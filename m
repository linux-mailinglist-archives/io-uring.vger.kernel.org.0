Return-Path: <io-uring+bounces-8164-lists+io-uring=lfdr.de@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from sy.mirrors.kernel.org (sy.mirrors.kernel.org [IPv6:2604:1380:40f1:3f00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id B3A95AC9213
	for <lists+io-uring@lfdr.de>; Fri, 30 May 2025 17:10:35 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sy.mirrors.kernel.org (Postfix) with ESMTPS id 8E5167A871E
	for <lists+io-uring@lfdr.de>; Fri, 30 May 2025 15:09:16 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id DB2F8235065;
	Fri, 30 May 2025 15:10:29 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="g8iTd2pd"
X-Original-To: io-uring@vger.kernel.org
Received: from mail-ej1-f52.google.com (mail-ej1-f52.google.com [209.85.218.52])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id EF87921CA0A
	for <io-uring@vger.kernel.org>; Fri, 30 May 2025 15:10:27 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.218.52
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1748617829; cv=none; b=Oc9SbF03MlLF9wvU3W4w/x2ZppPSTSkGGoCaDCSMGsoMuc4NmIQDTRumsAeiTU+i8263oEL2zsRm4p/xkDJME2ux7OarWCO37SCylorRBScSGpX5jmZJm1m2bsZjGEkb1gPBXmBdiHOyV0dArt5abSk87SsX6ObnCkFCRYJiz/g=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1748617829; c=relaxed/simple;
	bh=jY8M6S69Cg6lcSE15oPsKDH1X8buNHQMNPE+8IAz1Pk=;
	h=Message-ID:Date:MIME-Version:Subject:To:References:From:
	 In-Reply-To:Content-Type; b=U0690uo5rof7+JzCTdA41fwFPZtDyp4zs1P7/YAHOArpts6Pkw/CB/3OgEE+orKEUgNd5R+UmD6fTou0g/n3QThTBGSsvbJbxs4AuVyvgf27buaFTPde/8M3el6JRKP4N8zf+gLzeB01XJPsiYCJDQcjb/rIKBaNCHNuNkwFKEI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=g8iTd2pd; arc=none smtp.client-ip=209.85.218.52
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Received: by mail-ej1-f52.google.com with SMTP id a640c23a62f3a-ad574992fcaso370550366b.1
        for <io-uring@vger.kernel.org>; Fri, 30 May 2025 08:10:27 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1748617826; x=1749222626; darn=vger.kernel.org;
        h=content-transfer-encoding:in-reply-to:from:content-language
         :references:to:subject:user-agent:mime-version:date:message-id:from
         :to:cc:subject:date:message-id:reply-to;
        bh=pEFHGBaTggfP5PrN12r9EK1eQJz2ElF+Jy1K40jbj1M=;
        b=g8iTd2pdJ3/XQ/M+7z66T5Z2mnTADLZTGmLrW/cwFG0UXSg1MXf1m5xGhO+QCA2kGH
         3JRVuFtRq4r2U4nKcbIC+UOrRvEtzJgUP4rDxCEEL2+tnzaW04ZB4GPbw2LV1sUEEV2L
         jx0kk21FLxLVvF/orSDhfT++7ILQ2oRm84ITAdKgGvW3Au3kxHjvl7fysFh592Uuitds
         9lkZ8Lf7zij39SBBXuCXOkGcv5udCZ0W1KuvNNxbBMOHsvIxuzt9uZzFmyNV4DxOS0V5
         o4eBQOFNCW+9KYihoAEsWdmltwka+4hzgXG5IocS88JZRcKV8b1ZrawQM+0TRW+o5QwN
         cdAQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1748617826; x=1749222626;
        h=content-transfer-encoding:in-reply-to:from:content-language
         :references:to:subject:user-agent:mime-version:date:message-id
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=pEFHGBaTggfP5PrN12r9EK1eQJz2ElF+Jy1K40jbj1M=;
        b=Ni7RrZYvXa2TkDGC9WapN+wxIwG/5drGxkGQ/fHidgR7zXDpPzZFO6JH+vWEuqjkIh
         dQnf4dJekoQ3s2PPtJ17V1GEJJIDAZPn4KZU6Mnsz5oIfEnTrzYyRQMyua6ciODNlOL2
         0xhad3NzRb4lpHeVnRgZ6c990J71S4qYaLKeZVwHpPORnvHOxw6uFC8fpcMcynvome95
         iYKNki5uKbegtv4BAE0t+JcLkyIUZMsqfQQ6TYARsuSwsKocrQW2nGCU2m+U/3FtPcZb
         axwdUKjyFFIUvxtLEaaoYyps1gTEarTcqjGfT6QqfeQfefyqJ0kEOvrLOwYgHtx+I3UB
         yGwA==
X-Forwarded-Encrypted: i=1; AJvYcCVODPPgHgS6X+zTNdrjY6ck5RkOmQGjbcLO9eAuRuirRKXMwLuBtJsqBF5Wwwvaj18F3RKH0ehq1w==@vger.kernel.org
X-Gm-Message-State: AOJu0Ywm2VpGXGGxRWcSLp51x2J7VDYyXqwLLfYFTKJjDKWll/EESzUM
	5RpFulOPUnhBXJcy7Pboc2Pf+btZCXKFyeMIR+ZHNKwCSqdFf/UIByQLfk9p5w==
X-Gm-Gg: ASbGnctHVbpv2hcGBmVT10JwVkui0x+7gIOxLK1+RBMqL6rUj1XO/0eqZ4eNLUeoVxW
	iBX9ypP8JPc2v7QnzKLOw3iA2w6o0yUup8xkb7ysRLrDCKFGCGnn9HDgsjhqFMfbtqghrQgBml7
	LIXIUpXYvVCSOzAsQjelhKMrh/GV6ae1OFXxmS5nRBBhxzAO+EkzHrnpSm0+rUVrc6hBifH0V9c
	4/G9ubgw/QDLXGWAXMXIKhPyddzm9gelGOqoclbGVcV65tF2i8rYlty8/rvrFb9IZCnGtwldsOf
	0Nyt9nM2D6+jH4ggLVrkmBXIzPkWQXKFlJrg91ur5bSnGVVKwobwmz9XzL2cfKjuKtMB/2+/Fdg
	=
X-Google-Smtp-Source: AGHT+IFa1cZ073vPjlnDxOfgk300DzyiSgXrT+BuyyX8ztXdx8KnhvYkTP4JRy2LJ1qUnWUxBqS9/w==
X-Received: by 2002:a17:907:3d9f:b0:adb:2a21:28b3 with SMTP id a640c23a62f3a-adb3244ce26mr367416466b.54.1748617825662;
        Fri, 30 May 2025 08:10:25 -0700 (PDT)
Received: from ?IPV6:2620:10d:c096:325::15c? ([2620:10d:c092:600::1:a320])
        by smtp.gmail.com with ESMTPSA id a640c23a62f3a-ada5e2bf088sm345473066b.106.2025.05.30.08.10.24
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Fri, 30 May 2025 08:10:24 -0700 (PDT)
Message-ID: <ac55e11c-feb2-45a3-84d4-d84badab477e@gmail.com>
Date: Fri, 30 May 2025 16:11:38 +0100
Precedence: bulk
X-Mailing-List: io-uring@vger.kernel.org
List-Id: <io-uring.vger.kernel.org>
List-Subscribe: <mailto:io-uring+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:io-uring+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v4 1/6] io_uring/mock: add basic infra for test mock files
To: Jens Axboe <axboe@kernel.dk>, io-uring@vger.kernel.org
References: <cover.1748609413.git.asml.silence@gmail.com>
 <6c51a2bb26dbb74cbe1ca0da137a77f7aaa59b6c.1748609413.git.asml.silence@gmail.com>
 <cf2e4b4b-c229-408d-ac86-ab259a87e90e@kernel.dk>
 <eb81c562-7030-48e0-85de-6192f3f5845a@gmail.com>
 <e6ea9f6c-c673-4767-9405-c9179edbc9c6@gmail.com>
 <8cdda5c4-5b05-4960-90e2-478417be6faf@gmail.com>
 <311e2d72-3b30-444e-bd18-a39060e5e9fa@kernel.dk>
Content-Language: en-US
From: Pavel Begunkov <asml.silence@gmail.com>
In-Reply-To: <311e2d72-3b30-444e-bd18-a39060e5e9fa@kernel.dk>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit

On 5/30/25 15:41, Jens Axboe wrote:
> On 5/30/25 8:26 AM, Pavel Begunkov wrote:
>> On 5/30/25 15:12, Pavel Begunkov wrote:
>>> On 5/30/25 15:09, Pavel Begunkov wrote:
>>>> On 5/30/25 14:28, Jens Axboe wrote:
>>>>> On 5/30/25 6:51 AM, Pavel Begunkov wrote:
>>>>>> diff --git a/init/Kconfig b/init/Kconfig
>>>>>> index 63f5974b9fa6..9e8a5b810804 100644
>>>>>> --- a/init/Kconfig
>>>>>> +++ b/init/Kconfig
>>>>>> @@ -1774,6 +1774,17 @@ config GCOV_PROFILE_URING
>>>>>>          the io_uring subsystem, hence this should only be enabled for
>>>>>>          specific test purposes.
>>>>>> +config IO_URING_MOCK_FILE
>>>>>> +    tristate "Enable io_uring mock files (Experimental)" if EXPERT
>>>>>> +    default n
>>>>>> +    depends on IO_URING && KASAN
>>>>>> +    help
>>>>>> +      Enable mock files for io_uring subststem testing. The ABI might
>>>>>> +      still change, so it's still experimental and should only be enabled
>>>>>> +      for specific test purposes.
>>>>>> +
>>>>>> +      If unsure, say N.
>>>>>
>>>>> As mentioned in the other email, I don't think we should include KASAN
>>>>> here.
>>>>
>>>> I disagree. It's supposed to give a superset of coverage, if not,
>>>> mocking should be improved. It might be seen as a nuisance that you
>>>> can't run it with a stock kernel, but that desire is already half
>>>> step from "let's enable it for prod kernels for testing", and then
>>>> distributions will start forcing it on, because as you said "People
>>>> do all sorts of weird stuff".
>>>
>>> The purpose is to get the project even more hardened / secure through
>>> elaborate testing, that would defeat the purpose if non test systems
>>> will start getting errors because of some mess up, let's say in the
>>> driver.
>>
>> Alternatively, it doesn't help with bloating, but tainting the kernel
>> might be enough to serve the purpose.
> 
> I think taint or KASAN dependencies is over-reaching. It has nothing to
> do with KASAN, and there's absolutely zero reason for it to be gated on
> KASAN (or lockdep, or whatever). You're never going to prevent people
> from running this in odd cases, and I think it's a mistake to try and do
> that. If the thing is gated on CAP_SYS_ADMIN, then that's Good Enough
> imho.
> 
> It'll make my life harder for coverage testing, which I think is reason
> enough alone to not have a KASAN dependency. No other test code in the
> kernel has unrelated dependencies like KASAN, unless they are related to
> KASAN. We should not add one here for some notion of preventing people
> from running it on prod stuff, in fact it should be totally fine to run
> on a prod kernel. Might actually be useful in some cases, to verify or
> test some behavior on that specific kernel, without needing to build a
> new kernel for it.

commit 2852ca7fba9f77b204f0fe953b31fadd0057c936
Author: David Gow <davidgow@google.com>
Date:   Fri Jul 1 16:47:41 2022 +0800

     panic: Taint kernel if tests are run
     
     Most in-kernel tests (such as KUnit tests) are not supposed to run on
     production systems: they may do deliberately illegal things to trigger
     errors, and have security implications (for example, KUnit assertions
     will often deliberately leak kernel addresses).
     
     Add a new taint type, TAINT_TEST to signal that a test has been run.
     This will be printed as 'N' (originally for kuNit, as every other
     sensible letter was taken.)
     
     This should discourage people from running these tests on production
     systems, and to make it easier to tell if tests have been run
     accidentally (by loading the wrong configuration, etc.)
     
     Acked-by: Luis Chamberlain <mcgrof@kernel.org>
     Reviewed-by: Brendan Higgins <brendanhiggins@google.com>
     Signed-off-by: David Gow <davidgow@google.com>
     Signed-off-by: Shuah Khan <skhan@linuxfoundation.org>


The same situation, it's a special TAINT_TEST, and set for a good
reason. And there is also a case of TAINT_CRAP for staging.

-- 
Pavel Begunkov


