Return-Path: <io-uring+bounces-754-lists+io-uring=lfdr.de@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [139.178.88.99])
	by mail.lfdr.de (Postfix) with ESMTPS id D5ECE8680A2
	for <lists+io-uring@lfdr.de>; Mon, 26 Feb 2024 20:15:22 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 8C5B328E5B2
	for <lists+io-uring@lfdr.de>; Mon, 26 Feb 2024 19:15:21 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 13C4C12F361;
	Mon, 26 Feb 2024 19:11:58 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel-dk.20230601.gappssmtp.com header.i=@kernel-dk.20230601.gappssmtp.com header.b="ZJwjY7Gv"
X-Original-To: io-uring@vger.kernel.org
Received: from mail-io1-f47.google.com (mail-io1-f47.google.com [209.85.166.47])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 54086130AC1
	for <io-uring@vger.kernel.org>; Mon, 26 Feb 2024 19:11:53 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.166.47
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1708974717; cv=none; b=MpqQjAZs07bNtsszyDt/3Af2Ml8KWseakZIaCNX3ChDkzu7rhKfV9hVCxdmedB7m6Ysy72TJ1rrYz+67tmTbjDyL18Apha5r84nuCONkpfLU0MqDPM7JV7hA9vvOEg7KBCmBZqEnq1oZ5eWxvPpntOUHBNQqitxhUKwRHn2TuSs=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1708974717; c=relaxed/simple;
	bh=oCbvh5CO9e6dZJ+KzWtlCZt3JHpbqieyaMZ6qXNzyo0=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=IsF7VYVkQku4Rsw1rHJI5qQKASfesWOwBNNW00YePR2WN/KdYa9Vp0avr38FHzr60aHHwJ1rpUCZw3ciQ39ifbwImYVpeE1uc9kr+xcfDLDhpBGPUolYiHw7ENgRIXo6NwlDK7fc9CaCSMc5BGe3QlcDYcPwmHItaBol3e22Pv8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=kernel.dk; spf=pass smtp.mailfrom=kernel.dk; dkim=pass (2048-bit key) header.d=kernel-dk.20230601.gappssmtp.com header.i=@kernel-dk.20230601.gappssmtp.com header.b=ZJwjY7Gv; arc=none smtp.client-ip=209.85.166.47
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=kernel.dk
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=kernel.dk
Received: by mail-io1-f47.google.com with SMTP id ca18e2360f4ac-7c7b076562cso25871739f.0
        for <io-uring@vger.kernel.org>; Mon, 26 Feb 2024 11:11:53 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernel-dk.20230601.gappssmtp.com; s=20230601; t=1708974711; x=1709579511; darn=vger.kernel.org;
        h=content-transfer-encoding:in-reply-to:from:references:cc:to
         :content-language:subject:user-agent:mime-version:date:message-id
         :from:to:cc:subject:date:message-id:reply-to;
        bh=gIRJb7Kus99iCKgL+l++hYqZBfwHdYtd2SPtrqgE0ps=;
        b=ZJwjY7Gv1uxm+MrHuNvzJ7xPL8apGTtSptBmPKSmmweM+FqsGe30cvimF5hSuobnE8
         b5vGSG+lJE5mrTU7KtLF5T7EKGopGqFmHDjVln204uOto5p/0LZn95jK4fVShLDRyAQY
         FLbHYH7tdEKl9KDW/fpWfGweL2CqKi7d82MF3tfw85zPhpEstgAt0Bp4Lgf6RcocUDjT
         D1UrUTZClEFFtaXKnIT5cKJyzQvnvLbrAvIywx8ZhS//Tyu8l7Tl67ZMuLIZmpUYpfCg
         BMrWl06BoO3MXPn1EMr3JrCS+iuIbXohE6w4L88HEO05Xhj49gwwpV6VFMvhKT31Ihek
         Gcow==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1708974711; x=1709579511;
        h=content-transfer-encoding:in-reply-to:from:references:cc:to
         :content-language:subject:user-agent:mime-version:date:message-id
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=gIRJb7Kus99iCKgL+l++hYqZBfwHdYtd2SPtrqgE0ps=;
        b=juHufRTuGopWUQqvQ3WLjWTHdcTJXW4lsE1qaU4lUeoMgcPPIks0jFszAGGBiDS+N1
         C4kd0p03jl8Sf6RbJqMWgfCVkP2w0Tl73q4GIBMxmAOpnnfPg8T6HpVBPxzN7ZvgHmjA
         ClASqSt46y3gDrbceBYW5WWKDQ4qKPDZJoHVDpOI+7WgPC9tnKsu5CgKOCa77AApLIj2
         NGpOyhGNis4kAVhNLV81F5k0QMEifiMezr0/ALSnNNzG1n5i5G8peLLtNBdKIGiS2U1X
         pCiVVQqt6J9hYaiJLQ+0q38SXeCbT3Xye+qUm4dozCs7E7M6vgk10ulbu1vNni4K1Ll+
         j07w==
X-Gm-Message-State: AOJu0YzjfrCsUqmGJSrDYh8DUOMyv9AgYSXLAg+bXi/XLwJbqYZ4GNQI
	8xEsAPN0oW0W2TnKV83JtQPicEiX5laweKDeGTfZuBuUqH0bEG14OrO90l3HohY=
X-Google-Smtp-Source: AGHT+IFpE0bC+RVBcVnD4apMjoGniFCI2IiH5aivUkFDQJtDgFqApv3K+uRjpUXDVRiK3gQY2cPV1Q==
X-Received: by 2002:a05:6602:2e8c:b0:7c7:b54b:19b0 with SMTP id m12-20020a0566022e8c00b007c7b54b19b0mr5746962iow.0.1708974711014;
        Mon, 26 Feb 2024 11:11:51 -0800 (PST)
Received: from [192.168.1.116] ([96.43.243.2])
        by smtp.gmail.com with ESMTPSA id q21-20020a0566380ed500b00473a2d3a3d7sm1358005jas.152.2024.02.26.11.11.50
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Mon, 26 Feb 2024 11:11:50 -0800 (PST)
Message-ID: <4823c201-8c5d-4a4f-a77e-bd3e6c239cbe@kernel.dk>
Date: Mon, 26 Feb 2024 12:11:49 -0700
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
From: Jens Axboe <axboe@kernel.dk>
In-Reply-To: <a0f62e25-f19c-44b7-bf26-4460ae01de7f@gmail.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit

On 2/26/24 8:41 AM, Pavel Begunkov wrote:
> On 2/26/24 15:16, Jens Axboe wrote:
>> On 2/26/24 7:36 AM, Pavel Begunkov wrote:
>>> On 2/26/24 14:27, Jens Axboe wrote:
>>>> On 2/26/24 7:02 AM, Dylan Yudaken wrote:
>>>>> On Mon, Feb 26, 2024 at 1:38?PM Jens Axboe <axboe@kernel.dk> wrote:
>>>>>>
>>>>>> On 2/26/24 3:47 AM, Dylan Yudaken wrote:
>>>>>>> On Sun, Feb 25, 2024 at 12:46?AM Jens Axboe <axboe@kernel.dk> wrote:
>>>>>>>>
>>>>>>>> This works very much like the receive side, except for sends. The idea
>>>>>>>> is that an application can fill outgoing buffers in a provided buffer
>>>>>>>> group, and then arm a single send that will service them all. For now
>>>>>>>> this variant just terminates when we are out of buffers to send, and
>>>>>>>> hence the application needs to re-arm it if IORING_CQE_F_MORE isn't
>>>>>>>> set, as per usual for multishot requests.
>>>>>>>>
>>>>>>>
>>>>>>> This feels to me a lot like just using OP_SEND with MSG_WAITALL as
>>>>>>> described, unless I'm missing something?
>>>>>>
>>>>>> How so? MSG_WAITALL is "send X amount of data, and if it's a short send,
>>>>>> try again" where multishot is "send data from this buffer group, and
>>>>>> keep sending data until it's empty". Hence it's the mirror of multishot
>>>>>> on the receive side. Unless I'm misunderstanding you somehow, not sure
>>>>>> it'd be smart to add special meaning to MSG_WAITALL with provided
>>>>>> buffers.
>>>>>>
>>>>>
>>>>> _If_ you have the data upfront these are very similar, and only differ
>>>>> in that the multishot approach will give you more granular progress
>>>>> updates. My point was that this might not be a valuable API to people
>>>>> for only this use case.
>>>>
>>>> Not sure I agree, it feels like attributing a different meaning to
>>>> MSG_WAITALL if you use a provided buffer vs if you don't. And that to me
>>>> would seem to be confusing. Particularly when we have multishot on the
>>>> receive side, and this is identical, just for sends. Receives will keep
>>>> receiving as long as there are buffers in the provided group to receive
>>>> into, and sends will keep sending for the same condition. Either one
>>>> will terminate if we run out of buffers.
>>>>
>>>> If you make MSG_WAITALL be that for provided buffers + send, then that
>>>> behaves differently than MSG_WAITALL with receive, and MSG_WAITALL with
>>>> send _without_ provided buffers. I don't think overloading an existing
>>>> flag for this purposes is a good idea, particularly when we already have
>>>> the existing semantics for multishot on the receive side.
>>>
>>> I'm actually with Dylan on that and wonder where the perf win
>>> could come from. Let's assume TCP, sends are usually completed
>>> in the same syscall, otherwise your pacing is just bad. Thrift,
>>> for example, collects sends and packs into one multi iov request
>>> during a loop iteration. If the req completes immediately then
>>> the userspace just wouldn't have time to push more buffers by
>>> definition (assuming single threading).
>>
>> The problem only occurs when they don't complete inline, and now you get
>> reordering. The application could of course attempt to do proper pacing
>> and see if it can avoid that condition. If not, it now needs to
> 
> Ok, I admit that there are more than valid cases when artificial pacing
> is not an option, which is why I also laid out the polling case.
> Let's also say that limits potential perf wins to streaming and very
> large transfers (like files), not "lots of relatively small
> request-response" kinds of apps.

I don't think that's true - if you're doing large streaming, you're more
likely to keep the socket buffer full, whereas for smallish sends, it's
less likely to be full. Testing with the silly proxy confirms that. And
outside of cases where pacing just isn't feasible, it's extra overhead
for cases where you potentially could or what. To me, the main appeal of
this is the simplicity.

>> serialize sends. Using provided buffers makes this very easy, as you
>> don't need to care about it at all, and it eliminates complexity in the
>> application dealing with this.
> 
> If I'm correct the example also serialises sends(?). I don't
> think it's that simpler. You batch, you send. Same with this,
> but batch into a provided buffer and the send is conditional.

Do you mean the proxy example? Just want to be sure we're talking about
the same thing. Yes it has to serialize sends, because otherwise we can
run into the condition described in the patch that adds provided buffer
support for send. But I did bench multishot separately from there,
here's some of it:

10G network, 3 hosts, 1 acting as a mirror proxy shuffling N-byte packets.
Send ring and send multishot not used:

Pkt sz | Send ring | mshot |  usec  |  QPS  |  Bw
=====================================================
1000   |    No	   |  No   |   437  | 1.22M | 9598M
32     |    No	   |  No   |  5856  | 2.87M |  734M

Same test, now turn on send ring:

Pkt sz | Send ring | mshot |  usec  |  QPS  |  Bw   | Diff
===========================================================
1000   |    Yes	   |  No   |   436  | 1.23M | 9620M | + 0.2%
32     |    Yes	   |  No   |  3462  | 4.85M | 1237M | +68.5%

Same test, now turn on send mshot as well:

Pkt sz | Send ring | mshot |  usec  |  QPS  |  Bw   | Diff
===========================================================
1000   |    Yes	   |  Yes  |   436  | 1.23M | 9620M | + 0.2%
32     |    Yes	   |  Yes  |  3125  | 5.37M | 1374M | +87.2%

which does show that there's another win on top for just queueing these
sends and doing a single send to handle them, rather than needing to
prepare a send for each buffer. Part of that may be that you simply run
out of SQEs and then have to submit regardless of where you are at.

> Another downside is that you need a provided queue per socket,
> which sounds pretty expensive for 100s if not 1000s socket
> apps.

That's certainly true. But either you need backlog per socket anyway in
the app, or you only send single buffers anyway (in a typical
request/response kind of fashion) between receives and you don't need it
at all.

>>> If you actually need to poll tx, you send a request and collect
>>> data into iov in userspace in background. When the request
>>> completes you send all that in batch. You can probably find
>>> a niche example when batch=1 in this case, but I don't think
>>> anyone would care.
>>>
>>> The example doesn't use multi-iov, and also still has to
>>> serialise requests, which naturally serialises buffer consumption
>>> w/o provided bufs.
>>
>> IMHO there's no reason NOT to have both a send with provided buffers and
>> a multishot send. The alternative would be to have send-N, where you
>> pass in N. But I don't see much point to that over "just drain the whole
>> pending list". The obvious use case is definitely send multishot, but
> 
> Not sure I follow, but in all cases I was contemplating about
> you sends everything you have at the moment.
> 
>> what would the reasoning be to prohibit pacing by explicitly disallowing
>> only doing a single buffer (or a partial queue)? As mentioned earlier, I
>> like keeping the symmetry with the receive side for multishot, and not
>> make it any different unless there's a reason to.
> 
> There are different, buffer content kernel (rx) vs userspace (tx)
> provided, provided queue / group per socket vs shared. Wake ups
> for multishots as per below. It's not like it's a one line change,
> so IMHO requires to be giving some benefits.

Are you talking about provided buffers, or multishot specifically? I
think both are standalone pretty much as simple as they can be. And if
the argument is "just have send with provided buffers be multishot by
default", then that single patch is basically the two patches combined.
There's no simplification there. Outside of a strong argument for why it
would never make sense to do single shot send with provided buffers, I
really don't want to combine them into one single action.

>>>>> You do make a good point about MSG_WAITALL though - multishot send
>>>>> doesn't really make sense to me without MSG_WAITALL semantics. I
>>>>> cannot imagine a useful use case where the first buffer being
>>>>> partially sent will still want the second buffer sent.
>>>>
>>>> Right, and I need to tweak that. Maybe we require MSG_WAITALL, or we
>>>> make it implied for multishot send. Currently the code doesn't deal with
>>>> that.
>>>>
>>>> Maybe if MSG_WAITALL isn't set and we get a short send we don't set
>>>> CQE_F_MORE and we just stop. If it is set, then we go through the usual
>>>> retry logic. That would make it identical to MSG_WAITALL send without
>>>> multishot, which again is something I like in that we don't have
>>>> different behaviors depending on which mode we are using.
>>>>
>>>>>>> I actually could imagine it being useful for the previous patches' use
>>>>>>> case of queuing up sends and keeping ordering,
>>>>>>> and I think the API is more obvious (rather than the second CQE
>>>>>>> sending the first CQE's data). So maybe it's worth only
>>>>>>> keeping one approach?
>>>>>>
>>>>>> And here you totally lost me :-)
>>>>>
>>>>> I am suggesting here that you don't really need to support buffer
>>>>> lists on send without multishot.
>>>>
>>>> That is certainly true, but I also don't see a reason _not_ to support
>>>> it. Again mostly because this is how receive and everything else works.
>>>> The app is free to issue a single SQE for send without multishot, and
>>>> pick the first buffer and send it.
>>>
>>> Multishot sound interesting, but I don't see it much useful if
>>> you terminate when there are no buffers. Otherwise, if it continues
>>> to sit in, someone would have to wake it up
>>
>> I did think about the termination case, and the problem is that if there
>> are no buffers, you need it to wake when there are buffers. And at that
>> point you may as well just do another send, as you need the application
>> to trigger it. The alternative would be to invent a way to trigger that
>> wakeup, which would be send only and weird just because of that.
> 
> Yeah, that's the point, wake ups would be userspace driven, and how
> to do it without heavy stuff like syscalls is not so clear.

It's just not possible without eg polling, either directly or using some
monitor/mwait arch specific thing which would be awful. Or by doing some
manual wakeup, which would need to lookup and kick the request, which I
bet would be worse than just re-arming the send multishot.

If you could poll trigger it somehow, it also further complicates things
as now it could potentially happen at any time. As it stands, the app
knows when a poll multishot is armed (and submitted, or not), and can
serialize with the outgoing buffer queue trivially.

-- 
Jens Axboe


