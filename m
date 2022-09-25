Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 7F4A75E955C
	for <lists+io-uring@lfdr.de>; Sun, 25 Sep 2022 20:15:28 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232817AbiIYSP0 (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Sun, 25 Sep 2022 14:15:26 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:45524 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232716AbiIYSP0 (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Sun, 25 Sep 2022 14:15:26 -0400
Received: from mail-io1-f72.google.com (mail-io1-f72.google.com [209.85.166.72])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 2772B18B36
        for <io-uring@vger.kernel.org>; Sun, 25 Sep 2022 11:15:24 -0700 (PDT)
Received: by mail-io1-f72.google.com with SMTP id u23-20020a6be917000000b0069f4854e11eso2627891iof.2
        for <io-uring@vger.kernel.org>; Sun, 25 Sep 2022 11:15:24 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=to:from:subject:message-id:in-reply-to:date:mime-version
         :x-gm-message-state:from:to:cc:subject:date;
        bh=X8z6lrV3etko+qX0fuaP3o2XZ16yi036Eqgp9liBS7A=;
        b=eZlxRlhkaLIZ4AqDMfbeDd4YFg8f3Qrj1KesCwl0V3lHGD2jZQ5bmshYoem/JwN7QE
         wMgbh25bRt4AT1ZvWY3lpO3R5Z44eYuNq+njzr6oxToX2nqL3m0ksutvTmQmvncf/HF8
         UhcK73M/BVDGjL0sSS+g74w73IqAUWPAzgmcl1n3TJO5q5En7m4VRxa50PvMtPnj0MYp
         S3Ph6O76p955dBXHn8QBtj9/zBK68ChrihU0/LAvIDah3xodzqa+cokETnu03K3BfrQw
         rTHGbCZPCnjscCcsrDufWEFPBGi+SIfSNDu2Ide5kHSzDV0UGN/Axhmwa6ZgME8EmvhI
         ZHBw==
X-Gm-Message-State: ACrzQf0LgSll1A3un+ox33+lasMf5rLpJJ5EwvOBd/1hwEh/gSSTvY5R
        2kuFSEsnknxCYaI3lQ283WIkhhVRFWYu8mA681jrzBgxlsay
X-Google-Smtp-Source: AMsMyM5ESmUfheXRXJy3HSicvczC74b7vkw4ULMO118BvRYFv1beabKrq9F51IyFOM/EphBRYtDm/N+ZrM3P62SCT4SPROQMLBt5
MIME-Version: 1.0
X-Received: by 2002:a05:6e02:1a6b:b0:2f1:a7c9:ea2e with SMTP id
 w11-20020a056e021a6b00b002f1a7c9ea2emr8324491ilv.176.1664129723540; Sun, 25
 Sep 2022 11:15:23 -0700 (PDT)
Date:   Sun, 25 Sep 2022 11:15:23 -0700
In-Reply-To: <8c9845cf-a5fe-21c0-10a5-2369758dd23c@gmail.com>
X-Google-Appengine-App-Id: s~syzkaller
X-Google-Appengine-App-Id-Alias: syzkaller
Message-ID: <000000000000082de205e98465e4@google.com>
Subject: Re: [syzbot] KASAN: invalid-free in io_clean_op
From:   syzbot <syzbot+edfd15cd4246a3fc615a@syzkaller.appspotmail.com>
To:     asml.silence@gmail.com, axboe@kernel.dk, io-uring@vger.kernel.org,
        linux-kernel@vger.kernel.org, syzkaller-bugs@googlegroups.com
Content-Type: text/plain; charset="UTF-8"
X-Spam-Status: No, score=-1.6 required=5.0 tests=BAYES_00,FROM_LOCAL_HEX,
        HEADER_FROM_DIFFERENT_DOMAINS,RCVD_IN_DNSWL_NONE,RCVD_IN_MSPIKE_H2,
        SPF_HELO_NONE,SPF_PASS autolearn=no autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org

Hello,

syzbot has tested the proposed patch but the reproducer is still triggering an issue:
KASAN: invalid-free in io_clean_op

==================================================================
BUG: KASAN: double-free in slab_free mm/slub.c:3534 [inline]
BUG: KASAN: double-free in kfree+0xe2/0x580 mm/slub.c:4562

CPU: 0 PID: 4143 Comm: syz-executor.0 Not tainted 6.0.0-rc6-syzkaller-00046-gaa1df3a360a0 #0
Hardware name: Google Google Compute Engine/Google Compute Engine, BIOS Google 08/26/2022
Call Trace:
 <TASK>
 __dump_stack lib/dump_stack.c:88 [inline]
 dump_stack_lvl+0xcd/0x134 lib/dump_stack.c:106
 print_address_description mm/kasan/report.c:317 [inline]
 print_report.cold+0x2ba/0x719 mm/kasan/report.c:433
 kasan_report_invalid_free+0x81/0x190 mm/kasan/report.c:462
 ____kasan_slab_free+0x18b/0x1c0 mm/kasan/common.c:356
 kasan_slab_free include/linux/kasan.h:200 [inline]
 slab_free_hook mm/slub.c:1754 [inline]
 slab_free_freelist_hook+0x8b/0x1c0 mm/slub.c:1780
 slab_free mm/slub.c:3534 [inline]
 kfree+0xe2/0x580 mm/slub.c:4562
 io_clean_op+0x581/0xb10 io_uring/io_uring.c:1706
 io_free_batch_list+0x46f/0x7e0 io_uring/io_uring.c:1312
 __io_submit_flush_completions+0x22b/0x2e0 io_uring/io_uring.c:1350
 io_submit_flush_completions io_uring/io_uring.c:171 [inline]
 ctx_flush_and_put+0xdf/0x1b0 io_uring/io_uring.c:1010
 tctx_task_work+0x153/0x420 io_uring/io_uring.c:1094
 task_work_run+0xdd/0x1a0 kernel/task_work.c:177
 get_signal+0x1c3/0x2610 kernel/signal.c:2634
 arch_do_signal_or_restart+0x82/0x2300 arch/x86/kernel/signal.c:869
 exit_to_user_mode_loop kernel/entry/common.c:166 [inline]
 exit_to_user_mode_prepare+0x15f/0x250 kernel/entry/common.c:201
 __syscall_exit_to_user_mode_work kernel/entry/common.c:283 [inline]
 syscall_exit_to_user_mode+0x19/0x50 kernel/entry/common.c:294
 do_syscall_64+0x42/0xb0 arch/x86/entry/common.c:86
 entry_SYSCALL_64_after_hwframe+0x63/0xcd
RIP: 0033:0x7f25f668a669
Code: ff ff c3 66 2e 0f 1f 84 00 00 00 00 00 0f 1f 40 00 48 89 f8 48 89 f7 48 89 d6 48 89 ca 4d 89 c2 4d 89 c8 4c 8b 4c 24 08 0f 05 <48> 3d 01 f0 ff ff 73 01 c3 48 c7 c1 b8 ff ff ff f7 d8 64 89 01 48
RSP: 002b:00007f25f7743168 EFLAGS: 00000246 ORIG_RAX: 00000000000001aa
RAX: 00000000000040b2 RBX: 00007f25f67abf80 RCX: 00007f25f668a669
RDX: 0000000000000000 RSI: 00000000000040b2 RDI: 0000000000000003
RBP: 00007f25f66e5560 R08: 0000000020000000 R09: 0000000000000008
R10: 0000000000000000 R11: 0000000000000246 R12: 0000000000000000
R13: 00007ffca833dfcf R14: 00007f25f7743300 R15: 0000000000022000
 </TASK>

Allocated by task 4143:
 kasan_save_stack+0x1e/0x40 mm/kasan/common.c:38
 kasan_set_track mm/kasan/common.c:45 [inline]
 set_alloc_info mm/kasan/common.c:437 [inline]
 ____kasan_kmalloc mm/kasan/common.c:516 [inline]
 ____kasan_kmalloc mm/kasan/common.c:475 [inline]
 __kasan_kmalloc+0xa9/0xd0 mm/kasan/common.c:525
 kmalloc include/linux/slab.h:605 [inline]
 io_alloc_async_data+0x9b/0x160 io_uring/io_uring.c:1597
 io_msg_alloc_async io_uring/net.c:138 [inline]
 io_msg_alloc_async_prep io_uring/net.c:147 [inline]
 io_sendmsg_prep_async+0x19b/0x3c0 io_uring/net.c:221
 io_req_prep_async+0x1d9/0x300 io_uring/io_uring.c:1620
 io_submit_sqe io_uring/io_uring.c:2144 [inline]
 io_submit_sqes+0xf69/0x1d10 io_uring/io_uring.c:2283
 __do_sys_io_uring_enter+0xac6/0x2380 io_uring/io_uring.c:3224
 do_syscall_x64 arch/x86/entry/common.c:50 [inline]
 do_syscall_64+0x35/0xb0 arch/x86/entry/common.c:80
 entry_SYSCALL_64_after_hwframe+0x63/0xcd

Freed by task 4143:
 kasan_save_stack+0x1e/0x40 mm/kasan/common.c:38
 kasan_set_track+0x21/0x30 mm/kasan/common.c:45
 kasan_set_free_info+0x20/0x30 mm/kasan/generic.c:370
 ____kasan_slab_free mm/kasan/common.c:367 [inline]
 ____kasan_slab_free+0x166/0x1c0 mm/kasan/common.c:329
 kasan_slab_free include/linux/kasan.h:200 [inline]
 slab_free_hook mm/slub.c:1754 [inline]
 slab_free_freelist_hook+0x8b/0x1c0 mm/slub.c:1780
 slab_free mm/slub.c:3534 [inline]
 kfree+0xe2/0x580 mm/slub.c:4562
 io_send_zc_cleanup+0x141/0x190 io_uring/net.c:916
 io_clean_op+0xf4/0xb10 io_uring/io_uring.c:1691
 io_free_batch_list+0x46f/0x7e0 io_uring/io_uring.c:1312
 __io_submit_flush_completions+0x22b/0x2e0 io_uring/io_uring.c:1350
 io_submit_flush_completions io_uring/io_uring.c:171 [inline]
 ctx_flush_and_put+0xdf/0x1b0 io_uring/io_uring.c:1010
 tctx_task_work+0x153/0x420 io_uring/io_uring.c:1094
 task_work_run+0xdd/0x1a0 kernel/task_work.c:177
 get_signal+0x1c3/0x2610 kernel/signal.c:2634
 arch_do_signal_or_restart+0x82/0x2300 arch/x86/kernel/signal.c:869
 exit_to_user_mode_loop kernel/entry/common.c:166 [inline]
 exit_to_user_mode_prepare+0x15f/0x250 kernel/entry/common.c:201
 __syscall_exit_to_user_mode_work kernel/entry/common.c:283 [inline]
 syscall_exit_to_user_mode+0x19/0x50 kernel/entry/common.c:294
 do_syscall_64+0x42/0xb0 arch/x86/entry/common.c:86
 entry_SYSCALL_64_after_hwframe+0x63/0xcd

The buggy address belongs to the object at ffff888016865800
 which belongs to the cache kmalloc-512 of size 512
The buggy address is located 0 bytes inside of
 512-byte region [ffff888016865800, ffff888016865a00)

The buggy address belongs to the physical page:
page:ffffea00005a1900 refcount:1 mapcount:0 mapping:0000000000000000 index:0x0 pfn:0x16864
head:ffffea00005a1900 order:2 compound_mapcount:0 compound_pincount:0
flags: 0xfff00000010200(slab|head|node=0|zone=1|lastcpupid=0x7ff)
raw: 00fff00000010200 0000000000000000 dead000000000122 ffff888011841c80
raw: 0000000000000000 0000000000100010 00000001ffffffff 0000000000000000
page dumped because: kasan: bad access detected
page_owner tracks the page as allocated
page last allocated via order 2, migratetype Unmovable, gfp_mask 0x1d20c0(__GFP_IO|__GFP_FS|__GFP_NOWARN|__GFP_NORETRY|__GFP_COMP|__GFP_NOMEMALLOC|__GFP_HARDWALL), pid 2968, tgid 2968 (udevd), ts 80588086489, free_ts 78568556659
 prep_new_page mm/page_alloc.c:2532 [inline]
 get_page_from_freelist+0x109b/0x2ce0 mm/page_alloc.c:4283
 __alloc_pages+0x1c7/0x510 mm/page_alloc.c:5515
 alloc_pages+0x1a6/0x270 mm/mempolicy.c:2270
 alloc_slab_page mm/slub.c:1824 [inline]
 allocate_slab+0x27e/0x3d0 mm/slub.c:1969
 new_slab mm/slub.c:2029 [inline]
 ___slab_alloc+0x7f1/0xe10 mm/slub.c:3031
 __slab_alloc.constprop.0+0x4d/0xa0 mm/slub.c:3118
 slab_alloc_node mm/slub.c:3209 [inline]
 __kmalloc_node_track_caller+0x2f2/0x380 mm/slub.c:4955
 kmalloc_reserve net/core/skbuff.c:362 [inline]
 __alloc_skb+0xd9/0x2f0 net/core/skbuff.c:434
 alloc_skb include/linux/skbuff.h:1257 [inline]
 alloc_uevent_skb+0x7b/0x210 lib/kobject_uevent.c:290
 uevent_net_broadcast_untagged lib/kobject_uevent.c:326 [inline]
 kobject_uevent_net_broadcast lib/kobject_uevent.c:409 [inline]
 kobject_uevent_env+0xc2e/0x1640 lib/kobject_uevent.c:593
 kobject_synth_uevent+0x701/0x850 lib/kobject_uevent.c:208
 uevent_store+0x20/0x50 drivers/base/core.c:2509
 dev_attr_store+0x50/0x80 drivers/base/core.c:2211
 sysfs_kf_write+0x110/0x160 fs/sysfs/file.c:136
 kernfs_fop_write_iter+0x3f8/0x610 fs/kernfs/file.c:354
 call_write_iter include/linux/fs.h:2189 [inline]
 new_sync_write fs/read_write.c:491 [inline]
 vfs_write+0x9e9/0xdd0 fs/read_write.c:578
page last free stack trace:
 reset_page_owner include/linux/page_owner.h:24 [inline]
 free_pages_prepare mm/page_alloc.c:1449 [inline]
 free_pcp_prepare+0x5e4/0xd20 mm/page_alloc.c:1499
 free_unref_page_prepare mm/page_alloc.c:3380 [inline]
 free_unref_page+0x19/0x4d0 mm/page_alloc.c:3476
 qlink_free mm/kasan/quarantine.c:168 [inline]
 qlist_free_all+0x6a/0x170 mm/kasan/quarantine.c:187
 kasan_quarantine_reduce+0x180/0x200 mm/kasan/quarantine.c:294
 __kasan_slab_alloc+0xa2/0xc0 mm/kasan/common.c:447
 kasan_slab_alloc include/linux/kasan.h:224 [inline]
 slab_post_alloc_hook mm/slab.h:727 [inline]
 slab_alloc_node mm/slub.c:3243 [inline]
 kmem_cache_alloc_node+0x2b1/0x3f0 mm/slub.c:3293
 __alloc_skb+0x210/0x2f0 net/core/skbuff.c:422
 alloc_skb include/linux/skbuff.h:1257 [inline]
 bt_skb_alloc include/net/bluetooth/bluetooth.h:469 [inline]
 __vhci_create_device+0x83/0x7d0 drivers/bluetooth/hci_vhci.c:300
 vhci_create_device drivers/bluetooth/hci_vhci.c:374 [inline]
 vhci_open_timeout+0x38/0x50 drivers/bluetooth/hci_vhci.c:531
 process_one_work+0x991/0x1610 kernel/workqueue.c:2289
 worker_thread+0x665/0x1080 kernel/workqueue.c:2436
 kthread+0x2e4/0x3a0 kernel/kthread.c:376
 ret_from_fork+0x1f/0x30 arch/x86/entry/entry_64.S:306

Memory state around the buggy address:
 ffff888016865700: fc fc fc fc fc fc fc fc fc fc fc fc fc fc fc fc
 ffff888016865780: fc fc fc fc fc fc fc fc fc fc fc fc fc fc fc fc
>ffff888016865800: fa fb fb fb fb fb fb fb fb fb fb fb fb fb fb fb
                   ^
 ffff888016865880: fb fb fb fb fb fb fb fb fb fb fb fb fb fb fb fb
 ffff888016865900: fb fb fb fb fb fb fb fb fb fb fb fb fb fb fb fb
==================================================================


Tested on:

commit:         aa1df3a3 io_uring: fix CQE reordering
git tree:       git://git.kernel.dk/linux.git for-6.1/io_uring
console output: https://syzkaller.appspot.com/x/log.txt?x=12e27688880000
kernel config:  https://syzkaller.appspot.com/x/.config?x=3521db70c6a595c4
dashboard link: https://syzkaller.appspot.com/bug?extid=edfd15cd4246a3fc615a
compiler:       gcc (Debian 10.2.1-6) 10.2.1 20210110, GNU ld (GNU Binutils for Debian) 2.35.2

Note: no patches were applied.
