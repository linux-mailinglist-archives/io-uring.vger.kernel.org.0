Return-Path: <io-uring+bounces-2227-lists+io-uring=lfdr.de@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [147.75.80.249])
	by mail.lfdr.de (Postfix) with ESMTPS id D9081909ED7
	for <lists+io-uring@lfdr.de>; Sun, 16 Jun 2024 19:43:20 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id 68ADD1F224E7
	for <lists+io-uring@lfdr.de>; Sun, 16 Jun 2024 17:43:20 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 088261BC57;
	Sun, 16 Jun 2024 17:43:16 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="DfBcR7hf"
X-Original-To: io-uring@vger.kernel.org
Received: from mail-wm1-f48.google.com (mail-wm1-f48.google.com [209.85.128.48])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3808B2D600
	for <io-uring@vger.kernel.org>; Sun, 16 Jun 2024 17:43:13 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.128.48
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1718559795; cv=none; b=AgF5DaM8s4hYbX6YzOG11FFFxii1BcZ1SqKewyOy+P7Qz3TpaAq7zBx4pa2ONrvgbgdKuSBZ+5lx/5ftqsOdnkEE7rTDlAP2fG0QFZRwIL76E1UnZMb+EAX7HV2MvdGOj2UQIJtmiQnEnHsyTssC1WqBg6YLnFhgK1Zn3A2E3Aw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1718559795; c=relaxed/simple;
	bh=rZ6S08zYE5lfpvlQMAfFmpz+9nRy4DxLDQgqUU3COgo=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=pS8NI0SdmB+9RlmzKzVrG2/DCb08msTkS4kdC8PahbhrXHIIZT67f1Xup/aP8aC6+kQ+NZMY7AtWGox4BRLX6ym8nZcWqgSdmlIbrgbN6yWqlvBJ2kBhUCktllP6GbgHS2gyMK/7gI43gLYQ2M8PUs2SNoGC+3duzVwx5Z2vyQs=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=DfBcR7hf; arc=none smtp.client-ip=209.85.128.48
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Received: by mail-wm1-f48.google.com with SMTP id 5b1f17b1804b1-42172ed3597so22888525e9.0
        for <io-uring@vger.kernel.org>; Sun, 16 Jun 2024 10:43:13 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1718559792; x=1719164592; darn=vger.kernel.org;
        h=content-transfer-encoding:in-reply-to:from:content-language
         :references:cc:to:subject:user-agent:mime-version:date:message-id
         :from:to:cc:subject:date:message-id:reply-to;
        bh=l+S1dFVZSwRKX1ROkn2kHLT+bpXSYYzw45ciS889UK0=;
        b=DfBcR7hfckzxuFcfLZ2zPFWbK6ex8FJcAu11KO6rXYiMvpRSMXbUSSrP7fNgE9sugU
         wlWus3qdiKNYrwQ/EY2H3torFiwiUFsD3Dai6nT1cDiPGPY0vnEC60YwuXCF7iUBfDON
         /T98zPz/7y+hl1uY3Xow3GNe7zsy5KzrDKTgo/4xVjI2sEIopZ0H90fH+zipzH7ByW6u
         2Xpo4OFRY3nHwHFA/zZrmZwlVP8GjYt/WfLJ3uqcdRN/mfZ8GQRjZOqQNQXLCYJBhs0K
         +TTjNh0ZOyLRaTKGkEI3NeNnAyvP6Y3JOogadtKYpEP8vvW0VGFN6jBaTx/GHxQWjrKW
         Q5jA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1718559792; x=1719164592;
        h=content-transfer-encoding:in-reply-to:from:content-language
         :references:cc:to:subject:user-agent:mime-version:date:message-id
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=l+S1dFVZSwRKX1ROkn2kHLT+bpXSYYzw45ciS889UK0=;
        b=dyOdg4pUi6LiRep318fJREthU/eZnV2Jljpsuv3V+16krJL7yEqpwgOGbwUZjtF5nl
         jcqKK4Y0JwAakQtVPM5PlImUDglkYvluP7DbamwMFCO7SiuIPz264rBn7Ktpe11SJOvQ
         p3D9mPzBwkvGK9lK19rLJahV0H+KEMGoCuOp8zi1llkXCe/ctMsVYp3MTF97D99+RBWO
         0Xe5kRgwcsVsH+QtF8OZn+9jWs8HZg9GG8YMmE6ZLMlg1bcDBDq8SC9HvH+5LJYBYDZ+
         7LGDMlKkqYagcpr+FPX7Miiln4Q5RoQQY0GsJ9tneUQSnUHe/u9dnT7OsOyPdPP9wdKA
         iKZw==
X-Gm-Message-State: AOJu0YwKVbfQBFhWZDX7LnwV9Jp+4xrcSHupued3TmCMEbUeCjGg+Q/y
	tmJhl5LZFve5/1B7c5mR1wSRi9RHgXTd9zgKIp8yqNoWgBm3ancJiyJUXA==
X-Google-Smtp-Source: AGHT+IH9vnPwjPMckn2hBUrE6hXhPgWgeNs6fUEamaLu3mjL1oEt1rTmQeEMm6hC7ctuz57JI7re4g==
X-Received: by 2002:a05:600c:4506:b0:421:392b:7e13 with SMTP id 5b1f17b1804b1-422b6dc80c2mr117006335e9.4.1718559792197;
        Sun, 16 Jun 2024 10:43:12 -0700 (PDT)
Received: from [192.168.42.249] ([148.252.147.74])
        by smtp.gmail.com with ESMTPSA id 5b1f17b1804b1-4229447eaa5sm168671105e9.48.2024.06.16.10.43.11
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Sun, 16 Jun 2024 10:43:11 -0700 (PDT)
Message-ID: <bc9ae109-090c-4669-9be1-11ed6a6d39aa@gmail.com>
Date: Sun, 16 Jun 2024 18:43:13 +0100
Precedence: bulk
X-Mailing-List: io-uring@vger.kernel.org
List-Id: <io-uring.vger.kernel.org>
List-Subscribe: <mailto:io-uring+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:io-uring+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v4 3/4] io_uring/rsrc: add init and account functions for
 coalesced imus
To: Chenliang Li <cliang01.li@samsung.com>, axboe@kernel.dk
Cc: io-uring@vger.kernel.org, peiwei.li@samsung.com, joshi.k@samsung.com,
 kundan.kumar@samsung.com, anuj20.g@samsung.com, gost.dev@samsung.com
References: <20240514075444.590910-1-cliang01.li@samsung.com>
 <CGME20240514075500epcas5p1e638b1ae84727b3669ff6b780cd1cb23@epcas5p1.samsung.com>
 <20240514075444.590910-4-cliang01.li@samsung.com>
Content-Language: en-US
From: Pavel Begunkov <asml.silence@gmail.com>
In-Reply-To: <20240514075444.590910-4-cliang01.li@samsung.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit

On 5/14/24 08:54, Chenliang Li wrote:
> Introduce two functions to separate the coalesced imu alloc and
> accounting path from the original one. This helps to keep the original
> code path clean.
> 
> Signed-off-by: Chenliang Li <cliang01.li@samsung.com>
> ---
>   io_uring/rsrc.c | 89 +++++++++++++++++++++++++++++++++++++++++++++++++
>   1 file changed, 89 insertions(+)
> 
> diff --git a/io_uring/rsrc.c b/io_uring/rsrc.c
> index 578d382ca9bc..53fac5f27bbf 100644
> --- a/io_uring/rsrc.c
> +++ b/io_uring/rsrc.c
> @@ -871,6 +871,45 @@ static int io_buffer_account_pin(struct io_ring_ctx *ctx, struct page **pages,
>   	return ret;
>   }
>   
> +static int io_coalesced_buffer_account_pin(struct io_ring_ctx *ctx,
> +					   struct page **pages,
> +					   struct io_mapped_ubuf *imu,
> +					   struct page **last_hpage,
> +					   struct io_imu_folio_data *data)
> +{
> +	int i, j, ret;
> +
> +	imu->acct_pages = 0;
> +	j = 0;
> +	for (i = 0; i < data->nr_folios; i++) {
> +		struct page *hpage = pages[j];
> +
> +		if (hpage == *last_hpage)
> +			continue;
> +		*last_hpage = hpage;
> +		/*
> +		 * Already checked the page array in try coalesce,
> +		 * so pass in nr_pages=0 here to waive that.
> +		 */
> +		if (headpage_already_acct(ctx, pages, 0, hpage))
> +			continue;
> +		imu->acct_pages += data->nr_pages_mid;
> +		if (i)
> +			j += data->nr_pages_mid;
> +		else
> +			j = data->nr_pages_head;

You should account an entire folio here, i.e. ->nr_pages_mid
in either case. Let's say the first page in the registration
is the last page of a huge page, you'd account 4K while it
actually pins the entire huge page size.
It seems like you can just call io_buffer_account_pin()
instead.

On that note, you shouldn't duplicate code in either case,
just treat the normal discontig pages case as folios of
shift=PAGE_SHIFT.

Either just plain reuse or adjust io_buffer_account_pin()
instead of io_coalesced_buffer_account_pin().
io_coalesced_imu_alloc() should also go away.

io_sqe_buffer_register() {
	struct io_imu_folio_data data;

	if (!io_sqe_buffer_try_coalesce(pages, folio_data)) {
		folio_data.shift = PAGE_SHIFT;
		...
	}
	
	io_buffer_account_pin(pages, &data);
	imu->data = uaddr;
	...
}

> +	}
> +
> +	if (!imu->acct_pages)
> +		return 0;
> +
> +	ret = io_account_mem(ctx, imu->acct_pages);
> +	if (!ret)
> +		return 0;
> +	imu->acct_pages = 0;
> +	return ret;
> +}
> +
>   static bool __io_sqe_buffer_try_coalesce(struct page **pages, int nr_pages,
>   					 struct io_imu_folio_data *data)
>   {
> @@ -949,6 +988,56 @@ static bool io_sqe_buffer_try_coalesce(struct page **pages, int nr_pages,
>   	return true;
>   }
>   
> +static int io_coalesced_imu_alloc(struct io_ring_ctx *ctx, struct iovec *iov,
> +				  struct io_mapped_ubuf **pimu,
> +				  struct page **last_hpage, struct page **pages,
> +				  struct io_imu_folio_data *data)
> +{
> +	struct io_mapped_ubuf *imu = NULL;
> +	unsigned long off;
> +	size_t size, vec_len;
> +	int ret, i, j;
> +
> +	ret = -ENOMEM;
> +	imu = kvmalloc(struct_size(imu, bvec, data->nr_folios), GFP_KERNEL);
> +	if (!imu)
> +		return ret;
> +
> +	ret = io_coalesced_buffer_account_pin(ctx, pages, imu, last_hpage,
> +						data);
> +	if (ret) {
> +		unpin_user_page(pages[0]);
> +		j = data->nr_pages_head;
> +		for (i = 1; i < data->nr_folios; i++) {
> +			unpin_user_page(pages[j]);
> +			j += data->nr_pages_mid;
> +		}
> +		return ret;
> +	}
> +	off = (unsigned long) iov->iov_base & ~PAGE_MASK;
> +	size = iov->iov_len;
> +	/* store original address for later verification */
> +	imu->ubuf = (unsigned long) iov->iov_base;
> +	imu->ubuf_end = imu->ubuf + iov->iov_len;
> +	imu->nr_bvecs = data->nr_folios;
> +	imu->folio_shift = data->folio_shift;
> +	imu->folio_mask = ~((1UL << data->folio_shift) - 1);
> +	*pimu = imu;
> +	ret = 0;
> +
> +	vec_len = min_t(size_t, size, PAGE_SIZE * data->nr_pages_head - off);
> +	bvec_set_page(&imu->bvec[0], pages[0], vec_len, off);
> +	size -= vec_len;
> +	j = data->nr_pages_head;
> +	for (i = 1; i < data->nr_folios; i++) {
> +		vec_len = min_t(size_t, size, data->folio_size);
> +		bvec_set_page(&imu->bvec[i], pages[j], vec_len, 0);
> +		size -= vec_len;
> +		j += data->nr_pages_mid;
> +	}
> +	return ret;
> +}
> +
>   static int io_sqe_buffer_register(struct io_ring_ctx *ctx, struct iovec *iov,
>   				  struct io_mapped_ubuf **pimu,
>   				  struct page **last_hpage)

-- 
Pavel Begunkov

