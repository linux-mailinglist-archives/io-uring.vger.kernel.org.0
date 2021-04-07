Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 622443578AA
	for <lists+io-uring@lfdr.de>; Thu,  8 Apr 2021 01:52:10 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229520AbhDGXwT (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Wed, 7 Apr 2021 19:52:19 -0400
Received: from mail-io1-f69.google.com ([209.85.166.69]:53838 "EHLO
        mail-io1-f69.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229505AbhDGXwS (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Wed, 7 Apr 2021 19:52:18 -0400
Received: by mail-io1-f69.google.com with SMTP id r10so121013iod.20
        for <io-uring@vger.kernel.org>; Wed, 07 Apr 2021 16:52:08 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:date:in-reply-to:message-id:subject
         :from:to;
        bh=e/9KI2pt6RZT8NMLCpxHsidWT0O7BDfrY4oQWDeFxuQ=;
        b=r85Os7tbpTIByCx7vIf6xVxdZ3I043Yvwhj8BsagDEFGAvP3KTG8F84h0AEG2Mo5qq
         n9EKd7tXZdHF81EfYJHZmLU8KxWmWdtsKJjMrIfbguhaK8iLw0Q7da7LUjVLbc3sTKOl
         ZxNovzbWFjXETGMoGLIe4uQy6JxCyo7cPnT9wTUDQzuU1qI52fAKDkQqVqjw5/Kr4Tfg
         zAuCDt36kDBhRZFp53mKmLfLtmpZFoKvzjcjGM+SxPYAKiRu2a2GlrpiOyKDorvtBd4r
         n1E7Ahq3vw2styPuSILm5LV6I9pMIJxC/PA0iuGjTjnS3A7TU3hBKJ05ZzfvqVn6P933
         l1JQ==
X-Gm-Message-State: AOAM533Yp2jwHBX+qrTGADO7Rhlgyj/bR84KKJuSk5y72ie12Cf9YDc4
        nSUnUEHzsGm6ipVKZj+tjtLmPKthL6JHFUaTA8TZX5ajZTxA
X-Google-Smtp-Source: ABdhPJzNnxtrEADV1GZMbXPKRUV/9nzLx7VKnkMPGlLoRbvsPr1BXf06muwF7GGKqRb2WhUnzBUK8iATmDHjHgoLySa6iV56hK+e
MIME-Version: 1.0
X-Received: by 2002:a92:3644:: with SMTP id d4mr4896716ilf.53.1617839528408;
 Wed, 07 Apr 2021 16:52:08 -0700 (PDT)
Date:   Wed, 07 Apr 2021 16:52:08 -0700
In-Reply-To: <0ed14bc0-136d-e6e2-971b-513099864083@gmail.com>
X-Google-Appengine-App-Id: s~syzkaller
X-Google-Appengine-App-Id-Alias: syzkaller
Message-ID: <00000000000064fa3c05bf6a9ec9@google.com>
Subject: Re: [syzbot] INFO: task hung in io_ring_exit_work
From:   syzbot <syzbot+93f72b3885406bb09e0d@syzkaller.appspotmail.com>
To:     asml.silence@gmail.com, axboe@kernel.dk, io-uring@vger.kernel.org,
        linux-kernel@vger.kernel.org, syzkaller-bugs@googlegroups.com
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org

Hello,

syzbot has tested the proposed patch but the reproducer is still triggering an issue:
WARNING in kvm_wait

------------[ cut here ]------------
raw_local_irq_restore() called with IRQs enabled
WARNING: CPU: 1 PID: 8751 at kernel/locking/irqflag-debug.c:10 warn_bogus_irq_restore+0x1d/0x20 kernel/locking/irqflag-debug.c:10
Modules linked in:
CPU: 1 PID: 8751 Comm: syz-execprog Not tainted 5.12.0-rc2-syzkaller #0
Hardware name: Google Google Compute Engine/Google Compute Engine, BIOS Google 01/01/2011
RIP: 0010:warn_bogus_irq_restore+0x1d/0x20 kernel/locking/irqflag-debug.c:10
Code: bf ff cc cc cc cc cc cc cc cc cc cc cc 80 3d 50 f3 2f 04 00 74 01 c3 48 c7 c7 20 92 6b 89 c6 05 3f f3 2f 04 01 e8 77 2d bf ff <0f> 0b c3 48 39 77 10 0f 84 97 00 00 00 66 f7 47 22 f0 ff 74 4b 48
RSP: 0000:ffffc90000f1fa00 EFLAGS: 00010282
RAX: 0000000000000000 RBX: ffff88802b5f5d88 RCX: 0000000000000000
RDX: ffff88802b5f54c0 RSI: ffffffff815c3df5 RDI: fffff520001e3f32
RBP: 0000000000000200 R08: 0000000000000000 R09: 0000000000000000
R10: ffffffff815bcb8e R11: 0000000000000000 R12: 0000000000000003
R13: ffffed10056bebb1 R14: 0000000000000001 R15: ffff8880b9f35f40
FS:  0000000000000000(0000) GS:ffff8880b9f00000(0000) knlGS:0000000000000000
CS:  0010 DS: 0000 ES: 0000 CR0: 0000000080050033
CR2: 0000000000454476 CR3: 0000000013f15000 CR4: 00000000001506e0
DR0: 0000000000000000 DR1: 0000000000000000 DR2: 0000000000000000
DR3: 0000000000000000 DR6: 00000000fffe0ff0 DR7: 0000000000000400
Call Trace:
 kvm_wait arch/x86/kernel/kvm.c:860 [inline]
 kvm_wait+0xc9/0xe0 arch/x86/kernel/kvm.c:837
 pv_wait arch/x86/include/asm/paravirt.h:564 [inline]
 pv_wait_head_or_lock kernel/locking/qspinlock_paravirt.h:470 [inline]
 __pv_queued_spin_lock_slowpath+0x8b8/0xb40 kernel/locking/qspinlock.c:508
 pv_queued_spin_lock_slowpath arch/x86/include/asm/paravirt.h:554 [inline]
 queued_spin_lock_slowpath arch/x86/include/asm/qspinlock.h:51 [inline]
 queued_spin_lock include/asm-generic/qspinlock.h:85 [inline]
 do_raw_spin_lock+0x200/0x2b0 kernel/locking/spinlock_debug.c:113
 spin_lock include/linux/spinlock.h:354 [inline]
 task_lock include/linux/sched/task.h:168 [inline]
 exit_mm kernel/exit.c:481 [inline]
 do_exit+0xa6f/0x2a60 kernel/exit.c:812
 do_group_exit+0x125/0x310 kernel/exit.c:922
 get_signal+0x47f/0x2150 kernel/signal.c:2781
 arch_do_signal_or_restart+0x2a8/0x1eb0 arch/x86/kernel/signal.c:811
 handle_signal_work kernel/entry/common.c:147 [inline]
 exit_to_user_mode_loop kernel/entry/common.c:171 [inline]
 exit_to_user_mode_prepare+0x148/0x250 kernel/entry/common.c:208
 __syscall_exit_to_user_mode_work kernel/entry/common.c:290 [inline]
 syscall_exit_to_user_mode+0x19/0x60 kernel/entry/common.c:301
 entry_SYSCALL_64_after_hwframe+0x44/0xae
RIP: 0033:0x46ca23
Code: Unable to access opcode bytes at RIP 0x46c9f9.
RSP: 002b:00007ffe5318bb08 EFLAGS: 00000286 ORIG_RAX: 00000000000000ca
RAX: fffffffffffffe00 RBX: 00000000016b3d60 RCX: 000000000046ca23
RDX: 0000000000000000 RSI: 0000000000000080 RDI: 00000000016b3ea8
RBP: 00007ffe5318bb50 R08: 0000000000000000 R09: 0000000000000000
R10: 0000000000000000 R11: 0000000000000286 R12: 0000000000000003
R13: 00000000016b39a0 R14: 0000000000000005 R15: 00000000000000aa


Tested on:

commit:         1507b68f io_uring: don't quiesce reg buffer
git tree:       https://github.com/isilence/linux.git syz_test
console output: https://syzkaller.appspot.com/x/log.txt?x=1008508ed00000
kernel config:  https://syzkaller.appspot.com/x/.config?x=86318203e865a02b
dashboard link: https://syzkaller.appspot.com/bug?extid=93f72b3885406bb09e0d
compiler:       

