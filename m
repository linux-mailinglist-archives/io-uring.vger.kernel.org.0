Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id BF8562409DA
	for <lists+io-uring@lfdr.de>; Mon, 10 Aug 2020 17:36:41 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729213AbgHJPgV (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Mon, 10 Aug 2020 11:36:21 -0400
Received: from mail-io1-f72.google.com ([209.85.166.72]:44343 "EHLO
        mail-io1-f72.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1729006AbgHJPgS (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Mon, 10 Aug 2020 11:36:18 -0400
Received: by mail-io1-f72.google.com with SMTP id m12so7304087iov.11
        for <io-uring@vger.kernel.org>; Mon, 10 Aug 2020 08:36:18 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:date:message-id:subject:from:to;
        bh=+fLG61A9eCuOJ+VN2LjNHXpvQaE3FxmNy9hu4vih70E=;
        b=Rk5/AA5bFUSHTJMbPnZXdLWINabxNvAAXgDOKJYLRdsPbdIfpbXwYgBBbRizh/G9FD
         mEBbg5IY5Hw/aFaEmnt96H3nH8kFZ+urVCZkrGiLlHYWTA/jjavEgY+SAluhuaGmI7yB
         U6ftjk51cr91eJB57c19GCqbCnJK/e0Pnj3+EXyPLzON2FCMHgIjLtnlQbxN2lBVF5Su
         4k4JK6A6nsHuMU4ZwVzOlKkEt+iR9aYtcOhnQcn1v5RgXC716W1IfHLeG3Fzjkx/e0qP
         e9jxFoVh/sA02N+plyynE8BswPOhG1v4AVWMn3DcllngRg5Y3j+4JAGbTMmu4kmF0vqm
         HsXw==
X-Gm-Message-State: AOAM531QtUGshCt1erz1hSek2/t6i92izL1O6mMZuIfjVNbuyAJeHOVf
        4LP80OcPVsJOV3ytv/by4z1MmxjcF8S5M8hrs+NXJYrYr0Ib
X-Google-Smtp-Source: ABdhPJzYXIlBeC+R4RDnKBaNfmN2JJ/gZN5P6MU7QoI6eYkWFRcVYHLqmdYgOwfGhfnHJjMQcH+a7yBMG/toC3fMYHxfGlqgwSrk
MIME-Version: 1.0
X-Received: by 2002:a05:6638:1129:: with SMTP id f9mr20086051jar.35.1597073777883;
 Mon, 10 Aug 2020 08:36:17 -0700 (PDT)
Date:   Mon, 10 Aug 2020 08:36:17 -0700
X-Google-Appengine-App-Id: s~syzkaller
X-Google-Appengine-App-Id-Alias: syzkaller
Message-ID: <00000000000035fdf505ac87b7f9@google.com>
Subject: possible deadlock in __io_queue_deferred
From:   syzbot <syzbot+996f91b6ec3812c48042@syzkaller.appspotmail.com>
To:     axboe@kernel.dk, io-uring@vger.kernel.org,
        linux-fsdevel@vger.kernel.org, linux-kernel@vger.kernel.org,
        syzkaller-bugs@googlegroups.com, viro@zeniv.linux.org.uk
Content-Type: text/plain; charset="UTF-8"
Sender: io-uring-owner@vger.kernel.org
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org

Hello,

syzbot found the following issue on:

HEAD commit:    449dc8c9 Merge tag 'for-v5.9' of git://git.kernel.org/pub/..
git tree:       upstream
console output: https://syzkaller.appspot.com/x/log.txt?x=14d41e02900000
kernel config:  https://syzkaller.appspot.com/x/.config?x=9d25235bf0162fbc
dashboard link: https://syzkaller.appspot.com/bug?extid=996f91b6ec3812c48042
compiler:       clang version 10.0.0 (https://github.com/llvm/llvm-project/ c2443155a0fb245c8f17f2c1c72b6ea391e86e81)
syz repro:      https://syzkaller.appspot.com/x/repro.syz?x=133c9006900000
C reproducer:   https://syzkaller.appspot.com/x/repro.c?x=1191cb1a900000

IMPORTANT: if you fix the issue, please add the following tag to the commit:
Reported-by: syzbot+996f91b6ec3812c48042@syzkaller.appspotmail.com

============================================
WARNING: possible recursive locking detected
5.8.0-syzkaller #0 Not tainted
--------------------------------------------
syz-executor287/6816 is trying to acquire lock:
ffff888093cdb4d8 (&ctx->completion_lock){....}-{2:2}, at: spin_lock_irq include/linux/spinlock.h:379 [inline]
ffff888093cdb4d8 (&ctx->completion_lock){....}-{2:2}, at: io_queue_linked_timeout fs/io_uring.c:5928 [inline]
ffff888093cdb4d8 (&ctx->completion_lock){....}-{2:2}, at: __io_queue_async_work fs/io_uring.c:1192 [inline]
ffff888093cdb4d8 (&ctx->completion_lock){....}-{2:2}, at: __io_queue_deferred+0x36a/0x790 fs/io_uring.c:1237

but task is already holding lock:
ffff888093cdb4d8 (&ctx->completion_lock){....}-{2:2}, at: io_cqring_overflow_flush+0xc6/0xab0 fs/io_uring.c:1333

other info that might help us debug this:
 Possible unsafe locking scenario:

       CPU0
       ----
  lock(&ctx->completion_lock);
  lock(&ctx->completion_lock);

 *** DEADLOCK ***

 May be due to missing lock nesting notation

1 lock held by syz-executor287/6816:
 #0: ffff888093cdb4d8 (&ctx->completion_lock){....}-{2:2}, at: io_cqring_overflow_flush+0xc6/0xab0 fs/io_uring.c:1333

stack backtrace:
CPU: 1 PID: 6816 Comm: syz-executor287 Not tainted 5.8.0-syzkaller #0
Hardware name: Google Google Compute Engine/Google Compute Engine, BIOS Google 01/01/2011
Call Trace:
 __dump_stack lib/dump_stack.c:77 [inline]
 dump_stack+0x1f0/0x31e lib/dump_stack.c:118
 print_deadlock_bug kernel/locking/lockdep.c:2391 [inline]
 check_deadlock kernel/locking/lockdep.c:2432 [inline]
 validate_chain+0x69a4/0x88a0 kernel/locking/lockdep.c:3202
 __lock_acquire+0x1161/0x2ab0 kernel/locking/lockdep.c:4426
 lock_acquire+0x160/0x730 kernel/locking/lockdep.c:5005
 __raw_spin_lock_irq include/linux/spinlock_api_smp.h:128 [inline]
 _raw_spin_lock_irq+0x67/0x80 kernel/locking/spinlock.c:167
 spin_lock_irq include/linux/spinlock.h:379 [inline]
 io_queue_linked_timeout fs/io_uring.c:5928 [inline]
 __io_queue_async_work fs/io_uring.c:1192 [inline]
 __io_queue_deferred+0x36a/0x790 fs/io_uring.c:1237
 io_cqring_overflow_flush+0x774/0xab0 fs/io_uring.c:1359
 io_ring_ctx_wait_and_kill+0x2a1/0x570 fs/io_uring.c:7808
 io_uring_release+0x59/0x70 fs/io_uring.c:7829
 __fput+0x34f/0x7b0 fs/file_table.c:281
 task_work_run+0x137/0x1c0 kernel/task_work.c:135
 exit_task_work include/linux/task_work.h:25 [inline]
 do_exit+0x5f3/0x1f20 kernel/exit.c:806
 do_group_exit+0x161/0x2d0 kernel/exit.c:903
 __do_sys_exit_group+0x13/0x20 kernel/exit.c:914
 __se_sys_exit_group+0x10/0x10 kernel/exit.c:912
 __x64_sys_exit_group+0x37/0x40 kernel/exit.c:912
 do_syscall_64+0x31/0x70 arch/x86/entry/common.c:46
 entry_SYSCALL_64_after_hwframe+0x44/0xa9
RIP: 0033:0x43f598
Code: Bad RIP value.
RSP: 002b:00007fffdac2bf58 EFLAGS: 00000246 ORIG_RAX: 00000000000000e7
RAX: ffffffffffffffda RBX: 0000000000000000 RCX: 000000000043f598
RDX: 0000000000000000 RSI: 000000000000003c RDI: 0000000000000000
RBP: 00000000004beda8 R08: 00000000000000e7 R09: ffffffffffffffd0
R10: 0000000000000000 R11: 0000000000000246 R12: 0000000000000001
R13: 00000000006d11a0 R14: 0000000000000000 R15: 0000000000000000


---
This report is generated by a bot. It may contain errors.
See https://goo.gl/tpsmEJ for more information about syzbot.
syzbot engineers can be reached at syzkaller@googlegroups.com.

syzbot will keep track of this issue. See:
https://goo.gl/tpsmEJ#status for how to communicate with syzbot.
syzbot can test patches for this issue, for details see:
https://goo.gl/tpsmEJ#testing-patches
