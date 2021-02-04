Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 83C5230CC60
	for <lists+io-uring@lfdr.de>; Tue,  2 Feb 2021 20:55:05 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S240200AbhBBTyO (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Tue, 2 Feb 2021 14:54:14 -0500
Received: from out4436.biz.mail.alibaba.com ([47.88.44.36]:6896 "EHLO
        out4436.biz.mail.alibaba.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S240197AbhBBTxx (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Tue, 2 Feb 2021 14:53:53 -0500
X-Alimail-AntiSpam: AC=PASS;BC=-1|-1;BR=01201311R161e4;CH=green;DM=||false|;DS=||;FP=0|-1|-1|-1|0|-1|-1|-1;HT=e01e01424;MF=haoxu@linux.alibaba.com;NM=1;PH=DS;RN=4;SR=0;TI=SMTPD_---0UNi9.Ix_1612295573;
Received: from e18g09479.et15sqa.tbsite.net(mailfrom:haoxu@linux.alibaba.com fp:SMTPD_---0UNi9.Ix_1612295573)
          by smtp.aliyun-inc.com(127.0.0.1);
          Wed, 03 Feb 2021 03:53:00 +0800
From:   Hao Xu <haoxu@linux.alibaba.com>
To:     Jens Axboe <axboe@kernel.dk>
Cc:     io-uring@vger.kernel.org, Pavel Begunkov <asml.silence@gmail.com>,
        Joseph Qi <joseph.qi@linux.alibaba.com>
Subject: [PATCH] io_uring: fix possible deadlock in io_uring_poll
Date:   Wed,  3 Feb 2021 03:52:53 +0800
Message-Id: <1612295573-221587-1-git-send-email-haoxu@linux.alibaba.com>
X-Mailer: git-send-email 1.8.3.1
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org

Abaci reported follow issue:

[   30.615891] ======================================================
[   30.616648] WARNING: possible circular locking dependency detected
[   30.617423] 5.11.0-rc3-next-20210115 #1 Not tainted
[   30.618035] ------------------------------------------------------
[   30.618914] a.out/1128 is trying to acquire lock:
[   30.619520] ffff88810b063868 (&ep->mtx){+.+.}-{3:3}, at: __ep_eventpoll_poll+0x9f/0x220
[   30.620505]
[   30.620505] but task is already holding lock:
[   30.621218] ffff88810e952be8 (&ctx->uring_lock){+.+.}-{3:3}, at: __x64_sys_io_uring_enter+0x3f0/0x5b0
[   30.622349]
[   30.622349] which lock already depends on the new lock.
[   30.622349]
[   30.623289]
[   30.623289] the existing dependency chain (in reverse order) is:
[   30.624243]
[   30.624243] -> #1 (&ctx->uring_lock){+.+.}-{3:3}:
[   30.625263]        lock_acquire+0x2c7/0x390
[   30.625868]        __mutex_lock+0xae/0x9f0
[   30.626451]        io_cqring_overflow_flush.part.95+0x6d/0x70
[   30.627278]        io_uring_poll+0xcb/0xd0
[   30.627890]        ep_item_poll.isra.14+0x4e/0x90
[   30.628531]        do_epoll_ctl+0xb7e/0x1120
[   30.629122]        __x64_sys_epoll_ctl+0x70/0xb0
[   30.629770]        do_syscall_64+0x2d/0x40
[   30.630332]        entry_SYSCALL_64_after_hwframe+0x44/0xa9
[   30.631187]
[   30.631187] -> #0 (&ep->mtx){+.+.}-{3:3}:
[   30.631985]        check_prevs_add+0x226/0xb00
[   30.632584]        __lock_acquire+0x1237/0x13a0
[   30.633207]        lock_acquire+0x2c7/0x390
[   30.633740]        __mutex_lock+0xae/0x9f0
[   30.634258]        __ep_eventpoll_poll+0x9f/0x220
[   30.634879]        __io_arm_poll_handler+0xbf/0x220
[   30.635462]        io_issue_sqe+0xa6b/0x13e0
[   30.635982]        __io_queue_sqe+0x10b/0x550
[   30.636648]        io_queue_sqe+0x235/0x470
[   30.637281]        io_submit_sqes+0xcce/0xf10
[   30.637839]        __x64_sys_io_uring_enter+0x3fb/0x5b0
[   30.638465]        do_syscall_64+0x2d/0x40
[   30.638999]        entry_SYSCALL_64_after_hwframe+0x44/0xa9
[   30.639643]
[   30.639643] other info that might help us debug this:
[   30.639643]
[   30.640618]  Possible unsafe locking scenario:
[   30.640618]
[   30.641402]        CPU0                    CPU1
[   30.641938]        ----                    ----
[   30.642664]   lock(&ctx->uring_lock);
[   30.643425]                                lock(&ep->mtx);
[   30.644498]                                lock(&ctx->uring_lock);
[   30.645668]   lock(&ep->mtx);
[   30.646321]
[   30.646321]  *** DEADLOCK ***
[   30.646321]
[   30.647642] 1 lock held by a.out/1128:
[   30.648424]  #0: ffff88810e952be8 (&ctx->uring_lock){+.+.}-{3:3}, at: __x64_sys_io_uring_enter+0x3f0/0x5b0
[   30.649954]
[   30.649954] stack backtrace:
[   30.650592] CPU: 1 PID: 1128 Comm: a.out Not tainted 5.11.0-rc3-next-20210115 #1
[   30.651554] Hardware name: Red Hat KVM, BIOS 0.5.1 01/01/2011
[   30.652290] Call Trace:
[   30.652688]  dump_stack+0xac/0xe3
[   30.653164]  check_noncircular+0x11e/0x130
[   30.653747]  ? check_prevs_add+0x226/0xb00
[   30.654303]  check_prevs_add+0x226/0xb00
[   30.654845]  ? add_lock_to_list.constprop.49+0xac/0x1d0
[   30.655564]  __lock_acquire+0x1237/0x13a0
[   30.656262]  lock_acquire+0x2c7/0x390
[   30.656788]  ? __ep_eventpoll_poll+0x9f/0x220
[   30.657379]  ? __io_queue_proc.isra.88+0x180/0x180
[   30.658014]  __mutex_lock+0xae/0x9f0
[   30.658524]  ? __ep_eventpoll_poll+0x9f/0x220
[   30.659112]  ? mark_held_locks+0x5a/0x80
[   30.659648]  ? __ep_eventpoll_poll+0x9f/0x220
[   30.660229]  ? _raw_spin_unlock_irqrestore+0x2d/0x40
[   30.660885]  ? trace_hardirqs_on+0x46/0x110
[   30.661471]  ? __io_queue_proc.isra.88+0x180/0x180
[   30.662102]  ? __ep_eventpoll_poll+0x9f/0x220
[   30.662696]  __ep_eventpoll_poll+0x9f/0x220
[   30.663273]  ? __ep_eventpoll_poll+0x220/0x220
[   30.663875]  __io_arm_poll_handler+0xbf/0x220
[   30.664463]  io_issue_sqe+0xa6b/0x13e0
[   30.664984]  ? __lock_acquire+0x782/0x13a0
[   30.665544]  ? __io_queue_proc.isra.88+0x180/0x180
[   30.666170]  ? __io_queue_sqe+0x10b/0x550
[   30.666725]  __io_queue_sqe+0x10b/0x550
[   30.667252]  ? __fget_files+0x131/0x260
[   30.667791]  ? io_req_prep+0xd8/0x1090
[   30.668316]  ? io_queue_sqe+0x235/0x470
[   30.668868]  io_queue_sqe+0x235/0x470
[   30.669398]  io_submit_sqes+0xcce/0xf10
[   30.669931]  ? xa_load+0xe4/0x1c0
[   30.670425]  __x64_sys_io_uring_enter+0x3fb/0x5b0
[   30.671051]  ? lockdep_hardirqs_on_prepare+0xde/0x180
[   30.671719]  ? syscall_enter_from_user_mode+0x2b/0x80
[   30.672380]  do_syscall_64+0x2d/0x40
[   30.672901]  entry_SYSCALL_64_after_hwframe+0x44/0xa9
[   30.673503] RIP: 0033:0x7fd89c813239
[   30.673962] Code: 01 00 48 81 c4 80 00 00 00 e9 f1 fe ff ff 0f 1f 00 48 89 f8 48 89 f7 48 89 d6 48 89 ca 4d 89 c2 4d 89 c8 4c 8b 4c 24 08 0f 05  3d 01 f0 ff ff 73 01 c3 48 8b 0d 27 ec 2c 00 f7 d8 64 89 01 48
[   30.675920] RSP: 002b:00007ffc65a7c628 EFLAGS: 00000217 ORIG_RAX: 00000000000001aa
[   30.676791] RAX: ffffffffffffffda RBX: 0000000000000000 RCX: 00007fd89c813239
[   30.677594] RDX: 0000000000000000 RSI: 0000000000000014 RDI: 0000000000000003
[   30.678678] RBP: 00007ffc65a7c720 R08: 0000000000000000 R09: 0000000003000000
[   30.679492] R10: 0000000000000000 R11: 0000000000000217 R12: 0000000000400ff0
[   30.680282] R13: 00007ffc65a7c840 R14: 0000000000000000 R15: 0000000000000000

This might happen if we do epoll_wait on a uring fd while reading/writing
the former epoll fd in a sqe in the former uring instance.
So let's don't flush cqring overflow list when we fail to get the uring
lock. This leads to less accuracy, but is still ok.

Reported-by: Abaci <abaci@linux.alibaba.com>
Fixes: 6c503150ae33 ("io_uring: patch up IOPOLL overflow_flush sync")
Signed-off-by: Hao Xu <haoxu@linux.alibaba.com>
---

Here I use mutex_trylock() to fix this issue, but this causes loss of
accuracy. I think doing cqring overflow flush in a task work maybe a
better solution. I'm think of this. Any thoughts?

 fs/io_uring.c | 31 ++++++++++++++++++++++++++++++-
 1 file changed, 30 insertions(+), 1 deletion(-)

diff --git a/fs/io_uring.c b/fs/io_uring.c
index 38c6cbe1ab38..866e45d42ac7 100644
--- a/fs/io_uring.c
+++ b/fs/io_uring.c
@@ -8718,7 +8718,36 @@ static __poll_t io_uring_poll(struct file *file, poll_table *wait)
 	smp_rmb();
 	if (!io_sqring_full(ctx))
 		mask |= EPOLLOUT | EPOLLWRNORM;
-	io_cqring_overflow_flush(ctx, false, NULL, NULL);
+
+	if (test_bit(0, &ctx->cq_check_overflow)) {
+		bool should_flush = true;
+		/* iopoll syncs against uring_lock, not completion_lock */
+		if (ctx->flags & IORING_SETUP_IOPOLL) {
+			/*
+			 * avoid ABBA deadlock.
+			 * there could be contention like below:
+			 *      CPU0                    CPU1
+			 *      ----                    ----
+			 * lock(&ctx->uring_lock);
+			 *                              lock(&ep->mtx);
+			 *                              lock(&ctx->uring_lock);
+			 * lock(&ep->mtx);
+			 *
+			 * this might happen if we do epoll_wait on a uring fd while
+			 * read/write the former epoll fd in a sqe in the former uring
+			 * instance.
+			 * We don't flush cqring overflow list when we fail to get the
+			 * uring lock. This leads to less accuracy, but is still ok.
+			 */
+			should_flush = mutex_trylock(&ctx->uring_lock);
+		}
+		if (should_flush) {
+			__io_cqring_overflow_flush(ctx, false, NULL, NULL);
+			if (ctx->flags & IORING_SETUP_IOPOLL)
+				mutex_unlock(&ctx->uring_lock);
+		}
+	}
+
 	if (io_cqring_events(ctx))
 		mask |= EPOLLIN | EPOLLRDNORM;
 
-- 
1.8.3.1

