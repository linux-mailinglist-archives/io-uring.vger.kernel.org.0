Return-Path: <io-uring+bounces-1052-lists+io-uring=lfdr.de@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [147.75.80.249])
	by mail.lfdr.de (Postfix) with ESMTPS id D3F1487E05A
	for <lists+io-uring@lfdr.de>; Sun, 17 Mar 2024 22:30:20 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id 5BDCD1F21BFB
	for <lists+io-uring@lfdr.de>; Sun, 17 Mar 2024 21:30:20 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id EE17E208B4;
	Sun, 17 Mar 2024 21:30:15 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel-dk.20230601.gappssmtp.com header.i=@kernel-dk.20230601.gappssmtp.com header.b="fcm3UVSy"
X-Original-To: io-uring@vger.kernel.org
Received: from mail-pf1-f170.google.com (mail-pf1-f170.google.com [209.85.210.170])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id CA662208A7
	for <io-uring@vger.kernel.org>; Sun, 17 Mar 2024 21:30:13 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.210.170
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1710711015; cv=none; b=Yo1DOWD0dPYsT+jUsZHd9+DuiMgCIW0lEyxAd5xwof3oCAWP0c12KBZKldh8egD8cxf0gQ+v31kFeCr4x71FgaofAYP+eUtdVbLTfpsFq/MOeFob35MnMcaOC61k8NOTV9OGkGM2uEReUhU5fIFYFdjblaatqg2pFMKGP27h6jQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1710711015; c=relaxed/simple;
	bh=EAP8WLr0E4ZJ4NmQfGAO4IQBYefspc5BJqXMxVYhUOw=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=JTEIV6g5dvrQupUqWlu5Yj48ryw3UGlvsXdmLQhWnoIoLwvr1bzW8dimE5KJ67VCatHivMYixCTyfIkVsNzbeqZAN0lUS315JrUBH6eYCFtjFxn2jfdp8FJPZeb83O98oU/014RvI7iRyUoohPWTln6NVrtc6g5Sfrgf8MHkoCQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=kernel.dk; spf=pass smtp.mailfrom=kernel.dk; dkim=pass (2048-bit key) header.d=kernel-dk.20230601.gappssmtp.com header.i=@kernel-dk.20230601.gappssmtp.com header.b=fcm3UVSy; arc=none smtp.client-ip=209.85.210.170
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=kernel.dk
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=kernel.dk
Received: by mail-pf1-f170.google.com with SMTP id d2e1a72fcca58-6e6ca65edc9so1297398b3a.0
        for <io-uring@vger.kernel.org>; Sun, 17 Mar 2024 14:30:13 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernel-dk.20230601.gappssmtp.com; s=20230601; t=1710711013; x=1711315813; darn=vger.kernel.org;
        h=content-transfer-encoding:in-reply-to:from:references:cc:to
         :content-language:subject:user-agent:mime-version:date:message-id
         :from:to:cc:subject:date:message-id:reply-to;
        bh=3PxkkblZ7HCoh3ry2JVig2sKl2js1XvqsA+vMJLZU4k=;
        b=fcm3UVSymYH/Bqv7ZkndTW84Mx4GBFwZ/FDbstPwHDUsQP3HDUzzEFJcKOeuhAYeFF
         QA9ShZ30MH01zQm5NEoma7JEi0jmaTQD/PfwIcOdJng/J3O/+xlxLALY9qBe3FyyAkTJ
         Bno6ZKPyLCAgyznnd9y3+HOYXQ4aaya6RoIatI+12Facxo7o+/x0F/IRDd60syVsQKkm
         DD7HIyR3kyFd/DK/JX65XzV36coTg4EAZzl+Cg4HFsGfWw3jeNEq5fqh9zcQ9k1MyXJl
         RgF0vW3IPF7TRj7NBrowcdMN0FFoxWKWpIX2HpF4l2qehx+b0gqhQywqFmHFGti2Fb0K
         0xqg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1710711013; x=1711315813;
        h=content-transfer-encoding:in-reply-to:from:references:cc:to
         :content-language:subject:user-agent:mime-version:date:message-id
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=3PxkkblZ7HCoh3ry2JVig2sKl2js1XvqsA+vMJLZU4k=;
        b=UHoFsqbDT6KIprXybhkzTgGRH38murJMl/1yC5kpgHmBwhdOwxv5IGUFMAjghhAibw
         mPhP/PjQVEKik0/ry5Dplsxk0i6bMmFoxU6GWJvv2DOpcOsUHFB9W4VXKiJUnmGglM+8
         iG8MKCi6zymwoU/P6hLsO7v+y3NuR7qwkVQeomR74En7V0C/CyTkNLX4U2zJYqDt2jpL
         nA7lsj3xyOYFYZ+b6lHgHnBkT+Jzfi8KIwDBW2/IDmhFnsEfHsoAHl5GijOLoFpozID/
         EiW53K6oUqhDz6FOVRMbec+oclwwWeq/5bIm7E8VTZVVrbClh9hYEZITOILBwLTLCsL8
         1oNQ==
X-Forwarded-Encrypted: i=1; AJvYcCXj9BrrUJhjQC8H9XstgXTpkl5tkasyMmVGxj6JPqdGxhjXN0FNwM7A2qt4zmwniSn0NDJSwKbCx/PenBFukBZjbAtFChFPWcI=
X-Gm-Message-State: AOJu0Yybf1nPbTrjdOI5o9jprT6kj1e3oHDla3ZtAkvRuTkIYgR7kGDL
	Zvt6xl3VMj26UBnZ1l67fptBi7fsbNhcTFNdTYu1JQJ9WFwBOMWnZWnGU+iWiNE=
X-Google-Smtp-Source: AGHT+IGTUPuYxpgl1rrznjp7YG/tbbIDCCqaKV4kXFCM+cE18b7FCvus9TaMBI3CwKZIzHU+zGFIYA==
X-Received: by 2002:a62:cd4e:0:b0:6e7:256b:d47 with SMTP id o75-20020a62cd4e000000b006e7256b0d47mr1956668pfg.0.1710711012465;
        Sun, 17 Mar 2024 14:30:12 -0700 (PDT)
Received: from [192.168.1.150] ([198.8.77.194])
        by smtp.gmail.com with ESMTPSA id x16-20020aa784d0000000b006e66c9bb00dsm6734232pfn.179.2024.03.17.14.30.10
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Sun, 17 Mar 2024 14:30:11 -0700 (PDT)
Message-ID: <b33184b5-3c94-4507-9fe1-bf68d93817ba@kernel.dk>
Date: Sun, 17 Mar 2024 15:30:10 -0600
Precedence: bulk
X-Mailing-List: io-uring@vger.kernel.org
List-Id: <io-uring.vger.kernel.org>
List-Subscribe: <mailto:io-uring+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:io-uring+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [RFC PATCH v4 13/16] io_uring: add io_recvzc request
Content-Language: en-US
To: Pavel Begunkov <asml.silence@gmail.com>, David Wei <dw@davidwei.uk>,
 io-uring@vger.kernel.org, netdev@vger.kernel.org
Cc: Jakub Kicinski <kuba@kernel.org>, Paolo Abeni <pabeni@redhat.com>,
 "David S. Miller" <davem@davemloft.net>, Eric Dumazet <edumazet@google.com>,
 Jesper Dangaard Brouer <hawk@kernel.org>, David Ahern <dsahern@kernel.org>,
 Mina Almasry <almasrymina@google.com>
References: <20240312214430.2923019-1-dw@davidwei.uk>
 <20240312214430.2923019-14-dw@davidwei.uk>
 <7752a08c-f55c-48d5-87f2-70f248381e48@kernel.dk>
 <4343cff7-37d9-4b78-af70-a0d7771b04bc@gmail.com>
 <c4871911-5cb6-4237-a0a3-001ecb8bd7e5@kernel.dk>
 <e646d731-dec9-4d2e-9e05-dbb9b1183a0b@gmail.com>
 <1e49ba1e-a2b0-4b11-8c36-85e7b9f95260@kernel.dk>
 <90c588ab-884e-401a-83fd-3d204a732acd@gmail.com>
 <4a613551-9a29-4e41-ae78-ad38bacaa009@kernel.dk>
 <d5ceb9c2-2fbb-4b82-9e9b-c482109acbf8@gmail.com>
From: Jens Axboe <axboe@kernel.dk>
In-Reply-To: <d5ceb9c2-2fbb-4b82-9e9b-c482109acbf8@gmail.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit

On 3/17/24 3:22 PM, Pavel Begunkov wrote:
> On 3/16/24 16:59, Jens Axboe wrote:
>> On 3/15/24 5:52 PM, Pavel Begunkov wrote:
>>> On 3/15/24 18:38, Jens Axboe wrote:
>>>> On 3/15/24 11:34 AM, Pavel Begunkov wrote:
>>>>> On 3/14/24 16:14, Jens Axboe wrote:
>>>>> [...]
>>>>>>>>> @@ -1053,6 +1058,85 @@ struct io_zc_rx_ifq *io_zc_verify_sock(struct io_kiocb *req,
>>>>>>>>>          return ifq;
>>>>>>>>>      }
>>>>>>>>>      +int io_recvzc_prep(struct io_kiocb *req, const struct io_uring_sqe *sqe)
>>>>>>>>> +{
>>>>>>>>> +    struct io_recvzc *zc = io_kiocb_to_cmd(req, struct io_recvzc);
>>>>>>>>> +
>>>>>>>>> +    /* non-iopoll defer_taskrun only */
>>>>>>>>> +    if (!req->ctx->task_complete)
>>>>>>>>> +        return -EINVAL;
>>>>>>>>
>>>>>>>> What's the reasoning behind this?
>>>>>>>
>>>>>>> CQ locking, see the comment a couple lines below
>>>>>>
>>>>>> My question here was more towards "is this something we want to do".
>>>>>> Maybe this is just a temporary work-around and it's nothing to discuss,
>>>>>> but I'm not sure we want to have opcodes only work on certain ring
>>>>>> setups.
>>>>>
>>>>> I don't think it's that unreasonable restricting it. It's hard to
>>>>> care about !DEFER_TASKRUN for net workloads, it makes CQE posting a bit
>>>>
>>>> I think there's a distinction between "not reasonable to support because
>>>> it's complicated/impossible to do so", and "we prefer not to support
>>>> it". I agree, as a developer it's hard to care about !DEFER_TASKRUN for
>>>> networking workloads, but as a user, they will just setup a default
>>>> queue until they wise up. And maybe this can be a good thing in that
>>>
>>> They'd still need to find a supported NIC and do all the other
>>> setup, comparably to that it doesn't add much trouble. And my
>>
>> Hopefully down the line, it'll work on more NICs,
> 
> I wouldn't hope all necessary features will be seen in consumer
> cards

Nah that would never be the case, but normal users aren't going to be
interested in zerocopy rx. If they are, then it's power users, and they
can pick an appropriate NIC rather than just rely on what's in their
laptop or desktop PC. But hopefully on the server production front,
there will be more NICs that support it. It's all driven by demand. If
it's a useful feature, then customers will ask for it.

>> and configuration will be less of a nightmare than it is now.
> 
> I'm already assuming steering will be taken care by the kernel,
> but you have to choose your nic, allocate an ifq, mmap a ring,
> and then you're getting scattered chunks instead of
> 
> recv((void *)one_large_buffer);
> 
> My point is that it requires more involvement from user by design.

For sure, it's more complicated than non-zerocopy, that's unavoidable.

>>> usual argument is that io_uring is a low-level api, it's expected
>>> that people interacting with it directly are experienced enough,
>>> expect to spend some time to make it right and likely library
>>> devs.
>>
>> Have you seen some of the code that has gone in to libraries for
>> io_uring support? I have, and I don't think that statement is true at
>> all for that side.
> 
> Well, some implementations are crappy, some are ok, some are
> learning and improving what they have.

Right, it wasn't a jab at them in general, it's natural to start
somewhere simple and then improve things as they go along. I don't
expect folks to have the level of knowledge of the internals that we do,
nor should they need to.

>> It should work out of the box even with a naive approach, while the best
>> approach may require some knowledge. At least I think that's the sanest
>> stance on that.
>>
>>>> they'd be nudged toward DEFER_TASKRUN, but I can also see some head
>>>> scratching when something just returns (the worst of all error codes)
>>>> -EINVAL when they attempt to use it.
>>>
>>> Yeah, we should try to find a better error code, and the check
>>> should migrate to ifq registration.
>>
>> Wasn't really a jab at the code in question, just more that -EINVAL is
>> the ubiqitious error code for all kinds of things and it's hard to
>> diagnose in general for a user. You just have to start guessing...
>>
>>>>> cleaner, and who knows where the single task part would become handy.
>>>>
>>>> But you can still take advantage of single task, since you know if
>>>> that's going to be true or not. It just can't be unconditional.
>>>>
>>>>> Thinking about ifq termination, which should better cancel and wait
>>>>> for all corresponding zc requests, it's should be easier without
>>>>> parallel threads. E.g. what if another thread is in the enter syscall
>>>>> using ifq, or running task_work and not cancellable. Then apart
>>>>> from (non-atomic) refcounting, we'd need to somehow wait for it,
>>>>> doing wake ups on the zc side, and so on.
>>>>
>>>> I don't know, not seeing a lot of strong arguments for making it
>>>> DEFER_TASKRUN only. My worry is that once we starting doing that, then
>>>> more will follow. And honestly I think that would be a shame.
>>>>
>>>> For ifq termination, surely these things are referenced, and termination
>>>> would need to wait for the last reference to drop? And if that isn't an
>>>> expected condition (it should not be), then a percpu ref would suffice.
>>>> Nobody cares if the teardown side is more expensive, as long as the fast
>>>> path is efficient.
>>>
>>> You can solve any of that, it's true, the question how much crap
>>> you'd need to add in hot paths and diffstat wise. Just take a look
>>> at what a nice function io_recvmsg() is together with its helpers
>>> like io_recvmsg_multishot().
>>
>> That is true, and I guess my real question is "what would it look like
>> if we supported !DEFER_TASKRUN". Which I think is a valid question.
>>
>>> The biggest concern is optimisations and quirks that we can't
>>> predict at the moment. DEFER_TASKRUN/SINGLE_ISSUER provide a simpler
>>> model, I'd rather keep recvzc simple than having tens of conditional
>>> optimisations with different execution flavours and contexts.
>>> Especially, since it can be implemented later, wouldn't work the
>>> other way around.
>>
>> Yes me too, and I'd hate to have two variants just because of that. But
>> comparing to eg io_recv() and helpers, it's really not that bad. Hence
>> my question on how much would it take, and how nasty would it be, to
>> support !DEFER_TASKRUN.
> 
> It might look bearable... at first, but when it stops on that?
> There will definitely be fixes and optimisations, whenever in my
> mind it's something that is not even needed. I guess I'm too
> traumatised by the amount of uapi binding features I wish I
> could axe out and never see again.

But that's real world though, particularly for the kernel. We'd all love
to restart things from scratch, and sometimes that'd lead to something
better which then down the line inevitably you'd love to redo again.

-- 
Jens Axboe


