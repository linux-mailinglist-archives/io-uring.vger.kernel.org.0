Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 05C6B2338E4
	for <lists+io-uring@lfdr.de>; Thu, 30 Jul 2020 21:21:30 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730433AbgG3TVV (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Thu, 30 Jul 2020 15:21:21 -0400
Received: from mail-io1-f71.google.com ([209.85.166.71]:56911 "EHLO
        mail-io1-f71.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1730412AbgG3TVT (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Thu, 30 Jul 2020 15:21:19 -0400
Received: by mail-io1-f71.google.com with SMTP id f21so19130461ioo.23
        for <io-uring@vger.kernel.org>; Thu, 30 Jul 2020 12:21:18 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:date:message-id:subject:from:to;
        bh=zcGvcLBkmLVIiitWjC0dTjPKNOWpI78/MjOsV9KI+nI=;
        b=gqcCiKbbJt87my9bWNEROSN0YbZHJYI/R9ZjRiXelBaC4Qs6GyVMAEhNxSzc6s+dhp
         wiX+eRuWk8fM2Hqv+lc8l3ID0pYT5kInR5DCno81V6ILS5JNazwhZ8ZIsOyjwp/xlSl/
         +Vf9dJNYiqXbR4XgRg2Nq82pHlboIg96qBhFPd+wHzJ2S6xGzWaRuzfDNudApDvvsFNe
         6eHkJuKF5x0Tuu/A6f+2l9041lwUI4ipSKfv+YSCjFJqHw6hnRQTPIDz6l7PK2NDl8zR
         WwJtXmhOyy5Gq2aMufJjjV+6SAFmSS4IDGRffSobmUWwnXYx9L4EFSwg6EgDcIHfCf9c
         U+Bg==
X-Gm-Message-State: AOAM533MHeVsmL+s5Vn13hhT8eUhbGtRU4C0MasijoyMiDXy555ZoGfC
        i9eF7AZR+Muc75XwcWaVvSh0uJZmVhzzd6WE/qwfKSs7VS6x
X-Google-Smtp-Source: ABdhPJxA1XVBHHgevcFGRcm19/FogHJVO/W/fLEMw40v6yi3auJFWHjZ0mPyzWWj13H7vbhXlSAjTVVJacoHQ30dUKZz5gJjN5gF
MIME-Version: 1.0
X-Received: by 2002:a05:6e02:c1:: with SMTP id r1mr119662ilq.34.1596136878205;
 Thu, 30 Jul 2020 12:21:18 -0700 (PDT)
Date:   Thu, 30 Jul 2020 12:21:18 -0700
X-Google-Appengine-App-Id: s~syzkaller
X-Google-Appengine-App-Id-Alias: syzkaller
Message-ID: <000000000000a3709905abad9335@google.com>
Subject: KASAN: use-after-free Read in io_uring_setup (2)
From:   syzbot <syzbot+9d46305e76057f30c74e@syzkaller.appspotmail.com>
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

HEAD commit:    04b45717 Add linux-next specific files for 20200729
git tree:       linux-next
console output: https://syzkaller.appspot.com/x/log.txt?x=173774b8900000
kernel config:  https://syzkaller.appspot.com/x/.config?x=ec68f65b459f1ed
dashboard link: https://syzkaller.appspot.com/bug?extid=9d46305e76057f30c74e
compiler:       gcc (GCC) 10.1.0-syz 20200507

Unfortunately, I don't have any reproducer for this issue yet.

IMPORTANT: if you fix the issue, please add the following tag to the commit:
Reported-by: syzbot+9d46305e76057f30c74e@syzkaller.appspotmail.com

==================================================================
BUG: KASAN: use-after-free in io_account_mem fs/io_uring.c:7397 [inline]
BUG: KASAN: use-after-free in io_uring_create fs/io_uring.c:8369 [inline]
BUG: KASAN: use-after-free in io_uring_setup+0x2797/0x2910 fs/io_uring.c:8400
Read of size 1 at addr ffff888087a41044 by task syz-executor.5/18145

CPU: 0 PID: 18145 Comm: syz-executor.5 Not tainted 5.8.0-rc7-next-20200729-syzkaller #0
Hardware name: Google Google Compute Engine/Google Compute Engine, BIOS Google 01/01/2011
Call Trace:
 __dump_stack lib/dump_stack.c:77 [inline]
 dump_stack+0x18f/0x20d lib/dump_stack.c:118
 print_address_description.constprop.0.cold+0xae/0x497 mm/kasan/report.c:383
 __kasan_report mm/kasan/report.c:513 [inline]
 kasan_report.cold+0x1f/0x37 mm/kasan/report.c:530
 io_account_mem fs/io_uring.c:7397 [inline]
 io_uring_create fs/io_uring.c:8369 [inline]
 io_uring_setup+0x2797/0x2910 fs/io_uring.c:8400
 do_syscall_64+0x2d/0x70 arch/x86/entry/common.c:46
 entry_SYSCALL_64_after_hwframe+0x44/0xa9
RIP: 0033:0x45c429
Code: 8d b6 fb ff c3 66 2e 0f 1f 84 00 00 00 00 00 66 90 48 89 f8 48 89 f7 48 89 d6 48 89 ca 4d 89 c2 4d 89 c8 4c 8b 4c 24 08 0f 05 <48> 3d 01 f0 ff ff 0f 83 5b b6 fb ff c3 66 2e 0f 1f 84 00 00 00 00
RSP: 002b:00007f8f121d0c78 EFLAGS: 00000246 ORIG_RAX: 00000000000001a9
RAX: ffffffffffffffda RBX: 0000000000008540 RCX: 000000000045c429
RDX: 0000000000000000 RSI: 0000000020000040 RDI: 0000000000000196
RBP: 000000000078bf38 R08: 0000000000000000 R09: 0000000000000000
R10: 0000000000000000 R11: 0000000000000246 R12: 000000000078bf0c
R13: 00007fff86698cff R14: 00007f8f121d19c0 R15: 000000000078bf0c

Allocated by task 18145:
 kasan_save_stack+0x1b/0x40 mm/kasan/common.c:48
 kasan_set_track mm/kasan/common.c:56 [inline]
 __kasan_kmalloc.constprop.0+0xbf/0xd0 mm/kasan/common.c:461
 kmem_cache_alloc_trace+0x16e/0x2c0 mm/slab.c:3550
 kmalloc include/linux/slab.h:554 [inline]
 kzalloc include/linux/slab.h:666 [inline]
 io_ring_ctx_alloc fs/io_uring.c:1042 [inline]
 io_uring_create fs/io_uring.c:8313 [inline]
 io_uring_setup+0x4df/0x2910 fs/io_uring.c:8400
 do_syscall_64+0x2d/0x70 arch/x86/entry/common.c:46
 entry_SYSCALL_64_after_hwframe+0x44/0xa9

Freed by task 15583:
 kasan_save_stack+0x1b/0x40 mm/kasan/common.c:48
 kasan_set_track+0x1c/0x30 mm/kasan/common.c:56
 kasan_set_free_info+0x1b/0x30 mm/kasan/generic.c:355
 __kasan_slab_free+0xd8/0x120 mm/kasan/common.c:422
 __cache_free mm/slab.c:3418 [inline]
 kfree+0x103/0x2c0 mm/slab.c:3756
 process_one_work+0x94c/0x1670 kernel/workqueue.c:2269
 worker_thread+0x64c/0x1120 kernel/workqueue.c:2415
 kthread+0x3b5/0x4a0 kernel/kthread.c:292
 ret_from_fork+0x1f/0x30 arch/x86/entry/entry_64.S:294

Last call_rcu():
 kasan_save_stack+0x1b/0x40 mm/kasan/common.c:48
 kasan_record_aux_stack+0x82/0xb0 mm/kasan/generic.c:346
 __call_rcu kernel/rcu/tree.c:2883 [inline]
 call_rcu+0x14f/0x7e0 kernel/rcu/tree.c:2957
 __percpu_ref_switch_to_atomic lib/percpu-refcount.c:192 [inline]
 __percpu_ref_switch_mode+0x365/0x700 lib/percpu-refcount.c:237
 percpu_ref_kill_and_confirm+0x94/0x350 lib/percpu-refcount.c:350
 percpu_ref_kill include/linux/percpu-refcount.h:136 [inline]
 io_ring_ctx_wait_and_kill+0x38/0x600 fs/io_uring.c:7799
 io_uring_release+0x3e/0x50 fs/io_uring.c:7831
 __fput+0x285/0x920 fs/file_table.c:281
 task_work_run+0xdd/0x190 kernel/task_work.c:135
 tracehook_notify_resume include/linux/tracehook.h:188 [inline]
 exit_to_user_mode_loop kernel/entry/common.c:139 [inline]
 exit_to_user_mode_prepare+0x195/0x1c0 kernel/entry/common.c:166
 syscall_exit_to_user_mode+0x59/0x2b0 kernel/entry/common.c:241
 entry_SYSCALL_64_after_hwframe+0x44/0xa9

The buggy address belongs to the object at ffff888087a41000
 which belongs to the cache kmalloc-2k of size 2048
The buggy address is located 68 bytes inside of
 2048-byte region [ffff888087a41000, ffff888087a41800)
The buggy address belongs to the page:
page:000000007a29a6b9 refcount:1 mapcount:0 mapping:0000000000000000 index:0x0 pfn:0x87a41
flags: 0xfffe0000000200(slab)
raw: 00fffe0000000200 ffffea0002386288 ffffea000253c0c8 ffff8880aa000800
raw: 0000000000000000 ffff888087a41000 0000000100000001 0000000000000000
page dumped because: kasan: bad access detected

Memory state around the buggy address:
 ffff888087a40f00: fc fc fc fc fc fc fc fc fc fc fc fc fc fc fc fc
 ffff888087a40f80: fc fc fc fc fc fc fc fc fc fc fc fc fc fc fc fc
>ffff888087a41000: fa fb fb fb fb fb fb fb fb fb fb fb fb fb fb fb
                                           ^
 ffff888087a41080: fb fb fb fb fb fb fb fb fb fb fb fb fb fb fb fb
 ffff888087a41100: fb fb fb fb fb fb fb fb fb fb fb fb fb fb fb fb
==================================================================


---
This report is generated by a bot. It may contain errors.
See https://goo.gl/tpsmEJ for more information about syzbot.
syzbot engineers can be reached at syzkaller@googlegroups.com.

syzbot will keep track of this issue. See:
https://goo.gl/tpsmEJ#status for how to communicate with syzbot.
