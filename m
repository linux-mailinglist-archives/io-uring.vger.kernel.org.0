Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id DE892305418
	for <lists+io-uring@lfdr.de>; Wed, 27 Jan 2021 08:12:17 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233058AbhA0HLg (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Wed, 27 Jan 2021 02:11:36 -0500
Received: from out30-130.freemail.mail.aliyun.com ([115.124.30.130]:46184 "EHLO
        out30-130.freemail.mail.aliyun.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S232997AbhA0HIh (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Wed, 27 Jan 2021 02:08:37 -0500
X-Alimail-AntiSpam: AC=PASS;BC=-1|-1;BR=01201311R111e4;CH=green;DM=||false|;DS=||;FP=0|-1|-1|-1|0|-1|-1|-1;HT=alimailimapcm10staff010182156082;MF=haoxu@linux.alibaba.com;NM=1;PH=DS;RN=3;SR=0;TI=SMTPD_---0UN0sed8_1611731204;
Received: from e18g09479.et15sqa.tbsite.net(mailfrom:haoxu@linux.alibaba.com fp:SMTPD_---0UN0sed8_1611731204)
          by smtp.aliyun-inc.com(127.0.0.1);
          Wed, 27 Jan 2021 15:06:51 +0800
From:   Hao Xu <haoxu@linux.alibaba.com>
To:     Jens Axboe <axboe@kernel.dk>
Cc:     io-uring@vger.kernel.org, Joseph Qi <joseph.qi@linux.alibaba.com>
Subject: [PATCH RESEND] io_uring: fix flush cqring overflow list while TASK_INTERRUPTIBLE
Date:   Wed, 27 Jan 2021 15:06:44 +0800
Message-Id: <1611731204-171460-1-git-send-email-haoxu@linux.alibaba.com>
X-Mailer: git-send-email 1.8.3.1
In-Reply-To: <1611729900-161892-1-git-send-email-haoxu@linux.alibaba.com>
References: <1611729900-161892-1-git-send-email-haoxu@linux.alibaba.com>
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org

Abaci reported the follow warning:

[   27.073425] do not call blocking ops when !TASK_RUNNING; state=1 set at [] prepare_to_wait_exclusive+0x3a/0xc0
[   27.075805] WARNING: CPU: 0 PID: 951 at kernel/sched/core.c:7853 __might_sleep+0x80/0xa0
[   27.077604] Modules linked in:
[   27.078379] CPU: 0 PID: 951 Comm: a.out Not tainted 5.11.0-rc3+ #1
[   27.079637] Hardware name: Red Hat KVM, BIOS 0.5.1 01/01/2011
[   27.080852] RIP: 0010:__might_sleep+0x80/0xa0
[   27.081835] Code: 65 48 8b 04 25 80 71 01 00 48 8b 90 c0 15 00 00 48 8b 70 18 48 c7 c7 08 39 95 82 c6 05 f9 5f de 08 01 48 89 d1 e8 00 c6 fa ff  0b eb bf 41 0f b6 f5 48 c7 c7 40 23 c9 82 e8 f3 48 ec 00 eb a7
[   27.084521] RSP: 0018:ffffc90000fe3ce8 EFLAGS: 00010286
[   27.085350] RAX: 0000000000000000 RBX: ffffffff82956083 RCX: 0000000000000000
[   27.086348] RDX: ffff8881057a0000 RSI: ffffffff8118cc9e RDI: ffff88813bc28570
[   27.087598] RBP: 00000000000003a7 R08: 0000000000000001 R09: 0000000000000001
[   27.088819] R10: ffffc90000fe3e00 R11: 00000000fffef9f0 R12: 0000000000000000
[   27.089819] R13: 0000000000000000 R14: ffff88810576eb80 R15: ffff88810576e800
[   27.091058] FS:  00007f7b144cf740(0000) GS:ffff88813bc00000(0000) knlGS:0000000000000000
[   27.092775] CS:  0010 DS: 0000 ES: 0000 CR0: 0000000080050033
[   27.093796] CR2: 00000000022da7b8 CR3: 000000010b928002 CR4: 00000000003706f0
[   27.094778] DR0: 0000000000000000 DR1: 0000000000000000 DR2: 0000000000000000
[   27.095780] DR3: 0000000000000000 DR6: 00000000fffe0ff0 DR7: 0000000000000400
[   27.097011] Call Trace:
[   27.097685]  __mutex_lock+0x5d/0xa30
[   27.098565]  ? prepare_to_wait_exclusive+0x71/0xc0
[   27.099412]  ? io_cqring_overflow_flush.part.101+0x6d/0x70
[   27.100441]  ? lockdep_hardirqs_on_prepare+0xe9/0x1c0
[   27.101537]  ? _raw_spin_unlock_irqrestore+0x2d/0x40
[   27.102656]  ? trace_hardirqs_on+0x46/0x110
[   27.103459]  ? io_cqring_overflow_flush.part.101+0x6d/0x70
[   27.104317]  io_cqring_overflow_flush.part.101+0x6d/0x70
[   27.105113]  io_cqring_wait+0x36e/0x4d0
[   27.105770]  ? find_held_lock+0x28/0xb0
[   27.106370]  ? io_uring_remove_task_files+0xa0/0xa0
[   27.107076]  __x64_sys_io_uring_enter+0x4fb/0x640
[   27.107801]  ? rcu_read_lock_sched_held+0x59/0xa0
[   27.108562]  ? lockdep_hardirqs_on_prepare+0xe9/0x1c0
[   27.109684]  ? syscall_enter_from_user_mode+0x26/0x70
[   27.110731]  do_syscall_64+0x2d/0x40
[   27.111296]  entry_SYSCALL_64_after_hwframe+0x44/0xa9
[   27.112056] RIP: 0033:0x7f7b13dc8239
[   27.112663] Code: 01 00 48 81 c4 80 00 00 00 e9 f1 fe ff ff 0f 1f 00 48 89 f8 48 89 f7 48 89 d6 48 89 ca 4d 89 c2 4d 89 c8 4c 8b 4c 24 08 0f 05  3d 01 f0 ff ff 73 01 c3 48 8b 0d 27 ec 2c 00 f7 d8 64 89 01 48
[   27.115113] RSP: 002b:00007ffd6d7f5c88 EFLAGS: 00000286 ORIG_RAX: 00000000000001aa
[   27.116562] RAX: ffffffffffffffda RBX: 0000000000000000 RCX: 00007f7b13dc8239
[   27.117961] RDX: 000000000000478e RSI: 0000000000000000 RDI: 0000000000000003
[   27.118925] RBP: 00007ffd6d7f5cb0 R08: 0000000020000040 R09: 0000000000000008
[   27.119773] R10: 0000000000000001 R11: 0000000000000286 R12: 0000000000400480
[   27.120614] R13: 00007ffd6d7f5d90 R14: 0000000000000000 R15: 0000000000000000
[   27.121490] irq event stamp: 5635
[   27.121946] hardirqs last  enabled at (5643): [] console_unlock+0x5c4/0x740
[   27.123476] hardirqs last disabled at (5652): [] console_unlock+0x4e7/0x740
[   27.125192] softirqs last  enabled at (5272): [] __do_softirq+0x3c5/0x5aa
[   27.126430] softirqs last disabled at (5267): [] asm_call_irq_on_stack+0xf/0x20
[   27.127634] ---[ end trace 289d7e28fa60f928 ]---

This is caused by calling io_cqring_overflow_flush() which may sleep
after calling prepare_to_wait_exclusive() which set task state to
TASK_INTERRUPTIBLE

Reported-by: Abaci <abaci@linux.alibaba.com>
Fixes: 6c503150ae33 ("io_uring: patch up IOPOLL overflow_flush sync")
Cc: stable@vger.kernel.org # 5.11+
Signed-off-by: Hao Xu <haoxu@linux.alibaba.com>
---
 fs/io_uring.c | 8 ++++++--
 1 file changed, 6 insertions(+), 2 deletions(-)

diff --git a/fs/io_uring.c b/fs/io_uring.c
index c07913ec0cca..3ca69a425182 100644
--- a/fs/io_uring.c
+++ b/fs/io_uring.c
@@ -7266,14 +7266,18 @@ static int io_cqring_wait(struct io_ring_ctx *ctx, int min_events,
 						TASK_INTERRUPTIBLE);
 		/* make sure we run task_work before checking for signals */
 		ret = io_run_task_work_sig();
-		if (ret > 0)
+		if (ret > 0) {
+			finish_wait(&ctx->wait, &iowq.wq);
 			continue;
+		}
 		else if (ret < 0)
 			break;
 		if (io_should_wake(&iowq))
 			break;
-		if (test_bit(0, &ctx->cq_check_overflow))
+		if (test_bit(0, &ctx->cq_check_overflow)) {
+			finish_wait(&ctx->wait, &iowq.wq);
 			continue;
+		}
 		if (uts) {
 			timeout = schedule_timeout(timeout);
 			if (timeout == 0) {
-- 
1.8.3.1

