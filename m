Return-Path: <io-uring+bounces-2470-lists+io-uring=lfdr.de@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [147.75.80.249])
	by mail.lfdr.de (Postfix) with ESMTPS id EFC3292BAD2
	for <lists+io-uring@lfdr.de>; Tue,  9 Jul 2024 15:17:49 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id 7F2401F25E77
	for <lists+io-uring@lfdr.de>; Tue,  9 Jul 2024 13:17:49 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id BF433156C73;
	Tue,  9 Jul 2024 13:17:45 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="Web4Ui/q"
X-Original-To: io-uring@vger.kernel.org
Received: from mail-ej1-f44.google.com (mail-ej1-f44.google.com [209.85.218.44])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id DF220382
	for <io-uring@vger.kernel.org>; Tue,  9 Jul 2024 13:17:43 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.218.44
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1720531065; cv=none; b=nvhjbAXK1ITQZ70wTrMzR2j/WnzXMu114gkx/5xTluvgW4k5sZgxg7xTsc1Woh3TqJKQ2qFWECEkb3A4T5JyMPQ3zdOoZTWULO7a1xNP+VxciMwZClS54vvPULv5/RT+3WkjAYgS8N1s+o1p6C4U4t3cg+IvRZSJwBlN4O5/n6E=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1720531065; c=relaxed/simple;
	bh=r386Bu2KV5C7xQnJp0eNNp55hZ3hvW5ONBA9sob6Exc=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=LC0fD1MoeZBTGKDdjz4Nmt31Vi5Qk+E7r21J2UmS2dN4gW9qs4ZLi408CgbcW8K8M7U4d0GxdmIfFPiXhLTiWMU+B9s5DNgjiIVqEFqokB0bLiJfR4acgdanse0e2r+1feGgkgWm9NxyvrqFxZPRIG+7h2XTpAryiipdSMx/yOc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=Web4Ui/q; arc=none smtp.client-ip=209.85.218.44
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Received: by mail-ej1-f44.google.com with SMTP id a640c23a62f3a-a77c9c5d68bso486081466b.2
        for <io-uring@vger.kernel.org>; Tue, 09 Jul 2024 06:17:43 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1720531062; x=1721135862; darn=vger.kernel.org;
        h=content-transfer-encoding:in-reply-to:from:content-language
         :references:cc:to:subject:user-agent:mime-version:date:message-id
         :from:to:cc:subject:date:message-id:reply-to;
        bh=6tvhKnkuT5X2fMddMn/UBzTLURYvympotSW5e3rfMXg=;
        b=Web4Ui/qmnEQqPNcoMftzRBtVMOoKntmOjPMRUfPR/YWpXgFc2zKZHd0SAeMQzcdBM
         BOQ1hTdARfEp6bhjrE0hoY+fkGr/Ez1OeEp3DHHcYaLAVwHViGEyptGnO8xTv9W2xSu8
         Ra7o5ZhC0G6yNKxgvVjUTp5zOvgmNgYWNXWgWtra9Neb5EWxluVxbxsw6OBiE8dCpOrT
         ffVnx7F0ynZhXPzgIEkwzW2YZFDtQRflG8nr9cKoTfZvPb6UBNpegu+J+HCGU3gHX7N8
         /uRsZ5tQ+oM75BXzP+dpDz7bjdgDTLskAkOXRhcxYpKDUqJgtCdBInPWVmhmmEyjGVsM
         hjpg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1720531062; x=1721135862;
        h=content-transfer-encoding:in-reply-to:from:content-language
         :references:cc:to:subject:user-agent:mime-version:date:message-id
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=6tvhKnkuT5X2fMddMn/UBzTLURYvympotSW5e3rfMXg=;
        b=PBNkgzflInHSnUfUrs7DPn7qwkzNQl6lgqj2c8dAvqa9QC5pCytikyUzfcO2j+iEvd
         Eb8j9XK0PkXjugjeGHBYTW2ajlZLyLs2V4pGhZpW8lTWXHhxJF313dN07I9+I+jSKYKa
         xrrwqYNG19L3iPogzswkreyfIP6B+JdAXhA4cwgIVYFFiAdNGH62q5a3hoCgkSDTHadj
         Blm1sJJ9iTvhms3+vNUdxf653H+alb/RojHyEJ0v6iEKzRbzt5pe1wlhoNwRssmtUP69
         mEVnsi4Yv4/SuYP2SRjLgoIX42plTTSh9+mz9kAfESB5KqblB3IMi7lfSxwFrL+fbSbY
         yWzQ==
X-Gm-Message-State: AOJu0Yx+zrEGTMM2FnkOl+J5UZ5WYz7mPch8LAep58FobfYFjaHRnlGt
	e9QVqkvyGO0d5b3aylNRrbjSd+7xRv4gQ8WFzKxYu48djcbQpDva
X-Google-Smtp-Source: AGHT+IFmahtwAipDVxjrhPPrPmI5WvSBHPihqsDT5/JNckNicuq99bQlFNw0F+m73kNFBgU3ueHoTg==
X-Received: by 2002:a17:907:7e94:b0:a77:a529:4457 with SMTP id a640c23a62f3a-a780b6b3611mr221429766b.25.1720531061803;
        Tue, 09 Jul 2024 06:17:41 -0700 (PDT)
Received: from [192.168.42.197] ([163.114.131.193])
        by smtp.gmail.com with ESMTPSA id a640c23a62f3a-a780a872002sm76555166b.211.2024.07.09.06.17.41
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Tue, 09 Jul 2024 06:17:41 -0700 (PDT)
Message-ID: <4e6d1195-3073-401c-91ad-a1f3adc45a77@gmail.com>
Date: Tue, 9 Jul 2024 14:17:50 +0100
Precedence: bulk
X-Mailing-List: io-uring@vger.kernel.org
List-Id: <io-uring.vger.kernel.org>
List-Subscribe: <mailto:io-uring+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:io-uring+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v5 3/3] io_uring/rsrc: enable multi-hugepage buffer
 coalescing
To: Chenliang Li <cliang01.li@samsung.com>, axboe@kernel.dk
Cc: io-uring@vger.kernel.org, peiwei.li@samsung.com, joshi.k@samsung.com,
 kundan.kumar@samsung.com, anuj20.g@samsung.com, gost.dev@samsung.com
References: <20240628084411.2371-1-cliang01.li@samsung.com>
 <CGME20240628084424epcas5p3c34ec2fb8fb45752ef6a11447812ae0d@epcas5p3.samsung.com>
 <20240628084411.2371-4-cliang01.li@samsung.com>
Content-Language: en-US
From: Pavel Begunkov <asml.silence@gmail.com>
In-Reply-To: <20240628084411.2371-4-cliang01.li@samsung.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit

On 6/28/24 09:44, Chenliang Li wrote:
> Modify io_sqe_buffer_register to enable the coalescing for
> multi-hugepage fixed buffers.
> 
> Signed-off-by: Chenliang Li <cliang01.li@samsung.com>
> ---
>   io_uring/rsrc.c | 47 ++++++++++++++++-------------------------------
>   1 file changed, 16 insertions(+), 31 deletions(-)
> 
> diff --git a/io_uring/rsrc.c b/io_uring/rsrc.c
> index 3198cf854db1..790ed3c1bcc8 100644
> --- a/io_uring/rsrc.c
> +++ b/io_uring/rsrc.c
> @@ -945,7 +945,8 @@ static int io_sqe_buffer_register(struct io_ring_ctx *ctx, struct iovec *iov,
>   	unsigned long off;
>   	size_t size;
>   	int ret, nr_pages, i;
> -	struct folio *folio = NULL;
> +	struct io_imu_folio_data data;
> +	bool coalesced;
>   
>   	*pimu = (struct io_mapped_ubuf *)&dummy_ubuf;
>   	if (!iov->iov_base)
> @@ -960,31 +961,8 @@ static int io_sqe_buffer_register(struct io_ring_ctx *ctx, struct iovec *iov,
>   		goto done;
>   	}
>   
> -	/* If it's a huge page, try to coalesce them into a single bvec entry */
> -	if (nr_pages > 1) {
> -		folio = page_folio(pages[0]);
> -		for (i = 1; i < nr_pages; i++) {
> -			/*
> -			 * Pages must be consecutive and on the same folio for
> -			 * this to work
> -			 */
> -			if (page_folio(pages[i]) != folio ||
> -			    pages[i] != pages[i - 1] + 1) {
> -				folio = NULL;
> -				break;
> -			}
> -		}
> -		if (folio) {
> -			/*
> -			 * The pages are bound to the folio, it doesn't
> -			 * actually unpin them but drops all but one reference,
> -			 * which is usually put down by io_buffer_unmap().
> -			 * Note, needs a better helper.
> -			 */
> -			unpin_user_pages(&pages[1], nr_pages - 1);
> -			nr_pages = 1;
> -		}
> -	}
> +	/* If it's huge page(s), try to coalesce them into fewer bvec entries */
> +	coalesced = io_try_coalesce_buffer(&pages, &nr_pages, &data);
>   
>   	imu = kvmalloc(struct_size(imu, bvec, nr_pages), GFP_KERNEL);
>   	if (!imu)
> @@ -1004,17 +982,24 @@ static int io_sqe_buffer_register(struct io_ring_ctx *ctx, struct iovec *iov,
>   	imu->nr_bvecs = nr_pages;
>   	imu->folio_shift = PAGE_SHIFT;
>   	imu->folio_mask = PAGE_MASK;
> +	if (coalesced) {
> +		imu->folio_shift = data.folio_shift;
> +		imu->folio_mask = ~((1UL << data.folio_shift) - 1);
> +	}
>   	*pimu = imu;
>   	ret = 0;
>   
> -	if (folio) {
> -		bvec_set_page(&imu->bvec[0], pages[0], size, off);
> -		goto done;
> -	}
>   	for (i = 0; i < nr_pages; i++) {
>   		size_t vec_len;
>   
> -		vec_len = min_t(size_t, size, PAGE_SIZE - off);
> +		if (coalesced) {
> +			size_t seg_size = i ? data.folio_size :
> +				PAGE_SIZE * data.nr_pages_head;

When you're compacting the page array, instead of taking a middle
page for the first folio, you can set it to the first page in the
folio and fix up the offset. Kind of:

new_array[0] = compound_head(old_array[0]);
off += folio_page_idx(folio, old_array[0]) << PAGE_SHIFT;


With that change you should be able to treat it in a uniform way
without branching.

off = (unsigned long) iov->iov_base & ~folio_mask;
vec_len = min_t(size_t, size, folio_size - off);


> +
> +			vec_len = min_t(size_t, size, seg_size - off);
> +		} else {
> +			vec_len = min_t(size_t, size, PAGE_SIZE - off);
> +		}
>   		bvec_set_page(&imu->bvec[i], pages[i], vec_len, off);
>   		off = 0;
>   		size -= vec_len;

-- 
Pavel Begunkov

