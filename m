Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 62F8F287692
	for <lists+io-uring@lfdr.de>; Thu,  8 Oct 2020 17:00:27 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730786AbgJHPA0 (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Thu, 8 Oct 2020 11:00:26 -0400
Received: from mail-il1-f207.google.com ([209.85.166.207]:45008 "EHLO
        mail-il1-f207.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1730797AbgJHPAX (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Thu, 8 Oct 2020 11:00:23 -0400
Received: by mail-il1-f207.google.com with SMTP id a14so4312194iln.11
        for <io-uring@vger.kernel.org>; Thu, 08 Oct 2020 08:00:21 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:date:message-id:subject:from:to;
        bh=lY++L9cL0ljmsfqhwTNdE4O6nYJ0FxIg2oBi5vOfh+k=;
        b=Bv0uJaQPpXPah7fzcG+O3IrjF406aPa418qVte2YNYb/egcAQiW909nFFA5Ghtn5+l
         QLKDWBtyhZe4uMJPl1zGOxsyqXTmgvEHnKqpWyBkHDWVAnVFrNrNj2DtPNShHNyNycNG
         bF9OrEdhq23BQuD5oc6RthcQvMIav1Hm5AjPwR3DOObqELiw+m9XSRORlVrAUDX91Xqs
         2Xd+sr5Ft9/SdgcSBZAxO63Sqm278rV5mHHO8wskzsH1P9TPc2Achs45ifLaS8HsMp+V
         vbFucHyesmACgGjlGJsujEgKpbBBHzLqEIBMly/PqFCjU3ppH2u1NXdiaPqyytq6Eoj+
         23Rg==
X-Gm-Message-State: AOAM530HGOF4szpgQKjpqyKWmLSLx65si6n+l2cov1lWzCeHKHAisgCx
        FzGlkrwYArxFmrtsgQqAWQHA+zslKakarTLcN8XrxzX0eU71
X-Google-Smtp-Source: ABdhPJy5aHn+Vg0GvVVRIq4RnjAMgJLNj5w4U0f/S+lPUJa9VMu5/sO8YizAwNfFZdRrYz3IbJZ7t+wEq3upfkE/hCqmhC0zV3Zf
MIME-Version: 1.0
X-Received: by 2002:a02:a510:: with SMTP id e16mr7153429jam.51.1602169220736;
 Thu, 08 Oct 2020 08:00:20 -0700 (PDT)
Date:   Thu, 08 Oct 2020 08:00:20 -0700
X-Google-Appengine-App-Id: s~syzkaller
X-Google-Appengine-App-Id-Alias: syzkaller
Message-ID: <00000000000045ac4605b12a1720@google.com>
Subject: inconsistent lock state in xa_destroy
From:   syzbot <syzbot+cdcbdc0bd42e559b52b9@syzkaller.appspotmail.com>
To:     axboe@kernel.dk, io-uring@vger.kernel.org,
        linux-fsdevel@vger.kernel.org, linux-kernel@vger.kernel.org,
        syzkaller-bugs@googlegroups.com, viro@zeniv.linux.org.uk
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org

Hello,

syzbot found the following issue on:

HEAD commit:    e4fb79c7 Add linux-next specific files for 20201008
git tree:       linux-next
console output: https://syzkaller.appspot.com/x/log.txt?x=12555227900000
kernel config:  https://syzkaller.appspot.com/x/.config?x=568d41fe4341ed0f
dashboard link: https://syzkaller.appspot.com/bug?extid=cdcbdc0bd42e559b52b9
compiler:       gcc (GCC) 10.1.0-syz 20200507

Unfortunately, I don't have any reproducer for this issue yet.

IMPORTANT: if you fix the issue, please add the following tag to the commit:
Reported-by: syzbot+cdcbdc0bd42e559b52b9@syzkaller.appspotmail.com

================================
WARNING: inconsistent lock state
5.9.0-rc8-next-20201008-syzkaller #0 Not tainted
--------------------------------
inconsistent {SOFTIRQ-ON-W} -> {IN-SOFTIRQ-W} usage.
syz-executor.2/6913 [HC0[0]:SC1[1]:HE0:SE0] takes:
ffff888023003c18 (&xa->xa_lock#9){+.?.}-{2:2}, at: xa_destroy+0xaa/0x350 lib/xarray.c:2205
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
irq event stamp: 362445
hardirqs last  enabled at (362444): [<ffffffff8847f0df>] __raw_spin_unlock_irqrestore include/linux/spinlock_api_smp.h:160 [inline]
hardirqs last  enabled at (362444): [<ffffffff8847f0df>] _raw_spin_unlock_irqrestore+0x6f/0x90 kernel/locking/spinlock.c:191
hardirqs last disabled at (362445): [<ffffffff8847f6c9>] __raw_spin_lock_irqsave include/linux/spinlock_api_smp.h:108 [inline]
hardirqs last disabled at (362445): [<ffffffff8847f6c9>] _raw_spin_lock_irqsave+0xa9/0xd0 kernel/locking/spinlock.c:159
softirqs last  enabled at (361998): [<ffffffff86db0172>] tcp_close+0x8d2/0x1220 net/ipv4/tcp.c:2576
softirqs last disabled at (362079): [<ffffffff88600f2f>] asm_call_irq_on_stack+0xf/0x20

other info that might help us debug this:
 Possible unsafe locking scenario:

       CPU0
       ----
  lock(&xa->xa_lock#9);
  <Interrupt>
    lock(&xa->xa_lock#9);

 *** DEADLOCK ***

1 lock held by syz-executor.2/6913:
 #0: ffffffff8a554c80 (rcu_callback){....}-{0:0}, at: rcu_do_batch kernel/rcu/tree.c:2474 [inline]
 #0: ffffffff8a554c80 (rcu_callback){....}-{0:0}, at: rcu_core+0x5d8/0x1240 kernel/rcu/tree.c:2718

stack backtrace:
CPU: 0 PID: 6913 Comm: syz-executor.2 Not tainted 5.9.0-rc8-next-20201008-syzkaller #0
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
RIP: 0010:memset_erms+0x9/0x10 arch/x86/lib/memset_64.S:66
Code: c1 e9 03 40 0f b6 f6 48 b8 01 01 01 01 01 01 01 01 48 0f af c6 f3 48 ab 89 d1 f3 aa 4c 89 c8 c3 90 49 89 f9 40 88 f0 48 89 d1 <f3> aa 4c 89 c8 c3 90 49 89 fa 40 0f b6 ce 48 b8 01 01 01 01 01 01
RSP: 0018:ffffc900053c7b78 EFLAGS: 00010202
RAX: 0000000000000000 RBX: 0000000000000000 RCX: 0000000000002040
RDX: 0000000000008000 RSI: 0000000000000000 RDI: ffffc900161a5fc0
RBP: ffffc900053c7d08 R08: 0000000000000001 R09: ffffc900161a0000
R10: fffff52002c34fff R11: 0000000000000000 R12: ffff88805b9f0380
R13: ffff888010ccae08 R14: 0000000001200000 R15: 0000000000000000
 memset include/linux/string.h:384 [inline]
 alloc_thread_stack_node kernel/fork.c:232 [inline]
 dup_task_struct kernel/fork.c:864 [inline]
 copy_process+0x68a/0x6e90 kernel/fork.c:1938
 kernel_clone+0xe5/0xae0 kernel/fork.c:2456
 __do_sys_clone+0xc8/0x110 kernel/fork.c:2573
 do_syscall_64+0x2d/0x70 arch/x86/entry/common.c:46
 entry_SYSCALL_64_after_hwframe+0x44/0xa9
RIP: 0033:0x45c3fa
Code: f7 d8 64 89 04 25 d4 02 00 00 64 4c 8b 0c 25 10 00 00 00 31 d2 4d 8d 91 d0 02 00 00 31 f6 bf 11 00 20 01 b8 38 00 00 00 0f 05 <48> 3d 00 f0 ff ff 0f 87 f5 00 00 00 85 c0 41 89 c5 0f 85 fc 00 00
RSP: 002b:00007ffe5dc445b0 EFLAGS: 00000246 ORIG_RAX: 0000000000000038
RAX: ffffffffffffffda RBX: 00007ffe5dc445b0 RCX: 000000000045c3fa
RDX: 0000000000000000 RSI: 0000000000000000 RDI: 0000000001200011
RBP: 00007ffe5dc445f0 R08: 0000000000000001 R09: 0000000002f46940
R10: 0000000002f46c10 R11: 0000000000000246 R12: 0000000000000001
R13: 0000000000000000 R14: 0000000000000001 R15: 00007ffe5dc44640


---
This report is generated by a bot. It may contain errors.
See https://goo.gl/tpsmEJ for more information about syzbot.
syzbot engineers can be reached at syzkaller@googlegroups.com.

syzbot will keep track of this issue. See:
https://goo.gl/tpsmEJ#status for how to communicate with syzbot.
