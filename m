Return-Path: <io-uring+bounces-7066-lists+io-uring=lfdr.de@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [139.178.88.99])
	by mail.lfdr.de (Postfix) with ESMTPS id A9E40A5E171
	for <lists+io-uring@lfdr.de>; Wed, 12 Mar 2025 17:08:30 +0100 (CET)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id D126A3BC42D
	for <lists+io-uring@lfdr.de>; Wed, 12 Mar 2025 16:07:43 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 688CC1C84D4;
	Wed, 12 Mar 2025 16:07:26 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel-dk.20230601.gappssmtp.com header.i=@kernel-dk.20230601.gappssmtp.com header.b="HZe/Rgjw"
X-Original-To: io-uring@vger.kernel.org
Received: from mail-io1-f48.google.com (mail-io1-f48.google.com [209.85.166.48])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D6E511C5F1E
	for <io-uring@vger.kernel.org>; Wed, 12 Mar 2025 16:07:23 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.166.48
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1741795646; cv=none; b=rLFnS4Gy+2UyrxLyzPZEHhDalccGLO7D6aPNsmZrD78UD78BwdmxkYl6y+J0kNiFpCnNSd00OIGg9FpfZJ0T6P53/yIQI5J6B2L7GD4i7fDuO3bDx7By6Fq7/YtQmpmLEcjFeOnGXIzFOSvLCV1Mf5PTpCz5UcHU1PkT6/4AiBk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1741795646; c=relaxed/simple;
	bh=+DPcVpt5jm09eAi/Y9n5785dJsafsofbqA8F/h57dus=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=FLOjnBCekJBEQanluFiD1CmlHaG1DfcLuXVnrNu8EJ9kv8uuDFAQHMLj6ZG0stCT965XtJfTsko9FxY4pdAoiE6CIyhQlTmIKwMv/GgOFqrmj0GeN0Qyw2IeH44dQQ4vNAn4jbwFLeEQfsxaEPvlOs//62oywesXDe1BROo/QRk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=kernel.dk; spf=pass smtp.mailfrom=kernel.dk; dkim=pass (2048-bit key) header.d=kernel-dk.20230601.gappssmtp.com header.i=@kernel-dk.20230601.gappssmtp.com header.b=HZe/Rgjw; arc=none smtp.client-ip=209.85.166.48
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=kernel.dk
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=kernel.dk
Received: by mail-io1-f48.google.com with SMTP id ca18e2360f4ac-85dac9729c3so71263239f.2
        for <io-uring@vger.kernel.org>; Wed, 12 Mar 2025 09:07:23 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernel-dk.20230601.gappssmtp.com; s=20230601; t=1741795643; x=1742400443; darn=vger.kernel.org;
        h=content-transfer-encoding:in-reply-to:from:content-language
         :references:cc:to:subject:user-agent:mime-version:date:message-id
         :from:to:cc:subject:date:message-id:reply-to;
        bh=ExMoY/YUEJ2sXZfuXzKCTdc9+tog41q5+FPX04PqUyM=;
        b=HZe/RgjwWI1hEqmeTUpZ7rLgRzKZbdsCLSjpiIZwywmwJMJ7rpKITg+E+bNy2VmPA3
         IXP66hluxKFO1nUuFB97+n015rW282h0l3WS6oSFD4BCQGeDnXInZkpeJJGAJx5xKHo1
         wylHfhTaRJRSVDoQX0JR0cIYXPLxmrcGiXnxPtenFa7zE4adRUaOKenn9Q6mwk2/sjpe
         ObaEDKowiY/sh2AF5g5FVxhgZZ76mQY6Xfa/1zeE1UrBHyU0gz2AWaUwnb1xhI3RbcAb
         BMkdAkiZzlHY3FyxqDwxgT5FQHU9ZZBWxOb/LHgS5vNpc7nEVtO8uWyp+B5c4UTP/PUY
         BAGg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1741795643; x=1742400443;
        h=content-transfer-encoding:in-reply-to:from:content-language
         :references:cc:to:subject:user-agent:mime-version:date:message-id
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=ExMoY/YUEJ2sXZfuXzKCTdc9+tog41q5+FPX04PqUyM=;
        b=Dk/zBl0ylRgQ2nMDLlDyIREFBfZHtvTYJNFaT8eH+J2KcRt/OakLAV4mqFpL7jgCb3
         /OlgEGs3fV0fkVitrYgkx4uUo017dxK4dQxIwUEladnLgcr+SQZcsn1/IJfHuAXCrVPD
         D/SXZ4PIUNUhZUgu6wtEsJIGiRZ+026IRdvQABNeQSAvARDawEtNiB8qQ/9yLtzufhtk
         KPySy9E4zyeAihEyUjgpkjS+M5OfanzTs7ZwNxzdM0HdjTJXWTcokrAwBP8Zz0705jgH
         8rrsL0Sma8uzs/uE1dTFOucw3+zy0H4ulF/RyEJe+qZEloxzKAxgscz5AwPy1YWGTy4a
         JOiA==
X-Forwarded-Encrypted: i=1; AJvYcCXm4FGhXCg5RG7BXerZyh8SvxmxfVM7Yozo7h6IdmyrLmUgxzFdrm4MFXe7P6wlp1D2VdgVRfJ9Uw==@vger.kernel.org
X-Gm-Message-State: AOJu0Yy5gYPpbDiv7S3meTXiayOP3FgymqTOwieajWAhJ9d9Dy01L26+
	6VOjnnaT04SOelwJusyWWqwv4OndowUqqtS6ILHQeCzqLetxIIXjUWJvJ/3zvCM=
X-Gm-Gg: ASbGnctajs1jCPX7le6e5B5lcmLnjxmoZ6NAB3s97zZnzAk9Lzt+35s5I9ztSilU+ZS
	10Mnq3tOjm8nJGc53M6hkwjhsQmEseBLwgIAioy2JLYplDeDQAegdcD7KLpJa8UAXZn+Nh9Wdua
	mTdqX01ppWgiQZPP6SwIMW7y3tXmCRaOFyN1vueldp7QlBoc6h2cT/WuiSR7uPdL+m5lG/J0623
	BVZkYjHGWWjTHEKUR92EJTC0TmIa0ZPjuVK1OELuN5GHI4tnLvsxzQ9Tb5QwT63KPHASm3gH774
	RZTbLH/Ofz8QR2Hc8HAoZTXcu16fnqkfiuENNZ3n
X-Google-Smtp-Source: AGHT+IElo/nFdPS6E/5N5+GL1pAZfk0yR7kOrU1+gao2muzmo9g0AwgP1v3zMHzkrcml22cA5yeNRw==
X-Received: by 2002:a05:6602:398f:b0:85c:5521:cbfe with SMTP id ca18e2360f4ac-85d8e2233c5mr1023090939f.8.1741795642951;
        Wed, 12 Mar 2025 09:07:22 -0700 (PDT)
Received: from [192.168.1.116] ([96.43.243.2])
        by smtp.gmail.com with ESMTPSA id ca18e2360f4ac-85b119a823asm284201939f.14.2025.03.12.09.07.21
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Wed, 12 Mar 2025 09:07:22 -0700 (PDT)
Message-ID: <6115bfac-658c-4e8c-859f-d4a1a5820dae@kernel.dk>
Date: Wed, 12 Mar 2025 10:07:21 -0600
Precedence: bulk
X-Mailing-List: io-uring@vger.kernel.org
List-Id: <io-uring.vger.kernel.org>
List-Subscribe: <mailto:io-uring+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:io-uring+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH] fs: dodge an atomic in putname if ref == 1
To: Mateusz Guzik <mjguzik@gmail.com>, brauner@kernel.org,
 viro@zeniv.linux.org.uk
Cc: jack@suse.cz, linux-kernel@vger.kernel.org,
 linux-fsdevel@vger.kernel.org, io-uring@vger.kernel.org,
 audit@vger.kernel.org
References: <20250311181804.1165758-1-mjguzik@gmail.com>
Content-Language: en-US
From: Jens Axboe <axboe@kernel.dk>
In-Reply-To: <20250311181804.1165758-1-mjguzik@gmail.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit

On 3/11/25 12:18 PM, Mateusz Guzik wrote:
> diff --git a/fs/namei.c b/fs/namei.c
> index 06765d320e7e..add90981cfcd 100644
> --- a/fs/namei.c
> +++ b/fs/namei.c
> @@ -275,14 +275,19 @@ EXPORT_SYMBOL(getname_kernel);
>  
>  void putname(struct filename *name)
>  {
> +	int refcnt;
> +
>  	if (IS_ERR_OR_NULL(name))
>  		return;
>  
> -	if (WARN_ON_ONCE(!atomic_read(&name->refcnt)))
> -		return;
> +	refcnt = atomic_read(&name->refcnt);
> +	if (refcnt != 1) {
> +		if (WARN_ON_ONCE(!refcnt))
> +			return;
>  
> -	if (!atomic_dec_and_test(&name->refcnt))
> -		return;
> +		if (!atomic_dec_and_test(&name->refcnt))
> +			return;
> +	}

Looks good to me, I use this trick with bitops too all the time, to
avoid a RMW when possible.

Reviewed-by: Jens Axboe <axboe@kernel.dk>

-- 
Jens Axboe

