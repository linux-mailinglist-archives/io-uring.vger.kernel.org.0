Return-Path: <io-uring+bounces-10237-lists+io-uring=lfdr.de@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [IPv6:2604:1380:45e3:2400::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 780C8C1179D
	for <lists+io-uring@lfdr.de>; Mon, 27 Oct 2025 22:08:27 +0100 (CET)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id C165B401FA6
	for <lists+io-uring@lfdr.de>; Mon, 27 Oct 2025 21:07:43 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id DF04A3254BC;
	Mon, 27 Oct 2025 21:07:39 +0000 (UTC)
X-Original-To: io-uring@vger.kernel.org
Received: from mail-il1-f205.google.com (mail-il1-f205.google.com [209.85.166.205])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A1BFF30147E
	for <io-uring@vger.kernel.org>; Mon, 27 Oct 2025 21:07:37 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.166.205
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1761599259; cv=none; b=K39+mxr+/q5TrD5tZDem+jvgIj54In/8vbEv9DAKGnBf+cPSnbM2CwtGMvzz389oeilgQYGpx7bn3easYSlMpjPzu/7hfRmCu1hlIZc9fB4otG9uITr9rifRihJ/zug/1Q714DEu6NFqB4C7PUplQvjSlJMoq4gpKZYPMWalEZY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1761599259; c=relaxed/simple;
	bh=Cz1eSevpD/I1LrsIrUBNouhdxHno4nqx0TPkX3bxatk=;
	h=MIME-Version:Date:Message-ID:Subject:From:To:Content-Type; b=XKKnF0qdGjBhtT3xq4lzPIk9zjGRJ9O+6Hz9VgOlLjV9aSgiuw5hculesaT/ObSkkBNHtYqmJQ6smEo6tAExM154CpzF8ZKvxNt4Sm1PFRRLLFFHVBn9JB1ttoTH2IZGhbhgveJBM4f+rxf5ZK5Llk2z5o7ZUIuWv7GxJVeiU2Q=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=fail (p=none dis=none) header.from=syzkaller.appspotmail.com; spf=pass smtp.mailfrom=M3KW2WVRGUFZ5GODRSRYTGD7.apphosting.bounces.google.com; arc=none smtp.client-ip=209.85.166.205
Authentication-Results: smtp.subspace.kernel.org; dmarc=fail (p=none dis=none) header.from=syzkaller.appspotmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=M3KW2WVRGUFZ5GODRSRYTGD7.apphosting.bounces.google.com
Received: by mail-il1-f205.google.com with SMTP id e9e14a558f8ab-431d999ebe8so164794145ab.1
        for <io-uring@vger.kernel.org>; Mon, 27 Oct 2025 14:07:37 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1761599257; x=1762204057;
        h=to:from:subject:message-id:date:mime-version:x-gm-message-state
         :from:to:cc:subject:date:message-id:reply-to;
        bh=yJd309KA2t9tYlphuKW1GClsIxItIY6mqSvUQYS2sUs=;
        b=NQj0QOv3IOlPfGi6cPs6DtdLaVpXlNs6LnT6oDPcJkcdaNfqR6EmvCEl0LQotbF4V0
         ZQAS0bClZ3k199MyhucvP7l1h9hN71psSSWZ9c7I3unqegcjrad4gC7EKlZelNaDiMLI
         cNQCEnztKIXbJNNhAj1vSc0SCU+yHKEPS3T+esSMKcG1BJz2Sk8AZjQ2fV8qFAvKhgZn
         HWJdm7Jjm19qSQeHR5yTTcZr+iRSRzweOqAYPPbE+3hcqpA8eHmm8X8z+yJ3kcSbnsKd
         J1O8tuYWnzPQB8IO50xeV1HVlJhux0OTafo7kUq8xnLtOIFr3pBnHyuQUMLvyjiwn0a0
         qc0Q==
X-Forwarded-Encrypted: i=1; AJvYcCUf8LgjeW71Y+KN5kJemPT48jFEn1gBRU44sXi5U7aJFW58sVrIesDymdyz7x3pqNqKx1Jq3hZQ3g==@vger.kernel.org
X-Gm-Message-State: AOJu0YxEyp12PhNxX1h/bYdC8oVcf/DJ6hnfO9bqQXhc3G9HK4gzI8Ab
	y3vaKHwNz4owCqYBrdNR4EkSgxOtiVybrgND0Zslu+FU1JMkhAySv9y0z691XK6bMaLXdH5vUk0
	YwDj08t5mW6ealLRnnAHZMNu14aedxNx2b2/Yy0rvxX8Fcf1gtqXfiUM0Sp4=
X-Google-Smtp-Source: AGHT+IHtrFJtB1irmumn5zkk/+lgIGRIIa8XaCwkJxPDXeOqp5K9BJ4Wwid1E2uNB6608tP8V/0rswSH123NiE1cwuSJBd1iG3H2
Precedence: bulk
X-Mailing-List: io-uring@vger.kernel.org
List-Id: <io-uring.vger.kernel.org>
List-Subscribe: <mailto:io-uring+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:io-uring+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-Received: by 2002:a92:cdab:0:b0:431:d951:ab9b with SMTP id
 e9e14a558f8ab-4320f685ff3mr22239925ab.0.1761599256723; Mon, 27 Oct 2025
 14:07:36 -0700 (PDT)
Date: Mon, 27 Oct 2025 14:07:36 -0700
X-Google-Appengine-App-Id: s~syzkaller
X-Google-Appengine-App-Id-Alias: syzkaller
Message-ID: <68ffdf18.050a0220.3344a1.039e.GAE@google.com>
Subject: [syzbot] [io-uring?] INFO: task hung in io_uring_del_tctx_node (5)
From: syzbot <syzbot+10a9b495f54a17b607a6@syzkaller.appspotmail.com>
To: axboe@kernel.dk, io-uring@vger.kernel.org, linux-kernel@vger.kernel.org, 
	syzkaller-bugs@googlegroups.com
Content-Type: text/plain; charset="UTF-8"

Hello,

syzbot found the following issue on:

HEAD commit:    72fb0170ef1f Add linux-next specific files for 20251024
git tree:       linux-next
console output: https://syzkaller.appspot.com/x/log.txt?x=13087be2580000
kernel config:  https://syzkaller.appspot.com/x/.config?x=e812d103f45aa955
dashboard link: https://syzkaller.appspot.com/bug?extid=10a9b495f54a17b607a6
compiler:       Debian clang version 20.1.8 (++20250708063551+0c9f909b7976-1~exp1~20250708183702.136), Debian LLD 20.1.8
syz repro:      https://syzkaller.appspot.com/x/repro.syz?x=14725d2f980000
C reproducer:   https://syzkaller.appspot.com/x/repro.c?x=11233b04580000

Downloadable assets:
disk image: https://storage.googleapis.com/syzbot-assets/be1fa3d1f761/disk-72fb0170.raw.xz
vmlinux: https://storage.googleapis.com/syzbot-assets/57302bf7af40/vmlinux-72fb0170.xz
kernel image: https://storage.googleapis.com/syzbot-assets/91c806bb2a2b/bzImage-72fb0170.xz

IMPORTANT: if you fix the issue, please add the following tag to the commit:
Reported-by: syzbot+10a9b495f54a17b607a6@syzkaller.appspotmail.com

INFO: task syz.0.17:6027 blocked for more than 143 seconds.
      Not tainted syzkaller #0
      Blocked by coredump.
"echo 0 > /proc/sys/kernel/hung_task_timeout_secs" disables this message.
task:syz.0.17        state:D stack:25752 pid:6027  tgid:6026  ppid:5955   task_flags:0x400548 flags:0x00080000
Call Trace:
 <TASK>
 context_switch kernel/sched/core.c:5254 [inline]
 __schedule+0x17c4/0x4d60 kernel/sched/core.c:6862
 __schedule_loop kernel/sched/core.c:6944 [inline]
 schedule+0x165/0x360 kernel/sched/core.c:6959
 schedule_preempt_disabled+0x13/0x30 kernel/sched/core.c:7016
 __mutex_lock_common kernel/locking/mutex.c:676 [inline]
 __mutex_lock+0x7e6/0x1350 kernel/locking/mutex.c:760
 io_uring_del_tctx_node+0xf0/0x2c0 io_uring/tctx.c:179
 io_uring_clean_tctx+0xd4/0x1a0 io_uring/tctx.c:195
 io_uring_cancel_generic+0x6ca/0x7d0 io_uring/io_uring.c:3363
 io_uring_files_cancel include/linux/io_uring.h:19 [inline]
 do_exit+0x345/0x2300 kernel/exit.c:912
 do_group_exit+0x21c/0x2d0 kernel/exit.c:1107
 get_signal+0x1285/0x1340 kernel/signal.c:3034
 arch_do_signal_or_restart+0xa0/0x790 arch/x86/kernel/signal.c:337
 exit_to_user_mode_loop+0x72/0x130 kernel/entry/common.c:40
 exit_to_user_mode_prepare include/linux/irq-entry-common.h:225 [inline]
 syscall_exit_to_user_mode_work include/linux/entry-common.h:175 [inline]
 syscall_exit_to_user_mode include/linux/entry-common.h:210 [inline]
 do_syscall_64+0x2bd/0xfa0 arch/x86/entry/syscall_64.c:100
 entry_SYSCALL_64_after_hwframe+0x77/0x7f
RIP: 0033:0x7f887d98efc9
RSP: 002b:00007f887e743038 EFLAGS: 00000246 ORIG_RAX: 000000000000010e
RAX: fffffffffffffdfe RBX: 00007f887dbe5fa0 RCX: 00007f887d98efc9
RDX: 0000000000000000 RSI: 0000000000000000 RDI: 0000000000000000
RBP: 00007f887da11f91 R08: 0000000000000000 R09: 0000000000000000
R10: 0000000000000000 R11: 0000000000000246 R12: 0000000000000000
R13: 00007f887dbe6038 R14: 00007f887dbe5fa0 R15: 00007ffda9831b38
 </TASK>
INFO: task syz.1.18:6058 blocked for more than 145 seconds.
      Not tainted syzkaller #0
      Blocked by coredump.
"echo 0 > /proc/sys/kernel/hung_task_timeout_secs" disables this message.
task:syz.1.18        state:D stack:28104 pid:6058  tgid:6057  ppid:6038   task_flags:0x400548 flags:0x00080000
Call Trace:
 <TASK>
 context_switch kernel/sched/core.c:5254 [inline]
 __schedule+0x17c4/0x4d60 kernel/sched/core.c:6862
 __schedule_loop kernel/sched/core.c:6944 [inline]
 schedule+0x165/0x360 kernel/sched/core.c:6959
 schedule_preempt_disabled+0x13/0x30 kernel/sched/core.c:7016
 __mutex_lock_common kernel/locking/mutex.c:676 [inline]
 __mutex_lock+0x7e6/0x1350 kernel/locking/mutex.c:760
 io_uring_del_tctx_node+0xf0/0x2c0 io_uring/tctx.c:179
 io_uring_clean_tctx+0xd4/0x1a0 io_uring/tctx.c:195
 io_uring_cancel_generic+0x6ca/0x7d0 io_uring/io_uring.c:3363
 io_uring_files_cancel include/linux/io_uring.h:19 [inline]
 do_exit+0x345/0x2300 kernel/exit.c:912
 do_group_exit+0x21c/0x2d0 kernel/exit.c:1107
 get_signal+0x1285/0x1340 kernel/signal.c:3034
 arch_do_signal_or_restart+0xa0/0x790 arch/x86/kernel/signal.c:337
 exit_to_user_mode_loop+0x72/0x130 kernel/entry/common.c:40
 exit_to_user_mode_prepare include/linux/irq-entry-common.h:225 [inline]
 syscall_exit_to_user_mode_work include/linux/entry-common.h:175 [inline]
 syscall_exit_to_user_mode include/linux/entry-common.h:210 [inline]
 do_syscall_64+0x2bd/0xfa0 arch/x86/entry/syscall_64.c:100
 entry_SYSCALL_64_after_hwframe+0x77/0x7f
RIP: 0033:0x7f37d438efc9
RSP: 002b:00007f37d5232038 EFLAGS: 00000246 ORIG_RAX: 000000000000010e
RAX: fffffffffffffdfe RBX: 00007f37d45e5fa0 RCX: 00007f37d438efc9
RDX: 0000000000000000 RSI: 0000000000000000 RDI: 0000000000000000
RBP: 00007f37d4411f91 R08: 0000000000000000 R09: 0000000000000000
R10: 0000000000000000 R11: 0000000000000246 R12: 0000000000000000
R13: 00007f37d45e6038 R14: 00007f37d45e5fa0 R15: 00007ffc85237d08
 </TASK>

Showing all locks held in the system:
1 lock held by khungtaskd/31:
 #0: ffffffff8e13d5a0 (rcu_read_lock){....}-{1:3}, at: rcu_lock_acquire include/linux/rcupdate.h:331 [inline]
 #0: ffffffff8e13d5a0 (rcu_read_lock){....}-{1:3}, at: rcu_read_lock include/linux/rcupdate.h:867 [inline]
 #0: ffffffff8e13d5a0 (rcu_read_lock){....}-{1:3}, at: debug_show_all_locks+0x2e/0x180 kernel/locking/lockdep.c:6775
3 locks held by kworker/u8:3/37:
 #0: ffff88813fe69948 ((wq_completion)events_unbound#2){+.+.}-{0:0}, at: process_one_work kernel/workqueue.c:3238 [inline]
 #0: ffff88813fe69948 ((wq_completion)events_unbound#2){+.+.}-{0:0}, at: process_scheduled_works+0x9b4/0x17b0 kernel/workqueue.c:3346
 #1: ffffc90000ad7ba0 ((linkwatch_work).work){+.+.}-{0:0}, at: process_one_work kernel/workqueue.c:3239 [inline]
 #1: ffffc90000ad7ba0 ((linkwatch_work).work){+.+.}-{0:0}, at: process_scheduled_works+0x9ef/0x17b0 kernel/workqueue.c:3346
 #2: ffffffff8f4edb48 (rtnl_mutex){+.+.}-{4:4}, at: linkwatch_event+0xe/0x60 net/core/link_watch.c:303
3 locks held by kworker/u8:7/3579:
 #0: ffff88802f51d148 ((wq_completion)ipv6_addrconf){+.+.}-{0:0}, at: process_one_work kernel/workqueue.c:3238 [inline]
 #0: ffff88802f51d148 ((wq_completion)ipv6_addrconf){+.+.}-{0:0}, at: process_scheduled_works+0x9b4/0x17b0 kernel/workqueue.c:3346
 #1: ffffc9000c717ba0 ((work_completion)(&(&ifa->dad_work)->work)){+.+.}-{0:0}, at: process_one_work kernel/workqueue.c:3239 [inline]
 #1: ffffc9000c717ba0 ((work_completion)(&(&ifa->dad_work)->work)){+.+.}-{0:0}, at: process_scheduled_works+0x9ef/0x17b0 kernel/workqueue.c:3346
 #2: ffffffff8f4edb48 (rtnl_mutex){+.+.}-{4:4}, at: rtnl_net_lock include/linux/rtnetlink.h:130 [inline]
 #2: ffffffff8f4edb48 (rtnl_mutex){+.+.}-{4:4}, at: addrconf_dad_work+0x112/0x14b0 net/ipv6/addrconf.c:4194
2 locks held by getty/5585:
 #0: ffff8880344d50a0 (&tty->ldisc_sem){++++}-{0:0}, at: tty_ldisc_ref_wait+0x25/0x70 drivers/tty/tty_ldisc.c:243
 #1: ffffc900036bb2f0 (&ldata->atomic_read_lock){+.+.}-{4:4}, at: n_tty_read+0x43e/0x1400 drivers/tty/n_tty.c:2222
1 lock held by syz.0.17/6027:
 #0: ffff888031ece0a8 (&ctx->uring_lock){+.+.}-{4:4}, at: io_uring_del_tctx_node+0xf0/0x2c0 io_uring/tctx.c:179
3 locks held by syz.0.17/6030:
1 lock held by syz.1.18/6058:
 #0: ffff88802faa20a8 (&ctx->uring_lock){+.+.}-{4:4}, at: io_uring_del_tctx_node+0xf0/0x2c0 io_uring/tctx.c:179
3 locks held by syz.1.18/6059:
1 lock held by syz.2.19/6082:
 #0: ffff88802840c0a8 (&ctx->uring_lock){+.+.}-{4:4}, at: io_uring_del_tctx_node+0xf0/0x2c0 io_uring/tctx.c:179
3 locks held by syz.2.19/6083:
1 lock held by syz.3.20/6106:
 #0: ffff8880338140a8 (&ctx->uring_lock){+.+.}-{4:4}, at: io_uring_del_tctx_node+0xf0/0x2c0 io_uring/tctx.c:179
3 locks held by syz.3.20/6107:
1 lock held by syz.4.21/6142:
 #0: ffff8880611da0a8 (&ctx->uring_lock){+.+.}-{4:4}, at: io_uring_del_tctx_node+0xf0/0x2c0 io_uring/tctx.c:179
3 locks held by syz.4.21/6143:
1 lock held by syz.5.22/6172:
 #0: ffff88801f7c00a8 (&ctx->uring_lock){+.+.}-{4:4}, at: io_uring_del_tctx_node+0xf0/0x2c0 io_uring/tctx.c:179
3 locks held by syz.5.22/6173:
1 lock held by syz.6.23/6204:
 #0: ffff88805b6440a8 (&ctx->uring_lock){+.+.}-{4:4}, at: io_uring_del_tctx_node+0xf0/0x2c0 io_uring/tctx.c:179
3 locks held by syz.6.23/6205:
1 lock held by syz.7.24/6242:
 #0: ffff8880301c60a8 (&ctx->uring_lock){+.+.}-{4:4}, at: io_uring_del_tctx_node+0xf0/0x2c0 io_uring/tctx.c:179
3 locks held by syz.7.24/6243:
3 locks held by syz-executor/6246:
 #0: ffffffff8f4edb48 (rtnl_mutex){+.+.}-{4:4}, at: rtnl_lock net/core/rtnetlink.c:80 [inline]
 #0: ffffffff8f4edb48 (rtnl_mutex){+.+.}-{4:4}, at: rtnl_nets_lock net/core/rtnetlink.c:341 [inline]
 #0: ffffffff8f4edb48 (rtnl_mutex){+.+.}-{4:4}, at: rtnl_newlink+0x8e9/0x1c80 net/core/rtnetlink.c:4064
 #1: ffff88807b9c1528 (&wg->device_update_lock){+.+.}-{4:4}, at: wg_open+0x227/0x420 drivers/net/wireguard/device.c:50
 #2: ffffffff8e143038 (rcu_state.exp_mutex){+.+.}-{4:4}, at: exp_funnel_lock kernel/rcu/tree_exp.h:311 [inline]
 #2: ffffffff8e143038 (rcu_state.exp_mutex){+.+.}-{4:4}, at: synchronize_rcu_expedited+0x2f6/0x730 kernel/rcu/tree_exp.h:957

=============================================

NMI backtrace for cpu 1
CPU: 1 UID: 0 PID: 31 Comm: khungtaskd Not tainted syzkaller #0 PREEMPT(full) 
Hardware name: Google Google Compute Engine/Google Compute Engine, BIOS Google 10/02/2025
Call Trace:
 <TASK>
 dump_stack_lvl+0x189/0x250 lib/dump_stack.c:120
 nmi_cpu_backtrace+0x39e/0x3d0 lib/nmi_backtrace.c:113
 nmi_trigger_cpumask_backtrace+0x17a/0x300 lib/nmi_backtrace.c:62
 trigger_all_cpu_backtrace include/linux/nmi.h:160 [inline]
 check_hung_uninterruptible_tasks kernel/hung_task.c:337 [inline]
 watchdog+0xfa9/0xff0 kernel/hung_task.c:500
 kthread+0x711/0x8a0 kernel/kthread.c:463
 ret_from_fork+0x4bc/0x870 arch/x86/kernel/process.c:158
 ret_from_fork_asm+0x1a/0x30 arch/x86/entry/entry_64.S:245
 </TASK>
Sending NMI from CPU 1 to CPUs 0:
NMI backtrace for cpu 0
CPU: 0 UID: 0 PID: 6107 Comm: syz.3.20 Not tainted syzkaller #0 PREEMPT(full) 
Hardware name: Google Google Compute Engine/Google Compute Engine, BIOS Google 10/02/2025
RIP: 0010:kasan_check_range+0x1d4/0x2c0 mm/kasan/generic.c:200
Code: 01 f3 49 8d 5c 24 07 4d 85 e4 49 0f 49 dc 48 83 e3 f8 49 29 dc 74 12 41 80 3b 00 0f 85 b8 00 00 00 49 ff c3 49 ff cc 75 ee 5b <41> 5c 41 5d 41 5e 41 5f 5d e9 4e d8 2e 09 cc 45 84 ff 75 63 41 f7
RSP: 0018:ffffc9000383f7b0 EFLAGS: 00000256
RAX: ffffffff82431501 RBX: 0000000000000018 RCX: ffffffff824315fd
RDX: 0000000000000001 RSI: 0000000000000018 RDI: ffffc9000383f880
RBP: 0000000000000000 R08: ffffc9000383f897 R09: 1ffff92000707f12
R10: dffffc0000000000 R11: fffff52000707f13 R12: 0000000000000003
R13: ffff888079527128 R14: fffff52000707f13 R15: 1ffff92000707f10
FS:  00007f4e567906c0(0000) GS:ffff888125cdc000(0000) knlGS:0000000000000000
CS:  0010 DS: 0000 ES: 0000 CR0: 0000000080050033
CR2: 000055db9a726918 CR3: 000000002ec48000 CR4: 00000000003526f0
Call Trace:
 <TASK>
 __asan_memset+0x22/0x50 mm/kasan/shadow.c:84
 seq_printf+0xad/0x270 fs/seq_file.c:403
 __io_uring_show_fdinfo io_uring/fdinfo.c:142 [inline]
 io_uring_show_fdinfo+0x734/0x17d0 io_uring/fdinfo.c:256
 seq_show+0x5bc/0x730 fs/proc/fd.c:68
 seq_read_iter+0x4ef/0xe20 fs/seq_file.c:230
 seq_read+0x369/0x480 fs/seq_file.c:162
 vfs_read+0x200/0xa30 fs/read_write.c:570
 ksys_read+0x145/0x250 fs/read_write.c:715
 do_syscall_x64 arch/x86/entry/syscall_64.c:63 [inline]
 do_syscall_64+0xfa/0xfa0 arch/x86/entry/syscall_64.c:94
 entry_SYSCALL_64_after_hwframe+0x77/0x7f
RIP: 0033:0x7f4e5598efc9
Code: ff ff c3 66 2e 0f 1f 84 00 00 00 00 00 0f 1f 40 00 48 89 f8 48 89 f7 48 89 d6 48 89 ca 4d 89 c2 4d 89 c8 4c 8b 4c 24 08 0f 05 <48> 3d 01 f0 ff ff 73 01 c3 48 c7 c1 a8 ff ff ff f7 d8 64 89 01 48
RSP: 002b:00007f4e56790038 EFLAGS: 00000246 ORIG_RAX: 0000000000000000
RAX: ffffffffffffffda RBX: 00007f4e55be6090 RCX: 00007f4e5598efc9
RDX: 0000000000002020 RSI: 00002000000040c0 RDI: 0000000000000004
RBP: 00007f4e55a11f91 R08: 0000000000000000 R09: 0000000000000000
R10: 0000000000000000 R11: 0000000000000246 R12: 0000000000000000
R13: 00007f4e55be6128 R14: 00007f4e55be6090 R15: 00007ffd5d16a678
 </TASK>


---
This report is generated by a bot. It may contain errors.
See https://goo.gl/tpsmEJ for more information about syzbot.
syzbot engineers can be reached at syzkaller@googlegroups.com.

syzbot will keep track of this issue. See:
https://goo.gl/tpsmEJ#status for how to communicate with syzbot.

If the report is already addressed, let syzbot know by replying with:
#syz fix: exact-commit-title

If you want syzbot to run the reproducer, reply with:
#syz test: git://repo/address.git branch-or-commit-hash
If you attach or paste a git patch, syzbot will apply it before testing.

If you want to overwrite report's subsystems, reply with:
#syz set subsystems: new-subsystem
(See the list of subsystem names on the web dashboard)

If the report is a duplicate of another one, reply with:
#syz dup: exact-subject-of-another-report

If you want to undo deduplication, reply with:
#syz undup

