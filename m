Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 1839A322B90
	for <lists+io-uring@lfdr.de>; Tue, 23 Feb 2021 14:37:20 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232963AbhBWNgQ (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Tue, 23 Feb 2021 08:36:16 -0500
Received: from mail-il1-f198.google.com ([209.85.166.198]:50391 "EHLO
        mail-il1-f198.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232801AbhBWNgG (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Tue, 23 Feb 2021 08:36:06 -0500
Received: by mail-il1-f198.google.com with SMTP id x11so10255710ill.17
        for <io-uring@vger.kernel.org>; Tue, 23 Feb 2021 05:35:49 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:date:message-id:subject:from:to;
        bh=Xi6RC7ZMu2hIG2j15w+8GBmMOzwo95mmfYGYu0RDrDU=;
        b=WEhh16/RrSBrp4KnAcqt9cJKeIBdBE7/1orqpi4/HUu5VYrf0PxfV1nUviyWT5TAwo
         uVkIoAH7Apz5K2ye3hFBl6P9s86q5DnCoL/BTFbZHIZborLfnDSaOtstmiU2Zfjd5EC3
         99PwD50l0gNlCa1ChuuNi5CGcrbXa3Ld71YII3Hc1sb26v0D3qXqnO7QrOFnzJXc3m+z
         qc2Pqxa01ybcFKNZz8QO6a2gv+Ed9DrPERBOOCjFHCKdMKq1PGkcXvK0FmsxSc/D5ciE
         xVcLrXQlc6DCCPUTN+oCq8hcDoqYi4OfIaR6nKnHqx0wK2t82JKaEkvDuaiC4gXTrEVA
         0VaA==
X-Gm-Message-State: AOAM530n6RpjRVhvH5oCdZR7kFdAUuWksr8rG0aZCZVpKBtPHro5gfbw
        MWVx93W3Y8HxOKgBl4BmRb1SBhoETDX65jtoOP3bGF8S9QmM
X-Google-Smtp-Source: ABdhPJx+3Po97UpECh5rPZzovqvvMAr1zQ6hCjwqq23V5ZQNK7ESRgY92EpxT4nKr3MZ5Si6+fArsZkg6/cT9KaPdXLRs3zG+JsO
MIME-Version: 1.0
X-Received: by 2002:a05:6e02:cb1:: with SMTP id 17mr15841578ilg.271.1614087324164;
 Tue, 23 Feb 2021 05:35:24 -0800 (PST)
Date:   Tue, 23 Feb 2021 05:35:24 -0800
X-Google-Appengine-App-Id: s~syzkaller
X-Google-Appengine-App-Id-Alias: syzkaller
Message-ID: <00000000000097f98905bc00fd53@google.com>
Subject: possible deadlock in io_link_timeout_fn
From:   syzbot <syzbot+9a512c5bdc15635eab70@syzkaller.appspotmail.com>
To:     asml.silence@gmail.com, axboe@kernel.dk, io-uring@vger.kernel.org,
        linux-kernel@vger.kernel.org, syzkaller-bugs@googlegroups.com
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org

Hello,

syzbot found the following issue on:

HEAD commit:    31caf8b2 Merge branch 'linus' of git://git.kernel.org/pub/..
git tree:       upstream
console output: https://syzkaller.appspot.com/x/log.txt?x=11c64f12d00000
kernel config:  https://syzkaller.appspot.com/x/.config?x=5a8f3a57fabb4015
dashboard link: https://syzkaller.appspot.com/bug?extid=9a512c5bdc15635eab70

Unfortunately, I don't have any reproducer for this issue yet.

IMPORTANT: if you fix the issue, please add the following tag to the commit:
Reported-by: syzbot+9a512c5bdc15635eab70@syzkaller.appspotmail.com

=====================================================
WARNING: HARDIRQ-safe -> HARDIRQ-unsafe lock order detected
5.11.0-syzkaller #0 Not tainted
-----------------------------------------------------
syz-executor.0/12185 [HC0[0]:SC0[0]:HE0:SE1] is trying to acquire:
ffff888013db4820 (&fs->lock){+.+.}-{2:2}, at: spin_lock include/linux/spinlock.h:354 [inline]
ffff888013db4820 (&fs->lock){+.+.}-{2:2}, at: io_req_clean_work fs/io_uring.c:1405 [inline]
ffff888013db4820 (&fs->lock){+.+.}-{2:2}, at: io_dismantle_req+0x90f/0xf90 fs/io_uring.c:2051

and this task is already holding:
ffff88806bea6718 (&ctx->completion_lock){-...}-{2:2}, at: io_req_complete_post+0x4e/0x920 fs/io_uring.c:1923
which would create a new lock dependency:
 (&ctx->completion_lock){-...}-{2:2} -> (&fs->lock){+.+.}-{2:2}

but this new dependency connects a HARDIRQ-irq-safe lock:
 (&ctx->completion_lock){-...}-{2:2}

... which became HARDIRQ-irq-safe at:
  lock_acquire kernel/locking/lockdep.c:5510 [inline]
  lock_acquire+0x1ab/0x730 kernel/locking/lockdep.c:5475
  __raw_spin_lock_irqsave include/linux/spinlock_api_smp.h:110 [inline]
  _raw_spin_lock_irqsave+0x39/0x50 kernel/locking/spinlock.c:159
  io_link_timeout_fn+0xbf/0x720 fs/io_uring.c:6495
  __run_hrtimer kernel/time/hrtimer.c:1519 [inline]
  __hrtimer_run_queues+0x609/0xe40 kernel/time/hrtimer.c:1583
  hrtimer_interrupt+0x334/0x940 kernel/time/hrtimer.c:1645
  local_apic_timer_interrupt arch/x86/kernel/apic/apic.c:1089 [inline]
  __sysvec_apic_timer_interrupt+0x146/0x540 arch/x86/kernel/apic/apic.c:1106
  asm_call_irq_on_stack+0xf/0x20
  __run_sysvec_on_irqstack arch/x86/include/asm/irq_stack.h:37 [inline]
  run_sysvec_on_irqstack_cond arch/x86/include/asm/irq_stack.h:89 [inline]
  sysvec_apic_timer_interrupt+0xbd/0x100 arch/x86/kernel/apic/apic.c:1100
  asm_sysvec_apic_timer_interrupt+0x12/0x20 arch/x86/include/asm/idtentry.h:635
  __raw_spin_unlock_irq include/linux/spinlock_api_smp.h:169 [inline]
  _raw_spin_unlock_irq+0x25/0x40 kernel/locking/spinlock.c:199
  spin_unlock_irq include/linux/spinlock.h:404 [inline]
  io_queue_linked_timeout+0x194/0x1f0 fs/io_uring.c:6541
  __io_queue_sqe+0x32f/0xdb0 fs/io_uring.c:6607
  __io_req_task_submit+0x18e/0x240 fs/io_uring.c:2344
  __tctx_task_work fs/io_uring.c:2204 [inline]
  tctx_task_work+0x12b/0x330 fs/io_uring.c:2230
  task_work_run+0xdd/0x1a0 kernel/task_work.c:140
  tracehook_notify_signal include/linux/tracehook.h:212 [inline]
  handle_signal_work kernel/entry/common.c:145 [inline]
  exit_to_user_mode_loop kernel/entry/common.c:171 [inline]
  exit_to_user_mode_prepare+0x221/0x250 kernel/entry/common.c:208
  __syscall_exit_to_user_mode_work kernel/entry/common.c:290 [inline]
  syscall_exit_to_user_mode+0x19/0x50 kernel/entry/common.c:301
  entry_SYSCALL_64_after_hwframe+0x44/0xae

to a HARDIRQ-irq-unsafe lock:
 (&fs->lock){+.+.}-{2:2}

... which became HARDIRQ-irq-unsafe at:
...
  lock_acquire kernel/locking/lockdep.c:5510 [inline]
  lock_acquire+0x1ab/0x730 kernel/locking/lockdep.c:5475
  __raw_spin_lock include/linux/spinlock_api_smp.h:142 [inline]
  _raw_spin_lock+0x2a/0x40 kernel/locking/spinlock.c:151
  spin_lock include/linux/spinlock.h:354 [inline]
  set_fs_pwd+0x85/0x2a0 fs/fs_struct.c:39
  init_chdir+0x106/0x14e fs/init.c:54
  devtmpfs_setup drivers/base/devtmpfs.c:415 [inline]
  devtmpfsd+0x76/0x333 drivers/base/devtmpfs.c:430
  kthread+0x3b1/0x4a0 kernel/kthread.c:292
  ret_from_fork+0x1f/0x30 arch/x86/entry/entry_64.S:294

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

1 lock held by syz-executor.0/12185:
 #0: ffff88806bea6718 (&ctx->completion_lock){-...}-{2:2}, at: io_req_complete_post+0x4e/0x920 fs/io_uring.c:1923

the dependencies between HARDIRQ-irq-safe lock and the holding lock:
-> (&ctx->completion_lock){-...}-{2:2} {
   IN-HARDIRQ-W at:
                    lock_acquire kernel/locking/lockdep.c:5510 [inline]
                    lock_acquire+0x1ab/0x730 kernel/locking/lockdep.c:5475
                    __raw_spin_lock_irqsave include/linux/spinlock_api_smp.h:110 [inline]
                    _raw_spin_lock_irqsave+0x39/0x50 kernel/locking/spinlock.c:159
                    io_link_timeout_fn+0xbf/0x720 fs/io_uring.c:6495
                    __run_hrtimer kernel/time/hrtimer.c:1519 [inline]
                    __hrtimer_run_queues+0x609/0xe40 kernel/time/hrtimer.c:1583
                    hrtimer_interrupt+0x334/0x940 kernel/time/hrtimer.c:1645
                    local_apic_timer_interrupt arch/x86/kernel/apic/apic.c:1089 [inline]
                    __sysvec_apic_timer_interrupt+0x146/0x540 arch/x86/kernel/apic/apic.c:1106
                    asm_call_irq_on_stack+0xf/0x20
                    __run_sysvec_on_irqstack arch/x86/include/asm/irq_stack.h:37 [inline]
                    run_sysvec_on_irqstack_cond arch/x86/include/asm/irq_stack.h:89 [inline]
                    sysvec_apic_timer_interrupt+0xbd/0x100 arch/x86/kernel/apic/apic.c:1100
                    asm_sysvec_apic_timer_interrupt+0x12/0x20 arch/x86/include/asm/idtentry.h:635
                    __raw_spin_unlock_irq include/linux/spinlock_api_smp.h:169 [inline]
                    _raw_spin_unlock_irq+0x25/0x40 kernel/locking/spinlock.c:199
                    spin_unlock_irq include/linux/spinlock.h:404 [inline]
                    io_queue_linked_timeout+0x194/0x1f0 fs/io_uring.c:6541
                    __io_queue_sqe+0x32f/0xdb0 fs/io_uring.c:6607
                    __io_req_task_submit+0x18e/0x240 fs/io_uring.c:2344
                    __tctx_task_work fs/io_uring.c:2204 [inline]
                    tctx_task_work+0x12b/0x330 fs/io_uring.c:2230
                    task_work_run+0xdd/0x1a0 kernel/task_work.c:140
                    tracehook_notify_signal include/linux/tracehook.h:212 [inline]
                    handle_signal_work kernel/entry/common.c:145 [inline]
                    exit_to_user_mode_loop kernel/entry/common.c:171 [inline]
                    exit_to_user_mode_prepare+0x221/0x250 kernel/entry/common.c:208
                    __syscall_exit_to_user_mode_work kernel/entry/common.c:290 [inline]
                    syscall_exit_to_user_mode+0x19/0x50 kernel/entry/common.c:301
                    entry_SYSCALL_64_after_hwframe+0x44/0xae
   INITIAL USE at:
                   lock_acquire kernel/locking/lockdep.c:5510 [inline]
                   lock_acquire+0x1ab/0x730 kernel/locking/lockdep.c:5475
                   __raw_spin_lock_irqsave include/linux/spinlock_api_smp.h:110 [inline]
                   _raw_spin_lock_irqsave+0x39/0x50 kernel/locking/spinlock.c:159
                   io_req_complete_post+0x4e/0x920 fs/io_uring.c:1923
                   __io_req_complete fs/io_uring.c:1963 [inline]
                   io_req_complete fs/io_uring.c:1968 [inline]
                   io_queue_sqe+0xa3b/0xfa0 fs/io_uring.c:6620
                   io_submit_sqe fs/io_uring.c:6707 [inline]
                   io_submit_sqes+0x15f5/0x2b60 fs/io_uring.c:6939
                   __do_sys_io_uring_enter+0x1154/0x1f50 fs/io_uring.c:9454
                   do_syscall_64+0x2d/0x70 arch/x86/entry/common.c:46
                   entry_SYSCALL_64_after_hwframe+0x44/0xae
 }
 ... key      at: [<ffffffff8fe69a80>] __key.9+0x0/0x40
 ... acquired at:
   lock_acquire kernel/locking/lockdep.c:5510 [inline]
   lock_acquire+0x1ab/0x730 kernel/locking/lockdep.c:5475
   __raw_spin_lock include/linux/spinlock_api_smp.h:142 [inline]
   _raw_spin_lock+0x2a/0x40 kernel/locking/spinlock.c:151
   spin_lock include/linux/spinlock.h:354 [inline]
   io_req_clean_work fs/io_uring.c:1405 [inline]
   io_dismantle_req+0x90f/0xf90 fs/io_uring.c:2051
   io_req_complete_post+0xf6/0x920 fs/io_uring.c:1933
   __io_req_complete fs/io_uring.c:1963 [inline]
   io_req_complete fs/io_uring.c:1968 [inline]
   io_cancel_defer_files fs/io_uring.c:8945 [inline]
   io_uring_cancel_task_requests+0x67e/0xea0 fs/io_uring.c:9052
   __io_uring_files_cancel+0x110/0x1b0 fs/io_uring.c:9140
   io_uring_files_cancel include/linux/io_uring.h:65 [inline]
   do_exit+0x2fe/0x2ae0 kernel/exit.c:780
   do_group_exit+0x125/0x310 kernel/exit.c:922
   get_signal+0x42c/0x2100 kernel/signal.c:2773
   arch_do_signal_or_restart+0x2a8/0x1eb0 arch/x86/kernel/signal.c:811
   handle_signal_work kernel/entry/common.c:147 [inline]
   exit_to_user_mode_loop kernel/entry/common.c:171 [inline]
   exit_to_user_mode_prepare+0x148/0x250 kernel/entry/common.c:208
   __syscall_exit_to_user_mode_work kernel/entry/common.c:290 [inline]
   syscall_exit_to_user_mode+0x19/0x50 kernel/entry/common.c:301
   entry_SYSCALL_64_after_hwframe+0x44/0xae


the dependencies between the lock to be acquired
 and HARDIRQ-irq-unsafe lock:
-> (&fs->lock){+.+.}-{2:2} {
   HARDIRQ-ON-W at:
                    lock_acquire kernel/locking/lockdep.c:5510 [inline]
                    lock_acquire+0x1ab/0x730 kernel/locking/lockdep.c:5475
                    __raw_spin_lock include/linux/spinlock_api_smp.h:142 [inline]
                    _raw_spin_lock+0x2a/0x40 kernel/locking/spinlock.c:151
                    spin_lock include/linux/spinlock.h:354 [inline]
                    set_fs_pwd+0x85/0x2a0 fs/fs_struct.c:39
                    init_chdir+0x106/0x14e fs/init.c:54
                    devtmpfs_setup drivers/base/devtmpfs.c:415 [inline]
                    devtmpfsd+0x76/0x333 drivers/base/devtmpfs.c:430
                    kthread+0x3b1/0x4a0 kernel/kthread.c:292
                    ret_from_fork+0x1f/0x30 arch/x86/entry/entry_64.S:294
   SOFTIRQ-ON-W at:
                    lock_acquire kernel/locking/lockdep.c:5510 [inline]
                    lock_acquire+0x1ab/0x730 kernel/locking/lockdep.c:5475
                    __raw_spin_lock include/linux/spinlock_api_smp.h:142 [inline]
                    _raw_spin_lock+0x2a/0x40 kernel/locking/spinlock.c:151
                    spin_lock include/linux/spinlock.h:354 [inline]
                    set_fs_pwd+0x85/0x2a0 fs/fs_struct.c:39
                    init_chdir+0x106/0x14e fs/init.c:54
                    devtmpfs_setup drivers/base/devtmpfs.c:415 [inline]
                    devtmpfsd+0x76/0x333 drivers/base/devtmpfs.c:430
                    kthread+0x3b1/0x4a0 kernel/kthread.c:292
                    ret_from_fork+0x1f/0x30 arch/x86/entry/entry_64.S:294
   INITIAL USE at:
                   lock_acquire kernel/locking/lockdep.c:5510 [inline]
                   lock_acquire+0x1ab/0x730 kernel/locking/lockdep.c:5475
                   __raw_spin_lock include/linux/spinlock_api_smp.h:142 [inline]
                   _raw_spin_lock+0x2a/0x40 kernel/locking/spinlock.c:151
                   spin_lock include/linux/spinlock.h:354 [inline]
                   set_fs_pwd+0x85/0x2a0 fs/fs_struct.c:39
                   init_chdir+0x106/0x14e fs/init.c:54
                   devtmpfs_setup drivers/base/devtmpfs.c:415 [inline]
                   devtmpfsd+0x76/0x333 drivers/base/devtmpfs.c:430
                   kthread+0x3b1/0x4a0 kernel/kthread.c:292
                   ret_from_fork+0x1f/0x30 arch/x86/entry/entry_64.S:294
 }
 ... key      at: [<ffffffff8fe68260>] __key.1+0x0/0x40
 ... acquired at:
   lock_acquire kernel/locking/lockdep.c:5510 [inline]
   lock_acquire+0x1ab/0x730 kernel/locking/lockdep.c:5475
   __raw_spin_lock include/linux/spinlock_api_smp.h:142 [inline]
   _raw_spin_lock+0x2a/0x40 kernel/locking/spinlock.c:151
   spin_lock include/linux/spinlock.h:354 [inline]
   io_req_clean_work fs/io_uring.c:1405 [inline]
   io_dismantle_req+0x90f/0xf90 fs/io_uring.c:2051
   io_req_complete_post+0xf6/0x920 fs/io_uring.c:1933
   __io_req_complete fs/io_uring.c:1963 [inline]
   io_req_complete fs/io_uring.c:1968 [inline]
   io_cancel_defer_files fs/io_uring.c:8945 [inline]
   io_uring_cancel_task_requests+0x67e/0xea0 fs/io_uring.c:9052
   __io_uring_files_cancel+0x110/0x1b0 fs/io_uring.c:9140
   io_uring_files_cancel include/linux/io_uring.h:65 [inline]
   do_exit+0x2fe/0x2ae0 kernel/exit.c:780
   do_group_exit+0x125/0x310 kernel/exit.c:922
   get_signal+0x42c/0x2100 kernel/signal.c:2773
   arch_do_signal_or_restart+0x2a8/0x1eb0 arch/x86/kernel/signal.c:811
   handle_signal_work kernel/entry/common.c:147 [inline]
   exit_to_user_mode_loop kernel/entry/common.c:171 [inline]
   exit_to_user_mode_prepare+0x148/0x250 kernel/entry/common.c:208
   __syscall_exit_to_user_mode_work kernel/entry/common.c:290 [inline]
   syscall_exit_to_user_mode+0x19/0x50 kernel/entry/common.c:301
   entry_SYSCALL_64_after_hwframe+0x44/0xae


stack backtrace:
CPU: 3 PID: 12185 Comm: syz-executor.0 Not tainted 5.11.0-syzkaller #0
Hardware name: QEMU Standard PC (Q35 + ICH9, 2009), BIOS 1.14.0-2 04/01/2014
Call Trace:
 __dump_stack lib/dump_stack.c:79 [inline]
 dump_stack+0xfa/0x151 lib/dump_stack.c:120
 print_bad_irq_dependency kernel/locking/lockdep.c:2460 [inline]
 check_irq_usage.cold+0x50d/0x744 kernel/locking/lockdep.c:2689
 check_prev_add kernel/locking/lockdep.c:2940 [inline]
 check_prevs_add kernel/locking/lockdep.c:3059 [inline]
 validate_chain kernel/locking/lockdep.c:3674 [inline]
 __lock_acquire+0x2b2c/0x54c0 kernel/locking/lockdep.c:4900
 lock_acquire kernel/locking/lockdep.c:5510 [inline]
 lock_acquire+0x1ab/0x730 kernel/locking/lockdep.c:5475
 __raw_spin_lock include/linux/spinlock_api_smp.h:142 [inline]
 _raw_spin_lock+0x2a/0x40 kernel/locking/spinlock.c:151
 spin_lock include/linux/spinlock.h:354 [inline]
 io_req_clean_work fs/io_uring.c:1405 [inline]
 io_dismantle_req+0x90f/0xf90 fs/io_uring.c:2051
 io_req_complete_post+0xf6/0x920 fs/io_uring.c:1933
 __io_req_complete fs/io_uring.c:1963 [inline]
 io_req_complete fs/io_uring.c:1968 [inline]
 io_cancel_defer_files fs/io_uring.c:8945 [inline]
 io_uring_cancel_task_requests+0x67e/0xea0 fs/io_uring.c:9052
 __io_uring_files_cancel+0x110/0x1b0 fs/io_uring.c:9140
 io_uring_files_cancel include/linux/io_uring.h:65 [inline]
 do_exit+0x2fe/0x2ae0 kernel/exit.c:780
 do_group_exit+0x125/0x310 kernel/exit.c:922
 get_signal+0x42c/0x2100 kernel/signal.c:2773
 arch_do_signal_or_restart+0x2a8/0x1eb0 arch/x86/kernel/signal.c:811
 handle_signal_work kernel/entry/common.c:147 [inline]
 exit_to_user_mode_loop kernel/entry/common.c:171 [inline]
 exit_to_user_mode_prepare+0x148/0x250 kernel/entry/common.c:208
 __syscall_exit_to_user_mode_work kernel/entry/common.c:290 [inline]
 syscall_exit_to_user_mode+0x19/0x50 kernel/entry/common.c:301
 entry_SYSCALL_64_after_hwframe+0x44/0xae
RIP: 0033:0x465ef9
Code: ff ff c3 66 2e 0f 1f 84 00 00 00 00 00 0f 1f 40 00 48 89 f8 48 89 f7 48 89 d6 48 89 ca 4d 89 c2 4d 89 c8 4c 8b 4c 24 08 0f 05 <48> 3d 01 f0 ff ff 73 01 c3 48 c7 c1 bc ff ff ff f7 d8 64 89 01 48
RSP: 002b:00007ffb56aa0218 EFLAGS: 00000246 ORIG_RAX: 00000000000000ca
RAX: 0000000000000000 RBX: 000000000056bf68 RCX: 0000000000465ef9
RDX: 0000000000000000 RSI: 0000000000000080 RDI: 000000000056bf68
RBP: 000000000056bf60 R08: 0000000000000000 R09: 0000000000000000
R10: 0000000000000000 R11: 0000000000000246 R12: 000000000056bf6c
R13: 00007fff198147ff R14: 00007ffb56aa0300 R15: 0000000000022000


---
This report is generated by a bot. It may contain errors.
See https://goo.gl/tpsmEJ for more information about syzbot.
syzbot engineers can be reached at syzkaller@googlegroups.com.

syzbot will keep track of this issue. See:
https://goo.gl/tpsmEJ#status for how to communicate with syzbot.
