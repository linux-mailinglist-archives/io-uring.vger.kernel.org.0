Return-Path: <io-uring+bounces-9570-lists+io-uring=lfdr.de@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [147.75.80.249])
	by mail.lfdr.de (Postfix) with ESMTPS id EC35AB444AF
	for <lists+io-uring@lfdr.de>; Thu,  4 Sep 2025 19:49:46 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id BDFCB1C283F2
	for <lists+io-uring@lfdr.de>; Thu,  4 Sep 2025 17:50:07 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 89E7F31A577;
	Thu,  4 Sep 2025 17:49:40 +0000 (UTC)
X-Original-To: io-uring@vger.kernel.org
Received: from mail-io1-f80.google.com (mail-io1-f80.google.com [209.85.166.80])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C51703128CC
	for <io-uring@vger.kernel.org>; Thu,  4 Sep 2025 17:49:37 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.166.80
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1757008180; cv=none; b=A09m1ln8VRFlgrra0+4ANIq0cYJvg3Wixi6cpzur1igkkUgQ7MnB/69AujgZxhHfNJ8xzsgwKRFRUgdVfKn5J7Xq7v7aD9Cf2dt9JV3eGdorZ2KoRsElWUwi9UMvXENu11PGZiufaFLcJP1FQAISUmnoU/wNODGX7n1CuFAYO8M=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1757008180; c=relaxed/simple;
	bh=mHDApK+72fcX9ww0/JfPQYkZ9kEFb/psSWTUJafvN+Q=;
	h=MIME-Version:Date:Message-ID:Subject:From:To:Content-Type; b=PgNz4kubWkDY+ZfseE8enJQ7h/SYnfk3DVt7e79x2aQHVSNzBIcQ3gf5dzud3zzo9hkyAgLstF/eEgv6+wxOp7Fc9jUcAVP/n1gmj2zF6qAvbRxO7UPuTxhdcAbNAx9hlnKk16irYc8wdy88SpxG8M7jAoGuE78kNq63ozi52ak=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=fail (p=none dis=none) header.from=syzkaller.appspotmail.com; spf=pass smtp.mailfrom=M3KW2WVRGUFZ5GODRSRYTGD7.apphosting.bounces.google.com; arc=none smtp.client-ip=209.85.166.80
Authentication-Results: smtp.subspace.kernel.org; dmarc=fail (p=none dis=none) header.from=syzkaller.appspotmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=M3KW2WVRGUFZ5GODRSRYTGD7.apphosting.bounces.google.com
Received: by mail-io1-f80.google.com with SMTP id ca18e2360f4ac-88717723bc0so238976639f.1
        for <io-uring@vger.kernel.org>; Thu, 04 Sep 2025 10:49:37 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1757008177; x=1757612977;
        h=to:from:subject:message-id:date:mime-version:x-gm-message-state
         :from:to:cc:subject:date:message-id:reply-to;
        bh=6m/zJM+fxdnBcsnfXwpW04o0E8Rlbz7FqEEQlI4BDU8=;
        b=BdN6ys2HFGelWUghynUpH9jSyvU/RdH+8F7svI4d3T4IkDpTS0mEQzXQfMOCQTb/5e
         SPBsLImwXbrt64zSN9FWrNu52SfdVwsQ0ewCvOtPuToO130+ift9JEvfx8jptslX6HtT
         GiKfxd+X7Ijns7vNkFLywZOqHTZSnJFaeZRPPoWEVgHhEGOtgD2ssnhcrG4EiE3nuADO
         UwtT9huOsr0afOwsRl2cl8iOroKT1uTzHvf15g8icRMark3gbtF77MYyadJNtI020EuN
         /o/VBX+7ce7Naqf+AcVNfGlzrhnvQaQXL2BWtGDtSXfXMHHfTLQboEKIf4A1Pu/mZmVI
         Cqsg==
X-Forwarded-Encrypted: i=1; AJvYcCXrxTijRMQdakBOn9t3vUFqoN/1Sik0capc0aw67VHqw2OAuN3PVI4WOXoZ8RtEK4XhLkwst90BAw==@vger.kernel.org
X-Gm-Message-State: AOJu0YwqYLYP9C0I8r1flpPV0jacju7eyZRz6c0oACMO6KM0qS8hzQgT
	D7Cf/b1QXbNEPwyvG51X0qLR3Q/gSt3G6Ce+zkMNpCsyVnBm8A2UrAocSe7aPVAJOVhg6dTZbdQ
	fTe8RKXvDfsPWKfh3bN5alWaCPtlz0bLfZvr853lBbgoYRnWPphmRkyVOqlc=
X-Google-Smtp-Source: AGHT+IHMI8eBYiEiIrHGi7g3n3OBqG3C3AdzNkdwlTbtX++L8mfeT9vcNqwtpwRTwtP4vwIMfmrWvFAWg1BnK1X6+rj4YnRQvV1p
Precedence: bulk
X-Mailing-List: io-uring@vger.kernel.org
List-Id: <io-uring.vger.kernel.org>
List-Subscribe: <mailto:io-uring+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:io-uring+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-Received: by 2002:a6b:da0e:0:b0:886:c49e:283a with SMTP id
 ca18e2360f4ac-88767ec3454mr75494239f.9.1757008176935; Thu, 04 Sep 2025
 10:49:36 -0700 (PDT)
Date: Thu, 04 Sep 2025 10:49:36 -0700
X-Google-Appengine-App-Id: s~syzkaller
X-Google-Appengine-App-Id-Alias: syzkaller
Message-ID: <68b9d130.a00a0220.eb3d.0008.GAE@google.com>
Subject: [syzbot] [io-uring?] general protection fault in io_check_coalesce_buffer
From: syzbot <syzbot+3c84158e2daa468b2a3c@syzkaller.appspotmail.com>
To: axboe@kernel.dk, io-uring@vger.kernel.org, linux-kernel@vger.kernel.org, 
	syzkaller-bugs@googlegroups.com
Content-Type: text/plain; charset="UTF-8"

Hello,

syzbot found the following issue on:

HEAD commit:    4ac65880ebca Add linux-next specific files for 20250904
git tree:       linux-next
console output: https://syzkaller.appspot.com/x/log.txt?x=1290e312580000
kernel config:  https://syzkaller.appspot.com/x/.config?x=fbc16d9faf3a88a4
dashboard link: https://syzkaller.appspot.com/bug?extid=3c84158e2daa468b2a3c
compiler:       Debian clang version 20.1.8 (++20250708063551+0c9f909b7976-1~exp1~20250708183702.136), Debian LLD 20.1.8
syz repro:      https://syzkaller.appspot.com/x/repro.syz?x=164f1a42580000
C reproducer:   https://syzkaller.appspot.com/x/repro.c?x=1690e312580000

Downloadable assets:
disk image: https://storage.googleapis.com/syzbot-assets/36645a51612c/disk-4ac65880.raw.xz
vmlinux: https://storage.googleapis.com/syzbot-assets/bba80d634bef/vmlinux-4ac65880.xz
kernel image: https://storage.googleapis.com/syzbot-assets/e58dd70dfd0f/bzImage-4ac65880.xz

IMPORTANT: if you fix the issue, please add the following tag to the commit:
Reported-by: syzbot+3c84158e2daa468b2a3c@syzkaller.appspotmail.com

Oops: general protection fault, probably for non-canonical address 0xdffffc0000000001: 0000 [#1] SMP KASAN PTI
KASAN: null-ptr-deref in range [0x0000000000000008-0x000000000000000f]
CPU: 0 UID: 0 PID: 6175 Comm: syz.2.19 Not tainted syzkaller #0 PREEMPT(full) 
Hardware name: Google Google Compute Engine/Google Compute Engine, BIOS Google 07/12/2025
RIP: 0010:_compound_head include/linux/page-flags.h:284 [inline]
RIP: 0010:io_check_coalesce_buffer+0x354/0xb60 io_uring/rsrc.c:746
Code: f7 e8 e0 64 63 fd 4c 89 74 24 28 48 8b 44 24 18 4c 8b 74 d8 08 49 8d 6e 08 48 89 e8 48 c1 e8 03 48 b9 00 00 00 00 00 fc ff df <80> 3c 08 00 74 08 48 89 ef e8 ae 64 63 fd 48 8b 6d 00 48 89 ee 48
RSP: 0018:ffffc90003a5fa38 EFLAGS: 00010202
RAX: 0000000000000001 RBX: 00000000000001ff RCX: dffffc0000000000
RDX: 0000000000000000 RSI: 0000000000000001 RDI: ffff888024768ff8
RBP: 0000000000000008 R08: ffffea0001908007 R09: 1ffffd4000321000
R10: dffffc0000000000 R11: fffff94000321001 R12: ffff888024768ff8
R13: 0000000000000200 R14: 0000000000000000 R15: ffffea0001908000
FS:  00007fb6be5816c0(0000) GS:ffff8881259fa000(0000) knlGS:0000000000000000
CS:  0010 DS: 0000 ES: 0000 CR0: 0000000080050033
CR2: 0000200000095030 CR3: 0000000078fd4000 CR4: 00000000003526f0
Call Trace:
 <TASK>
 io_sqe_buffer_register+0x1ef/0x20a0 io_uring/rsrc.c:807
 io_sqe_buffers_register+0x3b9/0x8e0 io_uring/rsrc.c:913
 __io_uring_register io_uring/register.c:657 [inline]
 __do_sys_io_uring_register io_uring/register.c:926 [inline]
 __se_sys_io_uring_register+0xb85/0x11b0 io_uring/register.c:903
 do_syscall_x64 arch/x86/entry/syscall_64.c:63 [inline]
 do_syscall_64+0xfa/0xfa0 arch/x86/entry/syscall_64.c:94
 entry_SYSCALL_64_after_hwframe+0x77/0x7f
RIP: 0033:0x7fb6bd78ebe9
Code: ff ff c3 66 2e 0f 1f 84 00 00 00 00 00 0f 1f 40 00 48 89 f8 48 89 f7 48 89 d6 48 89 ca 4d 89 c2 4d 89 c8 4c 8b 4c 24 08 0f 05 <48> 3d 01 f0 ff ff 73 01 c3 48 c7 c1 a8 ff ff ff f7 d8 64 89 01 48
RSP: 002b:00007fb6be581038 EFLAGS: 00000246 ORIG_RAX: 00000000000001ab
RAX: ffffffffffffffda RBX: 00007fb6bd9c6180 RCX: 00007fb6bd78ebe9
RDX: 00002000000002c0 RSI: 0000000000000000 RDI: 0000000000000005
RBP: 00007fb6bd811e19 R08: 0000000000000000 R09: 0000000000000000
R10: 100000000000011a R11: 0000000000000246 R12: 0000000000000000
R13: 00007fb6bd9c6218 R14: 00007fb6bd9c6180 R15: 00007ffdb92f0a28
 </TASK>
Modules linked in:
---[ end trace 0000000000000000 ]---
RIP: 0010:_compound_head include/linux/page-flags.h:284 [inline]
RIP: 0010:io_check_coalesce_buffer+0x354/0xb60 io_uring/rsrc.c:746
Code: f7 e8 e0 64 63 fd 4c 89 74 24 28 48 8b 44 24 18 4c 8b 74 d8 08 49 8d 6e 08 48 89 e8 48 c1 e8 03 48 b9 00 00 00 00 00 fc ff df <80> 3c 08 00 74 08 48 89 ef e8 ae 64 63 fd 48 8b 6d 00 48 89 ee 48
RSP: 0018:ffffc90003a5fa38 EFLAGS: 00010202
RAX: 0000000000000001 RBX: 00000000000001ff RCX: dffffc0000000000
RDX: 0000000000000000 RSI: 0000000000000001 RDI: ffff888024768ff8
RBP: 0000000000000008 R08: ffffea0001908007 R09: 1ffffd4000321000
R10: dffffc0000000000 R11: fffff94000321001 R12: ffff888024768ff8
R13: 0000000000000200 R14: 0000000000000000 R15: ffffea0001908000
FS:  00007fb6be5816c0(0000) GS:ffff8881259fa000(0000) knlGS:0000000000000000
CS:  0010 DS: 0000 ES: 0000 CR0: 0000000080050033
CR2: 0000200000095030 CR3: 0000000078fd4000 CR4: 00000000003526f0
----------------
Code disassembly (best guess):
   0:	f7 e8                	imul   %eax
   2:	e0 64                	loopne 0x68
   4:	63 fd                	movsxd %ebp,%edi
   6:	4c 89 74 24 28       	mov    %r14,0x28(%rsp)
   b:	48 8b 44 24 18       	mov    0x18(%rsp),%rax
  10:	4c 8b 74 d8 08       	mov    0x8(%rax,%rbx,8),%r14
  15:	49 8d 6e 08          	lea    0x8(%r14),%rbp
  19:	48 89 e8             	mov    %rbp,%rax
  1c:	48 c1 e8 03          	shr    $0x3,%rax
  20:	48 b9 00 00 00 00 00 	movabs $0xdffffc0000000000,%rcx
  27:	fc ff df
* 2a:	80 3c 08 00          	cmpb   $0x0,(%rax,%rcx,1) <-- trapping instruction
  2e:	74 08                	je     0x38
  30:	48 89 ef             	mov    %rbp,%rdi
  33:	e8 ae 64 63 fd       	call   0xfd6364e6
  38:	48 8b 6d 00          	mov    0x0(%rbp),%rbp
  3c:	48 89 ee             	mov    %rbp,%rsi
  3f:	48                   	rex.W


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

