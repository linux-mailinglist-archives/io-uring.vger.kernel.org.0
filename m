Return-Path: <io-uring+bounces-3244-lists+io-uring=lfdr.de@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from sy.mirrors.kernel.org (sy.mirrors.kernel.org [147.75.48.161])
	by mail.lfdr.de (Postfix) with ESMTPS id 3D46A97D5B8
	for <lists+io-uring@lfdr.de>; Fri, 20 Sep 2024 14:47:33 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sy.mirrors.kernel.org (Postfix) with ESMTPS id AD389B20F2A
	for <lists+io-uring@lfdr.de>; Fri, 20 Sep 2024 12:47:30 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id EEA411684A4;
	Fri, 20 Sep 2024 12:47:26 +0000 (UTC)
X-Original-To: io-uring@vger.kernel.org
Received: from mail-il1-f198.google.com (mail-il1-f198.google.com [209.85.166.198])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 52A9F165EEB
	for <io-uring@vger.kernel.org>; Fri, 20 Sep 2024 12:47:25 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.166.198
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1726836446; cv=none; b=p1Gti22nITOy2+RNiDIOGgnv0xLI7X5S47e8t8T2J7D1EHMl3YcjppO43rHHm8vAG4r4+T1c+HuMkLRuc1uGh7ytprmfccOVWHvCq81OAvqbPC0SWlIzgz1+fMI4qz6DRy3DAJwdsmO5jEai8wlcCBVlxIkSNhqj5YtwQYmL0lU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1726836446; c=relaxed/simple;
	bh=tD3iDft4SBwpBaSHl8NlI2gqYGQHO0INPEO5LqHu1QI=;
	h=MIME-Version:Date:Message-ID:Subject:From:To:Content-Type; b=D+95tMoF5wbBavFXKyC4szXkscEenSLJ9DZv2FUYNyfT1VSThp97InsBdqKhjylpGwUTS0SkVYyFvYv7cGAmNJNoc0oG/BdeK3T0EQddYOVeANywwWhYP07Ke+i4N3Y2sPqyWcBsH+LWzEz9s5rNtaDZQEV4JQ5gtnrPYPOkRfU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=fail (p=none dis=none) header.from=syzkaller.appspotmail.com; spf=pass smtp.mailfrom=M3KW2WVRGUFZ5GODRSRYTGD7.apphosting.bounces.google.com; arc=none smtp.client-ip=209.85.166.198
Authentication-Results: smtp.subspace.kernel.org; dmarc=fail (p=none dis=none) header.from=syzkaller.appspotmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=M3KW2WVRGUFZ5GODRSRYTGD7.apphosting.bounces.google.com
Received: by mail-il1-f198.google.com with SMTP id e9e14a558f8ab-3a0a08aa0f1so22758695ab.0
        for <io-uring@vger.kernel.org>; Fri, 20 Sep 2024 05:47:25 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1726836444; x=1727441244;
        h=to:from:subject:message-id:date:mime-version:x-gm-message-state
         :from:to:cc:subject:date:message-id:reply-to;
        bh=IxIryZOr6HYqrQlJxWr1jnYP1uSOLuO/kQSlwcjblKo=;
        b=kSnZNxJp/5lJtludobUVeKr4AtSiE9Gs26K0Wq0TpAWSks5S7l0Yk4tYVNYrZdTrSx
         irlz6rFHeGHSUwKh4mUMP1wJ8IdjPSzLZOR29o/h5FTp4i9QthI+I05nwmew4f9jdh2S
         B9BmKuomHgsR849FOV+4snGkDpn4JFD8bzW0b+n+qNLstUZ5mlhEXcrNhIhALFDLQMxG
         GY0OxB2t/ll00FsX0er8zhYYz7kOD15LAK4+4ZKPZEQp7pqA2RDkU/VF5GWzwQjrYJVd
         rtZtQVfADAUIa2WV/0PEupaOfzVIFLSUlcLJkwSz+J7mw7lEvva1P1m1IraG7Y5rB89X
         E62A==
X-Forwarded-Encrypted: i=1; AJvYcCVBrTziNuD3F+szgN/rZpMgNk90IwTtIJW3ncOem0rQNq2fzlSCtZrHh6Gd3wczm/StwnqXOQEcdQ==@vger.kernel.org
X-Gm-Message-State: AOJu0YwW4UknyTDm6GE/AcpahEi2REF5OcnczCgAwWIVDKX8qSc+LLkz
	N/XAPlGsPsG9cYoB9GBZoeXjyVj5nYwVk7kzjKN6cAZv97MJ9nsa0mmtsLYMriOdVhrVcZbjOa6
	RHAOv/RUr0aOCMH9CmzRH2dGGtJQ/iYks3UfUqP1VtxhwdlpSCJvyjsM=
X-Google-Smtp-Source: AGHT+IHyg/NSSAXQ6bcrGSnBfOGrXCWgOAeuOULXE3fpQN4XrKArcp3ok4OS8tizrd/GiQq5XkG9rH2jRv2x62m/Ki2fK+6/Y32U
Precedence: bulk
X-Mailing-List: io-uring@vger.kernel.org
List-Id: <io-uring.vger.kernel.org>
List-Subscribe: <mailto:io-uring+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:io-uring+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-Received: by 2002:a05:6e02:1a43:b0:3a0:a070:b81 with SMTP id
 e9e14a558f8ab-3a0c8d2ea34mr32629695ab.23.1726836444433; Fri, 20 Sep 2024
 05:47:24 -0700 (PDT)
Date: Fri, 20 Sep 2024 05:47:24 -0700
X-Google-Appengine-App-Id: s~syzkaller
X-Google-Appengine-App-Id-Alias: syzkaller
Message-ID: <66ed6edc.050a0220.2abe4d.0014.GAE@google.com>
Subject: [syzbot] [io-uring?] WARNING in io_sq_offload_create
From: syzbot <syzbot+71b95eda637a2088bd6b@syzkaller.appspotmail.com>
To: asml.silence@gmail.com, axboe@kernel.dk, io-uring@vger.kernel.org, 
	linux-kernel@vger.kernel.org, syzkaller-bugs@googlegroups.com
Content-Type: text/plain; charset="UTF-8"

Hello,

syzbot found the following issue on:

HEAD commit:    adfc3ded5c33 Merge tag 'for-6.12/io_uring-discard-20240913..
git tree:       upstream
console output: https://syzkaller.appspot.com/x/log.txt?x=10ccd500580000
kernel config:  https://syzkaller.appspot.com/x/.config?x=c7cbb8108ed6b75e
dashboard link: https://syzkaller.appspot.com/bug?extid=71b95eda637a2088bd6b
compiler:       gcc (Debian 12.2.0-14) 12.2.0, GNU ld (GNU Binutils for Debian) 2.40
syz repro:      https://syzkaller.appspot.com/x/repro.syz?x=156d5fc7980000
C reproducer:   https://syzkaller.appspot.com/x/repro.c?x=14ccd500580000

Downloadable assets:
disk image: https://storage.googleapis.com/syzbot-assets/f36034d78003/disk-adfc3ded.raw.xz
vmlinux: https://storage.googleapis.com/syzbot-assets/312ad0ebcf45/vmlinux-adfc3ded.xz
kernel image: https://storage.googleapis.com/syzbot-assets/06eca1ed13c5/bzImage-adfc3ded.xz

IMPORTANT: if you fix the issue, please add the following tag to the commit:
Reported-by: syzbot+71b95eda637a2088bd6b@syzkaller.appspotmail.com

------------[ cut here ]------------
WARNING: CPU: 1 PID: 5230 at include/linux/cpumask.h:135 cpu_max_bits_warn include/linux/cpumask.h:135 [inline]
WARNING: CPU: 1 PID: 5230 at include/linux/cpumask.h:135 cpumask_check include/linux/cpumask.h:142 [inline]
WARNING: CPU: 1 PID: 5230 at include/linux/cpumask.h:135 cpumask_test_cpu include/linux/cpumask.h:562 [inline]
WARNING: CPU: 1 PID: 5230 at include/linux/cpumask.h:135 io_sq_offload_create+0xe3d/0x1090 io_uring/sqpoll.c:469
Modules linked in:
CPU: 1 UID: 0 PID: 5230 Comm: syz-executor334 Not tainted 6.11.0-syzkaller-02520-gadfc3ded5c33 #0
Hardware name: Google Google Compute Engine/Google Compute Engine, BIOS Google 08/06/2024
RIP: 0010:cpu_max_bits_warn include/linux/cpumask.h:135 [inline]
RIP: 0010:cpumask_check include/linux/cpumask.h:142 [inline]
RIP: 0010:cpumask_test_cpu include/linux/cpumask.h:562 [inline]
RIP: 0010:io_sq_offload_create+0xe3d/0x1090 io_uring/sqpoll.c:469
Code: 44 24 08 e9 2f f7 ff ff e8 a0 8d 0f fd 44 89 e3 e9 06 ff ff ff e8 93 8d 0f fd 4c 89 ff e8 6b 5f 7f fd eb ad e8 84 8d 0f fd 90 <0f> 0b 90 e9 f3 fd ff ff e8 76 8d 0f fd 31 ff 89 de e8 ad 8f 0f fd
RSP: 0018:ffffc9000369fcd8 EFLAGS: 00010293
RAX: 0000000000000000 RBX: ffff88803234bc00 RCX: ffffffff847b951e
RDX: ffff88801f7eda00 RSI: ffffffff847b972c RDI: 0000000000000005
RBP: ffff88802b2aa000 R08: 0000000000000005 R09: 0000000000000007
R10: 0000000000000008 R11: 0000000000000000 R12: 0000000000000008
R13: 1ffff920006d3fa0 R14: ffffc9000369fd20 R15: 0000000000000000
FS:  000055557be9d380(0000) GS:ffff8880b8900000(0000) knlGS:0000000000000000
CS:  0010 DS: 0000 ES: 0000 CR0: 0000000080050033
CR2: 00007f88aadf0df8 CR3: 0000000078b14000 CR4: 00000000003506f0
DR0: 0000000000000000 DR1: 0000000000000000 DR2: 0000000000000000
DR3: 0000000000000000 DR6: 00000000fffe0ff0 DR7: 0000000000000400
Call Trace:
 <TASK>
 io_uring_create io_uring/io_uring.c:3617 [inline]
 io_uring_setup+0x180f/0x3730 io_uring/io_uring.c:3726
 __do_sys_io_uring_setup io_uring/io_uring.c:3753 [inline]
 __se_sys_io_uring_setup io_uring/io_uring.c:3747 [inline]
 __x64_sys_io_uring_setup+0x98/0x140 io_uring/io_uring.c:3747
 do_syscall_x64 arch/x86/entry/common.c:52 [inline]
 do_syscall_64+0xcd/0x250 arch/x86/entry/common.c:83
 entry_SYSCALL_64_after_hwframe+0x77/0x7f
RIP: 0033:0x7f88aad91919
Code: ff c3 66 2e 0f 1f 84 00 00 00 00 00 0f 1f 44 00 00 48 89 f8 48 89 f7 48 89 d6 48 89 ca 4d 89 c2 4d 89 c8 4c 8b 4c 24 08 0f 05 <48> 3d 01 f0 ff ff 73 01 c3 48 c7 c1 b8 ff ff ff f7 d8 64 89 01 48
RSP: 002b:00007ffe74f4e298 EFLAGS: 00000246 ORIG_RAX: 00000000000001a9
RAX: ffffffffffffffda RBX: 00007f88aaddb105 RCX: 00007f88aad91919
RDX: ffffffffffffffb8 RSI: 0000000000000003 RDI: 00000000000003ff
RBP: 00007f88aaddb0e3 R08: 0000000000008000 R09: 0000000000008000
R10: 0000000000008000 R11: 0000000000000246 R12: 00007f88aade009c
R13: 00007f88aaddb0a3 R14: 0000000000000001 R15: 0000000000000001
 </TASK>


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

