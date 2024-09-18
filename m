Return-Path: <io-uring+bounces-3223-lists+io-uring=lfdr.de@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [IPv6:2604:1380:4601:e00::3])
	by mail.lfdr.de (Postfix) with ESMTPS id 54FDC97B7C2
	for <lists+io-uring@lfdr.de>; Wed, 18 Sep 2024 08:16:53 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id 020161F23C99
	for <lists+io-uring@lfdr.de>; Wed, 18 Sep 2024 06:16:53 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 07FFE1531E6;
	Wed, 18 Sep 2024 06:16:48 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel-dk.20230601.gappssmtp.com header.i=@kernel-dk.20230601.gappssmtp.com header.b="lN4/S6z7"
X-Original-To: io-uring@vger.kernel.org
Received: from mail-wr1-f52.google.com (mail-wr1-f52.google.com [209.85.221.52])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 765612572
	for <io-uring@vger.kernel.org>; Wed, 18 Sep 2024 06:16:45 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.221.52
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1726640207; cv=none; b=cGAX8DWBCSp/mFIkwL9rIdsLZldP+uVNU1+MU3YDgRy4udeX1nAio9oCJ3Czhbcp6A7/7ckQVDBBTXZqjWiIocH1pUjEjDrbQsaGgjr1ejb7tvMZCbsKyxLfvO51O+OomOFFOBtZ24r6k8pqBPopXESC/fxnsyWgQ/N4/g9m6j0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1726640207; c=relaxed/simple;
	bh=h1x8IJe7lN71i2zcyIYHpbVMlL8euNj1bt8GoLm/poc=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=rSeb55eePdMBgygkUWw6wYMDt27xe1uNWZp9AJXtc6462BdnEWlEtwfD1IVkCPdkpzzwJVqup+a78YVWRIOFAPQJo4mB2Q7AIU1LQaXbVXKLSwW7KZdaZ+/+IGtimdM7JcAqLxwgtYsWMCZCDwCQY0bePEsOD7laY2CO9RNcQL0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=kernel.dk; spf=pass smtp.mailfrom=kernel.dk; dkim=pass (2048-bit key) header.d=kernel-dk.20230601.gappssmtp.com header.i=@kernel-dk.20230601.gappssmtp.com header.b=lN4/S6z7; arc=none smtp.client-ip=209.85.221.52
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=kernel.dk
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=kernel.dk
Received: by mail-wr1-f52.google.com with SMTP id ffacd0b85a97d-374c6187b6eso4686141f8f.0
        for <io-uring@vger.kernel.org>; Tue, 17 Sep 2024 23:16:45 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernel-dk.20230601.gappssmtp.com; s=20230601; t=1726640203; x=1727245003; darn=vger.kernel.org;
        h=content-transfer-encoding:in-reply-to:from:content-language
         :references:cc:to:subject:user-agent:mime-version:date:message-id
         :from:to:cc:subject:date:message-id:reply-to;
        bh=mIPhQLcvTE4j+71hp94TpiU+POERqSJhs24nbUaj6GI=;
        b=lN4/S6z7mQaK5vKh8F0fZmMOk4JaEwrDg4Omu4frLz9GvDPu7IMYiGPEJ5bPQna6+x
         CDxUFpuVxy6vJxpZcXFW223jat3nFVyADDoEwA1hr+A7mnPi9b1oSuCJCicFlghsCLn1
         H1wgc0GbRfw59taNgl9saqQMaXd6eDdvuwB2+5fgzkVkc5hFL0HOQNAxaR95J8ZPv7pu
         LHD4YWNgwN4cezYLGN5Bha29o4AWwedPH4fORVkoZt4/DaTNpYASsubOqapz5zq0z6RO
         HJhir+X6/gJWNBGAU3HyBJOh0jeudh+t7AjaM7xYBewuEWu8vy7hNSc0SqyGKh8gDvqu
         jRag==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1726640203; x=1727245003;
        h=content-transfer-encoding:in-reply-to:from:content-language
         :references:cc:to:subject:user-agent:mime-version:date:message-id
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=mIPhQLcvTE4j+71hp94TpiU+POERqSJhs24nbUaj6GI=;
        b=SeBQ3MFgBEnjECLFPaXseUYiwrSmV4/C3RoJo/uei38im8DIUWa7UUVkPe20MfU23P
         njaZUnqnGiHHEvbGHZX+ETPXE+74LNljatHvBKlvLT/4CA43L0wI4cH8d/V1Rs/P9dMx
         mYju8sQqQ2dN29ol8nI4GlLQsfy0SwsQzaXZppQC5wuwsG02Fuga3zU1N3QV1Fl6IgsQ
         6tdWloP8wSCrxGHcp7oFfVA34i/SdCdZVW/8ggLKjTA7qfnjTvhSefE6XZKwcuPOM6th
         xXoMJifDADZNXmSVZHX/QY8f3b4ovuz136YzdZhJKqo4p9i2eyRlFWOm3k5Inc9PpkrW
         AGDw==
X-Forwarded-Encrypted: i=1; AJvYcCX30oiQI2ZdcbyXDGbgH5vrHUYO/34CpiuuF6t+Vh5NRkC1hpHZozHPGSTJZsvPfd7Vk/4x5zK0hg==@vger.kernel.org
X-Gm-Message-State: AOJu0YzL8Uq2yV4X77IVMI+IgOyLLBYyVeV01Ng5oMaYVob8q3XzuCHK
	2oM9ZhxW9AFXCjhFpXqYfo63vXpXtCxnVLvCjh+xdI1mSSdeYkT+1dYDHNFp81E=
X-Google-Smtp-Source: AGHT+IF482qm71OBg3dA9iPtz3GXklywXbZ8iO2oGy5tKPfIAb/pGMdrJk3Kh+CMA8pz8uQTeQT01Q==
X-Received: by 2002:adf:9c09:0:b0:374:c3a2:2b5e with SMTP id ffacd0b85a97d-378c2d5b1cbmr10327577f8f.37.1726640203319;
        Tue, 17 Sep 2024 23:16:43 -0700 (PDT)
Received: from [192.168.0.216] ([185.44.53.103])
        by smtp.gmail.com with ESMTPSA id ffacd0b85a97d-378e78044easm11411043f8f.91.2024.09.17.23.16.41
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Tue, 17 Sep 2024 23:16:42 -0700 (PDT)
Message-ID: <5237b4c0-973f-44cc-a6ee-08302871fd19@kernel.dk>
Date: Wed, 18 Sep 2024 00:16:41 -0600
Precedence: bulk
X-Mailing-List: io-uring@vger.kernel.org
List-Id: <io-uring.vger.kernel.org>
List-Subscribe: <mailto:io-uring+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:io-uring+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH 1/1] io_uring/sqpoll: do not allow pinning outside of
 cpuset
To: "Lai, Yi" <yi1.lai@linux.intel.com>,
 Felix Moessbauer <felix.moessbauer@siemens.com>
Cc: asml.silence@gmail.com, linux-kernel@vger.kernel.org,
 io-uring@vger.kernel.org, cgroups@vger.kernel.org, dqminh@cloudflare.com,
 longman@redhat.com, adriaan.schmidt@siemens.com,
 florian.bezdeka@siemens.com, stable@vger.kernel.org,
 syzkaller-bugs@googlegroups.com, pengfei.xu@intel.com, yi1.lai@intel.com
References: <20240909150036.55921-1-felix.moessbauer@siemens.com>
 <ZupPb3OH3tnM2ARj@ly-workstation>
Content-Language: en-US
From: Jens Axboe <axboe@kernel.dk>
In-Reply-To: <ZupPb3OH3tnM2ARj@ly-workstation>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit

On 9/17/24 9:56 PM, Lai, Yi wrote:
> Hi Felix Moessbauer,
> 
> Greetings!
> 
> I used Syzkaller and found that there is KASAN: use-after-free Read in io_sq_offload_create in Linux-next tree - next-20240916.
> 
> After bisection and the first bad commit is:
> "
> f011c9cf04c0 io_uring/sqpoll: do not allow pinning outside of cpuset
> "

This is known and fixed:

https://git.kernel.dk/cgit/linux/commit/?h=for-6.12/io_uring&id=a09c17240bdf2e9fa6d0591afa9448b59785f7d4

-- 
Jens Axboe

