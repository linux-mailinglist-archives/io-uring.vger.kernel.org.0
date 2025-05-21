Return-Path: <io-uring+bounces-8067-lists+io-uring=lfdr.de@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from sy.mirrors.kernel.org (sy.mirrors.kernel.org [IPv6:2604:1380:40f1:3f00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id E6229ABF861
	for <lists+io-uring@lfdr.de>; Wed, 21 May 2025 16:55:39 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sy.mirrors.kernel.org (Postfix) with ESMTPS id 4EF9D7AEC0A
	for <lists+io-uring@lfdr.de>; Wed, 21 May 2025 14:54:22 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 156C11DE8A8;
	Wed, 21 May 2025 14:51:45 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel-dk.20230601.gappssmtp.com header.i=@kernel-dk.20230601.gappssmtp.com header.b="VnEKS5DR"
X-Original-To: io-uring@vger.kernel.org
Received: from mail-io1-f53.google.com (mail-io1-f53.google.com [209.85.166.53])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4ED711EF37A
	for <io-uring@vger.kernel.org>; Wed, 21 May 2025 14:51:42 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.166.53
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1747839105; cv=none; b=LD4B0SctvilVu98cIoN6/alkBZx2IBQW+rFC2FYkmLJMQPB2RF1MmAhvl+sNAbzfKz55eig98+0eR6A7ECngFWKvVB+rK00NpJSq+MnO/dZb4w3B7lceMWnE/VcZZjg8MHEcpnE2p1RKM20H89924yOU1AWmoVb9pE4l+5O9fMI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1747839105; c=relaxed/simple;
	bh=BlrHoDcwyPhhIG3XOTYRBoSM5eEThezzITVgnB977Bw=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=JyJevbvvcqW5WwcMJuDibRUpS2wV1avWBnE2a5IdFSFWELR0w507SMueKKLkpsaq6syKr05vZYL/WPYFOjNkArqJ/0MiLS+g0o6L5UZ8nh1dhyB3kGVWGhkiFttv1JMHgmAwKeF6IOt1NH1BgvJb6nXmgLkCKsaBpgZUPYMivMc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=kernel.dk; spf=pass smtp.mailfrom=kernel.dk; dkim=pass (2048-bit key) header.d=kernel-dk.20230601.gappssmtp.com header.i=@kernel-dk.20230601.gappssmtp.com header.b=VnEKS5DR; arc=none smtp.client-ip=209.85.166.53
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=kernel.dk
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=kernel.dk
Received: by mail-io1-f53.google.com with SMTP id ca18e2360f4ac-86135af1045so832758639f.1
        for <io-uring@vger.kernel.org>; Wed, 21 May 2025 07:51:42 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernel-dk.20230601.gappssmtp.com; s=20230601; t=1747839099; x=1748443899; darn=vger.kernel.org;
        h=content-transfer-encoding:in-reply-to:from:content-language
         :references:cc:to:subject:user-agent:mime-version:date:message-id
         :from:to:cc:subject:date:message-id:reply-to;
        bh=zp9tdkPv2eih2YNuSyjkTHY6aUxas45ukA9X4382OwI=;
        b=VnEKS5DRA7Qzs72SAKParSm9kgbAMHc1oxTpDSIuRS2hFWJ4vxqx9H4fnSObwmrzhk
         LU8JcCkoUgkS8nb5QDRab/AsM69Y0t17Ec8HACYQhzJOkzwLA3+0DdwiigJ1DH5fd2n9
         70PAKwbI0E3Sors2MpMCtGx76rYZbkplRpdz8yoL4HmbhwBCWrpBYKTEQXPm/DC5RACM
         9F0bWVvBRfiXR7Kef2Rv+B4NnpIKmr3SUJznaF84lMPlkc+7akqlCQ0RhI4LOdiRX2Dc
         2H4z0s/4l/f7Gzb2BHfWNMIvcIJMO6eoUjy+gayrUt6ivseUtSu6opXmt+IEkp88FAzq
         0DGw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1747839099; x=1748443899;
        h=content-transfer-encoding:in-reply-to:from:content-language
         :references:cc:to:subject:user-agent:mime-version:date:message-id
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=zp9tdkPv2eih2YNuSyjkTHY6aUxas45ukA9X4382OwI=;
        b=SaysDOO1TJ7zsuo9rnlevmL3fOEdvZoz1CdHFapwy2jof42l5VV3yzhbePZBvlH7aF
         E7SCo/b9IWV7EwuYEEjNbu7jwDtF29RUMQWBpnWlo85klzPmCleO79rrxtc2TX3gUmhv
         Iws0lQHW/LuC7LVEpoX2vSpLIuCJqW7GqW7/c+aj0peN43X67YEk6sD8JZNlQevJIoK+
         UCsWsPLHZzAeIcS20hMRdUw82Shtuo4nTv1W52a8BrnJNjAs0cLAhC4mljFEs5XXe1eX
         DbwoCrKpau2Ko8XHlyehj2iV2NfXYsGIug7L4nmoGXBjOWDUwvwuWmntGLoYI8aVC6sa
         6jeg==
X-Forwarded-Encrypted: i=1; AJvYcCUarEVYvQ3ODv2JvXO6xULr6H9xP4fpjf7sQvAar7ARUrkzb7wKUMNaOkPaEG6zXpn6RFTXYefmUQ==@vger.kernel.org
X-Gm-Message-State: AOJu0YzZ9RK1r65w6+olJwyf4MRtltg/SDw8EL8XH3BxyFS7uzQgbuUg
	d29LO7i0HdJ39BYzmMGxSvCLwbI/78wTauTHrxNlwD5L31YVGMizz2cT2+33eojSwZs=
X-Gm-Gg: ASbGncu5vK0C6wT1KK3lSzWxvj/byYxOX3VVjhggn58XFiFLCiGszG8EjtXXa+lUxh2
	WJUB3JvL5YBhwFpAp8fx3geKG6nyibwb2hX/0qcF8/rrmkfSyc7qns6sovCFpTb8/XSwDIUJg9q
	fxYC1LwjZ5e8snWOyiHEt8y76hUxcNU/j8+AJ945uB7bBvVXbMrfg2WBp3lkMvXqBEyIQw1zrAk
	uBV9b3QbNdW8EGSlg3SCND0Sr3Pd2R/OeIBbgcoMK5vtrhRD2zGOwTBkNVkvI6WvYqTLUGi/7DQ
	6JouEQ3Xk4Ed4LA5SEqcTKliUempBNwHpGs+b2jX7xC/RuyoGfPwtg6pww==
X-Google-Smtp-Source: AGHT+IEww2FwR7xZUDXm86LwiWqZ7mnSik6KAV8vyyoBSwgTY0Q2hUUV0dAh+C3x3KvbNSCX4UTyKQ==
X-Received: by 2002:a05:6602:370a:b0:85d:a5d3:618c with SMTP id ca18e2360f4ac-86a2323e04fmr2801574139f.11.1747839099346;
        Wed, 21 May 2025 07:51:39 -0700 (PDT)
Received: from [192.168.1.116] ([96.43.243.2])
        by smtp.gmail.com with ESMTPSA id 8926c6da1cb9f-4fbcc4b3b55sm2672877173.131.2025.05.21.07.51.38
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Wed, 21 May 2025 07:51:38 -0700 (PDT)
Message-ID: <1e1b9b3a-6663-4ede-8066-6ba7c061d7f6@kernel.dk>
Date: Wed, 21 May 2025 08:51:38 -0600
Precedence: bulk
X-Mailing-List: io-uring@vger.kernel.org
List-Id: <io-uring.vger.kernel.org>
List-Subscribe: <mailto:io-uring+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:io-uring+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH liburing] test/io_uring_passthrough: add test for vectored
 fixed-buffers
To: Pavel Begunkov <asml.silence@gmail.com>,
 Anuj gupta <anuj1072538@gmail.com>
Cc: Anuj Gupta <anuj20.g@samsung.com>, io-uring@vger.kernel.org,
 joshi.k@samsung.com
References: <CGME20250521083658epcas5p2c2d23dbcfac4242343365bb85301c5ea@epcas5p2.samsung.com>
 <20250521081949.10497-1-anuj20.g@samsung.com>
 <7e846c8a-3506-4581-bbc5-fdf9e084a5bf@gmail.com>
 <CACzX3Av3G1K0aoZXDOHjfT=Su6G9D-_RyKWjdMwsNpba8T7CFA@mail.gmail.com>
 <48319c53-9556-4a97-97b3-3530247b6046@gmail.com>
 <b4f0d0ef-b05f-4f40-bace-e7632293fbb6@kernel.dk>
 <5ec492a2-082d-4797-b231-088564d763a0@gmail.com>
Content-Language: en-US
From: Jens Axboe <axboe@kernel.dk>
In-Reply-To: <5ec492a2-082d-4797-b231-088564d763a0@gmail.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit

On 5/21/25 8:46 AM, Pavel Begunkov wrote:
> On 5/21/25 15:14, Jens Axboe wrote:
>> On 5/21/25 8:05 AM, Pavel Begunkov wrote:
>>>> About the use of io_uring_prep_read/write*() helpers ? you're right,
>>>> they don?t really add much here since the passthrough command handles
>>>> the fields directly. I?ll work on a cleanup patch to remove those and
>>>> simplify the submission code.
>>>
>>> I don't care about the test itself much, but it means there
>>> are lots of unused fields for the nvme commands that are not
>>> checked by the kernel and hence can't be reused in the future.
>>> That's not great
>>
>> It's still a pretty recent addition, no reason we can't add the checks
>> and get them back to stable as well. At least that would open the door
>> for more easy future expansion.
> 
> nvme passthrough? It has been around for a while
> 
> commit 456cba386e94f22fa1b1426303fdcac9e66b1417
> Author: Kanchan Joshi <joshi.k@samsung.com>
> Date:   Wed May 11 11:17:48 2022 +0530
> 
>     nvme: wire-up uring-cmd support for io-passthru on char-device.
> 
> 
> and if people followed the test for initialising sqes, it'll start
> failing for them.

Huh yes, that's older than I thought, we'd need to got back to 6.1
stable for that. Which isn't a huge deal, but also seems like the
risk would be too high at that point. Unfortunately lots of folks use
odd ball distro kernels that don't diligently pull stable fixes.

-- 
Jens Axboe

