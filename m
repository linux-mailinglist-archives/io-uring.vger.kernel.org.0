Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 8E75B38010E
	for <lists+io-uring@lfdr.de>; Fri, 14 May 2021 02:08:11 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231311AbhENAJT (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Thu, 13 May 2021 20:09:19 -0400
Received: from mail-il1-f197.google.com ([209.85.166.197]:44625 "EHLO
        mail-il1-f197.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230466AbhENAJS (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Thu, 13 May 2021 20:09:18 -0400
Received: by mail-il1-f197.google.com with SMTP id p6-20020a92d6860000b02901bb4be9e3c1so2054201iln.11
        for <io-uring@vger.kernel.org>; Thu, 13 May 2021 17:08:08 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:date:in-reply-to:message-id:subject
         :from:to;
        bh=cXyNGd9Vrd2aON7CjiL60tt9ApHuhPJmJpF0UyZNllw=;
        b=boZs8sSvxWrC594rBj36YHHQZAri9yrAgjpQ8Zk0cNjMJB6W83EBfWXLSBgmCpUmtg
         g2U+FPZRqObUtmemjYb5okTqag+WwRJ6Z1itaNtFWqqFR0aVN7qiSIH7875dVAJ4dlDE
         hXj+mP4CpJZO/Y6h9k3a1hvUbshQzAi5oZrfcW3rdC5/787v+15zRn6Hy6ZvylLASjHP
         /WCm9kxZj4pCjHfubBTDebR0hUDkW2pSPhj9ydjO6MzKWJm8IBEAFzSa+KvgIok/OtJp
         jTfrncrv7oHrQNfk8JU63Br4Y/2EDeZGTtqR7C4A3+4UdnU7DdR5YExMa0rPaHFt9Rku
         TykQ==
X-Gm-Message-State: AOAM531Id/arn25nYsNSXWKb4YE4++PZ3sLwLtN2MJSJx2UZ7MAva0+X
        YfsgaUu/bJkK0l1BJc/iLkgiu5HjieM9CnPuQDLGYHiOb/Or
X-Google-Smtp-Source: ABdhPJwOaEbURDnPKBMzitivcDtxibTJxpVP8paGWM4P05ST1L7tdcG9nXvIXXTcmWfsN+xmlHc9t75I8WycfQHrt6QM4wMZIN8m
MIME-Version: 1.0
X-Received: by 2002:a6b:c981:: with SMTP id z123mr31798891iof.6.1620950887615;
 Thu, 13 May 2021 17:08:07 -0700 (PDT)
Date:   Thu, 13 May 2021 17:08:07 -0700
In-Reply-To: <8915be59-5ac9-232d-878e-b09c141059d5@gmail.com>
X-Google-Appengine-App-Id: s~syzkaller
X-Google-Appengine-App-Id-Alias: syzkaller
Message-ID: <000000000000dacff205c23f0955@google.com>
Subject: Re: [syzbot] WARNING in io_link_timeout_fn
From:   syzbot <syzbot+5a864149dd970b546223@syzkaller.appspotmail.com>
To:     asml.silence@gmail.com, axboe@kernel.dk, io-uring@vger.kernel.org,
        linux-fsdevel@vger.kernel.org, linux-kernel@vger.kernel.org,
        syzkaller-bugs@googlegroups.com, viro@zeniv.linux.org.uk
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org

Hello,

syzbot has tested the proposed patch but the reproducer is still triggering an issue:
KASAN: use-after-free Read in hrtimer_active

==================================================================
BUG: KASAN: use-after-free in hrtimer_active+0x1d6/0x1f0 kernel/time/hrtimer.c:1462
Read of size 8 at addr ffff8880129a64b8 by task syz-executor.0/9928

CPU: 0 PID: 9928 Comm: syz-executor.0 Not tainted 5.12.0-syzkaller #0
Hardware name: Google Google Compute Engine/Google Compute Engine, BIOS Google 01/01/2011
Call Trace:
 __dump_stack lib/dump_stack.c:79 [inline]
 dump_stack+0x141/0x1d7 lib/dump_stack.c:120
 print_address_description.constprop.0.cold+0x5b/0x2f8 mm/kasan/report.c:233
 __kasan_report mm/kasan/report.c:419 [inline]
 kasan_report.cold+0x7c/0xd8 mm/kasan/report.c:436
 hrtimer_active+0x1d6/0x1f0 kernel/time/hrtimer.c:1462
 hrtimer_try_to_cancel+0x21/0x1e0 kernel/time/hrtimer.c:1180
 io_kill_linked_timeout fs/io_uring.c:1794 [inline]
 io_disarm_next+0x196/0xad0 fs/io_uring.c:1827
 __io_req_find_next+0xca/0x160 fs/io_uring.c:1852
 io_req_find_next fs/io_uring.c:1868 [inline]
 io_queue_next fs/io_uring.c:2070 [inline]
 io_free_req fs/io_uring.c:2078 [inline]
 io_put_req_deferred_cb+0x253/0x4a0 fs/io_uring.c:2180
 __tctx_task_work fs/io_uring.c:1909 [inline]
 tctx_task_work+0x24e/0x550 fs/io_uring.c:1923
 task_work_run+0xdd/0x1a0 kernel/task_work.c:161
 tracehook_notify_signal include/linux/tracehook.h:212 [inline]
 handle_signal_work kernel/entry/common.c:145 [inline]
 exit_to_user_mode_loop kernel/entry/common.c:171 [inline]
 exit_to_user_mode_prepare+0x24a/0x280 kernel/entry/common.c:208
 __syscall_exit_to_user_mode_work kernel/entry/common.c:290 [inline]
 syscall_exit_to_user_mode+0x19/0x60 kernel/entry/common.c:301
 do_syscall_64+0x47/0xb0 arch/x86/entry/common.c:57
 entry_SYSCALL_64_after_hwframe+0x44/0xae
RIP: 0033:0x4665f9
Code: ff ff c3 66 2e 0f 1f 84 00 00 00 00 00 0f 1f 40 00 48 89 f8 48 89 f7 48 89 d6 48 89 ca 4d 89 c2 4d 89 c8 4c 8b 4c 24 08 0f 05 <48> 3d 01 f0 ff ff 73 01 c3 48 c7 c1 bc ff ff ff f7 d8 64 89 01 48
RSP: 002b:00007f9092a97188 EFLAGS: 00000246 ORIG_RAX: 00000000000001aa
RAX: 0000000000000100 RBX: 000000000056bf60 RCX: 00000000004665f9
RDX: 0000000000000000 RSI: 000000000000450c RDI: 0000000000000003
RBP: 00000000004bfce1 R08: 0000000000000000 R09: 0000000000000000
R10: 0000000000000000 R11: 0000000000000246 R12: 000000000056bf60
R13: 0000000000a9fb1f R14: 00007f9092a97300 R15: 0000000000022000

Allocated by task 9928:
 kasan_save_stack+0x1b/0x40 mm/kasan/common.c:38
 kasan_set_track mm/kasan/common.c:46 [inline]
 set_alloc_info mm/kasan/common.c:427 [inline]
 ____kasan_kmalloc mm/kasan/common.c:506 [inline]
 ____kasan_kmalloc mm/kasan/common.c:465 [inline]
 __kasan_kmalloc+0x99/0xc0 mm/kasan/common.c:515
 kmalloc include/linux/slab.h:561 [inline]
 io_alloc_async_data fs/io_uring.c:3116 [inline]
 io_timeout_prep+0x3d9/0x500 fs/io_uring.c:5637
 io_req_prep fs/io_uring.c:5908 [inline]
 io_submit_sqe fs/io_uring.c:6576 [inline]
 io_submit_sqes+0x4e4c/0x6c50 fs/io_uring.c:6734
 __do_sys_io_uring_enter+0xeaf/0x1d50 fs/io_uring.c:9319
 do_syscall_64+0x3a/0xb0 arch/x86/entry/common.c:47
 entry_SYSCALL_64_after_hwframe+0x44/0xae

Freed by task 4826:
 kasan_save_stack+0x1b/0x40 mm/kasan/common.c:38
 kasan_set_track+0x1c/0x30 mm/kasan/common.c:46
 kasan_set_free_info+0x20/0x30 mm/kasan/generic.c:357
 ____kasan_slab_free mm/kasan/common.c:360 [inline]
 ____kasan_slab_free mm/kasan/common.c:325 [inline]
 __kasan_slab_free+0xf5/0x130 mm/kasan/common.c:367
 kasan_slab_free include/linux/kasan.h:199 [inline]
 slab_free_hook mm/slub.c:1563 [inline]
 slab_free_freelist_hook+0x92/0x210 mm/slub.c:1601
 slab_free mm/slub.c:3162 [inline]
 kfree+0xe5/0x7f0 mm/slub.c:4216
 io_dismantle_req+0x116/0x250 fs/io_uring.c:1743
 io_req_complete_post+0x1d7/0x890 fs/io_uring.c:1600
 io_link_timeout_fn+0x5f7/0xb10 fs/io_uring.c:6369
 __run_hrtimer kernel/time/hrtimer.c:1537 [inline]
 __hrtimer_run_queues+0x609/0xe40 kernel/time/hrtimer.c:1601
 hrtimer_interrupt+0x330/0xa00 kernel/time/hrtimer.c:1663
 local_apic_timer_interrupt arch/x86/kernel/apic/apic.c:1089 [inline]
 __sysvec_apic_timer_interrupt+0x146/0x540 arch/x86/kernel/apic/apic.c:1106
 sysvec_apic_timer_interrupt+0x8e/0xc0 arch/x86/kernel/apic/apic.c:1100
 asm_sysvec_apic_timer_interrupt+0x12/0x20 arch/x86/include/asm/idtentry.h:632

The buggy address belongs to the object at ffff8880129a6480
 which belongs to the cache kmalloc-96 of size 96
The buggy address is located 56 bytes inside of
 96-byte region [ffff8880129a6480, ffff8880129a64e0)
The buggy address belongs to the page:
page:ffffea00004a6980 refcount:1 mapcount:0 mapping:0000000000000000 index:0x0 pfn:0x129a6
flags: 0xfff00000000200(slab|node=0|zone=1|lastcpupid=0x7ff)
raw: 00fff00000000200 dead000000000100 dead000000000122 ffff888010841780
raw: 0000000000000000 0000000000200020 00000001ffffffff 0000000000000000
page dumped because: kasan: bad access detected
page_owner tracks the page as allocated
page last allocated via order 0, migratetype Unmovable, gfp_mask 0x12cc0(GFP_KERNEL|__GFP_NOWARN|__GFP_NORETRY), pid 9928, ts 107924339577
 set_page_owner include/linux/page_owner.h:31 [inline]
 post_alloc_hook+0x161/0x1c0 mm/page_alloc.c:2302
 prep_new_page mm/page_alloc.c:2311 [inline]
 get_page_from_freelist+0x1c6f/0x3fb0 mm/page_alloc.c:3951
 __alloc_pages_nodemask+0x2d6/0x730 mm/page_alloc.c:5001
 alloc_pages_current+0x18c/0x2a0 mm/mempolicy.c:2277
 alloc_pages include/linux/gfp.h:561 [inline]
 alloc_slab_page mm/slub.c:1639 [inline]
 allocate_slab+0x2c5/0x4c0 mm/slub.c:1779
 new_slab mm/slub.c:1842 [inline]
 new_slab_objects mm/slub.c:2588 [inline]
 ___slab_alloc+0x44c/0x7a0 mm/slub.c:2751
 __slab_alloc.constprop.0+0xa7/0xf0 mm/slub.c:2791
 slab_alloc_node mm/slub.c:2872 [inline]
 slab_alloc mm/slub.c:2916 [inline]
 __kmalloc+0x2e5/0x300 mm/slub.c:4054
 kmalloc include/linux/slab.h:561 [inline]
 io_alloc_async_data fs/io_uring.c:3116 [inline]
 io_timeout_prep+0x3d9/0x500 fs/io_uring.c:5637
 io_req_prep fs/io_uring.c:5908 [inline]
 io_submit_sqe fs/io_uring.c:6576 [inline]
 io_submit_sqes+0x4e4c/0x6c50 fs/io_uring.c:6734
 __do_sys_io_uring_enter+0xeaf/0x1d50 fs/io_uring.c:9319
 do_syscall_64+0x3a/0xb0 arch/x86/entry/common.c:47
 entry_SYSCALL_64_after_hwframe+0x44/0xae
page last free stack trace:
 reset_page_owner include/linux/page_owner.h:24 [inline]
 free_pages_prepare mm/page_alloc.c:1271 [inline]
 free_pcp_prepare+0x2cb/0x410 mm/page_alloc.c:1310
 free_unref_page_prepare mm/page_alloc.c:3205 [inline]
 free_unref_page+0x12/0x1d0 mm/page_alloc.c:3253
 qlink_free mm/kasan/quarantine.c:146 [inline]
 qlist_free_all+0x5a/0xc0 mm/kasan/quarantine.c:165
 kasan_quarantine_reduce+0x180/0x200 mm/kasan/quarantine.c:272
 __kasan_slab_alloc+0x7f/0x90 mm/kasan/common.c:437
 kasan_slab_alloc include/linux/kasan.h:223 [inline]
 slab_post_alloc_hook mm/slab.h:516 [inline]
 slab_alloc_node mm/slub.c:2908 [inline]
 slab_alloc mm/slub.c:2916 [inline]
 kmem_cache_alloc+0x153/0x370 mm/slub.c:2921
 getname_flags.part.0+0x50/0x4f0 fs/namei.c:138
 getname_flags include/linux/audit.h:319 [inline]
 getname+0x8e/0xd0 fs/namei.c:209
 do_sys_openat2+0xf5/0x420 fs/open.c:1181
 do_sys_open fs/open.c:1203 [inline]
 __do_sys_open fs/open.c:1211 [inline]
 __se_sys_open fs/open.c:1207 [inline]
 __x64_sys_open+0x119/0x1c0 fs/open.c:1207
 do_syscall_64+0x3a/0xb0 arch/x86/entry/common.c:47
 entry_SYSCALL_64_after_hwframe+0x44/0xae

Memory state around the buggy address:
 ffff8880129a6380: fa fb fb fb fb fb fb fb fb fb fb fb fc fc fc fc
 ffff8880129a6400: 00 00 00 00 00 00 00 00 00 00 00 00 fc fc fc fc
>ffff8880129a6480: fa fb fb fb fb fb fb fb fb fb fb fb fc fc fc fc
                                        ^
 ffff8880129a6500: fa fb fb fb fb fb fb fb fb fb fb fb fc fc fc fc
 ffff8880129a6580: fa fb fb fb fb fb fb fb fb fb fb fb fc fc fc fc
==================================================================


Tested on:

commit:         a519b86e io_uring: syz debug output
git tree:       https://github.com/isilence/linux.git syz_test6
console output: https://syzkaller.appspot.com/x/log.txt?x=14127779d00000
kernel config:  https://syzkaller.appspot.com/x/.config?x=ae2e6c63d6410fd3
dashboard link: https://syzkaller.appspot.com/bug?extid=5a864149dd970b546223
compiler:       

