Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id C35C632B549
	for <lists+io-uring@lfdr.de>; Wed,  3 Mar 2021 07:50:29 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S239615AbhCCGmn (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Wed, 3 Mar 2021 01:42:43 -0500
Received: from mail-io1-f70.google.com ([209.85.166.70]:55569 "EHLO
        mail-io1-f70.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1581607AbhCBS7r (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Tue, 2 Mar 2021 13:59:47 -0500
Received: by mail-io1-f70.google.com with SMTP id e15so5949964ioe.22
        for <io-uring@vger.kernel.org>; Tue, 02 Mar 2021 10:59:31 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:date:in-reply-to:message-id:subject
         :from:to;
        bh=aXStB7B09qi9E7YwxmPgSkz9nQg+89gIu3eYJDouYcI=;
        b=V/UY4OcBBHpz9uriiwUYFNFibdrXztOHTEFRlp5Kti1vfKp/FEcVsSdoYq+snf/5KJ
         XWEAlQ4RsxThZsmtvf+nzzAqumLOcF8zbNvqkRjMhak084QgWrNu4pC2ZU2CTCgYfdKo
         EUOtCKV5F91gUegHpQKf1qbHKdWodd/f39cgkXgff80aldrDUuC36TicosBsRQeGhYhf
         AiGJsJa5kEGSL8oE0XvvSaRiZWYZuTaM4LZONOcdReRnXYSF5xeZorwliGTYX065t37d
         xy1kKPC1U4EOXZ8j84sZiOX5+o5y5njRxuWDPO+S84s4nMB550WM5keu7Fjh0HUKC1lb
         KqWA==
X-Gm-Message-State: AOAM533rT5KurTTRdAz3XYLYRzARqjO2VqwdoGg4wCX/Hq0PPMNmY2fa
        EN4+6tageIZ6qH0YUzsOpS2U5VVQyzMwsrt1m7ulGQFshhMz
X-Google-Smtp-Source: ABdhPJw5P0YOC1MnJxbOWefbMZcH/6MQQV6rrVC2OY+iwxu2F4lsCpEJSBmp5dCCuJMs4qe11rZjIRq4emK2sWH999jwxRtrrUMW
MIME-Version: 1.0
X-Received: by 2002:a05:6602:3314:: with SMTP id b20mr19581774ioz.78.1614711545606;
 Tue, 02 Mar 2021 10:59:05 -0800 (PST)
Date:   Tue, 02 Mar 2021 10:59:05 -0800
In-Reply-To: <586d357d-8c4c-8875-3a1c-0599a0a64da0@kernel.dk>
X-Google-Appengine-App-Id: s~syzkaller
X-Google-Appengine-App-Id-Alias: syzkaller
Message-ID: <00000000000017349305bc9254f4@google.com>
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
5.12.0-rc1-syzkaller #0 Not tainted
--------------------------------------------
syz-executor.4/10454 is trying to acquire lock:
ffff8880343cc130 (&runtime->sleep){..-.}-{2:2}, at: spin_lock include/linux/spinlock.h:354 [inline]
ffff8880343cc130 (&runtime->sleep){..-.}-{2:2}, at: io_poll_double_wake+0x25f/0x6a0 fs/io_uring.c:4925

but task is already holding lock:
ffff888034e3b130 (&runtime->sleep){..-.}-{2:2}, at: __wake_up_common_lock+0xb4/0x130 kernel/sched/wait.c:137

other info that might help us debug this:
 Possible unsafe locking scenario:

       CPU0
       ----
  lock(&runtime->sleep);
  lock(&runtime->sleep);

 *** DEADLOCK ***

 May be due to missing lock nesting notation

4 locks held by syz-executor.4/10454:
 #0: ffff888018cc8128 (&ctx->uring_lock){+.+.}-{3:3}, at: __do_sys_io_uring_enter+0x1146/0x2200 fs/io_uring.c:9113
 #1: ffff888021692440 (&runtime->oss.params_lock){+.+.}-{3:3}, at: snd_pcm_oss_change_params sound/core/oss/pcm_oss.c:1087 [inline]
 #1: ffff888021692440 (&runtime->oss.params_lock){+.+.}-{3:3}, at: snd_pcm_oss_make_ready+0xc7/0x1b0 sound/core/oss/pcm_oss.c:1149
 #2: ffff888020273908 (&group->lock){..-.}-{2:2}, at: _snd_pcm_stream_lock_irqsave+0x9f/0xd0 sound/core/pcm_native.c:170
 #3: ffff888034e3b130 (&runtime->sleep){..-.}-{2:2}, at: __wake_up_common_lock+0xb4/0x130 kernel/sched/wait.c:137

stack backtrace:
CPU: 0 PID: 10454 Comm: syz-executor.4 Not tainted 5.12.0-rc1-syzkaller #0
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
 io_poll_double_wake+0x25f/0x6a0 fs/io_uring.c:4925
 __wake_up_common+0x147/0x650 kernel/sched/wait.c:108
 __wake_up_common_lock+0xd0/0x130 kernel/sched/wait.c:138
 snd_pcm_update_state+0x46a/0x540 sound/core/pcm_lib.c:203
 snd_pcm_update_hw_ptr0+0xa75/0x1a50 sound/core/pcm_lib.c:464
 snd_pcm_period_elapsed+0x160/0x250 sound/core/pcm_lib.c:1805
 dummy_hrtimer_callback+0x94/0x1b0 sound/drivers/dummy.c:378
 __run_hrtimer kernel/time/hrtimer.c:1519 [inline]
 __hrtimer_run_queues+0x609/0xe40 kernel/time/hrtimer.c:1583
 hrtimer_run_softirq+0x17b/0x360 kernel/time/hrtimer.c:1600
 __do_softirq+0x29b/0x9f6 kernel/softirq.c:345
 invoke_softirq kernel/softirq.c:221 [inline]
 __irq_exit_rcu kernel/softirq.c:422 [inline]
 irq_exit_rcu+0x134/0x200 kernel/softirq.c:434
 sysvec_apic_timer_interrupt+0x93/0xc0 arch/x86/kernel/apic/apic.c:1100
 </IRQ>
 asm_sysvec_apic_timer_interrupt+0x12/0x20 arch/x86/include/asm/idtentry.h:632
RIP: 0010:unwind_next_frame+0xde0/0x2000 arch/x86/kernel/unwind_orc.c:611
Code: 48 b8 00 00 00 00 00 fc ff df 4c 89 fa 48 c1 ea 03 0f b6 04 02 84 c0 74 08 3c 03 0f 8e 83 0f 00 00 41 3b 2f 0f 84 c1 05 00 00 <bf> 01 00 00 00 e8 16 95 1b 00 b8 01 00 00 00 65 8b 15 ca a8 cf 7e
RSP: 0018:ffffc9000b447168 EFLAGS: 00000287
RAX: ffffc9000b448001 RBX: 1ffff92001688e35 RCX: 1ffff92001688e01
RDX: ffffc9000b447ae8 RSI: ffffc9000b447ab0 RDI: ffffc9000b447250
RBP: ffffc9000b447ae0 R08: ffffffff8dac0810 R09: 0000000000000001
R10: 0000000000084087 R11: 0000000000000001 R12: ffffc9000b440000
R13: ffffc9000b447275 R14: ffffc9000b447290 R15: ffffc9000b447240
 arch_stack_walk+0x7d/0xe0 arch/x86/kernel/stacktrace.c:25
 stack_trace_save+0x8c/0xc0 kernel/stacktrace.c:121
 kasan_save_stack+0x1b/0x40 mm/kasan/common.c:38
 kasan_set_track+0x1c/0x30 mm/kasan/common.c:46
 kasan_set_free_info+0x20/0x30 mm/kasan/generic.c:357
 ____kasan_slab_free mm/kasan/common.c:360 [inline]
 ____kasan_slab_free mm/kasan/common.c:325 [inline]
 __kasan_slab_free+0xf5/0x130 mm/kasan/common.c:367
 kasan_slab_free include/linux/kasan.h:199 [inline]
 slab_free_hook mm/slub.c:1562 [inline]
 slab_free_freelist_hook+0x72/0x1b0 mm/slub.c:1600
 slab_free mm/slub.c:3161 [inline]
 kfree+0xe5/0x7b0 mm/slub.c:4213
 snd_pcm_hw_param_near.constprop.0+0x7b0/0x8f0 sound/core/oss/pcm_oss.c:438
 snd_pcm_oss_change_params_locked+0x18c6/0x39a0 sound/core/oss/pcm_oss.c:936
 snd_pcm_oss_change_params sound/core/oss/pcm_oss.c:1090 [inline]
 snd_pcm_oss_make_ready+0xe7/0x1b0 sound/core/oss/pcm_oss.c:1149
 snd_pcm_oss_set_trigger.isra.0+0x30f/0x6e0 sound/core/oss/pcm_oss.c:2057
 snd_pcm_oss_poll+0x661/0xb10 sound/core/oss/pcm_oss.c:2841
 vfs_poll include/linux/poll.h:90 [inline]
 __io_arm_poll_handler+0x354/0xa20 fs/io_uring.c:5073
 io_arm_poll_handler fs/io_uring.c:5142 [inline]
 __io_queue_sqe+0x6ef/0xc40 fs/io_uring.c:6213
 io_queue_sqe+0x60d/0xf60 fs/io_uring.c:6259
 io_submit_sqe fs/io_uring.c:6423 [inline]
 io_submit_sqes+0x519a/0x6320 fs/io_uring.c:6537
 __do_sys_io_uring_enter+0x1152/0x2200 fs/io_uring.c:9114
 do_syscall_64+0x2d/0x70 arch/x86/entry/common.c:46
 entry_SYSCALL_64_after_hwframe+0x44/0xae
RIP: 0033:0x465ef9
Code: ff ff c3 66 2e 0f 1f 84 00 00 00 00 00 0f 1f 40 00 48 89 f8 48 89 f7 48 89 d6 48 89 ca 4d 89 c2 4d 89 c8 4c 8b 4c 24 08 0f 05 <48> 3d 01 f0 ff ff 73 01 c3 48 c7 c1 bc ff ff ff f7 d8 64 89 01 48
RSP: 002b:00007f818e00e188 EFLAGS: 00000246 ORIG_RAX: 00000000000001aa
RAX: ffffffffffffffda RBX: 000000000056c008 RCX: 0000000000465ef9
RDX: 0000000000000000 RSI: 0000000000002039 RDI: 0000000000000004
RBP: 00000000004bcd1c R08: 0000000000000000 R09: 0000000000000000
R10: 0000000000000000 R11: 0000000000000246 R12: 000000000056c008
R13: 0000000000a9fb1f R14: 00007f818e00e300 R15: 0000000000022000


Tested on:

commit:         c9387501 sound: name fiddling
git tree:       git://git.kernel.dk/linux-block syzbot-test
console output: https://syzkaller.appspot.com/x/log.txt?x=16a51856d00000
kernel config:  https://syzkaller.appspot.com/x/.config?x=fa0e4e0c3e0cf6e0
dashboard link: https://syzkaller.appspot.com/bug?extid=28abd693db9e92c160d8
compiler:       

