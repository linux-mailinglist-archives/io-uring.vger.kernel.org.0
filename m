Return-Path: <io-uring+bounces-8668-lists+io-uring=lfdr.de@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [147.75.80.249])
	by mail.lfdr.de (Postfix) with ESMTPS id 7FC3CB04498
	for <lists+io-uring@lfdr.de>; Mon, 14 Jul 2025 17:48:52 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id A75E61891C3C
	for <lists+io-uring@lfdr.de>; Mon, 14 Jul 2025 15:45:01 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 9A97F25C80E;
	Mon, 14 Jul 2025 15:44:06 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="AHgTu1tB"
X-Original-To: io-uring@vger.kernel.org
Received: from mail-ed1-f51.google.com (mail-ed1-f51.google.com [209.85.208.51])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D77E51DC07D
	for <io-uring@vger.kernel.org>; Mon, 14 Jul 2025 15:44:04 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.208.51
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1752507846; cv=none; b=X8NWxdIW+FwtVcvtCaJ00i42qRwSZHd9gb6YrK0pluwt1d+CDKt1TkFpU8+pdOWvRHwcGrfHfxJRDuaaGKlpsex6QiXDyIFHRvlAP8CRNMj58L0vr/YjbEdt9GjL3s9+39R9CDGWp6zsw4KxfS6QGIrU64JfoWnBmAAPKHJyP3M=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1752507846; c=relaxed/simple;
	bh=a8KMdi04VkGks0svtTF1HjREPjJF3/awTlNqP6UgtUI=;
	h=Message-ID:Date:MIME-Version:Subject:To:References:From:
	 In-Reply-To:Content-Type; b=EzQYIO+bi7RmvU16KnXyCU6iGRDSWAgcSXDvuK+Dhp8yFtJnke9yqd6Y4f7P6mzWZcCH4yzeWFOe9F67pquI8W4f777/G8sREQQMTKN1g9ZNcD4ghRPlV4Sq8/Z4NoA8WstuP7ElbFn78xj/GKFs4tHCcH1eXuUB8NRnfYSWabE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=AHgTu1tB; arc=none smtp.client-ip=209.85.208.51
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Received: by mail-ed1-f51.google.com with SMTP id 4fb4d7f45d1cf-606b58241c9so7462419a12.3
        for <io-uring@vger.kernel.org>; Mon, 14 Jul 2025 08:44:04 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1752507843; x=1753112643; darn=vger.kernel.org;
        h=content-transfer-encoding:in-reply-to:from:content-language
         :references:to:subject:user-agent:mime-version:date:message-id:from
         :to:cc:subject:date:message-id:reply-to;
        bh=wd6klBy3FXF8OKVI9d6BlGQDJT7OU0xXo5tlenW8Jg4=;
        b=AHgTu1tBP3hyE1l0vp1RhwUwUmKGbIJ3qwswvKNex0QaaBvPziEl8Kv8+Lk7n0Nop1
         yWp4VPxhG5NvPZE+jjJa27pmPstQ+NDsbY+knIRImSW1bNtSdEfVleXDX0+cW0Xwy3cs
         jMFe7SD/Avltr7LqRRGY7Px58IW3shEBZEam2Ut53ChK6dT9LCgp7fnfY8l4Wv8msgGZ
         1a2p28Ex56FoKkzfKrzxBX57mGvFRxojvwF3vnAcB/uTvp45XxS3HMxgMVOS7IU9mSt5
         vYMm7y01FM80Wycrl23n5dDuGpk78nD+ohH8sm+AB81QLAqjtYJHX4U7CgO0zfR5HSzG
         tRjA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1752507843; x=1753112643;
        h=content-transfer-encoding:in-reply-to:from:content-language
         :references:to:subject:user-agent:mime-version:date:message-id
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=wd6klBy3FXF8OKVI9d6BlGQDJT7OU0xXo5tlenW8Jg4=;
        b=s70zKzgmB6IyqGneoCw+ep4YG91NlAF4T5e4SGsLxgcbaqLk/m76NSg3PkeTA8lGYh
         EID7SlkGdKgbDAAEDSWd8ZN92brK9+ga950GDwlFGs39KZYKlJnhYhKy3CPBtnzBbLKP
         tQXsR2iSYbqq8NQauAJbHyeX/zAZZ2wU7WbtyyEjdB7hTStgU7I+WOp54k9m6rD8sb4A
         YEFoiwaWxzavg/t+1A3d89qaL6FJy160akKErht3iQvgRXWdx3jT44mW2hjJWWs5KkVA
         VRLIMLVQCHOIRK9BmXvm+/xozvgY8omhPQ+aIXsPuUpyZUC5pIHb1EMgBGHyNgJziExU
         35JQ==
X-Forwarded-Encrypted: i=1; AJvYcCVm+nIw5UjqrwwPWs/bEiklu7o67/ijueVZ8qDxQCrVNf+xF8Wcz6FfvPtqJQfB//qCie3MZgDkGw==@vger.kernel.org
X-Gm-Message-State: AOJu0YxYE7rv2dLhQ3Qn+ru80oUjqm8bvg8NYMk1IXpjlbjnQ4u18wbt
	JvpVlQh7d4mcE6SShuAt5HuoK80xKsWL5487pwBY3LXb5lqr2Xyi14HM
X-Gm-Gg: ASbGncvmj2Y/FoEvh5XKfF7u/LwQ4CO4LhHrojsxBmTJN+a9F7mn6C5DVAGysc/33Wh
	Fwqt2uTmBQTpOK9NWyqe63k8m/2Wb2slbYukAgsmTlH0psq76Oilo1lUvnzwgiaAHMbrFRR10iJ
	BVYikdnbVf2/SCMk4cngjpuY5D9DndrgoDDEC1M+F2GqmckiHwIGooNZd/gnmHmXQAcjOrUzeFf
	H3WuMQvifRok+uOkH3u5+UJqCuL/rLCWM7YERbmpSzxpAkzeRGL/4zMbUXV6kgI7S9HKYkLpNGX
	sKviqOEWh569z3Yv6RKg1MVhIUHEeRV++ryEnCV7o+syOgyvAF6ZBiXF01uwqu4TYWTgInXRgyt
	dyn0Lt1Bt16C+9cpV8Ugsrp2CIyYCPYxZGdHvvlCe
X-Google-Smtp-Source: AGHT+IEYFs2zQYs6jVPL+lMCnZd+LUJe+IG1KdDOgol6yws258SyLjUEcfCtQEDeP2kabQ+fhB16Qg==
X-Received: by 2002:a17:907:d716:b0:ae6:b006:1be with SMTP id a640c23a62f3a-ae6fbf410cbmr1317295566b.5.1752507842853;
        Mon, 14 Jul 2025 08:44:02 -0700 (PDT)
Received: from [192.168.8.100] ([85.255.234.80])
        by smtp.gmail.com with ESMTPSA id a640c23a62f3a-ae6e8294042sm840948666b.119.2025.07.14.08.44.01
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Mon, 14 Jul 2025 08:44:02 -0700 (PDT)
Message-ID: <4abbf820-11c9-4e01-9f95-5ccc45f0f20c@gmail.com>
Date: Mon, 14 Jul 2025 16:45:33 +0100
Precedence: bulk
X-Mailing-List: io-uring@vger.kernel.org
List-Id: <io-uring.vger.kernel.org>
List-Subscribe: <mailto:io-uring+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:io-uring+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH 2/3] io_uring/poll: flag request as having gone through
 poll wake machinery
To: Jens Axboe <axboe@kernel.dk>, io-uring@vger.kernel.org
References: <[PATCHSET 0/3] Add support for IORING_CQE_F_POLLED>
 <20250712000344.1579663-1-axboe@kernel.dk>
 <20250712000344.1579663-3-axboe@kernel.dk>
 <801afb46-4070-4df4-a3f6-cb55ceb22a00@gmail.com>
 <9d9b87d4-78df-4c31-8504-8dbc633ccb22@kernel.dk>
 <e89d9a26-0d54-4c22-85d2-6f6c7bad9a73@gmail.com>
 <e24aaa01-e703-4a6b-9d1c-bf5deacbda86@kernel.dk>
Content-Language: en-US
From: Pavel Begunkov <asml.silence@gmail.com>
In-Reply-To: <e24aaa01-e703-4a6b-9d1c-bf5deacbda86@kernel.dk>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit

On 7/14/25 15:54, Jens Axboe wrote:
> On 7/14/25 3:26 AM, Pavel Begunkov wrote:
>> On 7/12/25 21:59, Jens Axboe wrote:
>>> On 7/12/25 5:39 AM, Pavel Begunkov wrote:
>>>> On 7/12/25 00:59, Jens Axboe wrote:
>>>>> No functional changes in this patch, just in preparation for being able
...>>>> Same, it's overhead for all polled requests for a not clear gain.
>>>> Just move it to the arming function. It's also not correct to
>>>> keep it here, if that's what you care about.
>>>
>>> Not too worried about overhead, for an unlocked or. The whole poll
>>
>> You know, I wrote this machinery and optimised it, I'm not saying it
>> to just piss you off, I still need it to work well for zcrx :)
> 
> This was not a critique of the code, it's just a generic statement on
> the serialization around poll triggering is obviously a lot more
> expensive than basic flag checking or setting. Every comment is not a
> backhanded attack on someones code.

Not taken this way, it works well enough for such highly concurrent
synchronisation.

>> Not going into details, but it's not such a simple unlocked or. And
>> death by a thousand is never old either.
> 
> That's obviously true, I was just trying to set expectations that a
> single flag mask is not really a big deal. If the idea and feature was
> fully solidified and useful, then arguing that adding a bit or is a
> problem is nonsense.

Quite the opppsite, it should be argued about, and not because "or"
is expensive, but because it's a write in a nuanced place.

  By that standard, we could never add anything to
> the code, only remove. At the same time, adding frivolous code is of
> course always a bad idea.

-- 
Pavel Begunkov


