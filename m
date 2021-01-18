Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id C7A352F9D1F
	for <lists+io-uring@lfdr.de>; Mon, 18 Jan 2021 11:48:59 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2389043AbhARKrl (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Mon, 18 Jan 2021 05:47:41 -0500
Received: from out30-42.freemail.mail.aliyun.com ([115.124.30.42]:41086 "EHLO
        out30-42.freemail.mail.aliyun.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S2389307AbhARJvN (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Mon, 18 Jan 2021 04:51:13 -0500
X-Alimail-AntiSpam: AC=PASS;BC=-1|-1;BR=01201311R141e4;CH=green;DM=||false|;DS=||;FP=0|-1|-1|-1|0|-1|-1|-1;HT=e01e04357;MF=joseph.qi@linux.alibaba.com;NM=1;PH=DS;RN=3;SR=0;TI=SMTPD_---0UM4iQQA_1610963424;
Received: from localhost(mailfrom:joseph.qi@linux.alibaba.com fp:SMTPD_---0UM4iQQA_1610963424)
          by smtp.aliyun-inc.com(127.0.0.1);
          Mon, 18 Jan 2021 17:50:25 +0800
From:   Joseph Qi <joseph.qi@linux.alibaba.com>
To:     Jens Axboe <axboe@kernel.dk>
Cc:     io-uring@vger.kernel.org,
        Xiaoguang Wang <xiaoguang.wang@linux.alibaba.com>
Subject: [PATCH] io_uring: fix NULL pointer dereference for async cancel close
Date:   Mon, 18 Jan 2021 17:50:24 +0800
Message-Id: <1610963424-27129-1-git-send-email-joseph.qi@linux.alibaba.com>
X-Mailer: git-send-email 1.8.3.1
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org

Abaci reported the following crash:

[   31.252589] BUG: kernel NULL pointer dereference, address: 00000000000000d8
[   31.253942] #PF: supervisor read access in kernel mode
[   31.254945] #PF: error_code(0x0000) - not-present page
[   31.255964] PGD 800000010b76f067 P4D 800000010b76f067 PUD 10b462067 PMD 0
[   31.257221] Oops: 0000 [#1] SMP PTI
[   31.257923] CPU: 1 PID: 1788 Comm: io_uring-sq Not tainted 5.11.0-rc4 #1
[   31.259175] Hardware name: Red Hat KVM, BIOS 0.5.1 01/01/2011
[   31.260232] RIP: 0010:__lock_acquire+0x19d/0x18c0
[   31.261144] Code: 00 00 8b 1d fd 56 dd 08 85 db 0f 85 43 05 00 00 48 c7 c6 98 7b 95 82 48 c7 c7 57 96 93 82 e8 9a bc f5 ff 0f 0b e9 2b 05 00 00 <48> 81 3f c0 ca 67 8a b8 00 00 00 00 41 0f 45 c0 89 04 24 e9 81 fe
[   31.264297] RSP: 0018:ffffc90001933828 EFLAGS: 00010002
[   31.265320] RAX: 0000000000000001 RBX: 0000000000000001 RCX: 0000000000000000
[   31.266594] RDX: 0000000000000000 RSI: 0000000000000000 RDI: 00000000000000d8
[   31.267922] RBP: 0000000000000246 R08: 0000000000000001 R09: 0000000000000000
[   31.269262] R10: 0000000000000000 R11: 0000000000000000 R12: 0000000000000000
[   31.270550] R13: 0000000000000000 R14: ffff888106e8a140 R15: 00000000000000d8
[   31.271760] FS:  0000000000000000(0000) GS:ffff88813bd00000(0000) knlGS:0000000000000000
[   31.273269] CS:  0010 DS: 0000 ES: 0000 CR0: 0000000080050033
[   31.274330] CR2: 00000000000000d8 CR3: 0000000106efa004 CR4: 00000000003706e0
[   31.275613] DR0: 0000000000000000 DR1: 0000000000000000 DR2: 0000000000000000
[   31.276855] DR3: 0000000000000000 DR6: 00000000fffe0ff0 DR7: 0000000000000400
[   31.278065] Call Trace:
[   31.278649]  lock_acquire+0x31a/0x440
[   31.279404]  ? close_fd_get_file+0x39/0x160
[   31.280276]  ? __lock_acquire+0x647/0x18c0
[   31.281112]  _raw_spin_lock+0x2c/0x40
[   31.281821]  ? close_fd_get_file+0x39/0x160
[   31.282586]  close_fd_get_file+0x39/0x160
[   31.283338]  io_issue_sqe+0x1334/0x14e0
[   31.284053]  ? lock_acquire+0x31a/0x440
[   31.284763]  ? __io_free_req+0xcf/0x2e0
[   31.285504]  ? __io_free_req+0x175/0x2e0
[   31.286247]  ? find_held_lock+0x28/0xb0
[   31.286968]  ? io_wq_submit_work+0x7f/0x240
[   31.287733]  io_wq_submit_work+0x7f/0x240
[   31.288486]  io_wq_cancel_cb+0x161/0x580
[   31.289230]  ? io_wqe_wake_worker+0x114/0x360
[   31.290020]  ? io_uring_get_socket+0x40/0x40
[   31.290832]  io_async_find_and_cancel+0x3b/0x140
[   31.291676]  io_issue_sqe+0xbe1/0x14e0
[   31.292405]  ? __lock_acquire+0x647/0x18c0
[   31.293207]  ? __io_queue_sqe+0x10b/0x5f0
[   31.293986]  __io_queue_sqe+0x10b/0x5f0
[   31.294747]  ? io_req_prep+0xdb/0x1150
[   31.295485]  ? mark_held_locks+0x6d/0xb0
[   31.296252]  ? mark_held_locks+0x6d/0xb0
[   31.297019]  ? io_queue_sqe+0x235/0x4b0
[   31.297774]  io_queue_sqe+0x235/0x4b0
[   31.298496]  io_submit_sqes+0xd7e/0x12a0
[   31.299275]  ? _raw_spin_unlock_irq+0x24/0x30
[   31.300121]  ? io_sq_thread+0x3ae/0x940
[   31.300873]  io_sq_thread+0x207/0x940
[   31.301606]  ? do_wait_intr_irq+0xc0/0xc0
[   31.302396]  ? __ia32_sys_io_uring_enter+0x650/0x650
[   31.303321]  kthread+0x134/0x180
[   31.303982]  ? kthread_create_worker_on_cpu+0x90/0x90
[   31.304886]  ret_from_fork+0x1f/0x30

This is caused by NULL files when async cancel close, which has
IO_WQ_WORK_NO_CANCEL set and continue to do work. Fix it by also setting
needs_files for IORING_OP_ASYNC_CANCEL.

Reported-by: Abaci <abaci@linux.alibaba.com>
Cc: stable@vger.kernel.org # 5.6+
Signed-off-by: Joseph Qi <joseph.qi@linux.alibaba.com>
---
 fs/io_uring.c | 5 ++++-
 1 file changed, 4 insertions(+), 1 deletion(-)

diff --git a/fs/io_uring.c b/fs/io_uring.c
index 985a9e3..8eb1349 100644
--- a/fs/io_uring.c
+++ b/fs/io_uring.c
@@ -883,7 +883,10 @@ struct io_op_def {
 		.pollin			= 1,
 		.work_flags		= IO_WQ_WORK_MM | IO_WQ_WORK_FILES,
 	},
-	[IORING_OP_ASYNC_CANCEL] = {},
+	[IORING_OP_ASYNC_CANCEL] = {
+		/* for async cancel close */
+		.needs_file		= 1,
+	},
 	[IORING_OP_LINK_TIMEOUT] = {
 		.needs_async_data	= 1,
 		.async_size		= sizeof(struct io_timeout_data),
-- 
1.8.3.1

