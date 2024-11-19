Return-Path: <io-uring+bounces-4835-lists+io-uring=lfdr.de@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from sy.mirrors.kernel.org (sy.mirrors.kernel.org [IPv6:2604:1380:40f1:3f00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 39F599D2AC1
	for <lists+io-uring@lfdr.de>; Tue, 19 Nov 2024 17:23:07 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sy.mirrors.kernel.org (Postfix) with ESMTPS id EF4CFB2926A
	for <lists+io-uring@lfdr.de>; Tue, 19 Nov 2024 16:18:48 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 7F26F3C463;
	Tue, 19 Nov 2024 16:18:44 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel-dk.20230601.gappssmtp.com header.i=@kernel-dk.20230601.gappssmtp.com header.b="SG5aB+Wi"
X-Original-To: io-uring@vger.kernel.org
Received: from mail-oi1-f170.google.com (mail-oi1-f170.google.com [209.85.167.170])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 69FE3199B9
	for <io-uring@vger.kernel.org>; Tue, 19 Nov 2024 16:18:41 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.167.170
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1732033124; cv=none; b=I8bgfqlqSXbRyDLoQTAtQaCBPDnbLUuiWhhW6U7MbhExK+/Mzl/TLW5rwP/uspuPo9+fPjeAkxKVvVJEmMWW6lPuwK+0R/bIa6gXPJhFQJU7yTa6N8fqVIg93AxzFp4zReRW0l994NqTzq62oVmQZd92z4OVgk9SzdTXxheGgNw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1732033124; c=relaxed/simple;
	bh=EpmM9T4jeTope9+UNhqcgngzlzMONMv6llYJLImRyu4=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=MeR5c8RFUqrqWwfxreIavTFR2z/Kk1Qxx/BV66JH8jMPkBOHD98jaOPl4GvEhCnPd7TyvLMDe1El4kVz6LO6pRTysO7hnxgIuoblJTv4Krkbu+puo36B4ECkN5hTD6ThYWiJgvDeKMMvvpNBgFK61mlMqT/LBbEyXNr6IqvOdlo=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=kernel.dk; spf=pass smtp.mailfrom=kernel.dk; dkim=pass (2048-bit key) header.d=kernel-dk.20230601.gappssmtp.com header.i=@kernel-dk.20230601.gappssmtp.com header.b=SG5aB+Wi; arc=none smtp.client-ip=209.85.167.170
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=kernel.dk
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=kernel.dk
Received: by mail-oi1-f170.google.com with SMTP id 5614622812f47-3e60e57a322so623541b6e.3
        for <io-uring@vger.kernel.org>; Tue, 19 Nov 2024 08:18:41 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernel-dk.20230601.gappssmtp.com; s=20230601; t=1732033120; x=1732637920; darn=vger.kernel.org;
        h=content-transfer-encoding:in-reply-to:from:content-language
         :references:cc:to:subject:user-agent:mime-version:date:message-id
         :from:to:cc:subject:date:message-id:reply-to;
        bh=NUYE9FPGQhm1dvf9fDZHQxlLBXymfUQu5MbS+4u+WfA=;
        b=SG5aB+WiprGDdOAUtXEJmUB7Tuhvg5ZnvhEmHEG55dWToD+ajwSKiuaP5cHGpyM7jc
         cxLg853/aA/pJJViHOPNFjr4E4+NR4xciN6cquOQJaT+/+KBPtuTRdVfSbsfs/QyaXiA
         XWoyqOZrpYjABPLH61nMMyv9EvXuKWB+Cxi32SZOhM84ePQLIFeLd9UsW/ZnhCbRCPD/
         E5UZWEwQHQjN3K3ubC/fBj2CnAOaHAoo5U+fuNW5tBJXCmuj/XSDWNLhwfiF1S/6F0m7
         MSLSsgu6bCX+aghPcNd1TU3XhEUxV68EfcY+ZfvFwQpVBew2CHqJRA8rV2JtpXiez16c
         qahg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1732033120; x=1732637920;
        h=content-transfer-encoding:in-reply-to:from:content-language
         :references:cc:to:subject:user-agent:mime-version:date:message-id
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=NUYE9FPGQhm1dvf9fDZHQxlLBXymfUQu5MbS+4u+WfA=;
        b=GJCRESd/1EsVV2NS/JLjd8a6ZMfuhAEvALBUx45qliNLCd2XuQf/k2rnQM/kzTtsyq
         K7x7pZZH4lg6rao2q9xA8e2/g9plgOjnDxoueTdnP3tJl8z10t9stnz2C5K4+PMrvjC8
         ZE0UTMnV1ZMna2+UaWaZT6QdM7DKSJwdd/xzRF9/laqaYe/uFR1y/gfQoRN/d2rd026B
         x+5NEeYukq94kqzUKiIf1mAheyr71jUB2a+m+rzGNZPp6D02uURKT3W0sbhAO8BB0atT
         Z7MU9otMaIONUuHH5WK6XVt3jnh+Ee6OhHuajCoVKiX4s9cOb42XgoxyM8tou9zfysTD
         uEjg==
X-Forwarded-Encrypted: i=1; AJvYcCUfD4fXLrILTrDu6ecIPdAnBjmekyHKwBsb0x62ZjkHSjuduKcYPYlBW03kLv1UxHUVo4onQj7vPg==@vger.kernel.org
X-Gm-Message-State: AOJu0YzG6PJv6dArXcWRfh8NWJEil3rMH0PYJ1RUA9ywR/qaFW+EgsWI
	tBI8zPsTB5T0VyE7Bw2Pk58NHK4B0IHlPeh9ppa0nmGAVuLsuDZx2KSjakGdjZo=
X-Google-Smtp-Source: AGHT+IFP1snBbj3tSi06euu/lCA16VXTLDGSe9QQjlyZAo/S0wbl0ZX5PBz3knQGEF9wx+oUU+Sn6w==
X-Received: by 2002:a05:6808:1204:b0:3e5:f4f9:3280 with SMTP id 5614622812f47-3e7bc7bfa12mr13166015b6e.10.1732033120410;
        Tue, 19 Nov 2024 08:18:40 -0800 (PST)
Received: from [192.168.1.116] ([96.43.243.2])
        by smtp.gmail.com with ESMTPSA id 5614622812f47-3e7bcd93889sm3716289b6e.46.2024.11.19.08.18.39
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Tue, 19 Nov 2024 08:18:39 -0800 (PST)
Message-ID: <2549a20b-e4a2-42ec-9d8c-cf4488acb6c0@kernel.dk>
Date: Tue, 19 Nov 2024 09:18:39 -0700
Precedence: bulk
X-Mailing-List: io-uring@vger.kernel.org
List-Id: <io-uring.vger.kernel.org>
List-Subscribe: <mailto:io-uring+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:io-uring+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH 1/9] io_uring: Fold allocation into alloc_cache helper
To: Gabriel Krisman Bertazi <krisman@suse.de>
Cc: asml.silence@gmail.com, io-uring@vger.kernel.org
References: <20241119012224.1698238-1-krisman@suse.de>
 <20241119012224.1698238-2-krisman@suse.de>
 <4e679f16-7da9-47c7-959c-d4636e5117b2@kernel.dk>
 <87ttc3nsv5.fsf@mailhost.krisman.be>
Content-Language: en-US
From: Jens Axboe <axboe@kernel.dk>
In-Reply-To: <87ttc3nsv5.fsf@mailhost.krisman.be>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit

On 11/19/24 8:30 AM, Gabriel Krisman Bertazi wrote:
> Jens Axboe <axboe@kernel.dk> writes:
> 
>> On 11/18/24 6:22 PM, Gabriel Krisman Bertazi wrote:
>>> diff --git a/io_uring/alloc_cache.h b/io_uring/alloc_cache.h
>>> index b7a38a2069cf..6b34e491a30a 100644
>>> --- a/io_uring/alloc_cache.h
>>> +++ b/io_uring/alloc_cache.h
>>> @@ -30,6 +30,13 @@ static inline void *io_alloc_cache_get(struct io_alloc_cache *cache)
>>>  	return NULL;
>>>  }
>>>  
>>> +static inline void *io_alloc_cache_alloc(struct io_alloc_cache *cache, gfp_t gfp)
>>> +{
>>> +	if (!cache->nr_cached)
>>> +		return kzalloc(cache->elem_size, gfp);
>>> +	return io_alloc_cache_get(cache);
>>> +}
>>
>> I don't think you want to use kzalloc here. The caller will need to
>> clear what its needs for the cached path anyway, so has no other option
>> than to clear/set things twice for that case.
> 
> Hi Jens,
> 
> The reason I do kzalloc here is to be able to trust the value of
> rw->free_iov (io_rw_alloc_async) and hdr->free_iov (io_msg_alloc_async)
> regardless of where the allocated memory came from, cache or slab.  In
> the callers (patch 6 and 7), we do:

I see, I guess that makes sense as some things are persistent in cache
and need clearing upfront if freshly allocated.

> +	hdr = io_uring_alloc_async_data(&ctx->netmsg_cache, req);
> +	if (!hdr)
> +		return NULL;
> +
> +	/* If the async data was cached, we might have an iov cached inside. */
> +	if (hdr->free_iov) {
> 
> An alternative would be to return a flag indicating whether the
> allocated memory came from the cache or not, but it didn't seem elegant.
> Do you see a better way?
> 
> I also considered that zeroing memory here shouldn't harm performance,
> because it'll hit the cache most of the time.

It should hit cache most of the time, but if we exceed the cache size,
then you will see allocations happen and churn. I don't like the idea of
the flag, then we still need to complicate the caller. We can do
something like slab where you have a hook for freshly allocated data
only? That can either be a property of the cache, or passed in via
io_alloc_cache_alloc()?

BTW, I'd probably change the name of that to io_cache_get() or
io_cache_alloc() or something like that, I don't think we need two
allocs in there.

-- 
Jens Axboe

