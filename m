Return-Path: <io-uring+bounces-10383-lists+io-uring=lfdr.de@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [147.75.80.249])
	by mail.lfdr.de (Postfix) with ESMTPS id A969AC375DA
	for <lists+io-uring@lfdr.de>; Wed, 05 Nov 2025 19:45:06 +0100 (CET)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id 350FA1A2171A
	for <lists+io-uring@lfdr.de>; Wed,  5 Nov 2025 18:45:31 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 97CFC29992A;
	Wed,  5 Nov 2025 18:45:02 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel-dk.20230601.gappssmtp.com header.i=@kernel-dk.20230601.gappssmtp.com header.b="RSp//kx2"
X-Original-To: io-uring@vger.kernel.org
Received: from mail-io1-f45.google.com (mail-io1-f45.google.com [209.85.166.45])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5135622157B
	for <io-uring@vger.kernel.org>; Wed,  5 Nov 2025 18:44:58 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.166.45
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1762368302; cv=none; b=jeC6IE3l93i8W42oBMGLS6djXOaDdEwOEo9F7PBfy3xlXzIoU7Z9lTkp4lyXeTqYyOr+hlvNtJHAIYDE3HGM+hlqWZrW6MphhNVscOWWZP1+RG6CKLNmOOv3N0mkRWc3luTyH/i322xi1XBbV9PEe5MSZxgRhRuGClXoAiPg41o=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1762368302; c=relaxed/simple;
	bh=40J3nQIy/DPXOemDa1Y6vSXXhvMjKwx6NdE39WL6jek=;
	h=Message-ID:Date:MIME-Version:Subject:To:References:From:
	 In-Reply-To:Content-Type; b=LU/l+DsIbphUc9Vtzw8WdXUR8EvMA92yRWeycJc9Cp5mEjDXzx2Za0wu1cMYdd8hJe9PpjdZx9pNTvAbIjKcBgoiUFnyRrzyomfFRZMsrJ/svHNg0JW4bEaayuMzGO0BYuijMU2cU/nXzoH9xlbNUcdSttsf1D+NBEBasNrZ5GY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=kernel.dk; spf=pass smtp.mailfrom=kernel.dk; dkim=pass (2048-bit key) header.d=kernel-dk.20230601.gappssmtp.com header.i=@kernel-dk.20230601.gappssmtp.com header.b=RSp//kx2; arc=none smtp.client-ip=209.85.166.45
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=kernel.dk
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=kernel.dk
Received: by mail-io1-f45.google.com with SMTP id ca18e2360f4ac-9486b567baaso7244439f.0
        for <io-uring@vger.kernel.org>; Wed, 05 Nov 2025 10:44:58 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernel-dk.20230601.gappssmtp.com; s=20230601; t=1762368297; x=1762973097; darn=vger.kernel.org;
        h=content-transfer-encoding:in-reply-to:from:content-language
         :references:to:subject:user-agent:mime-version:date:message-id:from
         :to:cc:subject:date:message-id:reply-to;
        bh=MRKL5zkx6MIavWTflj2AbVOp8JfmKeoTjbY3LPmhsZs=;
        b=RSp//kx2PE4evv0lyXMQcbEYhe43PtbTe25Bjjordtj73alq6J3jvloBmCPPrZoCB8
         TDtGplNTs+vSZjJuuCpXJqozKtxtLwCjeFinZ2Nrskn1Ven4EWCbOfI2PggCSnUFwlAZ
         F+mSbKwVjmyLcr9aTBaPZxCeM6ORNrjjfQ6oJQ4/Ny+nHJjU8ZkNi4Zio9YXFYVPxTXp
         yHJMiLtmRPeNmFuC/LJu7C6lF7TFKm9HXQpZEsU7aK+5/3aoQ9ZlD3MuUZnEkiBnLIrP
         CCSJAEqkPrNURm6jwY7L2pajQs/QdleAmaNNq2vzY7C5ahMfTGILgcl6Cy9xkMvAZsLy
         tSFQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1762368297; x=1762973097;
        h=content-transfer-encoding:in-reply-to:from:content-language
         :references:to:subject:user-agent:mime-version:date:message-id
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=MRKL5zkx6MIavWTflj2AbVOp8JfmKeoTjbY3LPmhsZs=;
        b=sSz94IQbDSzAORvDaQW8h1kGhfzHltCMjAO72iS8EXSLKzZ9Mm51tJ60UPOv5Kdwi0
         p9BKfTeMeOjMr4tQaMz4f81cs/iE+DUndCQFe2C40C+WoQ9Tn6DUVFnVcsjDc6NLTZef
         c8VqT4P9oV0r7wJs0JEv6YcmCGjlR9dsqpc+BvcJaS+Q7/qi7+5C6oqEM1NZK6EDUvVS
         FnxZU7mSLg9vhAuYLr+b7KdVLec2FVern/tQgWLdsKy3iAohDYpC+8Nisn85DTdcOfnh
         amuttP1nnp3myLG69uexmPLowmCkedV65FAhr7UoXjpHg3d73OSm3jemqcTIALctsqbY
         /vew==
X-Forwarded-Encrypted: i=1; AJvYcCUwYf0xhrWZ6S/WNMiQZxr9KsyVZnt7YJijXER5Y5gI2LETMXXzoqSGK7mWnaQcdTgqVowDw8xYMA==@vger.kernel.org
X-Gm-Message-State: AOJu0YwParLQdn4cY8NVPp2IN5GKtWjULI4lXQD/OU/hAHfMhNX4zNe/
	Zq2ja/Ers6uFVgTVrFBjVKXK8XxhqBsf6oqo0I9PEdzjCNU3Q4RZeLU9m2k+YSzaAUOYZYKJ4KH
	yWwm8
X-Gm-Gg: ASbGncubuP0NzMgAE5fYF/NNyJ3vsBBBLo1P52vrpFjzTncjdnqVg6e8aRoJEPwYeOE
	egNILo+lyOHcGvxfFrV042aWTfvSDDu8SAhzm6UG0PeP3UU3K/Ebo1lnvIbxjjiSp6fNPUitkV1
	lBl6By1s3YKsi5f/OTYJfAjUcob3UbJ47j/BzGdvN8VtXp5MUz5bBdhfWjFR1uxo8UlPz7SMwVJ
	PZmkCem5W6RRXF8BW9NhK2V18XaLgGrdZmiBlx6/HCab09nILpP7TG0vkk+B2Nqq8J10Q0vKsuC
	7n8DhhwxxuupZIRFYumJUqUKy7FY3f8T80wRvguJazc2sb+HSwUqnC1br+GjrEI/5J4n8kY8ABd
	o5J6Mpwy5XLX6PBo5nokaB92wDoRaFTrEu20ZHY6rpbSzYJuVmwQs
X-Google-Smtp-Source: AGHT+IEYfY2qcmbVm5ZT7BE+xyVGA9QobbZwSuM8xKq74tObCVultckbZxpXIwdoGlsBIhIG9RaBdg==
X-Received: by 2002:a05:6e02:1609:b0:430:bf89:f7f7 with SMTP id e9e14a558f8ab-433407a3dabmr73712105ab.13.1762368297434;
        Wed, 05 Nov 2025 10:44:57 -0800 (PST)
Received: from [172.19.0.90] ([99.196.133.153])
        by smtp.gmail.com with ESMTPSA id 8926c6da1cb9f-5b745c445e9sm46381173.49.2025.11.05.10.44.52
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Wed, 05 Nov 2025 10:44:56 -0800 (PST)
Message-ID: <43429045-4443-4e5c-a892-4265de2cd026@kernel.dk>
Date: Wed, 5 Nov 2025 11:44:45 -0700
Precedence: bulk
X-Mailing-List: io-uring@vger.kernel.org
List-Id: <io-uring.vger.kernel.org>
List-Subscribe: <mailto:io-uring+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:io-uring+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH io_uring-6.18 1/1] io_uring: fix types for region size
 calulation
To: Pavel Begunkov <asml.silence@gmail.com>, io-uring@vger.kernel.org
References: <f883c8cca557438e70423b4831d2e8d17a4eeaf4.1762357551.git.asml.silence@gmail.com>
Content-Language: en-US
From: Jens Axboe <axboe@kernel.dk>
In-Reply-To: <f883c8cca557438e70423b4831d2e8d17a4eeaf4.1762357551.git.asml.silence@gmail.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit

On 11/5/25 8:47 AM, Pavel Begunkov wrote:
> ->nr_pages is int, it needs type extension before calculating the region
> size.
> 
> Fixes: a90558b36ccee ("io_uring/memmap: helper for pinning region pages")
> Signed-off-by: Pavel Begunkov <asml.silence@gmail.com>
> ---
>  io_uring/memmap.c | 2 +-
>  1 file changed, 1 insertion(+), 1 deletion(-)
> 
> diff --git a/io_uring/memmap.c b/io_uring/memmap.c
> index 2e99dffddfc5..fab79c7b3157 100644
> --- a/io_uring/memmap.c
> +++ b/io_uring/memmap.c
> @@ -135,7 +135,7 @@ static int io_region_pin_pages(struct io_ring_ctx *ctx,
>  				struct io_mapped_region *mr,
>  				struct io_uring_region_desc *reg)
>  {
> -	unsigned long size = mr->nr_pages << PAGE_SHIFT;
> +	unsigned long size = (size_t)mr->nr_pages << PAGE_SHIFT;
>  	struct page **pages;
>  	int nr_pages;

Should probably consistently use a size_t, everywhere else does. Doesn't
matter here as io_pin_pages() does the right thing anyway.

-- 
Jens Axboe

