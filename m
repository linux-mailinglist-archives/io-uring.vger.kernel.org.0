Return-Path: <io-uring+bounces-6705-lists+io-uring=lfdr.de@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [147.75.80.249])
	by mail.lfdr.de (Postfix) with ESMTPS id E5087A42D2A
	for <lists+io-uring@lfdr.de>; Mon, 24 Feb 2025 20:57:04 +0100 (CET)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id 32EAC18925AC
	for <lists+io-uring@lfdr.de>; Mon, 24 Feb 2025 19:57:08 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 347A8204F8B;
	Mon, 24 Feb 2025 19:56:53 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel-dk.20230601.gappssmtp.com header.i=@kernel-dk.20230601.gappssmtp.com header.b="Uv6f1NNJ"
X-Original-To: io-uring@vger.kernel.org
Received: from mail-io1-f54.google.com (mail-io1-f54.google.com [209.85.166.54])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5DC141FFC47
	for <io-uring@vger.kernel.org>; Mon, 24 Feb 2025 19:56:50 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.166.54
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1740427013; cv=none; b=fFQxLohYkwodWZAsP5Rs5zUWzjQl2ovlbKNq+LUkS9U4w5BfHXuHZ1rDQz9Bv6ymGfGKZPGJusFy8vmSGiUwZEiBl335vx2S1fRQzgAsl/HbEzKwbDrNhN7eekRchw27f9ZLHwNkDnmUW0sjPphyXPcBFA2Hwa9cpBezUS6SChQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1740427013; c=relaxed/simple;
	bh=B9HJUM0flXm/HLYNWLRVgYUVWPW50AKcjrAUejBZgHo=;
	h=Message-ID:Date:MIME-Version:Subject:From:To:Cc:References:
	 In-Reply-To:Content-Type; b=WIGSymXzL6Ty8BYTpdVqXgOVYaD6sxtmCPPbYezwjGmLnJwuEwrG9nmIzOMwI6jfwDmISlBexxHIqS/9fYfLMaS6FjJ5QPuTRwo1Cqu4mcMpRiBk4xXQApEFNfoNwGmMjW/jtSO5h63o3XVS7X6YSLOdqORiEir/4BoNL+yDU/Q=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=kernel.dk; spf=pass smtp.mailfrom=kernel.dk; dkim=pass (2048-bit key) header.d=kernel-dk.20230601.gappssmtp.com header.i=@kernel-dk.20230601.gappssmtp.com header.b=Uv6f1NNJ; arc=none smtp.client-ip=209.85.166.54
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=kernel.dk
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=kernel.dk
Received: by mail-io1-f54.google.com with SMTP id ca18e2360f4ac-855a095094fso126866739f.1
        for <io-uring@vger.kernel.org>; Mon, 24 Feb 2025 11:56:50 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernel-dk.20230601.gappssmtp.com; s=20230601; t=1740427009; x=1741031809; darn=vger.kernel.org;
        h=content-transfer-encoding:in-reply-to:content-language:references
         :cc:to:from:subject:user-agent:mime-version:date:message-id:from:to
         :cc:subject:date:message-id:reply-to;
        bh=ptlnKaTO3pD8QXv17dCfckKDfHxsa0opFW4bNWeAHp0=;
        b=Uv6f1NNJEVGGRL4wT9pPgBmClq2NswDI7gt6NklLMFSV5RKcNaZpKavX53mpu2wmYb
         +gWIxPMlR/jkvqV/tA+k2pmC4UiTHy4d8BOh5p+RR4qVcsa+8ZMphZnxQzzcdqCRTqhn
         6oe22FwWI1SMZTCnd99eEP0jVHc3zUxDHM9mlBAqTLdvkAg7xXQ2X/IGH4oEoNGx4ArZ
         PfNZnJ7We0F7bv3hPnYcFAnv5DumcJzixp8nzs+xR85RofvsgxKTuOx0HC1Nlz8n2JGA
         y3DgBqfFsVVed2UHLcJ9eL/CNdTrrzryU2PnNkPLbiqrG7FAVZpWw8yG9qISnfVA5kTH
         oWTQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1740427009; x=1741031809;
        h=content-transfer-encoding:in-reply-to:content-language:references
         :cc:to:from:subject:user-agent:mime-version:date:message-id
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=ptlnKaTO3pD8QXv17dCfckKDfHxsa0opFW4bNWeAHp0=;
        b=HjGK+JzXxOKhNWOypk62h8soql7riRlMLy1dME1gPZXHBeLmV2TAfCk2j/a8Z7uU7Y
         EFYxFsJi45njVzBuEGfN65eM06hl+1RQ4nC48ocO+R3mq67FYl7ApGcvU4f4ziBWHCwL
         F7WcE4fqGx22+H6mXyz2/kav1at+CH+OstV4aAqMFsLYoGUdXLgLD1/A30zduIZ2g4Tf
         Y7d2p1EiAiWG7Bto5+PXXztxAXRkgPaVq/iYN3csKVHJTy/lA/GwOzCU3IA+8NPi29rV
         XEKpeVShuKJt1dISx8vnlNi3cai8Ng3oLCcSHF9OfEE7mTe2tZ+tPIs516UTwfT77Bk7
         saVg==
X-Gm-Message-State: AOJu0YyjYeC8oLHgsiKjV5UUGP2ZOz2QrrXA844Ebl7FG9M9dB15Amec
	Rn7+CxuTVr3nwbXq9+9TAtPIW3bjPl87wlYEtI5eb2FvzZ5zgdHDE0lmiFnXBI6DTTxls3wrrwt
	o
X-Gm-Gg: ASbGncvwwxkhwRk1LmVN6ttQpLV0HNzV24e+IPhgvZ7/5r2F7EJR2swEUAucGlYr3GC
	1qduX0YF6pkFtTR0lrVEZW74o2G4Rl3EfM36+WY5MUiY4lc1Fs73NkIzTGvpWiTI5KAffINrGf2
	OsCmYC/JRPG+oXUzwPKH+J1JAnrz95nObF2NV9pm14BvWjejKtR3xL4r67NN1SEWgocrw5HYeQo
	1fhYQZSd7nO3osU0k7VJVhFR5y67e8GBQiNAvh2BhPTifLSyL/jV4cH+/+Y/kpeud5qqCvpwUsC
	xnACeZNFt38W2/zunSrag58=
X-Google-Smtp-Source: AGHT+IHnYAzAjz+SbXLx+w0x2bIFT0JKHj/T8TallRggapVT0YM5yTeLbpCAzvdzgNKixIwr4Mn8KQ==
X-Received: by 2002:a05:6602:3411:b0:84f:2929:5ec0 with SMTP id ca18e2360f4ac-855da9be5d5mr1810599039f.4.1740427008700;
        Mon, 24 Feb 2025 11:56:48 -0800 (PST)
Received: from [192.168.1.150] ([198.8.77.157])
        by smtp.gmail.com with ESMTPSA id ca18e2360f4ac-856209f893csm3551539f.2.2025.02.24.11.56.47
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Mon, 24 Feb 2025 11:56:48 -0800 (PST)
Message-ID: <17c27735-a613-4bd5-89df-645ae7ed83a2@kernel.dk>
Date: Mon, 24 Feb 2025 12:56:47 -0700
Precedence: bulk
X-Mailing-List: io-uring@vger.kernel.org
List-Id: <io-uring.vger.kernel.org>
List-Subscribe: <mailto:io-uring+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:io-uring+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v3 0/2] io_uring/zcrx: recvzc read limit
From: Jens Axboe <axboe@kernel.dk>
To: io-uring@vger.kernel.org, David Wei <dw@davidwei.uk>
Cc: Pavel Begunkov <asml.silence@gmail.com>, lizetao <lizetao1@huawei.com>
References: <20250224041319.2389785-1-dw@davidwei.uk>
 <174040774071.1976134.14229369640864774353.b4-ty@kernel.dk>
Content-Language: en-US
In-Reply-To: <174040774071.1976134.14229369640864774353.b4-ty@kernel.dk>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit

On 2/24/25 7:35 AM, Jens Axboe wrote:
> 
> On Sun, 23 Feb 2025 20:13:17 -0800, David Wei wrote:
>> Currently multishot recvzc requests have no read limit and will remain
>> active so as long as the socket remains open. But, there are sometimes a
>> need to do a fixed length read e.g. peeking at some data in the socket.
>>
>> Add a length limit to recvzc requests `len`. A value of 0 means no limit
>> which is the previous behaviour. A positive value N specifies how many
>> bytes to read from the socket.
>>
>> [...]
> 
> Applied, thanks!
> 
> [1/2] io_uring/zcrx: add a read limit to recvzc requests
>       commit: 9a53ea6aa5c87fe4c49297158e7982dbe4f96227
> [2/2] io_uring/zcrx: add selftest case for recvzc with read limit
>       commit: f4b4948fb824a9fbaff906d96f6d575305842efc

Fixed up 1/2 for !CONFIG_NET, fwiw.

-- 
Jens Axboe


