Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 538814E4A6B
	for <lists+io-uring@lfdr.de>; Wed, 23 Mar 2022 02:20:28 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S241076AbiCWBVx (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Tue, 22 Mar 2022 21:21:53 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:33100 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229872AbiCWBVw (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Tue, 22 Mar 2022 21:21:52 -0400
Received: from mail-il1-f198.google.com (mail-il1-f198.google.com [209.85.166.198])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 4B7F86972A
        for <io-uring@vger.kernel.org>; Tue, 22 Mar 2022 18:20:23 -0700 (PDT)
Received: by mail-il1-f198.google.com with SMTP id m4-20020a924b04000000b002c851e73720so23163ilg.23
        for <io-uring@vger.kernel.org>; Tue, 22 Mar 2022 18:20:23 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:mime-version:date:in-reply-to:message-id:subject
         :from:to;
        bh=4oE/s5JQuU4pe1NxzWVJtqNkTMUBGTgcIS50OCSWyD8=;
        b=GuSUMDCP9WCiUeSRI2hC5tamPi74pjVsF4fDXakR/M6AQzcgVNkWgdkSSmLbcvLgqC
         IjQqb259i4QsqFG3RwT3PvKjVrtfshgEVyM6oWNDGUqUEMQ57iM9GBTXHuvYJiUqbG1D
         MOOmVuFuwppUPG8X/58pJ5MTQZiOm4esLKwwqWhbdTTKjDyuS0HsyPlBCvmsiHVP0NZC
         hJdrpUtyjXoiYc84zie3Nawy1yHAqjqNEz2EP0nm4Y2QD7UEyCfgWRjWTN1HNy3BvK3T
         j999fCgt7eeiIRdYcS0Dr8YdPwzEf2EVSQgbVbJgfDfYZHuZWqxRJL3j3VBQ2zf5FfTx
         xEbA==
X-Gm-Message-State: AOAM532CuQcxRf1nCC3opF0HpXHleRDrP7TY+Bcl5c1G5y3v4HE8/clt
        X6FOvBc59tcM4mdbfXfk28SoHFU7+ZR1t6VQ1gc3L5aUB6lr
X-Google-Smtp-Source: ABdhPJyN2m0WXbCnDo0SIMDjtgDYZLgXZ/WgBrIY6J0KGb8TnXTHzLB2rEHwA8xA/RSezlhWV1z1b4y+X3yjcu8o4NIqTcmSj7cO
MIME-Version: 1.0
X-Received: by 2002:a05:6e02:2143:b0:2c8:3bda:ba8f with SMTP id
 d3-20020a056e02214300b002c83bdaba8fmr3743528ilv.263.1647998422702; Tue, 22
 Mar 2022 18:20:22 -0700 (PDT)
Date:   Tue, 22 Mar 2022 18:20:22 -0700
In-Reply-To: <0000000000000f361d05dacabb09@google.com>
X-Google-Appengine-App-Id: s~syzkaller
X-Google-Appengine-App-Id-Alias: syzkaller
Message-ID: <000000000000935d2c05dad8883e@google.com>
Subject: Re: [syzbot] KASAN: use-after-free Read in io_poll_remove_entries
From:   syzbot <syzbot+cd301bb6523ea8cc8ca2@syzkaller.appspotmail.com>
To:     asml.silence@gmail.com, axboe@kernel.dk, io-uring@vger.kernel.org,
        linux-kernel@vger.kernel.org, syzkaller-bugs@googlegroups.com
Content-Type: text/plain; charset="UTF-8"
X-Spam-Status: No, score=-1.7 required=5.0 tests=BAYES_00,FROM_LOCAL_HEX,
        HEADER_FROM_DIFFERENT_DOMAINS,RCVD_IN_DNSWL_NONE,RCVD_IN_MSPIKE_H2,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=no
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org

syzbot has found a reproducer for the following issue on:

HEAD commit:    b47d5a4f6b8d Merge tag 'audit-pr-20220321' of git://git.ke..
git tree:       upstream
console output: https://syzkaller.appspot.com/x/log.txt?x=10e8e8ed700000
kernel config:  https://syzkaller.appspot.com/x/.config?x=c44f0c051803a0ae
dashboard link: https://syzkaller.appspot.com/bug?extid=cd301bb6523ea8cc8ca2
compiler:       Debian clang version 11.0.1-2, GNU ld (GNU Binutils for Debian) 2.35.2
syz repro:      https://syzkaller.appspot.com/x/repro.syz?x=150525ed700000
C reproducer:   https://syzkaller.appspot.com/x/repro.c?x=10d08625700000

IMPORTANT: if you fix the issue, please add the following tag to the commit:
Reported-by: syzbot+cd301bb6523ea8cc8ca2@syzkaller.appspotmail.com

==================================================================
BUG: KASAN: use-after-free in __list_del_entry_valid+0x76/0x100 lib/list_debug.c:51
Read of size 8 at addr ffff88801ecab630 by task syz-executor987/3638

CPU: 1 PID: 3638 Comm: syz-executor987 Tainted: G        W         5.17.0-syzkaller-01442-gb47d5a4f6b8d #0
Hardware name: Google Google Compute Engine/Google Compute Engine, BIOS Google 01/01/2011
Call Trace:
 <TASK>
 __dump_stack lib/dump_stack.c:88 [inline]
 dump_stack_lvl+0x1dc/0x2d8 lib/dump_stack.c:106
 print_address_description+0x65/0x3a0 mm/kasan/report.c:255
 __kasan_report mm/kasan/report.c:442 [inline]
 kasan_report+0x19a/0x1f0 mm/kasan/report.c:459
 __list_del_entry_valid+0x76/0x100 lib/list_debug.c:51
 __list_del_entry include/linux/list.h:134 [inline]
 list_del_init include/linux/list.h:206 [inline]
 io_poll_remove_entry fs/io_uring.c:5863 [inline]
 io_poll_remove_entries+0x1a8/0x5c0 fs/io_uring.c:5895
 io_apoll_task_func+0x7d/0x2c0 fs/io_uring.c:5995
 handle_tw_list fs/io_uring.c:2480 [inline]
 tctx_task_work+0xcf1/0x1130 fs/io_uring.c:2514
 task_work_run+0x146/0x1c0 kernel/task_work.c:164
 exit_task_work include/linux/task_work.h:32 [inline]
 do_exit+0x5e3/0x22a0 kernel/exit.c:806
 do_group_exit+0x2af/0x2b0 kernel/exit.c:936
 __do_sys_exit_group+0x13/0x20 kernel/exit.c:947
 __se_sys_exit_group+0x10/0x10 kernel/exit.c:945
 __x64_sys_exit_group+0x37/0x40 kernel/exit.c:945
 do_syscall_x64 arch/x86/entry/common.c:50 [inline]
 do_syscall_64+0x2b/0x70 arch/x86/entry/common.c:80
 entry_SYSCALL_64_after_hwframe+0x44/0xae
RIP: 0033:0x7f0e18005c59
Code: Unable to access opcode bytes at RIP 0x7f0e18005c2f.
RSP: 002b:00007fff7d1f37a8 EFLAGS: 00000246 ORIG_RAX: 00000000000000e7
RAX: ffffffffffffffda RBX: 00007f0e1807a330 RCX: 00007f0e18005c59
RDX: 000000000000003c RSI: 00000000000000e7 RDI: 0000000000000000
RBP: 0000000000000000 R08: ffffffffffffffc0 R09: 0000000000000000
R10: 0000000000000000 R11: 0000000000000246 R12: 00007f0e1807a330
R13: 0000000000000001 R14: 0000000000000000 R15: 0000000000000001
 </TASK>

Allocated by task 3633:
 kasan_save_stack mm/kasan/common.c:38 [inline]
 kasan_set_track mm/kasan/common.c:45 [inline]
 set_alloc_info mm/kasan/common.c:436 [inline]
 ____kasan_kmalloc+0xdc/0x110 mm/kasan/common.c:515
 kasan_kmalloc include/linux/kasan.h:249 [inline]
 kmem_cache_alloc_trace+0x9d/0x330 mm/slub.c:3257
 kmalloc include/linux/slab.h:581 [inline]
 io_arm_poll_handler+0x3bd/0x710 fs/io_uring.c:6248
 io_queue_sqe_arm_apoll fs/io_uring.c:7499 [inline]
 __io_queue_sqe+0x23d/0x10b0 fs/io_uring.c:7541
 io_queue_sqe fs/io_uring.c:7568 [inline]
 io_submit_sqe fs/io_uring.c:7776 [inline]
 io_submit_sqes+0x1265/0xb050 fs/io_uring.c:7882
 __do_sys_io_uring_enter fs/io_uring.c:10924 [inline]
 __se_sys_io_uring_enter+0x31f/0x2f50 fs/io_uring.c:10850
 do_syscall_x64 arch/x86/entry/common.c:50 [inline]
 do_syscall_64+0x2b/0x70 arch/x86/entry/common.c:80
 entry_SYSCALL_64_after_hwframe+0x44/0xae

Freed by task 3633:
 kasan_save_stack mm/kasan/common.c:38 [inline]
 kasan_set_track+0x4c/0x70 mm/kasan/common.c:45
 kasan_set_free_info+0x1f/0x40 mm/kasan/generic.c:370
 ____kasan_slab_free+0x126/0x180 mm/kasan/common.c:366
 kasan_slab_free include/linux/kasan.h:215 [inline]
 slab_free_hook mm/slub.c:1728 [inline]
 slab_free_freelist_hook+0x12e/0x1a0 mm/slub.c:1754
 slab_free mm/slub.c:3509 [inline]
 kfree+0xb8/0x2e0 mm/slub.c:4562
 io_clean_op fs/io_uring.c:7137 [inline]
 io_dismantle_req+0x644/0x9b0 fs/io_uring.c:2270
 __io_req_complete_post+0x294/0x4b0 fs/io_uring.c:2108
 io_req_complete_post fs/io_uring.c:2121 [inline]
 io_req_complete_failed+0xd7/0x440 fs/io_uring.c:2152
 handle_tw_list fs/io_uring.c:2480 [inline]
 tctx_task_work+0xcf1/0x1130 fs/io_uring.c:2514
 task_work_run+0x146/0x1c0 kernel/task_work.c:164
 exit_task_work include/linux/task_work.h:32 [inline]
 do_exit+0x5e3/0x22a0 kernel/exit.c:806
 do_group_exit+0x2af/0x2b0 kernel/exit.c:936
 __do_sys_exit_group+0x13/0x20 kernel/exit.c:947
 __ia32_sys_exit_group+0x0/0x40 kernel/exit.c:945
 __x64_sys_exit_group+0x37/0x40 kernel/exit.c:945
 do_syscall_x64 arch/x86/entry/common.c:50 [inline]
 do_syscall_64+0x2b/0x70 arch/x86/entry/common.c:80
 entry_SYSCALL_64_after_hwframe+0x44/0xae

The buggy address belongs to the object at ffff88801ecab600
 which belongs to the cache kmalloc-96 of size 96
The buggy address is located 48 bytes inside of
 96-byte region [ffff88801ecab600, ffff88801ecab660)
The buggy address belongs to the page:
page:ffffea00007b2ac0 refcount:1 mapcount:0 mapping:0000000000000000 index:0x0 pfn:0x1ecab
flags: 0xfff00000000200(slab|node=0|zone=1|lastcpupid=0x7ff)
raw: 00fff00000000200 ffffea00007c7580 dead000000000004 ffff888011441780
raw: 0000000000000000 0000000000200020 00000001ffffffff 0000000000000000
page dumped because: kasan: bad access detected
page_owner tracks the page as allocated
page last allocated via order 0, migratetype Unmovable, gfp_mask 0x12c40(GFP_NOFS|__GFP_NOWARN|__GFP_NORETRY), pid 2979, ts 18120987075, free_ts 18116591159
 prep_new_page mm/page_alloc.c:2434 [inline]
 get_page_from_freelist+0x729/0x9e0 mm/page_alloc.c:4165
 __alloc_pages+0x255/0x580 mm/page_alloc.c:5389
 alloc_slab_page mm/slub.c:1799 [inline]
 allocate_slab+0xce/0x3f0 mm/slub.c:1944
 new_slab mm/slub.c:2004 [inline]
 ___slab_alloc+0x3fe/0xc30 mm/slub.c:3018
 __slab_alloc mm/slub.c:3105 [inline]
 slab_alloc_node mm/slub.c:3196 [inline]
 slab_alloc mm/slub.c:3238 [inline]
 __kmalloc+0x2eb/0x380 mm/slub.c:4420
 kmalloc include/linux/slab.h:586 [inline]
 kzalloc include/linux/slab.h:714 [inline]
 tomoyo_encode2+0x25a/0x560 security/tomoyo/realpath.c:45
 tomoyo_encode security/tomoyo/realpath.c:80 [inline]
 tomoyo_realpath_from_path+0x5c3/0x610 security/tomoyo/realpath.c:288
 tomoyo_get_realpath security/tomoyo/file.c:151 [inline]
 tomoyo_check_open_permission+0x22f/0x490 security/tomoyo/file.c:771
 security_file_open+0x50/0x570 security/security.c:1651
 do_dentry_open+0x350/0x1020 fs/open.c:811
 do_open fs/namei.c:3476 [inline]
 path_openat+0x273b/0x36a0 fs/namei.c:3609
 do_filp_open+0x277/0x4f0 fs/namei.c:3636
 do_sys_openat2+0x13b/0x500 fs/open.c:1214
 do_sys_open fs/open.c:1230 [inline]
 __do_sys_openat fs/open.c:1246 [inline]
 __se_sys_openat fs/open.c:1241 [inline]
 __x64_sys_openat+0x243/0x290 fs/open.c:1241
 do_syscall_x64 arch/x86/entry/common.c:50 [inline]
 do_syscall_64+0x2b/0x70 arch/x86/entry/common.c:80
 entry_SYSCALL_64_after_hwframe+0x44/0xae
page last free stack trace:
 reset_page_owner include/linux/page_owner.h:24 [inline]
 free_pages_prepare mm/page_alloc.c:1352 [inline]
 free_pcp_prepare+0xd1c/0xe00 mm/page_alloc.c:1404
 free_unref_page_prepare mm/page_alloc.c:3325 [inline]
 free_unref_page+0x7d/0x580 mm/page_alloc.c:3404
 free_pipe_info+0x2f6/0x380 fs/pipe.c:851
 put_pipe_info fs/pipe.c:711 [inline]
 pipe_release+0x235/0x310 fs/pipe.c:734
 __fput+0x3fc/0x870 fs/file_table.c:317
 task_work_run+0x146/0x1c0 kernel/task_work.c:164
 tracehook_notify_resume include/linux/tracehook.h:188 [inline]
 exit_to_user_mode_loop kernel/entry/common.c:189 [inline]
 exit_to_user_mode_prepare+0x1dd/0x200 kernel/entry/common.c:221
 __syscall_exit_to_user_mode_work kernel/entry/common.c:303 [inline]
 syscall_exit_to_user_mode+0x2e/0x70 kernel/entry/common.c:314
 entry_SYSCALL_64_after_hwframe+0x44/0xae

Memory state around the buggy address:
 ffff88801ecab500: 00 00 00 00 00 00 00 00 00 00 00 00 fc fc fc fc
 ffff88801ecab580: 00 00 00 00 00 00 00 00 00 fc fc fc fc fc fc fc
>ffff88801ecab600: fa fb fb fb fb fb fb fb fb fb fb fb fc fc fc fc
                                     ^
 ffff88801ecab680: 00 00 00 00 00 00 00 00 00 00 00 00 fc fc fc fc
 ffff88801ecab700: 00 00 00 00 00 00 00 00 00 fc fc fc fc fc fc fc
==================================================================

