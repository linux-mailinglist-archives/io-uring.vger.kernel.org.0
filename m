Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 7FEB54368C6
	for <lists+io-uring@lfdr.de>; Thu, 21 Oct 2021 19:10:08 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231891AbhJURMW (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Thu, 21 Oct 2021 13:12:22 -0400
Received: from out30-44.freemail.mail.aliyun.com ([115.124.30.44]:44581 "EHLO
        out30-44.freemail.mail.aliyun.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S230456AbhJURMW (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Thu, 21 Oct 2021 13:12:22 -0400
X-Alimail-AntiSpam: AC=PASS;BC=-1|-1;BR=01201311R521e4;CH=green;DM=||false|;DS=||;FP=0|-1|-1|-1|0|-1|-1|-1;HT=e01e04423;MF=haoxu@linux.alibaba.com;NM=1;PH=DS;RN=3;SR=0;TI=SMTPD_---0UtAXFUu_1634836204;
Received: from 192.168.31.215(mailfrom:haoxu@linux.alibaba.com fp:SMTPD_---0UtAXFUu_1634836204)
          by smtp.aliyun-inc.com(127.0.0.1);
          Fri, 22 Oct 2021 01:10:04 +0800
Subject: Re: [PATCH 5.15] io_uring: apply worker limits to previous users
To:     Pavel Begunkov <asml.silence@gmail.com>, io-uring@vger.kernel.org
Cc:     Jens Axboe <axboe@kernel.dk>
References: <d6e09ecc3545e4dc56e43c906ee3d71b7ae21bed.1634818641.git.asml.silence@gmail.com>
From:   Hao Xu <haoxu@linux.alibaba.com>
Message-ID: <96676328-5de4-786d-3224-656808c8e157@linux.alibaba.com>
Date:   Fri, 22 Oct 2021 01:10:03 +0800
User-Agent: Mozilla/5.0 (Macintosh; Intel Mac OS X 10.15; rv:78.0)
 Gecko/20100101 Thunderbird/78.13.0
MIME-Version: 1.0
In-Reply-To: <d6e09ecc3545e4dc56e43c906ee3d71b7ae21bed.1634818641.git.asml.silence@gmail.com>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org

在 2021/10/21 下午8:20, Pavel Begunkov 写道:
> Another change to the API io-wq worker limitation API added in 5.15,
> apply the limit to all prior users that already registered a tctx. It
> may be confusing as it's now, in particular the change covers the
> following 2 cases:
> 
> TASK1                   | TASK2
> _________________________________________________
> ring = create()         |
>                          | limit_iowq_workers()
> *not limited*           |
> 
> TASK1                   | TASK2
> _________________________________________________
> ring = create()         |
>                          | issue_requests()
> limit_iowq_workers()    |
>                          | *not limited*
> 
> A note on locking, it's safe to traverse ->tctx_list as we hold
> ->uring_lock, but do that after dropping sqd->lock to avoid possible
> problems. It's also safe to access tctx->io_wq there because tasks
> kill it only after removing themselves from tctx_list, see
> io_uring_cancel_generic() -> io_uring_clean_tctx()
> 
> Signed-off-by: Pavel Begunkov <asml.silence@gmail.com>
> ---
>   fs/io_uring.c | 18 ++++++++++++++++++
>   1 file changed, 18 insertions(+)
> 
> diff --git a/fs/io_uring.c b/fs/io_uring.c
> index d5cc103224f1..bc18af5e0a93 100644
> --- a/fs/io_uring.c
> +++ b/fs/io_uring.c
> @@ -10649,7 +10649,9 @@ static int io_unregister_iowq_aff(struct io_ring_ctx *ctx)
>   
>   static int io_register_iowq_max_workers(struct io_ring_ctx *ctx,
>   					void __user *arg)
> +	__must_hold(&ctx->uring_lock)
>   {
> +	struct io_tctx_node *node;
>   	struct io_uring_task *tctx = NULL;
>   	struct io_sq_data *sqd = NULL;
>   	__u32 new_count[2];
> @@ -10702,6 +10704,22 @@ static int io_register_iowq_max_workers(struct io_ring_ctx *ctx,
>   	if (copy_to_user(arg, new_count, sizeof(new_count)))
>   		return -EFAULT;
>   
> +	/* that's it for SQPOLL, only the SQPOLL task creates requests */
> +	if (sqd)
> +		return 0;
> +
> +	/* now propagate the restriction to all registered users */
> +	list_for_each_entry(node, &ctx->tctx_list, ctx_node) {
> +		struct io_uring_task *tctx = node->task->io_uring;
> +
> +		if (WARN_ON_ONCE(!tctx->io_wq))
> +			continue;
> +
> +		for (i = 0; i < ARRAY_SIZE(new_count); i++)
> +			new_count[i] = ctx->iowq_limits[i];
> +		/* ignore errors, it always returns zero anyway */
> +		(void)io_wq_max_workers(tctx->io_wq, new_count);
> +	}
>   	return 0;
>   err:
>   	if (sqd) {
> 
Reviewed-by: Hao Xu <haoxu@linux.alibaba.com>

