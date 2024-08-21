Return-Path: <io-uring+bounces-2873-lists+io-uring=lfdr.de@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [147.75.199.223])
	by mail.lfdr.de (Postfix) with ESMTPS id 804F7959FA9
	for <lists+io-uring@lfdr.de>; Wed, 21 Aug 2024 16:22:47 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id A548E1C2042E
	for <lists+io-uring@lfdr.de>; Wed, 21 Aug 2024 14:22:46 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 8FD2F18C348;
	Wed, 21 Aug 2024 14:22:44 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel-dk.20230601.gappssmtp.com header.i=@kernel-dk.20230601.gappssmtp.com header.b="JRo5OZKx"
X-Original-To: io-uring@vger.kernel.org
Received: from mail-io1-f45.google.com (mail-io1-f45.google.com [209.85.166.45])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E654C1B1D4B
	for <io-uring@vger.kernel.org>; Wed, 21 Aug 2024 14:22:40 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.166.45
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1724250164; cv=none; b=SQL5dOcDvEW3fAnVPatArTsAryOvqd/UgUSHH849XdaVXUOn+MzakHY6VDuTy5dMQAyLKfyJWHNkAzdx3Qv9NQScWEcmxSnYpVLxc5seHSe3Uh+nDRwoR9r3T7TZMy7sVKKkHs0ujCDaMltUKhNZjkjIr9f+hUdsl9J0BoILHrY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1724250164; c=relaxed/simple;
	bh=OTatB2rYnJgFgAFbS5aacogfaaRXTX8ZMslp2b+vmco=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=gsGCx/Hw/Ee/O00+RduXL6LICup0r9y4vC881gluPo/1PTLdrWwqSTt0TNDrJsAVGpha0QRINsvTpDOWxzwuEKVm+PUFlooc2QQWiVwCx6c98c0Wjz4iX8VGhXmyIUGKtgexNiqppS47hJ0lxWSBp2tzss/kR7P6rNCzndXsWi8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=kernel.dk; spf=pass smtp.mailfrom=kernel.dk; dkim=pass (2048-bit key) header.d=kernel-dk.20230601.gappssmtp.com header.i=@kernel-dk.20230601.gappssmtp.com header.b=JRo5OZKx; arc=none smtp.client-ip=209.85.166.45
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=kernel.dk
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=kernel.dk
Received: by mail-io1-f45.google.com with SMTP id ca18e2360f4ac-81f96eaa02aso366082939f.2
        for <io-uring@vger.kernel.org>; Wed, 21 Aug 2024 07:22:40 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernel-dk.20230601.gappssmtp.com; s=20230601; t=1724250160; x=1724854960; darn=vger.kernel.org;
        h=content-transfer-encoding:in-reply-to:from:content-language
         :references:cc:to:subject:user-agent:mime-version:date:message-id
         :from:to:cc:subject:date:message-id:reply-to;
        bh=foVOMneni3NZw+uThNkk5I0DOTHu7b8Pa30zchlZonE=;
        b=JRo5OZKxfr9WVK98MOaHpYRyA7Rzug/uw36kyQjiQwPa00wq7hyWhEyTL5JuZ1Wdu9
         fJ5zZ6rAKGXAqyhrU4BCiB+61jZ/mOYEZXkLQKsTVaHZoWI0USI3SO5LIVVi2SRJ7cCS
         cyeD06jL4xL8YkQ14h0NyE9ZIjJImFJ2Zl5oXh8j4JWcdxDZcT4QGfbVjpKLMhSh9Sv5
         HqTVWFZYpuARkfQesD1YreN31jiaxPdIVjEndAN+YM/tPLjnNEyOjegq5apgxp5uJukb
         hadWoxHGXGM8idNQzZhXUu6V7ejxUeZKl0+RFrw+PKWyWwynmq6K4ddDttXA4l9UGURg
         caDw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1724250160; x=1724854960;
        h=content-transfer-encoding:in-reply-to:from:content-language
         :references:cc:to:subject:user-agent:mime-version:date:message-id
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=foVOMneni3NZw+uThNkk5I0DOTHu7b8Pa30zchlZonE=;
        b=jRnIY0sgKjlBoC9258M2ysFn3ZRBmgiP4Q2ib+3/bzPV7EGX/eWKIV5jiJ0FMXYg7C
         +RmCz3AiAQWNIvN50RyLiReDx54CxRO591pkwdKeR2fb7a8O0SATipGlIulrRIfpLX20
         o42bQZt8Z77MoWWvdiWflVt1MES0SIglMET3Fq2Cw/zloFcCyneaGSnrO2hADDD/W9Ek
         a/mzYbGp3NYvHypy5a9kghSrtRX0NFwHEcLHRROnGDg9aqcBMVeYslSGi8TL6esrX8De
         gulg4rEfLPDymaiNsN1vi66EOgGzMK1pXcAxkL4B1fyJysOyHjySsyso7ia/dRUTiqVa
         KMww==
X-Forwarded-Encrypted: i=1; AJvYcCXduZRrhOXqoFmekoN3wT6UBOeXvC7jLocSGKAfzPWIFiUHFQtQBFgWBiK1McYvNIkArid0lSOZ/w==@vger.kernel.org
X-Gm-Message-State: AOJu0YyBqzjyy97Wi5xZyWpv1NmuCwjvY6jAl1i17jlzIdTldw8Lt2I2
	O7W3u856pGguTpFCcaQJadB/A5U+X5A+goOk3McfqH2+G3HKU0Dv0vJXP6nZeW5tihFD2wKcXEk
	m
X-Google-Smtp-Source: AGHT+IHl8q+D7W1Mod64MRR8qm4xxvPs+eROZkMl6o3IZoTysSBDS+CJusGAJNoZlXQH20NbrD8Y8g==
X-Received: by 2002:a05:6602:1490:b0:803:5e55:ecb2 with SMTP id ca18e2360f4ac-825318032f1mr258584239f.0.1724250159955;
        Wed, 21 Aug 2024 07:22:39 -0700 (PDT)
Received: from [192.168.1.116] ([96.43.243.2])
        by smtp.gmail.com with ESMTPSA id 8926c6da1cb9f-4ccd6f3e264sm4616353173.103.2024.08.21.07.22.39
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Wed, 21 Aug 2024 07:22:39 -0700 (PDT)
Message-ID: <d6771a36-d3b4-4817-8121-298b2e3ea54b@kernel.dk>
Date: Wed, 21 Aug 2024 08:22:38 -0600
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
 <b9fbfad3-717e-45e9-b66e-e90799c5a2f3@kernel.dk>
 <6f2389c9-7bd7-42b5-bc9e-1db6ddb90d3b@gmail.com>
Content-Language: en-US
From: Jens Axboe <axboe@kernel.dk>
In-Reply-To: <6f2389c9-7bd7-42b5-bc9e-1db6ddb90d3b@gmail.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit

On 8/20/24 6:08 PM, Pavel Begunkov wrote:
> On 8/20/24 23:58, Jens Axboe wrote:
>> On 8/20/24 4:47 PM, Pavel Begunkov wrote:
>>> On 8/20/24 23:46, Pavel Begunkov wrote:
>>>> On 8/20/24 00:28, Jens Axboe wrote:
>>>>> Waiting for events with io_uring has two knobs that can be set:
>>>>>
>>>>> 1) The number of events to wake for
>>>>> 2) The timeout associated with the event
>>>>>
>>>>> Waiting will abort when either of those conditions are met, as expected.
>>>>>
>>>>> This adds support for a third event, which is associated with the number
>>>>> of events to wait for. Applications generally like to handle batches of
>>>>> completions, and right now they'd set a number of events to wait for and
>>>>> the timeout for that. If no events have been received but the timeout
>>>>> triggers, control is returned to the application and it can wait again.
>>>>> However, if the application doesn't have anything to do until events are
>>>>> reaped, then it's possible to make this waiting more efficient.
>>>>>
>>>>> For example, the application may have a latency time of 50 usecs and
>>>>> wanting to handle a batch of 8 requests at the time. If it uses 50 usecs
>>>>> as the timeout, then it'll be doing 20K context switches per second even
>>>>> if nothing is happening.
>>>>>
>>>>> This introduces the notion of min batch wait time. If the min batch wait
>>>>> time expires, then we'll return to userspace if we have any events at all.
>>>>> If none are available, the general wait time is applied. Any request
>>>>> arriving after the min batch wait time will cause waiting to stop and
>>>>> return control to the application.
>>>>>
>>>>> Signed-off-by: Jens Axboe <axboe@kernel.dk>
>>>>> ---
>>>>>    io_uring/io_uring.c | 75 +++++++++++++++++++++++++++++++++++++++------
>>>>>    io_uring/io_uring.h |  2 ++
>>>>>    2 files changed, 67 insertions(+), 10 deletions(-)
>>>>>
>>>>> diff --git a/io_uring/io_uring.c b/io_uring/io_uring.c
>>>>> index ddfbe04c61ed..d09a7c2e1096 100644
>>>>> --- a/io_uring/io_uring.c
>>>>> +++ b/io_uring/io_uring.c
>>>>> @@ -2363,13 +2363,62 @@ static enum hrtimer_restart io_cqring_timer_wakeup(struct hrtimer *timer)
>>>>>        return HRTIMER_NORESTART;
>>>>>    }
>>>>> +/*
>>>>> + * Doing min_timeout portion. If we saw any timeouts, events, or have work,
>>>>> + * wake up. If not, and we have a normal timeout, switch to that and keep
>>>>> + * sleeping.
>>>>> + */
>>>>> +static enum hrtimer_restart io_cqring_min_timer_wakeup(struct hrtimer *timer)
>>>>> +{
>>>>> +    struct io_wait_queue *iowq = container_of(timer, struct io_wait_queue, t);
>>>>> +    struct io_ring_ctx *ctx = iowq->ctx;
>>>>> +
>>>>> +    /* no general timeout, or shorter, we are done */
>>>>> +    if (iowq->timeout == KTIME_MAX ||
>>>>> +        ktime_after(iowq->min_timeout, iowq->timeout))
>>>>> +        goto out_wake;
>>>>> +    /* work we may need to run, wake function will see if we need to wake */
>>>>> +    if (io_has_work(ctx))
>>>>> +        goto out_wake;
>>>>> +    /* got events since we started waiting, min timeout is done */
>>>>> +    if (iowq->cq_min_tail != READ_ONCE(ctx->rings->cq.tail))
>>>>> +        goto out_wake;
>>>>> +    /* if we have any events and min timeout expired, we're done */
>>>>> +    if (io_cqring_events(ctx))
>>>>> +        goto out_wake;
>>>>> +
>>>>> +    /*
>>>>> +     * If using deferred task_work running and application is waiting on
>>>>> +     * more than one request, ensure we reset it now where we are switching
>>>>> +     * to normal sleeps. Any request completion post min_wait should wake
>>>>> +     * the task and return.
>>>>> +     */
>>>>> +    if (ctx->flags & IORING_SETUP_DEFER_TASKRUN)
>>>>> +        atomic_set(&ctx->cq_wait_nr, 1);
>>>>
>>>> racy
>>>>
>>>> atomic_set(&ctx->cq_wait_nr, 1);
>>>> smp_mb();
>>>> if (llist_empty(&ctx->work_llist))
>>>>       // wake;
>>>
>>> rather if _not_ empty
>>
>> Yep that one was a given :-)
>>
>> Updated it, we'll punt to out_wake at that point.
> 
> Another concern is racing with the task [re]setting ->cq_wait_nr
> in io_cqring_wait(), e.g. because of a spurious wake up.

I tried to close that up somewhat in the next iteration.

-- 
Jens Axboe


