Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 3D8EB309D16
	for <lists+io-uring@lfdr.de>; Sun, 31 Jan 2021 15:45:15 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231811AbhAaOmA (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Sun, 31 Jan 2021 09:42:00 -0500
Received: from out30-54.freemail.mail.aliyun.com ([115.124.30.54]:59774 "EHLO
        out30-54.freemail.mail.aliyun.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S231660AbhAaOkH (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Sun, 31 Jan 2021 09:40:07 -0500
X-Alimail-AntiSpam: AC=PASS;BC=-1|-1;BR=01201311R111e4;CH=green;DM=||false|;DS=||;FP=0|-1|-1|-1|0|-1|-1|-1;HT=alimailimapcm10staff010182156082;MF=haoxu@linux.alibaba.com;NM=1;PH=DS;RN=4;SR=0;TI=SMTPD_---0UNPPVy5_1612103945;
Received: from e18g09479.et15sqa.tbsite.net(mailfrom:haoxu@linux.alibaba.com fp:SMTPD_---0UNPPVy5_1612103945)
          by smtp.aliyun-inc.com(127.0.0.1);
          Sun, 31 Jan 2021 22:39:11 +0800
From:   Hao Xu <haoxu@linux.alibaba.com>
To:     Jens Axboe <axboe@kernel.dk>
Cc:     io-uring@vger.kernel.org, Pavel Begunkov <asml.silence@gmail.com>,
        Joseph Qi <joseph.qi@linux.alibaba.com>
Subject: [PATCH v3] io_uring: check kthread parked flag before sqthread goes to sleep
Date:   Sun, 31 Jan 2021 22:39:04 +0800
Message-Id: <1612103944-208132-1-git-send-email-haoxu@linux.alibaba.com>
X-Mailer: git-send-email 1.8.3.1
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org

Abaci reported this issue:

#[  605.170872] INFO: task kworker/u4:1:53 blocked for more than 143 seconds.
[  605.172123]       Not tainted 5.10.0+ #1
[  605.172811] "echo 0 > /proc/sys/kernel/hung_task_timeout_secs" disables this message.
[  605.173915] task:kworker/u4:1    state:D stack:    0 pid:   53 ppid:     2 flags:0x00004000
[  605.175130] Workqueue: events_unbound io_ring_exit_work
[  605.175931] Call Trace:
[  605.176334]  __schedule+0xe0e/0x25a0
[  605.176971]  ? firmware_map_remove+0x1a1/0x1a1
[  605.177631]  ? write_comp_data+0x2a/0x80
[  605.178272]  schedule+0xd0/0x270
[  605.178811]  schedule_timeout+0x6b6/0x940
[  605.179415]  ? mark_lock.part.0+0xca/0x1420
[  605.180062]  ? usleep_range+0x170/0x170
[  605.180684]  ? wait_for_completion+0x16d/0x280
[  605.181392]  ? mark_held_locks+0x9e/0xe0
[  605.182079]  ? rwlock_bug.part.0+0x90/0x90
[  605.182853]  ? lockdep_hardirqs_on_prepare+0x286/0x400
[  605.183817]  wait_for_completion+0x175/0x280
[  605.184713]  ? wait_for_completion_interruptible+0x340/0x340
[  605.185611]  ? _raw_spin_unlock_irq+0x24/0x30
[  605.186307]  ? migrate_swap_stop+0x9c0/0x9c0
[  605.187046]  kthread_park+0x127/0x1c0
[  605.187738]  io_sq_thread_stop+0xd5/0x530
[  605.188459]  io_ring_exit_work+0xb1/0x970
[  605.189207]  process_one_work+0x92c/0x1510
[  605.189947]  ? pwq_dec_nr_in_flight+0x360/0x360
[  605.190682]  ? rwlock_bug.part.0+0x90/0x90
[  605.191430]  ? write_comp_data+0x2a/0x80
[  605.192207]  worker_thread+0x9b/0xe20
[  605.192900]  ? process_one_work+0x1510/0x1510
[  605.193599]  kthread+0x353/0x460
[  605.194154]  ? _raw_spin_unlock_irq+0x24/0x30
[  605.194910]  ? kthread_create_on_node+0x100/0x100
[  605.195821]  ret_from_fork+0x1f/0x30
[  605.196605]
[  605.196605] Showing all locks held in the system:
[  605.197598] 1 lock held by khungtaskd/25:
[  605.198301]  #0: ffffffff8b5f76a0 (rcu_read_lock){....}-{1:2}, at: rcu_lock_acquire.constprop.0+0x0/0x30
[  605.199914] 3 locks held by kworker/u4:1/53:
[  605.200609]  #0: ffff888100109938 ((wq_completion)events_unbound){+.+.}-{0:0}, at: process_one_work+0x82a/0x1510
[  605.202108]  #1: ffff888100e47dc0 ((work_completion)(&ctx->exit_work)){+.+.}-{0:0}, at: process_one_work+0x85e/0x1510
[  605.203681]  #2: ffff888116931870 (&sqd->lock){+.+.}-{3:3}, at: io_sq_thread_park.part.0+0x19/0x50
[  605.205183] 3 locks held by systemd-journal/161:
[  605.206037] 1 lock held by syslog-ng/254:
[  605.206674] 2 locks held by agetty/311:
[  605.207292]  #0: ffff888101097098 (&tty->ldisc_sem){++++}-{0:0}, at: tty_ldisc_ref_wait+0x27/0x80
[  605.208715]  #1: ffffc900000332e8 (&ldata->atomic_read_lock){+.+.}-{3:3}, at: n_tty_read+0x222/0x1bb0
[  605.210131] 2 locks held by bash/677:
[  605.210723]  #0: ffff88810419a098 (&tty->ldisc_sem){++++}-{0:0}, at: tty_ldisc_ref_wait+0x27/0x80
[  605.212105]  #1: ffffc900000512e8 (&ldata->atomic_read_lock){+.+.}-{3:3}, at: n_tty_read+0x222/0x1bb0
[  605.213777]
[  605.214151] =============================================

I believe this is caused by the follow race:

(ctx_list is empty now)
=> io_put_sq_data               |
==> kthread_park(sqd->thread);  |
====> set KTHREAD_SHOULD_PARK	|
====> wake_up_process(k)        | sq thread is running
				|
				|
				| needs_sched is true since no ctx,
				| so TASK_INTERRUPTIBLE set and schedule
				| out then never wake up again
				|
====> wait_for_completion	|
	(stuck here)

So check if sqthread gets park flag right before schedule().
since ctx_list is always empty when this problem happens, here I put
kthread_should_park() before setting the wakeup flag(ctx_list is empty
so this for loop is fast), where is close enough to schedule(). The
problem doesn't show again in my repro testing after this fix.

Reported-by: Abaci <abaci@linux.alibaba.com>
Signed-off-by: Hao Xu <haoxu@linux.alibaba.com>
---

v1-->v2
- tweak the commit message

v2-->v3
- remove duplicate kthread_should_park() since thread parking is rare
operation
- put kthread_should_park() in if (needs_sched)


 fs/io_uring.c | 5 +----
 1 file changed, 1 insertion(+), 4 deletions(-)

diff --git a/fs/io_uring.c b/fs/io_uring.c
index c07913ec0cca..d9019ce2bda0 100644
--- a/fs/io_uring.c
+++ b/fs/io_uring.c
@@ -7115,9 +7115,6 @@ static int io_sq_thread(void *data)
 			continue;
 		}
 
-		if (kthread_should_park())
-			continue;
-
 		needs_sched = true;
 		prepare_to_wait(&sqd->wait, &wait, TASK_INTERRUPTIBLE);
 		list_for_each_entry(ctx, &sqd->ctx_list, sqd_list) {
@@ -7132,7 +7129,7 @@ static int io_sq_thread(void *data)
 			}
 		}
 
-		if (needs_sched) {
+		if (needs_sched && !kthread_should_park()) {
 			list_for_each_entry(ctx, &sqd->ctx_list, sqd_list)
 				io_ring_set_wakeup_flag(ctx);
 
-- 
1.8.3.1

