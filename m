Return-Path: <io-uring+bounces-6295-lists+io-uring=lfdr.de@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [IPv6:2604:1380:45d1:ec00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id EF4E6A2C2E4
	for <lists+io-uring@lfdr.de>; Fri,  7 Feb 2025 13:41:20 +0100 (CET)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id 82D5316295D
	for <lists+io-uring@lfdr.de>; Fri,  7 Feb 2025 12:41:19 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id B12E51624E4;
	Fri,  7 Feb 2025 12:41:15 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="md7a5Tgw"
X-Original-To: io-uring@vger.kernel.org
Received: from mail-ej1-f41.google.com (mail-ej1-f41.google.com [209.85.218.41])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E802B33EC;
	Fri,  7 Feb 2025 12:41:13 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.218.41
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1738932075; cv=none; b=f+pfmjOad77brdHh5kxy1UITdxODjsz93Q5efITT+PnEl8wC6Fkai8oyNPcDhNED3RIqcW9FUQwT5xQDYmup7Twp2+dPX2iWLVdYlTzstEkhZezKiAcnRNAQXwkjighFe2kTqn8pqCw/s7MWVTvfLhP89XpRSwmSoyEcf2z8xKw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1738932075; c=relaxed/simple;
	bh=MspCQtuF1L1uj1gmBsMFVAfZQuU7Dmgijjzp4TtZSCs=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=W8XzRIuhjG7bPcc/hbM+pNrs9NFXqWZpym7kV1FrhKB2TTk4fO8R0FpkMIVmwgR1lRY9Ve09tnmmdIKhe4yeV68ZkmlwlL9S5REgG3bXya/ads+S+BJrkw0DaKbW0IF5dr1A3l/gANj3F8/Ax8qPWhh4r5HxAqJokC2ME28BYrk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=md7a5Tgw; arc=none smtp.client-ip=209.85.218.41
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Received: by mail-ej1-f41.google.com with SMTP id a640c23a62f3a-ab7430e27b2so375557666b.3;
        Fri, 07 Feb 2025 04:41:13 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1738932072; x=1739536872; darn=vger.kernel.org;
        h=content-transfer-encoding:in-reply-to:from:content-language
         :references:cc:to:subject:user-agent:mime-version:date:message-id
         :from:to:cc:subject:date:message-id:reply-to;
        bh=luRbu+qxp5tYTbAPnrQjWIZLwECTkT6rgueITNh5cGE=;
        b=md7a5TgwSdD5p9WvJ7A4TvBNjEWSKL9bJ06h4ZbPeQMWMqih+hY0005ORKMDijNWK8
         8q6hsj6a1Q5d9b+JAjj6mNfl5NxW4s4Gx9dMTYQDQ1s6tTKcbsxFtjkMYEbZUndGQ3Uf
         ISgpASLfd0jVr+7AG4gYR52IjzXig0Z1aPEHymX0IFT43B9p+s51ySqDYuRnJZOEppFU
         UcVbu2Kst1mCDCOMTagFnoju0CYbJ4ESu+OyHnQM1fJChMeqRixCJSpDeJ4Ez+qrYL29
         pE0DZY2Pl/WFOiGQJpik+d53ti9Dj6irYPI4IASBXvh3RFjPBOmBN3N3ifacTU7SrOox
         QNRw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1738932072; x=1739536872;
        h=content-transfer-encoding:in-reply-to:from:content-language
         :references:cc:to:subject:user-agent:mime-version:date:message-id
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=luRbu+qxp5tYTbAPnrQjWIZLwECTkT6rgueITNh5cGE=;
        b=MiCXosY62bLT6XJTTuSaeBNSNHbTAL9y7nm7HwiQuDED/VA5KB6oO/FND979NCvrSg
         qLSW2W602AxBP1K5YJMdHsHHPj7JyN/MSGSYzSLZZX9eCK3fbgB0iYdoqmKd1+/7fcGH
         thBWtMrbTM550IiArh0dlS96Gtev6ZdLq4roe6SGp71VLEd8PI9Skk4qZzfekGTBaY39
         5HLag0NLc1SmzugDpsrzP3eqQSVReDBIb+CKKuKGuVsU9U5UdzRQnjnAN9hi5RfFspKt
         jc+MxndttmrzUVJN4DMwxGstvSyIH4/Lbm2yAvZ+6EtFxBs8jJsI6pQcQGhz1VOxFnZ2
         L6PQ==
X-Forwarded-Encrypted: i=1; AJvYcCUSYXpInzrjftDXxrM/+k3tThORyf/gzUjFI0zamzA+ehkOpmSO0Gpqp06c7xvD8APQhjy0b4LLRdug3Ig=@vger.kernel.org, AJvYcCUtwohtkNhINDpzmyPnygDQG+wjoiJYh/0aY/Do3U4+sG9iyuibLgUm9xF6gIELiRPxZguxsBgqVA==@vger.kernel.org
X-Gm-Message-State: AOJu0Ywb6v9KjqExVJSMp7RtvL6bdaLMj7cmlbvRO9N4r24qXk3nfxEA
	vuHj7JNnv42UPd5gjHexCrVyrMBQo9GE1jJJYJm+gxzRQi032rNQiiRWsA==
X-Gm-Gg: ASbGncubcpAfxQveY0S0iIACInjcE7dJzB7WRqGf7hec71ajoJDgSVXBl+3E1w+/XAE
	IfKuRQtcRaEH6O0G/h0vGjKJhz8eKQm7jLz8LH+c7yGI8u1lVPlLBsY7niW6NOOh6gap9vIt8rP
	4BT444ojxiOMFqmutqadeFvV5zNatD4MaJisV6TE2KNG6LUW4fD65nHL7M8IB0/YbTFEZoUCsH7
	5AInecjb+TlhAZz/UBd0w537ymQAwtnRhW6seQrhClmWDDxkkwqJ5r4FVgvINXNktbYhI5ohrt3
	wO0G28HTyXCXL9cEAnucnyplqjlvnoImvhFOb1EgcStjtDUh
X-Google-Smtp-Source: AGHT+IFe67U49RcIQtd8/cPi8kX86e5CxUBCkNHuuOrF9vP5BxLv5warogiRIPjyMz/W5j2EcWNvCw==
X-Received: by 2002:a17:907:d8f:b0:aac:1e96:e7d2 with SMTP id a640c23a62f3a-ab789c834f5mr310503966b.54.1738932071849;
        Fri, 07 Feb 2025 04:41:11 -0800 (PST)
Received: from ?IPV6:2620:10d:c096:325:77fd:1068:74c8:af87? ([2620:10d:c092:600::1:8e12])
        by smtp.gmail.com with ESMTPSA id a640c23a62f3a-ab795848f79sm7424666b.52.2025.02.07.04.41.10
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Fri, 07 Feb 2025 04:41:11 -0800 (PST)
Message-ID: <a6845bcf-8881-4b92-acc0-0aab8d98cba9@gmail.com>
Date: Fri, 7 Feb 2025 12:41:17 +0000
Precedence: bulk
X-Mailing-List: io-uring@vger.kernel.org
List-Id: <io-uring.vger.kernel.org>
List-Subscribe: <mailto:io-uring+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:io-uring+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH 6/6] io_uring: cache nodes and mapped buffers
To: Keith Busch <kbusch@meta.com>, io-uring@vger.kernel.org,
 linux-block@vger.kernel.org, ming.lei@redhat.com, axboe@kernel.dk
Cc: Keith Busch <kbusch@kernel.org>
References: <20250203154517.937623-1-kbusch@meta.com>
 <20250203154517.937623-7-kbusch@meta.com>
Content-Language: en-US
From: Pavel Begunkov <asml.silence@gmail.com>
In-Reply-To: <20250203154517.937623-7-kbusch@meta.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit

On 2/3/25 15:45, Keith Busch wrote:
> From: Keith Busch <kbusch@kernel.org>
> 
> Frequent alloc/free cycles on these is pretty costly. Use an io cache to
> more efficiently reuse these buffers.
> 
> Signed-off-by: Keith Busch <kbusch@kernel.org>
> ---
>   include/linux/io_uring_types.h |  16 ++---
>   io_uring/filetable.c           |   2 +-
>   io_uring/rsrc.c                | 108 ++++++++++++++++++++++++---------
>   io_uring/rsrc.h                |   2 +-
>   4 files changed, 92 insertions(+), 36 deletions(-)
> 
> diff --git a/include/linux/io_uring_types.h b/include/linux/io_uring_types.h
> index aa661ebfd6568..c0e0c1f92e5b1 100644
> --- a/include/linux/io_uring_types.h
> +++ b/include/linux/io_uring_types.h
> @@ -67,8 +67,17 @@ struct io_file_table {
>   	unsigned int alloc_hint;
>   };
>   
> +struct io_alloc_cache {
> +	void			**entries;
> +	unsigned int		nr_cached;
> +	unsigned int		max_cached;
> +	size_t			elem_size;
> +};
> +
>   struct io_buf_table {
>   	struct io_rsrc_data	data;
> +	struct io_alloc_cache	node_cache;
> +	struct io_alloc_cache	imu_cache;

We can avoid all churn if you kill patch 5/6 and place put the
caches directly into struct io_ring_ctx. It's a bit better for
future cache improvements and we can even reuse the node cache
for files.

...
> diff --git a/io_uring/rsrc.c b/io_uring/rsrc.c
> index 864c2eabf8efd..5434b0d992d62 100644
> --- a/io_uring/rsrc.c
> +++ b/io_uring/rsrc.c
> @@ -117,23 +117,39 @@ static void io_buffer_unmap(struct io_ring_ctx *ctx, struct io_rsrc_node *node)
>   				unpin_user_page(imu->bvec[i].bv_page);
>   		if (imu->acct_pages)
>   			io_unaccount_mem(ctx, imu->acct_pages);
> -		kvfree(imu);
> +		if (struct_size(imu, bvec, imu->nr_bvecs) >
> +				ctx->buf_table.imu_cache.elem_size ||

It could be quite a large allocation, let's not cache it if
it hasn't came from the cache for now. We can always improve
on top.

And can we invert how it's calculated? See below. You'll have
fewer calculations in the fast path, and I don't really like
users looking at ->elem_size when it's not necessary.


#define IO_CACHED_BVEC_SEGS	N

io_alloc_cache_init(&table->imu_cache, ...,
		    /* elem_size */ struct_size(imu, ..., IO_CACHED_BVEC_SEGS));

alloc(bvec_segs) {
	if (bvec_segs <= IO_CACHED_BVEC_SEGS)
		/* use the cache */
	...
}

free() {
	if (imu->nr_segs == IO_CACHED_BVEC_SEGS)
		/* return to cache */
	else {
		WARN_ON_ONCE(imu->nr_segs < IO_CACHED_BVEC_SEGS);
		...
	}
}


> +		    !io_alloc_cache_put(&ctx->buf_table.imu_cache, imu))
> +			kvfree(imu);
>   	}
>   }
>   

-- 
Pavel Begunkov


