Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id A4AF72C7CAB
	for <lists+io-uring@lfdr.de>; Mon, 30 Nov 2020 03:10:10 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726637AbgK3CIr (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Sun, 29 Nov 2020 21:08:47 -0500
Received: from ozlabs.ru ([107.174.27.60]:33628 "EHLO ozlabs.ru"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726520AbgK3CIr (ORCPT <rfc822;io-uring@vger.kernel.org>);
        Sun, 29 Nov 2020 21:08:47 -0500
X-Greylist: delayed 443 seconds by postgrey-1.27 at vger.kernel.org; Sun, 29 Nov 2020 21:08:46 EST
Received: from fstn1-p1.ozlabs.ibm.com (localhost [IPv6:::1])
        by ozlabs.ru (Postfix) with ESMTP id 8324FAE80047;
        Sun, 29 Nov 2020 21:00:34 -0500 (EST)
From:   Alexey Kardashevskiy <aik@ozlabs.ru>
To:     io-uring@vger.kernel.org
Cc:     Alexey Kardashevskiy <aik@ozlabs.ru>,
        lexander Viro <viro@zeniv.linux.org.uk>,
        Jens Axboe <axboe@kernel.dk>, linux-fsdevel@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: [PATCH kernel] fs/io_ring: Fix lockdep warnings
Date:   Mon, 30 Nov 2020 13:00:28 +1100
Message-Id: <20201130020028.106198-1-aik@ozlabs.ru>
X-Mailer: git-send-email 2.17.1
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org

There are a few potential deadlocks reported by lockdep and triggered by
syzkaller (a syscall fuzzer). These are reported as timer interrupts can
execute softirq handlers and if we were executing certain bits of io_ring,
a deadlock can occur. This fixes those bits by disabling soft interrupts.

Signed-off-by: Alexey Kardashevskiy <aik@ozlabs.ru>
---

There are 2 reports.

Warning#1:

================================
WARNING: inconsistent lock state
5.10.0-rc5_irqs_a+fstn1 #5 Not tainted
--------------------------------
inconsistent {SOFTIRQ-ON-W} -> {IN-SOFTIRQ-W} usage.
swapper/14/0 [HC0[0]:SC1[1]:HE0:SE0] takes:
c00000000b76f4a8 (&file_data->lock){+.?.}-{2:2}, at: io_file_data_ref_zero+0x58/0x300
{SOFTIRQ-ON-W} state was registered at:
  lock_acquire+0x2c4/0x5c0
  _raw_spin_lock+0x54/0x80
  sys_io_uring_register+0x1de0/0x2100
  system_call_exception+0x160/0x240
  system_call_common+0xf0/0x27c
irq event stamp: 4011767
hardirqs last  enabled at (4011766): [<c00000000167a7d4>] _raw_spin_unlock_irqrestore+0x54/0x90
hardirqs last disabled at (4011767): [<c00000000167a358>] _raw_spin_lock_irqsave+0x48/0xb0
softirqs last  enabled at (4011754): [<c00000000020b69c>] irq_enter_rcu+0xbc/0xc0
softirqs last disabled at (4011755): [<c00000000020ba84>] irq_exit+0x1d4/0x1e0

other info that might help us debug this:
 Possible unsafe locking scenario:

       CPU0
       ----
  lock(&file_data->lock);
  <Interrupt>
    lock(&file_data->lock);

 *** DEADLOCK ***

2 locks held by swapper/14/0:
 #0: c0000000021cc3e8 (rcu_callback){....}-{0:0}, at: rcu_core+0x2b0/0xfe0
 #1: c0000000021cc358 (rcu_read_lock){....}-{1:2}, at: percpu_ref_switch_to_atomic_rcu+0x148/0x400

stack backtrace:
CPU: 14 PID: 0 Comm: swapper/14 Not tainted 5.10.0-rc5_irqs_a+fstn1 #5
Call Trace:
[c0000000097672c0] [c0000000002b0268] print_usage_bug+0x3e8/0x3f0
[c000000009767360] [c0000000002b0e88] mark_lock.part.48+0xc18/0xee0
[c000000009767480] [c0000000002b1fb8] __lock_acquire+0xac8/0x21e0
[c0000000097675d0] [c0000000002b4454] lock_acquire+0x2c4/0x5c0
[c0000000097676c0] [c00000000167a38c] _raw_spin_lock_irqsave+0x7c/0xb0
[c000000009767700] [c0000000007321b8] io_file_data_ref_zero+0x58/0x300
[c000000009767770] [c000000000be93e4] percpu_ref_switch_to_atomic_rcu+0x3f4/0x400
[c000000009767800] [c0000000002fe0d4] rcu_core+0x314/0xfe0
[c0000000097678b0] [c00000000167b5b8] __do_softirq+0x198/0x6c0
[c0000000097679d0] [c00000000020ba84] irq_exit+0x1d4/0x1e0
[c000000009767a00] [c0000000000301c8] timer_interrupt+0x1e8/0x600
[c000000009767a70] [c000000000009d84] decrementer_common_virt+0x1e4/0x1f0
--- interrupt: 900 at snooze_loop+0xf4/0x300
    LR = snooze_loop+0xe4/0x300
[c000000009767dc0] [c00000000111b010] cpuidle_enter_state+0x520/0x910
[c000000009767e30] [c00000000111b4c8] cpuidle_enter+0x58/0x80
[c000000009767e70] [c00000000026da0c] call_cpuidle+0x4c/0x90
[c000000009767e90] [c00000000026de80] do_idle+0x320/0x3d0
[c000000009767f10] [c00000000026e308] cpu_startup_entry+0x38/0x50
[c000000009767f40] [c00000000006f624] start_secondary+0x304/0x320
[c000000009767f90] [c00000000000cc54] start_secondary_prolog+0x10/0x14
systemd[1]: systemd-udevd.service: Got notification message from PID 195 (WATCHDOG=1)
systemd-journald[175]: Sent WATCHDOG=1 notification.



Warning#2:
================================
WARNING: inconsistent lock state
5.10.0-rc5_irqs_a+fstn1 #7 Not tainted
--------------------------------
inconsistent {SOFTIRQ-ON-W} -> {IN-SOFTIRQ-W} usage.
swapper/7/0 [HC0[0]:SC1[1]:HE1:SE0] takes:
c00000000c64b7a8 (&file_data->lock){+.?.}-{2:2}, at: io_file_data_ref_zero+0x54/0x2d0
{SOFTIRQ-ON-W} state was registered at:
  lock_acquire+0x2c4/0x5c0
  _raw_spin_lock+0x54/0x80
  io_sqe_files_unregister+0x5c/0x200
  io_ring_exit_work+0x230/0x640
  process_one_work+0x428/0xab0
  worker_thread+0x94/0x770
  kthread+0x204/0x210
  ret_from_kernel_thread+0x5c/0x6c
irq event stamp: 3250736
hardirqs last  enabled at (3250736): [<c00000000167a794>] _raw_spin_unlock_irqrestore+0x54/0x90
hardirqs last disabled at (3250735): [<c00000000167a318>] _raw_spin_lock_irqsave+0x48/0xb0
softirqs last  enabled at (3250722): [<c00000000020b69c>] irq_enter_rcu+0xbc/0xc0
softirqs last disabled at (3250723): [<c00000000020ba84>] irq_exit+0x1d4/0x1e0

other info that might help us debug this:
 Possible unsafe locking scenario:

       CPU0
       ----
  lock(&file_data->lock);
  <Interrupt>
    lock(&file_data->lock);

 *** DEADLOCK ***

2 locks held by swapper/7/0:
 #0: c0000000021cc3e8 (rcu_callback){....}-{0:0}, at: rcu_core+0x2b0/0xfe0
 #1: c0000000021cc358 (rcu_read_lock){....}-{1:2}, at: percpu_ref_switch_to_atomic_rcu+0x148/0x400

stack backtrace:
CPU: 7 PID: 0 Comm: swapper/7 Not tainted 5.10.0-rc5_irqs_a+fstn1 #7
Call Trace:
[c00000000974b280] [c0000000002b0268] print_usage_bug+0x3e8/0x3f0
[c00000000974b320] [c0000000002b0e88] mark_lock.part.48+0xc18/0xee0
[c00000000974b440] [c0000000002b1fb8] __lock_acquire+0xac8/0x21e0
[c00000000974b590] [c0000000002b4454] lock_acquire+0x2c4/0x5c0
[c00000000974b680] [c00000000167a074] _raw_spin_lock+0x54/0x80
[c00000000974b6b0] [c0000000007321b4] io_file_data_ref_zero+0x54/0x2d0
[c00000000974b720] [c000000000be93a4] percpu_ref_switch_to_atomic_rcu+0x3f4/0x400
[c00000000974b7b0] [c0000000002fe0d4] rcu_core+0x314/0xfe0
[c00000000974b860] [c00000000167b578] __do_softirq+0x198/0x6c0
[c00000000974b980] [c00000000020ba84] irq_exit+0x1d4/0x1e0
[c00000000974b9b0] [c0000000000301c8] timer_interrupt+0x1e8/0x600
[c00000000974ba20] [c000000000009d84] decrementer_common_virt+0x1e4/0x1f0
--- interrupt: 900 at plpar_hcall_norets+0x1c/0x28
    LR = check_and_cede_processor.part.2+0x2c/0x90
[c00000000974bd80] [c00000000111f75c] shared_cede_loop+0x18c/0x230
[c00000000974bdc0] [c00000000111afd0] cpuidle_enter_state+0x520/0x910
[c00000000974be30] [c00000000111b488] cpuidle_enter+0x58/0x80
[c00000000974be70] [c00000000026da0c] call_cpuidle+0x4c/0x90
[c00000000974be90] [c00000000026de80] do_idle+0x320/0x3d0
[c00000000974bf10] [c00000000026e30c] cpu_startup_entry+0x3c/0x50
[c00000000974bf40] [c00000000006f624] start_secondary+0x304/0x320
[c00000000974bf90] [c00000000000cc54] start_secondary_prolog+0x10/0x14

---
 fs/io_uring.c | 8 ++++----
 1 file changed, 4 insertions(+), 4 deletions(-)

diff --git a/fs/io_uring.c b/fs/io_uring.c
index a8c136a1cf4e..b922ac95dfc4 100644
--- a/fs/io_uring.c
+++ b/fs/io_uring.c
@@ -6973,9 +6973,9 @@ static int io_sqe_files_unregister(struct io_ring_ctx *ctx)
 	if (!data)
 		return -ENXIO;
 
-	spin_lock(&data->lock);
+	spin_lock_bh(&data->lock);
 	ref_node = data->node;
-	spin_unlock(&data->lock);
+	spin_unlock_bh(&data->lock);
 	if (ref_node)
 		percpu_ref_kill(&ref_node->refs);
 
@@ -7493,9 +7493,9 @@ static int io_sqe_files_register(struct io_ring_ctx *ctx, void __user *arg,
 	}
 
 	file_data->node = ref_node;
-	spin_lock(&file_data->lock);
+	spin_lock_bh(&file_data->lock);
 	list_add_tail(&ref_node->node, &file_data->ref_list);
-	spin_unlock(&file_data->lock);
+	spin_unlock_bh(&file_data->lock);
 	percpu_ref_get(&file_data->refs);
 	return ret;
 out_fput:
-- 
2.17.1

