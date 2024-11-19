Return-Path: <io-uring+bounces-4840-lists+io-uring=lfdr.de@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [IPv6:2604:1380:4601:e00::3])
	by mail.lfdr.de (Postfix) with ESMTPS id 1C9DF9D2E72
	for <lists+io-uring@lfdr.de>; Tue, 19 Nov 2024 20:00:33 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id 98CE51F23725
	for <lists+io-uring@lfdr.de>; Tue, 19 Nov 2024 19:00:32 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 2D5FC43179;
	Tue, 19 Nov 2024 19:00:28 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel-dk.20230601.gappssmtp.com header.i=@kernel-dk.20230601.gappssmtp.com header.b="iqLu+R9N"
X-Original-To: io-uring@vger.kernel.org
Received: from mail-oa1-f44.google.com (mail-oa1-f44.google.com [209.85.160.44])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 499CD1D0E06
	for <io-uring@vger.kernel.org>; Tue, 19 Nov 2024 19:00:12 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.160.44
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1732042828; cv=none; b=ma67bVWkYxIcmnyuLr4m7hY17+g5pq5HIv/QxG9CJDAYRl/61o8rhHPpwxexbmJlvzEqwPc4kNDPrLHBT45NHYF7lgpjS8Qm/i9Xyay4BnZG/lq7o9J7oIwaLkFID072V+Mjt/bTa1F9eoPzzSetTD2NaHvEwd3UIRAOlqw34BI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1732042828; c=relaxed/simple;
	bh=ju8kW288JZ4YeYS+Bf4HB8WeGroHgfelm7KLKhW4aDc=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=mQ+LsXlkwe188AJorKbWsg9zesvvNhlH5prn749X6OJEWEKrsafH2+WoQGxYPHl9GNpBkIVAUne7Racj3RHj+NawKYt44Ru1npfM5gzx67izEgEb1nT7yZTcn0MA2AJRdUlUVtgokFzAfqqPlQlkGk50DyGANv6d7jTbMxYTSW4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=kernel.dk; spf=pass smtp.mailfrom=kernel.dk; dkim=pass (2048-bit key) header.d=kernel-dk.20230601.gappssmtp.com header.i=@kernel-dk.20230601.gappssmtp.com header.b=iqLu+R9N; arc=none smtp.client-ip=209.85.160.44
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=kernel.dk
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=kernel.dk
Received: by mail-oa1-f44.google.com with SMTP id 586e51a60fabf-29685066b8dso1394250fac.1
        for <io-uring@vger.kernel.org>; Tue, 19 Nov 2024 11:00:12 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernel-dk.20230601.gappssmtp.com; s=20230601; t=1732042811; x=1732647611; darn=vger.kernel.org;
        h=content-transfer-encoding:in-reply-to:from:content-language
         :references:cc:to:subject:user-agent:mime-version:date:message-id
         :from:to:cc:subject:date:message-id:reply-to;
        bh=ln5mYsUFfvvZNO5jIK8wHispzs9EDY5ZgCeN+cWWrpA=;
        b=iqLu+R9NofTkdhWczk8hXko3L3AQ3NQP32OADaitxwb0WOCTlzFpVRicp9lZihR7Tj
         k9puP3KCaLl3Qia8vf9BSfMErSSac//EPiodKCWRo5FGxaReIHkV7JMuw6KnaeoD4qId
         F3qyKBBs8T9SVfE8ZNVlwEjaeWUV/8vJ1myoKqiqUjoJIXIEw4MUilCOhXQ75wIxUaIA
         Cjmka9L17JzZNgudPYAyaJqJwD/7s9Fn8Nx9CFCkvCWle8WflywlMOOJjf8E4KMGBBvM
         IdouSIPvjubGBNjvAZImUjsPasnZjkIXF2Nxh+By7Ie8w5eS/e78MFimlZFKjsZDNoJw
         lVQg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1732042811; x=1732647611;
        h=content-transfer-encoding:in-reply-to:from:content-language
         :references:cc:to:subject:user-agent:mime-version:date:message-id
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=ln5mYsUFfvvZNO5jIK8wHispzs9EDY5ZgCeN+cWWrpA=;
        b=HUc/TGbEYyuwpJ4Vw6/JL0o9B7RBuQtjzWLc3bHUcGOWA5kEI8nKcTSwsTio3qUsHa
         va4OphWPm/wKooBUGcHJkHBkHMD5X6nrHcHoDLR+I15ETc8R76npNjis+uO1aKg8XV8G
         OCCMXGCSsx7QPXpjBCp3B7YrrmeoiGrrylyrQHNn5aRnKc8tkX82HhEdOUWZMghwCFh9
         JyjHsbWxMf4FZMhENmtDcwZsBOUMMDPsfpqANHqfRUFwgOI/G9TyJRx9Kn59fcn3CjE8
         No2UqzEwuSsFU96eLTJ9V4jrlwWT1AI6TYTFi0cNEzx7V1a6pCnFS3KtHJFufxxUx83O
         ZJ5A==
X-Gm-Message-State: AOJu0YxCpIWctg2HEQqGCqJGx2q8HmOf1blVJGcl1w+EXBYY+HeOkqBf
	dKkrNUZ9a0tWSuOBvWzVm/CsFlVZ3BxyvLigq5X0QPChaLJ1LKquiBEP1yEuocO/jTpr3i25Rcn
	7YZU=
X-Google-Smtp-Source: AGHT+IEc77QQ3q08JHwfxDxHC0cl70wxT+kgO164AWGr+MLmV8epD1FBlOHfHbZupCzp0Yw0Yi7tng==
X-Received: by 2002:a05:6870:56a9:b0:261:1339:1cb9 with SMTP id 586e51a60fabf-2962e33c110mr14636602fac.35.1732042811290;
        Tue, 19 Nov 2024 11:00:11 -0800 (PST)
Received: from [192.168.1.116] ([96.43.243.2])
        by smtp.gmail.com with ESMTPSA id 586e51a60fabf-29651ace601sm3740117fac.43.2024.11.19.11.00.10
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Tue, 19 Nov 2024 11:00:10 -0800 (PST)
Message-ID: <5a7528c4-4391-4bd9-bbdb-a0247f3c76a9@kernel.dk>
Date: Tue, 19 Nov 2024 12:00:09 -0700
Precedence: bulk
X-Mailing-List: io-uring@vger.kernel.org
List-Id: <io-uring.vger.kernel.org>
List-Subscribe: <mailto:io-uring+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:io-uring+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH 03/14] io_uring: specify freeptr usage for
 SLAB_TYPESAFE_BY_RCU io_kiocb cache
To: Geert Uytterhoeven <geert@linux-m68k.org>,
 Guenter Roeck <linux@roeck-us.net>
Cc: io-uring@vger.kernel.org, linux-m68k <linux-m68k@lists.linux-m68k.org>
References: <20241029152249.667290-1-axboe@kernel.dk>
 <20241029152249.667290-4-axboe@kernel.dk>
 <37c588d4-2c32-4aad-a19e-642961f200d7@roeck-us.net>
 <d4e5a858-1333-4427-a470-350c45b78733@kernel.dk>
 <ffc9d82d-fedf-4253-bbc1-c70c339c8b23@roeck-us.net>
 <CAMuHMdVAnJ8Tczm1=c=HOiWMZrNk0i_c1guUoqQbJRmdaXqPGw@mail.gmail.com>
Content-Language: en-US
From: Jens Axboe <axboe@kernel.dk>
In-Reply-To: <CAMuHMdVAnJ8Tczm1=c=HOiWMZrNk0i_c1guUoqQbJRmdaXqPGw@mail.gmail.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit

On 11/19/24 10:49 AM, Geert Uytterhoeven wrote:
> On Tue, Nov 19, 2024 at 5:21?PM Guenter Roeck <linux@roeck-us.net> wrote:
>> On 11/19/24 08:02, Jens Axboe wrote:
>>> On 11/19/24 8:36 AM, Guenter Roeck wrote:
>>>> On Tue, Oct 29, 2024 at 09:16:32AM -0600, Jens Axboe wrote:
>>>>> Doesn't matter right now as there's still some bytes left for it, but
>>>>> let's prepare for the io_kiocb potentially growing and add a specific
>>>>> freeptr offset for it.
>>>>>
>>>>> Signed-off-by: Jens Axboe <axboe@kernel.dk>
>>>>
>>>> This patch triggers:
>>>>
>>>> Kernel panic - not syncing: __kmem_cache_create_args: Failed to create slab 'io_kiocb'. Error -22
>>>> CPU: 0 UID: 0 PID: 1 Comm: swapper Not tainted 6.12.0-mac-00971-g158f238aa69d #1
>>>> Stack from 00c63e5c:
>>>>          00c63e5c 00612c1c 00612c1c 00000300 00000001 005f3ce6 004b9044 00612c1c
>>>>          004ae21e 00000310 000000b6 005f3ce6 005f3ce6 ffffffea ffffffea 00797244
>>>>          00c63f20 000c6974 005ee588 004c9051 005f3ce6 ffffffea 000000a5 00c614a0
>>>>          004a72c2 0002cb62 000c675e 004adb58 0076f28a 005f3ce6 000000b6 00c63ef4
>>>>          00000310 00c63ef4 00000000 00000016 0076f23e 00c63f4c 00000010 00000004
>>>>          00000038 0000009a 01000000 00000000 00000000 00000000 000020e0 0076f23e
>>>> Call Trace: [<004b9044>] dump_stack+0xc/0x10
>>>>   [<004ae21e>] panic+0xc4/0x252
>>>>   [<000c6974>] __kmem_cache_create_args+0x216/0x26c
>>>>   [<004a72c2>] strcpy+0x0/0x1c
>>>>   [<0002cb62>] parse_args+0x0/0x1f2
>>>>   [<000c675e>] __kmem_cache_create_args+0x0/0x26c
>>>>   [<004adb58>] memset+0x0/0x8c
>>>>   [<0076f28a>] io_uring_init+0x4c/0xca
>>>>   [<0076f23e>] io_uring_init+0x0/0xca
>>>>   [<000020e0>] do_one_initcall+0x32/0x192
>>>>   [<0076f23e>] io_uring_init+0x0/0xca
>>>>   [<0000211c>] do_one_initcall+0x6e/0x192
>>>>   [<004a72c2>] strcpy+0x0/0x1c
>>>>   [<0002cb62>] parse_args+0x0/0x1f2
>>>>   [<000020ae>] do_one_initcall+0x0/0x192
>>>>   [<0075c4e2>] kernel_init_freeable+0x1a0/0x1a4
>>>>   [<0076f23e>] io_uring_init+0x0/0xca
>>>>   [<004b911a>] kernel_init+0x0/0xec
>>>>   [<004b912e>] kernel_init+0x14/0xec
>>>>   [<004b911a>] kernel_init+0x0/0xec
>>>>   [<0000252c>] ret_from_kernel_thread+0xc/0x14
>>>>
>>>> when trying to boot the m68k:q800 machine in qemu.
>>>>
>>>> An added debug message in create_cache() shows the reason:
>>>>
>>>> #### freeptr_offset=154 object_size=182 flags=0x310 aligned=0 sizeof(freeptr_t)=4
>>>>
>>>> freeptr_offset would need to be 4-byte aligned but that is not the
>>>> case on m68k.
>>>
>>> Why is ->work 2-byte aligned to begin with on m68k?!
>>
>> My understanding is that m68k does not align pointers.
> 
> The minimum alignment for multi-byte integral values on m68k is
> 2 bytes.
> 
> See also the comment at
> https://elixir.bootlin.com/linux/v6.12/source/include/linux/maple_tree.h#L46

Maybe it's time we put m68k to bed? :-)

We can add a forced alignment ->work to be 4 bytes, won't change
anything on anything remotely current. But does feel pretty hacky to
need to align based on some ancient thing.

-- 
Jens Axboe

