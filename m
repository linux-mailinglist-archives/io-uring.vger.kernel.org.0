Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id F3E38661F41
	for <lists+io-uring@lfdr.de>; Mon,  9 Jan 2023 08:32:21 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232272AbjAIHcT (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Mon, 9 Jan 2023 02:32:19 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:43416 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S236487AbjAIHcE (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Mon, 9 Jan 2023 02:32:04 -0500
Received: from mail-il1-f198.google.com (mail-il1-f198.google.com [209.85.166.198])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 9B10913CD9
        for <io-uring@vger.kernel.org>; Sun,  8 Jan 2023 23:31:38 -0800 (PST)
Received: by mail-il1-f198.google.com with SMTP id x8-20020a056e021ca800b0030c075dc55dso5511834ill.7
        for <io-uring@vger.kernel.org>; Sun, 08 Jan 2023 23:31:38 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=to:from:subject:message-id:date:mime-version:x-gm-message-state
         :from:to:cc:subject:date:message-id:reply-to;
        bh=Bk4s5WCEBLL97IRS+dq4zxRxKqOKDGxAIhb7CY+DLOg=;
        b=AYhfx3/HXXS2M1f9yf5Co/3DdTpsI0yJaA/bfde+dowbWsNB5oc6B/b58zK+UD08/y
         lKKv5FFvM5qvRd89RlQ8pIQHSb/1cc69VCrSKt0/9Sh6Xi3DnbDnM43iCdg7aEtgHhsv
         qWeif2zlG8eK/FkiwDVczu9fJq3HUEM41hXyri0X6tKNVLd5t+uVCeQKkY8rg/+54VVw
         95sga5CXH9hjYM0S+EzgA1oLHo2qTlvYGzuN40xyeg9fxmmn/UBEE4QyCayZt1efSMj+
         FRXlONAk5q2zPpsnk4C7a+0CHRX/YUeXTLNwdvxngAWn/b9RmBfZz707nx2xY3vu2Kjc
         Iaqg==
X-Gm-Message-State: AFqh2kplLH0Z9bMQ53IAPpXjDVOiY5bTG5/7/AeWXJeNFeGWUlN60j++
        +5m629QZNNx2YMOrg4TSX8EReFcGd7qPNDHHR6+K8ITfkrQz
X-Google-Smtp-Source: AMrXdXtpnsIVYs+2m+zmaI2ArPKYuxVu9fOTuWOhBwwoTwjzmvJ6MCr0f8/+z0kLsL2nia5BlwocXpe0GLIuASz8zGwVcL8GiKS1
MIME-Version: 1.0
X-Received: by 2002:a02:9568:0:b0:39e:4ed4:4a79 with SMTP id
 y95-20020a029568000000b0039e4ed44a79mr1671781jah.80.1673249497871; Sun, 08
 Jan 2023 23:31:37 -0800 (PST)
Date:   Sun, 08 Jan 2023 23:31:37 -0800
X-Google-Appengine-App-Id: s~syzkaller
X-Google-Appengine-App-Id-Alias: syzkaller
Message-ID: <000000000000f0fb6005f1cfc17f@google.com>
Subject: [syzbot] KASAN: use-after-free Read in io_wq_worker_wake
From:   syzbot <syzbot+b3ba2408ce0c74bb9230@syzkaller.appspotmail.com>
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

HEAD commit:    1fe4fd6f5cad Merge tag 'xfs-6.2-fixes-2' of git://git.kern..
git tree:       upstream
console output: https://syzkaller.appspot.com/x/log.txt?x=13c346a4480000
kernel config:  https://syzkaller.appspot.com/x/.config?x=8b79b14037065d92
dashboard link: https://syzkaller.appspot.com/bug?extid=b3ba2408ce0c74bb9230
compiler:       gcc (Debian 10.2.1-6) 10.2.1 20210110, GNU ld (GNU Binutils for Debian) 2.35.2
syz repro:      https://syzkaller.appspot.com/x/repro.syz?x=1388e5f2480000
C reproducer:   https://syzkaller.appspot.com/x/repro.c?x=127f1aa4480000

Downloadable assets:
disk image: https://storage.googleapis.com/syzbot-assets/a60762f762f7/disk-1fe4fd6f.raw.xz
vmlinux: https://storage.googleapis.com/syzbot-assets/4988f100ecfa/vmlinux-1fe4fd6f.xz
kernel image: https://storage.googleapis.com/syzbot-assets/1e0060a97bb5/bzImage-1fe4fd6f.xz

IMPORTANT: if you fix the issue, please add the following tag to the commit:
Reported-by: syzbot+b3ba2408ce0c74bb9230@syzkaller.appspotmail.com

==================================================================
BUG: KASAN: use-after-free in io_wq_worker_wake+0xa8/0xb0 io_uring/io-wq.c:862
Read of size 8 at addr ffff88801cdd7028 by task syz-executor318/18434

CPU: 1 PID: 18434 Comm: syz-executor318 Not tainted 6.2.0-rc3-syzkaller-00008-g1fe4fd6f5cad #0
Hardware name: Google Google Compute Engine/Google Compute Engine, BIOS Google 10/26/2022
Call Trace:
 <TASK>
 __dump_stack lib/dump_stack.c:88 [inline]
 dump_stack_lvl+0xd1/0x138 lib/dump_stack.c:106
 print_address_description mm/kasan/report.c:306 [inline]
 print_report+0x15e/0x45d mm/kasan/report.c:417
 kasan_report+0xbf/0x1f0 mm/kasan/report.c:517
 io_wq_worker_wake+0xa8/0xb0 io_uring/io-wq.c:862
 io_wq_for_each_worker io_uring/io-wq.c:849 [inline]
 io_wq_exit_workers io_uring/io-wq.c:1250 [inline]
 io_wq_put_and_exit+0x52a/0xe30 io_uring/io-wq.c:1289
 io_uring_clean_tctx+0x117/0x178 io_uring/tctx.c:193
 io_uring_cancel_generic+0x5ae/0x606 io_uring/io_uring.c:3145
 io_uring_files_cancel include/linux/io_uring.h:55 [inline]
 do_exit+0x522/0x2950 kernel/exit.c:822
 do_group_exit+0xd4/0x2a0 kernel/exit.c:1012
 get_signal+0x21c3/0x2450 kernel/signal.c:2859
 arch_do_signal_or_restart+0x79/0x5c0 arch/x86/kernel/signal.c:306
 exit_to_user_mode_loop kernel/entry/common.c:168 [inline]
 exit_to_user_mode_prepare+0x15f/0x250 kernel/entry/common.c:203
 __syscall_exit_to_user_mode_work kernel/entry/common.c:285 [inline]
 syscall_exit_to_user_mode+0x1d/0x50 kernel/entry/common.c:296
 do_syscall_64+0x46/0xb0 arch/x86/entry/common.c:86
 entry_SYSCALL_64_after_hwframe+0x63/0xcd
RIP: 0033:0x7fbc7f2cbb99
Code: 28 00 00 00 75 05 48 83 c4 28 c3 e8 11 15 00 00 90 48 89 f8 48 89 f7 48 89 d6 48 89 ca 4d 89 c2 4d 89 c8 4c 8b 4c 24 08 0f 05 <48> 3d 01 f0 ff ff 73 01 c3 48 c7 c1 b8 ff ff ff f7 d8 64 89 01 48
RSP: 002b:00007fbc7f27d2e8 EFLAGS: 00000246 ORIG_RAX: 00000000000001aa
RAX: 00000000000002ff RBX: 00007fbc7f353428 RCX: 00007fbc7f2cbb99
RDX: 0000000000000000 RSI: 00000000000002ff RDI: 0000000000000003
RBP: 00007fbc7f353420 R08: 0000000000000000 R09: 0000000000000000
R10: 0000000000000000 R11: 0000000000000246 R12: 00007fbc7f35342c
R13: 00007fbc7f321074 R14: 8000000000000001 R15: 0000000000000003
 </TASK>

Allocated by task 18434:
 kasan_save_stack+0x22/0x40 mm/kasan/common.c:45
 kasan_set_track+0x25/0x30 mm/kasan/common.c:52
 ____kasan_kmalloc mm/kasan/common.c:371 [inline]
 ____kasan_kmalloc mm/kasan/common.c:330 [inline]
 __kasan_kmalloc+0xa5/0xb0 mm/kasan/common.c:380
 kmalloc_node include/linux/slab.h:606 [inline]
 kzalloc_node include/linux/slab.h:731 [inline]
 create_io_worker+0x10c/0x630 io_uring/io-wq.c:801
 io_wqe_create_worker io_uring/io-wq.c:310 [inline]
 io_wqe_enqueue+0x6c3/0xbc0 io_uring/io-wq.c:936
 io_queue_iowq+0x282/0x5c0 io_uring/io_uring.c:475
 io_queue_sqe_fallback+0xf3/0x190 io_uring/io_uring.c:2059
 io_submit_sqe io_uring/io_uring.c:2281 [inline]
 io_submit_sqes+0x11db/0x1e60 io_uring/io_uring.c:2397
 __do_sys_io_uring_enter+0xc1d/0x2540 io_uring/io_uring.c:3345
 do_syscall_x64 arch/x86/entry/common.c:50 [inline]
 do_syscall_64+0x39/0xb0 arch/x86/entry/common.c:80
 entry_SYSCALL_64_after_hwframe+0x63/0xcd

Freed by task 18437:
 kasan_save_stack+0x22/0x40 mm/kasan/common.c:45
 kasan_set_track+0x25/0x30 mm/kasan/common.c:52
 kasan_save_free_info+0x2e/0x40 mm/kasan/generic.c:518
 ____kasan_slab_free mm/kasan/common.c:236 [inline]
 ____kasan_slab_free+0x160/0x1c0 mm/kasan/common.c:200
 kasan_slab_free include/linux/kasan.h:177 [inline]
 slab_free_hook mm/slub.c:1781 [inline]
 slab_free_freelist_hook+0x8b/0x1c0 mm/slub.c:1807
 slab_free mm/slub.c:3787 [inline]
 __kmem_cache_free+0xaf/0x3b0 mm/slub.c:3800
 io_wq_cancel_tw_create io_uring/io-wq.c:1233 [inline]
 io_queue_worker_create+0x567/0x660 io_uring/io-wq.c:381
 io_wqe_dec_running+0x1e4/0x240 io_uring/io-wq.c:410
 io_wq_worker_sleeping+0xa6/0xc0 io_uring/io-wq.c:698
 sched_submit_work kernel/sched/core.c:6597 [inline]
 schedule+0x16e/0x1b0 kernel/sched/core.c:6628
 schedule_preempt_disabled+0x13/0x20 kernel/sched/core.c:6690
 __mutex_lock_common kernel/locking/mutex.c:679 [inline]
 __mutex_lock+0xa48/0x1360 kernel/locking/mutex.c:747
 io_ring_submit_lock io_uring/io_uring.h:215 [inline]
 io_file_get_fixed io_uring/io_uring.c:1966 [inline]
 io_assign_file io_uring/io_uring.c:1834 [inline]
 io_assign_file io_uring/io_uring.c:1828 [inline]
 io_wq_submit_work+0x5f7/0xdc0 io_uring/io_uring.c:1916
 io_worker_handle_work+0xc41/0x1c60 io_uring/io-wq.c:587
 io_wqe_worker+0xa5b/0xe40 io_uring/io-wq.c:632
 ret_from_fork+0x1f/0x30 arch/x86/entry/entry_64.S:308

Last potentially related work creation:
 kasan_save_stack+0x22/0x40 mm/kasan/common.c:45
 __kasan_record_aux_stack+0xbc/0xd0 mm/kasan/generic.c:488
 task_work_add+0x7f/0x2c0 kernel/task_work.c:48
 io_queue_worker_create+0x41d/0x660 io_uring/io-wq.c:373
 io_wqe_dec_running+0x1e4/0x240 io_uring/io-wq.c:410
 io_wq_worker_sleeping+0xa6/0xc0 io_uring/io-wq.c:698
 sched_submit_work kernel/sched/core.c:6597 [inline]
 schedule+0x16e/0x1b0 kernel/sched/core.c:6628
 schedule_preempt_disabled+0x13/0x20 kernel/sched/core.c:6690
 __mutex_lock_common kernel/locking/mutex.c:679 [inline]
 __mutex_lock+0xa48/0x1360 kernel/locking/mutex.c:747
 io_ring_submit_lock io_uring/io_uring.h:215 [inline]
 io_file_get_fixed io_uring/io_uring.c:1966 [inline]
 io_assign_file io_uring/io_uring.c:1834 [inline]
 io_assign_file io_uring/io_uring.c:1828 [inline]
 io_wq_submit_work+0x5f7/0xdc0 io_uring/io_uring.c:1916
 io_worker_handle_work+0xc41/0x1c60 io_uring/io-wq.c:587
 io_wqe_worker+0xa5b/0xe40 io_uring/io-wq.c:632
 ret_from_fork+0x1f/0x30 arch/x86/entry/entry_64.S:308

The buggy address belongs to the object at ffff88801cdd7000
 which belongs to the cache kmalloc-512 of size 512
The buggy address is located 40 bytes inside of
 512-byte region [ffff88801cdd7000, ffff88801cdd7200)

The buggy address belongs to the physical page:
page:ffffea0000737500 refcount:1 mapcount:0 mapping:0000000000000000 index:0x0 pfn:0x1cdd4
head:ffffea0000737500 order:2 compound_mapcount:0 subpages_mapcount:0 compound_pincount:0
flags: 0xfff00000010200(slab|head|node=0|zone=1|lastcpupid=0x7ff)
raw: 00fff00000010200 ffff888012441c80 dead000000000122 0000000000000000
raw: 0000000000000000 0000000000100010 00000001ffffffff 0000000000000000
page dumped because: kasan: bad access detected
page_owner tracks the page as allocated
page last allocated via order 2, migratetype Unmovable, gfp_mask 0xd20c0(__GFP_IO|__GFP_FS|__GFP_NOWARN|__GFP_NORETRY|__GFP_COMP|__GFP_NOMEMALLOC), pid 18245, tgid 18244 (syz-executor318), ts 59882596706, free_ts 59723498525
 prep_new_page mm/page_alloc.c:2531 [inline]
 get_page_from_freelist+0x119c/0x2ce0 mm/page_alloc.c:4283
 __alloc_pages+0x1cb/0x5b0 mm/page_alloc.c:5549
 __alloc_pages_node include/linux/gfp.h:237 [inline]
 alloc_slab_page mm/slub.c:1853 [inline]
 allocate_slab+0xa7/0x350 mm/slub.c:1998
 new_slab mm/slub.c:2051 [inline]
 ___slab_alloc+0xa91/0x1400 mm/slub.c:3193
 __slab_alloc.constprop.0+0x56/0xa0 mm/slub.c:3292
 __slab_alloc_node mm/slub.c:3345 [inline]
 slab_alloc_node mm/slub.c:3442 [inline]
 __kmem_cache_alloc_node+0x1a4/0x430 mm/slub.c:3491
 kmalloc_node_trace+0x21/0x60 mm/slab_common.c:1075
 kmalloc_node include/linux/slab.h:606 [inline]
 kzalloc_node include/linux/slab.h:731 [inline]
 create_io_worker+0x10c/0x630 io_uring/io-wq.c:801
 io_wqe_create_worker io_uring/io-wq.c:310 [inline]
 io_wqe_enqueue+0x6c3/0xbc0 io_uring/io-wq.c:936
 io_queue_iowq+0x282/0x5c0 io_uring/io_uring.c:475
 io_queue_sqe_fallback+0xf3/0x190 io_uring/io_uring.c:2059
 io_submit_sqe io_uring/io_uring.c:2281 [inline]
 io_submit_sqes+0x11db/0x1e60 io_uring/io_uring.c:2397
 __do_sys_io_uring_enter+0xc1d/0x2540 io_uring/io_uring.c:3345
 do_syscall_x64 arch/x86/entry/common.c:50 [inline]
 do_syscall_64+0x39/0xb0 arch/x86/entry/common.c:80
 entry_SYSCALL_64_after_hwframe+0x63/0xcd
page last free stack trace:
 reset_page_owner include/linux/page_owner.h:24 [inline]
 free_pages_prepare mm/page_alloc.c:1446 [inline]
 free_pcp_prepare+0x65c/0xc00 mm/page_alloc.c:1496
 free_unref_page_prepare mm/page_alloc.c:3369 [inline]
 free_unref_page+0x1d/0x490 mm/page_alloc.c:3464
 __vunmap+0x85d/0xd30 mm/vmalloc.c:2727
 free_work+0x5c/0x80 mm/vmalloc.c:100
 process_one_work+0x9bf/0x1710 kernel/workqueue.c:2289
 worker_thread+0x669/0x1090 kernel/workqueue.c:2436
 kthread+0x2e8/0x3a0 kernel/kthread.c:376
 ret_from_fork+0x1f/0x30 arch/x86/entry/entry_64.S:308

Memory state around the buggy address:
 ffff88801cdd6f00: fc fc fc fc fc fc fc fc fc fc fc fc fc fc fc fc
 ffff88801cdd6f80: fc fc fc fc fc fc fc fc fc fc fc fc fc fc fc fc
>ffff88801cdd7000: fa fb fb fb fb fb fb fb fb fb fb fb fb fb fb fb
                                  ^
 ffff88801cdd7080: fb fb fb fb fb fb fb fb fb fb fb fb fb fb fb fb
 ffff88801cdd7100: fb fb fb fb fb fb fb fb fb fb fb fb fb fb fb fb
==================================================================


---
This report is generated by a bot. It may contain errors.
See https://goo.gl/tpsmEJ for more information about syzbot.
syzbot engineers can be reached at syzkaller@googlegroups.com.

syzbot will keep track of this issue. See:
https://goo.gl/tpsmEJ#status for how to communicate with syzbot.
syzbot can test patches for this issue, for details see:
https://goo.gl/tpsmEJ#testing-patches
