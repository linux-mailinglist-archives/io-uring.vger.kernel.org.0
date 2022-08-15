Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 2F5FE59306B
	for <lists+io-uring@lfdr.de>; Mon, 15 Aug 2022 16:03:09 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S242620AbiHOODH (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Mon, 15 Aug 2022 10:03:07 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:46850 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S242584AbiHOODG (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Mon, 15 Aug 2022 10:03:06 -0400
Received: from mail-wm1-x334.google.com (mail-wm1-x334.google.com [IPv6:2a00:1450:4864:20::334])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 4E53422BEB
        for <io-uring@vger.kernel.org>; Mon, 15 Aug 2022 07:03:04 -0700 (PDT)
Received: by mail-wm1-x334.google.com with SMTP id c187-20020a1c35c4000000b003a30d88fe8eso7858009wma.2
        for <io-uring@vger.kernel.org>; Mon, 15 Aug 2022 07:03:04 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=content-transfer-encoding:in-reply-to:from:references:cc:to
         :content-language:subject:user-agent:mime-version:date:message-id
         :from:to:cc;
        bh=jyGL9tdIMKzpqKFpTE58cgLD1NfNrFqYfmLGeEc5q8A=;
        b=ok31S46c9y49hQaZ5ld/e8Sq13kkBxNgJD93CgilWESgVz2W9JFRrN56VyxO1MB9Ko
         tkOL20aU32VTy4xP4xNJcBYKsaQCzoVfKoTbsTQ8KWeJvG89j95NwPm/pUaT6bww8TGp
         SFriMnvolT1GtAsY1aiCLm5oo5fIfYGXze7UJoXgngNgEAJszkM0jbKbLsEUjCa4GXS7
         ZJaxJOTLrYWmWAVTPOSqrislzQ7lBdE/Cq6r+mHDppJOpqK0G9E2fHY4GcwrDyMNs/EW
         vXhsEly3s7EO2+7eszhb8fiFKXGXIfQ54J46ReMerXEDX1EwDe+HwzuTTomIj3MnF4yi
         LYZQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=content-transfer-encoding:in-reply-to:from:references:cc:to
         :content-language:subject:user-agent:mime-version:date:message-id
         :x-gm-message-state:from:to:cc;
        bh=jyGL9tdIMKzpqKFpTE58cgLD1NfNrFqYfmLGeEc5q8A=;
        b=s0s+Tb5jpurUzDeNgv1LNW3h6KtoP/TUdmCGuJvQ3cgt3rFK2CL4eakUcwZN8pukoG
         plt0epvOaOAgH8xVq7V0HXTXSDH09uZ3UUzlsjCqjRFAoZTle2qhPEedIfdigOihqApg
         9LZZLbtHQ3okVFO8iJ+W3Goii8vG5Eh2Ji2zY2Hm0KqcxvokCacMgZsIPB3B+DixsUW9
         DSZWEV5vpalwDopBTuZhVb5Zkvx9HmscbG0s1hiAOfSYzUH45KgEtqsKK7wUuyZwCRnr
         i/h38jfHx/evJk6R5aFk1qSO4Hi5jCoZdI3dJYFTpMIHr8Bgbj07J5fotmoZia0I8n9b
         cpCA==
X-Gm-Message-State: ACgBeo2EgkZ12OKqvpKqIBIiW2ob4MiM4cP6XhllpXJbAg9NHVGNWoG+
        w3WtFKDBiFZ5GT9hpaK3uNA=
X-Google-Smtp-Source: AA6agR7bRKV3R11CVbUzVpq2CZ4k7672WcLTlzhmSBc04t+4eKnHF6Y4ZTuNXheO7wKprFZ2xLLcDg==
X-Received: by 2002:a05:600c:27cb:b0:3a5:cd14:269d with SMTP id l11-20020a05600c27cb00b003a5cd14269dmr9424835wmb.128.1660572182529;
        Mon, 15 Aug 2022 07:03:02 -0700 (PDT)
Received: from ?IPV6:2620:10d:c096:310::22ef? ([2620:10d:c092:600::2:886])
        by smtp.gmail.com with ESMTPSA id b21-20020a05600c4e1500b003a50924f1c0sm9516411wmq.18.2022.08.15.07.03.01
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Mon, 15 Aug 2022 07:03:02 -0700 (PDT)
Message-ID: <d86f4994-cc30-720f-8fa7-3a5a11508a57@gmail.com>
Date:   Mon, 15 Aug 2022 15:02:01 +0100
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:91.0) Gecko/20100101
 Thunderbird/91.11.0
Subject: Re: [PATCH for-next 5/7] io_uring: add IORING_SETUP_DEFER_TASKRUN
Content-Language: en-US
To:     Dylan Yudaken <dylany@fb.com>, Jens Axboe <axboe@kernel.dk>,
        io-uring@vger.kernel.org
Cc:     Kernel-team@fb.com
References: <20220815130911.988014-1-dylany@fb.com>
 <20220815130911.988014-6-dylany@fb.com>
From:   Pavel Begunkov <asml.silence@gmail.com>
In-Reply-To: <20220815130911.988014-6-dylany@fb.com>
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

On 8/15/22 14:09, Dylan Yudaken wrote:
> Allow deferring async tasks until the user calls io_uring_enter(2) with
> the IORING_ENTER_GETEVENTS flag.
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
>   io_uring/io_uring.c            | 125 ++++++++++++++++++++++++++++-----
>   io_uring/io_uring.h            |  31 +++++++-
>   io_uring/rsrc.c                |   2 +-
>   6 files changed, 148 insertions(+), 21 deletions(-)
> 
[...]
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
> @@ -1074,6 +1093,69 @@ void io_req_task_work_add(struct io_kiocb *req)
>   	}
>   }
>   
> +void io_req_task_work_add(struct io_kiocb *req)
> +{
> +	__io_req_task_work_add(req, true);
> +}
> +
> +static void __cold io_move_task_work_from_local(struct io_ring_ctx *ctx)
> +{
> +	struct llist_node *node;
> +
> +	node = llist_del_all(&ctx->work_llist);
> +	while (node) {
> +		struct io_kiocb *req = container_of(node, struct io_kiocb,
> +						    io_task_work.node);
> +
> +		node = node->next;
> +		__io_req_task_work_add(req, false);
> +	}
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
> +		if (unlikely(!same_thread_group(req->task, current))) {

Not same thread group, they have to be executed by the same thread.
One of the assumptions is that current->io_uring is the same
as the request was initialised with.

> +			__io_req_task_work_add(req, false);

Why do we mix local and normal tw in the same ring? I think we
need to do either one or another. What is blocking it?

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
> @@ -1284,8 +1366,7 @@ static int io_iopoll_check(struct io_ring_ctx *ctx, long min)
>   		if (wq_list_empty(&ctx->iopoll_list)) {
>   			u32 tail = ctx->cached_cq_tail;
>   
> -			mutex_unlock(&ctx->uring_lock);
> -			io_run_task_work();
> +			io_run_task_work_unlock_ctx(ctx);
>   			mutex_lock(&ctx->uring_lock);
>   
>   			/* some requests don't go through iopoll_list */
> @@ -2146,7 +2227,9 @@ struct io_wait_queue {
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
> @@ -2178,9 +2261,9 @@ static int io_wake_function(struct wait_queue_entry *curr, unsigned int mode,
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
> @@ -2196,7 +2279,7 @@ static inline int io_cqring_wait_schedule(struct io_ring_ctx *ctx,
>   	unsigned long check_cq;
>   
>   	/* make sure we run task_work before checking for signals */
> -	ret = io_run_task_work_sig();
> +	ret = io_run_task_work_sig(ctx);
>   	if (ret || io_should_wake(iowq))
>   		return ret;
>   
> @@ -2230,7 +2313,7 @@ static int io_cqring_wait(struct io_ring_ctx *ctx, int min_events,
>   		io_cqring_overflow_flush(ctx);
>   		if (io_cqring_events(ctx) >= min_events)
>   			return 0;
> -		if (!io_run_task_work())
> +		if (!io_run_task_work_ctx(ctx, false))
>   			break;
>   	} while (1);
>   
> @@ -2768,13 +2851,14 @@ static __cold bool io_uring_try_cancel_requests(struct io_ring_ctx *ctx,
>   		}
>   	}
>   
> +	io_move_task_work_from_local(ctx);

Why do we even need to move them? Isn't it easier to just
execute them here?

>   	ret |= io_cancel_defer_files(ctx, task, cancel_all);
>   	mutex_lock(&ctx->uring_lock);
>   	ret |= io_poll_remove_all(ctx, task, cancel_all);
>   	mutex_unlock(&ctx->uring_lock);
>   	ret |= io_kill_timeouts(ctx, task, cancel_all);
>   	if (task)
> -		ret |= io_run_task_work();
> +		ret |= io_run_task_work_ctx(ctx, true);
>   	return ret;
>   }
>   
> @@ -2837,7 +2921,7 @@ __cold void io_uring_cancel_generic(bool cancel_all, struct io_sq_data *sqd)
>   		}
>   
>   		prepare_to_wait(&tctx->wait, &wait, TASK_INTERRUPTIBLE);
> -		io_run_task_work();
> +		io_run_task_work_ctx(ctx, true);
>   		io_uring_drop_tctx_refs(current);
>   
>   		/*
> @@ -3055,12 +3139,15 @@ SYSCALL_DEFINE6(io_uring_enter, unsigned int, fd, u32, to_submit,
>   			mutex_unlock(&ctx->uring_lock);
>   			goto out;
>   		}
> -		if ((flags & IORING_ENTER_GETEVENTS) && ctx->syscall_iopoll)
> +
> +		if (!(flags & IORING_ENTER_GETEVENTS))
> +			mutex_unlock(&ctx->uring_lock);
> +		else if (ctx->syscall_iopoll)
>   			goto iopoll_locked;
> -		mutex_unlock(&ctx->uring_lock);
> -		io_run_task_work();
> +		else
> +			io_run_task_work_unlock_ctx(ctx);

Let's unroll this function and get rid of conditional
locking, especially since you don't need the io_run_task_work()
part here.

>   	} else {
> -		io_run_task_work();
> +		io_run_task_work_ctx(ctx, false);
>   	}
>   
...
> --- a/io_uring/io_uring.h
> +++ b/io_uring/io_uring.h
> @@ -26,7 +26,8 @@ enum {
>   
...
>   
> +static inline bool io_run_task_work_ctx(struct io_ring_ctx *ctx, bool all)
> +{
> +	bool ret = false;
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
> +		mutex_unlock(&ctx->uring_lock);

If I read it right, io_run_local_work(locked=true) will
release the lock, and then we unlock it a second time
here. I'd suggest moving conditional locking out
of io_run_local_work().

> +	} else {
> +		mutex_unlock(&ctx->uring_lock);
> +		ret = io_run_task_work();
> +	}
> +
> +	return ret;
> +}
> +

-- 
Pavel Begunkov
