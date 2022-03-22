Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 9DCDD4E3B37
	for <lists+io-uring@lfdr.de>; Tue, 22 Mar 2022 09:52:39 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231888AbiCVIxv (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Tue, 22 Mar 2022 04:53:51 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:38902 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231874AbiCVIxu (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Tue, 22 Mar 2022 04:53:50 -0400
Received: from mail-il1-f197.google.com (mail-il1-f197.google.com [209.85.166.197])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 0301D7DAB7
        for <io-uring@vger.kernel.org>; Tue, 22 Mar 2022 01:52:21 -0700 (PDT)
Received: by mail-il1-f197.google.com with SMTP id z15-20020a92d6cf000000b002c811796c23so3276335ilp.3
        for <io-uring@vger.kernel.org>; Tue, 22 Mar 2022 01:52:20 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:mime-version:date:message-id:subject:from:to;
        bh=aPWrAvb8qvWbuOEd6bcF+hw+Q1SsdpcI7vwukB2ythQ=;
        b=jw9d/QDWjd0d9Xh0AHF5nU8c3hJgan/wVEcABYvQd28IEoErApXx1jHkol1tx9EeB/
         Aixn+posYkOzbagJDnVhpFqGuGTS+900KJ3Fq5HjSBE0CqummNcBBcrgxUVPjHhJ56ck
         kCfLS25NTkXBmK2PI6GBEg/SsOAXrfAD94TUWwb4piU75jhVGIvpVof5MwCPyPQotSN1
         Gun6H3APXcdR6xunIj99mjosSTk8hy9QXxVl33cMywwex1KPL13CQpVzWCoxwTLBwCZs
         Rhc0MvS7Qiqj0maNow0lItVbwT5zB+wh+O094xpYYxUaHPmm9QxxkeZ7moVKn4Ll9SLA
         AHYQ==
X-Gm-Message-State: AOAM531K5MMN6eZuViX76aBPcM3/pticg2FsLjEp8huQJQ9Vhwytuq4R
        LBeI/PJlb3rhhF13WykGUPYmCH9KWT6k/E1/RWGKXb4wW/Jt
X-Google-Smtp-Source: ABdhPJwo7skWb2kNRkeY+JACe04jchnCTlo4/lyYCbiiyftD5tNly8rYpyHywr1aYMKFVTlBC9RwLlqtFtafaPXsb7rSx3q9/lVo
MIME-Version: 1.0
X-Received: by 2002:a05:6e02:1a62:b0:2c8:47e7:c52b with SMTP id
 w2-20020a056e021a6200b002c847e7c52bmr687433ilv.11.1647939140377; Tue, 22 Mar
 2022 01:52:20 -0700 (PDT)
Date:   Tue, 22 Mar 2022 01:52:20 -0700
X-Google-Appengine-App-Id: s~syzkaller
X-Google-Appengine-App-Id-Alias: syzkaller
Message-ID: <00000000000012e22c05dacabb11@google.com>
Subject: [syzbot] KASAN: use-after-free Read in add_wait_queue
From:   syzbot <syzbot+950cee6d91e62329be2c@syzkaller.appspotmail.com>
To:     asml.silence@gmail.com, axboe@kernel.dk, io-uring@vger.kernel.org,
        linux-kernel@vger.kernel.org, syzkaller-bugs@googlegroups.com
Content-Type: text/plain; charset="UTF-8"
X-Spam-Status: No, score=-1.7 required=5.0 tests=BAYES_00,FROM_LOCAL_HEX,
        HEADER_FROM_DIFFERENT_DOMAINS,RCVD_IN_DNSWL_NONE,RCVD_IN_MSPIKE_H2,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=no
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
console output: https://syzkaller.appspot.com/x/log.txt?x=179570b5700000
kernel config:  https://syzkaller.appspot.com/x/.config?x=89040bbe61f60a52
dashboard link: https://syzkaller.appspot.com/bug?extid=950cee6d91e62329be2c
compiler:       gcc (Debian 10.2.1-6) 10.2.1 20210110, GNU ld (GNU Binutils for Debian) 2.35.2

Unfortunately, I don't have any reproducer for this issue yet.

IMPORTANT: if you fix the issue, please add the following tag to the commit:
Reported-by: syzbot+950cee6d91e62329be2c@syzkaller.appspotmail.com

==================================================================
BUG: KASAN: use-after-free in __add_wait_queue include/linux/wait.h:177 [inline]
BUG: KASAN: use-after-free in add_wait_queue+0x1c0/0x260 kernel/sched/wait.c:24
Read of size 4 at addr ffff888077adca98 by task syz-executor.3/4398

CPU: 1 PID: 4398 Comm: syz-executor.3 Tainted: G        W         5.17.0-syzkaller-01402-g8565d64430f8 #0
Hardware name: Google Google Compute Engine/Google Compute Engine, BIOS Google 01/01/2011
Call Trace:
 <TASK>
 __dump_stack lib/dump_stack.c:88 [inline]
 dump_stack_lvl+0xcd/0x134 lib/dump_stack.c:106
 print_address_description.constprop.0.cold+0x8d/0x303 mm/kasan/report.c:255
 __kasan_report mm/kasan/report.c:442 [inline]
 kasan_report.cold+0x83/0xdf mm/kasan/report.c:459
 __add_wait_queue include/linux/wait.h:177 [inline]
 add_wait_queue+0x1c0/0x260 kernel/sched/wait.c:24
 __io_queue_proc+0x18c/0x6f0 fs/io_uring.c:6131
 poll_wait include/linux/poll.h:49 [inline]
 n_tty_poll+0x76/0x8a0 drivers/tty/n_tty.c:2322
 tty_poll+0x139/0x1b0 drivers/tty/tty_io.c:2212
 vfs_poll include/linux/poll.h:88 [inline]
 __io_arm_poll_handler+0x397/0xc00 fs/io_uring.c:6165
 io_arm_poll_handler+0x42c/0x940 fs/io_uring.c:6257
 io_queue_sqe_arm_apoll+0x6d/0x430 fs/io_uring.c:7499
 __io_queue_sqe fs/io_uring.c:7541 [inline]
 io_queue_sqe fs/io_uring.c:7568 [inline]
 io_submit_sqe fs/io_uring.c:7776 [inline]
 io_submit_sqes+0x7dda/0x9310 fs/io_uring.c:7882
 __do_sys_io_uring_enter+0x9f1/0x1520 fs/io_uring.c:10924
 do_syscall_x64 arch/x86/entry/common.c:50 [inline]
 do_syscall_64+0x35/0xb0 arch/x86/entry/common.c:80
 entry_SYSCALL_64_after_hwframe+0x44/0xae
RIP: 0033:0x7f6573120049
Code: ff ff c3 66 2e 0f 1f 84 00 00 00 00 00 0f 1f 40 00 48 89 f8 48 89 f7 48 89 d6 48 89 ca 4d 89 c2 4d 89 c8 4c 8b 4c 24 08 0f 05 <48> 3d 01 f0 ff ff 73 01 c3 48 c7 c1 b8 ff ff ff f7 d8 64 89 01 48
RSP: 002b:00007f6571a95168 EFLAGS: 00000246 ORIG_RAX: 00000000000001aa
RAX: ffffffffffffffda RBX: 00007f6573232f60 RCX: 00007f6573120049
RDX: 0000000000000000 RSI: 0000000000001261 RDI: 0000000000000004
RBP: 00007f657317a08d R08: 0000000000000000 R09: 0000000030000000
R10: 0000000000000000 R11: 0000000000000246 R12: 0000000000000000
R13: 00007ffe760b3a3f R14: 00007f6571a95300 R15: 0000000000022000
 </TASK>

Allocated by task 4386:
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

Freed by task 4061:
 kasan_save_stack+0x1e/0x40 mm/kasan/common.c:38
 kasan_set_track+0x21/0x30 mm/kasan/common.c:45
 kasan_set_free_info+0x20/0x30 mm/kasan/generic.c:370
 ____kasan_slab_free mm/kasan/common.c:366 [inline]
 ____kasan_slab_free+0xff/0x140 mm/kasan/common.c:328
 kasan_slab_free include/linux/kasan.h:215 [inline]
 __cache_free mm/slab.c:3437 [inline]
 kfree+0xf8/0x2b0 mm/slab.c:3794
 io_flush_apoll_cache fs/io_uring.c:10038 [inline]
 io_ring_ctx_free fs/io_uring.c:10064 [inline]
 io_ring_exit_work+0x7f7/0x1053 fs/io_uring.c:10244
 process_one_work+0x9ac/0x1650 kernel/workqueue.c:2307
 worker_thread+0x657/0x1110 kernel/workqueue.c:2454
 kthread+0x2e9/0x3a0 kernel/kthread.c:377
 ret_from_fork+0x1f/0x30 arch/x86/entry/entry_64.S:295

The buggy address belongs to the object at ffff888077adca80
 which belongs to the cache kmalloc-96 of size 96
The buggy address is located 24 bytes inside of
 96-byte region [ffff888077adca80, ffff888077adcae0)
The buggy address belongs to the page:
page:ffffea0001deb700 refcount:1 mapcount:0 mapping:0000000000000000 index:0x0 pfn:0x77adc
flags: 0xfff00000000200(slab|node=0|zone=1|lastcpupid=0x7ff)
raw: 00fff00000000200 ffffea00007d2088 ffffea00004b7bc8 ffff888010c40300
raw: 0000000000000000 ffff888077adc000 0000000100000020 0000000000000000
page dumped because: kasan: bad access detected
page_owner tracks the page as allocated
page last allocated via order 0, migratetype Unmovable, gfp_mask 0x342220(__GFP_HIGH|__GFP_ATOMIC|__GFP_NOWARN|__GFP_COMP|__GFP_HARDWALL|__GFP_THISNODE), pid 3842, ts 194269929651, free_ts 193491488751
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
page last free stack trace:
 reset_page_owner include/linux/page_owner.h:24 [inline]
 free_pages_prepare mm/page_alloc.c:1352 [inline]
 free_pcp_prepare+0x374/0x870 mm/page_alloc.c:1404
 free_unref_page_prepare mm/page_alloc.c:3325 [inline]
 free_unref_page+0x19/0x690 mm/page_alloc.c:3404
 slab_destroy mm/slab.c:1630 [inline]
 slabs_destroy+0x89/0xc0 mm/slab.c:1650
 cache_flusharray mm/slab.c:3410 [inline]
 ___cache_free+0x303/0x600 mm/slab.c:3472
 qlink_free mm/kasan/quarantine.c:157 [inline]
 qlist_free_all+0x50/0x1a0 mm/kasan/quarantine.c:176
 kasan_quarantine_reduce+0x180/0x200 mm/kasan/quarantine.c:283
 __kasan_slab_alloc+0x97/0xb0 mm/kasan/common.c:446
 kasan_slab_alloc include/linux/kasan.h:239 [inline]
 slab_post_alloc_hook mm/slab.h:732 [inline]
 slab_alloc_node mm/slab.c:3253 [inline]
 kmem_cache_alloc_node+0x2ea/0x590 mm/slab.c:3591
 __alloc_skb+0x215/0x340 net/core/skbuff.c:414
 alloc_skb include/linux/skbuff.h:1158 [inline]
 alloc_skb_with_frags+0x93/0x620 net/core/skbuff.c:5956
 sock_alloc_send_pskb+0x793/0x920 net/core/sock.c:2586
 unix_dgram_sendmsg+0x414/0x1a10 net/unix/af_unix.c:1896
 sock_sendmsg_nosec net/socket.c:705 [inline]
 sock_sendmsg+0xcf/0x120 net/socket.c:725
 sock_write_iter+0x289/0x3c0 net/socket.c:1061
 call_write_iter include/linux/fs.h:2074 [inline]
 new_sync_write+0x431/0x660 fs/read_write.c:503
 vfs_write+0x7cd/0xae0 fs/read_write.c:590

Memory state around the buggy address:
 ffff888077adc980: fa fb fb fb fb fb fb fb fb fb fb fb fc fc fc fc
 ffff888077adca00: 00 00 00 00 00 00 00 00 00 00 00 00 fc fc fc fc
>ffff888077adca80: fa fb fb fb fb fb fb fb fb fb fb fb fc fc fc fc
                            ^
 ffff888077adcb00: 00 00 00 00 00 00 00 00 00 00 00 00 fc fc fc fc
 ffff888077adcb80: fa fb fb fb fb fb fb fb fb fb fb fb fc fc fc fc
==================================================================


---
This report is generated by a bot. It may contain errors.
See https://goo.gl/tpsmEJ for more information about syzbot.
syzbot engineers can be reached at syzkaller@googlegroups.com.

syzbot will keep track of this issue. See:
https://goo.gl/tpsmEJ#status for how to communicate with syzbot.
