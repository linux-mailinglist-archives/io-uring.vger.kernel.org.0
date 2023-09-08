Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 89D74798F82
	for <lists+io-uring@lfdr.de>; Fri,  8 Sep 2023 21:32:59 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1344881AbjIHTcw (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Fri, 8 Sep 2023 15:32:52 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:54060 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1344885AbjIHTcv (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Fri, 8 Sep 2023 15:32:51 -0400
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 4C4DE1FEA;
        Fri,  8 Sep 2023 12:32:22 -0700 (PDT)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 2DE1DC43395;
        Fri,  8 Sep 2023 19:31:30 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1694201491;
        bh=yegpmFKqZADs6elVAH1kxXTwTX9xDIpofYJDh7KGPhk=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=WUVwk8cGExllQlCjYaElwxp64xKMK3Kk1F3G3ndilWn2VLg0tvAFnoReSIdfSx7jD
         oEENagaVKzoKWP9XvQQUEsZjag7gw+1KHhYBSgr5NzJsBE9dTS2cUXzJoTZuGBHMsL
         5/jfVprQJ9+HzAqKlsHTRmYY57sHuHZJUALUwr0EyFjhmSBnPweHJU2SKSWupOlxsQ
         qSKmqKRBAQCAsS8PlhQBCEnN2WPA9r28tiMWqv2KucQhrerTdlNwSWp2PvB/gyAGVS
         VSkIYuIjC3OT850GeV0cSkBSai07KCKEq9OLf6Vjoa12PhmGhZl+ctoTQkd7H43ExY
         c313dAKAEk3Kw==
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Jens Axboe <axboe@kernel.dk>, Breno Leitao <leitao@debian.org>,
        Sasha Levin <sashal@kernel.org>, keescook@chromium.org,
        nathan@kernel.org, ndesaulniers@google.com,
        io-uring@vger.kernel.org, linux-hardening@vger.kernel.org,
        llvm@lists.linux.dev
Subject: [PATCH AUTOSEL 6.5 27/36] io_uring: annotate the struct io_kiocb slab for appropriate user copy
Date:   Fri,  8 Sep 2023 15:28:38 -0400
Message-Id: <20230908192848.3462476-27-sashal@kernel.org>
X-Mailer: git-send-email 2.40.1
In-Reply-To: <20230908192848.3462476-1-sashal@kernel.org>
References: <20230908192848.3462476-1-sashal@kernel.org>
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
X-stable-base: Linux 6.5.2
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-4.4 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org

From: Jens Axboe <axboe@kernel.dk>

[ Upstream commit b97f96e22f051d59d07a527dbd7d90408b661ca8 ]

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
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 io_uring/io_uring.c | 16 ++++++++++++++--
 1 file changed, 14 insertions(+), 2 deletions(-)

diff --git a/io_uring/io_uring.c b/io_uring/io_uring.c
index 93db3e4e7b688..5006b14f97e1e 100644
--- a/io_uring/io_uring.c
+++ b/io_uring/io_uring.c
@@ -4615,8 +4615,20 @@ static int __init io_uring_init(void)
 
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
+				sizeof_field(struct io_kiocb, cmd.data), NULL);
+
 	return 0;
 };
 __initcall(io_uring_init);
-- 
2.40.1

