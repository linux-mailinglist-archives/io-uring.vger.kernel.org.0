Return-Path: <io-uring+bounces-2874-lists+io-uring=lfdr.de@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [IPv6:2604:1380:4601:e00::3])
	by mail.lfdr.de (Postfix) with ESMTPS id BBE1F95A4A9
	for <lists+io-uring@lfdr.de>; Wed, 21 Aug 2024 20:25:51 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id 4005C1F21B49
	for <lists+io-uring@lfdr.de>; Wed, 21 Aug 2024 18:25:51 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 293711B2516;
	Wed, 21 Aug 2024 18:25:47 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=davidwei-uk.20230601.gappssmtp.com header.i=@davidwei-uk.20230601.gappssmtp.com header.b="iifcwaiW"
X-Original-To: io-uring@vger.kernel.org
Received: from mail-pl1-f178.google.com (mail-pl1-f178.google.com [209.85.214.178])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4B1D014C5AE
	for <io-uring@vger.kernel.org>; Wed, 21 Aug 2024 18:25:44 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.214.178
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1724264747; cv=none; b=OFl/Ye1GB35iV9PDpZHqFnjESYpFKGZA3VUvP6sIEm7zB1vBf5vuVONm5vqaXLf2ALSRSL8eMhf5DaOxBaIZnRb5Xp4UFJZXTglElPi4bXRnu9ddWzmh574VI0sklw67apwFhgvi6Vu9GqF+Lzu8FcAQ4XBtDXVlZw/uMwu5oek=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1724264747; c=relaxed/simple;
	bh=n49ZZuWBlE/x6ynN3i8K+9i33zD/rfI/GQcnBL6xcf0=;
	h=Message-ID:Date:MIME-Version:Subject:To:References:From:
	 In-Reply-To:Content-Type; b=JAQVIA8H+rdLPGXDZ8+dSMZ/paKtlGIkivTi61dfVvidQnwlFwToLXQcfW+sTl65kVB/cUvd/UQtDPg0Qopm+y1Fk5dYhZtPvku1jgw2zSP5Mr224AZf5Uqq8hWg52wFUguweuiREPNStOC0OisoPJP1gH2p9yvPRcIGcqvq48I=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=davidwei.uk; spf=none smtp.mailfrom=davidwei.uk; dkim=pass (2048-bit key) header.d=davidwei-uk.20230601.gappssmtp.com header.i=@davidwei-uk.20230601.gappssmtp.com header.b=iifcwaiW; arc=none smtp.client-ip=209.85.214.178
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=davidwei.uk
Authentication-Results: smtp.subspace.kernel.org; spf=none smtp.mailfrom=davidwei.uk
Received: by mail-pl1-f178.google.com with SMTP id d9443c01a7336-202146e93f6so56140155ad.3
        for <io-uring@vger.kernel.org>; Wed, 21 Aug 2024 11:25:44 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=davidwei-uk.20230601.gappssmtp.com; s=20230601; t=1724264744; x=1724869544; darn=vger.kernel.org;
        h=content-transfer-encoding:in-reply-to:from:references:to
         :content-language:subject:user-agent:mime-version:date:message-id
         :from:to:cc:subject:date:message-id:reply-to;
        bh=A52WzFkHfarlWQm9tqQOhKyyt7qxq5omLE0bYHOYqBQ=;
        b=iifcwaiWq7cVuQYTIWTKkEwDAH0VVz+MEeeFASgUoZml5012jMG2Krboz6LtLWdWNq
         9QgTolY5+lNgqPlKj5rR9Sk6OeB7sfHIO4MLIzV4VgT6lpnlLzAgR+s3W7UGhaVIe9z2
         a3M3bfE2ZuyDiaaopuLVs5+UzllSRMuI5W1wihZAk+pUaCyAFPzkh4CTgzJPou4bnbGZ
         fnI/EmCj7GOhVWBWkhJF+wVLWMOiNO/oErD9udA15ZCCyOJynmKmcwEkJyfTGiMW+G2C
         YdimJmww+51R0F65cWLL0PG8yjV7G/7cYHu+nA9R3FDalZ8bzJohCzFtpsbncEmBWL6W
         3shA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1724264744; x=1724869544;
        h=content-transfer-encoding:in-reply-to:from:references:to
         :content-language:subject:user-agent:mime-version:date:message-id
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=A52WzFkHfarlWQm9tqQOhKyyt7qxq5omLE0bYHOYqBQ=;
        b=xKcx8USaMe/9N6l3POQyuwkr3fj1XXiKo2BC6ejOPlPnuVBanHXfe0eqyg8ilmFVYi
         qEhbs82VQXPClr6r9D3xHeSuxk5o23JSbrkRPhWKx3RDUqwdE1AVzsK3i4N513H8bXt5
         PG175MJx0b/DIy8z2YRM8UekLpIFMTPJlAidW9WMmqy4GwxSuAi1beAE2df9lUYNivRD
         QSJI3bivmiUL3PN2SMedfwfB9sb8uYZayOUmeIWqOL9UpWTLAW1Ec5EPFbCZEWPQP81S
         Uybra9dBiezG+UKtBL8mCO+qpvjtrG7S7mBLaROJwKLsxRG44YwTw8lUmXNXzw1TEZHP
         vUbg==
X-Forwarded-Encrypted: i=1; AJvYcCXuAvoUGtjxZXbkdRr9yNzCfCPAqOw3+ZL116Sp4tpvjWu3RqrtyLpDqbrZyoDVG9yAYtc3epScjw==@vger.kernel.org
X-Gm-Message-State: AOJu0YxhnfW1GGlk7beQgM8lPWcJ7VU4loriw4O7MfCRXnsHuPBxgEkU
	8EfCGYrYwfB2Ytbo0O4YGQe9LmbiPORnZtl/NmMCzbH6n3Rx3+3hVclBE8oCf9g=
X-Google-Smtp-Source: AGHT+IFiq1x5qa0OlXMiVyzSRLKWYbyftC0CuIEPxnJ1IVPfMjykd89IYqCpvPo+u8Lrzn7OjjUcTg==
X-Received: by 2002:a17:902:d50d:b0:202:18af:2fa3 with SMTP id d9443c01a7336-20368191bffmr42166625ad.39.1724264744346;
        Wed, 21 Aug 2024 11:25:44 -0700 (PDT)
Received: from ?IPV6:2a03:83e0:1256:1:80c:c984:f4f1:951f? ([2620:10d:c090:500::6:7d40])
        by smtp.gmail.com with ESMTPSA id d9443c01a7336-201f03756bcsm96695095ad.157.2024.08.21.11.25.42
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Wed, 21 Aug 2024 11:25:43 -0700 (PDT)
Message-ID: <ae255e94-f787-4950-9831-ee5d6693c089@davidwei.uk>
Date: Wed, 21 Aug 2024 11:25:41 -0700
Precedence: bulk
X-Mailing-List: io-uring@vger.kernel.org
List-Id: <io-uring.vger.kernel.org>
List-Subscribe: <mailto:io-uring+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:io-uring+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH 4/5] io_uring: add support for batch wait timeout
Content-Language: en-GB
To: Jens Axboe <axboe@kernel.dk>, io-uring@vger.kernel.org
References: <20240821141910.204660-1-axboe@kernel.dk>
 <20240821141910.204660-5-axboe@kernel.dk>
From: David Wei <dw@davidwei.uk>
In-Reply-To: <20240821141910.204660-5-axboe@kernel.dk>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit

On 2024-08-21 07:16, Jens Axboe wrote:
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
>  io_uring/io_uring.c | 88 ++++++++++++++++++++++++++++++++++++++-------
>  io_uring/io_uring.h |  2 ++
>  2 files changed, 77 insertions(+), 13 deletions(-)
> 
> diff --git a/io_uring/io_uring.c b/io_uring/io_uring.c
> index 4ba5292137c3..87e7cf6551d7 100644
> --- a/io_uring/io_uring.c
> +++ b/io_uring/io_uring.c
> @@ -2322,7 +2322,8 @@ static int io_wake_function(struct wait_queue_entry *curr, unsigned int mode,
>  	 * Cannot safely flush overflowed CQEs from here, ensure we wake up
>  	 * the task, and the next invocation will do it.
>  	 */
> -	if (io_should_wake(iowq) || io_has_work(iowq->ctx) || iowq->hit_timeout)
> +	if (io_should_wake(iowq) || io_has_work(iowq->ctx) ||
> +	    READ_ONCE(iowq->hit_timeout))
>  		return autoremove_wake_function(curr, mode, wake_flags, key);
>  	return -1;
>  }
> @@ -2359,13 +2360,66 @@ static enum hrtimer_restart io_cqring_timer_wakeup(struct hrtimer *timer)
>  	return HRTIMER_NORESTART;
>  }
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

What happens if timeout < min_timeout? Would the timer expired callback
io_cqring_timer_wakeup() be called right away?

> +	return HRTIMER_RESTART;
> +out_wake:
> +	return io_cqring_timer_wakeup(timer);
> +}
> +
>  static int io_cqring_schedule_timeout(struct io_wait_queue *iowq,
> -				      clockid_t clock_id)
> +				      clockid_t clock_id, ktime_t start_time)
>  {
> -	iowq->hit_timeout = 0;
> +	ktime_t timeout;
> +
> +	WRITE_ONCE(iowq->hit_timeout, 0);
>  	hrtimer_init_on_stack(&iowq->t, clock_id, HRTIMER_MODE_ABS);
> -	iowq->t.function = io_cqring_timer_wakeup;
> -	hrtimer_set_expires_range_ns(&iowq->t, iowq->timeout, 0);
> +	if (iowq->min_timeout) {
> +		timeout = ktime_add_ns(iowq->min_timeout, start_time);
> +		iowq->t.function = io_cqring_min_timer_wakeup;
> +	} else {
> +		timeout = iowq->timeout;
> +		iowq->t.function = io_cqring_timer_wakeup;
> +	}
> +
> +	hrtimer_set_expires_range_ns(&iowq->t, timeout, 0);
>  	hrtimer_start_expires(&iowq->t, HRTIMER_MODE_ABS);
>  
>  	if (!READ_ONCE(iowq->hit_timeout))
> @@ -2379,7 +2433,8 @@ static int io_cqring_schedule_timeout(struct io_wait_queue *iowq,
>  }
>  
>  static int __io_cqring_wait_schedule(struct io_ring_ctx *ctx,
> -				     struct io_wait_queue *iowq)
> +				     struct io_wait_queue *iowq,
> +				     ktime_t start_time)
>  {
>  	int ret = 0;
>  
> @@ -2390,8 +2445,8 @@ static int __io_cqring_wait_schedule(struct io_ring_ctx *ctx,
>  	 */
>  	if (current_pending_io())
>  		current->in_iowait = 1;
> -	if (iowq->timeout != KTIME_MAX)
> -		ret = io_cqring_schedule_timeout(iowq, ctx->clockid);
> +	if (iowq->timeout != KTIME_MAX || iowq->min_timeout != KTIME_MAX)
> +		ret = io_cqring_schedule_timeout(iowq, ctx->clockid, start_time);

In this case it is possible for either timeout or min_timeout to be
KTIME_MAX and still schedule a timeout.

If min_timeout != KTIME_MAX and timeout == KTIME_MAX, then
io_cqring_min_timer_wakeup() will reset itself to a timer with
KTIME_MAX.

If min_timeout == KTIME_MAX and timeout != KTIME_MAX, then a KTIME_MAX
timer will be set.

This should be fine, the timer will never expire and schedule() is
called regardless. The previous code is a small optimisation to avoid
setting up a timer that will never expire.

>  	else
>  		schedule();
>  	current->in_iowait = 0;
> @@ -2400,7 +2455,8 @@ static int __io_cqring_wait_schedule(struct io_ring_ctx *ctx,
>  
>  /* If this returns > 0, the caller should retry */
>  static inline int io_cqring_wait_schedule(struct io_ring_ctx *ctx,
> -					  struct io_wait_queue *iowq)
> +					  struct io_wait_queue *iowq,
> +					  ktime_t start_time)
>  {
>  	if (unlikely(READ_ONCE(ctx->check_cq)))
>  		return 1;
> @@ -2413,7 +2469,7 @@ static inline int io_cqring_wait_schedule(struct io_ring_ctx *ctx,
>  	if (unlikely(io_should_wake(iowq)))
>  		return 0;
>  
> -	return __io_cqring_wait_schedule(ctx, iowq);
> +	return __io_cqring_wait_schedule(ctx, iowq, start_time);
>  }
>  
>  struct ext_arg {
> @@ -2431,6 +2487,7 @@ static int io_cqring_wait(struct io_ring_ctx *ctx, int min_events, u32 flags,
>  {
>  	struct io_wait_queue iowq;
>  	struct io_rings *rings = ctx->rings;
> +	ktime_t start_time;
>  	int ret;
>  
>  	if (!io_allowed_run_tw(ctx))
> @@ -2449,8 +2506,11 @@ static int io_cqring_wait(struct io_ring_ctx *ctx, int min_events, u32 flags,
>  	INIT_LIST_HEAD(&iowq.wq.entry);
>  	iowq.ctx = ctx;
>  	iowq.nr_timeouts = atomic_read(&ctx->cq_timeouts);
> +	iowq.cq_min_tail = READ_ONCE(ctx->rings->cq.tail);
>  	iowq.cq_tail = READ_ONCE(ctx->rings->cq.head) + min_events;
> +	iowq.min_timeout = 0;
>  	iowq.timeout = KTIME_MAX;
> +	start_time = io_get_time(ctx);
>  
>  	if (ext_arg->ts) {
>  		struct timespec64 ts;
> @@ -2460,7 +2520,7 @@ static int io_cqring_wait(struct io_ring_ctx *ctx, int min_events, u32 flags,
>  
>  		iowq.timeout = timespec64_to_ktime(ts);
>  		if (!(flags & IORING_ENTER_ABS_TIMER))
> -			iowq.timeout = ktime_add(iowq.timeout, io_get_time(ctx));
> +			iowq.timeout = ktime_add(iowq.timeout, start_time);
>  	}
>  
>  	if (ext_arg->sig) {
> @@ -2484,14 +2544,16 @@ static int io_cqring_wait(struct io_ring_ctx *ctx, int min_events, u32 flags,
>  		unsigned long check_cq;
>  
>  		if (ctx->flags & IORING_SETUP_DEFER_TASKRUN) {
> -			atomic_set(&ctx->cq_wait_nr, nr_wait);
> +			/* if min timeout has been hit, don't reset wait count */
> +			if (!READ_ONCE(iowq.hit_timeout))
> +				atomic_set(&ctx->cq_wait_nr, nr_wait);

Only the two timeout expired callback functions
io_cqring_min_timer_wakeup() and io_cqring_timer_wakeup() sets
hit_timeout to 1. In this case, io_cqring_schedule_timeout() would
return -ETIME and the do {...} while(1) loop in io_cqring_wait() would
break. So I'm not sure if it is possible to reach here with hit_timeout
= 1.

Also, in the first iteration of the loop, hit_timeout is init to 0
inside of io_cqring_wait_schedule() -> __io_cqring_wait_schedule() ->
io_cqring_schedule_timeout(). So it is possible for hit_timeout to be
READ_ONCE before it is initialised. If this code is kept we should init
iowq.hit_timeout = 0 above.

>  			set_current_state(TASK_INTERRUPTIBLE);
>  		} else {
>  			prepare_to_wait_exclusive(&ctx->cq_wait, &iowq.wq,
>  							TASK_INTERRUPTIBLE);
>  		}
>  
> -		ret = io_cqring_wait_schedule(ctx, &iowq);
> +		ret = io_cqring_wait_schedule(ctx, &iowq, start_time);
>  		__set_current_state(TASK_RUNNING);
>  		atomic_set(&ctx->cq_wait_nr, IO_CQ_WAKE_INIT);
>  
> diff --git a/io_uring/io_uring.h b/io_uring/io_uring.h
> index f95c1b080f4b..65078e641390 100644
> --- a/io_uring/io_uring.h
> +++ b/io_uring/io_uring.h
> @@ -39,8 +39,10 @@ struct io_wait_queue {
>  	struct wait_queue_entry wq;
>  	struct io_ring_ctx *ctx;
>  	unsigned cq_tail;
> +	unsigned cq_min_tail;
>  	unsigned nr_timeouts;
>  	int hit_timeout;
> +	ktime_t min_timeout;
>  	ktime_t timeout;
>  	struct hrtimer t;
>  

