Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 5E9C42423FD
	for <lists+io-uring@lfdr.de>; Wed, 12 Aug 2020 04:16:21 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726402AbgHLCQU (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Tue, 11 Aug 2020 22:16:20 -0400
Received: from mail-il1-f200.google.com ([209.85.166.200]:56710 "EHLO
        mail-il1-f200.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726173AbgHLCQT (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Tue, 11 Aug 2020 22:16:19 -0400
Received: by mail-il1-f200.google.com with SMTP id x15so696214ilg.23
        for <io-uring@vger.kernel.org>; Tue, 11 Aug 2020 19:16:18 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:date:message-id:subject:from:to;
        bh=NNCxy25Gvyij/389iQlJ89u2Pz3SqdiYvWLTR0AE4O8=;
        b=Hq8GJvN1BqFCzFAJkN0fjzZ0NNwc8EcycykHGywkalerMGFpObdmhr8zZ3Lq4sAkCP
         Y5J2Ik3HP1FDGwqtQJwee/ftl3tYHjID1ix/JXmwNQRoe3sP6WfEreTeQOZ8Sy7NDSP7
         HrnTuLqccX2K8u0uJNhWAbyBSWHqnCUBer2RI2iGGf3I78O6BpJm+BoCRk3RFQYLu1mM
         cmx3EXk3WNpCeetsJFO9dh3ddLNfs/BexO14QSE7PH7SnooMe+Br56KxNdvSYPkqrOWf
         /8r5pKuM6sQs/nJu8Db1OykdfuPFPvCE7+ZkZaNpnO6xPXcQ4/nKuvK3WpfHS+thQdM4
         y7+A==
X-Gm-Message-State: AOAM530cjelYV8Iz9CByhnASstpxofcwEORi3aYctIHX1vz1vT/W9x/D
        FuszPU9g4oEYbE7CW4OqDzHPSKcIV0KbHTDlpAuHlWsd0La0
X-Google-Smtp-Source: ABdhPJwNMFFhKuLifgs5sVAm3qlVQwWlzTLqn0XgcmQt3wpKSQlnCTt43sGaeI0lxHeABUahCY05/+sVSYHLc70+VvLMIZfwntuY
MIME-Version: 1.0
X-Received: by 2002:a02:dc3:: with SMTP id 186mr28483226jax.46.1597198578332;
 Tue, 11 Aug 2020 19:16:18 -0700 (PDT)
Date:   Tue, 11 Aug 2020 19:16:18 -0700
X-Google-Appengine-App-Id: s~syzkaller
X-Google-Appengine-App-Id-Alias: syzkaller
Message-ID: <000000000000e5b60405aca4c517@google.com>
Subject: KASAN: use-after-free Read in __io_req_task_submit
From:   syzbot <syzbot+3c72ce3136524268d7af@syzkaller.appspotmail.com>
To:     axboe@kernel.dk, io-uring@vger.kernel.org,
        linux-fsdevel@vger.kernel.org, linux-kernel@vger.kernel.org,
        syzkaller-bugs@googlegroups.com, viro@zeniv.linux.org.uk
Content-Type: text/plain; charset="UTF-8"
Sender: io-uring-owner@vger.kernel.org
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org

Hello,

syzbot found the following issue on:

HEAD commit:    00e4db51 Merge tag 'perf-tools-2020-08-10' of git://git.ke..
git tree:       upstream
console output: https://syzkaller.appspot.com/x/log.txt?x=13829022900000
kernel config:  https://syzkaller.appspot.com/x/.config?x=64a3282e09356140
dashboard link: https://syzkaller.appspot.com/bug?extid=3c72ce3136524268d7af
compiler:       gcc (GCC) 10.1.0-syz 20200507
syz repro:      https://syzkaller.appspot.com/x/repro.syz?x=1612cee2900000
C reproducer:   https://syzkaller.appspot.com/x/repro.c?x=14e3b1b2900000

IMPORTANT: if you fix the issue, please add the following tag to the commit:
Reported-by: syzbot+3c72ce3136524268d7af@syzkaller.appspotmail.com

==================================================================
BUG: KASAN: use-after-free in instrument_atomic_read include/linux/instrumented.h:56 [inline]
BUG: KASAN: use-after-free in atomic64_read include/asm-generic/atomic-instrumented.h:837 [inline]
BUG: KASAN: use-after-free in atomic_long_read include/asm-generic/atomic-long.h:29 [inline]
BUG: KASAN: use-after-free in __mutex_unlock_slowpath+0x8e/0x610 kernel/locking/mutex.c:1237
Read of size 8 at addr ffff88809de9c3c0 by task syz-executor338/1394

CPU: 1 PID: 1394 Comm: syz-executor338 Not tainted 5.8.0-syzkaller #0
Hardware name: Google Google Compute Engine/Google Compute Engine, BIOS Google 01/01/2011
Call Trace:
 __dump_stack lib/dump_stack.c:77 [inline]
 dump_stack+0x18f/0x20d lib/dump_stack.c:118
 print_address_description.constprop.0.cold+0xae/0x497 mm/kasan/report.c:383
 __kasan_report mm/kasan/report.c:513 [inline]
 kasan_report.cold+0x1f/0x37 mm/kasan/report.c:530
 check_memory_region_inline mm/kasan/generic.c:186 [inline]
 check_memory_region+0x13d/0x180 mm/kasan/generic.c:192
 instrument_atomic_read include/linux/instrumented.h:56 [inline]
 atomic64_read include/asm-generic/atomic-instrumented.h:837 [inline]
 atomic_long_read include/asm-generic/atomic-long.h:29 [inline]
 __mutex_unlock_slowpath+0x8e/0x610 kernel/locking/mutex.c:1237
 __io_req_task_submit+0x8a/0xe0 fs/io_uring.c:1760
 task_work_run+0xdd/0x190 kernel/task_work.c:135
 tracehook_notify_resume include/linux/tracehook.h:188 [inline]
 exit_to_user_mode_loop kernel/entry/common.c:139 [inline]
 exit_to_user_mode_prepare+0x1aa/0x1d0 kernel/entry/common.c:166
 syscall_exit_to_user_mode+0x59/0x2b0 kernel/entry/common.c:241
 entry_SYSCALL_64_after_hwframe+0x44/0xa9
RIP: 0033:0x449b99
Code: e8 3c e6 ff ff 48 83 c4 18 c3 0f 1f 80 00 00 00 00 48 89 f8 48 89 f7 48 89 d6 48 89 ca 4d 89 c2 4d 89 c8 4c 8b 4c 24 08 0f 05 <48> 3d 01 f0 ff ff 0f 83 2b 06 fc ff c3 66 2e 0f 1f 84 00 00 00 00
RSP: 002b:00007f4c0bec2cf8 EFLAGS: 00000246 ORIG_RAX: 00000000000000ca
RAX: 0000000000000000 RBX: 00000000006e5a38 RCX: 0000000000449b99
RDX: 0000000000000000 RSI: 0000000000000080 RDI: 00000000006e5a38
RBP: 00000000006e5a30 R08: 0000000000000000 R09: 0000000000000000
R10: 0000000000000000 R11: 0000000000000246 R12: 00000000006e5a3c
R13: 00007ffdb6e3600f R14: 00007f4c0bec39c0 R15: 20c49ba5e353f7cf

Allocated by task 1347:
 kasan_save_stack+0x1b/0x40 mm/kasan/common.c:48
 kasan_set_track mm/kasan/common.c:56 [inline]
 __kasan_kmalloc.constprop.0+0xbf/0xd0 mm/kasan/common.c:461
 kmem_cache_alloc_trace+0x16e/0x2c0 mm/slab.c:3550
 kmalloc include/linux/slab.h:554 [inline]
 kzalloc include/linux/slab.h:666 [inline]
 io_ring_ctx_alloc fs/io_uring.c:1030 [inline]
 io_uring_create fs/io_uring.c:8308 [inline]
 io_uring_setup+0x4df/0x28c0 fs/io_uring.c:8401
 do_syscall_64+0x2d/0x70 arch/x86/entry/common.c:46
 entry_SYSCALL_64_after_hwframe+0x44/0xa9

Freed by task 6838:
 kasan_save_stack+0x1b/0x40 mm/kasan/common.c:48
 kasan_set_track+0x1c/0x30 mm/kasan/common.c:56
 kasan_set_free_info+0x1b/0x30 mm/kasan/generic.c:355
 __kasan_slab_free+0xd8/0x120 mm/kasan/common.c:422
 __cache_free mm/slab.c:3418 [inline]
 kfree+0x103/0x2c0 mm/slab.c:3756
 process_one_work+0x94c/0x1670 kernel/workqueue.c:2269
 worker_thread+0x64c/0x1120 kernel/workqueue.c:2415
 kthread+0x3b5/0x4a0 kernel/kthread.c:292
 ret_from_fork+0x1f/0x30 arch/x86/entry/entry_64.S:294

Last call_rcu():
 kasan_save_stack+0x1b/0x40 mm/kasan/common.c:48
 kasan_record_aux_stack+0x82/0xb0 mm/kasan/generic.c:346
 __call_rcu kernel/rcu/tree.c:2894 [inline]
 call_rcu+0x14f/0x7e0 kernel/rcu/tree.c:2968
 __percpu_ref_switch_to_atomic lib/percpu-refcount.c:192 [inline]
 __percpu_ref_switch_mode+0x365/0x700 lib/percpu-refcount.c:237
 percpu_ref_kill_and_confirm+0x94/0x350 lib/percpu-refcount.c:350
 percpu_ref_kill include/linux/percpu-refcount.h:136 [inline]
 io_ring_ctx_wait_and_kill+0x38/0x600 fs/io_uring.c:7797
 io_uring_release+0x3e/0x50 fs/io_uring.c:7829
 __fput+0x285/0x920 fs/file_table.c:281
 task_work_run+0xdd/0x190 kernel/task_work.c:135
 tracehook_notify_resume include/linux/tracehook.h:188 [inline]
 exit_to_user_mode_loop kernel/entry/common.c:139 [inline]
 exit_to_user_mode_prepare+0x1aa/0x1d0 kernel/entry/common.c:166
 syscall_exit_to_user_mode+0x59/0x2b0 kernel/entry/common.c:241
 entry_SYSCALL_64_after_hwframe+0x44/0xa9

Second to last call_rcu():
 kasan_save_stack+0x1b/0x40 mm/kasan/common.c:48
 kasan_record_aux_stack+0x82/0xb0 mm/kasan/generic.c:346
 __call_rcu kernel/rcu/tree.c:2894 [inline]
 call_rcu+0x14f/0x7e0 kernel/rcu/tree.c:2968
 __percpu_ref_switch_to_atomic lib/percpu-refcount.c:192 [inline]
 __percpu_ref_switch_mode+0x365/0x700 lib/percpu-refcount.c:237
 percpu_ref_kill_and_confirm+0x94/0x350 lib/percpu-refcount.c:350
 percpu_ref_kill include/linux/percpu-refcount.h:136 [inline]
 io_ring_ctx_wait_and_kill+0x38/0x600 fs/io_uring.c:7797
 io_uring_release+0x3e/0x50 fs/io_uring.c:7829
 __fput+0x285/0x920 fs/file_table.c:281
 task_work_run+0xdd/0x190 kernel/task_work.c:135
 exit_task_work include/linux/task_work.h:25 [inline]
 do_exit+0xb7d/0x29f0 kernel/exit.c:806
 do_group_exit+0x125/0x310 kernel/exit.c:903
 get_signal+0x40b/0x1ee0 kernel/signal.c:2743
 arch_do_signal+0x82/0x2520 arch/x86/kernel/signal.c:811
 exit_to_user_mode_loop kernel/entry/common.c:135 [inline]
 exit_to_user_mode_prepare+0x172/0x1d0 kernel/entry/common.c:166
 syscall_exit_to_user_mode+0x59/0x2b0 kernel/entry/common.c:241
 entry_SYSCALL_64_after_hwframe+0x44/0xa9

The buggy address belongs to the object at ffff88809de9c000
 which belongs to the cache kmalloc-2k of size 2048
The buggy address is located 960 bytes inside of
 2048-byte region [ffff88809de9c000, ffff88809de9c800)
The buggy address belongs to the page:
page:00000000f914c910 refcount:1 mapcount:0 mapping:0000000000000000 index:0x0 pfn:0x9de9c
flags: 0xfffe0000000200(slab)
raw: 00fffe0000000200 ffffea0002422c08 ffffea0002765948 ffff8880aa040800
raw: 0000000000000000 ffff88809de9c000 0000000100000001 0000000000000000
page dumped because: kasan: bad access detected

Memory state around the buggy address:
 ffff88809de9c280: fb fb fb fb fb fb fb fb fb fb fb fb fb fb fb fb
 ffff88809de9c300: fb fb fb fb fb fb fb fb fb fb fb fb fb fb fb fb
>ffff88809de9c380: fb fb fb fb fb fb fb fb fb fb fb fb fb fb fb fb
                                           ^
 ffff88809de9c400: fb fb fb fb fb fb fb fb fb fb fb fb fb fb fb fb
 ffff88809de9c480: fb fb fb fb fb fb fb fb fb fb fb fb fb fb fb fb
==================================================================


---
This report is generated by a bot. It may contain errors.
See https://goo.gl/tpsmEJ for more information about syzbot.
syzbot engineers can be reached at syzkaller@googlegroups.com.

syzbot will keep track of this issue. See:
https://goo.gl/tpsmEJ#status for how to communicate with syzbot.
syzbot can test patches for this issue, for details see:
https://goo.gl/tpsmEJ#testing-patches
