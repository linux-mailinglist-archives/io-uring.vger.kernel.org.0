Return-Path: <io-uring+bounces-2558-lists+io-uring=lfdr.de@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [147.75.80.249])
	by mail.lfdr.de (Postfix) with ESMTPS id 48A8393AFFA
	for <lists+io-uring@lfdr.de>; Wed, 24 Jul 2024 12:51:27 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id BA4DF1F22841
	for <lists+io-uring@lfdr.de>; Wed, 24 Jul 2024 10:51:26 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 10E29155A5C;
	Wed, 24 Jul 2024 10:51:23 +0000 (UTC)
X-Original-To: io-uring@vger.kernel.org
Received: from mail-io1-f71.google.com (mail-io1-f71.google.com [209.85.166.71])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7C91D15572D
	for <io-uring@vger.kernel.org>; Wed, 24 Jul 2024 10:51:21 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.166.71
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1721818283; cv=none; b=bwUbFUyKKbLjF1+U9CAXY8RFxp4/FUmTT0eBgUJE8rmc/0Rsjem8SHljisP9LT31PgYiDykgc8pDzLDkdcU7A/RX9KpUAkni44XonmXSeHoM/tSX222M6OVgM2t/z8ltk1L8U8VdyjD71mKfpER/lEIb/7RzYDo8GL3Gi3Acw4A=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1721818283; c=relaxed/simple;
	bh=V9FflNMOaNUBjUr7DyKJK0R/5lCMGATCaPVDjYqEex0=;
	h=MIME-Version:Date:Message-ID:Subject:From:To:Content-Type; b=ZF91J7iePnGpyJ7ToIJiiNWuuD0SAEw6sVyb/C1iy9q5DMqdQcvLSGdQWbgOVY+c16Sbqp3K9U9wVXFbrCtrgAXjwY3F/CkLBaJGPdKGl7Ay7knMj65jeUXNWVCUOimdyz0+JyBqd5Dn5k8gwedDLRtn4wnaW5oZr4uDOt0gOH4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=fail (p=none dis=none) header.from=syzkaller.appspotmail.com; spf=pass smtp.mailfrom=M3KW2WVRGUFZ5GODRSRYTGD7.apphosting.bounces.google.com; arc=none smtp.client-ip=209.85.166.71
Authentication-Results: smtp.subspace.kernel.org; dmarc=fail (p=none dis=none) header.from=syzkaller.appspotmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=M3KW2WVRGUFZ5GODRSRYTGD7.apphosting.bounces.google.com
Received: by mail-io1-f71.google.com with SMTP id ca18e2360f4ac-803aad60527so1019483939f.1
        for <io-uring@vger.kernel.org>; Wed, 24 Jul 2024 03:51:21 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1721818281; x=1722423081;
        h=to:from:subject:message-id:date:mime-version:x-gm-message-state
         :from:to:cc:subject:date:message-id:reply-to;
        bh=xYIIdmOP00JCZGs1NX7YrS8Qs+uoGfBXL+gmejp32e4=;
        b=woLlq8dThWAYMlw809S1wFsNmSQ2VSH4mFof4oCMGuhdafpa202RPtkuisPoisfPFT
         3xWXC+jObzjZ16c22YuSZSk46kRqDqzZ6CqUQEDhANSZHsjgymAp8tPPbWWNdGAtCsfI
         5AHrbhjzOUYJ2mbdDbh9MnVIBVAemaaH1NPmZfraMKK3+gx+pN47XuZz0jAg7p5eu7tk
         1t5yF2b/Jqti0llIAANJJmbNnDasMXzKihIimIsHbeTrFRP59aYUD1ytlruRoYvSJhlk
         F576BVQT5HJOJOe+QVJPbPf2YIg9CbIQU+RmeBiVlGd5Dbf8jNnIwGGxXSkgSpbQ10n5
         xw0Q==
X-Forwarded-Encrypted: i=1; AJvYcCW7l3y4iDHmbnbOlUqnNMy3ax3IS+LHbqWdHgc426siltrZKJ3du630F7ncLJffSCp18Ny1y5/LNhSTo1S3F7+nqVysjjAVQq8=
X-Gm-Message-State: AOJu0YyuUIiRB3LonMMjqeWcYEp6F43t/yJgc6CAoaCndL66ttfhFnqG
	9Lue54A7A1A3XTAS4BUMsHHs9j8+AWiLYshwV8m2ktywwD46FBi0vDHe0oOq6pz6/CyN7A2bjj3
	34PnG4ApVu2jsaHom8IUL+8/mCCUFlAEhgSq9pNRAgnQOBFzfs/eWY24=
X-Google-Smtp-Source: AGHT+IF+N5Jkk6jlaJolKBvhKw0oO9gdPWk3bQnLliEiN9s5fX70jg8hI7VmeGTfMfGiLrgpiIvr8KB8kZZeKUAJIemjv4nlVSPy
Precedence: bulk
X-Mailing-List: io-uring@vger.kernel.org
List-Id: <io-uring.vger.kernel.org>
List-Subscribe: <mailto:io-uring+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:io-uring+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-Received: by 2002:a05:6638:841f:b0:4c0:a8a5:81e9 with SMTP id
 8926c6da1cb9f-4c23fe63d83mr589728173.3.1721818280700; Wed, 24 Jul 2024
 03:51:20 -0700 (PDT)
Date: Wed, 24 Jul 2024 03:51:20 -0700
X-Google-Appengine-App-Id: s~syzkaller
X-Google-Appengine-App-Id-Alias: syzkaller
Message-ID: <000000000000fd3d8d061dfc0e4a@google.com>
Subject: [syzbot] [io-uring?] KMSAN: uninit-value in io_req_task_work_add_remote
From: syzbot <syzbot+82609b8937a4458106ca@syzkaller.appspotmail.com>
To: asml.silence@gmail.com, axboe@kernel.dk, io-uring@vger.kernel.org, 
	linux-kernel@vger.kernel.org, syzkaller-bugs@googlegroups.com
Content-Type: text/plain; charset="UTF-8"

Hello,

syzbot found the following issue on:

HEAD commit:    933069701c1b Merge tag '6.11-rc-smb3-server-fixes' of git:..
git tree:       upstream
console+strace: https://syzkaller.appspot.com/x/log.txt?x=16e38d5e980000
kernel config:  https://syzkaller.appspot.com/x/.config?x=c062b3d00b275b52
dashboard link: https://syzkaller.appspot.com/bug?extid=82609b8937a4458106ca
compiler:       Debian clang version 15.0.6, GNU ld (GNU Binutils for Debian) 2.40
syz repro:      https://syzkaller.appspot.com/x/repro.syz?x=149e5245980000
C reproducer:   https://syzkaller.appspot.com/x/repro.c?x=1388c55e980000

Downloadable assets:
disk image: https://storage.googleapis.com/syzbot-assets/11dcaf5ed4bb/disk-93306970.raw.xz
vmlinux: https://storage.googleapis.com/syzbot-assets/6b2d786e6c09/vmlinux-93306970.xz
kernel image: https://storage.googleapis.com/syzbot-assets/c6cd729a2bbd/bzImage-93306970.xz

IMPORTANT: if you fix the issue, please add the following tag to the commit:
Reported-by: syzbot+82609b8937a4458106ca@syzkaller.appspotmail.com

=====================================================
BUG: KMSAN: uninit-value in io_req_local_work_add io_uring/io_uring.c:1192 [inline]
BUG: KMSAN: uninit-value in io_req_task_work_add_remote+0x588/0x5d0 io_uring/io_uring.c:1240
 io_req_local_work_add io_uring/io_uring.c:1192 [inline]
 io_req_task_work_add_remote+0x588/0x5d0 io_uring/io_uring.c:1240
 io_msg_remote_post io_uring/msg_ring.c:102 [inline]
 io_msg_data_remote io_uring/msg_ring.c:133 [inline]
 io_msg_ring_data io_uring/msg_ring.c:152 [inline]
 io_msg_ring+0x1c38/0x1ef0 io_uring/msg_ring.c:305
 io_issue_sqe+0x383/0x22c0 io_uring/io_uring.c:1710
 io_queue_sqe io_uring/io_uring.c:1924 [inline]
 io_submit_sqe io_uring/io_uring.c:2180 [inline]
 io_submit_sqes+0x1259/0x2f20 io_uring/io_uring.c:2295
 __do_sys_io_uring_enter io_uring/io_uring.c:3205 [inline]
 __se_sys_io_uring_enter+0x40c/0x3ca0 io_uring/io_uring.c:3142
 __x64_sys_io_uring_enter+0x11f/0x1a0 io_uring/io_uring.c:3142
 x64_sys_call+0x2d82/0x3c10 arch/x86/include/generated/asm/syscalls_64.h:427
 do_syscall_x64 arch/x86/entry/common.c:52 [inline]
 do_syscall_64+0xcd/0x1e0 arch/x86/entry/common.c:83
 entry_SYSCALL_64_after_hwframe+0x77/0x7f

Uninit was created at:
 __alloc_pages_noprof+0x9d6/0xe70 mm/page_alloc.c:4719
 __alloc_pages_node_noprof include/linux/gfp.h:269 [inline]
 alloc_pages_node_noprof include/linux/gfp.h:296 [inline]
 alloc_slab_page mm/slub.c:2321 [inline]
 allocate_slab+0x203/0x1220 mm/slub.c:2484
 new_slab mm/slub.c:2537 [inline]
 ___slab_alloc+0x12ef/0x35e0 mm/slub.c:3723
 __kmem_cache_alloc_bulk mm/slub.c:4759 [inline]
 kmem_cache_alloc_bulk_noprof+0x486/0x1330 mm/slub.c:4831
 __io_alloc_req_refill+0x84/0x560 io_uring/io_uring.c:940
 io_alloc_req io_uring/io_uring.h:393 [inline]
 io_submit_sqes+0x171b/0x2f20 io_uring/io_uring.c:2284
 __do_sys_io_uring_enter io_uring/io_uring.c:3205 [inline]
 __se_sys_io_uring_enter+0x40c/0x3ca0 io_uring/io_uring.c:3142
 __x64_sys_io_uring_enter+0x11f/0x1a0 io_uring/io_uring.c:3142
 x64_sys_call+0x2d82/0x3c10 arch/x86/include/generated/asm/syscalls_64.h:427
 do_syscall_x64 arch/x86/entry/common.c:52 [inline]
 do_syscall_64+0xcd/0x1e0 arch/x86/entry/common.c:83
 entry_SYSCALL_64_after_hwframe+0x77/0x7f

CPU: 1 UID: 0 PID: 5053 Comm: syz-executor367 Not tainted 6.10.0-syzkaller-11840-g933069701c1b #0
Hardware name: Google Google Compute Engine/Google Compute Engine, BIOS Google 06/27/2024
=====================================================


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

