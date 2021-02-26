Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 478AE32600E
	for <lists+io-uring@lfdr.de>; Fri, 26 Feb 2021 10:31:16 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229954AbhBZJaB (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Fri, 26 Feb 2021 04:30:01 -0500
Received: from mail-il1-f200.google.com ([209.85.166.200]:50245 "EHLO
        mail-il1-f200.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230384AbhBZJ15 (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Fri, 26 Feb 2021 04:27:57 -0500
Received: by mail-il1-f200.google.com with SMTP id x11so6550336ill.17
        for <io-uring@vger.kernel.org>; Fri, 26 Feb 2021 01:27:41 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:date:message-id:subject:from:to;
        bh=2QGJQNwRyRtPyEnRhscM9rxJei+GAaXg9Ct3gvOlSpQ=;
        b=qFJveC2oXmRzZY7AgaYQJkkTzfJmD1xMAFZxXfUEjVdXvExJ83w5+My6SLf8Pl/WzO
         vLAWeyUcPjwS+vB7uJ8hh+dtHuN8gzSV+MmoBKvduDjXoC6Wi26R75KXOnALYZgwW05a
         b/va/HkiFposYuwBGemA5rFLCCAcATfQoRPQLxANETGk1H/BXrLxLjqQ93k9jDYOVzYo
         2ZR/POZ4JzkYYV+6ZTgUvJp5rDKHCZcYFPv2bRNH0xRk0lBa0ASKe16icMSN90HBuy71
         Ir4Zm0xsfi0vGkpIXKxFVLgWXFmPRl5DLP9xuTbDzxpTn7uxV9/PCLhJooyoUfaNrxF0
         B/Ig==
X-Gm-Message-State: AOAM532LcaCc9+QE9gROJqgWqDI6CxXoxb2knRW2Wr3vT+pzorf2xpDK
        AzlhmtraCOr+WUGt+CHMRj/sfVL0EKDtuydFQ43Bal8RUnYX
X-Google-Smtp-Source: ABdhPJwsCMwGdE2PR/+hyNw1WOx6H2ogMBXfZ6d0Jhgg+XtYwayAXpdXTsyply9ZekortrmQ4cQmHJ3yKLCVGAQmewWPXg0IPBnS
MIME-Version: 1.0
X-Received: by 2002:a02:1c49:: with SMTP id c70mr2067617jac.136.1614331636391;
 Fri, 26 Feb 2021 01:27:16 -0800 (PST)
Date:   Fri, 26 Feb 2021 01:27:16 -0800
X-Google-Appengine-App-Id: s~syzkaller
X-Google-Appengine-App-Id-Alias: syzkaller
Message-ID: <000000000000bca1c105bc39df89@google.com>
Subject: KASAN: use-after-free Read in io_sq_thread
From:   syzbot <syzbot+edf737ddc3001895469f@syzkaller.appspotmail.com>
To:     asml.silence@gmail.com, axboe@kernel.dk, io-uring@vger.kernel.org,
        linux-kernel@vger.kernel.org, syzkaller-bugs@googlegroups.com
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org

Hello,

syzbot found the following issue on:

HEAD commit:    7f206cf3 Add linux-next specific files for 20210225
git tree:       linux-next
console output: https://syzkaller.appspot.com/x/log.txt?x=16746466d00000
kernel config:  https://syzkaller.appspot.com/x/.config?x=a1746d2802a82a05
dashboard link: https://syzkaller.appspot.com/bug?extid=edf737ddc3001895469f
syz repro:      https://syzkaller.appspot.com/x/repro.syz?x=1388fb82d00000
C reproducer:   https://syzkaller.appspot.com/x/repro.c?x=16a10666d00000

IMPORTANT: if you fix the issue, please add the following tag to the commit:
Reported-by: syzbot+edf737ddc3001895469f@syzkaller.appspotmail.com

==================================================================
BUG: KASAN: use-after-free in __lock_acquire+0x3e6f/0x54c0 kernel/locking/lockdep.c:4770
Read of size 8 at addr ffff8881444a3a88 by task iou-sqp-7185/7188

CPU: 0 PID: 7188 Comm: iou-sqp-7185 Not tainted 5.11.0-next-20210225-syzkaller #0
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
 complete+0x13/0x60 kernel/sched/completion.c:32
 io_sq_thread+0x1225/0x19a0 fs/io_uring.c:6808
 ret_from_fork+0x1f/0x30 arch/x86/entry/entry_64.S:294

Allocated by task 7185:
 kasan_save_stack+0x1b/0x40 mm/kasan/common.c:38
 kasan_set_track mm/kasan/common.c:46 [inline]
 set_alloc_info mm/kasan/common.c:427 [inline]
 ____kasan_kmalloc mm/kasan/common.c:506 [inline]
 ____kasan_kmalloc mm/kasan/common.c:465 [inline]
 __kasan_kmalloc+0x99/0xc0 mm/kasan/common.c:515
 kmalloc include/linux/slab.h:554 [inline]
 kzalloc include/linux/slab.h:684 [inline]
 io_get_sq_data fs/io_uring.c:7202 [inline]
 io_sq_offload_create fs/io_uring.c:7875 [inline]
 io_uring_create fs/io_uring.c:9465 [inline]
 io_uring_setup+0x173e/0x2c20 fs/io_uring.c:9550
 do_syscall_64+0x2d/0x70 arch/x86/entry/common.c:46
 entry_SYSCALL_64_after_hwframe+0x44/0xae

Freed by task 10279:
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
 kfree+0xe5/0x7b0 mm/slub.c:4213
 io_put_sq_data fs/io_uring.c:7142 [inline]
 io_sq_thread_finish+0x474/0x580 fs/io_uring.c:7164
 io_ring_ctx_free fs/io_uring.c:8408 [inline]
 io_ring_exit_work+0x7e/0x4a0 fs/io_uring.c:8540
 process_one_work+0x98d/0x1600 kernel/workqueue.c:2275
 worker_thread+0x64c/0x1120 kernel/workqueue.c:2421
 kthread+0x3b1/0x4a0 kernel/kthread.c:292
 ret_from_fork+0x1f/0x30 arch/x86/entry/entry_64.S:294

The buggy address belongs to the object at ffff8881444a3800
 which belongs to the cache kmalloc-1k of size 1024
The buggy address is located 648 bytes inside of
 1024-byte region [ffff8881444a3800, ffff8881444a3c00)
The buggy address belongs to the page:
page:00000000299b6ff4 refcount:1 mapcount:0 mapping:0000000000000000 index:0x0 pfn:0x1444a0
head:00000000299b6ff4 order:3 compound_mapcount:0 compound_pincount:0
flags: 0x57ff00000010200(slab|head)
raw: 057ff00000010200 dead000000000100 dead000000000122 ffff888010841dc0
raw: 0000000000000000 0000000000100010 00000001ffffffff 0000000000000000
page dumped because: kasan: bad access detected

Memory state around the buggy address:
 ffff8881444a3980: fb fb fb fb fb fb fb fb fb fb fb fb fb fb fb fb
 ffff8881444a3a00: fb fb fb fb fb fb fb fb fb fb fb fb fb fb fb fb
>ffff8881444a3a80: fb fb fb fb fb fb fb fb fb fb fb fb fb fb fb fb
                      ^
 ffff8881444a3b00: fb fb fb fb fb fb fb fb fb fb fb fb fb fb fb fb
 ffff8881444a3b80: fb fb fb fb fb fb fb fb fb fb fb fb fb fb fb fb
==================================================================


---
This report is generated by a bot. It may contain errors.
See https://goo.gl/tpsmEJ for more information about syzbot.
syzbot engineers can be reached at syzkaller@googlegroups.com.

syzbot will keep track of this issue. See:
https://goo.gl/tpsmEJ#status for how to communicate with syzbot.
syzbot can test patches for this issue, for details see:
https://goo.gl/tpsmEJ#testing-patches
