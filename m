Return-Path: <io-uring+bounces-10833-lists+io-uring=lfdr.de@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from ams.mirrors.kernel.org (ams.mirrors.kernel.org [213.196.21.55])
	by mail.lfdr.de (Postfix) with ESMTPS id E7ABDC9158B
	for <lists+io-uring@lfdr.de>; Fri, 28 Nov 2025 10:02:34 +0100 (CET)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ams.mirrors.kernel.org (Postfix) with ESMTPS id F0B8E34A747
	for <lists+io-uring@lfdr.de>; Fri, 28 Nov 2025 09:02:33 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 8F3732FF64D;
	Fri, 28 Nov 2025 09:02:28 +0000 (UTC)
X-Original-To: io-uring@vger.kernel.org
Received: from mail-io1-f79.google.com (mail-io1-f79.google.com [209.85.166.79])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A85BA2FD7A4
	for <io-uring@vger.kernel.org>; Fri, 28 Nov 2025 09:02:26 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.166.79
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1764320548; cv=none; b=AOIVNhtzxJexvMVz5ENGIBr1ge24ikKx0uncmX2/+yPwCopmH9TJSIOmPzf7ZF+XF92k2HfkBlw4KOpt0ySPhD8ijhX1Gv2HY6XDNc9V8cyxWWUJDsYnR9AINfXzHxoeI9PZqrnp6i1OHCkuXICT1O88VYUc81WScpNSLVG+d6w=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1764320548; c=relaxed/simple;
	bh=qbap086vlbOmIJVOikXwOELw6UDhLvkYMczxzss9hzg=;
	h=MIME-Version:Date:Message-ID:Subject:From:To:Content-Type; b=sJkQsSgcZR1leHRLZIEUT2URxcOedfNaTnrL/Gs1LwQJ0grdi/jgvm3Yr/1kA2AfPYpG7t02RYHpWahfTmRgWrdjnM0tBIKVAdKeabjfxWiYyywVmEGnTswYOe+S6kxAI/g0t2n/yjw/IfQRVlZK1g9LItxktetarzL4bPc5B4c=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=fail (p=none dis=none) header.from=syzkaller.appspotmail.com; spf=pass smtp.mailfrom=M3KW2WVRGUFZ5GODRSRYTGD7.apphosting.bounces.google.com; arc=none smtp.client-ip=209.85.166.79
Authentication-Results: smtp.subspace.kernel.org; dmarc=fail (p=none dis=none) header.from=syzkaller.appspotmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=M3KW2WVRGUFZ5GODRSRYTGD7.apphosting.bounces.google.com
Received: by mail-io1-f79.google.com with SMTP id ca18e2360f4ac-9486920a552so123459139f.3
        for <io-uring@vger.kernel.org>; Fri, 28 Nov 2025 01:02:26 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1764320546; x=1764925346;
        h=to:from:subject:message-id:date:mime-version:x-gm-message-state
         :from:to:cc:subject:date:message-id:reply-to;
        bh=5hP+joNxjBnAC1moShX75Na/N8vts7Gci+83UwXi/7o=;
        b=hYI6eamXGB2GJ7xPicZ9MDnAXEaDAc+XtyTlgh8DHWxdqEWsdKFnFBLPLf1Ka7fdzl
         RFHrr6C12G6Mxe1lwMXRVOOTBIfdWueb8UGmXsxNsqflFPsoT00zh9nrDjVG+Qmi3VwV
         GvztxLGw0xUWQ1BKrwzDkFADE6u38VRdTJ0IdcXUOyn7ftWD0tF8Xh90jJZYGbN+i0X0
         kqGaTG3PwdbPlPQY7EGAjwnqLuCi7idSGExiThnyv4gv9Be0WFfB3MHw004OH01kK+N+
         hTFeq47UxWA7YsnbQKhtGHVQMwFvdhhJRZToWcRm9gF8y0rl/qMXPbnhcEY81TwVLQE8
         99hw==
X-Forwarded-Encrypted: i=1; AJvYcCWys1w25h7aZT94+roME+WJl4gzEgU7mgd5/ldEYQ0coeQoos8uwDK9jo2s+02xT6TYS/5ViuQZ7A==@vger.kernel.org
X-Gm-Message-State: AOJu0YyiRzrh/TVdMDdaWtke2vHPL0ywHDGp5/929RJ2iIWkAhUvdrZm
	hJr8KMcje16DSdVipT41OovOIw7QDgtl+4fOnWoFbzASdMGi8UII4yJvHMxLJO3eOoxjoPK+6xw
	MowcC9RIplws0SXqVZ3evKM/8rpIerdoALLhJE+ZZ2Cpa3+t/lvi2HG78Ehw=
X-Google-Smtp-Source: AGHT+IFpHM8thsrdrbl4IdtLGLIsU6sQbK0iVMNSM68cvbwekru7dS3XpTr4Jq9qirQKOR0Uo/RJJGT3hSrpbX77dRShlW5dApMJ
Precedence: bulk
X-Mailing-List: io-uring@vger.kernel.org
List-Id: <io-uring.vger.kernel.org>
List-Subscribe: <mailto:io-uring+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:io-uring+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-Received: by 2002:a05:6e02:178f:b0:435:a462:552 with SMTP id
 e9e14a558f8ab-435dd0e8d19mr99860585ab.19.1764320545801; Fri, 28 Nov 2025
 01:02:25 -0800 (PST)
Date: Fri, 28 Nov 2025 01:02:25 -0800
X-Google-Appengine-App-Id: s~syzkaller
X-Google-Appengine-App-Id-Alias: syzkaller
Message-ID: <69296521.a70a0220.d98e3.0135.GAE@google.com>
Subject: [syzbot] [io-uring?] KASAN: slab-use-after-free Read in
 io_poll_remove_entries (2)
From: syzbot <syzbot+721cddf316143353975e@syzkaller.appspotmail.com>
To: axboe@kernel.dk, io-uring@vger.kernel.org, linux-kernel@vger.kernel.org, 
	syzkaller-bugs@googlegroups.com
Content-Type: text/plain; charset="UTF-8"

Hello,

syzbot found the following issue on:

HEAD commit:    ef68bf704646 Add linux-next specific files for 20251127
git tree:       linux-next
console output: https://syzkaller.appspot.com/x/log.txt?x=113a9e92580000
kernel config:  https://syzkaller.appspot.com/x/.config?x=75e4ba9be1d3d04
dashboard link: https://syzkaller.appspot.com/bug?extid=721cddf316143353975e
compiler:       Debian clang version 20.1.8 (++20250708063551+0c9f909b7976-1~exp1~20250708183702.136), Debian LLD 20.1.8

Unfortunately, I don't have any reproducer for this issue yet.

Downloadable assets:
disk image: https://storage.googleapis.com/syzbot-assets/d2c8379aac84/disk-ef68bf70.raw.xz
vmlinux: https://storage.googleapis.com/syzbot-assets/c5f8945ec4ba/vmlinux-ef68bf70.xz
kernel image: https://storage.googleapis.com/syzbot-assets/dab0de6e99a6/bzImage-ef68bf70.xz

IMPORTANT: if you fix the issue, please add the following tag to the commit:
Reported-by: syzbot+721cddf316143353975e@syzkaller.appspotmail.com

==================================================================
BUG: KASAN: slab-use-after-free in __raw_spin_lock_irq include/linux/spinlock_api_smp.h:119 [inline]
BUG: KASAN: slab-use-after-free in _raw_spin_lock_irq+0xa2/0xf0 kernel/locking/spinlock.c:170
Read of size 1 at addr ffff88801c7f2d50 by task kworker/0:8/5987

CPU: 0 UID: 0 PID: 5987 Comm: kworker/0:8 Not tainted syzkaller #0 PREEMPT(full) 
Hardware name: Google Google Compute Engine/Google Compute Engine, BIOS Google 10/25/2025
Workqueue: events io_fallback_req_func
Call Trace:
 <TASK>
 dump_stack_lvl+0x189/0x250 lib/dump_stack.c:120
 print_address_description mm/kasan/report.c:378 [inline]
 print_report+0xca/0x240 mm/kasan/report.c:482
 kasan_report+0x118/0x150 mm/kasan/report.c:595
 __kasan_check_byte+0x2a/0x40 mm/kasan/common.c:573
 kasan_check_byte include/linux/kasan.h:401 [inline]
 lock_acquire+0x84/0x340 kernel/locking/lockdep.c:5842
 __raw_spin_lock_irq include/linux/spinlock_api_smp.h:119 [inline]
 _raw_spin_lock_irq+0xa2/0xf0 kernel/locking/spinlock.c:170
 spin_lock_irq include/linux/spinlock.h:376 [inline]
 io_poll_remove_entry io_uring/poll.c:146 [inline]
 io_poll_remove_entries+0x1eb/0x620 io_uring/poll.c:179
 io_poll_task_func+0x6f6/0xd10 io_uring/poll.c:325
 io_fallback_req_func+0x126/0x210 io_uring/io_uring.c:246
 process_one_work+0x93a/0x15a0 kernel/workqueue.c:3261
 process_scheduled_works kernel/workqueue.c:3344 [inline]
 worker_thread+0x9b0/0xee0 kernel/workqueue.c:3425
 kthread+0x711/0x8a0 kernel/kthread.c:463
 ret_from_fork+0x599/0xb30 arch/x86/kernel/process.c:158
 ret_from_fork_asm+0x1a/0x30 arch/x86/entry/entry_64.S:246
 </TASK>

Allocated by task 10303:
 kasan_save_stack mm/kasan/common.c:56 [inline]
 kasan_save_track+0x3e/0x80 mm/kasan/common.c:77
 unpoison_slab_object mm/kasan/common.c:339 [inline]
 __kasan_slab_alloc+0x6c/0x80 mm/kasan/common.c:365
 kasan_slab_alloc include/linux/kasan.h:252 [inline]
 slab_post_alloc_hook mm/slub.c:4948 [inline]
 slab_alloc_node mm/slub.c:5258 [inline]
 kmem_cache_alloc_lru_noprof+0x36c/0x6e0 mm/slub.c:5277
 mqueue_alloc_inode+0x28/0x40 ipc/mqueue.c:502
 alloc_inode+0x6a/0x1b0 fs/inode.c:346
 new_inode+0x22/0x170 fs/inode.c:1175
 mqueue_get_inode+0x27/0xb50 ipc/mqueue.c:297
 mqueue_create_attr+0x1ac/0x2e0 ipc/mqueue.c:590
 vfs_mkobj+0xcf/0x290 fs/namei.c:4153
 prepare_open ipc/mqueue.c:876 [inline]
 mqueue_file_open ipc/mqueue.c:905 [inline]
 do_mq_open+0x60d/0x7c0 ipc/mqueue.c:928
 __do_sys_mq_open ipc/mqueue.c:941 [inline]
 __se_sys_mq_open ipc/mqueue.c:934 [inline]
 __x64_sys_mq_open+0x16a/0x1c0 ipc/mqueue.c:934
 do_syscall_x64 arch/x86/entry/syscall_64.c:63 [inline]
 do_syscall_64+0xfa/0xf80 arch/x86/entry/syscall_64.c:94
 entry_SYSCALL_64_after_hwframe+0x77/0x7f

Freed by task 0:
 kasan_save_stack mm/kasan/common.c:56 [inline]
 kasan_save_track+0x3e/0x80 mm/kasan/common.c:77
 kasan_save_free_info+0x46/0x50 mm/kasan/generic.c:584
 poison_slab_object mm/kasan/common.c:252 [inline]
 __kasan_slab_free+0x5c/0x80 mm/kasan/common.c:284
 kasan_slab_free include/linux/kasan.h:234 [inline]
 slab_free_hook mm/slub.c:2540 [inline]
 slab_free mm/slub.c:6663 [inline]
 kmem_cache_free+0x197/0x620 mm/slub.c:6774
 rcu_do_batch kernel/rcu/tree.c:2605 [inline]
 rcu_core+0xd70/0x1870 kernel/rcu/tree.c:2857
 handle_softirqs+0x27d/0x850 kernel/softirq.c:626
 __do_softirq kernel/softirq.c:660 [inline]
 invoke_softirq kernel/softirq.c:496 [inline]
 __irq_exit_rcu+0xca/0x1f0 kernel/softirq.c:727
 irq_exit_rcu+0x9/0x30 kernel/softirq.c:743
 instr_sysvec_apic_timer_interrupt arch/x86/kernel/apic/apic.c:1056 [inline]
 sysvec_apic_timer_interrupt+0xa6/0xc0 arch/x86/kernel/apic/apic.c:1056
 asm_sysvec_apic_timer_interrupt+0x1a/0x20 arch/x86/include/asm/idtentry.h:697

Last potentially related work creation:
 kasan_save_stack+0x3e/0x60 mm/kasan/common.c:56
 kasan_record_aux_stack+0xbd/0xd0 mm/kasan/generic.c:556
 __call_rcu_common kernel/rcu/tree.c:3119 [inline]
 call_rcu+0x157/0x9c0 kernel/rcu/tree.c:3239
 destroy_inode fs/inode.c:401 [inline]
 evict+0x931/0xae0 fs/inode.c:861
 __dentry_kill+0x209/0x660 fs/dcache.c:670
 finish_dput+0xc9/0x480 fs/dcache.c:879
 __fput+0x68e/0xa70 fs/file_table.c:476
 task_work_run+0x1d4/0x260 kernel/task_work.c:233
 resume_user_mode_work include/linux/resume_user_mode.h:50 [inline]
 __exit_to_user_mode_loop kernel/entry/common.c:44 [inline]
 exit_to_user_mode_loop+0xff/0x4f0 kernel/entry/common.c:75
 __exit_to_user_mode_prepare include/linux/irq-entry-common.h:226 [inline]
 syscall_exit_to_user_mode_prepare include/linux/irq-entry-common.h:256 [inline]
 syscall_exit_to_user_mode_work include/linux/entry-common.h:159 [inline]
 syscall_exit_to_user_mode include/linux/entry-common.h:194 [inline]
 do_syscall_64+0x2e3/0xf80 arch/x86/entry/syscall_64.c:100
 entry_SYSCALL_64_after_hwframe+0x77/0x7f

The buggy address belongs to the object at ffff88801c7f2880
 which belongs to the cache mqueue_inode_cache of size 1576
The buggy address is located 1232 bytes inside of
 freed 1576-byte region [ffff88801c7f2880, ffff88801c7f2ea8)

The buggy address belongs to the physical page:
page: refcount:0 mapcount:0 mapping:0000000000000000 index:0xffff88801c7f1440 pfn:0x1c7f0
head: order:3 mapcount:0 entire_mapcount:0 nr_pages_mapped:0 pincount:0
memcg:ffff88802ea71f01
flags: 0xfff00000000040(head|node=0|zone=1|lastcpupid=0x7ff)
page_type: f5(slab)
raw: 00fff00000000040 ffff88801cf88c80 dead000000000122 0000000000000000
raw: ffff88801c7f1440 000000008012000e 00000000f5000000 ffff88802ea71f01
head: 00fff00000000040 ffff88801cf88c80 dead000000000122 0000000000000000
head: ffff88801c7f1440 000000008012000e 00000000f5000000 ffff88802ea71f01
head: 00fff00000000003 ffffea000071fc01 00000000ffffffff 00000000ffffffff
head: ffffffffffffffff 0000000000000000 00000000ffffffff 0000000000000008
page dumped because: kasan: bad access detected
page_owner tracks the page as allocated
page last allocated via order 3, migratetype Unmovable, gfp_mask 0xd20c0(__GFP_IO|__GFP_FS|__GFP_NOWARN|__GFP_NORETRY|__GFP_COMP|__GFP_NOMEMALLOC), pid 1, tgid 1 (swapper/0), ts 9112271990, free_ts 0
 set_page_owner include/linux/page_owner.h:32 [inline]
 post_alloc_hook+0x234/0x290 mm/page_alloc.c:1846
 prep_new_page mm/page_alloc.c:1854 [inline]
 get_page_from_freelist+0x2365/0x2440 mm/page_alloc.c:3915
 __alloc_frozen_pages_noprof+0x181/0x370 mm/page_alloc.c:5210
 alloc_pages_mpol+0x232/0x4a0 mm/mempolicy.c:2486
 alloc_slab_page mm/slub.c:3075 [inline]
 allocate_slab+0x86/0x3b0 mm/slub.c:3248
 new_slab mm/slub.c:3302 [inline]
 ___slab_alloc+0xf2b/0x1960 mm/slub.c:4651
 __slab_alloc+0x65/0x100 mm/slub.c:4774
 __slab_alloc_node mm/slub.c:4850 [inline]
 slab_alloc_node mm/slub.c:5246 [inline]
 kmem_cache_alloc_lru_noprof+0x3fe/0x6e0 mm/slub.c:5277
 mqueue_alloc_inode+0x28/0x40 ipc/mqueue.c:502
 alloc_inode+0x6a/0x1b0 fs/inode.c:346
 new_inode+0x22/0x170 fs/inode.c:1175
 mqueue_get_inode ipc/mqueue.c:297 [inline]
 mqueue_fill_super+0xdc/0x380 ipc/mqueue.c:416
 vfs_get_super fs/super.c:1324 [inline]
 get_tree_nodev+0xbb/0x150 fs/super.c:1343
 vfs_get_tree+0x92/0x2a0 fs/super.c:1751
 fc_mount fs/namespace.c:1209 [inline]
 fc_mount_longterm+0x1c/0x100 fs/namespace.c:1220
 mq_create_mount ipc/mqueue.c:486 [inline]
 mq_init_ns+0x275/0x360 ipc/mqueue.c:1639
page_owner free stack trace missing

Memory state around the buggy address:
 ffff88801c7f2c00: fb fb fb fb fb fb fb fb fb fb fb fb fb fb fb fb
 ffff88801c7f2c80: fb fb fb fb fb fb fb fb fb fb fb fb fb fb fb fb
>ffff88801c7f2d00: fb fb fb fb fb fb fb fb fb fb fb fb fb fb fb fb
                                                 ^
 ffff88801c7f2d80: fb fb fb fb fb fb fb fb fb fb fb fb fb fb fb fb
 ffff88801c7f2e00: fb fb fb fb fb fb fb fb fb fb fb fb fb fb fb fb
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

