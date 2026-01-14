Return-Path: <io-uring+bounces-11698-lists+io-uring=lfdr.de@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from sea.lore.kernel.org (sea.lore.kernel.org [172.234.253.10])
	by mail.lfdr.de (Postfix) with ESMTPS id 7D3C0D1D24B
	for <lists+io-uring@lfdr.de>; Wed, 14 Jan 2026 09:36:25 +0100 (CET)
Received: from smtp.subspace.kernel.org (conduit.subspace.kernel.org [100.90.174.1])
	by sea.lore.kernel.org (Postfix) with ESMTP id 2244F30053C5
	for <lists+io-uring@lfdr.de>; Wed, 14 Jan 2026 08:35:32 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 40DE637C0FF;
	Wed, 14 Jan 2026 08:35:31 +0000 (UTC)
X-Original-To: io-uring@vger.kernel.org
Received: from mail-oo1-f79.google.com (mail-oo1-f79.google.com [209.85.161.79])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B31D337E2F8
	for <io-uring@vger.kernel.org>; Wed, 14 Jan 2026 08:35:27 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.161.79
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1768379730; cv=none; b=Hvy2F8vYvLYM8S2tTgwaPtQgxOwOJ+VeJwUER2E5ONrqLzQ9SFDnreIRBGX+DbEUXBY3W/jvyaJBheXtxia4sHUYBoghN5J4Y9LX5A6rDWfOu4YREFShvfbJRVyjdEBLU3p5ap+aRDRB3YBHVXzIXeZIlr2x798E623MYl97QLo=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1768379730; c=relaxed/simple;
	bh=abBQcb06QoqN93vgKCJ6SvCkxX6S/CrmI8l2zF0pshc=;
	h=MIME-Version:Date:Message-ID:Subject:From:To:Content-Type; b=eDkYzCE/erJkg81zjpe5YcvJfLFrX+Wk5seImyKMIeAzwh8F31fgQh7tBKvIIzouSzd1NxokEnQHD1qSGop6cn6YQ1T+/YIY1gnazHpzWZz4CyrHS4bhYbRzOWx8J2ED+s2KS2/UnGtDiLa1eGGAQuviSuLjP3/HUF2V+ibL4tY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=fail (p=none dis=none) header.from=syzkaller.appspotmail.com; spf=pass smtp.mailfrom=M3KW2WVRGUFZ5GODRSRYTGD7.apphosting.bounces.google.com; arc=none smtp.client-ip=209.85.161.79
Authentication-Results: smtp.subspace.kernel.org; dmarc=fail (p=none dis=none) header.from=syzkaller.appspotmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=M3KW2WVRGUFZ5GODRSRYTGD7.apphosting.bounces.google.com
Received: by mail-oo1-f79.google.com with SMTP id 006d021491bc7-661094d05b7so136745eaf.1
        for <io-uring@vger.kernel.org>; Wed, 14 Jan 2026 00:35:27 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1768379726; x=1768984526;
        h=to:from:subject:message-id:date:mime-version:x-gm-message-state
         :from:to:cc:subject:date:message-id:reply-to;
        bh=Ur0KIjjqFLinHIDXYQQIULZWyjaQ5tUM7NZH21PFlBw=;
        b=uYp8BUWoLMe+PyQ09xab5awmSsVq6MTk63UBZFb63rt1yLC6TwH7oe1k8NsGeFqna0
         jgFPc5Jvb2G/dWhzcsFsl+ouToDniYoidS/zohqOtwU+tG35PWIQnsbkyJEagED2yx9i
         cnbq1LRBfoHoK2SJ2ArNABWwomnTQIb+QlwvogPasBLKqvlUmEW8OswNVVC4MRJO+9OA
         +tJiHG0OjFN1LPEN94CQ/C5hZZ+IunYY6WV+984S4KS7jtIEYncSNEYc35tzac6iDjbR
         prgswxr9nQLdtzw7P/XmlQfEWicOwr8R4A+WV722GZzBbBHCUPCfkjyGaSURS2g01n3I
         kpXw==
X-Forwarded-Encrypted: i=1; AJvYcCURODFIPnYVtRqzKqnTKU+dilcLX0Qm6I/AATguzMxP8bvWQKiHC2nF9o12Uu5KRdTdrWwhjqhUsA==@vger.kernel.org
X-Gm-Message-State: AOJu0Yw0USAp6BjrrDM6LB0yqju+39s24c+tc8Mq7QLVTjpAafFpc+sT
	ho6vfHtQHnip8d6neuLF9sufyKlBa8fcAJtREDGtNph90/rXumtRhEXeR0wAs3TkzPti6qtRQT0
	NSvHR0s5ijL8dI+tXsb8iPfIxyL1tM9gCZ0CuTDfKVc3cpXOBdrPt3ArIcMY=
Precedence: bulk
X-Mailing-List: io-uring@vger.kernel.org
List-Id: <io-uring.vger.kernel.org>
List-Subscribe: <mailto:io-uring+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:io-uring+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-Received: by 2002:a05:6820:621:b0:65d:697:3ae8 with SMTP id
 006d021491bc7-66100718ed1mr1474718eaf.72.1768379726632; Wed, 14 Jan 2026
 00:35:26 -0800 (PST)
Date: Wed, 14 Jan 2026 00:35:26 -0800
X-Google-Appengine-App-Id: s~syzkaller
X-Google-Appengine-App-Id-Alias: syzkaller
Message-ID: <6967554e.a70a0220.1aa68e.0004.GAE@google.com>
Subject: [syzbot] [io-uring?] memory leak in iovec_from_user (4)
From: syzbot <syzbot+df0b387708573ad096ce@syzkaller.appspotmail.com>
To: axboe@kernel.dk, io-uring@vger.kernel.org, linux-kernel@vger.kernel.org, 
	syzkaller-bugs@googlegroups.com
Content-Type: text/plain; charset="UTF-8"

Hello,

syzbot found the following issue on:

HEAD commit:    b54345928fa1 Merge tag 'gfs2-for-6.19-rc6' of git://git.ke..
git tree:       upstream
console output: https://syzkaller.appspot.com/x/log.txt?x=15f82052580000
kernel config:  https://syzkaller.appspot.com/x/.config?x=87bc41cae23d2144
dashboard link: https://syzkaller.appspot.com/bug?extid=df0b387708573ad096ce
compiler:       gcc (Debian 12.2.0-14+deb12u1) 12.2.0, GNU ld (GNU Binutils for Debian) 2.40
syz repro:      https://syzkaller.appspot.com/x/repro.syz?x=147ef99a580000
C reproducer:   https://syzkaller.appspot.com/x/repro.c?x=109655fa580000

Downloadable assets:
disk image: https://storage.googleapis.com/syzbot-assets/23b084ff7602/disk-b5434592.raw.xz
vmlinux: https://storage.googleapis.com/syzbot-assets/3ecd3b0e8e34/vmlinux-b5434592.xz
kernel image: https://storage.googleapis.com/syzbot-assets/b42ab3574030/bzImage-b5434592.xz

IMPORTANT: if you fix the issue, please add the following tag to the commit:
Reported-by: syzbot+df0b387708573ad096ce@syzkaller.appspotmail.com

BUG: memory leak
unreferenced object 0xffff88812944f000 (size 4096):
  comm "syz.3.20", pid 6138, jiffies 4294947163
  hex dump (first 32 bytes):
    40 02 00 00 00 20 00 00 03 00 00 00 00 00 00 00  @.... ..........
    00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00  ................
  backtrace (crc 8ab58d7d):
    kmemleak_alloc_recursive include/linux/kmemleak.h:44 [inline]
    slab_post_alloc_hook mm/slub.c:4958 [inline]
    slab_alloc_node mm/slub.c:5263 [inline]
    __do_kmalloc_node mm/slub.c:5656 [inline]
    __kmalloc_noprof+0x3e0/0x660 mm/slub.c:5669
    kmalloc_noprof include/linux/slab.h:961 [inline]
    kmalloc_array_noprof include/linux/slab.h:1003 [inline]
    iovec_from_user lib/iov_iter.c:1321 [inline]
    iovec_from_user+0x108/0x140 lib/iov_iter.c:1304
    __import_iovec+0x71/0x350 lib/iov_iter.c:1375
    io_import_vec io_uring/rw.c:99 [inline]
    __io_import_rw_buffer+0x1e2/0x260 io_uring/rw.c:120
    io_import_rw_buffer io_uring/rw.c:139 [inline]
    io_rw_do_import io_uring/rw.c:313 [inline]
    io_prep_rw+0xb5/0x120 io_uring/rw.c:325
    io_prep_rwv io_uring/rw.c:343 [inline]
    io_prep_writev+0x23/0x80 io_uring/rw.c:363
    io_init_req io_uring/io_uring.c:2235 [inline]
    io_submit_sqe io_uring/io_uring.c:2282 [inline]
    io_submit_sqes+0x40d/0xf40 io_uring/io_uring.c:2435
    __do_sys_io_uring_enter+0x841/0xcf0 io_uring/io_uring.c:3285
    do_syscall_x64 arch/x86/entry/syscall_64.c:63 [inline]
    do_syscall_64+0xa4/0xf80 arch/x86/entry/syscall_64.c:94
    entry_SYSCALL_64_after_hwframe+0x77/0x7f

BUG: memory leak
unreferenced object 0xffff888129450000 (size 4096):
  comm "syz.3.20", pid 6138, jiffies 4294947163
  hex dump (first 32 bytes):
    40 02 00 00 00 20 00 00 03 00 00 00 00 00 00 00  @.... ..........
    00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00  ................
  backtrace (crc 8ab58d7d):
    kmemleak_alloc_recursive include/linux/kmemleak.h:44 [inline]
    slab_post_alloc_hook mm/slub.c:4958 [inline]
    slab_alloc_node mm/slub.c:5263 [inline]
    __do_kmalloc_node mm/slub.c:5656 [inline]
    __kmalloc_noprof+0x3e0/0x660 mm/slub.c:5669
    kmalloc_noprof include/linux/slab.h:961 [inline]
    kmalloc_array_noprof include/linux/slab.h:1003 [inline]
    iovec_from_user lib/iov_iter.c:1321 [inline]
    iovec_from_user+0x108/0x140 lib/iov_iter.c:1304
    __import_iovec+0x71/0x350 lib/iov_iter.c:1375
    io_import_vec io_uring/rw.c:99 [inline]
    __io_import_rw_buffer+0x1e2/0x260 io_uring/rw.c:120
    io_import_rw_buffer io_uring/rw.c:139 [inline]
    io_rw_do_import io_uring/rw.c:313 [inline]
    io_prep_rw+0xb5/0x120 io_uring/rw.c:325
    io_prep_rwv io_uring/rw.c:343 [inline]
    io_prep_writev+0x23/0x80 io_uring/rw.c:363
    io_init_req io_uring/io_uring.c:2235 [inline]
    io_submit_sqe io_uring/io_uring.c:2282 [inline]
    io_submit_sqes+0x40d/0xf40 io_uring/io_uring.c:2435
    __do_sys_io_uring_enter+0x841/0xcf0 io_uring/io_uring.c:3285
    do_syscall_x64 arch/x86/entry/syscall_64.c:63 [inline]
    do_syscall_64+0xa4/0xf80 arch/x86/entry/syscall_64.c:94
    entry_SYSCALL_64_after_hwframe+0x77/0x7f

BUG: memory leak
unreferenced object 0xffff888129451000 (size 4096):
  comm "syz.3.20", pid 6138, jiffies 4294947163
  hex dump (first 32 bytes):
    40 02 00 00 00 20 00 00 03 00 00 00 00 00 00 00  @.... ..........
    00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00  ................
  backtrace (crc 8ab58d7d):
    kmemleak_alloc_recursive include/linux/kmemleak.h:44 [inline]
    slab_post_alloc_hook mm/slub.c:4958 [inline]
    slab_alloc_node mm/slub.c:5263 [inline]
    __do_kmalloc_node mm/slub.c:5656 [inline]
    __kmalloc_noprof+0x3e0/0x660 mm/slub.c:5669
    kmalloc_noprof include/linux/slab.h:961 [inline]
    kmalloc_array_noprof include/linux/slab.h:1003 [inline]
    iovec_from_user lib/iov_iter.c:1321 [inline]
    iovec_from_user+0x108/0x140 lib/iov_iter.c:1304
    __import_iovec+0x71/0x350 lib/iov_iter.c:1375
    io_import_vec io_uring/rw.c:99 [inline]
    __io_import_rw_buffer+0x1e2/0x260 io_uring/rw.c:120
    io_import_rw_buffer io_uring/rw.c:139 [inline]
    io_rw_do_import io_uring/rw.c:313 [inline]
    io_prep_rw+0xb5/0x120 io_uring/rw.c:325
    io_prep_rwv io_uring/rw.c:343 [inline]
    io_prep_writev+0x23/0x80 io_uring/rw.c:363
    io_init_req io_uring/io_uring.c:2235 [inline]
    io_submit_sqe io_uring/io_uring.c:2282 [inline]
    io_submit_sqes+0x40d/0xf40 io_uring/io_uring.c:2435
    __do_sys_io_uring_enter+0x841/0xcf0 io_uring/io_uring.c:3285
    do_syscall_x64 arch/x86/entry/syscall_64.c:63 [inline]
    do_syscall_64+0xa4/0xf80 arch/x86/entry/syscall_64.c:94
    entry_SYSCALL_64_after_hwframe+0x77/0x7f

BUG: memory leak
unreferenced object 0xffff888129453000 (size 4096):
  comm "syz.3.20", pid 6138, jiffies 4294947164
  hex dump (first 32 bytes):
    40 02 00 00 00 20 00 00 03 00 00 00 00 00 00 00  @.... ..........
    00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00  ................
  backtrace (crc 8ab58d7d):
    kmemleak_alloc_recursive include/linux/kmemleak.h:44 [inline]
    slab_post_alloc_hook mm/slub.c:4958 [inline]
    slab_alloc_node mm/slub.c:5263 [inline]
    __do_kmalloc_node mm/slub.c:5656 [inline]
    __kmalloc_noprof+0x3e0/0x660 mm/slub.c:5669
    kmalloc_noprof include/linux/slab.h:961 [inline]
    kmalloc_array_noprof include/linux/slab.h:1003 [inline]
    iovec_from_user lib/iov_iter.c:1321 [inline]
    iovec_from_user+0x108/0x140 lib/iov_iter.c:1304
    __import_iovec+0x71/0x350 lib/iov_iter.c:1375
    io_import_vec io_uring/rw.c:99 [inline]
    __io_import_rw_buffer+0x1e2/0x260 io_uring/rw.c:120
    io_import_rw_buffer io_uring/rw.c:139 [inline]
    io_rw_do_import io_uring/rw.c:313 [inline]
    io_prep_rw+0xb5/0x120 io_uring/rw.c:325
    io_prep_rwv io_uring/rw.c:343 [inline]
    io_prep_writev+0x23/0x80 io_uring/rw.c:363
    io_init_req io_uring/io_uring.c:2235 [inline]
    io_submit_sqe io_uring/io_uring.c:2282 [inline]
    io_submit_sqes+0x40d/0xf40 io_uring/io_uring.c:2435
    __do_sys_io_uring_enter+0x841/0xcf0 io_uring/io_uring.c:3285
    do_syscall_x64 arch/x86/entry/syscall_64.c:63 [inline]
    do_syscall_64+0xa4/0xf80 arch/x86/entry/syscall_64.c:94
    entry_SYSCALL_64_after_hwframe+0x77/0x7f

BUG: memory leak
unreferenced object 0xffff888129452000 (size 4096):
  comm "syz.3.20", pid 6138, jiffies 4294947164
  hex dump (first 32 bytes):
    40 02 00 00 00 20 00 00 03 00 00 00 00 00 00 00  @.... ..........
    00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00  ................
  backtrace (crc 8ab58d7d):
    kmemleak_alloc_recursive include/linux/kmemleak.h:44 [inline]
    slab_post_alloc_hook mm/slub.c:4958 [inline]
    slab_alloc_node mm/slub.c:5263 [inline]
    __do_kmalloc_node mm/slub.c:5656 [inline]
    __kmalloc_noprof+0x3e0/0x660 mm/slub.c:5669
    kmalloc_noprof include/linux/slab.h:961 [inline]
    kmalloc_array_noprof include/linux/slab.h:1003 [inline]
    iovec_from_user lib/iov_iter.c:1321 [inline]
    iovec_from_user+0x108/0x140 lib/iov_iter.c:1304
    __import_iovec+0x71/0x350 lib/iov_iter.c:1375
    io_import_vec io_uring/rw.c:99 [inline]
    __io_import_rw_buffer+0x1e2/0x260 io_uring/rw.c:120
    io_import_rw_buffer io_uring/rw.c:139 [inline]
    io_rw_do_import io_uring/rw.c:313 [inline]
    io_prep_rw+0xb5/0x120 io_uring/rw.c:325
    io_prep_rwv io_uring/rw.c:343 [inline]
    io_prep_writev+0x23/0x80 io_uring/rw.c:363
    io_init_req io_uring/io_uring.c:2235 [inline]
    io_submit_sqe io_uring/io_uring.c:2282 [inline]
    io_submit_sqes+0x40d/0xf40 io_uring/io_uring.c:2435
    __do_sys_io_uring_enter+0x841/0xcf0 io_uring/io_uring.c:3285
    do_syscall_x64 arch/x86/entry/syscall_64.c:63 [inline]
    do_syscall_64+0xa4/0xf80 arch/x86/entry/syscall_64.c:94
    entry_SYSCALL_64_after_hwframe+0x77/0x7f

BUG: memory leak
unreferenced object 0xffff888129454000 (size 4096):
  comm "syz.3.20", pid 6138, jiffies 4294947164
  hex dump (first 32 bytes):
    40 02 00 00 00 20 00 00 03 00 00 00 00 00 00 00  @.... ..........
    00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00  ................
  backtrace (crc 8ab58d7d):
    kmemleak_alloc_recursive include/linux/kmemleak.h:44 [inline]
    slab_post_alloc_hook mm/slub.c:4958 [inline]
    slab_alloc_node mm/slub.c:5263 [inline]
    __do_kmalloc_node mm/slub.c:5656 [inline]
    __kmalloc_noprof+0x3e0/0x660 mm/slub.c:5669
    kmalloc_noprof include/linux/slab.h:961 [inline]
    kmalloc_array_noprof include/linux/slab.h:1003 [inline]
    iovec_from_user lib/iov_iter.c:1321 [inline]
    iovec_from_user+0x108/0x140 lib/iov_iter.c:1304
    __import_iovec+0x71/0x350 lib/iov_iter.c:1375
    io_import_vec io_uring/rw.c:99 [inline]
    __io_import_rw_buffer+0x1e2/0x260 io_uring/rw.c:120
    io_import_rw_buffer io_uring/rw.c:139 [inline]
    io_rw_do_import io_uring/rw.c:313 [inline]
    io_prep_rw+0xb5/0x120 io_uring/rw.c:325
    io_prep_rwv io_uring/rw.c:343 [inline]
    io_prep_writev+0x23/0x80 io_uring/rw.c:363
    io_init_req io_uring/io_uring.c:2235 [inline]
    io_submit_sqe io_uring/io_uring.c:2282 [inline]
    io_submit_sqes+0x40d/0xf40 io_uring/io_uring.c:2435
    __do_sys_io_uring_enter+0x841/0xcf0 io_uring/io_uring.c:3285
    do_syscall_x64 arch/x86/entry/syscall_64.c:63 [inline]
    do_syscall_64+0xa4/0xf80 arch/x86/entry/syscall_64.c:94
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

