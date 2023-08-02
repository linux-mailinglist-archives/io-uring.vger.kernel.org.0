Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 7CBB476D8BF
	for <lists+io-uring@lfdr.de>; Wed,  2 Aug 2023 22:42:41 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230146AbjHBUmk (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Wed, 2 Aug 2023 16:42:40 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:39620 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229460AbjHBUmj (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Wed, 2 Aug 2023 16:42:39 -0400
Received: from mail-io1-xd33.google.com (mail-io1-xd33.google.com [IPv6:2607:f8b0:4864:20::d33])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 5DB601712
        for <io-uring@vger.kernel.org>; Wed,  2 Aug 2023 13:42:37 -0700 (PDT)
Received: by mail-io1-xd33.google.com with SMTP id ca18e2360f4ac-790b6761117so1376139f.0
        for <io-uring@vger.kernel.org>; Wed, 02 Aug 2023 13:42:37 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernel-dk.20221208.gappssmtp.com; s=20221208; t=1691008956; x=1691613756;
        h=content-transfer-encoding:subject:from:cc:to:content-language
         :user-agent:mime-version:date:message-id:from:to:cc:subject:date
         :message-id:reply-to;
        bh=WRRCiEHdhrHL2zN4IG62EDfo+Q9Q6i3ajoAWX60gH1U=;
        b=cT6jyBVtiQqugxbpraVTW9s9fKWzs7EnvX74wCaFyHS+rJ0gmjJt1nOGivsUNUcl65
         A9A4pOsbGWfOgYM4lR6nI3VZftEV/B6FcxbESgkOGkRI9U0vloY+OJFrf/fOR0x9MQ7L
         ycrujswLUX+xdV81kHwteIBLGFnLTvw5MRcT4X0h1WxMpyTOiwKPctQp4Y4tmlxsQo4g
         ndFOodUILQgfFnMl/GbxPwbtW5p2j5hFo3FOkGFFfrjkXKF/JulB9JB3AXO0A/r2rnHV
         Hwdn0trro57aBLO2jUJWQXTK00QPXceZfnzvFOKGUxfEZhSAq/g6fuHRYW1AAMgOKBKj
         DgRQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20221208; t=1691008956; x=1691613756;
        h=content-transfer-encoding:subject:from:cc:to:content-language
         :user-agent:mime-version:date:message-id:x-gm-message-state:from:to
         :cc:subject:date:message-id:reply-to;
        bh=WRRCiEHdhrHL2zN4IG62EDfo+Q9Q6i3ajoAWX60gH1U=;
        b=ejnsw0lSnFPkiqdO1H/KWDN4LYur90v+qFHg749cZdGASDRqDqiJ68rPruXRK8krw7
         cDGPu42XxaoqGt+XrCqKyS+EJC4J4rUGa49kyy1wS4b6Z/hNsrtPcJ4ghEv7xAa9yclf
         KiP1e3FQXblHFIQ8cDPMJSQ0SQ/sl3X+lkQNkSzdDmJHg5IQzR5hmDE1TRtwNEmzuIIm
         3AeYSbTTdeY04ONkh6d1joK9QvzMo1aq2IOR2SJuve9wHwB163BLqyfdkjIdyTQVTAC7
         PxhhUBC9eHb9sKeLaMBoope+sp+9YsG6ZY06CCkxIb/xYi2/vWMqFCR6OBZDccXADYzW
         HfEw==
X-Gm-Message-State: ABy/qLYzZrY1G2lw1iThp+XlMZZOtAbWqxl36wy4CpxnDvio7r519iq0
        jdINoZHOsdqLte0O5YUK2nlCQfZmqhO9gJq4OoE=
X-Google-Smtp-Source: APBJJlGhMYkzIxXbDii2hAioGQ1y3ClZcUhUOAbeLIE2+bzy4UsIhixFp+dHq3HDG3bPZLPIQKyGRQ==
X-Received: by 2002:a05:6602:3d5:b0:780:d65c:d78f with SMTP id g21-20020a05660203d500b00780d65cd78fmr20407354iov.2.1691008956549;
        Wed, 02 Aug 2023 13:42:36 -0700 (PDT)
Received: from [192.168.1.94] ([96.43.243.2])
        by smtp.gmail.com with ESMTPSA id m12-20020a5e8d0c000000b007836e9ff198sm4768366ioj.55.2023.08.02.13.42.36
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Wed, 02 Aug 2023 13:42:36 -0700 (PDT)
Message-ID: <db807b6b-76ca-4101-844a-aa6da1467b98@kernel.dk>
Date:   Wed, 2 Aug 2023 14:42:35 -0600
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux aarch64; rv:102.0) Gecko/20100101
 Thunderbird/102.13.1
Content-Language: en-US
To:     io-uring <io-uring@vger.kernel.org>
Cc:     Breno Leitao <leitao@debian.org>
From:   Jens Axboe <axboe@kernel.dk>
Subject: [PATCH] io_uring: annotate the struct io_kiocb slab for appropriate
 user copy
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=-1.9 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,RCVD_IN_DNSWL_BLOCKED,SPF_HELO_NONE,SPF_PASS,
        T_SCC_BODY_TEXT_LINE,URIBL_BLOCKED autolearn=ham autolearn_force=no
        version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org

When compiling the kernel with clang and having HARDENED_USERCOPY
enabled, the liburing openat2.t test case fails during request setup:

usercopy: Kernel memory overwrite attempt detected to SLUB object 'io_kiocb' (offset 24, size 24)!
------------[ cut here ]------------
kernel BUG at mm/usercopy.c:102!
invalid opcode: 0000 [#1] PREEMPT SMP DEBUG_PAGEALLOC
CPU: 3 PID: 413 Comm: openat2.t Tainted: G                 N 6.4.3-g6995e2de6891-dirty #19
Hardware name: QEMU Standard PC (i440FX + PIIX, 1996), BIOS rel-1.16.1-0-g3208b098f51a-prebuilt.qemu.org 04/01/2014
RIP: 0010:usercopy_abort+0x84/0x90
Code: ce 49 89 ce 48 c7 c3 68 48 98 82 48 0f 44 de 48 c7 c7 56 c6 94 82 4c 89 de 48 89 c1 41 52 41 56 53 e8 e0 51 c5 00 48 83 c4 18 <0f> 0b 66 2e 0f 1f 84 00 00 00 00 00 0f 1f 44 00 00 55 41 57 41 56
RSP: 0018:ffffc900016b3da0 EFLAGS: 00010296
RAX: 0000000000000062 RBX: ffffffff82984868 RCX: 4e9b661ac6275b00
RDX: ffff8881b90ec580 RSI: ffffffff82949a64 RDI: 00000000ffffffff
RBP: 0000000000000018 R08: 0000000000000000 R09: 0000000000000000
R10: ffffc900016b3c88 R11: ffffc900016b3c30 R12: 00007ffe549659e0
R13: ffff888119014000 R14: 0000000000000018 R15: 0000000000000018
FS:  00007f862e3ca680(0000) GS:ffff8881b90c0000(0000) knlGS:0000000000000000
CS:  0010 DS: 0000 ES: 0000 CR0: 0000000080050033
CR2: 00005571483542a8 CR3: 0000000118c11000 CR4: 00000000003506e0
Call Trace:
 <TASK>
 ? __die_body+0x63/0xb0
 ? die+0x9d/0xc0
 ? do_trap+0xa7/0x180
 ? usercopy_abort+0x84/0x90
 ? do_error_trap+0xc6/0x110
 ? usercopy_abort+0x84/0x90
 ? handle_invalid_op+0x2c/0x40
 ? usercopy_abort+0x84/0x90
 ? exc_invalid_op+0x2f/0x40
 ? asm_exc_invalid_op+0x16/0x20
 ? usercopy_abort+0x84/0x90
 __check_heap_object+0xe2/0x110
 __check_object_size+0x142/0x3d0
 io_openat2_prep+0x68/0x140
 io_submit_sqes+0x28a/0x680
 __se_sys_io_uring_enter+0x120/0x580
 do_syscall_64+0x3d/0x80
 entry_SYSCALL_64_after_hwframe+0x46/0xb0
RIP: 0033:0x55714834de26
Code: ca 01 0f b6 82 d0 00 00 00 8b ba cc 00 00 00 45 31 c0 31 d2 41 b9 08 00 00 00 83 e0 01 c1 e0 04 41 09 c2 b8 aa 01 00 00 0f 05 <c3> 66 0f 1f 84 00 00 00 00 00 89 30 eb 89 0f 1f 40 00 8b 00 a8 06
RSP: 002b:00007ffe549659c8 EFLAGS: 00000246 ORIG_RAX: 00000000000001aa
RAX: ffffffffffffffda RBX: 00007ffe54965a50 RCX: 000055714834de26
RDX: 0000000000000000 RSI: 0000000000000001 RDI: 0000000000000003
RBP: 0000000000000000 R08: 0000000000000000 R09: 0000000000000008
R10: 0000000000000000 R11: 0000000000000246 R12: 000055714834f057
R13: 00007ffe54965a50 R14: 0000000000000001 R15: 0000557148351dd8
 </TASK>
Modules linked in:
---[ end trace 0000000000000000 ]---
RIP: 0010:usercopy_abort+0x84/0x90
Code: ce 49 89 ce 48 c7 c3 68 48 98 82 48 0f 44 de 48 c7 c7 56 c6 94 82 4c 89 de 48 89 c1 41 52 41 56 53 e8 e0 51 c5 00 48 83 c4 18 <0f> 0b 66 2e 0f 1f 84 00 00 00 00 00 0f 1f 44 00 00 55 41 57 41 56
RSP: 0018:ffffc900016b3da0 EFLAGS: 00010296
RAX: 0000000000000062 RBX: ffffffff82984868 RCX: 4e9b661ac6275b00
RDX: ffff8881b90ec580 RSI: ffffffff82949a64 RDI: 00000000ffffffff
RBP: 0000000000000018 R08: 0000000000000000 R09: 0000000000000000
R10: ffffc900016b3c88 R11: ffffc900016b3c30 R12: 00007ffe549659e0
R13: ffff888119014000 R14: 0000000000000018 R15: 0000000000000018
FS:  00007f862e3ca680(0000) GS:ffff8881b90c0000(0000) knlGS:0000000000000000
CS:  0010 DS: 0000 ES: 0000 CR0: 0000000080050033
CR2: 00005571483542a8 CR3: 0000000118c11000 CR4: 00000000003506e0
Kernel panic - not syncing: Fatal exception
Kernel Offset: disabled
---[ end Kernel panic - not syncing: Fatal exception ]---

when it tries to copy struct open_how from userspace into the per-command
space in the io_kiocb. There's nothing wrong with the copy, but we're
missing the appropriate annotations for allowing user copies to/from the
io_kiocb slab.

Allow copies in the per-command area, which is from the 'file' pointer to
when 'opcode' starts. We do have existing user copies there, but they are
not all annotated like the one that openat2_prep() uses,
copy_struct_from_user(). But in practice opcodes should be allowed to
copy data into their per-command area in the io_kiocb.

Reported-by: Breno Leitao <leitao@debian.org>
Signed-off-by: Jens Axboe <axboe@kernel.dk>

---

diff --git a/io_uring/io_uring.c b/io_uring/io_uring.c
index 135da2fd0eda..d8e69461786d 100644
--- a/io_uring/io_uring.c
+++ b/io_uring/io_uring.c
@@ -4627,8 +4627,20 @@ static int __init io_uring_init(void)
 
 	io_uring_optable_init();
 
-	req_cachep = KMEM_CACHE(io_kiocb, SLAB_HWCACHE_ALIGN | SLAB_PANIC |
-				SLAB_ACCOUNT | SLAB_TYPESAFE_BY_RCU);
+	/*
+	 * Allow user copy in the per-command field, which starts after the
+	 * file in io_kiocb and until the opcode field. The openat2 handling
+	 * requires copying in user memory into the io_kiocb object in that
+	 * range, and HARDENED_USERCOPY will complain if we haven't
+	 * correctly annotated this range.
+	 */
+	req_cachep = kmem_cache_create_usercopy("io_kiocb",
+				sizeof(struct io_kiocb), 0,
+				SLAB_HWCACHE_ALIGN | SLAB_PANIC |
+				SLAB_ACCOUNT | SLAB_TYPESAFE_BY_RCU,
+				offsetof(struct io_kiocb, cmd.data),
+				offsetof(struct io_kiocb, opcode) -
+				offsetof(struct io_kiocb, cmd.data), NULL);
 
 #ifdef CONFIG_SYSCTL
 	register_sysctl_init("kernel", kernel_io_uring_disabled_table);

-- 
Jens Axboe

