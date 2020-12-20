Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id B6E062DF295
	for <lists+io-uring@lfdr.de>; Sun, 20 Dec 2020 02:25:14 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726915AbgLTBY5 (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Sat, 19 Dec 2020 20:24:57 -0500
Received: from mail-il1-f199.google.com ([209.85.166.199]:45830 "EHLO
        mail-il1-f199.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726902AbgLTBYv (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Sat, 19 Dec 2020 20:24:51 -0500
Received: by mail-il1-f199.google.com with SMTP id x10so6031133ilq.12
        for <io-uring@vger.kernel.org>; Sat, 19 Dec 2020 17:24:35 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:date:message-id:subject:from:to;
        bh=b6Rz9SpGo3gliA4WwCwaVIirtj/lEHbQR0C+NTE/jEA=;
        b=DpL//UyEPyzM/t3weXhnF4moSb5x25QauSVoxhYfGKyo/m8G/DylC3tbyfYHjwprTJ
         Nx2ABgzGEx9mA35hpsYkvjkkpg7OouzrB9bVlBmf+BbiPUqnlwyVyhkZ6NCpMiPwcJ5y
         whjmuax5LZMGMMu1/stEYpz959FEloQpkd7g/JBmaXRJsv7qaDsJTexcdWzg3J6oSuCE
         ciADPNID4rgoc/UK/GS1U7Km0IOInGR3S0Dsf0jFNW8I+MKkHL/iIV7bPNvS9PifB9rw
         XJ5NqvuIED2bGTDWrnun+QllfpCDtc4hXuXos24WkQS7f5ICxI1vfjPvN6BiFGwVvYE6
         nutw==
X-Gm-Message-State: AOAM531lxzZ8puesm8Z2bWXx6wXCTCh7z8FlqxA0eBFvScbFUdqRolJb
        jJDP8/ZCjpe67+5ICfAg5IREOsaEUNPLya6ilCX/1b1SjOyU
X-Google-Smtp-Source: ABdhPJyYIH5BZbXS9Ocrm8a2yKvqz7SLhEnZk2w6B36KaofKtaBuEh2ejG51w68RPzj8wMrEXXsRmSi9PSo4hFSq0FqrFnlWFH0G
MIME-Version: 1.0
X-Received: by 2002:a5e:db4d:: with SMTP id r13mr9693729iop.65.1608427450297;
 Sat, 19 Dec 2020 17:24:10 -0800 (PST)
Date:   Sat, 19 Dec 2020 17:24:10 -0800
X-Google-Appengine-App-Id: s~syzkaller
X-Google-Appengine-App-Id-Alias: syzkaller
Message-ID: <000000000000d26fda05b6db3298@google.com>
Subject: KASAN: use-after-free Read in io_ring_ctx_wait_and_kill
From:   syzbot <syzbot+fef004c4db2d363bacd3@syzkaller.appspotmail.com>
To:     axboe@kernel.dk, io-uring@vger.kernel.org,
        linux-fsdevel@vger.kernel.org, linux-kernel@vger.kernel.org,
        syzkaller-bugs@googlegroups.com, viro@zeniv.linux.org.uk
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org

Hello,

syzbot found the following issue on:

HEAD commit:    a409ed15 Merge tag 'gpio-v5.11-1' of git://git.kernel.org/..
git tree:       upstream
console output: https://syzkaller.appspot.com/x/log.txt?x=1425527b500000
kernel config:  https://syzkaller.appspot.com/x/.config?x=f7c39e7211134bc0
dashboard link: https://syzkaller.appspot.com/bug?extid=fef004c4db2d363bacd3
compiler:       gcc (GCC) 10.1.0-syz 20200507

Unfortunately, I don't have any reproducer for this issue yet.

IMPORTANT: if you fix the issue, please add the following tag to the commit:
Reported-by: syzbot+fef004c4db2d363bacd3@syzkaller.appspotmail.com

==================================================================
BUG: KASAN: use-after-free in __mutex_lock_common kernel/locking/mutex.c:938 [inline]
BUG: KASAN: use-after-free in __mutex_lock+0x102f/0x1110 kernel/locking/mutex.c:1103
Read of size 8 at addr ffff888073de33e0 by task syz-executor.1/13101

CPU: 1 PID: 13101 Comm: syz-executor.1 Not tainted 5.10.0-syzkaller #0
Hardware name: Google Google Compute Engine/Google Compute Engine, BIOS Google 01/01/2011
Call Trace:
 __dump_stack lib/dump_stack.c:79 [inline]
 dump_stack+0x107/0x163 lib/dump_stack.c:120
 print_address_description.constprop.0.cold+0xae/0x4c8 mm/kasan/report.c:385
 __kasan_report mm/kasan/report.c:545 [inline]
 kasan_report.cold+0x1f/0x37 mm/kasan/report.c:562
 __mutex_lock_common kernel/locking/mutex.c:938 [inline]
 __mutex_lock+0x102f/0x1110 kernel/locking/mutex.c:1103
 io_ring_ctx_wait_and_kill+0x21/0x450 fs/io_uring.c:8648
 io_uring_release+0x3e/0x50 fs/io_uring.c:8687
 __fput+0x283/0x920 fs/file_table.c:280
 task_work_run+0xdd/0x190 kernel/task_work.c:140
 exit_task_work include/linux/task_work.h:30 [inline]
 do_exit+0xb89/0x2a00 kernel/exit.c:823
 do_group_exit+0x125/0x310 kernel/exit.c:920
 get_signal+0x3e9/0x2160 kernel/signal.c:2770
 arch_do_signal_or_restart+0x2a8/0x1eb0 arch/x86/kernel/signal.c:811
 handle_signal_work kernel/entry/common.c:147 [inline]
 exit_to_user_mode_loop kernel/entry/common.c:171 [inline]
 exit_to_user_mode_prepare+0x124/0x200 kernel/entry/common.c:201
 __syscall_exit_to_user_mode_work kernel/entry/common.c:291 [inline]
 syscall_exit_to_user_mode+0x19/0x50 kernel/entry/common.c:302
 entry_SYSCALL_64_after_hwframe+0x44/0xa9
RIP: 0033:0x45e149
Code: Unable to access opcode bytes at RIP 0x45e11f.
RSP: 002b:00007f2290236be8 EFLAGS: 00000206 ORIG_RAX: 00000000000001a9
RAX: fffffffffffffff4 RBX: 0000000020000080 RCX: 000000000045e149
RDX: 00000000200b0000 RSI: 0000000020000080 RDI: 0000000000000001
RBP: 000000000119c080 R08: 0000000020000000 R09: 0000000020000000
R10: 0000000020000100 R11: 0000000000000206 R12: 00000000200b0000
R13: 00000000200a0000 R14: 0000000020000000 R15: 0000000020000100

Allocated by task 13101:
 kasan_save_stack+0x1b/0x40 mm/kasan/common.c:48
 kasan_set_track mm/kasan/common.c:56 [inline]
 __kasan_kmalloc.constprop.0+0xc2/0xd0 mm/kasan/common.c:461
 kmalloc include/linux/slab.h:552 [inline]
 kzalloc include/linux/slab.h:682 [inline]
 io_ring_ctx_alloc fs/io_uring.c:1268 [inline]
 io_uring_create fs/io_uring.c:9480 [inline]
 io_uring_setup+0x1d5b/0x38b0 fs/io_uring.c:9613
 do_syscall_64+0x2d/0x70 arch/x86/entry/common.c:46
 entry_SYSCALL_64_after_hwframe+0x44/0xa9

Freed by task 37:
 kasan_save_stack+0x1b/0x40 mm/kasan/common.c:48
 kasan_set_track+0x1c/0x30 mm/kasan/common.c:56
 kasan_set_free_info+0x1b/0x30 mm/kasan/generic.c:352
 __kasan_slab_free+0x102/0x140 mm/kasan/common.c:422
 slab_free_hook mm/slub.c:1544 [inline]
 slab_free_freelist_hook+0x5d/0x150 mm/slub.c:1577
 slab_free mm/slub.c:3140 [inline]
 kfree+0xdb/0x3c0 mm/slub.c:4122
 process_one_work+0x98d/0x1630 kernel/workqueue.c:2275
 worker_thread+0x64c/0x1120 kernel/workqueue.c:2421
 kthread+0x3b1/0x4a0 kernel/kthread.c:292
 ret_from_fork+0x1f/0x30 arch/x86/entry/entry_64.S:296

Last potentially related work creation:
 kasan_save_stack+0x1b/0x40 mm/kasan/common.c:48
 kasan_record_aux_stack+0xc0/0xf0 mm/kasan/generic.c:343
 insert_work+0x48/0x370 kernel/workqueue.c:1331
 __queue_work+0x5c1/0xfb0 kernel/workqueue.c:1497
 queue_work_on+0xc7/0xd0 kernel/workqueue.c:1524
 io_uring_create fs/io_uring.c:9586 [inline]
 io_uring_setup+0x1358/0x38b0 fs/io_uring.c:9613
 do_syscall_64+0x2d/0x70 arch/x86/entry/common.c:46
 entry_SYSCALL_64_after_hwframe+0x44/0xa9

The buggy address belongs to the object at ffff888073de3000
 which belongs to the cache kmalloc-2k of size 2048
The buggy address is located 992 bytes inside of
 2048-byte region [ffff888073de3000, ffff888073de3800)
The buggy address belongs to the page:
page:000000002686ff6f refcount:1 mapcount:0 mapping:0000000000000000 index:0x0 pfn:0x73de0
head:000000002686ff6f order:3 compound_mapcount:0 compound_pincount:0
flags: 0xfff00000010200(slab|head)
raw: 00fff00000010200 dead000000000100 dead000000000122 ffff888010842000
raw: 0000000000000000 0000000000080008 00000001ffffffff 0000000000000000
page dumped because: kasan: bad access detected

Memory state around the buggy address:
 ffff888073de3280: fb fb fb fb fb fb fb fb fb fb fb fb fb fb fb fb
 ffff888073de3300: fb fb fb fb fb fb fb fb fb fb fb fb fb fb fb fb
>ffff888073de3380: fb fb fb fb fb fb fb fb fb fb fb fb fb fb fb fb
                                                       ^
 ffff888073de3400: fb fb fb fb fb fb fb fb fb fb fb fb fb fb fb fb
 ffff888073de3480: fb fb fb fb fb fb fb fb fb fb fb fb fb fb fb fb
==================================================================


---
This report is generated by a bot. It may contain errors.
See https://goo.gl/tpsmEJ for more information about syzbot.
syzbot engineers can be reached at syzkaller@googlegroups.com.

syzbot will keep track of this issue. See:
https://goo.gl/tpsmEJ#status for how to communicate with syzbot.
