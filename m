Return-Path: <io-uring+bounces-8344-lists+io-uring=lfdr.de@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from sy.mirrors.kernel.org (sy.mirrors.kernel.org [147.75.48.161])
	by mail.lfdr.de (Postfix) with ESMTPS id 062A3ADA136
	for <lists+io-uring@lfdr.de>; Sun, 15 Jun 2025 09:35:34 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sy.mirrors.kernel.org (Postfix) with ESMTPS id EA50A7A9BB9
	for <lists+io-uring@lfdr.de>; Sun, 15 Jun 2025 07:34:11 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 6C4C81922FB;
	Sun, 15 Jun 2025 07:35:28 +0000 (UTC)
X-Original-To: io-uring@vger.kernel.org
Received: from mail-io1-f80.google.com (mail-io1-f80.google.com [209.85.166.80])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 938CE1BC3F
	for <io-uring@vger.kernel.org>; Sun, 15 Jun 2025 07:35:26 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.166.80
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1749972928; cv=none; b=aZltC8djFMFKrhhT+ZJQTZwsAoNoJ2+X3RI4oD/jLQEZfNh4zXzuhd9PzZGoZx4Y8r7W1Q57jVTDxGusLCN8fUnvrtpVJGW+EyYQ8azDmb0WzTLyIwE/wvp0cLcj6bxcVXu2AR5HA9+1D8TCHLQF/kMWieaJMc9fVp8c2V9T9qs=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1749972928; c=relaxed/simple;
	bh=TYmktIn3n42QmKClhXVRANX3DvcuuNc5Z1BB/nALABE=;
	h=MIME-Version:Date:Message-ID:Subject:From:To:Content-Type; b=Ho4sZ8eoNeirQzUfx5G9ehXpZVf6AzuYrdpGQfNYI8JNld+fDC+F2dclkHVABXFMVvvh7FdwX1dtPIhzTiRtFeC32uvZrcnepITp9UyI5gMQqJkcU4w74zXZ5lQVY43kbnSIn/+OG8f506EH0ueEAtt1NZRlcSZTWUw31ma/Ch4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=fail (p=none dis=none) header.from=syzkaller.appspotmail.com; spf=pass smtp.mailfrom=M3KW2WVRGUFZ5GODRSRYTGD7.apphosting.bounces.google.com; arc=none smtp.client-ip=209.85.166.80
Authentication-Results: smtp.subspace.kernel.org; dmarc=fail (p=none dis=none) header.from=syzkaller.appspotmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=M3KW2WVRGUFZ5GODRSRYTGD7.apphosting.bounces.google.com
Received: by mail-io1-f80.google.com with SMTP id ca18e2360f4ac-875b6256041so284627139f.2
        for <io-uring@vger.kernel.org>; Sun, 15 Jun 2025 00:35:26 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1749972926; x=1750577726;
        h=to:from:subject:message-id:date:mime-version:x-gm-message-state
         :from:to:cc:subject:date:message-id:reply-to;
        bh=1pL33sSdNVTBaRKS6axTdFjtZlV8CPQhJ68btPDVGWE=;
        b=Zr14dNfvYNLpYL8/IP4GPQC6zAyEo74JjwuRzSzhce9ZVe+PQJN1UhRQt2uVgZw37p
         iig4DqKUal7QyofeKnsqx0AsFU0zokhiAk2MqwCP6X40XadyTLEq8Rndo2ERRcTRTOsJ
         H1yVC6nxesxlOwJNXyoKDMbqy09EtxyYzcw1IqB7+beWf19YUET5LilMGg+jCd8yNbMZ
         kK9oDQEeGuGqUNfaRaIj7jI/fG1cGz81ercGJK35ix64lcsMB495z+vYu2uPRiO5YbuY
         Fz69JWBnXHrk7WOxq4CkaNUeU2/mzE1bvOZcGRax7qmRr9FCgBKK7qEKPYj4Iiqu5i9b
         /AfA==
X-Forwarded-Encrypted: i=1; AJvYcCXr/rX2qbRV0xAG0SgoAm3S4qtB5kdmsXMF30YWn4gqCf2b7eF5ZDB4HLEnQWF8OdeFq6PuSSPCAA==@vger.kernel.org
X-Gm-Message-State: AOJu0YzOSjIWJhmywzjuKb2rJcHzM+GZmDzV9DBv2bgXGz/qK+cfsgES
	jpxChjKIgg9x4nqoFY+Ol/NMFTbcjpJlZqYw+G9P1gbt2mJm5aIcZlZtvazb0gxRwDzkAgQid3t
	HAl6E3tpgUHELh7kPYGjFMQ0r2zhvasK7SbGisks5un2p3uTbwdcVZ4Xue/0=
X-Google-Smtp-Source: AGHT+IGZ6G6rWLQPm9EnDsDTE/vfF8hfk3f+woSQ7LIYkk9YPylE7ceTkRXzM7W/s3eBQSb29xa7Z+n23J0/kb6VAFfD8Ec8wvwd
Precedence: bulk
X-Mailing-List: io-uring@vger.kernel.org
List-Id: <io-uring.vger.kernel.org>
List-Subscribe: <mailto:io-uring+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:io-uring+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-Received: by 2002:a05:6602:341b:b0:866:217f:80a with SMTP id
 ca18e2360f4ac-875ded3ea30mr594685939f.7.1749972925788; Sun, 15 Jun 2025
 00:35:25 -0700 (PDT)
Date: Sun, 15 Jun 2025 00:35:25 -0700
X-Google-Appengine-App-Id: s~syzkaller
X-Google-Appengine-App-Id-Alias: syzkaller
Message-ID: <684e77bd.a00a0220.279073.0029.GAE@google.com>
Subject: [syzbot] [io-uring?] WARNING in io_register_clone_buffers
From: syzbot <syzbot+cb4bf3cb653be0d25de8@syzkaller.appspotmail.com>
To: asml.silence@gmail.com, axboe@kernel.dk, io-uring@vger.kernel.org, 
	linux-kernel@vger.kernel.org, syzkaller-bugs@googlegroups.com
Content-Type: text/plain; charset="UTF-8"

Hello,

syzbot found the following issue on:

HEAD commit:    d7fa1af5b33e Merge branch 'for-next/core' into for-kernelci
git tree:       git://git.kernel.org/pub/scm/linux/kernel/git/arm64/linux.git for-kernelci
console output: https://syzkaller.appspot.com/x/log.txt?x=13db6682580000
kernel config:  https://syzkaller.appspot.com/x/.config?x=89c13de706fbf07a
dashboard link: https://syzkaller.appspot.com/bug?extid=cb4bf3cb653be0d25de8
compiler:       Debian clang version 20.1.6 (++20250514063057+1e4d39e07757-1~exp1~20250514183223.118), Debian LLD 20.1.6
userspace arch: arm64
syz repro:      https://syzkaller.appspot.com/x/repro.syz?x=15cab60c580000
C reproducer:   https://syzkaller.appspot.com/x/repro.c?x=10c9a60c580000

Downloadable assets:
disk image: https://storage.googleapis.com/syzbot-assets/da97ad659b2c/disk-d7fa1af5.raw.xz
vmlinux: https://storage.googleapis.com/syzbot-assets/659e123552a8/vmlinux-d7fa1af5.xz
kernel image: https://storage.googleapis.com/syzbot-assets/6ec5dbf4643e/Image-d7fa1af5.gz.xz

IMPORTANT: if you fix the issue, please add the following tag to the commit:
Reported-by: syzbot+cb4bf3cb653be0d25de8@syzkaller.appspotmail.com

------------[ cut here ]------------
WARNING: CPU: 0 PID: 6488 at mm/slub.c:5024 __kvmalloc_node_noprof+0x520/0x640 mm/slub.c:5024
Modules linked in:
CPU: 0 UID: 0 PID: 6488 Comm: syz-executor312 Not tainted 6.15.0-rc7-syzkaller-gd7fa1af5b33e #0 PREEMPT 
Hardware name: Google Google Compute Engine/Google Compute Engine, BIOS Google 05/07/2025
pstate: 20400005 (nzCv daif +PAN -UAO -TCO -DIT -SSBS BTYPE=--)
pc : __kvmalloc_node_noprof+0x520/0x640 mm/slub.c:5024
lr : __do_kmalloc_node mm/slub.c:-1 [inline]
lr : __kvmalloc_node_noprof+0x3b4/0x640 mm/slub.c:5012
sp : ffff80009cfd7a90
x29: ffff80009cfd7ac0 x28: ffff0000dd52a120 x27: 0000000000412dc0
x26: 0000000000000178 x25: ffff7000139faf70 x24: 0000000000000000
x23: ffff800082f4cea8 x22: 00000000ffffffff x21: 000000010cd004a8
x20: ffff0000d75816c0 x19: ffff0000dd52a000 x18: 00000000ffffffff
x17: ffff800092f39000 x16: ffff80008adbe9e4 x15: 0000000000000005
x14: 1ffff000139faf1c x13: 0000000000000000 x12: 0000000000000000
x11: ffff7000139faf21 x10: 0000000000000003 x9 : ffff80008f27b938
x8 : 0000000000000002 x7 : 0000000000000000 x6 : 0000000000000000
x5 : 00000000ffffffff x4 : 0000000000400dc0 x3 : 0000000200000000
x2 : 000000010cd004a8 x1 : ffff80008b3ebc40 x0 : 0000000000000001
Call trace:
 __kvmalloc_node_noprof+0x520/0x640 mm/slub.c:5024 (P)
 kvmalloc_array_node_noprof include/linux/slab.h:1065 [inline]
 io_rsrc_data_alloc io_uring/rsrc.c:206 [inline]
 io_clone_buffers io_uring/rsrc.c:1178 [inline]
 io_register_clone_buffers+0x484/0xa14 io_uring/rsrc.c:1287
 __io_uring_register io_uring/register.c:815 [inline]
 __do_sys_io_uring_register io_uring/register.c:926 [inline]
 __se_sys_io_uring_register io_uring/register.c:903 [inline]
 __arm64_sys_io_uring_register+0x42c/0xea8 io_uring/register.c:903
 __invoke_syscall arch/arm64/kernel/syscall.c:35 [inline]
 invoke_syscall+0x98/0x2b8 arch/arm64/kernel/syscall.c:49
 el0_svc_common+0x130/0x23c arch/arm64/kernel/syscall.c:132
 do_el0_svc+0x48/0x58 arch/arm64/kernel/syscall.c:151
 el0_svc+0x58/0x17c arch/arm64/kernel/entry-common.c:767
 el0t_64_sync_handler+0x78/0x108 arch/arm64/kernel/entry-common.c:786
 el0t_64_sync+0x198/0x19c arch/arm64/kernel/entry.S:600
irq event stamp: 370
hardirqs last  enabled at (369): [<ffff8000801fc600>] local_daif_restore+0x1c/0x3c arch/arm64/include/asm/daifflags.h:75
hardirqs last disabled at (370): [<ffff80008adb9eb8>] el1_dbg+0x24/0x80 arch/arm64/kernel/entry-common.c:511
softirqs last  enabled at (294): [<ffff8000803cf71c>] softirq_handle_end kernel/softirq.c:425 [inline]
softirqs last  enabled at (294): [<ffff8000803cf71c>] handle_softirqs+0xaf8/0xc88 kernel/softirq.c:607
softirqs last disabled at (289): [<ffff800080020efc>] __do_softirq+0x14/0x20 kernel/softirq.c:613
---[ end trace 0000000000000000 ]---


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

