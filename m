Return-Path: <io-uring+bounces-2538-lists+io-uring=lfdr.de@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [IPv6:2604:1380:4601:e00::3])
	by mail.lfdr.de (Postfix) with ESMTPS id 63EA6938FB0
	for <lists+io-uring@lfdr.de>; Mon, 22 Jul 2024 15:12:30 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id D81501F21E43
	for <lists+io-uring@lfdr.de>; Mon, 22 Jul 2024 13:12:29 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id D946D16D312;
	Mon, 22 Jul 2024 13:12:24 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="TlMR7wl4"
X-Original-To: io-uring@vger.kernel.org
Received: from mail-ej1-f48.google.com (mail-ej1-f48.google.com [209.85.218.48])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4212816C86C
	for <io-uring@vger.kernel.org>; Mon, 22 Jul 2024 13:12:23 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.218.48
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1721653944; cv=none; b=hYDH6IfRcjm5Hc4/I4czpGnnWP0LieW075hIzsVN90JuXlpJGOrV+PoHeoMqYUOA2ApAVA23D7G8E3Ms/RHJ8knPsIIUL08/TlLumpTfyB9B4KVbsGMGE0tbVYVo42oNjpP0ncWrH1tPIbXy1AgzhnFv9/aJSMyJwPtm89xWyoE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1721653944; c=relaxed/simple;
	bh=ZDpW46zYYmcXYXi1gs6sVxILHI+ntzVjWJUY4JL4vXg=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=ffPEnEDEGY/NXDw050ELUH8aCNoh0BHVMVG1WFCa2ZoDQOqY/x9erdxJWSygrWRvVYvaydbAVxEoz4+W+x901O32WfuPf3D7k4V6b4i3cFfsX6VijvHISqCghYYhNdE3XohXF6bP07iPMZ1Zf3nY2ze6nI/1y77o+X0E3UUl3mQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=TlMR7wl4; arc=none smtp.client-ip=209.85.218.48
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Received: by mail-ej1-f48.google.com with SMTP id a640c23a62f3a-a77d85f7fa3so689933266b.0
        for <io-uring@vger.kernel.org>; Mon, 22 Jul 2024 06:12:23 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1721653942; x=1722258742; darn=vger.kernel.org;
        h=content-transfer-encoding:in-reply-to:from:content-language
         :references:cc:to:subject:user-agent:mime-version:date:message-id
         :from:to:cc:subject:date:message-id:reply-to;
        bh=ZaA7ELYfCBytGBHycZn/0maI9XaR98EbBKpXVQ28XuM=;
        b=TlMR7wl4emgZjOTO/nbNiKwOeg259TYomhaQNSt4aeLI7QS+lprN/csvpXcFaVAdiZ
         mBJuPl51dCnC33chlwoHaK1Ci43rsq389PjTqY0BpeqiPhi6ybdKGX7wAJ28dkWmexPN
         FQwWorGXTfETX12rJh/EFeuEzUeIedu1zBfG72gSgtmvqDD8yC0Ak+bBhBV95dkEUysr
         C6Fio8ffIByn1WUwahDG4djLA1H8hw79OFCD+bZ3rBT/7JWLQlXXydKji9iNi9TZRbTc
         MoxMsboS+CzfdC5/IDz6JCOSzysqGVy5qxW/goTg+AX8IWGiuJM+LNvNAwhHbo1iA8Xf
         WY4g==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1721653942; x=1722258742;
        h=content-transfer-encoding:in-reply-to:from:content-language
         :references:cc:to:subject:user-agent:mime-version:date:message-id
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=ZaA7ELYfCBytGBHycZn/0maI9XaR98EbBKpXVQ28XuM=;
        b=aW42gEAymqQ6twiB8K0GjsXf5bdhGu+ujq0bU608aZRzjfaw+iIUk5QDv8EoXM8gaR
         dvwoNmEr90rUcETauriSIGYvXjN/IqyCLz+aaimC8DrxVtpOBCsSQCs+cHrxzNaOY60l
         MHwCfCScWMvSuvksXLsHYBs798OhR8NtFYLBy7TiZks9EBxBvYXs+VFOsdwv2a4Byd8K
         R92PMeMkDJb+RyIaEmhrleVLByfzwDBP0Pt9QDF/CXZjOac4Y0hBzDx+Vq1KkVqr1W7P
         AVQ/OzQpRDrvnfNeehPcE/WVf/9qnT2rGtok8op1RAy26s358FSGKJQyMx/D2hwpKWw0
         fKSw==
X-Gm-Message-State: AOJu0YyulgXE1E7nI7ieLNxvvkpJNk9Ljg98v4wXgGIj/IQq+Qrf/0l2
	GWB0JCzFQcMkbssHNKD7XH7fIOieUNQtWHt0Ht3M5G6wpja7oFihnpPBpg==
X-Google-Smtp-Source: AGHT+IEtzooKjVnJW5AZ3JliYoJv0B+HIuh+H4iHeTO0CnT1lpVwmGFZXo8ATLXmj3Doyclkx37mHw==
X-Received: by 2002:a17:906:c142:b0:a6f:996f:23ea with SMTP id a640c23a62f3a-a7a41b87dbemr742163766b.15.1721653941396;
        Mon, 22 Jul 2024 06:12:21 -0700 (PDT)
Received: from [192.168.42.33] ([163.114.131.193])
        by smtp.gmail.com with ESMTPSA id a640c23a62f3a-a7a84bbfd99sm2607566b.94.2024.07.22.06.12.20
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Mon, 22 Jul 2024 06:12:21 -0700 (PDT)
Message-ID: <ec03c78a-98a6-414c-a8ac-b1c5498101b5@gmail.com>
Date: Mon, 22 Jul 2024 14:12:48 +0100
Precedence: bulk
X-Mailing-List: io-uring@vger.kernel.org
List-Id: <io-uring.vger.kernel.org>
List-Subscribe: <mailto:io-uring+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:io-uring+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v6 2/2] io_uring/rsrc: enable multi-hugepage buffer
 coalescing
To: Chenliang Li <cliang01.li@samsung.com>, axboe@kernel.dk
Cc: io-uring@vger.kernel.org, peiwei.li@samsung.com, joshi.k@samsung.com,
 kundan.kumar@samsung.com, anuj20.g@samsung.com, gost.dev@samsung.com
References: <20240716060807.2707-1-cliang01.li@samsung.com>
 <CGME20240716060819epcas5p3387922a068b65eca1b3ab65effcf586e@epcas5p3.samsung.com>
 <20240716060807.2707-3-cliang01.li@samsung.com>
Content-Language: en-US
From: Pavel Begunkov <asml.silence@gmail.com>
In-Reply-To: <20240716060807.2707-3-cliang01.li@samsung.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit

On 7/16/24 07:08, Chenliang Li wrote:
> Add support for checking and coalescing multi-hugepage-backed fixed
> buffers. The coalescing optimizes both time and space consumption caused
> by mapping and storing multi-hugepage fixed buffers.
> 
> A coalescable multi-hugepage buffer should fully cover its folios
> (except potentially the first and last one), and these folios should
> have the same size. These requirements are for easier processing later,
> also we need same size'd chunks in io_import_fixed for fast iov_iter
> adjust.
> 
> Signed-off-by: Chenliang Li <cliang01.li@samsung.com>
> ---

The series looks good apart from the comment below, I'll run some
tests this week, I think you sent something for liburing/test

> +static bool io_try_coalesce_buffer(struct page ***pages, int *nr_pages,
> +					 struct io_imu_folio_data *data)
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
> +
> +		if (nr_folios == 1) {
> +			if (folio_page_idx(folio, page_array[i-1])
> +				!= data->nr_pages_mid - 1)

Code style, comparison (i.e. "!=") should be on the previous line

> +				return false;
> +
> +			data->nr_pages_head = count;
> +		} else if (count != data->nr_pages_mid) {
> +			return false;
> +		}
> +
> +		folio = page_folio(page_array[i]);
> +		if (folio_size(folio) != (1UL << data->folio_shift) ||
> +			folio_page_idx(folio, page_array[i]) != 0)
> +			return false;
> +
> +		count = 1;
> +		nr_folios++;
> +	}
> +	if (nr_folios == 1) {
> +		if (folio_page_idx(folio, page_array[i-1])
> +			!= data->nr_pages_mid - 1)

That's too restrictive and would be a regression. We currently allow
registrations fully falling under a single huge page but not matching
the right side. E.g. for a [N; M) huge page, you're allowed to register
[N + 4KB, M - 4KB). We should just remove this check.

And same comment about code style.


> +			return false;
> +
> +		data->nr_pages_head = count;
> +	}
> +
> +	return io_do_coalesce_buffer(pages, nr_pages, data, nr_folios);
> +}
> +
-- 
Pavel Begunkov

