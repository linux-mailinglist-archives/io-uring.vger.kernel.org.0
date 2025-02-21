Return-Path: <io-uring+bounces-6594-lists+io-uring=lfdr.de@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from sy.mirrors.kernel.org (sy.mirrors.kernel.org [147.75.48.161])
	by mail.lfdr.de (Postfix) with ESMTPS id 79539A3F3EF
	for <lists+io-uring@lfdr.de>; Fri, 21 Feb 2025 13:13:50 +0100 (CET)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sy.mirrors.kernel.org (Postfix) with ESMTPS id 7CBAC7A6B09
	for <lists+io-uring@lfdr.de>; Fri, 21 Feb 2025 12:12:30 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id DC82C2080F2;
	Fri, 21 Feb 2025 12:13:21 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="J14ogNQS"
X-Original-To: io-uring@vger.kernel.org
Received: from mail-wm1-f47.google.com (mail-wm1-f47.google.com [209.85.128.47])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2EC551AF0B8;
	Fri, 21 Feb 2025 12:13:19 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.128.47
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1740140001; cv=none; b=U0VvdQ2DsPHIJVVcUDw96FzgI20UlSyaxYdq9Oy79Sgj+7uSCi84i4S80UPzt57MBLyiFqGC6HDMduuHDu2qc8Y4CvjZ3zjNVKvbejJ7/pQ8WsXWgoRmiSvbzABdPtR603RRrSBdwrWgZHjYHCBL/aKqpbLzyRhJ8p8SPCz57JU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1740140001; c=relaxed/simple;
	bh=hXxabPhxEzmO/UL+78zbBv09X2DPNvSjm64PvtmJJ0Y=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=Rzc7kRtlkv2gklUVipqVQEig0ymRDjHa9BvtoibRywe5Lr8XCFbOiEHRKozka6+9vMDGmcJfbvaCMoazI/ZiKgQQJ52wMZJQoyO0AupwMy/v5jvuaqkO1UsscZvc3BCH1H8Cf3EiYfKuZickarb+5w/tLLvZKP7/dPutBzbfRJw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=J14ogNQS; arc=none smtp.client-ip=209.85.128.47
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Received: by mail-wm1-f47.google.com with SMTP id 5b1f17b1804b1-439a4fc2d65so17636335e9.3;
        Fri, 21 Feb 2025 04:13:19 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1740139998; x=1740744798; darn=vger.kernel.org;
        h=content-transfer-encoding:in-reply-to:from:content-language
         :references:cc:to:subject:user-agent:mime-version:date:message-id
         :from:to:cc:subject:date:message-id:reply-to;
        bh=SeTBP0kt2z5boCI1F2D+0dzCmCR/2SZ7qDyDDR5e8Zg=;
        b=J14ogNQSIF8dvOPKG0SMPUrhgjLOdOEApmWvIXbp3LaY978aVS+G3x574CiISxtVcW
         Lgi3wdCw7Bs/wQIqmzxZsGpwTPBUZnSoSvP4BxWefCydxFu4Kl9asc2isiZe+uK4VzCY
         IEG8/SB4FN58e/W4JJJ5diJWs1QAk2mRFIJk8p8s2JYqqIDQY7KMnJzYZXlRta7h+rPz
         UWyonGTIBYTJYiHlQjD7+3u68t0WEPuwdfcbLuOLcvagg4FuOUOTU80wASxG6406fZyZ
         HDSWK7LrRNK+lxipDF0CRqKqyL3Y3WE7sSyURuvKfAgKydwWazB48MRMtm1P8g+nyvyz
         4YKg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1740139998; x=1740744798;
        h=content-transfer-encoding:in-reply-to:from:content-language
         :references:cc:to:subject:user-agent:mime-version:date:message-id
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=SeTBP0kt2z5boCI1F2D+0dzCmCR/2SZ7qDyDDR5e8Zg=;
        b=tNZAnJAabS9QahNGPxyusd1vPO2uFpv1i/j9Hd/0wlx8mLlrJFkSnP4FV7bysEVtJZ
         ahmHpQJ9mFlHnZ6pcDdOrtnea3uF8R69hE2nRT439/1mxkmJe8sE18ovI89WMOUEzZxe
         xFmyxzn5GbdI4jlNETY7ndAPF6MBC3V8h9gn6VBk14rqIPZknjoEdxGRPXpz0r/AihpD
         kkdsSyiMAd6KN6o22wscb4iDOGecCCkyjFOyA+CNgfaXwIFmhP+RY5NWXfOA0yKcNZne
         EXxJHmCpvAD0b/WjkHAn4X4LOmexKuVJvPWq2ZTovUIHOhERTGv/ZMi8ZzKFPzSorCvj
         2KTA==
X-Forwarded-Encrypted: i=1; AJvYcCXEgrCGl43W5mvj6WcXaFhEQQs0qbDhQHPZ7Cqyv/HnUfCrJTIKeMyvF7BGd5FPxuUN7d5aYlJyWg2knT8v@vger.kernel.org, AJvYcCXslTAab1Lrhirl1CMGmCkdMS9lGaHVv5hrXFtaj/FT61bM5dlzHrNKTA1tr6BnR84sOruoDKrIrw==@vger.kernel.org
X-Gm-Message-State: AOJu0Yyx2fIzqA8blBEZ1l4HtwEPl6KCXgblcXlv2scuFfXvXHn5FpOy
	/vzCCFHF2YgwWTuarL63SHGtFRd0L3oYILyeEKtzF0h9J0WkviTc8OLFvw==
X-Gm-Gg: ASbGnct6LJ6jY5ZavCk61j0Bg1xpgyEYmdsZ7cD2FuS/En0ddvVlUVndF8eCkv/YSgi
	UiArvJDXbAXyTxnEg7a58Y94i5PaMPmBjc9NJelnTat5cdJ3S2hSCaYxU0T3XGEXaHhEvMxeVxz
	VS7uj63FtRcZAeBwLekeEZmwtZfhNlwdJD0kQM3yqRb0rzVavX28Vp3xt46v7C9q7s2GttLKJrq
	dVOu2F8mFSXMAGskwChwR3Avs3NEhreZhF9duxUHvEBfFko9sAZnHTWV8H5izJKkZsATO5we+n0
	ByE+bdxXWKHH5xfS9qHiWWDCj4IXnsgdDdlMuck5S3D5Ohn8gC63LRxxA0Q=
X-Google-Smtp-Source: AGHT+IHYh/tXagBH+FhyM7xr1Rj+NoPIkFXtjpsyKZOXRZoqXOshak04b5u0/XDs6NDMkcOkRByTqw==
X-Received: by 2002:a05:6000:178f:b0:38c:5cd0:ecf3 with SMTP id ffacd0b85a97d-38f6e756a90mr2753587f8f.11.1740139998146;
        Fri, 21 Feb 2025 04:13:18 -0800 (PST)
Received: from ?IPV6:2620:10d:c096:325:77fd:1068:74c8:af87? ([2620:10d:c092:600::1:5e88])
        by smtp.gmail.com with ESMTPSA id a640c23a62f3a-abbdcac38ccsm470502066b.29.2025.02.21.04.13.17
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Fri, 21 Feb 2025 04:13:17 -0800 (PST)
Message-ID: <f6694b56-cd1f-45d5-8e5f-b4a98ab2c7af@gmail.com>
Date: Fri, 21 Feb 2025 12:14:16 +0000
Precedence: bulk
X-Mailing-List: io-uring@vger.kernel.org
List-Id: <io-uring.vger.kernel.org>
List-Subscribe: <mailto:io-uring+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:io-uring+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH] io_uring: add missing IORING_MAP_OFF_ZCRX_REGION in
 io_uring_mmap
To: Bui Quang Minh <minhquangbui99@gmail.com>, io-uring@vger.kernel.org
Cc: Jens Axboe <axboe@kernel.dk>, David Wei <dw@davidwei.uk>,
 linux-kernel@vger.kernel.org
References: <20250221085933.26034-1-minhquangbui99@gmail.com>
Content-Language: en-US
From: Pavel Begunkov <asml.silence@gmail.com>
In-Reply-To: <20250221085933.26034-1-minhquangbui99@gmail.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit

On 2/21/25 08:59, Bui Quang Minh wrote:
> Allow user to mmap the kernel allocated zerocopy-rx refill queue.

Reviewed-by: Pavel Begunkov <asml.silence@gmail.com>

> 
> Signed-off-by: Bui Quang Minh <minhquangbui99@gmail.com>
> ---
>   io_uring/memmap.c | 2 ++
>   1 file changed, 2 insertions(+)
> 
> diff --git a/io_uring/memmap.c b/io_uring/memmap.c
> index 361134544427..76fcc79656b0 100644
> --- a/io_uring/memmap.c
> +++ b/io_uring/memmap.c
> @@ -271,6 +271,8 @@ static struct io_mapped_region *io_mmap_get_region(struct io_ring_ctx *ctx,
>   		return io_pbuf_get_region(ctx, bgid);
>   	case IORING_MAP_OFF_PARAM_REGION:
>   		return &ctx->param_region;
> +	case IORING_MAP_OFF_ZCRX_REGION:
> +		return &ctx->zcrx_region;
>   	}
>   	return NULL;
>   }

-- 
Pavel Begunkov


