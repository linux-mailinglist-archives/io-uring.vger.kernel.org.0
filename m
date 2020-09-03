Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id F009425C6C6
	for <lists+io-uring@lfdr.de>; Thu,  3 Sep 2020 18:28:32 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728145AbgICQ2V (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Thu, 3 Sep 2020 12:28:21 -0400
Received: from mail-il1-f200.google.com ([209.85.166.200]:48277 "EHLO
        mail-il1-f200.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1728036AbgICQ2R (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Thu, 3 Sep 2020 12:28:17 -0400
Received: by mail-il1-f200.google.com with SMTP id p78so2721847ill.15
        for <io-uring@vger.kernel.org>; Thu, 03 Sep 2020 09:28:16 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:date:message-id:subject:from:to;
        bh=qnNATF4LHgG/gf1TCC38jnAlfww7rCmyIxY6DH8mpkA=;
        b=N8bjUH2VIrd048Ue4/k6KsQddFr1hs/LI9KSjURM+sY9QY12A0FnotMudzaBiYhPOk
         8cwQrTKrijxsa4+cJqHbnD9IFMZPKjQU+YLIC4v+72vvnpoO14BX+kXOrRckha5OhHHY
         LznK6umdR2gocoZiPhlZJcqPkEKBwgx0O0ACYDfe2GK4Np8i7fwIVmFIzIKZtOxb5tPI
         h/9fNrnTa3AYgjJDBGAIHoG4w4RfXj/Q3V/sgpaVsmO6exzvG5M4+fqs8WFvxjqVeHAY
         ncxZkPmuDFcXRC5dSbd9AbdspbCDjGSgcYS7uA23A6PiENkLFHo1JmoPO6FvM1YiauFs
         KMmA==
X-Gm-Message-State: AOAM533kRQv9nc4yyfXCvQnGEefbVlVnIZyrMj/RfPEFJeWiP0hBufbB
        6wExx5akLHNS7rgi9/VKBoawM0hwUt4BenNEKLZMFJ4euEws
X-Google-Smtp-Source: ABdhPJzJWH9lXzw+GWptLRJ2zGNcjK0jXbnbp9dcP4Bbf55r6Zb9hcz3V4o6hXY/BPRVN/quKlnSoVAOgXfl1tyLQgxYEPdHRcDK
MIME-Version: 1.0
X-Received: by 2002:a5e:9916:: with SMTP id t22mr3682861ioj.163.1599150495729;
 Thu, 03 Sep 2020 09:28:15 -0700 (PDT)
Date:   Thu, 03 Sep 2020 09:28:15 -0700
X-Google-Appengine-App-Id: s~syzkaller
X-Google-Appengine-App-Id-Alias: syzkaller
Message-ID: <0000000000003d90ba05ae6b3d5f@google.com>
Subject: INFO: task can't die in io_uring_setup
From:   syzbot <syzbot+3227d097b95b4207b570@syzkaller.appspotmail.com>
To:     axboe@kernel.dk, io-uring@vger.kernel.org, keescook@chromium.org,
        linux-fsdevel@vger.kernel.org, linux-kernel@vger.kernel.org,
        sgarzare@redhat.com, syzkaller-bugs@googlegroups.com,
        viro@zeniv.linux.org.uk
Content-Type: text/plain; charset="UTF-8"
Sender: io-uring-owner@vger.kernel.org
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org

Hello,

syzbot found the following issue on:

HEAD commit:    4442749a Add linux-next specific files for 20200902
git tree:       linux-next
console output: https://syzkaller.appspot.com/x/log.txt?x=138e7285900000
kernel config:  https://syzkaller.appspot.com/x/.config?x=39134fcec6c78e33
dashboard link: https://syzkaller.appspot.com/bug?extid=3227d097b95b4207b570
compiler:       gcc (GCC) 10.1.0-syz 20200507
syz repro:      https://syzkaller.appspot.com/x/repro.syz?x=15306279900000

The issue was bisected to:

commit dfe127799f8e663c7e3e48b5275ca538b278177b
Author: Stefano Garzarella <sgarzare@redhat.com>
Date:   Thu Aug 27 14:58:31 2020 +0000

    io_uring: allow disabling rings during the creation

bisection log:  https://syzkaller.appspot.com/x/bisect.txt?x=15b09115900000
final oops:     https://syzkaller.appspot.com/x/report.txt?x=17b09115900000
console output: https://syzkaller.appspot.com/x/log.txt?x=13b09115900000

IMPORTANT: if you fix the issue, please add the following tag to the commit:
Reported-by: syzbot+3227d097b95b4207b570@syzkaller.appspotmail.com
Fixes: dfe127799f8e ("io_uring: allow disabling rings during the creation")

INFO: task syz-executor.0:28543 can't die for more than 143 seconds.
task:syz-executor.0  state:D stack:28824 pid:28543 ppid:  6864 flags:0x00004004
Call Trace:
 context_switch kernel/sched/core.c:3777 [inline]
 __schedule+0xea9/0x2230 kernel/sched/core.c:4526
 schedule+0xd0/0x2a0 kernel/sched/core.c:4601
 schedule_timeout+0x1d8/0x250 kernel/time/timer.c:1855
 do_wait_for_common kernel/sched/completion.c:85 [inline]
 __wait_for_common kernel/sched/completion.c:106 [inline]
 wait_for_common kernel/sched/completion.c:117 [inline]
 wait_for_completion+0x163/0x260 kernel/sched/completion.c:138
 io_sq_thread_stop fs/io_uring.c:6906 [inline]
 io_finish_async fs/io_uring.c:6920 [inline]
 io_sq_offload_create fs/io_uring.c:7595 [inline]
 io_uring_create fs/io_uring.c:8671 [inline]
 io_uring_setup+0x1495/0x29a0 fs/io_uring.c:8744
 do_syscall_64+0x2d/0x70 arch/x86/entry/common.c:46
 entry_SYSCALL_64_after_hwframe+0x44/0xa9
RIP: 0033:0x45d5b9
Code: Bad RIP value.
RSP: 002b:00007fde24a51bf8 EFLAGS: 00000206 ORIG_RAX: 00000000000001a9
RAX: ffffffffffffffda RBX: 0000000020000240 RCX: 000000000045d5b9
RDX: 00000000206d5000 RSI: 0000000020000240 RDI: 0000000000007e71
RBP: 000000000118cf98 R08: 0000000020000100 R09: 0000000020000100
R10: 0000000000000000 R11: 0000000000000206 R12: 00000000206d5000
R13: 00000000206d4000 R14: 0000000020000100 R15: 0000000000000000
INFO: task syz-executor.0:28543 blocked for more than 143 seconds.
      Not tainted 5.9.0-rc3-next-20200902-syzkaller #0
"echo 0 > /proc/sys/kernel/hung_task_timeout_secs" disables this message.
task:syz-executor.0  state:D stack:28824 pid:28543 ppid:  6864 flags:0x00004004
Call Trace:
 context_switch kernel/sched/core.c:3777 [inline]
 __schedule+0xea9/0x2230 kernel/sched/core.c:4526
 schedule+0xd0/0x2a0 kernel/sched/core.c:4601
 schedule_timeout+0x1d8/0x250 kernel/time/timer.c:1855
 do_wait_for_common kernel/sched/completion.c:85 [inline]
 __wait_for_common kernel/sched/completion.c:106 [inline]
 wait_for_common kernel/sched/completion.c:117 [inline]
 wait_for_completion+0x163/0x260 kernel/sched/completion.c:138
 io_sq_thread_stop fs/io_uring.c:6906 [inline]
 io_finish_async fs/io_uring.c:6920 [inline]
 io_sq_offload_create fs/io_uring.c:7595 [inline]
 io_uring_create fs/io_uring.c:8671 [inline]
 io_uring_setup+0x1495/0x29a0 fs/io_uring.c:8744
 do_syscall_64+0x2d/0x70 arch/x86/entry/common.c:46
 entry_SYSCALL_64_after_hwframe+0x44/0xa9
RIP: 0033:0x45d5b9
Code: Bad RIP value.
RSP: 002b:00007fde24a51bf8 EFLAGS: 00000206 ORIG_RAX: 00000000000001a9
RAX: ffffffffffffffda RBX: 0000000020000240 RCX: 000000000045d5b9
RDX: 00000000206d5000 RSI: 0000000020000240 RDI: 0000000000007e71
RBP: 000000000118cf98 R08: 0000000020000100 R09: 0000000020000100
R10: 0000000000000000 R11: 0000000000000206 R12: 00000000206d5000
R13: 00000000206d4000 R14: 0000000020000100 R15: 0000000000000000
INFO: task io_uring-sq:28548 blocked for more than 143 seconds.
      Not tainted 5.9.0-rc3-next-20200902-syzkaller #0
"echo 0 > /proc/sys/kernel/hung_task_timeout_secs" disables this message.
task:io_uring-sq     state:D stack:31120 pid:28548 ppid:     2 flags:0x00004000
Call Trace:
 context_switch kernel/sched/core.c:3777 [inline]
 __schedule+0xea9/0x2230 kernel/sched/core.c:4526
 schedule+0xd0/0x2a0 kernel/sched/core.c:4601
 schedule_preempt_disabled+0xf/0x20 kernel/sched/core.c:4660
 kthread+0x2ac/0x4a0 kernel/kthread.c:285
 ret_from_fork+0x1f/0x30 arch/x86/entry/entry_64.S:294

Showing all locks held in the system:
1 lock held by khungtaskd/1174:
 #0: ffffffff89c67980 (rcu_read_lock){....}-{1:2}, at: debug_show_all_locks+0x53/0x260 kernel/locking/lockdep.c:5829

=============================================

NMI backtrace for cpu 1
CPU: 1 PID: 1174 Comm: khungtaskd Not tainted 5.9.0-rc3-next-20200902-syzkaller #0
Hardware name: Google Google Compute Engine/Google Compute Engine, BIOS Google 01/01/2011
Call Trace:
 __dump_stack lib/dump_stack.c:77 [inline]
 dump_stack+0x198/0x1fd lib/dump_stack.c:118
 nmi_cpu_backtrace.cold+0x44/0xd7 lib/nmi_backtrace.c:105
 nmi_trigger_cpumask_backtrace+0x1b3/0x223 lib/nmi_backtrace.c:62
 trigger_all_cpu_backtrace include/linux/nmi.h:147 [inline]
 check_hung_uninterruptible_tasks kernel/hung_task.c:253 [inline]
 watchdog+0xd89/0xf30 kernel/hung_task.c:339
 kthread+0x3b5/0x4a0 kernel/kthread.c:292
 ret_from_fork+0x1f/0x30 arch/x86/entry/entry_64.S:294
Sending NMI from CPU 1 to CPUs 0:
NMI backtrace for cpu 0
CPU: 0 PID: 3906 Comm: systemd-journal Not tainted 5.9.0-rc3-next-20200902-syzkaller #0
Hardware name: Google Google Compute Engine/Google Compute Engine, BIOS Google 01/01/2011
RIP: 0010:arch_static_branch arch/x86/include/asm/jump_label.h:25 [inline]
RIP: 0010:static_key_false include/linux/jump_label.h:200 [inline]
RIP: 0010:trace_irq_disable_rcuidle include/trace/events/preemptirq.h:36 [inline]
RIP: 0010:trace_hardirqs_off kernel/trace/trace_preemptirq.c:82 [inline]
RIP: 0010:trace_hardirqs_off+0x6c/0x210 kernel/trace/trace_preemptirq.c:74
Code: 81 e3 00 00 f0 00 31 ff 89 de e8 9f 37 fa ff 85 db 74 0d 5b 5d 41 5c 41 5d 41 5e e9 0e 3b fa ff e8 09 3b fa ff 4c 8b 6c 24 28 <0f> 1f 44 00 00 e8 fa 3a fa ff eb dd e8 f3 3a fa ff 65 8b 1d bc fe
RSP: 0018:ffffc90005357f00 EFLAGS: 00000093
RAX: 0000000000000000 RBX: 0000000000000000 RCX: ffffffff817a9471
RDX: ffff888092cbe500 RSI: ffffffff817a9487 RDI: 0000000000000005
RBP: ffffc90005357f58 R08: 0000000000000001 R09: ffff888092cbee08
R10: 0000000000000000 R11: 0000000000000000 R12: 0000000000000000
R13: ffffffff87f9c83e R14: 0000000000000000 R15: 0000000000000000
FS:  00007f7fd426b8c0(0000) GS:ffff8880ae600000(0000) knlGS:0000000000000000
CS:  0010 DS: 0000 ES: 0000 CR0: 0000000080050033
CR2: 00007f7fd161d000 CR3: 00000000933ac000 CR4: 00000000001506f0
DR0: 0000000000000000 DR1: 0000000000000000 DR2: 0000000000000000
DR3: 0000000000000000 DR6: 00000000fffe0ff0 DR7: 0000000000000400
Call Trace:
 local_irq_disable_exit_to_user include/linux/entry-common.h:166 [inline]
 syscall_exit_to_user_mode+0xae/0x2e0 kernel/entry/common.c:241
 entry_SYSCALL_64_after_hwframe+0x44/0xa9
RIP: 0033:0x7f7fd3504f17
Code: ff ff ff 48 8b 4d a0 0f b7 51 fe 48 8b 4d a8 66 89 54 08 fe e9 1a ff ff ff 66 2e 0f 1f 84 00 00 00 00 00 b8 27 00 00 00 0f 05 <c3> 0f 1f 84 00 00 00 00 00 b8 6e 00 00 00 0f 05 c3 0f 1f 84 00 00
RSP: 002b:00007ffc0a1045c8 EFLAGS: 00000206 ORIG_RAX: 0000000000000027
RAX: 0000000000000f42 RBX: 000055ca0d4b51e0 RCX: 00007f7fd3504f17
RDX: 00007ffc0a104688 RSI: 0000000000000001 RDI: 000055ca0d4b51e0
RBP: 0000000000000001 R08: 0000000000000000 R09: 0000000000000000
R10: 0000000000000069 R11: 0000000000000206 R12: 00007ffc0a104688
R13: 0000000000000f42 R14: 00007ffc0a107470 R15: 00007ffc0a104a80


---
This report is generated by a bot. It may contain errors.
See https://goo.gl/tpsmEJ for more information about syzbot.
syzbot engineers can be reached at syzkaller@googlegroups.com.

syzbot will keep track of this issue. See:
https://goo.gl/tpsmEJ#status for how to communicate with syzbot.
For information about bisection process see: https://goo.gl/tpsmEJ#bisection
syzbot can test patches for this issue, for details see:
https://goo.gl/tpsmEJ#testing-patches
