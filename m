Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id C22FF2E8153
	for <lists+io-uring@lfdr.de>; Thu, 31 Dec 2020 18:00:22 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726673AbgLaQ7z (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Thu, 31 Dec 2020 11:59:55 -0500
Received: from mail-il1-f198.google.com ([209.85.166.198]:40726 "EHLO
        mail-il1-f198.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726618AbgLaQ7z (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Thu, 31 Dec 2020 11:59:55 -0500
Received: by mail-il1-f198.google.com with SMTP id g1so18187596ilq.7
        for <io-uring@vger.kernel.org>; Thu, 31 Dec 2020 08:59:38 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:date:message-id:subject:from:to;
        bh=SiP37H8yUWGLxjUs9NunW4dHNFyuQM7FcCahZb/ksQo=;
        b=p9kF+nyQpXufUXwmd65XUtaeewnwG4t4uYIDOr96VELwqnr/qjZB7RPKgOVlvhbASV
         EZ5qCgZ5rEoSanM+r45yZm67fADQzSptF2CmCvDl7fMgK8JlipqVn7eqRYMJHpK1KXul
         674CbgZvvx3PuQFrEkXbrMHv60I81eSZZYEenqd9XFYpbYUmOGbQlBsgvKeEvgZ+6m9N
         yA6zsxeHU6nr/BjKQZRbu13KzZMwIG6N4j1DvRLk7+bI3CjnApGqt7UBagRPP5IJqLlv
         i85yKy9KNxmN4gfJHQXhqhoR32zTs9YkulcxcEShY3Zq2izZklUOnwQKCZ2dQ2sH5Es0
         /05Q==
X-Gm-Message-State: AOAM530cryM1H6v2xMpTaAL/YmDQFhEVjEOpO2AXMn240WMdkRPkSjkP
        sBKzXp+vjm/RpxBRRZItTiFuxLlIlozlnMUTkR2lGznqfFn7
X-Google-Smtp-Source: ABdhPJwmy8SSnnWhWo110T8onR8DuaNy2xyuV2xzIpLqUTxHR5ch9zIpo0f63uzPHN5Xq+6Ti/MxA+dEMWV4AaZTSKDR/u5Db/YH
MIME-Version: 1.0
X-Received: by 2002:a05:6e02:104b:: with SMTP id p11mr57981121ilj.241.1609433953168;
 Thu, 31 Dec 2020 08:59:13 -0800 (PST)
Date:   Thu, 31 Dec 2020 08:59:13 -0800
X-Google-Appengine-App-Id: s~syzkaller
X-Google-Appengine-App-Id-Alias: syzkaller
Message-ID: <00000000000011737305b7c58b07@google.com>
Subject: possible deadlock in io_timeout_fn (2)
From:   syzbot <syzbot+91ca3f25bd7f795f019c@syzkaller.appspotmail.com>
To:     axboe@kernel.dk, io-uring@vger.kernel.org,
        linux-fsdevel@vger.kernel.org, linux-kernel@vger.kernel.org,
        syzkaller-bugs@googlegroups.com, viro@zeniv.linux.org.uk
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org

Hello,

syzbot found the following issue on:

HEAD commit:    f6e1ea19 Merge tag 'ceph-for-5.11-rc2' of git://github.com..
git tree:       upstream
console output: https://syzkaller.appspot.com/x/log.txt?x=108227df500000
kernel config:  https://syzkaller.appspot.com/x/.config?x=725326c654c08da7
dashboard link: https://syzkaller.appspot.com/bug?extid=91ca3f25bd7f795f019c
compiler:       gcc (GCC) 10.1.0-syz 20200507

Unfortunately, I don't have any reproducer for this issue yet.

IMPORTANT: if you fix the issue, please add the following tag to the commit:
Reported-by: syzbot+91ca3f25bd7f795f019c@syzkaller.appspotmail.com

========================================================
WARNING: possible irq lock inversion dependency detected
5.11.0-rc1-syzkaller #0 Not tainted
--------------------------------------------------------
syz-executor.4/15599 just changed the state of lock:
ffff888011ba2498 (&ctx->completion_lock){-...}-{2:2}, at: io_timeout_fn+0x6f/0x3d0 fs/io_uring.c:5619
but this lock took another, HARDIRQ-READ-unsafe lock in the past:
 (&new->fa_lock){.+.+}-{2:2}


and interrupts could create inverse lock ordering between them.


other info that might help us debug this:
 Possible interrupt unsafe locking scenario:

       CPU0                    CPU1
       ----                    ----
  lock(&new->fa_lock);
                               local_irq_disable();
                               lock(&ctx->completion_lock);
                               lock(&new->fa_lock);
  <Interrupt>
    lock(&ctx->completion_lock);

 *** DEADLOCK ***

2 locks held by syz-executor.4/15599:
 #0: ffffffff8c948be8 (rtnl_mutex){+.+.}-{3:3}, at: rtnl_lock net/core/rtnetlink.c:72 [inline]
 #0: ffffffff8c948be8 (rtnl_mutex){+.+.}-{3:3}, at: rtnetlink_rcv_msg+0x3f9/0xad0 net/core/rtnetlink.c:5561
 #1: ffffffff8cabf298
 (addrconf_hash_lock){+...}-{2:2}, at: spin_lock_bh include/linux/spinlock.h:359 [inline]
 (addrconf_hash_lock){+...}-{2:2}, at: addrconf_ifdown.isra.0+0x2b6/0x1590 net/ipv6/addrconf.c:3741

the shortest dependencies between 2nd lock and 1st lock:
 -> (
&new->fa_lock){.+.+}-{2:2} {
    HARDIRQ-ON-R at:
                      lock_acquire kernel/locking/lockdep.c:5437 [inline]
                      lock_acquire+0x29d/0x740 kernel/locking/lockdep.c:5402
                      __raw_read_lock include/linux/rwlock_api_smp.h:149 [inline]
                      _raw_read_lock+0x5b/0x70 kernel/locking/spinlock.c:223
                      kill_fasync_rcu fs/fcntl.c:1004 [inline]
                      kill_fasync fs/fcntl.c:1025 [inline]
                      kill_fasync+0x14b/0x460 fs/fcntl.c:1018
                      sock_wake_async+0xd2/0x160 net/socket.c:1310
                      sk_wake_async include/net/sock.h:2279 [inline]
                      sk_wake_async include/net/sock.h:2275 [inline]
                      af_alg_data_wakeup.part.0+0x2cb/0x4c0 crypto/af_alg.c:810
                      af_alg_data_wakeup include/crypto/if_alg.h:187 [inline]
                      af_alg_sendmsg+0xf24/0x1400 crypto/af_alg.c:971
                      sock_sendmsg_nosec net/socket.c:652 [inline]
                      sock_sendmsg+0xcf/0x120 net/socket.c:672
                      ____sys_sendmsg+0x6e8/0x810 net/socket.c:2345
                      ___sys_sendmsg+0xf3/0x170 net/socket.c:2399
                      __sys_sendmsg+0xe5/0x1b0 net/socket.c:2432
                      do_syscall_64+0x2d/0x70 arch/x86/entry/common.c:46
                      entry_SYSCALL_64_after_hwframe+0x44/0xa9
    SOFTIRQ-ON-R at:
                      lock_acquire kernel/locking/lockdep.c:5437 [inline]
                      lock_acquire+0x29d/0x740 kernel/locking/lockdep.c:5402
                      __raw_read_lock include/linux/rwlock_api_smp.h:149 [inline]
                      _raw_read_lock+0x5b/0x70 kernel/locking/spinlock.c:223
                      kill_fasync_rcu fs/fcntl.c:1004 [inline]
                      kill_fasync fs/fcntl.c:1025 [inline]
                      kill_fasync+0x14b/0x460 fs/fcntl.c:1018
                      sock_wake_async+0xd2/0x160 net/socket.c:1310
                      sk_wake_async include/net/sock.h:2279 [inline]
                      sk_wake_async include/net/sock.h:2275 [inline]
                      af_alg_data_wakeup.part.0+0x2cb/0x4c0 crypto/af_alg.c:810
                      af_alg_data_wakeup include/crypto/if_alg.h:187 [inline]
                      af_alg_sendmsg+0xf24/0x1400 crypto/af_alg.c:971
                      sock_sendmsg_nosec net/socket.c:652 [inline]
                      sock_sendmsg+0xcf/0x120 net/socket.c:672
                      ____sys_sendmsg+0x6e8/0x810 net/socket.c:2345
                      ___sys_sendmsg+0xf3/0x170 net/socket.c:2399
                      __sys_sendmsg+0xe5/0x1b0 net/socket.c:2432
                      do_syscall_64+0x2d/0x70 arch/x86/entry/common.c:46
                      entry_SYSCALL_64_after_hwframe+0x44/0xa9
    INITIAL USE at:
                     lock_acquire kernel/locking/lockdep.c:5437 [inline]
                     lock_acquire+0x29d/0x740 kernel/locking/lockdep.c:5402
                     __raw_write_lock_irq include/linux/rwlock_api_smp.h:196 [inline]
                     _raw_write_lock_irq+0x32/0x50 kernel/locking/spinlock.c:311
                     fasync_remove_entry+0xb6/0x1f0 fs/fcntl.c:882
                     fasync_helper+0x9e/0xb0 fs/fcntl.c:985
                     sock_fasync+0x94/0x140 net/socket.c:1281
                     __fput+0x70d/0x920 fs/file_table.c:277
                     task_work_run+0xdd/0x190 kernel/task_work.c:140
                     exit_task_work include/linux/task_work.h:30 [inline]
                     do_exit+0xb89/0x29e0 kernel/exit.c:823
                     do_group_exit+0x125/0x310 kernel/exit.c:920
                     get_signal+0x3ec/0x2010 kernel/signal.c:2770
                     arch_do_signal_or_restart+0x2a8/0x1eb0 arch/x86/kernel/signal.c:811
                     handle_signal_work kernel/entry/common.c:147 [inline]
                     exit_to_user_mode_loop kernel/entry/common.c:171 [inline]
                     exit_to_user_mode_prepare+0x148/0x250 kernel/entry/common.c:201
                     __syscall_exit_to_user_mode_work kernel/entry/common.c:291 [inline]
                     syscall_exit_to_user_mode+0x19/0x50 kernel/entry/common.c:302
                     entry_SYSCALL_64_after_hwframe+0x44/0xa9
    INITIAL READ USE at:
                          lock_acquire kernel/locking/lockdep.c:5437 [inline]
                          lock_acquire+0x29d/0x740 kernel/locking/lockdep.c:5402
                          __raw_read_lock include/linux/rwlock_api_smp.h:149 [inline]
                          _raw_read_lock+0x5b/0x70 kernel/locking/spinlock.c:223
                          kill_fasync_rcu fs/fcntl.c:1004 [inline]
                          kill_fasync fs/fcntl.c:1025 [inline]
                          kill_fasync+0x14b/0x460 fs/fcntl.c:1018
                          sock_wake_async+0xd2/0x160 net/socket.c:1310
                          sk_wake_async include/net/sock.h:2279 [inline]
                          sk_wake_async include/net/sock.h:2275 [inline]
                          af_alg_data_wakeup.part.0+0x2cb/0x4c0 crypto/af_alg.c:810
                          af_alg_data_wakeup include/crypto/if_alg.h:187 [inline]
                          af_alg_sendmsg+0xf24/0x1400 crypto/af_alg.c:971
                          sock_sendmsg_nosec net/socket.c:652 [inline]
                          sock_sendmsg+0xcf/0x120 net/socket.c:672
                          ____sys_sendmsg+0x6e8/0x810 net/socket.c:2345
                          ___sys_sendmsg+0xf3/0x170 net/socket.c:2399
                          __sys_sendmsg+0xe5/0x1b0 net/socket.c:2432
                          do_syscall_64+0x2d/0x70 arch/x86/entry/common.c:46
                          entry_SYSCALL_64_after_hwframe+0x44/0xa9
  }
  ... key      at: [<ffffffff8ef9a960>] __key.0+0x0/0x40
  ... acquired at:
   __raw_read_lock include/linux/rwlock_api_smp.h:149 [inline]
   _raw_read_lock+0x5b/0x70 kernel/locking/spinlock.c:223
   kill_fasync_rcu fs/fcntl.c:1004 [inline]
   kill_fasync fs/fcntl.c:1025 [inline]
   kill_fasync+0x14b/0x460 fs/fcntl.c:1018
   __io_commit_cqring fs/io_uring.c:1344 [inline]
   io_commit_cqring+0x34e/0xa90 fs/io_uring.c:1654
   io_submit_flush_completions+0x269/0x3a0 fs/io_uring.c:1851
   __io_req_complete+0x209/0x310 fs/io_uring.c:1870
   io_nop fs/io_uring.c:3893 [inline]
   io_issue_sqe+0x1234/0x4490 fs/io_uring.c:6180
   __io_queue_sqe+0x228/0x10c0 fs/io_uring.c:6484
   io_queue_sqe+0x631/0x10d0 fs/io_uring.c:6550
   io_submit_sqe fs/io_uring.c:6623 [inline]
   io_submit_sqes+0x1495/0x2720 fs/io_uring.c:6871
   __do_sys_io_uring_enter+0x6d1/0x1e70 fs/io_uring.c:9192
   do_syscall_64+0x2d/0x70 arch/x86/entry/common.c:46
   entry_SYSCALL_64_after_hwframe+0x44/0xa9

-> (
&ctx->completion_lock){-...}-{2:2} {
   IN-HARDIRQ-W at:
                    lock_acquire kernel/locking/lockdep.c:5437 [inline]
                    lock_acquire+0x29d/0x740 kernel/locking/lockdep.c:5402
                    __raw_spin_lock_irqsave include/linux/spinlock_api_smp.h:110 [inline]
                    _raw_spin_lock_irqsave+0x39/0x50 kernel/locking/spinlock.c:159
                    io_timeout_fn+0x6f/0x3d0 fs/io_uring.c:5619
                    __run_hrtimer kernel/time/hrtimer.c:1519 [inline]
                    __hrtimer_run_queues+0x693/0xea0 kernel/time/hrtimer.c:1583
                    hrtimer_interrupt+0x334/0x940 kernel/time/hrtimer.c:1645
                    local_apic_timer_interrupt arch/x86/kernel/apic/apic.c:1085 [inline]
                    __sysvec_apic_timer_interrupt+0x146/0x540 arch/x86/kernel/apic/apic.c:1102
                    asm_call_irq_on_stack+0xf/0x20
                    __run_sysvec_on_irqstack arch/x86/include/asm/irq_stack.h:37 [inline]
                    run_sysvec_on_irqstack_cond arch/x86/include/asm/irq_stack.h:89 [inline]
                    sysvec_apic_timer_interrupt+0xbd/0x100 arch/x86/kernel/apic/apic.c:1096
                    asm_sysvec_apic_timer_interrupt+0x12/0x20 arch/x86/include/asm/idtentry.h:628
                    addrconf_ifdown.isra.0+0x2f5/0x1590 net/ipv6/addrconf.c:3743
                    addrconf_notify+0x55c/0x23f0 net/ipv6/addrconf.c:3628
                    notifier_call_chain+0xb5/0x200 kernel/notifier.c:83
                    call_netdevice_notifiers_info+0xb5/0x130 net/core/dev.c:2040
                    call_netdevice_notifiers_extack net/core/dev.c:2052 [inline]
                    call_netdevice_notifiers net/core/dev.c:2066 [inline]
                    __dev_notify_flags+0x1da/0x2b0 net/core/dev.c:8518
                    dev_change_flags+0x100/0x160 net/core/dev.c:8554
                    do_setlink+0x891/0x3a70 net/core/rtnetlink.c:2708
                    rtnl_group_changelink net/core/rtnetlink.c:3227 [inline]
                    __rtnl_newlink+0xde5/0x1750 net/core/rtnetlink.c:3381
                    rtnl_newlink+0x64/0xa0 net/core/rtnetlink.c:3502
                    rtnetlink_rcv_msg+0x44e/0xad0 net/core/rtnetlink.c:5564
                    netlink_rcv_skb+0x153/0x420 net/netlink/af_netlink.c:2494
                    netlink_unicast_kernel net/netlink/af_netlink.c:1304 [inline]
                    netlink_unicast+0x533/0x7d0 net/netlink/af_netlink.c:1330
                    netlink_sendmsg+0x856/0xd90 net/netlink/af_netlink.c:1919
                    sock_sendmsg_nosec net/socket.c:652 [inline]
                    sock_sendmsg+0xcf/0x120 net/socket.c:672
                    ____sys_sendmsg+0x6e8/0x810 net/socket.c:2345
                    ___sys_sendmsg+0xf3/0x170 net/socket.c:2399
                    __sys_sendmsg+0xe5/0x1b0 net/socket.c:2432
                    do_syscall_64+0x2d/0x70 arch/x86/entry/common.c:46
                    entry_SYSCALL_64_after_hwframe+0x44/0xa9
   INITIAL USE
 at:
                   lock_acquire kernel/locking/lockdep.c:5437 [inline]
                   lock_acquire+0x29d/0x740 kernel/locking/lockdep.c:5402
                   __raw_spin_lock_irq include/linux/spinlock_api_smp.h:128 [inline]
                   _raw_spin_lock_irq+0x32/0x50 kernel/locking/spinlock.c:167
                   spin_lock_irq include/linux/spinlock.h:379 [inline]
                   io_cancel_defer_files fs/io_uring.c:8735 [inline]
                   io_uring_cancel_task_requests fs/io_uring.c:8836 [inline]
                   __io_uring_files_cancel+0x2f0/0x14f0 fs/io_uring.c:8941
                   io_uring_files_cancel include/linux/io_uring.h:51 [inline]
                   exit_files+0xe4/0x170 fs/file.c:431
                   do_exit+0xb4f/0x29e0 kernel/exit.c:818
                   do_group_exit+0x125/0x310 kernel/exit.c:920
                   get_signal+0x3ec/0x2010 kernel/signal.c:2770
                   arch_do_signal_or_restart+0x2a8/0x1eb0 arch/x86/kernel/signal.c:811
                   handle_signal_work kernel/entry/common.c:147 [inline]
                   exit_to_user_mode_loop kernel/entry/common.c:171 [inline]
                   exit_to_user_mode_prepare+0x148/0x250 kernel/entry/common.c:201
                   __syscall_exit_to_user_mode_work kernel/entry/common.c:291 [inline]
                   syscall_exit_to_user_mode+0x19/0x50 kernel/entry/common.c:302
                   entry_SYSCALL_64_after_hwframe+0x44/0xa9
 }
 ... key      at: [<ffffffff8ef9ea40>] __key.10+0x0/0x40
 ... acquired at:
   mark_usage kernel/locking/lockdep.c:4303 [inline]
   __lock_acquire+0x1459/0x5500 kernel/locking/lockdep.c:4786
   lock_acquire kernel/locking/lockdep.c:5437 [inline]
   lock_acquire+0x29d/0x740 kernel/locking/lockdep.c:5402
   __raw_spin_lock_irqsave include/linux/spinlock_api_smp.h:110 [inline]
   _raw_spin_lock_irqsave+0x39/0x50 kernel/locking/spinlock.c:159
   io_timeout_fn+0x6f/0x3d0 fs/io_uring.c:5619
   __run_hrtimer kernel/time/hrtimer.c:1519 [inline]
   __hrtimer_run_queues+0x693/0xea0 kernel/time/hrtimer.c:1583
   hrtimer_interrupt+0x334/0x940 kernel/time/hrtimer.c:1645
   local_apic_timer_interrupt arch/x86/kernel/apic/apic.c:1085 [inline]
   __sysvec_apic_timer_interrupt+0x146/0x540 arch/x86/kernel/apic/apic.c:1102
   asm_call_irq_on_stack+0xf/0x20
   __run_sysvec_on_irqstack arch/x86/include/asm/irq_stack.h:37 [inline]
   run_sysvec_on_irqstack_cond arch/x86/include/asm/irq_stack.h:89 [inline]
   sysvec_apic_timer_interrupt+0xbd/0x100 arch/x86/kernel/apic/apic.c:1096
   asm_sysvec_apic_timer_interrupt+0x12/0x20 arch/x86/include/asm/idtentry.h:628
   addrconf_ifdown.isra.0+0x2f5/0x1590 net/ipv6/addrconf.c:3743
   addrconf_notify+0x55c/0x23f0 net/ipv6/addrconf.c:3628
   notifier_call_chain+0xb5/0x200 kernel/notifier.c:83
   call_netdevice_notifiers_info+0xb5/0x130 net/core/dev.c:2040
   call_netdevice_notifiers_extack net/core/dev.c:2052 [inline]
   call_netdevice_notifiers net/core/dev.c:2066 [inline]
   __dev_notify_flags+0x1da/0x2b0 net/core/dev.c:8518
   dev_change_flags+0x100/0x160 net/core/dev.c:8554
   do_setlink+0x891/0x3a70 net/core/rtnetlink.c:2708
   rtnl_group_changelink net/core/rtnetlink.c:3227 [inline]
   __rtnl_newlink+0xde5/0x1750 net/core/rtnetlink.c:3381
   rtnl_newlink+0x64/0xa0 net/core/rtnetlink.c:3502
   rtnetlink_rcv_msg+0x44e/0xad0 net/core/rtnetlink.c:5564
   netlink_rcv_skb+0x153/0x420 net/netlink/af_netlink.c:2494
   netlink_unicast_kernel net/netlink/af_netlink.c:1304 [inline]
   netlink_unicast+0x533/0x7d0 net/netlink/af_netlink.c:1330
   netlink_sendmsg+0x856/0xd90 net/netlink/af_netlink.c:1919
   sock_sendmsg_nosec net/socket.c:652 [inline]
   sock_sendmsg+0xcf/0x120 net/socket.c:672
   ____sys_sendmsg+0x6e8/0x810 net/socket.c:2345
   ___sys_sendmsg+0xf3/0x170 net/socket.c:2399
   __sys_sendmsg+0xe5/0x1b0 net/socket.c:2432
   do_syscall_64+0x2d/0x70 arch/x86/entry/common.c:46
   entry_SYSCALL_64_after_hwframe+0x44/0xa9


stack backtrace:
CPU: 1 PID: 15599 Comm: syz-executor.4 Not tainted 5.11.0-rc1-syzkaller #0
Hardware name: Google Google Compute Engine/Google Compute Engine, BIOS Google 01/01/2011
Call Trace:
 <IRQ>
 __dump_stack lib/dump_stack.c:79 [inline]
 dump_stack+0x107/0x163 lib/dump_stack.c:120
 print_irq_inversion_bug kernel/locking/lockdep.c:4413 [inline]
 check_usage_forwards kernel/locking/lockdep.c:3849 [inline]
 mark_lock_irq kernel/locking/lockdep.c:3981 [inline]
 mark_lock.cold+0x6e/0x73 kernel/locking/lockdep.c:4411
 mark_usage kernel/locking/lockdep.c:4303 [inline]
 __lock_acquire+0x1459/0x5500 kernel/locking/lockdep.c:4786
 lock_acquire kernel/locking/lockdep.c:5437 [inline]
 lock_acquire+0x29d/0x740 kernel/locking/lockdep.c:5402
 __raw_spin_lock_irqsave include/linux/spinlock_api_smp.h:110 [inline]
 _raw_spin_lock_irqsave+0x39/0x50 kernel/locking/spinlock.c:159
 io_timeout_fn+0x6f/0x3d0 fs/io_uring.c:5619
 __run_hrtimer kernel/time/hrtimer.c:1519 [inline]
 __hrtimer_run_queues+0x693/0xea0 kernel/time/hrtimer.c:1583
 hrtimer_interrupt+0x334/0x940 kernel/time/hrtimer.c:1645
 local_apic_timer_interrupt arch/x86/kernel/apic/apic.c:1085 [inline]
 __sysvec_apic_timer_interrupt+0x146/0x540 arch/x86/kernel/apic/apic.c:1102
 asm_call_irq_on_stack+0xf/0x20
 </IRQ>
 __run_sysvec_on_irqstack arch/x86/include/asm/irq_stack.h:37 [inline]
 run_sysvec_on_irqstack_cond arch/x86/include/asm/irq_stack.h:89 [inline]
 sysvec_apic_timer_interrupt+0xbd/0x100 arch/x86/kernel/apic/apic.c:1096
 asm_sysvec_apic_timer_interrupt+0x12/0x20 arch/x86/include/asm/idtentry.h:628
RIP: 0010:addrconf_ifdown.isra.0+0x2f5/0x1590 net/ipv6/addrconf.c:3743
Code: 08 e8 1f 39 cc f9 48 8b 44 24 08 80 38 00 0f 85 1d 10 00 00 48 8b 04 24 48 8b 1c c5 a0 52 af 8f 48 85 db 75 32 e9 ff 01 00 00 <e8> f6 38 cc f9 48 8d bb 48 01 00 00 48 89 f8 48 c1 e8 03 80 3c 28
RSP: 0018:ffffc900087f6b98 EFLAGS: 00000206
RAX: 1ffff1100398f327 RBX: ffff88801cc79800 RCX: ffffc9001169e000
RDX: 0000000000040000 RSI: ffffffff87a63e39 RDI: ffff88801cc79938
RBP: dffffc0000000000 R08: 0000000000000001 R09: 0000000000000003
R10: fffff520010fed65 R11: 0000000000000000 R12: 000000000000005a
R13: ffff888034c45d48 R14: ffff88801bf2a800 R15: 0000000000000000
 addrconf_notify+0x55c/0x23f0 net/ipv6/addrconf.c:3628
 notifier_call_chain+0xb5/0x200 kernel/notifier.c:83
 call_netdevice_notifiers_info+0xb5/0x130 net/core/dev.c:2040
 call_netdevice_notifiers_extack net/core/dev.c:2052 [inline]
 call_netdevice_notifiers net/core/dev.c:2066 [inline]
 __dev_notify_flags+0x1da/0x2b0 net/core/dev.c:8518
 dev_change_flags+0x100/0x160 net/core/dev.c:8554
 do_setlink+0x891/0x3a70 net/core/rtnetlink.c:2708
 rtnl_group_changelink net/core/rtnetlink.c:3227 [inline]
 __rtnl_newlink+0xde5/0x1750 net/core/rtnetlink.c:3381
 rtnl_newlink+0x64/0xa0 net/core/rtnetlink.c:3502
 rtnetlink_rcv_msg+0x44e/0xad0 net/core/rtnetlink.c:5564
 netlink_rcv_skb+0x153/0x420 net/netlink/af_netlink.c:2494
 netlink_unicast_kernel net/netlink/af_netlink.c:1304 [inline]
 netlink_unicast+0x533/0x7d0 net/netlink/af_netlink.c:1330
 netlink_sendmsg+0x856/0xd90 net/netlink/af_netlink.c:1919
 sock_sendmsg_nosec net/socket.c:652 [inline]
 sock_sendmsg+0xcf/0x120 net/socket.c:672
 ____sys_sendmsg+0x6e8/0x810 net/socket.c:2345
 ___sys_sendmsg+0xf3/0x170 net/socket.c:2399
 __sys_sendmsg+0xe5/0x1b0 net/socket.c:2432
 do_syscall_64+0x2d/0x70 arch/x86/entry/common.c:46
 entry_SYSCALL_64_after_hwframe+0x44/0xa9
RIP: 0033:0x45e219
Code: 0d b4 fb ff c3 66 2e 0f 1f 84 00 00 00 00 00 66 90 48 89 f8 48 89 f7 48 89 d6 48 89 ca 4d 89 c2 4d 89 c8 4c 8b 4c 24 08 0f 05 <48> 3d 01 f0 ff ff 0f 83 db b3 fb ff c3 66 2e 0f 1f 84 00 00 00 00
RSP: 002b:00007f2d76500c68 EFLAGS: 00000246 ORIG_RAX: 000000000000002e
RAX: ffffffffffffffda RBX: 0000000000000003 RCX: 000000000045e219
RDX: 0000000000000000 RSI: 0000000020000140 RDI: 0000000000000007
RBP: 000000000119bfc0 R08: 0000000000000000 R09: 0000000000000000
R10: 0000000000000000 R11: 0000000000000246 R12: 000000000119bf8c
R13: 00007ffc1160eedf R14: 00007f2d765019c0 R15: 000000000119bf8c


---
This report is generated by a bot. It may contain errors.
See https://goo.gl/tpsmEJ for more information about syzbot.
syzbot engineers can be reached at syzkaller@googlegroups.com.

syzbot will keep track of this issue. See:
https://goo.gl/tpsmEJ#status for how to communicate with syzbot.
