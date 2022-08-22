Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id B941759BE9F
	for <lists+io-uring@lfdr.de>; Mon, 22 Aug 2022 13:38:12 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234170AbiHVLiL (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Mon, 22 Aug 2022 07:38:11 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:35652 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233522AbiHVLiL (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Mon, 22 Aug 2022 07:38:11 -0400
Received: from mail-wm1-x32b.google.com (mail-wm1-x32b.google.com [IPv6:2a00:1450:4864:20::32b])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id CC0DA2FFE2
        for <io-uring@vger.kernel.org>; Mon, 22 Aug 2022 04:38:09 -0700 (PDT)
Received: by mail-wm1-x32b.google.com with SMTP id bd26-20020a05600c1f1a00b003a5e82a6474so5829823wmb.4
        for <io-uring@vger.kernel.org>; Mon, 22 Aug 2022 04:38:09 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=content-transfer-encoding:in-reply-to:from:references:cc:to
         :content-language:subject:user-agent:mime-version:date:message-id
         :from:to:cc;
        bh=T+peGq9fDXF2kzknq6cwP8FvO5ha4pRfmiKu1LG2Ovg=;
        b=R62Bq1PI5xpx8+2IteslHnCEnJqw7RWhk6wG0qmZ4Nap1MnUzFBQxmGkkbFw1JCgNi
         SX4ZLgHDm071lUfKQrFDa/z/f+6DR/EZsyoH1TxG1McBg9gBJsz2zSNsI7ie0/5sRzxM
         7CNhNYwiDqMsKtDfa0rqdeN6flGohae4MSC4zk5m6YhzAaJpKrto9hGXgSsNnJz8WVhk
         C8f1Rk9uH9w16oSJyQ1JGrXbOyR68RBR6KZLVTNNoWoXgJG9BwNcqjO7ERaOLI43is6s
         0LansUZS1TEJkIRA1npPRGG+2P4I9yXxmcdLAzMG5mt4zrOsoEWtDw+WwZZNLxnVdDY5
         z+/w==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=content-transfer-encoding:in-reply-to:from:references:cc:to
         :content-language:subject:user-agent:mime-version:date:message-id
         :x-gm-message-state:from:to:cc;
        bh=T+peGq9fDXF2kzknq6cwP8FvO5ha4pRfmiKu1LG2Ovg=;
        b=HvQkXfgoBGuLx9r6oy7Oxg3Baa6eOAHowGlDXQ6ptiyyOwM/TgdAqWilAkTJ9/Qvga
         dathZ0t5LoD+MLsWY0xLtrCbHiMPykx7MBPu9grmuQT7W/37woNkUzyBvwdgAUNiHDYq
         csFMkq293ewHrYyC8JjcTMmvOELxhzSIuTN5oDethLXs5XHKmatmMyMJfQptcxiWdtTg
         8FoBcFFA4tWG7O7idCerwzKlK4341meff/BhrdtVXc3R3gGe6GEochSSgD+5d2UJOKC7
         A99UfR9uHt6zP4CkTXLMsWUweHAU+idUzT6zZLude9A5WVsr3rSKV2sw3b6dBiWSCd5q
         JoRw==
X-Gm-Message-State: ACgBeo1CkNmbG8jkeUsb3UwG/WwJ42gKMuBPR6AzJhMWtt0NGfzkxMTc
        i9fQj4Z1mC1amzuyfCcjXtI=
X-Google-Smtp-Source: AA6agR7hHp+fn0pTDjh4GkTZo22k925CutiFEpx55gyqjX3QDwJSQfC+JZ4KFXG7/0QwMBxnF+n0XA==
X-Received: by 2002:a05:600c:1d8c:b0:3a5:a536:bf71 with SMTP id p12-20020a05600c1d8c00b003a5a536bf71mr15439048wms.201.1661168288029;
        Mon, 22 Aug 2022 04:38:08 -0700 (PDT)
Received: from [192.168.8.198] (188.28.126.24.threembb.co.uk. [188.28.126.24])
        by smtp.gmail.com with ESMTPSA id f10-20020adff8ca000000b002252cb35184sm11601222wrq.25.2022.08.22.04.38.06
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Mon, 22 Aug 2022 04:38:07 -0700 (PDT)
Message-ID: <d3ad2512-ab06-1a56-6394-0dc4a62f0028@gmail.com>
Date:   Mon, 22 Aug 2022 12:34:10 +0100
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:91.0) Gecko/20100101
 Thunderbird/91.12.0
Subject: Re: [PATCH for-next v3 4/7] io_uring: add IORING_SETUP_DEFER_TASKRUN
Content-Language: en-US
To:     Dylan Yudaken <dylany@fb.com>, Jens Axboe <axboe@kernel.dk>,
        io-uring@vger.kernel.org
Cc:     Kernel-team@fb.com
References: <20220819121946.676065-1-dylany@fb.com>
 <20220819121946.676065-5-dylany@fb.com>
From:   Pavel Begunkov <asml.silence@gmail.com>
In-Reply-To: <20220819121946.676065-5-dylany@fb.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_FROM,NICE_REPLY_A,
        RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org

On 8/19/22 13:19, Dylan Yudaken wrote:
> Allow deferring async tasks until the user calls io_uring_enter(2) with
> the IORING_ENTER_GETEVENTS flag. Enable this mode with a flag at
> io_uring_setup time. This functionality requires that the later
> io_uring_enter will be called from the same submission task, and therefore
> restrict this flag to work only when IORING_SETUP_SINGLE_ISSUER is also
> set.

Looks ok, a couple of small comments below, but I don't see anything
blocking it.

> Being able to hand pick when tasks are run prevents the problem where
> there is current work to be done, however task work runs anyway.
> 
> For example, a common workload would obtain a batch of CQEs, and process
> each one. Interrupting this to additional taskwork would add latency but
> not gain anything. If instead task work is deferred to just before more
> CQEs are obtained then no additional latency is added.
> 
> The way this is implemented is by trying to keep task work local to a
> io_ring_ctx, rather than to the submission task. This is required, as the
> application will want to wake up only a single io_ring_ctx at a time to
> process work, and so the lists of work have to be kept separate.
> 
> This has some other benefits like not having to check the task continually
> in handle_tw_list (and potentially unlocking/locking those), and reducing
> locks in the submit & process completions path.
> 
> There are networking cases where using this option can reduce request
> latency by 50%. For example a contrived example using [1] where the client
> sends 2k data and receives the same data back while doing some system
> calls (to trigger task work) shows this reduction. The reason ends up
> being that if sending responses is delayed by processing task work, then
> the client side sits idle. Whereas reordering the sends first means that
> the client runs it's workload in parallel with the local task work.

Quite contrived, for some it may cut latency in half but for others
as easily increate it twofold. In any case, it's not a critique of the
feature as it's optional, but rather raises a question whether we
need to add some fairness / scheduling here.

> [1]:
> Using https://github.com/DylanZA/netbench/tree/defer_run
> Client:
> ./netbench  --client_only 1 --control_port 10000 --host <host> --tx "epoll --threads 16 --per_thread 1 --size 2048 --resp 2048 --workload 1000"
> Server:
> ./netbench  --server_only 1 --control_port 10000  --rx "io_uring --defer_taskrun 0 --workload 100"   --rx "io_uring  --defer_taskrun 1 --workload 100"
> 
> Signed-off-by: Dylan Yudaken <dylany@fb.com>
> ---

> diff --git a/io_uring/io_uring.c b/io_uring/io_uring.c
> index 53696dd90626..6572d2276750 100644
> --- a/io_uring/io_uring.c
> +++ b/io_uring/io_uring.c
[...]

> +int io_run_local_work(struct io_ring_ctx *ctx, bool locked)
> +{
> +	struct llist_node *node;
> +	struct llist_node fake;
> +	struct llist_node *current_final = NULL;
> +	int ret;
> +
> +	if (unlikely(ctx->submitter_task != current)) {
> +		if (locked)
> +			mutex_unlock(&ctx->uring_lock);
> +
> +		/* maybe this is before any submissions */
> +		if (!ctx->submitter_task)
> +			return 0;
> +
> +		return -EEXIST;
> +	}
> +
> +	if (!locked)
> +		locked = mutex_trylock(&ctx->uring_lock);
> +
> +	node = io_llist_xchg(&ctx->work_llist, &fake);
> +	ret = 0;
> +again:
> +	while (node != current_final) {
> +		struct llist_node *next = node->next;
> +		struct io_kiocb *req = container_of(node, struct io_kiocb,
> +						    io_task_work.node);
> +		prefetch(container_of(next, struct io_kiocb, io_task_work.node));
> +		req->io_task_work.func(req, &locked);
> +		ret++;
> +		node = next;
> +	}
> +
> +	if (ctx->flags & IORING_SETUP_TASKRUN_FLAG)
> +		atomic_andnot(IORING_SQ_TASKRUN, &ctx->rings->sq_flags);
> +
> +	node = io_llist_cmpxchg(&ctx->work_llist, &fake, NULL);
> +	if (node != &fake) {
> +		current_final = &fake;
> +		node = io_llist_xchg(&ctx->work_llist, &fake);
> +		goto again;
> +	}
> +
> +	if (locked) {
> +		io_submit_flush_completions(ctx);
> +		mutex_unlock(&ctx->uring_lock);
> +	}
> +	return ret;
> +}

I was thinking about:

int io_run_local_work(struct io_ring_ctx *ctx, bool *locked)
{
	locked = try_lock();
}

bool locked = false;
io_run_local_work(ctx, *locked);
if (locked)
	unlock();

// or just as below when already holding it
bool locked = true;
io_run_local_work(ctx, *locked);

Which would replace

if (DEFER) {
	// we're assuming that it'll unlock
	io_run_local_work(true);
} else {
	unlock();
}

with

if (DEFER) {
	bool locked = true;
	io_run_local_work(&locked);
}
unlock();

But anyway, it can be mulled later.


> -int io_run_task_work_sig(void)
> +int io_run_task_work_sig(struct io_ring_ctx *ctx)
>   {
> -	if (io_run_task_work())
> +	if (io_run_task_work_ctx(ctx))
>   		return 1;
>   	if (task_sigpending(current))
>   		return -EINTR;
> @@ -2196,7 +2294,7 @@ static inline int io_cqring_wait_schedule(struct io_ring_ctx *ctx,
>   	unsigned long check_cq;
>   
>   	/* make sure we run task_work before checking for signals */
> -	ret = io_run_task_work_sig();
> +	ret = io_run_task_work_sig(ctx);
>   	if (ret || io_should_wake(iowq))
>   		return ret;
>   
> @@ -2230,7 +2328,7 @@ static int io_cqring_wait(struct io_ring_ctx *ctx, int min_events,
>   		io_cqring_overflow_flush(ctx);
>   		if (io_cqring_events(ctx) >= min_events)
>   			return 0;
> -		if (!io_run_task_work())
> +		if (!io_run_task_work_ctx(ctx))
>   			break;
>   	} while (1);
>   
> @@ -2573,6 +2671,9 @@ static __cold void io_ring_exit_work(struct work_struct *work)
>   	 * as nobody else will be looking for them.
>   	 */
>   	do {
> +		if (ctx->flags & IORING_SETUP_DEFER_TASKRUN)
> +			io_move_task_work_from_local(ctx);
> +
>   		while (io_uring_try_cancel_requests(ctx, NULL, true))
>   			cond_resched();
>   
> @@ -2768,6 +2869,8 @@ static __cold bool io_uring_try_cancel_requests(struct io_ring_ctx *ctx,
>   		}
>   	}
>   
> +	if (ctx->flags & IORING_SETUP_DEFER_TASKRUN)
> +		ret |= io_run_local_work(ctx, false) > 0;
>   	ret |= io_cancel_defer_files(ctx, task, cancel_all);
>   	mutex_lock(&ctx->uring_lock);
>   	ret |= io_poll_remove_all(ctx, task, cancel_all);
> @@ -3057,10 +3160,20 @@ SYSCALL_DEFINE6(io_uring_enter, unsigned int, fd, u32, to_submit,
>   		}
>   		if ((flags & IORING_ENTER_GETEVENTS) && ctx->syscall_iopoll)
>   			goto iopoll_locked;
> +		if ((flags & IORING_ENTER_GETEVENTS) &&
> +			(ctx->flags & IORING_SETUP_DEFER_TASKRUN)) {
> +			int ret2 = io_run_local_work(ctx, true);
> +
> +			if (unlikely(ret2 < 0))
> +				goto out;

It's an optimisation and we don't have to handle errors here,
let's ignore them and make it looking a bit better.

> +			goto getevents_ran_local;
> +		}
>   		mutex_unlock(&ctx->uring_lock);
>   	}
> +
>   	if (flags & IORING_ENTER_GETEVENTS) {
>   		int ret2;
> +
>   		if (ctx->syscall_iopoll) {
>   			/*
>   			 * We disallow the app entering submit/complete with
> @@ -3081,6 +3194,12 @@ SYSCALL_DEFINE6(io_uring_enter, unsigned int, fd, u32, to_submit,
>   			const sigset_t __user *sig;
>   			struct __kernel_timespec __user *ts;
>   
> +			if (ctx->flags & IORING_SETUP_DEFER_TASKRUN) {

I think it should be in io_cqring_wait(), which calls it anyway
in the beginning. Instead of

	do {
		io_cqring_overflow_flush(ctx);
		if (io_cqring_events(ctx) >= min_events)
			return 0;
		if (!io_run_task_work())
			break;
	} while (1);

Let's have

	do {
		ret = io_run_task_work_ctx();
		// handle ret
		io_cqring_overflow_flush(ctx);
		if (io_cqring_events(ctx) >= min_events)
			return 0;
	} while (1);

> +				ret2 = io_run_local_work(ctx, false);
> +				if (unlikely(ret2 < 0))
> +					goto getevents_out;
> +			}
> +getevents_ran_local:
>   			ret2 = io_get_ext_arg(flags, argp, &argsz, &ts, &sig);
>   			if (likely(!ret2)) {
>   				min_complete = min(min_complete,
> @@ -3090,6 +3209,7 @@ SYSCALL_DEFINE6(io_uring_enter, unsigned int, fd, u32, to_submit,
>   			}
>   		}
>   
> +getevents_out:
>   		if (!ret) {
>   			ret = ret2;
>   
> @@ -3289,17 +3409,29 @@ static __cold int io_uring_create(unsigned entries, struct io_uring_params *p,
>   	if (ctx->flags & IORING_SETUP_SQPOLL) {
>   		/* IPI related flags don't make sense with SQPOLL */
>   		if (ctx->flags & (IORING_SETUP_COOP_TASKRUN |
> -				  IORING_SETUP_TASKRUN_FLAG))
> +				  IORING_SETUP_TASKRUN_FLAG |
> +				  IORING_SETUP_DEFER_TASKRUN))

Sounds like we should also fail if SQPOLL is set, especially with
the task check on the waiting side.

>   			goto err;
>   		ctx->notify_method = TWA_SIGNAL_NO_IPI;
>   	} else if (ctx->flags & IORING_SETUP_COOP_TASKRUN) {
>   		ctx->notify_method = TWA_SIGNAL_NO_IPI;
[...]
>   	mutex_lock(&ctx->uring_lock);
>   	ret = __io_uring_register(ctx, opcode, arg, nr_args);
> diff --git a/io_uring/io_uring.h b/io_uring/io_uring.h
> index 2f73f83af960..a9fb115234af 100644
> --- a/io_uring/io_uring.h
> +++ b/io_uring/io_uring.h
> @@ -26,7 +26,8 @@ enum {
[...]
> +static inline int io_run_task_work_unlock_ctx(struct io_ring_ctx *ctx)
> +{
> +	int ret;
> +
> +	if (ctx->flags & IORING_SETUP_DEFER_TASKRUN) {
> +		ret = io_run_local_work(ctx, true);
> +	} else {
> +		mutex_unlock(&ctx->uring_lock);
> +		ret = (int)io_run_task_work();

Why do we need a cast? let's keep the return type same


-- 
Pavel Begunkov
