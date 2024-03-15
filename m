Return-Path: <io-uring+bounces-1002-lists+io-uring=lfdr.de@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [IPv6:2604:1380:4601:e00::3])
	by mail.lfdr.de (Postfix) with ESMTPS id F071487D772
	for <lists+io-uring@lfdr.de>; Sat, 16 Mar 2024 00:53:23 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id 686F41F23DF1
	for <lists+io-uring@lfdr.de>; Fri, 15 Mar 2024 23:53:23 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id BCA565A799;
	Fri, 15 Mar 2024 23:53:11 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="JChpunwh"
X-Original-To: io-uring@vger.kernel.org
Received: from mail-wm1-f47.google.com (mail-wm1-f47.google.com [209.85.128.47])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D6A6E5A783;
	Fri, 15 Mar 2024 23:53:09 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.128.47
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1710546791; cv=none; b=H1nSX0dPJVpAToyUsVoXNsUXQyHiV3skLJq2U0XzOmg2jb81Mw5Yf9bifr/URcJHTO5s4j1dxnmRTE4A89gBBd6NbbCPr/cwpVs6nkNaOI50IPVaVgOlAxgjx6krkOJUDM6chb5z3ZSSMv2KdTq7SFjR4+KTJFOdP+Oa/4HEVvk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1710546791; c=relaxed/simple;
	bh=jlS6ttdWOKZxHZQWF+FsukwDKbHbtqK61QMUL1AwpnY=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=IzYz66XWZIYkdIrhjniN+jQ7FVF2hnAxZR4bwlSrxcp9m9hPAyTYZLc9ZiNpsdNoVUgQkNO1bAlYmWfKUGFiHdP9/VuCiMfF8oFMqPEFfT6+bk0nCibjC+KyDLwqaYHgvmaQu098ry2+HPmX1mYeLMjdqE6e8mQ8w3zFF71l54U=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=JChpunwh; arc=none smtp.client-ip=209.85.128.47
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Received: by mail-wm1-f47.google.com with SMTP id 5b1f17b1804b1-413f76ff0daso14459585e9.0;
        Fri, 15 Mar 2024 16:53:09 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1710546788; x=1711151588; darn=vger.kernel.org;
        h=content-transfer-encoding:in-reply-to:from:references:cc:to
         :content-language:subject:user-agent:mime-version:date:message-id
         :from:to:cc:subject:date:message-id:reply-to;
        bh=epK4WYCGiNTnRYrRFB2D6l93vkHkbCGygUuX/fPW50s=;
        b=JChpunwhdWscsgHuFZM3oHksADkhr4OKqwAit/416C+4xf0t6G3vkPE8YRS9JETZaL
         3udU1Cr618xGuGXsDPSlYwKxkzdnIiGgVy5gadnMhCLYD6ckL9ynPWn0N4QIZz3vg7ED
         8hELCsWQNH75YbrazqIHusNTWrm41ewoyWQCTKGlIVauxGOy53ZoS62I+SokZfNuF1pZ
         RcIf/acth1LrXS5behYXkjIApbdj/VbiZ9ctWKc+i0bU/8tSvFMghbwJmifeT96GSw4c
         oXC/jFPYXdmMZDfFjR/okTIyZeczB6CHY4uCu+Yaiubso1KOxFIuyvMC/d5ZERCmFkbk
         8wNg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1710546788; x=1711151588;
        h=content-transfer-encoding:in-reply-to:from:references:cc:to
         :content-language:subject:user-agent:mime-version:date:message-id
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=epK4WYCGiNTnRYrRFB2D6l93vkHkbCGygUuX/fPW50s=;
        b=vTAosjPGdiU3H1I5YJZhBLJRB2Y3wrRT5IpVoJBm1puVJtNtrq+3wHSdBQ7jN9f8PQ
         ISxOI+eK6QvqJ9Xe9QCW3uy6oOEmkDmL/WWhMWvA/xo9e2LzD58BrGy2n87ZsWGFCHv/
         FWO8c90kpDcCumAKdbQ7BP5MkrIgVYHkquivaI52oFpyNibKDj2dGUoERQMM1ac4+boJ
         3267uBuq4n2/2IlhXEfGQejrGyzh18S16DgtaUffV7PCMP74es8nZ50S/ahs0K75SeSX
         wOXFfWTCJaukkXvV0RaTgvPXX+7VDPDix/FkOp33B9As/mjxZET4odWJU5uRTP0oBR0y
         ulyA==
X-Forwarded-Encrypted: i=1; AJvYcCW4Nni/wFzK6DzeRucnm1m4fY23vRoHZCGM64GTGJOMqVSvDUkS8KCuGbWDoypUQHQ97wOUsk28ge1pN9geVR+LOfKMzGuLHz2FPyfCskIxzLcz56q+EOZIXq2zc47LYlQ=
X-Gm-Message-State: AOJu0YwiY/BhStfkvv4IQbGgycCGauLMVafqbfcnGmhId9d5lUXpPLtu
	pqog1IsjT1rAKeM5Cd/hax2RtiMtTDWgNd00QVh0zsgyTK/6jmbfWMMUAYak
X-Google-Smtp-Source: AGHT+IFFqXJ6RvlxbE88iSLgjlojPASVxfvT81XvV33itm3sOALmfLnzMpeG99czY+V4E2HeeDIRCA==
X-Received: by 2002:a05:600c:1c14:b0:413:fd90:3d08 with SMTP id j20-20020a05600c1c1400b00413fd903d08mr3785863wms.41.1710546787906;
        Fri, 15 Mar 2024 16:53:07 -0700 (PDT)
Received: from [192.168.8.100] ([185.69.144.99])
        by smtp.gmail.com with ESMTPSA id jg28-20020a05600ca01c00b0041401fbe446sm3062923wmb.11.2024.03.15.16.53.07
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Fri, 15 Mar 2024 16:53:07 -0700 (PDT)
Message-ID: <90c588ab-884e-401a-83fd-3d204a732acd@gmail.com>
Date: Fri, 15 Mar 2024 23:52:02 +0000
Precedence: bulk
X-Mailing-List: io-uring@vger.kernel.org
List-Id: <io-uring.vger.kernel.org>
List-Subscribe: <mailto:io-uring+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:io-uring+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [RFC PATCH v4 13/16] io_uring: add io_recvzc request
Content-Language: en-US
To: Jens Axboe <axboe@kernel.dk>, David Wei <dw@davidwei.uk>,
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
From: Pavel Begunkov <asml.silence@gmail.com>
In-Reply-To: <1e49ba1e-a2b0-4b11-8c36-85e7b9f95260@kernel.dk>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit

On 3/15/24 18:38, Jens Axboe wrote:
> On 3/15/24 11:34 AM, Pavel Begunkov wrote:
>> On 3/14/24 16:14, Jens Axboe wrote:
>> [...]
>>>>>> @@ -1053,6 +1058,85 @@ struct io_zc_rx_ifq *io_zc_verify_sock(struct io_kiocb *req,
>>>>>>         return ifq;
>>>>>>     }
>>>>>>     +int io_recvzc_prep(struct io_kiocb *req, const struct io_uring_sqe *sqe)
>>>>>> +{
>>>>>> +    struct io_recvzc *zc = io_kiocb_to_cmd(req, struct io_recvzc);
>>>>>> +
>>>>>> +    /* non-iopoll defer_taskrun only */
>>>>>> +    if (!req->ctx->task_complete)
>>>>>> +        return -EINVAL;
>>>>>
>>>>> What's the reasoning behind this?
>>>>
>>>> CQ locking, see the comment a couple lines below
>>>
>>> My question here was more towards "is this something we want to do".
>>> Maybe this is just a temporary work-around and it's nothing to discuss,
>>> but I'm not sure we want to have opcodes only work on certain ring
>>> setups.
>>
>> I don't think it's that unreasonable restricting it. It's hard to
>> care about !DEFER_TASKRUN for net workloads, it makes CQE posting a bit
> 
> I think there's a distinction between "not reasonable to support because
> it's complicated/impossible to do so", and "we prefer not to support
> it". I agree, as a developer it's hard to care about !DEFER_TASKRUN for
> networking workloads, but as a user, they will just setup a default
> queue until they wise up. And maybe this can be a good thing in that

They'd still need to find a supported NIC and do all the other
setup, comparably to that it doesn't add much trouble. And my
usual argument is that io_uring is a low-level api, it's expected
that people interacting with it directly are experienced enough,
expect to spend some time to make it right and likely library
devs.

> they'd be nudged toward DEFER_TASKRUN, but I can also see some head
> scratching when something just returns (the worst of all error codes)
> -EINVAL when they attempt to use it.

Yeah, we should try to find a better error code, and the check
should migrate to ifq registration.

>> cleaner, and who knows where the single task part would become handy.
> 
> But you can still take advantage of single task, since you know if
> that's going to be true or not. It just can't be unconditional.
> 
>> Thinking about ifq termination, which should better cancel and wait
>> for all corresponding zc requests, it's should be easier without
>> parallel threads. E.g. what if another thread is in the enter syscall
>> using ifq, or running task_work and not cancellable. Then apart
>> from (non-atomic) refcounting, we'd need to somehow wait for it,
>> doing wake ups on the zc side, and so on.
> 
> I don't know, not seeing a lot of strong arguments for making it
> DEFER_TASKRUN only. My worry is that once we starting doing that, then
> more will follow. And honestly I think that would be a shame.
> 
> For ifq termination, surely these things are referenced, and termination
> would need to wait for the last reference to drop? And if that isn't an
> expected condition (it should not be), then a percpu ref would suffice.
> Nobody cares if the teardown side is more expensive, as long as the fast
> path is efficient.

You can solve any of that, it's true, the question how much crap
you'd need to add in hot paths and diffstat wise. Just take a look
at what a nice function io_recvmsg() is together with its helpers
like io_recvmsg_multishot().

The biggest concern is optimisations and quirks that we can't
predict at the moment. DEFER_TASKRUN/SINGLE_ISSUER provide a simpler
model, I'd rather keep recvzc simple than having tens of conditional
optimisations with different execution flavours and contexts.
Especially, since it can be implemented later, wouldn't work the
other way around.

> Dunno - anyway, for now let's just leave it as-is, it's just something
> to consider once we get closer to a more finished patchset.
> 
>> The CQ side is easy to support though, put conditional locking
>> around the posting like fill/post_cqe does with the todays
>> patchset.
> 
> Yep, which is one of the reasons why I was hopeful this could go away!
> 

-- 
Pavel Begunkov

