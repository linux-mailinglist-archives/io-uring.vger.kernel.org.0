Return-Path: <io-uring+bounces-3595-lists+io-uring=lfdr.de@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [147.75.199.223])
	by mail.lfdr.de (Postfix) with ESMTPS id 28B0399A69B
	for <lists+io-uring@lfdr.de>; Fri, 11 Oct 2024 16:41:52 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id 308B01C222DD
	for <lists+io-uring@lfdr.de>; Fri, 11 Oct 2024 14:41:51 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id ACBEB1917D9;
	Fri, 11 Oct 2024 14:41:08 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel-dk.20230601.gappssmtp.com header.i=@kernel-dk.20230601.gappssmtp.com header.b="UuZUcN0O"
X-Original-To: io-uring@vger.kernel.org
Received: from mail-il1-f176.google.com (mail-il1-f176.google.com [209.85.166.176])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1D250184
	for <io-uring@vger.kernel.org>; Fri, 11 Oct 2024 14:41:05 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.166.176
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1728657668; cv=none; b=fpEI2SOKeHpg72tGnW51dCgjvSLbxeS8p3o59drz02I2jhPCat8Yxy10+YHZ6HLM0WpOohb2ZaAkLS9asawLWciQJfGlsJ9tPb3lW/E1Wz3uQr9vs8BEn33MVqsQ5DPMGvTC/y9gHezx6OesZbTNlORjnVzEjvZmjqfvXNBR9J0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1728657668; c=relaxed/simple;
	bh=24vOxEbM5v2mpKTSo9IDTPajc/ESodcw2DlremmkyN8=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=GLC4263EckgIW9dpeBKBBBNWyxMEIjnahoymRyA1BIxlUhZYiX1fACFH/EkPjB0U6Js9Y+pdYw5j67ipjn/kOUjy6wfofJYZlDh30q2Dta0xQKmpEF5Jd7szXjVkwHejD3vDTnLwzFiuyfkHpx4ylkKdY4CrnZwpgFeRSQmjB0Q=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=kernel.dk; spf=pass smtp.mailfrom=kernel.dk; dkim=pass (2048-bit key) header.d=kernel-dk.20230601.gappssmtp.com header.i=@kernel-dk.20230601.gappssmtp.com header.b=UuZUcN0O; arc=none smtp.client-ip=209.85.166.176
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=kernel.dk
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=kernel.dk
Received: by mail-il1-f176.google.com with SMTP id e9e14a558f8ab-3a3b8964134so1530605ab.1
        for <io-uring@vger.kernel.org>; Fri, 11 Oct 2024 07:41:05 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernel-dk.20230601.gappssmtp.com; s=20230601; t=1728657665; x=1729262465; darn=vger.kernel.org;
        h=content-transfer-encoding:in-reply-to:from:content-language
         :references:cc:to:subject:user-agent:mime-version:date:message-id
         :from:to:cc:subject:date:message-id:reply-to;
        bh=L3nDY1J+xaAYSG0mTzcOLz1kZRVUPIr+mr42Y0Twm8g=;
        b=UuZUcN0OXneyLfylNU3zM2VbmT2GNpBbNxBuCjdjXr/CpaUCtNK4Ftl0ZKXhRmMRQC
         1/VVGSVFDeBihrfrkbMAdBJm0OHtFXTthhsrgHZ86jm5WDc3qua6F3+OdOyIgzuojUnJ
         6F+74wiwQaMuRV8GoWKKSAJ8KLsY2NQKoZnsEoJvqrV/6gME3438HPQ7HesnJi4P5ACT
         tuEpZXbtNTop7+/yO3pEq7ciHzA458Aanwdsw59GQYuQ5khh/NKQPymd5b53ZpHbTrpn
         2XmAe24bXDiKi3/ijDI+1XCGtKbdjAP6Bo65HpXjPJws7wM2T7LPb7uaP5wCfDkQ8m8R
         4MXA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1728657665; x=1729262465;
        h=content-transfer-encoding:in-reply-to:from:content-language
         :references:cc:to:subject:user-agent:mime-version:date:message-id
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=L3nDY1J+xaAYSG0mTzcOLz1kZRVUPIr+mr42Y0Twm8g=;
        b=ahQ9M9TwuWhhnPwR45Wj1x2RYEnQfQEgWng4nXT3I18wAjL8T3W5juRVxhvT8k8Ug9
         KoJM9V8hW4l5ZWUqQ2HZzSI1oODbn/wzsfVkIgozvhQkk72UIvC39zV9rkEd/p11fUe7
         j6epmOS7JQCecngtFwMsH7Gys2GqOm7RXLZHX++1KBpgUxUyASsmXa8bq/+/Py3Vv2yZ
         xco53TyIoUocbjn/dumYZ93aI54OHfWPA4PwDVLON38KOID83o6CZ9cAnLe5jMv6TznV
         F01+qwDik56BmFBcEe7PchnnwBq8OHW/ZtKpERCKTWj9HOdkSOIx9jZhza2dbYPpqY8k
         GtSw==
X-Forwarded-Encrypted: i=1; AJvYcCWem0aUpemRGT3PWaJPYkfyxqJhVn7Pr2Za8jtEmQlr3j3Y5M2CeD2fAtwbAoS6L9JeyXKGw7+RZw==@vger.kernel.org
X-Gm-Message-State: AOJu0Yyq9BXbDDWKNI77TPFHPz/f5lsHWNuN/GjoPzhL4cHocxmXSpWS
	X4jEAdcLQFGVeZICvenH18U3hgnTcUJXh3sxy681pNuwUal9uEh8/QV8D/0yv+k=
X-Google-Smtp-Source: AGHT+IGraweo5GKz9NV7nh+qfLh22ndfaU0TYAo54d3y+GCvOlkkhzplNv6QiPtMF4YvJ4oyZnDUfA==
X-Received: by 2002:a05:6e02:1e04:b0:3a3:968b:4e3f with SMTP id e9e14a558f8ab-3a3b5fb635bmr18489995ab.18.1728657665103;
        Fri, 11 Oct 2024 07:41:05 -0700 (PDT)
Received: from [192.168.1.116] ([96.43.243.2])
        by smtp.gmail.com with ESMTPSA id e9e14a558f8ab-3a3afde8ebdsm7443535ab.88.2024.10.11.07.41.04
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Fri, 11 Oct 2024 07:41:04 -0700 (PDT)
Message-ID: <a7eefe36-55fd-48f7-b05b-afed16a32d0c@kernel.dk>
Date: Fri, 11 Oct 2024 08:41:03 -0600
Precedence: bulk
X-Mailing-List: io-uring@vger.kernel.org
List-Id: <io-uring.vger.kernel.org>
List-Subscribe: <mailto:io-uring+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:io-uring+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH V6 7/8] io_uring/uring_cmd: support provide group kernel
 buffer
To: Ming Lei <ming.lei@redhat.com>
Cc: Pavel Begunkov <asml.silence@gmail.com>, io-uring@vger.kernel.org,
 linux-block@vger.kernel.org
References: <b232fa58-1255-44b2-92c9-f8eb4f70e2c9@gmail.com>
 <ZwJObC6mzetw4goe@fedora> <38ad4c05-6ee3-4839-8d61-f8e1b5219556@gmail.com>
 <ZwdJ7sDuHhWT61FR@fedora> <4b40eff1-a848-4742-9cb3-541bf8ed606e@gmail.com>
 <655b3348-27a1-4bc7-ade7-4d958a692d0b@kernel.dk> <ZwiN0Ioy2Y7cfnTI@fedora>
 <44028492-3681-4cd4-8ae2-ef7139ad50ad@kernel.dk> <ZwiWdO6SS_jlkYrM@fedora>
 <051e74c9-c5b4-40d7-9024-b4bd3f5d0a0f@kernel.dk> <Zwk0SQBiTUBLNvj0@fedora>
Content-Language: en-US
From: Jens Axboe <axboe@kernel.dk>
In-Reply-To: <Zwk0SQBiTUBLNvj0@fedora>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit

On 10/11/24 8:20 AM, Ming Lei wrote:
> On Fri, Oct 11, 2024 at 07:24:27AM -0600, Jens Axboe wrote:
>> On 10/10/24 9:07 PM, Ming Lei wrote:
>>> On Thu, Oct 10, 2024 at 08:39:12PM -0600, Jens Axboe wrote:
>>>> On 10/10/24 8:30 PM, Ming Lei wrote:
>>>>> Hi Jens,
>>>>>
>>>>> On Thu, Oct 10, 2024 at 01:31:21PM -0600, Jens Axboe wrote:
>>>>>> Hi,
>>>>>>
>>>>>> Discussed this with Pavel, and on his suggestion, I tried prototyping a
>>>>>> "buffer update" opcode. Basically it works like
>>>>>> IORING_REGISTER_BUFFERS_UPDATE in that it can update an existing buffer
>>>>>> registration. But it works as an sqe rather than being a sync opcode.
>>>>>>
>>>>>> The idea here is that you could do that upfront, or as part of a chain,
>>>>>> and have it be generically available, just like any other buffer that
>>>>>> was registered upfront. You do need an empty table registered first,
>>>>>> which can just be sparse. And since you can pick the slot it goes into,
>>>>>> you can rely on that slot afterwards (either as a link, or just the
>>>>>> following sqe).
>>>>>>
>>>>>> Quick'n dirty obviously, but I did write a quick test case too to verify
>>>>>> that:
>>>>>>
>>>>>> 1) It actually works (it seems to)
>>>>>
>>>>> It doesn't work for ublk zc since ublk needs to provide one kernel buffer
>>>>> for fs rw & net send/recv to consume, and the kernel buffer is invisible
>>>>> to userspace. But  __io_register_rsrc_update() only can register userspace
>>>>> buffer.
>>>>
>>>> I'd be surprised if this simple one was enough! In terms of user vs
>>>> kernel buffer, you could certainly use the same mechanism, and just
>>>> ensure that buffers are tagged appropriately. I need to think about that
>>>> a little bit.
>>>
>>> It is actually same with IORING_OP_PROVIDE_BUFFERS, so the following
>>> consumer OPs have to wait until this OP_BUF_UPDATE is completed.
>>
>> See below for the registered vs provided buffer confusion that seems to
>> be a confusion issue here.
>>
>>> Suppose we have N consumers OPs which depends on OP_BUF_UPDATE.
>>>
>>> 1) all N OPs are linked with OP_BUF_UPDATE
>>>
>>> Or
>>>
>>> 2) submit OP_BUF_UPDATE first, and wait its completion, then submit N
>>> OPs concurrently.
>>
>> Correct
>>
>>> But 1) and 2) may slow the IO handing.  In 1) all N OPs are serialized,
>>> and 1 extra syscall is introduced in 2).
>>
>> Yes you don't want do do #1. But the OP_BUF_UPDATE is cheap enough that
>> you can just do it upfront. It's not ideal in terms of usage, and I get
>> where the grouping comes from. But is it possible to do the grouping in
>> a less intrusive fashion with OP_BUF_UPDATE? Because it won't change any
> 
> The most of 'intrusive' change is just on patch 4, and Pavel has commented
> that it is good enough:
> 
> https://lore.kernel.org/linux-block/ZwZzsPcXyazyeZnu@fedora/T/#m551e94f080b80ccbd2561e01da5ea8e17f7ee15d

At least for me, patch 4 looks fine. The problem occurs when you start
needing to support this different buffer type, which is in patch 6. I'm
not saying we can necessarily solve this with OP_BUF_UPDATE, I just want
to explore that path because if we can, then patch 6 turns into "oh
let's just added registered/fixed buffer support to these ops that don't
currently support it". And that would be much nicer indeed.


>> of the other ops in terms of buffer consumption, they'd just need fixed
>> buffer support and you'd flag the buffer index in sqe->buf_index. And
>> the nice thing about that is that while fixed/registered buffers aren't
>> really used on the networking side yet (as they don't bring any benefit
>> yet), adding support for them could potentially be useful down the line
>> anyway.
> 
> With 2), two extra syscalls are added for each ublk IO, one is provide
> buffer, another is remove buffer. The two syscalls have to be sync with
> consumer OPs.
> 
> I can understand the concern, but if the change can't improve perf or
> even slow things done, it loses its value.

It'd be one extra syscall, as the remove can get bundled with the next
add. But your point still stands, yes it will add extra overhead,
although be it pretty darn minimal. I'm actually more concerned with the
complexity for handling it. While the OP_BUF_UPDATE will always
complete immediately, there's no guarantee it's the next cqe you pull
out when peeking post submission.

>>> The same thing exists in the next OP_BUF_UPDATE which has to wait until
>>> all the previous buffer consumers are done. So the same slow thing are
>>> doubled. Not mention the application will become more complicated.
>>
>> It does not, you can do an update on a buffer that's already inflight.
> 
> UPDATE may not match the case, actually two OPs are needed, one is
> provide buffer OP and the other is remove buffer OP, both have to deal
> with the other subsystem(ublk). Remove buffer needs to be done after all
> consumer OPs are done immediately.

You don't necessarily need the remove. If you always just use the same
slot for these, then the OP_BUF_UPDATE will just update the current
location.

> I guess you mean the buffer is reference-counted, but what if the remove
> buffer OP is run before any consumer OP? The order has to be enhanced.
> 
> That is why I mention two syscalls are added.

See above, you can just update in place, and if you do want remove, it
can get bundled with the next one. But it would be pointless to remove
only then to update right after, a single update would suffice.

>>> Here the provided buffer is only visible among the N OPs wide, and making
>>> it global isn't necessary, and slow things down. And has kbuf lifetime
>>> issue.
>>
>> I was worried about it being too slow too, but the basic testing seems
>> like it's fine. Yes with updates inflight it'll make it a tad bit
>> slower, but really should not be a concern. I'd argue that even doing
>> the very basic of things, which would be:
>>
>> 1) Submit OP_BUF_UPDATE, get completion
>> 2) Do the rest of the ops
> 
> The above adds one syscall for each ublk IO, and the following Remove
> buffer adds another syscall.
> 
> Not only it slows thing down, but also makes application more
> complicated, cause two wait points are added.

I don't think the extra overhead would be noticeable though, but the
extra complication is the main issue here.

>> would be totally fine in terms of performance. OP_BUF_UPDATE will
>> _always_ completely immediately and inline, which means that it'll
>> _always_ be immediately available post submission. The only think you'd
>> ever have to worry about in terms of failure is a badly formed request,
>> which is a programming issue, or running out of memory on the host.
>>
>>> Also it makes error handling more complicated, io_uring has to remove
>>> the kernel buffer when the current task is exit, dependency or order with
>>> buffer provider is introduced.
>>
>> Why would that be? They belong to the ring, so should be torn down as
>> part of the ring anyway? Why would they be task-private, but not
>> ring-private?
> 
> It is kernel buffer, which belongs to provider(such as ublk) instead
> of uring, application may panic any time, then io_uring has to remove
> the buffer for notifying the buffer owner.

But it could be an application buffer, no? You'd just need the
application to provide it to ublk and have it mapped, rather than have
ublk allocate it in-kernel and then use that.

> In concept grouping is simpler because:
> 
> - buffer lifetime is aligned with group leader lifetime, so we needn't
> worry buffer leak because of application accidental exit

But if it was an application buffer, that would not be a concern.

> - the buffer is borrowed to consumer OPs, and returned back after all
> consumers are done, this way avoids any dependency
> 
> Meantime OP_BUF_UPDATE(provide buffer OP, remove buffer OP) becomes more
> complicated:
> 
> - buffer leak because of app panic
> - buffer dependency issue: consumer OPs depend on provide buffer OP,
> 	remove buffer OP depends on consumer OPs; two syscalls has to be
> 	added for handling single ublk IO.

Seems like most of this is because of the kernel buffer too, no?

I do like the concept of the ephemeral buffer, the downside is that we
need per-op support for it too. And while I'm not totally against doing
that, it would be lovely if we could utilize and existing mechanism for
that rather than add another one.

>>>> There are certainly many different ways that can get propagated which
>>>> would not entail a complicated mechanism. I really like the aspect of
>>>> having the identifier being the same thing that we already use, and
>>>> hence not needing to be something new on the side.
>>>>
>>>>> Also multiple OPs may consume the buffer concurrently, which can't be
>>>>> supported by buffer select.
>>>>
>>>> Why not? You can certainly have multiple ops using the same registered
>>>> buffer concurrently right now.
>>>
>>> Please see the above problem.
>>>
>>> Also I remember that the selected buffer is removed from buffer list,
>>> see io_provided_buffer_select(), but maybe I am wrong.
>>
>> You're mixing up provided and registered buffers. Provided buffers are
>> ones that the applications gives to the kernel, and the kernel grabs and
>> consumes them. Then the application replenishes, repeat.
>>
>> Registered buffers are entirely different, those are registered with the
>> kernel and we can do things like pre-gup the pages so we don't have to
>> do them for every IO. They are entirely persistent, any multiple ops can
>> keep using them, concurrently. They don't get consumed by an IO like
>> provided buffers, they remain in place until they get unregistered (or
>> updated, like my patch) at some point.
> 
> I know the difference.

But io_provided_buffer_select() has nothing to do with registered/fixed
buffers or this use case, the above "remove from buffer list" is an
entirely different buffer concept. So there's some confusion here, just
wanted to make that clear.

> The thing is that here we can't register the kernel buffer in ->prep(),
> and it has to be provided in ->issue() of uring command. That is similar
> with provided buffer.

What's preventing it from registering it in ->prep()? It would be a bit
odd, but there would be nothing preventing it codewise, outside of the
oddity of ->prep() not being idempotent at that point. Don't follow why
that would be necessary, though, can you expand?

-- 
Jens Axboe

