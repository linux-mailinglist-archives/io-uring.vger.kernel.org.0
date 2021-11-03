Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 87353444B68
	for <lists+io-uring@lfdr.de>; Thu,  4 Nov 2021 00:16:35 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229676AbhKCXTF (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Wed, 3 Nov 2021 19:19:05 -0400
Received: from mail-io1-f69.google.com ([209.85.166.69]:36529 "EHLO
        mail-io1-f69.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229618AbhKCXTF (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Wed, 3 Nov 2021 19:19:05 -0400
Received: by mail-io1-f69.google.com with SMTP id n8-20020a056602340800b005e17d5ba4b9so2652901ioz.3
        for <io-uring@vger.kernel.org>; Wed, 03 Nov 2021 16:16:28 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:mime-version:date:message-id:subject:from:to;
        bh=wbuKJuSVl/NT7eECMbsEKa3vPpaTLvDXMmmZ2vghqEY=;
        b=Ui1f0wTnzMOUp3Wk9hJbo6wLfbJ2cUC2xrEY2eRbtZeA2nNXp+o5CW3qV1R7PQ1hX4
         DLF2fSmF9PmZmkyXWH5xFJTe44G9LfHwGRFXT8+fyKf/tiBdM4OmbCtG+4vlvV8nVAie
         m4/ghMBWNmoFfFvMtczX0fd00fm7s+lzDTBefO68vg2i2mLHbsCMRquukAY0q5zQYYh+
         6nycemXwY7TO6eZD7BqMM50LB5BE5jTXe+PANJYR/nC2N9Lzb/oIskrIuRNQpIOEf3K5
         JUnQr5SHyTJhjCTKZK2quWcwNzK5oz7Q5xoZgoCn8PvckTTqoyvXX7fV2BGXoZ12/O1b
         5lEw==
X-Gm-Message-State: AOAM533g1AbMmjyOT/qLS9N5A62kP3nxKuYD22CMGLNbW7kSH1FahZCZ
        2aB/3u9CmN3c9uU/s0Mf+ICJU6lqrJEfucU8XN2v2dZdhAGw
X-Google-Smtp-Source: ABdhPJz47uTr+r8RxWv0ec+aegSEYLLKCrShSBbwFLB+b53NyXRfpxjDVijzQHeSJs8JVm3LKIKdbeJcE8keudFAB84Zmrh6v8ET
MIME-Version: 1.0
X-Received: by 2002:a92:1e11:: with SMTP id e17mr31764709ile.196.1635981387761;
 Wed, 03 Nov 2021 16:16:27 -0700 (PDT)
Date:   Wed, 03 Nov 2021 16:16:27 -0700
X-Google-Appengine-App-Id: s~syzkaller
X-Google-Appengine-App-Id-Alias: syzkaller
Message-ID: <0000000000007a0d5705cfea99b2@google.com>
Subject: [syzbot] WARNING in io_poll_task_func (2)
From:   syzbot <syzbot+804709f40ea66018e544@syzkaller.appspotmail.com>
To:     asml.silence@gmail.com, axboe@kernel.dk, io-uring@vger.kernel.org,
        linux-kernel@vger.kernel.org, syzkaller-bugs@googlegroups.com,
        xiaoguang.wang@linux.alibaba.com
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org

Hello,

syzbot found the following issue on:

HEAD commit:    bdcc9f6a5682 Add linux-next specific files for 20211029
git tree:       linux-next
console output: https://syzkaller.appspot.com/x/log.txt?x=14ab0e5cb00000
kernel config:  https://syzkaller.appspot.com/x/.config?x=4b504bcb4c507265
dashboard link: https://syzkaller.appspot.com/bug?extid=804709f40ea66018e544
compiler:       gcc (Debian 10.2.1-6) 10.2.1 20210110, GNU ld (GNU Binutils for Debian) 2.35.2
syz repro:      https://syzkaller.appspot.com/x/repro.syz?x=15710012b00000
C reproducer:   https://syzkaller.appspot.com/x/repro.c?x=11862ef4b00000

The issue was bisected to:

commit 34ced75ca1f63fac6148497971212583aa0f7a87
Author: Xiaoguang Wang <xiaoguang.wang@linux.alibaba.com>
Date:   Mon Oct 25 05:38:48 2021 +0000

    io_uring: reduce frequent add_wait_queue() overhead for multi-shot poll request

bisection log:  https://syzkaller.appspot.com/x/bisect.txt?x=13c264bcb00000
final oops:     https://syzkaller.appspot.com/x/report.txt?x=102264bcb00000
console output: https://syzkaller.appspot.com/x/log.txt?x=17c264bcb00000

IMPORTANT: if you fix the issue, please add the following tag to the commit:
Reported-by: syzbot+804709f40ea66018e544@syzkaller.appspotmail.com
Fixes: 34ced75ca1f6 ("io_uring: reduce frequent add_wait_queue() overhead for multi-shot poll request")

------------[ cut here ]------------
WARNING: CPU: 1 PID: 9467 at fs/io_uring.c:1183 req_ref_put_and_test fs/io_uring.c:1183 [inline]
WARNING: CPU: 1 PID: 9467 at fs/io_uring.c:1183 req_ref_put_and_test fs/io_uring.c:1178 [inline]
WARNING: CPU: 1 PID: 9467 at fs/io_uring.c:1183 io_put_req_find_next fs/io_uring.c:2392 [inline]
WARNING: CPU: 1 PID: 9467 at fs/io_uring.c:1183 io_poll_task_func+0x81d/0x9f0 fs/io_uring.c:5412
Modules linked in:
CPU: 1 PID: 9467 Comm: syz-executor199 Not tainted 5.15.0-rc7-next-20211029-syzkaller #0
Hardware name: Google Google Compute Engine/Google Compute Engine, BIOS Google 01/01/2011
RIP: 0010:req_ref_put_and_test fs/io_uring.c:1183 [inline]
RIP: 0010:req_ref_put_and_test fs/io_uring.c:1178 [inline]
RIP: 0010:io_put_req_find_next fs/io_uring.c:2392 [inline]
RIP: 0010:io_poll_task_func+0x81d/0x9f0 fs/io_uring.c:5412
Code: e8 e8 f3 da ff f0 ff 8d 80 00 00 00 0f 94 c3 31 ff 89 de e8 15 33 94 ff 84 db 0f 84 47 f8 ff ff e9 a4 fa ff ff e8 23 2f 94 ff <0f> 0b eb c5 e8 4a f0 da ff e9 0e f8 ff ff 4c 89 f7 e8 0d f0 da ff
RSP: 0018:ffffc9000daa7d98 EFLAGS: 00010293
RAX: 0000000000000000 RBX: 000000000000007f RCX: 0000000000000000
RDX: ffff88806d821d40 RSI: ffffffff81e39d0d RDI: 0000000000000003
RBP: ffff888072c1b140 R08: 000000000000007f R09: ffff888072c1b1c3
R10: ffffffff81e39cd1 R11: 0000000000000000 R12: ffff888072c1b1c0
R13: ffff88806b2a0000 R14: 0000000000000016 R15: ffff8880173f03c0
FS:  00007f1c4f07e700(0000) GS:ffff8880b9d00000(0000) knlGS:0000000000000000
CS:  0010 DS: 0000 ES: 0000 CR0: 0000000080050033
CR2: 0000000020001348 CR3: 000000001d66d000 CR4: 00000000003506e0
DR0: 0000000000000000 DR1: 0000000000000000 DR2: 0000000000000000
DR3: 0000000000000000 DR6: 00000000fffe0ff0 DR7: 0000000000000400
Call Trace:
 <TASK>
 tctx_task_work+0x1b3/0x630 fs/io_uring.c:2207
 task_work_run+0xdd/0x1a0 kernel/task_work.c:164
 tracehook_notify_signal include/linux/tracehook.h:214 [inline]
 handle_signal_work kernel/entry/common.c:146 [inline]
 exit_to_user_mode_loop kernel/entry/common.c:172 [inline]
 exit_to_user_mode_prepare+0x256/0x290 kernel/entry/common.c:207
 __syscall_exit_to_user_mode_work kernel/entry/common.c:289 [inline]
 syscall_exit_to_user_mode+0x19/0x60 kernel/entry/common.c:300
 do_syscall_64+0x42/0xb0 arch/x86/entry/common.c:86
 entry_SYSCALL_64_after_hwframe+0x44/0xae
RIP: 0033:0x7f1c4f0d57f9
Code: 28 00 00 00 75 05 48 83 c4 28 c3 e8 a1 18 00 00 90 48 89 f8 48 89 f7 48 89 d6 48 89 ca 4d 89 c2 4d 89 c8 4c 8b 4c 24 08 0f 05 <48> 3d 01 f0 ff ff 73 01 c3 48 c7 c1 b8 ff ff ff f7 d8 64 89 01 48
RSP: 002b:00007f1c4f07e2f8 EFLAGS: 00000246 ORIG_RAX: 00000000000001aa
RAX: 000000000000052c RBX: 00007f1c4f1574a8 RCX: 00007f1c4f0d57f9
RDX: 0000000000000000 RSI: 000000000000450e RDI: 0000000000000006
RBP: 00007f1c4f1574a0 R08: 0000000000000000 R09: 0000000000000000
R10: 0000000000000000 R11: 0000000000000246 R12: 00007f1c4f124598
R13: 0000000000000006 R14: 00007f1c4f07e400 R15: 0000000000022000
 </TASK>


---
This report is generated by a bot. It may contain errors.
See https://goo.gl/tpsmEJ for more information about syzbot.
syzbot engineers can be reached at syzkaller@googlegroups.com.

syzbot will keep track of this issue. See:
https://goo.gl/tpsmEJ#status for how to communicate with syzbot.
For information about bisection process see: https://goo.gl/tpsmEJ#bisection
syzbot can test patches for this issue, for details see:
https://goo.gl/tpsmEJ#testing-patches
