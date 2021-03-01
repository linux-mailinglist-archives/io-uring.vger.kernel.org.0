Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id DEB4B3282DE
	for <lists+io-uring@lfdr.de>; Mon,  1 Mar 2021 16:56:18 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S237418AbhCAPz6 (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Mon, 1 Mar 2021 10:55:58 -0500
Received: from mail-io1-f72.google.com ([209.85.166.72]:56517 "EHLO
        mail-io1-f72.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S237414AbhCAPzx (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Mon, 1 Mar 2021 10:55:53 -0500
Received: by mail-io1-f72.google.com with SMTP id y2so2130191ioa.23
        for <io-uring@vger.kernel.org>; Mon, 01 Mar 2021 07:55:32 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:date:in-reply-to:message-id:subject
         :from:to;
        bh=xJN3FVoUqXq7d6uuH16ejE/uBWtpJ9QdmwrYOd/l9Zo=;
        b=gywcYUAWnb8AFS+i4z/92dGrRXV6qdJ+yre0mjR3z+j+dk9B1WGeDiFd+NkWaYwLTT
         n62ZUlTGMXcvtrRCYhNBYv3/kKA4lbGj7poqBUqUKe+YcjdMINvQIsuK/JTqSfvQA78v
         JBoTeQ34m0IVWTHBUM5evlH9C7UUA5V/Vnh9YSwVfPtRki+czael7GFYv4TvcisWN+xq
         RP/MRm7D8mk1WgTf3XTypmoM4hw5x9OO3qed832bYT7E+P0iUrExwVN/PHUPExsyL6BN
         tyrUCOG3qo6bTuFg2KDCH0FfIlCkvt0Px0cIg5ArwJ5IupJo4a+t3nmY3rn35JBJJH1F
         TM8w==
X-Gm-Message-State: AOAM533+8KmAs4Mqc9Ptfy295wlMJOZpa0w9yJD2J+yUvZAlv2vQsqUr
        uVJ9jRQac+kqGAwqNOqXDT0kgMsT0QkBbYSywM/0DV2j3wa1
X-Google-Smtp-Source: ABdhPJx73Vkeb1VSKSpT1UU2iZtTjzJOSza135caDxdLdq2oytD2nPiEE3izIhJJsZwhJBkP9bZCHdopc6Pk4Q6mjZkcK7zaynK2
MIME-Version: 1.0
X-Received: by 2002:a02:aa92:: with SMTP id u18mr4581402jai.119.1614614107465;
 Mon, 01 Mar 2021 07:55:07 -0800 (PST)
Date:   Mon, 01 Mar 2021 07:55:07 -0800
In-Reply-To: <4c4caf8a-47e6-f112-f307-94fe0a622ff5@kernel.dk>
X-Google-Appengine-App-Id: s~syzkaller
X-Google-Appengine-App-Id-Alias: syzkaller
Message-ID: <00000000000053300505bc7ba4c1@google.com>
Subject: Re: possible deadlock in io_poll_double_wake (2)
From:   syzbot <syzbot+28abd693db9e92c160d8@syzkaller.appspotmail.com>
To:     asml.silence@gmail.com, axboe@kernel.dk, io-uring@vger.kernel.org,
        linux-fsdevel@vger.kernel.org, linux-kernel@vger.kernel.org,
        syzkaller-bugs@googlegroups.com, viro@zeniv.linux.org.uk
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org

Hello,

syzbot has tested the proposed patch but the reproducer is still triggering an issue:
possible deadlock in io_poll_double_wake

============================================
WARNING: possible recursive locking detected
5.11.0-syzkaller #0 Not tainted
--------------------------------------------
syz-executor.3/8853 is trying to acquire lock:
ffff88802cfbd130 (&runtime->sleep){..-.}-{2:2}, at: spin_lock include/linux/spinlock.h:354 [inline]
ffff88802cfbd130 (&runtime->sleep){..-.}-{2:2}, at: io_poll_double_wake+0x25f/0x6a0 fs/io_uring.c:4921

but task is already holding lock:
ffff888018ac2130 (&runtime->sleep){..-.}-{2:2}, at: __wake_up_common_lock+0xb4/0x130 kernel/sched/wait.c:137

other info that might help us debug this:
 Possible unsafe locking scenario:

       CPU0
       ----
  lock(&runtime->sleep);
  lock(&runtime->sleep);

 *** DEADLOCK ***

 May be due to missing lock nesting notation

5 locks held by syz-executor.3/8853:
 #0: ffffffff8b63e390 (dup_mmap_sem){.+.+}-{0:0}, at: dup_mmap kernel/fork.c:479 [inline]
 #0: ffffffff8b63e390 (dup_mmap_sem){.+.+}-{0:0}, at: dup_mm+0x108/0x1380 kernel/fork.c:1360
 #1: ffff8880249cb958 (&mm->mmap_lock#2){++++}-{3:3}, at: mmap_write_lock_killable include/linux/mmap_lock.h:87 [inline]
 #1: ffff8880249cb958 (&mm->mmap_lock#2){++++}-{3:3}, at: dup_mmap kernel/fork.c:480 [inline]
 #1: ffff8880249cb958 (&mm->mmap_lock#2){++++}-{3:3}, at: dup_mm+0x12e/0x1380 kernel/fork.c:1360
 #2: ffff88802b225558 (&mm->mmap_lock/1){+.+.}-{3:3}, at: mmap_write_lock_nested include/linux/mmap_lock.h:78 [inline]
 #2: ffff88802b225558 (&mm->mmap_lock/1){+.+.}-{3:3}, at: dup_mmap kernel/fork.c:489 [inline]
 #2: ffff88802b225558 (&mm->mmap_lock/1){+.+.}-{3:3}, at: dup_mm+0x18a/0x1380 kernel/fork.c:1360
 #3: ffff888020f6c908 (&group->lock){..-.}-{2:2}, at: _snd_pcm_stream_lock_irqsave+0x9f/0xd0 sound/core/pcm_native.c:170
 #4: ffff888018ac2130 (&runtime->sleep){..-.}-{2:2}, at: __wake_up_common_lock+0xb4/0x130 kernel/sched/wait.c:137

stack backtrace:
CPU: 1 PID: 8853 Comm: syz-executor.3 Not tainted 5.11.0-syzkaller #0
Hardware name: Google Google Compute Engine/Google Compute Engine, BIOS Google 01/01/2011
Call Trace:
 <IRQ>
 __dump_stack lib/dump_stack.c:79 [inline]
 dump_stack+0xfa/0x151 lib/dump_stack.c:120
 print_deadlock_bug kernel/locking/lockdep.c:2829 [inline]
 check_deadlock kernel/locking/lockdep.c:2872 [inline]
 validate_chain kernel/locking/lockdep.c:3661 [inline]
 __lock_acquire.cold+0x14c/0x3b4 kernel/locking/lockdep.c:4900
 lock_acquire kernel/locking/lockdep.c:5510 [inline]
 lock_acquire+0x1ab/0x730 kernel/locking/lockdep.c:5475
 __raw_spin_lock include/linux/spinlock_api_smp.h:142 [inline]
 _raw_spin_lock+0x2a/0x40 kernel/locking/spinlock.c:151
 spin_lock include/linux/spinlock.h:354 [inline]
 io_poll_double_wake+0x25f/0x6a0 fs/io_uring.c:4921
 __wake_up_common+0x147/0x650 kernel/sched/wait.c:108
 __wake_up_common_lock+0xd0/0x130 kernel/sched/wait.c:138
 snd_pcm_update_state+0x46a/0x540 sound/core/pcm_lib.c:203
 snd_pcm_update_hw_ptr0+0xa75/0x1a50 sound/core/pcm_lib.c:464
 snd_pcm_period_elapsed+0x160/0x250 sound/core/pcm_lib.c:1805
 dummy_hrtimer_callback+0x94/0x1b0 sound/drivers/dummy.c:378
 __run_hrtimer kernel/time/hrtimer.c:1519 [inline]
 __hrtimer_run_queues+0x609/0xe40 kernel/time/hrtimer.c:1583
 hrtimer_run_softirq+0x17b/0x360 kernel/time/hrtimer.c:1600
 __do_softirq+0x29b/0x9f6 kernel/softirq.c:343
 asm_call_irq_on_stack+0xf/0x20
 </IRQ>
 __run_on_irqstack arch/x86/include/asm/irq_stack.h:26 [inline]
 run_on_irqstack_cond arch/x86/include/asm/irq_stack.h:77 [inline]
 do_softirq_own_stack+0xaa/0xd0 arch/x86/kernel/irq_64.c:77
 invoke_softirq kernel/softirq.c:226 [inline]
 __irq_exit_rcu kernel/softirq.c:420 [inline]
 irq_exit_rcu+0x134/0x200 kernel/softirq.c:432
 sysvec_apic_timer_interrupt+0x4d/0x100 arch/x86/kernel/apic/apic.c:1100
 asm_sysvec_apic_timer_interrupt+0x12/0x20 arch/x86/include/asm/idtentry.h:635
RIP: 0010:__sanitizer_cov_trace_const_cmp8+0x0/0x70 kernel/kcov.c:290
Code: fe 72 22 44 89 c6 48 83 c2 01 48 89 4c 38 f0 48 c7 44 38 e0 05 00 00 00 48 89 74 38 e8 4e 89 54 c8 20 48 89 10 c3 0f 1f 40 00 <49> 89 f8 bf 03 00 00 00 4c 8b 14 24 48 89 f1 65 48 8b 34 25 00 f0
RSP: 0018:ffffc90001a6f808 EFLAGS: 00000246
RAX: 0000000000000000 RBX: ffffc90001a6fa00 RCX: 0000000000000001
RDX: 0000000000000000 RSI: 0000000000000000 RDI: 0000000000000000
RBP: 0000000000000004 R08: 0000000000000000 R09: ffff888022c75ea3
R10: ffffed100458ebd4 R11: 0000000000000000 R12: ffff88802b225800
R13: dffffc0000000000 R14: 0000000000000000 R15: 0000000000000000
 copy_pte_range mm/memory.c:1018 [inline]
 copy_pmd_range mm/memory.c:1070 [inline]
 copy_pud_range mm/memory.c:1107 [inline]
 copy_p4d_range mm/memory.c:1131 [inline]
 copy_page_range+0x127f/0x3fb0 mm/memory.c:1204
 dup_mmap kernel/fork.c:594 [inline]
 dup_mm+0x9ed/0x1380 kernel/fork.c:1360
 copy_mm kernel/fork.c:1416 [inline]
 copy_process+0x2a4c/0x6fd0 kernel/fork.c:2097
 kernel_clone+0xe7/0xab0 kernel/fork.c:2462
 __do_sys_clone+0xc8/0x110 kernel/fork.c:2579
 do_syscall_64+0x2d/0x70 arch/x86/entry/common.c:46
 entry_SYSCALL_64_after_hwframe+0x44/0xae
RIP: 0033:0x4644eb
Code: ed 0f 85 60 01 00 00 64 4c 8b 0c 25 10 00 00 00 45 31 c0 4d 8d 91 d0 02 00 00 31 d2 31 f6 bf 11 00 20 01 b8 38 00 00 00 0f 05 <48> 3d 00 f0 ff ff 0f 87 89 00 00 00 41 89 c5 85 c0 0f 85 90 00 00
RSP: 002b:0000000000a9fd50 EFLAGS: 00000246 ORIG_RAX: 0000000000000038
RAX: ffffffffffffffda RBX: 0000000000000000 RCX: 00000000004644eb
RDX: 0000000000000000 RSI: 0000000000000000 RDI: 0000000001200011
RBP: 0000000000000001 R08: 0000000000000000 R09: 00000000026a7400
R10: 00000000026a76d0 R11: 0000000000000246 R12: 0000000000000001
R13: 0000000000000000 R14: 0000000000000001 R15: 0000000000a9fe40


Tested on:

commit:         d5c6caec io_uring: test patch for double wake syzbot issue
git tree:       git://git.kernel.dk/linux-block syzbot-test
console output: https://syzkaller.appspot.com/x/log.txt?x=15129782d00000
kernel config:  https://syzkaller.appspot.com/x/.config?x=e348dbdef26bb725
dashboard link: https://syzkaller.appspot.com/bug?extid=28abd693db9e92c160d8
compiler:       

