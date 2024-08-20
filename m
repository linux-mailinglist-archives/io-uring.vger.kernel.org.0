Return-Path: <io-uring+bounces-2845-lists+io-uring=lfdr.de@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from sy.mirrors.kernel.org (sy.mirrors.kernel.org [IPv6:2604:1380:40f1:3f00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id EC487958F79
	for <lists+io-uring@lfdr.de>; Tue, 20 Aug 2024 23:10:37 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sy.mirrors.kernel.org (Postfix) with ESMTPS id 2D7CAB22BFF
	for <lists+io-uring@lfdr.de>; Tue, 20 Aug 2024 21:10:35 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 71DC71C4602;
	Tue, 20 Aug 2024 21:10:13 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=davidwei-uk.20230601.gappssmtp.com header.i=@davidwei-uk.20230601.gappssmtp.com header.b="OIEl93dP"
X-Original-To: io-uring@vger.kernel.org
Received: from mail-pf1-f171.google.com (mail-pf1-f171.google.com [209.85.210.171])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B9EAE1BE222
	for <io-uring@vger.kernel.org>; Tue, 20 Aug 2024 21:10:11 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.210.171
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1724188213; cv=none; b=EbLK03UCTjvNO4K34ulE+iL6B+gECQae/rdMIQvV46Smq0UTHJYuC91+48h2TwF6LwW8shQT3nQ3KNEWaVcrdtlFdL54EOSTk7ZV17G+JmblI7p61aLaolc1BV1S3w0sRtaLErio+wMpYNWZETvNl8xQwRTg+O+qke0Ib9LvG3U=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1724188213; c=relaxed/simple;
	bh=fu5dKLP5+mTV5YlVZEyMxpgaArRT3Ulak2ahJPsfag4=;
	h=Message-ID:Date:MIME-Version:Subject:To:References:From:
	 In-Reply-To:Content-Type; b=DUNTLC4goVBWN7GjkVTpabg5AAhA1g0d3m9qDD5EPmdQozUDXOq7KAXUXF4RHiR9MwS1ltRYyVDBMkhMPHoP6R+DlrvD6DLbEUiB7J1pS/pZTe1Z9FoGQlNz5J2B/U0A/tdVLGg9v9KcY4TokvRdwI32922DxKx1IO67DG9gxOw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=davidwei.uk; spf=none smtp.mailfrom=davidwei.uk; dkim=pass (2048-bit key) header.d=davidwei-uk.20230601.gappssmtp.com header.i=@davidwei-uk.20230601.gappssmtp.com header.b=OIEl93dP; arc=none smtp.client-ip=209.85.210.171
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=davidwei.uk
Authentication-Results: smtp.subspace.kernel.org; spf=none smtp.mailfrom=davidwei.uk
Received: by mail-pf1-f171.google.com with SMTP id d2e1a72fcca58-70d1c655141so3909384b3a.1
        for <io-uring@vger.kernel.org>; Tue, 20 Aug 2024 14:10:11 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=davidwei-uk.20230601.gappssmtp.com; s=20230601; t=1724188211; x=1724793011; darn=vger.kernel.org;
        h=content-transfer-encoding:in-reply-to:from:references:to
         :content-language:subject:user-agent:mime-version:date:message-id
         :from:to:cc:subject:date:message-id:reply-to;
        bh=AjkftimJvFUwk64tGQAXT2pX96PSrpw+Cv9nUZtQj7I=;
        b=OIEl93dPUVsMP8/yiOl3JKarlMxkgcYh99bhVHs2pnTB6+9eUxWq3cdkq8FoRa3+XX
         1DJFi6n3p3GJFOg1miY2ln9elONM0hshV4LpSSWxFXml/szuJHzS6vDvw0/sslQIQ+/X
         RYgUvvQxsag4wQwYfh1ybhxzmeHNZahQyRttvNMlVy8h7LzjLyXAm/0YGIaQG/riooL3
         3dQIwKgDx02LZ8g8u6/NTvzfzlq/owmQKgkSvWaqzDQbInS3+2avPJIMIFpaW35rHhBz
         BiK+WGEZ9KZsAdFdZaa5Lg1uO75Ggn1xs4rgPmMWhJ2XOzs1Y6j7cCzxRrUM62sI/BLl
         IZJg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1724188211; x=1724793011;
        h=content-transfer-encoding:in-reply-to:from:references:to
         :content-language:subject:user-agent:mime-version:date:message-id
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=AjkftimJvFUwk64tGQAXT2pX96PSrpw+Cv9nUZtQj7I=;
        b=CywFn+fbpap3J/lY3AHetJ/lIiY1r/TN3pffVIYLuzwVAo0ks7Nf15/tOilP5KFnob
         mE/e/tLUgVZekJ6gzt4KJ5vy4QWOuzUJdioywwyTdXTcCvnRdXcWjnHtsTzOFdCRgQje
         GX8qV9u5yfzJ2ilgg2pukIIcyw4VVK7zDqZWMQ3NGbcl/hz/Wz7JDbtTcSS4to9bVbMi
         ra3wnp4dDEJVdLi647nKUKSojTx6dXFy+s+0R7sndbT56o9WjWlRBFr4tR4/oV8aDQFk
         KVA9C7hh/939nfgjWaVPD/WpErzKn8Bq8xK7elYxdHB91ouULHYCCNDrkE2uXLbUXroz
         XCaA==
X-Forwarded-Encrypted: i=1; AJvYcCWyodVcnBu6tdB6lBA76C9y/BdEmzaVqC3lWL6y9X+kUvwy/Ok2i7RKJnkErYOi9aUIG9jDNHBDrg==@vger.kernel.org
X-Gm-Message-State: AOJu0YyNnhBoOJg4nFh3ylOW2ZH7g0CVDiSMOTzcaXG+FpOWcEcyfy+Z
	s0y2GCz4iTtoltUcIeAEQKPY6tNqpvSCuMWw9uToyeDLkANnQL1kKdWhKKBFxSpNRK4SyPrRfwR
	c4AY=
X-Google-Smtp-Source: AGHT+IEJotXuy9HL6AedAKkmWbrspRKa9HckPKTlLs5ix+FE375DANxHtGaNhYva3vA3NntOvtB4wQ==
X-Received: by 2002:a05:6a00:2d25:b0:70d:1b48:e362 with SMTP id d2e1a72fcca58-714235bb00fmr330855b3a.26.1724188210817;
        Tue, 20 Aug 2024 14:10:10 -0700 (PDT)
Received: from ?IPV6:2a03:83e0:1256:1:80c:c984:f4f1:951f? ([2620:10d:c090:500::5:2f5b])
        by smtp.gmail.com with ESMTPSA id d2e1a72fcca58-7127ae11b3csm8636856b3a.71.2024.08.20.14.10.10
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Tue, 20 Aug 2024 14:10:10 -0700 (PDT)
Message-ID: <c9d18b99-96a8-4c86-abe0-0535f395ccc6@davidwei.uk>
Date: Tue, 20 Aug 2024 14:10:09 -0700
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
References: <20240819233042.230956-1-axboe@kernel.dk>
 <20240819233042.230956-5-axboe@kernel.dk>
From: David Wei <dw@davidwei.uk>
In-Reply-To: <20240819233042.230956-5-axboe@kernel.dk>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit

On 2024-08-19 16:28, Jens Axboe wrote:
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

I think the batch request count should be applied to the min_timeout,
such that:

start_time          min_timeout            timeout
    |--------------------|--------------------|

Return to user between [start_time, min_timeout) if there are wait_nr
number of completions, checked by io_req_local_work_add(), or is it
io_wake_function()?

Return to user between [min_timeout, timeout) if there are at least one
completion.

Return to user at timeout always.

> 
> Signed-off-by: Jens Axboe <axboe@kernel.dk>
> ---
>  io_uring/io_uring.c | 75 +++++++++++++++++++++++++++++++++++++++------
>  io_uring/io_uring.h |  2 ++
>  2 files changed, 67 insertions(+), 10 deletions(-)
> 
> diff --git a/io_uring/io_uring.c b/io_uring/io_uring.c
> index ddfbe04c61ed..d09a7c2e1096 100644
> --- a/io_uring/io_uring.c
> +++ b/io_uring/io_uring.c
> @@ -2363,13 +2363,62 @@ static enum hrtimer_restart io_cqring_timer_wakeup(struct hrtimer *timer)
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

How can ctx->rings->cq.tail be modified if the task is sleeping while
waiting for completions? What is doing the work?

> +
> +	/*
> +	 * If using deferred task_work running and application is waiting on
> +	 * more than one request, ensure we reset it now where we are switching
> +	 * to normal sleeps. Any request completion post min_wait should wake
> +	 * the task and return.
> +	 */
> +	if (ctx->flags & IORING_SETUP_DEFER_TASKRUN)
> +		atomic_set(&ctx->cq_wait_nr, 1);
> +
> +	iowq->t.function = io_cqring_timer_wakeup;
> +	hrtimer_set_expires(timer, iowq->timeout);
> +	return HRTIMER_RESTART;
> +out_wake:
> +	return io_cqring_timer_wakeup(timer);
> +}
> +
>  static int io_cqring_schedule_timeout(struct io_wait_queue *iowq,
> -				      clockid_t clock_id)
> +				      clockid_t clock_id, ktime_t start_time)
>  {
> +	ktime_t timeout;
> +
>  	iowq->hit_timeout = 0;
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

