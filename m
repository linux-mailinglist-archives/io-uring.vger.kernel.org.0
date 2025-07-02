Return-Path: <io-uring+bounces-8593-lists+io-uring=lfdr.de@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [139.178.88.99])
	by mail.lfdr.de (Postfix) with ESMTPS id 0C73AAF661E
	for <lists+io-uring@lfdr.de>; Thu,  3 Jul 2025 01:16:53 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id BBAEF3B1BA4
	for <lists+io-uring@lfdr.de>; Wed,  2 Jul 2025 23:16:26 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 136701E1308;
	Wed,  2 Jul 2025 23:16:49 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=davidwei-uk.20230601.gappssmtp.com header.i=@davidwei-uk.20230601.gappssmtp.com header.b="m1rWnkOc"
X-Original-To: io-uring@vger.kernel.org
Received: from mail-pl1-f181.google.com (mail-pl1-f181.google.com [209.85.214.181])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 91C0D2DE709
	for <io-uring@vger.kernel.org>; Wed,  2 Jul 2025 23:16:47 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.214.181
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1751498209; cv=none; b=OWRGkYgcLx0EgkPPghJT0mNQi563UfhWa/Wzvc3xo+hR0UQEutX0bA0I2yw9w5sqAm+kUXSwhcWEtHPU467p+lyP12mimi3X65i5uF0J9vDULKOr0w5MlmZF7EZSm2kfl0ZXcV5Bv0oXkrHcPzeE4Pu2/xTY05brxn1FRVeYWxg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1751498209; c=relaxed/simple;
	bh=+UBngILyjw1KBn12Be4W8+cfCOJurYSUyGcvvlIuiRI=;
	h=Message-ID:Date:MIME-Version:Subject:To:References:From:
	 In-Reply-To:Content-Type; b=iWMj8rEpw4vcdyOPL9CeyU3rn4ylFep7BRCFw4MyeA+Pp1Cp+CGxqbkknnQqHxuGct9yXz1eMUnNt+eLUsAPWPwJEGPXszlJYP4QiboNf/ijao31gltV4mmrGWP3yhmnatQK8SmqiwrJ6PqpcP/z10xTASLcu+VAQnAm7piBXx8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=davidwei.uk; spf=none smtp.mailfrom=davidwei.uk; dkim=pass (2048-bit key) header.d=davidwei-uk.20230601.gappssmtp.com header.i=@davidwei-uk.20230601.gappssmtp.com header.b=m1rWnkOc; arc=none smtp.client-ip=209.85.214.181
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=davidwei.uk
Authentication-Results: smtp.subspace.kernel.org; spf=none smtp.mailfrom=davidwei.uk
Received: by mail-pl1-f181.google.com with SMTP id d9443c01a7336-236377f00easo60633555ad.1
        for <io-uring@vger.kernel.org>; Wed, 02 Jul 2025 16:16:47 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=davidwei-uk.20230601.gappssmtp.com; s=20230601; t=1751498207; x=1752103007; darn=vger.kernel.org;
        h=content-transfer-encoding:in-reply-to:from:content-language
         :references:to:subject:user-agent:mime-version:date:message-id:from
         :to:cc:subject:date:message-id:reply-to;
        bh=+tplfLEshqbATduLrjyckd0dU2Be9XojN5BSs4aCsko=;
        b=m1rWnkOc+acjEQFJbR5jMlYOnIPeJoEa57XJaXNuIB8SevPC7BsDnpW+d2e5BoPe75
         3DMddTWofb1w3dfiU10u6wyGSpqg+ZYpgSWWL3F8eGTA5epMWTVKIiCMAxB19cmWUiQl
         VG17Th/9mggsHzg1/Mngqwp5benJDRckMYuYjWRmeLG+8k1YngOJL0B6SBY46pUmkr/t
         KozifDfDqtSWDUwHmWOXBs54h543OlWUiVQUFdyCEpCpgudKCzg9KaQCVPX2RQdHmlPF
         Wo7A/Ae7hToHnCV1MkPtXoCaG9AC9BILy43oamrHycRolYBn3+pjxsLRYxnamaXeB0rI
         p/ig==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1751498207; x=1752103007;
        h=content-transfer-encoding:in-reply-to:from:content-language
         :references:to:subject:user-agent:mime-version:date:message-id
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=+tplfLEshqbATduLrjyckd0dU2Be9XojN5BSs4aCsko=;
        b=PsNj5apujecak0gkZxDXv4H5PPatqA//oJ9lg2rlCPnxS8JbW/nXZUnw/jWKkSxNa1
         9EhOi+YwBZfBlqzf9aB8uSW7txRVvRTz2Or0teVC9I/s3UUrdwXLvaDntctFE10QA2Lz
         fZkBhLAdMqWimj6YjoHTOZV49BctAm09rqy5xjbpJZ+AS5oIaT97B/TmgSl0H5sya7BY
         UPdMu8W/8nuP7Vxg6hwx1iQM9Cto4mGCncYO9rQNytRgjLBkBLPExrQJmAGHySpbsWlU
         n3Q5HjdfVlbUyIpzPG23clHZJszoawEb/705jyFGv1tGW1ynkOXX1Mkp/t7SIwSvqbo8
         sxlg==
X-Forwarded-Encrypted: i=1; AJvYcCVi1yUhxqKii8E18j6Rc9Y1zR1hnmDvO73IOjPvsXD/SRkPZCSq/yU3NabAtVLLaXAv2xaOP3K3OA==@vger.kernel.org
X-Gm-Message-State: AOJu0YwFtwiiwnpJDBbNboq8CPmODf2o0xtT0H10T5iVO6rm6gGRny9l
	UUPsOfDsjQUxRpIMFaFSUJ5F5tNUcqzXgYxrs2SXco28Aa+Yy+Vdf45XYBprSOD6dHaaI9cRp1v
	ZWo8Nz4g=
X-Gm-Gg: ASbGnctg4lrMtjilm2/aVJhCFfGN6RgWE+CNeX+c+xklgfVWFE3l28Kc3a/x8Dg2sR9
	76ERzIzHYUDBbfb9PE41XMZQx/g3sH1/I7cFeelrH/hsDHp7I0yHPRuQ5EyrHwOLMuqZOSuUzd2
	/TrboIfOX0+Uoui2xj5C5e76uEV4h5aeoX67t6SuUd8ufh/ebHjK7rh2bS+KQYt7qw9UWzoZdm4
	u2Lpho11/IKOZeiBo7Ki1h7iksZ38giPyg7VvsCwUyFcRYKLZxB3dTlPgnqpVLG2qC/Yyu0KelI
	KlVK93F2n9edD+A0fbxANgZO/adi2JYA1+J6JVYuy/Khv5XBj4PxNxtEz+kMQ12r+92xK3we/MA
	n/u6fMr3EnwuTupAhSEvQNnQJ
X-Google-Smtp-Source: AGHT+IGctHYY6bHrMDKBTrHKQXUs24x29U/0vyqMXuf6zMpBwJ56pE0v+IvFAXhmc81v0iZ2EUzf2Q==
X-Received: by 2002:a17:903:1208:b0:234:f182:a754 with SMTP id d9443c01a7336-23c797abddcmr14600985ad.47.1751498206812;
        Wed, 02 Jul 2025 16:16:46 -0700 (PDT)
Received: from ?IPV6:2a03:83e0:1156:1:14f8:5a41:7998:a806? ([2620:10d:c090:500::5:b65f])
        by smtp.gmail.com with ESMTPSA id d9443c01a7336-23acb2e1b49sm140480435ad.22.2025.07.02.16.16.46
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Wed, 02 Jul 2025 16:16:46 -0700 (PDT)
Message-ID: <9f81ba54-e933-479a-bd7e-4aeaf3cf78e1@davidwei.uk>
Date: Wed, 2 Jul 2025 16:16:45 -0700
Precedence: bulk
X-Mailing-List: io-uring@vger.kernel.org
List-Id: <io-uring.vger.kernel.org>
List-Subscribe: <mailto:io-uring+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:io-uring+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v4 4/6] io_uring/zcrx: allocate sgtable for umem areas
To: Pavel Begunkov <asml.silence@gmail.com>, io-uring@vger.kernel.org
References: <cover.1751466461.git.asml.silence@gmail.com>
 <f3c15081827c1bf5427d3a2e693bc526476b87ee.1751466461.git.asml.silence@gmail.com>
Content-Language: en-US
From: David Wei <dw@davidwei.uk>
In-Reply-To: <f3c15081827c1bf5427d3a2e693bc526476b87ee.1751466461.git.asml.silence@gmail.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit

On 2025-07-02 07:29, Pavel Begunkov wrote:
> Currently, dma addresses for umem areas are stored directly in niovs.
> It's memory efficient but inconvenient. I need a better format 1) to
> share code with dmabuf areas, and 2) for disentangling page, folio and
> niov sizes. dmabuf already provides sg_table, create one for user memory
> as well.
> 
> Signed-off-by: Pavel Begunkov <asml.silence@gmail.com>
> ---
>   io_uring/zcrx.c | 78 +++++++++++++++++--------------------------------
>   io_uring/zcrx.h |  1 +
>   2 files changed, 28 insertions(+), 51 deletions(-)
> 
> diff --git a/io_uring/zcrx.c b/io_uring/zcrx.c
> index cef0763010a0..fbcec06a1fb0 100644
> --- a/io_uring/zcrx.c
> +++ b/io_uring/zcrx.c
> @@ -159,7 +159,7 @@ static int io_import_umem(struct io_zcrx_ifq *ifq,
>   			  struct io_uring_zcrx_area_reg *area_reg)
>   {
>   	struct page **pages;
> -	int nr_pages;
> +	int nr_pages, ret;
>   
>   	if (area_reg->dmabuf_fd)
>   		return -EINVAL;
> @@ -170,6 +170,12 @@ static int io_import_umem(struct io_zcrx_ifq *ifq,
>   	if (IS_ERR(pages))
>   		return PTR_ERR(pages);
>   
> +	ret = sg_alloc_table_from_pages(&mem->page_sg_table, pages, nr_pages,
> +					0, nr_pages << PAGE_SHIFT,
> +					GFP_KERNEL_ACCOUNT);
> +	if (ret)
> +		return ret;
> +
>   	mem->pages = pages;
>   	mem->nr_folios = nr_pages;
>   	mem->size = area_reg->len;
> @@ -184,6 +190,7 @@ static void io_release_area_mem(struct io_zcrx_mem *mem)
>   	}
>   	if (mem->pages) {
>   		unpin_user_pages(mem->pages, mem->nr_folios);
> +		sg_free_table(&mem->page_sg_table);
>   		kvfree(mem->pages);
>   	}
>   }
> @@ -205,67 +212,36 @@ static int io_import_area(struct io_zcrx_ifq *ifq,
>   	return io_import_umem(ifq, mem, area_reg);
>   }
>   
> -static void io_zcrx_unmap_umem(struct io_zcrx_ifq *ifq,
> -				struct io_zcrx_area *area, int nr_mapped)
> -{
> -	int i;
> -
> -	for (i = 0; i < nr_mapped; i++) {
> -		netmem_ref netmem = net_iov_to_netmem(&area->nia.niovs[i]);
> -		dma_addr_t dma = page_pool_get_dma_addr_netmem(netmem);
> -
> -		dma_unmap_page_attrs(ifq->dev, dma, PAGE_SIZE,
> -				     DMA_FROM_DEVICE, IO_DMA_ATTR);
> -	}
> -}
> -
> -static void __io_zcrx_unmap_area(struct io_zcrx_ifq *ifq,
> -				 struct io_zcrx_area *area, int nr_mapped)
> +static void io_zcrx_unmap_area(struct io_zcrx_ifq *ifq,
> +				struct io_zcrx_area *area)
>   {
>   	int i;
>   
> -	if (area->mem.is_dmabuf)
> -		io_release_dmabuf(&area->mem);
> -	else
> -		io_zcrx_unmap_umem(ifq, area, nr_mapped);
> +	guard(mutex)(&ifq->dma_lock);
> +	if (!area->is_mapped)
> +		return;
> +	area->is_mapped = false;
>   
>   	for (i = 0; i < area->nia.num_niovs; i++)
>   		net_mp_niov_set_dma_addr(&area->nia.niovs[i], 0);
> -}
> -
> -static void io_zcrx_unmap_area(struct io_zcrx_ifq *ifq, struct io_zcrx_area *area)
> -{
> -	guard(mutex)(&ifq->dma_lock);
>   
> -	if (area->is_mapped)
> -		__io_zcrx_unmap_area(ifq, area, area->nia.num_niovs);
> -	area->is_mapped = false;
> +	if (area->mem.is_dmabuf) {
> +		io_release_dmabuf(&area->mem);
> +	} else {
> +		dma_unmap_sgtable(ifq->dev, &area->mem.page_sg_table,
> +				  DMA_FROM_DEVICE, IO_DMA_ATTR);
> +	}
>   }
>   
> -static int io_zcrx_map_area_umem(struct io_zcrx_ifq *ifq, struct io_zcrx_area *area)
> +static unsigned io_zcrx_map_area_umem(struct io_zcrx_ifq *ifq, struct io_zcrx_area *area)
>   {
> -	int i;
> -
> -	for (i = 0; i < area->nia.num_niovs; i++) {
> -		struct net_iov *niov = &area->nia.niovs[i];
> -		dma_addr_t dma;
> -
> -		dma = dma_map_page_attrs(ifq->dev, area->mem.pages[i], 0,
> -					 PAGE_SIZE, DMA_FROM_DEVICE, IO_DMA_ATTR);
> -		if (dma_mapping_error(ifq->dev, dma))
> -			break;
> -		if (net_mp_niov_set_dma_addr(niov, dma)) {
> -			dma_unmap_page_attrs(ifq->dev, dma, PAGE_SIZE,
> -					     DMA_FROM_DEVICE, IO_DMA_ATTR);
> -			break;
> -		}
> -	}
> +	int ret;
>   
> -	if (i != area->nia.num_niovs) {
> -		__io_zcrx_unmap_area(ifq, area, i);
> -		return -EINVAL;
> -	}
> -	return 0;
> +	ret = dma_map_sgtable(ifq->dev, &area->mem.page_sg_table,
> +				DMA_FROM_DEVICE, IO_DMA_ATTR);
> +	if (ret < 0)
> +		return ret;
> +	return io_populate_area_dma(ifq, area, &area->mem.page_sg_table, 0);
>   }
>   
>   static int io_zcrx_map_area(struct io_zcrx_ifq *ifq, struct io_zcrx_area *area)
> diff --git a/io_uring/zcrx.h b/io_uring/zcrx.h
> index 2f5e26389f22..89015b923911 100644
> --- a/io_uring/zcrx.h
> +++ b/io_uring/zcrx.h
> @@ -14,6 +14,7 @@ struct io_zcrx_mem {
>   
>   	struct page			**pages;
>   	unsigned long			nr_folios;
> +	struct sg_table			page_sg_table;
>   
>   	struct dma_buf_attachment	*attach;
>   	struct dma_buf			*dmabuf;

I looked at dma_map_sgtable() (but not too closely) and it seems to be
equivalent to the hand rolled code being deleted.

Reviewed-by: David Wei <dw@davidwei.uk>

