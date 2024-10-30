Return-Path: <io-uring+bounces-4246-lists+io-uring=lfdr.de@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [IPv6:2604:1380:45e3:2400::1])
	by mail.lfdr.de (Postfix) with ESMTPS id AEE619B6E57
	for <lists+io-uring@lfdr.de>; Wed, 30 Oct 2024 22:04:29 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 8CE4A2812B1
	for <lists+io-uring@lfdr.de>; Wed, 30 Oct 2024 21:04:27 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id F20D01DF739;
	Wed, 30 Oct 2024 21:04:24 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel-dk.20230601.gappssmtp.com header.i=@kernel-dk.20230601.gappssmtp.com header.b="kZdqKcrK"
X-Original-To: io-uring@vger.kernel.org
Received: from mail-io1-f45.google.com (mail-io1-f45.google.com [209.85.166.45])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 21B5414F90
	for <io-uring@vger.kernel.org>; Wed, 30 Oct 2024 21:04:21 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.166.45
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1730322264; cv=none; b=QNcc/MHitZ5ezxLvmgfuwzEvSoi1QLRPvadMMp1GzLXomFqbv05rJc3cEeJdKE8AowVOY9Hg1PCYlvaPqar8tVMRxxztB4IrRsfZk1BmsW4FsG7uXfq1sSUHyBr7ZwrQrVffS0O2x3wEvoW1Nu4T97NHSUieJod6c/9hNmeyf2Q=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1730322264; c=relaxed/simple;
	bh=LvAUOBO6pkopY9jPIPl5W6FF/ypewKuz1zIPdzMs8KI=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=ZoAM8TjSZ10MTxj80KY3IMznmGw9hcabfiB3wCjeGM3HlsNpknlCBvpjVvT8AnWpchq5AIaabQ+oUT+7vXyr1uS4eDnX9pHNZz1hO09MUu+DS5bEyKZL/zSKNWmYRyX4c1+q9qPWBhV2N2Nyr7luRwSPtaZS/NOT/F6S1oHb+SM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=kernel.dk; spf=pass smtp.mailfrom=kernel.dk; dkim=pass (2048-bit key) header.d=kernel-dk.20230601.gappssmtp.com header.i=@kernel-dk.20230601.gappssmtp.com header.b=kZdqKcrK; arc=none smtp.client-ip=209.85.166.45
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=kernel.dk
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=kernel.dk
Received: by mail-io1-f45.google.com with SMTP id ca18e2360f4ac-83aba65556cso9791639f.3
        for <io-uring@vger.kernel.org>; Wed, 30 Oct 2024 14:04:21 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernel-dk.20230601.gappssmtp.com; s=20230601; t=1730322261; x=1730927061; darn=vger.kernel.org;
        h=content-transfer-encoding:in-reply-to:from:content-language
         :references:cc:to:subject:user-agent:mime-version:date:message-id
         :from:to:cc:subject:date:message-id:reply-to;
        bh=gpwtXXRyToHrdH0EVL2AFZhDEkcFNU9cbbDIw71umLQ=;
        b=kZdqKcrKKomFFLGCX5rXylPOXrmO9aH95oC3PaBZtXemBNJ4ZxW8oMOz+A8jyi0qSu
         mOmfPJMIJbixjnwi65slKs+dXW63Hcs1cdp1iHKDtj4k5BVEJdBMH7LBLx1R1TjFFjZt
         xjNz2tjwkEBlE/Ozdn4xeECAmjTSImUqYRhuJKbeHa5bvmnIWGzPYeDxVt3+1in8Gl5x
         S/H3QsXsoKBydmHRNbqXTyAl9fQFrkAlHqDZdac6W8RmRiX05qwmY8RQFyP/mkzTjkBa
         Mi4o1HwccebkKaljy07YmvB/NH0EKMkctHxQzgH9mmnLz22Smlp8UWz6DMHvZ9NxG7hS
         6aRQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1730322261; x=1730927061;
        h=content-transfer-encoding:in-reply-to:from:content-language
         :references:cc:to:subject:user-agent:mime-version:date:message-id
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=gpwtXXRyToHrdH0EVL2AFZhDEkcFNU9cbbDIw71umLQ=;
        b=gnjrTHO1HU5cHVYK9J4OyGdQpYqz5YD+l5p3RalurKZUstsr1HW5oXD4acUxRxxltY
         en9Lb8R4cnXq/EQ9UGFaadqCgrY9u5r2brzeFKjUMRUYIiu5A6Nvzc177C14zoKP3U7g
         HC07f194hJ4lhPhaSXYE6r4LG7uEKEFb9Z6OHknAu6E7dqJ/jmIkMB8UivVIk+4pqYl1
         5INnL2q9LKnkSggi0xHdg/1E0NDxnwROVgX69gsi5On78ylFEIjNseUt1135VLqBUvxL
         YdCDSFA+WqaaqWzOMeShN0RhrAV5rOUGHhtk6TMNz3EaEiGlSe26rZyCrPxKUu3bIFK2
         wcjQ==
X-Gm-Message-State: AOJu0YxfKEkR4h7kphx0ASMDbeF7eunxIH8oN1tXzRHXvJEvDOOpXBLD
	qX+eoPU7521Tk3nKqn4xT8wvlWw0ZqeOUKxVwdxv2gj6u61ZbiKIMjGEB+dyEZXlgzv9KKhNa+n
	V0fs=
X-Google-Smtp-Source: AGHT+IFtt4JFkoENqRmA3sOc1usgdKKxjqsX+1u9nExzmE8ciGJQkUk/77qCNnNMA1LlyYCq/K4DwQ==
X-Received: by 2002:a05:6602:15cb:b0:83a:d3cc:779a with SMTP id ca18e2360f4ac-83b1c5e9a29mr1742608339f.11.1730322261211;
        Wed, 30 Oct 2024 14:04:21 -0700 (PDT)
Received: from [192.168.1.116] ([96.43.243.2])
        by smtp.gmail.com with ESMTPSA id ca18e2360f4ac-83b138050d8sm266076639f.33.2024.10.30.14.04.19
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Wed, 30 Oct 2024 14:04:20 -0700 (PDT)
Message-ID: <037d4950-d8f9-4a02-ba1a-d93f3cafd932@kernel.dk>
Date: Wed, 30 Oct 2024 15:04:19 -0600
Precedence: bulk
X-Mailing-List: io-uring@vger.kernel.org
List-Id: <io-uring.vger.kernel.org>
List-Subscribe: <mailto:io-uring+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:io-uring+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH RFC] io_uring/rsrc: add last-lookup cache hit to
 io_rsrc_node_lookup()
To: Jann Horn <jannh@google.com>, Robin Murphy <robin.murphy@arm.com>,
 Mark Rutland <mark.rutland@arm.com>, Will Deacon <will.deacon@arm.com>,
 Catalin Marinas <catalin.marinas@arm.com>
Cc: io-uring <io-uring@vger.kernel.org>
References: <db316d73-cb32-4f7f-beb0-68f253f5e0c5@kernel.dk>
 <CAG48ez1291n=0yi3PvT0V0YXxwtP9rUbXMghYsFdkia1Op8Mzw@mail.gmail.com>
 <eb449a55-f1de-4bab-a068-0cbfdd84267c@kernel.dk>
 <CAG48ez3W+dkCerwioHNiZCWKJkuf9aL1s6SxN8X=yJ=JbGMB9Q@mail.gmail.com>
Content-Language: en-US
From: Jens Axboe <axboe@kernel.dk>
In-Reply-To: <CAG48ez3W+dkCerwioHNiZCWKJkuf9aL1s6SxN8X=yJ=JbGMB9Q@mail.gmail.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit

On 10/30/24 3:01 PM, Jann Horn wrote:
> On Wed, Oct 30, 2024 at 9:25?PM Jens Axboe <axboe@kernel.dk> wrote:
>> On 10/30/24 11:20 AM, Jann Horn wrote:
>>> On Wed, Oct 30, 2024 at 5:58?PM Jens Axboe <axboe@kernel.dk> wrote:
>>>> This avoids array_index_nospec() for repeated lookups on the same node,
>>>> which can be quite common (and costly). If a cached node is removed from
>>>
>>> You're saying array_index_nospec() can be quite costly - which
>>> architecture is this on? Is this the cost of the compare+subtract+and
>>> making the critical path longer?
>>
>> Tested this on arm64, in a vm to be specific. Let me try and generate
>> some numbers/profiles on x86-64 as well. It's noticeable there as well,
>> though not quite as bad as the below example. For arm64, with the patch,
>> we get roughly 8.7% of the time spent getting a resource - without it's
>> 66% of the time. This is just doing a microbenchmark, but it clearly
>> shows that anything following the barrier on arm64 is very costly:
>>
>>   0.98 ?       ldr   x21, [x0, #96]
>>        ?     ? tbnz  w2, #1, b8
>>   1.04 ?       ldr   w1, [x21, #144]
>>        ?       cmp   w1, w19
>>        ?     ? b.ls  a0
>>        ? 30:   mov   w1, w1
>>        ?       sxtw  x0, w19
>>        ?       cmp   x0, x1
>>        ?       ngc   x0, xzr
>>        ?       csdb
>>        ?       ldr   x1, [x21, #160]
>>        ?       and   w19, w19, w0
>>  93.98 ?       ldr   x19, [x1, w19, sxtw #3]
>>
>> and accounts for most of that 66% of the total cost of the micro bench,
>> even though it's doing a ton more stuff than simple getting this node
>> via a lookup.
> 
> Ah, actually... a difference between x86 and arm64 is that arm64 does
> an extra Speculative Data Barrier here, while x86 just does some
> arithmetic. Which I think is to work around "data value predictions",
> in which case my idea of using bitwise AND probably isn't valid.
> 
> https://developer.arm.com/documentation/102816/0205/ section "Software
> Mitigations" says "Such code sequences are based around specific data
> processing operations (for example conditional select or conditional
> move) and a new barrier instruction (CSDB). The combination of both a
> conditional select/conditional move and the new barrier are sufficient
> to address this problem on ALL Arm implementations, both current and
> future".

Yep, see my followup on the x86-64 side too. Don't think it's worth
doing something just because it's expensive on arm64, in fact any kind
of higher frequency array_index_nospec() will be expensive on arm64 :/

-- 
Jens Axboe

