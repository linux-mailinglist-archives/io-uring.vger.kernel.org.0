Return-Path: <io-uring+bounces-3970-lists+io-uring=lfdr.de@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [IPv6:2604:1380:45e3:2400::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 672D09AE944
	for <lists+io-uring@lfdr.de>; Thu, 24 Oct 2024 16:48:37 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 1E52D283A30
	for <lists+io-uring@lfdr.de>; Thu, 24 Oct 2024 14:48:36 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 9BDA91E0487;
	Thu, 24 Oct 2024 14:48:31 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel-dk.20230601.gappssmtp.com header.i=@kernel-dk.20230601.gappssmtp.com header.b="DCoVIdgc"
X-Original-To: io-uring@vger.kernel.org
Received: from mail-io1-f41.google.com (mail-io1-f41.google.com [209.85.166.41])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id CAD6F1DE88A
	for <io-uring@vger.kernel.org>; Thu, 24 Oct 2024 14:48:28 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.166.41
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1729781311; cv=none; b=aI+0C6t/QSTI16jCyoJuvwyLbrA/cbKSb1wBtPH1MAbiVobgtVpuWQCTya+TXfDsIWzpkgoywC3AP6AomyuCWbi8uKJU4qTd4FfE4feAI+SUIZGO26QP5yne2hP9KlCf1QQ7i/DYOQyIqZKPXovCiiG2crHcd7gZH39+rBNr+ak=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1729781311; c=relaxed/simple;
	bh=gNJBUZTIKNZRH3ibq+PrEAlcpt1CdyN4srQ67Ct/aHU=;
	h=Message-ID:Date:MIME-Version:Subject:To:References:From:
	 In-Reply-To:Content-Type; b=Q4wMuNpgeI2HXEwA7cSCrE7XjmQrxWFZcMUEzzLYFutaP8IKr4GxoCwHoJ9EQALrUTnRYSwHDrZIIkWTAIjbkkey+d++RJwF1SJY0k+80+tObDOBZDjgSkStTm6RTTR4VsYvl9O8SY4+6mCRq2FTTnIgALnjd0HRIRM+3ZK4U9s=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=kernel.dk; spf=pass smtp.mailfrom=kernel.dk; dkim=pass (2048-bit key) header.d=kernel-dk.20230601.gappssmtp.com header.i=@kernel-dk.20230601.gappssmtp.com header.b=DCoVIdgc; arc=none smtp.client-ip=209.85.166.41
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=kernel.dk
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=kernel.dk
Received: by mail-io1-f41.google.com with SMTP id ca18e2360f4ac-83abc039b25so40283739f.0
        for <io-uring@vger.kernel.org>; Thu, 24 Oct 2024 07:48:28 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernel-dk.20230601.gappssmtp.com; s=20230601; t=1729781308; x=1730386108; darn=vger.kernel.org;
        h=content-transfer-encoding:in-reply-to:from:content-language
         :references:to:subject:user-agent:mime-version:date:message-id:from
         :to:cc:subject:date:message-id:reply-to;
        bh=2sYRQ6KuumguDoaCgpSV0ixaLToquZio9bcMYibGfrA=;
        b=DCoVIdgcUVlyFoBAwYwtnMp+X6AcyHE4qnsixB012/QUxaFIn1o2dV57r1xdCqFcIq
         Sfr96rIWUv6N0daEoBU7P+su0f7rYofmYD1UZg08c5FPEkzB+5QwEhZxQukPHuOelSHH
         7DNIfhHSbXfSe58GcmS4J2Uos4Fnfhb/YPHv60jYBf0C6vYw6ztrSmrzOm76tsnouguG
         XQraNsamo3iPxo6iL+adakHXlLo3K2QZowXrO9rsfPQ/EpjeGxZ6MLS8sFNOxTsbK1ii
         /M8dQIQb9+ewuRKJuKOhW1+7iR6tyZ3PFpTiLOPivtlDxB4kHcYBJ1yFBNxRM7dFvNpQ
         gJBw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1729781308; x=1730386108;
        h=content-transfer-encoding:in-reply-to:from:content-language
         :references:to:subject:user-agent:mime-version:date:message-id
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=2sYRQ6KuumguDoaCgpSV0ixaLToquZio9bcMYibGfrA=;
        b=SprNDWecMZbtEtn1oAqBfGVD8HPa5gNOPUW/bPRWGAdPKue06/lu//uChZXjk45TtU
         16QhixAk70iUvSQMx6mmKtS9XdED1QL4vG7/1ZkSjZjiiphXpbH5fBNqXHn8VxHoBvNm
         eJVX7ozGK+RycPeqzEXXGP+RIXN69f+CAtCB5pkhAPjaRGpYWoUyicB+r5JegTqdmdkO
         WX87WR294Wy2nKVZSPZzEoZ0PLVrAZgEYB8ifTpsLj5yYj9U9set+69+EntRQv/+T+55
         bso7LNrrgam0eDTlVq1UJnGvYDkS67uO4S+2vj8ZihQRAavrIABzIMgJrxgI/kGIpsmv
         FQFg==
X-Forwarded-Encrypted: i=1; AJvYcCXsuVdzwECJxYgdc87sBKeM6REu0NYf5kLxWqBgkNk6VnnsMFjpU0n08n+rScNUiHy5LE0n2gFlmw==@vger.kernel.org
X-Gm-Message-State: AOJu0YzbhNO5tfT5OwDJFPbLb4ZOoVJbej3FOKlCV1moB8RUgHe6cEhI
	/yYGxiyeZgCRNoZ05SrqHpNjhvUmvowh1y57SmCRmw1+9EN8QWbxS/O7xVyHyxg=
X-Google-Smtp-Source: AGHT+IEuUxh29YVelxFbgcbuBJ+hz3n10GyVAe0v4EIhRujX6gsfVafmbm6ZTJyfLS5TQOsyfUYgYg==
X-Received: by 2002:a05:6602:6b8b:b0:83a:a746:68a6 with SMTP id ca18e2360f4ac-83af6162123mr602860239f.5.1729781307723;
        Thu, 24 Oct 2024 07:48:27 -0700 (PDT)
Received: from [192.168.1.116] ([96.43.243.2])
        by smtp.gmail.com with ESMTPSA id ca18e2360f4ac-83ae6b2022bsm197903939f.27.2024.10.24.07.48.26
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Thu, 24 Oct 2024 07:48:27 -0700 (PDT)
Message-ID: <4d61544d-3a06-4419-8dc6-f23a57740d77@kernel.dk>
Date: Thu, 24 Oct 2024 08:48:26 -0600
Precedence: bulk
X-Mailing-List: io-uring@vger.kernel.org
List-Id: <io-uring.vger.kernel.org>
List-Subscribe: <mailto:io-uring+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:io-uring+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH 7/7] io_uring/net: add provided buffer and bundle support
 to send zc
To: Pavel Begunkov <asml.silence@gmail.com>, io-uring@vger.kernel.org
References: <20241023161522.1126423-1-axboe@kernel.dk>
 <20241023161522.1126423-8-axboe@kernel.dk>
 <b826ce35-98b2-4639-9d39-d798e3b08d89@gmail.com>
Content-Language: en-US
From: Jens Axboe <axboe@kernel.dk>
In-Reply-To: <b826ce35-98b2-4639-9d39-d798e3b08d89@gmail.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit

On 10/24/24 8:44 AM, Pavel Begunkov wrote:
> On 10/23/24 17:07, Jens Axboe wrote:
>> Provided buffers inform the kernel which buffer group ID to pick a
>> buffer from for transfer. Normally that buffer contains the usual
>> addr + length information, as well as a buffer ID that is passed back
>> at completion time to inform the application of which buffer was used
>> for the transfer.
>>
>> However, if registered and provided buffers are combined, then the
>> provided buffer must instead tell the kernel which registered buffer
>> index should be used, and the length/offset within that buffer. Rather
>> than store the addr + length, the application must instead store this
>> information instead.
>>
>> If provided buffers are used with send zc, then those buffers must be
>> an index into a registered buffer. Change the mapping type to use
>> KBUF_MODE_BVEC, which tells the kbuf handlers to turn the mappings
>> into bio_vecs rather than iovecs. Then all that is needed is to
>> setup our iov_iterator to use iov_iter_bvec().
>>
>> Signed-off-by: Jens Axboe <axboe@kernel.dk>
>> ---
> ...
>> diff --git a/io_uring/net.h b/io_uring/net.h
>> index 52bfee05f06a..e052762cf85d 100644
>> --- a/io_uring/net.h
>> +++ b/io_uring/net.h
>> @@ -5,9 +5,15 @@
>>     struct io_async_msghdr {
>>   #if defined(CONFIG_NET)
>> -    struct iovec            fast_iov;
>> +    union {
>> +        struct iovec        fast_iov;
>> +        struct bio_vec        fast_bvec;
>> +    };
>>       /* points to an allocated iov, if NULL we use fast_iov instead */
>> -    struct iovec            *free_iov;
>> +    union {
>> +        struct iovec        *free_iov;
>> +        struct bio_vec        *free_bvec;
> 
> I'd rather not do it like that, aliasing with reusing memory and
> counting the number is a recipe for disaster when scattered across
> code. E.g. seems you change all(?) iovec allocations to allocate
> based on the size of the larger structure.
> 
> Counting bytes as in my series is less fragile, otherwise it needs
> a new structure and a set of helpers that can be kept together.

I have been pondering this, because I'm not a huge fan either. But
outside of the space side, it does come out pretty nicely/clean. This
series is really just a WIP posting as per the RFC, mostly just so we
can come up with something that's clean enough and works for both cases,
as it does have the caching that your series does not. And to
facilitate some more efficient TX/RX zero copy testing.

I'd love a separate struct for these two, but that kind of gets in the
way of the usual iovec imports. I'll get back to this soonish, it's not
a 6.13 thing by any stretch.

-- 
Jens Axboe

