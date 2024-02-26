Return-Path: <io-uring+bounces-769-lists+io-uring=lfdr.de@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [147.75.80.249])
	by mail.lfdr.de (Postfix) with ESMTPS id 14D4D8681C0
	for <lists+io-uring@lfdr.de>; Mon, 26 Feb 2024 21:12:57 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id 6A9E21F22989
	for <lists+io-uring@lfdr.de>; Mon, 26 Feb 2024 20:12:56 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id B96F812F39F;
	Mon, 26 Feb 2024 20:12:51 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel-dk.20230601.gappssmtp.com header.i=@kernel-dk.20230601.gappssmtp.com header.b="rth/J9fL"
X-Original-To: io-uring@vger.kernel.org
Received: from mail-io1-f54.google.com (mail-io1-f54.google.com [209.85.166.54])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4C79412C55D
	for <io-uring@vger.kernel.org>; Mon, 26 Feb 2024 20:12:47 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.166.54
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1708978371; cv=none; b=eptSdXf9+CQZYeJvI/Dbw7YfPi/fNvFCpfwzR5AxkXBul39To43OAyDuFQjfbolFgxxkxHBiFSRMGw/OZlOS+JI0yX4l34s8f4VLITOTse3hhRsDjlaA9FFefS4insw/CpGQ0cfeALVC78akm5tNrSXdIDqaraRXcxOVPyeHUIc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1708978371; c=relaxed/simple;
	bh=cWCU8l+Xd/H2y7QAXcAWH8tLbVqFMaGsBak2M95eICg=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=VeSy8583z8RW3P7Htv5U6xlvJSYv8S57jLQGLtNmUtTthCiHugrD4XoriLGl0OroAJV7bRLFPinRSe69P/eBUHGzaDeWTOsv3xSDOnvO3eSOUl+4Z9PjWjPF602XH2MrVCesVE/DxcxXktPN5aPJ9KFds8lQs6USMARqPtCsaTo=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=kernel.dk; spf=pass smtp.mailfrom=kernel.dk; dkim=pass (2048-bit key) header.d=kernel-dk.20230601.gappssmtp.com header.i=@kernel-dk.20230601.gappssmtp.com header.b=rth/J9fL; arc=none smtp.client-ip=209.85.166.54
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=kernel.dk
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=kernel.dk
Received: by mail-io1-f54.google.com with SMTP id ca18e2360f4ac-7c787eee137so39830039f.0
        for <io-uring@vger.kernel.org>; Mon, 26 Feb 2024 12:12:47 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernel-dk.20230601.gappssmtp.com; s=20230601; t=1708978366; x=1709583166; darn=vger.kernel.org;
        h=content-transfer-encoding:in-reply-to:from:references:cc:to
         :content-language:subject:user-agent:mime-version:date:message-id
         :from:to:cc:subject:date:message-id:reply-to;
        bh=BHom26/yIxN0tBTFue2LjkrmtnMRt4hn6F8YzZmC7yg=;
        b=rth/J9fLZlrKbLdyKGjqZ6kouqYQ9AMDk12X/yzFHVuVAm0jUpdXl7K/fK5dMdhv/K
         uC3RbCgr7MTD2cxwvX38X8LSIt5/A1BYX8h7B9hFu1AF58UYlcY2JCNDr3EMi0OTIFDr
         8AwzOPDXATS5lV28ljgua5a7LPtxgWMVhXDjIUr+prm8ZMtAofiWt/Q22hnZpjVghPyP
         XqJPvujljPdSFoEM3XQ2J5cFN2gOuXFDZr71IAFU7/Kd+3agNSAg7pmpmiZ/D8vEKM3R
         ZhKHILwzCwV0E6JN2mKnyGYQFiaZ8vlIN6zhUG040qY0g4Y9XGRS3sX/Jr53oTGn5Uob
         NjoQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1708978366; x=1709583166;
        h=content-transfer-encoding:in-reply-to:from:references:cc:to
         :content-language:subject:user-agent:mime-version:date:message-id
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=BHom26/yIxN0tBTFue2LjkrmtnMRt4hn6F8YzZmC7yg=;
        b=Si9JEQfOmfP8zjP473qmOHSLeVKVSj+9wJ1Zov9s6boPhWEtT+uA5QXQRsvtq3Yp3t
         F+ZDMWPi3l4VYY6mxAtrfqElQ06ZEBoLqz1oo76YdyGvVPFjXDjr6RrvupotZOflQpYF
         +oGGAt7nPv1B6dFux+DL7z2cuXQpoEW0gp3NOn9zpE1IvmDvAXzptjUxPTdBU9RNMp5x
         PEACYZowkWsx4qwHdDzjzodME+dNIa4F7mOx/goI3VDTVqCQarVB+dfGLKo7MVokTqmY
         AwRQp8G0fsYJXwDEcxOM7lVnwDyPGepLRNXLfBy5kXfDL6ZKGYEN9/AIKx1eiS1Kg/Au
         dUNw==
X-Gm-Message-State: AOJu0YzBRIu/e9jgy24EhjHXqhNQt3Z15D5p7Z036VWWW/EmZCNXgGpf
	HR8HDtlO9jkRziNT1jPx3b6R4XWxG3dFeEermjS/mt7xa2NJssFqgNDFcloIu0iMNoByMCpZeJw
	X
X-Google-Smtp-Source: AGHT+IEXg54/jJWYZDTBbxHmU+C+Xks+ZsiChSJYDJt+Om7AVdQL1Qso24dTvkVYoeoMHn5QjWWbGg==
X-Received: by 2002:a05:6e02:1ca8:b0:365:4e45:63ee with SMTP id x8-20020a056e021ca800b003654e4563eemr7268207ill.1.1708978366258;
        Mon, 26 Feb 2024 12:12:46 -0800 (PST)
Received: from [192.168.1.116] ([96.43.243.2])
        by smtp.gmail.com with ESMTPSA id c1-20020a92cf41000000b0036577b41481sm1679859ilr.73.2024.02.26.12.12.45
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Mon, 26 Feb 2024 12:12:45 -0800 (PST)
Message-ID: <302bf59a-40e1-413a-862d-9b99c8793061@kernel.dk>
Date: Mon, 26 Feb 2024 13:12:44 -0700
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
From: Jens Axboe <axboe@kernel.dk>
In-Reply-To: <68adc174-802a-455d-b6ca-a6908e592689@gmail.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit

On 2/26/24 12:21 PM, Pavel Begunkov wrote:
> On 2/26/24 19:11, Jens Axboe wrote:
>> On 2/26/24 8:41 AM, Pavel Begunkov wrote:
>>> On 2/26/24 15:16, Jens Axboe wrote:
>>>> On 2/26/24 7:36 AM, Pavel Begunkov wrote:
>>>>> On 2/26/24 14:27, Jens Axboe wrote:
>>>>>> On 2/26/24 7:02 AM, Dylan Yudaken wrote:
>>>>>>> On Mon, Feb 26, 2024 at 1:38?PM Jens Axboe
>>>>>>> <axboe@kernel.dk> wrote:
>>>>>>>> 
>>>>>>>> On 2/26/24 3:47 AM, Dylan Yudaken wrote:
>>>>>>>>> On Sun, Feb 25, 2024 at 12:46?AM Jens Axboe
>>>>>>>>> <axboe@kernel.dk> wrote:
>>>>>>>>>> 
>>>>>>>>>> This works very much like the receive side, except
>>>>>>>>>> for sends. The idea is that an application can fill
>>>>>>>>>> outgoing buffers in a provided buffer group, and
>>>>>>>>>> then arm a single send that will service them all.
>>>>>>>>>> For now this variant just terminates when we are
>>>>>>>>>> out of buffers to send, and hence the application
>>>>>>>>>> needs to re-arm it if IORING_CQE_F_MORE isn't set,
>>>>>>>>>> as per usual for multishot requests.
>>>>>>>>>> 
>>>>>>>>> 
>>>>>>>>> This feels to me a lot like just using OP_SEND with
>>>>>>>>> MSG_WAITALL as described, unless I'm missing
>>>>>>>>> something?
>>>>>>>> 
>>>>>>>> How so? MSG_WAITALL is "send X amount of data, and if
>>>>>>>> it's a short send, try again" where multishot is "send
>>>>>>>> data from this buffer group, and keep sending data
>>>>>>>> until it's empty". Hence it's the mirror of multishot 
>>>>>>>> on the receive side. Unless I'm misunderstanding you
>>>>>>>> somehow, not sure it'd be smart to add special meaning
>>>>>>>> to MSG_WAITALL with provided buffers.
>>>>>>>> 
>>>>>>> 
>>>>>>> _If_ you have the data upfront these are very similar,
>>>>>>> and only differ in that the multishot approach will give
>>>>>>> you more granular progress updates. My point was that
>>>>>>> this might not be a valuable API to people for only this
>>>>>>> use case.
>>>>>> 
>>>>>> Not sure I agree, it feels like attributing a different
>>>>>> meaning to MSG_WAITALL if you use a provided buffer vs if
>>>>>> you don't. And that to me would seem to be confusing.
>>>>>> Particularly when we have multishot on the receive side,
>>>>>> and this is identical, just for sends. Receives will keep 
>>>>>> receiving as long as there are buffers in the provided
>>>>>> group to receive into, and sends will keep sending for the
>>>>>> same condition. Either one will terminate if we run out of
>>>>>> buffers.
>>>>>> 
>>>>>> If you make MSG_WAITALL be that for provided buffers +
>>>>>> send, then that behaves differently than MSG_WAITALL with
>>>>>> receive, and MSG_WAITALL with send _without_ provided
>>>>>> buffers. I don't think overloading an existing flag for
>>>>>> this purposes is a good idea, particularly when we already
>>>>>> have the existing semantics for multishot on the receive
>>>>>> side.
>>>>> 
>>>>> I'm actually with Dylan on that and wonder where the perf
>>>>> win could come from. Let's assume TCP, sends are usually
>>>>> completed in the same syscall, otherwise your pacing is just
>>>>> bad. Thrift, for example, collects sends and packs into one
>>>>> multi iov request during a loop iteration. If the req
>>>>> completes immediately then the userspace just wouldn't have
>>>>> time to push more buffers by definition (assuming single
>>>>> threading).
>>>> 
>>>> The problem only occurs when they don't complete inline, and
>>>> now you get reordering. The application could of course attempt
>>>> to do proper pacing and see if it can avoid that condition. If
>>>> not, it now needs to
>>> 
>>> Ok, I admit that there are more than valid cases when artificial
>>> pacing is not an option, which is why I also laid out the polling
>>> case. Let's also say that limits potential perf wins to streaming
>>> and very large transfers (like files), not "lots of relatively
>>> small request-response" kinds of apps.
>> 
>> I don't think that's true - if you're doing large streaming, you're
>> more likely to keep the socket buffer full, whereas for smallish
>> sends, it's less likely to be full. Testing with the silly proxy
>> confirms that. And
> 
> I don't see any contradiction to what I said. With streaming/large 
> sends it's more likely to be polled. For small sends and 
> send-receive-send-... patterns the sock queue is unlikely to be full,
> in which case the send is processed inline, and so the feature
> doesn't add performance, as you agreed a couple email before.

Gotcha, I guess I misread you, we agree that the poll side is more
likely on bigger buffers.

>> outside of cases where pacing just isn't feasible, it's extra
>> overhead for cases where you potentially could or what.
> 
> I lost it, what overhead?

Overhead of needing to serialize the sends in the application, which may
include both extra memory needed and overhead in dealing with it.

>> To me, the main appeal of this is the simplicity.
> 
> I'd argue it doesn't seem any simpler than the alternative.

It's certainly simpler for an application to do "add buffer to queue"
and not need to worry about managing sends, than it is to manage a
backlog of only having a single send active.

>>>> serialize sends. Using provided buffers makes this very easy,
>>>> as you don't need to care about it at all, and it eliminates
>>>> complexity in the application dealing with this.
>>> 
>>> If I'm correct the example also serialises sends(?). I don't 
>>> think it's that simpler. You batch, you send. Same with this, but
>>> batch into a provided buffer and the send is conditional.
>> 
>> Do you mean the proxy example? Just want to be sure we're talking
>> about
> 
> Yes, proxy, the one you referenced in the CV. And FWIW, I don't think
> it's a fair comparison without batching followed by multi-iov.

It's not about vectored vs non-vectored IO, though you could of course
need to allocate an arbitrarily sized iovec that you can append to. And
now you need to use sendmsg rather than just send, which has further
overhead on top of send.

What kind of batching? The batching done by the tests are the same,
regardless of whether or not send multishot is used in the sense that we
wait on the same number of completions. As it's a basic proxy kind of
thing, it'll receive a packet and send a packet. Submission batching is
the same too, we'll submit when we have to.

>> the same thing. Yes it has to serialize sends, because otherwise we
>> can run into the condition described in the patch that adds
>> provided buffer support for send. But I did bench multishot
>> separately from there, here's some of it:
>> 
>> 10G network, 3 hosts, 1 acting as a mirror proxy shuffling N-byte
>> packets. Send ring and send multishot not used:
>> 
>> Pkt sz | Send ring | mshot |  usec  |  QPS  |  Bw 
>> ===================================================== 1000   |
>> No       |  No   |   437  | 1.22M | 9598M 32     |    No       |
>> No   |  5856  | 2.87M |  734M
>> 
>> Same test, now turn on send ring:
>> 
>> Pkt sz | Send ring | mshot |  usec  |  QPS  |  Bw   | Diff 
>> =========================================================== 1000
>> |    Yes       |  No   |   436  | 1.23M | 9620M | + 0.2% 32     |
>> Yes       |  No   |  3462  | 4.85M | 1237M | +68.5%
>> 
>> Same test, now turn on send mshot as well:
>> 
>> Pkt sz | Send ring | mshot |  usec  |  QPS  |  Bw   | Diff 
>> =========================================================== 1000
>> |    Yes       |  Yes  |   436  | 1.23M | 9620M | + 0.2% 32     |
>> Yes       |  Yes  |  3125  | 5.37M | 1374M | +87.2%
>> 
>> which does show that there's another win on top for just queueing
>> these sends and doing a single send to handle them, rather than
>> needing to prepare a send for each buffer. Part of that may be that
>> you simply run out of SQEs and then have to submit regardless of
>> where you are at.
> 
> How many sockets did you test with? It's 1 SQE per sock max

The above is just one, but I've run it with a lot more sockets. Nothing
ilke thousands, but 64-128.

> +87% sounds like a huge difference, and I don't understand where it
> comes from, hence the question

There are several things:

1) Fact is that the app has to serialize sends for the unlikely case
   of sends being reordered because of the condition outlined in the
   patch that enables provided buffer support for send. This is the
   largest win, particularly with smaller packets, as it ruins the
   send pipeline.

2) We're posting fewer SQEs. That's the multishot win. Obivously not
   as large, but it does help.

People have asked in the past on how to serialize sends, and I've had to
tell them that it isn't really possible. The only option we had was
using drain or links, which aren't ideal nor very flexible. Using
provided buffers finally gives the application a way to do that without
needing to do anything really. Does every application need it? Certainly
not, but for the ones that do, I do think it provides a great
alternative that's better performing than doing single sends at the
time.

>>> Another downside is that you need a provided queue per socket, 
>>> which sounds pretty expensive for 100s if not 1000s socket apps.
>> 
>> That's certainly true. But either you need backlog per socket
>> anyway in the app, or you only send single buffers anyway (in a
>> typical request/response kind of fashion) between receives and you
>> don't need it at all.
> 
> That's pinning pages and maping them, which surely is not bad but
> with everything else equal malloc()/stack alloc is much nicer in
> terms of resources. (Not talking about CPU setup overhead).

Sure, it's not free in terms of memory either. As mentioned several
times, the main win is on efficiency and in reducing complexity, and
both of those are pretty nice imho.

>>>>> If you actually need to poll tx, you send a request and
>>>>> collect data into iov in userspace in background. When the
>>>>> request completes you send all that in batch. You can
>>>>> probably find a niche example when batch=1 in this case, but
>>>>> I don't think anyone would care.
>>>>> 
>>>>> The example doesn't use multi-iov, and also still has to 
>>>>> serialise requests, which naturally serialises buffer
>>>>> consumption w/o provided bufs.
>>>> 
>>>> IMHO there's no reason NOT to have both a send with provided
>>>> buffers and a multishot send. The alternative would be to have
>>>> send-N, where you pass in N. But I don't see much point to that
>>>> over "just drain the whole pending list". The obvious use case
>>>> is definitely send multishot, but
>>> 
>>> Not sure I follow, but in all cases I was contemplating about you
>>> sends everything you have at the moment.
>>> 
>>>> what would the reasoning be to prohibit pacing by explicitly
>>>> disallowing only doing a single buffer (or a partial queue)? As
>>>> mentioned earlier, I like keeping the symmetry with the receive
>>>> side for multishot, and not make it any different unless
>>>> there's a reason to.
>>> 
>>> There are different, buffer content kernel (rx) vs userspace
>>> (tx) provided, provided queue / group per socket vs shared. Wake
>>> ups for multishots as per below. It's not like it's a one line
>>> change, so IMHO requires to be giving some benefits.
>> 
>> Are you talking about provided buffers, or multishot specifically?
>> I
> 
> I assumed that any of them would retry until the queue is exhausted, 
> at least that sounds more efficient and used in all comments.

That is what it does, it'll keep sending until it runs out of buffers
(or hits an error, short send, whatever).

>> think both are standalone pretty much as simple as they can be. And
>> if the argument is "just have send with provided buffers be
>> multishot by default",
> 
> It's not, rx and tx are different, e.g. true tx multishot doesn't 
> seem to be possible because of that.

In the sense that rx and poll trigger on data now being available isn't
feasible on send, yeah they are not exact mirrors of each other. But
they are as close as they can be. If there was, or ever will be, an
efficient way to re-trigger a multishot send, that would certainly be a
doable and an easy addition to make on top of this. It really only
changes the termination point, if you run out of buffers you just go to
whatever arming method would be suitable for that. But since the reason
for recv multishot is to avoid hammering on the locking on the poll
side, I'm not convinced that having a perpetual multishot send would
make a lot more sense than simply doing another one when needed. If
you're socket buffer bound on multishot send, then the perpetual poll
trigger works and is useful.

>> then that single patch is basically the two patches combined. 
>> There's no simplification there. Outside of a strong argument for
>> why it would never make sense to do single shot send with provided
>> buffers, I really don't want to combine them into one single
>> action.
> 
> In the current form it does make more sense to have multishot
> optionally.

I obviously agree on that too, kept them separate in the v4 posting as
well.

-- 
Jens Axboe



