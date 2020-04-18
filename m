Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 3B6EA1AF403
	for <lists+io-uring@lfdr.de>; Sat, 18 Apr 2020 20:59:17 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728051AbgDRS7Q (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Sat, 18 Apr 2020 14:59:16 -0400
Received: from mail-il1-f197.google.com ([209.85.166.197]:33216 "EHLO
        mail-il1-f197.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1728044AbgDRS7P (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Sat, 18 Apr 2020 14:59:15 -0400
Received: by mail-il1-f197.google.com with SMTP id l18so6468081ilg.0
        for <io-uring@vger.kernel.org>; Sat, 18 Apr 2020 11:59:14 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:date:message-id:subject:from:to;
        bh=lNGjideo7zFgJ779fKErVM6LqcZZT6w673OoXDkI/mI=;
        b=QeyDJMT6cwj5gY35xHu3fuU/2q+P/3SSD+d1UtmZPSK3S/5z8WD3ZGr2naC68yIcUG
         ToHUT8ufqwKMnpI6EnISIzsdFqMXD7CR7bn9Tl+gN3MqPTj39c87weCBKRpBCrU/Uibv
         UQfv8Me71zLYsBxOQKBRw258fJl9ILCPxYb5f/NTSQAV9iagIZBSUYCHFtHfjjedJo1P
         gGy5F5lgP9UUpnHcMyI3iK9YW2c2CVCBhWn13ZvOz+8pUwlUNK9qdkrvB94LC3yVAy0h
         mA+iU5w7+YmRUq/JS0W7wuoS8hvFxrkFXUVkxOdgR4nbJStAxg4ikLBoDrXnjuOp9hLu
         0dSw==
X-Gm-Message-State: AGi0PuZIJTnFMJx6W9wNFhS6Ayp7am61dORZ9ZzLqSE5ily99g6Tx9X4
        8duD2tsZ1vSrhtJnl9FD8kAfNPS3tvpf6mPxNIB3znpD++Nf
X-Google-Smtp-Source: APiQypJ5LYYPmMiPhlLhndVNdNt2z1uXUt7Gts90Wfw8pxmW97GBxS/uMNXRXyuwqX8Z76kEamWgGZE98MyMCuOYIiL4zLfDMOkR
MIME-Version: 1.0
X-Received: by 2002:a92:c004:: with SMTP id q4mr8533307ild.93.1587236353725;
 Sat, 18 Apr 2020 11:59:13 -0700 (PDT)
Date:   Sat, 18 Apr 2020 11:59:13 -0700
X-Google-Appengine-App-Id: s~syzkaller
X-Google-Appengine-App-Id-Alias: syzkaller
Message-ID: <00000000000009dcd905a3954340@google.com>
Subject: INFO: rcu detected stall in io_uring_release
From:   syzbot <syzbot+66243bb7126c410cefe6@syzkaller.appspotmail.com>
To:     axboe@kernel.dk, io-uring@vger.kernel.org,
        linux-fsdevel@vger.kernel.org, linux-kernel@vger.kernel.org,
        syzkaller-bugs@googlegroups.com, viro@zeniv.linux.org.uk
Content-Type: text/plain; charset="UTF-8"
Sender: io-uring-owner@vger.kernel.org
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org

Hello,

syzbot found the following crash on:

HEAD commit:    8f3d9f35 Linux 5.7-rc1
git tree:       upstream
console output: https://syzkaller.appspot.com/x/log.txt?x=115720c3e00000
kernel config:  https://syzkaller.appspot.com/x/.config?x=5d351a1019ed81a2
dashboard link: https://syzkaller.appspot.com/bug?extid=66243bb7126c410cefe6
compiler:       gcc (GCC) 9.0.0 20181231 (experimental)

Unfortunately, I don't have any reproducer for this crash yet.

IMPORTANT: if you fix the bug, please add the following tag to the commit:
Reported-by: syzbot+66243bb7126c410cefe6@syzkaller.appspotmail.com

rcu: INFO: rcu_preempt self-detected stall on CPU
rcu: 	0-....: (10500 ticks this GP) idle=57e/1/0x4000000000000002 softirq=44329/44329 fqs=5245 
	(t=10502 jiffies g=79401 q=2096)
NMI backtrace for cpu 0
CPU: 0 PID: 23184 Comm: syz-executor.5 Not tainted 5.7.0-rc1-syzkaller #0
Hardware name: Google Google Compute Engine/Google Compute Engine, BIOS Google 01/01/2011
Call Trace:
 <IRQ>
 __dump_stack lib/dump_stack.c:77 [inline]
 dump_stack+0x188/0x20d lib/dump_stack.c:118
 nmi_cpu_backtrace.cold+0x70/0xb1 lib/nmi_backtrace.c:101
 nmi_trigger_cpumask_backtrace+0x231/0x27e lib/nmi_backtrace.c:62
 trigger_single_cpu_backtrace include/linux/nmi.h:164 [inline]
 rcu_dump_cpu_stacks+0x19b/0x1e5 kernel/rcu/tree_stall.h:254
 print_cpu_stall kernel/rcu/tree_stall.h:475 [inline]
 check_cpu_stall kernel/rcu/tree_stall.h:549 [inline]
 rcu_pending kernel/rcu/tree.c:3225 [inline]
 rcu_sched_clock_irq.cold+0x55d/0xcfa kernel/rcu/tree.c:2296
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
Code: 01 00 00 4d 89 f4 48 b8 00 00 00 00 00 fc ff df 4c 89 ed 49 c1 ec 03 48 c1 ed 03 49 01 c4 48 01 c5 eb 1c e8 3a ea 9d ff f3 90 <41> 80 3c 24 00 0f 85 53 04 00 00 48 83 bb 10 01 00 00 00 74 21 e8
RSP: 0018:ffffc9000897fdf0 EFLAGS: 00000293 ORIG_RAX: ffffffffffffff13
RAX: ffff888024082080 RBX: ffff88808df8e000 RCX: 1ffff9200112ffab
RDX: 0000000000000000 RSI: ffffffff81d549c6 RDI: ffff88808df8e300
RBP: ffffed1011bf1c2c R08: 0000000000000001 R09: ffffed1011bf1c61
R10: ffff88808df8e307 R11: ffffed1011bf1c60 R12: ffffed1011bf1c22
R13: ffff88808df8e160 R14: ffff88808df8e110 R15: ffffffff81d54ed0
 io_uring_release+0x3e/0x50 fs/io_uring.c:7324
 __fput+0x33e/0x880 fs/file_table.c:280
 task_work_run+0xf4/0x1b0 kernel/task_work.c:123
 tracehook_notify_resume include/linux/tracehook.h:188 [inline]
 exit_to_usermode_loop+0x2fa/0x360 arch/x86/entry/common.c:165
 prepare_exit_to_usermode arch/x86/entry/common.c:196 [inline]
 syscall_return_slowpath arch/x86/entry/common.c:279 [inline]
 do_syscall_64+0x6b1/0x7d0 arch/x86/entry/common.c:305
 entry_SYSCALL_64_after_hwframe+0x49/0xb3
RIP: 0033:0x416421
Code: 75 14 b8 03 00 00 00 0f 05 48 3d 01 f0 ff ff 0f 83 04 1b 00 00 c3 48 83 ec 08 e8 0a fc ff ff 48 89 04 24 b8 03 00 00 00 0f 05 <48> 8b 3c 24 48 89 c2 e8 53 fc ff ff 48 89 d0 48 83 c4 08 48 3d 01
RSP: 002b:00007ffc3c9f63d0 EFLAGS: 00000293 ORIG_RAX: 0000000000000003
RAX: 0000000000000000 RBX: 0000000000000004 RCX: 0000000000416421
RDX: 00000000000f4240 RSI: 0000000000000081 RDI: 0000000000000003
RBP: 0000000000000000 R08: 0000000000000000 R09: 01ffffffffffffff
R10: 0000000000770b20 R11: 0000000000000293 R12: 000000000076bfa0
R13: 0000000000770b30 R14: 0000000000000001 R15: 000000000076bfac


---
This bug is generated by a bot. It may contain errors.
See https://goo.gl/tpsmEJ for more information about syzbot.
syzbot engineers can be reached at syzkaller@googlegroups.com.

syzbot will keep track of this bug report. See:
https://goo.gl/tpsmEJ#status for how to communicate with syzbot.
