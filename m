Return-Path: <io-uring+bounces-1982-lists+io-uring=lfdr.de@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [139.178.88.99])
	by mail.lfdr.de (Postfix) with ESMTPS id ABF068D2302
	for <lists+io-uring@lfdr.de>; Tue, 28 May 2024 20:07:46 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 5E9D52816FE
	for <lists+io-uring@lfdr.de>; Tue, 28 May 2024 18:07:45 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 676AA45BE3;
	Tue, 28 May 2024 18:07:42 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel-dk.20230601.gappssmtp.com header.i=@kernel-dk.20230601.gappssmtp.com header.b="dFZ421D+"
X-Original-To: io-uring@vger.kernel.org
Received: from mail-pf1-f177.google.com (mail-pf1-f177.google.com [209.85.210.177])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id F398444C7E
	for <io-uring@vger.kernel.org>; Tue, 28 May 2024 18:07:39 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.210.177
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1716919662; cv=none; b=vExCEL7VXUbIscxqh+e7HhQqiUjE6ov0bFe2m1hdEIaXvBcQM4bDhpQ2IZkfmOLCXUf7UQQ4bGgVKEihklTM6w8ZOUY7L+Mn6drkiDv/wVz3tgUJ3lc+wdL/FCfjrG0IEmsQ+kLeUZUxFFXiBmDrogjs5RS3UQVS3ESS6X0ZUmQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1716919662; c=relaxed/simple;
	bh=UwmvpJCIGDxcCgw6e7KC+aOmBjxys0SxnPFKA24MRvE=;
	h=Message-ID:Date:MIME-Version:Subject:To:References:From:
	 In-Reply-To:Content-Type; b=WIG34/yoQir9WQ4b8Hj0nlSu4wEwCzYIJNRKkG7iEhJpYvXIk3lUEVfxcjXZ8cJybXBpPgxiv6Kqy9r1etOUozrJSHdgbawQD4dvy1pihYHSPG6+jrPup4DcPC5DVoMg7AQvoS4Li0hgG7MmRGU77wEqB/MEup0Ciwngf++LbFQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=kernel.dk; spf=pass smtp.mailfrom=kernel.dk; dkim=pass (2048-bit key) header.d=kernel-dk.20230601.gappssmtp.com header.i=@kernel-dk.20230601.gappssmtp.com header.b=dFZ421D+; arc=none smtp.client-ip=209.85.210.177
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=kernel.dk
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=kernel.dk
Received: by mail-pf1-f177.google.com with SMTP id d2e1a72fcca58-6f8e9876117so58378b3a.1
        for <io-uring@vger.kernel.org>; Tue, 28 May 2024 11:07:39 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernel-dk.20230601.gappssmtp.com; s=20230601; t=1716919659; x=1717524459; darn=vger.kernel.org;
        h=content-transfer-encoding:in-reply-to:from:content-language
         :references:to:subject:user-agent:mime-version:date:message-id:from
         :to:cc:subject:date:message-id:reply-to;
        bh=8bN5UvyKi964WPIIfg9op4qbKPdiG1fU9vyOjauOGiE=;
        b=dFZ421D+2j3YBjZl7eof23zlZzOKH2u9i2KZNJ65Pxj+VuF1C2tUSwgz51Ieqjt2sw
         hMi1PEv4C/CKyrjS9V3R/uROVXVbEY9UWi7Fwve8xk2pvKzoTkJw4uq6rD2hfFigK1Im
         Gul3kbT6W87CGKgfLqfre0/RrwuAPuL46dEE1tS8snv+1Hb67ogVGnjUgfa+ufMjWa9P
         XXZ47QovlQT0iZyydbpHiXmvMJRYJBp7Z2F23oM9LX1p4vv/2Rvia9fQDqb1dE/sxr6y
         fAYjzJ25HyMKAkpihPHzcJAtox80bUB/9r0w6fyysrsZIAaH1SLnRTxLIUNH8eu2yYuS
         pwwg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1716919659; x=1717524459;
        h=content-transfer-encoding:in-reply-to:from:content-language
         :references:to:subject:user-agent:mime-version:date:message-id
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=8bN5UvyKi964WPIIfg9op4qbKPdiG1fU9vyOjauOGiE=;
        b=QMh0XegdBaOqpTf7Lssik8IPP78yy/bfrQUDSgtx6jMYrikCfqleP0p41Sjk7J4fRI
         O1n9RWOTf49mhWqveS5e36J6FgAyPmtxa0NoR2qcEevbwdPkMOGa8tIa+849thMmUTq6
         wXfMoE8+qzeKAikgD6TuzwShV3QJxcE690IcRcuPU08M5VWsHBNB4JEQxM6GdeND3ik7
         O3TsL6lBGaMsF5hVu+AtQ9mEcN4Sbl2NOUo0ldywvivQD7eGJAQ5GfFLg5q3AXZaYSCD
         KJhlP3B7kzQfFRQ1vj6kX37o6jlvGGlGCy++2G1uoG0VFLKbzm/mlXHjM8NXH0e1Dyex
         tRLg==
X-Forwarded-Encrypted: i=1; AJvYcCVrRcqXq7p702ykIdYCtNldHgoSqyKw/llVujiueAyeV/Gy8T8wZikrpoG9xqkl1ed9ZzzmSLU+E1oGndMzQOyhrm1nkM3ZtHc=
X-Gm-Message-State: AOJu0YzK+yZmCshJ2LQaCMGv7UP3/zimp3DUxVpP95eLKu4Jo+M8BBOw
	IyDSnp4DO4ti7/Dh5vPalSM4i59C10WV1Wi8H4hfP1r4716CTBfJphOUOpN46d8=
X-Google-Smtp-Source: AGHT+IH6x7pFfd4lt3MzcXZkT0xK9xexIqgC4DWLXeW+AhskRoonukVs8qNhmqxxUM2L9FKyL88B6A==
X-Received: by 2002:a17:902:cecd:b0:1f3:ef9:d49c with SMTP id d9443c01a7336-1f4486c4d40mr151899235ad.1.1716919659123;
        Tue, 28 May 2024 11:07:39 -0700 (PDT)
Received: from ?IPV6:2620:10d:c085:21e1::14ae? ([2620:10d:c090:400::5:29f9])
        by smtp.gmail.com with ESMTPSA id d9443c01a7336-1f4960ca6d1sm44262885ad.139.2024.05.28.11.07.38
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Tue, 28 May 2024 11:07:38 -0700 (PDT)
Message-ID: <35a9b48d-7269-417b-a312-6a9d637cfd72@kernel.dk>
Date: Tue, 28 May 2024 12:07:37 -0600
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
 <94e3df4c-2dd3-4b8d-a65f-0db030276007@kernel.dk>
 <d3d8363e-280d-41f4-94ac-8b7bb0ce16a9@gmail.com>
Content-Language: en-US
From: Jens Axboe <axboe@kernel.dk>
In-Reply-To: <d3d8363e-280d-41f4-94ac-8b7bb0ce16a9@gmail.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit

On 5/28/24 10:50 AM, Pavel Begunkov wrote:
> On 5/28/24 15:34, Jens Axboe wrote:
>> On 5/28/24 7:31 AM, Pavel Begunkov wrote:
>>> On 5/24/24 23:58, Jens Axboe wrote:
>>>> Hi,
>>>>
>>>> A ring setup with with IORING_SETUP_SINGLE_ISSUER, which is required to
>>>
>>> IORING_SETUP_SINGLE_ISSUER has nothing to do with it, it's
>>> specifically an IORING_SETUP_DEFER_TASKRUN optimisation.
>>
>> Right, I should change that in the commit message. It's task_complete
>> driving it, which is tied to DEFER_TASKRUN.
>>
>>>> use IORING_SETUP_DEFER_TASKRUN, will need two round trips through
>>>> generic task_work. This isn't ideal. This patchset attempts to rectify
>>>> that, taking a new approach rather than trying to use the io_uring
>>>> task_work infrastructure to handle it as in previous postings.
>>>
>>> Not sure why you'd want to piggyback onto overflows, it's not
>>> such a well made and reliable infra, whereas the DEFER_TASKRUN
>>> part of the task_work approach was fine.
>>
>> It's not right now, because it's really a "don't get into this
>> condition, if you do, things are slower". And this series doesn't really
>> change that, and honestly it doesn't even need to. It's still way better
>> than what we had before in terms of DEFER_TASKRUN and messages.
> 
> Better than how it is now or comparing to the previous attempt?
> I think the one using io_uring's tw infra was better, which is
> where all wake ups and optimisations currently consolidate.

Better than both - I haven't tested with the previous version, but I can
certainly do that. The reason why I think it'll be better is that it
avoids the double roundtrips. Yes v1 was using normal task_work which is
better, but it didn't solve what I think is the fundamental issue here.

I'll forward port it and give it a spin, then we'll know.

>> We could certainly make the messages a subset of real overflow if we
>> wanted, but honestly it looks decent enough as-is with the changes that
>> I'm not hugely motivated to do that.
> 
> Not sure what you mean here, but not really suggesting refactoring
> overflows. Taking the tw based patches should be easy, it only
> needs killing !DEFER_TASKRUN changes from there.

Sorry wasn't clear, the refactoring was purely my suggestion to reduce a
bit of the code duplication.

>>> The completion path doesn't usually look at the overflow list
>>> but on cached cqe pointers showing the CQ is full, that means
>>> after you queue an overflow someone may post a CQE in the CQ
>>> in the normal path and you get reordering. Not that bad
>>> considering it's from another ring, but a bit nasty and surely
>>> will bite us back in the future, it always does.
>>
>> This is true, but generally true as well as completions come in async.
>> You don't get to control the exact order on a remote ring. Messages
>> themselves will be ordered when posted, which should be the important
>> aspect here. Order with locally posted completions I don't see why you'd
>> care, that's a timing game that you cannot control.
> 
> True for a single request, but in a more complex system
> sender's ordering will affect the order on the receiving side.
> 
> ring1: msg_ring(); write(pipe)
> ring2: read(pipe)
> 
> The user would definitely think that the other ring will
> first get a msg_ring CQE and then an CQE from the read, but as
> always it's hard to predict all repercussions.

Nobody should be making assumptions like that, and that will in fact
already not be the case. If the msg_ring fails to lock the remote ring,
then it may very well end up in the hands of io-wq. And then you could
get either result validly, msg CQE first or last.

>>> That's assuming you decide io_msg_need_remote() solely based
>>> ->task_complete and remove
>>>
>>>      return current != target_ctx->submitter_task;
>>>
>>> otherwise you can get two linked msg_ring target CQEs reordered.
>>
>> Good point, since it'd now be cheap enough, would probably make sense to
>> simply gate it on task_complete alone. I even toyed with the idea of
>> just using this approach for any ring type and kill some code in there,
>> but didn't venture that far yet.
> 
> That task check doesn't make any real difference. If it's the
> same thread you can skip io_uring all together.

Yeah agree, I did add a patch in between after the last email to just
remove the task check. It's not really a useful case to attempt to cater
to in particular.

>>> It's also duplicating that crappy overflow code nobody cares
>>> much about, and it's still a forced wake up with no batching,
>>> circumventing the normal wake up path, i.e. io_uring tw.
>>
>> Yes, since this is v1 I didn't bother to integrate more tightly with the
>> generic overflows, that should obviously be done by first adding a
>> helper for this. I consider that pretty minor.
> 
> My problem is not duplication of code base but rather
> extending the internal user base of it. You can say that
> msg_ring can easily become a hot path for some, and
> then we'll be putting efforts both into overflows and
> task_work when in essence they solve quite a similar
> problem here.

That's why I was tempted to remove the task_work path for messages on
top of this. But I agree on the wakeup side, that's obviously something
that doesn't currently work with msg ring. And while I don't see that as
a hard problem to solve, it is a bit annoying to have multiple sources
for that. Would naturally be better to retain just the task_work side.

For one use case that I think is interesting with messages is work
passing, eliminating a user side data structure (and lock) for that and
side channel wakeups, I don't think the wakeup batching matters as
you're generally not going to be batching receiving work. You're either
already running work for processing, or sleeping waiting for one.

>>> I don't think we should care about the request completion
>>> latency (sender latency), people should be more interested
>>> in the reaction speed (receiver latency), but if you care
>>> about it for a reason, perhaps you can just as well allocate
>>> a new request and complete the previous one right away.
>>
>> I know the numbers I posted was just sender side improvements on that
>> particular box, however that isn't really the case for others. Here's on
>> an another test box:
>>
>> axboe@r7525 ~> ./msg-lat
>> init_flags=3000
>> Wait on startup
>> 802775: my fd 3, other 4
>> 802776: my fd 4, other 3
>> Latencies for: Receiver
>>      percentiles (nsec):
>>       |  1.0000th=[ 4192],  5.0000th=[ 4320], 10.0000th=[ 4448],
>>       | 20.0000th=[ 4576], 30.0000th=[ 4704], 40.0000th=[ 4832],
>>       | 50.0000th=[ 4960], 60.0000th=[ 5088], 70.0000th=[ 5216],
>>       | 80.0000th=[ 5344], 90.0000th=[ 5536], 95.0000th=[ 5728],
>>       | 99.0000th=[ 6176], 99.5000th=[ 7136], 99.9000th=[19584],
>>       | 99.9500th=[20352], 99.9900th=[28288]
>> Latencies for: Sender
>>      percentiles (nsec):
>>       |  1.0000th=[ 6560],  5.0000th=[ 6880], 10.0000th=[ 7008],
>>       | 20.0000th=[ 7264], 30.0000th=[ 7456], 40.0000th=[ 7712],
>>       | 50.0000th=[ 8032], 60.0000th=[ 8256], 70.0000th=[ 8512],
>>       | 80.0000th=[ 8640], 90.0000th=[ 8896], 95.0000th=[ 9152],
>>       | 99.0000th=[ 9792], 99.5000th=[11584], 99.9000th=[23168],
>>       | 99.9500th=[28032], 99.9900th=[40192]
>>
>> and after:
>>
>> axboe@r7525 ~> ./msg-lat                                                       1.776s
>> init_flags=3000
>> Wait on startup
>> 3767: my fd 3, other 4
>> 3768: my fd 4, other 3
>> Latencies for: Sender
>>      percentiles (nsec):
>>       |  1.0000th=[  740],  5.0000th=[  748], 10.0000th=[  756],
>>       | 20.0000th=[  764], 30.0000th=[  764], 40.0000th=[  772],
>>       | 50.0000th=[  772], 60.0000th=[  780], 70.0000th=[  780],
>>       | 80.0000th=[  860], 90.0000th=[  892], 95.0000th=[  900],
>>       | 99.0000th=[ 1224], 99.5000th=[ 1368], 99.9000th=[ 1656],
>>       | 99.9500th=[ 1976], 99.9900th=[ 3408]
>> Latencies for: Receiver
>>      percentiles (nsec):
>>       |  1.0000th=[ 2736],  5.0000th=[ 2736], 10.0000th=[ 2768],
>>       | 20.0000th=[ 2800], 30.0000th=[ 2800], 40.0000th=[ 2800],
>>       | 50.0000th=[ 2832], 60.0000th=[ 2832], 70.0000th=[ 2896],
>>       | 80.0000th=[ 2928], 90.0000th=[ 3024], 95.0000th=[ 3120],
>>       | 99.0000th=[ 4080], 99.5000th=[15424], 99.9000th=[18560],
>>       | 99.9500th=[21632], 99.9900th=[58624]
>>
>> Obivously some variation in runs in general, but it's most certainly
>> faster in terms of receiving too. This test case is fixed at doing 100K
>> messages per second, didn't do any peak testing. But I strongly suspect
>> you'll see very nice efficiency gains here too, as doing two TWA_SIGNAL
>> task_work is pretty sucky imho.
> 
> Sure, you mentioned wins on the receiver side, I consider it
> to be the main merit (latency and throughput)

Actually I think both are interesting - not because the sender side is
latency sensitive for on receving the CQE for it, but because it goes
hand in hand with a reduction in cycles spent sending that work. That's
the win on the sender side, more so than the latency win. The latter is
just gravy on top.

>> You could just make it io_kiocb based, but I did not want to get into
>> foreign requests on remote rings. What would you envision with that
>> approach, using our normal ring task_work for this instead? That would
> 
> It was buggy in the !DEFER_TASKRUN path. Fortunately, you don't care
> about it because it just does it all under ->completion_lock, which
> is why you shouldn't have ever hit the problem in testing.

I'll test the old approach and we'll see where we are at.

-- 
Jens Axboe


