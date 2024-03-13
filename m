Return-Path: <io-uring+bounces-938-lists+io-uring=lfdr.de@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from sy.mirrors.kernel.org (sy.mirrors.kernel.org [147.75.48.161])
	by mail.lfdr.de (Postfix) with ESMTPS id 6128387B529
	for <lists+io-uring@lfdr.de>; Thu, 14 Mar 2024 00:25:04 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sy.mirrors.kernel.org (Postfix) with ESMTPS id E5286B224DE
	for <lists+io-uring@lfdr.de>; Wed, 13 Mar 2024 23:25:01 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id F321641C6A;
	Wed, 13 Mar 2024 23:24:45 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel-dk.20230601.gappssmtp.com header.i=@kernel-dk.20230601.gappssmtp.com header.b="lw1haYIC"
X-Original-To: io-uring@vger.kernel.org
Received: from mail-pf1-f182.google.com (mail-pf1-f182.google.com [209.85.210.182])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A47625D72B
	for <io-uring@vger.kernel.org>; Wed, 13 Mar 2024 23:24:42 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.210.182
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1710372285; cv=none; b=P2NzJnw1Lhb6JDSRJDyPtFLG8MGELG3PyduKJ1oXTLz1SfFF3IKVz4dYObr9hM/2hHq6+lfFM82d6Hnqgi9vdRw8gc3evyt7zvXxZdfZcPqW8v2Mpmu5XXG72uTVq5R2OdmVN8A2xV+rXRWHHRdMnKxYgI53bofi6Z+qO9ZFe3I=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1710372285; c=relaxed/simple;
	bh=WW4wZCe0rDPE8wVaHA43PBkw5rsqC8hsuwzYnmJKadQ=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=GPv4+ZdU9wPWmHqQQ+2+q+u/Kab4N94O1F+/8aL1F2Z4OgArV8nnGs9zT4aTND4zAzJ0j2hhV+kMbPqoNH1eJZs9V3qmRQ9TkJYyefpkFYyaHOvah/O2z9wX/OFsDnNRHTGoO0qqlyy0StPzymFyZCnu3K0Qoskm6rekRM/TzVM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=kernel.dk; spf=pass smtp.mailfrom=kernel.dk; dkim=pass (2048-bit key) header.d=kernel-dk.20230601.gappssmtp.com header.i=@kernel-dk.20230601.gappssmtp.com header.b=lw1haYIC; arc=none smtp.client-ip=209.85.210.182
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=kernel.dk
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=kernel.dk
Received: by mail-pf1-f182.google.com with SMTP id d2e1a72fcca58-6e6aa270d55so96383b3a.1
        for <io-uring@vger.kernel.org>; Wed, 13 Mar 2024 16:24:42 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernel-dk.20230601.gappssmtp.com; s=20230601; t=1710372282; x=1710977082; darn=vger.kernel.org;
        h=content-transfer-encoding:in-reply-to:from:references:cc:to
         :content-language:subject:user-agent:mime-version:date:message-id
         :from:to:cc:subject:date:message-id:reply-to;
        bh=kMXDRqhKvNilIUWRU5wQWhwDpx0cE6MlZ58vylCumsU=;
        b=lw1haYIC3iBxVxq/j5pgfjg41xcYdrvWJljeQb1GR39MIvPPKUlxW4pFRj0ueAHcPg
         9nas0nrYIHW13R4Tyajw7E6d0JkoBNY0ZH3fqgYvNlpS6aDu558IuhFoGfDMHMksu7x4
         44qcsg9h71bGEl3wlJL0BSxQr1ZwgJ12S1WLWpt9Z77RH4MoVcpIejg0APXRDS6oUuq9
         aDx5a+VjKw6rEYWQM/G3lEosid3Ni7dyxIOZn2PSHX35+FDVNPIWtzKlxvEE28uAVsPf
         P1M+Py2yudg84GGVoIXw5EVNKdarEhnD/L1ApyZWsYSENaj+lULbE7QZCLDOI6M1MwjS
         sKIg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1710372282; x=1710977082;
        h=content-transfer-encoding:in-reply-to:from:references:cc:to
         :content-language:subject:user-agent:mime-version:date:message-id
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=kMXDRqhKvNilIUWRU5wQWhwDpx0cE6MlZ58vylCumsU=;
        b=p2ZWlCScARAK+ra/+BCUuxKyJI8gHS/GQlx/gyHgdnGnOcZlIU9YTxxd3Pck9tCief
         CLiFUx3WqJdH7Ry3OKTR9KgFW+T5RmLf0wIbb7muxSILxgFWdINCpzYYUsDlIzYoxMxI
         59Lyi0U22qXgbxFipACaFH0Qbo3C3MPPcRu5fHT8Otke19af8Tal7q2JkZZpGwiRQ/qq
         Z1sXaTSZuttT0GUI0ynz+Rvx1v3xHXa2sAaKYLD2cZSr1OqYhKY6RFDIQYaUA5mpoz+8
         /Zx+AquQA2nl3SXz5m0aPY4TA7qTy+E4YVvorElzfglF+5AuqRNpch/hr+/d3qwb6UCa
         CRBg==
X-Gm-Message-State: AOJu0Ywco4nk8L03pyF/omWbDh7eRMs0d5djeZztddza3jyCeH0k7LoF
	5axsnpkNZowkK8hqWh6Ib0a1mau+yOTsvJphFpZeKh4i7JO0vkL7rwDAQwQpIQQ=
X-Google-Smtp-Source: AGHT+IFJO82yHv7DLxaG2WaxR08Ii4iw0uDDU4BtOoajlmSUztSbzvEtnfgYzKffIzNWDFYJtHqaQQ==
X-Received: by 2002:a05:6a00:23c6:b0:6e6:8b98:721f with SMTP id g6-20020a056a0023c600b006e68b98721fmr216122pfc.1.1710372281960;
        Wed, 13 Mar 2024 16:24:41 -0700 (PDT)
Received: from [192.168.1.150] ([198.8.77.194])
        by smtp.gmail.com with ESMTPSA id gu21-20020a056a004e5500b006e6288ef4besm156890pfb.54.2024.03.13.16.24.41
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Wed, 13 Mar 2024 16:24:41 -0700 (PDT)
Message-ID: <4146d3a9-3f88-4ef5-8925-8782ae5aa90e@kernel.dk>
Date: Wed, 13 Mar 2024 17:24:40 -0600
Precedence: bulk
X-Mailing-List: io-uring@vger.kernel.org
List-Id: <io-uring.vger.kernel.org>
List-Subscribe: <mailto:io-uring+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:io-uring+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH 1/3] io_uring: simplify io_mem_alloc return values
Content-Language: en-US
To: Gabriel Krisman Bertazi <krisman@suse.de>,
 Pavel Begunkov <asml.silence@gmail.com>
Cc: io-uring@vger.kernel.org
References: <cover.1710343154.git.asml.silence@gmail.com>
 <ba1f5a30be45eec6cf73cfdbf4b4e1679a03cef8.1710343154.git.asml.silence@gmail.com>
 <87plvxkbjp.fsf@mailhost.krisman.be>
From: Jens Axboe <axboe@kernel.dk>
In-Reply-To: <87plvxkbjp.fsf@mailhost.krisman.be>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit

On 3/13/24 4:32 PM, Gabriel Krisman Bertazi wrote:
> Pavel Begunkov <asml.silence@gmail.com> writes:
> 
>> io_mem_alloc() returns a pointer on success and a pointer-encoded error
>> otherwise. However, it can only fail with -ENOMEM, just return NULL on
>> failure. PTR_ERR is usually pretty error prone.
>>
>> Signed-off-by: Pavel Begunkov <asml.silence@gmail.com>
>> ---
>>  io_uring/io_uring.c | 14 +++++---------
>>  io_uring/kbuf.c     |  4 ++--
>>  2 files changed, 7 insertions(+), 11 deletions(-)
>>
>> diff --git a/io_uring/io_uring.c b/io_uring/io_uring.c
>> index e7d7a456b489..1d0eac0cc8aa 100644
>> --- a/io_uring/io_uring.c
>> +++ b/io_uring/io_uring.c
>> @@ -2802,12 +2802,8 @@ static void io_rings_free(struct io_ring_ctx *ctx)
>>  void *io_mem_alloc(size_t size)
>>  {
>>  	gfp_t gfp = GFP_KERNEL_ACCOUNT | __GFP_ZERO | __GFP_NOWARN | __GFP_COMP;
>> -	void *ret;
>>  
>> -	ret = (void *) __get_free_pages(gfp, get_order(size));
>> -	if (ret)
>> -		return ret;
>> -	return ERR_PTR(-ENOMEM);
>> +	return (void *) __get_free_pages(gfp, get_order(size));
>>  }
>>  
>>  static unsigned long rings_size(struct io_ring_ctx *ctx, unsigned int sq_entries,
>> @@ -3762,8 +3758,8 @@ static __cold int io_allocate_scq_urings(struct io_ring_ctx *ctx,
>>  	else
>>  		rings = io_rings_map(ctx, p->cq_off.user_addr, size);
>>  
>> -	if (IS_ERR(rings))
>> -		return PTR_ERR(rings);
>> +	if (!rings)
>> +		return -ENOMEM;
>>
> 
> Sorry, I started reviewing this, got excited about the error path quick
> fix, and didn't finish the review before it got it.
> 
> I think this change is broken for the ctx->flags & IORING_SETUP_NO_MMAP
> case, because io_rings_map returns ERR_PTR, and not NULL.  In addition,
> io_rings_map might fail for multiple reasons, and we want to propagate
> the different error codes up here.

Yeah, see my reply from some hours ago. I dropped it back then.

-- 
Jens Axboe


