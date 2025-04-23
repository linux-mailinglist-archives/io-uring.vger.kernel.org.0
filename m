Return-Path: <io-uring+bounces-7670-lists+io-uring=lfdr.de@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [IPv6:2604:1380:45d1:ec00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 85CFBA99496
	for <lists+io-uring@lfdr.de>; Wed, 23 Apr 2025 18:18:19 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id D8FBF1753C4
	for <lists+io-uring@lfdr.de>; Wed, 23 Apr 2025 16:05:56 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id EE9DF284B42;
	Wed, 23 Apr 2025 15:58:31 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="j6BdaL/q"
X-Original-To: io-uring@vger.kernel.org
Received: from mail-ej1-f53.google.com (mail-ej1-f53.google.com [209.85.218.53])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 34C451FECBD
	for <io-uring@vger.kernel.org>; Wed, 23 Apr 2025 15:58:29 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.218.53
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1745423911; cv=none; b=eMdno715gESVgtbJ9NJd+yn+5QV7mNcGW/tVtFObJcBdQ0Bpl+V4wcH1P64ze4NTNo3SlSaN2xYX83F8ymYgDRpcFcJPRto4tAztmlnJBOf8IMgKXGTGxe7mLfaHI8LJYfE34EPToxzdwh8ftUibrd/FcAy8KNjAY0KmwPvnVtA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1745423911; c=relaxed/simple;
	bh=4rpzMj86OMA5MzinaKv5wKdJV37zmXkHwrS0ZQfIl5M=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=cK5XRWTO/6bG5bnPftMOodPTMgiVMrg8BFqwnR8s6z/l+EkyzSaJDEgwQLAt+eVVl7Lu/N/T21enZC8iOLAr+Gqd2zqkkgwVcRZJN6afhT+Sdsm3873z6O9HzPSiGFxCS2UFpDtEG7h44VUz2YSMBmQt/3zxAAXpBeO0nxIPbaY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=j6BdaL/q; arc=none smtp.client-ip=209.85.218.53
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Received: by mail-ej1-f53.google.com with SMTP id a640c23a62f3a-ace333d5f7bso2791666b.3
        for <io-uring@vger.kernel.org>; Wed, 23 Apr 2025 08:58:29 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1745423908; x=1746028708; darn=vger.kernel.org;
        h=content-transfer-encoding:in-reply-to:from:content-language
         :references:cc:to:subject:user-agent:mime-version:date:message-id
         :from:to:cc:subject:date:message-id:reply-to;
        bh=I3ErCwfDTgiAnTNnuK8CfPmWZxq1RibDJ3AMIQVEm9U=;
        b=j6BdaL/quE0HGEgWNhfu3Z1dtAXAJ2XYTQpZGRfC6tPHoKNvR2gWMVx9Dcgs13Q4RO
         fhOPQzofLIJLfknd9N3qo4LvNhpJqXtS3lNQVT+xkoBMIp4d29FUlAA/RO2IcCn9S7ud
         XFqHyit385ACvO3UvRjwQ8oLDCdAK5U0aJTDyTRugvdBoerjx/MA3f8SbZfS0uqJHn9E
         yuwYfEE4Po/wCBEnCuIeF1d42/W43mS4C4bQafEpamKZuaa38KqYZ7qNDAF0MUbV8y5f
         yUaWymvtxWL+2UGcdrbrjgmmJOCHhqOlVu3HgWiQOImQEPO6enJTwqs3V4BexEetPw29
         cshg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1745423908; x=1746028708;
        h=content-transfer-encoding:in-reply-to:from:content-language
         :references:cc:to:subject:user-agent:mime-version:date:message-id
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=I3ErCwfDTgiAnTNnuK8CfPmWZxq1RibDJ3AMIQVEm9U=;
        b=J38wNbNPClUxs91gaewk5aXyfJMdf4inUNXC607eEz3D8AbId8UqmM8TsBQQJ8Xlk2
         xR/U3nSv91lTuQOMuyo4V7551j0F5wVrkkkpIi6+ToZSC1+9MSIu/FUAlY4qqKgKo3lq
         CHszVEu17Jnx+MSMX9a0UlQtuDFu3Y62QSPLYZt8hCcnHlgrh8wROIDr27Nr874wfkjc
         z0kWQTG7gCYrQNiJ4DZHBhS8eQdoacX1Rl2bXAt02ekns5KcdmDnVMIJ5K4/hC0simb+
         yz+c7IK0DNOeFigoaHqMGHddRx2Of5M5teNy7KqGbGh4hBNzZ1OpPBMYXyNlk3mf/Dfq
         fr/g==
X-Gm-Message-State: AOJu0YyPHu15gqkbeQOn+11x0YTsJ4UDglQ/D3yGHFqhC/QyBRF7rzbF
	Rqt9hQS7a5h6SdFvf7Qyw3pwbrStIhtbQSiKvm2ZekpgVcLl6eS5wWPZjw==
X-Gm-Gg: ASbGncvUs0XL4xwqieo4oxuSHkAPWP0B4jwk/B//qclNfYbJ+OGKU3Gy9KtGp009OQj
	CRKtfQQ1irriuUjEVA9pqkYWh94lRuvn2FbQdLmhs1OfcRgJx6SKQL1J8C2QAnTjmLDDsuWoGSX
	/wgA2MQz5R8LrQWSV2USvE2sBqktiaivbKDnjeN3YFMr4GeEGBbXM3e21hOnxsy5SBmwJwvpswW
	uPJ+8VzxgdSWN/HDFAxjwIaVwybJDFMrtM1e3zN+Pd7znlFyr0CmwlXlqhVAB4FjkpWfSCBgfrm
	/NgXLFRMgp5AKNJUzc//AIbNORnRwdmF43lRjspJiRo1gy/HeK7v8ZIZzJGQqw==
X-Google-Smtp-Source: AGHT+IHm4fwoP4EKxnVTogU6lqCQX1Sl7DWeK3JlPKt8bea2nBlimENKb+egLURVLY2uMdkXbpa5NA==
X-Received: by 2002:a17:907:1b21:b0:acb:33c6:5c71 with SMTP id a640c23a62f3a-acb74b8189cmr1840050666b.29.1745423907917;
        Wed, 23 Apr 2025 08:58:27 -0700 (PDT)
Received: from [192.168.8.100] ([148.252.133.217])
        by smtp.gmail.com with ESMTPSA id a640c23a62f3a-acb6ec4c6b5sm806561466b.49.2025.04.23.08.58.26
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Wed, 23 Apr 2025 08:58:27 -0700 (PDT)
Message-ID: <e46727de-e981-4aa3-9cb4-38a5c4b27c5c@gmail.com>
Date: Wed, 23 Apr 2025 16:59:41 +0100
Precedence: bulk
X-Mailing-List: io-uring@vger.kernel.org
List-Id: <io-uring.vger.kernel.org>
List-Subscribe: <mailto:io-uring+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:io-uring+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [bug report] io_uring/zcrx: add support for multiple ifqs
To: Jens Axboe <axboe@kernel.dk>, Dan Carpenter <dan.carpenter@linaro.org>
Cc: io-uring@vger.kernel.org
References: <aAiTlrx6uXuyoCkf@stanley.mountain>
 <6047214a-794f-400b-993c-5b5ef9e6daf6@gmail.com>
 <83595e5a-ae53-4ca8-86a9-5909833b77bd@gmail.com>
 <46aa0cb5-87e6-47e8-b949-7e414e5723e3@kernel.dk>
Content-Language: en-US
From: Pavel Begunkov <asml.silence@gmail.com>
In-Reply-To: <46aa0cb5-87e6-47e8-b949-7e414e5723e3@kernel.dk>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit

On 4/23/25 14:14, Jens Axboe wrote:
> On 4/23/25 4:30 AM, Pavel Begunkov wrote:
>> On 4/23/25 11:04, Pavel Begunkov wrote:
>>> On 4/23/25 08:15, Dan Carpenter wrote:
>>>> Hello Pavel Begunkov,
>>>>
>>>> Commit 9c2a1c508442 ("io_uring/zcrx: add support for multiple ifqs")
>>>> from Apr 20, 2025 (linux-next), leads to the following Smatch static
>>>> checker warning:
>>>>
>>>>      io_uring/zcrx.c:457 io_register_zcrx_ifq()
>>>>      error: uninitialized symbol 'id'.
>>>>
>>>> io_uring/zcrx.c
>>> ...
>>>>       396         ifq = io_zcrx_ifq_alloc(ctx);
>>>>       397         if (!ifq)
>>>>       398                 return -ENOMEM;
>>>>       399
>>>>       400         scoped_guard(mutex, &ctx->mmap_lock) {
>>>>       401                 /* preallocate id */
>>>>       402                 ret = xa_alloc(&ctx->zcrx_ctxs, &id, NULL, xa_limit_31b, GFP_KERNEL);
>>>>       403                 if (ret)
>>>>       404                         goto err;
>>>>
>>>> Potentially uninitialized on this path.  Presumably we don't need to
>>>> erase id if alloc fails.
>>>
>>> Thanks for letting know
>>
>> Jens, do you want a separate patch or to fix it up as it's the top
>> patch? This should do
> 
> I can just fold it in - done!

Great, thanks!

-- 
Pavel Begunkov


