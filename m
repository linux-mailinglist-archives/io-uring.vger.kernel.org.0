Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id A44124550E5
	for <lists+io-uring@lfdr.de>; Thu, 18 Nov 2021 00:03:36 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235956AbhKQXGd (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Wed, 17 Nov 2021 18:06:33 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:33406 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233161AbhKQXGb (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Wed, 17 Nov 2021 18:06:31 -0500
Received: from mail-wm1-x32a.google.com (mail-wm1-x32a.google.com [IPv6:2a00:1450:4864:20::32a])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 8B0AAC061570
        for <io-uring@vger.kernel.org>; Wed, 17 Nov 2021 15:03:32 -0800 (PST)
Received: by mail-wm1-x32a.google.com with SMTP id k37-20020a05600c1ca500b00330cb84834fso6081620wms.2
        for <io-uring@vger.kernel.org>; Wed, 17 Nov 2021 15:03:32 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=message-id:date:mime-version:user-agent:subject:content-language:to
         :cc:references:from:in-reply-to:content-transfer-encoding;
        bh=RbH4nt/zMpdnOGZW42uxcH/umJhFf3N0lr0A2DmaPg0=;
        b=of+JgHFSaa2zjdsi177G3kZOuTc8cBxkp3NEAtC4O/llge7THKZzHhzw8q4HB9Mj28
         HJ1yuRnLIsaCbVEErEtQJ12wFvW4jym3i5Qq6WyBQoBjE9S9P9bGmtnvPwLJF7mXTmgC
         0CEfg5U/MeQQsi8CLon0yRJhXhHUcD6H319AuyWcnp2G2XM6u9N40Dbpggu7JkXK2oUS
         IXAQt3ekX+wdyC707R8SGHpqRTFVEz9yowLrK5t55wKVt2ZGLQUb4v7dx77Srp30QvC+
         9/Aj3iZQ/28WYqEWtPSow5MbueBSCgXzSI8AXMhuImNccoUkqXmQdW5s5OoCUrjADxM2
         4cqQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:message-id:date:mime-version:user-agent:subject
         :content-language:to:cc:references:from:in-reply-to
         :content-transfer-encoding;
        bh=RbH4nt/zMpdnOGZW42uxcH/umJhFf3N0lr0A2DmaPg0=;
        b=76p+Xvwa8ONLqztNSSjyH+W+yOoq57zrDp6Ujfb2Io0kDlOerTRIRK/El6TW8hcSM2
         Ycf98FML8XQq2fiRUu3jMD+X5qjpF+cZVXraYqOSn/hvDh3hgPg33XOsmo0PaVpMzEEd
         TX8bSCHLqslqFcelLwaHnXqCEhrlQqcrXirkrcayDynhzgTcr04Cys4v/487hR7bthOC
         LbD0y6MI5bFZPSEkSTTgLZM/pP085O6Vzbwe1FrbjdLQ45NtPVp9sk2142rQQ2mKnOOF
         wKFvvivczBXooeXx8LGzYx+36ZIQz2aBZRFgXLJVQ5toRDylbJDTlolGAML7+ts78O5x
         YVkw==
X-Gm-Message-State: AOAM530d7Voe/sUROk8rhSSOxdanRHoBG5meSamPXMWtYKRbVp008xHI
        OyNv0l6bHNYxnuZnB4vrZpc=
X-Google-Smtp-Source: ABdhPJyOZOiAqy7b3AlY5nm6cYN+Aq/nBILkK/l87829QncvmDhmL99BdF//yO2svNJADbIdAk8/0Q==
X-Received: by 2002:a05:600c:2189:: with SMTP id e9mr4144377wme.35.1637190210800;
        Wed, 17 Nov 2021 15:03:30 -0800 (PST)
Received: from [192.168.8.198] ([148.252.133.228])
        by smtp.gmail.com with ESMTPSA id q8sm1112096wrx.71.2021.11.17.15.03.29
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Wed, 17 Nov 2021 15:03:30 -0800 (PST)
Message-ID: <1165f5f5-79f2-f3b6-b921-4f15be33c2e6@gmail.com>
Date:   Wed, 17 Nov 2021 23:03:32 +0000
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:91.0) Gecko/20100101
 Thunderbird/91.2.0
Subject: Re: [PATCH 2/6] io_uring: add a priority tw list for irq completion
 work
Content-Language: en-US
To:     Hao Xu <haoxu@linux.alibaba.com>, Jens Axboe <axboe@kernel.dk>
Cc:     io-uring@vger.kernel.org, Joseph Qi <joseph.qi@linux.alibaba.com>
References: <20211029122237.164312-1-haoxu@linux.alibaba.com>
 <20211029122237.164312-3-haoxu@linux.alibaba.com>
From:   Pavel Begunkov <asml.silence@gmail.com>
In-Reply-To: <20211029122237.164312-3-haoxu@linux.alibaba.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org

On 10/29/21 13:22, Hao Xu wrote:
> Now we have a lot of task_work users, some are just to complete a req
> and generate a cqe. Let's put the work to a new tw list which has a
> higher priority, so that it can be handled quickly and thus to reduce
> avg req latency and users can issue next round of sqes earlier.
> An explanatory case:
> 
> origin timeline:
>      submit_sqe-->irq-->add completion task_work
>      -->run heavy work0~n-->run completion task_work
> now timeline:
>      submit_sqe-->irq-->add completion task_work
>      -->run completion task_work-->run heavy work0~n
> 
> Limitation: this optimization is only for those that submission and
> reaping process are in different threads. Otherwise anyhow we have to
> submit new sqes after returning to userspace, then the order of TWs
> doesn't matter.
> 
> Tested this patch(and the following ones) by manually replace
> __io_queue_sqe() in io_queue_sqe() by io_req_task_queue() to construct
> 'heavy' task works. Then test with fio:
> 
> ioengine=io_uring
> sqpoll=1
> thread=1
> bs=4k
> direct=1
> rw=randread
> time_based=1
> runtime=600
> randrepeat=0
> group_reporting=1
> filename=/dev/nvme0n1
> 
> Tried various iodepth.
> The peak IOPS for this patch is 710K, while the old one is 665K.
> For avg latency, difference shows when iodepth grow:
> depth and avg latency(usec):
> 	depth      new          old
> 	 1        7.05         7.10
> 	 2        8.47         8.60
> 	 4        10.42        10.42
> 	 8        13.78        13.22
> 	 16       27.41        24.33
> 	 32       49.40        53.08
> 	 64       102.53       103.36
> 	 128      196.98       205.61
> 	 256      372.99       414.88
>           512      747.23       791.30
>           1024     1472.59      1538.72
>           2048     3153.49      3329.01
>           4096     6387.86      6682.54
>           8192     12150.25     12774.14
>           16384    23085.58     26044.71
> 
> Signed-off-by: Hao Xu <haoxu@linux.alibaba.com>
> ---
>   fs/io_uring.c | 38 +++++++++++++++++++++++++-------------
>   1 file changed, 25 insertions(+), 13 deletions(-)
> 
> diff --git a/fs/io_uring.c b/fs/io_uring.c
> index 17cb0e1b88f0..981794ee3f3f 100644
> --- a/fs/io_uring.c
> +++ b/fs/io_uring.c
> @@ -467,6 +467,7 @@ struct io_uring_task {
>   
>   	spinlock_t		task_lock;
>   	struct io_wq_work_list	task_list;
> +	struct io_wq_work_list	prior_task_list;
>   	struct callback_head	task_work;
>   	bool			task_running;
>   };
> @@ -2148,13 +2149,17 @@ static void tctx_task_work(struct callback_head *cb)
>   
>   	while (1) {
>   		struct io_wq_work_node *node;
> +		struct io_wq_work_list *merged_list;
>   
> -		if (!tctx->task_list.first && locked)
> +		if (!tctx->prior_task_list.first &&
> +		    !tctx->task_list.first && locked)
>   			io_submit_flush_completions(ctx);
>   
>   		spin_lock_irq(&tctx->task_lock);
> -		node = tctx->task_list.first;
> +		merged_list = wq_list_merge(&tctx->prior_task_list, &tctx->task_list);
> +		node = merged_list->first;
>   		INIT_WQ_LIST(&tctx->task_list);
> +		INIT_WQ_LIST(&tctx->prior_task_list);
>   		if (!node)
>   			tctx->task_running = false;
>   		spin_unlock_irq(&tctx->task_lock);
> @@ -2183,19 +2188,23 @@ static void tctx_task_work(struct callback_head *cb)
>   	ctx_flush_and_put(ctx, &locked);
>   }
>   
> -static void io_req_task_work_add(struct io_kiocb *req)
> +static void io_req_task_work_add(struct io_kiocb *req, bool priority)
>   {
>   	struct task_struct *tsk = req->task;
>   	struct io_uring_task *tctx = tsk->io_uring;
>   	enum task_work_notify_mode notify;
>   	struct io_wq_work_node *node;
> +	struct io_wq_work_list *merged_list;
>   	unsigned long flags;
>   	bool running;
>   
>   	WARN_ON_ONCE(!tctx);
>   
>   	spin_lock_irqsave(&tctx->task_lock, flags);
> -	wq_list_add_tail(&req->io_task_work.node, &tctx->task_list);
> +	if (priority)
> +		wq_list_add_tail(&req->io_task_work.node, &tctx->prior_task_list);
> +	else
> +		wq_list_add_tail(&req->io_task_work.node, &tctx->task_list);
>   	running = tctx->task_running;
>   	if (!running)
>   		tctx->task_running = true;
> @@ -2220,8 +2229,10 @@ static void io_req_task_work_add(struct io_kiocb *req)
>   
>   	spin_lock_irqsave(&tctx->task_lock, flags);
>   	tctx->task_running = false;
> -	node = tctx->task_list.first;
> +	merged_list = wq_list_merge(&tctx->prior_task_list, &tctx->task_list);
> +	node = merged_list->first;
>   	INIT_WQ_LIST(&tctx->task_list);
> +	INIT_WQ_LIST(&tctx->prior_task_list);
>   	spin_unlock_irqrestore(&tctx->task_lock, flags);
>   
>   	while (node) {
> @@ -2258,19 +2269,19 @@ static void io_req_task_queue_fail(struct io_kiocb *req, int ret)
>   {
>   	req->result = ret;
>   	req->io_task_work.func = io_req_task_cancel;
> -	io_req_task_work_add(req);
> +	io_req_task_work_add(req, false);
>   }
>   
>   static void io_req_task_queue(struct io_kiocb *req)
>   {
>   	req->io_task_work.func = io_req_task_submit;
> -	io_req_task_work_add(req);
> +	io_req_task_work_add(req, false);
>   }
>   
>   static void io_req_task_queue_reissue(struct io_kiocb *req)
>   {
>   	req->io_task_work.func = io_queue_async_work;
> -	io_req_task_work_add(req);
> +	io_req_task_work_add(req, false);
>   }
>   
>   static inline void io_queue_next(struct io_kiocb *req)
> @@ -2375,7 +2386,7 @@ static inline void io_put_req_deferred(struct io_kiocb *req)
>   {
>   	if (req_ref_put_and_test(req)) {
>   		req->io_task_work.func = io_free_req_work;
> -		io_req_task_work_add(req);
> +		io_req_task_work_add(req, false);
>   	}
>   }
>   
> @@ -2678,7 +2689,7 @@ static void io_complete_rw(struct kiocb *kiocb, long res, long res2)
>   		return;
>   	req->result = res;
>   	req->io_task_work.func = io_req_task_complete;
> -	io_req_task_work_add(req);
> +	io_req_task_work_add(req, !!(req->ctx->flags & IORING_SETUP_SQPOLL));

I'm not sure this special case makes sense. I remembered you mentioned
that you measured it, but what's the reason? Can it be related to my
comments on 6/6?

>   }
>   
>   static void io_complete_rw_iopoll(struct kiocb *kiocb, long res, long res2)
> @@ -5243,7 +5254,7 @@ static inline int __io_async_wake(struct io_kiocb *req, struct io_poll_iocb *pol
>   	 * of executing it. We can't safely execute it anyway, as we may not
>   	 * have the needed state needed for it anyway.
>   	 */
> -	io_req_task_work_add(req);
> +	io_req_task_work_add(req, false);
>   	return 1;
>   }
>   
> @@ -5923,7 +5934,7 @@ static enum hrtimer_restart io_timeout_fn(struct hrtimer *timer)
>   	spin_unlock_irqrestore(&ctx->timeout_lock, flags);
>   
>   	req->io_task_work.func = io_req_task_timeout;
> -	io_req_task_work_add(req);
> +	io_req_task_work_add(req, false);
>   	return HRTIMER_NORESTART;
>   }
>   
> @@ -6889,7 +6900,7 @@ static enum hrtimer_restart io_link_timeout_fn(struct hrtimer *timer)
>   	spin_unlock_irqrestore(&ctx->timeout_lock, flags);
>   
>   	req->io_task_work.func = io_req_task_link_timeout;
> -	io_req_task_work_add(req);
> +	io_req_task_work_add(req, false);
>   	return HRTIMER_NORESTART;
>   }
>   
> @@ -8593,6 +8604,7 @@ static __cold int io_uring_alloc_task_context(struct task_struct *task,
>   	task->io_uring = tctx;
>   	spin_lock_init(&tctx->task_lock);
>   	INIT_WQ_LIST(&tctx->task_list);
> +	INIT_WQ_LIST(&tctx->prior_task_list);
>   	init_task_work(&tctx->task_work, tctx_task_work);
>   	return 0;
>   }
> 

-- 
Pavel Begunkov
