Return-Path: <io-uring+bounces-436-lists+io-uring=lfdr.de@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [147.75.80.249])
	by mail.lfdr.de (Postfix) with ESMTPS id 47A748334F9
	for <lists+io-uring@lfdr.de>; Sat, 20 Jan 2024 15:09:55 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id EDF8B1F22550
	for <lists+io-uring@lfdr.de>; Sat, 20 Jan 2024 14:09:54 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 143FD1078F;
	Sat, 20 Jan 2024 14:09:46 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="TowZHYVC"
X-Original-To: io-uring@vger.kernel.org
Received: from mail-pf1-f174.google.com (mail-pf1-f174.google.com [209.85.210.174])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B346A10785;
	Sat, 20 Jan 2024 14:09:44 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.210.174
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1705759786; cv=none; b=Kh+1HCZwtqkkDPI8ygHApoavXiXixcr0mFsLB5cduFQWMImZ3KNoFSnOe0BvwQbHlNJEi9ZtvATvci+pGUefwKetZ500Cln8981VHx3T0QQGrxZqfEzWRTLoMi0Ywkj8TIYN1laS7MUMCVrawhQgIHFK+fQOiIUpRSWV5gHfEkg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1705759786; c=relaxed/simple;
	bh=cof9HA1gs5d67ii3dH1JN87iOJ2ccqcZQ33y3xLHpJw=;
	h=Message-ID:Date:MIME-Version:Subject:To:References:From:
	 In-Reply-To:Content-Type; b=T4KFo9ufa7A9tdVbmHk0acDf2+B4LsMC7oCJS3zZ0ENypViNvircFEtDgFIxJhV5fcfUvbO8J0cNgKCfUidl32VzIYqsDHhOCPfIZOXa9VOXLrLB6jTmv1/EsdJZbFKkLKEL+S27BVvjjn7e+tcnQHQBJypP4jfoKTWcRjh+AlQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=TowZHYVC; arc=none smtp.client-ip=209.85.210.174
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Received: by mail-pf1-f174.google.com with SMTP id d2e1a72fcca58-6dbce74f917so260578b3a.0;
        Sat, 20 Jan 2024 06:09:44 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1705759784; x=1706364584; darn=vger.kernel.org;
        h=content-transfer-encoding:in-reply-to:from:references:to
         :content-language:subject:user-agent:mime-version:date:message-id
         :from:to:cc:subject:date:message-id:reply-to;
        bh=DuB2zY/sIBCZIR6AGER+yOmIgXzfGEjeeHajPPcZAEQ=;
        b=TowZHYVCJO5OkuxOxvt3eb3F15yRVW35xVMXAXvvYK089imwnGD9/oHjfZWx1Bx0fz
         fQebEidXNxVXCeh9TbsOCN1q25DmfSzV1cPUo1WDOjTlq2AXeYLUMVKd5kHhfM+XsSZt
         xsq25U6A4W8ie+BQVDVY3wSnuQzN2Y4ph3W61QZTGK5OvqB3vhKUquEgdi9ut/P0uvjk
         EvumOxrJNosBKajLOk0L28xIb+dKEDmXniqJU1hk0aD0/QkvsReu5lr68n/xkgv0vGzK
         WMDUN46H6/C2i6lCgoGBvwKwgthzvQbtTnBzYeqqVfYXR+123KYlc4LB17iR4Ig+2jb1
         L36Q==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1705759784; x=1706364584;
        h=content-transfer-encoding:in-reply-to:from:references:to
         :content-language:subject:user-agent:mime-version:date:message-id
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=DuB2zY/sIBCZIR6AGER+yOmIgXzfGEjeeHajPPcZAEQ=;
        b=QAtj6X6VKV78EjJfYJ06BLE9taqrIsepWhpV7SUpKceymNKrjUqZJwa0I4KBIblSnD
         k2lIzpT/dQPlFkR+pd+hZPYo2U3jDooewg/UYHcYnioPxXbcCkCe3sPLlzSfg25EE4Kg
         4XrVv9e0vw6p2AacAp9sjPEHa8ix8KX++6IzSHyf60k5m5nK2Jwp/mugfgq7Hf0ntFoD
         gFL6rB+qVW1Yn10pMpBFI5Pi9FfMHqV+Kpy71OR0KDRZPKPqRk3gjP565ZyShCo7Cxh/
         vHGFszNGl7PCtRcdzyDQdBV25+h/FfIPZzM5ZxJjx/okvoVCzGwMxyJv/ArgAPR7ivcL
         aKMQ==
X-Gm-Message-State: AOJu0Ywr42TaRtAo5ju8lMqNLZ1G2s+x0XcBMEU7lvv6vDbW1tdDiZId
	6Bvb4Etq9SABO0OWQRiovrKxkeVGnxomJBLTMJVfreOt7UrC7v44
X-Google-Smtp-Source: AGHT+IFLFjtGlXPL8Rmq+bW+Hpwap+Wq/0srn/1Hn6rHnGXSIvPI9whoZ4Y9N8nn+zaiAVF7GsutcA==
X-Received: by 2002:a05:6a00:390d:b0:6d9:3d15:d506 with SMTP id fh13-20020a056a00390d00b006d93d15d506mr693067pfb.53.1705759783987;
        Sat, 20 Jan 2024 06:09:43 -0800 (PST)
Received: from ?IPV6:2406:7400:94:dd16:106d:864:6ca4:72b7? ([2406:7400:94:dd16:106d:864:6ca4:72b7])
        by smtp.gmail.com with ESMTPSA id m6-20020a62f206000000b006dbd1678512sm991139pfh.162.2024.01.20.06.09.40
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Sat, 20 Jan 2024 06:09:43 -0800 (PST)
Message-ID: <df87e88a-adf6-4ba1-ba80-baccde2ecc28@gmail.com>
Date: Sat, 20 Jan 2024 19:39:40 +0530
Precedence: bulk
X-Mailing-List: io-uring@vger.kernel.org
List-Id: <io-uring.vger.kernel.org>
List-Subscribe: <mailto:io-uring+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:io-uring+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH] iouring:added boundary value check for io_uring_group
 systl
Content-Language: en-US
To: Jens Axboe <axboe@kernel.dk>, corbet@lwn.net, asml.silence@gmail.com,
 ribalda@chromium.org, rostedt@goodmis.org, bhe@redhat.com,
 akpm@linux-foundation.org, matteorizzo@google.com, ardb@kernel.org,
 alexghiti@rivosinc.com, linux-doc@vger.kernel.org,
 linux-kernel@vger.kernel.org, io-uring@vger.kernel.org
References: <20240115124925.1735-1-subramanya.swamy.linux@gmail.com>
 <71ba9456-45a7-4042-8716-ccd68cc7329f@kernel.dk>
From: Subramanya Swamy <subramanya.swamy.linux@gmail.com>
In-Reply-To: <71ba9456-45a7-4042-8716-ccd68cc7329f@kernel.dk>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit

Hi Jens,

            Thank you for reviewing the patch.

On 17/01/24 03:02, Jens Axboe wrote:
> On 1/15/24 5:49 AM, Subramanya Swamy wrote:
>> diff --git a/io_uring/io_uring.c b/io_uring/io_uring.c
>> index 09b6d860deba..0ed91b69643d 100644
>> --- a/io_uring/io_uring.c
>> +++ b/io_uring/io_uring.c
>> @@ -146,7 +146,9 @@ static void io_queue_sqe(struct io_kiocb *req);
>>   struct kmem_cache *req_cachep;
>>   
>>   static int __read_mostly sysctl_io_uring_disabled;
>> -static int __read_mostly sysctl_io_uring_group = -1;
>> +static unsigned int __read_mostly sysctl_io_uring_group;
>> +static unsigned int min_gid;
>> +static unsigned int max_gid  = 4294967294;  /*4294967294 is the max guid*/
> As per the compile bot, these need to be under CONFIG_SYSCTL. I'd
> recommend just moving them a few lines further down to do that.
>
> I think this would be cleaner:
>
> static unsigned int max_gid = ((gid_t) ~0U) - 1;
>
> however, as it explains why the value is what it is rather than being
> some magic constant.
Will add these changes in v2

-- 
Best Regards
Subramanya


