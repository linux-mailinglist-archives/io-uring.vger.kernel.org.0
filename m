Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 2ED14466025
	for <lists+io-uring@lfdr.de>; Thu,  2 Dec 2021 10:08:35 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1345898AbhLBJLx (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Thu, 2 Dec 2021 04:11:53 -0500
Received: from mail-io1-f71.google.com ([209.85.166.71]:45664 "EHLO
        mail-io1-f71.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1345884AbhLBJLs (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Thu, 2 Dec 2021 04:11:48 -0500
Received: by mail-io1-f71.google.com with SMTP id ay10-20020a5d9d8a000000b005e238eaeaa9so32091152iob.12
        for <io-uring@vger.kernel.org>; Thu, 02 Dec 2021 01:08:24 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:mime-version:date:message-id:subject:from:to;
        bh=2nEPO550Rj0CJg8yzFP5f3pa89cCWBV9CiKJJK9J9Ac=;
        b=A+f9Jm7BreWIcsblEjFywk1Jrnjes68P9yQIkCSZwsL6vD/OYHXAgg3ColsAB3hFc4
         iSm9FeaZTen1zs5k7+xcQXRm/zCm8Rk2RQUn/oYPhDJ5g/4ICoyrVgkfPlrlI8+SG+E9
         rJwhtfctnYw51dQ33ez2xKB7qHiQqCeT8Eehg1sAl9QiWoeDjG8gDocP83FzH1p8FX+4
         CV9mSgt6CdfMZXneDR9oPX++ZMNPX237toWFuPAm0QbE1kAF8yWmkfhJRyE2qGzWFLyf
         KmzLVk7dO5ISVpzdqQN3+0KeRn0pG+/Oahp99u1Isl4jaq2zVHORYREUg3rSZoAK2GzP
         gdIQ==
X-Gm-Message-State: AOAM531DpIPCsjBlTI1XDWDsLHToFNuTTdlh78JGmgoUVsUgAn1EwsBL
        pNyxPRgx0l0E0vAsmafgwGpxCh030fJmEayOd+8nNHZ35cFw
X-Google-Smtp-Source: ABdhPJwdIiqglfIfrBETAzYIY+rhwwS3wQVLPY4aL7a9eQGw6Sh6Athe+nzFhQbvf66S+B/MJoucChJZb6IAY85eDyrQWXmZKz/U
MIME-Version: 1.0
X-Received: by 2002:a6b:b2c1:: with SMTP id b184mr14946846iof.24.1638436103738;
 Thu, 02 Dec 2021 01:08:23 -0800 (PST)
Date:   Thu, 02 Dec 2021 01:08:23 -0800
X-Google-Appengine-App-Id: s~syzkaller
X-Google-Appengine-App-Id-Alias: syzkaller
Message-ID: <000000000000f35e3b05d22621ff@google.com>
Subject: [syzbot] INFO: task hung in io_uring_try_cancel_iowq
From:   syzbot <syzbot+97bcaa1dfa37e2512746@syzkaller.appspotmail.com>
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
console output: https://syzkaller.appspot.com/x/log.txt?x=14b06cc5b00000
kernel config:  https://syzkaller.appspot.com/x/.config?x=e9ea28d2c3c2c389
dashboard link: https://syzkaller.appspot.com/bug?extid=97bcaa1dfa37e2512746
compiler:       Debian clang version 11.0.1-2, GNU ld (GNU Binutils for Debian) 2.35.2

Unfortunately, I don't have any reproducer for this issue yet.

IMPORTANT: if you fix the issue, please add the following tag to the commit:
Reported-by: syzbot+97bcaa1dfa37e2512746@syzkaller.appspotmail.com

INFO: task kworker/u4:10:22176 blocked for more than 143 seconds.
      Not tainted 5.16.0-rc3-syzkaller #0
"echo 0 > /proc/sys/kernel/hung_task_timeout_secs" disables this message.
task:kworker/u4:10   state:D stack:22352 pid:22176 ppid:     2 flags:0x00004000
Workqueue: events_unbound io_ring_exit_work
Call Trace:
 <TASK>
 context_switch kernel/sched/core.c:4972 [inline]
 __schedule+0xb72/0x1460 kernel/sched/core.c:6253
 schedule+0x12b/0x1f0 kernel/sched/core.c:6326
 schedule_preempt_disabled+0xf/0x20 kernel/sched/core.c:6385
 __mutex_lock_common+0xd1f/0x2590 kernel/locking/mutex.c:680
 __mutex_lock kernel/locking/mutex.c:740 [inline]
 mutex_lock_nested+0x1a/0x20 kernel/locking/mutex.c:792
 io_uring_try_cancel_iowq+0x2e/0x17e fs/io_uring.c:9644
 io_uring_try_cancel_requests+0x16f/0x42a fs/io_uring.c:9674
 io_ring_exit_work+0x10b/0x6b7 fs/io_uring.c:9483
 process_one_work+0x853/0x1140 kernel/workqueue.c:2298
 worker_thread+0xac1/0x1320 kernel/workqueue.c:2445
 kthread+0x468/0x490 kernel/kthread.c:327
 ret_from_fork+0x1f/0x30
 </TASK>

Showing all locks held in the system:
1 lock held by khungtaskd/27:
 #0: ffffffff8cb1db40 (rcu_read_lock){....}-{1:2}, at: rcu_lock_acquire+0x0/0x30
1 lock held by in:imklog/6218:
 #0: ffff88801a8a9c70 (&f->f_pos_lock){+.+.}-{3:3}, at: __fdget_pos+0x24e/0x2f0 fs/file.c:990
3 locks held by kworker/u4:10/22176:
 #0: ffff888011469138 ((wq_completion)events_unbound){+.+.}-{0:0}, at: process_one_work+0x7ca/0x1140
 #1: ffffc9000f5a7d20 ((work_completion)(&ctx->exit_work)){+.+.}-{0:0}, at: process_one_work+0x808/0x1140 kernel/workqueue.c:2273
 #2: ffff88807ca0c0a8 (&ctx->uring_lock){+.+.}-{3:3}, at: io_uring_try_cancel_iowq+0x2e/0x17e fs/io_uring.c:9644
2 locks held by kworker/u4:7/4146:
3 locks held by iou-sqp-5421/5424:

=============================================

NMI backtrace for cpu 1
CPU: 1 PID: 27 Comm: khungtaskd Not tainted 5.16.0-rc3-syzkaller #0
Hardware name: Google Google Compute Engine/Google Compute Engine, BIOS Google 01/01/2011
Call Trace:
 <TASK>
 __dump_stack lib/dump_stack.c:88 [inline]
 dump_stack_lvl+0x1dc/0x2d8 lib/dump_stack.c:106
 nmi_cpu_backtrace+0x45f/0x490 lib/nmi_backtrace.c:111
 nmi_trigger_cpumask_backtrace+0x16a/0x280 lib/nmi_backtrace.c:62
 trigger_all_cpu_backtrace include/linux/nmi.h:146 [inline]
 check_hung_uninterruptible_tasks kernel/hung_task.c:210 [inline]
 watchdog+0xc82/0xcd0 kernel/hung_task.c:295
 kthread+0x468/0x490 kernel/kthread.c:327
 ret_from_fork+0x1f/0x30
 </TASK>
Sending NMI from CPU 1 to CPUs 0:
NMI backtrace for cpu 0
CPU: 0 PID: 2950 Comm: systemd-journal Not tainted 5.16.0-rc3-syzkaller #0
Hardware name: Google Google Compute Engine/Google Compute Engine, BIOS Google 01/01/2011
RIP: 0010:check_kcov_mode kernel/kcov.c:177 [inline]
RIP: 0010:write_comp_data kernel/kcov.c:221 [inline]
RIP: 0010:__sanitizer_cov_trace_const_cmp4+0x31/0xa0 kernel/kcov.c:287
Code: 14 25 c0 6f 02 00 65 8b 05 74 e3 7d 7e a9 00 01 ff 00 74 10 a9 00 01 00 00 74 6e 83 ba a4 15 00 00 00 74 65 8b 82 80 15 00 00 <83> f8 03 75 5a 48 8b 8a 88 15 00 00 44 8b 8a 84 15 00 00 49 c1 e1
RSP: 0018:ffffc90001acf6d0 EFLAGS: 00000246
RAX: 0000000000000000 RBX: ffffc90001acfbc0 RCX: ffff88807d1bba00
RDX: ffff88807d1bba00 RSI: 0000000000000040 RDI: 0000000000000000
RBP: 0000000000000051 R08: ffffffff81df889b R09: ffffc90001acf660
R10: fffff52000359ed5 R11: 0000000000000000 R12: 1ffff92000359f7f
R13: dffffc0000000000 R14: ffffc90001acfbf8 R15: dffffc0000000000
FS:  00007f46c1ca58c0(0000) GS:ffff8880b9a00000(0000) knlGS:0000000000000000
CS:  0010 DS: 0000 ES: 0000 CR0: 0000000080050033
CR2: 00007f46bf1cd000 CR3: 000000001f549000 CR4: 00000000003506f0
DR0: 0000000000000000 DR1: 0000000000000000 DR2: 0000000000000000
DR3: 0000000000000000 DR6: 00000000fffe0ff0 DR7: 0000000000000400
Call Trace:
 <TASK>
 try_to_unlazy+0x7b/0xce0 fs/namei.c:772
 may_lookup fs/namei.c:1684 [inline]
 link_path_walk+0x298/0xd00 fs/namei.c:2239
 path_openat+0x25b/0x3660 fs/namei.c:3555
 do_filp_open+0x277/0x4f0 fs/namei.c:3586
 do_sys_openat2+0x13b/0x500 fs/open.c:1212
 do_sys_open fs/open.c:1228 [inline]
 __do_sys_open fs/open.c:1236 [inline]
 __se_sys_open fs/open.c:1232 [inline]
 __x64_sys_open+0x221/0x270 fs/open.c:1232
 do_syscall_x64 arch/x86/entry/common.c:50 [inline]
 do_syscall_64+0x44/0xd0 arch/x86/entry/common.c:80
 entry_SYSCALL_64_after_hwframe+0x44/0xae
RIP: 0033:0x7f46c1234840
Code: 73 01 c3 48 8b 0d 68 77 20 00 f7 d8 64 89 01 48 83 c8 ff c3 66 0f 1f 44 00 00 83 3d 89 bb 20 00 00 75 10 b8 02 00 00 00 0f 05 <48> 3d 01 f0 ff ff 73 31 c3 48 83 ec 08 e8 1e f6 ff ff 48 89 04 24
RSP: 002b:00007fffe2dca4d8 EFLAGS: 00000246 ORIG_RAX: 0000000000000002
RAX: ffffffffffffffda RBX: 00007fffe2dca7e0 RCX: 00007f46c1234840
RDX: 00000000000001a0 RSI: 0000000000080042 RDI: 0000563b4c24d640
RBP: 000000000000000d R08: 000000000000c0c1 R09: 00000000ffffffff
R10: 0000000000000069 R11: 0000000000000246 R12: 00000000ffffffff
R13: 0000563b4c240040 R14: 00007fffe2dca7a0 R15: 0000563b4c24d690
 </TASK>
----------------
Code disassembly (best guess):
   0:	14 25                	adc    $0x25,%al
   2:	c0 6f 02 00          	shrb   $0x0,0x2(%rdi)
   6:	65 8b 05 74 e3 7d 7e 	mov    %gs:0x7e7de374(%rip),%eax        # 0x7e7de381
   d:	a9 00 01 ff 00       	test   $0xff0100,%eax
  12:	74 10                	je     0x24
  14:	a9 00 01 00 00       	test   $0x100,%eax
  19:	74 6e                	je     0x89
  1b:	83 ba a4 15 00 00 00 	cmpl   $0x0,0x15a4(%rdx)
  22:	74 65                	je     0x89
  24:	8b 82 80 15 00 00    	mov    0x1580(%rdx),%eax
* 2a:	83 f8 03             	cmp    $0x3,%eax <-- trapping instruction
  2d:	75 5a                	jne    0x89
  2f:	48 8b 8a 88 15 00 00 	mov    0x1588(%rdx),%rcx
  36:	44 8b 8a 84 15 00 00 	mov    0x1584(%rdx),%r9d
  3d:	49                   	rex.WB
  3e:	c1                   	.byte 0xc1
  3f:	e1                   	.byte 0xe1


---
This report is generated by a bot. It may contain errors.
See https://goo.gl/tpsmEJ for more information about syzbot.
syzbot engineers can be reached at syzkaller@googlegroups.com.

syzbot will keep track of this issue. See:
https://goo.gl/tpsmEJ#status for how to communicate with syzbot.
