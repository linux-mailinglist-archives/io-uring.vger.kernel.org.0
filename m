Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 211AA465FFF
	for <lists+io-uring@lfdr.de>; Thu,  2 Dec 2021 09:52:46 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S241081AbhLBI4E (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Thu, 2 Dec 2021 03:56:04 -0500
Received: from mail-il1-f200.google.com ([209.85.166.200]:39924 "EHLO
        mail-il1-f200.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1356287AbhLBIzt (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Thu, 2 Dec 2021 03:55:49 -0500
Received: by mail-il1-f200.google.com with SMTP id d3-20020a056e021c4300b002a23bcd5ee7so22959197ilg.6
        for <io-uring@vger.kernel.org>; Thu, 02 Dec 2021 00:52:24 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:mime-version:date:message-id:subject:from:to;
        bh=h5GUjx7K4W3pjVm6GFnIxly30AOiLX+8f+fE40ITzv4=;
        b=gJOhQohsDQTpvuG1Ke0wRZhYU2jA1SeTGoh9489TDIar1W9Trp06g5oUXQzS5uPWBg
         oWt06zZ0WVltfXpIL9QLgj70dmt6m1WvzPh45qJxukPLmNFq+9C+b7UQzPsIbm0lCMiA
         Wx0CzZXfPAlYPqZMgrF1QmecMZaufFQGNtD99Ux83R+taN2iyU+dLG0PRXEWNQFxBPoK
         hdhtGQqSsEPTMiDy8ST/90J9OU6hK04fjLVPc2NfpuaxtYceuK1HZAfBXIKecIDYFWGL
         Kli5j241QO3iZnjD2F90fEiWxlZhhyiENbjNJ1tjV6Gr+0PZjvBKGCxOIXbtbW2lM0kI
         boog==
X-Gm-Message-State: AOAM531FrTkw8YXkqhUVuCAXnojh00mfNFjg+zXFa75XgRox+odXpb9l
        OOTSAVEyNN2IqkdvaZE+91NgSELKsUDkOHfZV0NjcnvbWBuB
X-Google-Smtp-Source: ABdhPJyhbMC5vR2O62dxIfhxllsHYJSAIDq+BoU+so5PyFFkQBen7t73GhzqItjXY9l1U0CG52ZNKA5QxaOF1OiD3mjha//xGtPv
MIME-Version: 1.0
X-Received: by 2002:a6b:b4cc:: with SMTP id d195mr14515035iof.0.1638435144315;
 Thu, 02 Dec 2021 00:52:24 -0800 (PST)
Date:   Thu, 02 Dec 2021 00:52:24 -0800
X-Google-Appengine-App-Id: s~syzkaller
X-Google-Appengine-App-Id-Alias: syzkaller
Message-ID: <000000000000c3bac405d225e8ba@google.com>
Subject: [syzbot] INFO: task hung in io_uring_register
From:   syzbot <syzbot+7daefdd84ee7b8170aa6@syzkaller.appspotmail.com>
To:     asml.silence@gmail.com, axboe@kernel.dk, io-uring@vger.kernel.org,
        linux-kernel@vger.kernel.org, syzkaller-bugs@googlegroups.com
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org

Hello,

syzbot found the following issue on:

HEAD commit:    58e1100fdc59 MAINTAINERS: co-maintain random.c
git tree:       upstream
console output: https://syzkaller.appspot.com/x/log.txt?x=1221a1adb00000
kernel config:  https://syzkaller.appspot.com/x/.config?x=5b0eee8ab3ea1839
dashboard link: https://syzkaller.appspot.com/bug?extid=7daefdd84ee7b8170aa6
compiler:       gcc (Debian 10.2.1-6) 10.2.1 20210110, GNU ld (GNU Binutils for Debian) 2.35.2

Unfortunately, I don't have any reproducer for this issue yet.

IMPORTANT: if you fix the issue, please add the following tag to the commit:
Reported-by: syzbot+7daefdd84ee7b8170aa6@syzkaller.appspotmail.com

INFO: task syz-executor.5:3737 blocked for more than 143 seconds.
      Not tainted 5.16.0-rc3-syzkaller #0
"echo 0 > /proc/sys/kernel/hung_task_timeout_secs" disables this message.
task:syz-executor.5  state:D stack:29592 pid: 3737 ppid:  7406 flags:0x00000004
Call Trace:
 <TASK>
 context_switch kernel/sched/core.c:4972 [inline]
 __schedule+0xa9a/0x4940 kernel/sched/core.c:6253
 schedule+0xd2/0x260 kernel/sched/core.c:6326
 schedule_preempt_disabled+0xf/0x20 kernel/sched/core.c:6385
 __mutex_lock_common kernel/locking/mutex.c:680 [inline]
 __mutex_lock+0xa32/0x12f0 kernel/locking/mutex.c:740
 __do_sys_io_uring_register+0x2e0/0x15a0 fs/io_uring.c:11087
 do_syscall_x64 arch/x86/entry/common.c:50 [inline]
 do_syscall_64+0x35/0xb0 arch/x86/entry/common.c:80
 entry_SYSCALL_64_after_hwframe+0x44/0xae
RIP: 0033:0x7f8f023f9ae9
RSP: 002b:00007f8eff94e188 EFLAGS: 00000246 ORIG_RAX: 00000000000001ab
RAX: ffffffffffffffda RBX: 00007f8f0250d020 RCX: 00007f8f023f9ae9
RDX: 0000000000000000 RSI: 0000000000000009 RDI: 0000000000000003
RBP: 00007f8f02453f6d R08: 0000000000000000 R09: 0000000000000000
R10: 0000000000000000 R11: 0000000000000246 R12: 0000000000000000
R13: 00007f8f02a40b2f R14: 00007f8eff94e300 R15: 0000000000022000
 </TASK>

Showing all locks held in the system:
1 lock held by khungtaskd/26:
 #0: ffffffff8bb83b60 (rcu_read_lock){....}-{1:2}, at: debug_show_all_locks+0x53/0x260 kernel/locking/lockdep.c:6458
4 locks held by kworker/1:1/35:
 #0: ffff8880b9c39a98 (&rq->__lock){-.-.}-{2:2}, at: raw_spin_rq_lock_nested kernel/sched/core.c:486 [inline]
 #0: ffff8880b9c39a98 (&rq->__lock){-.-.}-{2:2}, at: raw_spin_rq_lock_nested+0x8c/0x120 kernel/sched/core.c:471
 #1: ffff8880b9d279c8 (&per_cpu_ptr(group->pcpu, cpu)->seq){-.-.}-{0:0}, at: psi_task_switch+0x3a6/0x490 kernel/sched/psi.c:880
 #2: ffff8880b9d28298 (&base->lock){-.-.}-{2:2}, at: lock_timer_base+0x5a/0x1f0 kernel/time/timer.c:946
 #3: ffffffff9064b2c8 (&obj_hash[i].lock){-.-.}-{2:2}, at: debug_object_activate+0x12e/0x3e0 lib/debugobjects.c:661
1 lock held by in:imklog/6232:
 #0: ffff88807b8334f0 (&f->f_pos_lock){+.+.}-{3:3}, at: __fdget_pos+0xe9/0x100 fs/file.c:990
2 locks held by kworker/u4:11/22134:
1 lock held by syz-executor.5/3735:
1 lock held by syz-executor.5/3737:
 #0: ffff888073e690a8 (&ctx->uring_lock){+.+.}-{3:3}, at: __do_sys_io_uring_register+0x2e0/0x15a0 fs/io_uring.c:11087
1 lock held by syz-executor.5/3780:
 #0: ffff88807c96d0a8 (&ctx->uring_lock){+.+.}-{3:3}, at: io_uring_del_tctx_node+0x109/0x20a fs/io_uring.c:9777
1 lock held by syz-executor.5/3782:

=============================================

NMI backtrace for cpu 0
CPU: 0 PID: 26 Comm: khungtaskd Not tainted 5.16.0-rc3-syzkaller #0
Hardware name: Google Google Compute Engine/Google Compute Engine, BIOS Google 01/01/2011
Call Trace:
 <TASK>
 __dump_stack lib/dump_stack.c:88 [inline]
 dump_stack_lvl+0xcd/0x134 lib/dump_stack.c:106
 nmi_cpu_backtrace.cold+0x47/0x144 lib/nmi_backtrace.c:111
 nmi_trigger_cpumask_backtrace+0x1b3/0x230 lib/nmi_backtrace.c:62
 trigger_all_cpu_backtrace include/linux/nmi.h:146 [inline]
 check_hung_uninterruptible_tasks kernel/hung_task.c:210 [inline]
 watchdog+0xc1d/0xf50 kernel/hung_task.c:295
 kthread+0x405/0x4f0 kernel/kthread.c:327
 ret_from_fork+0x1f/0x30 arch/x86/entry/entry_64.S:295
 </TASK>
Sending NMI from CPU 0 to CPUs 1:
NMI backtrace for cpu 1
CPU: 1 PID: 6232 Comm: in:imklog Not tainted 5.16.0-rc3-syzkaller #0
Hardware name: Google Google Compute Engine/Google Compute Engine, BIOS Google 01/01/2011
RIP: 0010:__switch_to_asm+0x2a/0x40 arch/x86/entry/entry_64.S:259
Code: 55 53 41 54 41 55 41 56 41 57 48 89 a7 98 17 00 00 48 8b a6 98 17 00 00 48 8b 9e d0 05 00 00 65 48 89 1c 25 28 00 00 00 41 5f <41> 5e 41 5d 41 5c 5b 5d e9 19 97 28 00 66 0f 1f 84 00 00 00 00 00
RSP: 0018:ffffc90001adfa40 EFLAGS: 00000046
RAX: dffffc0000000000 RBX: 38aea85631ad7d00 RCX: ffffc900081e7930
RDX: 1ffff11017387352 RSI: ffff888017d13a00 RDI: ffff88807f371d00
RBP: ffffc900081e7ac0 R08: 0000000000000001 R09: 0000000000000000
R10: 0000000000000001 R11: 000000000000003f R12: ffff888017d13a00
R13: ffff8880b9c39a80 R14: ffff88807f372218 R15: ffff88801a3abf10
FS:  00007f1dbd29c700(0000) GS:ffff8880b9d00000(0000) knlGS:0000000000000000
CS:  0010 DS: 0000 ES: 0000 CR0: 0000000080050033
CR2: 00007fe56da98000 CR3: 0000000018b09000 CR4: 00000000003506e0
DR0: 0000000000000000 DR1: 0000000000000000 DR2: 0000000000000000
DR3: 0000000000000000 DR6: 00000000fffe0ff0 DR7: 0000000000000400
Call Trace:
----------------
Code disassembly (best guess):
   0:	55                   	push   %rbp
   1:	53                   	push   %rbx
   2:	41 54                	push   %r12
   4:	41 55                	push   %r13
   6:	41 56                	push   %r14
   8:	41 57                	push   %r15
   a:	48 89 a7 98 17 00 00 	mov    %rsp,0x1798(%rdi)
  11:	48 8b a6 98 17 00 00 	mov    0x1798(%rsi),%rsp
  18:	48 8b 9e d0 05 00 00 	mov    0x5d0(%rsi),%rbx
  1f:	65 48 89 1c 25 28 00 	mov    %rbx,%gs:0x28
  26:	00 00
  28:	41 5f                	pop    %r15
* 2a:	41 5e                	pop    %r14 <-- trapping instruction
  2c:	41 5d                	pop    %r13
  2e:	41 5c                	pop    %r12
  30:	5b                   	pop    %rbx
  31:	5d                   	pop    %rbp
  32:	e9 19 97 28 00       	jmpq   0x289750
  37:	66 0f 1f 84 00 00 00 	nopw   0x0(%rax,%rax,1)
  3e:	00 00


---
This report is generated by a bot. It may contain errors.
See https://goo.gl/tpsmEJ for more information about syzbot.
syzbot engineers can be reached at syzkaller@googlegroups.com.

syzbot will keep track of this issue. See:
https://goo.gl/tpsmEJ#status for how to communicate with syzbot.
