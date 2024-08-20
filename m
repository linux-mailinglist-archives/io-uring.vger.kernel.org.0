Return-Path: <io-uring+bounces-2850-lists+io-uring=lfdr.de@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [IPv6:2604:1380:4601:e00::3])
	by mail.lfdr.de (Postfix) with ESMTPS id 3A9BF958FCF
	for <lists+io-uring@lfdr.de>; Tue, 20 Aug 2024 23:39:22 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id 754591F22855
	for <lists+io-uring@lfdr.de>; Tue, 20 Aug 2024 21:39:21 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 886FF1C4635;
	Tue, 20 Aug 2024 21:39:17 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel-dk.20230601.gappssmtp.com header.i=@kernel-dk.20230601.gappssmtp.com header.b="SQXGWnyG"
X-Original-To: io-uring@vger.kernel.org
Received: from mail-pg1-f179.google.com (mail-pg1-f179.google.com [209.85.215.179])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id AB0E545008
	for <io-uring@vger.kernel.org>; Tue, 20 Aug 2024 21:39:15 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.215.179
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1724189957; cv=none; b=jD2oEHMPDixWdccMCACiVSsWUWgfQyDBz3UXw0bCTgpjafZIKJwRy2G6KOAapb+9tSo1GMTqAtBkTgh7PVGflVHGP48wCNMoEA2S4WN6gITUg2KOG7umndd8QnvbHN3yovPT/VLjpwrSpFRIlB2f+ipcb1BSH9S7lHMZI4+4zeo=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1724189957; c=relaxed/simple;
	bh=0SgmTsjo5sjcjmmlKA3ClApBzvlwzWKIDaPDMrmInCY=;
	h=Message-ID:Date:MIME-Version:Subject:To:References:From:
	 In-Reply-To:Content-Type; b=nzT1qwtVc2XSEObJDDALxACMVo3xiZBFfSEK9f5lZn5Iohh3pq/0aNzlRquxI52I/BywCEoI4jXM7PrkdVPQcWFvQdt+n/9E4VmDj/YyA1g7PiAfMrA03zMYpCX5kMALqzh+GtYvfmPnckX+NIry41i1GeNB/hS+PJCxrHej9vw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=kernel.dk; spf=pass smtp.mailfrom=kernel.dk; dkim=pass (2048-bit key) header.d=kernel-dk.20230601.gappssmtp.com header.i=@kernel-dk.20230601.gappssmtp.com header.b=SQXGWnyG; arc=none smtp.client-ip=209.85.215.179
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=kernel.dk
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=kernel.dk
Received: by mail-pg1-f179.google.com with SMTP id 41be03b00d2f7-7cb3db0932cso2609543a12.1
        for <io-uring@vger.kernel.org>; Tue, 20 Aug 2024 14:39:15 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernel-dk.20230601.gappssmtp.com; s=20230601; t=1724189955; x=1724794755; darn=vger.kernel.org;
        h=content-transfer-encoding:in-reply-to:from:content-language
         :references:to:subject:user-agent:mime-version:date:message-id:from
         :to:cc:subject:date:message-id:reply-to;
        bh=CurCaQW+wpmzzFziFcX7T7Grd0ok8bOltG7MbFp1i84=;
        b=SQXGWnyGrBrgzLtgohV7cdnAGXpiZTxqmox5oE3M4DkDvVlQDNRmr8cLECnet2wEAH
         ZEScJMUGOdf0AvPxxhjoduK7w3HpYBKfodBtS4Wph1ZY7RhOghbSXnv3U5BCQud/FAQF
         4EuycEVxYCkvWKq2eXwAhJpxW/vAe/a+r/XnhwMM5VjQHzCrrH7AYKW7BSpQwXGhlzbq
         EHqhP1bm9inbicL7QMBv2x7PEITj/Hur1ZBCFqurcm6UOef8BWcwokI8xVN6vYN7W8uk
         dlSqaJmXsxVx4SGoVDw/hxO7irx/xBjdWOTuJsRP89lLVdSC9n1aa7YuPQ4cm/3mCY37
         2AGw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1724189955; x=1724794755;
        h=content-transfer-encoding:in-reply-to:from:content-language
         :references:to:subject:user-agent:mime-version:date:message-id
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=CurCaQW+wpmzzFziFcX7T7Grd0ok8bOltG7MbFp1i84=;
        b=C5QRubCtKrvAh5kVRRNBg6GAzXD/XcGafx0x1gJcb9BWEMIUuY3OcOKeVEiZEkNFxC
         SZar67ZnRTzMoUkAO0qlyQh5iOZI05M+CfLxQPyzh5LKaIXGz+kSsCLcwUjUGA3sFaTL
         iz0TzcOF2+dHSWDJIzoZuUeAa5O7VaGcjL9JinQEQCoIp1IVtcHbJwf05Y4owm0cR7F0
         0czU5+0FPi6SYJ2FBM+CU+SrXz4dzY2PKbzSJ9wiRPq43K/JPMDEw5/Bf+2HKtytdp1t
         FrRtUNgQczc7AMMDXW4FRsFAB7C+q5z1JPF5qXdPgRV7XFlXWzpj7UWem4/b8R+B4sSh
         cWiA==
X-Forwarded-Encrypted: i=1; AJvYcCV1qxdrad4BVGm1vJGGVHEOeLMQiNsBn8ubzKZ3LOWH0WBFoc9oCDoy8Rh6MTTzEapHqdztErAX3A==@vger.kernel.org
X-Gm-Message-State: AOJu0YyLmM9jydPV2VLiH1nlX5TJZRE0+6PjnwZov0mMeJ4qzVK7vO+2
	zwK6SHt2pK3/hapQOhOWjWkOQxk6GUFXbKhrI+tlxeXbYFzYvNXMN0Tq05QKN6oRaZHoSMlEYpJ
	P
X-Google-Smtp-Source: AGHT+IFfGgc2KWjXIXPIA6kMAfPB9mmgBG+AK661aSqhYgxMSTRbuJHmpq2fkn+3dgGB9cQsPZZBpg==
X-Received: by 2002:a05:6a20:c520:b0:1c6:fc39:8968 with SMTP id adf61e73a8af0-1cada1794a6mr319008637.46.1724189954948;
        Tue, 20 Aug 2024 14:39:14 -0700 (PDT)
Received: from [192.168.1.150] ([198.8.77.157])
        by smtp.gmail.com with ESMTPSA id d2e1a72fcca58-7127add7cbcsm8958557b3a.14.2024.08.20.14.39.13
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Tue, 20 Aug 2024 14:39:14 -0700 (PDT)
Message-ID: <a3285bfe-ddcb-4521-940c-2e59f774ec70@kernel.dk>
Date: Tue, 20 Aug 2024 15:39:13 -0600
Precedence: bulk
X-Mailing-List: io-uring@vger.kernel.org
List-Id: <io-uring.vger.kernel.org>
List-Subscribe: <mailto:io-uring+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:io-uring+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH 3/5] io_uring: implement our own schedule timeout handling
To: David Wei <dw@davidwei.uk>, io-uring@vger.kernel.org
References: <20240819233042.230956-1-axboe@kernel.dk>
 <20240819233042.230956-4-axboe@kernel.dk>
 <58a42e82-3742-4439-998e-c9389c5849bc@davidwei.uk>
 <cb79d5dd-3ff2-4cc3-ae0e-24c03d2729b3@kernel.dk>
 <d1116971-a2f7-430d-97d8-03440befd38a@davidwei.uk>
Content-Language: en-US
From: Jens Axboe <axboe@kernel.dk>
In-Reply-To: <d1116971-a2f7-430d-97d8-03440befd38a@davidwei.uk>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit

On 8/20/24 3:37 PM, David Wei wrote:
> On 2024-08-20 14:34, Jens Axboe wrote:
>> On 8/20/24 2:08 PM, David Wei wrote:
>>> On 2024-08-19 16:28, Jens Axboe wrote:
>>>> In preparation for having two distinct timeouts and avoid waking the
>>>> task if we don't need to.
>>>>
>>>> Signed-off-by: Jens Axboe <axboe@kernel.dk>
>>>> ---
>>>>  io_uring/io_uring.c | 41 ++++++++++++++++++++++++++++++++++++-----
>>>>  io_uring/io_uring.h |  2 ++
>>>>  2 files changed, 38 insertions(+), 5 deletions(-)
>>>>
>>>> diff --git a/io_uring/io_uring.c b/io_uring/io_uring.c
>>>> index 9e2b8d4c05db..ddfbe04c61ed 100644
>>>> --- a/io_uring/io_uring.c
>>>> +++ b/io_uring/io_uring.c
>>>> @@ -2322,7 +2322,7 @@ static int io_wake_function(struct wait_queue_entry *curr, unsigned int mode,
>>>>  	 * Cannot safely flush overflowed CQEs from here, ensure we wake up
>>>>  	 * the task, and the next invocation will do it.
>>>>  	 */
>>>> -	if (io_should_wake(iowq) || io_has_work(iowq->ctx))
>>>> +	if (io_should_wake(iowq) || io_has_work(iowq->ctx) || iowq->hit_timeout)
>>>
>>> iowq->hit_timeout may be modified in a timer softirq context, while this
>>> wait_queue_func_t (AIUI) may get called from any context e.g.
>>> net_rx_softirq for sockets. Does this need a READ_ONLY()?
>>
>> Yes probably not a bad idea to make it READ_ONCE().
>>
>>>>  		return autoremove_wake_function(curr, mode, wake_flags, key);
>>>>  	return -1;
>>>>  }
>>>> @@ -2350,6 +2350,38 @@ static bool current_pending_io(void)
>>>>  	return percpu_counter_read_positive(&tctx->inflight);
>>>>  }
>>>>  
>>>> +static enum hrtimer_restart io_cqring_timer_wakeup(struct hrtimer *timer)
>>>> +{
>>>> +	struct io_wait_queue *iowq = container_of(timer, struct io_wait_queue, t);
>>>> +	struct io_ring_ctx *ctx = iowq->ctx;
>>>> +
>>>> +	WRITE_ONCE(iowq->hit_timeout, 1);
>>>> +	if (ctx->flags & IORING_SETUP_DEFER_TASKRUN)
>>>> +		wake_up_process(ctx->submitter_task);
>>>> +	else
>>>> +		io_cqring_wake(ctx);
>>>
>>> This is a bit different to schedule_hrtimeout_range_clock(). Why is
>>> io_cqring_wake() needed here for non-DEFER_TASKRUN?
>>
>> That's how the wakeups work - for defer taskrun, the task isn't on a
>> waitqueue at all. Hence we need to wake the task itself. For any other
>> setup, they will be on the waitqueue, and we just call io_cqring_wake()
>> to wake up anyone waiting on the waitqueue. That will iterate the wake
>> queue and call handlers for each item. Having a separate handler for
>> that will allow to NOT wake up the task if we don't need to.
>> taskrun, the waker
> 
> To rephase the question, why is the original code calling
> schedule_hrtimeout_range_clock() not needing to differentiate behaviour
> between defer taskrun and not?

Because that part is the same, the task schedules out and goes to sleep.
That has always been the same regardless of how the ring is setup. Only
difference is that DEFER_TASKRUN doesn't add itself to ctx->wait, and
hence cannot be woken by a wake_up(ctx->wait). We have to wake the task
manually.

-- 
Jens Axboe


