Return-Path: <io-uring+bounces-2129-lists+io-uring=lfdr.de@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [139.178.88.99])
	by mail.lfdr.de (Postfix) with ESMTPS id ABA038FD660
	for <lists+io-uring@lfdr.de>; Wed,  5 Jun 2024 21:20:57 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 1595A287075
	for <lists+io-uring@lfdr.de>; Wed,  5 Jun 2024 19:20:56 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 9C2CC143C4D;
	Wed,  5 Jun 2024 19:20:51 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="Bda43u8W"
X-Original-To: io-uring@vger.kernel.org
Received: from mail-ed1-f44.google.com (mail-ed1-f44.google.com [209.85.208.44])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C7E4813D27F
	for <io-uring@vger.kernel.org>; Wed,  5 Jun 2024 19:20:49 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.208.44
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1717615251; cv=none; b=TRhuUNmXbCqDGrT7ci04Ww2yHAwEr1ngr7ZUBOYUeTeSDHV08JFJo+Kr/vn3+ht8V2+B8lP8gF65Aq545ByYOK8yx/EAXkaEi1YmH2/C0H9BD7pudYx1jgFR2DK181FGuRuQUCg+bTFh5XxN6Jawr/2KzpcCFLaUpuI/0JTg3S4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1717615251; c=relaxed/simple;
	bh=lIme2BzEIEow30DM6MKYqfebLtZqHixrEhRbGM08cUc=;
	h=Message-ID:Date:MIME-Version:Subject:To:References:From:
	 In-Reply-To:Content-Type; b=pmSgDPIU9teEcqgy31b8Rsvl1LDoD6bOdzPAviqhjnmJob/bnZy68BGzGp3iMXe3W0cOxcJfPf30XQq4Eg940GPXdzjHtKzA73NiWTmmrcBnjibr1bSETh1YAefUdbgJreAy1XyRBTsLe5mJq6DzkKGyPWDafnwuxWpHFlQcEwg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=Bda43u8W; arc=none smtp.client-ip=209.85.208.44
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Received: by mail-ed1-f44.google.com with SMTP id 4fb4d7f45d1cf-57a20c600a7so153352a12.3
        for <io-uring@vger.kernel.org>; Wed, 05 Jun 2024 12:20:49 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1717615248; x=1718220048; darn=vger.kernel.org;
        h=content-transfer-encoding:in-reply-to:from:content-language
         :references:to:subject:user-agent:mime-version:date:message-id:from
         :to:cc:subject:date:message-id:reply-to;
        bh=6bcZh3vysXd6oWhbrvcaTPSJ9jlwT4zVQvsbSx5Lb78=;
        b=Bda43u8WcO6gFcpw3Iwkdd3lDzcH6LvEWkNVeMisA9T4Zm16lRClrNnWWN+6UDg9/R
         COx2zH+5ML3gzvH3Bs9h7SeAllT5hJgS6xizZhuncOeH5WiEYe/akWLda54QR41yhbEF
         eG0vscbUK1yT6LiDFmynzmmSIBs9mhycSqLv8ZbmMQeswYGhq9/pNX2Utc2E/kSrui+G
         +znb5y3AWIfzf//g+H7vjuMiGm91aupV3sWGsyaE9o1QXD73y6+8ZNefC+sa9ERiZ7X8
         MCwhXz0SLYfI+l4zx0W1U6CR1o83YsPmnA/F9pX2zcMbMyB8vHQd2yhyX+nRkHl/t+ky
         AB9Q==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1717615248; x=1718220048;
        h=content-transfer-encoding:in-reply-to:from:content-language
         :references:to:subject:user-agent:mime-version:date:message-id
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=6bcZh3vysXd6oWhbrvcaTPSJ9jlwT4zVQvsbSx5Lb78=;
        b=Xx4Cyovcxr0riuNEMw+u+GUkdf0NF8W8RqIeRBZURPNT8VPOgqR3wty83KGhdVmcuA
         TaWtL9AAldgdSZKNZL3f1/OhocAfmYoCCZq9riE7zFYQAxFF8gNkVCYDhv2LdWNb6n3H
         NZKIpLUCgLmP11YPF5CzzmApWdAF1dYOqe8WWE1pKqpRKu/tJBDhg1se5WmncvT2Q8ku
         X4Hde9pmsc/H+sgxlSZD6LwvTbQk2F3ZxiUASgId8QCPUXLcuzqQ7OaQCIrDaxo59ORD
         Q5kaux+Sc7H3fdq0Taj6xWYyF3ClNoVSACcKxnuFqF3rjVnOLPZazR382uVEp6OlbqhB
         pHXQ==
X-Forwarded-Encrypted: i=1; AJvYcCUP6f1m0P4h4wChzaC6GZ+8lXuslx1XQhRWuJfqNmIk41TmdA7SirZKKWQ/zPq9Ls1Y95IkPXfiPeS99eOKFIFoi7fvpqaMRWk=
X-Gm-Message-State: AOJu0YyITP0xd+Hfj6YuHvCZzTeOotEFIZWipILakjBlJxpxVHmc47zo
	pGQppn/2Q2/eYs4jKZ2WnhkEjiTyIXhylkKCzo1HxGXk/Y2K6uwI1WVLHw==
X-Google-Smtp-Source: AGHT+IGvfXydPgmvy+5lyE2DbSNL3qRch604CyzGPLnvbuXPhfHK6fpcqMCExm29qdlN+HQiK5twoA==
X-Received: by 2002:a50:8e51:0:b0:57a:2e77:9bb7 with SMTP id 4fb4d7f45d1cf-57a8b6a8811mr2092310a12.13.1717615247726;
        Wed, 05 Jun 2024 12:20:47 -0700 (PDT)
Received: from [192.168.42.249] (82-132-237-201.dab.02.net. [82.132.237.201])
        by smtp.gmail.com with ESMTPSA id 4fb4d7f45d1cf-57a35e86c36sm9511610a12.54.2024.06.05.12.20.47
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Wed, 05 Jun 2024 12:20:47 -0700 (PDT)
Message-ID: <2027706f-971f-4552-aa0a-95c1db675cb2@gmail.com>
Date: Wed, 5 Jun 2024 20:20:51 +0100
Precedence: bulk
X-Mailing-List: io-uring@vger.kernel.org
List-Id: <io-uring.vger.kernel.org>
List-Subscribe: <mailto:io-uring+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:io-uring+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCHSET v2 0/7] Improve MSG_RING DEFER_TASKRUN performance
To: Jens Axboe <axboe@kernel.dk>, io-uring@vger.kernel.org
References: <20240530152822.535791-2-axboe@kernel.dk>
 <32ee0379-b8c7-4c34-8c3a-7901e5a78aa2@gmail.com>
 <656d487c-f0d8-401e-9154-4d01ef34356c@kernel.dk>
 <6c8ca196-2444-4c82-a8c0-a93f45fe47da@gmail.com>
 <e89d6035-8a96-413b-9d80-f4092d18738a@kernel.dk>
Content-Language: en-US
From: Pavel Begunkov <asml.silence@gmail.com>
In-Reply-To: <e89d6035-8a96-413b-9d80-f4092d18738a@kernel.dk>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit

On 6/5/24 17:41, Jens Axboe wrote:
> On 6/5/24 9:50 AM, Pavel Begunkov wrote:
>> On 6/4/24 19:57, Jens Axboe wrote:
>>> On 6/3/24 7:53 AM, Pavel Begunkov wrote:
>>>> On 5/30/24 16:23, Jens Axboe wrote:
>>>>> Hi,
>>>>>
>>>>> For v1 and replies to that and tons of perf measurements, go here:
>>>>
>>>> I'd really prefer the task_work version rather than carving
>>>> yet another path specific to msg_ring. Perf might sounds better,
>>>> but it's duplicating wake up paths, not integrated with batch
>>>> waiting, not clear how affects different workloads with target
>>>> locking and would work weird in terms of ordering.
>>>
>>> The duplication is really minor, basically non-existent imho. It's a
>>> wakeup call, it's literally 2 lines of code. I do agree on the batching,
>>
>> Well, v3 tries to add msg_ring/nr_overflow handling to local
>> task work, that what I mean by duplicating paths, and we'll
>> continue gutting the hot path for supporting msg_ring in
>> this way.
> 
> No matter how you look at it, there will be changes to the hot path
> regardless of whether we use local task_work like in the original, or do
> the current approach.

The only downside for !msg_ring paths in the original was
un-inlining of local tw_add().

>> Does it work with eventfd? I can't find any handling, so next
>> you'd be adding:
>>
>> io_commit_cqring_flush(ctx);
> 
> That's merely because the flagging should be done in io_defer_wake(),
> moving that code to the common helper as well.

Flagging? If you mean io_commit_cqring_flush() then no,
it shouldn't and cannot be there. It's called strictly after
posting a CQE (or queuing an overflow), which is after tw
callback execution.

>> Likely draining around cq_extra should also be patched.
>> Yes, fixable, but it'll be a pile of fun, and without many
>> users, it'll take time to discover it all.
> 
> Yes that may need tweaking indeed. But this is a bit of a chicken and
> egg problem - there are not many users of it, because it currently
> sucks. We have to make it better, and there's already one user lined up
> because of these changes.
> 
> We can't just let MSG_RING linger. It's an appealing interface for
> message passing where you are using rings on both sides, but it's
> currently pretty much useless exactly for the case that we care about
> the most - DEFER_TASKRUN. So right now you are caught between a rock and
> a hard place, where you want to use DEFER_TASKRUN because it's a lot
> better for the things that people care about, but if you need message
> passing, then it doesn't work very well.
> 
>>> though I don't think that's really a big concern as most usage I'd
>>> expect from this would be sending single messages. You're not batch
>>> waiting on those. But there could obviously be cases where you have a
>>> lot of mixed traffic, and for those it would make sense to have the
>>> batch wakeups.
>>>
>>> What I do like with this version is that we end up with just one method
>>> for delivering the CQE, rather than needing to split it into two. And it
>>> gets rid of the uring_lock double locking for non-SINGLE_ISSUER. I know
>>
>> You can't get rid of target locking for fd passing, the file tables
>> are sync'ed by the lock. Otherwise it's only IOPOLL, because with
>> normal rings it can and IIRC does take the completion_lock for CQE
>> posting. I don't see a problem here, unless you care that much about
>> IOPOLL?
> 
> Right, fd passing still needs to grab the lock, and it still does with
> the patchset. We can't really get around it for fd passing, at least not
> without further work (of which I have no current plans to do). I don't
> care about IOPOLL in particular for message passing, I don't think there
> are any good use cases there. It's more of a code hygiene thing, the
> branches are still there and do exist.
> 
>>> we always try and push people towards DEFER_TASKRUN|SINGLE_ISSUER, but
>>> that doesn't mean we should just ignore the cases where that isn't true.
>>> Unifying that code and making it faster all around is a worthy goal in
>>> and of itself. The code is CERTAINLY a lot cleaner after the change than
>>> all the IOPOLL etc.
>>>
>>>> If the swing back is that expensive, another option is to
>>>> allocate a new request and let the target ring to deallocate
>>>> it once the message is delivered (similar to that overflow
>>>> entry).
>>>
>>> I can give it a shot, and then run some testing. If we get close enough
>>> with the latencies and performance, then I'd certainly be more amenable
>>> to going either route.
>>>
>>> We'd definitely need to pass in the required memory and avoid the return
>>
>> Right, same as with CQEs
>>
>>> round trip, as that basically doubles the cost (and latency) of sending
>>
>> Sender's latency, which is IMHO not important at all
> 
> But it IS important. Not because of the latency itself, that part is
> less important, but because of the added overhead of bouncing from ring1
> to ring2, and then back from ring2 to ring1. The reduction in latency is
> a direct reflecting of the reduction of overhead.
> 
>>> a message. The downside of what you suggest here is that while that
>>> should integrate nicely with existing local task_work, it'll also mean
>>> that we'll need hot path checks for treating that request type as a
>>> special thing. Things like req->ctx being not local, freeing the request
>>> rather than recycling, etc. And that'll need to happen in multiple
>>> spots.
>>
>> I'm not suggesting feeding that request into flush_completions()
>> and common completion infra, can be killed right in the tw callback.
> 
> Right, so you need to special case these requests when you run the local
> task_work. Which was my point above, you're going to need to accept hot
> path additions regardless of the approach.
> 

-- 
Pavel Begunkov

