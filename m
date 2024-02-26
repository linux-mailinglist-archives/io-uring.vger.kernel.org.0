Return-Path: <io-uring+bounces-740-lists+io-uring=lfdr.de@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [147.75.199.223])
	by mail.lfdr.de (Postfix) with ESMTPS id 94385867A02
	for <lists+io-uring@lfdr.de>; Mon, 26 Feb 2024 16:21:23 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id B642A1C22A64
	for <lists+io-uring@lfdr.de>; Mon, 26 Feb 2024 15:21:22 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id DD9AF12BE8E;
	Mon, 26 Feb 2024 15:16:52 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel-dk.20230601.gappssmtp.com header.i=@kernel-dk.20230601.gappssmtp.com header.b="oUJQ1zZ7"
X-Original-To: io-uring@vger.kernel.org
Received: from mail-io1-f45.google.com (mail-io1-f45.google.com [209.85.166.45])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4D2DA60DCB
	for <io-uring@vger.kernel.org>; Mon, 26 Feb 2024 15:16:48 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.166.45
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1708960612; cv=none; b=fNrCucaJz5AHZwDKGFXmMce9rqrW2B3Z4J7/G1swrhTlAuRYIw+e4B96j+kA8mpliIbQSw9tFFV4iel9Fvzv7apzas9NzvCbNIxDURwUl9LvY6lnoCk7SmWUT9j44N4R2aMCgsViqPCo4QnknMwpH6CBg5BB1OcfSZd0W4uz84k=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1708960612; c=relaxed/simple;
	bh=je9ZW0Cwhq3SBOcDPoFC/I87iLj7tvP4LpgFlvfL9h4=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=u3xiuzsy9A7nAwO08cPn1vAU/Thv4Jta3AQ1W1LHHvYxgtgnO5NYTDC4lIcmRosX3wgOlLLZ4soQqHHcwkxbEu/arU3X746eCM/IHMFh9wg6eSSEIpkXx6v3G3zDCGOkYVdXN1u7LoHBp+GJg3R5V3jGYZAjS6k61MZwxhQXWYs=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=kernel.dk; spf=pass smtp.mailfrom=kernel.dk; dkim=pass (2048-bit key) header.d=kernel-dk.20230601.gappssmtp.com header.i=@kernel-dk.20230601.gappssmtp.com header.b=oUJQ1zZ7; arc=none smtp.client-ip=209.85.166.45
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=kernel.dk
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=kernel.dk
Received: by mail-io1-f45.google.com with SMTP id ca18e2360f4ac-7c7bd118546so9218739f.1
        for <io-uring@vger.kernel.org>; Mon, 26 Feb 2024 07:16:48 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernel-dk.20230601.gappssmtp.com; s=20230601; t=1708960607; x=1709565407; darn=vger.kernel.org;
        h=content-transfer-encoding:in-reply-to:from:references:cc:to
         :content-language:subject:user-agent:mime-version:date:message-id
         :from:to:cc:subject:date:message-id:reply-to;
        bh=8Si3fSK8PM19deIQtQnQHWXyMBX0VXYlwKrpmuU+1Eo=;
        b=oUJQ1zZ7DKMjDoZ/O4HGrodFYsEWw5CyFtix00cxW2dBIn+EqN6Dkzl+ML5HbBoZgL
         9TJfqxYtG2h/VMcX0CavnBwq0VbO2F0w/nK/l8ViPC6wE81HxZIDBDN0lpdoG2zZQHQR
         k8rOS8/2WgKBxy0PxKcne1NwO64Tsko7VbXOkJ2A64SwbxW1xMhP9RfyyEWt/MU9M/+o
         Z7LONUlHKYV/uytccTGU+UuTUPcB/2nPQvM+OMLVi2S2VKXrDPyissfupn2Atzv9QH07
         AOoasBun+NVbttagK75x/fjQwKvwrseUGpHOB/0MycILKOQub0O9XfO8LAb5ETspuMqn
         o4tw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1708960607; x=1709565407;
        h=content-transfer-encoding:in-reply-to:from:references:cc:to
         :content-language:subject:user-agent:mime-version:date:message-id
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=8Si3fSK8PM19deIQtQnQHWXyMBX0VXYlwKrpmuU+1Eo=;
        b=Jv0iIAX/bJ9OP/VkmQKrynPGYttBf/FRweLLby0+DJGH8UKlmy0/kqxCWntY1nBKsa
         5mKjY4cy86mlA9s08kxMciM5Ce104dApcxTHSC58J0SFEUcPD/Hh1bVk8Z+uhfiZ30rf
         SDwlrxbMY5msdXNh3qnghhVYDfB3/7e/RmHI2x4e77JD4e+86yrmXKJU9wMlr3FB28Ox
         9uxU/N6GEsJ5S+Z64T7FGY3wc40aXGZS/kPH9dPmqOSO7NNP3oH32q8ZimOYJLO7PJ5x
         XXpNIiEbPICoklYJqm7oF37raxQi3xlOIl7WrwJNduwIb4qtJtjg5r4U6Oq8AfIsF9sf
         KZjg==
X-Gm-Message-State: AOJu0Ywo7NW6y0MPpCmRGkZwLVXcH4f+Gcd4dmBPrFdPZnwy5/d1TuyY
	BBWmhnivgJ5Lik5BfgYPakPBx+Ej06fMTHrBx9S/ZNAtMY9F1Wj2chBPu1K2t8/xkvvtV3EDfwz
	y
X-Google-Smtp-Source: AGHT+IF2hkjFgVhiFJYvEexpl+E6ZTuqAqAp7NwUIPCxyLVeiY0weok6rFGnI9m5q3MUuuDnlOWZVg==
X-Received: by 2002:a05:6e02:1c44:b0:363:c919:eee3 with SMTP id d4-20020a056e021c4400b00363c919eee3mr7269133ilg.0.1708960607314;
        Mon, 26 Feb 2024 07:16:47 -0800 (PST)
Received: from [192.168.1.116] ([96.43.243.2])
        by smtp.gmail.com with ESMTPSA id p6-20020a92c606000000b003642dacafa5sm1583511ilm.29.2024.02.26.07.16.46
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Mon, 26 Feb 2024 07:16:46 -0800 (PST)
Message-ID: <454ef0d2-066f-4bdf-af42-52fd0c57bd56@kernel.dk>
Date: Mon, 26 Feb 2024 08:16:45 -0700
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
From: Jens Axboe <axboe@kernel.dk>
In-Reply-To: <f0046836-ef9d-4b58-bfae-f2bf087233e1@gmail.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit

On 2/26/24 7:36 AM, Pavel Begunkov wrote:
> On 2/26/24 14:27, Jens Axboe wrote:
>> On 2/26/24 7:02 AM, Dylan Yudaken wrote:
>>> On Mon, Feb 26, 2024 at 1:38?PM Jens Axboe <axboe@kernel.dk> wrote:
>>>>
>>>> On 2/26/24 3:47 AM, Dylan Yudaken wrote:
>>>>> On Sun, Feb 25, 2024 at 12:46?AM Jens Axboe <axboe@kernel.dk> wrote:
>>>>>>
>>>>>> This works very much like the receive side, except for sends. The idea
>>>>>> is that an application can fill outgoing buffers in a provided buffer
>>>>>> group, and then arm a single send that will service them all. For now
>>>>>> this variant just terminates when we are out of buffers to send, and
>>>>>> hence the application needs to re-arm it if IORING_CQE_F_MORE isn't
>>>>>> set, as per usual for multishot requests.
>>>>>>
>>>>>
>>>>> This feels to me a lot like just using OP_SEND with MSG_WAITALL as
>>>>> described, unless I'm missing something?
>>>>
>>>> How so? MSG_WAITALL is "send X amount of data, and if it's a short send,
>>>> try again" where multishot is "send data from this buffer group, and
>>>> keep sending data until it's empty". Hence it's the mirror of multishot
>>>> on the receive side. Unless I'm misunderstanding you somehow, not sure
>>>> it'd be smart to add special meaning to MSG_WAITALL with provided
>>>> buffers.
>>>>
>>>
>>> _If_ you have the data upfront these are very similar, and only differ
>>> in that the multishot approach will give you more granular progress
>>> updates. My point was that this might not be a valuable API to people
>>> for only this use case.
>>
>> Not sure I agree, it feels like attributing a different meaning to
>> MSG_WAITALL if you use a provided buffer vs if you don't. And that to me
>> would seem to be confusing. Particularly when we have multishot on the
>> receive side, and this is identical, just for sends. Receives will keep
>> receiving as long as there are buffers in the provided group to receive
>> into, and sends will keep sending for the same condition. Either one
>> will terminate if we run out of buffers.
>>
>> If you make MSG_WAITALL be that for provided buffers + send, then that
>> behaves differently than MSG_WAITALL with receive, and MSG_WAITALL with
>> send _without_ provided buffers. I don't think overloading an existing
>> flag for this purposes is a good idea, particularly when we already have
>> the existing semantics for multishot on the receive side.
> 
> I'm actually with Dylan on that and wonder where the perf win
> could come from. Let's assume TCP, sends are usually completed
> in the same syscall, otherwise your pacing is just bad. Thrift,
> for example, collects sends and packs into one multi iov request
> during a loop iteration. If the req completes immediately then
> the userspace just wouldn't have time to push more buffers by
> definition (assuming single threading).

The problem only occurs when they don't complete inline, and now you get
reordering. The application could of course attempt to do proper pacing
and see if it can avoid that condition. If not, it now needs to
serialize sends. Using provided buffers makes this very easy, as you
don't need to care about it at all, and it eliminates complexity in the
application dealing with this.

> If you actually need to poll tx, you send a request and collect
> data into iov in userspace in background. When the request
> completes you send all that in batch. You can probably find
> a niche example when batch=1 in this case, but I don't think
> anyone would care.
> 
> The example doesn't use multi-iov, and also still has to
> serialise requests, which naturally serialises buffer consumption
> w/o provided bufs.

IMHO there's no reason NOT to have both a send with provided buffers and
a multishot send. The alternative would be to have send-N, where you
pass in N. But I don't see much point to that over "just drain the whole
pending list". The obvious use case is definitely send multishot, but
what would the reasoning be to prohibit pacing by explicitly disallowing
only doing a single buffer (or a partial queue)? As mentioned earlier, I
like keeping the symmetry with the receive side for multishot, and not
make it any different unless there's a reason to.

>>> You do make a good point about MSG_WAITALL though - multishot send
>>> doesn't really make sense to me without MSG_WAITALL semantics. I
>>> cannot imagine a useful use case where the first buffer being
>>> partially sent will still want the second buffer sent.
>>
>> Right, and I need to tweak that. Maybe we require MSG_WAITALL, or we
>> make it implied for multishot send. Currently the code doesn't deal with
>> that.
>>
>> Maybe if MSG_WAITALL isn't set and we get a short send we don't set
>> CQE_F_MORE and we just stop. If it is set, then we go through the usual
>> retry logic. That would make it identical to MSG_WAITALL send without
>> multishot, which again is something I like in that we don't have
>> different behaviors depending on which mode we are using.
>>
>>>>> I actually could imagine it being useful for the previous patches' use
>>>>> case of queuing up sends and keeping ordering,
>>>>> and I think the API is more obvious (rather than the second CQE
>>>>> sending the first CQE's data). So maybe it's worth only
>>>>> keeping one approach?
>>>>
>>>> And here you totally lost me :-)
>>>
>>> I am suggesting here that you don't really need to support buffer
>>> lists on send without multishot.
>>
>> That is certainly true, but I also don't see a reason _not_ to support
>> it. Again mostly because this is how receive and everything else works.
>> The app is free to issue a single SQE for send without multishot, and
>> pick the first buffer and send it.
> 
> Multishot sound interesting, but I don't see it much useful if
> you terminate when there are no buffers. Otherwise, if it continues
> to sit in, someone would have to wake it up

I did think about the termination case, and the problem is that if there
are no buffers, you need it to wake when there are buffers. And at that
point you may as well just do another send, as you need the application
to trigger it. The alternative would be to invent a way to trigger that
wakeup, which would be send only and weird just because of that.

If you end up poll armed because the socket buffer is full, then it
certainly makes sense to stay armed as there's a natural trigger there
when that condition resolves.

-- 
Jens Axboe


