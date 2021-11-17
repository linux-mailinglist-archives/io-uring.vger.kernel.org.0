Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id A9C63454EE4
	for <lists+io-uring@lfdr.de>; Wed, 17 Nov 2021 22:03:39 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S240256AbhKQVGg (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Wed, 17 Nov 2021 16:06:36 -0500
Received: from mail-io1-f72.google.com ([209.85.166.72]:36505 "EHLO
        mail-io1-f72.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S240209AbhKQVGc (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Wed, 17 Nov 2021 16:06:32 -0500
Received: by mail-io1-f72.google.com with SMTP id w16-20020a5d8a10000000b005e241c13c7bso2282877iod.3
        for <io-uring@vger.kernel.org>; Wed, 17 Nov 2021 13:03:33 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:mime-version:date:message-id:subject:from:to;
        bh=OGp6KUtBMIM47aOKsKERcrrE6R12+QeT9a+JtvCK008=;
        b=M3x504wOyX2OfzEhQPuO83fncZmXUjzfqgpDC8U/ykUsv+gjc1iavl7FfclnYX558Y
         WfJxIkioDTHxHjRgNYMsUYakTdYWKo89pkq2oDV5lyEW7nE04ipW9U57zZo4Qr67V+C2
         A/lPnG+TgAa3ZJOVwSBBhosa2x8enntz6fW/YSOj91UwW0wSIL6hpyvVzYTjyx2CvnEO
         cvuYJ7+c/2fVMGKSAsIcDOTOm8+SWcc8FyzfD8prJv8mJZew723CFZEIZDybqLo9n5wH
         TAECG6feVZFQxU61wV4Ym5gj7B5bijIh3KPQaad0CzGlAuVxteUGfn4Y5JwRNxB6clnO
         jsRg==
X-Gm-Message-State: AOAM533X2KFxZS3BJtdgiurN2BAILbGRXtUPDby5cdmzsH7s4LmDIbOc
        1EBXYb2Ic5c7zmPADQZ/UW+lJs8vOX9Z7sCNO3L9e7NVgD0T
X-Google-Smtp-Source: ABdhPJwNdZe6+qo53JlVRrxhqJySuOTEqlqXFcCq44RtHvRPe0HMiRBWpEd8lLF1+jKzRkaP6P0dH7MwcM5Q+eeXEncTstYvikEP
MIME-Version: 1.0
X-Received: by 2002:a05:6e02:190f:: with SMTP id w15mr12753585ilu.197.1637183012212;
 Wed, 17 Nov 2021 13:03:32 -0800 (PST)
Date:   Wed, 17 Nov 2021 13:03:32 -0800
X-Google-Appengine-App-Id: s~syzkaller
X-Google-Appengine-App-Id-Alias: syzkaller
Message-ID: <000000000000e016c205d1025f4c@google.com>
Subject: [syzbot] INFO: task hung in io_uring_cancel_generic (2)
From:   syzbot <syzbot+21e6887c0be14181206d@syzkaller.appspotmail.com>
To:     asml.silence@gmail.com, axboe@kernel.dk, io-uring@vger.kernel.org,
        linux-kernel@vger.kernel.org, syzkaller-bugs@googlegroups.com
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org

Hello,

syzbot found the following issue on:

HEAD commit:    8ab774587903 Merge tag 'trace-v5.16-5' of git://git.kernel..
git tree:       upstream
console output: https://syzkaller.appspot.com/x/log.txt?x=12b2344eb00000
kernel config:  https://syzkaller.appspot.com/x/.config?x=6d3b8fd1977c1e73
dashboard link: https://syzkaller.appspot.com/bug?extid=21e6887c0be14181206d
compiler:       gcc (Debian 10.2.1-6) 10.2.1 20210110, GNU ld (GNU Binutils for Debian) 2.35.2

Unfortunately, I don't have any reproducer for this issue yet.

IMPORTANT: if you fix the issue, please add the following tag to the commit:
Reported-by: syzbot+21e6887c0be14181206d@syzkaller.appspotmail.com

INFO: task syz-executor.1:1474 blocked for more than 143 seconds.
      Not tainted 5.16.0-rc1-syzkaller #0
"echo 0 > /proc/sys/kernel/hung_task_timeout_secs" disables this message.
task:syz-executor.1  state:D stack:26328 pid: 1474 ppid:  6663 flags:0x00024004
Call Trace:
 <TASK>
 context_switch kernel/sched/core.c:4972 [inline]
 __schedule+0xa9a/0x4940 kernel/sched/core.c:6253
 schedule+0xd2/0x260 kernel/sched/core.c:6326
 io_uring_cancel_generic+0x53d/0x690 fs/io_uring.c:9846
 io_uring_files_cancel include/linux/io_uring.h:16 [inline]
 do_exit+0x60c/0x2b40 kernel/exit.c:787
 do_group_exit+0x125/0x310 kernel/exit.c:929
 get_signal+0x47d/0x2220 kernel/signal.c:2830
 arch_do_signal_or_restart+0x2a9/0x1c40 arch/x86/kernel/signal.c:868
 handle_signal_work kernel/entry/common.c:148 [inline]
 exit_to_user_mode_loop kernel/entry/common.c:172 [inline]
 exit_to_user_mode_prepare+0x17d/0x290 kernel/entry/common.c:207
 __syscall_exit_to_user_mode_work kernel/entry/common.c:289 [inline]
 syscall_exit_to_user_mode+0x19/0x60 kernel/entry/common.c:300
 do_syscall_64+0x42/0xb0 arch/x86/entry/common.c:86
 entry_SYSCALL_64_after_hwframe+0x44/0xae
RIP: 0033:0x7fd09b5fbae9
RSP: 002b:00007fd098b71218 EFLAGS: 00000246 ORIG_RAX: 00000000000000ca
RAX: fffffffffffffe00 RBX: 00007fd09b70ef68 RCX: 00007fd09b5fbae9
RDX: 0000000000000000 RSI: 0000000000000080 RDI: 00007fd09b70ef68
RBP: 00007fd09b70ef60 R08: 0000000000000000 R09: 0000000000000000
R10: 0000000000000000 R11: 0000000000000246 R12: 00007fd09b70ef6c
R13: 00007fd09bc42b2f R14: 00007fd098b71300 R15: 0000000000022000
 </TASK>

Showing all locks held in the system:
1 lock held by khungtaskd/27:
 #0: ffffffff8bb83a60 (rcu_read_lock){....}-{1:2}, at: debug_show_all_locks+0x53/0x260 kernel/locking/lockdep.c:6458
1 lock held by in:imklog/6233:
 #0: ffff8880208d7270 (&f->f_pos_lock){+.+.}-{3:3}, at: __fdget_pos+0xe9/0x100 fs/file.c:990
2 locks held by kworker/u4:7/9581:

=============================================

NMI backtrace for cpu 1
CPU: 1 PID: 27 Comm: khungtaskd Not tainted 5.16.0-rc1-syzkaller #0
Hardware name: Google Google Compute Engine/Google Compute Engine, BIOS Google 01/01/2011
Call Trace:
 <TASK>
 __dump_stack lib/dump_stack.c:88 [inline]
 dump_stack_lvl+0xcd/0x134 lib/dump_stack.c:106
 nmi_cpu_backtrace.cold+0x47/0x144 lib/nmi_backtrace.c:105
 nmi_trigger_cpumask_backtrace+0x1ae/0x220 lib/nmi_backtrace.c:62
 trigger_all_cpu_backtrace include/linux/nmi.h:146 [inline]
 check_hung_uninterruptible_tasks kernel/hung_task.c:210 [inline]
 watchdog+0xc1d/0xf50 kernel/hung_task.c:295
 kthread+0x405/0x4f0 kernel/kthread.c:327
 ret_from_fork+0x1f/0x30 arch/x86/entry/entry_64.S:295
 </TASK>
Sending NMI from CPU 1 to CPUs 0:
NMI backtrace for cpu 0
CPU: 0 PID: 2969 Comm: systemd-journal Not tainted 5.16.0-rc1-syzkaller #0
Hardware name: Google Google Compute Engine/Google Compute Engine, BIOS Google 01/01/2011
RIP: 0010:__lock_acquire+0x8fe/0x54a0 kernel/locking/lockdep.c:5000
Code: 03 38 d0 7c 08 84 d2 0f 85 d7 48 00 00 8b 0d a9 a5 ef 0e 85 c9 0f 84 05 07 00 00 49 8d 85 50 0a 00 00 48 89 c2 48 89 44 24 68 <48> b8 00 00 00 00 00 fc ff df 48 c1 ea 03 80 3c 02 00 0f 85 73 37
RSP: 0018:ffffc900020bfa38 EFLAGS: 00000047
RAX: ffff88807ad2c450 RBX: 0000000000000000 RCX: ffffffff815cab4a
RDX: ffff88807ad2c450 RSI: 0000000000000008 RDI: ffffffff8ff76a00
RBP: ffff88807ad2c482 R08: 0000000000000000 R09: ffffffff8ff76a07
R10: fffffbfff1feed40 R11: 0000000000000000 R12: ffff88807ad2c460
R13: ffff88807ad2ba00 R14: 0000000000000000 R15: 0000000000000002
FS:  00007f19aca9d8c0(0000) GS:ffff8880b9c00000(0000) knlGS:0000000000000000
CS:  0010 DS: 0000 ES: 0000 CR0: 0000000080050033
CR2: 00007f19a99a0028 CR3: 000000001cdbc000 CR4: 00000000003506f0
DR0: 0000000000000000 DR1: 0000000000000000 DR2: 0000000000000000
DR3: 0000000000000000 DR6: 00000000fffe0ff0 DR7: 0000000000000400
Call Trace:
 <TASK>
 lock_acquire kernel/locking/lockdep.c:5637 [inline]
 lock_acquire+0x1ab/0x510 kernel/locking/lockdep.c:5602
 __raw_spin_lock_irqsave include/linux/spinlock_api_smp.h:110 [inline]
 _raw_spin_lock_irqsave+0x39/0x50 kernel/locking/spinlock.c:162
 __debug_object_init+0xb1/0xd10 lib/debugobjects.c:569
 debug_object_init lib/debugobjects.c:620 [inline]
 debug_object_activate+0x32c/0x3e0 lib/debugobjects.c:706
 debug_rcu_head_queue kernel/rcu/rcu.h:176 [inline]
 __call_rcu kernel/rcu/tree.c:2969 [inline]
 call_rcu+0x2c/0x740 kernel/rcu/tree.c:3065
 task_work_run+0xdd/0x1a0 kernel/task_work.c:164
 tracehook_notify_resume include/linux/tracehook.h:189 [inline]
 exit_to_user_mode_loop kernel/entry/common.c:175 [inline]
 exit_to_user_mode_prepare+0x27e/0x290 kernel/entry/common.c:207
 __syscall_exit_to_user_mode_work kernel/entry/common.c:289 [inline]
 syscall_exit_to_user_mode+0x19/0x60 kernel/entry/common.c:300
 do_syscall_64+0x42/0xb0 arch/x86/entry/common.c:86
 entry_SYSCALL_64_after_hwframe+0x44/0xae
RIP: 0033:0x7f19ac02c840
Code: 73 01 c3 48 8b 0d 68 77 20 00 f7 d8 64 89 01 48 83 c8 ff c3 66 0f 1f 44 00 00 83 3d 89 bb 20 00 00 75 10 b8 02 00 00 00 0f 05 <48> 3d 01 f0 ff ff 73 31 c3 48 83 ec 08 e8 1e f6 ff ff 48 89 04 24
RSP: 002b:00007fffa9120ee8 EFLAGS: 00000246 ORIG_RAX: 0000000000000002
RAX: fffffffffffffffe RBX: 00007fffa91211f0 RCX: 00007f19ac02c840
RDX: 00000000000001a0 RSI: 0000000000080042 RDI: 00005590b7443010
RBP: 000000000000000d R08: 0000000000000000 R09: 00000000ffffffff
R10: 0000000000000069 R11: 0000000000000246 R12: 00000000ffffffff
R13: 00005590b7436040 R14: 00007fffa91211b0 R15: 00005590b7442e30
 </TASK>
----------------
Code disassembly (best guess):
   0:	03 38                	add    (%rax),%edi
   2:	d0 7c 08 84          	sarb   -0x7c(%rax,%rcx,1)
   6:	d2 0f                	rorb   %cl,(%rdi)
   8:	85 d7                	test   %edx,%edi
   a:	48 00 00             	rex.W add %al,(%rax)
   d:	8b 0d a9 a5 ef 0e    	mov    0xeefa5a9(%rip),%ecx        # 0xeefa5bc
  13:	85 c9                	test   %ecx,%ecx
  15:	0f 84 05 07 00 00    	je     0x720
  1b:	49 8d 85 50 0a 00 00 	lea    0xa50(%r13),%rax
  22:	48 89 c2             	mov    %rax,%rdx
  25:	48 89 44 24 68       	mov    %rax,0x68(%rsp)
* 2a:	48 b8 00 00 00 00 00 	movabs $0xdffffc0000000000,%rax <-- trapping instruction
  31:	fc ff df
  34:	48 c1 ea 03          	shr    $0x3,%rdx
  38:	80 3c 02 00          	cmpb   $0x0,(%rdx,%rax,1)
  3c:	0f                   	.byte 0xf
  3d:	85 73 37             	test   %esi,0x37(%rbx)


---
This report is generated by a bot. It may contain errors.
See https://goo.gl/tpsmEJ for more information about syzbot.
syzbot engineers can be reached at syzkaller@googlegroups.com.

syzbot will keep track of this issue. See:
https://goo.gl/tpsmEJ#status for how to communicate with syzbot.
