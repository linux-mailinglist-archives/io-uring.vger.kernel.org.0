Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id ECBB12B8F39
	for <lists+io-uring@lfdr.de>; Thu, 19 Nov 2020 10:48:03 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726545AbgKSJow (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Thu, 19 Nov 2020 04:44:52 -0500
Received: from out30-45.freemail.mail.aliyun.com ([115.124.30.45]:60648 "EHLO
        out30-45.freemail.mail.aliyun.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1726511AbgKSJow (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Thu, 19 Nov 2020 04:44:52 -0500
X-Alimail-AntiSpam: AC=PASS;BC=-1|-1;BR=01201311R151e4;CH=green;DM=||false|;DS=||;FP=0|-1|-1|-1|0|-1|-1|-1;HT=e01e04407;MF=xiaoguang.wang@linux.alibaba.com;NM=1;PH=DS;RN=3;SR=0;TI=SMTPD_---0UFt0unp_1605779086;
Received: from localhost(mailfrom:xiaoguang.wang@linux.alibaba.com fp:SMTPD_---0UFt0unp_1605779086)
          by smtp.aliyun-inc.com(127.0.0.1);
          Thu, 19 Nov 2020 17:44:46 +0800
From:   Xiaoguang Wang <xiaoguang.wang@linux.alibaba.com>
To:     io-uring@vger.kernel.org
Cc:     axboe@kernel.dk, joseph.qi@linux.alibaba.com
Subject: [PATCH] io_uring: check kthread stopped flag when sq thread is unparked
Date:   Thu, 19 Nov 2020 17:44:46 +0800
Message-Id: <20201119094446.10658-1-xiaoguang.wang@linux.alibaba.com>
X-Mailer: git-send-email 2.17.2
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org

syzbot reports following issue:
INFO: task syz-executor.2:12399 can't die for more than 143 seconds.
task:syz-executor.2  state:D stack:28744 pid:12399 ppid:  8504 flags:0x00004004
Call Trace:
 context_switch kernel/sched/core.c:3773 [inline]
 __schedule+0x893/0x2170 kernel/sched/core.c:4522
 schedule+0xcf/0x270 kernel/sched/core.c:4600
 schedule_timeout+0x1d8/0x250 kernel/time/timer.c:1847
 do_wait_for_common kernel/sched/completion.c:85 [inline]
 __wait_for_common kernel/sched/completion.c:106 [inline]
 wait_for_common kernel/sched/completion.c:117 [inline]
 wait_for_completion+0x163/0x260 kernel/sched/completion.c:138
 kthread_stop+0x17a/0x720 kernel/kthread.c:596
 io_put_sq_data fs/io_uring.c:7193 [inline]
 io_sq_thread_stop+0x452/0x570 fs/io_uring.c:7290
 io_finish_async fs/io_uring.c:7297 [inline]
 io_sq_offload_create fs/io_uring.c:8015 [inline]
 io_uring_create fs/io_uring.c:9433 [inline]
 io_uring_setup+0x19b7/0x3730 fs/io_uring.c:9507
 do_syscall_64+0x2d/0x70 arch/x86/entry/common.c:46
 entry_SYSCALL_64_after_hwframe+0x44/0xa9
RIP: 0033:0x45deb9
Code: Unable to access opcode bytes at RIP 0x45de8f.
RSP: 002b:00007f174e51ac78 EFLAGS: 00000246 ORIG_RAX: 00000000000001a9
RAX: ffffffffffffffda RBX: 0000000000008640 RCX: 000000000045deb9
RDX: 0000000000000000 RSI: 0000000020000140 RDI: 00000000000050e5
RBP: 000000000118bf58 R08: 0000000000000000 R09: 0000000000000000
R10: 0000000000000000 R11: 0000000000000246 R12: 000000000118bf2c
R13: 00007ffed9ca723f R14: 00007f174e51b9c0 R15: 000000000118bf2c
INFO: task syz-executor.2:12399 blocked for more than 143 seconds.
      Not tainted 5.10.0-rc3-next-20201110-syzkaller #0
"echo 0 > /proc/sys/kernel/hung_task_timeout_secs" disables this message.

Currently we don't have a reproducer yet, but seems that there is a
race in current codes:
=> io_put_sq_data
      ctx_list is empty now.       |
==> kthread_park(sqd->thread);     |
                                   | T1: sq thread is parked now.
==> kthread_stop(sqd->thread);     |
    KTHREAD_SHOULD_STOP is set now.|
===> kthread_unpark(k);            |
                                   | T2: sq thread is now unparkd, run again.
                                   |
                                   | T3: sq thread is now preempted out.
                                   |
===> wake_up_process(k);           |
                                   |
                                   | T4: Since sqd ctx_list is empty, needs_sched will be true,
                                   | then sq thread sets task state to TASK_INTERRUPTIBLE,
                                   | and schedule, now sq thread will never be waken up.
===> wait_for_completion           |

I have artificially used mdelay() to simulate above race, will get same
stack like this syzbot report, but to be honest, I'm not sure this code
race triggers syzbot report.

To fix this possible code race, when sq thread is unparked, need to check
whether sq thread has been stopped.

Reported-by: syzbot+03beeb595f074db9cfd1@syzkaller.appspotmail.com
Signed-off-by: Xiaoguang Wang <xiaoguang.wang@linux.alibaba.com>
---
 fs/io_uring.c | 10 +++++++++-
 1 file changed, 9 insertions(+), 1 deletion(-)

diff --git a/fs/io_uring.c b/fs/io_uring.c
index e659eeb4de72..2709b9bb3861 100644
--- a/fs/io_uring.c
+++ b/fs/io_uring.c
@@ -6965,8 +6965,16 @@ static int io_sq_thread(void *data)
 		 * kthread parking. This synchronizes the thread vs users,
 		 * the users are synchronized on the sqd->ctx_lock.
 		 */
-		if (kthread_should_park())
+		if (kthread_should_park()) {
 			kthread_parkme();
+			/*
+			 * When sq thread is unparked, in case the previous park operation
+			 * comes from io_put_sq_data(), which means that sq thread is going
+			 * to be stopped, so here needs to have a check.
+			 */
+			if (kthread_should_stop())
+				break;
+		}
 
 		if (unlikely(!list_empty(&sqd->ctx_new_list))) {
 			io_sqd_init_new(sqd);
-- 
2.17.2

