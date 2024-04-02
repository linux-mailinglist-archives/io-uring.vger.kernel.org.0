Return-Path: <io-uring+bounces-1360-lists+io-uring=lfdr.de@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [IPv6:2604:1380:45d1:ec00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id B807C894DE2
	for <lists+io-uring@lfdr.de>; Tue,  2 Apr 2024 10:47:46 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id E5FAE1C22429
	for <lists+io-uring@lfdr.de>; Tue,  2 Apr 2024 08:47:45 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id A6A4145BF9;
	Tue,  2 Apr 2024 08:47:34 +0000 (UTC)
X-Original-To: io-uring@vger.kernel.org
Received: from mail-io1-f70.google.com (mail-io1-f70.google.com [209.85.166.70])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E83D554919
	for <io-uring@vger.kernel.org>; Tue,  2 Apr 2024 08:47:32 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.166.70
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1712047654; cv=none; b=sLV7P5tc527fuZZ7HYClJAEGh9+WcFxteK4IfZ+CeYaseZ3iXZwXngKl2h2rjQ7oN26S0V2r8yY1eG4mN/hYYYkqygxAHSW7jj0L8eItKa1Xf7AojfTScqdDygRyRVY7Hwo8ENQMS6o7WfM2JgzaYThcQ9yxGJb1G0b1y06qvGg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1712047654; c=relaxed/simple;
	bh=jEdGEcceCTXdnD5MjNTC9IVy5Ci49c298K9nYlZVnpw=;
	h=MIME-Version:Date:Message-ID:Subject:From:To:Content-Type; b=HIjWy59oNHpHZ8uNmGHiZdhBJfsTg0tsJiwFShoVtsBonzQpcYyVSIEhXJVXbtuD5Q/6SodXIMhn513jTqvt+r2H4c4CBfCH/hYiK9xEU1tVfq+gJxBOtwablxfAxO861RzK6mPZqLdIbRAsJSRW9JGnT+L4YDCmUvj4Wne3IqU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=fail (p=none dis=none) header.from=syzkaller.appspotmail.com; spf=pass smtp.mailfrom=M3KW2WVRGUFZ5GODRSRYTGD7.apphosting.bounces.google.com; arc=none smtp.client-ip=209.85.166.70
Authentication-Results: smtp.subspace.kernel.org; dmarc=fail (p=none dis=none) header.from=syzkaller.appspotmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=M3KW2WVRGUFZ5GODRSRYTGD7.apphosting.bounces.google.com
Received: by mail-io1-f70.google.com with SMTP id ca18e2360f4ac-7c8a98e52b5so413217739f.1
        for <io-uring@vger.kernel.org>; Tue, 02 Apr 2024 01:47:32 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1712047652; x=1712652452;
        h=to:from:subject:message-id:date:mime-version:x-gm-message-state
         :from:to:cc:subject:date:message-id:reply-to;
        bh=8HQuzIwBpCyt1IFYX7pol1lktCvpmrQQPU05Mw4nyFo=;
        b=lV+m3VWuxhuoULfisfTmDKPj45qzmXJiML96IOuodAQ12guG8Tyw/Ig3/J4ddbiZMx
         pz/SUjCMRGjtAs4DB7BU2TcIGWlZlXSciys/+9CuuERICY4RvleuLeaIoec+o+BHWWyo
         u1j4iVXER9o6peunGOkjDz9zAl95yhtQQ6WjDv0BD5TfE1xjhFzdj5zH1rbSxT0OCfyD
         nC3jhnhwX9qWn82QwPTp8bPiDpkeBLZ5WANLDFFNEUZgimIIJH4zA6avvwex5glM1FXG
         bHpRdPS2lLlte5TogL8KzAM48hVPI0cf9uvzxDaX/xaVns/viSpj8qcTC9M/vHMTV30C
         X2bA==
X-Forwarded-Encrypted: i=1; AJvYcCUMHTr7DtbJHmCNzHi8Z8aTaI4j6lJjP/baFis7xC3ODu2cP6M5U7dkzaJuVdEbbPlJJFtXH5f+mPWyfKrMs42xF5dlVXxw84c=
X-Gm-Message-State: AOJu0Yz3j1EJa+9wwMffRzHmoJs6k62x3oFZJlphlRG/zaAuF98T+s8o
	lvxHg7ybwvL6D1VHp99HLhuEjZZRSYgmcU5ctFzMyIsCEkBYaI1mBDWxz6YML+zaJVkvlV3cfCo
	PjevXklD6CX20rrqpjhrvkJ7b2payX7JQRP7FeDZ3AISMKjIg3r4+8is=
X-Google-Smtp-Source: AGHT+IFW5TgVQmqg/5Q+HncurZGgxitxvvZWu5wolvjJzf8f7e2Rm8bve0k9EdygoMevAlLo8/nSWGHe3LtZCGaa5HJeEZmhR6V7
Precedence: bulk
X-Mailing-List: io-uring@vger.kernel.org
List-Id: <io-uring.vger.kernel.org>
List-Subscribe: <mailto:io-uring+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:io-uring+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-Received: by 2002:a05:6638:4094:b0:47e:c495:3a1e with SMTP id
 m20-20020a056638409400b0047ec4953a1emr884663jam.1.1712047652097; Tue, 02 Apr
 2024 01:47:32 -0700 (PDT)
Date: Tue, 02 Apr 2024 01:47:32 -0700
X-Google-Appengine-App-Id: s~syzkaller
X-Google-Appengine-App-Id-Alias: syzkaller
Message-ID: <0000000000002464bf06151928ef@google.com>
Subject: [syzbot] [io-uring?] kernel BUG in put_page
From: syzbot <syzbot+324f30025b9b5d66fab9@syzkaller.appspotmail.com>
To: asml.silence@gmail.com, axboe@kernel.dk, io-uring@vger.kernel.org, 
	linux-kernel@vger.kernel.org, syzkaller-bugs@googlegroups.com
Content-Type: text/plain; charset="UTF-8"

Hello,

syzbot found the following issue on:

HEAD commit:    c0b832517f62 Add linux-next specific files for 20240402
git tree:       linux-next
console+strace: https://syzkaller.appspot.com/x/log.txt?x=1737bfb1180000
kernel config:  https://syzkaller.appspot.com/x/.config?x=afcaf46d374cec8c
dashboard link: https://syzkaller.appspot.com/bug?extid=324f30025b9b5d66fab9
compiler:       Debian clang version 15.0.6, GNU ld (GNU Binutils for Debian) 2.40
syz repro:      https://syzkaller.appspot.com/x/repro.syz?x=17ce85b1180000
C reproducer:   https://syzkaller.appspot.com/x/repro.c?x=139fe0c5180000

Downloadable assets:
disk image: https://storage.googleapis.com/syzbot-assets/0d36ec76edc7/disk-c0b83251.raw.xz
vmlinux: https://storage.googleapis.com/syzbot-assets/6f9bb4e37dd0/vmlinux-c0b83251.xz
kernel image: https://storage.googleapis.com/syzbot-assets/2349287b14b7/bzImage-c0b83251.xz

IMPORTANT: if you fix the issue, please add the following tag to the commit:
Reported-by: syzbot+324f30025b9b5d66fab9@syzkaller.appspotmail.com

 reset_page_owner include/linux/page_owner.h:25 [inline]
 free_pages_prepare mm/page_alloc.c:1110 [inline]
 free_unref_page+0xd3c/0xec0 mm/page_alloc.c:2617
 __folio_put_small mm/swap.c:119 [inline]
 __folio_put+0x22b/0x390 mm/swap.c:142
 io_mem_alloc_single io_uring/memmap.c:55 [inline]
 io_pages_map+0x25a/0x480 io_uring/memmap.c:76
 io_allocate_scq_urings+0x3b8/0x640 io_uring/io_uring.c:3432
 io_uring_create+0x741/0x12f0 io_uring/io_uring.c:3590
 io_uring_setup io_uring/io_uring.c:3702 [inline]
 __do_sys_io_uring_setup io_uring/io_uring.c:3729 [inline]
 __se_sys_io_uring_setup+0x2ba/0x330 io_uring/io_uring.c:3723
 do_syscall_64+0xfb/0x240
 entry_SYSCALL_64_after_hwframe+0x72/0x7a
------------[ cut here ]------------
kernel BUG at include/linux/mm.h:1135!
Oops: invalid opcode: 0000 [#1] PREEMPT SMP KASAN PTI
CPU: 0 PID: 5084 Comm: syz-executor990 Not tainted 6.9.0-rc2-next-20240402-syzkaller #0
Hardware name: Google Google Compute Engine/Google Compute Engine, BIOS Google 03/27/2024
RIP: 0010:put_page_testzero include/linux/mm.h:1135 [inline]
RIP: 0010:folio_put_testzero include/linux/mm.h:1141 [inline]
RIP: 0010:folio_put include/linux/mm.h:1508 [inline]
RIP: 0010:put_page+0x1b6/0x260 include/linux/mm.h:1581
Code: 00 00 e8 6d 25 61 fd 84 c0 74 6e e8 c4 a6 ed fc e9 3f ff ff ff e8 ba a6 ed fc 4c 89 f7 48 c7 c6 a0 12 1f 8c e8 bb ea 36 fd 90 <0f> 0b e8 a3 a6 ed fc e9 a1 fe ff ff 4c 89 f7 be 08 00 00 00 e8 11
RSP: 0018:ffffc9000353fc30 EFLAGS: 00010246
RAX: bf727e5c3e70b300 RBX: ffffea0000446034 RCX: 0000000000000001
RDX: dffffc0000000000 RSI: ffffffff8bcad5c0 RDI: 0000000000000001
RBP: 0000000000000000 R08: ffffffff8fa934ef R09: 1ffffffff1f5269d
R10: dffffc0000000000 R11: fffffbfff1f5269e R12: 1ffff1100c8c9518
R13: ffff888064636000 R14: ffffea0000446000 R15: ffff88806464a8c6
FS:  00005555716a0380(0000) GS:ffff8880b9400000(0000) knlGS:0000000000000000
CS:  0010 DS: 0000 ES: 0000 CR0: 0000000080050033
CR2: 00007fe2349d29f0 CR3: 0000000022106000 CR4: 00000000003506f0
DR0: 0000000000000000 DR1: 0000000000000000 DR2: 0000000000000000
DR3: 0000000000000000 DR6: 00000000fffe0ff0 DR7: 0000000000000400
Call Trace:
 <TASK>
 io_pages_unmap+0x1c0/0x320 io_uring/memmap.c:108
 io_rings_free+0xcf/0x2b0 io_uring/io_uring.c:2619
 io_allocate_scq_urings+0x41f/0x640 io_uring/io_uring.c:3437
 io_uring_create+0x741/0x12f0 io_uring/io_uring.c:3590
 io_uring_setup io_uring/io_uring.c:3702 [inline]
 __do_sys_io_uring_setup io_uring/io_uring.c:3729 [inline]
 __se_sys_io_uring_setup+0x2ba/0x330 io_uring/io_uring.c:3723
 do_syscall_64+0xfb/0x240
 entry_SYSCALL_64_after_hwframe+0x72/0x7a
RIP: 0033:0x7fe234a0f9d9
Code: 28 00 00 00 75 05 48 83 c4 28 c3 e8 61 18 00 00 90 48 89 f8 48 89 f7 48 89 d6 48 89 ca 4d 89 c2 4d 89 c8 4c 8b 4c 24 08 0f 05 <48> 3d 01 f0 ff ff 73 01 c3 48 c7 c1 b8 ff ff ff f7 d8 64 89 01 48
RSP: 002b:00007ffc53bc7168 EFLAGS: 00000246 ORIG_RAX: 00000000000001a9
RAX: ffffffffffffffda RBX: 0000000000000010 RCX: 00007fe234a0f9d9
RDX: 00007fe234a0f9d9 RSI: 0000000020000000 RDI: 0000000000006839
RBP: 0000000000000000 R08: 0000000000000000 R09: 0000000000000000
R10: 0000000000000000 R11: 0000000000000246 R12: 00007fe234a59036
R13: 00007ffc53bc71a0 R14: 00007ffc53bc71e0 R15: 0000000000000000
 </TASK>
Modules linked in:
---[ end trace 0000000000000000 ]---
RIP: 0010:put_page_testzero include/linux/mm.h:1135 [inline]
RIP: 0010:folio_put_testzero include/linux/mm.h:1141 [inline]
RIP: 0010:folio_put include/linux/mm.h:1508 [inline]
RIP: 0010:put_page+0x1b6/0x260 include/linux/mm.h:1581
Code: 00 00 e8 6d 25 61 fd 84 c0 74 6e e8 c4 a6 ed fc e9 3f ff ff ff e8 ba a6 ed fc 4c 89 f7 48 c7 c6 a0 12 1f 8c e8 bb ea 36 fd 90 <0f> 0b e8 a3 a6 ed fc e9 a1 fe ff ff 4c 89 f7 be 08 00 00 00 e8 11
RSP: 0018:ffffc9000353fc30 EFLAGS: 00010246
RAX: bf727e5c3e70b300 RBX: ffffea0000446034 RCX: 0000000000000001
RDX: dffffc0000000000 RSI: ffffffff8bcad5c0 RDI: 0000000000000001
RBP: 0000000000000000 R08: ffffffff8fa934ef R09: 1ffffffff1f5269d
R10: dffffc0000000000 R11: fffffbfff1f5269e R12: 1ffff1100c8c9518
R13: ffff888064636000 R14: ffffea0000446000 R15: ffff88806464a8c6
FS:  00005555716a0380(0000) GS:ffff8880b9500000(0000) knlGS:0000000000000000
CS:  0010 DS: 0000 ES: 0000 CR0: 0000000080050033
CR2: 0000556f47e67058 CR3: 0000000022106000 CR4: 00000000003506f0
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

