Return-Path: <io-uring+bounces-4849-lists+io-uring=lfdr.de@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [147.75.80.249])
	by mail.lfdr.de (Postfix) with ESMTPS id A74419D3079
	for <lists+io-uring@lfdr.de>; Tue, 19 Nov 2024 23:31:05 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id 389061F21543
	for <lists+io-uring@lfdr.de>; Tue, 19 Nov 2024 22:31:05 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 8FDBA45945;
	Tue, 19 Nov 2024 22:31:00 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel-dk.20230601.gappssmtp.com header.i=@kernel-dk.20230601.gappssmtp.com header.b="nuercU/d"
X-Original-To: io-uring@vger.kernel.org
Received: from mail-pl1-f178.google.com (mail-pl1-f178.google.com [209.85.214.178])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id ACF4E17BB38
	for <io-uring@vger.kernel.org>; Tue, 19 Nov 2024 22:30:57 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.214.178
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1732055460; cv=none; b=sLAgdiZfm6aVIikwE3Pv+KmejusvZF5Qrhu4uxGZsJl/0UD7pT5UDVnA5FF0/zUlCjM21a9xIPEIY0sE0S+0ObnueN4xIRnWmVKg+sYwcv0MEao12fqYi/NrUm9WhBXqVb1K3fB0fAwlvPBwnuvsgBjtc/Xv1RDP6huq2ZDO54A=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1732055460; c=relaxed/simple;
	bh=w3GeayPl7ir6euitZT6Zi9W7XEsr1rAg6QQkygGFkzQ=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=kRN9PzFzANoJAEe+7ObZOqfO5kWCNSiHhxJkpHjUBlY9b3tGTUXjynXvqeDSTdc8B+vMjiFEZ/BerCoQDGxGmI+DcLO1k4ixueLb+JaAU3nDJCiC2i0pvoA4PJfK1ng+by/+7Vo1qtoQnSxK39G1c8giZTx+/BwAC5NQgI2loIM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=kernel.dk; spf=pass smtp.mailfrom=kernel.dk; dkim=pass (2048-bit key) header.d=kernel-dk.20230601.gappssmtp.com header.i=@kernel-dk.20230601.gappssmtp.com header.b=nuercU/d; arc=none smtp.client-ip=209.85.214.178
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=kernel.dk
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=kernel.dk
Received: by mail-pl1-f178.google.com with SMTP id d9443c01a7336-20c803787abso2285265ad.0
        for <io-uring@vger.kernel.org>; Tue, 19 Nov 2024 14:30:57 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernel-dk.20230601.gappssmtp.com; s=20230601; t=1732055457; x=1732660257; darn=vger.kernel.org;
        h=content-transfer-encoding:in-reply-to:from:content-language
         :references:cc:to:subject:user-agent:mime-version:date:message-id
         :from:to:cc:subject:date:message-id:reply-to;
        bh=otLzVUnNsJXfe+aY7L9yijdnruJk8S0GtPX3qdNtbEY=;
        b=nuercU/dxitZGauSB1mPC7UTrDZittJwO0Stxrm1An8538kD4s9v+khlGge/x5Vpg/
         yeqIJID2aQO2Ztmaku40HlcBFNKlEotIkjUfc2sT5zxjKWiVf2CyR24zhGJueiiud0Fn
         A9cKjTEgqH2p6k7XPfMabDaMcRKaFfxustOfGGRM+hhwCEMYrT2ZpGAYLYrSZ4me9aBQ
         w1bGK8+YapYa3LxUr4j10eJ3Dxn3nuMz92Ff+aCJLZduY6+UGlkswLlz5G3E4k8xjom4
         x8khTqTIWGDtbfdmZOZDufj8BYSZisaZYKlo03fLryDy0BQEI/i3VR3FDEimFiTXKja3
         cRZQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1732055457; x=1732660257;
        h=content-transfer-encoding:in-reply-to:from:content-language
         :references:cc:to:subject:user-agent:mime-version:date:message-id
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=otLzVUnNsJXfe+aY7L9yijdnruJk8S0GtPX3qdNtbEY=;
        b=CPywJCehXX8gF+DDhMGCyQn0Yun4VkW2zQYAnkrBvuZnqZgL7YsFYSw/5yS8iEhBO/
         yMbZO9zSkRUmDMsB7n/upfq2nocLa0sUnuF/4MwPBLac2Kt9ox3UX8eFto7jbn0hIOIP
         bys6C9+nXKhahsgN+F9JlOw0527VUAkZy6O5NZbpCu0JTODAdYWYNZHcXa04E227DUtw
         rnyDayp0Qqv8S0dKuIG/iQW0kC6BDjr0HcjijIzJgzp15EnM3uxksICCTjj1aGS9DwIW
         EY65gAAKibqa2bumn4ur2t9p5i5iI1qU8Wl8mxQt+ExYZtbyhvvg+gy/CPXZWj6MKSzl
         nC8w==
X-Gm-Message-State: AOJu0YzX4O0r67j9XvpkOVMl73f8ds3iTVlr4+kjT0bmvL8PtgA9rrW3
	dLZa0oGO1RAsSA5d0vA1njpfrUSV3p+RynMvwB/5li2kgBb4+RTIO5pchEtQ2lY=
X-Google-Smtp-Source: AGHT+IHC5ePC7J6v2xsCVSLUkEH4Xbdj0AflC04vIJ6SGRI6qBASX+S/OnHBQ4PwGv0IFR0nxwdjfw==
X-Received: by 2002:a17:902:dace:b0:212:f7d:9284 with SMTP id d9443c01a7336-21269dc8946mr12625945ad.8.1732055456537;
        Tue, 19 Nov 2024 14:30:56 -0800 (PST)
Received: from [192.168.1.150] ([198.8.77.157])
        by smtp.gmail.com with ESMTPSA id d9443c01a7336-211fd7021f2sm58351895ad.68.2024.11.19.14.30.55
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Tue, 19 Nov 2024 14:30:55 -0800 (PST)
Message-ID: <6c3d73a5-b5ef-455f-92db-e6b96ef22fba@kernel.dk>
Date: Tue, 19 Nov 2024 15:30:55 -0700
Precedence: bulk
X-Mailing-List: io-uring@vger.kernel.org
List-Id: <io-uring.vger.kernel.org>
List-Subscribe: <mailto:io-uring+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:io-uring+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH 03/14] io_uring: specify freeptr usage for
 SLAB_TYPESAFE_BY_RCU io_kiocb cache
To: Guenter Roeck <linux@roeck-us.net>,
 Geert Uytterhoeven <geert@linux-m68k.org>
Cc: io-uring@vger.kernel.org, linux-m68k <linux-m68k@lists.linux-m68k.org>
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
 <358710e8-a826-46df-9846-5a9e0f7c6851@kernel.dk>
 <CAMuHMdUsj9FsX=_rHwYjiXT8RehP6HW5hUL9LMvE0pt7Z8kc8w@mail.gmail.com>
 <82b97543-ad01-4e42-b79c-12d97c1df194@kernel.dk>
 <4623f30c-a12e-4ba6-ad99-835764611c67@kernel.dk>
 <47a16a83-52c7-4779-9ed3-f16ea547b9f0@roeck-us.net>
Content-Language: en-US
From: Jens Axboe <axboe@kernel.dk>
In-Reply-To: <47a16a83-52c7-4779-9ed3-f16ea547b9f0@roeck-us.net>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit

On 11/19/24 2:46 PM, Guenter Roeck wrote:
> On 11/19/24 11:49, Jens Axboe wrote:
>> On 11/19/24 12:44 PM, Jens Axboe wrote:
>>> On 11/19/24 12:41 PM, Geert Uytterhoeven wrote:
>>>> Hi Jens,
>>>>
>>>> On Tue, Nov 19, 2024 at 8:30?PM Jens Axboe <axboe@kernel.dk> wrote:
>>>>> On 11/19/24 12:25 PM, Geert Uytterhoeven wrote:
>>>>>> On Tue, Nov 19, 2024 at 8:10?PM Jens Axboe <axboe@kernel.dk> wrote:
>>>>>>> On 11/19/24 12:02 PM, Geert Uytterhoeven wrote:
>>>>>>>> On Tue, Nov 19, 2024 at 8:00?PM Jens Axboe <axboe@kernel.dk> wrote:
>>>>>>>>> On 11/19/24 10:49 AM, Geert Uytterhoeven wrote:
>>>>>>>>>> On Tue, Nov 19, 2024 at 5:21?PM Guenter Roeck <linux@roeck-us.net> wrote:
>>>>>>>>>>> On 11/19/24 08:02, Jens Axboe wrote:
>>>>>>>>>>>> On 11/19/24 8:36 AM, Guenter Roeck wrote:
>>>>>>>>>>>>> On Tue, Oct 29, 2024 at 09:16:32AM -0600, Jens Axboe wrote:
>>>>>>>>>>>>>> Doesn't matter right now as there's still some bytes left for it, but
>>>>>>>>>>>>>> let's prepare for the io_kiocb potentially growing and add a specific
>>>>>>>>>>>>>> freeptr offset for it.
>>>>>>>>>>>>>>
>>>>>>>>>>>>>> Signed-off-by: Jens Axboe <axboe@kernel.dk>
>>>>>>>>>>>>>
>>>>>>>>>>>>> This patch triggers:
>>>>>>>>>>>>>
>>>>>>>>>>>>> Kernel panic - not syncing: __kmem_cache_create_args: Failed to create slab 'io_kiocb'. Error -22
>>>>>>>>>>>>> CPU: 0 UID: 0 PID: 1 Comm: swapper Not tainted 6.12.0-mac-00971-g158f238aa69d #1
>>>>>>>>>>>>> Stack from 00c63e5c:
>>>>>>>>>>>>>           00c63e5c 00612c1c 00612c1c 00000300 00000001 005f3ce6 004b9044 00612c1c
>>>>>>>>>>>>>           004ae21e 00000310 000000b6 005f3ce6 005f3ce6 ffffffea ffffffea 00797244
>>>>>>>>>>>>>           00c63f20 000c6974 005ee588 004c9051 005f3ce6 ffffffea 000000a5 00c614a0
>>>>>>>>>>>>>           004a72c2 0002cb62 000c675e 004adb58 0076f28a 005f3ce6 000000b6 00c63ef4
>>>>>>>>>>>>>           00000310 00c63ef4 00000000 00000016 0076f23e 00c63f4c 00000010 00000004
>>>>>>>>>>>>>           00000038 0000009a 01000000 00000000 00000000 00000000 000020e0 0076f23e
>>>>>>>>>>>>> Call Trace: [<004b9044>] dump_stack+0xc/0x10
>>>>>>>>>>>>>    [<004ae21e>] panic+0xc4/0x252
>>>>>>>>>>>>>    [<000c6974>] __kmem_cache_create_args+0x216/0x26c
>>>>>>>>>>>>>    [<004a72c2>] strcpy+0x0/0x1c
>>>>>>>>>>>>>    [<0002cb62>] parse_args+0x0/0x1f2
>>>>>>>>>>>>>    [<000c675e>] __kmem_cache_create_args+0x0/0x26c
>>>>>>>>>>>>>    [<004adb58>] memset+0x0/0x8c
>>>>>>>>>>>>>    [<0076f28a>] io_uring_init+0x4c/0xca
>>>>>>>>>>>>>    [<0076f23e>] io_uring_init+0x0/0xca
>>>>>>>>>>>>>    [<000020e0>] do_one_initcall+0x32/0x192
>>>>>>>>>>>>>    [<0076f23e>] io_uring_init+0x0/0xca
>>>>>>>>>>>>>    [<0000211c>] do_one_initcall+0x6e/0x192
>>>>>>>>>>>>>    [<004a72c2>] strcpy+0x0/0x1c
>>>>>>>>>>>>>    [<0002cb62>] parse_args+0x0/0x1f2
>>>>>>>>>>>>>    [<000020ae>] do_one_initcall+0x0/0x192
>>>>>>>>>>>>>    [<0075c4e2>] kernel_init_freeable+0x1a0/0x1a4
>>>>>>>>>>>>>    [<0076f23e>] io_uring_init+0x0/0xca
>>>>>>>>>>>>>    [<004b911a>] kernel_init+0x0/0xec
>>>>>>>>>>>>>    [<004b912e>] kernel_init+0x14/0xec
>>>>>>>>>>>>>    [<004b911a>] kernel_init+0x0/0xec
>>>>>>>>>>>>>    [<0000252c>] ret_from_kernel_thread+0xc/0x14
>>>>>>>>>>>>>
>>>>>>>>>>>>> when trying to boot the m68k:q800 machine in qemu.
>>>>>>>>>>>>>
>>>>>>>>>>>>> An added debug message in create_cache() shows the reason:
>>>>>>>>>>>>>
>>>>>>>>>>>>> #### freeptr_offset=154 object_size=182 flags=0x310 aligned=0 sizeof(freeptr_t)=4
>>>>>>>>>>>>>
>>>>>>>>>>>>> freeptr_offset would need to be 4-byte aligned but that is not the
>>>>>>>>>>>>> case on m68k.
>>>>>>>>>>>>
>>>>>>>>>>>> Why is ->work 2-byte aligned to begin with on m68k?!
>>>>>>>>>>>
>>>>>>>>>>> My understanding is that m68k does not align pointers.
>>>>>>>>>>
>>>>>>>>>> The minimum alignment for multi-byte integral values on m68k is
>>>>>>>>>> 2 bytes.
>>>>>>>>>>
>>>>>>>>>> See also the comment at
>>>>>>>>>> https://elixir.bootlin.com/linux/v6.12/source/include/linux/maple_tree.h#L46
>>>>>>>>>
>>>>>>>>> Maybe it's time we put m68k to bed? :-)
>>>>>>>>>
>>>>>>>>> We can add a forced alignment ->work to be 4 bytes, won't change
>>>>>>>>> anything on anything remotely current. But does feel pretty hacky to
>>>>>>>>> need to align based on some ancient thing.
>>>>>>>>
>>>>>>>> Why does freeptr_offset need to be 4-byte aligned?
>>>>>>>
>>>>>>> Didn't check, but it's slab/slub complaining using a 2-byte aligned
>>>>>>> address for the free pointer offset. It's explicitly checking:
>>>>>>>
>>>>>>>          /* If a custom freelist pointer is requested make sure it's sane. */
>>>>>>>          err = -EINVAL;
>>>>>>>          if (args->use_freeptr_offset &&
>>>>>>>              (args->freeptr_offset >= object_size ||
>>>>>>>               !(flags & SLAB_TYPESAFE_BY_RCU) ||
>>>>>>>               !IS_ALIGNED(args->freeptr_offset, sizeof(freeptr_t))))
>>>>>>>                  goto out;
>>>>>>
>>>>>> It is not guaranteed that alignof(freeptr_t) >= sizeof(freeptr_t)
>>>>>> (free_ptr is sort of a long). If freeptr_offset must be a multiple of
>>>>>> 4 or 8 bytes,
>>>>>> the code that assigns it must make sure that is true.
>>>>>
>>>>> Right, this is what the email is about...
>>>>>
>>>>>> I guess this is the code in fs/file_table.c:
>>>>>>
>>>>>>      .freeptr_offset = offsetof(struct file, f_freeptr),
>>>>>>
>>>>>> which references:
>>>>>>
>>>>>>      include/linux/fs.h:           freeptr_t               f_freeptr;
>>>>>>
>>>>>> I guess the simplest solution is to add an __aligned(sizeof(freeptr_t))
>>>>>> (or __aligned(sizeof(long)) to the definition of freeptr_t:
>>>>>>
>>>>>>      include/linux/slab.h:typedef struct { unsigned long v; } freeptr_t;
>>>>>
>>>>> It's not, it's struct io_kiocb->work, as per the stack trace in this
>>>>> email.
>>>>
>>>> Sorry, I was falling out of thin air into this thread...
>>>>
>>>> linux-next/master:io_uring/io_uring.c:          .freeptr_offset =
>>>> offsetof(struct io_kiocb, work),
>>>> linux-next/master:io_uring/io_uring.c:          .use_freeptr_offset = true,
>>>>
>>>> Apparently io_kiocb.work is of type struct io_wq_work, not freeptr_t?
>>>> Isn't that a bit error-prone, as the slab core code expects a freeptr_t?
>>>
>>> It just needs the space, should not matter otherwise. But may as well
>>> just add the union and align the freeptr so it stop complaining on m68k.
>>
>> Ala the below, perhaps alignment takes care of itself then?
>>
> 
> No, that doesn't work (I tried), at least not on its own, because the pointer
> is still unaligned on m68k.

Yeah we'll likely need to force it. The below should work, I pressume?
Feels pretty odd to have to align it to the size of it, when that should
naturally occur... Crusty legacy archs.

diff --git a/include/linux/io_uring_types.h b/include/linux/io_uring_types.h
index 593c10a02144..8ed9c6923668 100644
--- a/include/linux/io_uring_types.h
+++ b/include/linux/io_uring_types.h
@@ -674,7 +674,11 @@ struct io_kiocb {
 	struct io_kiocb			*link;
 	/* custom credentials, valid IFF REQ_F_CREDS is set */
 	const struct cred		*creds;
-	struct io_wq_work		work;
+
+	union {
+		struct io_wq_work	work;
+		freeptr_t		freeptr __aligned(sizeof(freeptr_t));
+	};
 
 	struct {
 		u64			extra1;
diff --git a/io_uring/io_uring.c b/io_uring/io_uring.c
index 73af59863300..86ac7df2a601 100644
--- a/io_uring/io_uring.c
+++ b/io_uring/io_uring.c
@@ -3812,7 +3812,7 @@ static int __init io_uring_init(void)
 	struct kmem_cache_args kmem_args = {
 		.useroffset = offsetof(struct io_kiocb, cmd.data),
 		.usersize = sizeof_field(struct io_kiocb, cmd.data),
-		.freeptr_offset = offsetof(struct io_kiocb, work),
+		.freeptr_offset = offsetof(struct io_kiocb, freeptr),
 		.use_freeptr_offset = true,
 	};
 
-- 
Jens Axboe

