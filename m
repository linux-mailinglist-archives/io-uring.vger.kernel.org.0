Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 0F6F5661E8E
	for <lists+io-uring@lfdr.de>; Mon,  9 Jan 2023 07:03:51 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231410AbjAIGDu (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Mon, 9 Jan 2023 01:03:50 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:37080 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230382AbjAIGDq (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Mon, 9 Jan 2023 01:03:46 -0500
Received: from mail-il1-f198.google.com (mail-il1-f198.google.com [209.85.166.198])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id EA75010B70
        for <io-uring@vger.kernel.org>; Sun,  8 Jan 2023 22:03:44 -0800 (PST)
Received: by mail-il1-f198.google.com with SMTP id o10-20020a056e02102a00b003006328df7bso5417658ilj.17
        for <io-uring@vger.kernel.org>; Sun, 08 Jan 2023 22:03:44 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=to:from:subject:message-id:date:mime-version:x-gm-message-state
         :from:to:cc:subject:date:message-id:reply-to;
        bh=/W/WnXVBwSpp6PANALKdRoS5gdTY8R5EztsFYbtEx18=;
        b=fUXnFjtJjuCVxeIf8J8cGHvM/UbPOEDA3pWgD9ygZz4LW2FMxjZqcmlyQWOa/iND6M
         liZC/GOnTMgf73SKXeglni5ew2ORkCH78ZxxJPbqUQFGOXXGbnmrbKs4FcawVsgCmwTd
         Ha/7MKcq2y2PVPaanaQ1vS5E/qheJQRnlsOr8XWhTa/J5UrXBliIjXCHIM9gpMPiTmHg
         pWzUTcZwevl3lNBjGq+n6Gg6eud1Nl+9LvqQ1DyJF1wFmXc8c4pwR0/ivrjI2jkF64Ou
         EmT+5mqoh64ehWqxaRIJIrtkJcctx85dyHpD0C793rb8p3OpylAq71J7JyuljGoPIClx
         fSCQ==
X-Gm-Message-State: AFqh2kq9Tyr2X3f0XhKvEUiDhGLG5hIXwJx5dXnlJPRHMHDutgQdwQVJ
        inDC7GIgvndzpPHAyWoNowllM7Qjm1lnXr6gBLQkw3aZbp/J
X-Google-Smtp-Source: AMrXdXvfjFahAiysqFzn0mrIwmIT+c8MHLk/4JCEEw9FJrbvlcf2WuQlLWSMYXF9X8Uy2hYt8qV6SGjJE0KSmOj5MtggxeC2khoi
MIME-Version: 1.0
X-Received: by 2002:a6b:6d15:0:b0:6e0:2650:ca85 with SMTP id
 a21-20020a6b6d15000000b006e02650ca85mr4532306iod.96.1673244224256; Sun, 08
 Jan 2023 22:03:44 -0800 (PST)
Date:   Sun, 08 Jan 2023 22:03:44 -0800
X-Google-Appengine-App-Id: s~syzkaller
X-Google-Appengine-App-Id-Alias: syzkaller
Message-ID: <0000000000009bff3c05f1ce87f1@google.com>
Subject: [syzbot] KASAN: use-after-free Read in io_wqe_worker (2)
From:   syzbot <syzbot+ad53b671c30ddaba634d@syzkaller.appspotmail.com>
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

HEAD commit:    9b43a525db12 Merge tag 'nfs-for-6.2-2' of git://git.linux-..
git tree:       upstream
console output: https://syzkaller.appspot.com/x/log.txt?x=161784d2480000
kernel config:  https://syzkaller.appspot.com/x/.config?x=ff5cf657dd0e7643
dashboard link: https://syzkaller.appspot.com/bug?extid=ad53b671c30ddaba634d
compiler:       gcc (Debian 10.2.1-6) 10.2.1 20210110, GNU ld (GNU Binutils for Debian) 2.35.2
syz repro:      https://syzkaller.appspot.com/x/repro.syz?x=160480ba480000
C reproducer:   https://syzkaller.appspot.com/x/repro.c?x=14cddc6a480000

Downloadable assets:
disk image: https://storage.googleapis.com/syzbot-assets/ddf8271f0077/disk-9b43a525.raw.xz
vmlinux: https://storage.googleapis.com/syzbot-assets/5a43fe665720/vmlinux-9b43a525.xz
kernel image: https://storage.googleapis.com/syzbot-assets/323f0f0f7267/bzImage-9b43a525.xz

IMPORTANT: if you fix the issue, please add the following tag to the commit:
Reported-by: syzbot+ad53b671c30ddaba634d@syzkaller.appspotmail.com

==================================================================
BUG: KASAN: use-after-free in __list_del_entry_valid+0xec/0x110 lib/list_debug.c:62
Read of size 8 at addr ffff88807ba8f020 by task iou-wrk-10331/10338

CPU: 0 PID: 10338 Comm: iou-wrk-10331 Not tainted 6.2.0-rc2-syzkaller-00313-g9b43a525db12 #0
Hardware name: Google Google Compute Engine/Google Compute Engine, BIOS Google 10/26/2022
Call Trace:
 <TASK>
 __dump_stack lib/dump_stack.c:88 [inline]
 dump_stack_lvl+0xd1/0x138 lib/dump_stack.c:106
 print_address_description mm/kasan/report.c:306 [inline]
 print_report+0x15e/0x45d mm/kasan/report.c:417
 kasan_report+0xbf/0x1f0 mm/kasan/report.c:517
 __list_del_entry_valid+0xec/0x110 lib/list_debug.c:62
 __list_del_entry include/linux/list.h:134 [inline]
 list_del_rcu include/linux/rculist.h:157 [inline]
 io_worker_exit io_uring/io-wq.c:229 [inline]
 io_wqe_worker+0x852/0xe40 io_uring/io-wq.c:661
 ret_from_fork+0x1f/0x30 arch/x86/entry/entry_64.S:308
 </TASK>

Allocated by task 10331:
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

The buggy address belongs to the object at ffff88807ba8f000
 which belongs to the cache kmalloc-512 of size 512
The buggy address is located 32 bytes inside of
 512-byte region [ffff88807ba8f000, ffff88807ba8f200)

The buggy address belongs to the physical page:
page:ffffea0001eea300 refcount:1 mapcount:0 mapping:0000000000000000 index:0x0 pfn:0x7ba8c
head:ffffea0001eea300 order:2 compound_mapcount:0 subpages_mapcount:0 compound_pincount:0
flags: 0xfff00000010200(slab|head|node=0|zone=1|lastcpupid=0x7ff)
raw: 00fff00000010200 ffff888012441c80 dead000000000122 0000000000000000
raw: 0000000000000000 0000000000100010 00000001ffffffff 0000000000000000
page dumped because: kasan: bad access detected
page_owner tracks the page as allocated
page last allocated via order 2, migratetype Unmovable, gfp_mask 0xd20c0(__GFP_IO|__GFP_FS|__GFP_NOWARN|__GFP_NORETRY|__GFP_COMP|__GFP_NOMEMALLOC), pid 10143, tgid 10077 (syz-executor429), ts 196666481357, free_ts 195660604482
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
 __unfreeze_partials+0x17c/0x1a0 mm/slub.c:2637
 qlink_free mm/kasan/quarantine.c:168 [inline]
 qlist_free_all+0x6a/0x170 mm/kasan/quarantine.c:187
 kasan_quarantine_reduce+0x192/0x220 mm/kasan/quarantine.c:294
 __kasan_slab_alloc+0x66/0x90 mm/kasan/common.c:302
 kasan_slab_alloc include/linux/kasan.h:201 [inline]
 slab_post_alloc_hook mm/slab.h:761 [inline]
 slab_alloc_node mm/slub.c:3452 [inline]
 slab_alloc mm/slub.c:3460 [inline]
 __kmem_cache_alloc_lru mm/slub.c:3467 [inline]
 kmem_cache_alloc+0x1e4/0x430 mm/slub.c:3476
 kmem_cache_zalloc include/linux/slab.h:710 [inline]
 taskstats_tgid_alloc kernel/taskstats.c:583 [inline]
 taskstats_exit+0x5f3/0xb80 kernel/taskstats.c:622
 do_exit+0x822/0x2950 kernel/exit.c:852
 do_group_exit+0xd4/0x2a0 kernel/exit.c:1012
 __do_sys_exit_group kernel/exit.c:1023 [inline]
 __se_sys_exit_group kernel/exit.c:1021 [inline]
 __x64_sys_exit_group+0x3e/0x50 kernel/exit.c:1021
 do_syscall_x64 arch/x86/entry/common.c:50 [inline]
 do_syscall_64+0x39/0xb0 arch/x86/entry/common.c:80
 entry_SYSCALL_64_after_hwframe+0x63/0xcd

Memory state around the buggy address:
 ffff88807ba8ef00: fc fc fc fc fc fc fc fc fc fc fc fc fc fc fc fc
 ffff88807ba8ef80: fc fc fc fc fc fc fc fc fc fc fc fc fc fc fc fc
>ffff88807ba8f000: fb fb fb fb fb fb fb fb fb fb fb fb fb fb fb fb
                               ^
 ffff88807ba8f080: fb fb fb fb fb fb fb fb fb fb fb fb fb fb fb fb
 ffff88807ba8f100: fb fb fb fb fb fb fb fb fb fb fb fb fb fb fb fb
==================================================================


---
This report is generated by a bot. It may contain errors.
See https://goo.gl/tpsmEJ for more information about syzbot.
syzbot engineers can be reached at syzkaller@googlegroups.com.

syzbot will keep track of this issue. See:
https://goo.gl/tpsmEJ#status for how to communicate with syzbot.
syzbot can test patches for this issue, for details see:
https://goo.gl/tpsmEJ#testing-patches
