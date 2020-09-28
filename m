Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id CF80927A860
	for <lists+io-uring@lfdr.de>; Mon, 28 Sep 2020 09:17:55 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726559AbgI1HR0 (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Mon, 28 Sep 2020 03:17:26 -0400
Received: from mail-il1-f205.google.com ([209.85.166.205]:50142 "EHLO
        mail-il1-f205.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726497AbgI1HRZ (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Mon, 28 Sep 2020 03:17:25 -0400
Received: by mail-il1-f205.google.com with SMTP id o18so68636ilm.16
        for <io-uring@vger.kernel.org>; Mon, 28 Sep 2020 00:17:25 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:date:message-id:subject:from:to;
        bh=GHGGR4Zfn1U2MwoQAnVbHF7lefhURprcgm/RtnFwDRQ=;
        b=oeLoMK8oOk7N0fYv9fLQB3MTTYOsP8FaKGEag9Ikzh95gTbWL93Fq8p+ys4KJmYq/p
         n/NjWaJE0yDSulSc2Ky8ermlpbBslH5gOKYl1kevl3woMYrjfyCSfNCC/O9SN05V9SVy
         TKTgOfHSCt1G4lBnEgjsJPOUbav4blvVN3I4/waT2pasdlJlgxUW516A7MaQxlp310uN
         KUlWOI9A62viJjNSW+MFPLl/d0pKlQ2qYXw+WjLg9vhFOl2+8r4I2vYj/PD6O4ricM9C
         VmvRiIYsj6ECDIi2H/8tlXUi2I1XQXjBMBiAiEdzflJ4zSRxZ7tub6xrYnPKZtpWU0Jr
         2EuQ==
X-Gm-Message-State: AOAM532nU4tBN4DtQ6xmCoq18hsuQaVGV5VqcCSVTTWMivlasZalx7at
        9clTCqlEhMhcdSpu/0N8afGDik0RNdzjcez1zt7kTY9lXZXp
X-Google-Smtp-Source: ABdhPJwkfJxPhyjGtwfnoYbPxJx2Gypp/5FpZVK82XXdI5Exe87xWNsfIU11of/7hMYigERZk0exFULdXDuusHWvcR5e3moApY3X
MIME-Version: 1.0
X-Received: by 2002:a6b:da19:: with SMTP id x25mr6111900iob.12.1601277444720;
 Mon, 28 Sep 2020 00:17:24 -0700 (PDT)
Date:   Mon, 28 Sep 2020 00:17:24 -0700
X-Google-Appengine-App-Id: s~syzkaller
X-Google-Appengine-App-Id-Alias: syzkaller
Message-ID: <000000000000478f3a05b05a7539@google.com>
Subject: general protection fault in io_poll_double_wake (2)
From:   syzbot <syzbot+81b3883093f772addf6d@syzkaller.appspotmail.com>
To:     axboe@kernel.dk, io-uring@vger.kernel.org,
        linux-fsdevel@vger.kernel.org, linux-kernel@vger.kernel.org,
        syzkaller-bugs@googlegroups.com, viro@zeniv.linux.org.uk
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org

Hello,

syzbot found the following issue on:

HEAD commit:    d1d2220c Add linux-next specific files for 20200924
git tree:       linux-next
console output: https://syzkaller.appspot.com/x/log.txt?x=1550b609900000
kernel config:  https://syzkaller.appspot.com/x/.config?x=254e028a642027c
dashboard link: https://syzkaller.appspot.com/bug?extid=81b3883093f772addf6d
compiler:       gcc (GCC) 10.1.0-syz 20200507
syz repro:      https://syzkaller.appspot.com/x/repro.syz?x=15946317900000
C reproducer:   https://syzkaller.appspot.com/x/repro.c?x=1266c5ad900000

IMPORTANT: if you fix the issue, please add the following tag to the commit:
Reported-by: syzbot+81b3883093f772addf6d@syzkaller.appspotmail.com

IPVS: ftp: loaded support on port[0] = 21
general protection fault, probably for non-canonical address 0xdffffc0000000009: 0000 [#1] PREEMPT SMP KASAN
KASAN: null-ptr-deref in range [0x0000000000000048-0x000000000000004f]
CPU: 0 PID: 6874 Comm: syz-executor749 Not tainted 5.9.0-rc6-next-20200924-syzkaller #0
Hardware name: Google Google Compute Engine/Google Compute Engine, BIOS Google 01/01/2011
RIP: 0010:io_poll_get_single fs/io_uring.c:4778 [inline]
RIP: 0010:io_poll_double_wake+0x51/0x510 fs/io_uring.c:4845
Code: fc ff df 48 c1 ea 03 80 3c 02 00 0f 85 9e 03 00 00 48 b8 00 00 00 00 00 fc ff df 49 8b 5d 08 48 8d 7b 48 48 89 fa 48 c1 ea 03 <0f> b6 04 02 84 c0 74 06 0f 8e 63 03 00 00 0f b6 6b 48 bf 06 00 00
RSP: 0018:ffffc90001c1fb70 EFLAGS: 00010006
RAX: dffffc0000000000 RBX: 0000000000000000 RCX: 0000000000000004
RDX: 0000000000000009 RSI: ffffffff81d9b3ad RDI: 0000000000000048
RBP: dffffc0000000000 R08: ffff8880a3cac798 R09: ffffc90001c1fc60
R10: fffff52000383f73 R11: 0000000000000000 R12: 0000000000000004
R13: ffff8880a3cac798 R14: ffff8880a3cac7a0 R15: 0000000000000004
FS:  0000000001f98880(0000) GS:ffff8880ae400000(0000) knlGS:0000000000000000
CS:  0010 DS: 0000 ES: 0000 CR0: 0000000080050033
CR2: 00007f18886916c0 CR3: 0000000094c5a000 CR4: 00000000001506f0
DR0: 0000000000000000 DR1: 0000000000000000 DR2: 0000000000000000
DR3: 0000000000000000 DR6: 00000000fffe0ff0 DR7: 0000000000000400
Call Trace:
 __wake_up_common+0x147/0x650 kernel/sched/wait.c:93
 __wake_up_common_lock+0xd0/0x130 kernel/sched/wait.c:123
 tty_ldisc_hangup+0x1cf/0x680 drivers/tty/tty_ldisc.c:735
 __tty_hangup.part.0+0x403/0x870 drivers/tty/tty_io.c:625
 __tty_hangup drivers/tty/tty_io.c:575 [inline]
 tty_vhangup+0x1d/0x30 drivers/tty/tty_io.c:698
 pty_close+0x3f5/0x550 drivers/tty/pty.c:79
 tty_release+0x455/0xf60 drivers/tty/tty_io.c:1679
 __fput+0x285/0x920 fs/file_table.c:281
 task_work_run+0xdd/0x190 kernel/task_work.c:141
 tracehook_notify_resume include/linux/tracehook.h:188 [inline]
 exit_to_user_mode_loop kernel/entry/common.c:165 [inline]
 exit_to_user_mode_prepare+0x1e2/0x1f0 kernel/entry/common.c:192
 syscall_exit_to_user_mode+0x7a/0x2c0 kernel/entry/common.c:267
 entry_SYSCALL_64_after_hwframe+0x44/0xa9
RIP: 0033:0x401210
Code: 01 f0 ff ff 0f 83 20 0c 00 00 c3 66 2e 0f 1f 84 00 00 00 00 00 0f 1f 44 00 00 83 3d dd 24 2d 00 00 75 14 b8 03 00 00 00 0f 05 <48> 3d 01 f0 ff ff 0f 83 f4 0b 00 00 c3 48 83 ec 08 e8 5a 01 00 00
RSP: 002b:00007ffcdc2c7408 EFLAGS: 00000246 ORIG_RAX: 0000000000000003
RAX: 0000000000000000 RBX: 0000000000000004 RCX: 0000000000401210
RDX: 0000000000000000 RSI: 000000000000450c RDI: 0000000000000003
RBP: 00007ffcdc2c7410 R08: 0000000000000000 R09: 0000000000000000
R10: 0000000000000000 R11: 0000000000000246 R12: 0000000000402290
R13: 0000000000402320 R14: 0000000000000000 R15: 0000000000000000
Modules linked in:
---[ end trace b71b955b40cc85b6 ]---
RIP: 0010:io_poll_get_single fs/io_uring.c:4778 [inline]
RIP: 0010:io_poll_double_wake+0x51/0x510 fs/io_uring.c:4845
Code: fc ff df 48 c1 ea 03 80 3c 02 00 0f 85 9e 03 00 00 48 b8 00 00 00 00 00 fc ff df 49 8b 5d 08 48 8d 7b 48 48 89 fa 48 c1 ea 03 <0f> b6 04 02 84 c0 74 06 0f 8e 63 03 00 00 0f b6 6b 48 bf 06 00 00
RSP: 0018:ffffc90001c1fb70 EFLAGS: 00010006
RAX: dffffc0000000000 RBX: 0000000000000000 RCX: 0000000000000004
RDX: 0000000000000009 RSI: ffffffff81d9b3ad RDI: 0000000000000048
RBP: dffffc0000000000 R08: ffff8880a3cac798 R09: ffffc90001c1fc60
R10: fffff52000383f73 R11: 0000000000000000 R12: 0000000000000004
R13: ffff8880a3cac798 R14: ffff8880a3cac7a0 R15: 0000000000000004
FS:  0000000001f98880(0000) GS:ffff8880ae400000(0000) knlGS:0000000000000000
CS:  0010 DS: 0000 ES: 0000 CR0: 0000000080050033
CR2: 00007f18886916c0 CR3: 0000000094c5a000 CR4: 00000000001506f0
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
