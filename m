Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 1A701326C2C
	for <lists+io-uring@lfdr.de>; Sat, 27 Feb 2021 09:00:14 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229849AbhB0H75 (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Sat, 27 Feb 2021 02:59:57 -0500
Received: from mail-il1-f198.google.com ([209.85.166.198]:45369 "EHLO
        mail-il1-f198.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229795AbhB0H7z (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Sat, 27 Feb 2021 02:59:55 -0500
Received: by mail-il1-f198.google.com with SMTP id h17so8821558ila.12
        for <io-uring@vger.kernel.org>; Fri, 26 Feb 2021 23:59:39 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:date:message-id:subject:from:to;
        bh=nUvoNP5wxjco/3yNPNsZUbWgktQSvo7XfdKtrgDvgP4=;
        b=Pdj7ryANmfkF89zua43YgYPI13tgfI1On/YwRXtNr94DjqWPUnY+Ulw+bbw/l+/Gmh
         D+r1gpFlW+bahYLM5obKNuxfQGgiIeHgPetGUmkb7C1L+/ErQZNm+M5QYtgt1Bx3m/QG
         lTfld5qj2lVHHLEYe2BYKUgzeufX+ZSiTKvSj5bl0ofc65eDdquMuS8yz8VDW5vuVl7m
         GoFyeXyaMV8xz5WHwIK5Pvs3DE/A0hT8XuMbW0d6TagiM64OtQ6vfDKnCWQpjcaeTBu4
         s2QN96ZQgR8s5MU2MrsZO6Yvr0KW02+TpM3TcU2F+9Jq4flYWgeZR8oZn6l+I7X/BMMM
         Ug+Q==
X-Gm-Message-State: AOAM531YQJ/evUwcm/ICqvO02W+dRrZ700+OCUCRHuEGHVBIibtN4nHh
        G/+WhKZ50KAF4jpmf6guwKkr7MFsLYrGi38VKbNOwzSB2wu9
X-Google-Smtp-Source: ABdhPJyPWKPFAKEHbjQFv2OucE2gn6NwiZMD/CH6rXdlXaiByMOSM7UljGcFisIAc5/IrPd117ZCdjsmcrWMNVxwj/hvzuiD9HEh
MIME-Version: 1.0
X-Received: by 2002:a5e:cb4b:: with SMTP id h11mr6164933iok.108.1614412754008;
 Fri, 26 Feb 2021 23:59:14 -0800 (PST)
Date:   Fri, 26 Feb 2021 23:59:14 -0800
X-Google-Appengine-App-Id: s~syzkaller
X-Google-Appengine-App-Id-Alias: syzkaller
Message-ID: <000000000000b93e3405bc4cc2d6@google.com>
Subject: INFO: task can't die in task_thread
From:   syzbot <syzbot+424fd30c996924e270a9@syzkaller.appspotmail.com>
To:     asml.silence@gmail.com, axboe@kernel.dk, christian@brauner.io,
        io-uring@vger.kernel.org, linux-kernel@vger.kernel.org,
        syzkaller-bugs@googlegroups.com
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org

Hello,

syzbot found the following issue on:

HEAD commit:    d01f2f7e Add linux-next specific files for 20210226
git tree:       linux-next
console output: https://syzkaller.appspot.com/x/log.txt?x=17a449cad00000
kernel config:  https://syzkaller.appspot.com/x/.config?x=a1746d2802a82a05
dashboard link: https://syzkaller.appspot.com/bug?extid=424fd30c996924e270a9

Unfortunately, I don't have any reproducer for this issue yet.

IMPORTANT: if you fix the issue, please add the following tag to the commit:
Reported-by: syzbot+424fd30c996924e270a9@syzkaller.appspotmail.com

INFO: task iou-wrk-14642:14654 can't die for more than 143 seconds.
task:iou-wrk-14642   state:R  running task     stack:29768 pid:14654 ppid:  8579 flags:0x00004006
Call Trace:
 context_switch kernel/sched/core.c:4324 [inline]
 __schedule+0x90c/0x21a0 kernel/sched/core.c:5075
 schedule+0xcf/0x270 kernel/sched/core.c:5154
 schedule_timeout+0x14a/0x250 kernel/time/timer.c:1892
 io_wqe_worker fs/io-wq.c:512 [inline]
 task_thread.isra.0+0x8d0/0x1380 fs/io-wq.c:602
 task_thread_bound+0x18/0x20 fs/io-wq.c:608
 ret_from_fork+0x1f/0x30 arch/x86/entry/entry_64.S:294
INFO: task iou-wrk-14642:14655 can't die for more than 144 seconds.
task:iou-wrk-14642   state:R  running task     stack:29704 pid:14655 ppid:  8579 flags:0x00004006
Call Trace:
 context_switch kernel/sched/core.c:4324 [inline]
 __schedule+0x90c/0x21a0 kernel/sched/core.c:5075
 schedule+0xcf/0x270 kernel/sched/core.c:5154
 schedule_timeout+0x14a/0x250 kernel/time/timer.c:1892
 io_wqe_worker fs/io-wq.c:512 [inline]
 task_thread.isra.0+0x8d0/0x1380 fs/io-wq.c:602
 task_thread_unbound+0x1b/0x20 fs/io-wq.c:613
 ret_from_fork+0x1f/0x30 arch/x86/entry/entry_64.S:294
INFO: task iou-wrk-14642:14656 can't die for more than 144 seconds.
task:iou-wrk-14642   state:R  running task     stack:29480 pid:14656 ppid:  8579 flags:0x00004006
Call Trace:
 context_switch kernel/sched/core.c:4324 [inline]
 __schedule+0x90c/0x21a0 kernel/sched/core.c:5075
 schedule+0xcf/0x270 kernel/sched/core.c:5154
INFO: task iou-wrk-14642:14657 can't die for more than 145 seconds.
task:iou-wrk-14642   state:R  running task     stack:29512 pid:14657 ppid:  8579 flags:0x00004006
Call Trace:
 context_switch kernel/sched/core.c:4324 [inline]
 __schedule+0x90c/0x21a0 kernel/sched/core.c:5075
 schedule+0xcf/0x270 kernel/sched/core.c:5154
 schedule_timeout+0x14a/0x250 kernel/time/timer.c:1892
 io_wqe_worker fs/io-wq.c:512 [inline]
 task_thread.isra.0+0x8d0/0x1380 fs/io-wq.c:602
 task_thread_unbound+0x1b/0x20 fs/io-wq.c:613
 ret_from_fork+0x1f/0x30 arch/x86/entry/entry_64.S:294
INFO: task iou-wrk-14642:14659 can't die for more than 146 seconds.
task:iou-wrk-14642   state:R  running task     stack:29768 pid:14659 ppid:  8579 flags:0x00004006
Call Trace:
 context_switch kernel/sched/core.c:4324 [inline]
 __schedule+0x90c/0x21a0 kernel/sched/core.c:5075
 schedule+0xcf/0x270 kernel/sched/core.c:5154
 schedule_timeout+0x14a/0x250 kernel/time/timer.c:1892
 io_wqe_worker fs/io-wq.c:512 [inline]
 task_thread.isra.0+0x8d0/0x1380 fs/io-wq.c:602
 task_thread_unbound+0x1b/0x20 fs/io-wq.c:613
 ret_from_fork+0x1f/0x30 arch/x86/entry/entry_64.S:294
INFO: task iou-wrk-14642:14661 can't die for more than 147 seconds.
task:iou-wrk-14642   state:R  running task     stack:29768 pid:14661 ppid:  8579 flags:0x00004006
Call Trace:
 context_switch kernel/sched/core.c:4324 [inline]
 __schedule+0x90c/0x21a0 kernel/sched/core.c:5075
 schedule+0xcf/0x270 kernel/sched/core.c:5154
 schedule_timeout+0x14a/0x250 kernel/time/timer.c:1892
 io_wqe_worker fs/io-wq.c:512 [inline]
 task_thread.isra.0+0x8d0/0x1380 fs/io-wq.c:602
 task_thread_bound+0x18/0x20 fs/io-wq.c:608
 ret_from_fork+0x1f/0x30 arch/x86/entry/entry_64.S:294
INFO: task iou-wrk-14642:14665 can't die for more than 147 seconds.
task:iou-wrk-14642   state:R  running task     stack:29328 pid:14665 ppid:  8579 flags:0x00004006
Call Trace:
 context_switch kernel/sched/core.c:4324 [inline]
 __schedule+0x90c/0x21a0 kernel/sched/core.c:5075
 schedule+0xcf/0x270 kernel/sched/core.c:5154
 schedule_timeout+0x14a/0x250 kernel/time/timer.c:1892
 io_wqe_worker fs/io-wq.c:512 [inline]
 task_thread.isra.0+0x8d0/0x1380 fs/io-wq.c:602
 task_thread_bound+0x18/0x20 fs/io-wq.c:608
 ret_from_fork+0x1f/0x30 arch/x86/entry/entry_64.S:294
INFO: task iou-wrk-14642:14666 can't die for more than 148 seconds.
task:iou-wrk-14642   state:R  running task     stack:29552 pid:14666 ppid:  8579 flags:0x00004006
Call Trace:
 context_switch kernel/sched/core.c:4324 [inline]
 __schedule+0x90c/0x21a0 kernel/sched/core.c:5075
 schedule+0xcf/0x270 kernel/sched/core.c:5154
 schedule_timeout+0x14a/0x250 kernel/time/timer.c:1892
 io_wqe_worker fs/io-wq.c:512 [inline]
 task_thread.isra.0+0x8d0/0x1380 fs/io-wq.c:602
 task_thread_unbound+0x1b/0x20 fs/io-wq.c:613
 ret_from_fork+0x1f/0x30 arch/x86/entry/entry_64.S:294
INFO: task iou-wrk-14642:14668 can't die for more than 149 seconds.
task:iou-wrk-14642   state:R  running task     stack:29704 pid:14668 ppid:  8579 flags:0x00004006
Call Trace:
 context_switch kernel/sched/core.c:4324 [inline]
 __schedule+0x90c/0x21a0 kernel/sched/core.c:5075

Showing all locks held in the system:
2 locks held by kworker/u4:0/8:
 #0: ffff888010869138 ((wq_completion)events_unbound){+.+.}-{0:0}, at: arch_atomic64_set arch/x86/include/asm/atomic64_64.h:34 [inline]
 #0: ffff888010869138 ((wq_completion)events_unbound){+.+.}-{0:0}, at: atomic64_set include/asm-generic/atomic-instrumented.h:856 [inline]
 #0: ffff888010869138 ((wq_completion)events_unbound){+.+.}-{0:0}, at: atomic_long_set include/asm-generic/atomic-long.h:41 [inline]
 #0: ffff888010869138 ((wq_completion)events_unbound){+.+.}-{0:0}, at: set_work_data kernel/workqueue.c:616 [inline]
 #0: ffff888010869138 ((wq_completion)events_unbound){+.+.}-{0:0}, at: set_work_pool_and_clear_pending kernel/workqueue.c:643 [inline]
 #0: ffff888010869138 ((wq_completion)events_unbound){+.+.}-{0:0}, at: process_one_work+0x871/0x1600 kernel/workqueue.c:2246
 #1: ffffc90000cd7da8 ((work_completion)(&ctx->exit_work)){+.+.}-{0:0}, at: process_one_work+0x8a5/0x1600 kernel/workqueue.c:2250
2 locks held by kworker/u4:1/24:
 #0: ffff888010869138 ((wq_completion)events_unbound){+.+.}-{0:0}, at: arch_atomic64_set arch/x86/include/asm/atomic64_64.h:34 [inline]
 #0: ffff888010869138 ((wq_completion)events_unbound){+.+.}-{0:0}, at: atomic64_set include/asm-generic/atomic-instrumented.h:856 [inline]
 #0: ffff888010869138 ((wq_completion)events_unbound){+.+.}-{0:0}, at: atomic_long_set include/asm-generic/atomic-long.h:41 [inline]
 #0: ffff888010869138 ((wq_completion)events_unbound){+.+.}-{0:0}, at: set_work_data kernel/workqueue.c:616 [inline]
 #0: ffff888010869138 ((wq_completion)events_unbound){+.+.}-{0:0}, at: set_work_pool_and_clear_pending kernel/workqueue.c:643 [inline]
 #0: ffff888010869138 ((wq_completion)events_unbound){+.+.}-{0:0}, at: process_one_work+0x871/0x1600 kernel/workqueue.c:2246
 #1: ffffc90000defda8 ((work_completion)(&ctx->exit_work)){+.+.}-{0:0}, at: process_one_work+0x8a5/0x1600 kernel/workqueue.c:2250
2 locks held by kworker/u4:2/27:
 #0: ffff888010869138 ((wq_completion)events_unbound){+.+.}-{0:0}, at: arch_atomic64_set arch/x86/include/asm/atomic64_64.h:34 [inline]
 #0: ffff888010869138 ((wq_completion)events_unbound){+.+.}-{0:0}, at: atomic64_set include/asm-generic/atomic-instrumented.h:856 [inline]
 #0: ffff888010869138 ((wq_completion)events_unbound){+.+.}-{0:0}, at: atomic_long_set include/asm-generic/atomic-long.h:41 [inline]
 #0: ffff888010869138 ((wq_completion)events_unbound){+.+.}-{0:0}, at: set_work_data kernel/workqueue.c:616 [inline]
 #0: ffff888010869138 ((wq_completion)events_unbound){+.+.}-{0:0}, at: set_work_pool_and_clear_pending kernel/workqueue.c:643 [inline]
 #0: ffff888010869138 ((wq_completion)events_unbound){+.+.}-{0:0}, at: process_one_work+0x871/0x1600 kernel/workqueue.c:2246
 #1: ffffc90000e2fda8 ((work_completion)(&ctx->exit_work)){+.+.}-{0:0}, at: process_one_work+0x8a5/0x1600 kernel/workqueue.c:2250
2 locks held by kworker/u4:4/214:
 #0: ffff888010869138 ((wq_completion)events_unbound){+.+.}-{0:0}, at: arch_atomic64_set arch/x86/include/asm/atomic64_64.h:34 [inline]
 #0: ffff888010869138 ((wq_completion)events_unbound){+.+.}-{0:0}, at: atomic64_set include/asm-generic/atomic-instrumented.h:856 [inline]
 #0: ffff888010869138 ((wq_completion)events_unbound){+.+.}-{0:0}, at: atomic_long_set include/asm-generic/atomic-long.h:41 [inline]
 #0: ffff888010869138 ((wq_completion)events_unbound){+.+.}-{0:0}, at: set_work_data kernel/workqueue.c:616 [inline]
 #0: ffff888010869138 ((wq_completion)events_unbound){+.+.}-{0:0}, at: set_work_pool_and_clear_pending kernel/workqueue.c:643 [inline]
 #0: ffff888010869138 ((wq_completion)events_unbound){+.+.}-{0:0}, at: process_one_work+0x871/0x1600 kernel/workqueue.c:2246
 #1: ffffc9000142fda8 ((work_completion)(&ctx->exit_work)){+.+.}-{0:0}, at: process_one_work+0x8a5/0x1600 kernel/workqueue.c:2250
2 locks held by kworker/u4:5/231:
 #0: ffff888010869138 ((wq_completion)events_unbound){+.+.}-{0:0}, at: arch_atomic64_set arch/x86/include/asm/atomic64_64.h:34 [inline]
 #0: ffff888010869138 ((wq_completion)events_unbound){+.+.}-{0:0}, at: atomic64_set include/asm-generic/atomic-instrumented.h:856 [inline]
 #0: ffff888010869138 ((wq_completion)events_unbound){+.+.}-{0:0}, at: atomic_long_set include/asm-generic/atomic-long.h:41 [inline]
 #0: ffff888010869138 ((wq_completion)events_unbound){+.+.}-{0:0}, at: set_work_data kernel/workqueue.c:616 [inline]
 #0: ffff888010869138 ((wq_completion)events_unbound){+.+.}-{0:0}, at: set_work_pool_and_clear_pending kernel/workqueue.c:643 [inline]
 #0: ffff888010869138 ((wq_completion)events_unbound){+.+.}-{0:0}, at: process_one_work+0x871/0x1600 kernel/workqueue.c:2246
 #1: ffffc9000199fda8 ((work_completion)(&ctx->exit_work)){+.+.}-{0:0}, at: process_one_work+0x8a5/0x1600 kernel/workqueue.c:2250
2 locks held by kworker/u4:6/283:
 #0: ffff888010869138 ((wq_completion)events_unbound){+.+.}-{0:0}, at: arch_atomic64_set arch/x86/include/asm/atomic64_64.h:34 [inline]
 #0: ffff888010869138 ((wq_completion)events_unbound){+.+.}-{0:0}, at: atomic64_set include/asm-generic/atomic-instrumented.h:856 [inline]
 #0: ffff888010869138 ((wq_completion)events_unbound){+.+.}-{0:0}, at: atomic_long_set include/asm-generic/atomic-long.h:41 [inline]
 #0: ffff888010869138 ((wq_completion)events_unbound){+.+.}-{0:0}, at: set_work_data kernel/workqueue.c:616 [inline]
 #0: ffff888010869138 ((wq_completion)events_unbound){+.+.}-{0:0}, at: set_work_pool_and_clear_pending kernel/workqueue.c:643 [inline]
 #0: ffff888010869138 ((wq_completion)events_unbound){+.+.}-{0:0}, at: process_one_work+0x871/0x1600 kernel/workqueue.c:2246
 #1: ffffc90001c9fda8 ((work_completion)(&ctx->exit_work)){+.+.}-{0:0}, at: process_one_work+0x8a5/0x1600 kernel/workqueue.c:2250
2 locks held by kworker/u4:7/370:
 #0: ffff888010869138 ((wq_completion)events_unbound){+.+.}-{0:0}, at: arch_atomic64_set arch/x86/include/asm/atomic64_64.h:34 [inline]
 #0: ffff888010869138 ((wq_completion)events_unbound){+.+.}-{0:0}, at: atomic64_set include/asm-generic/atomic-instrumented.h:856 [inline]
 #0: ffff888010869138 ((wq_completion)events_unbound){+.+.}-{0:0}, at: atomic_long_set include/asm-generic/atomic-long.h:41 [inline]
 #0: ffff888010869138 ((wq_completion)events_unbound){+.+.}-{0:0}, at: set_work_data kernel/workqueue.c:616 [inline]
 #0: ffff888010869138 ((wq_completion)events_unbound){+.+.}-{0:0}, at: set_work_pool_and_clear_pending kernel/workqueue.c:643 [inline]
 #0: ffff888010869138 ((wq_completion)events_unbound){+.+.}-{0:0}, at: process_one_work+0x871/0x1600 kernel/workqueue.c:2246
 #1: ffffc900021ffda8 ((work_completion)(&ctx->exit_work)){+.+.}-{0:0}, at: process_one_work+0x8a5/0x1600 kernel/workqueue.c:2250
1 lock held by khungtaskd/1638:
 #0: ffffffff8bf741e0 (rcu_read_lock){....}-{1:2}, at: debug_show_all_locks+0x53/0x260 kernel/locking/lockdep.c:6327
1 lock held by in:imklog/8126:
 #0: ffff888012a234f0 (&f->f_pos_lock){+.+.}-{3:3}, at: __fdget_pos+0xe9/0x100 fs/file.c:961
2 locks held by kworker/u4:8/8482:
 #0: ffff888010869138 ((wq_completion)events_unbound){+.+.}-{0:0}, at: arch_atomic64_set arch/x86/include/asm/atomic64_64.h:34 [inline]
 #0: ffff888010869138 ((wq_completion)events_unbound){+.+.}-{0:0}, at: atomic64_set include/asm-generic/atomic-instrumented.h:856 [inline]
 #0: ffff888010869138 ((wq_completion)events_unbound){+.+.}-{0:0}, at: atomic_long_set include/asm-generic/atomic-long.h:41 [inline]
 #0: ffff888010869138 ((wq_completion)events_unbound){+.+.}-{0:0}, at: set_work_data kernel/workqueue.c:616 [inline]
 #0: ffff888010869138 ((wq_completion)events_unbound){+.+.}-{0:0}, at: set_work_pool_and_clear_pending kernel/workqueue.c:643 [inline]
 #0: ffff888010869138 ((wq_completion)events_unbound){+.+.}-{0:0}, at: process_one_work+0x871/0x1600 kernel/workqueue.c:2246
 #1: ffffc900018efda8 ((work_completion)(&ctx->exit_work)){+.+.}-{0:0}, at: process_one_work+0x8a5/0x1600 kernel/workqueue.c:2250
2 locks held by kworker/u4:9/11890:
 #0: ffff888010869138 ((wq_completion)events_unbound){+.+.}-{0:0}, at: arch_atomic64_set arch/x86/include/asm/atomic64_64.h:34 [inline]
 #0: ffff888010869138 ((wq_completion)events_unbound){+.+.}-{0:0}, at: atomic64_set include/asm-generic/atomic-instrumented.h:856 [inline]
 #0: ffff888010869138 ((wq_completion)events_unbound){+.+.}-{0:0}, at: atomic_long_set include/asm-generic/atomic-long.h:41 [inline]
 #0: ffff888010869138 ((wq_completion)events_unbound){+.+.}-{0:0}, at: set_work_data kernel/workqueue.c:616 [inline]
 #0: ffff888010869138 ((wq_completion)events_unbound){+.+.}-{0:0}, at: set_work_pool_and_clear_pending kernel/workqueue.c:643 [inline]
 #0: ffff888010869138 ((wq_completion)events_unbound){+.+.}-{0:0}, at: process_one_work+0x871/0x1600 kernel/workqueue.c:2246
 #1: ffffc9000c527da8 ((work_completion)(&ctx->exit_work)){+.+.}-{0:0}, at: process_one_work+0x8a5/0x1600 kernel/workqueue.c:2250
2 locks held by kworker/u4:10/12072:
 #0: ffff888010869138 ((wq_completion)events_unbound){+.+.}-{0:0}, at: arch_atomic64_set arch/x86/include/asm/atomic64_64.h:34 [inline]
 #0: ffff888010869138 ((wq_completion)events_unbound){+.+.}-{0:0}, at: atomic64_set include/asm-generic/atomic-instrumented.h:856 [inline]
 #0: ffff888010869138 ((wq_completion)events_unbound){+.+.}-{0:0}, at: atomic_long_set include/asm-generic/atomic-long.h:41 [inline]
 #0: ffff888010869138 ((wq_completion)events_unbound){+.+.}-{0:0}, at: set_work_data kernel/workqueue.c:616 [inline]
 #0: ffff888010869138 ((wq_completion)events_unbound){+.+.}-{0:0}, at: set_work_pool_and_clear_pending kernel/workqueue.c:643 [inline]
 #0: ffff888010869138 ((wq_completion)events_unbound){+.+.}-{0:0}, at: process_one_work+0x871/0x1600 kernel/workqueue.c:2246
 #1: ffffc9001639fda8 ((work_completion)(&ctx->exit_work)){+.+.}-{0:0}, at: process_one_work+0x8a5/0x1600 kernel/workqueue.c:2250
2 locks held by kworker/u4:11/12103:
 #0: ffff888010869138 ((wq_completion)events_unbound){+.+.}-{0:0}, at: arch_atomic64_set arch/x86/include/asm/atomic64_64.h:34 [inline]
 #0: ffff888010869138 ((wq_completion)events_unbound){+.+.}-{0:0}, at: atomic64_set include/asm-generic/atomic-instrumented.h:856 [inline]
 #0: ffff888010869138 ((wq_completion)events_unbound){+.+.}-{0:0}, at: atomic_long_set include/asm-generic/atomic-long.h:41 [inline]
 #0: ffff888010869138 ((wq_completion)events_unbound){+.+.}-{0:0}, at: set_work_data kernel/workqueue.c:616 [inline]
 #0: ffff888010869138 ((wq_completion)events_unbound){+.+.}-{0:0}, at: set_work_pool_and_clear_pending kernel/workqueue.c:643 [inline]
 #0: ffff888010869138 ((wq_completion)events_unbound){+.+.}-{0:0}, at: process_one_work+0x871/0x1600 kernel/workqueue.c:2246
 #1: ffffc9001645fda8 ((work_completion)(&ctx->exit_work)){+.+.}-{0:0}, at: process_one_work+0x8a5/0x1600 kernel/workqueue.c:2250
2 locks held by kworker/u4:12/12139:
 #0: ffff888010869138 ((wq_completion)events_unbound){+.+.}-{0:0}, at: arch_atomic64_set arch/x86/include/asm/atomic64_64.h:34 [inline]
 #0: ffff888010869138 ((wq_completion)events_unbound){+.+.}-{0:0}, at: atomic64_set include/asm-generic/atomic-instrumented.h:856 [inline]
 #0: ffff888010869138 ((wq_completion)events_unbound){+.+.}-{0:0}, at: atomic_long_set include/asm-generic/atomic-long.h:41 [inline]
 #0: ffff888010869138 ((wq_completion)events_unbound){+.+.}-{0:0}, at: set_work_data kernel/workqueue.c:616 [inline]
 #0: ffff888010869138 ((wq_completion)events_unbound){+.+.}-{0:0}, at: set_work_pool_and_clear_pending kernel/workqueue.c:643 [inline]
 #0: ffff888010869138 ((wq_completion)events_unbound){+.+.}-{0:0}, at: process_one_work+0x871/0x1600 kernel/workqueue.c:2246
 #1: ffffc9001654fda8 ((work_completion)(&ctx->exit_work)){+.+.}-{0:0}, at: process_one_work+0x8a5/0x1600 kernel/workqueue.c:2250
2 locks held by kworker/u4:13/12309:
 #0: ffff888010869138 ((wq_completion)events_unbound){+.+.}-{0:0}, at: arch_atomic64_set arch/x86/include/asm/atomic64_64.h:34 [inline]
 #0: ffff888010869138 ((wq_completion)events_unbound){+.+.}-{0:0}, at: atomic64_set include/asm-generic/atomic-instrumented.h:856 [inline]
 #0: ffff888010869138 ((wq_completion)events_unbound){+.+.}-{0:0}, at: atomic_long_set include/asm-generic/atomic-long.h:41 [inline]
 #0: ffff888010869138 ((wq_completion)events_unbound){+.+.}-{0:0}, at: set_work_data kernel/workqueue.c:616 [inline]
 #0: ffff888010869138 ((wq_completion)events_unbound){+.+.}-{0:0}, at: set_work_pool_and_clear_pending kernel/workqueue.c:643 [inline]
 #0: ffff888010869138 ((wq_completion)events_unbound){+.+.}-{0:0}, at: process_one_work+0x871/0x1600 kernel/workqueue.c:2246
 #1: ffffc90016cb7da8 ((work_completion)(&ctx->exit_work)){+.+.}-{0:0}, at: process_one_work+0x8a5/0x1600 kernel/workqueue.c:2250
3 locks held by kworker/u4:16/12501:
2 locks held by kworker/u4:19/14398:
 #0: ffff888010869138 ((wq_completion)events_unbound){+.+.}-{0:0}, at: arch_atomic64_set arch/x86/include/asm/atomic64_64.h:34 [inline]
 #0: ffff888010869138 ((wq_completion)events_unbound){+.+.}-{0:0}, at: atomic64_set include/asm-generic/atomic-instrumented.h:856 [inline]
 #0: ffff888010869138 ((wq_completion)events_unbound){+.+.}-{0:0}, at: atomic_long_set include/asm-generic/atomic-long.h:41 [inline]
 #0: ffff888010869138 ((wq_completion)events_unbound){+.+.}-{0:0}, at: set_work_data kernel/workqueue.c:616 [inline]
 #0: ffff888010869138 ((wq_completion)events_unbound){+.+.}-{0:0}, at: set_work_pool_and_clear_pending kernel/workqueue.c:643 [inline]
 #0: ffff888010869138 ((wq_completion)events_unbound){+.+.}-{0:0}, at: process_one_work+0x871/0x1600 kernel/workqueue.c:2246
 #1: ffffc90001a1fda8 ((work_completion)(&ctx->exit_work)){+.+.}-{0:0}, at: process_one_work+0x8a5/0x1600 kernel/workqueue.c:2250
1 lock held by iou-wrk-14642/14665:

=============================================



---
This report is generated by a bot. It may contain errors.
See https://goo.gl/tpsmEJ for more information about syzbot.
syzbot engineers can be reached at syzkaller@googlegroups.com.

syzbot will keep track of this issue. See:
https://goo.gl/tpsmEJ#status for how to communicate with syzbot.
