Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id EEE395A434C
	for <lists+io-uring@lfdr.de>; Mon, 29 Aug 2022 08:33:05 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229711AbiH2GdE (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Mon, 29 Aug 2022 02:33:04 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:42910 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229446AbiH2GdE (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Mon, 29 Aug 2022 02:33:04 -0400
Received: from out0.migadu.com (out0.migadu.com [94.23.1.103])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 0E0B82DAB4
        for <io-uring@vger.kernel.org>; Sun, 28 Aug 2022 23:33:02 -0700 (PDT)
Message-ID: <370dd3d4-1f54-279c-3d6a-8c9f8473a80a@linux.dev>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linux.dev; s=key1;
        t=1661754780;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=ilinHGb2aX72TP7T44l6a/PfbrrUgN3ojDLIu4adnlg=;
        b=aqlPDuWnOlRmK9VGVhuXK/Qgkz2S9BHYz6EXSAmgN68GvWGy3fUgitYnqW6w+LATWpPz7C
        cWrrv5QkTG40XeOiCqJS6DZ8OOhLL1f7hh5q3qtsm2kFHzpVRrD5iJqTI9ez8o/poUnz5K
        AF3nOhD7/apIC8YqRH2sdxjF66OMLYU=
Date:   Mon, 29 Aug 2022 14:32:49 +0800
MIME-Version: 1.0
Subject: Re: [PATCH for-next v3 4/7] io_uring: add IORING_SETUP_DEFER_TASKRUN
Content-Language: en-US
To:     Pavel Begunkov <asml.silence@gmail.com>,
        Dylan Yudaken <dylany@fb.com>, Jens Axboe <axboe@kernel.dk>,
        io-uring@vger.kernel.org
Cc:     Kernel-team@fb.com
References: <20220819121946.676065-1-dylany@fb.com>
 <20220819121946.676065-5-dylany@fb.com>
 <d3ad2512-ab06-1a56-6394-0dc4a62f0028@gmail.com>
X-Report-Abuse: Please report any abuse attempt to abuse@migadu.com and include these headers.
From:   Hao Xu <hao.xu@linux.dev>
In-Reply-To: <d3ad2512-ab06-1a56-6394-0dc4a62f0028@gmail.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit
X-Migadu-Flow: FLOW_OUT
X-Migadu-Auth-User: linux.dev
X-Spam-Status: No, score=-2.8 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_LOW,SPF_HELO_PASS,
        SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no
        version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org

On 8/22/22 19:34, Pavel Begunkov wrote:
> On 8/19/22 13:19, Dylan Yudaken wrote:
>> Allow deferring async tasks until the user calls io_uring_enter(2) with
>> the IORING_ENTER_GETEVENTS flag. Enable this mode with a flag at
>> io_uring_setup time. This functionality requires that the later
>> io_uring_enter will be called from the same submission task, and 
>> therefore
>> restrict this flag to work only when IORING_SETUP_SINGLE_ISSUER is also
>> set.
> 
> Looks ok, a couple of small comments below, but I don't see anything
> blocking it.
> 
>> Being able to hand pick when tasks are run prevents the problem where
>> there is current work to be done, however task work runs anyway.
>>
>> For example, a common workload would obtain a batch of CQEs, and process
>> each one. Interrupting this to additional taskwork would add latency but
>> not gain anything. If instead task work is deferred to just before more
>> CQEs are obtained then no additional latency is added.
>>
>> The way this is implemented is by trying to keep task work local to a
>> io_ring_ctx, rather than to the submission task. This is required, as the
>> application will want to wake up only a single io_ring_ctx at a time to
>> process work, and so the lists of work have to be kept separate.
>>
>> This has some other benefits like not having to check the task 
>> continually
>> in handle_tw_list (and potentially unlocking/locking those), and reducing
>> locks in the submit & process completions path.
>>
>> There are networking cases where using this option can reduce request
>> latency by 50%. For example a contrived example using [1] where the 
>> client
>> sends 2k data and receives the same data back while doing some system
>> calls (to trigger task work) shows this reduction. The reason ends up
>> being that if sending responses is delayed by processing task work, then
>> the client side sits idle. Whereas reordering the sends first means that
>> the client runs it's workload in parallel with the local task work.
> 
> Quite contrived, for some it may cut latency in half but for others
> as easily increate it twofold. In any case, it's not a critique of the
> feature as it's optional, but rather raises a question whether we
> need to add some fairness / scheduling here.
> 
>> [1]:
>> Using https://github.com/DylanZA/netbench/tree/defer_run
>> Client:
>> ./netbench  --client_only 1 --control_port 10000 --host <host> --tx 
>> "epoll --threads 16 --per_thread 1 --size 2048 --resp 2048 --workload 
>> 1000"
>> Server:
>> ./netbench  --server_only 1 --control_port 10000  --rx "io_uring 
>> --defer_taskrun 0 --workload 100"   --rx "io_uring  --defer_taskrun 1 
>> --workload 100"
>>
>> Signed-off-by: Dylan Yudaken <dylany@fb.com>
>> ---
> 
>> diff --git a/io_uring/io_uring.c b/io_uring/io_uring.c
>> index 53696dd90626..6572d2276750 100644
>> --- a/io_uring/io_uring.c
>> +++ b/io_uring/io_uring.c
> [...]
> 
>> +int io_run_local_work(struct io_ring_ctx *ctx, bool locked)
>> +{
>> +    struct llist_node *node;
>> +    struct llist_node fake;
>> +    struct llist_node *current_final = NULL;
>> +    int ret;
>> +
>> +    if (unlikely(ctx->submitter_task != current)) {
>> +        if (locked)
>> +            mutex_unlock(&ctx->uring_lock);
>> +
>> +        /* maybe this is before any submissions */
>> +        if (!ctx->submitter_task)
>> +            return 0;
>> +
>> +        return -EEXIST;
>> +    }
>> +
>> +    if (!locked)
>> +        locked = mutex_trylock(&ctx->uring_lock);
>> +
>> +    node = io_llist_xchg(&ctx->work_llist, &fake);
>> +    ret = 0;
>> +again:
>> +    while (node != current_final) {
>> +        struct llist_node *next = node->next;
>> +        struct io_kiocb *req = container_of(node, struct io_kiocb,
>> +                            io_task_work.node);
>> +        prefetch(container_of(next, struct io_kiocb, 
>> io_task_work.node));
>> +        req->io_task_work.func(req, &locked);
>> +        ret++;
>> +        node = next;
>> +    }
>> +
>> +    if (ctx->flags & IORING_SETUP_TASKRUN_FLAG)
>> +        atomic_andnot(IORING_SQ_TASKRUN, &ctx->rings->sq_flags);
>> +
>> +    node = io_llist_cmpxchg(&ctx->work_llist, &fake, NULL);
>> +    if (node != &fake) {
>> +        current_final = &fake;
>> +        node = io_llist_xchg(&ctx->work_llist, &fake);
>> +        goto again;
>> +    }
>> +
>> +    if (locked) {
>> +        io_submit_flush_completions(ctx);
>> +        mutex_unlock(&ctx->uring_lock);
>> +    }
>> +    return ret;
>> +}
> 
> I was thinking about:
> 
> int io_run_local_work(struct io_ring_ctx *ctx, bool *locked)
> {
>      locked = try_lock();
> }
> 
> bool locked = false;
> io_run_local_work(ctx, *locked);
> if (locked)
>      unlock();
> 
> // or just as below when already holding it
> bool locked = true;
> io_run_local_work(ctx, *locked);
> 
> Which would replace
> 
> if (DEFER) {
>      // we're assuming that it'll unlock
>      io_run_local_work(true);
> } else {
>      unlock();
> }
> 
> with
> 
> if (DEFER) {
>      bool locked = true;
>      io_run_local_work(&locked);
> }
> unlock();
> 
> But anyway, it can be mulled later.
> 
> 
>> -int io_run_task_work_sig(void)
>> +int io_run_task_work_sig(struct io_ring_ctx *ctx)
>>   {
>> -    if (io_run_task_work())
>> +    if (io_run_task_work_ctx(ctx))
>>           return 1;
>>       if (task_sigpending(current))
>>           return -EINTR;
>> @@ -2196,7 +2294,7 @@ static inline int io_cqring_wait_schedule(struct 
>> io_ring_ctx *ctx,
>>       unsigned long check_cq;
>>       /* make sure we run task_work before checking for signals */
>> -    ret = io_run_task_work_sig();
>> +    ret = io_run_task_work_sig(ctx);
>>       if (ret || io_should_wake(iowq))
>>           return ret;
>> @@ -2230,7 +2328,7 @@ static int io_cqring_wait(struct io_ring_ctx 
>> *ctx, int min_events,
>>           io_cqring_overflow_flush(ctx);
>>           if (io_cqring_events(ctx) >= min_events)
>>               return 0;
>> -        if (!io_run_task_work())
>> +        if (!io_run_task_work_ctx(ctx))
>>               break;
>>       } while (1);
>> @@ -2573,6 +2671,9 @@ static __cold void io_ring_exit_work(struct 
>> work_struct *work)
>>        * as nobody else will be looking for them.
>>        */
>>       do {
>> +        if (ctx->flags & IORING_SETUP_DEFER_TASKRUN)
>> +            io_move_task_work_from_local(ctx);
>> +
>>           while (io_uring_try_cancel_requests(ctx, NULL, true))
>>               cond_resched();
>> @@ -2768,6 +2869,8 @@ static __cold bool 
>> io_uring_try_cancel_requests(struct io_ring_ctx *ctx,
>>           }
>>       }
>> +    if (ctx->flags & IORING_SETUP_DEFER_TASKRUN)
>> +        ret |= io_run_local_work(ctx, false) > 0;
>>       ret |= io_cancel_defer_files(ctx, task, cancel_all);
>>       mutex_lock(&ctx->uring_lock);
>>       ret |= io_poll_remove_all(ctx, task, cancel_all);
>> @@ -3057,10 +3160,20 @@ SYSCALL_DEFINE6(io_uring_enter, unsigned int, 
>> fd, u32, to_submit,
>>           }
>>           if ((flags & IORING_ENTER_GETEVENTS) && ctx->syscall_iopoll)
>>               goto iopoll_locked;
>> +        if ((flags & IORING_ENTER_GETEVENTS) &&
>> +            (ctx->flags & IORING_SETUP_DEFER_TASKRUN)) {
>> +            int ret2 = io_run_local_work(ctx, true);
>> +
>> +            if (unlikely(ret2 < 0))
>> +                goto out;
> 
> It's an optimisation and we don't have to handle errors here,
> let's ignore them and make it looking a bit better.
> 
>> +            goto getevents_ran_local;
>> +        }
>>           mutex_unlock(&ctx->uring_lock);
>>       }
>> +
>>       if (flags & IORING_ENTER_GETEVENTS) {
>>           int ret2;
>> +
>>           if (ctx->syscall_iopoll) {
>>               /*
>>                * We disallow the app entering submit/complete with
>> @@ -3081,6 +3194,12 @@ SYSCALL_DEFINE6(io_uring_enter, unsigned int, 
>> fd, u32, to_submit,
>>               const sigset_t __user *sig;
>>               struct __kernel_timespec __user *ts;
>> +            if (ctx->flags & IORING_SETUP_DEFER_TASKRUN) {
> 
> I think it should be in io_cqring_wait(), which calls it anyway
> in the beginning. Instead of
> 
>      do {
>          io_cqring_overflow_flush(ctx);
>          if (io_cqring_events(ctx) >= min_events)
>              return 0;
>          if (!io_run_task_work())
>              break;
>      } while (1);
> 
> Let's have
> 
>      do {
>          ret = io_run_task_work_ctx();
>          // handle ret
>          io_cqring_overflow_flush(ctx);
>          if (io_cqring_events(ctx) >= min_events)
>              return 0;
>      } while (1);
> 
>> +                ret2 = io_run_local_work(ctx, false);
>> +                if (unlikely(ret2 < 0))
>> +                    goto getevents_out;
>> +            }
>> +getevents_ran_local:
>>               ret2 = io_get_ext_arg(flags, argp, &argsz, &ts, &sig);
>>               if (likely(!ret2)) {
>>                   min_complete = min(min_complete,
>> @@ -3090,6 +3209,7 @@ SYSCALL_DEFINE6(io_uring_enter, unsigned int, 
>> fd, u32, to_submit,
>>               }
>>           }
>> +getevents_out:
>>           if (!ret) {
>>               ret = ret2;
>> @@ -3289,17 +3409,29 @@ static __cold int io_uring_create(unsigned 
>> entries, struct io_uring_params *p,
>>       if (ctx->flags & IORING_SETUP_SQPOLL) {
>>           /* IPI related flags don't make sense with SQPOLL */
>>           if (ctx->flags & (IORING_SETUP_COOP_TASKRUN |
>> -                  IORING_SETUP_TASKRUN_FLAG))
>> +                  IORING_SETUP_TASKRUN_FLAG |
>> +                  IORING_SETUP_DEFER_TASKRUN))
> 
> Sounds like we should also fail if SQPOLL is set, especially with
> the task check on the waiting side.

sqpoll as a natural single issuer case, shouldn't we support this
feature for it? And surely, in that case, don't do local task work check
in cqring wait time and be careful in other places like
io_uring_register

> 
>>               goto err;
>>           ctx->notify_method = TWA_SIGNAL_NO_IPI;
>>       } else if (ctx->flags & IORING_SETUP_COOP_TASKRUN) {
>>           ctx->notify_method = TWA_SIGNAL_NO_IPI;
> [...]
>>       mutex_lock(&ctx->uring_lock);
>>       ret = __io_uring_register(ctx, opcode, arg, nr_args);
>> diff --git a/io_uring/io_uring.h b/io_uring/io_uring.h
>> index 2f73f83af960..a9fb115234af 100644
>> --- a/io_uring/io_uring.h
>> +++ b/io_uring/io_uring.h
>> @@ -26,7 +26,8 @@ enum {
> [...]
>> +static inline int io_run_task_work_unlock_ctx(struct io_ring_ctx *ctx)
>> +{
>> +    int ret;
>> +
>> +    if (ctx->flags & IORING_SETUP_DEFER_TASKRUN) {
>> +        ret = io_run_local_work(ctx, true);
>> +    } else {
>> +        mutex_unlock(&ctx->uring_lock);
>> +        ret = (int)io_run_task_work();
> 
> Why do we need a cast? let's keep the return type same
> 
> 

