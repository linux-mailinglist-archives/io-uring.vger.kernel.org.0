Return-Path: <io-uring+bounces-7547-lists+io-uring=lfdr.de@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [IPv6:2604:1380:4601:e00::3])
	by mail.lfdr.de (Postfix) with ESMTPS id DE85AA93A4C
	for <lists+io-uring@lfdr.de>; Fri, 18 Apr 2025 18:05:45 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id 6A3241B60229
	for <lists+io-uring@lfdr.de>; Fri, 18 Apr 2025 16:05:56 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id F25022147E5;
	Fri, 18 Apr 2025 16:05:40 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=davidwei-uk.20230601.gappssmtp.com header.i=@davidwei-uk.20230601.gappssmtp.com header.b="FNVLXK55"
X-Original-To: io-uring@vger.kernel.org
Received: from mail-pf1-f175.google.com (mail-pf1-f175.google.com [209.85.210.175])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 805542116F1
	for <io-uring@vger.kernel.org>; Fri, 18 Apr 2025 16:05:39 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.210.175
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1744992340; cv=none; b=Kj3ab2dr5RdrGHWcr5GJftKzJjVUbDP9XaWqsY2kDyqR3gwN7r2Kz2tiURxt6z0u4jVA6QnKtJwEJ5GX8/EGwd6nGE87KQwawZShVJhfBWbn2DQkVIa7UaV52XciWwx/kppljN+XN5770hZQ3V6vkaaOoxYoUTsVvBkdImnVKKg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1744992340; c=relaxed/simple;
	bh=/w5rur3o/ojmbutlS6Alq7EYfiHTSfOz7N0LMs+R2hQ=;
	h=Message-ID:Date:MIME-Version:Subject:To:References:From:
	 In-Reply-To:Content-Type; b=RYv8LE4mTtB5vxuo0lXZNQoAPMX9tl0m5JBPQBdyzHQVcwLXSeFSOy+QzW0tkMymB5am9yTLuasxGWBMq10t0Od0TVtYD2kfQckzx9dRSkwqwqxMBfj2RfPM4sTPIyKN02KJPtGouNkMQBwafKST1uQ8mysuJJIjxICsyXNhprQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=davidwei.uk; spf=none smtp.mailfrom=davidwei.uk; dkim=pass (2048-bit key) header.d=davidwei-uk.20230601.gappssmtp.com header.i=@davidwei-uk.20230601.gappssmtp.com header.b=FNVLXK55; arc=none smtp.client-ip=209.85.210.175
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=davidwei.uk
Authentication-Results: smtp.subspace.kernel.org; spf=none smtp.mailfrom=davidwei.uk
Received: by mail-pf1-f175.google.com with SMTP id d2e1a72fcca58-73972a54919so1784626b3a.3
        for <io-uring@vger.kernel.org>; Fri, 18 Apr 2025 09:05:39 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=davidwei-uk.20230601.gappssmtp.com; s=20230601; t=1744992339; x=1745597139; darn=vger.kernel.org;
        h=content-transfer-encoding:in-reply-to:from:references:to
         :content-language:subject:user-agent:mime-version:date:message-id
         :from:to:cc:subject:date:message-id:reply-to;
        bh=TdLzBuvgdZ9JRUGwTqAkarTc8eNGhNJOB7Bp/Zatr5M=;
        b=FNVLXK55d7y8ht1WDGckKBpKrkSJ8tRsctRAfOSsItkck9lgcXuxWoC8XLRMRQg7L6
         dWrCOrwiuTDsDJY+h4KmdsuuMHiA8nqd92nTSp5WxcW5ECv6oinv5hCFjgeNXWedM08+
         IsvsrMXYleqXAnT9NdqRo9afLejh7Gizl+F7Ymy3zJTsmv9jSiBqddsIc+c/BAqdQ1JZ
         uDPDOmsaj4dHoQnrTi54ObIyjxLKT9nvnXy4KKntBWvjEeaJtUZHzKnzdaKVC9y4hulB
         rHSg6NpWw/SWM+JcUQ9in97NIKzuk/lw4jwRRWdmPn5CgxKS3XdjmC9W9VGdQPfpTyr/
         UddQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1744992339; x=1745597139;
        h=content-transfer-encoding:in-reply-to:from:references:to
         :content-language:subject:user-agent:mime-version:date:message-id
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=TdLzBuvgdZ9JRUGwTqAkarTc8eNGhNJOB7Bp/Zatr5M=;
        b=Zgo+t4cBYOwNTtLLXg0sSdGE5BpTVrltk9R24WmS2fIVpGnmu5qTpjORetjan9BkfG
         HqwzYe1M0tqOFIbnKCOzbEGC145RSVmobHF2aaRH8G+WpanhY0A/EhojN2q1tST7Q6jV
         Pudc5+SVKrB4Hx7eeI/DxWSm6X5KwDAgyuzs+YMt8fX0BnABpeFK1gfdgMhmBWZymKII
         EhNSUcOt2tsoKwxdMKY/hlMaghowF9lc+ugj54y0Zu3g2QZ1GAU1OqxvjX/DYnUy6gGW
         I26eDssypmGBUgrMSpm73JYIoU49EZINnMWk6JCNomt4oypwkJwFyxvH0oayQnzc5eEm
         sDIw==
X-Forwarded-Encrypted: i=1; AJvYcCWPxzFvALaA/oJe+54wGH4hKn/nwiy7kyvGxeEqhH6v/IGBxw+80lxXMEYf4QY+vG3F1cR5dUozjw==@vger.kernel.org
X-Gm-Message-State: AOJu0Yy3Ecm0n8+wlUjmtn/WLBg3IXs+gacwuUtobujGG89IrwAaubVA
	F9t48Uubxnx0HfJOCmExJMNdEMka2Ldqf05W1xxNc5TWunDD6U4Hecs24McX2Ck=
X-Gm-Gg: ASbGncuUQV6JiVSsROpcqFmWhOy+raqSXCF6XcZxZRo4nOyH4HzGy+wC9Ra40/IlFAh
	1y6psN9EO8BIo9PlghFQHMmXbxi5eSMoojIfR0+28eKLNCx00G6ehU4gvolOGZ1VCCesBtSZn8v
	ayqC5oLwZB1IvWUxgww8xTlgYIfr84Nu6j0ow6XnGf7OeykoAsV5kHzN3htlgT9JnFF8/sOc7rD
	IiKjbQXqxhTZR+O41KDREeymhd+2JlwX0m8fMoAVQcpUSHB13lpk6zlxzk4hz4BvDObDsc1UTMG
	EhLVV5U6hm5aKhW8F2DClGweTtV30uQMBTKnqVeNtY+ico4YVW2hLBXbuF+yLUn0QaOTNLH7IQn
	EuHnszjKv
X-Google-Smtp-Source: AGHT+IGNSOOcQikLZrhrHgE5pVo0dJ3Z1SJTzmvs4kjyVbuHiEZLAD7859/fSePB4I//1uuaHiqJ6g==
X-Received: by 2002:a05:6a00:21c4:b0:736:3979:369e with SMTP id d2e1a72fcca58-73dc14800ecmr4024841b3a.9.1744992338543;
        Fri, 18 Apr 2025 09:05:38 -0700 (PDT)
Received: from ?IPV6:2a03:83e0:1156:1:1cf1:8569:9916:d71f? ([2620:10d:c090:500::6:5122])
        by smtp.gmail.com with ESMTPSA id d2e1a72fcca58-73dbf8c0233sm1769744b3a.22.2025.04.18.09.05.37
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Fri, 18 Apr 2025 09:05:38 -0700 (PDT)
Message-ID: <b787d94c-8398-43d5-9721-5c4fb76890ca@davidwei.uk>
Date: Fri, 18 Apr 2025 09:05:36 -0700
Precedence: bulk
X-Mailing-List: io-uring@vger.kernel.org
List-Id: <io-uring.vger.kernel.org>
List-Subscribe: <mailto:io-uring+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:io-uring+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH 4/5] io_uring/zcrx: move zcrx region to struct io_zcrx_ifq
Content-Language: en-GB
To: Pavel Begunkov <asml.silence@gmail.com>, io-uring@vger.kernel.org
References: <cover.1744815316.git.asml.silence@gmail.com>
 <6d2bb3ce1d1fb0653a5330a67f6b9b60d069b284.1744815316.git.asml.silence@gmail.com>
From: David Wei <dw@davidwei.uk>
In-Reply-To: <6d2bb3ce1d1fb0653a5330a67f6b9b60d069b284.1744815316.git.asml.silence@gmail.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit

On 2025-04-16 08:21, Pavel Begunkov wrote:
> Refill queue region is a part of zcrx and should stay in struct
> io_zcrx_ifq. We can't have multiple queues without it.
> 
> Note: ctx->ifq assignments are now protected by mmap_lock as it's in
> the mmap region look up path.
> 
> Signed-off-by: Pavel Begunkov <asml.silence@gmail.com>
> ---
>  include/linux/io_uring_types.h |  2 --
>  io_uring/zcrx.c                | 20 ++++++++++++--------
>  io_uring/zcrx.h                |  1 +
>  3 files changed, 13 insertions(+), 10 deletions(-)
> 
> diff --git a/include/linux/io_uring_types.h b/include/linux/io_uring_types.h
> index 3b467879bca8..06d722289fc5 100644
> --- a/include/linux/io_uring_types.h
> +++ b/include/linux/io_uring_types.h
> @@ -448,8 +448,6 @@ struct io_ring_ctx {
>  	struct io_mapped_region		ring_region;
>  	/* used for optimised request parameter and wait argument passing  */
>  	struct io_mapped_region		param_region;
> -	/* just one zcrx per ring for now, will move to io_zcrx_ifq eventually */
> -	struct io_mapped_region		zcrx_region;
>  };
>  
>  /*
> diff --git a/io_uring/zcrx.c b/io_uring/zcrx.c
> index 652daff0eb8d..d56665fd103d 100644
> --- a/io_uring/zcrx.c
> +++ b/io_uring/zcrx.c
> @@ -160,12 +160,11 @@ static int io_allocate_rbuf_ring(struct io_zcrx_ifq *ifq,
>  	if (size > rd->size)
>  		return -EINVAL;
>  
> -	ret = io_create_region_mmap_safe(ifq->ctx, &ifq->ctx->zcrx_region, rd,
> -					 IORING_MAP_OFF_ZCRX_REGION);
> +	ret = io_create_region(ifq->ctx, &ifq->region, rd, IORING_MAP_OFF_ZCRX_REGION);

Why is this changed to io_create_region()? I don't see the caller of
io_allocate_rbuf_ring() changing or taking mmap_lock.

