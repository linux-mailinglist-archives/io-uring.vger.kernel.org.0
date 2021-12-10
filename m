Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 4035946FA1C
	for <lists+io-uring@lfdr.de>; Fri, 10 Dec 2021 06:21:19 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231226AbhLJFYw (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Fri, 10 Dec 2021 00:24:52 -0500
Received: from mail-il1-f198.google.com ([209.85.166.198]:56964 "EHLO
        mail-il1-f198.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229736AbhLJFYw (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Fri, 10 Dec 2021 00:24:52 -0500
Received: by mail-il1-f198.google.com with SMTP id e2-20020a056e020b2200b002a4303742d6so8181991ilu.23
        for <io-uring@vger.kernel.org>; Thu, 09 Dec 2021 21:21:17 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:mime-version:date:in-reply-to:message-id:subject
         :from:to;
        bh=CARZrFUgx8qlojUD6zHon2FcXGSXjPH5eTprCyDROBo=;
        b=hruSh/mLMisw8SYb4c4uppIaZCJp3mWdLpFxxrQPjpR7I9N0vyrKfN+vCA0yr38lo9
         MPaK8Dntmu2uFfaL1SvYAf5pz8zXDD41weN7MwNah19m3kyz8OI9iGF0WpL2NnUdHDYb
         vuoeP08dK6ZNc8X/vBFyeKRK2de6VbxB9zbWtF37u637+PZvNc5EJrDhyBNzOV0dpM4B
         IyLkZXVWe2/DfapUUa6/B2Qap1JIQe8cXrpPvwqZLejkwr/y2pwmwzVqU0+nxyEFLKua
         Aj8KZI5rEOrDvaOurxGFSWGyXhGOE/7Iv4jECH4+7ibnGvEVJ1EEF23X8i1Ec4Q8KvsX
         /D8A==
X-Gm-Message-State: AOAM531W+aeMw7Nx5JriAtCrMU9JFs288K4l7JmIWVDLkIVLxgKsqhcv
        2WSBXNPFFYoL/WwD9ZSsetmf/bcNsAZWBDFsYrcWY7EQrm/q
X-Google-Smtp-Source: ABdhPJwsvq1kYHFwyvC/1VDzly880MHPUzaMqXYET2VpWAer+OJccyDtH1nT9VnvSPFUoA4ig986jBqcNkGS6Qsah2Y3TLUllowy
MIME-Version: 1.0
X-Received: by 2002:a02:b616:: with SMTP id h22mr15009272jam.127.1639113677292;
 Thu, 09 Dec 2021 21:21:17 -0800 (PST)
Date:   Thu, 09 Dec 2021 21:21:17 -0800
In-Reply-To: <000000000000a9162005d27492b0@google.com>
X-Google-Appengine-App-Id: s~syzkaller
X-Google-Appengine-App-Id-Alias: syzkaller
Message-ID: <0000000000007b4e3605d2c3e4f1@google.com>
Subject: Re: [syzbot] KASAN: use-after-free Write in io_queue_worker_create
From:   syzbot <syzbot+b60c982cb0efc5e05a47@syzkaller.appspotmail.com>
To:     asml.silence@gmail.com, axboe@kernel.dk, io-uring@vger.kernel.org,
        linux-kernel@vger.kernel.org, syzkaller-bugs@googlegroups.com
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org

syzbot has found a reproducer for the following issue on:

HEAD commit:    c741e49150db Merge tag 'for-linus' of git://git.kernel.org..
git tree:       upstream
console output: https://syzkaller.appspot.com/x/log.txt?x=125600bab00000
kernel config:  https://syzkaller.appspot.com/x/.config?x=221ffc09e39ebbd1
dashboard link: https://syzkaller.appspot.com/bug?extid=b60c982cb0efc5e05a47
compiler:       gcc (Debian 10.2.1-6) 10.2.1 20210110, GNU ld (GNU Binutils for Debian) 2.35.2
syz repro:      https://syzkaller.appspot.com/x/repro.syz?x=1686906db00000
C reproducer:   https://syzkaller.appspot.com/x/repro.c?x=1539a9b9b00000

IMPORTANT: if you fix the issue, please add the following tag to the commit:
Reported-by: syzbot+b60c982cb0efc5e05a47@syzkaller.appspotmail.com

==================================================================
BUG: KASAN: use-after-free in instrument_atomic_write include/linux/instrumented.h:86 [inline]
BUG: KASAN: use-after-free in clear_bit_unlock include/asm-generic/bitops/instrumented-lock.h:25 [inline]
BUG: KASAN: use-after-free in io_queue_worker_create+0x453/0x4e0 fs/io-wq.c:363
Write of size 8 at addr ffff88806e6920d8 by task kworker/1:1/25

CPU: 1 PID: 25 Comm: kworker/1:1 Not tainted 5.16.0-rc4-syzkaller #0
Hardware name: Google Google Compute Engine/Google Compute Engine, BIOS Google 01/01/2011
Workqueue: events io_workqueue_create
Call Trace:
 <TASK>
 __dump_stack lib/dump_stack.c:88 [inline]
 dump_stack_lvl+0xcd/0x134 lib/dump_stack.c:106
 print_address_description.constprop.0.cold+0x8d/0x320 mm/kasan/report.c:247
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

Allocated by task 4385:
 kasan_save_stack+0x1e/0x50 mm/kasan/common.c:38
 kasan_set_track mm/kasan/common.c:46 [inline]
 set_alloc_info mm/kasan/common.c:434 [inline]
 ____kasan_kmalloc mm/kasan/common.c:513 [inline]
 ____kasan_kmalloc mm/kasan/common.c:472 [inline]
 __kasan_kmalloc+0xa9/0xd0 mm/kasan/common.c:522
 kmalloc_node include/linux/slab.h:608 [inline]
 kzalloc_node include/linux/slab.h:735 [inline]
 create_io_worker+0x108/0x630 fs/io-wq.c:792
 create_worker_cb+0x202/0x270 fs/io-wq.c:329
 task_work_run+0xdd/0x1a0 kernel/task_work.c:164
 tracehook_notify_signal include/linux/tracehook.h:214 [inline]
 handle_signal_work kernel/entry/common.c:146 [inline]
 exit_to_user_mode_loop kernel/entry/common.c:172 [inline]
 exit_to_user_mode_prepare+0x256/0x290 kernel/entry/common.c:207
 __syscall_exit_to_user_mode_work kernel/entry/common.c:289 [inline]
 syscall_exit_to_user_mode+0x19/0x60 kernel/entry/common.c:300
 do_syscall_64+0x42/0xb0 arch/x86/entry/common.c:86
 entry_SYSCALL_64_after_hwframe+0x44/0xae

Freed by task 4385:
 kasan_save_stack+0x1e/0x50 mm/kasan/common.c:38
 kasan_set_track+0x21/0x30 mm/kasan/common.c:46
 kasan_set_free_info+0x20/0x30 mm/kasan/generic.c:370
 ____kasan_slab_free mm/kasan/common.c:366 [inline]
 ____kasan_slab_free mm/kasan/common.c:328 [inline]
 __kasan_slab_free+0xff/0x130 mm/kasan/common.c:374
 kasan_slab_free include/linux/kasan.h:235 [inline]
 slab_free_hook mm/slub.c:1723 [inline]
 slab_free_freelist_hook+0x8b/0x1c0 mm/slub.c:1749
 slab_free mm/slub.c:3513 [inline]
 kfree+0xf6/0x560 mm/slub.c:4561
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
 __kasan_record_aux_stack+0xf5/0x120 mm/kasan/generic.c:348
 task_work_add+0x3a/0x190 kernel/task_work.c:38
 io_queue_worker_create+0x3ee/0x4e0 fs/io-wq.c:362
 io_workqueue_create+0x9e/0xe0 fs/io-wq.c:780
 process_one_work+0x9b2/0x1690 kernel/workqueue.c:2298
 worker_thread+0x658/0x11f0 kernel/workqueue.c:2445
 kthread+0x405/0x4f0 kernel/kthread.c:327
 ret_from_fork+0x1f/0x30 arch/x86/entry/entry_64.S:295

Second to last potentially related work creation:
 kasan_save_stack+0x1e/0x50 mm/kasan/common.c:38
 __kasan_record_aux_stack+0xf5/0x120 mm/kasan/generic.c:348
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

The buggy address belongs to the object at ffff88806e692000
 which belongs to the cache kmalloc-512 of size 512
The buggy address is located 216 bytes inside of
 512-byte region [ffff88806e692000, ffff88806e692200)
The buggy address belongs to the page:
page:ffffea0001b9a400 refcount:1 mapcount:0 mapping:0000000000000000 index:0x0 pfn:0x6e690
head:ffffea0001b9a400 order:2 compound_mapcount:0 compound_pincount:0
flags: 0xfff00000010200(slab|head|node=0|zone=1|lastcpupid=0x7ff)
raw: 00fff00000010200 0000000000000000 dead000000000122 ffff888010c41c80
raw: 0000000000000000 0000000000100010 00000001ffffffff 0000000000000000
page dumped because: kasan: bad access detected
page_owner tracks the page as allocated
page last allocated via order 2, migratetype Unmovable, gfp_mask 0x1d20c0(__GFP_IO|__GFP_FS|__GFP_NOWARN|__GFP_NORETRY|__GFP_COMP|__GFP_NOMEMALLOC|__GFP_HARDWALL), pid 4385, ts 49566988561, free_ts 10514971018
 prep_new_page mm/page_alloc.c:2418 [inline]
 get_page_from_freelist+0xa72/0x2f50 mm/page_alloc.c:4149
 __alloc_pages+0x1b2/0x500 mm/page_alloc.c:5369
 __alloc_pages_node include/linux/gfp.h:570 [inline]
 alloc_slab_page mm/slub.c:1795 [inline]
 allocate_slab mm/slub.c:1930 [inline]
 new_slab+0xab/0x4a0 mm/slub.c:1993
 ___slab_alloc+0x918/0xfe0 mm/slub.c:3022
 __slab_alloc.constprop.0+0x4d/0xa0 mm/slub.c:3109
 slab_alloc_node mm/slub.c:3200 [inline]
 kmem_cache_alloc_node_trace+0x116/0x310 mm/slub.c:3284
 kmalloc_node include/linux/slab.h:608 [inline]
 kzalloc_node include/linux/slab.h:735 [inline]
 create_io_worker+0x108/0x630 fs/io-wq.c:792
 create_worker_cb+0x202/0x270 fs/io-wq.c:329
 task_work_run+0xdd/0x1a0 kernel/task_work.c:164
 tracehook_notify_signal include/linux/tracehook.h:214 [inline]
 handle_signal_work kernel/entry/common.c:146 [inline]
 exit_to_user_mode_loop kernel/entry/common.c:172 [inline]
 exit_to_user_mode_prepare+0x256/0x290 kernel/entry/common.c:207
 __syscall_exit_to_user_mode_work kernel/entry/common.c:289 [inline]
 syscall_exit_to_user_mode+0x19/0x60 kernel/entry/common.c:300
 do_syscall_64+0x42/0xb0 arch/x86/entry/common.c:86
 entry_SYSCALL_64_after_hwframe+0x44/0xae
page last free stack trace:
 reset_page_owner include/linux/page_owner.h:24 [inline]
 free_pages_prepare mm/page_alloc.c:1338 [inline]
 free_pcp_prepare+0x374/0x870 mm/page_alloc.c:1389
 free_unref_page_prepare mm/page_alloc.c:3309 [inline]
 free_unref_page+0x19/0x690 mm/page_alloc.c:3388
 free_contig_range+0xa8/0xf0 mm/page_alloc.c:9271
 destroy_args+0xa8/0x646 mm/debug_vm_pgtable.c:1016
 debug_vm_pgtable+0x2984/0x2a16 mm/debug_vm_pgtable.c:1330
 do_one_initcall+0x103/0x650 init/main.c:1297
 do_initcall_level init/main.c:1370 [inline]
 do_initcalls init/main.c:1386 [inline]
 do_basic_setup init/main.c:1405 [inline]
 kernel_init_freeable+0x6b1/0x73a init/main.c:1610
 kernel_init+0x1a/0x1d0 init/main.c:1499
 ret_from_fork+0x1f/0x30 arch/x86/entry/entry_64.S:295

Memory state around the buggy address:
 ffff88806e691f80: fc fc fc fc fc fc fc fc fc fc fc fc fc fc fc fc
 ffff88806e692000: fa fb fb fb fb fb fb fb fb fb fb fb fb fb fb fb
>ffff88806e692080: fb fb fb fb fb fb fb fb fb fb fb fb fb fb fb fb
                                                    ^
 ffff88806e692100: fb fb fb fb fb fb fb fb fb fb fb fb fb fb fb fb
 ffff88806e692180: fb fb fb fb fb fb fb fb fb fb fb fb fb fb fb fb
==================================================================

