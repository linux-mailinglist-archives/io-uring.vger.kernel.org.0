Return-Path: <io-uring+bounces-4696-lists+io-uring=lfdr.de@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [139.178.88.99])
	by mail.lfdr.de (Postfix) with ESMTPS id A78969C8DC7
	for <lists+io-uring@lfdr.de>; Thu, 14 Nov 2024 16:21:55 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 6C502285B5F
	for <lists+io-uring@lfdr.de>; Thu, 14 Nov 2024 15:21:54 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id AB87E13AD39;
	Thu, 14 Nov 2024 15:21:51 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel-dk.20230601.gappssmtp.com header.i=@kernel-dk.20230601.gappssmtp.com header.b="HnjLBj06"
X-Original-To: io-uring@vger.kernel.org
Received: from mail-oi1-f173.google.com (mail-oi1-f173.google.com [209.85.167.173])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id F2CBD2C859
	for <io-uring@vger.kernel.org>; Thu, 14 Nov 2024 15:21:49 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.167.173
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1731597711; cv=none; b=Tza1aQs1+iX4u0+QzMNnsPiLv8CRLXpapNZ4O04Q7pn/T6glTDE7f9gTBEiXcl4T3FE9zW7wl4x2D0qBmDMgBqnVxD2jdOHmr/6TsyBzfVdQLJVHF7oRLeq2AWLwbz5a2JhV1Z+T/hUrMCs2JA/vAPu53WLj9OuvKXbWHOvyvtQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1731597711; c=relaxed/simple;
	bh=TkTDD2RBDV7sIIVkEaor+Jhu6eLvbT0o3IVngzyAups=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=uzHIGbDwv0zAcZPOtOguqkLkkMb1rXJJ5M2iCKFETDxDTGhrxzChVhkj5kvQXZOPkPnzH4zJaxpnXtX2D/5I1B+q6CtRxQNWGjPAsj9ehcL5mQ4grTlcOepcMT6H71NQKLWKdgOh/blUT6aZ4b9BIczJZ2XCy5JhSs0D7Ku5Ldc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=kernel.dk; spf=pass smtp.mailfrom=kernel.dk; dkim=pass (2048-bit key) header.d=kernel-dk.20230601.gappssmtp.com header.i=@kernel-dk.20230601.gappssmtp.com header.b=HnjLBj06; arc=none smtp.client-ip=209.85.167.173
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=kernel.dk
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=kernel.dk
Received: by mail-oi1-f173.google.com with SMTP id 5614622812f47-3e5f835c024so408253b6e.2
        for <io-uring@vger.kernel.org>; Thu, 14 Nov 2024 07:21:49 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernel-dk.20230601.gappssmtp.com; s=20230601; t=1731597709; x=1732202509; darn=vger.kernel.org;
        h=content-transfer-encoding:in-reply-to:from:content-language
         :references:cc:to:subject:user-agent:mime-version:date:message-id
         :from:to:cc:subject:date:message-id:reply-to;
        bh=IhiHo84MP1UBxEQIr32cazmzolaVBZwyLy4hsoyUvpc=;
        b=HnjLBj06scMtBlPzU9qXfkExkbBRNTLuTk/8QVqUEMAF2zzAFhLHD6Kvibaekgvkgq
         xxvCWFEVPNokRwMkfeisNklHaz9ZW/EmCNfqd1weCGsQIV3WlC5V2cqMKVzBxYvsUWK7
         y91qKC/DJWoHIsNpbvUAMK2+QKR9uDp8hqB/WuN9JZLETp310IFJLvXKO2V2h+GwY3YL
         WYE5oj7MzYPrwtoqq50x9hK4Rg8A+6ukj7b6bJBvPxslbd/1tLju2CXsIQxi9Xin67Uh
         YodL1Zpa4bzX9eYci5lsYNAAplVl3hHDbwzjm/paL4c93OaJnVWuF2EjYzvwiKzdB7hK
         z04w==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1731597709; x=1732202509;
        h=content-transfer-encoding:in-reply-to:from:content-language
         :references:cc:to:subject:user-agent:mime-version:date:message-id
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=IhiHo84MP1UBxEQIr32cazmzolaVBZwyLy4hsoyUvpc=;
        b=GPiRj/wp14mCDlorcUEHqaL679+tAJ6/hK+zhxU/Yv7WffYO2Jx4MMeY9YXqQpOnFh
         uct0iecv/R1CUSiTJm4J5asxRrwdKxNdj87+PWzhId/xff0VRMCTIDtg3NM0gbjIlVek
         Zv61oaTmpL+pbWKBiucKO+VGW3j9ccXhI67H1O8HleSwgPHzRXUXE8SX93FWTuGoaYcd
         vwOVPYPQFZsVKbdZPUkN0yEU6d01OXiJCmYrbXKRtCEdc1CUTLJlxT6RZ1fiQ+5BG0OM
         h5cxrAnAkVzpUpPI8EMT5Q/mZ3peuXrmDtnK6gsLLFHW9I2nAP/gE/wZFfqPaqcExbd4
         W2nQ==
X-Gm-Message-State: AOJu0Yw85NOJuyGeO/oz45EX94xP4T4k8bwW55m3Nv8vp79SbhtYn1iW
	5T6DNLmkcnKnN18q8ee2bN3SXB6FNLi68cIVC7WUs5mYYsImjv+r30+pv+MQPKs=
X-Google-Smtp-Source: AGHT+IF2xM5cF5lrcm7z3Ppt5W2zSRmGCfJHS2qO+H9XY0ibX96ffRlATC1Ljsm4ZQkP68yXaIXCiA==
X-Received: by 2002:a05:6808:68d:b0:3e7:a494:ae6d with SMTP id 5614622812f47-3e7a494b2d6mr11900976b6e.42.1731597708919;
        Thu, 14 Nov 2024 07:21:48 -0800 (PST)
Received: from [192.168.1.116] ([96.43.243.2])
        by smtp.gmail.com with ESMTPSA id 5614622812f47-3e7b8597a0dsm354160b6e.8.2024.11.14.07.21.47
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Thu, 14 Nov 2024 07:21:48 -0800 (PST)
Message-ID: <3aada5a2-074a-45e8-882c-0302cae4c41b@kernel.dk>
Date: Thu, 14 Nov 2024 08:21:47 -0700
Precedence: bulk
X-Mailing-List: io-uring@vger.kernel.org
List-Id: <io-uring.vger.kernel.org>
List-Subscribe: <mailto:io-uring+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:io-uring+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH liburing v2] test: add test cases for hybrid iopoll
To: hexue <xue01.he@samsung.com>, asml.silence@gmail.com
Cc: io-uring@vger.kernel.org, linux-kernel@vger.kernel.org
References: <CGME20241114050337epcas5p174214fb58aedefee4077447fa71b70f0@epcas5p1.samsung.com>
 <20241114050330.4006367-1-xue01.he@samsung.com>
Content-Language: en-US
From: Jens Axboe <axboe@kernel.dk>
In-Reply-To: <20241114050330.4006367-1-xue01.he@samsung.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit

On 11/13/24 10:03 PM, hexue wrote:
> diff --git a/man/io_uring_setup.2 b/man/io_uring_setup.2
> index 2f87783..fa928fa 100644
> --- a/man/io_uring_setup.2
> +++ b/man/io_uring_setup.2
> @@ -78,7 +78,15 @@ in question. For NVMe devices, the nvme driver must be loaded with the
>  parameter set to the desired number of polling queues. The polling queues
>  will be shared appropriately between the CPUs in the system, if the number
>  is less than the number of online CPU threads.
> -
> +.TP
> +.B IORING_SETUP_HYBRID_IOPOLL
> +This flag must setup with

This flag must be used with

> +.B IORING_SETUP_IOPOLL
> +flag. hybrid poll is a new

Like before, skip new. Think about what happens when someone reads this
in 5 years time. What does new mean? Yes it may be new now, but docs
are supposed to be timeless.

> +feature baed on iopoll, this could be a suboptimal solution when running

based on

> +on a single thread, it offers higher performance than IRQ and lower CPU
> +utilization than polling. Similarly, this feature also requires the devices
> +to support polling configuration.

This doesn't explain how it works. I'd say something like:

Hybrid io polling differs from strict polling in that it will delay a
bit before doing completion side polling, to avoid wasting too much CPU.
Like IOPOLL, it requires that devices support polling.


> diff --git a/src/setup.c b/src/setup.c
> index 073de50..d1a87aa 100644
> --- a/src/setup.c
> +++ b/src/setup.c
> @@ -320,6 +320,10 @@ int __io_uring_queue_init_params(unsigned entries, struct io_uring *ring,
>  			ring->int_flags |= INT_FLAG_APP_MEM;
>  	}
>  
> +	if ((p->flags & (IORING_SETUP_IOPOLL|IORING_SETUP_HYBRID_IOPOLL)) ==
> +			IORING_SETUP_HYBRID_IOPOLL)
> +		return -EINVAL;
> +

The kernel should already do this, no point duplicating it in liburing.

The test bits look much better now, way simpler. I'll just need to
double check that they handle EINVAL on setup properly, and EOPNOTSUPP
at completion time will turn off further testing of it. Did you run it
on configurations where hybrid io polling will both fail at setup time,
and at runtime (eg the latter where the kernel supports it, but the
device/fs does not)?

-- 
Jens Axboe

