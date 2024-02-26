Return-Path: <io-uring+bounces-766-lists+io-uring=lfdr.de@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [IPv6:2604:1380:4601:e00::3])
	by mail.lfdr.de (Postfix) with ESMTPS id B05FE868147
	for <lists+io-uring@lfdr.de>; Mon, 26 Feb 2024 20:42:51 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id 270591F21E58
	for <lists+io-uring@lfdr.de>; Mon, 26 Feb 2024 19:42:51 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 5687C12FF6A;
	Mon, 26 Feb 2024 19:42:04 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="HWJM+Y9m"
X-Original-To: io-uring@vger.kernel.org
Received: from mail-lj1-f175.google.com (mail-lj1-f175.google.com [209.85.208.175])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id F34471DFCD
	for <io-uring@vger.kernel.org>; Mon, 26 Feb 2024 19:42:01 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.208.175
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1708976524; cv=none; b=ISwue86XXfPTwWmt746QH12JqMSXF54BVZNUXGAYZtwtzBt4ekX05ikuLjELQkJnXnGdQmUS42gNXLNqTu/XP9hPvGw8FpPeb7I9nEK+DaDSJwu0+inWR+wpbaY1xr8YCDcBymKobqhzokkJq0jo0TfNw9af8en9tfrdAZSCe1E=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1708976524; c=relaxed/simple;
	bh=ECFktcGCcd4zh+g/qFOholFCqyocYYutgjEZWdIAyIg=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=Oi1eKp4dySqMfAOWR68PhOs4KwYMdnN08/DG77uHY4oLKU1fMfhXoCdOGUq8FGTI9Of1INi6kHPJdTTsvkP2A2XUYZoX+Jb924JPwv5+88j/a+wchzpzYDQN9R9sM9i2qELriDpEQfJ2wabijz8W8+HLzQP1ZdzkTLfzvAqyO9o=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=HWJM+Y9m; arc=none smtp.client-ip=209.85.208.175
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Received: by mail-lj1-f175.google.com with SMTP id 38308e7fff4ca-2d2533089f6so41862531fa.1
        for <io-uring@vger.kernel.org>; Mon, 26 Feb 2024 11:42:01 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1708976520; x=1709581320; darn=vger.kernel.org;
        h=content-transfer-encoding:in-reply-to:from:references:cc:to
         :content-language:subject:user-agent:mime-version:date:message-id
         :from:to:cc:subject:date:message-id:reply-to;
        bh=VPGmnPol1YFisBYmwUge6jKoFsz+yFOXJaBr+LwKKGs=;
        b=HWJM+Y9mIlVDzflw1pBjl0RhOainKFetBf+wgFzLQbHeoADMXBnbN4jPwDZJPzmopq
         mR4oZagCwEmTFQtqaWqmAu3UG9oDbGAtOCYq9YnJZtcjG7zTOfuqv8GcQ11OXeOBGoTq
         ssTiTBCQX69G9P+N5/8Xp8/zA2HWwY3RQQF7vogMqZr4yhoBbghZNGP+HouqTt4gldh8
         Cv4lljDGoKbpGiXUMf5bJmrjlhUx/NXiiv0wqF1+EBWmaxCYQ318+BAYULXQ8hf0TdIy
         sV0FCQWdsF5MHJbpH+tP0jmeAqx0Sr9FAo+YeKV5U2uQCs1nrBhIQ65No9jzCjIv1cqB
         9/PA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1708976520; x=1709581320;
        h=content-transfer-encoding:in-reply-to:from:references:cc:to
         :content-language:subject:user-agent:mime-version:date:message-id
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=VPGmnPol1YFisBYmwUge6jKoFsz+yFOXJaBr+LwKKGs=;
        b=WPVmehSJgBVt0yBcmf8Y+aLEaTu/7VNIZatrbtNN7gX6maT1J92E91kqjFX7IbIEBe
         91z+xhsjUgYbPwq8iCbAqn8efiXbD+eL5eBXgAD6Fx5RuuI4BJ3pwMLry9PEoEViUdYH
         H5InD3JijQc6avsJGAob0WdBrPeM8HGXybRuG2Q4bG9Ho+FgTWusgSxm7PTbdnC9XFXo
         se3hVTS3Q+N+1K6i3Pp24LToVsZY3YB564khfItZNas9/ha7IdWYK3SyHczzS/HqH4GK
         O1U3dwuyo/wcn90upIu8GnzCiFFl47beAJNix61NhXxL02gtDZ921JwgU+HflXqf/NoU
         bK0Q==
X-Gm-Message-State: AOJu0YzYs8w1UrQwwQCqXGYFtgqD1EgxzS0i6JRxHr90I4wuAgoumQTz
	WJaDScKOxD0aZjNHYfrojZwNtU5eNVQ1Xm7euum+pHJ5r3ugCFE/qqx2LIx9
X-Google-Smtp-Source: AGHT+IHNY4eHJjpgkVNdwzXxx4hQ7XD0GQJFAcdEC6UV+yuimYma3am+izc3JiOU2uRY5Y8etZ8mhQ==
X-Received: by 2002:a2e:801a:0:b0:2d2:61e8:44eb with SMTP id j26-20020a2e801a000000b002d261e844ebmr4972208ljg.33.1708976519693;
        Mon, 26 Feb 2024 11:41:59 -0800 (PST)
Received: from [192.168.8.100] ([185.69.144.12])
        by smtp.gmail.com with ESMTPSA id m4-20020a05600c4f4400b004128d6ddad3sm13349214wmq.0.2024.02.26.11.41.59
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Mon, 26 Feb 2024 11:41:59 -0800 (PST)
Message-ID: <68adc174-802a-455d-b6ca-a6908e592689@gmail.com>
Date: Mon, 26 Feb 2024 19:21:38 +0000
Precedence: bulk
X-Mailing-List: io-uring@vger.kernel.org
List-Id: <io-uring.vger.kernel.org>
List-Subscribe: <mailto:io-uring+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:io-uring+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH 6/8] io_uring/net: support multishot for send
Content-Language: en-US
To: Jens Axboe <axboe@kernel.dk>, Dylan Yudaken <dyudaken@gmail.com>
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
From: Pavel Begunkov <asml.silence@gmail.com>
In-Reply-To: <4823c201-8c5d-4a4f-a77e-bd3e6c239cbe@kernel.dk>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit

On 2/26/24 19:11, Jens Axboe wrote:
> On 2/26/24 8:41 AM, Pavel Begunkov wrote:
>> On 2/26/24 15:16, Jens Axboe wrote:
>>> On 2/26/24 7:36 AM, Pavel Begunkov wrote:
>>>> On 2/26/24 14:27, Jens Axboe wrote:
>>>>> On 2/26/24 7:02 AM, Dylan Yudaken wrote:
>>>>>> On Mon, Feb 26, 2024 at 1:38?PM Jens Axboe <axboe@kernel.dk> wrote:
>>>>>>>
>>>>>>> On 2/26/24 3:47 AM, Dylan Yudaken wrote:
>>>>>>>> On Sun, Feb 25, 2024 at 12:46?AM Jens Axboe <axboe@kernel.dk> wrote:
>>>>>>>>>
>>>>>>>>> This works very much like the receive side, except for sends. The idea
>>>>>>>>> is that an application can fill outgoing buffers in a provided buffer
>>>>>>>>> group, and then arm a single send that will service them all. For now
>>>>>>>>> this variant just terminates when we are out of buffers to send, and
>>>>>>>>> hence the application needs to re-arm it if IORING_CQE_F_MORE isn't
>>>>>>>>> set, as per usual for multishot requests.
>>>>>>>>>
>>>>>>>>
>>>>>>>> This feels to me a lot like just using OP_SEND with MSG_WAITALL as
>>>>>>>> described, unless I'm missing something?
>>>>>>>
>>>>>>> How so? MSG_WAITALL is "send X amount of data, and if it's a short send,
>>>>>>> try again" where multishot is "send data from this buffer group, and
>>>>>>> keep sending data until it's empty". Hence it's the mirror of multishot
>>>>>>> on the receive side. Unless I'm misunderstanding you somehow, not sure
>>>>>>> it'd be smart to add special meaning to MSG_WAITALL with provided
>>>>>>> buffers.
>>>>>>>
>>>>>>
>>>>>> _If_ you have the data upfront these are very similar, and only differ
>>>>>> in that the multishot approach will give you more granular progress
>>>>>> updates. My point was that this might not be a valuable API to people
>>>>>> for only this use case.
>>>>>
>>>>> Not sure I agree, it feels like attributing a different meaning to
>>>>> MSG_WAITALL if you use a provided buffer vs if you don't. And that to me
>>>>> would seem to be confusing. Particularly when we have multishot on the
>>>>> receive side, and this is identical, just for sends. Receives will keep
>>>>> receiving as long as there are buffers in the provided group to receive
>>>>> into, and sends will keep sending for the same condition. Either one
>>>>> will terminate if we run out of buffers.
>>>>>
>>>>> If you make MSG_WAITALL be that for provided buffers + send, then that
>>>>> behaves differently than MSG_WAITALL with receive, and MSG_WAITALL with
>>>>> send _without_ provided buffers. I don't think overloading an existing
>>>>> flag for this purposes is a good idea, particularly when we already have
>>>>> the existing semantics for multishot on the receive side.
>>>>
>>>> I'm actually with Dylan on that and wonder where the perf win
>>>> could come from. Let's assume TCP, sends are usually completed
>>>> in the same syscall, otherwise your pacing is just bad. Thrift,
>>>> for example, collects sends and packs into one multi iov request
>>>> during a loop iteration. If the req completes immediately then
>>>> the userspace just wouldn't have time to push more buffers by
>>>> definition (assuming single threading).
>>>
>>> The problem only occurs when they don't complete inline, and now you get
>>> reordering. The application could of course attempt to do proper pacing
>>> and see if it can avoid that condition. If not, it now needs to
>>
>> Ok, I admit that there are more than valid cases when artificial pacing
>> is not an option, which is why I also laid out the polling case.
>> Let's also say that limits potential perf wins to streaming and very
>> large transfers (like files), not "lots of relatively small
>> request-response" kinds of apps.
> 
> I don't think that's true - if you're doing large streaming, you're more
> likely to keep the socket buffer full, whereas for smallish sends, it's
> less likely to be full. Testing with the silly proxy confirms that. And

I don't see any contradiction to what I said. With streaming/large
sends it's more likely to be polled. For small sends and
send-receive-send-... patterns the sock queue is unlikely to be
full, in which case the send is processed inline, and so the
feature doesn't add performance, as you agreed a couple email
before.

> outside of cases where pacing just isn't feasible, it's extra overhead
> for cases where you potentially could or what.

I lost it, what overhead?

> To me, the main appeal of this is the simplicity.

I'd argue it doesn't seem any simpler than the alternative.

>>> serialize sends. Using provided buffers makes this very easy, as you
>>> don't need to care about it at all, and it eliminates complexity in the
>>> application dealing with this.
>>
>> If I'm correct the example also serialises sends(?). I don't
>> think it's that simpler. You batch, you send. Same with this,
>> but batch into a provided buffer and the send is conditional.
> 
> Do you mean the proxy example? Just want to be sure we're talking about

Yes, proxy, the one you referenced in the CV. And FWIW, I don't
think it's a fair comparison without batching followed by multi-iov.

> the same thing. Yes it has to serialize sends, because otherwise we can
> run into the condition described in the patch that adds provided buffer
> support for send. But I did bench multishot separately from there,
> here's some of it:
> 
> 10G network, 3 hosts, 1 acting as a mirror proxy shuffling N-byte packets.
> Send ring and send multishot not used:
> 
> Pkt sz | Send ring | mshot |  usec  |  QPS  |  Bw
> =====================================================
> 1000   |    No	   |  No   |   437  | 1.22M | 9598M
> 32     |    No	   |  No   |  5856  | 2.87M |  734M
> 
> Same test, now turn on send ring:
> 
> Pkt sz | Send ring | mshot |  usec  |  QPS  |  Bw   | Diff
> ===========================================================
> 1000   |    Yes	   |  No   |   436  | 1.23M | 9620M | + 0.2%
> 32     |    Yes	   |  No   |  3462  | 4.85M | 1237M | +68.5%
> 
> Same test, now turn on send mshot as well:
> 
> Pkt sz | Send ring | mshot |  usec  |  QPS  |  Bw   | Diff
> ===========================================================
> 1000   |    Yes	   |  Yes  |   436  | 1.23M | 9620M | + 0.2%
> 32     |    Yes	   |  Yes  |  3125  | 5.37M | 1374M | +87.2%
> 
> which does show that there's another win on top for just queueing these
> sends and doing a single send to handle them, rather than needing to
> prepare a send for each buffer. Part of that may be that you simply run
> out of SQEs and then have to submit regardless of where you are at.

How many sockets did you test with? It's 1 SQE per sock max

+87% sounds like a huge difference, and I don't understand where
it comes from, hence the question

>> Another downside is that you need a provided queue per socket,
>> which sounds pretty expensive for 100s if not 1000s socket
>> apps.
> 
> That's certainly true. But either you need backlog per socket anyway in
> the app, or you only send single buffers anyway (in a typical
> request/response kind of fashion) between receives and you don't need it
> at all.

That's pinning pages and maping them, which surely is not bad
but with everything else equal malloc()/stack alloc is much
nicer in terms of resources. (Not talking about CPU setup
overhead).

>>>> If you actually need to poll tx, you send a request and collect
>>>> data into iov in userspace in background. When the request
>>>> completes you send all that in batch. You can probably find
>>>> a niche example when batch=1 in this case, but I don't think
>>>> anyone would care.
>>>>
>>>> The example doesn't use multi-iov, and also still has to
>>>> serialise requests, which naturally serialises buffer consumption
>>>> w/o provided bufs.
>>>
>>> IMHO there's no reason NOT to have both a send with provided buffers and
>>> a multishot send. The alternative would be to have send-N, where you
>>> pass in N. But I don't see much point to that over "just drain the whole
>>> pending list". The obvious use case is definitely send multishot, but
>>
>> Not sure I follow, but in all cases I was contemplating about
>> you sends everything you have at the moment.
>>
>>> what would the reasoning be to prohibit pacing by explicitly disallowing
>>> only doing a single buffer (or a partial queue)? As mentioned earlier, I
>>> like keeping the symmetry with the receive side for multishot, and not
>>> make it any different unless there's a reason to.
>>
>> There are different, buffer content kernel (rx) vs userspace (tx)
>> provided, provided queue / group per socket vs shared. Wake ups
>> for multishots as per below. It's not like it's a one line change,
>> so IMHO requires to be giving some benefits.
> 
> Are you talking about provided buffers, or multishot specifically? I

I assumed that any of them would retry until the queue is exhausted,
at least that sounds more efficient and used in all comments.

> think both are standalone pretty much as simple as they can be. And if
> the argument is "just have send with provided buffers be multishot by
> default",

It's not, rx and tx are different, e.g. true tx multishot doesn't
seem to be possible because of that.

> then that single patch is basically the two patches combined.
> There's no simplification there. Outside of a strong argument for why it
> would never make sense to do single shot send with provided buffers, I
> really don't want to combine them into one single action.

In the current form it does make more sense to have
multishot optionally.

>>>>>> You do make a good point about MSG_WAITALL though - multishot send
>>>>>> doesn't really make sense to me without MSG_WAITALL semantics. I
>>>>>> cannot imagine a useful use case where the first buffer being
>>>>>> partially sent will still want the second buffer sent.
>>>>>
>>>>> Right, and I need to tweak that. Maybe we require MSG_WAITALL, or we
>>>>> make it implied for multishot send. Currently the code doesn't deal with
>>>>> that.
>>>>>
>>>>> Maybe if MSG_WAITALL isn't set and we get a short send we don't set
>>>>> CQE_F_MORE and we just stop. If it is set, then we go through the usual
>>>>> retry logic. That would make it identical to MSG_WAITALL send without
>>>>> multishot, which again is something I like in that we don't have
>>>>> different behaviors depending on which mode we are using.
>>>>>
>>>>>>>> I actually could imagine it being useful for the previous patches' use
>>>>>>>> case of queuing up sends and keeping ordering,
>>>>>>>> and I think the API is more obvious (rather than the second CQE
>>>>>>>> sending the first CQE's data). So maybe it's worth only
>>>>>>>> keeping one approach?
>>>>>>>
>>>>>>> And here you totally lost me :-)
>>>>>>
>>>>>> I am suggesting here that you don't really need to support buffer
>>>>>> lists on send without multishot.
>>>>>
>>>>> That is certainly true, but I also don't see a reason _not_ to support
>>>>> it. Again mostly because this is how receive and everything else works.
>>>>> The app is free to issue a single SQE for send without multishot, and
>>>>> pick the first buffer and send it.
>>>>
>>>> Multishot sound interesting, but I don't see it much useful if
>>>> you terminate when there are no buffers. Otherwise, if it continues
>>>> to sit in, someone would have to wake it up
>>>
>>> I did think about the termination case, and the problem is that if there
>>> are no buffers, you need it to wake when there are buffers. And at that
>>> point you may as well just do another send, as you need the application
>>> to trigger it. The alternative would be to invent a way to trigger that
>>> wakeup, which would be send only and weird just because of that.
>>
>> Yeah, that's the point, wake ups would be userspace driven, and how
>> to do it without heavy stuff like syscalls is not so clear.
> 
> It's just not possible without eg polling, either directly or using some
> monitor/mwait arch specific thing which would be awful. Or by doing some
> manual wakeup, which would need to lookup and kick the request, which I
> bet would be worse than just re-arming the send multishot.

Right

> If you could poll trigger it somehow, it also further complicates things
> as now it could potentially happen at any time. As it stands, the app
> knows when a poll multishot is armed (and submitted, or not), and can
> serialize with the outgoing buffer queue trivially.

-- 
Pavel Begunkov

