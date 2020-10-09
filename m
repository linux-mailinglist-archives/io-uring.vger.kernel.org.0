Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id D7FA52884CB
	for <lists+io-uring@lfdr.de>; Fri,  9 Oct 2020 10:02:46 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1732918AbgJIICp (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Fri, 9 Oct 2020 04:02:45 -0400
Received: from mail-io1-f79.google.com ([209.85.166.79]:39502 "EHLO
        mail-io1-f79.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1732923AbgJIICT (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Fri, 9 Oct 2020 04:02:19 -0400
Received: by mail-io1-f79.google.com with SMTP id s135so5650788ios.6
        for <io-uring@vger.kernel.org>; Fri, 09 Oct 2020 01:02:18 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:date:message-id:subject:from:to;
        bh=wjVhKiqgqTabR+ms1hyzS3BfeUzc+mXHyOkqU5qccHg=;
        b=odH91m8dxKSfL7BFZZ5lsfKu7Ab7NBe59mgTohnmuBJDvw885auaeSYu8BWmIFps2Z
         WUGZ2QoLMY6o7HlMdb7BkRRoklrIS0yT+yEJcbD8uOpYY5HrvltmAm+FvLtqHswSL6Ai
         swqf5msUssv6y6tT+qHbW834EvJ4mOmakuRdi5sKWC1Ce+rqR+vqrseQUsPTOc4VU7cb
         I6UUIt7ZWNOBu1/jYQrNEboA8ROgdyrp0Ir9RYrP0I5AwRDPKyJw/YNJODyTbl0bQ9YG
         887Zuk7iE8rsZVPeWgdDZNuXq2Zs7gLtfe2RnDzHKBcu6q7nisaTig/UUmMQEACesonO
         N5ZA==
X-Gm-Message-State: AOAM5316LMoEgcwwMJHgrYXvaN2lX94q7/0FNeL8+76QJlWpzrRNTYf1
        5CRt9LDwS6x3C3Im0qdyXC7mFFE89f5JDyYb5/uQErJbxjrt
X-Google-Smtp-Source: ABdhPJxvPML8Fq9zq1J/OM2ISnEuo4McWxii+SNAUhGQ4MOg5taScDzwaz+lZBKph82jR2BOp9UJo83i8mIGfDlVXFkK636edH8x
MIME-Version: 1.0
X-Received: by 2002:a92:c74c:: with SMTP id y12mr9899144ilp.19.1602230538625;
 Fri, 09 Oct 2020 01:02:18 -0700 (PDT)
Date:   Fri, 09 Oct 2020 01:02:18 -0700
X-Google-Appengine-App-Id: s~syzkaller
X-Google-Appengine-App-Id-Alias: syzkaller
Message-ID: <0000000000001a684d05b1385e71@google.com>
Subject: KASAN: use-after-free Read in __io_uring_files_cancel
From:   syzbot <syzbot+77efce558b2b9e6b6405@syzkaller.appspotmail.com>
To:     axboe@kernel.dk, io-uring@vger.kernel.org,
        linux-fsdevel@vger.kernel.org, linux-kernel@vger.kernel.org,
        syzkaller-bugs@googlegroups.com, viro@zeniv.linux.org.uk
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org

Hello,

syzbot found the following issue on:

HEAD commit:    e4fb79c7 Add linux-next specific files for 20201008
git tree:       linux-next
console output: https://syzkaller.appspot.com/x/log.txt?x=1592ee1b900000
kernel config:  https://syzkaller.appspot.com/x/.config?x=568d41fe4341ed0f
dashboard link: https://syzkaller.appspot.com/bug?extid=77efce558b2b9e6b6405
compiler:       gcc (GCC) 10.1.0-syz 20200507

Unfortunately, I don't have any reproducer for this issue yet.

IMPORTANT: if you fix the issue, please add the following tag to the commit:
Reported-by: syzbot+77efce558b2b9e6b6405@syzkaller.appspotmail.com

==================================================================
BUG: KASAN: use-after-free in xas_next_entry include/linux/xarray.h:1630 [inline]
BUG: KASAN: use-after-free in __io_uring_files_cancel+0x417/0x440 fs/io_uring.c:8681
Read of size 1 at addr ffff888033631880 by task syz-executor.1/8477

CPU: 1 PID: 8477 Comm: syz-executor.1 Not tainted 5.9.0-rc8-next-20201008-syzkaller #0
Hardware name: Google Google Compute Engine/Google Compute Engine, BIOS Google 01/01/2011
Call Trace:
 __dump_stack lib/dump_stack.c:77 [inline]
 dump_stack+0x198/0x1fb lib/dump_stack.c:118
 print_address_description.constprop.0.cold+0xae/0x497 mm/kasan/report.c:385
 __kasan_report mm/kasan/report.c:545 [inline]
 kasan_report.cold+0x1f/0x37 mm/kasan/report.c:562
 xas_next_entry include/linux/xarray.h:1630 [inline]
 __io_uring_files_cancel+0x417/0x440 fs/io_uring.c:8681
 io_uring_files_cancel include/linux/io_uring.h:35 [inline]
 exit_files+0xe4/0x170 fs/file.c:456
 do_exit+0xae9/0x2930 kernel/exit.c:801
 do_group_exit+0x125/0x310 kernel/exit.c:903
 get_signal+0x428/0x1f00 kernel/signal.c:2757
 arch_do_signal+0x82/0x2470 arch/x86/kernel/signal.c:811
 exit_to_user_mode_loop kernel/entry/common.c:161 [inline]
 exit_to_user_mode_prepare+0x194/0x1f0 kernel/entry/common.c:192
 syscall_exit_to_user_mode+0x7a/0x2c0 kernel/entry/common.c:267
 entry_SYSCALL_64_after_hwframe+0x44/0xa9
RIP: 0033:0x45de29
Code: Unable to access opcode bytes at RIP 0x45ddff.
RSP: 002b:00007f887aa8fcf8 EFLAGS: 00000246 ORIG_RAX: 00000000000000ca
RAX: fffffffffffffe00 RBX: 000000000118bf28 RCX: 000000000045de29
RDX: 0000000000000000 RSI: 0000000000000080 RDI: 000000000118bf28
RBP: 000000000118bf20 R08: 0000000000000000 R09: 0000000000000000
R10: 0000000000000000 R11: 0000000000000246 R12: 000000000118bf2c
R13: 00007ffe3a42135f R14: 00007f887aa909c0 R15: 000000000118bf2c

Allocated by task 8477:
 kasan_save_stack+0x1b/0x40 mm/kasan/common.c:48
 kasan_set_track mm/kasan/common.c:56 [inline]
 __kasan_kmalloc.constprop.0+0xbf/0xd0 mm/kasan/common.c:461
 slab_post_alloc_hook mm/slab.h:514 [inline]
 slab_alloc mm/slab.c:3314 [inline]
 kmem_cache_alloc+0x162/0x550 mm/slab.c:3484
 xas_alloc+0x330/0x440 lib/xarray.c:374
 xas_create+0x2db/0x1020 lib/xarray.c:676
 xas_store+0x8a/0x1bb0 lib/xarray.c:784
 io_uring_add_task_file fs/io_uring.c:8608 [inline]
 io_uring_add_task_file+0x212/0x430 fs/io_uring.c:8590
 io_uring_get_fd fs/io_uring.c:9116 [inline]
 io_uring_create fs/io_uring.c:9280 [inline]
 io_uring_setup+0x2727/0x3660 fs/io_uring.c:9314
 do_syscall_64+0x2d/0x70 arch/x86/entry/common.c:46
 entry_SYSCALL_64_after_hwframe+0x44/0xa9

Freed by task 6907:
 kasan_save_stack+0x1b/0x40 mm/kasan/common.c:48
 kasan_set_track+0x1c/0x30 mm/kasan/common.c:56
 kasan_set_free_info+0x1b/0x30 mm/kasan/generic.c:355
 __kasan_slab_free+0xd8/0x120 mm/kasan/common.c:422
 __cache_free mm/slab.c:3420 [inline]
 kmem_cache_free.part.0+0x74/0x1d0 mm/slab.c:3695
 rcu_do_batch kernel/rcu/tree.c:2484 [inline]
 rcu_core+0x645/0x1240 kernel/rcu/tree.c:2718
 __do_softirq+0x203/0xab6 kernel/softirq.c:298

Last call_rcu():
 kasan_save_stack+0x1b/0x40 mm/kasan/common.c:48
 kasan_record_aux_stack+0x82/0xb0 mm/kasan/generic.c:346
 __call_rcu kernel/rcu/tree.c:2960 [inline]
 call_rcu+0x15e/0x7d0 kernel/rcu/tree.c:3033
 xa_node_free lib/xarray.c:258 [inline]
 xas_delete_node lib/xarray.c:494 [inline]
 update_node lib/xarray.c:756 [inline]
 xas_store+0xbcc/0x1bb0 lib/xarray.c:841
 io_uring_del_task_file+0x105/0x1a0 fs/io_uring.c:8630
 __io_uring_files_cancel+0x3dd/0x440 fs/io_uring.c:8691
 io_uring_files_cancel include/linux/io_uring.h:35 [inline]
 exit_files+0xe4/0x170 fs/file.c:456
 do_exit+0xae9/0x2930 kernel/exit.c:801
 do_group_exit+0x125/0x310 kernel/exit.c:903
 get_signal+0x428/0x1f00 kernel/signal.c:2757
 arch_do_signal+0x82/0x2470 arch/x86/kernel/signal.c:811
 exit_to_user_mode_loop kernel/entry/common.c:161 [inline]
 exit_to_user_mode_prepare+0x194/0x1f0 kernel/entry/common.c:192
 syscall_exit_to_user_mode+0x7a/0x2c0 kernel/entry/common.c:267
 entry_SYSCALL_64_after_hwframe+0x44/0xa9

Second to last call_rcu():
 kasan_save_stack+0x1b/0x40 mm/kasan/common.c:48
 kasan_record_aux_stack+0x82/0xb0 mm/kasan/generic.c:346
 __call_rcu kernel/rcu/tree.c:2960 [inline]
 call_rcu+0x15e/0x7d0 kernel/rcu/tree.c:3033
 radix_tree_node_free lib/radix-tree.c:308 [inline]
 delete_node+0xef/0x8c0 lib/radix-tree.c:571
 __radix_tree_delete+0x190/0x370 lib/radix-tree.c:1377
 radix_tree_delete_item+0xe7/0x230 lib/radix-tree.c:1428
 free_pid+0x9b/0x260 kernel/pid.c:152
 __change_pid+0x1c7/0x2d0 kernel/pid.c:353
 __unhash_process kernel/exit.c:76 [inline]
 __exit_signal kernel/exit.c:147 [inline]
 release_task+0xd1c/0x14d0 kernel/exit.c:198
 exit_notify kernel/exit.c:681 [inline]
 do_exit+0x143f/0x2930 kernel/exit.c:826
 call_usermodehelper_exec_async+0x413/0x580 kernel/umh.c:123
 ret_from_fork+0x1f/0x30 arch/x86/entry/entry_64.S:296

The buggy address belongs to the object at ffff888033631880
 which belongs to the cache radix_tree_node of size 576
The buggy address is located 0 bytes inside of
 576-byte region [ffff888033631880, ffff888033631ac0)
The buggy address belongs to the page:
page:00000000c45adbd1 refcount:1 mapcount:0 mapping:0000000000000000 index:0xffff888033631ffb pfn:0x33631
flags: 0xfffe0000000200(slab)
raw: 00fffe0000000200 ffffea0000cd8908 ffffea0000cd8488 ffff88800ec6f000
raw: ffff888033631ffb ffff888033631040 0000000100000005 0000000000000000
page dumped because: kasan: bad access detected

Memory state around the buggy address:
 ffff888033631780: 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00
 ffff888033631800: fc fc fc fc fc fc fc fc fc fc fc fc fc fc fc fc
>ffff888033631880: fa fb fb fb fb fb fb fb fb fb fb fb fb fb fb fb
                   ^
 ffff888033631900: fb fb fb fb fb fb fb fb fb fb fb fb fb fb fb fb
 ffff888033631980: fb fb fb fb fb fb fb fb fb fb fb fb fb fb fb fb
==================================================================


---
This report is generated by a bot. It may contain errors.
See https://goo.gl/tpsmEJ for more information about syzbot.
syzbot engineers can be reached at syzkaller@googlegroups.com.

syzbot will keep track of this issue. See:
https://goo.gl/tpsmEJ#status for how to communicate with syzbot.
