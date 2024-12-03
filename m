Return-Path: <io-uring+bounces-5194-lists+io-uring=lfdr.de@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from sy.mirrors.kernel.org (sy.mirrors.kernel.org [147.75.48.161])
	by mail.lfdr.de (Postfix) with ESMTPS id 5230C9E2246
	for <lists+io-uring@lfdr.de>; Tue,  3 Dec 2024 16:22:37 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sy.mirrors.kernel.org (Postfix) with ESMTPS id 8E90BB26A9F
	for <lists+io-uring@lfdr.de>; Tue,  3 Dec 2024 14:43:24 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 93BD21F471F;
	Tue,  3 Dec 2024 14:43:21 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="l/AJFSeA"
X-Original-To: io-uring@vger.kernel.org
Received: from mail-ed1-f43.google.com (mail-ed1-f43.google.com [209.85.208.43])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id CA34A1E4A9
	for <io-uring@vger.kernel.org>; Tue,  3 Dec 2024 14:43:19 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.208.43
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1733237001; cv=none; b=iNc9P3ku15zy6qjIQQaFIPIs/k4k3EdjuYW8OiHT+iJamgo3VLxpg7ULDYekNDqt6ihCU24aJnMwiKNLUIexvMA2nhBGaHCT6H/2eir0VOhSuvSHvYcJTQRwmCRWIhuB/Hzdz/VI46GnUrKx83KNlww68qhAPB63N7fEfCvXLcc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1733237001; c=relaxed/simple;
	bh=76atnDeUNqy++gJuSpTN/SkFMH+SqdqtSVUZMFAoJOs=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=W7OfX6Mq5yxEYiN0P3Jp25X+1MO7b7n1RlSw54+hxG5qtvdfCJN8ixy5Yw/29gfrFUL8HcyH+AFZ3YJ9OnjgO1/lBVxGTV6Zqewt+OhOQ2ONjonmWxIC2hsbnd5XQEQ/Byq9RPhHeu5Vw7xf75ypzGH5nNZW/9zDcPsb9tOE//s=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=l/AJFSeA; arc=none smtp.client-ip=209.85.208.43
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Received: by mail-ed1-f43.google.com with SMTP id 4fb4d7f45d1cf-5d11413b633so48051a12.2
        for <io-uring@vger.kernel.org>; Tue, 03 Dec 2024 06:43:19 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1733236998; x=1733841798; darn=vger.kernel.org;
        h=content-transfer-encoding:in-reply-to:from:content-language
         :references:cc:to:subject:user-agent:mime-version:date:message-id
         :from:to:cc:subject:date:message-id:reply-to;
        bh=02rdfyehlfHsjfiGXQH3qDULABvXUVgEpBCVoRzb/RY=;
        b=l/AJFSeAystkR1VjcBFWkPq7pjgSjP/XTY04if3/0Bq8kH9EPxGamirQrxuoqxz7NU
         wdFp7d89ahR9eCbR5QCOSx8PziE7UhdYl0izAyG3hIPjX3HjiylzuGvbKQLPBLt96JDC
         Qp1vHJiLaq6BSnCNUWuhp3JHPacsaHTSWD9E9qbagsio+tNj33SUCMhGxNNJwPMSlqdC
         scBcjfznkFmdtqQP5B3PozuCKxl54TFIJPN0o9Kdsc0E5hhaRthw8K/rUHk9IQWw1GFl
         BZFLsl/ke0UHRKcBsHczvWLs0fdq7QW1+8zGBC0QIWowZwdYU+a4OwQiVsEBAI9d6tK5
         K9LA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1733236998; x=1733841798;
        h=content-transfer-encoding:in-reply-to:from:content-language
         :references:cc:to:subject:user-agent:mime-version:date:message-id
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=02rdfyehlfHsjfiGXQH3qDULABvXUVgEpBCVoRzb/RY=;
        b=tR9gBFEqavmQ+5fPEQyJSzpU02FosCUzANI/ruRJ4Fo4Y+zUeaewr9zzCQsKgzTv4j
         va9hm/Ri1wU7epPtVzzStYZTD4WqAd835Xc+dOF5A3ahpx9WDXwfQcHn+NquCzNZ993s
         aZxCOJ/czNiR+skevDzgK05jZBI2NfuHOIUUw23TTpz0ejpsMi5YbBP3XIJrofRt1YTA
         BIra28Ug4293sUnSxSYots6tL0eKmAKKVx3gMlHFJgaGIycMpZbVI3sGyVnA21n5U1pc
         /m17y92l5Q9wMhoqQT7P20ScIQm3JKzjsmldeTNWopSSz/kDPbnO4X51V708TsbrZlhn
         9aiQ==
X-Gm-Message-State: AOJu0Yxh2WNZwpiIE9GVwPPu7wBIbk0PBk3K5RYA3xj4Ir1ZTfyE6E1j
	09uxrMzAkQkbzhWZAtMTvIlEzhmh9k0kupQNpef26vMKnOhZidf7hFp7mA==
X-Gm-Gg: ASbGncvMO7yzDMcYssxjeyepzj7ja42Qk+Bp7UbjLJn4ybGjFmlUJTIaDevgsVPAHa2
	Y1sc0ziUPda03NjkMh6uhHYr1IaJlpYi4ANbL/9NgxgzXZlNa+4POidZHJoAwsKZTG3tQ2m23td
	AdG7Hgekafixp/Lz7y0TPcKHtYkjzCuVp+YxF6JhiV1l0X2YNHnFA/W2vKsttJUoSAcv8mqNMtd
	tFAqr+nmAsmVw1xbYQl4v7+FVuqICSnRO31HpI9iYiFMldkq93Bx4aHX5wypg==
X-Google-Smtp-Source: AGHT+IG1moFTgbP3qTw0wE2wFzCrtF7JLqxKJfbN/8lGjQgf9SPa8p+aj7/6IY6qP2GAQsVY8rG50Q==
X-Received: by 2002:a05:6402:2686:b0:5d0:e9d5:e030 with SMTP id 4fb4d7f45d1cf-5d10cb98997mr2253189a12.29.1733236997908;
        Tue, 03 Dec 2024 06:43:17 -0800 (PST)
Received: from [192.168.42.182] ([163.114.131.193])
        by smtp.gmail.com with ESMTPSA id a640c23a62f3a-aa5996c19b5sm619503966b.5.2024.12.03.06.43.17
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Tue, 03 Dec 2024 06:43:17 -0800 (PST)
Message-ID: <283d7be4-27d2-4123-96be-34c9c77c1371@gmail.com>
Date: Tue, 3 Dec 2024 14:44:13 +0000
Precedence: bulk
X-Mailing-List: io-uring@vger.kernel.org
List-Id: <io-uring.vger.kernel.org>
List-Subscribe: <mailto:io-uring+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:io-uring+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH -next] io_uring: add support for fchmod
To: lizetao <lizetao1@huawei.com>, Jens Axboe <axboe@kernel.dk>
Cc: "io-uring@vger.kernel.org" <io-uring@vger.kernel.org>
References: <ad222c8b35e54627b0244d5ee4d54f0c@huawei.com>
Content-Language: en-US
From: Pavel Begunkov <asml.silence@gmail.com>
In-Reply-To: <ad222c8b35e54627b0244d5ee4d54f0c@huawei.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit

On 11/26/24 15:07, lizetao wrote:
>>>>> On 11/19/24 1:12 AM, lizetao wrote:
>>>>> Adds support for doing chmod through io_uring. IORING_OP_FCHMOD
>>>>> behaves like fchmod(2) and takes the same arguments.
>>>
>>>> Looks pretty straight forward. The only downside is the forced use of REQ_F_FORCE_ASYNC - did you look into how feasible it would be to allow non-blocking issue of this? Would imagine the majority of fchmod calls end up not blocking in the first place.
>>>
>>> Yes, I considered fchmod to allow asynchronous execution and wrote a test case to test it, the results are as follows:
>>>

FYI, this email got into spam.

>>> fchmod:
>>> real	0m1.413s
>>> user	0m0.253s
>>> sys	0m1.079s
>>>
>>> io_uring + fchmod:
>>> real	0m1.268s
>>> user	0m0.015s
>>> sys	0m5.739s
>>>
>>> There is about a 10% improvement.
> 
>> And that makes sense if you're keeping some fchmod inflight, as you'd generally just have one io-wq processing them and running things in parallel with submission. But what you you keep an indepth count of 1, eg do sync fchmod? Then it'd be considerably slower than the syscall.
> Indeed, When performing REQ_F_FORCE_ASYNC operations at depth 1, performance is degraded. The results are as follows:
> 
> fchmod:
> real	0m2.285s
> user	0m0.050s
> sys	0m1.996s
> 
> io_uring + fchmod:
> real	0m2.541s
> user	0m0.013s
> sys	0m2.379s
> 
>> This isn't necessarily something to worry about, but fact is that if you can do a nonblock issue and have it succeed most of the time, that'll be more efficient (and faster for low/sync fchmod) than something that just offloads to io-wq. You can see that from your results too, comparing the sys number netween the two.
> However, when I remove REQ_F_FORCE_ASYNC and use IO_URING_F_NONBLOCK, the performance is not improved. The measured results are as follows:
> fchmod:
> real	0m2.132s
> user	0m0.048s
> sys	0m1.845s
> 
> io_uring + fchmod:
> real	0m2.196s
> user	0m0.005s
> sys	0m2.097s
> 
>> Hence why I'm asking if you looked into doing a nonblocking issue at all. This won't necessarily gate the inclusion of the patch, and it is something that can be changed down the line, I'm mostly just curious.
> Does this result meet expectations? Or maybe I missed something, please let me know

-- 
Pavel Begunkov


