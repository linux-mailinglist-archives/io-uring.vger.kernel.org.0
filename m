Return-Path: <io-uring+bounces-5150-lists+io-uring=lfdr.de@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [139.178.88.99])
	by mail.lfdr.de (Postfix) with ESMTPS id CC4389DE809
	for <lists+io-uring@lfdr.de>; Fri, 29 Nov 2024 14:51:35 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 8BE26281D18
	for <lists+io-uring@lfdr.de>; Fri, 29 Nov 2024 13:51:34 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 242E619E804;
	Fri, 29 Nov 2024 13:51:32 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="DUB/kHQz"
X-Original-To: io-uring@vger.kernel.org
Received: from mail-ed1-f54.google.com (mail-ed1-f54.google.com [209.85.208.54])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 353D1198E61
	for <io-uring@vger.kernel.org>; Fri, 29 Nov 2024 13:51:30 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.208.54
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1732888292; cv=none; b=J+z7B3LgjBTuqaYvZGw+JtoJ5UnvxBamVtyyoefgrrgrDVQdVfi8qwwI9piqUHkGUGJwIWMO/Sg8kQUH8zTGqWLOoxMCpRVHsNDUT1CwGFJG5Tz0vgyexmUq9jxz/qRPn1xQ0A1+X2gm81HD17D0zhSn0w4WC9DysMPk7aw8cWc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1732888292; c=relaxed/simple;
	bh=H5pi23/iHg3Ss5iB2KXRwlltaihcz76z4vWMpMu89hw=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=EPmQMUPuXfuk8rAqQxjC5Q04bcAyzemEPEk9E4xSUxlIYsZ4DkaQV/g8595FopfbeZvUk191WiUvMDXDiOM3aJ7s+2iOkvcF07pnZySdJ0UuLtQtMEw7oqauClqM0qZbZK17YSl2CUKNLbs9wh9ehUhpd1RWEQRjmJIpYxyrBeg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=DUB/kHQz; arc=none smtp.client-ip=209.85.208.54
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Received: by mail-ed1-f54.google.com with SMTP id 4fb4d7f45d1cf-5cfadf851e2so2736530a12.2
        for <io-uring@vger.kernel.org>; Fri, 29 Nov 2024 05:51:29 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1732888288; x=1733493088; darn=vger.kernel.org;
        h=content-transfer-encoding:in-reply-to:from:content-language
         :references:cc:to:subject:user-agent:mime-version:date:message-id
         :from:to:cc:subject:date:message-id:reply-to;
        bh=M3vxe4QNEainutxyDCwNQg7DtSw6Vf5FtzfVVp4kRMI=;
        b=DUB/kHQzRS3YAmILhs17ZOqLJ2SFS7AgQh6NJiFaEldPz9F12JpJIleQhCHwMMOLBb
         XfVWUtenZ4Z1rsvajSjV3RqNcXlb/45DXbGUPogOTkaxnC6Z6tg3yFClvGmYxTzYc91P
         FPJx68AxQ8NSPJxK0c98E1Owu6aOWllYx02U5gf97XlM974WJGqegXH4/aF0f+9pQSK2
         7O/0/Pw5h+dVsYZdkb98r4Rx6nS4DtInk11WMVjAJrmXwlQiKgKbVv6/KfIc/2LnU2CN
         3btBZKzuaxRAXJ2fXT0wQd3iKpJ0jWzHxt5LkQaIPXY3BjvalcLuNZpHvMKpsOVS5csh
         SAwA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1732888288; x=1733493088;
        h=content-transfer-encoding:in-reply-to:from:content-language
         :references:cc:to:subject:user-agent:mime-version:date:message-id
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=M3vxe4QNEainutxyDCwNQg7DtSw6Vf5FtzfVVp4kRMI=;
        b=kbuaWT8lL51xLYJsZrDyyv4yuCq31u/STRKfyuSUPyEDsXTzrz2XwMxiZXMy4B28kX
         7TeyiKJrQ+E4bIOgKjm/0rz9HAjXZyKq98FaoqvhFftGHDDGW7UWwkSejqKR06ARGZDf
         1GeONM6yDyZGLWT3O+N3CqQHpjqbV16Xoj8ngXHDVDsexigCmzuDJ35t0xAZQ+TgnIyv
         r7D9RIbBolpKOoT/PNom/YiY3dsXjDuQFVN8/J7n7tkhI/IbZdxfiCgkE6Uw0SM+F519
         LtopKBxFj4tJAlQwJw41iyqRIApCzB7sCMO8RiS7TEi1kfJFvVVHpfghXzANAGCQswMk
         l54Q==
X-Forwarded-Encrypted: i=1; AJvYcCU7w11u/FlB0eL2VPOVKpNzKWvfAFByDdG7+IitbTtQaWgvwnFw02pWAOr43haVAxsO9S34w7UquQ==@vger.kernel.org
X-Gm-Message-State: AOJu0YxUYw0JefsRo4LSYGvHeYXFK27Szi5lNGAQgh4jI55sIlRtawSt
	VHm2jzqdI1gwzYJWdcb/gi8yo8EQtH8ZSJmkfoAsic75w4iF386s
X-Gm-Gg: ASbGncu3G265awUJ4KoCfpFhX15+Bb81uoJ2SaEQ6vf3wiwSKm/Jjp5oiQVJei9ePCc
	7RBNxN5A7IYDdoj4n8TiX3f/IpCSI6wKzrY6IxX8yK1eXPkfk9PjCxkdDVRz3fw3jzrHbTGwbIn
	7Je/TEVxjaIpOgdEo97gU20naoL42bV9SnW97KUR78gaKjCf0kmvIm74S18lHQ0zweHWcoqrmMD
	tH/1VM9YcPeFYmmHcl1rjKfAOUdwi5i9XiAZwXBwiO6mQW1EfQ7jYdfUh+4nQ==
X-Google-Smtp-Source: AGHT+IFO12YolPnDwRgxplFPWyni9BV5uCksCGo8ruF610O8Si6GbK2IYpoZ5XgnFXONR7Odqc7m2A==
X-Received: by 2002:a05:6402:35cb:b0:5d0:9686:39b2 with SMTP id 4fb4d7f45d1cf-5d096863abfmr8592661a12.18.1732888288382;
        Fri, 29 Nov 2024 05:51:28 -0800 (PST)
Received: from [192.168.42.227] ([163.114.131.193])
        by smtp.gmail.com with ESMTPSA id a640c23a62f3a-aa5998e64c4sm175502266b.97.2024.11.29.05.51.27
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Fri, 29 Nov 2024 05:51:28 -0800 (PST)
Message-ID: <ae07905f-76f0-4742-9c40-d784cf0143dd@gmail.com>
Date: Fri, 29 Nov 2024 13:52:12 +0000
Precedence: bulk
X-Mailing-List: io-uring@vger.kernel.org
List-Id: <io-uring.vger.kernel.org>
List-Subscribe: <mailto:io-uring+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:io-uring+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH 1/1] io_uring: prevent reg-wait speculations
To: Jann Horn <jannh@google.com>
Cc: Jens Axboe <axboe@kernel.dk>, io-uring@vger.kernel.org
References: <fd36cd900023955c763bd424c0895ae5828f68a0.1731979403.git.asml.silence@gmail.com>
 <0dfd1032-6ddd-49b3-a422-569af2307d3b@kernel.dk>
 <d5e9c79f-d571-4f3a-9145-f7e349e532ae@gmail.com>
 <278a1964-b795-4146-8f24-19f112af75b0@kernel.dk>
 <8bc3b927-b7f0-425f-8874-a3905b30759d@gmail.com>
 <CAG48ez3QNBvryTaf7s6G--Cgcuq2_vUmgJQOFxPLeySbsGj0Kg@mail.gmail.com>
Content-Language: en-US
From: Pavel Begunkov <asml.silence@gmail.com>
In-Reply-To: <CAG48ez3QNBvryTaf7s6G--Cgcuq2_vUmgJQOFxPLeySbsGj0Kg@mail.gmail.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit

On 11/27/24 22:53, Jann Horn wrote:
> On Thu, Nov 21, 2024 at 1:12 AM Pavel Begunkov <asml.silence@gmail.com> wrote:
>> On 11/19/24 01:59, Jens Axboe wrote:
>>> On 11/18/24 6:43 PM, Pavel Begunkov wrote:
>>>> On 11/19/24 01:29, Jens Axboe wrote:
>>>>> On 11/18/24 6:29 PM, Pavel Begunkov wrote:
>>>>>> With *ENTER_EXT_ARG_REG instead of passing a user pointer with arguments
>>>>>> for the waiting loop the user can specify an offset into a pre-mapped
>>>>>> region of memory, in which case the
>>>>>> [offset, offset + sizeof(io_uring_reg_wait)) will be intepreted as the
>>>>>> argument.
>>>>>>
>>>>>> As we address a kernel array using a user given index, it'd be a subject
>>>>>> to speculation type of exploits.
>>>>>>
>>>>>> Fixes: d617b3147d54c ("io_uring: restore back registered wait arguments")
>>>>>> Fixes: aa00f67adc2c0 ("io_uring: add support for fixed wait regions")
>>>>>> Signed-off-by: Pavel Begunkov <asml.silence@gmail.com>
>>>>>> ---
>>>>>>     io_uring/io_uring.c | 1 +
>>>>>>     1 file changed, 1 insertion(+)
>>>>>>
>>>>>> diff --git a/io_uring/io_uring.c b/io_uring/io_uring.c
>>>>>> index da8fd460977b..3a3e4fca1545 100644
>>>>>> --- a/io_uring/io_uring.c
>>>>>> +++ b/io_uring/io_uring.c
>>>>>> @@ -3207,6 +3207,7 @@ static struct io_uring_reg_wait *io_get_ext_arg_reg(struct io_ring_ctx *ctx,
>>>>>>                  end > ctx->cq_wait_size))
>>>>>>             return ERR_PTR(-EFAULT);
>>>>>>     +    barrier_nospec();
>>>>>>         return ctx->cq_wait_arg + offset;
>>>>>
>>>>> We need something better than that, barrier_nospec() is a big slow
>>>>> hammer...
>>>>
>>>> Right, more of a discussion opener. I wonder if Jann can help here
>>>> (see the other reply). I don't like back and forth like that, but if
>>>> nothing works there is an option of returning back to reg-wait array
>>>> indexes. Trivial to change, but then we're committing to not expanding
>>>> the structure or complicating things if we do.
>>>
>>> Then I think it should've been marked as a discussion point, because we
>>> definitely can't do this. Soliciting input is perfectly fine. And yeah,
>>> was thinking the same thing, if this is an issue then we just go back to
>>> indexing again. At least both the problem and solution is well known
>>> there. The original aa00f67adc2c0 just needed an array_index_nospec()
>>> and it would've been fine.
>>>
>>> Not a huge deal in terms of timing, either way.
>>>
>>> I suspect we can do something similar here, with just clamping the
>>> indexing offset. But let's hear what Jann thinks.
>>
>> That what I hope for, but I can't say I entirely understand it. E.g.
>> why can_do_masked_user_access() exists and guards mask_user_address().
> 
> FWIW, my understanding is that x86-64 can do this because there is a
> really big hole in the virtual address space between userspace
> addresses and kernel addresses (over 2^63 bytes big); so if you check
> that the address at which you start accessing memory is in userspace,
> and then you access memory more or less linearly forward from there,
> you'll never reach kernelspace addresses.
> 
>> IIRC, with invalid argument the mask turns the index into 0. A complete
>> speculation from my side of how it works is that you then able to
>> "inspect" or what's the right word the value of array[0] but not a
>> address of memory of choice.
> 
> Yeah, exactly, that's the idea of array_index_nospec(). As the comment
> above the generic version of array_index_mask_nospec() describes, the
> mask used for the bitwise AND in array_index_nospec() is generated as
> follows:
> "When @index is out of bounds (@index >= @size), the sign bit will be
> set.  Extend the sign bit to all bits and invert, giving a result of
> zero for an out of bounds index, or ~0 if within bounds [0, @size)."
> 
> The X86 version of array_index_mask_nospec() just does the same with
> optimized assembly code. But there are architectures, like arm64, that
> actually do more than just this - arm64's array_index_mask_nospec()
> additionally includes a csdb(), which is some arm64 barrier for some
> kinds of speculation. (So, for example, open-coding a bitwise AND may
> not be enough on all architectures.)

Good to know, thanks

>> Then in our case, considering that
>> mappings are page sized, array_index_nospec() would clamp it to either
>> first 32 bytes of the first page or to absolute addresses [0, 32)
>> in case size==0 and the mapping is NULL. But that could be just my
>> fantasy.
> 
> Without having looked at this uring code in detail: What you're saying
> sounds reasonable to me. Though one thing to be careful with is that
> if the value you're masking is a byte offset, you should ideally make
> sure to give array_index_mask_nospec() a limit that is something like
> the size of the region minus the size of an element - you should

Good point, thanks. I'll prepare something based on it.

> probably assume that the preceding "if (unlikely(offset %
> sizeof(long)))" could be bypassed in speculation, though in practice

That is there because of arches that don't like unaligned accesses,
and size checks don't rely on it. It doesn't seems we should worry
about it.

> that's probably unlikely since it'd compile into something
> straightforward like a bitmask-and-test with immediate operands.

-- 
Pavel Begunkov

