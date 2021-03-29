Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 45EC134D8A1
	for <lists+io-uring@lfdr.de>; Mon, 29 Mar 2021 21:55:19 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231876AbhC2Tyr (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Mon, 29 Mar 2021 15:54:47 -0400
Received: from mail-io1-f69.google.com ([209.85.166.69]:39006 "EHLO
        mail-io1-f69.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231834AbhC2TyP (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Mon, 29 Mar 2021 15:54:15 -0400
Received: by mail-io1-f69.google.com with SMTP id x6so11672867ioj.6
        for <io-uring@vger.kernel.org>; Mon, 29 Mar 2021 12:54:15 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:date:message-id:subject:from:to;
        bh=2uINefkHadw+gRKQPjIggoOezSA0zP7rfMG7DQaWRmk=;
        b=WksMt3SbENaJDGw19HyEoPzV8QZ9awFA0t2rBsr0RtSkwtp5TgTQWWZ2U1kcvga0Fo
         WltIMCW+S9kLDL0BCEQ2QJpe+A0dxrxeuqfJaBD+JumAnWdugFnBQ8FUcHm3qwMqPeqD
         vlDTxZIG+NAZ9r3DSd52YB9YnvwUFUnDxPsIWJ2dsPIusSYXzF95B82QHm/Hcj1FNcgT
         MYS3WGVcz+SJ+Ezj9guuCmtHEjlKx0++KvovNu9/ohvlK0pegHDmLKa9EtBslst6TbBo
         iAzF0jQJ8E0Ls0liDCkGymSpvSxz4zEnHUTibfxGE5Wv6DEr0FtinVZw3LSM+c3AYzp8
         sZTg==
X-Gm-Message-State: AOAM5327WRaiERXKNIjuLMAVf4XFsY9wTVC7zmO86VomKrx0d4NjvPC0
        XaeLrRMmwZhDRb8UpfzAhC+LSYn7n6YhebXmLYs3WA/fCIfs
X-Google-Smtp-Source: ABdhPJxoHEnos7QaDVSO1mCSWOMCL7cxJr2bu8h0MF8dfXbPMxblWoXWncvO/hl283rDr/fXP8PxpBR5JThb4DrUPnJAAALwEdWy
MIME-Version: 1.0
X-Received: by 2002:a02:b39a:: with SMTP id p26mr25541110jan.20.1617047654872;
 Mon, 29 Mar 2021 12:54:14 -0700 (PDT)
Date:   Mon, 29 Mar 2021 12:54:14 -0700
X-Google-Appengine-App-Id: s~syzkaller
X-Google-Appengine-App-Id-Alias: syzkaller
Message-ID: <0000000000000dbebd05beb23f0c@google.com>
Subject: [syzbot] KASAN: use-after-free Read in create_worker_cb
From:   syzbot <syzbot+099593561bbd1805b839@syzkaller.appspotmail.com>
To:     asml.silence@gmail.com, axboe@kernel.dk, io-uring@vger.kernel.org,
        linux-kernel@vger.kernel.org, mingo@kernel.org, mingo@redhat.com,
        peterz@infradead.org, rostedt@goodmis.org,
        syzkaller-bugs@googlegroups.com, will@kernel.org
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org

Hello,

syzbot found the following issue on:

HEAD commit:    93129492 Add linux-next specific files for 20210326
git tree:       linux-next
console output: https://syzkaller.appspot.com/x/log.txt?x=144509bad00000
kernel config:  https://syzkaller.appspot.com/x/.config?x=4c9322cd4e3b7a16
dashboard link: https://syzkaller.appspot.com/bug?extid=099593561bbd1805b839
syz repro:      https://syzkaller.appspot.com/x/repro.syz?x=124ce00ed00000
C reproducer:   https://syzkaller.appspot.com/x/repro.c?x=1664d5aad00000

The issue was bisected to:

commit 4d004099a668c41522242aa146a38cc4eb59cb1e
Author: Peter Zijlstra <peterz@infradead.org>
Date:   Fri Oct 2 09:04:21 2020 +0000

    lockdep: Fix lockdep recursion

bisection log:  https://syzkaller.appspot.com/x/bisect.txt?x=12f96b7cd00000
final oops:     https://syzkaller.appspot.com/x/report.txt?x=11f96b7cd00000
console output: https://syzkaller.appspot.com/x/log.txt?x=16f96b7cd00000

IMPORTANT: if you fix the issue, please add the following tag to the commit:
Reported-by: syzbot+099593561bbd1805b839@syzkaller.appspotmail.com
Fixes: 4d004099a668 ("lockdep: Fix lockdep recursion")

==================================================================
BUG: KASAN: use-after-free in create_worker_cb+0xaa/0xc0 fs/io-wq.c:272
Read of size 8 at addr ffff88801bf150e8 by task syz-executor364/8509

CPU: 0 PID: 8509 Comm: syz-executor364 Not tainted 5.12.0-rc4-next-20210326-syzkaller #0
Hardware name: Google Google Compute Engine/Google Compute Engine, BIOS Google 01/01/2011
Call Trace:
 __dump_stack lib/dump_stack.c:79 [inline]
 dump_stack+0x141/0x1d7 lib/dump_stack.c:120
 print_address_description.constprop.0.cold+0x5b/0x2f8 mm/kasan/report.c:232
 __kasan_report mm/kasan/report.c:399 [inline]
 kasan_report.cold+0x7c/0xd8 mm/kasan/report.c:416
 create_worker_cb+0xaa/0xc0 fs/io-wq.c:272
 task_work_run+0xdd/0x1a0 kernel/task_work.c:143
 exit_task_work include/linux/task_work.h:30 [inline]
 do_exit+0xbfc/0x2a60 kernel/exit.c:825
 do_group_exit+0x125/0x310 kernel/exit.c:922
 __do_sys_exit_group kernel/exit.c:933 [inline]
 __se_sys_exit_group kernel/exit.c:931 [inline]
 __x64_sys_exit_group+0x3a/0x50 kernel/exit.c:931
 do_syscall_64+0x2d/0x70 arch/x86/entry/common.c:46
 entry_SYSCALL_64_after_hwframe+0x44/0xae
RIP: 0033:0x447359
Code: Unable to access opcode bytes at RIP 0x44732f.
RSP: 002b:00007ffdfb4e3ea8 EFLAGS: 00000246 ORIG_RAX: 00000000000000e7
RAX: ffffffffffffffda RBX: 00000000004b8390 RCX: 0000000000447359
RDX: 000000000000003c RSI: 00000000000000e7 RDI: 0000000000000000
RBP: 0000000000000000 R08: ffffffffffffffc0 R09: 0000000000000000
R10: 0000000000000000 R11: 0000000000000246 R12: 00000000004b8390
R13: 0000000000000001 R14: 0000000000000000 R15: 0000000000000001

Allocated by task 8509:
 kasan_save_stack+0x1b/0x40 mm/kasan/common.c:38
 kasan_set_track mm/kasan/common.c:46 [inline]
 set_alloc_info mm/kasan/common.c:428 [inline]
 ____kasan_kmalloc mm/kasan/common.c:507 [inline]
 ____kasan_kmalloc mm/kasan/common.c:466 [inline]
 __kasan_kmalloc+0x9b/0xd0 mm/kasan/common.c:516
 kmalloc_node include/linux/slab.h:574 [inline]
 kzalloc_node include/linux/slab.h:697 [inline]
 io_wq_create+0x6e4/0xca0 fs/io-wq.c:934
 io_init_wq_offload fs/io_uring.c:7938 [inline]
 io_uring_alloc_task_context+0x1bf/0x660 fs/io_uring.c:7957
 __io_uring_add_task_file+0x29a/0x3c0 fs/io_uring.c:8915
 io_uring_add_task_file fs/io_uring.c:8951 [inline]
 io_uring_install_fd fs/io_uring.c:9509 [inline]
 io_uring_create fs/io_uring.c:9656 [inline]
 io_uring_setup+0x20dd/0x2b00 fs/io_uring.c:9693
 do_syscall_64+0x2d/0x70 arch/x86/entry/common.c:46
 entry_SYSCALL_64_after_hwframe+0x44/0xae

Freed by task 8509:
 kasan_save_stack+0x1b/0x40 mm/kasan/common.c:38
 kasan_set_track+0x1c/0x30 mm/kasan/common.c:46
 kasan_set_free_info+0x20/0x30 mm/kasan/generic.c:357
 ____kasan_slab_free mm/kasan/common.c:360 [inline]
 ____kasan_slab_free mm/kasan/common.c:325 [inline]
 __kasan_slab_free+0xfb/0x130 mm/kasan/common.c:368
 kasan_slab_free include/linux/kasan.h:212 [inline]
 slab_free_hook mm/slub.c:1578 [inline]
 slab_free_freelist_hook+0xdf/0x240 mm/slub.c:1603
 slab_free mm/slub.c:3163 [inline]
 kfree+0xe5/0x7f0 mm/slub.c:4230
 io_wq_destroy+0x13e/0x2d0 fs/io-wq.c:1022
 io_wq_put fs/io-wq.c:1032 [inline]
 io_wq_put_and_exit+0x7a/0xa0 fs/io-wq.c:1038
 io_uring_clean_tctx+0xed/0x160 fs/io_uring.c:8988
 __io_uring_files_cancel+0x703/0x850 fs/io_uring.c:9053
 io_uring_files_cancel include/linux/io_uring.h:22 [inline]
 do_exit+0x299/0x2a60 kernel/exit.c:780
 do_group_exit+0x125/0x310 kernel/exit.c:922
 __do_sys_exit_group kernel/exit.c:933 [inline]
 __se_sys_exit_group kernel/exit.c:931 [inline]
 __x64_sys_exit_group+0x3a/0x50 kernel/exit.c:931
 do_syscall_64+0x2d/0x70 arch/x86/entry/common.c:46
 entry_SYSCALL_64_after_hwframe+0x44/0xae

The buggy address belongs to the object at ffff88801bf15000
 which belongs to the cache kmalloc-1k of size 1024
The buggy address is located 232 bytes inside of
 1024-byte region [ffff88801bf15000, ffff88801bf15400)
The buggy address belongs to the page:
page:ffffea00006fc400 refcount:1 mapcount:0 mapping:0000000000000000 index:0xffff88801bf15800 pfn:0x1bf10
head:ffffea00006fc400 order:3 compound_mapcount:0 compound_pincount:0
flags: 0xfff00000010200(slab|head|node=0|zone=1|lastcpupid=0x7ff)
raw: 00fff00000010200 ffffea00004cd808 ffff888010840888 ffff888010841dc0
raw: ffff88801bf15800 000000000010000d 00000001ffffffff 0000000000000000
page dumped because: kasan: bad access detected

Memory state around the buggy address:
 ffff88801bf14f80: fc fc fc fc fc fc fc fc fc fc fc fc fc fc fc fc
 ffff88801bf15000: fa fb fb fb fb fb fb fb fb fb fb fb fb fb fb fb
>ffff88801bf15080: fb fb fb fb fb fb fb fb fb fb fb fb fb fb fb fb
                                                          ^
 ffff88801bf15100: fb fb fb fb fb fb fb fb fb fb fb fb fb fb fb fb
 ffff88801bf15180: fb fb fb fb fb fb fb fb fb fb fb fb fb fb fb fb
==================================================================


---
This report is generated by a bot. It may contain errors.
See https://goo.gl/tpsmEJ for more information about syzbot.
syzbot engineers can be reached at syzkaller@googlegroups.com.

syzbot will keep track of this issue. See:
https://goo.gl/tpsmEJ#status for how to communicate with syzbot.
For information about bisection process see: https://goo.gl/tpsmEJ#bisection
syzbot can test patches for this issue, for details see:
https://goo.gl/tpsmEJ#testing-patches
