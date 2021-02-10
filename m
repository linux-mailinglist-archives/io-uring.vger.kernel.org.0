Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id D86CE315BBD
	for <lists+io-uring@lfdr.de>; Wed, 10 Feb 2021 01:57:11 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234674AbhBJA4y (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Tue, 9 Feb 2021 19:56:54 -0500
Received: from mail-io1-f69.google.com ([209.85.166.69]:57245 "EHLO
        mail-io1-f69.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234462AbhBJAyz (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Tue, 9 Feb 2021 19:54:55 -0500
Received: by mail-io1-f69.google.com with SMTP id m2so538915iow.23
        for <io-uring@vger.kernel.org>; Tue, 09 Feb 2021 16:54:38 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:date:message-id:subject:from:to;
        bh=ELLsDRhc1OwIhGjv11zMuyJ1ltE0yFcmeFvVf50z9n0=;
        b=M/0KsINwprewqsaFHaEAKUyS7U2w1tVap0f5QhR1GBrNFhotEUp4AXjjy91VqUAjSL
         uj1SAf+CrQVW1nKWl6xUUFoC+3Gnq12pt9r936zmPJYLzxbSyl4LT/s16JOjbAyr3KrJ
         ki9azmowl3DrqkNCawQpn68tPpdXe1j+6nXCuxhphDOd4ARchRzujhaJh0dGud49VFeV
         3HSt4joi09aehp02KZiYQGv+nMNEljdIYFNBmKd8GKnO10yS8QwwjNKOWHKPHRlTmhcf
         eEU52uoGJC7lO65+Lpu7RQad6txHZ864Inixqikg5c+yfl1ONQUAmDIFpr7aikO6PRoy
         mqQg==
X-Gm-Message-State: AOAM533upVfXrQ7TOQqanA7E1+Qw88iQYGFJwB3aKVCAES82INSKznZ3
        Bq3NNLuK/npBtj31u4iBnerEkg8rbLDrpTJN1lKyKv3Cd7ZM
X-Google-Smtp-Source: ABdhPJziRd9BjJP8MQjGFT377RUnzOl96G/WQ1eNeNV5J7VTF9V5o/+nzhKQGJUK5u71+1ADkZ6A2TnL1f5e9PUo2lchyT+P0eox
MIME-Version: 1.0
X-Received: by 2002:a92:8711:: with SMTP id m17mr601345ild.48.1612918453301;
 Tue, 09 Feb 2021 16:54:13 -0800 (PST)
Date:   Tue, 09 Feb 2021 16:54:13 -0800
X-Google-Appengine-App-Id: s~syzkaller
X-Google-Appengine-App-Id-Alias: syzkaller
Message-ID: <00000000000075f90305baf0d732@google.com>
Subject: INFO: task hung in io_uring_cancel_task_requests
From:   syzbot <syzbot+695b03d82fa8e4901b06@syzkaller.appspotmail.com>
To:     axboe@kernel.dk, io-uring@vger.kernel.org,
        linux-fsdevel@vger.kernel.org, linux-kernel@vger.kernel.org,
        syzkaller-bugs@googlegroups.com, viro@zeniv.linux.org.uk
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org

Hello,

syzbot found the following issue on:

HEAD commit:    dd86e7fa Merge tag 'pci-v5.11-fixes-2' of git://git.kernel..
git tree:       upstream
console output: https://syzkaller.appspot.com/x/log.txt?x=13e43f90d00000
kernel config:  https://syzkaller.appspot.com/x/.config?x=e83e68d0a6aba5f6
dashboard link: https://syzkaller.appspot.com/bug?extid=695b03d82fa8e4901b06
syz repro:      https://syzkaller.appspot.com/x/repro.syz?x=1490f0d4d00000
C reproducer:   https://syzkaller.appspot.com/x/repro.c?x=17aedf1cd00000

IMPORTANT: if you fix the issue, please add the following tag to the commit:
Reported-by: syzbot+695b03d82fa8e4901b06@syzkaller.appspotmail.com

INFO: task syz-executor893:8493 blocked for more than 143 seconds.
      Not tainted 5.11.0-rc6-syzkaller #0
"echo 0 > /proc/sys/kernel/hung_task_timeout_secs" disables this message.
task:syz-executor893 state:D stack:28144 pid: 8493 ppid:  8480 flags:0x00000004
Call Trace:
 context_switch kernel/sched/core.c:4327 [inline]
 __schedule+0x90c/0x21a0 kernel/sched/core.c:5078
 schedule+0xcf/0x270 kernel/sched/core.c:5157
 io_uring_cancel_files fs/io_uring.c:8912 [inline]
 io_uring_cancel_task_requests+0xe70/0x11a0 fs/io_uring.c:8979
 __io_uring_files_cancel+0x110/0x1b0 fs/io_uring.c:9067
 io_uring_files_cancel include/linux/io_uring.h:51 [inline]
 do_exit+0x2fe/0x2ae0 kernel/exit.c:780
 do_group_exit+0x125/0x310 kernel/exit.c:922
 __do_sys_exit_group kernel/exit.c:933 [inline]
 __se_sys_exit_group kernel/exit.c:931 [inline]
 __x64_sys_exit_group+0x3a/0x50 kernel/exit.c:931
 do_syscall_64+0x2d/0x70 arch/x86/entry/common.c:46
 entry_SYSCALL_64_after_hwframe+0x44/0xa9
RIP: 0033:0x43eb19
RSP: 002b:00007ffda99d64d8 EFLAGS: 00000246 ORIG_RAX: 00000000000000e7
RAX: ffffffffffffffda RBX: 00000000004b02f0 RCX: 000000000043eb19
RDX: 000000000000003c RSI: 00000000000000e7 RDI: 0000000000000000
RBP: 0000000000000000 R08: ffffffffffffffc0 R09: 0000000010000000
R10: 0000000000008011 R11: 0000000000000246 R12: 00000000004b02f0
R13: 0000000000000001 R14: 0000000000000000 R15: 0000000000000001
INFO: task syz-executor893:8571 blocked for more than 143 seconds.
      Not tainted 5.11.0-rc6-syzkaller #0
"echo 0 > /proc/sys/kernel/hung_task_timeout_secs" disables this message.
task:syz-executor893 state:D stack:28144 pid: 8571 ppid:  8479 flags:0x00004004
Call Trace:
 context_switch kernel/sched/core.c:4327 [inline]
 __schedule+0x90c/0x21a0 kernel/sched/core.c:5078
 schedule+0xcf/0x270 kernel/sched/core.c:5157
 io_uring_cancel_files fs/io_uring.c:8912 [inline]
 io_uring_cancel_task_requests+0xe70/0x11a0 fs/io_uring.c:8979
 __io_uring_files_cancel+0x110/0x1b0 fs/io_uring.c:9067
 io_uring_files_cancel include/linux/io_uring.h:51 [inline]
 do_exit+0x2fe/0x2ae0 kernel/exit.c:780
 do_group_exit+0x125/0x310 kernel/exit.c:922
 __do_sys_exit_group kernel/exit.c:933 [inline]
 __se_sys_exit_group kernel/exit.c:931 [inline]
 __x64_sys_exit_group+0x3a/0x50 kernel/exit.c:931
 do_syscall_64+0x2d/0x70 arch/x86/entry/common.c:46
 entry_SYSCALL_64_after_hwframe+0x44/0xa9
RIP: 0033:0x43eb19
RSP: 002b:00007ffda99d64d8 EFLAGS: 00000246 ORIG_RAX: 00000000000000e7
RAX: ffffffffffffffda RBX: 00000000004b02f0 RCX: 000000000043eb19
RDX: 000000000000003c RSI: 00000000000000e7 RDI: 0000000000000000
RBP: 0000000000000000 R08: ffffffffffffffc0 R09: 0000000010000000
R10: 0000000000008011 R11: 0000000000000246 R12: 00000000004b02f0
R13: 0000000000000001 R14: 0000000000000000 R15: 0000000000000001
INFO: task syz-executor893:8579 blocked for more than 143 seconds.
      Not tainted 5.11.0-rc6-syzkaller #0
"echo 0 > /proc/sys/kernel/hung_task_timeout_secs" disables this message.
task:syz-executor893 state:D stack:28144 pid: 8579 ppid:  8482 flags:0x00004004
Call Trace:
 context_switch kernel/sched/core.c:4327 [inline]
 __schedule+0x90c/0x21a0 kernel/sched/core.c:5078
 schedule+0xcf/0x270 kernel/sched/core.c:5157
 io_uring_cancel_files fs/io_uring.c:8912 [inline]
 io_uring_cancel_task_requests+0xe70/0x11a0 fs/io_uring.c:8979
 __io_uring_files_cancel+0x110/0x1b0 fs/io_uring.c:9067
 io_uring_files_cancel include/linux/io_uring.h:51 [inline]
 do_exit+0x2fe/0x2ae0 kernel/exit.c:780
 do_group_exit+0x125/0x310 kernel/exit.c:922
 __do_sys_exit_group kernel/exit.c:933 [inline]
 __se_sys_exit_group kernel/exit.c:931 [inline]
 __x64_sys_exit_group+0x3a/0x50 kernel/exit.c:931
 do_syscall_64+0x2d/0x70 arch/x86/entry/common.c:46
 entry_SYSCALL_64_after_hwframe+0x44/0xa9
RIP: 0033:0x43eb19
RSP: 002b:00007ffda99d64d8 EFLAGS: 00000246 ORIG_RAX: 00000000000000e7
RAX: ffffffffffffffda RBX: 00000000004b02f0 RCX: 000000000043eb19
RDX: 000000000000003c RSI: 00000000000000e7 RDI: 0000000000000000
RBP: 0000000000000000 R08: ffffffffffffffc0 R09: 0000000010000000
R10: 0000000000008011 R11: 0000000000000246 R12: 00000000004b02f0
R13: 0000000000000001 R14: 0000000000000000 R15: 0000000000000001
INFO: task syz-executor893:8591 blocked for more than 143 seconds.
      Not tainted 5.11.0-rc6-syzkaller #0
"echo 0 > /proc/sys/kernel/hung_task_timeout_secs" disables this message.
task:syz-executor893 state:D stack:28144 pid: 8591 ppid:  8481 flags:0x00000004
Call Trace:
 context_switch kernel/sched/core.c:4327 [inline]
 __schedule+0x90c/0x21a0 kernel/sched/core.c:5078
 schedule+0xcf/0x270 kernel/sched/core.c:5157
 io_uring_cancel_files fs/io_uring.c:8912 [inline]
 io_uring_cancel_task_requests+0xe70/0x11a0 fs/io_uring.c:8979
 __io_uring_files_cancel+0x110/0x1b0 fs/io_uring.c:9067
 io_uring_files_cancel include/linux/io_uring.h:51 [inline]
 do_exit+0x2fe/0x2ae0 kernel/exit.c:780
 do_group_exit+0x125/0x310 kernel/exit.c:922
 __do_sys_exit_group kernel/exit.c:933 [inline]
 __se_sys_exit_group kernel/exit.c:931 [inline]
 __x64_sys_exit_group+0x3a/0x50 kernel/exit.c:931
 do_syscall_64+0x2d/0x70 arch/x86/entry/common.c:46
 entry_SYSCALL_64_after_hwframe+0x44/0xa9
RIP: 0033:0x43eb19
RSP: 002b:00007ffda99d64d8 EFLAGS: 00000246 ORIG_RAX: 00000000000000e7
RAX: ffffffffffffffda RBX: 00000000004b02f0 RCX: 000000000043eb19
RDX: 000000000000003c RSI: 00000000000000e7 RDI: 0000000000000000
RBP: 0000000000000000 R08: ffffffffffffffc0 R09: 0000000010000000
R10: 0000000000008011 R11: 0000000000000246 R12: 00000000004b02f0
R13: 0000000000000001 R14: 0000000000000000 R15: 0000000000000001
INFO: task syz-executor893:8624 blocked for more than 144 seconds.
      Not tainted 5.11.0-rc6-syzkaller #0
"echo 0 > /proc/sys/kernel/hung_task_timeout_secs" disables this message.
task:syz-executor893 state:D stack:28144 pid: 8624 ppid:  8477 flags:0x00004004
Call Trace:
 context_switch kernel/sched/core.c:4327 [inline]
 __schedule+0x90c/0x21a0 kernel/sched/core.c:5078
 schedule+0xcf/0x270 kernel/sched/core.c:5157
 io_uring_cancel_files fs/io_uring.c:8912 [inline]
 io_uring_cancel_task_requests+0xe70/0x11a0 fs/io_uring.c:8979
 __io_uring_files_cancel+0x110/0x1b0 fs/io_uring.c:9067
 io_uring_files_cancel include/linux/io_uring.h:51 [inline]
 do_exit+0x2fe/0x2ae0 kernel/exit.c:780
 do_group_exit+0x125/0x310 kernel/exit.c:922
 __do_sys_exit_group kernel/exit.c:933 [inline]
 __se_sys_exit_group kernel/exit.c:931 [inline]
 __x64_sys_exit_group+0x3a/0x50 kernel/exit.c:931
 do_syscall_64+0x2d/0x70 arch/x86/entry/common.c:46
 entry_SYSCALL_64_after_hwframe+0x44/0xa9
RIP: 0033:0x43eb19
RSP: 002b:00007ffda99d64d8 EFLAGS: 00000246 ORIG_RAX: 00000000000000e7
RAX: ffffffffffffffda RBX: 00000000004b02f0 RCX: 000000000043eb19
RDX: 000000000000003c RSI: 00000000000000e7 RDI: 0000000000000000
RBP: 0000000000000000 R08: ffffffffffffffc0 R09: 0000000010000000
R10: 0000000000008011 R11: 0000000000000246 R12: 00000000004b02f0
R13: 0000000000000001 R14: 0000000000000000 R15: 0000000000000001
INFO: task syz-executor893:8633 blocked for more than 144 seconds.
      Not tainted 5.11.0-rc6-syzkaller #0
"echo 0 > /proc/sys/kernel/hung_task_timeout_secs" disables this message.
task:syz-executor893 state:D stack:27648 pid: 8633 ppid:  8478 flags:0x00004004
Call Trace:
 context_switch kernel/sched/core.c:4327 [inline]
 __schedule+0x90c/0x21a0 kernel/sched/core.c:5078
 schedule+0xcf/0x270 kernel/sched/core.c:5157
 io_uring_cancel_files fs/io_uring.c:8912 [inline]
 io_uring_cancel_task_requests+0xe70/0x11a0 fs/io_uring.c:8979
 __io_uring_files_cancel+0x110/0x1b0 fs/io_uring.c:9067
 io_uring_files_cancel include/linux/io_uring.h:51 [inline]
 do_exit+0x2fe/0x2ae0 kernel/exit.c:780
 do_group_exit+0x125/0x310 kernel/exit.c:922
 __do_sys_exit_group kernel/exit.c:933 [inline]
 __se_sys_exit_group kernel/exit.c:931 [inline]
 __x64_sys_exit_group+0x3a/0x50 kernel/exit.c:931
 do_syscall_64+0x2d/0x70 arch/x86/entry/common.c:46
 entry_SYSCALL_64_after_hwframe+0x44/0xa9
RIP: 0033:0x43eb19
RSP: 002b:00007ffda99d64d8 EFLAGS: 00000246 ORIG_RAX: 00000000000000e7
RAX: ffffffffffffffda RBX: 00000000004b02f0 RCX: 000000000043eb19
RDX: 000000000000003c RSI: 00000000000000e7 RDI: 0000000000000000
RBP: 0000000000000000 R08: ffffffffffffffc0 R09: 0000000010000000
R10: 0000000000008011 R11: 0000000000000246 R12: 00000000004b02f0
R13: 0000000000000001 R14: 0000000000000000 R15: 0000000000000001

Showing all locks held in the system:
1 lock held by khungtaskd/1638:
 #0: ffffffff8bd73da0 (rcu_read_lock){....}-{1:2}, at: debug_show_all_locks+0x53/0x260 kernel/locking/lockdep.c:6259
2 locks held by in:imklog/8193:
 #0: ffff888019c15bb0 (&f->f_pos_lock){+.+.}-{3:3}, at: __fdget_pos+0xe9/0x100 fs/file.c:947
 #1: ffffffff8bd73da0 (rcu_read_lock){....}-{1:2}, at: is_bpf_text_address+0x0/0x160 kernel/bpf/core.c:687
1 lock held by syz-executor893/8493:
 #0: ffff88801362dc70 (&sqd->lock){+.+.}-{3:3}, at: io_sq_thread_park fs/io_uring.c:7468 [inline]
 #0: ffff88801362dc70 (&sqd->lock){+.+.}-{3:3}, at: io_sq_thread_park fs/io_uring.c:7463 [inline]
 #0: ffff88801362dc70 (&sqd->lock){+.+.}-{3:3}, at: io_uring_cancel_task_requests+0x311/0x11a0 fs/io_uring.c:8973
1 lock held by syz-executor893/8571:
 #0: ffff8880232b3470 (&sqd->lock){+.+.}-{3:3}, at: io_sq_thread_park fs/io_uring.c:7468 [inline]
 #0: ffff8880232b3470 (&sqd->lock){+.+.}-{3:3}, at: io_sq_thread_park fs/io_uring.c:7463 [inline]
 #0: ffff8880232b3470 (&sqd->lock){+.+.}-{3:3}, at: io_uring_cancel_task_requests+0x311/0x11a0 fs/io_uring.c:8973
1 lock held by syz-executor893/8579:
 #0: ffff888014271070 (&sqd->lock){+.+.}-{3:3}, at: io_sq_thread_park fs/io_uring.c:7468 [inline]
 #0: ffff888014271070 (&sqd->lock){+.+.}-{3:3}, at: io_sq_thread_park fs/io_uring.c:7463 [inline]
 #0: ffff888014271070 (&sqd->lock){+.+.}-{3:3}, at: io_uring_cancel_task_requests+0x311/0x11a0 fs/io_uring.c:8973
1 lock held by syz-executor893/8591:
 #0: ffff8880195b2470 (&sqd->lock){+.+.}-{3:3}, at: io_sq_thread_park fs/io_uring.c:7468 [inline]
 #0: ffff8880195b2470 (&sqd->lock){+.+.}-{3:3}, at: io_sq_thread_park fs/io_uring.c:7463 [inline]
 #0: ffff8880195b2470 (&sqd->lock){+.+.}-{3:3}, at: io_uring_cancel_task_requests+0x311/0x11a0 fs/io_uring.c:8973
1 lock held by syz-executor893/8624:
 #0: ffff8880161a4870 (&sqd->lock){+.+.}-{3:3}, at: io_sq_thread_park fs/io_uring.c:7468 [inline]
 #0: ffff8880161a4870 (&sqd->lock){+.+.}-{3:3}, at: io_sq_thread_park fs/io_uring.c:7463 [inline]
 #0: ffff8880161a4870 (&sqd->lock){+.+.}-{3:3}, at: io_uring_cancel_task_requests+0x311/0x11a0 fs/io_uring.c:8973
1 lock held by syz-executor893/8633:
 #0: ffff888025448c70 (&sqd->lock){+.+.}-{3:3}, at: io_sq_thread_park fs/io_uring.c:7468 [inline]
 #0: ffff888025448c70 (&sqd->lock){+.+.}-{3:3}, at: io_sq_thread_park fs/io_uring.c:7463 [inline]
 #0: ffff888025448c70 (&sqd->lock){+.+.}-{3:3}, at: io_uring_cancel_task_requests+0x311/0x11a0 fs/io_uring.c:8973

=============================================

NMI backtrace for cpu 0
CPU: 0 PID: 1638 Comm: khungtaskd Not tainted 5.11.0-rc6-syzkaller #0
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
Sending NMI from CPU 0 to CPUs 1:
NMI backtrace for cpu 1
CPU: 1 PID: 4885 Comm: systemd-journal Not tainted 5.11.0-rc6-syzkaller #0
Hardware name: Google Google Compute Engine/Google Compute Engine, BIOS Google 01/01/2011
RIP: 0010:latch_tree_find include/linux/rbtree_latch.h:209 [inline]
RIP: 0010:bpf_ksym_find+0x6a/0x1c0 kernel/bpf/core.c:667
Code: 68 ff ff ff 48 89 ef 4c 89 fe e8 41 66 f4 ff 4c 39 fd 0f 83 e9 00 00 00 e8 c3 5e f4 ff 8b 1d ad 7e 22 0a 44 8b 74 24 04 89 de <44> 89 f7 e8 ae 65 f4 ff 41 39 de 0f 84 e3 00 00 00 e8 a0 5e f4 ff
RSP: 0018:ffffc90001207aa0 EFLAGS: 00000093
RAX: 0000000000000000 RBX: 0000000000000000 RCX: 0000000000000000
RDX: ffff888015d6a200 RSI: 0000000000000000 RDI: ffffffff8ba0f3b0
RBP: 00007fb450c54840 R08: 0000000000000000 R09: 0000000000000001
R10: ffffffff817ec8c7 R11: 0000000000000000 R12: 0000000000000000
R13: dffffc0000000000 R14: 0000000000000000 R15: 0000000000000200
FS:  00007fb4516c58c0(0000) GS:ffff8880b9d00000(0000) knlGS:0000000000000000
CS:  0010 DS: 0000 ES: 0000 CR0: 0000000080050033
CR2: 00007fb44eab7000 CR3: 0000000015593000 CR4: 00000000001506e0
DR0: 0000000000000000 DR1: 0000000000000000 DR2: 0000000000000000
DR3: 0000000000000000 DR6: 00000000fffe0ff0 DR7: 0000000000000400
Call Trace:
 is_bpf_text_address+0x75/0x160 kernel/bpf/core.c:701
 kernel_text_address kernel/extable.c:151 [inline]
 kernel_text_address+0xbd/0xf0 kernel/extable.c:120
 __kernel_text_address+0x9/0x30 kernel/extable.c:105
 unwind_get_return_address arch/x86/kernel/unwind_orc.c:318 [inline]
 unwind_get_return_address+0x51/0x90 arch/x86/kernel/unwind_orc.c:313
 arch_stack_walk+0x93/0xe0 arch/x86/kernel/stacktrace.c:26
 stack_trace_save+0x8c/0xc0 kernel/stacktrace.c:121
 kasan_save_stack+0x1b/0x40 mm/kasan/common.c:38
 kasan_record_aux_stack+0x87/0xb0 mm/kasan/generic.c:344
 __call_rcu kernel/rcu/tree.c:2965 [inline]
 call_rcu+0xbb/0x700 kernel/rcu/tree.c:3038
 task_work_run+0xdd/0x190 kernel/task_work.c:140
 tracehook_notify_resume include/linux/tracehook.h:189 [inline]
 exit_to_user_mode_loop kernel/entry/common.c:174 [inline]
 exit_to_user_mode_prepare+0x249/0x250 kernel/entry/common.c:201
 __syscall_exit_to_user_mode_work kernel/entry/common.c:291 [inline]
 syscall_exit_to_user_mode+0x19/0x50 kernel/entry/common.c:302
 entry_SYSCALL_64_after_hwframe+0x44/0xa9
RIP: 0033:0x7fb450c54840
Code: 73 01 c3 48 8b 0d 68 77 20 00 f7 d8 64 89 01 48 83 c8 ff c3 66 0f 1f 44 00 00 83 3d 89 bb 20 00 00 75 10 b8 02 00 00 00 0f 05 <48> 3d 01 f0 ff ff 73 31 c3 48 83 ec 08 e8 1e f6 ff ff 48 89 04 24
RSP: 002b:00007ffd66c13138 EFLAGS: 00000246 ORIG_RAX: 0000000000000002
RAX: fffffffffffffffe RBX: 00007ffd66c13440 RCX: 00007fb450c54840
RDX: 00000000000001a0 RSI: 0000000000080042 RDI: 000055b07430c150
RBP: 000000000000000d R08: 000000000000ffc0 R09: 00000000ffffffff
R10: 0000000000000069 R11: 0000000000000246 R12: 00000000ffffffff
R13: 000055b0742fe060 R14: 00007ffd66c13400 R15: 000055b07430c1a0


---
This report is generated by a bot. It may contain errors.
See https://goo.gl/tpsmEJ for more information about syzbot.
syzbot engineers can be reached at syzkaller@googlegroups.com.

syzbot will keep track of this issue. See:
https://goo.gl/tpsmEJ#status for how to communicate with syzbot.
syzbot can test patches for this issue, for details see:
https://goo.gl/tpsmEJ#testing-patches
