Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id CE19C4BC715
	for <lists+io-uring@lfdr.de>; Sat, 19 Feb 2022 10:26:01 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S238925AbiBSJUo (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Sat, 19 Feb 2022 04:20:44 -0500
Received: from mxb-00190b01.gslb.pphosted.com ([23.128.96.19]:41534 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S236876AbiBSJUo (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Sat, 19 Feb 2022 04:20:44 -0500
Received: from mail-il1-f200.google.com (mail-il1-f200.google.com [209.85.166.200])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 7E24D207FE9
        for <io-uring@vger.kernel.org>; Sat, 19 Feb 2022 01:20:25 -0800 (PST)
Received: by mail-il1-f200.google.com with SMTP id x6-20020a92d306000000b002bdff65a8e1so5429471ila.3
        for <io-uring@vger.kernel.org>; Sat, 19 Feb 2022 01:20:25 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:mime-version:date:message-id:subject:from:to;
        bh=ckvJmtS+yRVhxy+A79GduUDFZwqPmpPSNh3O8zJ0EkU=;
        b=YGjf+PK1usKs7zMZG69y7IYKn2UJsJ+5tZ80aA8rQeBfPfSrX4wZ0j8DE2kvkPaCpW
         uwZbDVyyCkNTJJuY3X7G8zpY0YMNJ2E5gK1dPBwi8Ksqrnu4xHs+N+BXl8MIN1CP+YwM
         GjJZ4JBZrCijsL/fbhTHIU/Ja2eubU7oa6GMHeGtQJ2QsCK0No2anhhmdbs0hDGG3RVr
         SZocGEITAkzRuGplWtlMHIG7Aj9QnMFrNcyGw9PjWH6XoPFui2yDTQNkSYQBQVQr39bZ
         bn8N6u+AzPFx6qEJLn1N/iAWT5CajEgm0BIRXGl9oCC5/ACnhGaR5qNjNkm5NYW9dDs3
         7XSw==
X-Gm-Message-State: AOAM532mkHvymhZmealUPEFdZXzxpyZy6iOTuXkzWEaA+jQlhq6d4svY
        NB//NNqlCjFAAGWZFrWgrL/r1IMeSQaGoM2O3h+9E8nW7mcB
X-Google-Smtp-Source: ABdhPJwebZdHdIzFMONM1uJsoutpR4znRB4ODc+YKE99903UIXtDRzSQUDhvwO8U0ut2poXVCkp61f7r1100ZYkoajnFyVOhbN5k
MIME-Version: 1.0
X-Received: by 2002:a5e:c64a:0:b0:640:7b5a:3446 with SMTP id
 s10-20020a5ec64a000000b006407b5a3446mr4376673ioo.82.1645262424834; Sat, 19
 Feb 2022 01:20:24 -0800 (PST)
Date:   Sat, 19 Feb 2022 01:20:24 -0800
X-Google-Appengine-App-Id: s~syzkaller
X-Google-Appengine-App-Id-Alias: syzkaller
Message-ID: <00000000000065061a05d85b8262@google.com>
Subject: [syzbot] KASAN: use-after-free Read in io_poll_check_events
From:   syzbot <syzbot+edb9c7738ba8cbdbf197@syzkaller.appspotmail.com>
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

Hello,

syzbot found the following issue on:

HEAD commit:    d567f5db412e Merge tag 'regulator-fix-v5.17-rc4' of git://..
git tree:       upstream
console output: https://syzkaller.appspot.com/x/log.txt?x=137545a4700000
kernel config:  https://syzkaller.appspot.com/x/.config?x=c252f01504189189
dashboard link: https://syzkaller.appspot.com/bug?extid=edb9c7738ba8cbdbf197
compiler:       Debian clang version 11.0.1-2, GNU ld (GNU Binutils for Debian) 2.35.2

Unfortunately, I don't have any reproducer for this issue yet.

IMPORTANT: if you fix the issue, please add the following tag to the commit:
Reported-by: syzbot+edb9c7738ba8cbdbf197@syzkaller.appspotmail.com

==================================================================
BUG: KASAN: use-after-free in io_poll_check_events+0x994/0x9a0 fs/io_uring.c:5516
Read of size 4 at addr ffff88802452ba2c by task kworker/1:21/2630

CPU: 1 PID: 2630 Comm: kworker/1:21 Not tainted 5.17.0-rc4-syzkaller-00002-gd567f5db412e #0
Hardware name: Google Google Compute Engine/Google Compute Engine, BIOS Google 01/01/2011
Workqueue: events io_fallback_req_func
Call Trace:
 <TASK>
 __dump_stack lib/dump_stack.c:88 [inline]
 dump_stack_lvl+0x1dc/0x2d8 lib/dump_stack.c:106
 print_address_description+0x65/0x3a0 mm/kasan/report.c:255
 __kasan_report mm/kasan/report.c:442 [inline]
 kasan_report+0x19a/0x1f0 mm/kasan/report.c:459
 io_poll_check_events+0x994/0x9a0 fs/io_uring.c:5516
 io_apoll_task_func+0x4c/0xb10 fs/io_uring.c:5590
 io_fallback_req_func+0x118/0x1fd fs/io_uring.c:1400
 process_one_work+0x86c/0x1190 kernel/workqueue.c:2307
 worker_thread+0xab1/0x1300 kernel/workqueue.c:2454
 kthread+0x2a3/0x2d0 kernel/kthread.c:377
 ret_from_fork+0x1f/0x30
 </TASK>

Allocated by task 9351:
 kasan_save_stack mm/kasan/common.c:38 [inline]
 kasan_set_track mm/kasan/common.c:45 [inline]
 set_alloc_info mm/kasan/common.c:436 [inline]
 __kasan_slab_alloc+0xb2/0xe0 mm/kasan/common.c:469
 kasan_slab_alloc include/linux/kasan.h:260 [inline]
 slab_post_alloc_hook mm/slab.h:732 [inline]
 slab_alloc_node mm/slub.c:3230 [inline]
 kmem_cache_alloc_node+0x201/0x370 mm/slub.c:3266
 alloc_task_struct_node kernel/fork.c:171 [inline]
 dup_task_struct+0x52/0x9a0 kernel/fork.c:883
 copy_process+0x64a/0x5aa0 kernel/fork.c:1998
 kernel_clone+0x22a/0x7e0 kernel/fork.c:2555
 __do_sys_clone kernel/fork.c:2672 [inline]
 __se_sys_clone kernel/fork.c:2656 [inline]
 __x64_sys_clone+0x245/0x2b0 kernel/fork.c:2656
 do_syscall_x64 arch/x86/entry/common.c:50 [inline]
 do_syscall_64+0x44/0xd0 arch/x86/entry/common.c:80
 entry_SYSCALL_64_after_hwframe+0x44/0xae

Freed by task 2630:
 kasan_save_stack mm/kasan/common.c:38 [inline]
 kasan_set_track+0x4c/0x70 mm/kasan/common.c:45
 kasan_set_free_info+0x1f/0x40 mm/kasan/generic.c:370
 ____kasan_slab_free+0x126/0x180 mm/kasan/common.c:366
 kasan_slab_free include/linux/kasan.h:236 [inline]
 slab_free_hook mm/slub.c:1728 [inline]
 slab_free_freelist_hook+0x12e/0x1a0 mm/slub.c:1754
 slab_free mm/slub.c:3509 [inline]
 kmem_cache_free+0xb6/0x1c0 mm/slub.c:3526
 __io_req_complete_post+0x25c/0x470 fs/io_uring.c:1960
 io_req_complete_post fs/io_uring.c:1972 [inline]
 io_req_complete_failed fs/io_uring.c:2003 [inline]
 io_apoll_task_func+0x226/0xb10 fs/io_uring.c:5602
 io_fallback_req_func+0x118/0x1fd fs/io_uring.c:1400
 process_one_work+0x86c/0x1190 kernel/workqueue.c:2307
 worker_thread+0xab1/0x1300 kernel/workqueue.c:2454
 kthread+0x2a3/0x2d0 kernel/kthread.c:377
 ret_from_fork+0x1f/0x30

Last potentially related work creation:
 kasan_save_stack+0x3b/0x60 mm/kasan/common.c:38
 __kasan_record_aux_stack+0xb2/0xc0 mm/kasan/generic.c:348
 __call_rcu kernel/rcu/tree.c:3026 [inline]
 call_rcu+0x1c4/0xa70 kernel/rcu/tree.c:3106
 context_switch kernel/sched/core.c:4990 [inline]
 __schedule+0x92e/0x1080 kernel/sched/core.c:6296
 preempt_schedule_common kernel/sched/core.c:6462 [inline]
 preempt_schedule+0x14d/0x190 kernel/sched/core.c:6487
 preempt_schedule_thunk+0x16/0x18
 __raw_spin_unlock_irq include/linux/spinlock_api_smp.h:160 [inline]
 _raw_spin_unlock_irq+0x3c/0x40 kernel/locking/spinlock.c:202
 spin_unlock_irq include/linux/spinlock.h:399 [inline]
 do_group_exit+0x29f/0x2b0 kernel/exit.c:932
 __do_sys_exit_group+0x13/0x20 kernel/exit.c:946
 __ia32_sys_exit_group+0x0/0x40 kernel/exit.c:944
 __x64_sys_exit_group+0x37/0x40 kernel/exit.c:944
 do_syscall_x64 arch/x86/entry/common.c:50 [inline]
 do_syscall_64+0x44/0xd0 arch/x86/entry/common.c:80
 entry_SYSCALL_64_after_hwframe+0x44/0xae

Second to last potentially related work creation:
 kasan_save_stack+0x3b/0x60 mm/kasan/common.c:38
 __kasan_record_aux_stack+0xb2/0xc0 mm/kasan/generic.c:348
 __call_rcu kernel/rcu/tree.c:3026 [inline]
 call_rcu+0x1c4/0xa70 kernel/rcu/tree.c:3106
 put_task_struct_rcu_user kernel/exit.c:180 [inline]
 release_task+0x133b/0x15d0 kernel/exit.c:226
 wait_task_zombie kernel/exit.c:1121 [inline]
 wait_consider_task+0x1995/0x3020 kernel/exit.c:1348
 do_wait_thread kernel/exit.c:1411 [inline]
 do_wait+0x291/0x9d0 kernel/exit.c:1528
 kernel_wait4+0x2a3/0x3c0 kernel/exit.c:1691
 __do_sys_wait4 kernel/exit.c:1719 [inline]
 __se_sys_wait4 kernel/exit.c:1715 [inline]
 __x64_sys_wait4+0x130/0x1e0 kernel/exit.c:1715
 do_syscall_x64 arch/x86/entry/common.c:50 [inline]
 do_syscall_64+0x44/0xd0 arch/x86/entry/common.c:80
 entry_SYSCALL_64_after_hwframe+0x44/0xae

The buggy address belongs to the object at ffff88802452ba00
 which belongs to the cache task_struct of size 7168
The buggy address is located 44 bytes inside of
 7168-byte region [ffff88802452ba00, ffff88802452d600)
The buggy address belongs to the page:
page:ffffea0000914a00 refcount:1 mapcount:0 mapping:0000000000000000 index:0xffff888024528000 pfn:0x24528
head:ffffea0000914a00 order:3 compound_mapcount:0 compound_pincount:0
memcg:ffff88801b05ff01
flags: 0xfff00000010200(slab|head|node=0|zone=1|lastcpupid=0x7ff)
raw: 00fff00000010200 ffffea00008c1408 ffffea0001f56408 ffff888140006280
raw: ffff888024528000 0000000000040002 00000001ffffffff ffff88801b05ff01
page dumped because: kasan: bad access detected
page_owner tracks the page as allocated
page last allocated via order 3, migratetype Unmovable, gfp_mask 0xd20c0(__GFP_IO|__GFP_FS|__GFP_NOWARN|__GFP_NORETRY|__GFP_COMP|__GFP_NOMEMALLOC), pid 2, ts 12556673292, free_ts 0
 prep_new_page mm/page_alloc.c:2434 [inline]
 get_page_from_freelist+0x729/0x9e0 mm/page_alloc.c:4165
 __alloc_pages+0x255/0x580 mm/page_alloc.c:5389
 alloc_slab_page mm/slub.c:1799 [inline]
 allocate_slab+0xce/0x3f0 mm/slub.c:1944
 new_slab mm/slub.c:2004 [inline]
 ___slab_alloc+0x3fe/0xc30 mm/slub.c:3018
 __slab_alloc mm/slub.c:3105 [inline]
 slab_alloc_node mm/slub.c:3196 [inline]
 kmem_cache_alloc_node+0x2bb/0x370 mm/slub.c:3266
 alloc_task_struct_node kernel/fork.c:171 [inline]
 dup_task_struct+0x52/0x9a0 kernel/fork.c:883
 copy_process+0x64a/0x5aa0 kernel/fork.c:1998
 kernel_clone+0x22a/0x7e0 kernel/fork.c:2555
 kernel_thread+0x155/0x1d0 kernel/fork.c:2607
 create_kthread kernel/kthread.c:400 [inline]
 kthreadd+0x5b5/0x7a0 kernel/kthread.c:746
 ret_from_fork+0x1f/0x30
page_owner free stack trace missing

Memory state around the buggy address:
 ffff88802452b900: fc fc fc fc fc fc fc fc fc fc fc fc fc fc fc fc
 ffff88802452b980: fc fc fc fc fc fc fc fc fc fc fc fc fc fc fc fc
>ffff88802452ba00: fa fb fb fb fb fb fb fb fb fb fb fb fb fb fb fb
                                  ^
 ffff88802452ba80: fb fb fb fb fb fb fb fb fb fb fb fb fb fb fb fb
 ffff88802452bb00: fb fb fb fb fb fb fb fb fb fb fb fb fb fb fb fb
==================================================================


---
This report is generated by a bot. It may contain errors.
See https://goo.gl/tpsmEJ for more information about syzbot.
syzbot engineers can be reached at syzkaller@googlegroups.com.

syzbot will keep track of this issue. See:
https://goo.gl/tpsmEJ#status for how to communicate with syzbot.
