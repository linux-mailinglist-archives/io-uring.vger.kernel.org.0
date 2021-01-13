Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 354742F48CF
	for <lists+io-uring@lfdr.de>; Wed, 13 Jan 2021 11:41:54 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727450AbhAMKiF (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Wed, 13 Jan 2021 05:38:05 -0500
Received: from mail-io1-f69.google.com ([209.85.166.69]:35324 "EHLO
        mail-io1-f69.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727207AbhAMKh4 (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Wed, 13 Jan 2021 05:37:56 -0500
Received: by mail-io1-f69.google.com with SMTP id a1so2154638ios.2
        for <io-uring@vger.kernel.org>; Wed, 13 Jan 2021 02:37:41 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:date:message-id:subject:from:to;
        bh=FflgQIa0V/Siwck56OOWVGczfPVwFLuPrTzseNjH5mg=;
        b=gbxsyOqc4HUcIKY6qnpOXH0u5QOrJpxQ4jK/DdXeXVG0lU99BsxkA7xxARfe9vakvC
         LseddJSP2agHLOHwciSYcGb8N4oSQbJ6Se5brFzJhxbg+HviTNAk+4BCp023Q0GIOJ5T
         50YryISvLSQGjaGry4VXn1wo4TtrCMXwdLaCdX+Z/JxuolPDoaUFoeFdIl9bkC/4+wZP
         trf8FLY8k2UGq4PS6A2q+CsuurHDsCe7nXqKo9qn5D8AN2QQxoe+syAkw+WsY/Pbe1iT
         HuFDx9fXNbT8pjOQnfGVMERtJraaVPiAgvtexWPxgBhI8Zg7o6YfwM24ZPWDOS0OAIJM
         Fw1A==
X-Gm-Message-State: AOAM5315tYyy//9+rhaaPIn/xV6rIMpi0nIid4uaVG5jqXNOxgRyQdCt
        n74S7xoAvi8O7XgJZErUEAdWmBfaYbopQUHZfCc9XD2qcVTj
X-Google-Smtp-Source: ABdhPJykJAmynDQ2pp2mibHVe5Ws8QccqfA0IzI4h/Mfbd321XGZirMBogHYRJ5ypTfcAwpw/62pH7GdAtFDqayCAhgThGx1s/ls
MIME-Version: 1.0
X-Received: by 2002:a02:1dca:: with SMTP id 193mr1778755jaj.39.1610534235644;
 Wed, 13 Jan 2021 02:37:15 -0800 (PST)
Date:   Wed, 13 Jan 2021 02:37:15 -0800
X-Google-Appengine-App-Id: s~syzkaller
X-Google-Appengine-App-Id-Alias: syzkaller
Message-ID: <00000000000003aab005b8c5b9ac@google.com>
Subject: WARNING in io_ring_ctx_wait_and_kill
From:   syzbot <syzbot+9c9c35374c0ecac06516@syzkaller.appspotmail.com>
To:     asml.silence@gmail.com, axboe@kernel.dk, io-uring@vger.kernel.org,
        linux-fsdevel@vger.kernel.org, linux-kernel@vger.kernel.org,
        syzkaller-bugs@googlegroups.com, viro@zeniv.linux.org.uk
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org

Hello,

syzbot found the following issue on:

HEAD commit:    7c53f6b6 Linux 5.11-rc3
git tree:       upstream
console output: https://syzkaller.appspot.com/x/log.txt?x=115280af500000
kernel config:  https://syzkaller.appspot.com/x/.config?x=c60c9ff9cc916cbc
dashboard link: https://syzkaller.appspot.com/bug?extid=9c9c35374c0ecac06516
compiler:       gcc (GCC) 10.1.0-syz 20200507
syz repro:      https://syzkaller.appspot.com/x/repro.syz?x=16286007500000
C reproducer:   https://syzkaller.appspot.com/x/repro.c?x=107fc7fb500000

The issue was bisected to:

commit d9d05217cb6990b9a56e13b56e7a1b71e2551f6c
Author: Pavel Begunkov <asml.silence@gmail.com>
Date:   Fri Jan 8 20:57:25 2021 +0000

    io_uring: stop SQPOLL submit on creator's death

bisection log:  https://syzkaller.appspot.com/x/bisect.txt?x=135aeb0b500000
final oops:     https://syzkaller.appspot.com/x/report.txt?x=10daeb0b500000
console output: https://syzkaller.appspot.com/x/log.txt?x=175aeb0b500000

IMPORTANT: if you fix the issue, please add the following tag to the commit:
Reported-by: syzbot+9c9c35374c0ecac06516@syzkaller.appspotmail.com
Fixes: d9d05217cb69 ("io_uring: stop SQPOLL submit on creator's death")

------------[ cut here ]------------
WARNING: CPU: 0 PID: 8494 at fs/io_uring.c:8717 io_ring_ctx_wait_and_kill+0x4f2/0x600 fs/io_uring.c:8717
Modules linked in:
CPU: 0 PID: 8494 Comm: syz-executor170 Not tainted 5.11.0-rc3-syzkaller #0
Hardware name: Google Google Compute Engine/Google Compute Engine, BIOS Google 01/01/2011
RIP: 0010:io_ring_ctx_wait_and_kill+0x4f2/0x600 fs/io_uring.c:8717
Code: 0f 85 23 01 00 00 48 8b ab 68 01 00 00 be 08 00 00 00 48 8d 7d 50 e8 8d 29 db ff f0 4c 29 65 50 e9 80 fd ff ff e8 0e 6a 98 ff <0f> 0b 48 b8 00 00 00 00 00 fc ff df 48 89 ea 48 c1 ea 03 0f b6 04
RSP: 0018:ffffc9000160fe38 EFLAGS: 00010293
RAX: 0000000000000000 RBX: ffff888014c83000 RCX: 0000000000000000
RDX: ffff888020309bc0 RSI: ffffffff81da5fb2 RDI: 0000000000000003
RBP: ffff888014c83044 R08: 0000000000000002 R09: ffffffff8ed30867
R10: ffffffff81da5b2d R11: 0000000000000000 R12: 0000000000000002
R13: ffff888014c83040 R14: ffff888014c83380 R15: ffff88802e2ea000
FS:  0000000002167880(0000) GS:ffff8880b9e00000(0000) knlGS:0000000000000000
CS:  0010 DS: 0000 ES: 0000 CR0: 0000000080050033
CR2: 00007f69433e31f0 CR3: 0000000017b77000 CR4: 0000000000350ef0
Call Trace:
 io_uring_release+0x3e/0x50 fs/io_uring.c:8759
 __fput+0x283/0x920 fs/file_table.c:280
 task_work_run+0xdd/0x190 kernel/task_work.c:140
 tracehook_notify_resume include/linux/tracehook.h:189 [inline]
 exit_to_user_mode_loop kernel/entry/common.c:174 [inline]
 exit_to_user_mode_prepare+0x249/0x250 kernel/entry/common.c:201
 __syscall_exit_to_user_mode_work kernel/entry/common.c:291 [inline]
 syscall_exit_to_user_mode+0x19/0x50 kernel/entry/common.c:302
 entry_SYSCALL_64_after_hwframe+0x44/0xa9
RIP: 0033:0x4402c9
Code: 18 89 d0 c3 66 2e 0f 1f 84 00 00 00 00 00 0f 1f 00 48 89 f8 48 89 f7 48 89 d6 48 89 ca 4d 89 c2 4d 89 c8 4c 8b 4c 24 08 0f 05 <48> 3d 01 f0 ff ff 0f 83 7b 13 fc ff c3 66 2e 0f 1f 84 00 00 00 00
RSP: 002b:00007ffca0848378 EFLAGS: 00000246 ORIG_RAX: 00000000000001a9
RAX: ffffffffffffffe8 RBX: 00000000004002c8 RCX: 00000000004402c9
RDX: 00000000004402c9 RSI: 0000000020000040 RDI: 0000000000002094
RBP: 00000000006ca018 R08: 0000000000000000 R09: 0000000000000000
R10: 0000000000000000 R11: 0000000000000246 R12: 0000000000401ad0
R13: 0000000000401b60 R14: 0000000000000000 R15: 0000000000000000


---
This report is generated by a bot. It may contain errors.
See https://goo.gl/tpsmEJ for more information about syzbot.
syzbot engineers can be reached at syzkaller@googlegroups.com.

syzbot will keep track of this issue. See:
https://goo.gl/tpsmEJ#status for how to communicate with syzbot.
For information about bisection process see: https://goo.gl/tpsmEJ#bisection
syzbot can test patches for this issue, for details see:
https://goo.gl/tpsmEJ#testing-patches
