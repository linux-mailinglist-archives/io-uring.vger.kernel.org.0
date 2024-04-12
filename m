Return-Path: <io-uring+bounces-1527-lists+io-uring=lfdr.de@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [139.178.88.99])
	by mail.lfdr.de (Postfix) with ESMTPS id F045A8A2F42
	for <lists+io-uring@lfdr.de>; Fri, 12 Apr 2024 15:20:58 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id AD109282E5E
	for <lists+io-uring@lfdr.de>; Fri, 12 Apr 2024 13:20:57 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 1BF80823A3;
	Fri, 12 Apr 2024 13:20:35 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="nEqJ6/fI"
X-Original-To: io-uring@vger.kernel.org
Received: from mail-lj1-f175.google.com (mail-lj1-f175.google.com [209.85.208.175])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2C10281ABF;
	Fri, 12 Apr 2024 13:20:32 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.208.175
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1712928035; cv=none; b=kcZTWPYnIJRByzsPGjQhKS9+nQAMpWqsPtlarQKzkg4eVlUl7quxKEE59vICT8PNJLlAEqKuilTNN+vqb6xbYhJXyVBwUjbasCVSbSyyJcMAGRUW5sfGEffkbmMwARiTxB7pAPJpl8pXiph9CkmFbSOl5MlmnIhoc4RB/PrNUTQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1712928035; c=relaxed/simple;
	bh=ggKNdRNVxGf5EBrQ8LQvx2t3m3au2Eq6IP7KyVOmvXE=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=rDdGDh8Yv299gMUGltOtGJANb5ekTwaXAjay7+Gf3cZrMV5s1LYz+vbaknQcuA9vCYtDFZMurIGy9mVmuwaF0oqxJ1Y6u2MlW8Vtlij7xkMXMOuIJZgQ0yzMi6NvkFW0eW4hewh31cKXfglEsZ4DEXyg/s4nD47wEHpyfNPPxFs=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=nEqJ6/fI; arc=none smtp.client-ip=209.85.208.175
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Received: by mail-lj1-f175.google.com with SMTP id 38308e7fff4ca-2d485886545so13445191fa.2;
        Fri, 12 Apr 2024 06:20:32 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1712928031; x=1713532831; darn=vger.kernel.org;
        h=content-transfer-encoding:in-reply-to:from:content-language
         :references:cc:to:subject:user-agent:mime-version:date:message-id
         :from:to:cc:subject:date:message-id:reply-to;
        bh=VqEa2aOPo9IegVx1B8G79amCgM98vSM6RT7qBuWGPIM=;
        b=nEqJ6/fIpVC9FeUE4AMMxzv8tzjmEhekkkIaE1qFwoTcRe86jtsTCEjOIgeaNNypam
         6F0QtxX6fpYV6KmM42qpk4fHcUuolkvLR6NuVdzjTNi2qmxD2Bu95KrbThm+Xrgt7KC3
         y9bF1pIF5zeN4GxStM/Hcndk2mwTVm/c2oMMn2Mi6ZHzYQpttV5QY1yVmx1nM3wU34sG
         XaikMCfnHdOGEHzMh9Xe8517KXNitrakuC98XNzWeyUac5hPfScNBh+6iZcX0Ur1zbJc
         8WT+pfLcUKjBpcIlXTeuM0yZ2X8utkIG3rnWFWAoRXMQpYNpQlnbhqmwfr+KIpT49yCt
         QFKQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1712928031; x=1713532831;
        h=content-transfer-encoding:in-reply-to:from:content-language
         :references:cc:to:subject:user-agent:mime-version:date:message-id
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=VqEa2aOPo9IegVx1B8G79amCgM98vSM6RT7qBuWGPIM=;
        b=eYJ8utVYYaGXuTJDQp8NVz0b899H1rLB7jd0/SI5gO7X47ib6iJ1R+/qa6uYJrR84g
         7wSKML7m0RaUN/8jgXQ0lL3+D5WZbkd2unrD4a71Pr1AbX+6m9wMhs/qtibKj82T9e4w
         ZpQvHdE/HVvtgoIKFCVzrrGrnAzBD+rNk40zlHAAqelV7Kj2yYKpK12DFfU9zPpqttnq
         6XvpPKX1u/W1pEw4Pn+dfoJll7N98oh1B7Bu0sB/VEVDLBpRKoPRUoyHNLRaQgzrV5rT
         3qrW6ViYKO/UjOPUGGSYpZn3Mt1EjkYhXA2mJm/V4IGyS08m9hvo2Q+ah+YE8qOrzuRY
         ikQw==
X-Forwarded-Encrypted: i=1; AJvYcCWff1NKEJB7Mw+o3C509rXf5p/DKk1Yt+gRZCCon5F9PDV/MQKXSYNWZOqg0wiAlJ/7n28ripYrAcLqdkoE2sMALPOjp6aqyUa9mnAV
X-Gm-Message-State: AOJu0YxiT4X+0Bc8aQLD+oIdPh+YlLPnIFBLGs6v7IrSAUVNk6Hs2FsE
	QO2HJaBZsqxGwSsF1q3hQVClO91BU3pmSpb/tzp2hufyfKHPAEVZ
X-Google-Smtp-Source: AGHT+IHlye3fkEXgNAEnAcc4XvQBBFhLqkNN+i3MEIkF9i/jIbO0V4cW5uqs6VLNdBzYv5r0qfxaPA==
X-Received: by 2002:a2e:a545:0:b0:2d8:58b6:c10d with SMTP id e5-20020a2ea545000000b002d858b6c10dmr2267357ljn.18.1712928030896;
        Fri, 12 Apr 2024 06:20:30 -0700 (PDT)
Received: from [192.168.42.203] ([163.114.131.193])
        by smtp.gmail.com with ESMTPSA id yz15-20020a170906dc4f00b00a4673706b4dsm1830435ejb.78.2024.04.12.06.20.30
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Fri, 12 Apr 2024 06:20:30 -0700 (PDT)
Message-ID: <0eca7b8a-5ea5-4c9a-b6a7-6920b93d27b1@gmail.com>
Date: Fri, 12 Apr 2024 14:20:34 +0100
Precedence: bulk
X-Mailing-List: io-uring@vger.kernel.org
List-Id: <io-uring.vger.kernel.org>
List-Subscribe: <mailto:io-uring+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:io-uring+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH 1/3] io_uring: Add REQ_F_CQE_SKIP support for io_uring
 zerocopy
To: Oliver Crumrine <ozlinuxc@gmail.com>, axboe@kernel.dk
Cc: io-uring@vger.kernel.org, linux-kernel@vger.kernel.org
References: <cover.1712268605.git.ozlinuxc@gmail.com>
 <b1a047a1b2d55c1c245a78ca9772c31a9b3ceb12.1712268605.git.ozlinuxc@gmail.com>
 <6850f08d-0e89-4eb3-bbfb-bdcc5d4e1b78@gmail.com>
 <CAK1VsR17Ea6cmks7BcdvS4ZHQMRz_kWd1NhPh8J1fUpsgC7WFg@mail.gmail.com>
 <c2e63753-5901-47b2-8def-1a98d8fcdd41@gmail.com>
 <CAK1VsR210nrqtxWaVbQh00t_=7rhq9bwucFygGZaT=7N-t7E5Q@mail.gmail.com>
 <CAK1VsR1b-dbAa8pMqGvfcAAcVP3ZkTYZdyqcaK4wJdbuAZtJsA@mail.gmail.com>
 <09f1a8e9-d9ad-4b40-885b-21e1c2ba147b@gmail.com>
 <CAK1VsR3QDh3WiR+r=30f0YQkiYN3hw071Hi9=dkd_xLQ2itdvw@mail.gmail.com>
 <8666ff9d-1cb6-4e92-a1b3-4f3b1fb0ac79@gmail.com>
 <CAK1VsR1+8nQdX4of4A6DoRj5WSyAt2uYFeqG3dAoQ7aR_vkRZg@mail.gmail.com>
Content-Language: en-US
From: Pavel Begunkov <asml.silence@gmail.com>
In-Reply-To: <CAK1VsR1+8nQdX4of4A6DoRj5WSyAt2uYFeqG3dAoQ7aR_vkRZg@mail.gmail.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit

On 4/11/24 01:52, Oliver Crumrine wrote:
> Pavel Begunkov wrote:
>> On 4/9/24 02:33, Oliver Crumrine wrote:
>>> Pavel Begunkov wrote:
>>>> On 4/7/24 20:14, Oliver Crumrine wrote:
>>>>> Oliver Crumrine wrote:
>>>>>> Pavel Begunkov wrote:
>>>>>>> On 4/5/24 21:04, Oliver Crumrine wrote:
>>>>>>>> Pavel Begunkov wrote:
>>>>>>>>> On 4/4/24 23:17, Oliver Crumrine wrote:
>>>>>>>>>> In his patch to enable zerocopy networking for io_uring, Pavel Begunkov
>>>>>>>>>> specifically disabled REQ_F_CQE_SKIP, as (at least from my
>>>>>>>>>> understanding) the userspace program wouldn't receive the
>>>>>>>>>> IORING_CQE_F_MORE flag in the result value.
>>>>>>>>>
>>>>>>>>> No. IORING_CQE_F_MORE means there will be another CQE from this
>>>>>>>>> request, so a single CQE without IORING_CQE_F_MORE is trivially
>>>>>>>>> fine.
>>>>>>>>>
>>>>>>>>> The problem is the semantics, because by suppressing the first
>>>>>>>>> CQE you're loosing the result value. You might rely on WAITALL
>>>>>>>> That's already happening with io_send.
>>>>>>>
>>>>>>> Right, and it's still annoying and hard to use
>>>>>> Another solution might be something where there is a counter that stores
>>>>>> how many CQEs with REQ_F_CQE_SKIP have been processed. Before exiting,
>>>>>> userspace could call a function like: io_wait_completions(int completions)
>>>>>> which would wait until everything is done, and then userspace could peek
>>>>>> the completion ring.
>>>>>>>
>>>>>>>>> as other sends and "fail" (in terms of io_uring) the request
>>>>>>>>> in case of a partial send posting 2 CQEs, but that's not a great
>>>>>>>>> way and it's getting userspace complicated pretty easily.
>>>>>>>>>
>>>>>>>>> In short, it was left out for later because there is a
>>>>>>>>> better way to implement it, but it should be done carefully
>>>>>>>> Maybe we could put the return values in the notifs? That would be a
>>>>>>>> discrepancy between io_send and io_send_zc, though.
>>>>>>>
>>>>>>> Yes. And yes, having a custom flavour is not good. It'd only
>>>>>>> be well usable if apart from returning the actual result
>>>>>>> it also guarantees there will be one and only one CQE, then
>>>>>>> the userspace doesn't have to do the dancing with counting
>>>>>>> and checking F_MORE. In fact, I outlined before how a generic
>>>>>>> solution may looks like:
>>>>>>>
>>>>>>> https://github.com/axboe/liburing/issues/824
>>>>>>>
>>>>>>> The only interesting part, IMHO, is to be able to merge the
>>>>>>> main completion with its notification. Below is an old stash
>>>>>>> rebased onto for-6.10. The only thing missing is relinking,
>>>>>>> but maybe we don't even care about it. I need to cover it
>>>>>>> well with tests.
>>>>>> The patch looks pretty good. The only potential issue is that you store
>>>>>> the res of the normal CQE into the notif CQE. This overwrites the
>>>>>> IORING_CQE_F_NOTIF with IORING_CQE_F_MORE. This means that the notif would
>>>>>> indicate to userspace that there will be another CQE, of which there
>>>>>> won't.
>>>>> I was wrong here; Mixed up flags and result value.
>>>>
>>>> Right, it's fine. And it's synchronised by the ubuf refcounting,
>>>> though it might get more complicated if I'd try out some counting
>>>> optimisations.
>>>>
>>>> FWIW, it shouldn't give any performance wins. The heavy stuff is
>>>> notifications waking the task, which is still there. I can even
>>>> imagine that having separate CQEs might be more flexible and would
>>>> allow more efficient CQ batching.
>>> I've actaully been working on this issue for a little while now. My current
>>> idea is that an id is put into the optval section of the SQE, and then it
>>> can be used to tag that req with a certain group. When a req has a flag
>>> set on it, it can request for all of group's notifs to be "flushed" in one
>>> notif that encompasses that entire group. If the id is zero, it won't be
>>> associated with a group and will generate a notif. LMK if you see anything
>>> in here that could overcomplicate userspace. I think it's pretty simple,
>>> but you've had a crack at this before so I'd like to hear your opinion.
>>
>> You can take a look at early versions of the IORING_OP_SEND_ZC, e.g.
>> patchset v1, probably even later ones. It was basically doing what
>> you've described with minor uapi changes, like you had to declare groups
>> (slots) in advance, i.e. register them.
> My idea is that insead of allocating slots before making requests, "slots"
> will be allocated as the group ids show up. Instead of an array of slots, a
> linked list can be used so things can be kmalloc'ed on the fly to make
> the uapi simpler.
>>
>> More flexible and so performant in some circumstances, but the overall
>> feedback from people trying it is that it's complicated. The user should
>> allocate group ids, track bound requests / buffers, do other management.
>> The next question is how the user should decide what bind to what. There
>> is some nastiness in using the same group for multiple sockets, and then
> Then maybe we find a way to prevent multiple sockets on one group.

You don't have to explicitly prevent it unless there are other reasons,
it's just not given a real app would be able to use it this way.

>> what's the cut line to flush the previous notif? I probably forgot a
> I'd make it the max for a u32 -- I'm (probably) going to use an atomic_t
> to store the counter of how many reqs have been completed, so a u32 max
> would make sense.

To be clear, the question raised is entirely for userspace to decide
if we're talking about the design when the user has to flush a group
notificaiton via flag or so. Atomics or not is a performance side,
that's separate.

>> couple more complaints.
>>
>> TL;DR;
>>
>> The performance is a bit of a longer story, problems are mostly coming
>> from the async nature of io_uring, and it'd be nice to solve at least a
>> part of it generically, not only for sendzc. The expensive stuff is
>> waking up the task, it's not unique to notifications, recv will trigger
>> it with polling as well as other opcodes. Then the key is completion
>> batching.
> Maybe the interface is made for sendzc first, and people could test it
> there. Then if it is considered beneficial to other places, it could be
> implemented there.
>>
>> What's interesting, take for example some tx only toy benchmark with
>> DEFER_TASKRUN (recommended to use in any case). If you always wait for
>> sends without notifications and add eventual *_get_events(), that would
>> completely avoid the wake up overhead if there are enough buffers,
>> and if it's not it can 1:1 replace tx polling.
> Seems like an interesting way to eliminate waiting overhead.
>>
>> Try groups, see if numbers are good. And a heads up, I'm looking at
> I will. Working hard to have the code done by Sunday.

Good, and here is the patchset I mentioned:

https://lore.kernel.org/io-uring/cover.1712923998.git.asml.silence@gmail.com/T/

>> improving it a little bit for TCP because of a report, not changing
>> uapi but might change performance math.

-- 
Pavel Begunkov

