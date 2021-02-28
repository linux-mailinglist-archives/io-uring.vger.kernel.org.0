Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 62C683274B4
	for <lists+io-uring@lfdr.de>; Sun, 28 Feb 2021 22:58:59 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231438AbhB1V66 (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Sun, 28 Feb 2021 16:58:58 -0500
Received: from mail-io1-f70.google.com ([209.85.166.70]:48634 "EHLO
        mail-io1-f70.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231398AbhB1V65 (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Sun, 28 Feb 2021 16:58:57 -0500
Received: by mail-io1-f70.google.com with SMTP id c4so11792503ioq.15
        for <io-uring@vger.kernel.org>; Sun, 28 Feb 2021 13:58:41 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:date:message-id:subject:from:to;
        bh=chNxsZ4Js326lT8cHMoI26IH9ZNijvX0dsRJKNoScmE=;
        b=D7h4xmm7UXvy/FXN0GkOcsCFtT6j+9HOzi31wX39F45I4Gax5JH0+yda8rWZOyn88u
         HWFDeJRjKF7/nR4utNBL1vaUP78qmNWoZvZRiOQjafsvMNxSYivC5Swj14wAP3rMEVHF
         7kWf9WLN+LUBrf2PyAG0k7zNw/MPQaJ5cXFSsXbApFVHuWdMWg+liFBLm0+qPtDDfkIm
         YiW+p56TSijojw0bfOkoJ615acXPEiM2WhZBCdCKMf2UyRGq924duYtbJy8lshOV/dGZ
         8DD8jQXaLhXA3G/rH95itW9wAlYHfDy9gXyRl7O8X5TtAMbvVBZsXXPUUDHL8v6oChR1
         ETQA==
X-Gm-Message-State: AOAM531qE8tOyB8D3GEbiXqGAtGGg88xQyTaJ6GMAla5PsHVoZs86ES4
        5npCn/8+rVqUYd+SIPlpXbpEGeUPnRgBeQZ+Pl+plvvCDXOZ
X-Google-Smtp-Source: ABdhPJwUSb2eX0Igzr01c0hNN4Vh2hOhfhqe0TJptNifsvB1yLEHRlSnSfKd/Ww+ofTi5r3rMyb0JQt8I0kAqVa+l2akXagZ2Xqj
MIME-Version: 1.0
X-Received: by 2002:a6b:b415:: with SMTP id d21mr11171871iof.149.1614549496096;
 Sun, 28 Feb 2021 13:58:16 -0800 (PST)
Date:   Sun, 28 Feb 2021 13:58:16 -0800
X-Google-Appengine-App-Id: s~syzkaller
X-Google-Appengine-App-Id-Alias: syzkaller
Message-ID: <0000000000002feb3505bc6c99ee@google.com>
Subject: INFO: task hung in io_sq_thread_park
From:   syzbot <syzbot+fb5458330b4442f2090d@syzkaller.appspotmail.com>
To:     asml.silence@gmail.com, axboe@kernel.dk, io-uring@vger.kernel.org,
        linux-kernel@vger.kernel.org, syzkaller-bugs@googlegroups.com
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org

Hello,

syzbot found the following issue on:

HEAD commit:    d01f2f7e Add linux-next specific files for 20210226
git tree:       linux-next
console output: https://syzkaller.appspot.com/x/log.txt?x=1265dcead00000
kernel config:  https://syzkaller.appspot.com/x/.config?x=a1746d2802a82a05
dashboard link: https://syzkaller.appspot.com/bug?extid=fb5458330b4442f2090d
syz repro:      https://syzkaller.appspot.com/x/repro.syz?x=175427f2d00000
C reproducer:   https://syzkaller.appspot.com/x/repro.c?x=11109782d00000

IMPORTANT: if you fix the issue, please add the following tag to the commit:
Reported-by: syzbot+fb5458330b4442f2090d@syzkaller.appspotmail.com

INFO: task syz-executor458:8401 blocked for more than 143 seconds.
      Not tainted 5.11.0-next-20210226-syzkaller #0
"echo 0 > /proc/sys/kernel/hung_task_timeout_secs" disables this message.
task:syz-executor458 state:D stack:27536 pid: 8401 ppid:  8400 flags:0x00004004
Call Trace:
 context_switch kernel/sched/core.c:4324 [inline]
 __schedule+0x90c/0x21a0 kernel/sched/core.c:5075
 schedule+0xcf/0x270 kernel/sched/core.c:5154
 schedule_timeout+0x1db/0x250 kernel/time/timer.c:1868
 do_wait_for_common kernel/sched/completion.c:85 [inline]
 __wait_for_common kernel/sched/completion.c:106 [inline]
 wait_for_common kernel/sched/completion.c:117 [inline]
 wait_for_completion+0x168/0x270 kernel/sched/completion.c:138
 io_sq_thread_park fs/io_uring.c:7115 [inline]
 io_sq_thread_park+0xd5/0x130 fs/io_uring.c:7103
 io_uring_cancel_task_requests+0x24c/0xd90 fs/io_uring.c:8745
 __io_uring_files_cancel+0x110/0x230 fs/io_uring.c:8840
 io_uring_files_cancel include/linux/io_uring.h:47 [inline]
 do_exit+0x299/0x2a60 kernel/exit.c:780
 do_group_exit+0x125/0x310 kernel/exit.c:922
 __do_sys_exit_group kernel/exit.c:933 [inline]
 __se_sys_exit_group kernel/exit.c:931 [inline]
 __x64_sys_exit_group+0x3a/0x50 kernel/exit.c:931
 do_syscall_64+0x2d/0x70 arch/x86/entry/common.c:46
 entry_SYSCALL_64_after_hwframe+0x44/0xae
RIP: 0033:0x43e899
RSP: 002b:00007ffe89376d48 EFLAGS: 00000246 ORIG_RAX: 00000000000000e7
RAX: ffffffffffffffda RBX: 00000000004af2f0 RCX: 000000000043e899
RDX: 000000000000003c RSI: 00000000000000e7 RDI: 0000000000000000
RBP: 0000000000000000 R08: ffffffffffffffc0 R09: 0000000010000000
R10: 0000000000008011 R11: 0000000000000246 R12: 00000000004af2f0
R13: 0000000000000001 R14: 0000000000000000 R15: 0000000000000001
INFO: task iou-sqp-8401:8402 can't die for more than 143 seconds.
task:iou-sqp-8401    state:D stack:30272 pid: 8402 ppid:  8400 flags:0x00004004
Call Trace:
 context_switch kernel/sched/core.c:4324 [inline]
 __schedule+0x90c/0x21a0 kernel/sched/core.c:5075
 schedule+0xcf/0x270 kernel/sched/core.c:5154
 schedule_timeout+0x1db/0x250 kernel/time/timer.c:1868
 do_wait_for_common kernel/sched/completion.c:85 [inline]
 __wait_for_common kernel/sched/completion.c:106 [inline]
 wait_for_common kernel/sched/completion.c:117 [inline]
 wait_for_completion+0x168/0x270 kernel/sched/completion.c:138
 io_sq_thread+0x27d/0x1ae0 fs/io_uring.c:6717
 ret_from_fork+0x1f/0x30 arch/x86/entry/entry_64.S:294
INFO: task iou-sqp-8401:8402 blocked for more than 143 seconds.
      Not tainted 5.11.0-next-20210226-syzkaller #0
"echo 0 > /proc/sys/kernel/hung_task_timeout_secs" disables this message.
task:iou-sqp-8401    state:D stack:30272 pid: 8402 ppid:  8400 flags:0x00004004
Call Trace:
 context_switch kernel/sched/core.c:4324 [inline]
 __schedule+0x90c/0x21a0 kernel/sched/core.c:5075
 schedule+0xcf/0x270 kernel/sched/core.c:5154
 schedule_timeout+0x1db/0x250 kernel/time/timer.c:1868
 do_wait_for_common kernel/sched/completion.c:85 [inline]
 __wait_for_common kernel/sched/completion.c:106 [inline]
 wait_for_common kernel/sched/completion.c:117 [inline]
 wait_for_completion+0x168/0x270 kernel/sched/completion.c:138
 io_sq_thread+0x27d/0x1ae0 fs/io_uring.c:6717
 ret_from_fork+0x1f/0x30 arch/x86/entry/entry_64.S:294

Showing all locks held in the system:
1 lock held by khungtaskd/1666:
 #0: ffffffff8bf741e0 (rcu_read_lock){....}-{1:2}, at: debug_show_all_locks+0x53/0x260 kernel/locking/lockdep.c:6327
1 lock held by syz-executor458/8401:
 #0: ffff88801cafe870 (&sqd->lock){+.+.}-{3:3}, at: io_sq_thread_park+0x5d/0x130 fs/io_uring.c:7108

=============================================

NMI backtrace for cpu 0
CPU: 0 PID: 1666 Comm: khungtaskd Not tainted 5.11.0-next-20210226-syzkaller #0
Hardware name: Google Google Compute Engine/Google Compute Engine, BIOS Google 01/01/2011
Call Trace:
 __dump_stack lib/dump_stack.c:79 [inline]
 dump_stack+0xfa/0x151 lib/dump_stack.c:120
 nmi_cpu_backtrace.cold+0x44/0xd7 lib/nmi_backtrace.c:105
 nmi_trigger_cpumask_backtrace+0x1b3/0x230 lib/nmi_backtrace.c:62
 trigger_all_cpu_backtrace include/linux/nmi.h:147 [inline]
 check_hung_uninterruptible_tasks kernel/hung_task.c:253 [inline]
 watchdog+0xd8e/0xf40 kernel/hung_task.c:338
 kthread+0x3b1/0x4a0 kernel/kthread.c:292
 ret_from_fork+0x1f/0x30 arch/x86/entry/entry_64.S:294
Sending NMI from CPU 0 to CPUs 1:
NMI backtrace for cpu 1 skipped: idling at native_safe_halt arch/x86/include/asm/irqflags.h:51 [inline]
NMI backtrace for cpu 1 skipped: idling at arch_safe_halt arch/x86/include/asm/irqflags.h:89 [inline]
NMI backtrace for cpu 1 skipped: idling at acpi_safe_halt drivers/acpi/processor_idle.c:110 [inline]
NMI backtrace for cpu 1 skipped: idling at acpi_idle_do_entry+0x1c9/0x250 drivers/acpi/processor_idle.c:516


---
This report is generated by a bot. It may contain errors.
See https://goo.gl/tpsmEJ for more information about syzbot.
syzbot engineers can be reached at syzkaller@googlegroups.com.

syzbot will keep track of this issue. See:
https://goo.gl/tpsmEJ#status for how to communicate with syzbot.
syzbot can test patches for this issue, for details see:
https://goo.gl/tpsmEJ#testing-patches
