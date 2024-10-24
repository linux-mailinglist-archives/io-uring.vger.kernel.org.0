Return-Path: <io-uring+bounces-3998-lists+io-uring=lfdr.de@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [IPv6:2604:1380:45e3:2400::1])
	by mail.lfdr.de (Postfix) with ESMTPS id BEE629AEF0B
	for <lists+io-uring@lfdr.de>; Thu, 24 Oct 2024 20:00:30 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 7E00E2843FB
	for <lists+io-uring@lfdr.de>; Thu, 24 Oct 2024 18:00:29 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 0CE0A1F8196;
	Thu, 24 Oct 2024 18:00:26 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel-dk.20230601.gappssmtp.com header.i=@kernel-dk.20230601.gappssmtp.com header.b="makQnCDW"
X-Original-To: io-uring@vger.kernel.org
Received: from mail-io1-f52.google.com (mail-io1-f52.google.com [209.85.166.52])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 921681F81BC
	for <io-uring@vger.kernel.org>; Thu, 24 Oct 2024 18:00:20 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.166.52
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1729792825; cv=none; b=oVWL9zAoSropitEocQZAFJ2zc5VjxX1PPpzDNMwWs7cNq5czl8k8kI9VkfgeyY5oQeaEs3oJair769lvhOImREL8GA1/OrfHXvXNCWnim1BDb4NteX0RkyysOV/5B+uCZLjkUabTy2XMX943r0n2IACQn5v2KRpcl+vu/VbWjVM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1729792825; c=relaxed/simple;
	bh=MGLjocNeTGdl31YEJFTrqCbb949FzW593aShsAV0Ctc=;
	h=Message-ID:Date:MIME-Version:Subject:To:References:From:
	 In-Reply-To:Content-Type; b=FGZxj82A1L1IyPZQKa2n9zSUzNouFYgpwfjtsJmOb5RhVJ0HGJYQnWq0h3SkErDGUCbaw/bPbDzzIm1s7RQyEu7x+grDNaBn8K1l04HJSlKJpqELD891WgtlR+jIpqaVrYJmYYUhkqQNDBEZrC7N2mQdS/nR0PFD10s/bi/qSM8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=kernel.dk; spf=pass smtp.mailfrom=kernel.dk; dkim=pass (2048-bit key) header.d=kernel-dk.20230601.gappssmtp.com header.i=@kernel-dk.20230601.gappssmtp.com header.b=makQnCDW; arc=none smtp.client-ip=209.85.166.52
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=kernel.dk
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=kernel.dk
Received: by mail-io1-f52.google.com with SMTP id ca18e2360f4ac-83aacecc8efso75292639f.0
        for <io-uring@vger.kernel.org>; Thu, 24 Oct 2024 11:00:20 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernel-dk.20230601.gappssmtp.com; s=20230601; t=1729792819; x=1730397619; darn=vger.kernel.org;
        h=content-transfer-encoding:in-reply-to:from:content-language
         :references:to:subject:user-agent:mime-version:date:message-id:from
         :to:cc:subject:date:message-id:reply-to;
        bh=ClHwk8L4cetZ7oWYC8z3f5MmTwG9tRf1Q8L7cch1kj8=;
        b=makQnCDWuvcZnjzjqfaJT/Z7ATSUJ3EJlcEKTZBdC+eWyRsYpsM2fQJHs/m67d6LOb
         Wi93XfEYJ3VXWFllkcPeasz/0Ah5GG80jhWBQ/xGgTIHYnyuS4JBwPhmuueX62F7HcC0
         EHCfzip6b0Jgjl1MnCbBQJLyzspX5qaSmQjOPSSrdXdY1MRneN9GaApy5QjuIqHJY1iF
         lnpz91PemnlFNv9xIS0x9YsXdSiBPsfI9TueIEVUG34Pqe+5r+5laNPRvbnFrBluYA2x
         vbnUZ2GqfENf+FPFAPp2PTaRgSCk2WKxlg+vXl2+PNcN829BgWfBvQT9LOG7p4I9aHbs
         wv3g==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1729792819; x=1730397619;
        h=content-transfer-encoding:in-reply-to:from:content-language
         :references:to:subject:user-agent:mime-version:date:message-id
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=ClHwk8L4cetZ7oWYC8z3f5MmTwG9tRf1Q8L7cch1kj8=;
        b=eI5PUZLvnET5qm7VdAoyPQXHCzwXVigzVXbVllaltsTwiktWYv8wL+KozyaF6jHSSa
         uTEq98hecTjBBwIzvlxc/RmkfqWdhw8Z3ZlyXLUurt5UvI0Iy0dqoPsuzDQMo5XHLUoV
         LdtwtVL5VfMDrmGvneMzZXfo/jMsDIaxjjL6+itQSRjLg0nKTEMq+cgx9r953lbzmFj1
         kdKWAXeof+dLIJdic5fAsvOKXkyI3Bw0lo++RQjMqwahveguTzGSI+lWnjkGcet4nn3I
         nSaW6LFwb9fDQ0I1vCvi9wcdg9PX0KjS9HcxDwn0O7B+VCMQuPy2ffUoC6M8WN33jFKS
         BdvA==
X-Forwarded-Encrypted: i=1; AJvYcCWsA5p10cRrE2PfEwXDvYCyM6tUJQp2ENmGVGo7EVQO540yet2/VsEI6G8x4h+nouy5lt1FCmEu1Q==@vger.kernel.org
X-Gm-Message-State: AOJu0YwQoBYd///Q0dw11kiZhLFAaqHOv5l38rVRhKgOKjGZzrw9L3u3
	fCObu3n9oQBW0Y8FOOhhDvd8rNvFyAvaS+acK7lv7m8Icq+NYIz7Bgf6SmN60Bsx3haRCPAjKBz
	q
X-Google-Smtp-Source: AGHT+IGoFq7Bmy6vNk8hzUXxSZ2s5o8d9Wz+xdAI+ujrDoCs66yiZ9M4BkzlRBQAbMQtZFgq4DLDbg==
X-Received: by 2002:a05:6e02:20c8:b0:39d:3c87:1435 with SMTP id e9e14a558f8ab-3a4de6f6b3dmr23245245ab.1.1729792819299;
        Thu, 24 Oct 2024 11:00:19 -0700 (PDT)
Received: from [192.168.1.116] ([96.43.243.2])
        by smtp.gmail.com with ESMTPSA id 8926c6da1cb9f-4dc2a6091bfsm2772217173.97.2024.10.24.11.00.18
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Thu, 24 Oct 2024 11:00:18 -0700 (PDT)
Message-ID: <67f9a2b9-f2bd-4abd-a4a5-c1c5e8beda61@kernel.dk>
Date: Thu, 24 Oct 2024 12:00:17 -0600
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
 <3e6c3ff5-9116-4d50-9fa8-aae85ad24abc@kernel.dk>
 <3376be3e-e5c4-4fbb-95bb-b3bcd0e9bd8b@gmail.com>
Content-Language: en-US
From: Jens Axboe <axboe@kernel.dk>
In-Reply-To: <3376be3e-e5c4-4fbb-95bb-b3bcd0e9bd8b@gmail.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit

On 10/24/24 11:56 AM, Pavel Begunkov wrote:
> On 10/24/24 18:19, Jens Axboe wrote:
>> On 10/24/24 10:06 AM, Pavel Begunkov wrote:
>>> On 10/24/24 16:45, Jens Axboe wrote:
> ...
>>>> bv = kmsg->bvec;
>>>> for_each_iov {
>>>>      struct iovec iov;
>>>>
>>>>      unsafe_get_user(iov.iov_base, &user_iovec->iov_base, foo);
>>>>      unsafe_get_user(iov.iov_len, &user_iovec->iov_len, foo);
>>>>
>>>>      import_to_bvec(bv, &iov);
>>>>
>>>>      user_iovec++;
>>>>      bv++;
>>>> }
>>>>
>>>> if it can be done at prep time, because then there's no need to store
>>>> the iovec at all, it's already stable, just in bvecs. And this avoids
>>>> overlapping iovec/bvec memory, and it avoids doing two iterations for
>>>> import. Purely a poc, just tossing out ideas.
>>>>
>>>> But I haven't looked too closely at your series yet. In any case,
>>>> whatever ends up working for you, will most likely be find for the
>>>> bundled zerocopy send (non-vectored) as well, and I can just put it on
>>>> top of that.
>>>>
>>>>> And you just made one towards delaying the imu resolution, which
>>>>> is conceptually the right thing to do because of the mess with
>>>>> links, just like it is with fixed files. That's why it need to
>>>>> copy the iovec at the prep stage and resolve at the issue time.
>>>>
>>>> Indeed, prep time is certainly the place to do it. And the above
>>>> incremental import should work fine then, as we won't care abot
>>>> user_iovec being stable being prep.
>>>
>>> Seems like you're agreeing but then stating the opposite, there
>>> is some confusion. I'm saying that IMHO the right API wise way
>>> is resolving an imu at issue time, just like it's done for fixed
>>> files, and what your recent series did for send zc.
>>
>> Yeah early morning confusion I guess. And I do agree in principle,
>> though for registered buffers, those have to be registered upfront
>> anyway, so no confusion possible with prep vs issue there. For provided
>> buffers, it only matters for the legacy ones, which generally should not
>> be used. Doesn't change the fact that you're technically correct, the
>> right time to resolve them would be at issue time.
> 
> I'm talking about sendmsg with iovec. Registered buffers should
> be registered upfront, that's right, but iovec should be copied
> at prep, and finally resolved into bvecs incl the imu/buffer lookup
> at the issue time. And those are two different points in time,
> maybe because of links, draining or anything else. And if they
> should be at different moments, there is no way to do it while
> copying iovec.

Oh I totally follow, the incremental approach would only work if it can
be done at prep time. If at issue time, then it has to turn an existing
iovec array into the appropriate bvec array. And that's where you'd have
to do some clever bits to avoid holding both a full bvec and iovec array
in memory, which would be pretty wasteful/inefficient. If done at issue
time, then there's no way around a second iteration :/

-- 
Jens Axboe

