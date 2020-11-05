Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 2FDD02A7608
	for <lists+io-uring@lfdr.de>; Thu,  5 Nov 2020 04:21:40 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730673AbgKEDVj (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Wed, 4 Nov 2020 22:21:39 -0500
Received: from out30-130.freemail.mail.aliyun.com ([115.124.30.130]:44258 "EHLO
        out30-130.freemail.mail.aliyun.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1728511AbgKEDVj (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Wed, 4 Nov 2020 22:21:39 -0500
X-Alimail-AntiSpam: AC=PASS;BC=-1|-1;BR=01201311R181e4;CH=green;DM=||false|;DS=||;FP=0|-1|-1|-1|0|-1|-1|-1;HT=e01e04407;MF=xiaoguang.wang@linux.alibaba.com;NM=1;PH=DS;RN=3;SR=0;TI=SMTPD_---0UEHCIRW_1604546495;
Received: from 30.225.32.219(mailfrom:xiaoguang.wang@linux.alibaba.com fp:SMTPD_---0UEHCIRW_1604546495)
          by smtp.aliyun-inc.com(127.0.0.1);
          Thu, 05 Nov 2020 11:21:35 +0800
Subject: Re: [PATCH] io_uring: don't take percpu_ref operations for registered
 files in IOPOLL mode
To:     io-uring@vger.kernel.org
Cc:     axboe@kernel.dk, joseph.qi@linux.alibaba.com
References: <20200902050538.8350-1-xiaoguang.wang@linux.alibaba.com>
From:   Xiaoguang Wang <xiaoguang.wang@linux.alibaba.com>
Message-ID: <2eb73693-9c40-d657-b822-548ddd92b875@linux.alibaba.com>
Date:   Thu, 5 Nov 2020 11:20:26 +0800
User-Agent: Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:78.0) Gecko/20100101
 Thunderbird/78.4.0
MIME-Version: 1.0
In-Reply-To: <20200902050538.8350-1-xiaoguang.wang@linux.alibaba.com>
Content-Type: text/plain; charset=gbk; format=flowed
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org

hi,

> In io_file_get() and io_put_file(), currently we use percpu_ref_get() and
> percpu_ref_put() for registered files, but it's hard to say they're very
> light-weight synchronization primitives, especially in arm platform. In one
> our arm machine, I get below perf data(registered files enabled):
> Samples: 98K of event 'cycles:ppp', Event count (approx.): 63789396810
> Overhead  Command      Shared Object     Symbol
>     ...
>     0.78%  io_uring-sq  [kernel.vmlinux]  [k] io_file_get
> There is an obvious overhead that can not be ignored.
> 
> Currently I don't find any good and generic solution for this issue, but
> in IOPOLL mode, given that we can always ensure get/put registered files
> under uring_lock, we can use a simple and plain u64 counter to synchronize
> with registered files update operations in __io_sqe_files_update().
> 
> With this patch, perf data show shows:
> Samples: 104K of event 'cycles:ppp', Event count (approx.): 67478249890
> Overhead  Command      Shared Object     Symbol
>     ...
>     0.27%  io_uring-sq  [kernel.vmlinux]  [k] io_file_get
The above %0.78 => %0.27 improvements are observed in arm machine with 4.19 kernel.
In upstream mainline codes, since this patch "2b0d3d3e4fcf percpu_ref: reduce memory
footprint of percpu_ref in fast path", I believe the io_file_get's overhead would
be further smaller. I have same tests in same machine, in upstream codes with my patch,
now the io_file_get's overhead is %0.44.

This patch's idea is simple, and now seems it only gives minor performance improvement,
do you have any comments about this patch, should I continue re-send it?

Regards,
Xiaoguang Wang

> 
> Signed-off-by: Xiaoguang Wang <xiaoguang.wang@linux.alibaba.com>
> ---
>   fs/io_uring.c | 58 ++++++++++++++++++++++++++++++++++++++++++++-------
>   1 file changed, 50 insertions(+), 8 deletions(-)
> 
> diff --git a/fs/io_uring.c b/fs/io_uring.c
> index ce69bd9b0838..186072861af9 100644
> --- a/fs/io_uring.c
> +++ b/fs/io_uring.c
> @@ -195,6 +195,11 @@ struct fixed_file_table {
>   
>   struct fixed_file_ref_node {
>   	struct percpu_ref		refs;
> +	/*
> +	 * Track the number of reqs that reference this node, currently it's
> +	 * only used in IOPOLL mode.
> +	 */
> +	u64				count;
>   	struct list_head		node;
>   	struct list_head		file_list;
>   	struct fixed_file_data		*file_data;
> @@ -651,7 +656,10 @@ struct io_kiocb {
>   	 */
>   	struct list_head		inflight_entry;
>   
> -	struct percpu_ref		*fixed_file_refs;
> +	union {
> +		struct percpu_ref		*fixed_file_refs;
> +		struct fixed_file_ref_node	*fixed_file_ref_node;
> +	};
>   	struct callback_head		task_work;
>   	/* for polled requests, i.e. IORING_OP_POLL_ADD and async armed poll */
>   	struct hlist_node		hash_node;
> @@ -1544,9 +1552,20 @@ static struct io_kiocb *io_alloc_req(struct io_ring_ctx *ctx,
>   static inline void io_put_file(struct io_kiocb *req, struct file *file,
>   			  bool fixed)
>   {
> -	if (fixed)
> -		percpu_ref_put(req->fixed_file_refs);
> -	else
> +	struct io_ring_ctx *ctx = req->ctx;
> +
> +	if (fixed) {
> +		/* See same comments in io_sqe_files_unregister(). */
> +		if (ctx->flags & IORING_SETUP_IOPOLL) {
> +			struct fixed_file_ref_node *ref_node = req->fixed_file_ref_node;
> +			struct percpu_ref *refs = &ref_node->refs;
> +
> +			ref_node->count--;
> +			if ((ctx->file_data->cur_refs != refs) && !ref_node->count)
> +				percpu_ref_kill(refs);
> +		} else
> +			percpu_ref_put(req->fixed_file_refs);
> +	} else
>   		fput(file);
>   }
>   
> @@ -5967,8 +5986,21 @@ static int io_file_get(struct io_submit_state *state, struct io_kiocb *req,
>   		fd = array_index_nospec(fd, ctx->nr_user_files);
>   		file = io_file_from_index(ctx, fd);
>   		if (file) {
> -			req->fixed_file_refs = ctx->file_data->cur_refs;
> -			percpu_ref_get(req->fixed_file_refs);
> +			struct percpu_ref *refs = ctx->file_data->cur_refs;
> +
> +			/*
> +			 * In IOPOLL mode, we can always ensure get/put registered files under
> +			 * uring_lock, so we can use a simple and plain u64 counter to synchronize
> +			 * with registered files update operations in __io_sqe_files_update.
> +			 */
> +			if (ctx->flags & IORING_SETUP_IOPOLL) {
> +				req->fixed_file_ref_node = container_of(refs,
> +						struct fixed_file_ref_node, refs);
> +				req->fixed_file_ref_node->count++;
> +			} else {
> +				req->fixed_file_refs = refs;
> +				percpu_ref_get(refs);
> +			}
>   		}
>   	} else {
>   		trace_io_uring_file_get(ctx, fd);
> @@ -6781,7 +6813,12 @@ static int io_sqe_files_unregister(struct io_ring_ctx *ctx)
>   		ref_node = list_first_entry(&data->ref_list,
>   				struct fixed_file_ref_node, node);
>   	spin_unlock(&data->lock);
> -	if (ref_node)
> +	/*
> +	 * If count is not zero, that means we're in IOPOLL mode, and there are
> +	 * still reqs that reference this ref_node, let the final req do the
> +	 * percpu_ref_kill job.
> +	 */
> +	if (ref_node && !ref_node->count)
>   		percpu_ref_kill(&ref_node->refs);
>   
>   	percpu_ref_kill(&data->refs);
> @@ -7363,7 +7400,12 @@ static int __io_sqe_files_update(struct io_ring_ctx *ctx,
>   	}
>   
>   	if (needs_switch) {
> -		percpu_ref_kill(data->cur_refs);
> +		struct fixed_file_ref_node *old_ref_node = container_of(data->cur_refs,
> +				struct fixed_file_ref_node, refs);
> +
> +		/* See same comments in io_sqe_files_unregister(). */
> +		if (!old_ref_node->count)
> +			percpu_ref_kill(data->cur_refs);
>   		spin_lock(&data->lock);
>   		list_add(&ref_node->node, &data->ref_list);
>   		data->cur_refs = &ref_node->refs;
> 
