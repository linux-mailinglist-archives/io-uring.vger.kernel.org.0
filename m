Return-Path: <io-uring+bounces-9955-lists+io-uring=lfdr.de@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [139.178.88.99])
	by mail.lfdr.de (Postfix) with ESMTPS id EA829BCA56E
	for <lists+io-uring@lfdr.de>; Thu, 09 Oct 2025 19:11:08 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 60D433B345A
	for <lists+io-uring@lfdr.de>; Thu,  9 Oct 2025 17:11:07 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 2D2F223A9AC;
	Thu,  9 Oct 2025 17:11:05 +0000 (UTC)
X-Original-To: io-uring@vger.kernel.org
Received: from mail-io1-f70.google.com (mail-io1-f70.google.com [209.85.166.70])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6BEA6235044
	for <io-uring@vger.kernel.org>; Thu,  9 Oct 2025 17:11:03 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.166.70
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1760029865; cv=none; b=G2+8+757PJpYfCp8gTyU+NLL/tjLCIL1hq8ckgk52DhCCpDRgXY9KkSSlWTXv7Mkji8w5L2VgbEb2PONgLGm9+FJ8hZLfG3vP3xEZW2oV0yBvNVFrIssTp+w4vBAGdYHYbDW2MIWOGbNUVPiVZe1ZG8w89tUdtvbcTkuk6pXSV8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1760029865; c=relaxed/simple;
	bh=ph62z0hz9curX8oOh8fwnrkuk8Tb40qULke+shiey78=;
	h=MIME-Version:Date:In-Reply-To:Message-ID:Subject:From:To:
	 Content-Type; b=jPYi6YcndbqTtc4o8/RuaKAXklsKCj3VjtssnfTtfIOxmKht2BjUQL/4v0i3uKf37ukcu+VtyYNm2sl6nVvMmfplT+pDn23qEyDn4ZsNEN7BdIUeDg/y+NN2/MC1VrsjzEitqnQaU/XIQkSGbySW9UHeyFksPPpK65i1K+zHjSE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=fail (p=none dis=none) header.from=syzkaller.appspotmail.com; spf=pass smtp.mailfrom=M3KW2WVRGUFZ5GODRSRYTGD7.apphosting.bounces.google.com; arc=none smtp.client-ip=209.85.166.70
Authentication-Results: smtp.subspace.kernel.org; dmarc=fail (p=none dis=none) header.from=syzkaller.appspotmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=M3KW2WVRGUFZ5GODRSRYTGD7.apphosting.bounces.google.com
Received: by mail-io1-f70.google.com with SMTP id ca18e2360f4ac-930db3a16c1so451844139f.1
        for <io-uring@vger.kernel.org>; Thu, 09 Oct 2025 10:11:03 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1760029862; x=1760634662;
        h=to:from:subject:message-id:in-reply-to:date:mime-version
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=eP1y14kl8cbBSAbGEotk410AY/qxRYO5ANt1wxuB5dE=;
        b=s/wFoTf0aDHS+imGt30HkpKQvPn9BDnn7jvUPiaGNZkpph5HLb687mw0spSnA1n6V6
         G2vexF4igYaetgN4abTaezCE2dMVOEYpw3Vqz5FBAY4NyiFYBIPaDaHdon+7OF2ct15V
         4HurWUUAln3NWJGhH2rCb2Wzwmu6+d4Ojxm0INOKjIn0c4/7gQw2gvga6y4XMCO2lmhu
         lkkfMMuh0ZstyVQhDk+EkRbjfsxnv+VXARWJBkRcl/QS656AR9U9SlabAGtu7StJ9qVR
         nDwBslHEnlqfVY4Uddj1Xk2W1+aHLYayLKkE/gU19g5XdE2xu5EGrrZ4Xo1tvrLuknoh
         UJ4w==
X-Forwarded-Encrypted: i=1; AJvYcCWGF6Y15SJ/Onyddh6uSsnhRP2PrR4Q4UEEhjVNWT16h802Hx8M/xoGBIJXk76ysdE/JnAAhI79GA==@vger.kernel.org
X-Gm-Message-State: AOJu0YxsXXB0jjTkdnViQURKoitzalNHKQjeT1bysDFozE+vfIByhZAh
	JBpbz9DUQTCqhrvl+8QPaIoOu59i4cophAGNE00rH2gY65Eh2pHHzw55enj4ILVDHNT6Ly409gH
	yBNdzEanRdhfZgraHeVZu/yQErstlHaFvnhsWEdRoOuBBzsnXkeaPt0QkeKo=
X-Google-Smtp-Source: AGHT+IHvVeTPWkN2Au1GSzRvcFsxvXkXMYNvAnCxkt6Y/4VdZ84lSnLEFBhcSVGQpM4Qcj0xujlS/YDd/B3lSENGKDM1krc1UjN5
Precedence: bulk
X-Mailing-List: io-uring@vger.kernel.org
List-Id: <io-uring.vger.kernel.org>
List-Subscribe: <mailto:io-uring+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:io-uring+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-Received: by 2002:a05:6602:6015:b0:924:2696:a53 with SMTP id
 ca18e2360f4ac-93bd1830713mr983194939f.3.1760029862564; Thu, 09 Oct 2025
 10:11:02 -0700 (PDT)
Date: Thu, 09 Oct 2025 10:11:02 -0700
In-Reply-To: <b64194fe-59c3-4d61-bbf8-1f9494b91dbf@kernel.dk>
X-Google-Appengine-App-Id: s~syzkaller
X-Google-Appengine-App-Id-Alias: syzkaller
Message-ID: <68e7eca6.050a0220.1186a4.0002.GAE@google.com>
Subject: Re: [syzbot] [io-uring?] KASAN: slab-use-after-free Read in io_waitid_wait
From: syzbot <syzbot+b9e83021d9c642a33d8c@syzkaller.appspotmail.com>
To: axboe@kernel.dk, io-uring@vger.kernel.org, linux-kernel@vger.kernel.org, 
	syzkaller-bugs@googlegroups.com
Content-Type: text/plain; charset="UTF-8"

Hello,

syzbot has tested the proposed patch but the reproducer is still triggering an issue:
general protection fault in add_wait_queue

Oops: general protection fault, probably for non-canonical address 0xdffffc0000000003: 0000 [#1] SMP KASAN NOPTI
KASAN: null-ptr-deref in range [0x0000000000000018-0x000000000000001f]
CPU: 3 UID: 0 PID: 6397 Comm: syz.0.17 Not tainted syzkaller #0 PREEMPT(full) 
Hardware name: QEMU Standard PC (Q35 + ICH9, 2009), BIOS 1.16.3-debian-1.16.3-2~bpo12+1 04/01/2014
RIP: 0010:kasan_byte_accessible+0x15/0x30 mm/kasan/generic.c:210
Code: 00 00 0f 1f 00 90 90 90 90 90 90 90 90 90 90 90 90 90 90 90 90 66 0f 1f 00 48 b8 00 00 00 00 00 fc ff df 48 c1 ef 03 48 01 c7 <0f> b6 07 3c 07 0f 96 c0 c3 cc cc cc cc 66 66 2e 0f 1f 84 00 00 00
RSP: 0018:ffffc900027579b0 EFLAGS: 00010086
RAX: dffffc0000000000 RBX: 0000000000000018 RCX: 0000000000000000
RDX: 0000000000000000 RSI: ffffffff8b54cf9a RDI: dffffc0000000003
RBP: 0000000000000018 R08: 0000000000000001 R09: 0000000000000000
R10: ffffffff905ff0d7 R11: 0000000000000000 R12: ffffffff8b54cf9a
R13: 0000000000000000 R14: 0000000000000000 R15: 0000000000000000
FS:  00007fe7bc5c86c0(0000) GS:ffff8880d7161000(0000) knlGS:0000000000000000
CS:  0010 DS: 0000 ES: 0000 CR0: 0000000080050033
CR2: 00007fe7bb9e5fac CR3: 00000000504de000 CR4: 0000000000352ef0
Call Trace:
 <TASK>
 __kasan_check_byte+0x13/0x50 mm/kasan/common.c:579
 kasan_check_byte include/linux/kasan.h:401 [inline]
 lock_acquire kernel/locking/lockdep.c:5842 [inline]
 lock_acquire+0xfc/0x350 kernel/locking/lockdep.c:5825
 __raw_spin_lock_irqsave include/linux/spinlock_api_smp.h:110 [inline]
 _raw_spin_lock_irqsave+0x3a/0x60 kernel/locking/spinlock.c:162
 add_wait_queue+0x45/0x230 kernel/sched/wait.c:23
 io_waitid_cb+0x1c3/0x2b0 io_uring/waitid.c:219
 io_handle_tw_list+0x486/0x500 io_uring/io_uring.c:1151
 tctx_task_work_run+0xac/0x380 io_uring/io_uring.c:1216
 tctx_task_work+0x7a/0xd0 io_uring/io_uring.c:1234
 task_work_run+0x150/0x240 kernel/task_work.c:227
 get_signal+0x1d0/0x26d0 kernel/signal.c:2807
 arch_do_signal_or_restart+0x8f/0x7c0 arch/x86/kernel/signal.c:337
 exit_to_user_mode_loop+0x85/0x130 kernel/entry/common.c:40
 exit_to_user_mode_prepare include/linux/irq-entry-common.h:225 [inline]
 syscall_exit_to_user_mode_work include/linux/entry-common.h:175 [inline]
 syscall_exit_to_user_mode include/linux/entry-common.h:210 [inline]
 do_syscall_64+0x419/0x4e0 arch/x86/entry/syscall_64.c:100
 entry_SYSCALL_64_after_hwframe+0x77/0x7f
RIP: 0033:0x7fe7bb78eec9
Code: ff ff c3 66 2e 0f 1f 84 00 00 00 00 00 0f 1f 40 00 48 89 f8 48 89 f7 48 89 d6 48 89 ca 4d 89 c2 4d 89 c8 4c 8b 4c 24 08 0f 05 <48> 3d 01 f0 ff ff 73 01 c3 48 c7 c1 a8 ff ff ff f7 d8 64 89 01 48
RSP: 002b:00007fe7bc5c80e8 EFLAGS: 00000246 ORIG_RAX: 00000000000000ca
RAX: 0000000000000000 RBX: 00007fe7bb9e5fa8 RCX: 00007fe7bb78eec9
RDX: 0000000000000000 RSI: 0000000000000080 RDI: 00007fe7bb9e5fa8
RBP: 00007fe7bb9e5fa0 R08: 0000000000000000 R09: 0000000000000000
R10: 0000000000000000 R11: 0000000000000246 R12: 0000000000000000
R13: 00007fe7bb9e6038 R14: 00007ffcd14563d0 R15: 00007ffcd14564b8
 </TASK>
Modules linked in:
---[ end trace 0000000000000000 ]---
RIP: 0010:kasan_byte_accessible+0x15/0x30 mm/kasan/generic.c:210
Code: 00 00 0f 1f 00 90 90 90 90 90 90 90 90 90 90 90 90 90 90 90 90 66 0f 1f 00 48 b8 00 00 00 00 00 fc ff df 48 c1 ef 03 48 01 c7 <0f> b6 07 3c 07 0f 96 c0 c3 cc cc cc cc 66 66 2e 0f 1f 84 00 00 00
RSP: 0018:ffffc900027579b0 EFLAGS: 00010086
RAX: dffffc0000000000 RBX: 0000000000000018 RCX: 0000000000000000
RDX: 0000000000000000 RSI: ffffffff8b54cf9a RDI: dffffc0000000003
RBP: 0000000000000018 R08: 0000000000000001 R09: 0000000000000000
R10: ffffffff905ff0d7 R11: 0000000000000000 R12: ffffffff8b54cf9a
R13: 0000000000000000 R14: 0000000000000000 R15: 0000000000000000
FS:  00007fe7bc5c86c0(0000) GS:ffff8880d7161000(0000) knlGS:0000000000000000
CS:  0010 DS: 0000 ES: 0000 CR0: 0000000080050033
CR2: 00007fe7bb9e5fac CR3: 00000000504de000 CR4: 0000000000352ef0
----------------
Code disassembly (best guess):
   0:	00 00                	add    %al,(%rax)
   2:	0f 1f 00             	nopl   (%rax)
   5:	90                   	nop
   6:	90                   	nop
   7:	90                   	nop
   8:	90                   	nop
   9:	90                   	nop
   a:	90                   	nop
   b:	90                   	nop
   c:	90                   	nop
   d:	90                   	nop
   e:	90                   	nop
   f:	90                   	nop
  10:	90                   	nop
  11:	90                   	nop
  12:	90                   	nop
  13:	90                   	nop
  14:	90                   	nop
  15:	66 0f 1f 00          	nopw   (%rax)
  19:	48 b8 00 00 00 00 00 	movabs $0xdffffc0000000000,%rax
  20:	fc ff df
  23:	48 c1 ef 03          	shr    $0x3,%rdi
  27:	48 01 c7             	add    %rax,%rdi
* 2a:	0f b6 07             	movzbl (%rdi),%eax <-- trapping instruction
  2d:	3c 07                	cmp    $0x7,%al
  2f:	0f 96 c0             	setbe  %al
  32:	c3                   	ret
  33:	cc                   	int3
  34:	cc                   	int3
  35:	cc                   	int3
  36:	cc                   	int3
  37:	66                   	data16
  38:	66                   	data16
  39:	2e                   	cs
  3a:	0f                   	.byte 0xf
  3b:	1f                   	(bad)
  3c:	84 00                	test   %al,(%rax)


Tested on:

commit:         299d12f3 io_uring/waitid: use io_waitid_remove_wq() co..
git tree:       git://git.kernel.org/pub/scm/linux/kernel/git/axboe/linux.git syztest
console output: https://syzkaller.appspot.com/x/log.txt?x=12de0dcd980000
kernel config:  https://syzkaller.appspot.com/x/.config?x=6da9233e22696ba7
dashboard link: https://syzkaller.appspot.com/bug?extid=b9e83021d9c642a33d8c
compiler:       gcc (Debian 12.2.0-14+deb12u1) 12.2.0, GNU ld (GNU Binutils for Debian) 2.40

Note: no patches were applied.

