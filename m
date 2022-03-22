Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 4A3BF4E3B36
	for <lists+io-uring@lfdr.de>; Tue, 22 Mar 2022 09:52:39 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231878AbiCVIxu (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Tue, 22 Mar 2022 04:53:50 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:38886 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231758AbiCVIxs (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Tue, 22 Mar 2022 04:53:48 -0400
Received: from mail-il1-f197.google.com (mail-il1-f197.google.com [209.85.166.197])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id C798B7DAB5
        for <io-uring@vger.kernel.org>; Tue, 22 Mar 2022 01:52:20 -0700 (PDT)
Received: by mail-il1-f197.google.com with SMTP id g5-20020a92dd85000000b002c79aa519f4so8808850iln.10
        for <io-uring@vger.kernel.org>; Tue, 22 Mar 2022 01:52:20 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:mime-version:date:message-id:subject:from:to;
        bh=nbwo8CwNqspTeO0QA8C8Mwa8yKVKWXRCp/zY1zVZzEE=;
        b=TOlUuN+B1gJnwl5go6L3gJWBwRyEmdpZswMVTRPKCLTFWzLR/bDVRuWn1v7uxzLYc+
         grs8oBot0HKOkRqKH6sgUk6pf72gNSsAutvgOjgEHmLakoOPP/VXcPG0PWiQYabY0J4R
         ZjoQ6BnxPRIiVEBjC+YhQeFflFBOmHxX62to9bVl4eqtHvovLhyE9z39piw1q6+0SLIj
         3RnWxu5/BRvYMddwRZqaY9sip4hJmH8vBMQzQM8p8wurFL3zRuWz9xdsU2r5oHXvUduP
         Ko8p3MKK9sa4p8hR803RQZ3xUnRn5JBkGcxPayMSR0HXst57pumufvOK2t/x2iqAe3sB
         izww==
X-Gm-Message-State: AOAM5337hzmYINHIE4zwi+fM5GILLeg7lu+iKjbJGPskdp9ZI+3F9C6R
        Q4ZlUReT+vBd8VqYYT8GkDgZeM5jjQH7+Kk5SIvBCwSOHA/H
X-Google-Smtp-Source: ABdhPJz5/W/opXU+EpZMsJccGV1qtUCAPLfb5bPvgAHSTR4yII5iwJ/BFnavJTnp0kTQ0DZOiKTorGfpIh/DB+dij8pCyNiexxGX
MIME-Version: 1.0
X-Received: by 2002:a05:6638:4187:b0:319:dc78:e47c with SMTP id
 az7-20020a056638418700b00319dc78e47cmr12915510jab.315.1647939140136; Tue, 22
 Mar 2022 01:52:20 -0700 (PDT)
Date:   Tue, 22 Mar 2022 01:52:20 -0700
X-Google-Appengine-App-Id: s~syzkaller
X-Google-Appengine-App-Id-Alias: syzkaller
Message-ID: <0000000000000f361d05dacabb09@google.com>
Subject: [syzbot] KASAN: use-after-free Read in io_poll_remove_entries
From:   syzbot <syzbot+cd301bb6523ea8cc8ca2@syzkaller.appspotmail.com>
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
console output: https://syzkaller.appspot.com/x/log.txt?x=15406ddb700000
kernel config:  https://syzkaller.appspot.com/x/.config?x=89040bbe61f60a52
dashboard link: https://syzkaller.appspot.com/bug?extid=cd301bb6523ea8cc8ca2
compiler:       gcc (Debian 10.2.1-6) 10.2.1 20210110, GNU ld (GNU Binutils for Debian) 2.35.2

Unfortunately, I don't have any reproducer for this issue yet.

IMPORTANT: if you fix the issue, please add the following tag to the commit:
Reported-by: syzbot+cd301bb6523ea8cc8ca2@syzkaller.appspotmail.com

==================================================================
BUG: KASAN: use-after-free in __list_del_entry_valid+0xe0/0xf0 lib/list_debug.c:51
Read of size 8 at addr ffff8880700bed30 by task syz-executor.2/5247

CPU: 0 PID: 5247 Comm: syz-executor.2 Tainted: G        W         5.17.0-syzkaller-01402-g8565d64430f8 #0
Hardware name: Google Google Compute Engine/Google Compute Engine, BIOS Google 01/01/2011
Call Trace:
 <TASK>
 __dump_stack lib/dump_stack.c:88 [inline]
 dump_stack_lvl+0xcd/0x134 lib/dump_stack.c:106
 print_address_description.constprop.0.cold+0x8d/0x303 mm/kasan/report.c:255
 __kasan_report mm/kasan/report.c:442 [inline]
 kasan_report.cold+0x83/0xdf mm/kasan/report.c:459
 __list_del_entry_valid+0xe0/0xf0 lib/list_debug.c:51
 __list_del_entry include/linux/list.h:134 [inline]
 list_del_init include/linux/list.h:206 [inline]
 io_poll_remove_entry fs/io_uring.c:5863 [inline]
 io_poll_remove_entries.part.0+0x167/0x7e0 fs/io_uring.c:5895
 io_poll_remove_entries fs/io_uring.c:5875 [inline]
 io_apoll_task_func+0xba/0x230 fs/io_uring.c:5995
 handle_tw_list fs/io_uring.c:2480 [inline]
 tctx_task_work+0x1a2/0x1380 fs/io_uring.c:2514
 task_work_run+0xdd/0x1a0 kernel/task_work.c:164
 tracehook_notify_signal include/linux/tracehook.h:213 [inline]
 handle_signal_work kernel/entry/common.c:146 [inline]
 exit_to_user_mode_loop kernel/entry/common.c:186 [inline]
 exit_to_user_mode_prepare+0x256/0x290 kernel/entry/common.c:221
 __syscall_exit_to_user_mode_work kernel/entry/common.c:303 [inline]
 syscall_exit_to_user_mode+0x19/0x60 kernel/entry/common.c:314
 do_syscall_64+0x42/0xb0 arch/x86/entry/common.c:86
 entry_SYSCALL_64_after_hwframe+0x44/0xae
RIP: 0033:0x7f2400e65049
Code: ff ff c3 66 2e 0f 1f 84 00 00 00 00 00 0f 1f 40 00 48 89 f8 48 89 f7 48 89 d6 48 89 ca 4d 89 c2 4d 89 c8 4c 8b 4c 24 08 0f 05 <48> 3d 01 f0 ff ff 73 01 c3 48 c7 c1 b8 ff ff ff f7 d8 64 89 01 48
RSP: 002b:00007f23ff7da168 EFLAGS: 00000246 ORIG_RAX: 00000000000001aa
RAX: 0000000000001261 RBX: 00007f2400f77f60 RCX: 00007f2400e65049
RDX: 0000000000000000 RSI: 0000000000001261 RDI: 0000000000000004
RBP: 00007f2400ebf08d R08: 0000000000000000 R09: 0000000030000000
R10: 0000000000000000 R11: 0000000000000246 R12: 0000000000000000
R13: 00007ffd5a0e325f R14: 00007f23ff7da300 R15: 0000000000022000
 </TASK>

Allocated by task 5243:
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

Freed by task 5258:
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
 __io_free_req+0xc8/0x3c5 fs/io_uring.c:2280
 io_put_req_find_next fs/io_uring.c:2717 [inline]
 io_wq_free_work.cold+0x10/0x69 fs/io_uring.c:7301
 io_worker_handle_work+0xb3e/0x1b30 fs/io-wq.c:598
 io_wqe_worker+0x606/0xd40 fs/io-wq.c:642
 ret_from_fork+0x1f/0x30 arch/x86/entry/entry_64.S:295

Last potentially related work creation:
 kasan_save_stack+0x1e/0x40 mm/kasan/common.c:38
 __kasan_record_aux_stack+0x7e/0x90 mm/kasan/generic.c:348
 kvfree_call_rcu+0x74/0x990 kernel/rcu/tree.c:3595
 cfg80211_update_known_bss+0x833/0xa60 net/wireless/scan.c:1661
 cfg80211_bss_update+0xef/0x2070 net/wireless/scan.c:1708
 cfg80211_inform_single_bss_frame_data+0x72b/0xf30 net/wireless/scan.c:2464
 cfg80211_inform_bss_frame_data+0xa7/0xb50 net/wireless/scan.c:2497
 ieee80211_bss_info_update+0x35b/0xb00 net/mac80211/scan.c:190
 ieee80211_rx_bss_info net/mac80211/ibss.c:1119 [inline]
 ieee80211_rx_mgmt_probe_beacon net/mac80211/ibss.c:1610 [inline]
 ieee80211_ibss_rx_queued_mgmt+0x19cf/0x3150 net/mac80211/ibss.c:1639
 ieee80211_iface_process_skb net/mac80211/iface.c:1527 [inline]
 ieee80211_iface_work+0xa69/0xd00 net/mac80211/iface.c:1581
 process_one_work+0x9ac/0x1650 kernel/workqueue.c:2307
 worker_thread+0x657/0x1110 kernel/workqueue.c:2454
 kthread+0x2e9/0x3a0 kernel/kthread.c:377
 ret_from_fork+0x1f/0x30 arch/x86/entry/entry_64.S:295

The buggy address belongs to the object at ffff8880700bed00
 which belongs to the cache kmalloc-96 of size 96
The buggy address is located 48 bytes inside of
 96-byte region [ffff8880700bed00, ffff8880700bed60)
The buggy address belongs to the page:
page:ffffea0001c02f80 refcount:1 mapcount:0 mapping:0000000000000000 index:0x0 pfn:0x700be
flags: 0xfff00000000200(slab|node=0|zone=1|lastcpupid=0x7ff)
raw: 00fff00000000200 ffffea0000736b88 ffffea0001eb7448 ffff888010c40300
raw: 0000000000000000 ffff8880700be000 0000000100000020 0000000000000000
page dumped because: kasan: bad access detected
page_owner tracks the page as allocated
page last allocated via order 0, migratetype Unmovable, gfp_mask 0x342220(__GFP_HIGH|__GFP_ATOMIC|__GFP_NOWARN|__GFP_COMP|__GFP_HARDWALL|__GFP_THISNODE), pid 0, ts 118360599722, free_ts 118282284710
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
 dst_cow_metrics_generic+0x48/0x1e0 net/core/dst.c:199
 dst_metrics_write_ptr include/net/dst.h:119 [inline]
 dst_metric_set include/net/dst.h:180 [inline]
 icmp6_dst_alloc+0x4fb/0x6c0 net/ipv6/route.c:3284
 ndisc_send_skb+0x1146/0x17f0 net/ipv6/ndisc.c:488
 ndisc_send_rs+0x12e/0x6f0 net/ipv6/ndisc.c:702
 addrconf_rs_timer+0x3f2/0x820 net/ipv6/addrconf.c:3915
 call_timer_fn+0x1a5/0x6b0 kernel/time/timer.c:1421
 expire_timers kernel/time/timer.c:1466 [inline]
 __run_timers.part.0+0x67c/0xa30 kernel/time/timer.c:1734
 __run_timers kernel/time/timer.c:1715 [inline]
 run_timer_softirq+0xb3/0x1d0 kernel/time/timer.c:1747
 __do_softirq+0x29b/0x9c2 kernel/softirq.c:558
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
 mld_newpack.isra.0+0x1be/0x750 net/ipv6/mcast.c:1746
 add_grhead+0x283/0x360 net/ipv6/mcast.c:1849
 add_grec+0x106a/0x1530 net/ipv6/mcast.c:1987
 mld_send_initial_cr.part.0+0xf6/0x230 net/ipv6/mcast.c:2234
 mld_send_initial_cr net/ipv6/mcast.c:1232 [inline]
 mld_dad_work+0x1d3/0x690 net/ipv6/mcast.c:2260

Memory state around the buggy address:
 ffff8880700bec00: fb fb fb fb fb fb fb fb fb fb fb fb fc fc fc fc
 ffff8880700bec80: fa fb fb fb fb fb fb fb fb fb fb fb fc fc fc fc
>ffff8880700bed00: fa fb fb fb fb fb fb fb fb fb fb fb fc fc fc fc
                                     ^
 ffff8880700bed80: fa fb fb fb fb fb fb fb fb fb fb fb fc fc fc fc
 ffff8880700bee00: fb fb fb fb fb fb fb fb fb fb fb fb fc fc fc fc
==================================================================


---
This report is generated by a bot. It may contain errors.
See https://goo.gl/tpsmEJ for more information about syzbot.
syzbot engineers can be reached at syzkaller@googlegroups.com.

syzbot will keep track of this issue. See:
https://goo.gl/tpsmEJ#status for how to communicate with syzbot.
