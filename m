Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id E44632C21CC
	for <lists+io-uring@lfdr.de>; Tue, 24 Nov 2020 10:40:14 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1731552AbgKXJjT (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Tue, 24 Nov 2020 04:39:19 -0500
Received: from mail-il1-f199.google.com ([209.85.166.199]:52010 "EHLO
        mail-il1-f199.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1731477AbgKXJjS (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Tue, 24 Nov 2020 04:39:18 -0500
Received: by mail-il1-f199.google.com with SMTP id f8so16150243ilj.18
        for <io-uring@vger.kernel.org>; Tue, 24 Nov 2020 01:39:16 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:date:in-reply-to:message-id:subject
         :from:to;
        bh=oc7pctaeQ/N0g9YU6MzeOraJ/pitkOzDnbqGSnGuQfI=;
        b=P6o4mFc1xAVptZaAPfJdb1/oOeI1Jih7efeN4eijprxmkhbIpKEMnsY5dD6fPlzx56
         5sSJAX/DmjMFipOFg1qq98UdEbd1DwA+x4yqRcTxXzG4XlFDp+PdL9e25eaNXY8GYWsE
         LExjc/iOVwbVMzJmSGQB7hUZNFkioxAw3PmJUOxyYh8KE3x027PlyQJWcJsolxG2v7Lx
         2BA6Eq1oR7MnIbrxUPdo/a8D6SlqLUKc2jg9fHIA+0uq1vWC3LB7tfecycxGULWRWrfI
         buTRX2PHcxZ6hUowoYWoUGQhL0QaPOfesb/FjmyS7xU18j0uVY681+lDKAtagv0YgB4a
         E0lg==
X-Gm-Message-State: AOAM5331XIKAqr1Y0PMfwC8/HI8O9hS+yrRBkwtqhQdmW2k/R/Sm9oyj
        1B+tzpqKRYGLthukANkNukOymxejhFS/573jTaZSpKIxQfkK
X-Google-Smtp-Source: ABdhPJxjj7PeAqElqFdgdrGvoF64/zchsL9gMRulbX5Dj591+VmJoYT7iJBCOcW244LVqVoZBdjYGqi9slSyeUQYn3/3T+Sd5BxG
MIME-Version: 1.0
X-Received: by 2002:a02:6c09:: with SMTP id w9mr3533269jab.135.1606210755947;
 Tue, 24 Nov 2020 01:39:15 -0800 (PST)
Date:   Tue, 24 Nov 2020 01:39:15 -0800
In-Reply-To: <0000000000002bea4605b4a5931d@google.com>
X-Google-Appengine-App-Id: s~syzkaller
X-Google-Appengine-App-Id-Alias: syzkaller
Message-ID: <0000000000008af43105b4d71509@google.com>
Subject: Re: INFO: task hung in __io_uring_files_cancel
From:   syzbot <syzbot+c0d52d0b3c0c3ffb9525@syzkaller.appspotmail.com>
To:     asml.silence@gmail.com, axboe@kernel.dk, hdanton@sina.com,
        io-uring@vger.kernel.org, linux-fsdevel@vger.kernel.org,
        linux-kernel@vger.kernel.org, mingo@kernel.org, mingo@redhat.com,
        peterz@infradead.org, rostedt@goodmis.org,
        syzkaller-bugs@googlegroups.com, viro@zeniv.linux.org.uk,
        will@kernel.org
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org

syzbot has found a reproducer for the following issue on:

HEAD commit:    62918e6f Add linux-next specific files for 20201123
git tree:       linux-next
console output: https://syzkaller.appspot.com/x/log.txt?x=16efe369500000
kernel config:  https://syzkaller.appspot.com/x/.config?x=5c3a457d7bf812a8
dashboard link: https://syzkaller.appspot.com/bug?extid=c0d52d0b3c0c3ffb9525
compiler:       gcc (GCC) 10.1.0-syz 20200507
syz repro:      https://syzkaller.appspot.com/x/repro.syz?x=153ffcae500000
C reproducer:   https://syzkaller.appspot.com/x/repro.c?x=10b2120d500000

The issue was bisected to:

commit 4d004099a668c41522242aa146a38cc4eb59cb1e
Author: Peter Zijlstra <peterz@infradead.org>
Date:   Fri Oct 2 09:04:21 2020 +0000

    lockdep: Fix lockdep recursion

bisection log:  https://syzkaller.appspot.com/x/bisect.txt?x=10401726500000
final oops:     https://syzkaller.appspot.com/x/report.txt?x=12401726500000
console output: https://syzkaller.appspot.com/x/log.txt?x=14401726500000

IMPORTANT: if you fix the issue, please add the following tag to the commit:
Reported-by: syzbot+c0d52d0b3c0c3ffb9525@syzkaller.appspotmail.com
Fixes: 4d004099a668 ("lockdep: Fix lockdep recursion")

INFO: task syz-executor136:9222 blocked for more than 143 seconds.
      Not tainted 5.10.0-rc4-next-20201123-syzkaller #0
"echo 0 > /proc/sys/kernel/hung_task_timeout_secs" disables this message.
task:syz-executor136 state:D stack:28952 pid: 9222 ppid:  8504 flags:0x00004000
Call Trace:
 context_switch kernel/sched/core.c:4316 [inline]
 __schedule+0x896/0x2050 kernel/sched/core.c:5067
 schedule+0xcf/0x270 kernel/sched/core.c:5146
 io_uring_cancel_files fs/io_uring.c:8745 [inline]
 io_uring_cancel_task_requests fs/io_uring.c:8797 [inline]
 __io_uring_files_cancel+0xc4d/0x14b0 fs/io_uring.c:8893
 io_uring_files_cancel include/linux/io_uring.h:51 [inline]
 exit_files+0xe4/0x170 fs/file.c:456
 do_exit+0xb61/0x29f0 kernel/exit.c:818
 do_group_exit+0x125/0x310 kernel/exit.c:920
 get_signal+0x3ec/0x2010 kernel/signal.c:2770
 arch_do_signal_or_restart+0x2a8/0x1eb0 arch/x86/kernel/signal.c:811
 handle_signal_work kernel/entry/common.c:144 [inline]
 exit_to_user_mode_loop kernel/entry/common.c:168 [inline]
 exit_to_user_mode_prepare+0x124/0x200 kernel/entry/common.c:198
 syscall_exit_to_user_mode+0x36/0x260 kernel/entry/common.c:275
 entry_SYSCALL_64_after_hwframe+0x44/0xa9
RIP: 0033:0x446c69
RSP: 002b:00007f96da049da8 EFLAGS: 00000246 ORIG_RAX: 00000000000000ca
RAX: fffffffffffffe00 RBX: 00000000006dbc58 RCX: 0000000000446c69
RDX: 0000000000000000 RSI: 0000000000000080 RDI: 00000000006dbc58
RBP: 00000000006dbc50 R08: 0000000000000000 R09: 0000000000000000
R10: 0000000000000000 R11: 0000000000000246 R12: 00000000006dbc5c
R13: 0000000000000004 R14: 00007f96da04a9c0 R15: 000000000000002d
INFO: task syz-executor136:9685 blocked for more than 143 seconds.
      Not tainted 5.10.0-rc4-next-20201123-syzkaller #0
"echo 0 > /proc/sys/kernel/hung_task_timeout_secs" disables this message.
task:syz-executor136 state:D stack:28712 pid: 9685 ppid:  8502 flags:0x00004000
Call Trace:
 context_switch kernel/sched/core.c:4316 [inline]
 __schedule+0x896/0x2050 kernel/sched/core.c:5067
 schedule+0xcf/0x270 kernel/sched/core.c:5146
 io_uring_cancel_files fs/io_uring.c:8745 [inline]
 io_uring_cancel_task_requests fs/io_uring.c:8797 [inline]
 __io_uring_files_cancel+0xc4d/0x14b0 fs/io_uring.c:8893
 io_uring_files_cancel include/linux/io_uring.h:51 [inline]
 exit_files+0xe4/0x170 fs/file.c:456
 do_exit+0xb61/0x29f0 kernel/exit.c:818
 do_group_exit+0x125/0x310 kernel/exit.c:920
 get_signal+0x3ec/0x2010 kernel/signal.c:2770
 arch_do_signal_or_restart+0x2a8/0x1eb0 arch/x86/kernel/signal.c:811
 handle_signal_work kernel/entry/common.c:144 [inline]
 exit_to_user_mode_loop kernel/entry/common.c:168 [inline]
 exit_to_user_mode_prepare+0x124/0x200 kernel/entry/common.c:198
 syscall_exit_to_user_mode+0x36/0x260 kernel/entry/common.c:275
 entry_SYSCALL_64_after_hwframe+0x44/0xa9
RIP: 0033:0x446c69
RSP: 002b:00007f96da049da8 EFLAGS: 00000246 ORIG_RAX: 00000000000000ca
RAX: fffffffffffffe00 RBX: 00000000006dbc58 RCX: 0000000000446c69
RDX: 0000000000000000 RSI: 0000000000000080 RDI: 00000000006dbc58
RBP: 00000000006dbc50 R08: 0000000000000000 R09: 0000000000000000
R10: 0000000000000000 R11: 0000000000000246 R12: 00000000006dbc5c
R13: 0000000000000004 R14: 00007f96da04a9c0 R15: 000000000000002d

Showing all locks held in the system:
2 locks held by kworker/u4:3/102:
 #0: ffff888010069138 ((wq_completion)events_unbound){+.+.}-{0:0}, at: arch_atomic64_set arch/x86/include/asm/atomic64_64.h:34 [inline]
 #0: ffff888010069138 ((wq_completion)events_unbound){+.+.}-{0:0}, at: atomic64_set include/asm-generic/atomic-instrumented.h:856 [inline]
 #0: ffff888010069138 ((wq_completion)events_unbound){+.+.}-{0:0}, at: atomic_long_set include/asm-generic/atomic-long.h:41 [inline]
 #0: ffff888010069138 ((wq_completion)events_unbound){+.+.}-{0:0}, at: set_work_data kernel/workqueue.c:616 [inline]
 #0: ffff888010069138 ((wq_completion)events_unbound){+.+.}-{0:0}, at: set_work_pool_and_clear_pending kernel/workqueue.c:643 [inline]
 #0: ffff888010069138 ((wq_completion)events_unbound){+.+.}-{0:0}, at: process_one_work+0x821/0x15a0 kernel/workqueue.c:2243
 #1: ffff8880b9f20088 (&per_cpu_ptr(group->pcpu, cpu)->seq){-.-.}-{0:0}, at: psi_task_switch+0x305/0x440 kernel/sched/psi.c:833
1 lock held by khungtaskd/1644:
 #0: ffffffff8b339e60 (rcu_read_lock){....}-{1:2}, at: debug_show_all_locks+0x53/0x260 kernel/locking/lockdep.c:6254
1 lock held by in:imklog/8173:
 #0: ffff8880209594f0 (&f->f_pos_lock){+.+.}-{3:3}, at: __fdget_pos+0xe9/0x100 fs/file.c:932
2 locks held by kworker/u4:0/8560:
 #0: ffff888010069138 ((wq_completion)events_unbound){+.+.}-{0:0}, at: arch_atomic64_set arch/x86/include/asm/atomic64_64.h:34 [inline]
 #0: ffff888010069138 ((wq_completion)events_unbound){+.+.}-{0:0}, at: atomic64_set include/asm-generic/atomic-instrumented.h:856 [inline]
 #0: ffff888010069138 ((wq_completion)events_unbound){+.+.}-{0:0}, at: atomic_long_set include/asm-generic/atomic-long.h:41 [inline]
 #0: ffff888010069138 ((wq_completion)events_unbound){+.+.}-{0:0}, at: set_work_data kernel/workqueue.c:616 [inline]
 #0: ffff888010069138 ((wq_completion)events_unbound){+.+.}-{0:0}, at: set_work_pool_and_clear_pending kernel/workqueue.c:643 [inline]
 #0: ffff888010069138 ((wq_completion)events_unbound){+.+.}-{0:0}, at: process_one_work+0x821/0x15a0 kernel/workqueue.c:2243
 #1: ffffc900018efda8 ((work_completion)(&ctx->exit_work)){+.+.}-{0:0}, at: process_one_work+0x854/0x15a0 kernel/workqueue.c:2247
2 locks held by kworker/u4:11/28297:
 #0: ffff888010069138 ((wq_completion)events_unbound){+.+.}-{0:0}, at: arch_atomic64_set arch/x86/include/asm/atomic64_64.h:34 [inline]
 #0: ffff888010069138 ((wq_completion)events_unbound){+.+.}-{0:0}, at: atomic64_set include/asm-generic/atomic-instrumented.h:856 [inline]
 #0: ffff888010069138 ((wq_completion)events_unbound){+.+.}-{0:0}, at: atomic_long_set include/asm-generic/atomic-long.h:41 [inline]
 #0: ffff888010069138 ((wq_completion)events_unbound){+.+.}-{0:0}, at: set_work_data kernel/workqueue.c:616 [inline]
 #0: ffff888010069138 ((wq_completion)events_unbound){+.+.}-{0:0}, at: set_work_pool_and_clear_pending kernel/workqueue.c:643 [inline]
 #0: ffff888010069138 ((wq_completion)events_unbound){+.+.}-{0:0}, at: process_one_work+0x821/0x15a0 kernel/workqueue.c:2243
 #1: ffffc90003797da8 ((work_completion)(&ctx->exit_work)){+.+.}-{0:0}, at: process_one_work+0x854/0x15a0 kernel/workqueue.c:2247
2 locks held by kworker/u4:13/28309:
 #0: ffff888010069138 ((wq_completion)events_unbound){+.+.}-{0:0}, at: arch_atomic64_set arch/x86/include/asm/atomic64_64.h:34 [inline]
 #0: ffff888010069138 ((wq_completion)events_unbound){+.+.}-{0:0}, at: atomic64_set include/asm-generic/atomic-instrumented.h:856 [inline]
 #0: ffff888010069138 ((wq_completion)events_unbound){+.+.}-{0:0}, at: atomic_long_set include/asm-generic/atomic-long.h:41 [inline]
 #0: ffff888010069138 ((wq_completion)events_unbound){+.+.}-{0:0}, at: set_work_data kernel/workqueue.c:616 [inline]
 #0: ffff888010069138 ((wq_completion)events_unbound){+.+.}-{0:0}, at: set_work_pool_and_clear_pending kernel/workqueue.c:643 [inline]
 #0: ffff888010069138 ((wq_completion)events_unbound){+.+.}-{0:0}, at: process_one_work+0x821/0x15a0 kernel/workqueue.c:2243
 #1: ffffc900037b7da8 ((work_completion)(&ctx->exit_work)){+.+.}-{0:0}, at: process_one_work+0x854/0x15a0 kernel/workqueue.c:2247
2 locks held by kworker/u4:15/28331:
 #0: ffff888010069138 ((wq_completion)events_unbound){+.+.}-{0:0}, at: arch_atomic64_set arch/x86/include/asm/atomic64_64.h:34 [inline]
 #0: ffff888010069138 ((wq_completion)events_unbound){+.+.}-{0:0}, at: atomic64_set include/asm-generic/atomic-instrumented.h:856 [inline]
 #0: ffff888010069138 ((wq_completion)events_unbound){+.+.}-{0:0}, at: atomic_long_set include/asm-generic/atomic-long.h:41 [inline]
 #0: ffff888010069138 ((wq_completion)events_unbound){+.+.}-{0:0}, at: set_work_data kernel/workqueue.c:616 [inline]
 #0: ffff888010069138 ((wq_completion)events_unbound){+.+.}-{0:0}, at: set_work_pool_and_clear_pending kernel/workqueue.c:643 [inline]
 #0: ffff888010069138 ((wq_completion)events_unbound){+.+.}-{0:0}, at: process_one_work+0x821/0x15a0 kernel/workqueue.c:2243
 #1: ffffc90003567da8 ((work_completion)(&ctx->exit_work)){+.+.}-{0:0}, at: process_one_work+0x854/0x15a0 kernel/workqueue.c:2247
2 locks held by kworker/u4:16/28341:
 #0: ffff888010069138 ((wq_completion)events_unbound){+.+.}-{0:0}, at: arch_atomic64_set arch/x86/include/asm/atomic64_64.h:34 [inline]
 #0: ffff888010069138 ((wq_completion)events_unbound){+.+.}-{0:0}, at: atomic64_set include/asm-generic/atomic-instrumented.h:856 [inline]
 #0: ffff888010069138 ((wq_completion)events_unbound){+.+.}-{0:0}, at: atomic_long_set include/asm-generic/atomic-long.h:41 [inline]
 #0: ffff888010069138 ((wq_completion)events_unbound){+.+.}-{0:0}, at: set_work_data kernel/workqueue.c:616 [inline]
 #0: ffff888010069138 ((wq_completion)events_unbound){+.+.}-{0:0}, at: set_work_pool_and_clear_pending kernel/workqueue.c:643 [inline]
 #0: ffff888010069138 ((wq_completion)events_unbound){+.+.}-{0:0}, at: process_one_work+0x821/0x15a0 kernel/workqueue.c:2243
 #1: ffffc90003987da8 ((work_completion)(&ctx->exit_work)){+.+.}-{0:0}, at: process_one_work+0x854/0x15a0 kernel/workqueue.c:2247
2 locks held by kworker/u4:17/28345:
 #0: ffff888010069138 ((wq_completion)events_unbound){+.+.}-{0:0}, at: arch_atomic64_set arch/x86/include/asm/atomic64_64.h:34 [inline]
 #0: ffff888010069138 ((wq_completion)events_unbound){+.+.}-{0:0}, at: atomic64_set include/asm-generic/atomic-instrumented.h:856 [inline]
 #0: ffff888010069138 ((wq_completion)events_unbound){+.+.}-{0:0}, at: atomic_long_set include/asm-generic/atomic-long.h:41 [inline]
 #0: ffff888010069138 ((wq_completion)events_unbound){+.+.}-{0:0}, at: set_work_data kernel/workqueue.c:616 [inline]
 #0: ffff888010069138 ((wq_completion)events_unbound){+.+.}-{0:0}, at: set_work_pool_and_clear_pending kernel/workqueue.c:643 [inline]
 #0: ffff888010069138 ((wq_completion)events_unbound){+.+.}-{0:0}, at: process_one_work+0x821/0x15a0 kernel/workqueue.c:2243
 #1: ffffc900038f7da8 ((work_completion)(&ctx->exit_work)){+.+.}-{0:0}, at: process_one_work+0x854/0x15a0 kernel/workqueue.c:2247
2 locks held by kworker/u4:18/28349:
 #0: ffff888010069138 ((wq_completion)events_unbound){+.+.}-{0:0}, at: arch_atomic64_set arch/x86/include/asm/atomic64_64.h:34 [inline]
 #0: ffff888010069138 ((wq_completion)events_unbound){+.+.}-{0:0}, at: atomic64_set include/asm-generic/atomic-instrumented.h:856 [inline]
 #0: ffff888010069138 ((wq_completion)events_unbound){+.+.}-{0:0}, at: atomic_long_set include/asm-generic/atomic-long.h:41 [inline]
 #0: ffff888010069138 ((wq_completion)events_unbound){+.+.}-{0:0}, at: set_work_data kernel/workqueue.c:616 [inline]
 #0: ffff888010069138 ((wq_completion)events_unbound){+.+.}-{0:0}, at: set_work_pool_and_clear_pending kernel/workqueue.c:643 [inline]
 #0: ffff888010069138 ((wq_completion)events_unbound){+.+.}-{0:0}, at: process_one_work+0x821/0x15a0 kernel/workqueue.c:2243
 #1: ffffc900039b7da8 ((work_completion)(&ctx->exit_work)){+.+.}-{0:0}, at: process_one_work+0x854/0x15a0 kernel/workqueue.c:2247
2 locks held by kworker/u4:19/28360:
 #0: ffff888010069138 ((wq_completion)events_unbound){+.+.}-{0:0}, at: arch_atomic64_set arch/x86/include/asm/atomic64_64.h:34 [inline]
 #0: ffff888010069138 ((wq_completion)events_unbound){+.+.}-{0:0}, at: atomic64_set include/asm-generic/atomic-instrumented.h:856 [inline]
 #0: ffff888010069138 ((wq_completion)events_unbound){+.+.}-{0:0}, at: atomic_long_set include/asm-generic/atomic-long.h:41 [inline]
 #0: ffff888010069138 ((wq_completion)events_unbound){+.+.}-{0:0}, at: set_work_data kernel/workqueue.c:616 [inline]
 #0: ffff888010069138 ((wq_completion)events_unbound){+.+.}-{0:0}, at: set_work_pool_and_clear_pending kernel/workqueue.c:643 [inline]
 #0: ffff888010069138 ((wq_completion)events_unbound){+.+.}-{0:0}, at: process_one_work+0x821/0x15a0 kernel/workqueue.c:2243
 #1: ffffc900038e7da8 ((work_completion)(&ctx->exit_work)){+.+.}-{0:0}, at: process_one_work+0x854/0x15a0 kernel/workqueue.c:2247
2 locks held by kworker/u4:20/28362:
 #0: ffff888010069138 ((wq_completion)events_unbound){+.+.}-{0:0}, at: arch_atomic64_set arch/x86/include/asm/atomic64_64.h:34 [inline]
 #0: ffff888010069138 ((wq_completion)events_unbound){+.+.}-{0:0}, at: atomic64_set include/asm-generic/atomic-instrumented.h:856 [inline]
 #0: ffff888010069138 ((wq_completion)events_unbound){+.+.}-{0:0}, at: atomic_long_set include/asm-generic/atomic-long.h:41 [inline]
 #0: ffff888010069138 ((wq_completion)events_unbound){+.+.}-{0:0}, at: set_work_data kernel/workqueue.c:616 [inline]
 #0: ffff888010069138 ((wq_completion)events_unbound){+.+.}-{0:0}, at: set_work_pool_and_clear_pending kernel/workqueue.c:643 [inline]
 #0: ffff888010069138 ((wq_completion)events_unbound){+.+.}-{0:0}, at: process_one_work+0x821/0x15a0 kernel/workqueue.c:2243
 #1: ffffc900039d7da8 ((work_completion)(&ctx->exit_work)){+.+.}-{0:0}, at: process_one_work+0x854/0x15a0 kernel/workqueue.c:2247
2 locks held by kworker/u4:21/28363:
 #0: ffff888010069138 ((wq_completion)events_unbound){+.+.}-{0:0}, at: arch_atomic64_set arch/x86/include/asm/atomic64_64.h:34 [inline]
 #0: ffff888010069138 ((wq_completion)events_unbound){+.+.}-{0:0}, at: atomic64_set include/asm-generic/atomic-instrumented.h:856 [inline]
 #0: ffff888010069138 ((wq_completion)events_unbound){+.+.}-{0:0}, at: atomic_long_set include/asm-generic/atomic-long.h:41 [inline]
 #0: ffff888010069138 ((wq_completion)events_unbound){+.+.}-{0:0}, at: set_work_data kernel/workqueue.c:616 [inline]
 #0: ffff888010069138 ((wq_completion)events_unbound){+.+.}-{0:0}, at: set_work_pool_and_clear_pending kernel/workqueue.c:643 [inline]
 #0: ffff888010069138 ((wq_completion)events_unbound){+.+.}-{0:0}, at: process_one_work+0x821/0x15a0 kernel/workqueue.c:2243
 #1: ffffc90003787da8 ((work_completion)(&ctx->exit_work)){+.+.}-{0:0}, at: process_one_work+0x854/0x15a0 kernel/workqueue.c:2247
3 locks held by syz-executor136/28466:

=============================================

NMI backtrace for cpu 1
CPU: 1 PID: 1644 Comm: khungtaskd Not tainted 5.10.0-rc4-next-20201123-syzkaller #0
Hardware name: Google Google Compute Engine/Google Compute Engine, BIOS Google 01/01/2011
Call Trace:
 __dump_stack lib/dump_stack.c:79 [inline]
 dump_stack+0x107/0x163 lib/dump_stack.c:120
 nmi_cpu_backtrace.cold+0x44/0xd7 lib/nmi_backtrace.c:105
 nmi_trigger_cpumask_backtrace+0x1b3/0x230 lib/nmi_backtrace.c:62
 trigger_all_cpu_backtrace include/linux/nmi.h:147 [inline]
 check_hung_uninterruptible_tasks kernel/hung_task.c:253 [inline]
 watchdog+0xd89/0xf30 kernel/hung_task.c:338
 kthread+0x3b1/0x4a0 kernel/kthread.c:292
 ret_from_fork+0x1f/0x30 arch/x86/entry/entry_64.S:296
Sending NMI from CPU 1 to CPUs 0:
NMI backtrace for cpu 0
CPU: 0 PID: 28469 Comm: io_wqe_worker-0 Not tainted 5.10.0-rc4-next-20201123-syzkaller #0
Hardware name: Google Google Compute Engine/Google Compute Engine, BIOS Google 01/01/2011
RIP: 0010:get_current arch/x86/include/asm/current.h:15 [inline]
RIP: 0010:__sanitizer_cov_trace_pc+0x0/0x60 kernel/kcov.c:196
Code: fc ff ff 48 c7 c7 c0 01 39 8b 48 89 54 24 08 48 89 34 24 e8 d2 7a 60 02 48 8b 54 24 08 48 8b 34 24 e9 a1 fd ff ff 0f 1f 40 00 <65> 48 8b 14 25 00 f0 01 00 65 8b 05 90 64 91 7e a9 00 01 ff 00 48
RSP: 0018:ffffc90003e3fc48 EFLAGS: 00000046
RAX: 0000000000000000 RBX: ffffc90003e3fd58 RCX: ffffffff81600e1b
RDX: 0000000000000000 RSI: ffff888147e63580 RDI: 0000000000000001
RBP: 0000000000000000 R08: 0000000000000000 R09: ffffffff8ced564f
R10: 0000000000000000 R11: 0000000000000000 R12: 0000000000000001
R13: ffffc90003e3fd60 R14: 0000000000000293 R15: ffff888147e1c800
FS:  0000000000000000(0000) GS:ffff8880b9e00000(0000) knlGS:0000000000000000
CS:  0010 DS: 0000 ES: 0000 CR0: 0000000080050033
CR2: 000000002001d06c CR3: 0000000013499000 CR4: 00000000001506f0
DR0: 0000000000000000 DR1: 0000000000000000 DR2: 0000000000000000
DR3: 0000000000000000 DR6: 00000000fffe0ff0 DR7: 0000000000000400
Call Trace:
 __hlist_del include/linux/list.h:835 [inline]
 detach_timer kernel/time/timer.c:825 [inline]
 detach_if_pending+0xee/0x470 kernel/time/timer.c:844
 try_to_del_timer_sync+0xaa/0x110 kernel/time/timer.c:1232
 del_timer_sync+0xf5/0x160 kernel/time/timer.c:1378
 schedule_timeout+0x150/0x250 kernel/time/timer.c:1879
 io_wqe_worker+0x5b4/0x10e0 fs/io-wq.c:625
 kthread+0x3b1/0x4a0 kernel/kthread.c:292
 ret_from_fork+0x1f/0x30 arch/x86/entry/entry_64.S:296

