Return-Path: <io-uring+bounces-5626-lists+io-uring=lfdr.de@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [IPv6:2604:1380:4601:e00::3])
	by mail.lfdr.de (Postfix) with ESMTPS id 0B77A9FDE14
	for <lists+io-uring@lfdr.de>; Sun, 29 Dec 2024 10:01:28 +0100 (CET)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id A21511882657
	for <lists+io-uring@lfdr.de>; Sun, 29 Dec 2024 09:01:29 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 71B952594AD;
	Sun, 29 Dec 2024 09:01:23 +0000 (UTC)
X-Original-To: io-uring@vger.kernel.org
Received: from mail-il1-f207.google.com (mail-il1-f207.google.com [209.85.166.207])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A4C962D057
	for <io-uring@vger.kernel.org>; Sun, 29 Dec 2024 09:01:21 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.166.207
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1735462883; cv=none; b=TxW3mxy02x8QeqYLUkB7vtvF/BgIqt54RSR3bjz5UN8Ha00gtdEZPqWcn8mW09OLXm8L7ZvfgEyvdoJHfVGPFYbjis3SdYiGOI/PeiizJo8/U/sabg/Uz68ylvfbQiSOsfM/mjlIjboLxO3RpQZ4t8PVa0yUVvqSkPol+OXAL+Q=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1735462883; c=relaxed/simple;
	bh=DakjHU/5EqAFl6w1dBdeo075DH3PGCAoL+ZF094M9pE=;
	h=MIME-Version:Date:Message-ID:Subject:From:To:Content-Type; b=law+6nNtF7SINIFrNnuIJRHs6slkxuGH/eTruGisLcb0EozzJGyHhdoPVNtFW/Rqxabl9CLKDM7FwSgdOmBpLUPh0eHs+yZScUOCBN+x/SySs5lkIFihA0ih3NsR82SINEc0PXdirvoIH/Y6l2rhtNTgPSoaseGwdwsdzjtOvGY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=fail (p=none dis=none) header.from=syzkaller.appspotmail.com; spf=pass smtp.mailfrom=M3KW2WVRGUFZ5GODRSRYTGD7.apphosting.bounces.google.com; arc=none smtp.client-ip=209.85.166.207
Authentication-Results: smtp.subspace.kernel.org; dmarc=fail (p=none dis=none) header.from=syzkaller.appspotmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=M3KW2WVRGUFZ5GODRSRYTGD7.apphosting.bounces.google.com
Received: by mail-il1-f207.google.com with SMTP id e9e14a558f8ab-3a9d3e48637so82847255ab.1
        for <io-uring@vger.kernel.org>; Sun, 29 Dec 2024 01:01:21 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1735462881; x=1736067681;
        h=to:from:subject:message-id:date:mime-version:x-gm-message-state
         :from:to:cc:subject:date:message-id:reply-to;
        bh=daCCEn/1ANLJXY3OzsPHbrILxzq7Mu2AbRodggJztYU=;
        b=V8PybqgL36+evh09t9MCaid5v4mZcK+GW9/ZtdHDdeJL6Vq1sJqgB4koNE3QwT0VR4
         jRwABcmq8WKX3rIk9aFo6Y9OS99+VBOiBKlguTGztRr9acXL4nraiFUybyPZUrNCsoQq
         XJAh894qhQ9cUTUd2ApkG+BqzUBVhexHkRq9GKhgk5XxjOqAlLzjGTgpQQeRMeQq4/at
         R/SgFC3hBOcfavnOQkM0J5CptGrLwhoDiTjmhgExHkn86ZA/AdjqCCis1uupEZUxd4FL
         V25PlhNqsyVCgR0gJ/NEp64iRH0FFGiz3Mc/ozRCK+U6WIZxc23tYd/a5ZZL3KMM8GuO
         yg/A==
X-Forwarded-Encrypted: i=1; AJvYcCX/n4/dJ11MN2YaZbMfgB5A70+6Hk8NYUGUBWYJr4HfUH8dERwa5Sx1LglW5YBHJIvpQo7Rq6/g6g==@vger.kernel.org
X-Gm-Message-State: AOJu0YyP/tylaLat54sgb59f1NNo9UiHp60jghotaS5VI+pESMtuaEP8
	bUfKOtOIyv0KzWIh3+e7MBMJ+hcpiZdP+ZxcN5Ld/GIdNb4Lz1TbtXrKgOe5piWuBzQ2ihWGzmf
	kfXdyAxOxjUBEqcb5HwbECS2ticI9P49dT/j+PAaNxUi2QI6S81huVxQ=
X-Google-Smtp-Source: AGHT+IGwH9NK9dgykbiEF3bm2cVLjBukn/l7O8VNeaLcqZWKx4/9WmG7aM/vh+mg/TBsB/xAej59aYhmYdZodNOBMbGx5VLTG2Zj
Precedence: bulk
X-Mailing-List: io-uring@vger.kernel.org
List-Id: <io-uring.vger.kernel.org>
List-Subscribe: <mailto:io-uring+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:io-uring+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-Received: by 2002:a05:6e02:180a:b0:3a7:d082:651 with SMTP id
 e9e14a558f8ab-3c2d2d50c91mr254579465ab.12.1735462880856; Sun, 29 Dec 2024
 01:01:20 -0800 (PST)
Date: Sun, 29 Dec 2024 01:01:20 -0800
X-Google-Appengine-App-Id: s~syzkaller
X-Google-Appengine-App-Id-Alias: syzkaller
Message-ID: <67710fe0.050a0220.226966.00bd.GAE@google.com>
Subject: [syzbot] [fs?] [io-uring?] WARNING: locking bug in eventfd_signal_mask
From: syzbot <syzbot+b1fc199a40b65d601b65@syzkaller.appspotmail.com>
To: asml.silence@gmail.com, axboe@kernel.dk, bigeasy@linutronix.de, 
	brauner@kernel.org, clrkwllms@kernel.org, io-uring@vger.kernel.org, 
	jack@suse.cz, linux-fsdevel@vger.kernel.org, linux-kernel@vger.kernel.org, 
	linux-rt-devel@lists.linux.dev, rostedt@goodmis.org, 
	syzkaller-bugs@googlegroups.com, viro@zeniv.linux.org.uk
Content-Type: text/plain; charset="UTF-8"

Hello,

syzbot found the following issue on:

HEAD commit:    9b2ffa6148b1 Merge tag 'mtd/fixes-for-6.13-rc5' of git://g..
git tree:       upstream
console+strace: https://syzkaller.appspot.com/x/log.txt?x=128f74c4580000
kernel config:  https://syzkaller.appspot.com/x/.config?x=d269ef41b9262400
dashboard link: https://syzkaller.appspot.com/bug?extid=b1fc199a40b65d601b65
compiler:       Debian clang version 15.0.6, GNU ld (GNU Binutils for Debian) 2.40
syz repro:      https://syzkaller.appspot.com/x/repro.syz?x=1469890f980000
C reproducer:   https://syzkaller.appspot.com/x/repro.c?x=154b22f8580000

Downloadable assets:
disk image: https://storage.googleapis.com/syzbot-assets/9015cc2b19ac/disk-9b2ffa61.raw.xz
vmlinux: https://storage.googleapis.com/syzbot-assets/3ddeabd5e7eb/vmlinux-9b2ffa61.xz
kernel image: https://storage.googleapis.com/syzbot-assets/36e13b0305d0/bzImage-9b2ffa61.xz

The issue was bisected to:

commit 020b40f3562495f3c703a283ece145ffec19e82d
Author: Jens Axboe <axboe@kernel.dk>
Date:   Tue Dec 17 15:21:46 2024 +0000

    io_uring: make ctx->timeout_lock a raw spinlock

bisection log:  https://syzkaller.appspot.com/x/bisect.txt?x=124d0018580000
final oops:     https://syzkaller.appspot.com/x/report.txt?x=114d0018580000
console output: https://syzkaller.appspot.com/x/log.txt?x=164d0018580000

IMPORTANT: if you fix the issue, please add the following tag to the commit:
Reported-by: syzbot+b1fc199a40b65d601b65@syzkaller.appspotmail.com
Fixes: 020b40f35624 ("io_uring: make ctx->timeout_lock a raw spinlock")

=============================
[ BUG: Invalid wait context ]
6.13.0-rc4-syzkaller-00012-g9b2ffa6148b1 #0 Not tainted
-----------------------------
kworker/u8:2/35 is trying to lock:
ffff888033f47a20 (&ctx->wqh){....}-{3:3}, at: eventfd_signal_mask+0x7a/0x1f0 fs/eventfd.c:71
other info that might help us debug this:
context-{5:5}
6 locks held by kworker/u8:2/35:
 #0: ffff88801bb04948 ((wq_completion)iou_exit){+.+.}-{0:0}, at: process_one_work kernel/workqueue.c:3204 [inline]
 #0: ffff88801bb04948 ((wq_completion)iou_exit){+.+.}-{0:0}, at: process_scheduled_works+0x93b/0x1840 kernel/workqueue.c:3310
 #1: ffffc90000ab7d00 ((work_completion)(&ctx->exit_work)){+.+.}-{0:0}, at: process_one_work kernel/workqueue.c:3205 [inline]
 #1: ffffc90000ab7d00 ((work_completion)(&ctx->exit_work)){+.+.}-{0:0}, at: process_scheduled_works+0x976/0x1840 kernel/workqueue.c:3310
 #2: ffff888033bee3d8 (&ctx->completion_lock){+.+.}-{3:3}, at: spin_lock include/linux/spinlock.h:351 [inline]
 #2: ffff888033bee3d8 (&ctx->completion_lock){+.+.}-{3:3}, at: io_kill_timeouts+0x3c/0x230 io_uring/timeout.c:670
 #3: ffff888033bee358 (&ctx->timeout_lock){....}-{2:2}, at: io_kill_timeouts+0x4b/0x230 io_uring/timeout.c:671
 #4: ffffffff8e937ae0 (rcu_read_lock){....}-{1:3}, at: rcu_lock_acquire include/linux/rcupdate.h:337 [inline]
 #4: ffffffff8e937ae0 (rcu_read_lock){....}-{1:3}, at: rcu_read_lock include/linux/rcupdate.h:849 [inline]
 #4: ffffffff8e937ae0 (rcu_read_lock){....}-{1:3}, at: class_rcu_constructor include/linux/rcupdate.h:1161 [inline]
 #4: ffffffff8e937ae0 (rcu_read_lock){....}-{1:3}, at: io_req_local_work_add+0xb5/0x5c0 io_uring/io_uring.c:1161
 #5: ffffffff8e937ae0 (rcu_read_lock){....}-{1:3}, at: rcu_lock_acquire include/linux/rcupdate.h:337 [inline]
 #5: ffffffff8e937ae0 (rcu_read_lock){....}-{1:3}, at: rcu_read_lock include/linux/rcupdate.h:849 [inline]
 #5: ffffffff8e937ae0 (rcu_read_lock){....}-{1:3}, at: io_eventfd_grab+0xc2/0x6a0 io_uring/eventfd.c:97
stack backtrace:
CPU: 0 UID: 0 PID: 35 Comm: kworker/u8:2 Not tainted 6.13.0-rc4-syzkaller-00012-g9b2ffa6148b1 #0
Hardware name: Google Google Compute Engine/Google Compute Engine, BIOS Google 09/13/2024
Workqueue: iou_exit io_ring_exit_work
Call Trace:
 <TASK>
 __dump_stack lib/dump_stack.c:94 [inline]
 dump_stack_lvl+0x241/0x360 lib/dump_stack.c:120
 print_lock_invalid_wait_context kernel/locking/lockdep.c:4826 [inline]
 check_wait_context kernel/locking/lockdep.c:4898 [inline]
 __lock_acquire+0x15a8/0x2100 kernel/locking/lockdep.c:5176
 lock_acquire+0x1ed/0x550 kernel/locking/lockdep.c:5849
 __raw_spin_lock_irqsave include/linux/spinlock_api_smp.h:110 [inline]
 _raw_spin_lock_irqsave+0xd5/0x120 kernel/locking/spinlock.c:162
 eventfd_signal_mask+0x7a/0x1f0 fs/eventfd.c:71
 __io_eventfd_signal io_uring/eventfd.c:65 [inline]
 io_eventfd_signal+0x96/0x1d0 io_uring/eventfd.c:123
 io_req_local_work_add+0x408/0x5c0 io_uring/io_uring.c:1202
 io_req_task_work_add io_uring/io_uring.h:149 [inline]
 io_req_queue_tw_complete io_uring/io_uring.h:451 [inline]
 io_kill_timeout+0x27b/0x310 io_uring/timeout.c:101
 io_kill_timeouts+0x1b7/0x230 io_uring/timeout.c:676
 io_uring_try_cancel_requests+0x480/0x560 io_uring/io_uring.c:3117
 io_ring_exit_work+0x231/0x8a0 io_uring/io_uring.c:2901
 process_one_work kernel/workqueue.c:3229 [inline]
 process_scheduled_works+0xa66/0x1840 kernel/workqueue.c:3310
 worker_thread+0x870/0xd30 kernel/workqueue.c:3391
 kthread+0x2f0/0x390 kernel/kthread.c:389
 ret_from_fork+0x4b/0x80 arch/x86/kernel/process.c:147
 ret_from_fork_asm+0x1a/0x30 arch/x86/entry/entry_64.S:244
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

