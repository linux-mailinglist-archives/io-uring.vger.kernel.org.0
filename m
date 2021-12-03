Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 38AA6467351
	for <lists+io-uring@lfdr.de>; Fri,  3 Dec 2021 09:37:25 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1351106AbhLCIkr (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Fri, 3 Dec 2021 03:40:47 -0500
Received: from mail-io1-f71.google.com ([209.85.166.71]:52993 "EHLO
        mail-io1-f71.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S236266AbhLCIkr (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Fri, 3 Dec 2021 03:40:47 -0500
Received: by mail-io1-f71.google.com with SMTP id k12-20020a0566022a4c00b005ebe737d989so1695161iov.19
        for <io-uring@vger.kernel.org>; Fri, 03 Dec 2021 00:37:23 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:mime-version:date:message-id:subject:from:to;
        bh=9IwCa73Z+YOPimzGCLvws6NS4HcM322L2UNd+WfcjfU=;
        b=CjqH4dTiRi6DnZ8luRGfmTn7PoIag+f1L4iJKM/bisV1ft3/ToICYeSsm+M575XdYt
         lTvwovxWIkqrpQyUECi/UdarTgtod279hqdZCX3go8SpVCaZEjaRV0rT1bVOkim+Z5JR
         YGGG4fFxriCgJHq5rSQnvRSjBkKrxfHy+1ULc6A7QfLcOMZq6flni9oIKgxpNSvlD+GM
         jEk2xwx5uCoMzNk+b58bQ7D78pGvUsGIfOMX3ltL3lHJnK/5ff5UbIOy0p9QaVOrrl4J
         xGce9hVq1NKR56QtG9YzHzLKw+1tV9BwJdYIytHOG2gu9WvsMLUGTH1miYwleWcO6bNo
         4zSQ==
X-Gm-Message-State: AOAM530LIqTDfgXwPEnMRlqRO1pYgNUspQO7AmnnsdYxIql/WhQUKVxj
        wuBzzJOPLxoXAOuywnedEmICGu0otZPKkevngbdUE+1FICTm
X-Google-Smtp-Source: ABdhPJwOhxJ8k9CxVj5qHJRG2zMLOjTBuo7Kbqu1FlFRNoCJKXKifJVilN+/b0gvhrBEArWoR58i1zo6RwhQMngmnaCPrzMYEmgq
MIME-Version: 1.0
X-Received: by 2002:a02:ba8b:: with SMTP id g11mr22420185jao.128.1638520643115;
 Fri, 03 Dec 2021 00:37:23 -0800 (PST)
Date:   Fri, 03 Dec 2021 00:37:23 -0800
X-Google-Appengine-App-Id: s~syzkaller
X-Google-Appengine-App-Id-Alias: syzkaller
Message-ID: <000000000000e3df8e05d239d08a@google.com>
Subject: [syzbot] INFO: task hung in io_sq_thread_park (3)
From:   syzbot <syzbot+0fad9252b67f73124db9@syzkaller.appspotmail.com>
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
console output: https://syzkaller.appspot.com/x/log.txt?x=17cbc8c5b00000
kernel config:  https://syzkaller.appspot.com/x/.config?x=5b0eee8ab3ea1839
dashboard link: https://syzkaller.appspot.com/bug?extid=0fad9252b67f73124db9
compiler:       gcc (Debian 10.2.1-6) 10.2.1 20210110, GNU ld (GNU Binutils for Debian) 2.35.2

Unfortunately, I don't have any reproducer for this issue yet.

IMPORTANT: if you fix the issue, please add the following tag to the commit:
Reported-by: syzbot+0fad9252b67f73124db9@syzkaller.appspotmail.com

INFO: task kworker/u4:4:964 blocked for more than 143 seconds.
      Not tainted 5.16.0-rc3-syzkaller #0
"echo 0 > /proc/sys/kernel/hung_task_timeout_secs" disables this message.
task:kworker/u4:4    state:D stack:23392 pid:  964 ppid:     2 flags:0x00004000
Workqueue: events_unbound io_ring_exit_work
Call Trace:
 <TASK>
 context_switch kernel/sched/core.c:4972 [inline]
 __schedule+0xa9a/0x4940 kernel/sched/core.c:6253
 schedule+0xd2/0x260 kernel/sched/core.c:6326
 schedule_preempt_disabled+0xf/0x20 kernel/sched/core.c:6385
 __mutex_lock_common kernel/locking/mutex.c:680 [inline]
 __mutex_lock+0xa32/0x12f0 kernel/locking/mutex.c:740
 io_sq_thread_park+0x83/0xc1 fs/io_uring.c:7985
 io_ring_exit_work+0x132/0xbd0 fs/io_uring.c:9488
 process_one_work+0x9b2/0x1690 kernel/workqueue.c:2298
 worker_thread+0x658/0x11f0 kernel/workqueue.c:2445
 kthread+0x405/0x4f0 kernel/kthread.c:327
 ret_from_fork+0x1f/0x30 arch/x86/entry/entry_64.S:295
 </TASK>

Showing all locks held in the system:
1 lock held by khungtaskd/27:
 #0: ffffffff8bb83b60 (rcu_read_lock){....}-{1:2}, at: debug_show_all_locks+0x53/0x260 kernel/locking/lockdep.c:6458
3 locks held by kworker/u4:4/964:
 #0: ffff888010c69138 ((wq_completion)events_unbound){+.+.}-{0:0}, at: arch_atomic64_set arch/x86/include/asm/atomic64_64.h:34 [inline]
 #0: ffff888010c69138 ((wq_completion)events_unbound){+.+.}-{0:0}, at: arch_atomic_long_set include/linux/atomic/atomic-long.h:41 [inline]
 #0: ffff888010c69138 ((wq_completion)events_unbound){+.+.}-{0:0}, at: atomic_long_set include/linux/atomic/atomic-instrumented.h:1198 [inline]
 #0: ffff888010c69138 ((wq_completion)events_unbound){+.+.}-{0:0}, at: set_work_data kernel/workqueue.c:635 [inline]
 #0: ffff888010c69138 ((wq_completion)events_unbound){+.+.}-{0:0}, at: set_work_pool_and_clear_pending kernel/workqueue.c:662 [inline]
 #0: ffff888010c69138 ((wq_completion)events_unbound){+.+.}-{0:0}, at: process_one_work+0x896/0x1690 kernel/workqueue.c:2269
 #1: ffffc9000469fdb0 ((work_completion)(&ctx->exit_work)){+.+.}-{0:0}, at: process_one_work+0x8ca/0x1690 kernel/workqueue.c:2273
 #2: ffff888072ba4870 (&sqd->lock){+.+.}-{3:3}, at: io_sq_thread_park+0x83/0xc1 fs/io_uring.c:7985
1 lock held by in:imklog/6214:
 #0: ffff888073710370 (&f->f_pos_lock){+.+.}-{3:3}, at: __fdget_pos+0xe9/0x100 fs/file.c:990
4 locks held by iou-sqp-18541/18543:

=============================================

NMI backtrace for cpu 0
CPU: 0 PID: 27 Comm: khungtaskd Not tainted 5.16.0-rc3-syzkaller #0
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
CPU: 1 PID: 2956 Comm: systemd-journal Not tainted 5.16.0-rc3-syzkaller #0
Hardware name: Google Google Compute Engine/Google Compute Engine, BIOS Google 01/01/2011
RIP: 0010:security_cred_free+0xae/0x130 security/security.c:1686
Code: 80 3c 28 00 75 67 48 8b 1b 48 85 db 75 cb e8 69 4b d8 fd 4c 89 ea 48 b8 00 00 00 00 00 fc ff df 48 c1 ea 03 80 3c 02 00 75 6e <49> 8b ac 24 88 00 00 00 e8 45 4b d8 fd 48 89 ef e8 ed 6d 1e fe 4c
RSP: 0018:ffffc90001a4fde8 EFLAGS: 00000246
RAX: dffffc0000000000 RBX: 0000000000000000 RCX: 0000000000000000
RDX: 1ffff110039675f1 RSI: ffffffff839f5f57 RDI: ffff88801cb3af00
RBP: dffffc0000000000 R08: 0000000000000000 R09: ffff888010db4ab3
R10: ffffffff83a776d6 R11: 0000000000000000 R12: ffff88801cb3af00
R13: ffff88801cb3af88 R14: 0000000000000000 R15: 0000000000000000
FS:  00007fea3d76c8c0(0000) GS:ffff8880b9d00000(0000) knlGS:0000000000000000
CS:  0010 DS: 0000 ES: 0000 CR0: 0000000080050033
CR2: 00007fea3abe6000 CR3: 000000007e621000 CR4: 0000000000350ee0
Call Trace:
 <TASK>
 put_cred_rcu+0x122/0x520 kernel/cred.c:115
 __put_cred+0x1de/0x250 kernel/cred.c:151
 put_cred include/linux/cred.h:288 [inline]
 put_cred include/linux/cred.h:281 [inline]
 revert_creds+0x1a8/0x1f0 kernel/cred.c:608
 do_faccessat+0x2e7/0x850 fs/open.c:462
 do_syscall_x64 arch/x86/entry/common.c:50 [inline]
 do_syscall_64+0x35/0xb0 arch/x86/entry/common.c:80
 entry_SYSCALL_64_after_hwframe+0x44/0xae
RIP: 0033:0x7fea3ca279c7
Code: 83 c4 08 48 3d 01 f0 ff ff 73 01 c3 48 8b 0d c8 d4 2b 00 f7 d8 64 89 01 48 83 c8 ff c3 66 0f 1f 44 00 00 b8 15 00 00 00 0f 05 <48> 3d 01 f0 ff ff 73 01 c3 48 8b 0d a1 d4 2b 00 f7 d8 64 89 01 48
RSP: 002b:00007ffe79700ca8 EFLAGS: 00000246 ORIG_RAX: 0000000000000015
RAX: ffffffffffffffda RBX: 00007ffe79703cd0 RCX: 00007fea3ca279c7
RDX: 0000000000000000 RSI: 0000000000000000 RDI: 0000561873cda9a3
RBP: 00007ffe79700df0 R08: 0000561873cd03e5 R09: 0000000000000018
R10: 0000000000000069 R11: 0000000000000246 R12: 0000000000000000
R13: 0000000000000000 R14: 000056187561e8a0 R15: 00007ffe797012e0
 </TASK>
----------------
Code disassembly (best guess):
   0:	80 3c 28 00          	cmpb   $0x0,(%rax,%rbp,1)
   4:	75 67                	jne    0x6d
   6:	48 8b 1b             	mov    (%rbx),%rbx
   9:	48 85 db             	test   %rbx,%rbx
   c:	75 cb                	jne    0xffffffd9
   e:	e8 69 4b d8 fd       	callq  0xfdd84b7c
  13:	4c 89 ea             	mov    %r13,%rdx
  16:	48 b8 00 00 00 00 00 	movabs $0xdffffc0000000000,%rax
  1d:	fc ff df
  20:	48 c1 ea 03          	shr    $0x3,%rdx
  24:	80 3c 02 00          	cmpb   $0x0,(%rdx,%rax,1)
  28:	75 6e                	jne    0x98
* 2a:	49 8b ac 24 88 00 00 	mov    0x88(%r12),%rbp <-- trapping instruction
  31:	00
  32:	e8 45 4b d8 fd       	callq  0xfdd84b7c
  37:	48 89 ef             	mov    %rbp,%rdi
  3a:	e8 ed 6d 1e fe       	callq  0xfe1e6e2c
  3f:	4c                   	rex.WR


---
This report is generated by a bot. It may contain errors.
See https://goo.gl/tpsmEJ for more information about syzbot.
syzbot engineers can be reached at syzkaller@googlegroups.com.

syzbot will keep track of this issue. See:
https://goo.gl/tpsmEJ#status for how to communicate with syzbot.
