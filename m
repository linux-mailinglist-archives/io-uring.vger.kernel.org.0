Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 7DEAF3253FB
	for <lists+io-uring@lfdr.de>; Thu, 25 Feb 2021 17:50:30 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233603AbhBYQuB (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Thu, 25 Feb 2021 11:50:01 -0500
Received: from mail-il1-f200.google.com ([209.85.166.200]:39859 "EHLO
        mail-il1-f200.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233454AbhBYQsF (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Thu, 25 Feb 2021 11:48:05 -0500
Received: by mail-il1-f200.google.com with SMTP id g14so4772094ilb.6
        for <io-uring@vger.kernel.org>; Thu, 25 Feb 2021 08:47:48 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:date:message-id:subject:from:to;
        bh=KLzSL1b6FT2V1YojiYBz1dYOvRuvevGZ/eoF31S1Iy8=;
        b=awMbGxOSE2kO4xFjIBMlsAygdzURarpIvRKGNnS04eUYXKcj7kVNAX4co0i/993eHD
         9OzHmzvIth4ycspZHwQgd9uThK81SJ+2b9EYaxeAAOJ+/52ffn6QY7pVIzfuVX/t1cbI
         V6xI8/oV1+KwsXyahI8J2uJ9Dt3X94sry2K1DIK2u9plRFlnergdj3i/kC2hbtKkyK15
         vmQMEwJcdyf/qUXke5pxgWujTcRlYc3VMh8tD5SJ5jVmkyOh3pUZ6J5Lg3lw0PY0mGXJ
         FhT911Jaq2kXL/jDRm1RN5LQQY46T05HIzUzJLxRefq7EVKnLQkzxiL/okpR6MpjuoK7
         EVLg==
X-Gm-Message-State: AOAM5303FLn5PObzAN5ArHHFBgSaBfY/0E0f2GQxCSjtB8JGqf0UE5yi
        YttY/c6hXJUxVg+0dFYmV32XV1d6KMpX5USX7UWba9YAVK+A
X-Google-Smtp-Source: ABdhPJwRkP/TlDR0wn3uFHK5d7AkLML2A84vf/rmRqvlFo2wxguRFCqS7mB7j6a6KroeNpWgn3EP3xl0qWuUeGI+Onb8EJkPswcv
MIME-Version: 1.0
X-Received: by 2002:a05:6638:189:: with SMTP id a9mr3512182jaq.22.1614271643076;
 Thu, 25 Feb 2021 08:47:23 -0800 (PST)
Date:   Thu, 25 Feb 2021 08:47:23 -0800
X-Google-Appengine-App-Id: s~syzkaller
X-Google-Appengine-App-Id-Alias: syzkaller
Message-ID: <000000000000db4fe805bc2be7fc@google.com>
Subject: KASAN: use-after-free Read in try_to_wake_up
From:   syzbot <syzbot+7bf785eedca35ca05501@syzkaller.appspotmail.com>
To:     asml.silence@gmail.com, axboe@kernel.dk, christian@brauner.io,
        io-uring@vger.kernel.org, linux-kernel@vger.kernel.org,
        syzkaller-bugs@googlegroups.com
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org

Hello,

syzbot found the following issue on:

HEAD commit:    577c2835 Add linux-next specific files for 20210224
git tree:       linux-next
console output: https://syzkaller.appspot.com/x/log.txt?x=1586e0dad00000
kernel config:  https://syzkaller.appspot.com/x/.config?x=e9bb3d369b3bf49
dashboard link: https://syzkaller.appspot.com/bug?extid=7bf785eedca35ca05501
syz repro:      https://syzkaller.appspot.com/x/repro.syz?x=16609646d00000
C reproducer:   https://syzkaller.appspot.com/x/repro.c?x=1529c5a8d00000

IMPORTANT: if you fix the issue, please add the following tag to the commit:
Reported-by: syzbot+7bf785eedca35ca05501@syzkaller.appspotmail.com

==================================================================
BUG: KASAN: use-after-free in __lock_acquire+0x3e6f/0x54c0 kernel/locking/lockdep.c:4770
Read of size 8 at addr ffff888030dc08d0 by task syz-executor199/9383

CPU: 1 PID: 9383 Comm: syz-executor199 Not tainted 5.11.0-next-20210224-syzkaller #0
Hardware name: Google Google Compute Engine/Google Compute Engine, BIOS Google 01/01/2011
Call Trace:
 __dump_stack lib/dump_stack.c:79 [inline]
 dump_stack+0xfa/0x151 lib/dump_stack.c:120
 print_address_description.constprop.0.cold+0x5b/0x2f8 mm/kasan/report.c:232
 __kasan_report mm/kasan/report.c:399 [inline]
 kasan_report.cold+0x7c/0xd8 mm/kasan/report.c:416
 __lock_acquire+0x3e6f/0x54c0 kernel/locking/lockdep.c:4770
 lock_acquire kernel/locking/lockdep.c:5510 [inline]
 lock_acquire+0x1ab/0x730 kernel/locking/lockdep.c:5475
 __raw_spin_lock_irqsave include/linux/spinlock_api_smp.h:110 [inline]
 _raw_spin_lock_irqsave+0x39/0x50 kernel/locking/spinlock.c:159
 try_to_wake_up+0x98/0x14a0 kernel/sched/core.c:3347
 io_wq_destroy+0x74/0x3d0 fs/io-wq.c:1013
 __io_uring_files_cancel+0x195/0x230 fs/io_uring.c:8810
 io_uring_files_cancel include/linux/io_uring.h:47 [inline]
 do_exit+0x299/0x2a60 kernel/exit.c:780
 do_group_exit+0x125/0x310 kernel/exit.c:922
 __do_sys_exit_group kernel/exit.c:933 [inline]
 __se_sys_exit_group kernel/exit.c:931 [inline]
 __x64_sys_exit_group+0x3a/0x50 kernel/exit.c:931
 do_syscall_64+0x2d/0x70 arch/x86/entry/common.c:46
 entry_SYSCALL_64_after_hwframe+0x44/0xae
RIP: 0033:0x43e989
Code: 00 49 c7 c0 c0 ff ff ff be e7 00 00 00 ba 3c 00 00 00 eb 12 0f 1f 44 00 00 89 d0 0f 05 48 3d 00 f0 ff ff 77 1c f4 89 f0 0f 05 <48> 3d 00 f0 ff ff 76 e7 f7 d8 64 41 89 00 eb df 0f 1f 80 00 00 00
RSP: 002b:00007ffe3a2de828 EFLAGS: 00000246 ORIG_RAX: 00000000000000e7
RAX: ffffffffffffffda RBX: 00000000004b02f0 RCX: 000000000043e989
RDX: 000000000000003c RSI: 00000000000000e7 RDI: 0000000000000000
RBP: 0000000000000000 R08: ffffffffffffffc0 R09: 0000000010000000
R10: 0000000000008011 R11: 0000000000000246 R12: 00000000004b02f0
R13: 0000000000000001 R14: 0000000000000000 R15: 0000000000000001

Allocated by task 9383:
 kasan_save_stack+0x1b/0x40 mm/kasan/common.c:38
 kasan_set_track mm/kasan/common.c:46 [inline]
 set_alloc_info mm/kasan/common.c:427 [inline]
 __kasan_slab_alloc+0x75/0x90 mm/kasan/common.c:460
 kasan_slab_alloc include/linux/kasan.h:223 [inline]
 slab_post_alloc_hook mm/slab.h:516 [inline]
 slab_alloc_node mm/slub.c:2907 [inline]
 kmem_cache_alloc_node+0x16d/0x3c0 mm/slub.c:2943
 alloc_task_struct_node kernel/fork.c:170 [inline]
 dup_task_struct kernel/fork.c:860 [inline]
 copy_process+0x613/0x6fd0 kernel/fork.c:1940
 kernel_clone+0xe7/0xab0 kernel/fork.c:2462
 io_wq_fork_thread+0xa7/0xe0 fs/io-wq.c:601
 io_wq_create+0x81c/0xab0 fs/io-wq.c:985
 io_init_wq_offload fs/io_uring.c:7779 [inline]
 io_uring_alloc_task_context+0x185/0x510 fs/io_uring.c:7798
 io_uring_add_task_file+0x261/0x350 fs/io_uring.c:8737
 io_uring_install_fd fs/io_uring.c:9336 [inline]
 io_uring_create fs/io_uring.c:9487 [inline]
 io_uring_setup+0x14c7/0x2c20 fs/io_uring.c:9526
 do_syscall_64+0x2d/0x70 arch/x86/entry/common.c:46
 entry_SYSCALL_64_after_hwframe+0x44/0xae

Freed by task 12:
 kasan_save_stack+0x1b/0x40 mm/kasan/common.c:38
 kasan_set_track+0x1c/0x30 mm/kasan/common.c:46
 kasan_set_free_info+0x20/0x30 mm/kasan/generic.c:357
 ____kasan_slab_free mm/kasan/common.c:360 [inline]
 ____kasan_slab_free mm/kasan/common.c:325 [inline]
 __kasan_slab_free+0xf5/0x130 mm/kasan/common.c:367
 kasan_slab_free include/linux/kasan.h:199 [inline]
 slab_free_hook mm/slub.c:1562 [inline]
 slab_free_freelist_hook+0x72/0x1b0 mm/slub.c:1600
 slab_free mm/slub.c:3161 [inline]
 kmem_cache_free+0x8b/0x730 mm/slub.c:3177
 __put_task_struct+0x267/0x3f0 kernel/fork.c:742
 put_task_struct include/linux/sched/task.h:111 [inline]
 delayed_put_task_struct+0x1f6/0x340 kernel/exit.c:173
 rcu_do_batch kernel/rcu/tree.c:2559 [inline]
 rcu_core+0x722/0x1280 kernel/rcu/tree.c:2794
 __do_softirq+0x29b/0x9f6 kernel/softirq.c:345

Last potentially related work creation:
 kasan_save_stack+0x1b/0x40 mm/kasan/common.c:38
 kasan_record_aux_stack+0xe5/0x110 mm/kasan/generic.c:345
 __call_rcu kernel/rcu/tree.c:3039 [inline]
 call_rcu+0xb1/0x700 kernel/rcu/tree.c:3114
 put_task_struct_rcu_user+0x7f/0xb0 kernel/exit.c:179
 context_switch kernel/sched/core.c:4327 [inline]
 __schedule+0x914/0x21a0 kernel/sched/core.c:5075
 preempt_schedule_common+0x45/0xc0 kernel/sched/core.c:5235
 preempt_schedule_thunk+0x16/0x18 arch/x86/entry/thunk_64.S:35
 __raw_spin_unlock_irqrestore include/linux/spinlock_api_smp.h:161 [inline]
 _raw_spin_unlock_irqrestore+0x46/0x50 kernel/locking/spinlock.c:191
 io_wq_manager+0x13c/0x5b0 fs/io-wq.c:715
 ret_from_fork+0x1f/0x30 arch/x86/entry/entry_64.S:294

The buggy address belongs to the object at ffff888030dc0000
 which belongs to the cache task_struct of size 6912
The buggy address is located 2256 bytes inside of
 6912-byte region [ffff888030dc0000, ffff888030dc1b00)
The buggy address belongs to the page:
page:00000000deb921bd refcount:1 mapcount:0 mapping:0000000000000000 index:0x0 pfn:0x30dc0
head:00000000deb921bd order:3 compound_mapcount:0 compound_pincount:0
flags: 0xfff00000010200(slab|head)
raw: 00fff00000010200 dead000000000100 dead000000000122 ffff888140004000
raw: 0000000000000000 0000000080040004 00000001ffffffff 0000000000000000
page dumped because: kasan: bad access detected

Memory state around the buggy address:
 ffff888030dc0780: fb fb fb fb fb fb fb fb fb fb fb fb fb fb fb fb
 ffff888030dc0800: fb fb fb fb fb fb fb fb fb fb fb fb fb fb fb fb
>ffff888030dc0880: fb fb fb fb fb fb fb fb fb fb fb fb fb fb fb fb
                                                 ^
 ffff888030dc0900: fb fb fb fb fb fb fb fb fb fb fb fb fb fb fb fb
 ffff888030dc0980: fb fb fb fb fb fb fb fb fb fb fb fb fb fb fb fb
==================================================================


---
This report is generated by a bot. It may contain errors.
See https://goo.gl/tpsmEJ for more information about syzbot.
syzbot engineers can be reached at syzkaller@googlegroups.com.

syzbot will keep track of this issue. See:
https://goo.gl/tpsmEJ#status for how to communicate with syzbot.
syzbot can test patches for this issue, for details see:
https://goo.gl/tpsmEJ#testing-patches
