Return-Path: <io-uring+bounces-1039-lists+io-uring=lfdr.de@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [147.75.199.223])
	by mail.lfdr.de (Postfix) with ESMTPS id A781387DAEE
	for <lists+io-uring@lfdr.de>; Sat, 16 Mar 2024 18:00:06 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id C5B2F1C20C93
	for <lists+io-uring@lfdr.de>; Sat, 16 Mar 2024 17:00:05 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 39AAE1BDD3;
	Sat, 16 Mar 2024 16:59:58 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel-dk.20230601.gappssmtp.com header.i=@kernel-dk.20230601.gappssmtp.com header.b="aY5c7Chg"
X-Original-To: io-uring@vger.kernel.org
Received: from mail-pf1-f177.google.com (mail-pf1-f177.google.com [209.85.210.177])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id CDAA31B960
	for <io-uring@vger.kernel.org>; Sat, 16 Mar 2024 16:59:54 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.210.177
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1710608398; cv=none; b=OEoskRrcZi07BAGVNSjmHp0MiItxN861/ieRLgx3tRspopm37IYJCs9x2RcvmFSp6eRAq9K+jECVlW68yUBuoHFrC3BUnQ9zitOYPzsY8BVL+a9wZBCIot6Lsdhd1cO6Sv/A4um6AxRZG1wBg0ZWNqBUhYQ3QSqQpliicugJiCg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1710608398; c=relaxed/simple;
	bh=L5E54FcKbDRqcU8ZTlQM/H5zN267yobnpBU5kmy9AIk=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=EHGJ/hnzHt6esetyNocIjGvOvZVmz193BYm6FCsP+CLPGLGLa27HouLC/RCYXnfEnsuuSKXNy+hsS84ai3dVQzwI36pjkrfxMckcPR+JgeZVMMzzQGpxbrBBUz5BhHJAB9Ecq1DtsuBkzG37noQfxhrArtT/hyMT0f5RYlV4pBs=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=kernel.dk; spf=pass smtp.mailfrom=kernel.dk; dkim=pass (2048-bit key) header.d=kernel-dk.20230601.gappssmtp.com header.i=@kernel-dk.20230601.gappssmtp.com header.b=aY5c7Chg; arc=none smtp.client-ip=209.85.210.177
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=kernel.dk
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=kernel.dk
Received: by mail-pf1-f177.google.com with SMTP id d2e1a72fcca58-6e6ca65edc9so882938b3a.0
        for <io-uring@vger.kernel.org>; Sat, 16 Mar 2024 09:59:54 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernel-dk.20230601.gappssmtp.com; s=20230601; t=1710608394; x=1711213194; darn=vger.kernel.org;
        h=content-transfer-encoding:in-reply-to:from:references:cc:to
         :content-language:subject:user-agent:mime-version:date:message-id
         :from:to:cc:subject:date:message-id:reply-to;
        bh=y1GIdlcJxdG4YtFEAdIwGXJrrGx7Kfdq8NmdWCG1dVA=;
        b=aY5c7ChgWzbylycGVcqOJw/YAZ+JyIRdrFCPpjqvIf0cb+1t+2TZjLbH8AgztSrwo/
         qWUXgA5CIbpcqfkDgWdnM9c58Mdhv4K4eX5AzKzauwFASmav78sXxUDqm7Vc3mQmVa9x
         6rbdXohEqlUHgNKMP/idh3Le/IrjD3P95FxqcGTGBwJIxbrcln/eQ1RWslnPd+IUbCJ/
         6/d9d6dGqsIPMDwzLYPN0VZDWIZWmgILe57yd8iqZ+qKOlNnnZ+4m4uzaQqcTzIASwmO
         yvE4Un/QSw1YsaC6IchtSY+h5sfum5Ujuhgyb75OZQjarMHtOI7qc1aHoz/q7HR12pSE
         It9g==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1710608394; x=1711213194;
        h=content-transfer-encoding:in-reply-to:from:references:cc:to
         :content-language:subject:user-agent:mime-version:date:message-id
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=y1GIdlcJxdG4YtFEAdIwGXJrrGx7Kfdq8NmdWCG1dVA=;
        b=NzdMk5SDlKjPRZ83f9VE7D3HwPeKyjn/YoCYzOUhfcKaQsLy2/Cef2q8B1wg2kbX/B
         lpnzOnIAYWpSBYesIxJea7F4D6mizxA/3AKve5wPwKH+7gvgXnku9NcXOFaeqDmo/R/k
         jCGwMbSBsD6Bf/QNMSQykryDk+NnTQozLKdr++cNM7DIDChWMrLY3M3jkwxou9Di055z
         J3axTWshcO7yuS6/f61Uqth1pUdhBMSoe7w/O+9FegZitZNSJJHshvfsgcl7E/pNvGs2
         wkLuAY7uBS8RTj6LCZaBTfTnN/7ZRnfSjjWQh7CUFEtxdGKfRTEjK/tacTY1zlZNmv9W
         X48w==
X-Forwarded-Encrypted: i=1; AJvYcCV5OZcTn0TxQjrx/R7gBRP5jpI2hnrUzxaFJRjj9+/w0cmm7HaOPAzx9PQPQs12kk7owlAPkRaGaVwMY+1N/7UL6jtpc9DvF/o=
X-Gm-Message-State: AOJu0Yxe+kVSQrBsj2yByFuIHh9mVsNH56E07ghc04Nn3Ptsz25AER9X
	5jNCUchdoaSXM+Yq9+r55TWC1yktF6XR5MuDjfC0uptkxXYG8zEWuuyBTuBqC8w=
X-Google-Smtp-Source: AGHT+IF9k7wYPR8lnQctGGvzP1ehsITWWaLQGt+1f8KHDmDYdfm2KnwCv+FAe35PlEd/t8r7i8mVhA==
X-Received: by 2002:a05:6a21:3381:b0:1a3:5c74:62ae with SMTP id yy1-20020a056a21338100b001a35c7462aemr1232334pzb.1.1710608393978;
        Sat, 16 Mar 2024 09:59:53 -0700 (PDT)
Received: from [192.168.1.150] ([198.8.77.194])
        by smtp.gmail.com with ESMTPSA id n29-20020a634d5d000000b005d6a0b2efb3sm4303093pgl.21.2024.03.16.09.59.52
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Sat, 16 Mar 2024 09:59:53 -0700 (PDT)
Message-ID: <4a613551-9a29-4e41-ae78-ad38bacaa009@kernel.dk>
Date: Sat, 16 Mar 2024 10:59:51 -0600
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
From: Jens Axboe <axboe@kernel.dk>
In-Reply-To: <90c588ab-884e-401a-83fd-3d204a732acd@gmail.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit

On 3/15/24 5:52 PM, Pavel Begunkov wrote:
> On 3/15/24 18:38, Jens Axboe wrote:
>> On 3/15/24 11:34 AM, Pavel Begunkov wrote:
>>> On 3/14/24 16:14, Jens Axboe wrote:
>>> [...]
>>>>>>> @@ -1053,6 +1058,85 @@ struct io_zc_rx_ifq *io_zc_verify_sock(struct io_kiocb *req,
>>>>>>>         return ifq;
>>>>>>>     }
>>>>>>>     +int io_recvzc_prep(struct io_kiocb *req, const struct io_uring_sqe *sqe)
>>>>>>> +{
>>>>>>> +    struct io_recvzc *zc = io_kiocb_to_cmd(req, struct io_recvzc);
>>>>>>> +
>>>>>>> +    /* non-iopoll defer_taskrun only */
>>>>>>> +    if (!req->ctx->task_complete)
>>>>>>> +        return -EINVAL;
>>>>>>
>>>>>> What's the reasoning behind this?
>>>>>
>>>>> CQ locking, see the comment a couple lines below
>>>>
>>>> My question here was more towards "is this something we want to do".
>>>> Maybe this is just a temporary work-around and it's nothing to discuss,
>>>> but I'm not sure we want to have opcodes only work on certain ring
>>>> setups.
>>>
>>> I don't think it's that unreasonable restricting it. It's hard to
>>> care about !DEFER_TASKRUN for net workloads, it makes CQE posting a bit
>>
>> I think there's a distinction between "not reasonable to support because
>> it's complicated/impossible to do so", and "we prefer not to support
>> it". I agree, as a developer it's hard to care about !DEFER_TASKRUN for
>> networking workloads, but as a user, they will just setup a default
>> queue until they wise up. And maybe this can be a good thing in that
> 
> They'd still need to find a supported NIC and do all the other
> setup, comparably to that it doesn't add much trouble. And my

Hopefully down the line, it'll work on more NICs, and configuration will
be less of a nightmare than it is now.

> usual argument is that io_uring is a low-level api, it's expected
> that people interacting with it directly are experienced enough,
> expect to spend some time to make it right and likely library
> devs.

Have you seen some of the code that has gone in to libraries for
io_uring support? I have, and I don't think that statement is true at
all for that side.

It should work out of the box even with a naive approach, while the best
approach may require some knowledge. At least I think that's the sanest
stance on that.

>> they'd be nudged toward DEFER_TASKRUN, but I can also see some head
>> scratching when something just returns (the worst of all error codes)
>> -EINVAL when they attempt to use it.
> 
> Yeah, we should try to find a better error code, and the check
> should migrate to ifq registration.

Wasn't really a jab at the code in question, just more that -EINVAL is
the ubiqitious error code for all kinds of things and it's hard to
diagnose in general for a user. You just have to start guessing...

>>> cleaner, and who knows where the single task part would become handy.
>>
>> But you can still take advantage of single task, since you know if
>> that's going to be true or not. It just can't be unconditional.
>>
>>> Thinking about ifq termination, which should better cancel and wait
>>> for all corresponding zc requests, it's should be easier without
>>> parallel threads. E.g. what if another thread is in the enter syscall
>>> using ifq, or running task_work and not cancellable. Then apart
>>> from (non-atomic) refcounting, we'd need to somehow wait for it,
>>> doing wake ups on the zc side, and so on.
>>
>> I don't know, not seeing a lot of strong arguments for making it
>> DEFER_TASKRUN only. My worry is that once we starting doing that, then
>> more will follow. And honestly I think that would be a shame.
>>
>> For ifq termination, surely these things are referenced, and termination
>> would need to wait for the last reference to drop? And if that isn't an
>> expected condition (it should not be), then a percpu ref would suffice.
>> Nobody cares if the teardown side is more expensive, as long as the fast
>> path is efficient.
> 
> You can solve any of that, it's true, the question how much crap
> you'd need to add in hot paths and diffstat wise. Just take a look
> at what a nice function io_recvmsg() is together with its helpers
> like io_recvmsg_multishot().

That is true, and I guess my real question is "what would it look like
if we supported !DEFER_TASKRUN". Which I think is a valid question.

> The biggest concern is optimisations and quirks that we can't
> predict at the moment. DEFER_TASKRUN/SINGLE_ISSUER provide a simpler
> model, I'd rather keep recvzc simple than having tens of conditional
> optimisations with different execution flavours and contexts.
> Especially, since it can be implemented later, wouldn't work the
> other way around.

Yes me too, and I'd hate to have two variants just because of that. But
comparing to eg io_recv() and helpers, it's really not that bad. Hence
my question on how much would it take, and how nasty would it be, to
support !DEFER_TASKRUN.

-- 
Jens Axboe


