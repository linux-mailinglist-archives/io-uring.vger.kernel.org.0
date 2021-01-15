Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 6B70E2F892A
	for <lists+io-uring@lfdr.de>; Sat, 16 Jan 2021 00:10:47 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727468AbhAOXJF (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Fri, 15 Jan 2021 18:09:05 -0500
Received: from mail-io1-f70.google.com ([209.85.166.70]:39812 "EHLO
        mail-io1-f70.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726187AbhAOXJE (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Fri, 15 Jan 2021 18:09:04 -0500
Received: by mail-io1-f70.google.com with SMTP id n9so17557992iog.6
        for <io-uring@vger.kernel.org>; Fri, 15 Jan 2021 15:08:48 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:date:message-id:subject:from:to;
        bh=uakvH1s9XP9G5HMG/CzCkdjvXgWW8t2Z/lJ6987n5Pg=;
        b=GtE50GT8Ctg4UzM5vv1FT+cz2bQumoCuY5AwIs+6/8JSzsbczRg+g/UacPafAl7Z0z
         pCcr3hSjLpc0AJXXPt6HBOIKiqjPZ53/2mo1Isnam7uudVlzYYAfT8SbuUDIZXS2Ypou
         5QPKSW0m2rGDc9sv/O2Aziiw0WkMp0cJqiXz6i7UQ7p8yG5p3+4LI3FkzMoQy6CFBtZQ
         ROb++BZM2qfed4OsarMRa49nCJUUwKiOB51LX6RNJiDPFoSBLarocbIFObdJ4aEmGzfo
         LXCH3/MWMj4XRAadVbPkFN5kjZC26zDIYSmqfaH0rx4VAvDBoSiLRD/iK4fL5XAlB8Mq
         Ryfw==
X-Gm-Message-State: AOAM533wUu2RbeSaj4ISTOgsUsIi/intGSqeu2dN+QEXBaTz8pCeXUfs
        ljM7nJ2jVDbktCZT0/EzPcstDkbE1qvpzmkvGVV6KbgYCilC
X-Google-Smtp-Source: ABdhPJz/gYSCw4xqt5wGfGkX/mxjgGPv7jbyqDMBL8oivBdtAgy4D84Zxnn/e77W47tmfvQ2IVLQL/PDSFTdE+nSlYbeK2gi4ntx
MIME-Version: 1.0
X-Received: by 2002:a92:ba82:: with SMTP id t2mr12456787ill.139.1610752103304;
 Fri, 15 Jan 2021 15:08:23 -0800 (PST)
Date:   Fri, 15 Jan 2021 15:08:23 -0800
X-Google-Appengine-App-Id: s~syzkaller
X-Google-Appengine-App-Id-Alias: syzkaller
Message-ID: <000000000000f054d005b8f87274@google.com>
Subject: WARNING in io_disable_sqo_submit
From:   syzbot <syzbot+2f5d1785dc624932da78@syzkaller.appspotmail.com>
To:     axboe@kernel.dk, io-uring@vger.kernel.org,
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
console output: https://syzkaller.appspot.com/x/log.txt?x=12a76f70d00000
kernel config:  https://syzkaller.appspot.com/x/.config?x=c60c9ff9cc916cbc
dashboard link: https://syzkaller.appspot.com/bug?extid=2f5d1785dc624932da78
compiler:       gcc (GCC) 10.1.0-syz 20200507

Unfortunately, I don't have any reproducer for this issue yet.

IMPORTANT: if you fix the issue, please add the following tag to the commit:
Reported-by: syzbot+2f5d1785dc624932da78@syzkaller.appspotmail.com

------------[ cut here ]------------
WARNING: CPU: 1 PID: 9094 at fs/io_uring.c:8884 io_disable_sqo_submit+0x106/0x130 fs/io_uring.c:8884
Modules linked in:
CPU: 1 PID: 9094 Comm: syz-executor.5 Not tainted 5.11.0-rc3-syzkaller #0
Hardware name: Google Google Compute Engine/Google Compute Engine, BIOS Google 01/01/2011
RIP: 0010:io_disable_sqo_submit+0x106/0x130 fs/io_uring.c:8884
Code: b6 14 02 48 89 f8 83 e0 07 83 c0 03 38 d0 7c 04 84 d2 75 1d 83 8b 14 01 00 00 01 48 89 ef 5b 5d e9 ef bc 23 07 e8 5a e5 9a ff <0f> 0b e9 35 ff ff ff e8 3e a1 dd ff eb dc e8 67 a1 dd ff e9 65 ff
RSP: 0018:ffffc9000188fea0 EFLAGS: 00010212
RAX: 0000000000000044 RBX: ffff888079dbe000 RCX: ffffc90013b54000
RDX: 0000000000040000 RSI: ffffffff81d7e466 RDI: ffff888079dbe0d0
RBP: ffff8880201c0c80 R08: 0000000000000000 R09: 00000000278d0001
R10: ffffffff81d7e705 R11: 0000000000000001 R12: ffff888079dbe000
R13: ffff8880278d0001 R14: ffff888079dbe040 R15: ffff888079dbe0d0
FS:  00007fe461a71700(0000) GS:ffff8880b9f00000(0000) knlGS:0000000000000000
CS:  0010 DS: 0000 ES: 0000 CR0: 0000000080050033
CR2: 0000000000000080 CR3: 0000000011fd1000 CR4: 0000000000350ee0
Call Trace:
 io_uring_flush+0x28b/0x3a0 fs/io_uring.c:9099
 filp_close+0xb4/0x170 fs/open.c:1280
 close_fd+0x5c/0x80 fs/file.c:626
 __do_sys_close fs/open.c:1299 [inline]
 __se_sys_close fs/open.c:1297 [inline]
 __x64_sys_close+0x2f/0xa0 fs/open.c:1297
 do_syscall_64+0x2d/0x70 arch/x86/entry/common.c:46
 entry_SYSCALL_64_after_hwframe+0x44/0xa9
RIP: 0033:0x45e219
Code: 0d b4 fb ff c3 66 2e 0f 1f 84 00 00 00 00 00 66 90 48 89 f8 48 89 f7 48 89 d6 48 89 ca 4d 89 c2 4d 89 c8 4c 8b 4c 24 08 0f 05 <48> 3d 01 f0 ff ff 0f 83 db b3 fb ff c3 66 2e 0f 1f 84 00 00 00 00
RSP: 002b:00007fe461a70c68 EFLAGS: 00000246 ORIG_RAX: 0000000000000003
RAX: ffffffffffffffda RBX: 0000000000000001 RCX: 000000000045e219
RDX: 0000000000000000 RSI: 0000000000000000 RDI: 0000000000000007
RBP: 000000000119bfb0 R08: 0000000000000000 R09: 0000000000000000
R10: 0000000000000000 R11: 0000000000000246 R12: 000000000119bf8c
R13: 00007ffc626b58ff R14: 00007fe461a719c0 R15: 000000000119bf8c


---
This report is generated by a bot. It may contain errors.
See https://goo.gl/tpsmEJ for more information about syzbot.
syzbot engineers can be reached at syzkaller@googlegroups.com.

syzbot will keep track of this issue. See:
https://goo.gl/tpsmEJ#status for how to communicate with syzbot.
