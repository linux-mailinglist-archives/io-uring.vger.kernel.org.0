Return-Path: <io-uring+bounces-5998-lists+io-uring=lfdr.de@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [147.75.199.223])
	by mail.lfdr.de (Postfix) with ESMTPS id 668EBA15DB5
	for <lists+io-uring@lfdr.de>; Sat, 18 Jan 2025 16:43:55 +0100 (CET)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id 94DA4165299
	for <lists+io-uring@lfdr.de>; Sat, 18 Jan 2025 15:43:53 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 5FF9C19340E;
	Sat, 18 Jan 2025 15:43:52 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel-dk.20230601.gappssmtp.com header.i=@kernel-dk.20230601.gappssmtp.com header.b="YQxO+TcD"
X-Original-To: io-uring@vger.kernel.org
Received: from mail-il1-f177.google.com (mail-il1-f177.google.com [209.85.166.177])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 741A93398B
	for <io-uring@vger.kernel.org>; Sat, 18 Jan 2025 15:43:49 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.166.177
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1737215032; cv=none; b=KBiR47aeQAm2uAMIXtRDqHYwko/uWfKNVjoQc6N8pUOGFZ8T+WvTn3ybiuH2ZNJPr5Hx//4c/JH/Hk4KgKkUGCYh4Xb1ZAnv7pq3e9b1j9VqfG58UI5w4PrLEut4D09GO1eEmvKUl21TUdlo1FXpL7sNaV8TqZlcz+sNzcifunw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1737215032; c=relaxed/simple;
	bh=pe8wVn6KOFJNwW1fKMiJzVDGwT3JIS4QSIru+2pbNIg=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=g7OgrS1r3KL/Vnl6nHXz5JTRtWgGGLAakS4sC0TpTo95wH5RoS9/CzCEOhQp+DFl8wBmqZTj17d8yVNp68jttGaZBWB8MCjirJtIlqmmL19Jntjayqm9dAzPlNhDYK5HU1aLTl90UYlcWPggcRLWfLPpIARUgqRWWTLggADw9sE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=kernel.dk; spf=pass smtp.mailfrom=kernel.dk; dkim=pass (2048-bit key) header.d=kernel-dk.20230601.gappssmtp.com header.i=@kernel-dk.20230601.gappssmtp.com header.b=YQxO+TcD; arc=none smtp.client-ip=209.85.166.177
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=kernel.dk
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=kernel.dk
Received: by mail-il1-f177.google.com with SMTP id e9e14a558f8ab-3cf82bd380bso6049875ab.0
        for <io-uring@vger.kernel.org>; Sat, 18 Jan 2025 07:43:49 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernel-dk.20230601.gappssmtp.com; s=20230601; t=1737215028; x=1737819828; darn=vger.kernel.org;
        h=content-transfer-encoding:in-reply-to:from:content-language
         :references:cc:to:subject:user-agent:mime-version:date:message-id
         :from:to:cc:subject:date:message-id:reply-to;
        bh=hynII3O7AMbmTgLubudwmfVCpCJRn4h3x31zO+aCDv8=;
        b=YQxO+TcDTcOeG8NSjZsFZZnCys1Fm3DS521aV8oFUGvuE1g1wyx8+gH757asQv6W60
         efrGaKpY/cGLiBTLUfnbZ0wl7MbnA82A3NGVGCIxwrxyCLMpXB4k1azPF9S4oJ/SLsWa
         uF7phJ/xehyDbeQKEviDfuKCT+I9dwu3Vwurm1AiNMqoQfN7XwYvFvCqOr8VAm7Mvnbq
         6rS7C2HjRcracEQUUAn67yign4vRNOOZClo+v8zcsXkqb5W0/WSZGU2ytWvt/kAwkRu1
         XoF4y70pcrtAibeR9Ukq5I7PweZndaf5wqYOFIVl1yCTrr2MMESH7IsxTBmAt854YLR2
         3F8w==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1737215028; x=1737819828;
        h=content-transfer-encoding:in-reply-to:from:content-language
         :references:cc:to:subject:user-agent:mime-version:date:message-id
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=hynII3O7AMbmTgLubudwmfVCpCJRn4h3x31zO+aCDv8=;
        b=WPbmFNubdb0wZnaTegPF6chcqpOfwybxHxJUdpNeHnV2K3Vu4do64J4M/Syq6Juz+f
         nP396j9QepIcb6XaCcX8E0rOB6RY8iUG8R/4kjFBcdn9+8bnSiS4i19Cm+4CFUucN+wB
         BXCzSGQRdyzgn5hIUoRn6GAOHj0ADqOn52IonqkxybnUMK2ZE93bI3xemsPdDxYUG/Wn
         UaIcnAHX9ZcFMWOB8AQD51HNVVqH37r3U0BgMnRJm30Rff0+ux2gBtGUSeO8S2XI+22p
         Sd0gJTy5hiSF0yKXKT8tLNyTMKQn20Z4HAaY7Bzn3mF8QRm5YwXKbHNzj4SB21rUfCfr
         06Ng==
X-Gm-Message-State: AOJu0YwR2sKEdtXQMyiSuPChlngRo567J26R2/Z95enzihVOSZ1SIZSg
	IlK29JKFE/Q/y4U67aAAcuVuRao5yYipKwiS7Az0pJ1uw2sm3PbnH+wKM+jX5aA=
X-Gm-Gg: ASbGnctAdIYIkpzuGn25OPWgZJf0S1uC54aUBczzPPiFwKykj7kOn/Y67wf5RFJ2BfR
	yxBD2ntFxJACKiBnkE4A8VtyxwM2f0SIsu5LvI0HAn1ywMG87iOhx/F1dQb1hXm5YbjDKUov4IW
	1wo3mkteBL+4Q2qqiZa9/ZOLCgq6FDfQFYa7UoccuilcviFXmuAiFXP2Y2AOyFKCGzQxLhREd6O
	eDHzdoi4AR69tu9jCZYOvvoDprwmCQKqWQLe6TUU2KmGoT0QKOzrcOT6QA26xqLYyQ=
X-Google-Smtp-Source: AGHT+IHS6Aw0+192hTvw2L+pdkAnL1IlyzFFWnagChO1s/9EU873kgHs4g0QfavXFOSsWEbRwP01qA==
X-Received: by 2002:a05:6e02:1fcd:b0:3a6:ad61:7ff8 with SMTP id e9e14a558f8ab-3cf7442a567mr53811035ab.12.1737215028399;
        Sat, 18 Jan 2025 07:43:48 -0800 (PST)
Received: from [192.168.1.150] ([198.8.77.157])
        by smtp.gmail.com with ESMTPSA id 8926c6da1cb9f-4ea75441e06sm1246461173.55.2025.01.18.07.43.47
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Sat, 18 Jan 2025 07:43:47 -0800 (PST)
Message-ID: <1dc70b72-3eab-41bf-a430-229556c8a457@kernel.dk>
Date: Sat, 18 Jan 2025 08:43:46 -0700
Precedence: bulk
X-Mailing-List: io-uring@vger.kernel.org
List-Id: <io-uring.vger.kernel.org>
List-Subscribe: <mailto:io-uring+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:io-uring+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH] test/defer: fix deadlock when io_uring_submit fail
To: lizetao <lizetao1@huawei.com>, Pavel Begunkov <asml.silence@gmail.com>
Cc: "io-uring@vger.kernel.org" <io-uring@vger.kernel.org>
References: <77ab74b3fdff491db2a5596b1edc86b6@huawei.com>
 <70895666-4ec5-4a2e-a9c2-33c296087beb@kernel.dk>
 <e3567f48dad84d06bbca5d40d1ec79c0@huawei.com>
Content-Language: en-US
From: Jens Axboe <axboe@kernel.dk>
In-Reply-To: <e3567f48dad84d06bbca5d40d1ec79c0@huawei.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit

On 1/18/25 2:42 AM, lizetao wrote:
> Hi,
> 
>> -----Original Message-----
>> From: Jens Axboe <axboe@kernel.dk>
>> Sent: Thursday, January 16, 2025 10:51 PM
>> To: lizetao <lizetao1@huawei.com>; Pavel Begunkov <asml.silence@gmail.com>
>> Cc: io-uring@vger.kernel.org
>> Subject: Re: [PATCH] test/defer: fix deadlock when io_uring_submit fail
>>
>> On 1/15/25 6:10 AM, lizetao wrote:
>>> While performing fault injection testing, a bug report was triggered:
>>>
>>>   FAULT_INJECTION: forcing a failure.
>>>   name fail_usercopy, interval 1, probability 0, space 0, times 0
>>>   CPU: 12 UID: 0 PID: 18795 Comm: defer.t Tainted: G           O
>> 6.13.0-rc6-gf2a0a37b174b #17
>>>   Tainted: [O]=OOT_MODULE
>>>   Hardware name: linux,dummy-virt (DT)
>>>   Call trace:
>>>    show_stack+0x20/0x38 (C)
>>>    dump_stack_lvl+0x78/0x90
>>>    dump_stack+0x1c/0x28
>>>    should_fail_ex+0x544/0x648
>>>    should_fail+0x14/0x20
>>>    should_fail_usercopy+0x1c/0x28
>>>    get_timespec64+0x7c/0x258
>>>    __io_timeout_prep+0x31c/0x798
>>>    io_link_timeout_prep+0x1c/0x30
>>>    io_submit_sqes+0x59c/0x1d50
>>>    __arm64_sys_io_uring_enter+0x8dc/0xfa0
>>>    invoke_syscall+0x74/0x270
>>>    el0_svc_common.constprop.0+0xb4/0x240
>>>    do_el0_svc+0x48/0x68
>>>    el0_svc+0x38/0x78
>>>    el0t_64_sync_handler+0xc8/0xd0
>>>    el0t_64_sync+0x198/0x1a0
>>>
>>> The deadlock stack is as follows:
>>>
>>>   io_cqring_wait+0xa64/0x1060
>>>   __arm64_sys_io_uring_enter+0x46c/0xfa0
>>>   invoke_syscall+0x74/0x270
>>>   el0_svc_common.constprop.0+0xb4/0x240
>>>   do_el0_svc+0x48/0x68
>>>   el0_svc+0x38/0x78
>>>   el0t_64_sync_handler+0xc8/0xd0
>>>   el0t_64_sync+0x198/0x1a0
>>>
>>> This is because after the submission fails, the defer.t testcase is still waiting to
>> submit the failed request, resulting in an eventual deadlock.
>>> Solve the problem by telling wait_cqes the number of requests to wait for.
>>
>> I suspect this would be fixed by setting IORING_SETUP_SUBMIT_ALL for ring init,
>> something probably all/most tests should set.
> 
> 
> I tested it and found that IORING_SETUP_SUBMIT_ALL can indeed solve
> this problem. Should I just modify this problem or add
> IORING_SETUP_SUBMIT_ALL to the general path to solve most possible
> problems?

I think just fix up this one. We really should have all the tests use
t_create_ring*() first, and those helpers should just set SUBMIT_ALL.
But that's a separate change.

-- 
Jens Axboe

