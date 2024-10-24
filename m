Return-Path: <io-uring+bounces-3995-lists+io-uring=lfdr.de@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [139.178.88.99])
	by mail.lfdr.de (Postfix) with ESMTPS id 317A79AEDBF
	for <lists+io-uring@lfdr.de>; Thu, 24 Oct 2024 19:21:03 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id E480128700F
	for <lists+io-uring@lfdr.de>; Thu, 24 Oct 2024 17:21:01 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 6026B1EF933;
	Thu, 24 Oct 2024 17:19:25 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel-dk.20230601.gappssmtp.com header.i=@kernel-dk.20230601.gappssmtp.com header.b="AxoPkHQX"
X-Original-To: io-uring@vger.kernel.org
Received: from mail-il1-f176.google.com (mail-il1-f176.google.com [209.85.166.176])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 153001FC7EE
	for <io-uring@vger.kernel.org>; Thu, 24 Oct 2024 17:19:22 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.166.176
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1729790365; cv=none; b=ucsYFr9+m0csmPH8PlX4nY2RyimClDd4eNWnAo/BBx11dXE/lk2tTWVseqBXMcHX5/PgDl3/YNS6/VrTInJ/QgP6E4hMux2xcOXf0F463IqonwoH324A+iS7gINeTR7GyBvgnIwboMHRUUkegNPBfN3aslOMT0njqfnjebZ8blc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1729790365; c=relaxed/simple;
	bh=GTCEECU/MhO4cNvWj38wUgeRUzlsTpekEVoIX942p/o=;
	h=Message-ID:Date:MIME-Version:Subject:To:References:From:
	 In-Reply-To:Content-Type; b=M27w5zj+cg8Sy6smX8FKIkcOCr+goCAp5X/uLbYh+R7mHKSjK1j4ESbG31hv7wI31Ke77zcB8upLYu9VJLhEeqARaOM8VMnYe4WqWMrjUmndroJyLKQjtOj7Nln8R4EQYWGigRmc25h77rOqDGBFE0Q4j1ZxN76tRGOVHniLPyQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=kernel.dk; spf=pass smtp.mailfrom=kernel.dk; dkim=pass (2048-bit key) header.d=kernel-dk.20230601.gappssmtp.com header.i=@kernel-dk.20230601.gappssmtp.com header.b=AxoPkHQX; arc=none smtp.client-ip=209.85.166.176
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=kernel.dk
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=kernel.dk
Received: by mail-il1-f176.google.com with SMTP id e9e14a558f8ab-3a3b7d95a11so4374025ab.2
        for <io-uring@vger.kernel.org>; Thu, 24 Oct 2024 10:19:22 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernel-dk.20230601.gappssmtp.com; s=20230601; t=1729790362; x=1730395162; darn=vger.kernel.org;
        h=content-transfer-encoding:in-reply-to:from:content-language
         :references:to:subject:user-agent:mime-version:date:message-id:from
         :to:cc:subject:date:message-id:reply-to;
        bh=nn+STTqCsnbasH90L303pDK/1gx6TfMPZkiDuchhY3w=;
        b=AxoPkHQXLVN+J/WWz4lITNmBA9L1ap4AxaKOc5CvaeRYpmLkRaRtQ+V7poj8PTmAjI
         eAf3DrWvdk/o30wwP/MFHriJBmj1hhcqxOc2vtGskE/89WHaO4kAQDA9pm0cmB2yS/nu
         CHR+eEo9ofripTL6L30Kf0UCD60xIRpbmXZDa4EcE8QTMzz+sptyztaM6bhj+nWOKczz
         HgAJrHTZolCE2UyjKvlQsYVX9fKrOur41DNlbulan6/dnjnW880397jrvt9jmChq7DEZ
         K4UkX7JEOx3Vx8xbvOL3HmS5/Mck0TWJS5T0GyOuMD/ozD2YoGwEuxrnjgz+gn5md6Xu
         cf8Q==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1729790362; x=1730395162;
        h=content-transfer-encoding:in-reply-to:from:content-language
         :references:to:subject:user-agent:mime-version:date:message-id
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=nn+STTqCsnbasH90L303pDK/1gx6TfMPZkiDuchhY3w=;
        b=dXwL8IWmrcnYfPGsk4DJ4ERjAjEzF5ddDcF7wr6gWZFNnGMvHj8ZJR0JhYy0t7ghUa
         43bTeNUfZD3GpRR1fJ2L6IQRLgxG1GlqmYzLPkhKbKDKyE2I7FM7i9B9KQhoe7/04MtY
         mepIpjByP2sAXHc1j7PKSzFVlY2kvLyW3Q2hS0oBo24/f/jwQW99WB8f/vxwpWM8UHgf
         TNoYhFYKAqKAf5TKFfFwHviHvq+4jubMrPFrPalYdteBVJF27CcZsjCJxzHgvZLDosd/
         NysBKUymK9Y/1xXeubW1il+DcuuaN8uzLzEv5w0EWGDRBRg5sF2E/UzdPoddzqEDfINt
         GrUA==
X-Forwarded-Encrypted: i=1; AJvYcCVNiojdG+lAMo4ywszOWV8ex9eby/8jjHb8jU1uVXH3R0rkMqRCOwcZw93KPiw410PdXgV4g/5WDQ==@vger.kernel.org
X-Gm-Message-State: AOJu0YxOhrYWqWOg7TTQWKTWm4ebVmpiTyqLGkapHdPBzuxIIx5DEPcE
	vY5/VsL7EzyGT9KL6GKVr6AsBGIcTAIku/xq1prrkAfcOfSMk4RCdJpwotg2z4J7+zJYGlC230s
	0
X-Google-Smtp-Source: AGHT+IH0DNHMS9aiiPyWlB3uZN74gIWvGqlwsZWPhy7Wk1f4qHvAc0FB7LqBIwa48L586p5afjszSw==
X-Received: by 2002:a05:6e02:1522:b0:39b:330b:bb25 with SMTP id e9e14a558f8ab-3a4de7a2df5mr30545875ab.12.1729790362000;
        Thu, 24 Oct 2024 10:19:22 -0700 (PDT)
Received: from [192.168.1.116] ([96.43.243.2])
        by smtp.gmail.com with ESMTPSA id e9e14a558f8ab-3a400b639a6sm31291095ab.62.2024.10.24.10.19.21
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Thu, 24 Oct 2024 10:19:21 -0700 (PDT)
Message-ID: <3e6c3ff5-9116-4d50-9fa8-aae85ad24abc@kernel.dk>
Date: Thu, 24 Oct 2024 11:19:20 -0600
Precedence: bulk
X-Mailing-List: io-uring@vger.kernel.org
List-Id: <io-uring.vger.kernel.org>
List-Subscribe: <mailto:io-uring+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:io-uring+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH 0/4] implement vectored registered buffers for sendzc
To: Pavel Begunkov <asml.silence@gmail.com>, io-uring@vger.kernel.org
References: <cover.1729650350.git.asml.silence@gmail.com>
 <b15e136f-3dbd-4d4e-92c5-103ecffe3965@kernel.dk>
 <bfbe577b-1092-47a2-ab6c-d358f55003dc@gmail.com>
 <28964ec6-34a7-49b8-88f5-7aaf0e1e4e3f@kernel.dk>
 <3e28f0bb-4739-40de-93c7-9b207d90d7c5@gmail.com>
Content-Language: en-US
From: Jens Axboe <axboe@kernel.dk>
In-Reply-To: <3e28f0bb-4739-40de-93c7-9b207d90d7c5@gmail.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit

On 10/24/24 10:06 AM, Pavel Begunkov wrote:
> On 10/24/24 16:45, Jens Axboe wrote:
>> On 10/24/24 9:29 AM, Pavel Begunkov wrote:
>>> On 10/23/24 14:52, Jens Axboe wrote:
>>>> On 10/22/24 8:38 PM, Pavel Begunkov wrote:
>>>>> Allow registered buffers to be used with zerocopy sendmsg, where the
>>>>> passed iovec becomes a scatter list into the registered buffer
>>>>> specified by sqe->buf_index. See patches 3 and 4 for more details.
>>>>>
>>>>> To get performance out of it, it'll need a bit more work on top for
>>>>> optimising allocations and cleaning up send setups. We can also
>>>>> implement it for non zerocopy variants and reads/writes in the future.
>>>>>
>>>>> Tested by enabling it in test/send-zerocopy.c, which checks payloads,
>>>>> and exercises lots of corner cases, especially around send sizes,
>>>>> offsets and non aligned registered buffers.
>>>>
>>>> Just for the edification of the list readers, Pavel and I discussed this
>>>> a bit last night. There's a decent amount of overlap with the send zc
>>>> provided + registered buffers work that I did last week, but haven't
>>>> posted yet. It's here;
>>>>
>>>> https://git.kernel.dk/cgit/linux/log/?h=io_uring-sendzc-provided
>>>>
>>>> in terms of needing and using both bvec and iovec in the array, and
>>>> having the suitable caching for the arrays rather than needing a full
>>>> alloc + free every time.
>>>
>>> And as I mentioned, that can be well done in-place (in the same
>>> array) as one option.
>>
>> And that would be the way to do it, like I mentioned as well, that is
>> how my first iteration of the above did it too. But since this one just
>> needs to end up with an array of bvec, it was pointless for my series to
>> do the iovec import and only then turn it into bvecs.
>>
>> So somewhat orthogonal, as the use cases aren't exactly the same. One
>> deals with iovecs out of necessity, the other one only previously did as
>> a matter of convenience to reuse existing iovec based helpers.
>>
>>>> The send zc part can map into bvecs upfront and hence don't need the
>>>> iovec array storage at the same time, which this one does as the sendmsg
>>>> zc opcode needs to import an iovec. But perhaps there's a way to still
>>>> unify the storage and retain the caching, without needing to come up
>>>> with something new.
>>>
>>> I looked through. The first problem is that your thing consuming
>>> entries from the ring, with iovecs it'd need to be reading it
>>> from the user one by one. Considering allocations in your helpers,
>>> that would turn it into a bunch of copy_from_user, and it might
>>> just easier and cleaner to copy the entire iovec.
>>
>> I think for you case, incremental import would be the way to go. Eg
>> something ala:
>>
>> if (!user_access_begin(user_iovec, nr_vecs * sizeof(*user_iovec)))
>>     return -EFAULT;
> 
> Is it even legal? I don't know how it's implemented specifically
> but I assume there can be any kind of magic, e.g. intercepting
> page faults. I'd definitely prefer to avoid anything but the simplest
> handling like read from/write to memory, e.g. no allocations.
> 
>>
>> bv = kmsg->bvec;
>> for_each_iov {
>>     struct iovec iov;
>>
>>     unsafe_get_user(iov.iov_base, &user_iovec->iov_base, foo);
>>     unsafe_get_user(iov.iov_len, &user_iovec->iov_len, foo);
>>
>>     import_to_bvec(bv, &iov);
>>
>>     user_iovec++;
>>     bv++;
>> }
>>
>> if it can be done at prep time, because then there's no need to store
>> the iovec at all, it's already stable, just in bvecs. And this avoids
>> overlapping iovec/bvec memory, and it avoids doing two iterations for
>> import. Purely a poc, just tossing out ideas.
>>
>> But I haven't looked too closely at your series yet. In any case,
>> whatever ends up working for you, will most likely be find for the
>> bundled zerocopy send (non-vectored) as well, and I can just put it on
>> top of that.
>>
>>> And you just made one towards delaying the imu resolution, which
>>> is conceptually the right thing to do because of the mess with
>>> links, just like it is with fixed files. That's why it need to
>>> copy the iovec at the prep stage and resolve at the issue time.
>>
>> Indeed, prep time is certainly the place to do it. And the above
>> incremental import should work fine then, as we won't care abot
>> user_iovec being stable being prep.
> 
> Seems like you're agreeing but then stating the opposite, there
> is some confusion. I'm saying that IMHO the right API wise way
> is resolving an imu at issue time, just like it's done for fixed
> files, and what your recent series did for send zc.

Yeah early morning confusion I guess. And I do agree in principle,
though for registered buffers, those have to be registered upfront
anyway, so no confusion possible with prep vs issue there. For provided
buffers, it only matters for the legacy ones, which generally should not
be used. Doesn't change the fact that you're technically correct, the
right time to resolve them would be at issue time.

-- 
Jens Axboe

