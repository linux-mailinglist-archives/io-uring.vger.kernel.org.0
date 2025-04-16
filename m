Return-Path: <io-uring+bounces-7484-lists+io-uring=lfdr.de@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [139.178.88.99])
	by mail.lfdr.de (Postfix) with ESMTPS id 222FBA90736
	for <lists+io-uring@lfdr.de>; Wed, 16 Apr 2025 17:02:25 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id E479E3BDFFF
	for <lists+io-uring@lfdr.de>; Wed, 16 Apr 2025 15:02:04 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 269D51DC9A8;
	Wed, 16 Apr 2025 15:02:14 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="nacMTI+g"
X-Original-To: io-uring@vger.kernel.org
Received: from mail-ed1-f53.google.com (mail-ed1-f53.google.com [209.85.208.53])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 43FCB1FC0ED;
	Wed, 16 Apr 2025 15:02:12 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.208.53
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1744815734; cv=none; b=fbBnvV62+aiTM/IGblyYoi3HEhtzDqjEciEWKdUqJHEdt5uUhqTVZr0/JvdWBnfzpbnhuvh5F5i4DLFmQJWJZRINUu5a3vpL6Morxf0IKsY+f1h0tY+KE/mFa2E067lNogYIs2u8ZUe1o1uk8k+/Prz6NMAG0KIJEQCaszipA5Y=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1744815734; c=relaxed/simple;
	bh=QRxPya7JpXCETvUcH9DRxaL80/XVXjs4IkrDFBt/OGM=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=sspWkWQupX/pUc82S14vYVbkQPIocvi5h1kku8NkuqEKbhCX69Uz5t08PrZF4+kFpv9/ZI+tmViuxnF488b5o3fQFro8vWWiqef92DwddLWKCkWp969P/2aV7SDRTzaZ+4grWfG1XBEQNOonD6UQvo2IW4RVSgRiEP7Bg6/Qn28=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=nacMTI+g; arc=none smtp.client-ip=209.85.208.53
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Received: by mail-ed1-f53.google.com with SMTP id 4fb4d7f45d1cf-5efe8d9eb12so11571938a12.1;
        Wed, 16 Apr 2025 08:02:12 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1744815730; x=1745420530; darn=vger.kernel.org;
        h=content-transfer-encoding:in-reply-to:from:content-language
         :references:cc:to:subject:user-agent:mime-version:date:message-id
         :from:to:cc:subject:date:message-id:reply-to;
        bh=F6XcolHXlIjt28ayjF3eP0yfHiDO0i8Rtn3p581woik=;
        b=nacMTI+gdS1Gwulwz0zYUnQJr+C+rGxvfxchEnnHsOE4zUP3uTOhnFCUftX8Ub38gG
         hY9YeywkN33RvIm917S6Hvq8pn+5H1tXOBCqgvf8Xoest4+vEtaj+jriiqWQJysLLXsI
         STU1a2yMyOJS89WBt4eaehUxB5tJ7al10ttbjyqhsPXmPN5wEehf2erb+19HTmxx/7X+
         omQYVMZ2IXVsCPxPO4kxFfXuqXsdfxe8qP9x8gntLG9xBQhBaoC0DgyU4AdGZvA6vaWQ
         s7C6QAx37d/jxHbqtIspJX9WAh0WSO8WrWqpD8D7B3QsVQlQdNIQ35Y0o6h/HYQWk9ff
         qYfg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1744815730; x=1745420530;
        h=content-transfer-encoding:in-reply-to:from:content-language
         :references:cc:to:subject:user-agent:mime-version:date:message-id
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=F6XcolHXlIjt28ayjF3eP0yfHiDO0i8Rtn3p581woik=;
        b=Idz37PhgMCuWfCbLump9uoHsMbGt40AjaVe45vA8m0hvOyleW/9t7yF+7pwumzIooR
         kvPggjR0EljrADbnbxtKrpYUs21hXVMagcYvm59cW587VPUvM35a9JRUIOWVLmtHevr6
         u/od4y3c1lnph8/R+RXCA8TMThobOykPdUqie7nhgYWRX4pXqlQeHEiy5+pEIIkSXiXg
         3gnuBeYWiJNY31oifveKW1syjtbRXl4O7rES/ls/uEKU0i5cnoKYgUnrdTogZZISNLFr
         UUel1XQoB0cVjQBigSZYVVoz+5ultCA1C7L/KoG/xa5heghrptdRCzXBNpeuCcrc2zfm
         pkXA==
X-Forwarded-Encrypted: i=1; AJvYcCUlWser5UeR1nf7U7GsY6r849T07Rd6KkUNP3bzrl1xge8gHIetavBeqxsDpkBEznkW+/oziOeHDQ==@vger.kernel.org, AJvYcCVdbrpocPtSXCfR7ZoTJ5xdF6QT05APwcqWZENiYhpjR2DEbN7aPLEmjvZfDNGi6q3BWwR6ayPUCrJcXccI@vger.kernel.org
X-Gm-Message-State: AOJu0YxyzjYci9hZuQjOUs6Jqz0O48MnafmvxNEIe6D48tjBFtJDYqpZ
	KlrwFsdRwJDzs8GLyVmbXeZnV3Mi4BRSJYvZF4mHiio1/ho42kQw
X-Gm-Gg: ASbGncuac8jAp/73rzIPSEXDZ7N4NtF081u/yXUqPC+xsLE+mTDLXovhT8Ecfmrzv1I
	MdrNeR90EkaeTEqCQBPpCecIj1DEFA4u6Y2JYYIgyQcpaW5KgD41hzqmelofAX6a4wF5s8rw6uo
	EKlAFVOk7tZ/LNhE8a5Bumxh32E+J5zBUINtJKoZtVNVnLahQuru5HNReuoLpy+2PsOunIPVgzz
	lZWE6cELgi9KdDaOPvSvmq1rtn6BR8zlcxH2ofuXoh5shcdtnqFXsnItg6qBnHkSPsBQ6PoKFfH
	eBW4zeQve3h/t05964OgVcabECW6x2+Ae/Eq7ziL5wQc6xgMZaCmJg==
X-Google-Smtp-Source: AGHT+IFcj9jkDdgV+jSAuWrirYf6lJ1KteDhxbknY3Im4OWYZoJVGcid1LYGM0PLuUm1hpPNncyEDA==
X-Received: by 2002:a05:6402:849:b0:5e7:b02b:5ae with SMTP id 4fb4d7f45d1cf-5f4b76f12a3mr1484060a12.31.1744815727270;
        Wed, 16 Apr 2025 08:02:07 -0700 (PDT)
Received: from ?IPV6:2620:10d:c096:325::1e4? ([2620:10d:c092:600::1:1ccb])
        by smtp.gmail.com with ESMTPSA id 4fb4d7f45d1cf-5f4b78a3308sm1010332a12.7.2025.04.16.08.02.06
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Wed, 16 Apr 2025 08:02:06 -0700 (PDT)
Message-ID: <98f08b07-c8de-4489-9686-241c0aab6acc@gmail.com>
Date: Wed, 16 Apr 2025 16:03:24 +0100
Precedence: bulk
X-Mailing-List: io-uring@vger.kernel.org
List-Id: <io-uring.vger.kernel.org>
List-Subscribe: <mailto:io-uring+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:io-uring+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH] io_uring/rsrc: send exact nr_segs for fixed buffer
To: Nitesh Shetty <nj.shetty@samsung.com>, Jens Axboe <axboe@kernel.dk>
Cc: gost.dev@samsung.com, nitheshshetty@gmail.com, io-uring@vger.kernel.org,
 linux-kernel@vger.kernel.org
References: <CGME20250416055250epcas5p25fa8223a1bfeea5583ad8ba88c881a05@epcas5p2.samsung.com>
 <20250416054413.10431-1-nj.shetty@samsung.com>
Content-Language: en-US
From: Pavel Begunkov <asml.silence@gmail.com>
In-Reply-To: <20250416054413.10431-1-nj.shetty@samsung.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit

On 4/16/25 06:44, Nitesh Shetty wrote:
> Sending exact nr_segs, avoids bio split check and processing in
> block layer, which takes around 5%[1] of overall CPU utilization.
> 
> In our setup, we see overall improvement of IOPS from 7.15M to 7.65M [2]
> and 5% less CPU utilization.
> 
> [1]
>       3.52%  io_uring         [kernel.kallsyms]     [k] bio_split_rw_at
>       1.42%  io_uring         [kernel.kallsyms]     [k] bio_split_rw
>       0.62%  io_uring         [kernel.kallsyms]     [k] bio_submit_split
> 
> [2]
> sudo taskset -c 0,1 ./t/io_uring -b512 -d128 -c32 -s32 -p1 -F1 -B1 -n2
> -r4 /dev/nvme0n1 /dev/nvme1n1
> 
> Signed-off-by: Nitesh Shetty <nj.shetty@samsung.com>
> ---
>   io_uring/rsrc.c | 3 +++
>   1 file changed, 3 insertions(+)
> 
> diff --git a/io_uring/rsrc.c b/io_uring/rsrc.c
> index b36c8825550e..6fd3a4a85a9c 100644
> --- a/io_uring/rsrc.c
> +++ b/io_uring/rsrc.c
> @@ -1096,6 +1096,9 @@ static int io_import_fixed(int ddir, struct iov_iter *iter,
>   			iter->iov_offset = offset & ((1UL << imu->folio_shift) - 1);
>   		}
>   	}
> +	iter->nr_segs = (iter->bvec->bv_offset + iter->iov_offset +
> +		iter->count + ((1UL << imu->folio_shift) - 1)) /
> +		(1UL << imu->folio_shift);

That's not going to work with ->is_kbuf as the segments are not uniform in
size.

And can we make it saner? Split it into several statements, add variables
for folio size and so, or maybe just use ALIGN. If moved above, you
probably don't even need to recalc

iter->bvec->bv_offset + iter->iov_offset

-- 
Pavel Begunkov


