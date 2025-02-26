Return-Path: <io-uring+bounces-6774-lists+io-uring=lfdr.de@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [147.75.80.249])
	by mail.lfdr.de (Postfix) with ESMTPS id 4BA83A4551E
	for <lists+io-uring@lfdr.de>; Wed, 26 Feb 2025 06:56:27 +0100 (CET)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id BFFD7189B44E
	for <lists+io-uring@lfdr.de>; Wed, 26 Feb 2025 05:56:33 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 644CB260A45;
	Wed, 26 Feb 2025 05:56:23 +0000 (UTC)
X-Original-To: io-uring@vger.kernel.org
Received: from mail-il1-f205.google.com (mail-il1-f205.google.com [209.85.166.205])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B17BB22FDE4
	for <io-uring@vger.kernel.org>; Wed, 26 Feb 2025 05:56:21 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.166.205
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1740549383; cv=none; b=QKGBmPIcQsqVJ84fJDouSiWFLPf7w5xgctr5LjNWd2e/vNZbjejiuK4aFh4F+kbEVZZi+2kKPV0lTG/e0cU1K1FEc5bhSEXHjCWqmOIC61yQAXNNZ+S1km3BAJZN9BoyiFJ6XvleN1s9Acp8Ivr1lkGkUbLXCP0MsfzI40fWjsk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1740549383; c=relaxed/simple;
	bh=aJ1CDj6IHG5CdCYhUfhaAMuHbGLGkJsU8mSDkSUKG/k=;
	h=MIME-Version:Date:Message-ID:Subject:From:To:Content-Type; b=jU9+QJ9OfeWgSy3r1QcwD6v/Tghs075NCt7Z7Qfu0Csvv6UULHiKM3qg6dckuDHu8R1mbcggnbIS9uauCbE1MxWwgY5RwzLcoGxHWklLHJZJGUm1jpGWag5KVF+qai/KucALGrSZiFOAg9EDRXY7jTOfokBMrCFjLxDTjGx7Wi8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=fail (p=none dis=none) header.from=syzkaller.appspotmail.com; spf=pass smtp.mailfrom=M3KW2WVRGUFZ5GODRSRYTGD7.apphosting.bounces.google.com; arc=none smtp.client-ip=209.85.166.205
Authentication-Results: smtp.subspace.kernel.org; dmarc=fail (p=none dis=none) header.from=syzkaller.appspotmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=M3KW2WVRGUFZ5GODRSRYTGD7.apphosting.bounces.google.com
Received: by mail-il1-f205.google.com with SMTP id e9e14a558f8ab-3ce843b51c3so131010505ab.0
        for <io-uring@vger.kernel.org>; Tue, 25 Feb 2025 21:56:21 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1740549381; x=1741154181;
        h=to:from:subject:message-id:date:mime-version:x-gm-message-state
         :from:to:cc:subject:date:message-id:reply-to;
        bh=HSP8CbSQTbCE3z3gezg5yrid18Cgij6SuX+4IyN9t1k=;
        b=AteonjBCfb4j64yJ5K/EOgcu8aBYnNLXtzKDJ1oQomOoXyMsOE0KuxWLPuKEFx3fN0
         Q1/K6sGpzTHd5R/NJJhe5hlAU9n2YJNbBJCMGv/oV0ElyDn1VOUb+5eUWE0hDB0Rh46D
         a7O/y8yNF81DRPcXuuUBRJ0z0XwhgLTFVU1Zj4lh5VSKByGySTqcBsl2Dowp2CM3FV/A
         qK2kGOq84LARtXVdVzww16pgg+UBUO3+7OrSlo90KnOtsue972mtb9hu148+Y2GAjHNQ
         cCWsoToVv8mrzt66GQiAgcmpTnvR+Uu6AbiXaVjSEZD6hlquJBGQddPqIGenQ0a1M6Er
         /8HA==
X-Forwarded-Encrypted: i=1; AJvYcCU7D2PW5SCY+n9I01QA6YR5hh0q5qnRjlUafQaO3l16D2l8Ph6PwkbalYwXNQdl34F5gOUy05xTZg==@vger.kernel.org
X-Gm-Message-State: AOJu0Yyh/xgbGwXExrhxvJl+5hEYbbto6oKXIb/T/ELZ+XkU4XNIyPGA
	AkyO/0bldCmdfk/NTykjmed9MYXzJTm31WNSKOmsdNJ1BLiVsUlB/NSCM79UcO6cdeu3JSpKVIN
	IKinFp0kr+k+3LL9ppmB4GAbxrFwdWJ3cPuzEvCOUkF5lQsLayEA99as=
X-Google-Smtp-Source: AGHT+IEI/C25oLPvNScwmmGwkgadLS4wD1Jjf3Kg5w27gYr7QxYS7Y67gF1WFdlmVBm20HQhF1It5bWJCaUtmVBn4tQ04g1Gf0mf
Precedence: bulk
X-Mailing-List: io-uring@vger.kernel.org
List-Id: <io-uring.vger.kernel.org>
List-Subscribe: <mailto:io-uring+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:io-uring+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-Received: by 2002:a05:6e02:310f:b0:3cf:fe21:af8 with SMTP id
 e9e14a558f8ab-3d2cb432219mr213116715ab.4.1740549380868; Tue, 25 Feb 2025
 21:56:20 -0800 (PST)
Date: Tue, 25 Feb 2025 21:56:20 -0800
X-Google-Appengine-App-Id: s~syzkaller
X-Google-Appengine-App-Id-Alias: syzkaller
Message-ID: <67bead04.050a0220.38b081.0002.GAE@google.com>
Subject: [syzbot] [io-uring?] general protection fault in native_tss_update_io_bitmap
From: syzbot <syzbot+e2b1803445d236442e54@syzkaller.appspotmail.com>
To: asml.silence@gmail.com, axboe@kernel.dk, bp@alien8.de, 
	dave.hansen@linux.intel.com, hpa@zytor.com, io-uring@vger.kernel.org, 
	linux-kernel@vger.kernel.org, mingo@redhat.com, 
	syzkaller-bugs@googlegroups.com, tglx@linutronix.de, x86@kernel.org
Content-Type: text/plain; charset="UTF-8"

Hello,

syzbot found the following issue on:

HEAD commit:    e5d3fd687aac Add linux-next specific files for 20250218
git tree:       linux-next
console output: https://syzkaller.appspot.com/x/log.txt?x=13fcd7f8580000
kernel config:  https://syzkaller.appspot.com/x/.config?x=4e945b2fe8e5992f
dashboard link: https://syzkaller.appspot.com/bug?extid=e2b1803445d236442e54
compiler:       Debian clang version 15.0.6, GNU ld (GNU Binutils for Debian) 2.40
syz repro:      https://syzkaller.appspot.com/x/repro.syz?x=149427a4580000
C reproducer:   https://syzkaller.appspot.com/x/repro.c?x=11ed06e4580000

Downloadable assets:
disk image: https://storage.googleapis.com/syzbot-assets/ef079ccd2725/disk-e5d3fd68.raw.xz
vmlinux: https://storage.googleapis.com/syzbot-assets/99f2123d6831/vmlinux-e5d3fd68.xz
kernel image: https://storage.googleapis.com/syzbot-assets/eadfc9520358/bzImage-e5d3fd68.xz

IMPORTANT: if you fix the issue, please add the following tag to the commit:
Reported-by: syzbot+e2b1803445d236442e54@syzkaller.appspotmail.com

Oops: general protection fault, probably for non-canonical address 0xdffffc0000000000: 0000 [#1] PREEMPT SMP KASAN PTI
KASAN: null-ptr-deref in range [0x0000000000000000-0x0000000000000007]
CPU: 1 UID: 0 PID: 5891 Comm: iou-sqp-5889 Not tainted 6.14.0-rc3-next-20250218-syzkaller #0
Hardware name: Google Google Compute Engine/Google Compute Engine, BIOS Google 02/12/2025
RIP: 0010:native_tss_update_io_bitmap+0x1f5/0x640 arch/x86/kernel/process.c:471
Code: ff df 48 89 44 24 50 42 80 3c 38 00 74 08 48 89 df e8 cf 75 c7 00 48 89 5c 24 58 4c 8b 2b 4c 89 f0 48 c1 e8 03 48 89 44 24 48 <42> 80 3c 38 00 74 08 4c 89 f7 e8 ac 75 c7 00 49 8b 1e 4c 89 ef 48
RSP: 0018:ffffc900042cf280 EFLAGS: 00010246
RAX: 0000000000000000 RBX: ffff8880b870a068 RCX: dffffc0000000000
RDX: 0000000000000000 RSI: 0000000000000000 RDI: 0000000000000003
RBP: ffffc900042cf380 R08: ffffffff81620a34 R09: 1ffff1100fbacb40
R10: dffffc0000000000 R11: ffffed100fbacb41 R12: 1ffff92000859e5c
R13: 0000000000000014 R14: 0000000000000000 R15: dffffc0000000000
FS:  0000555565746480(0000) GS:ffff8880b8700000(0000) knlGS:0000000000000000
CS:  0010 DS: 0000 ES: 0000 CR0: 0000000080050033
CR2: 00007f62e5469170 CR3: 000000002a054000 CR4: 00000000003526f0
DR0: 0000000000000000 DR1: 0000000000000000 DR2: 0000000000000000
DR3: 0000000000000000 DR6: 00000000fffe0ff0 DR7: 0000000000000400
Call Trace:
 <TASK>
 task_update_io_bitmap+0xb8/0xf0 arch/x86/kernel/ioport.c:47
 io_bitmap_exit+0x62/0xf0 arch/x86/kernel/ioport.c:57
 exit_thread+0x76/0xa0 arch/x86/kernel/process.c:123
 copy_process+0x277d/0x3cf0 kernel/fork.c:2638
 create_io_thread+0x16a/0x1e0 kernel/fork.c:2746
 create_io_worker+0x176/0x540 io_uring/io-wq.c:862
 io_wq_create_worker io_uring/io-wq.c:332 [inline]
 io_wq_enqueue+0x7b5/0xa00 io_uring/io-wq.c:989
 io_queue_iowq+0x433/0x670 io_uring/io_uring.c:542
 io_submit_state_end io_uring/io_uring.c:2215 [inline]
 io_submit_sqes+0x1940/0x1cf0 io_uring/io_uring.c:2335
 __io_sq_thread io_uring/sqpoll.c:189 [inline]
 io_sq_thread+0xc8c/0x1fd0 io_uring/sqpoll.c:312
 ret_from_fork+0x4b/0x80 arch/x86/kernel/process.c:148
 ret_from_fork_asm+0x1a/0x30 arch/x86/entry/entry_64.S:245
 </TASK>
Modules linked in:
---[ end trace 0000000000000000 ]---
RIP: 0010:native_tss_update_io_bitmap+0x1f5/0x640 arch/x86/kernel/process.c:471
Code: ff df 48 89 44 24 50 42 80 3c 38 00 74 08 48 89 df e8 cf 75 c7 00 48 89 5c 24 58 4c 8b 2b 4c 89 f0 48 c1 e8 03 48 89 44 24 48 <42> 80 3c 38 00 74 08 4c 89 f7 e8 ac 75 c7 00 49 8b 1e 4c 89 ef 48
RSP: 0018:ffffc900042cf280 EFLAGS: 00010246
RAX: 0000000000000000 RBX: ffff8880b870a068 RCX: dffffc0000000000
RDX: 0000000000000000 RSI: 0000000000000000 RDI: 0000000000000003
RBP: ffffc900042cf380 R08: ffffffff81620a34 R09: 1ffff1100fbacb40
R10: dffffc0000000000 R11: ffffed100fbacb41 R12: 1ffff92000859e5c
R13: 0000000000000014 R14: 0000000000000000 R15: dffffc0000000000
FS:  0000555565746480(0000) GS:ffff8880b8700000(0000) knlGS:0000000000000000
CS:  0010 DS: 0000 ES: 0000 CR0: 0000000080050033
CR2: 00007f62e5469170 CR3: 000000002a054000 CR4: 00000000003526f0
DR0: 0000000000000000 DR1: 0000000000000000 DR2: 0000000000000000
DR3: 0000000000000000 DR6: 00000000fffe0ff0 DR7: 0000000000000400
----------------
Code disassembly (best guess), 1 bytes skipped:
   0:	df 48 89             	fisttps -0x77(%rax)
   3:	44 24 50             	rex.R and $0x50,%al
   6:	42 80 3c 38 00       	cmpb   $0x0,(%rax,%r15,1)
   b:	74 08                	je     0x15
   d:	48 89 df             	mov    %rbx,%rdi
  10:	e8 cf 75 c7 00       	call   0xc775e4
  15:	48 89 5c 24 58       	mov    %rbx,0x58(%rsp)
  1a:	4c 8b 2b             	mov    (%rbx),%r13
  1d:	4c 89 f0             	mov    %r14,%rax
  20:	48 c1 e8 03          	shr    $0x3,%rax
  24:	48 89 44 24 48       	mov    %rax,0x48(%rsp)
* 29:	42 80 3c 38 00       	cmpb   $0x0,(%rax,%r15,1) <-- trapping instruction
  2e:	74 08                	je     0x38
  30:	4c 89 f7             	mov    %r14,%rdi
  33:	e8 ac 75 c7 00       	call   0xc775e4
  38:	49 8b 1e             	mov    (%r14),%rbx
  3b:	4c 89 ef             	mov    %r13,%rdi
  3e:	48                   	rex.W


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

