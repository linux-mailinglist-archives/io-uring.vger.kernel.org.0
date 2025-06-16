Return-Path: <io-uring+bounces-8361-lists+io-uring=lfdr.de@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [139.178.88.99])
	by mail.lfdr.de (Postfix) with ESMTPS id 3E3F3ADB04D
	for <lists+io-uring@lfdr.de>; Mon, 16 Jun 2025 14:34:42 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id F03A93A263D
	for <lists+io-uring@lfdr.de>; Mon, 16 Jun 2025 12:34:14 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 65BF4292B20;
	Mon, 16 Jun 2025 12:34:26 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel-dk.20230601.gappssmtp.com header.i=@kernel-dk.20230601.gappssmtp.com header.b="O0Pqwt5J"
X-Original-To: io-uring@vger.kernel.org
Received: from mail-il1-f180.google.com (mail-il1-f180.google.com [209.85.166.180])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id CE5C52E425D
	for <io-uring@vger.kernel.org>; Mon, 16 Jun 2025 12:34:22 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.166.180
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1750077266; cv=none; b=s6SjHM/si6gbHbCLs6/RNYMKE8Wz7yV59cUbNSHt3iE+kcICQsekTjcL/Ep+v9B25I8LTntA/DIhh/sClWEfb5M45rvcktTxwEYpMUUMwPWUzKOuVey8VfuV+q9IJQ4c17PXy/d2OxlMZz5+t2X0/GfI5GVELJKAAIRsKfMmiBI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1750077266; c=relaxed/simple;
	bh=iOxXgpbgbKQNWWv+0K9j7MipD/jLCyGG02Q51e5oS/4=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=mvB2aMzEhvwOxjn1bzyFrqm7SEduvxbSHhayPlQqspDFmqjeyc67GjUczFKFyEYd5LNpCDhGw0hAhxRGhhp6YZZr4Y60HQxfQJQrFhwO/SRgIG+1przfDTjEsUXmRD8cEaUrQot7/FJ2X+lkdBykE/UHbnTDfbSQjVoyTppmA+M=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=kernel.dk; spf=pass smtp.mailfrom=kernel.dk; dkim=pass (2048-bit key) header.d=kernel-dk.20230601.gappssmtp.com header.i=@kernel-dk.20230601.gappssmtp.com header.b=O0Pqwt5J; arc=none smtp.client-ip=209.85.166.180
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=kernel.dk
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=kernel.dk
Received: by mail-il1-f180.google.com with SMTP id e9e14a558f8ab-3d948ce7d9dso19422605ab.2
        for <io-uring@vger.kernel.org>; Mon, 16 Jun 2025 05:34:22 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernel-dk.20230601.gappssmtp.com; s=20230601; t=1750077261; x=1750682061; darn=vger.kernel.org;
        h=content-transfer-encoding:in-reply-to:from:content-language
         :references:cc:to:subject:user-agent:mime-version:date:message-id
         :from:to:cc:subject:date:message-id:reply-to;
        bh=5vUM3QP1f/1D93oHDHZPj4RHdna7ropl9QdY0f7aLmY=;
        b=O0Pqwt5Jof7milvRna4m4gzPZ8rFsGzGN3WKuacOgckxXoTQNExCsSjb/GSybONh7M
         vphtSj0BTXg+Tnk3qD2lD4v1h/FDDHCgM8xnXBYN/Mk4tSOuYuQSMU29K8GzpkvpyvO5
         ScRF8kClp4ZVQNimZuxRT7zhCP51ViECpwhDkD+fI5bSgSiNnlUNq1fxChkFPf+s+e6T
         KNnzZutiTs3azq6U+nyF9K5AdlGGsbhmv52B0DDg4Wq4EJSvkQmMb1CJ6JYCo3QQGYNW
         Aw1TdThaHLw1+DBK0rLqEE02yBuNXFO6r/XlF0/bpxRn6ma+mx1948Uwnnmt1GdT71wT
         dGLg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1750077261; x=1750682061;
        h=content-transfer-encoding:in-reply-to:from:content-language
         :references:cc:to:subject:user-agent:mime-version:date:message-id
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=5vUM3QP1f/1D93oHDHZPj4RHdna7ropl9QdY0f7aLmY=;
        b=GHcq9TwFuLrOClGwsAgIezKJAFYRC5FhhrhxgejBx4cFH8aUtXOlAL5lPtSg5lBwxv
         pbFDy2Qjxh5Ckk8IL/bkn+jPaLVK6VjfpNB4beovCK2CFE83/0t7/rtuEye9yi7boSVr
         6CUcr0lfP+4M2CLJ6y31Ufc1TIsiUEtMJEQDM/aj7pvlfnaynIH0doEjPHyhWhI85lgh
         38M+qZrhCwKenQPWdEJXZNWbjvLL7lsN388vJ9WJmxivDSC47/8P7zVdIV+CDGNf2zfP
         6+Lvcnigkhoe4alwRL6fXJAaXmZMcgm4y3cX1RtnUibXE3AtaA9gmiFhbn0JkTLhFn5P
         YXUQ==
X-Gm-Message-State: AOJu0YwErvD7FxHzgVywtLUBARjoibLkfeIK71T2pQSWlSEgFgmxayhh
	K1HHxYeBCw/DzKnBcU9HoPF6LXWOWFiUBruWT/QblXsNzR0tbSpznt3jU35jFiYpLc5QcKbgeYl
	lj8Lr
X-Gm-Gg: ASbGncu9HPk2kWDmgJKvQ1tcr6CU/Lhtzzil0r7vn5tSzeAKrNVJpfrd+GVv7XHFFg5
	hDJvBiVm1jIWbSfnvNnpsn6yqPpp1ZEocpdN1084yptvVbYVKTe/JiQRzt5wCQUCg22ljnJ7DDn
	8/8rl/Wt/gTACgs6fUIijkwUweReaietG1pNFSeyAlc8Q3tQROVZaWXrXmYX1nHgy88fuWI9Ijp
	/ZxfvPOU4eTIKjAPgJ/0IqZaSYuUDVxPMaXB85YrEXEnADaFkLr1lYZCo/hVLvweKJcbxO7vAj/
	p6f9vSVdjLXmxzlEkuaX4uwtpu97bLxIgGZnFlDFzDOld2ynGqe5Lq7Vsw0=
X-Google-Smtp-Source: AGHT+IEV799uVH/3utWh0yZsgindewiYcYwS8UtaYAlzimn+rfx5E/rMP1WFrnQK7gX0j4vcnaTdug==
X-Received: by 2002:a05:6e02:1a26:b0:3dd:b4b5:5c9f with SMTP id e9e14a558f8ab-3de07d1fb74mr97507645ab.19.1750077261246;
        Mon, 16 Jun 2025 05:34:21 -0700 (PDT)
Received: from [192.168.1.150] ([198.8.77.157])
        by smtp.gmail.com with ESMTPSA id 8926c6da1cb9f-50149b7accbsm1707391173.17.2025.06.16.05.34.20
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Mon, 16 Jun 2025 05:34:20 -0700 (PDT)
Message-ID: <1198c63d-4fe8-4dda-ae9f-23a9f5dafd5c@kernel.dk>
Date: Mon, 16 Jun 2025 06:34:20 -0600
Precedence: bulk
X-Mailing-List: io-uring@vger.kernel.org
List-Id: <io-uring.vger.kernel.org>
List-Subscribe: <mailto:io-uring+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:io-uring+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: Building liburing on musl libc gives error that errno.h not found
To: =?UTF-8?Q?Milan_P=2E_Stani=C4=87?= <mps@arvanta.net>
Cc: io-uring@vger.kernel.org
References: <20250615171638.GA11009@m1pro.arvanta.net>
 <b94bfb39-0083-446a-bc76-79b99ea84a4e@kernel.dk>
 <20250615195617.GA15397@m1pro.arvanta.net>
Content-Language: en-US
From: Jens Axboe <axboe@kernel.dk>
In-Reply-To: <20250615195617.GA15397@m1pro.arvanta.net>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit

On 6/15/25 1:56 PM, Milan P. Stani? wrote:
> On Sun, 2025-06-15 at 12:57, Jens Axboe wrote:
>> On 6/15/25 11:16 AM, Milan P. Stani? wrote:
>>> Hi,
>>>
>>> Trying to build liburing 2.10 on Alpine Linux with musl libc got error
>>> that errno.h is not found when building examples/zcrx.c
>>>
>>> Temporary I disabled build zcrx.c, merge request with patch for Alpine
>>> is here:
>>> https://gitlab.alpinelinux.org/alpine/aports/-/merge_requests/84981
>>> I commented in merge request that error.h is glibc specific.
>>
>> I killed it, it's not needed and should've been caught during review.
>> We should probably have alpine/musl as part of the CI...
> 
> Fine.
> 
>>> Side note: running `make runtests` gives 'Tests failed (32)'. Not sure
>>> should I post full log here.
>>
>> Either that or file an issue on GH. Sounds like something is very wrong
>> on the setup if you get failing tests, test suite should generally
>> pass on the current kernel, or any -stable kernel.
>>
> I'm attaching log here to this mail. Actually it is one bug but repeated
> in different tests, segfaults

Your kernel is ancient, and that will surely account from some of the
failures you see. A 6.6 stable series from January 2024 is not current
by any stretch, should definitely upgrade that. But I don't think this
accounts for all the failures seen, it's more likely there's some musl
related issue as well which is affecting some of the tests.

-- 
Jens Axboe

