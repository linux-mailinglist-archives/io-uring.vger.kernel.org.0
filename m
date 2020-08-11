Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 77F08241673
	for <lists+io-uring@lfdr.de>; Tue, 11 Aug 2020 08:47:20 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728116AbgHKGrT (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Tue, 11 Aug 2020 02:47:19 -0400
Received: from mail-io1-f72.google.com ([209.85.166.72]:43205 "EHLO
        mail-io1-f72.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727066AbgHKGrT (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Tue, 11 Aug 2020 02:47:19 -0400
Received: by mail-io1-f72.google.com with SMTP id f19so9015209iol.10
        for <io-uring@vger.kernel.org>; Mon, 10 Aug 2020 23:47:18 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:date:message-id:subject:from:to;
        bh=ALLgFYzJu8xYow6jwfC/O/mtKqGLcRdyWSt6PNLRIOE=;
        b=ccUD/MYI4pz/8VD9ofrsmY+wclfaJQOTQkxxcR2RLxpj4AMII8paJWnOCFCyAfqJ6l
         aIAyETCpp/ScjtAx25Cv7d2fdR1wVOKm/1LFC+lgmd3b/mfrDvpkOgLbx7yaPCPbT2Qp
         vvj+hOKskp2OE2mxDH0+gv795XUwepVdLyDwcXbduZSud/NJ3J8jQwxrXTqKKfoQsUO6
         IvRhoryCM/K5SMq32nOzDpz+cadNcv5OuYn5aHNEuqrgm12FZwkMqVyxxOEwFIyClOXQ
         Lel40owMeGPmQS69tGO5Z8AAp86fDmgY1Znm25CC+A3vn/ZZayy67uATKQd0L+Z13PMI
         WU2g==
X-Gm-Message-State: AOAM530DVGoLUT132rJQU8LEi5I9I7cOzPduCEeHxTpsBfaEZsPlgg9M
        OJ3f2SN8epDC3MOTRhkQV2Jt38Tysfo7tHTgCivvUoUdaXRA
X-Google-Smtp-Source: ABdhPJwsQJoDHRXwvBGadlNgxs/TtlOVxU5vI+1XAOWQ07/0G8DKpifSYhjJFyWYQFFnzzwuWqpPnogZ1ICepLxDeXQ1restm2Gb
MIME-Version: 1.0
X-Received: by 2002:a5d:9d8a:: with SMTP id 10mr21911301ion.195.1597128437091;
 Mon, 10 Aug 2020 23:47:17 -0700 (PDT)
Date:   Mon, 10 Aug 2020 23:47:17 -0700
X-Google-Appengine-App-Id: s~syzkaller
X-Google-Appengine-App-Id-Alias: syzkaller
Message-ID: <0000000000002753ac05ac9471f4@google.com>
Subject: KASAN: use-after-free Read in io_async_task_func
From:   syzbot <syzbot+9b260fc33297966f5a8e@syzkaller.appspotmail.com>
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

HEAD commit:    fc80c51f Merge tag 'kbuild-v5.9' of git://git.kernel.org/p..
git tree:       upstream
console output: https://syzkaller.appspot.com/x/log.txt?x=17601ab2900000
kernel config:  https://syzkaller.appspot.com/x/.config?x=d48472fcc2f68903
dashboard link: https://syzkaller.appspot.com/bug?extid=9b260fc33297966f5a8e
compiler:       clang version 10.0.0 (https://github.com/llvm/llvm-project/ c2443155a0fb245c8f17f2c1c72b6ea391e86e81)
syz repro:      https://syzkaller.appspot.com/x/repro.syz?x=174272b2900000

IMPORTANT: if you fix the issue, please add the following tag to the commit:
Reported-by: syzbot+9b260fc33297966f5a8e@syzkaller.appspotmail.com

==================================================================
BUG: KASAN: use-after-free in instrument_atomic_read include/linux/instrumented.h:56 [inline]
BUG: KASAN: use-after-free in atomic64_read include/asm-generic/atomic-instrumented.h:837 [inline]
BUG: KASAN: use-after-free in atomic_long_read include/asm-generic/atomic-long.h:29 [inline]
BUG: KASAN: use-after-free in __mutex_unlock_slowpath+0x88/0x590 kernel/locking/mutex.c:1237
Read of size 8 at addr ffff8880952503c0 by task syz-executor.1/23201

CPU: 0 PID: 23201 Comm: syz-executor.1 Not tainted 5.8.0-syzkaller #0
Hardware name: Google Google Compute Engine/Google Compute Engine, BIOS Google 01/01/2011
Call Trace:
 __dump_stack lib/dump_stack.c:77 [inline]
 dump_stack+0x1f0/0x31e lib/dump_stack.c:118
 print_address_description+0x66/0x620 mm/kasan/report.c:383
 __kasan_report mm/kasan/report.c:513 [inline]
 kasan_report+0x132/0x1d0 mm/kasan/report.c:530
 check_memory_region_inline mm/kasan/generic.c:183 [inline]
 check_memory_region+0x2b5/0x2f0 mm/kasan/generic.c:192
 instrument_atomic_read include/linux/instrumented.h:56 [inline]
 atomic64_read include/asm-generic/atomic-instrumented.h:837 [inline]
 atomic_long_read include/asm-generic/atomic-long.h:29 [inline]
 __mutex_unlock_slowpath+0x88/0x590 kernel/locking/mutex.c:1237
 io_async_task_func+0x485/0x610 fs/io_uring.c:4689
 task_work_run+0x137/0x1c0 kernel/task_work.c:135
 tracehook_notify_resume include/linux/tracehook.h:188 [inline]
 exit_to_user_mode_loop kernel/entry/common.c:139 [inline]
 exit_to_user_mode_prepare+0xfa/0x1c0 kernel/entry/common.c:166
 syscall_exit_to_user_mode+0x5e/0x1a0 kernel/entry/common.c:241
 entry_SYSCALL_64_after_hwframe+0x44/0xa9
RIP: 0033:0x45ce69
Code: 2d b6 fb ff c3 66 2e 0f 1f 84 00 00 00 00 00 66 90 48 89 f8 48 89 f7 48 89 d6 48 89 ca 4d 89 c2 4d 89 c8 4c 8b 4c 24 08 0f 05 <48> 3d 01 f0 ff ff 0f 83 fb b5 fb ff c3 66 2e 0f 1f 84 00 00 00 00
RSP: 002b:00007f6719775c78 EFLAGS: 00000246 ORIG_RAX: 0000000000000037
RAX: fffffffffffffffe RBX: 0000000000004f40 RCX: 000000000045ce69
RDX: 0000000000000043 RSI: 0000000000000000 RDI: 0000000000000006
RBP: 000000000118c010 R08: 0000000020000140 R09: 0000000000000000
R10: 0000000020000000 R11: 0000000000000246 R12: 000000000118bfcc
R13: 00007fff62cc118f R14: 00007f67197769c0 R15: 000000000118bfcc

Allocated by task 23153:
 kasan_save_stack mm/kasan/common.c:48 [inline]
 kasan_set_track mm/kasan/common.c:56 [inline]
 __kasan_kmalloc+0x100/0x130 mm/kasan/common.c:461
 kmem_cache_alloc_trace+0x1f6/0x2f0 mm/slab.c:3550
 kmalloc include/linux/slab.h:554 [inline]
 kzalloc include/linux/slab.h:666 [inline]
 io_ring_ctx_alloc fs/io_uring.c:1030 [inline]
 io_uring_create fs/io_uring.c:8308 [inline]
 io_uring_setup fs/io_uring.c:8401 [inline]
 __do_sys_io_uring_setup fs/io_uring.c:8407 [inline]
 __se_sys_io_uring_setup+0x5ce/0x2c70 fs/io_uring.c:8404
 do_syscall_64+0x31/0x70 arch/x86/entry/common.c:46
 entry_SYSCALL_64_after_hwframe+0x44/0xa9

Freed by task 5:
 kasan_save_stack mm/kasan/common.c:48 [inline]
 kasan_set_track+0x3d/0x70 mm/kasan/common.c:56
 kasan_set_free_info+0x17/0x30 mm/kasan/generic.c:355
 __kasan_slab_free+0xdd/0x110 mm/kasan/common.c:422
 __cache_free mm/slab.c:3418 [inline]
 kfree+0x10a/0x220 mm/slab.c:3756
 process_one_work+0x789/0xfc0 kernel/workqueue.c:2269
 worker_thread+0xaa4/0x1460 kernel/workqueue.c:2415
 kthread+0x37e/0x3a0 drivers/block/aoe/aoecmd.c:1234
 ret_from_fork+0x1f/0x30 arch/x86/entry/entry_64.S:294

Last call_rcu():
 kasan_save_stack+0x27/0x50 mm/kasan/common.c:48
 kasan_record_aux_stack+0x7b/0xb0 mm/kasan/generic.c:346
 __call_rcu kernel/rcu/tree.c:2894 [inline]
 call_rcu+0x139/0x840 kernel/rcu/tree.c:2968
 __percpu_ref_switch_to_atomic lib/percpu-refcount.c:192 [inline]
 __percpu_ref_switch_mode+0x2c1/0x4f0 lib/percpu-refcount.c:237
 percpu_ref_kill_and_confirm+0x8f/0x130 lib/percpu-refcount.c:350
 percpu_ref_kill include/linux/percpu-refcount.h:136 [inline]
 io_ring_ctx_wait_and_kill+0x3c/0x570 fs/io_uring.c:7797
 io_uring_release+0x59/0x70 fs/io_uring.c:7829
 __fput+0x34f/0x7b0 fs/file_table.c:281
 task_work_run+0x137/0x1c0 kernel/task_work.c:135
 tracehook_notify_resume include/linux/tracehook.h:188 [inline]
 exit_to_user_mode_loop kernel/entry/common.c:139 [inline]
 exit_to_user_mode_prepare+0xfa/0x1c0 kernel/entry/common.c:166
 syscall_exit_to_user_mode+0x5e/0x1a0 kernel/entry/common.c:241
 entry_SYSCALL_64_after_hwframe+0x44/0xa9

Second to last call_rcu():
 kasan_save_stack+0x27/0x50 mm/kasan/common.c:48
 kasan_record_aux_stack+0x7b/0xb0 mm/kasan/generic.c:346
 __call_rcu kernel/rcu/tree.c:2894 [inline]
 call_rcu+0x139/0x840 kernel/rcu/tree.c:2968
 __percpu_ref_switch_to_atomic lib/percpu-refcount.c:192 [inline]
 __percpu_ref_switch_mode+0x2c1/0x4f0 lib/percpu-refcount.c:237
 percpu_ref_kill_and_confirm+0x8f/0x130 lib/percpu-refcount.c:350
 percpu_ref_kill include/linux/percpu-refcount.h:136 [inline]
 io_ring_ctx_wait_and_kill+0x3c/0x570 fs/io_uring.c:7797
 io_uring_release+0x59/0x70 fs/io_uring.c:7829
 __fput+0x34f/0x7b0 fs/file_table.c:281
 task_work_run+0x137/0x1c0 kernel/task_work.c:135
 tracehook_notify_resume include/linux/tracehook.h:188 [inline]
 exit_to_user_mode_loop kernel/entry/common.c:139 [inline]
 exit_to_user_mode_prepare+0xfa/0x1c0 kernel/entry/common.c:166
 syscall_exit_to_user_mode+0x5e/0x1a0 kernel/entry/common.c:241
 entry_SYSCALL_64_after_hwframe+0x44/0xa9

The buggy address belongs to the object at ffff888095250000
 which belongs to the cache kmalloc-2k of size 2048
The buggy address is located 960 bytes inside of
 2048-byte region [ffff888095250000, ffff888095250800)
The buggy address belongs to the page:
page:000000005a2c89d9 refcount:1 mapcount:0 mapping:0000000000000000 index:0x0 pfn:0x95250
flags: 0xfffe0000000200(slab)
raw: 00fffe0000000200 ffffea00024ca6c8 ffffea00024d8c48 ffff8880aa440800
raw: 0000000000000000 ffff888095250000 0000000100000001 0000000000000000
page dumped because: kasan: bad access detected

Memory state around the buggy address:
 ffff888095250280: fb fb fb fb fb fb fb fb fb fb fb fb fb fb fb fb
 ffff888095250300: fb fb fb fb fb fb fb fb fb fb fb fb fb fb fb fb
>ffff888095250380: fb fb fb fb fb fb fb fb fb fb fb fb fb fb fb fb
                                           ^
 ffff888095250400: fb fb fb fb fb fb fb fb fb fb fb fb fb fb fb fb
 ffff888095250480: fb fb fb fb fb fb fb fb fb fb fb fb fb fb fb fb
==================================================================


---
This report is generated by a bot. It may contain errors.
See https://goo.gl/tpsmEJ for more information about syzbot.
syzbot engineers can be reached at syzkaller@googlegroups.com.

syzbot will keep track of this issue. See:
https://goo.gl/tpsmEJ#status for how to communicate with syzbot.
syzbot can test patches for this issue, for details see:
https://goo.gl/tpsmEJ#testing-patches
