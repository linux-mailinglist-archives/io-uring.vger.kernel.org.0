Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id D67C9333440
	for <lists+io-uring@lfdr.de>; Wed, 10 Mar 2021 05:13:02 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229521AbhCJEM3 (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Tue, 9 Mar 2021 23:12:29 -0500
Received: from mail-il1-f200.google.com ([209.85.166.200]:43797 "EHLO
        mail-il1-f200.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232209AbhCJEMF (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Tue, 9 Mar 2021 23:12:05 -0500
Received: by mail-il1-f200.google.com with SMTP id b4so11863140ilj.10
        for <io-uring@vger.kernel.org>; Tue, 09 Mar 2021 20:12:05 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:date:in-reply-to:message-id:subject
         :from:to;
        bh=5OqF6VJ+CXLAAtRQ+kLi1XLegd503eawwJIvdTcetWc=;
        b=mOvLo2u9u3tfFyPFCAUIjCj9tltgHpUta89hdjza2cRs55SHK8ZZJUCAC5pt1D4CF1
         1v9PBdXt0AhI7wrtv80a19B3/bnyx43VswyWouuK4hWdEq+X+HxPSyB5S4frs0WMqtCv
         sPB5hpA+ra8I3SI9jImS7EPsFcwJzgsSPmbfpnA2Poyu6FUZ9gUAPBN+GsE/ToBc5gE0
         N3vjsVGB+z+yH6rqM9El9QRLze02qnN9IXKTptxLb1SobH37dYzXTGMn/03z9V37MXo0
         lAEP6ZkXEdNfAMGC1fMRkanpLZuKvk36WvngQYU6JyX6RO++LKh7TsseTS1qSsLe5Fpx
         ClIw==
X-Gm-Message-State: AOAM5325MQdioczm1Lb2tovg667x5GFifjXL2RCpWgnE6rhxL7Y1jL0r
        HAfRBS6jvuAEMCLWOXn8qRrEzlOVRSjlU+W3sV5tyyq+mRLy
X-Google-Smtp-Source: ABdhPJxd1ttW8Ue+EVOOjJOW6RWy649Eb+T3iGy63L+9AJlmZhWiN5hNB2ipvFSKjsz7Mqc8vElwXx1F7jIzsXjsezjwmF9I4EE+
MIME-Version: 1.0
X-Received: by 2002:a02:ce8d:: with SMTP id y13mr1396469jaq.29.1615349524740;
 Tue, 09 Mar 2021 20:12:04 -0800 (PST)
Date:   Tue, 09 Mar 2021 20:12:04 -0800
In-Reply-To: <7dff5f11-817d-228a-5623-1df17b05402b@kernel.dk>
X-Google-Appengine-App-Id: s~syzkaller
X-Google-Appengine-App-Id-Alias: syzkaller
Message-ID: <0000000000009c3d4505bd26de32@google.com>
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
Read of size 8 at addr ffff88801d418c78 by task iou-sqp-10269/10271

CPU: 1 PID: 10271 Comm: iou-sqp-10269 Not tainted 5.12.0-rc2-syzkaller #0
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

Allocated by task 10269:
 kasan_save_stack+0x1b/0x40 mm/kasan/common.c:38
 kasan_set_track mm/kasan/common.c:46 [inline]
 set_alloc_info mm/kasan/common.c:427 [inline]
 ____kasan_kmalloc mm/kasan/common.c:506 [inline]
 ____kasan_kmalloc mm/kasan/common.c:465 [inline]
 __kasan_kmalloc+0x99/0xc0 mm/kasan/common.c:515
 kmalloc include/linux/slab.h:554 [inline]
 kzalloc include/linux/slab.h:684 [inline]
 io_get_sq_data fs/io_uring.c:7153 [inline]
 io_sq_offload_create fs/io_uring.c:7827 [inline]
 io_uring_create fs/io_uring.c:9443 [inline]
 io_uring_setup+0x154b/0x2940 fs/io_uring.c:9523
 do_syscall_64+0x2d/0x70 arch/x86/entry/common.c:46
 entry_SYSCALL_64_after_hwframe+0x44/0xae

Freed by task 9:
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
 io_put_sq_data fs/io_uring.c:7095 [inline]
 io_sq_thread_finish+0x48e/0x5b0 fs/io_uring.c:7113
 io_ring_ctx_free fs/io_uring.c:8355 [inline]
 io_ring_exit_work+0x333/0xcf0 fs/io_uring.c:8525
 process_one_work+0x98d/0x1600 kernel/workqueue.c:2275
 worker_thread+0x64c/0x1120 kernel/workqueue.c:2421
 kthread+0x3b1/0x4a0 kernel/kthread.c:292
 ret_from_fork+0x1f/0x30 arch/x86/entry/entry_64.S:294

The buggy address belongs to the object at ffff88801d418c00
 which belongs to the cache kmalloc-512 of size 512
The buggy address is located 120 bytes inside of
 512-byte region [ffff88801d418c00, ffff88801d418e00)
The buggy address belongs to the page:
page:00000000311e6f59 refcount:1 mapcount:0 mapping:0000000000000000 index:0x0 pfn:0x1d418
head:00000000311e6f59 order:2 compound_mapcount:0 compound_pincount:0
flags: 0xfff00000010200(slab|head)
raw: 00fff00000010200 dead000000000100 dead000000000122 ffff88800fc41c80
raw: 0000000000000000 0000000000100010 00000001ffffffff 0000000000000000
page dumped because: kasan: bad access detected

Memory state around the buggy address:
 ffff88801d418b00: fc fc fc fc fc fc fc fc fc fc fc fc fc fc fc fc
 ffff88801d418b80: fc fc fc fc fc fc fc fc fc fc fc fc fc fc fc fc
>ffff88801d418c00: fa fb fb fb fb fb fb fb fb fb fb fb fb fb fb fb
                                                                ^
 ffff88801d418c80: fb fb fb fb fb fb fb fb fb fb fb fb fb fb fb fb
 ffff88801d418d00: fb fb fb fb fb fb fb fb fb fb fb fb fb fb fb fb
==================================================================


Tested on:

commit:         dc5c40fb io_uring: always wait for sqd exited when stoppin..
git tree:       git://git.kernel.dk/linux-block io_uring-5.12
console output: https://syzkaller.appspot.com/x/log.txt?x=111d175cd00000
kernel config:  https://syzkaller.appspot.com/x/.config?x=b3c6cab008c50864
dashboard link: https://syzkaller.appspot.com/bug?extid=ac39856cb1b332dbbdda
compiler:       

