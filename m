Return-Path: <io-uring+bounces-5685-lists+io-uring=lfdr.de@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [147.75.199.223])
	by mail.lfdr.de (Postfix) with ESMTPS id 4F73FA02E4A
	for <lists+io-uring@lfdr.de>; Mon,  6 Jan 2025 17:52:37 +0100 (CET)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id 29077163E75
	for <lists+io-uring@lfdr.de>; Mon,  6 Jan 2025 16:52:29 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 33C21153814;
	Mon,  6 Jan 2025 16:52:27 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="mAjbdrpO"
X-Original-To: io-uring@vger.kernel.org
Received: from mail-ej1-f49.google.com (mail-ej1-f49.google.com [209.85.218.49])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id EF9931AA1F2
	for <io-uring@vger.kernel.org>; Mon,  6 Jan 2025 16:52:24 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.218.49
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1736182347; cv=none; b=VZxeAg8wGmRyF/9SRxhyllbOYp55D0EkPgGdUnY6r5nNd7ndQEHSh+WnJ27RvzIGaK+n11fSNPCghKLk7yMewMNrmR/ub4flozhHc6jLOY4l86PnoSYdofcpwjP290wMwJmeH9shmQhtCbC/NmA+cte4a7dYEYOXk2VTLeAKmQU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1736182347; c=relaxed/simple;
	bh=/6APtfrufoQq8KqJlPNmuf1gIKKheq68wcB+TSEpUqM=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=B5gpMOBQbKDT0Fu9ETACMLog5fkSDtet1p2c+g5tFv3Bv4qA0UOBzjy+JUJSlTBAFcNe22hYrisyHriiNYQEjxiVhgivO23rnrlz/4RTnqiarjf7EinDlotIvh0MPX4xZIXV1kwP5Ncz9Do7fiGGHQmD+EKm0eBuNTGYWVLEYzI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=mAjbdrpO; arc=none smtp.client-ip=209.85.218.49
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Received: by mail-ej1-f49.google.com with SMTP id a640c23a62f3a-aa67333f7d2so2125003766b.0
        for <io-uring@vger.kernel.org>; Mon, 06 Jan 2025 08:52:24 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1736182343; x=1736787143; darn=vger.kernel.org;
        h=content-transfer-encoding:in-reply-to:from:content-language
         :references:cc:to:subject:user-agent:mime-version:date:message-id
         :from:to:cc:subject:date:message-id:reply-to;
        bh=zelEqXGQjbg0D/rloy9CSZZsan6tUvquDZJp5bmQZSc=;
        b=mAjbdrpOFjdhcbEmF3yiXCmRSow3L7BMXIruxNJeECip0SjifP3rKiTmBVzj8z5iTU
         v5QLmgo9fJB+kMgrqXG/XVdC2soJDvuiJiQVBkyDdKp4SiofU+Colcj3R4RtIKpXtGKQ
         vNPYt7cp/RI86Qmd8H+H05m7askX4igxaH9owA1h14UPouFRgx4vbeMrFRkay8iEikzd
         /T1ijM+b5pSkVxDoovHxeft9WFqewA4zT2QFPk2o5XUcwq78WDlLK7kC3ExFcFLMJotA
         GNaF5dh4SfzKRywg/YgiJlTUCCY7d2gVbYQgRCsWwzZ+/9IdgMyYisjqMYZY8wVNYDsI
         0oLg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1736182343; x=1736787143;
        h=content-transfer-encoding:in-reply-to:from:content-language
         :references:cc:to:subject:user-agent:mime-version:date:message-id
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=zelEqXGQjbg0D/rloy9CSZZsan6tUvquDZJp5bmQZSc=;
        b=rJ0Tt4Ifd2gviJblMrd/Eu8O8PDa0WdJTJJHXv2ARL9GULID4r9JcAIpMq5+BSfzAZ
         33WKTkc6NNXW35YUR/MCkl7N0rXBBznmIRGgrpCNsGdK50ObkQmRhNPqxf2IeuP8avqC
         gYgLhpuaNEt5S01p22JXD2vQyMVtw6J+5uAPUeUuC8b1SQ3E2ib/uAz+300oPHLpxrED
         LRgxiizl20VSFF06OBp7mPxHN1dqtnxIIOgA3uBW5HxFTt+NFMSP7H8Kpw/Z79mENODe
         VxlzFfcDcVSVGnEbD06i2FlZB+yluWKqgYzBTG3pvEPQj7YHqAYE9gA1sySv6BqT3+pK
         Nvxw==
X-Forwarded-Encrypted: i=1; AJvYcCUNDaegnr0MgO+EwRJ0A/3qd6Lct/vs1BKFkYy3nOMxeLeD9hP75qA6d8j4y7V1/JRVk18q5zo9nw==@vger.kernel.org
X-Gm-Message-State: AOJu0YxVo5UA7RuOpUTJCdpWFeyXvp5Y7GPJqYVjo+pRDfW8SxRVAnfC
	4to4rBqCLHu9EI5cGhN0gpKToI+qv0ppZWP21TJnlTTmfpnpZ3BI
X-Gm-Gg: ASbGncu/yGz8G6PtCX+7UUl1LuRWpfhJMKQUZqcsos136tVrEfV9nCVo9xzSe5Weq1Z
	3CI89fMdEPoHLgasrVEWziQ0XJvmb2g7W5DQkxPO7XpPjNxjSngGeME8aL81V6Q8SCHLMB7Rp39
	E7J7jAoPuN/9UHmAZqwz62H88F3IRDRPa0pgcfP6oK9c/+hzd1oBUFh69ljYCxaC3vyn/yeo5AI
	MFHbyF+CwtIMK6MT3r6V8LavlnJbDV43NF/m35lzUZ/tQNpaLzkHQgrBTMVrgwNDQ==
X-Google-Smtp-Source: AGHT+IFt/LSYW+pUJFID9pJMy3LwfSNssIiW2tiiaMitKiR4Fb3cilJHs5H3+VMVL9bt1LyaiKX5Dw==
X-Received: by 2002:a17:907:9803:b0:aaf:1604:bc5f with SMTP id a640c23a62f3a-aaf1604bcd1mr3463044466b.21.1736182342990;
        Mon, 06 Jan 2025 08:52:22 -0800 (PST)
Received: from [192.168.8.100] ([148.252.133.16])
        by smtp.gmail.com with ESMTPSA id a640c23a62f3a-aac0efe4184sm2256126666b.119.2025.01.06.08.52.22
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Mon, 06 Jan 2025 08:52:22 -0800 (PST)
Message-ID: <3d33d1ea-c385-4a4f-88b7-f04b9cfd6640@gmail.com>
Date: Mon, 6 Jan 2025 16:53:23 +0000
Precedence: bulk
X-Mailing-List: io-uring@vger.kernel.org
List-Id: <io-uring.vger.kernel.org>
List-Subscribe: <mailto:io-uring+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:io-uring+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH 4/4] io_uring/rw: pre-mapped rw attributes
To: lizetao <lizetao1@huawei.com>
Cc: Anuj Gupta <anuj20.g@samsung.com>, Kanchan Joshi <joshi.k@samsung.com>,
 "io-uring@vger.kernel.org" <io-uring@vger.kernel.org>
References: <cover.1735301337.git.asml.silence@gmail.com>
 <ea95e358ce21fe69200df6a0b1e747b8817a6ec6.1735301337.git.asml.silence@gmail.com>
 <e5b94e50bc9b41a9ab17161df38eadc5@huawei.com>
Content-Language: en-US
From: Pavel Begunkov <asml.silence@gmail.com>
In-Reply-To: <e5b94e50bc9b41a9ab17161df38eadc5@huawei.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit

On 1/6/25 11:13, lizetao wrote:
...
>>   /* sqe->attr_type_mask flags */
>> -#define IORING_RW_ATTR_FLAG_PI	(1U << 0)
>> +#define IORING_RW_ATTR_FLAG_PI		(1UL << 0)
>> +#define IORING_RW_ATTR_REGISTERED	(1UL << 63)
> Why use (1UL << 63) instead of (1UL << 1) here?

They serve different purposes, think how you'd be iterating
more attribute types, calculating the total size, etc.

>> diff --git a/io_uring/rw.c b/io_uring/rw.c index dc1acaf95db1..b1db4595788b
>> 100644
>> --- a/io_uring/rw.c
>> +++ b/io_uring/rw.c
>> @@ -271,10 +271,17 @@ static int io_prep_rw_pi(struct io_kiocb *req, struct
>> io_rw *rw, int ddir,
>>   	size_t pi_len;
>>   	int ret;
>>
>> -	if (copy_from_user(&__pi_attr, u64_to_user_ptr(attr_ptr),
>> -	    sizeof(pi_attr)))
>> -		return -EFAULT;
>> -	pi_attr = &__pi_attr;
>> +	if (attr_type_mask & IORING_RW_ATTR_REGISTERED) {
>> +		pi_attr = io_args_get_ptr(&req->ctx->sqe_args, attr_ptr,
>> +					  sizeof(pi_attr));
> Here pi_attr is just pointer, so maybe sizeof(__pi_attr) or sizeof(struct io_uring_attr_pi) will be better.

Good catch, and that's an issue from 3/4. As noted it's not even
tested and posted to discuss the API. I'd even prefer them to be
thrown away, and for Anuj / Kanchan to take over if that's
interesting.

-- 
Pavel Begunkov


