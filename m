Return-Path: <io-uring+bounces-11598-lists+io-uring=lfdr.de@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from sea.lore.kernel.org (sea.lore.kernel.org [IPv6:2600:3c0a:e001:db::12fc:5321])
	by mail.lfdr.de (Postfix) with ESMTPS id B2B36D14C35
	for <lists+io-uring@lfdr.de>; Mon, 12 Jan 2026 19:27:10 +0100 (CET)
Received: from smtp.subspace.kernel.org (conduit.subspace.kernel.org [100.90.174.1])
	by sea.lore.kernel.org (Postfix) with ESMTP id 4927030F84F5
	for <lists+io-uring@lfdr.de>; Mon, 12 Jan 2026 18:23:29 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 2A506387583;
	Mon, 12 Jan 2026 18:23:29 +0000 (UTC)
X-Original-To: io-uring@vger.kernel.org
Received: from mail-oo1-f79.google.com (mail-oo1-f79.google.com [209.85.161.79])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2E27738758F
	for <io-uring@vger.kernel.org>; Mon, 12 Jan 2026 18:23:27 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.161.79
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1768242209; cv=none; b=iM6Tho9lmF3fTRGY8vHtwo+CMMoE7JvGrddVfPJ0mBIarm9f00EBEt5bX953fbzlzZO6CaaycHFmDPIOznpMgmlRN1fujNHB398zmzUr9KgCBIP0Uyzqp9Hhlr7aVMSAXcqaJbbsnNpCqhfb6MwkCSDcP2eJA8EhpqpKSawr5+Q=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1768242209; c=relaxed/simple;
	bh=NKc60VV6Y6KQXqKhe2dVn8AmFGpT3zNKXgcTtZqfLSM=;
	h=MIME-Version:Date:Message-ID:Subject:From:To:Content-Type; b=Ur/VaSlUPwUP52sb4r9H15aWTywTd0ZpBVXDWh4vPR89UdnUUP87g885m0cICLN5ZRSXZCXRPf+UhisI2Q3RLxoaljCPT6CAtw+/187R1sow5yssLCiaypKpLbM8yTjgRX0JDV2dVxSOidjWALXKFVCzjvaNL2zjtubHE5zESuo=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=fail (p=none dis=none) header.from=syzkaller.appspotmail.com; spf=pass smtp.mailfrom=M3KW2WVRGUFZ5GODRSRYTGD7.apphosting.bounces.google.com; arc=none smtp.client-ip=209.85.161.79
Authentication-Results: smtp.subspace.kernel.org; dmarc=fail (p=none dis=none) header.from=syzkaller.appspotmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=M3KW2WVRGUFZ5GODRSRYTGD7.apphosting.bounces.google.com
Received: by mail-oo1-f79.google.com with SMTP id 006d021491bc7-65f66b8be64so10509887eaf.3
        for <io-uring@vger.kernel.org>; Mon, 12 Jan 2026 10:23:26 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1768242206; x=1768847006;
        h=to:from:subject:message-id:date:mime-version:x-gm-message-state
         :from:to:cc:subject:date:message-id:reply-to;
        bh=uLkesU3YZLlsC+BrLqYDYZfJucrTl1D8m8F/idS9gUU=;
        b=WeR1qS7jfe5KARxGrMFZ+zXvz8vHwET819+6m9cFNIwDQWa8XdOAcBsTYjDDaHQetT
         W7ufN2z85ASlnqMw9dIuB8JMVr9SoqEbiU/vrrDI7+5q7hEADqRO9uirH1PYBeW3MeMI
         phgfOe6WYeJaR2zYcCbcM+k+tNevy6FnXHq44IKnOgm6WuxWxuLnnTc6E9f2Elw95uAH
         qlVokRCy5AlHfgs5qutjdf6a50bDziJHtotQd+rGEJrQjtN+BuZV0rhzM3/8SFeWdJ8T
         WPTp2Lg3olWnlMGL0VV1FcRrHszCrze27UWdW8WJC5WLPon7nvNFLCUvtywthx3o4Gwa
         Js3A==
X-Forwarded-Encrypted: i=1; AJvYcCXC5UnjwpgFRu5oNQEgehf7LpOAzMckUG0P9TlLgVf69yVNFx9mYPYy28MbfpcVZ2/IZXcjKO6PQg==@vger.kernel.org
X-Gm-Message-State: AOJu0YyBLqmt6wARsS0LsLOkNLwau/ZFkpilDP3r1OjB2ykbqxgzx8OD
	HmBlus0JJDvW/TPjQEYoKDaxJ8OsZ86VfQfTlXnNQ+1OZP452jYJGtbmhlrpgFkLGVeBV6nNCIQ
	MsjAYj9y26OLEiAfpBJA2PEh7gFPoFmlDIgSGo1NJ+6Fg8bWfUGIUevudl0g=
X-Google-Smtp-Source: AGHT+IH7N5gZdQT0n3iJFEtwHN4Re40MJnyMFiqPwHA5ucUVNirjfaTHVe4hlEKafcxbVLNoyZcpQT2FDlUk29S8rZfsbPxf5yxY
Precedence: bulk
X-Mailing-List: io-uring@vger.kernel.org
List-Id: <io-uring.vger.kernel.org>
List-Subscribe: <mailto:io-uring+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:io-uring+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-Received: by 2002:a05:6820:228f:b0:659:9a49:8f93 with SMTP id
 006d021491bc7-65f54eea37dmr9029240eaf.12.1768242206242; Mon, 12 Jan 2026
 10:23:26 -0800 (PST)
Date: Mon, 12 Jan 2026 10:23:26 -0800
X-Google-Appengine-App-Id: s~syzkaller
X-Google-Appengine-App-Id-Alias: syzkaller
Message-ID: <69653c1e.050a0220.eaf7.00c9.GAE@google.com>
Subject: [syzbot] [io-uring?] memory leak in iovec_from_user (3)
From: syzbot <syzbot+abecd272a5e56fcef099@syzkaller.appspotmail.com>
To: axboe@kernel.dk, io-uring@vger.kernel.org, linux-kernel@vger.kernel.org, 
	syzkaller-bugs@googlegroups.com
Content-Type: text/plain; charset="UTF-8"

Hello,

syzbot found the following issue on:

HEAD commit:    7143203341dc Merge tag 'libcrypto-for-linus' of git://git...
git tree:       upstream
console output: https://syzkaller.appspot.com/x/log.txt?x=177fd9fc580000
kernel config:  https://syzkaller.appspot.com/x/.config?x=87bc41cae23d2144
dashboard link: https://syzkaller.appspot.com/bug?extid=abecd272a5e56fcef099
compiler:       gcc (Debian 12.2.0-14+deb12u1) 12.2.0, GNU ld (GNU Binutils for Debian) 2.40
syz repro:      https://syzkaller.appspot.com/x/repro.syz?x=12f4399a580000
C reproducer:   https://syzkaller.appspot.com/x/repro.c?x=11ab3c3a580000

Downloadable assets:
disk image: https://storage.googleapis.com/syzbot-assets/1efe18c6d01c/disk-71432033.raw.xz
vmlinux: https://storage.googleapis.com/syzbot-assets/a5a0b8a88b2b/vmlinux-71432033.xz
kernel image: https://storage.googleapis.com/syzbot-assets/5bd4c64b0a42/bzImage-71432033.xz

IMPORTANT: if you fix the issue, please add the following tag to the commit:
Reported-by: syzbot+abecd272a5e56fcef099@syzkaller.appspotmail.com

BUG: memory leak
unreferenced object 0xffff88811213f000 (size 4096):
  comm "syz.0.17", pid 6076, jiffies 4294944113
  hex dump (first 32 bytes):
    40 02 00 00 00 20 00 00 03 00 00 00 00 00 00 00  @.... ..........
    00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00  ................
  backtrace (crc 5845df99):
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
unreferenced object 0xffff888112158000 (size 4096):
  comm "syz.0.17", pid 6076, jiffies 4294944113
  hex dump (first 32 bytes):
    40 02 00 00 00 20 00 00 03 00 00 00 00 00 00 00  @.... ..........
    00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00  ................
  backtrace (crc 5845df99):
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
unreferenced object 0xffff888112159000 (size 4096):
  comm "syz.0.17", pid 6076, jiffies 4294944113
  hex dump (first 32 bytes):
    40 02 00 00 00 20 00 00 03 00 00 00 00 00 00 00  @.... ..........
    00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00  ................
  backtrace (crc 5845df99):
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
unreferenced object 0xffff88811215a000 (size 4096):
  comm "syz.0.17", pid 6076, jiffies 4294944113
  hex dump (first 32 bytes):
    40 02 00 00 00 20 00 00 03 00 00 00 00 00 00 00  @.... ..........
    00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00  ................
  backtrace (crc 5845df99):
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
unreferenced object 0xffff88811215b000 (size 4096):
  comm "syz.0.17", pid 6076, jiffies 4294944113
  hex dump (first 32 bytes):
    40 02 00 00 00 20 00 00 03 00 00 00 00 00 00 00  @.... ..........
    00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00  ................
  backtrace (crc 5845df99):
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
unreferenced object 0xffff88811215c000 (size 4096):
  comm "syz.0.17", pid 6076, jiffies 4294944113
  hex dump (first 32 bytes):
    40 02 00 00 00 20 00 00 03 00 00 00 00 00 00 00  @.... ..........
    00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00  ................
  backtrace (crc 5845df99):
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

