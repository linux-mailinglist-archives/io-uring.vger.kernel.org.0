Return-Path: <io-uring+bounces-2899-lists+io-uring=lfdr.de@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [IPv6:2604:1380:45e3:2400::1])
	by mail.lfdr.de (Postfix) with ESMTPS id A8C8095BAA2
	for <lists+io-uring@lfdr.de>; Thu, 22 Aug 2024 17:38:03 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 5CC7728319C
	for <lists+io-uring@lfdr.de>; Thu, 22 Aug 2024 15:38:02 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 1CEE21CB30F;
	Thu, 22 Aug 2024 15:38:00 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel-dk.20230601.gappssmtp.com header.i=@kernel-dk.20230601.gappssmtp.com header.b="lCneMQex"
X-Original-To: io-uring@vger.kernel.org
Received: from mail-io1-f49.google.com (mail-io1-f49.google.com [209.85.166.49])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4483B1CB30A
	for <io-uring@vger.kernel.org>; Thu, 22 Aug 2024 15:37:56 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.166.49
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1724341080; cv=none; b=T20FBjFy07y15voSzWdV/i+lSM12h5v/E6aeBkr1AcwVYiJVr0t5yf92BH+oJEpBbanRSEBc6jrGqLqx4eQIxVogJ4TAeFO+IZC3iS5lvS4+mEKXbHh9tbz8o8OklXkJdDaQuuWzfoXspGl3vyzxvqQx24IuM0RBEDFkQ5FHNiE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1724341080; c=relaxed/simple;
	bh=RkQ1c7KQMylpwk9AuaZqzeiKd8qD86nAGdzCEsgAQB4=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=UGvS3bNpXigQQaprdG/799HILfdeVqqRWSAKu1vTCmtXJv81ai89oNWssKnNY+FKVbicpwZ1TXJFCU6j9La+h3cUcB4jywsBdpHSteOUXdLRNWpmuaaDFbRWcRjYLGVd6j3ZSdo7LLzaMmIII1tdHgPtcbya2t6g0Oj3Yempsgo=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=kernel.dk; spf=pass smtp.mailfrom=kernel.dk; dkim=pass (2048-bit key) header.d=kernel-dk.20230601.gappssmtp.com header.i=@kernel-dk.20230601.gappssmtp.com header.b=lCneMQex; arc=none smtp.client-ip=209.85.166.49
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=kernel.dk
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=kernel.dk
Received: by mail-io1-f49.google.com with SMTP id ca18e2360f4ac-824ee14f7bfso37806039f.1
        for <io-uring@vger.kernel.org>; Thu, 22 Aug 2024 08:37:56 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernel-dk.20230601.gappssmtp.com; s=20230601; t=1724341076; x=1724945876; darn=vger.kernel.org;
        h=content-transfer-encoding:in-reply-to:from:content-language
         :references:cc:to:subject:user-agent:mime-version:date:message-id
         :from:to:cc:subject:date:message-id:reply-to;
        bh=igdKczjvnTZx/5C5QAFETm2pZ8y9m4bCQeyI2c9T24U=;
        b=lCneMQexYWgjrOKjuZfUt7U99wQw/ZmDWVqyOwRuGayRoqjc8wkYXtaXOLxQGz2Y+e
         IVwZhTBligh29KY069hWzbN4rs2X4Exl3UvxZb8j/2SfHgcb777ESrHIbSru0v6ESKhd
         AJAy+/EwQSHTmXHwXMVYsjShYB/EAGmbV0jlWM54ezZgOX2dC6wuOEBM1gK6kwahYu8I
         TttFtBMSQflyTx23FnfAF+O38WePUDZu8KJQZ8B7CTdEfAB8FdQIu/HIFhGnhOAv56gu
         gVuk0VvP4hTjHRqOSP2cK0jJxVEBgvWDAh+/RuQ5TYwbYv3MTu8erv/AXKxePUgtAULd
         mOKQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1724341076; x=1724945876;
        h=content-transfer-encoding:in-reply-to:from:content-language
         :references:cc:to:subject:user-agent:mime-version:date:message-id
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=igdKczjvnTZx/5C5QAFETm2pZ8y9m4bCQeyI2c9T24U=;
        b=Ljz4Vx09pobq0S0k7U4c+qbllTx2N8VZUAiVdcb6oLJiYDaS9uRLA4RGDKeBQ4pdML
         c/k+NiV304c06ZQeKJIjT1eDo9vzaNdXjOdt0ZFa/IXEAc2RcNNLaEpSmUcpw0bG14y4
         zrsaHbOvnWOwdbR+GKLaigw/WW1nuPMNMcQ5eXrapbvY6kWGg3kVBTia2fhgs+dlDUd4
         kQbiqm7GqpmdxKiWMr9OeIh+uvOqpZEmDaNcbcuzhDggDmpucQJV1yAwlLtZwjKc25IR
         KOZ602JK3ZX+fjrC/PpxPmSeyC/0hwipQB0TrcoL6+o0Wk/18DMtae8FpPkjgD1cCs48
         lY6A==
X-Forwarded-Encrypted: i=1; AJvYcCXfwF8Ox+fJwFvBAE5sfQYHKmPn84Ub2UrbYSFh1UccRf2cQD/t78EUWEoeD5ayo5zknocEuH0n3g==@vger.kernel.org
X-Gm-Message-State: AOJu0Yw+ssVbOh82xfdxWXtfQjUdz5KnPWvs+qovQbMsA4imJ9wCNebf
	Bmrq2Ir6cH4eXa/GwdIeRJuiS6o3LR2jdvSKyLaxwXUygFtMNDn5qfNU7sQ7QeliFJnnTZEvYbw
	w
X-Google-Smtp-Source: AGHT+IF6iZEVNw3ORqcMLrlyFwe5nQEh4vSYN5Ou4WqpXiUXT7NWQozJ7z9Nb8381G1mGYSLnvNmGg==
X-Received: by 2002:a05:6602:6c07:b0:7f6:84b0:23d0 with SMTP id ca18e2360f4ac-825318bacf3mr637113739f.7.1724341076126;
        Thu, 22 Aug 2024 08:37:56 -0700 (PDT)
Received: from [192.168.1.116] ([96.43.243.2])
        by smtp.gmail.com with ESMTPSA id ca18e2360f4ac-8253d5aa4e8sm60790639f.6.2024.08.22.08.37.55
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Thu, 22 Aug 2024 08:37:55 -0700 (PDT)
Message-ID: <fbb24fa4-3efe-4344-a4b9-982710e9454b@kernel.dk>
Date: Thu, 22 Aug 2024 09:37:54 -0600
Precedence: bulk
X-Mailing-List: io-uring@vger.kernel.org
List-Id: <io-uring.vger.kernel.org>
List-Subscribe: <mailto:io-uring+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:io-uring+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH 4/5] io_uring: add support for batch wait timeout
To: Pavel Begunkov <asml.silence@gmail.com>, io-uring@vger.kernel.org
Cc: dw@davidwei.uk
References: <20240821141910.204660-1-axboe@kernel.dk>
 <20240821141910.204660-5-axboe@kernel.dk>
 <ca995b4b-9dc3-4035-88ac-a22c690f09d0@gmail.com>
Content-Language: en-US
From: Jens Axboe <axboe@kernel.dk>
In-Reply-To: <ca995b4b-9dc3-4035-88ac-a22c690f09d0@gmail.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit

On 8/22/24 7:46 AM, Pavel Begunkov wrote:
> On 8/21/24 15:16, Jens Axboe wrote:
>> Waiting for events with io_uring has two knobs that can be set:
>>
>> 1) The number of events to wake for
>> 2) The timeout associated with the event
>>
>> Waiting will abort when either of those conditions are met, as expected.
>>
>> This adds support for a third event, which is associated with the number
>> of events to wait for. Applications generally like to handle batches of
>> completions, and right now they'd set a number of events to wait for and
>> the timeout for that. If no events have been received but the timeout
>> triggers, control is returned to the application and it can wait again.
>> However, if the application doesn't have anything to do until events are
>> reaped, then it's possible to make this waiting more efficient.
>>
>> For example, the application may have a latency time of 50 usecs and
>> wanting to handle a batch of 8 requests at the time. If it uses 50 usecs
>> as the timeout, then it'll be doing 20K context switches per second even
>> if nothing is happening.
>>
>> This introduces the notion of min batch wait time. If the min batch wait
>> time expires, then we'll return to userspace if we have any events at all.
>> If none are available, the general wait time is applied. Any request
>> arriving after the min batch wait time will cause waiting to stop and
>> return control to the application.
>>
>> Signed-off-by: Jens Axboe <axboe@kernel.dk>
>> ---
>>   io_uring/io_uring.c | 88 ++++++++++++++++++++++++++++++++++++++-------
>>   io_uring/io_uring.h |  2 ++
>>   2 files changed, 77 insertions(+), 13 deletions(-)
>>
>> diff --git a/io_uring/io_uring.c b/io_uring/io_uring.c
>> index 4ba5292137c3..87e7cf6551d7 100644
>> --- a/io_uring/io_uring.c
>> +++ b/io_uring/io_uring.c
>> @@ -2322,7 +2322,8 @@ static int io_wake_function(struct wait_queue_entry *curr, unsigned int mode,
>>        * Cannot safely flush overflowed CQEs from here, ensure we wake up
>>        * the task, and the next invocation will do it.
>>        */
>> -    if (io_should_wake(iowq) || io_has_work(iowq->ctx) || iowq->hit_timeout)
>> +    if (io_should_wake(iowq) || io_has_work(iowq->ctx) ||
>> +        READ_ONCE(iowq->hit_timeout))
>>           return autoremove_wake_function(curr, mode, wake_flags, key);
>>       return -1;
>>   }
>> @@ -2359,13 +2360,66 @@ static enum hrtimer_restart io_cqring_timer_wakeup(struct hrtimer *timer)
>>       return HRTIMER_NORESTART;
>>   }
>>   +/*
>> + * Doing min_timeout portion. If we saw any timeouts, events, or have work,
>> + * wake up. If not, and we have a normal timeout, switch to that and keep
>> + * sleeping.
>> + */
>> +static enum hrtimer_restart io_cqring_min_timer_wakeup(struct hrtimer *timer)
>> +{
>> +    struct io_wait_queue *iowq = container_of(timer, struct io_wait_queue, t);
>> +    struct io_ring_ctx *ctx = iowq->ctx;
>> +
>> +    /* no general timeout, or shorter, we are done */
>> +    if (iowq->timeout == KTIME_MAX ||
>> +        ktime_after(iowq->min_timeout, iowq->timeout))
>> +        goto out_wake;
>> +    /* work we may need to run, wake function will see if we need to wake */
>> +    if (io_has_work(ctx))
>> +        goto out_wake;
>> +    /* got events since we started waiting, min timeout is done */
>> +    if (iowq->cq_min_tail != READ_ONCE(ctx->rings->cq.tail))
>> +        goto out_wake;
>> +    /* if we have any events and min timeout expired, we're done */
>> +    if (io_cqring_events(ctx))
>> +        goto out_wake;
>> +
>> +    /*
>> +     * If using deferred task_work running and application is waiting on
>> +     * more than one request, ensure we reset it now where we are switching
>> +     * to normal sleeps. Any request completion post min_wait should wake
>> +     * the task and return.
>> +     */
>> +    if (ctx->flags & IORING_SETUP_DEFER_TASKRUN) {
>> +        atomic_set(&ctx->cq_wait_nr, 1);
>> +        smp_mb();
>> +        if (!llist_empty(&ctx->work_llist))
>> +            goto out_wake;
>> +    }
>> +
>> +    iowq->t.function = io_cqring_timer_wakeup;
>> +    hrtimer_set_expires(timer, iowq->timeout);
>> +    return HRTIMER_RESTART;
>> +out_wake:
>> +    return io_cqring_timer_wakeup(timer);
>> +}
>> +
>>   static int io_cqring_schedule_timeout(struct io_wait_queue *iowq,
>> -                      clockid_t clock_id)
>> +                      clockid_t clock_id, ktime_t start_time)
>>   {
>> -    iowq->hit_timeout = 0;
>> +    ktime_t timeout;
>> +
>> +    WRITE_ONCE(iowq->hit_timeout, 0);
>>       hrtimer_init_on_stack(&iowq->t, clock_id, HRTIMER_MODE_ABS);
>> -    iowq->t.function = io_cqring_timer_wakeup;
>> -    hrtimer_set_expires_range_ns(&iowq->t, iowq->timeout, 0);
>> +    if (iowq->min_timeout) {
> 
> What's the default, 0 or KTIME_MAX? __io_cqring_wait_schedule()
> checks KTIME_MAX instead.

In practice either one works, but let's keep it consistent - since it's
a relative value (eg you ask for xx usec), I'll change the one that
checks for KTIME_MAX to just check if it's set.

> It likely needs to account for hit_timeout. Not looking deep into
> the new callback, but imagine that it expired and you promoted the
> timeout to the next stage (long wait). Then you get a spurious wake
> up, it cancels timeouts, loops in io_cqring_wait() and gets back to
> schedule timeout. Since nothing modified ->min_timeout it'll
> try a short timeout again.

Yeah good point, we don't want to redo it for that case. With
hit_timeout being set earlier now, we can just check it in here.

>> @@ -2379,7 +2433,8 @@ static int io_cqring_schedule_timeout(struct io_wait_queue *iowq,
>>   }
>>     static int __io_cqring_wait_schedule(struct io_ring_ctx *ctx,
>> -                     struct io_wait_queue *iowq)
>> +                     struct io_wait_queue *iowq,
>> +                     ktime_t start_time)
>>   {
>>       int ret = 0;
>>   @@ -2390,8 +2445,8 @@ static int __io_cqring_wait_schedule(struct io_ring_ctx *ctx,
>>        */
>>       if (current_pending_io())
>>           current->in_iowait = 1;
>> -    if (iowq->timeout != KTIME_MAX)
>> -        ret = io_cqring_schedule_timeout(iowq, ctx->clockid);
>> +    if (iowq->timeout != KTIME_MAX || iowq->min_timeout != KTIME_MAX)
>> +        ret = io_cqring_schedule_timeout(iowq, ctx->clockid, start_time);
>>       else
>>           schedule();
>>       current->in_iowait = 0;
>> @@ -2400,7 +2455,8 @@ static int __io_cqring_wait_schedule(struct io_ring_ctx *ctx,
>>     /* If this returns > 0, the caller should retry */
>>   static inline int io_cqring_wait_schedule(struct io_ring_ctx *ctx,
>> -                      struct io_wait_queue *iowq)
>> +                      struct io_wait_queue *iowq,
>> +                      ktime_t start_time)
>>   {
>>       if (unlikely(READ_ONCE(ctx->check_cq)))
>>           return 1;
>> @@ -2413,7 +2469,7 @@ static inline int io_cqring_wait_schedule(struct io_ring_ctx *ctx,
>>       if (unlikely(io_should_wake(iowq)))
>>           return 0;
>>   -    return __io_cqring_wait_schedule(ctx, iowq);
>> +    return __io_cqring_wait_schedule(ctx, iowq, start_time);
>>   }
>>     struct ext_arg {
>> @@ -2431,6 +2487,7 @@ static int io_cqring_wait(struct io_ring_ctx *ctx, int min_events, u32 flags,
>>   {
>>       struct io_wait_queue iowq;
>>       struct io_rings *rings = ctx->rings;
>> +    ktime_t start_time;
>>       int ret;
>>         if (!io_allowed_run_tw(ctx))
>> @@ -2449,8 +2506,11 @@ static int io_cqring_wait(struct io_ring_ctx *ctx, int min_events, u32 flags,
>>       INIT_LIST_HEAD(&iowq.wq.entry);
>>       iowq.ctx = ctx;
>>       iowq.nr_timeouts = atomic_read(&ctx->cq_timeouts);
>> +    iowq.cq_min_tail = READ_ONCE(ctx->rings->cq.tail);
>>       iowq.cq_tail = READ_ONCE(ctx->rings->cq.head) + min_events;
>> +    iowq.min_timeout = 0;
>>       iowq.timeout = KTIME_MAX;
>> +    start_time = io_get_time(ctx);
>>         if (ext_arg->ts) {
>>           struct timespec64 ts;
>> @@ -2460,7 +2520,7 @@ static int io_cqring_wait(struct io_ring_ctx *ctx, int min_events, u32 flags,
>>             iowq.timeout = timespec64_to_ktime(ts);
>>           if (!(flags & IORING_ENTER_ABS_TIMER))
>> -            iowq.timeout = ktime_add(iowq.timeout, io_get_time(ctx));
>> +            iowq.timeout = ktime_add(iowq.timeout, start_time);
>>       }
>>         if (ext_arg->sig) {
>> @@ -2484,14 +2544,16 @@ static int io_cqring_wait(struct io_ring_ctx *ctx, int min_events, u32 flags,
>>           unsigned long check_cq;
>>             if (ctx->flags & IORING_SETUP_DEFER_TASKRUN) {
>> -            atomic_set(&ctx->cq_wait_nr, nr_wait);
>> +            /* if min timeout has been hit, don't reset wait count */
>> +            if (!READ_ONCE(iowq.hit_timeout))
> 
> Why read once? You're out of io_cqring_schedule_timeout(),
> timers are cancelled and everything should've been synchronised
> by this point.

Just for consistency's sake.

>> +                atomic_set(&ctx->cq_wait_nr, nr_wait);
> 
> if (hit_timeout)
>     nr_wait = 1;
> atomic_set(cq_wait_nr, nr_wait);
> 
> otherwise, you're risking not to be ever woken up
> ever again for this wait by tw.

Good point, I'll init nr_wait rather than check here.

-- 
Jens Axboe


