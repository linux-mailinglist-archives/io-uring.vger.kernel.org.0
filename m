Return-Path: <io-uring+bounces-7888-lists+io-uring=lfdr.de@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [147.75.80.249])
	by mail.lfdr.de (Postfix) with ESMTPS id C7014AAE570
	for <lists+io-uring@lfdr.de>; Wed,  7 May 2025 17:51:47 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id CAD891C45008
	for <lists+io-uring@lfdr.de>; Wed,  7 May 2025 15:51:09 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 2587728C2BE;
	Wed,  7 May 2025 15:49:24 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel-dk.20230601.gappssmtp.com header.i=@kernel-dk.20230601.gappssmtp.com header.b="wZ2YGMFD"
X-Original-To: io-uring@vger.kernel.org
Received: from mail-io1-f51.google.com (mail-io1-f51.google.com [209.85.166.51])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8CA4D28B3EC
	for <io-uring@vger.kernel.org>; Wed,  7 May 2025 15:49:19 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.166.51
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1746632964; cv=none; b=BmC9rSu7sIi82OjkFTuT7F3JtRx3Qr4eyr1KU+vPcCn9bA+qQ4lkgwmIq1OFLw/vVv0a/v2o6QqJVePpnrLL5PHai/0vnmybd80od5arIZthJnxxok2p1w2WAgpto4se6LWzm4hlm0QMPN9gNCT6gYqLGbqQywhb2F8MYUz9SJ8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1746632964; c=relaxed/simple;
	bh=NEx6ZBKgqhZU92WSG2SV7nnAqR70gVTTG6JfV6Q9vfo=;
	h=Message-ID:Date:MIME-Version:Subject:To:References:From:
	 In-Reply-To:Content-Type; b=h6/27hnfDxOMt42Fgvh/3602rAaUoM9NIOt/Rfffb+wCSLo+FhXYpmI1d2Thkvd/U7QBQ4v3Mrw55kKl9T1UMXea3qZ1Lx96j9PhV8N9HZJ/df8D3qZGaduOZewcjDrT2pKGB8VAUtPrHqSVvzhHjXPQSvXio6wveusrIZquZkk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=kernel.dk; spf=pass smtp.mailfrom=kernel.dk; dkim=pass (2048-bit key) header.d=kernel-dk.20230601.gappssmtp.com header.i=@kernel-dk.20230601.gappssmtp.com header.b=wZ2YGMFD; arc=none smtp.client-ip=209.85.166.51
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=kernel.dk
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=kernel.dk
Received: by mail-io1-f51.google.com with SMTP id ca18e2360f4ac-86135d11760so565566239f.2
        for <io-uring@vger.kernel.org>; Wed, 07 May 2025 08:49:19 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernel-dk.20230601.gappssmtp.com; s=20230601; t=1746632958; x=1747237758; darn=vger.kernel.org;
        h=content-transfer-encoding:in-reply-to:from:content-language
         :references:to:subject:user-agent:mime-version:date:message-id:from
         :to:cc:subject:date:message-id:reply-to;
        bh=KrWViNwaYMpsEcLTQFUxKzO9zKqxTUOdwZNz8QO23g0=;
        b=wZ2YGMFD3tfH3q1TtqgzNUItIZIqOGQmMxTKFpRyWHuDn7UStQPRj361tSbXliu0fu
         yLDw2f8vTnOM+9JBLDgvhA1RzMuNV9CdZw9RrgxOKm0QH31eWj8OPvAdHhbXHFF/5p6c
         FVxOrUfgqID7bqvCuEuPsVu0mRmsuAVhtaocgxxhZ1E4Kn4JorYLcQ7KQ+ng16JE9sKE
         XJskn8se532RS9Cs66L1IETksL+y3UQFZ+GctUxL3F7tNowpamJU8xxA7ItcxbOFAxXW
         fPDEhAIzZXvTSbUyhwY5mO34/P/aDbhSCHFR481flv889roeMwgbI1lyc/MajkeL87lK
         90cA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1746632958; x=1747237758;
        h=content-transfer-encoding:in-reply-to:from:content-language
         :references:to:subject:user-agent:mime-version:date:message-id
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=KrWViNwaYMpsEcLTQFUxKzO9zKqxTUOdwZNz8QO23g0=;
        b=NUiTF0jpylOmUs8phi51mnZwWpeh9qtOXEI9/nKvuc5etAHd97JCNcik7LeYPV8y/j
         M3z09ULDz7bLf2bwsAOhh3pdJwepV7TfiiuPBXNnSHzuALza6AwNWz/BM+D+ApOSV5hM
         +rOEUxp3pIngVsfQ5hIgIUiZ1EOoIsgIzlvbymXnpm0Ntl2iNgrlG0xKBgHBq4RvD+Ms
         saiA4la5gjTywI+7K3rbUB8p9IYhvcJ6qxxsIDnP8rU79ZEdXApoG5Pkhi35gLAxk/sQ
         tI/1e9qtL6ijmPhkc3Bdb2275aNtdA6t1B9GT5BYK6Yj2bC5eO5MxhuvGnn7clrcele9
         BlVQ==
X-Forwarded-Encrypted: i=1; AJvYcCXrg7hv3nVss1oCo4TwtLxII56M89bLp7A4O+gT+Utry2Vdq5eU55t1vAyIcjPgyC+UcIBiVlGZ0w==@vger.kernel.org
X-Gm-Message-State: AOJu0YyupgEoGPvrDcvtNwJ1rptpdWiBeEqSywp/pKdxce0tIe/15BdB
	n+YDSjNCuWGyWB3Ex4GY4ncHLarwpH0jTASR1Y3sPhdGfBTWsw7pUK5Oyu1sC1twJkFxWV80VE/
	D
X-Gm-Gg: ASbGnctbRVBJr5VVb0p+7k3ksn622OYHrmqz+H7r4243V0lBYeRhSCbJFPHBL9pk/UX
	v4KZ5pYQL7fgQmrsk/43UWVBJsRY3Fuse/Ref0JXPyqBlkutSdh7mABEyA5iKMgsat6TT+g2+NP
	7dxD3Cm7obrlNv6MJN4xMy/+cA4kwC6KkS+CFcYbyepmNpLNVU6QxJ2VrrP44/a/VsvTeemKTQ1
	xU5xX54zIIZQ37GhMOhLuQdCZvhFjl+liZ1PyYscUF+2MgN90dOrk7NDN9vdCgGNShgFiT3nUtG
	fzl+RprAmJ2q5FXsAwqvRs/u43HkbYf3XZ1J
X-Google-Smtp-Source: AGHT+IFMT5e5jwP8RzAvqPy5XiNp2CIbsHquyJx6VrRmDD2A0RTrvLCGKZ6vz5PCnpO44cRcNmYTKA==
X-Received: by 2002:a05:6602:1609:b0:864:4aa2:d796 with SMTP id ca18e2360f4ac-86755073684mr2499839f.8.1746632958637;
        Wed, 07 May 2025 08:49:18 -0700 (PDT)
Received: from [192.168.1.116] ([96.43.243.2])
        by smtp.gmail.com with ESMTPSA id ca18e2360f4ac-864aa5849cesm258333539f.39.2025.05.07.08.49.17
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Wed, 07 May 2025 08:49:18 -0700 (PDT)
Message-ID: <654d7a07-5b5f-4f78-bef5-dda6a919c3e1@kernel.dk>
Date: Wed, 7 May 2025 09:49:17 -0600
Precedence: bulk
X-Mailing-List: io-uring@vger.kernel.org
List-Id: <io-uring.vger.kernel.org>
List-Subscribe: <mailto:io-uring+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:io-uring+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH] io_uring: ensure deferred completions are flushed for
 multishot
To: Pavel Begunkov <asml.silence@gmail.com>,
 io-uring <io-uring@vger.kernel.org>
References: <a1dffa40-0c30-40d0-87b4-0a03698fd85f@kernel.dk>
 <c6260e33-ad29-4cd1-85c1-d0658c347a31@gmail.com>
 <a4ef2e70-e858-4a3a-9f7a-22bd3af2fefe@kernel.dk>
 <f6ac1b25-3185-4d3a-8e8e-d6d2771f2b3c@gmail.com>
 <611393de-4c50-4597-9290-82059e412a4b@kernel.dk>
 <f62f094c-346c-49d0-a80e-bc5fc0dcdc34@gmail.com>
Content-Language: en-US
From: Jens Axboe <axboe@kernel.dk>
In-Reply-To: <f62f094c-346c-49d0-a80e-bc5fc0dcdc34@gmail.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit

On 5/7/25 9:46 AM, Pavel Begunkov wrote:
> On 5/7/25 16:26, Jens Axboe wrote:
>> On 5/7/25 9:11 AM, Pavel Begunkov wrote:
>>> On 5/7/25 15:58, Jens Axboe wrote:
>>>> On 5/7/25 8:36 AM, Pavel Begunkov wrote:
>>>>> On 5/7/25 14:56, Jens Axboe wrote:
>>>>>> Multishot normally uses io_req_post_cqe() to post completions, but when
>>>>>> stopping it, it may finish up with a deferred completion. This is fine,
>>>>>> except if another multishot event triggers before the deferred completions
>>>>>> get flushed. If this occurs, then CQEs may get reordered in the CQ ring,
>>>>>> as new multishot completions get posted before the deferred ones are
>>>>>> flushed. This can cause confusion on the application side, if strict
>>>>>> ordering is required for the use case.
>>>>>>
>>>>>> When multishot posting via io_req_post_cqe(), flush any pending deferred
>>>>>> completions first, if any.
>>>>>>
>>>>>> Cc: stable@vger.kernel.org # 6.1+
>>>>>> Reported-by: Norman Maurer <norman_maurer@apple.com>
>>>>>> Reported-by: Christian Mazakas <christian.mazakas@gmail.com>
>>>>>> Signed-off-by: Jens Axboe <axboe@kernel.dk>
>>>>>>
>>>>>> ---
>>>>>>
>>>>>> diff --git a/io_uring/io_uring.c b/io_uring/io_uring.c
>>>>>> index 769814d71153..541e65a1eebf 100644
>>>>>> --- a/io_uring/io_uring.c
>>>>>> +++ b/io_uring/io_uring.c
>>>>>> @@ -848,6 +848,14 @@ bool io_req_post_cqe(struct io_kiocb *req, s32 res, u32 cflags)
>>>>>>         struct io_ring_ctx *ctx = req->ctx;
>>>>>>         bool posted;
>>>>>>     +    /*
>>>>>> +     * If multishot has already posted deferred completions, ensure that
>>>>>> +     * those are flushed first before posting this one. If not, CQEs
>>>>>> +     * could get reordered.
>>>>>> +     */
>>>>>> +    if (!wq_list_empty(&ctx->submit_state.compl_reqs))
>>>>>> +        __io_submit_flush_completions(ctx);
>>>>>
>>>>> A request is already dead if it's in compl_reqs, there should be no
>>>>> way io_req_post_cqe() is called with it. Is it reordering of CQEs
>>>>> belonging to the same request? And what do you mean by "deferred"
>>>>> completions?
>>>>
>>>> It's not the same req, it's different requests using the same
>>>> provided buffer ring where it can be problematic.
>>>
>>> Ok, and there has never been any ordering guarantees between them.
>>> Is there any report describing the problem? Why it's ok if
>>> io_req_post_cqe() produced CQEs of two multishot requests get
>>> reordered, but it's not when one of them is finishing a request?
>>> What's the problem with provided buffers?
>>
>> There better be ordering between posting of the CQEs - I'm not talking
>> about issue ordering in general, but if you have R1 (request 1) and R2
>> each consuming from the same buffer ring, then completion posting of
>> those absolutely need to be ordered. If not, you can have:
>>
>> R1 peek X buffers, BID Y, BGID Z. Doesn't use io_req_post_cqe() because
>> it's stopping, end up posting via io_req_task_complete ->
>> io_req_complete_defer -> add to deferred list.
>>
>> Other task_work in that run has R2, grabbing buffers from BGID Z,
>> doesn't terminate, posts CQE2 via io_req_post_cqe().
>>
>> tw run done, deferred completions flushed, R1 posts CQE1.
>>
>> Then we have CQE2 ahead of CQE1 in the CQ ring.
> 
> Which is why provided buffers from the beginning were returning
> buffer ids (i.e. bid, id within the group). Is it incremental
> consumption or some newer feature not being able to differentiate
> buffer chunks apart from ordering?

Both incrementally consumed and bundles are susceptible to this
reordering.

>>> It's a pretty bad spot to do such kinds of things, it disables any
>>> mixed mshot with non-mshot batching, and nesting flushing under
>>> an opcode handler is pretty nasty, it should rather stay top
>>> level as it is. From what I hear it's a provided buffer specific
>>> problem and should be fixed there.
>>
>> I agree it's not the prettiest, but I would prefer if we do it this way
>> just in terms of stable backporting. This should be a relatively rare
> 
> Sure. Are you looking into fixing it in a different way for
> upstream? Because it's not the right level of abstraction.

Yeah I think so - basically the common use case for stopping multishot
doesn't really work for this, as there are two methods of posting the
CQE. One is using io_req_post_cqe(), the other is a final deferred
completion. The mix and match of those two is what's causing this,
obviously.

I'd do this patch upstream, and then unify how the various users of
io_req_post_cqe() terminate, and ensure that only one channel is used
for posting CQEs for that case. When we're happy with that, we can
always flag that for stable fixing this one too, at least for 6.x where
x == newer.

Cooking that up right now on top...

-- 
Jens Axboe

