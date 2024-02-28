Return-Path: <io-uring+bounces-794-lists+io-uring=lfdr.de@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [147.75.80.249])
	by mail.lfdr.de (Postfix) with ESMTPS id 5A8AB86AFBA
	for <lists+io-uring@lfdr.de>; Wed, 28 Feb 2024 14:02:36 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id 0FBBF1F218EB
	for <lists+io-uring@lfdr.de>; Wed, 28 Feb 2024 13:02:36 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 2D6163BBCB;
	Wed, 28 Feb 2024 13:02:32 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="iBEYP5cw"
X-Original-To: io-uring@vger.kernel.org
Received: from mail-wr1-f49.google.com (mail-wr1-f49.google.com [209.85.221.49])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3E3FB73508
	for <io-uring@vger.kernel.org>; Wed, 28 Feb 2024 13:02:30 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.221.49
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1709125352; cv=none; b=bEGLyCkOdlbsi0igIwgDYP8YoMWkfT9Geu74fXMiRL6WFEWTRjjwyGuss+aw6TZWTVFpPJ29BSgtNQYjjliioPRHf5K+TRRuXVmy32R/KjGZKNiQI1BarakGOLxwDwyJqYcjr8lc3mLDQwLmDSiuIIwLCTQOD3C4RvcUULCLO4s=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1709125352; c=relaxed/simple;
	bh=JcRnBoWXjhEHg1WjCuqPFj+57qV/9Z82+J0dBv12o4g=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=BCsz6nPh2a2ZH0FPDKdgzLvLFCLjLzoXhZMemfUODT4Pnez9M/LUxq3MISmNrgFAU25MJjlLyc3VMTjbsDtqgiuR7KKMNAsmwASrO3nE/248c6Qbf5tlYa1XkdmykozRAJoRJN3JgDLZ7Qz4+4tqMv3oMsXVpOyhxPaaaXWwHBw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=iBEYP5cw; arc=none smtp.client-ip=209.85.221.49
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Received: by mail-wr1-f49.google.com with SMTP id ffacd0b85a97d-33aeb088324so3433478f8f.2
        for <io-uring@vger.kernel.org>; Wed, 28 Feb 2024 05:02:30 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1709125348; x=1709730148; darn=vger.kernel.org;
        h=content-transfer-encoding:in-reply-to:from:content-language
         :references:cc:to:subject:user-agent:mime-version:date:message-id
         :from:to:cc:subject:date:message-id:reply-to;
        bh=gjoZpL24mcY1kFdthfv+b0kds/wZ0Ux8gEeQJux9yY0=;
        b=iBEYP5cwsGoZ7uDmXqf6TO6eaAe6TXW0WCTXsV8mrcvSue2aYB4uzYrb+JQI1f61lt
         bjzLGGtubh0XaXzsAfaNRcS+DmRClcpeS+cZVTAQG3Lc1SsQNsv3ciKzC4LgYjT490ko
         GrvlagX6TLEB3WSBDGMzp0z0N+BlywzBEl+ZPHmp7wkParDBUEQ9PpFYbE6xX9netrYC
         m/zP5dokFcBhtD0BR71+5HJmn9bbNzsc8zqffRwQXX/4TDorCXGWtZggJw/EVY1VY3Pz
         QwXH6WGZxrA5+MTPVSjlGovWRDPkJ+6u5ADpEo7eci2UtvN2X0kriqAl0zecAEQpUNv0
         ARMQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1709125348; x=1709730148;
        h=content-transfer-encoding:in-reply-to:from:content-language
         :references:cc:to:subject:user-agent:mime-version:date:message-id
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=gjoZpL24mcY1kFdthfv+b0kds/wZ0Ux8gEeQJux9yY0=;
        b=VX2hpjI2g9VuUaN0UzXFL3zTsC2RsnXJP94kZ956nXBwJaU4NM2pjN1+EiOJ+FTovi
         u7fvehgckWssX2Z9JtRQxNaGe1VtmMcozCfhKrQx3rI0b1tXEElMS7fHUvieg5mXRw8W
         ei6Ppap9WibMQD0/U9Bup7Gu3Z4c6L7I9XpFpN6koo/blKFRZN4fN9Mld50mp3Wkn664
         bDZ7Y4/SWO2CUNzJBC0mm2zCnA6+VUqbzMd1aZ5bsq52g+LOt2dMKozAQNVHxfKAhK4+
         lTZJXO1B6LPt7mzJ5W6uGyg3IEF/IyYZZPISZ6XpiyNfdwOBtPNexucVTrjJ72/PT5TL
         02Mg==
X-Gm-Message-State: AOJu0YzuixM/Y2Rb+jaJqlt9p5G2eRRZvATYpS1Ns2KQf1gG5MbWOE0W
	f3Xnyy5vq4Bx1Pw675d7BWameGeh+z4Y3MZ7GA7NEAgPbqvedWLb
X-Google-Smtp-Source: AGHT+IGck1ICZAd6EEK16SQxoboBSpnvPvcVwUT+ZY15putkjN7zsSfKt0znqg3vX6bRzArwXVREBg==
X-Received: by 2002:a05:6000:136d:b0:33d:f51f:2da5 with SMTP id q13-20020a056000136d00b0033df51f2da5mr3104452wrz.7.1709125348014;
        Wed, 28 Feb 2024 05:02:28 -0800 (PST)
Received: from ?IPV6:2620:10d:c096:310::2eef? ([2620:10d:c092:600::1:457d])
        by smtp.gmail.com with ESMTPSA id ay25-20020a5d6f19000000b0033da430f286sm14924908wrb.69.2024.02.28.05.02.27
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Wed, 28 Feb 2024 05:02:27 -0800 (PST)
Message-ID: <63da5078-96ea-4734-9b68-817b1be52ec6@gmail.com>
Date: Wed, 28 Feb 2024 12:39:36 +0000
Precedence: bulk
X-Mailing-List: io-uring@vger.kernel.org
List-Id: <io-uring.vger.kernel.org>
List-Subscribe: <mailto:io-uring+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:io-uring+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH 6/8] io_uring/net: support multishot for send
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
 <68adc174-802a-455d-b6ca-a6908e592689@gmail.com>
 <302bf59a-40e1-413a-862d-9b99c8793061@kernel.dk>
 <0d440ebb-206e-4315-a7c4-84edc73e8082@gmail.com>
 <53e69744-7165-4069-bada-8e60c2adc0c7@kernel.dk>
Content-Language: en-US
From: Pavel Begunkov <asml.silence@gmail.com>
In-Reply-To: <53e69744-7165-4069-bada-8e60c2adc0c7@kernel.dk>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit

On 2/26/24 21:27, Jens Axboe wrote:
> On 2/26/24 1:51 PM, Pavel Begunkov wrote:
>> On 2/26/24 20:12, Jens Axboe wrote:
>>> On 2/26/24 12:21 PM, Pavel Begunkov wrote:
>>>> On 2/26/24 19:11, Jens Axboe wrote:
>>>>> On 2/26/24 8:41 AM, Pavel Begunkov wrote:
>>>>>> On 2/26/24 15:16, Jens Axboe wrote:
>>>>>>> On 2/26/24 7:36 AM, Pavel Begunkov wrote:
>>>>>>>> On 2/26/24 14:27, Jens Axboe wrote:
>>>>>>>>> On 2/26/24 7:02 AM, Dylan Yudaken wrote:
>>>>>>>>>> On Mon, Feb 26, 2024 at 1:38?PM Jens Axboe
>> ...
>>>>> I don't think that's true - if you're doing large streaming, you're
>>>>> more likely to keep the socket buffer full, whereas for smallish
>>>>> sends, it's less likely to be full. Testing with the silly proxy
>>>>> confirms that. And
>>>>
>>>> I don't see any contradiction to what I said. With streaming/large
>>>> sends it's more likely to be polled. For small sends and
>>>> send-receive-send-... patterns the sock queue is unlikely to be full,
>>>> in which case the send is processed inline, and so the feature
>>>> doesn't add performance, as you agreed a couple email before.
>>>
>>> Gotcha, I guess I misread you, we agree that the poll side is more
>>> likely on bigger buffers.
>>>
>>>>> outside of cases where pacing just isn't feasible, it's extra
>>>>> overhead for cases where you potentially could or what.
>>>>
>>>> I lost it, what overhead?
>>>
>>> Overhead of needing to serialize the sends in the application, which may
>>> include both extra memory needed and overhead in dealing with it.
>>
>> I think I misread the code. Does it push 1 request for each
>> send buffer / queue_send() in case of provided bufs?
> 
> Right, that's the way it's currently setup. Per send (per loop), if
> you're using provided buffers, it'll do a send per buffer. If using
> multishot on top of that, it'll do one send per loop regardless of the
> number of buffers.

Ok, then I'd say the performance tests are misleading, at least
the proxy one. For selected buffers, sending tons of requests sounds
unnecessarily expensive, but I don't have numbers to back it. The
normal case must employ the natural batching it has with
serialisation.

It's important comparing programs that are optimised and close
to what is achievable in userspace. You wouldn't compare it with

while (i = 0; i < nr_bytes; i++)
	send(data+i, bytes=1);

and claim that it's N times faster. Or surely we can add an
empty "for" loop to one side and say "users are stupid and
will put garbage here anyway, so fair game", but then it
needs a note in small font "valid only for users who can't
write code up to standard"

static void defer_send() {
	ps = malloc(sizeof(*ps));
}

fwiw, maybe malloc is not really expensive there, but
that sounds like a pretty bad practice for a hi perf
benchmark.

>> Anyway, the overhead of serialisation would be negligent.
>> And that's same extra memory you keep for the provided buffer
>> pool, and you can allocate it once. Also consider that provided
>> buffers are fixed size and it'd be hard to resize without waiting,
>> thus the userspace would still need to have another, userspace
>> backlog, it can't just drop requests. Or you make provided queues
>> extra large, but it's per socket and you'd wasting lots of memory.
>>
>> IOW, I don't think this overhead could anyhow close us to
>> the understanding of the 30%+ perf gap.
> 
> The 32-byte case is obviously somewhat pathological, as you're going to
> be much better off having a bunch of these pipelined rather than issued
> serially. As you can see from the 1000 byte packets, at that point it
> doesn't matter that much. It's mostly about making it simpler at that
> point.
> 
>>>>> To me, the main appeal of this is the simplicity.
>>>>
>>>> I'd argue it doesn't seem any simpler than the alternative.
>>>
>>> It's certainly simpler for an application to do "add buffer to queue"
>>> and not need to worry about managing sends, than it is to manage a
>>> backlog of only having a single send active.
>>
>> They still need to manage / re-queue sends. And maybe I
>> misunderstand the point, but it's only one request inflight
>> per socket in either case.
> 
> Sure, but one is a manageable condition, the other one is not. If you
> can keep N inflight at the same time and only abort the chain in case of
> error/short send, that's a corner case. Versus not knowing when things
> get reordered, and hence always needing to serialize.

Manageable or not, you still have to implement all that, whereas
serialisation is not complex and I doubt it's anywhere expensive
enough to overturn the picture. It seems that multishot selected
bufs would also need serialisation, and for oneshots managing
multiple requests when you don't know which one sends what buffer
would be complicated in real scenarios.

>>> What kind of batching? The batching done by the tests are the same,
>>> regardless of whether or not send multishot is used in the sense that we
>>
>> You can say that, but I say that it moves into the kernel
>> batching that can be implemented in userspace.
> 
> And then most people get it wrong or just do the basic stuff, and
> performance isn't very good. Getting the most out of it can be tricky
> and require extensive testing and knowledge building. I'm confident
> you'd be able to write an efficient version, but that's not the same as
> saying "it's trivial to write an efficient version".

It actually _is_ trivial to write an efficient version for anyone
competent enough and having a spare day for that, which is usually
in a form of a library

I'm a firm believer of not putting into the kernel what can
already be well implemented in userspace, because the next step
could be "firefox can be implemented in userspace, but it requires
knowledge building, so let's implement it in the kernel". At
least I recall nginx / HTTP servers not flying well

>>> wait on the same number of completions. As it's a basic proxy kind of
>>> thing, it'll receive a packet and send a packet. Submission batching is
>>> the same too, we'll submit when we have to.
>>
>> "If you actually need to poll tx, you send a request and collect
>> data into iov in userspace in background. When the request
>> completes you send all that in batch..."
>>
>> That's how it's in Thrift for example.
>>
>> In terms of "proxy", the first approximation would be to
>> do sth like defer_send() for normal requests as well, then
>>
>> static void __queue_send(struct io_uring *ring, struct conn *c, int fd,
>>               void *data, int bid, int len)
>> {
>>      ...
>>
>>      defer_send(data);
>>
>>      while (buf = defer_backlog.get()) {
>>          iov[idx++] = buf;
>>      }
>>      msghdr->iovlen = idx;
>>      ...
>> }
> 
> Yep, that's the iovec coalescing, and that could certainly be done. And
> then you need to size the iov[] so that it's always big enough, OR
> submit that send and still deal with managing your own backlog.

Which is as trivial as iov.push_back() or a couple of lines with
realloc, whereas for selected buffers you would likely need to
wait for the previous request[s] to complete, which you cannot
do in place.

The point is, it seems that when you'd try to write something
error proof and real life ready, it wouldn't look simpler or
much simpler than the approach suggested, then the performance
is the question.

> I don't think we disagree that there are other solutions. I'm saying
> that I like this solution. I think it's simple to use for the cases that
> can use it, and that's why the patches exist. It fits with the notion of
> an async API being able to keep multiple things in flight, rather than a
> semi solution where you kind of can, except not for cases X and Y
> because of corner cases.
...

-- 
Pavel Begunkov

