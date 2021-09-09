Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 8E918404212
	for <lists+io-uring@lfdr.de>; Thu,  9 Sep 2021 02:10:30 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1348100AbhIIALh (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Wed, 8 Sep 2021 20:11:37 -0400
Received: from mail-io1-f71.google.com ([209.85.166.71]:56257 "EHLO
        mail-io1-f71.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S244074AbhIIALh (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Wed, 8 Sep 2021 20:11:37 -0400
Received: by mail-io1-f71.google.com with SMTP id o128-20020a6bbe86000000b005bd06eaeca6so3261870iof.22
        for <io-uring@vger.kernel.org>; Wed, 08 Sep 2021 17:10:28 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:mime-version:date:message-id:subject:from:to;
        bh=oJITLq7oFNgdo+ig1paiTgEcP4D9oE5MGFM98vRAVnM=;
        b=inSYrM6kh1ky69R1ES2gFhbV9gxdsJ57xWJ225YdBvVWblnZwgzpj8duh/BacitOYL
         rbW92T3jvdycaDhpZ0+44pgNQhCehD0TgJV/i9W9aoGbcEFJshearQfBiHG4poKeI3WB
         OIYxFhgsfisvElW6qkWEAKmSot50IDJQtgMU/zkDBNTKYoKMQyf0enXWgd7+52LzoPWB
         ZkW+/BNGFrOFRJtBL3sTIy6dQI+cDWqsZ3W6DXlvRgsn7IoaUw8FDwAW2I8vS544ALFV
         qRKin8Cvi37GeDBQhr84ds034rf0tbXQF7of8Z+aQCNvWsSPc7k+fULUt/WZ9MZFGQPo
         hBgQ==
X-Gm-Message-State: AOAM533U9T2ck7cc9EFA96QiEZE8GtsJTyxk2SrjLJx9cBREZDm8JGj2
        lEaPPRGyqk43InY7BL+HF5XBnDZjEPS+bz1d/5CJ1J9jnYIJ
X-Google-Smtp-Source: ABdhPJznLR+RDJNtDm1Mug+RCBx/rryN7gfcSgmfV9zCuSBBBtfDxPbvLZ9Gqs5darJAy/92Caq2V8IUwQEnlL9ONEKdcdzkLlgi
MIME-Version: 1.0
X-Received: by 2002:a05:6638:d94:: with SMTP id l20mr195136jaj.134.1631146228485;
 Wed, 08 Sep 2021 17:10:28 -0700 (PDT)
Date:   Wed, 08 Sep 2021 17:10:28 -0700
X-Google-Appengine-App-Id: s~syzkaller
X-Google-Appengine-App-Id-Alias: syzkaller
Message-ID: <000000000000868f9305cb84d318@google.com>
Subject: [syzbot] possible deadlock in io_uring_register
From:   syzbot <syzbot+97fa56483f69d677969f@syzkaller.appspotmail.com>
To:     asml.silence@gmail.com, axboe@kernel.dk, io-uring@vger.kernel.org,
        linux-kernel@vger.kernel.org, syzkaller-bugs@googlegroups.com
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org

Hello,

syzbot found the following issue on:

HEAD commit:    ac08b1c68d1b Merge tag 'pci-v5.15-changes' of git://git.ke..
git tree:       upstream
console output: https://syzkaller.appspot.com/x/log.txt?x=177842dd300000
kernel config:  https://syzkaller.appspot.com/x/.config?x=dc596ab8008badc2
dashboard link: https://syzkaller.appspot.com/bug?extid=97fa56483f69d677969f
compiler:       gcc (Debian 10.2.1-6) 10.2.1 20210110, GNU ld (GNU Binutils for Debian) 2.35.1

Unfortunately, I don't have any reproducer for this issue yet.

IMPORTANT: if you fix the issue, please add the following tag to the commit:
Reported-by: syzbot+97fa56483f69d677969f@syzkaller.appspotmail.com

======================================================
WARNING: possible circular locking dependency detected
5.14.0-syzkaller #0 Not tainted
------------------------------------------------------
syz-executor.5/25433 is trying to acquire lock:
ffff888023426870 (&sqd->lock){+.+.}-{3:3}, at: io_register_iowq_max_workers fs/io_uring.c:10551 [inline]
ffff888023426870 (&sqd->lock){+.+.}-{3:3}, at: __io_uring_register fs/io_uring.c:10757 [inline]
ffff888023426870 (&sqd->lock){+.+.}-{3:3}, at: __do_sys_io_uring_register+0x10aa/0x2e70 fs/io_uring.c:10792

but task is already holding lock:
ffff8880885b40a8 (&ctx->uring_lock){+.+.}-{3:3}, at: __do_sys_io_uring_register+0x2e1/0x2e70 fs/io_uring.c:10791

which lock already depends on the new lock.


the existing dependency chain (in reverse order) is:

-> #1 (&ctx->uring_lock){+.+.}-{3:3}:
       __mutex_lock_common kernel/locking/mutex.c:596 [inline]
       __mutex_lock+0x131/0x12f0 kernel/locking/mutex.c:729
       __io_sq_thread fs/io_uring.c:7291 [inline]
       io_sq_thread+0x65a/0x1370 fs/io_uring.c:7368
       ret_from_fork+0x1f/0x30 arch/x86/entry/entry_64.S:295

-> #0 (&sqd->lock){+.+.}-{3:3}:
       check_prev_add kernel/locking/lockdep.c:3051 [inline]
       check_prevs_add kernel/locking/lockdep.c:3174 [inline]
       validate_chain kernel/locking/lockdep.c:3789 [inline]
       __lock_acquire+0x2a07/0x54a0 kernel/locking/lockdep.c:5015
       lock_acquire kernel/locking/lockdep.c:5625 [inline]
       lock_acquire+0x1ab/0x510 kernel/locking/lockdep.c:5590
       __mutex_lock_common kernel/locking/mutex.c:596 [inline]
       __mutex_lock+0x131/0x12f0 kernel/locking/mutex.c:729
       io_register_iowq_max_workers fs/io_uring.c:10551 [inline]
       __io_uring_register fs/io_uring.c:10757 [inline]
       __do_sys_io_uring_register+0x10aa/0x2e70 fs/io_uring.c:10792
       do_syscall_x64 arch/x86/entry/common.c:50 [inline]
       do_syscall_64+0x35/0xb0 arch/x86/entry/common.c:80
       entry_SYSCALL_64_after_hwframe+0x44/0xae

other info that might help us debug this:

 Possible unsafe locking scenario:

       CPU0                    CPU1
       ----                    ----
  lock(&ctx->uring_lock);
                               lock(&sqd->lock);
                               lock(&ctx->uring_lock);
  lock(&sqd->lock);

 *** DEADLOCK ***

1 lock held by syz-executor.5/25433:
 #0: ffff8880885b40a8 (&ctx->uring_lock){+.+.}-{3:3}, at: __do_sys_io_uring_register+0x2e1/0x2e70 fs/io_uring.c:10791

stack backtrace:
CPU: 1 PID: 25433 Comm: syz-executor.5 Not tainted 5.14.0-syzkaller #0
Hardware name: Google Google Compute Engine/Google Compute Engine, BIOS Google 01/01/2011
Call Trace:
 __dump_stack lib/dump_stack.c:88 [inline]
 dump_stack_lvl+0xcd/0x134 lib/dump_stack.c:105
 check_noncircular+0x25f/0x2e0 kernel/locking/lockdep.c:2131
 check_prev_add kernel/locking/lockdep.c:3051 [inline]
 check_prevs_add kernel/locking/lockdep.c:3174 [inline]
 validate_chain kernel/locking/lockdep.c:3789 [inline]
 __lock_acquire+0x2a07/0x54a0 kernel/locking/lockdep.c:5015
 lock_acquire kernel/locking/lockdep.c:5625 [inline]
 lock_acquire+0x1ab/0x510 kernel/locking/lockdep.c:5590
 __mutex_lock_common kernel/locking/mutex.c:596 [inline]
 __mutex_lock+0x131/0x12f0 kernel/locking/mutex.c:729
 io_register_iowq_max_workers fs/io_uring.c:10551 [inline]
 __io_uring_register fs/io_uring.c:10757 [inline]
 __do_sys_io_uring_register+0x10aa/0x2e70 fs/io_uring.c:10792
 do_syscall_x64 arch/x86/entry/common.c:50 [inline]
 do_syscall_64+0x35/0xb0 arch/x86/entry/common.c:80
 entry_SYSCALL_64_after_hwframe+0x44/0xae
RIP: 0033:0x4665f9
Code: ff ff c3 66 2e 0f 1f 84 00 00 00 00 00 0f 1f 40 00 48 89 f8 48 89 f7 48 89 d6 48 89 ca 4d 89 c2 4d 89 c8 4c 8b 4c 24 08 0f 05 <48> 3d 01 f0 ff ff 73 01 c3 48 c7 c1 bc ff ff ff f7 d8 64 89 01 48
RSP: 002b:00007f2de4e18188 EFLAGS: 00000246 ORIG_RAX: 00000000000001ab
RAX: ffffffffffffffda RBX: 000000000056bf80 RCX: 00000000004665f9
RDX: 0000000020000140 RSI: 0000000000000013 RDI: 0000000000000005
RBP: 00000000004bfcc4 R08: 0000000000000000 R09: 0000000000000000
R10: 0000000000000002 R11: 0000000000000246 R12: 000000000056bf80
R13: 00007ffe0e2af47f R14: 00007f2de4e18300 R15: 0000000000022000


---
This report is generated by a bot. It may contain errors.
See https://goo.gl/tpsmEJ for more information about syzbot.
syzbot engineers can be reached at syzkaller@googlegroups.com.

syzbot will keep track of this issue. See:
https://goo.gl/tpsmEJ#status for how to communicate with syzbot.
