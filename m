Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id B14A92C708A
	for <lists+io-uring@lfdr.de>; Sat, 28 Nov 2020 19:18:47 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1733209AbgK1SAX (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Sat, 28 Nov 2020 13:00:23 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:33824 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1728688AbgK1R6S (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Sat, 28 Nov 2020 12:58:18 -0500
Received: from mail-il1-x147.google.com (mail-il1-x147.google.com [IPv6:2607:f8b0:4864:20::147])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 4F81AC0A3BE3
        for <io-uring@vger.kernel.org>; Sat, 28 Nov 2020 09:49:58 -0800 (PST)
Received: by mail-il1-x147.google.com with SMTP id u17so6356228ilb.4
        for <io-uring@vger.kernel.org>; Sat, 28 Nov 2020 09:49:58 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:date:in-reply-to:message-id:subject
         :from:to;
        bh=IdtRM5LrnYpqJx63YO+4L7WfBjCJ1sZ5owKnOBZSeYA=;
        b=ez89ay8PxwyEn9DyRSQ2jcWTw0R+8NLGwZsiTIlXh4vqFYycK9ot0o0+gTuwV02T67
         u4YUINlUz23d+fcnCIBFuNa5Mi6HMfv9KaO2lJJopy2k8+yqS7AbM4i63UUML3i1eGm9
         LLRHU2kolOfDrANwYHHSoP8ob03c1bLyxbIMOg3oAmOvnvxdRzyYGqmPPt6mbx1cDM1D
         qnLB26olIjuHZhobE8kHdBnZmD2SPKF/7G0EnSxJQPVOrVjxYA00QSDH3PzlU+QjmCS0
         PeUSu9gqD38OnejWVcUhaDNqKC/QGPJw+clMz/1nkjaBKffUjd7eN4gpUFs1iyWRaRAu
         yY4Q==
X-Gm-Message-State: AOAM532fWIG3Oa3RC9pOOuW8PVQ5VSP9zjLOqBA+Onk2MhpXY5yIBnyi
        bASuUeePp+kKZV6IRDg0dtMyBoxGwHwigRnFsRSXqmRHnxnI
X-Google-Smtp-Source: ABdhPJz0twx/ERLu8vV0pfhcwHMmna3D6hskeh50+HELIC20hC0+lwy1vzueUzf+ib9P2UraQP8BsL+qPNUJSaBdZF9HgjnobplI
MIME-Version: 1.0
X-Received: by 2002:a5d:8793:: with SMTP id f19mr2289851ion.106.1606583961435;
 Sat, 28 Nov 2020 09:19:21 -0800 (PST)
Date:   Sat, 28 Nov 2020 09:19:21 -0800
In-Reply-To: <000000000000ca835605b0e8a723@google.com>
X-Google-Appengine-App-Id: s~syzkaller
X-Google-Appengine-App-Id-Alias: syzkaller
Message-ID: <00000000000052c1e805b52dfa16@google.com>
Subject: Re: KASAN: use-after-free Read in idr_for_each (2)
From:   syzbot <syzbot+12056a09a0311d758e60@syzkaller.appspotmail.com>
To:     axboe@kernel.dk, io-uring@vger.kernel.org,
        linux-fsdevel@vger.kernel.org, linux-kernel@vger.kernel.org,
        syzkaller-bugs@googlegroups.com, viro@zeniv.linux.org.uk
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org

syzbot has found a reproducer for the following issue on:

HEAD commit:    c84e1efa Merge tag 'asm-generic-fixes-5.10-2' of git://git..
git tree:       upstream
console output: https://syzkaller.appspot.com/x/log.txt?x=1251d759500000
kernel config:  https://syzkaller.appspot.com/x/.config?x=cb8d1a3819ba4356
dashboard link: https://syzkaller.appspot.com/bug?extid=12056a09a0311d758e60
compiler:       gcc (GCC) 10.1.0-syz 20200507
syz repro:      https://syzkaller.appspot.com/x/repro.syz?x=1126cce9500000
C reproducer:   https://syzkaller.appspot.com/x/repro.c?x=1173d2e9500000

IMPORTANT: if you fix the issue, please add the following tag to the commit:
Reported-by: syzbot+12056a09a0311d758e60@syzkaller.appspotmail.com

==================================================================
BUG: KASAN: use-after-free in radix_tree_next_slot include/linux/radix-tree.h:422 [inline]
BUG: KASAN: use-after-free in idr_for_each+0x206/0x220 lib/idr.c:202
Read of size 8 at addr ffff888032eb2c40 by task kworker/u4:4/186

CPU: 1 PID: 186 Comm: kworker/u4:4 Not tainted 5.10.0-rc5-syzkaller #0
Hardware name: Google Google Compute Engine/Google Compute Engine, BIOS Google 01/01/2011
Workqueue: events_unbound io_ring_exit_work
Call Trace:
 __dump_stack lib/dump_stack.c:77 [inline]
 dump_stack+0x107/0x163 lib/dump_stack.c:118
 print_address_description.constprop.0.cold+0xae/0x4c8 mm/kasan/report.c:385
 __kasan_report mm/kasan/report.c:545 [inline]
 kasan_report.cold+0x1f/0x37 mm/kasan/report.c:562
 radix_tree_next_slot include/linux/radix-tree.h:422 [inline]
 idr_for_each+0x206/0x220 lib/idr.c:202
 io_destroy_buffers fs/io_uring.c:8275 [inline]
 io_ring_ctx_free fs/io_uring.c:8298 [inline]
 io_ring_exit_work+0x3f7/0x7a0 fs/io_uring.c:8375
 process_one_work+0x933/0x15a0 kernel/workqueue.c:2272
 worker_thread+0x64c/0x1120 kernel/workqueue.c:2418
 kthread+0x3b1/0x4a0 kernel/kthread.c:292
 ret_from_fork+0x1f/0x30 arch/x86/entry/entry_64.S:296

Allocated by task 10961:
 kasan_save_stack+0x1b/0x40 mm/kasan/common.c:48
 kasan_set_track mm/kasan/common.c:56 [inline]
 __kasan_kmalloc.constprop.0+0xc2/0xd0 mm/kasan/common.c:461
 slab_post_alloc_hook mm/slab.h:526 [inline]
 slab_alloc_node mm/slub.c:2891 [inline]
 slab_alloc mm/slub.c:2899 [inline]
 kmem_cache_alloc+0x122/0x460 mm/slub.c:2904
 radix_tree_node_alloc.constprop.0+0x7c/0x350 lib/radix-tree.c:274
 idr_get_free+0x4c5/0x940 lib/radix-tree.c:1504
 idr_alloc_u32+0x170/0x2d0 lib/idr.c:46
 idr_alloc+0xc2/0x130 lib/idr.c:87
 io_provide_buffers fs/io_uring.c:4032 [inline]
 io_issue_sqe+0x2fc4/0x3d10 fs/io_uring.c:6012
 __io_queue_sqe+0x132/0xda0 fs/io_uring.c:6232
 io_queue_sqe+0x623/0x11f0 fs/io_uring.c:6298
 io_submit_sqe fs/io_uring.c:6367 [inline]
 io_submit_sqes+0x15e1/0x28a0 fs/io_uring.c:6596
 __do_sys_io_uring_enter+0xc90/0x1ab0 fs/io_uring.c:8983
 do_syscall_64+0x2d/0x70 arch/x86/entry/common.c:46
 entry_SYSCALL_64_after_hwframe+0x44/0xa9

Freed by task 8546:
 kasan_save_stack+0x1b/0x40 mm/kasan/common.c:48
 kasan_set_track+0x1c/0x30 mm/kasan/common.c:56
 kasan_set_free_info+0x1b/0x30 mm/kasan/generic.c:355
 __kasan_slab_free+0x102/0x140 mm/kasan/common.c:422
 slab_free_hook mm/slub.c:1544 [inline]
 slab_free_freelist_hook+0x5d/0x150 mm/slub.c:1577
 slab_free mm/slub.c:3142 [inline]
 kmem_cache_free+0x82/0x350 mm/slub.c:3158
 rcu_do_batch kernel/rcu/tree.c:2476 [inline]
 rcu_core+0x5df/0xe80 kernel/rcu/tree.c:2711
 __do_softirq+0x2a0/0x9f6 kernel/softirq.c:298

Last call_rcu():
 kasan_save_stack+0x1b/0x40 mm/kasan/common.c:48
 kasan_record_aux_stack+0xc0/0xf0 mm/kasan/generic.c:346
 __call_rcu kernel/rcu/tree.c:2953 [inline]
 call_rcu+0xbb/0x700 kernel/rcu/tree.c:3027
 radix_tree_node_free lib/radix-tree.c:308 [inline]
 delete_node+0x591/0x8c0 lib/radix-tree.c:571
 __radix_tree_delete+0x190/0x370 lib/radix-tree.c:1377
 radix_tree_delete_item+0xe7/0x230 lib/radix-tree.c:1428
 __io_remove_buffers fs/io_uring.c:3930 [inline]
 __io_remove_buffers fs/io_uring.c:3909 [inline]
 __io_destroy_buffers+0x161/0x200 fs/io_uring.c:8269
 idr_for_each+0x113/0x220 lib/idr.c:208
 io_destroy_buffers fs/io_uring.c:8275 [inline]
 io_ring_ctx_free fs/io_uring.c:8298 [inline]
 io_ring_exit_work+0x3f7/0x7a0 fs/io_uring.c:8375
 process_one_work+0x933/0x15a0 kernel/workqueue.c:2272
 worker_thread+0x64c/0x1120 kernel/workqueue.c:2418
 kthread+0x3b1/0x4a0 kernel/kthread.c:292
 ret_from_fork+0x1f/0x30 arch/x86/entry/entry_64.S:296

The buggy address belongs to the object at ffff888032eb2c00
 which belongs to the cache radix_tree_node of size 576
The buggy address is located 64 bytes inside of
 576-byte region [ffff888032eb2c00, ffff888032eb2e40)
The buggy address belongs to the page:
page:00000000102f3139 refcount:1 mapcount:0 mapping:0000000000000000 index:0x0 pfn:0x32eb0
head:00000000102f3139 order:2 compound_mapcount:0 compound_pincount:0
flags: 0xfff00000010200(slab|head)
raw: 00fff00000010200 dead000000000100 dead000000000122 ffff88801004db40
raw: 0000000000000000 0000000000170017 00000001ffffffff 0000000000000000
page dumped because: kasan: bad access detected

Memory state around the buggy address:
 ffff888032eb2b00: fb fb fb fb fb fb fb fb fb fb fb fb fb fb fb fb
 ffff888032eb2b80: fc fc fc fc fc fc fc fc fc fc fc fc fc fc fc fc
>ffff888032eb2c00: fa fb fb fb fb fb fb fb fb fb fb fb fb fb fb fb
                                           ^
 ffff888032eb2c80: fb fb fb fb fb fb fb fb fb fb fb fb fb fb fb fb
 ffff888032eb2d00: fb fb fb fb fb fb fb fb fb fb fb fb fb fb fb fb
==================================================================

