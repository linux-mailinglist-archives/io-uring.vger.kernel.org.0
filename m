Return-Path: <io-uring+bounces-1775-lists+io-uring=lfdr.de@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [IPv6:2604:1380:4601:e00::3])
	by mail.lfdr.de (Postfix) with ESMTPS id C291C8BCE9F
	for <lists+io-uring@lfdr.de>; Mon,  6 May 2024 14:57:57 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id 34E8F1F22F08
	for <lists+io-uring@lfdr.de>; Mon,  6 May 2024 12:57:57 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id C89F65FB9A;
	Mon,  6 May 2024 12:57:50 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel-dk.20230601.gappssmtp.com header.i=@kernel-dk.20230601.gappssmtp.com header.b="NVCEXrDK"
X-Original-To: io-uring@vger.kernel.org
Received: from mail-oo1-f53.google.com (mail-oo1-f53.google.com [209.85.161.53])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7CEC81C6B9
	for <io-uring@vger.kernel.org>; Mon,  6 May 2024 12:57:47 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.161.53
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1715000270; cv=none; b=tQeJpKKV9fXdQtU98ZpAA+P7A/ilHy4Cfpjw9njWsuN5NLOLJxGJNDM5fHFS6t7bRiRVgwxsNzwEXm0lK/kXT+otAHv8IX903LzWZq03KWoUiPjo57daJIE/rBcvycGc/Nuuh6mZZGjd+/55WZxqJeR/sljEYTk5VKgdIEDjUPo=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1715000270; c=relaxed/simple;
	bh=UsBddcet5Sd4zyP9X920l8bRMzFSxcgmySjLBhYkM0c=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=qnLeAc9yhNlTgX1XmcWmcykH68tJ11o+AqLnqoxbPJPY3dfD3LOHIVMHFOEFJQtBhm+MAtheAmlNlg4AGmrTfKz8xyt4qQTwIq51sh0pvcsehycW4+mxFAH+SO4UcOqryWOjBbNUKIA4VZjeRiz9FoRz3ucgvPdimbLXJfBYDcM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=kernel.dk; spf=pass smtp.mailfrom=kernel.dk; dkim=pass (2048-bit key) header.d=kernel-dk.20230601.gappssmtp.com header.i=@kernel-dk.20230601.gappssmtp.com header.b=NVCEXrDK; arc=none smtp.client-ip=209.85.161.53
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=kernel.dk
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=kernel.dk
Received: by mail-oo1-f53.google.com with SMTP id 006d021491bc7-5ad288442bdso242303eaf.3
        for <io-uring@vger.kernel.org>; Mon, 06 May 2024 05:57:47 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernel-dk.20230601.gappssmtp.com; s=20230601; t=1715000266; x=1715605066; darn=vger.kernel.org;
        h=content-transfer-encoding:in-reply-to:from:content-language
         :references:cc:to:subject:user-agent:mime-version:date:message-id
         :from:to:cc:subject:date:message-id:reply-to;
        bh=nMciShd0EGYC7XDcTrn2YNrkROd7Rswy9QEQRWNAjUM=;
        b=NVCEXrDKTUkIuOCgrmgGGD5CuP2Eij/BIo8wwbA8G+VlhtrKjkxwVdUDVYCvRmrvfN
         w1dCBueomJ0PoqYxgtVto0zW2tnbPWTOdVQpTxOHrditzFV9CuWfUPbO6l5cgIdvqcb/
         KXNoYBV6zpS+iGOjfiN7RDZzyG9EmJM6I1hejS1/1GMttki27x2lGCVOFEj0I29KZ6r8
         bGJNLSOC2mqzTe5Kb2zWiYZMRi7Ws9F7QEcEcrue7OiKy5aQXUzGqdgIUHY2s2Ty8RWC
         cxJJn6IGDHN3RRfuw0uxrKx5yEag9uhFxmAUk896yoXkXONtz7ns4xxN2QPcys89co+8
         vZ8w==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1715000266; x=1715605066;
        h=content-transfer-encoding:in-reply-to:from:content-language
         :references:cc:to:subject:user-agent:mime-version:date:message-id
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=nMciShd0EGYC7XDcTrn2YNrkROd7Rswy9QEQRWNAjUM=;
        b=Nx+c4CynjQxxDtkBO7QAVjNLMH4JiVtzFid9YU3f5Zp+2Yn0/2pOZhgha9ag23T6tX
         oNzPDbWPQkxLCkACHfJhrG6YEL9A3cwEHl9kfjbKckZx1SGJLb3FeTr1FCI/+9fmksK3
         +ncnGcMMcsanRWvAYLRCUUCZ5ouHIKK4U6ICcLdevmaWWRmByci21HfVn8lApNrO2QGL
         5tD2HV/llJXnZRrqnQLH4H7/ZM8zFtIFZB6FZaExh5iL8bAh6G2h7G+BSTGyqn894mJU
         9gtSzxp3sYo38zn9soVWBRVHXejUeuntDR4U6NSst3iytXz4TXPygGBKcYoPkuQ445LF
         fJKw==
X-Gm-Message-State: AOJu0YxqQ4YPjHSZCLCH6uf0p03P+onZ7lfhaduWjVZ0a+duEHHemOBc
	yc5v5EvMPiMnvyz5VmPCmts5p5zKxYJC+byV6B6JZA6Hi7JWvoSTZW8jmMP42ZE=
X-Google-Smtp-Source: AGHT+IF0uaJyxDYlhm9O/TvO/iJ/Fz0qp7mFPyXdDKipzsEKCgfH9GqZEiBJUkM2K4CJPBtVCta/PQ==
X-Received: by 2002:a05:6870:b4a7:b0:23c:9036:1f61 with SMTP id y39-20020a056870b4a700b0023c90361f61mr12457322oap.1.1715000266357;
        Mon, 06 May 2024 05:57:46 -0700 (PDT)
Received: from [192.168.1.150] ([198.8.77.194])
        by smtp.gmail.com with ESMTPSA id g9-20020aa79dc9000000b006eae2d9298esm7596322pfq.194.2024.05.06.05.57.45
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Mon, 06 May 2024 05:57:45 -0700 (PDT)
Message-ID: <71c1f01f-f740-43b0-9962-afcf08cab686@kernel.dk>
Date: Mon, 6 May 2024 06:57:44 -0600
Precedence: bulk
X-Mailing-List: io-uring@vger.kernel.org
List-Id: <io-uring.vger.kernel.org>
List-Subscribe: <mailto:io-uring+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:io-uring+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH] io_uring/rsrc: Add support for multi-folio buffer
 coalescing
To: Chenliang Li <cliang01.li@samsung.com>, asml.silence@gmail.com
Cc: io-uring@vger.kernel.org, linux-kernel@vger.kernel.org,
 peiwei.li@samsung.com, joshi.k@samsung.com, kundan.kumar@samsung.com,
 gost.dev@samsung.com
References: <CGME20240506075314epcas5p25333b80c8d6a3217d5352a5a7ed89278@epcas5p2.samsung.com>
 <20240506075303.25630-1-cliang01.li@samsung.com>
Content-Language: en-US
From: Jens Axboe <axboe@kernel.dk>
In-Reply-To: <20240506075303.25630-1-cliang01.li@samsung.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit

On 5/6/24 1:53 AM, Chenliang Li wrote:
> Currently fixed buffers consisting of pages in one same folio(huge page)
> can be coalesced into a single bvec entry at registration.
> This patch expands it to support coalescing fixed buffers
> with multiple folios, by:
> 1. Add a helper function and a helper struct to do the coalescing work
> at buffer registration;
> 2. Add the bvec setup procedure of the coalsced path;

coalesced

> 3. store page_mask and page_shift into io_mapped_ubuf for
> later use in io_import_fixed.

Can you add some justification to this commit message? A good commit
message should basically be the WHY of why this commit exists in the
first place. Your commit message just explains what the patch does,
which I can just read the code to see for myself.

As it stands, it's not clear to me or anyone casually reading this
commit message why the change is being done in the first place.

Outside of that, you probably want to split this into two parts - one
that adds the helper for the existing code, then one that modifies it
for your change. We need this to be as simple as possible to review, as
we've had a security issue with page coalescing in this code in the
past.

Minor comments below, will wait with a full review until this is split
to be more easily reviewable.

> +/*
> + * For coalesce to work, a buffer must be one or multiple
> + * folios, all the folios except the first and last one
> + * should be of the same size.
> + */
> +static bool io_sqe_buffer_try_coalesce(struct page **pages,
> +				       unsigned int nr_pages,
> +				       struct io_imu_folio_stats *stats)
> +{
> +	struct folio	*folio = NULL, *first_folio = NULL;
> +	unsigned int	page_cnt;
> +	int		i, j;

Please don't make up your own style, follow the style that's already in
the file to begin with.

> diff --git a/io_uring/rsrc.h b/io_uring/rsrc.h
> index c032ca3436ca..4c655e446150 100644
> --- a/io_uring/rsrc.h
> +++ b/io_uring/rsrc.h
> @@ -47,9 +47,18 @@ struct io_mapped_ubuf {
>  	u64		ubuf_end;
>  	unsigned int	nr_bvecs;
>  	unsigned long	acct_pages;
> +	unsigned int	page_shift;
> +	unsigned long	page_mask;
>  	struct bio_vec	bvec[] __counted_by(nr_bvecs);
>  };

When adding members to a struct, please be cognizant of how it packs.
I'd suggest making the above:

  	u64		ubuf_end;
  	unsigned int	nr_bvecs;
	unsigned int	page_shift;
	unsigned long	page_mask;
  	unsigned long	acct_pages;
	struct bio_vec	bvec[] __counted_by(nr_bvecs);

which should pack much nicer and actually save memory.

-- 
Jens Axboe


