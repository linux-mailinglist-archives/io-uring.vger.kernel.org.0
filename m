Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id D68DE78F6D3
	for <lists+io-uring@lfdr.de>; Fri,  1 Sep 2023 03:50:10 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234984AbjIABuL (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Thu, 31 Aug 2023 21:50:11 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:56862 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230061AbjIABuK (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Thu, 31 Aug 2023 21:50:10 -0400
Received: from mail-pj1-x102b.google.com (mail-pj1-x102b.google.com [IPv6:2607:f8b0:4864:20::102b])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id ADF48E6E
        for <io-uring@vger.kernel.org>; Thu, 31 Aug 2023 18:50:07 -0700 (PDT)
Received: by mail-pj1-x102b.google.com with SMTP id 98e67ed59e1d1-26d50a832a9so1070012a91.3
        for <io-uring@vger.kernel.org>; Thu, 31 Aug 2023 18:50:07 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=bytedance.com; s=google; t=1693533007; x=1694137807; darn=vger.kernel.org;
        h=content-transfer-encoding:in-reply-to:from:references:cc:to
         :content-language:subject:user-agent:mime-version:date:message-id
         :from:to:cc:subject:date:message-id:reply-to;
        bh=8UYX/rV54NTNhfJ7ISy6QcWzS2KoV/Pg1bDdPX1eCsw=;
        b=gcNTYwDSiTZlzmPGF82VMzlaEcqVROV34tT/1diEai7Pc0gMW5knzyF3OcagHaJG/2
         9bkXuty6KRTR2uQ0R9xpPMJpCV4uWTht0+iJKuno9X1nHBSMhhWGZR077Ho7w/iueMyy
         UmmUqvSRETQnlnDhk26zLpkljLuUHO/HCC1cjJSce9EpA9uX9uCWldDB+phDwT7Bc2mc
         ZH2PX9/ZpQ0SHUY5cZWJET6FvbewEqQwwjalQnHGDKPd2xne2DZe8KyQhqJHM7sSTgU3
         Q5knRXfKQSXfEYcHHVE9n5z++FhrQCZBi0I6oYQj6iMynBeY0ausiE1z1PDd8wIU50DD
         Fixw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20221208; t=1693533007; x=1694137807;
        h=content-transfer-encoding:in-reply-to:from:references:cc:to
         :content-language:subject:user-agent:mime-version:date:message-id
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=8UYX/rV54NTNhfJ7ISy6QcWzS2KoV/Pg1bDdPX1eCsw=;
        b=cTCa7Yig0bj94cmLYYsCNnnfj6uggkzKFWTOLeCiNpgkMXBP/n6SVo6DOkXL2ccEg2
         2KennGozMlKds70mSjLFOMBfxwoH+khxL9tM+s/s+5KWX2L8Oej0uMnAqNiBwnl8nf0J
         3WrE3orFQpw8/Iv+NAuRHncKgNyzcD6U5+qOptH/6/EUxiLYMpfYy569hyJgfJuyAZvf
         vGBNcAtSTDNMjqT+7ngh6h8ff7Iy3aLeFmhd7AAEGztwIkrclYSmtub3/CYoNaYu3PR/
         zTFwwl47/jTz8XuSQ8diUpMMFcQ2+a+Qp/td+n+5TYjilqQddbwdElJu7XrJHgwb6RFR
         bheg==
X-Gm-Message-State: AOJu0Yxjf9Mm4os9ESPhfrOsWpM2OArF7itpwDwXr6BxK4AnTI+YZSX1
        H9oWr3R7guEMYQHZ8bvR/exSOw==
X-Google-Smtp-Source: AGHT+IElCrE30MKp3wAErGkQ77jWKU29G37KiPz80q3RV29NKfH3oUb+F6dEMEDu8a+Ecg74eD0upg==
X-Received: by 2002:a17:90a:5184:b0:262:ecd9:ed09 with SMTP id u4-20020a17090a518400b00262ecd9ed09mr1019862pjh.33.1693533007154;
        Thu, 31 Aug 2023 18:50:07 -0700 (PDT)
Received: from [10.4.182.70] ([139.177.225.225])
        by smtp.gmail.com with ESMTPSA id 27-20020a17090a031b00b002680b2d2ab6sm3814232pje.19.2023.08.31.18.50.04
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Thu, 31 Aug 2023 18:50:06 -0700 (PDT)
Message-ID: <7a083b4e-f9f3-552b-0e6c-32bf44982d8f@bytedance.com>
Date:   Fri, 1 Sep 2023 09:50:02 +0800
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (Macintosh; Intel Mac OS X 10.15; rv:102.0)
 Gecko/20100101 Thunderbird/102.14.0
Subject: Re: [PATCH] io_uring: fix IO hang in io_wq_put_and_exit from
 do_exit()
Content-Language: en-US
To:     Ming Lei <ming.lei@redhat.com>, Jens Axboe <axboe@kernel.dk>,
        io-uring@vger.kernel.org, linux-block@vger.kernel.org
Cc:     David Howells <dhowells@redhat.com>
References: <20230831074221.2309565-1-ming.lei@redhat.com>
From:   Chengming Zhou <zhouchengming@bytedance.com>
In-Reply-To: <20230831074221.2309565-1-ming.lei@redhat.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=-5.6 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,NICE_REPLY_A,
        RCVD_IN_DNSWL_BLOCKED,SPF_HELO_NONE,SPF_NONE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org

On 2023/8/31 15:42, Ming Lei wrote:
> io_wq_put_and_exit() is called from do_exit(), but all requests in io_wq
> aren't cancelled in io_uring_cancel_generic() called from do_exit().
> Meantime io_wq IO code path may share resource with normal iopoll code
> path.
> 
> So if any HIPRI request is pending in io_wq_submit_work(), this request
> may not get resouce for moving on, given iopoll isn't possible in
> io_wq_put_and_exit().
> 
> The issue can be triggered when terminating 't/io_uring -n4 /dev/nullb0'
> with default null_blk parameters.
> 
> Fix it by always cancelling all requests in io_wq from io_uring_cancel_generic(),
> and this way is reasonable because io_wq destroying follows cancelling
> requests immediately. Based on one patch from Chengming.

Thanks much for this work, I'm still learning these code, so maybe some
silly questions below.

> 
> Closes: https://lore.kernel.org/linux-block/3893581.1691785261@warthog.procyon.org.uk/
> Reported-by: David Howells <dhowells@redhat.com>
> Cc: Chengming Zhou <zhouchengming@bytedance.com>,
> Signed-off-by: Ming Lei <ming.lei@redhat.com>
> ---
>  io_uring/io_uring.c | 40 ++++++++++++++++++++++++++++------------
>  1 file changed, 28 insertions(+), 12 deletions(-)
> 
> diff --git a/io_uring/io_uring.c b/io_uring/io_uring.c
> index e7675355048d..18d5ab969c29 100644
> --- a/io_uring/io_uring.c
> +++ b/io_uring/io_uring.c
> @@ -144,7 +144,7 @@ struct io_defer_entry {
>  
>  static bool io_uring_try_cancel_requests(struct io_ring_ctx *ctx,
>  					 struct task_struct *task,
> -					 bool cancel_all);
> +					 bool cancel_all, bool *wq_cancelled);
>  
>  static void io_queue_sqe(struct io_kiocb *req);
>  
> @@ -3049,7 +3049,7 @@ static __cold void io_ring_exit_work(struct work_struct *work)
>  		if (ctx->flags & IORING_SETUP_DEFER_TASKRUN)
>  			io_move_task_work_from_local(ctx);
>  
> -		while (io_uring_try_cancel_requests(ctx, NULL, true))
> +		while (io_uring_try_cancel_requests(ctx, NULL, true, NULL))
>  			cond_resched();
>  
>  		if (ctx->sq_data) {
> @@ -3231,12 +3231,13 @@ static __cold bool io_uring_try_cancel_iowq(struct io_ring_ctx *ctx)
>  
>  static __cold bool io_uring_try_cancel_requests(struct io_ring_ctx *ctx,
>  						struct task_struct *task,
> -						bool cancel_all)
> +						bool cancel_all, bool *wq_cancelled)
>  {
> -	struct io_task_cancel cancel = { .task = task, .all = cancel_all, };
> +	struct io_task_cancel cancel = { .task = task, .all = true, };
>  	struct io_uring_task *tctx = task ? task->io_uring : NULL;
>  	enum io_wq_cancel cret;
>  	bool ret = false;
> +	bool wq_active = false;
>  
>  	/* set it so io_req_local_work_add() would wake us up */
>  	if (ctx->flags & IORING_SETUP_DEFER_TASKRUN) {
> @@ -3249,7 +3250,7 @@ static __cold bool io_uring_try_cancel_requests(struct io_ring_ctx *ctx,
>  		return false;
>  
>  	if (!task) {
> -		ret |= io_uring_try_cancel_iowq(ctx);
> +		wq_active = io_uring_try_cancel_iowq(ctx);
>  	} else if (tctx && tctx->io_wq) {
>  		/*
>  		 * Cancels requests of all rings, not only @ctx, but
> @@ -3257,11 +3258,20 @@ static __cold bool io_uring_try_cancel_requests(struct io_ring_ctx *ctx,
>  		 */
>  		cret = io_wq_cancel_cb(tctx->io_wq, io_cancel_task_cb,
>  				       &cancel, true);
> -		ret |= (cret != IO_WQ_CANCEL_NOTFOUND);
> +		wq_active = (cret != IO_WQ_CANCEL_NOTFOUND);
>  	}
> +	ret |= wq_active;
> +	if (wq_cancelled)
> +		*wq_cancelled = !wq_active;

Here it seems "wq_cancelled" means no any pending or running work anymore.

Why not just use the return value "loop", instead of using this new "wq_cancelled"?

If return value "loop" is true, we know there is still any request need to cancel,
so we will loop the cancel process until there is no any request.

Ah, I guess you may want to cover one case: !wq_active && loop == true

>  
> -	/* SQPOLL thread does its own polling */
> -	if ((!(ctx->flags & IORING_SETUP_SQPOLL) && cancel_all) ||
> +	/*
> +	 * SQPOLL thread does its own polling
> +	 *
> +	 * io_wq may share IO resources(such as requests) with iopoll, so
> +	 * iopoll requests have to be reapped for providing forward
> +	 * progress to io_wq cancelling
> +	 */
> +	if (!(ctx->flags & IORING_SETUP_SQPOLL) ||
>  	    (ctx->sq_data && ctx->sq_data->thread == current)) {
>  		while (!wq_list_empty(&ctx->iopoll_list)) {
>  			io_iopoll_try_reap_events(ctx);
> @@ -3313,11 +3323,12 @@ __cold void io_uring_cancel_generic(bool cancel_all, struct io_sq_data *sqd)
>  	atomic_inc(&tctx->in_cancel);
>  	do {
>  		bool loop = false;
> +		bool wq_cancelled;
>  
>  		io_uring_drop_tctx_refs(current);
>  		/* read completions before cancelations */
>  		inflight = tctx_inflight(tctx, !cancel_all);
> -		if (!inflight)
> +		if (!inflight && !tctx->io_wq)
>  			break;
>  

I think this inflight check should put after the cancel loop, because the
cancel loop make sure there is no any request need to cancel, then we can
loop inflight checking to make sure all inflight requests to complete.

>  		if (!sqd) {
> @@ -3326,20 +3337,25 @@ __cold void io_uring_cancel_generic(bool cancel_all, struct io_sq_data *sqd)
>  				if (node->ctx->sq_data)
>  					continue;
>  				loop |= io_uring_try_cancel_requests(node->ctx,
> -							current, cancel_all);
> +							current, cancel_all,
> +							&wq_cancelled);
>  			}
>  		} else {
>  			list_for_each_entry(ctx, &sqd->ctx_list, sqd_list)
>  				loop |= io_uring_try_cancel_requests(ctx,
>  								     current,
> -								     cancel_all);
> +								     cancel_all,
> +								     &wq_cancelled);
>  		}
>  
> -		if (loop) {
> +		if (!wq_cancelled || (inflight && loop)) {
>  			cond_resched();
>  			continue;
>  		}

So here we just need to check "loop", continue cancel if loop is true?

Thanks!

>  
> +		if (!inflight)
> +			break;
> +
>  		prepare_to_wait(&tctx->wait, &wait, TASK_INTERRUPTIBLE);
>  		io_run_task_work();
>  		io_uring_drop_tctx_refs(current);
