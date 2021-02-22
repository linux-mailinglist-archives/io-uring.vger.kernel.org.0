Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 30FE3321967
	for <lists+io-uring@lfdr.de>; Mon, 22 Feb 2021 14:52:31 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231765AbhBVNvr (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Mon, 22 Feb 2021 08:51:47 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:50518 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231370AbhBVNux (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Mon, 22 Feb 2021 08:50:53 -0500
Received: from mail-wm1-x32d.google.com (mail-wm1-x32d.google.com [IPv6:2a00:1450:4864:20::32d])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 90FFDC061574
        for <io-uring@vger.kernel.org>; Mon, 22 Feb 2021 05:50:10 -0800 (PST)
Received: by mail-wm1-x32d.google.com with SMTP id a132so13654934wmc.0
        for <io-uring@vger.kernel.org>; Mon, 22 Feb 2021 05:50:10 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=subject:to:cc:references:from:autocrypt:message-id:date:user-agent
         :mime-version:in-reply-to:content-language:content-transfer-encoding;
        bh=2eE25vzWU3jvb9kNNzciAh0zyscKly6ZyjtiAzdmaTE=;
        b=FUXzen1fsU5C+sNP6V4oZigCj92AU429OOIk28DjPFk5XeCtuhn08+sXUpKYSMY/zM
         is4R1X3rf+VROZ2NkKz4MjNUb9gBBcvf2jmdEiI4UUzTrXHJhAWdSqdZqVrZe+yFL7Q2
         hYZxUs8trxcohjTpM9Az/+dBFAcAc4njJj59cramDPT0E867DyDMDwESSh+AdiZ8f5YD
         eIM/Rs/fiDDp7RfbEgzZhzqcg33YpcN/omxowrdkoOABAf+N9Vyw1Q0mJTVTYLv1XgQw
         v2qb4BFzIRqZ7Iq4QrpJc6vZLgae53483gN4d4M2/Sdxwlti+6IwTrDMWyp5s87I2lJ3
         PGJg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:autocrypt
         :message-id:date:user-agent:mime-version:in-reply-to
         :content-language:content-transfer-encoding;
        bh=2eE25vzWU3jvb9kNNzciAh0zyscKly6ZyjtiAzdmaTE=;
        b=gJJlznQtNtRyPBwfIAeTiA0/4D1PBCRbdPCn2BQNiSRJqDTa5aYL7d1veKu8p+OeiI
         8UqltMTEmO2XntigMRJ8cr48JGTGUrsJKTvaFDOS3Ia08NIkgSnOIxXUJrSYYU7BwWjq
         +hBJYviiTCbXlNItOJsn4RUAsf7mH9SW8UgGncDs9X/Z16xuqk29vVT8UlSDaAV7iT0e
         Iyt0ZXcTiceLNMElgT/yC7YGZras3KDldudKQBg/LFhhjjR30Xm1IVyEqnEIpKzbjaqT
         hAGCNrZ7DZk8ttu6KsReMDiQg/bBTzXiX1G79BhAnP5E0iRdAROGDaENZ6iN1IYDUuWz
         IEcQ==
X-Gm-Message-State: AOAM532GuwhMLmlYpinisXkHJWP2w/i4KPtCBbVvTMyKgZCAND9AmY5E
        mlIjCTDELhWIseXxD/jnzF4=
X-Google-Smtp-Source: ABdhPJzV3wQarV/72aViHMyobdVyX9mdqhI+acimFfu9Fxm1C+g6exbTxbi+XkuzAWtB15IkplcNRg==
X-Received: by 2002:a1c:721a:: with SMTP id n26mr10490465wmc.181.1614001809350;
        Mon, 22 Feb 2021 05:50:09 -0800 (PST)
Received: from [192.168.8.146] ([148.252.132.56])
        by smtp.gmail.com with ESMTPSA id u7sm28274519wrt.67.2021.02.22.05.50.08
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Mon, 22 Feb 2021 05:50:08 -0800 (PST)
Subject: Re: [PATCH 01/18] io_uring: remove the need for relying on an io-wq
 fallback worker
To:     Jens Axboe <axboe@kernel.dk>, io-uring@vger.kernel.org
Cc:     ebiederm@xmission.com, viro@zeniv.linux.org.uk,
        torvalds@linux-foundation.org
References: <20210219171010.281878-1-axboe@kernel.dk>
 <20210219171010.281878-2-axboe@kernel.dk>
From:   Pavel Begunkov <asml.silence@gmail.com>
Autocrypt: addr=asml.silence@gmail.com; prefer-encrypt=mutual; keydata=
 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 bA==
Message-ID: <a237cb3c-c5a4-4344-f6da-f68475c57204@gmail.com>
Date:   Mon, 22 Feb 2021 13:46:19 +0000
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.3.0
MIME-Version: 1.0
In-Reply-To: <20210219171010.281878-2-axboe@kernel.dk>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org

On 19/02/2021 17:09, Jens Axboe wrote:
> We hit this case when the task is exiting, and we need somewhere to
> do background cleanup of requests. Instead of relying on the io-wq
> task manager to do this work for us, just stuff it somewhere where
> we can safely run it ourselves directly.
> 
> Signed-off-by: Jens Axboe <axboe@kernel.dk>
> ---
>  fs/io-wq.c    | 12 ------------
>  fs/io-wq.h    |  2 --
>  fs/io_uring.c | 38 +++++++++++++++++++++++++++++++++++---
>  3 files changed, 35 insertions(+), 17 deletions(-)
> 
> diff --git a/fs/io-wq.c b/fs/io-wq.c
> index c36bbcd823ce..800b299f9772 100644
> --- a/fs/io-wq.c
> +++ b/fs/io-wq.c
> @@ -16,7 +16,6 @@
>  #include <linux/kthread.h>
>  #include <linux/rculist_nulls.h>
>  #include <linux/fs_struct.h>
> -#include <linux/task_work.h>
>  #include <linux/blk-cgroup.h>
>  #include <linux/audit.h>
>  #include <linux/cpu.h>
> @@ -775,9 +774,6 @@ static int io_wq_manager(void *data)
>  	complete(&wq->done);
>  
>  	while (!kthread_should_stop()) {
> -		if (current->task_works)
> -			task_work_run();
> -
>  		for_each_node(node) {
>  			struct io_wqe *wqe = wq->wqes[node];
>  			bool fork_worker[2] = { false, false };
> @@ -800,9 +796,6 @@ static int io_wq_manager(void *data)
>  		schedule_timeout(HZ);
>  	}
>  
> -	if (current->task_works)
> -		task_work_run();
> -
>  out:
>  	if (refcount_dec_and_test(&wq->refs)) {
>  		complete(&wq->done);
> @@ -1160,11 +1153,6 @@ void io_wq_destroy(struct io_wq *wq)
>  		__io_wq_destroy(wq);
>  }
>  
> -struct task_struct *io_wq_get_task(struct io_wq *wq)
> -{
> -	return wq->manager;
> -}
> -
>  static bool io_wq_worker_affinity(struct io_worker *worker, void *data)
>  {
>  	struct task_struct *task = worker->task;
> diff --git a/fs/io-wq.h b/fs/io-wq.h
> index 096f1021018e..a1610702f222 100644
> --- a/fs/io-wq.h
> +++ b/fs/io-wq.h
> @@ -124,8 +124,6 @@ typedef bool (work_cancel_fn)(struct io_wq_work *, void *);
>  enum io_wq_cancel io_wq_cancel_cb(struct io_wq *wq, work_cancel_fn *cancel,
>  					void *data, bool cancel_all);
>  
> -struct task_struct *io_wq_get_task(struct io_wq *wq);
> -
>  #if defined(CONFIG_IO_WQ)
>  extern void io_wq_worker_sleeping(struct task_struct *);
>  extern void io_wq_worker_running(struct task_struct *);
> diff --git a/fs/io_uring.c b/fs/io_uring.c
> index d951acb95117..bbd1ec7aa9e9 100644
> --- a/fs/io_uring.c
> +++ b/fs/io_uring.c
> @@ -455,6 +455,9 @@ struct io_ring_ctx {
>  
>  	struct io_restriction		restrictions;
>  
> +	/* exit task_work */
> +	struct callback_head		*exit_task_work;
> +
>  	/* Keep this last, we don't need it for the fast path */
>  	struct work_struct		exit_work;
>  };
> @@ -2313,11 +2316,14 @@ static int io_req_task_work_add(struct io_kiocb *req)
>  static void io_req_task_work_add_fallback(struct io_kiocb *req,
>  					  task_work_func_t cb)
>  {
> -	struct task_struct *tsk = io_wq_get_task(req->ctx->io_wq);
> +	struct io_ring_ctx *ctx = req->ctx;
> +	struct callback_head *head;
>  
>  	init_task_work(&req->task_work, cb);
> -	task_work_add(tsk, &req->task_work, TWA_NONE);
> -	wake_up_process(tsk);
> +	do {
> +		head = ctx->exit_task_work;
> +		req->task_work.next = head;
> +	} while (cmpxchg(&ctx->exit_task_work, head, &req->task_work) != head);
>  }
>  
>  static void __io_req_task_cancel(struct io_kiocb *req, int error)
> @@ -9258,6 +9264,30 @@ void __io_uring_task_cancel(void)
>  	io_uring_remove_task_files(tctx);
>  }
>  
> +static void io_run_ctx_fallback(struct io_ring_ctx *ctx)
> +{
> +	struct callback_head *work, *head, *next;
> +
> +	do {
> +		do {
> +			head = NULL;
> +			work = READ_ONCE(ctx->exit_task_work);
> +			if (!work)
> +				break;
> +		} while (cmpxchg(&ctx->exit_task_work, work, head) != work);

Looking at io_uring-worker.v3, it's actually just xchg() without do-while.

work = xchg(&ctx->exit_task_work, NULL);

> +
> +		if (!work)
> +			break;
> +
> +		do {
> +			next = work->next;
> +			work->func(work);
> +			work = next;
> +			cond_resched();
> +		} while (work);
> +	} while (1);
> +}
> +
>  static int io_uring_flush(struct file *file, void *data)
>  {
>  	struct io_uring_task *tctx = current->io_uring;
> @@ -9268,6 +9298,8 @@ static int io_uring_flush(struct file *file, void *data)
>  		io_req_caches_free(ctx, current);
>  	}
>  
> +	io_run_ctx_fallback(ctx);
> +
>  	if (!tctx)
>  		return 0;
>  
> 

-- 
Pavel Begunkov
