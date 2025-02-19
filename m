Return-Path: <io-uring+bounces-6536-lists+io-uring=lfdr.de@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [IPv6:2604:1380:45e3:2400::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 19628A3AED0
	for <lists+io-uring@lfdr.de>; Wed, 19 Feb 2025 02:22:19 +0100 (CET)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 1595A3AAF0E
	for <lists+io-uring@lfdr.de>; Wed, 19 Feb 2025 01:22:01 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id A823C13E41A;
	Wed, 19 Feb 2025 01:22:00 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=davidwei-uk.20230601.gappssmtp.com header.i=@davidwei-uk.20230601.gappssmtp.com header.b="v4MJOHhm"
X-Original-To: io-uring@vger.kernel.org
Received: from mail-pj1-f54.google.com (mail-pj1-f54.google.com [209.85.216.54])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id EF6DC22097
	for <io-uring@vger.kernel.org>; Wed, 19 Feb 2025 01:21:58 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.216.54
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1739928120; cv=none; b=Nt+R6PB7lONJov8zY2iWdk3yduvZsW6VCDx7Wvfcj0wVVc/iC66eFnxyn69y9QzUMn2bhpgjk2GLiOYmqELUgybRta6mU1BpzOCU6hSWdSXiXgnOH13xPHKBePNAPTYsMI19Rr80zxwdP/1QTkH4SbdCUqayhVLfRC305nH0l8g=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1739928120; c=relaxed/simple;
	bh=rACkZ/i4iN7iouldsaNHD5JD6R30JlJFgI3t9UJJNcE=;
	h=Message-ID:Date:MIME-Version:Subject:To:References:From:
	 In-Reply-To:Content-Type; b=ikglrksDZh1D0ww5fCwicc8qJx5/apm/9ygfy43LETuGgEhvg7Yd54Jwza+DCBMbn1poYALpzLd1ahH0npmIkDDs/90xbM7fdIC8sroBj4JTYNBAYgIA4pBojBWGCfu/jEN5e3I/F7ujHBZU97IuWeN1AyDfLKMFwLW+SNa38dM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=davidwei.uk; spf=none smtp.mailfrom=davidwei.uk; dkim=pass (2048-bit key) header.d=davidwei-uk.20230601.gappssmtp.com header.i=@davidwei-uk.20230601.gappssmtp.com header.b=v4MJOHhm; arc=none smtp.client-ip=209.85.216.54
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=davidwei.uk
Authentication-Results: smtp.subspace.kernel.org; spf=none smtp.mailfrom=davidwei.uk
Received: by mail-pj1-f54.google.com with SMTP id 98e67ed59e1d1-2fc737aeeb1so4018572a91.3
        for <io-uring@vger.kernel.org>; Tue, 18 Feb 2025 17:21:58 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=davidwei-uk.20230601.gappssmtp.com; s=20230601; t=1739928118; x=1740532918; darn=vger.kernel.org;
        h=content-transfer-encoding:in-reply-to:from:references:to
         :content-language:subject:user-agent:mime-version:date:message-id
         :from:to:cc:subject:date:message-id:reply-to;
        bh=cs/qxsGh+Itt/0hSYTNAgODFc/tkRBqBzJsO+jJu09Q=;
        b=v4MJOHhmaycAqkxvKFQnfm+yZ8iDZBJQgq+vt+mS/VBXd2ArMGG4t4EgTLof36MW+h
         Ras9LGKlqDwcl57gj14FqfNc9szPi9eFbHYnQ13Xu2syAH5ch6WpOksarYhNH4lmCbsA
         Jsor5SyktXfmnFIgbuTcXJeqkG9SPT6Be3NHDy3ssRRIGx+N6HKjNPkPjfXracg9I/EI
         H8UnTt85+lj5e+KoKSiC3at1NT3Z1Uf5GC0UDkKLEPX4ZIhnDXYU6DEAG5zGHwRMNvaH
         heKwwEmj+o+TSsYLt0U/n2ufAlslgfAMWcYplVl3uNuZ1ws4ueRXg0/gLFOYf+kVOwnL
         sBRg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1739928118; x=1740532918;
        h=content-transfer-encoding:in-reply-to:from:references:to
         :content-language:subject:user-agent:mime-version:date:message-id
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=cs/qxsGh+Itt/0hSYTNAgODFc/tkRBqBzJsO+jJu09Q=;
        b=ITwSxwa2HJza8qHFeWkxG/xZ196m6bANgArirVtxyvNPyZZZjC0MAxX+F+aebUbsYD
         GVp0UtbVRzi9nBPzdyt2SzGXAZpPOe7HOspKwkERd6/M38w1gxlUlW7IJn+nIzl2Ozvy
         D9E6VzFQQrRCcbKlhP2Fr6T7pIkLeZipAxG2KJ3KwnmAntZbA7AbzC0t1AGhdjA8FAw9
         jYvWcfOkts95Bb32tnffKkNtrrO5Fxfpg7kQavmGJQxPmUUbdvqafhln8Ta9PIQoMsp7
         ct4kVPZV7J+vAzzMV0lQOJ4fk/c+voYL1Gv5bvDxI8jEzRtLVtHLDNgQTr9nVSjUuTkz
         njEg==
X-Forwarded-Encrypted: i=1; AJvYcCUEO/hL1BFm4p1Fk+rlamNgkOy9K0HZf+ZrEyXgQ3JamI3HisjKprTlGP3gdJcaR5vFSCyy5JuQRA==@vger.kernel.org
X-Gm-Message-State: AOJu0Yy16Ffz5dAFUvialVlvZRCWBoxQB1ULfJb8cOTTYTWjCqWTp7kp
	5/Xp0EXXUpvOCRROWP1Dw/KjM2gYkD3Fe2rHvmbp+Ld+mtyOs7mR9bFmPOg2+vOS+H5G3rqkZVg
	h
X-Gm-Gg: ASbGncvyKU1mq+kSqczobxy/oHofI7xgl49RphhP0LLbh0Raqp4fhBewpngUbHfnYeB
	KDBeYUF1VjoWfQsxlmr4dypIkkBs2Db1T/OlRgpMrJhU+OTPGX9+nKa6u9W+R7BBuqAGcZQzvAq
	qhjzVWvdrp1vXCRzLEJihOpYnaA+dmSSvhGXF4aIgCvLPfTjfy+3ba6SlkxhxjCj8V1WacjWLH5
	tyRuv0KOaITJ8ia84RSKJOIwW3rebqwnLhJecmLKp4I1qiwAeoh3sGmwyR+ac4gKNwZAzYTzdbU
	UdjRO/HnrVwShCZVoTzsEg==
X-Google-Smtp-Source: AGHT+IEGJl6lxAyF4tojfH8YSBEkJBAw4s+S/alW+vgDJ/nj4W4aXS55/q11+YWcnEBUEFy+92Jjiw==
X-Received: by 2002:a17:90b:134e:b0:2ee:acb4:fecd with SMTP id 98e67ed59e1d1-2fcb5a10379mr2619799a91.9.1739928118077;
        Tue, 18 Feb 2025 17:21:58 -0800 (PST)
Received: from [192.168.1.12] ([97.126.136.10])
        by smtp.gmail.com with ESMTPSA id 98e67ed59e1d1-2fbf98cf1besm12748502a91.11.2025.02.18.17.21.57
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Tue, 18 Feb 2025 17:21:57 -0800 (PST)
Message-ID: <fd45819a-932d-4fdc-91b2-9835fab1f109@davidwei.uk>
Date: Tue, 18 Feb 2025 17:21:57 -0800
Precedence: bulk
X-Mailing-List: io-uring@vger.kernel.org
List-Id: <io-uring.vger.kernel.org>
List-Subscribe: <mailto:io-uring+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:io-uring+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH] io_uring: fix spelling error in uapi io_uring.h
Content-Language: en-GB
To: Jens Axboe <axboe@kernel.dk>, io-uring <io-uring@vger.kernel.org>
References: <fd1a291b-e6e5-4ab0-9a2a-b5751b3e4a02@kernel.dk>
From: David Wei <dw@davidwei.uk>
In-Reply-To: <fd1a291b-e6e5-4ab0-9a2a-b5751b3e4a02@kernel.dk>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit

On 2025-02-18 15:49, Jens Axboe wrote:
> This is obviously not that important, but when changes are synced back
> from the kernel to liburing, the codespell CI ends up erroring because
> of this misspelling. Let's just correct it and avoid this biting us
> again on an import.
> 
> Signed-off-by: Jens Axboe <axboe@kernel.dk>
> 
> ---
> 
> diff --git a/include/uapi/linux/io_uring.h b/include/uapi/linux/io_uring.h
> index e11c82638527..050fa8eb2e8f 100644
> --- a/include/uapi/linux/io_uring.h
> +++ b/include/uapi/linux/io_uring.h
> @@ -380,7 +380,7 @@ enum io_uring_op {
>   *				result 	will be the number of buffers send, with
>   *				the starting buffer ID in cqe->flags as per
>   *				usual for provided buffer usage. The buffers
> - *				will be	contigious from the starting buffer ID.
> + *				will be	contiguous from the starting buffer ID.
>   */
>  #define IORING_RECVSEND_POLL_FIRST	(1U << 0)
>  #define IORING_RECV_MULTISHOT		(1U << 1)

Hah, saw your liburing commit and was about to do the same! It's about
time we stopped propagating this typo back and forth. ;)

Reviewed-by: David Wei <dw@davidwei.uk>

