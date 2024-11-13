Return-Path: <io-uring+bounces-4666-lists+io-uring=lfdr.de@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from sy.mirrors.kernel.org (sy.mirrors.kernel.org [147.75.48.161])
	by mail.lfdr.de (Postfix) with ESMTPS id B3EF29C7E3F
	for <lists+io-uring@lfdr.de>; Wed, 13 Nov 2024 23:27:24 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sy.mirrors.kernel.org (Postfix) with ESMTPS id 3F7E8B23D8A
	for <lists+io-uring@lfdr.de>; Wed, 13 Nov 2024 22:27:22 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id DA39217837A;
	Wed, 13 Nov 2024 22:27:13 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel-dk.20230601.gappssmtp.com header.i=@kernel-dk.20230601.gappssmtp.com header.b="LQv2vNHe"
X-Original-To: io-uring@vger.kernel.org
Received: from mail-oa1-f50.google.com (mail-oa1-f50.google.com [209.85.160.50])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C4F0F18BC1C
	for <io-uring@vger.kernel.org>; Wed, 13 Nov 2024 22:27:10 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.160.50
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1731536833; cv=none; b=mHKapOolm3D54YwRZVBD35xRBukTDBjg2cpmjsGtPz/7xVjy/M5qaMnSUw7KNLRIQgXdjjy8J1RVNrM1z8j2/CfHTcVGmLMgJIZjAOsThlR2N7Q4q+iP8EJKoejcVZL3rzfS6UllICsMDtWeQQS41i83thpTSet8b3aD6KzIevk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1731536833; c=relaxed/simple;
	bh=nsozifW1bJaUXQvcoeJUy8/Gj7E4/mT/cosGv0myfXI=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=b2E+tiHzMsYvNow3PP6SsgBb2UnfVPNHJIXV2CAFAFhj7iSwvye7tfDFutAQ1KKMH7Zy95G37C6+KrtiTM9ucTuIpmp6fNSvJvSVhKQQRcuSo+ZpnTby8xVx1G1KMXSXDZAaWaAy4ZgG6EifB6jz9Nm1egS4w6fs9bXQ2gwtKXM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=kernel.dk; spf=pass smtp.mailfrom=kernel.dk; dkim=pass (2048-bit key) header.d=kernel-dk.20230601.gappssmtp.com header.i=@kernel-dk.20230601.gappssmtp.com header.b=LQv2vNHe; arc=none smtp.client-ip=209.85.160.50
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=kernel.dk
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=kernel.dk
Received: by mail-oa1-f50.google.com with SMTP id 586e51a60fabf-288fa5ce8f0so3432552fac.3
        for <io-uring@vger.kernel.org>; Wed, 13 Nov 2024 14:27:10 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernel-dk.20230601.gappssmtp.com; s=20230601; t=1731536830; x=1732141630; darn=vger.kernel.org;
        h=content-transfer-encoding:in-reply-to:from:content-language
         :references:cc:to:subject:user-agent:mime-version:date:message-id
         :from:to:cc:subject:date:message-id:reply-to;
        bh=Gk4zJTuuGCZq8YdlR7rEOEIOkX+EpzyKcyBLyLJ6C58=;
        b=LQv2vNHe3c6J/Xk7LKaqBSbsVu98sNAgAr92qlbs0SCs5PffOC3OKJGJ2iGr79I9B5
         zGR5dXRgl69nmqXYVLtToMm9vEnVoGI93x6pH13pHDBxcg/56wluYTNvwzHA6g9TePce
         JDT333v3qP7Ny/dOA7uABo2hFGqoWvRIRt9RAnkI4mDBsBh6x71igvmQPi64kBbDCyVl
         K3JmIGRfPqGFoMoOjf1+VAz/iT0uiVL9wnNef2vc1ZyI6l5Ong/52Vg4eVffSD+4T5B9
         kp9KDZeo1oJXbFr1gf2BIrtTxgrnsnKddqtm2gU46ry4pL82Wafp+yddh6KntZn5/RoN
         Jh1g==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1731536830; x=1732141630;
        h=content-transfer-encoding:in-reply-to:from:content-language
         :references:cc:to:subject:user-agent:mime-version:date:message-id
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=Gk4zJTuuGCZq8YdlR7rEOEIOkX+EpzyKcyBLyLJ6C58=;
        b=X/Gby94fVS4bx7uKYcMVi+1eZ0AlS93KuNpwcQTKdf4CqCYXzt16dMj659eDia2S5W
         iDjd4JWsa8O84n8VJbdu0ZEGZ4e+62THUZtIRc2kNX3FYN9mIpapuXxlDKMCJHtgUHoN
         82/fpmqe4bOu0AbHJTsUlmpDfDVu6Epe7rP7PSd/75HRlSGVX5QjiFS0+jZobpeR+okK
         xAe3qtVbiyaI5pTTDOmu+FIg1JJx4zlVJKeS7wgCO9G0aUJ4ithJObYlEiykLEUBzOAU
         bMKKGS4PyL84+NOMWpqBuOJKRXGrcExeJZOgc8MkHggH5ne+izsxkB7Oqb0vBCy/lNtn
         5wag==
X-Forwarded-Encrypted: i=1; AJvYcCURuQ4CZNPk6K9u6IzXqPtSSb3CIvjcPWKN1Tn6ORBhnUwB5iX9UVJRxb0u1okLMrfKr0coTXRlXA==@vger.kernel.org
X-Gm-Message-State: AOJu0Yw7RdjuSkLn9KoEpRvm4A17SZvGJIHVqBTn08V2yHoEvbwnsa4s
	gSlUK0kKVSaSrvT/QrEGABPv2DjSdJrXbRZj5cP3w0LV9WtxCuU4Szq1t6KRPXs=
X-Google-Smtp-Source: AGHT+IGoqd96MY7bfoXv+9tibkBAuG/6TDsL/wWWwAgL5vAB2DYrndf+hvSgNBskdlUVxt9rcbSY2A==
X-Received: by 2002:a05:6870:a58f:b0:288:570d:8fe2 with SMTP id 586e51a60fabf-2956010ababmr20540208fac.11.1731536829597;
        Wed, 13 Nov 2024 14:27:09 -0800 (PST)
Received: from [192.168.1.116] ([96.43.243.2])
        by smtp.gmail.com with ESMTPSA id 586e51a60fabf-295e9351aeasm1230872fac.54.2024.11.13.14.27.08
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Wed, 13 Nov 2024 14:27:08 -0800 (PST)
Message-ID: <0376df05-0b60-480d-84b8-76dd2d58f1a8@kernel.dk>
Date: Wed, 13 Nov 2024 15:27:07 -0700
Precedence: bulk
X-Mailing-List: io-uring@vger.kernel.org
List-Id: <io-uring.vger.kernel.org>
List-Subscribe: <mailto:io-uring+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:io-uring+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: don't reorder requests passed to ->queue_rqs
To: Chaitanya Kulkarni <chaitanyak@nvidia.com>, Christoph Hellwig <hch@lst.de>
Cc: "Michael S. Tsirkin" <mst@redhat.com>, Jason Wang <jasowang@redhat.com>,
 Keith Busch <kbusch@kernel.org>, Sagi Grimberg <sagi@grimberg.me>,
 Pavel Begunkov <asml.silence@gmail.com>,
 "linux-block@vger.kernel.org" <linux-block@vger.kernel.org>,
 "virtualization@lists.linux.dev" <virtualization@lists.linux.dev>,
 "linux-nvme@lists.infradead.org" <linux-nvme@lists.infradead.org>,
 "io-uring@vger.kernel.org" <io-uring@vger.kernel.org>
References: <20241113152050.157179-1-hch@lst.de>
 <eb2faaba-c261-48de-8316-c8e34fdb516c@nvidia.com>
 <2f7fa13a-71d9-4a8d-b8f4-5f657fdaab60@kernel.dk>
 <8156ea70-12a2-46f4-b977-59c9d76a4a65@nvidia.com>
Content-Language: en-US
From: Jens Axboe <axboe@kernel.dk>
In-Reply-To: <8156ea70-12a2-46f4-b977-59c9d76a4a65@nvidia.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit

On 11/13/24 3:23 PM, Chaitanya Kulkarni wrote:
> On 11/13/2024 12:51 PM, Jens Axboe wrote:
>>> Looks good to me. I ran the quick performance numbers [1].
>>>
>>> Reviewed-by: Chaitanya Kulkarni<kch@nvidia.com>
>>>
>>> -ck
>>>
>>> fio randread iouring workload :-
>>>
>>> IOPS :-
>>> -------
>>> nvme-orig:           Average IOPS: 72,690
>>> nvme-new-no-reorder: Average IOPS: 72,580
>>>
>>> BW :-
>>> -------
>>> nvme-orig:           Average BW: 283.9 MiB/s
>>> nvme-new-no-reorder: Average BW: 283.4 MiB/s
>> Thanks for testing, but you can't verify any kind of perf change with
>> that kind of setup. I'll be willing to bet that it'll be 1-2% drop at
>> higher rates, which is substantial. But the reordering is a problem, not
>> just for zoned devices, which is why I chose to merge this.
>>
>> -- Jens Axboe
> 
> Agree with you. My intention was to test it, since it was touching NVMe,
> I thought sharing results will help either way with io_uring?
> but no intention to stop this patchset and make an argument
> against it (if at all) for potential drop :).

Oh all good, and like I said, the testing is appreciated! The functional
testing is definitely useful.

-- 
Jens Axboe

