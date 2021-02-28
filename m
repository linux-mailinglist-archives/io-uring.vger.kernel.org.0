Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 23E153271CF
	for <lists+io-uring@lfdr.de>; Sun, 28 Feb 2021 11:00:25 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230414AbhB1KAE (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Sun, 28 Feb 2021 05:00:04 -0500
Received: from mail-io1-f70.google.com ([209.85.166.70]:56656 "EHLO
        mail-io1-f70.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230107AbhB1J77 (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Sun, 28 Feb 2021 04:59:59 -0500
Received: by mail-io1-f70.google.com with SMTP id e12so10918774ioc.23
        for <io-uring@vger.kernel.org>; Sun, 28 Feb 2021 01:59:43 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:date:message-id:subject:from:to;
        bh=+LtU5wvLL/gljskcS4jLn6m6L5p6dDi832fng9CRgSk=;
        b=gtnC5EYBnwhj7a9ppYIwtUgIBt0B+ZIaMLeRhUiTIQl4cKV5SAfDPcgJfDQO46uNkj
         sNhcz2CiZI4rt2AqlRCdVX0oU5XEHx+LXJnrPHnJp5pJUJz4tOmC6skJh//mqsqfuj/r
         9fNYVxIn6p2pqu6dN6y0R2GD8jWTkPfRE5X+7tcgYSeYYtGJm2eiyXPdzIf6oKjdTJYd
         houq+CMy9fHXRJo6d3NEM7qXKvN32Yr0nprVG9cMPLL9V2OHMGLza3QmxHtNniWJoO3I
         J9cpQc6nkLZqeqnCGiS06pWvKSUmQild6Nf+JY1YCC6AQOWct7B8mG/p6/Ujwgsh4E3g
         rrVA==
X-Gm-Message-State: AOAM530Km3C9nk8MLDiHC0F328ULOo2Keskq3PSSZWYR196mKRs6hyZH
        3TppyHQyj8UKez4x/pYnMMym/BXOv70amtXlButEoo/fV5n8
X-Google-Smtp-Source: ABdhPJzikQMhyMn3IzbQIBErMJK7R0Vvpy+IklInsPjNtERsPKmz9b3Iw3lv0DJsyIoVf9BmQ5l13JrgoCfy1lfS/lany8Vv0v/y
MIME-Version: 1.0
X-Received: by 2002:a5e:a508:: with SMTP id 8mr144708iog.135.1614506358547;
 Sun, 28 Feb 2021 01:59:18 -0800 (PST)
Date:   Sun, 28 Feb 2021 01:59:18 -0800
X-Google-Appengine-App-Id: s~syzkaller
X-Google-Appengine-App-Id-Alias: syzkaller
Message-ID: <000000000000fd274b05bc628d6a@google.com>
Subject: KASAN: use-after-free Read in tctx_task_work
From:   syzbot <syzbot+a157ac7c03a56397f553@syzkaller.appspotmail.com>
To:     asml.silence@gmail.com, axboe@kernel.dk, io-uring@vger.kernel.org,
        linux-kernel@vger.kernel.org, syzkaller-bugs@googlegroups.com
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org

Hello,

syzbot found the following issue on:

HEAD commit:    29c395c7 Merge tag 'x86-entry-2021-02-24' of git://git.ker..
git tree:       upstream
console output: https://syzkaller.appspot.com/x/log.txt?x=11cd05cad00000
kernel config:  https://syzkaller.appspot.com/x/.config?x=c581c545cb4ffac7
dashboard link: https://syzkaller.appspot.com/bug?extid=a157ac7c03a56397f553
compiler:       Debian clang version 11.0.1-2

Unfortunately, I don't have any reproducer for this issue yet.

IMPORTANT: if you fix the issue, please add the following tag to the commit:
Reported-by: syzbot+a157ac7c03a56397f553@syzkaller.appspotmail.com

==================================================================
BUG: KASAN: use-after-free in __tctx_task_work fs/io_uring.c:2217 [inline]
BUG: KASAN: use-after-free in tctx_task_work+0x238/0x280 fs/io_uring.c:2230
Read of size 4 at addr ffff88802178e3f0 by task syz-executor.2/12656

CPU: 1 PID: 12656 Comm: syz-executor.2 Not tainted 5.11.0-syzkaller #0
Hardware name: Google Google Compute Engine/Google Compute Engine, BIOS Google 01/01/2011
Call Trace:
 __dump_stack lib/dump_stack.c:79 [inline]
 dump_stack+0x125/0x19e lib/dump_stack.c:120
 print_address_description+0x5f/0x3a0 mm/kasan/report.c:230
 __kasan_report mm/kasan/report.c:397 [inline]
 kasan_report+0x15e/0x200 mm/kasan/report.c:414
 __tctx_task_work fs/io_uring.c:2217 [inline]
 tctx_task_work+0x238/0x280 fs/io_uring.c:2230
 task_work_run+0x146/0x1c0 kernel/task_work.c:140
 exit_task_work include/linux/task_work.h:30 [inline]
 do_exit+0x6e4/0x2380 kernel/exit.c:825
 do_group_exit+0x168/0x2d0 kernel/exit.c:922
 get_signal+0x1734/0x1ef0 kernel/signal.c:2773
 arch_do_signal_or_restart+0x3c/0x610 arch/x86/kernel/signal.c:811
 handle_signal_work kernel/entry/common.c:147 [inline]
 exit_to_user_mode_loop kernel/entry/common.c:171 [inline]
 exit_to_user_mode_prepare+0xac/0x1e0 kernel/entry/common.c:208
 __syscall_exit_to_user_mode_work kernel/entry/common.c:290 [inline]
 syscall_exit_to_user_mode+0x48/0x180 kernel/entry/common.c:301
 entry_SYSCALL_64_after_hwframe+0x44/0xae
RIP: 0033:0x465ef9
Code: Unable to access opcode bytes at RIP 0x465ecf.
RSP: 002b:00007f80563b5188 EFLAGS: 00000246 ORIG_RAX: 00000000000001aa
RAX: 0000000000000302 RBX: 000000000056c008 RCX: 0000000000465ef9
RDX: 0000000000000000 RSI: 0000000000000302 RDI: 0000000000000003
RBP: 00000000004bcd1c R08: 0000000000000000 R09: 0000000000000000
R10: 0000000000000000 R11: 0000000000000246 R12: 000000000056c008
R13: 00007ffedb23021f R14: 00007f80563b5300 R15: 0000000000022000

Allocated by task 12638:
 kasan_save_stack mm/kasan/common.c:38 [inline]
 kasan_set_track mm/kasan/common.c:46 [inline]
 set_alloc_info mm/kasan/common.c:400 [inline]
 ____kasan_kmalloc+0xbd/0xf0 mm/kasan/common.c:428
 kasan_kmalloc include/linux/kasan.h:218 [inline]
 kmem_cache_alloc_trace+0x205/0x300 mm/slub.c:2922
 kmalloc include/linux/slab.h:554 [inline]
 kzalloc include/linux/slab.h:684 [inline]
 io_ring_ctx_alloc fs/io_uring.c:1316 [inline]
 io_uring_create fs/io_uring.c:9745 [inline]
 io_uring_setup fs/io_uring.c:9876 [inline]
 __do_sys_io_uring_setup fs/io_uring.c:9882 [inline]
 __se_sys_io_uring_setup+0x368/0x3140 fs/io_uring.c:9879
 do_syscall_64+0x2d/0x70 arch/x86/entry/common.c:46
 entry_SYSCALL_64_after_hwframe+0x44/0xae

Freed by task 54:
 kasan_save_stack mm/kasan/common.c:38 [inline]
 kasan_set_track+0x3d/0x70 mm/kasan/common.c:46
 kasan_set_free_info+0x1f/0x40 mm/kasan/generic.c:356
 ____kasan_slab_free+0xd3/0x110 mm/kasan/common.c:361
 kasan_slab_free include/linux/kasan.h:191 [inline]
 slab_free_hook mm/slub.c:1561 [inline]
 slab_free_freelist_hook+0xdd/0x1b0 mm/slub.c:1594
 slab_free mm/slub.c:3146 [inline]
 kfree+0xcf/0x2b0 mm/slub.c:4182
 process_one_work+0x789/0xfd0 kernel/workqueue.c:2275
 worker_thread+0xac1/0x1300 kernel/workqueue.c:2421
 kthread+0x39a/0x3c0 kernel/kthread.c:292
 ret_from_fork+0x1f/0x30 arch/x86/entry/entry_64.S:294

Last potentially related work creation:
 kasan_save_stack+0x27/0x50 mm/kasan/common.c:38
 kasan_record_aux_stack+0xcc/0x100 mm/kasan/generic.c:344
 insert_work+0x54/0x400 kernel/workqueue.c:1331
 __queue_work+0x97f/0xcc0 kernel/workqueue.c:1497
 queue_work_on+0xb5/0x100 kernel/workqueue.c:1524
 io_uring_release+0x57/0x70 fs/io_uring.c:8895
 __fput+0x352/0x7b0 fs/file_table.c:280
 task_work_run+0x146/0x1c0 kernel/task_work.c:140
 exit_task_work include/linux/task_work.h:30 [inline]
 do_exit+0x6e4/0x2380 kernel/exit.c:825
 do_group_exit+0x168/0x2d0 kernel/exit.c:922
 get_signal+0x1734/0x1ef0 kernel/signal.c:2773
 arch_do_signal_or_restart+0x3c/0x610 arch/x86/kernel/signal.c:811
 handle_signal_work kernel/entry/common.c:147 [inline]
 exit_to_user_mode_loop kernel/entry/common.c:171 [inline]
 exit_to_user_mode_prepare+0xac/0x1e0 kernel/entry/common.c:208
 __syscall_exit_to_user_mode_work kernel/entry/common.c:290 [inline]
 syscall_exit_to_user_mode+0x48/0x180 kernel/entry/common.c:301
 entry_SYSCALL_64_after_hwframe+0x44/0xae

The buggy address belongs to the object at ffff88802178e000
 which belongs to the cache kmalloc-4k of size 4096
The buggy address is located 1008 bytes inside of
 4096-byte region [ffff88802178e000, ffff88802178f000)
The buggy address belongs to the page:
page:00000000f7d94ef1 refcount:1 mapcount:0 mapping:0000000000000000 index:0x0 pfn:0x21788
head:00000000f7d94ef1 order:3 compound_mapcount:0 compound_pincount:0
flags: 0xfff00000010200(slab|head)
raw: 00fff00000010200 dead000000000100 dead000000000122 ffff888011042140
raw: 0000000000000000 0000000000040004 00000001ffffffff 0000000000000000
page dumped because: kasan: bad access detected

Memory state around the buggy address:
 ffff88802178e280: fb fb fb fb fb fb fb fb fb fb fb fb fb fb fb fb
 ffff88802178e300: fb fb fb fb fb fb fb fb fb fb fb fb fb fb fb fb
>ffff88802178e380: fb fb fb fb fb fb fb fb fb fb fb fb fb fb fb fb
                                                             ^
 ffff88802178e400: fb fb fb fb fb fb fb fb fb fb fb fb fb fb fb fb
 ffff88802178e480: fb fb fb fb fb fb fb fb fb fb fb fb fb fb fb fb
==================================================================


---
This report is generated by a bot. It may contain errors.
See https://goo.gl/tpsmEJ for more information about syzbot.
syzbot engineers can be reached at syzkaller@googlegroups.com.

syzbot will keep track of this issue. See:
https://goo.gl/tpsmEJ#status for how to communicate with syzbot.
