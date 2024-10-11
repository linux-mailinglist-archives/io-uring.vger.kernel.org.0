Return-Path: <io-uring+bounces-3614-lists+io-uring=lfdr.de@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [IPv6:2604:1380:45d1:ec00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id E0C9199AF20
	for <lists+io-uring@lfdr.de>; Sat, 12 Oct 2024 01:12:32 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id E67CD1C2412F
	for <lists+io-uring@lfdr.de>; Fri, 11 Oct 2024 23:12:31 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 5DA7F28EB;
	Fri, 11 Oct 2024 23:11:57 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="GT3BVhy7"
X-Original-To: io-uring@vger.kernel.org
Received: from mail-ej1-f53.google.com (mail-ej1-f53.google.com [209.85.218.53])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 51EC01D27A9;
	Fri, 11 Oct 2024 23:11:55 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.218.53
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1728688317; cv=none; b=Gh91qDKrP0ltRMYRh9Q+fTh4a/NtJ745IuBLKbBGCMKWfAUeH9HCJIutp8HrhPlbJzRpcjqwfVNHwXVFPfzEEoq53/vBunLLoVNb4BhKbseRLF7hjLmemyxUQLfO1dAm4lIkqHDNwrPIzf9cd2XPKI7uQY8qH9wlo5Sjx4N4Wcc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1728688317; c=relaxed/simple;
	bh=oERtUBw1FRZvPrFLk037yXatUawF/ZjSMOzjAqA73dA=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=OVnvxld8pKUL8DjaMFxAVF/lrjIxW0n42rP1GteAvYAAgStxBznAFATyTTgEgusHTN8+WV5vYQgvxjpDlAmOxN0yoETpgcUjjYNk5XmN+HFtjrdnuj4nAJW9s0J1FyExvakyla5U3f81rkliwqmu2Rp8G8dlcAGg+lsx85EJ5UE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=GT3BVhy7; arc=none smtp.client-ip=209.85.218.53
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Received: by mail-ej1-f53.google.com with SMTP id a640c23a62f3a-a9950d27234so360710366b.1;
        Fri, 11 Oct 2024 16:11:55 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1728688313; x=1729293113; darn=vger.kernel.org;
        h=content-transfer-encoding:in-reply-to:from:content-language
         :references:cc:to:subject:user-agent:mime-version:date:message-id
         :from:to:cc:subject:date:message-id:reply-to;
        bh=QFsNuVaqTxckw0Im+3DUMO2C8Eh0chMeXSbEl+kmAAI=;
        b=GT3BVhy79DE73mFELLD/k6H5IhLNqDnDXgqPsSNhE+8pmtBAeMu/GbTkS8PEDFJf26
         9778Dkybb/67ugB0woHwE3R4sbvy3EKZDu8/MZAKHJpVu5huvzMCC9utkzhI583BWO/o
         +9/ey6lNDZrh+AihYCRAgXkNvDl3+fJ23YGxXjNgx2hMPd4p76dCslxibu/iDDiKMuNV
         SHzPUZpRSUm4584BgnQeFkbgXTY+dsBT4TlbgAWP4Kz/5qa7Qhp3aGsWbjzOFMT2bvy9
         Cnq5dglyPmu3MuxYeWfjH5ynXXu7++cstvJGCOA88W1CNnyrBLh4bPqER5h9pTp/WwgF
         rUYg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1728688313; x=1729293113;
        h=content-transfer-encoding:in-reply-to:from:content-language
         :references:cc:to:subject:user-agent:mime-version:date:message-id
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=QFsNuVaqTxckw0Im+3DUMO2C8Eh0chMeXSbEl+kmAAI=;
        b=o/Qx8vsKTX7SkZreb9FC4v7nOEOO5MJl3+J7We9mg4u0xykqAli9q6HeZJwSriyOcj
         VVfOLXBb6p9Kg5WoXFWAzirufuADvImsBsjBqSuFdGdOuMFkrIP+M7s4YxMDaYpTUgD7
         OmpbFEh61kg+3w4txoxoA4hE2eR3zzm27BjclBLHDVfuBcUrwmIST1T4sVXXp31VBeHB
         jjYYwRnZgQQllzX0ee8vQScv79uOUzDG2u330j5hpuVIWoU0XUffL1zq8XJu35KXWzU9
         1U/toV64v/EWfl8KZDFudM82wGJ1lZo+RqbFVeI2wC4qKcDxCnVR+p+j6QpbNakrFVfy
         hKOA==
X-Forwarded-Encrypted: i=1; AJvYcCUZDJwSBVVtQ/aYggqkcq3C2M2D516NEM7Ha5eWpazGM6AHY+hw6w5AI5oCEvcOhuidFou5ynXoew==@vger.kernel.org, AJvYcCWvQENBAzdteYcmjrO6qrBNQHlbQck+8b3wvHgEt72quHXD8FyBgdzPdFLiEyCqTaSGnFAaI6+9@vger.kernel.org
X-Gm-Message-State: AOJu0YyAf1mFNz3EO9X0TPpSgJhXrERHn9nidYsAEu1vrBgOdjh2J6UT
	dKfiCJRFrzdgnqZ97Kvom6HvBYBPMVuHYk48dN1yjhdi5XzngLWH
X-Google-Smtp-Source: AGHT+IGmEUdiDic9w0AWzo08XG/kO/Zd5B5eS+tPxPtB5jEAq415izVBkv9BF1j6G+8A52H540iqdQ==
X-Received: by 2002:a17:907:1b1a:b0:a99:d6e1:605f with SMTP id a640c23a62f3a-a99d6e16587mr155358066b.14.1728688313279;
        Fri, 11 Oct 2024 16:11:53 -0700 (PDT)
Received: from [192.168.42.194] ([85.255.233.136])
        by smtp.gmail.com with ESMTPSA id 4fb4d7f45d1cf-5c93729a8cfsm2321955a12.95.2024.10.11.16.11.52
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Fri, 11 Oct 2024 16:11:52 -0700 (PDT)
Message-ID: <f762abbd-5732-456f-97f2-df91b006016e@gmail.com>
Date: Sat, 12 Oct 2024 00:12:25 +0100
Precedence: bulk
X-Mailing-List: io-uring@vger.kernel.org
List-Id: <io-uring.vger.kernel.org>
List-Subscribe: <mailto:io-uring+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:io-uring+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v1 03/15] net: generalise net_iov chunk owners
To: Mina Almasry <almasrymina@google.com>
Cc: David Wei <dw@davidwei.uk>, Stanislav Fomichev <stfomichev@gmail.com>,
 io-uring@vger.kernel.org, netdev@vger.kernel.org,
 Jens Axboe <axboe@kernel.dk>, Jakub Kicinski <kuba@kernel.org>,
 Paolo Abeni <pabeni@redhat.com>, "David S. Miller" <davem@davemloft.net>,
 Eric Dumazet <edumazet@google.com>, Jesper Dangaard Brouer
 <hawk@kernel.org>, David Ahern <dsahern@kernel.org>
References: <20241007221603.1703699-1-dw@davidwei.uk>
 <20241007221603.1703699-4-dw@davidwei.uk> <ZwVT8AnAq_uERzvB@mini-arch>
 <ade753dd-caab-4151-af30-39de9080f69b@gmail.com> <ZwavJuVI-6d9ZSuh@mini-arch>
 <b2aa16ac-a5fe-4bab-a047-8f38086f4d43@davidwei.uk>
 <7d321d9e-48bb-4e5f-bca5-6a6c940e3a9a@gmail.com>
 <CAHS8izM4AVsB5+H4p05D_m-cwO5TqHfn28XfNUM-rDAO5=BTew@mail.gmail.com>
Content-Language: en-US
From: Pavel Begunkov <asml.silence@gmail.com>
In-Reply-To: <CAHS8izM4AVsB5+H4p05D_m-cwO5TqHfn28XfNUM-rDAO5=BTew@mail.gmail.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit

On 10/11/24 23:25, Mina Almasry wrote:
> On Fri, Oct 11, 2024 at 3:02 PM Pavel Begunkov <asml.silence@gmail.com> wrote:
>>
>> On 10/11/24 19:44, David Wei wrote:
>>> On 2024-10-09 09:28, Stanislav Fomichev wrote:
>>>> On 10/08, Pavel Begunkov wrote:
>>>>> On 10/8/24 16:46, Stanislav Fomichev wrote:
>>>>>> On 10/07, David Wei wrote:
>>>>>>> From: Pavel Begunkov <asml.silence@gmail.com>
>>>>>>>
>>>>>>> Currently net_iov stores a pointer to struct dmabuf_genpool_chunk_owner,
>>>>>>> which serves as a useful abstraction to share data and provide a
>>>>>>> context. However, it's too devmem specific, and we want to reuse it for
>>>>>>> other memory providers, and for that we need to decouple net_iov from
>>>>>>> devmem. Make net_iov to point to a new base structure called
>>>>>>> net_iov_area, which dmabuf_genpool_chunk_owner extends.
>>>>>>>
>>>>>>> Signed-off-by: Pavel Begunkov <asml.silence@gmail.com>
>>>>>>> Signed-off-by: David Wei <dw@davidwei.uk>
>>>>>>> ---
>>>>>>>     include/net/netmem.h | 21 ++++++++++++++++++++-
>>>>>>>     net/core/devmem.c    | 25 +++++++++++++------------
>>>>>>>     net/core/devmem.h    | 25 +++++++++----------------
>>>>>>>     3 files changed, 42 insertions(+), 29 deletions(-)
>>>>>>>
>>>>>>> diff --git a/include/net/netmem.h b/include/net/netmem.h
>>>>>>> index 8a6e20be4b9d..3795ded30d2c 100644
>>>>>>> --- a/include/net/netmem.h
>>>>>>> +++ b/include/net/netmem.h
>>>>>>> @@ -24,11 +24,20 @@ struct net_iov {
>>>>>>>            unsigned long __unused_padding;
>>>>>>>            unsigned long pp_magic;
>>>>>>>            struct page_pool *pp;
>>>>>>> - struct dmabuf_genpool_chunk_owner *owner;
>>>>>>> + struct net_iov_area *owner;
>>>>>>
>>>>>> Any reason not to use dmabuf_genpool_chunk_owner as is (or rename it
>>>>>> to net_iov_area to generalize) with the fields that you don't need
>>>>>> set to 0/NULL? container_of makes everything harder to follow :-(
>>>>>
>>>>> It can be that, but then io_uring would have a (null) pointer to
>>>>> struct net_devmem_dmabuf_binding it knows nothing about and other
>>>>> fields devmem might add in the future. Also, it reduces the
>>>>> temptation for the common code to make assumptions about the origin
>>>>> of the area / pp memory provider. IOW, I think it's cleaner
>>>>> when separated like in this patch.
>>>>
>>>> Ack, let's see whether other people find any issues with this approach.
>>>> For me, it makes the devmem parts harder to read, so my preference
>>>> is on dropping this patch and keeping owner=null on your side.
>>>
>>> I don't mind at this point which approach to take right now. I would
>>> prefer keeping dmabuf_genpool_chunk_owner today even if it results in a
>>> nullptr in io_uring's case. Once there are more memory providers in the
>>> future, I think it'll be clearer what sort of abstraction we might need
>>> here.
>>
>> That's the thing about abstractions, if we say that devmem is the
>> only first class citizen for net_iov and everything else by definition
>> is 2nd class that should strictly follow devmem TCP patterns, and/or
>> that struct dmabuf_genpool_chunk_owner is an integral part of net_iov
>> and should be reused by everyone, then preserving the current state
>> of the chunk owner is likely the right long term approach. If not, and
>> net_iov is actually a generic piece of infrastructure, then IMHO there
>> is no place for devmem sticking out of every bit single bit of it, with
>> structures that are devmem specific and can even be not defined without
>> devmem TCP enabled (fwiw, which is not an actual problem for
>> compilation, juts oddness).
>>
> 
> There is no intention of devmem TCP being a first class citizen or
> anything.

Let me note to avoid being misread, that kind of prioritisation can
have place and that's fine, but that usually happens when you build
on top of older code or user base sizes are much different. And
again, theoretically dmabuf_genpool_chunk_owner could be common code,
i.e. if you want to use dmabuf you need to use the structure
regardless of the provider of choice, and it'll do all dmabuf
handling. But the current chunk owner goes beyond that, and
would need some splitting if someone tries to have that kind of
an abstraction.

> Abstractly speaking, we're going to draw a line in the sand
> and say everything past this line is devmem specific and should be
> replaced by other users. In this patch you drew the line between
> dmabuf_genpool_chunk_owner and net_iov_area, which is fine by me on
> first look. What Stan and I were thinking at first glance is
> preserving dmabuf_* (and renaming) and drawing the line somewhere
> else, which would have also been fine.

True enough, I drew the line when it was convenient, io_uring
needs an extendible abstraction that binds net_iovs, and we'll
also have several different sets of net_iovs, so it fell onto
the object holding the net_iov array as the most natural option.
In that sense, we could've had that binding pointing to an
allocated io_zcrx_area, which would then point further into
io_uring, but that's one extra indirection.

As an viable alternative I don't like that much, instead of
trying to share struct net_iov_area, we can just make struct
struct net_iov::owner completely provider dependent and make
it void *, providers will be allowed to store there whatever
they wish.

> My real issue is whether its safe to do all this container_of while
> not always checking explicitly for the type of net_iov. I'm not 100%
> sure checking in tcp.c alone is enough, yet. I need to take a deeper
> look, no changes requested from me yet.

That's done the typical way everything in the kernel and just
inheritance works. When you get into devmem.c the page pool
callbacks, you for sure know that net_iov's passed are devmem's,
nobody should ever take one net_iov's ops and call it with a
second net_iov without care, the page pool follows it.

When someone wants to operate with devmem net_iov's but doesn't
have a callback it has to validate the origin as tcp.c now does
in 5/15. The nice part is that this patch changes types, so all
such places either explicitly listed in this patch, or it has to
pass through one of the devmem.h helpers, which is yet trivially
checkable.

> FWIW I'm out for the next couple of weeks. I'll have time to take a
> look during that but not as much as now.
> 

-- 
Pavel Begunkov

