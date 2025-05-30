Return-Path: <io-uring+bounces-8165-lists+io-uring=lfdr.de@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [IPv6:2604:1380:4601:e00::3])
	by mail.lfdr.de (Postfix) with ESMTPS id F3B3DAC928B
	for <lists+io-uring@lfdr.de>; Fri, 30 May 2025 17:30:35 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id C08621C07AB9
	for <lists+io-uring@lfdr.de>; Fri, 30 May 2025 15:30:49 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 4CD8F192B75;
	Fri, 30 May 2025 15:30:31 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel-dk.20230601.gappssmtp.com header.i=@kernel-dk.20230601.gappssmtp.com header.b="M0UxUqyR"
X-Original-To: io-uring@vger.kernel.org
Received: from mail-il1-f181.google.com (mail-il1-f181.google.com [209.85.166.181])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5703F194C75
	for <io-uring@vger.kernel.org>; Fri, 30 May 2025 15:30:26 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.166.181
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1748619031; cv=none; b=RrqXLB/NEFcz3MQ4KHiKpBHJgsNIIObFymc7SiO8EtAXNiwyHAxs+DvmnQ6rg7lEHg35/UGRaqCOsnSa2hvZ1h9pp9vOaCX7WvEzAAn1KDejpIkA8qxeA1XbM72MSLuRlitStLwpOdvY83CoTJSHC7L211GVKOWPXcfJj2kbLOc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1748619031; c=relaxed/simple;
	bh=Wd7Zh32dR6d95tM+lRG0/0FbzgrYLZRrlEGTUfB8/v4=;
	h=Message-ID:Date:MIME-Version:Subject:To:References:From:
	 In-Reply-To:Content-Type; b=uoZnbON+l3ibcxWNFvHkLcIBvOItq7T02Bp6N088dmycQCpFJYDs1CWRmYBNlEESfCRkrh/HgPA6akyBmnm+Fy9G270g8jInAnSsi8Mm0+T8qw9DqF0p5idIoth8XsQ62a7MY4z7DCoiCG+Ovk1JvJvWlenySbLhv1cqZz5Knmg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=kernel.dk; spf=pass smtp.mailfrom=kernel.dk; dkim=pass (2048-bit key) header.d=kernel-dk.20230601.gappssmtp.com header.i=@kernel-dk.20230601.gappssmtp.com header.b=M0UxUqyR; arc=none smtp.client-ip=209.85.166.181
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=kernel.dk
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=kernel.dk
Received: by mail-il1-f181.google.com with SMTP id e9e14a558f8ab-3dd87b83302so7429555ab.0
        for <io-uring@vger.kernel.org>; Fri, 30 May 2025 08:30:26 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernel-dk.20230601.gappssmtp.com; s=20230601; t=1748619025; x=1749223825; darn=vger.kernel.org;
        h=content-transfer-encoding:in-reply-to:from:content-language
         :references:to:subject:user-agent:mime-version:date:message-id:from
         :to:cc:subject:date:message-id:reply-to;
        bh=Ej1nIHar2/CESGiGepq7UyvinGdIFXNcH5mC9ceLxFg=;
        b=M0UxUqyRt3/bw+7dvdQqKa6fdhAF3ek5Hf/zn00XlWu14B7xhIW973Pm6juu8fJn2y
         jJeYcx7OQbNL8fBxCGe2PUvll5J9S6Yq/n+vWopw295mBDC5/ZCA0tHLOw1R3i36MLj3
         MTAhz9QwF9Ppp9ak+9aqsEYOAZXMpeZEIfWhtMh1qNJRT6zXZ66Ivfp4ijsx5LmqTdmg
         Z5RZClhfu6PpPVVi2/chqqrdJH8BnL38mnoV5kN7g9hi2wW5A+y4RcdzhKdFhL7V1Hb/
         XiJNrqdGXFSKT89MtgnTwImW0YtwaI6nJR9tXv2OFzuxEnp8lR0hwibPoteDH53nxn+s
         0oiQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1748619025; x=1749223825;
        h=content-transfer-encoding:in-reply-to:from:content-language
         :references:to:subject:user-agent:mime-version:date:message-id
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=Ej1nIHar2/CESGiGepq7UyvinGdIFXNcH5mC9ceLxFg=;
        b=ErVaZm269aZm6jFrUU0j1CsjQ19I0Olh0H5d1/Suep0izs5k8WC0vI//AREwDxNgGK
         vvnSaBPAIFl+1HM+FOYs7w1W6PqEzcZolaXI0TwcWGiB7tXH1vknTwj4Gy6vNeYo7hBb
         P4ick0xvgGq7dH23LfhVPIxawSPotNQBkAsSINl7lycpuO9HQYi06iZ0ksWYy5Y0jQfU
         zQZThZoKvGB2ewtGCEhUU2SM+CMdi2etpCnkJ3TRP6pyUf70tkne0617kldJ5uR/bh5e
         Mq9L0dAfK9AHbMWBGcI7riFIcMSK/eEGOdKEwvpNQd+KntlvMJM5ieF35rAU2AwRuTL6
         g75w==
X-Forwarded-Encrypted: i=1; AJvYcCV7fvGk1bYOuaB9xcspgo69E5QOCgCvMza637rMigUDnaNfjAcQn5oaaZOsavTY2MwdWjZmBZJB8A==@vger.kernel.org
X-Gm-Message-State: AOJu0YxwzIG+iDU3M0qMORuCkYa086ePYVqgZZOd7gV1SEvE+KB4vd8J
	orkR6o3lNP25Be6vmKXQ42MIp9K+j/nUcPHn0XA9gt2Sa0enS0Xbbq0DH0PTzpPN1KpB9ZyoFsX
	htWMW
X-Gm-Gg: ASbGncvYm8eaHCdeRPYToz/VC3U4p3BtSro8YevH1L6u8A7ZvlAm+0drYwEQyb0KByd
	LrT+ZOtph+3Yr5Se75O93VpYDeyBVYFjShLadJzII3whQdLVNMu8hC54z6mdA8GNMmhjJbAqez+
	BbCvX5zeOkgj9HypC1jg6AkAPoAdodZYhxU+hlZJp5zDIQB/03AmBNwe8v0jg7wz2MnWBSOahE6
	Um0H1ucP94Db5oYmeYyA3kvzbPhBJW5t8C5pnjuSgMcpJCbFu/oIU7lVLha/Ka6od4SiFRyJE4i
	nOVnr4BqxaUMfLe+FWzRMp0F701sZaqfOHXCCCgTxKOVsXk=
X-Google-Smtp-Source: AGHT+IHMuEQ79nn31BriIsIoTYqoCALd1BDGSKbregSizZHeGF9HdJ84VkkgGnh09l6B9t5Iiu10qw==
X-Received: by 2002:a92:cd8b:0:b0:3dc:8b29:3097 with SMTP id e9e14a558f8ab-3dd99bff75cmr50281985ab.12.1748619023820;
        Fri, 30 May 2025 08:30:23 -0700 (PDT)
Received: from [192.168.1.116] ([96.43.243.2])
        by smtp.gmail.com with ESMTPSA id 8926c6da1cb9f-4fdd7e28db9sm492037173.49.2025.05.30.08.30.23
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Fri, 30 May 2025 08:30:23 -0700 (PDT)
Message-ID: <d285d003-b160-4174-93bc-223bfbc7fd7c@kernel.dk>
Date: Fri, 30 May 2025 09:30:22 -0600
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
Content-Language: en-US
From: Jens Axboe <axboe@kernel.dk>
In-Reply-To: <ac55e11c-feb2-45a3-84d4-d84badab477e@gmail.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit

On 5/30/25 9:11 AM, Pavel Begunkov wrote:
> On 5/30/25 15:41, Jens Axboe wrote:
>> On 5/30/25 8:26 AM, Pavel Begunkov wrote:
>>> On 5/30/25 15:12, Pavel Begunkov wrote:
>>>> On 5/30/25 15:09, Pavel Begunkov wrote:
>>>>> On 5/30/25 14:28, Jens Axboe wrote:
>>>>>> On 5/30/25 6:51 AM, Pavel Begunkov wrote:
>>>>>>> diff --git a/init/Kconfig b/init/Kconfig
>>>>>>> index 63f5974b9fa6..9e8a5b810804 100644
>>>>>>> --- a/init/Kconfig
>>>>>>> +++ b/init/Kconfig
>>>>>>> @@ -1774,6 +1774,17 @@ config GCOV_PROFILE_URING
>>>>>>>          the io_uring subsystem, hence this should only be enabled for
>>>>>>>          specific test purposes.
>>>>>>> +config IO_URING_MOCK_FILE
>>>>>>> +    tristate "Enable io_uring mock files (Experimental)" if EXPERT
>>>>>>> +    default n
>>>>>>> +    depends on IO_URING && KASAN
>>>>>>> +    help
>>>>>>> +      Enable mock files for io_uring subststem testing. The ABI might
>>>>>>> +      still change, so it's still experimental and should only be enabled
>>>>>>> +      for specific test purposes.
>>>>>>> +
>>>>>>> +      If unsure, say N.
>>>>>>
>>>>>> As mentioned in the other email, I don't think we should include KASAN
>>>>>> here.
>>>>>
>>>>> I disagree. It's supposed to give a superset of coverage, if not,
>>>>> mocking should be improved. It might be seen as a nuisance that you
>>>>> can't run it with a stock kernel, but that desire is already half
>>>>> step from "let's enable it for prod kernels for testing", and then
>>>>> distributions will start forcing it on, because as you said "People
>>>>> do all sorts of weird stuff".
>>>>
>>>> The purpose is to get the project even more hardened / secure through
>>>> elaborate testing, that would defeat the purpose if non test systems
>>>> will start getting errors because of some mess up, let's say in the
>>>> driver.
>>>
>>> Alternatively, it doesn't help with bloating, but tainting the kernel
>>> might be enough to serve the purpose.
>>
>> I think taint or KASAN dependencies is over-reaching. It has nothing to
>> do with KASAN, and there's absolutely zero reason for it to be gated on
>> KASAN (or lockdep, or whatever). You're never going to prevent people
>> from running this in odd cases, and I think it's a mistake to try and do
>> that. If the thing is gated on CAP_SYS_ADMIN, then that's Good Enough
>> imho.
>>
>> It'll make my life harder for coverage testing, which I think is reason
>> enough alone to not have a KASAN dependency. No other test code in the
>> kernel has unrelated dependencies like KASAN, unless they are related to
>> KASAN. We should not add one here for some notion of preventing people
>> from running it on prod stuff, in fact it should be totally fine to run
>> on a prod kernel. Might actually be useful in some cases, to verify or
>> test some behavior on that specific kernel, without needing to build a
>> new kernel for it.
> 
> commit 2852ca7fba9f77b204f0fe953b31fadd0057c936
> Author: David Gow <davidgow@google.com>
> Date:   Fri Jul 1 16:47:41 2022 +0800
> 
>     panic: Taint kernel if tests are run
>         Most in-kernel tests (such as KUnit tests) are not supposed to run on
>     production systems: they may do deliberately illegal things to trigger
>     errors, and have security implications (for example, KUnit assertions
>     will often deliberately leak kernel addresses).
>         Add a new taint type, TAINT_TEST to signal that a test has been run.
>     This will be printed as 'N' (originally for kuNit, as every other
>     sensible letter was taken.)
>         This should discourage people from running these tests on production
>     systems, and to make it easier to tell if tests have been run
>     accidentally (by loading the wrong configuration, etc.)
>         Acked-by: Luis Chamberlain <mcgrof@kernel.org>
>     Reviewed-by: Brendan Higgins <brendanhiggins@google.com>
>     Signed-off-by: David Gow <davidgow@google.com>
>     Signed-off-by: Shuah Khan <skhan@linuxfoundation.org>
> 
> 
> The same situation, it's a special TAINT_TEST, and set for a good
> reason. And there is also a case of TAINT_CRAP for staging.

TAINT is fine, I don't care about that. So we can certainly do that. My
main objection is just to gating it on lockdep/kasan or something like
that.

-- 
Jens Axboe

