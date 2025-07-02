Return-Path: <io-uring+bounces-8592-lists+io-uring=lfdr.de@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [IPv6:2604:1380:45d1:ec00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id B0FD1AF661C
	for <lists+io-uring@lfdr.de>; Thu,  3 Jul 2025 01:13:47 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id 0758D4E823E
	for <lists+io-uring@lfdr.de>; Wed,  2 Jul 2025 23:13:48 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 140CA253F39;
	Wed,  2 Jul 2025 23:13:43 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=davidwei-uk.20230601.gappssmtp.com header.i=@davidwei-uk.20230601.gappssmtp.com header.b="ucuFeK/G"
X-Original-To: io-uring@vger.kernel.org
Received: from mail-pf1-f171.google.com (mail-pf1-f171.google.com [209.85.210.171])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A17A5251799
	for <io-uring@vger.kernel.org>; Wed,  2 Jul 2025 23:13:41 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.210.171
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1751498023; cv=none; b=qukNBokSUxezuPKQYfnJP8dpNFu3PRwhdCFx+wf4UjdxZeT/sNWpYn1pDNwY42+tMqaa2SdKKFpcO4pDWw9uI6No8yOndWbOTcQPdOfS+Ud+YvcoWki8cfATavZeehKDnBhXwII6XquFuJ8IDGyxDOp0o8O01pWZHOYo8EBFBrE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1751498023; c=relaxed/simple;
	bh=waSVLuiPLZJD8aaXSyKVVJqLfZJof2tjGIszSASePCI=;
	h=Message-ID:Date:MIME-Version:Subject:To:References:From:
	 In-Reply-To:Content-Type; b=AWbyvWmYGmGBVQpDC0NFwFuewTMOUcXYbV8v+xZDkBvaAdgEnlrMsbYMe0BX7DF0ptGNqyonMyUYQzAT9Si95O7gEbJQux0leLLFkBdhPnHJrcIJC9v7msV3q5vp3/UfGzDHEtWjkPrdR06cwviVvlEvB78cPVLVHABX1/2BXOE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=davidwei.uk; spf=none smtp.mailfrom=davidwei.uk; dkim=pass (2048-bit key) header.d=davidwei-uk.20230601.gappssmtp.com header.i=@davidwei-uk.20230601.gappssmtp.com header.b=ucuFeK/G; arc=none smtp.client-ip=209.85.210.171
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=davidwei.uk
Authentication-Results: smtp.subspace.kernel.org; spf=none smtp.mailfrom=davidwei.uk
Received: by mail-pf1-f171.google.com with SMTP id d2e1a72fcca58-742c7a52e97so7212802b3a.3
        for <io-uring@vger.kernel.org>; Wed, 02 Jul 2025 16:13:41 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=davidwei-uk.20230601.gappssmtp.com; s=20230601; t=1751498021; x=1752102821; darn=vger.kernel.org;
        h=content-transfer-encoding:in-reply-to:from:content-language
         :references:to:subject:user-agent:mime-version:date:message-id:from
         :to:cc:subject:date:message-id:reply-to;
        bh=t3adCti64k5JET2IteXc5byWrOLwYc4Crrm92m8xRr8=;
        b=ucuFeK/GiurRIZjAvi16M2d4DayknkC7qSZ6i9310+LC0qujos1SBlceTBBfiXP4lG
         OU5ZDCW2rb/HipXKjHd4dHKOhpeQPLYeSJEkbW+mhb5pLNFHFPd7OP0SjmiXQsHmgOlR
         cEoBj00JWYnCaVz0HJtBmZVBDOhq1nx5HLWP/kl1m4AawhJEfZ0JzSqrdPMZOkfnVNzU
         w9FfFwHOgLYQ/jm4yv9topMVQJdHATPgnQ9y2jYFBGsy6dD+hyBjuayTYNB58O9Hi5kQ
         QugpqtBeshuRWCoK+9NyJgnBC6tHGqS3CB1ovmJXPfnJBuKnPN6mKcto3Cx1yQScONIU
         JQYw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1751498021; x=1752102821;
        h=content-transfer-encoding:in-reply-to:from:content-language
         :references:to:subject:user-agent:mime-version:date:message-id
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=t3adCti64k5JET2IteXc5byWrOLwYc4Crrm92m8xRr8=;
        b=K5kL6U82QX5CEBSdM2ZwZDeiyDqNj1pbsgEg1woxkBi4BjMRsP1vgy1JsNAeN9XG9P
         v93vGGBNL1PE8H3EXfoHshx1A3OAjhvS6uWG7iICjnYZcPiZlsbPbZ+UfNEOOTQ1W0dB
         WzFBK2v/wFZbQYL5kxDHWq1PkfUs15TQgQIyQhl2/fcbDvBqLTUMpRwgL98bFidx/aZ/
         JJTvFh1ZaXvx+yfzLUZjGmPOL3VRsNRMURhPl/CuZu1mvbj/jLv5LtdnfFHhjyvNv6oF
         fXMmYJbgV9T/5hKjFGJUw7OomCGq3bzMqb83Dtyw2NLqWzwygW38Xi+VnBtRzibbQHCr
         HnCA==
X-Forwarded-Encrypted: i=1; AJvYcCUcJXcszzQq+iH4Y8ajgmC0pburZRWONI6AMPMBOFHOnzLW4bqv8sGQotfDVc9tY+z4RuRxBrCf/Q==@vger.kernel.org
X-Gm-Message-State: AOJu0YyDCHLFZK+llXCpRGe9QuxvFFy54BAvwMvy6lSKh8mT4xl9PLxV
	7mfJpnufM0JX1Phnu1ewAe1oSIgwg9NywrIQGaOjasEqEU1QKelIdoZXizh7jECuMBg=
X-Gm-Gg: ASbGncuWtEGKDZP0SxwLf2oD9rmnuySk8zpAnrVhPj+j/nKJYWPhm+MyTNJv3y2/SxI
	IzR0xwxH08TCT8b3ozbotpIk9a68UG8XptMEVIPyCmA5Z13cin9DlRCOjABFtYH1o2zZm2+a6cz
	ZbbLiq9J8e7EI9F2A867hvgQmSzsmOo5u0krt16s2bni2te3qiz91M4yi4mycEsPwhM8ybpnjvw
	QOM2RrQ5U2txgdXULfmumJpZDHExf/I395PkpI3MukugEYShqX/kUH9N8eTI+BU3sga3+79uaNt
	tbY9HrXmqvnSkwAd7Y8irFpFOOeKD0XVun5aVhsJCK1Gb/PH7PhNcBcukBUSabVw7D7hyTv8L4B
	mXH9E+3mVbtgLgAQiJbJQJHUSztG5e1R8180=
X-Google-Smtp-Source: AGHT+IHvw2GjPZfHp3VsWM3Q1/vwoeLcrBsvIfPuXy1FgnkK91Yz7okANSoFROHrCimD7Qqln6LLJw==
X-Received: by 2002:a05:6a21:48b:b0:201:2834:6c62 with SMTP id adf61e73a8af0-2240bfba39dmr1979942637.25.1751498020869;
        Wed, 02 Jul 2025 16:13:40 -0700 (PDT)
Received: from ?IPV6:2a03:83e0:1156:1:14f8:5a41:7998:a806? ([2620:10d:c090:500::5:b65f])
        by smtp.gmail.com with ESMTPSA id 41be03b00d2f7-b38dd1a87d0sm105709a12.10.2025.07.02.16.13.40
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Wed, 02 Jul 2025 16:13:40 -0700 (PDT)
Message-ID: <9922a004-a2ed-4a8f-a129-b5a4bcb5ce92@davidwei.uk>
Date: Wed, 2 Jul 2025 16:13:39 -0700
Precedence: bulk
X-Mailing-List: io-uring@vger.kernel.org
List-Id: <io-uring.vger.kernel.org>
List-Subscribe: <mailto:io-uring+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:io-uring+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v4 3/6] io_uring/zcrx: introduce io_populate_area_dma
To: Pavel Begunkov <asml.silence@gmail.com>, io-uring@vger.kernel.org
References: <cover.1751466461.git.asml.silence@gmail.com>
 <a8972a77be9b5675abc585d6e2e6e30f9c7dbd85.1751466461.git.asml.silence@gmail.com>
Content-Language: en-US
From: David Wei <dw@davidwei.uk>
In-Reply-To: <a8972a77be9b5675abc585d6e2e6e30f9c7dbd85.1751466461.git.asml.silence@gmail.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit

On 2025-07-02 07:29, Pavel Begunkov wrote:
> Add a helper that initialises page-pool dma addresses from a sg table.
> It'll be reused in following patches.
> 
> Signed-off-by: Pavel Begunkov <asml.silence@gmail.com>
> ---
>   io_uring/zcrx.c | 56 +++++++++++++++++++++++++++----------------------
>   1 file changed, 31 insertions(+), 25 deletions(-)
> 
> diff --git a/io_uring/zcrx.c b/io_uring/zcrx.c
> index 2cde88988260..cef0763010a0 100644
> --- a/io_uring/zcrx.c
> +++ b/io_uring/zcrx.c
> @@ -47,6 +47,35 @@ static inline struct page *io_zcrx_iov_page(const struct net_iov *niov)
>   	return area->mem.pages[net_iov_idx(niov)];
>   }
>   
> +static int io_populate_area_dma(struct io_zcrx_ifq *ifq,
> +				struct io_zcrx_area *area,
> +				struct sg_table *sgt, unsigned long off)
> +{
> +	struct scatterlist *sg;
> +	unsigned i, niov_idx = 0;
> +
> +	for_each_sgtable_dma_sg(sgt, sg, i) {
> +		dma_addr_t dma = sg_dma_address(sg);
> +		unsigned long sg_len = sg_dma_len(sg);
> +		unsigned long sg_off = min(sg_len, off);
> +
> +		off -= sg_off;
> +		sg_len -= sg_off;
> +		dma += sg_off;
> +
> +		while (sg_len && niov_idx < area->nia.num_niovs) {
> +			struct net_iov *niov = &area->nia.niovs[niov_idx];
> +
> +			if (net_mp_niov_set_dma_addr(niov, dma))
> +				return -EFAULT;
> +			sg_len -= PAGE_SIZE;
> +			dma += PAGE_SIZE;
> +			niov_idx++;
> +		}
> +	}
> +	return 0;
> +}
> +
>   static void io_release_dmabuf(struct io_zcrx_mem *mem)
>   {
>   	if (!IS_ENABLED(CONFIG_DMA_SHARED_BUFFER))
> @@ -119,33 +148,10 @@ static int io_import_dmabuf(struct io_zcrx_ifq *ifq,
>   
>   static int io_zcrx_map_area_dmabuf(struct io_zcrx_ifq *ifq, struct io_zcrx_area *area)
>   {
> -	unsigned long off = area->mem.dmabuf_offset;
> -	struct scatterlist *sg;
> -	unsigned i, niov_idx = 0;
> -
>   	if (!IS_ENABLED(CONFIG_DMA_SHARED_BUFFER))
>   		return -EINVAL;
> -
> -	for_each_sgtable_dma_sg(area->mem.sgt, sg, i) {
> -		dma_addr_t dma = sg_dma_address(sg);
> -		unsigned long sg_len = sg_dma_len(sg);
> -		unsigned long sg_off = min(sg_len, off);
> -
> -		off -= sg_off;
> -		sg_len -= sg_off;
> -		dma += sg_off;
> -
> -		while (sg_len && niov_idx < area->nia.num_niovs) {
> -			struct net_iov *niov = &area->nia.niovs[niov_idx];
> -
> -			if (net_mp_niov_set_dma_addr(niov, dma))
> -				return -EFAULT;
> -			sg_len -= PAGE_SIZE;
> -			dma += PAGE_SIZE;
> -			niov_idx++;
> -		}
> -	}
> -	return 0;
> +	return io_populate_area_dma(ifq, area, area->mem.sgt,
> +				    area->mem.dmabuf_offset);
>   }
>   
>   static int io_import_umem(struct io_zcrx_ifq *ifq,

Reviewed-by: David Wei <dw@davidwei.uk>

