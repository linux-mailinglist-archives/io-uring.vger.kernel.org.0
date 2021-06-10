Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id D5ED53A275D
	for <lists+io-uring@lfdr.de>; Thu, 10 Jun 2021 10:45:25 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229770AbhFJIrU (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Thu, 10 Jun 2021 04:47:20 -0400
Received: from out30-133.freemail.mail.aliyun.com ([115.124.30.133]:59606 "EHLO
        out30-133.freemail.mail.aliyun.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S229823AbhFJIrU (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Thu, 10 Jun 2021 04:47:20 -0400
X-Alimail-AntiSpam: AC=PASS;BC=-1|-1;BR=01201311R941e4;CH=green;DM=||false|;DS=||;FP=0|-1|-1|-1|0|-1|-1|-1;HT=e01e04395;MF=haoxu@linux.alibaba.com;NM=1;PH=DS;RN=4;SR=0;TI=SMTPD_---0UbxHC4T_1623314716;
Received: from e18g09479.et15sqa.tbsite.net(mailfrom:haoxu@linux.alibaba.com fp:SMTPD_---0UbxHC4T_1623314716)
          by smtp.aliyun-inc.com(127.0.0.1);
          Thu, 10 Jun 2021 16:45:23 +0800
From:   Hao Xu <haoxu@linux.alibaba.com>
To:     Jens Axboe <axboe@kernel.dk>
Cc:     io-uring@vger.kernel.org, Pavel Begunkov <asml.silence@gmail.com>,
        Joseph Qi <joseph.qi@linux.alibaba.com>
Subject: [PATCH] io_uring: use io_poll_get_double in io_poll_double_wake
Date:   Thu, 10 Jun 2021 16:45:16 +0800
Message-Id: <1623314716-55024-1-git-send-email-haoxu@linux.alibaba.com>
X-Mailer: git-send-email 1.8.3.1
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org

Correct wrong use of io_poll_get_single in io_poll_double_wake, which
I think is a slip-up.

[   55.204528] WARNING: CPU: 0 PID: 2660 at fs/io_uring.c:1512 io_poll_double_wake+0x1d6/0x1f0
[   55.204546] Modules linked in:
[   55.204560] CPU: 0 PID: 2660 Comm: a.out Not tainted 5.13.0-rc3+ #1
[   55.204575] RIP: 0010:io_poll_double_wake+0x1d6/0x1f0
[   55.204584] Code: ff 48 89 eb e9 8b fe ff ff e8 c6 68 d3 ff 49 c7 44 24 08 00 00 00 00 48 8b 7b 08 e8 e4 7b 9d 00 e9 5d ff ff ff e8 aa 68 d3 ff <0f> 0b e9 76 ff ff ff e8 9e 68 d3 ff 0f 0b e9 59 ff ff ff 0f 1f 80
[   55.204592] RSP: 0018:ffffc90003c73cc8 EFLAGS: 00010093
[   55.204599] RAX: 0000000000000000 RBX: ffff88810fcf6500 RCX: 0000000000000000
[   55.204604] RDX: ffff88810d38b500 RSI: ffffffff814d3dd6 RDI: ffff88810ff5fd60
[   55.204610] RBP: ffff88810fcf6500 R08: ffff88810d38bf38 R09: 00000000fffffffe
[   55.204615] R10: 00000000e2886200 R11: 000000005dbbc615 R12: ffff88810d068658
[   55.204620] R13: 0000000000000000 R14: 0000000000000001 R15: 0000000040000000
[   55.204625] FS:  00007f84d6170700(0000) GS:ffff88813bc00000(0000) knlGS:0000000000000000
[   55.204635] CS:  0010 DS: 0000 ES: 0000 CR0: 0000000080050033
[   55.204640] CR2: 00007f84d616fef8 CR3: 000000010ffd2006 CR4: 00000000001706f0
[   55.204646] Call Trace:
[   55.204656]  __wake_up_common+0x9f/0x1b0
[   55.204674]  __wake_up_common_lock+0x7a/0xc0
[   55.204694]  tty_ldisc_lock+0x44/0x80
[   55.204705]  tty_ldisc_hangup+0xe3/0x240
[   55.204719]  __tty_hangup+0x26b/0x360
[   55.204736]  tty_ioctl+0x6be/0xb20
[   55.204747]  ? do_vfs_ioctl+0x1af/0xaa0
[   55.204757]  ? __fget_files+0x15a/0x260
[   55.204774]  ? tty_vhangup+0x20/0x20
[   55.204787]  __x64_sys_ioctl+0xbb/0x100
[   55.204801]  do_syscall_64+0x36/0x70
[   55.204813]  entry_SYSCALL_64_after_hwframe+0x44/0xae

Reported-by: Abaci <abaci@linux.alibaba.com>
Fixes: d4e7cd36a90e ("io_uring: sanitize double poll handling")
Signed-off-by: Hao Xu <haoxu@linux.alibaba.com>
---
 fs/io_uring.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/fs/io_uring.c b/fs/io_uring.c
index b2cc1e76d660..2be2db156094 100644
--- a/fs/io_uring.c
+++ b/fs/io_uring.c
@@ -4950,7 +4950,7 @@ static int io_poll_double_wake(struct wait_queue_entry *wait, unsigned mode,
 			       int sync, void *key)
 {
 	struct io_kiocb *req = wait->private;
-	struct io_poll_iocb *poll = io_poll_get_single(req);
+	struct io_poll_iocb *poll = io_poll_get_double(req);
 	__poll_t mask = key_to_poll(key);
 
 	/* for instances that support it check for an event match first: */
-- 
1.8.3.1

