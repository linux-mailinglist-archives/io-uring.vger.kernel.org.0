Return-Path: <io-uring+bounces-4017-lists+io-uring=lfdr.de@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [IPv6:2604:1380:4601:e00::3])
	by mail.lfdr.de (Postfix) with ESMTPS id BBFA69AF595
	for <lists+io-uring@lfdr.de>; Fri, 25 Oct 2024 00:51:09 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id 393D11F22527
	for <lists+io-uring@lfdr.de>; Thu, 24 Oct 2024 22:51:09 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id A77BC1F81AC;
	Thu, 24 Oct 2024 22:51:04 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="D5hVJizg"
X-Original-To: io-uring@vger.kernel.org
Received: from mail-ed1-f47.google.com (mail-ed1-f47.google.com [209.85.208.47])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 29B8422B644
	for <io-uring@vger.kernel.org>; Thu, 24 Oct 2024 22:51:01 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.208.47
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1729810264; cv=none; b=D9OonK0pg/c96iwOLypvn7slWGkx0lwyhH9yqCgjSGhPldJHb/fwZrIPjvDHdkMYUR3G0V1cB6Dg7MT+P+rts9YQ4iPZFnn0zTGNoWJyjbMAztbGhKAW/OYL20LGxgJnTcfwUl7RoogQjcql0UaxE+F2XkrqYqQSzQLe6g0mkfU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1729810264; c=relaxed/simple;
	bh=qbFDBXHaTZwvPRTibAmtx3C0JDkEbHiNmNRhQdCqTvs=;
	h=Message-ID:Date:MIME-Version:Subject:To:References:From:
	 In-Reply-To:Content-Type; b=sUhpDQZxDT02U6c/zj3u+h/9V6rzYbPzJ13sHwNjvUP8DStGsRLIVkSpflxpFSicFpkeBwY2HbsojrqbpKdwWbGYgcdgm90I7snCqzjAcLkK022cy9pNC9kuRxOVy+vboz9HkN/b4yv7eDxwaqDx9ek/g3z6Bn3jPX+lEBnQJXg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=D5hVJizg; arc=none smtp.client-ip=209.85.208.47
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Received: by mail-ed1-f47.google.com with SMTP id 4fb4d7f45d1cf-5cb72918bddso1881326a12.3
        for <io-uring@vger.kernel.org>; Thu, 24 Oct 2024 15:51:01 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1729810260; x=1730415060; darn=vger.kernel.org;
        h=content-transfer-encoding:in-reply-to:from:content-language
         :references:to:subject:user-agent:mime-version:date:message-id:from
         :to:cc:subject:date:message-id:reply-to;
        bh=RMxYEtyWJJiOFckfSwzfv7vEJaJrbHxi0KSmyIn0LZk=;
        b=D5hVJizgBZmsy/DLnJOQZFKyHObj90iUCQwd5mcfD8qkPK2O/N19pfUrsOEFaGjZmz
         BQg4LJJsqgW5gEmYC9ogGLE+hR5IUzKJXIf4OayiEYGgcpPxbAJcViMucS9yKGWfm/to
         b3z0YV6nGNuwR/tNirD4AiK8tKA87aoBZfDgMM9JJ1VS/eRYLxPS0tG36I0pcRDDq+SK
         DRTsgVLXyk1v6WkgS2uiKog1cYxy5RwqIoAASLtmxeNDmpNLMKR9l66oEHJVJMIAYFNO
         ITgz9W6vxKAvRzDTa4cZTxxAccckg+TE1ziWtw4Eoce9FUm9ialX8qaIw3vr7N+yjYK1
         Ortw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1729810260; x=1730415060;
        h=content-transfer-encoding:in-reply-to:from:content-language
         :references:to:subject:user-agent:mime-version:date:message-id
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=RMxYEtyWJJiOFckfSwzfv7vEJaJrbHxi0KSmyIn0LZk=;
        b=Ks2AL+KNR0x0fOqKZXsXQsF1vU0XZ9u1LOYsvkKXmJ9R0rcfsDMP2hsu/gnkpgIR9Y
         fkbKTKCpvs42TwijJIYV55xH/TpwiyyvvHjoI/uTm0RQDB4rCkIhdAHbcd3pxR3UcyuI
         7ASvH28iHMG22fUE2KDWG8Uq/1UHT0f3vhHFgaoA02u9sxpup/BZOGtp8A20UrljgaHU
         3r5KwLWvjKFZoPZpdZKdEWrRDDDY0Z7V++VevkQHrbNg9f2Ts/Ly/nFDzFOrj/eFjH4f
         F8oB64iHAfriqN5u2FVRNrujTYLiyNi68UeUeFu1cgH3REHqnpl675e7jBYm7FLwYeDm
         Ap4w==
X-Forwarded-Encrypted: i=1; AJvYcCXKL6xHo4Dgj8MbyUvc47T5f+OYNxt3UHsAVl7VfFRKKJE8D4IZxAb5B0bGOuW2zThXWnxN0MA75g==@vger.kernel.org
X-Gm-Message-State: AOJu0YxTNT5PKfYdiT1JhQkSmOSji/unBMtiv32aA5uPA1oLKLdMHRa3
	Nj5IUC4qY30gGkYcROe8waFJyqiumG4WfS4+ZhqX96rEeLgpOmmC
X-Google-Smtp-Source: AGHT+IEVabXPY/7TY90TUNALGFcy9f7RIAUE9h8RibLAg3arEe/NLAxDFKLK6w3T+OFtLwnM3zLCqA==
X-Received: by 2002:a05:6402:380a:b0:5cb:6706:ccd with SMTP id 4fb4d7f45d1cf-5cb8af6c613mr6182801a12.25.1729810259964;
        Thu, 24 Oct 2024 15:50:59 -0700 (PDT)
Received: from [192.168.42.26] ([85.255.233.224])
        by smtp.gmail.com with ESMTPSA id 4fb4d7f45d1cf-5cb66c6b974sm6124014a12.67.2024.10.24.15.50.59
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Thu, 24 Oct 2024 15:50:59 -0700 (PDT)
Message-ID: <527e3fa3-cfcb-437a-80b1-1526358abcd6@gmail.com>
Date: Thu, 24 Oct 2024 23:51:33 +0100
Precedence: bulk
X-Mailing-List: io-uring@vger.kernel.org
List-Id: <io-uring.vger.kernel.org>
List-Subscribe: <mailto:io-uring+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:io-uring+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH 0/4] implement vectored registered buffers for sendzc
To: Jens Axboe <axboe@kernel.dk>, io-uring@vger.kernel.org
References: <cover.1729650350.git.asml.silence@gmail.com>
 <b15e136f-3dbd-4d4e-92c5-103ecffe3965@kernel.dk>
 <bfbe577b-1092-47a2-ab6c-d358f55003dc@gmail.com>
 <28964ec6-34a7-49b8-88f5-7aaf0e1e4e3f@kernel.dk>
 <3e28f0bb-4739-40de-93c7-9b207d90d7c5@gmail.com>
 <3e6c3ff5-9116-4d50-9fa8-aae85ad24abc@kernel.dk>
 <3376be3e-e5c4-4fbb-95bb-b3bcd0e9bd8b@gmail.com>
 <67f9a2b9-f2bd-4abd-a4a5-c1c5e8beda61@kernel.dk>
 <d8da2a22-948b-4837-a69a-e9e91e37feec@gmail.com>
 <daeacc90-e5b4-471d-a79e-74ae10eb4aba@kernel.dk>
 <4f38ca15-a341-4d93-80eb-18f79fdd6664@gmail.com>
 <ce033359-a17a-4303-bd57-0ad66b5138fc@kernel.dk>
Content-Language: en-US
From: Pavel Begunkov <asml.silence@gmail.com>
In-Reply-To: <ce033359-a17a-4303-bd57-0ad66b5138fc@kernel.dk>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit

On 10/24/24 23:22, Jens Axboe wrote:
> On 10/24/24 4:14 PM, Pavel Begunkov wrote:
>> On 10/24/24 20:56, Jens Axboe wrote:
>>> On 10/24/24 12:13 PM, Pavel Begunkov wrote:
>>>> On 10/24/24 19:00, Jens Axboe wrote:
>>>>> On 10/24/24 11:56 AM, Pavel Begunkov wrote:
>>>>>> On 10/24/24 18:19, Jens Axboe wrote:
>>>>>>> On 10/24/24 10:06 AM, Pavel Begunkov wrote:
>>>>>>>> On 10/24/24 16:45, Jens Axboe wrote:
>>>> ...>>>> Seems like you're agreeing but then stating the opposite, there
>>>>>>>> is some confusion. I'm saying that IMHO the right API wise way
>>>>>>>> is resolving an imu at issue time, just like it's done for fixed
>>>>>>>> files, and what your recent series did for send zc.
>>>>>>>
>>>>>>> Yeah early morning confusion I guess. And I do agree in principle,
>>>>>>> though for registered buffers, those have to be registered upfront
>>>>>>> anyway, so no confusion possible with prep vs issue there. For provided
>>>>>>> buffers, it only matters for the legacy ones, which generally should not
>>>>>>> be used. Doesn't change the fact that you're technically correct, the
>>>>>>> right time to resolve them would be at issue time.
>>>>>>
>>>>>> I'm talking about sendmsg with iovec. Registered buffers should
>>>>>> be registered upfront, that's right, but iovec should be copied
>>>>>> at prep, and finally resolved into bvecs incl the imu/buffer lookup
>>>>>> at the issue time. And those are two different points in time,
>>>>>> maybe because of links, draining or anything else. And if they
>>>>>> should be at different moments, there is no way to do it while
>>>>>> copying iovec.
>>>>>
>>>>> Oh I totally follow, the incremental approach would only work if it can
>>>>> be done at prep time. If at issue time, then it has to turn an existing
>>>>> iovec array into the appropriate bvec array. And that's where you'd have
>>>>> to do some clever bits to avoid holding both a full bvec and iovec array
>>>>> in memory, which would be pretty wasteful/inefficient. If done at issue
>>>>
>>>> Why would it be wasteful and inefficient? No more than jumping
>>>> though that incremental infra for each chunk, doubling the size
>>>> of the array / reallocating / memcpy'ing it, instead of a tight
>>>> loop doing the entire conversion.
>>>
>>> Because it would prevent doing an iovec at-the-time import, then turning
>>> it into the desired bvec. That's one loop instead of two. You would have
>>> the space upfront, there should be no need to realloc+memcpy. And then
>>> there's the space concern, where the initial import is an iovec, and
>>> then you need a bvec. For 64-bit that's fine as they take up the same
>>> amount of space,
>>
>> That's not true, each iov can produce multiple bvec entries so
>> iovs might get overwritten if you do it the simplest way.
> 
> What part isn't true? Yeah one iovec can turn into multiple bvec
> segments, the provided send zc stuff I sent does deal with that. So yeah
> it's not necessarily a 1:1 mapping, and even if they have the same size,
> you may need more elements on the bvec size.

Ok, you didn't state why 64 bit is fine, what I'm saying is that
irrelevant of the element size, if you have an iovec array with
free space at the end just enough so that after overwriting iovecs
it can fit in the resulting bvec, a simple in place algorithm from
left to right will still fail.

> Doesn't change the fact that you can loop once and do it. If you need to
> expand the bvec size, that would be a realloc+copy. But that part is
> true even if you first import all iovecs, and then iterate them to map
> the bvecs. Unless you do some upfront tracking to know how many elements
> you need, but that would seem overly convoluted. With caching, the
> expansion should be a rare occurence outside of the initial import into
> a new region.
> 
>>> but for 32-bit it'd make incremental importing from a
>>> stable iovec to a bvec array a bit more tricky (and would need realloc,
>>> unless you over-alloc'ed for the iovec array upfront).
>>
>> And that's not true, you can still well do it in place if
>> iovec is placed right in the memory, which I explicitly
>> noted there are simple enough ways to do it in place
>> without extra reallocs.
> 
> I don't think anything stated there is untrue, just saying it's a bit

"and would need realloc, unless you over-alloc'ed for the iovec array
upfront", that one is if in the second part you're talking about
array_size = bvec_size + iovec_size (in bytes). All you need is max
of two for making it in place.

> more tricky. Which is certainly true, if it's the same memory region and
> there's overlaps. But let's just see the code for it, much easier to
> discuss over those parts rather than pontificate hypotheticals :-)
> 

-- 
Pavel Begunkov

