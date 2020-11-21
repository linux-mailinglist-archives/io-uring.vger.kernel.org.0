Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 4498D2BC26F
	for <lists+io-uring@lfdr.de>; Sat, 21 Nov 2020 23:35:41 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728559AbgKUWfT (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Sat, 21 Nov 2020 17:35:19 -0500
Received: from mail-io1-f69.google.com ([209.85.166.69]:39116 "EHLO
        mail-io1-f69.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1728584AbgKUWfR (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Sat, 21 Nov 2020 17:35:17 -0500
Received: by mail-io1-f69.google.com with SMTP id q187so10336174iod.6
        for <io-uring@vger.kernel.org>; Sat, 21 Nov 2020 14:35:15 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:date:message-id:subject:from:to;
        bh=tsEgpTQpUkS5dqX5+E3eCw03/yxK+M4z1miPp2iN8Sc=;
        b=dfYDKZ+81CPMrYY4wo+SBDQr24wTVxS1VedBiFONpYE5S/Y/5iH484/cYrjfRN3krW
         +TROgYKekXtf6udOu6gbf2Uj8kPzVomEFcwR98xoHJi+iZO1KWA+ANpUz+CKVMYLbN8F
         oEL437oNvQXaNfi8FNx2kQG2tENC0M2fGCeHb7luJytTT89sOWfGj85dZRpt1LTdtE+E
         cmzuqI+conw8tmuYeBzNnTqJGLtqOaxUseD6GyvDt7YQotm0zEWrrqzILG9OGKdTkQ71
         ZP/GMqG64JXuCoXZO3vRI5cijsxaw4ZbYKyPY0wZQh72NnyPmFcRUAYqEiBWbDjj2/Kb
         ZahQ==
X-Gm-Message-State: AOAM532Q8SF9D/mrOgOPyhUw9gjWL/fsBItYrKmQmjD1wt79WiZJXtcz
        r8e6naBrbnWUxltaCcKsjVpQpKE1EbBfrSuGSnHGkEgfYxCA
X-Google-Smtp-Source: ABdhPJzfYW2jjR9C0So+1b6+oMyUJpJM47Kswdc9TPIm14zKNKqyaZT+sGuJBTOPygKB5nmtq8PWLV4fCshXb8RtfU4IcoGudCWO
MIME-Version: 1.0
X-Received: by 2002:a92:ba14:: with SMTP id o20mr30980442ili.76.1605998115283;
 Sat, 21 Nov 2020 14:35:15 -0800 (PST)
Date:   Sat, 21 Nov 2020 14:35:15 -0800
X-Google-Appengine-App-Id: s~syzkaller
X-Google-Appengine-App-Id-Alias: syzkaller
Message-ID: <0000000000002bea4605b4a5931d@google.com>
Subject: INFO: task hung in __io_uring_files_cancel
From:   syzbot <syzbot+c0d52d0b3c0c3ffb9525@syzkaller.appspotmail.com>
To:     axboe@kernel.dk, io-uring@vger.kernel.org,
        linux-fsdevel@vger.kernel.org, linux-kernel@vger.kernel.org,
        mingo@kernel.org, mingo@redhat.com, peterz@infradead.org,
        rostedt@goodmis.org, syzkaller-bugs@googlegroups.com,
        viro@zeniv.linux.org.uk, will@kernel.org
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org

Hello,

syzbot found the following issue on:

HEAD commit:    7c8ca812 Add linux-next specific files for 20201117
git tree:       linux-next
console output: https://syzkaller.appspot.com/x/log.txt?x=12d2d191500000
kernel config:  https://syzkaller.appspot.com/x/.config?x=ff4bc71371dc5b13
dashboard link: https://syzkaller.appspot.com/bug?extid=c0d52d0b3c0c3ffb9525
compiler:       gcc (GCC) 10.1.0-syz 20200507
syz repro:      https://syzkaller.appspot.com/x/repro.syz?x=1481166a500000

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

INFO: task syz-executor.0:9557 blocked for more than 143 seconds.
      Not tainted 5.10.0-rc4-next-20201117-syzkaller #0
"echo 0 > /proc/sys/kernel/hung_task_timeout_secs" disables this message.
task:syz-executor.0  state:D stack:28584 pid: 9557 ppid:  8485 flags:0x00004002
Call Trace:
 context_switch kernel/sched/core.c:4269 [inline]
 __schedule+0x890/0x2030 kernel/sched/core.c:5019
 schedule+0xcf/0x270 kernel/sched/core.c:5098
 io_uring_cancel_files fs/io_uring.c:8720 [inline]
 io_uring_cancel_task_requests fs/io_uring.c:8772 [inline]
 __io_uring_files_cancel+0xc4d/0x14b0 fs/io_uring.c:8868
 io_uring_files_cancel include/linux/io_uring.h:51 [inline]
 exit_files+0xe4/0x170 fs/file.c:456
 do_exit+0xb61/0x29f0 kernel/exit.c:818
 do_group_exit+0x125/0x310 kernel/exit.c:920
 get_signal+0x3ea/0x1f70 kernel/signal.c:2750
 arch_do_signal_or_restart+0x2a6/0x1ea0 arch/x86/kernel/signal.c:811
 handle_signal_work kernel/entry/common.c:145 [inline]
 exit_to_user_mode_loop kernel/entry/common.c:169 [inline]
 exit_to_user_mode_prepare+0x124/0x200 kernel/entry/common.c:199
 syscall_exit_to_user_mode+0x38/0x260 kernel/entry/common.c:274
 entry_SYSCALL_64_after_hwframe+0x44/0xa9
RIP: 0033:0x45deb9
Code: Unable to access opcode bytes at RIP 0x45de8f.
RSP: 002b:00007fa68397ccf8 EFLAGS: 00000246 ORIG_RAX: 00000000000000ca
RAX: fffffffffffffe00 RBX: 000000000118bf28 RCX: 000000000045deb9
RDX: 0000000000000000 RSI: 0000000000000080 RDI: 000000000118bf28
RBP: 000000000118bf20 R08: 0000000000000000 R09: 0000000000000000
R10: 0000000000000000 R11: 0000000000000246 R12: 000000000118bf2c
R13: 00007fff50acc9af R14: 00007fa68397d9c0 R15: 000000000118bf2c

Showing all locks held in the system:
1 lock held by khungtaskd/1654:
 #0: ffffffff8b339ca0 (rcu_read_lock){....}-{1:2}, at: debug_show_all_locks+0x53/0x260 kernel/locking/lockdep.c:6252
1 lock held by in:imklog/8177:
 #0: ffff88801cf22d70 (&f->f_pos_lock){+.+.}-{3:3}, at: __fdget_pos+0xe9/0x100 fs/file.c:932

=============================================

NMI backtrace for cpu 1
CPU: 1 PID: 1654 Comm: khungtaskd Not tainted 5.10.0-rc4-next-20201117-syzkaller #0
Hardware name: Google Google Compute Engine/Google Compute Engine, BIOS Google 01/01/2011
Call Trace:
 __dump_stack lib/dump_stack.c:79 [inline]
 dump_stack+0x107/0x163 lib/dump_stack.c:120
 nmi_cpu_backtrace.cold+0x44/0xd7 lib/nmi_backtrace.c:105
 nmi_trigger_cpumask_backtrace+0x1b3/0x230 lib/nmi_backtrace.c:62
 trigger_all_cpu_backtrace include/linux/nmi.h:147 [inline]
 check_hung_uninterruptible_tasks kernel/hung_task.c:253 [inline]
 watchdog+0xd89/0xf30 kernel/hung_task.c:338
 kthread+0x3af/0x4a0 kernel/kthread.c:292
 ret_from_fork+0x1f/0x30 arch/x86/entry/entry_64.S:296
Sending NMI from CPU 1 to CPUs 0:
NMI backtrace for cpu 0
CPU: 0 PID: 4887 Comm: systemd-journal Not tainted 5.10.0-rc4-next-20201117-syzkaller #0
Hardware name: Google Google Compute Engine/Google Compute Engine, BIOS Google 01/01/2011
RIP: 0010:__sanitizer_cov_trace_const_cmp4+0x4/0x20 kernel/kcov.c:284
Code: 84 00 00 00 00 00 48 8b 0c 24 0f b7 d6 0f b7 f7 bf 03 00 00 00 e9 cc fe ff ff 66 90 66 2e 0f 1f 84 00 00 00 00 00 48 8b 0c 24 <89> f2 89 fe bf 05 00 00 00 e9 ae fe ff ff 0f 1f 40 00 66 2e 0f 1f
RSP: 0018:ffffc90000f0fe90 EFLAGS: 00000206
RAX: 0000000000000000 RBX: 0000000000080042 RCX: ffffffff81bd2a21
RDX: ffff88802594b500 RSI: 0000000000000040 RDI: 0000000000000000
RBP: 1ffff920001e1fd3 R08: 0000000000000000 R09: ffff8880110f3c17
R10: 0000000000000000 R11: 0000000000000000 R12: 0000000000000040
R13: 00000000000001a0 R14: 00005616bdf3c270 R15: 0000000000000000
FS:  00007f934ff098c0(0000) GS:ffff8880b9e00000(0000) knlGS:0000000000000000
CS:  0010 DS: 0000 ES: 0000 CR0: 0000000080050033
CR2: 0000000000a47b58 CR3: 0000000026162000 CR4: 00000000001506f0
DR0: 0000000000000000 DR1: 0000000000000000 DR2: 0000000000000000
DR3: 0000000000000000 DR6: 00000000fffe0ff0 DR7: 0000000000000400
Call Trace:
 build_open_how fs/open.c:989 [inline]
 do_sys_open fs/open.c:1183 [inline]
 __do_sys_open fs/open.c:1192 [inline]
 __se_sys_open fs/open.c:1188 [inline]
 __x64_sys_open+0x171/0x1c0 fs/open.c:1188
 do_syscall_64+0x2d/0x70 arch/x86/entry/common.c:46
 entry_SYSCALL_64_after_hwframe+0x44/0xa9
RIP: 0033:0x7f934f499840
Code: 73 01 c3 48 8b 0d 68 77 20 00 f7 d8 64 89 01 48 83 c8 ff c3 66 0f 1f 44 00 00 83 3d 89 bb 20 00 00 75 10 b8 02 00 00 00 0f 05 <48> 3d 01 f0 ff ff 73 31 c3 48 83 ec 08 e8 1e f6 ff ff 48 89 04 24
RSP: 002b:00007ffc6cf30568 EFLAGS: 00000246 ORIG_RAX: 0000000000000002
RAX: ffffffffffffffda RBX: 00007ffc6cf30870 RCX: 00007f934f499840
RDX: 00000000000001a0 RSI: 0000000000080042 RDI: 00005616bdf3c270
RBP: 000000000000000d R08: 0000000000000000 R09: 00000000ffffffff
R10: 0000000000000069 R11: 0000000000000246 R12: 00000000ffffffff
R13: 00005616bdf30040 R14: 00007ffc6cf30830 R15: 00005616bdf3cef0


---
This report is generated by a bot. It may contain errors.
See https://goo.gl/tpsmEJ for more information about syzbot.
syzbot engineers can be reached at syzkaller@googlegroups.com.

syzbot will keep track of this issue. See:
https://goo.gl/tpsmEJ#status for how to communicate with syzbot.
For information about bisection process see: https://goo.gl/tpsmEJ#bisection
syzbot can test patches for this issue, for details see:
https://goo.gl/tpsmEJ#testing-patches
