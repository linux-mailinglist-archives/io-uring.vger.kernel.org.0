Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 86A75288476
	for <lists+io-uring@lfdr.de>; Fri,  9 Oct 2020 10:01:24 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1732613AbgJIIAc (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Fri, 9 Oct 2020 04:00:32 -0400
Received: from mail-il1-f205.google.com ([209.85.166.205]:42875 "EHLO
        mail-il1-f205.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1732525AbgJIIAZ (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Fri, 9 Oct 2020 04:00:25 -0400
Received: by mail-il1-f205.google.com with SMTP id 18so6276056ilt.9
        for <io-uring@vger.kernel.org>; Fri, 09 Oct 2020 01:00:23 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:date:message-id:subject:from:to;
        bh=eOD7BtHWSKEPTdJ+fUO2oFYrU8z7mMDg/rYmr1MnpH8=;
        b=C89g2utKHRchQWJGX09wlR/65re+lqXUfZG1Z4qVT1ma5ghCO3z649EuC9bnOb5emU
         fb4tFD+v8HxRO5BLetCLDRIsil+2tfSS+V1/miEhaRxcGZReOwvcrDHxwWY1IVEiXcDv
         AJvkL+mjCQNcsbivt9RWPsrUlZQZWPya/u9lHHJXlURPMSUFUXDhHo16plh0s+dEqi5s
         XWw06WehtPIIPzxn5G8B7GXPdQINnDl7r14WmsNnWi99lMKcYUoArpSkE7tVwWs9A04k
         6B+QvIecPEMdfGsnKPpzAFXzAiozwuR1ZHFtLU4KBb3fdnLxJdpg4KLOtUF8lWyQMWhq
         eOAg==
X-Gm-Message-State: AOAM533BL7tQzjVANRNxDgNQNgV9KuSv3G1qGVzn/CSdyFYhnAsdWOQ1
        ZtwTjGMC5Vwo+etTdrZz4a/jVi1Am6CoIfJkVAv2WGLCW1le
X-Google-Smtp-Source: ABdhPJwH60XYZ2M2nGvt2bLfm3bvuc9NBX2KOIX9Fet9jO9hHCS3SbvBvxns4ss6fVe6e65XHkmi/UJnoHj0G7thFmH9cPa25G8n
MIME-Version: 1.0
X-Received: by 2002:a05:6638:1616:: with SMTP id x22mr10409541jas.110.1602230422963;
 Fri, 09 Oct 2020 01:00:22 -0700 (PDT)
Date:   Fri, 09 Oct 2020 01:00:22 -0700
X-Google-Appengine-App-Id: s~syzkaller
X-Google-Appengine-App-Id-Alias: syzkaller
Message-ID: <000000000000358ba805b1385785@google.com>
Subject: inconsistent lock state in io_uring_add_task_file
From:   syzbot <syzbot+27c12725d8ff0bfe1a13@syzkaller.appspotmail.com>
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
console output: https://syzkaller.appspot.com/x/log.txt?x=172b3ebf900000
kernel config:  https://syzkaller.appspot.com/x/.config?x=568d41fe4341ed0f
dashboard link: https://syzkaller.appspot.com/bug?extid=27c12725d8ff0bfe1a13
compiler:       gcc (GCC) 10.1.0-syz 20200507

Unfortunately, I don't have any reproducer for this issue yet.

IMPORTANT: if you fix the issue, please add the following tag to the commit:
Reported-by: syzbot+27c12725d8ff0bfe1a13@syzkaller.appspotmail.com

================================
WARNING: inconsistent lock state
5.9.0-rc8-next-20201008-syzkaller #0 Not tainted
--------------------------------
inconsistent {IN-SOFTIRQ-W} -> {SOFTIRQ-ON-W} usage.
syz-executor.2/8511 [HC0[0]:SC0[0]:HE1:SE1] takes:
ffff8880161fdc18 (&xa->xa_lock#8){+.?.}-{2:2}, at: spin_lock include/linux/spinlock.h:354 [inline]
ffff8880161fdc18 (&xa->xa_lock#8){+.?.}-{2:2}, at: io_uring_add_task_file fs/io_uring.c:8607 [inline]
ffff8880161fdc18 (&xa->xa_lock#8){+.?.}-{2:2}, at: io_uring_add_task_file+0x207/0x430 fs/io_uring.c:8590
{IN-SOFTIRQ-W} state was registered at:
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
  __run_on_irqstack arch/x86/include/asm/irq_stack.h:26 [inline]
  run_on_irqstack_cond arch/x86/include/asm/irq_stack.h:77 [inline]
  do_softirq_own_stack+0x9b/0xd0 arch/x86/kernel/irq_64.c:77
  invoke_softirq kernel/softirq.c:393 [inline]
  __irq_exit_rcu kernel/softirq.c:423 [inline]
  irq_exit_rcu+0x235/0x280 kernel/softirq.c:435
  sysvec_apic_timer_interrupt+0x51/0xf0 arch/x86/kernel/apic/apic.c:1091
  asm_sysvec_apic_timer_interrupt+0x12/0x20 arch/x86/include/asm/idtentry.h:631
  arch_local_irq_restore arch/x86/include/asm/paravirt.h:653 [inline]
  lock_acquire+0x27b/0xaa0 kernel/locking/lockdep.c:5422
  rcu_lock_acquire include/linux/rcupdate.h:253 [inline]
  rcu_read_lock include/linux/rcupdate.h:642 [inline]
  batadv_nc_purge_orig_hash net/batman-adv/network-coding.c:407 [inline]
  batadv_nc_worker+0x12d/0xe50 net/batman-adv/network-coding.c:718
  process_one_work+0x933/0x15a0 kernel/workqueue.c:2269
  worker_thread+0x64c/0x1120 kernel/workqueue.c:2415
  kthread+0x3af/0x4a0 kernel/kthread.c:292
  ret_from_fork+0x1f/0x30 arch/x86/entry/entry_64.S:296
irq event stamp: 225
hardirqs last  enabled at (225): [<ffffffff8847f0df>] __raw_spin_unlock_irqrestore include/linux/spinlock_api_smp.h:160 [inline]
hardirqs last  enabled at (225): [<ffffffff8847f0df>] _raw_spin_unlock_irqrestore+0x6f/0x90 kernel/locking/spinlock.c:191
hardirqs last disabled at (224): [<ffffffff8847f6c9>] __raw_spin_lock_irqsave include/linux/spinlock_api_smp.h:108 [inline]
hardirqs last disabled at (224): [<ffffffff8847f6c9>] _raw_spin_lock_irqsave+0xa9/0xd0 kernel/locking/spinlock.c:159
softirqs last  enabled at (206): [<ffffffff870a2164>] read_pnet include/net/net_namespace.h:327 [inline]
softirqs last  enabled at (206): [<ffffffff870a2164>] sock_net include/net/sock.h:2521 [inline]
softirqs last  enabled at (206): [<ffffffff870a2164>] unix_create1+0x484/0x570 net/unix/af_unix.c:816
softirqs last disabled at (204): [<ffffffff870a20e1>] unix_sockets_unbound net/unix/af_unix.c:133 [inline]
softirqs last disabled at (204): [<ffffffff870a20e1>] unix_create1+0x401/0x570 net/unix/af_unix.c:810

other info that might help us debug this:
 Possible unsafe locking scenario:

       CPU0
       ----
  lock(&xa->xa_lock#8);
  <Interrupt>
    lock(&xa->xa_lock#8);

 *** DEADLOCK ***

1 lock held by syz-executor.2/8511:
 #0: ffffffff8a554da0 (rcu_read_lock){....}-{1:2}, at: io_uring_add_task_file fs/io_uring.c:8600 [inline]
 #0: ffffffff8a554da0 (rcu_read_lock){....}-{1:2}, at: io_uring_add_task_file+0x138/0x430 fs/io_uring.c:8590

stack backtrace:
CPU: 1 PID: 8511 Comm: syz-executor.2 Not tainted 5.9.0-rc8-next-20201008-syzkaller #0
Hardware name: Google Google Compute Engine/Google Compute Engine, BIOS Google 01/01/2011
Call Trace:
 __dump_stack lib/dump_stack.c:77 [inline]
 dump_stack+0x198/0x1fb lib/dump_stack.c:118
 print_usage_bug kernel/locking/lockdep.c:3715 [inline]
 valid_state kernel/locking/lockdep.c:3726 [inline]
 mark_lock_irq kernel/locking/lockdep.c:3929 [inline]
 mark_lock.cold+0x32/0x74 kernel/locking/lockdep.c:4396
 mark_usage kernel/locking/lockdep.c:4299 [inline]
 __lock_acquire+0x886/0x56d0 kernel/locking/lockdep.c:4771
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
RIP: 0033:0x45de29
Code: 0d b4 fb ff c3 66 2e 0f 1f 84 00 00 00 00 00 66 90 48 89 f8 48 89 f7 48 89 d6 48 89 ca 4d 89 c2 4d 89 c8 4c 8b 4c 24 08 0f 05 <48> 3d 01 f0 ff ff 0f 83 db b3 fb ff c3 66 2e 0f 1f 84 00 00 00 00
RSP: 002b:00007fc3719c4bf8 EFLAGS: 00000206 ORIG_RAX: 00000000000001a9
RAX: ffffffffffffffda RBX: 0000000020000080 RCX: 000000000045de29
RDX: 00000000206d4000 RSI: 0000000020000080 RDI: 0000000000000087
RBP: 000000000118bf78 R08: 0000000020000040 R09: 0000000020000040
R10: 0000000020000000 R11: 0000000000000206 R12: 00000000206d4000
R13: 0000000020ee7000 R14: 0000000020000040 R15: 0000000020000000


---
This report is generated by a bot. It may contain errors.
See https://goo.gl/tpsmEJ for more information about syzbot.
syzbot engineers can be reached at syzkaller@googlegroups.com.

syzbot will keep track of this issue. See:
https://goo.gl/tpsmEJ#status for how to communicate with syzbot.
