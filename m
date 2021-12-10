Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 23E5D46FF41
	for <lists+io-uring@lfdr.de>; Fri, 10 Dec 2021 12:00:10 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S240154AbhLJLDm (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Fri, 10 Dec 2021 06:03:42 -0500
Received: from mail-io1-f72.google.com ([209.85.166.72]:55230 "EHLO
        mail-io1-f72.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S240145AbhLJLDm (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Fri, 10 Dec 2021 06:03:42 -0500
Received: by mail-io1-f72.google.com with SMTP id s8-20020a056602168800b005e96bba1363so9862679iow.21
        for <io-uring@vger.kernel.org>; Fri, 10 Dec 2021 03:00:07 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:mime-version:date:in-reply-to:message-id:subject
         :from:to;
        bh=ky47CS5b/GZtSAGbTKm4wBz2ZlS4+3Wkce0HEoc8hYk=;
        b=MLhQnPnHBZRwQaxc3RupTfFqtELlyRE7kMVE48O9rGRQmb9kf0jF5CAineVasEabQm
         SllT0+BjrIVa0vTQ/dstxl/rg1cduN+uYgRxlakCs9/RtB+rAGch2qJYNxMgXyr3zUv4
         UhiM1K3qwysxmlskrZMyh8W6QHDabaX8ZD8qE+lebh0tRxR3eP7JCO01idQ6OJgsnXUV
         SXsg8JNqblv+nkfd7cGmlzq038sPRDwAxOF3Jpx1/3118yoL8kR6Hus2Y4MmC5Bz6c+E
         SNXvjjB39dm/msMAtZTDNCOInWdUJyoktrek1etY+kKQABGICr2xTTWDSbrEZTeEJYLe
         ux0Q==
X-Gm-Message-State: AOAM532Sbp9CGWGUqh+mK1YCUUxIOR8k51q3e8hu8Rp95f4TstOT1M50
        gLvM2ybUM6nLo7qjRIjvv493+u9QlzQXLKD77zxNvQf902qv
X-Google-Smtp-Source: ABdhPJzb+JSffVVZYa4GNka/uATapAWQJxKepQ6NiVxnXrf8pe5dGsPOI3ZsIKgFHo4ynOJgHpT8v3v5GHwax5+OWiap7XXojpSs
MIME-Version: 1.0
X-Received: by 2002:a05:6602:1345:: with SMTP id i5mr19652409iov.164.1639134007184;
 Fri, 10 Dec 2021 03:00:07 -0800 (PST)
Date:   Fri, 10 Dec 2021 03:00:07 -0800
In-Reply-To: <9db849c7-f998-dec6-5553-1d2670389204@kernel.dk>
X-Google-Appengine-App-Id: s~syzkaller
X-Google-Appengine-App-Id-Alias: syzkaller
Message-ID: <0000000000003cd27305d2c8a028@google.com>
Subject: Re: [syzbot] KASAN: use-after-free Write in io_queue_worker_create
From:   syzbot <syzbot+b60c982cb0efc5e05a47@syzkaller.appspotmail.com>
To:     asml.silence@gmail.com, axboe@kernel.dk, io-uring@vger.kernel.org,
        linux-kernel@vger.kernel.org, syzkaller-bugs@googlegroups.com
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org

Hello,

syzbot has tested the proposed patch but the reproducer is still triggering an issue:
INFO: task hung in io_wq_put_and_exit

INFO: task syz-executor.2:8594 blocked for more than 143 seconds.
      Not tainted 5.16.0-rc1-syzkaller #0
"echo 0 > /proc/sys/kernel/hung_task_timeout_secs" disables this message.
task:syz-executor.2  state:D stack:26928 pid: 8594 ppid:  3894 flags:0x00024004
Call Trace:
 <TASK>
 context_switch kernel/sched/core.c:4972 [inline]
 __schedule+0xa9a/0x4940 kernel/sched/core.c:6253
 schedule+0xd2/0x260 kernel/sched/core.c:6326
 schedule_timeout+0x1db/0x2a0 kernel/time/timer.c:1857
 do_wait_for_common kernel/sched/completion.c:85 [inline]
 __wait_for_common kernel/sched/completion.c:106 [inline]
 wait_for_common kernel/sched/completion.c:117 [inline]
 wait_for_completion+0x174/0x270 kernel/sched/completion.c:138
 io_wq_exit_workers fs/io-wq.c:1222 [inline]
 io_wq_put_and_exit+0x33a/0xb70 fs/io-wq.c:1257
 io_uring_clean_tctx fs/io_uring.c:9803 [inline]
 io_uring_cancel_generic+0x622/0x695 fs/io_uring.c:9886
 io_uring_files_cancel include/linux/io_uring.h:16 [inline]
 do_exit+0x60c/0x2b40 kernel/exit.c:787
 do_group_exit+0x125/0x310 kernel/exit.c:929
 get_signal+0x47d/0x2220 kernel/signal.c:2830
 arch_do_signal_or_restart+0x2a9/0x1c40 arch/x86/kernel/signal.c:868
 handle_signal_work kernel/entry/common.c:148 [inline]
 exit_to_user_mode_loop kernel/entry/common.c:172 [inline]
 exit_to_user_mode_prepare+0x17d/0x290 kernel/entry/common.c:207
 __syscall_exit_to_user_mode_work kernel/entry/common.c:289 [inline]
 syscall_exit_to_user_mode+0x19/0x60 kernel/entry/common.c:300
 do_syscall_64+0x42/0xb0 arch/x86/entry/common.c:86
 entry_SYSCALL_64_after_hwframe+0x44/0xae
RIP: 0033:0x7fe940cbfb49
RSP: 002b:00007fe940435218 EFLAGS: 00000246 ORIG_RAX: 00000000000000ca
RAX: fffffffffffffe00 RBX: 00007fe940dd2f68 RCX: 00007fe940cbfb49
RDX: 0000000000000000 RSI: 0000000000000080 RDI: 00007fe940dd2f68
RBP: 00007fe940dd2f60 R08: 0000000000000000 R09: 0000000000000000
R10: 0000000000000000 R11: 0000000000000246 R12: 00007fe940dd2f6c
R13: 00007ffc1b1af90f R14: 00007fe940435300 R15: 0000000000022000
 </TASK>

Showing all locks held in the system:
1 lock held by khungtaskd/27:
 #0: ffffffff8bb83a60 (rcu_read_lock){....}-{1:2}, at: debug_show_all_locks+0x53/0x260 kernel/locking/lockdep.c:6458
2 locks held by getty/3278:
 #0: ffff888023517098 (&tty->ldisc_sem){++++}-{0:0}, at: tty_ldisc_ref_wait+0x22/0x80 drivers/tty/tty_ldisc.c:252
 #1: ffffc90002b962e8 (&ldata->atomic_read_lock){+.+.}-{3:3}, at: n_tty_read+0xcf0/0x1230 drivers/tty/n_tty.c:2113
2 locks held by kworker/u4:8/4544:
 #0: ffff8880b9d39a98 (&rq->__lock){-.-.}-{2:2}, at: raw_spin_rq_lock_nested+0x2b/0x120 kernel/sched/core.c:478
 #1: ffffc900038bfdb0 ((work_completion)(&(&bat_priv->nc.work)->work)){+.+.}-{0:0}, at: process_one_work+0x8ca/0x1690 kernel/workqueue.c:2273

=============================================

NMI backtrace for cpu 0
CPU: 0 PID: 27 Comm: khungtaskd Not tainted 5.16.0-rc1-syzkaller #0
Hardware name: Google Google Compute Engine/Google Compute Engine, BIOS Google 01/01/2011
Call Trace:
 <TASK>
 __dump_stack lib/dump_stack.c:88 [inline]
 dump_stack_lvl+0xcd/0x134 lib/dump_stack.c:106
 nmi_cpu_backtrace.cold+0x47/0x144 lib/nmi_backtrace.c:105
 nmi_trigger_cpumask_backtrace+0x1ae/0x220 lib/nmi_backtrace.c:62
 trigger_all_cpu_backtrace include/linux/nmi.h:146 [inline]
 check_hung_uninterruptible_tasks kernel/hung_task.c:210 [inline]
 watchdog+0xc1d/0xf50 kernel/hung_task.c:295
 kthread+0x405/0x4f0 kernel/kthread.c:327
 ret_from_fork+0x1f/0x30 arch/x86/entry/entry_64.S:295
 </TASK>
Sending NMI from CPU 0 to CPUs 1:
NMI backtrace for cpu 1
CPU: 1 PID: 4355 Comm: kworker/u4:7 Not tainted 5.16.0-rc1-syzkaller #0
Hardware name: Google Google Compute Engine/Google Compute Engine, BIOS Google 01/01/2011
Workqueue: phy12 ieee80211_iface_work
RIP: 0010:mark_lock+0x27/0x17b0 kernel/locking/lockdep.c:4566
Code: 00 00 90 41 57 41 56 41 55 41 54 41 89 d4 48 ba 00 00 00 00 00 fc ff df 55 53 48 81 ec 18 01 00 00 48 8d 5c 24 38 48 89 3c 24 <48> c7 44 24 38 b3 8a b5 41 48 c1 eb 03 48 c7 44 24 40 e0 66 37 8b
RSP: 0018:ffffc90002dbf380 EFLAGS: 00000082
RAX: 0000000000000004 RBX: ffffc90002dbf3b8 RCX: 1ffffffff1b228f1
RDX: dffffc0000000000 RSI: ffff88801d8fe160 RDI: ffff88801d8fd700
RBP: 0000000000000002 R08: 0000000000000000 R09: 0000000000000001
R10: ffffffff817e2bc8 R11: 0000000000000000 R12: 0000000000000002
R13: dffffc0000000000 R14: ffff88801d8fe160 R15: 000000000003d510
FS:  0000000000000000(0000) GS:ffff8880b9d00000(0000) knlGS:0000000000000000
CS:  0010 DS: 0000 ES: 0000 CR0: 0000000080050033
CR2: 000055de5437a600 CR3: 000000000b88e000 CR4: 0000000000350ee0
Call Trace:
 <TASK>
 mark_held_locks+0x9f/0xe0 kernel/locking/lockdep.c:4206
 __trace_hardirqs_on_caller kernel/locking/lockdep.c:4224 [inline]
 lockdep_hardirqs_on_prepare kernel/locking/lockdep.c:4292 [inline]
 lockdep_hardirqs_on_prepare+0x135/0x400 kernel/locking/lockdep.c:4244
 trace_hardirqs_on+0x5b/0x1c0 kernel/trace/trace_preemptirq.c:49
 ___slab_alloc+0xc41/0xfe0 mm/slub.c:2978
 __slab_alloc.constprop.0+0x4d/0xa0 mm/slub.c:3109
 slab_alloc_node mm/slub.c:3200 [inline]
 slab_alloc mm/slub.c:3242 [inline]
 __kmalloc+0x2fb/0x340 mm/slub.c:4419
 kmalloc include/linux/slab.h:595 [inline]
 kzalloc include/linux/slab.h:724 [inline]
 cfg80211_inform_single_bss_frame_data+0x302/0xee0 net/wireless/scan.c:2397
 cfg80211_inform_bss_frame_data+0xa7/0xb50 net/wireless/scan.c:2458
 ieee80211_bss_info_update+0x35b/0xb30 net/mac80211/scan.c:190
 ieee80211_rx_bss_info net/mac80211/ibss.c:1119 [inline]
 ieee80211_rx_mgmt_probe_beacon net/mac80211/ibss.c:1610 [inline]
 ieee80211_ibss_rx_queued_mgmt+0x19cf/0x3130 net/mac80211/ibss.c:1639
 ieee80211_iface_process_skb net/mac80211/iface.c:1466 [inline]
 ieee80211_iface_work+0xa65/0xd00 net/mac80211/iface.c:1520
 process_one_work+0x9b2/0x1690 kernel/workqueue.c:2298
 worker_thread+0x658/0x11f0 kernel/workqueue.c:2445
 kthread+0x405/0x4f0 kernel/kthread.c:327
 ret_from_fork+0x1f/0x30 arch/x86/entry/entry_64.S:295
 </TASK>
----------------
Code disassembly (best guess):
   0:	00 00                	add    %al,(%rax)
   2:	90                   	nop
   3:	41 57                	push   %r15
   5:	41 56                	push   %r14
   7:	41 55                	push   %r13
   9:	41 54                	push   %r12
   b:	41 89 d4             	mov    %edx,%r12d
   e:	48 ba 00 00 00 00 00 	movabs $0xdffffc0000000000,%rdx
  15:	fc ff df
  18:	55                   	push   %rbp
  19:	53                   	push   %rbx
  1a:	48 81 ec 18 01 00 00 	sub    $0x118,%rsp
  21:	48 8d 5c 24 38       	lea    0x38(%rsp),%rbx
  26:	48 89 3c 24          	mov    %rdi,(%rsp)
* 2a:	48 c7 44 24 38 b3 8a 	movq   $0x41b58ab3,0x38(%rsp) <-- trapping instruction
  31:	b5 41
  33:	48 c1 eb 03          	shr    $0x3,%rbx
  37:	48 c7 44 24 40 e0 66 	movq   $0xffffffff8b3766e0,0x40(%rsp)
  3e:	37 8b


Tested on:

commit:         02a3f9f3 io_uring: ensure task_work gets run as part o..
git tree:       git://git.kernel.dk/linux-block io_uring-5.16
console output: https://syzkaller.appspot.com/x/log.txt?x=1037614db00000
kernel config:  https://syzkaller.appspot.com/x/.config?x=6d3b8fd1977c1e73
dashboard link: https://syzkaller.appspot.com/bug?extid=b60c982cb0efc5e05a47
compiler:       gcc (Debian 10.2.1-6) 10.2.1 20210110, GNU ld (GNU Binutils for Debian) 2.35.2

