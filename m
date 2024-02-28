Return-Path: <io-uring+bounces-796-lists+io-uring=lfdr.de@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [IPv6:2604:1380:45e3:2400::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 5B38786B5FA
	for <lists+io-uring@lfdr.de>; Wed, 28 Feb 2024 18:29:08 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 10796282DB4
	for <lists+io-uring@lfdr.de>; Wed, 28 Feb 2024 17:29:07 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 67C0E3FBA2;
	Wed, 28 Feb 2024 17:29:02 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel-dk.20230601.gappssmtp.com header.i=@kernel-dk.20230601.gappssmtp.com header.b="dK7jdwjf"
X-Original-To: io-uring@vger.kernel.org
Received: from mail-pj1-f46.google.com (mail-pj1-f46.google.com [209.85.216.46])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 32CE434CDE
	for <io-uring@vger.kernel.org>; Wed, 28 Feb 2024 17:28:57 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.216.46
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1709141342; cv=none; b=D9uUPBmIfxuW1FPyatkWxNG1W524IX5NUZPinFMv+KoiVRrUICRnJFSRW/7iJlXmvUG6KLKjfcsgCLR86oQcs/2mh3Zf3C1BfsoKQYh+YpqacHZsLyja9+6A+mpu8V5lLFiLc0VX7nMm/ZuqNQsplSRjf7UcXJo3FG7qV1TOyco=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1709141342; c=relaxed/simple;
	bh=fKt4B9cK7bXA5bNxctMBZrgesQFWqbPHqfjU6aKkLPA=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=EbORVDl2AVHo89J5eEdWgWBLrt2csj1z6bwArRRbo+rfY9LB1gVic0dPJCeKRzEeeHJxQ/zvajVDAtvXT4vKEThC1WDvEQedd1ZplaSOwBV+sn/EXrUO5xpnomP/lApO1eYlG0lgKL1vS70gFhrt/zy8l8L0B9nTHYrR/8T8J/8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=kernel.dk; spf=pass smtp.mailfrom=kernel.dk; dkim=pass (2048-bit key) header.d=kernel-dk.20230601.gappssmtp.com header.i=@kernel-dk.20230601.gappssmtp.com header.b=dK7jdwjf; arc=none smtp.client-ip=209.85.216.46
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=kernel.dk
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=kernel.dk
Received: by mail-pj1-f46.google.com with SMTP id 98e67ed59e1d1-29ae0d292d4so396641a91.0
        for <io-uring@vger.kernel.org>; Wed, 28 Feb 2024 09:28:57 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernel-dk.20230601.gappssmtp.com; s=20230601; t=1709141337; x=1709746137; darn=vger.kernel.org;
        h=content-transfer-encoding:in-reply-to:from:references:cc:to
         :content-language:subject:user-agent:mime-version:date:message-id
         :from:to:cc:subject:date:message-id:reply-to;
        bh=mWJtIJ/cpKPyz3jnqN+emvnZAuH9SZt3eHQhhPRFN0A=;
        b=dK7jdwjf8HkakCA7YKFgDv6vT3y8xsAX8LEMOAvEeZbvG4C1hUvW+QactPoqXl0Zxv
         MbyUmjvLUM1yUGFjMjUoZR68dqEbhronAKYsPo/POogyZLfj7YeiKx89RGFuMDhs6jPO
         U8LYuLtWnpypl2oNH8vsE2r7bidDMy+2doCrk5ywtc0Elq29+mMzApJwSNcqeKlzX0L5
         ZW0yfv1nQdowt05VscavmFlarEGl4bPXiccmGPudyBmbk5wWDhprYkeYoAZVeGGh8xdB
         Bi+xsL7vxzVFWksjZtHkQKmqE/7HeyVOx4aTgjGRELAmHDmL/JoLYT5P+X6LkQVJ76Jb
         mNBA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1709141337; x=1709746137;
        h=content-transfer-encoding:in-reply-to:from:references:cc:to
         :content-language:subject:user-agent:mime-version:date:message-id
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=mWJtIJ/cpKPyz3jnqN+emvnZAuH9SZt3eHQhhPRFN0A=;
        b=i2L9lQlbIjbWWWbIrUXx/1umkk2m+PbT0OW/532AWFi7/tUkJ5SEFZDUFyAGJpBR6m
         OMC0/AvjWZPvtwzqG4nuFXvlwd99MBZb7WGsX9iRluapWueWU3pDVNEwYaUvxw/v9hd7
         EC0PfmXeSPZ07wOfo+z+wkpsF4HI4pNjyvkrO070DNS4rDFvdKDcrknu1D0eKCMOWiBQ
         CFI6GdSZ5v5zZ4HANuMQBSGy1m+yYbKFAqFc3gC+GVT2iu/r9fBSKAd1CGQc5Z/tfBZA
         Vw9N0tGjRyVQJF+7RrpDNv7J+XlPT4BhvmRFJXevpwDcnlZoD/fhlgWNXlIEFWdp2Xu/
         mzew==
X-Gm-Message-State: AOJu0YxXWn3PEzoB8Yud8zyhNnymFETkqa6dyC/CLhOjw7eshAm+59MN
	dADzFSujr5OXLDPU9ncwxEHnX3ZdytrgtzBab9GK+epqZscCfOwuXjIohAZWLPg=
X-Google-Smtp-Source: AGHT+IFPCDxX4a5gavQIR2UhNeS7C5tFvYP5gXbIITazbMRs475btHbIMG2AeNf91mtL2fofeZTsIg==
X-Received: by 2002:a17:90a:17e4:b0:29a:4f72:28e with SMTP id q91-20020a17090a17e400b0029a4f72028emr11398358pja.2.1709141337285;
        Wed, 28 Feb 2024 09:28:57 -0800 (PST)
Received: from [192.168.1.150] ([198.8.77.194])
        by smtp.gmail.com with ESMTPSA id t16-20020a17090a0d1000b0029942a73eaesm2076714pja.9.2024.02.28.09.28.56
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Wed, 28 Feb 2024 09:28:56 -0800 (PST)
Message-ID: <0e02646e-589d-41da-afcb-d885150800e6@kernel.dk>
Date: Wed, 28 Feb 2024 10:28:55 -0700
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
 <53e69744-7165-4069-bada-8e60c2adc0c7@kernel.dk>
 <63da5078-96ea-4734-9b68-817b1be52ec6@gmail.com>
From: Jens Axboe <axboe@kernel.dk>
In-Reply-To: <63da5078-96ea-4734-9b68-817b1be52ec6@gmail.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit

On 2/28/24 5:39 AM, Pavel Begunkov wrote:
> On 2/26/24 21:27, Jens Axboe wrote:
>> On 2/26/24 1:51 PM, Pavel Begunkov wrote:
>>> On 2/26/24 20:12, Jens Axboe wrote:
>>>> On 2/26/24 12:21 PM, Pavel Begunkov wrote:
>>>>> On 2/26/24 19:11, Jens Axboe wrote:
>>>>>> On 2/26/24 8:41 AM, Pavel Begunkov wrote:
>>>>>>> On 2/26/24 15:16, Jens Axboe wrote:
>>>>>>>> On 2/26/24 7:36 AM, Pavel Begunkov wrote:
>>>>>>>>> On 2/26/24 14:27, Jens Axboe wrote:
>>>>>>>>>> On 2/26/24 7:02 AM, Dylan Yudaken wrote:
>>>>>>>>>>> On Mon, Feb 26, 2024 at 1:38?PM Jens Axboe
>>> ...
>>>>>> I don't think that's true - if you're doing large streaming, you're
>>>>>> more likely to keep the socket buffer full, whereas for smallish
>>>>>> sends, it's less likely to be full. Testing with the silly proxy
>>>>>> confirms that. And
>>>>>
>>>>> I don't see any contradiction to what I said. With streaming/large
>>>>> sends it's more likely to be polled. For small sends and
>>>>> send-receive-send-... patterns the sock queue is unlikely to be full,
>>>>> in which case the send is processed inline, and so the feature
>>>>> doesn't add performance, as you agreed a couple email before.
>>>>
>>>> Gotcha, I guess I misread you, we agree that the poll side is more
>>>> likely on bigger buffers.
>>>>
>>>>>> outside of cases where pacing just isn't feasible, it's extra
>>>>>> overhead for cases where you potentially could or what.
>>>>>
>>>>> I lost it, what overhead?
>>>>
>>>> Overhead of needing to serialize the sends in the application, which may
>>>> include both extra memory needed and overhead in dealing with it.
>>>
>>> I think I misread the code. Does it push 1 request for each
>>> send buffer / queue_send() in case of provided bufs?
>>
>> Right, that's the way it's currently setup. Per send (per loop), if
>> you're using provided buffers, it'll do a send per buffer. If using
>> multishot on top of that, it'll do one send per loop regardless of the
>> number of buffers.
> 
> Ok, then I'd say the performance tests are misleading, at least
> the proxy one. For selected buffers, sending tons of requests sounds
> unnecessarily expensive, but I don't have numbers to back it. The
> normal case must employ the natural batching it has with
> serialisation.
> 
> It's important comparing programs that are optimised and close
> to what is achievable in userspace. You wouldn't compare it with
> 
> while (i = 0; i < nr_bytes; i++)
>     send(data+i, bytes=1);
> 
> and claim that it's N times faster. Or surely we can add an
> empty "for" loop to one side and say "users are stupid and
> will put garbage here anyway, so fair game", but then it
> needs a note in small font "valid only for users who can't
> write code up to standard"
> 
> static void defer_send() {
>     ps = malloc(sizeof(*ps));
> }
> 
> fwiw, maybe malloc is not really expensive there, but
> that sounds like a pretty bad practice for a hi perf
> benchmark.

It's comparing using send using a manually managed backlog, or using
send where you don't have to do that. I think that's pretty valid by
itself. If you don't do that, you need to use sendmsg and append iovecs.
Which is obviously also a very valid use case and would avoid the
backlog, at the cost of sendmsg being more expensive than send. If done
right, the sendmsg+append would be a lot closer to send with multishot.

When I have some time I can do add the append case, or feel free to do
that yourself, and I can run some testing with that too.

>>> Anyway, the overhead of serialisation would be negligent.
>>> And that's same extra memory you keep for the provided buffer
>>> pool, and you can allocate it once. Also consider that provided
>>> buffers are fixed size and it'd be hard to resize without waiting,
>>> thus the userspace would still need to have another, userspace
>>> backlog, it can't just drop requests. Or you make provided queues
>>> extra large, but it's per socket and you'd wasting lots of memory.
>>>
>>> IOW, I don't think this overhead could anyhow close us to
>>> the understanding of the 30%+ perf gap.
>>
>> The 32-byte case is obviously somewhat pathological, as you're going to
>> be much better off having a bunch of these pipelined rather than issued
>> serially. As you can see from the 1000 byte packets, at that point it
>> doesn't matter that much. It's mostly about making it simpler at that
>> point.
>>
>>>>>> To me, the main appeal of this is the simplicity.
>>>>>
>>>>> I'd argue it doesn't seem any simpler than the alternative.
>>>>
>>>> It's certainly simpler for an application to do "add buffer to queue"
>>>> and not need to worry about managing sends, than it is to manage a
>>>> backlog of only having a single send active.
>>>
>>> They still need to manage / re-queue sends. And maybe I
>>> misunderstand the point, but it's only one request inflight
>>> per socket in either case.
>>
>> Sure, but one is a manageable condition, the other one is not. If you
>> can keep N inflight at the same time and only abort the chain in case of
>> error/short send, that's a corner case. Versus not knowing when things
>> get reordered, and hence always needing to serialize.
> 
> Manageable or not, you still have to implement all that, whereas
> serialisation is not complex and I doubt it's anywhere expensive
> enough to overturn the picture. It seems that multishot selected
> bufs would also need serialisation, and for oneshots managing
> multiple requests when you don't know which one sends what buffer
> would be complicated in real scenarios.

What "all that"? It's pretty trivial when you have a normal abort
condition to handle it. For the sendmsg case, you can append multiple
iovecs, but you can still only have one sendmsg inflight. If you start
prepping the next one before the previous one has successfully
completed, you have the same issue again.

Only serialization you need is to only have one inflight, which is in
your best interest anyway as it would be more wasteful to submit several
which both empty that particular queue.

>>>> What kind of batching? The batching done by the tests are the same,
>>>> regardless of whether or not send multishot is used in the sense that we
>>>
>>> You can say that, but I say that it moves into the kernel
>>> batching that can be implemented in userspace.
>>
>> And then most people get it wrong or just do the basic stuff, and
>> performance isn't very good. Getting the most out of it can be tricky
>> and require extensive testing and knowledge building. I'm confident
>> you'd be able to write an efficient version, but that's not the same as
>> saying "it's trivial to write an efficient version".
> 
> It actually _is_ trivial to write an efficient version for anyone
> competent enough and having a spare day for that, which is usually
> in a form of a library

If using sendmsg.

> I'm a firm believer of not putting into the kernel what can
> already be well implemented in userspace, because the next step
> could be "firefox can be implemented in userspace, but it requires
> knowledge building, so let's implement it in the kernel". At
> least I recall nginx / HTTP servers not flying well

Sorry but that's nonsense, we add kernel features all the time that
could be done (just less efficiently) in userspace. And the firefox
comment is crazy hyperbole, not relevant here at all.

>>> In terms of "proxy", the first approximation would be to
>>> do sth like defer_send() for normal requests as well, then
>>>
>>> static void __queue_send(struct io_uring *ring, struct conn *c, int fd,
>>>               void *data, int bid, int len)
>>> {
>>>      ...
>>>
>>>      defer_send(data);
>>>
>>>      while (buf = defer_backlog.get()) {
>>>          iov[idx++] = buf;
>>>      }
>>>      msghdr->iovlen = idx;
>>>      ...
>>> }
>>
>> Yep, that's the iovec coalescing, and that could certainly be done. And
>> then you need to size the iov[] so that it's always big enough, OR
>> submit that send and still deal with managing your own backlog.
> 
> Which is as trivial as iov.push_back() or a couple of lines with
> realloc, whereas for selected buffers you would likely need to
> wait for the previous request[s] to complete, which you cannot
> do in place.

Go implement it and we can benchmark. It won't solve the sendmsg being
slower than send situation in general, but it should certainly get a lot
closer in terms of using sendmsg and serializing per send issue.

> The point is, it seems that when you'd try to write something
> error proof and real life ready, it wouldn't look simpler or
> much simpler than the approach suggested, then the performance
> is the question.

The condition for sendmsg with append and send with multishot handling
is basically the same, you need to deal checking the send result and
restarting your send from there. Obviously in practice this will
never/rarely happen unless the connection is aborted anyway. If you use
send multishot with MSG_WAITALL, then if the buffer fills you'll just
restart when it has space, nothing to handle there.

-- 
Jens Axboe


