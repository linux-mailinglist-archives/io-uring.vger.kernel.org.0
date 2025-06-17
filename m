Return-Path: <io-uring+bounces-8390-lists+io-uring=lfdr.de@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [139.178.88.99])
	by mail.lfdr.de (Postfix) with ESMTPS id 4EA8FADD008
	for <lists+io-uring@lfdr.de>; Tue, 17 Jun 2025 16:37:01 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 34633404D98
	for <lists+io-uring@lfdr.de>; Tue, 17 Jun 2025 14:30:00 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id DD0922E2EF4;
	Tue, 17 Jun 2025 14:30:04 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel-dk.20230601.gappssmtp.com header.i=@kernel-dk.20230601.gappssmtp.com header.b="K53yQI+4"
X-Original-To: io-uring@vger.kernel.org
Received: from mail-il1-f181.google.com (mail-il1-f181.google.com [209.85.166.181])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id EEABB2DE202
	for <io-uring@vger.kernel.org>; Tue, 17 Jun 2025 14:30:01 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.166.181
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1750170604; cv=none; b=mHeh4S/kBhFCrRfH9fHsCD0lRYVRqlHBFnHMqbuIJ41rerKJnECv8rXPGSJGDiX0F7MHaQzED1RJUD16lzbU65qVcL418vyE3x9OPwZegX3sVFQ/T/6EVMlwqlSjlN0z6fJK/XKkp8e9ge2osqL/PIvCqqx9Ftgfoh5T/uYacHw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1750170604; c=relaxed/simple;
	bh=1ht4S85AVwey5d7l0NR7hBt1ryp6HndTt4PB7ev0J5o=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=uVGCWjB6Ae4eeoQ/yfp39Vae1POblBnz1uRQHmSVVr303ccQRcaLkNV5YXTS+VDLohCUwOMBQIeUFwLt29JYysW2Iud6CaqRtZJhGKUjiKdt3IMFjmVGiklQ25QeZ3od6lzM1MAZddSKCZJ0zmzORwtiw7kShMsCpRuLo7KUKEA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=kernel.dk; spf=pass smtp.mailfrom=kernel.dk; dkim=pass (2048-bit key) header.d=kernel-dk.20230601.gappssmtp.com header.i=@kernel-dk.20230601.gappssmtp.com header.b=K53yQI+4; arc=none smtp.client-ip=209.85.166.181
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=kernel.dk
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=kernel.dk
Received: by mail-il1-f181.google.com with SMTP id e9e14a558f8ab-3dc8265b9b5so51677655ab.1
        for <io-uring@vger.kernel.org>; Tue, 17 Jun 2025 07:30:01 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernel-dk.20230601.gappssmtp.com; s=20230601; t=1750170601; x=1750775401; darn=vger.kernel.org;
        h=content-transfer-encoding:in-reply-to:from:content-language
         :references:cc:to:subject:user-agent:mime-version:date:message-id
         :from:to:cc:subject:date:message-id:reply-to;
        bh=qm8ZESSFLfTrfNAmN4pCFwQBlQ23CDIRq2yjCkvIDts=;
        b=K53yQI+4B2PZ4L25WyHx/wS1azXhVGVgbHo8KmWa6tdBZupmdpG/69dJ+PNKIC0enR
         LVTzZhjA93pKri32gi80H1mo7BKFHfAFVV7qfUru+sELFhFfgS5K5dCugJEpOFBBxONd
         b/k1/GXKIz/PEgXkE/QnhlWQZ47+cRlLGtpZFl/UdF1gOHXeyzWMbyhw0xEjFqlVQ0SR
         p0B0Z0Lig1ifg5hX7RSpMP02emad9dv4ffxkDdK39pr6lJI1tLADxnG9TQ1/MdruJUXu
         HnFvO9xU8hsaElN+2JJSgVFWNwbcB/M9LUQugCyU36rZLR1t7KTaJgK9YnPvGxNn0g14
         Zl0Q==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1750170601; x=1750775401;
        h=content-transfer-encoding:in-reply-to:from:content-language
         :references:cc:to:subject:user-agent:mime-version:date:message-id
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=qm8ZESSFLfTrfNAmN4pCFwQBlQ23CDIRq2yjCkvIDts=;
        b=ep7eEOseiSFC9gaunzjD4Av8hkDt6haV2OB5NpePt+QTHUYIe/1ayLb69+uvNPKi4/
         b/QlXRvhkxCT5FvXQBZWl+cQPNsDL1xx9xfELpNWveM7LOQIhTq8KSGnLmlzx23VN6sK
         Ow1KIL6ohsgRUFfi0T/0GMKK16J49Z2UVPPLg9urg+h7Xh5ISkuTqwO34gKNo9lfLrWM
         d7PONZVd+cU/w/8Rbsgp45AkijhygIZSrg9Zc0Om312ebbwWBgWTJQojSv2HbGVtw4AL
         WHBNbHgYyf6tqk40nqxwb1ACHsJXive+sKNlO4JUZUOldJDSdVenEJ2/O9TXmr2oCuuG
         8A/g==
X-Gm-Message-State: AOJu0YyB7zqs9UTexkKsagrM1tFv/pOuaizhCOPawo3W+eacIXjziZB+
	Ae8zVtvDrfc2+BkE6CgQBqI8JO0+PqlvLuJw2bo5sJCNC+tVsyZbEKCcAeo1K0dlZZI=
X-Gm-Gg: ASbGncsAZBzPDM9qcxCV+Xz2WevwefICjZJF5x1PHtTLxP2Iwgn9mR7IikYiYv47+jT
	C+Hn2eSV3PoiP6JPnC4uAaBntWmDivKtYaQQnwUvePdcnRmZt6YeP7WAkAQCVqiOvcZawt6RPsU
	z2saH0ougxOE+fBMWD/cbH2n6kg9DfoV4w5Lyz5HPpnIN7GhfPgXIa9XZqdqiXVPkqOPO4uqW/9
	m+BsWs7Kcqhjt0+Uql/bbGcmOlseBVEne2A0Ej1aGVqw5GjFZrEtt/s4TXNkcjUOOPdCp+e7YmJ
	uUV9Uz60NxBouqCxzlOSvPvZbV0w/W6MK3CMBAl5rohXcoY97+3e3Q4Rwg==
X-Google-Smtp-Source: AGHT+IGrGXdxWmYblv4T9EhQC7vXeISVu8lyWpXAb/V85ozNTAbFF4tPag0Cl0RdG9Ltkd6m5yvdBA==
X-Received: by 2002:a05:6e02:1a2b:b0:3dd:d189:6511 with SMTP id e9e14a558f8ab-3de07cd433emr186895695ab.21.1750170600918;
        Tue, 17 Jun 2025 07:30:00 -0700 (PDT)
Received: from [192.168.1.116] ([96.43.243.2])
        by smtp.gmail.com with ESMTPSA id e9e14a558f8ab-3de019b4379sm24654355ab.15.2025.06.17.07.30.00
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Tue, 17 Jun 2025 07:30:00 -0700 (PDT)
Message-ID: <06a466e2-0904-447e-a0d7-73ddc2da937f@kernel.dk>
Date: Tue, 17 Jun 2025 08:29:59 -0600
Precedence: bulk
X-Mailing-List: io-uring@vger.kernel.org
List-Id: <io-uring.vger.kernel.org>
List-Subscribe: <mailto:io-uring+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:io-uring+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH] io_uring: fix page leak in io_sqe_buffer_register()
To: Penglei Jiang <superman.xpt@gmail.com>
Cc: io-uring@vger.kernel.org, linux-kernel@vger.kernel.org
References: <618aaa53-14a7-4d85-90d4-6e4a8e1ce3a1@kernel.dk>
 <20250617140234.40664-1-superman.xpt@gmail.com>
Content-Language: en-US
From: Jens Axboe <axboe@kernel.dk>
In-Reply-To: <20250617140234.40664-1-superman.xpt@gmail.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit

On 6/17/25 8:02 AM, Penglei Jiang wrote:
> On Tue, 17 Jun 2025 06:53:04 -0600, Jens Axboe wrote:
>> On 6/17/25 6:39 AM, Penglei Jiang wrote:
>>> Add missing unpin_user_pages() in the error path
>>>
>>> Fixes: d8c2237d0aa9 ("io_uring: add io_pin_pages() helper")
>>> Signed-off-by: Penglei Jiang <superman.xpt@gmail.com>
>>> ---
>>>  io_uring/rsrc.c | 4 +++-
>>>  1 file changed, 3 insertions(+), 1 deletion(-)
>>>
>>> diff --git a/io_uring/rsrc.c b/io_uring/rsrc.c
>>> index c592ceace97d..f5ac1b530e21 100644
>>> --- a/io_uring/rsrc.c
>>> +++ b/io_uring/rsrc.c
>>> @@ -804,8 +804,10 @@ static struct io_rsrc_node *io_sqe_buffer_register(struct io_ring_ctx *ctx,
>>>  	}
>>>  
>>>  	imu = io_alloc_imu(ctx, nr_pages);
>>> -	if (!imu)
>>> +	if (!imu) {
>>> +		unpin_user_pages(pages, nr_pages);
>>>  		goto done;
>>> +	}
>>>  
>>>  	imu->nr_bvecs = nr_pages;
>>>  	ret = io_buffer_account_pin(ctx, pages, nr_pages, imu, last_hpage);
>>
>> Wouldn't it be better to have the unpin be part of the normal error
>> handling? Not sure why the pin accounting failure doesn't do that
>> already.
>>
>> Totally untested...
>>
>> diff --git a/io_uring/rsrc.c b/io_uring/rsrc.c
>> index 94a9db030e0e..a68f0cd677a3 100644
>> --- a/io_uring/rsrc.c
>> +++ b/io_uring/rsrc.c
>> @@ -809,10 +809,8 @@ static struct io_rsrc_node *io_sqe_buffer_register(struct io_ring_ctx *ctx,
>>  
>>  	imu->nr_bvecs = nr_pages;
>>  	ret = io_buffer_account_pin(ctx, pages, nr_pages, imu, last_hpage);
>> -	if (ret) {
>> -		unpin_user_pages(pages, nr_pages);
>> +	if (ret)
>>  		goto done;
>> -	}
>>  
>>  	size = iov->iov_len;
>>  	/* store original address for later verification */
>> @@ -840,6 +838,7 @@ static struct io_rsrc_node *io_sqe_buffer_register(struct io_ring_ctx *ctx,
>>  	}
>>  done:
>>  	if (ret) {
>> +		unpin_user_pages(pages, nr_pages);
>>  		if (imu)
>>  			io_free_imu(ctx, imu);
>>  		io_cache_free(&ctx->node_cache, node);
> 
> Thank you for taking the time to address this issue!
> 
> However, if io_pin_pages() fails, it will also jump to the done label,
> but at that point, the value of nr_pages is undefined because nr_pages
> is only assigned a value inside io_pin_pages() if it succeeds.
> 
> 	pages = io_pin_pages((unsigned long) iov->iov_base, iov->iov_len,
> 				&nr_pages);
> 	if (IS_ERR(pages)) {
> 		ret = PTR_ERR(pages);
> 		pages = NULL;
> 		goto done;
> 	}
> 
> 	...
> 
> 	done:
> 		if (ret) {
> 			unpin_user_pages(NULL, undefined-value);
> 			...
> 
> I'm not sure what the impact of calling unpin_user_pages() in this way would be.

We should just check for 'pages' being valid first. Updated below. If
you want to test and send a v2 based on that, I do think that's the
better approach as it keeps all the error handling consistent.


diff --git a/io_uring/rsrc.c b/io_uring/rsrc.c
index 94a9db030e0e..454cd8855c6c 100644
--- a/io_uring/rsrc.c
+++ b/io_uring/rsrc.c
@@ -809,10 +809,8 @@ static struct io_rsrc_node *io_sqe_buffer_register(struct io_ring_ctx *ctx,
 
 	imu->nr_bvecs = nr_pages;
 	ret = io_buffer_account_pin(ctx, pages, nr_pages, imu, last_hpage);
-	if (ret) {
-		unpin_user_pages(pages, nr_pages);
+	if (ret)
 		goto done;
-	}
 
 	size = iov->iov_len;
 	/* store original address for later verification */
@@ -840,6 +838,8 @@ static struct io_rsrc_node *io_sqe_buffer_register(struct io_ring_ctx *ctx,
 	}
 done:
 	if (ret) {
+		if (pages)
+			unpin_user_pages(pages, nr_pages);
 		if (imu)
 			io_free_imu(ctx, imu);
 		io_cache_free(&ctx->node_cache, node);

-- 
Jens Axboe

