Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id C9CC927A864
	for <lists+io-uring@lfdr.de>; Mon, 28 Sep 2020 09:17:57 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726500AbgI1HRh (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Mon, 28 Sep 2020 03:17:37 -0400
Received: from mail-io1-f77.google.com ([209.85.166.77]:45195 "EHLO
        mail-io1-f77.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726547AbgI1HR0 (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Mon, 28 Sep 2020 03:17:26 -0400
Received: by mail-io1-f77.google.com with SMTP id h21so98352iof.12
        for <io-uring@vger.kernel.org>; Mon, 28 Sep 2020 00:17:25 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:date:message-id:subject:from:to;
        bh=XbPuch1ZotLQyYuXlwTI1LGYIWVJyxJ84pFPhbD6uyI=;
        b=GjPVIYAs7Og/SbjUzn7j5fxpjnBxoHp8Cm/AljsXQumAPpm8q10l4Va+2LTyAeOlO1
         KdAWfdf/+yOJ5vVLjSsquBSF6i/8uJBC4fb/GZgIdiZIZ8/V+IHlz3uCukt8TaM3m7qJ
         JkUrVP1rxpuoYqrTrqv1NnDJzNpYF1WhSR43T/LVvhvyiqHGyyrWpmp+CkilB229c9aR
         XGu6d0veUMqQxHlKjHPLTaj5LvWQwtmREUZxeaTc3mFbVw+od38/XbfLQIzUD+6KTdG9
         PSS3nA1eQ/I4hi3FpDeW+N6c+q/fyqyLdXyEBMBhANjiObWWH0bGZ4+XKgzhlah4zY8z
         pGHg==
X-Gm-Message-State: AOAM5333fwwwYlnU4pzc+dWnqd8S7JPHKYKw8oXLGNJdQhcTzpoCwW3s
        IdqaG+4bNJbPGozkXIN0JHyJ16JhvlZkirEo8yFStsR7s44b
X-Google-Smtp-Source: ABdhPJyChCnLT+cKsSlDlT8aiZZa/myOgUNdCCATPU5nHYLGF/QEZx2D+Lpp5YJ+nao4wb44tZ6nd6D940VZyHnulusvdeQwdMW4
MIME-Version: 1.0
X-Received: by 2002:a92:d07:: with SMTP id 7mr51097iln.243.1601277445316; Mon,
 28 Sep 2020 00:17:25 -0700 (PDT)
Date:   Mon, 28 Sep 2020 00:17:25 -0700
X-Google-Appengine-App-Id: s~syzkaller
X-Google-Appengine-App-Id-Alias: syzkaller
Message-ID: <00000000000050a4fd05b05a7579@google.com>
Subject: possible deadlock in io_write
From:   syzbot <syzbot+2f8fa4e860edc3066aba@syzkaller.appspotmail.com>
To:     axboe@kernel.dk, io-uring@vger.kernel.org,
        linux-fsdevel@vger.kernel.org, linux-kernel@vger.kernel.org,
        syzkaller-bugs@googlegroups.com, viro@zeniv.linux.org.uk
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org

Hello,

syzbot found the following issue on:

HEAD commit:    eeddbe68 Merge tag 's390-5.9-7' of git://git.kernel.org/pu..
git tree:       upstream
console output: https://syzkaller.appspot.com/x/log.txt?x=148c13d3900000
kernel config:  https://syzkaller.appspot.com/x/.config?x=240e2ebab67245c7
dashboard link: https://syzkaller.appspot.com/bug?extid=2f8fa4e860edc3066aba
compiler:       gcc (GCC) 10.1.0-syz 20200507

Unfortunately, I don't have any reproducer for this issue yet.

IMPORTANT: if you fix the issue, please add the following tag to the commit:
Reported-by: syzbot+2f8fa4e860edc3066aba@syzkaller.appspotmail.com

======================================================
WARNING: possible circular locking dependency detected
5.9.0-rc6-syzkaller #0 Not tainted
------------------------------------------------------
syz-executor.2/19710 is trying to acquire lock:
ffff888098ddc450 (sb_writers#4){.+.+}-{0:0}, at: io_write+0x6b5/0xb30 fs/io_uring.c:3296

but task is already holding lock:
ffff8880a11b8428 (&ctx->uring_lock){+.+.}-{3:3}, at: __do_sys_io_uring_enter+0xe9a/0x1bd0 fs/io_uring.c:8348

which lock already depends on the new lock.


the existing dependency chain (in reverse order) is:

-> #2 (&ctx->uring_lock){+.+.}-{3:3}:
       __mutex_lock_common kernel/locking/mutex.c:956 [inline]
       __mutex_lock+0x134/0x10e0 kernel/locking/mutex.c:1103
       __io_uring_show_fdinfo fs/io_uring.c:8417 [inline]
       io_uring_show_fdinfo+0x194/0xc70 fs/io_uring.c:8460
       seq_show+0x4a8/0x700 fs/proc/fd.c:65
       seq_read+0x432/0x1070 fs/seq_file.c:208
       do_loop_readv_writev fs/read_write.c:734 [inline]
       do_loop_readv_writev fs/read_write.c:721 [inline]
       do_iter_read+0x48e/0x6e0 fs/read_write.c:955
       vfs_readv+0xe5/0x150 fs/read_write.c:1073
       kernel_readv fs/splice.c:355 [inline]
       default_file_splice_read.constprop.0+0x4e6/0x9e0 fs/splice.c:412
       do_splice_to+0x137/0x170 fs/splice.c:871
       splice_direct_to_actor+0x307/0x980 fs/splice.c:950
       do_splice_direct+0x1b3/0x280 fs/splice.c:1059
       do_sendfile+0x55f/0xd40 fs/read_write.c:1540
       __do_sys_sendfile64 fs/read_write.c:1601 [inline]
       __se_sys_sendfile64 fs/read_write.c:1587 [inline]
       __x64_sys_sendfile64+0x1cc/0x210 fs/read_write.c:1587
       do_syscall_64+0x2d/0x70 arch/x86/entry/common.c:46
       entry_SYSCALL_64_after_hwframe+0x44/0xa9

-> #1 (&p->lock){+.+.}-{3:3}:
       __mutex_lock_common kernel/locking/mutex.c:956 [inline]
       __mutex_lock+0x134/0x10e0 kernel/locking/mutex.c:1103
       seq_read+0x61/0x1070 fs/seq_file.c:155
       pde_read fs/proc/inode.c:306 [inline]
       proc_reg_read+0x221/0x300 fs/proc/inode.c:318
       do_loop_readv_writev fs/read_write.c:734 [inline]
       do_loop_readv_writev fs/read_write.c:721 [inline]
       do_iter_read+0x48e/0x6e0 fs/read_write.c:955
       vfs_readv+0xe5/0x150 fs/read_write.c:1073
       kernel_readv fs/splice.c:355 [inline]
       default_file_splice_read.constprop.0+0x4e6/0x9e0 fs/splice.c:412
       do_splice_to+0x137/0x170 fs/splice.c:871
       splice_direct_to_actor+0x307/0x980 fs/splice.c:950
       do_splice_direct+0x1b3/0x280 fs/splice.c:1059
       do_sendfile+0x55f/0xd40 fs/read_write.c:1540
       __do_sys_sendfile64 fs/read_write.c:1601 [inline]
       __se_sys_sendfile64 fs/read_write.c:1587 [inline]
       __x64_sys_sendfile64+0x1cc/0x210 fs/read_write.c:1587
       do_syscall_64+0x2d/0x70 arch/x86/entry/common.c:46
       entry_SYSCALL_64_after_hwframe+0x44/0xa9

-> #0 (sb_writers#4){.+.+}-{0:0}:
       check_prev_add kernel/locking/lockdep.c:2496 [inline]
       check_prevs_add kernel/locking/lockdep.c:2601 [inline]
       validate_chain kernel/locking/lockdep.c:3218 [inline]
       __lock_acquire+0x2a96/0x5780 kernel/locking/lockdep.c:4441
       lock_acquire+0x1f3/0xaf0 kernel/locking/lockdep.c:5029
       percpu_down_read include/linux/percpu-rwsem.h:51 [inline]
       __sb_start_write+0x228/0x450 fs/super.c:1672
       io_write+0x6b5/0xb30 fs/io_uring.c:3296
       io_issue_sqe+0x18f/0x5c50 fs/io_uring.c:5719
       __io_queue_sqe+0x280/0x1160 fs/io_uring.c:6175
       io_queue_sqe+0x692/0xfa0 fs/io_uring.c:6254
       io_submit_sqe fs/io_uring.c:6324 [inline]
       io_submit_sqes+0x1761/0x2400 fs/io_uring.c:6521
       __do_sys_io_uring_enter+0xeac/0x1bd0 fs/io_uring.c:8349
       do_syscall_64+0x2d/0x70 arch/x86/entry/common.c:46
       entry_SYSCALL_64_after_hwframe+0x44/0xa9

other info that might help us debug this:

Chain exists of:
  sb_writers#4 --> &p->lock --> &ctx->uring_lock

 Possible unsafe locking scenario:

       CPU0                    CPU1
       ----                    ----
  lock(&ctx->uring_lock);
                               lock(&p->lock);
                               lock(&ctx->uring_lock);
  lock(sb_writers#4);

 *** DEADLOCK ***

1 lock held by syz-executor.2/19710:
 #0: ffff8880a11b8428 (&ctx->uring_lock){+.+.}-{3:3}, at: __do_sys_io_uring_enter+0xe9a/0x1bd0 fs/io_uring.c:8348

stack backtrace:
CPU: 0 PID: 19710 Comm: syz-executor.2 Not tainted 5.9.0-rc6-syzkaller #0
Hardware name: Google Google Compute Engine/Google Compute Engine, BIOS Google 01/01/2011
Call Trace:
 __dump_stack lib/dump_stack.c:77 [inline]
 dump_stack+0x198/0x1fd lib/dump_stack.c:118
 check_noncircular+0x324/0x3e0 kernel/locking/lockdep.c:1827
 check_prev_add kernel/locking/lockdep.c:2496 [inline]
 check_prevs_add kernel/locking/lockdep.c:2601 [inline]
 validate_chain kernel/locking/lockdep.c:3218 [inline]
 __lock_acquire+0x2a96/0x5780 kernel/locking/lockdep.c:4441
 lock_acquire+0x1f3/0xaf0 kernel/locking/lockdep.c:5029
 percpu_down_read include/linux/percpu-rwsem.h:51 [inline]
 __sb_start_write+0x228/0x450 fs/super.c:1672
 io_write+0x6b5/0xb30 fs/io_uring.c:3296
 io_issue_sqe+0x18f/0x5c50 fs/io_uring.c:5719
 __io_queue_sqe+0x280/0x1160 fs/io_uring.c:6175
 io_queue_sqe+0x692/0xfa0 fs/io_uring.c:6254
 io_submit_sqe fs/io_uring.c:6324 [inline]
 io_submit_sqes+0x1761/0x2400 fs/io_uring.c:6521
 __do_sys_io_uring_enter+0xeac/0x1bd0 fs/io_uring.c:8349
 do_syscall_64+0x2d/0x70 arch/x86/entry/common.c:46
 entry_SYSCALL_64_after_hwframe+0x44/0xa9
RIP: 0033:0x45e179
Code: 3d b2 fb ff c3 66 2e 0f 1f 84 00 00 00 00 00 66 90 48 89 f8 48 89 f7 48 89 d6 48 89 ca 4d 89 c2 4d 89 c8 4c 8b 4c 24 08 0f 05 <48> 3d 01 f0 ff ff 0f 83 0b b2 fb ff c3 66 2e 0f 1f 84 00 00 00 00
RSP: 002b:00007f1194e74c78 EFLAGS: 00000246 ORIG_RAX: 00000000000001aa
RAX: ffffffffffffffda RBX: 00000000000082c0 RCX: 000000000045e179
RDX: 0000000000000000 RSI: 0000000000000001 RDI: 0000000000000004
RBP: 000000000118cf98 R08: 0000000000000000 R09: 0000000000000000
R10: 0000000000000000 R11: 0000000000000246 R12: 000000000118cf4c
R13: 00007ffd1aa5756f R14: 00007f1194e759c0 R15: 000000000118cf4c


---
This report is generated by a bot. It may contain errors.
See https://goo.gl/tpsmEJ for more information about syzbot.
syzbot engineers can be reached at syzkaller@googlegroups.com.

syzbot will keep track of this issue. See:
https://goo.gl/tpsmEJ#status for how to communicate with syzbot.
