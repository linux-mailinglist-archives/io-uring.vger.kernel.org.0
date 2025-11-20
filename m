Return-Path: <io-uring+bounces-10701-lists+io-uring=lfdr.de@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from dfw.mirrors.kernel.org (dfw.mirrors.kernel.org [IPv6:2605:f480:58:1:0:1994:3:14])
	by mail.lfdr.de (Postfix) with ESMTPS id EDEC3C75369
	for <lists+io-uring@lfdr.de>; Thu, 20 Nov 2025 17:03:57 +0100 (CET)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by dfw.mirrors.kernel.org (Postfix) with ESMTPS id D66244E1A97
	for <lists+io-uring@lfdr.de>; Thu, 20 Nov 2025 15:54:04 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 0E67A2F5478;
	Thu, 20 Nov 2025 15:54:01 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel-dk.20230601.gappssmtp.com header.i=@kernel-dk.20230601.gappssmtp.com header.b="YO90Hfoy"
X-Original-To: io-uring@vger.kernel.org
Received: from mail-io1-f47.google.com (mail-io1-f47.google.com [209.85.166.47])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id BFE6032C327
	for <io-uring@vger.kernel.org>; Thu, 20 Nov 2025 15:53:58 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.166.47
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1763654040; cv=none; b=P8XAB/ZMaDGwvZhVRbUxyF9fQg1Pj+PS4hxVRMrRrzWgMj/cuzIlklNTayjTSpPde6qYFgi4+K4iGrgzxDJpqzwEGc33SazJvCPYWYGz/ZBnBf7fQS2STO6J9K5FMJiZSYBHswY+36Tfc8awCrQOYw0NuKySwCDklICOPfJNOz4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1763654040; c=relaxed/simple;
	bh=ig/n6xmal2rmA4JExNUc5/vgSFMlFdXaBT9+dcI9OaY=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=IaA9h9ywLV48C2CkOIDtbWbwwAQDZWtL8Cn89WBTA26RTco51qjl+fQC7p/lz3l85xy9pZ8W+VvTWn/PjL5vPz1JZvjgqytimk4nIcnSk0NzYgNECQOX/WCwYy7goAisNSM/FpOpRiPTQWSbiV7+Q0TrlgZAzPefIjbt0aYmDDg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=kernel.dk; spf=pass smtp.mailfrom=kernel.dk; dkim=pass (2048-bit key) header.d=kernel-dk.20230601.gappssmtp.com header.i=@kernel-dk.20230601.gappssmtp.com header.b=YO90Hfoy; arc=none smtp.client-ip=209.85.166.47
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=kernel.dk
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=kernel.dk
Received: by mail-io1-f47.google.com with SMTP id ca18e2360f4ac-9491571438cso46198639f.0
        for <io-uring@vger.kernel.org>; Thu, 20 Nov 2025 07:53:58 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernel-dk.20230601.gappssmtp.com; s=20230601; t=1763654038; x=1764258838; darn=vger.kernel.org;
        h=content-transfer-encoding:in-reply-to:from:content-language
         :references:cc:to:subject:user-agent:mime-version:date:message-id
         :from:to:cc:subject:date:message-id:reply-to;
        bh=pZCWSO8RasID5uf2JDwlFGfXFjpbDvxTN1KYnv68WYU=;
        b=YO90Hfoy4Kz1/Ib/8VjyCQAfFd6zEM1RSsiwFdElzRrYCDsR7L+8XMAcBSeIQDzFbD
         rM9goE+fXx+qj30n33APLZ4FwEQWAlTOTQTBoFNC7l6XGxzCgyDf6PjjbfOvuQgmiGle
         FR7tPXwrpa12soBWcdlJgOYC2wGIHBBLmELnRgKLQbBWR8C73Gq4p86fv32rLSBvBpXj
         bEPva9Q0QKJ7cfvgvrbsc8yWZADSIlEJOfzyRXxuXMjGDkXuD0a4TbIqlZRdae8YPIXR
         VdS+Fhyp5ALWTH9sdMgxOAPA2n8KMo42tdlA8NjQalTAh67GOKI1Mr1Zcutsr/H6hIXB
         cZUg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1763654038; x=1764258838;
        h=content-transfer-encoding:in-reply-to:from:content-language
         :references:cc:to:subject:user-agent:mime-version:date:message-id
         :x-gm-gg:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=pZCWSO8RasID5uf2JDwlFGfXFjpbDvxTN1KYnv68WYU=;
        b=q2nvTKaBshh7qvIDEvPDsVXm+AEFYb14mWYHF5D2M53UAsW+OvKX1aohLWFIuxtX1l
         rHlWfsDVE0tdM+oAcIZLFQCD1KY1Z3s6c4ywWc+RYr5BEq9oobiISsyxQqo3CzzIA+Tv
         hAg6SHcuerV4C13J+0r0gnxTBXitqv2S/JwZSa8enocLY2qh0cOqOODAtDFilQbdvvoW
         0Z6edvaa4ojFUxKit+0JAb48SjdJruFhqpiGtxwUHAiTXXcIW7W9iV4yuhOzpvtAFdbX
         sQZsNOJ8utkcCSGTatXMRY/8gW3ZL2zKoe2K6CrTB/Z5sZ0e2YWW5LdIK/cA2hzOB6IB
         Z1oQ==
X-Forwarded-Encrypted: i=1; AJvYcCVfv3Jf4Uhw47zj1K2Qrf4zwjXx9w2YoEj9yf5FZnjgdLRDxjRZ7eLHv3c2uv8mJBJz6y1umYliZQ==@vger.kernel.org
X-Gm-Message-State: AOJu0YyOi1IMP+GIg0JoBKxLhNG2xo+Mbak+/dlh4ENzAiV+ZIbwXZ5h
	bv7/ye92ErcrzXxjCFePrSPYxkmnCnUgJmleaiG8N2u+bLMEJInpTi8vds1bFP5OUkZ/LNsmmUC
	QYmMi
X-Gm-Gg: ASbGnctLuKAE53vLeoL6BKLDN/vngDzen3T2gVWmGCYNRtNVnmD7irPB+p5eoh5FkaV
	gF66SPw1onT8/KldEdYXkbiqz9FYMuYmbpZRCxnx/T5pWTem5ClPyHdhcYEXHVlC9d+wYRzTVku
	SidZr2OGgZfpVH7jutR9Y4uBmHj2zGC419zTFgM6eRMukzdDteJF9tlG6tOAYfNKxAdOEi/0Q0e
	KCNrj+blFCcIMhuPYDBPKB7hUrEYMJNgEx+s8RoxOu8kdQZRVKUMCmTynFjZYW+tZi4WELb5NVV
	/hD0kU9u9OU+MODJcy+EasYUTh7iZiZ2L+FelJ16SEkAPliyA5k5A+tvHj79rfAgpetLzRgw9WR
	NVSmp65Su/+NknMuZiLWcwRbm/rCE+2swKGFSUqhoDcoG+dh/GkmC8U74YE8wOZ7wjsGH4c00z5
	fUIiGFxQ==
X-Google-Smtp-Source: AGHT+IHkmqfmD5Sblsx6BX9vGdeKHw9Z7vlj3XgPSQVFQqXHsc+9SYotRfC1c301uKSMR73ApXMZUw==
X-Received: by 2002:a02:384d:0:b0:5b7:12b4:475e with SMTP id 8926c6da1cb9f-5b9541543b6mr2403947173.11.1763654037727;
        Thu, 20 Nov 2025 07:53:57 -0800 (PST)
Received: from [192.168.1.96] ([96.43.243.2])
        by smtp.gmail.com with ESMTPSA id 8926c6da1cb9f-5b954b207ccsm1076224173.34.2025.11.20.07.53.56
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Thu, 20 Nov 2025 07:53:57 -0800 (PST)
Message-ID: <312fe285-3915-4108-bc49-3357977d644d@kernel.dk>
Date: Thu, 20 Nov 2025 08:53:56 -0700
Precedence: bulk
X-Mailing-List: io-uring@vger.kernel.org
List-Id: <io-uring.vger.kernel.org>
List-Subscribe: <mailto:io-uring+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:io-uring+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH 04/44] io_uring/net: Change some dubious min_t()
To: David Laight <david.laight.linux@gmail.com>
Cc: linux-kernel@vger.kernel.org, io-uring@vger.kernel.org
References: <20251119224140.8616-1-david.laight.linux@gmail.com>
 <20251119224140.8616-5-david.laight.linux@gmail.com>
 <3202c47d-532d-4c74-aff9-992ec1d9cbeb@kernel.dk>
 <20251120154817.0160eeac@pumpkin>
Content-Language: en-US
From: Jens Axboe <axboe@kernel.dk>
In-Reply-To: <20251120154817.0160eeac@pumpkin>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit

On 11/20/25 8:48 AM, David Laight wrote:
> On Thu, 20 Nov 2025 07:48:58 -0700
> Jens Axboe <axboe@kernel.dk> wrote:
> 
>> On 11/19/25 3:41 PM, david.laight.linux@gmail.com wrote:
>>> From: David Laight <david.laight.linux@gmail.com>
>>>
>>> Since iov_len is 'unsigned long' it is possible that the cast
>>> to 'int' will change the value of min_t(int, iov[nbufs].iov_len, ret).
>>> Use a plain min() and change the loop bottom to while (ret > 0) so that
>>> the compiler knows 'ret' is always positive.
>>>
>>> Also change min_t(int, sel->val, sr->mshot_total_len) to a simple min()
>>> since sel->val is also long and subject to possible trunctation.
>>>
>>> It might be that other checks stop these being problems, but they are
>>> picked up by some compile-time tests for min_t() truncating values.  
>>
>> Fails with clang-21:
>>
>> io_uring/net.c:855:26: error: call to '__compiletime_assert_2006' declared with 'error' attribute: min(sel->val, sr->mshot_total_len) signedness error
>>   855 |                 sr->mshot_total_len -= min(sel->val, sr->mshot_total_len);
> 
> I'll take a look, I normally use gcc but there must be something
> subtle going on. Actually which architecture? I only tested x86-64.

This is x86-64.

-- 
Jens Axboe

