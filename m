Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id D721440420F
	for <lists+io-uring@lfdr.de>; Thu,  9 Sep 2021 02:09:24 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1348090AbhIIAK3 (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Wed, 8 Sep 2021 20:10:29 -0400
Received: from mail-io1-f70.google.com ([209.85.166.70]:46035 "EHLO
        mail-io1-f70.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1348028AbhIIAK0 (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Wed, 8 Sep 2021 20:10:26 -0400
Received: by mail-io1-f70.google.com with SMTP id d23-20020a056602281700b005b5b34670c7so29807ioe.12
        for <io-uring@vger.kernel.org>; Wed, 08 Sep 2021 17:09:18 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:mime-version:date:message-id:subject:from:to;
        bh=QPkkC/1Bh97x6PmNJUT4Hxi4h89kOXJouRdSjI8zf0Y=;
        b=3c1ROD7EazdCzH3K9VMtxz8L+PV2uvKC4y7kOMRCy0HpwcT3/kQmFJvYQ4XzFx7daP
         sPjISsK7DA4vL3QjZT8ucA5NqnNWRoEvUFlO8cpfX0K87krxbvhAM2Vaqyi1uTX9Ib6G
         /dTWgN+E69JnJKSowRU02lgbT7V5lsjkJdwdGkRP/tw+Rs11toYhfxcZiEvOvSR7XrJI
         gm5YD+X7p2Or6DKjicyzYw4/IchSsx76X22GqRal6fxAOBWPhQDp1Wk5/um0gCY/r6fs
         Clp9PMgupMkwzrEZmAzDcRMcJISkEd2Wt7R5YY4Yjd4XEB13zX1aIkQWNxhms5gdGum9
         qHWg==
X-Gm-Message-State: AOAM533Pej3wdENgi51FhYVmt8s2BOzlgsWum2nm1epsQ8AMaZyWDljY
        IHwA8XmqoZ6S2aAcMlp/UFBzjSW9wWinti1O8q8YCNVpl49V
X-Google-Smtp-Source: ABdhPJyIRrR7Hdh76tEY/CQM34AZbdIzkcE2dCcxDMT8REmvqwSZmWUL0+MwVYvj7CDDhTO1UpGXgtA61SS7uhITCwSXAc5H4RRX
MIME-Version: 1.0
X-Received: by 2002:a02:cebc:: with SMTP id z28mr185001jaq.49.1631146157527;
 Wed, 08 Sep 2021 17:09:17 -0700 (PDT)
Date:   Wed, 08 Sep 2021 17:09:17 -0700
X-Google-Appengine-App-Id: s~syzkaller
X-Google-Appengine-App-Id-Alias: syzkaller
Message-ID: <0000000000004bda3905cb84cfc0@google.com>
Subject: [syzbot] WARNING in io_wq_submit_work (2)
From:   syzbot <syzbot+bc2d90f602545761f287@syzkaller.appspotmail.com>
To:     asml.silence@gmail.com, axboe@kernel.dk, io-uring@vger.kernel.org,
        linux-kernel@vger.kernel.org, syzkaller-bugs@googlegroups.com
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org

Hello,

syzbot found the following issue on:

HEAD commit:    4b93c544e90e thunderbolt: test: split up test cases in tb_..
git tree:       upstream
console output: https://syzkaller.appspot.com/x/log.txt?x=10b7836d300000
kernel config:  https://syzkaller.appspot.com/x/.config?x=ac2f9cc43f6b17e4
dashboard link: https://syzkaller.appspot.com/bug?extid=bc2d90f602545761f287
compiler:       gcc (Debian 10.2.1-6) 10.2.1 20210110, GNU ld (GNU Binutils for Debian) 2.35.1
syz repro:      https://syzkaller.appspot.com/x/repro.syz?x=10e8ce0b300000

The issue was bisected to:

commit 3146cba99aa284b1d4a10fbd923df953f1d18035
Author: Jens Axboe <axboe@kernel.dk>
Date:   Wed Sep 1 17:20:10 2021 +0000

    io-wq: make worker creation resilient against signals

bisection log:  https://syzkaller.appspot.com/x/bisect.txt?x=11098e0d300000
final oops:     https://syzkaller.appspot.com/x/report.txt?x=13098e0d300000
console output: https://syzkaller.appspot.com/x/log.txt?x=15098e0d300000

IMPORTANT: if you fix the issue, please add the following tag to the commit:
Reported-by: syzbot+bc2d90f602545761f287@syzkaller.appspotmail.com
Fixes: 3146cba99aa2 ("io-wq: make worker creation resilient against signals")

------------[ cut here ]------------
WARNING: CPU: 1 PID: 8804 at fs/io_uring.c:1164 req_ref_get fs/io_uring.c:1164 [inline]
WARNING: CPU: 1 PID: 8804 at fs/io_uring.c:1164 io_wq_submit_work+0x272/0x300 fs/io_uring.c:6731
Modules linked in:
CPU: 1 PID: 8804 Comm: syz-executor.0 Not tainted 5.14.0-syzkaller #0
Hardware name: Google Google Compute Engine/Google Compute Engine, BIOS Google 01/01/2011
RIP: 0010:req_ref_get fs/io_uring.c:1164 [inline]
RIP: 0010:io_wq_submit_work+0x272/0x300 fs/io_uring.c:6731
Code: e8 d3 21 91 ff 83 fb 7f 76 1b e8 89 1a 91 ff be 04 00 00 00 4c 89 ef e8 bc 62 d8 ff f0 ff 45 a4 e9 41 fe ff ff e8 6e 1a 91 ff <0f> 0b eb dc e8 65 1a 91 ff 4c 89 e7 e8 ad dc fb ff 48 85 c0 49 89
RSP: 0018:ffffc900027b7ae8 EFLAGS: 00010293
RAX: 0000000000000000 RBX: 000000000000007f RCX: 0000000000000000
RDX: ffff8880209cb900 RSI: ffffffff81e506d2 RDI: 0000000000000003
RBP: ffff888071824978 R08: 000000000000007f R09: ffff88807182491f
R10: ffffffff81e506ad R11: 0000000000000000 R12: ffff8880718248c0
R13: ffff88807182491c R14: ffff888071824918 R15: 0000000000100000
FS:  0000000002b68400(0000) GS:ffff8880b9c00000(0000) knlGS:0000000000000000
CS:  0010 DS: 0000 ES: 0000 CR0: 0000000080050033
CR2: 000055f33208ca50 CR3: 0000000071827000 CR4: 00000000001506f0
DR0: 0000000000000000 DR1: 0000000000000000 DR2: 0000000000000000
DR3: 0000000000000000 DR6: 00000000fffe0ff0 DR7: 0000000000000400
Call Trace:
 io_run_cancel fs/io-wq.c:809 [inline]
 io_acct_cancel_pending_work.isra.0+0x2a9/0x5e0 fs/io-wq.c:950
 io_wqe_cancel_pending_work+0x98/0x130 fs/io-wq.c:968
 io_wq_destroy fs/io-wq.c:1185 [inline]
 io_wq_put_and_exit+0x7d1/0xc70 fs/io-wq.c:1198
 io_uring_clean_tctx fs/io_uring.c:9607 [inline]
 io_uring_cancel_generic+0x5fe/0x740 fs/io_uring.c:9687
 io_uring_files_cancel include/linux/io_uring.h:16 [inline]
 do_exit+0x265/0x2a30 kernel/exit.c:780
 do_group_exit+0x125/0x310 kernel/exit.c:922
 __do_sys_exit_group kernel/exit.c:933 [inline]
 __se_sys_exit_group kernel/exit.c:931 [inline]
 __x64_sys_exit_group+0x3a/0x50 kernel/exit.c:931
 do_syscall_x64 arch/x86/entry/common.c:50 [inline]
 do_syscall_64+0x35/0xb0 arch/x86/entry/common.c:80
 entry_SYSCALL_64_after_hwframe+0x44/0xae
RIP: 0033:0x4665f9
Code: ff ff c3 66 2e 0f 1f 84 00 00 00 00 00 0f 1f 40 00 48 89 f8 48 89 f7 48 89 d6 48 89 ca 4d 89 c2 4d 89 c8 4c 8b 4c 24 08 0f 05 <48> 3d 01 f0 ff ff 73 01 c3 48 c7 c1 bc ff ff ff f7 d8 64 89 01 48
RSP: 002b:00007ffdd0a294a8 EFLAGS: 00000246 ORIG_RAX: 00000000000000e7
RAX: ffffffffffffffda RBX: 000000000000001e RCX: 00000000004665f9
RDX: 000000000041940b RSI: ffffffffffffffbc RDI: 0000000000000000
RBP: 0000000000000000 R08: 0000001b2be20070 R09: 0000000000000000
R10: 0000000000000000 R11: 0000000000000246 R12: 0000000000000001
R13: 0000000000000000 R14: 0000000000000000 R15: 00007ffdd0a295a0


---
This report is generated by a bot. It may contain errors.
See https://goo.gl/tpsmEJ for more information about syzbot.
syzbot engineers can be reached at syzkaller@googlegroups.com.

syzbot will keep track of this issue. See:
https://goo.gl/tpsmEJ#status for how to communicate with syzbot.
For information about bisection process see: https://goo.gl/tpsmEJ#bisection
syzbot can test patches for this issue, for details see:
https://goo.gl/tpsmEJ#testing-patches
