Return-Path: <io-uring+bounces-4834-lists+io-uring=lfdr.de@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from sy.mirrors.kernel.org (sy.mirrors.kernel.org [147.75.48.161])
	by mail.lfdr.de (Postfix) with ESMTPS id CD8949D2A6E
	for <lists+io-uring@lfdr.de>; Tue, 19 Nov 2024 17:04:31 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sy.mirrors.kernel.org (Postfix) with ESMTPS id 6ADB0B23DE0
	for <lists+io-uring@lfdr.de>; Tue, 19 Nov 2024 16:02:14 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id D025A145FFF;
	Tue, 19 Nov 2024 16:02:10 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel-dk.20230601.gappssmtp.com header.i=@kernel-dk.20230601.gappssmtp.com header.b="pwDuAYT8"
X-Original-To: io-uring@vger.kernel.org
Received: from mail-oi1-f172.google.com (mail-oi1-f172.google.com [209.85.167.172])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id BE99318A950
	for <io-uring@vger.kernel.org>; Tue, 19 Nov 2024 16:02:07 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.167.172
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1732032130; cv=none; b=eIs6D4cgNBOxjQpQChJuyL+HKxEhtJfAGe6e+6hBiztpqu6n02ejgNy3r+JviUbCB6N1KsC4m22cHMFJi2U46gummN45zEUqIKHKkFCQLRuY1lAqhe9K39qs1RFuNxcqn6OQo+okBGFs+sV7WqCK9dmkkQrD8tZlxfkACcz+fRY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1732032130; c=relaxed/simple;
	bh=8GJM7uCVNS7hTxenfrjLOtcu5/3K2ajO3nNFvrW0bwM=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=cSCXWC3ONvH3siegaKou33BWuLKV0U90ZWj7/Iqcv7+njPXC9t8jbErF+Kgf34V73nDRh7k0dECQsOBMNYU8k6/8O0AWTFztOGF2Wla6fLH9kQS2W/tzbytSDxn3I8WrIhzOxvvXC1aZqykxKRLcuUDcn57TDYBv0NPuhIyyKS0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=kernel.dk; spf=pass smtp.mailfrom=kernel.dk; dkim=pass (2048-bit key) header.d=kernel-dk.20230601.gappssmtp.com header.i=@kernel-dk.20230601.gappssmtp.com header.b=pwDuAYT8; arc=none smtp.client-ip=209.85.167.172
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=kernel.dk
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=kernel.dk
Received: by mail-oi1-f172.google.com with SMTP id 5614622812f47-3e5f835c024so634094b6e.2
        for <io-uring@vger.kernel.org>; Tue, 19 Nov 2024 08:02:07 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernel-dk.20230601.gappssmtp.com; s=20230601; t=1732032127; x=1732636927; darn=vger.kernel.org;
        h=content-transfer-encoding:in-reply-to:from:content-language
         :references:cc:to:subject:user-agent:mime-version:date:message-id
         :from:to:cc:subject:date:message-id:reply-to;
        bh=yL8tHp2Fpr+O+zAmTby5OswtjdArzHPCWWqILBa0+ws=;
        b=pwDuAYT8j0ACyBy+QA77yQKOoTxJVU+6ZcXaNdDBftxPUoMgPowFrflOfc2pvNw6a+
         2V8WvdR/TOoVLNXJuP/F4AMsxTDqi+FoKl9KrQnDUedDt5LxtudUc/CPEcJAJo5oLEcU
         3qvnsFxddOoNoizQiD/iggTT+gz0MubesYo5UYWrN9msTYTHAi3TdpkOzWVIV9gT6f8n
         K+kJomX4dkTDX3dhvXMoWs3F7W1af0Kbr5LVxA5/bUoATk8QFYBvBOhHL2lwOxJQw65o
         9JPTKHtEnZMolKCoopOvL4urOrTBSm11ja0vnZk62wBSkc1BG+OVcA+330YKlFjbo6Oq
         Fb/w==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1732032127; x=1732636927;
        h=content-transfer-encoding:in-reply-to:from:content-language
         :references:cc:to:subject:user-agent:mime-version:date:message-id
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=yL8tHp2Fpr+O+zAmTby5OswtjdArzHPCWWqILBa0+ws=;
        b=NlgKK+ej18vg/6Pn8lvGBXgQca1ZtCcCHe5kmUmxGSe8Z6avskcuYekuGusvo0bFtD
         LIRA+t1zMruiZpn0dN5Ph06GjnqESl41rBfgjeJE2CicWD07NeJHZqY7fV+iX0Mr04Dl
         hvAQ/4tHJrZ7e+gLvtu+m3OOLAGCufnye/PHUjAOkU+ChY2eMpgKoFxWUUOenOIeIUR2
         uHZustuK+IWZVVuAlUujZh8eqorBwr/yZ76WfE0HOTECJVyIbmU+gNnVdc3o60k/xI/+
         chG+ozzvx3Go2J21+eSLuxkLLwkYQ0jSlpf8MtggQrsl8ftJq8Ylqc0GGXMxuLTJjXis
         LdAA==
X-Gm-Message-State: AOJu0Yy2vqQQ7JbBpgJjJ7wmU5CshzWG6kQLNEqqt25vsOfWS7a+l2dP
	zmD8ji/8p6bK4PXnHgT4WxGCSLf3MyZIuFZG6MEjcz7T5vrZAAOzTjBsKklInPS5BMc4jLsoqDg
	2FyI=
X-Google-Smtp-Source: AGHT+IG6jajNaFfp8vyW5721LEFfJ8EM7//vaq7sqCF1K2Rsf7YJomlkZ1NBKmmfzPW2ai+mmip4hg==
X-Received: by 2002:a05:6808:16ab:b0:3e6:2772:2a4b with SMTP id 5614622812f47-3e7bc7a3fecmr13929823b6e.9.1732032126668;
        Tue, 19 Nov 2024 08:02:06 -0800 (PST)
Received: from [192.168.1.116] ([96.43.243.2])
        by smtp.gmail.com with ESMTPSA id 5614622812f47-3e7bcd92e51sm3704608b6e.45.2024.11.19.08.02.05
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Tue, 19 Nov 2024 08:02:05 -0800 (PST)
Message-ID: <d4e5a858-1333-4427-a470-350c45b78733@kernel.dk>
Date: Tue, 19 Nov 2024 09:02:05 -0700
Precedence: bulk
X-Mailing-List: io-uring@vger.kernel.org
List-Id: <io-uring.vger.kernel.org>
List-Subscribe: <mailto:io-uring+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:io-uring+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH 03/14] io_uring: specify freeptr usage for
 SLAB_TYPESAFE_BY_RCU io_kiocb cache
To: Guenter Roeck <linux@roeck-us.net>
Cc: io-uring@vger.kernel.org
References: <20241029152249.667290-1-axboe@kernel.dk>
 <20241029152249.667290-4-axboe@kernel.dk>
 <37c588d4-2c32-4aad-a19e-642961f200d7@roeck-us.net>
Content-Language: en-US
From: Jens Axboe <axboe@kernel.dk>
In-Reply-To: <37c588d4-2c32-4aad-a19e-642961f200d7@roeck-us.net>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit

On 11/19/24 8:36 AM, Guenter Roeck wrote:
> Hi,
> 
> On Tue, Oct 29, 2024 at 09:16:32AM -0600, Jens Axboe wrote:
>> Doesn't matter right now as there's still some bytes left for it, but
>> let's prepare for the io_kiocb potentially growing and add a specific
>> freeptr offset for it.
>>
>> Signed-off-by: Jens Axboe <axboe@kernel.dk>
> 
> This patch triggers:
> 
> Kernel panic - not syncing: __kmem_cache_create_args: Failed to create slab 'io_kiocb'. Error -22
> CPU: 0 UID: 0 PID: 1 Comm: swapper Not tainted 6.12.0-mac-00971-g158f238aa69d #1
> Stack from 00c63e5c:
>         00c63e5c 00612c1c 00612c1c 00000300 00000001 005f3ce6 004b9044 00612c1c
>         004ae21e 00000310 000000b6 005f3ce6 005f3ce6 ffffffea ffffffea 00797244
>         00c63f20 000c6974 005ee588 004c9051 005f3ce6 ffffffea 000000a5 00c614a0
>         004a72c2 0002cb62 000c675e 004adb58 0076f28a 005f3ce6 000000b6 00c63ef4
>         00000310 00c63ef4 00000000 00000016 0076f23e 00c63f4c 00000010 00000004
>         00000038 0000009a 01000000 00000000 00000000 00000000 000020e0 0076f23e
> Call Trace: [<004b9044>] dump_stack+0xc/0x10
>  [<004ae21e>] panic+0xc4/0x252
>  [<000c6974>] __kmem_cache_create_args+0x216/0x26c
>  [<004a72c2>] strcpy+0x0/0x1c
>  [<0002cb62>] parse_args+0x0/0x1f2
>  [<000c675e>] __kmem_cache_create_args+0x0/0x26c
>  [<004adb58>] memset+0x0/0x8c
>  [<0076f28a>] io_uring_init+0x4c/0xca
>  [<0076f23e>] io_uring_init+0x0/0xca
>  [<000020e0>] do_one_initcall+0x32/0x192
>  [<0076f23e>] io_uring_init+0x0/0xca
>  [<0000211c>] do_one_initcall+0x6e/0x192
>  [<004a72c2>] strcpy+0x0/0x1c
>  [<0002cb62>] parse_args+0x0/0x1f2
>  [<000020ae>] do_one_initcall+0x0/0x192
>  [<0075c4e2>] kernel_init_freeable+0x1a0/0x1a4
>  [<0076f23e>] io_uring_init+0x0/0xca
>  [<004b911a>] kernel_init+0x0/0xec
>  [<004b912e>] kernel_init+0x14/0xec
>  [<004b911a>] kernel_init+0x0/0xec
>  [<0000252c>] ret_from_kernel_thread+0xc/0x14
> 
> when trying to boot the m68k:q800 machine in qemu.
> 
> An added debug message in create_cache() shows the reason:
> 
> #### freeptr_offset=154 object_size=182 flags=0x310 aligned=0 sizeof(freeptr_t)=4
> 
> freeptr_offset would need to be 4-byte aligned but that is not the
> case on m68k.

Why is ->work 2-byte aligned to begin with on m68k?!

-- 
Jens Axboe

