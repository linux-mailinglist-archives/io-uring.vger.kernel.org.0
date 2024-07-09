Return-Path: <io-uring+bounces-2469-lists+io-uring=lfdr.de@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [IPv6:2604:1380:4601:e00::3])
	by mail.lfdr.de (Postfix) with ESMTPS id 259C592BAB0
	for <lists+io-uring@lfdr.de>; Tue,  9 Jul 2024 15:10:13 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id 937AD1F21FEB
	for <lists+io-uring@lfdr.de>; Tue,  9 Jul 2024 13:10:12 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 85D6915699E;
	Tue,  9 Jul 2024 13:09:07 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="Jo9+lG6P"
X-Original-To: io-uring@vger.kernel.org
Received: from mail-ej1-f52.google.com (mail-ej1-f52.google.com [209.85.218.52])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A70F4161936
	for <io-uring@vger.kernel.org>; Tue,  9 Jul 2024 13:09:05 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.218.52
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1720530547; cv=none; b=Ez9AKCaZGAKmOjYo/6x9dqDZ5/kpuigcLuJQot73taxEufz22BLKj9Z5/RyIiODjeW5MBSR1OCvwPxqsJFlrSWDeTIDSciJPW0E30Lgua0SIZOn/UGv9wwjQLt/wpTpwMBpjRQTzq8XxtPEr6JaUreBkz3qJEqvd1P9Spt5vD54=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1720530547; c=relaxed/simple;
	bh=MFDkzDl8sN/LKE4vYOsqFY2OpI9WfwI8lLUYaTz3VUM=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=W6Jw440w9d0f0Agxq9Ilba3v/ySktcLgA1rv101A/coIGrdvzWo1iIrsM1mgoLf5+MC1mq4xbil9yHd4hlJWt561SLgx2uRlYHzWTF77TY0QdVi6DSxZ8nidCEQTQ6E75b8JJcnVeJyqIAzmJIuekBnudcP2YPisxzCEGGg75oY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=Jo9+lG6P; arc=none smtp.client-ip=209.85.218.52
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Received: by mail-ej1-f52.google.com with SMTP id a640c23a62f3a-a77b550128dso641788166b.0
        for <io-uring@vger.kernel.org>; Tue, 09 Jul 2024 06:09:05 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1720530544; x=1721135344; darn=vger.kernel.org;
        h=content-transfer-encoding:in-reply-to:from:content-language
         :references:cc:to:subject:user-agent:mime-version:date:message-id
         :from:to:cc:subject:date:message-id:reply-to;
        bh=+bUULStyY3rdWe1Joe+BLAARKQOAymCPb0HGFy/OwWM=;
        b=Jo9+lG6PzEaI/qcSOV1Ar6Exy3xGhnRJVQoiMoJ1J8lg/0rbgpIV6IBlNOc+ZBSovA
         kLoEdJqvgmm1sBI7nQW2fKnUNN0r8AhcI1j4Cjk/jitLZc07C0Lz8tvlJrFxwyfgV04f
         4AqzmejZjUCO5vUHwUaLz1s6DzwkqAhNpKE0s+NqJZUn9Qz2qH+ON/ZHGTmn/2ID3g98
         /TtOipsn1tD++E4pfqkUZ2LyLSWo0HOLx5RGgH94Fm1jTkWbJnxxGPkYSc01qMWvJigE
         0OCE8las+NSGYOLp9LjuCUt8Vb9kYU3EUaE46UD1Ay4HJcbNlf+tDsDnID/Qm4gpkyVO
         4G3Q==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1720530544; x=1721135344;
        h=content-transfer-encoding:in-reply-to:from:content-language
         :references:cc:to:subject:user-agent:mime-version:date:message-id
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=+bUULStyY3rdWe1Joe+BLAARKQOAymCPb0HGFy/OwWM=;
        b=cnHdvpmiSnFeIXknUS1xiPZP5X4jcDxkp/jF4FoLY0KtkjS2QGw9iaVYHImHk+uyyH
         nV0l/US0+xkS+SmuOenGlKcaql6+rXTh6T9A5BvpbxVQjPE1PuRk+HzghamvnI9Di0yY
         2AzyNzzAmS/NgtQ2bukR636kfwyKUHvtDvZv54aBsUEeW/S1qsT3zSbwRzbX/zsyFNyz
         sWCn4Nhx6clCp7iac4dgAC4VZBvg07y9jVk8qcgMk8kuIpkNosMDhKLrhc7IhiB4AlHh
         3UOPQj88Z0IdmXWcs/qgOS/zlMU1aLKiMr0FGLalGgxewsmYTd/FqyJmGEXKwOis82Qe
         iNkg==
X-Gm-Message-State: AOJu0YwAvFX2rDwlKX26031A0Zlm++bv9D6pkrbkmmuY69W8YJTHb/zM
	bA0L9POb3dn7Ck5aDrZND8xDxXMIIcMWsd4dpzyjMdwS/pr5FIOvNCOZXQ==
X-Google-Smtp-Source: AGHT+IG83PtOV8EPKIibTADf8CcxsY/kn4FQNXCs8VM7oJIyvVMTseNaCoIPZgmImLuFjbLLiqDr9w==
X-Received: by 2002:a17:906:6c93:b0:a72:6e13:a4b6 with SMTP id a640c23a62f3a-a780b88276bmr182336466b.58.1720530543642;
        Tue, 09 Jul 2024 06:09:03 -0700 (PDT)
Received: from [192.168.42.197] ([163.114.131.193])
        by smtp.gmail.com with ESMTPSA id a640c23a62f3a-a780a7ff24esm76208766b.131.2024.07.09.06.09.03
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Tue, 09 Jul 2024 06:09:03 -0700 (PDT)
Message-ID: <e7bfaafa-f890-4e5e-a9b2-95787c60473c@gmail.com>
Date: Tue, 9 Jul 2024 14:09:12 +0100
Precedence: bulk
X-Mailing-List: io-uring@vger.kernel.org
List-Id: <io-uring.vger.kernel.org>
List-Subscribe: <mailto:io-uring+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:io-uring+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v5 1/3] io_uring/rsrc: add hugepage fixed buffer coalesce
 helpers
To: Chenliang Li <cliang01.li@samsung.com>, axboe@kernel.dk
Cc: io-uring@vger.kernel.org, peiwei.li@samsung.com, joshi.k@samsung.com,
 kundan.kumar@samsung.com, anuj20.g@samsung.com, gost.dev@samsung.com
References: <20240628084411.2371-1-cliang01.li@samsung.com>
 <CGME20240628084420epcas5p32f49e7c977695d20bcef7734eb2e38b4@epcas5p3.samsung.com>
 <20240628084411.2371-2-cliang01.li@samsung.com>
Content-Language: en-US
From: Pavel Begunkov <asml.silence@gmail.com>
In-Reply-To: <20240628084411.2371-2-cliang01.li@samsung.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit

On 6/28/24 09:44, Chenliang Li wrote:
> Introduce helper functions to check and coalesce hugepage-backed fixed
> buffers. The coalescing optimizes both time and space consumption caused
> by mapping and storing multi-hugepage fixed buffers. Currently we only
> have single-hugepage buffer coalescing, so add support for multi-hugepage
> fixed buffer coalescing.
> 
> A coalescable multi-hugepage buffer should fully cover its folios
> (except potentially the first and last one), and these folios should
> have the same size. These requirements are for easier processing later,
> also we need same size'd chunks in io_import_fixed for fast iov_iter
> adjust.
> 
> Signed-off-by: Chenliang Li <cliang01.li@samsung.com>
> ---
>   io_uring/rsrc.c | 87 +++++++++++++++++++++++++++++++++++++++++++++++++
>   io_uring/rsrc.h |  9 +++++
>   2 files changed, 96 insertions(+)
> 
> diff --git a/io_uring/rsrc.c b/io_uring/rsrc.c
> index 60c00144471a..c88ce8c38515 100644
> --- a/io_uring/rsrc.c
> +++ b/io_uring/rsrc.c
> @@ -849,6 +849,93 @@ static int io_buffer_account_pin(struct io_ring_ctx *ctx, struct page **pages,
>   	return ret;
>   }
>   
> +static bool io_do_coalesce_buffer(struct page ***pages, int *nr_pages,
> +				struct io_imu_folio_data *data, int nr_folios)
> +{
> +	struct page **page_array = *pages, **new_array = NULL;
> +	int nr_pages_left = *nr_pages, i, j;
> +
> +	/* Store head pages only*/
> +	new_array = kvmalloc_array(nr_folios, sizeof(struct page *),
> +					GFP_KERNEL);
> +	if (!new_array)
> +		return false;
> +
> +	new_array[0] = page_array[0];
> +	/*
> +	 * The pages are bound to the folio, it doesn't
> +	 * actually unpin them but drops all but one reference,
> +	 * which is usually put down by io_buffer_unmap().
> +	 * Note, needs a better helper.
> +	 */
> +	if (data->nr_pages_head > 1)
> +		unpin_user_pages(&page_array[1], data->nr_pages_head - 1);
> +
> +	j = data->nr_pages_head;
> +	nr_pages_left -= data->nr_pages_head;
> +	for (i = 1; i < nr_folios; i++) {
> +		unsigned int nr_unpin;
> +
> +		new_array[i] = page_array[j];
> +		nr_unpin = min_t(unsigned int, nr_pages_left - 1,
> +					data->nr_pages_mid - 1);
> +		if (nr_unpin)
> +			unpin_user_pages(&page_array[j+1], nr_unpin);
> +		j += data->nr_pages_mid;
> +		nr_pages_left -= data->nr_pages_mid;
> +	}
> +	kvfree(page_array);
> +	*pages = new_array;
> +	*nr_pages = nr_folios;
> +	return true;
> +}
> +
> +static bool io_try_coalesce_buffer(struct page ***pages, int *nr_pages,
> +					 struct io_imu_folio_data *data)

I believe unused static function will trigger a warning, we don't
want that, especially since error on warn is a thing.

You can either reshuffle patches or at least add a
__maybe_unused attribute.


> +{
> +	struct page **page_array = *pages;
> +	struct folio *folio = page_folio(page_array[0]);
> +	unsigned int count = 1, nr_folios = 1;
> +	int i;
> +
> +	if (*nr_pages <= 1)
> +		return false;
> +
> +	data->nr_pages_mid = folio_nr_pages(folio);
> +	if (data->nr_pages_mid == 1)
> +		return false;
> +
> +	data->folio_shift = folio_shift(folio);
> +	data->folio_size = folio_size(folio);
> +	/*
> +	 * Check if pages are contiguous inside a folio, and all folios have
> +	 * the same page count except for the head and tail.
> +	 */
> +	for (i = 1; i < *nr_pages; i++) {
> +		if (page_folio(page_array[i]) == folio &&
> +			page_array[i] == page_array[i-1] + 1) {
> +			count++;
> +			continue;
> +		}

Seems like the first and last folios can be not border aligned,
i.e. the first should end at the folio_size boundary, and the
last one should start at the beginning of the folio.

Not really a bug, but we might get some problems with optimising
calculations down the road if we don't restrict it.

> +
> +		if (nr_folios == 1)
> +			data->nr_pages_head = count;
> +		else if (count != data->nr_pages_mid)
> +			return false;
> +
> +		folio = page_folio(page_array[i]);
> +		if (folio_size(folio) != data->folio_size)
> +			return false;
> +
> +		count = 1;
> +		nr_folios++;
> +	}
> +	if (nr_folios == 1)
> +		data->nr_pages_head = count;
> +
> +	return io_do_coalesce_buffer(pages, nr_pages, data, nr_folios);
> +}
> +
>   static int io_sqe_buffer_register(struct io_ring_ctx *ctx, struct iovec *iov,
>   				  struct io_mapped_ubuf **pimu,
>   				  struct page **last_hpage)
> diff --git a/io_uring/rsrc.h b/io_uring/rsrc.h
> index c032ca3436ca..cc66323535f6 100644
> --- a/io_uring/rsrc.h
> +++ b/io_uring/rsrc.h
> @@ -50,6 +50,15 @@ struct io_mapped_ubuf {
>   	struct bio_vec	bvec[] __counted_by(nr_bvecs);
>   };
>   
> +struct io_imu_folio_data {
> +	/* Head folio can be partially included in the fixed buf */
> +	unsigned int	nr_pages_head;
> +	/* For non-head/tail folios, has to be fully included */
> +	unsigned int	nr_pages_mid;
> +	unsigned int	folio_shift;
> +	size_t		folio_size;
> +};
> +
>   void io_rsrc_node_ref_zero(struct io_rsrc_node *node);
>   void io_rsrc_node_destroy(struct io_ring_ctx *ctx, struct io_rsrc_node *ref_node);
>   struct io_rsrc_node *io_rsrc_node_alloc(struct io_ring_ctx *ctx);

-- 
Pavel Begunkov

