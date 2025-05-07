Return-Path: <io-uring+bounces-7885-lists+io-uring=lfdr.de@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [147.75.199.223])
	by mail.lfdr.de (Postfix) with ESMTPS id 70E14AAE3F5
	for <lists+io-uring@lfdr.de>; Wed,  7 May 2025 17:10:51 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id 6B191507246
	for <lists+io-uring@lfdr.de>; Wed,  7 May 2025 15:10:51 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 8BC24289E1A;
	Wed,  7 May 2025 15:10:46 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="IIswhalt"
X-Original-To: io-uring@vger.kernel.org
Received: from mail-wm1-f49.google.com (mail-wm1-f49.google.com [209.85.128.49])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A4E4714A639
	for <io-uring@vger.kernel.org>; Wed,  7 May 2025 15:10:44 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.128.49
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1746630646; cv=none; b=d4SfFzshymYlyBGp+rLW0KghUzrdDQZZk2dC881X4sfwUarN+oAOUkfxU1y1u2Rms31wgIr4jCpH9FTyjXGaOoFBR5UtfqTmq71p6M0G+4VCySweIj+Q288VTcUZvBSVxTi6yF4AeUm2jsSZXCkURSmpTu7rPhX5uzmFnHxiMHg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1746630646; c=relaxed/simple;
	bh=meFYNeH8ZeHCwdf6ZtH2en4ZiAvhoOszOxC29TCiXj8=;
	h=Message-ID:Date:MIME-Version:Subject:To:References:From:
	 In-Reply-To:Content-Type; b=DyT7Vtm/p3fAJ8MoTh34e3bDNt3YU6/HOQvS5pxPP9ALCzqcFA7l2n8OxZpk10PSX+c4cjBNx66gxvSWWxzURo+ssKLOomEQ7VhabAZUNTwx7l/eNv7PhenG5CWUAaNhMc8/VCg9DIKLGF9bhMnEIGt6WOYQgZThHJZzmKbnJ8g=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=IIswhalt; arc=none smtp.client-ip=209.85.128.49
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Received: by mail-wm1-f49.google.com with SMTP id 5b1f17b1804b1-43d0618746bso51388385e9.2
        for <io-uring@vger.kernel.org>; Wed, 07 May 2025 08:10:44 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1746630643; x=1747235443; darn=vger.kernel.org;
        h=content-transfer-encoding:in-reply-to:from:content-language
         :references:to:subject:user-agent:mime-version:date:message-id:from
         :to:cc:subject:date:message-id:reply-to;
        bh=bsqarLZE6Von6pMkds2jVNq+1LMMljYgriYgKGs0UCA=;
        b=IIswhalt/8R8SMM3ODX1hBqBMfEa1DwUIGC9IgWSMVULXLKu/5hxl71C0qCXXlbQYH
         Fg4C24kSZrprAThoBvy0clw+3GWU8wnrp58FoAqZwsEVfFkt7QU1ORv0np9n1Az9aVub
         a2+7JchPhTIffTp4Eb6LIVHWGVqsLAmZuBSWhc6FbfZSwiVrFkTCRYfHFA5s5I7wmqKa
         Q07uRsU2+9qNyi4m6WZ4f9aZq6tcEyCfJL2ON0YBxjkNjjgf/GQCRw2up/TwLOWS2M3p
         XfubWdc1vbjoVxznUOLOLFeszi0ewfnwFhd7rT4K7A6c6/TGRXHhUukyXBNJP/S68w8g
         whnQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1746630643; x=1747235443;
        h=content-transfer-encoding:in-reply-to:from:content-language
         :references:to:subject:user-agent:mime-version:date:message-id
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=bsqarLZE6Von6pMkds2jVNq+1LMMljYgriYgKGs0UCA=;
        b=Sqkt46OBf+xhODhhltgDGjqkaKt/AIjYxouqlAh03JatSz/KWi18D0kynv3iImtx8W
         S0lrOq1khymPHqEkA6+WTIrw/MZ8z7Yhr3ikXTYLcDiBUzhonJX0+F8D4LSj1+/4iKN7
         EZARMYFqFoKqSAFKbUb7z5Fa6PIkdxU4tG8fRxtCMdY2EaSSV4dV1cG7H/dPNCx8/o90
         Sth6JQeos5s7jqekd1DuL19EVl/v1aEZuaV5jNYm6MRfdcGf8hAAdNe7SILkf10H5dld
         Ze4SuWrk70GKLpSfYebk+8fjklzBgOxuD58AqjVRZeyVODGn2PPuxz1scFuoA0luqJiw
         lJGg==
X-Forwarded-Encrypted: i=1; AJvYcCVFQtu6vv3pQt2KGN11wMvBAOaHbEHdcE9ezKWTta93Mi0cBQZfwto/gk75b5mE0uJn+rKf+Xe/nw==@vger.kernel.org
X-Gm-Message-State: AOJu0YyO15dUmqmW2lyY5390fn7MolIIgdNgJRMB1cMcyeyQwMYsc5xW
	ayoDCdM43NVUGNbESCheAP3TSHrrgK5szOHs8mWe0ROQqcEsGhlVuKkS1w==
X-Gm-Gg: ASbGncvJ7fXYuqGQVJOa5HMa004OfpwnjWJ3NEm2DNKS/eB/tWZHfZb/tEOCIOrk8r1
	Y2WjUz+RFz48ZbCaDjrNMsZ1Chm8C2Q3wvMZx9ySgRahcXySOsxuvZHRG71pQFetfGwG5UHI36b
	SI9W84HOqzxEH9BmxbIVTulSsOn4swn++mHC6GTwgz1UVu6tJhKn5xzv4vg2n/8oM+9r5UQbRKB
	Pu2HcvVnWoKdV/IhQKGj6yl8cycV59h5DFdNgd0n16P7Uo9N45lGcixgI/El+4E9LnZ6gFUPObV
	99yYiKN7EfMNiKlU4AT04vAsgC9lOIesKWYGy1hbLuDZ2QbVWg==
X-Google-Smtp-Source: AGHT+IHZBCRTg/PohQaHK3JcvqSm0cIooYECSEhziNJp2Aj0gqRZpbgkTe7k94uxl+0Er3HFJXmP8A==
X-Received: by 2002:a05:600c:5122:b0:43d:9d5:474d with SMTP id 5b1f17b1804b1-441d448c928mr35781425e9.0.1746630642605;
        Wed, 07 May 2025 08:10:42 -0700 (PDT)
Received: from [192.168.8.100] ([185.69.145.185])
        by smtp.gmail.com with ESMTPSA id 5b1f17b1804b1-441d11a44d3sm44235175e9.0.2025.05.07.08.10.41
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Wed, 07 May 2025 08:10:41 -0700 (PDT)
Message-ID: <f6ac1b25-3185-4d3a-8e8e-d6d2771f2b3c@gmail.com>
Date: Wed, 7 May 2025 16:11:57 +0100
Precedence: bulk
X-Mailing-List: io-uring@vger.kernel.org
List-Id: <io-uring.vger.kernel.org>
List-Subscribe: <mailto:io-uring+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:io-uring+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH] io_uring: ensure deferred completions are flushed for
 multishot
To: Jens Axboe <axboe@kernel.dk>, io-uring <io-uring@vger.kernel.org>
References: <a1dffa40-0c30-40d0-87b4-0a03698fd85f@kernel.dk>
 <c6260e33-ad29-4cd1-85c1-d0658c347a31@gmail.com>
 <a4ef2e70-e858-4a3a-9f7a-22bd3af2fefe@kernel.dk>
Content-Language: en-US
From: Pavel Begunkov <asml.silence@gmail.com>
In-Reply-To: <a4ef2e70-e858-4a3a-9f7a-22bd3af2fefe@kernel.dk>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit

On 5/7/25 15:58, Jens Axboe wrote:
> On 5/7/25 8:36 AM, Pavel Begunkov wrote:
>> On 5/7/25 14:56, Jens Axboe wrote:
>>> Multishot normally uses io_req_post_cqe() to post completions, but when
>>> stopping it, it may finish up with a deferred completion. This is fine,
>>> except if another multishot event triggers before the deferred completions
>>> get flushed. If this occurs, then CQEs may get reordered in the CQ ring,
>>> as new multishot completions get posted before the deferred ones are
>>> flushed. This can cause confusion on the application side, if strict
>>> ordering is required for the use case.
>>>
>>> When multishot posting via io_req_post_cqe(), flush any pending deferred
>>> completions first, if any.
>>>
>>> Cc: stable@vger.kernel.org # 6.1+
>>> Reported-by: Norman Maurer <norman_maurer@apple.com>
>>> Reported-by: Christian Mazakas <christian.mazakas@gmail.com>
>>> Signed-off-by: Jens Axboe <axboe@kernel.dk>
>>>
>>> ---
>>>
>>> diff --git a/io_uring/io_uring.c b/io_uring/io_uring.c
>>> index 769814d71153..541e65a1eebf 100644
>>> --- a/io_uring/io_uring.c
>>> +++ b/io_uring/io_uring.c
>>> @@ -848,6 +848,14 @@ bool io_req_post_cqe(struct io_kiocb *req, s32 res, u32 cflags)
>>>        struct io_ring_ctx *ctx = req->ctx;
>>>        bool posted;
>>>    +    /*
>>> +     * If multishot has already posted deferred completions, ensure that
>>> +     * those are flushed first before posting this one. If not, CQEs
>>> +     * could get reordered.
>>> +     */
>>> +    if (!wq_list_empty(&ctx->submit_state.compl_reqs))
>>> +        __io_submit_flush_completions(ctx);
>>
>> A request is already dead if it's in compl_reqs, there should be no
>> way io_req_post_cqe() is called with it. Is it reordering of CQEs
>> belonging to the same request? And what do you mean by "deferred"
>> completions?
> 
> It's not the same req, it's different requests using the same
> provided buffer ring where it can be problematic.

Ok, and there has never been any ordering guarantees between them.
Is there any report describing the problem? Why it's ok if
io_req_post_cqe() produced CQEs of two multishot requests get
reordered, but it's not when one of them is finishing a request?
What's the problem with provided buffers?

It's a pretty bad spot to do such kinds of things, it disables any
mixed mshot with non-mshot batching, and nesting flushing under
an opcode handler is pretty nasty, it should rather stay top
level as it is. From what I hear it's a provided buffer specific
problem and should be fixed there.

-- 
Pavel Begunkov


