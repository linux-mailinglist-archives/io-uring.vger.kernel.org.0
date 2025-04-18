Return-Path: <io-uring+bounces-7548-lists+io-uring=lfdr.de@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [147.75.199.223])
	by mail.lfdr.de (Postfix) with ESMTPS id CC1F9A93AC6
	for <lists+io-uring@lfdr.de>; Fri, 18 Apr 2025 18:26:01 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id A0EF14A18F6
	for <lists+io-uring@lfdr.de>; Fri, 18 Apr 2025 16:25:44 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 41CEA22257B;
	Fri, 18 Apr 2025 16:21:08 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="aJ5Rbccs"
X-Original-To: io-uring@vger.kernel.org
Received: from mail-wr1-f47.google.com (mail-wr1-f47.google.com [209.85.221.47])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 71C06224B1E
	for <io-uring@vger.kernel.org>; Fri, 18 Apr 2025 16:21:06 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.221.47
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1744993268; cv=none; b=MRkh0WgIaXBqf6bdyhFNOH7zyg/bvAR6kNjzJIH7gWYQ8jkN6qVskRoNF3xSIA/ObsT2hwT3REdnWN5cZAjAWcKQcJtu1eEYCLUhGIyu/mR3L+hfzJtNnSlNrTLez6pi7ALY5lwSzHBaAC78H5eLhubtRlvAmglY682uwCaShU4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1744993268; c=relaxed/simple;
	bh=x06+wDvgTy36F/RDJVWpM5ofEzgQadtjgW+7Y/foK+w=;
	h=Message-ID:Date:MIME-Version:Subject:To:References:From:
	 In-Reply-To:Content-Type; b=eL1DtpAjweldfo381/Tn/bxzPVCB9M1o6c1ONmYcX4O2aCP5TwQmlp44aVO/aKqbNjerpJX0VkPXh9VARNfG5TTfBfZUTewejUcs8XOuS3JkGyjdv46fF3d+7H0PTIkr4rDoGCb9OTopQaz3PEMpCAW0QseBupnxuh7uffVxq5E=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=aJ5Rbccs; arc=none smtp.client-ip=209.85.221.47
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Received: by mail-wr1-f47.google.com with SMTP id ffacd0b85a97d-39ee57c0b8cso1933274f8f.0
        for <io-uring@vger.kernel.org>; Fri, 18 Apr 2025 09:21:06 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1744993265; x=1745598065; darn=vger.kernel.org;
        h=content-transfer-encoding:in-reply-to:from:content-language
         :references:to:subject:user-agent:mime-version:date:message-id:from
         :to:cc:subject:date:message-id:reply-to;
        bh=JhcDnWRmIKq5Rgp1wzIdmNmIBFBhhMbT95cioBuawy4=;
        b=aJ5RbccsXX/K11yG39AK8rPWiIGVS8/KpYffN53suRCkoDsywSLzSwWrNmZpmP2sGg
         8WBeMOs+hFikw7REds0gB2FraAxcra+UCKqkstM2/gBSJW1eYQfR3w37nYizWSYZBSr7
         PzYLmb2a3z0gwQrPqQ6siItObzyfo16LXzsFjaTCmyyhxVy06osGzG67rokKXn0qhJ+V
         tAAlwkq+nLRruBoTd9HyIEjFRNt1Wov3vlTEzysHIsk31hTkLE/sOF446tycKW6O1gEx
         vBrBYmC9fP0YlDJgtqa3yjIfb1YgXP6su+jw8MRbtNoAxOVWVBgfKK1Ag4Z6rOZs7gS7
         jwlA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1744993265; x=1745598065;
        h=content-transfer-encoding:in-reply-to:from:content-language
         :references:to:subject:user-agent:mime-version:date:message-id
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=JhcDnWRmIKq5Rgp1wzIdmNmIBFBhhMbT95cioBuawy4=;
        b=LZs/Io5K+dOcOX8Vzs8/eRw08tvMxP2Yvv5kBHu+tKZ7gkW/iDWqG+SEUlelb8/C+O
         VHXQJ6czYFJUZ7XGw4+vXOfvN8eLdVqn+pAsRlh1mMW9SENqO49jwShmfoYcE+uzMVbN
         6Xbjx+xIpMlafORIjLy9aPCOLMY1hlnTyrok2G5yqOlY9zfbSmBCCHYXCi6Nz4+enjjR
         XnWyxTtrWvwDa1ek7buq+D8C1rS73baJUcFzxsrU2gFYNxQzyntmQDeup7BT0RxuZpQs
         SSZD7zLno4AC95dBqKoDPt6rkMua83IWkxnL3xdbj2bYR1+Bd6DgPS2Fqwqrg/dysB3i
         Erxw==
X-Forwarded-Encrypted: i=1; AJvYcCWBzuaIDtTYFBfa3OA5T9pyJKZFO1pS1hbuR0L34QyrdM9Zy0si68VAbn+NDgJ372MoYQharjT1Jw==@vger.kernel.org
X-Gm-Message-State: AOJu0YxNsQFC+3gcqlSXN1nobUpEdyizDjmghYcnUlIIqIgx9xJrBqlZ
	wllixLbEkm7E0Ev2KdGHsXsshLQJe9qtKVsPvOLvXCoHLwLFxjnT7EWPog==
X-Gm-Gg: ASbGncvYehIGMJzdpcIraeV8xsfZFOwlDT2SfzpoSpZ0p2uDEkekyvnX8FoWKK1PaZj
	yLM6iZW8+g1esnjklXQPZsbqG9u37+Gk987mCrSJ6mHpluvMImPpscXb5a1fOp7u9/YA1ODMKxM
	zAXpSSx07wRp3Zh4Z2RyG3Us++UnBjWoH9NU9FuOior+w40s3oGgoC5wRut5xcaWCiJcD/b2fRT
	vqslhdedcf2AdmMWR1HGgwhm3SjOAKrpECCGv2oq77ZBMmRy9SgVzpocsv3PmLcu8snfIe9dE7i
	GkG4Gcy1xvzkmjOEGP7F1pQKLNQr5fxIOlPDwSdhft6v/Sw8e/PkfXmZ8ybG
X-Google-Smtp-Source: AGHT+IESmldJagQ8XlwAVRbWa0Hj0z2ivcaqcEvP25fMtV++hePe475gkQA43n51oSGXJlKkXOqT5w==
X-Received: by 2002:a05:6000:2501:b0:391:4bcb:828f with SMTP id ffacd0b85a97d-39efba3cd22mr2442725f8f.14.1744993264607;
        Fri, 18 Apr 2025 09:21:04 -0700 (PDT)
Received: from [192.168.8.100] ([148.252.144.40])
        by smtp.gmail.com with ESMTPSA id ffacd0b85a97d-39efa43bf20sm3137374f8f.48.2025.04.18.09.21.03
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Fri, 18 Apr 2025 09:21:03 -0700 (PDT)
Message-ID: <a3a444fd-b219-4b70-9936-8ad347842d57@gmail.com>
Date: Fri, 18 Apr 2025 17:22:19 +0100
Precedence: bulk
X-Mailing-List: io-uring@vger.kernel.org
List-Id: <io-uring.vger.kernel.org>
List-Subscribe: <mailto:io-uring+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:io-uring+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH 4/5] io_uring/zcrx: move zcrx region to struct io_zcrx_ifq
To: David Wei <dw@davidwei.uk>, io-uring@vger.kernel.org
References: <cover.1744815316.git.asml.silence@gmail.com>
 <6d2bb3ce1d1fb0653a5330a67f6b9b60d069b284.1744815316.git.asml.silence@gmail.com>
 <b787d94c-8398-43d5-9721-5c4fb76890ca@davidwei.uk>
Content-Language: en-US
From: Pavel Begunkov <asml.silence@gmail.com>
In-Reply-To: <b787d94c-8398-43d5-9721-5c4fb76890ca@davidwei.uk>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit

On 4/18/25 17:05, David Wei wrote:
> On 2025-04-16 08:21, Pavel Begunkov wrote:
>> Refill queue region is a part of zcrx and should stay in struct
>> io_zcrx_ifq. We can't have multiple queues without it.
>>
>> Note: ctx->ifq assignments are now protected by mmap_lock as it's in
>> the mmap region look up path.
>>
>> Signed-off-by: Pavel Begunkov <asml.silence@gmail.com>
>> ---
>>   include/linux/io_uring_types.h |  2 --
>>   io_uring/zcrx.c                | 20 ++++++++++++--------
>>   io_uring/zcrx.h                |  1 +
>>   3 files changed, 13 insertions(+), 10 deletions(-)
>>
>> diff --git a/include/linux/io_uring_types.h b/include/linux/io_uring_types.h
>> index 3b467879bca8..06d722289fc5 100644
>> --- a/include/linux/io_uring_types.h
>> +++ b/include/linux/io_uring_types.h
>> @@ -448,8 +448,6 @@ struct io_ring_ctx {
>>   	struct io_mapped_region		ring_region;
>>   	/* used for optimised request parameter and wait argument passing  */
>>   	struct io_mapped_region		param_region;
>> -	/* just one zcrx per ring for now, will move to io_zcrx_ifq eventually */
>> -	struct io_mapped_region		zcrx_region;
>>   };
>>   
>>   /*
>> diff --git a/io_uring/zcrx.c b/io_uring/zcrx.c
>> index 652daff0eb8d..d56665fd103d 100644
>> --- a/io_uring/zcrx.c
>> +++ b/io_uring/zcrx.c
>> @@ -160,12 +160,11 @@ static int io_allocate_rbuf_ring(struct io_zcrx_ifq *ifq,
>>   	if (size > rd->size)
>>   		return -EINVAL;
>>   
>> -	ret = io_create_region_mmap_safe(ifq->ctx, &ifq->ctx->zcrx_region, rd,
>> -					 IORING_MAP_OFF_ZCRX_REGION);
>> +	ret = io_create_region(ifq->ctx, &ifq->region, rd, IORING_MAP_OFF_ZCRX_REGION);
> 
> Why is this changed to io_create_region()? I don't see the caller of
> io_allocate_rbuf_ring() changing or taking mmap_lock.

We only care about mmap seeing a consistent region. The mmap holds
the ctx->mmap_lock, and *mmap_safe was making sure the region is
updated atomically from its perspective.

Now, instead of protecting the region itself, this patch is protecting
how ifq and subsequently the region is published:

-	ctx->ifq = ifq;
+	scoped_guard(mutex, &ctx->mmap_lock)
+		ctx->ifq = ifq;

And io_zcrx_get_region() is either sees NULL or ifq with a
correct region.

-- 
Pavel Begunkov


