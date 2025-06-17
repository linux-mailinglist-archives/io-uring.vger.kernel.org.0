Return-Path: <io-uring+bounces-8379-lists+io-uring=lfdr.de@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [139.178.88.99])
	by mail.lfdr.de (Postfix) with ESMTPS id 2E024ADC45D
	for <lists+io-uring@lfdr.de>; Tue, 17 Jun 2025 10:16:32 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 32CA13A8402
	for <lists+io-uring@lfdr.de>; Tue, 17 Jun 2025 08:12:26 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 1D7F728DB7D;
	Tue, 17 Jun 2025 08:12:45 +0000 (UTC)
X-Original-To: io-uring@vger.kernel.org
Received: from mail-il1-f207.google.com (mail-il1-f207.google.com [209.85.166.207])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 60E8C1514F6
	for <io-uring@vger.kernel.org>; Tue, 17 Jun 2025 08:12:43 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.166.207
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1750147965; cv=none; b=IMMO9vCY4Jg82/Bmw3Yf6oPZRRdauaFpDPBrv/kYHQJGyWv8vdOGfAFlYWOkFhkZhHqG6GFNGSlJcdMMyWUtwyy+k5/W2Az465MEIbifJlbJ7rm12xeNz/xJjbAx8dzWuR15XwK574jdNKAH7s9XvDrnROcbHnP1mjvDE8c6tCk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1750147965; c=relaxed/simple;
	bh=Ftqr8Ew7eiB1St79ssxLZumSoYOEKQj01VKejQQ2XZM=;
	h=MIME-Version:Date:Message-ID:Subject:From:To:Content-Type; b=cmNtHhJ6AjlYWORWFrac5iRnIqHrADZ/liY4+MuJ1tsTK8rvk5xgsaS3g3QZ4gQ+sAIGI09kjI705tboT5qhq+YWtCJ2ZK8k2kB7/xNg77Mwwtk8MeyHTSSZVZp4MVwPV6yeW7W5PDLtD/JMwlNQWJUNMff2X822MuALVcso43A=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=fail (p=none dis=none) header.from=syzkaller.appspotmail.com; spf=pass smtp.mailfrom=M3KW2WVRGUFZ5GODRSRYTGD7.apphosting.bounces.google.com; arc=none smtp.client-ip=209.85.166.207
Authentication-Results: smtp.subspace.kernel.org; dmarc=fail (p=none dis=none) header.from=syzkaller.appspotmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=M3KW2WVRGUFZ5GODRSRYTGD7.apphosting.bounces.google.com
Received: by mail-il1-f207.google.com with SMTP id e9e14a558f8ab-3ddd90ca184so41129875ab.0
        for <io-uring@vger.kernel.org>; Tue, 17 Jun 2025 01:12:43 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1750147962; x=1750752762;
        h=to:from:subject:message-id:date:mime-version:x-gm-message-state
         :from:to:cc:subject:date:message-id:reply-to;
        bh=+DOD57MEg4LgGQWgJYKBIp3iz0Ed4IkfQ1ev4IDH3QE=;
        b=XOTxm/Zlh7RmHWUD+gzAH+9X7IHJH78q0e5Zr2mV2fzsMFW2i6jgn1Z3puoS93T+S9
         G9E5nFIBJrGWaAJO+pcf3IONFj1FHgw9OxXY/BQ1kpz9+jnbMBoLiizbNdt+WHnkwsNm
         xJ2qFOsUcl8gSY7mlMivNZd3DFs0OjjVpl9F2fCVzldodAezZ8gqxSVW717M1ppEUv7k
         aXo9ocvmehAITigvC3hWfvKjrzIzOPruhVsOjCSQGurBctsAj4fBw1mYany3jph28gVf
         4zquiXfQ0NUqkRLD/Apk4swss+KMvCo5wte8qHYB/p9/xqVOVnS9lIFJtZf+OBzRn398
         I4LQ==
X-Forwarded-Encrypted: i=1; AJvYcCXreQcowft4r6DH75K4SiNBMw+iR8yMf+fncMdTv8dDpYI2+Ge5pOSk/v/k+1irzKujJD8XILG/bQ==@vger.kernel.org
X-Gm-Message-State: AOJu0YxyF4386rpovczkvnlO0JL6TrmNWB8lsfohZ0O1HKNHCOzpyG4y
	Dj49LRhp0MNS8y2V/mDyo15Dlw65EZ8ai+SitZN+hp+TMmlb3/P6jf56pb72FNVtYWLLgfLok4C
	IvxE2TvQGrohZBPScItaAC/xv5KGVsTGwzc8UOa0VVzCQFBZ+PhxC/ikRKSg=
X-Google-Smtp-Source: AGHT+IEeo/Igu2vt1QhMxlUnR7kvSH/NG28fTVIpqxF576eRjw9tJD1k7l/CZUCUZMb291jLyevjQGC1zHVyAFN5slygZCJSgjX/
Precedence: bulk
X-Mailing-List: io-uring@vger.kernel.org
List-Id: <io-uring.vger.kernel.org>
List-Subscribe: <mailto:io-uring+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:io-uring+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-Received: by 2002:a05:6e02:1522:b0:3de:2102:f1d8 with SMTP id
 e9e14a558f8ab-3de2102f53dmr37656435ab.18.1750147962403; Tue, 17 Jun 2025
 01:12:42 -0700 (PDT)
Date: Tue, 17 Jun 2025 01:12:42 -0700
X-Google-Appengine-App-Id: s~syzkaller
X-Google-Appengine-App-Id-Alias: syzkaller
Message-ID: <6851237a.a70a0220.395abc.0208.GAE@google.com>
Subject: [syzbot] [io-uring?] WARNING: ODEBUG bug in io_sq_offload_create
From: syzbot <syzbot+763e12bbf004fb1062e4@syzkaller.appspotmail.com>
To: axboe@kernel.dk, io-uring@vger.kernel.org, linux-kernel@vger.kernel.org, 
	syzkaller-bugs@googlegroups.com
Content-Type: text/plain; charset="UTF-8"

Hello,

syzbot found the following issue on:

HEAD commit:    8c6bc74c7f89 Merge tag 'v6.16-rc1-smb3-client-fixes' of gi..
git tree:       upstream
console output: https://syzkaller.appspot.com/x/log.txt?x=1745710c580000
kernel config:  https://syzkaller.appspot.com/x/.config?x=1ab5c40b21ee326a
dashboard link: https://syzkaller.appspot.com/bug?extid=763e12bbf004fb1062e4
compiler:       gcc (Debian 12.2.0-14) 12.2.0, GNU ld (GNU Binutils for Debian) 2.40
syz repro:      https://syzkaller.appspot.com/x/repro.syz?x=13ea3d70580000
C reproducer:   https://syzkaller.appspot.com/x/repro.c?x=10c5710c580000

Downloadable assets:
disk image (non-bootable): https://storage.googleapis.com/syzbot-assets/d900f083ada3/non_bootable_disk-8c6bc74c.raw.xz
vmlinux: https://storage.googleapis.com/syzbot-assets/b523997774df/vmlinux-8c6bc74c.xz
kernel image: https://storage.googleapis.com/syzbot-assets/da5178f1b34a/bzImage-8c6bc74c.xz

IMPORTANT: if you fix the issue, please add the following tag to the commit:
Reported-by: syzbot+763e12bbf004fb1062e4@syzkaller.appspotmail.com

R13: 0000000000000002 R14: 00007fad89109ab1 R15: 00007fad8910601d
 </TASK>
------------[ cut here ]------------
ODEBUG: free active (active state 1) object: ffff888024813bd0 object type: rcu_head hint: 0x0
WARNING: CPU: 0 PID: 5941 at lib/debugobjects.c:612 debug_print_object+0x1a2/0x2b0 lib/debugobjects.c:612
Modules linked in:
CPU: 0 UID: 0 PID: 5941 Comm: syz-executor101 Not tainted 6.16.0-rc1-syzkaller-00236-g8c6bc74c7f89 #0 PREEMPT(full) 
Hardware name: QEMU Standard PC (Q35 + ICH9, 2009), BIOS 1.16.3-debian-1.16.3-2~bpo12+1 04/01/2014
RIP: 0010:debug_print_object+0x1a2/0x2b0 lib/debugobjects.c:612
Code: fc ff df 48 89 fa 48 c1 ea 03 80 3c 02 00 75 54 41 56 48 8b 14 dd 00 8a 15 8c 4c 89 e6 48 c7 c7 80 7e 15 8c e8 bf 33 99 fc 90 <0f> 0b 90 90 58 83 05 56 99 c6 0b 01 48 83 c4 18 5b 5d 41 5c 41 5d
RSP: 0018:ffffc90003f8fa78 EFLAGS: 00010282
RAX: 0000000000000000 RBX: 0000000000000003 RCX: ffffffff817ae248
RDX: ffff88803cd0a440 RSI: ffffffff817ae255 RDI: 0000000000000001
RBP: 0000000000000001 R08: 0000000000000001 R09: 0000000000000000
R10: 0000000000000001 R11: 0000000000000001 R12: ffffffff8c158520
R13: ffffffff8baeb4a0 R14: 0000000000000000 R15: ffffc90003f8fb78
FS:  00007fad890686c0(0000) GS:ffff8880d6753000(0000) knlGS:0000000000000000
CS:  0010 DS: 0000 ES: 0000 CR0: 0000000080050033
CR2: 00007fad8911b362 CR3: 0000000031b29000 CR4: 0000000000352ef0
DR0: 0000000000000000 DR1: 0000000000000000 DR2: 0000000000000000
DR3: 0000000000000000 DR6: 00000000fffe0ff0 DR7: 0000000000000400
Call Trace:
 <TASK>
 __debug_check_no_obj_freed lib/debugobjects.c:1099 [inline]
 debug_check_no_obj_freed+0x4b7/0x600 lib/debugobjects.c:1129
 slab_free_hook mm/slub.c:2312 [inline]
 slab_free mm/slub.c:4643 [inline]
 kmem_cache_free+0x2ac/0x4d0 mm/slub.c:4745
 put_task_struct include/linux/sched/task.h:145 [inline]
 put_task_struct include/linux/sched/task.h:132 [inline]
 io_sq_offload_create+0xe4b/0x1330 io_uring/sqpoll.c:517
 io_uring_create io_uring/io_uring.c:3747 [inline]
 io_uring_setup+0x1514/0x2120 io_uring/io_uring.c:3830
 __do_sys_io_uring_setup io_uring/io_uring.c:3864 [inline]
 __se_sys_io_uring_setup io_uring/io_uring.c:3855 [inline]
 __x64_sys_io_uring_setup+0xc2/0x170 io_uring/io_uring.c:3855
 do_syscall_x64 arch/x86/entry/syscall_64.c:63 [inline]
 do_syscall_64+0xcd/0x4c0 arch/x86/entry/syscall_64.c:94
 entry_SYSCALL_64_after_hwframe+0x77/0x7f
RIP: 0033:0x7fad890b6f99
Code: 28 00 00 00 75 05 48 83 c4 28 c3 e8 31 1b 00 00 90 48 89 f8 48 89 f7 48 89 d6 48 89 ca 4d 89 c2 4d 89 c8 4c 8b 4c 24 08 0f 05 <48> 3d 01 f0 ff ff 73 01 c3 48 c7 c1 b0 ff ff ff f7 d8 64 89 01 48
RSP: 002b:00007fad89068208 EFLAGS: 00000246 ORIG_RAX: 00000000000001a9
RAX: ffffffffffffffda RBX: 00007fad891393c8 RCX: 00007fad890b6f99
RDX: 0000000000000000 RSI: 0000200000000200 RDI: 0000000000004d25
RBP: 00007fad891393c0 R08: 00007fad89067fa6 R09: 0000000000003232
R10: 0000000000000000 R11: 0000000000000246 R12: 00007fad89068210
R13: 0000000000000002 R14: 00007fad89109ab1 R15: 00007fad8910601d
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

