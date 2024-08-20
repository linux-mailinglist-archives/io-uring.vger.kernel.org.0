Return-Path: <io-uring+bounces-2863-lists+io-uring=lfdr.de@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from sy.mirrors.kernel.org (sy.mirrors.kernel.org [IPv6:2604:1380:40f1:3f00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id C96129590C4
	for <lists+io-uring@lfdr.de>; Wed, 21 Aug 2024 00:58:41 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sy.mirrors.kernel.org (Postfix) with ESMTPS id 11EFEB222B2
	for <lists+io-uring@lfdr.de>; Tue, 20 Aug 2024 22:58:39 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 991661C7B6B;
	Tue, 20 Aug 2024 22:58:35 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel-dk.20230601.gappssmtp.com header.i=@kernel-dk.20230601.gappssmtp.com header.b="UhUPz5um"
X-Original-To: io-uring@vger.kernel.org
Received: from mail-pg1-f174.google.com (mail-pg1-f174.google.com [209.85.215.174])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 310FF1514FB
	for <io-uring@vger.kernel.org>; Tue, 20 Aug 2024 22:58:32 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.215.174
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1724194715; cv=none; b=JeS1DfrZYIi0Eg3jIxOHKoYa2NZxusjHLpaELJxUaQdfhOy6WngJqbkttB2qKHaHhE/GdOg8yRCunmLaPerlwU0g1poASukX9Ia27hBFTXUXMM/yJhy2dtSyoBmmHGI/BuAcea/4JeVYkwCikHalRRb0sFVsqK1JPxQrXG+sMEs=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1724194715; c=relaxed/simple;
	bh=djee/uYYvB4jAOPlYXrmqtRhoT6yANAGz+JwDEqW+eA=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=VTpFZRHaaUZyHTmaBLOKB2SezGcWuYRG4Dx0lqB5q2E4Jk6aWQyRASXG27GVO3FWLRqqB8gYspbOIXmu9QGbDpuwwln98CsyUNf9LrtZRkJv2peSqfocZe9Od+H91VBX3ynCLcTLw1ww9nkNd0woBcrniRv4XyX06VpgzU9i/hE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=kernel.dk; spf=pass smtp.mailfrom=kernel.dk; dkim=pass (2048-bit key) header.d=kernel-dk.20230601.gappssmtp.com header.i=@kernel-dk.20230601.gappssmtp.com header.b=UhUPz5um; arc=none smtp.client-ip=209.85.215.174
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=kernel.dk
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=kernel.dk
Received: by mail-pg1-f174.google.com with SMTP id 41be03b00d2f7-7c691c8f8dcso4054525a12.1
        for <io-uring@vger.kernel.org>; Tue, 20 Aug 2024 15:58:32 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernel-dk.20230601.gappssmtp.com; s=20230601; t=1724194712; x=1724799512; darn=vger.kernel.org;
        h=content-transfer-encoding:in-reply-to:from:content-language
         :references:cc:to:subject:user-agent:mime-version:date:message-id
         :from:to:cc:subject:date:message-id:reply-to;
        bh=MjlPY2moZxU9gbiwjaTmzOATcTkBOfV5APuZJANraUE=;
        b=UhUPz5umgfRTaT5GVoDNtNcE6tl6irYZ78zvN5bZfk6sPabwcCw9QssBwesq63NHDa
         Nr2NGBZeTCvNeYNdKmZ4u0aFkFGW7d8R2AjFTA54r0EZmYCK5AT/MAghI5DXCAR+YFHY
         si+pRFpFcgLn6tE0ZQH7zWNzye+SVqOmqNwqRaIZIjGNpRc0HgnmCt6syoOzk82xnB7h
         FbBise3LnZ00CpYh3Y8cbkYmPatY2SIkU9/RzqRBOghuQXG9MkcTl7rtTWyK12GpF+z0
         i9zu9urfqWVJAmt+ospBbLhi26sb4BluhVO3Zg9r15xxHO84Zpshth7dSbbPBVqLp4aS
         USFg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1724194712; x=1724799512;
        h=content-transfer-encoding:in-reply-to:from:content-language
         :references:cc:to:subject:user-agent:mime-version:date:message-id
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=MjlPY2moZxU9gbiwjaTmzOATcTkBOfV5APuZJANraUE=;
        b=b7rrF7EIksuFoct3LJWU0nEwC2UkAXtCImXzgaJIb0BHwoltZ2xorZZ/qO5Gky+dnl
         gLMNR+cyoIRQMFQIw3Wu7w+WFDuNzLy5XesmlFkTxBaH4oKVZm0yZHkw1t9XSASCJVIF
         f5yU0fA7m55wUN9YefZf1fxWWqVDYvIAlvF1ED02qBSiyis1PxJuGLSRCq8uwyU3Ax8Y
         odzV9Y3kIqkrAAZKYAJanJjkmf7LsrUFzmP8eUGU/iYlOZyLm0wfOfzo4CMe4/OjV+Jh
         guKmLsXvJcg5l7KVXUiRBi9miuZb009pwob4a+Mhqby/TNdHBxiZZh7mTiWtFA2q8Mvx
         /k4A==
X-Forwarded-Encrypted: i=1; AJvYcCWNQ4c5cTEbSIOuYkmlvFVatIUHIYGz346avHZIsjzxEv06UGj5Uij1Z2ovfWUYYpVgVU2pTAgEyw==@vger.kernel.org
X-Gm-Message-State: AOJu0Yz/IbhCGYXZAaRd1GmPNGzHRDm0sy833kojyEZq6zM17qSOdKNh
	3MHUmhHUdqYE8sH/gUk/CzK7RU0tS7rPZLIbfD2NOZnkfBZeIBUSFkOcmXTo5jgqHPossAnzJLg
	K
X-Google-Smtp-Source: AGHT+IE/QgbXwJHdrS9OL6Mr2/FXeScg9VIs/UC9Vjv0cVB2kN4aYy0I6MGPYE91Hr7YB/Oclvi25A==
X-Received: by 2002:a05:6300:668b:b0:1c3:fc60:84f1 with SMTP id adf61e73a8af0-1cad7f728f6mr1011374637.7.1724194712355;
        Tue, 20 Aug 2024 15:58:32 -0700 (PDT)
Received: from [192.168.1.150] ([198.8.77.157])
        by smtp.gmail.com with ESMTPSA id d9443c01a7336-201f0376aebsm83057375ad.176.2024.08.20.15.58.30
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Tue, 20 Aug 2024 15:58:31 -0700 (PDT)
Message-ID: <b9fbfad3-717e-45e9-b66e-e90799c5a2f3@kernel.dk>
Date: Tue, 20 Aug 2024 16:58:30 -0600
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
References: <20240819233042.230956-1-axboe@kernel.dk>
 <20240819233042.230956-5-axboe@kernel.dk>
 <abbab9cf-1249-4463-88cc-85a51399a950@gmail.com>
 <aa17480b-ce0a-4569-9f28-f44bdf057aa9@gmail.com>
Content-Language: en-US
From: Jens Axboe <axboe@kernel.dk>
In-Reply-To: <aa17480b-ce0a-4569-9f28-f44bdf057aa9@gmail.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

On 8/20/24 4:47 PM, Pavel Begunkov wrote:
> On 8/20/24 23:46, Pavel Begunkov wrote:
>> On 8/20/24 00:28, Jens Axboe wrote:
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
>>>   io_uring/io_uring.c | 75 +++++++++++++++++++++++++++++++++++++++------
>>>   io_uring/io_uring.h |  2 ++
>>>   2 files changed, 67 insertions(+), 10 deletions(-)
>>>
>>> diff --git a/io_uring/io_uring.c b/io_uring/io_uring.c
>>> index ddfbe04c61ed..d09a7c2e1096 100644
>>> --- a/io_uring/io_uring.c
>>> +++ b/io_uring/io_uring.c
>>> @@ -2363,13 +2363,62 @@ static enum hrtimer_restart io_cqring_timer_wakeup(struct hrtimer *timer)
>>>       return HRTIMER_NORESTART;
>>>   }
>>> +/*
>>> + * Doing min_timeout portion. If we saw any timeouts, events, or have work,
>>> + * wake up. If not, and we have a normal timeout, switch to that and keep
>>> + * sleeping.
>>> + */
>>> +static enum hrtimer_restart io_cqring_min_timer_wakeup(struct hrtimer *timer)
>>> +{
>>> +    struct io_wait_queue *iowq = container_of(timer, struct io_wait_queue, t);
>>> +    struct io_ring_ctx *ctx = iowq->ctx;
>>> +
>>> +    /* no general timeout, or shorter, we are done */
>>> +    if (iowq->timeout == KTIME_MAX ||
>>> +        ktime_after(iowq->min_timeout, iowq->timeout))
>>> +        goto out_wake;
>>> +    /* work we may need to run, wake function will see if we need to wake */
>>> +    if (io_has_work(ctx))
>>> +        goto out_wake;
>>> +    /* got events since we started waiting, min timeout is done */
>>> +    if (iowq->cq_min_tail != READ_ONCE(ctx->rings->cq.tail))
>>> +        goto out_wake;
>>> +    /* if we have any events and min timeout expired, we're done */
>>> +    if (io_cqring_events(ctx))
>>> +        goto out_wake;
>>> +
>>> +    /*
>>> +     * If using deferred task_work running and application is waiting on
>>> +     * more than one request, ensure we reset it now where we are switching
>>> +     * to normal sleeps. Any request completion post min_wait should wake
>>> +     * the task and return.
>>> +     */
>>> +    if (ctx->flags & IORING_SETUP_DEFER_TASKRUN)
>>> +        atomic_set(&ctx->cq_wait_nr, 1);
>>
>> racy
>>
>> atomic_set(&ctx->cq_wait_nr, 1);
>> smp_mb();
>> if (llist_empty(&ctx->work_llist))
>>      // wake;
> 
> rather if _not_ empty

Yep that one was a given :-)

Updated it, we'll punt to out_wake at that point.

-- 
Jens Axboe



