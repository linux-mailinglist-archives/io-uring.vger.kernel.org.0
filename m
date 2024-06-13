Return-Path: <io-uring+bounces-2203-lists+io-uring=lfdr.de@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [147.75.80.249])
	by mail.lfdr.de (Postfix) with ESMTPS id 1668A907CBA
	for <lists+io-uring@lfdr.de>; Thu, 13 Jun 2024 21:38:44 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id 901701F24E48
	for <lists+io-uring@lfdr.de>; Thu, 13 Jun 2024 19:38:43 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id B9843137758;
	Thu, 13 Jun 2024 19:38:28 +0000 (UTC)
X-Original-To: io-uring@vger.kernel.org
Received: from mail-io1-f77.google.com (mail-io1-f77.google.com [209.85.166.77])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 175F614D2B7
	for <io-uring@vger.kernel.org>; Thu, 13 Jun 2024 19:38:26 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.166.77
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1718307508; cv=none; b=QzOYRFtsk+oALx/NB47NWnNbypAVtLlV1CGEYBn93LldcphX0PO0z6LVRwhmFhEu7wx6khq+10MUa13ONdZ6Ved1ZkxdwUWCBiIbNhJpjbIYJOnZ4WUtkcxDJ6fNFgMbaZQgC08MyQGa+MPRJrUxZq9Ib5KvGjEKojTrrXv7egc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1718307508; c=relaxed/simple;
	bh=6aypa/TFn6vR7GekpQf4/xcU4O9K8Fca3MiDire0XIs=;
	h=MIME-Version:Date:Message-ID:Subject:From:To:Content-Type; b=D2SiMesXxjzvHELZ8BcyjeAhnFiBWBmSJKl3gjByXCsWrGkYC+4udDBC5I6qeZjZtTIjvhtkCzRED2l17Q5pthCzXg2llBieK9lLoiYlfi5X0+iA0IcpKGqM3EaMLJgebl7A/4Sxrh3BruG54wJLJqfMsMNOFv5tNuDerPd2E2A=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=fail (p=none dis=none) header.from=syzkaller.appspotmail.com; spf=pass smtp.mailfrom=M3KW2WVRGUFZ5GODRSRYTGD7.apphosting.bounces.google.com; arc=none smtp.client-ip=209.85.166.77
Authentication-Results: smtp.subspace.kernel.org; dmarc=fail (p=none dis=none) header.from=syzkaller.appspotmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=M3KW2WVRGUFZ5GODRSRYTGD7.apphosting.bounces.google.com
Received: by mail-io1-f77.google.com with SMTP id ca18e2360f4ac-7eb861e964cso143525539f.1
        for <io-uring@vger.kernel.org>; Thu, 13 Jun 2024 12:38:26 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1718307506; x=1718912306;
        h=to:from:subject:message-id:date:mime-version:x-gm-message-state
         :from:to:cc:subject:date:message-id:reply-to;
        bh=MLJJOWCX65rxIwkhEm2uOMKY3r7EFZtqKAwAdHzJM9g=;
        b=ByKXhUAbCk57R0dBQQ4JWl+9DnglDqKl8diNse+3I8FP8tN9sB/Uxoh+VnFCQuPKq9
         p5QUkPd39pWfTWEt7FjgSFuG8KKEKW9IHHb1bQpzz5S2lAll/01AxHTYT9qrBBkNuOgh
         /MKobXB8/l+1k2g6js+1xwhkWoeQcirr9QFc8mTzVE3lYGswOkdv+yie0MQMUNl4IUR0
         OQY/URr679kbr+EjTmdxH7OmCxnWQDpDRMHcNyeM+L/Epo9khrj1dW3+jAhL6Hz7xUkk
         /Ceq2cz1yH1wwITguzXgpSY/iESn8BLJwGR66FGdt4XP81MqsswNPLHkNpMmR2F/8ZR2
         kOwA==
X-Forwarded-Encrypted: i=1; AJvYcCXf5Fhum/QbekelCFjiD8Xp5gABeUKExTZCHt3XyOqdC5DOXT5O7lISMmX2OJen5XnZ6lYGyRMd/vZPQ5T5wff0Jcy6YCytJNw=
X-Gm-Message-State: AOJu0YyyV7YCP+J+mStMFymllNLf8ZkljrlVKbH1c+1mcl02D1qofbvF
	QqahDVOGjtn3uvcBUkTY+Gv2cjy4uyxXW61//RIX4nV4bs3r2z8FhKlyk4Arpj4GyycgLMtkTSX
	oR7V1S5yD65orYVyp0XxyDmDGg3yeAzDcf6JEi8h3uKulN70QaQjErsI=
X-Google-Smtp-Source: AGHT+IHzIrUbSrbDOTpr6qQydzMSs7GCZvTCI9PQnIbCAKH2f2LdyUAT50wUuyIqvD2skpvH/Siu5CXVvClMaLe1skIHINU42xbE
Precedence: bulk
X-Mailing-List: io-uring@vger.kernel.org
List-Id: <io-uring.vger.kernel.org>
List-Subscribe: <mailto:io-uring+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:io-uring+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-Received: by 2002:a05:6638:841f:b0:4b7:ca3d:c0dd with SMTP id
 8926c6da1cb9f-4b96417f130mr5610173.6.1718307506165; Thu, 13 Jun 2024 12:38:26
 -0700 (PDT)
Date: Thu, 13 Jun 2024 12:38:26 -0700
X-Google-Appengine-App-Id: s~syzkaller
X-Google-Appengine-App-Id-Alias: syzkaller
Message-ID: <000000000000852fce061acaa456@google.com>
Subject: [syzbot] [io-uring?] KMSAN: uninit-value in io_req_cqe_overflow (3)
From: syzbot <syzbot+e6616d0dc8ded5dc56d6@syzkaller.appspotmail.com>
To: asml.silence@gmail.com, axboe@kernel.dk, io-uring@vger.kernel.org, 
	linux-kernel@vger.kernel.org, syzkaller-bugs@googlegroups.com
Content-Type: text/plain; charset="UTF-8"

Hello,

syzbot found the following issue on:

HEAD commit:    614da38e2f7a Merge tag 'hid-for-linus-2024051401' of git:/..
git tree:       upstream
console+strace: https://syzkaller.appspot.com/x/log.txt?x=12980e41980000
kernel config:  https://syzkaller.appspot.com/x/.config?x=f5d2cbf33633f507
dashboard link: https://syzkaller.appspot.com/bug?extid=e6616d0dc8ded5dc56d6
compiler:       Debian clang version 15.0.6, GNU ld (GNU Binutils for Debian) 2.40
syz repro:      https://syzkaller.appspot.com/x/repro.syz?x=13526ca2980000
C reproducer:   https://syzkaller.appspot.com/x/repro.c?x=144e5256980000

Downloadable assets:
disk image: https://storage.googleapis.com/syzbot-assets/89eafb874b71/disk-614da38e.raw.xz
vmlinux: https://storage.googleapis.com/syzbot-assets/356000512ad9/vmlinux-614da38e.xz
kernel image: https://storage.googleapis.com/syzbot-assets/839c73939115/bzImage-614da38e.xz

IMPORTANT: if you fix the issue, please add the following tag to the commit:
Reported-by: syzbot+e6616d0dc8ded5dc56d6@syzkaller.appspotmail.com

=====================================================
BUG: KMSAN: uninit-value in io_req_cqe_overflow+0x193/0x1c0 io_uring/io_uring.c:810
 io_req_cqe_overflow+0x193/0x1c0 io_uring/io_uring.c:810
 __io_submit_flush_completions+0x7eb/0x1be0 io_uring/io_uring.c:1464
 io_submit_flush_completions io_uring/io_uring.h:148 [inline]
 ctx_flush_and_put+0x16c/0x360 io_uring/io_uring.c:1055
 io_handle_tw_list+0x58b/0x5c0 io_uring/io_uring.c:1095
 tctx_task_work_run+0xf8/0x3d0 io_uring/io_uring.c:1155
 tctx_task_work+0x6d/0xc0 io_uring/io_uring.c:1173
 task_work_run+0x268/0x310 kernel/task_work.c:180
 ptrace_notify+0x304/0x320 kernel/signal.c:2404
 ptrace_report_syscall include/linux/ptrace.h:415 [inline]
 ptrace_report_syscall_exit include/linux/ptrace.h:477 [inline]
 syscall_exit_work+0x14e/0x3e0 kernel/entry/common.c:173
 syscall_exit_to_user_mode_prepare kernel/entry/common.c:200 [inline]
 __syscall_exit_to_user_mode_work kernel/entry/common.c:205 [inline]
 syscall_exit_to_user_mode+0x135/0x160 kernel/entry/common.c:218
 do_syscall_64+0xdc/0x1e0 arch/x86/entry/common.c:89
 entry_SYSCALL_64_after_hwframe+0x77/0x7f

Uninit was stored to memory at:
 io_req_set_res io_uring/io_uring.h:215 [inline]
 io_recv_finish+0xf10/0x1560 io_uring/net.c:861
 io_recv+0x12ec/0x1ea0 io_uring/net.c:1175
 io_issue_sqe+0x429/0x22c0 io_uring/io_uring.c:1751
 io_poll_issue+0x32/0x40 io_uring/io_uring.c:1782
 io_poll_check_events io_uring/poll.c:331 [inline]
 io_poll_task_func+0x5f9/0x14d0 io_uring/poll.c:357
 io_handle_tw_list+0x23a/0x5c0 io_uring/io_uring.c:1083
 tctx_task_work_run+0xf8/0x3d0 io_uring/io_uring.c:1155
 tctx_task_work+0x6d/0xc0 io_uring/io_uring.c:1173
 task_work_run+0x268/0x310 kernel/task_work.c:180
 ptrace_notify+0x304/0x320 kernel/signal.c:2404
 ptrace_report_syscall include/linux/ptrace.h:415 [inline]
 ptrace_report_syscall_exit include/linux/ptrace.h:477 [inline]
 syscall_exit_work+0x14e/0x3e0 kernel/entry/common.c:173
 syscall_exit_to_user_mode_prepare kernel/entry/common.c:200 [inline]
 __syscall_exit_to_user_mode_work kernel/entry/common.c:205 [inline]
 syscall_exit_to_user_mode+0x135/0x160 kernel/entry/common.c:218
 do_syscall_64+0xdc/0x1e0 arch/x86/entry/common.c:89
 entry_SYSCALL_64_after_hwframe+0x77/0x7f

Uninit was created at:
 slab_post_alloc_hook mm/slub.c:3877 [inline]
 slab_alloc_node mm/slub.c:3918 [inline]
 __do_kmalloc_node mm/slub.c:4038 [inline]
 __kmalloc+0x6e4/0x1060 mm/slub.c:4052
 kmalloc include/linux/slab.h:632 [inline]
 io_alloc_async_data+0xc0/0x220 io_uring/io_uring.c:1662
 io_msg_alloc_async io_uring/net.c:166 [inline]
 io_recvmsg_prep_setup io_uring/net.c:725 [inline]
 io_recvmsg_prep+0xbe8/0x1a20 io_uring/net.c:806
 io_init_req io_uring/io_uring.c:2135 [inline]
 io_submit_sqe io_uring/io_uring.c:2182 [inline]
 io_submit_sqes+0x1135/0x2f10 io_uring/io_uring.c:2335
 __do_sys_io_uring_enter io_uring/io_uring.c:3246 [inline]
 __se_sys_io_uring_enter+0x40f/0x3c80 io_uring/io_uring.c:3183
 __x64_sys_io_uring_enter+0x11f/0x1a0 io_uring/io_uring.c:3183
 x64_sys_call+0x2c0/0x3b50 arch/x86/include/generated/asm/syscalls_64.h:427
 do_syscall_x64 arch/x86/entry/common.c:52 [inline]
 do_syscall_64+0xcf/0x1e0 arch/x86/entry/common.c:83
 entry_SYSCALL_64_after_hwframe+0x77/0x7f

CPU: 1 PID: 5049 Comm: syz-executor107 Not tainted 6.9.0-syzkaller-02707-g614da38e2f7a #0
Hardware name: Google Google Compute Engine/Google Compute Engine, BIOS Google 06/07/2024
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

