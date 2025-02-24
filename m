Return-Path: <io-uring+bounces-6694-lists+io-uring=lfdr.de@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [IPv6:2604:1380:45e3:2400::1])
	by mail.lfdr.de (Postfix) with ESMTPS id D6424A42C60
	for <lists+io-uring@lfdr.de>; Mon, 24 Feb 2025 20:10:12 +0100 (CET)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id BF49B3AF748
	for <lists+io-uring@lfdr.de>; Mon, 24 Feb 2025 19:09:14 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 632D0189F36;
	Mon, 24 Feb 2025 19:09:23 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="QaN0ly9t"
X-Original-To: io-uring@vger.kernel.org
Received: from mail-wm1-f52.google.com (mail-wm1-f52.google.com [209.85.128.52])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 956FE2571B6;
	Mon, 24 Feb 2025 19:09:21 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.128.52
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1740424163; cv=none; b=h1PmC2w7Xgc8JDxKsiZ5shQ4iDtFFBmGE0MlGcaQ9tPM0VkcitnfBJKZH8FcxxWbOtEDvFXAUnhkOIupDc13RY6ZkJFm26yrL064OJ21VhNJv/5/C9DpovmwyVjh+NJJwMwNg//fR7svuYavHrmI/WWvU3SgME9USOyKtKjgkWA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1740424163; c=relaxed/simple;
	bh=AO+oiXMHey1DEavsd6Mj+oSRViT5e1/66qv9EOg0W1E=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=gXZ7zrYeZqKUFSehHUtKVmjXgv4dCJgeHri5Psg84nRzN818AHG1HLREV9TS10Ckprz2fuqyFJkQLZaiTH4FW/rVyOeL/lAn5iizWcUbbnUg7UGnyv3yqNjajFt0HUhmpiWjPTtUsGqXhkocdr2kudStUTEgvJEfGC/rVnRpz4g=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=QaN0ly9t; arc=none smtp.client-ip=209.85.128.52
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Received: by mail-wm1-f52.google.com with SMTP id 5b1f17b1804b1-4399ca9d338so29123225e9.3;
        Mon, 24 Feb 2025 11:09:21 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1740424160; x=1741028960; darn=vger.kernel.org;
        h=content-transfer-encoding:in-reply-to:from:content-language
         :references:cc:to:subject:user-agent:mime-version:date:message-id
         :from:to:cc:subject:date:message-id:reply-to;
        bh=/CKcU0C8ZMEZgmOHeVZOESVRF1hF1d3aMmQyfjNdoQw=;
        b=QaN0ly9tXJtVqgIe+/JFglTy2+RLZHxuf9YcvJH9NnRYb5fHIxnqzhpNf1BD0CD6jt
         yyig4LfxWiimf1pnRPBOudKI+SR0WpyNUv8GOnY9/c7amjxReN3fhNKfLozEnMSRYYiM
         qH1Y9PLEIS6fv0B3ATv1sozaBXpohGKwCCztIceJz+kljASrViFV+bZgdEQgCb48dhk6
         hQbypowFyLpREBT4jeJ40V7j1ZZS+acFV2/fTQ9QZd9TMzff93agCkWkm1rq3u30qfe+
         wzxYf8z4VfXReNFtz1K2kAqKbImRkTK3EwqBgOSWp9sx1vJG4Y/+nfWof85973/UjvlS
         42OQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1740424160; x=1741028960;
        h=content-transfer-encoding:in-reply-to:from:content-language
         :references:cc:to:subject:user-agent:mime-version:date:message-id
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=/CKcU0C8ZMEZgmOHeVZOESVRF1hF1d3aMmQyfjNdoQw=;
        b=RGxtCo4pXfDYn7NvXeL/mYkWPqjZNpsH0zz4iodei2/yVzaJi16OdkS1UAoHsLHhjp
         oYFetm7Y0mDeJ+e3MIWRYmJ317of/p71tD29aXqNhx5ed6lktl7qFrS1mzv8Taj/0+jN
         2wQ3/KBkqAUaV2wuJnatE+v/rIJYleP71DWyt98wMb3on8dJKVhkyY6gaVxr9vndclIH
         eslZWivfmHpxU622kmhDi/OuAwkN/0k0GVCGrfULIwp2MNM493tnzN5lz+jmLSJFxu3G
         NMvIUQ2C1ud3rAajgYTJfkjGWyd+tfeQYOgrVAs66p4vPz5AYZ1YwWBFWNG057giPCHr
         PynQ==
X-Forwarded-Encrypted: i=1; AJvYcCU4P03VJ8UdH2cbuN9xAJmgW7fSnzeKAvhuLDpQWNJ57YNYmuyz2yKIOnNe3BX1NpIbmtsWg+nJiJzbWVM=@vger.kernel.org
X-Gm-Message-State: AOJu0Yy+rXb8UlRrThph0PeGfHHd2EsexJ6cpaLU91siNIiTDt/IVmcP
	TML0TzXNZECeVt6w5rgXHCz1zq9Ym6Zy81IkrsGRUiz6bGDUCG0vsXDIrA==
X-Gm-Gg: ASbGncsujj+nQzIWZOrrnqTLgmn2UqeXL1Zq0gl2QtK/geO0ilMyqDfhr8xFPjrIgaR
	M63sDOOaaiEjEaAQU9senAp9/NnmCuebCEZBez+LM493dd2uTgfQpr1T28V4SahIiQz8kJY+YrT
	Q6MuA1LUGd7RP7cEVFLk0uIY4n3PfOHtNp3d208K91NNi52b51/I+e5k6z6JlsGzoi1nuLYa0BF
	XXmceheSvfUgfobcJIoulgMPN75OHKKWWRPIV08bUt65oKOzLr0+nJZDTi6QDZrqh13y3/PuE6U
	7otk45kt7TRUyNZwB6CNfc/xpZtTgOHC+mg=
X-Google-Smtp-Source: AGHT+IEZ30npC0CimIogRR7Pr6yngmIyIywR1RxmTjFHeX8FqAMxm8fkqJOCwJeWl9/xoqn1sI2IBQ==
X-Received: by 2002:a5d:6d86:0:b0:38f:27d3:1b3b with SMTP id ffacd0b85a97d-390cc5ef34cmr181193f8f.11.1740424159582;
        Mon, 24 Feb 2025 11:09:19 -0800 (PST)
Received: from [192.168.8.100] ([148.252.146.93])
        by smtp.gmail.com with ESMTPSA id ffacd0b85a97d-38f258b410dsm32314368f8f.5.2025.02.24.11.09.18
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Mon, 24 Feb 2025 11:09:19 -0800 (PST)
Message-ID: <91c200cd-2b2d-4756-b641-aa1bd4ec9796@gmail.com>
Date: Mon, 24 Feb 2025 19:10:20 +0000
Precedence: bulk
X-Mailing-List: io-uring@vger.kernel.org
List-Id: <io-uring.vger.kernel.org>
List-Subscribe: <mailto:io-uring+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:io-uring+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH] io_uring/waitid: remove #ifdef CONFIG_COMPAT
To: Jens Axboe <axboe@kernel.dk>,
 Caleb Sander Mateos <csander@purestorage.com>
Cc: io-uring@vger.kernel.org, linux-kernel@vger.kernel.org
References: <20250224172337.2009871-1-csander@purestorage.com>
 <ebad3c9b-9305-4efd-97b7-bbdf07060fea@kernel.dk>
 <CADUfDZrXAn=+4B9boaKe3aMBq19TXn8JDQm4kL0ctOxwB6YF9g@mail.gmail.com>
 <fedd8628-327a-473b-9443-4504fab48c2c@kernel.dk>
Content-Language: en-US
From: Pavel Begunkov <asml.silence@gmail.com>
In-Reply-To: <fedd8628-327a-473b-9443-4504fab48c2c@kernel.dk>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit

On 2/24/25 17:55, Jens Axboe wrote:
> On 2/24/25 10:53 AM, Caleb Sander Mateos wrote:
>> On Mon, Feb 24, 2025 at 9:44 AM Jens Axboe <axboe@kernel.dk> wrote:
>>>
>>> On 2/24/25 10:23 AM, Caleb Sander Mateos wrote:
>>>> io_is_compat() is already defined to return false if CONFIG_COMPAT is
>>>> disabled. So remove the additional #ifdef CONFIG_COMPAT guards. Let the
>>>> compiler optimize out the dead code when CONFIG_COMPAT is disabled.
>>>
>>> Would you mind if I fold this into Pavel's patch? I can keep it
>>> standalone too, just let me know.
>>
>> Fine by me, though I thought Pavel was suggesting keeping it separate:
>> https://lore.kernel.org/io-uring/da109d01-7aab-4205-bbb1-f5f1387f1847@gmail.com/T/#u
> 
> I'm reading it as he has other stuff that will go on top. I don't see
> any reason to double stage this part, might as well remove the
> CONFIG dependency at the same time, if it's doable.
> 
> Pavel?

I'm not sure why you'd want that, but I don't mind

-- 
Pavel Begunkov


