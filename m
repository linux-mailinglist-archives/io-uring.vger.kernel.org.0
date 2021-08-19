Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 947E33F1771
	for <lists+io-uring@lfdr.de>; Thu, 19 Aug 2021 12:44:09 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S238142AbhHSKoo (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Thu, 19 Aug 2021 06:44:44 -0400
Received: from mail-io1-f71.google.com ([209.85.166.71]:54871 "EHLO
        mail-io1-f71.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S236149AbhHSKon (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Thu, 19 Aug 2021 06:44:43 -0400
Received: by mail-io1-f71.google.com with SMTP id o5-20020a6bf8050000b02905b026202a6fso3007286ioh.21
        for <io-uring@vger.kernel.org>; Thu, 19 Aug 2021 03:44:08 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:date:in-reply-to:message-id:subject
         :from:to;
        bh=NnrHY+0Ifj4stMjiYzo4dTxHnwfcr4wtUED0ExIjtpA=;
        b=tIYUUStg9+00jckR4lPFnvP3CojDuzJJBo6bDvPtgwqielUPCWxr444rSJ5pqjk1B4
         fRE4pLukg5gf7lUqHfzMDvPqe8TdyzEloUMMNgZfNDj2DyVQeBPs7Lw8k0Wql6YG8rPz
         WWZBcYRGjTGpW7bcyna3TDGS2mYdPCGCYJ6Zxn2FON9c27usZ9j1HnvrTiujDyJ05nVB
         jJhaD8OpNOVoDOMXUBv4Pr4j/Wd68FH9qDCxcPHMwoChdY12NW0aQnjI5+HSUwaMBnKm
         +zmWmsoVFWBPDBaj0yDr+4S+L6Mcf1BHnT7Cp8nteE5J+HN/tGNYpAgowIywtR2qkLpw
         apUQ==
X-Gm-Message-State: AOAM531tfAPY5uYabnu9bq+bQQ4bvuzTKQo6NYwTzk1DiIK7MUeKL61d
        7JsdFuEeNyr8bUfvGU2NnjtQDxlfTx4dncaF6i48y0u7JYVA
X-Google-Smtp-Source: ABdhPJx1TcJSHMqV3xiO6gtNPn06oGIheguGbnqad41n5x9vN/jnwIoI4j+p1WILlnSlox3vNBMljICM6EM6FiF+8rvZS3p7123i
MIME-Version: 1.0
X-Received: by 2002:a92:ce03:: with SMTP id b3mr9326399ilo.267.1629369847773;
 Thu, 19 Aug 2021 03:44:07 -0700 (PDT)
Date:   Thu, 19 Aug 2021 03:44:07 -0700
In-Reply-To: <858d47f0-48d5-fff5-24bb-346ebde4e127@gmail.com>
X-Google-Appengine-App-Id: s~syzkaller
X-Google-Appengine-App-Id-Alias: syzkaller
Message-ID: <000000000000fc001d05c9e73a85@google.com>
Subject: Re: [syzbot] KASAN: use-after-free Read in tctx_task_work (2)
From:   syzbot <syzbot+9c3492b27d10dc49ffa6@syzkaller.appspotmail.com>
To:     asml.silence@gmail.com, axboe@kernel.dk, io-uring@vger.kernel.org,
        linux-kernel@vger.kernel.org, syzkaller-bugs@googlegroups.com
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org

Hello,

syzbot has tested the proposed patch but the reproducer is still triggering an issue:
KASAN: use-after-free Read in tctx_task_work

==================================================================
BUG: KASAN: use-after-free in ctx_flush_and_put fs/io_uring.c:2002 [inline]
BUG: KASAN: use-after-free in tctx_task_work+0x307/0x310 fs/io_uring.c:2049
Read of size 4 at addr ffff888029d66358 by task syz-executor530/27775

CPU: 0 PID: 27775 Comm: syz-executor530 Not tainted 5.14.0-rc5-syzkaller #0
Hardware name: Google Google Compute Engine/Google Compute Engine, BIOS Google 01/01/2011
Call Trace:
 __dump_stack lib/dump_stack.c:88 [inline]
 dump_stack_lvl+0xcd/0x134 lib/dump_stack.c:105
 print_address_description.constprop.0.cold+0x6c/0x309 mm/kasan/report.c:233
 __kasan_report mm/kasan/report.c:419 [inline]
 kasan_report.cold+0x83/0xdf mm/kasan/report.c:436
 ctx_flush_and_put fs/io_uring.c:2002 [inline]
 tctx_task_work+0x307/0x310 fs/io_uring.c:2049
 task_work_run+0xdd/0x1a0 kernel/task_work.c:164
 exit_task_work include/linux/task_work.h:32 [inline]
 do_exit+0xbae/0x2a30 kernel/exit.c:825
 do_group_exit+0x125/0x310 kernel/exit.c:922
 get_signal+0x47f/0x2160 kernel/signal.c:2808
 arch_do_signal_or_restart+0x2a9/0x1c40 arch/x86/kernel/signal.c:865
 handle_signal_work kernel/entry/common.c:148 [inline]
 exit_to_user_mode_loop kernel/entry/common.c:172 [inline]
 exit_to_user_mode_prepare+0x17d/0x290 kernel/entry/common.c:209
 __syscall_exit_to_user_mode_work kernel/entry/common.c:291 [inline]
 syscall_exit_to_user_mode+0x19/0x60 kernel/entry/common.c:302
 do_syscall_64+0x42/0xb0 arch/x86/entry/common.c:86
 entry_SYSCALL_64_after_hwframe+0x44/0xae
RIP: 0033:0x446729
Code: Unable to access opcode bytes at RIP 0x4466ff.
RSP: 002b:00007fada1a521e8 EFLAGS: 00000246 ORIG_RAX: 00000000000001aa
RAX: 00000000000001d2 RBX: 00000000004cb458 RCX: 0000000000446729
RDX: 0000000000000000 RSI: 0000000000006b46 RDI: 0000000000000006
RBP: 00000000004cb450 R08: 0000000000000000 R09: 0000000000000000
R10: 0000000000000000 R11: 0000000000000246 R12: 00000000004cb45c
R13: 00007ffff39bb49f R14: 00007fada1a52300 R15: 0000000000022000

Allocated by task 27776:
 kasan_save_stack+0x1b/0x40 mm/kasan/common.c:38
 kasan_set_track mm/kasan/common.c:46 [inline]
 set_alloc_info mm/kasan/common.c:434 [inline]
 ____kasan_kmalloc mm/kasan/common.c:513 [inline]
 ____kasan_kmalloc mm/kasan/common.c:472 [inline]
 __kasan_kmalloc+0x9b/0xd0 mm/kasan/common.c:522
 kmalloc include/linux/slab.h:591 [inline]
 kzalloc include/linux/slab.h:721 [inline]
 io_ring_ctx_alloc fs/io_uring.c:1206 [inline]
 io_uring_create fs/io_uring.c:9685 [inline]
 io_uring_setup+0x27d/0x2cf0 fs/io_uring.c:9791
 do_syscall_x64 arch/x86/entry/common.c:50 [inline]
 do_syscall_64+0x35/0xb0 arch/x86/entry/common.c:80
 entry_SYSCALL_64_after_hwframe+0x44/0xae

Freed by task 10491:
 kasan_save_stack+0x1b/0x40 mm/kasan/common.c:38
 kasan_set_track+0x1c/0x30 mm/kasan/common.c:46
 kasan_set_free_info+0x20/0x30 mm/kasan/generic.c:360
 ____kasan_slab_free mm/kasan/common.c:366 [inline]
 ____kasan_slab_free mm/kasan/common.c:328 [inline]
 __kasan_slab_free+0xfb/0x130 mm/kasan/common.c:374
 kasan_slab_free include/linux/kasan.h:230 [inline]
 slab_free_hook mm/slub.c:1625 [inline]
 slab_free_freelist_hook+0xdf/0x240 mm/slub.c:1650
 slab_free mm/slub.c:3210 [inline]
 kfree+0xe4/0x530 mm/slub.c:4264
 io_ring_ctx_free fs/io_uring.c:8712 [inline]
 io_ring_exit_work+0x13ba/0x1930 fs/io_uring.c:8861
 process_one_work+0x98d/0x1630 kernel/workqueue.c:2276
 worker_thread+0x658/0x11f0 kernel/workqueue.c:2422
 kthread+0x3e5/0x4d0 kernel/kthread.c:319
 ret_from_fork+0x1f/0x30 arch/x86/entry/entry_64.S:295

Last potentially related work creation:
 kasan_save_stack+0x1b/0x40 mm/kasan/common.c:38
 kasan_record_aux_stack+0xe5/0x110 mm/kasan/generic.c:348
 insert_work+0x48/0x370 kernel/workqueue.c:1332
 __queue_work+0x5c1/0xed0 kernel/workqueue.c:1498
 queue_work_on+0xee/0x110 kernel/workqueue.c:1525
 queue_work include/linux/workqueue.h:507 [inline]
 io_ring_ctx_wait_and_kill+0x30a/0x3c0 fs/io_uring.c:8914
 io_uring_release+0x3e/0x50 fs/io_uring.c:8922
 __fput+0x288/0x920 fs/file_table.c:280
 task_work_run+0xdd/0x1a0 kernel/task_work.c:164
 exit_task_work include/linux/task_work.h:32 [inline]
 do_exit+0xbae/0x2a30 kernel/exit.c:825
 do_group_exit+0x125/0x310 kernel/exit.c:922
 get_signal+0x47f/0x2160 kernel/signal.c:2808
 arch_do_signal_or_restart+0x2a9/0x1c40 arch/x86/kernel/signal.c:865
 handle_signal_work kernel/entry/common.c:148 [inline]
 exit_to_user_mode_loop kernel/entry/common.c:172 [inline]
 exit_to_user_mode_prepare+0x17d/0x290 kernel/entry/common.c:209
 __syscall_exit_to_user_mode_work kernel/entry/common.c:291 [inline]
 syscall_exit_to_user_mode+0x19/0x60 kernel/entry/common.c:302
 do_syscall_64+0x42/0xb0 arch/x86/entry/common.c:86
 entry_SYSCALL_64_after_hwframe+0x44/0xae

Second to last potentially related work creation:
 kasan_save_stack+0x1b/0x40 mm/kasan/common.c:38
 kasan_record_aux_stack+0xe5/0x110 mm/kasan/generic.c:348
 insert_work+0x48/0x370 kernel/workqueue.c:1332
 __queue_work+0x5c1/0xed0 kernel/workqueue.c:1498
 queue_work_on+0xee/0x110 kernel/workqueue.c:1525
 queue_work include/linux/workqueue.h:507 [inline]
 io_ring_ctx_wait_and_kill+0x30a/0x3c0 fs/io_uring.c:8914
 io_uring_release+0x3e/0x50 fs/io_uring.c:8922
 __fput+0x288/0x920 fs/file_table.c:280
 task_work_run+0xdd/0x1a0 kernel/task_work.c:164
 exit_task_work include/linux/task_work.h:32 [inline]
 do_exit+0xbae/0x2a30 kernel/exit.c:825
 do_group_exit+0x125/0x310 kernel/exit.c:922
 get_signal+0x47f/0x2160 kernel/signal.c:2808
 arch_do_signal_or_restart+0x2a9/0x1c40 arch/x86/kernel/signal.c:865
 handle_signal_work kernel/entry/common.c:148 [inline]
 exit_to_user_mode_loop kernel/entry/common.c:172 [inline]
 exit_to_user_mode_prepare+0x17d/0x290 kernel/entry/common.c:209
 __syscall_exit_to_user_mode_work kernel/entry/common.c:291 [inline]
 syscall_exit_to_user_mode+0x19/0x60 kernel/entry/common.c:302
 do_syscall_64+0x42/0xb0 arch/x86/entry/common.c:86
 entry_SYSCALL_64_after_hwframe+0x44/0xae

The buggy address belongs to the object at ffff888029d66000
 which belongs to the cache kmalloc-4k of size 4096
The buggy address is located 856 bytes inside of
 4096-byte region [ffff888029d66000, ffff888029d67000)
The buggy address belongs to the page:
page:ffffea0000a75800 refcount:1 mapcount:0 mapping:0000000000000000 index:0x0 pfn:0x29d60
head:ffffea0000a75800 order:3 compound_mapcount:0 compound_pincount:0
flags: 0xfff00000010200(slab|head|node=0|zone=1|lastcpupid=0x7ff)
raw: 00fff00000010200 dead000000000100 dead000000000122 ffff888010842140
raw: 0000000000000000 0000000000040004 00000001ffffffff 0000000000000000
page dumped because: kasan: bad access detected
page_owner tracks the page as allocated
page last allocated via order 3, migratetype Unmovable, gfp_mask 0xd2040(__GFP_IO|__GFP_NOWARN|__GFP_NORETRY|__GFP_COMP|__GFP_NOMEMALLOC), pid 6467, ts 58396905717, free_ts 57689976074
 prep_new_page mm/page_alloc.c:2436 [inline]
 get_page_from_freelist+0xa72/0x2f80 mm/page_alloc.c:4169
 __alloc_pages+0x1b2/0x500 mm/page_alloc.c:5391
 alloc_pages+0x18c/0x2a0 mm/mempolicy.c:2244
 alloc_slab_page mm/slub.c:1688 [inline]
 allocate_slab+0x32e/0x4b0 mm/slub.c:1828
 new_slab mm/slub.c:1891 [inline]
 new_slab_objects mm/slub.c:2637 [inline]
 ___slab_alloc+0x4ba/0x820 mm/slub.c:2800
 __slab_alloc.constprop.0+0xa7/0xf0 mm/slub.c:2840
 slab_alloc_node mm/slub.c:2922 [inline]
 slab_alloc mm/slub.c:2964 [inline]
 __kmalloc+0x312/0x330 mm/slub.c:4108
 kmalloc include/linux/slab.h:596 [inline]
 tomoyo_realpath_from_path+0xc3/0x620 security/tomoyo/realpath.c:254
 tomoyo_get_realpath security/tomoyo/file.c:151 [inline]
 tomoyo_path_perm+0x21b/0x400 security/tomoyo/file.c:822
 security_inode_getattr+0xcf/0x140 security/security.c:1332
 vfs_getattr fs/stat.c:139 [inline]
 vfs_statx+0x164/0x390 fs/stat.c:207
 vfs_fstatat fs/stat.c:225 [inline]
 vfs_lstat include/linux/fs.h:3386 [inline]
 __do_sys_newlstat+0x91/0x110 fs/stat.c:380
 do_syscall_x64 arch/x86/entry/common.c:50 [inline]
 do_syscall_64+0x35/0xb0 arch/x86/entry/common.c:80
 entry_SYSCALL_64_after_hwframe+0x44/0xae
page last free stack trace:
 reset_page_owner include/linux/page_owner.h:24 [inline]
 free_pages_prepare mm/page_alloc.c:1346 [inline]
 free_pcp_prepare+0x2c5/0x780 mm/page_alloc.c:1397
 free_unref_page_prepare mm/page_alloc.c:3332 [inline]
 free_unref_page+0x19/0x690 mm/page_alloc.c:3411
 qlink_free mm/kasan/quarantine.c:146 [inline]
 qlist_free_all+0x5a/0xc0 mm/kasan/quarantine.c:165
 kasan_quarantine_reduce+0x180/0x200 mm/kasan/quarantine.c:272
 __kasan_slab_alloc+0x8e/0xa0 mm/kasan/common.c:444
 kasan_slab_alloc include/linux/kasan.h:254 [inline]
 slab_post_alloc_hook mm/slab.h:519 [inline]
 slab_alloc_node mm/slub.c:2956 [inline]
 slab_alloc mm/slub.c:2964 [inline]
 kmem_cache_alloc+0x285/0x4a0 mm/slub.c:2969
 getname_flags.part.0+0x50/0x4f0 fs/namei.c:138
 getname_flags include/linux/audit.h:319 [inline]
 getname+0x8e/0xd0 fs/namei.c:209
 do_sys_openat2+0xf5/0x420 fs/open.c:1198
 do_sys_open fs/open.c:1220 [inline]
 __do_sys_open fs/open.c:1228 [inline]
 __se_sys_open fs/open.c:1224 [inline]
 __x64_sys_open+0x119/0x1c0 fs/open.c:1224
 do_syscall_x64 arch/x86/entry/common.c:50 [inline]
 do_syscall_64+0x35/0xb0 arch/x86/entry/common.c:80
 entry_SYSCALL_64_after_hwframe+0x44/0xae

Memory state around the buggy address:
 ffff888029d66200: fb fb fb fb fb fb fb fb fb fb fb fb fb fb fb fb
 ffff888029d66280: fb fb fb fb fb fb fb fb fb fb fb fb fb fb fb fb
>ffff888029d66300: fb fb fb fb fb fb fb fb fb fb fb fb fb fb fb fb
                                                    ^
 ffff888029d66380: fb fb fb fb fb fb fb fb fb fb fb fb fb fb fb fb
 ffff888029d66400: fb fb fb fb fb fb fb fb fb fb fb fb fb fb fb fb
==================================================================


Tested on:

commit:         bdd748b6 io-wq: move nr_running and worker_refs out of..
git tree:       git://git.kernel.dk/linux-block for-5.15/io_uring
console output: https://syzkaller.appspot.com/x/log.txt?x=13141b61300000
kernel config:  https://syzkaller.appspot.com/x/.config?x=cb4282936412304f
dashboard link: https://syzkaller.appspot.com/bug?extid=9c3492b27d10dc49ffa6
compiler:       gcc (Debian 10.2.1-6) 10.2.1 20210110, GNU ld (GNU Binutils for Debian) 2.35.1

