Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 06BB14E47D5
	for <lists+io-uring@lfdr.de>; Tue, 22 Mar 2022 21:55:24 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234515AbiCVU4s (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Tue, 22 Mar 2022 16:56:48 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:49120 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234455AbiCVU4s (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Tue, 22 Mar 2022 16:56:48 -0400
Received: from mail-io1-f72.google.com (mail-io1-f72.google.com [209.85.166.72])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 3462C6415
        for <io-uring@vger.kernel.org>; Tue, 22 Mar 2022 13:55:20 -0700 (PDT)
Received: by mail-io1-f72.google.com with SMTP id z16-20020a05660217d000b006461c7cbee3so13188005iox.21
        for <io-uring@vger.kernel.org>; Tue, 22 Mar 2022 13:55:20 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:mime-version:date:in-reply-to:message-id:subject
         :from:to;
        bh=FN+1NVtCnXt+yRhx/xLwYJoUJ8YsTtya7D1032pDwrQ=;
        b=J6IM7Ucfm/Sq2hPmsx06zSjoqBRvlgDEbiR+pkfizW/+Nx6eDKxV/BTLyLRfes9jGF
         ywpLPgfk1eAUV5Ydg/6Fz6DMWxC92h2vZU9FN3PYF0yvd3G+JktM9SppP2808Ff8OI8i
         zI13NyB3/AJzgIYL+nearL03BWnqU4A9M9Tx71ynvqol5ED/llMdRNyDzYMuIwtGj3OY
         lWpPgbEEVlIh/i4p3isUjenil/coce6qEXb/zG5bo8mGdJxow3eyFkojZAPnVT3r4pY0
         NKwrNVvPM09fbjVW+HdQuVSrSfBivWrs6LONM3XWLG7bR9+xn2/OoKfVXe4Da634yyzJ
         LY0Q==
X-Gm-Message-State: AOAM533g2moMzD2GrkZbTLrZ/zNKpgtOB6PiQmKR0LXdzRZG6Q283a9x
        i1Lo4GNOeg62YRCB3sOIIjoXsAm4oJa4ZkgO4sRKSeMwtu3/
X-Google-Smtp-Source: ABdhPJx8PK1hql2jp+jTJE+7bnuYzFldNluuYSsRZ4FyANQoGVrUK+f/qbZRf94esENKcZ+DPiD2/RDuVSf6nHYuQ9QWwtDIL3bH
MIME-Version: 1.0
X-Received: by 2002:a5e:a80a:0:b0:645:b477:bc23 with SMTP id
 c10-20020a5ea80a000000b00645b477bc23mr13017161ioa.191.1647982519560; Tue, 22
 Mar 2022 13:55:19 -0700 (PDT)
Date:   Tue, 22 Mar 2022 13:55:19 -0700
In-Reply-To: <00000000000012e22c05dacabb11@google.com>
X-Google-Appengine-App-Id: s~syzkaller
X-Google-Appengine-App-Id-Alias: syzkaller
Message-ID: <000000000000acacb205dad4d42c@google.com>
Subject: Re: [syzbot] KASAN: use-after-free Read in add_wait_queue
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

syzbot has found a reproducer for the following issue on:

HEAD commit:    b47d5a4f6b8d Merge tag 'audit-pr-20220321' of git://git.ke..
git tree:       upstream
console output: https://syzkaller.appspot.com/x/log.txt?x=106365bd700000
kernel config:  https://syzkaller.appspot.com/x/.config?x=63af44f0631a5c3a
dashboard link: https://syzkaller.appspot.com/bug?extid=950cee6d91e62329be2c
compiler:       gcc (Debian 10.2.1-6) 10.2.1 20210110, GNU ld (GNU Binutils for Debian) 2.35.2
syz repro:      https://syzkaller.appspot.com/x/repro.syz?x=14506ddb700000
C reproducer:   https://syzkaller.appspot.com/x/repro.c?x=139b2093700000

IMPORTANT: if you fix the issue, please add the following tag to the commit:
Reported-by: syzbot+950cee6d91e62329be2c@syzkaller.appspotmail.com

==================================================================
BUG: KASAN: use-after-free in __add_wait_queue include/linux/wait.h:177 [inline]
BUG: KASAN: use-after-free in add_wait_queue+0x1c0/0x260 kernel/sched/wait.c:24
Read of size 4 at addr ffff88807ec70f18 by task syz-executor133/3649

CPU: 1 PID: 3649 Comm: syz-executor133 Tainted: G        W         5.17.0-syzkaller-01442-gb47d5a4f6b8d #0
Hardware name: Google Google Compute Engine/Google Compute Engine, BIOS Google 01/01/2011
Call Trace:
 <TASK>
 __dump_stack lib/dump_stack.c:88 [inline]
 dump_stack_lvl+0xcd/0x134 lib/dump_stack.c:106
 print_address_description.constprop.0.cold+0x8d/0x336 mm/kasan/report.c:255
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
RIP: 0033:0x7f9692ff4fd9
Code: 28 00 00 00 75 05 48 83 c4 28 c3 e8 b1 14 00 00 90 48 89 f8 48 89 f7 48 89 d6 48 89 ca 4d 89 c2 4d 89 c8 4c 8b 4c 24 08 0f 05 <48> 3d 01 f0 ff ff 73 01 c3 48 c7 c1 c0 ff ff ff f7 d8 64 89 01 48
RSP: 002b:00007ffee24ecca8 EFLAGS: 00000246 ORIG_RAX: 00000000000001aa
RAX: ffffffffffffffda RBX: 0000000000000004 RCX: 00007f9692ff4fd9
RDX: 0000000000000000 RSI: 0000000000001261 RDI: 0000000000000004
RBP: 0000000000000000 R08: 0000000000000000 R09: 0000000000000000
R10: 0000000000000000 R11: 0000000000000246 R12: 0000000000009668
R13: 00007ffee24ecccc R14: 00007ffee24ecce0 R15: 00007ffee24eccd0
 </TASK>

Allocated by task 3631:
 kasan_save_stack+0x1e/0x40 mm/kasan/common.c:38
 kasan_set_track mm/kasan/common.c:45 [inline]
 set_alloc_info mm/kasan/common.c:436 [inline]
 ____kasan_kmalloc mm/kasan/common.c:515 [inline]
 ____kasan_kmalloc mm/kasan/common.c:474 [inline]
 __kasan_kmalloc+0xa9/0xd0 mm/kasan/common.c:524
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

Freed by task 3615:
 kasan_save_stack+0x1e/0x40 mm/kasan/common.c:38
 kasan_set_track+0x21/0x30 mm/kasan/common.c:45
 kasan_set_free_info+0x20/0x30 mm/kasan/generic.c:370
 ____kasan_slab_free mm/kasan/common.c:366 [inline]
 ____kasan_slab_free+0x126/0x160 mm/kasan/common.c:328
 kasan_slab_free include/linux/kasan.h:215 [inline]
 slab_free_hook mm/slub.c:1728 [inline]
 slab_free_freelist_hook+0x8b/0x1c0 mm/slub.c:1754
 slab_free mm/slub.c:3509 [inline]
 kfree+0xd0/0x390 mm/slub.c:4562
 io_flush_apoll_cache fs/io_uring.c:10038 [inline]
 io_ring_ctx_free fs/io_uring.c:10064 [inline]
 io_ring_exit_work+0x7f7/0x1053 fs/io_uring.c:10244
 process_one_work+0x9ac/0x1650 kernel/workqueue.c:2307
 worker_thread+0x657/0x1110 kernel/workqueue.c:2454
 kthread+0x2e9/0x3a0 kernel/kthread.c:377
 ret_from_fork+0x1f/0x30 arch/x86/entry/entry_64.S:295

The buggy address belongs to the object at ffff88807ec70f00
 which belongs to the cache kmalloc-96 of size 96
The buggy address is located 24 bytes inside of
 96-byte region [ffff88807ec70f00, ffff88807ec70f60)
The buggy address belongs to the page:
page:ffffea0001fb1c00 refcount:1 mapcount:0 mapping:0000000000000000 index:0x0 pfn:0x7ec70
flags: 0xfff00000000200(slab|node=0|zone=1|lastcpupid=0x7ff)
raw: 00fff00000000200 ffffea00051d7980 dead000000000006 ffff888010c41780
raw: 0000000000000000 0000000000200020 00000001ffffffff 0000000000000000
page dumped because: kasan: bad access detected
page_owner tracks the page as allocated
page last allocated via order 0, migratetype Unmovable, gfp_mask 0x12c40(GFP_NOFS|__GFP_NOWARN|__GFP_NORETRY), pid 2955, ts 13260642360, free_ts 13233642928
 prep_new_page mm/page_alloc.c:2434 [inline]
 get_page_from_freelist+0xa72/0x2f50 mm/page_alloc.c:4165
 __alloc_pages+0x1b2/0x500 mm/page_alloc.c:5389
 alloc_pages+0x1aa/0x310 mm/mempolicy.c:2271
 alloc_slab_page mm/slub.c:1799 [inline]
 allocate_slab+0x27f/0x3c0 mm/slub.c:1944
 new_slab mm/slub.c:2004 [inline]
 ___slab_alloc+0xbe1/0x12b0 mm/slub.c:3018
 __slab_alloc.constprop.0+0x4d/0xa0 mm/slub.c:3105
 slab_alloc_node mm/slub.c:3196 [inline]
 slab_alloc mm/slub.c:3238 [inline]
 __kmalloc+0x372/0x450 mm/slub.c:4420
 kmalloc include/linux/slab.h:586 [inline]
 kzalloc include/linux/slab.h:714 [inline]
 tomoyo_commit_ok+0x1e/0x90 security/tomoyo/memory.c:76
 tomoyo_update_domain+0x5de/0x850 security/tomoyo/domain.c:139
 tomoyo_update_path_number_acl security/tomoyo/file.c:691 [inline]
 tomoyo_write_file+0x68b/0x7f0 security/tomoyo/file.c:1034
 tomoyo_write_domain2+0x116/0x1d0 security/tomoyo/common.c:1152
 tomoyo_add_entry security/tomoyo/common.c:2042 [inline]
 tomoyo_supervisor+0xbc7/0xf00 security/tomoyo/common.c:2103
 tomoyo_audit_path_number_log security/tomoyo/file.c:235 [inline]
 tomoyo_path_number_perm+0x419/0x590 security/tomoyo/file.c:734
 security_file_ioctl+0x50/0xb0 security/security.c:1557
 __do_sys_ioctl fs/ioctl.c:868 [inline]
 __se_sys_ioctl fs/ioctl.c:860 [inline]
 __x64_sys_ioctl+0xb3/0x200 fs/ioctl.c:860
 do_syscall_x64 arch/x86/entry/common.c:50 [inline]
 do_syscall_64+0x35/0xb0 arch/x86/entry/common.c:80
page last free stack trace:
 reset_page_owner include/linux/page_owner.h:24 [inline]
 free_pages_prepare mm/page_alloc.c:1352 [inline]
 free_pcp_prepare+0x374/0x870 mm/page_alloc.c:1404
 free_unref_page_prepare mm/page_alloc.c:3325 [inline]
 free_unref_page_list+0x1a9/0xfa0 mm/page_alloc.c:3441
 release_pages+0x317/0x1220 mm/swap.c:980
 tlb_batch_pages_flush mm/mmu_gather.c:50 [inline]
 tlb_flush_mmu_free mm/mmu_gather.c:243 [inline]
 tlb_flush_mmu mm/mmu_gather.c:250 [inline]
 tlb_finish_mmu+0x165/0x8c0 mm/mmu_gather.c:341
 exit_mmap+0x21a/0x6a0 mm/mmap.c:3180
 __mmput+0x122/0x4b0 kernel/fork.c:1180
 mmput+0x56/0x60 kernel/fork.c:1202
 exit_mm kernel/exit.c:507 [inline]
 do_exit+0xa12/0x29d0 kernel/exit.c:793
 do_group_exit+0xd2/0x2f0 kernel/exit.c:936
 __do_sys_exit_group kernel/exit.c:947 [inline]
 __se_sys_exit_group kernel/exit.c:945 [inline]
 __x64_sys_exit_group+0x3a/0x50 kernel/exit.c:945
 do_syscall_x64 arch/x86/entry/common.c:50 [inline]
 do_syscall_64+0x35/0xb0 arch/x86/entry/common.c:80
 entry_SYSCALL_64_after_hwframe+0x44/0xae

Memory state around the buggy address:
 ffff88807ec70e00: fa fb fb fb fb fb fb fb fb fb fb fb fc fc fc fc
 ffff88807ec70e80: fa fb fb fb fb fb fb fb fb fb fb fb fc fc fc fc
>ffff88807ec70f00: fa fb fb fb fb fb fb fb fb fb fb fb fc fc fc fc
                            ^
 ffff88807ec70f80: 00 00 00 00 00 00 00 00 00 00 00 00 fc fc fc fc
 ffff88807ec71000: fa fb fb fb fc fc fc fc fa fb fb fb fc fc fc fc
==================================================================

