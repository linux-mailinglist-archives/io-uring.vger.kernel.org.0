Return-Path: <io-uring+bounces-678-lists+io-uring=lfdr.de@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [IPv6:2604:1380:4601:e00::3])
	by mail.lfdr.de (Postfix) with ESMTPS id B6E0A861938
	for <lists+io-uring@lfdr.de>; Fri, 23 Feb 2024 18:18:30 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id 2EEDD1F25140
	for <lists+io-uring@lfdr.de>; Fri, 23 Feb 2024 17:18:30 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 40E9D139575;
	Fri, 23 Feb 2024 17:17:56 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=davidwei-uk.20230601.gappssmtp.com header.i=@davidwei-uk.20230601.gappssmtp.com header.b="hfOVjXNF"
X-Original-To: io-uring@vger.kernel.org
Received: from mail-pl1-f180.google.com (mail-pl1-f180.google.com [209.85.214.180])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 89A6112D1F9
	for <io-uring@vger.kernel.org>; Fri, 23 Feb 2024 17:17:54 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.214.180
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1708708676; cv=none; b=VOoKjxV/lffCWSHm5sJx1reioPCG+tYHJK7g9RMAlCMYhppXc0tV0d0K4ra/DAY9JYrI9RkMDHwnIf7r3OJf8mWKreHPzX532umRDT6k+kLFPcJ2M3CKhyhy00oFBH7BRD6z0FNDK+XWP+o3UdnVszyOoRlonX5wECwUFQo7+SQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1708708676; c=relaxed/simple;
	bh=i00Yiy1kYBWhoxhq2k5+S8zl7QxgXwCdPBSvVA5sFrM=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=dNQAPl8DghVN5a57YmWqSWBFCyOvtWVNaBsWAjKGr4H1M4603DgkNU+K3TSxoL7YSqtq6oYzcm1KtLyGvWXo+YZ3oPuHb6xyMYmKjqOAdnhm1DooZI4rcP/Cd6qqv1NUPkAd1CjJ6tadK2GHj83JRBwSn8Qi4V2kuihJgsD6oBc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=davidwei.uk; spf=none smtp.mailfrom=davidwei.uk; dkim=pass (2048-bit key) header.d=davidwei-uk.20230601.gappssmtp.com header.i=@davidwei-uk.20230601.gappssmtp.com header.b=hfOVjXNF; arc=none smtp.client-ip=209.85.214.180
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=davidwei.uk
Authentication-Results: smtp.subspace.kernel.org; spf=none smtp.mailfrom=davidwei.uk
Received: by mail-pl1-f180.google.com with SMTP id d9443c01a7336-1d8da50bffaso3953895ad.2
        for <io-uring@vger.kernel.org>; Fri, 23 Feb 2024 09:17:54 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=davidwei-uk.20230601.gappssmtp.com; s=20230601; t=1708708674; x=1709313474; darn=vger.kernel.org;
        h=content-transfer-encoding:in-reply-to:from:references:cc:to
         :content-language:subject:user-agent:mime-version:date:message-id
         :from:to:cc:subject:date:message-id:reply-to;
        bh=ViA19KuVNsVhsnNQG0a7i3njEoMM7Mn0tdNltOk6mnY=;
        b=hfOVjXNFU15hilXCvoT+WgZ/0Y4hRFD7Qax/AGc7P4/+FyuKfsFkEOezuQe2TyZfQh
         yZq/l4unfcP427R3LTX34/cQXk16d80LFRaRTd2OU4L7g9GQQsCjZWla/mGlaxNjOQ9T
         DxOBs9p4E4SdeqxxFfyn6hTQmMtIgglSUWySM0DHWxtxgzSgP0Z791OQ+M66/jHtfpRv
         YjdSQ38kovNXVT7Y+s9CRlTt/4lp4ymDScT4nkbJoYPHzCD5gIY1z3rCZYv1j5UlFZcQ
         82zWwDAZ2xz7JiJTQS9AV+V82Zd9+FqK2v1rQsGoN95L/64L1jMyYujOgHhwzZTzVSXJ
         lCMw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1708708674; x=1709313474;
        h=content-transfer-encoding:in-reply-to:from:references:cc:to
         :content-language:subject:user-agent:mime-version:date:message-id
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=ViA19KuVNsVhsnNQG0a7i3njEoMM7Mn0tdNltOk6mnY=;
        b=YpsA6Fy4w6VXDS/huwrVCsl2hM2FCcXz+Gv5NlmvnQmfE9g1BFgbYUExXsYIs5QcK9
         cBIrSCDWATdd3G5uWZcHKocpOgams9XosgSGtr8Mk+sxMqEiBNIqu4Znj/ZzopGPcDBN
         ppowwdQown0pBqxGbD5+gq4Uom9bDtxy2XlYt70UuGnrrwuir8pdQ7/w880yZqwBciwi
         QljD0XPPxz8EHtA9CV7cu0Bld+75+T/LcR0yfIvVf/3H9scXJM8LkeyUnYCzipEe8llG
         IquPbvEvT5dgg9yAvg1OSGma4Yh+J+tHODqz8tvXRBMiI/zKg8boKCAEvd9IILTATvJK
         feXA==
X-Forwarded-Encrypted: i=1; AJvYcCUoriuBmVjKcoegQvCC6q41Tvmg9zAuJ7P8ygM+D6MEpr7LnzmkVt72PQPJziBLWym5KI0aGozmLi3ZYnE1KHHH5XCbHXyuRyQ=
X-Gm-Message-State: AOJu0YzOaTD73460dS1uAbogOcuoV4RC2tk/5cJrRjbHA3/+YwXvn/oT
	2NKQc2TTrMLuKinDAQxK8vauZDug3/nTxM92n2eo5CDqdBhogSZEvAXDQs4eGy4=
X-Google-Smtp-Source: AGHT+IFQ6LVh8Sc1qykS4vOlry9oRyF5l8AwLKHlGAVg6UPlcYxenU0Btg9k/XeS3Je1+uFKy/J6SQ==
X-Received: by 2002:a17:902:db02:b0:1dc:2d4d:45a1 with SMTP id m2-20020a170902db0200b001dc2d4d45a1mr649894plx.19.1708708673717;
        Fri, 23 Feb 2024 09:17:53 -0800 (PST)
Received: from [192.168.1.24] (71-212-1-72.tukw.qwest.net. [71.212.1.72])
        by smtp.gmail.com with ESMTPSA id r9-20020a170903014900b001da105d6a83sm11948096plc.224.2024.02.23.09.17.53
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Fri, 23 Feb 2024 09:17:53 -0800 (PST)
Message-ID: <7f179dd2-cba3-4383-ae41-848cd7e4eb3b@davidwei.uk>
Date: Fri, 23 Feb 2024 09:17:52 -0800
Precedence: bulk
X-Mailing-List: io-uring@vger.kernel.org
List-Id: <io-uring.vger.kernel.org>
List-Subscribe: <mailto:io-uring+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:io-uring+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [RFC PATCH v1] io_uring: only account cqring wait time as iowait
 if enabled for a ring
Content-Language: en-GB
To: Jens Axboe <axboe@kernel.dk>, io-uring@vger.kernel.org
Cc: Pavel Begunkov <asml.silence@gmail.com>
References: <20240223054012.3386196-1-dw@davidwei.uk>
 <71ce7853-a1b9-4475-ab2a-0d751d156e1b@kernel.dk>
From: David Wei <dw@davidwei.uk>
In-Reply-To: <71ce7853-a1b9-4475-ab2a-0d751d156e1b@kernel.dk>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit

On 2024-02-23 06:31, Jens Axboe wrote:
> On 2/22/24 10:40 PM, David Wei wrote:
>> diff --git a/include/linux/io_uring_types.h b/include/linux/io_uring_types.h
>> index bd7071aeec5d..57318fc01379 100644
>> --- a/include/linux/io_uring_types.h
>> +++ b/include/linux/io_uring_types.h
>> @@ -425,6 +425,9 @@ struct io_ring_ctx {
>>  	DECLARE_HASHTABLE(napi_ht, 4);
>>  #endif
>>  
>> +	/* iowait accounting */
>> +	bool				iowait_enabled;
>> +
> 
> Since this is just a single bit, you should put it in the top section
> where we have other single bits for hot / read-mostly data. This avoids
> needing something many cache lines away for the hotter wait path, and it
> avoids growing the struct as there's still plenty of space there for
> this.

Got it, moved it to the cacheline aligned hot/read-only struct.
$current_year is when I learnt about C bitfields.

> 
>> diff --git a/io_uring/register.c b/io_uring/register.c
>> index 99c37775f974..7cbc08544c4c 100644
>> --- a/io_uring/register.c
>> +++ b/io_uring/register.c
>> @@ -387,6 +387,12 @@ static __cold int io_register_iowq_max_workers(struct io_ring_ctx *ctx,
>>  	return ret;
>>  }
>>  
>> +static int io_register_iowait(struct io_ring_ctx *ctx)
>> +{
>> +	ctx->iowait_enabled = true;
>> +	return 0;
>> +}
>> +
>>  static int __io_uring_register(struct io_ring_ctx *ctx, unsigned opcode,
>>  			       void __user *arg, unsigned nr_args)
>>  	__releases(ctx->uring_lock)
>> @@ -563,6 +569,12 @@ static int __io_uring_register(struct io_ring_ctx *ctx, unsigned opcode,
>>  			break;
>>  		ret = io_unregister_napi(ctx, arg);
>>  		break;
>> +	case IORING_REGISTER_IOWAIT:
>> +		ret = -EINVAL;
>> +		if (arg || nr_args)
>> +			break;
>> +		ret = io_register_iowait(ctx);
>> +		break;
> 
> 
> This only allows you to set it, not clear it. I think we want to make it
> pass in the value, and pass back the previous. Something ala:
> 
> static int io_register_iowait(struct io_ring_ctx *ctx, int val)
> {
> 	int was_enabled = ctx->iowait_enabled;
> 
> 	if (val)
> 		ctx->iowait_enabled = 1;
> 	else
> 		ctx->iowait_enabled = 0;
> 	return was_enabled;
> }
> 
> and then:
> 
> 	case IORING_REGISTER_IOWAIT:
> 		ret = -EINVAL;
> 		if (arg)
> 			break;
> 		ret = io_register_iowait(ctx, nr_args);
> 		break;
> 

When I first thought about this I wondered how to pass a value like int
val through arg which is a void*. That's a clever use of nr_args.

> I'd also add a:
> 
> Fixes: 8a796565cec3 ("io_uring: Use io_schedule* in cqring wait")
> 
> and mark it for stable, so we at least attempt to make it something that
> can be depended on.

Sorry, what does "mark it for stable" mean?

> 

