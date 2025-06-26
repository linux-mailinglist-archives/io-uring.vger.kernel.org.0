Return-Path: <io-uring+bounces-8496-lists+io-uring=lfdr.de@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [IPv6:2604:1380:45d1:ec00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 65BBBAE9A07
	for <lists+io-uring@lfdr.de>; Thu, 26 Jun 2025 11:31:56 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id 58DF44A75FB
	for <lists+io-uring@lfdr.de>; Thu, 26 Jun 2025 09:31:56 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id A030D2D3A80;
	Thu, 26 Jun 2025 09:30:56 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="TpuZO7nW"
X-Original-To: io-uring@vger.kernel.org
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 819812D3EE2
	for <io-uring@vger.kernel.org>; Thu, 26 Jun 2025 09:30:54 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=170.10.133.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1750930256; cv=none; b=KxVxTqWYYcCLmjMO1Labw8J9J3mNY81yuAPIjaSdLfdyRyHJkQZmL0RRATCujMCyUvMFef0XsRbmh3GE0Im+DgcDZsKsecCKvr+PESix42UfI/UxU4bnShRHlIYcDXtyWVnlfhcncnEo4dZZUOmlWeIEtmeCJ8HpxwfoGXm4h4s=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1750930256; c=relaxed/simple;
	bh=NlYhgh2AIqJTuLmshm1rBjox6vRzuD75m6NhMfZnFCs=;
	h=Message-ID:Date:MIME-Version:Subject:To:References:From:
	 In-Reply-To:Content-Type; b=EtQbgqCS85dXQ28V5JiiAFz/8Imuo8c0VIT804ppsdO8Es7yqL/jltc9diY5TZfOJDQpyMf4YtwKc/GewCNc/r7NmPFcoQoP3gQnb26/8zHSpm9xxlsAPE2xp+ckCKUKIRT6xviaPwuURv1pS+uoehWi7LId3cdg1XR4HybCFNc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=TpuZO7nW; arc=none smtp.client-ip=170.10.133.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1750930253;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:autocrypt:autocrypt;
	bh=fHEo6rHV8Y39nwTe3PJYWTBAw9VHG32naAaV6Eid8LM=;
	b=TpuZO7nW/9oKQlhyxVnp1tb5MwPNptZqmj+ZX6MCEcaRAsxnmbNB4rZG8B3ZHu/YwqNaZJ
	ugSXd8h2YwP1pyUF/mTBxYui9M9m/QYbq1bVevXfLDrlWaXKPrbNp4LrAFvbyDeeczS6k4
	n4sB3yIFSnIECs740wBy5ytE51yBKLY=
Received: from mail-wr1-f69.google.com (mail-wr1-f69.google.com
 [209.85.221.69]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-378-Lu9MjUBOM4Ko9b2KjK4Pgw-1; Thu, 26 Jun 2025 05:30:51 -0400
X-MC-Unique: Lu9MjUBOM4Ko9b2KjK4Pgw-1
X-Mimecast-MFC-AGG-ID: Lu9MjUBOM4Ko9b2KjK4Pgw_1750930250
Received: by mail-wr1-f69.google.com with SMTP id ffacd0b85a97d-3a503f28b09so451254f8f.0
        for <io-uring@vger.kernel.org>; Thu, 26 Jun 2025 02:30:50 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1750930250; x=1751535050;
        h=content-transfer-encoding:in-reply-to:organization:autocrypt:from
         :content-language:references:to:subject:user-agent:mime-version:date
         :message-id:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=fHEo6rHV8Y39nwTe3PJYWTBAw9VHG32naAaV6Eid8LM=;
        b=KZ7hBpi7Hzj5bvHOFzsfpcYVDmyT9r+N10nL6OOY6xOOr5SvZxyz+blyNYP5DTZbJF
         aeN4z0PAC+00dQQkohngs+OFnKrBd2BR/1fhb48dVXoV80YrOsl8fDo8k5kmRYGwi9B+
         yhMb+s5MvJFtzIAouzXz7PqaPNGyoB/+TdJ8s58Q/jJnZE1QKfIF3aDiDw9Pfqxzsovg
         W5mLgtYBjTnA+kmsbiOHEucVUsfTZ3p4f4uFay1gINfPqkvQSmWnqP8SnLbq2i0ofuHv
         N6lW+RY4fUj+YAmD4SDhf1tvGY2jSApFlWyf1UEM+VEEoh13OIlJs8wQc29CL2bP18Uo
         qsWw==
X-Forwarded-Encrypted: i=1; AJvYcCUaP1xg7kYgB8CH8969WP9dps4SAw6v9CYQX5GQswAamBd8LLkGXN6FwPwE26F2kyLJK8nWgDPjew==@vger.kernel.org
X-Gm-Message-State: AOJu0YzDTIlclWERIAlaC2zjY72QvrZDDsAPLhzg5BrerWZcXLM9Avtz
	zZdyNU8nTBbHKPoTc9f1F/H/9Z5vo80eFW0GvlMVFKxxP0iLfzbRQKP5e19HeqPvZPUjPTNfFwZ
	HQ9M9IPp+2j+E+jxHLZfzUMwKJdHvYo62h/XOKgzdBsNG37Vpo3Js6+rWA2fa7s5RAVqEyVs=
X-Gm-Gg: ASbGncs+RyFWLwPunfRiVPsFhKDyn9e1ZoI2klhk7BEK5xKTsg/ygwddPh7lptY0iSk
	vNodZX61YAgzIS9YuZF8sEUA33tDQ8Gl7sYJ3hfS7sw4lk+kQ6ZrOc9dKx4V+ta7BrvVza/hjFM
	5WjIjnJVtArRalVsEES7A8HwxgYsR1068E1Qz62gkwIWvqVtLZ0z0DezSwCEmCv8H4j+kUTnssS
	wMTgQ2c2c9smhNtmnv4VmtHun8KQ6PrzhWm838Xy1B4LKipIfKUJarn10j7KzOm6TqW0Mxpr3uy
	9L+9M/Ho3c8yj5qfaRCIFQ8+cBoZl9qTHMBAI94TYYS2CVW6t3lSYfFwASOZw2Yk4yOmrtF5De9
	bb3n2TX9A6FhdgJckALIt2TtLdvGjWjna7JEzRR6IyWhUij3jag==
X-Received: by 2002:a05:6000:40d9:b0:3a5:8601:613b with SMTP id ffacd0b85a97d-3a6f311b5f5mr2466763f8f.20.1750930249867;
        Thu, 26 Jun 2025 02:30:49 -0700 (PDT)
X-Google-Smtp-Source: AGHT+IHSgZcEpHqymiC/r9wCrIuS2xExCDrCPnsHrambf2EmwdKIx8ON0Dp7iCUtDpj/Rg8t7Ggnbw==
X-Received: by 2002:a05:6000:40d9:b0:3a5:8601:613b with SMTP id ffacd0b85a97d-3a6f311b5f5mr2466729f8f.20.1750930249432;
        Thu, 26 Jun 2025 02:30:49 -0700 (PDT)
Received: from ?IPV6:2003:d8:2f3c:2f00:8afc:23fe:3813:776c? (p200300d82f3c2f008afc23fe3813776c.dip0.t-ipconnect.de. [2003:d8:2f3c:2f00:8afc:23fe:3813:776c])
        by smtp.gmail.com with ESMTPSA id ffacd0b85a97d-3a6e80fed75sm7002540f8f.66.2025.06.26.02.30.48
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Thu, 26 Jun 2025 02:30:49 -0700 (PDT)
Message-ID: <76a395cc-3bbb-46ee-88d8-dcb7c18b7e4a@redhat.com>
Date: Thu, 26 Jun 2025 11:30:48 +0200
Precedence: bulk
X-Mailing-List: io-uring@vger.kernel.org
List-Id: <io-uring.vger.kernel.org>
List-Subscribe: <mailto:io-uring+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:io-uring+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v2 2/3] io_uring/rsrc: don't rely on user vaddr alignment
To: Pavel Begunkov <asml.silence@gmail.com>, io-uring@vger.kernel.org
References: <cover.1750771718.git.asml.silence@gmail.com>
 <e387b4c78b33f231105a601d84eefd8301f57954.1750771718.git.asml.silence@gmail.com>
Content-Language: en-US
From: David Hildenbrand <david@redhat.com>
Autocrypt: addr=david@redhat.com; keydata=
 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
 WNyWQQ==
Organization: Red Hat
In-Reply-To: <e387b4c78b33f231105a601d84eefd8301f57954.1750771718.git.asml.silence@gmail.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit

On 24.06.25 15:40, Pavel Begunkov wrote:
> There is no guaranteed alignment for user pointers, however the
> calculation of an offset of the first page into a folio after
> coalescing uses some weird bit mask logic, get rid of it.
> 
> Cc: stable@vger.kernel.org
> Reported-by: David Hildenbrand <david@redhat.com>
> Fixes: a8edbb424b139 ("io_uring/rsrc: enable multi-hugepage buffer coalescing")
> Signed-off-by: Pavel Begunkov <asml.silence@gmail.com>
> ---
>   io_uring/rsrc.c | 7 ++++++-
>   io_uring/rsrc.h | 1 +
>   2 files changed, 7 insertions(+), 1 deletion(-)
> 
> diff --git a/io_uring/rsrc.c b/io_uring/rsrc.c
> index e83a294c718b..8b06c732d136 100644
> --- a/io_uring/rsrc.c
> +++ b/io_uring/rsrc.c
> @@ -734,6 +734,7 @@ bool io_check_coalesce_buffer(struct page **page_array, int nr_pages,
>   
>   	data->nr_pages_mid = folio_nr_pages(folio);
>   	data->folio_shift = folio_shift(folio);
> +	data->first_folio_page_idx = folio_page_idx(folio, page_array[0]);
>   
>   	/*
>   	 * Check if pages are contiguous inside a folio, and all folios have
> @@ -830,7 +831,11 @@ static struct io_rsrc_node *io_sqe_buffer_register(struct io_ring_ctx *ctx,
>   	if (coalesced)
>   		imu->folio_shift = data.folio_shift;
>   	refcount_set(&imu->refs, 1);
> -	off = (unsigned long) iov->iov_base & ((1UL << imu->folio_shift) - 1);
> +
> +	off = (unsigned long)iov->iov_base & ~PAGE_MASK;
> +	if (coalesced)
> +		off += data.first_folio_page_idx << PAGE_SHIFT;
> +
>   	node->buf = imu;
>   	ret = 0;
>   
> diff --git a/io_uring/rsrc.h b/io_uring/rsrc.h
> index 0d2138f16322..25e7e998dcfd 100644
> --- a/io_uring/rsrc.h
> +++ b/io_uring/rsrc.h
> @@ -49,6 +49,7 @@ struct io_imu_folio_data {
>   	unsigned int	nr_pages_mid;
>   	unsigned int	folio_shift;
>   	unsigned int	nr_folios;
> +	unsigned long	first_folio_page_idx;
>   };
>   
>   bool io_rsrc_cache_init(struct io_ring_ctx *ctx);

Acked-by: David Hildenbrand <david@redhat.com>

-- 
Cheers,

David / dhildenb


