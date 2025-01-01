Return-Path: <io-uring+bounces-5646-lists+io-uring=lfdr.de@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [139.178.88.99])
	by mail.lfdr.de (Postfix) with ESMTPS id D20F59FF4EA
	for <lists+io-uring@lfdr.de>; Wed,  1 Jan 2025 21:58:32 +0100 (CET)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id D780F3A2838
	for <lists+io-uring@lfdr.de>; Wed,  1 Jan 2025 20:58:27 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 76F831E2848;
	Wed,  1 Jan 2025 20:58:24 +0000 (UTC)
X-Original-To: io-uring@vger.kernel.org
Received: from mail-io1-f77.google.com (mail-io1-f77.google.com [209.85.166.77])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B416A2110E
	for <io-uring@vger.kernel.org>; Wed,  1 Jan 2025 20:58:22 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.166.77
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1735765104; cv=none; b=lfGmoty4ONav4j9JUvgOWIejwQ3aCpxpEWy5vkqecrNtscq1eXemfR3JBIufbHylrbexvlMS1WZ8q3rMHfq6nvIOmUICAh5KpFNr+04F9f0umH83EffOD2icgDaSiGePjScc6G3Otdg+/tPJs3QYPPfyKybDE34BU+ft/ZlPucY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1735765104; c=relaxed/simple;
	bh=RJvmvSx5bPgBT7GwVcKRnCUfUHVAU7jD+rDAotplmP8=;
	h=MIME-Version:Date:In-Reply-To:Message-ID:Subject:From:To:
	 Content-Type; b=hb9oNFepYE1IqdM0yZWYj/QdcsF8oMY2hf2BkyA+DLcdl9xMSKk2wFagzM1CzVvL//Ek/rHSyaW7cuyeSbfb92QrhW2USsIS0EDMjDuz5iCI3eW2kccE3AkVRB6KjCYnjBSgOt+QHoqLjEwo8U8K3MHjZpdrKsf8XLVXql1fuLU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=fail (p=none dis=none) header.from=syzkaller.appspotmail.com; spf=pass smtp.mailfrom=M3KW2WVRGUFZ5GODRSRYTGD7.apphosting.bounces.google.com; arc=none smtp.client-ip=209.85.166.77
Authentication-Results: smtp.subspace.kernel.org; dmarc=fail (p=none dis=none) header.from=syzkaller.appspotmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=M3KW2WVRGUFZ5GODRSRYTGD7.apphosting.bounces.google.com
Received: by mail-io1-f77.google.com with SMTP id ca18e2360f4ac-844d2a7ef6dso1833169239f.0
        for <io-uring@vger.kernel.org>; Wed, 01 Jan 2025 12:58:22 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1735765102; x=1736369902;
        h=to:from:subject:message-id:in-reply-to:date:mime-version
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=H3a9WShjNi2wa5yQd5lHx5dga/c6weFZ2yFrBWIpLFY=;
        b=kQrGg1/qYv+pX8yZstx1uybx61bupMkrgKRp0Wz24mP0p9EwX/IfKSXWxMYgRcVWU2
         Gx8Fwt847MrCPVfYLDqFykxDxe5LQMciYljAAlISxfLXn4pLKQ4whnbGvUNUigeqSuPR
         I7SHpF5W/iHmV/bAonxHrQo351lL9P3554JYmYKGVsHNIr+FiK97DaRicfJXycbz93IY
         mg30HL9DpnCiS2AZfUWGQlopEEXrXw12h7Sfm+4P58PJjPUoBqaRMDQYo5XmTz4yWmbI
         EPI63848Z1/hffvIyjcQFXm8oOHXj6bkypM0rWm+Lqi+F7FgvIlQe5jkMHPHPBZeSWsl
         IqbQ==
X-Forwarded-Encrypted: i=1; AJvYcCVVh7cg2lDDFD894Nk1nOSCl6irKcRVFrCnwVRbs1YsXOpG//V3EiFJIRRnySzyjwC8qxRRPmwacA==@vger.kernel.org
X-Gm-Message-State: AOJu0YwLjzU2A0cPflJgOmAVm2VVXyFzM8Aktz+ToJwmhHbVXb7DYHaw
	g2O4jGJfvKlIF0/LxwviBGpSSiFkei0v6Kt6JtAWkvwlmKYrSWFLYEpMNXgkxsdpxQWIXP+lU4M
	0w2r10NpXTf7ipZ3ji6FpeslwdVeaMmI2lZbi1dMcoU4NKfIlzCC7xrI=
X-Google-Smtp-Source: AGHT+IH/9K+r0rruKd2C4CTlfxMTkOVPkgxXL1atZtSK7DmhOS+/V5o7WQ2j9z8o0OguIQ08ntefwWqvRfdMi8yggFY3hQvnhqfV
Precedence: bulk
X-Mailing-List: io-uring@vger.kernel.org
List-Id: <io-uring.vger.kernel.org>
List-Subscribe: <mailto:io-uring+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:io-uring+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-Received: by 2002:a05:6e02:3497:b0:3a7:e528:6f1e with SMTP id
 e9e14a558f8ab-3c2d278364bmr348230185ab.11.1735765101979; Wed, 01 Jan 2025
 12:58:21 -0800 (PST)
Date: Wed, 01 Jan 2025 12:58:21 -0800
In-Reply-To: <0000000000006d4e02061b6cbf22@google.com>
X-Google-Appengine-App-Id: s~syzkaller
X-Google-Appengine-App-Id-Alias: syzkaller
Message-ID: <6775ac6d.050a0220.3a8527.002d.GAE@google.com>
Subject: Re: [syzbot] [kernel] WARNING: locking bug in sched_core_balance
From: syzbot <syzbot+14641d8d78cc029add8a@syzkaller.appspotmail.com>
To: asml.silence@gmail.com, axboe@kernel.dk, bp@alien8.de, 
	dave.hansen@linux.intel.com, hpa@zytor.com, io-uring@vger.kernel.org, 
	linux-kernel@vger.kernel.org, mingo@redhat.com, 
	syzkaller-bugs@googlegroups.com, tglx@linutronix.de, x86@kernel.org
Content-Type: text/plain; charset="UTF-8"

syzbot has found a reproducer for the following issue on:

HEAD commit:    ccb98ccef0e5 Merge tag 'platform-drivers-x86-v6.13-4' of g..
git tree:       upstream
console output: https://syzkaller.appspot.com/x/log.txt?x=13c3d6df980000
kernel config:  https://syzkaller.appspot.com/x/.config?x=1c541fa8af5c9cc7
dashboard link: https://syzkaller.appspot.com/bug?extid=14641d8d78cc029add8a
compiler:       Debian clang version 15.0.6, GNU ld (GNU Binutils for Debian) 2.40
syz repro:      https://syzkaller.appspot.com/x/repro.syz?x=127f3818580000
C reproducer:   https://syzkaller.appspot.com/x/repro.c?x=172306c4580000

Downloadable assets:
disk image: https://storage.googleapis.com/syzbot-assets/0ebebb2cf79b/disk-ccb98cce.raw.xz
vmlinux: https://storage.googleapis.com/syzbot-assets/8da8041cbc40/vmlinux-ccb98cce.xz
kernel image: https://storage.googleapis.com/syzbot-assets/8de730af73c0/bzImage-ccb98cce.xz

IMPORTANT: if you fix the issue, please add the following tag to the commit:
Reported-by: syzbot+14641d8d78cc029add8a@syzkaller.appspotmail.com

BUG: unable to handle page fault for address: fffffbfff3f8171b
#PF: supervisor read access in kernel mode
#PF: error_code(0x0000) - not-present page
PGD 23ffe4067 P4D 23ffe4067 PUD 23ffe3067 PMD 0 
Oops: Oops: 0000 [#1] PREEMPT SMP KASAN NOPTI
CPU: 0 UID: 0 PID: 0 Comm: swapper/0 Not tainted 6.13.0-rc5-syzkaller-00004-gccb98ccef0e5 #0
Hardware name: Google Google Compute Engine/Google Compute Engine, BIOS Google 09/13/2024
RIP: 0010:bytes_is_nonzero mm/kasan/generic.c:87 [inline]
RIP: 0010:memory_is_nonzero mm/kasan/generic.c:104 [inline]
RIP: 0010:memory_is_poisoned_n mm/kasan/generic.c:129 [inline]
RIP: 0010:memory_is_poisoned mm/kasan/generic.c:161 [inline]
RIP: 0010:check_region_inline mm/kasan/generic.c:180 [inline]
RIP: 0010:kasan_check_range+0x82/0x290 mm/kasan/generic.c:189
Code: 01 00 00 00 00 fc ff df 4f 8d 3c 31 4c 89 fd 4c 29 dd 48 83 fd 10 7f 29 48 85 ed 0f 84 3e 01 00 00 4c 89 cd 48 f7 d5 48 01 dd <41> 80 3b 00 0f 85 c9 01 00 00 49 ff c3 48 ff c5 75 ee e9 1e 01 00
RSP: 0018:ffffffff8e607640 EFLAGS: 00010086
RAX: 000000000172ce01 RBX: 1ffffffff3f8171b RCX: ffffffff817ac174
RDX: 0000000000000000 RSI: 0000000000000008 RDI: ffffffff9fc0b8d8
RBP: ffffffffffffffff R08: ffffffff9fc0b8df R09: 1ffffffff3f8171b
R10: dffffc0000000000 R11: fffffbfff3f8171b R12: ffffffff8e697084
R13: ffffffff8e6965c0 R14: dffffc0000000001 R15: fffffbfff3f8171c
FS:  0000000000000000(0000) GS:ffff8880b8600000(0000) knlGS:0000000000000000
CS:  0010 DS: 0000 ES: 0000 CR0: 0000000080050033
CR2: fffffbfff3f8171b CR3: 0000000077460000 CR4: 0000000000350ef0
Call Trace:
 <TASK>
 instrument_atomic_read include/linux/instrumented.h:68 [inline]
 _test_bit include/asm-generic/bitops/instrumented-non-atomic.h:141 [inline]
 __lock_acquire+0xc94/0x2100 kernel/locking/lockdep.c:5196
 lock_acquire+0x1ed/0x550 kernel/locking/lockdep.c:5849
 _raw_spin_lock_nested+0x31/0x40 kernel/locking/spinlock.c:378
 raw_spin_rq_lock_nested+0xb0/0x140 kernel/sched/core.c:606
 raw_spin_rq_lock kernel/sched/sched.h:1523 [inline]
 raw_spin_rq_lock_irq kernel/sched/sched.h:1529 [inline]
 sched_core_balance+0xd87/0xf50 kernel/sched/core.c:6411
 do_balance_callbacks kernel/sched/core.c:5021 [inline]
 __balance_callbacks+0x18a/0x280 kernel/sched/core.c:5075
 finish_lock_switch kernel/sched/core.c:5122 [inline]
 finish_task_switch+0x1d3/0x870 kernel/sched/core.c:5241
 context_switch kernel/sched/core.c:5372 [inline]
 __schedule+0x1858/0x4c30 kernel/sched/core.c:6756
 schedule_idle+0x56/0x90 kernel/sched/core.c:6874
 do_idle+0x567/0x5c0 kernel/sched/idle.c:353
 cpu_startup_entry+0x42/0x60 kernel/sched/idle.c:423
 rest_init+0x2dc/0x300 init/main.c:747
 start_kernel+0x47f/0x500 init/main.c:1102
 x86_64_start_reservations+0x2a/0x30 arch/x86/kernel/head64.c:507
 x86_64_start_kernel+0x9f/0xa0 arch/x86/kernel/head64.c:488
 common_startup_64+0x13e/0x147
 </TASK>
Modules linked in:
CR2: fffffbfff3f8171b
---[ end trace 0000000000000000 ]---
RIP: 0010:bytes_is_nonzero mm/kasan/generic.c:87 [inline]
RIP: 0010:memory_is_nonzero mm/kasan/generic.c:104 [inline]
RIP: 0010:memory_is_poisoned_n mm/kasan/generic.c:129 [inline]
RIP: 0010:memory_is_poisoned mm/kasan/generic.c:161 [inline]
RIP: 0010:check_region_inline mm/kasan/generic.c:180 [inline]
RIP: 0010:kasan_check_range+0x82/0x290 mm/kasan/generic.c:189
Code: 01 00 00 00 00 fc ff df 4f 8d 3c 31 4c 89 fd 4c 29 dd 48 83 fd 10 7f 29 48 85 ed 0f 84 3e 01 00 00 4c 89 cd 48 f7 d5 48 01 dd <41> 80 3b 00 0f 85 c9 01 00 00 49 ff c3 48 ff c5 75 ee e9 1e 01 00
RSP: 0018:ffffffff8e607640 EFLAGS: 00010086
RAX: 000000000172ce01 RBX: 1ffffffff3f8171b RCX: ffffffff817ac174
RDX: 0000000000000000 RSI: 0000000000000008 RDI: ffffffff9fc0b8d8
RBP: ffffffffffffffff R08: ffffffff9fc0b8df R09: 1ffffffff3f8171b
R10: dffffc0000000000 R11: fffffbfff3f8171b R12: ffffffff8e697084
R13: ffffffff8e6965c0 R14: dffffc0000000001 R15: fffffbfff3f8171c
FS:  0000000000000000(0000) GS:ffff8880b8600000(0000) knlGS:0000000000000000
CS:  0010 DS: 0000 ES: 0000 CR0: 0000000080050033
CR2: fffffbfff3f8171b CR3: 0000000077460000 CR4: 0000000000350ef0
----------------
Code disassembly (best guess), 7 bytes skipped:
   0:	df 4f 8d             	fisttps -0x73(%rdi)
   3:	3c 31                	cmp    $0x31,%al
   5:	4c 89 fd             	mov    %r15,%rbp
   8:	4c 29 dd             	sub    %r11,%rbp
   b:	48 83 fd 10          	cmp    $0x10,%rbp
   f:	7f 29                	jg     0x3a
  11:	48 85 ed             	test   %rbp,%rbp
  14:	0f 84 3e 01 00 00    	je     0x158
  1a:	4c 89 cd             	mov    %r9,%rbp
  1d:	48 f7 d5             	not    %rbp
  20:	48 01 dd             	add    %rbx,%rbp
* 23:	41 80 3b 00          	cmpb   $0x0,(%r11) <-- trapping instruction
  27:	0f 85 c9 01 00 00    	jne    0x1f6
  2d:	49 ff c3             	inc    %r11
  30:	48 ff c5             	inc    %rbp
  33:	75 ee                	jne    0x23
  35:	e9                   	.byte 0xe9
  36:	1e                   	(bad)
  37:	01 00                	add    %eax,(%rax)


---
If you want syzbot to run the reproducer, reply with:
#syz test: git://repo/address.git branch-or-commit-hash
If you attach or paste a git patch, syzbot will apply it before testing.

