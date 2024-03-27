Return-Path: <io-uring+bounces-1267-lists+io-uring=lfdr.de@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [147.75.199.223])
	by mail.lfdr.de (Postfix) with ESMTPS id C25AE88F024
	for <lists+io-uring@lfdr.de>; Wed, 27 Mar 2024 21:32:19 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id F37A91C27E93
	for <lists+io-uring@lfdr.de>; Wed, 27 Mar 2024 20:32:18 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 6C678153563;
	Wed, 27 Mar 2024 20:31:58 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel-dk.20230601.gappssmtp.com header.i=@kernel-dk.20230601.gappssmtp.com header.b="wVJdJCcK"
X-Original-To: io-uring@vger.kernel.org
Received: from mail-pf1-f174.google.com (mail-pf1-f174.google.com [209.85.210.174])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id CADD1152526
	for <io-uring@vger.kernel.org>; Wed, 27 Mar 2024 20:31:55 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.210.174
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1711571518; cv=none; b=STles35RWsEduXNu7xPjcBcC0pdAfz1PX5cGSbncfpvO8RIKAZETChn5KhH2nfQBOXYON7PqG35do0aHBWcxPXYORMvVTuklL33g87aO/nEWd5UyjzJ9b6S3cvzY1IS8SZKhMp4CpTGCaokhGZAO+uLwTV2Kanu4sbKRGlWxSXY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1711571518; c=relaxed/simple;
	bh=J1LFlkZD+GOL7qB6nVEMYvKM7WfPOPv1LSnvFQ3b8Cs=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=o3EB3JxVQpVX+ckgo8ClZlqMzfC5RVo6oW1PKWUQ3W8Mpoh2K42hS6TVnNlNyCgojdmAc77ACHigyx9GOKBXPeF6jxaBMA60KjnWVoyawBeqTBScYvVSVJc7CjyLgCJQu56DNWtb/RnyVeJ0S/HISP2SYJwPS8VapNKQFbcoC0Y=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=kernel.dk; spf=pass smtp.mailfrom=kernel.dk; dkim=pass (2048-bit key) header.d=kernel-dk.20230601.gappssmtp.com header.i=@kernel-dk.20230601.gappssmtp.com header.b=wVJdJCcK; arc=none smtp.client-ip=209.85.210.174
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=kernel.dk
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=kernel.dk
Received: by mail-pf1-f174.google.com with SMTP id d2e1a72fcca58-6e694337fffso75793b3a.1
        for <io-uring@vger.kernel.org>; Wed, 27 Mar 2024 13:31:55 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernel-dk.20230601.gappssmtp.com; s=20230601; t=1711571515; x=1712176315; darn=vger.kernel.org;
        h=content-transfer-encoding:in-reply-to:from:references:cc:to
         :content-language:subject:user-agent:mime-version:date:message-id
         :from:to:cc:subject:date:message-id:reply-to;
        bh=h0KZ9y/CXOivU7Q2KdflQnW13FIBopyrf7ldFMV4Pv8=;
        b=wVJdJCcKTasWNSft/Kb1Uv/wE81pSeNejT9lhJzE8RZ4VqC9dnUmuDnzLNfYLLbSvM
         9GylbNY5+zXSFEDqR1wEXbOmaHMC5/QeyuLiRhPdomM9e3S7kzZDA0urc8N1m20bP4Iq
         mZuzlsYg1zXw3phm7BTNYYq+4Qf3t6W8fYrZPNwn1nX3V6aVZUO4IGzDNEiG6g7PFXB3
         soS7+q/PQbt+HZTHChP3D03EFRRPOryOAtaEo2dBRl5iTJD3AT3B3lXIxtpmV1R/jaOZ
         W/V466rQoC74GlCcZkbp7vA1OmCeLcSBTgdkq88h0a9s/mJFAnSpvoaGT+c/eiF7Wwag
         d9Fw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1711571515; x=1712176315;
        h=content-transfer-encoding:in-reply-to:from:references:cc:to
         :content-language:subject:user-agent:mime-version:date:message-id
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=h0KZ9y/CXOivU7Q2KdflQnW13FIBopyrf7ldFMV4Pv8=;
        b=FvS1lMj63kZr2LsLaWx3aiUbjptsTMHv/eRumd/nXqz9YJHBGPDjXZhn1WdpiR3QA6
         TH3y5S2WtRrVY5ApeGf/jpfAEO+NX6F0eksseITEMt4PZLe2cNMBznYsKQYGpDrJ+LBY
         7LnKu6sZacslXFSN4ILsiqmP8zfrXGYHtn0nDhnotbeA2qR1VkkBCWZJf7DOE+tdCPlk
         0BpTSjAN2rY/TklawTr2wmbLmHCcELJCVxwS5tcSiTk77fV5/fwkpDVUZIogRwzAlurh
         6mgQgH/c2du4lACc7BbcHAdzPuumkK1xaXVvydunCG7XJK1hutt5LEJr9ygN786CrYga
         KFsg==
X-Gm-Message-State: AOJu0Yzga+n9ozTWcr/utNSS11sph1o77tIKmsJmHlzeypZrTcQWpWTV
	RDRgTyNORxQqTPEo/6xmnlV41gO4tqkHg8bU0fQCkb01FgOLK9PXqQLCDGwqJaY=
X-Google-Smtp-Source: AGHT+IHKbhghmCqkDzdNvQ/I/aObJPSsEO8l59TOzO6i9LegFjaiasTBFMtUcyYacvSgJ9brp2WI6w==
X-Received: by 2002:a05:6a00:929e:b0:6ea:b1f5:8aa with SMTP id jw30-20020a056a00929e00b006eab1f508aamr1051982pfb.3.1711571515065;
        Wed, 27 Mar 2024 13:31:55 -0700 (PDT)
Received: from ?IPV6:2620:10d:c096:122::1:2343? ([2620:10d:c090:600::1:bb1e])
        by smtp.gmail.com with ESMTPSA id r18-20020aa78b92000000b006e647716b6esm8617468pfd.149.2024.03.27.13.31.54
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Wed, 27 Mar 2024 13:31:54 -0700 (PDT)
Message-ID: <609b8fa6-731b-4cb1-b649-ff81cce325a7@kernel.dk>
Date: Wed, 27 Mar 2024 14:31:51 -0600
Precedence: bulk
X-Mailing-List: io-uring@vger.kernel.org
List-Id: <io-uring.vger.kernel.org>
List-Subscribe: <mailto:io-uring+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:io-uring+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH 03/10] io_uring: use vmap() for ring mapping
Content-Language: en-US
To: Jeff Moyer <jmoyer@redhat.com>
Cc: io-uring@vger.kernel.org
References: <20240327191933.607220-1-axboe@kernel.dk>
 <20240327191933.607220-4-axboe@kernel.dk>
 <x49v8574dwk.fsf@segfault.usersys.redhat.com>
From: Jens Axboe <axboe@kernel.dk>
In-Reply-To: <x49v8574dwk.fsf@segfault.usersys.redhat.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit

On 3/27/24 2:29 PM, Jeff Moyer wrote:
> Jens Axboe <axboe@kernel.dk> writes:
> 
>> This is the last holdout which does odd page checking, convert it to
>> vmap just like what is done for the non-mmap path.
>>
>> Signed-off-by: Jens Axboe <axboe@kernel.dk>
>> ---
>>  io_uring/io_uring.c | 40 +++++++++-------------------------------
>>  1 file changed, 9 insertions(+), 31 deletions(-)
>>
>> diff --git a/io_uring/io_uring.c b/io_uring/io_uring.c
>> index 29d0c1764aab..67c93b290ed9 100644
>> --- a/io_uring/io_uring.c
>> +++ b/io_uring/io_uring.c
>> @@ -63,7 +63,6 @@
>>  #include <linux/sched/mm.h>
>>  #include <linux/uaccess.h>
>>  #include <linux/nospec.h>
>> -#include <linux/highmem.h>
>>  #include <linux/fsnotify.h>
>>  #include <linux/fadvise.h>
>>  #include <linux/task_work.h>
>> @@ -2650,7 +2649,7 @@ static void *__io_uaddr_map(struct page ***pages, unsigned short *npages,
>>  	struct page **page_array;
>>  	unsigned int nr_pages;
>>  	void *page_addr;
>> -	int ret, i, pinned;
>> +	int ret, pinned;
>>  
>>  	*npages = 0;
>>  
>> @@ -2659,8 +2658,6 @@ static void *__io_uaddr_map(struct page ***pages, unsigned short *npages,
>>  
>>  	nr_pages = (size + PAGE_SIZE - 1) >> PAGE_SHIFT;
>>  	if (nr_pages > USHRT_MAX)
>> -		return ERR_PTR(-EINVAL);
>> -	page_array = kvmalloc_array(nr_pages, sizeof(struct page *), GFP_KERNEL);
>>  	if (!page_array)
>>  		return ERR_PTR(-ENOMEM);
> 
> That's not right.  ;-)  It gets fixed up (removed) in the next patch.

Ah crap, I had to re-order the series this morning before posting, I
guess that snuck in. Let me build/test each in order and fix this hunk
up.

-- 
Jens Axboe


