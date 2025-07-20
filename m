Return-Path: <io-uring+bounces-8735-lists+io-uring=lfdr.de@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [147.75.199.223])
	by mail.lfdr.de (Postfix) with ESMTPS id ACEA3B0B306
	for <lists+io-uring@lfdr.de>; Sun, 20 Jul 2025 02:49:09 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id 94EE017B3B3
	for <lists+io-uring@lfdr.de>; Sun, 20 Jul 2025 00:49:09 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 01D0712B93;
	Sun, 20 Jul 2025 00:49:05 +0000 (UTC)
X-Original-To: io-uring@vger.kernel.org
Received: from mail-il1-f197.google.com (mail-il1-f197.google.com [209.85.166.197])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3BCF08BEE
	for <io-uring@vger.kernel.org>; Sun, 20 Jul 2025 00:49:03 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.166.197
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1752972544; cv=none; b=BQGXWotuKBuBVzZ2FJ+/vLZJi/oUgG96nhhXRUh0nw0Z8zXANoqdozB1ZdTeg9r3Q3I1OFYhd3dLkC9F7aqii8RnO7QGses1O0Dv9jPEnY9jHYXk7mCWV/TL3rmu9lL592Cx+I9J9WUStOVpaRYvOqOik69+E/McfJOch209MWI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1752972544; c=relaxed/simple;
	bh=SyIw561S75HUB9HZLz+AMJVXYY18r6r3HIU5TAWd06s=;
	h=MIME-Version:Date:In-Reply-To:Message-ID:Subject:From:To:
	 Content-Type; b=n+0yLQM6ZslWzIWa27r/h/eDSxDWbrNtYlXo1D4QBcfe9FKJVv4tTeo0sGKJT/qQErgqCWktyjSPAFTUDGVFdZlGSsVyimIOY5Vpt9b1RqDSwu+o1NT6tF1GlbfZi0sZBc2bY6ZV6Xs+dalF5M3KCVyRIMoNhBmrLnCuIKLQtyc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=fail (p=none dis=none) header.from=syzkaller.appspotmail.com; spf=pass smtp.mailfrom=M3KW2WVRGUFZ5GODRSRYTGD7.apphosting.bounces.google.com; arc=none smtp.client-ip=209.85.166.197
Authentication-Results: smtp.subspace.kernel.org; dmarc=fail (p=none dis=none) header.from=syzkaller.appspotmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=M3KW2WVRGUFZ5GODRSRYTGD7.apphosting.bounces.google.com
Received: by mail-il1-f197.google.com with SMTP id e9e14a558f8ab-3ddbec809acso38001585ab.2
        for <io-uring@vger.kernel.org>; Sat, 19 Jul 2025 17:49:02 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1752972542; x=1753577342;
        h=to:from:subject:message-id:in-reply-to:date:mime-version
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=xG7qngR7y21j9Z9LYHBRWnNSkwfERvghxDYDOziSJkk=;
        b=jXe5+loclsDeZ1fuQS/dtH/Y610TGGCLh46PCmuNTJmtR7BYfK1PckXJI0QTgKrwUT
         n26dqa9QSqJVMcz7/PHT29u87kYMMbU3pvMj56KB/rLj6VveGSXs83bZ0uTeaB8PfLKd
         U7PZiwY4Y8rGKsSur3Zit8s07u2wdh1t1xdpxEpKG7picsK7z21RDZnMg6GYA4tBXvkJ
         wb6gGaQ6QFL1jOzQ/CUnCBjfoKQUv4creOPXBNfWSdDUodeZcjrUohX684IPTXbeMtG2
         Aq4909zJNjkLi1Ib+xkw6Qc6qbh3tHyQoMGw7ZYCL1khYoCZbF8/+cJ9mylQSaKpETKv
         TJEQ==
X-Forwarded-Encrypted: i=1; AJvYcCW3afuH4Hnj+0JNn6WQMr4jLSlDqFv239RefWIFGLhjVzUrR+0V+GHczOqU0JIduaqUNscSUes86A==@vger.kernel.org
X-Gm-Message-State: AOJu0YxmvDxhd2/bEMZszxKG3jCaOlSdLFZ9q+PXb6OhSGw+Vnf31yxw
	hlHn7igRxhXJgxMrGSMPJSAC0Lzc45uCoecp/vQ1AtyExmHAfclB6vBQ1m/CZTDFb/qTxrCfDT/
	k4v2JfO4T4DP8T13IT+CkQAt2biCNe2D0dkZ62cZ6HxmqtdAxidnjVt0xnUk=
X-Google-Smtp-Source: AGHT+IG3uxIG9+Yibj5IoSRQn4r8h/MCKJfsbYdF1AwrtVn3R1/LeymXummtUIrAloj5w9vZH8W/60cTkpFZypOuSL31dQ9zZJcY
Precedence: bulk
X-Mailing-List: io-uring@vger.kernel.org
List-Id: <io-uring.vger.kernel.org>
List-Subscribe: <mailto:io-uring+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:io-uring+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-Received: by 2002:a05:6e02:1709:b0:3e2:9aea:8049 with SMTP id
 e9e14a558f8ab-3e29aea823fmr56886345ab.13.1752972542356; Sat, 19 Jul 2025
 17:49:02 -0700 (PDT)
Date: Sat, 19 Jul 2025 17:49:02 -0700
In-Reply-To: <20250720003607.2491-1-hdanton@sina.com>
X-Google-Appengine-App-Id: s~syzkaller
X-Google-Appengine-App-Id-Alias: syzkaller
Message-ID: <687c3cfe.a70a0220.693ce.00a0.GAE@google.com>
Subject: Re: [syzbot] [io-uring?] KASAN: slab-use-after-free Read in io_poll_remove_entries
From: syzbot <syzbot+01523a0ae5600aef5895@syzkaller.appspotmail.com>
To: axboe@kernel.dk, hdanton@sina.com, io-uring@vger.kernel.org, 
	linux-kernel@vger.kernel.org, syzkaller-bugs@googlegroups.com
Content-Type: text/plain; charset="UTF-8"

Hello,

syzbot has tested the proposed patch but the reproducer is still triggering an issue:
KASAN: slab-use-after-free Read in io_poll_remove_entries

==================================================================
BUG: KASAN: slab-use-after-free in __raw_spin_lock_irq include/linux/spinlock_api_smp.h:119 [inline]
BUG: KASAN: slab-use-after-free in _raw_spin_lock_irq+0x36/0x50 kernel/locking/spinlock.c:170
Read of size 1 at addr ffff888025296ab0 by task kworker/0:2/837

CPU: 0 UID: 0 PID: 837 Comm: kworker/0:2 Not tainted 6.16.0-rc6-syzkaller-00281-gf4a40a4282f4-dirty #0 PREEMPT(full) 
Hardware name: QEMU Standard PC (Q35 + ICH9, 2009), BIOS 1.16.3-debian-1.16.3-2~bpo12+1 04/01/2014
Workqueue: events io_fallback_req_func
Call Trace:
 <TASK>
 __dump_stack lib/dump_stack.c:94 [inline]
 dump_stack_lvl+0x116/0x1f0 lib/dump_stack.c:120
 print_address_description mm/kasan/report.c:378 [inline]
 print_report+0xcd/0x610 mm/kasan/report.c:480
 kasan_report+0xe0/0x110 mm/kasan/report.c:593
 __kasan_check_byte+0x36/0x50 mm/kasan/common.c:557
 kasan_check_byte include/linux/kasan.h:399 [inline]
 lock_acquire kernel/locking/lockdep.c:5845 [inline]
 lock_acquire+0xfc/0x350 kernel/locking/lockdep.c:5828
 __raw_spin_lock_irq include/linux/spinlock_api_smp.h:119 [inline]
 _raw_spin_lock_irq+0x36/0x50 kernel/locking/spinlock.c:170
 spin_lock_irq include/linux/spinlock.h:376 [inline]
 io_poll_remove_entry io_uring/poll.c:148 [inline]
 io_poll_remove_entries.part.0+0x17b/0x850 io_uring/poll.c:181
 io_poll_remove_entries io_uring/poll.c:161 [inline]
 io_poll_task_func+0x4cd/0x1130 io_uring/poll.c:328
 io_fallback_req_func+0x1c7/0x6d0 io_uring/io_uring.c:259
 process_one_work+0x9cf/0x1b70 kernel/workqueue.c:3238
 process_scheduled_works kernel/workqueue.c:3321 [inline]
 worker_thread+0x6c8/0xf10 kernel/workqueue.c:3402
 kthread+0x3c5/0x780 kernel/kthread.c:464
 ret_from_fork+0x5d4/0x6f0 arch/x86/kernel/process.c:148
 ret_from_fork_asm+0x1a/0x30 arch/x86/entry/entry_64.S:245
 </TASK>

Allocated by task 6579:
 kasan_save_stack+0x33/0x60 mm/kasan/common.c:47
 kasan_save_track+0x14/0x30 mm/kasan/common.c:68
 poison_kmalloc_redzone mm/kasan/common.c:377 [inline]
 __kasan_kmalloc+0xaa/0xb0 mm/kasan/common.c:394
 kmalloc_noprof include/linux/slab.h:905 [inline]
 kzalloc_noprof include/linux/slab.h:1039 [inline]
 __comedi_device_postconfig_async drivers/comedi/drivers.c:664 [inline]
 __comedi_device_postconfig drivers/comedi/drivers.c:721 [inline]
 comedi_device_postconfig+0x2cb/0xc80 drivers/comedi/drivers.c:756
 comedi_device_attach+0x3cf/0x900 drivers/comedi/drivers.c:998
 do_devconfig_ioctl+0x1a7/0x580 drivers/comedi/comedi_fops.c:855
 comedi_unlocked_ioctl+0x15bb/0x2e90 drivers/comedi/comedi_fops.c:2136
 vfs_ioctl fs/ioctl.c:51 [inline]
 __do_sys_ioctl fs/ioctl.c:907 [inline]
 __se_sys_ioctl fs/ioctl.c:893 [inline]
 __x64_sys_ioctl+0x18e/0x210 fs/ioctl.c:893
 do_syscall_x64 arch/x86/entry/syscall_64.c:63 [inline]
 do_syscall_64+0xcd/0x4c0 arch/x86/entry/syscall_64.c:94
 entry_SYSCALL_64_after_hwframe+0x77/0x7f

Freed by task 6581:
 kasan_save_stack+0x33/0x60 mm/kasan/common.c:47
 kasan_save_track+0x14/0x30 mm/kasan/common.c:68
 kasan_save_free_info+0x3b/0x60 mm/kasan/generic.c:576
 poison_slab_object mm/kasan/common.c:247 [inline]
 __kasan_slab_free+0x51/0x70 mm/kasan/common.c:264
 kasan_slab_free include/linux/kasan.h:233 [inline]
 slab_free_hook mm/slub.c:2381 [inline]
 slab_free mm/slub.c:4643 [inline]
 kfree+0x2b4/0x4d0 mm/slub.c:4842
 comedi_device_detach_cleanup drivers/comedi/drivers.c:171 [inline]
 comedi_device_detach+0x2a4/0x9e0 drivers/comedi/drivers.c:208
 do_devconfig_ioctl+0x46c/0x580 drivers/comedi/comedi_fops.c:833
 comedi_unlocked_ioctl+0x15bb/0x2e90 drivers/comedi/comedi_fops.c:2136
 vfs_ioctl fs/ioctl.c:51 [inline]
 __do_sys_ioctl fs/ioctl.c:907 [inline]
 __se_sys_ioctl fs/ioctl.c:893 [inline]
 __x64_sys_ioctl+0x18e/0x210 fs/ioctl.c:893
 do_syscall_x64 arch/x86/entry/syscall_64.c:63 [inline]
 do_syscall_64+0xcd/0x4c0 arch/x86/entry/syscall_64.c:94
 entry_SYSCALL_64_after_hwframe+0x77/0x7f

The buggy address belongs to the object at ffff888025296a00
 which belongs to the cache kmalloc-256 of size 256
The buggy address is located 176 bytes inside of
 freed 256-byte region [ffff888025296a00, ffff888025296b00)

The buggy address belongs to the physical page:
page: refcount:0 mapcount:0 mapping:0000000000000000 index:0x0 pfn:0x25296
head: order:1 mapcount:0 entire_mapcount:0 nr_pages_mapped:0 pincount:0
flags: 0xfff00000000040(head|node=0|zone=1|lastcpupid=0x7ff)
page_type: f5(slab)
raw: 00fff00000000040 ffff88801b842b40 dead000000000122 0000000000000000
raw: 0000000000000000 0000000000100010 00000000f5000000 0000000000000000
head: 00fff00000000040 ffff88801b842b40 dead000000000122 0000000000000000
head: 0000000000000000 0000000000100010 00000000f5000000 0000000000000000
head: 00fff00000000001 ffffea000094a581 00000000ffffffff 00000000ffffffff
head: ffffffffffffffff 0000000000000000 00000000ffffffff 0000000000000002
page dumped because: kasan: bad access detected
page_owner tracks the page as allocated
page last allocated via order 1, migratetype Unmovable, gfp_mask 0x252800(GFP_NOWAIT|__GFP_NORETRY|__GFP_COMP|__GFP_THISNODE), pid 6279, tgid 6279 (udevd), ts 91681288326, free_ts 91422215520
 set_page_owner include/linux/page_owner.h:32 [inline]
 post_alloc_hook+0x1c0/0x230 mm/page_alloc.c:1704
 prep_new_page mm/page_alloc.c:1712 [inline]
 get_page_from_freelist+0x1321/0x3890 mm/page_alloc.c:3669
 __alloc_frozen_pages_noprof+0x261/0x23f0 mm/page_alloc.c:4959
 alloc_slab_page mm/slub.c:2453 [inline]
 allocate_slab mm/slub.c:2619 [inline]
 new_slab+0x94/0x330 mm/slub.c:2673
 ___slab_alloc+0xd9c/0x1940 mm/slub.c:3859
 __slab_alloc.constprop.0+0x56/0xb0 mm/slub.c:3949
 __slab_alloc_node mm/slub.c:4024 [inline]
 slab_alloc_node mm/slub.c:4185 [inline]
 __do_kmalloc_node mm/slub.c:4327 [inline]
 __kmalloc_node_noprof+0x2ed/0x500 mm/slub.c:4334
 kmalloc_array_node_noprof include/linux/slab.h:1020 [inline]
 alloc_slab_obj_exts+0x41/0xa0 mm/slub.c:1992
 account_slab mm/slub.c:2578 [inline]
 allocate_slab mm/slub.c:2638 [inline]
 new_slab+0x283/0x330 mm/slub.c:2673
 ___slab_alloc+0xd9c/0x1940 mm/slub.c:3859
 __slab_alloc.constprop.0+0x56/0xb0 mm/slub.c:3949
 __slab_alloc_node mm/slub.c:4024 [inline]
 slab_alloc_node mm/slub.c:4185 [inline]
 __do_kmalloc_node mm/slub.c:4327 [inline]
 __kvmalloc_node_noprof+0x3b1/0x620 mm/slub.c:5015
 simple_xattr_alloc+0x41/0xa0 fs/xattr.c:1238
 simple_xattr_set+0x3d/0x3e0 fs/xattr.c:1358
 shmem_xattr_handler_set+0x31b/0x3b0 mm/shmem.c:4331
 __vfs_setxattr+0x172/0x1e0 fs/xattr.c:200
page last free pid 33 tgid 33 stack trace:
 reset_page_owner include/linux/page_owner.h:25 [inline]
 free_pages_prepare mm/page_alloc.c:1248 [inline]
 __free_frozen_pages+0x7fe/0x1180 mm/page_alloc.c:2706
 rcu_do_batch kernel/rcu/tree.c:2576 [inline]
 rcu_core+0x799/0x14e0 kernel/rcu/tree.c:2832
 handle_softirqs+0x219/0x8e0 kernel/softirq.c:579
 run_ksoftirqd kernel/softirq.c:968 [inline]
 run_ksoftirqd+0x3a/0x60 kernel/softirq.c:960
 smpboot_thread_fn+0x3f7/0xae0 kernel/smpboot.c:164
 kthread+0x3c5/0x780 kernel/kthread.c:464
 ret_from_fork+0x5d4/0x6f0 arch/x86/kernel/process.c:148
 ret_from_fork_asm+0x1a/0x30 arch/x86/entry/entry_64.S:245

Memory state around the buggy address:
 ffff888025296980: fc fc fc fc fc fc fc fc fc fc fc fc fc fc fc fc
 ffff888025296a00: fa fb fb fb fb fb fb fb fb fb fb fb fb fb fb fb
>ffff888025296a80: fb fb fb fb fb fb fb fb fb fb fb fb fb fb fb fb
                                     ^
 ffff888025296b00: fc fc fc fc fc fc fc fc fc fc fc fc fc fc fc fc
 ffff888025296b80: fc fc fc fc fc fc fc fc fc fc fc fc fc fc fc fc
==================================================================


Tested on:

commit:         f4a40a42 Merge tag 'efi-fixes-for-v6.16-2' of git://gi..
git tree:       upstream
console output: https://syzkaller.appspot.com/x/log.txt?x=110104f0580000
kernel config:  https://syzkaller.appspot.com/x/.config?x=fa738a4418f051ee
dashboard link: https://syzkaller.appspot.com/bug?extid=01523a0ae5600aef5895
compiler:       gcc (Debian 12.2.0-14) 12.2.0, GNU ld (GNU Binutils for Debian) 2.40
patch:          https://syzkaller.appspot.com/x/patch.diff?x=1799138c580000


