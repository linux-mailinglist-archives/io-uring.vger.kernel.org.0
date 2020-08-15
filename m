Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id C9F52245267
	for <lists+io-uring@lfdr.de>; Sat, 15 Aug 2020 23:50:51 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726772AbgHOVut (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Sat, 15 Aug 2020 17:50:49 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:45598 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1728236AbgHOVun (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Sat, 15 Aug 2020 17:50:43 -0400
Received: from mail-io1-xd45.google.com (mail-io1-xd45.google.com [IPv6:2607:f8b0:4864:20::d45])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id E3A5FC0A88B8
        for <io-uring@vger.kernel.org>; Sat, 15 Aug 2020 10:00:23 -0700 (PDT)
Received: by mail-io1-xd45.google.com with SMTP id k10so7780765iow.15
        for <io-uring@vger.kernel.org>; Sat, 15 Aug 2020 10:00:23 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:date:message-id:subject:from:to;
        bh=Mh2vQL3nRBAlnAPp8z2LGMEgL0fvTMye3F0Sdv/V8c4=;
        b=NFsSHo/CBS7o3kabITvsOEEu0EzN2J0+W5nW5FHqKYY1ITFsFIhrj9wBZrxkrJaNqa
         vcuZSMgGQ8KIcz1Akq+mZwzpQJgq+ylBMVNXZDd1QirRbpNgOGqQEM/VrBYqAVD00BPj
         HiqIwu4EL+UL6hcsGQakEzfAQvtk/wHB20vX6keeXwHWtBGifOhJcgl+GXCUsgHQ/U2s
         8OY4ZB8NHCkIcIGNle/W8LdjaXhRv2Ai24lT+GREUvgpQtLVbLn1GyNHQM2RRX2D72dR
         hzrYkey+IWJtSpoZLQf1ap9cSgjaEtOb+jxwKWBcdPVES2GT4ewJMih7NL1MWYE7Ik6y
         OTmw==
X-Gm-Message-State: AOAM532Y2lRsme4dlmpP6q0oJk4Xa5DInaxXLokvIqVevHICVKEGMdeN
        6BRtW+bG1Bci2KyzhPQO2jgvEEmuxLelLN4L+E12UYWSud1l
X-Google-Smtp-Source: ABdhPJzYyX274OX+l37DAqsUHvwTM1HpTiSokWdE2OgfUedsairrIn4fwpGyYcMtJA4kqyI06NGJa+9Z4lGRakde0IBTseGBbLAO
MIME-Version: 1.0
X-Received: by 2002:a6b:5d05:: with SMTP id r5mr6221528iob.14.1597510822456;
 Sat, 15 Aug 2020 10:00:22 -0700 (PDT)
Date:   Sat, 15 Aug 2020 10:00:22 -0700
X-Google-Appengine-App-Id: s~syzkaller
X-Google-Appengine-App-Id-Alias: syzkaller
Message-ID: <00000000000018f60505aced798e@google.com>
Subject: general protection fault in io_poll_double_wake
From:   syzbot <syzbot+7f617d4a9369028b8a2c@syzkaller.appspotmail.com>
To:     axboe@kernel.dk, io-uring@vger.kernel.org,
        linux-fsdevel@vger.kernel.org, linux-kernel@vger.kernel.org,
        syzkaller-bugs@googlegroups.com, viro@zeniv.linux.org.uk
Content-Type: text/plain; charset="UTF-8"
Sender: io-uring-owner@vger.kernel.org
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org

Hello,

syzbot found the following issue on:

HEAD commit:    7fca4dee Merge tag 'powerpc-5.9-2' of git://git.kernel.org..
git tree:       upstream
console output: https://syzkaller.appspot.com/x/log.txt?x=1264d116900000
kernel config:  https://syzkaller.appspot.com/x/.config?x=21f0d1d2df6d5fc
dashboard link: https://syzkaller.appspot.com/bug?extid=7f617d4a9369028b8a2c
compiler:       clang version 10.0.0 (https://github.com/llvm/llvm-project/ c2443155a0fb245c8f17f2c1c72b6ea391e86e81)
syz repro:      https://syzkaller.appspot.com/x/repro.syz?x=10f211d2900000
C reproducer:   https://syzkaller.appspot.com/x/repro.c?x=1721b0ce900000

The issue was bisected to:

commit 18bceab101adde8f38de76016bc77f3f25cf22f4
Author: Jens Axboe <axboe@kernel.dk>
Date:   Fri May 15 17:56:54 2020 +0000

    io_uring: allow POLL_ADD with double poll_wait() users

bisection log:  https://syzkaller.appspot.com/x/bisect.txt?x=1498125e900000
final oops:     https://syzkaller.appspot.com/x/report.txt?x=1698125e900000
console output: https://syzkaller.appspot.com/x/log.txt?x=1298125e900000

IMPORTANT: if you fix the issue, please add the following tag to the commit:
Reported-by: syzbot+7f617d4a9369028b8a2c@syzkaller.appspotmail.com
Fixes: 18bceab101ad ("io_uring: allow POLL_ADD with double poll_wait() users")

general protection fault, probably for non-canonical address 0xdffffc0000000008: 0000 [#1] PREEMPT SMP KASAN
KASAN: null-ptr-deref in range [0x0000000000000040-0x0000000000000047]
CPU: 0 PID: 6842 Comm: syz-executor006 Not tainted 5.8.0-syzkaller #0
Hardware name: Google Google Compute Engine/Google Compute Engine, BIOS Google 01/01/2011
RIP: 0010:io_poll_double_wake+0x6b/0x360 fs/io_uring.c:4589
Code: 8d 9d b8 00 00 00 48 89 d8 48 c1 e8 03 42 80 3c 20 00 74 08 48 89 df e8 53 64 de ff 48 8b 1b 48 83 c3 40 48 89 d8 48 c1 e8 03 <42> 80 3c 20 00 74 08 48 89 df e8 36 64 de ff 4c 8b 33 31 ff 44 89
RSP: 0018:ffffc90001717b20 EFLAGS: 00010002
RAX: 0000000000000008 RBX: 0000000000000040 RCX: ffff88809e0fe4c0
RDX: 0000000000000000 RSI: 0000000000000001 RDI: ffff8880a2e7dc98
RBP: ffff8880a2e7dc98 R08: 0000000000000000 R09: ffffc90001717be8
R10: fffff520002e2f70 R11: 0000000000000000 R12: dffffc0000000000
R13: ffff88809a429e40 R14: 0000000000000000 R15: 0000000000000000
FS:  0000000002640880(0000) GS:ffff8880ae800000(0000) knlGS:0000000000000000
CS:  0010 DS: 0000 ES: 0000 CR0: 0000000080050033
CR2: 00007f2629c956c0 CR3: 000000009e4e7000 CR4: 00000000001506f0
DR0: 0000000000000000 DR1: 0000000000000000 DR2: 0000000000000000
DR3: 0000000000000000 DR6: 00000000fffe0ff0 DR7: 0000000000000400
Call Trace:
 __wake_up_common+0x30a/0x4e0 kernel/sched/wait.c:93
 __wake_up_common_lock kernel/sched/wait.c:123 [inline]
 __wake_up+0xd4/0x150 kernel/sched/wait.c:142
 n_tty_set_termios+0xa60/0x1080 drivers/tty/n_tty.c:1874
 tty_set_termios+0xcac/0x1510 drivers/tty/tty_ioctl.c:341
 set_termios+0x4a1/0x580 drivers/tty/tty_ioctl.c:414
 tty_mode_ioctl+0x7b2/0xa80 drivers/tty/tty_ioctl.c:770
 tty_ioctl+0xf81/0x15c0 drivers/tty/tty_io.c:2665
 vfs_ioctl fs/ioctl.c:48 [inline]
 __do_sys_ioctl fs/ioctl.c:753 [inline]
 __se_sys_ioctl+0xfb/0x170 fs/ioctl.c:739
 do_syscall_64+0x31/0x70 arch/x86/entry/common.c:46
 entry_SYSCALL_64_after_hwframe+0x44/0xa9
RIP: 0033:0x4405d9
Code: 18 89 d0 c3 66 2e 0f 1f 84 00 00 00 00 00 0f 1f 00 48 89 f8 48 89 f7 48 89 d6 48 89 ca 4d 89 c2 4d 89 c8 4c 8b 4c 24 08 0f 05 <48> 3d 01 f0 ff ff 0f 83 db 13 fc ff c3 66 2e 0f 1f 84 00 00 00 00
RSP: 002b:00007ffe5f581ef8 EFLAGS: 00000246 ORIG_RAX: 0000000000000010
RAX: ffffffffffffffda RBX: 0000000000401ed0 RCX: 00000000004405d9
RDX: 0000000020000080 RSI: 0000000000005404 RDI: 0000000000000004
RBP: 00000000006ca018 R08: 0000000000000000 R09: 0000000000000000
R10: 0000000000003e69 R11: 0000000000000246 R12: 0000000000401e40
R13: 0000000000401ed0 R14: 0000000000000000 R15: 0000000000000000
Modules linked in:
---[ end trace 9d629bc7ccf35892 ]---
RIP: 0010:io_poll_double_wake+0x6b/0x360 fs/io_uring.c:4589
Code: 8d 9d b8 00 00 00 48 89 d8 48 c1 e8 03 42 80 3c 20 00 74 08 48 89 df e8 53 64 de ff 48 8b 1b 48 83 c3 40 48 89 d8 48 c1 e8 03 <42> 80 3c 20 00 74 08 48 89 df e8 36 64 de ff 4c 8b 33 31 ff 44 89
RSP: 0018:ffffc90001717b20 EFLAGS: 00010002
RAX: 0000000000000008 RBX: 0000000000000040 RCX: ffff88809e0fe4c0
RDX: 0000000000000000 RSI: 0000000000000001 RDI: ffff8880a2e7dc98
RBP: ffff8880a2e7dc98 R08: 0000000000000000 R09: ffffc90001717be8
R10: fffff520002e2f70 R11: 0000000000000000 R12: dffffc0000000000
R13: ffff88809a429e40 R14: 0000000000000000 R15: 0000000000000000
FS:  0000000002640880(0000) GS:ffff8880ae800000(0000) knlGS:0000000000000000
CS:  0010 DS: 0000 ES: 0000 CR0: 0000000080050033
CR2: 00007f2629c956c0 CR3: 000000009e4e7000 CR4: 00000000001506f0
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
