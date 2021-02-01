Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 474FA30A434
	for <lists+io-uring@lfdr.de>; Mon,  1 Feb 2021 10:18:34 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232767AbhBAJRd (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Mon, 1 Feb 2021 04:17:33 -0500
Received: from mail-io1-f70.google.com ([209.85.166.70]:52394 "EHLO
        mail-io1-f70.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232719AbhBAJQz (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Mon, 1 Feb 2021 04:16:55 -0500
Received: by mail-io1-f70.google.com with SMTP id x17so11252039iov.19
        for <io-uring@vger.kernel.org>; Mon, 01 Feb 2021 01:16:38 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:date:message-id:subject:from:to;
        bh=qjnKowL0NWKITJezZfbQD3RWanZMvMk6rfyora+T86M=;
        b=Jyg6enEpj0YgEjJUVceJrgJuk6b4FnPaBVIsiapKRhpVzPkFAt3NboNyMCeqSyxJl0
         QNmNl17oH0uO58IbcqzBWSVqWAv1vJgqG0Q94NpflyWCF+VfSBwMfp3iGZ8AL1iTf4Zg
         1HwbSaoTyZZqS8nWknsIzYNhQ3IlDliIqcQdH7GlQk10eH18O4ll+ewwPu26JpCAjAP0
         zDO8ZBeML14gS9EwkC0d1TzdQlYEPYLLxmQV6P5HtMnZstx7UoaprC5AcEJgVeIRrfVz
         M07Oxea3XJGc668TYOuTMYbaTU4FvgWqTrMQp9JRP/eLDjsJhUSuzWl8oXwoNdRgjpMN
         y69g==
X-Gm-Message-State: AOAM532Lv2SNklUVhtdxx23bR7vMz1lBjM19Ty3V8mpE5V3j/87pkLl7
        UA3Fz9NmeMTIa8Y0fujZV32aj7Krk9FTQ49JAuvD+ft/ICRT
X-Google-Smtp-Source: ABdhPJx0NCex87hn4u7O6YkoThHY6EBpwRoGU63lVZRnLqDbtN15MvrP+DueiYbZRB+006aKMPAngqJ7eQc0N3VPehhjkOLNbCuH
MIME-Version: 1.0
X-Received: by 2002:a92:ca82:: with SMTP id t2mr11845649ilo.20.1612170971886;
 Mon, 01 Feb 2021 01:16:11 -0800 (PST)
Date:   Mon, 01 Feb 2021 01:16:11 -0800
X-Google-Appengine-App-Id: s~syzkaller
X-Google-Appengine-App-Id-Alias: syzkaller
Message-ID: <00000000000018b9a605ba42ce81@google.com>
Subject: inconsistent lock state in io_dismantle_req
From:   syzbot <syzbot+81d17233a2b02eafba33@syzkaller.appspotmail.com>
To:     asml.silence@gmail.com, axboe@kernel.dk, io-uring@vger.kernel.org,
        linux-kernel@vger.kernel.org, syzkaller-bugs@googlegroups.com
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org

Hello,

syzbot found the following issue on:

HEAD commit:    b01f250d Add linux-next specific files for 20210129
git tree:       linux-next
console output: https://syzkaller.appspot.com/x/log.txt?x=160cda90d00000
kernel config:  https://syzkaller.appspot.com/x/.config?x=725bc96dc234fda7
dashboard link: https://syzkaller.appspot.com/bug?extid=81d17233a2b02eafba33
compiler:       gcc (GCC) 10.1.0-syz 20200507
syz repro:      https://syzkaller.appspot.com/x/repro.syz?x=14f8a330d00000
C reproducer:   https://syzkaller.appspot.com/x/repro.c?x=12c10440d00000

IMPORTANT: if you fix the issue, please add the following tag to the commit:
Reported-by: syzbot+81d17233a2b02eafba33@syzkaller.appspotmail.com

================================
WARNING: inconsistent lock state
5.11.0-rc5-next-20210129-syzkaller #0 Not tainted
--------------------------------
inconsistent {HARDIRQ-ON-W} -> {IN-HARDIRQ-W} usage.
syz-executor217/8450 [HC1[1]:SC0[0]:HE0:SE1] takes:
ffff888023d6e620 (&fs->lock){?.+.}-{2:2}, at: spin_lock include/linux/spinlock.h:354 [inline]
ffff888023d6e620 (&fs->lock){?.+.}-{2:2}, at: io_req_clean_work fs/io_uring.c:1398 [inline]
ffff888023d6e620 (&fs->lock){?.+.}-{2:2}, at: io_dismantle_req+0x66f/0xf60 fs/io_uring.c:2029
{HARDIRQ-ON-W} state was registered at:
  lock_acquire kernel/locking/lockdep.c:5509 [inline]
  lock_acquire+0x1a8/0x720 kernel/locking/lockdep.c:5474
  __raw_spin_lock include/linux/spinlock_api_smp.h:142 [inline]
  _raw_spin_lock+0x2a/0x40 kernel/locking/spinlock.c:151
  spin_lock include/linux/spinlock.h:354 [inline]
  set_fs_pwd+0x85/0x2a0 fs/fs_struct.c:39
  init_chdir+0xdf/0x127 fs/init.c:54
  devtmpfs_setup drivers/base/devtmpfs.c:418 [inline]
  devtmpfsd+0x76/0x333 drivers/base/devtmpfs.c:433
  kthread+0x3b1/0x4a0 kernel/kthread.c:292
  ret_from_fork+0x1f/0x30 arch/x86/entry/entry_64.S:296
irq event stamp: 786
hardirqs last  enabled at (785): [<ffffffff8903de4f>] __raw_spin_unlock_irq include/linux/spinlock_api_smp.h:168 [inline]
hardirqs last  enabled at (785): [<ffffffff8903de4f>] _raw_spin_unlock_irq+0x1f/0x40 kernel/locking/spinlock.c:199
hardirqs last disabled at (786): [<ffffffff8901704c>] sysvec_apic_timer_interrupt+0xc/0x100 arch/x86/kernel/apic/apic.c:1096
softirqs last  enabled at (664): [<ffffffff87abbe04>] read_pnet include/net/net_namespace.h:324 [inline]
softirqs last  enabled at (664): [<ffffffff87abbe04>] sock_net include/net/sock.h:2550 [inline]
softirqs last  enabled at (664): [<ffffffff87abbe04>] unix_create1+0x484/0x570 net/unix/af_unix.c:814
softirqs last disabled at (662): [<ffffffff87abbd81>] unix_sockets_unbound net/unix/af_unix.c:133 [inline]
softirqs last disabled at (662): [<ffffffff87abbd81>] unix_create1+0x401/0x570 net/unix/af_unix.c:808

other info that might help us debug this:
 Possible unsafe locking scenario:

       CPU0
       ----
  lock(&fs->lock);
  <Interrupt>
    lock(&fs->lock);

 *** DEADLOCK ***

1 lock held by syz-executor217/8450:
 #0: ffff88802417c3e8 (&ctx->uring_lock){+.+.}-{3:3}, at: __do_sys_io_uring_enter+0x1071/0x1f30 fs/io_uring.c:9442

stack backtrace:
CPU: 1 PID: 8450 Comm: syz-executor217 Not tainted 5.11.0-rc5-next-20210129-syzkaller #0
Hardware name: Google Google Compute Engine/Google Compute Engine, BIOS Google 01/01/2011
Call Trace:
 <IRQ>
 __dump_stack lib/dump_stack.c:79 [inline]
 dump_stack+0x107/0x163 lib/dump_stack.c:120
 print_usage_bug kernel/locking/lockdep.c:3806 [inline]
 valid_state kernel/locking/lockdep.c:3817 [inline]
 mark_lock_irq kernel/locking/lockdep.c:4020 [inline]
 mark_lock.cold+0x61/0x8e kernel/locking/lockdep.c:4477
 mark_usage kernel/locking/lockdep.c:4369 [inline]
 __lock_acquire+0x1468/0x54c0 kernel/locking/lockdep.c:4853
 lock_acquire kernel/locking/lockdep.c:5509 [inline]
 lock_acquire+0x1a8/0x720 kernel/locking/lockdep.c:5474
 __raw_spin_lock include/linux/spinlock_api_smp.h:142 [inline]
 _raw_spin_lock+0x2a/0x40 kernel/locking/spinlock.c:151
 spin_lock include/linux/spinlock.h:354 [inline]
 io_req_clean_work fs/io_uring.c:1398 [inline]
 io_dismantle_req+0x66f/0xf60 fs/io_uring.c:2029
 __io_free_req+0x3d/0x2e0 fs/io_uring.c:2046
 io_free_req fs/io_uring.c:2269 [inline]
 io_double_put_req fs/io_uring.c:2392 [inline]
 io_put_req+0xf9/0x570 fs/io_uring.c:2388
 io_link_timeout_fn+0x30c/0x480 fs/io_uring.c:6497
 __run_hrtimer kernel/time/hrtimer.c:1519 [inline]
 __hrtimer_run_queues+0x609/0xe40 kernel/time/hrtimer.c:1583
 hrtimer_interrupt+0x334/0x940 kernel/time/hrtimer.c:1645
 local_apic_timer_interrupt arch/x86/kernel/apic/apic.c:1085 [inline]
 __sysvec_apic_timer_interrupt+0x146/0x540 arch/x86/kernel/apic/apic.c:1102
 asm_call_irq_on_stack+0xf/0x20
 </IRQ>
 __run_sysvec_on_irqstack arch/x86/include/asm/irq_stack.h:37 [inline]
 run_sysvec_on_irqstack_cond arch/x86/include/asm/irq_stack.h:89 [inline]
 sysvec_apic_timer_interrupt+0xbd/0x100 arch/x86/kernel/apic/apic.c:1096
 asm_sysvec_apic_timer_interrupt+0x12/0x20 arch/x86/include/asm/idtentry.h:629
RIP: 0010:__raw_spin_unlock_irq include/linux/spinlock_api_smp.h:169 [inline]
RIP: 0010:_raw_spin_unlock_irq+0x25/0x40 kernel/locking/spinlock.c:199
Code: 0f 1f 44 00 00 55 48 8b 74 24 08 48 89 fd 48 83 c7 18 e8 de 04 55 f8 48 89 ef e8 36 ba 55 f8 e8 71 16 75 f8 fb bf 01 00 00 00 <e8> 76 b9 49 f8 65 8b 05 5f 11 fe 76 85 c0 74 02 5d c3 e8 cb 66 fc
RSP: 0018:ffffc9000166f978 EFLAGS: 00000206
RAX: 0000000000000311 RBX: ffff8881416eaa00 RCX: 1ffffffff1df7d02
RDX: 0000000000000000 RSI: 0000000000000001 RDI: 0000000000000001
RBP: ffff88802417c480 R08: 0000000000000001 R09: ffffffff8ef738e7
R10: 0000000000000001 R11: 0000000000000000 R12: ffff88802417c480
R13: 0000000000000000 R14: 0000000000000001 R15: 0000000000000000
 spin_unlock_irq include/linux/spinlock.h:404 [inline]
 io_queue_linked_timeout+0x194/0x1f0 fs/io_uring.c:6525
 __io_queue_sqe+0x328/0x1290 fs/io_uring.c:6594
 io_queue_sqe+0x631/0x10d0 fs/io_uring.c:6639
 io_queue_link_head fs/io_uring.c:6650 [inline]
 io_submit_sqe fs/io_uring.c:6697 [inline]
 io_submit_sqes+0x19b5/0x2720 fs/io_uring.c:6960
 __do_sys_io_uring_enter+0x107d/0x1f30 fs/io_uring.c:9443
 do_syscall_64+0x2d/0x70 arch/x86/entry/common.c:46
 entry_SYSCALL_64_after_hwframe+0x44/0xa9
RIP: 0033:0x441619
Code: e8 fc ab 02 00 48 83 c4 18 c3 0f 1f 80 00 00 00 00 48 89 f8 48 89 f7 48 89 d6 48 89 ca 4d 89 c2 4d 89 c8 4c 8b 4c 24 08 0f 05 <48> 3d 01 f0 ff ff 0f 83 1b 09 fc ff c3 66 2e 0f 1f 84 00 00 00 00
RSP: 002b:00007ffc10aa3e28 EFLAGS: 00000246 ORIG_RAX: 00000000000001aa
RAX: ffffffffffffffda RBX: 0000000000000003 RCX: 0000000000441619
RDX: 0000000000000000 RSI: 0000000000004510 RDI: 0000000000000003
RBP: 00000000006cc018 R08: 0000000000000000 R09: 0000000000000000
R10: 0000000000000000 R11: 0000000000000246 R12: 00000000004023c0
R13: 0000000000402450 R14: 0000000000000000 R15: 0000000000000000


---
This report is generated by a bot. It may contain errors.
See https://goo.gl/tpsmEJ for more information about syzbot.
syzbot engineers can be reached at syzkaller@googlegroups.com.

syzbot will keep track of this issue. See:
https://goo.gl/tpsmEJ#status for how to communicate with syzbot.
syzbot can test patches for this issue, for details see:
https://goo.gl/tpsmEJ#testing-patches
