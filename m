Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 11FFA2832A2
	for <lists+io-uring@lfdr.de>; Mon,  5 Oct 2020 10:56:24 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1725995AbgJEI4T (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Mon, 5 Oct 2020 04:56:19 -0400
Received: from mail-il1-f206.google.com ([209.85.166.206]:51783 "EHLO
        mail-il1-f206.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725885AbgJEI4T (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Mon, 5 Oct 2020 04:56:19 -0400
Received: by mail-il1-f206.google.com with SMTP id e3so6703610ilq.18
        for <io-uring@vger.kernel.org>; Mon, 05 Oct 2020 01:56:17 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:date:message-id:subject:from:to;
        bh=Amwp1aqa7bTc2xanzlXXNgO7NgBXnd0zxzTo/kSRKZ4=;
        b=NE+SGEuALU5tNo6oJ0HE0PQjyWwsICuDfDZ5pjpakdK87x+qJ9UWcRX/Nq3N8Wevbl
         7cCewSvZJcyN3ceY9CpVqjSn+WpAG8O7nbYJ3J1T1BnBmEJzLfr5PbkXuZv4AoW2lhlG
         kMFEZZUY+iHA1aIoQBKZY5GNCxryDwpeV0Z7U/lCIRU5Fp6WG0XsvNM2IyOIVPoKQb2G
         pgyvnpaijNJ0VK4Sug3V0HYQjTFHSkaeuCU1lfInKkCvvWzL4XsnDFo3q/UNSAvTEEJj
         3gyZpqwk6+fSAGIg+TRT3gnkeLZkhbNOML2juSExVhstQFlrxopV968qPzIVO468uOGM
         FUlg==
X-Gm-Message-State: AOAM530DTwRrbLtDMGWteM/gIib5ZsPvKxhNKN7lwjazZn7ayEUv8QfV
        TFoS441KqyoEaL5XspIwy6fv6E5Av6lNFXOmidF9+RHysz3y
X-Google-Smtp-Source: ABdhPJz3JXucT/swRsk+KIgFBhBuEK/6ZIeOJpjrlErbuuvYmaYmsTK0T6RYtV+OwHha6Wy2dAHmV1TceajiSoT4jt4LsTh/NmKg
MIME-Version: 1.0
X-Received: by 2002:a05:6e02:46:: with SMTP id i6mr9221812ilr.74.1601888177519;
 Mon, 05 Oct 2020 01:56:17 -0700 (PDT)
Date:   Mon, 05 Oct 2020 01:56:17 -0700
X-Google-Appengine-App-Id: s~syzkaller
X-Google-Appengine-App-Id-Alias: syzkaller
Message-ID: <000000000000ca835605b0e8a723@google.com>
Subject: KASAN: use-after-free Read in idr_for_each (2)
From:   syzbot <syzbot+12056a09a0311d758e60@syzkaller.appspotmail.com>
To:     axboe@kernel.dk, io-uring@vger.kernel.org,
        linux-fsdevel@vger.kernel.org, linux-kernel@vger.kernel.org,
        syzkaller-bugs@googlegroups.com, viro@zeniv.linux.org.uk
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org

Hello,

syzbot found the following issue on:

HEAD commit:    472e5b05 pipe: remove pipe_wait() and fix wakeup race with..
git tree:       upstream
console output: https://syzkaller.appspot.com/x/log.txt?x=15ae0d47900000
kernel config:  https://syzkaller.appspot.com/x/.config?x=89ab6a0c48f30b49
dashboard link: https://syzkaller.appspot.com/bug?extid=12056a09a0311d758e60
compiler:       gcc (GCC) 10.1.0-syz 20200507
userspace arch: i386

Unfortunately, I don't have any reproducer for this issue yet.

IMPORTANT: if you fix the issue, please add the following tag to the commit:
Reported-by: syzbot+12056a09a0311d758e60@syzkaller.appspotmail.com

==================================================================
BUG: KASAN: use-after-free in radix_tree_next_slot include/linux/radix-tree.h:421 [inline]
BUG: KASAN: use-after-free in idr_for_each+0x206/0x220 lib/idr.c:202
Read of size 8 at addr ffff88804eb9cb30 by task kworker/u4:8/13668

CPU: 1 PID: 13668 Comm: kworker/u4:8 Not tainted 5.9.0-rc7-syzkaller #0
Hardware name: Google Google Compute Engine/Google Compute Engine, BIOS Google 01/01/2011
Workqueue: events_unbound io_ring_exit_work
Call Trace:
 __dump_stack lib/dump_stack.c:77 [inline]
 dump_stack+0x198/0x1fd lib/dump_stack.c:118
 print_address_description.constprop.0.cold+0xae/0x497 mm/kasan/report.c:383
 __kasan_report mm/kasan/report.c:513 [inline]
 kasan_report.cold+0x1f/0x37 mm/kasan/report.c:530
 radix_tree_next_slot include/linux/radix-tree.h:421 [inline]
 idr_for_each+0x206/0x220 lib/idr.c:202
 io_destroy_buffers fs/io_uring.c:7889 [inline]
 io_ring_ctx_free fs/io_uring.c:7904 [inline]
 io_ring_exit_work+0x363/0x6d0 fs/io_uring.c:7979
 process_one_work+0x94c/0x1670 kernel/workqueue.c:2269
 worker_thread+0x64c/0x1120 kernel/workqueue.c:2415
 kthread+0x3b5/0x4a0 kernel/kthread.c:292
 ret_from_fork+0x1f/0x30 arch/x86/entry/entry_64.S:294

Allocated by task 17016:
 kasan_save_stack+0x1b/0x40 mm/kasan/common.c:48
 kasan_set_track mm/kasan/common.c:56 [inline]
 __kasan_kmalloc.constprop.0+0xbf/0xd0 mm/kasan/common.c:461
 slab_post_alloc_hook mm/slab.h:518 [inline]
 slab_alloc mm/slab.c:3316 [inline]
 kmem_cache_alloc+0x13a/0x3f0 mm/slab.c:3486
 radix_tree_node_alloc.constprop.0+0x7c/0x350 lib/radix-tree.c:275
 idr_get_free+0x4c5/0x940 lib/radix-tree.c:1505
 idr_alloc_u32+0x170/0x2d0 lib/idr.c:46
 idr_alloc+0xc2/0x130 lib/idr.c:87
 io_provide_buffers fs/io_uring.c:3768 [inline]
 io_issue_sqe+0x48d2/0x5c50 fs/io_uring.c:5906
 __io_queue_sqe+0x280/0x1160 fs/io_uring.c:6178
 io_queue_sqe+0x692/0xfa0 fs/io_uring.c:6257
 io_submit_sqe fs/io_uring.c:6327 [inline]
 io_submit_sqes+0x1759/0x23f0 fs/io_uring.c:6521
 __do_sys_io_uring_enter+0xeac/0x1bd0 fs/io_uring.c:8349
 do_syscall_32_irqs_on arch/x86/entry/common.c:78 [inline]
 __do_fast_syscall_32+0x60/0x90 arch/x86/entry/common.c:137
 do_fast_syscall_32+0x2f/0x70 arch/x86/entry/common.c:160
 entry_SYSENTER_compat_after_hwframe+0x4d/0x5c

Freed by task 16:
 kasan_save_stack+0x1b/0x40 mm/kasan/common.c:48
 kasan_set_track+0x1c/0x30 mm/kasan/common.c:56
 kasan_set_free_info+0x1b/0x30 mm/kasan/generic.c:355
 __kasan_slab_free+0xd8/0x120 mm/kasan/common.c:422
 __cache_free mm/slab.c:3422 [inline]
 kmem_cache_free.part.0+0x74/0x1e0 mm/slab.c:3697
 rcu_do_batch kernel/rcu/tree.c:2430 [inline]
 rcu_core+0x5ca/0x1130 kernel/rcu/tree.c:2658
 __do_softirq+0x1f8/0xb23 kernel/softirq.c:298

Last call_rcu():
 kasan_save_stack+0x1b/0x40 mm/kasan/common.c:48
 kasan_record_aux_stack+0x82/0xb0 mm/kasan/generic.c:346
 __call_rcu kernel/rcu/tree.c:2896 [inline]
 call_rcu+0x15e/0x7c0 kernel/rcu/tree.c:2970
 radix_tree_node_free lib/radix-tree.c:309 [inline]
 delete_node+0x591/0x8c0 lib/radix-tree.c:572
 __radix_tree_delete+0x190/0x370 lib/radix-tree.c:1378
 radix_tree_delete_item+0xe7/0x230 lib/radix-tree.c:1429
 __io_remove_buffers fs/io_uring.c:3666 [inline]
 __io_remove_buffers fs/io_uring.c:3645 [inline]
 __io_destroy_buffers+0x161/0x200 fs/io_uring.c:7883
 idr_for_each+0x113/0x220 lib/idr.c:208
 io_destroy_buffers fs/io_uring.c:7889 [inline]
 io_ring_ctx_free fs/io_uring.c:7904 [inline]
 io_ring_exit_work+0x363/0x6d0 fs/io_uring.c:7979
 process_one_work+0x94c/0x1670 kernel/workqueue.c:2269
 worker_thread+0x64c/0x1120 kernel/workqueue.c:2415
 kthread+0x3b5/0x4a0 kernel/kthread.c:292
 ret_from_fork+0x1f/0x30 arch/x86/entry/entry_64.S:294

Second to last call_rcu():
 kasan_save_stack+0x1b/0x40 mm/kasan/common.c:48
 kasan_record_aux_stack+0x82/0xb0 mm/kasan/generic.c:346
 __call_rcu kernel/rcu/tree.c:2896 [inline]
 call_rcu+0x15e/0x7c0 kernel/rcu/tree.c:2970
 radix_tree_node_free lib/radix-tree.c:309 [inline]
 radix_tree_shrink lib/radix-tree.c:535 [inline]
 delete_node+0x37a/0x8c0 lib/radix-tree.c:553
 __radix_tree_delete+0x190/0x370 lib/radix-tree.c:1378
 radix_tree_delete_item+0xe7/0x230 lib/radix-tree.c:1429
 free_pid+0xa1/0x260 kernel/pid.c:151
 __change_pid+0x1c7/0x2d0 kernel/pid.c:352
 __unhash_process kernel/exit.c:77 [inline]
 __exit_signal kernel/exit.c:147 [inline]
 release_task+0xd29/0x14d0 kernel/exit.c:198
 wait_task_zombie kernel/exit.c:1088 [inline]
 wait_consider_task+0x2fd2/0x3b70 kernel/exit.c:1315
 do_wait_thread kernel/exit.c:1378 [inline]
 do_wait+0x376/0xa00 kernel/exit.c:1449
 kernel_wait4+0x14c/0x260 kernel/exit.c:1621
 do_syscall_32_irqs_on arch/x86/entry/common.c:78 [inline]
 __do_fast_syscall_32+0x60/0x90 arch/x86/entry/common.c:137
 do_fast_syscall_32+0x2f/0x70 arch/x86/entry/common.c:160
 entry_SYSENTER_compat_after_hwframe+0x4d/0x5c

The buggy address belongs to the object at ffff88804eb9cb00
 which belongs to the cache radix_tree_node of size 576
The buggy address is located 48 bytes inside of
 576-byte region [ffff88804eb9cb00, ffff88804eb9cd40)
The buggy address belongs to the page:
page:00000000a35d3b6e refcount:1 mapcount:0 mapping:0000000000000000 index:0xffff88804eb9cffb pfn:0x4eb9c
flags: 0xfffe0000000200(slab)
raw: 00fffe0000000200 ffffea00013ab388 ffffea0002927748 ffff8880aa06f000
raw: ffff88804eb9cffb ffff88804eb9c000 0000000100000005 0000000000000000
page dumped because: kasan: bad access detected

Memory state around the buggy address:
 ffff88804eb9ca00: fb fb fb fb fb fb fb fb fb fb fb fb fb fb fb fb
 ffff88804eb9ca80: fc fc fc fc fc fc fc fc fc fc fc fc fc fc fc fc
>ffff88804eb9cb00: fa fb fb fb fb fb fb fb fb fb fb fb fb fb fb fb
                                     ^
 ffff88804eb9cb80: fb fb fb fb fb fb fb fb fb fb fb fb fb fb fb fb
 ffff88804eb9cc00: fb fb fb fb fb fb fb fb fb fb fb fb fb fb fb fb
==================================================================


---
This report is generated by a bot. It may contain errors.
See https://goo.gl/tpsmEJ for more information about syzbot.
syzbot engineers can be reached at syzkaller@googlegroups.com.

syzbot will keep track of this issue. See:
https://goo.gl/tpsmEJ#status for how to communicate with syzbot.
