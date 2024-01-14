Return-Path: <io-uring+bounces-401-lists+io-uring=lfdr.de@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [IPv6:2604:1380:45e3:2400::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 70C6E82D03B
	for <lists+io-uring@lfdr.de>; Sun, 14 Jan 2024 11:14:24 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 062A82823CC
	for <lists+io-uring@lfdr.de>; Sun, 14 Jan 2024 10:14:23 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id AD5531FCA;
	Sun, 14 Jan 2024 10:14:18 +0000 (UTC)
X-Original-To: io-uring@vger.kernel.org
Received: from mail-il1-f198.google.com (mail-il1-f198.google.com [209.85.166.198])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 420AE1FAD
	for <io-uring@vger.kernel.org>; Sun, 14 Jan 2024 10:14:16 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; dmarc=fail (p=none dis=none) header.from=syzkaller.appspotmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=M3KW2WVRGUFZ5GODRSRYTGD7.apphosting.bounces.google.com
Received: by mail-il1-f198.google.com with SMTP id e9e14a558f8ab-3608452488eso64628125ab.1
        for <io-uring@vger.kernel.org>; Sun, 14 Jan 2024 02:14:16 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1705227256; x=1705832056;
        h=to:from:subject:message-id:date:mime-version:x-gm-message-state
         :from:to:cc:subject:date:message-id:reply-to;
        bh=++zUQFlQO1jJCn2oGGjsjqpi/zbkWdKQOFSazaQqWLM=;
        b=i4R69C3SetHcOq77/M7FPsDSzyxnWcGGZauwVqblSfBwZ8KPZqN0l1DiJBmPjZITxW
         tVFsPF1K1OoVczsNjgNv2VfWNyL2AlkiAKy59u9vL+nRY/KrfbGyp3dWkj0Sv6MWAqhS
         BwAwVn85sVrwAIaJL/FA6LIfOAqb0NYuFgN4df6aPgYN4pms89uMf21Wq1BeZhatYjSw
         cp2dvK7HmGkMJqd0icdg2HnbFPto4dFAfw+sD9BH/ECqcARjexyohFqAoCCu3bVZbAod
         j7g3v8wEW4qQZfMyr1IeTRfPx976IpjanL8jocfdtabQ3ZySUj7jUr6CS0+AmJfxGZMy
         3Pyw==
X-Gm-Message-State: AOJu0YyENOvaRWjuWNAgVd66s994hDfZfl4diTLnfO9KkqZtoNIhR3s+
	8CzbEa0buh/OAAzLa4d40lpRn1JHcS48tWCW3mOAl4VKEZ9A
X-Google-Smtp-Source: AGHT+IFuF0rQEiObRoW/C9j4Ipq9ayuERPEJrHyCIA/CXrKUYY1vLljh+rJ4yQchsGkbwShXhr0pzMhLVfpAgsv2MJXPA0j3WWHn
Precedence: bulk
X-Mailing-List: io-uring@vger.kernel.org
List-Id: <io-uring.vger.kernel.org>
List-Subscribe: <mailto:io-uring+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:io-uring+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-Received: by 2002:a05:6e02:194a:b0:360:620a:24eb with SMTP id
 x10-20020a056e02194a00b00360620a24ebmr560177ilu.4.1705227256357; Sun, 14 Jan
 2024 02:14:16 -0800 (PST)
Date: Sun, 14 Jan 2024 02:14:16 -0800
X-Google-Appengine-App-Id: s~syzkaller
X-Google-Appengine-App-Id-Alias: syzkaller
Message-ID: <000000000000e06949060ee528f1@google.com>
Subject: [syzbot] [io-uring?] KMSAN: uninit-value in io_rw_fail
From: syzbot <syzbot+8d9c06e026c513a69f2f@syzkaller.appspotmail.com>
To: asml.silence@gmail.com, axboe@kernel.dk, io-uring@vger.kernel.org, 
	linux-kernel@vger.kernel.org, syzkaller-bugs@googlegroups.com
Content-Type: text/plain; charset="UTF-8"

Hello,

syzbot found the following issue on:

HEAD commit:    99d99825fc07 Merge tag 'nfs-for-6.6-1' of git://git.linux-..
git tree:       upstream
console+strace: https://syzkaller.appspot.com/x/log.txt?x=10c292a8680000
kernel config:  https://syzkaller.appspot.com/x/.config?x=e9fadcd263e8d242
dashboard link: https://syzkaller.appspot.com/bug?extid=8d9c06e026c513a69f2f
compiler:       Debian clang version 15.0.6, GNU ld (GNU Binutils for Debian) 2.40
syz repro:      https://syzkaller.appspot.com/x/repro.syz?x=1358d7dfa80000
C reproducer:   https://syzkaller.appspot.com/x/repro.c?x=14c99d9fa80000

Downloadable assets:
disk image: https://storage.googleapis.com/syzbot-assets/7e9fa7fad7d0/disk-99d99825.raw.xz
vmlinux: https://storage.googleapis.com/syzbot-assets/424ca21fc443/vmlinux-99d99825.xz
kernel image: https://storage.googleapis.com/syzbot-assets/d4de08b26e5b/bzImage-99d99825.xz

IMPORTANT: if you fix the issue, please add the following tag to the commit:
Reported-by: syzbot+8d9c06e026c513a69f2f@syzkaller.appspotmail.com

=====================================================
BUG: KMSAN: uninit-value in io_fixup_rw_res io_uring/rw.c:273 [inline]
BUG: KMSAN: uninit-value in io_rw_fail+0x1a7/0x1b0 io_uring/rw.c:996
 io_fixup_rw_res io_uring/rw.c:273 [inline]
 io_rw_fail+0x1a7/0x1b0 io_uring/rw.c:996
 io_req_defer_failed+0x217/0x3e0 io_uring/io_uring.c:1030
 io_queue_sqe_fallback+0x1f4/0x260 io_uring/io_uring.c:2063
 io_submit_state_end io_uring/io_uring.c:2308 [inline]
 io_submit_sqes+0x2b83/0x2ff0 io_uring/io_uring.c:2426
 __do_sys_io_uring_enter io_uring/io_uring.c:3620 [inline]
 __se_sys_io_uring_enter+0x491/0x43f0 io_uring/io_uring.c:3554
 __x64_sys_io_uring_enter+0x11b/0x1a0 io_uring/io_uring.c:3554
 do_syscall_x64 arch/x86/entry/common.c:50 [inline]
 do_syscall_64+0x41/0xc0 arch/x86/entry/common.c:80
 entry_SYSCALL_64_after_hwframe+0x63/0xcd

Uninit was created at:
 slab_post_alloc_hook+0x12f/0xb70 mm/slab.h:767
 slab_alloc_node mm/slub.c:3478 [inline]
 __kmem_cache_alloc_node+0x536/0x8d0 mm/slub.c:3517
 __do_kmalloc_node mm/slab_common.c:1022 [inline]
 __kmalloc+0x121/0x3c0 mm/slab_common.c:1036
 kmalloc include/linux/slab.h:603 [inline]
 io_alloc_async_data io_uring/io_uring.c:1745 [inline]
 io_req_prep_async+0x384/0x5a0 io_uring/io_uring.c:1766
 io_queue_sqe_fallback+0x95/0x260 io_uring/io_uring.c:2060
 io_submit_state_end io_uring/io_uring.c:2308 [inline]
 io_submit_sqes+0x2b83/0x2ff0 io_uring/io_uring.c:2426
 __do_sys_io_uring_enter io_uring/io_uring.c:3620 [inline]
 __se_sys_io_uring_enter+0x491/0x43f0 io_uring/io_uring.c:3554
 __x64_sys_io_uring_enter+0x11b/0x1a0 io_uring/io_uring.c:3554
 do_syscall_x64 arch/x86/entry/common.c:50 [inline]
 do_syscall_64+0x41/0xc0 arch/x86/entry/common.c:80
 entry_SYSCALL_64_after_hwframe+0x63/0xcd

CPU: 0 PID: 4988 Comm: syz-executor352 Not tainted 6.5.0-syzkaller-09276-g99d99825fc07 #0
Hardware name: Google Google Compute Engine/Google Compute Engine, BIOS Google 07/26/2023
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

