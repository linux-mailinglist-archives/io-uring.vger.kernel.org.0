Return-Path: <io-uring+bounces-6631-lists+io-uring=lfdr.de@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [IPv6:2604:1380:4601:e00::3])
	by mail.lfdr.de (Postfix) with ESMTPS id 0CA6AA40480
	for <lists+io-uring@lfdr.de>; Sat, 22 Feb 2025 02:05:24 +0100 (CET)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id 4B08B19C724A
	for <lists+io-uring@lfdr.de>; Sat, 22 Feb 2025 01:05:30 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 4011015853B;
	Sat, 22 Feb 2025 01:05:20 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="fNUZRuTw"
X-Original-To: io-uring@vger.kernel.org
Received: from mail-wm1-f43.google.com (mail-wm1-f43.google.com [209.85.128.43])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 84FFF132103
	for <io-uring@vger.kernel.org>; Sat, 22 Feb 2025 01:05:18 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.128.43
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1740186320; cv=none; b=KFmfaXe+fqo9wqx0SEFH5naCTLG3RpH1i4Qe5m7fOoGASpMsYpIYJbDPl7PVihqs1NddW+SEuoythIQd1/9TRniUmvwVJSor4xjobIKF+aNxcoUSi56xotN8vadu4SnM7A/p64fOTvWEW6JObxan99hNXMCd/lRH5Xg0+b+UskA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1740186320; c=relaxed/simple;
	bh=CGpG/WiUVyeU9wzws+X+hjR7WuD95ih2ljcLrQxLSR0=;
	h=Message-ID:Date:MIME-Version:Subject:To:References:From:
	 In-Reply-To:Content-Type; b=rM9l2rHmDcMkXSxVt4CQ5FZTeoyncWewjO65PABS7IwSe12Bk077ABxmyi6cFJde1kNC8FGh51QYZRhmJ6BsUnhmqae95UrEKxaD1PS8WIFVpUNRAkWKCnCoSS8XGpx2CnKKorPwuSU72OWXclZ56XaaR8yXLtJcGukwo5IbpEQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=fNUZRuTw; arc=none smtp.client-ip=209.85.128.43
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Received: by mail-wm1-f43.google.com with SMTP id 5b1f17b1804b1-4398e839cd4so22338075e9.0
        for <io-uring@vger.kernel.org>; Fri, 21 Feb 2025 17:05:18 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1740186317; x=1740791117; darn=vger.kernel.org;
        h=content-transfer-encoding:in-reply-to:from:content-language
         :references:to:subject:user-agent:mime-version:date:message-id:from
         :to:cc:subject:date:message-id:reply-to;
        bh=xOEg5pQ4ZnATN+eksbipfMt9MNZsJiFCcJNfySyWnEU=;
        b=fNUZRuTwpyfSZdoHQZHWl4O2S3+iL83J/S92eXnBXqR9UFrxreNxu/eGpNtPnyF59r
         bGNZIclWVuUUsPaFQej+MeXq6CO67eCn/4jTYQSDgL2nsDUMkxapl62vZAKdS2/Ja/fL
         pxiQJo033qHtki6AAqk5kNFT0oPI0YrSWeKImOhs5U8N2k32kA2VpAIYhvcSf7m+jQ3n
         yHTWxpG7+lzbqmwwZ3R6XLGzBCE9euoNAvpNjSAiQA5wYzbEW7YVmIcVpdazPosB1oWH
         aWaStnnTX7TGWGEOq7tOSWM2xwq+5Ruq6VRpwxx1GZ7vpt3KZp7rqmqMpm+hdRE2IXzX
         pdJQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1740186317; x=1740791117;
        h=content-transfer-encoding:in-reply-to:from:content-language
         :references:to:subject:user-agent:mime-version:date:message-id
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=xOEg5pQ4ZnATN+eksbipfMt9MNZsJiFCcJNfySyWnEU=;
        b=f5Yw/7bRv3pUBiv6GqBa4zDI12Tlvc/wkuySkGpgAJ9EuOWcBrZEuaGOJFIxJrtST1
         lppcwfo+h6ZhHr7RCUqrvlLB8OAr+o3auATiPqTG6NQ/fppXUdHTBiYEnO3G2mk30KIX
         N2IC72naPvQq/lFQBB4cA9CkZgyzetUQDQBD+DrNjuxUvxoM+4t7PXuHMnvQnrHtpAZu
         BAMkc6BhzL9wrPnwDwjz8n5BRmawsKxUy3QN117MTgUlMHbJSGrZb9FA3eMZXvQ51cV9
         FDQOygajtmwVI+j9c/Vk+n6B6Qjw3bJYckgPS0ICwm6JHf0HBKQsS7rwxiYyI1AuSVFj
         Em0Q==
X-Forwarded-Encrypted: i=1; AJvYcCVOKwdnysf/qO+DH4X3CeyEml2Mt46v2w2cX4IdEz42cE6psyEv0Br4ceGHt5cldI3ZZGUv/szteg==@vger.kernel.org
X-Gm-Message-State: AOJu0YyciY1/Eo1TvmM1euIXyvbknBJeQbCx5RMSnqYmgo6b+OmwfddY
	J1H1nfjAu0+FYpHhlAwEpAugD3x2pWzDPSifBXop2PGAT5BCxc8T
X-Gm-Gg: ASbGnctqAIvIRgqKNHil9CN3MhWSIslyJk4rHyu17UjRwpFDQae/hi6ym5mHIVipzpW
	X6IS/rlBMapsJwFrqIM4b3GGwqNYrkZRTziaGPsIkj6lqBRxJ5pVb6Ok/+lwqet6iLnmmgTdk2S
	Yl+adKTUJtzYi8jO2aUKp0OntuUuIctppqFrfI94ws2Qp8i13Af/nNt8a+eg3rB7DQD7/tMPoRP
	SrAobb6IVRpSrMYEi0Arv4wIzRbkbgDEx4ZqtGoEtDqDDeBR7/m2YULlGBG4n53WNu7AELDtAyY
	52AcIkK0G2lxdEM65tIToa4FqFOSjJmeDP69
X-Google-Smtp-Source: AGHT+IFY+MLEHoEwqMe05ML3eWT7UHO4Q5Oh8l/MxUofj1ntH9EtK20C/RcrWod4nUgOqbPTR2ruMw==
X-Received: by 2002:adf:890a:0:b0:38f:232e:dd5e with SMTP id ffacd0b85a97d-38f616331ccmr6143419f8f.22.1740186316680;
        Fri, 21 Feb 2025 17:05:16 -0800 (PST)
Received: from [192.168.8.100] ([148.252.141.194])
        by smtp.gmail.com with ESMTPSA id ffacd0b85a97d-38f259d5c29sm24836323f8f.72.2025.02.21.17.05.13
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Fri, 21 Feb 2025 17:05:14 -0800 (PST)
Message-ID: <516fdf90-1f0a-4c2e-b7ed-23a72b7a4342@gmail.com>
Date: Sat, 22 Feb 2025 01:06:19 +0000
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
Content-Language: en-US
From: Pavel Begunkov <asml.silence@gmail.com>
In-Reply-To: <a44a6ed1-8a4c-4334-9785-aee8b545c68d@kernel.dk>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit

On 2/22/25 00:52, Jens Axboe wrote:
>>> @@ -1250,6 +1251,12 @@ int io_recvzc_prep(struct io_kiocb *req, const struct io_uring_sqe *sqe)
>>>        zc->ifq = req->ctx->ifq;
>>>        if (!zc->ifq)
>>>            return -EINVAL;
>>> +    zc->len = READ_ONCE(sqe->len);
>>> +    if (zc->len == UINT_MAX)
>>> +        return -EINVAL;
>>
>> The uapi gives u32, if we're using a special value it should
>> match the type. ~(u32)0
> 
> Any syscall in Linux is capped at 2G anyway, so I think all of this

I don't see how it related, you don't have to have a weird
00111111b as a special value.

> special meaning of ->len just needs to go away. Just ask for whatever
> bytes you want, but yes more than 2G will not be supported anyway.

That's not the case here, the request does support more than 2G,
it's just spread across multiple CQEs, and the limit accounts
for multiple CQEs.

-- 
Pavel Begunkov


