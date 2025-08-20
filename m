Return-Path: <io-uring+bounces-9125-lists+io-uring=lfdr.de@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [IPv6:2604:1380:45e3:2400::1])
	by mail.lfdr.de (Postfix) with ESMTPS id E53AEB2E56A
	for <lists+io-uring@lfdr.de>; Wed, 20 Aug 2025 21:02:27 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id A4CF5684244
	for <lists+io-uring@lfdr.de>; Wed, 20 Aug 2025 19:02:26 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id B67DA2594BD;
	Wed, 20 Aug 2025 19:02:23 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel-dk.20230601.gappssmtp.com header.i=@kernel-dk.20230601.gappssmtp.com header.b="Co7gE49h"
X-Original-To: io-uring@vger.kernel.org
Received: from mail-oi1-f180.google.com (mail-oi1-f180.google.com [209.85.167.180])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 30F4836CDEB
	for <io-uring@vger.kernel.org>; Wed, 20 Aug 2025 19:02:20 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.167.180
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1755716543; cv=none; b=XHvvWyYwXbui/asezt+qGIv9+XoMVHBwelyJC5IvEpv15U0ezAZ08e5x4qfsAGedjEsGJAXq+WAH0qJU2bDEuUiJnueMsLC+/o1vo5ihNpJvLAGgdvkZNTSHrtvt2jbHZhChj+vBsBu24A5NgwMD6v2zdDUu3HDjZQOr4ZJ0VHM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1755716543; c=relaxed/simple;
	bh=WNpoeRJgBvYgC7+JitZL+Ny2DDwIDFsAea8R/ACJ8wA=;
	h=Message-ID:Date:MIME-Version:Subject:To:References:From:
	 In-Reply-To:Content-Type; b=bN36U1UqSL7tjEGdfK6h/JQyyvRHfysQK56rabm/sSxVAlr4dGLLdev+JUj/bh00iE+uFC/IWcqXCyoMQQU+NQlb3ShUTq8u9XwstgnbW3wJ4wH3+tKGvpETBcMzGv4urS69Uxfai+tY59Mwl/KEvNabIf0bbudzmA5d2ZMCeJY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=kernel.dk; spf=pass smtp.mailfrom=kernel.dk; dkim=pass (2048-bit key) header.d=kernel-dk.20230601.gappssmtp.com header.i=@kernel-dk.20230601.gappssmtp.com header.b=Co7gE49h; arc=none smtp.client-ip=209.85.167.180
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=kernel.dk
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=kernel.dk
Received: by mail-oi1-f180.google.com with SMTP id 5614622812f47-435de70ed23so157259b6e.1
        for <io-uring@vger.kernel.org>; Wed, 20 Aug 2025 12:02:20 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernel-dk.20230601.gappssmtp.com; s=20230601; t=1755716540; x=1756321340; darn=vger.kernel.org;
        h=content-transfer-encoding:in-reply-to:from:content-language
         :references:to:subject:user-agent:mime-version:date:message-id:from
         :to:cc:subject:date:message-id:reply-to;
        bh=gT0wU22HIJ6M3eQbOipqoVrJ93lojIEBXuanCmtFCHI=;
        b=Co7gE49h7vGUBB10mOnSn3hYYWhxw9joSKpl5NzTsuliSUleSQAw1EIuKjkOfflYoM
         RtgDZmwzUBF2zMGRIOkoJcugW78oJxbBQYVBl+LFX6/0pv71xAIC0eF1I1mMJ8t/AhaT
         23+I/dzCB25iJXTMC87aI90WSq2ngoAAUl/m+vcbg0E1CxRX0F4UUyQPfNfodDcNEY8A
         vscUQnV4ckcvFXErYJXmeyi9Mupe4VzMb22UpyZWhYYOLWzziGXF6HwtA8OjN3Cww/iH
         KxthqDr8rZQuLSdXOCG9COQc5Uspe69yf5ZZe5D38/0l1cB17Zg+AyQIsBNoJsK6gvHn
         jZMA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1755716540; x=1756321340;
        h=content-transfer-encoding:in-reply-to:from:content-language
         :references:to:subject:user-agent:mime-version:date:message-id
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=gT0wU22HIJ6M3eQbOipqoVrJ93lojIEBXuanCmtFCHI=;
        b=RYy9ZiREO+jvRRySi8q1HiVVal4iM9/kYAPvvOzE8ylvzgkp/V+4ZCwrW65H+bfsrh
         21L9G990yERr7C5TdD5cH7+yzWcf8K7wmDe77eaHfvvhUFvpvMZeE6fZi1J/+qrFDpZj
         8GjMet/fSe/dQgWboyc4Kn6L3wgtIOeUk3ht2Fnk8hI5hHXJSafslAGwRxg2nD4ujaVq
         DzW1uw1VLL0f5xTdJGuzYfkBQkAZWOKadpRuuVjU8Miv321UoOYx5+zMZbj3QC/lJEAr
         X7MXG6RwEyOODL71ewKhfOrt6N9+g3sDL3oCybGANeeqjwqbbauf9cAB9qIM4AxYfcrU
         kT6w==
X-Forwarded-Encrypted: i=1; AJvYcCWzpHHZgiipOQrLsRGmJzh+hUSK/dmL5868Vc1mdgQUkFGPFknw0g1hsQUU9K6An8ezoR1qVUqlaw==@vger.kernel.org
X-Gm-Message-State: AOJu0YwTTUamdYGnBWR3NcPmpmZdcA0VRVWk1pP8dqbRZg8kvQHJSoeg
	UBm5KtrFCmVl5wo1vVfZDLe6IikQ8Gfk99PYBqllispic9OXQQFfBydQRrt/m02NPkY=
X-Gm-Gg: ASbGncs5VZCApEbFp0VgvB1tnzgvLUgDmYWpL2shmhKMGNHp1zK/lpkuzaPdf2YBncH
	8lezhILCuquMtKFPPbjNBy8bTSGz3BKXugd4W4YAVPzQ8mAqrmIOpRSQXPAkcr0SDYXYJKkIu3p
	6q7rmtgDzI0qOrwqFEArdz41OiVM4VM2WTHSRL32Xdv6nmAxcE9XKcJ1Sx8F9Di+yTmu1eHMued
	ELZHyqpnYPPMovq4dyDkJQAbnK1lEY7vp+OQnZ8WgCXcUv8od6K3w9HbM91vLzs7W+53yTmf67Q
	v3IdoU/SgvXr+fsIg+UKyLEvoE84jTgDC+H8kH+JH91+f85+/8mOZE39FhTnurMxHyA2UgGmC5A
	6U47icZfmV81x+69dkYniMVgSyNT5Vg==
X-Google-Smtp-Source: AGHT+IGkxdRBFLqwpI1c1NLzvRX0u3QtkrVD6ZfK8wjelNpyVzWiFcDh1FjPZa1JChcL4M2LXZvDZQ==
X-Received: by 2002:a05:6808:2f11:b0:437:75ea:6c84 with SMTP id 5614622812f47-43775ea72c5mr972649b6e.47.1755716540164;
        Wed, 20 Aug 2025 12:02:20 -0700 (PDT)
Received: from [192.168.1.116] ([96.43.243.2])
        by smtp.gmail.com with ESMTPSA id 8926c6da1cb9f-50c947d4976sm4442563173.36.2025.08.20.12.02.18
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Wed, 20 Aug 2025 12:02:19 -0700 (PDT)
Message-ID: <b811389e-2a4b-42b3-b9ed-3d31e5e30fd2@kernel.dk>
Date: Wed, 20 Aug 2025 13:02:18 -0600
Precedence: bulk
X-Mailing-List: io-uring@vger.kernel.org
List-Id: <io-uring.vger.kernel.org>
List-Subscribe: <mailto:io-uring+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:io-uring+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [zcrx-next 0/2] add support for synchronous refill
To: Pavel Begunkov <asml.silence@gmail.com>, io-uring@vger.kernel.org
References: <cover.1755468077.git.asml.silence@gmail.com>
 <175571405086.442349.7150561067887044481.b4-ty@kernel.dk>
 <c6ea1a29-3a0a-4eee-b137-a0b2929f00df@gmail.com>
Content-Language: en-US
From: Jens Axboe <axboe@kernel.dk>
In-Reply-To: <c6ea1a29-3a0a-4eee-b137-a0b2929f00df@gmail.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit

On 8/20/25 12:57 PM, Pavel Begunkov wrote:
> On 8/20/25 19:20, Jens Axboe wrote:
>>
>> On Sun, 17 Aug 2025 23:44:56 +0100, Pavel Begunkov wrote:
>>> Returning buffers via a ring is efficient but can cause problems
>>> when the ring doesn't have space. Add a way to return buffers
>>> synchronously via io_uring "register" syscall, which should serve
>>> as a slow fallback path.
>>>
>>> For a full branch with all relevant dependencies see
>>> https://github.com/isilence/linux.git zcrx/for-next
>>>
>>> [...]
>>
>> Applied, thanks!
> 
> Leave these and other series out please. I sent them for
> review, but it'll be easier to keep in a branch and rebase
> it if necessary. I hoped tagging with zcrx-next would be
> good enough of a sign.

Alright, but then please make it clear when you are sending
something out for merging.

-- 
Jens Axboe


