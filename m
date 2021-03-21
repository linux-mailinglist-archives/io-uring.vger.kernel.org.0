Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 0A00D343068
	for <lists+io-uring@lfdr.de>; Sun, 21 Mar 2021 01:44:56 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229766AbhCUAoU (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Sat, 20 Mar 2021 20:44:20 -0400
Received: from mail-il1-f200.google.com ([209.85.166.200]:55159 "EHLO
        mail-il1-f200.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229821AbhCUAoN (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Sat, 20 Mar 2021 20:44:13 -0400
Received: by mail-il1-f200.google.com with SMTP id f14so9265066ilr.21
        for <io-uring@vger.kernel.org>; Sat, 20 Mar 2021 17:44:13 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:date:in-reply-to:message-id:subject
         :from:to;
        bh=uN6lN3GlmonU2JJ7kGA35tYhCyEqkzBSc3SkKsMuimQ=;
        b=RHgOVPxYHvqrhDxr9PQvRYA6z/sfrnPdF7J7s1/ZXwM/A0oxKQ40nBhy3H67iBVite
         gHwkzHxWZCQkDU3yvOYIfqC8281wZk3ezaCMch1sLK8ANaXPcGfXR5WhnimGdpaI/ys2
         zva9RM7bNuwCWZlHp2AU5Q0gj+1XqRds/kqEJCU5idQji3ECgapvwpcXSkMPb8bJXwnF
         80TRNIpEyNFk29KCy/VXdJQvvoc0lppUCB8WxOxjWON422EWoqWBHBANehyYYJwPT7RK
         wo+ME6txEXN5dInVz7QhKWxvZNvxofJH80MP5nORxuCVCinS64KNcojEemGcPmsSPvRn
         O7Lw==
X-Gm-Message-State: AOAM5307w/CvtDEZrx8Utfwk7JvMrJ86xsZdNaOwNUxKAlvpmDSP4+jA
        4YghwmCh4mqsJrpQavCWu048gxjIf0Ddu3gQ5i1+qVEKXoOq
X-Google-Smtp-Source: ABdhPJyuklmBVSHUcr3qTbtDdGc0ESSn5ye7nLtlfvoHq7NIbmqEm8UhKgMkAM9CP1GOK3YPq9tniOn+ZZnCs2aa263W9rNq/AtV
MIME-Version: 1.0
X-Received: by 2002:a05:6638:635:: with SMTP id h21mr6225772jar.97.1616287452776;
 Sat, 20 Mar 2021 17:44:12 -0700 (PDT)
Date:   Sat, 20 Mar 2021 17:44:12 -0700
In-Reply-To: <00000000000020922505bd1c4500@google.com>
X-Google-Appengine-App-Id: s~syzkaller
X-Google-Appengine-App-Id-Alias: syzkaller
Message-ID: <0000000000007a49c105be013f72@google.com>
Subject: Re: [syzbot] WARNING in io_wq_put
From:   syzbot <syzbot+77a738a6bc947bf639ca@syzkaller.appspotmail.com>
To:     asml.silence@gmail.com, axboe@kernel.dk, io-uring@vger.kernel.org,
        linux-kernel@vger.kernel.org, syzkaller-bugs@googlegroups.com
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org

syzbot has found a reproducer for the following issue on:

HEAD commit:    1c273e10 Merge tag 'zonefs-5.12-rc4' of git://git.kernel.o..
git tree:       upstream
console output: https://syzkaller.appspot.com/x/log.txt?x=13853506d00000
kernel config:  https://syzkaller.appspot.com/x/.config?x=c51293a9ca630f6d
dashboard link: https://syzkaller.appspot.com/bug?extid=77a738a6bc947bf639ca
compiler:       Debian clang version 11.0.1-2
syz repro:      https://syzkaller.appspot.com/x/repro.syz?x=11ec259ed00000
C reproducer:   https://syzkaller.appspot.com/x/repro.c?x=13acfa62d00000

IMPORTANT: if you fix the issue, please add the following tag to the commit:
Reported-by: syzbot+77a738a6bc947bf639ca@syzkaller.appspotmail.com

------------[ cut here ]------------
WARNING: CPU: 1 PID: 12892 at fs/io-wq.c:1064 io_wq_destroy fs/io-wq.c:1064 [inline]
WARNING: CPU: 1 PID: 12892 at fs/io-wq.c:1064 io_wq_put+0x153/0x260 fs/io-wq.c:1075
Modules linked in:
CPU: 1 PID: 12892 Comm: syz-executor789 Not tainted 5.12.0-rc3-syzkaller #0
Hardware name: Google Google Compute Engine/Google Compute Engine, BIOS Google 01/01/2011
RIP: 0010:io_wq_destroy fs/io-wq.c:1064 [inline]
RIP: 0010:io_wq_put+0x153/0x260 fs/io-wq.c:1075
Code: 8d e8 f1 5f f2 01 49 89 c4 41 83 fc 40 7d 4f e8 a3 e9 97 ff 42 80 7c 2d 00 00 0f 85 77 ff ff ff e9 7a ff ff ff e8 8d e9 97 ff <0f> 0b eb b9 8d 6b ff 89 ee 09 de bf ff ff ff ff e8 88 ed 97 ff 09
RSP: 0018:ffffc9000a5efaa0 EFLAGS: 00010293
RAX: ffffffff81e11103 RBX: ffff888021873040 RCX: ffff88801fbb3880
RDX: 0000000000000000 RSI: 0000000000000000 RDI: 0000000000000040
RBP: 1ffff11004b3e480 R08: ffffffff81e1104e R09: ffffed1004b3e482
R10: ffffed1004b3e482 R11: 0000000000000000 R12: 0000000000000000
R13: dffffc0000000000 R14: ffff8880259f2400 R15: ffff888021873000
FS:  00007f2407204700(0000) GS:ffff8880b9c00000(0000) knlGS:0000000000000000
CS:  0010 DS: 0000 ES: 0000 CR0: 0000000080050033
CR2: 0000000000480510 CR3: 000000002d9a1000 CR4: 00000000001506f0
DR0: 0000000000000000 DR1: 0000000000000000 DR2: 0000000000000000
DR3: 0000000000000000 DR6: 00000000fffe0ff0 DR7: 0000000000000400
Call Trace:
 io_uring_clean_tctx fs/io_uring.c:8874 [inline]
 __io_uring_files_cancel+0xe11/0xe60 fs/io_uring.c:8939
 io_uring_files_cancel include/linux/io_uring.h:22 [inline]
 do_exit+0x258/0x2340 kernel/exit.c:780
 do_group_exit+0x168/0x2d0 kernel/exit.c:922
 get_signal+0x1734/0x1ef0 kernel/signal.c:2773
 arch_do_signal_or_restart+0x3c/0x610 arch/x86/kernel/signal.c:811
 handle_signal_work kernel/entry/common.c:147 [inline]
 exit_to_user_mode_loop kernel/entry/common.c:171 [inline]
 exit_to_user_mode_prepare+0xac/0x1e0 kernel/entry/common.c:208
 __syscall_exit_to_user_mode_work kernel/entry/common.c:290 [inline]
 syscall_exit_to_user_mode+0x26/0x70 kernel/entry/common.c:301
 entry_SYSCALL_64_after_hwframe+0x44/0xae
RIP: 0033:0x448c49
Code: 28 00 00 00 75 05 48 83 c4 28 c3 e8 d1 15 00 00 90 48 89 f8 48 89 f7 48 89 d6 48 89 ca 4d 89 c2 4d 89 c8 4c 8b 4c 24 08 0f 05 <48> 3d 01 f0 ff ff 73 01 c3 48 c7 c1 bc ff ff ff f7 d8 64 89 01 48
RSP: 002b:00007f24072041f8 EFLAGS: 00000246 ORIG_RAX: 00000000000001aa
RAX: 0000000000000302 RBX: 00000000004cd508 RCX: 0000000000448c49
RDX: 0000000000000000 RSI: 0000000000000302 RDI: 0000000000000005
RBP: 00000000004cd500 R08: 0000000000000000 R09: 0000000000000000
R10: 0000000000000000 R11: 0000000000000246 R12: 00000000004cd50c
R13: 00007ffc6fa9d1bf R14: 00007f2407204300 R15: 0000000000022000

