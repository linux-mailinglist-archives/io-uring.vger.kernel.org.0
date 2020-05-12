Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 4EDCE1CEAAD
	for <lists+io-uring@lfdr.de>; Tue, 12 May 2020 04:17:25 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728592AbgELCRP (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Mon, 11 May 2020 22:17:15 -0400
Received: from mail-il1-f199.google.com ([209.85.166.199]:50450 "EHLO
        mail-il1-f199.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727942AbgELCRP (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Mon, 11 May 2020 22:17:15 -0400
Received: by mail-il1-f199.google.com with SMTP id e8so11271472ile.17
        for <io-uring@vger.kernel.org>; Mon, 11 May 2020 19:17:14 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:date:in-reply-to:message-id:subject
         :from:to;
        bh=A+bGB37fUphrdg4rHZUQ/mDG5UQ3vJlqsxE4yR9cEE8=;
        b=CBoMcAytUMIZ9t+ySdB/TDrxOWWpBHELavPOjNot2SINTo3RBI8hcAOF5O2LI6yve6
         bTCRL2NVik14QK33n1kDdxetjZM6epsANhj3Wdg30BtORCaXqqiNK0dFnUwwrHh8DsXO
         oB1h8nEQAii88qQHpzuiyOLjzk+wd5IxfnBYBR+H/OXwGomFGy6KKK+jbnfzyKPB1PgI
         hbEbPXjIIkP0FCo2piUZLXvfKhzBpeSxog9BesLqKMZ/RX2VHxEBSKPiJC74l7Uu4Gtz
         AQtPh8YooX/s4Q3Qn1uVi4lfWGFMhNLpmVq7u0l+NQouGsuY4MdXWTU8SKOVp6WNMmBT
         yqmQ==
X-Gm-Message-State: AGi0Pub6mTy20pryNo7GKqZCXVdgxkweqHlLbBPMSxBpK2muMwvB09Ry
        sXu4/ARvRpbLAQsfinEqKyZJL6k+o+SZPzYOj7kXwRCbgGtY
X-Google-Smtp-Source: APiQypIctjI4BY678X/t1WAymF2cyXuX2SyTS1+z5w3mFX/fZa4vxhw2dKZ7JTseH4Vka4XJRt2E0ZvpPKA+IcgSpo1VYHbp8iLf
MIME-Version: 1.0
X-Received: by 2002:a92:d6c5:: with SMTP id z5mr13337735ilp.194.1589249834499;
 Mon, 11 May 2020 19:17:14 -0700 (PDT)
Date:   Mon, 11 May 2020 19:17:14 -0700
In-Reply-To: <00000000000009dcd905a3954340@google.com>
X-Google-Appengine-App-Id: s~syzkaller
X-Google-Appengine-App-Id-Alias: syzkaller
Message-ID: <000000000000d845e305a56a0f24@google.com>
Subject: Re: INFO: rcu detected stall in io_uring_release
From:   syzbot <syzbot+66243bb7126c410cefe6@syzkaller.appspotmail.com>
To:     asml.silence@gmail.com, axboe@kernel.dk, dan.carpenter@oracle.com,
        hdanton@sina.com, io-uring@vger.kernel.org,
        linux-fsdevel@vger.kernel.org, linux-kernel@vger.kernel.org,
        syzkaller-bugs@googlegroups.com, viro@zeniv.linux.org.uk
Content-Type: text/plain; charset="UTF-8"
Sender: io-uring-owner@vger.kernel.org
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org

syzbot has found a reproducer for the following crash on:

HEAD commit:    ac935d22 Add linux-next specific files for 20200415
git tree:       linux-next
console output: https://syzkaller.appspot.com/x/log.txt?x=13a38f0a100000
kernel config:  https://syzkaller.appspot.com/x/.config?x=bc498783097e9019
dashboard link: https://syzkaller.appspot.com/bug?extid=66243bb7126c410cefe6
compiler:       gcc (GCC) 9.0.0 20181231 (experimental)
syz repro:      https://syzkaller.appspot.com/x/repro.syz?x=179b3b32100000

IMPORTANT: if you fix the bug, please add the following tag to the commit:
Reported-by: syzbot+66243bb7126c410cefe6@syzkaller.appspotmail.com

rcu: INFO: rcu_preempt self-detected stall on CPU
rcu: 	0-....: (10533 ticks this GP) idle=aea/1/0x4000000000000002 softirq=10553/10555 fqs=5249 
	(t=10501 jiffies g=12777 q=556)
NMI backtrace for cpu 0
CPU: 0 PID: 8729 Comm: syz-executor.3 Not tainted 5.7.0-rc1-next-20200415-syzkaller #0
Hardware name: Google Google Compute Engine/Google Compute Engine, BIOS Google 01/01/2011
Call Trace:
 <IRQ>
 __dump_stack lib/dump_stack.c:77 [inline]
 dump_stack+0x188/0x20d lib/dump_stack.c:118
 nmi_cpu_backtrace.cold+0x70/0xb1 lib/nmi_backtrace.c:101
 nmi_trigger_cpumask_backtrace+0x231/0x27e lib/nmi_backtrace.c:62
 trigger_single_cpu_backtrace include/linux/nmi.h:165 [inline]
 rcu_dump_cpu_stacks+0x19b/0x1e5 kernel/rcu/tree_stall.h:254
 print_cpu_stall kernel/rcu/tree_stall.h:475 [inline]
 check_cpu_stall kernel/rcu/tree_stall.h:549 [inline]
 rcu_pending kernel/rcu/tree.c:3225 [inline]
 rcu_sched_clock_irq.cold+0x55d/0xd00 kernel/rcu/tree.c:2296
 update_process_times+0x25/0x60 kernel/time/timer.c:1727
 tick_sched_handle+0x9b/0x180 kernel/time/tick-sched.c:176
 tick_sched_timer+0x4e/0x140 kernel/time/tick-sched.c:1320
 __run_hrtimer kernel/time/hrtimer.c:1520 [inline]
 __hrtimer_run_queues+0x5ca/0xed0 kernel/time/hrtimer.c:1584
 hrtimer_interrupt+0x312/0x770 kernel/time/hrtimer.c:1646
 local_apic_timer_interrupt arch/x86/kernel/apic/apic.c:1113 [inline]
 smp_apic_timer_interrupt+0x15b/0x600 arch/x86/kernel/apic/apic.c:1138
 apic_timer_interrupt+0xf/0x20 arch/x86/entry/entry_64.S:829
 </IRQ>
RIP: 0010:io_ring_ctx_wait_and_kill+0x98/0x5a0 fs/io_uring.c:7301
Code: 01 00 00 4d 89 f4 48 b8 00 00 00 00 00 fc ff df 4c 89 ed 49 c1 ec 03 48 c1 ed 03 49 01 c4 48 01 c5 eb 1c e8 ba 65 9d ff f3 90 <41> 80 3c 24 00 0f 85 53 04 00 00 48 83 bb 10 01 00 00 00 74 21 e8
RSP: 0018:ffffc900054d7a50 EFLAGS: 00000293 ORIG_RAX: ffffffffffffff13
RAX: ffff888097c14400 RBX: ffff8880963a0000 RCX: 1ffff92000a9af37
RDX: 0000000000000000 RSI: ffffffff81d5ced6 RDI: ffff8880963a0300
RBP: ffffed1012c7402c R08: 0000000000000001 R09: ffffed1012c74061
R10: ffff8880963a0307 R11: ffffed1012c74060 R12: ffffed1012c74022
R13: ffff8880963a0160 R14: ffff8880963a0110 R15: ffffffff81d5d3e0
 io_uring_release+0x3e/0x50 fs/io_uring.c:7324
 __fput+0x33e/0x880 fs/file_table.c:280
 task_work_run+0xf4/0x1b0 kernel/task_work.c:123
 exit_task_work include/linux/task_work.h:22 [inline]
 do_exit+0xb53/0x2e10 kernel/exit.c:795
 do_group_exit+0x125/0x340 kernel/exit.c:893
 get_signal+0x47b/0x24e0 kernel/signal.c:2735
 do_signal+0x81/0x2240 arch/x86/kernel/signal.c:784
 exit_to_usermode_loop+0x26c/0x360 arch/x86/entry/common.c:161
 prepare_exit_to_usermode arch/x86/entry/common.c:196 [inline]
 syscall_return_slowpath arch/x86/entry/common.c:279 [inline]
 do_syscall_64+0x6b1/0x7d0 arch/x86/entry/common.c:305
 entry_SYSCALL_64_after_hwframe+0x49/0xb3
RIP: 0033:0x45c829
Code: Bad RIP value.
RSP: 002b:00007fdd2a37fc78 EFLAGS: 00000246 ORIG_RAX: 00000000000001a9
RAX: 0000000000000003 RBX: 00000000004e0ce0 RCX: 000000000045c829
RDX: 0000000000000000 RSI: 0000000020000580 RDI: 00000000000000f1
RBP: 000000000078bf00 R08: 0000000000000000 R09: 0000000000000000
R10: 0000000000000000 R11: 0000000000000246 R12: 00000000ffffffff
R13: 0000000000000204 R14: 00000000004c425f R15: 00007fdd2a3806d4

