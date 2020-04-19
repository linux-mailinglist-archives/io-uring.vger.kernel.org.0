Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 8E8771AF63F
	for <lists+io-uring@lfdr.de>; Sun, 19 Apr 2020 04:07:22 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1725877AbgDSCHU (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Sat, 18 Apr 2020 22:07:20 -0400
Received: from out30-57.freemail.mail.aliyun.com ([115.124.30.57]:60703 "EHLO
        out30-57.freemail.mail.aliyun.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1725827AbgDSCHU (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Sat, 18 Apr 2020 22:07:20 -0400
X-Alimail-AntiSpam: AC=PASS;BC=-1|-1;BR=01201311R251e4;CH=green;DM=||false|;DS=||;FP=0|-1|-1|-1|0|-1|-1|-1;HT=e01f04397;MF=xiaoguang.wang@linux.alibaba.com;NM=1;PH=DS;RN=4;SR=0;TI=SMTPD_---0TvxM1Ir_1587262028;
Received: from localhost(mailfrom:xiaoguang.wang@linux.alibaba.com fp:SMTPD_---0TvxM1Ir_1587262028)
          by smtp.aliyun-inc.com(127.0.0.1);
          Sun, 19 Apr 2020 10:07:16 +0800
From:   Xiaoguang Wang <xiaoguang.wang@linux.alibaba.com>
To:     io-uring@vger.kernel.org
Cc:     axboe@kernel.dk, joseph.qi@linux.alibaba.com,
        Xiaoguang Wang <xiaoguang.wang@linux.alibaba.com>
Subject: [PATCH] io_uring: only restore req->work for req that needs do completion
Date:   Sun, 19 Apr 2020 10:06:55 +0800
Message-Id: <20200419020655.2261-1-xiaoguang.wang@linux.alibaba.com>
X-Mailer: git-send-email 2.17.2
Sender: io-uring-owner@vger.kernel.org
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org

When testing io_uring IORING_FEAT_FAST_POLL feature, I got below panic:
BUG: kernel NULL pointer dereference, address: 0000000000000030
PGD 0 P4D 0
Oops: 0000 [#1] SMP PTI
CPU: 5 PID: 2154 Comm: io_uring_echo_s Not tainted 5.6.0+ #359
Hardware name: QEMU Standard PC (i440FX + PIIX, 1996),
BIOS rel-1.11.1-0-g0551a4be2c-prebuilt.qemu-project.org 04/01/2014
RIP: 0010:io_wq_submit_work+0xf/0xa0
Code: ff ff ff be 02 00 00 00 e8 ae c9 19 00 e9 58 ff ff ff 66 0f 1f
84 00 00 00 00 00 0f 1f 44 00 00 41 54 49 89 fc 55 53 48 8b 2f <8b>
45 30 48 8d 9d 48 ff ff ff 25 01 01 00 00 83 f8 01 75 07 eb 2a
RSP: 0018:ffffbef543e93d58 EFLAGS: 00010286
RAX: ffffffff84364f50 RBX: ffffa3eb50f046b8 RCX: 0000000000000000
RDX: ffffa3eb0efc1840 RSI: 0000000000000006 RDI: ffffa3eb50f046b8
RBP: 0000000000000000 R08: 00000000fffd070d R09: 0000000000000000
R10: 0000000000000000 R11: 0000000000000000 R12: ffffa3eb50f046b8
R13: ffffa3eb0efc2088 R14: ffffffff85b69be0 R15: ffffa3eb0effa4b8
FS:  00007fe9f69cc4c0(0000) GS:ffffa3eb5ef40000(0000) knlGS:0000000000000000
CS:  0010 DS: 0000 ES: 0000 CR0: 0000000080050033
CR2: 0000000000000030 CR3: 0000000020410000 CR4: 00000000000006e0
Call Trace:
 task_work_run+0x6d/0xa0
 do_exit+0x39a/0xb80
 ? get_signal+0xfe/0xbc0
 do_group_exit+0x47/0xb0
 get_signal+0x14b/0xbc0
 ? __x64_sys_io_uring_enter+0x1b7/0x450
 do_signal+0x2c/0x260
 ? __x64_sys_io_uring_enter+0x228/0x450
 exit_to_usermode_loop+0x87/0xf0
 do_syscall_64+0x209/0x230
 entry_SYSCALL_64_after_hwframe+0x49/0xb3
RIP: 0033:0x7fe9f64f8df9
Code: Bad RIP value.

task_work_run calls io_wq_submit_work unexpectedly, it's obvious that
struct callback_head's func member has been changed. After looking into
codes, I found this issue is still due to the union definition:
    union {
        /*
         * Only commands that never go async can use the below fields,
         * obviously. Right now only IORING_OP_POLL_ADD uses them, and
         * async armed poll handlers for regular commands. The latter
         * restore the work, if needed.
         */
        struct {
            struct callback_head	task_work;
            struct hlist_node	hash_node;
            struct async_poll	*apoll;
        };
        struct io_wq_work	work;
    };

When task_work_run has multiple work to execute, the work that calls
io_poll_remove_all() will do req->work restore for  non-poll request
always, but indeed if a non-poll request has been added to a new
callback_head, subsequent callback will call io_async_task_func() to
handle this request, that means we should not do the restore work
for such non-poll request. Meanwhile in io_async_task_func(), we should
drop submit ref when req has been canceled.

Fix both issues.

Fixes: b1f573bd15fd ("io_uring: restore req->work when canceling poll request")
Signed-off-by: Xiaoguang Wang <xiaoguang.wang@linux.alibaba.com>
---
 fs/io_uring.c | 9 +++++----
 1 file changed, 5 insertions(+), 4 deletions(-)

diff --git a/fs/io_uring.c b/fs/io_uring.c
index 381d50becd04..b4f89023df1e 100644
--- a/fs/io_uring.c
+++ b/fs/io_uring.c
@@ -4200,17 +4200,18 @@ static void io_async_task_func(struct callback_head *cb)
 
 	spin_unlock_irq(&ctx->completion_lock);
 
+	/* restore ->work in case we need to retry again */
+	memcpy(&req->work, &apoll->work, sizeof(req->work));
+
 	if (canceled) {
 		kfree(apoll);
 		io_cqring_ev_posted(ctx);
 		req_set_fail_links(req);
 		io_put_req(req);
+		io_put_req(req);
 		return;
 	}
 
-	/* restore ->work in case we need to retry again */
-	memcpy(&req->work, &apoll->work, sizeof(req->work));
-
 	__set_current_state(TASK_RUNNING);
 	mutex_lock(&ctx->uring_lock);
 	__io_queue_sqe(req, NULL);
@@ -4369,7 +4370,7 @@ static bool io_poll_remove_one(struct io_kiocb *req)
 
 	hash_del(&req->hash_node);
 
-	if (apoll) {
+	if (do_complete && apoll) {
 		/*
 		 * restore ->work because we need to call io_req_work_drop_env.
 		 */
-- 
2.17.2

