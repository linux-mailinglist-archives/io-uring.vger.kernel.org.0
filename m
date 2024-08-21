Return-Path: <io-uring+bounces-2876-lists+io-uring=lfdr.de@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [IPv6:2604:1380:45e3:2400::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 7AA7595A4E9
	for <lists+io-uring@lfdr.de>; Wed, 21 Aug 2024 20:54:11 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 2ADB72833D9
	for <lists+io-uring@lfdr.de>; Wed, 21 Aug 2024 18:54:10 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 35D3516BE25;
	Wed, 21 Aug 2024 18:54:07 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=davidwei-uk.20230601.gappssmtp.com header.i=@davidwei-uk.20230601.gappssmtp.com header.b="JpOQZDHH"
X-Original-To: io-uring@vger.kernel.org
Received: from mail-pj1-f47.google.com (mail-pj1-f47.google.com [209.85.216.47])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4F8134085D
	for <io-uring@vger.kernel.org>; Wed, 21 Aug 2024 18:54:05 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.216.47
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1724266447; cv=none; b=Zyv7+eAZ8yHbQXOTBiwcFiiPPrpj8uLvr8t+OM+36DdKnCxI7JG9y18RHN05Ct486jlvzT5NunHbHap06yvZ5F+SGYm2Zr+nbeBp5iIqLd5xJbuhlwjKlPqfJAD+6QodhlXSajN/wxlrsXrXuLNUpDu8El8P/lo6GwDRCp5+Gvs=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1724266447; c=relaxed/simple;
	bh=n8dlLuFs2v0d0iaDQ/jE+h3aL9xAVPLrrwL1aAvy+88=;
	h=Message-ID:Date:MIME-Version:Subject:To:References:From:
	 In-Reply-To:Content-Type; b=Q/cE/onezhhGD+ONUXpV84bnYKkQrrXGh0uIFqRQcUT0zkINBs7dKIZdFGzfODxdR4+WDGQDR0xN3gKpH7T8c2DTy2VdaVoVDFso+fG5A7JZW7+GnDMrum3MC52CvM22d6NkJZ3+pNhMaam/MTYj6Ir8SgU4DBtk88ndroELfog=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=davidwei.uk; spf=none smtp.mailfrom=davidwei.uk; dkim=pass (2048-bit key) header.d=davidwei-uk.20230601.gappssmtp.com header.i=@davidwei-uk.20230601.gappssmtp.com header.b=JpOQZDHH; arc=none smtp.client-ip=209.85.216.47
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=davidwei.uk
Authentication-Results: smtp.subspace.kernel.org; spf=none smtp.mailfrom=davidwei.uk
Received: by mail-pj1-f47.google.com with SMTP id 98e67ed59e1d1-2d3e46ba5bcso4083559a91.0
        for <io-uring@vger.kernel.org>; Wed, 21 Aug 2024 11:54:05 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=davidwei-uk.20230601.gappssmtp.com; s=20230601; t=1724266444; x=1724871244; darn=vger.kernel.org;
        h=content-transfer-encoding:in-reply-to:from:references:to
         :content-language:subject:user-agent:mime-version:date:message-id
         :from:to:cc:subject:date:message-id:reply-to;
        bh=naIhgg6l8jijV+zIYk3C1MgCRrYMnjHO8aUgRKNVpQo=;
        b=JpOQZDHHjgMM6WFfT1TNFDW5UpiH/tSOvdql28+DgVuv4yEz+jhliTHXwfAk8GQzXq
         98XRfZ2j3IO9NqgbOQX9QAEFc0xwDQrhmrggKySKnHDvKz02yllOp8hxCkzDATPE8MTO
         1vkybP2PCD+pc+LWTHRtQJE/weS3yCG+yxat2lrXDkp771ZjI+Y+w1mvAUZC49sVgCzp
         9chb9W8nWK8MnR9Hn+/e+hGSTSAkWLTYNb0rfmwA3vO54JjJWAFCTd3Y/CIpDhAESF8v
         PA7aSiHpt8hAC+Jc0LPpAE9lgMPHBdOkKM8l7g61x+AUheHFlCCEkJMzjotHGzE3n1Eq
         CByA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1724266444; x=1724871244;
        h=content-transfer-encoding:in-reply-to:from:references:to
         :content-language:subject:user-agent:mime-version:date:message-id
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=naIhgg6l8jijV+zIYk3C1MgCRrYMnjHO8aUgRKNVpQo=;
        b=ghmH5FQ+mtPyn1TaEyUMVvoCaamqpQLMTIFKXyQceLr3NYdR5wGX27o+67V+9r6u6N
         oWwi48LLuIN22LKr0T5tAbfJ/WAgXo6RE8cZaBxQmF7QFFstjDaYesLZRxyKWdUJ+ErN
         LQNoRooawQjpg4gkEsm6oWBdtKOjCP0BTngMOSkwACyLowAMmUkunJGCNiNx3RrJdm0Z
         VEEXpz5ObuODoZuRCzyQGIZ2uNI7LGKwxYH4CQMnCwyRz+ay1dhBD3fqHnOWjbpgrNmt
         IwgcwLPHK+58MG0YSTOxRzFqySsLxS4hFpfPLs0oDOLfWAHHPi3EzIQREYA/awqTwhiP
         fUFA==
X-Forwarded-Encrypted: i=1; AJvYcCXVcpydFuZbAY0xzBZfg8HdsyOyxEkvi0ya1VeXPjPnuVulgFfkFxT+yEsPcCJ7kFevDk5hdrD9ZA==@vger.kernel.org
X-Gm-Message-State: AOJu0Yzy7+ml+Iez9DHPt5SL1+dF9M53xhzqt3btzaCTEaC2nDt5h0LL
	xRwuKLynEO7Z+4Vp4O6bSeTMq1GtpBY4esgLb/a+8nFW6e7xfJdqdIm2qv0bWuGknHhB4/gboXz
	0Wy4=
X-Google-Smtp-Source: AGHT+IFz+em4byNQRRiJEpiTiteJZXfNJZ3DvjQX9w787dEWmSzBeT45SLs64kA19Ymh813Seka+pg==
X-Received: by 2002:a17:90b:4c04:b0:2cb:4e14:fd5d with SMTP id 98e67ed59e1d1-2d5e99e7c39mr3505589a91.17.1724266444320;
        Wed, 21 Aug 2024 11:54:04 -0700 (PDT)
Received: from ?IPV6:2a03:83e0:1256:1:80c:c984:f4f1:951f? ([2620:10d:c090:500::6:7d40])
        by smtp.gmail.com with ESMTPSA id 98e67ed59e1d1-2d5eb8cf61bsm2274057a91.9.2024.08.21.11.54.03
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Wed, 21 Aug 2024 11:54:03 -0700 (PDT)
Message-ID: <992ce87d-5c87-4149-946c-465b83c3e74a@davidwei.uk>
Date: Wed, 21 Aug 2024 11:54:02 -0700
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
 <ae255e94-f787-4950-9831-ee5d6693c089@davidwei.uk>
 <a99f6284-0b28-444e-b906-8c189964126b@kernel.dk>
From: David Wei <dw@davidwei.uk>
In-Reply-To: <a99f6284-0b28-444e-b906-8c189964126b@kernel.dk>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit

On 2024-08-21 11:38, Jens Axboe wrote:
> On 8/21/24 12:25 PM, David Wei wrote:
>> On 2024-08-21 07:16, Jens Axboe wrote:
>>> Waiting for events with io_uring has two knobs that can be set:
>>>
>>> 1) The number of events to wake for
>>> 2) The timeout associated with the event
>>>
>>> Waiting will abort when either of those conditions are met, as expected.
>>>
>>> This adds support for a third event, which is associated with the number
>>> of events to wait for. Applications generally like to handle batches of
>>> completions, and right now they'd set a number of events to wait for and
>>> the timeout for that. If no events have been received but the timeout
>>> triggers, control is returned to the application and it can wait again.
>>> However, if the application doesn't have anything to do until events are
>>> reaped, then it's possible to make this waiting more efficient.
>>>
>>> For example, the application may have a latency time of 50 usecs and
>>> wanting to handle a batch of 8 requests at the time. If it uses 50 usecs
>>> as the timeout, then it'll be doing 20K context switches per second even
>>> if nothing is happening.
>>>
>>> This introduces the notion of min batch wait time. If the min batch wait
>>> time expires, then we'll return to userspace if we have any events at all.
>>> If none are available, the general wait time is applied. Any request
>>> arriving after the min batch wait time will cause waiting to stop and
>>> return control to the application.
>>>
>>> Signed-off-by: Jens Axboe <axboe@kernel.dk>
>>> ---
>>>  io_uring/io_uring.c | 88 ++++++++++++++++++++++++++++++++++++++-------
>>>  io_uring/io_uring.h |  2 ++
>>>  2 files changed, 77 insertions(+), 13 deletions(-)
>>>
>>> diff --git a/io_uring/io_uring.c b/io_uring/io_uring.c
>>> index 4ba5292137c3..87e7cf6551d7 100644
>>> --- a/io_uring/io_uring.c
>>> +++ b/io_uring/io_uring.c
>>> @@ -2322,7 +2322,8 @@ static int io_wake_function(struct wait_queue_entry *curr, unsigned int mode,
>>>  	 * Cannot safely flush overflowed CQEs from here, ensure we wake up
>>>  	 * the task, and the next invocation will do it.
>>>  	 */
>>> -	if (io_should_wake(iowq) || io_has_work(iowq->ctx) || iowq->hit_timeout)
>>> +	if (io_should_wake(iowq) || io_has_work(iowq->ctx) ||
>>> +	    READ_ONCE(iowq->hit_timeout))
>>>  		return autoremove_wake_function(curr, mode, wake_flags, key);
>>>  	return -1;
>>>  }
>>> @@ -2359,13 +2360,66 @@ static enum hrtimer_restart io_cqring_timer_wakeup(struct hrtimer *timer)
>>>  	return HRTIMER_NORESTART;
>>>  }
>>>  
>>> +/*
>>> + * Doing min_timeout portion. If we saw any timeouts, events, or have work,
>>> + * wake up. If not, and we have a normal timeout, switch to that and keep
>>> + * sleeping.
>>> + */
>>> +static enum hrtimer_restart io_cqring_min_timer_wakeup(struct hrtimer *timer)
>>> +{
>>> +	struct io_wait_queue *iowq = container_of(timer, struct io_wait_queue, t);
>>> +	struct io_ring_ctx *ctx = iowq->ctx;
>>> +
>>> +	/* no general timeout, or shorter, we are done */
>>> +	if (iowq->timeout == KTIME_MAX ||
>>> +	    ktime_after(iowq->min_timeout, iowq->timeout))
>>> +		goto out_wake;
>>> +	/* work we may need to run, wake function will see if we need to wake */
>>> +	if (io_has_work(ctx))
>>> +		goto out_wake;
>>> +	/* got events since we started waiting, min timeout is done */
>>> +	if (iowq->cq_min_tail != READ_ONCE(ctx->rings->cq.tail))
>>> +		goto out_wake;
>>> +	/* if we have any events and min timeout expired, we're done */
>>> +	if (io_cqring_events(ctx))
>>> +		goto out_wake;
>>> +
>>> +	/*
>>> +	 * If using deferred task_work running and application is waiting on
>>> +	 * more than one request, ensure we reset it now where we are switching
>>> +	 * to normal sleeps. Any request completion post min_wait should wake
>>> +	 * the task and return.
>>> +	 */
>>> +	if (ctx->flags & IORING_SETUP_DEFER_TASKRUN) {
>>> +		atomic_set(&ctx->cq_wait_nr, 1);
>>> +		smp_mb();
>>> +		if (!llist_empty(&ctx->work_llist))
>>> +			goto out_wake;
>>> +	}
>>> +
>>> +	iowq->t.function = io_cqring_timer_wakeup;
>>> +	hrtimer_set_expires(timer, iowq->timeout);
>>
>> What happens if timeout < min_timeout? Would the timer expired callback
>> io_cqring_timer_wakeup() be called right away?
> 
> See the test cases, test/min-timeout-wait.c has various cases like that
> to ensure that they work. But the first check in this function is for
> timeout not being set, or being smaller to the min_timeout.
> 
>>> +	return HRTIMER_RESTART;
>>> +out_wake:
>>> +	return io_cqring_timer_wakeup(timer);
>>> +}
>>> +
>>>  static int io_cqring_schedule_timeout(struct io_wait_queue *iowq,
>>> -				      clockid_t clock_id)
>>> +				      clockid_t clock_id, ktime_t start_time)
>>>  {
>>> -	iowq->hit_timeout = 0;
>>> +	ktime_t timeout;
>>> +
>>> +	WRITE_ONCE(iowq->hit_timeout, 0);
>>>  	hrtimer_init_on_stack(&iowq->t, clock_id, HRTIMER_MODE_ABS);
>>> -	iowq->t.function = io_cqring_timer_wakeup;
>>> -	hrtimer_set_expires_range_ns(&iowq->t, iowq->timeout, 0);
>>> +	if (iowq->min_timeout) {
>>> +		timeout = ktime_add_ns(iowq->min_timeout, start_time);
>>> +		iowq->t.function = io_cqring_min_timer_wakeup;
>>> +	} else {
>>> +		timeout = iowq->timeout;
>>> +		iowq->t.function = io_cqring_timer_wakeup;
>>> +	}
>>> +
>>> +	hrtimer_set_expires_range_ns(&iowq->t, timeout, 0);
>>>  	hrtimer_start_expires(&iowq->t, HRTIMER_MODE_ABS);
>>>  
>>>  	if (!READ_ONCE(iowq->hit_timeout))
>>> @@ -2379,7 +2433,8 @@ static int io_cqring_schedule_timeout(struct io_wait_queue *iowq,
>>>  }
>>>  
>>>  static int __io_cqring_wait_schedule(struct io_ring_ctx *ctx,
>>> -				     struct io_wait_queue *iowq)
>>> +				     struct io_wait_queue *iowq,
>>> +				     ktime_t start_time)
>>>  {
>>>  	int ret = 0;
>>>  
>>> @@ -2390,8 +2445,8 @@ static int __io_cqring_wait_schedule(struct io_ring_ctx *ctx,
>>>  	 */
>>>  	if (current_pending_io())
>>>  		current->in_iowait = 1;
>>> -	if (iowq->timeout != KTIME_MAX)
>>> -		ret = io_cqring_schedule_timeout(iowq, ctx->clockid);
>>> +	if (iowq->timeout != KTIME_MAX || iowq->min_timeout != KTIME_MAX)
>>> +		ret = io_cqring_schedule_timeout(iowq, ctx->clockid, start_time);
>>
>> In this case it is possible for either timeout or min_timeout to be
>> KTIME_MAX and still schedule a timeout.
>>
>> If min_timeout != KTIME_MAX and timeout == KTIME_MAX, then
>> io_cqring_min_timer_wakeup() will reset itself to a timer with
>> KTIME_MAX.
>>
>> If min_timeout == KTIME_MAX and timeout != KTIME_MAX, then a KTIME_MAX
>> timer will be set.
>>
>> This should be fine, the timer will never expire and schedule() is
>> called regardless. The previous code is a small optimisation to avoid
>> setting up a timer that will never expire.
> 
> We should not be setting up a timer if both min-timeout and regular
> timeout are not given. Am I missing something? If either is set, we need
> a timer to wake us up. If neither is set, we should not be setting up a
> timer, we just need to call schedule().

Yeah, mostly talking to myself. If min_timeout == KTIME_MAX and timeout
is valid then we end up setting a timer that would never expire. I think
this is one case where scheduling a timer can be skipped. But I don't
think it will matter.

> 
>>> @@ -2400,7 +2455,8 @@ static int __io_cqring_wait_schedule(struct io_ring_ctx *ctx,
>>>  
>>>  /* If this returns > 0, the caller should retry */
>>>  static inline int io_cqring_wait_schedule(struct io_ring_ctx *ctx,
>>> -					  struct io_wait_queue *iowq)
>>> +					  struct io_wait_queue *iowq,
>>> +					  ktime_t start_time)
>>>  {
>>>  	if (unlikely(READ_ONCE(ctx->check_cq)))
>>>  		return 1;
>>> @@ -2413,7 +2469,7 @@ static inline int io_cqring_wait_schedule(struct io_ring_ctx *ctx,
>>>  	if (unlikely(io_should_wake(iowq)))
>>>  		return 0;
>>>  
>>> -	return __io_cqring_wait_schedule(ctx, iowq);
>>> +	return __io_cqring_wait_schedule(ctx, iowq, start_time);
>>>  }
>>>  
>>>  struct ext_arg {
>>> @@ -2431,6 +2487,7 @@ static int io_cqring_wait(struct io_ring_ctx *ctx, int min_events, u32 flags,
>>>  {
>>>  	struct io_wait_queue iowq;
>>>  	struct io_rings *rings = ctx->rings;
>>> +	ktime_t start_time;
>>>  	int ret;
>>>  
>>>  	if (!io_allowed_run_tw(ctx))
>>> @@ -2449,8 +2506,11 @@ static int io_cqring_wait(struct io_ring_ctx *ctx, int min_events, u32 flags,
>>>  	INIT_LIST_HEAD(&iowq.wq.entry);
>>>  	iowq.ctx = ctx;
>>>  	iowq.nr_timeouts = atomic_read(&ctx->cq_timeouts);
>>> +	iowq.cq_min_tail = READ_ONCE(ctx->rings->cq.tail);
>>>  	iowq.cq_tail = READ_ONCE(ctx->rings->cq.head) + min_events;
>>> +	iowq.min_timeout = 0;
>>>  	iowq.timeout = KTIME_MAX;
>>> +	start_time = io_get_time(ctx);
>>>  
>>>  	if (ext_arg->ts) {
>>>  		struct timespec64 ts;
>>> @@ -2460,7 +2520,7 @@ static int io_cqring_wait(struct io_ring_ctx *ctx, int min_events, u32 flags,
>>>  
>>>  		iowq.timeout = timespec64_to_ktime(ts);
>>>  		if (!(flags & IORING_ENTER_ABS_TIMER))
>>> -			iowq.timeout = ktime_add(iowq.timeout, io_get_time(ctx));
>>> +			iowq.timeout = ktime_add(iowq.timeout, start_time);
>>>  	}
>>>  
>>>  	if (ext_arg->sig) {
>>> @@ -2484,14 +2544,16 @@ static int io_cqring_wait(struct io_ring_ctx *ctx, int min_events, u32 flags,
>>>  		unsigned long check_cq;
>>>  
>>>  		if (ctx->flags & IORING_SETUP_DEFER_TASKRUN) {
>>> -			atomic_set(&ctx->cq_wait_nr, nr_wait);
>>> +			/* if min timeout has been hit, don't reset wait count */
>>> +			if (!READ_ONCE(iowq.hit_timeout))
>>> +				atomic_set(&ctx->cq_wait_nr, nr_wait);
>>
>> Only the two timeout expired callback functions
>> io_cqring_min_timer_wakeup() and io_cqring_timer_wakeup() sets
>> hit_timeout to 1. In this case, io_cqring_schedule_timeout() would
>> return -ETIME and the do {...} while(1) loop in io_cqring_wait() would
>> break. So I'm not sure if it is possible to reach here with hit_timeout
>> = 1.
>>
>> Also, in the first iteration of the loop, hit_timeout is init to 0
>> inside of io_cqring_wait_schedule() -> __io_cqring_wait_schedule() ->
>> io_cqring_schedule_timeout(). So it is possible for hit_timeout to be
>> READ_ONCE before it is initialised. If this code is kept we should init
>> iowq.hit_timeout = 0 above.
> 
> Yeah we probably should initialize it. The issue here isn't really if a
> timer woke us up, it's if the task got woken by something else and loop
> around for another retry. If that coincides with the timeout hitting,
> then we should not re-set ->cq_wait_nr as it should've been already set
> to 1 so any request being added will wake us up.

Ahh right, the so called 'spurious wakeups'. The timer may run after the
task is woken up by something else, and before the timer is cancelled.
In this case the task should definitely not touch cq_wait_nr if the
timer callback already set it to 1!

> 

