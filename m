Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 373672EFE9D
	for <lists+io-uring@lfdr.de>; Sat,  9 Jan 2021 09:30:14 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726068AbhAII36 (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Sat, 9 Jan 2021 03:29:58 -0500
Received: from mail-il1-f197.google.com ([209.85.166.197]:38275 "EHLO
        mail-il1-f197.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725847AbhAII35 (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Sat, 9 Jan 2021 03:29:57 -0500
Received: by mail-il1-f197.google.com with SMTP id e10so12581016ils.5
        for <io-uring@vger.kernel.org>; Sat, 09 Jan 2021 00:29:41 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:date:message-id:subject:from:to;
        bh=eqtHRI6EKHUkmqQpqzOZc2xRSvZjjEKnnJC+bZZCVOE=;
        b=UaQ11iwoUUZQgSo/Lkm4Iq/4YI/JwJqfsNpO1i5zS2+EOA6BYcHE4lZmy3iJ3tDnjK
         ieBZgzTcoSAwVMKMCJ7NLQSP/dVWsUQAEBd7+7KMOWex5rS0jDmanJL2neeoW+//8sUV
         0ldiP6NR+BStLtPR7GSJBn/2wyHWDFR7u592SQdEoNIScw85pfymn4WbXSAYxNy6VXkZ
         RhjRlS6ichdbhzgGODwZWUM7fr///8GtzawSbW23AllfBj+cwbvEgouHY6rgSC5l80nf
         qVMo+nhNhd9qxS33vApuMKnBi4Ilt7ZLbMtjDds7zCoVEp1toc7/oOiFoU53lhU1H9og
         9DAA==
X-Gm-Message-State: AOAM532GzCn45CZW4KRz6UZancRufEUD8/zlyJK0lzLYqe5JBDWw6iMt
        K7X0+ofybl1Yve6RqjWnJXz3ehz9Q9xbVviGzBw3CfoqLx4m
X-Google-Smtp-Source: ABdhPJyh94sxj0bQ8Vfsp8SY9JlbFRV5dPMTRzYKd61C12qMqS34mLDJe/vbgvaH6HXqdEPLvIbmmQIJvUezoBwXoNoq8XsqBmHi
MIME-Version: 1.0
X-Received: by 2002:a5e:8e05:: with SMTP id a5mr8282357ion.133.1610180956411;
 Sat, 09 Jan 2021 00:29:16 -0800 (PST)
Date:   Sat, 09 Jan 2021 00:29:16 -0800
X-Google-Appengine-App-Id: s~syzkaller
X-Google-Appengine-App-Id-Alias: syzkaller
Message-ID: <000000000000ee606405b873772a@google.com>
Subject: general protection fault in io_sqe_files_unregister
From:   syzbot <syzbot+9ec0395bc17f2b1e3cc1@syzkaller.appspotmail.com>
To:     axboe@kernel.dk, io-uring@vger.kernel.org,
        linux-fsdevel@vger.kernel.org, linux-kernel@vger.kernel.org,
        syzkaller-bugs@googlegroups.com, viro@zeniv.linux.org.uk
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org

Hello,

syzbot found the following issue on:

HEAD commit:    71c061d2 Merge tag 'for-5.11-rc2-tag' of git://git.kernel...
git tree:       upstream
console output: https://syzkaller.appspot.com/x/log.txt?x=17ec3f67500000
kernel config:  https://syzkaller.appspot.com/x/.config?x=8aa30b9da402d224
dashboard link: https://syzkaller.appspot.com/bug?extid=9ec0395bc17f2b1e3cc1
compiler:       gcc (GCC) 10.1.0-syz 20200507

Unfortunately, I don't have any reproducer for this issue yet.

IMPORTANT: if you fix the issue, please add the following tag to the commit:
Reported-by: syzbot+9ec0395bc17f2b1e3cc1@syzkaller.appspotmail.com

general protection fault, probably for non-canonical address 0xdffffc0000000000: 0000 [#1] PREEMPT SMP KASAN
KASAN: null-ptr-deref in range [0x0000000000000000-0x0000000000000007]
CPU: 1 PID: 9107 Comm: syz-executor.2 Not tainted 5.11.0-rc2-syzkaller #0
Hardware name: Google Google Compute Engine/Google Compute Engine, BIOS Google 01/01/2011
RIP: 0010:__list_add include/linux/list.h:71 [inline]
RIP: 0010:list_add_tail include/linux/list.h:100 [inline]
RIP: 0010:io_sqe_files_set_node fs/io_uring.c:7243 [inline]
RIP: 0010:io_sqe_files_unregister+0x42a/0x770 fs/io_uring.c:7279
Code: 00 fc ff df 48 c1 ea 03 80 3c 02 00 0f 85 07 03 00 00 4c 89 ea 4c 89 ad 88 00 00 00 48 b8 00 00 00 00 00 fc ff df 48 c1 ea 03 <80> 3c 02 00 0f 85 f4 02 00 00 49 8d 7f 18 48 8d 85 80 00 00 00 48
RSP: 0018:ffffc9000982fcf8 EFLAGS: 00010247
RAX: dffffc0000000000 RBX: ffff88814763fe90 RCX: ffffc9000d28d000
RDX: 0000000000000000 RSI: ffffffff81d82695 RDI: 0000000000000003
RBP: ffff88814763fe00 R08: 0000000000000001 R09: 0000000000000001
R10: ffffffff81d82684 R11: 0000000000000000 R12: 00000000fffffffc
R13: 0000000000000004 R14: ffff88814763fe80 R15: fffffffffffffff4
FS:  00007f6532203700(0000) GS:ffff8880b9f00000(0000) knlGS:0000000000000000
CS:  0010 DS: 0000 ES: 0000 CR0: 0000000080050033
CR2: 00000000200000d8 CR3: 0000000014ad5000 CR4: 00000000001506e0
DR0: 0000000000000000 DR1: 0000000000000000 DR2: 0000000000000000
DR3: 0000000000000000 DR6: 00000000fffe0ff0 DR7: 0000000000000400
Call Trace:
 __io_uring_register fs/io_uring.c:9916 [inline]
 __do_sys_io_uring_register+0x1185/0x4080 fs/io_uring.c:10000
 do_syscall_64+0x2d/0x70 arch/x86/entry/common.c:46
 entry_SYSCALL_64_after_hwframe+0x44/0xa9
RIP: 0033:0x45e219
Code: 0d b4 fb ff c3 66 2e 0f 1f 84 00 00 00 00 00 66 90 48 89 f8 48 89 f7 48 89 d6 48 89 ca 4d 89 c2 4d 89 c8 4c 8b 4c 24 08 0f 05 <48> 3d 01 f0 ff ff 0f 83 db b3 fb ff c3 66 2e 0f 1f 84 00 00 00 00
RSP: 002b:00007f6532202c68 EFLAGS: 00000246 ORIG_RAX: 00000000000001ab
RAX: ffffffffffffffda RBX: 0000000000000007 RCX: 000000000045e219
RDX: 0000000000000000 RSI: 0000000000000003 RDI: 0000000000000003
RBP: 00007f6532202ca0 R08: 0000000000000000 R09: 0000000000000000
R10: 0000000000000000 R11: 0000000000000246 R12: 0000000000000000
R13: 00000000016afb5f R14: 00007f65322039c0 R15: 000000000119bf8c
Modules linked in:
---[ end trace 6e4aada9e44ca3d1 ]---
RIP: 0010:__list_add include/linux/list.h:71 [inline]
RIP: 0010:list_add_tail include/linux/list.h:100 [inline]
RIP: 0010:io_sqe_files_set_node fs/io_uring.c:7243 [inline]
RIP: 0010:io_sqe_files_unregister+0x42a/0x770 fs/io_uring.c:7279
Code: 00 fc ff df 48 c1 ea 03 80 3c 02 00 0f 85 07 03 00 00 4c 89 ea 4c 89 ad 88 00 00 00 48 b8 00 00 00 00 00 fc ff df 48 c1 ea 03 <80> 3c 02 00 0f 85 f4 02 00 00 49 8d 7f 18 48 8d 85 80 00 00 00 48
RSP: 0018:ffffc9000982fcf8 EFLAGS: 00010247
RAX: dffffc0000000000 RBX: ffff88814763fe90 RCX: ffffc9000d28d000
RDX: 0000000000000000 RSI: ffffffff81d82695 RDI: 0000000000000003
RBP: ffff88814763fe00 R08: 0000000000000001 R09: 0000000000000001
R10: ffffffff81d82684 R11: 0000000000000000 R12: 00000000fffffffc
R13: 0000000000000004 R14: ffff88814763fe80 R15: fffffffffffffff4
FS:  00007f6532203700(0000) GS:ffff8880b9f00000(0000) knlGS:0000000000000000
CS:  0010 DS: 0000 ES: 0000 CR0: 0000000080050033
CR2: 00000000200000d8 CR3: 0000000014ad5000 CR4: 00000000001506e0
DR0: 0000000000000000 DR1: 0000000000000000 DR2: 0000000000000000
DR3: 0000000000000000 DR6: 00000000fffe0ff0 DR7: 0000000000000400


---
This report is generated by a bot. It may contain errors.
See https://goo.gl/tpsmEJ for more information about syzbot.
syzbot engineers can be reached at syzkaller@googlegroups.com.

syzbot will keep track of this issue. See:
https://goo.gl/tpsmEJ#status for how to communicate with syzbot.
