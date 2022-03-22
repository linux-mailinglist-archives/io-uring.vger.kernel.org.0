Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id DBB204E4573
	for <lists+io-uring@lfdr.de>; Tue, 22 Mar 2022 18:48:34 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S239831AbiCVRt6 (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Tue, 22 Mar 2022 13:49:58 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:45400 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S239852AbiCVRt5 (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Tue, 22 Mar 2022 13:49:57 -0400
Received: from mail-il1-f198.google.com (mail-il1-f198.google.com [209.85.166.198])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id A24F3673C1
        for <io-uring@vger.kernel.org>; Tue, 22 Mar 2022 10:48:28 -0700 (PDT)
Received: by mail-il1-f198.google.com with SMTP id a1-20020a927f01000000b002c76f4191c5so9650978ild.0
        for <io-uring@vger.kernel.org>; Tue, 22 Mar 2022 10:48:28 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:mime-version:date:message-id:subject:from:to;
        bh=oJZwdz9JBhGCcPSjS6Q2DkZuk26UljH41dYN2tYJ6/o=;
        b=m07XuBvGcKATRxwb50JAMFSiZJ71u6qei7eGFsARFYH0sTNCkOuShDFyrmUjnOzWbq
         f/w//N/ESTGpC7mKmaw6IEmFYh0ntynFQsc82hzfx7Jaw9UuXoFCivcFGRMx5I+C8E8j
         ISY3J3TpSLpMQtkSq91/9fI9HZ6nvfpT0prA+chR978Ro4zYWXCpSifapGSA9cmoAblJ
         3XkmFRpO8GAs+7/x3kIbFtYYMTPA7m9WMRUFqS5wbMG/up8FHfS0zxE175XKoDBTclXI
         wSCEQLSC8oKbjW5takMXVmhriwfuKa117kdTeniU8GKfB5eVaXAJurGNl8bMa6pqnXsW
         5M6A==
X-Gm-Message-State: AOAM530nWEksYHRxeir/+i0C7WWbW2hbGCgbwrJAdD7zFfQMm1Z5H1yT
        8kzzfh+zMYNUISyWdy39VvkGSucCbyBq0W9mlnSGrPaWbfFg
X-Google-Smtp-Source: ABdhPJxj8Xx14kXROYrnmWuUfRsUsK+uhpWsT94Q50nrQTkLGclj9PsxAD1OncBeU3+Sq4zEgJAwCMWFn0Tdt0jwqDND6lp8HWT+
MIME-Version: 1.0
X-Received: by 2002:a05:6602:1491:b0:648:cd01:9ba9 with SMTP id
 a17-20020a056602149100b00648cd019ba9mr13042234iow.195.1647971308022; Tue, 22
 Mar 2022 10:48:28 -0700 (PDT)
Date:   Tue, 22 Mar 2022 10:48:28 -0700
X-Google-Appengine-App-Id: s~syzkaller
X-Google-Appengine-App-Id-Alias: syzkaller
Message-ID: <0000000000006a354705dad2387e@google.com>
Subject: [syzbot] KASAN: use-after-free Read in tty_release
From:   syzbot <syzbot+09ad4050dd3a120bfccd@syzkaller.appspotmail.com>
To:     asml.silence@gmail.com, axboe@kernel.dk,
        gregkh@linuxfoundation.org, io-uring@vger.kernel.org,
        jirislaby@kernel.org, linux-kernel@vger.kernel.org,
        syzkaller-bugs@googlegroups.com
Content-Type: text/plain; charset="UTF-8"
X-Spam-Status: No, score=0.8 required=5.0 tests=BAYES_00,FROM_LOCAL_HEX,
        HEADER_FROM_DIFFERENT_DOMAINS,RCVD_IN_DNSWL_NONE,RCVD_IN_MSPIKE_H2,
        SORTED_RECIPS,SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=no
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org

Hello,

syzbot found the following issue on:

HEAD commit:    8565d64430f8 Merge tag 'bounds-fixes-v5.18-rc1' of git://g..
git tree:       upstream
console output: https://syzkaller.appspot.com/x/log.txt?x=118a7913700000
kernel config:  https://syzkaller.appspot.com/x/.config?x=89040bbe61f60a52
dashboard link: https://syzkaller.appspot.com/bug?extid=09ad4050dd3a120bfccd
compiler:       gcc (Debian 10.2.1-6) 10.2.1 20210110, GNU ld (GNU Binutils for Debian) 2.35.2
syz repro:      https://syzkaller.appspot.com/x/repro.syz?x=124eed75700000
C reproducer:   https://syzkaller.appspot.com/x/repro.c?x=11fbbb35700000

The issue was bisected to:

commit 91eac1c69c202d9dad8bf717ae5b92db70bfe5cf
Author: Jens Axboe <axboe@kernel.dk>
Date:   Wed Mar 16 22:59:10 2022 +0000

    io_uring: cache poll/double-poll state with a request flag

bisection log:  https://syzkaller.appspot.com/x/bisect.txt?x=12e4ae0b700000
final oops:     https://syzkaller.appspot.com/x/report.txt?x=11e4ae0b700000
console output: https://syzkaller.appspot.com/x/log.txt?x=16e4ae0b700000

IMPORTANT: if you fix the issue, please add the following tag to the commit:
Reported-by: syzbot+09ad4050dd3a120bfccd@syzkaller.appspotmail.com
Fixes: 91eac1c69c20 ("io_uring: cache poll/double-poll state with a request flag")

==================================================================
BUG: KASAN: use-after-free in __wake_up_common+0x637/0x650 kernel/sched/wait.c:101
Read of size 8 at addr ffff888011e8a130 by task syz-executor413/3618

CPU: 0 PID: 3618 Comm: syz-executor413 Tainted: G        W         5.17.0-syzkaller-01402-g8565d64430f8 #0
Hardware name: Google Google Compute Engine/Google Compute Engine, BIOS Google 01/01/2011
Call Trace:
 <TASK>
 __dump_stack lib/dump_stack.c:88 [inline]
 dump_stack_lvl+0xcd/0x134 lib/dump_stack.c:106
 print_address_description.constprop.0.cold+0x8d/0x303 mm/kasan/report.c:255
 __kasan_report mm/kasan/report.c:442 [inline]
 kasan_report.cold+0x83/0xdf mm/kasan/report.c:459
 __wake_up_common+0x637/0x650 kernel/sched/wait.c:101
 __wake_up_common_lock+0xd0/0x130 kernel/sched/wait.c:138
 tty_release+0x657/0x1200 drivers/tty/tty_io.c:1781
 __fput+0x286/0x9f0 fs/file_table.c:317
 task_work_run+0xdd/0x1a0 kernel/task_work.c:164
 exit_task_work include/linux/task_work.h:32 [inline]
 do_exit+0xaff/0x29d0 kernel/exit.c:806
 do_group_exit+0xd2/0x2f0 kernel/exit.c:936
 __do_sys_exit_group kernel/exit.c:947 [inline]
 __se_sys_exit_group kernel/exit.c:945 [inline]
 __x64_sys_exit_group+0x3a/0x50 kernel/exit.c:945
 do_syscall_x64 arch/x86/entry/common.c:50 [inline]
 do_syscall_64+0x35/0xb0 arch/x86/entry/common.c:80
 entry_SYSCALL_64_after_hwframe+0x44/0xae
RIP: 0033:0x7f439a1fac69
Code: Unable to access opcode bytes at RIP 0x7f439a1fac3f.
RSP: 002b:00007ffd9df32928 EFLAGS: 00000246 ORIG_RAX: 00000000000000e7
RAX: ffffffffffffffda RBX: 00007f439a26f330 RCX: 00007f439a1fac69
RDX: 000000000000003c RSI: 00000000000000e7 RDI: 0000000000000000
RBP: 0000000000000000 R08: ffffffffffffffc0 R09: 0000000030000000
R10: 0000000000000000 R11: 0000000000000246 R12: 00007f439a26f330
R13: 0000000000000001 R14: 0000000000000000 R15: 0000000000000001
 </TASK>

Allocated by task 3610:
 kasan_save_stack+0x1e/0x40 mm/kasan/common.c:38
 kasan_set_track mm/kasan/common.c:45 [inline]
 set_alloc_info mm/kasan/common.c:436 [inline]
 ____kasan_kmalloc mm/kasan/common.c:515 [inline]
 ____kasan_kmalloc mm/kasan/common.c:474 [inline]
 __kasan_kmalloc+0xa6/0xd0 mm/kasan/common.c:524
 kasan_kmalloc include/linux/kasan.h:249 [inline]
 kmem_cache_alloc_trace+0x1ea/0x4a0 mm/slab.c:3567
 kmalloc include/linux/slab.h:581 [inline]
 io_arm_poll_handler+0x39d/0x940 fs/io_uring.c:6248
 io_queue_sqe_arm_apoll+0x6d/0x430 fs/io_uring.c:7499
 __io_queue_sqe fs/io_uring.c:7541 [inline]
 io_queue_sqe fs/io_uring.c:7568 [inline]
 io_submit_sqe fs/io_uring.c:7776 [inline]
 io_submit_sqes+0x7dda/0x9310 fs/io_uring.c:7882
 __do_sys_io_uring_enter+0x9f1/0x1520 fs/io_uring.c:10924
 do_syscall_x64 arch/x86/entry/common.c:50 [inline]
 do_syscall_64+0x35/0xb0 arch/x86/entry/common.c:80
 entry_SYSCALL_64_after_hwframe+0x44/0xae

Freed by task 3610:
 kasan_save_stack+0x1e/0x40 mm/kasan/common.c:38
 kasan_set_track+0x21/0x30 mm/kasan/common.c:45
 kasan_set_free_info+0x20/0x30 mm/kasan/generic.c:370
 ____kasan_slab_free mm/kasan/common.c:366 [inline]
 ____kasan_slab_free+0xff/0x140 mm/kasan/common.c:328
 kasan_slab_free include/linux/kasan.h:215 [inline]
 __cache_free mm/slab.c:3437 [inline]
 kfree+0xf8/0x2b0 mm/slab.c:3794
 io_clean_op+0x20a/0xd90 fs/io_uring.c:7137
 io_dismantle_req fs/io_uring.c:2270 [inline]
 __io_req_complete_post+0x88c/0xc90 fs/io_uring.c:2108
 io_req_complete_post+0x56/0x1d0 fs/io_uring.c:2121
 io_apoll_task_func+0x1df/0x230 fs/io_uring.c:6003
 handle_tw_list fs/io_uring.c:2480 [inline]
 tctx_task_work+0x1a2/0x1380 fs/io_uring.c:2514
 task_work_run+0xdd/0x1a0 kernel/task_work.c:164
 exit_task_work include/linux/task_work.h:32 [inline]
 do_exit+0xaff/0x29d0 kernel/exit.c:806
 do_group_exit+0xd2/0x2f0 kernel/exit.c:936
 __do_sys_exit_group kernel/exit.c:947 [inline]
 __se_sys_exit_group kernel/exit.c:945 [inline]
 __x64_sys_exit_group+0x3a/0x50 kernel/exit.c:945
 do_syscall_x64 arch/x86/entry/common.c:50 [inline]
 do_syscall_64+0x35/0xb0 arch/x86/entry/common.c:80
 entry_SYSCALL_64_after_hwframe+0x44/0xae

The buggy address belongs to the object at ffff888011e8a100
 which belongs to the cache kmalloc-96 of size 96
The buggy address is located 48 bytes inside of
 96-byte region [ffff888011e8a100, ffff888011e8a160)
The buggy address belongs to the page:
page:ffffea000047a280 refcount:1 mapcount:0 mapping:0000000000000000 index:0xffff888011e8a480 pfn:0x11e8a
flags: 0xfff00000000200(slab|node=0|zone=1|lastcpupid=0x7ff)
raw: 00fff00000000200 ffffea000079fc08 ffffea0001f1d088 ffff888010c40300
raw: ffff888011e8a480 ffff888011e8a000 000000010000001e 0000000000000000
page dumped because: kasan: bad access detected
page_owner tracks the page as allocated
page last allocated via order 0, migratetype Unmovable, gfp_mask 0x2420c0(__GFP_IO|__GFP_FS|__GFP_NOWARN|__GFP_COMP|__GFP_THISNODE), pid 1, ts 3360715486, free_ts 0
 prep_new_page mm/page_alloc.c:2434 [inline]
 get_page_from_freelist+0xa72/0x2f50 mm/page_alloc.c:4165
 __alloc_pages+0x1b2/0x500 mm/page_alloc.c:5389
 __alloc_pages_node include/linux/gfp.h:572 [inline]
 kmem_getpages mm/slab.c:1378 [inline]
 cache_grow_begin+0x75/0x390 mm/slab.c:2584
 cache_alloc_refill+0x27f/0x380 mm/slab.c:2957
 ____cache_alloc mm/slab.c:3040 [inline]
 ____cache_alloc mm/slab.c:3023 [inline]
 __do_cache_alloc mm/slab.c:3267 [inline]
 slab_alloc mm/slab.c:3308 [inline]
 kmem_cache_alloc_trace+0x380/0x4a0 mm/slab.c:3565
 kmalloc include/linux/slab.h:581 [inline]
 kzalloc include/linux/slab.h:714 [inline]
 hugetlbfs_init_fs_context+0x41/0x420 fs/hugetlbfs/inode.c:1402
 alloc_fs_context+0x582/0xa00 fs/fs_context.c:290
 mount_one_hugetlbfs+0x1d/0x14d fs/hugetlbfs/inode.c:1507
 init_hugetlbfs_fs+0xd5/0x311 fs/hugetlbfs/inode.c:1546
 do_one_initcall+0x103/0x650 init/main.c:1300
 do_initcall_level init/main.c:1373 [inline]
 do_initcalls init/main.c:1389 [inline]
 do_basic_setup init/main.c:1408 [inline]
 kernel_init_freeable+0x6b1/0x73a init/main.c:1613
 kernel_init+0x1a/0x1d0 init/main.c:1502
 ret_from_fork+0x1f/0x30 arch/x86/entry/entry_64.S:295
page_owner free stack trace missing

Memory state around the buggy address:
 ffff888011e8a000: 00 00 00 00 00 00 00 00 00 05 fc fc fc fc fc fc
 ffff888011e8a080: fa fb fb fb fb fb fb fb fb fb fb fb fc fc fc fc
>ffff888011e8a100: fa fb fb fb fb fb fb fb fb fb fb fb fc fc fc fc
                                     ^
 ffff888011e8a180: 00 00 00 00 00 00 00 00 00 00 00 fc fc fc fc fc
 ffff888011e8a200: 00 00 00 00 00 00 00 00 00 fc fc fc fc fc fc fc
==================================================================


---
This report is generated by a bot. It may contain errors.
See https://goo.gl/tpsmEJ for more information about syzbot.
syzbot engineers can be reached at syzkaller@googlegroups.com.

syzbot will keep track of this issue. See:
https://goo.gl/tpsmEJ#status for how to communicate with syzbot.
For information about bisection process see: https://goo.gl/tpsmEJ#bisection
syzbot can test patches for this issue, for details see:
https://goo.gl/tpsmEJ#testing-patches
