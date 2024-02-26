Return-Path: <io-uring+bounces-771-lists+io-uring=lfdr.de@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [147.75.199.223])
	by mail.lfdr.de (Postfix) with ESMTPS id 849FC86830F
	for <lists+io-uring@lfdr.de>; Mon, 26 Feb 2024 22:29:30 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id A7F211C25D7C
	for <lists+io-uring@lfdr.de>; Mon, 26 Feb 2024 21:29:29 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 5518F13341A;
	Mon, 26 Feb 2024 21:27:51 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel-dk.20230601.gappssmtp.com header.i=@kernel-dk.20230601.gappssmtp.com header.b="M0kkS9Js"
X-Original-To: io-uring@vger.kernel.org
Received: from mail-il1-f176.google.com (mail-il1-f176.google.com [209.85.166.176])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3DFF8132466
	for <io-uring@vger.kernel.org>; Mon, 26 Feb 2024 21:27:46 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.166.176
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1708982871; cv=none; b=CAtlUbLNG+UJBq5K52acp6HR9I0D4C1vJFWmEKWjPb4fzpdPAxI/Wrs26KOyLLWnOPKNLvRNmpKqC/N5/IQ/9vkeNd05Wpk6cyWXM9k/oIBTrsFRAp6+W3HODIYiRESMft4vwvtN3/fseifdsS9FIoTOAun7AzKrvM/gZZbsbGY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1708982871; c=relaxed/simple;
	bh=pMeCnBjySF0c0srmW3xL+7cpYbBoN7JUni9UwI6BRDI=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=YlgmlyvLGytmFwF26qh61ieT7dlRr2SRnuVs0yR5sspjmj/TH2J3Uzo4xOjswN6hDiwYFkMR94diQlOLODDKfBbaob6yrxo+6N+WoXaLDGJ8b+6EiGji2NZSiDRCYS1TRuDsVhB67JIRuNLyS5mtIzZbDcfd0u9gCI8ZjMYml7c=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=kernel.dk; spf=pass smtp.mailfrom=kernel.dk; dkim=pass (2048-bit key) header.d=kernel-dk.20230601.gappssmtp.com header.i=@kernel-dk.20230601.gappssmtp.com header.b=M0kkS9Js; arc=none smtp.client-ip=209.85.166.176
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=kernel.dk
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=kernel.dk
Received: by mail-il1-f176.google.com with SMTP id e9e14a558f8ab-35d374bebe3so722265ab.1
        for <io-uring@vger.kernel.org>; Mon, 26 Feb 2024 13:27:46 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernel-dk.20230601.gappssmtp.com; s=20230601; t=1708982866; x=1709587666; darn=vger.kernel.org;
        h=content-transfer-encoding:in-reply-to:from:references:cc:to
         :content-language:subject:user-agent:mime-version:date:message-id
         :from:to:cc:subject:date:message-id:reply-to;
        bh=I+vufNGPqNwXX/DdjmHRnFR4+ZW6plYsDiQvVAXKZL0=;
        b=M0kkS9JsYTzOGLdBeKeGj1TAykLnTyVoz2jd+9XUZ0gM79WZ5MNbjmhKFrwTriy8tC
         txjIcnrj4JMuLRugtC/2SecCOaqncu4UmyVNW7KAgfxa8nUz7hmLMQvRwbFGaKaOAWts
         OSki+xKx/FrH4fVIznPgcKQJrD4gi2X11VJZVsM+yIvlNKK+8vPmBm37hyILkYlnDqBb
         cBrDsXThfnxZY5rITI+fMMcnMbfQRIj9w+0iDIEdowreZbPNqRwBK18HLfcR0Nhplwq/
         mH1drzhaW8HWwms7Aii+IVR7dtNWRboCDw21GwLbOGBWacr2Mq3QqXTIweP40ILg8WrW
         0ExQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1708982866; x=1709587666;
        h=content-transfer-encoding:in-reply-to:from:references:cc:to
         :content-language:subject:user-agent:mime-version:date:message-id
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=I+vufNGPqNwXX/DdjmHRnFR4+ZW6plYsDiQvVAXKZL0=;
        b=gLKZeR7I2cL9+A2sYcYZkwuEWMzKRdeL3RqB5ne2R5H/ks6TEkX5hUnnylUc796jL3
         6LkiWsTa/BIbPGF7ZFOpkkPjmVOphrtqnFqnwzEC4mpZvfUEH0qWIq1HB6l7mcalv6lc
         VLPvHRHgV7sEkcpR4uZ6/ndPC1fDhYHgIyckQ7EX7jp1ZX/DVS3UAUyVBwH0w4/SGE6m
         TY3kLpHgiffC4PbDYrpqhM2GhOstNyvxo/ZiPNgeUFIlEFLHI+gdseAu5/up+ylPwRly
         yDleS1aYSQSuCjHqrlPz62wiGEWFUU0zOkdrcN2ze8Tg+lKjVhQwfsO8Dq/pgAZKOWEM
         wlTw==
X-Gm-Message-State: AOJu0YyWhDI4F2S0GVDLb3SscwF1xnEfp24nFzPimVud4SBkEkdC3Yvi
	jWDv9W6fkVXeipFpuqitJVGbX/2XqQP2ipu+lAfXDTIebEQJbjExDx5a5Rdl6Dg=
X-Google-Smtp-Source: AGHT+IEGiRlrGXFZ7KeaPs6ZMorlStPvvmspC5POZ3XaOpdnfFt19XkceZVhwtnGq3qe+kAPE+OdTA==
X-Received: by 2002:a05:6e02:152b:b0:365:5dbd:ba43 with SMTP id i11-20020a056e02152b00b003655dbdba43mr8038531ilu.1.1708982865929;
        Mon, 26 Feb 2024 13:27:45 -0800 (PST)
Received: from [192.168.1.116] ([96.43.243.2])
        by smtp.gmail.com with ESMTPSA id t1-20020a92dc01000000b00365771fa2afsm1736322iln.30.2024.02.26.13.27.45
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Mon, 26 Feb 2024 13:27:45 -0800 (PST)
Message-ID: <53e69744-7165-4069-bada-8e60c2adc0c7@kernel.dk>
Date: Mon, 26 Feb 2024 14:27:44 -0700
Precedence: bulk
X-Mailing-List: io-uring@vger.kernel.org
List-Id: <io-uring.vger.kernel.org>
List-Subscribe: <mailto:io-uring+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:io-uring+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH 6/8] io_uring/net: support multishot for send
Content-Language: en-US
To: Pavel Begunkov <asml.silence@gmail.com>,
 Dylan Yudaken <dyudaken@gmail.com>
Cc: io-uring@vger.kernel.org
References: <20240225003941.129030-1-axboe@kernel.dk>
 <20240225003941.129030-7-axboe@kernel.dk>
 <CAO_YeojZHSnx471+HKKFgRo-yy5cv=OmEg_Ri48vMUOwegvOqg@mail.gmail.com>
 <63859888-5602-41fb-9a42-4edc6132766f@kernel.dk>
 <CAO_YeoiTpPALaeiQiCjoW1VSr6PMPDUrH5xT3dTD19=OK1ytPg@mail.gmail.com>
 <ecd796a4-e413-47d3-91c1-015b5c211ee2@kernel.dk>
 <f0046836-ef9d-4b58-bfae-f2bf087233e1@gmail.com>
 <454ef0d2-066f-4bdf-af42-52fd0c57bd56@kernel.dk>
 <a0f62e25-f19c-44b7-bf26-4460ae01de7f@gmail.com>
 <4823c201-8c5d-4a4f-a77e-bd3e6c239cbe@kernel.dk>
 <68adc174-802a-455d-b6ca-a6908e592689@gmail.com>
 <302bf59a-40e1-413a-862d-9b99c8793061@kernel.dk>
 <0d440ebb-206e-4315-a7c4-84edc73e8082@gmail.com>
From: Jens Axboe <axboe@kernel.dk>
In-Reply-To: <0d440ebb-206e-4315-a7c4-84edc73e8082@gmail.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit

On 2/26/24 1:51 PM, Pavel Begunkov wrote:
> On 2/26/24 20:12, Jens Axboe wrote:
>> On 2/26/24 12:21 PM, Pavel Begunkov wrote:
>>> On 2/26/24 19:11, Jens Axboe wrote:
>>>> On 2/26/24 8:41 AM, Pavel Begunkov wrote:
>>>>> On 2/26/24 15:16, Jens Axboe wrote:
>>>>>> On 2/26/24 7:36 AM, Pavel Begunkov wrote:
>>>>>>> On 2/26/24 14:27, Jens Axboe wrote:
>>>>>>>> On 2/26/24 7:02 AM, Dylan Yudaken wrote:
>>>>>>>>> On Mon, Feb 26, 2024 at 1:38?PM Jens Axboe
> ...
>>>> I don't think that's true - if you're doing large streaming, you're
>>>> more likely to keep the socket buffer full, whereas for smallish
>>>> sends, it's less likely to be full. Testing with the silly proxy
>>>> confirms that. And
>>>
>>> I don't see any contradiction to what I said. With streaming/large
>>> sends it's more likely to be polled. For small sends and
>>> send-receive-send-... patterns the sock queue is unlikely to be full,
>>> in which case the send is processed inline, and so the feature
>>> doesn't add performance, as you agreed a couple email before.
>>
>> Gotcha, I guess I misread you, we agree that the poll side is more
>> likely on bigger buffers.
>>
>>>> outside of cases where pacing just isn't feasible, it's extra
>>>> overhead for cases where you potentially could or what.
>>>
>>> I lost it, what overhead?
>>
>> Overhead of needing to serialize the sends in the application, which may
>> include both extra memory needed and overhead in dealing with it.
> 
> I think I misread the code. Does it push 1 request for each
> send buffer / queue_send() in case of provided bufs?

Right, that's the way it's currently setup. Per send (per loop), if
you're using provided buffers, it'll do a send per buffer. If using
multishot on top of that, it'll do one send per loop regardless of the
number of buffers.

> Anyway, the overhead of serialisation would be negligent.
> And that's same extra memory you keep for the provided buffer
> pool, and you can allocate it once. Also consider that provided
> buffers are fixed size and it'd be hard to resize without waiting,
> thus the userspace would still need to have another, userspace
> backlog, it can't just drop requests. Or you make provided queues
> extra large, but it's per socket and you'd wasting lots of memory.
> 
> IOW, I don't think this overhead could anyhow close us to
> the understanding of the 30%+ perf gap.

The 32-byte case is obviously somewhat pathological, as you're going to
be much better off having a bunch of these pipelined rather than issued
serially. As you can see from the 1000 byte packets, at that point it
doesn't matter that much. It's mostly about making it simpler at that
point.

>>>> To me, the main appeal of this is the simplicity.
>>>
>>> I'd argue it doesn't seem any simpler than the alternative.
>>
>> It's certainly simpler for an application to do "add buffer to queue"
>> and not need to worry about managing sends, than it is to manage a
>> backlog of only having a single send active.
> 
> They still need to manage / re-queue sends. And maybe I
> misunderstand the point, but it's only one request inflight
> per socket in either case.

Sure, but one is a manageable condition, the other one is not. If you
can keep N inflight at the same time and only abort the chain in case of
error/short send, that's a corner case. Versus not knowing when things
get reordered, and hence always needing to serialize.

>>>>>> serialize sends. Using provided buffers makes this very easy,
>>>>>> as you don't need to care about it at all, and it eliminates
>>>>>> complexity in the application dealing with this.
>>>>>
>>>>> If I'm correct the example also serialises sends(?). I don't
>>>>> think it's that simpler. You batch, you send. Same with this, but
>>>>> batch into a provided buffer and the send is conditional.
>>>>
>>>> Do you mean the proxy example? Just want to be sure we're talking
>>>> about
>>>
>>> Yes, proxy, the one you referenced in the CV. And FWIW, I don't think
>>> it's a fair comparison without batching followed by multi-iov.
>>
>> It's not about vectored vs non-vectored IO, though you could of course
>> need to allocate an arbitrarily sized iovec that you can append to. And
>> now you need to use sendmsg rather than just send, which has further
>> overhead on top of send.
> 
> That's not nearly enough of overhead to explain the difference,
> I don't believe so, going through the net stack is quite expensive.

See above, for the 32-byte packets, it's not hard to imagine big wins by
having many shoved in vs doing them piecemeal.

And honestly, I was surprised at how well the stack deals with this on
the networking side! It may have room for improvement, but it's not
nearly as sluggish as I feared.

>> What kind of batching? The batching done by the tests are the same,
>> regardless of whether or not send multishot is used in the sense that we
> 
> You can say that, but I say that it moves into the kernel
> batching that can be implemented in userspace.

And then most people get it wrong or just do the basic stuff, and
performance isn't very good. Getting the most out of it can be tricky
and require extensive testing and knowledge building. I'm confident
you'd be able to write an efficient version, but that's not the same as
saying "it's trivial to write an efficient version".

>> wait on the same number of completions. As it's a basic proxy kind of
>> thing, it'll receive a packet and send a packet. Submission batching is
>> the same too, we'll submit when we have to.
> 
> "If you actually need to poll tx, you send a request and collect
> data into iov in userspace in background. When the request
> completes you send all that in batch..."
> 
> That's how it's in Thrift for example.
> 
> In terms of "proxy", the first approximation would be to
> do sth like defer_send() for normal requests as well, then
> 
> static void __queue_send(struct io_uring *ring, struct conn *c, int fd,
>              void *data, int bid, int len)
> {
>     ...
> 
>     defer_send(data);
> 
>     while (buf = defer_backlog.get()) {
>         iov[idx++] = buf;
>     }
>     msghdr->iovlen = idx;
>     ...
> }

Yep, that's the iovec coalescing, and that could certainly be done. And
then you need to size the iov[] so that it's always big enough, OR
submit that send and still deal with managing your own backlog.

I don't think we disagree that there are other solutions. I'm saying
that I like this solution. I think it's simple to use for the cases that
can use it, and that's why the patches exist. It fits with the notion of
an async API being able to keep multiple things in flight, rather than a
semi solution where you kind of can, except not for cases X and Y
because of corner cases.

>>>> the same thing. Yes it has to serialize sends, because otherwise we
>>>> can run into the condition described in the patch that adds
>>>> provided buffer support for send. But I did bench multishot
>>>> separately from there, here's some of it:
>>>>
>>>> 10G network, 3 hosts, 1 acting as a mirror proxy shuffling N-byte
>>>> packets. Send ring and send multishot not used:
>>>>
>>>> Pkt sz | Send ring | mshot |  usec  |  QPS  |  Bw
>>>> ===================================================== 1000   |
>>>> No       |  No   |   437  | 1.22M | 9598M 32     |    No       |
>>>> No   |  5856  | 2.87M |  734M
>>>>
>>>> Same test, now turn on send ring:
>>>>
>>>> Pkt sz | Send ring | mshot |  usec  |  QPS  |  Bw   | Diff
>>>> =========================================================== 1000
>>>> |    Yes       |  No   |   436  | 1.23M | 9620M | + 0.2% 32     |
>>>> Yes       |  No   |  3462  | 4.85M | 1237M | +68.5%
>>>>
>>>> Same test, now turn on send mshot as well:
>>>>
>>>> Pkt sz | Send ring | mshot |  usec  |  QPS  |  Bw   | Diff
>>>> =========================================================== 1000
>>>> |    Yes       |  Yes  |   436  | 1.23M | 9620M | + 0.2% 32     |
>>>> Yes       |  Yes  |  3125  | 5.37M | 1374M | +87.2%
>>>>
>>>> which does show that there's another win on top for just queueing
>>>> these sends and doing a single send to handle them, rather than
>>>> needing to prepare a send for each buffer. Part of that may be that
>>>> you simply run out of SQEs and then have to submit regardless of
>>>> where you are at.
>>>
>>> How many sockets did you test with? It's 1 SQE per sock max
>>
>> The above is just one, but I've run it with a lot more sockets. Nothing
>> ilke thousands, but 64-128.
>>
>>> +87% sounds like a huge difference, and I don't understand where it
>>> comes from, hence the question
>>
>> There are several things:
>>
>> 1) Fact is that the app has to serialize sends for the unlikely case
>>     of sends being reordered because of the condition outlined in the
>>     patch that enables provided buffer support for send. This is the
>>     largest win, particularly with smaller packets, as it ruins the
>>     send pipeline.
> 
> Do those small packets force it to poll?

There's no polling in my testing.

>> 2) We're posting fewer SQEs. That's the multishot win. Obivously not
>>     as large, but it does help.
>>
>> People have asked in the past on how to serialize sends, and I've had to
>> tell them that it isn't really possible. The only option we had was
>> using drain or links, which aren't ideal nor very flexible. Using
>> provided buffers finally gives the application a way to do that without
>> needing to do anything really. Does every application need it? Certainly
>> not, but for the ones that do, I do think it provides a great
>> alternative that's better performing than doing single sends at the
>> time.
> 
> As per note on additional userspace backlog, any real generic app
> and especially libs would need to do more to support it.

Sure, if you get a short send or any abort in the chain, you need to
handle it. But things stall/stop at that point and you handle it, and
then you're back up and running. This is vastly different from "oh I
always need to serialize because X or Y may happen, even though it
rarely does or never does in my case".

-- 
Jens Axboe


