Return-Path: <io-uring+bounces-6633-lists+io-uring=lfdr.de@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [139.178.88.99])
	by mail.lfdr.de (Postfix) with ESMTPS id 0FA86A4048E
	for <lists+io-uring@lfdr.de>; Sat, 22 Feb 2025 02:08:52 +0100 (CET)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id BD3DC3B56B2
	for <lists+io-uring@lfdr.de>; Sat, 22 Feb 2025 01:08:37 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id BBDB915B0EF;
	Sat, 22 Feb 2025 01:08:44 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="AMELI1l6"
X-Original-To: io-uring@vger.kernel.org
Received: from mail-wm1-f52.google.com (mail-wm1-f52.google.com [209.85.128.52])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 03E6215853B
	for <io-uring@vger.kernel.org>; Sat, 22 Feb 2025 01:08:42 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.128.52
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1740186524; cv=none; b=eVSGMPKDaezygpoy0MrSF2mtxzff9RUu+deua4F0tiAD35Kn4Xf9lgV73GP0eyDZCjuqhSHE+6O14yj10I6ZkMg+rmqjwvCyY2i8XftkM+mZomSOVFvebxdkSCum2ARASHIBGzoFNvz2Q1ISjeYLfoeeYv3q3ni31TXyEHMXBBM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1740186524; c=relaxed/simple;
	bh=7i/We4idmmCrX88ecH7ftqX9qkpj6SvV0Qf4E3DixN4=;
	h=Message-ID:Date:MIME-Version:Subject:From:To:References:
	 In-Reply-To:Content-Type; b=lkiYNjOjlfExHS6bRMefP54fxQLZ7ie8qsQxcnT1wV9y3OxaqfimD5zSlYbaDn/C7YPrPQhMLg2OqiMCPbbMFCEM5U/ybqfTo3fXhKBbgmWVZWdhP9dzOyV53dbeHxdeWSesy3Ftj7a+a++Xy6JWiT8ihLMra6/SjMySFrgOjFc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=AMELI1l6; arc=none smtp.client-ip=209.85.128.52
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Received: by mail-wm1-f52.google.com with SMTP id 5b1f17b1804b1-4399ee18a57so16222705e9.1
        for <io-uring@vger.kernel.org>; Fri, 21 Feb 2025 17:08:42 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1740186521; x=1740791321; darn=vger.kernel.org;
        h=content-transfer-encoding:in-reply-to:content-language:references
         :to:from:subject:user-agent:mime-version:date:message-id:from:to:cc
         :subject:date:message-id:reply-to;
        bh=JRo/eVLDdU7CvlKi4YzbNTA4/ToMQhMoqSGc/TY1LSU=;
        b=AMELI1l6J2QAe5a2tQIwQVPDdNqYRgeHuOU9l7dbUZH/uwa50XfuumyLVhuH8VCtKU
         ZJAVyG4zGAH7EeVKO0dvVztbo0et9KwvEbVKdQgwnPCajMpdFkX0/7U3QiCz9H5mwqye
         bDtyolFSaF3mcKzFhcvyKViHXjAauVDTdR1OoV60x2PikYp1R4UQtpdEYo4P3FpZNDOm
         Nn+sL3jmCjdaEWmWbz2Tj6Gu6Dt7N+i+pah0O7n0n52gT9VBgRc/snf71jGKxHPbCirG
         Y5XGyh8D+xQuNnxXYCl8JsWTDy6fa8VcKI/5PStxiXci2cz6AqZCf0ZsEMnOnVFlwn4F
         AoeA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1740186521; x=1740791321;
        h=content-transfer-encoding:in-reply-to:content-language:references
         :to:from:subject:user-agent:mime-version:date:message-id
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=JRo/eVLDdU7CvlKi4YzbNTA4/ToMQhMoqSGc/TY1LSU=;
        b=FBwQbUXurjY/nvyik1S4vZqKKhRVgwz7VDXKsNdrSbVO3Hqzu+qgJWLskT4Tx05wsS
         SNfWUTsmYtqMiy7c09P5ZHKC7K6jxIR+889OdLepPcI8pZ7p697smBIYRTMlCXgLi2uv
         /sOyMVsL61JVCMCYWXYkUpPPJGuPitTlsmKrU7bs0qOwGpZsMVDyv5QRhgGamMqP+PlJ
         qdF7T7CMt/Mh7QllnXVgXZKL6euciaSToiQcGM3nODiBGOSWzTxfv6AhcylC6vOqqVFI
         aMLsGgpzfE74T627sRhb0QhDvg86DdMveitpvs76Vu+QvlmJnVFTZQmB4EQzCCcYvcn4
         QpPw==
X-Forwarded-Encrypted: i=1; AJvYcCWLGC9/jPb7z+o3SGkDepxK4svPSqPq8eSzPj9n+V0orOP1F7bVkFCGxyurl9l2nnBGYoOHMFkjDA==@vger.kernel.org
X-Gm-Message-State: AOJu0YztPD4N25tzzMbwgfPmnpWCsHa0TG0TNMELad9OY9h4eJsObQHx
	ah3fvyy502ulpHAq68jI9HgQeQQums3OtACH7MZ+zwgmfgqAqSrK
X-Gm-Gg: ASbGncuIDJVQOqeUIAE4HEnVO2VSRiHJD3jRgIPUJ5SX9uizLJeBOocKzlG2kxbmMPK
	cyJlvwYYJzX9YGquMJoSDoYKZD4qkZfEjPEfutCzp3Wz6ESh2I3EW3vtiNkfC+/AfZPxjlHGm4+
	h6Nkh7crBz5qOsHBSW8K5yDC9R4y4N3jCOcSh3gp72yM77dKi03EBZbjvNy6Xt7mtGUCD1xGZ6x
	JCAJr7LUSV4IZKsEoMCwpaORxdJaXtBgXKkClrEcZMb1lcZLZHmfhzXf75vQVrQ7COGuXbT8b6l
	7yA0xvyKEbfI8Zh3GQZRFv4S3s62gf+o7SiC
X-Google-Smtp-Source: AGHT+IGpnPXmGVutcPNi84rNgi12UT2AQdPe4vFb8o5fsCk9JvuAb2BjbXmaPWkUNblMe3DZEwdPbw==
X-Received: by 2002:a05:600c:1d0b:b0:439:98fd:a4b6 with SMTP id 5b1f17b1804b1-439ae33cb6bmr45158175e9.15.1740186521047;
        Fri, 21 Feb 2025 17:08:41 -0800 (PST)
Received: from [192.168.8.100] ([148.252.141.194])
        by smtp.gmail.com with ESMTPSA id 5b1f17b1804b1-439b03675dfsm32362685e9.29.2025.02.21.17.08.38
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Fri, 21 Feb 2025 17:08:40 -0800 (PST)
Message-ID: <58441ad9-f1b2-4869-9bef-2491157d75f6@gmail.com>
Date: Sat, 22 Feb 2025 01:09:45 +0000
Precedence: bulk
X-Mailing-List: io-uring@vger.kernel.org
List-Id: <io-uring.vger.kernel.org>
List-Subscribe: <mailto:io-uring+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:io-uring+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v2 1/2] io_uring/zcrx: add single shot recvzc
From: Pavel Begunkov <asml.silence@gmail.com>
To: Jens Axboe <axboe@kernel.dk>, David Wei <dw@davidwei.uk>,
 io-uring@vger.kernel.org
References: <20250221205146.1210952-1-dw@davidwei.uk>
 <20250221205146.1210952-2-dw@davidwei.uk>
 <6165d6a4-a8d3-4c2f-8550-e157a279c8f3@gmail.com>
 <a44a6ed1-8a4c-4334-9785-aee8b545c68d@kernel.dk>
 <516fdf90-1f0a-4c2e-b7ed-23a72b7a4342@gmail.com>
Content-Language: en-US
In-Reply-To: <516fdf90-1f0a-4c2e-b7ed-23a72b7a4342@gmail.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit

On 2/22/25 01:06, Pavel Begunkov wrote:
> On 2/22/25 00:52, Jens Axboe wrote:
>>>> @@ -1250,6 +1251,12 @@ int io_recvzc_prep(struct io_kiocb *req, const struct io_uring_sqe *sqe)
>>>>        zc->ifq = req->ctx->ifq;
>>>>        if (!zc->ifq)
>>>>            return -EINVAL;
>>>> +    zc->len = READ_ONCE(sqe->len);
>>>> +    if (zc->len == UINT_MAX)
>>>> +        return -EINVAL;
>>>
>>> The uapi gives u32, if we're using a special value it should
>>> match the type. ~(u32)0
>>
>> Any syscall in Linux is capped at 2G anyway, so I think all of this
> 
> I don't see how it related, you don't have to have a weird
> 00111111b as a special value.
> 
>> special meaning of ->len just needs to go away. Just ask for whatever

And there will need to be some special value for that. Setting
the maximum limit to 4GB is reasonable, but when it's crunching
data without limits 4GB is nothing. IMHO not worth growing the
uapi field u32 -> u64.

>> bytes you want, but yes more than 2G will not be supported anyway.
> 
> That's not the case here, the request does support more than 2G,
> it's just spread across multiple CQEs, and the limit accounts
> for multiple CQEs.
> 

-- 
Pavel Begunkov


