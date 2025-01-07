Return-Path: <io-uring+bounces-5718-lists+io-uring=lfdr.de@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [IPv6:2604:1380:45d1:ec00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 161A3A034FC
	for <lists+io-uring@lfdr.de>; Tue,  7 Jan 2025 03:17:51 +0100 (CET)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id E4F4316403A
	for <lists+io-uring@lfdr.de>; Tue,  7 Jan 2025 02:17:48 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id D8EA58248D;
	Tue,  7 Jan 2025 02:17:45 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel-dk.20230601.gappssmtp.com header.i=@kernel-dk.20230601.gappssmtp.com header.b="KzG//src"
X-Original-To: io-uring@vger.kernel.org
Received: from mail-il1-f181.google.com (mail-il1-f181.google.com [209.85.166.181])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2657827462
	for <io-uring@vger.kernel.org>; Tue,  7 Jan 2025 02:17:41 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.166.181
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1736216265; cv=none; b=VIRjavv5nnklQcmKwL6XdyI98Yc8cwkUvRwOzhrBnT8hCCiXTXGd00LtwIGqMPhcBVSv9exfiBTnG0FRu5dEKJHUtbPTJGTefP+GaN7uG45W/7EV+g6+rNv8xlchIgy4RoZAVZEFi9dvSZ3ekKNy/FMy6RJ6AGX3RlyG5gyR4kw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1736216265; c=relaxed/simple;
	bh=h4KyeIx/1I2PTmM4mENZb7zjGTWH935/w25CwO7qc1w=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=IWjw/ZA4m5tewo5S3k6NgoQ+uemXFrTqQj6CwJibLwO05tSr/35AIHGGUvEzlHYKw/Dq7SQTZ1wryTHCiEBgHgkHJa7+3WdrQoCug8pPA5MjI8aCuMYBwNWCLWByTxO/xPOywN+kOqoe4M0JfOqFw/HDYDLJ8bBGzvFYRalrr6Y=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=kernel.dk; spf=pass smtp.mailfrom=kernel.dk; dkim=pass (2048-bit key) header.d=kernel-dk.20230601.gappssmtp.com header.i=@kernel-dk.20230601.gappssmtp.com header.b=KzG//src; arc=none smtp.client-ip=209.85.166.181
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=kernel.dk
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=kernel.dk
Received: by mail-il1-f181.google.com with SMTP id e9e14a558f8ab-3cdce23f3e7so22063505ab.0
        for <io-uring@vger.kernel.org>; Mon, 06 Jan 2025 18:17:41 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernel-dk.20230601.gappssmtp.com; s=20230601; t=1736216261; x=1736821061; darn=vger.kernel.org;
        h=content-transfer-encoding:in-reply-to:content-language:from
         :references:cc:to:subject:user-agent:mime-version:date:message-id
         :from:to:cc:subject:date:message-id:reply-to;
        bh=92MtV43/q/VStM5ltOEmavD/9Z5kJUjPvTOj5sLJlLM=;
        b=KzG//srcpvVhKLpq2QL2q8RVCMQNGyEvPV9JU+QEaDN8z0/DJqKpdHPrbAnuLwV76T
         KY+9x1pZIKB9u5aMF024MewPk3XZwGFUlBDah6mK+231qllKbk7VrhbMqalMnz5GFb49
         VqTRjJ1V+WpQcTSMmY5ZRaU7CraJSwb4eho4zOL3X92cQe20+epwteUuHb+3Hk8YE0Ql
         dH1dRQrj2J3j/swMy9bgg0qAYmq1SN+j2kzRGWDUEJ8kN103ohldZnR2C5+Rz3yfROfI
         9UOrELe4FAZ5CnlZN+LOcvy0ql2sEiI+ujlfptQlq2biDV2UhUKhmC3bgU7RNR2G7+Fh
         QOfA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1736216261; x=1736821061;
        h=content-transfer-encoding:in-reply-to:content-language:from
         :references:cc:to:subject:user-agent:mime-version:date:message-id
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=92MtV43/q/VStM5ltOEmavD/9Z5kJUjPvTOj5sLJlLM=;
        b=BfvlF+aFKV7nWco7v8r3FQuDdN1nTDB/txJ22IU5scQJZgVksxzdtSH6vmN5t7m+T6
         GtWYqRZ6GiCCyHIz15Xgv5/JfirMxH+EsfKN0lWG5HA/4TMWuBmRKgxsL8/VO6syrWun
         agxtLrx7qLjMvFcmkwvn5Up3GYTGEBl+E14KCtNVYvPSAJZ1ts6XjqImRWn2O97iEA2n
         C0Cv1ree/nE+tyda3Aa26orSsTOc8xr8slv/CmBqEJfEIGpvPYZCUovQ+WrcsL7pMW+c
         ng9SIlSnWIGsGsb5N2UiwwSQZ/q1w2GvBNtMJ/IbJXRB3h93NcQ+5tKFPXEgZdD+bs4o
         M7jw==
X-Forwarded-Encrypted: i=1; AJvYcCVICiEEOcyKVr6zKh1PrLCRs9BoJJgeStFY3hnpN8VYE0G+r8NQzO5orUVG+GghMLkBHQzNJLsFjg==@vger.kernel.org
X-Gm-Message-State: AOJu0YzyHwUqpmrHTEFWajtZwVJ+si6fHJUkXVAoSJB19uC8dYEr/Yqb
	F3MkQafvGQGtldVxYB4IzSn9LdkpMvXDPPpTcl+QgMtb5+rDhJskembhF94bezM=
X-Gm-Gg: ASbGncvYtA27+CXu9hrD6YQwWYGI33dnBrSahoM55xnTiYxEYo2v/Wxuc/kWWgTIHlB
	v0OirmErnIj/xH8LtDe4HWTtWob6l6nvnEE6liPOVtrD/DN0NRoGv1k9HFd+EmlOuJr6Myg1PbE
	jdCO3J+tvzg8M1pcofsirO89r9tdvSXqy51U3WXQYS3N67pHJ1MMv32HVdaG6q9U4jk+gED7pKG
	bjAoxbkEpY3v0bkwhsBlTs+coViu0UCkcJRDLKm9+kMGPM6McOJAg==
X-Google-Smtp-Source: AGHT+IHmnGCUUshvzjHQeuqswxB8rbutUI8Kl2ImwYXkMiyxDAQKLnZTe6a08hQz567k4iiXro5NQw==
X-Received: by 2002:a92:8748:0:b0:3cc:b7e4:6264 with SMTP id e9e14a558f8ab-3ccb7e464b3mr192134895ab.0.1736216261181;
        Mon, 06 Jan 2025 18:17:41 -0800 (PST)
Received: from [192.168.1.150] ([198.8.77.157])
        by smtp.gmail.com with ESMTPSA id 8926c6da1cb9f-4e68c199afesm9760858173.94.2025.01.06.18.17.40
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Mon, 06 Jan 2025 18:17:40 -0800 (PST)
Message-ID: <aa9a7b74-a9c6-4333-bb25-490655eadb45@kernel.dk>
Date: Mon, 6 Jan 2025 19:17:39 -0700
Precedence: bulk
X-Mailing-List: io-uring@vger.kernel.org
List-Id: <io-uring.vger.kernel.org>
List-Subscribe: <mailto:io-uring+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:io-uring+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH 2/4] io_uring/cmd: add per-op data to struct
 io_uring_cmd_data
To: lizetao <lizetao1@huawei.com>, Mark Harmstone <maharmstone@fb.com>
Cc: "linux-btrfs@vger.kernel.org" <linux-btrfs@vger.kernel.org>,
 "io-uring@vger.kernel.org" <io-uring@vger.kernel.org>
References: <20250103150233.2340306-1-maharmstone@fb.com>
 <20250103150233.2340306-3-maharmstone@fb.com>
 <974022e6b52a4ae39f10ea4410dd8e25@huawei.com>
 <01b838d9-485f-47a5-9ee6-f2d79f71ae32@kernel.dk>
 <3e2e277ed6bf40ae87890b41133f5314@huawei.com>
From: Jens Axboe <axboe@kernel.dk>
Content-Language: en-US
In-Reply-To: <3e2e277ed6bf40ae87890b41133f5314@huawei.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit

On 1/6/25 7:04 PM, lizetao wrote:
> Hi,
> 
>> -----Original Message-----
>> From: Jens Axboe <axboe@kernel.dk>
>> Sent: Monday, January 6, 2025 10:46 PM
>> To: lizetao <lizetao1@huawei.com>; Mark Harmstone <maharmstone@fb.com>
>> Cc: linux-btrfs@vger.kernel.org; io-uring@vger.kernel.org
>> Subject: Re: [PATCH 2/4] io_uring/cmd: add per-op data to struct
>> io_uring_cmd_data
>>
>> On 1/6/25 5:47 AM, lizetao wrote:
>>> Hi,
>>>
>>>> -----Original Message-----
>>>> From: Mark Harmstone <maharmstone@fb.com>
>>>> Sent: Friday, January 3, 2025 11:02 PM
>>>> To: linux-btrfs@vger.kernel.org; io-uring@vger.kernel.org
>>>> Cc: Jens Axboe <axboe@kernel.dk>
>>>> Subject: [PATCH 2/4] io_uring/cmd: add per-op data to struct
>>>> io_uring_cmd_data
>>>>
>>>> From: Jens Axboe <axboe@kernel.dk>
>>>>
>>>> In case an op handler for ->uring_cmd() needs stable storage for user
>>>> data, it can allocate io_uring_cmd_data->op_data and use it for the
>>>> duration of the request. When the request gets cleaned up, uring_cmd
>>>> will free it automatically.
>>>>
>>>> Signed-off-by: Jens Axboe <axboe@kernel.dk>
>>>> ---
>>>>  include/linux/io_uring/cmd.h |  1 +
>>>>  io_uring/uring_cmd.c         | 13 +++++++++++--
>>>>  2 files changed, 12 insertions(+), 2 deletions(-)
>>>>
>>>> diff --git a/include/linux/io_uring/cmd.h
>>>> b/include/linux/io_uring/cmd.h index 61f97a398e9d..a65c7043078f
>>>> 100644
>>>> --- a/include/linux/io_uring/cmd.h
>>>> +++ b/include/linux/io_uring/cmd.h
>>>> @@ -20,6 +20,7 @@ struct io_uring_cmd {
>>>>
>>>>  struct io_uring_cmd_data {
>>>>  	struct io_uring_sqe	sqes[2];
>>>> +	void			*op_data;
>>>>  };
>>>>
>>>>  static inline const void *io_uring_sqe_cmd(const struct io_uring_sqe
>>>> *sqe) diff --git a/io_uring/uring_cmd.c b/io_uring/uring_cmd.c index
>>>> 629cb4266da6..ce7726a04883 100644
>>>> --- a/io_uring/uring_cmd.c
>>>> +++ b/io_uring/uring_cmd.c
>>>> @@ -23,12 +23,16 @@ static struct io_uring_cmd_data
>>>> *io_uring_async_get(struct io_kiocb *req)
>>>>
>>>>  	cache = io_alloc_cache_get(&ctx->uring_cache);
>>>>  	if (cache) {
>>>> +		cache->op_data = NULL;
>>>
>>> Why is op_data set to NULL here? If you are worried about some
>>> omissions, would it be better to use WARN_ON to assert that op_data is
>>> a null pointer? This will also make it easier to analyze the cause of
>>> the problem.
>>
>> Clearing the per-op data is prudent when allocating getting this struct, to avoid
>> previous garbage. The alternative would be clearing it when it's freed, either
>> way is fine imho. A WARN_ON would not make sense, as it can validly be non-
>> NULL already.
> 
> I still can't fully understand, the usage logic of op_data should be
> as follows: When applying for and initializing the cache, op_data has
> been set to NULL. In io_req_uring_cleanup, the op_data memory will be
> released and set to NULL. So if the cache in uring_cache, its op_data
> should be NULL? If it is non-NULL, is there a risk of memory leak if
> it is directly set to null?

Ah forgot I did clear it for freeing. So yes, this NULL setting on the
alloc side is redundant. But let's just leave it for now, once this gets
merged with the alloc cache cleanups that are pending for 6.14, it'll go
away anyway.

-- 
Jens Axboe

