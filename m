Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 936E227BACF
	for <lists+io-uring@lfdr.de>; Tue, 29 Sep 2020 04:28:29 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727301AbgI2C2W (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Mon, 28 Sep 2020 22:28:22 -0400
Received: from mail-il1-f208.google.com ([209.85.166.208]:36148 "EHLO
        mail-il1-f208.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726396AbgI2C2U (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Mon, 28 Sep 2020 22:28:20 -0400
Received: by mail-il1-f208.google.com with SMTP id q11so2336892ilt.3
        for <io-uring@vger.kernel.org>; Mon, 28 Sep 2020 19:28:19 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:date:message-id:subject:from:to;
        bh=Kv6Md2UlAv+qsEgbPVjygV1Z8fU17byPB4v94bmo1SQ=;
        b=AWPJ15HxiqzqLTfdAWlD+55jjvtDBfTMOgyPjwcMF3OGImRbQi3bULhV9H4JLixZIV
         AFqyDUrr4+rQqzKQ3udwHmUs4zLmYRfuG41kBKX6Dq1VmM99/9SK/LSnp5OoF1URJiYh
         COM4smKfuKH/HhUA/8uGicVSFnYl2BJ8/3bF6KH38/KAOfOMIUR5CE+n6UaxRPvDRkRj
         dGp9OI1x4ATNunIP8AFu56F46kZ2IWagU4Y/rdZEGnIeN6jVcgoIfkxPsN7QNWavlYmN
         wcrXFuYPxQuUiWk+NB96x3HqXOwxrPLvIIrmBTFnbRHD/pN5UVgCKh7cWs+AUvaezyIs
         OWUA==
X-Gm-Message-State: AOAM5332gG+YfcZMsMSEM1DtuZwqYIXAVKDUmPTMO4dYSNAKOZRt9zr5
        29ie4DwHLilUbgurAMdOCuXzzcyudIeCuDNmFYV6MBS6jnFb
X-Google-Smtp-Source: ABdhPJxVACHIxMueFo4YAPNo1llEYKcwN7jWWIr62WgQxzu/voJiTzx4YJ9e9HESWgj0X470rGcvVnw0Zsm0q4DK5fa2ikKhgQ6f
MIME-Version: 1.0
X-Received: by 2002:a05:6638:220c:: with SMTP id l12mr1193102jas.139.1601346498705;
 Mon, 28 Sep 2020 19:28:18 -0700 (PDT)
Date:   Mon, 28 Sep 2020 19:28:18 -0700
X-Google-Appengine-App-Id: s~syzkaller
X-Google-Appengine-App-Id-Alias: syzkaller
Message-ID: <00000000000037bd5305b06a8988@google.com>
Subject: possible deadlock in io_poll_double_wake (2)
From:   syzbot <syzbot+28abd693db9e92c160d8@syzkaller.appspotmail.com>
To:     axboe@kernel.dk, io-uring@vger.kernel.org,
        linux-fsdevel@vger.kernel.org, linux-kernel@vger.kernel.org,
        syzkaller-bugs@googlegroups.com, viro@zeniv.linux.org.uk
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org

Hello,

syzbot found the following issue on:

HEAD commit:    d1d2220c Add linux-next specific files for 20200924
git tree:       linux-next
console output: https://syzkaller.appspot.com/x/log.txt?x=14cd5cd3900000
kernel config:  https://syzkaller.appspot.com/x/.config?x=254e028a642027c
dashboard link: https://syzkaller.appspot.com/bug?extid=28abd693db9e92c160d8
compiler:       gcc (GCC) 10.1.0-syz 20200507
syz repro:      https://syzkaller.appspot.com/x/repro.syz?x=13ba3881900000

IMPORTANT: if you fix the issue, please add the following tag to the commit:
Reported-by: syzbot+28abd693db9e92c160d8@syzkaller.appspotmail.com

============================================
WARNING: possible recursive locking detected
5.9.0-rc6-next-20200924-syzkaller #0 Not tainted
--------------------------------------------
kworker/0:1/12 is trying to acquire lock:
ffff88808d998130 (&runtime->sleep){..-.}-{2:2}, at: spin_lock include/linux/spinlock.h:354 [inline]
ffff88808d998130 (&runtime->sleep){..-.}-{2:2}, at: io_poll_double_wake+0x156/0x510 fs/io_uring.c:4855

but task is already holding lock:
ffff888093f4c130 (&runtime->sleep){..-.}-{2:2}, at: __wake_up_common_lock+0xb4/0x130 kernel/sched/wait.c:122

other info that might help us debug this:
 Possible unsafe locking scenario:

       CPU0
       ----
  lock(&runtime->sleep);
  lock(&runtime->sleep);

 *** DEADLOCK ***

 May be due to missing lock nesting notation

6 locks held by kworker/0:1/12:
 #0: ffff8880aa063d38 ((wq_completion)events){+.+.}-{0:0}, at: arch_atomic64_set arch/x86/include/asm/atomic64_64.h:34 [inline]
 #0: ffff8880aa063d38 ((wq_completion)events){+.+.}-{0:0}, at: atomic64_set include/asm-generic/atomic-instrumented.h:856 [inline]
 #0: ffff8880aa063d38 ((wq_completion)events){+.+.}-{0:0}, at: atomic_long_set include/asm-generic/atomic-long.h:41 [inline]
 #0: ffff8880aa063d38 ((wq_completion)events){+.+.}-{0:0}, at: set_work_data kernel/workqueue.c:616 [inline]
 #0: ffff8880aa063d38 ((wq_completion)events){+.+.}-{0:0}, at: set_work_pool_and_clear_pending kernel/workqueue.c:643 [inline]
 #0: ffff8880aa063d38 ((wq_completion)events){+.+.}-{0:0}, at: process_one_work+0x821/0x15a0 kernel/workqueue.c:2240
 #1: ffffc90000d2fda8 ((linkwatch_work).work){+.+.}-{0:0}, at: process_one_work+0x854/0x15a0 kernel/workqueue.c:2244
 #2: ffffffff8b6c5648 (rtnl_mutex){+.+.}-{3:3}, at: linkwatch_event+0xb/0x60 net/core/link_watch.c:250
 #3: ffffffff8a553d40 (rcu_read_lock){....}-{1:2}, at: ib_device_get_by_netdev+0x0/0x4f0 drivers/infiniband/core/device.c:2550
 #4: ffff888214d31908 (&group->lock){..-.}-{2:2}, at: _snd_pcm_stream_lock_irqsave+0x9f/0xd0 sound/core/pcm_native.c:170
 #5: ffff888093f4c130 (&runtime->sleep){..-.}-{2:2}, at: __wake_up_common_lock+0xb4/0x130 kernel/sched/wait.c:122

stack backtrace:
CPU: 0 PID: 12 Comm: kworker/0:1 Not tainted 5.9.0-rc6-next-20200924-syzkaller #0
Hardware name: Google Google Compute Engine/Google Compute Engine, BIOS Google 01/01/2011
Workqueue: events linkwatch_event
Call Trace:
 <IRQ>
 __dump_stack lib/dump_stack.c:77 [inline]
 dump_stack+0x198/0x1fb lib/dump_stack.c:118
 print_deadlock_bug kernel/locking/lockdep.c:2714 [inline]
 check_deadlock kernel/locking/lockdep.c:2755 [inline]
 validate_chain kernel/locking/lockdep.c:3546 [inline]
 __lock_acquire.cold+0x12e/0x3ad kernel/locking/lockdep.c:4796
 lock_acquire+0x1f2/0xaa0 kernel/locking/lockdep.c:5398
 __raw_spin_lock include/linux/spinlock_api_smp.h:142 [inline]
 _raw_spin_lock+0x2a/0x40 kernel/locking/spinlock.c:151
 spin_lock include/linux/spinlock.h:354 [inline]
 io_poll_double_wake+0x156/0x510 fs/io_uring.c:4855
 __wake_up_common+0x147/0x650 kernel/sched/wait.c:93
 __wake_up_common_lock+0xd0/0x130 kernel/sched/wait.c:123
 snd_pcm_update_state+0x46a/0x540 sound/core/pcm_lib.c:203
 snd_pcm_update_hw_ptr0+0xa71/0x1a50 sound/core/pcm_lib.c:464
 snd_pcm_period_elapsed+0x160/0x250 sound/core/pcm_lib.c:1805
 dummy_hrtimer_callback+0x94/0x1b0 sound/drivers/dummy.c:378
 __run_hrtimer kernel/time/hrtimer.c:1524 [inline]
 __hrtimer_run_queues+0x693/0xea0 kernel/time/hrtimer.c:1588
 hrtimer_run_softirq+0x17b/0x360 kernel/time/hrtimer.c:1605
 __do_softirq+0x203/0xab6 kernel/softirq.c:298
 asm_call_on_stack+0xf/0x20 arch/x86/entry/entry_64.S:786
 </IRQ>
 __run_on_irqstack arch/x86/include/asm/irq_stack.h:22 [inline]
 run_on_irqstack_cond arch/x86/include/asm/irq_stack.h:48 [inline]
 do_softirq_own_stack+0x9d/0xd0 arch/x86/kernel/irq_64.c:77
 invoke_softirq kernel/softirq.c:393 [inline]
 __irq_exit_rcu kernel/softirq.c:423 [inline]
 irq_exit_rcu+0x235/0x280 kernel/softirq.c:435
 sysvec_apic_timer_interrupt+0x51/0xf0 arch/x86/kernel/apic/apic.c:1091
 asm_sysvec_apic_timer_interrupt+0x12/0x20 arch/x86/include/asm/idtentry.h:631
RIP: 0010:arch_local_irq_restore arch/x86/include/asm/paravirt.h:653 [inline]
RIP: 0010:lock_acquire+0x27b/0xaa0 kernel/locking/lockdep.c:5401
Code: 00 00 00 00 00 fc ff df 48 c1 e8 03 80 3c 10 00 0f 85 d2 06 00 00 48 83 3d 89 bc e1 08 00 0f 84 2d 05 00 00 48 8b 3c 24 57 9d <0f> 1f 44 00 00 48 b8 00 00 00 00 00 fc ff df 48 01 c3 48 c7 03 00
RSP: 0018:ffffc90000d2f8c8 EFLAGS: 00000282
RAX: 1ffffffff1479e35 RBX: 1ffff920001a5f1c RCX: 00000000f1571e19
RDX: dffffc0000000000 RSI: 0000000000000001 RDI: 0000000000000282
RBP: ffff8880a969a300 R08: 0000000000000000 R09: ffffffff8d71a9e7
R10: fffffbfff1ae353c R11: 0000000000000000 R12: 0000000000000002
R13: 0000000000000000 R14: ffffffff8a553d40 R15: 0000000000000000
 rcu_lock_acquire include/linux/rcupdate.h:253 [inline]
 rcu_read_lock include/linux/rcupdate.h:642 [inline]
 ib_device_get_by_netdev+0x9a/0x4f0 drivers/infiniband/core/device.c:2248
 rxe_get_dev_from_net drivers/infiniband/sw/rxe/rxe.h:76 [inline]
 rxe_notify+0x8b/0x1c0 drivers/infiniband/sw/rxe/rxe_net.c:566
 notifier_call_chain+0xb5/0x200 kernel/notifier.c:83
 call_netdevice_notifiers_info+0xb5/0x130 net/core/dev.c:2034
 netdev_state_change net/core/dev.c:1464 [inline]
 netdev_state_change+0x100/0x130 net/core/dev.c:1457
 linkwatch_do_dev+0x13f/0x180 net/core/link_watch.c:167
 __linkwatch_run_queue+0x1ea/0x630 net/core/link_watch.c:212
 linkwatch_event+0x4a/0x60 net/core/link_watch.c:251
 process_one_work+0x933/0x15a0 kernel/workqueue.c:2269
 worker_thread+0x64c/0x1120 kernel/workqueue.c:2415
 kthread+0x3af/0x4a0 kernel/kthread.c:292
 ret_from_fork+0x1f/0x30 arch/x86/entry/entry_64.S:296


---
This report is generated by a bot. It may contain errors.
See https://goo.gl/tpsmEJ for more information about syzbot.
syzbot engineers can be reached at syzkaller@googlegroups.com.

syzbot will keep track of this issue. See:
https://goo.gl/tpsmEJ#status for how to communicate with syzbot.
syzbot can test patches for this issue, for details see:
https://goo.gl/tpsmEJ#testing-patches
