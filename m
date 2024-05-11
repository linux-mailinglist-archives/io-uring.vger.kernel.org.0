Return-Path: <io-uring+bounces-1876-lists+io-uring=lfdr.de@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [147.75.80.249])
	by mail.lfdr.de (Postfix) with ESMTPS id 14ED98C3293
	for <lists+io-uring@lfdr.de>; Sat, 11 May 2024 18:48:29 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id 8D3861F21797
	for <lists+io-uring@lfdr.de>; Sat, 11 May 2024 16:48:28 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 9B7897F;
	Sat, 11 May 2024 16:48:23 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel-dk.20230601.gappssmtp.com header.i=@kernel-dk.20230601.gappssmtp.com header.b="KIuN/Moo"
X-Original-To: io-uring@vger.kernel.org
Received: from mail-pj1-f42.google.com (mail-pj1-f42.google.com [209.85.216.42])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id F178E1865A
	for <io-uring@vger.kernel.org>; Sat, 11 May 2024 16:48:20 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.216.42
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1715446103; cv=none; b=UzeFB8ZKL8pax+j+LaUjFm1XvPML+wd0AZTTuoa6Z4GA1PHjLqQhm5LYejygvqUA1/Hoxs0wGBInouJ53+wVaNZDNhkj8P21DcHOyb+bTpR08yQ1DG7EC+BDZGL0a2nJSZeP6w+2v/MEC8HgVFUdcRtq8AMu5Dr9i6B3xWz4nr4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1715446103; c=relaxed/simple;
	bh=X0N9fHTK+CA3MZ01Fh1HKU5nBmi7dX6YO/M2DQrMKRw=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=JNNMDDqe+MZBcvsjdyIMeXKdUHlCnexQJunq99s6GBuLs+vT2hxiCcpDUdC3Ex0llY5W0+umcwJ1+AhC4u6B8Ch2DIbQ8wzpF2pgsHrPK9DMJgj2UseU+O+BFq8P5IYfUiu9OJ9pPo8qz6QrTLW7dj4L3TYcxazvZwwMImf6jnE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=kernel.dk; spf=pass smtp.mailfrom=kernel.dk; dkim=pass (2048-bit key) header.d=kernel-dk.20230601.gappssmtp.com header.i=@kernel-dk.20230601.gappssmtp.com header.b=KIuN/Moo; arc=none smtp.client-ip=209.85.216.42
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=kernel.dk
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=kernel.dk
Received: by mail-pj1-f42.google.com with SMTP id 98e67ed59e1d1-2b360096cc4so826122a91.1
        for <io-uring@vger.kernel.org>; Sat, 11 May 2024 09:48:20 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernel-dk.20230601.gappssmtp.com; s=20230601; t=1715446100; x=1716050900; darn=vger.kernel.org;
        h=content-transfer-encoding:in-reply-to:from:content-language
         :references:cc:to:subject:user-agent:mime-version:date:message-id
         :from:to:cc:subject:date:message-id:reply-to;
        bh=2MK94LqUPxfZCOU5e3CFpE+C9EDygjVWT5S6XC8DZD0=;
        b=KIuN/MoooqVA4bwKachfN8v6MhVlf+p1S3RAjhk8KipDgRjlyiyYzOpxu4PJCPOewA
         Tx9MxVLnWh841c6ZAwVUg0Zcbf5xIKWXjLKpKgF0JE5AxDfzMjzWJQbSX65DIeIG1fkV
         tRWr41Qg89QPt9Ih14x31V1GRMTbegwTVD7LPIAePbZkTE9kYnTZ/a02yW8FI+YBgngT
         5pV3qW9Jk157hskYKuW1GqFrvDimvbIlwz4WBnI1zrZQ6unxr7K5k9WKg46PChUVVM8x
         iEmseQaTAPcZwmSeGjFkhj6S/xtEwNzafkJSHDvUQIE046Z5hU7UgcCvL6TJrot+ClKF
         vXQA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1715446100; x=1716050900;
        h=content-transfer-encoding:in-reply-to:from:content-language
         :references:cc:to:subject:user-agent:mime-version:date:message-id
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=2MK94LqUPxfZCOU5e3CFpE+C9EDygjVWT5S6XC8DZD0=;
        b=w6HyDo3SGZLi4Ats+VAL64/Qqk6R+dL9WQOeH/gjXK8dRRmlgQMLWDuW9KCtlbpjmq
         R8NeP3WQ/ug0UeXQLCV3/6kuhibPtNyXS/jHIWKN2quIqnaQmTIy/enRyhe7I+v6V75T
         H+iBQLKsjW/eumS1BbsFsflV424WA7rBhk8KzqRvHWV4ujQgIKp0Dj3JjEVdpvq7z+ng
         dxMGv5aYP/AKPt40TurlGEVwQaxjy1UQ8TkPsAdLS08Z+ZmDgZvxBmkb8mENY8JwTAsn
         mthyx+/h3ujCVVvbei+v0qylqPPtIYUkdiUTwo7Eugr8iu4auDF9TQ4JycgwPMGWL5kJ
         Lf7g==
X-Gm-Message-State: AOJu0Yzz5djJEolKjDmlw6/Z90GeX6sTZwX4ifUZz0pMMcdn0uZb7Qt+
	yT+7YXeEUv7v61lFVpp+XgC0JQlAS1c2dJENltfzdND6YxEqC0P0RTj+FGjfO34=
X-Google-Smtp-Source: AGHT+IFEOaGXrLmBfv5XxcArXR/1ETptL0d7UX2xpC2V2DlZdou28ZHt3xP02A8lTaYaFPoCUyIPZQ==
X-Received: by 2002:a17:902:d4ce:b0:1eb:d71c:fd6a with SMTP id d9443c01a7336-1ef441809f3mr65863315ad.3.1715446100250;
        Sat, 11 May 2024 09:48:20 -0700 (PDT)
Received: from [192.168.1.150] ([198.8.77.194])
        by smtp.gmail.com with ESMTPSA id d9443c01a7336-1ef0bad5f30sm51004765ad.64.2024.05.11.09.48.18
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Sat, 11 May 2024 09:48:19 -0700 (PDT)
Message-ID: <212f0080-beea-4671-8ce8-8662c155317b@kernel.dk>
Date: Sat, 11 May 2024 10:48:18 -0600
Precedence: bulk
X-Mailing-List: io-uring@vger.kernel.org
List-Id: <io-uring.vger.kernel.org>
List-Subscribe: <mailto:io-uring+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:io-uring+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v2 3/4] io_uring/rsrc: add init and account functions for
 coalesced imus
To: Chenliang Li <cliang01.li@samsung.com>, asml.silence@gmail.com
Cc: io-uring@vger.kernel.org, peiwei.li@samsung.com, joshi.k@samsung.com,
 kundan.kumar@samsung.com, gost.dev@samsung.com
References: <20240511055229.352481-1-cliang01.li@samsung.com>
 <CGME20240511055247epcas5p2a54e23b6dddd11dda962733d259a10af@epcas5p2.samsung.com>
 <20240511055229.352481-4-cliang01.li@samsung.com>
Content-Language: en-US
From: Jens Axboe <axboe@kernel.dk>
In-Reply-To: <20240511055229.352481-4-cliang01.li@samsung.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit

On 5/10/24 11:52 PM, Chenliang Li wrote:
> This patch depends on patch 1 and 2.

What does "patch 1 and 2" mean here, once it's in the git log? It
doesn't really mean anything. It's quite natural for patches in a series
to have dependencies on each other, eg patch 3 requirest 1 and 2.
Highlighting it doesn't really add anything, so just get rid of that.

> Introduces two functions to separate the coalesced imu alloc and
> accounting path from the original one. This helps to keep the original
> code path clean.
> 
> Signed-off-by: Chenliang Li <cliang01.li@samsung.com>
> ---
>  io_uring/rsrc.c | 86 +++++++++++++++++++++++++++++++++++++++++++++++++
>  1 file changed, 86 insertions(+)
> 
> diff --git a/io_uring/rsrc.c b/io_uring/rsrc.c
> index 578d382ca9bc..7f95eba72f1c 100644
> --- a/io_uring/rsrc.c
> +++ b/io_uring/rsrc.c
> @@ -871,6 +871,42 @@ static int io_buffer_account_pin(struct io_ring_ctx *ctx, struct page **pages,
>  	return ret;
>  }
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
> +		j += (i == 0) ?
> +			data->nr_pages_head : data->nr_pages_mid;

Can we just initialize 'j' to data->nr_pages_head and change this to be:

	if (i)
		j += data->nr_pages_mid;

That would be a lot cleaner.

> +	if (!imu->acct_pages)
> +		return 0;
> +
> +	ret = io_account_mem(ctx, imu->acct_pages);
> +	if (ret)
> +		imu->acct_pages = 0;
> +	return ret;
> +}

	ret = io_account_mem(ctx, imu->acct_pages);
	if (!ret)
		return 0;
	imu->acct_pages = 0;
	return ret;

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
> +		j = 0;
> +		for (i = 0; i < data->nr_folios; i++) {
> +			unpin_user_page(pages[j]);
> +			j += (i == 0) ?
> +				data->nr_pages_head : data->nr_pages_mid;
> +		}
> +		return ret;

Same comment here.

-- 
Jens Axboe


