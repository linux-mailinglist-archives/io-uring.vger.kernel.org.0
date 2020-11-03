Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 51CBE2A4D57
	for <lists+io-uring@lfdr.de>; Tue,  3 Nov 2020 18:43:40 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729005AbgKCRnc (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Tue, 3 Nov 2020 12:43:32 -0500
Received: from mail-il1-f198.google.com ([209.85.166.198]:36788 "EHLO
        mail-il1-f198.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727971AbgKCRn2 (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Tue, 3 Nov 2020 12:43:28 -0500
Received: by mail-il1-f198.google.com with SMTP id r12so13417057iln.3
        for <io-uring@vger.kernel.org>; Tue, 03 Nov 2020 09:43:26 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:date:message-id:subject:from:to;
        bh=cOp2atVuyrM4HQesHV0mHLyZ8BWipQWU0PDBlpE2oIs=;
        b=AHx5ntjAosjS99ziN9sGXJQXCe7KWcQ/ZIrUv3rNel4fMuDynspoBXN3KMQGljBpLh
         7OF9t/9O6f9JM4axCpYW9RR/ZFx9vSO4TOuU9xkYXRW+NMqYuAUcnUaR9loEpQ1Ufy1m
         6Iy5Ie2iSsoGKR3T363wXoVFf/cOC2/vzToJPw+R5WJWKWPfZp4sAnBZgvt7GjnIgioK
         vJFe5c3yI7T0OlHoODB0jxuwrakABzz/Oo7jZSH/3kveqhTb+zWZlhDN09ZZypQHpGPQ
         6hLNZXlTgu3VusvndTq2OnYJ2wdJOD/+peAXhgk7tlwz6U5nsOmq/j77GL/aYCsClEOL
         OsUQ==
X-Gm-Message-State: AOAM533sH/5smeQ52XpKK1w0AuIjVcXpTZA9wfIIh+TqM6TkuUH/BeD7
        G3hNMtKNfSpGD66il6pKBtF8UjGPz7TKET9kuUeqkkrAfYWM
X-Google-Smtp-Source: ABdhPJygcscVZKNTTagOZ10gSni9xWDoDMuFCaXDyT73cyic5gEhSPh4UnvHgkWurxD2W+EW5RAVJ4W37E4yuHT8boMIZpnO/bL8
MIME-Version: 1.0
X-Received: by 2002:a92:850f:: with SMTP id f15mr3146516ilh.286.1604425405855;
 Tue, 03 Nov 2020 09:43:25 -0800 (PST)
Date:   Tue, 03 Nov 2020 09:43:25 -0800
X-Google-Appengine-App-Id: s~syzkaller
X-Google-Appengine-App-Id-Alias: syzkaller
Message-ID: <000000000000627c8805b33766e9@google.com>
Subject: KASAN: use-after-free Write in io_submit_sqes
From:   syzbot <syzbot+625ce3bb7835b63f7f3d@syzkaller.appspotmail.com>
To:     axboe@kernel.dk, io-uring@vger.kernel.org,
        linux-fsdevel@vger.kernel.org, linux-kernel@vger.kernel.org,
        syzkaller-bugs@googlegroups.com, viro@zeniv.linux.org.uk
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org

Hello,

syzbot found the following issue on:

HEAD commit:    b49976d8 Add linux-next specific files for 20201102
git tree:       linux-next
console output: https://syzkaller.appspot.com/x/log.txt?x=16a02732500000
kernel config:  https://syzkaller.appspot.com/x/.config?x=fe87d079ac78e2be
dashboard link: https://syzkaller.appspot.com/bug?extid=625ce3bb7835b63f7f3d
compiler:       gcc (GCC) 10.1.0-syz 20200507
syz repro:      https://syzkaller.appspot.com/x/repro.syz?x=12de9346500000
C reproducer:   https://syzkaller.appspot.com/x/repro.c?x=1213fda8500000

IMPORTANT: if you fix the issue, please add the following tag to the commit:
Reported-by: syzbot+625ce3bb7835b63f7f3d@syzkaller.appspotmail.com

IPVS: ftp: loaded support on port[0] = 21
==================================================================
BUG: KASAN: use-after-free in instrument_atomic_read_write include/linux/instrumented.h:101 [inline]
BUG: KASAN: use-after-free in atomic_fetch_add_relaxed include/asm-generic/atomic-instrumented.h:142 [inline]
BUG: KASAN: use-after-free in __refcount_add include/linux/refcount.h:193 [inline]
BUG: KASAN: use-after-free in __refcount_inc include/linux/refcount.h:250 [inline]
BUG: KASAN: use-after-free in refcount_inc include/linux/refcount.h:267 [inline]
BUG: KASAN: use-after-free in io_init_req fs/io_uring.c:6700 [inline]
BUG: KASAN: use-after-free in io_submit_sqes+0x15a9/0x25f0 fs/io_uring.c:6774
Write of size 4 at addr ffff888011e08e48 by task syz-executor165/8487

CPU: 1 PID: 8487 Comm: syz-executor165 Not tainted 5.10.0-rc1-next-20201102-syzkaller #0
Hardware name: Google Google Compute Engine/Google Compute Engine, BIOS Google 01/01/2011
Call Trace:
 __dump_stack lib/dump_stack.c:77 [inline]
 dump_stack+0x107/0x163 lib/dump_stack.c:118
 print_address_description.constprop.0.cold+0xae/0x4c8 mm/kasan/report.c:385
 __kasan_report mm/kasan/report.c:545 [inline]
 kasan_report.cold+0x1f/0x37 mm/kasan/report.c:562
 check_memory_region_inline mm/kasan/generic.c:186 [inline]
 check_memory_region+0x13d/0x180 mm/kasan/generic.c:192
 instrument_atomic_read_write include/linux/instrumented.h:101 [inline]
 atomic_fetch_add_relaxed include/asm-generic/atomic-instrumented.h:142 [inline]
 __refcount_add include/linux/refcount.h:193 [inline]
 __refcount_inc include/linux/refcount.h:250 [inline]
 refcount_inc include/linux/refcount.h:267 [inline]
 io_init_req fs/io_uring.c:6700 [inline]
 io_submit_sqes+0x15a9/0x25f0 fs/io_uring.c:6774
 __do_sys_io_uring_enter+0xc8e/0x1b50 fs/io_uring.c:9159
 do_syscall_64+0x2d/0x70 arch/x86/entry/common.c:46
 entry_SYSCALL_64_after_hwframe+0x44/0xa9
RIP: 0033:0x440e19
Code: 18 89 d0 c3 66 2e 0f 1f 84 00 00 00 00 00 0f 1f 00 48 89 f8 48 89 f7 48 89 d6 48 89 ca 4d 89 c2 4d 89 c8 4c 8b 4c 24 08 0f 05 <48> 3d 01 f0 ff ff 0f 83 eb 0f fc ff c3 66 2e 0f 1f 84 00 00 00 00
RSP: 002b:00007fff644ff178 EFLAGS: 00000246 ORIG_RAX: 00000000000001aa
RAX: ffffffffffffffda RBX: 0000000000000005 RCX: 0000000000440e19
RDX: 0000000000000000 RSI: 000000000000450c RDI: 0000000000000003
RBP: 0000000000000004 R08: 0000000000000000 R09: 0000000000000000
R10: 0000000000000000 R11: 0000000000000246 R12: 00000000022b4850
R13: 0000000000000010 R14: 0000000000000000 R15: 0000000000000000

Allocated by task 8487:
 kasan_save_stack+0x1b/0x40 mm/kasan/common.c:48
 kasan_set_track mm/kasan/common.c:56 [inline]
 __kasan_kmalloc.constprop.0+0xc2/0xd0 mm/kasan/common.c:461
 kmalloc include/linux/slab.h:552 [inline]
 io_register_personality fs/io_uring.c:9638 [inline]
 __io_uring_register fs/io_uring.c:9874 [inline]
 __do_sys_io_uring_register+0x10f0/0x40a0 fs/io_uring.c:9924
 do_syscall_64+0x2d/0x70 arch/x86/entry/common.c:46
 entry_SYSCALL_64_after_hwframe+0x44/0xa9

Freed by task 8487:
 kasan_save_stack+0x1b/0x40 mm/kasan/common.c:48
 kasan_set_track+0x1c/0x30 mm/kasan/common.c:56
 kasan_set_free_info+0x1b/0x30 mm/kasan/generic.c:355
 __kasan_slab_free+0x102/0x140 mm/kasan/common.c:422
 slab_free_hook mm/slub.c:1544 [inline]
 slab_free_freelist_hook+0x5d/0x150 mm/slub.c:1577
 slab_free mm/slub.c:3140 [inline]
 kfree+0xdb/0x360 mm/slub.c:4122
 io_identity_cow fs/io_uring.c:1380 [inline]
 io_prep_async_work+0x903/0xbc0 fs/io_uring.c:1492
 io_prep_async_link fs/io_uring.c:1505 [inline]
 io_req_defer fs/io_uring.c:5999 [inline]
 io_queue_sqe+0x212/0xed0 fs/io_uring.c:6448
 io_submit_sqe fs/io_uring.c:6542 [inline]
 io_submit_sqes+0x14f6/0x25f0 fs/io_uring.c:6784
 __do_sys_io_uring_enter+0xc8e/0x1b50 fs/io_uring.c:9159
 do_syscall_64+0x2d/0x70 arch/x86/entry/common.c:46
 entry_SYSCALL_64_after_hwframe+0x44/0xa9

The buggy address belongs to the object at ffff888011e08e00
 which belongs to the cache kmalloc-96 of size 96
The buggy address is located 72 bytes inside of
 96-byte region [ffff888011e08e00, ffff888011e08e60)
The buggy address belongs to the page:
page:00000000a7104751 refcount:1 mapcount:0 mapping:0000000000000000 index:0x0 pfn:0x11e08
flags: 0xfff00000000200(slab)
raw: 00fff00000000200 ffffea00004f8540 0000001f00000002 ffff888010041780
raw: 0000000000000000 0000000080200020 00000001ffffffff 0000000000000000
page dumped because: kasan: bad access detected

Memory state around the buggy address:
 ffff888011e08d00: 00 00 00 00 00 00 00 00 00 00 00 00 fc fc fc fc
 ffff888011e08d80: 00 00 00 00 00 00 00 00 00 00 00 00 fc fc fc fc
>ffff888011e08e00: fa fb fb fb fb fb fb fb fb fb fb fb fc fc fc fc
                                              ^
 ffff888011e08e80: 00 00 00 00 00 00 00 00 00 00 00 00 fc fc fc fc
 ffff888011e08f00: 00 00 00 00 00 00 00 00 00 00 00 00 fc fc fc fc
==================================================================


---
This report is generated by a bot. It may contain errors.
See https://goo.gl/tpsmEJ for more information about syzbot.
syzbot engineers can be reached at syzkaller@googlegroups.com.

syzbot will keep track of this issue. See:
https://goo.gl/tpsmEJ#status for how to communicate with syzbot.
syzbot can test patches for this issue, for details see:
https://goo.gl/tpsmEJ#testing-patches
