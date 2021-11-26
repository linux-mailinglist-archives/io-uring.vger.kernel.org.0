Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 58E3345EA65
	for <lists+io-uring@lfdr.de>; Fri, 26 Nov 2021 10:29:24 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1376257AbhKZJcf (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Fri, 26 Nov 2021 04:32:35 -0500
Received: from mail-io1-f72.google.com ([209.85.166.72]:47620 "EHLO
        mail-io1-f72.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1376285AbhKZJaf (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Fri, 26 Nov 2021 04:30:35 -0500
Received: by mail-io1-f72.google.com with SMTP id o11-20020a0566022e0b00b005e95edf792dso11069684iow.14
        for <io-uring@vger.kernel.org>; Fri, 26 Nov 2021 01:27:22 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:mime-version:date:message-id:subject:from:to;
        bh=N71cJlytOgcSxEIn7CE/b4V2ySpqseceX41HD1MK7pc=;
        b=TWfX22Un3P8gGsmdaiOpxEQm611Qf5QBItdTdEIJ5Iwo3d39cJw8UTSDRUySSNJ+tT
         9xWqPIKVjoQnH9YEg1PKRA5Nbc82JJeZOL65FqigEoATCN5J+jsEul5kyhu8TPEZES0y
         fxa38MWfo3v1wwjuCFlFswyoyrzVW7yRnurecbRnqiT26sW6JjcSRG1nIZpOne5oepsK
         FaYTp3aaIAUtIuwBvA/xT2OroDbF3uTWUsbEqtaUOVk5c+1ebtB0csSqnzGPeFnkdcAG
         QI8OpIEWAMWBQp/+g6OcsWY2YO0bWlqGzr/H0Iii/KpIJXBh9bLHugYK0tXCoBI5waKL
         jt5A==
X-Gm-Message-State: AOAM53323mTDBVjl8pt8/MqdHvOs4RC/x5rjpMw3vuIXTSGCgadwIFIu
        HyiJ26raRdD+YipILKkTIjC8pmQR4fi3IusXjeE6timPigvf
X-Google-Smtp-Source: ABdhPJwkpo78hgD3Ll1lo5UZTdmWyF20HzU7DuQ3dADTQPrOIM7DwiWf/dC+RrlXkk/t4N/W+sFJdUJ6A5I9cGaBvJ9GN2tkUo02
MIME-Version: 1.0
X-Received: by 2002:a05:6638:2178:: with SMTP id p24mr39098243jak.142.1637918842532;
 Fri, 26 Nov 2021 01:27:22 -0800 (PST)
Date:   Fri, 26 Nov 2021 01:27:22 -0800
X-Google-Appengine-App-Id: s~syzkaller
X-Google-Appengine-App-Id-Alias: syzkaller
Message-ID: <000000000000c7ba4b05d1adb200@google.com>
Subject: [syzbot] inconsistent lock state in io_poll_remove_all
From:   syzbot <syzbot+51ce8887cdef77c9ac83@syzkaller.appspotmail.com>
To:     asml.silence@gmail.com, axboe@kernel.dk, io-uring@vger.kernel.org,
        linux-kernel@vger.kernel.org, syzkaller-bugs@googlegroups.com
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org

Hello,

syzbot found the following issue on:

HEAD commit:    a4849f6000e2 Merge tag 'drm-fixes-2021-11-26' of git://ano..
git tree:       upstream
console output: https://syzkaller.appspot.com/x/log.txt?x=11162e9ab00000
kernel config:  https://syzkaller.appspot.com/x/.config?x=bf85c53718a1e697
dashboard link: https://syzkaller.appspot.com/bug?extid=51ce8887cdef77c9ac83
compiler:       gcc (Debian 10.2.1-6) 10.2.1 20210110, GNU ld (GNU Binutils for Debian) 2.35.2

Unfortunately, I don't have any reproducer for this issue yet.

IMPORTANT: if you fix the issue, please add the following tag to the commit:
Reported-by: syzbot+51ce8887cdef77c9ac83@syzkaller.appspotmail.com

================================
WARNING: inconsistent lock state
5.16.0-rc2-syzkaller #0 Not tainted
--------------------------------
inconsistent {IN-HARDIRQ-W} -> {HARDIRQ-ON-W} usage.
syz-executor.1/11092 [HC0[0]:SC0[0]:HE0:SE1] takes:
ffff88801b935418 (&ctx->timeout_lock){?.-.}-{2:2}, at: spin_lock_irq include/linux/spinlock.h:374 [inline]
ffff88801b935418 (&ctx->timeout_lock){?.-.}-{2:2}, at: io_poll_remove_all+0x50/0x235 fs/io_uring.c:5702
{IN-HARDIRQ-W} state was registered at:
  lock_acquire kernel/locking/lockdep.c:5637 [inline]
  lock_acquire+0x1ab/0x510 kernel/locking/lockdep.c:5602
  __raw_spin_lock_irqsave include/linux/spinlock_api_smp.h:110 [inline]
  _raw_spin_lock_irqsave+0x39/0x50 kernel/locking/spinlock.c:162
  io_timeout_fn+0x6f/0x360 fs/io_uring.c:5943
  __run_hrtimer kernel/time/hrtimer.c:1685 [inline]
  __hrtimer_run_queues+0x609/0xe50 kernel/time/hrtimer.c:1749
  hrtimer_interrupt+0x31c/0x790 kernel/time/hrtimer.c:1811
  local_apic_timer_interrupt arch/x86/kernel/apic/apic.c:1086 [inline]
  __sysvec_apic_timer_interrupt+0x146/0x530 arch/x86/kernel/apic/apic.c:1103
  sysvec_apic_timer_interrupt+0x40/0xc0 arch/x86/kernel/apic/apic.c:1097
  asm_sysvec_apic_timer_interrupt+0x12/0x20 arch/x86/include/asm/idtentry.h:638
irq event stamp: 11828
hardirqs last  enabled at (11827): [<ffffffff8946c35f>] __raw_spin_unlock_irq include/linux/spinlock_api_smp.h:159 [inline]
hardirqs last  enabled at (11827): [<ffffffff8946c35f>] _raw_spin_unlock_irq+0x1f/0x40 kernel/locking/spinlock.c:202
hardirqs last disabled at (11828): [<ffffffff8946c131>] __raw_spin_lock_irq include/linux/spinlock_api_smp.h:117 [inline]
hardirqs last disabled at (11828): [<ffffffff8946c131>] _raw_spin_lock_irq+0x41/0x50 kernel/locking/spinlock.c:170
softirqs last  enabled at (11674): [<ffffffff87dfd0bc>] read_pnet include/net/net_namespace.h:327 [inline]
softirqs last  enabled at (11674): [<ffffffff87dfd0bc>] sock_net include/net/sock.h:2658 [inline]
softirqs last  enabled at (11674): [<ffffffff87dfd0bc>] unix_create1+0x47c/0x5c0 net/unix/af_unix.c:893
softirqs last disabled at (11672): [<ffffffff87dfd039>] unix_sockets_unbound net/unix/af_unix.c:134 [inline]
softirqs last disabled at (11672): [<ffffffff87dfd039>] unix_create1+0x3f9/0x5c0 net/unix/af_unix.c:890

other info that might help us debug this:
 Possible unsafe locking scenario:

       CPU0
       ----
  lock(&ctx->timeout_lock);
  <Interrupt>
    lock(&ctx->timeout_lock);

 *** DEADLOCK ***

2 locks held by syz-executor.1/11092:
 #0: ffff88801b9353d8 (&ctx->completion_lock){+.+.}-{2:2}, at: spin_lock include/linux/spinlock.h:349 [inline]
 #0: ffff88801b9353d8 (&ctx->completion_lock){+.+.}-{2:2}, at: io_poll_remove_all+0x48/0x235 fs/io_uring.c:5701
 #1: ffff88801b935418 (&ctx->timeout_lock){?.-.}-{2:2}, at: spin_lock_irq include/linux/spinlock.h:374 [inline]
 #1: ffff88801b935418 (&ctx->timeout_lock){?.-.}-{2:2}, at: io_poll_remove_all+0x50/0x235 fs/io_uring.c:5702

stack backtrace:
CPU: 1 PID: 11092 Comm: syz-executor.1 Not tainted 5.16.0-rc2-syzkaller #0
Hardware name: QEMU Standard PC (Q35 + ICH9, 2009), BIOS 1.14.0-2 04/01/2014
Call Trace:
 <TASK>
 __dump_stack lib/dump_stack.c:88 [inline]
 dump_stack_lvl+0xcd/0x134 lib/dump_stack.c:106
 print_usage_bug kernel/locking/lockdep.c:203 [inline]
 valid_state kernel/locking/lockdep.c:3945 [inline]
 mark_lock_irq kernel/locking/lockdep.c:4148 [inline]
 mark_lock.cold+0x61/0x8e kernel/locking/lockdep.c:4605
 mark_held_locks+0x9f/0xe0 kernel/locking/lockdep.c:4206
 __trace_hardirqs_on_caller kernel/locking/lockdep.c:4224 [inline]
 lockdep_hardirqs_on_prepare kernel/locking/lockdep.c:4292 [inline]
 lockdep_hardirqs_on_prepare+0x135/0x400 kernel/locking/lockdep.c:4244
 trace_hardirqs_on+0x5b/0x1c0 kernel/trace/trace_preemptirq.c:49
 __raw_spin_unlock_irq include/linux/spinlock_api_smp.h:159 [inline]
 _raw_spin_unlock_irq+0x1f/0x40 kernel/locking/spinlock.c:202
 spin_unlock_irq include/linux/spinlock.h:399 [inline]
 __io_poll_remove_one fs/io_uring.c:5669 [inline]
 __io_poll_remove_one fs/io_uring.c:5654 [inline]
 io_poll_remove_one+0x236/0x870 fs/io_uring.c:5680
 io_poll_remove_all+0x1af/0x235 fs/io_uring.c:5709
 io_uring_try_cancel_requests+0x66d/0x717 fs/io_uring.c:9668
 io_uring_cancel_generic+0x3b8/0x690 fs/io_uring.c:9833
 io_uring_files_cancel include/linux/io_uring.h:16 [inline]
 do_exit+0x60c/0x2b40 kernel/exit.c:787
 do_group_exit+0x125/0x310 kernel/exit.c:929
 get_signal+0x47d/0x2220 kernel/signal.c:2852
 arch_do_signal_or_restart+0x2a9/0x1c40 arch/x86/kernel/signal.c:868
 handle_signal_work kernel/entry/common.c:148 [inline]
 exit_to_user_mode_loop kernel/entry/common.c:172 [inline]
 exit_to_user_mode_prepare+0x17d/0x290 kernel/entry/common.c:207
 __syscall_exit_to_user_mode_work kernel/entry/common.c:289 [inline]
 syscall_exit_to_user_mode+0x19/0x60 kernel/entry/common.c:300
 do_syscall_64+0x42/0xb0 arch/x86/entry/common.c:86
 entry_SYSCALL_64_after_hwframe+0x44/0xae
RIP: 0033:0x7fbfcc7f1ae9
Code: ff ff c3 66 2e 0f 1f 84 00 00 00 00 00 0f 1f 40 00 48 89 f8 48 89 f7 48 89 d6 48 89 ca 4d 89 c2 4d 89 c8 4c 8b 4c 24 08 0f 05 <48> 3d 01 f0 ff ff 73 01 c3 48 c7 c1 bc ff ff ff f7 d8 64 89 01 48
RSP: 002b:00007fbfc9d67218 EFLAGS: 00000246 ORIG_RAX: 00000000000000ca
RAX: 0000000000000000 RBX: 00007fbfcc904f68 RCX: 00007fbfcc7f1ae9
RDX: 0000000000000000 RSI: 0000000000000080 RDI: 00007fbfcc904f68
RBP: 00007fbfcc904f60 R08: 0000000000000000 R09: 0000000000000000
R10: 0000000000000000 R11: 0000000000000246 R12: 00007fbfcc904f6c
R13: 00007ffd26cc528f R14: 00007fbfc9d67300 R15: 0000000000022000
 </TASK>


---
This report is generated by a bot. It may contain errors.
See https://goo.gl/tpsmEJ for more information about syzbot.
syzbot engineers can be reached at syzkaller@googlegroups.com.

syzbot will keep track of this issue. See:
https://goo.gl/tpsmEJ#status for how to communicate with syzbot.
