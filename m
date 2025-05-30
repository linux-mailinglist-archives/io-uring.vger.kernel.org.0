Return-Path: <io-uring+bounces-8168-lists+io-uring=lfdr.de@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [147.75.199.223])
	by mail.lfdr.de (Postfix) with ESMTPS id E4576AC9584
	for <lists+io-uring@lfdr.de>; Fri, 30 May 2025 20:13:42 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id 26C114E5F56
	for <lists+io-uring@lfdr.de>; Fri, 30 May 2025 18:13:40 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id E8C7722D7BF;
	Fri, 30 May 2025 18:13:29 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="IixaRVHT"
X-Original-To: io-uring@vger.kernel.org
Received: from mail-ej1-f51.google.com (mail-ej1-f51.google.com [209.85.218.51])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id EAE72278154
	for <io-uring@vger.kernel.org>; Fri, 30 May 2025 18:13:27 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.218.51
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1748628809; cv=none; b=PcSvs+3b3RSJLx02D8CF9XcjEQ0B/i03NeSa0RfBOtrzxTL+4oZN9y8BrPxF53xgqv4WBBAv4SrGMow/QsF4tfb/k6jY4dFGHT8wIAo7MipyLT1BEoUgXe8RMDkLOyesD79YmoWaGN4IypD4pa8PYuZ1tBQXnynY9iC4y5JIq1s=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1748628809; c=relaxed/simple;
	bh=OimSx/FhCguFmA+nlJvgfu9f8pWoB7Sxptl6bXYz0Ww=;
	h=Message-ID:Date:MIME-Version:Subject:To:References:From:
	 In-Reply-To:Content-Type; b=hSl5d0fH0cyZyZzgwbHW+zoWef0exAjomDVZfOvWwZhxBMmhz7jMsGMjJOlkJ16egBMC7qeSTsGMCZ84Gzxd/4edZtBCtp0qDaRS0PQC3gWk1TMFneul4EGCCyHdBRtLnb4Bvay8thffoRJuXLAyLEXwhd0IGG1rSyq22q0MOV8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=IixaRVHT; arc=none smtp.client-ip=209.85.218.51
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Received: by mail-ej1-f51.google.com with SMTP id a640c23a62f3a-ad883afdf0cso440999866b.0
        for <io-uring@vger.kernel.org>; Fri, 30 May 2025 11:13:27 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1748628806; x=1749233606; darn=vger.kernel.org;
        h=content-transfer-encoding:in-reply-to:from:content-language
         :references:to:subject:user-agent:mime-version:date:message-id:from
         :to:cc:subject:date:message-id:reply-to;
        bh=2ktx1jhH3aDRKmLFvpBX2sGuYA8yVbyLbylLTjfSmO8=;
        b=IixaRVHTWq2keLn6ooIiIKyLUCN3L67CuxiAgrFEdOhxLxDFzY4MEGv4yUwoja92Iz
         N+ubTTXQwJHgQluN9+ydawBbio2lsF4Y4n3IENEcBW4ZJdrdXeGfpQRNI6Gx2lZoCKbS
         pIY7op1uxITvfxMBjn/4GyAbviLXfLuN/DLZGAr4LR/ZDsR2QYYAlBEaYFsbQemWuWYj
         JhEKCisrGHc5ewvxvB+4gUhI4gXyLpaZ1wZt5YFwmoQLu7oWd6e9yED85XsvrZFDQfYG
         pFtAw1wAxQgASe0oUYSf4G+TxCBTcIqe2bftvx2S/b3QlPJvk8pb7TDyCbjrfAqUSEkX
         +mRQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1748628806; x=1749233606;
        h=content-transfer-encoding:in-reply-to:from:content-language
         :references:to:subject:user-agent:mime-version:date:message-id
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=2ktx1jhH3aDRKmLFvpBX2sGuYA8yVbyLbylLTjfSmO8=;
        b=lkNmrv9tKair37L2qa5Qnbspx3MTRhMAtV7Cg5662l2vkgFckVB6AITvq7qmIETZRx
         eth4AjMrfIJoiBlPR3NStV9vEjkPiZazUjBG7Sehvd6OEJae8S2JvYSOkbXkMHomYQ92
         wpGqEqZSIzyl+9gJR80xaEY3qBRZPFg3fB7sTsegWYdw1zcqmiNcPOMFTwKDqBRdrYkA
         lbmwBAiaQZ947rndjLyPifEbsjoMIJ3G0Gysst7GSd5IAfE5Y4o6QZ5PDH7avAlWpOYw
         QUYe7xNJvtl2xFWgwMVXtcTn5FjxWesdQYyQ2jT73u9C3hGLdAhKhFai6JbuLj0ZVXC5
         2k+w==
X-Forwarded-Encrypted: i=1; AJvYcCV3roV3ReC2Injw53ReaZEtQvmpybpk7tz6hZzsDErKZAjseeUNdnDzfIN+m75A3rTQ9v1LF3AbdA==@vger.kernel.org
X-Gm-Message-State: AOJu0YwtkjAhkcRbMX9ZceKxHbXhABgxuPtDgRniBGGY3CxLjY55MhDm
	iT3PYCLKOXIGYvnl/z9vrrUUqZA3e50HeR1Ufobwg085VIqul6hHk1s6Q81LbQ==
X-Gm-Gg: ASbGncuE4I0jFDC3EGg1JtUPQDpjfO68ZRM8tmECeMQZeB02Hr1Z7Q8w3TfiHy819fc
	svcN6M3hlOWE4RDx0pH8VyWvX//XiFmNxEWefODb7x3n5t/bld+W5Qavh8ghmpnnPvSNck2UZbm
	8UcZvvENINxJJKmKIQ7Sz41KGLukcaM0tzxW0DqKeUbq35al3CaqhumUxaDFRFsoJ8BVfufWS77
	X04DONKGlAbugkrv6lw/Q1zCCyNTCwdvCOMB/RnQD3Qy38OcXmo/OwEdXDtgIwo5dlAYI2k7Uwg
	X4CwjuuOVUzTX8pRYeKvDqUzbB6Yov9Z5JmBXJu9Olp6QsBZsENN4JWD3vySZg==
X-Google-Smtp-Source: AGHT+IGR29yE0n6zPH7Qmn4xxHjpEk59V4/4/cLoYkpikIVgkF+ebi0G0I6c89y2QhrYON0JpQW1RA==
X-Received: by 2002:a17:907:969e:b0:ad8:9b5d:2c2a with SMTP id a640c23a62f3a-adb36b2394amr292026666b.24.1748628805900;
        Fri, 30 May 2025 11:13:25 -0700 (PDT)
Received: from [192.168.8.100] ([148.252.133.152])
        by smtp.gmail.com with ESMTPSA id a640c23a62f3a-adb2dbcd459sm249503266b.167.2025.05.30.11.13.24
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Fri, 30 May 2025 11:13:25 -0700 (PDT)
Message-ID: <b601b46f-d4b5-4ffc-af8a-3c2e58cdd62d@gmail.com>
Date: Fri, 30 May 2025 19:14:38 +0100
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
 <ac55e11c-feb2-45a3-84d4-d84badab477e@gmail.com>
 <d285d003-b160-4174-93bc-223bfbc7fd7c@kernel.dk>
Content-Language: en-US
From: Pavel Begunkov <asml.silence@gmail.com>
In-Reply-To: <d285d003-b160-4174-93bc-223bfbc7fd7c@kernel.dk>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit

On 5/30/25 16:30, Jens Axboe wrote:
> On 5/30/25 9:11 AM, Pavel Begunkov wrote:
>> On 5/30/25 15:41, Jens Axboe wrote:
>>> On 5/30/25 8:26 AM, Pavel Begunkov wrote:
>>>> On 5/30/25 15:12, Pavel Begunkov wrote:
>>>>> On 5/30/25 15:09, Pavel Begunkov wrote:
>>>>>> On 5/30/25 14:28, Jens Axboe wrote:
>>>>>>> On 5/30/25 6:51 AM, Pavel Begunkov wrote:
>>>>>>>> diff --git a/init/Kconfig b/init/Kconfig
>>>>>>>> index 63f5974b9fa6..9e8a5b810804 100644
>>>>>>>> --- a/init/Kconfig
>>>>>>>> +++ b/init/Kconfig
>>>>>>>> @@ -1774,6 +1774,17 @@ config GCOV_PROFILE_URING
>>>>>>>>           the io_uring subsystem, hence this should only be enabled for
>>>>>>>>           specific test purposes.
>>>>>>>> +config IO_URING_MOCK_FILE
>>>>>>>> +    tristate "Enable io_uring mock files (Experimental)" if EXPERT
>>>>>>>> +    default n
>>>>>>>> +    depends on IO_URING && KASAN
>>>>>>>> +    help
>>>>>>>> +      Enable mock files for io_uring subststem testing. The ABI might
>>>>>>>> +      still change, so it's still experimental and should only be enabled
>>>>>>>> +      for specific test purposes.
>>>>>>>> +
>>>>>>>> +      If unsure, say N.
>>>>>>>
>>>>>>> As mentioned in the other email, I don't think we should include KASAN
>>>>>>> here.
>>>>>>
>>>>>> I disagree. It's supposed to give a superset of coverage, if not,
>>>>>> mocking should be improved. It might be seen as a nuisance that you
>>>>>> can't run it with a stock kernel, but that desire is already half
>>>>>> step from "let's enable it for prod kernels for testing", and then
>>>>>> distributions will start forcing it on, because as you said "People
>>>>>> do all sorts of weird stuff".
>>>>>
>>>>> The purpose is to get the project even more hardened / secure through
>>>>> elaborate testing, that would defeat the purpose if non test systems
>>>>> will start getting errors because of some mess up, let's say in the
>>>>> driver.
>>>>
>>>> Alternatively, it doesn't help with bloating, but tainting the kernel
>>>> might be enough to serve the purpose.
>>>
>>> I think taint or KASAN dependencies is over-reaching. It has nothing to
>>> do with KASAN, and there's absolutely zero reason for it to be gated on
>>> KASAN (or lockdep, or whatever). You're never going to prevent people
>>> from running this in odd cases, and I think it's a mistake to try and do
>>> that. If the thing is gated on CAP_SYS_ADMIN, then that's Good Enough
>>> imho.
>>>
>>> It'll make my life harder for coverage testing, which I think is reason
>>> enough alone to not have a KASAN dependency. No other test code in the
>>> kernel has unrelated dependencies like KASAN, unless they are related to
>>> KASAN. We should not add one here for some notion of preventing people
>>> from running it on prod stuff, in fact it should be totally fine to run
>>> on a prod kernel. Might actually be useful in some cases, to verify or
>>> test some behavior on that specific kernel, without needing to build a
>>> new kernel for it.
>>
>> commit 2852ca7fba9f77b204f0fe953b31fadd0057c936
>> Author: David Gow <davidgow@google.com>
>> Date:   Fri Jul 1 16:47:41 2022 +0800
>>
>>      panic: Taint kernel if tests are run
>>          Most in-kernel tests (such as KUnit tests) are not supposed to run on
>>      production systems: they may do deliberately illegal things to trigger
>>      errors, and have security implications (for example, KUnit assertions
>>      will often deliberately leak kernel addresses).
>>          Add a new taint type, TAINT_TEST to signal that a test has been run.
>>      This will be printed as 'N' (originally for kuNit, as every other
>>      sensible letter was taken.)
>>          This should discourage people from running these tests on production
>>      systems, and to make it easier to tell if tests have been run
>>      accidentally (by loading the wrong configuration, etc.)
>>          Acked-by: Luis Chamberlain <mcgrof@kernel.org>
>>      Reviewed-by: Brendan Higgins <brendanhiggins@google.com>
>>      Signed-off-by: David Gow <davidgow@google.com>
>>      Signed-off-by: Shuah Khan <skhan@linuxfoundation.org>
>>
>>
>> The same situation, it's a special TAINT_TEST, and set for a good
>> reason. And there is also a case of TAINT_CRAP for staging.
> 
> TAINT is fine, I don't care about that. So we can certainly do that. My

Good you changed your mind

> main objection is just to gating it on lockdep/kasan or something like
> that.
> 

-- 
Pavel Begunkov


