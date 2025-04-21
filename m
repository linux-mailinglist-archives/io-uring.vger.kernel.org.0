Return-Path: <io-uring+bounces-7588-lists+io-uring=lfdr.de@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [147.75.80.249])
	by mail.lfdr.de (Postfix) with ESMTPS id C2A6CA94CA6
	for <lists+io-uring@lfdr.de>; Mon, 21 Apr 2025 08:37:54 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id AE5D31891CFE
	for <lists+io-uring@lfdr.de>; Mon, 21 Apr 2025 06:38:05 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id E030E256C97;
	Mon, 21 Apr 2025 06:37:50 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="fLCgzXqZ"
X-Original-To: io-uring@vger.kernel.org
Received: from mail-ed1-f46.google.com (mail-ed1-f46.google.com [209.85.208.46])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id EAD08881E
	for <io-uring@vger.kernel.org>; Mon, 21 Apr 2025 06:37:47 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.208.46
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1745217470; cv=none; b=nFiQbgqOVwIlc+k4Nq5boxQCMN1ijZaeO/EEjKFKhZwlu1dS/+QATYBKSmXKnfoiBX3xQf21zkhSiy08Okb4uulfNSXpjUOOzWphNk+aYDCYMNQHvfSqXQ0b4XyGQQWZZq3vHC56UmWGoADFz0NY6YpztEmxe+/fY/EfAnkhwUE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1745217470; c=relaxed/simple;
	bh=PQ8TXHFk0B2zenbUdI3BQhE775bEONNkzGtGAhUV9Qc=;
	h=Message-ID:Date:MIME-Version:Subject:To:References:From:
	 In-Reply-To:Content-Type; b=rFhuKHxy7kG8LSjnNXPESYnf25G9JMA1/yHTJwmUaFEP8DaZVOOMA2y3lQUrVm+6mWvJ/T9t3AjvDz6phze3UtiU6svb0gr+P9RoCtIDrPFq+BQoJSxj0HwS50VaD+I9ifAm+fGJZcFNsjut/GjQOnKCcQKrq+kMrzjbQ7hUdG8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=fLCgzXqZ; arc=none smtp.client-ip=209.85.208.46
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Received: by mail-ed1-f46.google.com with SMTP id 4fb4d7f45d1cf-5e5e8274a74so5383243a12.1
        for <io-uring@vger.kernel.org>; Sun, 20 Apr 2025 23:37:47 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1745217466; x=1745822266; darn=vger.kernel.org;
        h=content-transfer-encoding:in-reply-to:from:content-language
         :references:to:subject:user-agent:mime-version:date:message-id:from
         :to:cc:subject:date:message-id:reply-to;
        bh=FAuO0ssvXesg5Nh7JZvzLb1ZIuJV3p2Hvq69ciUOu+I=;
        b=fLCgzXqZyukjNeJkyyb5XvvRMdJGFoOR88pnTtcYgU9+eLWMB3K8paZTQyxdXwckEe
         d9peicr1Uj7SpuEGeGSQ+Fs0gLaWO+HippuRSkuJHnLIUqWycZkvrPE0pfpmp2wNMCJO
         GneQ54i+zoXn8DA0EuFtuC72hQEgMOd6f0i/iFbGfMOjk73GOJ2PI3s/JDyTkfMItE73
         PADd8uhQc3IQk8TB/frhWjQU3IdIWsBfD//kv9IMcNpAnHHITlKkCzw9Z8X7Dwwcgex8
         MLlFFBjAmdkJLIreqbCRjz+QTNuAXn+VQfv1iVZqr/OPPLQ65SEZNtCNamdJVawK8LnQ
         MxVw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1745217466; x=1745822266;
        h=content-transfer-encoding:in-reply-to:from:content-language
         :references:to:subject:user-agent:mime-version:date:message-id
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=FAuO0ssvXesg5Nh7JZvzLb1ZIuJV3p2Hvq69ciUOu+I=;
        b=fj4acBtkZR/vXrI9TEHcyIMuSd0GqRX4fOZ0EpSvvbqbiNF9Lq+uq9HfCkMWTmx5Wt
         FyW74NynSDn0z46hPipWuhNkyl8qbSQe6X6SlNjg68g8uyRwHQcO1PJp6NT+RkYssv79
         Oi5MVWneuVMOa2kVUX0GZ2TvlqtpUbHJ6lzfWoYwJ9D0M77LcBm4q/pRCPm7onkpPhWV
         BSMxjsPkiO1JZslumECIMaKJ0sI+gLrx9Yr1+ShgyUt38QLELeNeAuu4pgYE6UnGSrE6
         gNEfe1wTEsGy9Q8CAtP4DjBGHsjytXlMK1aFZHIm9E+txtkts0ab0yTebaYYMheNLlcT
         ZCmQ==
X-Forwarded-Encrypted: i=1; AJvYcCWMCfExY+jaEGUk7mihZX3PByIJzenuhvpUWqEO02EzbjhdDp4eTFRMGw3T5KcUtrRoi7ASy1e/Kw==@vger.kernel.org
X-Gm-Message-State: AOJu0YyYURwBPcUTl8WUptwXZxz/sokEy0qdMJfw2tN9udYspceIMsas
	Fp5g7GeRBRbxxF3q3Z3ANkjsQ5OAWA1x74N0g77ETcwhVOD4/s0M
X-Gm-Gg: ASbGnctXshzNOCtsAzRmMXufukz+UZhT1acD8cirENBLAgne7RfBdm4NkldUa/jnuEt
	F5EaHlAkbAs1ICswIpKxynxNkj60Ag4e9ewy9GNhOpDNVP0CifSNda3oX1mL4Ax1tuy5jCpW2X9
	VTQdUOwPFDNGFC2C0bwAd++mTDt+s8G/4YtMIAdZ3RYpdM+Md7CSOqRBcnp1NdtkiRpVmCxmeap
	W5v2Rqa3O+ziaytZ8hHtsJ8efOK3QWlGyqSsE00rTo97czTg5JDCmaqjz8ryUzUvdc2xxBrM5zj
	MxffAxDpLY6S4kyrlFnVxQ2QBpyZLonFYQKcRio7YaruWdnLFg==
X-Google-Smtp-Source: AGHT+IGZYsr3tcwlFfoEmhczSHvYXFY5yaEbjSiq1d53oXb4lgaPbec08Tl/xs1IOteoNxiQL5PZMA==
X-Received: by 2002:a17:907:7246:b0:ac3:ccf7:3a11 with SMTP id a640c23a62f3a-acb74dd4b1bmr964727566b.44.1745217465902;
        Sun, 20 Apr 2025 23:37:45 -0700 (PDT)
Received: from [192.168.8.100] ([148.252.128.74])
        by smtp.gmail.com with ESMTPSA id a640c23a62f3a-acb6ec4b0b9sm477051266b.50.2025.04.20.23.37.44
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Sun, 20 Apr 2025 23:37:45 -0700 (PDT)
Message-ID: <04698484-e452-4e10-aaef-0ccda2378261@gmail.com>
Date: Mon, 21 Apr 2025 07:38:57 +0100
Precedence: bulk
X-Mailing-List: io-uring@vger.kernel.org
List-Id: <io-uring.vger.kernel.org>
List-Subscribe: <mailto:io-uring+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:io-uring+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH liburing 3/3] examples/zcrx: add refill queue allocation
 modes
To: David Wei <dw@davidwei.uk>, io-uring@vger.kernel.org
References: <cover.1745146129.git.asml.silence@gmail.com>
 <6a52feca4f8842c6aa3ad4595c1d1da8150f6fc1.1745146129.git.asml.silence@gmail.com>
 <7a941493-9924-4086-acaa-55cd428d25a2@davidwei.uk>
Content-Language: en-US
From: Pavel Begunkov <asml.silence@gmail.com>
In-Reply-To: <7a941493-9924-4086-acaa-55cd428d25a2@davidwei.uk>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit

On 4/21/25 01:28, David Wei wrote:
> On 2025-04-20 04:24, Pavel Begunkov wrote:
>> Refill queue creating is backed by the region api, which can either be
>> user or kernel allocated. Add an option to switch between the modes.
>>
>> Signed-off-by: Pavel Begunkov <asml.silence@gmail.com>
>> ---
>>   examples/zcrx.c | 46 ++++++++++++++++++++++++++++++++++++----------
>>   1 file changed, 36 insertions(+), 10 deletions(-)
>>
>> diff --git a/examples/zcrx.c b/examples/zcrx.c
>> index 8989c9a4..eafe1969 100644
>> --- a/examples/zcrx.c
>> +++ b/examples/zcrx.c
>> @@ -39,6 +39,13 @@
> [...]
>> @@ -128,6 +140,15 @@ static void setup_zcrx(struct io_uring *ring)
>>   	if (ret)
>>   		t_error(1, 0, "io_uring_register_ifq(): %d", ret);
>>   
>> +	if (cfg_rq_alloc_mode == RQ_ALLOC_USER) {
> 
> cfg_rq_alloc_mode == RQ_ALLOC_KERNEL?

Good catch! I found it during testing but apparently forgot to
commit.

> 
>> +		ring_ptr = mmap(NULL, ring_size,
>> +				PROT_READ | PROT_WRITE,
>> +				MAP_SHARED | MAP_POPULATE,
>> +				ring->ring_fd, region_reg.mmap_offset);
>> +		if (ring_ptr == MAP_FAILED)
>> +			t_error(1, 0, "mmap(): refill ring");
>> +	}
>> +
>>   	rq_ring.khead = (unsigned int *)((char *)ring_ptr + reg.offsets.head);
>>   	rq_ring.ktail = (unsigned int *)((char *)ring_ptr + reg.offsets.tail);
>>   	rq_ring.rqes = (struct io_uring_zcrx_rqe *)((char *)ring_ptr + reg.offsets.rqes);
> 

-- 
Pavel Begunkov


