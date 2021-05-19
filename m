Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id D5A14388757
	for <lists+io-uring@lfdr.de>; Wed, 19 May 2021 08:08:31 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232965AbhESGJn (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Wed, 19 May 2021 02:09:43 -0400
Received: from mail-il1-f198.google.com ([209.85.166.198]:33732 "EHLO
        mail-il1-f198.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232339AbhESGJn (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Wed, 19 May 2021 02:09:43 -0400
Received: by mail-il1-f198.google.com with SMTP id y10-20020a92c74a0000b02901bcf3518959so1722915ilp.0
        for <io-uring@vger.kernel.org>; Tue, 18 May 2021 23:08:24 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:date:message-id:subject:from:to;
        bh=B8vnO1NvvPdSl3xTLiqlOum2woTwSZFNkl28Ve0wjNw=;
        b=QRunJj1xuisr/4JQwJd7yvuxMs3NVzPgHigRFT9LMGzNqN8lY+C/P37oDMiVI1zogt
         C0vW56EO6HtqYXMk2tWoHVFTaq4mmNzd7gR2azi0rVa2slqHjX3rKcdZqwqtI+5Aj9CI
         IVkBPlaB3ifr880kSJMZQaFzgf/YzaWajLbbwjfCEL4WGjws53zpKy6haLk8TAettHYc
         8SwjQdBGppzwz9g6kbOSTo5BR5bEnDzoV8q/Jxyydz2zFrhzXhW6iI1fybu1ikrJVJ92
         WVhBirUbUkkeBclrUlw0tW/n5tIQ17NVxWowVTtZJ7LGSUHZKxLcNU7i4QV6KCYvYAl0
         cJyg==
X-Gm-Message-State: AOAM530rHzdjOukYXmRlGvtyrukUrDIqmBO0YQkVRSLpzAQLjnpITSXU
        EazOi5+ri4Qm/ch1TH9w5jRMRgrmdajqe1/qJ2oGRAQGOnUi
X-Google-Smtp-Source: ABdhPJyWdLOpB0KA63XtIBnJVebJAshUSLElHvhWJWDT2YWOjf9sfNn3Mc+hC+HAtc9SeUsWWrHlAuXqArSmr+Z17XRlpSjFWlfl
MIME-Version: 1.0
X-Received: by 2002:a05:6e02:190f:: with SMTP id w15mr9011931ilu.13.1621404504169;
 Tue, 18 May 2021 23:08:24 -0700 (PDT)
Date:   Tue, 18 May 2021 23:08:24 -0700
X-Google-Appengine-App-Id: s~syzkaller
X-Google-Appengine-App-Id-Alias: syzkaller
Message-ID: <0000000000008224bf05c2a8a78b@google.com>
Subject: [syzbot] KASAN: use-after-free Read in io_worker_handle_work
From:   syzbot <syzbot+6cb11ade52aa17095297@syzkaller.appspotmail.com>
To:     asml.silence@gmail.com, axboe@kernel.dk, io-uring@vger.kernel.org,
        linux-kernel@vger.kernel.org, syzkaller-bugs@googlegroups.com
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org

Hello,

syzbot found the following issue on:

HEAD commit:    8ac91e6c Merge tag 'for-5.13-rc2-tag' of git://git.kernel...
git tree:       upstream
console output: https://syzkaller.appspot.com/x/log.txt?x=114c7f0dd00000
kernel config:  https://syzkaller.appspot.com/x/.config?x=4df7270840595081
dashboard link: https://syzkaller.appspot.com/bug?extid=6cb11ade52aa17095297

Unfortunately, I don't have any reproducer for this issue yet.

IMPORTANT: if you fix the issue, please add the following tag to the commit:
Reported-by: syzbot+6cb11ade52aa17095297@syzkaller.appspotmail.com

==================================================================
BUG: KASAN: use-after-free in __wake_up_common+0x637/0x650 kernel/sched/wait.c:101
Read of size 8 at addr ffff8880304250d8 by task iou-wrk-28796/28802

CPU: 1 PID: 28802 Comm: iou-wrk-28796 Not tainted 5.13.0-rc2-syzkaller #0
Hardware name: Google Google Compute Engine/Google Compute Engine, BIOS Google 01/01/2011
Call Trace:
 __dump_stack lib/dump_stack.c:79 [inline]
 dump_stack+0x141/0x1d7 lib/dump_stack.c:120
 print_address_description.constprop.0.cold+0x5b/0x2c6 mm/kasan/report.c:233
 __kasan_report mm/kasan/report.c:419 [inline]
 kasan_report.cold+0x7c/0xd8 mm/kasan/report.c:436
 __wake_up_common+0x637/0x650 kernel/sched/wait.c:101
 __wake_up_common_lock+0xd0/0x130 kernel/sched/wait.c:138
 io_worker_handle_work+0x9dd/0x1790 fs/io-wq.c:512
 io_wqe_worker+0xb2a/0xd40 fs/io-wq.c:571
 ret_from_fork+0x1f/0x30 arch/x86/entry/entry_64.S:294

Allocated by task 28798:
 kasan_save_stack+0x1b/0x40 mm/kasan/common.c:38
 kasan_set_track mm/kasan/common.c:46 [inline]
 set_alloc_info mm/kasan/common.c:428 [inline]
 ____kasan_kmalloc mm/kasan/common.c:507 [inline]
 ____kasan_kmalloc mm/kasan/common.c:466 [inline]
 __kasan_kmalloc+0x98/0xc0 mm/kasan/common.c:516
 kasan_kmalloc include/linux/kasan.h:246 [inline]
 kmem_cache_alloc_node_trace+0x222/0x5b0 mm/slab.c:3619
 kmalloc_node include/linux/slab.h:574 [inline]
 kzalloc_node include/linux/slab.h:697 [inline]
 io_wq_create+0x3c4/0xdd0 fs/io-wq.c:934
 io_init_wq_offload fs/io_uring.c:7881 [inline]
 io_uring_alloc_task_context+0x1bf/0x6b0 fs/io_uring.c:7900
 __io_uring_add_task_file+0x29a/0x3c0 fs/io_uring.c:8971
 io_uring_add_task_file fs/io_uring.c:9007 [inline]
 io_uring_install_fd fs/io_uring.c:9527 [inline]
 io_uring_create fs/io_uring.c:9679 [inline]
 io_uring_setup+0x209a/0x2bd0 fs/io_uring.c:9716
 do_syscall_64+0x3a/0xb0 arch/x86/entry/common.c:47
 entry_SYSCALL_64_after_hwframe+0x44/0xae

Freed by task 28798:
 kasan_save_stack+0x1b/0x40 mm/kasan/common.c:38
 kasan_set_track+0x1c/0x30 mm/kasan/common.c:46
 kasan_set_free_info+0x20/0x30 mm/kasan/generic.c:357
 ____kasan_slab_free mm/kasan/common.c:360 [inline]
 ____kasan_slab_free mm/kasan/common.c:325 [inline]
 __kasan_slab_free+0xcd/0x100 mm/kasan/common.c:368
 kasan_slab_free include/linux/kasan.h:212 [inline]
 __cache_free mm/slab.c:3445 [inline]
 kfree+0x106/0x2c0 mm/slab.c:3803
 io_wq_destroy+0x182/0x380 fs/io-wq.c:1032
 io_wq_put fs/io-wq.c:1042 [inline]
 io_wq_put_and_exit+0x7a/0xa0 fs/io-wq.c:1048
 io_uring_clean_tctx fs/io_uring.c:9044 [inline]
 __io_uring_cancel+0x428/0x530 fs/io_uring.c:9136
 io_uring_files_cancel include/linux/io_uring.h:16 [inline]
 do_exit+0x299/0x2a60 kernel/exit.c:781
 do_group_exit+0x125/0x310 kernel/exit.c:923
 get_signal+0x47f/0x2150 kernel/signal.c:2818
 arch_do_signal_or_restart+0x2a8/0x1eb0 arch/x86/kernel/signal.c:789
 handle_signal_work kernel/entry/common.c:147 [inline]
 exit_to_user_mode_loop kernel/entry/common.c:171 [inline]
 exit_to_user_mode_prepare+0x171/0x280 kernel/entry/common.c:208
 __syscall_exit_to_user_mode_work kernel/entry/common.c:290 [inline]
 syscall_exit_to_user_mode+0x19/0x60 kernel/entry/common.c:301
 do_syscall_64+0x47/0xb0 arch/x86/entry/common.c:57
 entry_SYSCALL_64_after_hwframe+0x44/0xae

Last potentially related work creation:
 kasan_save_stack+0x1b/0x40 mm/kasan/common.c:38
 kasan_record_aux_stack+0xa4/0xd0 mm/kasan/generic.c:345
 kvfree_call_rcu+0x74/0x8c0 kernel/rcu/tree.c:3597
 batadv_hardif_release net/batman-adv/hard-interface.c:55 [inline]
 kref_put include/linux/kref.h:65 [inline]
 batadv_hardif_put net/batman-adv/hard-interface.h:93 [inline]
 batadv_hard_if_event+0xb27/0x15b0 net/batman-adv/hard-interface.c:1048
 notifier_call_chain+0xb5/0x200 kernel/notifier.c:83
 call_netdevice_notifiers_info+0xb5/0x130 net/core/dev.c:2121
 call_netdevice_notifiers_extack net/core/dev.c:2133 [inline]
 call_netdevice_notifiers net/core/dev.c:2147 [inline]
 unregister_netdevice_many+0x951/0x1790 net/core/dev.c:11006
 unregister_netdevice_queue+0x2dd/0x3c0 net/core/dev.c:10940
 unregister_netdevice include/linux/netdevice.h:2969 [inline]
 macsec_newlink+0x844/0x17b0 drivers/net/macsec.c:4100
 __rtnl_newlink+0x1062/0x1710 net/core/rtnetlink.c:3452
 rtnl_newlink+0x64/0xa0 net/core/rtnetlink.c:3500
 rtnetlink_rcv_msg+0x44e/0xad0 net/core/rtnetlink.c:5562
 netlink_rcv_skb+0x153/0x420 net/netlink/af_netlink.c:2502
 netlink_unicast_kernel net/netlink/af_netlink.c:1312 [inline]
 netlink_unicast+0x533/0x7d0 net/netlink/af_netlink.c:1338
 netlink_sendmsg+0x856/0xd90 net/netlink/af_netlink.c:1927
 sock_sendmsg_nosec net/socket.c:654 [inline]
 sock_sendmsg+0xcf/0x120 net/socket.c:674
 ____sys_sendmsg+0x6e8/0x810 net/socket.c:2350
 ___sys_sendmsg+0xf3/0x170 net/socket.c:2404
 __sys_sendmsg+0xe5/0x1b0 net/socket.c:2433
 do_syscall_64+0x3a/0xb0 arch/x86/entry/common.c:47
 entry_SYSCALL_64_after_hwframe+0x44/0xae

Second to last potentially related work creation:
 kasan_save_stack+0x1b/0x40 mm/kasan/common.c:38
 kasan_record_aux_stack+0xa4/0xd0 mm/kasan/generic.c:345
 kvfree_call_rcu+0x74/0x8c0 kernel/rcu/tree.c:3597
 neigh_destroy+0x40f/0x610 net/core/neighbour.c:862
 neigh_release include/net/neighbour.h:425 [inline]
 neigh_cleanup_and_release+0x1fd/0x340 net/core/neighbour.c:103
 neigh_flush_dev+0x511/0x820 net/core/neighbour.c:340
 neigh_changeaddr+0x2c/0x40 net/core/neighbour.c:348
 ndisc_netdev_event+0xa6/0x360 net/ipv6/ndisc.c:1795
 notifier_call_chain+0xb5/0x200 kernel/notifier.c:83
 call_netdevice_notifiers_info+0xb5/0x130 net/core/dev.c:2121
 call_netdevice_notifiers_extack net/core/dev.c:2133 [inline]
 call_netdevice_notifiers net/core/dev.c:2147 [inline]
 dev_set_mac_address+0x2d5/0x3e0 net/core/dev.c:9002
 dev_set_mac_address_user+0x2d/0x50 net/core/dev.c:9016
 do_setlink+0x1705/0x3af0 net/core/rtnetlink.c:2672
 __rtnl_newlink+0xdcf/0x1710 net/core/rtnetlink.c:3385
 rtnl_newlink+0x64/0xa0 net/core/rtnetlink.c:3500
 rtnetlink_rcv_msg+0x44e/0xad0 net/core/rtnetlink.c:5562
 netlink_rcv_skb+0x153/0x420 net/netlink/af_netlink.c:2502
 netlink_unicast_kernel net/netlink/af_netlink.c:1312 [inline]
 netlink_unicast+0x533/0x7d0 net/netlink/af_netlink.c:1338
 netlink_sendmsg+0x856/0xd90 net/netlink/af_netlink.c:1927
 sock_sendmsg_nosec net/socket.c:654 [inline]
 sock_sendmsg+0xcf/0x120 net/socket.c:674
 __sys_sendto+0x21c/0x320 net/socket.c:1977
 __do_sys_sendto net/socket.c:1989 [inline]
 __se_sys_sendto net/socket.c:1985 [inline]
 __x64_sys_sendto+0xdd/0x1b0 net/socket.c:1985
 do_syscall_64+0x3a/0xb0 arch/x86/entry/common.c:47
 entry_SYSCALL_64_after_hwframe+0x44/0xae

The buggy address belongs to the object at ffff888030425000
 which belongs to the cache kmalloc-1k of size 1024
The buggy address is located 216 bytes inside of
 1024-byte region [ffff888030425000, ffff888030425400)
The buggy address belongs to the page:
page:ffffea0000c10940 refcount:1 mapcount:0 mapping:0000000000000000 index:0x0 pfn:0x30425
flags: 0xfff00000000200(slab|node=0|zone=1|lastcpupid=0x7ff)
raw: 00fff00000000200 ffffea000086fac8 ffffea0000aa62c8 ffff888011040700
raw: 0000000000000000 ffff888030425000 0000000100000002 0000000000000000
page dumped because: kasan: bad access detected
page_owner tracks the page as allocated
page last allocated via order 0, migratetype Unmovable, gfp_mask 0x2c2220(__GFP_HIGH|__GFP_ATOMIC|__GFP_NOWARN|__GFP_COMP|__GFP_NOMEMALLOC|__GFP_THISNODE), pid 8450, ts 105387307626, free_ts 105194418369
 prep_new_page mm/page_alloc.c:2358 [inline]
 get_page_from_freelist+0x1033/0x2b60 mm/page_alloc.c:3994
 __alloc_pages+0x1b2/0x500 mm/page_alloc.c:5200
 __alloc_pages_node include/linux/gfp.h:549 [inline]
 kmem_getpages mm/slab.c:1377 [inline]
 cache_grow_begin+0x75/0x460 mm/slab.c:2593
 cache_alloc_refill+0x27f/0x380 mm/slab.c:2965
 ____cache_alloc mm/slab.c:3048 [inline]
 ____cache_alloc mm/slab.c:3031 [inline]
 slab_alloc_node mm/slab.c:3249 [inline]
 kmem_cache_alloc_node_trace+0x4da/0x5b0 mm/slab.c:3617
 __do_kmalloc_node mm/slab.c:3639 [inline]
 __kmalloc_node_track_caller+0x38/0x60 mm/slab.c:3654
 kmalloc_reserve net/core/skbuff.c:354 [inline]
 __alloc_skb+0xde/0x340 net/core/skbuff.c:425
 alloc_skb include/linux/skbuff.h:1107 [inline]
 __tcp_send_ack.part.0+0x67/0x7a0 net/ipv4/tcp_output.c:3944
 __tcp_send_ack net/ipv4/tcp_output.c:3976 [inline]
 tcp_send_ack+0x7d/0xa0 net/ipv4/tcp_output.c:3976
 tcp_cleanup_rbuf+0x46c/0x5b0 net/ipv4/tcp.c:1598
 tcp_recvmsg_locked+0x7aa/0x22f0 net/ipv4/tcp.c:2521
 tcp_recvmsg+0x134/0x550 net/ipv4/tcp.c:2551
 inet_recvmsg+0x11b/0x5d0 net/ipv4/af_inet.c:852
 sock_recvmsg_nosec net/socket.c:888 [inline]
 sock_recvmsg net/socket.c:906 [inline]
 sock_recvmsg net/socket.c:902 [inline]
 sock_read_iter+0x33c/0x470 net/socket.c:979
 call_read_iter include/linux/fs.h:2108 [inline]
 new_sync_read+0x5b7/0x6e0 fs/read_write.c:415
 vfs_read+0x35c/0x570 fs/read_write.c:496
page last free stack trace:
 reset_page_owner include/linux/page_owner.h:24 [inline]
 free_pages_prepare mm/page_alloc.c:1298 [inline]
 __free_pages_ok+0x476/0xce0 mm/page_alloc.c:1572
 slab_destroy mm/slab.c:1627 [inline]
 slabs_destroy+0x89/0xc0 mm/slab.c:1647
 cache_flusharray mm/slab.c:3418 [inline]
 ___cache_free+0x58b/0x7a0 mm/slab.c:3480
 qlink_free mm/kasan/quarantine.c:146 [inline]
 qlist_free_all+0x4e/0x110 mm/kasan/quarantine.c:165
 kasan_quarantine_reduce+0x180/0x200 mm/kasan/quarantine.c:272
 __kasan_slab_alloc+0x8b/0xa0 mm/kasan/common.c:438
 kasan_slab_alloc include/linux/kasan.h:236 [inline]
 slab_post_alloc_hook mm/slab.h:524 [inline]
 slab_alloc mm/slab.c:3323 [inline]
 __do_kmalloc mm/slab.c:3700 [inline]
 __kmalloc+0x29a/0x4d0 mm/slab.c:3711
 kmalloc include/linux/slab.h:561 [inline]
 kzalloc include/linux/slab.h:686 [inline]
 task_numa_fault+0x1674/0x3430 kernel/sched/fair.c:2655
 do_numa_page mm/memory.c:4217 [inline]
 handle_pte_fault mm/memory.c:4374 [inline]
 __handle_mm_fault+0x2ab3/0x52c0 mm/memory.c:4502
 handle_mm_fault+0x1bc/0x7e0 mm/memory.c:4600
 do_user_addr_fault+0x483/0x1210 arch/x86/mm/fault.c:1390
 handle_page_fault arch/x86/mm/fault.c:1475 [inline]
 exc_page_fault+0x9e/0x180 arch/x86/mm/fault.c:1531
 asm_exc_page_fault+0x1e/0x30 arch/x86/include/asm/idtentry.h:577

Memory state around the buggy address:
 ffff888030424f80: 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00
 ffff888030425000: fa fb fb fb fb fb fb fb fb fb fb fb fb fb fb fb
>ffff888030425080: fb fb fb fb fb fb fb fb fb fb fb fb fb fb fb fb
                                                    ^
 ffff888030425100: fb fb fb fb fb fb fb fb fb fb fb fb fb fb fb fb
 ffff888030425180: fb fb fb fb fb fb fb fb fb fb fb fb fb fb fb fb
==================================================================


---
This report is generated by a bot. It may contain errors.
See https://goo.gl/tpsmEJ for more information about syzbot.
syzbot engineers can be reached at syzkaller@googlegroups.com.

syzbot will keep track of this issue. See:
https://goo.gl/tpsmEJ#status for how to communicate with syzbot.
