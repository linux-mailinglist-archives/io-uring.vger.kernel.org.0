Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 246ED2DE790
	for <lists+io-uring@lfdr.de>; Fri, 18 Dec 2020 17:44:45 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729057AbgLRQoo (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Fri, 18 Dec 2020 11:44:44 -0500
Received: from mail-il1-f199.google.com ([209.85.166.199]:36387 "EHLO
        mail-il1-f199.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1729090AbgLRQoo (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Fri, 18 Dec 2020 11:44:44 -0500
Received: by mail-il1-f199.google.com with SMTP id z15so2579007ilb.3
        for <io-uring@vger.kernel.org>; Fri, 18 Dec 2020 08:44:28 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:date:in-reply-to:message-id:subject
         :from:to;
        bh=3VUHEO+si9B6ymY78I7rSRCFSjhEwSbJ7aJimbG4XBA=;
        b=TVlV7AwKbjQKx0+t5YzlEIp2Z+gWBU6TKxPGpdBlEPeMPsYG9g3FNbIld9C1UGd+1a
         IbKCTt+FEvTZNcmO0z+qb/xzxfYZY78gPxbqWJh+NTkyEDy3Tx0zGrG39P+/MH84oIA4
         UdLIwrxharD7cu9bUDGTJA5yV1eE5dx4fjm8NRsO7ihZV41bRrF898lw5N7j7ivEnZKD
         /LAe1jK1B6yi2og64PolRH0ZG5DN+0xE0xoExcNZpzgoUWjesMXTzJu63H/nK4nCbaVM
         rHKdC4IaLGK6XJsaGVKoTeZQ23yBnfFH6AyP03APVwCoTa2btLQ4dBkfcxU5Y/LQrGqR
         SX2A==
X-Gm-Message-State: AOAM5332CCNXspUia2lOIa6huNO17ae+R3TpzTFVvcbfPxfgzniS3oxJ
        dG0ug2893bAlF9fpQXQgekzZl4tiJFmogPluyJLdrXj/BvUd
X-Google-Smtp-Source: ABdhPJxwkQT7qvnYFzpxeY/oQYydehjpHWbtZsmMyWZY5LjbZzOT49BWANX3PhKMcxuvvpeFyKSmg31hXbssHgbGVAoDZXTMtFGw
MIME-Version: 1.0
X-Received: by 2002:a92:58dc:: with SMTP id z89mr3156048ilf.11.1608309843158;
 Fri, 18 Dec 2020 08:44:03 -0800 (PST)
Date:   Fri, 18 Dec 2020 08:44:03 -0800
In-Reply-To: <af4caaab-93c0-622f-9ab0-e540eb3bc049@gmail.com>
X-Google-Appengine-App-Id: s~syzkaller
X-Google-Appengine-App-Id-Alias: syzkaller
Message-ID: <000000000000e3ec8005b6bfd042@google.com>
Subject: Re: KASAN: use-after-free Read in idr_for_each (2)
From:   syzbot <syzbot+12056a09a0311d758e60@syzkaller.appspotmail.com>
To:     asml.silence@gmail.com, axboe@kernel.dk, io-uring@vger.kernel.org,
        linux-fsdevel@vger.kernel.org, linux-kernel@vger.kernel.org,
        syzkaller-bugs@googlegroups.com, viro@zeniv.linux.org.uk
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org

Hello,

syzbot has tested the proposed patch but the reproducer is still triggering an issue:
KASAN: use-after-free Read in idr_for_each

==================================================================
BUG: KASAN: use-after-free in radix_tree_next_slot include/linux/radix-tree.h:422 [inline]
BUG: KASAN: use-after-free in idr_for_each+0x206/0x220 lib/idr.c:202
Read of size 8 at addr ffff888042e76040 by task kworker/u4:5/3340

CPU: 0 PID: 3340 Comm: kworker/u4:5 Not tainted 5.10.0-syzkaller #0
Hardware name: Google Google Compute Engine/Google Compute Engine, BIOS Google 01/01/2011
Workqueue: events_unbound io_ring_exit_work
Call Trace:
 __dump_stack lib/dump_stack.c:79 [inline]
 dump_stack+0x107/0x163 lib/dump_stack.c:120
 print_address_description.constprop.0.cold+0xae/0x4c8 mm/kasan/report.c:385
 __kasan_report mm/kasan/report.c:545 [inline]
 kasan_report.cold+0x1f/0x37 mm/kasan/report.c:562
 radix_tree_next_slot include/linux/radix-tree.h:422 [inline]
 idr_for_each+0x206/0x220 lib/idr.c:202
 io_destroy_buffers fs/io_uring.c:8541 [inline]
 io_ring_ctx_free fs/io_uring.c:8564 [inline]
 io_ring_exit_work+0x394/0x730 fs/io_uring.c:8639
 process_one_work+0x98d/0x1630 kernel/workqueue.c:2275
 worker_thread+0x64c/0x1120 kernel/workqueue.c:2421
 kthread+0x3b1/0x4a0 kernel/kthread.c:292
 ret_from_fork+0x1f/0x30 arch/x86/entry/entry_64.S:296

Allocated by task 28625:
 kasan_save_stack+0x1b/0x40 mm/kasan/common.c:48
 kasan_set_track mm/kasan/common.c:56 [inline]
 __kasan_kmalloc.constprop.0+0xc2/0xd0 mm/kasan/common.c:461
 slab_post_alloc_hook mm/slab.h:512 [inline]
 slab_alloc_node mm/slub.c:2889 [inline]
 slab_alloc mm/slub.c:2897 [inline]
 kmem_cache_alloc+0x145/0x350 mm/slub.c:2902
 radix_tree_node_alloc.constprop.0+0x7c/0x350 lib/radix-tree.c:274
 idr_get_free+0x554/0xa60 lib/radix-tree.c:1504
 idr_alloc_u32+0x170/0x2d0 lib/idr.c:46
 idr_alloc+0xc2/0x130 lib/idr.c:87
 io_provide_buffers fs/io_uring.c:4230 [inline]
 io_issue_sqe+0x3681/0x44e0 fs/io_uring.c:6264
 __io_queue_sqe+0x228/0x1120 fs/io_uring.c:6477
 io_queue_sqe+0x631/0x10f0 fs/io_uring.c:6543
 io_submit_sqe fs/io_uring.c:6616 [inline]
 io_submit_sqes+0x135a/0x2530 fs/io_uring.c:6864
 __do_sys_io_uring_enter+0x591/0x1c00 fs/io_uring.c:9174
 do_syscall_64+0x2d/0x70 arch/x86/entry/common.c:46
 entry_SYSCALL_64_after_hwframe+0x44/0xa9

Freed by task 8890:
 kasan_save_stack+0x1b/0x40 mm/kasan/common.c:48
 kasan_set_track+0x1c/0x30 mm/kasan/common.c:56
 kasan_set_free_info+0x1b/0x30 mm/kasan/generic.c:352
 __kasan_slab_free+0x102/0x140 mm/kasan/common.c:422
 slab_free_hook mm/slub.c:1544 [inline]
 slab_free_freelist_hook+0x5d/0x150 mm/slub.c:1577
 slab_free mm/slub.c:3140 [inline]
 kmem_cache_free+0x82/0x360 mm/slub.c:3156
 rcu_do_batch kernel/rcu/tree.c:2489 [inline]
 rcu_core+0x75d/0xf80 kernel/rcu/tree.c:2723
 __do_softirq+0x2bc/0xa77 kernel/softirq.c:343

Last potentially related work creation:
 kasan_save_stack+0x1b/0x40 mm/kasan/common.c:48
 kasan_record_aux_stack+0xc0/0xf0 mm/kasan/generic.c:343
 __call_rcu kernel/rcu/tree.c:2965 [inline]
 call_rcu+0xbb/0x710 kernel/rcu/tree.c:3038
 radix_tree_node_free lib/radix-tree.c:308 [inline]
 delete_node+0x591/0x8c0 lib/radix-tree.c:571
 __radix_tree_delete+0x190/0x370 lib/radix-tree.c:1377
 radix_tree_delete_item+0xe7/0x230 lib/radix-tree.c:1428
 __io_remove_buffers fs/io_uring.c:4122 [inline]
 __io_remove_buffers fs/io_uring.c:4101 [inline]
 __io_destroy_buffers+0x161/0x200 fs/io_uring.c:8535
 idr_for_each+0x113/0x220 lib/idr.c:208
 io_destroy_buffers fs/io_uring.c:8541 [inline]
 io_ring_ctx_free fs/io_uring.c:8564 [inline]
 io_ring_exit_work+0x394/0x730 fs/io_uring.c:8639
 process_one_work+0x98d/0x1630 kernel/workqueue.c:2275
 worker_thread+0x64c/0x1120 kernel/workqueue.c:2421
 kthread+0x3b1/0x4a0 kernel/kthread.c:292
 ret_from_fork+0x1f/0x30 arch/x86/entry/entry_64.S:296

Second to last potentially related work creation:
 kasan_save_stack+0x1b/0x40 mm/kasan/common.c:48
 kasan_record_aux_stack+0xc0/0xf0 mm/kasan/generic.c:343
 __call_rcu kernel/rcu/tree.c:2965 [inline]
 call_rcu+0xbb/0x710 kernel/rcu/tree.c:3038
 xa_node_free lib/xarray.c:258 [inline]
 xas_delete_node lib/xarray.c:494 [inline]
 update_node lib/xarray.c:756 [inline]
 xas_store+0xbeb/0x1c10 lib/xarray.c:841
 __xa_erase lib/xarray.c:1489 [inline]
 xa_erase+0xb0/0x170 lib/xarray.c:1510
 io_uring_del_task_file fs/io_uring.c:8889 [inline]
 __io_uring_files_cancel+0xdbf/0x1550 fs/io_uring.c:8925
 io_uring_files_cancel include/linux/io_uring.h:51 [inline]
 exit_files+0xe4/0x170 fs/file.c:431
 do_exit+0xb4f/0x2a00 kernel/exit.c:818
 do_group_exit+0x125/0x310 kernel/exit.c:920
 get_signal+0x3e9/0x2160 kernel/signal.c:2770
 arch_do_signal_or_restart+0x2a8/0x1eb0 arch/x86/kernel/signal.c:811
 handle_signal_work kernel/entry/common.c:147 [inline]
 exit_to_user_mode_loop kernel/entry/common.c:171 [inline]
 exit_to_user_mode_prepare+0x124/0x200 kernel/entry/common.c:201
 __syscall_exit_to_user_mode_work kernel/entry/common.c:291 [inline]
 syscall_exit_to_user_mode+0x19/0x50 kernel/entry/common.c:302
 entry_SYSCALL_64_after_hwframe+0x44/0xa9

The buggy address belongs to the object at ffff888042e76000
 which belongs to the cache radix_tree_node of size 576
The buggy address is located 64 bytes inside of
 576-byte region [ffff888042e76000, ffff888042e76240)
The buggy address belongs to the page:
page:0000000090e8be83 refcount:1 mapcount:0 mapping:0000000000000000 index:0x0 pfn:0x42e76
head:0000000090e8be83 order:1 compound_mapcount:0
flags: 0xfff00000010200(slab|head)
raw: 00fff00000010200 dead000000000100 dead000000000122 ffff88801084db40
raw: ffff888042e76580 00000000800b000a 00000001ffffffff 0000000000000000
page dumped because: kasan: bad access detected

Memory state around the buggy address:
 ffff888042e75f00: fc fc fc fc fc fc fc fc fc fc fc fc fc fc fc fc
 ffff888042e75f80: fc fc fc fc fc fc fc fc fc fc fc fc fc fc fc fc
>ffff888042e76000: fa fb fb fb fb fb fb fb fb fb fb fb fb fb fb fb
                                           ^
 ffff888042e76080: fb fb fb fb fb fb fb fb fb fb fb fb fb fb fb fb
 ffff888042e76100: fb fb fb fb fb fb fb fb fb fb fb fb fb fb fb fb
==================================================================


Tested on:

commit:         dfea9fce io_uring: close a small race gap for files cancel
git tree:       git://git.kernel.dk/linux-block
console output: https://syzkaller.appspot.com/x/log.txt?x=1263a46b500000
kernel config:  https://syzkaller.appspot.com/x/.config?x=4db50a97037d9f3e
dashboard link: https://syzkaller.appspot.com/bug?extid=12056a09a0311d758e60
compiler:       gcc (GCC) 10.1.0-syz 20200507

