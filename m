Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 1374A366129
	for <lists+io-uring@lfdr.de>; Tue, 20 Apr 2021 22:52:19 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233747AbhDTUwt (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Tue, 20 Apr 2021 16:52:49 -0400
Received: from mail-io1-f72.google.com ([209.85.166.72]:38445 "EHLO
        mail-io1-f72.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233548AbhDTUwt (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Tue, 20 Apr 2021 16:52:49 -0400
Received: by mail-io1-f72.google.com with SMTP id v1-20020a5d94810000b02903e0f4d732b4so13421668ioj.5
        for <io-uring@vger.kernel.org>; Tue, 20 Apr 2021 13:52:17 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:date:message-id:subject:from:to;
        bh=SSDFdmPQATpQ8OwALoRdrIkkRpUrIYF3fsT+jgsm1KA=;
        b=phpNI7A2pTl3BVibSOargF6DUZwfWsO78+dPHKunhj6IVmVz1IkBVBeoPOeQ/svWJ1
         GHWsgEpaUu3q9ZcqLjuKzWsrCeC2K3TG9Kz4ZRy4pMRBdsqL0FJoyOoprkG+mDpdiki9
         dcPxzB8RdIwt91gut6fr51IAESYo612ai89aU8TYr1a1+dpWRzoHXnM65hqzgqTWWX8q
         PeRRoq34jqQAKSzqtgCR+zgw92w8oYiGDhSksIOwadDeGS9L2NmJBilHI6b2BFKhT2ry
         xeLox/PeWLHW/ApdF+3djKUhamZVBf47IfKa6t6vGohAC5WeoBX7OCAEc7CoieGXmmt3
         +xtA==
X-Gm-Message-State: AOAM531Co3U+zPsOcWvObsHuX6y7AqmK9blWajkzW/4hMsOAq+6ed6cl
        kZ07SWSdrOcy4vUBkAww+j4jzZ5RFzG0NfYVXMOOV+CG2Hh6
X-Google-Smtp-Source: ABdhPJyxthuirBJ25x+AXLCnQ7Xx8TsrCo0cc/ijk5RspqtbIdf7dTLhV1mvG0Ht0vT/jYvgAbPlw6T/VsOhDjSFDa1P9jTbiQoV
MIME-Version: 1.0
X-Received: by 2002:a5e:8a47:: with SMTP id o7mr3313017iom.57.1618951937369;
 Tue, 20 Apr 2021 13:52:17 -0700 (PDT)
Date:   Tue, 20 Apr 2021 13:52:17 -0700
X-Google-Appengine-App-Id: s~syzkaller
X-Google-Appengine-App-Id-Alias: syzkaller
Message-ID: <00000000000022acbf05c06d9f0d@google.com>
Subject: [syzbot] WARNING in io_poll_double_wake
From:   syzbot <syzbot+f2aca089e6f77e5acd46@syzkaller.appspotmail.com>
To:     asml.silence@gmail.com, axboe@kernel.dk, io-uring@vger.kernel.org,
        linux-fsdevel@vger.kernel.org, linux-kernel@vger.kernel.org,
        syzkaller-bugs@googlegroups.com, viro@zeniv.linux.org.uk
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org

Hello,

syzbot found the following issue on:

HEAD commit:    1216f02e Add linux-next specific files for 20210415
git tree:       linux-next
console output: https://syzkaller.appspot.com/x/log.txt?x=12a322b1d00000
kernel config:  https://syzkaller.appspot.com/x/.config?x=3491b04113499f81
dashboard link: https://syzkaller.appspot.com/bug?extid=f2aca089e6f77e5acd46
syz repro:      https://syzkaller.appspot.com/x/repro.syz?x=154654c5d00000
C reproducer:   https://syzkaller.appspot.com/x/repro.c?x=102c0319d00000

The issue was bisected to:

commit b69de288e913030082bed3a324ddc58be6c1e983
Author: Jens Axboe <axboe@kernel.dk>
Date:   Wed Mar 17 14:37:41 2021 +0000

    io_uring: allow events and user_data update of running poll requests

bisection log:  https://syzkaller.appspot.com/x/bisect.txt?x=12c4b2b6d00000
final oops:     https://syzkaller.appspot.com/x/report.txt?x=11c4b2b6d00000
console output: https://syzkaller.appspot.com/x/log.txt?x=16c4b2b6d00000

IMPORTANT: if you fix the issue, please add the following tag to the commit:
Reported-by: syzbot+f2aca089e6f77e5acd46@syzkaller.appspotmail.com
Fixes: b69de288e913 ("io_uring: allow events and user_data update of running poll requests")

------------[ cut here ]------------
WARNING: CPU: 1 PID: 8455 at fs/io_uring.c:1494 req_ref_put fs/io_uring.c:1494 [inline]
WARNING: CPU: 1 PID: 8455 at fs/io_uring.c:1494 req_ref_put fs/io_uring.c:1492 [inline]
WARNING: CPU: 1 PID: 8455 at fs/io_uring.c:1494 io_poll_double_wake+0x516/0x770 fs/io_uring.c:4943
Modules linked in:
CPU: 1 PID: 8455 Comm: syz-executor676 Not tainted 5.12.0-rc7-next-20210415-syzkaller #0
Hardware name: Google Google Compute Engine/Google Compute Engine, BIOS Google 01/01/2011
RIP: 0010:req_ref_put fs/io_uring.c:1494 [inline]
RIP: 0010:req_ref_put fs/io_uring.c:1492 [inline]
RIP: 0010:io_poll_double_wake+0x516/0x770 fs/io_uring.c:4943
Code: e8 1f 4c dc ff f0 ff 4d 5c 0f 94 c3 31 ff 89 de e8 7f 92 97 ff 84 db b8 01 00 00 00 0f 84 57 fc ff ff 89 04 24 e8 ba 8b 97 ff <0f> 0b 8b 04 24 e9 45 fc ff ff e8 ab 8b 97 ff 49 89 ec e9 83 fb ff
RSP: 0018:ffffc9000172fad8 EFLAGS: 00010093
RAX: 0000000000000000 RBX: 0000000000000001 RCX: 0000000000000000
RDX: ffff88801adbb900 RSI: ffffffff81dcec86 RDI: 0000000000000003
RBP: ffff8880125ac8c0 R08: 0000000000000001 R09: 0000000000000001
R10: ffffffff81dcec71 R11: 0000000000000000 R12: ffff8880125ac91c
R13: 0000000000000000 R14: ffff8880125ac8f0 R15: ffff888014ed6820
FS:  00000000015a73c0(0000) GS:ffff8880b9d00000(0000) knlGS:0000000000000000
CS:  0010 DS: 0000 ES: 0000 CR0: 0000000080050033
CR2: 00000000004af100 CR3: 000000001eb33000 CR4: 00000000001506e0
DR0: 0000000000000000 DR1: 0000000000000000 DR2: 0000000000000000
DR3: 0000000000000000 DR6: 00000000fffe0ff0 DR7: 0000000000000400
Call Trace:
 __wake_up_common+0x147/0x650 kernel/sched/wait.c:108
 __wake_up_common_lock+0xd0/0x130 kernel/sched/wait.c:138
 tty_ldisc_lock+0x55/0xb0 drivers/tty/tty_ldisc.c:336
 tty_ldisc_hangup+0x200/0x680 drivers/tty/tty_ldisc.c:752
 __tty_hangup.part.0+0x40a/0x870 drivers/tty/tty_io.c:639
 __tty_hangup drivers/tty/tty_io.c:595 [inline]
 tty_vhangup drivers/tty/tty_io.c:712 [inline]
 tty_ioctl+0xf6a/0x1600 drivers/tty/tty_io.c:2746
 vfs_ioctl fs/ioctl.c:51 [inline]
 __do_sys_ioctl fs/ioctl.c:1069 [inline]
 __se_sys_ioctl fs/ioctl.c:1055 [inline]
 __x64_sys_ioctl+0x193/0x200 fs/ioctl.c:1055
 do_syscall_64+0x3a/0xb0 arch/x86/entry/common.c:47
 entry_SYSCALL_64_after_hwframe+0x44/0xae
RIP: 0033:0x4408a9
Code: 1b 01 00 85 c0 b8 00 00 00 00 48 0f 44 c3 5b c3 90 48 89 f8 48 89 f7 48 89 d6 48 89 ca 4d 89 c2 4d 89 c8 4c 8b 4c 24 08 0f 05 <48> 3d 01 f0 ff ff 73 01 c3 48 c7 c1 c4 ff ff ff f7 d8 64 89 01 48
RSP: 002b:00007ffeb1a62488 EFLAGS: 00000246 ORIG_RAX: 0000000000000010
RAX: ffffffffffffffda RBX: 0000000000000003 RCX: 00000000004408a9
RDX: 0000000000000000 RSI: 0000000000005437 RDI: 0000000000000005
RBP: 00007ffeb1a624b8 R08: 000000000000000e R09: 00007ffeb1a624e0
R10: 0000000000000000 R11: 0000000000000246 R12: 00007ffeb1a624e0
R13: 0000000000000000 R14: 00000000004af018 R15: 0000000000400488


---
This report is generated by a bot. It may contain errors.
See https://goo.gl/tpsmEJ for more information about syzbot.
syzbot engineers can be reached at syzkaller@googlegroups.com.

syzbot will keep track of this issue. See:
https://goo.gl/tpsmEJ#status for how to communicate with syzbot.
For information about bisection process see: https://goo.gl/tpsmEJ#bisection
syzbot can test patches for this issue, for details see:
https://goo.gl/tpsmEJ#testing-patches
