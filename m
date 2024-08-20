Return-Path: <io-uring+bounces-2849-lists+io-uring=lfdr.de@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [147.75.199.223])
	by mail.lfdr.de (Postfix) with ESMTPS id 63E40958FCE
	for <lists+io-uring@lfdr.de>; Tue, 20 Aug 2024 23:37:31 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id 895B61C20FC6
	for <lists+io-uring@lfdr.de>; Tue, 20 Aug 2024 21:37:30 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 0DBD01E86E;
	Tue, 20 Aug 2024 21:37:25 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=davidwei-uk.20230601.gappssmtp.com header.i=@davidwei-uk.20230601.gappssmtp.com header.b="kctlCKUC"
X-Original-To: io-uring@vger.kernel.org
Received: from mail-pl1-f173.google.com (mail-pl1-f173.google.com [209.85.214.173])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7BADF1C57A8
	for <io-uring@vger.kernel.org>; Tue, 20 Aug 2024 21:37:23 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.214.173
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1724189844; cv=none; b=GCDqNok9NGpuOpXqRG7ZTjQ3jVCaFoA2Nf779Rzzu6l2eKizVBbr5UEMxpWqvE+46tE6rHMGxA5hobQJWb3Prb3EKXSFFe3IGqlxsRc++r/uOEAEsd6J8+WTT91mh48Brw6zSCldZ9A60aOSfz+8Hx3bZoG6lCjoEMBtZRJ/2fA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1724189844; c=relaxed/simple;
	bh=cbVJ/y8VAPkfZuDtBPkW/6vQjZIOg4taQhDO285/7dY=;
	h=Message-ID:Date:MIME-Version:Subject:To:References:From:
	 In-Reply-To:Content-Type; b=M67dyeP3Gznz/thce+vvj/kkEhXFNlvboKXXUP8jzIDGl9jq/0QLSkBbXqms67PXjZyOHYLqHTGTGFz/2cGoVAEDKPuSNhGc0Aovugp5z9WA7I/8xtmJ4XgFbt2k3iAlQPQ+48bU60BGwXAtYzjpKZs2NsFLvLniWFQn/YA1wvs=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=davidwei.uk; spf=none smtp.mailfrom=davidwei.uk; dkim=pass (2048-bit key) header.d=davidwei-uk.20230601.gappssmtp.com header.i=@davidwei-uk.20230601.gappssmtp.com header.b=kctlCKUC; arc=none smtp.client-ip=209.85.214.173
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=davidwei.uk
Authentication-Results: smtp.subspace.kernel.org; spf=none smtp.mailfrom=davidwei.uk
Received: by mail-pl1-f173.google.com with SMTP id d9443c01a7336-20208830de8so36622545ad.1
        for <io-uring@vger.kernel.org>; Tue, 20 Aug 2024 14:37:23 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=davidwei-uk.20230601.gappssmtp.com; s=20230601; t=1724189843; x=1724794643; darn=vger.kernel.org;
        h=content-transfer-encoding:in-reply-to:from:references:to
         :content-language:subject:user-agent:mime-version:date:message-id
         :from:to:cc:subject:date:message-id:reply-to;
        bh=+dbaGWTTLmnG5alqTxnsyLByZmdvQol4PO2ckktI7ZM=;
        b=kctlCKUCg71PFBq/5tcPIFLYBQ6Xgyqix6Kg7mg2W5uvV2EHRtZFOSZCwmTxAoQ9iR
         xtWTg2WtdzKGetXa5RtT0FqEJlc+ClIAy2vmgSqHIDgyB+QKmjqSWYStBsbIwO2oVgyh
         xsmUO0GQrnFKLK7h/AderYDiFv8DLvv2qxIrxrsq63cyhf497F0qQrbxK3W2CWxQGyyp
         USYkjORCuGhmOvR0l8gPH0Z8JPBfQ3PIEkBpkHzmyM0crPvXEHmQG2dcaK+tlLQRPJzj
         raJmbOuX/PUnGXyFxWu6Kqmvo0ukDSfagzxRzlOIcXyOeqJY6y7vDsO31Iu9+ACHkaNC
         arww==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1724189843; x=1724794643;
        h=content-transfer-encoding:in-reply-to:from:references:to
         :content-language:subject:user-agent:mime-version:date:message-id
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=+dbaGWTTLmnG5alqTxnsyLByZmdvQol4PO2ckktI7ZM=;
        b=NxZs8ltgXVszsg8WyVM8qW25DWER97pyxG4A/l5YDuAYskWVv1rwF3qkNIsHJPgyg7
         kH5VnUzpNYJm+GHH683EcseQPiv/maLZHWqko3RN2Z9Kjd5XJzmk9bkwGWGRxiY4OVUO
         m5suQuGhuDKZrrXEA4jN7EXLPtAGwxbfrXH6jLl/duvdpZ4/qKM3fHMHGBMfw278JiWA
         f0PcJG2uidSn66XBa9BNUFpLzO//lbS8a40G0tSGYlc0F1R+jSNgRv5WT5ZwMn00QMuM
         3EdDtsSYjxAbEe9JODxPfoOUd8kJwJ3mR0y7GksB4V2FHq2mL8rY7m5wHasOxje6T07L
         5B9g==
X-Forwarded-Encrypted: i=1; AJvYcCWfP4rY+0JJsjvqOpKQsZong/xMxzmmpBvvZHoFjErVWdactCO/gEuU9B2HNC/lfR8sHlTVSmOqKQ==@vger.kernel.org
X-Gm-Message-State: AOJu0YzUA+nzrDI9bTu7YSy8BuA3/FoZ6+1LIv97pdchTcnTsV03AZDm
	+bzS9Eh8ORc2au6n6PFnDifIm1cWhb5HuCGlLFN7BFhAUpgWI8zTQ6EdpyJhRCQ=
X-Google-Smtp-Source: AGHT+IF3AWj1Goi+rK6Cl39Fq87km6NRlx/+LMC/tqbwJkypoyvgckQ1vWFHMCpcCu3P8gAsn1wIag==
X-Received: by 2002:a17:903:41c8:b0:1fc:72f5:43b6 with SMTP id d9443c01a7336-20367c0bfdamr3042915ad.20.1724189842655;
        Tue, 20 Aug 2024 14:37:22 -0700 (PDT)
Received: from ?IPV6:2a03:83e0:1256:1:80c:c984:f4f1:951f? ([2620:10d:c090:500::5:2f5b])
        by smtp.gmail.com with ESMTPSA id d9443c01a7336-201f031bd78sm82104765ad.73.2024.08.20.14.37.21
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Tue, 20 Aug 2024 14:37:22 -0700 (PDT)
Message-ID: <d1116971-a2f7-430d-97d8-03440befd38a@davidwei.uk>
Date: Tue, 20 Aug 2024 14:37:20 -0700
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
From: David Wei <dw@davidwei.uk>
In-Reply-To: <cb79d5dd-3ff2-4cc3-ae0e-24c03d2729b3@kernel.dk>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit

On 2024-08-20 14:34, Jens Axboe wrote:
> On 8/20/24 2:08 PM, David Wei wrote:
>> On 2024-08-19 16:28, Jens Axboe wrote:
>>> In preparation for having two distinct timeouts and avoid waking the
>>> task if we don't need to.
>>>
>>> Signed-off-by: Jens Axboe <axboe@kernel.dk>
>>> ---
>>>  io_uring/io_uring.c | 41 ++++++++++++++++++++++++++++++++++++-----
>>>  io_uring/io_uring.h |  2 ++
>>>  2 files changed, 38 insertions(+), 5 deletions(-)
>>>
>>> diff --git a/io_uring/io_uring.c b/io_uring/io_uring.c
>>> index 9e2b8d4c05db..ddfbe04c61ed 100644
>>> --- a/io_uring/io_uring.c
>>> +++ b/io_uring/io_uring.c
>>> @@ -2322,7 +2322,7 @@ static int io_wake_function(struct wait_queue_entry *curr, unsigned int mode,
>>>  	 * Cannot safely flush overflowed CQEs from here, ensure we wake up
>>>  	 * the task, and the next invocation will do it.
>>>  	 */
>>> -	if (io_should_wake(iowq) || io_has_work(iowq->ctx))
>>> +	if (io_should_wake(iowq) || io_has_work(iowq->ctx) || iowq->hit_timeout)
>>
>> iowq->hit_timeout may be modified in a timer softirq context, while this
>> wait_queue_func_t (AIUI) may get called from any context e.g.
>> net_rx_softirq for sockets. Does this need a READ_ONLY()?
> 
> Yes probably not a bad idea to make it READ_ONCE().
> 
>>>  		return autoremove_wake_function(curr, mode, wake_flags, key);
>>>  	return -1;
>>>  }
>>> @@ -2350,6 +2350,38 @@ static bool current_pending_io(void)
>>>  	return percpu_counter_read_positive(&tctx->inflight);
>>>  }
>>>  
>>> +static enum hrtimer_restart io_cqring_timer_wakeup(struct hrtimer *timer)
>>> +{
>>> +	struct io_wait_queue *iowq = container_of(timer, struct io_wait_queue, t);
>>> +	struct io_ring_ctx *ctx = iowq->ctx;
>>> +
>>> +	WRITE_ONCE(iowq->hit_timeout, 1);
>>> +	if (ctx->flags & IORING_SETUP_DEFER_TASKRUN)
>>> +		wake_up_process(ctx->submitter_task);
>>> +	else
>>> +		io_cqring_wake(ctx);
>>
>> This is a bit different to schedule_hrtimeout_range_clock(). Why is
>> io_cqring_wake() needed here for non-DEFER_TASKRUN?
> 
> That's how the wakeups work - for defer taskrun, the task isn't on a
> waitqueue at all. Hence we need to wake the task itself. For any other
> setup, they will be on the waitqueue, and we just call io_cqring_wake()
> to wake up anyone waiting on the waitqueue. That will iterate the wake
> queue and call handlers for each item. Having a separate handler for
> that will allow to NOT wake up the task if we don't need to.
> taskrun, the waker

To rephase the question, why is the original code calling
schedule_hrtimeout_range_clock() not needing to differentiate behaviour
between defer taskrun and not?

