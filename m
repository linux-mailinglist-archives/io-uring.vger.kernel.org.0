Return-Path: <io-uring+bounces-7940-lists+io-uring=lfdr.de@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from sy.mirrors.kernel.org (sy.mirrors.kernel.org [147.75.48.161])
	by mail.lfdr.de (Postfix) with ESMTPS id A5C92AB25CB
	for <lists+io-uring@lfdr.de>; Sun, 11 May 2025 02:19:31 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sy.mirrors.kernel.org (Postfix) with ESMTPS id 7A4767A557C
	for <lists+io-uring@lfdr.de>; Sun, 11 May 2025 00:18:16 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 1B0422F50;
	Sun, 11 May 2025 00:19:25 +0000 (UTC)
X-Original-To: io-uring@vger.kernel.org
Received: from mail-il1-f205.google.com (mail-il1-f205.google.com [209.85.166.205])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4ECD323A9
	for <io-uring@vger.kernel.org>; Sun, 11 May 2025 00:19:22 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.166.205
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1746922765; cv=none; b=ThexGzubAX4skzrMrucV9/kmIn0IegeHeRROl1nVaAv+aIyVWlo5JzzYkzNZoDsya1XCOR7M0T/B2pT0XvIa7lem9o/sbzyYL2ywrkJ92lxIAXON44vQVCxbiQOGwVUMFnkJHGyoVKc+2JlLPJjqjvbxfkKb7qV4fEuxfKbAS74=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1746922765; c=relaxed/simple;
	bh=0cZBtVoHVFs1C5QVmgDUNpeiHBzoVU50bFqhITm/dvI=;
	h=MIME-Version:Date:Message-ID:Subject:From:To:Content-Type; b=kBnkyTJB1YLKFnzTYI1HJJhP1DBUz6397tS5OV841Z4VhT5rBsn9Wb8LmIttvb2AU0NvnoXHH+CR1JeNm8ePxhTSSeqnVI6lO8w3JQlQ65akdyUoWy+Ot08FAHgbJgpBjISK2QOJi/HYxhn1ZGRS3yUUDq45lJ8BEk4pY2ypveU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=fail (p=none dis=none) header.from=syzkaller.appspotmail.com; spf=pass smtp.mailfrom=M3KW2WVRGUFZ5GODRSRYTGD7.apphosting.bounces.google.com; arc=none smtp.client-ip=209.85.166.205
Authentication-Results: smtp.subspace.kernel.org; dmarc=fail (p=none dis=none) header.from=syzkaller.appspotmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=M3KW2WVRGUFZ5GODRSRYTGD7.apphosting.bounces.google.com
Received: by mail-il1-f205.google.com with SMTP id e9e14a558f8ab-3da76423b9cso40423045ab.0
        for <io-uring@vger.kernel.org>; Sat, 10 May 2025 17:19:22 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1746922762; x=1747527562;
        h=to:from:subject:message-id:date:mime-version:x-gm-message-state
         :from:to:cc:subject:date:message-id:reply-to;
        bh=HzRgQZqA6gXuY7HDluzT2btHJzutmkSAmtPUfQjNVFU=;
        b=DCSFF+ZP1vFGfyr8itZr7oXcYDRybGWOuJmGcRptuGxUZjYjFQsuGzV73/V97I/mSX
         vXLLZwHRMqLuOU4N0TbKE7G/oUMFysBzGacjjwy2SAMNKABjRhTrvwxVXv6cRk58Ivt7
         ujSAAPx5dB/0lq2YG2p/TspxbsQsMWxiB/o20IkeaEH99nY1mbxfq4XO5pnC/+4elkvO
         hh7GuEu1QwwuGanN5X7N/Tl7FiGyQTtzwqQOLpPJsP7KFq4RRQBiDCMm9qajyAFJTeFg
         VYouJp5BK8VUca++IE2cHhoEtjSGuWDDybVwGQlIuxH8vIZhx1UX9dVEvIJ1Oo5MBoWY
         ceTQ==
X-Forwarded-Encrypted: i=1; AJvYcCVjXCbsSZnprvlDG/81IOFzWnHuzkfRWhvsooyDvvCMLeBlsRao9kHM/3JiWVDly0uPe29jBIC84w==@vger.kernel.org
X-Gm-Message-State: AOJu0YzAcZhNRijSq2qXIL1w6qumTw0yhokvTYzDHMWAptfAJkGeUZe7
	g2g3bgeD9WZxmayS/+TiPTta2VhY7dcd71aAtQIUFF3N5iFHydYgdM3WvYBb8UgX/SqgjPt5cYj
	vWQKtPl6BCAT2MPEa+dFDfDvIqRH4Zm3PZ6pwkMrRheEZAglFS+LM0Eo=
X-Google-Smtp-Source: AGHT+IHskAVgUbMbI6+49o73PLsFSiex1auVB8/pc5F4mLM4Oa0Ix+SdMsa9372wGjIP8CRUSzn8TN/cua37iySXTkX4jOgIdZgF
Precedence: bulk
X-Mailing-List: io-uring@vger.kernel.org
List-Id: <io-uring.vger.kernel.org>
List-Subscribe: <mailto:io-uring+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:io-uring+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-Received: by 2002:a05:6e02:2282:b0:3d6:cbed:330c with SMTP id
 e9e14a558f8ab-3da7e1efc2amr91102345ab.11.1746922762341; Sat, 10 May 2025
 17:19:22 -0700 (PDT)
Date: Sat, 10 May 2025 17:19:22 -0700
X-Google-Appengine-App-Id: s~syzkaller
X-Google-Appengine-App-Id-Alias: syzkaller
Message-ID: <681fed0a.050a0220.f2294.001c.GAE@google.com>
Subject: [syzbot] [io-uring?] BUG: unable to handle kernel NULL pointer
 dereference in io_buffer_select
From: syzbot <syzbot+6456a99dfdc2e78c4feb@syzkaller.appspotmail.com>
To: asml.silence@gmail.com, axboe@kernel.dk, io-uring@vger.kernel.org, 
	linux-kernel@vger.kernel.org, syzkaller-bugs@googlegroups.com
Content-Type: text/plain; charset="UTF-8"

Hello,

syzbot found the following issue on:

HEAD commit:    0d8d44db295c Merge tag 'for-6.15-rc5-tag' of git://git.ker..
git tree:       upstream
console output: https://syzkaller.appspot.com/x/log.txt?x=12df282f980000
kernel config:  https://syzkaller.appspot.com/x/.config?x=925afd2bdd38a581
dashboard link: https://syzkaller.appspot.com/bug?extid=6456a99dfdc2e78c4feb
compiler:       arm-linux-gnueabi-gcc (Debian 12.2.0-14) 12.2.0, GNU ld (GNU Binutils for Debian) 2.40
userspace arch: arm
syz repro:      https://syzkaller.appspot.com/x/repro.syz?x=150338f4580000
C reproducer:   https://syzkaller.appspot.com/x/repro.c?x=143984f4580000

Downloadable assets:
disk image (non-bootable): https://storage.googleapis.com/syzbot-assets/98a89b9f34e4/non_bootable_disk-0d8d44db.raw.xz
vmlinux: https://storage.googleapis.com/syzbot-assets/f2af76a30640/vmlinux-0d8d44db.xz
kernel image: https://storage.googleapis.com/syzbot-assets/a0bb41cd257b/zImage-0d8d44db.xz

IMPORTANT: if you fix the issue, please add the following tag to the commit:
Reported-by: syzbot+6456a99dfdc2e78c4feb@syzkaller.appspotmail.com

Unable to handle kernel NULL pointer dereference at virtual address 0000000e when read
[0000000e] *pgd=84797003, *pmd=df777003
Internal error: Oops: 205 [#1] SMP ARM
Modules linked in:
CPU: 1 UID: 0 PID: 3105 Comm: syz-executor192 Not tainted 6.15.0-rc5-syzkaller #0 PREEMPT 
Hardware name: ARM-Versatile Express
PC is at io_ring_buffer_select io_uring/kbuf.c:163 [inline]
PC is at io_buffer_select+0x50/0x18c io_uring/kbuf.c:207
LR is at rcu_read_unlock include/linux/rcupdate.h:873 [inline]
LR is at xa_load+0x68/0xa4 lib/xarray.c:1621
pc : [<80889a10>]    lr : [<81a4be54>]    psr: 20000013
sp : df985e18  ip : df985dd8  fp : df985e34
r10: 837a6c80  r9 : 00000000  r8 : 80000001
r7 : df985e50  r6 : 00000000  r5 : 841f2900  r4 : 84799000
r3 : 00000001  r2 : 00000000  r1 : 846eb500  r0 : 00000000
Flags: nzCv  IRQs on  FIQs on  Mode SVC_32  ISA ARM  Segment none
Control: 30c5387d  Table: 84731880  DAC: 00000000
Register r0 information: NULL pointer
Register r1 information: slab kmalloc-64 start 846eb500 pointer offset 0 size 64
Register r2 information: NULL pointer
Register r3 information: non-paged memory
Register r4 information: slab io_kiocb start 84799000 pointer offset 0 size 192
Register r5 information: slab kmalloc-2k start 841f2800 pointer offset 256 size 2048
Register r6 information: NULL pointer
Register r7 information: 2-page vmalloc region starting at 0xdf984000 allocated at kernel_clone+0xac/0x3e4 kernel/fork.c:2844
Register r8 information: non-slab/vmalloc memory
Register r9 information: NULL pointer
Register r10 information: slab sock_inode_cache start 837a6c80 pointer offset 0 size 576
Register r11 information: 2-page vmalloc region starting at 0xdf984000 allocated at kernel_clone+0xac/0x3e4 kernel/fork.c:2844
Register r12 information: 2-page vmalloc region starting at 0xdf984000 allocated at kernel_clone+0xac/0x3e4 kernel/fork.c:2844
Process syz-executor192 (pid: 3105, stack limit = 0xdf984000)
Stack: (0xdf985e18 to 0xdf986000)
5e00:                                                       84799000 8466a500
5e20: 00000000 00000040 df985e84 df985e38 80892d3c 808899cc 8057abbc 8030cb0c
5e40: 84799000 00000001 01799000 00000000 00000000 c8c55b45 80886a40 84799000
5e60: 81cf0bd4 00000000 80000001 81cf0b5c 0000000a 8402bc00 df985ebc df985e88
5e80: 80886df4 80892b18 00000000 00000000 00000000 841f2800 8479906c 84799000
5ea0: 848c0000 00000000 00000000 8402bc00 df985f14 df985ec0 808877a8 80886b7c
5ec0: 8088e164 81a4bdf8 8479adb8 84731888 00000001 00000001 81cf0b5c 00000001
5ee0: 841f2800 c8c55b45 84786240 00000000 841f2800 000027e2 84786240 00000000
5f00: 8402bc00 00000000 df985fa4 df985f18 80888250 808875a8 df985f74 841f2840
5f20: 00000000 00000000 df985fac df985f38 8022b8b8 8046ec28 df985f64 df985f48
5f40: 8057a6bc 84460c00 00000000 8281d1f0 00000a0f 76f4a000 df985fb0 80234108
5f60: 00000000 000f4240 df985fac df985f78 8023478c c8c55b45 000000c0 00000000
5f80: 00000000 0008e068 000001aa 8020029c 8402bc00 000001aa 00000000 df985fa8
5fa0: 80200060 80888124 00000000 00000000 00000003 000027e2 00000000 00000000
5fc0: 00000000 00000000 0008e068 000001aa 00000001 00000000 000f4240 00000000
5fe0: 7ef9ac70 7ef9ac60 0001088c 0002f900 40000010 00000003 00000000 00000000
Call trace: 
[<808899c0>] (io_buffer_select) from [<80892d3c>] (io_recvmsg+0x230/0x420 io_uring/net.c:988)
 r7:00000040 r6:00000000 r5:8466a500 r4:84799000
[<80892b0c>] (io_recvmsg) from [<80886df4>] (__io_issue_sqe io_uring/io_uring.c:1740 [inline])
[<80892b0c>] (io_recvmsg) from [<80886df4>] (io_issue_sqe+0x284/0x658 io_uring/io_uring.c:1759)
 r10:8402bc00 r9:0000000a r8:81cf0b5c r7:80000001 r6:00000000 r5:81cf0bd4
 r4:84799000
[<80886b70>] (io_issue_sqe) from [<808877a8>] (io_queue_sqe io_uring/io_uring.c:1975 [inline])
[<80886b70>] (io_issue_sqe) from [<808877a8>] (io_submit_sqe io_uring/io_uring.c:2231 [inline])
[<80886b70>] (io_issue_sqe) from [<808877a8>] (io_submit_sqes+0x20c/0x938 io_uring/io_uring.c:2348)
 r10:8402bc00 r9:00000000 r8:00000000 r7:848c0000 r6:84799000 r5:8479906c
 r4:841f2800
[<8088759c>] (io_submit_sqes) from [<80888250>] (__do_sys_io_uring_enter io_uring/io_uring.c:3408 [inline])
[<8088759c>] (io_submit_sqes) from [<80888250>] (sys_io_uring_enter+0x138/0x780 io_uring/io_uring.c:3342)
 r10:00000000 r9:8402bc00 r8:00000000 r7:84786240 r6:000027e2 r5:841f2800
 r4:00000000
[<80888118>] (sys_io_uring_enter) from [<80200060>] (ret_fast_syscall+0x0/0x1c arch/arm/mm/proc-v7.S:67)
Exception stack(0xdf985fa8 to 0xdf985ff0)
5fa0:                   00000000 00000000 00000003 000027e2 00000000 00000000
5fc0: 00000000 00000000 0008e068 000001aa 00000001 00000000 000f4240 00000000
5fe0: 7ef9ac70 7ef9ac60 0001088c 0002f900
 r10:000001aa r9:8402bc00 r8:8020029c r7:000001aa r6:0008e068 r5:00000000
 r4:00000000
Code: e3130001 0a00002f e5910000 e1d120be (e1d030be) 
---[ end trace 0000000000000000 ]---
----------------
Code disassembly (best guess):
   0:	e3130001 	tst	r3, #1
   4:	0a00002f 	beq	0xc8
   8:	e5910000 	ldr	r0, [r1]
   c:	e1d120be 	ldrh	r2, [r1, #14]
* 10:	e1d030be 	ldrh	r3, [r0, #14] <-- trapping instruction


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

