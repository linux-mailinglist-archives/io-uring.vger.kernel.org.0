Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 235AC260703
	for <lists+io-uring@lfdr.de>; Tue,  8 Sep 2020 00:45:24 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728104AbgIGWpW (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Mon, 7 Sep 2020 18:45:22 -0400
Received: from mail-io1-f79.google.com ([209.85.166.79]:36862 "EHLO
        mail-io1-f79.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1728070AbgIGWpW (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Mon, 7 Sep 2020 18:45:22 -0400
Received: by mail-io1-f79.google.com with SMTP id h8so8642875ioa.3
        for <io-uring@vger.kernel.org>; Mon, 07 Sep 2020 15:45:21 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:date:message-id:subject:from:to;
        bh=9/Msx1lu/ps9Pxv5T2MGazTKEDnLytlEFHMtrHc6FM4=;
        b=GsQe0fPnoDhdNeqhrlj7ulAkLlXLfWZk656dfS29kGc5J+opSQJPTZzPGLt3YhuX0n
         eUHAafoaM+OoUp/7SbVAfdQ/84dOOEx4JoeM4JrPChGAW9m34CzMGVdCxSWwTsDffa4a
         IusmLvXIe0mahw6cbQuCQ/+1Kb9fa4IDbytZJswoqveYSZi7xp+EUYKtnSbrir5d/qys
         cxmXWaHlPwEPop+iv3Ci44nuiCzxY7e0SzDJyWCwTt04UocCPZqCAcGBgsYR3jCjp/1T
         7TDqwdRHoL+sxUzaysVdU12y8zUWXyZ+uvnX2AFGRaHVeMQD4OKuFUJqF2RfKl6WnC7e
         LyGA==
X-Gm-Message-State: AOAM533YYkiYlced0qpaHOqB4zY6enIgeQph3ELO7j3QyBQnsCMB9Xi+
        Du5pup1C03MClmjmvXj/QvD6HirvIZcW7XDWRgy/cTNTn6C1
X-Google-Smtp-Source: ABdhPJyiuinB4wyaiShTTyihly6OUsctSCZFeyepxrgMG/hoVffSUbfQSkrVVb+IxmJCzZB6b64e0ZyxU5h/sEzCAVBx5DS/D5+6
MIME-Version: 1.0
X-Received: by 2002:a92:d188:: with SMTP id z8mr12890802ilz.292.1599518720879;
 Mon, 07 Sep 2020 15:45:20 -0700 (PDT)
Date:   Mon, 07 Sep 2020 15:45:20 -0700
X-Google-Appengine-App-Id: s~syzkaller
X-Google-Appengine-App-Id-Alias: syzkaller
Message-ID: <0000000000002b721a05aec0f937@google.com>
Subject: KASAN: use-after-free Write in io_wq_worker_running
From:   syzbot <syzbot+45fa0a195b941764e0f0@syzkaller.appspotmail.com>
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

HEAD commit:    f4d51dff Linux 5.9-rc4
git tree:       upstream
console output: https://syzkaller.appspot.com/x/log.txt?x=13686dcd900000
kernel config:  https://syzkaller.appspot.com/x/.config?x=8f5c353182ed6199
dashboard link: https://syzkaller.appspot.com/bug?extid=45fa0a195b941764e0f0
compiler:       clang version 10.0.0 (https://github.com/llvm/llvm-project/ c2443155a0fb245c8f17f2c1c72b6ea391e86e81)
syz repro:      https://syzkaller.appspot.com/x/repro.syz?x=1378ceed900000

IMPORTANT: if you fix the issue, please add the following tag to the commit:
Reported-by: syzbot+45fa0a195b941764e0f0@syzkaller.appspotmail.com

==================================================================
BUG: KASAN: use-after-free in instrument_atomic_write include/linux/instrumented.h:71 [inline]
BUG: KASAN: use-after-free in atomic_inc include/asm-generic/atomic-instrumented.h:240 [inline]
BUG: KASAN: use-after-free in io_wqe_inc_running fs/io-wq.c:301 [inline]
BUG: KASAN: use-after-free in io_wq_worker_running+0xb4/0x100 fs/io-wq.c:613
Write of size 4 at addr ffff88821aaa388c by task io_wqe_worker-0/8276

CPU: 0 PID: 8276 Comm: io_wqe_worker-0 Not tainted 5.9.0-rc4-syzkaller #0
Hardware name: Google Google Compute Engine/Google Compute Engine, BIOS Google 01/01/2011
Call Trace:
 __dump_stack lib/dump_stack.c:77 [inline]
 dump_stack+0x1d6/0x29e lib/dump_stack.c:118
 print_address_description+0x66/0x620 mm/kasan/report.c:383
 __kasan_report mm/kasan/report.c:513 [inline]
 kasan_report+0x132/0x1d0 mm/kasan/report.c:530
 check_memory_region_inline mm/kasan/generic.c:183 [inline]
 check_memory_region+0x2b5/0x2f0 mm/kasan/generic.c:192
 instrument_atomic_write include/linux/instrumented.h:71 [inline]
 atomic_inc include/asm-generic/atomic-instrumented.h:240 [inline]
 io_wqe_inc_running fs/io-wq.c:301 [inline]
 io_wq_worker_running+0xb4/0x100 fs/io-wq.c:613
 schedule_timeout+0x15c/0x250 kernel/time/timer.c:1879
 io_wqe_worker+0x60b/0x810 fs/io-wq.c:580
 kthread+0x37e/0x3a0 drivers/block/aoe/aoecmd.c:1234
 ret_from_fork+0x1f/0x30 arch/x86/entry/entry_64.S:294

Allocated by task 8273:
 kasan_save_stack mm/kasan/common.c:48 [inline]
 kasan_set_track mm/kasan/common.c:56 [inline]
 __kasan_kmalloc+0x100/0x130 mm/kasan/common.c:461
 kmem_cache_alloc_node_trace+0x1f7/0x2a0 mm/slab.c:3594
 kmalloc_node include/linux/slab.h:572 [inline]
 kzalloc_node include/linux/slab.h:677 [inline]
 io_wq_create+0x295/0x880 fs/io-wq.c:1064
 io_init_wq_offload fs/io_uring.c:7432 [inline]
 io_sq_offload_start fs/io_uring.c:7504 [inline]
 io_uring_create fs/io_uring.c:8625 [inline]
 io_uring_setup fs/io_uring.c:8694 [inline]
 __do_sys_io_uring_setup fs/io_uring.c:8700 [inline]
 __se_sys_io_uring_setup+0x18ed/0x2a00 fs/io_uring.c:8697
 do_syscall_64+0x31/0x70 arch/x86/entry/common.c:46
 entry_SYSCALL_64_after_hwframe+0x44/0xa9

Freed by task 8175:
 kasan_save_stack mm/kasan/common.c:48 [inline]
 kasan_set_track+0x3d/0x70 mm/kasan/common.c:56
 kasan_set_free_info+0x17/0x30 mm/kasan/generic.c:355
 __kasan_slab_free+0xdd/0x110 mm/kasan/common.c:422
 __cache_free mm/slab.c:3418 [inline]
 kfree+0x113/0x200 mm/slab.c:3756
 __io_wq_destroy fs/io-wq.c:1138 [inline]
 io_wq_destroy+0x470/0x510 fs/io-wq.c:1146
 io_finish_async fs/io_uring.c:6836 [inline]
 io_ring_ctx_free fs/io_uring.c:7870 [inline]
 io_ring_exit_work+0x195/0x520 fs/io_uring.c:7954
 process_one_work+0x789/0xfc0 kernel/workqueue.c:2269
 worker_thread+0xaa4/0x1460 kernel/workqueue.c:2415
 kthread+0x37e/0x3a0 drivers/block/aoe/aoecmd.c:1234
 ret_from_fork+0x1f/0x30 arch/x86/entry/entry_64.S:294

The buggy address belongs to the object at ffff88821aaa3800
 which belongs to the cache kmalloc-1k of size 1024
The buggy address is located 140 bytes inside of
 1024-byte region [ffff88821aaa3800, ffff88821aaa3c00)
The buggy address belongs to the page:
page:00000000be451134 refcount:1 mapcount:0 mapping:0000000000000000 index:0x0 pfn:0x21aaa3
flags: 0x57ffe0000000200(slab)
raw: 057ffe0000000200 ffffea00086a2148 ffffea0008536b08 ffff8880aa440700
raw: 0000000000000000 ffff88821aaa3000 0000000100000002 0000000000000000
page dumped because: kasan: bad access detected

Memory state around the buggy address:
 ffff88821aaa3780: fc fc fc fc fc fc fc fc fc fc fc fc fc fc fc fc
 ffff88821aaa3800: fa fb fb fb fb fb fb fb fb fb fb fb fb fb fb fb
>ffff88821aaa3880: fb fb fb fb fb fb fb fb fb fb fb fb fb fb fb fb
                      ^
 ffff88821aaa3900: fb fb fb fb fb fb fb fb fb fb fb fb fb fb fb fb
 ffff88821aaa3980: fb fb fb fb fb fb fb fb fb fb fb fb fb fb fb fb
==================================================================


---
This report is generated by a bot. It may contain errors.
See https://goo.gl/tpsmEJ for more information about syzbot.
syzbot engineers can be reached at syzkaller@googlegroups.com.

syzbot will keep track of this issue. See:
https://goo.gl/tpsmEJ#status for how to communicate with syzbot.
syzbot can test patches for this issue, for details see:
https://goo.gl/tpsmEJ#testing-patches
