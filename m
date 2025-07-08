Return-Path: <io-uring+bounces-8611-lists+io-uring=lfdr.de@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [147.75.199.223])
	by mail.lfdr.de (Postfix) with ESMTPS id CCB26AFC521
	for <lists+io-uring@lfdr.de>; Tue,  8 Jul 2025 10:12:44 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id DC98D4A453D
	for <lists+io-uring@lfdr.de>; Tue,  8 Jul 2025 08:12:41 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 2DD2229E0F4;
	Tue,  8 Jul 2025 08:12:30 +0000 (UTC)
X-Original-To: io-uring@vger.kernel.org
Received: from mail-il1-f208.google.com (mail-il1-f208.google.com [209.85.166.208])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 581E029B79B
	for <io-uring@vger.kernel.org>; Tue,  8 Jul 2025 08:12:28 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.166.208
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1751962350; cv=none; b=abI0SwldqQZxQ99ZwUzsVaph94HFL2Kv9ztk8napodPJFd6IWguu5bF9kcTD7+qoIGoDSuehm3IOC9K01O54uG/Gw8zODnmI3bpC0pqiRHuDd8HzwGM9iSUm+2m/xg+uWtBfXE0Bb/JxvrWOmj4drDRYXK2Npk7/y0PQFPdy4GQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1751962350; c=relaxed/simple;
	bh=uXiA7socSE4CW9JrnAUV9yMkWu5Aq8uYT+iOpt1YZNY=;
	h=MIME-Version:Date:Message-ID:Subject:From:To:Content-Type; b=Yn/140xEAmpEHjiTjum2ERkOhkd0xkD/gUcLKdtGGBhvgF0TNYbKMTM9RdQwoJOlLOfmo9EA6Lk7t9PxJJAA11IovqECiAPO17Mn7CWpU+/fcA1M78AoTVz061cmDl4VtB4I1Ukd6iyn8c/8IQZUx5YYsJbz4UvV7Uo6N+L+f9A=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=fail (p=none dis=none) header.from=syzkaller.appspotmail.com; spf=pass smtp.mailfrom=M3KW2WVRGUFZ5GODRSRYTGD7.apphosting.bounces.google.com; arc=none smtp.client-ip=209.85.166.208
Authentication-Results: smtp.subspace.kernel.org; dmarc=fail (p=none dis=none) header.from=syzkaller.appspotmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=M3KW2WVRGUFZ5GODRSRYTGD7.apphosting.bounces.google.com
Received: by mail-il1-f208.google.com with SMTP id e9e14a558f8ab-3ddd03db21cso74447895ab.1
        for <io-uring@vger.kernel.org>; Tue, 08 Jul 2025 01:12:28 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1751962347; x=1752567147;
        h=to:from:subject:message-id:date:mime-version:x-gm-message-state
         :from:to:cc:subject:date:message-id:reply-to;
        bh=5yNg+Qnsn00jiC0zBfuV81VCJk/pcXdLU3om3egg/k8=;
        b=CLo3ZmRbwy+rnbKNVMpa+dT8/dGRyqresGPdFeIHEITEFaConA5ShJ/3s8YlyWBE4f
         RwGCu0ig88uJppm4BrNfjzuWe/MFgOB8ho1KzjT0hha+biXalw6+nVuVMYY69VWdQStn
         gzFGKxJ8KQ2RbDZ8fZpPLgO9o+KAb3yQsaDamwXtwe2Xc7+fF+UzXjPw7Qsyo3YEJWYs
         j8aPrKgj2t+A/utSrd/QLTxwPjc/UgysP7KAZpBIzivjX6PpESfqYZAHBVZz0XcVlQQY
         zn19tFyXe7WlSatpCKi3BvBQHoI8XZiTcpNNdXDqud9H/krjqWWDLQ7vquCI4j16ZVP4
         wxqQ==
X-Forwarded-Encrypted: i=1; AJvYcCWLOPnnIHjC9jlI571KQnDDWdvo9gsEApUEqkbMnflMLoKhGhLFtr3MCbK/ehRlzOEk8OZ+Pdnbpg==@vger.kernel.org
X-Gm-Message-State: AOJu0YzH2fONayuzYvjM9Wa0AuU7X6Z3RaVXrWNtHzOn3q8gD5lmbw1f
	d36JxXfbMpF8a8ofvANRfG3OSd9Tz7tEDQK6oUIZDlPFA7l3svm+04i8OjKQyjgPzhtkW2j32Ck
	uxplWj8iblk+2uaklvrFvN0fjFJhA2TJq09G76FuntD5qgdEje2j9m0D+aLM=
X-Google-Smtp-Source: AGHT+IGK4UeWYvxGWMgYwWA9ELfCGtqStvan7sq+2r5x9kZNSmHWn+R1UWjwphnjWMSmAcQTGWYI8UB9H594RT5K+G5PV6EUnTdT
Precedence: bulk
X-Mailing-List: io-uring@vger.kernel.org
List-Id: <io-uring.vger.kernel.org>
List-Subscribe: <mailto:io-uring+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:io-uring+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-Received: by 2002:a05:6e02:1a6f:b0:3dc:79e5:e6a8 with SMTP id
 e9e14a558f8ab-3e154e4e5ebmr19703635ab.15.1751962346500; Tue, 08 Jul 2025
 01:12:26 -0700 (PDT)
Date: Tue, 08 Jul 2025 01:12:26 -0700
X-Google-Appengine-App-Id: s~syzkaller
X-Google-Appengine-App-Id-Alias: syzkaller
Message-ID: <686cd2ea.a00a0220.338033.0007.GAE@google.com>
Subject: [syzbot] [io-uring?] KASAN: slab-use-after-free Read in __io_req_task_work_add
From: syzbot <syzbot+54cbbfb4db9145d26fc2@syzkaller.appspotmail.com>
To: axboe@kernel.dk, io-uring@vger.kernel.org, linux-kernel@vger.kernel.org, 
	syzkaller-bugs@googlegroups.com
Content-Type: text/plain; charset="UTF-8"

Hello,

syzbot found the following issue on:

HEAD commit:    17bbde2e1716 Merge tag 'net-6.16-rc5' of git://git.kernel...
git tree:       upstream
console output: https://syzkaller.appspot.com/x/log.txt?x=167ef770580000
kernel config:  https://syzkaller.appspot.com/x/.config?x=a6dba31fc9bb876c
dashboard link: https://syzkaller.appspot.com/bug?extid=54cbbfb4db9145d26fc2
compiler:       Debian clang version 20.1.7 (++20250616065708+6146a88f6049-1~exp1~20250616065826.132), Debian LLD 20.1.7

Unfortunately, I don't have any reproducer for this issue yet.

Downloadable assets:
disk image: https://storage.googleapis.com/syzbot-assets/1dca76eb941c/disk-17bbde2e.raw.xz
vmlinux: https://storage.googleapis.com/syzbot-assets/eb2bd74cc76e/vmlinux-17bbde2e.xz
kernel image: https://storage.googleapis.com/syzbot-assets/43f10448e78b/bzImage-17bbde2e.xz

IMPORTANT: if you fix the issue, please add the following tag to the commit:
Reported-by: syzbot+54cbbfb4db9145d26fc2@syzkaller.appspotmail.com

==================================================================
BUG: KASAN: slab-use-after-free in io_req_local_work_add io_uring/io_uring.c:1184 [inline]
BUG: KASAN: slab-use-after-free in __io_req_task_work_add+0x589/0x950 io_uring/io_uring.c:1252
Read of size 4 at addr ffff88804f04f044 by task iou-wrk-19354/19356

CPU: 1 UID: 0 PID: 19356 Comm: iou-wrk-19354 Not tainted 6.16.0-rc4-syzkaller-00108-g17bbde2e1716 #0 PREEMPT(full) 
Hardware name: Google Google Compute Engine/Google Compute Engine, BIOS Google 05/07/2025
Call Trace:
 <TASK>
 dump_stack_lvl+0x189/0x250 lib/dump_stack.c:120
 print_address_description mm/kasan/report.c:408 [inline]
 print_report+0xd2/0x2b0 mm/kasan/report.c:521
 kasan_report+0x118/0x150 mm/kasan/report.c:634
 io_req_local_work_add io_uring/io_uring.c:1184 [inline]
 __io_req_task_work_add+0x589/0x950 io_uring/io_uring.c:1252
 io_msg_remote_post io_uring/msg_ring.c:103 [inline]
 io_msg_data_remote io_uring/msg_ring.c:133 [inline]
 __io_msg_ring_data+0x820/0xaa0 io_uring/msg_ring.c:151
 io_msg_ring_data io_uring/msg_ring.c:173 [inline]
 io_msg_ring+0x134/0xa00 io_uring/msg_ring.c:314
 __io_issue_sqe+0x17e/0x4b0 io_uring/io_uring.c:1739
 io_issue_sqe+0x165/0xfd0 io_uring/io_uring.c:1762
 io_wq_submit_work+0x6e9/0xb90 io_uring/io_uring.c:1874
 io_worker_handle_work+0x7cd/0x1180 io_uring/io-wq.c:642
 io_wq_worker+0x42f/0xeb0 io_uring/io-wq.c:696
 ret_from_fork+0x3fc/0x770 arch/x86/kernel/process.c:148
 ret_from_fork_asm+0x1a/0x30 arch/x86/entry/entry_64.S:245
 </TASK>

Allocated by task 19354:
 kasan_save_stack mm/kasan/common.c:47 [inline]
 kasan_save_track+0x3e/0x80 mm/kasan/common.c:68
 unpoison_slab_object mm/kasan/common.c:319 [inline]
 __kasan_slab_alloc+0x6c/0x80 mm/kasan/common.c:345
 kasan_slab_alloc include/linux/kasan.h:250 [inline]
 slab_post_alloc_hook mm/slub.c:4148 [inline]
 slab_alloc_node mm/slub.c:4197 [inline]
 kmem_cache_alloc_noprof+0x1c1/0x3c0 mm/slub.c:4204
 io_msg_get_kiocb io_uring/msg_ring.c:117 [inline]
 io_msg_data_remote io_uring/msg_ring.c:126 [inline]
 __io_msg_ring_data+0x47b/0xaa0 io_uring/msg_ring.c:151
 io_msg_ring_data io_uring/msg_ring.c:173 [inline]
 io_msg_ring+0x134/0xa00 io_uring/msg_ring.c:314
 __io_issue_sqe+0x17e/0x4b0 io_uring/io_uring.c:1739
 io_issue_sqe+0x165/0xfd0 io_uring/io_uring.c:1762
 io_queue_sqe io_uring/io_uring.c:1969 [inline]
 io_submit_sqe io_uring/io_uring.c:2225 [inline]
 io_submit_sqes+0xa38/0x1c50 io_uring/io_uring.c:2338
 __do_sys_io_uring_enter io_uring/io_uring.c:3405 [inline]
 __se_sys_io_uring_enter+0x2df/0x2b20 io_uring/io_uring.c:3339
 do_syscall_x64 arch/x86/entry/syscall_64.c:63 [inline]
 do_syscall_64+0xfa/0x3b0 arch/x86/entry/syscall_64.c:94
 entry_SYSCALL_64_after_hwframe+0x77/0x7f

Freed by task 19354:
 kasan_save_stack mm/kasan/common.c:47 [inline]
 kasan_save_track+0x3e/0x80 mm/kasan/common.c:68
 kasan_save_free_info+0x46/0x50 mm/kasan/generic.c:576
 poison_slab_object mm/kasan/common.c:247 [inline]
 __kasan_mempool_poison_object+0xad/0x130 mm/kasan/common.c:522
 kasan_mempool_poison_object include/linux/kasan.h:360 [inline]
 io_alloc_cache_put io_uring/alloc_cache.h:23 [inline]
 io_msg_tw_complete+0x12c/0x510 io_uring/msg_ring.c:80
 __io_run_local_work_loop io_uring/io_uring.c:1295 [inline]
 __io_run_local_work+0x350/0x810 io_uring/io_uring.c:1328
 io_run_local_work_locked io_uring/io_uring.c:1350 [inline]
 __do_sys_io_uring_enter io_uring/io_uring.c:3418 [inline]
 __se_sys_io_uring_enter+0x1725/0x2b20 io_uring/io_uring.c:3339
 do_syscall_x64 arch/x86/entry/syscall_64.c:63 [inline]
 do_syscall_64+0xfa/0x3b0 arch/x86/entry/syscall_64.c:94
 entry_SYSCALL_64_after_hwframe+0x77/0x7f

The buggy address belongs to the object at ffff88804f04f000
 which belongs to the cache io_kiocb of size 248
The buggy address is located 68 bytes inside of
 freed 248-byte region [ffff88804f04f000, ffff88804f04f0f8)

The buggy address belongs to the physical page:
page: refcount:0 mapcount:0 mapping:0000000000000000 index:0x0 pfn:0x4f04f
memcg:ffff88805b8eca01
flags: 0xfff00000000000(node=0|zone=1|lastcpupid=0x7ff)
page_type: f5(slab)
raw: 00fff00000000000 ffff88801ff1e3c0 ffffea0001f19540 0000000000000008
raw: 0000000000000000 00000000000c000c 00000000f5000000 ffff88805b8eca01
page dumped because: kasan: bad access detected
page_owner tracks the page as allocated
page last allocated via order 0, migratetype Unmovable, gfp_mask 0x52cc0(GFP_KERNEL|__GFP_NOWARN|__GFP_NORETRY|__GFP_COMP), pid 19106, tgid 19105 (syz.3.4309), ts 738394506846, free_ts 738346896625
 set_page_owner include/linux/page_owner.h:32 [inline]
 post_alloc_hook+0x240/0x2a0 mm/page_alloc.c:1704
 prep_new_page mm/page_alloc.c:1712 [inline]
 get_page_from_freelist+0x21e4/0x22c0 mm/page_alloc.c:3669
 __alloc_frozen_pages_noprof+0x181/0x370 mm/page_alloc.c:4959
 alloc_pages_mpol+0x232/0x4a0 mm/mempolicy.c:2419
 alloc_slab_page mm/slub.c:2451 [inline]
 allocate_slab+0x8a/0x3b0 mm/slub.c:2619
 new_slab mm/slub.c:2673 [inline]
 ___slab_alloc+0xbfc/0x1480 mm/slub.c:3859
 __kmem_cache_alloc_bulk mm/slub.c:5294 [inline]
 kmem_cache_alloc_bulk_noprof+0x20e/0x790 mm/slub.c:5366
 __io_alloc_req_refill+0x9d/0x280 io_uring/io_uring.c:972
 io_alloc_req io_uring/io_uring.h:447 [inline]
 io_submit_sqes+0xc31/0x1c50 io_uring/io_uring.c:2327
 __do_sys_io_uring_enter io_uring/io_uring.c:3405 [inline]
 __se_sys_io_uring_enter+0x2df/0x2b20 io_uring/io_uring.c:3339
 do_syscall_x64 arch/x86/entry/syscall_64.c:63 [inline]
 do_syscall_64+0xfa/0x3b0 arch/x86/entry/syscall_64.c:94
 entry_SYSCALL_64_after_hwframe+0x77/0x7f
page last free pid 6405 tgid 6405 stack trace:
 reset_page_owner include/linux/page_owner.h:25 [inline]
 free_pages_prepare mm/page_alloc.c:1248 [inline]
 __free_frozen_pages+0xc71/0xe70 mm/page_alloc.c:2706
 pagetable_free include/linux/mm.h:2879 [inline]
 pagetable_dtor_free include/linux/mm.h:2977 [inline]
 __tlb_remove_table+0x2d2/0x3b0 include/asm-generic/tlb.h:220
 __tlb_remove_table_free mm/mmu_gather.c:227 [inline]
 tlb_remove_table_rcu+0x85/0x100 mm/mmu_gather.c:290
 rcu_do_batch kernel/rcu/tree.c:2576 [inline]
 rcu_core+0xca5/0x1710 kernel/rcu/tree.c:2832
 handle_softirqs+0x286/0x870 kernel/softirq.c:579
 do_softirq+0xec/0x180 kernel/softirq.c:480
 __local_bh_enable_ip+0x17d/0x1c0 kernel/softirq.c:407
 spin_unlock_bh include/linux/spinlock.h:396 [inline]
 batadv_nc_purge_paths+0x318/0x3b0 net/batman-adv/network-coding.c:471
 batadv_nc_worker+0x328/0x610 net/batman-adv/network-coding.c:720
 process_one_work kernel/workqueue.c:3238 [inline]
 process_scheduled_works+0xade/0x17b0 kernel/workqueue.c:3321
 worker_thread+0x8a0/0xda0 kernel/workqueue.c:3402
 kthread+0x70e/0x8a0 kernel/kthread.c:464
 ret_from_fork+0x3fc/0x770 arch/x86/kernel/process.c:148
 ret_from_fork_asm+0x1a/0x30 arch/x86/entry/entry_64.S:245

Memory state around the buggy address:
 ffff88804f04ef00: 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00
 ffff88804f04ef80: 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00
>ffff88804f04f000: fa fb fb fb fb fb fb fb fb fb fb fb fb fb fb fb
                                           ^
 ffff88804f04f080: fb fb fb fb fb fb fb fb fb fb fb fb fb fb fb fc
 ffff88804f04f100: fc fc fc fc fc fc fc fc 00 00 00 00 00 00 00 00
==================================================================


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

