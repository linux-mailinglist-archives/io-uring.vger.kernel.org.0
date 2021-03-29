Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id C25D034C508
	for <lists+io-uring@lfdr.de>; Mon, 29 Mar 2021 09:35:18 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231126AbhC2Heo (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Mon, 29 Mar 2021 03:34:44 -0400
Received: from mail-io1-f69.google.com ([209.85.166.69]:45710 "EHLO
        mail-io1-f69.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230224AbhC2HeT (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Mon, 29 Mar 2021 03:34:19 -0400
Received: by mail-io1-f69.google.com with SMTP id n13so10252621ioh.12
        for <io-uring@vger.kernel.org>; Mon, 29 Mar 2021 00:34:18 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:date:message-id:subject:from:to;
        bh=6nMBPjQoE5iHToTiMAu4u9310U6VWR1t5o9JInSRs9s=;
        b=q1af5Lcoyz+HL4OJmp5+//wI8XC7UgSwWP1dPBAW+Wuu10lDjGTCkgvVjSOriEDCSy
         qnuE2pafBuNu7HkfLkceyMKiOjj2Qx0sNo9Ggx7uKDeSWKCQ49YDekOB50b3UKrspRBP
         ku8c6UhgLUDbqOu0aZwVwyPZsE7NWzKUoUo2GRNmCKlG3KA2QAgrR55ETrQiqthTD1rV
         Cjjo925XYmE9p+zpaEUIJFjRCZdgWBKyM3pdZoQB80MGB6V9CsAoiG4FKsAyLowE4kKQ
         dqjCQBbS19WCNjreaSON1w9D4DG2XMKlj0ILtcKKGYZ9pqa0d1fp3McarDHKeZVA5G3Z
         BMLw==
X-Gm-Message-State: AOAM531Ex8NSzdQ6CdaO3nMJ8g91gxLJuE04oHA7/Gu5jRJUcrYCewAb
        4w8hVhWHQJbZDDZ0VvQzMB2LIUQaH1TuonfWEapzQ+w6HSgu
X-Google-Smtp-Source: ABdhPJwdL/IYYrRcO+yUnQ2A2cK5EhVwQjgZEKggFvEeML0cInp7Mt7eMkmUBr29k25aE5EefqYzV+KXir++TJ1fNnDQRSmp1Grk
MIME-Version: 1.0
X-Received: by 2002:a05:6602:184c:: with SMTP id d12mr19247097ioi.8.1617003258247;
 Mon, 29 Mar 2021 00:34:18 -0700 (PDT)
Date:   Mon, 29 Mar 2021 00:34:18 -0700
X-Google-Appengine-App-Id: s~syzkaller
X-Google-Appengine-App-Id-Alias: syzkaller
Message-ID: <000000000000cefea605bea7e8c3@google.com>
Subject: [syzbot] general protection fault in io_commit_cqring (2)
From:   syzbot <syzbot+0e905eb8228070c457a0@syzkaller.appspotmail.com>
To:     asml.silence@gmail.com, axboe@kernel.dk, io-uring@vger.kernel.org,
        linux-kernel@vger.kernel.org, syzkaller-bugs@googlegroups.com
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org

Hello,

syzbot found the following issue on:

HEAD commit:    81b1d39f Merge tag '5.12-rc4-smb3' of git://git.samba.org/..
git tree:       upstream
console output: https://syzkaller.appspot.com/x/log.txt?x=10ce6fe6d00000
kernel config:  https://syzkaller.appspot.com/x/.config?x=daeff30c2474a60f
dashboard link: https://syzkaller.appspot.com/bug?extid=0e905eb8228070c457a0
syz repro:      https://syzkaller.appspot.com/x/repro.syz?x=10e0ed06d00000
C reproducer:   https://syzkaller.appspot.com/x/repro.c?x=1144754ed00000

IMPORTANT: if you fix the issue, please add the following tag to the commit:
Reported-by: syzbot+0e905eb8228070c457a0@syzkaller.appspotmail.com

RBP: 00007ffe05a7c220 R08: 0000000000000001 R09: 0000000000000001
R10: 0000000000000000 R11: 0000000000000246 R12: 0000000000000003
R13: 431bde82d7b634db R14: 00000000004ae018 R15: 0000000000400488
general protection fault, probably for non-canonical address 0xdffffc0000000018: 0000 [#1] PREEMPT SMP KASAN
KASAN: null-ptr-deref in range [0x00000000000000c0-0x00000000000000c7]
CPU: 1 PID: 8400 Comm: syz-executor278 Not tainted 5.12.0-rc4-syzkaller #0
Hardware name: Google Google Compute Engine/Google Compute Engine, BIOS Google 01/01/2011
RIP: 0010:io_commit_cqring+0x37f/0xc10 fs/io_uring.c:1318
Code: 74 08 3c 03 0f 8e fa 05 00 00 48 8d bb c0 00 00 00 41 8b ac 24 00 06 00 00 48 b8 00 00 00 00 00 fc ff df 48 89 fa 48 c1 ea 03 <0f> b6 14 02 48 89 f8 83 e0 07 83 c0 03 38 d0 7c 08 84 d2 0f 85 b7
RSP: 0018:ffffc90001c1fc78 EFLAGS: 00010006
RAX: dffffc0000000000 RBX: 0000000000000000 RCX: 0000000000000000
RDX: 0000000000000018 RSI: ffffffff81db8861 RDI: 00000000000000c0
RBP: 0000000000000000 R08: 0000000000000001 R09: 0000000000000003
R10: fffff52000383f8f R11: 0000000000000000 R12: ffff888018166000
R13: 0000000000000000 R14: 1ffff92000383fab R15: ffff8880181660c0
FS:  00000000006c7300(0000) GS:ffff8880b9d00000(0000) knlGS:0000000000000000
CS:  0010 DS: 0000 ES: 0000 CR0: 0000000080050033
CR2: 00007fd3db1886c0 CR3: 0000000021099000 CR4: 00000000001506e0
DR0: 0000000000000000 DR1: 0000000000000000 DR2: 0000000000000000
DR3: 0000000000000000 DR6: 00000000fffe0ff0 DR7: 0000000000000400
Call Trace:
 io_kill_timeouts+0x2b5/0x320 fs/io_uring.c:8606
 io_ring_ctx_wait_and_kill+0x1da/0x400 fs/io_uring.c:8629
 io_uring_create fs/io_uring.c:9572 [inline]
 io_uring_setup+0x10da/0x2ae0 fs/io_uring.c:9599
 do_syscall_64+0x2d/0x70 arch/x86/entry/common.c:46
 entry_SYSCALL_64_after_hwframe+0x44/0xae
RIP: 0033:0x43ffd9
Code: 28 00 00 00 75 05 48 83 c4 28 c3 e8 b1 14 00 00 90 48 89 f8 48 89 f7 48 89 d6 48 89 ca 4d 89 c2 4d 89 c8 4c 8b 4c 24 08 0f 05 <48> 3d 01 f0 ff ff 73 01 c3 48 c7 c1 c0 ff ff ff f7 d8 64 89 01 48
RSP: 002b:00007ffe05a7c208 EFLAGS: 00000246 ORIG_RAX: 00000000000001a9
RAX: ffffffffffffffda RBX: 0000000000000001 RCX: 000000000043ffd9
RDX: 0000000000000020 RSI: 0000000020000080 RDI: 00000000000054ca
RBP: 00007ffe05a7c220 R08: 0000000000000001 R09: 0000000000000001
R10: 0000000000000000 R11: 0000000000000246 R12: 0000000000000003
R13: 431bde82d7b634db R14: 00000000004ae018 R15: 0000000000400488
Modules linked in:
---[ end trace a0b1f0cfec9b9808 ]---
RIP: 0010:io_commit_cqring+0x37f/0xc10 fs/io_uring.c:1318
Code: 74 08 3c 03 0f 8e fa 05 00 00 48 8d bb c0 00 00 00 41 8b ac 24 00 06 00 00 48 b8 00 00 00 00 00 fc ff df 48 89 fa 48 c1 ea 03 <0f> b6 14 02 48 89 f8 83 e0 07 83 c0 03 38 d0 7c 08 84 d2 0f 85 b7
RSP: 0018:ffffc90001c1fc78 EFLAGS: 00010006
RAX: dffffc0000000000 RBX: 0000000000000000 RCX: 0000000000000000
RDX: 0000000000000018 RSI: ffffffff81db8861 RDI: 00000000000000c0
RBP: 0000000000000000 R08: 0000000000000001 R09: 0000000000000003
R10: fffff52000383f8f R11: 0000000000000000 R12: ffff888018166000
R13: 0000000000000000 R14: 1ffff92000383fab R15: ffff8880181660c0
FS:  00000000006c7300(0000) GS:ffff8880b9d00000(0000) knlGS:0000000000000000
CS:  0010 DS: 0000 ES: 0000 CR0: 0000000080050033
CR2: 00007fd3db1886c0 CR3: 0000000021099000 CR4: 00000000001506e0
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
