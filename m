Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 3C7A3333181
	for <lists+io-uring@lfdr.de>; Tue,  9 Mar 2021 23:29:54 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231786AbhCIW3W (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Tue, 9 Mar 2021 17:29:22 -0500
Received: from mail-io1-f70.google.com ([209.85.166.70]:44487 "EHLO
        mail-io1-f70.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231616AbhCIW3I (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Tue, 9 Mar 2021 17:29:08 -0500
Received: by mail-io1-f70.google.com with SMTP id e11so11469025ioh.11
        for <io-uring@vger.kernel.org>; Tue, 09 Mar 2021 14:29:08 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:date:in-reply-to:message-id:subject
         :from:to;
        bh=PQso78x2Ip38ysvdHoRSbRvnHk2JHjvSWKdvT8Oo9sI=;
        b=aPPddljiM5v8MOAb52LivUmi715Vx4HoKNCwen9WMBFvqmtswLN9MH7pBtY3oTKmai
         GXVpTssmHxFIS3/4sfvHNlOMBCejMtXwAn15fXgKGbPEHYJ+2ygsIutubayQUk9+dFiC
         30eagxbygeAOTZtxTsZcRr+FCFcZ859UZB11cOUPM8lqV9B91Db4eCbQqJq9pLcjwZsi
         LPd6D0JToqfrUJ6G8irFxAygVHVZIauA4jJSTPFYGJT70oeR2bDSZNQ5UdLWQK42OJRp
         PF0sf8fijeTQUqKxdD1yK4NWSmLv+0gG5qP9dDZekzNvyQrm0kx/dBQmehIN3EZmVdKd
         4xvw==
X-Gm-Message-State: AOAM530IT3z6T+l3HbRzZ28QW3TkTFC6xpKNZwaaeytCsonCPqFJKHzl
        a7G8vAFdNnLTkPAVGHnb9vN12geGpH9EwA8ANpk16mq8VFXw
X-Google-Smtp-Source: ABdhPJwZ0E4ItVKmpmoseEH+bM2+/xoi9wS7cY5SOgfLmCK5f6TMnaMADNjJ6W95smrFHOPrV8BrcGm4oMZ4+YaMWd/kanBRZt2K
MIME-Version: 1.0
X-Received: by 2002:a5d:8249:: with SMTP id n9mr257191ioo.31.1615328947973;
 Tue, 09 Mar 2021 14:29:07 -0800 (PST)
Date:   Tue, 09 Mar 2021 14:29:07 -0800
In-Reply-To: <5112d102-d849-c640-868f-ee820163d02e@kernel.dk>
X-Google-Appengine-App-Id: s~syzkaller
X-Google-Appengine-App-Id-Alias: syzkaller
Message-ID: <00000000000023b36405bd221483@google.com>
Subject: Re: [syzbot] possible deadlock in io_sq_thread_finish
From:   syzbot <syzbot+ac39856cb1b332dbbdda@syzkaller.appspotmail.com>
To:     asml.silence@gmail.com, axboe@kernel.dk, io-uring@vger.kernel.org,
        linux-kernel@vger.kernel.org, syzkaller-bugs@googlegroups.com
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org

Hello,

syzbot has tested the proposed patch but the reproducer is still triggering an issue:
KASAN: use-after-free Read in io_sq_thread

==================================================================
BUG: KASAN: use-after-free in __lock_acquire+0x3e6f/0x54c0 kernel/locking/lockdep.c:4770
Read of size 8 at addr ffff888034cbfc78 by task iou-sqp-10518/10523

CPU: 0 PID: 10523 Comm: iou-sqp-10518 Not tainted 5.12.0-rc2-syzkaller #0
Hardware name: Google Google Compute Engine/Google Compute Engine, BIOS Google 01/01/2011
Call Trace:
 __dump_stack lib/dump_stack.c:79 [inline]
 dump_stack+0x141/0x1d7 lib/dump_stack.c:120
 print_address_description.constprop.0.cold+0x5b/0x2f8 mm/kasan/report.c:232
 __kasan_report mm/kasan/report.c:399 [inline]
 kasan_report.cold+0x7c/0xd8 mm/kasan/report.c:416
 __lock_acquire+0x3e6f/0x54c0 kernel/locking/lockdep.c:4770
 lock_acquire kernel/locking/lockdep.c:5510 [inline]
 lock_acquire+0x1ab/0x740 kernel/locking/lockdep.c:5475
 down_write+0x92/0x150 kernel/locking/rwsem.c:1406
 io_sq_thread+0x1220/0x1b10 fs/io_uring.c:6754
 ret_from_fork+0x1f/0x30 arch/x86/entry/entry_64.S:294

Allocated by task 10518:
 kasan_save_stack+0x1b/0x40 mm/kasan/common.c:38
 kasan_set_track mm/kasan/common.c:46 [inline]
 set_alloc_info mm/kasan/common.c:427 [inline]
 ____kasan_kmalloc mm/kasan/common.c:506 [inline]
 ____kasan_kmalloc mm/kasan/common.c:465 [inline]
 __kasan_kmalloc+0x99/0xc0 mm/kasan/common.c:515
 kmalloc include/linux/slab.h:554 [inline]
 kzalloc include/linux/slab.h:684 [inline]
 io_get_sq_data fs/io_uring.c:7156 [inline]
 io_sq_offload_create fs/io_uring.c:7830 [inline]
 io_uring_create fs/io_uring.c:9443 [inline]
 io_uring_setup+0x1552/0x2860 fs/io_uring.c:9523
 do_syscall_64+0x2d/0x70 arch/x86/entry/common.c:46
 entry_SYSCALL_64_after_hwframe+0x44/0xae

Freed by task 396:
 kasan_save_stack+0x1b/0x40 mm/kasan/common.c:38
 kasan_set_track+0x1c/0x30 mm/kasan/common.c:46
 kasan_set_free_info+0x20/0x30 mm/kasan/generic.c:357
 ____kasan_slab_free mm/kasan/common.c:360 [inline]
 ____kasan_slab_free mm/kasan/common.c:325 [inline]
 __kasan_slab_free+0xf5/0x130 mm/kasan/common.c:367
 kasan_slab_free include/linux/kasan.h:199 [inline]
 slab_free_hook mm/slub.c:1562 [inline]
 slab_free_freelist_hook+0x92/0x210 mm/slub.c:1600
 slab_free mm/slub.c:3161 [inline]
 kfree+0xe5/0x7f0 mm/slub.c:4213
 io_put_sq_data fs/io_uring.c:7098 [inline]
 io_sq_thread_finish+0x4b0/0x5f0 fs/io_uring.c:7116
 io_ring_ctx_free fs/io_uring.c:8355 [inline]
 io_ring_exit_work+0x333/0xcf0 fs/io_uring.c:8525
 process_one_work+0x98d/0x1600 kernel/workqueue.c:2275
 worker_thread+0x64c/0x1120 kernel/workqueue.c:2421
 kthread+0x3b1/0x4a0 kernel/kthread.c:292
 ret_from_fork+0x1f/0x30 arch/x86/entry/entry_64.S:294

The buggy address belongs to the object at ffff888034cbfc00
 which belongs to the cache kmalloc-512 of size 512
The buggy address is located 120 bytes inside of
 512-byte region [ffff888034cbfc00, ffff888034cbfe00)
The buggy address belongs to the page:
page:000000004a1f04c4 refcount:1 mapcount:0 mapping:0000000000000000 index:0x0 pfn:0x34cbc
head:000000004a1f04c4 order:2 compound_mapcount:0 compound_pincount:0
flags: 0xfff00000010200(slab|head)
raw: 00fff00000010200 dead000000000100 dead000000000122 ffff88800fc41c80
raw: 0000000000000000 0000000000100010 00000001ffffffff 0000000000000000
page dumped because: kasan: bad access detected

Memory state around the buggy address:
 ffff888034cbfb00: fc fc fc fc fc fc fc fc fc fc fc fc fc fc fc fc
 ffff888034cbfb80: fc fc fc fc fc fc fc fc fc fc fc fc fc fc fc fc
>ffff888034cbfc00: fa fb fb fb fb fb fb fb fb fb fb fb fb fb fb fb
                                                                ^
 ffff888034cbfc80: fb fb fb fb fb fb fb fb fb fb fb fb fb fb fb fb
 ffff888034cbfd00: fb fb fb fb fb fb fb fb fb fb fb fb fb fb fb fb
==================================================================


Tested on:

commit:         8bf06ba6 io_uring: remove unneeded variable 'ret'
git tree:       git://git.kernel.dk/linux-block io_uring-5.12
console output: https://syzkaller.appspot.com/x/log.txt?x=13fcd952d00000
kernel config:  https://syzkaller.appspot.com/x/.config?x=b3c6cab008c50864
dashboard link: https://syzkaller.appspot.com/bug?extid=ac39856cb1b332dbbdda
compiler:       

