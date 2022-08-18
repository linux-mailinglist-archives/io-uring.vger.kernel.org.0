Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id F15525981A0
	for <lists+io-uring@lfdr.de>; Thu, 18 Aug 2022 12:48:19 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S243881AbiHRKpW (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Thu, 18 Aug 2022 06:45:22 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:39928 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S244143AbiHRKpR (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Thu, 18 Aug 2022 06:45:17 -0400
Received: from mail-wm1-x32a.google.com (mail-wm1-x32a.google.com [IPv6:2a00:1450:4864:20::32a])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id B65A98284B
        for <io-uring@vger.kernel.org>; Thu, 18 Aug 2022 03:45:15 -0700 (PDT)
Received: by mail-wm1-x32a.google.com with SMTP id z14-20020a7bc7ce000000b003a5db0388a8so2622962wmk.1
        for <io-uring@vger.kernel.org>; Thu, 18 Aug 2022 03:45:15 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=content-transfer-encoding:in-reply-to:from:references:cc:to
         :content-language:subject:user-agent:mime-version:date:message-id
         :from:to:cc;
        bh=UIwFJjOnmHWHJvaOkpPYtpTfbrZ1iWGGi1FICeCJHbI=;
        b=dWfiUNu0AydmZrWaRl4UQS1ITxDmEfsu6Jec7WJvKy/q9ChWWJ4gBXlPQuWn8STAtA
         tM69cwO70ZPiX1AuaEN8DnZcYFcYLNPSlORWuEbG6tcJuMB6v2Tw1ItiFRqUmcl9WLq5
         FgML2MFPJbTCWIMr1pDJjzBxXxk+ykaXlYm1z7XzOL8MwVgJE8uY8mtDFNNeZammwD4e
         G2AFTvP6Q90H/ykJ+KY/o2mNPkmC653r0wQ/KFXplxMXXuf7xNKIlNBRnFclcta9QgvY
         p2p0moqS5uvZWUG3JEtPEBKyGHpSPgU+m709oqgJ9pieUAcvhPZHXYO1Xrd+kvKBQq3u
         f9gg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=content-transfer-encoding:in-reply-to:from:references:cc:to
         :content-language:subject:user-agent:mime-version:date:message-id
         :x-gm-message-state:from:to:cc;
        bh=UIwFJjOnmHWHJvaOkpPYtpTfbrZ1iWGGi1FICeCJHbI=;
        b=U3mxnZT+j/PJAbcsHPShTqywU02OFFI5O0XIW/AH6XsXxjvxyK8hSPyltEd+ek7XXS
         jVAZeWtqfyPJkl5cS0r60zBG3eHb5tPzEWVpFwe4W1fJ42FG5FRTg7ccdVKRZASehnRB
         FyjVNfYeb06X08iS0yWyBXyiiqIsQuvzaEWIrW2XoWMFB40sAiNBAt93ambK0dfAGJzd
         pjiVgqKIq5fjozCCFhjEpbxS4NSatWv8RlEdRUJ1J6onNRhUUBhDmaSaFgNHgL8tX+eb
         fD+QlZ9PmgXdfoaBeYBcXAqkNJcly3rYdX6zTygAcfPgaZgGdf6Are/+sim6iIWQ/1gO
         imow==
X-Gm-Message-State: ACgBeo1WSXKGy9BHIQuWAe+g2rutA5T613anCoe8jRAPkOwC1UNT9q/e
        QBAwRGVlpwLc3mPm7fhaKP2JxBYlH/DjEA==
X-Google-Smtp-Source: AA6agR45e48ivV0Kf83r63jXLUAYg0mtc7/0N37qhB14C/HvFGTi69ducTfcfS5TVERoAl/m697i8w==
X-Received: by 2002:a05:600c:ad2:b0:3a5:36ca:ec38 with SMTP id c18-20020a05600c0ad200b003a536caec38mr1407109wmr.21.1660819514178;
        Thu, 18 Aug 2022 03:45:14 -0700 (PDT)
Received: from ?IPV6:2620:10d:c096:310::22ef? ([2620:10d:c092:600::2:40fa])
        by smtp.gmail.com with ESMTPSA id p15-20020adfcc8f000000b002252ec781f7sm1139834wrj.8.2022.08.18.03.45.13
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Thu, 18 Aug 2022 03:45:13 -0700 (PDT)
Message-ID: <007b1271-4767-e405-d3ea-d681dae00647@gmail.com>
Date:   Thu, 18 Aug 2022 11:42:22 +0100
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:91.0) Gecko/20100101
 Thunderbird/91.11.0
Subject: Re: [PATCH for-next v2 4/6] io_uring: add IORING_SETUP_DEFER_TASKRUN
Content-Language: en-US
To:     Dylan Yudaken <dylany@fb.com>, Jens Axboe <axboe@kernel.dk>,
        io-uring@vger.kernel.org
Cc:     Kernel-team@fb.com
References: <20220816153728.2160601-1-dylany@fb.com>
 <20220816153728.2160601-5-dylany@fb.com>
From:   Pavel Begunkov <asml.silence@gmail.com>
In-Reply-To: <20220816153728.2160601-5-dylany@fb.com>
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

On 8/16/22 16:37, Dylan Yudaken wrote:
> Allow deferring async tasks until the user calls io_uring_enter(2) with
> the IORING_ENTER_GETEVENTS flag. Enable this mode with a flag at
> io_uring_setup time. This functionality requires that the later
> io_uring_enter will be called from the same submission task, and therefore
> restrict this flag to work only when IORING_SETUP_SINGLE_ISSUER is also
> set.
> 
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
> 
> [1]:
> Using https://github.com/DylanZA/netbench/tree/defer_run
> Client:
> ./netbench  --client_only 1 --control_port 10000 --host <host> --tx "epoll --threads 16 --per_thread 1 --size 2048 --resp 2048 --workload 1000"
> Server:
> ./netbench  --server_only 1 --control_port 10000  --rx "io_uring --defer_taskrun 0 --workload 100"   --rx "io_uring  --defer_taskrun 1 --workload 100"
> 
> Signed-off-by: Dylan Yudaken <dylany@fb.com>
> ---
>   include/linux/io_uring_types.h |   2 +
>   include/uapi/linux/io_uring.h  |   7 ++
>   io_uring/cancel.c              |   2 +-
>   io_uring/io_uring.c            | 119 +++++++++++++++++++++++++++++----
>   io_uring/io_uring.h            |  30 ++++++++-
>   io_uring/rsrc.c                |   2 +-
>   6 files changed, 146 insertions(+), 16 deletions(-)
> 
> diff --git a/include/linux/io_uring_types.h b/include/linux/io_uring_types.h
> index 677a25d44d7f..d56ff2185168 100644
> --- a/include/linux/io_uring_types.h
> +++ b/include/linux/io_uring_types.h
> @@ -301,6 +301,8 @@ struct io_ring_ctx {
>   		struct io_hash_table	cancel_table;
>   		bool			poll_multi_queue;
>   
> +		struct llist_head	work_llist;
> +
>   		struct list_head	io_buffers_comp;
>   	} ____cacheline_aligned_in_smp;
>   
> diff --git a/include/uapi/linux/io_uring.h b/include/uapi/linux/io_uring.h
> index 1463cfecb56b..be8d1801bf4a 100644
> --- a/include/uapi/linux/io_uring.h
> +++ b/include/uapi/linux/io_uring.h
> @@ -153,6 +153,13 @@ enum {
>    */
>   #define IORING_SETUP_SINGLE_ISSUER	(1U << 12)
>   
> +/*
> + * Defer running task work to get events.
> + * Rather than running bits of task work whenever the task transitions
> + * try to do it just before it is needed.
> + */
> +#define IORING_SETUP_DEFER_TASKRUN	(1U << 13)
> +
>   enum io_uring_op {
>   	IORING_OP_NOP,
>   	IORING_OP_READV,
> diff --git a/io_uring/cancel.c b/io_uring/cancel.c
> index e4e1dc0325f0..db6180b62e41 100644
> --- a/io_uring/cancel.c
> +++ b/io_uring/cancel.c
> @@ -292,7 +292,7 @@ int io_sync_cancel(struct io_ring_ctx *ctx, void __user *arg)
>   			break;
>   
>   		mutex_unlock(&ctx->uring_lock);
> -		ret = io_run_task_work_sig();
> +		ret = io_run_task_work_sig(ctx);
>   		if (ret < 0) {
>   			mutex_lock(&ctx->uring_lock);
>   			break;
> diff --git a/io_uring/io_uring.c b/io_uring/io_uring.c
> index 53696dd90626..6b16da0be712 100644
> --- a/io_uring/io_uring.c
> +++ b/io_uring/io_uring.c
> @@ -316,6 +316,7 @@ static __cold struct io_ring_ctx *io_ring_ctx_alloc(struct io_uring_params *p)
>   	INIT_LIST_HEAD(&ctx->rsrc_ref_list);
>   	INIT_DELAYED_WORK(&ctx->rsrc_put_work, io_rsrc_put_work);
>   	init_llist_head(&ctx->rsrc_put_llist);
> +	init_llist_head(&ctx->work_llist);
>   	INIT_LIST_HEAD(&ctx->tctx_list);
>   	ctx->submit_state.free_list.next = NULL;
>   	INIT_WQ_LIST(&ctx->locked_free_list);
> @@ -1047,12 +1048,30 @@ void tctx_task_work(struct callback_head *cb)
>   	trace_io_uring_task_work_run(tctx, count, loops);
>   }
>   
> -void io_req_task_work_add(struct io_kiocb *req)
> +static void io_req_local_work_add(struct io_kiocb *req)
> +{
> +	struct io_ring_ctx *ctx = req->ctx;
> +
> +	if (!llist_add(&req->io_task_work.node, &ctx->work_llist))
> +		return;
> +
> +	if (ctx->flags & IORING_SETUP_TASKRUN_FLAG)
> +		atomic_or(IORING_SQ_TASKRUN, &ctx->rings->sq_flags);
> +
> +	io_cqring_wake(ctx);
> +}
> +
> +static inline void __io_req_task_work_add(struct io_kiocb *req, bool allow_local)
>   {
>   	struct io_uring_task *tctx = req->task->io_uring;
>   	struct io_ring_ctx *ctx = req->ctx;
>   	struct llist_node *node;
>   
> +	if (allow_local && ctx->flags & IORING_SETUP_DEFER_TASKRUN) {
> +		io_req_local_work_add(req);
> +		return;
> +	}
> +
>   	/* task_work already pending, we're done */
>   	if (!llist_add(&req->io_task_work.node, &tctx->task_list))
>   		return;
> @@ -1074,6 +1093,55 @@ void io_req_task_work_add(struct io_kiocb *req)
>   	}
>   }
>   
> +void io_req_task_work_add(struct io_kiocb *req)
> +{
> +	__io_req_task_work_add(req, true);
> +}
> +
> +bool io_run_local_work(struct io_ring_ctx *ctx, bool locked)
> +{
> +	struct llist_node *node;
> +	struct llist_node fake;
> +	struct llist_node *current_final = NULL;
> +	unsigned int count;
> +
> +	if (!locked)
> +		locked = mutex_trylock(&ctx->uring_lock);
> +
> +	node = io_llist_xchg(&ctx->work_llist, &fake);
> +	count = 0;
> +again:
> +	while (node != current_final) {
> +		struct llist_node *next = node->next;
> +		struct io_kiocb *req = container_of(node, struct io_kiocb,
> +						    io_task_work.node);
> +		prefetch(container_of(next, struct io_kiocb, io_task_work.node));
> +		if (unlikely(req->task != current)) {
> +			__io_req_task_work_add(req, false);
> +		} else {
> +			req->io_task_work.func(req, &locked);
> +			count++;
> +		}
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
> +	return count > 0;
> +}
> +
>   static void io_req_tw_post(struct io_kiocb *req, bool *locked)
>   {
>   	io_req_complete_post(req);
> @@ -1284,8 +1352,7 @@ static int io_iopoll_check(struct io_ring_ctx *ctx, long min)
>   		if (wq_list_empty(&ctx->iopoll_list)) {
>   			u32 tail = ctx->cached_cq_tail;
>   
> -			mutex_unlock(&ctx->uring_lock);
> -			io_run_task_work();
> +			io_run_task_work_unlock_ctx(ctx);
>   			mutex_lock(&ctx->uring_lock);
>   
>   			/* some requests don't go through iopoll_list */
> @@ -2146,7 +2213,9 @@ struct io_wait_queue {
>   
>   static inline bool io_has_work(struct io_ring_ctx *ctx)
>   {
> -	return test_bit(IO_CHECK_CQ_OVERFLOW_BIT, &ctx->check_cq);
> +	return test_bit(IO_CHECK_CQ_OVERFLOW_BIT, &ctx->check_cq) ||
> +	       ((ctx->flags & IORING_SETUP_DEFER_TASKRUN) &&
> +		!llist_empty(&ctx->work_llist));
>   }
>   
>   static inline bool io_should_wake(struct io_wait_queue *iowq)
> @@ -2178,9 +2247,9 @@ static int io_wake_function(struct wait_queue_entry *curr, unsigned int mode,
>   	return -1;
>   }
>   
> -int io_run_task_work_sig(void)
> +int io_run_task_work_sig(struct io_ring_ctx *ctx)
>   {
> -	if (io_run_task_work())
> +	if (io_run_task_work_ctx(ctx, true))
>   		return 1;
>   	if (task_sigpending(current))
>   		return -EINTR;
> @@ -2196,7 +2265,7 @@ static inline int io_cqring_wait_schedule(struct io_ring_ctx *ctx,
>   	unsigned long check_cq;
>   
>   	/* make sure we run task_work before checking for signals */
> -	ret = io_run_task_work_sig();
> +	ret = io_run_task_work_sig(ctx);
>   	if (ret || io_should_wake(iowq))
>   		return ret;
>   
> @@ -2230,7 +2299,7 @@ static int io_cqring_wait(struct io_ring_ctx *ctx, int min_events,
>   		io_cqring_overflow_flush(ctx);
>   		if (io_cqring_events(ctx) >= min_events)
>   			return 0;
> -		if (!io_run_task_work())
> +		if (!io_run_task_work_ctx(ctx, false))

Sounds like there should be true, but see comments
around io_run_task_work_ctx().

Also, should we do

if (DEFER_TW) {
	if (current != ctx->submitter_task) // + SQPOLL handling
		return -E<error>;
}

And on top we can remove moving local tw -> normal tw in
io_run_local_work(), which probably will only be needed in
exit_work().


>   			break;
>   	} while (1);
>   
> @@ -2768,6 +2837,8 @@ static __cold bool io_uring_try_cancel_requests(struct io_ring_ctx *ctx,
>   		}
>   	}
>   
> +	if (ctx->flags & IORING_SETUP_DEFER_TASKRUN)
> +		ret |= io_run_local_work(ctx, false);
>   	ret |= io_cancel_defer_files(ctx, task, cancel_all);
>   	mutex_lock(&ctx->uring_lock);
>   	ret |= io_poll_remove_all(ctx, task, cancel_all);
> @@ -2837,7 +2908,7 @@ __cold void io_uring_cancel_generic(bool cancel_all, struct io_sq_data *sqd)
>   		}
>   
>   		prepare_to_wait(&tctx->wait, &wait, TASK_INTERRUPTIBLE);
> -		io_run_task_work();
> +		io_run_task_work_ctx(ctx, true);

Here we rely on normal tw waking up the task, which is not done
by the new local tw

>   		io_uring_drop_tctx_refs(current);
>   
>   		/*
> @@ -3057,10 +3128,17 @@ SYSCALL_DEFINE6(io_uring_enter, unsigned int, fd, u32, to_submit,
>   		}
>   		if ((flags & IORING_ENTER_GETEVENTS) && ctx->syscall_iopoll)
>   			goto iopoll_locked;
> +		if ((flags & IORING_ENTER_GETEVENTS) &&
> +			(ctx->flags & IORING_SETUP_DEFER_TASKRUN)) {
> +			io_run_local_work(ctx, true);
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
> @@ -3081,6 +3159,9 @@ SYSCALL_DEFINE6(io_uring_enter, unsigned int, fd, u32, to_submit,
>   			const sigset_t __user *sig;
>   			struct __kernel_timespec __user *ts;
>   
> +			if (ctx->flags & IORING_SETUP_DEFER_TASKRUN)
> +				io_run_local_work(ctx, false);
> +getevents_ran_local:
>   			ret2 = io_get_ext_arg(flags, argp, &argsz, &ts, &sig);
>   			if (likely(!ret2)) {
>   				min_complete = min(min_complete,
> @@ -3289,17 +3370,29 @@ static __cold int io_uring_create(unsigned entries, struct io_uring_params *p,
>   	if (ctx->flags & IORING_SETUP_SQPOLL) {
>   		/* IPI related flags don't make sense with SQPOLL */
>   		if (ctx->flags & (IORING_SETUP_COOP_TASKRUN |
> -				  IORING_SETUP_TASKRUN_FLAG))
> +				  IORING_SETUP_TASKRUN_FLAG |
> +				  IORING_SETUP_DEFER_TASKRUN))
>   			goto err;
>   		ctx->notify_method = TWA_SIGNAL_NO_IPI;
>   	} else if (ctx->flags & IORING_SETUP_COOP_TASKRUN) {
>   		ctx->notify_method = TWA_SIGNAL_NO_IPI;
>   	} else {
> -		if (ctx->flags & IORING_SETUP_TASKRUN_FLAG)
> +		if (ctx->flags & IORING_SETUP_TASKRUN_FLAG &&
> +		    !(ctx->flags & IORING_SETUP_DEFER_TASKRUN))
>   			goto err;
>   		ctx->notify_method = TWA_SIGNAL;
>   	}
>   
> +	/*
> +	 * For DEFER_TASKRUN we require the completion task to be the same as the
> +	 * submission task. This implies that there is only one submitter, so enforce
> +	 * that.
> +	 */
> +	if (ctx->flags & IORING_SETUP_DEFER_TASKRUN &&
> +	    !(ctx->flags & IORING_SETUP_SINGLE_ISSUER)) {
> +		goto err;
> +	}
> +
>   	/*
>   	 * This is just grabbed for accounting purposes. When a process exits,
>   	 * the mm is exited and dropped before the files, hence we need to hang
> @@ -3400,7 +3493,7 @@ static long io_uring_setup(u32 entries, struct io_uring_params __user *params)
>   			IORING_SETUP_R_DISABLED | IORING_SETUP_SUBMIT_ALL |
>   			IORING_SETUP_COOP_TASKRUN | IORING_SETUP_TASKRUN_FLAG |
>   			IORING_SETUP_SQE128 | IORING_SETUP_CQE32 |
> -			IORING_SETUP_SINGLE_ISSUER))
> +			IORING_SETUP_SINGLE_ISSUER | IORING_SETUP_DEFER_TASKRUN))
>   		return -EINVAL;
>   
>   	return io_uring_create(entries, &p, params);
> @@ -3872,7 +3965,7 @@ SYSCALL_DEFINE4(io_uring_register, unsigned int, fd, unsigned int, opcode,
>   
>   	ctx = f.file->private_data;
>   
> -	io_run_task_work();
> +	io_run_task_work_ctx(ctx, true);
>   
>   	mutex_lock(&ctx->uring_lock);
>   	ret = __io_uring_register(ctx, opcode, arg, nr_args);
> diff --git a/io_uring/io_uring.h b/io_uring/io_uring.h
> index 2f73f83af960..4d0e9c2e00d0 100644
> --- a/io_uring/io_uring.h
> +++ b/io_uring/io_uring.h
> @@ -26,7 +26,8 @@ enum {
>   
>   struct io_uring_cqe *__io_get_cqe(struct io_ring_ctx *ctx);
>   bool io_req_cqe_overflow(struct io_kiocb *req);
> -int io_run_task_work_sig(void);
> +int io_run_task_work_sig(struct io_ring_ctx *ctx);
> +bool io_run_local_work(struct io_ring_ctx *ctx, bool locked);
>   void io_req_complete_failed(struct io_kiocb *req, s32 res);
>   void __io_req_complete(struct io_kiocb *req, unsigned issue_flags);
>   void io_req_complete_post(struct io_kiocb *req);
> @@ -234,6 +235,33 @@ static inline bool io_run_task_work(void)
>   	return false;
>   }
>   
> +static inline bool io_run_task_work_ctx(struct io_ring_ctx *ctx, bool all)
> +{
> +	bool ret = false;

I'd rather prefer to have two inlined back to back calls like

io_run_local_work();
io_run_task_work();

instead of passing true/false, which are always confusing.


> +
> +	if (ctx->flags & IORING_SETUP_DEFER_TASKRUN) {
> +		ret = io_run_local_work(ctx, false);
> +		if (!all)
> +			return ret;
> +	}
> +	ret  |= io_run_task_work();
> +	return ret;
> +}
> +
> +static inline bool io_run_task_work_unlock_ctx(struct io_ring_ctx *ctx)
> +{
> +	bool ret;
> +
> +	if (ctx->flags & IORING_SETUP_DEFER_TASKRUN) {
> +		ret = io_run_local_work(ctx, true);
> +	} else {
> +		mutex_unlock(&ctx->uring_lock);
> +		ret = io_run_task_work();
> +	}
> +
> +	return ret;
> +}
> +
>   static inline void io_tw_lock(struct io_ring_ctx *ctx, bool *locked)
>   {
>   	if (!*locked) {
> diff --git a/io_uring/rsrc.c b/io_uring/rsrc.c
> index 71359a4d0bd4..80cda6e2067f 100644
> --- a/io_uring/rsrc.c
> +++ b/io_uring/rsrc.c
> @@ -343,7 +343,7 @@ __cold static int io_rsrc_ref_quiesce(struct io_rsrc_data *data,
>   		flush_delayed_work(&ctx->rsrc_put_work);
>   		reinit_completion(&data->done);
>   
> -		ret = io_run_task_work_sig();
> +		ret = io_run_task_work_sig(ctx);
>   		mutex_lock(&ctx->uring_lock);
>   	} while (ret >= 0);
>   	data->quiesce = false;

-- 
Pavel Begunkov
