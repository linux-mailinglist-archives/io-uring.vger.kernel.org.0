Return-Path: <io-uring+bounces-2853-lists+io-uring=lfdr.de@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [IPv6:2604:1380:4601:e00::3])
	by mail.lfdr.de (Postfix) with ESMTPS id 1730D959035
	for <lists+io-uring@lfdr.de>; Wed, 21 Aug 2024 00:04:01 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id 8B8BF1F2398B
	for <lists+io-uring@lfdr.de>; Tue, 20 Aug 2024 22:04:00 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id C32FE1C68A9;
	Tue, 20 Aug 2024 22:03:56 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="Dms7XCsj"
X-Original-To: io-uring@vger.kernel.org
Received: from mail-ej1-f54.google.com (mail-ej1-f54.google.com [209.85.218.54])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 09BBB1E86E
	for <io-uring@vger.kernel.org>; Tue, 20 Aug 2024 22:03:54 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.218.54
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1724191436; cv=none; b=NPKfdUg0KOaKdSNf+uUCVaQxrxqRu70+rgN77Z9IyWEFaEBPEVLm8nbxjMTSJi59B3CwsXyrJv/CNpBcM9T0g0TB6/PeiEqhLh6yVwXiqjwDyS4a+wSlPt1POIe7cG1Y90uUr3D9QYS6fQWDv4GWmEL3gzBxPF7KLBQEVAJDvHI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1724191436; c=relaxed/simple;
	bh=UiSqw7uRK55vMSByzJ84QZ3w6Sft7uFR7z3jusUTDl0=;
	h=Message-ID:Date:MIME-Version:Subject:To:References:From:
	 In-Reply-To:Content-Type; b=fM65UTODAcbFHJl5IGrEasL0DUuOBojQVM95H6MbdpAPSQHSZqjBuc+L5tyt7hd9jIGaIZke2TnvrUfK29WFdNyYCU/i5imu39dCaoGivSYUQhda6Mq9WY9WF7iGGD8y4jFTHxWloQIBmo2xsNrqWJk1/owOMq/Qmk6sbGYmvFA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=Dms7XCsj; arc=none smtp.client-ip=209.85.218.54
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Received: by mail-ej1-f54.google.com with SMTP id a640c23a62f3a-a8643a6bd55so192024566b.3
        for <io-uring@vger.kernel.org>; Tue, 20 Aug 2024 15:03:54 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1724191433; x=1724796233; darn=vger.kernel.org;
        h=content-transfer-encoding:in-reply-to:from:content-language
         :references:to:subject:user-agent:mime-version:date:message-id:from
         :to:cc:subject:date:message-id:reply-to;
        bh=svO50hKL4FSxD/1ghrSJOd+T5w9MDIla3cSyQCPj6d8=;
        b=Dms7XCsjxCzOQZNk0EcFP3wYSZYEia6wgYBUYA1T+EdBapLMLISqOjHHAX0ILMCTP7
         sSY+TUjZeAY6+HMa+FQEUE8KVybstXrLj3cVvshjil3dWfr6vw61CuH5kSefqJi53zvP
         u8MXbzSjZN3MDFeT5sVKhu88nT/5gD52oYEAhvbDnwPqu4pBlLiGz9AP5XaA3rLOb5DZ
         k9OferGA7JDvHee9g7tv1yoO0Y9FkFrTH66IZBuv07vXmT1eNcZWqe2jXG8jL+U/azbB
         wYfoZYPHIPDu0W3SjHU+2iMTClv5VpfLFBBZMcNIYhhkOmJqCMdW1ZS8eIf0jpyxWgRj
         OhJg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1724191433; x=1724796233;
        h=content-transfer-encoding:in-reply-to:from:content-language
         :references:to:subject:user-agent:mime-version:date:message-id
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=svO50hKL4FSxD/1ghrSJOd+T5w9MDIla3cSyQCPj6d8=;
        b=jcqFswGFBqzu2pZlubsJJM/ouGR/UUQBn5nmJbeEhleeejwI5n8BCi1AO470SvSd3F
         gbXp254rl/ymMAoXlaFO3QuLJ7brop2eOMx/j/JD8DAFo8b3rm0fjJ3Iw4Uh53VwS2Xg
         OCOI4N5N+SXv0MMRDkK0fS9En1ho84oFYqXpI2hiu4OFABDT1V98Ngivg3F42IQRneNi
         Ua8tdM7RGJNhrPwaLCNL4yF9N0wC1kN28+Xj6H8u09q9Dl58ZMnfSJgmYexuRevVKN6c
         PnfazphVVM+2npjc0AU1thH6NWY/iZjI7c2sTpIpe0cagQ/cDiKzsScntGaMJJX6uqiA
         0tBA==
X-Forwarded-Encrypted: i=1; AJvYcCWxaqw8rH7FZZ4y/tPU1zSW7fGZJA5nMHtv0L+V7qw2Ez6n0ch/FqsczaV3ZljLaTPuMvqsbCL6lQ==@vger.kernel.org
X-Gm-Message-State: AOJu0Yx7WFuJpoaKD9go5vDFW8tohnog/SQdAaw+7upqkfdZs0+EICB0
	TJeh+GyCPHw+LWtvJhFu9HERe7aPXOWW6Rvm2D5yvgsy69jMFZjoHJCnCQ==
X-Google-Smtp-Source: AGHT+IFAhd6k1Qd9+NtqfkTbj8sNCu0pkNZha6boHaXk9ZJduy9NbbOu1EYFmIlYUg0w8ak6nUlHFA==
X-Received: by 2002:a17:907:9490:b0:a7a:a892:8e05 with SMTP id a640c23a62f3a-a866f359158mr25924466b.33.1724191432723;
        Tue, 20 Aug 2024 15:03:52 -0700 (PDT)
Received: from [192.168.42.254] ([148.252.128.6])
        by smtp.gmail.com with ESMTPSA id a640c23a62f3a-a8383946441sm819101466b.148.2024.08.20.15.03.52
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Tue, 20 Aug 2024 15:03:52 -0700 (PDT)
Message-ID: <e6142b87-cc24-4ce3-9cb5-c62eced9fe22@gmail.com>
Date: Tue, 20 Aug 2024 23:04:21 +0100
Precedence: bulk
X-Mailing-List: io-uring@vger.kernel.org
List-Id: <io-uring.vger.kernel.org>
List-Subscribe: <mailto:io-uring+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:io-uring+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH 3/5] io_uring: implement our own schedule timeout handling
To: Jens Axboe <axboe@kernel.dk>, David Wei <dw@davidwei.uk>,
 io-uring@vger.kernel.org
References: <20240819233042.230956-1-axboe@kernel.dk>
 <20240819233042.230956-4-axboe@kernel.dk>
 <58a42e82-3742-4439-998e-c9389c5849bc@davidwei.uk>
 <cb79d5dd-3ff2-4cc3-ae0e-24c03d2729b3@kernel.dk>
 <d1116971-a2f7-430d-97d8-03440befd38a@davidwei.uk>
 <a3285bfe-ddcb-4521-940c-2e59f774ec70@kernel.dk>
Content-Language: en-US
From: Pavel Begunkov <asml.silence@gmail.com>
In-Reply-To: <a3285bfe-ddcb-4521-940c-2e59f774ec70@kernel.dk>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit

On 8/20/24 22:39, Jens Axboe wrote:
> On 8/20/24 3:37 PM, David Wei wrote:
>> On 2024-08-20 14:34, Jens Axboe wrote:
>>> On 8/20/24 2:08 PM, David Wei wrote:
>>>> On 2024-08-19 16:28, Jens Axboe wrote:
>>>>> In preparation for having two distinct timeouts and avoid waking the
>>>>> task if we don't need to.
>>>>>
>>>>> Signed-off-by: Jens Axboe <axboe@kernel.dk>
>>>>> ---
>>>>>   io_uring/io_uring.c | 41 ++++++++++++++++++++++++++++++++++++-----
>>>>>   io_uring/io_uring.h |  2 ++
>>>>>   2 files changed, 38 insertions(+), 5 deletions(-)
>>>>>
>>>>> diff --git a/io_uring/io_uring.c b/io_uring/io_uring.c
>>>>> index 9e2b8d4c05db..ddfbe04c61ed 100644
>>>>> --- a/io_uring/io_uring.c
>>>>> +++ b/io_uring/io_uring.c
>>>>> @@ -2322,7 +2322,7 @@ static int io_wake_function(struct wait_queue_entry *curr, unsigned int mode,
>>>>>   	 * Cannot safely flush overflowed CQEs from here, ensure we wake up
>>>>>   	 * the task, and the next invocation will do it.
>>>>>   	 */
>>>>> -	if (io_should_wake(iowq) || io_has_work(iowq->ctx))
>>>>> +	if (io_should_wake(iowq) || io_has_work(iowq->ctx) || iowq->hit_timeout)
>>>>
>>>> iowq->hit_timeout may be modified in a timer softirq context, while this
>>>> wait_queue_func_t (AIUI) may get called from any context e.g.
>>>> net_rx_softirq for sockets. Does this need a READ_ONLY()?
>>>
>>> Yes probably not a bad idea to make it READ_ONCE().
>>>
>>>>>   		return autoremove_wake_function(curr, mode, wake_flags, key);
>>>>>   	return -1;
>>>>>   }
>>>>> @@ -2350,6 +2350,38 @@ static bool current_pending_io(void)
>>>>>   	return percpu_counter_read_positive(&tctx->inflight);
>>>>>   }
>>>>>   
>>>>> +static enum hrtimer_restart io_cqring_timer_wakeup(struct hrtimer *timer)
>>>>> +{
>>>>> +	struct io_wait_queue *iowq = container_of(timer, struct io_wait_queue, t);
>>>>> +	struct io_ring_ctx *ctx = iowq->ctx;
>>>>> +
>>>>> +	WRITE_ONCE(iowq->hit_timeout, 1);
>>>>> +	if (ctx->flags & IORING_SETUP_DEFER_TASKRUN)
>>>>> +		wake_up_process(ctx->submitter_task);
>>>>> +	else
>>>>> +		io_cqring_wake(ctx);
>>>>
>>>> This is a bit different to schedule_hrtimeout_range_clock(). Why is
>>>> io_cqring_wake() needed here for non-DEFER_TASKRUN?
>>>
>>> That's how the wakeups work - for defer taskrun, the task isn't on a
>>> waitqueue at all. Hence we need to wake the task itself. For any other
>>> setup, they will be on the waitqueue, and we just call io_cqring_wake()
>>> to wake up anyone waiting on the waitqueue. That will iterate the wake
>>> queue and call handlers for each item. Having a separate handler for
>>> that will allow to NOT wake up the task if we don't need to.
>>> taskrun, the waker
>>
>> To rephase the question, why is the original code calling
>> schedule_hrtimeout_range_clock() not needing to differentiate behaviour
>> between defer taskrun and not?
> 
> Because that part is the same, the task schedules out and goes to sleep.
> That has always been the same regardless of how the ring is setup. Only
> difference is that DEFER_TASKRUN doesn't add itself to ctx->wait, and
> hence cannot be woken by a wake_up(ctx->wait). We have to wake the task
> manually.

Answering the question, for !IORING_SETUP_DEFER_TASKRUN, before it
was waking only the task that started the timeout. Now,
io_cqring_wake(ctx) wakes all waiters, so if there are multiple tasks
waiting, a timeout of one waiter will try to wake all of them.

I believe it's unintentional, but I don't think we care either. You
can save the waiter task struct and wake it specifically.


-- 
Pavel Begunkov

