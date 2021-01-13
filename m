Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id EA3592F48CA
	for <lists+io-uring@lfdr.de>; Wed, 13 Jan 2021 11:41:51 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727364AbhAMKh4 (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Wed, 13 Jan 2021 05:37:56 -0500
Received: from mail-io1-f70.google.com ([209.85.166.70]:47264 "EHLO
        mail-io1-f70.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727171AbhAMKh4 (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Wed, 13 Jan 2021 05:37:56 -0500
Received: by mail-io1-f70.google.com with SMTP id q21so2111536ios.14
        for <io-uring@vger.kernel.org>; Wed, 13 Jan 2021 02:37:40 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:date:message-id:subject:from:to;
        bh=7GNOF7qGFDGf5o1lpOvQ+1SohtcKvm00Mky/7K1AHxw=;
        b=EpiPAwiw4t5YB/fuhWBWt0MS1c5Zp3HjK6gmQUMikY8naNM9Fz54OcelwRo5+N7PzD
         68Q7RIt37D2oR4IIkQKE6uEy0MDUMuIyBggEmafXqCImmX09vsSL+cMLRPK6NaRRyF2N
         LiHsNoXNNgEsK8pg0278OoiN4QARWQlRnihWoeQd7QOTtXAx23vq1qazSb5z/MZG6hgU
         VwmT40LwgYbhW4l/KRTjaVwYJo0/bXXnfap/7C6BSslGTYH60AHuGtQKuJKCt+nx7XBT
         H6YUyVkM5TYOJXy/WrJZajQhv9lrvgbqco3FohMPn5+SLF+wyNlgdwtiyHb6TEYNQA4A
         E9Gw==
X-Gm-Message-State: AOAM530sevGCEd/vlYeW3v300MgDXaApHsdQZapcyJ7M4naaKPtziqky
        lAm3g/kuKFmONex9EpDPXkLAaUKgfl+4t6TxpfmSqhA4xiHa
X-Google-Smtp-Source: ABdhPJxaeiud9TqE/DpYaNNIkh0RBsmcxZRfcaXobByCwqOcJ38Ly1rrrgGGLoswHJ0aGguf/8Oer9fDTGtLL03jmZfBy+0UR+Pr
MIME-Version: 1.0
X-Received: by 2002:a6b:9346:: with SMTP id v67mr1054121iod.108.1610534235432;
 Wed, 13 Jan 2021 02:37:15 -0800 (PST)
Date:   Wed, 13 Jan 2021 02:37:15 -0800
X-Google-Appengine-App-Id: s~syzkaller
X-Google-Appengine-App-Id-Alias: syzkaller
Message-ID: <000000000000006c2105b8c5b9b9@google.com>
Subject: general protection fault in io_disable_sqo_submit
From:   syzbot <syzbot+ab412638aeb652ded540@syzkaller.appspotmail.com>
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
console output: https://syzkaller.appspot.com/x/log.txt?x=1606a757500000
kernel config:  https://syzkaller.appspot.com/x/.config?x=c60c9ff9cc916cbc
dashboard link: https://syzkaller.appspot.com/bug?extid=ab412638aeb652ded540
compiler:       gcc (GCC) 10.1.0-syz 20200507
syz repro:      https://syzkaller.appspot.com/x/repro.syz?x=13adb0d0d00000
C reproducer:   https://syzkaller.appspot.com/x/repro.c?x=1527be48d00000

The issue was bisected to:

commit d9d05217cb6990b9a56e13b56e7a1b71e2551f6c
Author: Pavel Begunkov <asml.silence@gmail.com>
Date:   Fri Jan 8 20:57:25 2021 +0000

    io_uring: stop SQPOLL submit on creator's death

bisection log:  https://syzkaller.appspot.com/x/bisect.txt?x=17b3b248d00000
final oops:     https://syzkaller.appspot.com/x/report.txt?x=1473b248d00000
console output: https://syzkaller.appspot.com/x/log.txt?x=1073b248d00000

IMPORTANT: if you fix the issue, please add the following tag to the commit:
Reported-by: syzbot+ab412638aeb652ded540@syzkaller.appspotmail.com
Fixes: d9d05217cb69 ("io_uring: stop SQPOLL submit on creator's death")

RDX: 0000000000000001 RSI: 0000000020000300 RDI: 00000000000000ff
RBP: 0000000000011fc2 R08: 0000000000000001 R09: 00000000004002c8
R10: 0000000000000000 R11: 0000000000000246 R12: 00000000004021d0
R13: 0000000000402260 R14: 0000000000000000 R15: 0000000000000000
general protection fault, probably for non-canonical address 0xdffffc0000000022: 0000 [#1] PREEMPT SMP KASAN
KASAN: null-ptr-deref in range [0x0000000000000110-0x0000000000000117]
CPU: 1 PID: 8473 Comm: syz-executor814 Not tainted 5.11.0-rc3-syzkaller #0
Hardware name: Google Google Compute Engine/Google Compute Engine, BIOS Google 01/01/2011
RIP: 0010:io_ring_set_wakeup_flag fs/io_uring.c:6929 [inline]
RIP: 0010:io_disable_sqo_submit+0xdb/0x130 fs/io_uring.c:8891
Code: fa 48 c1 ea 03 80 3c 02 00 75 62 48 8b 9b c0 00 00 00 48 b8 00 00 00 00 00 fc ff df 48 8d bb 14 01 00 00 48 89 fa 48 c1 ea 03 <0f> b6 14 02 48 89 f8 83 e0 07 83 c0 03 38 d0 7c 04 84 d2 75 1d 83
RSP: 0018:ffffc9000154fd78 EFLAGS: 00010007
RAX: dffffc0000000000 RBX: 0000000000000000 RCX: ffffffff815976e0
RDX: 0000000000000022 RSI: 0000000000000004 RDI: 0000000000000114
RBP: ffff8880149ee480 R08: 0000000000000001 R09: 0000000000000003
R10: fffff520002a9fa1 R11: 1ffffffff1d308df R12: fffffffffffffff4
R13: 0000000000000001 R14: ffff8880149ee054 R15: ffff8880149ee000
FS:  0000000000be4880(0000) GS:ffff8880b9f00000(0000) knlGS:0000000000000000
CS:  0010 DS: 0000 ES: 0000 CR0: 0000000080050033
CR2: 0000000020000304 CR3: 0000000014b50000 CR4: 00000000001506e0
DR0: 0000000000000000 DR1: 0000000000000000 DR2: 0000000000000000
DR3: 0000000000000000 DR6: 00000000fffe0ff0 DR7: 0000000000000400
Call Trace:
 io_uring_create fs/io_uring.c:9711 [inline]
 io_uring_setup+0x12b1/0x38e0 fs/io_uring.c:9739
 do_syscall_64+0x2d/0x70 arch/x86/entry/common.c:46
 entry_SYSCALL_64_after_hwframe+0x44/0xa9
RIP: 0033:0x441309
Code: e8 5c ae 02 00 48 83 c4 18 c3 0f 1f 80 00 00 00 00 48 89 f8 48 89 f7 48 89 d6 48 89 ca 4d 89 c2 4d 89 c8 4c 8b 4c 24 08 0f 05 <48> 3d 01 f0 ff ff 0f 83 3b 0a fc ff c3 66 2e 0f 1f 84 00 00 00 00
RSP: 002b:00007ffea5e64578 EFLAGS: 00000246 ORIG_RAX: 00000000000001a9
RAX: ffffffffffffffda RBX: 0000000000000000 RCX: 0000000000441309
RDX: 0000000000000001 RSI: 0000000020000300 RDI: 00000000000000ff
RBP: 0000000000011fc2 R08: 0000000000000001 R09: 00000000004002c8
R10: 0000000000000000 R11: 0000000000000246 R12: 00000000004021d0
R13: 0000000000402260 R14: 0000000000000000 R15: 0000000000000000
Modules linked in:
---[ end trace 0941172fec2041bb ]---
RIP: 0010:io_ring_set_wakeup_flag fs/io_uring.c:6929 [inline]
RIP: 0010:io_disable_sqo_submit+0xdb/0x130 fs/io_uring.c:8891
Code: fa 48 c1 ea 03 80 3c 02 00 75 62 48 8b 9b c0 00 00 00 48 b8 00 00 00 00 00 fc ff df 48 8d bb 14 01 00 00 48 89 fa 48 c1 ea 03 <0f> b6 14 02 48 89 f8 83 e0 07 83 c0 03 38 d0 7c 04 84 d2 75 1d 83
RSP: 0018:ffffc9000154fd78 EFLAGS: 00010007
RAX: dffffc0000000000 RBX: 0000000000000000 RCX: ffffffff815976e0
RDX: 0000000000000022 RSI: 0000000000000004 RDI: 0000000000000114
RBP: ffff8880149ee480 R08: 0000000000000001 R09: 0000000000000003
R10: fffff520002a9fa1 R11: 1ffffffff1d308df R12: fffffffffffffff4
R13: 0000000000000001 R14: ffff8880149ee054 R15: ffff8880149ee000
FS:  0000000000be4880(0000) GS:ffff8880b9f00000(0000) knlGS:0000000000000000
CS:  0010 DS: 0000 ES: 0000 CR0: 0000000080050033
CR2: 0000000020000304 CR3: 0000000014b50000 CR4: 00000000001506e0
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
