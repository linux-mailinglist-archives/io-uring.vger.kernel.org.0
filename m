Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id C0DA2243E48
	for <lists+io-uring@lfdr.de>; Thu, 13 Aug 2020 19:28:27 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726419AbgHMR20 (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Thu, 13 Aug 2020 13:28:26 -0400
Received: from mail-io1-f71.google.com ([209.85.166.71]:33554 "EHLO
        mail-io1-f71.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726192AbgHMR2X (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Thu, 13 Aug 2020 13:28:23 -0400
Received: by mail-io1-f71.google.com with SMTP id a12so4586031ioo.0
        for <io-uring@vger.kernel.org>; Thu, 13 Aug 2020 10:28:23 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:date:message-id:subject:from:to;
        bh=ldpXwfigXaNaYABjkX+Qet8HDUWG+klcFP4raS2Jo7A=;
        b=EkCzB3092CMinDI25rtPe3LRco+Xr7BE1gqLxn8HG/3po388JmQM2zj8/54e/1CpRb
         XlBTcSs+ZB6lwf1XiR2skGopTAKESLIikJKg/FMeuNdEL4rOfbWhU03gtja8PWDsSJjj
         Uk8/OBexe0Y91HCDmONRICKBoxNUsyDT49LVbwfOKOYoNPGmujAeeXTvjADCTFHyQj6s
         o09c3l5FnJJIYVJ44NohWOHOV5nh1Tkox4TyRknnIHnHfaV9/XH2Fm3hf57UOgK5DPt8
         8yz3pQd241IARxLdX/UfCumfz3qZRjSO/4lMwGWHtpbA2235ln25EAYzOASlfhX3puwN
         cuAg==
X-Gm-Message-State: AOAM530TlFYhOlVVCy43m6q0IulbYgpsxUE8aUyHeggPIJqs/dlPnzG9
        OKpks0Wi+Vp3SqVEeIsX84g2oqaNe5X54EeFIT0jOA57YVtB
X-Google-Smtp-Source: ABdhPJwbgt9PtKppPlYaFBH6G6aIb7jTr/Ctd9L+MfCY7sbdaIrxp7xhpQHysBI5O4lbn8iuGlizudWC0obKLgG3JC6lB+qLSQWk
MIME-Version: 1.0
X-Received: by 2002:a05:6638:1005:: with SMTP id r5mr6363265jab.116.1597339702885;
 Thu, 13 Aug 2020 10:28:22 -0700 (PDT)
Date:   Thu, 13 Aug 2020 10:28:22 -0700
X-Google-Appengine-App-Id: s~syzkaller
X-Google-Appengine-App-Id-Alias: syzkaller
Message-ID: <00000000000093837f05acc5a11f@google.com>
Subject: KASAN: use-after-free Read in idr_for_each
From:   syzbot <syzbot+25d82ed5cc4b474f1df8@syzkaller.appspotmail.com>
To:     axboe@kernel.dk, io-uring@vger.kernel.org,
        linux-fsdevel@vger.kernel.org, linux-kernel@vger.kernel.org,
        syzkaller-bugs@googlegroups.com, viro@zeniv.linux.org.uk
Content-Type: text/plain; charset="UTF-8"
Sender: io-uring-owner@vger.kernel.org
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org

Hello,

syzbot found the following issue on:

HEAD commit:    fb893de3 Merge tag 'tag-chrome-platform-for-v5.9' of git:/..
git tree:       upstream
console output: https://syzkaller.appspot.com/x/log.txt?x=167ed216900000
kernel config:  https://syzkaller.appspot.com/x/.config?x=f1fedc63022bf07e
dashboard link: https://syzkaller.appspot.com/bug?extid=25d82ed5cc4b474f1df8
compiler:       gcc (GCC) 10.1.0-syz 20200507
syz repro:      https://syzkaller.appspot.com/x/repro.syz?x=107bc222900000
C reproducer:   https://syzkaller.appspot.com/x/repro.c?x=17a09d06900000

IMPORTANT: if you fix the issue, please add the following tag to the commit:
Reported-by: syzbot+25d82ed5cc4b474f1df8@syzkaller.appspotmail.com

==================================================================
BUG: KASAN: use-after-free in radix_tree_next_slot include/linux/radix-tree.h:421 [inline]
BUG: KASAN: use-after-free in idr_for_each+0x206/0x220 lib/idr.c:202
Read of size 8 at addr ffff888082058c78 by task syz-executor999/3765

CPU: 1 PID: 3765 Comm: syz-executor999 Not tainted 5.8.0-syzkaller #0
Hardware name: Google Google Compute Engine/Google Compute Engine, BIOS Google 01/01/2011
Call Trace:
 __dump_stack lib/dump_stack.c:77 [inline]
 dump_stack+0x18f/0x20d lib/dump_stack.c:118
 print_address_description.constprop.0.cold+0xae/0x497 mm/kasan/report.c:383
 __kasan_report mm/kasan/report.c:513 [inline]
 kasan_report.cold+0x1f/0x37 mm/kasan/report.c:530
 radix_tree_next_slot include/linux/radix-tree.h:421 [inline]
 idr_for_each+0x206/0x220 lib/idr.c:202
 io_ring_ctx_wait_and_kill+0x374/0x600 fs/io_uring.c:7810
 io_uring_release+0x3e/0x50 fs/io_uring.c:7829
 __fput+0x285/0x920 fs/file_table.c:281
 task_work_run+0xdd/0x190 kernel/task_work.c:135
 exit_task_work include/linux/task_work.h:25 [inline]
 do_exit+0xb7d/0x29f0 kernel/exit.c:806
 do_group_exit+0x125/0x310 kernel/exit.c:903
 get_signal+0x40b/0x1ee0 kernel/signal.c:2743
 arch_do_signal+0x82/0x2520 arch/x86/kernel/signal.c:811
 exit_to_user_mode_loop kernel/entry/common.c:135 [inline]
 exit_to_user_mode_prepare+0x172/0x1d0 kernel/entry/common.c:166
 syscall_exit_to_user_mode+0x59/0x2b0 kernel/entry/common.c:241
 entry_SYSCALL_64_after_hwframe+0x44/0xa9
RIP: 0033:0x447179
Code: Bad RIP value.
RSP: 002b:00007f049661dcf8 EFLAGS: 00000246 ORIG_RAX: 00000000000000ca
RAX: fffffffffffffe00 RBX: 00000000006dbc38 RCX: 0000000000447179
RDX: 0000000000000000 RSI: 0000000000000080 RDI: 00000000006dbc38
RBP: 00000000006dbc30 R08: 0000000000000000 R09: 0000000000000000
R10: 0000000000000000 R11: 0000000000000246 R12: 00000000006dbc3c
R13: 00007ffd1e2340df R14: 00007f049661e9c0 R15: 0000000000000001

Allocated by task 3747:
 kasan_save_stack+0x1b/0x40 mm/kasan/common.c:48
 kasan_set_track mm/kasan/common.c:56 [inline]
 __kasan_kmalloc.constprop.0+0xbf/0xd0 mm/kasan/common.c:461
 slab_post_alloc_hook mm/slab.h:518 [inline]
 slab_alloc mm/slab.c:3312 [inline]
 kmem_cache_alloc+0x138/0x3a0 mm/slab.c:3482
 radix_tree_node_alloc.constprop.0+0x7c/0x320 lib/radix-tree.c:275
 idr_get_free+0x4b0/0x8e0 lib/radix-tree.c:1505
 idr_alloc_u32+0x170/0x2d0 lib/idr.c:46
 idr_alloc_cyclic+0x102/0x230 lib/idr.c:125
 io_register_personality fs/io_uring.c:8454 [inline]
 __io_uring_register fs/io_uring.c:8575 [inline]
 __do_sys_io_uring_register+0x606/0x33f0 fs/io_uring.c:8615
 do_syscall_64+0x2d/0x70 arch/x86/entry/common.c:46
 entry_SYSCALL_64_after_hwframe+0x44/0xa9

Freed by task 16:
 kasan_save_stack+0x1b/0x40 mm/kasan/common.c:48
 kasan_set_track+0x1c/0x30 mm/kasan/common.c:56
 kasan_set_free_info+0x1b/0x30 mm/kasan/generic.c:355
 __kasan_slab_free+0xd8/0x120 mm/kasan/common.c:422
 __cache_free mm/slab.c:3418 [inline]
 kmem_cache_free.part.0+0x67/0x1f0 mm/slab.c:3693
 rcu_do_batch kernel/rcu/tree.c:2428 [inline]
 rcu_core+0x5c7/0x1190 kernel/rcu/tree.c:2656
 __do_softirq+0x2de/0xa24 kernel/softirq.c:298

Last call_rcu():
 kasan_save_stack+0x1b/0x40 mm/kasan/common.c:48
 kasan_record_aux_stack+0x82/0xb0 mm/kasan/generic.c:346
 __call_rcu kernel/rcu/tree.c:2894 [inline]
 call_rcu+0x14f/0x7e0 kernel/rcu/tree.c:2968
 radix_tree_node_free lib/radix-tree.c:309 [inline]
 delete_node+0x587/0x8a0 lib/radix-tree.c:572
 __radix_tree_delete+0x190/0x370 lib/radix-tree.c:1378
 radix_tree_delete_item+0xe7/0x230 lib/radix-tree.c:1429
 io_remove_personalities+0x1b/0xb0 fs/io_uring.c:7769
 idr_for_each+0x113/0x220 lib/idr.c:208
 io_ring_ctx_wait_and_kill+0x374/0x600 fs/io_uring.c:7810
 io_uring_release+0x3e/0x50 fs/io_uring.c:7829
 __fput+0x285/0x920 fs/file_table.c:281
 task_work_run+0xdd/0x190 kernel/task_work.c:135
 exit_task_work include/linux/task_work.h:25 [inline]
 do_exit+0xb7d/0x29f0 kernel/exit.c:806
 do_group_exit+0x125/0x310 kernel/exit.c:903
 get_signal+0x40b/0x1ee0 kernel/signal.c:2743
 arch_do_signal+0x82/0x2520 arch/x86/kernel/signal.c:811
 exit_to_user_mode_loop kernel/entry/common.c:135 [inline]
 exit_to_user_mode_prepare+0x172/0x1d0 kernel/entry/common.c:166
 syscall_exit_to_user_mode+0x59/0x2b0 kernel/entry/common.c:241
 entry_SYSCALL_64_after_hwframe+0x44/0xa9

Second to last call_rcu():
 kasan_save_stack+0x1b/0x40 mm/kasan/common.c:48
 kasan_record_aux_stack+0x82/0xb0 mm/kasan/generic.c:346
 __call_rcu kernel/rcu/tree.c:2894 [inline]
 call_rcu+0x14f/0x7e0 kernel/rcu/tree.c:2968
 radix_tree_node_free lib/radix-tree.c:309 [inline]
 delete_node+0x587/0x8a0 lib/radix-tree.c:572
 __radix_tree_delete+0x190/0x370 lib/radix-tree.c:1378
 radix_tree_delete_item+0xe7/0x230 lib/radix-tree.c:1429
 io_remove_personalities+0x1b/0xb0 fs/io_uring.c:7769
 idr_for_each+0x113/0x220 lib/idr.c:208
 io_ring_ctx_wait_and_kill+0x374/0x600 fs/io_uring.c:7810
 io_uring_release+0x3e/0x50 fs/io_uring.c:7829
 __fput+0x285/0x920 fs/file_table.c:281
 task_work_run+0xdd/0x190 kernel/task_work.c:135
 exit_task_work include/linux/task_work.h:25 [inline]
 do_exit+0xb7d/0x29f0 kernel/exit.c:806
 do_group_exit+0x125/0x310 kernel/exit.c:903
 get_signal+0x40b/0x1ee0 kernel/signal.c:2743
 arch_do_signal+0x82/0x2520 arch/x86/kernel/signal.c:811
 exit_to_user_mode_loop kernel/entry/common.c:135 [inline]
 exit_to_user_mode_prepare+0x172/0x1d0 kernel/entry/common.c:166
 syscall_exit_to_user_mode+0x59/0x2b0 kernel/entry/common.c:241
 entry_SYSCALL_64_after_hwframe+0x44/0xa9

The buggy address belongs to the object at ffff888082058c40
 which belongs to the cache radix_tree_node of size 576
The buggy address is located 56 bytes inside of
 576-byte region [ffff888082058c40, ffff888082058e80)
The buggy address belongs to the page:
page:0000000023bf3329 refcount:1 mapcount:0 mapping:0000000000000000 index:0xffff888082058ffb pfn:0x82058
flags: 0xfffe0000000200(slab)
raw: 00fffe0000000200 ffffea0002080ac8 ffffea0002080cc8 ffff8880aa06f000
raw: ffff888082058ffb ffff888082058140 0000000100000005 0000000000000000
page dumped because: kasan: bad access detected

Memory state around the buggy address:
 ffff888082058b00: fb fb fb fb fb fb fb fb fb fb fb fb fb fb fb fb
 ffff888082058b80: fb fb fb fb fb fb fb fb fc fc fc fc fc fc fc fc
>ffff888082058c00: fc fc fc fc fc fc fc fc fa fb fb fb fb fb fb fb
                                                                ^
 ffff888082058c80: fb fb fb fb fb fb fb fb fb fb fb fb fb fb fb fb
 ffff888082058d00: fb fb fb fb fb fb fb fb fb fb fb fb fb fb fb fb
==================================================================


---
This report is generated by a bot. It may contain errors.
See https://goo.gl/tpsmEJ for more information about syzbot.
syzbot engineers can be reached at syzkaller@googlegroups.com.

syzbot will keep track of this issue. See:
https://goo.gl/tpsmEJ#status for how to communicate with syzbot.
syzbot can test patches for this issue, for details see:
https://goo.gl/tpsmEJ#testing-patches
