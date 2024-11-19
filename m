Return-Path: <io-uring+bounces-4805-lists+io-uring=lfdr.de@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [IPv6:2604:1380:45e3:2400::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 328469D1DBA
	for <lists+io-uring@lfdr.de>; Tue, 19 Nov 2024 02:59:50 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id EC66A2827F1
	for <lists+io-uring@lfdr.de>; Tue, 19 Nov 2024 01:59:48 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 73AE213211A;
	Tue, 19 Nov 2024 01:59:18 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel-dk.20230601.gappssmtp.com header.i=@kernel-dk.20230601.gappssmtp.com header.b="jFjVyyuj"
X-Original-To: io-uring@vger.kernel.org
Received: from mail-pf1-f169.google.com (mail-pf1-f169.google.com [209.85.210.169])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0EA72137745
	for <io-uring@vger.kernel.org>; Tue, 19 Nov 2024 01:59:13 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.210.169
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1731981558; cv=none; b=U126NRrKW8LcK8leKV9hNvb4LcafdqrH+7CcbtcTql1L8Oak3k2gm64RCQ3Ay/KJKCiBDy9ZQnpjhle5Y9uArYu9tl4pAPlCcAtUAnEI5jJqvbtdYLAO+6JW5UXCpmZlS6Cv3NVz97GaW/5u/T4riZrpju9g8ctAQsQ1s/SVSmU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1731981558; c=relaxed/simple;
	bh=ZfjlXjPwI9E2F3PcahXxbSADEwmj11F4UvKrPvQzKPs=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=XIIyqv5ZWg66qPSpOu+3nyv5Fp9O95gltYwZBWBS8eR1T69xjEFQGZz+JA+k/p9aymoZbC0EsrlNfce5BDnW+01pabEyUJRwCJegyQSMdqsOa9YHdb7+wWeydIa07fbSX3idjNfurBD7n6iSN2z/upH8GNXfPbjexOl3kW2O8Sk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=kernel.dk; spf=pass smtp.mailfrom=kernel.dk; dkim=pass (2048-bit key) header.d=kernel-dk.20230601.gappssmtp.com header.i=@kernel-dk.20230601.gappssmtp.com header.b=jFjVyyuj; arc=none smtp.client-ip=209.85.210.169
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=kernel.dk
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=kernel.dk
Received: by mail-pf1-f169.google.com with SMTP id d2e1a72fcca58-7240d93fffdso3058326b3a.2
        for <io-uring@vger.kernel.org>; Mon, 18 Nov 2024 17:59:13 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernel-dk.20230601.gappssmtp.com; s=20230601; t=1731981553; x=1732586353; darn=vger.kernel.org;
        h=content-transfer-encoding:in-reply-to:from:content-language
         :references:cc:to:subject:user-agent:mime-version:date:message-id
         :from:to:cc:subject:date:message-id:reply-to;
        bh=HJqdU9lCfeBWxQySZ5P5WBVC+iT4zBQwxuILvtFzzAk=;
        b=jFjVyyujlSUl1LIX/1CfhdVt3B2Ix421LC2Uuwk0Yvp/BA0rFp+OCIKtOypqHekhmQ
         Nf24Xt+tMszWiQZy4UaQpGdQDCHoGdXgvQ9Aw9WtC8vga7VXJ2xpc+AwuqOEJxobOvQS
         wv8bFE06VZVW5zgZMoUaig8llQacv3wAztTLC0Ak+Ghfko1b0NTNZJwv1VSABHjnLtpM
         1nWgV7dLig4DjFJgMAdJF80CXjDcySv9BVQnZv8ZJQCIz1Y+x+87CMfDUPwy12aJmFYX
         RkFk9+T/kf/IEij7PeEk0XVuQFbLB73ovr41ssw3NV3tOvloH9sLCZ/UQW/WmCHxnsaP
         TT5Q==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1731981553; x=1732586353;
        h=content-transfer-encoding:in-reply-to:from:content-language
         :references:cc:to:subject:user-agent:mime-version:date:message-id
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=HJqdU9lCfeBWxQySZ5P5WBVC+iT4zBQwxuILvtFzzAk=;
        b=S8dNnwpw8uIam2PObB4ok8CInBt6F/x85v5cu2ruIqPw2e8XjOJa7mMntjuOBVkgYw
         9v+KXWYLxU/p2UfOap2PxOFlMKTIQH4ETJQBnOegpJFf2I/HVfG4xpX7Q3DyyDflCV29
         +IP8TJUiLDMjs7pbEx1Inl4AF8jo+WYbHqPsJVq7gGbF/8aWK+DUqImZf1SK+XfFAWuM
         WWhyy30gAmVGDYqrbnTPxcZ0y9ww1ywJDS9kX6KU/3EsJ2XSPmAOgaoDB8dKwPsbANoT
         XAxesYgsmtse8tFZ70SuAUX9lZrRntHywzB/CyHdchTkt6NDI6cHBOODxKnL9bUORVNZ
         CVZg==
X-Forwarded-Encrypted: i=1; AJvYcCUXlsejQPINM/CH6mcBJMzcfC9Zfgp45HjZ9orKIbMnLSKto5Jtk8ZcSxwxNjWHWzjZGVcVOv/JPA==@vger.kernel.org
X-Gm-Message-State: AOJu0Yy2WrhMXEU1MDtB4hbB7nAzSsy7px3B4adJpMO7EnPt0D4l4nxd
	wpdyOyYlyLJbyMKfdBC20caAP5CJbvq3IEpInikZNK0NBjOBb0ihWj4oUjr+roo=
X-Google-Smtp-Source: AGHT+IHd8K7uGTXOyJQvw9Z/DCg/GOf+FEE9Bck5wSRQcvn4fkG2viVrnOGFZhYkrLI7Dontc+OVXA==
X-Received: by 2002:a05:6a20:2d22:b0:1db:e329:83f5 with SMTP id adf61e73a8af0-1dc90b23e29mr23475637637.14.1731981553354;
        Mon, 18 Nov 2024 17:59:13 -0800 (PST)
Received: from [192.168.1.150] ([198.8.77.157])
        by smtp.gmail.com with ESMTPSA id 98e67ed59e1d1-2ea5832e629sm3456224a91.23.2024.11.18.17.59.12
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Mon, 18 Nov 2024 17:59:12 -0800 (PST)
Message-ID: <278a1964-b795-4146-8f24-19f112af75b0@kernel.dk>
Date: Mon, 18 Nov 2024 18:59:11 -0700
Precedence: bulk
X-Mailing-List: io-uring@vger.kernel.org
List-Id: <io-uring.vger.kernel.org>
List-Subscribe: <mailto:io-uring+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:io-uring+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH 1/1] io_uring: prevent reg-wait speculations
To: Pavel Begunkov <asml.silence@gmail.com>, io-uring@vger.kernel.org
Cc: jannh@google.com
References: <fd36cd900023955c763bd424c0895ae5828f68a0.1731979403.git.asml.silence@gmail.com>
 <0dfd1032-6ddd-49b3-a422-569af2307d3b@kernel.dk>
 <d5e9c79f-d571-4f3a-9145-f7e349e532ae@gmail.com>
Content-Language: en-US
From: Jens Axboe <axboe@kernel.dk>
In-Reply-To: <d5e9c79f-d571-4f3a-9145-f7e349e532ae@gmail.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit

On 11/18/24 6:43 PM, Pavel Begunkov wrote:
> On 11/19/24 01:29, Jens Axboe wrote:
>> On 11/18/24 6:29 PM, Pavel Begunkov wrote:
>>> With *ENTER_EXT_ARG_REG instead of passing a user pointer with arguments
>>> for the waiting loop the user can specify an offset into a pre-mapped
>>> region of memory, in which case the
>>> [offset, offset + sizeof(io_uring_reg_wait)) will be intepreted as the
>>> argument.
>>>
>>> As we address a kernel array using a user given index, it'd be a subject
>>> to speculation type of exploits.
>>>
>>> Fixes: d617b3147d54c ("io_uring: restore back registered wait arguments")
>>> Fixes: aa00f67adc2c0 ("io_uring: add support for fixed wait regions")
>>> Signed-off-by: Pavel Begunkov <asml.silence@gmail.com>
>>> ---
>>>   io_uring/io_uring.c | 1 +
>>>   1 file changed, 1 insertion(+)
>>>
>>> diff --git a/io_uring/io_uring.c b/io_uring/io_uring.c
>>> index da8fd460977b..3a3e4fca1545 100644
>>> --- a/io_uring/io_uring.c
>>> +++ b/io_uring/io_uring.c
>>> @@ -3207,6 +3207,7 @@ static struct io_uring_reg_wait *io_get_ext_arg_reg(struct io_ring_ctx *ctx,
>>>                end > ctx->cq_wait_size))
>>>           return ERR_PTR(-EFAULT);
>>>   +    barrier_nospec();
>>>       return ctx->cq_wait_arg + offset;
>>
>> We need something better than that, barrier_nospec() is a big slow
>> hammer...
> 
> Right, more of a discussion opener. I wonder if Jann can help here
> (see the other reply). I don't like back and forth like that, but if
> nothing works there is an option of returning back to reg-wait array
> indexes. Trivial to change, but then we're committing to not expanding
> the structure or complicating things if we do.

Then I think it should've been marked as a discussion point, because we
definitely can't do this. Soliciting input is perfectly fine. And yeah,
was thinking the same thing, if this is an issue then we just go back to
indexing again. At least both the problem and solution is well known
there. The original aa00f67adc2c0 just needed an array_index_nospec()
and it would've been fine.

Not a huge deal in terms of timing, either way.

I suspect we can do something similar here, with just clamping the
indexing offset. But let's hear what Jann thinks.

-- 
Jens Axboe

