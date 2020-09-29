Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 2CDD927BFAE
	for <lists+io-uring@lfdr.de>; Tue, 29 Sep 2020 10:37:40 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1725554AbgI2Ih1 (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Tue, 29 Sep 2020 04:37:27 -0400
Received: from mail-il1-f206.google.com ([209.85.166.206]:45824 "EHLO
        mail-il1-f206.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727704AbgI2IhY (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Tue, 29 Sep 2020 04:37:24 -0400
Received: by mail-il1-f206.google.com with SMTP id p10so808536ilc.12
        for <io-uring@vger.kernel.org>; Tue, 29 Sep 2020 01:37:22 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:date:message-id:subject:from:to;
        bh=3LRSjGGqkPX5mBDw4mbslhAYvjhu1Sv4cLBuwz6kq00=;
        b=DUTdmSIVVaDyag/rhZCi0CypDZGxRBu83MlhoHdpi1JgjRi3ba+VvzG4HcRfJIE2NZ
         WaOWhpCDNpTznoQWPHWfOM6nR++gsW6OOcKgy/VnK9lZMo4YBxAK+JrCO27Ehw0tK1OV
         nNZiszryKfzN93l6roxXJvinZSkUZgwcpXPjkp7YDTmsiT/1+GUG98NhVSWqEf+0hJ4o
         82AUZsrvckr4opyqE7DKnZuZYDFeH1YR8f36e+qKp/OIcp+4aa8WT/YJQTe8yU5H6vXn
         7ExxnJOA0haw9XRJ7oD+XTB4UFjcTQ6036p7wld97MC9qHVhyHgsvVLb5NVRpPT8za3G
         cFiQ==
X-Gm-Message-State: AOAM531r4biuGwRt2ZrPv7l71eEMUu9P1P5mcw76OYOgjIMcS1K8xXSM
        Ap3rBmcnqJTmVY0lcF9BbZ2W1R2RmC3XUCqn4SeCW2ez+mth
X-Google-Smtp-Source: ABdhPJxK8JK3IBXCwghWxVbHlJ1u3zVM53Aa44DCW7UrsCEywttQQPK4lIjQ6dtUlBiXblZ0SBPRMqTIDjD2GNwUkwHvrmYbtjj0
MIME-Version: 1.0
X-Received: by 2002:a02:62c9:: with SMTP id d192mr2097122jac.59.1601368641644;
 Tue, 29 Sep 2020 01:37:21 -0700 (PDT)
Date:   Tue, 29 Sep 2020 01:37:21 -0700
X-Google-Appengine-App-Id: s~syzkaller
X-Google-Appengine-App-Id-Alias: syzkaller
Message-ID: <0000000000000a315605b06fb13c@google.com>
Subject: possible deadlock in io_uring_show_fdinfo
From:   syzbot <syzbot+d8076141c9af9baf6304@syzkaller.appspotmail.com>
To:     axboe@kernel.dk, io-uring@vger.kernel.org,
        linux-fsdevel@vger.kernel.org, linux-kernel@vger.kernel.org,
        syzkaller-bugs@googlegroups.com, viro@zeniv.linux.org.uk
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org

Hello,

syzbot found the following issue on:

HEAD commit:    fb0155a0 Merge tag 'nfs-for-5.9-3' of git://git.linux-nfs...
git tree:       upstream
console output: https://syzkaller.appspot.com/x/log.txt?x=109bf9e3900000
kernel config:  https://syzkaller.appspot.com/x/.config?x=adebb40048274f92
dashboard link: https://syzkaller.appspot.com/bug?extid=d8076141c9af9baf6304
compiler:       clang version 10.0.0 (https://github.com/llvm/llvm-project/ c2443155a0fb245c8f17f2c1c72b6ea391e86e81)

Unfortunately, I don't have any reproducer for this issue yet.

IMPORTANT: if you fix the issue, please add the following tag to the commit:
Reported-by: syzbot+d8076141c9af9baf6304@syzkaller.appspotmail.com

======================================================
WARNING: possible circular locking dependency detected
5.9.0-rc7-syzkaller #0 Not tainted
------------------------------------------------------
syz-executor.3/10475 is trying to acquire lock:
ffff8880a1a23428 (&ctx->uring_lock){+.+.}-{3:3}, at: __io_uring_show_fdinfo fs/io_uring.c:8417 [inline]
ffff8880a1a23428 (&ctx->uring_lock){+.+.}-{3:3}, at: io_uring_show_fdinfo+0x6c/0x790 fs/io_uring.c:8460

but task is already holding lock:
ffff888089039668 (&p->lock){+.+.}-{3:3}, at: seq_read+0x60/0xce0 fs/seq_file.c:155

which lock already depends on the new lock.


the existing dependency chain (in reverse order) is:

-> #2 (&p->lock){+.+.}-{3:3}:
       lock_acquire+0x148/0x720 kernel/locking/lockdep.c:5029
       __mutex_lock_common+0x189/0x2fc0 kernel/locking/mutex.c:956
       __mutex_lock kernel/locking/mutex.c:1103 [inline]
       mutex_lock_nested+0x1a/0x20 kernel/locking/mutex.c:1118
       seq_read+0x60/0xce0 fs/seq_file.c:155
       do_loop_readv_writev fs/read_write.c:734 [inline]
       do_iter_read+0x438/0x620 fs/read_write.c:955
       vfs_readv+0xc2/0x120 fs/read_write.c:1073
       kernel_readv fs/splice.c:355 [inline]
       default_file_splice_read+0x579/0xa40 fs/splice.c:412
       do_splice_to fs/splice.c:871 [inline]
       splice_direct_to_actor+0x3de/0xb60 fs/splice.c:950
       do_splice_direct+0x201/0x340 fs/splice.c:1059
       do_sendfile+0x86d/0x1210 fs/read_write.c:1540
       __do_sys_sendfile64 fs/read_write.c:1601 [inline]
       __se_sys_sendfile64 fs/read_write.c:1587 [inline]
       __x64_sys_sendfile64+0x164/0x1a0 fs/read_write.c:1587
       do_syscall_64+0x31/0x70 arch/x86/entry/common.c:46
       entry_SYSCALL_64_after_hwframe+0x44/0xa9

-> #1 (sb_writers#4){.+.+}-{0:0}:
       lock_acquire+0x148/0x720 kernel/locking/lockdep.c:5029
       percpu_down_read include/linux/percpu-rwsem.h:51 [inline]
       __sb_start_write+0x14b/0x400 fs/super.c:1672
       io_write+0x50f/0x1230 fs/io_uring.c:3294
       io_issue_sqe+0x34fe/0xc1a0 fs/io_uring.c:5722
       __io_queue_sqe+0x297/0x1310 fs/io_uring.c:6178
       io_submit_sqe fs/io_uring.c:6327 [inline]
       io_submit_sqes+0x149f/0x2570 fs/io_uring.c:6521
       __do_sys_io_uring_enter fs/io_uring.c:8349 [inline]
       __se_sys_io_uring_enter+0x1af/0x1300 fs/io_uring.c:8308
       do_syscall_64+0x31/0x70 arch/x86/entry/common.c:46
       entry_SYSCALL_64_after_hwframe+0x44/0xa9

-> #0 (&ctx->uring_lock){+.+.}-{3:3}:
       check_prev_add kernel/locking/lockdep.c:2496 [inline]
       check_prevs_add kernel/locking/lockdep.c:2601 [inline]
       validate_chain+0x1b0c/0x88a0 kernel/locking/lockdep.c:3218
       __lock_acquire+0x110b/0x2ae0 kernel/locking/lockdep.c:4441
       lock_acquire+0x148/0x720 kernel/locking/lockdep.c:5029
       __mutex_lock_common+0x189/0x2fc0 kernel/locking/mutex.c:956
       __mutex_lock kernel/locking/mutex.c:1103 [inline]
       mutex_lock_nested+0x1a/0x20 kernel/locking/mutex.c:1118
       __io_uring_show_fdinfo fs/io_uring.c:8417 [inline]
       io_uring_show_fdinfo+0x6c/0x790 fs/io_uring.c:8460
       seq_show+0x567/0x620 fs/proc/fd.c:65
       seq_read+0x41a/0xce0 fs/seq_file.c:208
       do_loop_readv_writev fs/read_write.c:734 [inline]
       do_iter_read+0x438/0x620 fs/read_write.c:955
       vfs_readv+0xc2/0x120 fs/read_write.c:1073
       kernel_readv fs/splice.c:355 [inline]
       default_file_splice_read+0x579/0xa40 fs/splice.c:412
       do_splice_to fs/splice.c:871 [inline]
       splice_direct_to_actor+0x3de/0xb60 fs/splice.c:950
       do_splice_direct+0x201/0x340 fs/splice.c:1059
       do_sendfile+0x86d/0x1210 fs/read_write.c:1540
       __do_sys_sendfile64 fs/read_write.c:1601 [inline]
       __se_sys_sendfile64 fs/read_write.c:1587 [inline]
       __x64_sys_sendfile64+0x164/0x1a0 fs/read_write.c:1587
       do_syscall_64+0x31/0x70 arch/x86/entry/common.c:46
       entry_SYSCALL_64_after_hwframe+0x44/0xa9

other info that might help us debug this:

Chain exists of:
  &ctx->uring_lock --> sb_writers#4 --> &p->lock

 Possible unsafe locking scenario:

       CPU0                    CPU1
       ----                    ----
  lock(&p->lock);
                               lock(sb_writers#4);
                               lock(&p->lock);
  lock(&ctx->uring_lock);

 *** DEADLOCK ***

2 locks held by syz-executor.3/10475:
 #0: ffff88821407a450 (sb_writers#4){.+.+}-{0:0}, at: file_start_write include/linux/fs.h:2783 [inline]
 #0: ffff88821407a450 (sb_writers#4){.+.+}-{0:0}, at: do_sendfile+0x83b/0x1210 fs/read_write.c:1539
 #1: ffff888089039668 (&p->lock){+.+.}-{3:3}, at: seq_read+0x60/0xce0 fs/seq_file.c:155

stack backtrace:
CPU: 0 PID: 10475 Comm: syz-executor.3 Not tainted 5.9.0-rc7-syzkaller #0
Hardware name: Google Google Compute Engine/Google Compute Engine, BIOS Google 01/01/2011
Call Trace:
 __dump_stack lib/dump_stack.c:77 [inline]
 dump_stack+0x1d6/0x29e lib/dump_stack.c:118
 print_circular_bug+0xc72/0xea0 kernel/locking/lockdep.c:1703
 check_noncircular+0x1fb/0x3a0 kernel/locking/lockdep.c:1827
 check_prev_add kernel/locking/lockdep.c:2496 [inline]
 check_prevs_add kernel/locking/lockdep.c:2601 [inline]
 validate_chain+0x1b0c/0x88a0 kernel/locking/lockdep.c:3218
 __lock_acquire+0x110b/0x2ae0 kernel/locking/lockdep.c:4441
 lock_acquire+0x148/0x720 kernel/locking/lockdep.c:5029
 __mutex_lock_common+0x189/0x2fc0 kernel/locking/mutex.c:956
 __mutex_lock kernel/locking/mutex.c:1103 [inline]
 mutex_lock_nested+0x1a/0x20 kernel/locking/mutex.c:1118
 __io_uring_show_fdinfo fs/io_uring.c:8417 [inline]
 io_uring_show_fdinfo+0x6c/0x790 fs/io_uring.c:8460
 seq_show+0x567/0x620 fs/proc/fd.c:65
 seq_read+0x41a/0xce0 fs/seq_file.c:208
 do_loop_readv_writev fs/read_write.c:734 [inline]
 do_iter_read+0x438/0x620 fs/read_write.c:955
 vfs_readv+0xc2/0x120 fs/read_write.c:1073
 kernel_readv fs/splice.c:355 [inline]
 default_file_splice_read+0x579/0xa40 fs/splice.c:412
 do_splice_to fs/splice.c:871 [inline]
 splice_direct_to_actor+0x3de/0xb60 fs/splice.c:950
 do_splice_direct+0x201/0x340 fs/splice.c:1059
 do_sendfile+0x86d/0x1210 fs/read_write.c:1540
 __do_sys_sendfile64 fs/read_write.c:1601 [inline]
 __se_sys_sendfile64 fs/read_write.c:1587 [inline]
 __x64_sys_sendfile64+0x164/0x1a0 fs/read_write.c:1587
 do_syscall_64+0x31/0x70 arch/x86/entry/common.c:46
 entry_SYSCALL_64_after_hwframe+0x44/0xa9
RIP: 0033:0x45dd99
Code: 0d b4 fb ff c3 66 2e 0f 1f 84 00 00 00 00 00 66 90 48 89 f8 48 89 f7 48 89 d6 48 89 ca 4d 89 c2 4d 89 c8 4c 8b 4c 24 08 0f 05 <48> 3d 01 f0 ff ff 0f 83 db b3 fb ff c3 66 2e 0f 1f 84 00 00 00 00
RSP: 002b:00007f3edfb2ec78 EFLAGS: 00000246 ORIG_RAX: 0000000000000028
RAX: ffffffffffffffda RBX: 0000000000027ec0 RCX: 000000000045dd99
RDX: 0000000000000000 RSI: 0000000000000009 RDI: 000000000000000a
RBP: 000000000118bf68 R08: 0000000000000000 R09: 0000000000000000
R10: 0000000000000208 R11: 0000000000000246 R12: 000000000118bf2c
R13: 00007ffe7ad0078f R14: 00007f3edfb2f9c0 R15: 000000000118bf2c


---
This report is generated by a bot. It may contain errors.
See https://goo.gl/tpsmEJ for more information about syzbot.
syzbot engineers can be reached at syzkaller@googlegroups.com.

syzbot will keep track of this issue. See:
https://goo.gl/tpsmEJ#status for how to communicate with syzbot.
