Return-Path: <io-uring+bounces-3060-lists+io-uring=lfdr.de@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [147.75.199.223])
	by mail.lfdr.de (Postfix) with ESMTPS id CDF6196F5A0
	for <lists+io-uring@lfdr.de>; Fri,  6 Sep 2024 15:41:11 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id E036F1C21FAC
	for <lists+io-uring@lfdr.de>; Fri,  6 Sep 2024 13:41:10 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 7BE0A12F5A5;
	Fri,  6 Sep 2024 13:41:07 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel-dk.20230601.gappssmtp.com header.i=@kernel-dk.20230601.gappssmtp.com header.b="IXYCSqEp"
X-Original-To: io-uring@vger.kernel.org
Received: from mail-pg1-f181.google.com (mail-pg1-f181.google.com [209.85.215.181])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id BEFD91552FA
	for <io-uring@vger.kernel.org>; Fri,  6 Sep 2024 13:41:05 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.215.181
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1725630067; cv=none; b=d1jc5LIDV5uXSHx/Gp131216UFFcdqfv2RsBfk5kC3oBDQ4h2qJXAI6TU80jbSl32IY7rOiucAx7Pl7DUWxfcsYpp13XULt1pCPDRZVtdBzWGjHewfFZezvS1c5SNyfqNgNcwcZwC54xSdughsTb8YcDcJqbQ6M+2V9JLYkMz2o=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1725630067; c=relaxed/simple;
	bh=tFiZXZrgfh30iPvJURj9xGucQfE0u9+XD65LJmNI9Qw=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=iEHSshd3cxWWX5LxXYHGFWWodAZ2KNg89LqIEfQKTLTjFLCJe12va1fnYNgV+ixXZ8n0kLxQC0mhEkTVqPn1vVs6lr3hTQIiakcKHqMsn+paRcYcqxXqfUaQaoGVMBHdWzRO8MB27wIhXisDOMK53PS+GcBOtHHeEBQXBtbwezQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=kernel.dk; spf=pass smtp.mailfrom=kernel.dk; dkim=pass (2048-bit key) header.d=kernel-dk.20230601.gappssmtp.com header.i=@kernel-dk.20230601.gappssmtp.com header.b=IXYCSqEp; arc=none smtp.client-ip=209.85.215.181
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=kernel.dk
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=kernel.dk
Received: by mail-pg1-f181.google.com with SMTP id 41be03b00d2f7-7d7a1b066d7so317484a12.3
        for <io-uring@vger.kernel.org>; Fri, 06 Sep 2024 06:41:05 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernel-dk.20230601.gappssmtp.com; s=20230601; t=1725630065; x=1726234865; darn=vger.kernel.org;
        h=content-transfer-encoding:in-reply-to:from:content-language
         :references:cc:to:subject:user-agent:mime-version:date:message-id
         :from:to:cc:subject:date:message-id:reply-to;
        bh=JRirsGjPeUp2chDtEYW/fu/UMEDf6TFEgxx2jXP3/Pg=;
        b=IXYCSqEpNz2MV6t7t4NCB68KRrAri4AjEBd9A3GbweiPNtyTul6iTQuW5X+IHEqZwB
         F44u8/3nY3WUohMQXFUPmfjT4dx46EnwKPKz5UKoDw+LuMODRFfTXRYy+bjY9hpyQHSS
         0b0vK64/j6Qo0sogAJ+/Raf7QHQ/LSA8eMBcEQ33X2DEj5EHTvEwoskafAwzTSwqqpMz
         AgNIPGc1B5ekcWhqIHTyEOMHPT9Ic6aruT1Vh900IPKZW4LcObA7L/juqYNGoESwICu9
         7BDxMrbngQlO9ifF6PAZMOMSIX0ppld2vM8m0yqXremnJgLk6PgNApVTR7q479cae571
         2DKw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1725630065; x=1726234865;
        h=content-transfer-encoding:in-reply-to:from:content-language
         :references:cc:to:subject:user-agent:mime-version:date:message-id
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=JRirsGjPeUp2chDtEYW/fu/UMEDf6TFEgxx2jXP3/Pg=;
        b=N1643dKx0VLXyqHfdugF7uIV3A5/G7kvl6nlb0ytCx7hi9BZyHEL0RH7cTfcW+nm7W
         ex9oogHic38VsMAe/W+ZiTRYwCpTjXwFNfrtbwRohTXHPQLAvFN0a+9imJK4GqFIqIAP
         AOZbgs/h46kSOLWnE2cv7kZfF4/DV/Nz7taX8PKqC7r3rayxEElBZMp0pHKf+vqkxeGs
         GkoVynM2iHvQcZ30PRtLpaQttidhp0YYt+LjCBfzQlX8A1kGMUXdURsD5lSucWcjvIpr
         wvgN84ANDdVRexOl6i5zY6Rxmhi1IBqCRhf4rvxoHvHBuIiXAsS7m+DuAEVqCi+/AB1/
         zEpA==
X-Forwarded-Encrypted: i=1; AJvYcCV9UwHb6b4s+feea6YiB1HLWtoCBh4imVZ0T4Gxc5GHbUN3eQ+tJG1k+SFiuuQVB4MKmyC0lf2pUg==@vger.kernel.org
X-Gm-Message-State: AOJu0Yy+VoQS2tqQt2bdqjlsKHXzo1IeUCx+9SF/OU8h7rBNcm22fFoM
	cJEnI7PEAZ675JOR2B6Wz1wsgjYxntWrav+fbJYVzbQtnDVPIzOutbe4GoP8mYuEKbZ5d3b6wol
	x
X-Google-Smtp-Source: AGHT+IGeJ6M6dQjSLqy1fgzqwmrtr3wk/1kaLXDHkr4qNURYJIsAGjcI6TVVPF8Mlyve939Cnkj3Lw==
X-Received: by 2002:a05:6a21:3942:b0:1cc:dedd:d8ff with SMTP id adf61e73a8af0-1cf1d1e0709mr2780890637.43.1725630065079;
        Fri, 06 Sep 2024 06:41:05 -0700 (PDT)
Received: from [192.168.1.150] ([198.8.77.157])
        by smtp.gmail.com with ESMTPSA id d2e1a72fcca58-717785331dasm4830923b3a.73.2024.09.06.06.41.02
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Fri, 06 Sep 2024 06:41:04 -0700 (PDT)
Message-ID: <862f125c-9710-4abc-a229-5f7eb9931ed5@kernel.dk>
Date: Fri, 6 Sep 2024 07:41:01 -0600
Precedence: bulk
X-Mailing-List: io-uring@vger.kernel.org
List-Id: <io-uring.vger.kernel.org>
List-Subscribe: <mailto:io-uring+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:io-uring+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v3 7/8] block: add nowait flag for
 __blkdev_issue_zero_pages
To: Pavel Begunkov <asml.silence@gmail.com>, io-uring@vger.kernel.org
Cc: Conrad Meyer <conradmeyer@meta.com>, linux-block@vger.kernel.org,
 linux-mm@kvack.org, Christoph Hellwig <hch@infradead.org>
References: <cover.1725459175.git.asml.silence@gmail.com>
 <292fa1c611adb064efe16ab741aad65c2128ada8.1725459175.git.asml.silence@gmail.com>
Content-Language: en-US
From: Jens Axboe <axboe@kernel.dk>
In-Reply-To: <292fa1c611adb064efe16ab741aad65c2128ada8.1725459175.git.asml.silence@gmail.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit

On 9/4/24 8:18 AM, Pavel Begunkov wrote:
> diff --git a/block/blk-lib.c b/block/blk-lib.c
> index c94c67a75f7e..a16b7c7965e8 100644
> --- a/block/blk-lib.c
> +++ b/block/blk-lib.c
> @@ -193,20 +193,32 @@ static unsigned int __blkdev_sectors_to_bio_pages(sector_t nr_sects)
>  	return min(pages, (sector_t)BIO_MAX_VECS);
>  }
>  
> -static void __blkdev_issue_zero_pages(struct block_device *bdev,
> +int blkdev_issue_zero_pages_bio(struct block_device *bdev,
>  		sector_t sector, sector_t nr_sects, gfp_t gfp_mask,
>  		struct bio **biop, unsigned int flags)
>  {
> +	blk_opf_t opf = REQ_OP_WRITE;
> +
> +	if (flags & BLKDEV_ZERO_PAGES_NOWAIT) {
> +		sector_t max_bio_sectors = BIO_MAX_VECS << PAGE_SECTORS_SHIFT;
> +
> +		if (nr_sects > max_bio_sectors)
> +			return -EAGAIN;
> +		opf |= REQ_NOWAIT;
> +	}
> +
>  	while (nr_sects) {
>  		unsigned int nr_vecs = __blkdev_sectors_to_bio_pages(nr_sects);
>  		struct bio *bio;
>  
>  		bio = bio_alloc(bdev, nr_vecs, REQ_OP_WRITE, gfp_mask);

as per the kernel test bot, I guess this one should be using opf rather
than REQ_OP_WRITE.

-- 
Jens Axboe


