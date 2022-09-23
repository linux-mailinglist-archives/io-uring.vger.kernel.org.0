Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 3578F5E8016
	for <lists+io-uring@lfdr.de>; Fri, 23 Sep 2022 18:42:40 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231916AbiIWQmi (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Fri, 23 Sep 2022 12:42:38 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:32850 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232216AbiIWQmN (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Fri, 23 Sep 2022 12:42:13 -0400
Received: from mail-il1-f200.google.com (mail-il1-f200.google.com [209.85.166.200])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 1DF33130BC3
        for <io-uring@vger.kernel.org>; Fri, 23 Sep 2022 09:41:38 -0700 (PDT)
Received: by mail-il1-f200.google.com with SMTP id k3-20020a056e02156300b002f5623faa62so612047ilu.0
        for <io-uring@vger.kernel.org>; Fri, 23 Sep 2022 09:41:38 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=to:from:subject:message-id:in-reply-to:date:mime-version
         :x-gm-message-state:from:to:cc:subject:date;
        bh=TLGBQepgSmBhiUnRTqRvQ1LUISgDXrjWwuExeNYIVI0=;
        b=2JCPRQtF1JHRj/K4iX3VDuSNXG+K6mZtUqv27s0zU6+PACdMYmj+aLfALkNYkYFwFj
         CKMTrEPTaNwmNzDGTFK5qtkkA/Z1Zm0/rUQ63pvHrKW/Qf6vBwbM4POaEQ3CIQ4289v7
         w7d7yvcwtH3kemzRs5rhoeFvHaKJyt4dCWA4RNSSc8M+27OaCxcOgKZqPGtfbZl/6Iui
         Z6SjOltAlHGnwJHp6AfHt0h4RkJvfPK5zqKyeTAwLFqaiXTqvujau+OjL7LpuhUn2dpy
         IHYCkgONoq3QxKoJogoHr2q2BZXntG/ORtQQqHb3+8NSGAizonPFCXPA6nVohrXWbBBj
         kT0Q==
X-Gm-Message-State: ACrzQf33RdvUUltFgeMhtigO6cLicmIgumK5JV89CqHZENdxsgp9Q4/2
        Xr/q8MRiYrFXhVoeFvgxdssjQxGlwTlvsqm0aMqJ4IfzIbf1
X-Google-Smtp-Source: AMsMyM7EPi6wRy1BkXonok+Y1PmI36LaeQR/PlxmEDTDxd/nsU/E+SrLBUQm/BLXe77C0HncoK6RgRVyCep0/zAAjSdcp+S1PudF
MIME-Version: 1.0
X-Received: by 2002:a05:6602:1601:b0:6a1:d963:4fc with SMTP id
 x1-20020a056602160100b006a1d96304fcmr4235876iow.67.1663951297446; Fri, 23 Sep
 2022 09:41:37 -0700 (PDT)
Date:   Fri, 23 Sep 2022 09:41:37 -0700
In-Reply-To: <0000000000005ec0e805e9575c11@google.com>
X-Google-Appengine-App-Id: s~syzkaller
X-Google-Appengine-App-Id-Alias: syzkaller
Message-ID: <000000000000020c4805e95ada45@google.com>
Subject: Re: [syzbot] KASAN: use-after-free Write in io_sendrecv_fail
From:   syzbot <syzbot+4c597a574a3f5a251bda@syzkaller.appspotmail.com>
To:     Kernel-team@fb.com, asml.silence@gmail.com, axboe@kernel.dk,
        dylany@fb.com, io-uring@vger.kernel.org,
        linux-kernel@vger.kernel.org, syzkaller-bugs@googlegroups.com
Content-Type: text/plain; charset="UTF-8"
X-Spam-Status: No, score=0.9 required=5.0 tests=BAYES_00,FROM_LOCAL_HEX,
        HEADER_FROM_DIFFERENT_DOMAINS,RCVD_IN_DNSWL_NONE,RCVD_IN_MSPIKE_H2,
        SORTED_RECIPS,SPF_HELO_NONE,SPF_PASS autolearn=no autolearn_force=no
        version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org

syzbot has found a reproducer for the following issue on:

HEAD commit:    aaa11ce2ffc8 Add linux-next specific files for 20220923
git tree:       linux-next
console+strace: https://syzkaller.appspot.com/x/log.txt?x=158bdb90880000
kernel config:  https://syzkaller.appspot.com/x/.config?x=186d1ff305f10294
dashboard link: https://syzkaller.appspot.com/bug?extid=4c597a574a3f5a251bda
compiler:       gcc (Debian 10.2.1-6) 10.2.1 20210110, GNU ld (GNU Binutils for Debian) 2.35.2
syz repro:      https://syzkaller.appspot.com/x/repro.syz?x=14d95fd8880000
C reproducer:   https://syzkaller.appspot.com/x/repro.c?x=17d0c2ef080000

IMPORTANT: if you fix the issue, please add the following tag to the commit:
Reported-by: syzbot+4c597a574a3f5a251bda@syzkaller.appspotmail.com

==================================================================
BUG: KASAN: use-after-free in io_sendrecv_fail+0x3b0/0x3e0 io_uring/net.c:1221
Write of size 8 at addr ffff888021163080 by task syz-executor258/3615

CPU: 1 PID: 3615 Comm: syz-executor258 Not tainted 6.0.0-rc6-next-20220923-syzkaller #0
Hardware name: Google Google Compute Engine/Google Compute Engine, BIOS Google 08/26/2022
Call Trace:
 <TASK>
 __dump_stack lib/dump_stack.c:88 [inline]
 dump_stack_lvl+0xcd/0x134 lib/dump_stack.c:106
 print_address_description mm/kasan/report.c:284 [inline]
 print_report+0x15e/0x45d mm/kasan/report.c:395
 kasan_report+0xbb/0x1f0 mm/kasan/report.c:495
 io_sendrecv_fail+0x3b0/0x3e0 io_uring/net.c:1221
 io_req_complete_failed+0x155/0x1b0 io_uring/io_uring.c:873
 io_drain_req io_uring/io_uring.c:1648 [inline]
 io_queue_sqe_fallback.cold+0x29f/0x788 io_uring/io_uring.c:1931
 io_submit_sqe io_uring/io_uring.c:2160 [inline]
 io_submit_sqes+0x1180/0x1df0 io_uring/io_uring.c:2276
 __do_sys_io_uring_enter+0xac6/0x2410 io_uring/io_uring.c:3216
 do_syscall_x64 arch/x86/entry/common.c:50 [inline]
 do_syscall_64+0x35/0xb0 arch/x86/entry/common.c:80
 entry_SYSCALL_64_after_hwframe+0x63/0xcd
RIP: 0033:0x7f8db2983dc9
Code: 28 c3 e8 2a 14 00 00 66 2e 0f 1f 84 00 00 00 00 00 48 89 f8 48 89 f7 48 89 d6 48 89 ca 4d 89 c2 4d 89 c8 4c 8b 4c 24 08 0f 05 <48> 3d 01 f0 ff ff 73 01 c3 48 c7 c1 c0 ff ff ff f7 d8 64 89 01 48
RSP: 002b:00007fffe363f568 EFLAGS: 00000246 ORIG_RAX: 00000000000001aa
RAX: ffffffffffffffda RBX: 0000000000000003 RCX: 00007f8db2983dc9
RDX: 0000000000000000 RSI: 0000000000002a6e RDI: 0000000000000003
RBP: 00007f8db2947f70 R08: 0000000000000000 R09: 0000000000000000
R10: 0000000000000000 R11: 0000000000000246 R12: 00007f8db2948000
R13: 0000000000000000 R14: 0000000000000000 R15: 0000000000000000
 </TASK>

Allocated by task 3615:
 kasan_save_stack+0x1e/0x40 mm/kasan/common.c:45
 kasan_set_track+0x21/0x30 mm/kasan/common.c:52
 ____kasan_kmalloc mm/kasan/common.c:371 [inline]
 ____kasan_kmalloc mm/kasan/common.c:330 [inline]
 __kasan_kmalloc+0xa1/0xb0 mm/kasan/common.c:380
 kasan_kmalloc include/linux/kasan.h:211 [inline]
 __do_kmalloc_node mm/slab_common.c:934 [inline]
 __kmalloc+0x54/0xc0 mm/slab_common.c:947
 kmalloc include/linux/slab.h:564 [inline]
 io_alloc_async_data+0x9b/0x160 io_uring/io_uring.c:1590
 io_msg_alloc_async io_uring/net.c:138 [inline]
 io_msg_alloc_async_prep io_uring/net.c:147 [inline]
 io_sendmsg_prep_async+0x19b/0x3c0 io_uring/net.c:221
 io_req_prep_async+0x1d9/0x300 io_uring/io_uring.c:1613
 io_drain_req io_uring/io_uring.c:1645 [inline]
 io_queue_sqe_fallback.cold+0x281/0x788 io_uring/io_uring.c:1931
 io_submit_sqe io_uring/io_uring.c:2160 [inline]
 io_submit_sqes+0x1180/0x1df0 io_uring/io_uring.c:2276
 __do_sys_io_uring_enter+0xac6/0x2410 io_uring/io_uring.c:3216
 do_syscall_x64 arch/x86/entry/common.c:50 [inline]
 do_syscall_64+0x35/0xb0 arch/x86/entry/common.c:80
 entry_SYSCALL_64_after_hwframe+0x63/0xcd

Freed by task 3615:
 kasan_save_stack+0x1e/0x40 mm/kasan/common.c:45
 kasan_set_track+0x21/0x30 mm/kasan/common.c:52
 kasan_save_free_info+0x2a/0x40 mm/kasan/generic.c:511
 ____kasan_slab_free mm/kasan/common.c:236 [inline]
 ____kasan_slab_free+0x160/0x1c0 mm/kasan/common.c:200
 kasan_slab_free include/linux/kasan.h:177 [inline]
 slab_free_hook mm/slub.c:1669 [inline]
 slab_free_freelist_hook+0x8b/0x1c0 mm/slub.c:1695
 slab_free mm/slub.c:3599 [inline]
 __kmem_cache_free+0xab/0x3b0 mm/slub.c:3612
 io_sendrecv_fail+0x2a4/0x3e0 io_uring/net.c:1220
 io_req_complete_failed+0x155/0x1b0 io_uring/io_uring.c:873
 io_drain_req io_uring/io_uring.c:1648 [inline]
 io_queue_sqe_fallback.cold+0x29f/0x788 io_uring/io_uring.c:1931
 io_submit_sqe io_uring/io_uring.c:2160 [inline]
 io_submit_sqes+0x1180/0x1df0 io_uring/io_uring.c:2276
 __do_sys_io_uring_enter+0xac6/0x2410 io_uring/io_uring.c:3216
 do_syscall_x64 arch/x86/entry/common.c:50 [inline]
 do_syscall_64+0x35/0xb0 arch/x86/entry/common.c:80
 entry_SYSCALL_64_after_hwframe+0x63/0xcd

The buggy address belongs to the object at ffff888021163000
 which belongs to the cache kmalloc-512 of size 512
The buggy address is located 128 bytes inside of
 512-byte region [ffff888021163000, ffff888021163200)

The buggy address belongs to the physical page:
page:ffffea0000845800 refcount:1 mapcount:0 mapping:0000000000000000 index:0xffffea0000854700 pfn:0x21160
head:ffffea0000845800 order:2 compound_mapcount:0 compound_pincount:0
flags: 0xfff00000010200(slab|head|node=0|zone=1|lastcpupid=0x7ff)
raw: 00fff00000010200 ffff888011841c80 dead000080100010 0000000000000000
raw: ffffea0000854700 dead000000000002 00000001ffffffff 0000000000000000
page dumped because: kasan: bad access detected
page_owner tracks the page as allocated
page last allocated via order 2, migratetype Unmovable, gfp_mask 0xd20c0(__GFP_IO|__GFP_FS|__GFP_NOWARN|__GFP_NORETRY|__GFP_COMP|__GFP_NOMEMALLOC), pid 1501, tgid 1501 (kworker/u4:5), ts 8710207687, free_ts 0
 prep_new_page mm/page_alloc.c:2538 [inline]
 get_page_from_freelist+0x1092/0x2d20 mm/page_alloc.c:4287
 __alloc_pages+0x1c7/0x5a0 mm/page_alloc.c:5546
 alloc_pages+0x1a6/0x270 mm/mempolicy.c:2280
 alloc_slab_page mm/slub.c:1739 [inline]
 allocate_slab+0x213/0x300 mm/slub.c:1884
 new_slab mm/slub.c:1937 [inline]
 ___slab_alloc+0xac1/0x1430 mm/slub.c:3119
 __slab_alloc.constprop.0+0x4d/0xa0 mm/slub.c:3217
 slab_alloc_node mm/slub.c:3302 [inline]
 __kmem_cache_alloc_node+0x18a/0x3d0 mm/slub.c:3375
 kmalloc_trace+0x22/0x60 mm/slab_common.c:1014
 kmalloc include/linux/slab.h:559 [inline]
 kzalloc include/linux/slab.h:695 [inline]
 alloc_bprm+0x51/0x900 fs/exec.c:1510
 kernel_execve+0xab/0x500 fs/exec.c:1969
 call_usermodehelper_exec_async+0x2e3/0x580 kernel/umh.c:113
 ret_from_fork+0x1f/0x30 arch/x86/entry/entry_64.S:306
page_owner free stack trace missing

Memory state around the buggy address:
 ffff888021162f80: fc fc fc fc fc fc fc fc fc fc fc fc fc fc fc fc
 ffff888021163000: fa fb fb fb fb fb fb fb fb fb fb fb fb fb fb fb
>ffff888021163080: fb fb fb fb fb fb fb fb fb fb fb fb fb fb fb fb
                   ^
 ffff888021163100: fb fb fb fb fb fb fb fb fb fb fb fb fb fb fb fb
 ffff888021163180: fb fb fb fb fb fb fb fb fb fb fb fb fb fb fb fb
==================================================================

