Return-Path: <io-uring+bounces-3061-lists+io-uring=lfdr.de@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [139.178.88.99])
	by mail.lfdr.de (Postfix) with ESMTPS id 158CA96F5B3
	for <lists+io-uring@lfdr.de>; Fri,  6 Sep 2024 15:46:11 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id C943628502A
	for <lists+io-uring@lfdr.de>; Fri,  6 Sep 2024 13:46:09 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 080E71CEAB5;
	Fri,  6 Sep 2024 13:45:49 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="Sku/Ppou"
X-Original-To: io-uring@vger.kernel.org
Received: from mail-wm1-f52.google.com (mail-wm1-f52.google.com [209.85.128.52])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4A92B1CF2BE;
	Fri,  6 Sep 2024 13:45:47 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.128.52
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1725630348; cv=none; b=oTlpEq9gJi2T7xUYhVJ51eD/Z8YGWRcS9mPpbv8BGQLpUJTCHmjXRc+RUT8ec+YpjeRsbxnP4ifjmWpMWPOMEYYNy/W7akn4EVlQbtfA3SAHskaL8dNfZQCEuJdPR3JhnWZEOHTeLZ38sAUesYt3SRHC40te5Vaz/vAqWF3WvtY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1725630348; c=relaxed/simple;
	bh=inach8KQEv5iasAFMeIAgwU1+S1WtU/zg7volHwFdHc=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=DRjG8Rlf7zB1SrOQgSBt4nl3DP23T0jqATKeiVeZZTsCZcyYcgZ9wpm8CH29gkBI3lu6V26W4dJSa1/QUEd33cuambGFy/J0/VfLK1/XcrTj3ynBzbtkT1KIDv0GqAqXeSloE3VTapKvvWfrENM1leKXxrtg6/YA7zkFexrXEXU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=Sku/Ppou; arc=none smtp.client-ip=209.85.128.52
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Received: by mail-wm1-f52.google.com with SMTP id 5b1f17b1804b1-42c94eb9822so15676865e9.0;
        Fri, 06 Sep 2024 06:45:46 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1725630345; x=1726235145; darn=vger.kernel.org;
        h=content-transfer-encoding:in-reply-to:from:content-language
         :references:cc:to:subject:user-agent:mime-version:date:message-id
         :from:to:cc:subject:date:message-id:reply-to;
        bh=e5rkDQXOut8d6XYh86QFrj0XIhHkFOTu4z3B+AX019U=;
        b=Sku/PpouS0omuiYXrCZzeOU9ASZaq7lobjpPuOit7iUsP36BmPy1VJbrfIO+7+y7P9
         AHZiUbJ3YQtvpEtvK6QpskPPD4+3O7F47/WYEY1EFHoPobwS7j9qDECrZi4NM7dlf64G
         yxMCiLfskJNWcLPTyHtL6+NhdVjVKimlKm7ADa8mzmeGAj2pCkx0ToRezKTQwvJq8QoH
         QOibQm5Cx0pJV1nVB7IKkIUkWt6m+5R/m4pX7Jxcoc/EBGgxH3m4rK13GDEC5q4k929K
         vB6JrsXaKFo65/yYI2hjUO4J2/NGizCiQbY7XW0hqWT+ls9/taEISpwVYNlYyBW9JuqZ
         YZZQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1725630345; x=1726235145;
        h=content-transfer-encoding:in-reply-to:from:content-language
         :references:cc:to:subject:user-agent:mime-version:date:message-id
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=e5rkDQXOut8d6XYh86QFrj0XIhHkFOTu4z3B+AX019U=;
        b=gC1jau3dcZWa2SVhq6/wqhQYdhT6dBs/fq/h7Okwdt+7nY1Pym/tti77KLTAAJWvYK
         e3AOM05GcEn0MLH1g70kJ9BfWFXEMpH1YWbdpCGpkwP+rR22aXT2jtLRCk5wZ4av4tbs
         jGa4FSWHkKhcyk0pPqynqhZ15FQ8V9QliDjJhxThiVmKTILoAI2NQPM7Ox3RWqJVRgC5
         Y4zV9APvcAPwqJ6cFsuFBBKi7pFePDlLJCSHiYUl9CDSCaJ3HxHtx7jq+6GoRLHGsOvb
         0ERsX4SuGYkIOlYVaPS68GrfQJxdNbEaP8jo/EaopsGuK708LPB8N4ZyluLN3UgTicvp
         Jv0w==
X-Forwarded-Encrypted: i=1; AJvYcCV8IA/6vV12AAAVkzj0+mFT9nOZN5KGphaONT9+AItGwfF1uEa/1fVWHML/9GOXirSbE/1nnuAqDG6EWZA=@vger.kernel.org, AJvYcCWoMnVCi0U3Ggphhf5VdHK8Xqcnbj+mS2aPMSLKVXZ0h9eRfkNmz51K8rVlAdOCtVQUTnKJ1fIpug==@vger.kernel.org
X-Gm-Message-State: AOJu0YxsgfnVqUEIClorIOmZfRXld5ltFEPx/pYN/L3+LQ4KIN1NB9nU
	7PnKcteUDSeUJbf9Hf3j0tBKDq0yAI2WNzEDawifP5NLt5dNFNSrL6aASuJy
X-Google-Smtp-Source: AGHT+IG/XCVL4z/7Ye9O29fA20ZSqIscT4l23i6TAu3O+kwgWrn2f2H42cvgytF57iuKqhVL+wGmkg==
X-Received: by 2002:a5d:5e12:0:b0:378:89d8:8242 with SMTP id ffacd0b85a97d-37889d88432mr1349658f8f.26.1725630344889;
        Fri, 06 Sep 2024 06:45:44 -0700 (PDT)
Received: from [192.168.42.120] ([163.114.131.193])
        by smtp.gmail.com with ESMTPSA id a640c23a62f3a-a8a623e3401sm277350366b.197.2024.09.06.06.45.44
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Fri, 06 Sep 2024 06:45:44 -0700 (PDT)
Message-ID: <8837b91c-55d8-45e6-8a98-3389464cac97@gmail.com>
Date: Fri, 6 Sep 2024 14:46:18 +0100
Precedence: bulk
X-Mailing-List: io-uring@vger.kernel.org
List-Id: <io-uring.vger.kernel.org>
List-Subscribe: <mailto:io-uring+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:io-uring+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v3 7/8] block: add nowait flag for
 __blkdev_issue_zero_pages
To: Jens Axboe <axboe@kernel.dk>, io-uring@vger.kernel.org
Cc: Conrad Meyer <conradmeyer@meta.com>, linux-block@vger.kernel.org,
 linux-mm@kvack.org, Christoph Hellwig <hch@infradead.org>
References: <cover.1725459175.git.asml.silence@gmail.com>
 <292fa1c611adb064efe16ab741aad65c2128ada8.1725459175.git.asml.silence@gmail.com>
 <862f125c-9710-4abc-a229-5f7eb9931ed5@kernel.dk>
Content-Language: en-US
From: Pavel Begunkov <asml.silence@gmail.com>
In-Reply-To: <862f125c-9710-4abc-a229-5f7eb9931ed5@kernel.dk>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit

On 9/6/24 14:41, Jens Axboe wrote:
> On 9/4/24 8:18 AM, Pavel Begunkov wrote:
>> diff --git a/block/blk-lib.c b/block/blk-lib.c
>> index c94c67a75f7e..a16b7c7965e8 100644
>> --- a/block/blk-lib.c
>> +++ b/block/blk-lib.c
>> @@ -193,20 +193,32 @@ static unsigned int __blkdev_sectors_to_bio_pages(sector_t nr_sects)
>>   	return min(pages, (sector_t)BIO_MAX_VECS);
>>   }
>>   
>> -static void __blkdev_issue_zero_pages(struct block_device *bdev,
>> +int blkdev_issue_zero_pages_bio(struct block_device *bdev,
>>   		sector_t sector, sector_t nr_sects, gfp_t gfp_mask,
>>   		struct bio **biop, unsigned int flags)
>>   {
>> +	blk_opf_t opf = REQ_OP_WRITE;
>> +
>> +	if (flags & BLKDEV_ZERO_PAGES_NOWAIT) {
>> +		sector_t max_bio_sectors = BIO_MAX_VECS << PAGE_SECTORS_SHIFT;
>> +
>> +		if (nr_sects > max_bio_sectors)
>> +			return -EAGAIN;
>> +		opf |= REQ_NOWAIT;
>> +	}
>> +
>>   	while (nr_sects) {
>>   		unsigned int nr_vecs = __blkdev_sectors_to_bio_pages(nr_sects);
>>   		struct bio *bio;
>>   
>>   		bio = bio_alloc(bdev, nr_vecs, REQ_OP_WRITE, gfp_mask);
> 
> as per the kernel test bot, I guess this one should be using opf rather
> than REQ_OP_WRITE.

Right, I overlooked it. I'm going to resend the series later today.

-- 
Pavel Begunkov

