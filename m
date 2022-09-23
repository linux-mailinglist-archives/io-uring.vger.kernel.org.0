Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 4FD955E7AD1
	for <lists+io-uring@lfdr.de>; Fri, 23 Sep 2022 14:32:55 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229496AbiIWMcw (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Fri, 23 Sep 2022 08:32:52 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:36288 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231579AbiIWMcf (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Fri, 23 Sep 2022 08:32:35 -0400
Received: from mail-io1-f69.google.com (mail-io1-f69.google.com [209.85.166.69])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 4E85EE7E1B
        for <io-uring@vger.kernel.org>; Fri, 23 Sep 2022 05:31:45 -0700 (PDT)
Received: by mail-io1-f69.google.com with SMTP id v20-20020a6b5b14000000b0069fee36308eso6526927ioh.10
        for <io-uring@vger.kernel.org>; Fri, 23 Sep 2022 05:31:45 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=to:from:subject:message-id:date:mime-version:x-gm-message-state
         :from:to:cc:subject:date;
        bh=RJ+2ypyFyiGIci6u02sw7SUotntd6zhrhuqsAS9aK2E=;
        b=qX89Ohs7giyerebNOYpNmsQtUQHHaV2T7jgQ2wJaUpbez5/ap3eJRqwzxKoKtE+gqo
         cRi5cnF1/dktXUmQ6azAbu9X0Jlj4fbkSg6B7jVbJRtw78e9Z2p9kpCRN/hjBPm/h+pL
         g8cjeAo093X60xHO+qaRHpBK4jIeiEzlbOoRK5LYWibDQbJKupCFp0pYv2V+Mm98+nwZ
         BoOtQc68vfr6IB8r1SY141S5uNrqj/9ehqgFzuzZilkkY1666E9rctdFtde8E2ZHiLjj
         kV5tJ9s7ypkSMXeXD9o0H1hxAp6F/xHCbdRCpKk/RrST9eeyajdH7UVUPZ6YTxtnDUcc
         kG+Q==
X-Gm-Message-State: ACrzQf3UtJOe0whBztgullVOinPV6Jq0ymW988+jTHs3h4bO7BMoVwwC
        vHv4y6qHor7W0LDElvv1YnC/ohF7TuihC2btziiFCRv+xbzA
X-Google-Smtp-Source: AMsMyM4ca8yU2BRW9LY6cIFHMuyT405HK/55s+waoZzrUaaWvuB2SVap3X6OyQDIgZ+J2Sww/M3UO3m7DRreA01scEw1+49D+q6V
MIME-Version: 1.0
X-Received: by 2002:a6b:c341:0:b0:6a2:84ee:d289 with SMTP id
 t62-20020a6bc341000000b006a284eed289mr3851163iof.38.1663936304690; Fri, 23
 Sep 2022 05:31:44 -0700 (PDT)
Date:   Fri, 23 Sep 2022 05:31:44 -0700
X-Google-Appengine-App-Id: s~syzkaller
X-Google-Appengine-App-Id-Alias: syzkaller
Message-ID: <0000000000005ec0e805e9575c11@google.com>
Subject: [syzbot] KASAN: use-after-free Write in io_sendrecv_fail
From:   syzbot <syzbot+4c597a574a3f5a251bda@syzkaller.appspotmail.com>
To:     asml.silence@gmail.com, axboe@kernel.dk, io-uring@vger.kernel.org,
        linux-kernel@vger.kernel.org, syzkaller-bugs@googlegroups.com
Content-Type: text/plain; charset="UTF-8"
X-Spam-Status: No, score=-1.6 required=5.0 tests=BAYES_00,FROM_LOCAL_HEX,
        HEADER_FROM_DIFFERENT_DOMAINS,RCVD_IN_DNSWL_NONE,RCVD_IN_MSPIKE_H2,
        SPF_HELO_NONE,SPF_PASS autolearn=no autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org

Hello,

syzbot found the following issue on:

HEAD commit:    aaa11ce2ffc8 Add linux-next specific files for 20220923
git tree:       linux-next
console output: https://syzkaller.appspot.com/x/log.txt?x=11228b54880000
kernel config:  https://syzkaller.appspot.com/x/.config?x=186d1ff305f10294
dashboard link: https://syzkaller.appspot.com/bug?extid=4c597a574a3f5a251bda
compiler:       gcc (Debian 10.2.1-6) 10.2.1 20210110, GNU ld (GNU Binutils for Debian) 2.35.2

Unfortunately, I don't have any reproducer for this issue yet.

IMPORTANT: if you fix the issue, please add the following tag to the commit:
Reported-by: syzbot+4c597a574a3f5a251bda@syzkaller.appspotmail.com

==================================================================
BUG: KASAN: use-after-free in io_sendrecv_fail+0x3b0/0x3e0 io_uring/net.c:1221
Write of size 8 at addr ffff8880771b4080 by task syz-executor.3/30199

CPU: 1 PID: 30199 Comm: syz-executor.3 Not tainted 6.0.0-rc6-next-20220923-syzkaller #0
Hardware name: Google Google Compute Engine/Google Compute Engine, BIOS Google 08/26/2022
Call Trace:
 <TASK>
 __dump_stack lib/dump_stack.c:88 [inline]
 dump_stack_lvl+0xcd/0x134 lib/dump_stack.c:106
 print_address_description mm/kasan/report.c:284 [inline]
 print_report+0x15e/0x45d mm/kasan/report.c:395
 kasan_report+0xbb/0x1f0 mm/kasan/report.c:495
 io_sendrecv_fail+0x3b0/0x3e0 io_uring/net.c:1221
 io_req_complete_failed+0x155/0x1b0 io_uring/io_uring.c:873
 io_drain_req io_uring/io_uring.c:1648 [inline]
 io_queue_sqe_fallback.cold+0x29f/0x788 io_uring/io_uring.c:1931
 io_submit_sqe io_uring/io_uring.c:2160 [inline]
 io_submit_sqes+0x1180/0x1df0 io_uring/io_uring.c:2276
 __do_sys_io_uring_enter+0xac6/0x2410 io_uring/io_uring.c:3216
 do_syscall_x64 arch/x86/entry/common.c:50 [inline]
 do_syscall_64+0x35/0xb0 arch/x86/entry/common.c:80
 entry_SYSCALL_64_after_hwframe+0x63/0xcd
RIP: 0033:0x7f6c7e28a669
Code: ff ff c3 66 2e 0f 1f 84 00 00 00 00 00 0f 1f 40 00 48 89 f8 48 89 f7 48 89 d6 48 89 ca 4d 89 c2 4d 89 c8 4c 8b 4c 24 08 0f 05 <48> 3d 01 f0 ff ff 73 01 c3 48 c7 c1 b8 ff ff ff f7 d8 64 89 01 48
RSP: 002b:00007f6c7f49d168 EFLAGS: 00000246 ORIG_RAX: 00000000000001aa
RAX: ffffffffffffffda RBX: 00007f6c7e3abf80 RCX: 00007f6c7e28a669
RDX: 0000000000000000 RSI: 000000000000782c RDI: 0000000000000003
RBP: 00007f6c7e2e5560 R08: 0000000000000000 R09: 0000000000000000
R10: 0000000000000000 R11: 0000000000000246 R12: 0000000000000000
R13: 00007ffde2f3c81f R14: 00007f6c7f49d300 R15: 0000000000022000
 </TASK>

Allocated by task 30199:
 kasan_save_stack+0x1e/0x40 mm/kasan/common.c:45
 kasan_set_track+0x21/0x30 mm/kasan/common.c:52
 ____kasan_kmalloc mm/kasan/common.c:371 [inline]
 ____kasan_kmalloc mm/kasan/common.c:330 [inline]
 __kasan_kmalloc+0xa1/0xb0 mm/kasan/common.c:380
 kasan_kmalloc include/linux/kasan.h:211 [inline]
 __do_kmalloc_node mm/slab_common.c:934 [inline]
 __kmalloc+0x54/0xc0 mm/slab_common.c:947
 kmalloc include/linux/slab.h:564 [inline]
 io_alloc_async_data+0x9b/0x160 io_uring/io_uring.c:1590
 io_msg_alloc_async io_uring/net.c:138 [inline]
 io_msg_alloc_async_prep io_uring/net.c:147 [inline]
 io_sendmsg_prep_async+0x19b/0x3c0 io_uring/net.c:221
 io_req_prep_async+0x1d9/0x300 io_uring/io_uring.c:1613
 io_drain_req io_uring/io_uring.c:1645 [inline]
 io_queue_sqe_fallback.cold+0x281/0x788 io_uring/io_uring.c:1931
 io_submit_sqe io_uring/io_uring.c:2160 [inline]
 io_submit_sqes+0x1180/0x1df0 io_uring/io_uring.c:2276
 __do_sys_io_uring_enter+0xac6/0x2410 io_uring/io_uring.c:3216
 do_syscall_x64 arch/x86/entry/common.c:50 [inline]
 do_syscall_64+0x35/0xb0 arch/x86/entry/common.c:80
 entry_SYSCALL_64_after_hwframe+0x63/0xcd

Freed by task 30199:
 kasan_save_stack+0x1e/0x40 mm/kasan/common.c:45
 kasan_set_track+0x21/0x30 mm/kasan/common.c:52
 kasan_save_free_info+0x2a/0x40 mm/kasan/generic.c:511
 ____kasan_slab_free mm/kasan/common.c:236 [inline]
 ____kasan_slab_free+0x160/0x1c0 mm/kasan/common.c:200
 kasan_slab_free include/linux/kasan.h:177 [inline]
 slab_free_hook mm/slub.c:1669 [inline]
 slab_free_freelist_hook+0x8b/0x1c0 mm/slub.c:1695
 slab_free mm/slub.c:3599 [inline]
 __kmem_cache_free+0xab/0x3b0 mm/slub.c:3612
 io_sendrecv_fail+0x2a4/0x3e0 io_uring/net.c:1220
 io_req_complete_failed+0x155/0x1b0 io_uring/io_uring.c:873
 io_drain_req io_uring/io_uring.c:1648 [inline]
 io_queue_sqe_fallback.cold+0x29f/0x788 io_uring/io_uring.c:1931
 io_submit_sqe io_uring/io_uring.c:2160 [inline]
 io_submit_sqes+0x1180/0x1df0 io_uring/io_uring.c:2276
 __do_sys_io_uring_enter+0xac6/0x2410 io_uring/io_uring.c:3216
 do_syscall_x64 arch/x86/entry/common.c:50 [inline]
 do_syscall_64+0x35/0xb0 arch/x86/entry/common.c:80
 entry_SYSCALL_64_after_hwframe+0x63/0xcd

Last potentially related work creation:
 kasan_save_stack+0x1e/0x40 mm/kasan/common.c:45
 __kasan_record_aux_stack+0xbc/0xd0 mm/kasan/generic.c:481
 insert_work+0x48/0x350 kernel/workqueue.c:1358
 __queue_work+0x693/0x13b0 kernel/workqueue.c:1517
 call_timer_fn+0x1da/0x7c0 kernel/time/timer.c:1474
 expire_timers kernel/time/timer.c:1514 [inline]
 __run_timers.part.0+0x4a3/0xaf0 kernel/time/timer.c:1790
 __run_timers kernel/time/timer.c:1768 [inline]
 run_timer_softirq+0xb3/0x1d0 kernel/time/timer.c:1803
 __do_softirq+0x1f7/0xad8 kernel/softirq.c:571

Second to last potentially related work creation:
 kasan_save_stack+0x1e/0x40 mm/kasan/common.c:45
 __kasan_record_aux_stack+0xbc/0xd0 mm/kasan/generic.c:481
 kvfree_call_rcu+0x74/0x8f0 kernel/rcu/tree.c:3341
 io_worker_exit io_uring/io-wq.c:237 [inline]
 io_wqe_worker+0x981/0xe30 io_uring/io-wq.c:661
 ret_from_fork+0x1f/0x30 arch/x86/entry/entry_64.S:306

The buggy address belongs to the object at ffff8880771b4000
 which belongs to the cache kmalloc-512 of size 512
The buggy address is located 128 bytes inside of
 512-byte region [ffff8880771b4000, ffff8880771b4200)

The buggy address belongs to the physical page:
page:ffffea0001dc6d00 refcount:1 mapcount:0 mapping:0000000000000000 index:0xffffea0000726900 pfn:0x771b4
head:ffffea0001dc6d00 order:2 compound_mapcount:0 compound_pincount:0
flags: 0xfff00000010200(slab|head|node=0|zone=1|lastcpupid=0x7ff)
raw: 00fff00000010200 ffff888011841c80 dead000080100010 0000000000000000
raw: ffffea0000726900 dead000000000002 00000001ffffffff 0000000000000000
page dumped because: kasan: bad access detected
page_owner tracks the page as allocated
page last allocated via order 2, migratetype Unmovable, gfp_mask 0xd2820(GFP_ATOMIC|__GFP_NOWARN|__GFP_NORETRY|__GFP_COMP|__GFP_NOMEMALLOC), pid 0, tgid 0 (swapper/0), ts 74508550254, free_ts 69376410492
 prep_new_page mm/page_alloc.c:2538 [inline]
 get_page_from_freelist+0x1092/0x2d20 mm/page_alloc.c:4287
 __alloc_pages+0x1c7/0x5a0 mm/page_alloc.c:5546
 alloc_pages+0x1a6/0x270 mm/mempolicy.c:2280
 alloc_slab_page mm/slub.c:1739 [inline]
 allocate_slab+0x213/0x300 mm/slub.c:1884
 new_slab mm/slub.c:1937 [inline]
 ___slab_alloc+0xac1/0x1430 mm/slub.c:3119
 __slab_alloc.constprop.0+0x4d/0xa0 mm/slub.c:3217
 slab_alloc_node mm/slub.c:3302 [inline]
 __kmem_cache_alloc_node+0x18a/0x3d0 mm/slub.c:3375
 __do_kmalloc_node mm/slab_common.c:933 [inline]
 __kmalloc_node_track_caller+0x45/0xc0 mm/slab_common.c:954
 kmalloc_reserve net/core/skbuff.c:362 [inline]
 __alloc_skb+0xd9/0x2f0 net/core/skbuff.c:434
 __napi_alloc_skb+0x93/0x340 net/core/skbuff.c:575
 napi_alloc_skb include/linux/skbuff.h:3208 [inline]
 page_to_skb+0x17d/0xc80 drivers/net/virtio_net.c:496
 receive_mergeable drivers/net/virtio_net.c:1119 [inline]
 receive_buf+0xe0a/0x5560 drivers/net/virtio_net.c:1258
 virtnet_receive drivers/net/virtio_net.c:1553 [inline]
 virtnet_poll+0x708/0x1310 drivers/net/virtio_net.c:1671
 __napi_poll+0xb8/0x770 net/core/dev.c:6511
 napi_poll net/core/dev.c:6578 [inline]
 net_rx_action+0x9fc/0xde0 net/core/dev.c:6689
 __do_softirq+0x1f7/0xad8 kernel/softirq.c:571
page last free stack trace:
 reset_page_owner include/linux/page_owner.h:24 [inline]
 free_pages_prepare mm/page_alloc.c:1458 [inline]
 free_pcp_prepare+0x65c/0xd90 mm/page_alloc.c:1508
 free_unref_page_prepare mm/page_alloc.c:3386 [inline]
 free_unref_page+0x19/0x4d0 mm/page_alloc.c:3482
 __unfreeze_partials+0x17c/0x1a0 mm/slub.c:2532
 qlink_free mm/kasan/quarantine.c:168 [inline]
 qlist_free_all+0x6a/0x170 mm/kasan/quarantine.c:187
 kasan_quarantine_reduce+0x180/0x200 mm/kasan/quarantine.c:294
 __kasan_slab_alloc+0x62/0x80 mm/kasan/common.c:302
 kasan_slab_alloc include/linux/kasan.h:201 [inline]
 slab_post_alloc_hook mm/slab.h:754 [inline]
 slab_alloc_node mm/slub.c:3336 [inline]
 kmem_cache_alloc_node+0x2ff/0x400 mm/slub.c:3381
 __alloc_skb+0x210/0x2f0 net/core/skbuff.c:422
 alloc_skb_fclone include/linux/skbuff.h:1308 [inline]
 tcp_stream_alloc_skb+0x38/0x580 net/ipv4/tcp.c:861
 tcp_sendmsg_locked+0xc36/0x2f90 net/ipv4/tcp.c:1325
 tcp_sendmsg+0x2b/0x40 net/ipv4/tcp.c:1483
 inet_sendmsg+0x99/0xe0 net/ipv4/af_inet.c:819
 sock_sendmsg_nosec net/socket.c:714 [inline]
 sock_sendmsg+0xcf/0x120 net/socket.c:734
 sock_write_iter+0x291/0x3d0 net/socket.c:1108
 call_write_iter include/linux/fs.h:2190 [inline]
 new_sync_write fs/read_write.c:491 [inline]
 vfs_write+0x9e9/0xdd0 fs/read_write.c:578
 ksys_write+0x1e8/0x250 fs/read_write.c:631

Memory state around the buggy address:
 ffff8880771b3f80: fc fc fc fc fc fc fc fc fc fc fc fc fc fc fc fc
 ffff8880771b4000: fa fb fb fb fb fb fb fb fb fb fb fb fb fb fb fb
>ffff8880771b4080: fb fb fb fb fb fb fb fb fb fb fb fb fb fb fb fb
                   ^
 ffff8880771b4100: fb fb fb fb fb fb fb fb fb fb fb fb fb fb fb fb
 ffff8880771b4180: fb fb fb fb fb fb fb fb fb fb fb fb fb fb fb fb
==================================================================


---
This report is generated by a bot. It may contain errors.
See https://goo.gl/tpsmEJ for more information about syzbot.
syzbot engineers can be reached at syzkaller@googlegroups.com.

syzbot will keep track of this issue. See:
https://goo.gl/tpsmEJ#status for how to communicate with syzbot.
