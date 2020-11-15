Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 248632B32F6
	for <lists+io-uring@lfdr.de>; Sun, 15 Nov 2020 09:32:09 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726690AbgKOIbb (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Sun, 15 Nov 2020 03:31:31 -0500
Received: from mail-il1-f198.google.com ([209.85.166.198]:35699 "EHLO
        mail-il1-f198.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726787AbgKOIa3 (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Sun, 15 Nov 2020 03:30:29 -0500
Received: by mail-il1-f198.google.com with SMTP id l2so9801049ilj.2
        for <io-uring@vger.kernel.org>; Sun, 15 Nov 2020 00:30:27 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:date:message-id:subject:from:to;
        bh=yhkV3/tMrdtrAvS4lOhoJ4CXfHY/S2nMAz1BiG29sHE=;
        b=XXqhVWI++cQFokCVow2KUq322VBs9CrXwbjjn5xhC6FwO0OX+umq5im4r2uttVA5Ob
         a/V9HDLnQOoqQNygyOKos7aRqGhTfjUXVpl4AqF9tNwHcMxe4/XizP9mBhyb/pfXlezN
         BtyDb1ODSVO/TiJarEXaCOvpjYu6OlsQOM0uzMtkvO9HrVaTwfiwIpKiJGea0HJEMDpN
         8zQAF674+cRIWY5YJinG1vidasKxWyaYZmXLa8DlTS6iToHM+roU+dCOQ9pliqWTagSg
         K7Dxv5MA5FGAgvnZ1ymDGwhTA8rCbo4BF6mOK8cXFjTsdBAcxyTCO3onb1pko85YfiG+
         7VqA==
X-Gm-Message-State: AOAM531y4HNX5bhOnDGoC0gcZmPCSaYi/Alq8Imp6rECv/QvkyChWo8D
        XrwIh8iuZh6Pp96TM2Gh2YftG+gyNa50Nv6So5yJzoI+G5S9
X-Google-Smtp-Source: ABdhPJxB4tGvsT6KSYHfr3uk8XxX/ci2Mz2uXfftosTElsPfwco9Y95M1vtZ8gYkOc9x5FPPeEtK1ZsKBshZvkErMMvLMgajHrOW
MIME-Version: 1.0
X-Received: by 2002:a02:a488:: with SMTP id d8mr7123849jam.55.1605429016154;
 Sun, 15 Nov 2020 00:30:16 -0800 (PST)
Date:   Sun, 15 Nov 2020 00:30:16 -0800
X-Google-Appengine-App-Id: s~syzkaller
X-Google-Appengine-App-Id-Alias: syzkaller
Message-ID: <00000000000038569805b4211287@google.com>
Subject: INFO: task can't die in io_sq_thread_stop
From:   syzbot <syzbot+03beeb595f074db9cfd1@syzkaller.appspotmail.com>
To:     axboe@kernel.dk, io-uring@vger.kernel.org,
        linux-fsdevel@vger.kernel.org, linux-kernel@vger.kernel.org,
        syzkaller-bugs@googlegroups.com, viro@zeniv.linux.org.uk
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org

Hello,

syzbot found the following issue on:

HEAD commit:    6dd65e60 Add linux-next specific files for 20201110
git tree:       linux-next
console output: https://syzkaller.appspot.com/x/log.txt?x=14727d42500000
kernel config:  https://syzkaller.appspot.com/x/.config?x=4fab43daf5c54712
dashboard link: https://syzkaller.appspot.com/bug?extid=03beeb595f074db9cfd1
compiler:       gcc (GCC) 10.1.0-syz 20200507

Unfortunately, I don't have any reproducer for this issue yet.

IMPORTANT: if you fix the issue, please add the following tag to the commit:
Reported-by: syzbot+03beeb595f074db9cfd1@syzkaller.appspotmail.com

INFO: task syz-executor.2:12399 can't die for more than 143 seconds.
task:syz-executor.2  state:D stack:28744 pid:12399 ppid:  8504 flags:0x00004004
Call Trace:
 context_switch kernel/sched/core.c:3773 [inline]
 __schedule+0x893/0x2170 kernel/sched/core.c:4522
 schedule+0xcf/0x270 kernel/sched/core.c:4600
 schedule_timeout+0x1d8/0x250 kernel/time/timer.c:1847
 do_wait_for_common kernel/sched/completion.c:85 [inline]
 __wait_for_common kernel/sched/completion.c:106 [inline]
 wait_for_common kernel/sched/completion.c:117 [inline]
 wait_for_completion+0x163/0x260 kernel/sched/completion.c:138
 kthread_stop+0x17a/0x720 kernel/kthread.c:596
 io_put_sq_data fs/io_uring.c:7193 [inline]
 io_sq_thread_stop+0x452/0x570 fs/io_uring.c:7290
 io_finish_async fs/io_uring.c:7297 [inline]
 io_sq_offload_create fs/io_uring.c:8015 [inline]
 io_uring_create fs/io_uring.c:9433 [inline]
 io_uring_setup+0x19b7/0x3730 fs/io_uring.c:9507
 do_syscall_64+0x2d/0x70 arch/x86/entry/common.c:46
 entry_SYSCALL_64_after_hwframe+0x44/0xa9
RIP: 0033:0x45deb9
Code: Unable to access opcode bytes at RIP 0x45de8f.
RSP: 002b:00007f174e51ac78 EFLAGS: 00000246 ORIG_RAX: 00000000000001a9
RAX: ffffffffffffffda RBX: 0000000000008640 RCX: 000000000045deb9
RDX: 0000000000000000 RSI: 0000000020000140 RDI: 00000000000050e5
RBP: 000000000118bf58 R08: 0000000000000000 R09: 0000000000000000
R10: 0000000000000000 R11: 0000000000000246 R12: 000000000118bf2c
R13: 00007ffed9ca723f R14: 00007f174e51b9c0 R15: 000000000118bf2c
INFO: task syz-executor.2:12399 blocked for more than 143 seconds.
      Not tainted 5.10.0-rc3-next-20201110-syzkaller #0
"echo 0 > /proc/sys/kernel/hung_task_timeout_secs" disables this message.
task:syz-executor.2  state:D stack:28744 pid:12399 ppid:  8504 flags:0x00004004
Call Trace:
 context_switch kernel/sched/core.c:3773 [inline]
 __schedule+0x893/0x2170 kernel/sched/core.c:4522
 schedule+0xcf/0x270 kernel/sched/core.c:4600
 schedule_timeout+0x1d8/0x250 kernel/time/timer.c:1847
 do_wait_for_common kernel/sched/completion.c:85 [inline]
 __wait_for_common kernel/sched/completion.c:106 [inline]
 wait_for_common kernel/sched/completion.c:117 [inline]
 wait_for_completion+0x163/0x260 kernel/sched/completion.c:138
 kthread_stop+0x17a/0x720 kernel/kthread.c:596
 io_put_sq_data fs/io_uring.c:7193 [inline]
 io_sq_thread_stop+0x452/0x570 fs/io_uring.c:7290
 io_finish_async fs/io_uring.c:7297 [inline]
 io_sq_offload_create fs/io_uring.c:8015 [inline]
 io_uring_create fs/io_uring.c:9433 [inline]
 io_uring_setup+0x19b7/0x3730 fs/io_uring.c:9507
 do_syscall_64+0x2d/0x70 arch/x86/entry/common.c:46
 entry_SYSCALL_64_after_hwframe+0x44/0xa9
RIP: 0033:0x45deb9
Code: Unable to access opcode bytes at RIP 0x45de8f.
RSP: 002b:00007f174e51ac78 EFLAGS: 00000246 ORIG_RAX: 00000000000001a9
RAX: ffffffffffffffda RBX: 0000000000008640 RCX: 000000000045deb9
RDX: 0000000000000000 RSI: 0000000020000140 RDI: 00000000000050e5
RBP: 000000000118bf58 R08: 0000000000000000 R09: 0000000000000000
R10: 0000000000000000 R11: 0000000000000246 R12: 000000000118bf2c
R13: 00007ffed9ca723f R14: 00007f174e51b9c0 R15: 000000000118bf2c

Showing all locks held in the system:
1 lock held by khungtaskd/1653:
 #0: ffffffff8b3386a0 (rcu_read_lock){....}-{1:2}, at: debug_show_all_locks+0x53/0x260 kernel/locking/lockdep.c:6253
1 lock held by systemd-journal/4873:
1 lock held by in:imklog/8167:
 #0: ffff88801c86e0f0 (&f->f_pos_lock){+.+.}-{3:3}, at: __fdget_pos+0xe9/0x100 fs/file.c:932

=============================================

NMI backtrace for cpu 1
CPU: 1 PID: 1653 Comm: khungtaskd Not tainted 5.10.0-rc3-next-20201110-syzkaller #0
Hardware name: Google Google Compute Engine/Google Compute Engine, BIOS Google 01/01/2011
Call Trace:
 __dump_stack lib/dump_stack.c:77 [inline]
 dump_stack+0x107/0x163 lib/dump_stack.c:118
 nmi_cpu_backtrace.cold+0x44/0xd7 lib/nmi_backtrace.c:105
 nmi_trigger_cpumask_backtrace+0x1b3/0x230 lib/nmi_backtrace.c:62
 trigger_all_cpu_backtrace include/linux/nmi.h:147 [inline]
 check_hung_uninterruptible_tasks kernel/hung_task.c:253 [inline]
 watchdog+0xd89/0xf30 kernel/hung_task.c:338
 kthread+0x3af/0x4a0 kernel/kthread.c:292
 ret_from_fork+0x1f/0x30 arch/x86/entry/entry_64.S:296
Sending NMI from CPU 1 to CPUs 0:
NMI backtrace for cpu 0
CPU: 0 PID: 5 Comm: kworker/0:0 Not tainted 5.10.0-rc3-next-20201110-syzkaller #0
Hardware name: Google Google Compute Engine/Google Compute Engine, BIOS Google 01/01/2011
Workqueue: events nsim_dev_trap_report_work
RIP: 0010:mark_lock+0x30/0x24c0 kernel/locking/lockdep.c:4371
Code: 41 54 41 89 d4 48 ba 00 00 00 00 00 fc ff df 55 53 48 81 ec 18 01 00 00 48 8d 5c 24 38 48 89 3c 24 48 c7 44 24 38 b3 8a b5 41 <48> c1 eb 03 48 c7 44 24 40 30 1b c6 8a 48 8d 04 13 48 c7 44 24 48
RSP: 0018:ffffc90000ca7988 EFLAGS: 00000096
RAX: 0000000000000004 RBX: ffffc90000ca79c0 RCX: ffffffff8155b947
RDX: dffffc0000000000 RSI: ffff888010d20918 RDI: ffff888010d20000
RBP: 0000000000000006 R08: 0000000000000000 R09: ffffffff8ebb477f
R10: fffffbfff1d768ef R11: 000000004fb6aa4b R12: 0000000000000006
R13: dffffc0000000000 R14: ffff888010d20918 R15: 0000000000000022
FS:  0000000000000000(0000) GS:ffff8880b9e00000(0000) knlGS:0000000000000000
CS:  0010 DS: 0000 ES: 0000 CR0: 0000000080050033
CR2: 00007f8ffcf99000 CR3: 000000001b2e7000 CR4: 00000000001506f0
DR0: 0000000000000000 DR1: 0000000000000000 DR2: 0000000000000000
DR3: 0000000000000000 DR6: 00000000fffe0ff0 DR7: 0000000000000400
Call Trace:
 mark_held_locks+0x9f/0xe0 kernel/locking/lockdep.c:4011
 __trace_hardirqs_on_caller kernel/locking/lockdep.c:4037 [inline]
 lockdep_hardirqs_on_prepare kernel/locking/lockdep.c:4097 [inline]
 lockdep_hardirqs_on_prepare+0x28b/0x400 kernel/locking/lockdep.c:4049
 trace_hardirqs_on+0x5b/0x1c0 kernel/trace/trace_preemptirq.c:49
 __raw_spin_unlock_irqrestore include/linux/spinlock_api_smp.h:160 [inline]
 _raw_spin_unlock_irqrestore+0x42/0x50 kernel/locking/spinlock.c:191
 extract_crng drivers/char/random.c:1026 [inline]
 _get_random_bytes+0x229/0x670 drivers/char/random.c:1562
 nsim_dev_trap_skb_build drivers/net/netdevsim/dev.c:538 [inline]
 nsim_dev_trap_report drivers/net/netdevsim/dev.c:568 [inline]
 nsim_dev_trap_report_work+0x740/0xbd0 drivers/net/netdevsim/dev.c:609
 process_one_work+0x933/0x15a0 kernel/workqueue.c:2272
 worker_thread+0x64c/0x1120 kernel/workqueue.c:2418
 kthread+0x3af/0x4a0 kernel/kthread.c:292
 ret_from_fork+0x1f/0x30 arch/x86/entry/entry_64.S:296


---
This report is generated by a bot. It may contain errors.
See https://goo.gl/tpsmEJ for more information about syzbot.
syzbot engineers can be reached at syzkaller@googlegroups.com.

syzbot will keep track of this issue. See:
https://goo.gl/tpsmEJ#status for how to communicate with syzbot.
