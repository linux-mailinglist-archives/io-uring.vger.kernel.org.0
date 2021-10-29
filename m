Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id E5C6943FE84
	for <lists+io-uring@lfdr.de>; Fri, 29 Oct 2021 16:34:25 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229712AbhJ2Ogu (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Fri, 29 Oct 2021 10:36:50 -0400
Received: from mail-io1-f70.google.com ([209.85.166.70]:49000 "EHLO
        mail-io1-f70.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229776AbhJ2Ogs (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Fri, 29 Oct 2021 10:36:48 -0400
Received: by mail-io1-f70.google.com with SMTP id f8-20020a05660215c800b005e166630a3dso2263976iow.15
        for <io-uring@vger.kernel.org>; Fri, 29 Oct 2021 07:34:20 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:mime-version:date:message-id:subject:from:to;
        bh=mDEthniVQ2UTNNp1xcyS4MPSJmP6LupS4J4GdkdYIaA=;
        b=KlHYr1W+LZCK/FsLaJqv+AiDtmAYPyPAttk1EKb4SI2b7zhHFKAsF1FaV7jbhgVKMx
         6vdCnmI7eAcfCZFmlYrAxYuWMHTmiIIj2A40yccKdXMoA6UzV5vPdKE3ZSUKs1y+xNo3
         Cm1zVLSVoFqAvzbU5YzF1+CXLpBhOIBIzVXVd8uLdovD++vUa+e27SQ26tukDpJ5MGGg
         AUBy1pkTw4uFnOxAwh3IGFColBZ3VTmAj5Kgl6NLt3zH60oOqd4cGU/xreftI8+UHc4h
         DtkLOoDwSPws2b8O0fqmIQXoPO2IlC+y8L18JTSrSK+86cCWUK9VvZtZ/0QstOGH3jM1
         RRZA==
X-Gm-Message-State: AOAM530mq85XWttGeVYYuVRVsk8LUgsENqVrL3tHWlFmEsEPuppOwPiM
        y98MfHSOnzj0uEn29wyocvHFaubxSoIbzmsQebRo59tuQtvA
X-Google-Smtp-Source: ABdhPJzakMuWgqm28rfZpAM2Q6mb/i+rc5Eqr+InRQrzh9sJObbqZjhViusvsArTMI52FdziFw6Yda0yiYHmMl0upqqDVYOP3pmO
MIME-Version: 1.0
X-Received: by 2002:a05:6638:32aa:: with SMTP id f42mr3429530jav.45.1635518059881;
 Fri, 29 Oct 2021 07:34:19 -0700 (PDT)
Date:   Fri, 29 Oct 2021 07:34:19 -0700
X-Google-Appengine-App-Id: s~syzkaller
X-Google-Appengine-App-Id-Alias: syzkaller
Message-ID: <000000000000fba7bd05cf7eb8f5@google.com>
Subject: [syzbot] KASAN: use-after-free Write in __io_free_req
From:   syzbot <syzbot+78b76ebc91042904f34e@syzkaller.appspotmail.com>
To:     asml.silence@gmail.com, axboe@kernel.dk, io-uring@vger.kernel.org,
        linux-kernel@vger.kernel.org, syzkaller-bugs@googlegroups.com
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org

Hello,

syzbot found the following issue on:

HEAD commit:    bdcc9f6a5682 Add linux-next specific files for 20211029
git tree:       linux-next
console output: https://syzkaller.appspot.com/x/log.txt?x=12a87e22b00000
kernel config:  https://syzkaller.appspot.com/x/.config?x=cea91ee10b0cd274
dashboard link: https://syzkaller.appspot.com/bug?extid=78b76ebc91042904f34e
compiler:       gcc (Debian 10.2.1-6) 10.2.1 20210110, GNU ld (GNU Binutils for Debian) 2.35.2
syz repro:      https://syzkaller.appspot.com/x/repro.syz?x=10cf03e2b00000

IMPORTANT: if you fix the issue, please add the following tag to the commit:
Reported-by: syzbot+78b76ebc91042904f34e@syzkaller.appspotmail.com

==================================================================
BUG: KASAN: use-after-free in wq_list_add_head fs/io-wq.h:71 [inline]
BUG: KASAN: use-after-free in __io_free_req+0x33f/0x3c5 fs/io_uring.c:2040
Write of size 8 at addr ffff8880713ecbb8 by task syz-executor.0/8059

CPU: 1 PID: 8059 Comm: syz-executor.0 Not tainted 5.15.0-rc7-next-20211029-syzkaller #0
Hardware name: Google Google Compute Engine/Google Compute Engine, BIOS Google 01/01/2011
Call Trace:
 <TASK>
 __dump_stack lib/dump_stack.c:88 [inline]
 dump_stack_lvl+0xcd/0x134 lib/dump_stack.c:106
 print_address_description.constprop.0.cold+0x8d/0x320 mm/kasan/report.c:247
 __kasan_report mm/kasan/report.c:433 [inline]
 kasan_report.cold+0x83/0xdf mm/kasan/report.c:450
 wq_list_add_head fs/io-wq.h:71 [inline]
 __io_free_req+0x33f/0x3c5 fs/io_uring.c:2040
 tctx_task_work+0x1b3/0x630 fs/io_uring.c:2207
 task_work_run+0xdd/0x1a0 kernel/task_work.c:164
 exit_task_work include/linux/task_work.h:32 [inline]
 do_exit+0xc14/0x2b40 kernel/exit.c:832
 do_group_exit+0x125/0x310 kernel/exit.c:929
 get_signal+0x47d/0x21d0 kernel/signal.c:2820
 arch_do_signal_or_restart+0x2a9/0x1c40 arch/x86/kernel/signal.c:868
 handle_signal_work kernel/entry/common.c:148 [inline]
 exit_to_user_mode_loop kernel/entry/common.c:172 [inline]
 exit_to_user_mode_prepare+0x17d/0x290 kernel/entry/common.c:207
 __syscall_exit_to_user_mode_work kernel/entry/common.c:289 [inline]
 syscall_exit_to_user_mode+0x19/0x60 kernel/entry/common.c:300
 do_syscall_64+0x42/0xb0 arch/x86/entry/common.c:86
 entry_SYSCALL_64_after_hwframe+0x44/0xae
RIP: 0033:0x7f9da8c4ea39
Code: Unable to access opcode bytes at RIP 0x7f9da8c4ea0f.
RSP: 002b:00007f9da83a3218 EFLAGS: 00000246 ORIG_RAX: 00000000000000ca
RAX: fffffffffffffe00 RBX: 00007f9da8d62028 RCX: 00007f9da8c4ea39
RDX: 0000000000000000 RSI: 0000000000000080 RDI: 00007f9da8d62028
RBP: 00007f9da8d62020 R08: 0000000000000000 R09: 0000000000000000
R10: 0000000000000000 R11: 0000000000000246 R12: 00007f9da8d6202c
R13: 00007ffd6e91741f R14: 00007f9da83a3300 R15: 0000000000022000
 </TASK>

Allocated by task 8059:
 kasan_save_stack+0x1e/0x50 mm/kasan/common.c:38
 kasan_set_track mm/kasan/common.c:46 [inline]
 set_alloc_info mm/kasan/common.c:434 [inline]
 __kasan_slab_alloc+0x90/0xc0 mm/kasan/common.c:467
 kasan_slab_alloc include/linux/kasan.h:259 [inline]
 slab_post_alloc_hook mm/slab.h:519 [inline]
 kmem_cache_alloc_bulk+0x39d/0x720 mm/slub.c:3730
 __io_alloc_req_refill fs/io_uring.c:1977 [inline]
 io_alloc_req_refill fs/io_uring.c:2003 [inline]
 io_submit_sqes.cold+0x20b/0x43d fs/io_uring.c:7325
 __do_sys_io_uring_enter+0xf6e/0x1f50 fs/io_uring.c:10052
 do_syscall_x64 arch/x86/entry/common.c:50 [inline]
 do_syscall_64+0x35/0xb0 arch/x86/entry/common.c:80
 entry_SYSCALL_64_after_hwframe+0x44/0xae

Freed by task 1041:
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
 kmem_cache_free+0x92/0x5e0 mm/slub.c:3529
 io_req_caches_free+0x1aa/0x1e6 fs/io_uring.c:9291
 io_ring_exit_work+0x1e4/0xbe8 fs/io_uring.c:9467
 process_one_work+0x9b2/0x1690 kernel/workqueue.c:2298
 worker_thread+0x658/0x11f0 kernel/workqueue.c:2445
 kthread+0x405/0x4f0 kernel/kthread.c:327
 ret_from_fork+0x1f/0x30 arch/x86/entry/entry_64.S:295

The buggy address belongs to the object at ffff8880713ecb40
 which belongs to the cache io_kiocb of size 224
The buggy address is located 120 bytes inside of
 224-byte region [ffff8880713ecb40, ffff8880713ecc20)
The buggy address belongs to the page:
page:ffffea0001c4fb00 refcount:1 mapcount:0 mapping:0000000000000000 index:0xffff8880713ec8c0 pfn:0x713ec
flags: 0xfff00000000200(slab|node=0|zone=1|lastcpupid=0x7ff)
raw: 00fff00000000200 ffffea0001c4d400 dead000000000004 ffff88814607bdc0
raw: ffff8880713ec8c0 00000000800c000b 00000001ffffffff 0000000000000000
page dumped because: kasan: bad access detected
page_owner tracks the page as allocated
page last allocated via order 0, migratetype Unmovable, gfp_mask 0x12cc0(GFP_KERNEL|__GFP_NOWARN|__GFP_NORETRY), pid 7168, ts 1580559391621, free_ts 1580537948913
 prep_new_page mm/page_alloc.c:2418 [inline]
 get_page_from_freelist+0xa72/0x2f50 mm/page_alloc.c:4149
 __alloc_pages+0x1b2/0x500 mm/page_alloc.c:5369
 alloc_pages+0x1a7/0x300 mm/mempolicy.c:2191
 alloc_slab_page mm/slub.c:1793 [inline]
 allocate_slab mm/slub.c:1930 [inline]
 new_slab+0x32d/0x4a0 mm/slub.c:1993
 ___slab_alloc+0x918/0xfe0 mm/slub.c:3022
 kmem_cache_alloc_bulk+0x21a/0x720 mm/slub.c:3706
 __io_alloc_req_refill fs/io_uring.c:1977 [inline]
 io_alloc_req_refill fs/io_uring.c:2003 [inline]
 io_submit_sqes.cold+0x20b/0x43d fs/io_uring.c:7325
 __do_sys_io_uring_enter+0xf6e/0x1f50 fs/io_uring.c:10052
 do_syscall_x64 arch/x86/entry/common.c:50 [inline]
 do_syscall_64+0x35/0xb0 arch/x86/entry/common.c:80
 entry_SYSCALL_64_after_hwframe+0x44/0xae
page last free stack trace:
 reset_page_owner include/linux/page_owner.h:24 [inline]
 free_pages_prepare mm/page_alloc.c:1338 [inline]
 free_pcp_prepare+0x374/0x870 mm/page_alloc.c:1389
 free_unref_page_prepare mm/page_alloc.c:3309 [inline]
 free_unref_page_list+0x1a9/0xfa0 mm/page_alloc.c:3425
 release_pages+0x3f4/0x1480 mm/swap.c:979
 tlb_batch_pages_flush mm/mmu_gather.c:49 [inline]
 tlb_flush_mmu_free mm/mmu_gather.c:242 [inline]
 tlb_flush_mmu mm/mmu_gather.c:249 [inline]
 tlb_finish_mmu+0x165/0x8c0 mm/mmu_gather.c:340
 exit_mmap+0x1ea/0x630 mm/mmap.c:3173
 __mmput+0x122/0x4b0 kernel/fork.c:1164
 mmput+0x56/0x60 kernel/fork.c:1185
 exit_mm kernel/exit.c:507 [inline]
 do_exit+0xb27/0x2b40 kernel/exit.c:819
 do_group_exit+0x125/0x310 kernel/exit.c:929
 get_signal+0x47d/0x21d0 kernel/signal.c:2820
 arch_do_signal_or_restart+0x2a9/0x1c40 arch/x86/kernel/signal.c:868
 handle_signal_work kernel/entry/common.c:148 [inline]
 exit_to_user_mode_loop kernel/entry/common.c:172 [inline]
 exit_to_user_mode_prepare+0x17d/0x290 kernel/entry/common.c:207
 __syscall_exit_to_user_mode_work kernel/entry/common.c:289 [inline]
 syscall_exit_to_user_mode+0x19/0x60 kernel/entry/common.c:300
 do_syscall_64+0x42/0xb0 arch/x86/entry/common.c:86
 entry_SYSCALL_64_after_hwframe+0x44/0xae

Memory state around the buggy address:
 ffff8880713eca80: fb fb fb fb fb fb fb fb fb fb fb fb fc fc fc fc
 ffff8880713ecb00: fc fc fc fc fc fc fc fc fa fb fb fb fb fb fb fb
>ffff8880713ecb80: fb fb fb fb fb fb fb fb fb fb fb fb fb fb fb fb
                                        ^
 ffff8880713ecc00: fb fb fb fb fc fc fc fc fc fc fc fc fc fc fc fc
 ffff8880713ecc80: fb fb fb fb fb fb fb fb fb fb fb fb fb fb fb fb
==================================================================


---
This report is generated by a bot. It may contain errors.
See https://goo.gl/tpsmEJ for more information about syzbot.
syzbot engineers can be reached at syzkaller@googlegroups.com.

syzbot will keep track of this issue. See:
https://goo.gl/tpsmEJ#status for how to communicate with syzbot.
syzbot can test patches for this issue, for details see:
https://goo.gl/tpsmEJ#testing-patches
