Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 3948B344D84
	for <lists+io-uring@lfdr.de>; Mon, 22 Mar 2021 18:37:56 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230391AbhCVRhX (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Mon, 22 Mar 2021 13:37:23 -0400
Received: from mail-il1-f200.google.com ([209.85.166.200]:36415 "EHLO
        mail-il1-f200.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230071AbhCVRhT (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Mon, 22 Mar 2021 13:37:19 -0400
Received: by mail-il1-f200.google.com with SMTP id s13so40480180ilp.3
        for <io-uring@vger.kernel.org>; Mon, 22 Mar 2021 10:37:19 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:date:message-id:subject:from:to;
        bh=rkdcotk5HOcDiurwBRIaTvqYjgL/Vtw/KTZrCesEFXI=;
        b=HmZnnpgRBvR9TTOC0QT3DOOGXOCCDu7tl4XwWFLtGhVEboytpCBzOz/3jvtD6gxDDP
         MjNxYzsjG5KXx1vzStph70wFukpV5KnEsMznYVZeh2VGAkdPrwCGf6em1adXGTNSgoib
         8tdQiuxwHorlnd5QtJtmqdimPsMioo2SmmGylcuYVkj/Sk5fXQvUnXwHFqVXAtZckksT
         f70lULcATNea66eFlY/V4zX0r6VvzOhP6xjCrNB7LU1yPO0qRF4OqG8QdxNnZ73tKg4+
         nBr7UnU6zcQSmxjkY+77W7sTlrakTxY/CgVoUaVPYRxRDKUC30J4tTge5w3MrnaEkIwK
         G32w==
X-Gm-Message-State: AOAM532aiQT8Aw0SDx7qxhDZaHIVzjJ7ohcaDonXaY0T+XvU59MBsR+T
        KcPQDweg6kDgagV22pTL/Np2pSV9tpFSjao25fNDHhyTS4C/
X-Google-Smtp-Source: ABdhPJycftI3/yD7GVxsMH7LD7AhkMCiVZcH28hBOOlJBnrORDqkabU/G68btuywBAj5A6NjPe9qxE2z7t2nybWehLUhBXTSxsk5
MIME-Version: 1.0
X-Received: by 2002:a05:6602:737:: with SMTP id g23mr722577iox.130.1616434639137;
 Mon, 22 Mar 2021 10:37:19 -0700 (PDT)
Date:   Mon, 22 Mar 2021 10:37:19 -0700
X-Google-Appengine-App-Id: s~syzkaller
X-Google-Appengine-App-Id-Alias: syzkaller
Message-ID: <00000000000077ef5d05be23841a@google.com>
Subject: [syzbot] WARNING in io_wq_destroy
From:   syzbot <syzbot+831debb250650baf4827@syzkaller.appspotmail.com>
To:     asml.silence@gmail.com, axboe@kernel.dk, io-uring@vger.kernel.org,
        linux-kernel@vger.kernel.org, syzkaller-bugs@googlegroups.com
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org

Hello,

syzbot found the following issue on:

HEAD commit:    0d02ec6b Linux 5.12-rc4
git tree:       upstream
console output: https://syzkaller.appspot.com/x/log.txt?x=1739e4aad00000
kernel config:  https://syzkaller.appspot.com/x/.config?x=5adab0bdee099d7a
dashboard link: https://syzkaller.appspot.com/bug?extid=831debb250650baf4827

Unfortunately, I don't have any reproducer for this issue yet.

IMPORTANT: if you fix the issue, please add the following tag to the commit:
Reported-by: syzbot+831debb250650baf4827@syzkaller.appspotmail.com

------------[ cut here ]------------
WARNING: CPU: 0 PID: 15234 at fs/io-wq.c:1068 io_wq_destroy+0x1dd/0x240 fs/io-wq.c:1068
Modules linked in:
CPU: 1 PID: 15234 Comm: syz-executor.5 Not tainted 5.12.0-rc4-syzkaller #0
Hardware name: Google Google Compute Engine/Google Compute Engine, BIOS Google 01/01/2011
RIP: 0010:io_wq_destroy+0x1dd/0x240 fs/io-wq.c:1068
Code: 48 c1 ea 03 80 3c 02 00 75 6e 49 8b 3c 24 e8 2a b3 d8 ff 4c 89 e7 5b 5d 41 5c 41 5d 41 5e 41 5f e9 18 b3 d8 ff e8 73 b1 95 ff <0f> 0b e9 02 ff ff ff e8 67 b1 95 ff 48 89 ef e8 ff b2 d8 ff eb ae
RSP: 0018:ffffc90016cb7950 EFLAGS: 00010293
RAX: 0000000000000000 RBX: 0000000000000000 RCX: 0000000000000000
RDX: ffff88801362d4c0 RSI: ffffffff81de3cbd RDI: ffff888022177840
RBP: ffff888022177800 R08: 000000000000003f R09: ffff8880254cb80f
R10: ffffffff81de3b50 R11: 0000000000000000 R12: ffff8880254cb800
R13: dffffc0000000000 R14: ffffed1004a99700 R15: 0000000000000040
FS:  00007f51c4a75700(0000) GS:ffff8880b9d00000(0000) knlGS:0000000000000000
CS:  0010 DS: 0000 ES: 0000 CR0: 0000000080050033
CR2: 0000001b32424000 CR3: 000000002a3f7000 CR4: 00000000001506e0
DR0: 0000000000000000 DR1: 0000000000000000 DR2: 0000000000000000
DR3: 0000000000000000 DR6: 00000000fffe0ff0 DR7: 0000000000000400
Call Trace:
 io_wq_put fs/io-wq.c:1079 [inline]
 io_wq_put_and_exit+0x8d/0xc0 fs/io-wq.c:1086
 io_uring_clean_tctx+0xed/0x160 fs/io_uring.c:8890
 __io_uring_files_cancel+0x503/0x5f0 fs/io_uring.c:8955
 io_uring_files_cancel include/linux/io_uring.h:22 [inline]
 do_exit+0x299/0x2a60 kernel/exit.c:780
 do_group_exit+0x125/0x310 kernel/exit.c:922
 get_signal+0x42c/0x2100 kernel/signal.c:2777
 arch_do_signal_or_restart+0x2a8/0x1eb0 arch/x86/kernel/signal.c:789
 handle_signal_work kernel/entry/common.c:147 [inline]
 exit_to_user_mode_loop kernel/entry/common.c:171 [inline]
 exit_to_user_mode_prepare+0x148/0x250 kernel/entry/common.c:208
 __syscall_exit_to_user_mode_work kernel/entry/common.c:290 [inline]
 syscall_exit_to_user_mode+0x19/0x60 kernel/entry/common.c:301
 entry_SYSCALL_64_after_hwframe+0x44/0xae
RIP: 0033:0x466459
Code: ff ff c3 66 2e 0f 1f 84 00 00 00 00 00 0f 1f 40 00 48 89 f8 48 89 f7 48 89 d6 48 89 ca 4d 89 c2 4d 89 c8 4c 8b 4c 24 08 0f 05 <48> 3d 01 f0 ff ff 73 01 c3 48 c7 c1 bc ff ff ff f7 d8 64 89 01 48
RSP: 002b:00007f51c4a75188 EFLAGS: 00000246 ORIG_RAX: 00000000000001aa
RAX: 0000000000000100 RBX: 000000000056bf60 RCX: 0000000000466459
RDX: 0000000000000000 RSI: 0000000000002039 RDI: 0000000000000003
RBP: 00000000004bf9fb R08: 0000000000000000 R09: 0000000000000000
R10: 0000000000000000 R11: 0000000000000246 R12: 000000000056bf60
R13: 0000000000a9fb1f R14: 00007f51c4a75300 R15: 0000000000022000


---
This report is generated by a bot. It may contain errors.
See https://goo.gl/tpsmEJ for more information about syzbot.
syzbot engineers can be reached at syzkaller@googlegroups.com.

syzbot will keep track of this issue. See:
https://goo.gl/tpsmEJ#status for how to communicate with syzbot.
