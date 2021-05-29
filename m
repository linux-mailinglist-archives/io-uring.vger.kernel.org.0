Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 73C3C394AC5
	for <lists+io-uring@lfdr.de>; Sat, 29 May 2021 08:33:18 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229679AbhE2Gew (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Sat, 29 May 2021 02:34:52 -0400
Received: from mail-il1-f200.google.com ([209.85.166.200]:35670 "EHLO
        mail-il1-f200.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229559AbhE2Gev (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Sat, 29 May 2021 02:34:51 -0400
Received: by mail-il1-f200.google.com with SMTP id n7-20020a056e021487b02901d29983f028so4161487ilk.2
        for <io-uring@vger.kernel.org>; Fri, 28 May 2021 23:33:16 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:date:message-id:subject:from:to;
        bh=WVZJnUAlwP86+Nc2TtM74BnEHSWsh0nAvTld31Kj4iY=;
        b=o/dTy2hlY6WKSvLj5Tddn0b9SqofLkOmPVbWF3eB9bcBxzRpUvNyuP6JDhWYXpSOTm
         RmBe/EenqaESTWV2PyUp1JDbC8yB2ac0twEa9y11jF1G3ajbLqoLDUqFhuscpniqWDRN
         vh/p+fqSx+qxSV3Ysdw25Eyp2h1EOrs8QdCYuyMVAal9DDkKkPVrV2j5ckgkDfWq+6IU
         ep00rpzqGPFMVv8eMkvz+pB9/3yAXnVvmGYOp1f/NfLwDoiEvXhSMa2pRUvjVQ5c8AjS
         qtGJtFBYtAV7P0C1hD/yUw2R6P6MyRtdQbcbKf82CtfEoBjdvEVO6BUINvZSIOVJIsmQ
         gO+A==
X-Gm-Message-State: AOAM532mZkVUajKGlr6wG78rN9vXZi4zA303o/Ua4GWAo/TU62I0UwZs
        Hyt2NbGvAxvE7MMVUB7Hj+Uwg0KXbXx/u2b7KXG8zRnTye25
X-Google-Smtp-Source: ABdhPJw++tRyQiRWMdyRmN9o4KBOqsTN6FIaKBk1ra3mhsuocGLdBPThKTuJzUNtPyXwqwW4EGJx3vsq/wWzW5K9kHvA/7Jxm233
MIME-Version: 1.0
X-Received: by 2002:a05:6638:1650:: with SMTP id a16mr11802842jat.23.1622269995698;
 Fri, 28 May 2021 23:33:15 -0700 (PDT)
Date:   Fri, 28 May 2021 23:33:15 -0700
X-Google-Appengine-App-Id: s~syzkaller
X-Google-Appengine-App-Id-Alias: syzkaller
Message-ID: <000000000000d2cdff05c3722a6c@google.com>
Subject: [syzbot] memory leak in io_submit_sqes (3)
From:   syzbot <syzbot+189b24ff132397acb8fd@syzkaller.appspotmail.com>
To:     asml.silence@gmail.com, axboe@kernel.dk, io-uring@vger.kernel.org,
        linux-kernel@vger.kernel.org, syzkaller-bugs@googlegroups.com
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org

Hello,

syzbot found the following issue on:

HEAD commit:    97e5bf60 Merge branch 'for-5.13-fixes' of git://git.kernel..
git tree:       upstream
console output: https://syzkaller.appspot.com/x/log.txt?x=17a782d3d00000
kernel config:  https://syzkaller.appspot.com/x/.config?x=b8c23f7848d1c696
dashboard link: https://syzkaller.appspot.com/bug?extid=189b24ff132397acb8fd
syz repro:      https://syzkaller.appspot.com/x/repro.syz?x=122ff517d00000
C reproducer:   https://syzkaller.appspot.com/x/repro.c?x=12cf7cb7d00000

IMPORTANT: if you fix the issue, please add the following tag to the commit:
Reported-by: syzbot+189b24ff132397acb8fd@syzkaller.appspotmail.com

executing program
BUG: memory leak
unreferenced object 0xffff888117747500 (size 232):
  comm "syz-executor793", pid 8437, jiffies 4294941760 (age 14.380s)
  hex dump (first 32 bytes):
    00 a2 11 02 81 88 ff ff 18 4e 6f 16 81 88 ff ff  .........No.....
    38 20 00 40 00 00 00 00 00 00 00 00 00 00 00 00  8 .@............
  backtrace:
    [<ffffffff81613299>] io_alloc_req fs/io_uring.c:1707 [inline]
    [<ffffffff81613299>] io_submit_sqes+0x6c9/0x23b0 fs/io_uring.c:6721
    [<ffffffff81615798>] __do_sys_io_uring_enter+0x818/0xf50 fs/io_uring.c:9319
    [<ffffffff8435309a>] do_syscall_64+0x3a/0xb0 arch/x86/entry/common.c:47
    [<ffffffff84400068>] entry_SYSCALL_64_after_hwframe+0x44/0xae

BUG: memory leak
unreferenced object 0xffff888117747400 (size 232):
  comm "syz-executor793", pid 8437, jiffies 4294941760 (age 14.380s)
  hex dump (first 32 bytes):
    00 a2 11 02 81 88 ff ff 18 4e 6f 16 81 88 ff ff  .........No.....
    38 20 00 40 00 00 00 00 00 00 00 00 00 00 00 00  8 .@............
  backtrace:
    [<ffffffff81613299>] io_alloc_req fs/io_uring.c:1707 [inline]
    [<ffffffff81613299>] io_submit_sqes+0x6c9/0x23b0 fs/io_uring.c:6721
    [<ffffffff81615798>] __do_sys_io_uring_enter+0x818/0xf50 fs/io_uring.c:9319
    [<ffffffff8435309a>] do_syscall_64+0x3a/0xb0 arch/x86/entry/common.c:47
    [<ffffffff84400068>] entry_SYSCALL_64_after_hwframe+0x44/0xae

BUG: memory leak
unreferenced object 0xffff888117747300 (size 232):
  comm "syz-executor793", pid 8437, jiffies 4294941760 (age 14.380s)
  hex dump (first 32 bytes):
    00 a2 11 02 81 88 ff ff 18 4e 6f 16 81 88 ff ff  .........No.....
    38 20 00 40 00 00 00 00 00 00 00 00 00 00 00 00  8 .@............
  backtrace:
    [<ffffffff81613299>] io_alloc_req fs/io_uring.c:1707 [inline]
    [<ffffffff81613299>] io_submit_sqes+0x6c9/0x23b0 fs/io_uring.c:6721
    [<ffffffff81615798>] __do_sys_io_uring_enter+0x818/0xf50 fs/io_uring.c:9319
    [<ffffffff8435309a>] do_syscall_64+0x3a/0xb0 arch/x86/entry/common.c:47
    [<ffffffff84400068>] entry_SYSCALL_64_after_hwframe+0x44/0xae

BUG: memory leak
unreferenced object 0xffff888117747200 (size 232):
  comm "syz-executor793", pid 8437, jiffies 4294941760 (age 14.380s)
  hex dump (first 32 bytes):
    00 a2 11 02 81 88 ff ff 18 4e 6f 16 81 88 ff ff  .........No.....
    38 20 00 40 00 00 00 00 00 00 00 00 00 00 00 00  8 .@............
  backtrace:
    [<ffffffff81613299>] io_alloc_req fs/io_uring.c:1707 [inline]
    [<ffffffff81613299>] io_submit_sqes+0x6c9/0x23b0 fs/io_uring.c:6721
    [<ffffffff81615798>] __do_sys_io_uring_enter+0x818/0xf50 fs/io_uring.c:9319
    [<ffffffff8435309a>] do_syscall_64+0x3a/0xb0 arch/x86/entry/common.c:47
    [<ffffffff84400068>] entry_SYSCALL_64_after_hwframe+0x44/0xae

BUG: memory leak
unreferenced object 0xffff888117747100 (size 232):
  comm "syz-executor793", pid 8437, jiffies 4294941760 (age 14.380s)
  hex dump (first 32 bytes):
    00 a2 11 02 81 88 ff ff 18 4e 6f 16 81 88 ff ff  .........No.....
    38 20 00 40 00 00 00 00 00 00 00 00 00 00 00 00  8 .@............
  backtrace:
    [<ffffffff81613299>] io_alloc_req fs/io_uring.c:1707 [inline]
    [<ffffffff81613299>] io_submit_sqes+0x6c9/0x23b0 fs/io_uring.c:6721
    [<ffffffff81615798>] __do_sys_io_uring_enter+0x818/0xf50 fs/io_uring.c:9319
    [<ffffffff8435309a>] do_syscall_64+0x3a/0xb0 arch/x86/entry/common.c:47
    [<ffffffff84400068>] entry_SYSCALL_64_after_hwframe+0x44/0xae

BUG: memory leak
unreferenced object 0xffff88811774acc0 (size 64):
  comm "syz-executor793", pid 8437, jiffies 4294941760 (age 14.380s)
  hex dump (first 32 bytes):
    00 00 00 00 00 00 00 00 00 4e 6f 16 81 88 ff ff  .........No.....
    38 20 00 40 00 00 00 00 00 00 00 00 00 00 00 00  8 .@............
  backtrace:
    [<ffffffff81607a9a>] kmalloc include/linux/slab.h:556 [inline]
    [<ffffffff81607a9a>] __io_queue_proc+0x10a/0x1b0 fs/io_uring.c:5027
    [<ffffffff824b8aa6>] poll_wait include/linux/poll.h:51 [inline]
    [<ffffffff824b8aa6>] n_tty_poll+0x76/0x3a0 drivers/tty/n_tty.c:2429
    [<ffffffff824b3319>] tty_poll+0x89/0xc0 drivers/tty/tty_io.c:2231
    [<ffffffff81600e79>] vfs_poll include/linux/poll.h:90 [inline]
    [<ffffffff81600e79>] __io_arm_poll_handler+0xb9/0x2b0 fs/io_uring.c:5118
    [<ffffffff81607137>] io_poll_add.constprop.0+0x47/0x180 fs/io_uring.c:5402
    [<ffffffff8160f6cf>] io_issue_sqe+0x19f/0x2880 fs/io_uring.c:6126
    [<ffffffff81611e4a>] __io_queue_sqe+0x9a/0x620 fs/io_uring.c:6414
    [<ffffffff81612a65>] io_queue_sqe+0x275/0x3e0 fs/io_uring.c:6463
    [<ffffffff81614bf8>] io_submit_sqe fs/io_uring.c:6626 [inline]
    [<ffffffff81614bf8>] io_submit_sqes+0x2028/0x23b0 fs/io_uring.c:6734
    [<ffffffff81615798>] __do_sys_io_uring_enter+0x818/0xf50 fs/io_uring.c:9319
    [<ffffffff8435309a>] do_syscall_64+0x3a/0xb0 arch/x86/entry/common.c:47
    [<ffffffff84400068>] entry_SYSCALL_64_after_hwframe+0x44/0xae



---
This report is generated by a bot. It may contain errors.
See https://goo.gl/tpsmEJ for more information about syzbot.
syzbot engineers can be reached at syzkaller@googlegroups.com.

syzbot will keep track of this issue. See:
https://goo.gl/tpsmEJ#status for how to communicate with syzbot.
syzbot can test patches for this issue, for details see:
https://goo.gl/tpsmEJ#testing-patches
