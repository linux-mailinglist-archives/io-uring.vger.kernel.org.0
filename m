Return-Path: <io-uring+bounces-2228-lists+io-uring=lfdr.de@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [IPv6:2604:1380:4601:e00::3])
	by mail.lfdr.de (Postfix) with ESMTPS id 0C83D909EF6
	for <lists+io-uring@lfdr.de>; Sun, 16 Jun 2024 20:04:44 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id F12411F2306F
	for <lists+io-uring@lfdr.de>; Sun, 16 Jun 2024 18:04:43 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 2B72F24B34;
	Sun, 16 Jun 2024 18:04:40 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="VZiikLcC"
X-Original-To: io-uring@vger.kernel.org
Received: from mail-wr1-f50.google.com (mail-wr1-f50.google.com [209.85.221.50])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 53DA31847
	for <io-uring@vger.kernel.org>; Sun, 16 Jun 2024 18:04:38 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.221.50
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1718561080; cv=none; b=iLgw5ELoXubdRRRzYpFXF/+XIsNMhW3l5SleOZbLbqoVZzxyM9AHxSjV4U3UXwmgmN2By/gT+gbaoJVD3oOJNU1j00VCrxOvTNsv85wkaKQFigKZcUVHdLut8hRAMmBwqFWIkn3f5mBlgPN+mkhO/942Hfj1gvbFXHbalOV585g=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1718561080; c=relaxed/simple;
	bh=ZpjWbXsrMIU4VNwRhIxbUz9fpku76lGdlcBj02c0rFI=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=edtsrBki8pcm+ViSo3o7ktxGLI1G4ahI3tS4fq8qj1gR/hc1JwrXCzBLqyi+fkUy0P52dbX9OveZZLc3ZZBgR9sLLRtneAzKDbl54GxvkmisMYbnTM4tAKt74Fk7YBOesCuHt4oqN2FIA9EK7UnyTl4NTn2Plw88n81OlBINw9c=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=VZiikLcC; arc=none smtp.client-ip=209.85.221.50
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Received: by mail-wr1-f50.google.com with SMTP id ffacd0b85a97d-3609565a1bdso205012f8f.1
        for <io-uring@vger.kernel.org>; Sun, 16 Jun 2024 11:04:38 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1718561076; x=1719165876; darn=vger.kernel.org;
        h=content-transfer-encoding:in-reply-to:from:content-language
         :references:cc:to:subject:user-agent:mime-version:date:message-id
         :from:to:cc:subject:date:message-id:reply-to;
        bh=UCup5tdTlwWBTV0Y3TVpbiCD+J4VO5fSS4LH8cdbu/M=;
        b=VZiikLcCaxVB3mxD3Hlk/FvvRzZyY0eildngCDAhpIjBRCu6foaH0nNc8iSEuMZ6YB
         2QlEbXLXU5HlvfHbFxU0vUrzAacFkANhAHAHHS2+XUyh46ZZIhwK+PnfcFeR06kGdaKP
         eCZC0ZpQ334AwvhIXglmTm7O2iiai4aMlgh1njjMQr/nao7yZLExXRSZT0ee4p7Tn9N2
         cu+2tJYdYs3Ve6iolSP1VQUD38/vOrhe+Yqd7evj7SU8dPb8mImBzspW41O3TGQmCYm5
         yao8clSUxjix2+X0Yy2Wnhr9lp7pvGlfLG4qHJwxPfLzfm+fCDKWF9oMtPvXk6c+lxs6
         JaRQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1718561076; x=1719165876;
        h=content-transfer-encoding:in-reply-to:from:content-language
         :references:cc:to:subject:user-agent:mime-version:date:message-id
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=UCup5tdTlwWBTV0Y3TVpbiCD+J4VO5fSS4LH8cdbu/M=;
        b=d2CVQAGbUjeSIhnzg+kJy/Alsyk8dcmr9qQqCi4vHtNaeEOS6Eem0SledQvzdzAjap
         I7ZimIY8C2qOtkWxHuPw6a8E+8haEtwYmsRj5ljH9cfL6ENIkkhMkyv2i1szdk2oMigw
         qxoPastmZ74DcVYoHXVMtChs69xeAQyx9saq6b+/HbKPNNoZIME/RnUBJiOxfY/2goyZ
         jYdT2GHBIs2tHVt73eu20GylW8asi4VaF9tHiXSM9x3b7fHXkBoZPKXj+iQraHaHlO8P
         otiPFUtNSJ6sFr4yOtQA4BDP4b6iN6IhFZ4JJ3N+tOc4vt2y9gpZ5V7q3RHA/4ePnlx6
         yVvQ==
X-Gm-Message-State: AOJu0YwiZienA2HBo+iU81EIlUjluKw8bDiuw3KL8dwlS8qKLyN+2ytb
	Pf6Mmx6DUvjkfBqJ3O1k/1hRxDfOuS6z6FVmJ60vtYH1Aj278T8N
X-Google-Smtp-Source: AGHT+IFcY3hU2Mjth9LQQZlAW8yeNGHXIobZ5VuH07B31Rr/GYmlRdDUtQP458I+oGwv50M16pBivw==
X-Received: by 2002:a5d:47ab:0:b0:35f:25db:b2bd with SMTP id ffacd0b85a97d-3607a7818a9mr7361178f8f.47.1718561076338;
        Sun, 16 Jun 2024 11:04:36 -0700 (PDT)
Received: from [192.168.42.249] ([148.252.147.74])
        by smtp.gmail.com with ESMTPSA id ffacd0b85a97d-360750ad1absm9933821f8f.62.2024.06.16.11.04.35
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Sun, 16 Jun 2024 11:04:35 -0700 (PDT)
Message-ID: <1233b470-c190-4b8f-873d-dfbf31b6874d@gmail.com>
Date: Sun, 16 Jun 2024 19:04:38 +0100
Precedence: bulk
X-Mailing-List: io-uring@vger.kernel.org
List-Id: <io-uring.vger.kernel.org>
List-Subscribe: <mailto:io-uring+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:io-uring+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v4 1/4] io_uring/rsrc: add hugepage buffer coalesce
 helpers
To: Chenliang Li <cliang01.li@samsung.com>, axboe@kernel.dk
Cc: io-uring@vger.kernel.org, peiwei.li@samsung.com, joshi.k@samsung.com,
 kundan.kumar@samsung.com, anuj20.g@samsung.com, gost.dev@samsung.com
References: <20240514075444.590910-1-cliang01.li@samsung.com>
 <CGME20240514075457epcas5p10f02f1746f957df91353724ec859664f@epcas5p1.samsung.com>
 <20240514075444.590910-2-cliang01.li@samsung.com>
Content-Language: en-US
From: Pavel Begunkov <asml.silence@gmail.com>
In-Reply-To: <20240514075444.590910-2-cliang01.li@samsung.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit

On 5/14/24 08:54, Chenliang Li wrote:
> Introduce helper functions to check whether a buffer can
> be coalesced or not, and gather folio data for later use.
> 
> The coalescing optimizes time and space consumption caused
> by mapping and storing multi-hugepage fixed buffers.
> 
> A coalescable multi-hugepage buffer should fully cover its folios
> (except potentially the first and last one), and these folios should
> have the same size. These requirements are for easier later process,
> also we need same size'd chunks in io_import_fixed for fast iov_iter
> adjust.
> 
> Signed-off-by: Chenliang Li <cliang01.li@samsung.com>
> ---
>   io_uring/rsrc.c | 78 +++++++++++++++++++++++++++++++++++++++++++++++++
>   io_uring/rsrc.h | 10 +++++++
>   2 files changed, 88 insertions(+)
> 
> diff --git a/io_uring/rsrc.c b/io_uring/rsrc.c
> index 65417c9553b1..d08224c0c5b0 100644
> --- a/io_uring/rsrc.c
> +++ b/io_uring/rsrc.c
> @@ -871,6 +871,84 @@ static int io_buffer_account_pin(struct io_ring_ctx *ctx, struct page **pages,
>   	return ret;
>   }
>   
> +static bool __io_sqe_buffer_try_coalesce(struct page **pages, int nr_pages,
> +					 struct io_imu_folio_data *data)

io_can_coalesce_buffer(), you're not actually trying to
do it here.

> +{
> +	struct folio *folio = page_folio(pages[0]);
> +	unsigned int count = 1;
> +	int i;
> +
> +	data->nr_pages_mid = folio_nr_pages(folio);
> +	if (data->nr_pages_mid == 1)
> +		return false;
> +
> +	data->folio_shift = folio_shift(folio);
> +	data->folio_size = folio_size(folio);
> +	data->nr_folios = 1;
> +	/*
> +	 * Check if pages are contiguous inside a folio, and all folios have
> +	 * the same page count except for the head and tail.
> +	 */
> +	for (i = 1; i < nr_pages; i++) {
> +		if (page_folio(pages[i]) == folio &&
> +			pages[i] == pages[i-1] + 1) {
> +			count++;
> +			continue;
> +		}
> +
> +		if (data->nr_folios == 1)
> +			data->nr_pages_head = count;
> +		else if (count != data->nr_pages_mid)
> +			return false;
> +
> +		folio = page_folio(pages[i]);
> +		if (folio_size(folio) != data->folio_size)
> +			return false;
> +
> +		count = 1;
> +		data->nr_folios++;
> +	}
> +	if (data->nr_folios == 1)
> +		data->nr_pages_head = count;
> +
> +	return true;
> +}
> +
> +static bool io_sqe_buffer_try_coalesce(struct page **pages, int nr_pages,
> +				       struct io_imu_folio_data *data)
> +{
> +	int i, j;
> +
> +	if (nr_pages <= 1 ||
> +		!__io_sqe_buffer_try_coalesce(pages, nr_pages, data))
> +		return false;
> +
> +	/*
> +	 * The pages are bound to the folio, it doesn't
> +	 * actually unpin them but drops all but one reference,
> +	 * which is usually put down by io_buffer_unmap().
> +	 * Note, needs a better helper.
> +	 */
> +	if (data->nr_pages_head > 1)
> +		unpin_user_pages(&pages[1], data->nr_pages_head - 1);

Should be pages[0]. page[1] can be in another folio, and even
though data->nr_pages_head > 1 protects against touching it,
it's still flimsy.

> +
> +	j = data->nr_pages_head;
> +	nr_pages -= data->nr_pages_head;
> +	for (i = 1; i < data->nr_folios; i++) {
> +		unsigned int nr_unpin;
> +
> +		nr_unpin = min_t(unsigned int, nr_pages - 1,
> +					data->nr_pages_mid - 1);
> +		if (nr_unpin == 0)
> +			break;
> +		unpin_user_pages(&pages[j+1], nr_unpin);

same

> +		j += data->nr_pages_mid;

And instead of duplicating this voodoo iteration later,
please just assemble a new compacted ->nr_folios sized
page array.

> +		nr_pages -= data->nr_pages_mid;
> +	}
> +
> +	return true;
> +}
> +
>   static int io_sqe_buffer_register(struct io_ring_ctx *ctx, struct iovec *iov,
>   				  struct io_mapped_ubuf **pimu,
>   				  struct page **last_hpage)
> diff --git a/io_uring/rsrc.h b/io_uring/rsrc.h
> index c032ca3436ca..b2a9d66b76dd 100644
> --- a/io_uring/rsrc.h
> +++ b/io_uring/rsrc.h
> @@ -50,6 +50,16 @@ struct io_mapped_ubuf {
>   	struct bio_vec	bvec[] __counted_by(nr_bvecs);
>   };
>   
> +struct io_imu_folio_data {
> +	/* Head folio can be partially included in the fixed buf */
> +	unsigned int	nr_pages_head;
> +	/* For non-head/tail folios, has to be fully included */
> +	unsigned int	nr_pages_mid;
> +	unsigned int	nr_folios;
> +	unsigned int	folio_shift;
> +	size_t		folio_size;
> +};
> +
>   void io_rsrc_node_ref_zero(struct io_rsrc_node *node);
>   void io_rsrc_node_destroy(struct io_ring_ctx *ctx, struct io_rsrc_node *ref_node);
>   struct io_rsrc_node *io_rsrc_node_alloc(struct io_ring_ctx *ctx);

-- 
Pavel Begunkov

