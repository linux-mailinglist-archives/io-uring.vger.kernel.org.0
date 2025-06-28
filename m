Return-Path: <io-uring+bounces-8516-lists+io-uring=lfdr.de@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [IPv6:2604:1380:4601:e00::3])
	by mail.lfdr.de (Postfix) with ESMTPS id 471DEAEC54B
	for <lists+io-uring@lfdr.de>; Sat, 28 Jun 2025 08:09:20 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id 23600188ACE3
	for <lists+io-uring@lfdr.de>; Sat, 28 Jun 2025 06:09:36 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id C842021C9E0;
	Sat, 28 Jun 2025 06:09:15 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="lNKQ5zRA"
X-Original-To: io-uring@vger.kernel.org
Received: from mail-ed1-f41.google.com (mail-ed1-f41.google.com [209.85.208.41])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1B8DC21FF25;
	Sat, 28 Jun 2025 06:09:13 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.208.41
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1751090955; cv=none; b=mFY/dGiPXPl/KCqOq5KWyAB7AEhvt3qjbrl2dlh/ppXKInS3feWaq72AFcvLoeoiLsyI5tr5yLq24Z98zOf2/BJCnfSDvftMtDIpxLCpVUB5OE0AUcZEfp1RsMxqZop3P4LUAm2TyyEeuJcMYnWoEJSUyUCXzKDChnMVeWEycoI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1751090955; c=relaxed/simple;
	bh=84pvm5Mnq9YsCdw62ki+3MLvyyjnuFdS03yKYpgzpHM=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=fELR/bJYLsFalHdQipmvIawiLpdHMDON38CToH+cDjB+ymGNOfzDn1kcyB57/G8lcI7BOcWzZZ11YiN3Lcu803mIaBTvV85i+f/DGIm7oOtp9oKU/7PVZ4VQW7Ufv/uzcYUe+mcSY4yHWb/fc6uNTgowNw+EROaENE+ot1nKYJ0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=lNKQ5zRA; arc=none smtp.client-ip=209.85.208.41
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Received: by mail-ed1-f41.google.com with SMTP id 4fb4d7f45d1cf-60c4521ae2cso5210969a12.0;
        Fri, 27 Jun 2025 23:09:13 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1751090952; x=1751695752; darn=vger.kernel.org;
        h=content-transfer-encoding:in-reply-to:from:content-language
         :references:cc:to:subject:user-agent:mime-version:date:message-id
         :from:to:cc:subject:date:message-id:reply-to;
        bh=Ltk1TzaY6k6pKdbjauwlCcf5/+jayx56XkBsjqMYFvs=;
        b=lNKQ5zRAX0bbNExhMYukOHiRLHRMtWQH1uaDVXgCUrplH+cEJ4DQitL6efeycbUjJU
         LTsuakB4tjpRDzJYgxRWwuq6Sd81Tvsw79o/JEhh158kt0H9Dx16vo5ujYX3WmJLATHQ
         tSrsj/ixrDqVqh6UPESmWTcvj9YHDexz3MFUkTSawEbFSIpeGp4O2GQkrEaQT3yowtYf
         Zyuv2IS4WaE+1hDRbjuqssUD+Ipr4anj++GY+DJnA1Qk21uojcujks5zVPG98UuwgI6L
         qjww2B91V2RaU21rBgfCuel0ordgoxlPRjz57Z3nZvvfY7tanQ0GKN6x/7+5NLbk6fD3
         cjGQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1751090952; x=1751695752;
        h=content-transfer-encoding:in-reply-to:from:content-language
         :references:cc:to:subject:user-agent:mime-version:date:message-id
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=Ltk1TzaY6k6pKdbjauwlCcf5/+jayx56XkBsjqMYFvs=;
        b=XXJ8rVN6XXoQEasuzAWZJTZptJxSlubuSylvA4IYGjzJT68fSv0DTeW1qz/iCjUPIG
         fawRGWMaWsu/FZkG3y7oJf4V14bo9u9GIMY8+n6ocwn8UaXkpqDA5bSkXR9qkjwaZCjl
         ZubU+Vg52BfkTSYHB1StL/TKWIRH1qvLggybvCcgjWgdguBRwQEOkJCY6PuRlIPo6Ujf
         UEfrSoAw+vXWI/yhh2N/rJ82RL+hI+g6h7w1cI9MtjCljBYFKJcSE8zks2XjVUgTVpN1
         qlvEsqfp51cNbU64djQvWRgtQqr7DAH/4h63lc0EeCOt8rIH5V9XxeNW6PHgW/AvGdui
         MeiA==
X-Forwarded-Encrypted: i=1; AJvYcCUO79GyMW632lXwjR3uNX8g2c2mJoxkpFuu+08U6fSw2r5F7QHlotFn7AlEpkpIYAYt9f6taUnDbg==@vger.kernel.org
X-Gm-Message-State: AOJu0YwUky4Y6kX46ykXJd8dIYY/+nWKpm3A5+PHFsO4hjPbqYraTUtj
	yopco6QlOYMG2gKVRS4z4+1df2Kgb4pyAmCqNg9AiBOem2vz2kQN3WR5
X-Gm-Gg: ASbGncuECivAtcEoUAqASGcPYcxj109O6XQici4MjrIULmKB79MaGecJa4asgJvS7pc
	X65VuTSNbA3NYWbtNZ77E8/ZG+5yPrt1WKAKO711lZSihYvLSvYcZc6vcfitaHAwDEL2fTHYuL+
	Nu37pjhEqTWshrf0DMAoPxUWQRbp8EkHCp4ynkjUxfpXsPRWcfzNbMNF7U+soA3YPkSKRFFLuS1
	9WA8PXq8y36SOgBUf2JY6YByArd0LdY7uEtZf5g1pPP1EBEl4Dd8NUNKfsPL+2ATyQkgZRUFQyf
	vphQGzV7CS7VgnVfZR0ayBF3bdQ2i15+cQIoFkeOFxotXVr/Z8RzzWjd6F3UwTEJe7SMk0dv
X-Google-Smtp-Source: AGHT+IHtCKPUXPtDVjQl2CIBDxhzzZ75sdH4EGAh+qSXZjafoPEMpIf+xZXpEjm6sM9tk2COsGtFVA==
X-Received: by 2002:a17:907:944e:b0:ad5:4806:4f07 with SMTP id a640c23a62f3a-ae34fd4476emr568552266b.2.1751090952250;
        Fri, 27 Jun 2025 23:09:12 -0700 (PDT)
Received: from [192.168.8.100] ([148.252.147.134])
        by smtp.gmail.com with ESMTPSA id a640c23a62f3a-ae353ca1d1asm251543666b.154.2025.06.27.23.09.10
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Fri, 27 Jun 2025 23:09:11 -0700 (PDT)
Message-ID: <cf277ccc-5228-41dc-abd5-d486244682dd@gmail.com>
Date: Sat, 28 Jun 2025 07:10:36 +0100
Precedence: bulk
X-Mailing-List: io-uring@vger.kernel.org
List-Id: <io-uring.vger.kernel.org>
List-Subscribe: <mailto:io-uring+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:io-uring+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: (subset) [PATCH v5 0/5] io_uring cmd for tx timestamps
To: Jens Axboe <axboe@kernel.dk>, io-uring@vger.kernel.org,
 Vadim Fedorenko <vadim.fedorenko@linux.dev>
Cc: netdev@vger.kernel.org, Eric Dumazet <edumazet@google.com>,
 Paolo Abeni <pabeni@redhat.com>, Willem de Bruijn <willemb@google.com>,
 "David S . Miller" <davem@davemloft.net>, Jakub Kicinski <kuba@kernel.org>,
 Richard Cochran <richardcochran@gmail.com>,
 Stanislav Fomichev <sdf@fomichev.me>, Jason Xing
 <kerneljasonxing@gmail.com>, Kuniyuki Iwashima <kuniyu@google.com>
References: <cover.1750065793.git.asml.silence@gmail.com>
 <175069088204.49729.7974627770604664371.b4-ty@kernel.dk>
 <a3e2d283-37cd-4c96-ab0b-dfd1c50aae61@kernel.dk>
Content-Language: en-US
From: Pavel Begunkov <asml.silence@gmail.com>
In-Reply-To: <a3e2d283-37cd-4c96-ab0b-dfd1c50aae61@kernel.dk>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit

On 6/27/25 18:07, Jens Axboe wrote:
> On 6/23/25 9:01 AM, Jens Axboe wrote:
>>
>> On Mon, 16 Jun 2025 10:46:24 +0100, Pavel Begunkov wrote:
>>> Vadim Fedorenko suggested to add an alternative API for receiving
>>> tx timestamps through io_uring. The series introduces io_uring socket
>>> cmd for fetching tx timestamps, which is a polled multishot request,
>>> i.e. internally polling the socket for POLLERR and posts timestamps
>>> when they're arrives. For the API description see Patch 5.
>>>
>>> It reuses existing timestamp infra and takes them from the socket's
>>> error queue. For networking people the important parts are Patch 1,
>>> and io_uring_cmd_timestamp() from Patch 5 walking the error queue.
>>>
>>> [...]
>>
>> Applied, thanks!
>>
>> [2/5] io_uring/poll: introduce io_arm_apoll()
>>        commit: 162151889267089bb920609830c35f9272087c3f
>> [3/5] io_uring/cmd: allow multishot polled commands
>>        commit: b95575495948a81ac9b0110aa721ea061dd850d9
>> [4/5] io_uring: add mshot helper for posting CQE32
>>        commit: ac479eac22e81c0ff56c6bdb93fad787015149cc
>> [5/5] io_uring/netcmd: add tx timestamping cmd support
>>        commit: 9e4ed359b8efad0e8ad4510d8ad22bf0b060526a
> 
> Pavel, can you send in the liburing PR for these, please?

It needs a minor clean up, I'll send it by Monday

-- 
Pavel Begunkov


