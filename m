Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 94BFE45EE5C
	for <lists+io-uring@lfdr.de>; Fri, 26 Nov 2021 13:58:12 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1346277AbhKZNBX (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Fri, 26 Nov 2021 08:01:23 -0500
Received: from out30-42.freemail.mail.aliyun.com ([115.124.30.42]:42747 "EHLO
        out30-42.freemail.mail.aliyun.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1348915AbhKZM7V (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Fri, 26 Nov 2021 07:59:21 -0500
X-Alimail-AntiSpam: AC=PASS;BC=-1|-1;BR=01201311R961e4;CH=green;DM=||false|;DS=||;FP=0|-1|-1|-1|0|-1|-1|-1;HT=e01e04395;MF=haoxu@linux.alibaba.com;NM=1;PH=DS;RN=4;SR=0;TI=SMTPD_---0UyNc-gZ_1637931366;
Received: from B-25KNML85-0107.local(mailfrom:haoxu@linux.alibaba.com fp:SMTPD_---0UyNc-gZ_1637931366)
          by smtp.aliyun-inc.com(127.0.0.1);
          Fri, 26 Nov 2021 20:56:07 +0800
Subject: Re: [PATCH 6/6] io_uring: batch completion in prior_task_list
From:   Hao Xu <haoxu@linux.alibaba.com>
To:     Jens Axboe <axboe@kernel.dk>
Cc:     io-uring@vger.kernel.org, Pavel Begunkov <asml.silence@gmail.com>,
        Joseph Qi <joseph.qi@linux.alibaba.com>
References: <20211126100740.196550-1-haoxu@linux.alibaba.com>
 <20211126100740.196550-7-haoxu@linux.alibaba.com>
Message-ID: <b95424aa-ab59-be68-60fa-4e4c37e1b06b@linux.alibaba.com>
Date:   Fri, 26 Nov 2021 20:56:06 +0800
User-Agent: Mozilla/5.0 (Macintosh; Intel Mac OS X 10.15; rv:78.0)
 Gecko/20100101 Thunderbird/78.14.0
MIME-Version: 1.0
In-Reply-To: <20211126100740.196550-7-haoxu@linux.alibaba.com>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org

在 2021/11/26 下午6:07, Hao Xu 写道:
> In previous patches, we have already gathered some tw with
> io_req_task_complete() as callback in prior_task_list, let's complete
> them in batch while we cannot grab uring lock. In this way, we batch
> the req_complete_post path.
> 
> Signed-off-by: Hao Xu <haoxu@linux.alibaba.com>
something is wrong with this one, will update it and resend later..
> ---
>   fs/io_uring.c | 58 ++++++++++++++++++++++++++++++++++++++++++++-------
>   1 file changed, 51 insertions(+), 7 deletions(-)
> 
> diff --git a/fs/io_uring.c b/fs/io_uring.c
> index e9c67f19d585..b474340c5ea5 100644
> --- a/fs/io_uring.c
> +++ b/fs/io_uring.c
> @@ -2223,6 +2223,43 @@ static inline unsigned int io_put_rw_kbuf(struct io_kiocb *req)
>   	return io_put_kbuf(req, req->kbuf);
>   }
>   
> +static inline void ctx_commit_and_unlock(struct io_ring_ctx *ctx)
> +{
> +	io_commit_cqring(ctx);
> +	spin_unlock(&ctx->completion_lock);
> +	io_cqring_ev_posted(ctx);
> +}
> +
> +static void handle_prior_tw_list(struct io_wq_work_node *node, struct io_ring_ctx **ctx,
> +				 bool *locked)
> +{
> +	do {
> +		struct io_wq_work_node *next = node->next;
> +		struct io_kiocb *req = container_of(node, struct io_kiocb,
> +						    io_task_work.node);
> +
> +		if (req->ctx != *ctx) {
> +			if (unlikely(!*locked) && *ctx)
> +				ctx_commit_and_unlock(*ctx);
> +			ctx_flush_and_put(*ctx, locked);
> +			*ctx = req->ctx;
> +			/* if not contended, grab and improve batching */
> +			*locked = mutex_trylock(&(*ctx)->uring_lock);
> +			percpu_ref_get(&(*ctx)->refs);
> +			if (unlikely(*locked))
> +				spin_lock(&(*ctx)->completion_lock);
> +		}
> +		if (likely(*locked))
> +			req->io_task_work.func(req, locked);
> +		else
> +			__io_req_complete_post(req, req->result, io_put_rw_kbuf(req));
> +		node = next;
> +	} while (node);
> +
> +	if (unlikely(!*locked) && *ctx)
> +		ctx_commit_and_unlock(*ctx);
> +}
> +
>   static void handle_tw_list(struct io_wq_work_node *node, struct io_ring_ctx **ctx, bool *locked)
>   {
>   	do {
> @@ -2250,21 +2287,28 @@ static void tctx_task_work(struct callback_head *cb)
>   						  task_work);
>   
>   	while (1) {
> -		struct io_wq_work_node *node;
> +		struct io_wq_work_node *node1, *node2;
>   
> -		if (!tctx->prior_task_list.first &&
> -		    !tctx->task_list.first && locked)
> +		if (!tctx->task_list.first &&
> +		    !tctx->prior_task_list.first && locked)
>   			io_submit_flush_completions(ctx);
>   
>   		spin_lock_irq(&tctx->task_lock);
> -		node= wq_list_merge(&tctx->prior_task_list, &tctx->task_list);
> -		if (!node)
> +		node1 = tctx->prior_task_list.first;
> +		node2 = tctx->task_list.first;
> +		INIT_WQ_LIST(&tctx->task_list);
> +		INIT_WQ_LIST(&tctx->prior_task_list);
> +		if (!node2 && !node1)
>   			tctx->task_running = false;
>   		spin_unlock_irq(&tctx->task_lock);
> -		if (!node)
> +		if (!node2 && !node1)
>   			break;
>   
> -		handle_tw_list(node, &ctx, &locked);
> +		if (node1)
> +			handle_prior_tw_list(node1, &ctx, &locked);
> +
> +		if (node2)
> +			handle_tw_list(node2, &ctx, &locked);
>   		cond_resched();
>   	}
>   
> 

