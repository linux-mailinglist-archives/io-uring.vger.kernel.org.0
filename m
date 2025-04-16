Return-Path: <io-uring+bounces-7480-lists+io-uring=lfdr.de@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [IPv6:2604:1380:45d1:ec00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id B0965A90633
	for <lists+io-uring@lfdr.de>; Wed, 16 Apr 2025 16:24:17 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id 6DB17178C79
	for <lists+io-uring@lfdr.de>; Wed, 16 Apr 2025 14:20:12 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 7C76C3FBA7;
	Wed, 16 Apr 2025 14:19:38 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel-dk.20230601.gappssmtp.com header.i=@kernel-dk.20230601.gappssmtp.com header.b="kOERifFJ"
X-Original-To: io-uring@vger.kernel.org
Received: from mail-il1-f180.google.com (mail-il1-f180.google.com [209.85.166.180])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 556C93F9FB
	for <io-uring@vger.kernel.org>; Wed, 16 Apr 2025 14:19:35 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.166.180
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1744813178; cv=none; b=KpaRCn+qs5R1tPpzAlj0Rp9rV/kSYo65082KLtAld2hwxKgVdetLscDcoB65KRqK3E93AKSDTJkQqsVPktZZXHjnhNuI4ieiZ/Bu+5WMTdgpmmVmPDF2k5NDYlmhMckOePNVPocEmEBrYd0yMGdRQBOwf5zY4M1JqMTAZZ7alJk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1744813178; c=relaxed/simple;
	bh=Kn8GewQMCt837Ur72dVjEJ2agTaNH8ObgZooVxRffzg=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=jP+Oc2bRYR6dKhf8zBlpME4mv/QHhQRxQ+FrnPKq5NY5f2gcf9HKdEzdwLKBqZfScLiTch9zONXFhjK+WEFxBIvgBSIVPT9AeGEUdwudBhIPsLzVrODEYrshgWgZU/t1zCrb23mZ8LdTVG+NB3AyOXfcA/CAuC27+dQos5I4nzU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=kernel.dk; spf=pass smtp.mailfrom=kernel.dk; dkim=pass (2048-bit key) header.d=kernel-dk.20230601.gappssmtp.com header.i=@kernel-dk.20230601.gappssmtp.com header.b=kOERifFJ; arc=none smtp.client-ip=209.85.166.180
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=kernel.dk
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=kernel.dk
Received: by mail-il1-f180.google.com with SMTP id e9e14a558f8ab-3d439dc0548so23178775ab.3
        for <io-uring@vger.kernel.org>; Wed, 16 Apr 2025 07:19:35 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernel-dk.20230601.gappssmtp.com; s=20230601; t=1744813174; x=1745417974; darn=vger.kernel.org;
        h=content-transfer-encoding:in-reply-to:from:content-language
         :references:cc:to:subject:user-agent:mime-version:date:message-id
         :from:to:cc:subject:date:message-id:reply-to;
        bh=JfAIOkjpjHNO0hyMEWOpAcY/kPLoFg/oJV0w72D5OhM=;
        b=kOERifFJh8ziaJ++/8whrC2ge3CsitIgzvRSCjp93VBt6W0Ju5GqEQALNzu/LSys29
         RSlriFQHx/MC1hobARzUQxI/GBg7l/7g2F1rjUP95LGoS7xhnO/VJiy4vIfbTEE22KHY
         DGdHEjEHPROc1s3zPq81K/Xrs8XfOHKtUvVHAeifhg9ZUFFfFuc5LfEOhQni6f1inube
         PaDLvHoM6s4iyvT9qwcJO2mnV7Xx6hzIKlLOoCuHYPjXEvMgtO9fOsNtYfi0uhx5YjrE
         uRD3jrEXwiUoOFTTVfqcc5MZpfsRGx0H3tiVqtpC+WqB+ZY3qisnI/Kbhi5R7DWXCgVS
         sIdQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1744813174; x=1745417974;
        h=content-transfer-encoding:in-reply-to:from:content-language
         :references:cc:to:subject:user-agent:mime-version:date:message-id
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=JfAIOkjpjHNO0hyMEWOpAcY/kPLoFg/oJV0w72D5OhM=;
        b=oZ1rhEkiZbtBlUll8/MORMka7BVecWU7fSXKngFfg3r+aYmYj5OVf+ojl/T2QM01hO
         LmwwnKgQbyi9pKgDtoXzuKppUpyUwlFtz7snyavtJwIgjLj/pLn9s6grTG+k3YjXBV6G
         XCa0aLs1cOM+88XeSGegOv+kmBaLFS10+EodLxm3/Uca58JHzQu+WIHwVCDP3RBglsn5
         rAQmK3988l3G3RLdMYF/nR3bvZ3OtlxhBfjt/CwURB1jXnxvnuC073PJU5JrxjeIDcaL
         WsPDlU528367r3c2rDxK7HfNfpK4DMz0ToHcFiWy3Wu5f0HsrHpmSNm/dq3I35RCDEjU
         9HPA==
X-Forwarded-Encrypted: i=1; AJvYcCUAGogrEQ27NW0mSpWnAHdKIQ4yWSKXc6UpEPgd5s7fBw3yCPBrQlIALwY0PbB0wrL4YlAPQwuIaA==@vger.kernel.org
X-Gm-Message-State: AOJu0Yy5ql356krzNQoJMv0Hax+z9xCLIIcVhD8qsKtodm8VAOsgaAIm
	bFigyyi6C9oEwe7/1PcKMxob9+FluNgdSJZPDTHv20S+a8PMBrC4PPfbCgpKS1Q=
X-Gm-Gg: ASbGncv5JcHnqevbUG9N+zTyJv3+8JNcJCG/Gm4osLOhcOwk9nsK3yKa2GtJF4LCh36
	IoLVKUCZg0DG7xtWJeqELYjDdMkWqazWbKGb4xNGfboy63NM8apseS5ALJE06o1bnwy8clBNQeL
	k21DLsOUuNI2blhMuJD4hoNLynsgdmywKlUnM7aYivS0uAOtbB0/KeY0VFb0Z7igGawAMeBDPtf
	RoHs42XiPAadvHpr1PSqfJQzQvqAPwJ2fbfb6bzRTdOhsjn6eyMF5a/58Bc5Her4Kr+PquLPKqJ
	JZTSXQUtS4EMDnqrPAqMqY8VewmNlYv0FG2A
X-Google-Smtp-Source: AGHT+IGBCs0Me+0RwnGVpKzHyE47gG1pmgiY5tpO5HWyRZrDQVdE05b859sEUsSWFeKLZBWcIkayEA==
X-Received: by 2002:a05:6e02:1487:b0:3d6:d162:be12 with SMTP id e9e14a558f8ab-3d815b6a8bbmr20961975ab.21.1744813174354;
        Wed, 16 Apr 2025 07:19:34 -0700 (PDT)
Received: from [192.168.1.116] ([96.43.243.2])
        by smtp.gmail.com with ESMTPSA id 8926c6da1cb9f-4f505e6ed19sm3647778173.133.2025.04.16.07.19.33
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Wed, 16 Apr 2025 07:19:33 -0700 (PDT)
Message-ID: <4ed32b40-47ee-43f8-b3e3-88fdc6ca60fa@kernel.dk>
Date: Wed, 16 Apr 2025 08:19:33 -0600
Precedence: bulk
X-Mailing-List: io-uring@vger.kernel.org
List-Id: <io-uring.vger.kernel.org>
List-Subscribe: <mailto:io-uring+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:io-uring+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH] io_uring/rsrc: send exact nr_segs for fixed buffer
To: Nitesh Shetty <nj.shetty@samsung.com>,
 Pavel Begunkov <asml.silence@gmail.com>
Cc: gost.dev@samsung.com, nitheshshetty@gmail.com, io-uring@vger.kernel.org,
 linux-kernel@vger.kernel.org
References: <CGME20250416055250epcas5p25fa8223a1bfeea5583ad8ba88c881a05@epcas5p2.samsung.com>
 <20250416054413.10431-1-nj.shetty@samsung.com>
Content-Language: en-US
From: Jens Axboe <axboe@kernel.dk>
In-Reply-To: <20250416054413.10431-1-nj.shetty@samsung.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit

On 4/15/25 11:44 PM, Nitesh Shetty wrote:
> Sending exact nr_segs, avoids bio split check and processing in
> block layer, which takes around 5%[1] of overall CPU utilization.
> 
> In our setup, we see overall improvement of IOPS from 7.15M to 7.65M [2]
> and 5% less CPU utilization.
> 
> [1]
>      3.52%  io_uring         [kernel.kallsyms]     [k] bio_split_rw_at
>      1.42%  io_uring         [kernel.kallsyms]     [k] bio_split_rw
>      0.62%  io_uring         [kernel.kallsyms]     [k] bio_submit_split
> 
> [2]
> sudo taskset -c 0,1 ./t/io_uring -b512 -d128 -c32 -s32 -p1 -F1 -B1 -n2
> -r4 /dev/nvme0n1 /dev/nvme1n1

This must be a regression, do you know which block/io_uring side commit
caused the splits to be done for fixed buffers?

> Signed-off-by: Nitesh Shetty <nj.shetty@samsung.com>
> ---
>  io_uring/rsrc.c | 3 +++
>  1 file changed, 3 insertions(+)
> 
> diff --git a/io_uring/rsrc.c b/io_uring/rsrc.c
> index b36c8825550e..6fd3a4a85a9c 100644
> --- a/io_uring/rsrc.c
> +++ b/io_uring/rsrc.c
> @@ -1096,6 +1096,9 @@ static int io_import_fixed(int ddir, struct iov_iter *iter,
>  			iter->iov_offset = offset & ((1UL << imu->folio_shift) - 1);
>  		}
>  	}
> +	iter->nr_segs = (iter->bvec->bv_offset + iter->iov_offset +
> +		iter->count + ((1UL << imu->folio_shift) - 1)) /
> +		(1UL << imu->folio_shift);

	iter->nr_segs = (iter->bvec->bv_offset + iter->iov_offset +
		iter->count + ((1UL << imu->folio_shift) - 1)) >> imu->folio_shift;

to avoid a division, seems worthwhile?

-- 
Jens Axboe

