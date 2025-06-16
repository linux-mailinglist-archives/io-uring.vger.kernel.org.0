Return-Path: <io-uring+bounces-8369-lists+io-uring=lfdr.de@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from sy.mirrors.kernel.org (sy.mirrors.kernel.org [147.75.48.161])
	by mail.lfdr.de (Postfix) with ESMTPS id B02FEADB562
	for <lists+io-uring@lfdr.de>; Mon, 16 Jun 2025 17:29:43 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sy.mirrors.kernel.org (Postfix) with ESMTPS id 42EEB7ABD44
	for <lists+io-uring@lfdr.de>; Mon, 16 Jun 2025 15:26:19 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id EE05522F75E;
	Mon, 16 Jun 2025 15:26:42 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel-dk.20230601.gappssmtp.com header.i=@kernel-dk.20230601.gappssmtp.com header.b="p74RM3hf"
X-Original-To: io-uring@vger.kernel.org
Received: from mail-il1-f170.google.com (mail-il1-f170.google.com [209.85.166.170])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 80ACB27E073
	for <io-uring@vger.kernel.org>; Mon, 16 Jun 2025 15:26:39 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.166.170
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1750087602; cv=none; b=atV8pPHu1DuXmwbV95TUk7Z9ACTh7pYNx3zBrwQUVuy4aWKPtZP92oiPvsqe+nSf28bxuKWagQtVYVK+ZK6VAYaTncEURZM5fjzFgxmB6vetIPRB1Dl34xeWQAYs7Wg+rA0sKIcyNxNBLwdF9+WCcUr7foswsQfNsVwMNBo+rsY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1750087602; c=relaxed/simple;
	bh=hWGGS0HIfyjaMYMIf9r/DqUND98vpTpoiNpsZ6g/MVU=;
	h=Message-ID:Date:MIME-Version:Subject:From:To:Cc:References:
	 In-Reply-To:Content-Type; b=COCbHempomqkwnb/wyjwO/S47AibWeAIz+myBpYebbqqfuLabK8dGu1/7jnAKbJpsVhRhF8kJyGOR1elawmX+arH4M3+FqwMeUK6clEVEqi21WbC3eO680Av1Fx6knfZJTRCOvLtpezeFLVVmSofD0sGv4Fa9D0xlFVNwsABLQQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=kernel.dk; spf=pass smtp.mailfrom=kernel.dk; dkim=pass (2048-bit key) header.d=kernel-dk.20230601.gappssmtp.com header.i=@kernel-dk.20230601.gappssmtp.com header.b=p74RM3hf; arc=none smtp.client-ip=209.85.166.170
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=kernel.dk
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=kernel.dk
Received: by mail-il1-f170.google.com with SMTP id e9e14a558f8ab-3da82c6c5d4so45379395ab.1
        for <io-uring@vger.kernel.org>; Mon, 16 Jun 2025 08:26:39 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernel-dk.20230601.gappssmtp.com; s=20230601; t=1750087598; x=1750692398; darn=vger.kernel.org;
        h=content-transfer-encoding:in-reply-to:content-language:references
         :cc:to:from:subject:user-agent:mime-version:date:message-id:from:to
         :cc:subject:date:message-id:reply-to;
        bh=Z24bYW2OmAl+0Lo30RqKasxRKDEdr99aPGQ8W9WrRE8=;
        b=p74RM3hfwGXuvnWqka6DWjeyYJLLf8oFNPdBdT3ibijA1eC0xOkMgOkWim7bXWdx+8
         v/e/rnssYV/tSOqThcHwZzHaXG7QJ7utoim7YAebTLt9OBiv7EU6WndJr6ByuhApN0PU
         wWtOUtZDTs+ze7xKBP2AHnbegdiaNQOosD0jTAUlL0568bac8emUqyXCp33d5en3sWgi
         VB+s/cSosiXR1RERzCdHp4Km/6y3wEjjzwrR2cHe6gU/pvuDp0l0G9cuypN6aQHxRz8g
         BV2f2Xcy+k6P/c+4lGpTNgrE+jECQb4W8prV+6IhyKd+z4yW4WJZLcR8DL9qAmKweeiU
         v7dQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1750087598; x=1750692398;
        h=content-transfer-encoding:in-reply-to:content-language:references
         :cc:to:from:subject:user-agent:mime-version:date:message-id
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=Z24bYW2OmAl+0Lo30RqKasxRKDEdr99aPGQ8W9WrRE8=;
        b=mxWbtWNEEDOAKHbyluAzfTyhtC1XHIUNZAkRYy+mvifZmHHF/oiUcylYN5L+EJy/0X
         5+x+R6cK4Fwcetbn4ZrDr7J2yk1WoRat04qXETppxikBMTRvS5xVqxT4qnr98Qx8Ip5t
         Wi6sa4ciLUAdHYQa2KIyL1WJtmUZcDUgkZMSArmC1Y3TUQF3AuD75opL46Kw6Q/PUKPQ
         E6rLsUAyglj7v11Ed/LD/Sm0D29Feu2GiWLbiUnFv81w38uD6gEDdK40Z9ypLY5PVUSE
         Pf3pSV2dxFdLfzUD8323fd/k7kqJ/i+nzWifLUWOd+Si0ekYhPKjANeqyRBnjUdg5g+T
         h25w==
X-Gm-Message-State: AOJu0Yxx3PGc48aXBq2eCUGYUAiFdzgWJdMart5My2CJHDfLp9241Ivu
	y8bDoT4D1Fs5wRCgjp2Y8HBxFcDJQdb5H+TG+gpfljpRM8Rew8pqgfbXAnGaNYeN6p5NBFcExhY
	YDFpD
X-Gm-Gg: ASbGncu/Hcktq5VkTMQoixPWVEfUbAm1SzDvyXMThTTMWsgAsHjAhik7wWUxoAQitwZ
	wF/BqNNHBYkaQq36fKLCpnflsqJvEsvWQZsiNoj1fzpWpW2i9gcVdbJDkwx9iAUOqih8cPbO0bD
	BBS6ehoBoTbXmD4m79YVcNSIQ/IRnqp1d60AmKcTXQ5cTMIzvUqXKx+vjI2RTMwueogjMM8k6Vm
	+vih3wbyNnb9udxkFT9hbfqJyBCBFmQGawhp1XQ9IftfNHFna7CX0AtQIGSoVeXxZrGxnq0bVJP
	sXuoyezON+sF/lUYd1k/005Mvm5HI/AbmSMyfM46JFrKqiu6m/zhIVJhM0I=
X-Google-Smtp-Source: AGHT+IG4nlRVTKb3MGnd7BtOjFtWB//o13dqLWXENV1T5PwoGwDu9qKPRNJvwu/ttY0ZncsTvW81Zg==
X-Received: by 2002:a05:6e02:198d:b0:3dc:7fa4:804 with SMTP id e9e14a558f8ab-3de07ced6acmr105677865ab.16.1750087598445;
        Mon, 16 Jun 2025 08:26:38 -0700 (PDT)
Received: from [192.168.1.150] ([198.8.77.157])
        by smtp.gmail.com with ESMTPSA id e9e14a558f8ab-3de134094f6sm9620455ab.9.2025.06.16.08.26.37
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Mon, 16 Jun 2025 08:26:37 -0700 (PDT)
Message-ID: <536b7d81-d64a-4ba4-9f07-5bfa8286bf1b@kernel.dk>
Date: Mon, 16 Jun 2025 09:26:37 -0600
Precedence: bulk
X-Mailing-List: io-uring@vger.kernel.org
List-Id: <io-uring.vger.kernel.org>
List-Subscribe: <mailto:io-uring+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:io-uring+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: Building liburing on musl libc gives error that errno.h not found
From: Jens Axboe <axboe@kernel.dk>
To: =?UTF-8?Q?Milan_P=2E_Stani=C4=87?= <mps@arvanta.net>
Cc: io-uring@vger.kernel.org
References: <20250615171638.GA11009@m1pro.arvanta.net>
 <b94bfb39-0083-446a-bc76-79b99ea84a4e@kernel.dk>
 <20250615195617.GA15397@m1pro.arvanta.net>
 <1198c63d-4fe8-4dda-ae9f-23a9f5dafd5c@kernel.dk>
 <20250616130612.GA21485@m1pro.arvanta.net>
 <39ae421b-a633-4b47-bf2b-6a55d818aa7c@kernel.dk>
 <20250616141823.GA27374@m1pro.arvanta.net>
 <290bfa14-b595-4fea-b1fe-a3f0881f4220@kernel.dk>
Content-Language: en-US
In-Reply-To: <290bfa14-b595-4fea-b1fe-a3f0881f4220@kernel.dk>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit

On 6/16/25 9:13 AM, Jens Axboe wrote:
> On 6/16/25 8:18 AM, Milan P. Stani? wrote:
>> On Mon, 2025-06-16 at 07:59, Jens Axboe wrote:
>>> On 6/16/25 7:06 AM, Milan P. Stani? wrote:
>>>> On Mon, 2025-06-16 at 06:34, Jens Axboe wrote:
>>>>> On 6/15/25 1:56 PM, Milan P. Stani? wrote:
>>>>>> On Sun, 2025-06-15 at 12:57, Jens Axboe wrote:
>>>>>>> On 6/15/25 11:16 AM, Milan P. Stani? wrote:
>>>>>>>> Hi,
>>>>>>>>
>>>>>>>> Trying to build liburing 2.10 on Alpine Linux with musl libc got error
>>>>>>>> that errno.h is not found when building examples/zcrx.c
>>>>>>>>
>>>>>>>> Temporary I disabled build zcrx.c, merge request with patch for Alpine
>>>>>>>> is here:
>>>>>>>> https://gitlab.alpinelinux.org/alpine/aports/-/merge_requests/84981
>>>>>>>> I commented in merge request that error.h is glibc specific.
>>>>>>>
>>>>>>> I killed it, it's not needed and should've been caught during review.
>>>>>>> We should probably have alpine/musl as part of the CI...
>>>>>>
>>>>>> Fine.
>>>>>>
>>>>>>>> Side note: running `make runtests` gives 'Tests failed (32)'. Not sure
>>>>>>>> should I post full log here.
>>>>>>>
>>>>>>> Either that or file an issue on GH. Sounds like something is very wrong
>>>>>>> on the setup if you get failing tests, test suite should generally
>>>>>>> pass on the current kernel, or any -stable kernel.
>>>>>>>
>>>>>> I'm attaching log here to this mail. Actually it is one bug but repeated
>>>>>> in different tests, segfaults
>>>>>
>>>>> Your kernel is ancient, and that will surely account from some of the
>>>>> failures you see. A 6.6 stable series from January 2024 is not current
>>>>> by any stretch, should definitely upgrade that. But I don't think this
>>>>> accounts for all the failures seen, it's more likely there's some musl
>>>>> related issue as well which is affecting some of the tests.
>>>>
>>>> This happens also on 6.14.8-1 asahi kernel on apple m1pro machine.
>>>> I forgot to mention this in previous mail, sorry.
>>>
>>> Also on musl, correct?
>>
>> Yes, correct.
>>
>>> Guessing it must be some musl oddity. I'll try and setup a vm with
>>> alpine and see how that goes.
>>
>> It could be. I can ask on #musl IRC channel on libera.chat
> 
> Probably easier if I just take a look at it, as long as I can get
> an alpine vm image going.

Works fine here, only tests that seem to mess up are the ones that
assume a fully featured ps is there:

Running test sq-poll-kthread.t                                      ps: unrecognized
 option: ppid
BusyBox v1.37.0 (2025-05-26 20:04:45 UTC) multi-call binary.

Usage: ps [-o COL1,COL2=HEADER] [-T]

Show list of processes

	-o COL1,COL2=HEADER	Select columns for display
	-T			Show threads
ps: unrecognized option: ppid

Unsure what's going on at your end. This is using a recent -git
kernel, fwiw.

-- 
Jens Axboe


