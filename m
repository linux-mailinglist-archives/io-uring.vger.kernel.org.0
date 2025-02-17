Return-Path: <io-uring+bounces-6491-lists+io-uring=lfdr.de@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [IPv6:2604:1380:45e3:2400::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 34C0EA38798
	for <lists+io-uring@lfdr.de>; Mon, 17 Feb 2025 16:34:33 +0100 (CET)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 4D6753A6722
	for <lists+io-uring@lfdr.de>; Mon, 17 Feb 2025 15:32:57 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 7F98821CA1B;
	Mon, 17 Feb 2025 15:33:03 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="BnVqfofb"
X-Original-To: io-uring@vger.kernel.org
Received: from mail-wm1-f42.google.com (mail-wm1-f42.google.com [209.85.128.42])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C233121A421
	for <io-uring@vger.kernel.org>; Mon, 17 Feb 2025 15:33:01 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.128.42
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1739806383; cv=none; b=k5Iv/2ixJ3Qgi5ROar43Lt8tk+JJ/hfai0HqwBZfkjf6ZCAyqQGarAY3x22Emu2SoOQYZQ8buzKqTC4xKlLBrlhWDkED/SpmVCYQFQWreA25ihj6Pk7+i10gJ3w1zkBisCJB+tKbGNaL3LGVNi/4AZO4EeLlPHdpOHeChWUutDw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1739806383; c=relaxed/simple;
	bh=wHyG9MdBMe29hbc5X+5jKSOUp9sy3wEpyT4dMnuMmvw=;
	h=Message-ID:Date:MIME-Version:Subject:To:References:From:
	 In-Reply-To:Content-Type; b=qttx/Cg1qoe2It+cKfx24nhQ7rpr5qXawIhZOAFwQWOtW3d8/Eg6eUWlw4lvc1SGq5iNdjtB17T2te+t5F5oS6ahZ7Y2ghFpGX+6dL0c+ByuS+1t5zSnz56f4rDic59SnQ7sCiFX2oNGY315uMazJl6FJ6dTHvAhlr8YHw/iM68=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=BnVqfofb; arc=none smtp.client-ip=209.85.128.42
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Received: by mail-wm1-f42.google.com with SMTP id 5b1f17b1804b1-439350f1a0bso26900215e9.0
        for <io-uring@vger.kernel.org>; Mon, 17 Feb 2025 07:33:01 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1739806380; x=1740411180; darn=vger.kernel.org;
        h=content-transfer-encoding:in-reply-to:from:content-language
         :references:to:subject:user-agent:mime-version:date:message-id:from
         :to:cc:subject:date:message-id:reply-to;
        bh=1MSRWyUsOdZ3Ul/kMKg3bQl3/44UxIW6PGc42zRgKeI=;
        b=BnVqfofbVnpqKPzv4pauzEu6rFh3kFKsnO6Ey8oAvZtPaPS4E5x2pBgSmJug/d7oCt
         YV3M3EaUfyA5zKPT55VAj1ob16RoxPtWCe05AU9RCAsHtzNR1S/qXdI9Xxoc2AQYOwDY
         J0FDR2zWKvjwPQ9ZvIsEhewplvH5LUiNCcCXeYRnE+CZEuM565xXgIZV6npbTP2KIBU+
         9f9qvyvA6vHIP/KQQYJ9oGP2adOoJb8Hm68RT5lQT3H8fI+6+x9aummqnhmD7HuEoz8Z
         LRks8EIN4ThYvplWPgGqaj4gQPuJa7sx6wSiOt39udnYWH4/H+M0EterlRxugLTbXLVR
         oy5g==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1739806380; x=1740411180;
        h=content-transfer-encoding:in-reply-to:from:content-language
         :references:to:subject:user-agent:mime-version:date:message-id
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=1MSRWyUsOdZ3Ul/kMKg3bQl3/44UxIW6PGc42zRgKeI=;
        b=eYAoJSKckVXi0tBH9le16uc1JmnUiQT3ZiD61t16YqdqqwDipAjQcucOqgXYEhZ5dV
         gaAi/DLmT1OcQZZ0RKY8Ql/k0AMUQv3aUSuuK6GiDfOHd+cA5DYoEovqFqArCXbboysc
         O9nULP/XJTe9TRX2nbk884s007gxkuk13Gw+w0q94O9cVYnNX0/AmvI7a5+uxw9xacl8
         zRKfau0S0T10yZmNM6rTfE+rUgNU5dWq3r2CFSIx/c+1mLx050oafMshwGlzVKcLrxeX
         aa8AF+kUZ+B2/KUZShb0sLIpsD3rcJnXslLe3NSiibOggJcgxrLpci4JsX2u47j7ER6o
         9mLw==
X-Forwarded-Encrypted: i=1; AJvYcCXHpTLq7i/oGP1uTg/urxgrBdSz9hi2anzm5D6HqM1iGTyUKxdmrJL1v3B1O44kr8acFjdN6VFM5Q==@vger.kernel.org
X-Gm-Message-State: AOJu0Yy9N/npZLbtOC4vg/RKX8Hc4Olb1H4MRnoQdOCOiLjlfw8GIBgM
	CZ6WEk5siA3Ax0SWEXqIhYYfpoLtKiNOFxgDDmqNLL3+f/1J/GX0cVnCDg==
X-Gm-Gg: ASbGncuORbuJDYtzGFyvnddsTBMAxKPH+P3IrxWCC3tXspeSWxF0PSns1/k4k3RGIPU
	9gp+mj8PyKdPZxrrp9Gvfb1GDxUI5jNQqlUQchhq/CpwaUAJmtyMsSdgPDOk5yrLaGO0mfIr7Nm
	axsi/0U1kfZeMnl5jyyPKDwwAEWKTT6FzHefo0Erj3iiZ26qkBkFzgsOR0VJZ4gPrWIqpu8G5M0
	AW4nFYVgLZZM6bl1POiuj1t6MU6e6kIPak7ucE25JD5rmKM3tmEBzlkedc7PMPYnxnKfmu8NQ38
	KPWaMm93Vnymk1a0qL8O8H/T
X-Google-Smtp-Source: AGHT+IGd7tJmRRFgLL+PsBxqrD4cq0djTXFdJcgiXnm/3UB8XF9u1i11XKqUXFO8PhhcJaFf4+X8AQ==
X-Received: by 2002:a05:600c:46ce:b0:439:5fbd:19d2 with SMTP id 5b1f17b1804b1-4396ec7c92amr88023565e9.10.1739806379633;
        Mon, 17 Feb 2025 07:32:59 -0800 (PST)
Received: from [192.168.8.100] ([185.69.145.170])
        by smtp.gmail.com with ESMTPSA id 5b1f17b1804b1-4395a1b8397sm155558075e9.36.2025.02.17.07.32.58
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Mon, 17 Feb 2025 07:32:59 -0800 (PST)
Message-ID: <5d50f5bf-1f2a-4b01-9749-d65b52d77e76@gmail.com>
Date: Mon, 17 Feb 2025 15:33:54 +0000
Precedence: bulk
X-Mailing-List: io-uring@vger.kernel.org
List-Id: <io-uring.vger.kernel.org>
List-Subscribe: <mailto:io-uring+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:io-uring+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH 1/1] io_uring/rw: forbid multishot async reads
To: Jens Axboe <axboe@kernel.dk>, io-uring@vger.kernel.org
References: <49f065f7b88b7a67190ce65919e7c93c04b3a74b.1739799395.git.asml.silence@gmail.com>
 <cd42f912-df8a-4c9d-a891-1c127f6b6fa0@kernel.dk>
 <b89b5ef0-9db9-44e6-9ae3-aabf39a70759@gmail.com>
 <b4c65139-b1e4-4a00-a70b-f1e1c3661d83@kernel.dk>
Content-Language: en-US
From: Pavel Begunkov <asml.silence@gmail.com>
In-Reply-To: <b4c65139-b1e4-4a00-a70b-f1e1c3661d83@kernel.dk>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit

On 2/17/25 15:06, Jens Axboe wrote:
> On 2/17/25 7:12 AM, Pavel Begunkov wrote:
>> On 2/17/25 13:58, Jens Axboe wrote:
>>> On 2/17/25 6:37 AM, Pavel Begunkov wrote:
>>>> At the moment we can't sanely handle queuing an async request from a
>>>> multishot context, so disable them. It shouldn't matter as pollable
>>>> files / socekts don't normally do async.
>>>
>>> Having something pollable that can return -EIOCBQUEUED is odd, but
>>> that's just a side comment.
>>>
>>>
>>>> diff --git a/io_uring/rw.c b/io_uring/rw.c
>>>> index 96b42c331267..4bda46c5eb20 100644
>>>> --- a/io_uring/rw.c
>>>> +++ b/io_uring/rw.c
>>>> @@ -878,7 +878,15 @@ static int __io_read(struct io_kiocb *req, unsigned int issue_flags)
>>>>        if (unlikely(ret))
>>>>            return ret;
>>>>    -    ret = io_iter_do_read(rw, &io->iter);
>>>> +    if (unlikely(req->opcode == IORING_OP_READ_MULTISHOT)) {
>>>> +        void *cb_copy = rw->kiocb.ki_complete;
>>>> +
>>>> +        rw->kiocb.ki_complete = NULL;
>>>> +        ret = io_iter_do_read(rw, &io->iter);
>>>> +        rw->kiocb.ki_complete = cb_copy;
>>>> +    } else {
>>>> +        ret = io_iter_do_read(rw, &io->iter);
>>>> +    }
>>>
>>> This looks a bit odd. Why can't io_read_mshot() just clear
>>> ->ki_complete?
>>
>> Forgot about that one, as for restoring it back, io_uring compares
>> or calls ->ki_complete in a couple of places, this way the patch
>> is more contained. It can definitely be refactored on top.
> 
> I'd be tempted to do that for the fix too, the patch as-is is a
> bit of an eye sore... Hmm.

It is an eyesore, sure, but I think a simple/concise eyesore is
better as a fix than having to change a couple more blocks across
rw.c. It probably wouldn't be too many changes, but I can't say
I'm concerned about this version too much as long as it can be
reshuffled later.

-- 
Pavel Begunkov


