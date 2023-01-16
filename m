Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id AFF0866B757
	for <lists+io-uring@lfdr.de>; Mon, 16 Jan 2023 07:12:56 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231947AbjAPGMw (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Mon, 16 Jan 2023 01:12:52 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:52220 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232070AbjAPGMd (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Mon, 16 Jan 2023 01:12:33 -0500
Received: from mail-io1-f72.google.com (mail-io1-f72.google.com [209.85.166.72])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 7A402A277
        for <io-uring@vger.kernel.org>; Sun, 15 Jan 2023 22:11:38 -0800 (PST)
Received: by mail-io1-f72.google.com with SMTP id d24-20020a5d9bd8000000b006ee2ddf6d77so17067241ion.6
        for <io-uring@vger.kernel.org>; Sun, 15 Jan 2023 22:11:38 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=to:from:subject:message-id:date:mime-version:x-gm-message-state
         :from:to:cc:subject:date:message-id:reply-to;
        bh=zkSMvX6rVJKCcqoDql0XlKX2nT9Z3jmJcEZLt5iBVTA=;
        b=xsGTtHDzCjtEiouUCs3LZwkuS2PNUyjkP7S4AEyxuo0s8YcDFwICZxdtTZEeE4CLUH
         45SmHLHB12SVK68j0x3RFq9UA/7MZD4QV+E42f4jGbshM9qFpbXSMtAJZt4Pkb4rB05b
         jj3L9jnvhR59ObsKHu++CBCmKAYPexeplsGWYGknUZ2ejhErSNWVP1vKV4h2jbPAbAMk
         0c83e4KbqdGbQpeEB1Q6VZ0jDtv0RyCNorRIxUx+indyOulBwHhMBXintIeg7q7WPIeJ
         ns/qwGMfdURga5DJXTrxhWLJA5+VnHQtWGJK9Sx7aW8Ai5/Jv4+bHm+9SwShoD/aeR+W
         Hozg==
X-Gm-Message-State: AFqh2koLOVM8U3qCSiI64SR96VFoqYHjgXTzwVBcoqBI5NcOTdgaHf+H
        wQeBLqY/SRbk4TakIqzlwzqduCDY92+m0imP7GOXnKAaFmRz
X-Google-Smtp-Source: AMrXdXsZ9hdUoIUmsPXRqU0tp+Fa+qnotRkQKHaHyI1IFdVsqxuJOCcRHjXd+1snOl5WkrYDHMDZZ09LBJAHhNjbi26LFslz8NBr
MIME-Version: 1.0
X-Received: by 2002:a02:8541:0:b0:3a1:bc4e:e164 with SMTP id
 g59-20020a028541000000b003a1bc4ee164mr501166jai.18.1673849497842; Sun, 15 Jan
 2023 22:11:37 -0800 (PST)
Date:   Sun, 15 Jan 2023 22:11:37 -0800
X-Google-Appengine-App-Id: s~syzkaller
X-Google-Appengine-App-Id-Alias: syzkaller
Message-ID: <000000000000b9f9fd05f25b74ff@google.com>
Subject: [syzbot] KASAN: use-after-free Read in io_poll_task_func
From:   syzbot <syzbot+cb95143d1d4d788c1941@syzkaller.appspotmail.com>
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

HEAD commit:    0a093b2893c7 Add linux-next specific files for 20230112
git tree:       linux-next
console output: https://syzkaller.appspot.com/x/log.txt?x=12fcd936480000
kernel config:  https://syzkaller.appspot.com/x/.config?x=835f3591019836d5
dashboard link: https://syzkaller.appspot.com/bug?extid=cb95143d1d4d788c1941
compiler:       gcc (Debian 10.2.1-6) 10.2.1 20210110, GNU ld (GNU Binutils for Debian) 2.35.2

Unfortunately, I don't have any reproducer for this issue yet.

Downloadable assets:
disk image: https://storage.googleapis.com/syzbot-assets/8111a570d6cb/disk-0a093b28.raw.xz
vmlinux: https://storage.googleapis.com/syzbot-assets/ecc135b7fc9a/vmlinux-0a093b28.xz
kernel image: https://storage.googleapis.com/syzbot-assets/ca8d73b446ea/bzImage-0a093b28.xz

IMPORTANT: if you fix the issue, please add the following tag to the commit:
Reported-by: syzbot+cb95143d1d4d788c1941@syzkaller.appspotmail.com

==================================================================
BUG: KASAN: use-after-free in io_poll_check_events io_uring/poll.c:244 [inline]
BUG: KASAN: use-after-free in io_poll_task_func+0xf77/0x1220 io_uring/poll.c:327
Read of size 4 at addr ffff888085e21d6c by task kworker/1:8/5241

CPU: 1 PID: 5241 Comm: kworker/1:8 Not tainted 6.2.0-rc3-next-20230112-syzkaller #0
Hardware name: Google Google Compute Engine/Google Compute Engine, BIOS Google 10/26/2022
Workqueue: events io_fallback_req_func
Call Trace:
 <TASK>
 __dump_stack lib/dump_stack.c:88 [inline]
 dump_stack_lvl+0xd1/0x138 lib/dump_stack.c:106
 print_address_description mm/kasan/report.c:306 [inline]
 print_report+0x15e/0x45d mm/kasan/report.c:417
 kasan_report+0xc0/0xf0 mm/kasan/report.c:517
 io_poll_check_events io_uring/poll.c:244 [inline]
 io_poll_task_func+0xf77/0x1220 io_uring/poll.c:327
 io_fallback_req_func+0xfd/0x204 io_uring/io_uring.c:252
 process_one_work+0x9bf/0x1750 kernel/workqueue.c:2293
 worker_thread+0x669/0x1090 kernel/workqueue.c:2440
 kthread+0x2e8/0x3a0 kernel/kthread.c:376
 ret_from_fork+0x1f/0x30 arch/x86/entry/entry_64.S:308
 </TASK>

Allocated by task 22336:
 kasan_save_stack+0x22/0x40 mm/kasan/common.c:45
 kasan_set_track+0x25/0x30 mm/kasan/common.c:52
 __kasan_slab_alloc+0x7f/0x90 mm/kasan/common.c:325
 kasan_slab_alloc include/linux/kasan.h:186 [inline]
 slab_post_alloc_hook mm/slab.h:769 [inline]
 slab_alloc_node mm/slub.c:3452 [inline]
 kmem_cache_alloc_node+0x183/0x350 mm/slub.c:3497
 alloc_task_struct_node kernel/fork.c:171 [inline]
 dup_task_struct kernel/fork.c:979 [inline]
 copy_process+0x3aa/0x7740 kernel/fork.c:2103
 kernel_clone+0xeb/0x9a0 kernel/fork.c:2687
 __do_sys_clone+0xba/0x100 kernel/fork.c:2828
 do_syscall_x64 arch/x86/entry/common.c:50 [inline]
 do_syscall_64+0x39/0xb0 arch/x86/entry/common.c:80
 entry_SYSCALL_64_after_hwframe+0x63/0xcd

Freed by task 5241:
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
 put_task_struct_many include/linux/sched/task.h:125 [inline]
 __io_put_task+0x155/0x1e0 io_uring/io_uring.c:725
 io_put_task io_uring/io_uring.h:328 [inline]
 __io_req_complete_post+0x7ac/0xcd0 io_uring/io_uring.c:978
 io_req_complete_post+0xf1/0x1a0 io_uring/io_uring.c:992
 io_req_task_complete+0x189/0x260 io_uring/io_uring.c:1623
 io_poll_task_func+0xa95/0x1220 io_uring/poll.c:347
 io_fallback_req_func+0xfd/0x204 io_uring/io_uring.c:252
 process_one_work+0x9bf/0x1750 kernel/workqueue.c:2293
 worker_thread+0x669/0x1090 kernel/workqueue.c:2440
 kthread+0x2e8/0x3a0 kernel/kthread.c:376
 ret_from_fork+0x1f/0x30 arch/x86/entry/entry_64.S:308

Last potentially related work creation:
 kasan_save_stack+0x22/0x40 mm/kasan/common.c:45
 __kasan_record_aux_stack+0xbc/0xd0 mm/kasan/generic.c:488
 __call_rcu_common.constprop.0+0x99/0x780 kernel/rcu/tree.c:2622
 put_task_struct_rcu_user+0x83/0xc0 kernel/exit.c:231
 context_switch kernel/sched/core.c:5304 [inline]
 __schedule+0x25d8/0x5a70 kernel/sched/core.c:6619
 preempt_schedule_common+0x45/0xc0 kernel/sched/core.c:6788
 preempt_schedule_thunk+0x1a/0x20 arch/x86/entry/thunk_64.S:34
 __raw_spin_unlock_irq include/linux/spinlock_api_smp.h:160 [inline]
 _raw_spin_unlock_irq+0x40/0x50 kernel/locking/spinlock.c:202
 spin_unlock_irq include/linux/spinlock.h:400 [inline]
 do_group_exit+0x1c5/0x2a0 kernel/exit.c:1009
 __do_sys_exit_group kernel/exit.c:1023 [inline]
 __se_sys_exit_group kernel/exit.c:1021 [inline]
 __x64_sys_exit_group+0x3e/0x50 kernel/exit.c:1021
 do_syscall_x64 arch/x86/entry/common.c:50 [inline]
 do_syscall_64+0x39/0xb0 arch/x86/entry/common.c:80
 entry_SYSCALL_64_after_hwframe+0x63/0xcd

Second to last potentially related work creation:
 kasan_save_stack+0x22/0x40 mm/kasan/common.c:45
 __kasan_record_aux_stack+0xbc/0xd0 mm/kasan/generic.c:488
 __call_rcu_common.constprop.0+0x99/0x780 kernel/rcu/tree.c:2622
 put_task_struct_rcu_user+0x83/0xc0 kernel/exit.c:231
 release_task+0xcc8/0x1870 kernel/exit.c:281
 wait_task_zombie kernel/exit.c:1198 [inline]
 wait_consider_task+0x306d/0x3ce0 kernel/exit.c:1425
 do_wait_thread kernel/exit.c:1488 [inline]
 do_wait+0x7cd/0xd90 kernel/exit.c:1605
 kernel_wait4+0x150/0x260 kernel/exit.c:1768
 __do_sys_wait4+0x13f/0x150 kernel/exit.c:1796
 do_syscall_x64 arch/x86/entry/common.c:50 [inline]
 do_syscall_64+0x39/0xb0 arch/x86/entry/common.c:80
 entry_SYSCALL_64_after_hwframe+0x63/0xcd

The buggy address belongs to the object at ffff888085e21d40
 which belongs to the cache task_struct of size 7232
The buggy address is located 44 bytes inside of
 7232-byte region [ffff888085e21d40, ffff888085e23980)

The buggy address belongs to the physical page:
page:ffffea0002178800 refcount:1 mapcount:0 mapping:0000000000000000 index:0x0 pfn:0x85e20
head:ffffea0002178800 order:3 entire_mapcount:0 nr_pages_mapped:0 pincount:0
memcg:ffff88802a511441
anon flags: 0xfff00000010200(slab|head|node=0|zone=1|lastcpupid=0x7ff)
raw: 00fff00000010200 ffff8880125ec500 0000000000000000 0000000000000001
raw: 0000000000000000 0000000000040004 00000001ffffffff ffff88802a511441
page dumped because: kasan: bad access detected
page_owner tracks the page as allocated
page last allocated via order 3, migratetype Unmovable, gfp_mask 0x1d20c0(__GFP_IO|__GFP_FS|__GFP_NOWARN|__GFP_NORETRY|__GFP_COMP|__GFP_NOMEMALLOC|__GFP_HARDWALL), pid 5140, tgid 5140 (syz-executor.4), ts 940002279505, free_ts 939439685406
 prep_new_page mm/page_alloc.c:2549 [inline]
 get_page_from_freelist+0x11bb/0x2d50 mm/page_alloc.c:4324
 __alloc_pages+0x1cb/0x5c0 mm/page_alloc.c:5590
 alloc_pages+0x1aa/0x270 mm/mempolicy.c:2281
 alloc_slab_page mm/slub.c:1851 [inline]
 allocate_slab+0x25f/0x350 mm/slub.c:1998
 new_slab mm/slub.c:2051 [inline]
 ___slab_alloc+0xa91/0x1400 mm/slub.c:3193
 __slab_alloc.constprop.0+0x56/0xa0 mm/slub.c:3292
 __slab_alloc_node mm/slub.c:3345 [inline]
 slab_alloc_node mm/slub.c:3442 [inline]
 kmem_cache_alloc_node+0x136/0x350 mm/slub.c:3497
 alloc_task_struct_node kernel/fork.c:171 [inline]
 dup_task_struct kernel/fork.c:979 [inline]
 copy_process+0x3aa/0x7740 kernel/fork.c:2103
 kernel_clone+0xeb/0x9a0 kernel/fork.c:2687
 __do_sys_clone+0xba/0x100 kernel/fork.c:2828
 do_syscall_x64 arch/x86/entry/common.c:50 [inline]
 do_syscall_64+0x39/0xb0 arch/x86/entry/common.c:80
 entry_SYSCALL_64_after_hwframe+0x63/0xcd
page last free stack trace:
 reset_page_owner include/linux/page_owner.h:24 [inline]
 free_pages_prepare mm/page_alloc.c:1451 [inline]
 free_pcp_prepare+0x4d0/0x910 mm/page_alloc.c:1501
 free_unref_page_prepare mm/page_alloc.c:3387 [inline]
 free_unref_page+0x1d/0x490 mm/page_alloc.c:3482
 __unfreeze_partials+0x17c/0x1a0 mm/slub.c:2637
 qlink_free mm/kasan/quarantine.c:168 [inline]
 qlist_free_all+0x6a/0x170 mm/kasan/quarantine.c:187
 kasan_quarantine_reduce+0x192/0x220 mm/kasan/quarantine.c:294
 __kasan_slab_alloc+0x63/0x90 mm/kasan/common.c:302
 kasan_slab_alloc include/linux/kasan.h:186 [inline]
 slab_post_alloc_hook mm/slab.h:769 [inline]
 slab_alloc_node mm/slub.c:3452 [inline]
 slab_alloc mm/slub.c:3460 [inline]
 __kmem_cache_alloc_lru mm/slub.c:3467 [inline]
 kmem_cache_alloc+0x175/0x320 mm/slub.c:3476
 getname_flags.part.0+0x50/0x4f0 fs/namei.c:140
 getname_flags include/linux/audit.h:320 [inline]
 getname+0x92/0xd0 fs/namei.c:219
 do_sys_openat2+0xf5/0x4c0 fs/open.c:1305
 do_sys_open fs/open.c:1327 [inline]
 __do_sys_openat fs/open.c:1343 [inline]
 __se_sys_openat fs/open.c:1338 [inline]
 __x64_sys_openat+0x143/0x1f0 fs/open.c:1338
 do_syscall_x64 arch/x86/entry/common.c:50 [inline]
 do_syscall_64+0x39/0xb0 arch/x86/entry/common.c:80
 entry_SYSCALL_64_after_hwframe+0x63/0xcd

Memory state around the buggy address:
 ffff888085e21c00: fb fb fb fb fb fb fb fb fc fc fc fc fc fc fc fc
 ffff888085e21c80: fc fc fc fc fc fc fc fc fc fc fc fc fc fc fc fc
>ffff888085e21d00: fc fc fc fc fc fc fc fc fa fb fb fb fb fb fb fb
                                                          ^
 ffff888085e21d80: fb fb fb fb fb fb fb fb fb fb fb fb fb fb fb fb
 ffff888085e21e00: fb fb fb fb fb fb fb fb fb fb fb fb fb fb fb fb
==================================================================


---
This report is generated by a bot. It may contain errors.
See https://goo.gl/tpsmEJ for more information about syzbot.
syzbot engineers can be reached at syzkaller@googlegroups.com.

syzbot will keep track of this issue. See:
https://goo.gl/tpsmEJ#status for how to communicate with syzbot.
