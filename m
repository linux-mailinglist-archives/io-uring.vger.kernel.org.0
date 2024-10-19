Return-Path: <io-uring+bounces-3839-lists+io-uring=lfdr.de@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [IPv6:2604:1380:4601:e00::3])
	by mail.lfdr.de (Postfix) with ESMTPS id 9FACD9A5143
	for <lists+io-uring@lfdr.de>; Sun, 20 Oct 2024 00:17:41 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id 1B92E1F22601
	for <lists+io-uring@lfdr.de>; Sat, 19 Oct 2024 22:17:41 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 3A2411922F1;
	Sat, 19 Oct 2024 22:17:33 +0000 (UTC)
X-Original-To: io-uring@vger.kernel.org
Received: from mail-il1-f200.google.com (mail-il1-f200.google.com [209.85.166.200])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D39AA167DB7
	for <io-uring@vger.kernel.org>; Sat, 19 Oct 2024 22:17:30 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.166.200
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1729376253; cv=none; b=jDuTlqQanWwH+uP5Ihqt/BqY0RGd9k9ljwsKF2EHF8OtL5Py55LbFgrCxUGQur8enQWzBUZkJ4fesi3M2w170aKLRC+78U1NGSef3RUZRqWWRsGMtkAMiNjnbfTOiYQEzT+HtpRFlG00VjAyh77NyBprCORqKzDpA079/Z7v7VI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1729376253; c=relaxed/simple;
	bh=LjCMDQv653GVBWtUngvECMrCk1DtcL2IHWPzUdvObGc=;
	h=MIME-Version:Date:Message-ID:Subject:From:To:Content-Type; b=Lxnv7qFiBlW3DJ/1BbaPqC82GD/h0958iPWuN5Q59qPlsX+GC48R6bjwuwwjOQbfJAq0XOhW4BKIA4SEG/LCks3QvbwxGRGwixd4R5g/uExpa8qnQNxJp14EaMBRtArAsNBcH0LftPXyZOMsRIzM59Yr5ScevuF5IfjM3dZ5YSY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=fail (p=none dis=none) header.from=syzkaller.appspotmail.com; spf=pass smtp.mailfrom=M3KW2WVRGUFZ5GODRSRYTGD7.apphosting.bounces.google.com; arc=none smtp.client-ip=209.85.166.200
Authentication-Results: smtp.subspace.kernel.org; dmarc=fail (p=none dis=none) header.from=syzkaller.appspotmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=M3KW2WVRGUFZ5GODRSRYTGD7.apphosting.bounces.google.com
Received: by mail-il1-f200.google.com with SMTP id e9e14a558f8ab-3a3cb771556so33327595ab.3
        for <io-uring@vger.kernel.org>; Sat, 19 Oct 2024 15:17:30 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1729376250; x=1729981050;
        h=to:from:subject:message-id:date:mime-version:x-gm-message-state
         :from:to:cc:subject:date:message-id:reply-to;
        bh=g6WdYd+/QgBUgZcOVwLcab2SaIw/kuqNCSg1KJnPIx0=;
        b=ece+0dLiTakl4KNq/58d5QJQtWWgiZuE2K6k/NErVWTMFHkklu3jmd4rFdDNlGegN1
         UTCscHbXpo+JUtkQ10REVIyi/zzKMqpMLmKQeShb6jCqTYdwFyvxvGDtKua5iWFIf32j
         xpmi5BcxDn4E2BptRh3mu+JTu+rOkVPOIxhpz5u0flid+bZY9lzOmr9fO8DlAsykPmk2
         BqLgjLAwfy61SDCeIMR+KFtdbH+24pQUz9AYOTDqaC39hrnd9/+CBIE2G1p7PGCjKjs5
         bxczD8bUm/TY1GHotnuRS2eRBHVbWj6w8Ol1jbkvtPMy2VqptbHPtrXsZVUBuegZ5KKQ
         mF2A==
X-Forwarded-Encrypted: i=1; AJvYcCWEzlCR2cy2KHi4MtbnwPFD41hISP/N9iOMidQobXBBwbi+idhp3WeV5u6rk31C4Q6qbFPgPtTPGg==@vger.kernel.org
X-Gm-Message-State: AOJu0YwFZjj1EC5KA0dbqtp5Og2+EskIFNjp2VpIkShhlfsfaja8GiBu
	pO+NNZWW3v0RRr/8mHMUAJY/CgS2nX4HnV5R6mNlEqtAiFd5WlSPLKLRH20d+88XeeSAHmEWR9t
	58ZJTXGe01Za7DSkRP5othRxIHtwNmphTfKD963MOkJVH1LuKzBDLSng=
X-Google-Smtp-Source: AGHT+IFM0ftuGeU6io7f/zUG/akYAM26dbzaYh9iCMcCUwMcdHf9B1ndSTThuUhBYcRxbHqL0ea6WNiVWNX0exYuBTY6cjySA66Y
Precedence: bulk
X-Mailing-List: io-uring@vger.kernel.org
List-Id: <io-uring.vger.kernel.org>
List-Subscribe: <mailto:io-uring+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:io-uring+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-Received: by 2002:a05:6e02:1b05:b0:3a3:3e17:994e with SMTP id
 e9e14a558f8ab-3a3f4054651mr62534005ab.9.1729376249926; Sat, 19 Oct 2024
 15:17:29 -0700 (PDT)
Date: Sat, 19 Oct 2024 15:17:29 -0700
X-Google-Appengine-App-Id: s~syzkaller
X-Google-Appengine-App-Id-Alias: syzkaller
Message-ID: <67142ff9.050a0220.1e4b4d.002f.GAE@google.com>
Subject: [syzbot] [io-uring?] INFO: task hung in io_wq_put_and_exit (4)
From: syzbot <syzbot+58928048fd1416f1457c@syzkaller.appspotmail.com>
To: asml.silence@gmail.com, axboe@kernel.dk, io-uring@vger.kernel.org, 
	linux-kernel@vger.kernel.org, syzkaller-bugs@googlegroups.com
Content-Type: text/plain; charset="UTF-8"

Hello,

syzbot found the following issue on:

HEAD commit:    4d939780b705 Merge tag 'mm-hotfixes-stable-2024-10-17-16-0..
git tree:       upstream
console output: https://syzkaller.appspot.com/x/log.txt?x=15f2c240580000
kernel config:  https://syzkaller.appspot.com/x/.config?x=cfbd94c114a3d407
dashboard link: https://syzkaller.appspot.com/bug?extid=58928048fd1416f1457c
compiler:       Debian clang version 15.0.6, GNU ld (GNU Binutils for Debian) 2.40

Unfortunately, I don't have any reproducer for this issue yet.

Downloadable assets:
disk image: https://storage.googleapis.com/syzbot-assets/6510e0507f68/disk-4d939780.raw.xz
vmlinux: https://storage.googleapis.com/syzbot-assets/a1bec5c6d200/vmlinux-4d939780.xz
kernel image: https://storage.googleapis.com/syzbot-assets/91694f5e7961/bzImage-4d939780.xz

IMPORTANT: if you fix the issue, please add the following tag to the commit:
Reported-by: syzbot+58928048fd1416f1457c@syzkaller.appspotmail.com

INFO: task syz.2.944:9507 blocked for more than 143 seconds.
      Not tainted 6.12.0-rc3-syzkaller-00217-g4d939780b705 #0
"echo 0 > /proc/sys/kernel/hung_task_timeout_secs" disables this message.
task:syz.2.944       state:D stack:25744 pid:9507  tgid:9506  ppid:9305   flags:0x00024000
Call Trace:
 <TASK>
 context_switch kernel/sched/core.c:5322 [inline]
 __schedule+0x1895/0x4b30 kernel/sched/core.c:6682
 __schedule_loop kernel/sched/core.c:6759 [inline]
 schedule+0x14b/0x320 kernel/sched/core.c:6774
 schedule_timeout+0xb0/0x310 kernel/time/timer.c:2591
 do_wait_for_common kernel/sched/completion.c:95 [inline]
 __wait_for_common kernel/sched/completion.c:116 [inline]
 wait_for_common kernel/sched/completion.c:127 [inline]
 wait_for_completion+0x355/0x620 kernel/sched/completion.c:148
 io_wq_exit_workers io_uring/io-wq.c:1249 [inline]
 io_wq_put_and_exit+0x344/0x720 io_uring/io-wq.c:1277
 io_uring_clean_tctx+0x168/0x1e0 io_uring/tctx.c:193
 io_uring_cancel_generic+0x76a/0x820 io_uring/io_uring.c:3219
 io_uring_files_cancel include/linux/io_uring.h:20 [inline]
 do_exit+0x6a8/0x28e0 kernel/exit.c:895
 do_group_exit+0x207/0x2c0 kernel/exit.c:1088
 get_signal+0x16a3/0x1740 kernel/signal.c:2917
 arch_do_signal_or_restart+0x96/0x860 arch/x86/kernel/signal.c:337
 exit_to_user_mode_loop kernel/entry/common.c:111 [inline]
 exit_to_user_mode_prepare include/linux/entry-common.h:328 [inline]
 __syscall_exit_to_user_mode_work kernel/entry/common.c:207 [inline]
 syscall_exit_to_user_mode+0xc9/0x370 kernel/entry/common.c:218
 do_syscall_64+0x100/0x230 arch/x86/entry/common.c:89
 entry_SYSCALL_64_after_hwframe+0x77/0x7f
RIP: 0033:0x7f958877dff9
RSP: 002b:00007f95895d30e8 EFLAGS: 00000246 ORIG_RAX: 00000000000000ca
RAX: fffffffffffffe00 RBX: 00007f9588935f88 RCX: 00007f958877dff9
RDX: 0000000000000000 RSI: 0000000000000080 RDI: 00007f9588935f88
RBP: 00007f9588935f80 R08: 0000000000000000 R09: 0000000000000000
R10: 0000000000000000 R11: 0000000000000246 R12: 00007f9588935f8c
R13: 0000000000000000 R14: 00007f9588a5f940 R15: 00007f9588a5fa28
 </TASK>

Showing all locks held in the system:
3 locks held by kworker/u8:1/12:
 #0: ffff88814bf8f148 ((wq_completion)ipv6_addrconf){+.+.}-{0:0}, at: process_one_work kernel/workqueue.c:3204 [inline]
 #0: ffff88814bf8f148 ((wq_completion)ipv6_addrconf){+.+.}-{0:0}, at: process_scheduled_works+0x93b/0x1850 kernel/workqueue.c:3310
 #1: ffffc90000117d00 ((work_completion)(&(&ifa->dad_work)->work)){+.+.}-{0:0}, at: process_one_work kernel/workqueue.c:3205 [inline]
 #1: ffffc90000117d00 ((work_completion)(&(&ifa->dad_work)->work)){+.+.}-{0:0}, at: process_scheduled_works+0x976/0x1850 kernel/workqueue.c:3310
 #2: ffffffff8fcd2d08 (rtnl_mutex){+.+.}-{3:3}, at: addrconf_dad_work+0xd0/0x16f0 net/ipv6/addrconf.c:4196
1 lock held by khungtaskd/30:
 #0: ffffffff8e937de0 (rcu_read_lock){....}-{1:2}, at: rcu_lock_acquire include/linux/rcupdate.h:337 [inline]
 #0: ffffffff8e937de0 (rcu_read_lock){....}-{1:2}, at: rcu_read_lock include/linux/rcupdate.h:849 [inline]
 #0: ffffffff8e937de0 (rcu_read_lock){....}-{1:2}, at: debug_show_all_locks+0x55/0x2a0 kernel/locking/lockdep.c:6720
6 locks held by kworker/u8:3/52:
 #0: ffff88801baed948 ((wq_completion)netns){+.+.}-{0:0}, at: process_one_work kernel/workqueue.c:3204 [inline]
 #0: ffff88801baed948 ((wq_completion)netns){+.+.}-{0:0}, at: process_scheduled_works+0x93b/0x1850 kernel/workqueue.c:3310
 #1: ffffc90000bd7d00 (net_cleanup_work){+.+.}-{0:0}, at: process_one_work kernel/workqueue.c:3205 [inline]
 #1: ffffc90000bd7d00 (net_cleanup_work){+.+.}-{0:0}, at: process_scheduled_works+0x976/0x1850 kernel/workqueue.c:3310
 #2: ffffffff8fcc6210 (pernet_ops_rwsem){++++}-{3:3}, at: cleanup_net+0x16a/0xcc0 net/core/net_namespace.c:580
 #3: ffff8880518ac0e8 (&dev->mutex){....}-{3:3}, at: device_lock include/linux/device.h:1014 [inline]
 #3: ffff8880518ac0e8 (&dev->mutex){....}-{3:3}, at: devl_dev_lock net/devlink/devl_internal.h:108 [inline]
 #3: ffff8880518ac0e8 (&dev->mutex){....}-{3:3}, at: devlink_pernet_pre_exit+0x13b/0x440 net/devlink/core.c:506
 #4: ffff8880518af250 (&devlink->lock_key#45){+.+.}-{3:3}, at: devl_lock net/devlink/core.c:276 [inline]
 #4: ffff8880518af250 (&devlink->lock_key#45){+.+.}-{3:3}, at: devl_dev_lock net/devlink/devl_internal.h:109 [inline]
 #4: ffff8880518af250 (&devlink->lock_key#45){+.+.}-{3:3}, at: devlink_pernet_pre_exit+0x14d/0x440 net/devlink/core.c:506
 #5: ffffffff8fcd2d08 (rtnl_mutex){+.+.}-{3:3}, at: nsim_destroy+0x71/0x5c0 drivers/net/netdevsim/netdev.c:773
2 locks held by dhcpcd/4900:
2 locks held by getty/4984:
 #0: ffff88814d1800a0 (&tty->ldisc_sem){++++}-{0:0}, at: tty_ldisc_ref_wait+0x25/0x70 drivers/tty/tty_ldisc.c:243
 #1: ffffc90002f062f0 (&ldata->atomic_read_lock){+.+.}-{3:3}, at: n_tty_read+0x6a6/0x1e00 drivers/tty/n_tty.c:2211
1 lock held by iou-wrk-9507/9508:
 #0: ffff888031f540a8 (&ctx->uring_lock){+.+.}-{3:3}, at: io_ring_submit_lock io_uring/io_uring.h:249 [inline]
 #0: ffff888031f540a8 (&ctx->uring_lock){+.+.}-{3:3}, at: io_provide_buffers+0xd0b/0x1010 io_uring/kbuf.c:580
1 lock held by iou-wrk-9507/9510:
 #0: ffff888031f540a8 (&ctx->uring_lock){+.+.}-{3:3}, at: io_ring_submit_lock io_uring/io_uring.h:249 [inline]
 #0: ffff888031f540a8 (&ctx->uring_lock){+.+.}-{3:3}, at: io_provide_buffers+0xd0b/0x1010 io_uring/kbuf.c:580
1 lock held by iou-wrk-9507/9511:
 #0: ffff888031f540a8 (&ctx->uring_lock){+.+.}-{3:3}, at: io_ring_submit_lock io_uring/io_uring.h:249 [inline]
 #0: ffff888031f540a8 (&ctx->uring_lock){+.+.}-{3:3}, at: io_provide_buffers+0xd0b/0x1010 io_uring/kbuf.c:580
1 lock held by iou-wrk-9507/9512:
 #0: ffff888031f540a8 (&ctx->uring_lock){+.+.}-{3:3}, at: io_ring_submit_lock io_uring/io_uring.h:249 [inline]
 #0: ffff888031f540a8 (&ctx->uring_lock){+.+.}-{3:3}, at: io_provide_buffers+0xd0b/0x1010 io_uring/kbuf.c:580
2 locks held by iou-wrk-9507/9513:
1 lock held by iou-wrk-9507/9514:
 #0: ffff888031f540a8 (&ctx->uring_lock){+.+.}-{3:3}, at: io_ring_submit_lock io_uring/io_uring.h:249 [inline]
 #0: ffff888031f540a8 (&ctx->uring_lock){+.+.}-{3:3}, at: io_provide_buffers+0xd0b/0x1010 io_uring/kbuf.c:580
1 lock held by iou-wrk-9507/9515:
 #0: ffff888031f540a8 (&ctx->uring_lock){+.+.}-{3:3}, at: io_ring_submit_lock io_uring/io_uring.h:249 [inline]
 #0: ffff888031f540a8 (&ctx->uring_lock){+.+.}-{3:3}, at: io_provide_buffers+0xd0b/0x1010 io_uring/kbuf.c:580
1 lock held by iou-wrk-9507/9516:
 #0: ffff888031f540a8 (&ctx->uring_lock){+.+.}-{3:3}, at: io_ring_submit_lock io_uring/io_uring.h:249 [inline]
 #0: ffff888031f540a8 (&ctx->uring_lock){+.+.}-{3:3}, at: io_provide_buffers+0xd0b/0x1010 io_uring/kbuf.c:580
1 lock held by syz.0.1129/10509:
1 lock held by syz-executor/10878:
 #0: ffffffff8e93d378 (rcu_state.exp_mutex){+.+.}-{3:3}, at: exp_funnel_lock kernel/rcu/tree_exp.h:297 [inline]
 #0: ffffffff8e93d378 (rcu_state.exp_mutex){+.+.}-{3:3}, at: synchronize_rcu_expedited+0x381/0x830 kernel/rcu/tree_exp.h:976
1 lock held by syz-executor/11012:
1 lock held by syz-executor/11041:
4 locks held by syz-executor/11109:
1 lock held by syz.0.1245/11222:

=============================================

NMI backtrace for cpu 1
CPU: 1 UID: 0 PID: 30 Comm: khungtaskd Not tainted 6.12.0-rc3-syzkaller-00217-g4d939780b705 #0
Hardware name: Google Google Compute Engine/Google Compute Engine, BIOS Google 09/13/2024
Call Trace:
 <TASK>
 __dump_stack lib/dump_stack.c:94 [inline]
 dump_stack_lvl+0x241/0x360 lib/dump_stack.c:120
 nmi_cpu_backtrace+0x49c/0x4d0 lib/nmi_backtrace.c:113
 nmi_trigger_cpumask_backtrace+0x198/0x320 lib/nmi_backtrace.c:62
 trigger_all_cpu_backtrace include/linux/nmi.h:162 [inline]
 check_hung_uninterruptible_tasks kernel/hung_task.c:223 [inline]
 watchdog+0xff4/0x1040 kernel/hung_task.c:379
 kthread+0x2f0/0x390 kernel/kthread.c:389
 ret_from_fork+0x4b/0x80 arch/x86/kernel/process.c:147
 ret_from_fork_asm+0x1a/0x30 arch/x86/entry/entry_64.S:244
 </TASK>
Sending NMI from CPU 1 to CPUs 0:
NMI backtrace for cpu 0
CPU: 0 UID: 0 PID: 11222 Comm: syz.0.1245 Not tainted 6.12.0-rc3-syzkaller-00217-g4d939780b705 #0
Hardware name: Google Google Compute Engine/Google Compute Engine, BIOS Google 09/13/2024
RIP: 0010:preempt_count kernel/rcu/tree.c:4767 [inline]
RIP: 0010:rcu_lockdep_current_cpu_online+0x6/0x120 kernel/rcu/tree.c:4771
Code: e9 53 ff ff ff 66 2e 0f 1f 84 00 00 00 00 00 0f 1f 44 00 00 90 90 90 90 90 90 90 90 90 90 90 90 90 90 90 90 f3 0f 1e fa 41 57 <41> 56 53 65 8b 0d f8 a4 88 7e b0 01 f7 c1 00 00 f0 00 0f 85 d5 00
RSP: 0018:ffffc90003c0f7a8 EFLAGS: 00000202
RAX: 0000000000000001 RBX: 0000000000000000 RCX: ffff888025388000
RDX: 0000000000000000 RSI: ffffffff8c610180 RDI: ffffffff8c610140
RBP: 0000000000000140 R08: ffffffff820b6d6e R09: 1ffffffff2859300
R10: dffffc0000000000 R11: fffffbfff2859301 R12: 0000000000055529
R13: ffffea0001554a48 R14: ffffffff820b6ca0 R15: ffff88801bf00000
FS:  0000000000000000(0000) GS:ffff8880b8600000(0000) knlGS:0000000000000000
CS:  0010 DS: 0000 ES: 0000 CR0: 0000000080050033
CR2: 00007f401994e5a0 CR3: 000000000e734000 CR4: 00000000003526f0
DR0: 0000000000000003 DR1: 0000000000000000 DR2: 0000000000000000
DR3: 0000000000000000 DR6: 00000000ffff0ff0 DR7: 0000000000000400
Call Trace:
 <NMI>
 </NMI>
 <TASK>
 rcu_read_lock_held_common kernel/rcu/update.c:113 [inline]
 rcu_read_lock_held+0x1e/0x50 kernel/rcu/update.c:349
 lookup_page_ext mm/page_ext.c:254 [inline]
 page_ext_get+0x192/0x2a0 mm/page_ext.c:526
 __reset_page_owner+0x30/0x430 mm/page_owner.c:290
 reset_page_owner include/linux/page_owner.h:25 [inline]
 free_pages_prepare mm/page_alloc.c:1108 [inline]
 free_unref_page+0xcfb/0xf20 mm/page_alloc.c:2638
 vfree+0x186/0x2e0 mm/vmalloc.c:3361
 kcov_put kernel/kcov.c:439 [inline]
 kcov_close+0x28/0x50 kernel/kcov.c:535
 __fput+0x23f/0x880 fs/file_table.c:431
 task_work_run+0x24f/0x310 kernel/task_work.c:228
 exit_task_work include/linux/task_work.h:40 [inline]
 do_exit+0xa2f/0x28e0 kernel/exit.c:939
 do_group_exit+0x207/0x2c0 kernel/exit.c:1088
 get_signal+0x16a3/0x1740 kernel/signal.c:2917
 arch_do_signal_or_restart+0x96/0x860 arch/x86/kernel/signal.c:337
 exit_to_user_mode_loop kernel/entry/common.c:111 [inline]
 exit_to_user_mode_prepare include/linux/entry-common.h:328 [inline]
 __syscall_exit_to_user_mode_work kernel/entry/common.c:207 [inline]
 syscall_exit_to_user_mode+0xc9/0x370 kernel/entry/common.c:218
 do_syscall_64+0x100/0x230 arch/x86/entry/common.c:89
 entry_SYSCALL_64_after_hwframe+0x77/0x7f
RIP: 0033:0x7fa6a717dff9
Code: Unable to access opcode bytes at 0x7fa6a717dfcf.
RSP: 002b:00007fa6a7f5d0e8 EFLAGS: 00000246 ORIG_RAX: 00000000000000ca
RAX: fffffffffffffe00 RBX: 00007fa6a7335f88 RCX: 00007fa6a717dff9
RDX: 0000000000000000 RSI: 0000000000000080 RDI: 00007fa6a7335f88
RBP: 00007fa6a7335f80 R08: 0000000000000000 R09: 0000000000000000
R10: 0000000000000000 R11: 0000000000000246 R12: 00007fa6a7335f8c
R13: 0000000000000000 R14: 00007fa6a745f940 R15: 00007fa6a745fa28
 </TASK>


---
This report is generated by a bot. It may contain errors.
See https://goo.gl/tpsmEJ for more information about syzbot.
syzbot engineers can be reached at syzkaller@googlegroups.com.

syzbot will keep track of this issue. See:
https://goo.gl/tpsmEJ#status for how to communicate with syzbot.

If the report is already addressed, let syzbot know by replying with:
#syz fix: exact-commit-title

If you want to overwrite report's subsystems, reply with:
#syz set subsystems: new-subsystem
(See the list of subsystem names on the web dashboard)

If the report is a duplicate of another one, reply with:
#syz dup: exact-subject-of-another-report

If you want to undo deduplication, reply with:
#syz undup

