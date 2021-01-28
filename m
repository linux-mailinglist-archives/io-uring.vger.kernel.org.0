Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 8EEDA307B9A
	for <lists+io-uring@lfdr.de>; Thu, 28 Jan 2021 18:02:30 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232233AbhA1Q75 (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Thu, 28 Jan 2021 11:59:57 -0500
Received: from mail-il1-f198.google.com ([209.85.166.198]:43306 "EHLO
        mail-il1-f198.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232727AbhA1Q7E (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Thu, 28 Jan 2021 11:59:04 -0500
Received: by mail-il1-f198.google.com with SMTP id b4so5210666ilj.10
        for <io-uring@vger.kernel.org>; Thu, 28 Jan 2021 08:58:48 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:date:message-id:subject:from:to;
        bh=5eUqdE/qujF2vvImOu8U/X+yORx2488KJ3tM2EhWIwA=;
        b=Tds5QyrrjyOUOelHXMm3TDkpaeV5Pwabzl1lFU7iWE5mR20HyUbdErT1/QRWrQstD1
         nbZ0bAv8ss0bjZcVJps7LknHtwEa1+qNiJKaYoETjBqaz3gx9bLyPtJCI39FRdUiAQGg
         R0fNYiE+Rhj+qrlirJ+/ouOQ7aNeIL2SN613fVlln5OQ0CSU2TAw/a8Ne/W43CLhURDf
         wqMh9F8UAvOzWsuMgHPBLxhSvVnFJVpwKco3YPJT2lHTnItb22PYTjA264erQqOg1o+N
         CN/jtFVtNPauowMEYXHaurYCLBHkwRM+gYf1F2haUB9aSCsFTkA/OsRE4DqfsrNlx5k7
         pLfw==
X-Gm-Message-State: AOAM532nxu/EfqZalZO11mzim6tHZeQS//xSIh1xoWmDKEeCDxt8wwPS
        S1wiJv/kTpx/6pTp1no10LzvgEcWfrq5N9zkZOUFIbGpNZv6
X-Google-Smtp-Source: ABdhPJzMwFJzkhTkWR833kFFG/6fGVR8ITXflyktlRRtWM7Pk+UN2ysf2xkXY2VNVOR+vaPD3DbtpvVuPJ/YhOtzo0JO33KbOUFY
MIME-Version: 1.0
X-Received: by 2002:a05:6e02:8aa:: with SMTP id a10mr13493652ilt.157.1611853103590;
 Thu, 28 Jan 2021 08:58:23 -0800 (PST)
Date:   Thu, 28 Jan 2021 08:58:23 -0800
X-Google-Appengine-App-Id: s~syzkaller
X-Google-Appengine-App-Id-Alias: syzkaller
Message-ID: <000000000000ab74fb05b9f8cb0a@google.com>
Subject: BUG: corrupted list in io_file_get
From:   syzbot <syzbot+6879187cf57845801267@syzkaller.appspotmail.com>
To:     axboe@kernel.dk, io-uring@vger.kernel.org,
        linux-fsdevel@vger.kernel.org, linux-kernel@vger.kernel.org,
        syzkaller-bugs@googlegroups.com, viro@zeniv.linux.org.uk
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org

Hello,

syzbot found the following issue on:

HEAD commit:    76c057c8 Merge branch 'parisc-5.11-2' of git://git.kernel...
git tree:       upstream
console output: https://syzkaller.appspot.com/x/log.txt?x=11959454d00000
kernel config:  https://syzkaller.appspot.com/x/.config?x=96b123631a6700e9
dashboard link: https://syzkaller.appspot.com/bug?extid=6879187cf57845801267
compiler:       gcc (GCC) 10.1.0-syz 20200507
syz repro:      https://syzkaller.appspot.com/x/repro.syz?x=12a3872cd00000
C reproducer:   https://syzkaller.appspot.com/x/repro.c?x=16ab17a4d00000

The issue was bisected to:

commit 02a13674fa0e8dd326de8b9f4514b41b03d99003
Author: Jens Axboe <axboe@kernel.dk>
Date:   Sat Jan 23 22:49:31 2021 +0000

    io_uring: account io_uring internal files as REQ_F_INFLIGHT

bisection log:  https://syzkaller.appspot.com/x/bisect.txt?x=14d1bf44d00000
final oops:     https://syzkaller.appspot.com/x/report.txt?x=16d1bf44d00000
console output: https://syzkaller.appspot.com/x/log.txt?x=12d1bf44d00000

IMPORTANT: if you fix the issue, please add the following tag to the commit:
Reported-by: syzbot+6879187cf57845801267@syzkaller.appspotmail.com
Fixes: 02a13674fa0e ("io_uring: account io_uring internal files as REQ_F_INFLIGHT")

list_add double add: new=ffff888017eaa080, prev=ffff88801a9cb520, next=ffff888017eaa080.
------------[ cut here ]------------
kernel BUG at lib/list_debug.c:29!
invalid opcode: 0000 [#1] PREEMPT SMP KASAN
CPU: 0 PID: 8481 Comm: syz-executor556 Not tainted 5.11.0-rc5-syzkaller #0
Hardware name: Google Google Compute Engine/Google Compute Engine, BIOS Google 01/01/2011
RIP: 0010:__list_add_valid.cold+0x26/0x3c lib/list_debug.c:29
Code: 04 c3 fb fa 4c 89 e1 48 c7 c7 e0 de 9e 89 e8 9e 43 f3 ff 0f 0b 48 89 f2 4c 89 e1 48 89 ee 48 c7 c7 20 e0 9e 89 e8 87 43 f3 ff <0f> 0b 48 89 f1 48 c7 c7 a0 df 9e 89 4c 89 e6 e8 73 43 f3 ff 0f 0b
RSP: 0018:ffffc90000fef938 EFLAGS: 00010086
RAX: 0000000000000058 RBX: ffff888017eaa000 RCX: 0000000000000000
RDX: ffff88801f3ed340 RSI: ffffffff815b6285 RDI: fffff520001fdf19
RBP: ffff888017eaa080 R08: 0000000000000058 R09: 0000000000000000
R10: ffffffff815af45e R11: 0000000000000000 R12: ffff888017eaa080
R13: ffff888014901900 R14: ffff88801a9cb000 R15: ffff88801a9cb520
FS:  0000000002395880(0000) GS:ffff8880b9e00000(0000) knlGS:0000000000000000
CS:  0010 DS: 0000 ES: 0000 CR0: 0000000080050033
CR2: 00007ff04f95b6c0 CR3: 000000001a4f2000 CR4: 0000000000350ef0
Call Trace:
 __list_add include/linux/list.h:67 [inline]
 list_add include/linux/list.h:86 [inline]
 io_file_get+0x8cc/0xdb0 fs/io_uring.c:6466
 __io_splice_prep+0x1bc/0x530 fs/io_uring.c:3866
 io_splice_prep fs/io_uring.c:3920 [inline]
 io_req_prep+0x3546/0x4e80 fs/io_uring.c:6081
 io_queue_sqe+0x609/0x10d0 fs/io_uring.c:6628
 io_submit_sqe fs/io_uring.c:6705 [inline]
 io_submit_sqes+0x1495/0x2720 fs/io_uring.c:6953
 __do_sys_io_uring_enter+0x107d/0x1f30 fs/io_uring.c:9353
 do_syscall_64+0x2d/0x70 arch/x86/entry/common.c:46
 entry_SYSCALL_64_after_hwframe+0x44/0xa9
RIP: 0033:0x440569
Code: 18 89 d0 c3 66 2e 0f 1f 84 00 00 00 00 00 0f 1f 00 48 89 f8 48 89 f7 48 89 d6 48 89 ca 4d 89 c2 4d 89 c8 4c 8b 4c 24 08 0f 05 <48> 3d 01 f0 ff ff 0f 83 7b 13 fc ff c3 66 2e 0f 1f 84 00 00 00 00
RSP: 002b:00007ffe38c5c5a8 EFLAGS: 00000246 ORIG_RAX: 00000000000001aa
RAX: ffffffffffffffda RBX: 0000000000401e00 RCX: 0000000000440569
RDX: 0000000000000000 RSI: 000000000000450c RDI: 0000000000000004
RBP: 00000000006ca018 R08: 0000000000000000 R09: 0000000000000000
R10: 0000000000000002 R11: 0000000000000246 R12: 0000000000401d70
R13: 0000000000401e00 R14: 0000000000000000 R15: 0000000000000000
Modules linked in:
---[ end trace 3c68392a0f24e7a0 ]---
RIP: 0010:__list_add_valid.cold+0x26/0x3c lib/list_debug.c:29
Code: 04 c3 fb fa 4c 89 e1 48 c7 c7 e0 de 9e 89 e8 9e 43 f3 ff 0f 0b 48 89 f2 4c 89 e1 48 89 ee 48 c7 c7 20 e0 9e 89 e8 87 43 f3 ff <0f> 0b 48 89 f1 48 c7 c7 a0 df 9e 89 4c 89 e6 e8 73 43 f3 ff 0f 0b
RSP: 0018:ffffc90000fef938 EFLAGS: 00010086
RAX: 0000000000000058 RBX: ffff888017eaa000 RCX: 0000000000000000
RDX: ffff88801f3ed340 RSI: ffffffff815b6285 RDI: fffff520001fdf19
RBP: ffff888017eaa080 R08: 0000000000000058 R09: 0000000000000000
R10: ffffffff815af45e R11: 0000000000000000 R12: ffff888017eaa080
R13: ffff888014901900 R14: ffff88801a9cb000 R15: ffff88801a9cb520
FS:  0000000002395880(0000) GS:ffff8880b9e00000(0000) knlGS:0000000000000000
CS:  0010 DS: 0000 ES: 0000 CR0: 0000000080050033
CR2: 00007ff04f95b6c0 CR3: 000000001a4f2000 CR4: 0000000000350ef0


---
This report is generated by a bot. It may contain errors.
See https://goo.gl/tpsmEJ for more information about syzbot.
syzbot engineers can be reached at syzkaller@googlegroups.com.

syzbot will keep track of this issue. See:
https://goo.gl/tpsmEJ#status for how to communicate with syzbot.
For information about bisection process see: https://goo.gl/tpsmEJ#bisection
syzbot can test patches for this issue, for details see:
https://goo.gl/tpsmEJ#testing-patches
