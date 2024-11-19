Return-Path: <io-uring+bounces-4833-lists+io-uring=lfdr.de@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [IPv6:2604:1380:4601:e00::3])
	by mail.lfdr.de (Postfix) with ESMTPS id 1FB1B9D29D1
	for <lists+io-uring@lfdr.de>; Tue, 19 Nov 2024 16:39:09 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id 994431F23796
	for <lists+io-uring@lfdr.de>; Tue, 19 Nov 2024 15:39:08 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 5B0151D172A;
	Tue, 19 Nov 2024 15:37:06 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="hlG2VkCS"
X-Original-To: io-uring@vger.kernel.org
Received: from mail-pf1-f175.google.com (mail-pf1-f175.google.com [209.85.210.175])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2003E1D042D
	for <io-uring@vger.kernel.org>; Tue, 19 Nov 2024 15:37:03 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.210.175
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1732030626; cv=none; b=i5KX8JYXt4WvHgssQOzmOKerbsWznGmuEuSMboT8gTU8gYxctcTjDm4y7LirX/6PwPYeBAHM4yyONLipD6ouHpoj+I0sTTeNKG+w6v4ctQdEdSTDBkrN9bA8VrfaBQEAZUHvZkV9DrWuZ3Rw+/H9W3GqMSfyVIGCMopFsxnqFzo=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1732030626; c=relaxed/simple;
	bh=BeRdOTGl3DtXKo2vSiuQPaPz1alJQCVuCJcj+V+dbEM=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=jvY8tPbl+J6CnKgIAUUR6g25OirpT/9K/57AESYzidVGf6EDK+HdqsJUCqgnTbUCAHoXWWGkw3PL49SOzdb9KXGwUIA38ZM64G+VrQks/8a2vqf9faIvpu0eyOsUHNHXiO+IeHWutMHJ8nHp7W0v6cV6xZgaycOAPasQR+avKlM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=roeck-us.net; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=hlG2VkCS; arc=none smtp.client-ip=209.85.210.175
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=roeck-us.net
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Received: by mail-pf1-f175.google.com with SMTP id d2e1a72fcca58-71e625b00bcso3648734b3a.3
        for <io-uring@vger.kernel.org>; Tue, 19 Nov 2024 07:37:03 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1732030623; x=1732635423; darn=vger.kernel.org;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:sender:from:to:cc:subject:date:message-id
         :reply-to;
        bh=q0TqoAvkxjIjR1K//mzC4Y4BvHtFogJclgQOudg6CrU=;
        b=hlG2VkCS97h/uGwc6XsWv8eEIm/JCVEALWfWGNo0k7AxTRFxEBhYScdrlQTGvCpPZP
         Od43R8bFaFMe+ER4Mh/o5N0by1YNsmsYQYBArMsX+FJWtyE/Sbict6VUcooeaWQXvi5O
         yeZbnb9pGuoqdZpB8C4snnquLfNoycIGqru3JvR/bACiaunayWtilLbK04IXTps7XtFn
         zEH9A62Fp1zNhJxYY+BKynPX6sAR9kl1i9bFBoU/LUhK0ywV5w80wOt2mQzBX+wUMKWL
         eMnIJlO9Xkt+YO4j22Q8RUGEtTwlM6RXVgRgD+7wKhkx5UGobcqvRO53gthqkMJF4bkT
         cWVg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1732030623; x=1732635423;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:sender:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=q0TqoAvkxjIjR1K//mzC4Y4BvHtFogJclgQOudg6CrU=;
        b=sQZsd7carVxWPq/SCW++RYHv+ldlnO4Fd8JBMB5PD3/ZQ99PgDlWTXS/C1//6ljyCe
         qhBCFV0PWzP+ddvxOYJP/5SisE6jBMQfHaknVV1BavACUX64M3fEdZ3/U9+EMZhbjXlO
         WrjAGFQpGbdBN2RQ7roAUZnOEgQ6FuD3I9r67iByi7xFc+b7Ex1kRAdm7r0HcTrTVvGF
         xFdoTd4hU3zF4rhXJ4S1bjC/o230UATEW6o2nv8AMwsLuubJwFd3S1PWWEpHD0P8tEOs
         Y/ZI7I3NnOEg8TpcgfKEQ5SAeLZxaybJdy5ccD89FCvWGCLn/ih0an32m1c//+5Vp6xf
         pYmQ==
X-Gm-Message-State: AOJu0YwY1qFNfyQsUMQYZlPyRO11lVdGVmqF9f6BIr7xpGeZwfR1jE3Q
	w7+Gy9SLpFMimNLGhX08OmKCHVH9u2rWd7pqYAsiwzEHB4tkIOeEp4Bf6Q==
X-Google-Smtp-Source: AGHT+IGnw5cEbrq9GRiIAZ2hh2oRgpAlLdrV6SMPBrQFtedzeeV4lEqbW/wV9QlmTKhYLrG0/BnoTw==
X-Received: by 2002:a05:6a00:3a14:b0:71e:5fa1:d3e4 with SMTP id d2e1a72fcca58-72476b72166mr21311103b3a.2.1732030619941;
        Tue, 19 Nov 2024 07:36:59 -0800 (PST)
Received: from server.roeck-us.net ([2600:1700:e321:62f0:329c:23ff:fee3:9d7c])
        by smtp.gmail.com with ESMTPSA id d2e1a72fcca58-724770ee82asm8252564b3a.30.2024.11.19.07.36.58
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 19 Nov 2024 07:36:59 -0800 (PST)
Sender: Guenter Roeck <groeck7@gmail.com>
Date: Tue, 19 Nov 2024 07:36:57 -0800
From: Guenter Roeck <linux@roeck-us.net>
To: Jens Axboe <axboe@kernel.dk>
Cc: io-uring@vger.kernel.org
Subject: Re: [PATCH 03/14] io_uring: specify freeptr usage for
 SLAB_TYPESAFE_BY_RCU io_kiocb cache
Message-ID: <37c588d4-2c32-4aad-a19e-642961f200d7@roeck-us.net>
References: <20241029152249.667290-1-axboe@kernel.dk>
 <20241029152249.667290-4-axboe@kernel.dk>
Precedence: bulk
X-Mailing-List: io-uring@vger.kernel.org
List-Id: <io-uring.vger.kernel.org>
List-Subscribe: <mailto:io-uring+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:io-uring+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20241029152249.667290-4-axboe@kernel.dk>

Hi,

On Tue, Oct 29, 2024 at 09:16:32AM -0600, Jens Axboe wrote:
> Doesn't matter right now as there's still some bytes left for it, but
> let's prepare for the io_kiocb potentially growing and add a specific
> freeptr offset for it.
> 
> Signed-off-by: Jens Axboe <axboe@kernel.dk>

This patch triggers:

Kernel panic - not syncing: __kmem_cache_create_args: Failed to create slab 'io_kiocb'. Error -22
CPU: 0 UID: 0 PID: 1 Comm: swapper Not tainted 6.12.0-mac-00971-g158f238aa69d #1
Stack from 00c63e5c:
        00c63e5c 00612c1c 00612c1c 00000300 00000001 005f3ce6 004b9044 00612c1c
        004ae21e 00000310 000000b6 005f3ce6 005f3ce6 ffffffea ffffffea 00797244
        00c63f20 000c6974 005ee588 004c9051 005f3ce6 ffffffea 000000a5 00c614a0
        004a72c2 0002cb62 000c675e 004adb58 0076f28a 005f3ce6 000000b6 00c63ef4
        00000310 00c63ef4 00000000 00000016 0076f23e 00c63f4c 00000010 00000004
        00000038 0000009a 01000000 00000000 00000000 00000000 000020e0 0076f23e
Call Trace: [<004b9044>] dump_stack+0xc/0x10
 [<004ae21e>] panic+0xc4/0x252
 [<000c6974>] __kmem_cache_create_args+0x216/0x26c
 [<004a72c2>] strcpy+0x0/0x1c
 [<0002cb62>] parse_args+0x0/0x1f2
 [<000c675e>] __kmem_cache_create_args+0x0/0x26c
 [<004adb58>] memset+0x0/0x8c
 [<0076f28a>] io_uring_init+0x4c/0xca
 [<0076f23e>] io_uring_init+0x0/0xca
 [<000020e0>] do_one_initcall+0x32/0x192
 [<0076f23e>] io_uring_init+0x0/0xca
 [<0000211c>] do_one_initcall+0x6e/0x192
 [<004a72c2>] strcpy+0x0/0x1c
 [<0002cb62>] parse_args+0x0/0x1f2
 [<000020ae>] do_one_initcall+0x0/0x192
 [<0075c4e2>] kernel_init_freeable+0x1a0/0x1a4
 [<0076f23e>] io_uring_init+0x0/0xca
 [<004b911a>] kernel_init+0x0/0xec
 [<004b912e>] kernel_init+0x14/0xec
 [<004b911a>] kernel_init+0x0/0xec
 [<0000252c>] ret_from_kernel_thread+0xc/0x14

when trying to boot the m68k:q800 machine in qemu.

An added debug message in create_cache() shows the reason:

#### freeptr_offset=154 object_size=182 flags=0x310 aligned=0 sizeof(freeptr_t)=4

freeptr_offset would need to be 4-byte aligned but that is not the case on m68k.

Bisect log attached.

Guenter

---
# bad: [158f238aa69d91ad74e535c73f552bd4b025109c] Merge tag 'for-linus-6.13-rc1-tag' of git://git.kernel.org/pub/scm/linux/kernel/git/xen/tip
# good: [adc218676eef25575469234709c2d87185ca223a] Linux 6.12
git bisect start '158f238aa69d' 'v6.12'
# good: [77a0cfafa9af9c0d5b43534eb90d530c189edca1] Merge tag 'for-6.13/block-20241118' of git://git.kernel.dk/linux
git bisect good 77a0cfafa9af9c0d5b43534eb90d530c189edca1
# bad: [0338cd9c22d1bce7dc4a6641d4215a50f476f429] Merge tag 's390-6.13-1' of git://git.kernel.org/pub/scm/linux/kernel/git/s390/linux
git bisect bad 0338cd9c22d1bce7dc4a6641d4215a50f476f429
# good: [fbe057e874c7037982dea38235e8b9a9be05a8d5] s390/cpu_mf: Convert to use flag output macros
git bisect good fbe057e874c7037982dea38235e8b9a9be05a8d5
# bad: [2f3cc8e441c9f657ff036c56baaab7dddbd0b350] io_uring/napi: protect concurrent io_napi_entry timeout accesses
git bisect bad 2f3cc8e441c9f657ff036c56baaab7dddbd0b350
# good: [d090bffab609762af06dec295a305ce270941b42] io_uring/memmap: explicitly return -EFAULT for mmap on NULL rings
git bisect good d090bffab609762af06dec295a305ce270941b42
# bad: [3597f2786b687a7f26361ce00a805ea0af41b65f] io_uring/rsrc: unify file and buffer resource tables
git bisect bad 3597f2786b687a7f26361ce00a805ea0af41b65f
# good: [ff1256b8f3c45f222bce19fbfc1e1bc498b31d03] io_uring/rsrc: move struct io_fixed_file to rsrc.h header
git bisect good ff1256b8f3c45f222bce19fbfc1e1bc498b31d03
# bad: [7029acd8a950393ee3a3d8e1a7ee1a9b77808a3b] io_uring/rsrc: get rid of per-ring io_rsrc_node list
git bisect bad 7029acd8a950393ee3a3d8e1a7ee1a9b77808a3b
# bad: [743fb58a35cde8fe27b07ee5a985ae76563845e3] io_uring/splice: open code 2nd direct file assignment
git bisect bad 743fb58a35cde8fe27b07ee5a985ae76563845e3
# bad: [aaa736b186239b7dc7778ae94c75f26c96972796] io_uring: specify freeptr usage for SLAB_TYPESAFE_BY_RCU io_kiocb cache
git bisect bad aaa736b186239b7dc7778ae94c75f26c96972796
# first bad commit: [aaa736b186239b7dc7778ae94c75f26c96972796] io_uring: specify freeptr usage for SLAB_TYPESAFE_BY_RCU io_kiocb cache

