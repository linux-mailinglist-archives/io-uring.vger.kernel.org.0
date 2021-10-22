Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 8AEB04370FC
	for <lists+io-uring@lfdr.de>; Fri, 22 Oct 2021 06:39:55 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231761AbhJVEk0 (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Fri, 22 Oct 2021 00:40:26 -0400
Received: from mail-io1-f69.google.com ([209.85.166.69]:43669 "EHLO
        mail-io1-f69.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231134AbhJVEk0 (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Fri, 22 Oct 2021 00:40:26 -0400
Received: by mail-io1-f69.google.com with SMTP id y11-20020a056602164b00b005de32183909so2189601iow.10
        for <io-uring@vger.kernel.org>; Thu, 21 Oct 2021 21:38:09 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:mime-version:date:in-reply-to:message-id:subject
         :from:to;
        bh=vchcYTHN/K+H4jbPQN/xLM29fx99UupAlN/YiAlKbjQ=;
        b=xp0EpCYyV4r/B696YCH7BCwhnqoqol27XNGiBpeb3LhtaC3iHzOOghy5vsOkyfL9jE
         wDcFKybrnMbTM18NSMQmqVK+UZenGrUL5GVFJJQlhdrs11JVVNtffGGzs6VU0ES2ob8g
         KLAgIxlbQWH7tEbsD7uWWxxSUFPh2l85R0oQQGJ3ib7r9yjOELhIm3vBoPA8ZODhB9qZ
         EFwtljDSDZi7jC2/mHQSGCbBYw7RuhtlxN+ia3SQgz7cl2F3SBPpUHB0usbh8FA4BOUJ
         Cg87/kZxwv+6Zlr8lqWF8JYz2rhPHmGmNqXT/0bGhN5C1uSbeD4viuACLQAG2KLrTlwN
         Ufkg==
X-Gm-Message-State: AOAM532W2URT8PCV6Fmwr/7MumDFXGpKFtmB0cotyf3Tl8iw0L+jiKmo
        5hPQVhfGxFlFdQjGR2fUyVkmJLMzk0snH1tFU1Go4RNiKef5
X-Google-Smtp-Source: ABdhPJy1vDT/1ZPsCsdLuWYj7qjsyIod7YpOXR1Ia1h3YKr6jTyZXl6US5eEmbFkKtxPmKrAGv1gqDW/3aeULWOj1wlcEyi1IPKL
MIME-Version: 1.0
X-Received: by 2002:a05:6602:2d4d:: with SMTP id d13mr7161427iow.53.1634877489285;
 Thu, 21 Oct 2021 21:38:09 -0700 (PDT)
Date:   Thu, 21 Oct 2021 21:38:09 -0700
In-Reply-To: <b9863d9b-11d3-8117-256b-714ae38f5494@gmail.com>
X-Google-Appengine-App-Id: s~syzkaller
X-Google-Appengine-App-Id-Alias: syzkaller
Message-ID: <0000000000000012fb05cee99477@google.com>
Subject: Re: [syzbot] INFO: task hung in io_wqe_worker
From:   syzbot <syzbot+27d62ee6f256b186883e@syzkaller.appspotmail.com>
To:     asml.silence@gmail.com, axboe@kernel.dk, io-uring@vger.kernel.org,
        linux-kernel@vger.kernel.org, syzkaller-bugs@googlegroups.com
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org

Hello,

syzbot has tested the proposed patch but the reproducer is still triggering an issue:
INFO: task hung in io_wqe_worker

INFO: task iou-wrk-9392:9401 blocked for more than 143 seconds.
      Not tainted 5.15.0-rc2-syzkaller #0
"echo 0 > /proc/sys/kernel/hung_task_timeout_secs" disables this message.
task:iou-wrk-9392    state:D stack:27952 pid: 9401 ppid:  7038 flags:0x00004004
Call Trace:
 context_switch kernel/sched/core.c:4940 [inline]
 __schedule+0xb44/0x5960 kernel/sched/core.c:6287
 schedule+0xd3/0x270 kernel/sched/core.c:6366
 schedule_timeout+0x1db/0x2a0 kernel/time/timer.c:1857
 do_wait_for_common kernel/sched/completion.c:85 [inline]
 __wait_for_common kernel/sched/completion.c:106 [inline]
 wait_for_common kernel/sched/completion.c:117 [inline]
 wait_for_completion+0x176/0x280 kernel/sched/completion.c:138
 io_worker_exit fs/io-wq.c:183 [inline]
 io_wqe_worker+0x66d/0xc40 fs/io-wq.c:597
 ret_from_fork+0x1f/0x30 arch/x86/entry/entry_64.S:295

Showing all locks held in the system:
1 lock held by khungtaskd/27:
 #0: ffffffff8b981ae0 (rcu_read_lock){....}-{1:2}, at: debug_show_all_locks+0x53/0x260 kernel/locking/lockdep.c:6446
1 lock held by cron/6230:
 #0: ffff8880b9c31a58 (&rq->__lock){-.-.}-{2:2}, at: raw_spin_rq_lock_nested+0x2b/0x120 kernel/sched/core.c:474
1 lock held by in:imklog/6237:
 #0: ffff88801db6ad70 (&f->f_pos_lock){+.+.}-{3:3}, at: __fdget_pos+0xe9/0x100 fs/file.c:990

=============================================

NMI backtrace for cpu 1
CPU: 1 PID: 27 Comm: khungtaskd Not tainted 5.15.0-rc2-syzkaller #0
Hardware name: Google Google Compute Engine/Google Compute Engine, BIOS Google 01/01/2011
Call Trace:
 __dump_stack lib/dump_stack.c:88 [inline]
 dump_stack_lvl+0xcd/0x134 lib/dump_stack.c:106
 nmi_cpu_backtrace.cold+0x47/0x144 lib/nmi_backtrace.c:105
 nmi_trigger_cpumask_backtrace+0x1ae/0x220 lib/nmi_backtrace.c:62
 trigger_all_cpu_backtrace include/linux/nmi.h:146 [inline]
 check_hung_uninterruptible_tasks kernel/hung_task.c:210 [inline]
 watchdog+0xc1d/0xf50 kernel/hung_task.c:295
 kthread+0x3e5/0x4d0 kernel/kthread.c:319
 ret_from_fork+0x1f/0x30 arch/x86/entry/entry_64.S:295
Sending NMI from CPU 1 to CPUs 0:
NMI backtrace for cpu 0
CPU: 0 PID: 6872 Comm: kworker/0:4 Not tainted 5.15.0-rc2-syzkaller #0
Hardware name: Google Google Compute Engine/Google Compute Engine, BIOS Google 01/01/2011
Workqueue: events nsim_dev_trap_report_work
RIP: 0010:set_canary_byte mm/kfence/core.c:214 [inline]
RIP: 0010:for_each_canary mm/kfence/core.c:249 [inline]
RIP: 0010:kfence_guarded_alloc mm/kfence/core.c:321 [inline]
RIP: 0010:__kfence_alloc+0x635/0xca0 mm/kfence/core.c:779
Code: 71 8a b8 ff 48 8b 6c 24 10 48 be 00 00 00 00 00 fc ff df 48 c1 ed 03 48 01 f5 4d 39 f7 73 5c e8 81 84 b8 ff 4c 89 f8 45 89 fe <4c> 89 fa 48 c1 e8 03 41 83 e6 07 83 e2 07 48 b9 00 00 00 00 00 fc
RSP: 0018:ffffc9000548fb48 EFLAGS: 00000093
RAX: ffff88823bce0d4b RBX: ffffffff9028ec08 RCX: 0000000000000000
RDX: ffff888079f7d580 RSI: ffffffff81be60df RDI: 0000000000000003
RBP: fffffbfff2051d8e R08: ffff88823bce0d4b R09: ffffffff8eef500f
R10: ffffffff81be6131 R11: 0000000000000001 R12: ffff8881441fa000
R13: 00000000000000e8 R14: 000000003bce0d4b R15: ffff88823bce0d4b
FS:  0000000000000000(0000) GS:ffff8880b9c00000(0000) knlGS:0000000000000000
CS:  0010 DS: 0000 ES: 0000 CR0: 0000000080050033
CR2: 00007efccb07f000 CR3: 000000000b68e000 CR4: 0000000000350ef0
Call Trace:
 kfence_alloc include/linux/kfence.h:124 [inline]
 slab_alloc_node mm/slub.c:3124 [inline]
 kmem_cache_alloc_node+0x213/0x3d0 mm/slub.c:3242
 __alloc_skb+0x20b/0x340 net/core/skbuff.c:414
 alloc_skb include/linux/skbuff.h:1116 [inline]
 nsim_dev_trap_skb_build drivers/net/netdevsim/dev.c:664 [inline]
 nsim_dev_trap_report drivers/net/netdevsim/dev.c:721 [inline]
 nsim_dev_trap_report_work+0x2ac/0xbd0 drivers/net/netdevsim/dev.c:762
 process_one_work+0x9bf/0x16b0 kernel/workqueue.c:2297
 worker_thread+0x658/0x11f0 kernel/workqueue.c:2444
 kthread+0x3e5/0x4d0 kernel/kthread.c:319
 ret_from_fork+0x1f/0x30 arch/x86/entry/entry_64.S:295
----------------
Code disassembly (best guess):
   0:	71 8a                	jno    0xffffff8c
   2:	b8 ff 48 8b 6c       	mov    $0x6c8b48ff,%eax
   7:	24 10                	and    $0x10,%al
   9:	48 be 00 00 00 00 00 	movabs $0xdffffc0000000000,%rsi
  10:	fc ff df
  13:	48 c1 ed 03          	shr    $0x3,%rbp
  17:	48 01 f5             	add    %rsi,%rbp
  1a:	4d 39 f7             	cmp    %r14,%r15
  1d:	73 5c                	jae    0x7b
  1f:	e8 81 84 b8 ff       	callq  0xffb884a5
  24:	4c 89 f8             	mov    %r15,%rax
  27:	45 89 fe             	mov    %r15d,%r14d
* 2a:	4c 89 fa             	mov    %r15,%rdx <-- trapping instruction
  2d:	48 c1 e8 03          	shr    $0x3,%rax
  31:	41 83 e6 07          	and    $0x7,%r14d
  35:	83 e2 07             	and    $0x7,%edx
  38:	48                   	rex.W
  39:	b9 00 00 00 00       	mov    $0x0,%ecx
  3e:	00 fc                	add    %bh,%ah


Tested on:

commit:         b22fa62a io_uring: apply worker limits to previous users
git tree:       git://git.kernel.dk/linux-block io_uring-5.15
console output: https://syzkaller.appspot.com/x/log.txt?x=16a3172cb00000
kernel config:  https://syzkaller.appspot.com/x/.config?x=cf1d1005f4fd6ccb
dashboard link: https://syzkaller.appspot.com/bug?extid=27d62ee6f256b186883e
compiler:       gcc (Debian 10.2.1-6) 10.2.1 20210110, GNU ld (GNU Binutils for Debian) 2.35.2

