Return-Path: <io-uring+bounces-2854-lists+io-uring=lfdr.de@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [147.75.80.249])
	by mail.lfdr.de (Postfix) with ESMTPS id 4658895903B
	for <lists+io-uring@lfdr.de>; Wed, 21 Aug 2024 00:06:25 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id C764F1F23262
	for <lists+io-uring@lfdr.de>; Tue, 20 Aug 2024 22:06:24 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 60E171C7B88;
	Tue, 20 Aug 2024 22:06:11 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=davidwei-uk.20230601.gappssmtp.com header.i=@davidwei-uk.20230601.gappssmtp.com header.b="3LZbJjDs"
X-Original-To: io-uring@vger.kernel.org
Received: from mail-pl1-f171.google.com (mail-pl1-f171.google.com [209.85.214.171])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3399F1C7B7B
	for <io-uring@vger.kernel.org>; Tue, 20 Aug 2024 22:06:09 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.214.171
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1724191571; cv=none; b=CUgGfos0zqHtEX6BycQoMFf5RfQpTuxJLPaSPMtZNgsFRrEjqU8f5opLTk3gNMsQ7RlkOUudxcO4NHTtrdLspbpdyYFFwBMxm5RskBYLJGCN038FbgrBtOHU8lnv8IkjHiuM358Wf+qbrhCiCt72Iv3RMlwFUpY0EevP4S2HeAs=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1724191571; c=relaxed/simple;
	bh=SCZJLoxcWIcjks0GGfGjITJ9lf6j5vHBFE5zpL7V+Jc=;
	h=Message-ID:Date:MIME-Version:Subject:To:References:From:
	 In-Reply-To:Content-Type; b=DRQMqzFIFwcvEHDmH6hdW0j0nYnGhJDswUek3pSLZ0FKPdUcvBoaDtepYdgQAnDXXzLuniaD1fUo28TPnURco+RJwwV5iw/GYR7XNB3xSOBk7yuiPjCU5/bTwPDA7NWrVRGxg2h5CDg8eeOkA6QuAv38xJTP7WJLhqzMbMGqMf0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=davidwei.uk; spf=none smtp.mailfrom=davidwei.uk; dkim=pass (2048-bit key) header.d=davidwei-uk.20230601.gappssmtp.com header.i=@davidwei-uk.20230601.gappssmtp.com header.b=3LZbJjDs; arc=none smtp.client-ip=209.85.214.171
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=davidwei.uk
Authentication-Results: smtp.subspace.kernel.org; spf=none smtp.mailfrom=davidwei.uk
Received: by mail-pl1-f171.google.com with SMTP id d9443c01a7336-20203988f37so43233855ad.1
        for <io-uring@vger.kernel.org>; Tue, 20 Aug 2024 15:06:08 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=davidwei-uk.20230601.gappssmtp.com; s=20230601; t=1724191568; x=1724796368; darn=vger.kernel.org;
        h=content-transfer-encoding:in-reply-to:from:references:to
         :content-language:subject:user-agent:mime-version:date:message-id
         :from:to:cc:subject:date:message-id:reply-to;
        bh=KKKFr/v/Fl4LCcJgqHOUAi4zq48Rsl/1q6v2EVuWekQ=;
        b=3LZbJjDsXckOv1HEweQDYjDyQweLEYyNA6lhl3JkcbRkLXPWjhPPq1YBfDPKpADRO1
         XXYVEFZbHIzVSYqdrhr7IAoMo9QUHrdrsQfcFw1ZFxMju1DAHWLJ2LUtEGecjVJyTRjW
         K1gQFUu9xIE6/n/EoFYH2tDGgOpBVPyGfiHZpsYPRFl/OnBoTcC/xaMR7CJGwueyeC5A
         0IA0fXoQypTR70BTdqcnPhihy+SovaP2L+nT1IgP40kHlUpUSET7NTqPbXAeOq/S34zP
         zWuWT9upSJfHP9QPV4Q/exYnLjJLprUQvEZ8JafawH8h9icEw2pjchrDNrFNfojDL7xp
         rFoA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1724191568; x=1724796368;
        h=content-transfer-encoding:in-reply-to:from:references:to
         :content-language:subject:user-agent:mime-version:date:message-id
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=KKKFr/v/Fl4LCcJgqHOUAi4zq48Rsl/1q6v2EVuWekQ=;
        b=ucVRu0HlAgjWT6kFPK+LLonihJVRMSIAWe5MuuA5fNH68+0eRCuX/YS4L2X2ImhAHC
         0wOBuPX7bPUesV+2RF4lAT3XPmUZQs2yL7CkShktE6bjPCAnvXP7UdP45nHZIFq/HvMJ
         C7mC1HlUzP8vSLjfAWc0s8kE/EV205iqYd3ozN8LQofQWWbzLgRSYYYhaRWj743O2Qga
         mH1aJLtglDRQnrD/J4OvMlOEHhMo/zA7klazg/KMckyJL4uRQsVynbyjRpomfH7LYs7+
         nZiEuBQZpt0NcqKQcZWBvS9cMH8aLRNtgQHVp0++qFWEv6rLFR6fBb6omTygzTtnTe4x
         sxXw==
X-Forwarded-Encrypted: i=1; AJvYcCXV/AuBF/g6PpMqUrwju5cKPtFYMuEIMiH8hsP+mRY093cwTrr4nlF8oW2r7MB6iZEtt3jUtyzMNg==@vger.kernel.org
X-Gm-Message-State: AOJu0YzFfDQ1xVRHtojB3gckSFAZrDOH/gRyCdXKvTdmwih3hwH6//IB
	0Ws/sG33jBizc5qZcHakzeGsNyo1dafxZZ9O+6s0asn3pD9NuF+JcFXLeHXTuhwV8jUf7cwfKuO
	0Pjg=
X-Google-Smtp-Source: AGHT+IGkXC9fcIlLYP+TJJHSuniZd6392h66AcAFwVtag/aHOXDWwLrKByiqusBWd4rZ75E1WZsFDw==
X-Received: by 2002:a17:903:1c7:b0:1ff:393d:5e56 with SMTP id d9443c01a7336-2036809745emr3951885ad.36.1724191568440;
        Tue, 20 Aug 2024 15:06:08 -0700 (PDT)
Received: from ?IPV6:2a03:83e0:1256:1:80c:c984:f4f1:951f? ([2620:10d:c090:500::5:2f5b])
        by smtp.gmail.com with ESMTPSA id d9443c01a7336-201f0395b9bsm82237135ad.237.2024.08.20.15.06.07
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Tue, 20 Aug 2024 15:06:08 -0700 (PDT)
Message-ID: <48359591-314d-42b0-8332-58f9f6041330@davidwei.uk>
Date: Tue, 20 Aug 2024 15:06:06 -0700
Precedence: bulk
X-Mailing-List: io-uring@vger.kernel.org
List-Id: <io-uring.vger.kernel.org>
List-Subscribe: <mailto:io-uring+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:io-uring+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH 3/5] io_uring: implement our own schedule timeout handling
Content-Language: en-GB
To: Jens Axboe <axboe@kernel.dk>, io-uring@vger.kernel.org
References: <20240819233042.230956-1-axboe@kernel.dk>
 <20240819233042.230956-4-axboe@kernel.dk>
 <58a42e82-3742-4439-998e-c9389c5849bc@davidwei.uk>
 <cb79d5dd-3ff2-4cc3-ae0e-24c03d2729b3@kernel.dk>
 <d1116971-a2f7-430d-97d8-03440befd38a@davidwei.uk>
 <a3285bfe-ddcb-4521-940c-2e59f774ec70@kernel.dk>
From: David Wei <dw@davidwei.uk>
In-Reply-To: <a3285bfe-ddcb-4521-940c-2e59f774ec70@kernel.dk>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit

On 2024-08-20 14:39, Jens Axboe wrote:
> On 8/20/24 3:37 PM, David Wei wrote:
>> On 2024-08-20 14:34, Jens Axboe wrote:
>>> On 8/20/24 2:08 PM, David Wei wrote:
>>>> On 2024-08-19 16:28, Jens Axboe wrote:
>>>>> In preparation for having two distinct timeouts and avoid waking the
>>>>> task if we don't need to.
>>>>>
>>>>> Signed-off-by: Jens Axboe <axboe@kernel.dk>
>>>>> ---
>>>>>  io_uring/io_uring.c | 41 ++++++++++++++++++++++++++++++++++++-----
>>>>>  io_uring/io_uring.h |  2 ++
>>>>>  2 files changed, 38 insertions(+), 5 deletions(-)
>>>>>
>>>>> diff --git a/io_uring/io_uring.c b/io_uring/io_uring.c
>>>>> index 9e2b8d4c05db..ddfbe04c61ed 100644
>>>>> --- a/io_uring/io_uring.c
>>>>> +++ b/io_uring/io_uring.c
>>>>> @@ -2322,7 +2322,7 @@ static int io_wake_function(struct wait_queue_entry *curr, unsigned int mode,
>>>>>  	 * Cannot safely flush overflowed CQEs from here, ensure we wake up
>>>>>  	 * the task, and the next invocation will do it.
>>>>>  	 */
>>>>> -	if (io_should_wake(iowq) || io_has_work(iowq->ctx))
>>>>> +	if (io_should_wake(iowq) || io_has_work(iowq->ctx) || iowq->hit_timeout)
>>>>
>>>> iowq->hit_timeout may be modified in a timer softirq context, while this
>>>> wait_queue_func_t (AIUI) may get called from any context e.g.
>>>> net_rx_softirq for sockets. Does this need a READ_ONLY()?
>>>
>>> Yes probably not a bad idea to make it READ_ONCE().
>>>
>>>>>  		return autoremove_wake_function(curr, mode, wake_flags, key);
>>>>>  	return -1;
>>>>>  }
>>>>> @@ -2350,6 +2350,38 @@ static bool current_pending_io(void)
>>>>>  	return percpu_counter_read_positive(&tctx->inflight);
>>>>>  }
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
> 

io_cqring_timer_wakeup() is the timer expired callback which calls
wake_up_process() or io_cqring_wake() depending on DEFER_TASKRUN.

The original code calling schedule_hrtimeout_range_clock() uses
hrtimer_sleeper instead, which has a default timer expired callback set
to hrtimer_wakeup().

hrtimer_wakeup() only calls wake_up_process().

My question is: why this asymmetry? Why does the new custom callback
require io_cqring_wake()?

