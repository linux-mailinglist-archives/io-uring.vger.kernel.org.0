Return-Path: <io-uring+bounces-10169-lists+io-uring=lfdr.de@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from ams.mirrors.kernel.org (ams.mirrors.kernel.org [213.196.21.55])
	by mail.lfdr.de (Postfix) with ESMTPS id 9FADAC0383A
	for <lists+io-uring@lfdr.de>; Thu, 23 Oct 2025 23:21:41 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ams.mirrors.kernel.org (Postfix) with ESMTPS id B085B3585E5
	for <lists+io-uring@lfdr.de>; Thu, 23 Oct 2025 21:21:40 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id CD53E246781;
	Thu, 23 Oct 2025 21:21:36 +0000 (UTC)
X-Original-To: io-uring@vger.kernel.org
Received: from mail-il1-f206.google.com (mail-il1-f206.google.com [209.85.166.206])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0F9DF238C0B
	for <io-uring@vger.kernel.org>; Thu, 23 Oct 2025 21:21:34 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.166.206
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1761254496; cv=none; b=q//maAIv9SOouvP7UF2qk4kG7Dgz+C3p/k8t+I8HjUxF+/YtWVNIfuslvhLbrVo0v+h/S+iykjqccUy3q6679SVlzmEjd68hIaBVjU3bT+Qiu4nbcNvA/RE0JHXfn9veGMTdCFZylcLsRQETL+ojZGw5xueNBqElKDX2JFrg0nc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1761254496; c=relaxed/simple;
	bh=QJ4Ncd1l1a3EXBJZnjSI6trhLWKbGx9AJeaXGuy80eE=;
	h=MIME-Version:Date:Message-ID:Subject:From:To:Content-Type; b=budeKbm/JWaBy7+iyg7Hsi+5F2yIR4EMQVjwtYu4olBifh4ipsscqIFcI9XBavb26ANE4ewLelUucvNJsPNfLsYsaTpQeZz6XDVy0ZzzglAG0FMWFFRLR3KmlD7kbQAgxsAy70dwGY3g1U2eN5geEcsvHKGVXmr79h6aGvRPlEo=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=fail (p=none dis=none) header.from=syzkaller.appspotmail.com; spf=pass smtp.mailfrom=M3KW2WVRGUFZ5GODRSRYTGD7.apphosting.bounces.google.com; arc=none smtp.client-ip=209.85.166.206
Authentication-Results: smtp.subspace.kernel.org; dmarc=fail (p=none dis=none) header.from=syzkaller.appspotmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=M3KW2WVRGUFZ5GODRSRYTGD7.apphosting.bounces.google.com
Received: by mail-il1-f206.google.com with SMTP id e9e14a558f8ab-430c6b6ce73so37910625ab.0
        for <io-uring@vger.kernel.org>; Thu, 23 Oct 2025 14:21:34 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1761254494; x=1761859294;
        h=to:from:subject:message-id:date:mime-version:x-gm-message-state
         :from:to:cc:subject:date:message-id:reply-to;
        bh=mJgfC9Kj5UQMZsm8dRwu+O4pwBoVzy6ZLOox70cQpM0=;
        b=Z3z88C3eK/0DqtBuZklXhYW77cTHrBagubC5qdzs2n+gEBKbpbw/W/KSwW8TL8Ejqn
         DYzi5FE2D4igfmvp0FYagU6daO7MPix1FcjnT459B25S5vZPSFVYlV6ZLIahs8M8b8fg
         r5XQFbvlrQABCx0AO5xtXsb6XNDdAPvaO51TNK9esgXqQaD50YFe7x032+CLpFPnxaD+
         B+FMhcT7+kSdsW1McvYgIfv1BzsvEb0VNVBciv4MF6sgIBBpseeXTdzOrH/aSFX9g2gk
         Uljqe3gTa9CoJkCj9vRl5HSYqZvnXtsM7TXLKhQ7aBA99j1snf3JRDFtlKe0GcBSJP9P
         syfQ==
X-Forwarded-Encrypted: i=1; AJvYcCXM69lC8sucAMZWaSjGieWSaGQ4TFp0kp2WdS9PRBjsDO8nHLVlP/sA0Fnh7w3D8fOGGA3pOjv1yQ==@vger.kernel.org
X-Gm-Message-State: AOJu0YwoP3kqxwLBtCw7lsNWS+XkkQiobh4BMqV0E8oQUgscJSDaPqcf
	CVUpRnGex9JaxMqxJzsaITMvpO7M2xldDoY5rVu6CRwxgNEgxfvcBV1Ri3fN2oYwKRyiZKZgTX1
	WzhwKamou4SKtyT65jffWnTFKW9cZwr7X3VRGAvKXn67ZEFdfSKns+cdceh0=
X-Google-Smtp-Source: AGHT+IFHUVZVOKKsGkFHUjX+mVLjoKCbdBi1O/OOmfMAVUKPpRDr67Q9/JoA0dbeDx6szZQDJTXYfUyz0yQHr9o2oEw0hupIiCnu
Precedence: bulk
X-Mailing-List: io-uring@vger.kernel.org
List-Id: <io-uring.vger.kernel.org>
List-Subscribe: <mailto:io-uring+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:io-uring+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-Received: by 2002:a05:6e02:3807:b0:430:c0cf:7920 with SMTP id
 e9e14a558f8ab-430c527bc73mr348783845ab.19.1761254494132; Thu, 23 Oct 2025
 14:21:34 -0700 (PDT)
Date: Thu, 23 Oct 2025 14:21:34 -0700
X-Google-Appengine-App-Id: s~syzkaller
X-Google-Appengine-App-Id-Alias: syzkaller
Message-ID: <68fa9c5e.a70a0220.3bf6c6.00c9.GAE@google.com>
Subject: [syzbot] [io-uring?] general protection fault in io_uring_show_fdinfo (4)
From: syzbot <syzbot+a77f64386b3e1b2ebb51@syzkaller.appspotmail.com>
To: axboe@kernel.dk, io-uring@vger.kernel.org, kbusch@kernel.org, 
	linux-kernel@vger.kernel.org, syzkaller-bugs@googlegroups.com
Content-Type: text/plain; charset="UTF-8"

Hello,

syzbot found the following issue on:

HEAD commit:    aaa9c3550b60 Add linux-next specific files for 20251022
git tree:       linux-next
console output: https://syzkaller.appspot.com/x/log.txt?x=11880c92580000
kernel config:  https://syzkaller.appspot.com/x/.config?x=c8b911aebadf6410
dashboard link: https://syzkaller.appspot.com/bug?extid=a77f64386b3e1b2ebb51
compiler:       Debian clang version 20.1.8 (++20250708063551+0c9f909b7976-1~exp1~20250708183702.136), Debian LLD 20.1.8
syz repro:      https://syzkaller.appspot.com/x/repro.syz?x=12e73734580000
C reproducer:   https://syzkaller.appspot.com/x/repro.c?x=102f43e2580000

Downloadable assets:
disk image: https://storage.googleapis.com/syzbot-assets/44f7af9b7ca1/disk-aaa9c355.raw.xz
vmlinux: https://storage.googleapis.com/syzbot-assets/9d09b0a9994d/vmlinux-aaa9c355.xz
kernel image: https://storage.googleapis.com/syzbot-assets/ae729ccb2c5c/bzImage-aaa9c355.xz

The issue was bisected to:

commit 31dc41afdef21f264364288a30013b538c46152e
Author: Keith Busch <kbusch@kernel.org>
Date:   Thu Oct 16 18:09:38 2025 +0000

    io_uring: add support for IORING_SETUP_SQE_MIXED

bisection log:  https://syzkaller.appspot.com/x/bisect.txt?x=12eac614580000
final oops:     https://syzkaller.appspot.com/x/report.txt?x=11eac614580000
console output: https://syzkaller.appspot.com/x/log.txt?x=16eac614580000

IMPORTANT: if you fix the issue, please add the following tag to the commit:
Reported-by: syzbot+a77f64386b3e1b2ebb51@syzkaller.appspotmail.com
Fixes: 31dc41afdef2 ("io_uring: add support for IORING_SETUP_SQE_MIXED")

Oops: general protection fault, probably for non-canonical address 0xdffffc0000000000: 0000 [#1] SMP KASAN PTI
KASAN: null-ptr-deref in range [0x0000000000000000-0x0000000000000007]
CPU: 0 UID: 0 PID: 6032 Comm: syz.0.17 Not tainted syzkaller #0 PREEMPT(full) 
Hardware name: Google Google Compute Engine/Google Compute Engine, BIOS Google 10/02/2025
RIP: 0010:__io_uring_show_fdinfo io_uring/fdinfo.c:103 [inline]
RIP: 0010:io_uring_show_fdinfo+0x371/0x1840 io_uring/fdinfo.c:255
Code: 0f 85 29 04 00 00 45 8b 36 44 89 f7 44 89 ee e8 a5 ec 94 00 45 39 ee 76 11 e8 db ea 94 00 45 89 fd 4c 8b 3c 24 e9 c9 03 00 00 <80> 3b 00 45 89 fd 0f 85 17 04 00 00 0f b6 2c 25 00 00 00 00 48 8b
RSP: 0018:ffffc9000392f928 EFLAGS: 00010293
RAX: ffffffff812b42ab RBX: dffffc0000000000 RCX: 0000000000000000
RDX: ffff888026c65ac0 RSI: 00000000000001ff RDI: 0000000000000000
RBP: 0000000000000000 R08: ffff888069c000aa R09: 1ffff1100d380015
R10: dffffc0000000000 R11: ffffed100d380016 R12: 0000000000000008
R13: 00000000000001ff R14: 0000000000000000 R15: 0000000000000000
FS:  000055556a027500(0000) GS:ffff888125f29000(0000) knlGS:0000000000000000
CS:  0010 DS: 0000 ES: 0000 CR0: 0000000080050033
CR2: 0000001b30363fff CR3: 0000000076c50000 CR4: 00000000003526f0
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
RIP: 0033:0x7f198c78efc9
Code: ff ff c3 66 2e 0f 1f 84 00 00 00 00 00 0f 1f 40 00 48 89 f8 48 89 f7 48 89 d6 48 89 ca 4d 89 c2 4d 89 c8 4c 8b 4c 24 08 0f 05 <48> 3d 01 f0 ff ff 73 01 c3 48 c7 c1 a8 ff ff ff f7 d8 64 89 01 48
RSP: 002b:00007fffae1a3128 EFLAGS: 00000246 ORIG_RAX: 0000000000000000
RAX: ffffffffffffffda RBX: 00007f198c9e5fa0 RCX: 00007f198c78efc9
RDX: 0000000000002020 RSI: 00002000000040c0 RDI: 0000000000000004
RBP: 00007f198c811f91 R08: 0000000000000000 R09: 0000000000000000
R10: 0000000000000000 R11: 0000000000000246 R12: 0000000000000000
R13: 00007f198c9e5fa0 R14: 00007f198c9e5fa0 R15: 0000000000000003
 </TASK>
Modules linked in:
---[ end trace 0000000000000000 ]---
RIP: 0010:__io_uring_show_fdinfo io_uring/fdinfo.c:103 [inline]
RIP: 0010:io_uring_show_fdinfo+0x371/0x1840 io_uring/fdinfo.c:255
Code: 0f 85 29 04 00 00 45 8b 36 44 89 f7 44 89 ee e8 a5 ec 94 00 45 39 ee 76 11 e8 db ea 94 00 45 89 fd 4c 8b 3c 24 e9 c9 03 00 00 <80> 3b 00 45 89 fd 0f 85 17 04 00 00 0f b6 2c 25 00 00 00 00 48 8b
RSP: 0018:ffffc9000392f928 EFLAGS: 00010293
RAX: ffffffff812b42ab RBX: dffffc0000000000 RCX: 0000000000000000
RDX: ffff888026c65ac0 RSI: 00000000000001ff RDI: 0000000000000000
RBP: 0000000000000000 R08: ffff888069c000aa R09: 1ffff1100d380015
R10: dffffc0000000000 R11: ffffed100d380016 R12: 0000000000000008
R13: 00000000000001ff R14: 0000000000000000 R15: 0000000000000000
FS:  000055556a027500(0000) GS:ffff888125f29000(0000) knlGS:0000000000000000
CS:  0010 DS: 0000 ES: 0000 CR0: 0000000080050033
CR2: 0000001b30363fff CR3: 0000000076c50000 CR4: 00000000003526f0
----------------
Code disassembly (best guess):
   0:	0f 85 29 04 00 00    	jne    0x42f
   6:	45 8b 36             	mov    (%r14),%r14d
   9:	44 89 f7             	mov    %r14d,%edi
   c:	44 89 ee             	mov    %r13d,%esi
   f:	e8 a5 ec 94 00       	call   0x94ecb9
  14:	45 39 ee             	cmp    %r13d,%r14d
  17:	76 11                	jbe    0x2a
  19:	e8 db ea 94 00       	call   0x94eaf9
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

