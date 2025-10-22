Return-Path: <io-uring+bounces-10117-lists+io-uring=lfdr.de@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [139.178.88.99])
	by mail.lfdr.de (Postfix) with ESMTPS id 4DD01BFD867
	for <lists+io-uring@lfdr.de>; Wed, 22 Oct 2025 19:19:14 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id A534E3B6EAB
	for <lists+io-uring@lfdr.de>; Wed, 22 Oct 2025 16:56:48 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 24AA31F63D9;
	Wed, 22 Oct 2025 16:56:36 +0000 (UTC)
X-Original-To: io-uring@vger.kernel.org
Received: from mail-il1-f207.google.com (mail-il1-f207.google.com [209.85.166.207])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1660635B13B
	for <io-uring@vger.kernel.org>; Wed, 22 Oct 2025 16:56:33 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.166.207
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1761152196; cv=none; b=KE9jfs3xhAEF54G311GBn0iL8vCz3uD0x/p3ABoWbGyby01zXD9QbeSUEscx+6GtVs5s8itJYW2j+MOYtfQv4mMANOiQO+oUaAw+xU+idN+pgIXvNX+dxsqjgSZWce71TtwlvciMDygpiaicbHKXx4tiJQkxKvPPpmSaB/uj9sw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1761152196; c=relaxed/simple;
	bh=K5ts1zxKbtHrQeafsfwtNksBJBm9G0RAKYz1cXAJZTQ=;
	h=MIME-Version:Date:Message-ID:Subject:From:To:Content-Type; b=VC99ErN2NUHiJX17lVtZAHyXIBS6b5m8LSNjX67bbI9LLurZBPAz3Xnpg1kqfrRneaAhDcjRkdK9DR4bhnRkQXGFPqi/hxGWcRP5aoynzMcmB5xzTzFJqIzWBznWvgNYU+d0NN+3k0umw7pjAPXuAUgQ7oCJRJ03mEOwotZl7mI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=fail (p=none dis=none) header.from=syzkaller.appspotmail.com; spf=pass smtp.mailfrom=M3KW2WVRGUFZ5GODRSRYTGD7.apphosting.bounces.google.com; arc=none smtp.client-ip=209.85.166.207
Authentication-Results: smtp.subspace.kernel.org; dmarc=fail (p=none dis=none) header.from=syzkaller.appspotmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=M3KW2WVRGUFZ5GODRSRYTGD7.apphosting.bounces.google.com
Received: by mail-il1-f207.google.com with SMTP id e9e14a558f8ab-430da49fcbbso52709315ab.3
        for <io-uring@vger.kernel.org>; Wed, 22 Oct 2025 09:56:33 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1761152193; x=1761756993;
        h=to:from:subject:message-id:date:mime-version:x-gm-message-state
         :from:to:cc:subject:date:message-id:reply-to;
        bh=gWuTMXZEqQB35g02kJ5mUtkUDD9y4KtJo2Bhsv6c+dk=;
        b=faGTykLK1twJV03U8tYUjFC+RRGQqVLOMe0codinHDQSQuTRx3hpMDmrUNeUTZ7jfA
         JN6qhcyDXbEDHCQPAO/PmXvcsMJyWTvcdtgUJeJWE4lxznh3YejHlIe/Eu1R8eCPKQYd
         /WMNWhFfG1p8CXt8lrIyKiQOkQDV1H9EwlaY3xIA4eFj4O14riJbfN4/zZr7mnoI1esQ
         PyQ1Jx75KId8htUBo/68Vrp/lLawyOo/MKK04A3/lPEUAVQ1bFJGZLuVc92PawjmgZLP
         xscWATrBsqn7BE1BEEY5eDwQJTSb3r73OQ5MVkSLqObi9abcbiLEFDyDZkuMx1979gtl
         jbqQ==
X-Forwarded-Encrypted: i=1; AJvYcCXc+Yby0NHi0+pv1wzbdFk6J8tQeuri4RguJBSyuwy/iy89fGwkfy7w/kEn5D27WO05+jKra63BnQ==@vger.kernel.org
X-Gm-Message-State: AOJu0YzOXkbB6EJu24Yue0Qa6On347M2ZI0Ghz4dvn6KkghQSJtT7wqw
	RgdSYJp1LKVlaka/JwY0bMID7cAUYi8OqdWgpd6O2246MCOicwAIHwV2oMq5dgR9Ohi1cP8DRzH
	VrNfg6pcTKX2KmBUEl3HfS23vtOMlefhdQfOWpWd/R/2C2WTMZXxi7QeiZk8=
X-Google-Smtp-Source: AGHT+IGkTDd8ScHMrfCkgkzRd1qdCMSdndpXp4ZQMprzR6E8MB/D+pIESwHsJ9MRjxHvRpBw+jcEonXRQNWMUfLRze1qKvYe64QD
Precedence: bulk
X-Mailing-List: io-uring@vger.kernel.org
List-Id: <io-uring.vger.kernel.org>
List-Subscribe: <mailto:io-uring+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:io-uring+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-Received: by 2002:a05:6e02:1605:b0:430:a5e3:fd70 with SMTP id
 e9e14a558f8ab-430c5253b58mr280489565ab.9.1761152193292; Wed, 22 Oct 2025
 09:56:33 -0700 (PDT)
Date: Wed, 22 Oct 2025 09:56:33 -0700
X-Google-Appengine-App-Id: s~syzkaller
X-Google-Appengine-App-Id-Alias: syzkaller
Message-ID: <68f90cc1.a70a0220.3bf6c6.0020.GAE@google.com>
Subject: [syzbot] [io-uring?] general protection fault in io_uring_show_fdinfo (3)
From: syzbot <syzbot+ea6ffa4864ebe64e7a04@syzkaller.appspotmail.com>
To: axboe@kernel.dk, io-uring@vger.kernel.org, linux-kernel@vger.kernel.org, 
	syzkaller-bugs@googlegroups.com
Content-Type: text/plain; charset="UTF-8"

Hello,

syzbot found the following issue on:

HEAD commit:    aaa9c3550b60 Add linux-next specific files for 20251022
git tree:       linux-next
console output: https://syzkaller.appspot.com/x/log.txt?x=108bd734580000
kernel config:  https://syzkaller.appspot.com/x/.config?x=ad8f5526e5acd067
dashboard link: https://syzkaller.appspot.com/bug?extid=ea6ffa4864ebe64e7a04
compiler:       Debian clang version 20.1.8 (++20250708063551+0c9f909b7976-1~exp1~20250708183702.136), Debian LLD 20.1.8
syz repro:      https://syzkaller.appspot.com/x/repro.syz?x=176c9b04580000
C reproducer:   https://syzkaller.appspot.com/x/repro.c?x=173f7c58580000

Downloadable assets:
disk image: https://storage.googleapis.com/syzbot-assets/2fe0a8f92a64/disk-aaa9c355.raw.xz
vmlinux: https://storage.googleapis.com/syzbot-assets/199d2e804802/vmlinux-aaa9c355.xz
kernel image: https://storage.googleapis.com/syzbot-assets/9371d55e359e/bzImage-aaa9c355.xz

IMPORTANT: if you fix the issue, please add the following tag to the commit:
Reported-by: syzbot+ea6ffa4864ebe64e7a04@syzkaller.appspotmail.com

Oops: general protection fault, probably for non-canonical address 0xdffffc0000000000: 0000 [#1] SMP KASAN PTI
KASAN: null-ptr-deref in range [0x0000000000000000-0x0000000000000007]
CPU: 1 UID: 0 PID: 6013 Comm: syz.0.17 Not tainted syzkaller #0 PREEMPT(full) 
Hardware name: Google Google Compute Engine/Google Compute Engine, BIOS Google 10/02/2025
RIP: 0010:__io_uring_show_fdinfo io_uring/fdinfo.c:103 [inline]
RIP: 0010:io_uring_show_fdinfo+0x371/0x1840 io_uring/fdinfo.c:255
Code: 0f 85 29 04 00 00 45 8b 36 44 89 f7 44 89 ee e8 15 3b 95 00 45 39 ee 76 11 e8 4b 39 95 00 45 89 fd 4c 8b 3c 24 e9 c9 03 00 00 <80> 3b 00 45 89 fd 0f 85 17 04 00 00 0f b6 2c 25 00 00 00 00 48 8b
RSP: 0018:ffffc90003a9f928 EFLAGS: 00010293
RAX: ffffffff812b443b RBX: dffffc0000000000 RCX: 0000000000000000
RDX: ffff88802ec55ac0 RSI: 0000000000000fff RDI: 0000000000000000
RBP: 0000000000000000 R08: ffff88807aa560aa R09: 1ffff1100f54ac15
R10: dffffc0000000000 R11: ffffed100f54ac16 R12: 0000000000000008
R13: 0000000000000fff R14: 0000000000000000 R15: 0000000000000000
FS:  0000555561784500(0000) GS:ffff888125de4000(0000) knlGS:0000000000000000
CS:  0010 DS: 0000 ES: 0000 CR0: 0000000080050033
CR2: 0000001b30263fff CR3: 000000007ad30000 CR4: 00000000003526f0
Call Trace:
 <TASK>
 seq_show+0x5bc/0x730 fs/proc/fd.c:68
 seq_read_iter+0x4ef/0xe20 fs/seq_file.c:230
 seq_read+0x369/0x480 fs/seq_file.c:162
 vfs_read+0x200/0xa30 fs/read_write.c:570
 ksys_read+0x145/0x250 fs/read_write.c:715
 do_syscall_x64 arch/x86/entry/syscall_64.c:63 [inline]
 do_syscall_64+0xfa/0xfa0 arch/x86/entry/syscall_64.c:94
 entry_SYSCALL_64_after_hwframe+0x77/0x7f
RIP: 0033:0x7f2bf498efc9
Code: ff ff c3 66 2e 0f 1f 84 00 00 00 00 00 0f 1f 40 00 48 89 f8 48 89 f7 48 89 d6 48 89 ca 4d 89 c2 4d 89 c8 4c 8b 4c 24 08 0f 05 <48> 3d 01 f0 ff ff 73 01 c3 48 c7 c1 a8 ff ff ff f7 d8 64 89 01 48
RSP: 002b:00007fff1b261a48 EFLAGS: 00000246 ORIG_RAX: 0000000000000000
RAX: ffffffffffffffda RBX: 00007f2bf4be5fa0 RCX: 00007f2bf498efc9
RDX: 0000000000002020 RSI: 00002000000040c0 RDI: 0000000000000004
RBP: 00007f2bf4a11f91 R08: 0000000000000000 R09: 0000000000000000
R10: 0000000000000000 R11: 0000000000000246 R12: 0000000000000000
R13: 00007f2bf4be5fa0 R14: 00007f2bf4be5fa0 R15: 0000000000000003
 </TASK>
Modules linked in:
---[ end trace 0000000000000000 ]---
RIP: 0010:__io_uring_show_fdinfo io_uring/fdinfo.c:103 [inline]
RIP: 0010:io_uring_show_fdinfo+0x371/0x1840 io_uring/fdinfo.c:255
Code: 0f 85 29 04 00 00 45 8b 36 44 89 f7 44 89 ee e8 15 3b 95 00 45 39 ee 76 11 e8 4b 39 95 00 45 89 fd 4c 8b 3c 24 e9 c9 03 00 00 <80> 3b 00 45 89 fd 0f 85 17 04 00 00 0f b6 2c 25 00 00 00 00 48 8b
RSP: 0018:ffffc90003a9f928 EFLAGS: 00010293
RAX: ffffffff812b443b RBX: dffffc0000000000 RCX: 0000000000000000
RDX: ffff88802ec55ac0 RSI: 0000000000000fff RDI: 0000000000000000
RBP: 0000000000000000 R08: ffff88807aa560aa R09: 1ffff1100f54ac15
R10: dffffc0000000000 R11: ffffed100f54ac16 R12: 0000000000000008
R13: 0000000000000fff R14: 0000000000000000 R15: 0000000000000000
FS:  0000555561784500(0000) GS:ffff888125de4000(0000) knlGS:0000000000000000
CS:  0010 DS: 0000 ES: 0000 CR0: 0000000080050033
CR2: 00007fb550764e9c CR3: 000000007ad30000 CR4: 00000000003526f0
----------------
Code disassembly (best guess):
   0:	0f 85 29 04 00 00    	jne    0x42f
   6:	45 8b 36             	mov    (%r14),%r14d
   9:	44 89 f7             	mov    %r14d,%edi
   c:	44 89 ee             	mov    %r13d,%esi
   f:	e8 15 3b 95 00       	call   0x953b29
  14:	45 39 ee             	cmp    %r13d,%r14d
  17:	76 11                	jbe    0x2a
  19:	e8 4b 39 95 00       	call   0x953969
  1e:	45 89 fd             	mov    %r15d,%r13d
  21:	4c 8b 3c 24          	mov    (%rsp),%r15
  25:	e9 c9 03 00 00       	jmp    0x3f3
* 2a:	80 3b 00             	cmpb   $0x0,(%rbx) <-- trapping instruction
  2d:	45 89 fd             	mov    %r15d,%r13d
  30:	0f 85 17 04 00 00    	jne    0x44d
  36:	0f b6 2c 25 00 00 00 	movzbl 0x0,%ebp
  3d:	00
  3e:	48                   	rex.W
  3f:	8b                   	.byte 0x8b


---
This report is generated by a bot. It may contain errors.
See https://goo.gl/tpsmEJ for more information about syzbot.
syzbot engineers can be reached at syzkaller@googlegroups.com.

syzbot will keep track of this issue. See:
https://goo.gl/tpsmEJ#status for how to communicate with syzbot.

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

