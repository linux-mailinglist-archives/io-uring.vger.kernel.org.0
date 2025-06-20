Return-Path: <io-uring+bounces-8440-lists+io-uring=lfdr.de@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [147.75.199.223])
	by mail.lfdr.de (Postfix) with ESMTPS id 600B2AE1D5F
	for <lists+io-uring@lfdr.de>; Fri, 20 Jun 2025 16:31:38 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id 80B1A17BDF1
	for <lists+io-uring@lfdr.de>; Fri, 20 Jun 2025 14:31:37 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id CA8AF1A76DE;
	Fri, 20 Jun 2025 14:31:31 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel-dk.20230601.gappssmtp.com header.i=@kernel-dk.20230601.gappssmtp.com header.b="QQleQUxH"
X-Original-To: io-uring@vger.kernel.org
Received: from mail-pf1-f179.google.com (mail-pf1-f179.google.com [209.85.210.179])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D676528A703
	for <io-uring@vger.kernel.org>; Fri, 20 Jun 2025 14:31:28 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.210.179
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1750429891; cv=none; b=N7mJbQC7jctFuXqaXDkbKDnqVq3cJbJseQjK9q/fXZueAyzUacK8U+BXuLpAMbwmQVtbSxZMt0xmHNQ8rpVVHSzuieAJXgzD8JiP3e5XlMDZVRkaob75ugod+AtaFWIlp840Ed3T1mvf/AI1vnQj8WuAkUp9efXJcTxYiNYz2yQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1750429891; c=relaxed/simple;
	bh=myfNPrpp+Td/Pu0vz/rZVBPOZTX4bO93UORciB2daFg=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=G3XjyM9u5t9lFSpSWxop8G/g2F2VCL6WJ1yqYd1pdcak0SI/bMJrgZL4bNtywQYD059Fd7nXk3eoNRW2x/D0yNej8LQhEcKtGERzu8yPh6TXwUbdlR+KoGRfNbC0/ITn9IJRbhZWMmn30dAfTeAPOwiXehiC4qTrn012bhmUcc4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=kernel.dk; spf=pass smtp.mailfrom=kernel.dk; dkim=pass (2048-bit key) header.d=kernel-dk.20230601.gappssmtp.com header.i=@kernel-dk.20230601.gappssmtp.com header.b=QQleQUxH; arc=none smtp.client-ip=209.85.210.179
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=kernel.dk
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=kernel.dk
Received: by mail-pf1-f179.google.com with SMTP id d2e1a72fcca58-748e378ba4fso2559723b3a.1
        for <io-uring@vger.kernel.org>; Fri, 20 Jun 2025 07:31:28 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernel-dk.20230601.gappssmtp.com; s=20230601; t=1750429888; x=1751034688; darn=vger.kernel.org;
        h=content-transfer-encoding:in-reply-to:from:content-language
         :references:cc:to:subject:user-agent:mime-version:date:message-id
         :from:to:cc:subject:date:message-id:reply-to;
        bh=JPissv+SzLajMZJYbP5O1wQ7Fk0qymzOwUfYk9eGlXw=;
        b=QQleQUxHnsFGB7nFB/udqmS8BB0qXlV7igURW9lM82c/iIRXPu3PtwhrlKQP5iWano
         l0NoWCe6uQQFzM3w7ht8LABzXjPGInaN8ZoEYWihADy74sj4rZaGHJ7N7Usvt871cwQ0
         joNfUzIDlISdrCW62EN24b/+zvLvXASOKqDWPPGS/xJG6lThjNbCLGamUJboKGJOlQ5x
         pUSS7FRlBPzwtzo6cXlFIQ/WYwoeKUpPEyBlJlPsmMYMvIkeZsO/oNncEPkfszSTQizr
         0qqo1QJnvmcVZb2Z9HKUkdg3/oKZWTuXksgXbBGrHFnqvdWVBQ8qcE/eFHMvdflmojc7
         4OZQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1750429888; x=1751034688;
        h=content-transfer-encoding:in-reply-to:from:content-language
         :references:cc:to:subject:user-agent:mime-version:date:message-id
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=JPissv+SzLajMZJYbP5O1wQ7Fk0qymzOwUfYk9eGlXw=;
        b=wlJXUulrgeETIAy2RGwIksvILn1oKDczsQaOdJbLlxCXwZ0aT6MiHVEDe26+V8g/87
         56UeyogpwDFSukskB9Y/3yiZ0IPWDkD5NAenWn7utT1GuX0WEk6EOhlNochlf7qE430X
         Vs8ouFVMaX/oBREK05lol8L7U9ygmv6WtPSaXxKO3KiBSZPaTZs4nEqfMH6tZuoS60kk
         P7grF74O0R1nobU7Cr4zu/M7p2Kcn40ZojHEMd0CAEmo25EllIkJI2pRFraYv+4Qai7/
         xknpCLuj2Nk8VeZofwM6b4yV4xm4eWO0773XIAuXmZCLkvJhkyJlw3Vyp5WMm7i5ylZS
         uN2Q==
X-Forwarded-Encrypted: i=1; AJvYcCWxDmbCpN8QAdSxdFn3Rj50SsG45mEQ5XAvaZfod5pKw9NYmKhgQ0zJijda7Y8GV9a1sar80/FZBQ==@vger.kernel.org
X-Gm-Message-State: AOJu0Ywf9k79lUFn/9U3XturmWvsa/TLoHoz7C7ecRXpJiLV88FgUQwg
	JmSQ6W/0zhCnX9iZPxXe7Oxb2UkkcbO1/6gdijs6xDK1tAD62b9S2GryWtfl2KZdRV4=
X-Gm-Gg: ASbGnctjc1IFVvGpT9yiAO65vgy3D+oNYi130O815lV2MeEKbU18HczmMFZKg9PjjJw
	5u3uNz/+u8T2z5nKOHwxpk+zJ3vrcGvWUpDcgSIVvUp0oQEIkLesu5LCUmENjvNNKaXSCdMxiJ6
	wj6AQo7nyrtTY3D6Q9qT2lcEjpgLVh9AWZZZPtOGqmfMRAdRUNkItynbqwvwT2YViqYgxyUV0B3
	ih93jsyOb4U27pvCP95Jj7fZVIcVY/uUAQjQlBErNH3KcSFlUwyqj2K4YhXOmNBYpPVZ59n0OjY
	Q+j85609kr2Nl6DEWZduZBcAyWqljd9NEz7GozX3lf1Y9G4S+9mbNsNV20osgAJxGNUl5JbdsXa
	xKUjmYLChNjDwHUeFr9wnmNgqO/M+
X-Google-Smtp-Source: AGHT+IHxr2om9jVWGFaQjjJHWMDX0OVhrO+Sp8ob/UBVdmaz5aFhQ700apz5Br9rUh1gx9zJRLiliA==
X-Received: by 2002:a05:6a20:4326:b0:1f5:8622:5ed5 with SMTP id adf61e73a8af0-22026d33a44mr5126355637.3.1750429888039;
        Fri, 20 Jun 2025 07:31:28 -0700 (PDT)
Received: from [192.168.11.150] (157-131-30-234.fiber.static.sonic.net. [157.131.30.234])
        by smtp.gmail.com with ESMTPSA id 41be03b00d2f7-b31f126b6fesm1835692a12.71.2025.06.20.07.31.26
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Fri, 20 Jun 2025 07:31:27 -0700 (PDT)
Message-ID: <1fb789b2-2251-42ed-b3c2-4a5f31bca020@kernel.dk>
Date: Fri, 20 Jun 2025 08:31:25 -0600
Precedence: bulk
X-Mailing-List: io-uring@vger.kernel.org
List-Id: <io-uring.vger.kernel.org>
List-Subscribe: <mailto:io-uring+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:io-uring+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v5 0/5] io_uring cmd for tx timestamps
To: Jakub Kicinski <kuba@kernel.org>
Cc: Pavel Begunkov <asml.silence@gmail.com>, io-uring@vger.kernel.org,
 Vadim Fedorenko <vadim.fedorenko@linux.dev>, netdev@vger.kernel.org,
 Eric Dumazet <edumazet@google.com>, Kuniyuki Iwashima <kuniyu@amazon.com>,
 Paolo Abeni <pabeni@redhat.com>, Willem de Bruijn <willemb@google.com>,
 "David S . Miller" <davem@davemloft.net>,
 Richard Cochran <richardcochran@gmail.com>,
 Stanislav Fomichev <sdf@fomichev.me>, Jason Xing <kerneljasonxing@gmail.com>
References: <cover.1750065793.git.asml.silence@gmail.com>
 <efd53c47-4be9-4a91-aef1-7f0cb8bae750@kernel.dk>
 <20250617152923.01c274a1@kernel.org>
 <520fa72f-1105-42f6-a16f-050873be8742@kernel.dk>
 <20250617154103.519b5b9d@kernel.org>
Content-Language: en-US
From: Jens Axboe <axboe@kernel.dk>
In-Reply-To: <20250617154103.519b5b9d@kernel.org>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit

On 6/17/25 4:41 PM, Jakub Kicinski wrote:
> On Tue, 17 Jun 2025 16:33:20 -0600 Jens Axboe wrote:
>>>> Sounds like we're good to queue this up for 6.17?  
>>>
>>> I think so. Can I apply patch 1 off v6.16-rc1 and merge it in to
>>> net-next? Hash will be 2410251cde0bac9f6, you can pull that across.
>>> LMK if that works.  
>>
>> Can we put it in a separate branch and merge it into both? Otherwise
>> my branch will get a bunch of unrelated commits, and pulling an
>> unnamed sha is pretty iffy.
> 
> Like this?
> 
>  https://git.kernel.org/pub/scm/linux/kernel/git/netdev/net-next.git timestamp-for-jens

Branch seems to be gone?

-- 
Jens Axboe


