Return-Path: <io-uring+bounces-2864-lists+io-uring=lfdr.de@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [139.178.88.99])
	by mail.lfdr.de (Postfix) with ESMTPS id 694FE959199
	for <lists+io-uring@lfdr.de>; Wed, 21 Aug 2024 02:08:01 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 1E3C5285833
	for <lists+io-uring@lfdr.de>; Wed, 21 Aug 2024 00:08:00 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id A3C26182;
	Wed, 21 Aug 2024 00:07:56 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="YR9Fz81r"
X-Original-To: io-uring@vger.kernel.org
Received: from mail-ej1-f48.google.com (mail-ej1-f48.google.com [209.85.218.48])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C212E191
	for <io-uring@vger.kernel.org>; Wed, 21 Aug 2024 00:07:54 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.218.48
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1724198876; cv=none; b=jd03VXYYF4ZdU5JXkgjEUV0xqwtEbsKm9+Orru8t8zsFWhLyYilAkz3w4ZqKmKJG8VV9cZ/OMqOL8i/POPNMT2QOJrcwzaoegTlRt2lVvbgpyaBeSuP5J+TAWJM4T7CcxGV/EOYK5afGqGudrky1qpUi0k0TUwXcczjBRnkPnqI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1724198876; c=relaxed/simple;
	bh=/L4JRDKa3gIxrpG8qee8932/FtDXkmRjigrn7cvLD+4=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=e67sfcdSEFzk1tRN1su3/ZsxAavYeMwbUPERfTJG1r1AkuO5dWbkiuaXlkOpaiQFIqibalOjWPz5L906KSsJnlFs27XtFD3MM25mnEuWhmSaPDKJ8mTchD1yZ6MkMj/k64LzD3WfB6ogxC75KtSOgcKedxPzW3OSXjOF1ofXKJs=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=YR9Fz81r; arc=none smtp.client-ip=209.85.218.48
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Received: by mail-ej1-f48.google.com with SMTP id a640c23a62f3a-a7a9cf7d3f3so782702866b.1
        for <io-uring@vger.kernel.org>; Tue, 20 Aug 2024 17:07:54 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1724198873; x=1724803673; darn=vger.kernel.org;
        h=content-transfer-encoding:in-reply-to:from:content-language
         :references:cc:to:subject:user-agent:mime-version:date:message-id
         :from:to:cc:subject:date:message-id:reply-to;
        bh=lNO+iRVUPN+y4mcRNEsuW3Kl2fgHZe7BX4mszCC+RvI=;
        b=YR9Fz81rSGYktZRZUsx8rOYivxtHzo5RFImPty7SaTMxamTTmTS542aHPpmWO53BLb
         zAebLxVot3oG7IXLpKBWJT5MxU5N++e25G4IMcPFX5u7jYvjKmmqSeIC2boWAgbbnUpz
         nLFECAlG896uxUORmCD/AfQrbHDBjhacyDMbNCwO3GJ0D6NACZbE7RWMVh8o5HmzIctJ
         /cRgdN2njHFlalGq4/M3VBvpghlG8S67f9969O8cAfYbhhA/MgIuNul4Oj9N6m8Cm0l+
         NpTK5vH9QVaxlSdX8xfcRtd8IpeZaUa7Kgy74CeB/J+a/drgQj/OluV/DuHy394SOIkg
         efpQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1724198873; x=1724803673;
        h=content-transfer-encoding:in-reply-to:from:content-language
         :references:cc:to:subject:user-agent:mime-version:date:message-id
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=lNO+iRVUPN+y4mcRNEsuW3Kl2fgHZe7BX4mszCC+RvI=;
        b=uQbl4tpOd/cwGWc1+J+7WpKuJrBiY6kz5ZK6Zig7Ab+1wB9Vm/TrbtUw971eN43adt
         j8KbrcuedGhmHwap2v49wQ0mgogQ0qGFZDf1vLerWZkbx4yn06wOWwo5vfF5MvMEMyGm
         UAArkPQMhtojzqEUJZpk9967HI1aJccvjgcqGM0lC5rZeIk6UOyv1hNeBUJkYpvjsGOo
         uE07WTUOvfHA2pnIxBqoueUU3XiG2L05GH2rZT4erBF58Xj43c5V46dWXMkwunAneW/e
         xRllxt0IGSgFGHpgoTQJ43AxWJYV5SPeE0KpAE09NJED+5IkPQUFTGVkvW4pSD9WQAXn
         x3VA==
X-Forwarded-Encrypted: i=1; AJvYcCVO3pI4Pypn84SFmZe7gEQECk0ngwgM1HLFhewi1nHUathVhAdb8KZuo3MLGWbWmmrgyiGSTKQh1A==@vger.kernel.org
X-Gm-Message-State: AOJu0YzDSqjzVP/mpIjMUdT/PupcVlQOn0kw6c1g/FQg7EsqdW5zXri7
	9hiECt59Fz5mXXj4Ae3FoJjCfRB+9v9Xt034t/expeHTPSrkwsXpgELI0A==
X-Google-Smtp-Source: AGHT+IE6VydNzMZE2wlf23WIS67DpSda+KL/A9ThPcsRBr7gy93FNULRMcVusZBdYw4zpwPpCHwC6Q==
X-Received: by 2002:a17:907:f782:b0:a75:2781:a5c4 with SMTP id a640c23a62f3a-a866f3666ccmr39987766b.29.1724198872536;
        Tue, 20 Aug 2024 17:07:52 -0700 (PDT)
Received: from [192.168.42.254] ([148.252.128.6])
        by smtp.gmail.com with ESMTPSA id a640c23a62f3a-a8383935616sm817426366b.123.2024.08.20.17.07.51
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Tue, 20 Aug 2024 17:07:52 -0700 (PDT)
Message-ID: <6f2389c9-7bd7-42b5-bc9e-1db6ddb90d3b@gmail.com>
Date: Wed, 21 Aug 2024 01:08:20 +0100
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
References: <20240819233042.230956-1-axboe@kernel.dk>
 <20240819233042.230956-5-axboe@kernel.dk>
 <abbab9cf-1249-4463-88cc-85a51399a950@gmail.com>
 <aa17480b-ce0a-4569-9f28-f44bdf057aa9@gmail.com>
 <b9fbfad3-717e-45e9-b66e-e90799c5a2f3@kernel.dk>
Content-Language: en-US
From: Pavel Begunkov <asml.silence@gmail.com>
In-Reply-To: <b9fbfad3-717e-45e9-b66e-e90799c5a2f3@kernel.dk>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit

On 8/20/24 23:58, Jens Axboe wrote:
> On 8/20/24 4:47 PM, Pavel Begunkov wrote:
>> On 8/20/24 23:46, Pavel Begunkov wrote:
>>> On 8/20/24 00:28, Jens Axboe wrote:
>>>> Waiting for events with io_uring has two knobs that can be set:
>>>>
>>>> 1) The number of events to wake for
>>>> 2) The timeout associated with the event
>>>>
>>>> Waiting will abort when either of those conditions are met, as expected.
>>>>
>>>> This adds support for a third event, which is associated with the number
>>>> of events to wait for. Applications generally like to handle batches of
>>>> completions, and right now they'd set a number of events to wait for and
>>>> the timeout for that. If no events have been received but the timeout
>>>> triggers, control is returned to the application and it can wait again.
>>>> However, if the application doesn't have anything to do until events are
>>>> reaped, then it's possible to make this waiting more efficient.
>>>>
>>>> For example, the application may have a latency time of 50 usecs and
>>>> wanting to handle a batch of 8 requests at the time. If it uses 50 usecs
>>>> as the timeout, then it'll be doing 20K context switches per second even
>>>> if nothing is happening.
>>>>
>>>> This introduces the notion of min batch wait time. If the min batch wait
>>>> time expires, then we'll return to userspace if we have any events at all.
>>>> If none are available, the general wait time is applied. Any request
>>>> arriving after the min batch wait time will cause waiting to stop and
>>>> return control to the application.
>>>>
>>>> Signed-off-by: Jens Axboe <axboe@kernel.dk>
>>>> ---
>>>>    io_uring/io_uring.c | 75 +++++++++++++++++++++++++++++++++++++++------
>>>>    io_uring/io_uring.h |  2 ++
>>>>    2 files changed, 67 insertions(+), 10 deletions(-)
>>>>
>>>> diff --git a/io_uring/io_uring.c b/io_uring/io_uring.c
>>>> index ddfbe04c61ed..d09a7c2e1096 100644
>>>> --- a/io_uring/io_uring.c
>>>> +++ b/io_uring/io_uring.c
>>>> @@ -2363,13 +2363,62 @@ static enum hrtimer_restart io_cqring_timer_wakeup(struct hrtimer *timer)
>>>>        return HRTIMER_NORESTART;
>>>>    }
>>>> +/*
>>>> + * Doing min_timeout portion. If we saw any timeouts, events, or have work,
>>>> + * wake up. If not, and we have a normal timeout, switch to that and keep
>>>> + * sleeping.
>>>> + */
>>>> +static enum hrtimer_restart io_cqring_min_timer_wakeup(struct hrtimer *timer)
>>>> +{
>>>> +    struct io_wait_queue *iowq = container_of(timer, struct io_wait_queue, t);
>>>> +    struct io_ring_ctx *ctx = iowq->ctx;
>>>> +
>>>> +    /* no general timeout, or shorter, we are done */
>>>> +    if (iowq->timeout == KTIME_MAX ||
>>>> +        ktime_after(iowq->min_timeout, iowq->timeout))
>>>> +        goto out_wake;
>>>> +    /* work we may need to run, wake function will see if we need to wake */
>>>> +    if (io_has_work(ctx))
>>>> +        goto out_wake;
>>>> +    /* got events since we started waiting, min timeout is done */
>>>> +    if (iowq->cq_min_tail != READ_ONCE(ctx->rings->cq.tail))
>>>> +        goto out_wake;
>>>> +    /* if we have any events and min timeout expired, we're done */
>>>> +    if (io_cqring_events(ctx))
>>>> +        goto out_wake;
>>>> +
>>>> +    /*
>>>> +     * If using deferred task_work running and application is waiting on
>>>> +     * more than one request, ensure we reset it now where we are switching
>>>> +     * to normal sleeps. Any request completion post min_wait should wake
>>>> +     * the task and return.
>>>> +     */
>>>> +    if (ctx->flags & IORING_SETUP_DEFER_TASKRUN)
>>>> +        atomic_set(&ctx->cq_wait_nr, 1);
>>>
>>> racy
>>>
>>> atomic_set(&ctx->cq_wait_nr, 1);
>>> smp_mb();
>>> if (llist_empty(&ctx->work_llist))
>>>       // wake;
>>
>> rather if _not_ empty
> 
> Yep that one was a given :-)
> 
> Updated it, we'll punt to out_wake at that point.

Another concern is racing with the task [re]setting ->cq_wait_nr
in io_cqring_wait(), e.g. because of a spurious wake up.

-- 
Pavel Begunkov

