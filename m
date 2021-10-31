Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 0CA4F440FC8
	for <lists+io-uring@lfdr.de>; Sun, 31 Oct 2021 18:40:32 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230209AbhJaRnC (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Sun, 31 Oct 2021 13:43:02 -0400
Received: from mail-il1-f198.google.com ([209.85.166.198]:43638 "EHLO
        mail-il1-f198.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229732AbhJaRnA (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Sun, 31 Oct 2021 13:43:00 -0400
Received: by mail-il1-f198.google.com with SMTP id s8-20020a92cbc8000000b002582a281a7bso8679158ilq.10
        for <io-uring@vger.kernel.org>; Sun, 31 Oct 2021 10:40:28 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:mime-version:date:message-id:subject:from:to;
        bh=g3iEMigpYmU/b8rBRslVB998+5hcxkuudEXmxIOgDVQ=;
        b=pSKzSkm1U7bgmEcak6np5DMxdnunBd8aGr4qTELIQkg4rtrKnTAVdr3nLMZkk4lMU1
         uJMQx8x/19e6NZbY2nPYlxjMHIloAuo47Hnt/mPbNcM0dJI4Rkkm78R44dKNeEN93g8c
         Z1So+py3GKx1tG6JyMtJ8suo+RH51e2xz3S0DN52n8MXFDmM4Ztam3PfGb6RiMcZa46a
         0IsQDWv3hnz0uwUq/aJO8RrC0EjsiJAxVRNLdoW+WuoRvt/QnL45Ds7ktzV7z2+fayhT
         pg9RIs6rByhhDdtJTJLUbUTPfi1xqA+g2Bh7OReVXagOvTV3tTv2uoVolcUaZA/IqekK
         JZlA==
X-Gm-Message-State: AOAM530KDNLUk7Lbf1cROnXfEj03RzgggrG3m0hvHgzB82enH2B+1Rtn
        KIyR5hSZiQSNvdOoovoLMfysObqBxJML0Q9BFXW0ZIShpiKe
X-Google-Smtp-Source: ABdhPJwBy9L/zia1sGaKa7r0CDGian0MZa65jmQvaLCVyYYMcrPKoF1hmQ8WdIuU7QlF+YHj7MkGmsV8xIwpnC8zcqejrBU6p50v
MIME-Version: 1.0
X-Received: by 2002:a05:6e02:17c8:: with SMTP id z8mr17163125ilu.247.1635702025534;
 Sun, 31 Oct 2021 10:40:25 -0700 (PDT)
Date:   Sun, 31 Oct 2021 10:40:25 -0700
X-Google-Appengine-App-Id: s~syzkaller
X-Google-Appengine-App-Id-Alias: syzkaller
Message-ID: <00000000000030c35005cfa98ed5@google.com>
Subject: [syzbot] INFO: rcu detected stall in tctx_task_work
From:   syzbot <syzbot+e4f5deeeccdd5a4873fe@syzkaller.appspotmail.com>
To:     asml.silence@gmail.com, axboe@kernel.dk, fweisbec@gmail.com,
        io-uring@vger.kernel.org, linux-kernel@vger.kernel.org,
        mingo@kernel.org, syzkaller-bugs@googlegroups.com,
        tglx@linutronix.de, xiaoguang.wang@linux.alibaba.com
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org

Hello,

syzbot found the following issue on:

HEAD commit:    bdcc9f6a5682 Add linux-next specific files for 20211029
git tree:       linux-next
console output: https://syzkaller.appspot.com/x/log.txt?x=10be38f4b00000
kernel config:  https://syzkaller.appspot.com/x/.config?x=4b504bcb4c507265
dashboard link: https://syzkaller.appspot.com/bug?extid=e4f5deeeccdd5a4873fe
compiler:       gcc (Debian 10.2.1-6) 10.2.1 20210110, GNU ld (GNU Binutils for Debian) 2.35.2
syz repro:      https://syzkaller.appspot.com/x/repro.syz?x=10b915d4b00000
C reproducer:   https://syzkaller.appspot.com/x/repro.c?x=1395f3e2b00000

The issue was bisected to:

commit 34ced75ca1f63fac6148497971212583aa0f7a87
Author: Xiaoguang Wang <xiaoguang.wang@linux.alibaba.com>
Date:   Mon Oct 25 05:38:48 2021 +0000

    io_uring: reduce frequent add_wait_queue() overhead for multi-shot poll request

bisection log:  https://syzkaller.appspot.com/x/bisect.txt?x=13f4a9d4b00000
final oops:     https://syzkaller.appspot.com/x/report.txt?x=100ca9d4b00000
console output: https://syzkaller.appspot.com/x/log.txt?x=17f4a9d4b00000

IMPORTANT: if you fix the issue, please add the following tag to the commit:
Reported-by: syzbot+e4f5deeeccdd5a4873fe@syzkaller.appspotmail.com
Fixes: 34ced75ca1f6 ("io_uring: reduce frequent add_wait_queue() overhead for multi-shot poll request")

rcu: INFO: rcu_preempt self-detected stall on CPU
rcu: 	0-....: (10499 ticks this GP) idle=91d/1/0x4000000000000000 softirq=9714/9714 fqs=3884 
	(t=10500 jiffies g=11093 q=47)
NMI backtrace for cpu 0
CPU: 0 PID: 6487 Comm: syz-executor141 Not tainted 5.15.0-rc7-next-20211029-syzkaller #0
Hardware name: Google Google Compute Engine/Google Compute Engine, BIOS Google 01/01/2011
Call Trace:
 <IRQ>
 __dump_stack lib/dump_stack.c:88 [inline]
 dump_stack_lvl+0xcd/0x134 lib/dump_stack.c:106
 nmi_cpu_backtrace.cold+0x47/0x144 lib/nmi_backtrace.c:105
 nmi_trigger_cpumask_backtrace+0x1ae/0x220 lib/nmi_backtrace.c:62
 trigger_single_cpu_backtrace include/linux/nmi.h:164 [inline]
 rcu_dump_cpu_stacks+0x25e/0x3f0 kernel/rcu/tree_stall.h:343
 print_cpu_stall kernel/rcu/tree_stall.h:604 [inline]
 check_cpu_stall kernel/rcu/tree_stall.h:688 [inline]
 rcu_pending kernel/rcu/tree.c:3922 [inline]
 rcu_sched_clock_irq.cold+0x9d/0x746 kernel/rcu/tree.c:2620
 update_process_times+0x16d/0x200 kernel/time/timer.c:1785
 tick_sched_handle+0x9b/0x180 kernel/time/tick-sched.c:226
 tick_sched_timer+0x1b0/0x2d0 kernel/time/tick-sched.c:1428
 __run_hrtimer kernel/time/hrtimer.c:1685 [inline]
 __hrtimer_run_queues+0x1c0/0xe50 kernel/time/hrtimer.c:1749
 hrtimer_interrupt+0x31c/0x790 kernel/time/hrtimer.c:1811
 local_apic_timer_interrupt arch/x86/kernel/apic/apic.c:1086 [inline]
 __sysvec_apic_timer_interrupt+0x146/0x530 arch/x86/kernel/apic/apic.c:1103
 sysvec_apic_timer_interrupt+0x8e/0xc0 arch/x86/kernel/apic/apic.c:1097
 </IRQ>
 <TASK>
 asm_sysvec_apic_timer_interrupt+0x12/0x20 arch/x86/include/asm/idtentry.h:638
RIP: 0010:debug_spin_unlock kernel/locking/spinlock_debug.c:104 [inline]
RIP: 0010:do_raw_spin_unlock+0x101/0x230 kernel/locking/spinlock_debug.c:140
Code: 8e fc 00 00 00 65 8b 05 e5 c5 a4 7e 39 45 08 0f 85 b5 00 00 00 48 b8 00 00 00 00 00 fc ff df 4c 89 ea 48 c1 ea 03 80 3c 02 00 <0f> 85 f5 00 00 00 4c 89 e2 48 c7 45 10 ff ff ff ff 48 b8 00 00 00
RSP: 0018:ffffc90002a8fcc8 EFLAGS: 00000246
RAX: dffffc0000000000 RBX: ffff88801a315950 RCX: ffffffff815d4f10
RDX: 1ffff1100449ce7a RSI: 0000000000000004 RDI: ffff8880224e73c0
RBP: ffff8880224e73c0 R08: 0000000000000000 R09: ffff8880224e73c3
R10: ffffed100449ce78 R11: 0000000000000000 R12: ffff8880224e73c8
R13: ffff8880224e73d0 R14: ffff88801a315918 R15: ffff88801a3158c0
 __raw_spin_unlock include/linux/spinlock_api_smp.h:151 [inline]
 _raw_spin_unlock+0x1a/0x40 kernel/locking/spinlock.c:186
 tctx_task_work+0x1b3/0x630 fs/io_uring.c:2207
 task_work_run+0xdd/0x1a0 kernel/task_work.c:164
 exit_task_work include/linux/task_work.h:32 [inline]
 do_exit+0xc14/0x2b40 kernel/exit.c:832
 do_group_exit+0x125/0x310 kernel/exit.c:929
 __do_sys_exit_group kernel/exit.c:940 [inline]
 __se_sys_exit_group kernel/exit.c:938 [inline]
 __x64_sys_exit_group+0x3a/0x50 kernel/exit.c:938
 do_syscall_x64 arch/x86/entry/common.c:50 [inline]
 do_syscall_64+0x35/0xb0 arch/x86/entry/common.c:80
 entry_SYSCALL_64_after_hwframe+0x44/0xae
RIP: 0033:0x7fe6950481a9
Code: Unable to access opcode bytes at RIP 0x7fe69504817f.
RSP: 002b:00007ffc42a91cb8 EFLAGS: 00000246 ORIG_RAX: 00000000000000e7
RAX: ffffffffffffffda RBX: 00007fe6950bc330 RCX: 00007fe6950481a9
RDX: 000000000000003c RSI: 00000000000000e7 RDI: 0000000000000000
RBP: 0000000000000000 R08: ffffffffffffffc0 R09: 00000000f5ffffff
R10: 0000000000000000 R11: 0000000000000246 R12: 00007fe6950bc330
R13: 0000000000000001 R14: 0000000000000000 R15: 0000000000000001
 </TASK>
----------------
Code disassembly (best guess):
   0:	8e fc                	mov    %esp,%?
   2:	00 00                	add    %al,(%rax)
   4:	00 65 8b             	add    %ah,-0x75(%rbp)
   7:	05 e5 c5 a4 7e       	add    $0x7ea4c5e5,%eax
   c:	39 45 08             	cmp    %eax,0x8(%rbp)
   f:	0f 85 b5 00 00 00    	jne    0xca
  15:	48 b8 00 00 00 00 00 	movabs $0xdffffc0000000000,%rax
  1c:	fc ff df
  1f:	4c 89 ea             	mov    %r13,%rdx
  22:	48 c1 ea 03          	shr    $0x3,%rdx
  26:	80 3c 02 00          	cmpb   $0x0,(%rdx,%rax,1)
* 2a:	0f 85 f5 00 00 00    	jne    0x125 <-- trapping instruction
  30:	4c 89 e2             	mov    %r12,%rdx
  33:	48 c7 45 10 ff ff ff 	movq   $0xffffffffffffffff,0x10(%rbp)
  3a:	ff
  3b:	48                   	rex.W
  3c:	b8                   	.byte 0xb8
  3d:	00 00                	add    %al,(%rax)


---
This report is generated by a bot. It may contain errors.
See https://goo.gl/tpsmEJ for more information about syzbot.
syzbot engineers can be reached at syzkaller@googlegroups.com.

syzbot will keep track of this issue. See:
https://goo.gl/tpsmEJ#status for how to communicate with syzbot.
For information about bisection process see: https://goo.gl/tpsmEJ#bisection
syzbot can test patches for this issue, for details see:
https://goo.gl/tpsmEJ#testing-patches
