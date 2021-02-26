Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id BE3C632699A
	for <lists+io-uring@lfdr.de>; Fri, 26 Feb 2021 22:34:19 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230237AbhBZVd5 (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Fri, 26 Feb 2021 16:33:57 -0500
Received: from mail-il1-f198.google.com ([209.85.166.198]:37493 "EHLO
        mail-il1-f198.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230206AbhBZVdz (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Fri, 26 Feb 2021 16:33:55 -0500
Received: by mail-il1-f198.google.com with SMTP id g3so8139441ild.4
        for <io-uring@vger.kernel.org>; Fri, 26 Feb 2021 13:33:39 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:date:in-reply-to:message-id:subject
         :from:to;
        bh=6fQ6n4J8NJ1XjKmbb7t3NP/O3Z5xiFfTRr8rUcTiOHs=;
        b=J4M1b8rzw/dDagM1j1Oa8fUeX5oAbku/ADvR6Og5M+KYfgt47kKKkTAHa5Jpl0+pJA
         njM3VAhnE06/tqozZLk34zHxEgE3SisPzn0pzWNzFOi44Za7jpZzBIHU1aCPxv8VhZ7o
         rnmNUIFPYb+IzVdffpAZWLkB/VSchwMp9zJP0V2sHYlczVe/FBKmb5kzG0JeFkrnrbOd
         qkjU83pEQSTSrZx+E2v7Skj2h3oiemf23mKDlKLcHe4U1Vx2sRrmVKqE7RbfMfxRWrbR
         ER3ZNWf92wBt9wRP6ptR+2vz5xB4QDGgSiJQlooXGRmy5P4IhMolccWSptsNIv/MXBo4
         36/w==
X-Gm-Message-State: AOAM532jn/RMc8SHswNGLEc8ezB+xF0IUDGcjflW21L4P1xpMgp7Y8F3
        GctcprTOMxMnvm9vBQIRDx4EqDNUrsfELTubcTNakWAArD/e
X-Google-Smtp-Source: ABdhPJzzKJGJE+Euo+nbuqcjM2l8P2mU5sqtnMlAOBukgmKVs3SKWY2hSN0R0mMQYZuP4fhBLomPWnbm3iBP3CPOdWvf+wlSEcSG
MIME-Version: 1.0
X-Received: by 2002:a05:6e02:506:: with SMTP id d6mr4157964ils.150.1614375193662;
 Fri, 26 Feb 2021 13:33:13 -0800 (PST)
Date:   Fri, 26 Feb 2021 13:33:13 -0800
In-Reply-To: <0000000000000427db05bc3a2be3@google.com>
X-Google-Appengine-App-Id: s~syzkaller
X-Google-Appengine-App-Id-Alias: syzkaller
Message-ID: <000000000000f3daed05bc440347@google.com>
Subject: Re: KASAN: use-after-free Read in __cpuhp_state_remove_instance
From:   syzbot <syzbot+38769495e847cea2dcca@syzkaller.appspotmail.com>
To:     asml.silence@gmail.com, axboe@kernel.dk, dvyukov@google.com,
        io-uring@vger.kernel.org, linux-kernel@vger.kernel.org,
        mpe@ellerman.id.au, paulmck@kernel.org, peterz@infradead.org,
        qais.yousef@arm.com, syzkaller-bugs@googlegroups.com,
        tglx@linutronix.de
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org

syzbot has found a reproducer for the following issue on:

HEAD commit:    d01f2f7e Add linux-next specific files for 20210226
git tree:       linux-next
console output: https://syzkaller.appspot.com/x/log.txt?x=114fa9ccd00000
kernel config:  https://syzkaller.appspot.com/x/.config?x=a1746d2802a82a05
dashboard link: https://syzkaller.appspot.com/bug?extid=38769495e847cea2dcca
syz repro:      https://syzkaller.appspot.com/x/repro.syz?x=1181e0dad00000

IMPORTANT: if you fix the issue, please add the following tag to the commit:
Reported-by: syzbot+38769495e847cea2dcca@syzkaller.appspotmail.com

==================================================================
BUG: KASAN: use-after-free in __hlist_del include/linux/list.h:835 [inline]
BUG: KASAN: use-after-free in hlist_del include/linux/list.h:852 [inline]
BUG: KASAN: use-after-free in __cpuhp_state_remove_instance+0x58b/0x5b0 kernel/cpu.c:2002
Read of size 8 at addr ffff88803daf3c98 by task syz-executor.2/12922

CPU: 0 PID: 12922 Comm: syz-executor.2 Not tainted 5.11.0-next-20210226-syzkaller #0
Hardware name: Google Google Compute Engine/Google Compute Engine, BIOS Google 01/01/2011
Call Trace:
 __dump_stack lib/dump_stack.c:79 [inline]
 dump_stack+0xfa/0x151 lib/dump_stack.c:120
 print_address_description.constprop.0.cold+0x5b/0x2f8 mm/kasan/report.c:232
 __kasan_report mm/kasan/report.c:399 [inline]
 kasan_report.cold+0x7c/0xd8 mm/kasan/report.c:416
 __hlist_del include/linux/list.h:835 [inline]
 hlist_del include/linux/list.h:852 [inline]
 __cpuhp_state_remove_instance+0x58b/0x5b0 kernel/cpu.c:2002
 cpuhp_state_remove_instance_nocalls include/linux/cpuhotplug.h:407 [inline]
 io_wq_create+0x6ca/0xbf0 fs/io-wq.c:1056
 io_init_wq_offload fs/io_uring.c:7792 [inline]
 io_uring_alloc_task_context+0x1bf/0x6a0 fs/io_uring.c:7811
 io_uring_add_task_file+0x261/0x350 fs/io_uring.c:8773
 io_uring_install_fd fs/io_uring.c:9381 [inline]
 io_uring_create fs/io_uring.c:9532 [inline]
 io_uring_setup+0x14c7/0x2be0 fs/io_uring.c:9571
 do_syscall_64+0x2d/0x70 arch/x86/entry/common.c:46
 entry_SYSCALL_64_after_hwframe+0x44/0xae
RIP: 0033:0x465ef9
Code: ff ff c3 66 2e 0f 1f 84 00 00 00 00 00 0f 1f 40 00 48 89 f8 48 89 f7 48 89 d6 48 89 ca 4d 89 c2 4d 89 c8 4c 8b 4c 24 08 0f 05 <48> 3d 01 f0 ff ff 73 01 c3 48 c7 c1 bc ff ff ff f7 d8 64 89 01 48
RSP: 002b:00007f02a7c99108 EFLAGS: 00000202 ORIG_RAX: 00000000000001a9
RAX: ffffffffffffffda RBX: 000000000056bf60 RCX: 0000000000465ef9
RDX: 0000000020eea000 RSI: 0000000020000180 RDI: 0000000000007761
RBP: 0000000020000180 R08: 0000000000000000 R09: 0000000000000000
R10: 0000000000000000 R11: 0000000000000202 R12: 0000000000000000
R13: 0000000020eea000 R14: 0000000000000000 R15: 0000000020ee8000

Allocated by task 12922:
 kasan_save_stack+0x1b/0x40 mm/kasan/common.c:38
 kasan_set_track mm/kasan/common.c:46 [inline]
 set_alloc_info mm/kasan/common.c:427 [inline]
 ____kasan_kmalloc mm/kasan/common.c:506 [inline]
 ____kasan_kmalloc mm/kasan/common.c:465 [inline]
 __kasan_kmalloc+0x99/0xc0 mm/kasan/common.c:515
 kmalloc include/linux/slab.h:554 [inline]
 kzalloc include/linux/slab.h:684 [inline]
 io_wq_create+0xc0/0xbf0 fs/io-wq.c:1002
 io_init_wq_offload fs/io_uring.c:7792 [inline]
 io_uring_alloc_task_context+0x1bf/0x6a0 fs/io_uring.c:7811
 io_uring_add_task_file+0x261/0x350 fs/io_uring.c:8773
 io_uring_install_fd fs/io_uring.c:9381 [inline]
 io_uring_create fs/io_uring.c:9532 [inline]
 io_uring_setup+0x14c7/0x2be0 fs/io_uring.c:9571
 do_syscall_64+0x2d/0x70 arch/x86/entry/common.c:46
 entry_SYSCALL_64_after_hwframe+0x44/0xae

Freed by task 12922:
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
 io_wq_destroy fs/io-wq.c:1091 [inline]
 io_wq_put+0x4d0/0x6d0 fs/io-wq.c:1098
 io_wq_create+0x92d/0xbf0 fs/io-wq.c:1053
 io_init_wq_offload fs/io_uring.c:7792 [inline]
 io_uring_alloc_task_context+0x1bf/0x6a0 fs/io_uring.c:7811
 io_uring_add_task_file+0x261/0x350 fs/io_uring.c:8773
 io_uring_install_fd fs/io_uring.c:9381 [inline]
 io_uring_create fs/io_uring.c:9532 [inline]
 io_uring_setup+0x14c7/0x2be0 fs/io_uring.c:9571
 do_syscall_64+0x2d/0x70 arch/x86/entry/common.c:46
 entry_SYSCALL_64_after_hwframe+0x44/0xae

Last potentially related work creation:
 kasan_save_stack+0x1b/0x40 mm/kasan/common.c:38
 kasan_record_aux_stack+0xe5/0x110 mm/kasan/generic.c:345
 insert_work+0x48/0x370 kernel/workqueue.c:1331
 __queue_work+0x5c1/0xf00 kernel/workqueue.c:1497
 queue_work_on+0xae/0xc0 kernel/workqueue.c:1524
 queue_work include/linux/workqueue.h:507 [inline]
 addr_event.part.0+0x2e1/0x470 drivers/infiniband/core/roce_gid_mgmt.c:852
 addr_event drivers/infiniband/core/roce_gid_mgmt.c:823 [inline]
 inet6addr_event+0x13e/0x1b0 drivers/infiniband/core/roce_gid_mgmt.c:882
 notifier_call_chain+0xb5/0x200 kernel/notifier.c:83
 atomic_notifier_call_chain+0x8d/0x170 kernel/notifier.c:217
 ipv6_add_addr+0x1750/0x1ef0 net/ipv6/addrconf.c:1152
 addrconf_add_linklocal+0x1ca/0x590 net/ipv6/addrconf.c:3182
 addrconf_addr_gen+0x3a4/0x3e0 net/ipv6/addrconf.c:3313
 addrconf_dev_config+0x26c/0x410 net/ipv6/addrconf.c:3360
 addrconf_notify+0x362/0x23e0 net/ipv6/addrconf.c:3593
 notifier_call_chain+0xb5/0x200 kernel/notifier.c:83
 call_netdevice_notifiers_info+0xb5/0x130 net/core/dev.c:2063
 netdev_state_change net/core/dev.c:1454 [inline]
 netdev_state_change+0x100/0x130 net/core/dev.c:1447
 linkwatch_do_dev+0x13f/0x180 net/core/link_watch.c:167
 __linkwatch_run_queue+0x1ea/0x630 net/core/link_watch.c:212
 linkwatch_event+0x4a/0x60 net/core/link_watch.c:251
 process_one_work+0x98d/0x1600 kernel/workqueue.c:2275
 worker_thread+0x64c/0x1120 kernel/workqueue.c:2421
 kthread+0x3b1/0x4a0 kernel/kthread.c:292
 ret_from_fork+0x1f/0x30 arch/x86/entry/entry_64.S:294

The buggy address belongs to the object at ffff88803daf3c00
 which belongs to the cache kmalloc-192 of size 192
The buggy address is located 152 bytes inside of
 192-byte region [ffff88803daf3c00, ffff88803daf3cc0)
The buggy address belongs to the page:
page:000000003078ed2f refcount:1 mapcount:0 mapping:0000000000000000 index:0xffff88803daf3200 pfn:0x3daf3
flags: 0xfff00000000200(slab)
raw: 00fff00000000200 ffffea0000462ec0 0000000500000005 ffff888010841a00
raw: ffff88803daf3200 0000000080100009 00000001ffffffff 0000000000000000
page dumped because: kasan: bad access detected

Memory state around the buggy address:
 ffff88803daf3b80: fb fb fb fb fb fb fb fb fc fc fc fc fc fc fc fc
 ffff88803daf3c00: fa fb fb fb fb fb fb fb fb fb fb fb fb fb fb fb
>ffff88803daf3c80: fb fb fb fb fb fb fb fb fc fc fc fc fc fc fc fc
                            ^
 ffff88803daf3d00: fb fb fb fb fb fb fb fb fb fb fb fb fb fb fb fb
 ffff88803daf3d80: fb fb fb fb fb fb fb fb fc fc fc fc fc fc fc fc
==================================================================

