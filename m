Return-Path: <io-uring+bounces-4971-lists+io-uring=lfdr.de@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from sy.mirrors.kernel.org (sy.mirrors.kernel.org [147.75.48.161])
	by mail.lfdr.de (Postfix) with ESMTPS id 324109D5D82
	for <lists+io-uring@lfdr.de>; Fri, 22 Nov 2024 11:51:41 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sy.mirrors.kernel.org (Postfix) with ESMTPS id 82492B23858
	for <lists+io-uring@lfdr.de>; Fri, 22 Nov 2024 10:51:38 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id B399118B47B;
	Fri, 22 Nov 2024 10:51:32 +0000 (UTC)
X-Original-To: io-uring@vger.kernel.org
Received: from mail-io1-f69.google.com (mail-io1-f69.google.com [209.85.166.69])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0318D189F5A
	for <io-uring@vger.kernel.org>; Fri, 22 Nov 2024 10:51:30 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.166.69
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1732272692; cv=none; b=pYea3lc7A69TQqLaTh9SUHMoRxKpbXeMB4xWUSPXCbpKqgAo29iHvmOEvSxfTIkMN4gLrAZzLiAhPevMFIp98mtZ8Wh4mrRdKiyBgLDw7AbEHuMJiyTTIkFFXfHGjycV4fD8ldwzZ3GCgaRooe4aVY7o4raJ56MM79CY+V8Z/O4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1732272692; c=relaxed/simple;
	bh=rWx1QafmI98vm6lFoCjenJ26opvPskjtjsWcH3jQgs4=;
	h=MIME-Version:Date:Message-ID:Subject:From:To:Content-Type; b=X/t58tn71BAufFWcYnJTFtbJxECsUQpq/l1lSuc6gSXFMA18aaZ6WLnGp/wy/l7UecPg9LnDlZd5BcskWbhklZvqGK40UIOppUG2o/MWJXhhwQKAqZUIvbfzX0SgEIZ4xebSXCKfpbxAfb61TaDEhnrEqqtaRmBSd/EqVkVND+k=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=fail (p=none dis=none) header.from=syzkaller.appspotmail.com; spf=pass smtp.mailfrom=M3KW2WVRGUFZ5GODRSRYTGD7.apphosting.bounces.google.com; arc=none smtp.client-ip=209.85.166.69
Authentication-Results: smtp.subspace.kernel.org; dmarc=fail (p=none dis=none) header.from=syzkaller.appspotmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=M3KW2WVRGUFZ5GODRSRYTGD7.apphosting.bounces.google.com
Received: by mail-io1-f69.google.com with SMTP id ca18e2360f4ac-83aaca0efc6so215497439f.0
        for <io-uring@vger.kernel.org>; Fri, 22 Nov 2024 02:51:30 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1732272690; x=1732877490;
        h=to:from:subject:message-id:date:mime-version:x-gm-message-state
         :from:to:cc:subject:date:message-id:reply-to;
        bh=a9b8gna8XYMg1/E7YRn5hKsYKfsNc4PZ7WP1R8bZk4w=;
        b=wW0Uyi6tK9x2/jHWWOLlaDpeVPd/0kq/+1eM3z8TSB6gbhzcFCf6ArOjyjtKs7u95q
         i1mOU+L4r6XrSp4j3UrVUqNTHd4vpxG5GASxTwuxPzK8+3+LP6L9vB84A3bHuBVhReR7
         CMg6++n10cVcbcN/ScblC/PwVSBxkfcDPz+kHf734jv5MXUdX2KmFDgc58S2KiofIgKH
         q697HrCwBVjV7P2Sw9UTeaekSlfABKPWdQroLYdksbzQsoZW9Jg0c7H5IGrVL2Iouj0q
         nKCnKGo3jq2NClP1R1ooTjGAjWkrAR47ccy6Bbe8YgYzt/qJtqSp5nPoQz+ethwI6r+s
         UD3A==
X-Forwarded-Encrypted: i=1; AJvYcCUdtgRHW3zFKX/+pWfU/3ze7Vh5WpmDu7+KzPblu0xsOD+LXUbGk8ejGiwxtBsECdR2k/gwbxqqMA==@vger.kernel.org
X-Gm-Message-State: AOJu0Yw1kkjBmpHXKf1GrRZCOdxZgrfM+uKts2RcWT/hlAi8trwvD+wM
	pHx7hn1DmDC1zZNR/8Kh8SjXmd1f/lmghbIz6DW+IEnikBuhtkwUI/rvNwrJlWQj4tQr+EKwgzN
	35upLUZt6STPCpa801aylTWDazhIIHC1j8u8PiUxsarEXBSrbnnh5NFg=
X-Google-Smtp-Source: AGHT+IHjAV/oE0VZPkOLXrt3akV1X4ocIo9wz+lIV1zmziMUf4p1hx4fHtTLQvFkDjWPVZutHjfi+oJqg8j7RAvCUF4BSGLKY6BL
Precedence: bulk
X-Mailing-List: io-uring@vger.kernel.org
List-Id: <io-uring.vger.kernel.org>
List-Subscribe: <mailto:io-uring+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:io-uring+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-Received: by 2002:a05:6e02:1a07:b0:3a7:9505:534b with SMTP id
 e9e14a558f8ab-3a79acfa2demr24810795ab.2.1732272690195; Fri, 22 Nov 2024
 02:51:30 -0800 (PST)
Date: Fri, 22 Nov 2024 02:51:30 -0800
X-Google-Appengine-App-Id: s~syzkaller
X-Google-Appengine-App-Id-Alias: syzkaller
Message-ID: <67406232.050a0220.3c9d61.018e.GAE@google.com>
Subject: [syzbot] [io-uring?] WARNING in io_pin_pages
From: syzbot <syzbot+2159cbb522b02847c053@syzkaller.appspotmail.com>
To: asml.silence@gmail.com, axboe@kernel.dk, io-uring@vger.kernel.org, 
	linux-kernel@vger.kernel.org, syzkaller-bugs@googlegroups.com
Content-Type: text/plain; charset="UTF-8"

Hello,

syzbot found the following issue on:

HEAD commit:    ae58226b89ac Add linux-next specific files for 20241118
git tree:       linux-next
console+strace: https://syzkaller.appspot.com/x/log.txt?x=14a67378580000
kernel config:  https://syzkaller.appspot.com/x/.config?x=45719eec4c74e6ba
dashboard link: https://syzkaller.appspot.com/bug?extid=2159cbb522b02847c053
compiler:       Debian clang version 15.0.6, GNU ld (GNU Binutils for Debian) 2.40
syz repro:      https://syzkaller.appspot.com/x/repro.syz?x=137beac0580000
C reproducer:   https://syzkaller.appspot.com/x/repro.c?x=177beac0580000

Downloadable assets:
disk image: https://storage.googleapis.com/syzbot-assets/fd3d650cd6b6/disk-ae58226b.raw.xz
vmlinux: https://storage.googleapis.com/syzbot-assets/89a0fb674130/vmlinux-ae58226b.xz
kernel image: https://storage.googleapis.com/syzbot-assets/92120e1c6775/bzImage-ae58226b.xz

The issue was bisected to:

commit 68685fa20edc5307fc893a06473c19661c236f29
Author: Pavel Begunkov <asml.silence@gmail.com>
Date:   Fri Nov 15 16:54:38 2024 +0000

    io_uring: fortify io_pin_pages with a warning

bisection log:  https://syzkaller.appspot.com/x/bisect.txt?x=17b73bf7980000
final oops:     https://syzkaller.appspot.com/x/report.txt?x=14773bf7980000
console output: https://syzkaller.appspot.com/x/log.txt?x=10773bf7980000

IMPORTANT: if you fix the issue, please add the following tag to the commit:
Reported-by: syzbot+2159cbb522b02847c053@syzkaller.appspotmail.com
Fixes: 68685fa20edc ("io_uring: fortify io_pin_pages with a warning")

------------[ cut here ]------------
WARNING: CPU: 0 PID: 5834 at io_uring/memmap.c:144 io_pin_pages+0x149/0x180 io_uring/memmap.c:144
Modules linked in:
CPU: 0 UID: 0 PID: 5834 Comm: syz-executor825 Not tainted 6.12.0-next-20241118-syzkaller #0
Hardware name: Google Google Compute Engine/Google Compute Engine, BIOS Google 10/30/2024
RIP: 0010:io_pin_pages+0x149/0x180 io_uring/memmap.c:144
Code: 63 fd 4c 89 f8 5b 41 5c 41 5e 41 5f 5d c3 cc cc cc cc e8 da c1 e3 fc 90 0f 0b 90 49 c7 c7 ea ff ff ff eb de e8 c8 c1 e3 fc 90 <0f> 0b 90 49 c7 c7 b5 ff ff ff eb cc 44 89 f1 80 e1 07 80 c1 03 38
RSP: 0018:ffffc90003d17c10 EFLAGS: 00010293
RAX: ffffffff84bbb6e8 RBX: fff0000000000091 RCX: ffff88802c6d5a00
RDX: 0000000000000000 RSI: fff0000000000091 RDI: 000000007fffffff
RBP: 000ffffffffffff0 R08: ffffffff84bbb5ee R09: 1ffff110041538c0
R10: dffffc0000000000 R11: ffffed10041538c1 R12: ffffffffffff0000
R13: ffffffffffff0000 R14: ffffc90003d17c80 R15: 1ffff110068d2920
FS:  0000555568d4e380(0000) GS:ffff8880b8600000(0000) knlGS:0000000000000000
CS:  0010 DS: 0000 ES: 0000 CR0: 0000000080050033
CR2: 000055ee7661e0d8 CR3: 0000000075cb2000 CR4: 00000000003526f0
DR0: 0000000000000000 DR1: 0000000000000000 DR2: 0000000000000000
DR3: 0000000000000000 DR6: 00000000fffe0ff0 DR7: 0000000000000400
Call Trace:
 <TASK>
 __io_uaddr_map+0xfb/0x2d0 io_uring/memmap.c:183
 io_rings_map io_uring/io_uring.c:2611 [inline]
 io_allocate_scq_urings+0x1c0/0x650 io_uring/io_uring.c:3470
 io_uring_create+0x5b5/0xc00 io_uring/io_uring.c:3692
 io_uring_setup io_uring/io_uring.c:3781 [inline]
 __do_sys_io_uring_setup io_uring/io_uring.c:3808 [inline]
 __se_sys_io_uring_setup+0x2ba/0x330 io_uring/io_uring.c:3802
 do_syscall_x64 arch/x86/entry/common.c:52 [inline]
 do_syscall_64+0xf3/0x230 arch/x86/entry/common.c:83
 entry_SYSCALL_64_after_hwframe+0x77/0x7f
RIP: 0033:0x7feda57a15a9
Code: 48 83 c4 28 c3 e8 37 17 00 00 0f 1f 80 00 00 00 00 48 89 f8 48 89 f7 48 89 d6 48 89 ca 4d 89 c2 4d 89 c8 4c 8b 4c 24 08 0f 05 <48> 3d 01 f0 ff ff 73 01 c3 48 c7 c1 b8 ff ff ff f7 d8 64 89 01 48
RSP: 002b:00007fff8a663b18 EFLAGS: 00000246 ORIG_RAX: 00000000000001a9
RAX: ffffffffffffffda RBX: 0000000000002c0c RCX: 00007feda57a15a9
RDX: ffffffffffffffb8 RSI: 0000000020000400 RDI: 0000000000002c0c
RBP: 00007feda5814610 R08: 0000000000000000 R09: 0000000000000000
R10: 00000000000000e8 R11: 0000000000000246 R12: 0000000000000001
R13: 00007fff8a663cf8 R14: 0000000000000001 R15: 0000000000000001
 </TASK>


---
This report is generated by a bot. It may contain errors.
See https://goo.gl/tpsmEJ for more information about syzbot.
syzbot engineers can be reached at syzkaller@googlegroups.com.

syzbot will keep track of this issue. See:
https://goo.gl/tpsmEJ#status for how to communicate with syzbot.
For information about bisection process see: https://goo.gl/tpsmEJ#bisection

If the report is already addressed, let syzbot know by replying with:
#syz fix: exact-commit-title

If you want syzbot to run the reproducer, reply with:
#syz test: git://repo/address.git branch-or-commit-hash
If you attach or paste a git patch, syzbot will apply it before testing.

If you want to overwrite report's subsystems, reply with:
#syz set subsystems: new-subsystem
(See the list of subsystem names on the web dashboard)

If the report is a duplicate of another one, reply with:
#syz dup: exact-subject-of-another-report

If you want to undo deduplication, reply with:
#syz undup

