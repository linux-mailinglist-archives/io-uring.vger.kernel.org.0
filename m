Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id E9A3E357BAD
	for <lists+io-uring@lfdr.de>; Thu,  8 Apr 2021 07:05:07 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229637AbhDHFFR (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Thu, 8 Apr 2021 01:05:17 -0400
Received: from mail-io1-f71.google.com ([209.85.166.71]:47877 "EHLO
        mail-io1-f71.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229623AbhDHFFQ (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Thu, 8 Apr 2021 01:05:16 -0400
Received: by mail-io1-f71.google.com with SMTP id t25so558273iog.14
        for <io-uring@vger.kernel.org>; Wed, 07 Apr 2021 22:05:05 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:date:in-reply-to:message-id:subject
         :from:to;
        bh=KjpGO78h4qjAE1du5rCaY3cTwtB8YsoNZ737Trk6/QY=;
        b=MBjvx+QxIgjXz0AUhpPfTKEMejWYcOO9TWkBYE/n7gf/B7q0HPIsZrCNrzQj3NzreZ
         MRoYPOrsNYAtrIt7980QClplQo4LpSJDXbCvh17sYiN7NznXeAXY7u9kOIiVhk04w4Kn
         Sy95rVuDvNw6tnD70Ps6jFPbR74w8wtvKVqYUKCOXH4DcXIixFUVL4r+9+vm10PtoxWl
         gV6lurtpwSlVkEd4i/kqohrim2DtXBXSnYkrVuvoh3e9FjH39Mqn2oJssTUSePRtBCVN
         s+mp/rbYc9ZhHHyvCfnb/odL9vRZeyUJjubpJA4WwqG9ilvODQ8OP8F6Nuemy9rKdLyc
         wvQA==
X-Gm-Message-State: AOAM532HCOmvoMxEV7qRGpeoYKmvBbneMfsQoFqDoM7d2gko36Z5Kvo1
        MB8xoD0nxxdiwZXSxWAdHjKlsHEa6tm/YtJpN1WA3z5HKs8G
X-Google-Smtp-Source: ABdhPJxX9pevaxffCbQ7JADxP3J8Mm5KxnaqkOjgt8vB58wBXjZePj/GdeoOjgXlN30GIJTvsIWiliGSplz15Lf4MUPrtXsYLcti
MIME-Version: 1.0
X-Received: by 2002:a92:d308:: with SMTP id x8mr5442874ila.301.1617858305144;
 Wed, 07 Apr 2021 22:05:05 -0700 (PDT)
Date:   Wed, 07 Apr 2021 22:05:05 -0700
In-Reply-To: <cc7890c0-2f48-881a-9b52-473716369626@gmail.com>
X-Google-Appengine-App-Id: s~syzkaller
X-Google-Appengine-App-Id-Alias: syzkaller
Message-ID: <000000000000933dd705bf6efd97@google.com>
Subject: Re: [syzbot] INFO: task hung in io_ring_exit_work
From:   syzbot <syzbot+93f72b3885406bb09e0d@syzkaller.appspotmail.com>
To:     asml.silence@gmail.com, axboe@kernel.dk, io-uring@vger.kernel.org,
        linux-kernel@vger.kernel.org, syzkaller-bugs@googlegroups.com
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org

Hello,

syzbot has tested the proposed patch but the reproducer is still triggering an issue:
INFO: task hung in io_ring_exit_work

INFO: task kworker/u4:0:9 blocked for more than 143 seconds.
      Not tainted 5.12.0-rc2-syzkaller #0
"echo 0 > /proc/sys/kernel/hung_task_timeout_secs" disables this message.
task:kworker/u4:0    state:D stack:26336 pid:    9 ppid:     2 flags:0x00004000
Workqueue: events_unbound io_ring_exit_work
Call Trace:
 context_switch kernel/sched/core.c:4324 [inline]
 __schedule+0x911/0x21b0 kernel/sched/core.c:5075
 schedule+0xcf/0x270 kernel/sched/core.c:5154
 schedule_timeout+0x1db/0x250 kernel/time/timer.c:1868
 do_wait_for_common kernel/sched/completion.c:85 [inline]
 __wait_for_common kernel/sched/completion.c:106 [inline]
 wait_for_common kernel/sched/completion.c:117 [inline]
 wait_for_completion+0x168/0x270 kernel/sched/completion.c:138
 io_ring_exit_work+0x4e8/0x12d0 fs/io_uring.c:8611
 process_one_work+0x98d/0x1600 kernel/workqueue.c:2275
 worker_thread+0x64c/0x1120 kernel/workqueue.c:2421
 kthread+0x3b1/0x4a0 kernel/kthread.c:292
 ret_from_fork+0x1f/0x30 arch/x86/entry/entry_64.S:294
INFO: task kworker/u4:1:25 blocked for more than 144 seconds.
      Not tainted 5.12.0-rc2-syzkaller #0
"echo 0 > /proc/sys/kernel/hung_task_timeout_secs" disables this message.
task:kworker/u4:1    state:D stack:25312 pid:   25 ppid:     2 flags:0x00004000
Workqueue: events_unbound io_ring_exit_work
Call Trace:
 context_switch kernel/sched/core.c:4324 [inline]
 __schedule+0x911/0x21b0 kernel/sched/core.c:5075
 schedule+0xcf/0x270 kernel/sched/core.c:5154
 schedule_timeout+0x1db/0x250 kernel/time/timer.c:1868
 do_wait_for_common kernel/sched/completion.c:85 [inline]
 __wait_for_common kernel/sched/completion.c:106 [inline]
 wait_for_common kernel/sched/completion.c:117 [inline]
 wait_for_completion+0x168/0x270 kernel/sched/completion.c:138
 io_ring_exit_work+0x4e8/0x12d0 fs/io_uring.c:8611
 process_one_work+0x98d/0x1600 kernel/workqueue.c:2275
 worker_thread+0x64c/0x1120 kernel/workqueue.c:2421
 kthread+0x3b1/0x4a0 kernel/kthread.c:292
 ret_from_fork+0x1f/0x30 arch/x86/entry/entry_64.S:294
INFO: task kworker/u4:3:110 blocked for more than 145 seconds.
      Not tainted 5.12.0-rc2-syzkaller #0
"echo 0 > /proc/sys/kernel/hung_task_timeout_secs" disables this message.
task:kworker/u4:3    state:D stack:23608 pid:  110 ppid:     2 flags:0x00004000
Workqueue: events_unbound io_ring_exit_work
Call Trace:
 context_switch kernel/sched/core.c:4324 [inline]
 __schedule+0x911/0x21b0 kernel/sched/core.c:5075
 schedule+0xcf/0x270 kernel/sched/core.c:5154
 schedule_timeout+0x1db/0x250 kernel/time/timer.c:1868
 do_wait_for_common kernel/sched/completion.c:85 [inline]
 __wait_for_common kernel/sched/completion.c:106 [inline]
 wait_for_common kernel/sched/completion.c:117 [inline]
 wait_for_completion+0x168/0x270 kernel/sched/completion.c:138
 io_ring_exit_work+0x4e8/0x12d0 fs/io_uring.c:8611
 process_one_work+0x98d/0x1600 kernel/workqueue.c:2275
 worker_thread+0x64c/0x1120 kernel/workqueue.c:2421
 kthread+0x3b1/0x4a0 kernel/kthread.c:292
 ret_from_fork+0x1f/0x30 arch/x86/entry/entry_64.S:294
INFO: task kworker/u4:4:185 blocked for more than 145 seconds.
      Not tainted 5.12.0-rc2-syzkaller #0
"echo 0 > /proc/sys/kernel/hung_task_timeout_secs" disables this message.
task:kworker/u4:4    state:D stack:25584 pid:  185 ppid:     2 flags:0x00004000
Workqueue: events_unbound io_ring_exit_work
Call Trace:
 context_switch kernel/sched/core.c:4324 [inline]
 __schedule+0x911/0x21b0 kernel/sched/core.c:5075
 schedule+0xcf/0x270 kernel/sched/core.c:5154
 schedule_timeout+0x1db/0x250 kernel/time/timer.c:1868
 do_wait_for_common kernel/sched/completion.c:85 [inline]
 __wait_for_common kernel/sched/completion.c:106 [inline]
 wait_for_common kernel/sched/completion.c:117 [inline]
 wait_for_completion+0x168/0x270 kernel/sched/completion.c:138
 io_ring_exit_work+0x4e8/0x12d0 fs/io_uring.c:8611
 process_one_work+0x98d/0x1600 kernel/workqueue.c:2275
 worker_thread+0x64c/0x1120 kernel/workqueue.c:2421
 kthread+0x3b1/0x4a0 kernel/kthread.c:292
 ret_from_fork+0x1f/0x30 arch/x86/entry/entry_64.S:294

Showing all locks held in the system:
2 locks held by kworker/u4:0/9:
 #0: ffff88800fc69138 ((wq_completion)events_unbound){+.+.}-{0:0}, at: arch_atomic64_set arch/x86/include/asm/atomic64_64.h:34 [inline]
 #0: ffff88800fc69138 ((wq_completion)events_unbound){+.+.}-{0:0}, at: atomic64_set include/asm-generic/atomic-instrumented.h:856 [inline]
 #0: ffff88800fc69138 ((wq_completion)events_unbound){+.+.}-{0:0}, at: atomic_long_set include/asm-generic/atomic-long.h:41 [inline]
 #0: ffff88800fc69138 ((wq_completion)events_unbound){+.+.}-{0:0}, at: set_work_data kernel/workqueue.c:616 [inline]
 #0: ffff88800fc69138 ((wq_completion)events_unbound){+.+.}-{0:0}, at: set_work_pool_and_clear_pending kernel/workqueue.c:643 [inline]
 #0: ffff88800fc69138 ((wq_completion)events_unbound){+.+.}-{0:0}, at: process_one_work+0x871/0x1600 kernel/workqueue.c:2246
 #1: ffffc90000ce7da8 ((work_completion)(&ctx->exit_work)){+.+.}-{0:0}, at: process_one_work+0x8a5/0x1600 kernel/workqueue.c:2250
2 locks held by kworker/u4:1/25:
 #0: ffff88800fc69138 ((wq_completion)events_unbound){+.+.}-{0:0}, at: arch_atomic64_set arch/x86/include/asm/atomic64_64.h:34 [inline]
 #0: ffff88800fc69138 ((wq_completion)events_unbound){+.+.}-{0:0}, at: atomic64_set include/asm-generic/atomic-instrumented.h:856 [inline]
 #0: ffff88800fc69138 ((wq_completion)events_unbound){+.+.}-{0:0}, at: atomic_long_set include/asm-generic/atomic-long.h:41 [inline]
 #0: ffff88800fc69138 ((wq_completion)events_unbound){+.+.}-{0:0}, at: set_work_data kernel/workqueue.c:616 [inline]
 #0: ffff88800fc69138 ((wq_completion)events_unbound){+.+.}-{0:0}, at: set_work_pool_and_clear_pending kernel/workqueue.c:643 [inline]
 #0: ffff88800fc69138 ((wq_completion)events_unbound){+.+.}-{0:0}, at: process_one_work+0x871/0x1600 kernel/workqueue.c:2246
 #1: ffffc90000dffda8 ((work_completion)(&ctx->exit_work)){+.+.}-{0:0}, at: process_one_work+0x8a5/0x1600 kernel/workqueue.c:2250
2 locks held by kworker/u4:2/28:
 #0: ffff88800fc69138 ((wq_completion)events_unbound){+.+.}-{0:0}, at: arch_atomic64_set arch/x86/include/asm/atomic64_64.h:34 [inline]
 #0: ffff88800fc69138 ((wq_completion)events_unbound){+.+.}-{0:0}, at: atomic64_set include/asm-generic/atomic-instrumented.h:856 [inline]
 #0: ffff88800fc69138 ((wq_completion)events_unbound){+.+.}-{0:0}, at: atomic_long_set include/asm-generic/atomic-long.h:41 [inline]
 #0: ffff88800fc69138 ((wq_completion)events_unbound){+.+.}-{0:0}, at: set_work_data kernel/workqueue.c:616 [inline]
 #0: ffff88800fc69138 ((wq_completion)events_unbound){+.+.}-{0:0}, at: set_work_pool_and_clear_pending kernel/workqueue.c:643 [inline]
 #0: ffff88800fc69138 ((wq_completion)events_unbound){+.+.}-{0:0}, at: process_one_work+0x871/0x1600 kernel/workqueue.c:2246
 #1: ffffc90000e3fda8 ((work_completion)(&ctx->exit_work)){+.+.}-{0:0}, at: process_one_work+0x8a5/0x1600 kernel/workqueue.c:2250
2 locks held by kworker/u4:3/110:
 #0: ffff88800fc69138 ((wq_completion)events_unbound){+.+.}-{0:0}, at: arch_atomic64_set arch/x86/include/asm/atomic64_64.h:34 [inline]
 #0: ffff88800fc69138 ((wq_completion)events_unbound){+.+.}-{0:0}, at: atomic64_set include/asm-generic/atomic-instrumented.h:856 [inline]
 #0: ffff88800fc69138 ((wq_completion)events_unbound){+.+.}-{0:0}, at: atomic_long_set include/asm-generic/atomic-long.h:41 [inline]
 #0: ffff88800fc69138 ((wq_completion)events_unbound){+.+.}-{0:0}, at: set_work_data kernel/workqueue.c:616 [inline]
 #0: ffff88800fc69138 ((wq_completion)events_unbound){+.+.}-{0:0}, at: set_work_pool_and_clear_pending kernel/workqueue.c:643 [inline]
 #0: ffff88800fc69138 ((wq_completion)events_unbound){+.+.}-{0:0}, at: process_one_work+0x871/0x1600 kernel/workqueue.c:2246
 #1: ffffc9000127fda8 ((work_completion)(&ctx->exit_work)){+.+.}-{0:0}, at: process_one_work+0x8a5/0x1600 kernel/workqueue.c:2250
2 locks held by kworker/u4:4/185:
 #0: ffff88800fc69138 ((wq_completion)events_unbound){+.+.}-{0:0}, at: arch_atomic64_set arch/x86/include/asm/atomic64_64.h:34 [inline]
 #0: ffff88800fc69138 ((wq_completion)events_unbound){+.+.}-{0:0}, at: atomic64_set include/asm-generic/atomic-instrumented.h:856 [inline]
 #0: ffff88800fc69138 ((wq_completion)events_unbound){+.+.}-{0:0}, at: atomic_long_set include/asm-generic/atomic-long.h:41 [inline]
 #0: ffff88800fc69138 ((wq_completion)events_unbound){+.+.}-{0:0}, at: set_work_data kernel/workqueue.c:616 [inline]
 #0: ffff88800fc69138 ((wq_completion)events_unbound){+.+.}-{0:0}, at: set_work_pool_and_clear_pending kernel/workqueue.c:643 [inline]
 #0: ffff88800fc69138 ((wq_completion)events_unbound){+.+.}-{0:0}, at: process_one_work+0x871/0x1600 kernel/workqueue.c:2246
 #1: ffffc900011afda8 ((work_completion)(&ctx->exit_work)){+.+.}-{0:0}, at: process_one_work+0x8a5/0x1600 kernel/workqueue.c:2250
2 locks held by kworker/u4:5/218:
 #0: ffff88800fc69138 ((wq_completion)events_unbound){+.+.}-{0:0}, at: arch_atomic64_set arch/x86/include/asm/atomic64_64.h:34 [inline]
 #0: ffff88800fc69138 ((wq_completion)events_unbound){+.+.}-{0:0}, at: atomic64_set include/asm-generic/atomic-instrumented.h:856 [inline]
 #0: ffff88800fc69138 ((wq_completion)events_unbound){+.+.}-{0:0}, at: atomic_long_set include/asm-generic/atomic-long.h:41 [inline]
 #0: ffff88800fc69138 ((wq_completion)events_unbound){+.+.}-{0:0}, at: set_work_data kernel/workqueue.c:616 [inline]
 #0: ffff88800fc69138 ((wq_completion)events_unbound){+.+.}-{0:0}, at: set_work_pool_and_clear_pending kernel/workqueue.c:643 [inline]
 #0: ffff88800fc69138 ((wq_completion)events_unbound){+.+.}-{0:0}, at: process_one_work+0x871/0x1600 kernel/workqueue.c:2246
 #1: ffffc900018ffda8 ((work_completion)(&ctx->exit_work)){+.+.}-{0:0}, at: process_one_work+0x8a5/0x1600 kernel/workqueue.c:2250
2 locks held by kworker/u4:6/275:
 #0: ffff88800fc69138 ((wq_completion)events_unbound){+.+.}-{0:0}, at: arch_atomic64_set arch/x86/include/asm/atomic64_64.h:34 [inline]
 #0: ffff88800fc69138 ((wq_completion)events_unbound){+.+.}-{0:0}, at: atomic64_set include/asm-generic/atomic-instrumented.h:856 [inline]
 #0: ffff88800fc69138 ((wq_completion)events_unbound){+.+.}-{0:0}, at: atomic_long_set include/asm-generic/atomic-long.h:41 [inline]
 #0: ffff88800fc69138 ((wq_completion)events_unbound){+.+.}-{0:0}, at: set_work_data kernel/workqueue.c:616 [inline]
 #0: ffff88800fc69138 ((wq_completion)events_unbound){+.+.}-{0:0}, at: set_work_pool_and_clear_pending kernel/workqueue.c:643 [inline]
 #0: ffff88800fc69138 ((wq_completion)events_unbound){+.+.}-{0:0}, at: process_one_work+0x871/0x1600 kernel/workqueue.c:2246
 #1: ffffc900018dfda8 ((work_completion)(&ctx->exit_work)){+.+.}-{0:0}, at: process_one_work+0x8a5/0x1600 kernel/workqueue.c:2250
1 lock held by khungtaskd/1622:
 #0: ffffffff8b774760 (rcu_read_lock){....}-{1:2}, at: debug_show_all_locks+0x53/0x260 kernel/locking/lockdep.c:6327
2 locks held by kswapd0/2125:
3 locks held by kswapd1/2126:
2 locks held by systemd-journal/4828:
 #0: ffff88814399f110 (&ei->i_mmap_sem){++++}-{3:3}, at: ext4_filemap_fault+0x7f/0xc0 fs/ext4/inode.c:6193
 #1: ffffffff8b88ca40 (fs_reclaim){+.+.}-{0:0}, at: fs_reclaim_acquire+0xf7/0x150 mm/page_alloc.c:4349
2 locks held by systemd-udevd/4830:
 #0: ffff88801bb2dd10 (&ei->i_mmap_sem){++++}-{3:3}, at: ext4_filemap_fault+0x7f/0xc0 fs/ext4/inode.c:6193
 #1: ffffffff8b88ca40 (fs_reclaim){+.+.}-{0:0}, at: fs_reclaim_acquire+0xf7/0x150 mm/page_alloc.c:4349
1 lock held by in:imklog/8091:
 #0: ffff888012020af0 (&f->f_pos_lock){+.+.}-{3:3}, at: __fdget_pos+0xe9/0x100 fs/file.c:961
4 locks held by rs:main Q:Reg/8092:
 #0: ffff8880116d00f0 (&f->f_pos_lock){+.+.}-{3:3}, at: __fdget_pos+0xe9/0x100 fs/file.c:961
 #1: ffff888021b78460 (sb_writers#5){.+.+}-{0:0}, at: ksys_write+0x12d/0x250 fs/read_write.c:658
 #2: ffff88802d418e88 (&sb->s_type->i_mutex_key#10){+.+.}-{3:3}, at: inode_lock include/linux/fs.h:775 [inline]
 #2: ffff88802d418e88 (&sb->s_type->i_mutex_key#10){+.+.}-{3:3}, at: ext4_buffered_write_iter+0xb6/0x4d0 fs/ext4/file.c:263
 #3: ffffffff8b88ca40 (fs_reclaim){+.+.}-{0:0}, at: fs_reclaim_acquire+0xf7/0x150 mm/page_alloc.c:4349
3 locks held by sshd/8739:
 #0: ffff88802b433510 (&ei->i_mmap_sem){++++}-{3:3}, at: ext4_filemap_fault+0x7f/0xc0 fs/ext4/inode.c:6193
 #1: ffffffff8b88ca40 (fs_reclaim){+.+.}-{0:0}, at: fs_reclaim_acquire+0xf7/0x150 mm/page_alloc.c:4349
 #2: ffff88802d5c1048 (&mapping->i_mmap_rwsem){++++}-{3:3}, at: i_mmap_lock_read include/linux/fs.h:510 [inline]
 #2: ffff88802d5c1048 (&mapping->i_mmap_rwsem){++++}-{3:3}, at: rmap_walk_file+0x6d1/0xca0 mm/rmap.c:1926
1 lock held by syz-execprog/8746:
 #0: ffff8880318add10 (&ei->i_mmap_sem){++++}-{3:3}, at: ext4_filemap_fault+0x7f/0xc0 fs/ext4/inode.c:6193
2 locks held by syz-execprog/8755:
 #0: ffff8880b9f35198 (&rq->lock){-.-.}-{2:2}, at: rq_lock kernel/sched/sched.h:1321 [inline]
 #0: ffff8880b9f35198 (&rq->lock){-.-.}-{2:2}, at: __schedule+0x21c/0x21b0 kernel/sched/core.c:4992
 #1: ffff8880b9f1f948 (&per_cpu_ptr(group->pcpu, cpu)->seq){-.-.}-{0:0}, at: psi_task_switch+0x305/0x440 kernel/sched/psi.c:833
2 locks held by syz-executor.2/8769:
 #0: ffff888023e6ea58 (&mm->mmap_lock#2){++++}-{3:3}, at: mmap_read_trylock include/linux/mmap_lock.h:136 [inline]
 #0: ffff888023e6ea58 (&mm->mmap_lock#2){++++}-{3:3}, at: do_user_addr_fault+0x285/0x1210 arch/x86/mm/fault.c:1331
 #1: ffffffff8b88ca40 (fs_reclaim){+.+.}-{0:0}, at: fs_reclaim_acquire+0xf7/0x150 mm/page_alloc.c:4349
1 lock held by syz-executor.0/8770:
 #0: ffff8880b9f35198 (&rq->lock){-.-.}-{2:2}, at: rq_lock kernel/sched/sched.h:1321 [inline]
 #0: ffff8880b9f35198 (&rq->lock){-.-.}-{2:2}, at: __schedule+0x21c/0x21b0 kernel/sched/core.c:4992
2 locks held by syz-executor.1/8771:
 #0: ffff88801fd4c458 (&xt[i].mutex){+.+.}-{3:3}, at: xt_find_table_lock+0x41/0x540 net/netfilter/x_tables.c:1206
 #1: ffffffff8b77d328 (rcu_state.exp_mutex){+.+.}-{3:3}, at: exp_funnel_lock kernel/rcu/tree_exp.h:322 [inline]
 #1: ffffffff8b77d328 (rcu_state.exp_mutex){+.+.}-{3:3}, at: synchronize_rcu_expedited+0x27e/0x620 kernel/rcu/tree_exp.h:836
2 locks held by syz-executor.3/8773:
 #0: ffff88802d5c0d10 (&ei->i_mmap_sem){++++}-{3:3}, at: ext4_filemap_fault+0x7f/0xc0 fs/ext4/inode.c:6193
 #1: ffffffff8b88ca40 (fs_reclaim){+.+.}-{0:0}, at: fs_reclaim_acquire+0xf7/0x150 mm/page_alloc.c:4349
1 lock held by syz-executor.4/8775:
 #0: ffff88801fd4cd88 (&xt[i].mutex){+.+.}-{3:3}, at: xt_find_table_lock+0x41/0x540 net/netfilter/x_tables.c:1206
2 locks held by kworker/u4:7/10347:
 #0: ffff88800fc69138 ((wq_completion)events_unbound){+.+.}-{0:0}, at: arch_atomic64_set arch/x86/include/asm/atomic64_64.h:34 [inline]
 #0: ffff88800fc69138 ((wq_completion)events_unbound){+.+.}-{0:0}, at: atomic64_set include/asm-generic/atomic-instrumented.h:856 [inline]
 #0: ffff88800fc69138 ((wq_completion)events_unbound){+.+.}-{0:0}, at: atomic_long_set include/asm-generic/atomic-long.h:41 [inline]
 #0: ffff88800fc69138 ((wq_completion)events_unbound){+.+.}-{0:0}, at: set_work_data kernel/workqueue.c:616 [inline]
 #0: ffff88800fc69138 ((wq_completion)events_unbound){+.+.}-{0:0}, at: set_work_pool_and_clear_pending kernel/workqueue.c:643 [inline]
 #0: ffff88800fc69138 ((wq_completion)events_unbound){+.+.}-{0:0}, at: process_one_work+0x871/0x1600 kernel/workqueue.c:2246
 #1: ffffc9000b07fda8 ((work_completion)(&ctx->exit_work)){+.+.}-{0:0}, at: process_one_work+0x8a5/0x1600 kernel/workqueue.c:2250
2 locks held by kworker/u4:8/10640:
 #0: ffff88800fc69138 ((wq_completion)events_unbound){+.+.}-{0:0}, at: arch_atomic64_set arch/x86/include/asm/atomic64_64.h:34 [inline]
 #0: ffff88800fc69138 ((wq_completion)events_unbound){+.+.}-{0:0}, at: atomic64_set include/asm-generic/atomic-instrumented.h:856 [inline]
 #0: ffff88800fc69138 ((wq_completion)events_unbound){+.+.}-{0:0}, at: atomic_long_set include/asm-generic/atomic-long.h:41 [inline]
 #0: ffff88800fc69138 ((wq_completion)events_unbound){+.+.}-{0:0}, at: set_work_data kernel/workqueue.c:616 [inline]
 #0: ffff88800fc69138 ((wq_completion)events_unbound){+.+.}-{0:0}, at: set_work_pool_and_clear_pending kernel/workqueue.c:643 [inline]
 #0: ffff88800fc69138 ((wq_completion)events_unbound){+.+.}-{0:0}, at: process_one_work+0x871/0x1600 kernel/workqueue.c:2246
 #1: ffffc9000bd0fda8 ((work_completion)(&ctx->exit_work)){+.+.}-{0:0}, at: process_one_work+0x8a5/0x1600 kernel/workqueue.c:2250
2 locks held by kworker/u4:9/10726:
 #0: ffff88800fc69138 ((wq_completion)events_unbound){+.+.}-{0:0}, at: arch_atomic64_set arch/x86/include/asm/atomic64_64.h:34 [inline]
 #0: ffff88800fc69138 ((wq_completion)events_unbound){+.+.}-{0:0}, at: atomic64_set include/asm-generic/atomic-instrumented.h:856 [inline]
 #0: ffff88800fc69138 ((wq_completion)events_unbound){+.+.}-{0:0}, at: atomic_long_set include/asm-generic/atomic-long.h:41 [inline]
 #0: ffff88800fc69138 ((wq_completion)events_unbound){+.+.}-{0:0}, at: set_work_data kernel/workqueue.c:616 [inline]
 #0: ffff88800fc69138 ((wq_completion)events_unbound){+.+.}-{0:0}, at: set_work_pool_and_clear_pending kernel/workqueue.c:643 [inline]
 #0: ffff88800fc69138 ((wq_completion)events_unbound){+.+.}-{0:0}, at: process_one_work+0x871/0x1600 kernel/workqueue.c:2246
 #1: ffffc9000a6dfda8 ((work_completion)(&ctx->exit_work)){+.+.}-{0:0}, at: process_one_work+0x8a5/0x1600 kernel/workqueue.c:2250
2 locks held by kworker/u4:10/10915:
 #0: ffff88800fc69138 ((wq_completion)events_unbound){+.+.}-{0:0}, at: arch_atomic64_set arch/x86/include/asm/atomic64_64.h:34 [inline]
 #0: ffff88800fc69138 ((wq_completion)events_unbound){+.+.}-{0:0}, at: atomic64_set include/asm-generic/atomic-instrumented.h:856 [inline]
 #0: ffff88800fc69138 ((wq_completion)events_unbound){+.+.}-{0:0}, at: atomic_long_set include/asm-generic/atomic-long.h:41 [inline]
 #0: ffff88800fc69138 ((wq_completion)events_unbound){+.+.}-{0:0}, at: set_work_data kernel/workqueue.c:616 [inline]
 #0: ffff88800fc69138 ((wq_completion)events_unbound){+.+.}-{0:0}, at: set_work_pool_and_clear_pending kernel/workqueue.c:643 [inline]
 #0: ffff88800fc69138 ((wq_completion)events_unbound){+.+.}-{0:0}, at: process_one_work+0x871/0x1600 kernel/workqueue.c:2246
 #1: ffffc9000c81fda8 ((work_completion)(&ctx->exit_work)){+.+.}-{0:0}, at: process_one_work+0x8a5/0x1600 kernel/workqueue.c:2250
2 locks held by kworker/u4:11/11278:
 #0: ffff88800fc69138 ((wq_completion)events_unbound){+.+.}-{0:0}, at: arch_atomic64_set arch/x86/include/asm/atomic64_64.h:34 [inline]
 #0: ffff88800fc69138 ((wq_completion)events_unbound){+.+.}-{0:0}, at: atomic64_set include/asm-generic/atomic-instrumented.h:856 [inline]
 #0: ffff88800fc69138 ((wq_completion)events_unbound){+.+.}-{0:0}, at: atomic_long_set include/asm-generic/atomic-long.h:41 [inline]
 #0: ffff88800fc69138 ((wq_completion)events_unbound){+.+.}-{0:0}, at: set_work_data kernel/workqueue.c:616 [inline]
 #0: ffff88800fc69138 ((wq_completion)events_unbound){+.+.}-{0:0}, at: set_work_pool_and_clear_pending kernel/workqueue.c:643 [inline]
 #0: ffff88800fc69138 ((wq_completion)events_unbound){+.+.}-{0:0}, at: process_one_work+0x871/0x1600 kernel/workqueue.c:2246
 #1: ffffc9000d5cfda8 ((work_completion)(&ctx->exit_work)){+.+.}-{0:0}, at: process_one_work+0x8a5/0x1600 kernel/workqueue.c:2250
2 locks held by kworker/u4:12/11561:
 #0: ffff88800fc69138 ((wq_completion)events_unbound){+.+.}-{0:0}, at: arch_atomic64_set arch/x86/include/asm/atomic64_64.h:34 [inline]
 #0: ffff88800fc69138 ((wq_completion)events_unbound){+.+.}-{0:0}, at: atomic64_set include/asm-generic/atomic-instrumented.h:856 [inline]
 #0: ffff88800fc69138 ((wq_completion)events_unbound){+.+.}-{0:0}, at: atomic_long_set include/asm-generic/atomic-long.h:41 [inline]
 #0: ffff88800fc69138 ((wq_completion)events_unbound){+.+.}-{0:0}, at: set_work_data kernel/workqueue.c:616 [inline]
 #0: ffff88800fc69138 ((wq_completion)events_unbound){+.+.}-{0:0}, at: set_work_pool_and_clear_pending kernel/workqueue.c:643 [inline]
 #0: ffff88800fc69138 ((wq_completion)events_unbound){+.+.}-{0:0}, at: process_one_work+0x871/0x1600 kernel/workqueue.c:2246
 #1: ffffc9000e00fda8 ((work_completion)(&ctx->exit_work)){+.+.}-{0:0}, at: process_one_work+0x8a5/0x1600 kernel/workqueue.c:2250
2 locks held by kworker/u4:13/11663:
 #0: ffff88800fc69138 ((wq_completion)events_unbound){+.+.}-{0:0}, at: arch_atomic64_set arch/x86/include/asm/atomic64_64.h:34 [inline]
 #0: ffff88800fc69138 ((wq_completion)events_unbound){+.+.}-{0:0}, at: atomic64_set include/asm-generic/atomic-instrumented.h:856 [inline]
 #0: ffff88800fc69138 ((wq_completion)events_unbound){+.+.}-{0:0}, at: atomic_long_set include/asm-generic/atomic-long.h:41 [inline]
 #0: ffff88800fc69138 ((wq_completion)events_unbound){+.+.}-{0:0}, at: set_work_data kernel/workqueue.c:616 [inline]
 #0: ffff88800fc69138 ((wq_completion)events_unbound){+.+.}-{0:0}, at: set_work_pool_and_clear_pending kernel/workqueue.c:643 [inline]
 #0: ffff88800fc69138 ((wq_completion)events_unbound){+.+.}-{0:0}, at: process_one_work+0x871/0x1600 kernel/workqueue.c:2246
 #1: ffffc9000e38fda8 ((work_completion)(&ctx->exit_work)){+.+.}-{0:0}, at: process_one_work+0x8a5/0x1600 kernel/workqueue.c:2250
2 locks held by kworker/u4:14/11950:
 #0: ffff88800fc69138 ((wq_completion)events_unbound){+.+.}-{0:0}, at: arch_atomic64_set arch/x86/include/asm/atomic64_64.h:34 [inline]
 #0: ffff88800fc69138 ((wq_completion)events_unbound){+.+.}-{0:0}, at: atomic64_set include/asm-generic/atomic-instrumented.h:856 [inline]
 #0: ffff88800fc69138 ((wq_completion)events_unbound){+.+.}-{0:0}, at: atomic_long_set include/asm-generic/atomic-long.h:41 [inline]
 #0: ffff88800fc69138 ((wq_completion)events_unbound){+.+.}-{0:0}, at: set_work_data kernel/workqueue.c:616 [inline]
 #0: ffff88800fc69138 ((wq_completion)events_unbound){+.+.}-{0:0}, at: set_work_pool_and_clear_pending kernel/workqueue.c:643 [inline]
 #0: ffff88800fc69138 ((wq_completion)events_unbound){+.+.}-{0:0}, at: process_one_work+0x871/0x1600 kernel/workqueue.c:2246
 #1: ffffc9000ee6fda8 ((work_completion)(&ctx->exit_work)){+.+.}-{0:0}, at: process_one_work+0x8a5/0x1600 kernel/workqueue.c:2250
2 locks held by kworker/u4:15/12154:
 #0: ffff88800fc69138 ((wq_completion)events_unbound){+.+.}-{0:0}, at: arch_atomic64_set arch/x86/include/asm/atomic64_64.h:34 [inline]
 #0: ffff88800fc69138 ((wq_completion)events_unbound){+.+.}-{0:0}, at: atomic64_set include/asm-generic/atomic-instrumented.h:856 [inline]
 #0: ffff88800fc69138 ((wq_completion)events_unbound){+.+.}-{0:0}, at: atomic_long_set include/asm-generic/atomic-long.h:41 [inline]
 #0: ffff88800fc69138 ((wq_completion)events_unbound){+.+.}-{0:0}, at: set_work_data kernel/workqueue.c:616 [inline]
 #0: ffff88800fc69138 ((wq_completion)events_unbound){+.+.}-{0:0}, at: set_work_pool_and_clear_pending kernel/workqueue.c:643 [inline]
 #0: ffff88800fc69138 ((wq_completion)events_unbound){+.+.}-{0:0}, at: process_one_work+0x871/0x1600 kernel/workqueue.c:2246
 #1: ffffc9000216fda8 ((work_completion)(&ctx->exit_work)){+.+.}-{0:0}, at: process_one_work+0x8a5/0x1600 kernel/workqueue.c:2250
2 locks held by kworker/u4:16/12256:
 #0: ffff88800fc69138 ((wq_completion)events_unbound){+.+.}-{0:0}, at: arch_atomic64_set arch/x86/include/asm/atomic64_64.h:34 [inline]
 #0: ffff88800fc69138 ((wq_completion)events_unbound){+.+.}-{0:0}, at: atomic64_set include/asm-generic/atomic-instrumented.h:856 [inline]
 #0: ffff88800fc69138 ((wq_completion)events_unbound){+.+.}-{0:0}, at: atomic_long_set include/asm-generic/atomic-long.h:41 [inline]
 #0: ffff88800fc69138 ((wq_completion)events_unbound){+.+.}-{0:0}, at: set_work_data kernel/workqueue.c:616 [inline]
 #0: ffff88800fc69138 ((wq_completion)events_unbound){+.+.}-{0:0}, at: set_work_pool_and_clear_pending kernel/workqueue.c:643 [inline]
 #0: ffff88800fc69138 ((wq_completion)events_unbound){+.+.}-{0:0}, at: process_one_work+0x871/0x1600 kernel/workqueue.c:2246
 #1: ffffc9000263fda8 ((work_completion)(&ctx->exit_work)){+.+.}-{0:0}, at: process_one_work+0x8a5/0x1600 kernel/workqueue.c:2250
2 locks held by kworker/u4:17/12391:
 #0: ffff88800fc69138 ((wq_completion)events_unbound){+.+.}-{0:0}, at: arch_atomic64_set arch/x86/include/asm/atomic64_64.h:34 [inline]
 #0: ffff88800fc69138 ((wq_completion)events_unbound){+.+.}-{0:0}, at: atomic64_set include/asm-generic/atomic-instrumented.h:856 [inline]
 #0: ffff88800fc69138 ((wq_completion)events_unbound){+.+.}-{0:0}, at: atomic_long_set include/asm-generic/atomic-long.h:41 [inline]
 #0: ffff88800fc69138 ((wq_completion)events_unbound){+.+.}-{0:0}, at: set_work_data kernel/workqueue.c:616 [inline]
 #0: ffff88800fc69138 ((wq_completion)events_unbound){+.+.}-{0:0}, at: set_work_pool_and_clear_pending kernel/workqueue.c:643 [inline]
 #0: ffff88800fc69138 ((wq_completion)events_unbound){+.+.}-{0:0}, at: process_one_work+0x871/0x1600 kernel/workqueue.c:2246
 #1: ffffc90002befda8 ((work_completion)(&ctx->exit_work)){+.+.}-{0:0}, at: process_one_work+0x8a5/0x1600 kernel/workqueue.c:2250
2 locks held by kworker/u4:18/12443:
 #0: ffff88800fc69138 ((wq_completion)events_unbound){+.+.}-{0:0}, at: arch_atomic64_set arch/x86/include/asm/atomic64_64.h:34 [inline]
 #0: ffff88800fc69138 ((wq_completion)events_unbound){+.+.}-{0:0}, at: atomic64_set include/asm-generic/atomic-instrumented.h:856 [inline]
 #0: ffff88800fc69138 ((wq_completion)events_unbound){+.+.}-{0:0}, at: atomic_long_set include/asm-generic/atomic-long.h:41 [inline]
 #0: ffff88800fc69138 ((wq_completion)events_unbound){+.+.}-{0:0}, at: set_work_data kernel/workqueue.c:616 [inline]
 #0: ffff88800fc69138 ((wq_completion)events_unbound){+.+.}-{0:0}, at: set_work_pool_and_clear_pending kernel/workqueue.c:643 [inline]
 #0: ffff88800fc69138 ((wq_completion)events_unbound){+.+.}-{0:0}, at: process_one_work+0x871/0x1600 kernel/workqueue.c:2246
 #1: ffffc90002dbfda8 ((work_completion)(&ctx->exit_work)){+.+.}-{0:0}, at: process_one_work+0x8a5/0x1600 kernel/workqueue.c:2250
2 locks held by kworker/u4:19/12596:
 #0: ffff88800fc69138 ((wq_completion)events_unbound){+.+.}-{0:0}, at: arch_atomic64_set arch/x86/include/asm/atomic64_64.h:34 [inline]
 #0: ffff88800fc69138 ((wq_completion)events_unbound){+.+.}-{0:0}, at: atomic64_set include/asm-generic/atomic-instrumented.h:856 [inline]
 #0: ffff88800fc69138 ((wq_completion)events_unbound){+.+.}-{0:0}, at: atomic_long_set include/asm-generic/atomic-long.h:41 [inline]
 #0: ffff88800fc69138 ((wq_completion)events_unbound){+.+.}-{0:0}, at: set_work_data kernel/workqueue.c:616 [inline]
 #0: ffff88800fc69138 ((wq_completion)events_unbound){+.+.}-{0:0}, at: set_work_pool_and_clear_pending kernel/workqueue.c:643 [inline]
 #0: ffff88800fc69138 ((wq_completion)events_unbound){+.+.}-{0:0}, at: process_one_work+0x871/0x1600 kernel/workqueue.c:2246
 #1: ffffc900030b7da8 ((work_completion)(&ctx->exit_work)){+.+.}-{0:0}, at: process_one_work+0x8a5/0x1600 kernel/workqueue.c:2250
2 locks held by kworker/u4:20/12663:
 #0: ffff88800fc69138 ((wq_completion)events_unbound){+.+.}-{0:0}, at: arch_atomic64_set arch/x86/include/asm/atomic64_64.h:34 [inline]
 #0: ffff88800fc69138 ((wq_completion)events_unbound){+.+.}-{0:0}, at: atomic64_set include/asm-generic/atomic-instrumented.h:856 [inline]
 #0: ffff88800fc69138 ((wq_completion)events_unbound){+.+.}-{0:0}, at: atomic_long_set include/asm-generic/atomic-long.h:41 [inline]
 #0: ffff88800fc69138 ((wq_completion)events_unbound){+.+.}-{0:0}, at: set_work_data kernel/workqueue.c:616 [inline]
 #0: ffff88800fc69138 ((wq_completion)events_unbound){+.+.}-{0:0}, at: set_work_pool_and_clear_pending kernel/workqueue.c:643 [inline]
 #0: ffff88800fc69138 ((wq_completion)events_unbound){+.+.}-{0:0}, at: process_one_work+0x871/0x1600 kernel/workqueue.c:2246
 #1: ffffc90003077da8 ((work_completion)(&ctx->exit_work)){+.+.}-{0:0}, at: process_one_work+0x8a5/0x1600 kernel/workqueue.c:2250
2 locks held by kworker/u4:21/12823:
 #0: ffff88800fc69138 ((wq_completion)events_unbound){+.+.}-{0:0}, at: arch_atomic64_set arch/x86/include/asm/atomic64_64.h:34 [inline]
 #0: ffff88800fc69138 ((wq_completion)events_unbound){+.+.}-{0:0}, at: atomic64_set include/asm-generic/atomic-instrumented.h:856 [inline]
 #0: ffff88800fc69138 ((wq_completion)events_unbound){+.+.}-{0:0}, at: atomic_long_set include/asm-generic/atomic-long.h:41 [inline]
 #0: ffff88800fc69138 ((wq_completion)events_unbound){+.+.}-{0:0}, at: set_work_data kernel/workqueue.c:616 [inline]
 #0: ffff88800fc69138 ((wq_completion)events_unbound){+.+.}-{0:0}, at: set_work_pool_and_clear_pending kernel/workqueue.c:643 [inline]
 #0: ffff88800fc69138 ((wq_completion)events_unbound){+.+.}-{0:0}, at: process_one_work+0x871/0x1600 kernel/workqueue.c:2246
 #1: ffffc900091e7da8 ((work_completion)(&ctx->exit_work)){+.+.}-{0:0}, at: process_one_work+0x8a5/0x1600 kernel/workqueue.c:2250
2 locks held by kworker/u4:22/12831:
 #0: ffff88800fc69138 ((wq_completion)events_unbound){+.+.}-{0:0}, at: arch_atomic64_set arch/x86/include/asm/atomic64_64.h:34 [inline]
 #0: ffff88800fc69138 ((wq_completion)events_unbound){+.+.}-{0:0}, at: atomic64_set include/asm-generic/atomic-instrumented.h:856 [inline]
 #0: ffff88800fc69138 ((wq_completion)events_unbound){+.+.}-{0:0}, at: atomic_long_set include/asm-generic/atomic-long.h:41 [inline]
 #0: ffff88800fc69138 ((wq_completion)events_unbound){+.+.}-{0:0}, at: set_work_data kernel/workqueue.c:616 [inline]
 #0: ffff88800fc69138 ((wq_completion)events_unbound){+.+.}-{0:0}, at: set_work_pool_and_clear_pending kernel/workqueue.c:643 [inline]
 #0: ffff88800fc69138 ((wq_completion)events_unbound){+.+.}-{0:0}, at: process_one_work+0x871/0x1600 kernel/workqueue.c:2246
 #1: ffffc90005237da8 ((work_completion)(&ctx->exit_work)){+.+.}-{0:0}, at: process_one_work+0x8a5/0x1600 kernel/workqueue.c:2250
2 locks held by kworker/u4:23/13064:
 #0: ffff88800fc69138 ((wq_completion)events_unbound){+.+.}-{0:0}, at: arch_atomic64_set arch/x86/include/asm/atomic64_64.h:34 [inline]
 #0: ffff88800fc69138 ((wq_completion)events_unbound){+.+.}-{0:0}, at: atomic64_set include/asm-generic/atomic-instrumented.h:856 [inline]
 #0: ffff88800fc69138 ((wq_completion)events_unbound){+.+.}-{0:0}, at: atomic_long_set include/asm-generic/atomic-long.h:41 [inline]
 #0: ffff88800fc69138 ((wq_completion)events_unbound){+.+.}-{0:0}, at: set_work_data kernel/workqueue.c:616 [inline]
 #0: ffff88800fc69138 ((wq_completion)events_unbound){+.+.}-{0:0}, at: set_work_pool_and_clear_pending kernel/workqueue.c:643 [inline]
 #0: ffff88800fc69138 ((wq_completion)events_unbound){+.+.}-{0:0}, at: process_one_work+0x871/0x1600 kernel/workqueue.c:2246
 #1: ffffc90009d17da8 ((work_completion)(&ctx->exit_work)){+.+.}-{0:0}, at: process_one_work+0x8a5/0x1600 kernel/workqueue.c:2250
2 locks held by kworker/u4:24/13470:
 #0: ffff88800fc69138 ((wq_completion)events_unbound){+.+.}-{0:0}, at: arch_atomic64_set arch/x86/include/asm/atomic64_64.h:34 [inline]
 #0: ffff88800fc69138 ((wq_completion)events_unbound){+.+.}-{0:0}, at: atomic64_set include/asm-generic/atomic-instrumented.h:856 [inline]
 #0: ffff88800fc69138 ((wq_completion)events_unbound){+.+.}-{0:0}, at: atomic_long_set include/asm-generic/atomic-long.h:41 [inline]
 #0: ffff88800fc69138 ((wq_completion)events_unbound){+.+.}-{0:0}, at: set_work_data kernel/workqueue.c:616 [inline]
 #0: ffff88800fc69138 ((wq_completion)events_unbound){+.+.}-{0:0}, at: set_work_pool_and_clear_pending kernel/workqueue.c:643 [inline]
 #0: ffff88800fc69138 ((wq_completion)events_unbound){+.+.}-{0:0}, at: process_one_work+0x871/0x1600 kernel/workqueue.c:2246
 #1: ffffc9000b47fda8 ((work_completion)(&ctx->exit_work)){+.+.}-{0:0}, at: process_one_work+0x8a5/0x1600 kernel/workqueue.c:2250
2 locks held by kworker/u4:25/13565:
 #0: ffff88800fc69138 ((wq_completion)events_unbound){+.+.}-{0:0}, at: arch_atomic64_set arch/x86/include/asm/atomic64_64.h:34 [inline]
 #0: ffff88800fc69138 ((wq_completion)events_unbound){+.+.}-{0:0}, at: atomic64_set include/asm-generic/atomic-instrumented.h:856 [inline]
 #0: ffff88800fc69138 ((wq_completion)events_unbound){+.+.}-{0:0}, at: atomic_long_set include/asm-generic/atomic-long.h:41 [inline]
 #0: ffff88800fc69138 ((wq_completion)events_unbound){+.+.}-{0:0}, at: set_work_data kernel/workqueue.c:616 [inline]
 #0: ffff88800fc69138 ((wq_completion)events_unbound){+.+.}-{0:0}, at: set_work_pool_and_clear_pending kernel/workqueue.c:643 [inline]
 #0: ffff88800fc69138 ((wq_completion)events_unbound){+.+.}-{0:0}, at: process_one_work+0x871/0x1600 kernel/workqueue.c:2246
 #1: ffffc9000bbbfda8 ((work_completion)(&ctx->exit_work)){+.+.}-{0:0}, at: process_one_work+0x8a5/0x1600 kernel/workqueue.c:2250
2 locks held by kworker/u4:26/14589:
 #0: ffff88800fc69138 ((wq_completion)events_unbound){+.+.}-{0:0}, at: arch_atomic64_set arch/x86/include/asm/atomic64_64.h:34 [inline]
 #0: ffff88800fc69138 ((wq_completion)events_unbound){+.+.}-{0:0}, at: atomic64_set include/asm-generic/atomic-instrumented.h:856 [inline]
 #0: ffff88800fc69138 ((wq_completion)events_unbound){+.+.}-{0:0}, at: atomic_long_set include/asm-generic/atomic-long.h:41 [inline]
 #0: ffff88800fc69138 ((wq_completion)events_unbound){+.+.}-{0:0}, at: set_work_data kernel/workqueue.c:616 [inline]
 #0: ffff88800fc69138 ((wq_completion)events_unbound){+.+.}-{0:0}, at: set_work_pool_and_clear_pending kernel/workqueue.c:643 [inline]
 #0: ffff88800fc69138 ((wq_completion)events_unbound){+.+.}-{0:0}, at: process_one_work+0x871/0x1600 kernel/workqueue.c:2246
 #1: ffffc9000fe9fda8 ((work_completion)(&ctx->exit_work)){+.+.}-{0:0}, at: process_one_work+0x8a5/0x1600 kernel/workqueue.c:2250
2 locks held by kworker/u4:27/14673:
 #0: ffff88800fc69138 ((wq_completion)events_unbound){+.+.}-{0:0}, at: arch_atomic64_set arch/x86/include/asm/atomic64_64.h:34 [inline]
 #0: ffff88800fc69138 ((wq_completion)events_unbound){+.+.}-{0:0}, at: atomic64_set include/asm-generic/atomic-instrumented.h:856 [inline]
 #0: ffff88800fc69138 ((wq_completion)events_unbound){+.+.}-{0:0}, at: atomic_long_set include/asm-generic/atomic-long.h:41 [inline]
 #0: ffff88800fc69138 ((wq_completion)events_unbound){+.+.}-{0:0}, at: set_work_data kernel/workqueue.c:616 [inline]
 #0: ffff88800fc69138 ((wq_completion)events_unbound){+.+.}-{0:0}, at: set_work_pool_and_clear_pending kernel/workqueue.c:643 [inline]
 #0: ffff88800fc69138 ((wq_completion)events_unbound){+.+.}-{0:0}, at: process_one_work+0x871/0x1600 kernel/workqueue.c:2246
 #1: ffffc9001017fda8 ((work_completion)(&ctx->exit_work)){+.+.}-{0:0}, at: process_one_work+0x8a5/0x1600 kernel/workqueue.c:2250
2 locks held by kworker/u4:28/14712:
 #0: ffff88800fc69138 ((wq_completion)events_unbound){+.+.}-{0:0}, at: arch_atomic64_set arch/x86/include/asm/atomic64_64.h:34 [inline]
 #0: ffff88800fc69138 ((wq_completion)events_unbound){+.+.}-{0:0}, at: atomic64_set include/asm-generic/atomic-instrumented.h:856 [inline]
 #0: ffff88800fc69138 ((wq_completion)events_unbound){+.+.}-{0:0}, at: atomic_long_set include/asm-generic/atomic-long.h:41 [inline]
 #0: ffff88800fc69138 ((wq_completion)events_unbound){+.+.}-{0:0}, at: set_work_data kernel/workqueue.c:616 [inline]
 #0: ffff88800fc69138 ((wq_completion)events_unbound){+.+.}-{0:0}, at: set_work_pool_and_clear_pending kernel/workqueue.c:643 [inline]
 #0: ffff88800fc69138 ((wq_completion)events_unbound){+.+.}-{0:0}, at: process_one_work+0x871/0x1600 kernel/workqueue.c:2246
 #1: ffffc9000fbdfda8 ((work_completion)(&ctx->exit_work)){+.+.}-{0:0}, at: process_one_work+0x8a5/0x1600 kernel/workqueue.c:2250
2 locks held by kworker/u4:29/14738:
 #0: ffff88800fc69138 ((wq_completion)events_unbound){+.+.}-{0:0}, at: arch_atomic64_set arch/x86/include/asm/atomic64_64.h:34 [inline]
 #0: ffff88800fc69138 ((wq_completion)events_unbound){+.+.}-{0:0}, at: atomic64_set include/asm-generic/atomic-instrumented.h:856 [inline]
 #0: ffff88800fc69138 ((wq_completion)events_unbound){+.+.}-{0:0}, at: atomic_long_set include/asm-generic/atomic-long.h:41 [inline]
 #0: ffff88800fc69138 ((wq_completion)events_unbound){+.+.}-{0:0}, at: set_work_data kernel/workqueue.c:616 [inline]
 #0: ffff88800fc69138 ((wq_completion)events_unbound){+.+.}-{0:0}, at: set_work_pool_and_clear_pending kernel/workqueue.c:643 [inline]
 #0: ffff88800fc69138 ((wq_completion)events_unbound){+.+.}-{0:0}, at: process_one_work+0x871/0x1600 kernel/workqueue.c:2246
 #1: ffffc900103bfda8 ((work_completion)(&ctx->exit_work)){+.+.}-{0:0}, at: process_one_work+0x8a5/0x1600 kernel/workqueue.c:2250
2 locks held by kworker/u4:30/14985:
 #0: ffff88800fc69138 ((wq_completion)events_unbound){+.+.}-{0:0}, at: arch_atomic64_set arch/x86/include/asm/atomic64_64.h:34 [inline]
 #0: ffff88800fc69138 ((wq_completion)events_unbound){+.+.}-{0:0}, at: atomic64_set include/asm-generic/atomic-instrumented.h:856 [inline]
 #0: ffff88800fc69138 ((wq_completion)events_unbound){+.+.}-{0:0}, at: atomic_long_set include/asm-generic/atomic-long.h:41 [inline]
 #0: ffff88800fc69138 ((wq_completion)events_unbound){+.+.}-{0:0}, at: set_work_data kernel/workqueue.c:616 [inline]
 #0: ffff88800fc69138 ((wq_completion)events_unbound){+.+.}-{0:0}, at: set_work_pool_and_clear_pending kernel/workqueue.c:643 [inline]
 #0: ffff88800fc69138 ((wq_completion)events_unbound){+.+.}-{0:0}, at: process_one_work+0x871/0x1600 kernel/workqueue.c:2246
 #1: ffffc90010cdfda8 ((work_completion)(&ctx->exit_work)){+.+.}-{0:0}, at: process_one_work+0x8a5/0x1600 kernel/workqueue.c:2250
2 locks held by kworker/u4:31/15019:
 #0: ffff88800fc69138 ((wq_completion)events_unbound){+.+.}-{0:0}, at: arch_atomic64_set arch/x86/include/asm/atomic64_64.h:34 [inline]
 #0: ffff88800fc69138 ((wq_completion)events_unbound){+.+.}-{0:0}, at: atomic64_set include/asm-generic/atomic-instrumented.h:856 [inline]
 #0: ffff88800fc69138 ((wq_completion)events_unbound){+.+.}-{0:0}, at: atomic_long_set include/asm-generic/atomic-long.h:41 [inline]
 #0: ffff88800fc69138 ((wq_completion)events_unbound){+.+.}-{0:0}, at: set_work_data kernel/workqueue.c:616 [inline]
 #0: ffff88800fc69138 ((wq_completion)events_unbound){+.+.}-{0:0}, at: set_work_pool_and_clear_pending kernel/workqueue.c:643 [inline]
 #0: ffff88800fc69138 ((wq_completion)events_unbound){+.+.}-{0:0}, at: process_one_work+0x871/0x1600 kernel/workqueue.c:2246
 #1: ffffc90010e4fda8 ((work_completion)(&ctx->exit_work)){+.+.}-{0:0}, at: process_one_work+0x8a5/0x1600 kernel/workqueue.c:2250
2 locks held by kworker/u4:32/15295:
 #0: ffff88800fc69138 ((wq_completion)events_unbound){+.+.}-{0:0}, at: arch_atomic64_set arch/x86/include/asm/atomic64_64.h:34 [inline]
 #0: ffff88800fc69138 ((wq_completion)events_unbound){+.+.}-{0:0}, at: atomic64_set include/asm-generic/atomic-instrumented.h:856 [inline]
 #0: ffff88800fc69138 ((wq_completion)events_unbound){+.+.}-{0:0}, at: atomic_long_set include/asm-generic/atomic-long.h:41 [inline]
 #0: ffff88800fc69138 ((wq_completion)events_unbound){+.+.}-{0:0}, at: set_work_data kernel/workqueue.c:616 [inline]
 #0: ffff88800fc69138 ((wq_completion)events_unbound){+.+.}-{0:0}, at: set_work_pool_and_clear_pending kernel/workqueue.c:643 [inline]
 #0: ffff88800fc69138 ((wq_completion)events_unbound){+.+.}-{0:0}, at: process_one_work+0x871/0x1600 kernel/workqueue.c:2246
 #1: ffffc9001186fda8 ((work_completion)(&ctx->exit_work)){+.+.}-{0:0}, at: process_one_work+0x8a5/0x1600 kernel/workqueue.c:2250
2 locks held by kworker/u4:33/15304:
 #0: ffff88800fc69138 ((wq_completion)events_unbound){+.+.}-{0:0}, at: arch_atomic64_set arch/x86/include/asm/atomic64_64.h:34 [inline]
 #0: ffff88800fc69138 ((wq_completion)events_unbound){+.+.}-{0:0}, at: atomic64_set include/asm-generic/atomic-instrumented.h:856 [inline]
 #0: ffff88800fc69138 ((wq_completion)events_unbound){+.+.}-{0:0}, at: atomic_long_set include/asm-generic/atomic-long.h:41 [inline]
 #0: ffff88800fc69138 ((wq_completion)events_unbound){+.+.}-{0:0}, at: set_work_data kernel/workqueue.c:616 [inline]
 #0: ffff88800fc69138 ((wq_completion)events_unbound){+.+.}-{0:0}, at: set_work_pool_and_clear_pending kernel/workqueue.c:643 [inline]
 #0: ffff88800fc69138 ((wq_completion)events_unbound){+.+.}-{0:0}, at: process_one_work+0x871/0x1600 kernel/workqueue.c:2246
 #1: ffffc900116bfda8 ((work_completion)(&ctx->exit_work)){+.+.}-{0:0}, at: process_one_work+0x8a5/0x1600 kernel/workqueue.c:2250
2 locks held by kworker/u4:34/15535:
 #0: ffff88800fc69138 ((wq_completion)events_unbound){+.+.}-{0:0}, at: arch_atomic64_set arch/x86/include/asm/atomic64_64.h:34 [inline]
 #0: ffff88800fc69138 ((wq_completion)events_unbound){+.+.}-{0:0}, at: atomic64_set include/asm-generic/atomic-instrumented.h:856 [inline]
 #0: ffff88800fc69138 ((wq_completion)events_unbound){+.+.}-{0:0}, at: atomic_long_set include/asm-generic/atomic-long.h:41 [inline]
 #0: ffff88800fc69138 ((wq_completion)events_unbound){+.+.}-{0:0}, at: set_work_data kernel/workqueue.c:616 [inline]
 #0: ffff88800fc69138 ((wq_completion)events_unbound){+.+.}-{0:0}, at: set_work_pool_and_clear_pending kernel/workqueue.c:643 [inline]
 #0: ffff88800fc69138 ((wq_completion)events_unbound){+.+.}-{0:0}, at: process_one_work+0x871/0x1600 kernel/workqueue.c:2246
 #1: ffffc9000237fda8 ((work_completion)(&ctx->exit_work)){+.+.}-{0:0}, at: process_one_work+0x8a5/0x1600 kernel/workqueue.c:2250
2 locks held by kworker/u4:35/15640:
 #0: ffff88800fc69138 ((wq_completion)events_unbound){+.+.}-{0:0}, at: arch_atomic64_set arch/x86/include/asm/atomic64_64.h:34 [inline]
 #0: ffff88800fc69138 ((wq_completion)events_unbound){+.+.}-{0:0}, at: atomic64_set include/asm-generic/atomic-instrumented.h:856 [inline]
 #0: ffff88800fc69138 ((wq_completion)events_unbound){+.+.}-{0:0}, at: atomic_long_set include/asm-generic/atomic-long.h:41 [inline]
 #0: ffff88800fc69138 ((wq_completion)events_unbound){+.+.}-{0:0}, at: set_work_data kernel/workqueue.c:616 [inline]
 #0: ffff88800fc69138 ((wq_completion)events_unbound){+.+.}-{0:0}, at: set_work_pool_and_clear_pending kernel/workqueue.c:643 [inline]
 #0: ffff88800fc69138 ((wq_completion)events_unbound){+.+.}-{0:0}, at: process_one_work+0x871/0x1600 kernel/workqueue.c:2246
 #1: ffffc90002defda8 ((work_completion)(&ctx->exit_work)){+.+.}-{0:0}, at: process_one_work+0x8a5/0x1600 kernel/workqueue.c:2250
2 locks held by kworker/u4:36/15854:
 #0: ffff88800fc69138 ((wq_completion)events_unbound){+.+.}-{0:0}, at: arch_atomic64_set arch/x86/include/asm/atomic64_64.h:34 [inline]
 #0: ffff88800fc69138 ((wq_completion)events_unbound){+.+.}-{0:0}, at: atomic64_set include/asm-generic/atomic-instrumented.h:856 [inline]
 #0: ffff88800fc69138 ((wq_completion)events_unbound){+.+.}-{0:0}, at: atomic_long_set include/asm-generic/atomic-long.h:41 [inline]
 #0: ffff88800fc69138 ((wq_completion)events_unbound){+.+.}-{0:0}, at: set_work_data kernel/workqueue.c:616 [inline]
 #0: ffff88800fc69138 ((wq_completion)events_unbound){+.+.}-{0:0}, at: set_work_pool_and_clear_pending kernel/workqueue.c:643 [inline]
 #0: ffff88800fc69138 ((wq_completion)events_unbound){+.+.}-{0:0}, at: process_one_work+0x871/0x1600 kernel/workqueue.c:2246
 #1: ffffc90009ba7da8 ((work_completion)(&ctx->exit_work)){+.+.}-{0:0}, at: process_one_work+0x8a5/0x1600 kernel/workqueue.c:2250
2 locks held by kworker/u4:37/16150:
 #0: ffff88800fc69138 ((wq_completion)events_unbound){+.+.}-{0:0}, at: arch_atomic64_set arch/x86/include/asm/atomic64_64.h:34 [inline]
 #0: ffff88800fc69138 ((wq_completion)events_unbound){+.+.}-{0:0}, at: atomic64_set include/asm-generic/atomic-instrumented.h:856 [inline]
 #0: ffff88800fc69138 ((wq_completion)events_unbound){+.+.}-{0:0}, at: atomic_long_set include/asm-generic/atomic-long.h:41 [inline]
 #0: ffff88800fc69138 ((wq_completion)events_unbound){+.+.}-{0:0}, at: set_work_data kernel/workqueue.c:616 [inline]
 #0: ffff88800fc69138 ((wq_completion)events_unbound){+.+.}-{0:0}, at: set_work_pool_and_clear_pending kernel/workqueue.c:643 [inline]
 #0: ffff88800fc69138 ((wq_completion)events_unbound){+.+.}-{0:0}, at: process_one_work+0x871/0x1600 kernel/workqueue.c:2246
 #1: ffffc9000b71fda8 ((work_completion)(&ctx->exit_work)){+.+.}-{0:0}, at: process_one_work+0x8a5/0x1600 kernel/workqueue.c:2250
2 locks held by kworker/u4:39/17160:
 #0: ffff88800fc69138 ((wq_completion)events_unbound){+.+.}-{0:0}, at: arch_atomic64_set arch/x86/include/asm/atomic64_64.h:34 [inline]
 #0: ffff88800fc69138 ((wq_completion)events_unbound){+.+.}-{0:0}, at: atomic64_set include/asm-generic/atomic-instrumented.h:856 [inline]
 #0: ffff88800fc69138 ((wq_completion)events_unbound){+.+.}-{0:0}, at: atomic_long_set include/asm-generic/atomic-long.h:41 [inline]
 #0: ffff88800fc69138 ((wq_completion)events_unbound){+.+.}-{0:0}, at: set_work_data kernel/workqueue.c:616 [inline]
 #0: ffff88800fc69138 ((wq_completion)events_unbound){+.+.}-{0:0}, at: set_work_pool_and_clear_pending kernel/workqueue.c:643 [inline]
 #0: ffff88800fc69138 ((wq_completion)events_unbound){+.+.}-{0:0}, at: process_one_work+0x871/0x1600 kernel/workqueue.c:2246
 #1: ffffc90012a8fda8 ((work_completion)(&ctx->exit_work)){+.+.}-{0:0}, at: process_one_work+0x8a5/0x1600 kernel/workqueue.c:2250
5 locks held by kworker/u4:40/17617:
2 locks held by kworker/u4:41/17633:
 #0: ffff88800fc69138 ((wq_completion)events_unbound){+.+.}-{0:0}, at: arch_atomic64_set arch/x86/include/asm/atomic64_64.h:34 [inline]
 #0: ffff88800fc69138 ((wq_completion)events_unbound){+.+.}-{0:0}, at: atomic64_set include/asm-generic/atomic-instrumented.h:856 [inline]
 #0: ffff88800fc69138 ((wq_completion)events_unbound){+.+.}-{0:0}, at: atomic_long_set include/asm-generic/atomic-long.h:41 [inline]
 #0: ffff88800fc69138 ((wq_completion)events_unbound){+.+.}-{0:0}, at: set_work_data kernel/workqueue.c:616 [inline]
 #0: ffff88800fc69138 ((wq_completion)events_unbound){+.+.}-{0:0}, at: set_work_pool_and_clear_pending kernel/workqueue.c:643 [inline]
 #0: ffff88800fc69138 ((wq_completion)events_unbound){+.+.}-{0:0}, at: process_one_work+0x871/0x1600 kernel/workqueue.c:2246
 #1: ffffc90013aefda8 ((work_completion)(&ctx->exit_work)){+.+.}-{0:0}, at: process_one_work+0x8a5/0x1600 kernel/workqueue.c:2250
2 locks held by kworker/u4:43/17720:
2 locks held by kworker/u4:45/17770:
 #0: ffff88800fc69138 ((wq_completion)events_unbound){+.+.}-{0:0}, at: arch_atomic64_set arch/x86/include/asm/atomic64_64.h:34 [inline]
 #0: ffff88800fc69138 ((wq_completion)events_unbound){+.+.}-{0:0}, at: atomic64_set include/asm-generic/atomic-instrumented.h:856 [inline]
 #0: ffff88800fc69138 ((wq_completion)events_unbound){+.+.}-{0:0}, at: atomic_long_set include/asm-generic/atomic-long.h:41 [inline]
 #0: ffff88800fc69138 ((wq_completion)events_unbound){+.+.}-{0:0}, at: set_work_data kernel/workqueue.c:616 [inline]
 #0: ffff88800fc69138 ((wq_completion)events_unbound){+.+.}-{0:0}, at: set_work_pool_and_clear_pending kernel/workqueue.c:643 [inline]
 #0: ffff88800fc69138 ((wq_completion)events_unbound){+.+.}-{0:0}, at: process_one_work+0x871/0x1600 kernel/workqueue.c:2246
 #1: ffffc90013f9fda8 ((work_completion)(&ctx->exit_work)){+.+.}-{0:0}, at: process_one_work+0x8a5/0x1600 kernel/workqueue.c:2250
2 locks held by kworker/u4:46/17829:
 #0: ffff88800fc69138 ((wq_completion)events_unbound){+.+.}-{0:0}, at: arch_atomic64_set arch/x86/include/asm/atomic64_64.h:34 [inline]
 #0: ffff88800fc69138 ((wq_completion)events_unbound){+.+.}-{0:0}, at: atomic64_set include/asm-generic/atomic-instrumented.h:856 [inline]
 #0: ffff88800fc69138 ((wq_completion)events_unbound){+.+.}-{0:0}, at: atomic_long_set include/asm-generic/atomic-long.h:41 [inline]
 #0: ffff88800fc69138 ((wq_completion)events_unbound){+.+.}-{0:0}, at: set_work_data kernel/workqueue.c:616 [inline]
 #0: ffff88800fc69138 ((wq_completion)events_unbound){+.+.}-{0:0}, at: set_work_pool_and_clear_pending kernel/workqueue.c:643 [inline]
 #0: ffff88800fc69138 ((wq_completion)events_unbound){+.+.}-{0:0}, at: process_one_work+0x871/0x1600 kernel/workqueue.c:2246
 #1: ffffc90013f5fda8 ((work_completion)(&ctx->exit_work)){+.+.}-{0:0}, at: process_one_work+0x8a5/0x1600 kernel/workqueue.c:2250
2 locks held by kworker/u4:47/17991:
 #0: ffff88800fc69138 ((wq_completion)events_unbound){+.+.}-{0:0}, at: arch_atomic64_set arch/x86/include/asm/atomic64_64.h:34 [inline]
 #0: ffff88800fc69138 ((wq_completion)events_unbound){+.+.}-{0:0}, at: atomic64_set include/asm-generic/atomic-instrumented.h:856 [inline]
 #0: ffff88800fc69138 ((wq_completion)events_unbound){+.+.}-{0:0}, at: atomic_long_set include/asm-generic/atomic-long.h:41 [inline]
 #0: ffff88800fc69138 ((wq_completion)events_unbound){+.+.}-{0:0}, at: set_work_data kernel/workqueue.c:616 [inline]
 #0: ffff88800fc69138 ((wq_completion)events_unbound){+.+.}-{0:0}, at: set_work_pool_and_clear_pending kernel/workqueue.c:643 [inline]
 #0: ffff88800fc69138 ((wq_completion)events_unbound){+.+.}-{0:0}, at: process_one_work+0x871/0x1600 kernel/workqueue.c:2246
 #1: ffffc9001479fda8 ((work_completion)(&ctx->exit_work)){+.+.}-{0:0}, at: process_one_work+0x8a5/0x1600 kernel/workqueue.c:2250
2 locks held by kworker/u4:48/19272:
 #0: ffff88800fc69138 ((wq_completion)events_unbound){+.+.}-{0:0}, at: arch_atomic64_set arch/x86/include/asm/atomic64_64.h:34 [inline]
 #0: ffff88800fc69138 ((wq_completion)events_unbound){+.+.}-{0:0}, at: atomic64_set include/asm-generic/atomic-instrumented.h:856 [inline]
 #0: ffff88800fc69138 ((wq_completion)events_unbound){+.+.}-{0:0}, at: atomic_long_set include/asm-generic/atomic-long.h:41 [inline]
 #0: ffff88800fc69138 ((wq_completion)events_unbound){+.+.}-{0:0}, at: set_work_data kernel/workqueue.c:616 [inline]
 #0: ffff88800fc69138 ((wq_completion)events_unbound){+.+.}-{0:0}, at: set_work_pool_and_clear_pending kernel/workqueue.c:643 [inline]
 #0: ffff88800fc69138 ((wq_completion)events_unbound){+.+.}-{0:0}, at: process_one_work+0x871/0x1600 kernel/workqueue.c:2246
 #1: ffffc9001280fda8 ((work_completion)(&ctx->exit_work)){+.+.}-{0:0}, at: process_one_work+0x8a5/0x1600 kernel/workqueue.c:2250
2 locks held by systemd-udevd/21711:
 #0: ffff88801b9c4910 (&ei->i_mmap_sem){++++}-{3:3}, at: ext4_filemap_fault+0x7f/0xc0 fs/ext4/inode.c:6193
 #1: ffffffff8b88ca40 (fs_reclaim){+.+.}-{0:0}, at: fs_reclaim_acquire+0xf7/0x150 mm/page_alloc.c:4349
1 lock held by syz-executor.0/21744:
 #0: ffffffff8b77d328 (rcu_state.exp_mutex){+.+.}-{3:3}, at: exp_funnel_lock kernel/rcu/tree_exp.h:290 [inline]
 #0: ffffffff8b77d328 (rcu_state.exp_mutex){+.+.}-{3:3}, at: synchronize_rcu_expedited+0x4fa/0x620 kernel/rcu/tree_exp.h:836

=============================================

NMI backtrace for cpu 1
CPU: 1 PID: 1622 Comm: khungtaskd Not tainted 5.12.0-rc2-syzkaller #0
Hardware name: Google Google Compute Engine/Google Compute Engine, BIOS Google 01/01/2011
Call Trace:
 __dump_stack lib/dump_stack.c:79 [inline]
 dump_stack+0x141/0x1d7 lib/dump_stack.c:120
 nmi_cpu_backtrace.cold+0x44/0xd7 lib/nmi_backtrace.c:105
 nmi_trigger_cpumask_backtrace+0x1b3/0x230 lib/nmi_backtrace.c:62
 trigger_all_cpu_backtrace include/linux/nmi.h:146 [inline]
 check_hung_uninterruptible_tasks kernel/hung_task.c:209 [inline]
 watchdog+0xd48/0xfb0 kernel/hung_task.c:294
 kthread+0x3b1/0x4a0 kernel/kthread.c:292
 ret_from_fork+0x1f/0x30 arch/x86/entry/entry_64.S:294
Sending NMI from CPU 1 to CPUs 0:
NMI backtrace for cpu 0
CPU: 0 PID: 2126 Comm: kswapd1 Not tainted 5.12.0-rc2-syzkaller #0
Hardware name: Google Google Compute Engine/Google Compute Engine, BIOS Google 01/01/2011
RIP: 0010:lockdep_enabled kernel/locking/lockdep.c:90 [inline]
RIP: 0010:lock_is_held_type+0x3a/0x140 kernel/locking/lockdep.c:5542
Code: 48 83 ec 08 8b 0d b2 5d 44 04 85 c9 0f 84 d7 00 00 00 65 8b 05 97 3d 01 77 85 c0 0f 85 c8 00 00 00 65 4c 8b 24 25 00 f0 01 00 <41> 8b 94 24 e4 09 00 00 85 d2 0f 85 af 00 00 00 48 89 fd 41 89 f6
RSP: 0018:ffffc90007fe7148 EFLAGS: 00000246
RAX: 0000000000000000 RBX: 0000000000000000 RCX: 0000000000000001
RDX: 0000000000000000 RSI: 00000000ffffffff RDI: ffffffff8b7746a0
RBP: ffffffff897625c0 R08: 0000000000000000 R09: 0000000000000000
R10: ffffffff81abc9e6 R11: 0000000000000000 R12: ffff888016a5b880
R13: 0000000000000001 R14: 0000000000000000 R15: ffffea0008dba480
FS:  0000000000000000(0000) GS:ffff8880b9e00000(0000) knlGS:0000000000000000
CS:  0010 DS: 0000 ES: 0000 CR0: 0000000080050033
CR2: 00007fff403f6f7c CR3: 000000000b48e000 CR4: 00000000001506f0
DR0: 0000000000000000 DR1: 0000000000000000 DR2: 0000000000000000
DR3: 0000000000000000 DR6: 00000000fffe0ff0 DR7: 0000000000000400
Call Trace:
 lock_is_held include/linux/lockdep.h:278 [inline]
 ___might_sleep+0x23f/0x2c0 kernel/sched/core.c:8296
 mmu_notifier_invalidate_range_start include/linux/mmu_notifier.h:448 [inline]
 try_to_unmap_one+0x376/0x2b10 mm/rmap.c:1440
 rmap_walk_file+0x567/0xca0 mm/rmap.c:1936
 rmap_walk+0x105/0x190 mm/rmap.c:1954
 try_to_unmap+0x315/0x390 mm/rmap.c:1778
 shrink_page_list+0x2dd1/0x6420 mm/vmscan.c:1306
 shrink_inactive_list+0x347/0xca0 mm/vmscan.c:1948
 shrink_list mm/vmscan.c:2170 [inline]
 shrink_lruvec+0x7f9/0x14f0 mm/vmscan.c:2465
 shrink_node_memcgs mm/vmscan.c:2653 [inline]
 shrink_node+0x868/0x1de0 mm/vmscan.c:2770
 kswapd_shrink_node mm/vmscan.c:3513 [inline]
 balance_pgdat+0x745/0x1270 mm/vmscan.c:3671
 kswapd+0x5b6/0xdb0 mm/vmscan.c:3928
 kthread+0x3b1/0x4a0 kernel/kthread.c:292
 ret_from_fork+0x1f/0x30 arch/x86/entry/entry_64.S:294


Tested on:

commit:         07c3d710 Revert "Revert "io_uring: wait potential ->releas..
git tree:       https://github.com/isilence/linux.git syz_test2
console output: https://syzkaller.appspot.com/x/log.txt?x=13e6e986d00000
kernel config:  https://syzkaller.appspot.com/x/.config?x=86318203e865a02b
dashboard link: https://syzkaller.appspot.com/bug?extid=93f72b3885406bb09e0d
compiler:       

