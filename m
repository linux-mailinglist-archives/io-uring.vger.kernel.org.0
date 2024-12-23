Return-Path: <io-uring+bounces-5595-lists+io-uring=lfdr.de@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [IPv6:2604:1380:4601:e00::3])
	by mail.lfdr.de (Postfix) with ESMTPS id 85F5D9FB4CE
	for <lists+io-uring@lfdr.de>; Mon, 23 Dec 2024 20:52:49 +0100 (CET)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id 8B0741884092
	for <lists+io-uring@lfdr.de>; Mon, 23 Dec 2024 19:52:50 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 57EA61C5F3F;
	Mon, 23 Dec 2024 19:52:30 +0000 (UTC)
X-Original-To: io-uring@vger.kernel.org
Received: from mail-il1-f208.google.com (mail-il1-f208.google.com [209.85.166.208])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9C42B1C68B6
	for <io-uring@vger.kernel.org>; Mon, 23 Dec 2024 19:52:28 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.166.208
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1734983550; cv=none; b=JZA2Byn3EmLJ7vu9bM+QQp5dS8zuB89QfJhiuZVpk6TVWTX64vNEZixdebE7e90fQT+LMmCinQQjbSCYrPcnDFXNn+mvSiBv62+qsLD7areEAWUv9uNzFIRU/2q5Wxp0EHuZJ/+iXQshEVa6+RUytWdVKSCCqFAQj1rMPYzZtO4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1734983550; c=relaxed/simple;
	bh=6nBYjXrsKjtfSx4EDakUW/OmDlZQod1yBQm5/K0l/e8=;
	h=MIME-Version:Date:Message-ID:Subject:From:To:Content-Type; b=aoYmh5vbWUM4RbjQZnFhlBMRmAV4AetGM35XkIzNAiNFdz0nrV6N/z5sjcwAHSTj9tZDfMlpF/86J1A9arvt8/OiDJ+bhoKKepdllUU+S1d5M18IU01ZSmYHv6WHEn6wIoYX4gMQfKlZX40AmLLegRLV7bMIk/ha5CPwRmHM8IM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=fail (p=none dis=none) header.from=syzkaller.appspotmail.com; spf=pass smtp.mailfrom=M3KW2WVRGUFZ5GODRSRYTGD7.apphosting.bounces.google.com; arc=none smtp.client-ip=209.85.166.208
Authentication-Results: smtp.subspace.kernel.org; dmarc=fail (p=none dis=none) header.from=syzkaller.appspotmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=M3KW2WVRGUFZ5GODRSRYTGD7.apphosting.bounces.google.com
Received: by mail-il1-f208.google.com with SMTP id e9e14a558f8ab-3a814406be9so84594635ab.1
        for <io-uring@vger.kernel.org>; Mon, 23 Dec 2024 11:52:28 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1734983547; x=1735588347;
        h=to:from:subject:message-id:date:mime-version:x-gm-message-state
         :from:to:cc:subject:date:message-id:reply-to;
        bh=kEqN/OXKaJA6mOJ0z8plrkyAV3GROr5fUVt8KVklN9A=;
        b=gQYGnVkA6czvpopDyop4Pysc0Vrcb2SzoRSgnjD3MDMBmO7CiMviUaNdoL1OsppjK1
         m4Hv7WLvNHd5k+ZlFJnLR8cf8OicTWv/s/mJdyQFOaoZkt6LwwNAvHwiX1wkSOGCbRBH
         ClbQ1j2Lmjlb/kwQvvKx0wyGUSx0IP5N9smkIFnxxENyhaOi/0vubAec/s2Tx1cXGqNK
         lfkusVhYJJcZpWw3xVG7Ka5DpFnw9b6uDmv0nW+koklroF0rMDQhi3NbKw56AuzyYiWy
         jJLBNthOjOiYlEi6X1dMFkxJY7eNr2zZyUGb/MA1VCvTjAhuW3sp2zKwLCG7hk1zsIoH
         3HTw==
X-Forwarded-Encrypted: i=1; AJvYcCUhz28FeOe23MhtUSLwjff5DVr0ReCqczo8auxCJXPzZl0UJPUBbseF4K+LhCtHS0Ow0b9Ayni06A==@vger.kernel.org
X-Gm-Message-State: AOJu0Yz+Y7/RzNBmngPbqfK1VRgfSc3o5tkOsBgI9+EK08vjqOdCNyGe
	zzQf2UU/e2K6L6WX4ri9+nbCEVDlQDmvB6lGvNes6h4sZG8Oo0umwTItQOMWAGW5M0yhFC2xdeZ
	0+qcKn1K23S1juCWYflWA93HSdixd+2sNJCKOinKWpV9OLe0n2yjS63A=
X-Google-Smtp-Source: AGHT+IGgXGp/dbWaAiyHKK99HPV4eKxdo/OgZExWtVBw5a/Zglt9quEj/pvW3mV5PYZxEMPCuJyfF4TLANDrlzadHl1xsm++Cdis
Precedence: bulk
X-Mailing-List: io-uring@vger.kernel.org
List-Id: <io-uring.vger.kernel.org>
List-Subscribe: <mailto:io-uring+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:io-uring+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-Received: by 2002:a05:6e02:20c9:b0:3a7:955e:1cc5 with SMTP id
 e9e14a558f8ab-3c2d1b9bad6mr134970885ab.1.1734983547623; Mon, 23 Dec 2024
 11:52:27 -0800 (PST)
Date: Mon, 23 Dec 2024 11:52:27 -0800
X-Google-Appengine-App-Id: s~syzkaller
X-Google-Appengine-App-Id-Alias: syzkaller
Message-ID: <6769bf7b.050a0220.226966.0041.GAE@google.com>
Subject: [syzbot] [io-uring?] BUG: unable to handle kernel NULL pointer
 dereference in percpu_ref_put_many
From: syzbot <syzbot+3dcac84cc1d50f43ed31@syzkaller.appspotmail.com>
To: asml.silence@gmail.com, axboe@kernel.dk, io-uring@vger.kernel.org, 
	linux-kernel@vger.kernel.org, syzkaller-bugs@googlegroups.com
Content-Type: text/plain; charset="UTF-8"

Hello,

syzbot found the following issue on:

HEAD commit:    eabcdba3ad40 Merge tag 'for-6.13-rc3-tag' of git://git.ker..
git tree:       upstream
console output: https://syzkaller.appspot.com/x/log.txt?x=10871f44580000
kernel config:  https://syzkaller.appspot.com/x/.config?x=c22efbd20f8da769
dashboard link: https://syzkaller.appspot.com/bug?extid=3dcac84cc1d50f43ed31
compiler:       gcc (Debian 12.2.0-14) 12.2.0, GNU ld (GNU Binutils for Debian) 2.40
syz repro:      https://syzkaller.appspot.com/x/repro.syz?x=141bccf8580000
C reproducer:   https://syzkaller.appspot.com/x/repro.c?x=135f7730580000

Downloadable assets:
disk image: https://storage.googleapis.com/syzbot-assets/a9904ed2be77/disk-eabcdba3.raw.xz
vmlinux: https://storage.googleapis.com/syzbot-assets/fb8d571e1cb3/vmlinux-eabcdba3.xz
kernel image: https://storage.googleapis.com/syzbot-assets/76349070db25/bzImage-eabcdba3.xz

IMPORTANT: if you fix the issue, please add the following tag to the commit:
Reported-by: syzbot+3dcac84cc1d50f43ed31@syzkaller.appspotmail.com

BUG: kernel NULL pointer dereference, address: 0000000000000000
#PF: supervisor instruction fetch in kernel mode
#PF: error_code(0x0010) - not-present page
PGD 0 P4D 0 
Oops: Oops: 0010 [#1] PREEMPT SMP KASAN PTI
CPU: 0 UID: 0 PID: 11082 Comm: syz-executor246 Not tainted 6.13.0-rc3-syzkaller-00073-geabcdba3ad40 #0
Hardware name: Google Google Compute Engine/Google Compute Engine, BIOS Google 11/25/2024
RIP: 0010:0x0
Code: Unable to access opcode bytes at 0xffffffffffffffd6.
RSP: 0018:ffffc9000413f9e0 EFLAGS: 00010046
RAX: 0000000000000000 RBX: ffff88807c722018 RCX: ffffffff8497d56c
RDX: 1ffff110287e09e1 RSI: ffffffff8497d57a RDI: ffff88807c722018
RBP: ffff888143f04f00 R08: 0000000000000001 R09: 0000000000000000
R10: 0000000000000001 R11: 0000000000000002 R12: ffff88807c722020
R13: 0000000000000000 R14: 0000000000000000 R15: ffff8880745b4a10
FS:  0000000000000000(0000) GS:ffff8880b8600000(0000) knlGS:0000000000000000
CS:  0010 DS: 0000 ES: 0000 CR0: 0000000080050033
CR2: ffffffffffffffd6 CR3: 000000000db7e000 CR4: 00000000003526f0
DR0: 0000000000000000 DR1: 0000000000000000 DR2: 0000000000000000
DR3: 0000000000000000 DR6: 00000000fffe0ff0 DR7: 0000000000000400
Call Trace:
 <TASK>
 percpu_ref_put_many.constprop.0+0x269/0x2a0 include/linux/percpu-refcount.h:335
 percpu_ref_put include/linux/percpu-refcount.h:351 [inline]
 percpu_ref_kill_and_confirm+0x94/0x180 lib/percpu-refcount.c:396
 percpu_ref_kill include/linux/percpu-refcount.h:149 [inline]
 io_ring_ctx_wait_and_kill+0x86/0x250 io_uring/io_uring.c:2973
 io_uring_release+0x39/0x50 io_uring/io_uring.c:2995
 __fput+0x3f8/0xb60 fs/file_table.c:450
 task_work_run+0x14e/0x250 kernel/task_work.c:239
 exit_task_work include/linux/task_work.h:43 [inline]
 do_exit+0xadd/0x2d70 kernel/exit.c:938
 do_group_exit+0xd3/0x2a0 kernel/exit.c:1087
 get_signal+0x2576/0x2610 kernel/signal.c:3017
 arch_do_signal_or_restart+0x90/0x7e0 arch/x86/kernel/signal.c:337
 exit_to_user_mode_loop kernel/entry/common.c:111 [inline]
 exit_to_user_mode_prepare include/linux/entry-common.h:329 [inline]
 __syscall_exit_to_user_mode_work kernel/entry/common.c:207 [inline]
 syscall_exit_to_user_mode+0x150/0x2a0 kernel/entry/common.c:218
 do_syscall_64+0xda/0x250 arch/x86/entry/common.c:89
 entry_SYSCALL_64_after_hwframe+0x77/0x7f
RIP: 0033:0x7f1575ca04e9
Code: Unable to access opcode bytes at 0x7f1575ca04bf.
RSP: 002b:00007f1575c5b218 EFLAGS: 00000246 ORIG_RAX: 00000000000000ca
RAX: fffffffffffffe00 RBX: 00007f1575d2a308 RCX: 00007f1575ca04e9
RDX: 0000000000000000 RSI: 0000000000000080 RDI: 00007f1575d2a308
RBP: 00007f1575d2a300 R08: 0000000000000000 R09: 0000000000000000
R10: 0000000000000000 R11: 0000000000000246 R12: 00007f1575d2a30c
R13: 00007f1575cf7074 R14: 006e716e5f797265 R15: 0030656c69662f2e
 </TASK>
Modules linked in:
CR2: 0000000000000000
---[ end trace 0000000000000000 ]---
RIP: 0010:0x0
Code: Unable to access opcode bytes at 0xffffffffffffffd6.
RSP: 0018:ffffc9000413f9e0 EFLAGS: 00010046
RAX: 0000000000000000 RBX: ffff88807c722018 RCX: ffffffff8497d56c
RDX: 1ffff110287e09e1 RSI: ffffffff8497d57a RDI: ffff88807c722018
RBP: ffff888143f04f00 R08: 0000000000000001 R09: 0000000000000000
R10: 0000000000000001 R11: 0000000000000002 R12: ffff88807c722020
R13: 0000000000000000 R14: 0000000000000000 R15: ffff8880745b4a10
FS:  0000000000000000(0000) GS:ffff8880b8600000(0000) knlGS:0000000000000000
CS:  0010 DS: 0000 ES: 0000 CR0: 0000000080050033
CR2: ffffffffffffffd6 CR3: 000000000db7e000 CR4: 00000000003526f0
DR0: 0000000000000000 DR1: 0000000000000000 DR2: 0000000000000000
DR3: 0000000000000000 DR6: 00000000fffe0ff0 DR7: 0000000000000400


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

