Return-Path: <io-uring+bounces-7659-lists+io-uring=lfdr.de@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [139.178.88.99])
	by mail.lfdr.de (Postfix) with ESMTPS id 5DC82A9874D
	for <lists+io-uring@lfdr.de>; Wed, 23 Apr 2025 12:29:21 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 13CF93BFC18
	for <lists+io-uring@lfdr.de>; Wed, 23 Apr 2025 10:29:04 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 9AD1922E403;
	Wed, 23 Apr 2025 10:29:16 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="ADdz3F6z"
X-Original-To: io-uring@vger.kernel.org
Received: from mail-ej1-f47.google.com (mail-ej1-f47.google.com [209.85.218.47])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D6EA01F2C45
	for <io-uring@vger.kernel.org>; Wed, 23 Apr 2025 10:29:14 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.218.47
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1745404156; cv=none; b=oUrWK5c1bRNrEyykWr/kZJFg0HrF0IQenY+FnXYhfeumYlQrEzyG0XR6zG5+qcE02KeK3gNPN5tKx78FUlJpFAhG+Ict9k8bB/OXvIotUyzIhkwEfri+TjHGonnR7Ms3qEtm9kZS+hcGqV24XRaMC5DRuXbVigNq9NPIXEIyfSc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1745404156; c=relaxed/simple;
	bh=V+DRs2HFMrE0Cyiji6SuFwxw7MzfOwoTc8DyvKN0ynA=;
	h=Message-ID:Date:MIME-Version:Subject:From:To:Cc:References:
	 In-Reply-To:Content-Type; b=nb2r+21IsLJ+YYWHfy5H8PBl9u1mrMCoGgcQptggRW3ittfGOoTY8pX0Ly6sCK5wyWKMgWLzHNPDhpGCav00aRmACN0COSc+D2zJHqgqbxDQoeviNBzLBPwvh+rlpYBvjUTjGF8/t6ogZe6Vyi2yZW7+GK1Mnzmnj+7wzNCgGK8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=ADdz3F6z; arc=none smtp.client-ip=209.85.218.47
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Received: by mail-ej1-f47.google.com with SMTP id a640c23a62f3a-ac29fd22163so916076266b.3
        for <io-uring@vger.kernel.org>; Wed, 23 Apr 2025 03:29:14 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1745404153; x=1746008953; darn=vger.kernel.org;
        h=content-transfer-encoding:in-reply-to:content-language:references
         :cc:to:from:subject:user-agent:mime-version:date:message-id:from:to
         :cc:subject:date:message-id:reply-to;
        bh=qpAhdH0ufWdadVxNDJgEm5TJ7kqnu1kQn4NqmWnMpdw=;
        b=ADdz3F6z7AVJ3JbAwNy1LtWrVomSPjxber6meCoxsmAP/AdHvaYIBeereJ96qyjtWG
         fwDTH8yjimytbsmq2jK9BOgZN3nKFCsAhdMNnWHb/QvPEQHHfbqXmFePD45HXFeaLFVE
         /gzJyVaPxwYhQcNcMTU5aJYb6N5bKbeoSHKuCKIqglOnOx1cfV6s0VrEML+NCgOrIp+H
         Jy9FnaWrGrASYxOAdaKu3tPnxAbYsRwzTQQM8T2jshswWbMggJwT744TDxHGd96VvT4L
         gLT7zuP7iElhS7qTsA9pl8n8IeaHsvXeVm7PzsARQFlc+W0B3kGBtllyA65deO8HEWg9
         ELXA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1745404153; x=1746008953;
        h=content-transfer-encoding:in-reply-to:content-language:references
         :cc:to:from:subject:user-agent:mime-version:date:message-id
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=qpAhdH0ufWdadVxNDJgEm5TJ7kqnu1kQn4NqmWnMpdw=;
        b=P11gGWYtwnX484D8vyGeqK3ryK90O7rs/Wk5yZTiyyV9nA0DNJMDYnLdJIA36iiQAu
         znDecpnCcYdVSD85/Gsbrn22bwz2iLdbuUhCAJxRLOWrlQuhqGfdeCcb0/9+d8Rz/JNf
         9drKsfR0JpuUWax6swN0fF1Mm71rkZaXJhKX/Flk8ketxU987JtpQgpdwaCli2zKfg2T
         KHQQRhtrhiCwOtgJjjpGXF6/CEbb2r9vBHkesVtyXQhxlF6+G1Owz79CTEyjglnLkZcu
         gPSA9dWLaQ7oNGtzElLkhgnNDsaDbM8uHz9A9QZ5S730tPAvfUYx5rLPZhPlRZju7pM1
         2zYA==
X-Gm-Message-State: AOJu0Yxs15dsRHxBPDPi2BHQLuBjQRWN7SF5T5RIDNCPT2/7I4KNM3H/
	Kpo2fw3iyFMMWaeYrTCsPlK+lRDCFj4rtm1//+lQO86GoOjNRCBELpKMHg==
X-Gm-Gg: ASbGncsIz4H4/5VZ0fL2RKMr7JjQhJ6l8Anjuhc8fgxz7llvUNVWzYgbOyxYRFJn/yt
	PNxN2LdYuJcE1Eai2Wm7WLYpj269AZkKmXONupoq54x3yQSTU8u9+k1MUrFQVGDciXMLLmsNOq2
	2nlQ+hDpvsOuB09zX69aZZ6V57GrGwPkPceCxjEULLAqj7vTr2w6cQUIjGdeqf62GikrURZ1Aud
	5SqNSRxjn4pcegEJNuyrmLmIBIBpR8xZSWJhxnBGV8BHVtuAWB/YCc/wYHJIswuR3ed9Tay4WKg
	2f37hCimdJDxg2FihD9nkFU3A16Ev+VBNbwm8LgSS/CijEpgyDg=
X-Google-Smtp-Source: AGHT+IEyVbHMLJCxTXJ1HkUdIJfpcA/cNHMOPOBpSLH7p5l8IvF+qa90gIP9yMHtZxvu+xk5TW2nig==
X-Received: by 2002:a17:907:3d8f:b0:acb:3a0d:8a82 with SMTP id a640c23a62f3a-acb74b8cc83mr1667458466b.32.1745404152698;
        Wed, 23 Apr 2025 03:29:12 -0700 (PDT)
Received: from [192.168.8.100] ([148.252.144.224])
        by smtp.gmail.com with ESMTPSA id a640c23a62f3a-acb6eefcfa2sm797319866b.92.2025.04.23.03.29.11
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Wed, 23 Apr 2025 03:29:11 -0700 (PDT)
Message-ID: <83595e5a-ae53-4ca8-86a9-5909833b77bd@gmail.com>
Date: Wed, 23 Apr 2025 11:30:26 +0100
Precedence: bulk
X-Mailing-List: io-uring@vger.kernel.org
List-Id: <io-uring.vger.kernel.org>
List-Subscribe: <mailto:io-uring+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:io-uring+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [bug report] io_uring/zcrx: add support for multiple ifqs
From: Pavel Begunkov <asml.silence@gmail.com>
To: Dan Carpenter <dan.carpenter@linaro.org>
Cc: io-uring@vger.kernel.org
References: <aAiTlrx6uXuyoCkf@stanley.mountain>
 <6047214a-794f-400b-993c-5b5ef9e6daf6@gmail.com>
Content-Language: en-US
In-Reply-To: <6047214a-794f-400b-993c-5b5ef9e6daf6@gmail.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit

On 4/23/25 11:04, Pavel Begunkov wrote:
> On 4/23/25 08:15, Dan Carpenter wrote:
>> Hello Pavel Begunkov,
>>
>> Commit 9c2a1c508442 ("io_uring/zcrx: add support for multiple ifqs")
>> from Apr 20, 2025 (linux-next), leads to the following Smatch static
>> checker warning:
>>
>>     io_uring/zcrx.c:457 io_register_zcrx_ifq()
>>     error: uninitialized symbol 'id'.
>>
>> io_uring/zcrx.c
> ...
>>      396         ifq = io_zcrx_ifq_alloc(ctx);
>>      397         if (!ifq)
>>      398                 return -ENOMEM;
>>      399
>>      400         scoped_guard(mutex, &ctx->mmap_lock) {
>>      401                 /* preallocate id */
>>      402                 ret = xa_alloc(&ctx->zcrx_ctxs, &id, NULL, xa_limit_31b, GFP_KERNEL);
>>      403                 if (ret)
>>      404                         goto err;
>>
>> Potentially uninitialized on this path.  Presumably we don't need to
>> erase id if alloc fails.
> 
> Thanks for letting know

Jens, do you want a separate patch or to fix it up as it's the top
patch? This should do

diff --git a/io_uring/zcrx.c b/io_uring/zcrx.c
index 39744302fad1..ac2a05364b24 100644
--- a/io_uring/zcrx.c
+++ b/io_uring/zcrx.c
@@ -450,7 +450,7 @@ int io_register_zcrx_ifq(struct io_ring_ctx *ctx,
  		/* preallocate id */
  		ret = xa_alloc(&ctx->zcrx_ctxs, &id, NULL, xa_limit_31b, GFP_KERNEL);
  		if (ret)
-			goto err;
+			goto ifq_free;
  	}
  
  	ret = io_allocate_rbuf_ring(ifq, &reg, &rd, id);
@@ -506,6 +506,7 @@ int io_register_zcrx_ifq(struct io_ring_ctx *ctx,
  err:
  	scoped_guard(mutex, &ctx->mmap_lock)
  		xa_erase(&ctx->zcrx_ctxs, id);
+ifq_free:
  	io_zcrx_ifq_free(ifq);
  	return ret;
  }

-- 
Pavel Begunkov


