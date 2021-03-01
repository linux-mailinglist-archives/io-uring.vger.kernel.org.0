Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 6E6903276A0
	for <lists+io-uring@lfdr.de>; Mon,  1 Mar 2021 05:19:28 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233202AbhCAESy (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Sun, 28 Feb 2021 23:18:54 -0500
Received: from mail-il1-f199.google.com ([209.85.166.199]:42186 "EHLO
        mail-il1-f199.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233191AbhCAESs (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Sun, 28 Feb 2021 23:18:48 -0500
Received: by mail-il1-f199.google.com with SMTP id i16so10839269ila.9
        for <io-uring@vger.kernel.org>; Sun, 28 Feb 2021 20:18:32 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:date:in-reply-to:message-id:subject
         :from:to;
        bh=jGKJbsKWjLY3t1hbI1ad50n8UJWkfbpUJMTA9ScYOdQ=;
        b=X2XQqTKwpS8juSZPBpK0yiOxRUe7azOU0j3CU09BEmAs+EH/mQK/Tr9fc1DkFi6VYf
         u+ofy3+XtunCy7a32aXWVngaX+A+05W4LxOyc4vJy+6uH/0YCf13I+ZcSpHowABjHrqf
         u/thWmDiZh4sz2S/eAco/6zRct286I4D3ZexqERCFhYT2Pdvdni66/XUJQWd2Bl1M0CM
         swFoJSua/P6ARxnH5Wcbd6aWFOZRsPH8bQYVgURaDiYtJ7DMztjXnQ9WfxaUZP0OFsyy
         Asy4dfqO10c7sZVaz8qzKCfqSJkkdxRbGQy6kG6gJgju5Z9gpLRnEKHDd8W6zZ/VtxJy
         leyg==
X-Gm-Message-State: AOAM532c2EA2F2g88TvNNp5irnaMEJlZ/YSvzlyy7dActNh68grgoC3s
        OC5sd3HOg7sFWubC5j8i/9/NNlL4JmH6wZ1aeuCC9Dpum9s8
X-Google-Smtp-Source: ABdhPJzbk8yenPVEBjFaBJk9pDoAFImYrHa/idi0KSfzfWf6UKO7jBNh+JRxEb49CaamNQVuL53ajeITSuIp65gIbde/9LZWZiut
MIME-Version: 1.0
X-Received: by 2002:a05:6602:14c6:: with SMTP id b6mr12459382iow.104.1614572287239;
 Sun, 28 Feb 2021 20:18:07 -0800 (PST)
Date:   Sun, 28 Feb 2021 20:18:07 -0800
In-Reply-To: <900e27f3-6503-ed03-4c58-ccc946df7a6a@kernel.dk>
X-Google-Appengine-App-Id: s~syzkaller
X-Google-Appengine-App-Id-Alias: syzkaller
Message-ID: <000000000000a52fb105bc71e7b8@google.com>
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
syz-executor.0/10241 is trying to acquire lock:
ffff888012e09130 (&runtime->sleep){..-.}-{2:2}, at: spin_lock include/linux/spinlock.h:354 [inline]
ffff888012e09130 (&runtime->sleep){..-.}-{2:2}, at: io_poll_double_wake+0x25f/0x6a0 fs/io_uring.c:4921

but task is already holding lock:
ffff888013b00130 (&runtime->sleep){..-.}-{2:2}, at: __wake_up_common_lock+0xb4/0x130 kernel/sched/wait.c:137

other info that might help us debug this:
 Possible unsafe locking scenario:

       CPU0
       ----
  lock(&runtime->sleep);
  lock(&runtime->sleep);

 *** DEADLOCK ***

 May be due to missing lock nesting notation

4 locks held by syz-executor.0/10241:
 #0: ffff88801b1ce128 (&ctx->uring_lock){+.+.}-{3:3}, at: __do_sys_io_uring_enter+0x1155/0x22b0 fs/io_uring.c:9139
 #1: ffffffff8b574460 (rcu_read_lock){....}-{1:2}, at: file_ctx security/apparmor/include/file.h:33 [inline]
 #1: ffffffff8b574460 (rcu_read_lock){....}-{1:2}, at: aa_file_perm+0x119/0x1100 security/apparmor/file.c:607
 #2: ffff888020842108 (&group->lock){..-.}-{2:2}, at: _snd_pcm_stream_lock_irqsave+0x9f/0xd0 sound/core/pcm_native.c:170
 #3: ffff888013b00130 (&runtime->sleep){..-.}-{2:2}, at: __wake_up_common_lock+0xb4/0x130 kernel/sched/wait.c:137

stack backtrace:
CPU: 1 PID: 10241 Comm: syz-executor.0 Not tainted 5.11.0-syzkaller #0
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
RIP: 0010:lock_acquire+0x1e4/0x730 kernel/locking/lockdep.c:5478
Code: 07 b8 ff ff ff ff 65 0f c1 05 e8 b3 a8 7e 83 f8 01 0f 85 d9 03 00 00 48 83 7c 24 08 00 74 01 fb 48 b8 00 00 00 00 00 fc ff df <48> 01 c3 48 c7 03 00 00 00 00 48 c7 43 08 00 00 00 00 48 8b 84 24
RSP: 0018:ffffc9000b0e7468 EFLAGS: 00000206
RAX: dffffc0000000000 RBX: 1ffff9200161ce8f RCX: 00000000013c4b5b
RDX: 1ffff110030b54a9 RSI: 0000000000000000 RDI: 0000000000000000
RBP: 0000000000000000 R08: 0000000000000000 R09: ffffffff8f0a77a7
R10: fffffbfff1e14ef4 R11: 0000000000000000 R12: 0000000000000002
R13: ffffffff8b574460 R14: 0000000000000000 R15: 0000000000000000
 rcu_lock_acquire include/linux/rcupdate.h:267 [inline]
 rcu_read_lock include/linux/rcupdate.h:656 [inline]
 aa_file_perm+0x14d/0x1100 security/apparmor/file.c:609
 common_file_perm security/apparmor/lsm.c:466 [inline]
 apparmor_file_permission+0x163/0x4e0 security/apparmor/lsm.c:480
 security_file_permission+0x56/0x560 security/security.c:1456
 rw_verify_area+0x115/0x350 fs/read_write.c:400
 io_read+0x267/0xaf0 fs/io_uring.c:3235
 io_issue_sqe+0x2e1/0x59d0 fs/io_uring.c:5937
 __io_queue_sqe+0x18c/0xc40 fs/io_uring.c:6204
 io_queue_sqe+0x60d/0xf60 fs/io_uring.c:6257
 io_submit_sqe fs/io_uring.c:6421 [inline]
 io_submit_sqes+0x519a/0x6320 fs/io_uring.c:6535
 __do_sys_io_uring_enter+0x1161/0x22b0 fs/io_uring.c:9140
 do_syscall_64+0x2d/0x70 arch/x86/entry/common.c:46
 entry_SYSCALL_64_after_hwframe+0x44/0xae
RIP: 0033:0x465ef9
Code: ff ff c3 66 2e 0f 1f 84 00 00 00 00 00 0f 1f 40 00 48 89 f8 48 89 f7 48 89 d6 48 89 ca 4d 89 c2 4d 89 c8 4c 8b 4c 24 08 0f 05 <48> 3d 01 f0 ff ff 73 01 c3 48 c7 c1 bc ff ff ff f7 d8 64 89 01 48
RSP: 002b:00007fd5184e3188 EFLAGS: 00000246 ORIG_RAX: 00000000000001aa
RAX: ffffffffffffffda RBX: 000000000056bf60 RCX: 0000000000465ef9
RDX: 0000000000000000 RSI: 0000000000002039 RDI: 0000000000000004
RBP: 00000000004bcd1c R08: 0000000000000000 R09: 0000000000000000
R10: 0000000000000000 R11: 0000000000000246 R12: 000000000056bf60
R13: 0000000000a9fb1f R14: 00007fd5184e3300 R15: 0000000000022000


Tested on:

commit:         d5c6caec io_uring: test patch for double wake syzbot issue
git tree:       git://git.kernel.dk/linux-block syzbot-test
console output: https://syzkaller.appspot.com/x/log.txt?x=133f4f82d00000
kernel config:  https://syzkaller.appspot.com/x/.config?x=e348dbdef26bb725
dashboard link: https://syzkaller.appspot.com/bug?extid=28abd693db9e92c160d8
compiler:       

