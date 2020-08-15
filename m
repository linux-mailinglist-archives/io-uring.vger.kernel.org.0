Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 8C4302452F1
	for <lists+io-uring@lfdr.de>; Sat, 15 Aug 2020 23:56:50 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726587AbgHOV4c (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Sat, 15 Aug 2020 17:56:32 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:45636 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1729033AbgHOVwN (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Sat, 15 Aug 2020 17:52:13 -0400
Received: from mail-il1-x145.google.com (mail-il1-x145.google.com [IPv6:2607:f8b0:4864:20::145])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 7E3E0C0F26E9
        for <io-uring@vger.kernel.org>; Sat, 15 Aug 2020 11:09:18 -0700 (PDT)
Received: by mail-il1-x145.google.com with SMTP id k8so5081407ili.21
        for <io-uring@vger.kernel.org>; Sat, 15 Aug 2020 11:09:18 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:date:message-id:subject:from:to;
        bh=unqY6YUA6dN15yzdjEHwLUsw603J7sn/Dlnt+ztMhZk=;
        b=BzzAxLqK4aleMkYITIKN4JIDc+KRcqSqq0HVjUsZIZKtD1Az5GKa935zZNpg+vJibx
         Mi9EBIIqEYWdRTUnvlNTZVGkknwDfOLdWsBpIdzBwlG+aoroV+qEjWromfndphqR40wg
         auPFh7MYnVzUtZnSAMm7nOQKba0720lbNfjz5jx5knioyqWKObGgd+XtkZozqCoAXkfE
         cvXymtq9u9Rv0hgbWtYY/8NPBDXr6us5mbCvG1/0UllLqStalBlQzeuV3oN0N+69RB9R
         SPR7/7BOiWzOdAk0ujMKI1LmDdjmTHZUky22KklJSieClOgPol8Dq97rOW1Y0hZBU5Pa
         kFfw==
X-Gm-Message-State: AOAM5315kwYGnmMN/GlOwcBosaPfWO2T6XttK7hJPwUKpnzdu0LwvCKs
        W24dzzmsuvb0ZzRdsaHwibS+SveV1tI8X0r9FKnKhHwzIki/
X-Google-Smtp-Source: ABdhPJyo0N5X3Rr63x6KSCF9oemLGrgNQNTncv3rJKuvDN2i4ehbpeDid+q3ScpJ7466Pv+uSxM9s3V5J1KUjpfsGtCJJtdgE45x
MIME-Version: 1.0
X-Received: by 2002:a92:bf0c:: with SMTP id z12mr7149150ilh.151.1597514957600;
 Sat, 15 Aug 2020 11:09:17 -0700 (PDT)
Date:   Sat, 15 Aug 2020 11:09:17 -0700
X-Google-Appengine-App-Id: s~syzkaller
X-Google-Appengine-App-Id-Alias: syzkaller
Message-ID: <000000000000923cee05acee6f61@google.com>
Subject: possible deadlock in io_poll_double_wake
From:   syzbot <syzbot+0d56cfeec64f045baffc@syzkaller.appspotmail.com>
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

HEAD commit:    c9c9735c Merge tag 'scsi-misc' of git://git.kernel.org/pub..
git tree:       upstream
console output: https://syzkaller.appspot.com/x/log.txt?x=127399f6900000
kernel config:  https://syzkaller.appspot.com/x/.config?x=adea84f38e7bc8d
dashboard link: https://syzkaller.appspot.com/bug?extid=0d56cfeec64f045baffc
compiler:       clang version 10.0.0 (https://github.com/llvm/llvm-project/ c2443155a0fb245c8f17f2c1c72b6ea391e86e81)

Unfortunately, I don't have any reproducer for this issue yet.

IMPORTANT: if you fix the issue, please add the following tag to the commit:
Reported-by: syzbot+0d56cfeec64f045baffc@syzkaller.appspotmail.com

============================================
WARNING: possible recursive locking detected
5.8.0-syzkaller #0 Not tainted
--------------------------------------------
syz-executor.1/9155 is trying to acquire lock:
ffff8880a1fcc530 (&tty->write_wait){-.-.}-{2:2}, at: spin_lock include/linux/spinlock.h:354 [inline]
ffff8880a1fcc530 (&tty->write_wait){-.-.}-{2:2}, at: io_poll_double_wake+0x108/0x360 fs/io_uring.c:4599

but task is already holding lock:
ffff8880a1fcc530 (&tty->write_wait){-.-.}-{2:2}, at: __wake_up_common_lock kernel/sched/wait.c:122 [inline]
ffff8880a1fcc530 (&tty->write_wait){-.-.}-{2:2}, at: __wake_up+0xb8/0x150 kernel/sched/wait.c:142

other info that might help us debug this:
 Possible unsafe locking scenario:

       CPU0
       ----
  lock(&tty->write_wait);
  lock(&tty->write_wait);

 *** DEADLOCK ***

 May be due to missing lock nesting notation

4 locks held by syz-executor.1/9155:
 #0: ffff8880a1fcc098 (&tty->ldisc_sem){++++}-{0:0}, at: tty_ldisc_ref_wait+0x21/0x70 drivers/tty/tty_ldisc.c:267
 #1: ffff8880a1fcc2e8 (&tty->termios_rwsem){++++}-{3:3}, at: tty_set_termios+0xc5/0x1510 drivers/tty/tty_ioctl.c:328
 #2: ffff8880a1fcc098 (&tty->ldisc_sem){++++}-{0:0}, at: tty_ldisc_ref+0x18/0x80 drivers/tty/tty_ldisc.c:288
 #3: ffff8880a1fcc530 (&tty->write_wait){-.-.}-{2:2}, at: __wake_up_common_lock kernel/sched/wait.c:122 [inline]
 #3: ffff8880a1fcc530 (&tty->write_wait){-.-.}-{2:2}, at: __wake_up+0xb8/0x150 kernel/sched/wait.c:142

stack backtrace:
CPU: 0 PID: 9155 Comm: syz-executor.1 Not tainted 5.8.0-syzkaller #0
Hardware name: Google Google Compute Engine/Google Compute Engine, BIOS Google 01/01/2011
Call Trace:
 __dump_stack lib/dump_stack.c:77 [inline]
 dump_stack+0x1f0/0x31e lib/dump_stack.c:118
 print_deadlock_bug kernel/locking/lockdep.c:2391 [inline]
 check_deadlock kernel/locking/lockdep.c:2432 [inline]
 validate_chain+0x69a4/0x88a0 kernel/locking/lockdep.c:3202
 __lock_acquire+0x1161/0x2ab0 kernel/locking/lockdep.c:4426
 lock_acquire+0x160/0x730 kernel/locking/lockdep.c:5005
 __raw_spin_lock include/linux/spinlock_api_smp.h:142 [inline]
 _raw_spin_lock+0x2a/0x40 kernel/locking/spinlock.c:151
 spin_lock include/linux/spinlock.h:354 [inline]
 io_poll_double_wake+0x108/0x360 fs/io_uring.c:4599
 __wake_up_common+0x30a/0x4e0 kernel/sched/wait.c:93
 __wake_up_common_lock kernel/sched/wait.c:123 [inline]
 __wake_up+0xd4/0x150 kernel/sched/wait.c:142
 n_tty_set_termios+0xa60/0x1080 drivers/tty/n_tty.c:1874
 tty_set_termios+0xcac/0x1510 drivers/tty/tty_ioctl.c:341
 set_termios+0x4a1/0x580 drivers/tty/tty_ioctl.c:414
 tty_mode_ioctl+0x7b2/0xa80 drivers/tty/tty_ioctl.c:770
 tty_ioctl+0xf81/0x15c0 drivers/tty/tty_io.c:2665
 vfs_ioctl fs/ioctl.c:48 [inline]
 __do_sys_ioctl fs/ioctl.c:753 [inline]
 __se_sys_ioctl+0xfb/0x170 fs/ioctl.c:739
 do_syscall_64+0x31/0x70 arch/x86/entry/common.c:46
 entry_SYSCALL_64_after_hwframe+0x44/0xa9
RIP: 0033:0x45d239
Code: 5d b4 fb ff c3 66 2e 0f 1f 84 00 00 00 00 00 66 90 48 89 f8 48 89 f7 48 89 d6 48 89 ca 4d 89 c2 4d 89 c8 4c 8b 4c 24 08 0f 05 <48> 3d 01 f0 ff ff 0f 83 2b b4 fb ff c3 66 2e 0f 1f 84 00 00 00 00
RSP: 002b:00007f063db5fc78 EFLAGS: 00000246 ORIG_RAX: 0000000000000010
RAX: ffffffffffffffda RBX: 0000000000017cc0 RCX: 000000000045d239
RDX: 0000000020000000 RSI: 0000000000005404 RDI: 0000000000000003
RBP: 000000000118cf80 R08: 0000000000000000 R09: 0000000000000000
R10: 0000000000000000 R11: 0000000000000246 R12: 000000000118cf4c
R13: 00007ffc7ff6341f R14: 00007f063db609c0 R15: 000000000118cf4c


---
This report is generated by a bot. It may contain errors.
See https://goo.gl/tpsmEJ for more information about syzbot.
syzbot engineers can be reached at syzkaller@googlegroups.com.

syzbot will keep track of this issue. See:
https://goo.gl/tpsmEJ#status for how to communicate with syzbot.
