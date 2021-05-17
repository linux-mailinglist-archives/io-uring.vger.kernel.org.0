Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id F169B382828
	for <lists+io-uring@lfdr.de>; Mon, 17 May 2021 11:22:43 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235899AbhEQJX5 (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Mon, 17 May 2021 05:23:57 -0400
Received: from mail-il1-f198.google.com ([209.85.166.198]:33603 "EHLO
        mail-il1-f198.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S235848AbhEQJXh (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Mon, 17 May 2021 05:23:37 -0400
Received: by mail-il1-f198.google.com with SMTP id l6-20020a056e021c06b02901b9680ed93eso5884993ilh.0
        for <io-uring@vger.kernel.org>; Mon, 17 May 2021 02:22:21 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:date:message-id:subject:from:to;
        bh=yAxZuY0U2cxZ6bvTIN15+rDW7/ewWTfpsgQL4WqX9ms=;
        b=EyQb5SRPvuJPqpIpDseUtk0YAFduoMN5v/vmD8BmXsydOHnUL9wR7BE5J/PK0J0lck
         zRM0byRz8ofiwdfOgnQNY3K0IHM4/rXhURx4vmtIzMLIw/t7npDjbeOH6mpEkF3FzLcy
         2+3isYVoM7nRI3xFJz/LK+40VcPAW2EaFonp+3IotDPF5TPRgNyBkI4uwz271VcOK/xU
         aXIUmoHpVPy1FbWBN43Y7DoQArmeTQlsrAp6BcOSAvcHeqt+t9ohcjx93kjW5Fyke8Uu
         9JbGtWUMzLayU5MRvsRLHS+l0Ga7nfiQIrOB73ny5xwEv8u3JqOpQxzvw0dK/yoGWOlj
         Z8Cg==
X-Gm-Message-State: AOAM533I33I+KYExpeGYycIKL+FNgTNVQL3IqgzJhg0gNXaZ8yoaaDVB
        GD+aVOnOEs+hn7olw4szYJcQUKUhXfuobmjmPKrLb1lpptLG
X-Google-Smtp-Source: ABdhPJz9CSKyRhbSWSGpLb9XVQ1yIkEjwHD/sYkpDiMuvDyxrAiq7P40TolPjqHSvE1+eWqnUJU+pDiyQsagwDZy1gw3qyMrL/5c
MIME-Version: 1.0
X-Received: by 2002:a5d:9d47:: with SMTP id k7mr4108138iok.79.1621243340702;
 Mon, 17 May 2021 02:22:20 -0700 (PDT)
Date:   Mon, 17 May 2021 02:22:20 -0700
X-Google-Appengine-App-Id: s~syzkaller
X-Google-Appengine-App-Id-Alias: syzkaller
Message-ID: <0000000000006acb3105c28321f7@google.com>
Subject: [syzbot] BUG: unable to handle kernel paging request in corrupted (3)
From:   syzbot <syzbot+a84b8783366ecb1c65d0@syzkaller.appspotmail.com>
To:     asml.silence@gmail.com, axboe@kernel.dk, io-uring@vger.kernel.org,
        linux-kernel@vger.kernel.org, syzkaller-bugs@googlegroups.com
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org

Hello,

syzbot found the following issue on:

HEAD commit:    88b06399 Merge tag 'for-5.13-rc1-part2-tag' of git://git.k..
git tree:       upstream
console output: https://syzkaller.appspot.com/x/log.txt?x=11aa7a65d00000
kernel config:  https://syzkaller.appspot.com/x/.config?x=807beec6b4d66bf1
dashboard link: https://syzkaller.appspot.com/bug?extid=a84b8783366ecb1c65d0
syz repro:      https://syzkaller.appspot.com/x/repro.syz?x=16a031b3d00000
C reproducer:   https://syzkaller.appspot.com/x/repro.c?x=12fc54fdd00000

The issue was bisected to:

commit ea6a693d862d4f0edd748a1fa3fc6faf2c39afb2
Author: Jens Axboe <axboe@kernel.dk>
Date:   Thu Apr 15 15:47:13 2021 +0000

    io_uring: disable multishot poll for double poll add cases

bisection log:  https://syzkaller.appspot.com/x/bisect.txt?x=104b5795d00000
final oops:     https://syzkaller.appspot.com/x/report.txt?x=124b5795d00000
console output: https://syzkaller.appspot.com/x/log.txt?x=144b5795d00000

IMPORTANT: if you fix the issue, please add the following tag to the commit:
Reported-by: syzbot+a84b8783366ecb1c65d0@syzkaller.appspotmail.com
Fixes: ea6a693d862d ("io_uring: disable multishot poll for double poll add cases")

BUG: unable to handle page fault for address: ffffffffc1defce0
#PF: supervisor instruction fetch in kernel mode
#PF: error_code(0x0010) - not-present page
PGD bc8f067 P4D bc8f067 PUD bc91067 PMD 0 
Oops: 0010 [#1] PREEMPT SMP KASAN
CPU: 1 PID: 8479 Comm: iou-wrk-8440 Not tainted 5.13.0-rc1-syzkaller #0
Hardware name: Google Google Compute Engine/Google Compute Engine, BIOS Google 01/01/2011
RIP: 0010:0xffffffffc1defce0
Code: Unable to access opcode bytes at RIP 0xffffffffc1defcb6.
RSP: 0018:ffffc9000161f8f8 EFLAGS: 00010246
RAX: ffffffffc1defce0 RBX: 0000000000000000 RCX: 0000000000000000
RDX: 0000000000000000 RSI: 0000000000000000 RDI: ffff8880187eb8c0
RBP: ffff8880187eb8c0 R08: 0000000000000000 R09: 0000000000002000
R10: ffffffff81df1723 R11: 0000000000004000 R12: 0000000000000000
R13: ffff8880187eb918 R14: ffff8880187eb900 R15: ffffffffc1defce0
FS:  0000000001212300(0000) GS:ffff8880b9d00000(0000) knlGS:0000000000000000
CS:  0010 DS: 0000 ES: 0000 CR0: 0000000080050033
CR2: ffffffffc1defcb6 CR3: 00000000139d9000 CR4: 00000000001506e0
DR0: 0000000000000000 DR1: 0000000000000000 DR2: 0000000000000000
DR3: 0000000000000000 DR6: 00000000fffe0ff0 DR7: 0000000000000400
Call Trace:
Modules linked in:
CR2: ffffffffc1defce0
---[ end trace a41da77ef833bc79 ]---
RIP: 0010:0xffffffffc1defce0
Code: Unable to access opcode bytes at RIP 0xffffffffc1defcb6.
RSP: 0018:ffffc9000161f8f8 EFLAGS: 00010246
RAX: ffffffffc1defce0 RBX: 0000000000000000 RCX: 0000000000000000
RDX: 0000000000000000 RSI: 0000000000000000 RDI: ffff8880187eb8c0
RBP: ffff8880187eb8c0 R08: 0000000000000000 R09: 0000000000002000
R10: ffffffff81df1723 R11: 0000000000004000 R12: 0000000000000000
R13: ffff8880187eb918 R14: ffff8880187eb900 R15: ffffffffc1defce0
FS:  0000000001212300(0000) GS:ffff8880b9d00000(0000) knlGS:0000000000000000
CS:  0010 DS: 0000 ES: 0000 CR0: 0000000080050033
CR2: ffffffffc1defcb6 CR3: 00000000139d9000 CR4: 00000000001506e0
DR0: 0000000000000000 DR1: 0000000000000000 DR2: 0000000000000000
DR3: 0000000000000000 DR6: 00000000fffe0ff0 DR7: 0000000000000400


---
This report is generated by a bot. It may contain errors.
See https://goo.gl/tpsmEJ for more information about syzbot.
syzbot engineers can be reached at syzkaller@googlegroups.com.

syzbot will keep track of this issue. See:
https://goo.gl/tpsmEJ#status for how to communicate with syzbot.
For information about bisection process see: https://goo.gl/tpsmEJ#bisection
syzbot can test patches for this issue, for details see:
https://goo.gl/tpsmEJ#testing-patches
