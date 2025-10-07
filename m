Return-Path: <io-uring+bounces-9911-lists+io-uring=lfdr.de@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [147.75.80.249])
	by mail.lfdr.de (Postfix) with ESMTPS id 7DCECBC163E
	for <lists+io-uring@lfdr.de>; Tue, 07 Oct 2025 14:43:36 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id 5CD11188FEE9
	for <lists+io-uring@lfdr.de>; Tue,  7 Oct 2025 12:43:59 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 6E2502DF15B;
	Tue,  7 Oct 2025 12:43:33 +0000 (UTC)
X-Original-To: io-uring@vger.kernel.org
Received: from mail-io1-f79.google.com (mail-io1-f79.google.com [209.85.166.79])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 85F622DF153
	for <io-uring@vger.kernel.org>; Tue,  7 Oct 2025 12:43:31 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.166.79
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1759841013; cv=none; b=Q+S324AEXnaV207/eoXP9sSQOv4l7ROzIMQlcthd75GJLyEtzTkyNazQqvM39pxTq1b35/AhmgIi9Vi44vL+vo/aCaYO1wQl+w8qRtc218jT1757KfCcteuiOzrT3qcB7K3cT/Ceu0cq0xYL6lQ4/2ROstPfhPRD2fOtO4TfhLs=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1759841013; c=relaxed/simple;
	bh=Xrx4wKA2+CjRkqRrbTiCZhWv5vIN5nkQDI4tDuzDfOc=;
	h=MIME-Version:Date:Message-ID:Subject:From:To:Content-Type; b=OgjpPYlQcP92CzNjErXw6blMSjyoTeuf+nMa8NRkTq7TN6MBM2zoBqywIOX+h+NjA6DXIIQRYgmgC2a4A98DLx9l2MjiO82KBB534oIYGchOb1dA1V0jbDIrCzkK7qWEWGDTukUkL6hxh6z0sZVoaU1F6cZejbranVXfkXDqPiU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=fail (p=none dis=none) header.from=syzkaller.appspotmail.com; spf=pass smtp.mailfrom=M3KW2WVRGUFZ5GODRSRYTGD7.apphosting.bounces.google.com; arc=none smtp.client-ip=209.85.166.79
Authentication-Results: smtp.subspace.kernel.org; dmarc=fail (p=none dis=none) header.from=syzkaller.appspotmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=M3KW2WVRGUFZ5GODRSRYTGD7.apphosting.bounces.google.com
Received: by mail-io1-f79.google.com with SMTP id ca18e2360f4ac-937ce715b90so935071439f.0
        for <io-uring@vger.kernel.org>; Tue, 07 Oct 2025 05:43:31 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1759841010; x=1760445810;
        h=to:from:subject:message-id:date:mime-version:x-gm-message-state
         :from:to:cc:subject:date:message-id:reply-to;
        bh=ngkTLBuQWHCVGDOFb/GBzhurIyZJMzJMTLQp+SNhqdo=;
        b=RZh2E90Rf+3v2/X09UNa/wdpduKjyRQY8czWtWMkB9V0V1sXdpimKV9k3r85BCntyB
         SR0r6Ap1xfxTa3ZdLD59GEKBaCKGmUcABhtAfXY/Sij74WQ/Eu6V0yoauqePW5XAHJMg
         zCDpmTQGXeVfDQSPpOGnYWqv77ChoRqFSTEEpCPxabEsklB0X+YwPqB5aK7AA/knxC1h
         gMQM7hD6XBYJtkqQy9rEwGzdLAmtv1+ODARZwWOdaC2A1uT+4Xb7b0KTAsRixcKhWYra
         bnptdwPZ/V9SfCIiBGKoMcWEYxc4LrYdeNSGIRVgjc5CZLScAXWOvIddVmETh4hEmBvt
         0mMQ==
X-Forwarded-Encrypted: i=1; AJvYcCX46PoCid3f+pzXmJPpCSg7+mv8Y2DJJ5hw9jhSm6qcj9jjBSqQp9O9d8CUaL+ebdTEloFE3Cdyeg==@vger.kernel.org
X-Gm-Message-State: AOJu0Yx0JmUWfUWOp/3WZ5ZyHEh2+cwKsUlaP0/WkqO83ukxYge/P7A0
	EPrdjEa8IUmPJHFnNPw8u/6zlqKbo4sW8464MkxZpJGQJ09v6NU3RvV+azsOSBT7++ybvC3WkAB
	ifQBtah7qhlDrY43RnlgMYHUDsoplOZVH7aU/BXoCdGDlrSAQjJGWhHYZR7A=
X-Google-Smtp-Source: AGHT+IFuZEdHsoGHjvrPQD3ghM9pPE6I1IwSKPxkIYytTtG+JfsjUkERwDpLutRC+haRKqDGqoKxVy/1o6LrXT51CW6EAbdqo9CX
Precedence: bulk
X-Mailing-List: io-uring@vger.kernel.org
List-Id: <io-uring.vger.kernel.org>
List-Subscribe: <mailto:io-uring+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:io-uring+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-Received: by 2002:a05:6602:1d0a:b0:88c:3918:76fe with SMTP id
 ca18e2360f4ac-93bc4118117mr358839939f.4.1759841010472; Tue, 07 Oct 2025
 05:43:30 -0700 (PDT)
Date: Tue, 07 Oct 2025 05:43:30 -0700
X-Google-Appengine-App-Id: s~syzkaller
X-Google-Appengine-App-Id-Alias: syzkaller
Message-ID: <68e50af2.a00a0220.298cc0.0479.GAE@google.com>
Subject: [syzbot] [io-uring?] KASAN: slab-use-after-free Read in io_waitid_wait
From: syzbot <syzbot+b9e83021d9c642a33d8c@syzkaller.appspotmail.com>
To: axboe@kernel.dk, io-uring@vger.kernel.org, linux-kernel@vger.kernel.org, 
	syzkaller-bugs@googlegroups.com
Content-Type: text/plain; charset="UTF-8"

Hello,

syzbot found the following issue on:

HEAD commit:    6a74422b9710 Merge tag 'mips_6.18' of git://git.kernel.org..
git tree:       upstream
console output: https://syzkaller.appspot.com/x/log.txt?x=124fdee2580000
kernel config:  https://syzkaller.appspot.com/x/.config?x=8f142ebe84501b0b
dashboard link: https://syzkaller.appspot.com/bug?extid=b9e83021d9c642a33d8c
compiler:       gcc (Debian 12.2.0-14+deb12u1) 12.2.0, GNU ld (GNU Binutils for Debian) 2.40
syz repro:      https://syzkaller.appspot.com/x/repro.syz?x=1437c304580000
C reproducer:   https://syzkaller.appspot.com/x/repro.c?x=118b3334580000

Downloadable assets:
disk image (non-bootable): https://storage.googleapis.com/syzbot-assets/d900f083ada3/non_bootable_disk-6a74422b.raw.xz
vmlinux: https://storage.googleapis.com/syzbot-assets/fc46a17eb520/vmlinux-6a74422b.xz
kernel image: https://storage.googleapis.com/syzbot-assets/a9132caa46a1/bzImage-6a74422b.xz

IMPORTANT: if you fix the issue, please add the following tag to the commit:
Reported-by: syzbot+b9e83021d9c642a33d8c@syzkaller.appspotmail.com

==================================================================
BUG: KASAN: slab-use-after-free in __list_del_entry_valid_or_report+0x1ba/0x200 lib/list_debug.c:49
Read of size 8 at addr ffff888051712d50 by task syz.0.17/6127

CPU: 0 UID: 0 PID: 6127 Comm: syz.0.17 Not tainted syzkaller #0 PREEMPT(full) 
Hardware name: QEMU Standard PC (Q35 + ICH9, 2009), BIOS 1.16.3-debian-1.16.3-2~bpo12+1 04/01/2014
Call Trace:
 <TASK>
 __dump_stack lib/dump_stack.c:94 [inline]
 dump_stack_lvl+0x116/0x1f0 lib/dump_stack.c:120
 print_address_description mm/kasan/report.c:378 [inline]
 print_report+0xcd/0x630 mm/kasan/report.c:482
 kasan_report+0xe0/0x110 mm/kasan/report.c:595
 __list_del_entry_valid_or_report+0x1ba/0x200 lib/list_debug.c:49
 __list_del_entry_valid include/linux/list.h:132 [inline]
 __list_del_entry include/linux/list.h:223 [inline]
 list_del_init include/linux/list.h:295 [inline]
 io_waitid_wait+0xf7/0x230 io_uring/waitid.c:239
 __wake_up_common+0x132/0x1f0 kernel/sched/wait.c:108
 __wake_up_common_lock kernel/sched/wait.c:125 [inline]
 __wake_up_sync_key+0x36/0x50 kernel/sched/wait.c:192
 do_notify_parent_cldstop+0x540/0xb50 kernel/signal.c:2333
 ptrace_stop.part.0+0x7e1/0x950 kernel/signal.c:2437
 ptrace_stop kernel/signal.c:2376 [inline]
 ptrace_signal kernel/signal.c:2743 [inline]
 get_signal+0x13d5/0x26d0 kernel/signal.c:2921
 arch_do_signal_or_restart+0x8f/0x7c0 arch/x86/kernel/signal.c:337
 exit_to_user_mode_loop kernel/entry/common.c:40 [inline]
 exit_to_user_mode_prepare include/linux/irq-entry-common.h:225 [inline]
 irqentry_exit_to_user_mode+0x141/0x2b0 kernel/entry/common.c:73
 asm_exc_page_fault+0x26/0x30 arch/x86/include/asm/idtentry.h:623
RIP: 0033:0x7fc598db6c60
Code: 6e c7 89 13 48 8b 50 08 0f 16 40 50 0f 11 00 48 89 50 50 48 8b 50 10 48 89 78 10 48 89 50 40 48 89 d7 eb b2 66 0f 1f 44 00 00 <64> 48 8b 0c 25 10 00 00 00 8b 91 08 03 00 00 48 8d b9 08 03 00 00
RSP: 002b:00007ffccd0733d8 EFLAGS: 00010202
RAX: 00000000fffffffa RBX: 00007fc598fe5fa0 RCX: 0000000000000000
RDX: 00007ffccd073420 RSI: 0000000000000000 RDI: 0000000000000000
RBP: 00007fc598e11f91 R08: 0000000000000000 R09: 0000000000000000
R10: 0000000000000000 R11: 0000000000000246 R12: 0000000000000000
R13: 00007fc598fe5fa0 R14: 00007fc598fe5fa0 R15: 0000000000000006
 </TASK>

Allocated by task 6123:
 kasan_save_stack+0x33/0x60 mm/kasan/common.c:56
 kasan_save_track+0x14/0x30 mm/kasan/common.c:77
 poison_kmalloc_redzone mm/kasan/common.c:400 [inline]
 __kasan_kmalloc+0xaa/0xb0 mm/kasan/common.c:417
 kasan_kmalloc include/linux/kasan.h:262 [inline]
 __do_kmalloc_node mm/slub.c:5603 [inline]
 __kmalloc_noprof+0x32f/0x880 mm/slub.c:5615
 kmalloc_noprof include/linux/slab.h:961 [inline]
 io_uring_alloc_async_data io_uring/io_uring.h:328 [inline]
 io_waitid_prep+0x1aa/0x470 io_uring/waitid.c:251
 io_init_req io_uring/io_uring.c:2248 [inline]
 io_submit_sqe io_uring/io_uring.c:2295 [inline]
 io_submit_sqes+0x855/0x2710 io_uring/io_uring.c:2447
 __do_sys_io_uring_enter+0xd69/0x1630 io_uring/io_uring.c:3514
 do_syscall_x64 arch/x86/entry/syscall_64.c:63 [inline]
 do_syscall_64+0xcd/0x4e0 arch/x86/entry/syscall_64.c:94
 entry_SYSCALL_64_after_hwframe+0x77/0x7f

Freed by task 6123:
 kasan_save_stack+0x33/0x60 mm/kasan/common.c:56
 kasan_save_track+0x14/0x30 mm/kasan/common.c:77
 __kasan_save_free_info+0x3b/0x60 mm/kasan/generic.c:587
 kasan_save_free_info mm/kasan/kasan.h:406 [inline]
 poison_slab_object mm/kasan/common.c:252 [inline]
 __kasan_slab_free+0x5f/0x80 mm/kasan/common.c:284
 kasan_slab_free include/linux/kasan.h:234 [inline]
 slab_free_hook mm/slub.c:2514 [inline]
 slab_free mm/slub.c:6566 [inline]
 kfree+0x2b8/0x6d0 mm/slub.c:6773
 io_req_async_data_free io_uring/io_uring.h:349 [inline]
 io_waitid_free io_uring/waitid.c:40 [inline]
 io_waitid_finish io_uring/waitid.c:108 [inline]
 io_waitid_complete+0x249/0x5e0 io_uring/waitid.c:123
 io_waitid_cb+0xe4/0x3a0 io_uring/waitid.c:217
 io_handle_tw_list+0x483/0x500 io_uring/io_uring.c:1151
 tctx_task_work_run+0xac/0x380 io_uring/io_uring.c:1216
 tctx_task_work+0x7a/0xd0 io_uring/io_uring.c:1234
 task_work_run+0x150/0x240 kernel/task_work.c:227
 get_signal+0x1d0/0x26d0 kernel/signal.c:2807
 arch_do_signal_or_restart+0x8f/0x7c0 arch/x86/kernel/signal.c:337
 exit_to_user_mode_loop kernel/entry/common.c:40 [inline]
 exit_to_user_mode_prepare include/linux/irq-entry-common.h:225 [inline]
 irqentry_exit_to_user_mode+0x141/0x2b0 kernel/entry/common.c:73
 asm_exc_page_fault+0x26/0x30 arch/x86/include/asm/idtentry.h:623

The buggy address belongs to the object at ffff888051712d00
 which belongs to the cache kmalloc-96 of size 96
The buggy address is located 80 bytes inside of
 freed 96-byte region [ffff888051712d00, ffff888051712d60)

The buggy address belongs to the physical page:
page: refcount:0 mapcount:0 mapping:0000000000000000 index:0x0 pfn:0x51712
flags: 0xfff00000000000(node=0|zone=1|lastcpupid=0x7ff)
page_type: f5(slab)
raw: 00fff00000000000 ffff88801b042280 dead000000000122 0000000000000000
raw: 0000000000000000 0000000080200020 00000000f5000000 0000000000000000
page dumped because: kasan: bad access detected
page_owner tracks the page as allocated
page last allocated via order 0, migratetype Unmovable, gfp_mask 0x52cc0(GFP_KERNEL|__GFP_NOWARN|__GFP_NORETRY|__GFP_COMP), pid 6123, tgid 6123 (syz.0.17), ts 124233232510, free_ts 119982111762
 set_page_owner include/linux/page_owner.h:32 [inline]
 post_alloc_hook+0x1c0/0x230 mm/page_alloc.c:1850
 prep_new_page mm/page_alloc.c:1858 [inline]
 get_page_from_freelist+0x10a3/0x3a30 mm/page_alloc.c:3884
 __alloc_frozen_pages_noprof+0x25f/0x2470 mm/page_alloc.c:5183
 alloc_pages_mpol+0x1fb/0x550 mm/mempolicy.c:2416
 alloc_slab_page mm/slub.c:3030 [inline]
 allocate_slab mm/slub.c:3203 [inline]
 new_slab+0x24a/0x360 mm/slub.c:3257
 ___slab_alloc+0xdc4/0x1ae0 mm/slub.c:4627
 __slab_alloc.constprop.0+0x63/0x110 mm/slub.c:4746
 __slab_alloc_node mm/slub.c:4822 [inline]
 slab_alloc_node mm/slub.c:5233 [inline]
 __do_kmalloc_node mm/slub.c:5602 [inline]
 __kmalloc_noprof+0x501/0x880 mm/slub.c:5615
 kmalloc_noprof include/linux/slab.h:961 [inline]
 io_uring_alloc_async_data io_uring/io_uring.h:328 [inline]
 io_waitid_prep+0x1aa/0x470 io_uring/waitid.c:251
 io_init_req io_uring/io_uring.c:2248 [inline]
 io_submit_sqe io_uring/io_uring.c:2295 [inline]
 io_submit_sqes+0x855/0x2710 io_uring/io_uring.c:2447
 __do_sys_io_uring_enter+0xd69/0x1630 io_uring/io_uring.c:3514
 do_syscall_x64 arch/x86/entry/syscall_64.c:63 [inline]
 do_syscall_64+0xcd/0x4e0 arch/x86/entry/syscall_64.c:94
 entry_SYSCALL_64_after_hwframe+0x77/0x7f
page last free pid 6077 tgid 6077 stack trace:
 reset_page_owner include/linux/page_owner.h:25 [inline]
 free_pages_prepare mm/page_alloc.c:1394 [inline]
 __free_frozen_pages+0x7df/0x1160 mm/page_alloc.c:2906
 vfree+0x1fd/0xb50 mm/vmalloc.c:3440
 kcov_put kernel/kcov.c:439 [inline]
 kcov_put kernel/kcov.c:435 [inline]
 kcov_close+0x34/0x60 kernel/kcov.c:535
 __fput+0x402/0xb70 fs/file_table.c:468
 task_work_run+0x150/0x240 kernel/task_work.c:227
 exit_task_work include/linux/task_work.h:40 [inline]
 do_exit+0x86f/0x2bf0 kernel/exit.c:966
 do_group_exit+0xd3/0x2a0 kernel/exit.c:1107
 get_signal+0x2671/0x26d0 kernel/signal.c:3034
 arch_do_signal_or_restart+0x8f/0x7c0 arch/x86/kernel/signal.c:337
 exit_to_user_mode_loop+0x85/0x130 kernel/entry/common.c:40
 exit_to_user_mode_prepare include/linux/irq-entry-common.h:225 [inline]
 syscall_exit_to_user_mode_work include/linux/entry-common.h:175 [inline]
 syscall_exit_to_user_mode include/linux/entry-common.h:210 [inline]
 do_syscall_64+0x419/0x4e0 arch/x86/entry/syscall_64.c:100
 entry_SYSCALL_64_after_hwframe+0x77/0x7f

Memory state around the buggy address:
 ffff888051712c00: 00 00 00 00 00 00 00 00 00 00 00 00 fc fc fc fc
 ffff888051712c80: 00 00 00 00 00 00 00 00 00 00 00 00 fc fc fc fc
>ffff888051712d00: fa fb fb fb fb fb fb fb fb fb fb fb fc fc fc fc
                                                 ^
 ffff888051712d80: 00 00 00 00 00 00 00 00 00 fc fc fc fc fc fc fc
 ffff888051712e00: 00 00 00 00 00 00 00 00 00 fc fc fc fc fc fc fc
==================================================================


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

