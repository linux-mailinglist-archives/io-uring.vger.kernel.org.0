Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 7A2EE46DABB
	for <lists+io-uring@lfdr.de>; Wed,  8 Dec 2021 19:10:54 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S238607AbhLHSOZ (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Wed, 8 Dec 2021 13:14:25 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:37596 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231241AbhLHSOY (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Wed, 8 Dec 2021 13:14:24 -0500
Received: from mail-ed1-x529.google.com (mail-ed1-x529.google.com [IPv6:2a00:1450:4864:20::529])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id A411EC061746
        for <io-uring@vger.kernel.org>; Wed,  8 Dec 2021 10:10:52 -0800 (PST)
Received: by mail-ed1-x529.google.com with SMTP id z5so11295077edd.3
        for <io-uring@vger.kernel.org>; Wed, 08 Dec 2021 10:10:52 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=message-id:date:mime-version:user-agent:subject:content-language:to
         :cc:references:from:in-reply-to:content-transfer-encoding;
        bh=lD+sbyRC38Y49K3Rsis5HxKRyetQXqFnHMrVghylHkQ=;
        b=WHrvNYcLaZUqCiVCGSn/zm8YRGP5CVx/X2TZfkp15ABFtwc2kPKL38DSd+vFNtdnbl
         prdZZM83s9ebZoaq3vSIxagWtA8tJ5kU619HJVupFX4kcZNiTgHF5bkis4hWeVMMXl9w
         aGualaLqmljKsQ2sb/eLdwoWZk9KB9LAfj48d3T+v4m9FQ12xjJOs2RSme6avy58F/LE
         YbISCKf7TnWd1cNWqgcC8fmhYNHwLr7uR8f3M5Bti9I8ZEtcABxGbUHpXdNhnFyeWGUS
         66Dmc7fPPtDLnA+YLVEWbiJMdKstUC9Zp+eB2b0cj8SMy0VkedMqmVwt+BnTWen2qSoL
         zmYA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:message-id:date:mime-version:user-agent:subject
         :content-language:to:cc:references:from:in-reply-to
         :content-transfer-encoding;
        bh=lD+sbyRC38Y49K3Rsis5HxKRyetQXqFnHMrVghylHkQ=;
        b=oN40AbGcXlxLdYeY+rpMfqha6YEsZKOkE/FJgCKOE6G7kY8Ellwmj8VXQXa+0IX8eX
         n1Je+MMvSpJK463Be2bAvHDmKiNowda0KSEgHLvKiXpzE7x9eUK2VHpLPn2onjd+LVwI
         fopDa64aAaOCa8FzfD0KnpkX0CrLLldp9MbIhaJV0sAzYqqKYtKPnBGydUFfm5SSU4o4
         z5+v6pmFgVlfPOaKCP9R6ylfh1Kp/TuE+S61Hb80CGZH+2jSSSzb2DuqRv+eQ+PhJX5A
         xMRNh8cXYdlZzHY5nlSou1+lgwGC8q7/fBqe9iEzVOOoxN4RvY7HSelYk8s0aWLbFu4X
         ZLdA==
X-Gm-Message-State: AOAM5305hPueyVYpflLJ+BP9qKJPaabGLowkY25Ua9HRlO7I0PggK9dV
        z989AKoJ/UD9sN9jqRqke/KLbEPXV58=
X-Google-Smtp-Source: ABdhPJzZx8gSBEdxy/WacuFkK6msJW5cAFuOqfjSgiIJMzhXpkJArrrmbQJulAGFa1qbkdDt8b4wjg==
X-Received: by 2002:a50:e18e:: with SMTP id k14mr21661353edl.147.1638987051172;
        Wed, 08 Dec 2021 10:10:51 -0800 (PST)
Received: from [192.168.8.198] ([148.252.128.29])
        by smtp.gmail.com with ESMTPSA id r24sm2342145edv.18.2021.12.08.10.10.49
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Wed, 08 Dec 2021 10:10:50 -0800 (PST)
Message-ID: <342a6926-9d5d-bcc6-64dd-6e634294098a@gmail.com>
Date:   Wed, 8 Dec 2021 18:10:50 +0000
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:91.0) Gecko/20100101
 Thunderbird/91.3.2
Subject: Re: [PATCH v8] io_uring: batch completion in prior_task_list
Content-Language: en-US
To:     Hao Xu <haoxu@linux.alibaba.com>, Jens Axboe <axboe@kernel.dk>
Cc:     io-uring@vger.kernel.org, Joseph Qi <joseph.qi@linux.alibaba.com>
References: <20211208052125.351587-1-haoxu@linux.alibaba.com>
From:   Pavel Begunkov <asml.silence@gmail.com>
In-Reply-To: <20211208052125.351587-1-haoxu@linux.alibaba.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org

On 12/8/21 05:21, Hao Xu wrote:
> In previous patches, we have already gathered some tw with
> io_req_task_complete() as callback in prior_task_list, let's complete
> them in batch while we cannot grab uring lock. In this way, we batch
> the req_complete_post path.

Works fine now, don't see any problem

Reviewed-by: Pavel Begunkov <asml.silence@gmail.com>

> 
> Signed-off-by: Hao Xu <haoxu@linux.alibaba.com>
> ---
> 
> v4->v5
> - change the implementation of merge_wq_list
> 
> v5->v6
> - change the logic of handling prior task list to:
>    1) grabbed uring_lock: leverage the inline completion infra
>    2) otherwise: batch __req_complete_post() calls to save
>       completion_lock operations.
> 
> v6->v7
> - add Pavel's fix of wrong spin unlock
> - remove a patch and rebase work
> 
> v7->v8
> - the previous fix in v7 is incompleted, fix it.(Pavel's comment)
> - code clean(Jens' comment)
> 
>   fs/io_uring.c | 71 +++++++++++++++++++++++++++++++++++++++++++--------
>   1 file changed, 60 insertions(+), 11 deletions(-)
> 
> diff --git a/fs/io_uring.c b/fs/io_uring.c
> index 21738ed7521e..92dc33519466 100644
> --- a/fs/io_uring.c
> +++ b/fs/io_uring.c
> @@ -2225,7 +2225,49 @@ static void ctx_flush_and_put(struct io_ring_ctx *ctx, bool *locked)
>   	percpu_ref_put(&ctx->refs);
>   }
>   
> -static void handle_tw_list(struct io_wq_work_node *node, struct io_ring_ctx **ctx, bool *locked)
> +static inline void ctx_commit_and_unlock(struct io_ring_ctx *ctx)
> +{
> +	io_commit_cqring(ctx);
> +	spin_unlock(&ctx->completion_lock);
> +	io_cqring_ev_posted(ctx);
> +}
> +
> +static void handle_prev_tw_list(struct io_wq_work_node *node,
> +				struct io_ring_ctx **ctx, bool *uring_locked)
> +{
> +	if (*ctx && !*uring_locked)
> +		spin_lock(&(*ctx)->completion_lock);
> +
> +	do {
> +		struct io_wq_work_node *next = node->next;
> +		struct io_kiocb *req = container_of(node, struct io_kiocb,
> +						    io_task_work.node);
> +
> +		if (req->ctx != *ctx) {
> +			if (unlikely(!*uring_locked && *ctx))
> +				ctx_commit_and_unlock(*ctx);
> +
> +			ctx_flush_and_put(*ctx, uring_locked);
> +			*ctx = req->ctx;
> +			/* if not contended, grab and improve batching */
> +			*uring_locked = mutex_trylock(&(*ctx)->uring_lock);
> +			percpu_ref_get(&(*ctx)->refs);
> +			if (unlikely(!*uring_locked))
> +				spin_lock(&(*ctx)->completion_lock);
> +		}
> +		if (likely(*uring_locked))
> +			req->io_task_work.func(req, uring_locked);
> +		else
> +			__io_req_complete_post(req, req->result, io_put_kbuf(req));
> +		node = next;
> +	} while (node);
> +
> +	if (unlikely(!*uring_locked))
> +		ctx_commit_and_unlock(*ctx);
> +}
> +
> +static void handle_tw_list(struct io_wq_work_node *node,
> +			   struct io_ring_ctx **ctx, bool *locked)
>   {
>   	do {
>   		struct io_wq_work_node *next = node->next;
> @@ -2246,31 +2288,38 @@ static void handle_tw_list(struct io_wq_work_node *node, struct io_ring_ctx **ct
>   
>   static void tctx_task_work(struct callback_head *cb)
>   {
> -	bool locked = false;
> +	bool uring_locked = false;
>   	struct io_ring_ctx *ctx = NULL;
>   	struct io_uring_task *tctx = container_of(cb, struct io_uring_task,
>   						  task_work);
>   
>   	while (1) {
> -		struct io_wq_work_node *node;
> +		struct io_wq_work_node *node1, *node2;
>   
> -		if (!tctx->prior_task_list.first &&
> -		    !tctx->task_list.first && locked)
> +		if (!tctx->task_list.first &&
> +		    !tctx->prior_task_list.first && uring_locked)
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
> +			handle_prev_tw_list(node1, &ctx, &uring_locked);
> +
> +		if (node2)
> +			handle_tw_list(node2, &ctx, &uring_locked);
>   		cond_resched();
>   	}
>   
> -	ctx_flush_and_put(ctx, &locked);
> +	ctx_flush_and_put(ctx, &uring_locked);
>   }
>   
>   static void io_req_task_work_add(struct io_kiocb *req, bool priority)
> @@ -2759,7 +2808,7 @@ static void io_complete_rw(struct kiocb *kiocb, long res)
>   		return;
>   	req->result = res;
>   	req->io_task_work.func = io_req_task_complete;
> -	io_req_task_work_add(req, true);
> +	io_req_task_work_add(req, !!(req->ctx->flags & IORING_SETUP_SQPOLL));
>   }
>   
>   static void io_complete_rw_iopoll(struct kiocb *kiocb, long res)
> 

-- 
Pavel Begunkov
