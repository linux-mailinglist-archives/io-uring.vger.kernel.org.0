Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 1E5C1469073
	for <lists+io-uring@lfdr.de>; Mon,  6 Dec 2021 07:43:28 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S237842AbhLFGqv (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Mon, 6 Dec 2021 01:46:51 -0500
Received: from mail-io1-f70.google.com ([209.85.166.70]:40750 "EHLO
        mail-io1-f70.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S237852AbhLFGqv (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Mon, 6 Dec 2021 01:46:51 -0500
Received: by mail-io1-f70.google.com with SMTP id d12-20020a0566022d4c00b005ebda1035b1so7317936iow.7
        for <io-uring@vger.kernel.org>; Sun, 05 Dec 2021 22:43:22 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:mime-version:date:message-id:subject:from:to;
        bh=RiE0z6Vt+AIoyysumKyHCiuT5kT4lX6ulAvpG3vHcfs=;
        b=BKQeph+Og9HJFdBQ8guplB95dfGZB6dwUKbPxel5SJk4kIliT6eRwRcpahgFB7c9DE
         dwEVaFxpwmBjGvPMu9esvshveoJHyDjLP+UVaUYz1ZNqLE9YvXoD+KO5PQK4Nd1lN4gW
         3OBX4dy2i47M8oZM3yLdaYFSZDr6O7TXKp13XyvN5Db9hAdyavFleXK5wnUkiO1NcdsD
         kSK4H29NU5VCQnMKIeGL52JY6xLHlBADaYWdttZ97pDI1KJ5DOkUpo+mp4KNRPvSQJ6g
         sEIlzS1kf7Hu1z7qyMtuHdEds6rLfJWoGv2SN9unfZWYp4jU1a6oQTduwYPbIvESDji8
         wDLA==
X-Gm-Message-State: AOAM532XZT6q30vRm2h2Px12HArHcLTT/CquXS/CaODl1sVsYLFXDneY
        r3n+5N1N0Rdx4iy9ZaOHSy+mTpJzj3WYyOafXB/iDCMnB+v2
X-Google-Smtp-Source: ABdhPJxxQr1F5YLs+k77CEJSXYD9yvuKglzfj1w6rIx8HJMtMKf350w7zYbb2JG11PTn4gJGeekbunZYlqGHKwOmknXYQSbf5CRg
MIME-Version: 1.0
X-Received: by 2002:a05:6602:5d9:: with SMTP id w25mr32120398iox.10.1638773002144;
 Sun, 05 Dec 2021 22:43:22 -0800 (PST)
Date:   Sun, 05 Dec 2021 22:43:22 -0800
X-Google-Appengine-App-Id: s~syzkaller
X-Google-Appengine-App-Id-Alias: syzkaller
Message-ID: <000000000000a9162005d27492b0@google.com>
Subject: [syzbot] KASAN: use-after-free Write in io_queue_worker_create
From:   syzbot <syzbot+b60c982cb0efc5e05a47@syzkaller.appspotmail.com>
To:     asml.silence@gmail.com, axboe@kernel.dk, io-uring@vger.kernel.org,
        linux-kernel@vger.kernel.org, syzkaller-bugs@googlegroups.com
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org

Hello,

syzbot found the following issue on:

HEAD commit:    944207047ca4 Merge tag 'usb-5.16-rc4' of git://git.kernel...
git tree:       upstream
console output: https://syzkaller.appspot.com/x/log.txt?x=13ebd129b00000
kernel config:  https://syzkaller.appspot.com/x/.config?x=171728a464c05f2b
dashboard link: https://syzkaller.appspot.com/bug?extid=b60c982cb0efc5e05a47
compiler:       gcc (Debian 10.2.1-6) 10.2.1 20210110, GNU ld (GNU Binutils for Debian) 2.35.2

Unfortunately, I don't have any reproducer for this issue yet.

IMPORTANT: if you fix the issue, please add the following tag to the commit:
Reported-by: syzbot+b60c982cb0efc5e05a47@syzkaller.appspotmail.com

==================================================================
BUG: KASAN: use-after-free in instrument_atomic_write include/linux/instrumented.h:86 [inline]
BUG: KASAN: use-after-free in clear_bit_unlock include/asm-generic/bitops/instrumented-lock.h:25 [inline]
BUG: KASAN: use-after-free in io_queue_worker_create+0x453/0x4e0 fs/io-wq.c:363
Write of size 8 at addr ffff888023e068d8 by task kworker/3:4/13798

CPU: 3 PID: 13798 Comm: kworker/3:4 Not tainted 5.16.0-rc3-syzkaller #0
Hardware name: QEMU Standard PC (Q35 + ICH9, 2009), BIOS 1.14.0-2 04/01/2014
Workqueue: events io_workqueue_create
Call Trace:
 <TASK>
 __dump_stack lib/dump_stack.c:88 [inline]
 dump_stack_lvl+0xcd/0x134 lib/dump_stack.c:106
 print_address_description.constprop.0.cold+0x8d/0x2ed mm/kasan/report.c:247
 __kasan_report mm/kasan/report.c:433 [inline]
 kasan_report.cold+0x83/0xdf mm/kasan/report.c:450
 check_region_inline mm/kasan/generic.c:183 [inline]
 kasan_check_range+0x13d/0x180 mm/kasan/generic.c:189
 instrument_atomic_write include/linux/instrumented.h:86 [inline]
 clear_bit_unlock include/asm-generic/bitops/instrumented-lock.h:25 [inline]
 io_queue_worker_create+0x453/0x4e0 fs/io-wq.c:363
 io_workqueue_create+0x9e/0xe0 fs/io-wq.c:780
 process_one_work+0x9b2/0x1690 kernel/workqueue.c:2298
 worker_thread+0x658/0x11f0 kernel/workqueue.c:2445
 kthread+0x405/0x4f0 kernel/kthread.c:327
 ret_from_fork+0x1f/0x30 arch/x86/entry/entry_64.S:295
 </TASK>

Allocated by task 5554:
 kasan_save_stack+0x1e/0x50 mm/kasan/common.c:38
 kasan_set_track mm/kasan/common.c:46 [inline]
 set_alloc_info mm/kasan/common.c:434 [inline]
 ____kasan_kmalloc mm/kasan/common.c:513 [inline]
 ____kasan_kmalloc mm/kasan/common.c:472 [inline]
 __kasan_kmalloc+0xa6/0xd0 mm/kasan/common.c:522
 kasan_kmalloc include/linux/kasan.h:269 [inline]
 kmem_cache_alloc_node_trace+0x208/0x5b0 mm/slab.c:3619
 kmalloc_node include/linux/slab.h:608 [inline]
 kzalloc_node include/linux/slab.h:735 [inline]
 create_io_worker+0x108/0x630 fs/io-wq.c:792
 io_wqe_create_worker fs/io-wq.c:300 [inline]
 io_wqe_enqueue+0x692/0xbc0 fs/io-wq.c:924
 io_queue_async_work+0x28b/0x5d0 fs/io_uring.c:1585
 io_queue_sqe_arm_apoll+0xcf/0x1a0 fs/io_uring.c:7004
 __io_queue_sqe fs/io_uring.c:7033 [inline]
 io_queue_sqe fs/io_uring.c:7060 [inline]
 io_submit_sqe fs/io_uring.c:7263 [inline]
 io_submit_sqes+0x796a/0x8a20 fs/io_uring.c:7369
 __do_sys_io_uring_enter+0xf6e/0x1f50 fs/io_uring.c:10070
 do_syscall_x64 arch/x86/entry/common.c:50 [inline]
 do_syscall_64+0x35/0xb0 arch/x86/entry/common.c:80
 entry_SYSCALL_64_after_hwframe+0x44/0xae

Freed by task 5554:
 kasan_save_stack+0x1e/0x50 mm/kasan/common.c:38
 kasan_set_track+0x21/0x30 mm/kasan/common.c:46
 kasan_set_free_info+0x20/0x30 mm/kasan/generic.c:370
 ____kasan_slab_free mm/kasan/common.c:366 [inline]
 ____kasan_slab_free mm/kasan/common.c:328 [inline]
 __kasan_slab_free+0xd1/0x110 mm/kasan/common.c:374
 kasan_slab_free include/linux/kasan.h:235 [inline]
 __cache_free mm/slab.c:3445 [inline]
 kfree+0x10d/0x2c0 mm/slab.c:3802
 create_worker_cont+0x3fb/0x550 fs/io-wq.c:766
 task_work_run+0xdd/0x1a0 kernel/task_work.c:164
 tracehook_notify_signal include/linux/tracehook.h:214 [inline]
 handle_signal_work kernel/entry/common.c:146 [inline]
 exit_to_user_mode_loop kernel/entry/common.c:172 [inline]
 exit_to_user_mode_prepare+0x256/0x290 kernel/entry/common.c:207
 __syscall_exit_to_user_mode_work kernel/entry/common.c:289 [inline]
 syscall_exit_to_user_mode+0x19/0x60 kernel/entry/common.c:300
 do_syscall_64+0x42/0xb0 arch/x86/entry/common.c:86
 entry_SYSCALL_64_after_hwframe+0x44/0xae

Last potentially related work creation:
 kasan_save_stack+0x1e/0x50 mm/kasan/common.c:38
 __kasan_record_aux_stack+0xb5/0xe0 mm/kasan/generic.c:348
 task_work_add+0x3a/0x190 kernel/task_work.c:38
 io_queue_worker_create+0x3ee/0x4e0 fs/io-wq.c:362
 io_workqueue_create+0x9e/0xe0 fs/io-wq.c:780
 process_one_work+0x9b2/0x1690 kernel/workqueue.c:2298
 worker_thread+0x658/0x11f0 kernel/workqueue.c:2445
 kthread+0x405/0x4f0 kernel/kthread.c:327
 ret_from_fork+0x1f/0x30 arch/x86/entry/entry_64.S:295

Second to last potentially related work creation:
 kasan_save_stack+0x1e/0x50 mm/kasan/common.c:38
 __kasan_record_aux_stack+0xb5/0xe0 mm/kasan/generic.c:348
 insert_work+0x48/0x370 kernel/workqueue.c:1354
 __queue_work+0x5ca/0xee0 kernel/workqueue.c:1520
 queue_work_on+0xee/0x110 kernel/workqueue.c:1547
 queue_work include/linux/workqueue.h:502 [inline]
 schedule_work include/linux/workqueue.h:563 [inline]
 create_worker_cont+0x44b/0x550 fs/io-wq.c:772
 task_work_run+0xdd/0x1a0 kernel/task_work.c:164
 tracehook_notify_signal include/linux/tracehook.h:214 [inline]
 handle_signal_work kernel/entry/common.c:146 [inline]
 exit_to_user_mode_loop kernel/entry/common.c:172 [inline]
 exit_to_user_mode_prepare+0x256/0x290 kernel/entry/common.c:207
 __syscall_exit_to_user_mode_work kernel/entry/common.c:289 [inline]
 syscall_exit_to_user_mode+0x19/0x60 kernel/entry/common.c:300
 do_syscall_64+0x42/0xb0 arch/x86/entry/common.c:86
 entry_SYSCALL_64_after_hwframe+0x44/0xae

The buggy address belongs to the object at ffff888023e06800
 which belongs to the cache kmalloc-512 of size 512
The buggy address is located 216 bytes inside of
 512-byte region [ffff888023e06800, ffff888023e06a00)
The buggy address belongs to the page:
page:ffffea00008f8180 refcount:1 mapcount:0 mapping:0000000000000000 index:0x0 pfn:0x23e06
flags: 0xfff00000000200(slab|node=0|zone=1|lastcpupid=0x7ff)
raw: 00fff00000000200 ffffea00004f9bc8 ffffea000072de48 ffff888010c40600
raw: 0000000000000000 ffff888023e06000 0000000100000004 0000000000000000
page dumped because: kasan: bad access detected
page_owner tracks the page as allocated
page last allocated via order 0, migratetype Unmovable, gfp_mask 0x2c2220(__GFP_HIGH|__GFP_ATOMIC|__GFP_NOWARN|__GFP_COMP|__GFP_NOMEMALLOC|__GFP_THISNODE), pid 10854, ts 2474866807743, free_ts 2469053292495
 prep_new_page mm/page_alloc.c:2418 [inline]
 get_page_from_freelist+0xa72/0x2f50 mm/page_alloc.c:4149
 __alloc_pages_slowpath.constprop.0+0x2eb/0x20d0 mm/page_alloc.c:4914
 __alloc_pages+0x412/0x500 mm/page_alloc.c:5382
 __alloc_pages_node include/linux/gfp.h:570 [inline]
 kmem_getpages mm/slab.c:1377 [inline]
 cache_grow_begin+0x75/0x470 mm/slab.c:2593
 cache_alloc_refill+0x27f/0x380 mm/slab.c:2965
 ____cache_alloc mm/slab.c:3048 [inline]
 ____cache_alloc mm/slab.c:3031 [inline]
 slab_alloc_node mm/slab.c:3249 [inline]
 kmem_cache_alloc_node_trace+0x49c/0x5b0 mm/slab.c:3617
 __do_kmalloc_node mm/slab.c:3639 [inline]
 __kmalloc_node_track_caller+0x38/0x60 mm/slab.c:3654
 kmalloc_reserve net/core/skbuff.c:354 [inline]
 __alloc_skb+0xde/0x340 net/core/skbuff.c:426
 skb_copy+0x137/0x2f0 net/core/skbuff.c:1586
 mac80211_hwsim_tx_frame_no_nl.isra.0+0xb17/0x1330 drivers/net/wireless/mac80211_hwsim.c:1565
 mac80211_hwsim_tx+0x574/0x12e0 drivers/net/wireless/mac80211_hwsim.c:1669
 drv_tx net/mac80211/driver-ops.h:35 [inline]
 ieee80211_tx_frags+0x552/0x970 net/mac80211/tx.c:1714
 __ieee80211_tx+0x145/0x4c0 net/mac80211/tx.c:1768
 ieee80211_tx+0x325/0x420 net/mac80211/tx.c:1948
 ieee80211_xmit+0x339/0x420 net/mac80211/tx.c:2040
 __ieee80211_subif_start_xmit+0x7ce/0xdc0 net/mac80211/tx.c:4248
page last free stack trace:
 reset_page_owner include/linux/page_owner.h:24 [inline]
 free_pages_prepare mm/page_alloc.c:1338 [inline]
 free_pcp_prepare+0x374/0x870 mm/page_alloc.c:1389
 free_unref_page_prepare mm/page_alloc.c:3309 [inline]
 free_unref_page+0x19/0x690 mm/page_alloc.c:3388
 slab_destroy mm/slab.c:1627 [inline]
 slabs_destroy+0x89/0xc0 mm/slab.c:1647
 cache_flusharray mm/slab.c:3418 [inline]
 ___cache_free+0x4cc/0x610 mm/slab.c:3480
 qlink_free mm/kasan/quarantine.c:146 [inline]
 qlist_free_all+0x4e/0x110 mm/kasan/quarantine.c:165
 kasan_quarantine_reduce+0x180/0x200 mm/kasan/quarantine.c:272
 __kasan_slab_alloc+0x97/0xb0 mm/kasan/common.c:444
 kasan_slab_alloc include/linux/kasan.h:259 [inline]
 slab_post_alloc_hook mm/slab.h:519 [inline]
 slab_alloc mm/slab.c:3323 [inline]
 kmem_cache_alloc+0x1bc/0x560 mm/slab.c:3507
 sock_alloc_inode+0x18/0x1c0 net/socket.c:303
 alloc_inode+0x61/0x230 fs/inode.c:235
 new_inode_pseudo+0x14/0xe0 fs/inode.c:944
 sock_alloc+0x3c/0x260 net/socket.c:626
 __sock_create+0xb9/0x790 net/socket.c:1428
 sock_create net/socket.c:1515 [inline]
 __sys_socket+0xef/0x200 net/socket.c:1557
 __do_sys_socket net/socket.c:1566 [inline]
 __se_sys_socket net/socket.c:1564 [inline]
 __x64_sys_socket+0x6f/0xb0 net/socket.c:1564
 do_syscall_x64 arch/x86/entry/common.c:50 [inline]
 do_syscall_64+0x35/0xb0 arch/x86/entry/common.c:80

Memory state around the buggy address:
 ffff888023e06780: fc fc fc fc fc fc fc fc fc fc fc fc fc fc fc fc
 ffff888023e06800: fa fb fb fb fb fb fb fb fb fb fb fb fb fb fb fb
>ffff888023e06880: fb fb fb fb fb fb fb fb fb fb fb fb fb fb fb fb
                                                    ^
 ffff888023e06900: fb fb fb fb fb fb fb fb fb fb fb fb fb fb fb fb
 ffff888023e06980: fb fb fb fb fb fb fb fb fb fb fb fb fb fb fb fb
==================================================================


---
This report is generated by a bot. It may contain errors.
See https://goo.gl/tpsmEJ for more information about syzbot.
syzbot engineers can be reached at syzkaller@googlegroups.com.

syzbot will keep track of this issue. See:
https://goo.gl/tpsmEJ#status for how to communicate with syzbot.
