Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 5148641860E
	for <lists+io-uring@lfdr.de>; Sun, 26 Sep 2021 05:36:23 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230371AbhIZDh5 (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Sat, 25 Sep 2021 23:37:57 -0400
Received: from out30-45.freemail.mail.aliyun.com ([115.124.30.45]:54908 "EHLO
        out30-45.freemail.mail.aliyun.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S230373AbhIZDh5 (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Sat, 25 Sep 2021 23:37:57 -0400
X-Alimail-AntiSpam: AC=PASS;BC=-1|-1;BR=01201311R891e4;CH=green;DM=||false|;DS=||;FP=0|-1|-1|-1|0|-1|-1|-1;HT=e01e04394;MF=haoxu@linux.alibaba.com;NM=1;PH=DS;RN=3;SR=0;TI=SMTPD_---0UpaJY70_1632627379;
Received: from B-25KNML85-0107.local(mailfrom:haoxu@linux.alibaba.com fp:SMTPD_---0UpaJY70_1632627379)
          by smtp.aliyun-inc.com(127.0.0.1);
          Sun, 26 Sep 2021 11:36:20 +0800
Subject: Re: [PATCH v2 10/24] io_uring: add a helper for batch free
To:     Pavel Begunkov <asml.silence@gmail.com>,
        Jens Axboe <axboe@kernel.dk>, io-uring@vger.kernel.org
References: <cover.1632516769.git.asml.silence@gmail.com>
 <4fc8306b542c6b1dd1d08e8021ef3bdb0ad15010.1632516769.git.asml.silence@gmail.com>
From:   Hao Xu <haoxu@linux.alibaba.com>
Message-ID: <1522b987-b614-7255-8336-7dbdf6f785fa@linux.alibaba.com>
Date:   Sun, 26 Sep 2021 11:36:19 +0800
User-Agent: Mozilla/5.0 (Macintosh; Intel Mac OS X 10.15; rv:78.0)
 Gecko/20100101 Thunderbird/78.13.0
MIME-Version: 1.0
In-Reply-To: <4fc8306b542c6b1dd1d08e8021ef3bdb0ad15010.1632516769.git.asml.silence@gmail.com>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org

在 2021/9/25 上午4:59, Pavel Begunkov 写道:
> Add a helper io_free_batch_list(), which takes a single linked list and
> puts/frees all requests from it in an efficient manner. Will be reused
> later.
> 
> Signed-off-by: Pavel Begunkov <asml.silence@gmail.com>
> ---
>   fs/io_uring.c | 34 +++++++++++++++++++++-------------
>   1 file changed, 21 insertions(+), 13 deletions(-)
> 
> diff --git a/fs/io_uring.c b/fs/io_uring.c
> index 205127394649..ad8af05af4bc 100644
> --- a/fs/io_uring.c
> +++ b/fs/io_uring.c
> @@ -2308,12 +2308,31 @@ static void io_req_free_batch(struct req_batch *rb, struct io_kiocb *req,
>   	wq_stack_add_head(&req->comp_list, &state->free_list);
>   }
>   
> +static void io_free_batch_list(struct io_ring_ctx *ctx,
> +			       struct io_wq_work_list *list)
> +	__must_hold(&ctx->uring_lock)
> +{
> +	struct io_wq_work_node *node;
> +	struct req_batch rb;
> +
> +	io_init_req_batch(&rb);
> +	node = list->first;
> +	do {
> +		struct io_kiocb *req = container_of(node, struct io_kiocb,
> +						    comp_list);
> +
> +		node = req->comp_list.next;
> +		if (req_ref_put_and_test(req))
> +			io_req_free_batch(&rb, req, &ctx->submit_state);
> +	} while (node);
> +	io_req_free_batch_finish(ctx, &rb);
> +}
Hi Pavel, Why not we use the wq_list_for_each here as well?
> +
>   static void __io_submit_flush_completions(struct io_ring_ctx *ctx)
>   	__must_hold(&ctx->uring_lock)
>   {
>   	struct io_wq_work_node *node, *prev;
>   	struct io_submit_state *state = &ctx->submit_state;
> -	struct req_batch rb;
>   
>   	spin_lock(&ctx->completion_lock);
>   	wq_list_for_each(node, prev, &state->compl_reqs) {
> @@ -2327,18 +2346,7 @@ static void __io_submit_flush_completions(struct io_ring_ctx *ctx)
>   	spin_unlock(&ctx->completion_lock);
>   	io_cqring_ev_posted(ctx);
>   
> -	io_init_req_batch(&rb);
> -	node = state->compl_reqs.first;
> -	do {
> -		struct io_kiocb *req = container_of(node, struct io_kiocb,
> -						    comp_list);
> -
> -		node = req->comp_list.next;
> -		if (req_ref_put_and_test(req))
> -			io_req_free_batch(&rb, req, &ctx->submit_state);
> -	} while (node);
> -
> -	io_req_free_batch_finish(ctx, &rb);
> +	io_free_batch_list(ctx, &state->compl_reqs);
>   	INIT_WQ_LIST(&state->compl_reqs);
>   }
>   
> 

