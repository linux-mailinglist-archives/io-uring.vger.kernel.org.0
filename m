Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id D6172287DB3
	for <lists+io-uring@lfdr.de>; Thu,  8 Oct 2020 23:14:30 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729347AbgJHVO0 (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Thu, 8 Oct 2020 17:14:26 -0400
Received: from mail-il1-f200.google.com ([209.85.166.200]:53003 "EHLO
        mail-il1-f200.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727181AbgJHVOX (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Thu, 8 Oct 2020 17:14:23 -0400
Received: by mail-il1-f200.google.com with SMTP id m1so5204653iln.19
        for <io-uring@vger.kernel.org>; Thu, 08 Oct 2020 14:14:20 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:date:in-reply-to:message-id:subject
         :from:to;
        bh=vzf609RP+iBVorRyXP7G3xytLVq/dULkfZhJLD/Vp+Y=;
        b=qu44kgEbuiOH9+LJlCMCoN9b0ACLKZV3eV3B1l6IRZ1WG120c8mEdhxS6QIIn7DqK2
         UdTkqSqUX5Arb5UsA9zZvSVAsvIV+TpGerX+sbHWav1tVL6VupYNTgCAJ83NPleDBMQg
         vtFDULtlUI5YNNIuFW9HFYD9nJteHMRXl8z3jyzEgQ+AK5y50Be5zpU6A8QJxx6kT0Yv
         8wbxFkuZOBA68I1OvkaXf9Tw1O8eAnmhY/448CXFA6/kIcgzkzRgy7O36OPOqcVVH+zK
         rZFY1RfWLHKsBV8fQmwuiBUyMOyGU3vimp2X1Qt2PDM0ecePQLGGDDZpSb67B4TCn2Ih
         K63Q==
X-Gm-Message-State: AOAM530pmsmJqH/U+0Int+FBoW4rYeQz1R8TH0CfM5lXixPp7zkvpnnZ
        cPgPA2pFLBGRRFd2o7bXs/SazpPBHq7RiBuaLAW+o2wrdd9R
X-Google-Smtp-Source: ABdhPJy39gmzrOCLLQZ7G6Nm64vOvORQcQxIJgEoxmBH4G4VN+5AfQplmJ+gOBnuEg3nM822IUhovQI4FhIpjGY+evNvoAGowBUu
MIME-Version: 1.0
X-Received: by 2002:a05:6602:2ac8:: with SMTP id m8mr4903877iov.46.1602191660106;
 Thu, 08 Oct 2020 14:14:20 -0700 (PDT)
Date:   Thu, 08 Oct 2020 14:14:20 -0700
In-Reply-To: <00000000000045ac4605b12a1720@google.com>
X-Google-Appengine-App-Id: s~syzkaller
X-Google-Appengine-App-Id-Alias: syzkaller
Message-ID: <000000000000c35f0805b12f5099@google.com>
Subject: Re: inconsistent lock state in xa_destroy
From:   syzbot <syzbot+cdcbdc0bd42e559b52b9@syzkaller.appspotmail.com>
To:     axboe@kernel.dk, io-uring@vger.kernel.org,
        linux-fsdevel@vger.kernel.org, linux-kernel@vger.kernel.org,
        syzkaller-bugs@googlegroups.com, viro@zeniv.linux.org.uk,
        willy@infradead.org
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org

syzbot has found a reproducer for the following issue on:

HEAD commit:    e4fb79c7 Add linux-next specific files for 20201008
git tree:       linux-next
console output: https://syzkaller.appspot.com/x/log.txt?x=17dda29f900000
kernel config:  https://syzkaller.appspot.com/x/.config?x=568d41fe4341ed0f
dashboard link: https://syzkaller.appspot.com/bug?extid=cdcbdc0bd42e559b52b9
compiler:       gcc (GCC) 10.1.0-syz 20200507
syz repro:      https://syzkaller.appspot.com/x/repro.syz?x=14860568500000
C reproducer:   https://syzkaller.appspot.com/x/repro.c?x=16367de7900000

IMPORTANT: if you fix the issue, please add the following tag to the commit:
Reported-by: syzbot+cdcbdc0bd42e559b52b9@syzkaller.appspotmail.com

================================
WARNING: inconsistent lock state
5.9.0-rc8-next-20201008-syzkaller #0 Not tainted
--------------------------------
inconsistent {SOFTIRQ-ON-W} -> {IN-SOFTIRQ-W} usage.
swapper/0/0 [HC0[0]:SC1[1]:HE0:SE0] takes:
ffff888025f65018 (&xa->xa_lock#7){+.?.}-{2:2}, at: xa_destroy+0xaa/0x350 lib/xarray.c:2205
{SOFTIRQ-ON-W} state was registered at:
  lock_acquire+0x1f2/0xaa0 kernel/locking/lockdep.c:5419
  __raw_spin_lock include/linux/spinlock_api_smp.h:142 [inline]
  _raw_spin_lock+0x2a/0x40 kernel/locking/spinlock.c:151
  spin_lock include/linux/spinlock.h:354 [inline]
  io_uring_add_task_file fs/io_uring.c:8607 [inline]
  io_uring_add_task_file+0x207/0x430 fs/io_uring.c:8590
  io_uring_get_fd fs/io_uring.c:9116 [inline]
  io_uring_create fs/io_uring.c:9280 [inline]
  io_uring_setup+0x2727/0x3660 fs/io_uring.c:9314
  do_syscall_64+0x2d/0x70 arch/x86/entry/common.c:46
  entry_SYSCALL_64_after_hwframe+0x44/0xa9
irq event stamp: 120141
hardirqs last  enabled at (120140): [<ffffffff8847f0df>] __raw_spin_unlock_irqrestore include/linux/spinlock_api_smp.h:160 [inline]
hardirqs last  enabled at (120140): [<ffffffff8847f0df>] _raw_spin_unlock_irqrestore+0x6f/0x90 kernel/locking/spinlock.c:191
hardirqs last disabled at (120141): [<ffffffff8847f6c9>] __raw_spin_lock_irqsave include/linux/spinlock_api_smp.h:108 [inline]
hardirqs last disabled at (120141): [<ffffffff8847f6c9>] _raw_spin_lock_irqsave+0xa9/0xd0 kernel/locking/spinlock.c:159
softirqs last  enabled at (119956): [<ffffffff814731af>] irq_enter_rcu+0xcf/0xf0 kernel/softirq.c:360
softirqs last disabled at (119957): [<ffffffff88600f2f>] asm_call_irq_on_stack+0xf/0x20

other info that might help us debug this:
 Possible unsafe locking scenario:

       CPU0
       ----
  lock(&xa->xa_lock#7);
  <Interrupt>
    lock(&xa->xa_lock#7);

 *** DEADLOCK ***

1 lock held by swapper/0/0:
 #0: ffffffff8a554c80 (rcu_callback){....}-{0:0}, at: rcu_do_batch kernel/rcu/tree.c:2474 [inline]
 #0: ffffffff8a554c80 (rcu_callback){....}-{0:0}, at: rcu_core+0x5d8/0x1240 kernel/rcu/tree.c:2718

stack backtrace:
CPU: 0 PID: 0 Comm: swapper/0 Not tainted 5.9.0-rc8-next-20201008-syzkaller #0
Hardware name: Google Google Compute Engine/Google Compute Engine, BIOS Google 01/01/2011
Call Trace:
 <IRQ>
 __dump_stack lib/dump_stack.c:77 [inline]
 dump_stack+0x198/0x1fb lib/dump_stack.c:118
 print_usage_bug kernel/locking/lockdep.c:3715 [inline]
 valid_state kernel/locking/lockdep.c:3726 [inline]
 mark_lock_irq kernel/locking/lockdep.c:3929 [inline]
 mark_lock.cold+0x32/0x74 kernel/locking/lockdep.c:4396
 mark_usage kernel/locking/lockdep.c:4281 [inline]
 __lock_acquire+0x118a/0x56d0 kernel/locking/lockdep.c:4771
 lock_acquire+0x1f2/0xaa0 kernel/locking/lockdep.c:5419
 __raw_spin_lock_irqsave include/linux/spinlock_api_smp.h:110 [inline]
 _raw_spin_lock_irqsave+0x94/0xd0 kernel/locking/spinlock.c:159
 xa_destroy+0xaa/0x350 lib/xarray.c:2205
 __io_uring_free+0x60/0xc0 fs/io_uring.c:7693
 io_uring_free include/linux/io_uring.h:40 [inline]
 __put_task_struct+0xff/0x3f0 kernel/fork.c:732
 put_task_struct include/linux/sched/task.h:111 [inline]
 delayed_put_task_struct+0x1f6/0x340 kernel/exit.c:172
 rcu_do_batch kernel/rcu/tree.c:2484 [inline]
 rcu_core+0x645/0x1240 kernel/rcu/tree.c:2718
 __do_softirq+0x203/0xab6 kernel/softirq.c:298
 asm_call_irq_on_stack+0xf/0x20
 </IRQ>
 __run_on_irqstack arch/x86/include/asm/irq_stack.h:26 [inline]
 run_on_irqstack_cond arch/x86/include/asm/irq_stack.h:77 [inline]
 do_softirq_own_stack+0x9b/0xd0 arch/x86/kernel/irq_64.c:77
 invoke_softirq kernel/softirq.c:393 [inline]
 __irq_exit_rcu kernel/softirq.c:423 [inline]
 irq_exit_rcu+0x235/0x280 kernel/softirq.c:435
 sysvec_apic_timer_interrupt+0x51/0xf0 arch/x86/kernel/apic/apic.c:1091
 asm_sysvec_apic_timer_interrupt+0x12/0x20 arch/x86/include/asm/idtentry.h:631
RIP: 0010:native_safe_halt+0xe/0x10 arch/x86/include/asm/irqflags.h:61
Code: 89 ef e8 b5 62 6f f9 e9 86 fe ff ff 48 89 df e8 a8 62 6f f9 e9 7b ff ff ff cc cc cc e9 07 00 00 00 0f 00 2d 54 08 61 00 fb f4 <c3> 90 e9 07 00 00 00 0f 00 2d 44 08 61 00 f4 c3 cc cc 55 53 e8 09
RSP: 0018:ffffffff8a207d48 EFLAGS: 00000293
RAX: 0000000000000000 RBX: 0000000000000000 RCX: 1ffffffff176a7c1
RDX: ffffffff8a29ce40 RSI: ffffffff8847e5c3 RDI: 0000000000000000
RBP: ffff888012d2e064 R08: 0000000000000001 R09: 0000000000000001
R10: 0000000000000000 R11: 0000000000000001 R12: 0000000000000001
R13: ffff888012d2e000 R14: ffff888012d2e064 R15: ffff8881339b2004
 arch_safe_halt arch/x86/include/asm/paravirt.h:150 [inline]
 acpi_safe_halt drivers/acpi/processor_idle.c:111 [inline]
 acpi_idle_do_entry+0x1e8/0x330 drivers/acpi/processor_idle.c:517
 acpi_idle_enter+0x35a/0x550 drivers/acpi/processor_idle.c:648
 cpuidle_enter_state+0x1ab/0xdb0 drivers/cpuidle/cpuidle.c:237
 cpuidle_enter+0x4a/0xa0 drivers/cpuidle/cpuidle.c:351
 call_cpuidle kernel/sched/idle.c:132 [inline]
 cpuidle_idle_call kernel/sched/idle.c:213 [inline]
 do_idle+0x48e/0x730 kernel/sched/idle.c:273
 cpu_startup_entry+0x14/0x20 kernel/sched/idle.c:369
 start_kernel+0x490/0x4b1 init/main.c:1049
 secondary_startup_64_no_verify+0xa6/0xab

