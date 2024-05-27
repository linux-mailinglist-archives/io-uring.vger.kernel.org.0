Return-Path: <io-uring+bounces-1970-lists+io-uring=lfdr.de@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [139.178.88.99])
	by mail.lfdr.de (Postfix) with ESMTPS id 824C78D0143
	for <lists+io-uring@lfdr.de>; Mon, 27 May 2024 15:22:44 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 377A1283430
	for <lists+io-uring@lfdr.de>; Mon, 27 May 2024 13:22:43 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id DFB3015EFAD;
	Mon, 27 May 2024 13:22:30 +0000 (UTC)
X-Original-To: io-uring@vger.kernel.org
Received: from mail-io1-f77.google.com (mail-io1-f77.google.com [209.85.166.77])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5673B15ECF9
	for <io-uring@vger.kernel.org>; Mon, 27 May 2024 13:22:29 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.166.77
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1716816150; cv=none; b=ojHZ+PNq3afxWlYJ0srLqAEcS2ptt0EtEmW55QF765DcdF0w+96Qqx+1U+8GXGvYLa8Wp+0cJ+1xVgqpcegOwoECcOw7YHC1lJQLCEa9lcssZjwv/vqYUQOvQsB3G+3I5+uuKQOghI6Ac0KGk2YjbXg0eK93YU6u9+kistxwwGw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1716816150; c=relaxed/simple;
	bh=l4cYYvTuGJTCQAXcG6jFJSb2OefKYqz1SCBoseZVUns=;
	h=MIME-Version:Date:Message-ID:Subject:From:To:Content-Type; b=XGUjY6Y0yfz8MBcTXOC/Nj/IuhX2WbDeIyZ5IUzpulhOK5tRfy7SoDUqxV8xdVRySXRFfz5nL4AmBhqhJYR5OREtrFdRwiiZKfmz2Dxp6OasN+o8LiDYf+35wAoOJEkLquzhaE/NZ4DZtb2a3dXOeu4MdyvFHGyh3BKu9cJit5o=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=fail (p=none dis=none) header.from=syzkaller.appspotmail.com; spf=pass smtp.mailfrom=M3KW2WVRGUFZ5GODRSRYTGD7.apphosting.bounces.google.com; arc=none smtp.client-ip=209.85.166.77
Authentication-Results: smtp.subspace.kernel.org; dmarc=fail (p=none dis=none) header.from=syzkaller.appspotmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=M3KW2WVRGUFZ5GODRSRYTGD7.apphosting.bounces.google.com
Received: by mail-io1-f77.google.com with SMTP id ca18e2360f4ac-7e8e7707356so368820839f.3
        for <io-uring@vger.kernel.org>; Mon, 27 May 2024 06:22:29 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1716816148; x=1717420948;
        h=to:from:subject:message-id:date:mime-version:x-gm-message-state
         :from:to:cc:subject:date:message-id:reply-to;
        bh=/qhmbTQ4F0jLVtDtoVk681gByJJZtXvPAOYim6+cLZE=;
        b=soe1GLEliK/faSq/qm5LqAt/8huYEHPzaXk7mF3WHc9W6uUwlcG8SRzy+K13a16mUW
         BvldzAAA4KRjp4elBZdgBVPVVXA2ejX9G5uJ5mZX7kZPf3OUbE+htVDPCyn1pw1owix2
         c8NYlsEsufUNt2mMUYcrj6KDSfTaPsAOrzBktUYc9MB6uvFRq/iqhjEY0jhDMhBGETPa
         AS3gCBKOsDz2E7Whb0v+WFNV3wNPgTXW3qpfhkqcuMxR/FG1P9PUFe98LiYJQCUKHC9F
         k5Plr6S1R23IWWiwKddqo6CnXfPguAIgFY+0dFU3XBvOwL7VxYlqFA31U5ban2VhAx8H
         /nyA==
X-Forwarded-Encrypted: i=1; AJvYcCWCxFC8DX2Uw/y5rkht9UzRj1x31seYWqJnVN0mlqKy8kGWlpL0ywOUe5kSAgmBMn1hsGReKKUtP+qz3IRVFdWQNVTXXOxLXGU=
X-Gm-Message-State: AOJu0YzGfoAEcXMB4QM1he1oZ6yVj0xf7hdHnv+4kR3htr1Cg/Ee5LEg
	QLPdF+tuEANtPkG3xj5nOGFk5ejtzyLRY2cSrX05qp4DKxIHSCvAF9/1AfI8wjVm+KXWLpIIOyc
	vQK5nk1tQBC6yw+TRCgFCBfE60cITi+FsJUVOBDa4QGuPKm0ky0xM+PU=
X-Google-Smtp-Source: AGHT+IEWiodKgU8o7O1h9yGWtTo/R1nGfBJ3VP+NBaqZy7bxNCatxqKr698IrVTTW8Zz1Lpq5lic2HoFa0yiw29chSGTWr3ilD7J
Precedence: bulk
X-Mailing-List: io-uring@vger.kernel.org
List-Id: <io-uring.vger.kernel.org>
List-Subscribe: <mailto:io-uring+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:io-uring+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-Received: by 2002:a05:6e02:216e:b0:36b:2731:4084 with SMTP id
 e9e14a558f8ab-3737b2bdafemr5797905ab.2.1716816148564; Mon, 27 May 2024
 06:22:28 -0700 (PDT)
Date: Mon, 27 May 2024 06:22:28 -0700
X-Google-Appengine-App-Id: s~syzkaller
X-Google-Appengine-App-Id-Alias: syzkaller
Message-ID: <000000000000ae186106196f6894@google.com>
Subject: [syzbot] [io-uring?] KMSAN: uninit-value in io_issue_sqe
From: syzbot <syzbot+b1647099e82b3b349fbf@syzkaller.appspotmail.com>
To: asml.silence@gmail.com, axboe@kernel.dk, io-uring@vger.kernel.org, 
	linux-kernel@vger.kernel.org, syzkaller-bugs@googlegroups.com
Content-Type: text/plain; charset="UTF-8"

Hello,

syzbot found the following issue on:

HEAD commit:    614da38e2f7a Merge tag 'hid-for-linus-2024051401' of git:/..
git tree:       upstream
console output: https://syzkaller.appspot.com/x/log.txt?x=11b9b972980000
kernel config:  https://syzkaller.appspot.com/x/.config?x=f5d2cbf33633f507
dashboard link: https://syzkaller.appspot.com/bug?extid=b1647099e82b3b349fbf
compiler:       Debian clang version 15.0.6, GNU ld (GNU Binutils for Debian) 2.40

Unfortunately, I don't have any reproducer for this issue yet.

Downloadable assets:
disk image: https://storage.googleapis.com/syzbot-assets/89eafb874b71/disk-614da38e.raw.xz
vmlinux: https://storage.googleapis.com/syzbot-assets/356000512ad9/vmlinux-614da38e.xz
kernel image: https://storage.googleapis.com/syzbot-assets/839c73939115/bzImage-614da38e.xz

IMPORTANT: if you fix the issue, please add the following tag to the commit:
Reported-by: syzbot+b1647099e82b3b349fbf@syzkaller.appspotmail.com

=====================================================
BUG: KMSAN: uninit-value in io_req_cqe_overflow io_uring/io_uring.c:810 [inline]
BUG: KMSAN: uninit-value in io_req_complete_post io_uring/io_uring.c:937 [inline]
BUG: KMSAN: uninit-value in io_issue_sqe+0x1f1b/0x22c0 io_uring/io_uring.c:1763
 io_req_cqe_overflow io_uring/io_uring.c:810 [inline]
 io_req_complete_post io_uring/io_uring.c:937 [inline]
 io_issue_sqe+0x1f1b/0x22c0 io_uring/io_uring.c:1763
 io_wq_submit_work+0xa17/0xeb0 io_uring/io_uring.c:1860
 io_worker_handle_work+0xc04/0x2000 io_uring/io-wq.c:597
 io_wq_worker+0x447/0x1410 io_uring/io-wq.c:651
 ret_from_fork+0x6d/0x90 arch/x86/kernel/process.c:147
 ret_from_fork_asm+0x1a/0x30 arch/x86/entry/entry_64.S:244

Uninit was stored to memory at:
 io_req_set_res io_uring/io_uring.h:215 [inline]
 io_recv_finish+0xf10/0x1560 io_uring/net.c:861
 io_recv+0x12ec/0x1ea0 io_uring/net.c:1175
 io_issue_sqe+0x429/0x22c0 io_uring/io_uring.c:1751
 io_wq_submit_work+0xa17/0xeb0 io_uring/io_uring.c:1860
 io_worker_handle_work+0xc04/0x2000 io_uring/io-wq.c:597
 io_wq_worker+0x447/0x1410 io_uring/io-wq.c:651
 ret_from_fork+0x6d/0x90 arch/x86/kernel/process.c:147
 ret_from_fork_asm+0x1a/0x30 arch/x86/entry/entry_64.S:244

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

CPU: 1 PID: 7410 Comm: iou-wrk-7408 Not tainted 6.9.0-syzkaller-02707-g614da38e2f7a #0
Hardware name: Google Google Compute Engine/Google Compute Engine, BIOS Google 04/02/2024
=====================================================


---
This report is generated by a bot. It may contain errors.
See https://goo.gl/tpsmEJ for more information about syzbot.
syzbot engineers can be reached at syzkaller@googlegroups.com.

syzbot will keep track of this issue. See:
https://goo.gl/tpsmEJ#status for how to communicate with syzbot.

If the report is already addressed, let syzbot know by replying with:
#syz fix: exact-commit-title

If you want to overwrite report's subsystems, reply with:
#syz set subsystems: new-subsystem
(See the list of subsystem names on the web dashboard)

If the report is a duplicate of another one, reply with:
#syz dup: exact-subject-of-another-report

If you want to undo deduplication, reply with:
#syz undup

