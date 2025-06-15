Return-Path: <io-uring+bounces-8349-lists+io-uring=lfdr.de@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [139.178.88.99])
	by mail.lfdr.de (Postfix) with ESMTPS id 5FA8EADA311
	for <lists+io-uring@lfdr.de>; Sun, 15 Jun 2025 20:57:56 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 5144F3AF7FA
	for <lists+io-uring@lfdr.de>; Sun, 15 Jun 2025 18:57:32 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 842EF1E89C;
	Sun, 15 Jun 2025 18:57:52 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel-dk.20230601.gappssmtp.com header.i=@kernel-dk.20230601.gappssmtp.com header.b="KJaaHlN/"
X-Original-To: io-uring@vger.kernel.org
Received: from mail-io1-f42.google.com (mail-io1-f42.google.com [209.85.166.42])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 87E662620CB
	for <io-uring@vger.kernel.org>; Sun, 15 Jun 2025 18:57:48 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.166.42
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1750013872; cv=none; b=OHnaZiX+w9W+ni4ixPLF8nBR5NOsA/qtsMDCSOAxHQ0AgmifNm0dO6cb9WK1K83ppbiBTSZ0GSodz+Fx0kkr8TtZVA3JTOEuBjChdt6lb+u20Ka4z6cOxVLIux0JR64aq0ThdyxnRPRY9ydyr9JfX14gmvkwKQotsrlufPxvRa4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1750013872; c=relaxed/simple;
	bh=Kl1bfHKhe0GNgjQXBfGk9CfGqo+ScF5X6Ha7cAcjHYs=;
	h=Message-ID:Date:MIME-Version:Subject:To:References:From:
	 In-Reply-To:Content-Type; b=rlPO7sLsrftL7KmKn70cXFRlCju4cvqU1TmqreOLbI/VsLJG1kHvuoMCW9fQTCg+qeuX3h4PKRZWfoD7kmtYAA6LNXbOI27p/C6NryEgSJgB7h20Wik/YnP6cOlVfyRJwOKN1TGzdnFFs6bsEYDPhGmpe+fHCRGYHok9m9ErdZU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=kernel.dk; spf=pass smtp.mailfrom=kernel.dk; dkim=pass (2048-bit key) header.d=kernel-dk.20230601.gappssmtp.com header.i=@kernel-dk.20230601.gappssmtp.com header.b=KJaaHlN/; arc=none smtp.client-ip=209.85.166.42
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=kernel.dk
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=kernel.dk
Received: by mail-io1-f42.google.com with SMTP id ca18e2360f4ac-86a052d7897so365081039f.0
        for <io-uring@vger.kernel.org>; Sun, 15 Jun 2025 11:57:48 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernel-dk.20230601.gappssmtp.com; s=20230601; t=1750013867; x=1750618667; darn=vger.kernel.org;
        h=content-transfer-encoding:in-reply-to:from:content-language
         :references:to:subject:user-agent:mime-version:date:message-id:from
         :to:cc:subject:date:message-id:reply-to;
        bh=4cmnjOnB4eKMFAUmcrkXX/oulXTR5qwKTi4w6VRqjb0=;
        b=KJaaHlN/7sXWxDxypwPJhL04oVrlXQnsZN4OQBmVQjVyfAOjV5VdpOw88oisTxGpJY
         ljzn3qFHEnnob/YkA9HUWhc2Cor6ndgkVEkcWYQpmJOACw3I1DPwu7M4ABqhcX0I0JeD
         yPr5LTnuFgl6/416y9cK2Vomdls04knhLV0UtofhFR1k6ikiazcDcGhomqXlB/q/9UXY
         je4ihuZrB9ImXzdBfT6oOUKmsYESW71Afa4MSUishRLu/XsNmQpuGjkkRSITriXAhBfg
         Rr1pdZRgUdq76KzWJZCsAA/xqU/MB42xLtNREdz7BDq7MqexRmNGr/VQV6I7+XKNrFNc
         SQoQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1750013867; x=1750618667;
        h=content-transfer-encoding:in-reply-to:from:content-language
         :references:to:subject:user-agent:mime-version:date:message-id
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=4cmnjOnB4eKMFAUmcrkXX/oulXTR5qwKTi4w6VRqjb0=;
        b=PMkDfOSIKLBd54UDVWfZc3qZ26T87niddJKukfBawiIRzaMCXztEIPEFCXzUrwpse+
         RTkbOg3NSNPRAnAgKkmAiRjNqO/HUL0+01x0XMht3xU5sj5JnJWlvpJPC2JAnzocIN7h
         G/2Hj1ALlySfD4cV/1etcCKH9j1n5IpStmmzFuPm+BLLQeCL7jm7ehWGZdHJvWi46dl7
         McK/2bkEeWCzLZsi1BEVaEUGuDLvraSyijcGb2vB7PuSbeyi2faLA3TZ7eSg7NV2Nfx7
         lKHzI96vuJUOOeDO9yBstZd4JSgT9xuVhu02uduPDypBEP64m75qiWs3XdnbmF0EOcTn
         sO+w==
X-Forwarded-Encrypted: i=1; AJvYcCWNwRG0zZM1GkUMHntID+lbgRn2tQJWkmdOYlcSA1q7jLnI/3cuuW7uoU3NBnkFMOTzpnBdLIA99A==@vger.kernel.org
X-Gm-Message-State: AOJu0YwjsiM5bwCeknAne+3wGQY4I9J/4sKmi5sR0aUwvWU6M8lSBPCs
	nQPk+QMs5K+Ht9AQlYf8oHyss4hhOnipjHqMPjpwvxRDFiuRA/1U3uo7ZNAWuYscwvZKOkRHzUq
	70PUt
X-Gm-Gg: ASbGnctd+096Ua6BBc3gIttCyOosilY4GIwO6jAlzibfZqlFXe0+Te1kE+NaWU+drR1
	YfQ8Eic4dttqqsnQBiCQ7s+aoA7IzFTbDk/ADtgUvVZpWEuvKou/ckJYPMfRziPe5B9OoI/9tYz
	/Y3xTKYvhNyOIZaa+bEkDi/SNBgHAjN/n5oYvRgChuTqYHjDgpa2CtzvLw5tulUBgBWn5p0HaY+
	l/b/LuVvMSYJPFj46voLWYAwCVU54r30Go9JOfXTBCZQQnw/3kViFsuDhwNap7xRtc+yXxH4gDc
	7ZhYGL86mIVUhw7EinxQp6IFHel4TKDLbo4hbBEAVfto/cH/yo+29PzoPjo=
X-Google-Smtp-Source: AGHT+IFQ6vXTkIi9rYl7ZTIRnrWkA4g0VrsKAbizGz2LiRpY6VUiO3fvlrqvTWHi+031Nlj1qKD6kQ==
X-Received: by 2002:a05:6602:6d84:b0:875:bc13:3c26 with SMTP id ca18e2360f4ac-875dedc374amr831577339f.4.1750013867603;
        Sun, 15 Jun 2025 11:57:47 -0700 (PDT)
Received: from [192.168.1.150] ([198.8.77.157])
        by smtp.gmail.com with ESMTPSA id ca18e2360f4ac-875d570ed6fsm129256239f.3.2025.06.15.11.57.46
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Sun, 15 Jun 2025 11:57:46 -0700 (PDT)
Message-ID: <b94bfb39-0083-446a-bc76-79b99ea84a4e@kernel.dk>
Date: Sun, 15 Jun 2025 12:57:46 -0600
Precedence: bulk
X-Mailing-List: io-uring@vger.kernel.org
List-Id: <io-uring.vger.kernel.org>
List-Subscribe: <mailto:io-uring+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:io-uring+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: Building liburing on musl libc gives error that errno.h not found
To: =?UTF-8?Q?Milan_P=2E_Stani=C4=87?= <mps@arvanta.net>,
 io-uring@vger.kernel.org
References: <20250615171638.GA11009@m1pro.arvanta.net>
Content-Language: en-US
From: Jens Axboe <axboe@kernel.dk>
In-Reply-To: <20250615171638.GA11009@m1pro.arvanta.net>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

On 6/15/25 11:16 AM, Milan P. Stanić wrote:
> Hi,
> 
> Trying to build liburing 2.10 on Alpine Linux with musl libc got error
> that errno.h is not found when building examples/zcrx.c
> 
> Temporary I disabled build zcrx.c, merge request with patch for Alpine
> is here:
> https://gitlab.alpinelinux.org/alpine/aports/-/merge_requests/84981
> I commented in merge request that error.h is glibc specific.

I killed it, it's not needed and should've been caught during review.
We should probably have alpine/musl as part of the CI...

> Side note: running `make runtests` gives 'Tests failed (32)'. Not sure
> should I post full log here.

Either that or file an issue on GH. Sounds like something is very wrong
on the setup if you get failing tests, test suite should generally
pass on the current kernel, or any -stable kernel.

-- 
Jens Axboe


