Return-Path: <io-uring+bounces-4836-lists+io-uring=lfdr.de@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [139.178.88.99])
	by mail.lfdr.de (Postfix) with ESMTPS id E4EB79D2AB6
	for <lists+io-uring@lfdr.de>; Tue, 19 Nov 2024 17:22:01 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id A57C028366A
	for <lists+io-uring@lfdr.de>; Tue, 19 Nov 2024 16:22:00 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id E952F1CCB35;
	Tue, 19 Nov 2024 16:21:55 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="abzPQ0o5"
X-Original-To: io-uring@vger.kernel.org
Received: from mail-pf1-f170.google.com (mail-pf1-f170.google.com [209.85.210.170])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4EBEF145348
	for <io-uring@vger.kernel.org>; Tue, 19 Nov 2024 16:21:54 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.210.170
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1732033315; cv=none; b=qB051Qx6u0owEabmKBD9wThuTDmPujAfRD49rsdGqnoBENwdYIWs3R6o+Tv5+IsVIuT95ohYbGBKgY4/rnfXP4/igWoo7gEmjs5jKOKu5S8vyD+1uePdf8kq2utOopiiDJZyuAaofjXynlMA2OtVZ6DUNPfesnQ5/zJVsHzwdWs=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1732033315; c=relaxed/simple;
	bh=tnnQnW1hlRwlXgzmyeSTAznbxa4wV3mVYYN+myi2JnM=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=Sphtf9ifxHdaBh2OKrEeT7/tpiZBgLexRC7RTaBzaeue1V0S76AlcQsbOkqFgfS+wkYKAjqucFxZ2f7crsyovR/qse5N8afj1DUAju4rgPRqMmPzB75NN1DkwgKD1vAnW3ETNbA/e6q8zhUbVCNvzu+Iph9JGPynJmgYAyNpwHA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=roeck-us.net; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=abzPQ0o5; arc=none smtp.client-ip=209.85.210.170
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=roeck-us.net
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Received: by mail-pf1-f170.google.com with SMTP id d2e1a72fcca58-71ec997ad06so4162949b3a.3
        for <io-uring@vger.kernel.org>; Tue, 19 Nov 2024 08:21:54 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1732033313; x=1732638113; darn=vger.kernel.org;
        h=content-transfer-encoding:in-reply-to:autocrypt:from
         :content-language:references:cc:to:subject:user-agent:mime-version
         :date:message-id:sender:from:to:cc:subject:date:message-id:reply-to;
        bh=bRhD2zS+BslcgVFuoW4N2TO5PUnGjOrsY18+K5urrps=;
        b=abzPQ0o5sfvkDwUV5zjuUYrs1gishrK1iZ1iiV1DiDnGdIbZ+/lSB2XiAJHayqSSEt
         DKW69w94hFlpCbPZjm9Sn/YStDmOthG0cBbq1SOKn8DkPpDS5yK2WKpw0qRaOv9NPzaf
         6scY4oFcfL1zOLLt01ns71SLlwS5iIFdICTM31NGYk6lh00dwYS9ISmo2ci33uEZ1zow
         5VzKKWcF/NBG3l6WfP6DoPFqu4TawsC56dgyGPS94+Zz9/D+U+bRVq1K96wob8TjwwLG
         j1j3ugoMFu4B2trGXvly2tjibdUaCJGOi0h2EDl1re9YrmvtNYtDBQ3HyLk1GB5RpLjH
         eAdA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1732033313; x=1732638113;
        h=content-transfer-encoding:in-reply-to:autocrypt:from
         :content-language:references:cc:to:subject:user-agent:mime-version
         :date:message-id:sender:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=bRhD2zS+BslcgVFuoW4N2TO5PUnGjOrsY18+K5urrps=;
        b=VM0oZ+nBdYiYitQXf3f6/jaLoG37ouqiJqUB0Rd7BYgBiVllxUkD5EHRd5NBFIpXxF
         6PQxQYypNYbmtxF+Vj9wm6lSMFCjThHn2QWtWIJlXioCziSXjn4oB9Q9RYDXr+StyeYR
         /7inwbC6ePnrhrzMYIfKFKWppnmWxdCc9d9wY5h1PRxp7p7Psew/QQ9qaBLSBSEGCJGt
         MgWPtmpzWbp8Qu8/p1LF2zOUNhaPct4howa5ut2+JtJ75T3l11hWmr6quxdbNbFU1tEY
         DeJodaKdkjSBcQgwlS8bBJKppIHxqIF9d+qsrp7VA+Vdtyfcle6ZVi5kdpXQbWnqKlZ8
         pZ9w==
X-Gm-Message-State: AOJu0YzzyveinU5DCg51QBpjq7/eFU4jNp+MX3GWX3s1MbZKb4bY+0bl
	sTqOcBLNrs+ilLaG4k605Byqw3Sja+4XkQk5KQ6bBySTdb5vFVjR
X-Google-Smtp-Source: AGHT+IEO7Qu46BODWt5MYIjr2PItJfqgLlug+B6rvfy52LeOnJM/t9u301aed9m/oGG3ue+hKCxwTA==
X-Received: by 2002:a05:6a00:2292:b0:71e:7294:bbc4 with SMTP id d2e1a72fcca58-72476bb83eamr24149661b3a.13.1732033313449;
        Tue, 19 Nov 2024 08:21:53 -0800 (PST)
Received: from ?IPV6:2600:1700:e321:62f0:329c:23ff:fee3:9d7c? ([2600:1700:e321:62f0:329c:23ff:fee3:9d7c])
        by smtp.gmail.com with ESMTPSA id d2e1a72fcca58-72477200f05sm8661137b3a.188.2024.11.19.08.21.51
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Tue, 19 Nov 2024 08:21:52 -0800 (PST)
Sender: Guenter Roeck <groeck7@gmail.com>
Message-ID: <ffc9d82d-fedf-4253-bbc1-c70c339c8b23@roeck-us.net>
Date: Tue, 19 Nov 2024 08:21:50 -0800
Precedence: bulk
X-Mailing-List: io-uring@vger.kernel.org
List-Id: <io-uring.vger.kernel.org>
List-Subscribe: <mailto:io-uring+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:io-uring+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH 03/14] io_uring: specify freeptr usage for
 SLAB_TYPESAFE_BY_RCU io_kiocb cache
To: Jens Axboe <axboe@kernel.dk>
Cc: io-uring@vger.kernel.org, linux-m68k <linux-m68k@lists.linux-m68k.org>,
 Geert Uytterhoeven <geert@linux-m68k.org>
References: <20241029152249.667290-1-axboe@kernel.dk>
 <20241029152249.667290-4-axboe@kernel.dk>
 <37c588d4-2c32-4aad-a19e-642961f200d7@roeck-us.net>
 <d4e5a858-1333-4427-a470-350c45b78733@kernel.dk>
Content-Language: en-US
From: Guenter Roeck <linux@roeck-us.net>
Autocrypt: addr=linux@roeck-us.net; keydata=
 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
 mDW4+i+XlNFUPUYMrIKi9joBhu18ssf5i5Q=
In-Reply-To: <d4e5a858-1333-4427-a470-350c45b78733@kernel.dk>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit

On 11/19/24 08:02, Jens Axboe wrote:
> On 11/19/24 8:36 AM, Guenter Roeck wrote:
>> Hi,
>>
>> On Tue, Oct 29, 2024 at 09:16:32AM -0600, Jens Axboe wrote:
>>> Doesn't matter right now as there's still some bytes left for it, but
>>> let's prepare for the io_kiocb potentially growing and add a specific
>>> freeptr offset for it.
>>>
>>> Signed-off-by: Jens Axboe <axboe@kernel.dk>
>>
>> This patch triggers:
>>
>> Kernel panic - not syncing: __kmem_cache_create_args: Failed to create slab 'io_kiocb'. Error -22
>> CPU: 0 UID: 0 PID: 1 Comm: swapper Not tainted 6.12.0-mac-00971-g158f238aa69d #1
>> Stack from 00c63e5c:
>>          00c63e5c 00612c1c 00612c1c 00000300 00000001 005f3ce6 004b9044 00612c1c
>>          004ae21e 00000310 000000b6 005f3ce6 005f3ce6 ffffffea ffffffea 00797244
>>          00c63f20 000c6974 005ee588 004c9051 005f3ce6 ffffffea 000000a5 00c614a0
>>          004a72c2 0002cb62 000c675e 004adb58 0076f28a 005f3ce6 000000b6 00c63ef4
>>          00000310 00c63ef4 00000000 00000016 0076f23e 00c63f4c 00000010 00000004
>>          00000038 0000009a 01000000 00000000 00000000 00000000 000020e0 0076f23e
>> Call Trace: [<004b9044>] dump_stack+0xc/0x10
>>   [<004ae21e>] panic+0xc4/0x252
>>   [<000c6974>] __kmem_cache_create_args+0x216/0x26c
>>   [<004a72c2>] strcpy+0x0/0x1c
>>   [<0002cb62>] parse_args+0x0/0x1f2
>>   [<000c675e>] __kmem_cache_create_args+0x0/0x26c
>>   [<004adb58>] memset+0x0/0x8c
>>   [<0076f28a>] io_uring_init+0x4c/0xca
>>   [<0076f23e>] io_uring_init+0x0/0xca
>>   [<000020e0>] do_one_initcall+0x32/0x192
>>   [<0076f23e>] io_uring_init+0x0/0xca
>>   [<0000211c>] do_one_initcall+0x6e/0x192
>>   [<004a72c2>] strcpy+0x0/0x1c
>>   [<0002cb62>] parse_args+0x0/0x1f2
>>   [<000020ae>] do_one_initcall+0x0/0x192
>>   [<0075c4e2>] kernel_init_freeable+0x1a0/0x1a4
>>   [<0076f23e>] io_uring_init+0x0/0xca
>>   [<004b911a>] kernel_init+0x0/0xec
>>   [<004b912e>] kernel_init+0x14/0xec
>>   [<004b911a>] kernel_init+0x0/0xec
>>   [<0000252c>] ret_from_kernel_thread+0xc/0x14
>>
>> when trying to boot the m68k:q800 machine in qemu.
>>
>> An added debug message in create_cache() shows the reason:
>>
>> #### freeptr_offset=154 object_size=182 flags=0x310 aligned=0 sizeof(freeptr_t)=4
>>
>> freeptr_offset would need to be 4-byte aligned but that is not the
>> case on m68k.
> 
> Why is ->work 2-byte aligned to begin with on m68k?!
> 

My understanding is that m68k does not align pointers.

Copying Geert and the m68k mailing list for feedback. Sorry, I should have done
that earlier.

Guenter


