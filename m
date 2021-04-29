Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id D831336E89F
	for <lists+io-uring@lfdr.de>; Thu, 29 Apr 2021 12:22:22 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S240326AbhD2KXG (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Thu, 29 Apr 2021 06:23:06 -0400
Received: from mail-io1-f70.google.com ([209.85.166.70]:46599 "EHLO
        mail-io1-f70.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232261AbhD2KXG (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Thu, 29 Apr 2021 06:23:06 -0400
Received: by mail-io1-f70.google.com with SMTP id b16-20020a5ea7100000b02904037ac1756fso10121161iod.13
        for <io-uring@vger.kernel.org>; Thu, 29 Apr 2021 03:22:18 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:date:message-id:subject:from:to;
        bh=Q5GY5CQBS9JbaZENIwHq92UaClqvwLemJzW3Ue1M9jE=;
        b=skahMJWpq1TOk7Hbz7LwMg72oryEWXIE2+9BCTf4ahS42w3JTKiHUeLeMy0LF3dFbM
         VLhT0eIC9C+cwnoJ3HtLJ1+XBNZtXOzM04UQazpQLj5DiHQP+fcebIXSKEMBIOjLznrD
         U1WaL7I8i22p6x3ZPj851eW6XXjVGsPvBB+7pSU35SHKQUvMIAtiztcteYcVTHEQ4V6Y
         eh3LCRd/7x6KGN5DMRsvbsEQ4wYLnnEiRyxVZsKk6CIwe13zSHfDPRadgmEiOWFeD9/n
         /zD//4Zm0rhDavkl4zC0QKehvumpxw1ldmDBIpkb8p2x5CZDoWgUPRFHRgZnv08nbmoD
         CO0g==
X-Gm-Message-State: AOAM530aTUpWcF3NVwUmfg82lyKaIg8vTH7YQc9BlGGYtSA4mJQISUJz
        TMoe+kz2R8MTw8weLNvwz7kfzyE4OIQfMVZAMmNTclQpdHr+
X-Google-Smtp-Source: ABdhPJxDnsYF4u/8fIugn/QQ0cfFwQnvbbBWTdsghqbaTwewIepdmedfZEtZQrG3kOd3Y1NYcU+duoDHl3AS+giC6CW2WpZWRfPG
MIME-Version: 1.0
X-Received: by 2002:a05:6638:2044:: with SMTP id t4mr32241075jaj.12.1619691738118;
 Thu, 29 Apr 2021 03:22:18 -0700 (PDT)
Date:   Thu, 29 Apr 2021 03:22:18 -0700
X-Google-Appengine-App-Id: s~syzkaller
X-Google-Appengine-App-Id-Alias: syzkaller
Message-ID: <000000000000b23f7805c119dee8@google.com>
Subject: [syzbot] WARNING in io_rsrc_node_switch
From:   syzbot <syzbot+a4715dd4b7c866136f79@syzkaller.appspotmail.com>
To:     asml.silence@gmail.com, axboe@kernel.dk, io-uring@vger.kernel.org,
        linux-kernel@vger.kernel.org, syzkaller-bugs@googlegroups.com
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org

Hello,

syzbot found the following issue on:

HEAD commit:    d72cd4ad Merge tag 'scsi-misc' of git://git.kernel.org/pub..
git tree:       upstream
console output: https://syzkaller.appspot.com/x/log.txt?x=143aae7dd00000
kernel config:  https://syzkaller.appspot.com/x/.config?x=65c207250bba4efe
dashboard link: https://syzkaller.appspot.com/bug?extid=a4715dd4b7c866136f79

Unfortunately, I don't have any reproducer for this issue yet.

IMPORTANT: if you fix the issue, please add the following tag to the commit:
Reported-by: syzbot+a4715dd4b7c866136f79@syzkaller.appspotmail.com

R13: 0000000020ffc000 R14: 0000000020000040 R15: 0000000020ee7000
------------[ cut here ]------------
WARNING: CPU: 1 PID: 27734 at fs/io_uring.c:7081 io_rsrc_node_switch+0x2a5/0x390 fs/io_uring.c:7081
Modules linked in:
CPU: 1 PID: 27734 Comm: syz-executor.1 Not tainted 5.12.0-syzkaller #0
Hardware name: Google Google Compute Engine/Google Compute Engine, BIOS Google 01/01/2011
RIP: 0010:io_rsrc_node_switch+0x2a5/0x390 fs/io_uring.c:7081
Code: ff 4d 85 e4 74 a4 48 83 c4 20 5b 5d 41 5c 41 5d 41 5e 41 5f e9 fc 00 99 ff e8 f7 00 99 ff 0f 0b e9 ee fd ff ff e8 eb 00 99 ff <0f> 0b e9 9d fd ff ff 4c 89 f7 e8 7c e0 dc ff eb 8b 4c 89 ef e8 72
RSP: 0018:ffffc9000a407d90 EFLAGS: 00010246
RAX: 0000000000040000 RBX: ffff888093390000 RCX: ffffc9000af4b000
RDX: 0000000000040000 RSI: ffffffff81db5d25 RDI: ffff888093390000
RBP: 0000000000000000 R08: 0000000000000dc0 R09: ffffffff8c0b37d3
R10: fffffbfff18166fa R11: 0000000000000000 R12: 0000000000000000
R13: 0000000000000000 R14: ffff888093390808 R15: 0000000000000000
FS:  00007f6a99229700(0000) GS:ffff8880b9c00000(0000) knlGS:0000000000000000
CS:  0010 DS: 0000 ES: 0000 CR0: 0000000080050033
CR2: 0000563680f98258 CR3: 0000000096847000 CR4: 0000000000350ef0
Call Trace:
 io_uring_create fs/io_uring.c:9611 [inline]
 io_uring_setup+0xf75/0x2a80 fs/io_uring.c:9689
 do_syscall_64+0x3a/0xb0 arch/x86/entry/common.c:47
 entry_SYSCALL_64_after_hwframe+0x44/0xae
RIP: 0033:0x4665f9
Code: ff ff c3 66 2e 0f 1f 84 00 00 00 00 00 0f 1f 40 00 48 89 f8 48 89 f7 48 89 d6 48 89 ca 4d 89 c2 4d 89 c8 4c 8b 4c 24 08 0f 05 <48> 3d 01 f0 ff ff 73 01 c3 48 c7 c1 bc ff ff ff f7 d8 64 89 01 48
RSP: 002b:00007f6a99229108 EFLAGS: 00000202 ORIG_RAX: 00000000000001a9
RAX: ffffffffffffffda RBX: 000000000056bf60 RCX: 00000000004665f9
RDX: 0000000020ffc000 RSI: 00000000200002c0 RDI: 0000000000000182
RBP: 00000000200002c0 R08: 00000000200001c0 R09: 00000000200001c0
R10: 0000000020000040 R11: 0000000000000202 R12: 00000000200001c0
R13: 0000000020ffc000 R14: 0000000020000040 R15: 0000000020ee7000


---
This report is generated by a bot. It may contain errors.
See https://goo.gl/tpsmEJ for more information about syzbot.
syzbot engineers can be reached at syzkaller@googlegroups.com.

syzbot will keep track of this issue. See:
https://goo.gl/tpsmEJ#status for how to communicate with syzbot.
