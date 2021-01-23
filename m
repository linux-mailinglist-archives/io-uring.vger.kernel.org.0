Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 7F8BC30144F
	for <lists+io-uring@lfdr.de>; Sat, 23 Jan 2021 10:43:10 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726032AbhAWJlX (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Sat, 23 Jan 2021 04:41:23 -0500
Received: from out30-42.freemail.mail.aliyun.com ([115.124.30.42]:58091 "EHLO
        out30-42.freemail.mail.aliyun.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1726883AbhAWJlV (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Sat, 23 Jan 2021 04:41:21 -0500
X-Alimail-AntiSpam: AC=PASS;BC=-1|-1;BR=01201311R121e4;CH=green;DM=||false|;DS=||;FP=0|-1|-1|-1|0|-1|-1|-1;HT=e01e01424;MF=haoxu@linux.alibaba.com;NM=1;PH=DS;RN=3;SR=0;TI=SMTPD_---0UMbbXwC_1611394824;
Received: from e18g09479.et15sqa.tbsite.net(mailfrom:haoxu@linux.alibaba.com fp:SMTPD_---0UMbbXwC_1611394824)
          by smtp.aliyun-inc.com(127.0.0.1);
          Sat, 23 Jan 2021 17:40:32 +0800
From:   Hao Xu <haoxu@linux.alibaba.com>
To:     Jens Axboe <axboe@kernel.dk>
Cc:     io-uring@vger.kernel.org, Joseph Qi <joseph.qi@linux.alibaba.com>
Subject: [PATCH] io_uring: don't recursively hold ctx->uring_lock in io_wq_submit_work()
Date:   Sat, 23 Jan 2021 17:40:24 +0800
Message-Id: <1611394824-73078-1-git-send-email-haoxu@linux.alibaba.com>
X-Mailer: git-send-email 1.8.3.1
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org

Abaci reported the following warning:

[   97.862205] ============================================
[   97.863400] WARNING: possible recursive locking detected
[   97.864640] 5.11.0-rc4+ #12 Not tainted
[   97.865537] --------------------------------------------
[   97.866748] a.out/2890 is trying to acquire lock:
[   97.867829] ffff8881046763e8 (&ctx->uring_lock){+.+.}-{3:3}, at:
io_wq_submit_work+0x155/0x240
[   97.869735]
[   97.869735] but task is already holding lock:
[   97.871033] ffff88810dfe0be8 (&ctx->uring_lock){+.+.}-{3:3}, at:
__x64_sys_io_uring_enter+0x3f0/0x5b0
[   97.873074]
[   97.873074] other info that might help us debug this:
[   97.874520]  Possible unsafe locking scenario:
[   97.874520]
[   97.875845]        CPU0
[   97.876440]        ----
[   97.877048]   lock(&ctx->uring_lock);
[   97.877961]   lock(&ctx->uring_lock);
[   97.878881]
[   97.878881]  *** DEADLOCK ***
[   97.878881]
[   97.880341]  May be due to missing lock nesting notation
[   97.880341]
[   97.881952] 1 lock held by a.out/2890:
[   97.882873]  #0: ffff88810dfe0be8 (&ctx->uring_lock){+.+.}-{3:3}, at:
__x64_sys_io_uring_enter+0x3f0/0x5b0
[   97.885108]
[   97.885108] stack backtrace:
[   97.886209] CPU: 0 PID: 2890 Comm: a.out Not tainted 5.11.0-rc4+ #12
[   97.887683] Hardware name: Alibaba Cloud Alibaba Cloud ECS, BIOS
rel-1.7.5-0-ge51488c-20140602_164612-nilsson.home.kraxel.org 04/01/2014
[   97.890457] Call Trace:
[   97.891121]  dump_stack+0xac/0xe3
[   97.891972]  __lock_acquire+0xab6/0x13a0
[   97.892940]  lock_acquire+0x2c3/0x390
[   97.893853]  ? io_wq_submit_work+0x155/0x240
[   97.894894]  __mutex_lock+0xae/0x9f0
[   97.895785]  ? io_wq_submit_work+0x155/0x240
[   97.896816]  ? __lock_acquire+0x782/0x13a0
[   97.897817]  ? io_wq_submit_work+0x155/0x240
[   97.898867]  ? io_wq_submit_work+0x155/0x240
[   97.899916]  ? _raw_spin_unlock_irqrestore+0x2d/0x40
[   97.901101]  io_wq_submit_work+0x155/0x240
[   97.902112]  io_wq_cancel_cb+0x162/0x490
[   97.903084]  ? io_uring_get_socket+0x40/0x40
[   97.904126]  io_async_find_and_cancel+0x3b/0x140
[   97.905247]  io_issue_sqe+0x86d/0x13e0
[   97.906186]  ? __lock_acquire+0x782/0x13a0
[   97.907195]  ? __io_queue_sqe+0x10b/0x550
[   97.908175]  ? lock_acquire+0x2c3/0x390
[   97.909122]  __io_queue_sqe+0x10b/0x550
[   97.910080]  ? io_req_prep+0xd8/0x1090
[   97.911044]  ? mark_held_locks+0x5a/0x80
[   97.912042]  ? mark_held_locks+0x5a/0x80
[   97.913014]  ? io_queue_sqe+0x235/0x470
[   97.913971]  io_queue_sqe+0x235/0x470
[   97.914894]  io_submit_sqes+0xcce/0xf10
[   97.915842]  ? xa_store+0x3b/0x50
[   97.916683]  ? __x64_sys_io_uring_enter+0x3f0/0x5b0
[   97.917872]  __x64_sys_io_uring_enter+0x3fb/0x5b0
[   97.918995]  ? lockdep_hardirqs_on_prepare+0xde/0x180
[   97.920204]  ? syscall_enter_from_user_mode+0x26/0x70
[   97.921424]  do_syscall_64+0x2d/0x40
[   97.922329]  entry_SYSCALL_64_after_hwframe+0x44/0xa9
[   97.923538] RIP: 0033:0x7f0b62601239
[   97.924437] Code: 01 00 48 81 c4 80 00 00 00 e9 f1 fe ff ff 0f 1f 00
48 89 f8 48 89 f7 48 89 d6 48 89 ca 4d 89 c2 4d 89 c8 4c 8b 4c 24 08 0f
   05 <48> 3d 01 f0 ff ff 73 01 c3 48 8b 0d 27 ec 2c 00 f7 d8 64 89 01
      48
[   97.928628] RSP: 002b:00007f0b62cc4d28 EFLAGS: 00000246 ORIG_RAX:
00000000000001aa
[   97.930422] RAX: ffffffffffffffda RBX: 0000000000000000 RCX:
00007f0b62601239
[   97.932073] RDX: 0000000000000000 RSI: 0000000000006cf6 RDI:
0000000000000005
[   97.933710] RBP: 00007f0b62cc4e20 R08: 0000000000000000 R09:
0000000000000000
[   97.935369] R10: 0000000000000000 R11: 0000000000000246 R12:
0000000000000000
[   97.937008] R13: 0000000000021000 R14: 0000000000000000 R15:
00007f0b62cc5700

This is caused by try to hold uring_lock in io_wq_submit_work() without
checking if we are in io-wq thread context or not. It can be in original
context when io_wq_submit_work() is called from IORING_OP_ASYNC_CANCEL
code path, where we already held uring_lock.

Fixes: c07e6719511e ("io_uring: hold uring_lock while completing failed polled io in io_wq_submit_work()")
Reported-by: Abaci <abaci@linux.alibaba.com>
Signed-off-by: Hao Xu <haoxu@linux.alibaba.com>
---
 fs/io_uring.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/fs/io_uring.c b/fs/io_uring.c
index 985a9e3f976d..15d0a96ec487 100644
--- a/fs/io_uring.c
+++ b/fs/io_uring.c
@@ -6395,7 +6395,7 @@ static struct io_wq_work *io_wq_submit_work(struct io_wq_work *work)
 	if (ret) {
 		struct io_ring_ctx *lock_ctx = NULL;
 
-		if (req->ctx->flags & IORING_SETUP_IOPOLL)
+		if ((req->ctx->flags & IORING_SETUP_IOPOLL) && io_wq_current_is_worker())
 			lock_ctx = req->ctx;
 
 		/*
-- 
1.8.3.1

