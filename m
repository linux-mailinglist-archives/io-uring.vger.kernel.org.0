Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 734FE266679
	for <lists+io-uring@lfdr.de>; Fri, 11 Sep 2020 19:28:51 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726094AbgIKR2l (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Fri, 11 Sep 2020 13:28:41 -0400
Received: from mail-io1-f70.google.com ([209.85.166.70]:35767 "EHLO
        mail-io1-f70.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726287AbgIKR2U (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Fri, 11 Sep 2020 13:28:20 -0400
Received: by mail-io1-f70.google.com with SMTP id e83so7346650ioa.2
        for <io-uring@vger.kernel.org>; Fri, 11 Sep 2020 10:28:19 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:date:in-reply-to:message-id:subject
         :from:to;
        bh=1HRQZSHIuQzsMOzww47L1ehzI1lYUqlvWhyszfusKO4=;
        b=YKt2060rwrllGPSV4R3xIxoSedZyZ6YL2Hk9+mIsuCrQCho51MSmlypjNg2LHBI0hg
         Fvl4zLU8WIboRD/8slYiSqULmKkCkN2JKRsBsNPDU2o4sctbdozrhkiugByqPqRxPSVI
         /5N2bKvogLa7jSnH3hXgxIGWBMsA1MVyrfDp9a2j+2ySWx1On2Tf9nfMzRvW9iu2aeuH
         fPktpXbSsbmKFY10hguAN7JE4dGFgWh6liJxEWrln9MYmwACEZnTBd21xWRtnAZc4Uw1
         gLWQ5gH4XJBOiR5P1FUfhBqb4KkDhqUNxCFRZOREWJe81bADA5ql1J0JP+3s3Eoql3Sw
         JIGw==
X-Gm-Message-State: AOAM5337cDl64276KwkSGDLEFAdC03YWsZBLZZTEGu/WoX7uljibhaCM
        dvrgusfmM6fqLhVSjQeQqkEJ2qkJ16hCOFBUe6ItFajRxYIy
X-Google-Smtp-Source: ABdhPJwFt7MsDZF43S5VTnXpwzh3wkDps7Hpvkv1eRonV9F5mIY00Fkm3g9NAlar1dbK6206AH8K2qOfBwOPALhpLZubrw6emAJT
MIME-Version: 1.0
X-Received: by 2002:a02:a498:: with SMTP id d24mr2942583jam.137.1599845298770;
 Fri, 11 Sep 2020 10:28:18 -0700 (PDT)
Date:   Fri, 11 Sep 2020 10:28:18 -0700
In-Reply-To: <0000000000002b721a05aec0f937@google.com>
X-Google-Appengine-App-Id: s~syzkaller
X-Google-Appengine-App-Id-Alias: syzkaller
Message-ID: <000000000000ba9afd05af0d0229@google.com>
Subject: Re: KASAN: use-after-free Write in io_wq_worker_running
From:   syzbot <syzbot+45fa0a195b941764e0f0@syzkaller.appspotmail.com>
To:     axboe@kernel.dk, io-uring@vger.kernel.org,
        linux-fsdevel@vger.kernel.org, linux-kernel@vger.kernel.org,
        syzkaller-bugs@googlegroups.com, viro@zeniv.linux.org.uk
Content-Type: text/plain; charset="UTF-8"
Sender: io-uring-owner@vger.kernel.org
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org

syzbot has found a reproducer for the following issue on:

HEAD commit:    581cb3a2 Merge tag 'f2fs-for-5.9-rc5' of git://git.kernel...
git tree:       upstream
console output: https://syzkaller.appspot.com/x/log.txt?x=10cc47a5900000
kernel config:  https://syzkaller.appspot.com/x/.config?x=a9075b36a6ae26c9
dashboard link: https://syzkaller.appspot.com/bug?extid=45fa0a195b941764e0f0
compiler:       gcc (GCC) 10.1.0-syz 20200507
syz repro:      https://syzkaller.appspot.com/x/repro.syz?x=12e933f9900000
C reproducer:   https://syzkaller.appspot.com/x/repro.c?x=1554acdd900000

IMPORTANT: if you fix the issue, please add the following tag to the commit:
Reported-by: syzbot+45fa0a195b941764e0f0@syzkaller.appspotmail.com

==================================================================
BUG: KASAN: use-after-free in instrument_atomic_write include/linux/instrumented.h:71 [inline]
BUG: KASAN: use-after-free in atomic_inc include/asm-generic/atomic-instrumented.h:240 [inline]
BUG: KASAN: use-after-free in io_wqe_inc_running fs/io-wq.c:301 [inline]
BUG: KASAN: use-after-free in io_wq_worker_running+0xde/0x110 fs/io-wq.c:613
Write of size 4 at addr ffff8882183db08c by task io_wqe_worker-0/7771

CPU: 0 PID: 7771 Comm: io_wqe_worker-0 Not tainted 5.9.0-rc4-syzkaller #0
Hardware name: Google Google Compute Engine/Google Compute Engine, BIOS Google 01/01/2011
Call Trace:
 __dump_stack lib/dump_stack.c:77 [inline]
 dump_stack+0x198/0x1fd lib/dump_stack.c:118
 print_address_description.constprop.0.cold+0xae/0x497 mm/kasan/report.c:383
 __kasan_report mm/kasan/report.c:513 [inline]
 kasan_report.cold+0x1f/0x37 mm/kasan/report.c:530
 check_memory_region_inline mm/kasan/generic.c:186 [inline]
 check_memory_region+0x13d/0x180 mm/kasan/generic.c:192
 instrument_atomic_write include/linux/instrumented.h:71 [inline]
 atomic_inc include/asm-generic/atomic-instrumented.h:240 [inline]
 io_wqe_inc_running fs/io-wq.c:301 [inline]
 io_wq_worker_running+0xde/0x110 fs/io-wq.c:613
 schedule_timeout+0x148/0x250 kernel/time/timer.c:1879
 io_wqe_worker+0x517/0x10e0 fs/io-wq.c:580
 kthread+0x3b5/0x4a0 kernel/kthread.c:292
 ret_from_fork+0x1f/0x30 arch/x86/entry/entry_64.S:294

Allocated by task 7768:
 kasan_save_stack+0x1b/0x40 mm/kasan/common.c:48
 kasan_set_track mm/kasan/common.c:56 [inline]
 __kasan_kmalloc.constprop.0+0xbf/0xd0 mm/kasan/common.c:461
 kmem_cache_alloc_node_trace+0x17b/0x3f0 mm/slab.c:3594
 kmalloc_node include/linux/slab.h:572 [inline]
 kzalloc_node include/linux/slab.h:677 [inline]
 io_wq_create+0x57b/0xa10 fs/io-wq.c:1064
 io_init_wq_offload fs/io_uring.c:7432 [inline]
 io_sq_offload_start fs/io_uring.c:7504 [inline]
 io_uring_create fs/io_uring.c:8625 [inline]
 io_uring_setup+0x1836/0x28e0 fs/io_uring.c:8694
 do_syscall_64+0x2d/0x70 arch/x86/entry/common.c:46
 entry_SYSCALL_64_after_hwframe+0x44/0xa9

Freed by task 21:
 kasan_save_stack+0x1b/0x40 mm/kasan/common.c:48
 kasan_set_track+0x1c/0x30 mm/kasan/common.c:56
 kasan_set_free_info+0x1b/0x30 mm/kasan/generic.c:355
 __kasan_slab_free+0xd8/0x120 mm/kasan/common.c:422
 __cache_free mm/slab.c:3418 [inline]
 kfree+0x10e/0x2b0 mm/slab.c:3756
 __io_wq_destroy fs/io-wq.c:1138 [inline]
 io_wq_destroy+0x2af/0x460 fs/io-wq.c:1146
 io_finish_async fs/io_uring.c:6836 [inline]
 io_ring_ctx_free fs/io_uring.c:7870 [inline]
 io_ring_exit_work+0x1e4/0x6d0 fs/io_uring.c:7954
 process_one_work+0x94c/0x1670 kernel/workqueue.c:2269
 worker_thread+0x64c/0x1120 kernel/workqueue.c:2415
 kthread+0x3b5/0x4a0 kernel/kthread.c:292
 ret_from_fork+0x1f/0x30 arch/x86/entry/entry_64.S:294

The buggy address belongs to the object at ffff8882183db000
 which belongs to the cache kmalloc-1k of size 1024
The buggy address is located 140 bytes inside of
 1024-byte region [ffff8882183db000, ffff8882183db400)
The buggy address belongs to the page:
page:000000009bada22b refcount:1 mapcount:0 mapping:0000000000000000 index:0x0 pfn:0x2183db
flags: 0x57ffe0000000200(slab)
raw: 057ffe0000000200 ffffea0008604c48 ffffea00086a8648 ffff8880aa040700
raw: 0000000000000000 ffff8882183db000 0000000100000002 0000000000000000
page dumped because: kasan: bad access detected

Memory state around the buggy address:
 ffff8882183daf80: ff ff ff ff ff ff ff ff ff ff ff ff ff ff ff ff
 ffff8882183db000: fa fb fb fb fb fb fb fb fb fb fb fb fb fb fb fb
>ffff8882183db080: fb fb fb fb fb fb fb fb fb fb fb fb fb fb fb fb
                      ^
 ffff8882183db100: fb fb fb fb fb fb fb fb fb fb fb fb fb fb fb fb
 ffff8882183db180: fb fb fb fb fb fb fb fb fb fb fb fb fb fb fb fb
==================================================================

