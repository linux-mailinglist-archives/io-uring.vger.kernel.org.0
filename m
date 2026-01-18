Return-Path: <io-uring+bounces-11805-lists+io-uring=lfdr.de@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from sto.lore.kernel.org (sto.lore.kernel.org [172.232.135.74])
	by mail.lfdr.de (Postfix) with ESMTPS id 0A7BED39938
	for <lists+io-uring@lfdr.de>; Sun, 18 Jan 2026 19:41:27 +0100 (CET)
Received: from smtp.subspace.kernel.org (conduit.subspace.kernel.org [100.90.174.1])
	by sto.lore.kernel.org (Postfix) with ESMTP id 58C4C3001194
	for <lists+io-uring@lfdr.de>; Sun, 18 Jan 2026 18:41:26 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 5664B2FD696;
	Sun, 18 Jan 2026 18:41:25 +0000 (UTC)
X-Original-To: io-uring@vger.kernel.org
Received: from mail-oa1-f78.google.com (mail-oa1-f78.google.com [209.85.160.78])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 862B1238C3B
	for <io-uring@vger.kernel.org>; Sun, 18 Jan 2026 18:41:23 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.160.78
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1768761685; cv=none; b=Q7qlrbARhSoDR44NEluM2uXaHWL/V8HpzdKgQypKiWk0OYvUwziWwID7oMBPn8XKDQjsvCZ+fH/vOLevAtdd0Chi/WLJ92JOE19DXq9WKlnj0/x4xoOF3H5MYWt1sMq4I5gkascVSeR4RYnbntEBnoCordPOBxNKcRCtSRiJLdc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1768761685; c=relaxed/simple;
	bh=I7iePBh2SQ0RavDDcD8KaZaul1MRqqVGVuwE5ADaffE=;
	h=MIME-Version:Date:Message-ID:Subject:From:To:Content-Type; b=mU+feISEdvqZ7NtQeSPKfVla7PqkzdI3zCuVsDbnhvBil49Vxepcqax8bueEXbRTDKlShylt7XjMnThmYL8ic0mou8qP02kSBmoBLs+rjoXUDp97G+MNk8q2m8e1on1gXZ0cvJWVzwE7Fkyx18o3osr0XURw7D8CBx14vpCF2Gw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=fail (p=none dis=none) header.from=syzkaller.appspotmail.com; spf=pass smtp.mailfrom=M3KW2WVRGUFZ5GODRSRYTGD7.apphosting.bounces.google.com; arc=none smtp.client-ip=209.85.160.78
Authentication-Results: smtp.subspace.kernel.org; dmarc=fail (p=none dis=none) header.from=syzkaller.appspotmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=M3KW2WVRGUFZ5GODRSRYTGD7.apphosting.bounces.google.com
Received: by mail-oa1-f78.google.com with SMTP id 586e51a60fabf-4041710f90fso8460778fac.2
        for <io-uring@vger.kernel.org>; Sun, 18 Jan 2026 10:41:23 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1768761682; x=1769366482;
        h=to:from:subject:message-id:date:mime-version:x-gm-message-state
         :from:to:cc:subject:date:message-id:reply-to;
        bh=Dsslg/pUyrpiQ11DKu+WpYdoK031UpWJOq7zroR3xpY=;
        b=isiQ085Vzew2jzzK07ak7bASEKoUx0ZZmSBEKmmzGGZEeBc4eATygSwhu7gqYt8xyj
         kEW39W2+9bsfHqnTfipxTZmJ7q4Ws/WJTARAp68Z5fa2/XjLWU63COzWvLtYHfIxmItQ
         syRy/HlzIy/yn2DZXo8XqEeVkcxolMqibxGlNfqdQbM94FFlJRE+yECnwNEqe6BodBb+
         4t1VYaLiYzzFa8eoY5pnOywoNN1BSHARjHBABJ0ZZI+Yn69onowiQMoehFicUJrkVHKt
         Wmq3NzXEdeMrwb3mFXIZyU8s8N3LEo0QIGcMjFxMsPMSt+37r8sOY2aXGSLxOfDnsF7r
         0Sww==
X-Forwarded-Encrypted: i=1; AJvYcCXx5ek4PnOJ2+mctNXaJWQe9+MV7rYoRK8yJt+CmapjTks/X1GfxWXyUo/xFsaof2Pys52yWV8XBA==@vger.kernel.org
X-Gm-Message-State: AOJu0YzH0F1wZI8nJhy7f8nuFcwjdbL+eJf3vVnERcmDT7ARPQqs+XDE
	QGKSEswq2bQrGv5xfjZAtQtJms/Ly/bNMahKtjX66QLgAbMP6Vk0y2xX/ooJ48ky5DfrCPKJpAN
	wcijIT09dw9YIdGlAOq5UU+M6jxvZCWAK3QW2FjZYo+nBfhtlK4Q65TLlMoI=
Precedence: bulk
X-Mailing-List: io-uring@vger.kernel.org
List-Id: <io-uring.vger.kernel.org>
List-Subscribe: <mailto:io-uring+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:io-uring+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-Received: by 2002:a05:6820:612:b0:65d:be3:3116 with SMTP id
 006d021491bc7-6611796f301mr3681973eaf.32.1768761682421; Sun, 18 Jan 2026
 10:41:22 -0800 (PST)
Date: Sun, 18 Jan 2026 10:41:22 -0800
X-Google-Appengine-App-Id: s~syzkaller
X-Google-Appengine-App-Id-Alias: syzkaller
Message-ID: <696d2952.050a0220.3390f1.0022.GAE@google.com>
Subject: [syzbot] [io-uring?] memory leak in iovec_from_user (5)
From: syzbot <syzbot+321914d39d7553cca1e7@syzkaller.appspotmail.com>
To: axboe@kernel.dk, io-uring@vger.kernel.org, linux-kernel@vger.kernel.org, 
	syzkaller-bugs@googlegroups.com
Content-Type: text/plain; charset="UTF-8"

Hello,

syzbot found the following issue on:

HEAD commit:    c537e12daeec Merge tag 'bpf-fixes' of git://git.kernel.org..
git tree:       upstream
console output: https://syzkaller.appspot.com/x/log.txt?x=17c91d9a580000
kernel config:  https://syzkaller.appspot.com/x/.config?x=87bc41cae23d2144
dashboard link: https://syzkaller.appspot.com/bug?extid=321914d39d7553cca1e7
compiler:       gcc (Debian 12.2.0-14+deb12u1) 12.2.0, GNU ld (GNU Binutils for Debian) 2.40
syz repro:      https://syzkaller.appspot.com/x/repro.syz?x=16a8d5fa580000

Downloadable assets:
disk image: https://storage.googleapis.com/syzbot-assets/b4f60c3c9800/disk-c537e12d.raw.xz
vmlinux: https://storage.googleapis.com/syzbot-assets/5f2c0a541579/vmlinux-c537e12d.xz
kernel image: https://storage.googleapis.com/syzbot-assets/32dcd74ba443/bzImage-c537e12d.xz

IMPORTANT: if you fix the issue, please add the following tag to the commit:
Reported-by: syzbot+321914d39d7553cca1e7@syzkaller.appspotmail.com

BUG: memory leak
unreferenced object 0xffff8881228893e0 (size 32):
  comm "syz.6.23", pid 6169, jiffies 4294942659
  hex dump (first 32 bytes):
    00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00  ................
    00 00 00 00 00 00 00 00 01 00 00 00 00 00 00 00  ................
  backtrace (crc ccaa009e):
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
unreferenced object 0xffff888122889400 (size 32):
  comm "syz.6.23", pid 6169, jiffies 4294942659
  hex dump (first 32 bytes):
    00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00  ................
    00 00 00 00 00 00 00 00 01 00 00 00 00 00 00 00  ................
  backtrace (crc ccaa009e):
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
unreferenced object 0xffff888122889420 (size 32):
  comm "syz.6.23", pid 6169, jiffies 4294942659
  hex dump (first 32 bytes):
    00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00  ................
    00 00 00 00 00 00 00 00 01 00 00 00 00 00 00 00  ................
  backtrace (crc ccaa009e):
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
unreferenced object 0xffff888122889440 (size 32):
  comm "syz.6.23", pid 6169, jiffies 4294942659
  hex dump (first 32 bytes):
    00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00  ................
    00 00 00 00 00 00 00 00 01 00 00 00 00 00 00 00  ................
  backtrace (crc ccaa009e):
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
unreferenced object 0xffff888122889460 (size 32):
  comm "syz.6.23", pid 6169, jiffies 4294942659
  hex dump (first 32 bytes):
    00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00  ................
    00 00 00 00 00 00 00 00 01 00 00 00 00 00 00 00  ................
  backtrace (crc ccaa009e):
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
unreferenced object 0xffff888122889480 (size 32):
  comm "syz.6.23", pid 6169, jiffies 4294942659
  hex dump (first 32 bytes):
    00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00  ................
    00 00 00 00 00 00 00 00 01 00 00 00 00 00 00 00  ................
  backtrace (crc ccaa009e):
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

