Return-Path: <io-uring+bounces-8984-lists+io-uring=lfdr.de@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [147.75.80.249])
	by mail.lfdr.de (Postfix) with ESMTPS id EAC17B28B73
	for <lists+io-uring@lfdr.de>; Sat, 16 Aug 2025 09:30:30 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id 449E81CE6864
	for <lists+io-uring@lfdr.de>; Sat, 16 Aug 2025 07:30:50 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 22F237081F;
	Sat, 16 Aug 2025 07:30:29 +0000 (UTC)
X-Original-To: io-uring@vger.kernel.org
Received: from mail-il1-f199.google.com (mail-il1-f199.google.com [209.85.166.199])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4A226217F36
	for <io-uring@vger.kernel.org>; Sat, 16 Aug 2025 07:30:27 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.166.199
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1755329429; cv=none; b=ObXRqU2V2CCIBe5ahGwtIN7BkKBeD8w9F+ZrNJRAdYrYNYODpAVctoLdOlxUH/XzNzH8T0kypb5HKvF2CZu+J52qZhEbF9uPuuNafu4JOeA7FpUG7N55wpzp3eSJPavmvgh1xA4lAs1zUm5Kkav+qIYM4YBxuhxW/WWR6CUe/FA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1755329429; c=relaxed/simple;
	bh=X9j3eKFGq11QwM9nhg0P1onKwRN6+n6i+pPjJ26anLA=;
	h=MIME-Version:Date:In-Reply-To:Message-ID:Subject:From:To:Cc:
	 Content-Type; b=Wl9K+jo/BBxQWtJBHj6tEMwcZH085as9YbxbYWpQQAoFKJhgf2VFu7f0eRa/cv3DQNgXUAnCAeAUxqYyEefLIis3tE3V6KRpZatx9Sin1PWFN9k7mUw7vk1vBy14DsmiZMAcdoNqL6Ueujej5DzVwSjoIZtnPMATw2JsqdtXyZw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=fail (p=none dis=none) header.from=syzkaller.appspotmail.com; spf=pass smtp.mailfrom=M3KW2WVRGUFZ5GODRSRYTGD7.apphosting.bounces.google.com; arc=none smtp.client-ip=209.85.166.199
Authentication-Results: smtp.subspace.kernel.org; dmarc=fail (p=none dis=none) header.from=syzkaller.appspotmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=M3KW2WVRGUFZ5GODRSRYTGD7.apphosting.bounces.google.com
Received: by mail-il1-f199.google.com with SMTP id e9e14a558f8ab-3e56ff1b629so76458425ab.0
        for <io-uring@vger.kernel.org>; Sat, 16 Aug 2025 00:30:27 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1755329426; x=1755934226;
        h=cc:to:from:subject:message-id:in-reply-to:date:mime-version
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=E8ZzlfslUfQ7sfDo+fe8cd+2+/YVyjoPRyuYUu7rKFY=;
        b=cNIZuGMCgEXsIal0CEENGTwtvvXBwzexfZj/HBeZPILglrbBjgPMoCBrpnss9oMSRk
         rChW66HbWpKrtFd7U+I0RWUwJkDR//yKIVRkN3aGuvFAIZx/rfCFT4NJoUMU/602m2WZ
         ZrKZ810J4I6V3c7k8fBvgCeH/dyGQ8CY5B9gH65Ac3wBIsza4UxMxF4ZqO+Yim5ApuXF
         uZSNIFieF4n0rcAQsyuHp4LbFp8vq1JelnN0R8UERldrWUClDKb2RZ/ylB3OhW/UpCkn
         siWxfyaVREFnztFLnE/fZvkMk0dIgJnnQvIcXUkz4GskrAgeSrVGoCNumUG6ZqCXf8ru
         dA6A==
X-Forwarded-Encrypted: i=1; AJvYcCUp4aSor8qIoLUtJZi17CecLsdhyS6jSVuoOw7b14TW9gtTPUyneJ0hIdtF/R28IdSuKdCggbwDpg==@vger.kernel.org
X-Gm-Message-State: AOJu0Yx+sbuQXo5BYsmLXU5g/26iqo/3th46Ap4sxCSSKug+Sga3w1pU
	vOKoUx/uKHvKT0wKXi5ExfGsEn9xxogcZuMOz83/wX+ldlEl3hbKrRf6rjfMjMuLOjaehOxOJoO
	b1Arsdh3mzAmldMc1Bur6zIC/bMzMPBseUGmu+5N1EiwVQ6I3OxOj/kQGs8A=
X-Google-Smtp-Source: AGHT+IEqX7iiuSPF6Cd72DBiHhq/Tvm5QWeZbVrTEiWzot7SxNPi4ykC/qCICkfzkHWJ+CPmNcBpqJkkLrZfvDCxfItPruhDhbVW
Precedence: bulk
X-Mailing-List: io-uring@vger.kernel.org
List-Id: <io-uring.vger.kernel.org>
List-Subscribe: <mailto:io-uring+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:io-uring+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-Received: by 2002:a05:6e02:156a:b0:3e5:50a5:a7ef with SMTP id
 e9e14a558f8ab-3e57e9c1042mr93799305ab.15.1755329426533; Sat, 16 Aug 2025
 00:30:26 -0700 (PDT)
Date: Sat, 16 Aug 2025 00:30:26 -0700
In-Reply-To: <b98edbb8ec4495b053dfb11cb3588f17f5253b6e.1755182071.git.asml.silence@gmail.com>
X-Google-Appengine-App-Id: s~syzkaller
X-Google-Appengine-App-Id-Alias: syzkaller
Message-ID: <68a03392.050a0220.e29e5.0041.GAE@google.com>
Subject: [syzbot ci] Re: io_uring: add request poisoning
From: syzbot ci <syzbot+ci13e386d4235544e2@syzkaller.appspotmail.com>
To: asml.silence@gmail.com, io-uring@vger.kernel.org
Cc: syzbot@lists.linux.dev, syzkaller-bugs@googlegroups.com
Content-Type: text/plain; charset="UTF-8"

syzbot ci has tested the following series

[v1] io_uring: add request poisoning
https://lore.kernel.org/all/b98edbb8ec4495b053dfb11cb3588f17f5253b6e.1755182071.git.asml.silence@gmail.com
* [PATCH 1/1] io_uring: add request poisoning

and found the following issue:
general protection fault in __io_queue_proc

Full report is available here:
https://ci.syzbot.org/series/f67750f7-0bd0-41d6-a3eb-d1b77b2c9728

***

general protection fault in __io_queue_proc

tree:      torvalds
URL:       https://kernel.googlesource.com/pub/scm/linux/kernel/git/torvalds/linux
base:      dfc0f6373094dd88e1eaf76c44f2ff01b65db851
arch:      amd64
compiler:  Debian clang version 20.1.7 (++20250616065708+6146a88f6049-1~exp1~20250616065826.132), Debian LLD 20.1.7
config:    https://ci.syzbot.org/builds/e0a322a6-324d-4dcd-a2dc-b6ec3bfb0f54/config
C repro:   https://ci.syzbot.org/findings/c93b97f2-efb3-45d6-a6ca-0afeb7311b74/c_repro
syz repro: https://ci.syzbot.org/findings/c93b97f2-efb3-45d6-a6ca-0afeb7311b74/syz_repro

Oops: general protection fault, probably for non-canonical address 0xfbd59c0000000213: 0000 [#1] SMP KASAN PTI
KASAN: maybe wild-memory-access in range [0xdead000000001098-0xdead00000000109f]
CPU: 0 UID: 0 PID: 5985 Comm: syz.0.17 Not tainted 6.17.0-rc1-syzkaller-00036-gdfc0f6373094-dirty #0 PREEMPT(full) 
Hardware name: QEMU Standard PC (Q35 + ICH9, 2009), BIOS 1.16.2-debian-1.16.2-1 04/01/2014
RIP: 0010:__io_queue_proc+0x1b8/0x4d0 io_uring/poll.c:475
Code: c1 e8 03 48 89 44 24 20 80 3c 18 00 74 08 4c 89 ef e8 8c 27 63 fd 4d 8b 6d 00 4d 85 ed 74 5a 49 83 c5 08 4c 89 e8 48 c1 e8 03 <80> 3c 18 00 74 08 4c 89 ef e8 6a 27 63 fd 48 8b 44 24 18 49 39 45
RSP: 0018:ffffc9000295f760 EFLAGS: 00010a02
RAX: 1bd5a00000000213 RBX: dffffc0000000000 RCX: 0000000000000000
RDX: ffff888020cd9cc0 RSI: 0000000000000001 RDI: 0000000000000000
RBP: ffffc9000295f900 R08: ffffffff8fa37e37 R09: 1ffffffff1f46fc6
R10: dffffc0000000000 R11: ffffffff84bfdf40 R12: ffff888028da6000
R13: dead000000001099 R14: ffffc9000295f918 R15: 1ffff9200052bf23
FS:  000055558fd42500(0000) GS:ffff8880b861c000(0000) knlGS:0000000000000000
CS:  0010 DS: 0000 ES: 0000 CR0: 0000000080050033
CR2: 0000001b30d63fff CR3: 000000010e6dc000 CR4: 00000000000006f0
Call Trace:
 <TASK>
 poll_wait include/linux/poll.h:45 [inline]
 n_tty_poll+0x9d/0x740 drivers/tty/n_tty.c:2451
 tty_poll+0xbe/0x160 drivers/tty/tty_io.c:2199
 vfs_poll include/linux/poll.h:82 [inline]
 __io_arm_poll_handler+0x372/0xbb0 io_uring/poll.c:581
 io_poll_add+0xcd/0x1f0 io_uring/poll.c:901
 __io_issue_sqe+0x181/0x4b0 io_uring/io_uring.c:1795
 io_issue_sqe+0x165/0xfd0 io_uring/io_uring.c:1818
 io_queue_sqe io_uring/io_uring.c:2047 [inline]
 io_submit_sqe io_uring/io_uring.c:2306 [inline]
 io_submit_sqes+0xa32/0x1e60 io_uring/io_uring.c:2419
 __do_sys_io_uring_enter io_uring/io_uring.c:3487 [inline]
 __se_sys_io_uring_enter+0x2df/0x2b20 io_uring/io_uring.c:3421
 do_syscall_x64 arch/x86/entry/syscall_64.c:63 [inline]
 do_syscall_64+0xfa/0x3b0 arch/x86/entry/syscall_64.c:94
 entry_SYSCALL_64_after_hwframe+0x77/0x7f
RIP: 0033:0x7f750a18ebe9
Code: ff ff c3 66 2e 0f 1f 84 00 00 00 00 00 0f 1f 40 00 48 89 f8 48 89 f7 48 89 d6 48 89 ca 4d 89 c2 4d 89 c8 4c 8b 4c 24 08 0f 05 <48> 3d 01 f0 ff ff 73 01 c3 48 c7 c1 a8 ff ff ff f7 d8 64 89 01 48
RSP: 002b:00007ffc8b53b938 EFLAGS: 00000246 ORIG_RAX: 00000000000001aa
RAX: ffffffffffffffda RBX: 00007f750a3b5fa0 RCX: 00007f750a18ebe9
RDX: 0000000000000000 RSI: 0000000000000a3d RDI: 0000000000000004
RBP: 00007f750a211e19 R08: 0000000000000000 R09: 000000000000ff39
R10: 0000000000000000 R11: 0000000000000246 R12: 0000000000000000
R13: 00007f750a3b5fa0 R14: 00007f750a3b5fa0 R15: 0000000000000006
 </TASK>
Modules linked in:
---[ end trace 0000000000000000 ]---
RIP: 0010:__io_queue_proc+0x1b8/0x4d0 io_uring/poll.c:475
Code: c1 e8 03 48 89 44 24 20 80 3c 18 00 74 08 4c 89 ef e8 8c 27 63 fd 4d 8b 6d 00 4d 85 ed 74 5a 49 83 c5 08 4c 89 e8 48 c1 e8 03 <80> 3c 18 00 74 08 4c 89 ef e8 6a 27 63 fd 48 8b 44 24 18 49 39 45
RSP: 0018:ffffc9000295f760 EFLAGS: 00010a02
RAX: 1bd5a00000000213 RBX: dffffc0000000000 RCX: 0000000000000000
RDX: ffff888020cd9cc0 RSI: 0000000000000001 RDI: 0000000000000000
RBP: ffffc9000295f900 R08: ffffffff8fa37e37 R09: 1ffffffff1f46fc6
R10: dffffc0000000000 R11: ffffffff84bfdf40 R12: ffff888028da6000
R13: dead000000001099 R14: ffffc9000295f918 R15: 1ffff9200052bf23
FS:  000055558fd42500(0000) GS:ffff8880b861c000(0000) knlGS:0000000000000000
CS:  0010 DS: 0000 ES: 0000 CR0: 0000000080050033
CR2: 0000001b30d63fff CR3: 000000010e6dc000 CR4: 00000000000006f0
----------------
Code disassembly (best guess):
   0:	c1 e8 03             	shr    $0x3,%eax
   3:	48 89 44 24 20       	mov    %rax,0x20(%rsp)
   8:	80 3c 18 00          	cmpb   $0x0,(%rax,%rbx,1)
   c:	74 08                	je     0x16
   e:	4c 89 ef             	mov    %r13,%rdi
  11:	e8 8c 27 63 fd       	call   0xfd6327a2
  16:	4d 8b 6d 00          	mov    0x0(%r13),%r13
  1a:	4d 85 ed             	test   %r13,%r13
  1d:	74 5a                	je     0x79
  1f:	49 83 c5 08          	add    $0x8,%r13
  23:	4c 89 e8             	mov    %r13,%rax
  26:	48 c1 e8 03          	shr    $0x3,%rax
* 2a:	80 3c 18 00          	cmpb   $0x0,(%rax,%rbx,1) <-- trapping instruction
  2e:	74 08                	je     0x38
  30:	4c 89 ef             	mov    %r13,%rdi
  33:	e8 6a 27 63 fd       	call   0xfd6327a2
  38:	48 8b 44 24 18       	mov    0x18(%rsp),%rax
  3d:	49                   	rex.WB
  3e:	39                   	.byte 0x39
  3f:	45                   	rex.RB


***

If these findings have caused you to resend the series or submit a
separate fix, please add the following tag to your commit message:
Tested-by: syzbot@syzkaller.appspotmail.com

---
This report is generated by a bot. It may contain errors.
syzbot ci engineers can be reached at syzkaller@googlegroups.com.

