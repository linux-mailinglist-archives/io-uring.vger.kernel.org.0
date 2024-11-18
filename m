Return-Path: <io-uring+bounces-4784-lists+io-uring=lfdr.de@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [IPv6:2604:1380:45e3:2400::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 126BF9D1BD1
	for <lists+io-uring@lfdr.de>; Tue, 19 Nov 2024 00:27:42 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 6EDB9283079
	for <lists+io-uring@lfdr.de>; Mon, 18 Nov 2024 23:27:40 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id DE318194A74;
	Mon, 18 Nov 2024 23:27:39 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel-dk.20230601.gappssmtp.com header.i=@kernel-dk.20230601.gappssmtp.com header.b="S1oEU54z"
X-Original-To: io-uring@vger.kernel.org
Received: from mail-pj1-f48.google.com (mail-pj1-f48.google.com [209.85.216.48])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5A544147C71
	for <io-uring@vger.kernel.org>; Mon, 18 Nov 2024 23:27:36 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.216.48
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1731972459; cv=none; b=J5i02J71KO12yeKD9m95632oVUo+qp4w0+v5O5k57XCz91LVNFxXi4M+CRR8ECd3nVhyn9wuMXmq77LK0FroO9iFpDHVgqebNkL/biOk9fKbNUdHYRHFfV79LXopZ1CJHQ1XprE12X1n151VRTFEp3seHAo/b3jVo6FE9UabUfk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1731972459; c=relaxed/simple;
	bh=op0OdfpB0nzAhqQZ/xqu1F0X5M+diS5+94gLfXixwZE=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=iSWU/U5bWG5/sTkWZsNmogi8+OX7ZVL06lJ6MdJXvrhzw0dIksjRGjA1MwcZStaQnafOCG3kO/7GXCvEmhanpdL/XuW5TP3mJNLwP5eHGDvQ9zm1U6dMD840Utj3wsgkQUEqRJXT5mL6CqevyrOIGxlCKr2M98q727JujmQnPx0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=kernel.dk; spf=pass smtp.mailfrom=kernel.dk; dkim=pass (2048-bit key) header.d=kernel-dk.20230601.gappssmtp.com header.i=@kernel-dk.20230601.gappssmtp.com header.b=S1oEU54z; arc=none smtp.client-ip=209.85.216.48
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=kernel.dk
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=kernel.dk
Received: by mail-pj1-f48.google.com with SMTP id 98e67ed59e1d1-2ea78d164b3so211263a91.2
        for <io-uring@vger.kernel.org>; Mon, 18 Nov 2024 15:27:36 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernel-dk.20230601.gappssmtp.com; s=20230601; t=1731972456; x=1732577256; darn=vger.kernel.org;
        h=content-transfer-encoding:in-reply-to:from:content-language
         :references:cc:to:subject:user-agent:mime-version:date:message-id
         :from:to:cc:subject:date:message-id:reply-to;
        bh=aOAwgP/lskGuR8jLgC596n5ztTlsXHwd6wcN7iy5MZ4=;
        b=S1oEU54zs7Sh7QLtt1njdYOx9QtovL+2ZiFpwdkSbSjtX6kmbdZ/yWdl5NDQn/MZCE
         Q3V7g9PK53nIHh1tSOVf2N0/60GG1FsNZcuhmzfUo+Fd6wEYKsp0/4hQ7FhnajhsNoGa
         FrrwzLx8JPxglkzDQJ2PjyM3zP7Jox5fX13CjmA+DBR3RI+J/Coo/zqkJfp7jnjck6cM
         VoIvdxiU3W4Dg9hlR8TQb2wJubO5O1FP1GBvBB6WHyv54BoEaQrKJvXwKU/qTowSOxzz
         L39zYc1ymheKXiJNmR42gWTOmVAicipa2jYZzLQ/r5ZriLRWGbHUS9YumgDsmcOAdG2s
         6exA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1731972456; x=1732577256;
        h=content-transfer-encoding:in-reply-to:from:content-language
         :references:cc:to:subject:user-agent:mime-version:date:message-id
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=aOAwgP/lskGuR8jLgC596n5ztTlsXHwd6wcN7iy5MZ4=;
        b=r4XfCtjz9gY+xHXZxsjiRSyorzdTid1nWLQzBN0obrueQPATefUUyxxg182Z49I4f6
         dKy8GbM1/N+UKdeCBCv2ZeCOwicq5fJG96XqTZFGOdlQEDK9NgDEv2bJp8wD0jnmcFVC
         lYt5kmf2Pn3CvzqXformGfYUwqv6vUjVX5iy65Z8R0DJcTRdGZKDV+Kt1inNtB3SoGfY
         ZdrtnzVZcFwiMJJZ7PqaTFs6GdDVOBQHfJTdatq36mLuGEZ1a3bPkqcc3+tUJOM0MYfu
         nBYSo5348tg6WE36D6AbJyZFPHgFN4fyM6m2MZzewaSdSzFAULpyVYA/EQdqCseninpb
         LY6w==
X-Forwarded-Encrypted: i=1; AJvYcCXHrROQAYulDt3r0yKTQrmsY9M5UlunZfvj/sL7brUj0bje/UAZaUd/w1VlusQbEq5DPEC6VX2ATA==@vger.kernel.org
X-Gm-Message-State: AOJu0YwJPgSuqApXOu3IShgRzObimH5bQxA4Q0INsddSB4BCNoePwZcL
	eLYDkfElOr3+2p+4h9PbJwN0MMcfzvwJg+2ndF6TXLpGY/Ju1yCrHy3VyT1zWwY=
X-Google-Smtp-Source: AGHT+IFgZaz12LCyMidZuDwme1CelgLxS4ERqNxnEKCN8Ikg1RgI+1+EE10S4lfY9LEIHq+r0RTSAw==
X-Received: by 2002:a17:90b:1dcc:b0:2ea:a565:18b1 with SMTP id 98e67ed59e1d1-2eaa5651946mr2531240a91.8.1731972455652;
        Mon, 18 Nov 2024 15:27:35 -0800 (PST)
Received: from [192.168.1.150] ([198.8.77.157])
        by smtp.gmail.com with ESMTPSA id 98e67ed59e1d1-2ea06fbb293sm8006707a91.48.2024.11.18.15.27.34
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Mon, 18 Nov 2024 15:27:34 -0800 (PST)
Message-ID: <9aabca30-26a8-41d2-8421-4c547fbf94fa@kernel.dk>
Date: Mon, 18 Nov 2024 16:27:34 -0700
Precedence: bulk
X-Mailing-List: io-uring@vger.kernel.org
List-Id: <io-uring.vger.kernel.org>
List-Subscribe: <mailto:io-uring+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:io-uring+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [GIT PULL] io_uring changes for 6.13-rc1
To: Sasha Levin <sashal@kernel.org>
Cc: Linus Torvalds <torvalds@linux-foundation.org>,
 io-uring <io-uring@vger.kernel.org>, tglx@linutronix.de
References: <ad411989-3695-4ac9-9f96-b95f71918285@kernel.dk>
 <Zzu6dkYTFX2AA26c@sashalap>
Content-Language: en-US
From: Jens Axboe <axboe@kernel.dk>
In-Reply-To: <Zzu6dkYTFX2AA26c@sashalap>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit

On 11/18/24 3:06 PM, Sasha Levin wrote:
> Hi Jens, Thomas,
> 
> On Mon, Nov 18, 2024 at 07:22:59AM -0700, Jens Axboe wrote:
>> hexue (1):
>>      io_uring: add support for hybrid IOPOLL
> 
> After merging of this pull request into linus-next, I've started seeing
> build errors:
> 
> /builds/linux/io_uring/rw.c: In function 'io_hybrid_iopoll_delay':
> /builds/linux/io_uring/rw.c:1179:2: error: implicit declaration of function 'hrtimer_init_sleeper_on_stack'; did you mean 'hrtimer_setup_sleeper_on_stack'? [-Werror=implicit-function-declaration]
>   hrtimer_init_sleeper_on_stack(&timer, CLOCK_MONOTONIC, mode);
>   ^~~~~~~~~~~~~~~~~~~~~~~~~~~~~
>   hrtimer_setup_sleeper_on_stack
> 
> This is because 01ee194d1aba ("io_uring: add support for hybrid IOPOLL")
> adds a call to hrtimer_init_sleeper_on_stack() which was removed earlier
> today in Thomas's PR[1], specifically in commit f3bef7aaa6c8
> ("hrtimers: Delete hrtimer_init_sleeper_on_stack()").

Right, forgot to mention that. linux-next has been carrying a fixup for
that which I was going to link, but it's not on a public list for some
reason. In any case, it's trivial to fixup, just change

hrtimer_init_sleeper_on_stack(&timer, CLOCK_MONOTONIC, mode);

to

hrtimer_setup_sleeper_on_stack(&timer, CLOCK_MONOTONIC, mode);

in io_uring/rw.c while merging either of the two trees that go in last.

FWIW, this kind of change should be done before -rc1 rather than be
queued up earlier. That's usually the best way to do these things and
avoid -next or merge window breakage. I'm guessing this tree isn't the
only one going to get hit by that.

-- 
Jens Axboe

