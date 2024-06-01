Return-Path: <io-uring+bounces-2060-lists+io-uring=lfdr.de@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [147.75.80.249])
	by mail.lfdr.de (Postfix) with ESMTPS id 21C468D7185
	for <lists+io-uring@lfdr.de>; Sat,  1 Jun 2024 20:33:17 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id 9AB521F2184E
	for <lists+io-uring@lfdr.de>; Sat,  1 Jun 2024 18:33:16 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 4491B1D6AA;
	Sat,  1 Jun 2024 18:33:12 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel-dk.20230601.gappssmtp.com header.i=@kernel-dk.20230601.gappssmtp.com header.b="0KnP/84M"
X-Original-To: io-uring@vger.kernel.org
Received: from mail-pl1-f177.google.com (mail-pl1-f177.google.com [209.85.214.177])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id AEB6314267
	for <io-uring@vger.kernel.org>; Sat,  1 Jun 2024 18:33:08 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.214.177
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1717266792; cv=none; b=iEULhCMHZGV8RG9mHqwOTLiNa3x74McOCgmjZSvsUf4AgWwFd/zt2ioMQSIQd1/DB3kM6idJOFn0CIkOyof6HNF08ytPm8QS6bB75tVZVTCuqtG/UVEzhBVWafnSCH8W4ug3TudyuKH3tE7Q8jesVXpd8Swr27wCjLb6KKI03YA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1717266792; c=relaxed/simple;
	bh=qYfHJpJLTr8TLyuKoD5FAPfltNd6fHQozIHFBPgHSbY=;
	h=Message-ID:Date:MIME-Version:Subject:To:References:From:
	 In-Reply-To:Content-Type; b=AH6irIoZ5u5cqD14LCs1MMznPoga+3mkt3jtriczV3pacynFAlMVMG/SiMjf8uVjpyuSC7UQR+vPgdFlFzgs3jYluGosLQYeqOq5aWCQSafeYVXatEgKVDjvFH43rEozPeGoKfKZ40WThet/owmAe/gXQhGSk1pMmTs3nwJLjd4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=kernel.dk; spf=pass smtp.mailfrom=kernel.dk; dkim=pass (2048-bit key) header.d=kernel-dk.20230601.gappssmtp.com header.i=@kernel-dk.20230601.gappssmtp.com header.b=0KnP/84M; arc=none smtp.client-ip=209.85.214.177
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=kernel.dk
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=kernel.dk
Received: by mail-pl1-f177.google.com with SMTP id d9443c01a7336-1f61cca4a17so1300105ad.2
        for <io-uring@vger.kernel.org>; Sat, 01 Jun 2024 11:33:08 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernel-dk.20230601.gappssmtp.com; s=20230601; t=1717266788; x=1717871588; darn=vger.kernel.org;
        h=content-transfer-encoding:in-reply-to:from:content-language
         :references:to:subject:user-agent:mime-version:date:message-id:from
         :to:cc:subject:date:message-id:reply-to;
        bh=wDlTxqQodG+OTPLxL8e147DvNSWbxId9ZMwCfC5emQo=;
        b=0KnP/84M7XlWRCgLVDGVsfmxtAAvw3vBY6UIDvPOFPPJiWE6tvxR9+RuoT5anq7rdj
         DtvGhIXCGQlt4sbubKJDTHQ0aLMfxrUgx9tUXKIZh9Dx1wapLKf+ku7sg8hTXudSSUK7
         fbRUYJhw8xztQe8l9+pxRSd7hce4b5goeApmV2W+HbOuBPlfp6rUQXuFtd0TA+gWEN5F
         +DndaNxz7Bbv/eku5QKQUNueEy4iy+ieTCQz66w4d9WpsRdAm/RwCdSSFF12tozqwfD+
         d3+6413sm3tkJCcActUfcKunlDaJAeSnJHXh2vLOCyy73CYo0OGtQ0Om5X+sWYGki2W3
         6vUw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1717266788; x=1717871588;
        h=content-transfer-encoding:in-reply-to:from:content-language
         :references:to:subject:user-agent:mime-version:date:message-id
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=wDlTxqQodG+OTPLxL8e147DvNSWbxId9ZMwCfC5emQo=;
        b=Z3dh7yRCj6a0gOaDiFHW573NYKN8es+uSPrYXh0kLD7sj2X3OXrO3FgSJTxCFaGNye
         DgYYVHv8A8Bp2w1LkCb1YTG6m5AEjmaoJvoyNAabOJs1UNeQlraTGceyDFZEz/Knt0+0
         szrplPsipHGsZVOkfrdzLAqnz0jW9TxqHEeTYDtGdPRpBQPw2oO2KG4fJ5kU2QtQO7Qk
         RDu1dcG2GstWXbXdQmIIo1Izbs5+T9W9H2PNGO8/HlH+r2pjn7KxgUMnbqBWDdOgxWpp
         BzraqpMxYb109ipk83/aaPOBPSy1hllsIrEoOMJVuvMlxako/kqflcDCF+/w5ejJ7IH+
         vv1g==
X-Forwarded-Encrypted: i=1; AJvYcCUW2oeKP4ykZXQ+SN4T98PtgIvBpjmH32PjF+/YcE+QrRj0m4hg9ZQW5HBBCkx3nHqX0XcLivVM232zIEnUcZzTWQHp18bRc9c=
X-Gm-Message-State: AOJu0YxfWp02KPY8oL59kYpoVSgbycK9lEiJcjt+8Qxo6PlGnMyapQvL
	BF+iUJ2S6I5mI3rxuWmcNGe4U/kPHvlvD8l7dVXjOW0bOsYiy9R3EiKli1YF9J4=
X-Google-Smtp-Source: AGHT+IGuk380ui2h/45f4aRZjBjWKL8Kb8LwY/TqlXaWUeJtDKthIUw5rXeizyTsiebW9utzkX3ilA==
X-Received: by 2002:a05:6a21:271c:b0:1b0:219d:79a6 with SMTP id adf61e73a8af0-1b26f30e7cbmr5015277637.5.1717266787823;
        Sat, 01 Jun 2024 11:33:07 -0700 (PDT)
Received: from [192.168.1.150] ([198.8.77.157])
        by smtp.gmail.com with ESMTPSA id d2e1a72fcca58-702437b5c3esm3031184b3a.121.2024.06.01.11.33.06
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Sat, 01 Jun 2024 11:33:07 -0700 (PDT)
Message-ID: <c6c149ac-ce0e-4c21-b235-03b5d8250d86@kernel.dk>
Date: Sat, 1 Jun 2024 12:33:06 -0600
Precedence: bulk
X-Mailing-List: io-uring@vger.kernel.org
List-Id: <io-uring.vger.kernel.org>
List-Subscribe: <mailto:io-uring+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:io-uring+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: madvise/fadvise 32-bit length
To: Stefan <source@s.muenzel.net>, io-uring@vger.kernel.org
References: <bc92a2fa-4400-4c3a-8766-c2e346113ea7@s.muenzel.net>
 <db4d32d6-cc71-4903-92cf-b1867b8c7d12@kernel.dk>
 <2d4d3434-401c-42c2-b450-40dec4689797@kernel.dk>
 <c9059b69-96d0-45e6-8d05-e44298d7548e@s.muenzel.net>
 <d6e2f493-87ca-4203-8d23-2ced10d47d02@kernel.dk>
 <8b08398d-a66d-42ad-a776-78b52d5231c4@s.muenzel.net>
Content-Language: en-US
From: Jens Axboe <axboe@kernel.dk>
In-Reply-To: <8b08398d-a66d-42ad-a776-78b52d5231c4@s.muenzel.net>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit

On 6/1/24 9:51 AM, Stefan wrote:
> On 1/6/2024 17:35, Jens Axboe wrote:
>> On 6/1/24 9:22 AM, Stefan wrote:
>>> On 1/6/2024 17:05, Jens Axboe wrote:
>>>> On 6/1/24 8:19 AM, Jens Axboe wrote:
>>>>> On 6/1/24 3:43 AM, Stefan wrote:
>>>>>> io_uring uses the __u32 len field in order to pass the length to
>>>>>> madvise and fadvise, but these calls use an off_t, which is 64bit on
>>>>>> 64bit platforms.
>>>>>>
>>>>>> When using liburing, the length is silently truncated to 32bits (so
>>>>>> 8GB length would become zero, which has a different meaning of "until
>>>>>> the end of the file" for fadvise).
>>>>>>
>>>>>> If my understanding is correct, we could fix this by introducing new
>>>>>> operations MADVISE64 and FADVISE64, which use the addr3 field instead
>>>>>> of the length field for length.
>>>>>
>>>>> We probably just want to introduce a flag and ensure that older stable
>>>>> kernels check it, and then use a 64-bit field for it when the flag is
>>>>> set.
>>>>
>>>> I think this should do it on the kernel side, as we already check these
>>>> fields and return -EINVAL as needed. Should also be trivial to backport.
>>>> Totally untested... Might want a FEAT flag for this, or something where
>>>> it's detectable, to make the liburing change straight forward.
>>>>
>>>>
>>>> diff --git a/io_uring/advise.c b/io_uring/advise.c
>>>> index 7085804c513c..cb7b881665e5 100644
>>>> --- a/io_uring/advise.c
>>>> +++ b/io_uring/advise.c
>>>> @@ -17,14 +17,14 @@
>>>>    struct io_fadvise {
>>>>        struct file            *file;
>>>>        u64                offset;
>>>> -    u32                len;
>>>> +    u64                len;
>>>>        u32                advice;
>>>>    };
>>>>      struct io_madvise {
>>>>        struct file            *file;
>>>>        u64                addr;
>>>> -    u32                len;
>>>> +    u64                len;
>>>>        u32                advice;
>>>>    };
>>>>    @@ -33,11 +33,13 @@ int io_madvise_prep(struct io_kiocb *req, const struct io_uring_sqe *sqe)
>>>>    #if defined(CONFIG_ADVISE_SYSCALLS) && defined(CONFIG_MMU)
>>>>        struct io_madvise *ma = io_kiocb_to_cmd(req, struct io_madvise);
>>>>    -    if (sqe->buf_index || sqe->off || sqe->splice_fd_in)
>>>> +    if (sqe->buf_index || sqe->splice_fd_in)
>>>>            return -EINVAL;
>>>>          ma->addr = READ_ONCE(sqe->addr);
>>>> -    ma->len = READ_ONCE(sqe->len);
>>>> +    ma->len = READ_ONCE(sqe->off);
>>>> +    if (!ma->len)
>>>> +        ma->len = READ_ONCE(sqe->len);
>>>>        ma->advice = READ_ONCE(sqe->fadvise_advice);
>>>>        req->flags |= REQ_F_FORCE_ASYNC;
>>>>        return 0;
>>>> @@ -78,11 +80,13 @@ int io_fadvise_prep(struct io_kiocb *req, const struct io_uring_sqe *sqe)
>>>>    {
>>>>        struct io_fadvise *fa = io_kiocb_to_cmd(req, struct io_fadvise);
>>>>    -    if (sqe->buf_index || sqe->addr || sqe->splice_fd_in)
>>>> +    if (sqe->buf_index || sqe->splice_fd_in)
>>>>            return -EINVAL;
>>>>          fa->offset = READ_ONCE(sqe->off);
>>>> -    fa->len = READ_ONCE(sqe->len);
>>>> +    fa->len = READ_ONCE(sqe->addr);
>>>> +    if (!fa->len)
>>>> +        fa->len = READ_ONCE(sqe->len);
>>>>        fa->advice = READ_ONCE(sqe->fadvise_advice);
>>>>        if (io_fadvise_force_async(fa))
>>>>            req->flags |= REQ_F_FORCE_ASYNC;
>>>>
>>>
>>>
>>> If we want to have the length in the same field in both *ADVISE
>>> operations, we can put a flag in splice_fd_in/optlen.
>>
>> I don't think that part matters that much.
>>
>>> Maybe the explicit flag is a bit clearer for users of the API
>>> compared to the implicit flag when setting sqe->len to zero?
>>
>> We could go either way. The unused fields returning -EINVAL if set right
>> now can serve as the flag field - if you have it set, then that is your
>> length. If not, then the old style is the length. That's the approach I
>> took, rather than add an explicit flag to it. Existing users that would
>> set the 64-bit length fields would get -EINVAL already. And since the
>> normal flags field is already used for advice flags, I'd prefer just
>> using the existing 64-bit zero fields for it rather than add a flag in
>> an odd location. Would also make for an easier backport to stable.
>>
>> But don't feel that strongly about that part.
>>
>> Attached kernel patch with FEAT added, and liburing patch with 64
>> versions added.
>>
> 
> Sounds good!
> Do we want to do anything about the current (32-bit) functions in
> liburing? They silently truncate the user's values, so either marking
> them deprecated or changing the type of length in the arguments to a
> __u32 could help.

I like changing it to an __u32, and then we'll add a note to the man
page for them as well (with references to the 64-bit variants).

I still need to write a test and actually test the patches, but I'll get
to that Monday. If you want to write a test case that checks the 64-bit
range, then please do!

-- 
Jens Axboe


