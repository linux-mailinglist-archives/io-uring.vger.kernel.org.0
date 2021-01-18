Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id EE3352F989E
	for <lists+io-uring@lfdr.de>; Mon, 18 Jan 2021 05:28:29 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730434AbhARE2H (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Sun, 17 Jan 2021 23:28:07 -0500
Received: from mail-io1-f70.google.com ([209.85.166.70]:37056 "EHLO
        mail-io1-f70.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1728690AbhARE17 (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Sun, 17 Jan 2021 23:27:59 -0500
Received: by mail-io1-f70.google.com with SMTP id l22so27198413iom.4
        for <io-uring@vger.kernel.org>; Sun, 17 Jan 2021 20:27:43 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:date:in-reply-to:message-id:subject
         :from:to;
        bh=qC8G0IPXg9beaQej+tLqh5V/dMR/FwgnyQdMvOOVq98=;
        b=Cf9krTz9/2pkymzR+nWwRTwLzV6ye8D9edbjHrtT4bevSkHHOQBktKGUctCeihtp+D
         RFMPopAccQc/8wgFkrJ1GeLU8MkCyei30gMSDgVkaKY9gC5TheA1/DhWJk25G+Hy/6aa
         Hr2DHOI8c+r36/Hb9qfxSeB/C3H3/0sS6oVE5ASqmPmXQfTjRRCoha/6MpikbYMWm/Qc
         8qI+Q5kEELbb6+kRWkrQoAjqOCDWQtKo0m5JTBTTIO5JnQoYimeas1xtOYVnL+Zf01tC
         v7gAGKOuuZ/LvP+D59vgy+oEaOL2gHOuqQkSZIby7QveqIHGP+Fw4VlV1i6Qn3l20N8l
         HODQ==
X-Gm-Message-State: AOAM530EorDK2bKyBvfX2AYG7zgqf8HtzJwgc47sj6dlI8buvE3klxUe
        GU75QGwdt9mudPPv6H16VX7lXql5VFE89HLTOHBc0TtTtrRu
X-Google-Smtp-Source: ABdhPJxcjLG96jCODEMWVyf7lnLaM1Jx6ebp8DYdB5L4tSPIAZywJDtkn0sLJ8ywd+/kXYFXE0aYokKBeNSDkSIQtgcdfKIXwUoS
MIME-Version: 1.0
X-Received: by 2002:a6b:9346:: with SMTP id v67mr15981999iod.108.1610944037885;
 Sun, 17 Jan 2021 20:27:17 -0800 (PST)
Date:   Sun, 17 Jan 2021 20:27:17 -0800
In-Reply-To: <000000000000f054d005b8f87274@google.com>
X-Google-Appengine-App-Id: s~syzkaller
X-Google-Appengine-App-Id-Alias: syzkaller
Message-ID: <000000000000219cec05b9252334@google.com>
Subject: Re: WARNING in io_disable_sqo_submit
From:   syzbot <syzbot+2f5d1785dc624932da78@syzkaller.appspotmail.com>
To:     asml.silence@gmail.com, axboe@kernel.dk, hdanton@sina.com,
        io-uring@vger.kernel.org, linux-fsdevel@vger.kernel.org,
        linux-kernel@vger.kernel.org, syzkaller-bugs@googlegroups.com,
        viro@zeniv.linux.org.uk
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org

syzbot has found a reproducer for the following issue on:

HEAD commit:    a1339d63 Merge tag 'powerpc-5.11-4' of git://git.kernel.or..
git tree:       upstream
console output: https://syzkaller.appspot.com/x/log.txt?x=17532a58d00000
kernel config:  https://syzkaller.appspot.com/x/.config?x=c60c9ff9cc916cbc
dashboard link: https://syzkaller.appspot.com/bug?extid=2f5d1785dc624932da78
compiler:       gcc (GCC) 10.1.0-syz 20200507
syz repro:      https://syzkaller.appspot.com/x/repro.syz?x=10f207c7500000

IMPORTANT: if you fix the issue, please add the following tag to the commit:
Reported-by: syzbot+2f5d1785dc624932da78@syzkaller.appspotmail.com

------------[ cut here ]------------
WARNING: CPU: 0 PID: 9113 at fs/io_uring.c:8917 io_disable_sqo_submit+0x13d/0x180 fs/io_uring.c:8917
Modules linked in:
CPU: 1 PID: 9113 Comm: syz-executor.0 Not tainted 5.11.0-rc3-syzkaller #0
Hardware name: Google Google Compute Engine/Google Compute Engine, BIOS Google 01/01/2011
RIP: 0010:io_disable_sqo_submit+0x13d/0x180 fs/io_uring.c:8917
Code: e0 07 83 c0 03 38 d0 7c 04 84 d2 75 2e 83 8b 14 01 00 00 01 4c 89 e7 e8 31 0a 24 07 5b 5d 41 5c e9 98 e1 9a ff e8 93 e1 9a ff <0f> 0b e9 00 ff ff ff e8 a7 a1 dd ff e9 37 ff ff ff e8 6d a1 dd ff
RSP: 0018:ffffc9000311fe98 EFLAGS: 00010293
RAX: 0000000000000000 RBX: ffff888024b43000 RCX: 0000000000000000
RDX: ffff888147071bc0 RSI: ffffffff81d7e82d RDI: ffff888024b430d0
RBP: ffff8880115d1900 R08: 0000000000000000 R09: 0000000014555c01
R10: ffffffff81d7eae5 R11: 0000000000000001 R12: ffff888024b43000
R13: ffff888014555c01 R14: ffff888024b43040 R15: ffff888024b430d0
FS:  00007f85abf55700(0000) GS:ffff8880b9e00000(0000) knlGS:0000000000000000
CS:  0010 DS: 0000 ES: 0000 CR0: 0000000080050033
CR2: 00007fd3adeb5000 CR3: 00000000115d2000 CR4: 0000000000350ef0
Call Trace:
 io_uring_flush+0x28b/0x3a0 fs/io_uring.c:9134
 filp_close+0xb4/0x170 fs/open.c:1280
 close_fd+0x5c/0x80 fs/file.c:626
 __do_sys_close fs/open.c:1299 [inline]
 __se_sys_close fs/open.c:1297 [inline]
 __x64_sys_close+0x2f/0xa0 fs/open.c:1297
 do_syscall_64+0x2d/0x70 arch/x86/entry/common.c:46
 entry_SYSCALL_64_after_hwframe+0x44/0xa9
RIP: 0033:0x45e219
Code: 0d b4 fb ff c3 66 2e 0f 1f 84 00 00 00 00 00 66 90 48 89 f8 48 89 f7 48 89 d6 48 89 ca 4d 89 c2 4d 89 c8 4c 8b 4c 24 08 0f 05 <48> 3d 01 f0 ff ff 0f 83 db b3 fb ff c3 66 2e 0f 1f 84 00 00 00 00
RSP: 002b:00007f85abf54c68 EFLAGS: 00000246 ORIG_RAX: 0000000000000003
RAX: ffffffffffffffda RBX: 0000000000000001 RCX: 000000000045e219
RDX: 0000000000000000 RSI: 0000000000000000 RDI: 0000000000000004
RBP: 000000000119bfb0 R08: 0000000000000000 R09: 0000000000000000
R10: 0000000000000000 R11: 0000000000000246 R12: 000000000119bf8c
R13: 00007ffe5217973f R14: 00007f85abf559c0 R15: 000000000119bf8c

