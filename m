Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id EE4B5660D04
	for <lists+io-uring@lfdr.de>; Sat,  7 Jan 2023 09:35:41 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230049AbjAGIfj (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Sat, 7 Jan 2023 03:35:39 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:53692 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229517AbjAGIfj (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Sat, 7 Jan 2023 03:35:39 -0500
Received: from mail-io1-f69.google.com (mail-io1-f69.google.com [209.85.166.69])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id CC46281C15
        for <io-uring@vger.kernel.org>; Sat,  7 Jan 2023 00:35:37 -0800 (PST)
Received: by mail-io1-f69.google.com with SMTP id 16-20020a5d9c10000000b00702de2ee669so1355997ioe.10
        for <io-uring@vger.kernel.org>; Sat, 07 Jan 2023 00:35:37 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=to:from:subject:message-id:in-reply-to:date:mime-version
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=eFZX7VtxQxMqvCKPWZt20Zmxwpld0Duv4j3WBUb+MIs=;
        b=cguRnW2BEJGHbHT8JxRdN7Ni0z5snXQ9QGekD0Vo5FmfPXVZWoDmnfcgVsYXHMDvd7
         pezMmdObbbBcPha4f6AFNoGfm8sDpzuYDGqoqDlCUnL22dHpFrHApa3M4ECTcwn1byXi
         XCxNusqBJZ5UMfmrc0woO+ef9b7uyj5z//Or/tzVeFIacByjPlEic9Hg24xXU61dWlD/
         dmctAq5Z6c7VII+KzDUBjVs6dhVRw8dwU9m4bMTc2EivC/ngtET20mKJQ/B3IUH29I5V
         lGI9KIcZ6S0eFFczUHcFLDulzcZvo39akKqssXp2d2a1sBgTU8iYgVWGFOI5sKxzIR3W
         J51Q==
X-Gm-Message-State: AFqh2kojZ2gL+1wYA/N0t3zmlHSxbvD3MyGKGkkIC5/aY6vrUUhKUR3B
        eISGAp+W8OaGWpOhs++Wcb/PJ7lxI8khX4KXQjUNN57nlXGQ
X-Google-Smtp-Source: AMrXdXveveFGItPPr0IqclAsZiqyqThwEaiaxOvVhzmVMA0bENuVLLXUiLKrQEKAO2cMneCtFYGy+x1azoI0+T4sXN7lunfYLPCd
MIME-Version: 1.0
X-Received: by 2002:a02:c99a:0:b0:39e:5ce5:ed59 with SMTP id
 b26-20020a02c99a000000b0039e5ce5ed59mr695822jap.274.1673080537173; Sat, 07
 Jan 2023 00:35:37 -0800 (PST)
Date:   Sat, 07 Jan 2023 00:35:37 -0800
In-Reply-To: <000000000000da806205f1a5b139@google.com>
X-Google-Appengine-App-Id: s~syzkaller
X-Google-Appengine-App-Id-Alias: syzkaller
Message-ID: <00000000000019558e05f1a86b19@google.com>
Subject: Re: [syzbot] KASAN: wild-memory-access Read in io_wq_worker_running
From:   syzbot <syzbot+d56ec896af3637bdb7e4@syzkaller.appspotmail.com>
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

syzbot has found a reproducer for the following issue on:

HEAD commit:    a689b938df39 Merge tag 'block-2023-01-06' of git://git.ker..
git tree:       upstream
console output: https://syzkaller.appspot.com/x/log.txt?x=1278ab3a480000
kernel config:  https://syzkaller.appspot.com/x/.config?x=ff5cf657dd0e7643
dashboard link: https://syzkaller.appspot.com/bug?extid=d56ec896af3637bdb7e4
compiler:       gcc (Debian 10.2.1-6) 10.2.1 20210110, GNU ld (GNU Binutils for Debian) 2.35.2
syz repro:      https://syzkaller.appspot.com/x/repro.syz?x=137f9b3a480000
C reproducer:   https://syzkaller.appspot.com/x/repro.c?x=17d080ba480000

Downloadable assets:
disk image: https://storage.googleapis.com/syzbot-assets/e2cef31af3d4/disk-a689b938.raw.xz
vmlinux: https://storage.googleapis.com/syzbot-assets/107ea77bb030/vmlinux-a689b938.xz
kernel image: https://storage.googleapis.com/syzbot-assets/102597c4f641/bzImage-a689b938.xz

IMPORTANT: if you fix the issue, please add the following tag to the commit:
Reported-by: syzbot+d56ec896af3637bdb7e4@syzkaller.appspotmail.com

==================================================================
BUG: KASAN: use-after-free in io_wq_worker_running+0x114/0x130 io_uring/io-wq.c:674
Read of size 4 at addr ffff888020e9f404 by task iou-wrk-6429/6430

CPU: 1 PID: 6430 Comm: iou-wrk-6429 Not tainted 6.2.0-rc2-syzkaller-00256-ga689b938df39 #0
Hardware name: Google Google Compute Engine/Google Compute Engine, BIOS Google 10/26/2022
Call Trace:
 <TASK>
 __dump_stack lib/dump_stack.c:88 [inline]
 dump_stack_lvl+0xd1/0x138 lib/dump_stack.c:106
 print_address_description mm/kasan/report.c:306 [inline]
 print_report+0x15e/0x45d mm/kasan/report.c:417
 kasan_report+0xbf/0x1f0 mm/kasan/report.c:517
 io_wq_worker_running+0x114/0x130 io_uring/io-wq.c:674
 schedule_preempt_disabled+0x13/0x20 kernel/sched/core.c:6690
 __mutex_lock_common kernel/locking/mutex.c:679 [inline]
 __mutex_lock+0xa48/0x1360 kernel/locking/mutex.c:747
 io_ring_submit_lock io_uring/io_uring.h:215 [inline]
 io_poll_cancel+0x1ae/0x1e0 io_uring/poll.c:846
 io_try_cancel+0x176/0x230 io_uring/cancel.c:97
 __io_async_cancel+0xa0/0x3f0 io_uring/cancel.c:140
 io_async_cancel+0x27a/0x480 io_uring/cancel.c:193
 io_issue_sqe+0x156/0x1220 io_uring/io_uring.c:1856
 io_wq_submit_work+0x29c/0xdc0 io_uring/io_uring.c:1932
 io_worker_handle_work+0xc41/0x1c60 io_uring/io-wq.c:587
 io_wqe_worker+0xa5b/0xe40 io_uring/io-wq.c:632
 ret_from_fork+0x1f/0x30 arch/x86/entry/entry_64.S:308
 </TASK>

Allocated by task 6429:
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

Freed by task 6430:
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
 io_poll_cancel+0x1ae/0x1e0 io_uring/poll.c:846
 io_try_cancel+0x176/0x230 io_uring/cancel.c:97
 __io_async_cancel+0xa0/0x3f0 io_uring/cancel.c:140
 io_async_cancel+0x27a/0x480 io_uring/cancel.c:193
 io_issue_sqe+0x156/0x1220 io_uring/io_uring.c:1856
 io_wq_submit_work+0x29c/0xdc0 io_uring/io_uring.c:1932
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
 io_poll_cancel+0x1ae/0x1e0 io_uring/poll.c:846
 io_try_cancel+0x176/0x230 io_uring/cancel.c:97
 __io_async_cancel+0xa0/0x3f0 io_uring/cancel.c:140
 io_async_cancel+0x27a/0x480 io_uring/cancel.c:193
 io_issue_sqe+0x156/0x1220 io_uring/io_uring.c:1856
 io_wq_submit_work+0x29c/0xdc0 io_uring/io_uring.c:1932
 io_worker_handle_work+0xc41/0x1c60 io_uring/io-wq.c:587
 io_wqe_worker+0xa5b/0xe40 io_uring/io-wq.c:632
 ret_from_fork+0x1f/0x30 arch/x86/entry/entry_64.S:308

The buggy address belongs to the object at ffff888020e9f400
 which belongs to the cache kmalloc-512 of size 512
The buggy address is located 4 bytes inside of
 512-byte region [ffff888020e9f400, ffff888020e9f600)

The buggy address belongs to the physical page:
page:ffffea000083a700 refcount:1 mapcount:0 mapping:0000000000000000 index:0x0 pfn:0x20e9c
head:ffffea000083a700 order:2 compound_mapcount:0 subpages_mapcount:0 compound_pincount:0
ksm flags: 0xfff00000010200(slab|head|node=0|zone=1|lastcpupid=0x7ff)
raw: 00fff00000010200 ffff888012441c80 ffffea000078b400 dead000000000003
raw: 0000000000000000 0000000000100010 00000001ffffffff 0000000000000000
page dumped because: kasan: bad access detected
page_owner tracks the page as allocated
page last allocated via order 2, migratetype Unmovable, gfp_mask 0xd2000(__GFP_NOWARN|__GFP_NORETRY|__GFP_COMP|__GFP_NOMEMALLOC), pid 1, tgid 1 (swapper/0), ts 9022994950, free_ts 0
 prep_new_page mm/page_alloc.c:2531 [inline]
 get_page_from_freelist+0x119c/0x2ce0 mm/page_alloc.c:4283
 __alloc_pages+0x1cb/0x5b0 mm/page_alloc.c:5549
 alloc_page_interleave+0x1e/0x200 mm/mempolicy.c:2119
 alloc_pages+0x233/0x270 mm/mempolicy.c:2281
 alloc_slab_page mm/slub.c:1851 [inline]
 allocate_slab+0x25f/0x350 mm/slub.c:1998
 new_slab mm/slub.c:2051 [inline]
 ___slab_alloc+0xa91/0x1400 mm/slub.c:3193
 __slab_alloc.constprop.0+0x56/0xa0 mm/slub.c:3292
 __slab_alloc_node mm/slub.c:3345 [inline]
 slab_alloc_node mm/slub.c:3442 [inline]
 __kmem_cache_alloc_node+0x1a4/0x430 mm/slub.c:3491
 kmalloc_trace+0x26/0x60 mm/slab_common.c:1062
 kmalloc include/linux/slab.h:580 [inline]
 usb_cache_string+0x62/0x150 drivers/usb/core/message.c:1027
 usb_enumerate_device drivers/usb/core/hub.c:2415 [inline]
 usb_new_device+0x167/0x7b0 drivers/usb/core/hub.c:2543
 register_root_hub+0x421/0x573 drivers/usb/core/hcd.c:1017
 usb_add_hcd.cold+0x100c/0x13a1 drivers/usb/core/hcd.c:2991
 dummy_hcd_probe+0x1a3/0x314 drivers/usb/gadget/udc/dummy_hcd.c:2676
 platform_probe+0x100/0x1f0 drivers/base/platform.c:1400
 call_driver_probe drivers/base/dd.c:560 [inline]
 really_probe+0x249/0xb90 drivers/base/dd.c:639
page_owner free stack trace missing

Memory state around the buggy address:
 ffff888020e9f300: fc fc fc fc fc fc fc fc fc fc fc fc fc fc fc fc
 ffff888020e9f380: fc fc fc fc fc fc fc fc fc fc fc fc fc fc fc fc
>ffff888020e9f400: fa fb fb fb fb fb fb fb fb fb fb fb fb fb fb fb
                   ^
 ffff888020e9f480: fb fb fb fb fb fb fb fb fb fb fb fb fb fb fb fb
 ffff888020e9f500: fb fb fb fb fb fb fb fb fb fb fb fb fb fb fb fb
==================================================================

