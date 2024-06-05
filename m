Return-Path: <io-uring+bounces-2126-lists+io-uring=lfdr.de@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [IPv6:2604:1380:4601:e00::3])
	by mail.lfdr.de (Postfix) with ESMTPS id BADDB8FD30F
	for <lists+io-uring@lfdr.de>; Wed,  5 Jun 2024 18:41:38 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id 38F631F222E4
	for <lists+io-uring@lfdr.de>; Wed,  5 Jun 2024 16:41:38 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id B6D5E1527B5;
	Wed,  5 Jun 2024 16:41:36 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel-dk.20230601.gappssmtp.com header.i=@kernel-dk.20230601.gappssmtp.com header.b="C27rIDcj"
X-Original-To: io-uring@vger.kernel.org
Received: from mail-oi1-f172.google.com (mail-oi1-f172.google.com [209.85.167.172])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B0C652837A
	for <io-uring@vger.kernel.org>; Wed,  5 Jun 2024 16:41:33 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.167.172
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1717605696; cv=none; b=k5yrK6TvA16eQGWNy98KNnYdD+SN5SMmRiGHHztQe6q41685I5xXp95y2zldGiIDZJaaZzyLeJBEDz5NVHTghO6LeDzC/YzSE7An79t9BdMlz6+wVqKXbdTAPmUAT0Y6UAFIkbbcbRow9ad4nR9l6bf6vJ5Fd5THaZ7CvjqwsLA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1717605696; c=relaxed/simple;
	bh=dLaDhSynmuwI9YLX0T4z28Qj6zqmkaFho3WGD9hlvdI=;
	h=Message-ID:Date:MIME-Version:Subject:To:References:From:
	 In-Reply-To:Content-Type; b=IdfXMI/BiPG2MNnsAk5b21CnR1d47vCaY6I+thw2F/UYKcXQL9lfYG7MsRnId7AkqgR41Hgxp0GEFTD48HpNieaUTJnAHjgJYAIRXqBvCUaEYnnlGhgJyHlwGp0R/YZL7aauMTZgNW4nqbcz0WO8CLG8HCOdfUBoC5S8ERI4dw8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=kernel.dk; spf=pass smtp.mailfrom=kernel.dk; dkim=pass (2048-bit key) header.d=kernel-dk.20230601.gappssmtp.com header.i=@kernel-dk.20230601.gappssmtp.com header.b=C27rIDcj; arc=none smtp.client-ip=209.85.167.172
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=kernel.dk
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=kernel.dk
Received: by mail-oi1-f172.google.com with SMTP id 5614622812f47-3d1fd5fd4e9so285926b6e.1
        for <io-uring@vger.kernel.org>; Wed, 05 Jun 2024 09:41:33 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernel-dk.20230601.gappssmtp.com; s=20230601; t=1717605693; x=1718210493; darn=vger.kernel.org;
        h=content-transfer-encoding:in-reply-to:from:content-language
         :references:to:subject:user-agent:mime-version:date:message-id:from
         :to:cc:subject:date:message-id:reply-to;
        bh=yWu8iluWE1DO36YdJsykDTeO8JOeRlkf5HxPSTPylb4=;
        b=C27rIDcjC7f3omp8KZ1RPCZViryLH7bmgco9OuRxEXu8IJxB/lBjgXihpeYqkT1BI0
         MUSNhneKpTjlAjhdMP2MyELfKPGhAStsR0sY0sEluliHs/0iOSbrcvToOO8mSvlPaiJz
         fp2PMm2T1r/SNMvs8Y79i+9/EIVmZ0Q8atfGCIGJemPVMCOD/AgkvMRtji9gCVFqis02
         oG7aGlD9EqZKklC9+qtLE2vDAW2E2Ngor1LftOM5zkrDuj1eA496MzLJ++O8I7QncZ57
         z5RRmSlyjqtKsJaryM2ojCh+AfqSQqkTjwWM+8nFyZsJ81MVzEX+q/gYFfKEmp9L0pBM
         sZAg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1717605693; x=1718210493;
        h=content-transfer-encoding:in-reply-to:from:content-language
         :references:to:subject:user-agent:mime-version:date:message-id
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=yWu8iluWE1DO36YdJsykDTeO8JOeRlkf5HxPSTPylb4=;
        b=Dp1x0Cr05pRBZ3IJ89BNMHFppfcrFHcbML6lJ8PqkLh0fuGeaqKZLY79GQ12e+5npD
         7W0T2NEFqh/O4zG7YGGP5rZ12R/Kx4I/+5KQQTo8nGqvxv9nK9E9Zp1Mkv5lMPUZwuNr
         4eVMh8OZ4vWgwZ7n4FezEgczM7wxOAobXhp+Ka3sHwS9hfukx0Dve8Gw6M+HKerYodbn
         6g6GAsJcZZ9/ZzQ9u5DURJ4kdzhrn+HTL5ejKK4XXNS649toymHcJnk1RfDLZ9qJbe7i
         NdR/C1sfZgf9+XDC90A2uvJ8SRd9lmVZryCNOwTlnDR2h0SGMTeKfXshy2SaK/Eza9oY
         5tcQ==
X-Forwarded-Encrypted: i=1; AJvYcCVtmqaqFe0v2vDXddB+1r2XC4jdOso9oFmswSYdkljyuqEaz/JpWVTp0KvEIHB+x6yY4q39rB9dpZrhSSvmLaq3ihC8CwVO5FU=
X-Gm-Message-State: AOJu0YwVHk/aSaHQcxFTkXjLqSa0UT2raIiYtJlsTg4rVE2MDEF1pika
	ZuKB9u4989dGIQd8zdE36+taIcPhq+nnyqPHZ8mB9sYDbqj21ZwWjDqcaoXg39/tIjiYbJs0ag2
	B
X-Google-Smtp-Source: AGHT+IGWFBEVF7DZaYpIQvI6gGYAXILKVgspog8R5P5tuWhPdL3OJ59IEMKbo/zQ1vXCqWbr400ieg==
X-Received: by 2002:a05:6808:1786:b0:3d2:368:9288 with SMTP id 5614622812f47-3d20425e4abmr3589484b6e.1.1717605692450;
        Wed, 05 Jun 2024 09:41:32 -0700 (PDT)
Received: from [192.168.1.116] ([96.43.243.2])
        by smtp.gmail.com with ESMTPSA id 5614622812f47-3d20672451bsm222804b6e.8.2024.06.05.09.41.31
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Wed, 05 Jun 2024 09:41:31 -0700 (PDT)
Message-ID: <e89d6035-8a96-413b-9d80-f4092d18738a@kernel.dk>
Date: Wed, 5 Jun 2024 10:41:30 -0600
Precedence: bulk
X-Mailing-List: io-uring@vger.kernel.org
List-Id: <io-uring.vger.kernel.org>
List-Subscribe: <mailto:io-uring+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:io-uring+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCHSET v2 0/7] Improve MSG_RING DEFER_TASKRUN performance
To: Pavel Begunkov <asml.silence@gmail.com>, io-uring@vger.kernel.org
References: <20240530152822.535791-2-axboe@kernel.dk>
 <32ee0379-b8c7-4c34-8c3a-7901e5a78aa2@gmail.com>
 <656d487c-f0d8-401e-9154-4d01ef34356c@kernel.dk>
 <6c8ca196-2444-4c82-a8c0-a93f45fe47da@gmail.com>
Content-Language: en-US
From: Jens Axboe <axboe@kernel.dk>
In-Reply-To: <6c8ca196-2444-4c82-a8c0-a93f45fe47da@gmail.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit

On 6/5/24 9:50 AM, Pavel Begunkov wrote:
> On 6/4/24 19:57, Jens Axboe wrote:
>> On 6/3/24 7:53 AM, Pavel Begunkov wrote:
>>> On 5/30/24 16:23, Jens Axboe wrote:
>>>> Hi,
>>>>
>>>> For v1 and replies to that and tons of perf measurements, go here:
>>>
>>> I'd really prefer the task_work version rather than carving
>>> yet another path specific to msg_ring. Perf might sounds better,
>>> but it's duplicating wake up paths, not integrated with batch
>>> waiting, not clear how affects different workloads with target
>>> locking and would work weird in terms of ordering.
>>
>> The duplication is really minor, basically non-existent imho. It's a
>> wakeup call, it's literally 2 lines of code. I do agree on the batching,
> 
> Well, v3 tries to add msg_ring/nr_overflow handling to local
> task work, that what I mean by duplicating paths, and we'll
> continue gutting the hot path for supporting msg_ring in
> this way.

No matter how you look at it, there will be changes to the hot path
regardless of whether we use local task_work like in the original, or do
the current approach.

> Does it work with eventfd? I can't find any handling, so next
> you'd be adding:
> 
> io_commit_cqring_flush(ctx);

That's merely because the flagging should be done in io_defer_wake(),
moving that code to the common helper as well.

> Likely draining around cq_extra should also be patched.
> Yes, fixable, but it'll be a pile of fun, and without many
> users, it'll take time to discover it all.

Yes that may need tweaking indeed. But this is a bit of a chicken and
egg problem - there are not many users of it, because it currently
sucks. We have to make it better, and there's already one user lined up
because of these changes.

We can't just let MSG_RING linger. It's an appealing interface for
message passing where you are using rings on both sides, but it's
currently pretty much useless exactly for the case that we care about
the most - DEFER_TASKRUN. So right now you are caught between a rock and
a hard place, where you want to use DEFER_TASKRUN because it's a lot
better for the things that people care about, but if you need message
passing, then it doesn't work very well.

>> though I don't think that's really a big concern as most usage I'd
>> expect from this would be sending single messages. You're not batch
>> waiting on those. But there could obviously be cases where you have a
>> lot of mixed traffic, and for those it would make sense to have the
>> batch wakeups.
>>
>> What I do like with this version is that we end up with just one method
>> for delivering the CQE, rather than needing to split it into two. And it
>> gets rid of the uring_lock double locking for non-SINGLE_ISSUER. I know
> 
> You can't get rid of target locking for fd passing, the file tables
> are sync'ed by the lock. Otherwise it's only IOPOLL, because with
> normal rings it can and IIRC does take the completion_lock for CQE
> posting. I don't see a problem here, unless you care that much about
> IOPOLL?

Right, fd passing still needs to grab the lock, and it still does with
the patchset. We can't really get around it for fd passing, at least not
without further work (of which I have no current plans to do). I don't
care about IOPOLL in particular for message passing, I don't think there
are any good use cases there. It's more of a code hygiene thing, the
branches are still there and do exist.

>> we always try and push people towards DEFER_TASKRUN|SINGLE_ISSUER, but
>> that doesn't mean we should just ignore the cases where that isn't true.
>> Unifying that code and making it faster all around is a worthy goal in
>> and of itself. The code is CERTAINLY a lot cleaner after the change than
>> all the IOPOLL etc.
>>
>>> If the swing back is that expensive, another option is to
>>> allocate a new request and let the target ring to deallocate
>>> it once the message is delivered (similar to that overflow
>>> entry).
>>
>> I can give it a shot, and then run some testing. If we get close enough
>> with the latencies and performance, then I'd certainly be more amenable
>> to going either route.
>>
>> We'd definitely need to pass in the required memory and avoid the return
> 
> Right, same as with CQEs
> 
>> round trip, as that basically doubles the cost (and latency) of sending
> 
> Sender's latency, which is IMHO not important at all

But it IS important. Not because of the latency itself, that part is
less important, but because of the added overhead of bouncing from ring1
to ring2, and then back from ring2 to ring1. The reduction in latency is
a direct reflecting of the reduction of overhead.

>> a message. The downside of what you suggest here is that while that
>> should integrate nicely with existing local task_work, it'll also mean
>> that we'll need hot path checks for treating that request type as a
>> special thing. Things like req->ctx being not local, freeing the request
>> rather than recycling, etc. And that'll need to happen in multiple
>> spots.
> 
> I'm not suggesting feeding that request into flush_completions()
> and common completion infra, can be killed right in the tw callback.

Right, so you need to special case these requests when you run the local
task_work. Which was my point above, you're going to need to accept hot
path additions regardless of the approach.

-- 
Jens Axboe


