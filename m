Return-Path: <io-uring+bounces-6897-lists+io-uring=lfdr.de@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [147.75.199.223])
	by mail.lfdr.de (Postfix) with ESMTPS id 0C50CA4A824
	for <lists+io-uring@lfdr.de>; Sat,  1 Mar 2025 03:36:00 +0100 (CET)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id 1FBE416A439
	for <lists+io-uring@lfdr.de>; Sat,  1 Mar 2025 02:35:59 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id A53CE8615A;
	Sat,  1 Mar 2025 02:35:58 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="iCaPoRQP"
X-Original-To: io-uring@vger.kernel.org
Received: from mail-ed1-f47.google.com (mail-ed1-f47.google.com [209.85.208.47])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E78EF35976
	for <io-uring@vger.kernel.org>; Sat,  1 Mar 2025 02:35:56 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.208.47
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1740796558; cv=none; b=hzJ95jJhp4mpdxlsHtWpu+oiNT2rcfUbyD/O1MGjTK1IycvP/Y5QYpn1TfYW2upY1+rGLisG2cPMI2oac2ZyQzgjABA6N7MVqfX453WRL6ef5Qx8BWVg5OW5zxTvsgMfUdMsCfEMHK9G+B5Z11/U3v2nmKynPmSjVx/HtUj8A30=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1740796558; c=relaxed/simple;
	bh=BSr5X0iWpV44VNLVd/yONK1VVrZSwZXETXIm2nCbRuQ=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=AMr8pO0E5w+RLR4xISj4f3YEvsxFfRnNYScGsNpMem1QJVtEmD58/iLDR+OZiU9hTPKAGQS0soYtdIEb7S7PaD30r0WjoIdvk7zLfz2JXH3nnglsQj9j1nkOcdGtf8aEyuAplUoQRRwHKdLw0IqscwyzX2Eq2nbNIuh4R+ZYeI0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=iCaPoRQP; arc=none smtp.client-ip=209.85.208.47
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Received: by mail-ed1-f47.google.com with SMTP id 4fb4d7f45d1cf-5e0813bd105so4681007a12.1
        for <io-uring@vger.kernel.org>; Fri, 28 Feb 2025 18:35:56 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1740796555; x=1741401355; darn=vger.kernel.org;
        h=content-transfer-encoding:in-reply-to:from:content-language
         :references:cc:to:subject:user-agent:mime-version:date:message-id
         :from:to:cc:subject:date:message-id:reply-to;
        bh=rB8hyU0AFWWwm/tgMrIpdcP2ri6YPLWI0rDqRhVhyDU=;
        b=iCaPoRQP7M+vv8tMHsHtgAirfeCUig7bdIZFAjeNJjzrYLoZXpQdaiMfiHMcPWu5AT
         FpUN0LfqUHPR5dHgxlPwM/KlEyL90KXdCaPfk/6Qw0Ny+nIFDrldJL+MMP1Rp88BaKgw
         7w5dOkzqu/5cC0UI1v5ap8Bhcuemuga3DZM0G6r0v34WLS6VbWRMXINEmtoVskkeU2g7
         ULxdwQyiby6TiIBCQPDHd5gB1PEhJE533aV2LDXZnmY6PS89xIDtbRJkupXxlJl2zIMM
         eZlrykJuhAj6rxiAt/IEoruCrKzlwJeaXTahcfSK01VgPIpunOaruhA3XprbEGLe9ABn
         R+ZQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1740796555; x=1741401355;
        h=content-transfer-encoding:in-reply-to:from:content-language
         :references:cc:to:subject:user-agent:mime-version:date:message-id
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=rB8hyU0AFWWwm/tgMrIpdcP2ri6YPLWI0rDqRhVhyDU=;
        b=v8LRanlJ3n8Yv4zb2cDFgZqPS9jpZrpQN3n9eAFfOJ4z0oS5H9vRSbCEz2Z1YYBoXV
         baKY1aWbmWEf/orQIH3rC8dGVl0oKEnEFtxboB4UBdvgS7+y7TO1dpWEz9H3YUvsiS0P
         wS3RngJ74YJkGcT+fQAxRMZMaQf29uPamgxf+KWTwPKm7OCZf5ZExl4l0ey3m9k/HcPE
         DE3Iy9JcpXpUpx9Ig1HBr4RqgY/kum4hOePMCh6wpqSfgMA1LSrJfEyfbARZaix1T9Tz
         Blux5SzM66oiCR+OaeJYqTG0wFqrsNfnN3go5nhHGJUpgGsfZxWwBAzxzolXYUbCJ2/V
         zCNw==
X-Gm-Message-State: AOJu0YwZHuwYHOODe+foC07CxiLOrYhbcrknYkJozIMF5ENPOJ0B3ghO
	nz+4au7V1+Yi1EihP5JtJJsgn11EFPUJmX0qBVt6tQWCR4pu1VDV
X-Gm-Gg: ASbGncuKrKHY94IOuHYMoCkT4Ru3MifV94Xuoh6j+X01r2kEQcjaQaY4PZx2zRjbBUn
	SHVJV+DBKHwtbqEip2ivgI02kpRwkfsHRj7PQhdTlvkF4LN4vzYm44Nx63KfkDDOP1IwJbYwKH/
	gOZoEKLQVdAK2y6cf6utfQl4gSpcp+UpmR8YHR9aBxr6QAmAOQDM4oEw2kEfdfOA2F4X/sydyAw
	Nrvkvs9BNSwLAVb4D8WiiY9OiYuuPrWVIlv4W/YHinqpiXhjOy0MHMAN0Le/T5P7XwPzGe364ny
	7WyDnlEBSUJjcKYS+sV57JACiaanes9OwB2jM5NTtul7cc/dl31CGME=
X-Google-Smtp-Source: AGHT+IFfpozMO96yabLZvo8U3HdJ7el2g3rUIABtc8OZAua4DcKMNV1+V8EsBqCa6Ey3lvZzvyefLg==
X-Received: by 2002:a05:6402:2354:b0:5e0:82a0:50e6 with SMTP id 4fb4d7f45d1cf-5e4d6b70f9cmr4216236a12.20.1740796555061;
        Fri, 28 Feb 2025 18:35:55 -0800 (PST)
Received: from [192.168.8.100] ([148.252.144.117])
        by smtp.gmail.com with ESMTPSA id 4fb4d7f45d1cf-5e4c3b4aaf1sm3339180a12.13.2025.02.28.18.35.51
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Fri, 28 Feb 2025 18:35:53 -0800 (PST)
Message-ID: <cc3a3a35-ab5d-45ac-9f0e-963632c872e4@gmail.com>
Date: Sat, 1 Mar 2025 02:36:59 +0000
Precedence: bulk
X-Mailing-List: io-uring@vger.kernel.org
List-Id: <io-uring.vger.kernel.org>
List-Subscribe: <mailto:io-uring+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:io-uring+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH 2/2] io_uring/nop: use io_find_buf_node()
To: Jens Axboe <axboe@kernel.dk>,
 Caleb Sander Mateos <csander@purestorage.com>
Cc: io-uring@vger.kernel.org
References: <20250301001610.678223-1-csander@purestorage.com>
 <20250301001610.678223-2-csander@purestorage.com>
 <d4271290-2abb-49ee-a99a-bc8bb6dde558@gmail.com>
 <e84d5e50-617b-421e-bed6-628cacc28cf9@gmail.com>
 <524be10f-c873-40f1-91b7-ae597dadcca0@kernel.dk>
Content-Language: en-US
From: Pavel Begunkov <asml.silence@gmail.com>
In-Reply-To: <524be10f-c873-40f1-91b7-ae597dadcca0@kernel.dk>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit

On 3/1/25 02:21, Jens Axboe wrote:
> On 2/28/25 7:15 PM, Pavel Begunkov wrote:
>> On 3/1/25 01:41, Pavel Begunkov wrote:
>>> On 3/1/25 00:16, Caleb Sander Mateos wrote:
>>>> Call io_find_buf_node() to avoid duplicating it in io_nop().
>>>
>>> IORING_NOP_FIXED_BUFFER interface looks odd, instead of pretending
>>> to use a buffer, it basically pokes directly into internal infra,
>>> it's not something userspace should be able to do.
>>>
>>> Jens, did use it anywhere? It's new, I'd rather kill it or align with
>>> how requests consume buffers, i.e. addr+len, and then do
>>> io_import_reg_buf() instead. That'd break the api though, but would
>>> anyone care?
>>
>> 3rd option is to ignore the flag and let the req succeed.
> 
> Honestly what is the problem here? NOP isn't doing anything that
> other commands types can't or aren't already. So no, it should stay,

It completely ignores any checking and buffer importing stopping
half way at looking at nodes, the behaviour other requests don't
do. We can also add a request that take a lock and releases it
back because other requests do that as well but as a part of some
useful sequence of actions.

> it's been handy for testing overheads, which is why it was added in
> the first place.



-- 
Pavel Begunkov


