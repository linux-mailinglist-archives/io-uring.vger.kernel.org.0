Return-Path: <io-uring+bounces-4331-lists+io-uring=lfdr.de@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from sy.mirrors.kernel.org (sy.mirrors.kernel.org [IPv6:2604:1380:40f1:3f00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 84F939B9927
	for <lists+io-uring@lfdr.de>; Fri,  1 Nov 2024 21:07:39 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sy.mirrors.kernel.org (Postfix) with ESMTPS id D233AB21207
	for <lists+io-uring@lfdr.de>; Fri,  1 Nov 2024 20:07:36 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 6FF861D1E77;
	Fri,  1 Nov 2024 20:07:35 +0000 (UTC)
X-Original-To: io-uring@vger.kernel.org
Received: from mail-il1-f198.google.com (mail-il1-f198.google.com [209.85.166.198])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B07FB1D2B11
	for <io-uring@vger.kernel.org>; Fri,  1 Nov 2024 20:07:33 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.166.198
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1730491655; cv=none; b=ZHCP1GAQPHIms6UIQllDl+CFOr9RI3kPnYu/bhNGd/Rg2cGNpn6x8dIMeiw8ToLAki2S+WHmy8bcdrL89XDcN1TpF4Njdl5q8Bm4+b1SPBXVQTzuPDcHdc/tgtkxrJN+cnScZGU8Zll4uTda9h8Ayd9kCK7AAOQnsteeWz1hRm4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1730491655; c=relaxed/simple;
	bh=pLCSgf1FA7YufT7FjypRtJtCBin2sqPNA2G6Ffx8JmY=;
	h=MIME-Version:Date:Message-ID:Subject:From:To:Content-Type; b=rzoi3GrgxYmD8+vMizKRSxzPDcbZ7HPB4Rm/Ho98Y4oh9O/x0VkMeBeM+cVHb5l7PK2eduzp3KL+KGO2hOV1TVH/D9xZpraxMJjzS6qOF68wCWVLXMOBi4JqtHv/okeH9PVGQIFTaIIhvqrH7LU0qs6qA5ZnCUYhIw69XapPH8Y=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=fail (p=none dis=none) header.from=syzkaller.appspotmail.com; spf=pass smtp.mailfrom=M3KW2WVRGUFZ5GODRSRYTGD7.apphosting.bounces.google.com; arc=none smtp.client-ip=209.85.166.198
Authentication-Results: smtp.subspace.kernel.org; dmarc=fail (p=none dis=none) header.from=syzkaller.appspotmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=M3KW2WVRGUFZ5GODRSRYTGD7.apphosting.bounces.google.com
Received: by mail-il1-f198.google.com with SMTP id e9e14a558f8ab-3a4e41e2732so22794915ab.2
        for <io-uring@vger.kernel.org>; Fri, 01 Nov 2024 13:07:33 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1730491652; x=1731096452;
        h=to:from:subject:message-id:date:mime-version:x-gm-message-state
         :from:to:cc:subject:date:message-id:reply-to;
        bh=WKkXYUGj7iwxbjiKax0C3RrxchxN2fGDD9Ow3Ftv1DU=;
        b=U6xvYakUiSk9byg1Q/8d4ACgaj6n9HZ73Le5ifSWrVta0GnELHRA3+wxJYJZ0lPZIx
         EaS5um0PSXle9U6pqjX76dUfIozPHr4Qz3qsaQDLI6KMvCyL51pCXF02lNq8o6RkfRWq
         l7tWfNWe0xleOrDAGQsb2LEpBg0wP41q6xlonV2aRL8ZHGBOhRwI3JNYudncvIKa48mG
         5xdhW9GkHoUPwgi8et+H/umg+OrhkBQ5Kyw49WJ7CNyiYu1/nmU4JQTST/U02Jw1i72P
         TONeehhEAhsR+I6QZFK5rIcWXQzrgWHkiSQI7vdWbKrdvj+sw4ZZVau0zJoF3QQMtQPu
         rnUw==
X-Forwarded-Encrypted: i=1; AJvYcCX3p6c9JmhLYcr1lHDDaqjexFbWvF9YLKFpAVG55kLv7tu8nJIESLP3Ncqtwzim0UhEl/yOjeQH1w==@vger.kernel.org
X-Gm-Message-State: AOJu0YwLE0VNARqupAVuXut8pQpPQgIygUT7GUQm1ePepo+loA5WI2SU
	eIHZCDIoqR3IqaGZVD8TJGUyE7oh/SvFDB8CL/ZbYt20RJ9ifizn/rjvnGb9OEWhjBQbBHkrejj
	Zq8vXPQVLpryjmAFCPch0hSC9MmnDEgWlnYRns9En86AfTrP+gV+2GGs=
X-Google-Smtp-Source: AGHT+IElId++NX4OCR+e50oEteEN2/ewKdWt5dAGF5kq255zp5JCCSVY8a/ac7cvhnmE11BJXFu8qEcaOS68LzeocUNavBOmRL7o
Precedence: bulk
X-Mailing-List: io-uring@vger.kernel.org
List-Id: <io-uring.vger.kernel.org>
List-Subscribe: <mailto:io-uring+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:io-uring+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-Received: by 2002:a05:6e02:1548:b0:3a2:6ce9:19c6 with SMTP id
 e9e14a558f8ab-3a4ed30fe20mr242408415ab.25.1730491652715; Fri, 01 Nov 2024
 13:07:32 -0700 (PDT)
Date: Fri, 01 Nov 2024 13:07:32 -0700
X-Google-Appengine-App-Id: s~syzkaller
X-Google-Appengine-App-Id-Alias: syzkaller
Message-ID: <67253504.050a0220.3c8d68.08e1.GAE@google.com>
Subject: [syzbot] [io-uring?] general protection fault in io_sqe_buffer_register
From: syzbot <syzbot+05c0f12a4d43d656817e@syzkaller.appspotmail.com>
To: asml.silence@gmail.com, axboe@kernel.dk, io-uring@vger.kernel.org, 
	linux-kernel@vger.kernel.org, syzkaller-bugs@googlegroups.com
Content-Type: text/plain; charset="UTF-8"

Hello,

syzbot found the following issue on:

HEAD commit:    f9f24ca362a4 Add linux-next specific files for 20241031
git tree:       linux-next
console+strace: https://syzkaller.appspot.com/x/log.txt?x=12052630580000
kernel config:  https://syzkaller.appspot.com/x/.config?x=328572ed4d152be9
dashboard link: https://syzkaller.appspot.com/bug?extid=05c0f12a4d43d656817e
compiler:       Debian clang version 15.0.6, GNU ld (GNU Binutils for Debian) 2.40
syz repro:      https://syzkaller.appspot.com/x/repro.syz?x=15abc6f7980000
C reproducer:   https://syzkaller.appspot.com/x/repro.c?x=10eb655f980000

Downloadable assets:
disk image: https://storage.googleapis.com/syzbot-assets/eb84549dd6b3/disk-f9f24ca3.raw.xz
vmlinux: https://storage.googleapis.com/syzbot-assets/beb29bdfa297/vmlinux-f9f24ca3.xz
kernel image: https://storage.googleapis.com/syzbot-assets/8881fe3245ad/bzImage-f9f24ca3.xz

IMPORTANT: if you fix the issue, please add the following tag to the commit:
Reported-by: syzbot+05c0f12a4d43d656817e@syzkaller.appspotmail.com

Oops: general protection fault, probably for non-canonical address 0xdffffc0000000003: 0000 [#1] PREEMPT SMP KASAN PTI
KASAN: null-ptr-deref in range [0x0000000000000018-0x000000000000001f]
CPU: 0 UID: 0 PID: 5845 Comm: syz-executor176 Not tainted 6.12.0-rc5-next-20241031-syzkaller #0
Hardware name: Google Google Compute Engine/Google Compute Engine, BIOS Google 09/13/2024
RIP: 0010:headpage_already_acct io_uring/rsrc.c:584 [inline]
RIP: 0010:io_buffer_account_pin io_uring/rsrc.c:614 [inline]
RIP: 0010:io_sqe_buffer_register+0xaa8/0x2cf0 io_uring/rsrc.c:758
Code: 00 fc ff df 80 3c 08 00 74 08 48 89 df e8 b0 8a 55 fd 48 8b 1b 48 83 c3 18 48 89 d8 48 c1 e8 03 48 b9 00 00 00 00 00 fc ff df <80> 3c 08 00 74 08 48 89 df e8 8a 8a 55 fd 48 8b 03 48 89 44 24 60
RSP: 0018:ffffc90003faf640 EFLAGS: 00010206
RAX: 0000000000000003 RBX: 0000000000000018 RCX: dffffc0000000000
RDX: ffff88807ef14128 RSI: 0000000000000000 RDI: 0000000000000000
RBP: ffffc90003faf7f0 R08: ffffffff84a9ce37 R09: 1ffffd40003a8000
R10: dffffc0000000000 R11: fffff940003a8001 R12: ffffea0001d40000
R13: 0000000000000006 R14: 1ffff110060dc350 R15: ffff8880306e1a80
FS:  00005555684d7380(0000) GS:ffff8880b8600000(0000) knlGS:0000000000000000
CS:  0010 DS: 0000 ES: 0000 CR0: 0000000080050033
CR2: 0000000020010404 CR3: 000000007ea62000 CR4: 00000000003526f0
DR0: 0000000000000000 DR1: 0000000000000000 DR2: 0000000000000000
DR3: 0000000000000000 DR6: 00000000fffe0ff0 DR7: 0000000000000400
Call Trace:
 <TASK>
 __io_sqe_buffers_update io_uring/rsrc.c:257 [inline]
 __io_register_rsrc_update+0x5c8/0x1320 io_uring/rsrc.c:295
 io_register_rsrc_update+0x1d1/0x230 io_uring/rsrc.c:326
 __do_sys_io_uring_register io_uring/register.c:938 [inline]
 __se_sys_io_uring_register+0x8ee/0x40d0 io_uring/register.c:915
 do_syscall_x64 arch/x86/entry/common.c:52 [inline]
 do_syscall_64+0xf3/0x230 arch/x86/entry/common.c:83
 entry_SYSCALL_64_after_hwframe+0x77/0x7f
RIP: 0033:0x7f96c01b8469
Code: 48 83 c4 28 c3 e8 37 17 00 00 0f 1f 80 00 00 00 00 48 89 f8 48 89 f7 48 89 d6 48 89 ca 4d 89 c2 4d 89 c8 4c 8b 4c 24 08 0f 05 <48> 3d 01 f0 ff ff 73 01 c3 48 c7 c1 b8 ff ff ff f7 d8 64 89 01 48
RSP: 002b:00007ffc4e36b3a8 EFLAGS: 00000246 ORIG_RAX: 00000000000001ab
RAX: ffffffffffffffda RBX: 00000000000004b5 RCX: 00007f96c01b8469
RDX: 0000000020000600 RSI: 0000000000000010 RDI: 0000000000000003
RBP: 0000000000000003 R08: 00000000000ac5f8 R09: 00000000000ac5f8
R10: 0000000000000020 R11: 0000000000000246 R12: 0000000000000001
R13: 00007ffc4e36b578 R14: 0000000000000001 R15: 0000000000000001
 </TASK>
Modules linked in:
---[ end trace 0000000000000000 ]---
RIP: 0010:headpage_already_acct io_uring/rsrc.c:584 [inline]
RIP: 0010:io_buffer_account_pin io_uring/rsrc.c:614 [inline]
RIP: 0010:io_sqe_buffer_register+0xaa8/0x2cf0 io_uring/rsrc.c:758
Code: 00 fc ff df 80 3c 08 00 74 08 48 89 df e8 b0 8a 55 fd 48 8b 1b 48 83 c3 18 48 89 d8 48 c1 e8 03 48 b9 00 00 00 00 00 fc ff df <80> 3c 08 00 74 08 48 89 df e8 8a 8a 55 fd 48 8b 03 48 89 44 24 60
RSP: 0018:ffffc90003faf640 EFLAGS: 00010206
RAX: 0000000000000003 RBX: 0000000000000018 RCX: dffffc0000000000
RDX: ffff88807ef14128 RSI: 0000000000000000 RDI: 0000000000000000
RBP: ffffc90003faf7f0 R08: ffffffff84a9ce37 R09: 1ffffd40003a8000
R10: dffffc0000000000 R11: fffff940003a8001 R12: ffffea0001d40000
R13: 0000000000000006 R14: 1ffff110060dc350 R15: ffff8880306e1a80
FS:  00005555684d7380(0000) GS:ffff8880b8700000(0000) knlGS:0000000000000000
CS:  0010 DS: 0000 ES: 0000 CR0: 0000000080050033
CR2: 00007f96c017d020 CR3: 000000007ea62000 CR4: 00000000003526f0
DR0: 0000000000000000 DR1: 0000000000000000 DR2: 0000000000000000
DR3: 0000000000000000 DR6: 00000000fffe0ff0 DR7: 0000000000000400
----------------
Code disassembly (best guess), 3 bytes skipped:
   0:	df 80 3c 08 00 74    	filds  0x7400083c(%rax)
   6:	08 48 89             	or     %cl,-0x77(%rax)
   9:	df e8                	fucomip %st(0),%st
   b:	b0 8a                	mov    $0x8a,%al
   d:	55                   	push   %rbp
   e:	fd                   	std
   f:	48 8b 1b             	mov    (%rbx),%rbx
  12:	48 83 c3 18          	add    $0x18,%rbx
  16:	48 89 d8             	mov    %rbx,%rax
  19:	48 c1 e8 03          	shr    $0x3,%rax
  1d:	48 b9 00 00 00 00 00 	movabs $0xdffffc0000000000,%rcx
  24:	fc ff df
* 27:	80 3c 08 00          	cmpb   $0x0,(%rax,%rcx,1) <-- trapping instruction
  2b:	74 08                	je     0x35
  2d:	48 89 df             	mov    %rbx,%rdi
  30:	e8 8a 8a 55 fd       	call   0xfd558abf
  35:	48 8b 03             	mov    (%rbx),%rax
  38:	48 89 44 24 60       	mov    %rax,0x60(%rsp)


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

