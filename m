Return-Path: <io-uring+bounces-4942-lists+io-uring=lfdr.de@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [IPv6:2604:1380:4601:e00::3])
	by mail.lfdr.de (Postfix) with ESMTPS id 110DC9D5299
	for <lists+io-uring@lfdr.de>; Thu, 21 Nov 2024 19:35:22 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id 8A86E1F21FCB
	for <lists+io-uring@lfdr.de>; Thu, 21 Nov 2024 18:35:21 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 3BAFE1A2574;
	Thu, 21 Nov 2024 18:35:16 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel-dk.20230601.gappssmtp.com header.i=@kernel-dk.20230601.gappssmtp.com header.b="riv6zpD6"
X-Original-To: io-uring@vger.kernel.org
Received: from mail-oa1-f41.google.com (mail-oa1-f41.google.com [209.85.160.41])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 35E6B6F06B
	for <io-uring@vger.kernel.org>; Thu, 21 Nov 2024 18:35:13 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.160.41
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1732214116; cv=none; b=QZo7KLyMee9PY8TuXkE6FFEQeBVeg3c4OXO4WuS87SW5bB1G4jpwws5hpLeBu7/P5mSLLjJfIgn0H7pvHr4aTD4YBx208MVx4iQP7KyNLGa05MtQJHtl6NDiKbc1QgxLqGBu3yzxclnLhtEPaddTqEJAnH2G8fYQZL55UFYd7K4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1732214116; c=relaxed/simple;
	bh=sxEt5QHQVWebuJzi/ZocdkWCv5jV6t5UCOUoxd5WEPQ=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=B/t7yYo6q09wX/A3+9sL1CFk2vAlFFrxiq3SIUzf4GNaE7neyekGuYFjOyIVxjQR+CVjy5C0Cr+NdX6//Q6TNUVP/UG0PUnQeGHCoMjmgZ3cQyx3O2jQXql75WEzWval+m/ksyAthrkLA5wmjk98cQdX5Aw9nqsyS6TJPzwX1D0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=kernel.dk; spf=pass smtp.mailfrom=kernel.dk; dkim=pass (2048-bit key) header.d=kernel-dk.20230601.gappssmtp.com header.i=@kernel-dk.20230601.gappssmtp.com header.b=riv6zpD6; arc=none smtp.client-ip=209.85.160.41
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=kernel.dk
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=kernel.dk
Received: by mail-oa1-f41.google.com with SMTP id 586e51a60fabf-27d0e994ae3so647569fac.3
        for <io-uring@vger.kernel.org>; Thu, 21 Nov 2024 10:35:13 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernel-dk.20230601.gappssmtp.com; s=20230601; t=1732214113; x=1732818913; darn=vger.kernel.org;
        h=content-transfer-encoding:in-reply-to:from:content-language
         :references:cc:to:subject:user-agent:mime-version:date:message-id
         :from:to:cc:subject:date:message-id:reply-to;
        bh=mbqhQuLd+DrrA6T8L2Ps3K6JSpl7CQfQrjhLlkd4Ce8=;
        b=riv6zpD6gKoahr9CvmQFTmST+QAMwSYFLMwaQsEgTVOGBMNidnBQMiPwwp0yJDBzSw
         Z9AI7AtV7wV3TO6Z9iYwlNVHhth2gkvTHr/wmDzQTM5Jv0Ge2Qc23S3YG4BjXCeNLbNI
         5g/h8/lF7ZhQ1vxYAAJWNcLELLfgupR8idnFSKZBm8NRE0p2Mh4CcKXFriWORjbeG8kZ
         Fs4d/Qo54oWRxwZyb1a3bnQucfc9q19ThmnzMjb6R3Qd9ObuhMixUAje/zbHfX0+cFSC
         PnTVQ9LG6qhIV1U27+vJGGpV/4o5kP2Qq6DqeosRpMQikmZewa45q5SHGcPHU+Dz5Bnb
         dyZg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1732214113; x=1732818913;
        h=content-transfer-encoding:in-reply-to:from:content-language
         :references:cc:to:subject:user-agent:mime-version:date:message-id
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=mbqhQuLd+DrrA6T8L2Ps3K6JSpl7CQfQrjhLlkd4Ce8=;
        b=wc3Rd6zUHaFngj13xkzapHrr9KFpecgcwBkGBts6hShUJPjgUyMmaqPMT3VoBdM6pG
         3QFhU8/L7wjey9gIlkZAyfJE9kMHETIoogmqUx41KdtKt7kiUcBdrn08WdRjmGUyZBOw
         dgOmbJPHBFDKD3G+CRUtCuA+WZpQGDwBxFArPsKDA1qcebLYk8z4HUlZthO6IIDw8hfG
         DLEDhzV3F/VxudTCCjnCeZ/hNAH/zUlA53rX62uCO7h8DGWDku+NsBdvDNqFE383t7oZ
         rp97n5JQjE08oI7sk34FbhFyv+gKWWuk7aRCqTpHR7qK4Tck8HcSMdcoL2ArCZGzz9IX
         C49A==
X-Forwarded-Encrypted: i=1; AJvYcCVRMA2G8f5bCRm+u8AofTTYXvpKx8TmzFegAIo0lPCgXkQX+n6vt+Mx23/fnmmlwzsKsi4kG7fzSA==@vger.kernel.org
X-Gm-Message-State: AOJu0YykXLT94/NG0XLfRh+Lv9kOaSSwiIUEoG22v3LUzT5VA5URGjE9
	nNPeTQWzf0IHp2Z9JUiICIpDI5Y8nv4LPnpgMev0Fsls62Fs1ivRcUu/KnWyeEU=
X-Gm-Gg: ASbGncs9nBQD4z1td/rs8bfv6b9b/fCsS0xrlJYZ47ab6c8pPi1yf0ahMr6ilHIdNMC
	JonwmVooH8/WqRUNHGtOhs7VIRcyd8Jl4Sa/Es7NJpQXGWiHadjjz7LuHmiYukUaCI6ObIWt2Pj
	Rp78K1kF12P1+jsVXJbBrcILQkeTpELm3UT2rGOAJ+Cs+81rQivrYiQJpfL5BFwMLrqKjmzx7HX
	EE5sTKkyot6v9FqzOm1s3ZVIAH+U5xBISX9VOvHdRiuVw==
X-Google-Smtp-Source: AGHT+IGQ9k8wS2TS60qT8IVjc3fnuFCoLgHqv0GNMp58Q1HLV2LNWsVqKRLFgpF9Cw9p6ZAQqUdenA==
X-Received: by 2002:a05:6870:9619:b0:296:b0d8:9025 with SMTP id 586e51a60fabf-296d9bcedd8mr8467428fac.20.1732214113009;
        Thu, 21 Nov 2024 10:35:13 -0800 (PST)
Received: from [192.168.1.116] ([96.43.243.2])
        by smtp.gmail.com with ESMTPSA id 586e51a60fabf-2971d87e96dsm52987fac.45.2024.11.21.10.35.11
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Thu, 21 Nov 2024 10:35:12 -0800 (PST)
Message-ID: <3fe55eba-1a8c-464f-8598-6068ce03f296@kernel.dk>
Date: Thu, 21 Nov 2024 11:35:10 -0700
Precedence: bulk
X-Mailing-List: io-uring@vger.kernel.org
List-Id: <io-uring.vger.kernel.org>
List-Subscribe: <mailto:io-uring+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:io-uring+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH] slab: Fix too strict alignment check in create_cache()
To: Guenter Roeck <linux@roeck-us.net>,
 "Christoph Lameter (Ampere)" <cl@gentwo.org>
Cc: Geert Uytterhoeven <geert@linux-m68k.org>,
 Vlastimil Babka <vbabka@suse.cz>, Pekka Enberg <penberg@kernel.org>,
 David Rientjes <rientjes@google.com>, Joonsoo Kim <iamjoonsoo.kim@lge.com>,
 Andrew Morton <akpm@linux-foundation.org>,
 Roman Gushchin <roman.gushchin@linux.dev>,
 Hyeonggon Yoo <42.hyeyoo@gmail.com>, Pavel Begunkov
 <asml.silence@gmail.com>, Mike Rapoport <rppt@kernel.org>,
 Christian Brauner <brauner@kernel.org>, Kees Cook <keescook@chromium.org>,
 Jann Horn <jannh@google.com>, linux-mm@kvack.org, io-uring@vger.kernel.org,
 linux-m68k@vger.kernel.org, linux-kernel@vger.kernel.org
References: <80c767a5d5927c099aea5178fbf2c897b459fa90.1732106544.git.geert@linux-m68k.org>
 <4f70f8d3-4ba5-43dc-af1c-f8e207d27e9f@suse.cz>
 <2e704ffc-2e79-27f7-159e-8fe167d5a450@gentwo.org>
 <CAMuHMdWQisrjqaPPd0xLgtSAxRwnxCPdsqnWSncMiPYLnre2MA@mail.gmail.com>
 <693a6243-b2bd-7f2b-2b69-c7e2308d0f58@gentwo.org>
 <f602e322-af21-4bb3-86d4-52795a581354@roeck-us.net>
Content-Language: en-US
From: Jens Axboe <axboe@kernel.dk>
In-Reply-To: <f602e322-af21-4bb3-86d4-52795a581354@roeck-us.net>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit

On 11/21/24 11:30 AM, Guenter Roeck wrote:
> On Thu, Nov 21, 2024 at 09:23:28AM -0800, Christoph Lameter (Ampere) wrote:
>> On Thu, 21 Nov 2024, Geert Uytterhoeven wrote:
>>
>>> Linux has supported m68k since last century.
>>
>> Yeah I fondly remember the 80s where 68K systems were always out of reach
>> for me to have. The dream system that I never could get my hands on. The
>> creme de la creme du jour. I just had to be content with the 6800 and
>> 6502 processors. Then IBM started the sick road down the 8088, 8086
>> that led from crap to more crap. Sigh.
>>
>>> Any new such assumptions are fixed quickly (at least in the kernel).
>>> If you need a specific alignment, make sure to use __aligned and/or
>>> appropriate padding in structures.
>>> And yes, the compiler knows, and provides __alignof__.
>>>
>>>> How do you deal with torn reads/writes in such a scenario? Is this UP
>>>> only?
>>>
>>> Linux does not support (rate) SMP m68k machines.
>>
>> Ah. Ok that explains it.
>>
>> Do we really need to maintain support for a platform that has been
>> obsolete for decade and does not even support SMP?

I asked that earlier in this thread too...

> Since this keeps coming up, I think there is a much more important
> question to ask:
> 
> Do we really need to continue supporting nommu machines ? Is anyone
> but me even boot testing those ?

Getting rid of nommu would be nice for sure in terms of maintenance,
it's one of those things that pop up as a build breaking thing because
nobody is using/testing them.

I'm all for axing relics from the codebase. Doesn't mean they can't be
maintained out-of-tree, but that is where they belong imho.

-- 
Jens Axboe

