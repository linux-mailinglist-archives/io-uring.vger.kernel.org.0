Return-Path: <io-uring+bounces-8162-lists+io-uring=lfdr.de@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [147.75.80.249])
	by mail.lfdr.de (Postfix) with ESMTPS id F2EFAAC91BE
	for <lists+io-uring@lfdr.de>; Fri, 30 May 2025 16:42:54 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id A2C80188693A
	for <lists+io-uring@lfdr.de>; Fri, 30 May 2025 14:42:11 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 8BDDB232395;
	Fri, 30 May 2025 14:41:50 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel-dk.20230601.gappssmtp.com header.i=@kernel-dk.20230601.gappssmtp.com header.b="ueraS46t"
X-Original-To: io-uring@vger.kernel.org
Received: from mail-io1-f52.google.com (mail-io1-f52.google.com [209.85.166.52])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 97302212B2F
	for <io-uring@vger.kernel.org>; Fri, 30 May 2025 14:41:48 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.166.52
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1748616110; cv=none; b=Gz1Nb8bFyGbMltTErt/IUM15N0u6SFM01EdvVUWRbz3OH6LywtA4simBSpvlXbsn8ROwNbbP636aHxrlhpb4L1u2UdgH+0SVnBAg0/aSqh7EVxTB2roaE83k7jKRl6yQw1DDJBQlyFBw2qjUmXslIQKPVwTyZaOaKn4DMJXutEU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1748616110; c=relaxed/simple;
	bh=cH+jHRQZZ4lybGI+bPYwgs21ep2omDsAt1EnhYyAnVI=;
	h=Message-ID:Date:MIME-Version:Subject:To:References:From:
	 In-Reply-To:Content-Type; b=mdXVTprwKpV/SIyi+SOVNqOFw1WYTpnkTVRuZAg+3kA0ROlhiR3PNREtiMuh4M34SXjqiQIa1Q+otQ5YQub9AANoOoWsFKdh8lmrxMnaQG10i1KH+7hBO+NMF8zV3pfw79h38U0zBmiBavyxbrOxBE4ugmJ2fL/esi1z5Xa36Po=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=kernel.dk; spf=pass smtp.mailfrom=kernel.dk; dkim=pass (2048-bit key) header.d=kernel-dk.20230601.gappssmtp.com header.i=@kernel-dk.20230601.gappssmtp.com header.b=ueraS46t; arc=none smtp.client-ip=209.85.166.52
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=kernel.dk
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=kernel.dk
Received: by mail-io1-f52.google.com with SMTP id ca18e2360f4ac-86a55400875so152913839f.3
        for <io-uring@vger.kernel.org>; Fri, 30 May 2025 07:41:48 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernel-dk.20230601.gappssmtp.com; s=20230601; t=1748616107; x=1749220907; darn=vger.kernel.org;
        h=content-transfer-encoding:in-reply-to:from:content-language
         :references:to:subject:user-agent:mime-version:date:message-id:from
         :to:cc:subject:date:message-id:reply-to;
        bh=Q3894dmhrCv9jfQjM9VXT3z4JOrIdEv5dBQNfOjj3N0=;
        b=ueraS46tFv2A7Dx+Xc/QzMBWpPGND16Khqjx49VXjaBdOmQBcN0ozM0JIIzhp8nXSI
         yo9u4bXV/kIUlDPoX3AXnDDIdhCgWe/xLCXjsznJ3vysy45cuVZ7gT/27KClN0uO7KmJ
         Il6Rp/I5nx8NYS7hmyd6bvOOKzvIdqwrMudIUHXbwkxgqNqGMCuJOY/ly7vMh/rJWw82
         H36MK7X1EPC4Us7Br/wsUy/IxV/qLMR/ksnfhVlc8JoYgGSWno8R7kJTKtK5yCMI6PV0
         Xhy/e0t60mjNMt+7Qc0iT3fnVgAxw1lVBV3JcCWEWGV4WYNCBP0f8m3BGIG64FXLttbj
         Ydkw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1748616107; x=1749220907;
        h=content-transfer-encoding:in-reply-to:from:content-language
         :references:to:subject:user-agent:mime-version:date:message-id
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=Q3894dmhrCv9jfQjM9VXT3z4JOrIdEv5dBQNfOjj3N0=;
        b=iP3fTSIHHwrea4TRqizWgVwN+uuMGamoORpETP2rSIXSffgJtaktBSk+b9zaE6kEpv
         SPlOECOx6AQ1tc+GctVr7x8+NFlDfRSy4NVAAfKpCffYQuGlCTcxrtTPob8Qvt1gPmSm
         H+JSj0O6C/sM7TSE6dETZgSzLEGZ6cVsdl39miqZ/m5ryepf10FRiGY9NP/cmNhhUK+O
         TY2W47JVJuHB4CzIeUQrXbl40YDEP09gcduQo3AOSffbMiGVdUjYsLM4sSXmhUJKvJO1
         fwUuTmfxzFVLq2K/WPfQossrLQGK3y4Eooa32LTf/muxBgQEuPPyGp3kLgxeFLMPtqkM
         A+ng==
X-Forwarded-Encrypted: i=1; AJvYcCVCkDOjrA/CDzo0k3FDUdgKxBbTJYrIYObDr6glYBY06yvCs0cifOlrlbJZbJr7nzC/VCIy3PXxbw==@vger.kernel.org
X-Gm-Message-State: AOJu0YyvyNAaF944bj+20kliY5IUDc4gfv+oQ8jkHqt3e7UMUhBwwLhR
	N0k6ebs4WTTc2bsW5SCeCTFRbcF89Q1e1GC5ILGZs6U5VRM6unHtaH4AdlDP+RoaDuBktbX6B/b
	Qnn06
X-Gm-Gg: ASbGncvcEbKGHKn4Rh6UnWRVmHqjz4CJ/R6baOq3j1Z7M6gUG4YJy8XzOGmxsiZbIno
	uj+Uh6sA/jGqWXd52szb9sbYwYyhgk/2M+NN/hFOFhswoCvl59YO7gkY3yxzfupviSTZsNUTO8Y
	cfTRNPSrWYUN67rwTYP6cIyT6kMnMYm1qCZGDTmzwYQz0FA9hWSPUvjCry3h5EiJgS7x0+D+4OP
	LhvwYfLQMYa02N95mjxQEiOPxbYZUkgza/MEBPvBIkY10/2Qp+89UinrplRjBPehV8D4O+QAA8z
	PY48ncjNT6BiRvqxV4aimVV29pUrPQjcnFUmGcSl6JyMWGxP+OLp/1dfNQ==
X-Google-Smtp-Source: AGHT+IEETxwDRKY9il1ZUBlV2VBcuKHYUmxfDGKgZOQwi+jGpERASbUXnq4TVLKI9EyGi/2Vxv5WYg==
X-Received: by 2002:a05:6602:3806:b0:86c:f2c1:70d9 with SMTP id ca18e2360f4ac-86d00099634mr486465539f.3.1748616107573;
        Fri, 30 May 2025 07:41:47 -0700 (PDT)
Received: from [192.168.1.116] ([96.43.243.2])
        by smtp.gmail.com with ESMTPSA id 8926c6da1cb9f-4fdd7ed91f2sm479653173.87.2025.05.30.07.41.46
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Fri, 30 May 2025 07:41:47 -0700 (PDT)
Message-ID: <311e2d72-3b30-444e-bd18-a39060e5e9fa@kernel.dk>
Date: Fri, 30 May 2025 08:41:46 -0600
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
Content-Language: en-US
From: Jens Axboe <axboe@kernel.dk>
In-Reply-To: <8cdda5c4-5b05-4960-90e2-478417be6faf@gmail.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit

On 5/30/25 8:26 AM, Pavel Begunkov wrote:
> On 5/30/25 15:12, Pavel Begunkov wrote:
>> On 5/30/25 15:09, Pavel Begunkov wrote:
>>> On 5/30/25 14:28, Jens Axboe wrote:
>>>> On 5/30/25 6:51 AM, Pavel Begunkov wrote:
>>>>> diff --git a/init/Kconfig b/init/Kconfig
>>>>> index 63f5974b9fa6..9e8a5b810804 100644
>>>>> --- a/init/Kconfig
>>>>> +++ b/init/Kconfig
>>>>> @@ -1774,6 +1774,17 @@ config GCOV_PROFILE_URING
>>>>>         the io_uring subsystem, hence this should only be enabled for
>>>>>         specific test purposes.
>>>>> +config IO_URING_MOCK_FILE
>>>>> +    tristate "Enable io_uring mock files (Experimental)" if EXPERT
>>>>> +    default n
>>>>> +    depends on IO_URING && KASAN
>>>>> +    help
>>>>> +      Enable mock files for io_uring subststem testing. The ABI might
>>>>> +      still change, so it's still experimental and should only be enabled
>>>>> +      for specific test purposes.
>>>>> +
>>>>> +      If unsure, say N.
>>>>
>>>> As mentioned in the other email, I don't think we should include KASAN
>>>> here.
>>>
>>> I disagree. It's supposed to give a superset of coverage, if not,
>>> mocking should be improved. It might be seen as a nuisance that you
>>> can't run it with a stock kernel, but that desire is already half
>>> step from "let's enable it for prod kernels for testing", and then
>>> distributions will start forcing it on, because as you said "People
>>> do all sorts of weird stuff".
>>
>> The purpose is to get the project even more hardened / secure through
>> elaborate testing, that would defeat the purpose if non test systems
>> will start getting errors because of some mess up, let's say in the
>> driver.
> 
> Alternatively, it doesn't help with bloating, but tainting the kernel
> might be enough to serve the purpose.

I think taint or KASAN dependencies is over-reaching. It has nothing to
do with KASAN, and there's absolutely zero reason for it to be gated on
KASAN (or lockdep, or whatever). You're never going to prevent people
from running this in odd cases, and I think it's a mistake to try and do
that. If the thing is gated on CAP_SYS_ADMIN, then that's Good Enough
imho.

It'll make my life harder for coverage testing, which I think is reason
enough alone to not have a KASAN dependency. No other test code in the
kernel has unrelated dependencies like KASAN, unless they are related to
KASAN. We should not add one here for some notion of preventing people
from running it on prod stuff, in fact it should be totally fine to run
on a prod kernel. Might actually be useful in some cases, to verify or
test some behavior on that specific kernel, without needing to build a
new kernel for it.

-- 
Jens Axboe

