Return-Path: <io-uring+bounces-2897-lists+io-uring=lfdr.de@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from sy.mirrors.kernel.org (sy.mirrors.kernel.org [IPv6:2604:1380:40f1:3f00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 7BCB595B710
	for <lists+io-uring@lfdr.de>; Thu, 22 Aug 2024 15:45:55 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sy.mirrors.kernel.org (Postfix) with ESMTPS id A4C9EB264E9
	for <lists+io-uring@lfdr.de>; Thu, 22 Aug 2024 13:45:52 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 6D5101C693;
	Thu, 22 Aug 2024 13:45:47 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="awWMFxZt"
X-Original-To: io-uring@vger.kernel.org
Received: from mail-ed1-f46.google.com (mail-ed1-f46.google.com [209.85.208.46])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 621A221350
	for <io-uring@vger.kernel.org>; Thu, 22 Aug 2024 13:45:45 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.208.46
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1724334347; cv=none; b=Jr5D2OqIQrmoiRcvoE30Vt+p40rIrNl9nE7PrUzTVxcqPpeKU9zmqlNxBTGLm0gCVSkxgpC1Py1Lvx7lSnTndNGjH+MSVmFcVr8NysUphI6CFZ7Tcqz/TL/VSFjllCv4KM4f4MR1/637TIcUbE9afLrBpU6jFlIU4M2eyyClrkY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1724334347; c=relaxed/simple;
	bh=7WVirtTk8XLnIt8kvhXYtS2n915+6oDRt09mWIsnO9I=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=tm2I4nOUWR2jCP9KYYtFQ9PeNTTyXfucze0il/JDzsvE3tZsSQFcd+Zao4iZUMQtd1cuPUdtmj41jAWETmi8IKhbSJkQG7aZukmKSCQ+utuMmhoxCL5Vdos8nSMP/JFiOHpxaIyGRWDq7rrF8peNVNdAPeTNKxMAn2slDAH3mfI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=awWMFxZt; arc=none smtp.client-ip=209.85.208.46
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Received: by mail-ed1-f46.google.com with SMTP id 4fb4d7f45d1cf-5bf009cf4c0so1006575a12.1
        for <io-uring@vger.kernel.org>; Thu, 22 Aug 2024 06:45:45 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1724334344; x=1724939144; darn=vger.kernel.org;
        h=content-transfer-encoding:in-reply-to:from:content-language
         :references:cc:to:subject:user-agent:mime-version:date:message-id
         :from:to:cc:subject:date:message-id:reply-to;
        bh=GIOERqsptz0VSeGpneDqJ5XF9dO79lGFkCDI3IGR+bY=;
        b=awWMFxZtUDjOLyhMpkAOJQ1apdaAh/sKnhzqsjR6TFuj9zypsrFMVOITIy1A0TuDKE
         MHcnIhjewBiGnFfztMlBUirVGfviiPefo9JlQg4AoIJLUR2+mWQ13CRBjYuqJQE3i23f
         Y4Sxpc2NIT3AHhULKKzLBJzkf1ZocaeIzmMAfpux7TIh/yglckXNWrzqEpocgjCZ+64c
         ID7H/iIByJvAy5k7Y/BuNEo2zv5j6nUL++IEFlURiopRMUePyYfZfK6j6R6DdKY2rEhJ
         anl0mAEuoUasvRRNbRbETmPsg447GaV3pXfdmg6HnWxflbYk52UWn/p+XSVS65TEMD1c
         0LLQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1724334344; x=1724939144;
        h=content-transfer-encoding:in-reply-to:from:content-language
         :references:cc:to:subject:user-agent:mime-version:date:message-id
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=GIOERqsptz0VSeGpneDqJ5XF9dO79lGFkCDI3IGR+bY=;
        b=PmrSZ7M1iCSjsXG8z2FGcZGH/Vk0BqtzvK4gqdQz8bZOSlK+uUBU+/vsSVUqECm0IT
         +LL3/xkpEKMJ7eELgmtBUARwqwjSH0qK2V5TWePTq2mUvAxZgSoHRiOEEMu84BxRmc6d
         yZ1TaVIzyVp9EWZ94O18xK8P5dq6Y1RRgY5a+9aLeRI9jmteM453MaXnNb2HcJiTCV6g
         5otCHwoKSe66J0AygVK3KGLTpC1nuuRhqo+CbcsahpKh5I4pGJR9HNvxklVp17v0j+1D
         s/1ohtmvz+LqhSAQveEYhyQZDY1nwzIVgCk87bv9m3y40TM8DG+Sr0hDq59cItu3hjT2
         Pz1g==
X-Forwarded-Encrypted: i=1; AJvYcCU/rs9MH7TPJj9B/OZcq7M1tVXxUIaUiSlf6CoWJds2CJZMtAwxqSCW0w0ycIIYK1BXTeTZoI8HPg==@vger.kernel.org
X-Gm-Message-State: AOJu0YxpYkOobOxArWqLVfKGryIliT/XGFijOim5OtB0lHkSxRK5GSog
	3yYxXBB+nlpfQDX8XMUqxCawj2cc2H4FjLV9KGT5yen4takTp+gxHzAmZg==
X-Google-Smtp-Source: AGHT+IE0cSpC4V95ADZlftmPORW+r1e5tPNylJzT2yY8QFAYyk+ELSD20wV1be66y1LiOBeVY/wdjA==
X-Received: by 2002:a05:6402:280a:b0:57c:c166:ba6 with SMTP id 4fb4d7f45d1cf-5bf1f150c67mr3742096a12.19.1724334342832;
        Thu, 22 Aug 2024 06:45:42 -0700 (PDT)
Received: from [192.168.42.237] ([163.114.131.193])
        by smtp.gmail.com with ESMTPSA id 4fb4d7f45d1cf-5c044ddc0f1sm936332a12.17.2024.08.22.06.45.42
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Thu, 22 Aug 2024 06:45:42 -0700 (PDT)
Message-ID: <ca995b4b-9dc3-4035-88ac-a22c690f09d0@gmail.com>
Date: Thu, 22 Aug 2024 14:46:08 +0100
Precedence: bulk
X-Mailing-List: io-uring@vger.kernel.org
List-Id: <io-uring.vger.kernel.org>
List-Subscribe: <mailto:io-uring+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:io-uring+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH 4/5] io_uring: add support for batch wait timeout
To: Jens Axboe <axboe@kernel.dk>, io-uring@vger.kernel.org
Cc: dw@davidwei.uk
References: <20240821141910.204660-1-axboe@kernel.dk>
 <20240821141910.204660-5-axboe@kernel.dk>
Content-Language: en-US
From: Pavel Begunkov <asml.silence@gmail.com>
In-Reply-To: <20240821141910.204660-5-axboe@kernel.dk>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit

On 8/21/24 15:16, Jens Axboe wrote:
> Waiting for events with io_uring has two knobs that can be set:
> 
> 1) The number of events to wake for
> 2) The timeout associated with the event
> 
> Waiting will abort when either of those conditions are met, as expected.
> 
> This adds support for a third event, which is associated with the number
> of events to wait for. Applications generally like to handle batches of
> completions, and right now they'd set a number of events to wait for and
> the timeout for that. If no events have been received but the timeout
> triggers, control is returned to the application and it can wait again.
> However, if the application doesn't have anything to do until events are
> reaped, then it's possible to make this waiting more efficient.
> 
> For example, the application may have a latency time of 50 usecs and
> wanting to handle a batch of 8 requests at the time. If it uses 50 usecs
> as the timeout, then it'll be doing 20K context switches per second even
> if nothing is happening.
> 
> This introduces the notion of min batch wait time. If the min batch wait
> time expires, then we'll return to userspace if we have any events at all.
> If none are available, the general wait time is applied. Any request
> arriving after the min batch wait time will cause waiting to stop and
> return control to the application.
> 
> Signed-off-by: Jens Axboe <axboe@kernel.dk>
> ---
>   io_uring/io_uring.c | 88 ++++++++++++++++++++++++++++++++++++++-------
>   io_uring/io_uring.h |  2 ++
>   2 files changed, 77 insertions(+), 13 deletions(-)
> 
> diff --git a/io_uring/io_uring.c b/io_uring/io_uring.c
> index 4ba5292137c3..87e7cf6551d7 100644
> --- a/io_uring/io_uring.c
> +++ b/io_uring/io_uring.c
> @@ -2322,7 +2322,8 @@ static int io_wake_function(struct wait_queue_entry *curr, unsigned int mode,
>   	 * Cannot safely flush overflowed CQEs from here, ensure we wake up
>   	 * the task, and the next invocation will do it.
>   	 */
> -	if (io_should_wake(iowq) || io_has_work(iowq->ctx) || iowq->hit_timeout)
> +	if (io_should_wake(iowq) || io_has_work(iowq->ctx) ||
> +	    READ_ONCE(iowq->hit_timeout))
>   		return autoremove_wake_function(curr, mode, wake_flags, key);
>   	return -1;
>   }
> @@ -2359,13 +2360,66 @@ static enum hrtimer_restart io_cqring_timer_wakeup(struct hrtimer *timer)
>   	return HRTIMER_NORESTART;
>   }
>   
> +/*
> + * Doing min_timeout portion. If we saw any timeouts, events, or have work,
> + * wake up. If not, and we have a normal timeout, switch to that and keep
> + * sleeping.
> + */
> +static enum hrtimer_restart io_cqring_min_timer_wakeup(struct hrtimer *timer)
> +{
> +	struct io_wait_queue *iowq = container_of(timer, struct io_wait_queue, t);
> +	struct io_ring_ctx *ctx = iowq->ctx;
> +
> +	/* no general timeout, or shorter, we are done */
> +	if (iowq->timeout == KTIME_MAX ||
> +	    ktime_after(iowq->min_timeout, iowq->timeout))
> +		goto out_wake;
> +	/* work we may need to run, wake function will see if we need to wake */
> +	if (io_has_work(ctx))
> +		goto out_wake;
> +	/* got events since we started waiting, min timeout is done */
> +	if (iowq->cq_min_tail != READ_ONCE(ctx->rings->cq.tail))
> +		goto out_wake;
> +	/* if we have any events and min timeout expired, we're done */
> +	if (io_cqring_events(ctx))
> +		goto out_wake;
> +
> +	/*
> +	 * If using deferred task_work running and application is waiting on
> +	 * more than one request, ensure we reset it now where we are switching
> +	 * to normal sleeps. Any request completion post min_wait should wake
> +	 * the task and return.
> +	 */
> +	if (ctx->flags & IORING_SETUP_DEFER_TASKRUN) {
> +		atomic_set(&ctx->cq_wait_nr, 1);
> +		smp_mb();
> +		if (!llist_empty(&ctx->work_llist))
> +			goto out_wake;
> +	}
> +
> +	iowq->t.function = io_cqring_timer_wakeup;
> +	hrtimer_set_expires(timer, iowq->timeout);
> +	return HRTIMER_RESTART;
> +out_wake:
> +	return io_cqring_timer_wakeup(timer);
> +}
> +
>   static int io_cqring_schedule_timeout(struct io_wait_queue *iowq,
> -				      clockid_t clock_id)
> +				      clockid_t clock_id, ktime_t start_time)
>   {
> -	iowq->hit_timeout = 0;
> +	ktime_t timeout;
> +
> +	WRITE_ONCE(iowq->hit_timeout, 0);
>   	hrtimer_init_on_stack(&iowq->t, clock_id, HRTIMER_MODE_ABS);
> -	iowq->t.function = io_cqring_timer_wakeup;
> -	hrtimer_set_expires_range_ns(&iowq->t, iowq->timeout, 0);
> +	if (iowq->min_timeout) {

What's the default, 0 or KTIME_MAX? __io_cqring_wait_schedule()
checks KTIME_MAX instead.

It likely needs to account for hit_timeout. Not looking deep into
the new callback, but imagine that it expired and you promoted the
timeout to the next stage (long wait). Then you get a spurious wake
up, it cancels timeouts, loops in io_cqring_wait() and gets back to
schedule timeout. Since nothing modified ->min_timeout it'll
try a short timeout again.


> +		timeout = ktime_add_ns(iowq->min_timeout, start_time);
> +		iowq->t.function = io_cqring_min_timer_wakeup;
> +	} else {
> +		timeout = iowq->timeout;
> +		iowq->t.function = io_cqring_timer_wakeup;
> +	}
> +
> +	hrtimer_set_expires_range_ns(&iowq->t, timeout, 0);
>   	hrtimer_start_expires(&iowq->t, HRTIMER_MODE_ABS);
>   
>   	if (!READ_ONCE(iowq->hit_timeout))
> @@ -2379,7 +2433,8 @@ static int io_cqring_schedule_timeout(struct io_wait_queue *iowq,
>   }
>   
>   static int __io_cqring_wait_schedule(struct io_ring_ctx *ctx,
> -				     struct io_wait_queue *iowq)
> +				     struct io_wait_queue *iowq,
> +				     ktime_t start_time)
>   {
>   	int ret = 0;
>   
> @@ -2390,8 +2445,8 @@ static int __io_cqring_wait_schedule(struct io_ring_ctx *ctx,
>   	 */
>   	if (current_pending_io())
>   		current->in_iowait = 1;
> -	if (iowq->timeout != KTIME_MAX)
> -		ret = io_cqring_schedule_timeout(iowq, ctx->clockid);
> +	if (iowq->timeout != KTIME_MAX || iowq->min_timeout != KTIME_MAX)
> +		ret = io_cqring_schedule_timeout(iowq, ctx->clockid, start_time);
>   	else
>   		schedule();
>   	current->in_iowait = 0;
> @@ -2400,7 +2455,8 @@ static int __io_cqring_wait_schedule(struct io_ring_ctx *ctx,
>   
>   /* If this returns > 0, the caller should retry */
>   static inline int io_cqring_wait_schedule(struct io_ring_ctx *ctx,
> -					  struct io_wait_queue *iowq)
> +					  struct io_wait_queue *iowq,
> +					  ktime_t start_time)
>   {
>   	if (unlikely(READ_ONCE(ctx->check_cq)))
>   		return 1;
> @@ -2413,7 +2469,7 @@ static inline int io_cqring_wait_schedule(struct io_ring_ctx *ctx,
>   	if (unlikely(io_should_wake(iowq)))
>   		return 0;
>   
> -	return __io_cqring_wait_schedule(ctx, iowq);
> +	return __io_cqring_wait_schedule(ctx, iowq, start_time);
>   }
>   
>   struct ext_arg {
> @@ -2431,6 +2487,7 @@ static int io_cqring_wait(struct io_ring_ctx *ctx, int min_events, u32 flags,
>   {
>   	struct io_wait_queue iowq;
>   	struct io_rings *rings = ctx->rings;
> +	ktime_t start_time;
>   	int ret;
>   
>   	if (!io_allowed_run_tw(ctx))
> @@ -2449,8 +2506,11 @@ static int io_cqring_wait(struct io_ring_ctx *ctx, int min_events, u32 flags,
>   	INIT_LIST_HEAD(&iowq.wq.entry);
>   	iowq.ctx = ctx;
>   	iowq.nr_timeouts = atomic_read(&ctx->cq_timeouts);
> +	iowq.cq_min_tail = READ_ONCE(ctx->rings->cq.tail);
>   	iowq.cq_tail = READ_ONCE(ctx->rings->cq.head) + min_events;
> +	iowq.min_timeout = 0;
>   	iowq.timeout = KTIME_MAX;
> +	start_time = io_get_time(ctx);
>   
>   	if (ext_arg->ts) {
>   		struct timespec64 ts;
> @@ -2460,7 +2520,7 @@ static int io_cqring_wait(struct io_ring_ctx *ctx, int min_events, u32 flags,
>   
>   		iowq.timeout = timespec64_to_ktime(ts);
>   		if (!(flags & IORING_ENTER_ABS_TIMER))
> -			iowq.timeout = ktime_add(iowq.timeout, io_get_time(ctx));
> +			iowq.timeout = ktime_add(iowq.timeout, start_time);
>   	}
>   
>   	if (ext_arg->sig) {
> @@ -2484,14 +2544,16 @@ static int io_cqring_wait(struct io_ring_ctx *ctx, int min_events, u32 flags,
>   		unsigned long check_cq;
>   
>   		if (ctx->flags & IORING_SETUP_DEFER_TASKRUN) {
> -			atomic_set(&ctx->cq_wait_nr, nr_wait);
> +			/* if min timeout has been hit, don't reset wait count */
> +			if (!READ_ONCE(iowq.hit_timeout))

Why read once? You're out of io_cqring_schedule_timeout(),
timers are cancelled and everything should've been synchronised
by this point.

FWIW, it was also fine setting it to 1 in the timer callback
for the same reason. However...


> +				atomic_set(&ctx->cq_wait_nr, nr_wait);

if (hit_timeout)
	nr_wait = 1;
atomic_set(cq_wait_nr, nr_wait);

otherwise, you're risking not to be ever woken up
ever again for this wait by tw.


>   			set_current_state(TASK_INTERRUPTIBLE);
>   		} else {
>   			prepare_to_wait_exclusive(&ctx->cq_wait, &iowq.wq,
>   							TASK_INTERRUPTIBLE);
>   		}
>   
> -		ret = io_cqring_wait_schedule(ctx, &iowq);
> +		ret = io_cqring_wait_schedule(ctx, &iowq, start_time);
>   		__set_current_state(TASK_RUNNING);
>   		atomic_set(&ctx->cq_wait_nr, IO_CQ_WAKE_INIT);
>   
> diff --git a/io_uring/io_uring.h b/io_uring/io_uring.h
> index f95c1b080f4b..65078e641390 100644
> --- a/io_uring/io_uring.h
> +++ b/io_uring/io_uring.h
> @@ -39,8 +39,10 @@ struct io_wait_queue {
>   	struct wait_queue_entry wq;
>   	struct io_ring_ctx *ctx;
>   	unsigned cq_tail;
> +	unsigned cq_min_tail;
>   	unsigned nr_timeouts;
>   	int hit_timeout;
> +	ktime_t min_timeout;
>   	ktime_t timeout;
>   	struct hrtimer t;
>   

-- 
Pavel Begunkov

