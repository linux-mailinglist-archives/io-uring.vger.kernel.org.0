Return-Path: <io-uring+bounces-7545-lists+io-uring=lfdr.de@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [147.75.199.223])
	by mail.lfdr.de (Postfix) with ESMTPS id 3B7B4A939B2
	for <lists+io-uring@lfdr.de>; Fri, 18 Apr 2025 17:35:52 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id BEBC4448389
	for <lists+io-uring@lfdr.de>; Fri, 18 Apr 2025 15:35:47 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 1CE5D21325D;
	Fri, 18 Apr 2025 15:35:43 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=davidwei-uk.20230601.gappssmtp.com header.i=@davidwei-uk.20230601.gappssmtp.com header.b="C1R3NfYb"
X-Original-To: io-uring@vger.kernel.org
Received: from mail-pf1-f170.google.com (mail-pf1-f170.google.com [209.85.210.170])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 86C6E21129A
	for <io-uring@vger.kernel.org>; Fri, 18 Apr 2025 15:35:41 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.210.170
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1744990543; cv=none; b=YDzXxrNZNgT4ioExYsNWG5uJ+qJqh8cRYiaGC1l7wOronVPgPukCTqEljj8ZzDRBseOIHrb/Xs7Oi3lmEAKjAc1BRSLSWXgr59hVYBVn6BEoTPlScf4H5DWy8RTtmUPXO+dmlmizXiOP+a0DiZcUxYVvm+7WmyETQ8QI7qeWtQU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1744990543; c=relaxed/simple;
	bh=aDFwMO67IWdxGViwjxcN5TKWFu9m2bt68SWd5zrdUGY=;
	h=Message-ID:Date:MIME-Version:Subject:To:References:From:
	 In-Reply-To:Content-Type; b=F8tRXrB7kpYCXZ4X9t/j1FOcAqd/6BNggoyRo6XTpEw06ANcavQhasSJUlZH37pLFcwlF0Hy0//m4QYnQhUCBRo+NNEwotusLslvVNBOom8EEpuebl5wE3q9MSwGRkyW2pEit6j9PqlE9ZfwPFFim3SkCvx5NqBn3jsOnTtLGpk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=davidwei.uk; spf=none smtp.mailfrom=davidwei.uk; dkim=pass (2048-bit key) header.d=davidwei-uk.20230601.gappssmtp.com header.i=@davidwei-uk.20230601.gappssmtp.com header.b=C1R3NfYb; arc=none smtp.client-ip=209.85.210.170
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=davidwei.uk
Authentication-Results: smtp.subspace.kernel.org; spf=none smtp.mailfrom=davidwei.uk
Received: by mail-pf1-f170.google.com with SMTP id d2e1a72fcca58-739525d4e12so1804513b3a.3
        for <io-uring@vger.kernel.org>; Fri, 18 Apr 2025 08:35:41 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=davidwei-uk.20230601.gappssmtp.com; s=20230601; t=1744990541; x=1745595341; darn=vger.kernel.org;
        h=content-transfer-encoding:in-reply-to:from:references:to
         :content-language:subject:user-agent:mime-version:date:message-id
         :from:to:cc:subject:date:message-id:reply-to;
        bh=kILkesqa+OyhJ2e6w/tTZN4VwcVD9KcdJg0wH3ZZnbY=;
        b=C1R3NfYbQkT7V9ptjonD9q1pQRLldvossw+et87cisNYmMCgbAHlfL73BmCxRlwfGT
         3xqghqjzAZDx48nIbeqvb/iDnk2FO+P/HcCBpKI5vfyPkzaNOvbQck6AF8kPIrd5N5tL
         d302QG1jv0X+nlBxlvWzbGzaL2ZrMXL6g5jGVTs8J6Rjzu7fNLhNU/v3fRYNe3Oxncxg
         te6FzUgWa9/RrKNkAOnoRc3jo0gmLRgN+tBs7894VMRtN5idq+asWui+PX9f9VpZQQXX
         bf9fGnf7hHIgUceLEqFVrXopDBlwz9I9ROst2+lUrj3w7wWAEDxoRwDKJwq1sRZnOpXh
         aG0w==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1744990541; x=1745595341;
        h=content-transfer-encoding:in-reply-to:from:references:to
         :content-language:subject:user-agent:mime-version:date:message-id
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=kILkesqa+OyhJ2e6w/tTZN4VwcVD9KcdJg0wH3ZZnbY=;
        b=OwPWfDZ3I5VPT799rblAGf0s0wccHy1KVr4oO1l7VSjZgFX8UglToQ97O6JmWP2qLH
         CTCeEJ2NrgHdRuocIA4tVuuQjgPefSpfqGBd2s8VPfP3Aizj/GpQztjowNjo79goENHd
         d9k8M9wHldvUW/Melt3iJkXAKXGpZuRSZVvooU5FgFUDcAd4YJnREeBfWTwIEMmuzADo
         oUL6wVO/rcQ1fNtawe+igCivkNjStKsGKza3VIWrPobPkD6u/bVpSJyatZLFdR0KFCPp
         POyT7wvITu6CIIIIe81XsJN79PmMYJepSnINw4UIaa6uRm9D7sn1pYKFu84feYlX1VCu
         GKaw==
X-Forwarded-Encrypted: i=1; AJvYcCV2jXh8HMGetS441W9YtpFnFKDNg3OkkjIuY/pV973ZGNHoVIq3KWIo/XT2FimPEJdi7KjXRgkWuw==@vger.kernel.org
X-Gm-Message-State: AOJu0YwFRu/dw40hacSYScMy+3rg/x6gUmS8TV28oalV0s9cCeqyrArj
	xqi1pjSkA7bhkVBa4EZYqaK+qXTvE4xYEM7qAXydOk7v0AtKXeMIZvkUnJgPakc=
X-Gm-Gg: ASbGnct/X5ZCBcUPtC+w7Ztsz2osZWrlTCPGXrZ2QyXziJJq0+dIQUpp99N4LAKjPGW
	JSUUueOZN+HpgGocHRmf9UVL6Xc26UAx2G5ia3x7NdxiN7wNEyqP5fOsEw/M8YX3OYq8BSve2sX
	bxpNoeLBPNLiAOeBWOYghAUEfHJAtZA5pIOqt2MFeHhcfQoxTS1h/eFHT8PIRyVEqVREn6YmzkH
	IILaoG/bAppGBtaRWzWrDTL8BySvNgq5w06n09IaNAaX/hqisgY3rc3snbsnrfGXmha1CUnqY8X
	OwE7+HdT5oGx9R+LqcVOcGYStaQ0uPG73PfcNbeibwLTwo0d0v9PVJ5HAjEpG4xYdcTkgZe2hJA
	qQXvwm0J8CuvQo5/TiLg=
X-Google-Smtp-Source: AGHT+IEBoNs2W1jJqNYy+KaOqtYYPVph4ByZntnlTp/2VNDdurO9oP5DTiJ41YngqhaWyJi4yBp7OA==
X-Received: by 2002:a05:6a21:3181:b0:1fe:8ffe:9801 with SMTP id adf61e73a8af0-203cbc748dfmr4974898637.22.1744990540745;
        Fri, 18 Apr 2025 08:35:40 -0700 (PDT)
Received: from ?IPV6:2a03:83e0:1156:1:1cf1:8569:9916:d71f? ([2620:10d:c090:500::6:5122])
        by smtp.gmail.com with ESMTPSA id d2e1a72fcca58-73dbf8beb0dsm1742370b3a.33.2025.04.18.08.35.40
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Fri, 18 Apr 2025 08:35:40 -0700 (PDT)
Message-ID: <f0dfc45a-6916-4c1a-a917-2c0a3f05c8a7@davidwei.uk>
Date: Fri, 18 Apr 2025 08:35:39 -0700
Precedence: bulk
X-Mailing-List: io-uring@vger.kernel.org
List-Id: <io-uring.vger.kernel.org>
List-Subscribe: <mailto:io-uring+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:io-uring+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH 3/5] io_uring/zcrx: let zcrx choose region for mmaping
Content-Language: en-GB
To: Pavel Begunkov <asml.silence@gmail.com>, io-uring@vger.kernel.org
References: <cover.1744815316.git.asml.silence@gmail.com>
 <83105d96566ff5615aacd3d7646811081614d9a0.1744815316.git.asml.silence@gmail.com>
From: David Wei <dw@davidwei.uk>
In-Reply-To: <83105d96566ff5615aacd3d7646811081614d9a0.1744815316.git.asml.silence@gmail.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit

On 2025-04-16 08:21, Pavel Begunkov wrote:
> In preparation for adding multiple ifqs, add a helper returning a region
> for mmaping zcrx refill queue. For now it's trivial and returns the same
> ctx global ->zcrx_region.
> 
> Signed-off-by: Pavel Begunkov <asml.silence@gmail.com>
> ---
>  io_uring/memmap.c | 10 ++++++----
>  io_uring/zcrx.c   | 10 ++++++++++
>  io_uring/zcrx.h   |  7 +++++++
>  3 files changed, 23 insertions(+), 4 deletions(-)
> 
> diff --git a/io_uring/memmap.c b/io_uring/memmap.c
> index 76fcc79656b0..e53289b8d69d 100644
> --- a/io_uring/memmap.c
> +++ b/io_uring/memmap.c
> @@ -13,6 +13,7 @@
>  #include "memmap.h"
>  #include "kbuf.h"
>  #include "rsrc.h"
> +#include "zcrx.h"
>  
>  static void *io_mem_alloc_compound(struct page **pages, int nr_pages,
>  				   size_t size, gfp_t gfp)
> @@ -258,7 +259,9 @@ static struct io_mapped_region *io_mmap_get_region(struct io_ring_ctx *ctx,
>  						   loff_t pgoff)
>  {
>  	loff_t offset = pgoff << PAGE_SHIFT;
> -	unsigned int bgid;
> +	unsigned int id;
> +
> +	id = (offset & ~IORING_OFF_MMAP_MASK) >> IORING_OFF_PBUF_SHIFT;

We using the same IORING_OFF_PBUF_SHIFT?


