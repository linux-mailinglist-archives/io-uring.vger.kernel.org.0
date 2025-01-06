Return-Path: <io-uring+bounces-5684-lists+io-uring=lfdr.de@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [IPv6:2604:1380:45e3:2400::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 5C22BA02DE5
	for <lists+io-uring@lfdr.de>; Mon,  6 Jan 2025 17:40:06 +0100 (CET)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id D9C033A5384
	for <lists+io-uring@lfdr.de>; Mon,  6 Jan 2025 16:40:00 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 9A90014AD3D;
	Mon,  6 Jan 2025 16:40:02 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="ITA7K4c4"
X-Original-To: io-uring@vger.kernel.org
Received: from mail-ej1-f50.google.com (mail-ej1-f50.google.com [209.85.218.50])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B1BD113DB9F
	for <io-uring@vger.kernel.org>; Mon,  6 Jan 2025 16:40:00 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.218.50
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1736181602; cv=none; b=L6FdEsFxVen7h05kpfNt64wHNeOjNrJ9twyL25F4BAEAda9d//IAEnMbDwgx9kG/Cx1zinCjtn4vNnNplqNayFqBxfsytuq81cn2C+KA0lvgsgULdrrSLDpPZASeJvUuvQPsCnfNNAYoMsvns31ZvEysIuteJ+dkfHXbG9YU+zs=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1736181602; c=relaxed/simple;
	bh=mA+jdLXnYYvD7jo1qzDLdDBwgR5KCvPJOlRxsCLLAzA=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=MedeBTSpST6Fdjv8zRR8Dc9xoqxk3GEjBYE/3mzR5Xz1ed9UlMnOthrpGxnM6Do9ZORbyAdg/diI5rHuzM03gw0pJN9dwlI2UT6W+OgKR3D0zAxNc7WmNACyoCJAlvugapdN0uxKG8GUwhjElf+Pqszrqg7x5iS+zZrTD3fv4Ck=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=ITA7K4c4; arc=none smtp.client-ip=209.85.218.50
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Received: by mail-ej1-f50.google.com with SMTP id a640c23a62f3a-aaee2c5ee6eso1663365966b.1
        for <io-uring@vger.kernel.org>; Mon, 06 Jan 2025 08:40:00 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1736181599; x=1736786399; darn=vger.kernel.org;
        h=content-transfer-encoding:in-reply-to:from:content-language
         :references:cc:to:subject:user-agent:mime-version:date:message-id
         :from:to:cc:subject:date:message-id:reply-to;
        bh=rhEghcxTSWsTQNbuT+cS9mabMzGub7x7moc8rqn9qy0=;
        b=ITA7K4c4CqhHJQWyDY9nsLSxyghKFZ46hBfdq8Z//QGnKeOrVrNgvNqz4sR0RIGoT+
         D6RoN0NtpDDl0LkXe8LjGfRbUyMfCGYXHw2TSxKL8bBft0AcZfySBQXhyp6DdenVfYYx
         4ETsZJLGaDpgUWY/SJv9ZGydvpQCm5xl+Tlf7GuYY4scFxYa9pNuB124LaRtUopgnmY1
         +cAimmCC6TwLKUcuxWdqTjvrq75ki5oJq/tu2YltoAkodR+S7EpMwe8+8ByBFvBj50rL
         8C01BkJVq+XzMR5X4UrZB8qj+/zEb2ZtYjEv+dMoYAFfMKLeAN5Z1b52Ntp+58lOaf+E
         vhsA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1736181599; x=1736786399;
        h=content-transfer-encoding:in-reply-to:from:content-language
         :references:cc:to:subject:user-agent:mime-version:date:message-id
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=rhEghcxTSWsTQNbuT+cS9mabMzGub7x7moc8rqn9qy0=;
        b=syO+i5ONDSsuAQ2nJ0CDJ0Ib8wTkGD2kvv6Mj+IJXsjNQ2xy/0tCxnTv6Q3Dc+b1W1
         kD83hdVLHY3Sy6KHHfWuVOXwMpq7llEd/ARMDlXbJOEfLbw8UqmW+JFJ3abmTBBmroY7
         H06bgjU2DrmyE3o9I6HtjJPudLoXA8KoS2/i7QNtpR+LlfYXvFKG3c4HXEY2xe2nA62o
         457yqY685GP5MO40k5IFbmUR0iw1n++gqwhpScbOnfZdbYdWJGjRT4a+oASx6GER/7lu
         VgEP7S6nTCB1tkwH2U81sgAffXJgtyOqo5I82F1YjL/ksWui0fdWbWhmNtSrlfRJSNx+
         Eafw==
X-Forwarded-Encrypted: i=1; AJvYcCVWZGur8WQAl+2itu+kesS3VV5cLW901huX1UMmwQACCjSnhxTXdtv1tj0oygDiLsLcik8wpy2P8g==@vger.kernel.org
X-Gm-Message-State: AOJu0YxjpRy6suIRQml5X1d58llpfYW3Og4TdRAKyOzPmLEos3lLob9o
	kMKERJXuUxOplPhzzcSEnvILA85a/E9sXXG2n0eVFTFe8YSJfVGH
X-Gm-Gg: ASbGncvpmGFaFnzTQEQMBQ1ULQgSW9KtWS7MchwXI1qJCeMK1pgkgb+9Zl5OpjduLvX
	GcYMZ9lUiQ0qsEKK7vzMazfpA841n9JRMmvUhABwkCE74eK1TXa/p2kmFSHusSVOJurZPaSGQ0F
	3Hqp+jmUW/WDctzYVgJKr7TE3rIW8XGBqyuWwsaR4rciZVqC+gkHgeBrXRAb8Ja4f1Az0eWgM8o
	YcsdfNxQWz84XHYsAw+P4CJk9n3j8BbwRdrsAvSjyZSEAm7SwgAb4dRPNTxU8NoWg==
X-Google-Smtp-Source: AGHT+IEuxpZn7YQ92jkP6K0xn1crwq9GX/mWlwVxgHfSNHg4Z/rFQC1TdpXKo1GUyOsB2BigEo7qyg==
X-Received: by 2002:a17:907:7da5:b0:aa6:8781:9909 with SMTP id a640c23a62f3a-aac2d32837amr5686920866b.29.1736181598807;
        Mon, 06 Jan 2025 08:39:58 -0800 (PST)
Received: from [192.168.8.100] ([148.252.133.16])
        by smtp.gmail.com with ESMTPSA id a640c23a62f3a-aac0e830ae6sm2276271866b.22.2025.01.06.08.39.57
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Mon, 06 Jan 2025 08:39:58 -0800 (PST)
Message-ID: <b44108f9-0b2d-42c6-befe-19fc86c1d05e@gmail.com>
Date: Mon, 6 Jan 2025 16:40:58 +0000
Precedence: bulk
X-Mailing-List: io-uring@vger.kernel.org
List-Id: <io-uring.vger.kernel.org>
List-Subscribe: <mailto:io-uring+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:io-uring+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH 2/4] io_uring: add registered request arguments
To: lizetao <lizetao1@huawei.com>,
 "io-uring@vger.kernel.org" <io-uring@vger.kernel.org>
Cc: Anuj Gupta <anuj20.g@samsung.com>, Kanchan Joshi <joshi.k@samsung.com>
References: <cover.1735301337.git.asml.silence@gmail.com>
 <cb3cc963ad684d5687b90f28ff9d928a20f80b76.1735301337.git.asml.silence@gmail.com>
 <4cda935c978f48ceac6d69dd2e9587f9@huawei.com>
Content-Language: en-US
From: Pavel Begunkov <asml.silence@gmail.com>
In-Reply-To: <4cda935c978f48ceac6d69dd2e9587f9@huawei.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit

On 1/6/25 11:33, lizetao wrote:
> Hi,
> 
>> -----Original Message-----
>> From: Pavel Begunkov <asml.silence@gmail.com>
>> Sent: Monday, December 30, 2024 9:30 PM
>> To: io-uring@vger.kernel.org
>> Cc: asml.silence@gmail.com; Anuj Gupta <anuj20.g@samsung.com>; Kanchan
>> Joshi <joshi.k@samsung.com>
>> Subject: [PATCH 2/4] io_uring: add registered request arguments
>>
>> Similarly to registered wait arguments we want to have a pre-mapped space
>> for various request arguments. Use the same parameter region, however as -
>>> wait_args has different lifetime rules, add a new instance of struct
>> io_reg_args.
>>
>> Signed-off-by: Pavel Begunkov <asml.silence@gmail.com>
>> ---
>>   include/linux/io_uring_types.h | 2 ++
>>   io_uring/register.c            | 3 +++
>>   2 files changed, 5 insertions(+)
>>
>> diff --git a/include/linux/io_uring_types.h b/include/linux/io_uring_types.h
>> index 49008f00d064..cd6642855533 100644
>> --- a/include/linux/io_uring_types.h
>> +++ b/include/linux/io_uring_types.h
>> @@ -299,6 +299,8 @@ struct io_ring_ctx {
>>
>>   		struct io_submit_state	submit_state;
>>
>> +		struct io_reg_args	sqe_args;
>> +
>>   		/*
>>   		 * Modifications are protected by ->uring_lock and -
>>> mmap_lock.
>>   		 * The flags, buf_pages and buf_nr_pages fields should be
>> stable diff --git a/io_uring/register.c b/io_uring/register.c index
>> b926eb053408..d2232b90a81d 100644
>> --- a/io_uring/register.c
>> +++ b/io_uring/register.c
>> @@ -607,6 +607,9 @@ static int io_register_mem_region(struct io_ring_ctx
>> *ctx, void __user *uarg)
>>   		ctx->wait_args.ptr = io_region_get_ptr(&ctx->param_region);
>>   		ctx->wait_args.size = rd.size;
>>   	}
>> +
>> +	ctx->sqe_args.ptr = io_region_get_ptr(&ctx->param_region);
>> +	ctx->sqe_args.size = rd.size;
> 
> Why not add an enum value against sqe_args? Will mixing it with

Not sure what you mean

> IORING_MEM_REGION_REG_WAIT_ARG cause management confusion?

This specific region was added to be shared for multiple use
cases, the rest is up to the userspace. liburing will need to
have a clear API

-- 
Pavel Begunkov


