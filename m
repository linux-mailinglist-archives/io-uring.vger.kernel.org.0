Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 2B7DC664F8C
	for <lists+io-uring@lfdr.de>; Wed, 11 Jan 2023 00:02:52 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234489AbjAJXCu (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Tue, 10 Jan 2023 18:02:50 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:35450 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234454AbjAJXCu (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Tue, 10 Jan 2023 18:02:50 -0500
Received: from mail-il1-f199.google.com (mail-il1-f199.google.com [209.85.166.199])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id E90C3113D
        for <io-uring@vger.kernel.org>; Tue, 10 Jan 2023 15:02:48 -0800 (PST)
Received: by mail-il1-f199.google.com with SMTP id i14-20020a056e020d8e00b003034b93bd07so9556983ilj.14
        for <io-uring@vger.kernel.org>; Tue, 10 Jan 2023 15:02:48 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=to:from:subject:message-id:date:mime-version:x-gm-message-state
         :from:to:cc:subject:date:message-id:reply-to;
        bh=xp4JzV5yAAr8aEwclMCYmmqY7J/C0e/FAD1rSXdMgwg=;
        b=epO5M8Kn682P6g8UvMvu7Xfln+hWkNRa037Iq2qA4HtRoqc10u7NfBQEwxxX042iUl
         Khr6w/Yu4URKmtwEEd6sqU6EOH9hVWRoEnm4C/LlSlcHOVfybn64djePjDqYk1EIWwXp
         Y9ceWCxciXDaGjQSO/FxheFUS9b3E1bYnZcxmz3REuz7N092PorqOzBcI6dLCmuGYQNW
         F0y+R4wAEAHqwdZCFeUpqyKwBzlTT5vXdr818BZfCWyqv73MMUscFHO6GsvyS/Wcqmut
         +pVZJiyW/K+ks8VhchzM2ejCNg0nzH+1gFe8DC95mvFaVWPAwy1PWkaEdQcs0UFTjACN
         wqFQ==
X-Gm-Message-State: AFqh2kov9Vhvgc0y0JCkkR4pKBygG+CN1a4GWqYrTzc9mdU5gwH7k/cW
        6Dwyy6k6aNpuBOhRUkwlkopSAP97mTF32T/JACd9Z5rNzMhK
X-Google-Smtp-Source: AMrXdXuCYwxsKY3/DIjZeqdMFJsW8nYIpovZHVW4AlxVWKAwQ+X5FZeRupiqiIMkRgn0KU88wotQedjIvcmiK6e2QZo2bUCwpZQ4
MIME-Version: 1.0
X-Received: by 2002:a6b:d613:0:b0:6ed:3090:2ae5 with SMTP id
 w19-20020a6bd613000000b006ed30902ae5mr6589862ioa.100.1673391768324; Tue, 10
 Jan 2023 15:02:48 -0800 (PST)
Date:   Tue, 10 Jan 2023 15:02:48 -0800
X-Google-Appengine-App-Id: s~syzkaller
X-Google-Appengine-App-Id-Alias: syzkaller
Message-ID: <000000000000ebcfaa05f1f0e161@google.com>
Subject: [syzbot] KASAN: use-after-free Read in io_wq_put_and_exit
From:   syzbot <syzbot+0ef474eead6cc5d7f8f9@syzkaller.appspotmail.com>
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

HEAD commit:    40c18f363a08 Merge tag '6.2-rc3-ksmbd-server-fixes' of git..
git tree:       upstream
console output: https://syzkaller.appspot.com/x/log.txt?x=168aefe2480000
kernel config:  https://syzkaller.appspot.com/x/.config?x=2b6ecad960fc703e
dashboard link: https://syzkaller.appspot.com/bug?extid=0ef474eead6cc5d7f8f9
compiler:       gcc (Debian 10.2.1-6) 10.2.1 20210110, GNU ld (GNU Binutils for Debian) 2.35.2

Unfortunately, I don't have any reproducer for this issue yet.

Downloadable assets:
disk image: https://storage.googleapis.com/syzbot-assets/c511b26467c8/disk-40c18f36.raw.xz
vmlinux: https://storage.googleapis.com/syzbot-assets/9d2b0b6588cb/vmlinux-40c18f36.xz
kernel image: https://storage.googleapis.com/syzbot-assets/c7b5971331e3/bzImage-40c18f36.xz

IMPORTANT: if you fix the issue, please add the following tag to the commit:
Reported-by: syzbot+0ef474eead6cc5d7f8f9@syzkaller.appspotmail.com

==================================================================
BUG: KASAN: use-after-free in instrument_atomic_read include/linux/instrumented.h:72 [inline]
BUG: KASAN: use-after-free in atomic_read include/linux/atomic/atomic-instrumented.h:27 [inline]
BUG: KASAN: use-after-free in refcount_read include/linux/refcount.h:147 [inline]
BUG: KASAN: use-after-free in __refcount_add_not_zero include/linux/refcount.h:152 [inline]
BUG: KASAN: use-after-free in __refcount_inc_not_zero include/linux/refcount.h:227 [inline]
BUG: KASAN: use-after-free in refcount_inc_not_zero include/linux/refcount.h:245 [inline]
BUG: KASAN: use-after-free in io_worker_get io_uring/io-wq.c:153 [inline]
BUG: KASAN: use-after-free in io_wq_for_each_worker io_uring/io-wq.c:846 [inline]
BUG: KASAN: use-after-free in io_wq_exit_workers io_uring/io-wq.c:1250 [inline]
BUG: KASAN: use-after-free in io_wq_put_and_exit+0x584/0xe30 io_uring/io-wq.c:1289
Read of size 4 at addr ffff88807d04b800 by task syz-executor.0/25975

CPU: 0 PID: 25975 Comm: syz-executor.0 Not tainted 6.2.0-rc3-syzkaller-00014-g40c18f363a08 #0
Hardware name: Google Google Compute Engine/Google Compute Engine, BIOS Google 10/26/2022
Call Trace:
 <TASK>
 __dump_stack lib/dump_stack.c:88 [inline]
 dump_stack_lvl+0xd1/0x138 lib/dump_stack.c:106
 print_address_description mm/kasan/report.c:306 [inline]
 print_report+0x15e/0x45d mm/kasan/report.c:417
 kasan_report+0xbf/0x1f0 mm/kasan/report.c:517
 check_region_inline mm/kasan/generic.c:183 [inline]
 kasan_check_range+0x141/0x190 mm/kasan/generic.c:189
 instrument_atomic_read include/linux/instrumented.h:72 [inline]
 atomic_read include/linux/atomic/atomic-instrumented.h:27 [inline]
 refcount_read include/linux/refcount.h:147 [inline]
 __refcount_add_not_zero include/linux/refcount.h:152 [inline]
 __refcount_inc_not_zero include/linux/refcount.h:227 [inline]
 refcount_inc_not_zero include/linux/refcount.h:245 [inline]
 io_worker_get io_uring/io-wq.c:153 [inline]
 io_wq_for_each_worker io_uring/io-wq.c:846 [inline]
 io_wq_exit_workers io_uring/io-wq.c:1250 [inline]
 io_wq_put_and_exit+0x584/0xe30 io_uring/io-wq.c:1289
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
RIP: 0033:0x7fd23488c0c9
Code: 28 00 00 00 75 05 48 83 c4 28 c3 e8 f1 19 00 00 90 48 89 f8 48 89 f7 48 89 d6 48 89 ca 4d 89 c2 4d 89 c8 4c 8b 4c 24 08 0f 05 <48> 3d 01 f0 ff ff 73 01 c3 48 c7 c1 b8 ff ff ff f7 d8 64 89 01 48
RSP: 002b:00007fd235510168 EFLAGS: 00000246 ORIG_RAX: 00000000000001aa
RAX: 0000000000000800 RBX: 00007fd2349ac050 RCX: 00007fd23488c0c9
RDX: 0000000000000000 RSI: 0000000000002905 RDI: 0000000000000006
RBP: 00007fd2348e7ae9 R08: 0000000000000000 R09: 0200000000000000
R10: 0000000000000000 R11: 0000000000000246 R12: 0000000000000000
R13: 00007ffe3270181f R14: 00007fd235510300 R15: 0000000000022000
 </TASK>

Allocated by task 25975:
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

Freed by task 25982:
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
 io_buffer_select+0x8e5/0xbe0 io_uring/kbuf.c:178
 io_recv+0x851/0x1140 io_uring/net.c:860
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
 io_buffer_select+0x8e5/0xbe0 io_uring/kbuf.c:178
 io_recv+0x851/0x1140 io_uring/net.c:860
 io_issue_sqe+0x156/0x1220 io_uring/io_uring.c:1856
 io_wq_submit_work+0x29c/0xdc0 io_uring/io_uring.c:1932
 io_worker_handle_work+0xc41/0x1c60 io_uring/io-wq.c:587
 io_wqe_worker+0xa5b/0xe40 io_uring/io-wq.c:632
 ret_from_fork+0x1f/0x30 arch/x86/entry/entry_64.S:308

The buggy address belongs to the object at ffff88807d04b800
 which belongs to the cache kmalloc-512 of size 512
The buggy address is located 0 bytes inside of
 512-byte region [ffff88807d04b800, ffff88807d04ba00)

The buggy address belongs to the physical page:
page:ffffea0001f41200 refcount:1 mapcount:0 mapping:0000000000000000 index:0x0 pfn:0x7d048
head:ffffea0001f41200 order:2 compound_mapcount:0 subpages_mapcount:0 compound_pincount:0
flags: 0xfff00000010200(slab|head|node=0|zone=1|lastcpupid=0x7ff)
raw: 00fff00000010200 ffff888012441c80 dead000000000122 0000000000000000
raw: 0000000000000000 0000000000100010 00000001ffffffff 0000000000000000
page dumped because: kasan: bad access detected
page_owner tracks the page as allocated
page last allocated via order 2, migratetype Unmovable, gfp_mask 0x1d20c0(__GFP_IO|__GFP_FS|__GFP_NOWARN|__GFP_NORETRY|__GFP_COMP|__GFP_NOMEMALLOC|__GFP_HARDWALL), pid 25812, tgid 25807 (syz-executor.0), ts 3443735370667, free_ts 3344104752836
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
 audit_buffer_alloc kernel/audit.c:1776 [inline]
 audit_log_start.part.0+0x25a/0x740 kernel/audit.c:1898
 audit_log_start+0x67/0x90 kernel/audit.c:1854
 audit_seccomp+0x61/0x290 kernel/auditsc.c:2993
 seccomp_log kernel/seccomp.c:994 [inline]
 __seccomp_filter+0x8fc/0x1080 kernel/seccomp.c:1312
 __secure_computing+0x24a/0x3e0 kernel/seccomp.c:1342
 syscall_trace_enter.constprop.0+0x90/0x250 kernel/entry/common.c:72
 do_syscall_64+0x1a/0xb0 arch/x86/entry/common.c:76
 entry_SYSCALL_64_after_hwframe+0x63/0xcd

Memory state around the buggy address:
 ffff88807d04b700: fc fc fc fc fc fc fc fc fc fc fc fc fc fc fc fc
 ffff88807d04b780: fc fc fc fc fc fc fc fc fc fc fc fc fc fc fc fc
>ffff88807d04b800: fa fb fb fb fb fb fb fb fb fb fb fb fb fb fb fb
                   ^
 ffff88807d04b880: fb fb fb fb fb fb fb fb fb fb fb fb fb fb fb fb
 ffff88807d04b900: fb fb fb fb fb fb fb fb fb fb fb fb fb fb fb fb
==================================================================


---
This report is generated by a bot. It may contain errors.
See https://goo.gl/tpsmEJ for more information about syzbot.
syzbot engineers can be reached at syzkaller@googlegroups.com.

syzbot will keep track of this issue. See:
https://goo.gl/tpsmEJ#status for how to communicate with syzbot.
