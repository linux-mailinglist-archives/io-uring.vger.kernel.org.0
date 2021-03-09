Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id BC9BE332A86
	for <lists+io-uring@lfdr.de>; Tue,  9 Mar 2021 16:34:00 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230503AbhCIPd1 (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Tue, 9 Mar 2021 10:33:27 -0500
Received: from mail-il1-f197.google.com ([209.85.166.197]:45632 "EHLO
        mail-il1-f197.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230325AbhCIPdU (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Tue, 9 Mar 2021 10:33:20 -0500
Received: by mail-il1-f197.google.com with SMTP id h17so10437773ila.12
        for <io-uring@vger.kernel.org>; Tue, 09 Mar 2021 07:33:20 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:date:message-id:subject:from:to;
        bh=dx71GG595U3crIwUELL4NgEeNwGkUwYWZRfrBmC/+Jk=;
        b=Rump0XccoZ0qmgWN3c8hKY8k09/fnzqybsb1bSGpkqwAz7s1Kei6Uh51vYn3MK1yET
         H41gFAf64ra5F/vosemldRSaoVU2hS4pC3SM6qB6bEY2pCXQoEP1tiOE9wWI6rO5kIIh
         wvhmpoQeB+lCxn08VAQOIGvdX36vKCB+bx51oxaGruZXUjGPRmt2gpV5bnzTZdvNstPJ
         NGxJzgZ1V5ihxgKUOWXo8Q8mNUHxz8U6EZGn7zKNn1lPkWEJnd/9yOFJEDAGuYnLvwV1
         rxdsMMGJxpG0S/OhuaWPtCjNazpqTNvrNO2tzZUtWMoVOYOJd+2fHyXzrmqcv5dumJvP
         mZJg==
X-Gm-Message-State: AOAM532NzulOelT2Fh0bODZtPGshDa6/n0WWW+RQSbjb1CV2tnQKE8vs
        0/dwQzeGbeL1oVswgBTCSU8oL/TAjzZINhRfcH+j4XVR0dxA
X-Google-Smtp-Source: ABdhPJzUU/xAsizsFO/L8HF+wBNZQfrpEKRngVqCtIUY9/dtXFZKqMDD3KtZLk071961GEbLWbyDQc7jGbOB74fW7b4iQQ7XvNQK
MIME-Version: 1.0
X-Received: by 2002:a02:cd39:: with SMTP id h25mr20503519jaq.49.1615304000048;
 Tue, 09 Mar 2021 07:33:20 -0800 (PST)
Date:   Tue, 09 Mar 2021 07:33:20 -0800
X-Google-Appengine-App-Id: s~syzkaller
X-Google-Appengine-App-Id-Alias: syzkaller
Message-ID: <00000000000020922505bd1c4500@google.com>
Subject: [syzbot] WARNING in io_wq_put
From:   syzbot <syzbot+77a738a6bc947bf639ca@syzkaller.appspotmail.com>
To:     asml.silence@gmail.com, axboe@kernel.dk, io-uring@vger.kernel.org,
        linux-kernel@vger.kernel.org, syzkaller-bugs@googlegroups.com
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org

Hello,

syzbot found the following issue on:

HEAD commit:    a38fd874 Linux 5.12-rc2
git tree:       upstream
console output: https://syzkaller.appspot.com/x/log.txt?x=1276fd0ad00000
kernel config:  https://syzkaller.appspot.com/x/.config?x=9008fb06fa15d749
dashboard link: https://syzkaller.appspot.com/bug?extid=77a738a6bc947bf639ca
compiler:       Debian clang version 11.0.1-2

Unfortunately, I don't have any reproducer for this issue yet.

IMPORTANT: if you fix the issue, please add the following tag to the commit:
Reported-by: syzbot+77a738a6bc947bf639ca@syzkaller.appspotmail.com

------------[ cut here ]------------
WARNING: CPU: 1 PID: 12346 at fs/io-wq.c:1061 io_wq_destroy fs/io-wq.c:1061 [inline]
WARNING: CPU: 1 PID: 12346 at fs/io-wq.c:1061 io_wq_put+0x153/0x260 fs/io-wq.c:1072
Modules linked in:
CPU: 1 PID: 12346 Comm: syz-executor.5 Not tainted 5.12.0-rc2-syzkaller #0
Hardware name: Google Google Compute Engine/Google Compute Engine, BIOS Google 01/01/2011
RIP: 0010:io_wq_destroy fs/io-wq.c:1061 [inline]
RIP: 0010:io_wq_put+0x153/0x260 fs/io-wq.c:1072
Code: 8d e8 71 90 ea 01 49 89 c4 41 83 fc 40 7d 4f e8 33 4d 97 ff 42 80 7c 2d 00 00 0f 85 77 ff ff ff e9 7a ff ff ff e8 1d 4d 97 ff <0f> 0b eb b9 8d 6b ff 89 ee 09 de bf ff ff ff ff e8 18 51 97 ff 09
RSP: 0018:ffffc90001ebfb08 EFLAGS: 00010293
RAX: ffffffff81e16083 RBX: ffff888019038040 RCX: ffff88801e86b780
RDX: 0000000000000000 RSI: 0000000000000000 RDI: 0000000000000040
RBP: 1ffff1100b2f8a80 R08: ffffffff81e15fce R09: ffffed100b2f8a82
R10: ffffed100b2f8a82 R11: 0000000000000000 R12: 0000000000000000
R13: dffffc0000000000 R14: ffff8880597c5400 R15: ffff888019038000
FS:  00007f8dcd89c700(0000) GS:ffff8880b9c00000(0000) knlGS:0000000000000000
CS:  0010 DS: 0000 ES: 0000 CR0: 0000000080050033
CR2: 000055e9a054e160 CR3: 000000001dfb8000 CR4: 00000000001506f0
DR0: 0000000000000000 DR1: 0000000000000000 DR2: 0000000000000000
DR3: 0000000000000000 DR6: 00000000fffe0ff0 DR7: 0000000000000400
Call Trace:
 io_uring_clean_tctx+0x1b7/0x210 fs/io_uring.c:8802
 __io_uring_files_cancel+0x13c/0x170 fs/io_uring.c:8820
 io_uring_files_cancel include/linux/io_uring.h:47 [inline]
 do_exit+0x258/0x2340 kernel/exit.c:780
 do_group_exit+0x168/0x2d0 kernel/exit.c:922
 get_signal+0x1734/0x1ef0 kernel/signal.c:2773
 arch_do_signal_or_restart+0x3c/0x610 arch/x86/kernel/signal.c:811
 handle_signal_work kernel/entry/common.c:147 [inline]
 exit_to_user_mode_loop kernel/entry/common.c:171 [inline]
 exit_to_user_mode_prepare+0xac/0x1e0 kernel/entry/common.c:208
 __syscall_exit_to_user_mode_work kernel/entry/common.c:290 [inline]
 syscall_exit_to_user_mode+0x48/0x180 kernel/entry/common.c:301
 entry_SYSCALL_64_after_hwframe+0x44/0xae
RIP: 0033:0x465f69
Code: ff ff c3 66 2e 0f 1f 84 00 00 00 00 00 0f 1f 40 00 48 89 f8 48 89 f7 48 89 d6 48 89 ca 4d 89 c2 4d 89 c8 4c 8b 4c 24 08 0f 05 <48> 3d 01 f0 ff ff 73 01 c3 48 c7 c1 bc ff ff ff f7 d8 64 89 01 48
RSP: 002b:00007f8dcd89c188 EFLAGS: 00000246 ORIG_RAX: 00000000000001aa
RAX: 0000000000000302 RBX: 000000000056bf60 RCX: 0000000000465f69
RDX: 0000000000000000 RSI: 0000000000000302 RDI: 0000000000000005
RBP: 00000000004bfa67 R08: 0000000000000000 R09: 0000000000000000
R10: 0000000000000000 R11: 0000000000000246 R12: 000000000056bf60
R13: 00007ffd520357bf R14: 00007f8dcd89c300 R15: 0000000000022000


---
This report is generated by a bot. It may contain errors.
See https://goo.gl/tpsmEJ for more information about syzbot.
syzbot engineers can be reached at syzkaller@googlegroups.com.

syzbot will keep track of this issue. See:
https://goo.gl/tpsmEJ#status for how to communicate with syzbot.
