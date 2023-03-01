Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 501C86A7355
	for <lists+io-uring@lfdr.de>; Wed,  1 Mar 2023 19:21:16 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229606AbjCASVO (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Wed, 1 Mar 2023 13:21:14 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:58528 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229515AbjCASVN (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Wed, 1 Mar 2023 13:21:13 -0500
Received: from mail-io1-f72.google.com (mail-io1-f72.google.com [209.85.166.72])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id D2FAF39BA0
        for <io-uring@vger.kernel.org>; Wed,  1 Mar 2023 10:21:11 -0800 (PST)
Received: by mail-io1-f72.google.com with SMTP id v10-20020a056602058a00b007076e06ba3dso9209011iox.20
        for <io-uring@vger.kernel.org>; Wed, 01 Mar 2023 10:21:11 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=to:from:subject:message-id:date:mime-version:x-gm-message-state
         :from:to:cc:subject:date:message-id:reply-to;
        bh=inptAgL1BoezTf1J4ilWI9gcDQQE95Nqr7+5/AqqGpw=;
        b=fGhWHSlHCEosKo5BX1ng7OUG5ARiRIGCJKtAhXJnk7aGG89XocpwlMw/hb6GcE8tM7
         lQafeC9tBF9YDSwiO2W9B1h8usdh4dCkEHHqP1SncodkoX8pj/Xai1vtrBEqMujg9w9H
         i5VkxZ2ybW+nZOsemN/NANn4YKYjJ8EXZ5Q+176p7ZetVEyLU6XFzUCJ8ruxifaQHY8f
         HP2IpsEW22IG8edGIELo+uD/ndyiJ2vc9IaTQ/p49OmFuhGlQ4hiYmuixNsPPjNc1tAG
         Td7mm6wNPhX8TGhXc/Eomz8n/HyMy46ahUN6Mp/d+DSj6V/XjmsJDpRBZbSRgX8yBPgr
         waTQ==
X-Gm-Message-State: AO0yUKVjB7p/dM4q1O7AK4H+uaDlNoUlrG0OgQhMx/V+wRNB81RW9QIR
        KNDGUSI3iJiIqudNCfJ5hCVH7ZPS8FKlz3WsiOJ1SJ2yKsdq
X-Google-Smtp-Source: AK7set/acmEvNgAzK6clGiGBlYe0dliFOGSBas4VYz8Vsn4Ogx9uO1rT2O4t8+MZNym2t1nYLET3J0chNmGYnujYKh56xE53DLRg
MIME-Version: 1.0
X-Received: by 2002:a02:9641:0:b0:3c5:1915:7d5 with SMTP id
 c59-20020a029641000000b003c5191507d5mr3440590jai.5.1677694871211; Wed, 01 Mar
 2023 10:21:11 -0800 (PST)
Date:   Wed, 01 Mar 2023 10:21:11 -0800
X-Google-Appengine-App-Id: s~syzkaller
X-Google-Appengine-App-Id-Alias: syzkaller
Message-ID: <000000000000d7144305f5dac6ef@google.com>
Subject: [syzbot] [io-uring?] INFO: task hung in sys_io_uring_register (2)
From:   syzbot <syzbot+eba3269b5fe4023dd5ad@syzkaller.appspotmail.com>
To:     asml.silence@gmail.com, axboe@kernel.dk, io-uring@vger.kernel.org,
        linux-kernel@vger.kernel.org, syzkaller-bugs@googlegroups.com
Content-Type: text/plain; charset="UTF-8"
X-Spam-Status: No, score=-1.6 required=5.0 tests=BAYES_00,FROM_LOCAL_HEX,
        HEADER_FROM_DIFFERENT_DOMAINS,RCVD_IN_DNSWL_NONE,RCVD_IN_MSPIKE_H2,
        SPF_HELO_NONE,SPF_PASS autolearn=no autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org

Hello,

syzbot found the following issue on:

HEAD commit:    489fa31ea873 Merge branch 'work.misc' of git://git.kernel...
git tree:       upstream
console+strace: https://syzkaller.appspot.com/x/log.txt?x=135829a8c80000
kernel config:  https://syzkaller.appspot.com/x/.config?x=cbfa7a73c540248d
dashboard link: https://syzkaller.appspot.com/bug?extid=eba3269b5fe4023dd5ad
compiler:       Debian clang version 15.0.7, GNU ld (GNU Binutils for Debian) 2.35.2
syz repro:      https://syzkaller.appspot.com/x/repro.syz?x=1632ceacc80000

Downloadable assets:
disk image: https://storage.googleapis.com/syzbot-assets/6bea5d39bf58/disk-489fa31e.raw.xz
vmlinux: https://storage.googleapis.com/syzbot-assets/265538df6fa2/vmlinux-489fa31e.xz
kernel image: https://storage.googleapis.com/syzbot-assets/8f0a643c86ea/bzImage-489fa31e.xz

IMPORTANT: if you fix the issue, please add the following tag to the commit:
Reported-by: syzbot+eba3269b5fe4023dd5ad@syzkaller.appspotmail.com

INFO: task syz-executor.1:5629 blocked for more than 143 seconds.
      Not tainted 6.2.0-syzkaller-10827-g489fa31ea873 #0
"echo 0 > /proc/sys/kernel/hung_task_timeout_secs" disables this message.
task:syz-executor.1  state:D stack:28664 pid:5629  ppid:5568   flags:0x00004004
Call Trace:
 <TASK>
 context_switch kernel/sched/core.c:5304 [inline]
 __schedule+0x17d8/0x4990 kernel/sched/core.c:6622
 schedule+0xc3/0x180 kernel/sched/core.c:6698
 schedule_preempt_disabled+0x13/0x20 kernel/sched/core.c:6757
 __mutex_lock_common+0xe33/0x2530 kernel/locking/mutex.c:679
 __mutex_lock kernel/locking/mutex.c:747 [inline]
 mutex_lock_nested+0x1b/0x20 kernel/locking/mutex.c:799
 __do_sys_io_uring_register io_uring/io_uring.c:4342 [inline]
 __se_sys_io_uring_register+0x1e5/0x15b0 io_uring/io_uring.c:4303
 do_syscall_x64 arch/x86/entry/common.c:50 [inline]
 do_syscall_64+0x41/0xc0 arch/x86/entry/common.c:80
 entry_SYSCALL_64_after_hwframe+0x63/0xcd
RIP: 0033:0x7f898ee8c0f9
RSP: 002b:00007f898fb4c168 EFLAGS: 00000246 ORIG_RAX: 00000000000001ab
RAX: ffffffffffffffda RBX: 00007f898efac050 RCX: 00007f898ee8c0f9
RDX: 0000000000000000 RSI: 0000000000000008 RDI: 0000000000000003
RBP: 00007f898eee7ae9 R08: 0000000000000000 R09: 0000000000000000
R10: 0000000000000000 R11: 0000000000000246 R12: 0000000000000000
R13: 00007fff8ddae53f R14: 00007f898fb4c300 R15: 0000000000022000
 </TASK>

Showing all locks held in the system:
2 locks held by kworker/u4:1/11:
1 lock held by rcu_tasks_kthre/12:
 #0: ffffffff8d127cf0 (rcu_tasks.tasks_gp_mutex){+.+.}-{3:3}, at: rcu_tasks_one_gp+0x29/0xd20 kernel/rcu/tasks.h:510
1 lock held by rcu_tasks_trace/13:
 #0: ffffffff8d1284f0 (rcu_tasks_trace.tasks_gp_mutex){+.+.}-{3:3}, at: rcu_tasks_one_gp+0x29/0xd20 kernel/rcu/tasks.h:510
2 locks held by kworker/1:1/26:
 #0: ffff888012472538 ((wq_completion)rcu_gp){+.+.}-{0:0}, at: process_one_work+0x77f/0x13a0
 #1: ffffc90000a1fd20 ((work_completion)(&rew->rew_work)){+.+.}-{0:0}, at: process_one_work+0x7c6/0x13a0 kernel/workqueue.c:2365
1 lock held by khungtaskd/28:
 #0: ffffffff8d127b20 (rcu_read_lock){....}-{1:2}, at: rcu_lock_acquire+0x0/0x30
4 locks held by kworker/u4:3/46:
 #0: ffff888016612938 ((wq_completion)netns){+.+.}-{0:0}, at: process_one_work+0x77f/0x13a0
 #1: ffffc90000b77d20 (net_cleanup_work){+.+.}-{0:0}, at: process_one_work+0x7c6/0x13a0 kernel/workqueue.c:2365
 #2: ffffffff8e28a2d0 (pernet_ops_rwsem){++++}-{3:3}, at: cleanup_net+0xf5/0xb80 net/core/net_namespace.c:575
 #3: ffffffff8e296848 (rtnl_mutex){+.+.}-{3:3}, at: tc_action_net_exit include/net/act_api.h:172 [inline]
 #3: ffffffff8e296848 (rtnl_mutex){+.+.}-{3:3}, at: gate_exit_net+0x30/0x100 net/sched/act_gate.c:658
3 locks held by kworker/1:2/1661:
 #0: ffff888012470d38 ((wq_completion)events){+.+.}-{0:0}, at: process_one_work+0x77f/0x13a0
 #1: ffffc90005f7fd20 ((linkwatch_work).work){+.+.}-{0:0}, at: process_one_work+0x7c6/0x13a0 kernel/workqueue.c:2365
 #2: ffffffff8e296848 (rtnl_mutex){+.+.}-{3:3}, at: linkwatch_event+0xe/0x60 net/core/link_watch.c:277
3 locks held by kworker/u4:6/3146:
2 locks held by getty/4751:
 #0: ffff88802c5c2098 (&tty->ldisc_sem){++++}-{0:0}, at: tty_ldisc_ref_wait+0x25/0x70 drivers/tty/tty_ldisc.c:244
 #1: ffffc900015902f0 (&ldata->atomic_read_lock){+.+.}-{3:3}, at: n_tty_read+0x6ab/0x1db0 drivers/tty/n_tty.c:2177
1 lock held by syz-executor.0/5388:
1 lock held by syz-executor.3/5405:
1 lock held by syz-executor.2/5484:
1 lock held by syz-executor.1/5486:
1 lock held by syz-executor.5/5496:
1 lock held by syz-executor.3/5555:
1 lock held by syz-executor.4/5584:
1 lock held by syz-executor.0/5594:
1 lock held by syz-executor.1/5628:
1 lock held by syz-executor.1/5629:
 #0: ffff88807fa300a8 (&ctx->uring_lock){+.+.}-{3:3}, at: __do_sys_io_uring_register io_uring/io_uring.c:4342 [inline]
 #0: ffff88807fa300a8 (&ctx->uring_lock){+.+.}-{3:3}, at: __se_sys_io_uring_register+0x1e5/0x15b0 io_uring/io_uring.c:4303
1 lock held by syz-executor.2/5631:
1 lock held by syz-executor.5/5657:
1 lock held by syz-executor.5/5658:
 #0: ffff8880295ba0a8 (&ctx->uring_lock){+.+.}-{3:3}, at: __do_sys_io_uring_register io_uring/io_uring.c:4342 [inline]
 #0: ffff8880295ba0a8 (&ctx->uring_lock){+.+.}-{3:3}, at: __se_sys_io_uring_register+0x1e5/0x15b0 io_uring/io_uring.c:4303
1 lock held by syz-executor.3/5665:
1 lock held by syz-executor.0/5811:
2 locks held by syz-executor.5/5826:
 #0: ffffffff8e296848 (rtnl_mutex){+.+.}-{3:3}, at: rtnl_lock net/core/rtnetlink.c:75 [inline]
 #0: ffffffff8e296848 (rtnl_mutex){+.+.}-{3:3}, at: rtnetlink_rcv_msg+0x7ce/0xf40 net/core/rtnetlink.c:6171
 #1: ffffffff8d12d1f8 (rcu_state.exp_mutex){+.+.}-{3:3}, at: exp_funnel_lock kernel/rcu/tree_exp.h:293 [inline]
 #1: ffffffff8d12d1f8 (rcu_state.exp_mutex){+.+.}-{3:3}, at: synchronize_rcu_expedited+0x3a3/0x890 kernel/rcu/tree_exp.h:989

=============================================

NMI backtrace for cpu 1
CPU: 1 PID: 28 Comm: khungtaskd Not tainted 6.2.0-syzkaller-10827-g489fa31ea873 #0
Hardware name: Google Google Compute Engine/Google Compute Engine, BIOS Google 02/16/2023
Call Trace:
 <TASK>
 __dump_stack lib/dump_stack.c:88 [inline]
 dump_stack_lvl+0x1e7/0x2d0 lib/dump_stack.c:106
 nmi_cpu_backtrace+0x4e5/0x560 lib/nmi_backtrace.c:113
 nmi_trigger_cpumask_backtrace+0x1b4/0x410 lib/nmi_backtrace.c:62
 trigger_all_cpu_backtrace include/linux/nmi.h:148 [inline]
 check_hung_uninterruptible_tasks kernel/hung_task.c:222 [inline]
 watchdog+0x1024/0x1070 kernel/hung_task.c:379
 kthread+0x270/0x300 kernel/kthread.c:376
 ret_from_fork+0x1f/0x30 arch/x86/entry/entry_64.S:308
 </TASK>
Sending NMI from CPU 1 to CPUs 0:
NMI backtrace for cpu 0
CPU: 0 PID: 5665 Comm: syz-executor.3 Not tainted 6.2.0-syzkaller-10827-g489fa31ea873 #0
Hardware name: Google Google Compute Engine/Google Compute Engine, BIOS Google 02/16/2023
RIP: 0010:io_prep_async_work+0x3/0x6b0 io_uring/io_uring.c:409
Code: e1 80 e1 07 80 c1 03 38 c1 0f 8c 1c ff ff ff 4c 89 e7 e8 10 c5 ad fd e9 0f ff ff ff 66 2e 0f 1f 84 00 00 00 00 00 90 55 41 57 <41> 56 41 55 41 54 53 48 83 ec 30 49 89 fd 49 bc 00 00 00 00 00 fc
RSP: 0018:ffffc900056e7b90 EFLAGS: 00000293
RAX: ffffffff84344cf5 RBX: ffff88805e00f8c0 RCX: ffff888021219d40
RDX: 0000000000000000 RSI: 0000000000000000 RDI: ffff88805e00f8c0
RBP: 0000000000000000 R08: ffffffff843565e4 R09: ffffffff8434c403
R10: 0000000000000003 R11: ffff888021219d40 R12: dffffc0000000000
R13: 1ffff1100b376234 R14: ffff888059bb1140 R15: ffff888059bb11a0
FS:  00007fc2b7aab700(0000) GS:ffff8880b9800000(0000) knlGS:0000000000000000
CS:  0010 DS: 0000 ES: 0000 CR0: 0000000080050033
CR2: 00005636566335c0 CR3: 00000000671e3000 CR4: 00000000003506f0
DR0: 0000000000000000 DR1: 0000000000000000 DR2: 0000000000000000
DR3: 0000000000000000 DR6: 00000000fffe0ff0 DR7: 0000000000000400
Call Trace:
 <TASK>
 io_prep_async_link io_uring/io_uring.c:449 [inline]
 io_queue_iowq+0x14b/0x6d0 io_uring/io_uring.c:462
 handle_tw_list io_uring/io_uring.c:1184 [inline]
 tctx_task_work+0x3d8/0xdc0 io_uring/io_uring.c:1246
 task_work_run+0x24a/0x300 kernel/task_work.c:179
 ptrace_notify+0x2cd/0x380 kernel/signal.c:2354
 ptrace_report_syscall include/linux/ptrace.h:411 [inline]
 ptrace_report_syscall_exit include/linux/ptrace.h:473 [inline]
 syscall_exit_work kernel/entry/common.c:251 [inline]
 syscall_exit_to_user_mode_prepare kernel/entry/common.c:278 [inline]
 __syscall_exit_to_user_mode_work kernel/entry/common.c:283 [inline]
 syscall_exit_to_user_mode+0x17a/0x2e0 kernel/entry/common.c:296
 do_syscall_64+0x4d/0xc0 arch/x86/entry/common.c:86
 entry_SYSCALL_64_after_hwframe+0x63/0xcd
RIP: 0033:0x7fc2b6c8c0f9
Code: 28 00 00 00 75 05 48 83 c4 28 c3 e8 f1 19 00 00 90 48 89 f8 48 89 f7 48 89 d6 48 89 ca 4d 89 c2 4d 89 c8 4c 8b 4c 24 08 0f 05 <48> 3d 01 f0 ff ff 73 01 c3 48 c7 c1 b8 ff ff ff f7 d8 64 89 01 48
RSP: 002b:00007fc2b7aab168 EFLAGS: 00000246 ORIG_RAX: 00000000000001aa
RAX: 00000000000040b3 RBX: 00007fc2b6dabf80 RCX: 00007fc2b6c8c0f9
RDX: 0000000000000000 RSI: 00000000000040b3 RDI: 0000000000000003
RBP: 00007fc2b6ce7ae9 R08: 0000000020000000 R09: 0000000000000008
R10: 0000000000000000 R11: 0000000000000246 R12: 0000000000000000
R13: 00007fff8e021b7f R14: 00007fc2b7aab300 R15: 0000000000022000
 </TASK>


---
This report is generated by a bot. It may contain errors.
See https://goo.gl/tpsmEJ for more information about syzbot.
syzbot engineers can be reached at syzkaller@googlegroups.com.

syzbot will keep track of this issue. See:
https://goo.gl/tpsmEJ#status for how to communicate with syzbot.
syzbot can test patches for this issue, for details see:
https://goo.gl/tpsmEJ#testing-patches
