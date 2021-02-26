Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id B4ADC326A39
	for <lists+io-uring@lfdr.de>; Fri, 26 Feb 2021 23:51:10 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230128AbhBZWu5 (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Fri, 26 Feb 2021 17:50:57 -0500
Received: from mail-il1-f198.google.com ([209.85.166.198]:39887 "EHLO
        mail-il1-f198.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230063AbhBZWuz (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Fri, 26 Feb 2021 17:50:55 -0500
Received: by mail-il1-f198.google.com with SMTP id g14so8235780ilb.6
        for <io-uring@vger.kernel.org>; Fri, 26 Feb 2021 14:50:39 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:date:in-reply-to:message-id:subject
         :from:to;
        bh=8aJELXYkV+FyPmc9WSyhbrXTfHAKXmtu49aRjAVzZC4=;
        b=i0f/qDgOgW1Nw011K0AVRrx34Cwsu2ZGBfN1QtrOadLktYFjHWXaKbGpRkMMz/fAjF
         m9mnKcMqeCOupCle1ldsKR60C9j7c7ivbqlBpS3BBLbkmtWPik6YH/F7qM0BnrDnXKED
         MsfOFjt83WW6hw0A9S+yN4DkWlhGMu+ZaEJ8SwgPnBnfy/HbnC9rItP39tonIiQdA41U
         KnO1RAMY0fqKA2iFm0B3rPAPp/Fpbs1s3rsbZNyu4NQh/2XIpSNlcVEQ7ZAkQsEX7o+p
         Bv2r3tgccS+CRVlm6VT++uV0PvcFrvPWpunRmDtIuB9v1viNOlSeNV7dMTSKn7AWrqCq
         9RZw==
X-Gm-Message-State: AOAM533k4i0Rl4fQNcoToy3OATiaMxrSoxkJVEdT/WKzHclHCCOKeA35
        XYkim9F6UO4fq76DzNCpF7y8dzCQSKy0RoCz3vqZVTaqLWCI
X-Google-Smtp-Source: ABdhPJxk97KwYnJUc58c+aGvWU2H9uj2B2L8mXiYGkD4b9MmiRZOENr8Rtv85d87YOmE5T0Cx6knp04QceOyPfi7UWZlrNACznKk
MIME-Version: 1.0
X-Received: by 2002:a92:4151:: with SMTP id o78mr4397656ila.117.1614379814224;
 Fri, 26 Feb 2021 14:50:14 -0800 (PST)
Date:   Fri, 26 Feb 2021 14:50:14 -0800
In-Reply-To: <0000000000000427db05bc3a2be3@google.com>
X-Google-Appengine-App-Id: s~syzkaller
X-Google-Appengine-App-Id-Alias: syzkaller
Message-ID: <0000000000005c0ac105bc4517f5@google.com>
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
console output: https://syzkaller.appspot.com/x/log.txt?x=17208f22d00000
kernel config:  https://syzkaller.appspot.com/x/.config?x=a1746d2802a82a05
dashboard link: https://syzkaller.appspot.com/bug?extid=38769495e847cea2dcca
syz repro:      https://syzkaller.appspot.com/x/repro.syz?x=1087f2bcd00000
C reproducer:   https://syzkaller.appspot.com/x/repro.c?x=14b83722d00000

IMPORTANT: if you fix the issue, please add the following tag to the commit:
Reported-by: syzbot+38769495e847cea2dcca@syzkaller.appspotmail.com

==================================================================
BUG: KASAN: use-after-free in __hlist_del include/linux/list.h:835 [inline]
BUG: KASAN: use-after-free in hlist_del include/linux/list.h:852 [inline]
BUG: KASAN: use-after-free in __cpuhp_state_remove_instance+0x58b/0x5b0 kernel/cpu.c:2002
Read of size 8 at addr ffff888013928898 by task syz-executor929/8420

CPU: 1 PID: 8420 Comm: syz-executor929 Not tainted 5.11.0-next-20210226-syzkaller #0
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
RIP: 0033:0x43eec9
Code: 28 c3 e8 2a 14 00 00 66 2e 0f 1f 84 00 00 00 00 00 48 89 f8 48 89 f7 48 89 d6 48 89 ca 4d 89 c2 4d 89 c8 4c 8b 4c 24 08 0f 05 <48> 3d 01 f0 ff ff 73 01 c3 48 c7 c1 c0 ff ff ff f7 d8 64 89 01 48
RSP: 002b:00007fff25216ba8 EFLAGS: 00000246 ORIG_RAX: 00000000000001a9
RAX: ffffffffffffffda RBX: 0000000000400488 RCX: 000000000043eec9
RDX: 000000000043eec9 RSI: 0000000020000040 RDI: 00000000000074c1
RBP: 0000000000402eb0 R08: 0000000000000000 R09: 0000000000000000
R10: 0000000000000000 R11: 0000000000000246 R12: 0000000000402f40
R13: 0000000000000000 R14: 00000000004ac018 R15: 0000000000400488

Allocated by task 8420:
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

Freed by task 8420:
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
 call_usermodehelper_exec+0x1f0/0x4c0 kernel/umh.c:433
 kobject_uevent_env+0xf9f/0x1680 lib/kobject_uevent.c:617
 kobject_synth_uevent+0x701/0x850 lib/kobject_uevent.c:208
 uevent_store+0x42/0x90 drivers/base/bus.c:585
 drv_attr_store+0x6d/0xa0 drivers/base/bus.c:77
 sysfs_kf_write+0x110/0x160 fs/sysfs/file.c:139
 kernfs_fop_write_iter+0x342/0x500 fs/kernfs/file.c:296
 call_write_iter include/linux/fs.h:1977 [inline]
 new_sync_write+0x426/0x650 fs/read_write.c:519
 vfs_write+0x796/0xa30 fs/read_write.c:606
 ksys_write+0x12d/0x250 fs/read_write.c:659
 do_syscall_64+0x2d/0x70 arch/x86/entry/common.c:46
 entry_SYSCALL_64_after_hwframe+0x44/0xae

Second to last potentially related work creation:
 kasan_save_stack+0x1b/0x40 mm/kasan/common.c:38
 kasan_record_aux_stack+0xe5/0x110 mm/kasan/generic.c:345
 insert_work+0x48/0x370 kernel/workqueue.c:1331
 __queue_work+0x5c1/0xf00 kernel/workqueue.c:1497
 queue_work_on+0xae/0xc0 kernel/workqueue.c:1524
 queue_work include/linux/workqueue.h:507 [inline]
 call_usermodehelper_exec+0x1f0/0x4c0 kernel/umh.c:433
 kobject_uevent_env+0xf9f/0x1680 lib/kobject_uevent.c:617
 kernel_add_sysfs_param kernel/params.c:798 [inline]
 param_sysfs_builtin kernel/params.c:833 [inline]
 param_sysfs_init+0x3bf/0x498 kernel/params.c:952
 do_one_initcall+0x103/0x650 init/main.c:1226
 do_initcall_level init/main.c:1299 [inline]
 do_initcalls init/main.c:1315 [inline]
 do_basic_setup init/main.c:1335 [inline]
 kernel_init_freeable+0x5ff/0x683 init/main.c:1536
 kernel_init+0xd/0x1b8 init/main.c:1424
 ret_from_fork+0x1f/0x30 arch/x86/entry/entry_64.S:294

The buggy address belongs to the object at ffff888013928800
 which belongs to the cache kmalloc-192 of size 192
The buggy address is located 152 bytes inside of
 192-byte region [ffff888013928800, ffff8880139288c0)
The buggy address belongs to the page:
page:00000000bd6bb1df refcount:1 mapcount:0 mapping:0000000000000000 index:0x0 pfn:0x13928
flags: 0xfff00000000200(slab)
raw: 00fff00000000200 0000000000000000 0000000c00000001 ffff888010841a00
raw: 0000000000000000 0000000080100010 00000001ffffffff 0000000000000000
page dumped because: kasan: bad access detected

Memory state around the buggy address:
 ffff888013928780: fb fb fb fb fb fb fb fb fc fc fc fc fc fc fc fc
 ffff888013928800: fa fb fb fb fb fb fb fb fb fb fb fb fb fb fb fb
>ffff888013928880: fb fb fb fb fb fb fb fb fc fc fc fc fc fc fc fc
                            ^
 ffff888013928900: 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00
 ffff888013928980: 04 fc fc fc fc fc fc fc fc fc fc fc fc fc fc fc
==================================================================

