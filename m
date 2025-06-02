Return-Path: <io-uring+bounces-8188-lists+io-uring=lfdr.de@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [147.75.80.249])
	by mail.lfdr.de (Postfix) with ESMTPS id 23F76ACB819
	for <lists+io-uring@lfdr.de>; Mon,  2 Jun 2025 17:35:50 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id 0D4D11C272BD
	for <lists+io-uring@lfdr.de>; Mon,  2 Jun 2025 15:26:13 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 9E89A239E6A;
	Mon,  2 Jun 2025 15:19:08 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel-dk.20230601.gappssmtp.com header.i=@kernel-dk.20230601.gappssmtp.com header.b="f8FCt4Dc"
X-Original-To: io-uring@vger.kernel.org
Received: from mail-io1-f51.google.com (mail-io1-f51.google.com [209.85.166.51])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 246C82376E6
	for <io-uring@vger.kernel.org>; Mon,  2 Jun 2025 15:19:04 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.166.51
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1748877548; cv=none; b=fbdJ0L2XFzyots9gz111eDwDsVQ0jWFQ29Jdx/8/Fv5l5rpO1YKHO4lDR8LB/HBh2sI6brr6d8eSN2ZtXTLZA4v/7UWo0hDSGAWdNyYWjzoU9URykqqWrxtDqRrlaWj0RdFG0no/S0paSt4uSdv+trcdw5nmD87mkfgfjdeT5mo=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1748877548; c=relaxed/simple;
	bh=MnxiV7jGcWoQ1Wv0ZUfjYZC5S2UNU7XxwPraTjtDfk0=;
	h=Message-ID:Date:MIME-Version:Subject:To:References:From:
	 In-Reply-To:Content-Type; b=P6C7R58OiIw2LtHP1zzDt8mUczbQb1LMeMngr68XZb1TmXGFI6UPgkFZT9m/I3D6V51XoEj5gqAAzjyrZnrur/Il1hvZKXp+p36ioGWa0Io083/VbcqTy2TM/MFGNR6PiIH/dKy7gegww+OTpwTKtRfejlmA4323k3lSYzmv/Cc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=kernel.dk; spf=pass smtp.mailfrom=kernel.dk; dkim=pass (2048-bit key) header.d=kernel-dk.20230601.gappssmtp.com header.i=@kernel-dk.20230601.gappssmtp.com header.b=f8FCt4Dc; arc=none smtp.client-ip=209.85.166.51
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=kernel.dk
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=kernel.dk
Received: by mail-io1-f51.google.com with SMTP id ca18e2360f4ac-86cfa53d151so9208239f.2
        for <io-uring@vger.kernel.org>; Mon, 02 Jun 2025 08:19:04 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernel-dk.20230601.gappssmtp.com; s=20230601; t=1748877544; x=1749482344; darn=vger.kernel.org;
        h=content-transfer-encoding:in-reply-to:content-language:from
         :references:to:subject:user-agent:mime-version:date:message-id:from
         :to:cc:subject:date:message-id:reply-to;
        bh=gnB256URbo309IDMMrLVmKzKRPA3J57w1ZFPw1qaA5I=;
        b=f8FCt4DcE0Jdc7EHr2x+1+2M5D9m54HMgabgoUxKJ6WoheckkoesPY8fQgJApggCDO
         F/nvuwDTFF3dbx46+Y1WLH4/BHwqDHKPXA5lZqNiQvhuKKY0KpnmrSZL/jN2TQKBUFl6
         IftwPXdgLsr8k93iz6bR8Ym9LXmdyPiba24SiAPWyYufBGiqoAAkeh1BGLgL8p1DVp8a
         Hltg7YhZXhEhze7hBGHLrzOYQJlifXi16hR9+6xunYbmNf3v6LARlHtjJ/W3Bgb1cK83
         hgXnDnrawjBkNSyDFVGQBGfy3HRX3vR/T190UGjTH/Za4EbhBowl72R2uqQtXymxx2ye
         rAEQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1748877544; x=1749482344;
        h=content-transfer-encoding:in-reply-to:content-language:from
         :references:to:subject:user-agent:mime-version:date:message-id
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=gnB256URbo309IDMMrLVmKzKRPA3J57w1ZFPw1qaA5I=;
        b=WwJgnDFvO+DQ78Re0LENeq9R+n1kb+wZajDihp9H4rcF3NDYhGFgbMD9x3/fE9XU/F
         zPNmCKJd7irC1b2YQ2APVNGwe5qaKDon9eKY3B1dZ3G9JIrNIV9s/KDUjpTQMV1QWDAn
         wZVTLikb5CUJniJ4IZDMMfE8kSV4XlLJbToaBL9OO2J2+mzuEvER05O3o6VWcvIRfgIH
         0ywxXyzYBuM6xMezwumGL+MrIuh/CtK6/UKw7ZXTfw8FEh9uY59SZY1GSV0IDmrVVJ0N
         tERpvoVq3SmC92NOuOp0hn2CJr80SOS7U2KbalgKNPnPmBL5myfvCoZAGCic/dGYFh8E
         EeSw==
X-Forwarded-Encrypted: i=1; AJvYcCWixjFhoyTCfxvioxtNufkrKkaPthZq5t1Fgsijb319qqXR4UYROmdqF1obWFxG6wGZIx3aC5sbQQ==@vger.kernel.org
X-Gm-Message-State: AOJu0YwUQUq+EP/iJ1vCRziMlrYJwMlE7v0mrgD6a9wZ3KwAQaeLAPYz
	+rSVO8Wdq+DgbixZqCUDdHb2BgpxIzuPNHdITGyuHEMmWPCCSk3LNxd+D7rRFDzbsvk=
X-Gm-Gg: ASbGncubM5VxejyckstyVfFsydbEGWIHjoF5GV7g6GB1bvrQ/sRqkwhZRr3lTurAlWt
	bhxMSbltevAKPG5GYMHdVwgnu7BAedTUH9wHJIQ4uay8USqzdqMi1LfzrmQjKBv1Dj4Z3MyXm5R
	7vKhu8v0AwY9Q63yeC7HW3F1uHxmbWrN1RbnbWn7jeGjD/Rsc4HbgYDWpudEzyoebMhbDKrKjUP
	LQ+d78qtHNN7QXy7bCVThHvsyIHra98AKfAsqZyNTIAkCTOLELLUWlh2azTNCXRi4yuzSkhT1OU
	WAyo4OAUFJA+wnhxT6n3g9ogypuBPMcoAAA/ThdYO4BLtDbE0wIQ3ExdIg==
X-Google-Smtp-Source: AGHT+IERTtgZevpyYrfq6kcIAXKXNc36muyWElRZspVsx40vnGbHEXjAY2DTWxmwtGTmrHdjnKs3/A==
X-Received: by 2002:a05:6602:408a:b0:86c:cf7e:d85d with SMTP id ca18e2360f4ac-86d3fe5062emr1137750739f.12.1748877543895;
        Mon, 02 Jun 2025 08:19:03 -0700 (PDT)
Received: from [192.168.1.116] ([96.43.243.2])
        by smtp.gmail.com with ESMTPSA id ca18e2360f4ac-86cf5e79acfsm189092139f.19.2025.06.02.08.19.03
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Mon, 02 Jun 2025 08:19:03 -0700 (PDT)
Message-ID: <44e37cb0-9a89-4c88-8fa1-2a51abad34f7@kernel.dk>
Date: Mon, 2 Jun 2025 09:19:02 -0600
Precedence: bulk
X-Mailing-List: io-uring@vger.kernel.org
List-Id: <io-uring.vger.kernel.org>
List-Subscribe: <mailto:io-uring+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:io-uring+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v4 1/6] io_uring/mock: add basic infra for test mock files
To: Pavel Begunkov <asml.silence@gmail.com>, io-uring@vger.kernel.org
References: <cover.1748609413.git.asml.silence@gmail.com>
 <6c51a2bb26dbb74cbe1ca0da137a77f7aaa59b6c.1748609413.git.asml.silence@gmail.com>
 <cf2e4b4b-c229-408d-ac86-ab259a87e90e@kernel.dk>
 <eb81c562-7030-48e0-85de-6192f3f5845a@gmail.com>
 <e6ea9f6c-c673-4767-9405-c9179edbc9c6@gmail.com>
 <8cdda5c4-5b05-4960-90e2-478417be6faf@gmail.com>
 <311e2d72-3b30-444e-bd18-a39060e5e9fa@kernel.dk>
 <ac55e11c-feb2-45a3-84d4-d84badab477e@gmail.com>
 <d285d003-b160-4174-93bc-223bfbc7fd7c@kernel.dk>
 <b601b46f-d4b5-4ffc-af8a-3c2e58cdd62d@gmail.com>
From: Jens Axboe <axboe@kernel.dk>
Content-Language: en-US
In-Reply-To: <b601b46f-d4b5-4ffc-af8a-3c2e58cdd62d@gmail.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit

On 5/30/25 12:14 PM, Pavel Begunkov wrote:
> On 5/30/25 16:30, Jens Axboe wrote:
>> On 5/30/25 9:11 AM, Pavel Begunkov wrote:
>>> On 5/30/25 15:41, Jens Axboe wrote:
>>>> On 5/30/25 8:26 AM, Pavel Begunkov wrote:
>>>>> On 5/30/25 15:12, Pavel Begunkov wrote:
>>>>>> On 5/30/25 15:09, Pavel Begunkov wrote:
>>>>>>> On 5/30/25 14:28, Jens Axboe wrote:
>>>>>>>> On 5/30/25 6:51 AM, Pavel Begunkov wrote:
>>>>>>>>> diff --git a/init/Kconfig b/init/Kconfig
>>>>>>>>> index 63f5974b9fa6..9e8a5b810804 100644
>>>>>>>>> --- a/init/Kconfig
>>>>>>>>> +++ b/init/Kconfig
>>>>>>>>> @@ -1774,6 +1774,17 @@ config GCOV_PROFILE_URING
>>>>>>>>>           the io_uring subsystem, hence this should only be enabled for
>>>>>>>>>           specific test purposes.
>>>>>>>>> +config IO_URING_MOCK_FILE
>>>>>>>>> +    tristate "Enable io_uring mock files (Experimental)" if EXPERT
>>>>>>>>> +    default n
>>>>>>>>> +    depends on IO_URING && KASAN
>>>>>>>>> +    help
>>>>>>>>> +      Enable mock files for io_uring subststem testing. The ABI might
>>>>>>>>> +      still change, so it's still experimental and should only be enabled
>>>>>>>>> +      for specific test purposes.
>>>>>>>>> +
>>>>>>>>> +      If unsure, say N.
>>>>>>>>
>>>>>>>> As mentioned in the other email, I don't think we should include KASAN
>>>>>>>> here.
>>>>>>>
>>>>>>> I disagree. It's supposed to give a superset of coverage, if not,
>>>>>>> mocking should be improved. It might be seen as a nuisance that you
>>>>>>> can't run it with a stock kernel, but that desire is already half
>>>>>>> step from "let's enable it for prod kernels for testing", and then
>>>>>>> distributions will start forcing it on, because as you said "People
>>>>>>> do all sorts of weird stuff".
>>>>>>
>>>>>> The purpose is to get the project even more hardened / secure through
>>>>>> elaborate testing, that would defeat the purpose if non test systems
>>>>>> will start getting errors because of some mess up, let's say in the
>>>>>> driver.
>>>>>
>>>>> Alternatively, it doesn't help with bloating, but tainting the kernel
>>>>> might be enough to serve the purpose.
>>>>
>>>> I think taint or KASAN dependencies is over-reaching. It has nothing to
>>>> do with KASAN, and there's absolutely zero reason for it to be gated on
>>>> KASAN (or lockdep, or whatever). You're never going to prevent people
>>>> from running this in odd cases, and I think it's a mistake to try and do
>>>> that. If the thing is gated on CAP_SYS_ADMIN, then that's Good Enough
>>>> imho.
>>>>
>>>> It'll make my life harder for coverage testing, which I think is reason
>>>> enough alone to not have a KASAN dependency. No other test code in the
>>>> kernel has unrelated dependencies like KASAN, unless they are related to
>>>> KASAN. We should not add one here for some notion of preventing people
>>>> from running it on prod stuff, in fact it should be totally fine to run
>>>> on a prod kernel. Might actually be useful in some cases, to verify or
>>>> test some behavior on that specific kernel, without needing to build a
>>>> new kernel for it.
>>>
>>> commit 2852ca7fba9f77b204f0fe953b31fadd0057c936
>>> Author: David Gow <davidgow@google.com>
>>> Date:   Fri Jul 1 16:47:41 2022 +0800
>>>
>>>      panic: Taint kernel if tests are run
>>>          Most in-kernel tests (such as KUnit tests) are not supposed to run on
>>>      production systems: they may do deliberately illegal things to trigger
>>>      errors, and have security implications (for example, KUnit assertions
>>>      will often deliberately leak kernel addresses).
>>>          Add a new taint type, TAINT_TEST to signal that a test has been run.
>>>      This will be printed as 'N' (originally for kuNit, as every other
>>>      sensible letter was taken.)
>>>          This should discourage people from running these tests on production
>>>      systems, and to make it easier to tell if tests have been run
>>>      accidentally (by loading the wrong configuration, etc.)
>>>          Acked-by: Luis Chamberlain <mcgrof@kernel.org>
>>>      Reviewed-by: Brendan Higgins <brendanhiggins@google.com>
>>>      Signed-off-by: David Gow <davidgow@google.com>
>>>      Signed-off-by: Shuah Khan <skhan@linuxfoundation.org>
>>>
>>>
>>> The same situation, it's a special TAINT_TEST, and set for a good
>>> reason. And there is also a case of TAINT_CRAP for staging.
>>
>> TAINT is fine, I don't care about that. So we can certainly do that. My
> 
> Good you changed your mind

Yes, my main objection was (and is) having nonsensical dependencies.

-- 
Jens Axboe

