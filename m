Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 33E5835E803
	for <lists+io-uring@lfdr.de>; Tue, 13 Apr 2021 23:07:20 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1345585AbhDMVHh (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Tue, 13 Apr 2021 17:07:37 -0400
Received: from mail-il1-f200.google.com ([209.85.166.200]:37132 "EHLO
        mail-il1-f200.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229610AbhDMVHg (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Tue, 13 Apr 2021 17:07:36 -0400
Received: by mail-il1-f200.google.com with SMTP id m1so522188ilu.4
        for <io-uring@vger.kernel.org>; Tue, 13 Apr 2021 14:07:16 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:date:message-id:subject:from:to;
        bh=gBB56l8B63o8JGJvBXflD8n3+2lDt1Rtdswdt5GflVQ=;
        b=Dp9dJo0vq2WjmOpJJ+4tylOB5eIxiUIKEM56pbgnAqmU9P4JOk9UOHSalbNz4QzPF5
         GkHmyEoS42I7Uilu0h+o2sDhun3wMZdyY/qlfqSsaF9srVbAXstBhFXANpbqnqUxIgiR
         mDx9J3FQHggmm0brlien2gbmnoyHMx0LSZxvz+4zLBQBRbtcTwFULuc29/oLc+f0tk6w
         okbvUX9O4c4jry3Ap8YPP7gIO6Jv8af4tj84EznjhkConoATpYvmfgrNfj7VxW8zqTTX
         Esevq8bo3lAAj2zXZadRRU7gSBEYwsiiMEope+3XWAakxKUHTuJxnTDW71/KenztRwZQ
         hRew==
X-Gm-Message-State: AOAM53020b/zpToZqWJ32uOUnAWAN84RMkKZ+YQEqpUa+eOKUXB2Ipq9
        bpLm3Mrng22vvE2o2/7EH7BwS42wyDmvG0AFHJT1pq/kW8ix
X-Google-Smtp-Source: ABdhPJy4S/Wn2LnO8XH5aRFz6TbtDBXu7JtnGDHPqPXclmhiG+hj4a8tgRASZhqc1tVTclgPM0WDm5wGnWyy0XuitQJ7xJGW9yBX
MIME-Version: 1.0
X-Received: by 2002:a05:6638:a56:: with SMTP id 22mr20638222jap.33.1618348036402;
 Tue, 13 Apr 2021 14:07:16 -0700 (PDT)
Date:   Tue, 13 Apr 2021 14:07:16 -0700
X-Google-Appengine-App-Id: s~syzkaller
X-Google-Appengine-App-Id-Alias: syzkaller
Message-ID: <000000000000d5358b05bfe10354@google.com>
Subject: [syzbot] possible deadlock in io_poll_double_wake (3)
From:   syzbot <syzbot+e654d4e15e6b3b9deb53@syzkaller.appspotmail.com>
To:     asml.silence@gmail.com, axboe@kernel.dk, io-uring@vger.kernel.org,
        linux-kernel@vger.kernel.org, syzkaller-bugs@googlegroups.com
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org

Hello,

syzbot found the following issue on:

HEAD commit:    17e7124a Merge tag '5.12-rc6-smb3' of git://git.samba.org/..
git tree:       upstream
console output: https://syzkaller.appspot.com/x/log.txt?x=102c3891d00000
kernel config:  https://syzkaller.appspot.com/x/.config?x=9320464bf47598bd
dashboard link: https://syzkaller.appspot.com/bug?extid=e654d4e15e6b3b9deb53
syz repro:      https://syzkaller.appspot.com/x/repro.syz?x=15fe3096d00000
C reproducer:   https://syzkaller.appspot.com/x/repro.c?x=147b9431d00000

IMPORTANT: if you fix the issue, please add the following tag to the commit:
Reported-by: syzbot+e654d4e15e6b3b9deb53@syzkaller.appspotmail.com

============================================
WARNING: possible recursive locking detected
5.12.0-rc6-syzkaller #0 Not tainted
--------------------------------------------
swapper/0/0 is trying to acquire lock:
ffff88802108c130 (&runtime->sleep){..-.}-{2:2}, at: spin_lock include/linux/spinlock.h:354 [inline]
ffff88802108c130 (&runtime->sleep){..-.}-{2:2}, at: io_poll_double_wake+0x25f/0x6a0 fs/io_uring.c:4988

but task is already holding lock:
ffff888014fd8130 (&runtime->sleep){..-.}-{2:2}, at: __wake_up_common_lock+0xb4/0x130 kernel/sched/wait.c:137

other info that might help us debug this:
 Possible unsafe locking scenario:

       CPU0
       ----
  lock(&runtime->sleep);
  lock(&runtime->sleep);

 *** DEADLOCK ***

 May be due to missing lock nesting notation

2 locks held by swapper/0/0:
 #0: ffff888020d18108 (&group->lock){..-.}-{2:2}, at: _snd_pcm_stream_lock_irqsave+0x9f/0xd0 sound/core/pcm_native.c:170
 #1: ffff888014fd8130 (&runtime->sleep){..-.}-{2:2}, at: __wake_up_common_lock+0xb4/0x130 kernel/sched/wait.c:137

stack backtrace:
CPU: 0 PID: 0 Comm: swapper/0 Not tainted 5.12.0-rc6-syzkaller #0
Hardware name: Google Google Compute Engine/Google Compute Engine, BIOS Google 01/01/2011
Call Trace:
 <IRQ>
 __dump_stack lib/dump_stack.c:79 [inline]
 dump_stack+0x141/0x1d7 lib/dump_stack.c:120
 print_deadlock_bug kernel/locking/lockdep.c:2829 [inline]
 check_deadlock kernel/locking/lockdep.c:2872 [inline]
 validate_chain kernel/locking/lockdep.c:3661 [inline]
 __lock_acquire.cold+0x14c/0x3b4 kernel/locking/lockdep.c:4900
 lock_acquire kernel/locking/lockdep.c:5510 [inline]
 lock_acquire+0x1ab/0x740 kernel/locking/lockdep.c:5475
 __raw_spin_lock include/linux/spinlock_api_smp.h:142 [inline]
 _raw_spin_lock+0x2a/0x40 kernel/locking/spinlock.c:151
 spin_lock include/linux/spinlock.h:354 [inline]
 io_poll_double_wake+0x25f/0x6a0 fs/io_uring.c:4988
 __wake_up_common+0x147/0x650 kernel/sched/wait.c:108
 __wake_up_common_lock+0xd0/0x130 kernel/sched/wait.c:138
 snd_pcm_update_state+0x46a/0x540 sound/core/pcm_lib.c:203
 snd_pcm_update_hw_ptr0+0xa75/0x1a50 sound/core/pcm_lib.c:464
 snd_pcm_period_elapsed+0x160/0x250 sound/core/pcm_lib.c:1805
 dummy_hrtimer_callback+0x94/0x1b0 sound/drivers/dummy.c:377
 __run_hrtimer kernel/time/hrtimer.c:1537 [inline]
 __hrtimer_run_queues+0x609/0xe40 kernel/time/hrtimer.c:1601
 hrtimer_run_softirq+0x17b/0x360 kernel/time/hrtimer.c:1618
 __do_softirq+0x29b/0x9f6 kernel/softirq.c:345
 invoke_softirq kernel/softirq.c:221 [inline]
 __irq_exit_rcu kernel/softirq.c:422 [inline]
 irq_exit_rcu+0x134/0x200 kernel/softirq.c:434
 sysvec_apic_timer_interrupt+0x93/0xc0 arch/x86/kernel/apic/apic.c:1100
 </IRQ>
 asm_sysvec_apic_timer_interrupt+0x12/0x20 arch/x86/include/asm/idtentry.h:632
RIP: 0010:native_save_fl arch/x86/include/asm/irqflags.h:29 [inline]
RIP: 0010:arch_local_save_flags arch/x86/include/asm/irqflags.h:70 [inline]
RIP: 0010:arch_irqs_disabled arch/x86/include/asm/irqflags.h:137 [inline]
RIP: 0010:acpi_safe_halt drivers/acpi/processor_idle.c:112 [inline]
RIP: 0010:acpi_idle_do_entry+0x1c9/0x250 drivers/acpi/processor_idle.c:517
Code: cd cb 6e f8 84 db 75 ac e8 14 c5 6e f8 e8 1f b4 74 f8 e9 0c 00 00 00 e8 05 c5 6e f8 0f 00 2d 0e 18 c8 00 e8 f9 c4 6e f8 fb f4 <9c> 5b 81 e3 00 02 00 00 fa 31 ff 48 89 de e8 04 cd 6e f8 48 85 db
RSP: 0018:ffffffff8bc07d60 EFLAGS: 00000293
RAX: 0000000000000000 RBX: 0000000000000000 RCX: 0000000000000000
RDX: ffffffff8bcbc400 RSI: ffffffff89052c17 RDI: 0000000000000000
RBP: ffff888015078064 R08: 0000000000000001 R09: 0000000000000001
R10: ffffffff8179e058 R11: 0000000000000000 R12: 0000000000000001
R13: ffff888015078000 R14: ffff888015078064 R15: ffff888143a48004
 acpi_idle_enter+0x361/0x500 drivers/acpi/processor_idle.c:654
 cpuidle_enter_state+0x1b1/0xc80 drivers/cpuidle/cpuidle.c:237
 cpuidle_enter+0x4a/0xa0 drivers/cpuidle/cpuidle.c:351
 call_cpuidle kernel/sched/idle.c:158 [inline]
 cpuidle_idle_call kernel/sched/idle.c:239 [inline]
 do_idle+0x3e1/0x590 kernel/sched/idle.c:300


---
This report is generated by a bot. It may contain errors.
See https://goo.gl/tpsmEJ for more information about syzbot.
syzbot engineers can be reached at syzkaller@googlegroups.com.

syzbot will keep track of this issue. See:
https://goo.gl/tpsmEJ#status for how to communicate with syzbot.
syzbot can test patches for this issue, for details see:
https://goo.gl/tpsmEJ#testing-patches
