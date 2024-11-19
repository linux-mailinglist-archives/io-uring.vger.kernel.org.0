Return-Path: <io-uring+bounces-4844-lists+io-uring=lfdr.de@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [147.75.80.249])
	by mail.lfdr.de (Postfix) with ESMTPS id 9218C9D2ED7
	for <lists+io-uring@lfdr.de>; Tue, 19 Nov 2024 20:30:45 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id 2698C1F2396A
	for <lists+io-uring@lfdr.de>; Tue, 19 Nov 2024 19:30:45 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 8EDA81422C7;
	Tue, 19 Nov 2024 19:30:30 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel-dk.20230601.gappssmtp.com header.i=@kernel-dk.20230601.gappssmtp.com header.b="QXqxk77p"
X-Original-To: io-uring@vger.kernel.org
Received: from mail-oi1-f179.google.com (mail-oi1-f179.google.com [209.85.167.179])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 21AB11D2794
	for <io-uring@vger.kernel.org>; Tue, 19 Nov 2024 19:30:25 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.167.179
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1732044630; cv=none; b=hzTKA3NU/h3BUCDe5z3I5i34JAscfuRB97TN7/lJufrQaR0yOFVxSvE87HXoY5Wvrj8JqN1O8eok1AFt74ffT2qMizyTbuUKB2Mzn9z6/MzEm4a7s4rwCxoDj/pZEitPvQX/XcuXsWUt2mME527VfZ172nZ1hQ25mKqK1x7Y1Z0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1732044630; c=relaxed/simple;
	bh=/pxPvr7rVIs84+ncTHjRCEVNwTUEubyJK9MR4PQrQDg=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=S/74n711FcMuysz2tr9y61h7sIvg0jPMQUix5f8+/+Hsaw+S7gwzTcAHH6jNCVm4KDEUPapEKE2zPk7NRB3Dw7ksE5QxNoPckPDcwCTEdz1+cwaJp5NWRaQ6lcINL92ummfostD5zdmGMP/a0p5E9RL6zAHAQ3mP46QtGNVH/wY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=kernel.dk; spf=pass smtp.mailfrom=kernel.dk; dkim=pass (2048-bit key) header.d=kernel-dk.20230601.gappssmtp.com header.i=@kernel-dk.20230601.gappssmtp.com header.b=QXqxk77p; arc=none smtp.client-ip=209.85.167.179
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=kernel.dk
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=kernel.dk
Received: by mail-oi1-f179.google.com with SMTP id 5614622812f47-3e602994635so2717720b6e.0
        for <io-uring@vger.kernel.org>; Tue, 19 Nov 2024 11:30:25 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernel-dk.20230601.gappssmtp.com; s=20230601; t=1732044625; x=1732649425; darn=vger.kernel.org;
        h=content-transfer-encoding:in-reply-to:from:content-language
         :references:cc:to:subject:user-agent:mime-version:date:message-id
         :from:to:cc:subject:date:message-id:reply-to;
        bh=1j2wwajvsqCyDi8kxNb5t2Zl1bcDPGqJuEe1UFF0umE=;
        b=QXqxk77pRPIMgabB7gNzVXjB+VZoFek77CZbNcnMygFF6PEjZbX57SRIf7fkG42Stw
         3y1yrjPu9SLQqre1Ail9YqWQUgbAPqOTHgAAHrRvNYlTaRNsyEVhiyEy7SEP7zDqwJxk
         p761sAud6YbJChTK8ZRGBU4XlMWFAqawGqlP7zgvbRl2LsBGFZJVg6+N2mLzUWJEf2nw
         r1xQdT/1+pYqAYUBKf262TEBUDLSmwtvuW3PZ3iC8V9jhPW4BeeAb05G4/yaymQApbx1
         /8fCB9O+F7ClsHZH+vb1srQ1GfahCilE92jAkWBmvX5Tb4W7U0WbVSI+sNNF376QfUHp
         8xEA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1732044625; x=1732649425;
        h=content-transfer-encoding:in-reply-to:from:content-language
         :references:cc:to:subject:user-agent:mime-version:date:message-id
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=1j2wwajvsqCyDi8kxNb5t2Zl1bcDPGqJuEe1UFF0umE=;
        b=fRA3yeB3Zj2Z6+i8gB8Uw6BY07WMvuMVVENOOISABumsink5npF3yk/YXz9g2meCE3
         4xby172qSrqqZ0HWrfIHnm7ZWMuyDIClSB5JBxsNT+iQts7tB4MMtqnOyC2cSp+Bt4me
         Js8PqmaRj48Ijvs6zJQFwkgbU/7sQ0XUWXh0KPrpGnweBPMEZPreVPXYOylJ9ZU4FpTU
         im0T4ZA6T73RnhQ/e8PyEQDFQWeuVQnTuN2W+bPcmZvvOM85HR1U7PNQo8eo7VDNl56U
         9M8iuLJwz4VMXFKDK5tWvKUHIRpuDP7qnKupxbTFOdzy7YjFnX0gDeMJlbV92tDucnt9
         SlGQ==
X-Forwarded-Encrypted: i=1; AJvYcCX77pValdsnk2mV2GYLFvffpvoS660ViaQZj7fBWYQl1x5fHVvYcwauINuCS2umA0JNH9kmcFQkPw==@vger.kernel.org
X-Gm-Message-State: AOJu0Yxogmb51Za5n0qWSrDTVG413aIie0sDCRyrhWYXipYppD1QDy8T
	gz6jnEvYu4IQLb0Yb9+/pYQdUv2B4aUsHPhivMroeflB4yTIaBrgBP2cjKQrtzA=
X-Google-Smtp-Source: AGHT+IGb4b1E9npAtC+iNcMXvMastU/QUoX28HYm7dmiLw3lFKHYAsPgsz4Wr7NrZXRDOgln6hPauQ==
X-Received: by 2002:a05:6808:118b:b0:3e7:6191:91e4 with SMTP id 5614622812f47-3e7bc7d3734mr15419867b6e.24.1732044625098;
        Tue, 19 Nov 2024 11:30:25 -0800 (PST)
Received: from [192.168.1.116] ([96.43.243.2])
        by smtp.gmail.com with ESMTPSA id 5614622812f47-3e7bcd11747sm3771832b6e.18.2024.11.19.11.30.24
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Tue, 19 Nov 2024 11:30:24 -0800 (PST)
Message-ID: <358710e8-a826-46df-9846-5a9e0f7c6851@kernel.dk>
Date: Tue, 19 Nov 2024 12:30:23 -0700
Precedence: bulk
X-Mailing-List: io-uring@vger.kernel.org
List-Id: <io-uring.vger.kernel.org>
List-Subscribe: <mailto:io-uring+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:io-uring+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH 03/14] io_uring: specify freeptr usage for
 SLAB_TYPESAFE_BY_RCU io_kiocb cache
To: Geert Uytterhoeven <geert@linux-m68k.org>
Cc: Guenter Roeck <linux@roeck-us.net>, io-uring@vger.kernel.org,
 linux-m68k <linux-m68k@lists.linux-m68k.org>
References: <20241029152249.667290-1-axboe@kernel.dk>
 <20241029152249.667290-4-axboe@kernel.dk>
 <37c588d4-2c32-4aad-a19e-642961f200d7@roeck-us.net>
 <d4e5a858-1333-4427-a470-350c45b78733@kernel.dk>
 <ffc9d82d-fedf-4253-bbc1-c70c339c8b23@roeck-us.net>
 <CAMuHMdVAnJ8Tczm1=c=HOiWMZrNk0i_c1guUoqQbJRmdaXqPGw@mail.gmail.com>
 <5a7528c4-4391-4bd9-bbdb-a0247f3c76a9@kernel.dk>
 <CAMuHMdX9rHUQYn34_Hz=3TKjbFqzenoDCdwt-Mqk1qXJiG4=Zg@mail.gmail.com>
 <5851cd28-b369-4c09-876c-62c4a47c5982@kernel.dk>
 <CAMuHMdX3iOVLN-rJSqvKSjrjTTf++PJ4e-wPsEX-3QJR3=eWOA@mail.gmail.com>
Content-Language: en-US
From: Jens Axboe <axboe@kernel.dk>
In-Reply-To: <CAMuHMdX3iOVLN-rJSqvKSjrjTTf++PJ4e-wPsEX-3QJR3=eWOA@mail.gmail.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit

On 11/19/24 12:25 PM, Geert Uytterhoeven wrote:
> Hi Jens,
> 
> On Tue, Nov 19, 2024 at 8:10?PM Jens Axboe <axboe@kernel.dk> wrote:
>> On 11/19/24 12:02 PM, Geert Uytterhoeven wrote:
>>> On Tue, Nov 19, 2024 at 8:00?PM Jens Axboe <axboe@kernel.dk> wrote:
>>>> On 11/19/24 10:49 AM, Geert Uytterhoeven wrote:
>>>>> On Tue, Nov 19, 2024 at 5:21?PM Guenter Roeck <linux@roeck-us.net> wrote:
>>>>>> On 11/19/24 08:02, Jens Axboe wrote:
>>>>>>> On 11/19/24 8:36 AM, Guenter Roeck wrote:
>>>>>>>> On Tue, Oct 29, 2024 at 09:16:32AM -0600, Jens Axboe wrote:
>>>>>>>>> Doesn't matter right now as there's still some bytes left for it, but
>>>>>>>>> let's prepare for the io_kiocb potentially growing and add a specific
>>>>>>>>> freeptr offset for it.
>>>>>>>>>
>>>>>>>>> Signed-off-by: Jens Axboe <axboe@kernel.dk>
>>>>>>>>
>>>>>>>> This patch triggers:
>>>>>>>>
>>>>>>>> Kernel panic - not syncing: __kmem_cache_create_args: Failed to create slab 'io_kiocb'. Error -22
>>>>>>>> CPU: 0 UID: 0 PID: 1 Comm: swapper Not tainted 6.12.0-mac-00971-g158f238aa69d #1
>>>>>>>> Stack from 00c63e5c:
>>>>>>>>          00c63e5c 00612c1c 00612c1c 00000300 00000001 005f3ce6 004b9044 00612c1c
>>>>>>>>          004ae21e 00000310 000000b6 005f3ce6 005f3ce6 ffffffea ffffffea 00797244
>>>>>>>>          00c63f20 000c6974 005ee588 004c9051 005f3ce6 ffffffea 000000a5 00c614a0
>>>>>>>>          004a72c2 0002cb62 000c675e 004adb58 0076f28a 005f3ce6 000000b6 00c63ef4
>>>>>>>>          00000310 00c63ef4 00000000 00000016 0076f23e 00c63f4c 00000010 00000004
>>>>>>>>          00000038 0000009a 01000000 00000000 00000000 00000000 000020e0 0076f23e
>>>>>>>> Call Trace: [<004b9044>] dump_stack+0xc/0x10
>>>>>>>>   [<004ae21e>] panic+0xc4/0x252
>>>>>>>>   [<000c6974>] __kmem_cache_create_args+0x216/0x26c
>>>>>>>>   [<004a72c2>] strcpy+0x0/0x1c
>>>>>>>>   [<0002cb62>] parse_args+0x0/0x1f2
>>>>>>>>   [<000c675e>] __kmem_cache_create_args+0x0/0x26c
>>>>>>>>   [<004adb58>] memset+0x0/0x8c
>>>>>>>>   [<0076f28a>] io_uring_init+0x4c/0xca
>>>>>>>>   [<0076f23e>] io_uring_init+0x0/0xca
>>>>>>>>   [<000020e0>] do_one_initcall+0x32/0x192
>>>>>>>>   [<0076f23e>] io_uring_init+0x0/0xca
>>>>>>>>   [<0000211c>] do_one_initcall+0x6e/0x192
>>>>>>>>   [<004a72c2>] strcpy+0x0/0x1c
>>>>>>>>   [<0002cb62>] parse_args+0x0/0x1f2
>>>>>>>>   [<000020ae>] do_one_initcall+0x0/0x192
>>>>>>>>   [<0075c4e2>] kernel_init_freeable+0x1a0/0x1a4
>>>>>>>>   [<0076f23e>] io_uring_init+0x0/0xca
>>>>>>>>   [<004b911a>] kernel_init+0x0/0xec
>>>>>>>>   [<004b912e>] kernel_init+0x14/0xec
>>>>>>>>   [<004b911a>] kernel_init+0x0/0xec
>>>>>>>>   [<0000252c>] ret_from_kernel_thread+0xc/0x14
>>>>>>>>
>>>>>>>> when trying to boot the m68k:q800 machine in qemu.
>>>>>>>>
>>>>>>>> An added debug message in create_cache() shows the reason:
>>>>>>>>
>>>>>>>> #### freeptr_offset=154 object_size=182 flags=0x310 aligned=0 sizeof(freeptr_t)=4
>>>>>>>>
>>>>>>>> freeptr_offset would need to be 4-byte aligned but that is not the
>>>>>>>> case on m68k.
>>>>>>>
>>>>>>> Why is ->work 2-byte aligned to begin with on m68k?!
>>>>>>
>>>>>> My understanding is that m68k does not align pointers.
>>>>>
>>>>> The minimum alignment for multi-byte integral values on m68k is
>>>>> 2 bytes.
>>>>>
>>>>> See also the comment at
>>>>> https://elixir.bootlin.com/linux/v6.12/source/include/linux/maple_tree.h#L46
>>>>
>>>> Maybe it's time we put m68k to bed? :-)
>>>>
>>>> We can add a forced alignment ->work to be 4 bytes, won't change
>>>> anything on anything remotely current. But does feel pretty hacky to
>>>> need to align based on some ancient thing.
>>>
>>> Why does freeptr_offset need to be 4-byte aligned?
>>
>> Didn't check, but it's slab/slub complaining using a 2-byte aligned
>> address for the free pointer offset. It's explicitly checking:
>>
>>         /* If a custom freelist pointer is requested make sure it's sane. */
>>         err = -EINVAL;
>>         if (args->use_freeptr_offset &&
>>             (args->freeptr_offset >= object_size ||
>>              !(flags & SLAB_TYPESAFE_BY_RCU) ||
>>              !IS_ALIGNED(args->freeptr_offset, sizeof(freeptr_t))))
>>                 goto out;
> 
> It is not guaranteed that alignof(freeptr_t) >= sizeof(freeptr_t)
> (free_ptr is sort of a long). If freeptr_offset must be a multiple of
> 4 or 8 bytes,
> the code that assigns it must make sure that is true.

Right, this is what the email is about...

> I guess this is the code in fs/file_table.c:
> 
>     .freeptr_offset = offsetof(struct file, f_freeptr),
> 
> which references:
> 
>     include/linux/fs.h:           freeptr_t               f_freeptr;
> 
> I guess the simplest solution is to add an __aligned(sizeof(freeptr_t))
> (or __aligned(sizeof(long)) to the definition of freeptr_t:
> 
>     include/linux/slab.h:typedef struct { unsigned long v; } freeptr_t;

It's not, it's struct io_kiocb->work, as per the stack trace in this
email.

-- 
Jens Axboe

