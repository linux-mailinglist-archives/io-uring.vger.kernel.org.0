Return-Path: <io-uring+bounces-1364-lists+io-uring=lfdr.de@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [IPv6:2604:1380:45d1:ec00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 0E4BF895B2C
	for <lists+io-uring@lfdr.de>; Tue,  2 Apr 2024 19:54:36 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id 325FE1C20C0D
	for <lists+io-uring@lfdr.de>; Tue,  2 Apr 2024 17:54:35 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id A7AB315AAC9;
	Tue,  2 Apr 2024 17:54:27 +0000 (UTC)
X-Original-To: io-uring@vger.kernel.org
Received: from mail-io1-f71.google.com (mail-io1-f71.google.com [209.85.166.71])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id DEFF415AABA
	for <io-uring@vger.kernel.org>; Tue,  2 Apr 2024 17:54:25 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.166.71
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1712080467; cv=none; b=oTEWQBvRxCT1AWi5EUBzBcPY0w1uYw8VTmYbzHMgMMOqilMLQPdRGt/oiGcPjS+9CmVtksK+WuQN6vmlmFNJLBYKg1RntK0cn1Ld4OsjiM+Qb0caozC38qdCQIQCBCmCKlVJrrse6rMkr3U2GcVwhZOVNm3yoGo31hWCtAy1H6Y=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1712080467; c=relaxed/simple;
	bh=An2Jp3BeEqpuw0kXtMrC3J6wpoU/Nui+LmIiPsH/Ax0=;
	h=MIME-Version:Date:Message-ID:Subject:From:To:Content-Type; b=ZetKkg0TTyWPA4o66XNT3Psq7Nkk/2Hk5/gJxHkFchX/ffWPPJdCnYOGZQJxJFZ3am8HXrXiiIKZmKpR3djYbcu+bRl/sMILPSQ0nvB7t3rN7dWIPkmIKFdlgtWmszUsiNJcklNv1inbdDnrPxYjYGSDW11tWX5dKRUxO8Wx3pU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=fail (p=none dis=none) header.from=syzkaller.appspotmail.com; spf=pass smtp.mailfrom=M3KW2WVRGUFZ5GODRSRYTGD7.apphosting.bounces.google.com; arc=none smtp.client-ip=209.85.166.71
Authentication-Results: smtp.subspace.kernel.org; dmarc=fail (p=none dis=none) header.from=syzkaller.appspotmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=M3KW2WVRGUFZ5GODRSRYTGD7.apphosting.bounces.google.com
Received: by mail-io1-f71.google.com with SMTP id ca18e2360f4ac-7c8742bedd4so8356039f.1
        for <io-uring@vger.kernel.org>; Tue, 02 Apr 2024 10:54:25 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1712080465; x=1712685265;
        h=to:from:subject:message-id:date:mime-version:x-gm-message-state
         :from:to:cc:subject:date:message-id:reply-to;
        bh=dneoHgsX3nsgd/CBqL8Tb4EZ1x6rRPwypobUWP/z48I=;
        b=lLStWxqhhJ/gW8X+wY5bOeLvSWu99Yak/8SEfszbI3bOS6AoRkZF+Du3GKvrzg/7xe
         Kd0uTKocGQc+YzTY6xWSv3FITVMU+37pQvmSAE6SXAivNun58OOyxaytgcmMIk/rwrYB
         yksbJKN2BRYMBSyhg+vVkYkeBQ8iFPKNp4jEYn0W7pgzRWLSgZ17NqEmVcq+mN87Qian
         gV6YmxuCzZ2PgmsZg4kdikQmDBaSAMBrROUW1o75Sm+XYutaZZOgn4M5MUoG8U0PwEHT
         C/4RDOR4jkJIM+ppemNQQHm17e+Gd3zFxCAyez8wRISrnHUBkbSl50Ti8kwSWKkUDv6W
         bi4A==
X-Forwarded-Encrypted: i=1; AJvYcCV3JVbeQ9nQcjZX4r10XaNi/M6ZahHSJ1bVs7G4lnVcWn5bCA+uU4YLGdY14Q6EzffDrsSp35egerS1FAhxB35OWI/Pzjq07NE=
X-Gm-Message-State: AOJu0Yz7uwh1xHn+JcPk4zTSOPa9v0L9ikZL5aTQo7apTxFK64ImpBZQ
	aMed4vcfsAoOp3RqlRbaIfgteq7nUY1txDdLaaLDh6ixK6jSonmX1XOO8uklHcC2RMcp96ydsuj
	uMFY42NT9sXgpNIetW0pUFw155Jb7iRRjO/zyQCB0UmoHpkja/Pdnywg=
X-Google-Smtp-Source: AGHT+IFrncUXVW+v64ArE/rJ/le2TPQWM4rWPuCk1FkWHuD/NK956lQ1eZaw9GTQPH60b83cSh0aDKkzHdYNLI6OxXfRz/FFMdVr
Precedence: bulk
X-Mailing-List: io-uring@vger.kernel.org
List-Id: <io-uring.vger.kernel.org>
List-Subscribe: <mailto:io-uring+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:io-uring+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-Received: by 2002:a05:6e02:1c86:b0:366:b246:2f10 with SMTP id
 w6-20020a056e021c8600b00366b2462f10mr11956ill.2.1712080465159; Tue, 02 Apr
 2024 10:54:25 -0700 (PDT)
Date: Tue, 02 Apr 2024 10:54:25 -0700
X-Google-Appengine-App-Id: s~syzkaller
X-Google-Appengine-App-Id-Alias: syzkaller
Message-ID: <000000000000f3f1ef061520cb6e@google.com>
Subject: [syzbot] [io-uring?] kernel BUG in __io_remove_buffers
From: syzbot <syzbot+beb5226eef6218124e9d@syzkaller.appspotmail.com>
To: asml.silence@gmail.com, axboe@kernel.dk, io-uring@vger.kernel.org, 
	linux-kernel@vger.kernel.org, syzkaller-bugs@googlegroups.com
Content-Type: text/plain; charset="UTF-8"

Hello,

syzbot found the following issue on:

HEAD commit:    c0b832517f62 Add linux-next specific files for 20240402
git tree:       linux-next
console+strace: https://syzkaller.appspot.com/x/log.txt?x=12d5def9180000
kernel config:  https://syzkaller.appspot.com/x/.config?x=afcaf46d374cec8c
dashboard link: https://syzkaller.appspot.com/bug?extid=beb5226eef6218124e9d
compiler:       Debian clang version 15.0.6, GNU ld (GNU Binutils for Debian) 2.40
syz repro:      https://syzkaller.appspot.com/x/repro.syz?x=1155ccc5180000
C reproducer:   https://syzkaller.appspot.com/x/repro.c?x=14b06795180000

Downloadable assets:
disk image: https://storage.googleapis.com/syzbot-assets/0d36ec76edc7/disk-c0b83251.raw.xz
vmlinux: https://storage.googleapis.com/syzbot-assets/6f9bb4e37dd0/vmlinux-c0b83251.xz
kernel image: https://storage.googleapis.com/syzbot-assets/2349287b14b7/bzImage-c0b83251.xz

IMPORTANT: if you fix the issue, please add the following tag to the commit:
Reported-by: syzbot+beb5226eef6218124e9d@syzkaller.appspotmail.com

 ret_from_fork+0x4b/0x80 arch/x86/kernel/process.c:147
 ret_from_fork_asm+0x1a/0x30 arch/x86/entry/entry_64.S:243
------------[ cut here ]------------
kernel BUG at include/linux/mm.h:1135!
Oops: invalid opcode: 0000 [#1] PREEMPT SMP KASAN PTI
CPU: 0 PID: 12 Comm: kworker/u8:1 Not tainted 6.9.0-rc2-next-20240402-syzkaller #0
Hardware name: Google Google Compute Engine/Google Compute Engine, BIOS Google 03/27/2024
Workqueue: events_unbound io_ring_exit_work
RIP: 0010:put_page_testzero include/linux/mm.h:1135 [inline]
RIP: 0010:folio_put_testzero include/linux/mm.h:1141 [inline]
RIP: 0010:folio_put include/linux/mm.h:1508 [inline]
RIP: 0010:put_page include/linux/mm.h:1581 [inline]
RIP: 0010:__io_remove_buffers+0x8ee/0x8f0 io_uring/kbuf.c:196
Code: ff fb ff ff 48 c7 c7 3c 68 a9 8f e8 fc b6 56 fd e9 ee fb ff ff e8 12 dc f1 fc 48 89 ef 48 c7 c6 60 ff 1e 8c e8 13 20 3b fd 90 <0f> 0b 90 90 90 90 90 90 90 90 90 90 90 90 90 90 90 90 f3 0f 1e fa
RSP: 0018:ffffc90000117830 EFLAGS: 00010246
RAX: 12798bbc5474ca00 RBX: 0000000000000000 RCX: 0000000000000001
RDX: dffffc0000000000 RSI: ffffffff8bcad5c0 RDI: 0000000000000001
RBP: ffffea0000880c40 R08: ffffffff92f3a5ef R09: 1ffffffff25e74bd
R10: dffffc0000000000 R11: fffffbfff25e74be R12: 0000000000000008
R13: 0000000000000002 R14: ffff88802d20d280 R15: ffffea0000880c74
FS:  0000000000000000(0000) GS:ffff8880b9400000(0000) knlGS:0000000000000000
CS:  0010 DS: 0000 ES: 0000 CR0: 0000000080050033
CR2: 00000000200020c4 CR3: 000000007d97a000 CR4: 00000000003506f0
DR0: 0000000000000000 DR1: 0000000000000000 DR2: 0000000000000000
DR3: 0000000000000000 DR6: 00000000fffe0ff0 DR7: 0000000000000400
Call Trace:
 <TASK>
 io_put_bl io_uring/kbuf.c:229 [inline]
 io_destroy_buffers+0x14e/0x490 io_uring/kbuf.c:243
 io_ring_ctx_free+0x818/0xe70 io_uring/io_uring.c:2710
 io_ring_exit_work+0x7c7/0x850 io_uring/io_uring.c:2941
 process_one_work kernel/workqueue.c:3218 [inline]
 process_scheduled_works+0xa2c/0x1830 kernel/workqueue.c:3299
 worker_thread+0x86d/0xd70 kernel/workqueue.c:3380
 kthread+0x2f0/0x390 kernel/kthread.c:388
 ret_from_fork+0x4b/0x80 arch/x86/kernel/process.c:147
 ret_from_fork_asm+0x1a/0x30 arch/x86/entry/entry_64.S:243
 </TASK>
Modules linked in:
---[ end trace 0000000000000000 ]---
RIP: 0010:put_page_testzero include/linux/mm.h:1135 [inline]
RIP: 0010:folio_put_testzero include/linux/mm.h:1141 [inline]
RIP: 0010:folio_put include/linux/mm.h:1508 [inline]
RIP: 0010:put_page include/linux/mm.h:1581 [inline]
RIP: 0010:__io_remove_buffers+0x8ee/0x8f0 io_uring/kbuf.c:196
Code: ff fb ff ff 48 c7 c7 3c 68 a9 8f e8 fc b6 56 fd e9 ee fb ff ff e8 12 dc f1 fc 48 89 ef 48 c7 c6 60 ff 1e 8c e8 13 20 3b fd 90 <0f> 0b 90 90 90 90 90 90 90 90 90 90 90 90 90 90 90 90 f3 0f 1e fa
RSP: 0018:ffffc90000117830 EFLAGS: 00010246
RAX: 12798bbc5474ca00 RBX: 0000000000000000 RCX: 0000000000000001
RDX: dffffc0000000000 RSI: ffffffff8bcad5c0 RDI: 0000000000000001
RBP: ffffea0000880c40 R08: ffffffff92f3a5ef R09: 1ffffffff25e74bd
R10: dffffc0000000000 R11: fffffbfff25e74be R12: 0000000000000008
R13: 0000000000000002 R14: ffff88802d20d280 R15: ffffea0000880c74
FS:  0000000000000000(0000) GS:ffff8880b9500000(0000) knlGS:0000000000000000
CS:  0010 DS: 0000 ES: 0000 CR0: 0000000080050033
CR2: 00007f31a71870f0 CR3: 000000007930c000 CR4: 00000000003506f0
DR0: 0000000000000000 DR1: 0000000000000000 DR2: 0000000000000000
DR3: 0000000000000000 DR6: 00000000fffe0ff0 DR7: 0000000000000400


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

