Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 72041662690
	for <lists+io-uring@lfdr.de>; Mon,  9 Jan 2023 14:10:21 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234700AbjAINKR (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Mon, 9 Jan 2023 08:10:17 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:55062 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233446AbjAINJy (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Mon, 9 Jan 2023 08:09:54 -0500
Received: from mail-ed1-x536.google.com (mail-ed1-x536.google.com [IPv6:2a00:1450:4864:20::536])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 9BECDFD4;
        Mon,  9 Jan 2023 05:09:37 -0800 (PST)
Received: by mail-ed1-x536.google.com with SMTP id c34so12488250edf.0;
        Mon, 09 Jan 2023 05:09:37 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=content-transfer-encoding:in-reply-to:from:content-language
         :references:to:subject:user-agent:mime-version:date:message-id:from
         :to:cc:subject:date:message-id:reply-to;
        bh=+T9S6AAwG8Npn1wIfp9AWbaogJg1ZXaofb1Rhh9l9zg=;
        b=E8236e5rH5n8e0InMTVO9xcYDLgC4xpdMbKwEGBAqFkZFflRhGxaGjrckD+nYHd1qK
         fpd7OAWLkFNJa03EqouoBmxP0J4QMJQXKLOMn4CwPgwb/ZaQezAsdIt9MqBlOssz/BiE
         6FT04aSpDRefnzTMZ/5XRyTJ/lVRmETTWzq6Ee6UzzKlcIAoNWafRQH7StIHsk8GaKkN
         nEJnsHpmb/JqXmM5PyW9K7VCHGAo31XcaVRtgmaOUEtlZOCi0WbKoTPnAekiLNKOnUrd
         k9swb4R22+bCSJvYn1V5uEMxt4cfSsCkwIZlxWQTiEHgS5cB5mdvD/D+11l0cqjMFxl5
         qWHg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=content-transfer-encoding:in-reply-to:from:content-language
         :references:to:subject:user-agent:mime-version:date:message-id
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=+T9S6AAwG8Npn1wIfp9AWbaogJg1ZXaofb1Rhh9l9zg=;
        b=gKd8OkOL1ktmddckZD7n4GwtD7/ROufjMzfrm91N3tx7rf3CRT9/plcK9f9tpbvnit
         bTSyIneMN1Weq4VMaZqBMAsV2pYCaAELeCPD/WvKpsuvAoHp3gZ+ON3ld7btmjtYk958
         NezqJgg2RO+5Uya6VopPOTKoirnLa308aLFma89OZn68ib7Wu3Zh5CZnnnmww1nkqI4+
         Y4zv/qeuThqgWzZW/wrqKga9fQn9HUKHIIJciWqJ5PbDuTrUyHu7Rq4Zqi6+QST/385q
         d/c2rM/8E0+ZYSajpHG4VJgMRiiGoRKwULcHL4aSK77EDq5jSyKqccQ7dUrGI8pmdnLV
         dbuA==
X-Gm-Message-State: AFqh2kpaTGWZajwRIRZ7lOJqBfaO5S2mIWnG4yjLgG17zqwmIH2rdQ+H
        p30lBvB7nf0c1H+Y67vSfunnoqKRco4=
X-Google-Smtp-Source: AMrXdXtpco9ECm40SAv5bUFmnHNMutSagBbNQ/evmwmiyc4sQyVhzMvBnc899KScbwoVcAOE2ocwhQ==
X-Received: by 2002:a05:6402:a55:b0:475:9918:37ce with SMTP id bt21-20020a0564020a5500b00475991837cemr55323618edb.13.1673269775961;
        Mon, 09 Jan 2023 05:09:35 -0800 (PST)
Received: from [192.168.8.100] (188.29.102.7.threembb.co.uk. [188.29.102.7])
        by smtp.gmail.com with ESMTPSA id f1-20020a17090631c100b007aea1dc1840sm3723491ejf.111.2023.01.09.05.09.34
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Mon, 09 Jan 2023 05:09:35 -0800 (PST)
Message-ID: <3b08247b-a645-db6a-aa20-ba77766730bc@gmail.com>
Date:   Mon, 9 Jan 2023 13:08:38 +0000
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:102.0) Gecko/20100101
 Thunderbird/102.5.1
Subject: Re: [syzbot] KASAN: use-after-free Read in io_worker_get
To:     syzbot <syzbot+55cc59267340fad29512@syzkaller.appspotmail.com>,
        axboe@kernel.dk, io-uring@vger.kernel.org,
        linux-kernel@vger.kernel.org, syzkaller-bugs@googlegroups.com
References: <00000000000097fc2305f1ce87d9@google.com>
Content-Language: en-US
From:   Pavel Begunkov <asml.silence@gmail.com>
In-Reply-To: <00000000000097fc2305f1ce87d9@google.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_FROM,NICE_REPLY_A,
        RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org

On 1/9/23 06:03, syzbot wrote:
> Hello,
> 
> syzbot found the following issue on:

#syz test: git://git.kernel.dk/linux.git syztest

> 
> HEAD commit:    a689b938df39 Merge tag 'block-2023-01-06' of git://git.ker..
> git tree:       upstream
> console output: https://syzkaller.appspot.com/x/log.txt?x=1495a5e6480000
> kernel config:  https://syzkaller.appspot.com/x/.config?x=33ad6720950f996d
> dashboard link: https://syzkaller.appspot.com/bug?extid=55cc59267340fad29512
> compiler:       Debian clang version 13.0.1-++20220126092033+75e33f71c2da-1~exp1~20220126212112.63, GNU ld (GNU Binutils for Debian) 2.35.2
> syz repro:      https://syzkaller.appspot.com/x/repro.syz?x=1532ef72480000
> C reproducer:   https://syzkaller.appspot.com/x/repro.c?x=10b43f3a480000
> 
> Downloadable assets:
> disk image: https://storage.googleapis.com/syzbot-assets/5fcfa927aa80/disk-a689b938.raw.xz
> vmlinux: https://storage.googleapis.com/syzbot-assets/e92e2a5e7778/vmlinux-a689b938.xz
> kernel image: https://storage.googleapis.com/syzbot-assets/5e792fc2d1a8/bzImage-a689b938.xz
> 
> The issue was bisected to:
> 
> commit af82425c6a2d2f347c79b63ce74fca6dc6be157f
> Author: Jens Axboe <axboe@kernel.dk>
> Date:   Mon Jan 2 23:49:46 2023 +0000
> 
>      io_uring/io-wq: free worker if task_work creation is canceled
> 
> bisection log:  https://syzkaller.appspot.com/x/bisect.txt?x=16a90a6e480000
> final oops:     https://syzkaller.appspot.com/x/report.txt?x=15a90a6e480000
> console output: https://syzkaller.appspot.com/x/log.txt?x=11a90a6e480000
> 
> IMPORTANT: if you fix the issue, please add the following tag to the commit:
> Reported-by: syzbot+55cc59267340fad29512@syzkaller.appspotmail.com
> Fixes: af82425c6a2d ("io_uring/io-wq: free worker if task_work creation is canceled")
> 
> ==================================================================
> BUG: KASAN: use-after-free in instrument_atomic_read include/linux/instrumented.h:72 [inline]
> BUG: KASAN: use-after-free in atomic_read include/linux/atomic/atomic-instrumented.h:27 [inline]
> BUG: KASAN: use-after-free in refcount_read include/linux/refcount.h:147 [inline]
> BUG: KASAN: use-after-free in __refcount_add_not_zero include/linux/refcount.h:152 [inline]
> BUG: KASAN: use-after-free in __refcount_inc_not_zero include/linux/refcount.h:227 [inline]
> BUG: KASAN: use-after-free in refcount_inc_not_zero include/linux/refcount.h:245 [inline]
> BUG: KASAN: use-after-free in io_worker_get+0x77/0x2a0 io_uring/io-wq.c:153
> Read of size 4 at addr ffff888028085c00 by task syz-executor161/5058
> 
> CPU: 0 PID: 5058 Comm: syz-executor161 Not tainted 6.2.0-rc2-syzkaller-00256-ga689b938df39 #0
> Hardware name: Google Google Compute Engine/Google Compute Engine, BIOS Google 10/26/2022
> Call Trace:
>   <TASK>
>   __dump_stack lib/dump_stack.c:88 [inline]
>   dump_stack_lvl+0x1e3/0x2d0 lib/dump_stack.c:106
>   print_address_description+0x74/0x340 mm/kasan/report.c:306
>   print_report+0x107/0x220 mm/kasan/report.c:417
>   kasan_report+0x139/0x170 mm/kasan/report.c:517
>   kasan_check_range+0x2a7/0x2e0 mm/kasan/generic.c:189
>   instrument_atomic_read include/linux/instrumented.h:72 [inline]
>   atomic_read include/linux/atomic/atomic-instrumented.h:27 [inline]
>   refcount_read include/linux/refcount.h:147 [inline]
>   __refcount_add_not_zero include/linux/refcount.h:152 [inline]
>   __refcount_inc_not_zero include/linux/refcount.h:227 [inline]
>   refcount_inc_not_zero include/linux/refcount.h:245 [inline]
>   io_worker_get+0x77/0x2a0 io_uring/io-wq.c:153
>   io_wq_for_each_worker io_uring/io-wq.c:846 [inline]
>   io_wq_exit_workers io_uring/io-wq.c:1250 [inline]
>   io_wq_put_and_exit+0x2f8/0xcb0 io_uring/io-wq.c:1289
>   io_uring_clean_tctx+0x164/0x1d0 io_uring/tctx.c:193
>   io_uring_cancel_generic+0x60e/0x670 io_uring/io_uring.c:3145
>   io_uring_files_cancel include/linux/io_uring.h:55 [inline]
>   do_exit+0x2ad/0x2150 kernel/exit.c:822
>   do_group_exit+0x1fd/0x2b0 kernel/exit.c:1012
>   __do_sys_exit_group kernel/exit.c:1023 [inline]
>   __se_sys_exit_group kernel/exit.c:1021 [inline]
>   __x64_sys_exit_group+0x3b/0x40 kernel/exit.c:1021
>   do_syscall_x64 arch/x86/entry/common.c:50 [inline]
>   do_syscall_64+0x2b/0x70 arch/x86/entry/common.c:80
>   entry_SYSCALL_64_after_hwframe+0x63/0xcd
> RIP: 0033:0x7f43fd8b3ce9
> Code: 00 49 c7 c0 c0 ff ff ff be e7 00 00 00 ba 3c 00 00 00 eb 12 0f 1f 44 00 00 89 d0 0f 05 48 3d 00 f0 ff ff 77 1c f4 89 f0 0f 05 <48> 3d 00 f0 ff ff 76 e7 f7 d8 64 41 89 00 eb df 0f 1f 80 00 00 00
> RSP: 002b:00007fffe594c5b8 EFLAGS: 00000246 ORIG_RAX: 00000000000000e7
> RAX: ffffffffffffffda RBX: 00007f43fd929350 RCX: 00007f43fd8b3ce9
> RDX: 000000000000003c RSI: 00000000000000e7 RDI: 0000000000000000
> RBP: 0000000000000000 R08: ffffffffffffffc0 R09: 0000000000000000
> R10: 0000000000000000 R11: 0000000000000246 R12: 00007f43fd929350
> R13: 0000000000000001 R14: 0000000000000000 R15: 0000000000000001
>   </TASK>
> 
> Allocated by task 5058:
>   kasan_save_stack mm/kasan/common.c:45 [inline]
>   kasan_set_track+0x4c/0x70 mm/kasan/common.c:52
>   ____kasan_kmalloc mm/kasan/common.c:371 [inline]
>   __kasan_kmalloc+0x97/0xb0 mm/kasan/common.c:380
>   kmalloc_node include/linux/slab.h:606 [inline]
>   kzalloc_node include/linux/slab.h:731 [inline]
>   create_io_worker+0xef/0x630 io_uring/io-wq.c:801
>   create_worker_cb+0x16b/0x330 io_uring/io-wq.c:339
>   task_work_run+0x243/0x300 kernel/task_work.c:179
>   get_signal+0x1654/0x1820 kernel/signal.c:2635
>   arch_do_signal_or_restart+0x8d/0x5f0 arch/x86/kernel/signal.c:306
>   exit_to_user_mode_loop+0x74/0x160 kernel/entry/common.c:168
>   exit_to_user_mode_prepare+0xad/0x110 kernel/entry/common.c:203
>   irqentry_exit_to_user_mode+0x5/0x30 kernel/entry/common.c:309
>   exc_page_fault+0xa2/0x120 arch/x86/mm/fault.c:1578
>   asm_exc_page_fault+0x22/0x30 arch/x86/include/asm/idtentry.h:570
> 
> Freed by task 5058:
>   kasan_save_stack mm/kasan/common.c:45 [inline]
>   kasan_set_track+0x4c/0x70 mm/kasan/common.c:52
>   kasan_save_free_info+0x27/0x40 mm/kasan/generic.c:518
>   ____kasan_slab_free+0xd6/0x120 mm/kasan/common.c:236
>   kasan_slab_free include/linux/kasan.h:177 [inline]
>   slab_free_hook mm/slub.c:1781 [inline]
>   slab_free_freelist_hook+0x12e/0x1a0 mm/slub.c:1807
>   slab_free mm/slub.c:3787 [inline]
>   __kmem_cache_free+0x71/0x110 mm/slub.c:3800
>   io_wq_cancel_tw_create io_uring/io-wq.c:1233 [inline]
>   io_wq_exit_workers io_uring/io-wq.c:1244 [inline]
>   io_wq_put_and_exit+0x137/0xcb0 io_uring/io-wq.c:1289
>   io_uring_clean_tctx+0x164/0x1d0 io_uring/tctx.c:193
>   io_uring_cancel_generic+0x60e/0x670 io_uring/io_uring.c:3145
>   io_uring_files_cancel include/linux/io_uring.h:55 [inline]
>   do_exit+0x2ad/0x2150 kernel/exit.c:822
>   do_group_exit+0x1fd/0x2b0 kernel/exit.c:1012
>   __do_sys_exit_group kernel/exit.c:1023 [inline]
>   __se_sys_exit_group kernel/exit.c:1021 [inline]
>   __x64_sys_exit_group+0x3b/0x40 kernel/exit.c:1021
>   do_syscall_x64 arch/x86/entry/common.c:50 [inline]
>   do_syscall_64+0x2b/0x70 arch/x86/entry/common.c:80
>   entry_SYSCALL_64_after_hwframe+0x63/0xcd
> 
> Last potentially related work creation:
>   kasan_save_stack+0x3b/0x60 mm/kasan/common.c:45
>   __kasan_record_aux_stack+0xb0/0xc0 mm/kasan/generic.c:488
>   task_work_add+0x87/0x340 kernel/task_work.c:48
>   io_queue_worker_create+0x1e2/0x430 io_uring/io-wq.c:373
>   sched_submit_work kernel/sched/core.c:6597 [inline]
>   schedule+0x63/0x190 kernel/sched/core.c:6628
>   schedule_timeout+0xac/0x300 kernel/time/timer.c:2143
>   wait_woken+0xca/0x1b0 kernel/sched/wait.c:463
>   af_alg_wait_for_data+0x458/0x700 crypto/af_alg.c:904
>   _skcipher_recvmsg crypto/algif_skcipher.c:65 [inline]
>   skcipher_recvmsg+0x2d9/0xea0 crypto/algif_skcipher.c:157
>   sock_recvmsg_nosec net/socket.c:995 [inline]
>   sock_recvmsg net/socket.c:1013 [inline]
>   sock_read_iter+0x3fa/0x530 net/socket.c:1086
>   call_read_iter include/linux/fs.h:2183 [inline]
>   io_iter_do_read io_uring/rw.c:643 [inline]
>   io_read+0x4a8/0x1310 io_uring/rw.c:766
>   io_issue_sqe+0x44e/0xcd0 io_uring/io_uring.c:1856
>   io_wq_submit_work+0x44a/0x9c0 io_uring/io_uring.c:1932
>   io_worker_handle_work+0x8e1/0xee0 io_uring/io-wq.c:587
>   io_wqe_worker+0x36c/0xde0 io_uring/io-wq.c:632
>   ret_from_fork+0x1f/0x30 arch/x86/entry/entry_64.S:308
> 
> The buggy address belongs to the object at ffff888028085c00
>   which belongs to the cache kmalloc-512 of size 512
> The buggy address is located 0 bytes inside of
>   512-byte region [ffff888028085c00, ffff888028085e00)
> 
> The buggy address belongs to the physical page:
> page:ffffea0000a02100 refcount:1 mapcount:0 mapping:0000000000000000 index:0x0 pfn:0x28084
> head:ffffea0000a02100 order:2 compound_mapcount:0 subpages_mapcount:0 compound_pincount:0
> anon flags: 0xfff00000010200(slab|head|node=0|zone=1|lastcpupid=0x7ff)
> raw: 00fff00000010200 ffff888012841c80 0000000000000000 dead000000000001
> raw: 0000000000000000 0000000080100010 00000001ffffffff 0000000000000000
> page dumped because: kasan: bad access detected
> page_owner tracks the page as allocated
> page last allocated via order 2, migratetype Unmovable, gfp_mask 0xd20c0(__GFP_IO|__GFP_FS|__GFP_NOWARN|__GFP_NORETRY|__GFP_COMP|__GFP_NOMEMALLOC), pid 1, tgid 1 (swapper/0), ts 9757639976, free_ts 0
>   prep_new_page mm/page_alloc.c:2531 [inline]
>   get_page_from_freelist+0x72b/0x7a0 mm/page_alloc.c:4283
>   __alloc_pages+0x259/0x560 mm/page_alloc.c:5549
>   alloc_page_interleave+0x22/0x1c0 mm/mempolicy.c:2119
>   alloc_slab_page+0xbd/0x190 mm/slub.c:1851
>   allocate_slab+0x5e/0x3c0 mm/slub.c:1998
>   new_slab mm/slub.c:2051 [inline]
>   ___slab_alloc+0x7f4/0xeb0 mm/slub.c:3193
>   __slab_alloc mm/slub.c:3292 [inline]
>   __slab_alloc_node mm/slub.c:3345 [inline]
>   slab_alloc_node mm/slub.c:3442 [inline]
>   __kmem_cache_alloc_node+0x25b/0x340 mm/slub.c:3491
>   kmalloc_trace+0x26/0x60 mm/slab_common.c:1062
>   kmalloc include/linux/slab.h:580 [inline]
>   kzalloc include/linux/slab.h:720 [inline]
>   device_private_init drivers/base/core.c:3323 [inline]
>   device_add+0xb6/0xf90 drivers/base/core.c:3373
>   netdev_register_kobject+0x178/0x310 net/core/net-sysfs.c:2015
>   register_netdevice+0x136c/0x1a30 net/core/dev.c:10045
>   register_netdev+0x37/0x50 net/core/dev.c:10173
>   rose_proto_init+0x197/0x7c0 net/rose/af_rose.c:1545
>   do_one_initcall+0xbd/0x2c0 init/main.c:1306
>   do_initcall_level+0x168/0x220 init/main.c:1379
>   do_initcalls+0x43/0x90 init/main.c:1395
> page_owner free stack trace missing
> 
> Memory state around the buggy address:
>   ffff888028085b00: fc fc fc fc fc fc fc fc fc fc fc fc fc fc fc fc
>   ffff888028085b80: fc fc fc fc fc fc fc fc fc fc fc fc fc fc fc fc
>> ffff888028085c00: fa fb fb fb fb fb fb fb fb fb fb fb fb fb fb fb
>                     ^
>   ffff888028085c80: fb fb fb fb fb fb fb fb fb fb fb fb fb fb fb fb
>   ffff888028085d00: fb fb fb fb fb fb fb fb fb fb fb fb fb fb fb fb
> ==================================================================
> 
> 
> ---
> This report is generated by a bot. It may contain errors.
> See https://goo.gl/tpsmEJ for more information about syzbot.
> syzbot engineers can be reached at syzkaller@googlegroups.com.
> 
> syzbot will keep track of this issue. See:
> https://goo.gl/tpsmEJ#status for how to communicate with syzbot.
> For information about bisection process see: https://goo.gl/tpsmEJ#bisection
> syzbot can test patches for this issue, for details see:
> https://goo.gl/tpsmEJ#testing-patches

-- 
Pavel Begunkov
