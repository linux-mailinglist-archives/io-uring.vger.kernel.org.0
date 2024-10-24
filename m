Return-Path: <io-uring+bounces-3977-lists+io-uring=lfdr.de@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [147.75.199.223])
	by mail.lfdr.de (Postfix) with ESMTPS id 0CD619AEAB1
	for <lists+io-uring@lfdr.de>; Thu, 24 Oct 2024 17:36:01 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id 2F4C31C21CBA
	for <lists+io-uring@lfdr.de>; Thu, 24 Oct 2024 15:36:00 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 628431E3DF2;
	Thu, 24 Oct 2024 15:35:57 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="mhCqzKqM"
X-Original-To: io-uring@vger.kernel.org
Received: from mail-ej1-f44.google.com (mail-ej1-f44.google.com [209.85.218.44])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1C6B51C728E
	for <io-uring@vger.kernel.org>; Thu, 24 Oct 2024 15:35:54 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.218.44
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1729784157; cv=none; b=K61RXApFnCS8c9SPLe/CnqFvHdKTdFzq4CqoQykCU13meXPGeSt13Rgypk0U4AmzARkbFL2Snt1bb0ALtE9BND7kcqgiOQTqXMx64vCIx0ngU6oe32BFJgnxifiaFwqOADV4+KfgMd9AALP1TlwE24xWLxjp4y50qNpKeRnuz+k=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1729784157; c=relaxed/simple;
	bh=lcB98S5N2Pk3l5/exRxFKfeIhC/DUm378311n6oRYRs=;
	h=Message-ID:Date:MIME-Version:Subject:To:References:From:
	 In-Reply-To:Content-Type; b=a9Q3aksv5yCE2quFa84wO5MOPtiI6Ps32yd7T9zc/nmRIbaoOSIh+ZP8s04P6wdMm1IzaF8Q+n8q9UwXvSJb47xYesU5tdW/h11Ux8CpdPVzPGv7zgWpTkfCo+YpJCpLUKtGetT9us1+euM48WPfsiV+gkrUNPiYxd50qCiloPI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=mhCqzKqM; arc=none smtp.client-ip=209.85.218.44
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Received: by mail-ej1-f44.google.com with SMTP id a640c23a62f3a-a9a628b68a7so163676766b.2
        for <io-uring@vger.kernel.org>; Thu, 24 Oct 2024 08:35:54 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1729784153; x=1730388953; darn=vger.kernel.org;
        h=content-transfer-encoding:in-reply-to:from:content-language
         :references:to:subject:user-agent:mime-version:date:message-id:from
         :to:cc:subject:date:message-id:reply-to;
        bh=iAARGZnaERJLdSqoxGSicyXeEkxdgWSLPKuYFxs+2HQ=;
        b=mhCqzKqM0YFWHI0fToCof65tbRRhgqpWJ+4c6gF5/pX7Dpip/u4AtP+aQfba49oso3
         USjEmX5YIqiwRXYtErBWrfVq7S4+3AozOSmrkzCjRa3c5BjfiTQLvOmtLZBgA9wV8RuC
         6pe9lomPvt2CGw+aQSgTk6BNvtwrlwl0g/I2YSu0fc5yC/9tm0+o4IZLFHq1SAid39Be
         dOoxFKLeRkNIPzfGZVGe8Y4JSxAbvfiNkqcs8jSYwJOFzFlcNbgNwd7TLMmH90T7iy+4
         F8Rnd5izwBhgSMMbDH3su/KY0+T+ZF/2ZVj8a7ZR2iXFdHKDaqJj+hYy9duqUwdhoucl
         QWKA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1729784153; x=1730388953;
        h=content-transfer-encoding:in-reply-to:from:content-language
         :references:to:subject:user-agent:mime-version:date:message-id
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=iAARGZnaERJLdSqoxGSicyXeEkxdgWSLPKuYFxs+2HQ=;
        b=ZkhDv+UJKj1NjRzbQz2LnjbKaljyXwq7RRgziS9XN++K9+LM9qbQPlNNNUtGdgn3oM
         Qsgvwl7B43uPZALx2vFOj7JByLZYk2GyBEo5e3Ql/h+J5EYfk6LNZHnM7tBtYPL+YeK1
         QlCCUKyRGzn6k2D6wyHZ8/wSdcAlIBzN+yoZyW648X55y+RShKGYz2T3X5vyHGAScF+y
         DcvlB5REOqkbeC+Lr3LUnDWyOwQHFbwVJiehyATaVX7yYgOfEzlq60Iekt8+AE6KRcBt
         zpUQsgpL89mKeuWUbhrD5UlqyKvzYoQJcfANUld5CRPPmDPqAYMbbsKGoGQz9CNmVNrM
         25lw==
X-Forwarded-Encrypted: i=1; AJvYcCXdQHACvLmEAeVfxfKNrsDApezJxvyGF6a4yZtnE3U9mtpqCiXJNksfEPkNpkdpmhkuNLQ/T2WHaw==@vger.kernel.org
X-Gm-Message-State: AOJu0Yw/jcTPspGnwcCOuJSyksk/WIJR4brsa7TbybhX3E4hjsEqN1jP
	crYkmT2+ow433bRXCgW6ynHzQUWz/bQTB5NnMWzhntozPL53hXeO
X-Google-Smtp-Source: AGHT+IFufT9wY6o81XpgB7onAA7junF3ZnVoQhBa3sdsIPulJsAgd9VpW136vG7PCY4yxAvNJ6fxKw==
X-Received: by 2002:a17:907:1b84:b0:a9a:cac1:7aad with SMTP id a640c23a62f3a-a9acac17fd4mr288506266b.35.1729784152986;
        Thu, 24 Oct 2024 08:35:52 -0700 (PDT)
Received: from [192.168.42.27] ([85.255.233.224])
        by smtp.gmail.com with ESMTPSA id a640c23a62f3a-a9a912edfedsm631647566b.72.2024.10.24.08.35.49
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Thu, 24 Oct 2024 08:35:50 -0700 (PDT)
Message-ID: <01aec2bf-cb55-44e6-96ab-5d9ff6a5233f@gmail.com>
Date: Thu, 24 Oct 2024 16:36:24 +0100
Precedence: bulk
X-Mailing-List: io-uring@vger.kernel.org
List-Id: <io-uring.vger.kernel.org>
List-Subscribe: <mailto:io-uring+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:io-uring+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH 7/7] io_uring/net: add provided buffer and bundle support
 to send zc
To: Jens Axboe <axboe@kernel.dk>, io-uring@vger.kernel.org
References: <20241023161522.1126423-1-axboe@kernel.dk>
 <20241023161522.1126423-8-axboe@kernel.dk>
 <b826ce35-98b2-4639-9d39-d798e3b08d89@gmail.com>
 <4d61544d-3a06-4419-8dc6-f23a57740d77@kernel.dk>
Content-Language: en-US
From: Pavel Begunkov <asml.silence@gmail.com>
In-Reply-To: <4d61544d-3a06-4419-8dc6-f23a57740d77@kernel.dk>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit

On 10/24/24 15:48, Jens Axboe wrote:
> On 10/24/24 8:44 AM, Pavel Begunkov wrote:
>> On 10/23/24 17:07, Jens Axboe wrote:
>>> Provided buffers inform the kernel which buffer group ID to pick a
>>> buffer from for transfer. Normally that buffer contains the usual
>>> addr + length information, as well as a buffer ID that is passed back
>>> at completion time to inform the application of which buffer was used
>>> for the transfer.
>>>
>>> However, if registered and provided buffers are combined, then the
>>> provided buffer must instead tell the kernel which registered buffer
>>> index should be used, and the length/offset within that buffer. Rather
>>> than store the addr + length, the application must instead store this
>>> information instead.
>>>
>>> If provided buffers are used with send zc, then those buffers must be
>>> an index into a registered buffer. Change the mapping type to use
>>> KBUF_MODE_BVEC, which tells the kbuf handlers to turn the mappings
>>> into bio_vecs rather than iovecs. Then all that is needed is to
>>> setup our iov_iterator to use iov_iter_bvec().
>>>
>>> Signed-off-by: Jens Axboe <axboe@kernel.dk>
>>> ---
>> ...
>>> diff --git a/io_uring/net.h b/io_uring/net.h
>>> index 52bfee05f06a..e052762cf85d 100644
>>> --- a/io_uring/net.h
>>> +++ b/io_uring/net.h
>>> @@ -5,9 +5,15 @@
>>>      struct io_async_msghdr {
>>>    #if defined(CONFIG_NET)
>>> -    struct iovec            fast_iov;
>>> +    union {
>>> +        struct iovec        fast_iov;
>>> +        struct bio_vec        fast_bvec;
>>> +    };
>>>        /* points to an allocated iov, if NULL we use fast_iov instead */
>>> -    struct iovec            *free_iov;
>>> +    union {
>>> +        struct iovec        *free_iov;
>>> +        struct bio_vec        *free_bvec;
>>
>> I'd rather not do it like that, aliasing with reusing memory and
>> counting the number is a recipe for disaster when scattered across
>> code. E.g. seems you change all(?) iovec allocations to allocate
>> based on the size of the larger structure.
>>
>> Counting bytes as in my series is less fragile, otherwise it needs
>> a new structure and a set of helpers that can be kept together.
> 
> I have been pondering this, because I'm not a huge fan either. But
> outside of the space side, it does come out pretty nicely/clean. This
> series is really just a WIP posting as per the RFC, mostly just so we
> can come up with something that's clean enough and works for both cases,
> as it does have the caching that your series does not. And to
> facilitate some more efficient TX/RX zero copy testing.

The thing is, I know how to implement caching on top of my series,
but as I commented in the other thread, I don't think it can reuse
the incremental helper well. At least it can try to unify the imu
checking / parsing, bvec copy-setup, but that's minor.

-- 
Pavel Begunkov

