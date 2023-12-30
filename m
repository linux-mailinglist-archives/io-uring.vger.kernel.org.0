Return-Path: <io-uring+bounces-366-lists+io-uring=lfdr.de@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [IPv6:2604:1380:45d1:ec00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 0CA7882088C
	for <lists+io-uring@lfdr.de>; Sat, 30 Dec 2023 22:17:56 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id 398CF1C21E03
	for <lists+io-uring@lfdr.de>; Sat, 30 Dec 2023 21:17:55 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 421CAC2C5;
	Sat, 30 Dec 2023 21:17:43 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="hP7yVnZy"
X-Original-To: io-uring@vger.kernel.org
Received: from mail-ed1-f52.google.com (mail-ed1-f52.google.com [209.85.208.52])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 68C30E555;
	Sat, 30 Dec 2023 21:17:41 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Received: by mail-ed1-f52.google.com with SMTP id 4fb4d7f45d1cf-555aa7fddeaso2205707a12.2;
        Sat, 30 Dec 2023 13:17:41 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1703971059; x=1704575859; darn=vger.kernel.org;
        h=content-transfer-encoding:in-reply-to:from:references:cc:to
         :content-language:subject:user-agent:mime-version:date:message-id
         :from:to:cc:subject:date:message-id:reply-to;
        bh=9ifBVNIGDNmdHiahBIa2ujG1TJ47BtAvBSmm7JJXvfc=;
        b=hP7yVnZyS8G0Rg7xVcGi7cQ7w2jucuq6kg2kO9qcl7Gq4t0oOq1CiGYghwP6e5yQ81
         OOVYyItFMjUa77Edv4ZRFIX5K4tYyWIrMSgAOGj4BNUnHWh0aWA/T388QR3OoFLKHlvC
         GVt8ni1SvQrnusnDJmwWdtg4kgs8AFVlONQsZuJg9L1HIG6sE7Iq9cWQHQA6Da11nopA
         UTibKKZ2lprGw8i8p06d+4QaE3XlgCCVXFg+T6HYly7imR/DWXkviv60DGRPZzKQneuC
         OY6W6wWkr/mDODtooxvFdNtOYQEZ2i2Pui3tckW1DEcuq6w3B9IaSNb7ufuQNbH5/R8t
         6oiQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1703971059; x=1704575859;
        h=content-transfer-encoding:in-reply-to:from:references:cc:to
         :content-language:subject:user-agent:mime-version:date:message-id
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=9ifBVNIGDNmdHiahBIa2ujG1TJ47BtAvBSmm7JJXvfc=;
        b=gr39ynV4PnXoJ4uen8UP9VO7ZytYNVgi8kZe8MEX+8NCi3kM2Y7TF2kyzL0FNRR80a
         Rjq6z9q+h/vJhwQg4Lp4rOF+keJdduO1AJFNmnq4B+T1Y0+B0vj581A39QFmjc/FBOWg
         yj55vra8lbh7dWR+K0x9Fvsq4abN8gVlukAlWM2w4a7XFtVNAWhrF1XnRLgp1gCVDKDL
         wQlNyLZys/j5yQvyVPj7O0bgKvJJsCXNandyKwv5l32QarcrFLeVsbZVTbMS83iqSHU9
         Tu41EzyYFT7AQ5I3rgrGaTOcW9hYscdgPWvcSM0fbW5Bxo7zuz75gy+WVrxP+hiHFiHb
         wrgw==
X-Gm-Message-State: AOJu0Yw4G+j7LMGhBs160eqA2t9Mwy1XIveyiLs3LcE4U57XrkCnZFXS
	md8jSIq0CF+OXOVlu38qT6M=
X-Google-Smtp-Source: AGHT+IFq/xwhynCPcB25Xd9Nm6tTaGg1dA9dqvCEES0ds9twnM1m5/lTLLlWj/n+SczJqAFboaLJEw==
X-Received: by 2002:a17:906:5184:b0:a26:8eb9:8a28 with SMTP id y4-20020a170906518400b00a268eb98a28mr6070825ejk.24.1703971059470;
        Sat, 30 Dec 2023 13:17:39 -0800 (PST)
Received: from [192.168.8.100] ([185.69.144.139])
        by smtp.gmail.com with ESMTPSA id su24-20020a17090703d800b00a26ab41d0f7sm8898383ejb.26.2023.12.30.13.17.38
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Sat, 30 Dec 2023 13:17:39 -0800 (PST)
Message-ID: <20536da2-57e1-4cf3-b040-bd456b86111a@gmail.com>
Date: Sat, 30 Dec 2023 21:15:53 +0000
Precedence: bulk
X-Mailing-List: io-uring@vger.kernel.org
List-Id: <io-uring.vger.kernel.org>
List-Subscribe: <mailto:io-uring+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:io-uring+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [RFC PATCH v3 15/20] io_uring: add io_recvzc request
Content-Language: en-US
To: Jens Axboe <axboe@kernel.dk>, David Wei <dw@davidwei.uk>,
 io-uring@vger.kernel.org, netdev@vger.kernel.org
Cc: Jakub Kicinski <kuba@kernel.org>, Paolo Abeni <pabeni@redhat.com>,
 "David S. Miller" <davem@davemloft.net>, Eric Dumazet <edumazet@google.com>,
 Jesper Dangaard Brouer <hawk@kernel.org>, David Ahern <dsahern@kernel.org>,
 Mina Almasry <almasrymina@google.com>
References: <20231219210357.4029713-1-dw@davidwei.uk>
 <20231219210357.4029713-16-dw@davidwei.uk>
 <8a447c17-92a1-40b7-baa7-4098c7701ee9@kernel.dk>
 <bef81787-bb85-441f-9350-c915572ab82e@gmail.com>
 <7d39e650-0879-45f1-b76c-be111b9ee38e@kernel.dk>
 <6042681c-fef6-456b-8c65-e0505c6b4abb@gmail.com>
 <9d715976-6f27-4291-a2b4-f34b1bbeaf77@kernel.dk>
From: Pavel Begunkov <asml.silence@gmail.com>
In-Reply-To: <9d715976-6f27-4291-a2b4-f34b1bbeaf77@kernel.dk>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit

On 12/21/23 21:32, Jens Axboe wrote:
> On 12/21/23 11:59 AM, Pavel Begunkov wrote:
>> On 12/20/23 18:09, Jens Axboe wrote:
>>> On 12/20/23 10:04 AM, Pavel Begunkov wrote:
>>>> On 12/20/23 16:27, Jens Axboe wrote:
>>>>> On 12/19/23 2:03 PM, David Wei wrote:
>>>>>> diff --git a/io_uring/net.c b/io_uring/net.c
>>>>>> index 454ba301ae6b..7a2aadf6962c 100644
>>>>>> --- a/io_uring/net.c
>>>>>> +++ b/io_uring/net.c
[...]
>>>>>> +    if (issue_flags & IO_URING_F_UNLOCKED)
>>>>>> +        return -EAGAIN;
>>>>>
>>>>> This seems odd, why? If we're called with IO_URING_F_UNLOCKED set, then
>>>>
>>>> It's my addition, let me explain.
>>>>
>>>> io_recvzc() -> io_zc_rx_recv() -> ... -> zc_rx_recv_frag()
>>>>
>>>> This chain posts completions to a buffer completion queue, and
>>>> we don't want extra locking to share it with io-wq threads. In
>>>> some sense it's quite similar to the CQ locking, considering
>>>> we restrict zc to DEFER_TASKRUN. And doesn't change anything
>>>> anyway because multishot cannot post completions from io-wq
>>>> and are executed from the poll callback in task work.
>>>>
>>>>> it's from io-wq. And returning -EAGAIN there will not do anything to
>>>>
>>>> It will. It's supposed to just requeue for polling (it's not
>>>> IOPOLL to keep retrying -EAGAIN), just like multishots do.
>>>
>>> It definitely needs a good comment, as it's highly non-obvious when
>>> reading the code!
>>>
>>>> Double checking the code, it can actually terminate the request,
>>>> which doesn't make much difference for us because multishots
>>>> should normally never end up in io-wq anyway, but I guess we
>>>> can improve it a liitle bit.
>>>
>>> Right, assumptions seems to be that -EAGAIN will lead to poll arm, which
>>> seems a bit fragile.
>>
>> The main assumption is that io-wq will eventually leave the
>> request alone and push it somewhere else, either queuing for
>> polling or terminating, which is more than reasonable. I'd
> 
> But surely you don't want it terminated from here? It seems like a very
> odd choice. As it stands, if you end up doing more than one loop, then
> it won't arm poll and it'll get failed.
>> add that it's rather insane for io-wq indefinitely spinning
>> on -EAGAIN, but it has long been fixed (for !IOPOLL).
> 
> There's no other choice for polling, and it doesn't do it for

zc rx is !IOPOLL, that's what I care about.

> non-polling. The current logic makes sense - if you do a blocking
> attempt and you get -EAGAIN, that's really the final result and you
> cannot sanely retry for !IOPOLL in that case. Before we did poll arm for
> io-wq, even the first -EAGAIN would've terminated it. Relying on -EAGAIN
> from a blocking attempt to do anything but fail the request with -EAGAIN
> res is pretty fragile and odd, I think that needs sorting out.
> 
>> As said, can be made a bit better, but it won't change anything
>> for real life execution, multishots would never end up there
>> after they start listening for poll events.
> 
> Right, probably won't ever be a thing for !multishot. As mentioned in my
> original reply, it really just needs a comment explaining exactly what
> it's doing and why it's fine.
> 
>>>> And it should also use IO_URING_F_IOWQ, forgot I split out
>>>> it from *F_UNLOCK.
>>>
>>> Yep, that'd be clearer.
>>
>> Not "clearer", but more correct. Even though it's not
>> a bug because deps between the flags.
> 
> Both clearer and more correct, I would say.
> 
[...]
>>>
>>> Oracle coding?
>>
>> I.e. knowing how later patches (should) look like.
>>
>>> Each patch stands separately, there's no reason not to make this one as
>>
>> They are not standalone, you cannot sanely develop anything not
>> thinking how and where it's used, otherwise you'd get a set of
>> functions full of sleeping but later used in irq context or just
>> unfittable into a desired framework. By extent, code often is
>> written while trying to look a step ahead. For example, first
>> patches don't push everything into io_uring.c just to wholesale
>> move it into zc_rx.c because of exceeding some size threshold.
> 
> Yes, this is how most patch series are - they will compile separately,
> but obviously won't necessarily make sense or be functional until you
> get to the end. But since you very much do have future knowledge in
> these patches, there's no excuse for not making them interact with each
> other better. Each patch should not pretend it doesn't know what comes

Which is exactly the reason why it is how it is.

> next in a series, if you can make a followup patch simpler with a tweak
> to a previous patch, that is definitely a good idea.
> 
> And here, even the end result would be better imho without having
> 
> if (a) {
> 	big blob of stuff
> } else {
> 	other blob of stuff
> }
> 
> when it could just be
> 
> if (a)
> 	return big_blog_of_stuff();
> 
> return other_blog_of_stuff();
> 
> instead.

That sounds like a good general advice, but the "blobs" are
not big nor expected to grow to require splitting, I can't say
it makes it any cleaner or simpler.

>>> clean as it can be. And an error case with the main bits inline is a lot
>>
>> I agree that it should be clean among all, but it _is_ clean
>> and readable, all else is stylistic nit picking. And maybe it's
>> just my opinion, but I also personally appreciate when a patch is
>> easy to review, which includes not restructuring all written before
>> with every patch, which also helps with back porting and other
>> developing aspects.
> 
> But that's basically my point, it even makes followup patches simpler to
> read as well. Is it stylistic? Certainly, I just prefer having the above
> rather than two big indentations. But it also makes the followup patch
> simpler
> and it's basically a one-liner change at that point, and a
> bigger hunk of added code that's the new function that handles the new
> case.
> 
>>> nicer imho than two separate indented parts. For the latter addition
>>> instead of the -EOPNOTSUPP, would probably be nice to have it in a
>>> separate function. Probably ditto for the page pool case here now, would
>>> make the later patch simpler too.
>>
>> If we'd need it in the future, we'll change it then, patches
>> stand separately, at least it's IMHO not needed in the current
>> series.
> 
> It's still an RFC series, please do change it for v4.

It's not my patch, but I don't view it as moving the patches in
any positive direction.

-- 
Pavel Begunkov

