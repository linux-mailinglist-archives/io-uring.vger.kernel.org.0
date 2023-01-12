Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 2D6F466795E
	for <lists+io-uring@lfdr.de>; Thu, 12 Jan 2023 16:34:44 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S240412AbjALPel (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Thu, 12 Jan 2023 10:34:41 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:47478 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232135AbjALPeJ (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Thu, 12 Jan 2023 10:34:09 -0500
Received: from mail-il1-f199.google.com (mail-il1-f199.google.com [209.85.166.199])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 4EDBA5F91B
        for <io-uring@vger.kernel.org>; Thu, 12 Jan 2023 07:24:58 -0800 (PST)
Received: by mail-il1-f199.google.com with SMTP id x8-20020a056e021ca800b0030c075dc55dso13531846ill.7
        for <io-uring@vger.kernel.org>; Thu, 12 Jan 2023 07:24:58 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=to:from:subject:message-id:in-reply-to:date:mime-version
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=M9Zf/miwcHLHdjuwhn1tof/VbQJRtjvI28zo155yc28=;
        b=M6sOKqvj8PYloyOUjMxxr/1tQhzY9JjxjJf/09AM9spb3EmVd7LaQpplVhHftF9c5D
         vMr8rdxdRk2Wyhq0cDX49tQbU47OKlfs+N6dkUyR8FR7DktH5TpYqeXrC1qBDqZjC/ih
         t+kfGmljuQvlToyoEzLr0VcXjL4+PqpIMxhyE9tqSUpZpaZWtRR5+dNFB28rgtPwYiLM
         CnZlfcEWSz1SiQjUcO+vfxHDfqLJp7sVyu6zzz/7ja8ca5V9kjlB7FjOGZ3W8C58tA2x
         4Vmf/9SciiM/3rjQ4Zo4MtlslkXnXxmwlQOTJzARAZ/PZ5DoIH4UMLxjOYq5nsO1AH+l
         5Ujg==
X-Gm-Message-State: AFqh2kosmuS85uqHPyow5Cy912Ryo8fYHLxycH8qRltqmr7nmcqF+zqd
        99q1V1hW4/R6hyx8HHd+3oMNX/O/RcFe1zYtaqAh0LftpOhd
X-Google-Smtp-Source: AMrXdXvZIBuEaFR7oann2faAz8VUASMdahw9GjGzkbCCFishkCIGtnavZ9GmV+2JY+aVXtUysGrNK03D+VVUoSsaEoF36B95mHki
MIME-Version: 1.0
X-Received: by 2002:a6b:cd45:0:b0:6e2:ca58:69c with SMTP id
 d66-20020a6bcd45000000b006e2ca58069cmr6772959iog.42.1673537083294; Thu, 12
 Jan 2023 07:24:43 -0800 (PST)
Date:   Thu, 12 Jan 2023 07:24:43 -0800
In-Reply-To: <000000000000cf0f4905f20e504c@google.com>
X-Google-Appengine-App-Id: s~syzkaller
X-Google-Appengine-App-Id-Alias: syzkaller
Message-ID: <0000000000005e4ea205f212b7ac@google.com>
Subject: Re: [syzbot] KASAN: use-after-free Read in io_fallback_req_func
From:   syzbot <syzbot+bc022c162e3b001bf607@syzkaller.appspotmail.com>
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

HEAD commit:    0a093b2893c7 Add linux-next specific files for 20230112
git tree:       linux-next
console+strace: https://syzkaller.appspot.com/x/log.txt?x=176167ba480000
kernel config:  https://syzkaller.appspot.com/x/.config?x=835f3591019836d5
dashboard link: https://syzkaller.appspot.com/bug?extid=bc022c162e3b001bf607
compiler:       gcc (Debian 10.2.1-6) 10.2.1 20210110, GNU ld (GNU Binutils for Debian) 2.35.2
syz repro:      https://syzkaller.appspot.com/x/repro.syz?x=17d58fbe480000
C reproducer:   https://syzkaller.appspot.com/x/repro.c?x=151b0316480000

Downloadable assets:
disk image: https://storage.googleapis.com/syzbot-assets/8111a570d6cb/disk-0a093b28.raw.xz
vmlinux: https://storage.googleapis.com/syzbot-assets/ecc135b7fc9a/vmlinux-0a093b28.xz
kernel image: https://storage.googleapis.com/syzbot-assets/ca8d73b446ea/bzImage-0a093b28.xz

IMPORTANT: if you fix the issue, please add the following tag to the commit:
Reported-by: syzbot+bc022c162e3b001bf607@syzkaller.appspotmail.com

==================================================================
BUG: KASAN: use-after-free in io_fallback_req_func+0xc7/0x204 io_uring/io_uring.c:251
Read of size 8 at addr ffff8880793aa948 by task kworker/0:3/4401

CPU: 0 PID: 4401 Comm: kworker/0:3 Not tainted 6.2.0-rc3-next-20230112-syzkaller #0
Hardware name: Google Google Compute Engine/Google Compute Engine, BIOS Google 10/26/2022
Workqueue: events io_fallback_req_func
Call Trace:
 <TASK>
 __dump_stack lib/dump_stack.c:88 [inline]
 dump_stack_lvl+0xd1/0x138 lib/dump_stack.c:106
 print_address_description mm/kasan/report.c:306 [inline]
 print_report+0x15e/0x45d mm/kasan/report.c:417
 kasan_report+0xc0/0xf0 mm/kasan/report.c:517
 io_fallback_req_func+0xc7/0x204 io_uring/io_uring.c:251
 process_one_work+0x9bf/0x1750 kernel/workqueue.c:2293
 worker_thread+0x669/0x1090 kernel/workqueue.c:2440
 kthread+0x2e8/0x3a0 kernel/kthread.c:376
 ret_from_fork+0x1f/0x30 arch/x86/entry/entry_64.S:308
 </TASK>

Allocated by task 5077:
 kasan_save_stack+0x22/0x40 mm/kasan/common.c:45
 kasan_set_track+0x25/0x30 mm/kasan/common.c:52
 __kasan_slab_alloc+0x7f/0x90 mm/kasan/common.c:325
 kasan_slab_alloc include/linux/kasan.h:186 [inline]
 slab_post_alloc_hook mm/slab.h:769 [inline]
 kmem_cache_alloc_bulk+0x3aa/0x730 mm/slub.c:4033
 __io_alloc_req_refill+0xcc/0x40b io_uring/io_uring.c:1062
 io_alloc_req_refill io_uring/io_uring.h:348 [inline]
 io_submit_sqes.cold+0x7c/0xc2 io_uring/io_uring.c:2407
 __do_sys_io_uring_enter+0x9e4/0x2c10 io_uring/io_uring.c:3429
 do_syscall_x64 arch/x86/entry/common.c:50 [inline]
 do_syscall_64+0x39/0xb0 arch/x86/entry/common.c:80
 entry_SYSCALL_64_after_hwframe+0x63/0xcd

Freed by task 31:
 kasan_save_stack+0x22/0x40 mm/kasan/common.c:45
 kasan_set_track+0x25/0x30 mm/kasan/common.c:52
 kasan_save_free_info+0x2e/0x40 mm/kasan/generic.c:518
 ____kasan_slab_free mm/kasan/common.c:236 [inline]
 ____kasan_slab_free+0x160/0x1c0 mm/kasan/common.c:200
 kasan_slab_free include/linux/kasan.h:162 [inline]
 slab_free_hook mm/slub.c:1781 [inline]
 slab_free_freelist_hook+0x8b/0x1c0 mm/slub.c:1807
 slab_free mm/slub.c:3787 [inline]
 kmem_cache_free+0xec/0x4e0 mm/slub.c:3809
 io_req_caches_free+0x1a9/0x1e6 io_uring/io_uring.c:2737
 io_ring_exit_work+0x2e7/0xc80 io_uring/io_uring.c:2967
 process_one_work+0x9bf/0x1750 kernel/workqueue.c:2293
 worker_thread+0x669/0x1090 kernel/workqueue.c:2440
 kthread+0x2e8/0x3a0 kernel/kthread.c:376
 ret_from_fork+0x1f/0x30 arch/x86/entry/entry_64.S:308

The buggy address belongs to the object at ffff8880793aa8c0
 which belongs to the cache io_kiocb of size 216
The buggy address is located 136 bytes inside of
 216-byte region [ffff8880793aa8c0, ffff8880793aa998)

The buggy address belongs to the physical page:
page:ffffea0001e4ea80 refcount:1 mapcount:0 mapping:0000000000000000 index:0x0 pfn:0x793aa
flags: 0xfff00000000200(slab|node=0|zone=1|lastcpupid=0x7ff)
raw: 00fff00000000200 ffff88814610fc80 dead000000000122 0000000000000000
raw: 0000000000000000 00000000800c000c 00000001ffffffff 0000000000000000
page dumped because: kasan: bad access detected
page_owner tracks the page as allocated
page last allocated via order 0, migratetype Unmovable, gfp_mask 0x12cc0(GFP_KERNEL|__GFP_NOWARN|__GFP_NORETRY), pid 5077, tgid 5077 (syz-executor134), ts 60034717602, free_ts 59988620363
 prep_new_page mm/page_alloc.c:2549 [inline]
 get_page_from_freelist+0x11bb/0x2d50 mm/page_alloc.c:4324
 __alloc_pages+0x1cb/0x5c0 mm/page_alloc.c:5590
 alloc_pages+0x1aa/0x270 mm/mempolicy.c:2281
 alloc_slab_page mm/slub.c:1851 [inline]
 allocate_slab+0x25f/0x350 mm/slub.c:1998
 new_slab mm/slub.c:2051 [inline]
 ___slab_alloc+0xa91/0x1400 mm/slub.c:3193
 __kmem_cache_alloc_bulk mm/slub.c:3951 [inline]
 kmem_cache_alloc_bulk+0x23d/0x730 mm/slub.c:4026
 __io_alloc_req_refill+0xcc/0x40b io_uring/io_uring.c:1062
 io_alloc_req_refill io_uring/io_uring.h:348 [inline]
 io_submit_sqes.cold+0x7c/0xc2 io_uring/io_uring.c:2407
 __do_sys_io_uring_enter+0x9e4/0x2c10 io_uring/io_uring.c:3429
 do_syscall_x64 arch/x86/entry/common.c:50 [inline]
 do_syscall_64+0x39/0xb0 arch/x86/entry/common.c:80
 entry_SYSCALL_64_after_hwframe+0x63/0xcd
page last free stack trace:
 reset_page_owner include/linux/page_owner.h:24 [inline]
 free_pages_prepare mm/page_alloc.c:1451 [inline]
 free_pcp_prepare+0x4d0/0x910 mm/page_alloc.c:1501
 free_unref_page_prepare mm/page_alloc.c:3387 [inline]
 free_unref_page_list+0x176/0xcd0 mm/page_alloc.c:3528
 release_pages+0xcb1/0x1330 mm/swap.c:1072
 tlb_batch_pages_flush+0xa8/0x1a0 mm/mmu_gather.c:97
 tlb_flush_mmu_free mm/mmu_gather.c:292 [inline]
 tlb_flush_mmu mm/mmu_gather.c:299 [inline]
 tlb_finish_mmu+0x14b/0x7e0 mm/mmu_gather.c:391
 exit_mmap+0x202/0x7c0 mm/mmap.c:3100
 __mmput+0x128/0x4c0 kernel/fork.c:1212
 mmput+0x60/0x70 kernel/fork.c:1234
 exit_mm kernel/exit.c:563 [inline]
 do_exit+0x9ac/0x2a90 kernel/exit.c:854
 do_group_exit+0xd4/0x2a0 kernel/exit.c:1012
 get_signal+0x225f/0x24f0 kernel/signal.c:2859
 arch_do_signal_or_restart+0x79/0x5c0 arch/x86/kernel/signal.c:306
 exit_to_user_mode_loop kernel/entry/common.c:168 [inline]
 exit_to_user_mode_prepare+0x11f/0x240 kernel/entry/common.c:204
 irqentry_exit_to_user_mode+0x9/0x40 kernel/entry/common.c:310
 exc_page_fault+0xc0/0x170 arch/x86/mm/fault.c:1557
 asm_exc_page_fault+0x26/0x30 arch/x86/include/asm/idtentry.h:570

Memory state around the buggy address:
 ffff8880793aa800: fb fb fb fb fb fb fb fb fb fb fb fc fc fc fc fc
 ffff8880793aa880: fc fc fc fc fc fc fc fc fa fb fb fb fb fb fb fb
>ffff8880793aa900: fb fb fb fb fb fb fb fb fb fb fb fb fb fb fb fb
                                              ^
 ffff8880793aa980: fb fb fb fc fc fc fc fc fc fc fc fc fc fc fc fc
 ffff8880793aaa00: fc fc fc fc fc fc fc fc fc fc fc fc fc fc fc fc
==================================================================

