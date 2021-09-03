Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 6EE7940069B
	for <lists+io-uring@lfdr.de>; Fri,  3 Sep 2021 22:28:25 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1350523AbhICU3X (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Fri, 3 Sep 2021 16:29:23 -0400
Received: from mail-il1-f198.google.com ([209.85.166.198]:41801 "EHLO
        mail-il1-f198.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1350334AbhICU3X (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Fri, 3 Sep 2021 16:29:23 -0400
Received: by mail-il1-f198.google.com with SMTP id l4-20020a92d8c40000b02902242b6ea4b3so158207ilo.8
        for <io-uring@vger.kernel.org>; Fri, 03 Sep 2021 13:28:23 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:date:message-id:subject:from:to;
        bh=e0G8oDxHDZq3PXhMJnp9n7DKn5qv2ZYzqyKdQ4nnIDI=;
        b=TdqKd4Q/Zk83QrkdZHF0zddnvvYzlyf6pksGwFtx+w3M5/1jP94yYlkdMweacJ6CSX
         G46CBW2LKJ6XYx88Mx9Yg9MCzWly+oYC4S6YXTwd3LC34r4mgZYVmp32Jpkj8MbMQj/f
         GqOKQ9Ky8mI1ZnBQRJCCgnNMu9A7inNbsAjvQgFsFQa55DnZ9v4Emnk1gAjucp+wQtJY
         GVKAgb9OAWZ1JpQpLFaEZwKeGOXMyNvNbOgdh9YgjJXVocCzIldDsS7o0qKK3Y4GdkTT
         0e+JHmm6M6kVBATpY1OZVBrZIj9MT957dRThb1q5wFwiZSNP8BDNi1VHgrnY64oYDpJk
         oWpw==
X-Gm-Message-State: AOAM5320jBGqNK84co8utsJARilwJJALucyMs1C76GH7umuNU9D5zb8w
        HLHNaUy4suHxtkJN/pBKcwxGOHB71LYY0ZNouObkWo3FTKTp
X-Google-Smtp-Source: ABdhPJwzC9vEcHrX60n3V8OZXRBboFSFbDwrhsCSmUAguBGEsttW+FHrcijlB8gXul2pjHUP8oFWJrmbC2+i6RBYWFR6FN6wqYto
MIME-Version: 1.0
X-Received: by 2002:a05:6e02:1a6b:: with SMTP id w11mr520338ilv.69.1630700902893;
 Fri, 03 Sep 2021 13:28:22 -0700 (PDT)
Date:   Fri, 03 Sep 2021 13:28:22 -0700
X-Google-Appengine-App-Id: s~syzkaller
X-Google-Appengine-App-Id-Alias: syzkaller
Message-ID: <0000000000000d4da305cb1d2467@google.com>
Subject: [syzbot] BUG: unable to handle kernel NULL pointer dereference in kiocb_done
From:   syzbot <syzbot+726f2ce6dbbf2ad8d133@syzkaller.appspotmail.com>
To:     asml.silence@gmail.com, axboe@kernel.dk, io-uring@vger.kernel.org,
        linux-kernel@vger.kernel.org, syzkaller-bugs@googlegroups.com
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org

Hello,

syzbot found the following issue on:

HEAD commit:    4ac6d90867a4 Merge tag 'docs-5.15' of git://git.lwn.net/li..
git tree:       upstream
console output: https://syzkaller.appspot.com/x/log.txt?x=13a275f5300000
kernel config:  https://syzkaller.appspot.com/x/.config?x=3c3a5498e99259cf
dashboard link: https://syzkaller.appspot.com/bug?extid=726f2ce6dbbf2ad8d133
compiler:       gcc (Debian 10.2.1-6) 10.2.1 20210110, GNU ld (GNU Binutils for Debian) 2.35.1
syz repro:      https://syzkaller.appspot.com/x/repro.syz?x=124a3b49300000
C reproducer:   https://syzkaller.appspot.com/x/repro.c?x=142e610b300000

IMPORTANT: if you fix the issue, please add the following tag to the commit:
Reported-by: syzbot+726f2ce6dbbf2ad8d133@syzkaller.appspotmail.com

BUG: kernel NULL pointer dereference, address: 0000000000000000
#PF: supervisor instruction fetch in kernel mode
#PF: error_code(0x0010) - not-present page
PGD 26f41067 P4D 26f41067 PUD 17c87067 PMD 0 
Oops: 0010 [#1] PREEMPT SMP KASAN
CPU: 1 PID: 8473 Comm: iou-wrk-8424 Not tainted 5.14.0-syzkaller #0
Hardware name: Google Google Compute Engine/Google Compute Engine, BIOS Google 01/01/2011
RIP: 0010:0x0
Code: Unable to access opcode bytes at RIP 0xffffffffffffffd6.
RSP: 0018:ffffc900016af910 EFLAGS: 00010246
RAX: 0000000000000000 RBX: 0000000000000000 RCX: 0000000000000000
RDX: 0000000000000000 RSI: 0000000000000000 RDI: ffff888036b6c000
RBP: ffff888036b6c000 R08: 0000000000000000 R09: ffff8880191787d7
R10: ffffffff81e263e4 R11: 0000000000000000 R12: 0000000000000000
R13: ffff888036b6c058 R14: ffff888036b6c040 R15: 0000000000000000
FS:  0000000002442400(0000) GS:ffff8880b9d00000(0000) knlGS:0000000000000000
CS:  0010 DS: 0000 ES: 0000 CR0: 0000000080050033
CR2: ffffffffffffffd6 CR3: 000000001d9bc000 CR4: 00000000001506e0
DR0: 0000000000000000 DR1: 0000000000000000 DR2: 0000000000000000
DR3: 0000000000000000 DR6: 00000000fffe0ff0 DR7: 0000000000000400
Call Trace:
 io_rw_done fs/io_uring.c:2905 [inline]
 kiocb_done+0x1b3/0x980 fs/io_uring.c:2929
 io_read+0x3d3/0x1140 fs/io_uring.c:3503
 io_issue_sqe+0x209/0x6ba0 fs/io_uring.c:6558
 io_wq_submit_work+0x1d4/0x300 fs/io_uring.c:6707
 io_worker_handle_work+0xcb1/0x1950 fs/io-wq.c:560
 io_wqe_worker+0x2cc/0xbb0 fs/io-wq.c:609
 ret_from_fork+0x1f/0x30 arch/x86/entry/entry_64.S:295
Modules linked in:
CR2: 0000000000000000
---[ end trace f60cb53b8a968c33 ]---
RIP: 0010:0x0
Code: Unable to access opcode bytes at RIP 0xffffffffffffffd6.
RSP: 0018:ffffc900016af910 EFLAGS: 00010246
RAX: 0000000000000000 RBX: 0000000000000000 RCX: 0000000000000000
RDX: 0000000000000000 RSI: 0000000000000000 RDI: ffff888036b6c000
RBP: ffff888036b6c000 R08: 0000000000000000 R09: ffff8880191787d7
R10: ffffffff81e263e4 R11: 0000000000000000 R12: 0000000000000000
R13: ffff888036b6c058 R14: ffff888036b6c040 R15: 0000000000000000
FS:  0000000002442400(0000) GS:ffff8880b9d00000(0000) knlGS:0000000000000000
CS:  0010 DS: 0000 ES: 0000 CR0: 0000000080050033
CR2: ffffffffffffffd6 CR3: 000000001d9bc000 CR4: 00000000001506e0
DR0: 0000000000000000 DR1: 0000000000000000 DR2: 0000000000000000
DR3: 0000000000000000 DR6: 00000000fffe0ff0 DR7: 0000000000000400


---
This report is generated by a bot. It may contain errors.
See https://goo.gl/tpsmEJ for more information about syzbot.
syzbot engineers can be reached at syzkaller@googlegroups.com.

syzbot will keep track of this issue. See:
https://goo.gl/tpsmEJ#status for how to communicate with syzbot.
syzbot can test patches for this issue, for details see:
https://goo.gl/tpsmEJ#testing-patches
