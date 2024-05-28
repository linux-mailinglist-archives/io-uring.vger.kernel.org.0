Return-Path: <io-uring+bounces-1980-lists+io-uring=lfdr.de@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [147.75.199.223])
	by mail.lfdr.de (Postfix) with ESMTPS id 0A7E28D21F8
	for <lists+io-uring@lfdr.de>; Tue, 28 May 2024 18:50:33 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id 15EEF1C22F76
	for <lists+io-uring@lfdr.de>; Tue, 28 May 2024 16:50:32 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id B9E0A172BC2;
	Tue, 28 May 2024 16:50:27 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="MBiN6DGH"
X-Original-To: io-uring@vger.kernel.org
Received: from mail-ej1-f48.google.com (mail-ej1-f48.google.com [209.85.218.48])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E43AA171E44
	for <io-uring@vger.kernel.org>; Tue, 28 May 2024 16:50:25 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.218.48
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1716915027; cv=none; b=BvuG9haU7UcZU1C4re9J6EE7AqjBzwLuQj+ljfXsUNSvoSOzypW+To2sf/c6CTieeyU5TNOawXdTpnLZ0Tk25Fj2S6JjPkiUtcUHCiZQG/EKCNkibswvS1IdxmrlbJeX+3eQlnn0/GwGdhc38b2v2uoGnlmPnfvjcwwNygS7+ek=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1716915027; c=relaxed/simple;
	bh=/1E5koQTESPOgu1wututwKU+m34VG+2q3t3o8UMQjpY=;
	h=Message-ID:Date:MIME-Version:Subject:To:References:From:
	 In-Reply-To:Content-Type; b=Q2aGQgm1LOO+fDCt0xoqoBw2GyWDuhqGDP4dO9s+ir3RevKjYf5QCL5ieCsoU0P9v1Nklc7s/doA3GsSYcFPpIEilmVyzIEnCz9DHM1v8vFTdNM1oT70RaR0YD1dRkSgaDtN1PCXwWFLedmQQf52phZYt5XwdIsTSBGHGvi7SHY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=MBiN6DGH; arc=none smtp.client-ip=209.85.218.48
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Received: by mail-ej1-f48.google.com with SMTP id a640c23a62f3a-a6265d47c61so115805366b.0
        for <io-uring@vger.kernel.org>; Tue, 28 May 2024 09:50:25 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1716915024; x=1717519824; darn=vger.kernel.org;
        h=content-transfer-encoding:in-reply-to:from:content-language
         :references:to:subject:user-agent:mime-version:date:message-id:from
         :to:cc:subject:date:message-id:reply-to;
        bh=r43k8ATIHSQ2xGAHQ2xPnzJyXaSz1UMHRaK8lVFZmPQ=;
        b=MBiN6DGHEEAuwGdMkcoyXMj/73W9xsBhnfbxJ4FwuTnj8J3xhuIc29FHPQZEw80zGm
         ZL9R1aMQ6s+qwH69rZza7rExa+gBTgPtylvpAnhrQncutQp1x+lo6SA6Jt5BnKg8Qtvo
         lF0DpIvyec4+e3vEbvk+VV9TwIzifiA6T2XuEA080xze6PL957FKRRHbHEw0B1QtZdZd
         eFx1tn88/35tUCS0BRObpL8dcrNA6MSmJ+BP/te/mWwGm/aRryCzFqq1Bk3CGQebRPd8
         RS9snodtBPUZnAD4BCOPbzZ9RsSmGTeBMzwpPzmgulJZrv/cD/TG2RB3roz6agonzTgt
         cadQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1716915024; x=1717519824;
        h=content-transfer-encoding:in-reply-to:from:content-language
         :references:to:subject:user-agent:mime-version:date:message-id
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=r43k8ATIHSQ2xGAHQ2xPnzJyXaSz1UMHRaK8lVFZmPQ=;
        b=mqeQNlaTEIH+AyFA/UE+epcgaU837LSTHV8LihjjBl2xswYFzDW1MQM9m6NCB7GhEA
         2Lt207LNxrd3Clx2di1TQoMWlm8vBOi5OJGjkD2JGoxsRxbkP3HAsDwsJsaqxRkjrWy+
         BGLMmIDOD2XTRm4Lb9NtoNAVXYkjlCfNiS9joQiW8kwxi80ovD+O9sfkvHByTEdv2Q+u
         3cIP72Nch7JKj9R5kMZhACrc46ZETPZWrsIi9MD5JCo5ZLRBvldJ8WFY05TkbsVPNBFk
         FrMjcYwPRfyhOiOX9hDV+TT+qfaFo02ZHIwcpR6kvP5tFww1oRCHYPLepGQXdcTo58Ml
         YSnQ==
X-Forwarded-Encrypted: i=1; AJvYcCUOsj70Nff6VBU+HUDFkVNQMUjG/bBDTcwa7ZOeg4+5WcBzewztWPIAW+dmhYK5I/Iw5c6YXxXeMK2lCp1tl8XvaGdEIoySqXg=
X-Gm-Message-State: AOJu0Yx6+nePjsnFRAKI+Rahn4g5a9sWwuIdzPX1QQtR8ghjH9QOT6iX
	Dme901GiLhhTWg4ve2QmrC5jR6n+cUjJjBZyrBDSuiNt8s5akXOJKZFOOw==
X-Google-Smtp-Source: AGHT+IGsuAPl5Dn0RwdT7z/Q3iCfBH7/sQpRTMsCe8fXQB5ZBbvxtVYNh5pKlUDcCoE/A53Z6+fSJQ==
X-Received: by 2002:a17:906:f204:b0:a63:a6bc:fc76 with SMTP id a640c23a62f3a-a63a6bcfd8dmr14699666b.8.1716915023381;
        Tue, 28 May 2024 09:50:23 -0700 (PDT)
Received: from [192.168.42.198] ([163.114.131.193])
        by smtp.gmail.com with ESMTPSA id a640c23a62f3a-a635238fcc3sm55600766b.63.2024.05.28.09.50.23
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Tue, 28 May 2024 09:50:23 -0700 (PDT)
Message-ID: <d3d8363e-280d-41f4-94ac-8b7bb0ce16a9@gmail.com>
Date: Tue, 28 May 2024 17:50:27 +0100
Precedence: bulk
X-Mailing-List: io-uring@vger.kernel.org
List-Id: <io-uring.vger.kernel.org>
List-Subscribe: <mailto:io-uring+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:io-uring+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCHSET 0/3] Improve MSG_RING SINGLE_ISSUER performance
To: Jens Axboe <axboe@kernel.dk>, io-uring@vger.kernel.org
References: <20240524230501.20178-1-axboe@kernel.dk>
 <3571192b-238b-47a3-948d-1ecff5748c01@gmail.com>
 <94e3df4c-2dd3-4b8d-a65f-0db030276007@kernel.dk>
Content-Language: en-US
From: Pavel Begunkov <asml.silence@gmail.com>
In-Reply-To: <94e3df4c-2dd3-4b8d-a65f-0db030276007@kernel.dk>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit

On 5/28/24 15:34, Jens Axboe wrote:
> On 5/28/24 7:31 AM, Pavel Begunkov wrote:
>> On 5/24/24 23:58, Jens Axboe wrote:
>>> Hi,
>>>
>>> A ring setup with with IORING_SETUP_SINGLE_ISSUER, which is required to
>>
>> IORING_SETUP_SINGLE_ISSUER has nothing to do with it, it's
>> specifically an IORING_SETUP_DEFER_TASKRUN optimisation.
> 
> Right, I should change that in the commit message. It's task_complete
> driving it, which is tied to DEFER_TASKRUN.
> 
>>> use IORING_SETUP_DEFER_TASKRUN, will need two round trips through
>>> generic task_work. This isn't ideal. This patchset attempts to rectify
>>> that, taking a new approach rather than trying to use the io_uring
>>> task_work infrastructure to handle it as in previous postings.
>>
>> Not sure why you'd want to piggyback onto overflows, it's not
>> such a well made and reliable infra, whereas the DEFER_TASKRUN
>> part of the task_work approach was fine.
> 
> It's not right now, because it's really a "don't get into this
> condition, if you do, things are slower". And this series doesn't really
> change that, and honestly it doesn't even need to. It's still way better
> than what we had before in terms of DEFER_TASKRUN and messages.

Better than how it is now or comparing to the previous attempt?
I think the one using io_uring's tw infra was better, which is
where all wake ups and optimisations currently consolidate.

> We could certainly make the messages a subset of real overflow if we
> wanted, but honestly it looks decent enough as-is with the changes that
> I'm not hugely motivated to do that.

Not sure what you mean here, but not really suggesting refactoring
overflows. Taking the tw based patches should be easy, it only
needs killing !DEFER_TASKRUN changes from there.


>> The completion path doesn't usually look at the overflow list
>> but on cached cqe pointers showing the CQ is full, that means
>> after you queue an overflow someone may post a CQE in the CQ
>> in the normal path and you get reordering. Not that bad
>> considering it's from another ring, but a bit nasty and surely
>> will bite us back in the future, it always does.
> 
> This is true, but generally true as well as completions come in async.
> You don't get to control the exact order on a remote ring. Messages
> themselves will be ordered when posted, which should be the important
> aspect here. Order with locally posted completions I don't see why you'd
> care, that's a timing game that you cannot control.

True for a single request, but in a more complex system
sender's ordering will affect the order on the receiving side.

ring1: msg_ring(); write(pipe)
ring2: read(pipe)

The user would definitely think that the other ring will
first get a msg_ring CQE and then an CQE from the read, but as
always it's hard to predict all repercussions.

>> That's assuming you decide io_msg_need_remote() solely based
>> ->task_complete and remove
>>
>>      return current != target_ctx->submitter_task;
>>
>> otherwise you can get two linked msg_ring target CQEs reordered.
> 
> Good point, since it'd now be cheap enough, would probably make sense to
> simply gate it on task_complete alone. I even toyed with the idea of
> just using this approach for any ring type and kill some code in there,
> but didn't venture that far yet.

That task check doesn't make any real difference. If it's the
same thread you can skip io_uring all together.

>> It's also duplicating that crappy overflow code nobody cares
>> much about, and it's still a forced wake up with no batching,
>> circumventing the normal wake up path, i.e. io_uring tw.
> 
> Yes, since this is v1 I didn't bother to integrate more tightly with the
> generic overflows, that should obviously be done by first adding a
> helper for this. I consider that pretty minor.

My problem is not duplication of code base but rather
extending the internal user base of it. You can say that
msg_ring can easily become a hot path for some, and
then we'll be putting efforts both into overflows and
task_work when in essence they solve quite a similar
problem here.

>> I don't think we should care about the request completion
>> latency (sender latency), people should be more interested
>> in the reaction speed (receiver latency), but if you care
>> about it for a reason, perhaps you can just as well allocate
>> a new request and complete the previous one right away.
> 
> I know the numbers I posted was just sender side improvements on that
> particular box, however that isn't really the case for others. Here's on
> an another test box:
> 
> axboe@r7525 ~> ./msg-lat
> init_flags=3000
> Wait on startup
> 802775: my fd 3, other 4
> 802776: my fd 4, other 3
> Latencies for: Receiver
>      percentiles (nsec):
>       |  1.0000th=[ 4192],  5.0000th=[ 4320], 10.0000th=[ 4448],
>       | 20.0000th=[ 4576], 30.0000th=[ 4704], 40.0000th=[ 4832],
>       | 50.0000th=[ 4960], 60.0000th=[ 5088], 70.0000th=[ 5216],
>       | 80.0000th=[ 5344], 90.0000th=[ 5536], 95.0000th=[ 5728],
>       | 99.0000th=[ 6176], 99.5000th=[ 7136], 99.9000th=[19584],
>       | 99.9500th=[20352], 99.9900th=[28288]
> Latencies for: Sender
>      percentiles (nsec):
>       |  1.0000th=[ 6560],  5.0000th=[ 6880], 10.0000th=[ 7008],
>       | 20.0000th=[ 7264], 30.0000th=[ 7456], 40.0000th=[ 7712],
>       | 50.0000th=[ 8032], 60.0000th=[ 8256], 70.0000th=[ 8512],
>       | 80.0000th=[ 8640], 90.0000th=[ 8896], 95.0000th=[ 9152],
>       | 99.0000th=[ 9792], 99.5000th=[11584], 99.9000th=[23168],
>       | 99.9500th=[28032], 99.9900th=[40192]
> 
> and after:
> 
> axboe@r7525 ~> ./msg-lat                                                       1.776s
> init_flags=3000
> Wait on startup
> 3767: my fd 3, other 4
> 3768: my fd 4, other 3
> Latencies for: Sender
>      percentiles (nsec):
>       |  1.0000th=[  740],  5.0000th=[  748], 10.0000th=[  756],
>       | 20.0000th=[  764], 30.0000th=[  764], 40.0000th=[  772],
>       | 50.0000th=[  772], 60.0000th=[  780], 70.0000th=[  780],
>       | 80.0000th=[  860], 90.0000th=[  892], 95.0000th=[  900],
>       | 99.0000th=[ 1224], 99.5000th=[ 1368], 99.9000th=[ 1656],
>       | 99.9500th=[ 1976], 99.9900th=[ 3408]
> Latencies for: Receiver
>      percentiles (nsec):
>       |  1.0000th=[ 2736],  5.0000th=[ 2736], 10.0000th=[ 2768],
>       | 20.0000th=[ 2800], 30.0000th=[ 2800], 40.0000th=[ 2800],
>       | 50.0000th=[ 2832], 60.0000th=[ 2832], 70.0000th=[ 2896],
>       | 80.0000th=[ 2928], 90.0000th=[ 3024], 95.0000th=[ 3120],
>       | 99.0000th=[ 4080], 99.5000th=[15424], 99.9000th=[18560],
>       | 99.9500th=[21632], 99.9900th=[58624]
> 
> Obivously some variation in runs in general, but it's most certainly
> faster in terms of receiving too. This test case is fixed at doing 100K
> messages per second, didn't do any peak testing. But I strongly suspect
> you'll see very nice efficiency gains here too, as doing two TWA_SIGNAL
> task_work is pretty sucky imho.

Sure, you mentioned wins on the receiver side, I consider it
to be the main merit (latency and throughput)

> You could just make it io_kiocb based, but I did not want to get into
> foreign requests on remote rings. What would you envision with that
> approach, using our normal ring task_work for this instead? That would

It was buggy in the !DEFER_TASKRUN path. Fortunately, you don't care
about it because it just does it all under ->completion_lock, which
is why you shouldn't have ever hit the problem in testing.

> be an approach, obviously this one took a different path from the
> previous task_work driven approach.

-- 
Pavel Begunkov

