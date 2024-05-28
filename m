Return-Path: <io-uring+bounces-1976-lists+io-uring=lfdr.de@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [IPv6:2604:1380:45e3:2400::1])
	by mail.lfdr.de (Postfix) with ESMTPS id BF9958D1EEB
	for <lists+io-uring@lfdr.de>; Tue, 28 May 2024 16:34:55 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 7149D286529
	for <lists+io-uring@lfdr.de>; Tue, 28 May 2024 14:34:54 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 34EB816D313;
	Tue, 28 May 2024 14:34:49 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel-dk.20230601.gappssmtp.com header.i=@kernel-dk.20230601.gappssmtp.com header.b="jt2xR9Rx"
X-Original-To: io-uring@vger.kernel.org
Received: from mail-oo1-f50.google.com (mail-oo1-f50.google.com [209.85.161.50])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2C3F51DFDE
	for <io-uring@vger.kernel.org>; Tue, 28 May 2024 14:34:46 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.161.50
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1716906889; cv=none; b=GUi0XUbPrI0SXqgqVU+lhvimI1GpPdek7QoACyleVhle76VefnggGtsut7Q57LkGr6eSz+G5DMpcGMIa0QhteczU2U6KzCDcPlcAb1TWAwup1MAXphheSPz+RI6PZtmZ+PZNVGgmvvaMT+ZmFpnWXE03TaLg4SDyGztc06WUpjw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1716906889; c=relaxed/simple;
	bh=sQOxJkXGqkvrLw7WVJA0eWAiO9v960ZcHc3IF64njcw=;
	h=Message-ID:Date:MIME-Version:Subject:To:References:From:
	 In-Reply-To:Content-Type; b=ks8MMHt1tpZXtpqx8a61tIiNBDBGvaeA7teZzdvJMfm5lmtn/FrE5fgav6H6BEfnurkz0mJL/OFM6cUbLBM0mhamcpqEcDQI4MyDHgp5anrT/xeDqcMSLLJUAsSt3uJctA6tyvJW2Drryic/oblxHqzlWY1qzwmjZutvkWJXpKY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=kernel.dk; spf=pass smtp.mailfrom=kernel.dk; dkim=pass (2048-bit key) header.d=kernel-dk.20230601.gappssmtp.com header.i=@kernel-dk.20230601.gappssmtp.com header.b=jt2xR9Rx; arc=none smtp.client-ip=209.85.161.50
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=kernel.dk
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=kernel.dk
Received: by mail-oo1-f50.google.com with SMTP id 006d021491bc7-5b2e8d73bfcso116810eaf.1
        for <io-uring@vger.kernel.org>; Tue, 28 May 2024 07:34:46 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernel-dk.20230601.gappssmtp.com; s=20230601; t=1716906886; x=1717511686; darn=vger.kernel.org;
        h=content-transfer-encoding:in-reply-to:from:content-language
         :references:to:subject:user-agent:mime-version:date:message-id:from
         :to:cc:subject:date:message-id:reply-to;
        bh=h8K4n31EeIrHYg1JG2HBPbSMq0RDMtkjMrEeR4WxUsQ=;
        b=jt2xR9Rx86YhwYHcBo75gmprgyHaolbv38nd3sh0hG2W4sdETnV29N6bh9OhteqfAN
         z3d9wZWxhVPRoL96seWTI0+nT3yvwJ9uavjBkSzYzIjEhoyAvNeDU8HcpIzCwt+y4E+h
         /e0542Sjx1TcMxq6xyxo8t1sBdslXSUx+y3Tw7TQmcVwAQtQszRaH57yW8VXiIyZMI0S
         A//E1TmE8/nKYjfoxzYThOL5+qCMQw9B4NQirA1ZK/+gDLGITviK4PDwb+1ETdNslBQu
         AB9BtD2T0SlLc9BybAUuywNgf8pRKGj3DW4P8V9LD8HuPwX9eSog7tIuFVpDkqX1Ejpt
         WBiQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1716906886; x=1717511686;
        h=content-transfer-encoding:in-reply-to:from:content-language
         :references:to:subject:user-agent:mime-version:date:message-id
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=h8K4n31EeIrHYg1JG2HBPbSMq0RDMtkjMrEeR4WxUsQ=;
        b=TeSCcvOHRrEque2rmFEfYgauCQCyNJDgUHuQdfr179Kf/xaSF7F6EOv5lYnapxr38h
         dkfMR3uBxOJRDbbsrsxhgc6i004dLl49xIQn4qO4BUjtqqCNskidF0qFnXDKDHrfpntR
         pbV8TG6SPDzYyF8FBgTcVwJXLuL8s6xIFq+843JRGaV5csU/4yBxOlpje6ykZMT7PtG+
         UhYjoYKMXGsDpx0dMGUFP3YQrLBpqpGgjzXxRBbWhYbUQSJBHOsnQMZEu1iaKO0CiFEY
         FMDp/sa/qbPjmv3xa139nRLOgOtnSH5kbl0mIJTYDz8WRD1WliXq3KWPPh3ZHo/g4NBj
         Vprg==
X-Forwarded-Encrypted: i=1; AJvYcCXWY44HdZyXhWh/FacMR3nfOEcaYqLRUo011TYDX0vgJXScFH8A6acdlXdOuOJV6cfd4gQnNLO6cMFUUN22MpfpD7rqd5OoeKI=
X-Gm-Message-State: AOJu0YzW7gDN14umnBWo5LTfJeQhOX29NniTyxCRF1tj6eNbx/xEEExO
	6lc+IRkB07T4AguUC6lmm5BlJKhIygIbqqJLELu48opLDciV2wUy+woCg4NUEbNm24AViQfcsGi
	g
X-Google-Smtp-Source: AGHT+IHfV5vGLzq21fCClhvanCDgIc3vrrLd2NypIe5FFwK5wY69NsEWYzxcEcZiGzsT0IG9jbfSXQ==
X-Received: by 2002:a05:6808:4c85:b0:3d1:d3ba:ce0b with SMTP id 5614622812f47-3d1d3bad073mr127447b6e.2.1716906886113;
        Tue, 28 May 2024 07:34:46 -0700 (PDT)
Received: from [192.168.1.116] ([96.43.243.2])
        by smtp.gmail.com with ESMTPSA id 5614622812f47-3d1b36825dfsm1409433b6e.8.2024.05.28.07.34.45
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Tue, 28 May 2024 07:34:45 -0700 (PDT)
Message-ID: <94e3df4c-2dd3-4b8d-a65f-0db030276007@kernel.dk>
Date: Tue, 28 May 2024 08:34:44 -0600
Precedence: bulk
X-Mailing-List: io-uring@vger.kernel.org
List-Id: <io-uring.vger.kernel.org>
List-Subscribe: <mailto:io-uring+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:io-uring+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCHSET 0/3] Improve MSG_RING SINGLE_ISSUER performance
To: Pavel Begunkov <asml.silence@gmail.com>, io-uring@vger.kernel.org
References: <20240524230501.20178-1-axboe@kernel.dk>
 <3571192b-238b-47a3-948d-1ecff5748c01@gmail.com>
Content-Language: en-US
From: Jens Axboe <axboe@kernel.dk>
In-Reply-To: <3571192b-238b-47a3-948d-1ecff5748c01@gmail.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit

On 5/28/24 7:31 AM, Pavel Begunkov wrote:
> On 5/24/24 23:58, Jens Axboe wrote:
>> Hi,
>>
>> A ring setup with with IORING_SETUP_SINGLE_ISSUER, which is required to
> 
> IORING_SETUP_SINGLE_ISSUER has nothing to do with it, it's
> specifically an IORING_SETUP_DEFER_TASKRUN optimisation.

Right, I should change that in the commit message. It's task_complete
driving it, which is tied to DEFER_TASKRUN.

>> use IORING_SETUP_DEFER_TASKRUN, will need two round trips through
>> generic task_work. This isn't ideal. This patchset attempts to rectify
>> that, taking a new approach rather than trying to use the io_uring
>> task_work infrastructure to handle it as in previous postings.
> 
> Not sure why you'd want to piggyback onto overflows, it's not
> such a well made and reliable infra, whereas the DEFER_TASKRUN
> part of the task_work approach was fine.

It's not right now, because it's really a "don't get into this
condition, if you do, things are slower". And this series doesn't really
change that, and honestly it doesn't even need to. It's still way better
than what we had before in terms of DEFER_TASKRUN and messages.

We could certainly make the messages a subset of real overflow if we
wanted, but honestly it looks decent enough as-is with the changes that
I'm not hugely motivated to do that.

> The completion path doesn't usually look at the overflow list
> but on cached cqe pointers showing the CQ is full, that means
> after you queue an overflow someone may post a CQE in the CQ
> in the normal path and you get reordering. Not that bad
> considering it's from another ring, but a bit nasty and surely
> will bite us back in the future, it always does.

This is true, but generally true as well as completions come in async.
You don't get to control the exact order on a remote ring. Messages
themselves will be ordered when posted, which should be the important
aspect here. Order with locally posted completions I don't see why you'd
care, that's a timing game that you cannot control.

> That's assuming you decide io_msg_need_remote() solely based
> ->task_complete and remove
> 
>     return current != target_ctx->submitter_task;
> 
> otherwise you can get two linked msg_ring target CQEs reordered.

Good point, since it'd now be cheap enough, would probably make sense to
simply gate it on task_complete alone. I even toyed with the idea of
just using this approach for any ring type and kill some code in there,
but didn't venture that far yet.

> It's also duplicating that crappy overflow code nobody cares
> much about, and it's still a forced wake up with no batching,
> circumventing the normal wake up path, i.e. io_uring tw.

Yes, since this is v1 I didn't bother to integrate more tightly with the
generic overflows, that should obviously be done by first adding a
helper for this. I consider that pretty minor.

> I don't think we should care about the request completion
> latency (sender latency), people should be more interested
> in the reaction speed (receiver latency), but if you care
> about it for a reason, perhaps you can just as well allocate
> a new request and complete the previous one right away.

I know the numbers I posted was just sender side improvements on that
particular box, however that isn't really the case for others. Here's on
an another test box:

axboe@r7525 ~> ./msg-lat
init_flags=3000
Wait on startup
802775: my fd 3, other 4
802776: my fd 4, other 3
Latencies for: Receiver
    percentiles (nsec):
     |  1.0000th=[ 4192],  5.0000th=[ 4320], 10.0000th=[ 4448],
     | 20.0000th=[ 4576], 30.0000th=[ 4704], 40.0000th=[ 4832],
     | 50.0000th=[ 4960], 60.0000th=[ 5088], 70.0000th=[ 5216],
     | 80.0000th=[ 5344], 90.0000th=[ 5536], 95.0000th=[ 5728],
     | 99.0000th=[ 6176], 99.5000th=[ 7136], 99.9000th=[19584],
     | 99.9500th=[20352], 99.9900th=[28288]
Latencies for: Sender
    percentiles (nsec):
     |  1.0000th=[ 6560],  5.0000th=[ 6880], 10.0000th=[ 7008],
     | 20.0000th=[ 7264], 30.0000th=[ 7456], 40.0000th=[ 7712],
     | 50.0000th=[ 8032], 60.0000th=[ 8256], 70.0000th=[ 8512],
     | 80.0000th=[ 8640], 90.0000th=[ 8896], 95.0000th=[ 9152],
     | 99.0000th=[ 9792], 99.5000th=[11584], 99.9000th=[23168],
     | 99.9500th=[28032], 99.9900th=[40192]

and after:

axboe@r7525 ~> ./msg-lat                                                       1.776s
init_flags=3000
Wait on startup
3767: my fd 3, other 4
3768: my fd 4, other 3
Latencies for: Sender
    percentiles (nsec):
     |  1.0000th=[  740],  5.0000th=[  748], 10.0000th=[  756],
     | 20.0000th=[  764], 30.0000th=[  764], 40.0000th=[  772],
     | 50.0000th=[  772], 60.0000th=[  780], 70.0000th=[  780],
     | 80.0000th=[  860], 90.0000th=[  892], 95.0000th=[  900],
     | 99.0000th=[ 1224], 99.5000th=[ 1368], 99.9000th=[ 1656],
     | 99.9500th=[ 1976], 99.9900th=[ 3408]
Latencies for: Receiver
    percentiles (nsec):
     |  1.0000th=[ 2736],  5.0000th=[ 2736], 10.0000th=[ 2768],
     | 20.0000th=[ 2800], 30.0000th=[ 2800], 40.0000th=[ 2800],
     | 50.0000th=[ 2832], 60.0000th=[ 2832], 70.0000th=[ 2896],
     | 80.0000th=[ 2928], 90.0000th=[ 3024], 95.0000th=[ 3120],
     | 99.0000th=[ 4080], 99.5000th=[15424], 99.9000th=[18560],
     | 99.9500th=[21632], 99.9900th=[58624]

Obivously some variation in runs in general, but it's most certainly
faster in terms of receiving too. This test case is fixed at doing 100K
messages per second, didn't do any peak testing. But I strongly suspect
you'll see very nice efficiency gains here too, as doing two TWA_SIGNAL
task_work is pretty sucky imho.

You could just make it io_kiocb based, but I did not want to get into
foreign requests on remote rings. What would you envision with that
approach, using our normal ring task_work for this instead? That would
be an approach, obviously this one took a different path from the
previous task_work driven approach.

-- 
Jens Axboe


