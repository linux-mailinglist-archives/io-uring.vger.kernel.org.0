Return-Path: <io-uring+bounces-1050-lists+io-uring=lfdr.de@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [IPv6:2604:1380:4601:e00::3])
	by mail.lfdr.de (Postfix) with ESMTPS id B3E8E87E043
	for <lists+io-uring@lfdr.de>; Sun, 17 Mar 2024 22:24:07 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id 2C6CF1F21BED
	for <lists+io-uring@lfdr.de>; Sun, 17 Mar 2024 21:24:07 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 4E1F6208A4;
	Sun, 17 Mar 2024 21:24:04 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="HRCZBNV4"
X-Original-To: io-uring@vger.kernel.org
Received: from mail-ej1-f48.google.com (mail-ej1-f48.google.com [209.85.218.48])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 70BAB208A0;
	Sun, 17 Mar 2024 21:24:02 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.218.48
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1710710644; cv=none; b=qO0AAAf/DUa5ZdAvtXldipAp6sSyVvoRvoTsiVw6KIm4A4RantadhphAMT+Wg94U4zQugIxch45A1R63+jYsV+vfVU8wTibkIH6JlE6qr1x11p/BpvB4lgjglqWHwj7ItPsShPqcTZmgr9t1FCoqqXJoreezaYutoDan2D/UuIQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1710710644; c=relaxed/simple;
	bh=JImlRwkOFe13jFffeZcKf4MJA+RzZ2nk4xGQMDWRNRk=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=dnENqZ78N0RN4VCKS2OmRxF/nKShl5jD8BfuqIE+4j25GMLfOslffK3vaCHXvlB0QXP2gdOa8wVwcNIDJ8as8wnySISgSSnzXGiEA04zX4644OexvvzvGwyU55o5/hA8amcMH0SD7SLpp8D/9iUBlVcNrzQRVq/VqePAViccs3g=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=HRCZBNV4; arc=none smtp.client-ip=209.85.218.48
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Received: by mail-ej1-f48.google.com with SMTP id a640c23a62f3a-a4644bde1d4so488598266b.3;
        Sun, 17 Mar 2024 14:24:02 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1710710641; x=1711315441; darn=vger.kernel.org;
        h=content-transfer-encoding:in-reply-to:from:references:cc:to
         :content-language:subject:user-agent:mime-version:date:message-id
         :from:to:cc:subject:date:message-id:reply-to;
        bh=6RUYP0GHl7tm3Mga3DjOfW1WDbCxoCJCtfJ1ECYKcWY=;
        b=HRCZBNV4vxN/wL/Y62vinJbYO50OQbncvXwCcUo/T+h2OEHLfI8YCk1f09tgqVmwET
         gE9n3IpuatLExyTQ46y51wR6zFzDBj5Rmln5m69FkgIbWfuRmf73QPeavNFIxSPEnFBH
         0a/a6M6tD5a34O4iCkp645uryFJlKGiQ4oh4aGL/0PDksDwqzxqC7Ro+6zsPM/4zO3yu
         0/1OyzjPWaxjp/snoXjRPLRsXl2uvo6BI+n5bc5MhxnyRLI32ZH/oXYo5t/b2EV1H1jt
         +0NtXwHhtj6qZdaSr+aZWOJOHC+0Wc4jyAHQz/a3Oz4A8CobctPCmlPrwt30c8sZBfAF
         0c7g==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1710710641; x=1711315441;
        h=content-transfer-encoding:in-reply-to:from:references:cc:to
         :content-language:subject:user-agent:mime-version:date:message-id
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=6RUYP0GHl7tm3Mga3DjOfW1WDbCxoCJCtfJ1ECYKcWY=;
        b=MORaUKu5hmS9Aw+rzb78rXOowJFwthPBve1sYpSoRAYHORz5c5Ib6Rn2w5fcmcj09t
         0yOKHmqHPpR2VLEVH3gvxZbIthS5RWqdi1uNzZIcV5rzC0TXdVuigDNNWrhxXazWx7sy
         h6ZRhVFiXHe0i1rgQitbOnUy0gv2/J/q7eWB1zLQdZHbAuH7Dk107Ih75GCQ9hMhgfk4
         5knnVxf3XXPAErXkrv/zfqYlWH6en6K3XkOcEXW8HSwraTtz7zFLRylg71naV6i0iU4A
         MBM/Ueu0NguU5WxoDsaHzywlowh4ItNS9L5p2r1wqlvdwviudHAiX1BEo1ULEGcXz2H5
         ePcQ==
X-Forwarded-Encrypted: i=1; AJvYcCWCPdLHOKcuAJrs3AqZEQrmoYjWHm8GcI/TrWI2EBoDgOqtI+4Zu7VPW5qdBK6v5h6woZj7iKHOERBwPPfzV3HJfL7hbeuGTym8CLatOoTnG2frqoiXbUmPOU1qRUD6q4k=
X-Gm-Message-State: AOJu0Yz8VihLye+Q//81GkgVB6on4Ym/fTJXCu+2Vwpoiqbj5pqz+5Ud
	7ffjONDqFrSjNlMFuEt2oKSqn2Qr7qFrOZjLcxXpY3ARRfvduCOj
X-Google-Smtp-Source: AGHT+IExWvTxZ0NIOlrml3ZfbIIeI/2UI2jo4KMSfpFxlc79HgB13KJW8ga9iG+VMGrQuZIOg9Aplw==
X-Received: by 2002:a17:906:68db:b0:a46:1f0f:31b5 with SMTP id y27-20020a17090668db00b00a461f0f31b5mr4316582ejr.57.1710710640568;
        Sun, 17 Mar 2024 14:24:00 -0700 (PDT)
Received: from [192.168.8.100] ([85.255.232.181])
        by smtp.gmail.com with ESMTPSA id bf8-20020a170907098800b00a46bcfe4f16sm515970ejc.37.2024.03.17.14.23.59
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Sun, 17 Mar 2024 14:24:00 -0700 (PDT)
Message-ID: <d5ceb9c2-2fbb-4b82-9e9b-c482109acbf8@gmail.com>
Date: Sun, 17 Mar 2024 21:22:46 +0000
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
 <90c588ab-884e-401a-83fd-3d204a732acd@gmail.com>
 <4a613551-9a29-4e41-ae78-ad38bacaa009@kernel.dk>
From: Pavel Begunkov <asml.silence@gmail.com>
In-Reply-To: <4a613551-9a29-4e41-ae78-ad38bacaa009@kernel.dk>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit

On 3/16/24 16:59, Jens Axboe wrote:
> On 3/15/24 5:52 PM, Pavel Begunkov wrote:
>> On 3/15/24 18:38, Jens Axboe wrote:
>>> On 3/15/24 11:34 AM, Pavel Begunkov wrote:
>>>> On 3/14/24 16:14, Jens Axboe wrote:
>>>> [...]
>>>>>>>> @@ -1053,6 +1058,85 @@ struct io_zc_rx_ifq *io_zc_verify_sock(struct io_kiocb *req,
>>>>>>>>          return ifq;
>>>>>>>>      }
>>>>>>>>      +int io_recvzc_prep(struct io_kiocb *req, const struct io_uring_sqe *sqe)
>>>>>>>> +{
>>>>>>>> +    struct io_recvzc *zc = io_kiocb_to_cmd(req, struct io_recvzc);
>>>>>>>> +
>>>>>>>> +    /* non-iopoll defer_taskrun only */
>>>>>>>> +    if (!req->ctx->task_complete)
>>>>>>>> +        return -EINVAL;
>>>>>>>
>>>>>>> What's the reasoning behind this?
>>>>>>
>>>>>> CQ locking, see the comment a couple lines below
>>>>>
>>>>> My question here was more towards "is this something we want to do".
>>>>> Maybe this is just a temporary work-around and it's nothing to discuss,
>>>>> but I'm not sure we want to have opcodes only work on certain ring
>>>>> setups.
>>>>
>>>> I don't think it's that unreasonable restricting it. It's hard to
>>>> care about !DEFER_TASKRUN for net workloads, it makes CQE posting a bit
>>>
>>> I think there's a distinction between "not reasonable to support because
>>> it's complicated/impossible to do so", and "we prefer not to support
>>> it". I agree, as a developer it's hard to care about !DEFER_TASKRUN for
>>> networking workloads, but as a user, they will just setup a default
>>> queue until they wise up. And maybe this can be a good thing in that
>>
>> They'd still need to find a supported NIC and do all the other
>> setup, comparably to that it doesn't add much trouble. And my
> 
> Hopefully down the line, it'll work on more NICs,

I wouldn't hope all necessary features will be seen in consumer
cards

> and configuration will be less of a nightmare than it is now.

I'm already assuming steering will be taken care by the kernel,
but you have to choose your nic, allocate an ifq, mmap a ring,
and then you're getting scattered chunks instead of

recv((void *)one_large_buffer);

My point is that it requires more involvement from user by design.
  
>> usual argument is that io_uring is a low-level api, it's expected
>> that people interacting with it directly are experienced enough,
>> expect to spend some time to make it right and likely library
>> devs.
> 
> Have you seen some of the code that has gone in to libraries for
> io_uring support? I have, and I don't think that statement is true at
> all for that side.

Well, some implementations are crappy, some are ok, some are
learning and improving what they have.

> 
> It should work out of the box even with a naive approach, while the best
> approach may require some knowledge. At least I think that's the sanest
> stance on that.
> 
>>> they'd be nudged toward DEFER_TASKRUN, but I can also see some head
>>> scratching when something just returns (the worst of all error codes)
>>> -EINVAL when they attempt to use it.
>>
>> Yeah, we should try to find a better error code, and the check
>> should migrate to ifq registration.
> 
> Wasn't really a jab at the code in question, just more that -EINVAL is
> the ubiqitious error code for all kinds of things and it's hard to
> diagnose in general for a user. You just have to start guessing...
> 
>>>> cleaner, and who knows where the single task part would become handy.
>>>
>>> But you can still take advantage of single task, since you know if
>>> that's going to be true or not. It just can't be unconditional.
>>>
>>>> Thinking about ifq termination, which should better cancel and wait
>>>> for all corresponding zc requests, it's should be easier without
>>>> parallel threads. E.g. what if another thread is in the enter syscall
>>>> using ifq, or running task_work and not cancellable. Then apart
>>>> from (non-atomic) refcounting, we'd need to somehow wait for it,
>>>> doing wake ups on the zc side, and so on.
>>>
>>> I don't know, not seeing a lot of strong arguments for making it
>>> DEFER_TASKRUN only. My worry is that once we starting doing that, then
>>> more will follow. And honestly I think that would be a shame.
>>>
>>> For ifq termination, surely these things are referenced, and termination
>>> would need to wait for the last reference to drop? And if that isn't an
>>> expected condition (it should not be), then a percpu ref would suffice.
>>> Nobody cares if the teardown side is more expensive, as long as the fast
>>> path is efficient.
>>
>> You can solve any of that, it's true, the question how much crap
>> you'd need to add in hot paths and diffstat wise. Just take a look
>> at what a nice function io_recvmsg() is together with its helpers
>> like io_recvmsg_multishot().
> 
> That is true, and I guess my real question is "what would it look like
> if we supported !DEFER_TASKRUN". Which I think is a valid question.
> 
>> The biggest concern is optimisations and quirks that we can't
>> predict at the moment. DEFER_TASKRUN/SINGLE_ISSUER provide a simpler
>> model, I'd rather keep recvzc simple than having tens of conditional
>> optimisations with different execution flavours and contexts.
>> Especially, since it can be implemented later, wouldn't work the
>> other way around.
> 
> Yes me too, and I'd hate to have two variants just because of that. But
> comparing to eg io_recv() and helpers, it's really not that bad. Hence
> my question on how much would it take, and how nasty would it be, to
> support !DEFER_TASKRUN.

It might look bearable... at first, but when it stops on that?
There will definitely be fixes and optimisations, whenever in my
mind it's something that is not even needed. I guess I'm too
traumatised by the amount of uapi binding features I wish I
could axe out and never see again.

-- 
Pavel Begunkov

