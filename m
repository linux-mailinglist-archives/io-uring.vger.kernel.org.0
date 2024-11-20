Return-Path: <io-uring+bounces-4865-lists+io-uring=lfdr.de@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [147.75.80.249])
	by mail.lfdr.de (Postfix) with ESMTPS id 42A349D3EAB
	for <lists+io-uring@lfdr.de>; Wed, 20 Nov 2024 16:12:38 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id F17EE1F2456E
	for <lists+io-uring@lfdr.de>; Wed, 20 Nov 2024 15:12:37 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id C819F1AFB31;
	Wed, 20 Nov 2024 15:00:33 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="Upqv/vsR"
X-Original-To: io-uring@vger.kernel.org
Received: from mail-pg1-f175.google.com (mail-pg1-f175.google.com [209.85.215.175])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3D2AD19CCFC;
	Wed, 20 Nov 2024 15:00:31 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.215.175
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1732114833; cv=none; b=MwGF1bT1HoIheU7KqJlkXNKqxQXEGGYTyXbzrkx45gEdEd8EPNlC0aHXn8IWcoboO4oabjkGZmcJaBf8tJsD1s4rKt9mJWbDWso0RQVofrNedUfEwhuicHAA0gLaagstYUAKDhWGt34IUTxdYUINu0e41g+lyaFGnkZS2GgFvuA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1732114833; c=relaxed/simple;
	bh=9ZC+2ipveOKTiTiA55rUJph3DsBYXv6Abypl2uf3Xqc=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=ebAMXVJvy78bhoRMSirPG8h5xnsxP46T8VOpSrcVT9rSyGf6BK0P/GwGuCctrK3NmTUUPZ/jcZFd69Y0kkVm+9q0C4DjffWjw1BDvj+1W+uD2yFWgjno7ouWGM1V3Xq/IgiDQnz6kWIlUbaRhYpVgXMhrq3n4urUdhanEzkKR4Q=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=roeck-us.net; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=Upqv/vsR; arc=none smtp.client-ip=209.85.215.175
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=roeck-us.net
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Received: by mail-pg1-f175.google.com with SMTP id 41be03b00d2f7-7ede82dbb63so2755207a12.2;
        Wed, 20 Nov 2024 07:00:31 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1732114830; x=1732719630; darn=vger.kernel.org;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:sender:from:to:cc:subject:date:message-id
         :reply-to;
        bh=lFFenx849KBhQwdSdYlyI/GCskIbw5nu6S3nTEvWg0M=;
        b=Upqv/vsRX3sN4EjsUHkCvIVbbcB0CQMb4GbXCVFs24yLg8Qi1BHDOeGXWC8c7y7ysc
         YWSIwJ+5GJ5rvgIFIwPYDC+exlBWE1ffG1RQhZ1SAlXS98BaESZwfkDU6obtdTWCkjVv
         UA7S2sQywwiz5DflooBQSDoKvXFuoTmBIdQLqcNuABCe/Edt3eGrJE02mqbzSBHfED3Z
         OdeA1MdOF0EvP7GdKUxW0rL4ks8pVbIgkihJwC6SHFlJ8/ySHaY86irAPFF+VkuMSzRd
         sqdP2zxU8CKa6HI3z+CdDkmWI5Q0vk/xiGJqp1Hlfra0Hvu6d8pEmOpYNedNZTL6h1yd
         j5Pw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1732114830; x=1732719630;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:sender:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=lFFenx849KBhQwdSdYlyI/GCskIbw5nu6S3nTEvWg0M=;
        b=xGdk0F4DoXAGBT3yELiqUEITz+QgtTQKPoKs6te7wJZbGSB8FuTH8CcjTYHvmFCSK3
         FOqe7rrWK+upO+7XbuAL77pfzG7TuJxLwVblu+WyUPM73QaFPy4srj9TsQUUJa5DwlSG
         Y0XuO/vWfScofyN6/pvM4WLwjCTC4weSbRR+b+CVZ4if13Lxr6Yg8F2rdALhSmzQtKLu
         YOaNbKMoYiiJhntcfSlCHHGc4+YS3+bDN0CdfBydM2RRBvcY0nefTtZTjm8ubPnb9Ovw
         QFAyEMvI4oQiYYuYSdh/opgWZ4+VkdIYDY1NtIOom1JIedqlPBQWCHTCUbi6aFpOdn7W
         9BsA==
X-Forwarded-Encrypted: i=1; AJvYcCU8vICOdeY8HBtBjdp1plxtaZGaoL+458Q/fp6xsKu9TaWMQOcmuR98Z6qTkMfkg1eoxcXIIlm5ah/USQ==@vger.kernel.org, AJvYcCVLkJnlRlWuTsfBoczMvHShNUsZjUU/IhjmsmnhedyfJpwYKDmnZeRQMvOPxzmsfAcQKA+ozsRLuDZFOemf@vger.kernel.org, AJvYcCVR20ZFMHx2dqHaz03YSs6q1MeXx9exFoER/YKSz4281k+n0ZVq2q2sQndJAKvf5GhyGU/IC0awMA==@vger.kernel.org
X-Gm-Message-State: AOJu0YyMSdB0z/PGhj7XvcZKTHZMBYhYfEnRA0sm/V8gJ8UZ+8kA+WNU
	e5repVhLjidDBkqxyFRHYGYas/pe52Vx/hm/ogu4aWETJ54DlBVR
X-Google-Smtp-Source: AGHT+IFV1FFI1cI7abiH+7KTSeeEW/+3XLs4ah+x+jtitU1XtL5LK2apTa03VWws5gWrvzNJ0ykmqw==
X-Received: by 2002:a05:6a20:12ce:b0:1d9:780a:4311 with SMTP id adf61e73a8af0-1ddaecd0f35mr4458444637.18.1732114827931;
        Wed, 20 Nov 2024 07:00:27 -0800 (PST)
Received: from server.roeck-us.net ([2600:1700:e321:62f0:329c:23ff:fee3:9d7c])
        by smtp.gmail.com with ESMTPSA id 41be03b00d2f7-7f8c1dcf424sm9688998a12.78.2024.11.20.07.00.27
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 20 Nov 2024 07:00:27 -0800 (PST)
Sender: Guenter Roeck <groeck7@gmail.com>
Date: Wed, 20 Nov 2024 07:00:26 -0800
From: Guenter Roeck <linux@roeck-us.net>
To: Geert Uytterhoeven <geert@linux-m68k.org>
Cc: Christoph Lameter <cl@linux.com>, Pekka Enberg <penberg@kernel.org>,
	David Rientjes <rientjes@google.com>,
	Joonsoo Kim <iamjoonsoo.kim@lge.com>,
	Andrew Morton <akpm@linux-foundation.org>,
	Vlastimil Babka <vbabka@suse.cz>,
	Roman Gushchin <roman.gushchin@linux.dev>,
	Hyeonggon Yoo <42.hyeyoo@gmail.com>, Jens Axboe <axboe@kernel.dk>,
	Pavel Begunkov <asml.silence@gmail.com>, Mike@rox.of.borg,
	Rapoport@rox.of.borg, Christian Brauner <brauner@kernel.org>,
	Kees Cook <keescook@chromium.org>, Jann Horn <jannh@google.com>,
	linux-mm@kvack.org, io-uring@vger.kernel.org,
	linux-m68k@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH] slab: Fix too strict alignment check in create_cache()
Message-ID: <5df87ac7-9779-4a9e-b3ca-6aeddb1a4896@roeck-us.net>
References: <80c767a5d5927c099aea5178fbf2c897b459fa90.1732106544.git.geert@linux-m68k.org>
Precedence: bulk
X-Mailing-List: io-uring@vger.kernel.org
List-Id: <io-uring.vger.kernel.org>
List-Subscribe: <mailto:io-uring+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:io-uring+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <80c767a5d5927c099aea5178fbf2c897b459fa90.1732106544.git.geert@linux-m68k.org>

On Wed, Nov 20, 2024 at 01:46:21PM +0100, Geert Uytterhoeven wrote:
> On m68k, where the minimum alignment of unsigned long is 2 bytes:
> 
>     Kernel panic - not syncing: __kmem_cache_create_args: Failed to create slab 'io_kiocb'. Error -22
>     CPU: 0 UID: 0 PID: 1 Comm: swapper Not tainted 6.12.0-atari-03776-g7eaa1f99261a #1783
>     Stack from 0102fe5c:
> 	    0102fe5c 00514a2b 00514a2b ffffff00 00000001 0051f5ed 00425e78 00514a2b
> 	    0041eb74 ffffffea 00000310 0051f5ed ffffffea ffffffea 00601f60 00000044
> 	    0102ff20 000e7a68 0051ab8e 004383b8 0051f5ed ffffffea 000000b8 00000007
> 	    01020c00 00000000 000e77f0 0041e5f0 005f67c0 0051f5ed 000000b6 0102fef4
> 	    00000310 0102fef4 00000000 00000016 005f676c 0060a34c 00000010 00000004
> 	    00000038 0000009a 01000000 000000b8 005f668e 0102e000 00001372 0102ff88
>     Call Trace: [<00425e78>] dump_stack+0xc/0x10
>      [<0041eb74>] panic+0xd8/0x26c
>      [<000e7a68>] __kmem_cache_create_args+0x278/0x2e8
>      [<000e77f0>] __kmem_cache_create_args+0x0/0x2e8
>      [<0041e5f0>] memset+0x0/0x8c
>      [<005f67c0>] io_uring_init+0x54/0xd2
> 
> The minimal alignment of an integral type may differ from its size,
> hence is not safe to assume that an arbitrary freeptr_t (which is
> basically an unsigned long) is always aligned to 4 or 8 bytes.
> 
> As nothing seems to require the additional alignment, it is safe to fix
> this by relaxing the check to the actual minimum alignment of freeptr_t.
> 
> Fixes: aaa736b186239b7d ("io_uring: specify freeptr usage for SLAB_TYPESAFE_BY_RCU io_kiocb cache")
> Fixes: d345bd2e9834e2da ("mm: add kmem_cache_create_rcu()")
> Reported-by: Guenter Roeck <linux@roeck-us.net>
> Closes: https://lore.kernel.org/37c588d4-2c32-4aad-a19e-642961f200d7@roeck-us.net
> Signed-off-by: Geert Uytterhoeven <geert@linux-m68k.org>

On m68k:

Tested-by: Guenter Roeck <linux@roeck-us.net>

