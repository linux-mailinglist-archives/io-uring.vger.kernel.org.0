Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 836A12798A0
	for <lists+io-uring@lfdr.de>; Sat, 26 Sep 2020 12:58:30 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726183AbgIZK6X (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Sat, 26 Sep 2020 06:58:23 -0400
Received: from mail-il1-f207.google.com ([209.85.166.207]:43432 "EHLO
        mail-il1-f207.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726210AbgIZK6S (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Sat, 26 Sep 2020 06:58:18 -0400
Received: by mail-il1-f207.google.com with SMTP id t11so4481247ilj.10
        for <io-uring@vger.kernel.org>; Sat, 26 Sep 2020 03:58:17 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:date:message-id:subject:from:to;
        bh=TtTv3mjkQp5CKRWiMYylgUft3vHyjPQyIuTYGFhYbxk=;
        b=V289S8hWVLNEgJwLOerqiHsyqLd6Y1aHf94jnWikMDhgvrW1CyWghoXJbRL5ftdzFG
         +txmvFUuivJ1sGeMCL3qaSNYQ9zZ2/DZNQgJEGJgTobexYapkxEqz5HdD/ODVBRT/o1H
         bbf5lHvQy9Qqa2omykhkZb2dnterOqf7y5QXcS0d5AWdZDThbMqwtlJifmmgmAHemoYg
         WJ+HNh1p/3wmBde64BPl6z6Fv84QYMBThMw2VuJVXDZBG1MDUVq9XZfvnyICrUT4JBmb
         vcI2AZGbJQqjC+ciT6TOwt1MT8WBb/izjIgY/Yao8+UMSzqFWx1eM6hsy9gbQfsjeFBH
         pHhA==
X-Gm-Message-State: AOAM531Q+oPGHlXEv+8L8KPrk/ZYreX1WGfs0MrOxvmLYkUMAhX7C3lv
        bdnG67Dh7U6IBdKC2DSzgCH6Er0CoqP1WDRwO0gjHwFMs8nC
X-Google-Smtp-Source: ABdhPJyaDtGw4JMShzXBdwFY588MGEE6JZE1cHLw1152lrqsPXUYZA1du2CBVfmk5FS80UL/1ryGJ8J0gVzKTrkBU3kljUDSk84+
MIME-Version: 1.0
X-Received: by 2002:a05:6638:144f:: with SMTP id l15mr2546075jad.5.1601117896999;
 Sat, 26 Sep 2020 03:58:16 -0700 (PDT)
Date:   Sat, 26 Sep 2020 03:58:16 -0700
X-Google-Appengine-App-Id: s~syzkaller
X-Google-Appengine-App-Id-Alias: syzkaller
Message-ID: <0000000000007e88ec05b0354fdd@google.com>
Subject: KASAN: use-after-free Read in io_wqe_worker
From:   syzbot <syzbot+9af99580130003da82b1@syzkaller.appspotmail.com>
To:     axboe@kernel.dk, io-uring@vger.kernel.org,
        linux-fsdevel@vger.kernel.org, linux-kernel@vger.kernel.org,
        syzkaller-bugs@googlegroups.com, viro@zeniv.linux.org.uk
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org

Hello,

syzbot found the following issue on:

HEAD commit:    98477740 Merge branch 'rcu/urgent' of git://git.kernel.org..
git tree:       upstream
console output: https://syzkaller.appspot.com/x/log.txt?x=153e929b900000
kernel config:  https://syzkaller.appspot.com/x/.config?x=af502ec9a451c9fc
dashboard link: https://syzkaller.appspot.com/bug?extid=9af99580130003da82b1
compiler:       clang version 10.0.0 (https://github.com/llvm/llvm-project/ c2443155a0fb245c8f17f2c1c72b6ea391e86e81)
syz repro:      https://syzkaller.appspot.com/x/repro.syz?x=14138009900000
C reproducer:   https://syzkaller.appspot.com/x/repro.c?x=17d0f809900000

IMPORTANT: if you fix the issue, please add the following tag to the commit:
Reported-by: syzbot+9af99580130003da82b1@syzkaller.appspotmail.com

==================================================================
BUG: KASAN: use-after-free in __lock_acquire+0x92/0x2ae0 kernel/locking/lockdep.c:4311
Read of size 8 at addr ffff88821ae5f818 by task io_wqe_worker-0/11054

CPU: 1 PID: 11054 Comm: io_wqe_worker-0 Not tainted 5.9.0-rc6-syzkaller #0
Hardware name: Google Google Compute Engine/Google Compute Engine, BIOS Google 01/01/2011
Call Trace:
 __dump_stack lib/dump_stack.c:77 [inline]
 dump_stack+0x1d6/0x29e lib/dump_stack.c:118
 print_address_description+0x66/0x620 mm/kasan/report.c:383
 __kasan_report mm/kasan/report.c:513 [inline]
 kasan_report+0x132/0x1d0 mm/kasan/report.c:530
 __lock_acquire+0x92/0x2ae0 kernel/locking/lockdep.c:4311
 lock_acquire+0x148/0x720 kernel/locking/lockdep.c:5029
 __raw_spin_lock_irq include/linux/spinlock_api_smp.h:128 [inline]
 _raw_spin_lock_irq+0xa6/0xc0 kernel/locking/spinlock.c:167
 spin_lock_irq include/linux/spinlock.h:379 [inline]
 io_wqe_worker+0x756/0x810 fs/io-wq.c:589
 kthread+0x37e/0x3a0 drivers/block/aoe/aoecmd.c:1234
 ret_from_fork+0x1f/0x30 arch/x86/entry/entry_64.S:294

Allocated by task 11048:
 kasan_save_stack mm/kasan/common.c:48 [inline]
 kasan_set_track mm/kasan/common.c:56 [inline]
 __kasan_kmalloc+0x100/0x130 mm/kasan/common.c:461
 kmem_cache_alloc_node_trace+0x1f7/0x2a0 mm/slab.c:3594
 kmalloc_node include/linux/slab.h:572 [inline]
 kzalloc_node include/linux/slab.h:677 [inline]
 io_wq_create+0x295/0x880 fs/io-wq.c:1064
 io_init_wq_offload fs/io_uring.c:7432 [inline]
 io_sq_offload_start fs/io_uring.c:7504 [inline]
 io_uring_create fs/io_uring.c:8625 [inline]
 io_uring_setup fs/io_uring.c:8694 [inline]
 __do_sys_io_uring_setup fs/io_uring.c:8700 [inline]
 __se_sys_io_uring_setup+0x18ed/0x2a00 fs/io_uring.c:8697
 do_syscall_64+0x31/0x70 arch/x86/entry/common.c:46
 entry_SYSCALL_64_after_hwframe+0x44/0xa9

Freed by task 128:
 kasan_save_stack mm/kasan/common.c:48 [inline]
 kasan_set_track+0x3d/0x70 mm/kasan/common.c:56
 kasan_set_free_info+0x17/0x30 mm/kasan/generic.c:355
 __kasan_slab_free+0xdd/0x110 mm/kasan/common.c:422
 __cache_free mm/slab.c:3418 [inline]
 kfree+0x113/0x200 mm/slab.c:3756
 __io_wq_destroy fs/io-wq.c:1138 [inline]
 io_wq_destroy+0x470/0x510 fs/io-wq.c:1146
 io_finish_async fs/io_uring.c:6836 [inline]
 io_ring_ctx_free fs/io_uring.c:7870 [inline]
 io_ring_exit_work+0x195/0x520 fs/io_uring.c:7954
 process_one_work+0x789/0xfc0 kernel/workqueue.c:2269
 worker_thread+0xaa4/0x1460 kernel/workqueue.c:2415
 kthread+0x37e/0x3a0 drivers/block/aoe/aoecmd.c:1234
 ret_from_fork+0x1f/0x30 arch/x86/entry/entry_64.S:294

The buggy address belongs to the object at ffff88821ae5f800
 which belongs to the cache kmalloc-1k of size 1024
The buggy address is located 24 bytes inside of
 1024-byte region [ffff88821ae5f800, ffff88821ae5fc00)
The buggy address belongs to the page:
page:000000008e41b1c2 refcount:1 mapcount:0 mapping:0000000000000000 index:0x0 pfn:0x21ae5f
flags: 0x57ffe0000000200(slab)
raw: 057ffe0000000200 ffffea00086a10c8 ffffea00085d1848 ffff8880aa440700
raw: 0000000000000000 ffff88821ae5f000 0000000100000002 0000000000000000
page dumped because: kasan: bad access detected

Memory state around the buggy address:
 ffff88821ae5f700: fc fc fc fc fc fc fc fc fc fc fc fc fc fc fc fc
 ffff88821ae5f780: fc fc fc fc fc fc fc fc fc fc fc fc fc fc fc fc
>ffff88821ae5f800: fa fb fb fb fb fb fb fb fb fb fb fb fb fb fb fb
                            ^
 ffff88821ae5f880: fb fb fb fb fb fb fb fb fb fb fb fb fb fb fb fb
 ffff88821ae5f900: fb fb fb fb fb fb fb fb fb fb fb fb fb fb fb fb
==================================================================


---
This report is generated by a bot. It may contain errors.
See https://goo.gl/tpsmEJ for more information about syzbot.
syzbot engineers can be reached at syzkaller@googlegroups.com.

syzbot will keep track of this issue. See:
https://goo.gl/tpsmEJ#status for how to communicate with syzbot.
syzbot can test patches for this issue, for details see:
https://goo.gl/tpsmEJ#testing-patches
