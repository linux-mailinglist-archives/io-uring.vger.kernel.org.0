Return-Path: <io-uring+bounces-8733-lists+io-uring=lfdr.de@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from sy.mirrors.kernel.org (sy.mirrors.kernel.org [147.75.48.161])
	by mail.lfdr.de (Postfix) with ESMTPS id 5CDCBB0B115
	for <lists+io-uring@lfdr.de>; Sat, 19 Jul 2025 19:29:48 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sy.mirrors.kernel.org (Postfix) with ESMTPS id C81337A4791
	for <lists+io-uring@lfdr.de>; Sat, 19 Jul 2025 17:28:19 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 447A222126B;
	Sat, 19 Jul 2025 17:29:38 +0000 (UTC)
X-Original-To: io-uring@vger.kernel.org
Received: from mail-io1-f80.google.com (mail-io1-f80.google.com [209.85.166.80])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6D0431DF75C
	for <io-uring@vger.kernel.org>; Sat, 19 Jul 2025 17:29:35 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.166.80
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1752946178; cv=none; b=s7hR0WPD1c9ZcpqJr+koWGaAoJbn8A+7fuGtiK0w+DCRDe/1nhBPaE2lFo0fDXx+QIyj9hUWSmsfLlRO2bzWDEIB1jonrkGh7tBFNyRTe34rTIYdO6KkzERXSGeZPTQo/AQsOjzEPFbeoRSnV1jee9WpK3OfoM1vONVYWLAq41o=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1752946178; c=relaxed/simple;
	bh=KYhNbHE14b98jSc3mZsHzzy5ABMNLGBu8GLUxKFvztw=;
	h=MIME-Version:Date:Message-ID:Subject:From:To:Content-Type; b=QF0olAcYK9Q878QS4OaLVS+Bdm+fYShe3GCpKT9eBN633Aw4JFADqX/8hzHMm/9HMJZqvYRK7tpCNsqekcliX5OdNrYeWcmsIIzmw1djFb7B7oqG/xrbfhJcw+G4MPQW8y+ai5at/a9KPwp/9eMEB4E/dYpanhYik2rZ8KjJmZI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=fail (p=none dis=none) header.from=syzkaller.appspotmail.com; spf=pass smtp.mailfrom=M3KW2WVRGUFZ5GODRSRYTGD7.apphosting.bounces.google.com; arc=none smtp.client-ip=209.85.166.80
Authentication-Results: smtp.subspace.kernel.org; dmarc=fail (p=none dis=none) header.from=syzkaller.appspotmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=M3KW2WVRGUFZ5GODRSRYTGD7.apphosting.bounces.google.com
Received: by mail-io1-f80.google.com with SMTP id ca18e2360f4ac-87c29bef96cso68505439f.0
        for <io-uring@vger.kernel.org>; Sat, 19 Jul 2025 10:29:35 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1752946174; x=1753550974;
        h=to:from:subject:message-id:date:mime-version:x-gm-message-state
         :from:to:cc:subject:date:message-id:reply-to;
        bh=W1DMqMjrAKUE2DOW2FEXPqltDFKB7gs9nU8AbGyqNjM=;
        b=ZIiml8XRIaqrp5I5XpbvJDTLr7axqyB7kp6ZDqzj10gP3sIeHNwzNiSSA7fJ2RDVmt
         dwkIVxozD43WavHKm/83su6QgpMliddajZVMcSIt75b4EipB/lTmAqwt7tMe/+NbeOTB
         fp2pZepdIlPv6CfxbWffV68DeDE4e1qN2rE5qOmK9bGLrUPkZnMHp/Iw1/j3CaPXTSeR
         4L9wJAeca4weozemejiM/uPOjZlFo2yRbAuMgusLWp00bIaL3iIqyaSOkCY22aKB/59X
         hh8aptPC8kh3MHmUey6hThqOQ13yxVDbex6IzGvloIfMO3NNdGKRgrntJW9LomnWWzxY
         pnfA==
X-Forwarded-Encrypted: i=1; AJvYcCWuN9CiBWW7W8rRHXiyoBr87DDgw1ydFLYYrtq4dXKysmx+iCrhNy446ZmZsufqV5kMhO/CMuDTgQ==@vger.kernel.org
X-Gm-Message-State: AOJu0YyEvjEhyoEyw98F+6L6ALVpX5OlVJPLJbt7LxHmrteWrIkH6+44
	dABKD9aR95N9WsgCZ++++u9iVOFYpQnV0WRI8PTdrGN3MfFMjF6HL9ZDdMSQD4kFJjstV5p4Up/
	uVxcrKgeJHDB92aKZei9qWqKM/FT75/xOe39I8SQYpKCvYOrrtrGsbmdHalY=
X-Google-Smtp-Source: AGHT+IEX02Et00RaWhwFlXd8NuDQc0m5ZD6ya/4reaYYRpU0gPACYdGpVCjIjvNiIe68WYk9r5Ud6+/Mh4fH2lxt+cHBw6kS0ABN
Precedence: bulk
X-Mailing-List: io-uring@vger.kernel.org
List-Id: <io-uring.vger.kernel.org>
List-Subscribe: <mailto:io-uring+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:io-uring+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-Received: by 2002:a05:6602:2c8f:b0:879:c609:f5a1 with SMTP id
 ca18e2360f4ac-879c609f634mr1851494639f.12.1752946174457; Sat, 19 Jul 2025
 10:29:34 -0700 (PDT)
Date: Sat, 19 Jul 2025 10:29:34 -0700
X-Google-Appengine-App-Id: s~syzkaller
X-Google-Appengine-App-Id-Alias: syzkaller
Message-ID: <687bd5fe.a70a0220.693ce.0091.GAE@google.com>
Subject: [syzbot] [io-uring?] KASAN: slab-use-after-free Read in io_poll_remove_entries
From: syzbot <syzbot+01523a0ae5600aef5895@syzkaller.appspotmail.com>
To: axboe@kernel.dk, io-uring@vger.kernel.org, linux-kernel@vger.kernel.org, 
	syzkaller-bugs@googlegroups.com
Content-Type: text/plain; charset="UTF-8"

Hello,

syzbot found the following issue on:

HEAD commit:    4871b7cb27f4 Merge tag 'v6.16-rc6-smb3-client-fixes' of gi..
git tree:       upstream
console output: https://syzkaller.appspot.com/x/log.txt?x=1288c38c580000
kernel config:  https://syzkaller.appspot.com/x/.config?x=fa738a4418f051ee
dashboard link: https://syzkaller.appspot.com/bug?extid=01523a0ae5600aef5895
compiler:       gcc (Debian 12.2.0-14) 12.2.0, GNU ld (GNU Binutils for Debian) 2.40
syz repro:      https://syzkaller.appspot.com/x/repro.syz?x=1688c38c580000
C reproducer:   https://syzkaller.appspot.com/x/repro.c?x=166ed7d4580000

Downloadable assets:
disk image (non-bootable): https://storage.googleapis.com/syzbot-assets/d900f083ada3/non_bootable_disk-4871b7cb.raw.xz
vmlinux: https://storage.googleapis.com/syzbot-assets/4a9dea51d821/vmlinux-4871b7cb.xz
kernel image: https://storage.googleapis.com/syzbot-assets/f96c723cdfe6/bzImage-4871b7cb.xz

IMPORTANT: if you fix the issue, please add the following tag to the commit:
Reported-by: syzbot+01523a0ae5600aef5895@syzkaller.appspotmail.com

==================================================================
BUG: KASAN: slab-use-after-free in __raw_spin_lock_irq include/linux/spinlock_api_smp.h:119 [inline]
BUG: KASAN: slab-use-after-free in _raw_spin_lock_irq+0x36/0x50 kernel/locking/spinlock.c:170
Read of size 1 at addr ffff88803c6f42b0 by task kworker/2:2/1339

CPU: 2 UID: 0 PID: 1339 Comm: kworker/2:2 Not tainted 6.16.0-rc6-syzkaller-00253-g4871b7cb27f4 #0 PREEMPT(full) 
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
 io_poll_remove_entry io_uring/poll.c:146 [inline]
 io_poll_remove_entries.part.0+0x14e/0x7e0 io_uring/poll.c:179
 io_poll_remove_entries io_uring/poll.c:159 [inline]
 io_poll_task_func+0x4cd/0x1130 io_uring/poll.c:326
 io_fallback_req_func+0x1c7/0x6d0 io_uring/io_uring.c:259
 process_one_work+0x9cf/0x1b70 kernel/workqueue.c:3238
 process_scheduled_works kernel/workqueue.c:3321 [inline]
 worker_thread+0x6c8/0xf10 kernel/workqueue.c:3402
 kthread+0x3c5/0x780 kernel/kthread.c:464
 ret_from_fork+0x5d4/0x6f0 arch/x86/kernel/process.c:148
 ret_from_fork_asm+0x1a/0x30 arch/x86/entry/entry_64.S:245
 </TASK>

Allocated by task 6154:
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

Freed by task 6156:
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

The buggy address belongs to the object at ffff88803c6f4200
 which belongs to the cache kmalloc-256 of size 256
The buggy address is located 176 bytes inside of
 freed 256-byte region [ffff88803c6f4200, ffff88803c6f4300)

The buggy address belongs to the physical page:
page: refcount:0 mapcount:0 mapping:0000000000000000 index:0x0 pfn:0x3c6f4
head: order:1 mapcount:0 entire_mapcount:0 nr_pages_mapped:0 pincount:0
flags: 0xfff00000000040(head|node=0|zone=1|lastcpupid=0x7ff)
page_type: f5(slab)
raw: 00fff00000000040 ffff88801b842b40 ffffea0000f0c180 dead000000000004
raw: 0000000000000000 0000000000100010 00000000f5000000 0000000000000000
head: 00fff00000000040 ffff88801b842b40 ffffea0000f0c180 dead000000000004
head: 0000000000000000 0000000000100010 00000000f5000000 0000000000000000
head: 00fff00000000001 ffffea0000f1bd01 00000000ffffffff 00000000ffffffff
head: ffffffffffffffff 0000000000000000 00000000ffffffff 0000000000000002
page dumped because: kasan: bad access detected
page_owner tracks the page as allocated
page last allocated via order 1, migratetype Unmovable, gfp_mask 0xd20c0(__GFP_IO|__GFP_FS|__GFP_NOWARN|__GFP_NORETRY|__GFP_COMP|__GFP_NOMEMALLOC), pid 6018, tgid 6018 (syz-executor), ts 49909540314, free_ts 49907641430
 set_page_owner include/linux/page_owner.h:32 [inline]
 post_alloc_hook+0x1c0/0x230 mm/page_alloc.c:1704
 prep_new_page mm/page_alloc.c:1712 [inline]
 get_page_from_freelist+0x1321/0x3890 mm/page_alloc.c:3669
 __alloc_frozen_pages_noprof+0x261/0x23f0 mm/page_alloc.c:4959
 alloc_pages_mpol+0x1fb/0x550 mm/mempolicy.c:2419
 alloc_slab_page mm/slub.c:2451 [inline]
 allocate_slab mm/slub.c:2619 [inline]
 new_slab+0x23b/0x330 mm/slub.c:2673
 ___slab_alloc+0xd9c/0x1940 mm/slub.c:3859
 __slab_alloc.constprop.0+0x56/0xb0 mm/slub.c:3949
 __slab_alloc_node mm/slub.c:4024 [inline]
 slab_alloc_node mm/slub.c:4185 [inline]
 __do_kmalloc_node mm/slub.c:4327 [inline]
 __kmalloc_node_track_caller_noprof+0x2ee/0x510 mm/slub.c:4347
 kmemdup_noprof+0x29/0x60 mm/util.c:137
 ipt_register_table+0x224/0x430 net/ipv4/netfilter/ip_tables.c:1770
 iptable_filter_table_init+0x75/0xa0 net/ipv4/netfilter/iptable_filter.c:49
 xt_find_table_lock+0x2e4/0x520 net/netfilter/x_tables.c:1260
 xt_request_find_table_lock+0x28/0xf0 net/netfilter/x_tables.c:1285
 get_info+0x19c/0x7c0 net/ipv4/netfilter/ip_tables.c:963
 do_ipt_get_ctl+0x169/0xaa0 net/ipv4/netfilter/ip_tables.c:1659
 nf_getsockopt+0x7c/0xe0 net/netfilter/nf_sockopt.c:116
page last free pid 6018 tgid 6018 stack trace:
 reset_page_owner include/linux/page_owner.h:25 [inline]
 free_pages_prepare mm/page_alloc.c:1248 [inline]
 __free_frozen_pages+0x7fe/0x1180 mm/page_alloc.c:2706
 qlink_free mm/kasan/quarantine.c:163 [inline]
 qlist_free_all+0x4d/0x120 mm/kasan/quarantine.c:179
 kasan_quarantine_reduce+0x195/0x1e0 mm/kasan/quarantine.c:286
 __kasan_slab_alloc+0x69/0x90 mm/kasan/common.c:329
 kasan_slab_alloc include/linux/kasan.h:250 [inline]
 slab_post_alloc_hook mm/slub.c:4148 [inline]
 slab_alloc_node mm/slub.c:4197 [inline]
 kmem_cache_alloc_noprof+0x1cb/0x3b0 mm/slub.c:4204
 getname_flags.part.0+0x4c/0x550 fs/namei.c:146
 getname_flags+0x93/0xf0 include/linux/audit.h:322
 getname include/linux/fs.h:2907 [inline]
 __do_sys_mkdirat fs/namei.c:4425 [inline]
 __se_sys_mkdirat fs/namei.c:4423 [inline]
 __x64_sys_mkdirat+0x76/0xb0 fs/namei.c:4423
 do_syscall_x64 arch/x86/entry/syscall_64.c:63 [inline]
 do_syscall_64+0xcd/0x4c0 arch/x86/entry/syscall_64.c:94
 entry_SYSCALL_64_after_hwframe+0x77/0x7f

Memory state around the buggy address:
 ffff88803c6f4180: fc fc fc fc fc fc fc fc fc fc fc fc fc fc fc fc
 ffff88803c6f4200: fa fb fb fb fb fb fb fb fb fb fb fb fb fb fb fb
>ffff88803c6f4280: fb fb fb fb fb fb fb fb fb fb fb fb fb fb fb fb
                                     ^
 ffff88803c6f4300: fc fc fc fc fc fc fc fc fc fc fc fc fc fc fc fc
 ffff88803c6f4380: fc fc fc fc fc fc fc fc fc fc fc fc fc fc fc fc
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

