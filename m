Return-Path: <io-uring+bounces-614-lists+io-uring=lfdr.de@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [147.75.80.249])
	by mail.lfdr.de (Postfix) with ESMTPS id 5596285709E
	for <lists+io-uring@lfdr.de>; Thu, 15 Feb 2024 23:37:56 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id 0B9321F225CE
	for <lists+io-uring@lfdr.de>; Thu, 15 Feb 2024 22:37:56 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 2B46312CD93;
	Thu, 15 Feb 2024 22:37:52 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel-dk.20230601.gappssmtp.com header.i=@kernel-dk.20230601.gappssmtp.com header.b="DJ45jJBb"
X-Original-To: io-uring@vger.kernel.org
Received: from mail-io1-f43.google.com (mail-io1-f43.google.com [209.85.166.43])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B90551E894
	for <io-uring@vger.kernel.org>; Thu, 15 Feb 2024 22:37:48 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.166.43
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1708036672; cv=none; b=MlGVgc2lKV/GSxo7K52+oQHe3lf/W5wd0f+HDcqz7LxgnHvhpoB2NFwMqIlUaX9mFNC+GR2TD3lI0eieHiBWfEqcI+uJBAyFEQQRA4dqpXtsqnydLXURHbw1dcqhywcWTmYhFVIVQysQU/aMRtYxaJlpquIdXu3uLqco4KZT55Q=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1708036672; c=relaxed/simple;
	bh=UcgT6eDHcYlVFtu1IrJte0Pq790otfr1x2kMhmqBsko=;
	h=Message-ID:Date:MIME-Version:Subject:To:References:From:
	 In-Reply-To:Content-Type; b=LK82p7kyJ7utVHf95Yhs1pwIR447xSq5NI2ZMpvXAKPgBwEu3yOB/7dlbYRLZSSnrRsmhznDkpnDcHN+6LIWa13yIuvBkZrtT6y72f/Z1GxyJgIKxsIV/gcXdaKF3LzHDkN78t6k6Iht8RReg8njI29gMlSzhAd40HGFW15F8C8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=kernel.dk; spf=pass smtp.mailfrom=kernel.dk; dkim=pass (2048-bit key) header.d=kernel-dk.20230601.gappssmtp.com header.i=@kernel-dk.20230601.gappssmtp.com header.b=DJ45jJBb; arc=none smtp.client-ip=209.85.166.43
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=kernel.dk
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=kernel.dk
Received: by mail-io1-f43.google.com with SMTP id ca18e2360f4ac-7bf3283c18dso13139339f.0
        for <io-uring@vger.kernel.org>; Thu, 15 Feb 2024 14:37:48 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernel-dk.20230601.gappssmtp.com; s=20230601; t=1708036667; x=1708641467; darn=vger.kernel.org;
        h=content-transfer-encoding:in-reply-to:from:references:to
         :content-language:subject:user-agent:mime-version:date:message-id
         :from:to:cc:subject:date:message-id:reply-to;
        bh=0MyFMH/fPNSm4Kwebj4rlAxTomJEDZMqYYA97+vzbPQ=;
        b=DJ45jJBbfJ0qCirxXu9aV4OdrD56N8Rd7ogrlzbj81RXiQWKFQ43V2Dnzg+aGbU2m5
         64VQzzNrp4qM1Kc6iv8yJcuYpV91G8t9jH3sONa/AusDW20ix8J3crRUZxlAjOgvSPqn
         idjhK5ayhQQDEt8L297rJTbtJWcSbCwZ8CMiSl3dIclxWmgfVc6A7SMhGZnGzoalsG4C
         jf6Np5AMZrO2kc/pjI1GigASmnN7FveCE1g7Oq3B0JUsJ7tI5EOMtazsi7U1HItJ8Bqi
         ivWdzs63tJ2YaOKgGTfHHPlGc5Ir0m2vE/ZGIxYqdJWIC4WBHvpEIEkcdacFH2PVoB2T
         MdjQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1708036667; x=1708641467;
        h=content-transfer-encoding:in-reply-to:from:references:to
         :content-language:subject:user-agent:mime-version:date:message-id
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=0MyFMH/fPNSm4Kwebj4rlAxTomJEDZMqYYA97+vzbPQ=;
        b=Q3wAAYJJDiH/PWJMN04zSIOPNfYKun5S/AsfNnRGGRCZ/tvXz+FHGuRDaix4Yyrcc7
         V5neBSIYyPdVAureVgGhziTTgEBAwqb/mmfggnSBgYvPqLt+6DW1760PkfN3mgd7E12I
         fy2/bCmch5f2l5iQfhDaUQmR4G3uqxy8WvKTEqSxmqHT08ywTpSuVOSWSGG/WeSiSPdG
         XU8XYMg0KZDeEsuAkJP1jpw7KydQdao53y+LvZe7+N2U2Qy1T34ph1TSJCyJkF5lh8GP
         bIvriYhSB4Kc3ef9uIDXAQ/9wOzP+rwSGe7T6k09H+XuaoGlAW34ChL4cqZCxptDspd1
         ktMg==
X-Forwarded-Encrypted: i=1; AJvYcCUyLL/iHGwVbwR/AkFRkQTtuxijpEsdjU4+NZqnf4jnwbquB+9O2ZkS2G/ASIaZYnDlJotAOTbcyGWxIvSjHiRROgBveZOTrw0=
X-Gm-Message-State: AOJu0Ywe5um1zALUuddxePdKSVJBwtmZHBoDl/Gu/PLkh//WvgaAGKlp
	cEF4Qcu+L0Aou/P/b8LqophzbMyb67bjeRZaer1vLizZbS3+8KqLOw8+A3JgbxhbplpDK/dW74y
	2
X-Google-Smtp-Source: AGHT+IH4qRrHP9gMfx3+thMd7MFH6pjurvg336qL7x+WpaKe6/WQ1U53NTsz7FmjmQ7tRUiDJfcmbg==
X-Received: by 2002:a6b:5a16:0:b0:7c4:5898:11d0 with SMTP id o22-20020a6b5a16000000b007c4589811d0mr548446iob.1.1708036667548;
        Thu, 15 Feb 2024 14:37:47 -0800 (PST)
Received: from [192.168.1.116] ([96.43.243.2])
        by smtp.gmail.com with ESMTPSA id q21-20020a6bf215000000b007c71d2c950fsm57538ioh.46.2024.02.15.14.37.46
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Thu, 15 Feb 2024 14:37:47 -0800 (PST)
Message-ID: <e33f0996-7b0b-4ba8-ad88-24376e08631e@kernel.dk>
Date: Thu, 15 Feb 2024 15:37:45 -0700
Precedence: bulk
X-Mailing-List: io-uring@vger.kernel.org
List-Id: <io-uring.vger.kernel.org>
List-Subscribe: <mailto:io-uring+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:io-uring+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH] io_uring/napi: enable even with a timeout of 0
Content-Language: en-US
To: David Wei <dw@davidwei.uk>, io-uring <io-uring@vger.kernel.org>
References: <c7210193-a850-465c-bee2-ade5b36b4e2d@kernel.dk>
 <a16586d2-a488-4c5f-95a3-14256c84693c@davidwei.uk>
From: Jens Axboe <axboe@kernel.dk>
In-Reply-To: <a16586d2-a488-4c5f-95a3-14256c84693c@davidwei.uk>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit

On 2/15/24 3:37 PM, David Wei wrote:
> On 2024-02-15 15:32, Jens Axboe wrote:
>> 1 usec is not as short as it used to be, and it makes sense to allow 0
>> for a busy poll timeout - this means just do one loop to check if we
>> have anything available. Add a separate ->napi_enabled to check if napi
>> has been enabled or not.
>>
>> While at it, move the writing of the ctx napi values after we've copied
>> the old values back to userspace. This ensures that if the call fails,
>> we'll be in the same state as we were before, rather than some
>> indeterminate state.
>>
>> Signed-off-by: Jens Axboe <axboe@kernel.dk>
>>
>> ---
>>
>> diff --git a/include/linux/io_uring_types.h b/include/linux/io_uring_types.h
>> index 4fe7af8a4907..bd7071aeec5d 100644
>> --- a/include/linux/io_uring_types.h
>> +++ b/include/linux/io_uring_types.h
>> @@ -420,6 +420,7 @@ struct io_ring_ctx {
>>  	/* napi busy poll default timeout */
>>  	unsigned int		napi_busy_poll_to;
>>  	bool			napi_prefer_busy_poll;
>> +	bool			napi_enabled;
>>  
>>  	DECLARE_HASHTABLE(napi_ht, 4);
>>  #endif
>> diff --git a/io_uring/napi.c b/io_uring/napi.c
>> index b234adda7dfd..e653927a376e 100644
>> --- a/io_uring/napi.c
>> +++ b/io_uring/napi.c
>> @@ -227,12 +227,12 @@ int io_register_napi(struct io_ring_ctx *ctx, void __user *arg)
>>  	if (napi.pad[0] || napi.pad[1] || napi.pad[2] || napi.resv)
>>  		return -EINVAL;
>>  
>> -	WRITE_ONCE(ctx->napi_busy_poll_to, napi.busy_poll_to);
>> -	WRITE_ONCE(ctx->napi_prefer_busy_poll, !!napi.prefer_busy_poll);
>> -
>>  	if (copy_to_user(arg, &curr, sizeof(curr)))
>>  		return -EFAULT;
>>  
>> +	WRITE_ONCE(ctx->napi_busy_poll_to, napi.busy_poll_to);
>> +	WRITE_ONCE(ctx->napi_prefer_busy_poll, !!napi.prefer_busy_poll);
>> +	WRITE_ONCE(ctx->napi_enabled, true);
>>  	return 0;
>>  }
>>  
>> @@ -256,6 +256,7 @@ int io_unregister_napi(struct io_ring_ctx *ctx, void __user *arg)
>>  
>>  	WRITE_ONCE(ctx->napi_busy_poll_to, 0);
>>  	WRITE_ONCE(ctx->napi_prefer_busy_poll, false);
>> +	WRITE_ONCE(ctx->napi_enabled, true);
> 
> Should this be false?

It should indeed... Updated, thanks!

-- 
Jens Axboe


