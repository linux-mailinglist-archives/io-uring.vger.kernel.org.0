Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 55BB01521AA
	for <lists+io-uring@lfdr.de>; Tue,  4 Feb 2020 22:06:16 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727494AbgBDVGO (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Tue, 4 Feb 2020 16:06:14 -0500
Received: from mail-il1-f199.google.com ([209.85.166.199]:53379 "EHLO
        mail-il1-f199.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727445AbgBDVGO (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Tue, 4 Feb 2020 16:06:14 -0500
Received: by mail-il1-f199.google.com with SMTP id d3so16067844ilg.20
        for <io-uring@vger.kernel.org>; Tue, 04 Feb 2020 13:06:12 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:date:message-id:subject:from:to;
        bh=Ec6H7uOKuEKDUgpYQ9tAdF70iyOvPezHib3X4v8QxEU=;
        b=VJkqrMYwWV5k9tcxnWC8SEbr4SlY1wSTh6dW+FEH8ZmYUTZLYinutoWBDAcdiEJCSl
         Ftp4xb1uq2D0IrVtypBbqFGuICmjCdj77YNYyS4fwwqH7jQgwYUBP3MbYImTWj/+AvmR
         rimJMcgXlmYvcpXz/aH2uhwq2d5j8jaHuahbZSbvCqpAnnHd7lANVxPgtC8x691IGod8
         BujEwsJmoRyaK2ABMb7nsjwrP6fWNqCnXu0OHdnT9X6VQwjQRJW/Onb3zddWtAjynW5n
         HrNHXr5PwYAwq//tIqr11Yuph2kFkfDUUQiUn6d/bCJi3Bwren3jHIQz/R5GWoVcsWy1
         kdtQ==
X-Gm-Message-State: APjAAAVmS1tiPNcbvpxMpM2XibaL8Zva0GuKLIx6wFB/YWYQGdoF7W0E
        /0CT3x4RfBWRrxrYmZEc77YS4j6tkUql4S4ofCT8P61BL4sG
X-Google-Smtp-Source: APXvYqwh32XJRILeZPcNCc2nNebeCO6epiO+CqG7Z5hpPiNEEcKCGunzGgajvqiQP8ZQkxMpbG31NChx+6SJWRbp0jq6IyqMcLv3
MIME-Version: 1.0
X-Received: by 2002:a5d:8cce:: with SMTP id k14mr26510068iot.294.1580850372422;
 Tue, 04 Feb 2020 13:06:12 -0800 (PST)
Date:   Tue, 04 Feb 2020 13:06:12 -0800
X-Google-Appengine-App-Id: s~syzkaller
X-Google-Appengine-App-Id-Alias: syzkaller
Message-ID: <000000000000e43122059dc66882@google.com>
Subject: KASAN: use-after-free Write in percpu_ref_switch_to_percpu
From:   syzbot <syzbot+7caeaea49c2c8a591e3d@syzkaller.appspotmail.com>
To:     axboe@kernel.dk, io-uring@vger.kernel.org,
        linux-fsdevel@vger.kernel.org, linux-kernel@vger.kernel.org,
        syzkaller-bugs@googlegroups.com, viro@zeniv.linux.org.uk
Content-Type: text/plain; charset="UTF-8"
Sender: io-uring-owner@vger.kernel.org
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org

Hello,

syzbot found the following crash on:

HEAD commit:    754beeec Merge tag 'char-misc-5.6-rc1-2' of git://git.kern..
git tree:       upstream
console output: https://syzkaller.appspot.com/x/log.txt?x=15fe4511e00000
kernel config:  https://syzkaller.appspot.com/x/.config?x=99db4e42d047be3
dashboard link: https://syzkaller.appspot.com/bug?extid=7caeaea49c2c8a591e3d
compiler:       gcc (GCC) 9.0.0 20181231 (experimental)

Unfortunately, I don't have any reproducer for this crash yet.

IMPORTANT: if you fix the bug, please add the following tag to the commit:
Reported-by: syzbot+7caeaea49c2c8a591e3d@syzkaller.appspotmail.com

==================================================================
BUG: KASAN: use-after-free in percpu_ref_switch_to_percpu+0x69/0x70 lib/percpu-refcount.c:314
Write of size 1 at addr ffff888095e3b430 by task kworker/1:31/2772

CPU: 1 PID: 2772 Comm: kworker/1:31 Not tainted 5.5.0-syzkaller #0
Hardware name: Google Google Compute Engine/Google Compute Engine, BIOS Google 01/01/2011
Workqueue: events io_ring_file_ref_switch
Call Trace:
 __dump_stack lib/dump_stack.c:77 [inline]
 dump_stack+0x197/0x210 lib/dump_stack.c:118
 print_address_description.constprop.0.cold+0xd4/0x30b mm/kasan/report.c:374
 __kasan_report.cold+0x1b/0x32 mm/kasan/report.c:506
 kasan_report+0x12/0x20 mm/kasan/common.c:641
 __asan_report_store1_noabort+0x17/0x20 mm/kasan/generic_report.c:137
 percpu_ref_switch_to_percpu+0x69/0x70 lib/percpu-refcount.c:314
 io_ring_file_ref_switch+0x791/0xac0 fs/io_uring.c:5499
 process_one_work+0xa05/0x17a0 kernel/workqueue.c:2264
 worker_thread+0x98/0xe40 kernel/workqueue.c:2410
 kthread+0x361/0x430 kernel/kthread.c:255
 ret_from_fork+0x24/0x30 arch/x86/entry/entry_64.S:352

Allocated by task 26829:
 save_stack+0x23/0x90 mm/kasan/common.c:72
 set_track mm/kasan/common.c:80 [inline]
 __kasan_kmalloc mm/kasan/common.c:515 [inline]
 __kasan_kmalloc.constprop.0+0xcf/0xe0 mm/kasan/common.c:488
 kasan_kmalloc+0x9/0x10 mm/kasan/common.c:529
 __do_kmalloc mm/slab.c:3656 [inline]
 __kmalloc+0x163/0x770 mm/slab.c:3665
 kmalloc include/linux/slab.h:561 [inline]
 kzalloc.constprop.0+0x1b/0x20 include/linux/slab.h:670
 io_sqe_files_register fs/io_uring.c:5528 [inline]
 __io_uring_register+0xad7/0x2f40 fs/io_uring.c:6875
 __do_sys_io_uring_register fs/io_uring.c:6955 [inline]
 __se_sys_io_uring_register fs/io_uring.c:6937 [inline]
 __x64_sys_io_uring_register+0x1a1/0x560 fs/io_uring.c:6937
 do_syscall_64+0xfa/0x790 arch/x86/entry/common.c:294
 entry_SYSCALL_64_after_hwframe+0x49/0xbe

Freed by task 26826:
 save_stack+0x23/0x90 mm/kasan/common.c:72
 set_track mm/kasan/common.c:80 [inline]
 kasan_set_free_info mm/kasan/common.c:337 [inline]
 __kasan_slab_free+0x102/0x150 mm/kasan/common.c:476
 kasan_slab_free+0xe/0x10 mm/kasan/common.c:485
 __cache_free mm/slab.c:3426 [inline]
 kfree+0x10a/0x2c0 mm/slab.c:3757
 io_sqe_files_unregister+0x2e2/0x4d0 fs/io_uring.c:5250
 io_ring_ctx_free fs/io_uring.c:6229 [inline]
 io_ring_ctx_wait_and_kill+0x447/0x9b0 fs/io_uring.c:6310
 io_uring_release+0x42/0x50 fs/io_uring.c:6318
 __fput+0x2ff/0x890 fs/file_table.c:280
 ____fput+0x16/0x20 fs/file_table.c:313
 task_work_run+0x145/0x1c0 kernel/task_work.c:113
 tracehook_notify_resume include/linux/tracehook.h:188 [inline]
 exit_to_usermode_loop+0x316/0x380 arch/x86/entry/common.c:164
 prepare_exit_to_usermode arch/x86/entry/common.c:195 [inline]
 syscall_return_slowpath arch/x86/entry/common.c:278 [inline]
 do_syscall_64+0x676/0x790 arch/x86/entry/common.c:304
 entry_SYSCALL_64_after_hwframe+0x49/0xbe

The buggy address belongs to the object at ffff888095e3b400
 which belongs to the cache kmalloc-256 of size 256
The buggy address is located 48 bytes inside of
 256-byte region [ffff888095e3b400, ffff888095e3b500)
The buggy address belongs to the page:
page:ffffea0002578ec0 refcount:1 mapcount:0 mapping:ffff8880aa4008c0 index:0x0
flags: 0xfffe0000000200(slab)
raw: 00fffe0000000200 ffffea00025c09c8 ffffea00027f8308 ffff8880aa4008c0
raw: 0000000000000000 ffff888095e3b000 0000000100000008 0000000000000000
page dumped because: kasan: bad access detected

Memory state around the buggy address:
 ffff888095e3b300: fc fc fc fc fc fc fc fc fc fc fc fc fc fc fc fc
 ffff888095e3b380: fc fc fc fc fc fc fc fc fc fc fc fc fc fc fc fc
>ffff888095e3b400: fb fb fb fb fb fb fb fb fb fb fb fb fb fb fb fb
                                     ^
 ffff888095e3b480: fb fb fb fb fb fb fb fb fb fb fb fb fb fb fb fb
 ffff888095e3b500: fc fc fc fc fc fc fc fc fc fc fc fc fc fc fc fc
==================================================================


---
This bug is generated by a bot. It may contain errors.
See https://goo.gl/tpsmEJ for more information about syzbot.
syzbot engineers can be reached at syzkaller@googlegroups.com.

syzbot will keep track of this bug report. See:
https://goo.gl/tpsmEJ#status for how to communicate with syzbot.
