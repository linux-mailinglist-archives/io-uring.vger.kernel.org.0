Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 1D7581A0D47
	for <lists+io-uring@lfdr.de>; Tue,  7 Apr 2020 14:04:31 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726591AbgDGMEa (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Tue, 7 Apr 2020 08:04:30 -0400
Received: from out30-130.freemail.mail.aliyun.com ([115.124.30.130]:55863 "EHLO
        out30-130.freemail.mail.aliyun.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1728637AbgDGMEa (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Tue, 7 Apr 2020 08:04:30 -0400
X-Alimail-AntiSpam: AC=PASS;BC=-1|-1;BR=01201311R261e4;CH=green;DM=||false|;DS=||;FP=0|-1|-1|-1|0|-1|-1|-1;HT=e01e01419;MF=xiaoguang.wang@linux.alibaba.com;NM=1;PH=DS;RN=4;SR=0;TI=SMTPD_---0Tuu--x3_1586260971;
Received: from localhost(mailfrom:xiaoguang.wang@linux.alibaba.com fp:SMTPD_---0Tuu--x3_1586260971)
          by smtp.aliyun-inc.com(127.0.0.1);
          Tue, 07 Apr 2020 20:02:57 +0800
From:   Xiaoguang Wang <xiaoguang.wang@linux.alibaba.com>
To:     io-uring@vger.kernel.org
Cc:     axboe@kernel.dk, joseph.qi@linux.alibaba.com,
        Xiaoguang Wang <xiaoguang.wang@linux.alibaba.com>
Subject: [PATCH for-next] io_uring: initialize fixed_file_data lock
Date:   Tue,  7 Apr 2020 20:02:31 +0800
Message-Id: <20200407120231.2644-1-xiaoguang.wang@linux.alibaba.com>
X-Mailer: git-send-email 2.17.2
Sender: io-uring-owner@vger.kernel.org
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org

syzbot reports below warning:
INFO: trying to register non-static key.
the code is fine but needs lockdep annotation.
turning off the locking correctness validator.
CPU: 1 PID: 7099 Comm: syz-executor897 Not tainted 5.6.0-next-20200406-syzkaller #0
Hardware name: Google Google Compute Engine/Google Compute Engine, BIOS Google 01/01/2011
Call Trace:
 __dump_stack lib/dump_stack.c:77 [inline]
 dump_stack+0x188/0x20d lib/dump_stack.c:118
 assign_lock_key kernel/locking/lockdep.c:913 [inline]
 register_lock_class+0x1664/0x1760 kernel/locking/lockdep.c:1225
 __lock_acquire+0x104/0x4e00 kernel/locking/lockdep.c:4223
 lock_acquire+0x1f2/0x8f0 kernel/locking/lockdep.c:4923
 __raw_spin_lock_irqsave include/linux/spinlock_api_smp.h:110 [inline]
 _raw_spin_lock_irqsave+0x8c/0xbf kernel/locking/spinlock.c:159
 io_sqe_files_register fs/io_uring.c:6599 [inline]
 __io_uring_register+0x1fe8/0x2f00 fs/io_uring.c:8001
 __do_sys_io_uring_register fs/io_uring.c:8081 [inline]
 __se_sys_io_uring_register fs/io_uring.c:8063 [inline]
 __x64_sys_io_uring_register+0x192/0x560 fs/io_uring.c:8063
 do_syscall_64+0xf6/0x7d0 arch/x86/entry/common.c:295
 entry_SYSCALL_64_after_hwframe+0x49/0xb3
RIP: 0033:0x440289
Code: 18 89 d0 c3 66 2e 0f 1f 84 00 00 00 00 00 0f 1f 00 48 89 f8 48 89 f7
48 89 d6 48 89 ca 4d 89 c2 4d 89 c8 4c 8b 4c 24 08 0f 05 <48> 3d 01 f0 ff
ff 0f 83 fb 13 fc ff c3 66 2e 0f 1f 84 00 00 00 00
RSP: 002b:00007ffff1bbf558 EFLAGS: 00000246 ORIG_RAX: 00000000000001ab
RAX: ffffffffffffffda RBX: 00000000004002c8 RCX: 0000000000440289
RDX: 0000000020000280 RSI: 0000000000000002 RDI: 0000000000000003
RBP: 00000000006ca018 R08: 0000000000000000 R09: 00000000004002c8
R10: 0000000000000001 R11: 0000000000000246 R12: 0000000000401b10
R13: 0000000000401ba0 R14: 0000000000000000 R15: 0000000000000000

Initialize struct fixed_file_data's lock to fix this issue.

Reported-by: syzbot+e6eeca4a035da76b3065@syzkaller.appspotmail.com
Fixes: 055895537302 ("io_uring: refactor file register/unregister/update handling")
Signed-off-by: Xiaoguang Wang <xiaoguang.wang@linux.alibaba.com>
---
 fs/io_uring.c | 1 +
 1 file changed, 1 insertion(+)

diff --git a/fs/io_uring.c b/fs/io_uring.c
index 79bd22289d73..6ac830b2b4fb 100644
--- a/fs/io_uring.c
+++ b/fs/io_uring.c
@@ -6504,6 +6504,7 @@ static int io_sqe_files_register(struct io_ring_ctx *ctx, void __user *arg,
 	ctx->file_data->ctx = ctx;
 	init_completion(&ctx->file_data->done);
 	INIT_LIST_HEAD(&ctx->file_data->ref_list);
+	spin_lock_init(&ctx->file_data->lock);
 
 	nr_tables = DIV_ROUND_UP(nr_args, IORING_MAX_FILES_TABLE);
 	ctx->file_data->table = kcalloc(nr_tables,
-- 
2.17.2

