Return-Path: <io-uring+bounces-10870-lists+io-uring=lfdr.de@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from dfw.mirrors.kernel.org (dfw.mirrors.kernel.org [142.0.200.124])
	by mail.lfdr.de (Postfix) with ESMTPS id 3F9D8C98689
	for <lists+io-uring@lfdr.de>; Mon, 01 Dec 2025 18:07:53 +0100 (CET)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by dfw.mirrors.kernel.org (Postfix) with ESMTPS id C0BF84E22A6
	for <lists+io-uring@lfdr.de>; Mon,  1 Dec 2025 17:07:46 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id AF84533469F;
	Mon,  1 Dec 2025 17:07:39 +0000 (UTC)
X-Original-To: io-uring@vger.kernel.org
Received: from mail-oa1-f80.google.com (mail-oa1-f80.google.com [209.85.160.80])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id DF27C335BC1
	for <io-uring@vger.kernel.org>; Mon,  1 Dec 2025 17:07:37 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.160.80
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1764608859; cv=none; b=f5eqV1q50rzgiGT2LhIH2Yb3y0J7GkMkhcFkC3cgpFnIcPZ+7MCEdwzQzXI7raTuYrHDYSnZHo9F9RwqwurdAsANYsuURI7tpDcIqUa/HQcrJPmzkNVMi+4W1Lc9g2hGaR9KMFGIh4u9S3AoVGUtBGBMKWKoW15sdxUFQj6z2ZY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1764608859; c=relaxed/simple;
	bh=A4sa/7eFVyMZatLPYjUSB1g99hIr7cfbRrD+a7pT1MM=;
	h=MIME-Version:Date:Message-ID:Subject:From:To:Content-Type; b=M4QLf6fTIsYwKDOwRVF5JShSkh7hi5D4xv5RzgsufJkH8DcZ01ucnxoXNWZAVbuRltNUnqPvYJkdDgfcCvyZKrgvIaqOINSWBE8cazvwRG/5lLm/C9vY96IqdhXhcF+L51ip7GFHlDZeuZobiPNoOw0Y/ZlB6KUlxC4BqNUmQg0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=fail (p=none dis=none) header.from=syzkaller.appspotmail.com; spf=pass smtp.mailfrom=M3KW2WVRGUFZ5GODRSRYTGD7.apphosting.bounces.google.com; arc=none smtp.client-ip=209.85.160.80
Authentication-Results: smtp.subspace.kernel.org; dmarc=fail (p=none dis=none) header.from=syzkaller.appspotmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=M3KW2WVRGUFZ5GODRSRYTGD7.apphosting.bounces.google.com
Received: by mail-oa1-f80.google.com with SMTP id 586e51a60fabf-3e88358a7feso4531112fac.1
        for <io-uring@vger.kernel.org>; Mon, 01 Dec 2025 09:07:37 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1764608857; x=1765213657;
        h=to:from:subject:message-id:date:mime-version:x-gm-message-state
         :from:to:cc:subject:date:message-id:reply-to;
        bh=PulCKizpA9Z5muYyan2JEvePN99gM26/n4ONZAjRLaA=;
        b=Kl27J9ZUWgTv4btPdimtYfklHX/pNNJEJ3lgFskPM5ZbCfjTxOxdr+mBCv5cOYZOL5
         jsYjHt76FV3v9NY/utcEAm5RF1kesU4+9sn9qNQDfC/WbzqQpLQDtriAZ5J2CprjOreD
         JusiNM/W1Q7jxvJJyDOtOLNWI/CNUYSYVoss1o2E9d7bTBYwy6I+kkSBfXGkfK8+qRJK
         H4bcbjOnDufAL9k7OUvaVeQyFRVIZLAR82u10B/YX+kjfwIyzQWF7SADTldyeDOUDgQB
         t6xnATqDAU5qL+a+LtifvWbvgMAtAXL2FaHzXbJjYo+y53027EP5Xrh9A5CNUpMLZXhu
         nPmQ==
X-Forwarded-Encrypted: i=1; AJvYcCVgtSlBJTxCJYwbunYJF0trJY2M4dcEVuylVquyl16K1TD6QHVV+ZR2bDkhJSUbw9W7KvWhx0+bzg==@vger.kernel.org
X-Gm-Message-State: AOJu0Yyn1VatgG/b3oNHz5zdLNsrZy3Ai8mKiQuuZbWAnG0VZNRin3Vz
	H1UDYrWYD3xSi0w4+FXAFgl2Cgebhto5D0zbeaiGhHqPDRSoR1e4y4QDVYEfjiBhsWGVI+BYeFv
	Gm4p2QnWNzrsITqqYq8s8JqpKrMQRnQO5EiiU0g/W5gyE+gauJT9H6TAojO8=
X-Google-Smtp-Source: AGHT+IFlSfztzX02fpjFPCfYx4KjIqVFAZkttn/wUnppyuWaM5s6QZNw5s9GBN2A1wKDhhPMfjoozI4bXjUgVetl4nVPxZlj6eh+
Precedence: bulk
X-Mailing-List: io-uring@vger.kernel.org
List-Id: <io-uring.vger.kernel.org>
List-Subscribe: <mailto:io-uring+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:io-uring+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-Received: by 2002:a05:6808:3994:b0:450:d025:d6b with SMTP id
 5614622812f47-4514e6aa590mr12321175b6e.16.1764608856815; Mon, 01 Dec 2025
 09:07:36 -0800 (PST)
Date: Mon, 01 Dec 2025 09:07:36 -0800
X-Google-Appengine-App-Id: s~syzkaller
X-Google-Appengine-App-Id-Alias: syzkaller
Message-ID: <692dcb58.a70a0220.2ea503.00b5.GAE@google.com>
Subject: [syzbot] [io-uring?] memory leak in io_submit_sqes (5)
From: syzbot <syzbot+641eec6b7af1f62f2b99@syzkaller.appspotmail.com>
To: axboe@kernel.dk, io-uring@vger.kernel.org, linux-kernel@vger.kernel.org, 
	syzkaller-bugs@googlegroups.com
Content-Type: text/plain; charset="UTF-8"

Hello,

syzbot found the following issue on:

HEAD commit:    7d0a66e4bb90 Linux 6.18
git tree:       upstream
console output: https://syzkaller.appspot.com/x/log.txt?x=110d0512580000
kernel config:  https://syzkaller.appspot.com/x/.config?x=f30cc590c4f6da44
dashboard link: https://syzkaller.appspot.com/bug?extid=641eec6b7af1f62f2b99
compiler:       gcc (Debian 12.2.0-14+deb12u1) 12.2.0, GNU ld (GNU Binutils for Debian) 2.40
syz repro:      https://syzkaller.appspot.com/x/repro.syz?x=150d0512580000

Downloadable assets:
disk image: https://storage.googleapis.com/syzbot-assets/3e289f3ec7e8/disk-7d0a66e4.raw.xz
vmlinux: https://storage.googleapis.com/syzbot-assets/bf695f1b8080/vmlinux-7d0a66e4.xz
kernel image: https://storage.googleapis.com/syzbot-assets/eb2f95cf98c6/bzImage-7d0a66e4.xz

IMPORTANT: if you fix the issue, please add the following tag to the commit:
Reported-by: syzbot+641eec6b7af1f62f2b99@syzkaller.appspotmail.com

2025/12/01 16:45:07 executed programs: 5
BUG: memory leak
unreferenced object 0xffff888112d6b200 (size 248):
  comm "syz.0.17", pid 6070, jiffies 4294944719
  hex dump (first 32 bytes):
    40 f8 56 0d 81 88 ff ff 00 00 00 00 00 00 00 00  @.V.............
    3c 20 00 c0 00 00 00 00 00 00 00 00 00 00 00 00  < ..............
  backtrace (crc 9dd5d643):
    kmemleak_alloc_recursive include/linux/kmemleak.h:44 [inline]
    slab_post_alloc_hook mm/slub.c:4983 [inline]
    kmem_cache_alloc_bulk_noprof+0x220/0x3e0 mm/slub.c:7497
    __io_alloc_req_refill+0x54/0x1a0 io_uring/io_uring.c:1058
    io_alloc_req io_uring/io_uring.h:543 [inline]
    io_submit_sqes+0x584/0xe80 io_uring/io_uring.c:2438
    __do_sys_io_uring_enter+0x83f/0xcf0 io_uring/io_uring.c:3516
    do_syscall_x64 arch/x86/entry/syscall_64.c:63 [inline]
    do_syscall_64+0xa4/0xfa0 arch/x86/entry/syscall_64.c:94
    entry_SYSCALL_64_after_hwframe+0x77/0x7f

BUG: memory leak
unreferenced object 0xffff888112e96200 (size 248):
  comm "syz.0.18", pid 6072, jiffies 4294944721
  hex dump (first 32 bytes):
    40 f8 56 0d 81 88 ff ff 00 00 00 00 00 00 00 00  @.V.............
    3c 20 00 c0 00 00 00 00 00 00 00 00 00 00 00 00  < ..............
  backtrace (crc 79b7669c):
    kmemleak_alloc_recursive include/linux/kmemleak.h:44 [inline]
    slab_post_alloc_hook mm/slub.c:4983 [inline]
    kmem_cache_alloc_bulk_noprof+0x220/0x3e0 mm/slub.c:7497
    __io_alloc_req_refill+0x54/0x1a0 io_uring/io_uring.c:1058
    io_alloc_req io_uring/io_uring.h:543 [inline]
    io_submit_sqes+0x584/0xe80 io_uring/io_uring.c:2438
    __do_sys_io_uring_enter+0x83f/0xcf0 io_uring/io_uring.c:3516
    do_syscall_x64 arch/x86/entry/syscall_64.c:63 [inline]
    do_syscall_64+0xa4/0xfa0 arch/x86/entry/syscall_64.c:94
    entry_SYSCALL_64_after_hwframe+0x77/0x7f

BUG: memory leak
unreferenced object 0xffff888112e5ed00 (size 248):
  comm "syz.0.19", pid 6073, jiffies 4294944722
  hex dump (first 32 bytes):
    40 f8 56 0d 81 88 ff ff 00 00 00 00 00 00 00 00  @.V.............
    3c 20 00 c0 00 00 00 00 00 00 00 00 00 00 00 00  < ..............
  backtrace (crc 11e3e38b):
    kmemleak_alloc_recursive include/linux/kmemleak.h:44 [inline]
    slab_post_alloc_hook mm/slub.c:4983 [inline]
    kmem_cache_alloc_bulk_noprof+0x220/0x3e0 mm/slub.c:7497
    __io_alloc_req_refill+0x54/0x1a0 io_uring/io_uring.c:1058
    io_alloc_req io_uring/io_uring.h:543 [inline]
    io_submit_sqes+0x584/0xe80 io_uring/io_uring.c:2438
    __do_sys_io_uring_enter+0x83f/0xcf0 io_uring/io_uring.c:3516
    do_syscall_x64 arch/x86/entry/syscall_64.c:63 [inline]
    do_syscall_64+0xa4/0xfa0 arch/x86/entry/syscall_64.c:94
    entry_SYSCALL_64_after_hwframe+0x77/0x7f

BUG: memory leak
unreferenced object 0xffff888127618400 (size 248):
  comm "syz.0.20", pid 6127, jiffies 4294945384
  hex dump (first 32 bytes):
    40 f8 56 0d 81 88 ff ff 00 00 00 00 00 00 00 00  @.V.............
    3c 20 00 c0 00 00 00 00 00 00 00 00 00 00 00 00  < ..............
  backtrace (crc b9653957):
    kmemleak_alloc_recursive include/linux/kmemleak.h:44 [inline]
    slab_post_alloc_hook mm/slub.c:4983 [inline]
    kmem_cache_alloc_bulk_noprof+0x220/0x3e0 mm/slub.c:7497
    __io_alloc_req_refill+0x54/0x1a0 io_uring/io_uring.c:1058
    io_alloc_req io_uring/io_uring.h:543 [inline]
    io_submit_sqes+0x584/0xe80 io_uring/io_uring.c:2438
    __do_sys_io_uring_enter+0x83f/0xcf0 io_uring/io_uring.c:3516
    do_syscall_x64 arch/x86/entry/syscall_64.c:63 [inline]
    do_syscall_64+0xa4/0xfa0 arch/x86/entry/syscall_64.c:94
    entry_SYSCALL_64_after_hwframe+0x77/0x7f

BUG: memory leak
unreferenced object 0xffff8881262cf200 (size 248):
  comm "syz.0.21", pid 6128, jiffies 4294945385
  hex dump (first 32 bytes):
    40 f8 56 0d 81 88 ff ff 00 00 00 00 00 00 00 00  @.V.............
    3c 20 00 c0 00 00 00 00 00 00 00 00 00 00 00 00  < ..............
  backtrace (crc 457654b1):
    kmemleak_alloc_recursive include/linux/kmemleak.h:44 [inline]
    slab_post_alloc_hook mm/slub.c:4983 [inline]
    kmem_cache_alloc_bulk_noprof+0x220/0x3e0 mm/slub.c:7497
    __io_alloc_req_refill+0x54/0x1a0 io_uring/io_uring.c:1058
    io_alloc_req io_uring/io_uring.h:543 [inline]
    io_submit_sqes+0x584/0xe80 io_uring/io_uring.c:2438
    __do_sys_io_uring_enter+0x83f/0xcf0 io_uring/io_uring.c:3516
    do_syscall_x64 arch/x86/entry/syscall_64.c:63 [inline]
    do_syscall_64+0xa4/0xfa0 arch/x86/entry/syscall_64.c:94
    entry_SYSCALL_64_after_hwframe+0x77/0x7f

connection error: failed to recv *flatrpc.ExecutorMessageRawT: EOF


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

