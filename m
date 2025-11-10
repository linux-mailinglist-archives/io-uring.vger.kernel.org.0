Return-Path: <io-uring+bounces-10502-lists+io-uring=lfdr.de@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from dfw.mirrors.kernel.org (dfw.mirrors.kernel.org [IPv6:2605:f480:58:1:0:1994:3:14])
	by mail.lfdr.de (Postfix) with ESMTPS id 2B535C487DA
	for <lists+io-uring@lfdr.de>; Mon, 10 Nov 2025 19:10:44 +0100 (CET)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by dfw.mirrors.kernel.org (Postfix) with ESMTPS id 1DF2B4EDE59
	for <lists+io-uring@lfdr.de>; Mon, 10 Nov 2025 18:10:27 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id E73A63128C8;
	Mon, 10 Nov 2025 18:09:32 +0000 (UTC)
X-Original-To: io-uring@vger.kernel.org
Received: from mail-io1-f79.google.com (mail-io1-f79.google.com [209.85.166.79])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id CD613314B80
	for <io-uring@vger.kernel.org>; Mon, 10 Nov 2025 18:09:30 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.166.79
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1762798172; cv=none; b=Bya7seFvxs5n79bSUAhkWdVIprDB0g8n8dvf+2CdMrmVxeCoSJPKL1jrSeGCjNtUMPV2Xh6nVABF+XVACilbSbDXEvDpUBnZKIhAjM+r9czCYmEObTnnIM9ZQGzwU5QcfOPrvN2KluccXBEr21oVIS55VJvLkI80bErlbp+KyO4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1762798172; c=relaxed/simple;
	bh=BX+nAeNIF1g3TkXSjB13OGmoZFqYiahZuRo5NBB2WaM=;
	h=MIME-Version:Date:Message-ID:Subject:From:To:Content-Type; b=NqulD0dcTvlDbFhwVRjhS3J04YS+jehsDl8eFcqhQFiYjuX8wXT6c2drR0ePstTmZjECnhscwS3Y6yil5pcKKPtAuQiMdMPfuQNqjpc0RQEaaj8DcAC3M1ZzHSweRU2vE9SvkRUXb9xCgCEFZwVL1QeHztds69SYzwkOv5/piRE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=fail (p=none dis=none) header.from=syzkaller.appspotmail.com; spf=pass smtp.mailfrom=M3KW2WVRGUFZ5GODRSRYTGD7.apphosting.bounces.google.com; arc=none smtp.client-ip=209.85.166.79
Authentication-Results: smtp.subspace.kernel.org; dmarc=fail (p=none dis=none) header.from=syzkaller.appspotmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=M3KW2WVRGUFZ5GODRSRYTGD7.apphosting.bounces.google.com
Received: by mail-io1-f79.google.com with SMTP id ca18e2360f4ac-9489c73d908so173526739f.2
        for <io-uring@vger.kernel.org>; Mon, 10 Nov 2025 10:09:30 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1762798170; x=1763402970;
        h=to:from:subject:message-id:date:mime-version:x-gm-message-state
         :from:to:cc:subject:date:message-id:reply-to;
        bh=/ksrKuOU5FPJxqYEVZzmca7yyxRXUq9NtK9oQxoK79g=;
        b=Geeium/FCQb0NNPXp+AD62SNU9u5gPzXdzUsa4Hii7sUf8kl5iYqw/uKh+oAT0qpyu
         S+Np3N4x2gADTy/widoRwrP7+3E30k7ZoiuzvxS1Nz9bmhAvhLLClpzY8F7KvlRPXDEm
         rZAl/z3kw/Sp6zoKG7hsG2/wDN7OcPwVItHBJ2++pd/oW54wUHuCuWaETyCpnrk1gIsz
         QrE6xKxX7yhNN9u7JICUgV03bEIgd2zGGDle0UInzoYX0vrcM1PPTj2BtbUCohIElYLW
         HXrvPGjDsSxuoc6FwmLCWSfmG/a4UKfqsRUbp75BQy7QCniAbNfUE+uTNEalOmBc1WPI
         5vBg==
X-Forwarded-Encrypted: i=1; AJvYcCW8LMyqg9PafZRXUybCS0okT16rFtBsQInX2ZWFncx4Gxf9l/zsJ8W0sLXDS2DU2bnyKnxofyD5fw==@vger.kernel.org
X-Gm-Message-State: AOJu0Yw9hfLFJ1kEuDR44AgvHg8+Fsv0+TLLThXLc9ArGvrzewpH59Qi
	bVfmp08J4zLexwYcNyLK0hEfrj+bmEy8VU0UVyZod3z+th3BlXmazE/E6dFTa3ro7ZNr6sIuYLB
	oG9S80vYEK7wB0Tdnk8qPoabQ5fifEXLgoDasK0esFQbJ+3KZ0AobfsznLg4=
X-Google-Smtp-Source: AGHT+IFDAoztbnvC9n21uInqFfDm51VC2VSaReCQ3ut32Mn+MW31DvE+zso0ifMwNhvWq9U8Fzv5vQPmG2XZgs5LeBvcFUDXrRVw
Precedence: bulk
X-Mailing-List: io-uring@vger.kernel.org
List-Id: <io-uring.vger.kernel.org>
List-Subscribe: <mailto:io-uring+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:io-uring+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-Received: by 2002:a05:6e02:1a82:b0:433:7673:1d with SMTP id
 e9e14a558f8ab-43376730369mr95532205ab.31.1762798169947; Mon, 10 Nov 2025
 10:09:29 -0800 (PST)
Date: Mon, 10 Nov 2025 10:09:29 -0800
X-Google-Appengine-App-Id: s~syzkaller
X-Google-Appengine-App-Id-Alias: syzkaller
Message-ID: <69122a59.a70a0220.22f260.00fd.GAE@google.com>
Subject: [syzbot] [io-uring?] memory leak in iovec_from_user (2)
From: syzbot <syzbot+3c93637d7648c24e1fd0@syzkaller.appspotmail.com>
To: axboe@kernel.dk, io-uring@vger.kernel.org, linux-kernel@vger.kernel.org, 
	syzkaller-bugs@googlegroups.com
Content-Type: text/plain; charset="UTF-8"

Hello,

syzbot found the following issue on:

HEAD commit:    4a0c9b339199 Merge tag 'probes-fixes-v6.18-rc4' of git://g..
git tree:       upstream
console output: https://syzkaller.appspot.com/x/log.txt?x=12af5342580000
kernel config:  https://syzkaller.appspot.com/x/.config?x=cb128cd5cb439809
dashboard link: https://syzkaller.appspot.com/bug?extid=3c93637d7648c24e1fd0
compiler:       gcc (Debian 12.2.0-14+deb12u1) 12.2.0, GNU ld (GNU Binutils for Debian) 2.40
syz repro:      https://syzkaller.appspot.com/x/repro.syz?x=16af5342580000
C reproducer:   https://syzkaller.appspot.com/x/repro.c?x=13664412580000

Downloadable assets:
disk image: https://storage.googleapis.com/syzbot-assets/bfd02a09ef4d/disk-4a0c9b33.raw.xz
vmlinux: https://storage.googleapis.com/syzbot-assets/ed9a1334f973/vmlinux-4a0c9b33.xz
kernel image: https://storage.googleapis.com/syzbot-assets/e503329437ee/bzImage-4a0c9b33.xz

IMPORTANT: if you fix the issue, please add the following tag to the commit:
Reported-by: syzbot+3c93637d7648c24e1fd0@syzkaller.appspotmail.com

BUG: memory leak
unreferenced object 0xffff88812638cc20 (size 32):
  comm "syz.0.17", pid 6104, jiffies 4294942640
  hex dump (first 32 bytes):
    00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00  ................
    00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00  ................
  backtrace (crc 0):
    kmemleak_alloc_recursive include/linux/kmemleak.h:44 [inline]
    slab_post_alloc_hook mm/slub.c:4975 [inline]
    slab_alloc_node mm/slub.c:5280 [inline]
    __do_kmalloc_node mm/slub.c:5641 [inline]
    __kmalloc_noprof+0x3e3/0x6b0 mm/slub.c:5654
    kmalloc_noprof include/linux/slab.h:961 [inline]
    kmalloc_array_noprof include/linux/slab.h:1003 [inline]
    iovec_from_user lib/iov_iter.c:1309 [inline]
    iovec_from_user+0x108/0x140 lib/iov_iter.c:1292
    __import_iovec+0x71/0x350 lib/iov_iter.c:1363
    io_import_vec io_uring/rw.c:99 [inline]
    __io_import_rw_buffer+0x1e2/0x260 io_uring/rw.c:120
    io_import_rw_buffer io_uring/rw.c:139 [inline]
    io_rw_do_import io_uring/rw.c:314 [inline]
    io_prep_rw+0xb5/0x120 io_uring/rw.c:326
    io_prep_rwv io_uring/rw.c:344 [inline]
    io_prep_readv+0x20/0x80 io_uring/rw.c:359
    io_init_req io_uring/io_uring.c:2248 [inline]
    io_submit_sqe io_uring/io_uring.c:2295 [inline]
    io_submit_sqes+0x354/0xe80 io_uring/io_uring.c:2447
    __do_sys_io_uring_enter+0x83f/0xcf0 io_uring/io_uring.c:3514
    do_syscall_x64 arch/x86/entry/syscall_64.c:63 [inline]
    do_syscall_64+0xa4/0xfa0 arch/x86/entry/syscall_64.c:94
    entry_SYSCALL_64_after_hwframe+0x77/0x7f

BUG: memory leak
unreferenced object 0xffff88812638cc40 (size 32):
  comm "syz.0.17", pid 6104, jiffies 4294942640
  hex dump (first 32 bytes):
    00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00  ................
    00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00  ................
  backtrace (crc 0):
    kmemleak_alloc_recursive include/linux/kmemleak.h:44 [inline]
    slab_post_alloc_hook mm/slub.c:4975 [inline]
    slab_alloc_node mm/slub.c:5280 [inline]
    __do_kmalloc_node mm/slub.c:5641 [inline]
    __kmalloc_noprof+0x3e3/0x6b0 mm/slub.c:5654
    kmalloc_noprof include/linux/slab.h:961 [inline]
    kmalloc_array_noprof include/linux/slab.h:1003 [inline]
    iovec_from_user lib/iov_iter.c:1309 [inline]
    iovec_from_user+0x108/0x140 lib/iov_iter.c:1292
    __import_iovec+0x71/0x350 lib/iov_iter.c:1363
    io_import_vec io_uring/rw.c:99 [inline]
    __io_import_rw_buffer+0x1e2/0x260 io_uring/rw.c:120
    io_import_rw_buffer io_uring/rw.c:139 [inline]
    io_rw_do_import io_uring/rw.c:314 [inline]
    io_prep_rw+0xb5/0x120 io_uring/rw.c:326
    io_prep_rwv io_uring/rw.c:344 [inline]
    io_prep_readv+0x20/0x80 io_uring/rw.c:359
    io_init_req io_uring/io_uring.c:2248 [inline]
    io_submit_sqe io_uring/io_uring.c:2295 [inline]
    io_submit_sqes+0x354/0xe80 io_uring/io_uring.c:2447
    __do_sys_io_uring_enter+0x83f/0xcf0 io_uring/io_uring.c:3514
    do_syscall_x64 arch/x86/entry/syscall_64.c:63 [inline]
    do_syscall_64+0xa4/0xfa0 arch/x86/entry/syscall_64.c:94
    entry_SYSCALL_64_after_hwframe+0x77/0x7f

BUG: memory leak
unreferenced object 0xffff88812638cc60 (size 32):
  comm "syz.0.17", pid 6104, jiffies 4294942640
  hex dump (first 32 bytes):
    00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00  ................
    00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00  ................
  backtrace (crc 0):
    kmemleak_alloc_recursive include/linux/kmemleak.h:44 [inline]
    slab_post_alloc_hook mm/slub.c:4975 [inline]
    slab_alloc_node mm/slub.c:5280 [inline]
    __do_kmalloc_node mm/slub.c:5641 [inline]
    __kmalloc_noprof+0x3e3/0x6b0 mm/slub.c:5654
    kmalloc_noprof include/linux/slab.h:961 [inline]
    kmalloc_array_noprof include/linux/slab.h:1003 [inline]
    iovec_from_user lib/iov_iter.c:1309 [inline]
    iovec_from_user+0x108/0x140 lib/iov_iter.c:1292
    __import_iovec+0x71/0x350 lib/iov_iter.c:1363
    io_import_vec io_uring/rw.c:99 [inline]
    __io_import_rw_buffer+0x1e2/0x260 io_uring/rw.c:120
    io_import_rw_buffer io_uring/rw.c:139 [inline]
    io_rw_do_import io_uring/rw.c:314 [inline]
    io_prep_rw+0xb5/0x120 io_uring/rw.c:326
    io_prep_rwv io_uring/rw.c:344 [inline]
    io_prep_readv+0x20/0x80 io_uring/rw.c:359
    io_init_req io_uring/io_uring.c:2248 [inline]
    io_submit_sqe io_uring/io_uring.c:2295 [inline]
    io_submit_sqes+0x354/0xe80 io_uring/io_uring.c:2447
    __do_sys_io_uring_enter+0x83f/0xcf0 io_uring/io_uring.c:3514
    do_syscall_x64 arch/x86/entry/syscall_64.c:63 [inline]
    do_syscall_64+0xa4/0xfa0 arch/x86/entry/syscall_64.c:94
    entry_SYSCALL_64_after_hwframe+0x77/0x7f

BUG: memory leak
unreferenced object 0xffff88812638cc80 (size 32):
  comm "syz.0.17", pid 6104, jiffies 4294942640
  hex dump (first 32 bytes):
    00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00  ................
    00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00  ................
  backtrace (crc 0):
    kmemleak_alloc_recursive include/linux/kmemleak.h:44 [inline]
    slab_post_alloc_hook mm/slub.c:4975 [inline]
    slab_alloc_node mm/slub.c:5280 [inline]
    __do_kmalloc_node mm/slub.c:5641 [inline]
    __kmalloc_noprof+0x3e3/0x6b0 mm/slub.c:5654
    kmalloc_noprof include/linux/slab.h:961 [inline]
    kmalloc_array_noprof include/linux/slab.h:1003 [inline]
    iovec_from_user lib/iov_iter.c:1309 [inline]
    iovec_from_user+0x108/0x140 lib/iov_iter.c:1292
    __import_iovec+0x71/0x350 lib/iov_iter.c:1363
    io_import_vec io_uring/rw.c:99 [inline]
    __io_import_rw_buffer+0x1e2/0x260 io_uring/rw.c:120
    io_import_rw_buffer io_uring/rw.c:139 [inline]
    io_rw_do_import io_uring/rw.c:314 [inline]
    io_prep_rw+0xb5/0x120 io_uring/rw.c:326
    io_prep_rwv io_uring/rw.c:344 [inline]
    io_prep_readv+0x20/0x80 io_uring/rw.c:359
    io_init_req io_uring/io_uring.c:2248 [inline]
    io_submit_sqe io_uring/io_uring.c:2295 [inline]
    io_submit_sqes+0x354/0xe80 io_uring/io_uring.c:2447
    __do_sys_io_uring_enter+0x83f/0xcf0 io_uring/io_uring.c:3514
    do_syscall_x64 arch/x86/entry/syscall_64.c:63 [inline]
    do_syscall_64+0xa4/0xfa0 arch/x86/entry/syscall_64.c:94
    entry_SYSCALL_64_after_hwframe+0x77/0x7f

BUG: memory leak
unreferenced object 0xffff88812638cca0 (size 32):
  comm "syz.0.17", pid 6104, jiffies 4294942640
  hex dump (first 32 bytes):
    00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00  ................
    00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00  ................
  backtrace (crc 0):
    kmemleak_alloc_recursive include/linux/kmemleak.h:44 [inline]
    slab_post_alloc_hook mm/slub.c:4975 [inline]
    slab_alloc_node mm/slub.c:5280 [inline]
    __do_kmalloc_node mm/slub.c:5641 [inline]
    __kmalloc_noprof+0x3e3/0x6b0 mm/slub.c:5654
    kmalloc_noprof include/linux/slab.h:961 [inline]
    kmalloc_array_noprof include/linux/slab.h:1003 [inline]
    iovec_from_user lib/iov_iter.c:1309 [inline]
    iovec_from_user+0x108/0x140 lib/iov_iter.c:1292
    __import_iovec+0x71/0x350 lib/iov_iter.c:1363
    io_import_vec io_uring/rw.c:99 [inline]
    __io_import_rw_buffer+0x1e2/0x260 io_uring/rw.c:120
    io_import_rw_buffer io_uring/rw.c:139 [inline]
    io_rw_do_import io_uring/rw.c:314 [inline]
    io_prep_rw+0xb5/0x120 io_uring/rw.c:326
    io_prep_rwv io_uring/rw.c:344 [inline]
    io_prep_readv+0x20/0x80 io_uring/rw.c:359
    io_init_req io_uring/io_uring.c:2248 [inline]
    io_submit_sqe io_uring/io_uring.c:2295 [inline]
    io_submit_sqes+0x354/0xe80 io_uring/io_uring.c:2447
    __do_sys_io_uring_enter+0x83f/0xcf0 io_uring/io_uring.c:3514
    do_syscall_x64 arch/x86/entry/syscall_64.c:63 [inline]
    do_syscall_64+0xa4/0xfa0 arch/x86/entry/syscall_64.c:94
    entry_SYSCALL_64_after_hwframe+0x77/0x7f

BUG: memory leak
unreferenced object 0xffff88812638ccc0 (size 32):
  comm "syz.0.17", pid 6104, jiffies 4294942640
  hex dump (first 32 bytes):
    00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00  ................
    00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00  ................
  backtrace (crc 0):
    kmemleak_alloc_recursive include/linux/kmemleak.h:44 [inline]
    slab_post_alloc_hook mm/slub.c:4975 [inline]
    slab_alloc_node mm/slub.c:5280 [inline]
    __do_kmalloc_node mm/slub.c:5641 [inline]
    __kmalloc_noprof+0x3e3/0x6b0 mm/slub.c:5654
    kmalloc_noprof include/linux/slab.h:961 [inline]
    kmalloc_array_noprof include/linux/slab.h:1003 [inline]
    iovec_from_user lib/iov_iter.c:1309 [inline]
    iovec_from_user+0x108/0x140 lib/iov_iter.c:1292
    __import_iovec+0x71/0x350 lib/iov_iter.c:1363
    io_import_vec io_uring/rw.c:99 [inline]
    __io_import_rw_buffer+0x1e2/0x260 io_uring/rw.c:120
    io_import_rw_buffer io_uring/rw.c:139 [inline]
    io_rw_do_import io_uring/rw.c:314 [inline]
    io_prep_rw+0xb5/0x120 io_uring/rw.c:326
    io_prep_rwv io_uring/rw.c:344 [inline]
    io_prep_readv+0x20/0x80 io_uring/rw.c:359
    io_init_req io_uring/io_uring.c:2248 [inline]
    io_submit_sqe io_uring/io_uring.c:2295 [inline]
    io_submit_sqes+0x354/0xe80 io_uring/io_uring.c:2447
    __do_sys_io_uring_enter+0x83f/0xcf0 io_uring/io_uring.c:3514
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

