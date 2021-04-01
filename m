Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 9235F351193
	for <lists+io-uring@lfdr.de>; Thu,  1 Apr 2021 11:12:24 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233643AbhDAJLA (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Thu, 1 Apr 2021 05:11:00 -0400
Received: from out30-132.freemail.mail.aliyun.com ([115.124.30.132]:55338 "EHLO
        out30-132.freemail.mail.aliyun.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S233683AbhDAJK3 (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Thu, 1 Apr 2021 05:10:29 -0400
X-Alimail-AntiSpam: AC=PASS;BC=-1|-1;BR=01201311R141e4;CH=green;DM=||false|;DS=||;FP=0|-1|-1|-1|0|-1|-1|-1;HT=e01e04395;MF=haoxu@linux.alibaba.com;NM=1;PH=DS;RN=4;SR=0;TI=SMTPD_---0UU61P1E_1617268222;
Received: from e18g09479.et15sqa.tbsite.net(mailfrom:haoxu@linux.alibaba.com fp:SMTPD_---0UU61P1E_1617268222)
          by smtp.aliyun-inc.com(127.0.0.1);
          Thu, 01 Apr 2021 17:10:27 +0800
From:   Hao Xu <haoxu@linux.alibaba.com>
To:     Jens Axboe <axboe@kernel.dk>
Cc:     io-uring@vger.kernel.org, Pavel Begunkov <asml.silence@gmail.com>,
        Joseph Qi <joseph.qi@linux.alibaba.com>
Subject: [PATCH] io_uring: fix ctx cancellation for rings allocation failure
Date:   Thu,  1 Apr 2021 17:10:22 +0800
Message-Id: <1617268222-151286-1-git-send-email-haoxu@linux.alibaba.com>
X-Mailer: git-send-email 1.8.3.1
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org

abaci reported the follow issue:
RDX: 0000000000000001 RSI: 0000000020000a80 RDI: 0000000000007a32
RBP: 0000000000000000 R08: 00007facc4ccb1bd R09: 0000000000000000
R10: 0000000000000000 R11: 0000000000000246 R12: 00000000004007c0
R13: 00007ffdf5fa1380 R14: 0000000000000000 R15: 0000000000000000
BUG: kernel NULL pointer dereference, address: 00000000000000c0
PGD 8000000105fc7067 P4D 8000000105fc7067 PUD 10c6a5067 PMD 0
Oops: 0002 [#1] SMP PTI
Hardware name: Red Hat KVM, BIOS 0.5.1 01/01/2011
RIP: 0010:io_commit_cqring+0xf6/0x190 fs/io_uring.c:1318
Code: 85 c0 0f 85 6d ff ff ff e8 67 2d d4 ff 44 89 a5 10 06 00 00 e8 5b 2d d4 ff 48 8b 85 40 04 00 00 8b 95 00 06 00 00 4c 8d 65 78 <89> 90 c0 00 00 00 48 8b 45 78 49 39 c4 75 6c 5b 5d 41 5c 41 5d e9
RSP: 0018:ffffc90001283db0 EFLAGS: 00010093
RAX: 0000000000000000 RBX: 0000000000000000 RCX: 0000000000000000
RDX: 0000000000000000 RSI: ffffffff814c2b45 RDI: ffff888105f0b000
RBP: ffff888105f0b000 R08: ffff88810c534c80 R09: 00000000fffffffe
R10: 0000000089b853a8 R11: 00000000fec8d1bc R12: ffff888105f0b078
R13: ffff888105f0b088 R14: 0000000000000000 R15: 0000000000100140
FS:  00007facc547d740(0000) GS:ffff88813bd00000(0000) knlGS:0000000000000000
CS:  0010 DS: 0000 ES: 0000 CR0: 0000000080050033
CR2: 00000000000000c0 CR3: 000000010c5a0006 CR4: 00000000003706e0
DR0: 0000000000000000 DR1: 0000000000000000 DR2: 0000000000000000
DR3: 0000000000000000 DR6: 00000000fffe0ff0 DR7: 0000000000000400
Call Trace:
 io_kill_timeouts+0x125/0x140 fs/io_uring.c:8606
 io_ring_ctx_wait_and_kill+0x109/0x1d0 fs/io_uring.c:8629
 io_uring_create+0x4c9/0xfb0 fs/io_uring.c:9574
 io_uring_setup+0x8c/0xd0 fs/io_uring.c:9601
 do_syscall_64+0x2d/0x40 arch/x86/entry/common.c:46
 entry_SYSCALL_64_after_hwframe+0x44/0xae
RIP: 0033:0x7facc4d76239
Code: 01 00 48 81 c4 80 00 00 00 e9 f1 fe ff ff 0f 1f 00 48 89 f8 48 89 f7 48 89 d6 48 89 ca 4d 89 c2 4d 89 c8 4c 8b 4c 24 08 0f 05 <48> 3d 01 f0 ff ff 73 01 c3 48 8b 0d 27 ec 2c 00 f7 d8 64 89 01 48
RSP: 002b:00007ffdf5fa1298 EFLAGS: 00000246 ORIG_RAX: 00000000000001a9
RAX: ffffffffffffffda RBX: 0000000000400d38 RCX: 00007facc4d76239
RDX: 0000000000000001 RSI: 0000000020000a80 RDI: 0000000000007a32
RBP: 0000000000000000 R08: 00007facc4ccb1bd R09: 0000000000000000
R10: 0000000000000000 R11: 0000000000000246 R12: 00000000004007c0
R13: 00007ffdf5fa1380 R14: 0000000000000000 R15: 0000000000000000
Modules linked in:
Dumping ftrace buffer:
   (ftrace buffer empty)
CR2: 00000000000000c0

This is caused by access ctx->rings in io_ring_ctx_wait_and_kill()
while ctx->rings is NULL because of allocation failure.

Reported-by: Abaci <abaci@linux.alibaba.com>
Signed-off-by: Hao Xu <haoxu@linux.alibaba.com>
---
 fs/io_uring.c | 8 ++++++--
 1 file changed, 6 insertions(+), 2 deletions(-)

diff --git a/fs/io_uring.c b/fs/io_uring.c
index 1949b80677e7..03f593f5e740 100644
--- a/fs/io_uring.c
+++ b/fs/io_uring.c
@@ -8616,12 +8616,16 @@ static void io_ring_ctx_wait_and_kill(struct io_ring_ctx *ctx)
 	unsigned long index;
 	struct creds *creds;
 
+	if (!ctx->rings) {
+		io_ring_ctx_free(ctx);
+		return;
+	}
+
 	mutex_lock(&ctx->uring_lock);
 	percpu_ref_kill(&ctx->refs);
 	/* if force is set, the ring is going away. always drop after that */
 	ctx->cq_overflow_flushed = 1;
-	if (ctx->rings)
-		__io_cqring_overflow_flush(ctx, true, NULL, NULL);
+	__io_cqring_overflow_flush(ctx, true, NULL, NULL);
 	xa_for_each(&ctx->personalities, index, creds)
 		io_unregister_personality(ctx, index);
 	mutex_unlock(&ctx->uring_lock);
-- 
1.8.3.1

