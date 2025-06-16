Return-Path: <io-uring+bounces-8363-lists+io-uring=lfdr.de@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [147.75.199.223])
	by mail.lfdr.de (Postfix) with ESMTPS id 050D3ADB2C8
	for <lists+io-uring@lfdr.de>; Mon, 16 Jun 2025 16:00:07 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id AE88216212D
	for <lists+io-uring@lfdr.de>; Mon, 16 Jun 2025 14:00:07 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 8B94F1A4E9D;
	Mon, 16 Jun 2025 14:00:04 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel-dk.20230601.gappssmtp.com header.i=@kernel-dk.20230601.gappssmtp.com header.b="IhmK28yQ"
X-Original-To: io-uring@vger.kernel.org
Received: from mail-io1-f41.google.com (mail-io1-f41.google.com [209.85.166.41])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8D9E32877E4
	for <io-uring@vger.kernel.org>; Mon, 16 Jun 2025 14:00:01 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.166.41
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1750082404; cv=none; b=P2iuU3Ze6wOvMEtIu73KMlhLERqflC0Uqd/uOQZkxQ3GymFrq/7OSzVSxygCL1D+i0iVzKcT+VVGDm7+g1Gn9CLCXsg9+9BxwGa009RAZMS8cIsy6S1t4e8vAplnDVAu6oQ2K1ABG3vQUXymAYo1vMPJZiLKebpAY1Sig4Aw3m8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1750082404; c=relaxed/simple;
	bh=ULpuVY85CqT+PiWfeIyZ5VE86T34dmtz/kDiCgWRc3Y=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=giRkSgUR1+MWnSrCp5/9tImUF1l4/HJ9/A9KmiGTDahq7colhNti4dKQVJONGnvaT9N75ZfZCDQSOTYFsFxrzJvQeXospAgcUWibGPz34EVzymBCKui5RpEBDLifg1vX/9Qd61y6QRuY13/eczlBRemhiAkjjY6+eudgVjPTSaw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=kernel.dk; spf=pass smtp.mailfrom=kernel.dk; dkim=pass (2048-bit key) header.d=kernel-dk.20230601.gappssmtp.com header.i=@kernel-dk.20230601.gappssmtp.com header.b=IhmK28yQ; arc=none smtp.client-ip=209.85.166.41
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=kernel.dk
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=kernel.dk
Received: by mail-io1-f41.google.com with SMTP id ca18e2360f4ac-86a07a1acffso434037139f.0
        for <io-uring@vger.kernel.org>; Mon, 16 Jun 2025 07:00:01 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernel-dk.20230601.gappssmtp.com; s=20230601; t=1750082400; x=1750687200; darn=vger.kernel.org;
        h=content-transfer-encoding:in-reply-to:from:content-language
         :references:cc:to:subject:user-agent:mime-version:date:message-id
         :from:to:cc:subject:date:message-id:reply-to;
        bh=zzbZiofT3KI87mwOhP7nUinaTWBpm8wuI9ibHq0ZLas=;
        b=IhmK28yQXRnGdxwpFMsee5Q2irlUxujwUe4iiddkwHfTHn4OWtpphEwc5LIMpLlgNS
         2uJNHqTOnpVrShptW/qXPAems/XuRqD4cgCWYO4827gxjKUv1OaD1/u0H56u/bS/PBEb
         jmMtyVUaHC1mACOo4cD/Cuf+b6EmRdZ/KXWmyuPz1DD9jbsPvfgx7i4MZPDURjAKjwwj
         Rki1mCLFkyix8ZXqXgQCLn00N2dHTGEqfyCfY2ctW5vukyCSoV82Sgy2u85YMCEbdfS2
         i9uq8oMiTDm0CI9LvfG/S+YQJ76wNaOr1n2KQi+bVCwFD22KkjbpdJ7RFbRaneBdpPn3
         o9rQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1750082400; x=1750687200;
        h=content-transfer-encoding:in-reply-to:from:content-language
         :references:cc:to:subject:user-agent:mime-version:date:message-id
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=zzbZiofT3KI87mwOhP7nUinaTWBpm8wuI9ibHq0ZLas=;
        b=nRwtfrHrlmsFL5DBo0UtJgXj5XHgNwGGZbAhphFZltXpLf0EoNFM0JqnRN91sfIGcd
         ANHm73hI1edTl1rCrCUOnWiUdtVfy8HXXnA1a3vKb0W+XHufI+cme9X8YYE4ovCDf2+S
         +3Hc7Pozxz0ZI4CYkO4ORPBiSU0Y6ugrdckbUkfaIc1FcrypnxAT84f2uhDKWvMri+YO
         FIs1aqo6kiNAdq7wHOlPalHjWye6w66UoadNLbE/UIJnakaJgtSuv5qKtUGsUjx4kzDC
         K+Ac13NhZW6GRANw1R7zLl9nEdyPPuXqhxt2w3R9zb49fLRJU2IKe0gBDRhRY3UmUqOO
         RWmg==
X-Gm-Message-State: AOJu0Yz8N9d/vwy4S/EOZfyEfcdx1h57PObInB+k0QsgtAHCW8W1OsAE
	4EgYNjIjOVtf5uGTYYzx/1S0bUXigC19CZNm9NHIw/UATBePjCTmc8w1XZPkUhs9fciB9j+BF1b
	PrJB4
X-Gm-Gg: ASbGnctezGswaZhDw+sm8hbjbcTtt1PE6VV4FM3EJRVetf90B+lEjlHFbubsRz8fW6z
	y/6g7ZRtEhs+Se7EhEspXZPvQr0iYu+QiGW4UNegYuplVw7maD5gz9Rb+LPc30nCdKlq4LSwvp3
	Vf595Wf+EZ+9n7JClWM6HXUSlUJxXOp/8gzfbvfgSNZwnH2lsEaEKyCIj5nOwSxctuxp2rthRqt
	4vkRTizk+hdB8v8j3hf7FMadAFzvBYLBGHAQTRq8m5eV53tReycZHQRdqxenlCbTn40yc/qtsDx
	8Hkar2qQZGy0cMgvCnNrr29OfAmDeAT+eDH4E15LpMuROMiQiM874N4NWXc=
X-Google-Smtp-Source: AGHT+IF4LUJp1EH3LZg9LUFR9XsU2hMQYa2NNs1lo5xbjABHWuFAmYaf219UDPNkrcAQIcAhHLGE2g==
X-Received: by 2002:a05:6602:6419:b0:86c:f603:8907 with SMTP id ca18e2360f4ac-875ded8d795mr1069516139f.5.1750082400602;
        Mon, 16 Jun 2025 07:00:00 -0700 (PDT)
Received: from [192.168.1.150] ([198.8.77.157])
        by smtp.gmail.com with ESMTPSA id ca18e2360f4ac-875d57fec96sm179146739f.24.2025.06.16.06.59.59
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Mon, 16 Jun 2025 06:59:59 -0700 (PDT)
Message-ID: <39ae421b-a633-4b47-bf2b-6a55d818aa7c@kernel.dk>
Date: Mon, 16 Jun 2025 07:59:59 -0600
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
 <1198c63d-4fe8-4dda-ae9f-23a9f5dafd5c@kernel.dk>
 <20250616130612.GA21485@m1pro.arvanta.net>
Content-Language: en-US
From: Jens Axboe <axboe@kernel.dk>
In-Reply-To: <20250616130612.GA21485@m1pro.arvanta.net>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

On 6/16/25 7:06 AM, Milan P. Stanić wrote:
> On Mon, 2025-06-16 at 06:34, Jens Axboe wrote:
>> On 6/15/25 1:56 PM, Milan P. Stani? wrote:
>>> On Sun, 2025-06-15 at 12:57, Jens Axboe wrote:
>>>> On 6/15/25 11:16 AM, Milan P. Stani? wrote:
>>>>> Hi,
>>>>>
>>>>> Trying to build liburing 2.10 on Alpine Linux with musl libc got error
>>>>> that errno.h is not found when building examples/zcrx.c
>>>>>
>>>>> Temporary I disabled build zcrx.c, merge request with patch for Alpine
>>>>> is here:
>>>>> https://gitlab.alpinelinux.org/alpine/aports/-/merge_requests/84981
>>>>> I commented in merge request that error.h is glibc specific.
>>>>
>>>> I killed it, it's not needed and should've been caught during review.
>>>> We should probably have alpine/musl as part of the CI...
>>>
>>> Fine.
>>>
>>>>> Side note: running `make runtests` gives 'Tests failed (32)'. Not sure
>>>>> should I post full log here.
>>>>
>>>> Either that or file an issue on GH. Sounds like something is very wrong
>>>> on the setup if you get failing tests, test suite should generally
>>>> pass on the current kernel, or any -stable kernel.
>>>>
>>> I'm attaching log here to this mail. Actually it is one bug but repeated
>>> in different tests, segfaults
>>
>> Your kernel is ancient, and that will surely account from some of the
>> failures you see. A 6.6 stable series from January 2024 is not current
>> by any stretch, should definitely upgrade that. But I don't think this
>> accounts for all the failures seen, it's more likely there's some musl
>> related issue as well which is affecting some of the tests.
> 
> This happens also on 6.14.8-1 asahi kernel on apple m1pro machine.
> I forgot to mention this in previous mail, sorry.

Also on musl, correct?

Guessing it must be some musl oddity. I'll try and setup a vm with
alpine and see how that goes.

-- 
Jens Axboe


