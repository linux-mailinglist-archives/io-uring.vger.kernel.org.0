Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 723CD2409FE
	for <lists+io-uring@lfdr.de>; Mon, 10 Aug 2020 17:37:51 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728638AbgHJPhj (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Mon, 10 Aug 2020 11:37:39 -0400
Received: from mail-io1-f70.google.com ([209.85.166.70]:44672 "EHLO
        mail-io1-f70.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1728660AbgHJPhT (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Mon, 10 Aug 2020 11:37:19 -0400
Received: by mail-io1-f70.google.com with SMTP id m12so7307679iov.11
        for <io-uring@vger.kernel.org>; Mon, 10 Aug 2020 08:37:18 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:date:message-id:subject:from:to;
        bh=sqCUJZ0N9QFf8u5nVlxIsNMxdST4jwToDGJoW6/Pw1g=;
        b=JbqtEa+nyCVtpKtDsCGMffUdLGudH/AFeISTwGQgmyzgQDlmJHyyi7dnBbBMIM1p3H
         ASmf4E5Ge7lqf11jiKuXMkpbf3MzF/6U0aFkRnB6HWI8Wk9OwaNnP6dfiPqrnGbkO+8L
         0IG6UQvW4jUHSazbD5eNGmQ0WVo7fULWBAF1oIanidCZPQPyqeJvpxFPR68PA2MwII6t
         1tdjBQIDPUSa+SHdk17o8Wejn5NSrR1UZUaY5TQYV1VgSp7VP7oxliIv4XqNfrjMgvG/
         PCvZje/4lmdI7F4VjXdHVov1lbvWpQpCLsHOJ3GrARDzTbSJ/9F+p+wzMrGJqqBGBlLF
         oJzQ==
X-Gm-Message-State: AOAM532wot0cJ8+sulf5G8ElhRf5LIijTNS9mEJXwhmDBe5XiDQqZ3VC
        kbzgmOR6woZOnzadyadQi4dXs7PJcze7yUFovUCsIREn/wz9
X-Google-Smtp-Source: ABdhPJwCy+ROg82sfsfHuaVqzXKtqhKu2XUEFcRwp+YNDxdNPxUqSNJ96j1/8Mw4j1J4Y0HfLqE2o6CKe6kCM6CTVOoT/25sLI96
MIME-Version: 1.0
X-Received: by 2002:a92:8b51:: with SMTP id i78mr17461223ild.179.1597073837991;
 Mon, 10 Aug 2020 08:37:17 -0700 (PDT)
Date:   Mon, 10 Aug 2020 08:37:17 -0700
X-Google-Appengine-App-Id: s~syzkaller
X-Google-Appengine-App-Id-Alias: syzkaller
Message-ID: <000000000000cb5dff05ac87ba2e@google.com>
Subject: possible deadlock in io_timeout_fn
From:   syzbot <syzbot+ef4b654b49ed7ff049bf@syzkaller.appspotmail.com>
To:     axboe@kernel.dk, bijan.mottahedeh@oracle.com,
        io-uring@vger.kernel.org, linux-fsdevel@vger.kernel.org,
        linux-kernel@vger.kernel.org, syzkaller-bugs@googlegroups.com,
        viro@zeniv.linux.org.uk
Content-Type: text/plain; charset="UTF-8"
Sender: io-uring-owner@vger.kernel.org
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org

Hello,

syzbot found the following issue on:

HEAD commit:    449dc8c9 Merge tag 'for-v5.9' of git://git.kernel.org/pub/..
git tree:       upstream
console output: https://syzkaller.appspot.com/x/log.txt?x=11293dc6900000
kernel config:  https://syzkaller.appspot.com/x/.config?x=9d25235bf0162fbc
dashboard link: https://syzkaller.appspot.com/bug?extid=ef4b654b49ed7ff049bf
compiler:       clang version 10.0.0 (https://github.com/llvm/llvm-project/ c2443155a0fb245c8f17f2c1c72b6ea391e86e81)
syz repro:      https://syzkaller.appspot.com/x/repro.syz?x=126b0f1a900000
C reproducer:   https://syzkaller.appspot.com/x/repro.c?x=13e32994900000

The issue was bisected to:

commit e62753e4e2926f249d088cc0517be5ed4efec6d6
Author: Bijan Mottahedeh <bijan.mottahedeh@oracle.com>
Date:   Sat May 23 04:31:18 2020 +0000

    io_uring: call statx directly

bisection log:  https://syzkaller.appspot.com/x/bisect.txt?x=1195de52900000
final oops:     https://syzkaller.appspot.com/x/report.txt?x=1395de52900000
console output: https://syzkaller.appspot.com/x/log.txt?x=1595de52900000

IMPORTANT: if you fix the issue, please add the following tag to the commit:
Reported-by: syzbot+ef4b654b49ed7ff049bf@syzkaller.appspotmail.com
Fixes: e62753e4e292 ("io_uring: call statx directly")

========================================================
WARNING: possible irq lock inversion dependency detected
5.8.0-syzkaller #0 Not tainted
--------------------------------------------------------
syz-executor659/6838 just changed the state of lock:
ffff8880a8bc44d8 (&ctx->completion_lock){-...}-{2:2}, at: io_timeout_fn+0x6b/0x360 fs/io_uring.c:4999
but this lock took another, HARDIRQ-unsafe lock in the past:
 (&fs->lock){+.+.}-{2:2}


and interrupts could create inverse lock ordering between them.


other info that might help us debug this:
 Possible interrupt unsafe locking scenario:

       CPU0                    CPU1
       ----                    ----
  lock(&fs->lock);
                               local_irq_disable();
                               lock(&ctx->completion_lock);
                               lock(&fs->lock);
  <Interrupt>
    lock(&ctx->completion_lock);

 *** DEADLOCK ***

1 lock held by syz-executor659/6838:
 #0: ffff8880a8bc4428 (&ctx->uring_lock){+.+.}-{3:3}, at: __do_sys_io_uring_enter fs/io_uring.c:8035 [inline]
 #0: ffff8880a8bc4428 (&ctx->uring_lock){+.+.}-{3:3}, at: __se_sys_io_uring_enter+0x19d/0x1300 fs/io_uring.c:7995

the shortest dependencies between 2nd lock and 1st lock:
 -> (&fs->lock){+.+.}-{2:2} {
    HARDIRQ-ON-W at:
                      lock_acquire+0x160/0x730 kernel/locking/lockdep.c:5005
                      __raw_spin_lock include/linux/spinlock_api_smp.h:142 [inline]
                      _raw_spin_lock+0x2a/0x40 kernel/locking/spinlock.c:151
                      spin_lock include/linux/spinlock.h:354 [inline]
                      set_fs_pwd+0x3b/0x220 fs/fs_struct.c:39
                      init_chdir+0xe2/0x10b fs/init.c:54
                      devtmpfs_setup+0xa5/0xd4 drivers/base/devtmpfs.c:415
                      devtmpfsd+0x11/0x40 drivers/base/devtmpfs.c:430
                      kthread+0x37e/0x3a0 drivers/block/aoe/aoecmd.c:1234
                      ret_from_fork+0x1f/0x30 arch/x86/entry/entry_64.S:294
    SOFTIRQ-ON-W at:
                      lock_acquire+0x160/0x730 kernel/locking/lockdep.c:5005
                      __raw_spin_lock include/linux/spinlock_api_smp.h:142 [inline]
                      _raw_spin_lock+0x2a/0x40 kernel/locking/spinlock.c:151
                      spin_lock include/linux/spinlock.h:354 [inline]
                      set_fs_pwd+0x3b/0x220 fs/fs_struct.c:39
                      init_chdir+0xe2/0x10b fs/init.c:54
                      devtmpfs_setup+0xa5/0xd4 drivers/base/devtmpfs.c:415
                      devtmpfsd+0x11/0x40 drivers/base/devtmpfs.c:430
                      kthread+0x37e/0x3a0 drivers/block/aoe/aoecmd.c:1234
                      ret_from_fork+0x1f/0x30 arch/x86/entry/entry_64.S:294
    INITIAL USE at:
                     lock_acquire+0x160/0x730 kernel/locking/lockdep.c:5005
                     __raw_spin_lock include/linux/spinlock_api_smp.h:142 [inline]
                     _raw_spin_lock+0x2a/0x40 kernel/locking/spinlock.c:151
                     spin_lock include/linux/spinlock.h:354 [inline]
                     set_fs_pwd+0x3b/0x220 fs/fs_struct.c:39
                     init_chdir+0xe2/0x10b fs/init.c:54
                     devtmpfs_setup+0xa5/0xd4 drivers/base/devtmpfs.c:415
                     devtmpfsd+0x11/0x40 drivers/base/devtmpfs.c:430
                     kthread+0x37e/0x3a0 drivers/block/aoe/aoecmd.c:1234
                     ret_from_fork+0x1f/0x30 arch/x86/entry/entry_64.S:294
  }
  ... key      at: [<ffffffff8b84e190>] copy_fs_struct.__key+0x0/0x10
  ... acquired at:
   lock_acquire+0x160/0x730 kernel/locking/lockdep.c:5005
   __raw_spin_lock include/linux/spinlock_api_smp.h:142 [inline]
   _raw_spin_lock+0x2a/0x40 kernel/locking/spinlock.c:151
   spin_lock include/linux/spinlock.h:354 [inline]
   io_req_clean_work fs/io_uring.c:1126 [inline]
   io_dismantle_req+0x285/0x5d0 fs/io_uring.c:1544
   __io_free_req+0x24/0x190 fs/io_uring.c:1562
   __io_double_put_req fs/io_uring.c:1909 [inline]
   __io_fail_links+0x1d7/0x6c0 fs/io_uring.c:1659
   io_fail_links fs/io_uring.c:1675 [inline]
   __io_req_find_next fs/io_uring.c:1698 [inline]
   io_req_find_next+0x101a/0x1260 fs/io_uring.c:1706
   io_steal_work fs/io_uring.c:1897 [inline]
   io_wq_submit_work+0x446/0x590 fs/io_uring.c:5792
   io_worker_handle_work+0xf8f/0x1570 fs/io-wq.c:527
   io_wqe_worker+0x2ff/0x810 fs/io-wq.c:569
   kthread+0x37e/0x3a0 drivers/block/aoe/aoecmd.c:1234
   ret_from_fork+0x1f/0x30 arch/x86/entry/entry_64.S:294

-> (&ctx->completion_lock){-...}-{2:2} {
   IN-HARDIRQ-W at:
                    lock_acquire+0x160/0x730 kernel/locking/lockdep.c:5005
                    __raw_spin_lock_irqsave include/linux/spinlock_api_smp.h:110 [inline]
                    _raw_spin_lock_irqsave+0x9e/0xc0 kernel/locking/spinlock.c:159
                    io_timeout_fn+0x6b/0x360 fs/io_uring.c:4999
                    __run_hrtimer kernel/time/hrtimer.c:1520 [inline]
                    __hrtimer_run_queues+0x47f/0x930 kernel/time/hrtimer.c:1584
                    hrtimer_interrupt+0x373/0xd60 kernel/time/hrtimer.c:1646
                    local_apic_timer_interrupt arch/x86/kernel/apic/apic.c:1079 [inline]
                    __sysvec_apic_timer_interrupt+0xf0/0x260 arch/x86/kernel/apic/apic.c:1096
                    asm_call_on_stack+0xf/0x20 arch/x86/entry/entry_64.S:706
                    __run_on_irqstack arch/x86/include/asm/irq_stack.h:22 [inline]
                    run_on_irqstack_cond arch/x86/include/asm/irq_stack.h:48 [inline]
                    sysvec_apic_timer_interrupt+0x94/0xf0 arch/x86/kernel/apic/apic.c:1090
                    asm_sysvec_apic_timer_interrupt+0x12/0x20 arch/x86/include/asm/idtentry.h:581
                    arch_local_irq_enable arch/x86/include/asm/paravirt.h:780 [inline]
                    __raw_spin_unlock_irq include/linux/spinlock_api_smp.h:168 [inline]
                    _raw_spin_unlock_irq+0x57/0x80 kernel/locking/spinlock.c:199
                    spin_unlock_irq include/linux/spinlock.h:404 [inline]
                    io_timeout fs/io_uring.c:5162 [inline]
                    io_issue_sqe+0x5b64/0xb8c0 fs/io_uring.c:5594
                    __io_queue_sqe+0x287/0xff0 fs/io_uring.c:5981
                    io_submit_sqe fs/io_uring.c:6130 [inline]
                    io_submit_sqes+0x14cf/0x25d0 fs/io_uring.c:6327
                    __do_sys_io_uring_enter fs/io_uring.c:8036 [inline]
                    __se_sys_io_uring_enter+0x1af/0x1300 fs/io_uring.c:7995
                    do_syscall_64+0x31/0x70 arch/x86/entry/common.c:46
                    entry_SYSCALL_64_after_hwframe+0x44/0xa9
   INITIAL USE at:
                   lock_acquire+0x160/0x730 kernel/locking/lockdep.c:5005
                   __raw_spin_lock_irqsave include/linux/spinlock_api_smp.h:110 [inline]
                   _raw_spin_lock_irqsave+0x9e/0xc0 kernel/locking/spinlock.c:159
                   io_cqring_add_event fs/io_uring.c:1419 [inline]
                   __io_req_complete+0x15e/0x2c0 fs/io_uring.c:1458
                   io_issue_sqe+0x8678/0xb8c0 fs/io_uring.c:3569
                   io_wq_submit_work+0x35e/0x590 fs/io_uring.c:5775
                   io_worker_handle_work+0xf8f/0x1570 fs/io-wq.c:527
                   io_wqe_worker+0x2ff/0x810 fs/io-wq.c:569
                   kthread+0x37e/0x3a0 drivers/block/aoe/aoecmd.c:1234
                   ret_from_fork+0x1f/0x30 arch/x86/entry/entry_64.S:294
 }
 ... key      at: [<ffffffff8b84ef58>] io_ring_ctx_alloc.__key.111+0x0/0x10
 ... acquired at:
   mark_lock_irq kernel/locking/lockdep.c:3568 [inline]
   mark_lock+0x529/0x1b00 kernel/locking/lockdep.c:4006
   mark_usage kernel/locking/lockdep.c:3902 [inline]
   __lock_acquire+0xa5c/0x2ab0 kernel/locking/lockdep.c:4380
   lock_acquire+0x160/0x730 kernel/locking/lockdep.c:5005
   __raw_spin_lock_irqsave include/linux/spinlock_api_smp.h:110 [inline]
   _raw_spin_lock_irqsave+0x9e/0xc0 kernel/locking/spinlock.c:159
   io_timeout_fn+0x6b/0x360 fs/io_uring.c:4999
   __run_hrtimer kernel/time/hrtimer.c:1520 [inline]
   __hrtimer_run_queues+0x47f/0x930 kernel/time/hrtimer.c:1584
   hrtimer_interrupt+0x373/0xd60 kernel/time/hrtimer.c:1646
   local_apic_timer_interrupt arch/x86/kernel/apic/apic.c:1079 [inline]
   __sysvec_apic_timer_interrupt+0xf0/0x260 arch/x86/kernel/apic/apic.c:1096
   asm_call_on_stack+0xf/0x20 arch/x86/entry/entry_64.S:706
   __run_on_irqstack arch/x86/include/asm/irq_stack.h:22 [inline]
   run_on_irqstack_cond arch/x86/include/asm/irq_stack.h:48 [inline]
   sysvec_apic_timer_interrupt+0x94/0xf0 arch/x86/kernel/apic/apic.c:1090
   asm_sysvec_apic_timer_interrupt+0x12/0x20 arch/x86/include/asm/idtentry.h:581
   arch_local_irq_enable arch/x86/include/asm/paravirt.h:780 [inline]
   __raw_spin_unlock_irq include/linux/spinlock_api_smp.h:168 [inline]
   _raw_spin_unlock_irq+0x57/0x80 kernel/locking/spinlock.c:199
   spin_unlock_irq include/linux/spinlock.h:404 [inline]
   io_timeout fs/io_uring.c:5162 [inline]
   io_issue_sqe+0x5b64/0xb8c0 fs/io_uring.c:5594
   __io_queue_sqe+0x287/0xff0 fs/io_uring.c:5981
   io_submit_sqe fs/io_uring.c:6130 [inline]
   io_submit_sqes+0x14cf/0x25d0 fs/io_uring.c:6327
   __do_sys_io_uring_enter fs/io_uring.c:8036 [inline]
   __se_sys_io_uring_enter+0x1af/0x1300 fs/io_uring.c:7995
   do_syscall_64+0x31/0x70 arch/x86/entry/common.c:46
   entry_SYSCALL_64_after_hwframe+0x44/0xa9


stack backtrace:
CPU: 1 PID: 6838 Comm: syz-executor659 Not tainted 5.8.0-syzkaller #0
Hardware name: Google Google Compute Engine/Google Compute Engine, BIOS Google 01/01/2011
Call Trace:
 <IRQ>
 __dump_stack lib/dump_stack.c:77 [inline]
 dump_stack+0x1f0/0x31e lib/dump_stack.c:118
 print_irq_inversion_bug+0xb67/0xe90 kernel/locking/lockdep.c:3428
 check_usage_forwards+0x13f/0x240 kernel/locking/lockdep.c:3453
 mark_lock_irq kernel/locking/lockdep.c:3568 [inline]
 mark_lock+0x529/0x1b00 kernel/locking/lockdep.c:4006
 mark_usage kernel/locking/lockdep.c:3902 [inline]
 __lock_acquire+0xa5c/0x2ab0 kernel/locking/lockdep.c:4380
 lock_acquire+0x160/0x730 kernel/locking/lockdep.c:5005
 __raw_spin_lock_irqsave include/linux/spinlock_api_smp.h:110 [inline]
 _raw_spin_lock_irqsave+0x9e/0xc0 kernel/locking/spinlock.c:159
 io_timeout_fn+0x6b/0x360 fs/io_uring.c:4999
 __run_hrtimer kernel/time/hrtimer.c:1520 [inline]
 __hrtimer_run_queues+0x47f/0x930 kernel/time/hrtimer.c:1584
 hrtimer_interrupt+0x373/0xd60 kernel/time/hrtimer.c:1646
 local_apic_timer_interrupt arch/x86/kernel/apic/apic.c:1079 [inline]
 __sysvec_apic_timer_interrupt+0xf0/0x260 arch/x86/kernel/apic/apic.c:1096
 asm_call_on_stack+0xf/0x20 arch/x86/entry/entry_64.S:706
 </IRQ>
 __run_on_irqstack arch/x86/include/asm/irq_stack.h:22 [inline]
 run_on_irqstack_cond arch/x86/include/asm/irq_stack.h:48 [inline]
 sysvec_apic_timer_interrupt+0x94/0xf0 arch/x86/kernel/apic/apic.c:1090
 asm_sysvec_apic_timer_interrupt+0x12/0x20 arch/x86/include/asm/idtentry.h:581
RIP: 0010:__raw_spin_unlock_irq include/linux/spinlock_api_smp.h:169 [inline]
RIP: 0010:_raw_spin_unlock_irq+0x57/0x80 kernel/locking/spinlock.c:199
Code: 00 00 00 00 fc ff df 80 3c 08 00 74 0c 48 c7 c7 c8 14 4d 89 e8 6a 28 8b f9 48 83 3d 0a a9 23 01 00 74 25 fb 66 0f 1f 44 00 00 <bf> 01 00 00 00 e8 6f 62 27 f9 65 8b 05 34 92 d8 77 85 c0 74 02 5b
RSP: 0018:ffffc9000102f8f0 EFLAGS: 00000286
RAX: 1ffffffff129a299 RBX: ffff8880a8bc44c0 RCX: dffffc0000000000
RDX: 0000000000000000 RSI: 0000000000000008 RDI: ffffffff88296b8f
RBP: ffffc9000102fb80 R08: dffffc0000000000 R09: fffffbfff167c6b8
R10: fffffbfff167c6b8 R11: 0000000000000000 R12: 0000000000000000
R13: dffffc0000000000 R14: ffff8880a2dfdc08 R15: ffff8880a2dfdc58
 spin_unlock_irq include/linux/spinlock.h:404 [inline]
 io_timeout fs/io_uring.c:5162 [inline]
 io_issue_sqe+0x5b64/0xb8c0 fs/io_uring.c:5594
 __io_queue_sqe+0x287/0xff0 fs/io_uring.c:5981
 io_submit_sqe fs/io_uring.c:6130 [inline]
 io_submit_sqes+0x14cf/0x25d0 fs/io_uring.c:6327
 __do_sys_io_uring_enter fs/io_uring.c:8036 [inline]
 __se_sys_io_uring_enter+0x1af/0x1300 fs/io_uring.c:7995
 do_syscall_64+0x31/0x70 arch/x86/entry/common.c:46
 entry_SYSCALL_64_after_hwframe+0x44/0xa9
RIP: 0033:0x440b99
Code: 18 89 d0 c3 66 2e 0f 1f 84 00 00 00 00 00 0f 1f 00 48 89 f8 48 89 f7 48 89 d6 48 89 ca 4d 89 c2 4d 89 c8 4c 8b 4c 24 08 0f 05 <48> 3d 01 f0 ff ff 0f 83 7b 13 fc ff c3 66 2e 0f 1f 84 00 00 00 00
RSP: 002b:00007ffea6abdbf8 EFLAGS: 00000246 ORIG_RAX: 00000000000001aa
RAX: ffffffffffffffda RBX: 00000000004002c8 RCX: 0000000000440b99
RDX: 0000000000000000 RSI: 000000000000450c RDI: 0000000000000005
RBP: 00000000006cb018 R08


---
This report is generated by a bot. It may contain errors.
See https://goo.gl/tpsmEJ for more information about syzbot.
syzbot engineers can be reached at syzkaller@googlegroups.com.

syzbot will keep track of this issue. See:
https://goo.gl/tpsmEJ#status for how to communicate with syzbot.
For information about bisection process see: https://goo.gl/tpsmEJ#bisection
syzbot can test patches for this issue, for details see:
https://goo.gl/tpsmEJ#testing-patches
