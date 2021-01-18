Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id C5CF42FA063
	for <lists+io-uring@lfdr.de>; Mon, 18 Jan 2021 13:51:39 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2404416AbhARMvR (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Mon, 18 Jan 2021 07:51:17 -0500
Received: from mail-io1-f71.google.com ([209.85.166.71]:43362 "EHLO
        mail-io1-f71.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S2404148AbhARMqv (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Mon, 18 Jan 2021 07:46:51 -0500
Received: by mail-io1-f71.google.com with SMTP id n18so9242752ioo.10
        for <io-uring@vger.kernel.org>; Mon, 18 Jan 2021 04:46:35 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:date:in-reply-to:message-id:subject
         :from:to;
        bh=YJ2ANZh2M04vWIUzXzQCuyA7q10YXGQQfQOyJ16QsJQ=;
        b=Kj+dTEMZwufA3fwMp951QDaJ85IWoLm+uQ7UhFtcTxrPS7BCw5z1FGL45NSh+VjL4F
         EEjr2rNzDDGDOc7vbQylJHSxo8sMUigoS/dOcxCIp1vbMgwWJOl2a+d3/IwKT2IG+sON
         PtxsQvv1aqeZbPwZzZph2MrjMXYA9XJxtwzcf5M3xa90x03cPG3AxfiitZIdrwBQRghr
         GqUYRDODHzeeuD122KO3Ot+vqq87460sSrDtAHPZZmO+eucEcu9aFiktzN7TkzyZ3MLz
         LSoCI5K2le/7ECrd+/H+c4wi3sZsKZ/5bBmhU66REjOtueEwclKHrHBVryoPpmoym1e5
         sn8A==
X-Gm-Message-State: AOAM533s+iiIMjsoRwP/l27khWdycMuK+rYFAqhTgNJmvt4goSvSqZew
        r3cSDfuSZQEq43/X2U+CEragZYcClqc/6q33f8SmT+biMqEN
X-Google-Smtp-Source: ABdhPJyvUCul7O32EEGQQpAgC1b3Kmj9J0hr07NS4qMNTULjpHrJ7HHEC4Gn8bVciPY4mooj+jjd4oOi/jKLw1acis6LzuYEZgP+
MIME-Version: 1.0
X-Received: by 2002:a92:85d4:: with SMTP id f203mr5939706ilh.232.1610973970611;
 Mon, 18 Jan 2021 04:46:10 -0800 (PST)
Date:   Mon, 18 Jan 2021 04:46:10 -0800
In-Reply-To: <1e51be0f-98a1-6dd2-63da-02e92e79a4ef@gmail.com>
X-Google-Appengine-App-Id: s~syzkaller
X-Google-Appengine-App-Id-Alias: syzkaller
Message-ID: <00000000000042c22b05b92c1b44@google.com>
Subject: Re: WARNING in io_disable_sqo_submit
From:   syzbot <syzbot+2f5d1785dc624932da78@syzkaller.appspotmail.com>
To:     asml.silence@gmail.com, axboe@kernel.dk, hdanton@sina.com,
        io-uring@vger.kernel.org, linux-fsdevel@vger.kernel.org,
        linux-kernel@vger.kernel.org, syzkaller-bugs@googlegroups.com,
        viro@zeniv.linux.org.uk
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org

Hello,

syzbot has tested the proposed patch but the reproducer is still triggering an issue:
INFO: task hung in io_sq_thread_stop

INFO: task kworker/u4:0:8 blocked for more than 143 seconds.
      Not tainted 5.11.0-rc1-syzkaller #0
"echo 0 > /proc/sys/kernel/hung_task_timeout_secs" disables this message.
task:kworker/u4:0    state:D stack:24056 pid:    8 ppid:     2 flags:0x00004000
Workqueue: events_unbound io_ring_exit_work
Call Trace:
 context_switch kernel/sched/core.c:4313 [inline]
 __schedule+0x90c/0x21a0 kernel/sched/core.c:5064
 schedule+0xcf/0x270 kernel/sched/core.c:5143
 schedule_timeout+0x1d8/0x250 kernel/time/timer.c:1854
 do_wait_for_common kernel/sched/completion.c:85 [inline]
 __wait_for_common kernel/sched/completion.c:106 [inline]
 wait_for_common kernel/sched/completion.c:117 [inline]
 wait_for_completion+0x163/0x260 kernel/sched/completion.c:138
 kthread_park+0x122/0x1b0 kernel/kthread.c:557
 io_sq_thread_park fs/io_uring.c:7445 [inline]
 io_sq_thread_park fs/io_uring.c:7439 [inline]
 io_sq_thread_stop+0xfe/0x570 fs/io_uring.c:7463
 io_finish_async fs/io_uring.c:7481 [inline]
 io_ring_ctx_free fs/io_uring.c:8646 [inline]
 io_ring_exit_work+0x62/0x6d0 fs/io_uring.c:8739
 process_one_work+0x98d/0x15f0 kernel/workqueue.c:2275
 worker_thread+0x64c/0x1120 kernel/workqueue.c:2421
 kthread+0x3b1/0x4a0 kernel/kthread.c:292
 ret_from_fork+0x1f/0x30 arch/x86/entry/entry_64.S:296

Showing all locks held in the system:
3 locks held by kworker/u4:0/8:
 #0: ffff888010069138 ((wq_completion)events_unbound){+.+.}-{0:0}, at: arch_atomic64_set arch/x86/include/asm/atomic64_64.h:34 [inline]
 #0: ffff888010069138 ((wq_completion)events_unbound){+.+.}-{0:0}, at: atomic64_set include/asm-generic/atomic-instrumented.h:856 [inline]
 #0: ffff888010069138 ((wq_completion)events_unbound){+.+.}-{0:0}, at: atomic_long_set include/asm-generic/atomic-long.h:41 [inline]
 #0: ffff888010069138 ((wq_completion)events_unbound){+.+.}-{0:0}, at: set_work_data kernel/workqueue.c:616 [inline]
 #0: ffff888010069138 ((wq_completion)events_unbound){+.+.}-{0:0}, at: set_work_pool_and_clear_pending kernel/workqueue.c:643 [inline]
 #0: ffff888010069138 ((wq_completion)events_unbound){+.+.}-{0:0}, at: process_one_work+0x871/0x15f0 kernel/workqueue.c:2246
 #1: ffffc90000cd7da8 ((work_completion)(&ctx->exit_work)){+.+.}-{0:0}, at: process_one_work+0x8a5/0x15f0 kernel/workqueue.c:2250
 #2: ffff88801bfd4870 (&sqd->lock){+.+.}-{3:3}, at: io_sq_thread_park fs/io_uring.c:7444 [inline]
 #2: ffff88801bfd4870 (&sqd->lock){+.+.}-{3:3}, at: io_sq_thread_park fs/io_uring.c:7439 [inline]
 #2: ffff88801bfd4870 (&sqd->lock){+.+.}-{3:3}, at: io_sq_thread_stop+0xd6/0x570 fs/io_uring.c:7463
1 lock held by khungtaskd/1647:
 #0: ffffffff8b373aa0 (rcu_read_lock){....}-{1:2}, at: debug_show_all_locks+0x53/0x260 kernel/locking/lockdep.c:6254
1 lock held by in:imklog/8164:
 #0: ffff8880151b8870 (&f->f_pos_lock){+.+.}-{3:3}, at: __fdget_pos+0xe9/0x100 fs/file.c:947
2 locks held by kworker/u4:6/8415:
2 locks held by kworker/0:4/8690:
 #0: ffff88801007c538 ((wq_completion)rcu_gp){+.+.}-{0:0}, at: arch_atomic64_set arch/x86/include/asm/atomic64_64.h:34 [inline]
 #0: ffff88801007c538 ((wq_completion)rcu_gp){+.+.}-{0:0}, at: atomic64_set include/asm-generic/atomic-instrumented.h:856 [inline]
 #0: ffff88801007c538 ((wq_completion)rcu_gp){+.+.}-{0:0}, at: atomic_long_set include/asm-generic/atomic-long.h:41 [inline]
 #0: ffff88801007c538 ((wq_completion)rcu_gp){+.+.}-{0:0}, at: set_work_data kernel/workqueue.c:616 [inline]
 #0: ffff88801007c538 ((wq_completion)rcu_gp){+.+.}-{0:0}, at: set_work_pool_and_clear_pending kernel/workqueue.c:643 [inline]
 #0: ffff88801007c538 ((wq_completion)rcu_gp){+.+.}-{0:0}, at: process_one_work+0x871/0x15f0 kernel/workqueue.c:2246
 #1: ffffc9000288fda8 ((work_completion)(&rew.rew_work)){+.+.}-{0:0}, at: process_one_work+0x8a5/0x15f0 kernel/workqueue.c:2250
1 lock held by syz-executor.3/8865:
 #0: ffff888146ddcd88 (&xt[i].mutex){+.+.}-{3:3}, at: xt_find_table_lock+0x41/0x540 net/netfilter/x_tables.c:1206
1 lock held by syz-executor.2/8867:
 #0: ffff888146ddcd88 (&xt[i].mutex){+.+.}-{3:3}, at: xt_find_table_lock+0x41/0x540 net/netfilter/x_tables.c:1206
2 locks held by syz-executor.5/8869:
 #0: ffff888146ddcd88 (&xt[i].mutex){+.+.}-{3:3}, at: xt_find_table_lock+0x41/0x540 net/netfilter/x_tables.c:1206
 #1: ffffffff8b37c368 (rcu_state.exp_mutex){+.+.}-{3:3}, at: exp_funnel_lock kernel/rcu/tree_exp.h:290 [inline]
 #1: ffffffff8b37c368 (rcu_state.exp_mutex){+.+.}-{3:3}, at: synchronize_rcu_expedited+0x4f2/0x610 kernel/rcu/tree_exp.h:836
1 lock held by syz-executor.4/8870:
 #0: ffff888146ddcd88 (&xt[i].mutex){+.+.}-{3:3}, at: xt_find_table_lock+0x41/0x540 net/netfilter/x_tables.c:1206
1 lock held by syz-executor.0/8872:
 #0: ffff888146ddcd88 (&xt[i].mutex){+.+.}-{3:3}, at: xt_find_table_lock+0x41/0x540 net/netfilter/x_tables.c:1206
1 lock held by syz-executor.1/8873:
 #0: ffff888146ddcd88 (&xt[i].mutex){+.+.}-{3:3}, at: xt_find_table_lock+0x41/0x540 net/netfilter/x_tables.c:1206

=============================================

NMI backtrace for cpu 1
CPU: 1 PID: 1647 Comm: khungtaskd Not tainted 5.11.0-rc1-syzkaller #0
Hardware name: Google Google Compute Engine/Google Compute Engine, BIOS Google 01/01/2011
Call Trace:
 __dump_stack lib/dump_stack.c:79 [inline]
 dump_stack+0x107/0x163 lib/dump_stack.c:120
 nmi_cpu_backtrace.cold+0x44/0xd7 lib/nmi_backtrace.c:105
 nmi_trigger_cpumask_backtrace+0x1b3/0x230 lib/nmi_backtrace.c:62
 trigger_all_cpu_backtrace include/linux/nmi.h:146 [inline]
 check_hung_uninterruptible_tasks kernel/hung_task.c:209 [inline]
 watchdog+0xd43/0xfa0 kernel/hung_task.c:294
 kthread+0x3b1/0x4a0 kernel/kthread.c:292
 ret_from_fork+0x1f/0x30 arch/x86/entry/entry_64.S:296
Sending NMI from CPU 1 to CPUs 0:
NMI backtrace for cpu 0
CPU: 0 PID: 8415 Comm: kworker/u4:6 Not tainted 5.11.0-rc1-syzkaller #0
Hardware name: Google Google Compute Engine/Google Compute Engine, BIOS Google 01/01/2011
Workqueue: bat_events batadv_nc_worker
RIP: 0010:__this_cpu_preempt_check+0xd/0x20 lib/smp_processor_id.c:70
Code: 00 00 48 c7 c6 00 d9 9e 89 48 c7 c7 40 d9 9e 89 e9 98 fe ff ff 0f 1f 84 00 00 00 00 00 55 48 89 fd 0f 1f 44 00 00 48 89 ee 5d <48> c7 c7 80 d9 9e 89 e9 77 fe ff ff cc cc cc cc cc cc cc 0f 1f 44
RSP: 0018:ffffc9000c507af0 EFLAGS: 00000046
RAX: 0000000000000001 RBX: 0000000000000000 RCX: 1ffffffff1a077ab
RDX: 0000000000000000 RSI: ffffffff894bac40 RDI: ffffffff894bac40
RBP: ffffffff8b3739e0 R08: 0000000000000000 R09: ffffffff8d038b8f
R10: fffffbfff1a07171 R11: 0000000000000000 R12: 0000000000000001
R13: ffff88802f858bc0 R14: 00000000ffffffff R15: ffffffff889a5430
FS:  0000000000000000(0000) GS:ffff8880b9e00000(0000) knlGS:0000000000000000
CS:  0010 DS: 0000 ES: 0000 CR0: 0000000080050033
CR2: 00007fbcc03ca000 CR3: 0000000011523000 CR4: 0000000000350ef0
Call Trace:
 lockdep_recursion_inc kernel/locking/lockdep.c:432 [inline]
 lock_is_held_type+0x34/0x100 kernel/locking/lockdep.c:5475
 lock_is_held include/linux/lockdep.h:271 [inline]
 rcu_read_lock_sched_held+0x3a/0x70 kernel/rcu/update.c:123
 trace_lock_release include/trace/events/lock.h:58 [inline]
 lock_release+0x5b7/0x710 kernel/locking/lockdep.c:5448
 __raw_spin_unlock_bh include/linux/spinlock_api_smp.h:174 [inline]
 _raw_spin_unlock_bh+0x12/0x30 kernel/locking/spinlock.c:207
 spin_unlock_bh include/linux/spinlock.h:399 [inline]
 batadv_nc_purge_paths+0x2a5/0x3a0 net/batman-adv/network-coding.c:467
 batadv_nc_worker+0x831/0xe50 net/batman-adv/network-coding.c:716
 process_one_work+0x98d/0x15f0 kernel/workqueue.c:2275
 worker_thread+0x64c/0x1120 kernel/workqueue.c:2421
 kthread+0x3b1/0x4a0 kernel/kthread.c:292
 ret_from_fork+0x1f/0x30 arch/x86/entry/entry_64.S:296


Tested on:

commit:         a1235e44 io_uring: cancel all requests on task exit
git tree:       git://git.kernel.dk/linux-block io_uring-5.11
console output: https://syzkaller.appspot.com/x/log.txt?x=10c53584d00000
kernel config:  https://syzkaller.appspot.com/x/.config?x=c6b6b5cccb0f38f2
dashboard link: https://syzkaller.appspot.com/bug?extid=2f5d1785dc624932da78
compiler:       gcc (GCC) 10.1.0-syz 20200507

