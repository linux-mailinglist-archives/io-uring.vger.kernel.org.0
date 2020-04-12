Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 8ADB51A5D16
	for <lists+io-uring@lfdr.de>; Sun, 12 Apr 2020 08:51:10 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1725832AbgDLGvJ (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Sun, 12 Apr 2020 02:51:09 -0400
Received: from out30-43.freemail.mail.aliyun.com ([115.124.30.43]:32926 "EHLO
        out30-43.freemail.mail.aliyun.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1725812AbgDLGvJ (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Sun, 12 Apr 2020 02:51:09 -0400
X-Alimail-AntiSpam: AC=PASS;BC=-1|-1;BR=01201311R411e4;CH=green;DM=||false|;DS=||;FP=0|-1|-1|-1|0|-1|-1|-1;HT=e01e07484;MF=xiaoguang.wang@linux.alibaba.com;NM=1;PH=DS;RN=4;SR=0;TI=SMTPD_---0TvFhUMv_1586674256;
Received: from localhost(mailfrom:xiaoguang.wang@linux.alibaba.com fp:SMTPD_---0TvFhUMv_1586674256)
          by smtp.aliyun-inc.com(127.0.0.1);
          Sun, 12 Apr 2020 14:51:03 +0800
From:   Xiaoguang Wang <xiaoguang.wang@linux.alibaba.com>
To:     io-uring@vger.kernel.org
Cc:     axboe@kernel.dk, joseph.qi@linux.alibaba.com,
        Xiaoguang Wang <xiaoguang.wang@linux.alibaba.com>
Subject: [PATCH] io_uring: restore req->work when canceling poll request
Date:   Sun, 12 Apr 2020 14:50:54 +0800
Message-Id: <20200412065054.2092-1-xiaoguang.wang@linux.alibaba.com>
X-Mailer: git-send-email 2.17.2
Sender: io-uring-owner@vger.kernel.org
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org

When running liburing test case 'accept', I got below warning:
RED: Invalid credentials
RED: At include/linux/cred.h:285
RED: Specified credentials: 00000000d02474a0
RED: ->magic=4b, put_addr=000000005b4f46e9
RED: ->usage=-1699227648, subscr=-25693
RED: ->*uid = { 256,-25693,-25693,65534 }
RED: ->*gid = { 0,-1925859360,-1789740800,-1827028688 }
RED: ->security is 00000000258c136e
eneral protection fault, probably for non-canonical address 0xdead4ead00000000: 0000 [#1] SMP PTI
PU: 21 PID: 2037 Comm: accept Not tainted 5.6.0+ #318
ardware name: QEMU Standard PC (i440FX + PIIX, 1996),
BIOS rel-1.11.1-0-g0551a4be2c-prebuilt.qemu-project.org 04/01/2014
IP: 0010:dump_invalid_creds+0x16f/0x184
ode: 48 8b 83 88 00 00 00 48 3d ff 0f 00 00 76 29 48 89 c2 81 e2 00 ff ff ff 48
81 fa 00 6b 6b 6b 74 17 5b 48 c7 c7 4b b1 10 8e 5d <8b> 50 04 41 5c 8b 30 41 5d
e9 67 e3 04 00 5b 5d 41 5c 41 5d c3 0f
SP: 0018:ffffacc1039dfb38 EFLAGS: 00010087
AX: dead4ead00000000 RBX: ffff9ba39319c100 RCX: 0000000000000007
DX: 0000000000000000 RSI: 0000000000000000 RDI: ffffffff8e10b14b
BP: ffffffff8e108476 R08: 0000000000000000 R09: 0000000000000001
10: 0000000000000000 R11: ffffacc1039df9e5 R12: 000000009552b900
13: 000000009319c130 R14: ffff9ba39319c100 R15: 0000000000000246
S:  00007f96b2bfc4c0(0000) GS:ffff9ba39f340000(0000) knlGS:0000000000000000
S:  0010 DS: 0000 ES: 0000 CR0: 0000000080050033
R2: 0000000000401870 CR3: 00000007db7a4000 CR4: 00000000000006e0
all Trace:
__invalid_creds+0x48/0x4a
__io_req_aux_free+0x2e8/0x3b0
? io_poll_remove_one+0x2a/0x1d0
__io_free_req+0x18/0x200
io_free_req+0x31/0x350
io_poll_remove_one+0x17f/0x1d0
io_poll_cancel.isra.80+0x6c/0x80
io_async_find_and_cancel+0x111/0x120
io_issue_sqe+0x181/0x10e0
? __lock_acquire+0x552/0xae0
? lock_acquire+0x8e/0x310
? fs_reclaim_acquire.part.97+0x5/0x30
__io_queue_sqe.part.100+0xc4/0x580
? io_submit_sqes+0x751/0xbd0
? rcu_read_lock_sched_held+0x32/0x40
io_submit_sqes+0x9ba/0xbd0
? __x64_sys_io_uring_enter+0x2b2/0x460
? __x64_sys_io_uring_enter+0xaf/0x460
? find_held_lock+0x2d/0x90
? __x64_sys_io_uring_enter+0x111/0x460
__x64_sys_io_uring_enter+0x2d7/0x460
do_syscall_64+0x5a/0x230
entry_SYSCALL_64_after_hwframe+0x49/0xb3

After looking into codes, it turns out that this issue is because we didn't
restore the req->work, which is changed in io_arm_poll_handler(), req->work
is a union with below struct:
	struct {
		struct callback_head	task_work;
		struct hlist_node	hash_node;
		struct async_poll	*apoll;
	};
If we forget to restore, members in struct io_wq_work would be invalid,
restore the req->work to fix this issue.

Signed-off-by: Xiaoguang Wang <xiaoguang.wang@linux.alibaba.com>
---
 fs/io_uring.c | 10 ++++++++++
 1 file changed, 10 insertions(+)

diff --git a/fs/io_uring.c b/fs/io_uring.c
index 5190bfb6a665..5b2badf3eb84 100644
--- a/fs/io_uring.c
+++ b/fs/io_uring.c
@@ -4316,6 +4316,8 @@ static bool __io_poll_remove_one(struct io_kiocb *req,
 static bool io_poll_remove_one(struct io_kiocb *req)
 {
 	bool do_complete;
+	bool need_restore = false;
+	struct async_poll *apoll = req->apoll;
 
 	if (req->opcode == IORING_OP_POLL_ADD) {
 		do_complete = __io_poll_remove_one(req, &req->poll);
@@ -4324,9 +4326,17 @@ static bool io_poll_remove_one(struct io_kiocb *req)
 		do_complete = __io_poll_remove_one(req, &req->apoll->poll);
 		if (do_complete)
 			io_put_req(req);
+		need_restore = true;
 	}
 
 	hash_del(&req->hash_node);
+	if (need_restore) {
+		/*
+		 * restore ->work because we need to call io_req_work_drop_env.
+		 */
+		memcpy(&req->work, &apoll->work, sizeof(req->work));
+		kfree(apoll);
+	}
 
 	if (do_complete) {
 		io_cqring_fill_event(req, -ECANCELED);
-- 
2.17.2

