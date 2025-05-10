Return-Path: <io-uring+bounces-7939-lists+io-uring=lfdr.de@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from sy.mirrors.kernel.org (sy.mirrors.kernel.org [147.75.48.161])
	by mail.lfdr.de (Postfix) with ESMTPS id C9E40AB25BC
	for <lists+io-uring@lfdr.de>; Sun, 11 May 2025 01:36:36 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sy.mirrors.kernel.org (Postfix) with ESMTPS id 7EFFC7B0B65
	for <lists+io-uring@lfdr.de>; Sat, 10 May 2025 23:35:21 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 9072015E96;
	Sat, 10 May 2025 23:36:30 +0000 (UTC)
X-Original-To: io-uring@vger.kernel.org
Received: from mail-il1-f207.google.com (mail-il1-f207.google.com [209.85.166.207])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A856019C556
	for <io-uring@vger.kernel.org>; Sat, 10 May 2025 23:36:28 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.166.207
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1746920190; cv=none; b=UtSxA6ht1UR/MFdgqzsV8s4vstkFDyOUDwJhGmXZaso2N4o/Ah5QLUfgbYZzWZVOgtT839uz3fOa+PARqJ1FkTOL35NF+trdNbD3WQJAtlkdCLyNjwHjrr4tEF1mifJ1sLl5rByGGgWDHj/uADXgJ6JEgRU5cdwlRtBFR6jlpVk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1746920190; c=relaxed/simple;
	bh=nhd1BIQqUw9sM1KdyJI6OM7qVmHO1GVGYA/ycl8n8CY=;
	h=MIME-Version:Date:Message-ID:Subject:From:To:Content-Type; b=TLR+gUhpNLiK+8l61TtjyTd8aEI4mCCO680KErEdzOOtW0vyz1a2lG43bcr3tA0yACJtZAudJ0g4KX1n5GiboFtwneRVeEt6181sn4S4ddwoJXwUQFDYRKN/wOe/pMHHa6RsM7Y8UAQHOirb9fKwAaqMe4sKEtJQwAdaIqZxMvQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=fail (p=none dis=none) header.from=syzkaller.appspotmail.com; spf=pass smtp.mailfrom=M3KW2WVRGUFZ5GODRSRYTGD7.apphosting.bounces.google.com; arc=none smtp.client-ip=209.85.166.207
Authentication-Results: smtp.subspace.kernel.org; dmarc=fail (p=none dis=none) header.from=syzkaller.appspotmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=M3KW2WVRGUFZ5GODRSRYTGD7.apphosting.bounces.google.com
Received: by mail-il1-f207.google.com with SMTP id e9e14a558f8ab-3d91a0d3e15so35716935ab.2
        for <io-uring@vger.kernel.org>; Sat, 10 May 2025 16:36:28 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1746920187; x=1747524987;
        h=to:from:subject:message-id:date:mime-version:x-gm-message-state
         :from:to:cc:subject:date:message-id:reply-to;
        bh=jnbq8VH5wB43oH4o1F7g/3iQ9AWJHMQBNtcAuCJTTH4=;
        b=HhO1CYuWD3g44By3OVERSZcMdTKBDYG79cOpGJEmu1nzxuLrEVAzeoQ5t7R9iVlLZA
         Z+xF/5+XcHRmkzAPrIA91jehff13ck3TB/fZhoB3m51mu/J8FT4YVZdoJq8LbrzZyTcz
         84H7HlLUA9iXruUhiza3rlbnIxoehckMDnFU7jWYpVZg3ffYVbRB98dJUHxMQ+e3SFzW
         DN7+4LqN/4O5etXUG9cpVZFuHz7GfwZ+Va3+1AXDiywGHAeZPdDOvh9sSPE64R4xri7B
         tYd0RjEJ63BUEovWukTboaYKP65CmhR/VaGWqVHfv+gAfOR+dsK1aqPKBcaJ3uRGXAd2
         R9uA==
X-Forwarded-Encrypted: i=1; AJvYcCW73+6m9vALuB7fKOvQuVZP1XBZ7qtzGeP81ZML2C2uhjrKdtJwxstncddnoR5ZcJOmYqz7Yd/Idw==@vger.kernel.org
X-Gm-Message-State: AOJu0Yxt86K2mWHREUctPn5NRi5RlLQMVFke5xWTDG5hG4v3I4jw5o/K
	lCnF2B3AeTu2AKfKNoCkTwenqTVqUNxx/gV2y3KwaXM+dXD6JTUClcWeCMywE+NW1xuBG1NaqR2
	btkgE1xtDIjjLRsHXIgtsaaOxODqLEDXTgVK1sqBeG8s0gsA9bw911/k=
X-Google-Smtp-Source: AGHT+IEWO8Wk2iEyeVOZB8Az2t48YFJpUGjpsS2nsP6tx2BE49SAfe2Wv86vPSr+2Mn/Fk9BSQKANWFOcr+uyINERbEf7ka2G1L2
Precedence: bulk
X-Mailing-List: io-uring@vger.kernel.org
List-Id: <io-uring.vger.kernel.org>
List-Subscribe: <mailto:io-uring+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:io-uring+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-Received: by 2002:a05:6e02:12cb:b0:3d3:f27a:9103 with SMTP id
 e9e14a558f8ab-3da7e1e26camr110347245ab.1.1746920187534; Sat, 10 May 2025
 16:36:27 -0700 (PDT)
Date: Sat, 10 May 2025 16:36:27 -0700
X-Google-Appengine-App-Id: s~syzkaller
X-Google-Appengine-App-Id-Alias: syzkaller
Message-ID: <681fe2fb.050a0220.f2294.001a.GAE@google.com>
Subject: [syzbot] [io-uring?] BUG: unable to handle kernel NULL pointer
 dereference in io_ring_buffers_peek
From: syzbot <syzbot+5b8c4abafcb1d791ccfc@syzkaller.appspotmail.com>
To: asml.silence@gmail.com, axboe@kernel.dk, io-uring@vger.kernel.org, 
	linux-kernel@vger.kernel.org, syzkaller-bugs@googlegroups.com
Content-Type: text/plain; charset="UTF-8"

Hello,

syzbot found the following issue on:

HEAD commit:    0d8d44db295c Merge tag 'for-6.15-rc5-tag' of git://git.ker..
git tree:       upstream
console output: https://syzkaller.appspot.com/x/log.txt?x=179f282f980000
kernel config:  https://syzkaller.appspot.com/x/.config?x=925afd2bdd38a581
dashboard link: https://syzkaller.appspot.com/bug?extid=5b8c4abafcb1d791ccfc
compiler:       arm-linux-gnueabi-gcc (Debian 12.2.0-14) 12.2.0, GNU ld (GNU Binutils for Debian) 2.40
userspace arch: arm
syz repro:      https://syzkaller.appspot.com/x/repro.syz?x=10d984f4580000
C reproducer:   https://syzkaller.appspot.com/x/repro.c?x=1774339b980000

Downloadable assets:
disk image (non-bootable): https://storage.googleapis.com/syzbot-assets/98a89b9f34e4/non_bootable_disk-0d8d44db.raw.xz
vmlinux: https://storage.googleapis.com/syzbot-assets/f2af76a30640/vmlinux-0d8d44db.xz
kernel image: https://storage.googleapis.com/syzbot-assets/a0bb41cd257b/zImage-0d8d44db.xz

IMPORTANT: if you fix the issue, please add the following tag to the commit:
Reported-by: syzbot+5b8c4abafcb1d791ccfc@syzkaller.appspotmail.com

8<--- cut here ---
Unable to handle kernel NULL pointer dereference at virtual address 0000000e when read
[0000000e] *pgd=84997003, *pmd=df9a9003
Internal error: Oops: 205 [#1] SMP ARM
Modules linked in:
CPU: 0 UID: 0 PID: 3102 Comm: syz-executor415 Not tainted 6.15.0-rc5-syzkaller #0 PREEMPT 
Hardware name: ARM-Versatile Express
PC is at io_ring_buffers_peek+0x24/0x258 io_uring/kbuf.c:227
LR is at io_buffers_peek+0x68/0x8c io_uring/kbuf.c:343
pc : [<8088956c>]    lr : [<80889cb0>]    psr: 20000013
sp : df991dc0  ip : df991e08  fp : df991e04
r10: 00012361  r9 : 00000000  r8 : 8498d740
r7 : 84498a0c  r6 : 84498a00  r5 : df991e44  r4 : 84995000
r3 : 00000001  r2 : 84498a0c  r1 : df991e44  r0 : 84995000
Flags: nzCv  IRQs on  FIQs on  Mode SVC_32  ISA ARM  Segment user
Control: 30c5387d  Table: 845f43c0  DAC: fffffffd
Register r0 information: slab io_kiocb start 84995000 pointer offset 0 size 192
Register r1 information: 2-page vmalloc region starting at 0xdf990000 allocated at kernel_clone+0xac/0x3e4 kernel/fork.c:2844
Register r2 information: slab kmalloc-256 start 84498a00 pointer offset 12 size 256
Register r3 information: non-paged memory
Register r4 information: slab io_kiocb start 84995000 pointer offset 0 size 192
Register r5 information: 2-page vmalloc region starting at 0xdf990000 allocated at kernel_clone+0xac/0x3e4 kernel/fork.c:2844
Register r6 information: slab kmalloc-256 start 84498a00 pointer offset 0 size 256
Register r7 information: slab kmalloc-256 start 84498a00 pointer offset 12 size 256
Register r8 information: slab kmalloc-64 start 8498d740 pointer offset 0 size 64
Register r9 information: NULL pointer
Register r10 information: non-paged memory
Register r11 information: 2-page vmalloc region starting at 0xdf990000 allocated at kernel_clone+0xac/0x3e4 kernel/fork.c:2844
Register r12 information: 2-page vmalloc region starting at 0xdf990000 allocated at kernel_clone+0xac/0x3e4 kernel/fork.c:2844
Process syz-executor415 (pid: 3102, stack limit = 0xdf990000)
Stack: (0xdf991dc0 to 0xdf992000)
1dc0: 81a4be54 8030cb0c 8495d100 00000001 00010000 84498a0c 00000000 84995000
1de0: df991e44 84498a00 84498a0c 00000000 80000001 00012361 df991e1c df991e08
1e00: 80889cb0 80889554 837e3b80 84995000 df991e84 df991e20 808931e0 80889c54
1e20: df991e4c df991e30 8089ec2c 8050a4c4 00010001 00000001 8057abbc 00000000
1e40: 00000000 84498a0c 00000000 00000000 00010001 7df2f2e8 80886a40 84995000
1e60: 81cf0ca0 00000000 80000001 81cf0b5c 0000001b 83b4ec00 df991ebc df991e88
1e80: 80886bd8 80892f38 849953c0 84995480 84995540 8495d000 8499506c 84995000
1ea0: 84ae0000 00000000 00000000 83b4ec00 df991f14 df991ec0 808877a8 80886b7c
1ec0: 8088e164 81a4bdf8 8499bdb8 845f43c8 00000800 00000800 81cf0b5c 00000800
1ee0: 8495d000 7df2f2e8 840ae0c0 00000042 8495d000 00003517 840ae0c0 00000000
1f00: 83b4ec00 00000000 df991fa4 df991f18 80888250 808875a8 df991f74 8495d040
1f20: 00000000 0000173d 840ae000 00000000 df991f94 df991f40 8151ae48 8057a670
1f40: df991f60 84404000 00000000 8281d1f0 00000a0f 76f57000 df991fb0 80234108
1f60: 20000280 00000000 df991fac df991f78 8023478c 7df2f2e8 00000120 00000000
1f80: 00000000 0008e068 000001aa 8020029c 83b4ec00 000001aa 00000000 df991fa8
1fa0: 80200060 80888124 00000000 00000000 00000003 00003517 0000173d 00000042
1fc0: 00000000 00000000 0008e068 000001aa 20000080 20000280 00000000 00000000
1fe0: 7e8b7c70 7e8b7c60 00010874 0002f900 40000010 00000003 00000000 00000000
Call trace: 
[<80889548>] (io_ring_buffers_peek) from [<80889cb0>] (io_buffers_peek+0x68/0x8c io_uring/kbuf.c:343)
 r10:00012361 r9:80000001 r8:00000000 r7:84498a0c r6:84498a00 r5:df991e44
 r4:84995000
[<80889c48>] (io_buffers_peek) from [<808931e0>] (io_recv_buf_select io_uring/net.c:1077 [inline])
[<80889c48>] (io_buffers_peek) from [<808931e0>] (io_recv+0x2b4/0x46c io_uring/net.c:1138)
 r5:84995000 r4:837e3b80
[<80892f2c>] (io_recv) from [<80886bd8>] (__io_issue_sqe io_uring/io_uring.c:1740 [inline])
[<80892f2c>] (io_recv) from [<80886bd8>] (io_issue_sqe+0x68/0x658 io_uring/io_uring.c:1759)
 r10:83b4ec00 r9:0000001b r8:81cf0b5c r7:80000001 r6:00000000 r5:81cf0ca0
 r4:84995000
[<80886b70>] (io_issue_sqe) from [<808877a8>] (io_queue_sqe io_uring/io_uring.c:1975 [inline])
[<80886b70>] (io_issue_sqe) from [<808877a8>] (io_submit_sqe io_uring/io_uring.c:2231 [inline])
[<80886b70>] (io_issue_sqe) from [<808877a8>] (io_submit_sqes+0x20c/0x938 io_uring/io_uring.c:2348)
 r10:83b4ec00 r9:00000000 r8:00000000 r7:84ae0000 r6:84995000 r5:8499506c
 r4:8495d000
[<8088759c>] (io_submit_sqes) from [<80888250>] (__do_sys_io_uring_enter io_uring/io_uring.c:3408 [inline])
[<8088759c>] (io_submit_sqes) from [<80888250>] (sys_io_uring_enter+0x138/0x780 io_uring/io_uring.c:3342)
 r10:00000000 r9:83b4ec00 r8:00000000 r7:840ae0c0 r6:00003517 r5:8495d000
 r4:00000042
[<80888118>] (sys_io_uring_enter) from [<80200060>] (ret_fast_syscall+0x0/0x1c arch/arm/mm/proc-v7.S:67)
Exception stack(0xdf991fa8 to 0xdf991ff0)
1fa0:                   00000000 00000000 00000003 00003517 0000173d 00000042
1fc0: 00000000 00000000 0008e068 000001aa 20000080 20000280 00000000 00000000
1fe0: 7e8b7c70 7e8b7c60 00010874 0002f900
 r10:000001aa r9:83b4ec00 r8:8020029c r7:000001aa r6:0008e068 r5:00000000
 r4:00000000
Code: e1a08002 e5912000 e50b2030 e1a05001 (e1d920be) 
---[ end trace 0000000000000000 ]---
----------------
Code disassembly (best guess):
   0:	e1a08002 	mov	r8, r2
   4:	e5912000 	ldr	r2, [r1]
   8:	e50b2030 	str	r2, [fp, #-48]	@ 0xffffffd0
   c:	e1a05001 	mov	r5, r1
* 10:	e1d920be 	ldrh	r2, [r9, #14] <-- trapping instruction


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

