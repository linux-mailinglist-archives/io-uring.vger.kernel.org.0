Return-Path: <io-uring+bounces-2856-lists+io-uring=lfdr.de@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [147.75.80.249])
	by mail.lfdr.de (Postfix) with ESMTPS id B213F959052
	for <lists+io-uring@lfdr.de>; Wed, 21 Aug 2024 00:13:49 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id 3FA2E1F243F8
	for <lists+io-uring@lfdr.de>; Tue, 20 Aug 2024 22:13:49 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id EA4531C8FB1;
	Tue, 20 Aug 2024 22:13:02 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="Nz2L/WrM"
X-Original-To: io-uring@vger.kernel.org
Received: from mail-ej1-f52.google.com (mail-ej1-f52.google.com [209.85.218.52])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0055F1C825B
	for <io-uring@vger.kernel.org>; Tue, 20 Aug 2024 22:13:00 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.218.52
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1724191982; cv=none; b=p04fNYJtlLiNNbWC8BfDilTK385U7glv6fPxKlu/f3tALX9+eQToFynW3hwfUkLtVafE9mREdsrRSQljf2AgHqYYkQLDS0nxSl7nX3Dl2PKKuFYjFDd31Llr11TR3BrnBBUrR71KuemrYfXdDHgwW16qZSFNo3cGvj0KDhKwjNQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1724191982; c=relaxed/simple;
	bh=OiwfCbonoUT8/mZjp1QXt/fXy4XWKioCNKP73E/r+WQ=;
	h=Message-ID:Date:MIME-Version:Subject:To:References:From:
	 In-Reply-To:Content-Type; b=DyYow6iGQZUiVaVv1dG1IcOsLj8GZHeth/bLJMn7EQQap9nkfT24mYJQ5y4/t38Ui9p4vWp1GFgjtREUo7j7ySytPTVPMEBm3rAcld+AgGO11jC4Wsl3f1hXL9eLzD9Xo+PlHEdFKn0YPDG9kulvfsxixV/hGJQiplVBlReik8s=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=Nz2L/WrM; arc=none smtp.client-ip=209.85.218.52
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Received: by mail-ej1-f52.google.com with SMTP id a640c23a62f3a-a7a94478a4eso29186466b.1
        for <io-uring@vger.kernel.org>; Tue, 20 Aug 2024 15:13:00 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1724191979; x=1724796779; darn=vger.kernel.org;
        h=content-transfer-encoding:in-reply-to:from:content-language
         :references:to:subject:user-agent:mime-version:date:message-id:from
         :to:cc:subject:date:message-id:reply-to;
        bh=tmSwYwRNvsFkrFx2yYc4dFNa9Vg33We2rqRELPvpHU8=;
        b=Nz2L/WrMi6NOXk/EMesB+qeEenEiy3ehqm0fZzMZGVINZMWFFfuZJZtM7csKSTb5VX
         hHtCEQEa701eod0JTTkOoym3L7XvQTbe6qfo5M5aOCjcrdXnPlbpD4RcZHqO1N5obb3i
         ZBRxPioAQNtQmdzZHQNpsj+fVrvgl4b+OIY4j0fj1t7Bj564MIP9rYe7utuTWctPDDYH
         yxz8FAUitMfM6+IIJ+/V756wWytZ+83iv27xH5/8QnX0DyIG3dR5HutK5th5kXs0cE4a
         ncOOSgwDYGjIa0wpbFrzxH+XQMGp2LTfh+7KpB6jA/pGUyPDMpohbKcvpkCxBDSEb/qI
         vyrQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1724191979; x=1724796779;
        h=content-transfer-encoding:in-reply-to:from:content-language
         :references:to:subject:user-agent:mime-version:date:message-id
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=tmSwYwRNvsFkrFx2yYc4dFNa9Vg33We2rqRELPvpHU8=;
        b=ouEaheMDu/r1m2S/RRbRE2uF8cGgqKOFWKnxAPw9A9XD0+PAq1wz5P2QN9cd6I6FuP
         J/gDvuHJ8RJD4SeAp5zmPE190xeuTWkj12n/4oafl7uR2Jg+sELcPI2rBY6MpQkISXaT
         UlGjAdsKtpDqhPOAf6ZUuDVqUm0D7Ys5rJAFGsX8Iime8HQwOkM8+uJfhViK05x95+yc
         J3cBRJGFRlwdFJTKEZPr1mEolffGKQJ+xJ+92IdpjQ26p9Xtc7Gawk876dHjplE9qbZJ
         cKzKvap3dybCi79zm2ec8UPI7xlkOQKssu+VvebVp2A29QPBepMDEE7MUb9RHoRNi6+a
         FzQQ==
X-Forwarded-Encrypted: i=1; AJvYcCXZgSTYZsVns6Rx09naklEWly6wHi1aiIdy2mhpMMhEAE+bh4iD7AtHi782tJJGb7RhmguQBEVrOg==@vger.kernel.org
X-Gm-Message-State: AOJu0YwKhy/6OXZ2aqXF+7QgBo4xdnEejjRnXz7kr6yHlWKrU1a48nVg
	47VKBLynYFqzXI6Wh5/bOb3IPBPSGVOU4z65N1LV3fBB4PEpNF5h
X-Google-Smtp-Source: AGHT+IGeFmMtvQ855rk73ACS1SQ7mIwtF1m/l4o4XqxbD5ZEohCu3VMZrRw37QNo3gchl79yeOlu6Q==
X-Received: by 2002:a17:906:c10e:b0:a7a:a763:842e with SMTP id a640c23a62f3a-a866ffcc1fcmr24197666b.13.1724191978752;
        Tue, 20 Aug 2024 15:12:58 -0700 (PDT)
Received: from [192.168.42.254] ([148.252.128.6])
        by smtp.gmail.com with ESMTPSA id a640c23a62f3a-a83838c6760sm809834966b.23.2024.08.20.15.12.58
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Tue, 20 Aug 2024 15:12:58 -0700 (PDT)
Message-ID: <4b0ed07b-1cb0-4564-9d13-44a7e6680190@gmail.com>
Date: Tue, 20 Aug 2024 23:13:27 +0100
Precedence: bulk
X-Mailing-List: io-uring@vger.kernel.org
List-Id: <io-uring.vger.kernel.org>
List-Subscribe: <mailto:io-uring+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:io-uring+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH 3/5] io_uring: implement our own schedule timeout handling
To: David Wei <dw@davidwei.uk>, Jens Axboe <axboe@kernel.dk>,
 io-uring@vger.kernel.org
References: <20240819233042.230956-1-axboe@kernel.dk>
 <20240819233042.230956-4-axboe@kernel.dk>
 <58a42e82-3742-4439-998e-c9389c5849bc@davidwei.uk>
 <cb79d5dd-3ff2-4cc3-ae0e-24c03d2729b3@kernel.dk>
 <d1116971-a2f7-430d-97d8-03440befd38a@davidwei.uk>
 <a3285bfe-ddcb-4521-940c-2e59f774ec70@kernel.dk>
 <48359591-314d-42b0-8332-58f9f6041330@davidwei.uk>
Content-Language: en-US
From: Pavel Begunkov <asml.silence@gmail.com>
In-Reply-To: <48359591-314d-42b0-8332-58f9f6041330@davidwei.uk>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit

On 8/20/24 23:06, David Wei wrote:
> On 2024-08-20 14:39, Jens Axboe wrote:
>> On 8/20/24 3:37 PM, David Wei wrote:
>>> On 2024-08-20 14:34, Jens Axboe wrote:
>>>> On 8/20/24 2:08 PM, David Wei wrote:
>>>>> On 2024-08-19 16:28, Jens Axboe wrote:
>>>>>> In preparation for having two distinct timeouts and avoid waking the
>>>>>> task if we don't need to.
>>>>>>
>>>>>> Signed-off-by: Jens Axboe <axboe@kernel.dk>
>>>>>> ---
>>>>>>   io_uring/io_uring.c | 41 ++++++++++++++++++++++++++++++++++++-----
>>>>>>   io_uring/io_uring.h |  2 ++
>>>>>>   2 files changed, 38 insertions(+), 5 deletions(-)
>>>>>>
>>>>>> diff --git a/io_uring/io_uring.c b/io_uring/io_uring.c
>>>>>> index 9e2b8d4c05db..ddfbe04c61ed 100644
>>>>>> --- a/io_uring/io_uring.c
>>>>>> +++ b/io_uring/io_uring.c
>>>>>> @@ -2322,7 +2322,7 @@ static int io_wake_function(struct wait_queue_entry *curr, unsigned int mode,
>>>>>>   	 * Cannot safely flush overflowed CQEs from here, ensure we wake up
>>>>>>   	 * the task, and the next invocation will do it.
>>>>>>   	 */
>>>>>> -	if (io_should_wake(iowq) || io_has_work(iowq->ctx))
>>>>>> +	if (io_should_wake(iowq) || io_has_work(iowq->ctx) || iowq->hit_timeout)
>>>>>
>>>>> iowq->hit_timeout may be modified in a timer softirq context, while this
>>>>> wait_queue_func_t (AIUI) may get called from any context e.g.
>>>>> net_rx_softirq for sockets. Does this need a READ_ONLY()?
>>>>
>>>> Yes probably not a bad idea to make it READ_ONCE().
>>>>
>>>>>>   		return autoremove_wake_function(curr, mode, wake_flags, key);
>>>>>>   	return -1;
>>>>>>   }
>>>>>> @@ -2350,6 +2350,38 @@ static bool current_pending_io(void)
>>>>>>   	return percpu_counter_read_positive(&tctx->inflight);
>>>>>>   }
>>>>>>   
>>>>>> +static enum hrtimer_restart io_cqring_timer_wakeup(struct hrtimer *timer)
>>>>>> +{
>>>>>> +	struct io_wait_queue *iowq = container_of(timer, struct io_wait_queue, t);
>>>>>> +	struct io_ring_ctx *ctx = iowq->ctx;
>>>>>> +
>>>>>> +	WRITE_ONCE(iowq->hit_timeout, 1);
>>>>>> +	if (ctx->flags & IORING_SETUP_DEFER_TASKRUN)
>>>>>> +		wake_up_process(ctx->submitter_task);
>>>>>> +	else
>>>>>> +		io_cqring_wake(ctx);
>>>>>
>>>>> This is a bit different to schedule_hrtimeout_range_clock(). Why is
>>>>> io_cqring_wake() needed here for non-DEFER_TASKRUN?
>>>>
>>>> That's how the wakeups work - for defer taskrun, the task isn't on a
>>>> waitqueue at all. Hence we need to wake the task itself. For any other
>>>> setup, they will be on the waitqueue, and we just call io_cqring_wake()
>>>> to wake up anyone waiting on the waitqueue. That will iterate the wake
>>>> queue and call handlers for each item. Having a separate handler for
>>>> that will allow to NOT wake up the task if we don't need to.
>>>> taskrun, the waker
>>>
>>> To rephase the question, why is the original code calling
>>> schedule_hrtimeout_range_clock() not needing to differentiate behaviour
>>> between defer taskrun and not?
>>
>> Because that part is the same, the task schedules out and goes to sleep.
>> That has always been the same regardless of how the ring is setup. Only
>> difference is that DEFER_TASKRUN doesn't add itself to ctx->wait, and
>> hence cannot be woken by a wake_up(ctx->wait). We have to wake the task
>> manually.
>>
> 
> io_cqring_timer_wakeup() is the timer expired callback which calls
> wake_up_process() or io_cqring_wake() depending on DEFER_TASKRUN.
> 
> The original code calling schedule_hrtimeout_range_clock() uses
> hrtimer_sleeper instead, which has a default timer expired callback set
> to hrtimer_wakeup().
> 
> hrtimer_wakeup() only calls wake_up_process().
> 
> My question is: why this asymmetry? Why does the new custom callback
> require io_cqring_wake()?

That's what I'm saying, it doesn't need and doesn't really want it.
 From the correctness point of view, it's ok since we wake up a
(unnecessarily) larger set of tasks.

-- 
Pavel Begunkov

