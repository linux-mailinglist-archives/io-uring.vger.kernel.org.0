Return-Path: <io-uring+bounces-6635-lists+io-uring=lfdr.de@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [147.75.80.249])
	by mail.lfdr.de (Postfix) with ESMTPS id C91B5A40495
	for <lists+io-uring@lfdr.de>; Sat, 22 Feb 2025 02:14:10 +0100 (CET)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id 15A0419E08A8
	for <lists+io-uring@lfdr.de>; Sat, 22 Feb 2025 01:14:17 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 99D42158868;
	Sat, 22 Feb 2025 01:14:06 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="nT3+1H3L"
X-Original-To: io-uring@vger.kernel.org
Received: from mail-wm1-f51.google.com (mail-wm1-f51.google.com [209.85.128.51])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id DDB1115853B
	for <io-uring@vger.kernel.org>; Sat, 22 Feb 2025 01:14:04 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.128.51
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1740186846; cv=none; b=EvSolvYEJrIKO9tYwBZnaygTn8cpRapineiXu8cvpAGtYdB0LYfcKYSxOgu672ctKZIJ2NYTzH5ww9msPQk2kYb2pCam6egcg4Anc77221HdO3PTmYDFvocTFyMdRyOSK+53r8dLEMHxbfZPcYNwKppfWQKbWl9/hjVsQRx8l2o=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1740186846; c=relaxed/simple;
	bh=K4yQCtH8PO5z4ATGi8+ol/rd512t002Cq4YHUILnVyc=;
	h=Message-ID:Date:MIME-Version:Subject:To:References:From:
	 In-Reply-To:Content-Type; b=O9/v1aCd44j22tjRuzAQeUm5+iW4hLTDH/Sv7ExTSU0qVrm9rtbndd4zdGpbc3JGgJ98etMldHREA4X7dByQf16Z4K8Eh56hJuQJSl9WxpHzhKWrDjVMwP/Hse43m4WXgOUOZL6aLux3mJLbtlGzjNv/mTm6clv2VBz3X5GafBU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=nT3+1H3L; arc=none smtp.client-ip=209.85.128.51
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Received: by mail-wm1-f51.google.com with SMTP id 5b1f17b1804b1-4398c8c8b2cso27031285e9.2
        for <io-uring@vger.kernel.org>; Fri, 21 Feb 2025 17:14:04 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1740186843; x=1740791643; darn=vger.kernel.org;
        h=content-transfer-encoding:in-reply-to:from:content-language
         :references:to:subject:user-agent:mime-version:date:message-id:from
         :to:cc:subject:date:message-id:reply-to;
        bh=I5GOlc5mP7gLWQonKRGoDJ8d8RkjwWcaStwIa8BFjAA=;
        b=nT3+1H3LGWkFcDZ5QMKccapee9hy9HcOirqG6YxYaD2OHLlcX1MDqz3cKobmLilscm
         fZEm9QiRqEBsDhOxmZmiJG7ZdJzHFtweovSPfY1kykYrPIa5s2/mj2/HqRGbcG7fREHu
         Tp8j1M+m0DICGPUcZP+tlZQq8X5Ys3pqIezDvBWYbU+1ASNaeXGgLs4+FBFW0UzUkJDb
         r3vdWKJKwFxCtA6F7geX+Ge+xEIIImN4bYTJtCBUWrsD6wbX20sMdwE5Oecj9D8AOyl/
         tyGkmXu7V0lN7LNTEMEpzcuOnzAPyrxxMMwo8C3z62EoPyJ/+vn8YAYlFkHau9Dp09SJ
         IRNw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1740186843; x=1740791643;
        h=content-transfer-encoding:in-reply-to:from:content-language
         :references:to:subject:user-agent:mime-version:date:message-id
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=I5GOlc5mP7gLWQonKRGoDJ8d8RkjwWcaStwIa8BFjAA=;
        b=FCkTpNro8R7B1zlspnJFcA2ve7qQCltvt4Q33Ka+1oJKqRqPH7SwTV7vpVsmS1VPwQ
         +NDc73WD5N4RHJ5HHukd76lk95VRtJ6sqM03rwQ4hxHNVDs9fucN3RtwmkglBKvJOoMT
         WLoF+IRkeaOF5GNZ0htNysjhVETrZH48lX4kHw8vTtbV1k4mUsO76r4u0GXasOX7dyVH
         HWRu6Xfljus8dK+Y/P2sfA0KqzDk3qcr91FWnIBwKxQjTQawRxk7V+MEiyHaWmU8GNx4
         9diZJqEC47sajjG3C4pG/4binAX1EGvJrQWadRSxd4XZ3o0035EatF4cRMwp7g013Aru
         OLjA==
X-Forwarded-Encrypted: i=1; AJvYcCVVSnVeygLKlQtCLwdzeg9HRuqnotJPA+oFFK7H5N4SSSnhZ2wUpKmCp3Oc18KzCAkhJa05dthiBg==@vger.kernel.org
X-Gm-Message-State: AOJu0YwIFmwaZq/X449egKfbIrSrrodLulrSfaPuYOR4JHh+L9eb2OZd
	WFz3LsP8GRzzP1P0OR8r3MQBb+tE5lzhWwFrUOsKqf6SjYr0NvMqTq66XA==
X-Gm-Gg: ASbGnctu8h73ISUKte49GKBzDozoXgtpGtvUB+VK8DBwaXDebLjRsZ4Z9AyLmDBShc2
	myyis5FSy0B+FFCkZ2o1s/F6CxJVaVYRmlYgaM4JWF3IzZVSqHOT2NbNfZUdrTEkTlnYLZcTvDi
	z9lRDD8dZwHbHTCDPYCRUBDvBmskfWJZCViDAROouTg5Jl+caolVSF/lLaFdLSbjVVW9qgpKKeH
	ILFpRC9/pFjx3ZUI09aLs06Svz6Cb+oBLd1KOK6ZUpug5n3YfJIjOwkinu+GKBOw/57j4Bhp4Az
	Tk7+ovizrpp54OK9+ej4kBoa5hHUgBoL/n5s
X-Google-Smtp-Source: AGHT+IH05QM91HU5/2NJtkKy3dprt6BSaasst1pQ/wK3a/IS6ReSnAVVxpkvh3lici9DxcdJ6URouA==
X-Received: by 2002:a05:600c:524a:b0:439:86c4:a8ec with SMTP id 5b1f17b1804b1-439ae1f1147mr52146855e9.15.1740186842901;
        Fri, 21 Feb 2025 17:14:02 -0800 (PST)
Received: from [192.168.8.100] ([148.252.141.194])
        by smtp.gmail.com with ESMTPSA id 5b1f17b1804b1-439b0367577sm32419725e9.25.2025.02.21.17.13.59
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Fri, 21 Feb 2025 17:14:01 -0800 (PST)
Message-ID: <d0253c85-a035-4338-842b-7782c6625235@gmail.com>
Date: Sat, 22 Feb 2025 01:15:05 +0000
Precedence: bulk
X-Mailing-List: io-uring@vger.kernel.org
List-Id: <io-uring.vger.kernel.org>
List-Subscribe: <mailto:io-uring+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:io-uring+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v2 1/2] io_uring/zcrx: add single shot recvzc
To: Jens Axboe <axboe@kernel.dk>, David Wei <dw@davidwei.uk>,
 io-uring@vger.kernel.org
References: <20250221205146.1210952-1-dw@davidwei.uk>
 <20250221205146.1210952-2-dw@davidwei.uk>
 <6165d6a4-a8d3-4c2f-8550-e157a279c8f3@gmail.com>
 <a44a6ed1-8a4c-4334-9785-aee8b545c68d@kernel.dk>
 <516fdf90-1f0a-4c2e-b7ed-23a72b7a4342@gmail.com>
 <13ebc224-a280-4d60-89ca-d777dc7553b2@kernel.dk>
Content-Language: en-US
From: Pavel Begunkov <asml.silence@gmail.com>
In-Reply-To: <13ebc224-a280-4d60-89ca-d777dc7553b2@kernel.dk>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit

On 2/22/25 01:09, Jens Axboe wrote:
> On 2/21/25 6:06 PM, Pavel Begunkov wrote:
>> On 2/22/25 00:52, Jens Axboe wrote:
>>>>> @@ -1250,6 +1251,12 @@ int io_recvzc_prep(struct io_kiocb *req, const struct io_uring_sqe *sqe)
>>>>>         zc->ifq = req->ctx->ifq;
>>>>>         if (!zc->ifq)
>>>>>             return -EINVAL;
>>>>> +    zc->len = READ_ONCE(sqe->len);
>>>>> +    if (zc->len == UINT_MAX)
>>>>> +        return -EINVAL;
>>>>
>>>> The uapi gives u32, if we're using a special value it should
>>>> match the type. ~(u32)0
>>>
>>> Any syscall in Linux is capped at 2G anyway, so I think all of this
>>
>> I don't see how it related, you don't have to have a weird
>> 00111111b as a special value.
>>
>>> special meaning of ->len just needs to go away. Just ask for whatever
>>> bytes you want, but yes more than 2G will not be supported anyway.
>>
>> That's not the case here, the request does support more than 2G,
>> it's just spread across multiple CQEs, and the limit accounts
>> for multiple CQEs.
> 
> All pretty moot if we just go with 0 as the "transfer whatever length
> you want", as obviously each individual transfer will be limited anyway.
> Which is the better choice than having some odd 4G value.

I think so as well, and we'd need to check for 0 otherwise.
And it's probably fine to reserve a U32_MAX as above if it
has a chance to make (even if in the future) handling easier,
not like prep is performance sensitive.

-- 
Pavel Begunkov


