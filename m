Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id E8FB95E9524
	for <lists+io-uring@lfdr.de>; Sun, 25 Sep 2022 19:56:00 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229801AbiIYRz6 (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Sun, 25 Sep 2022 13:55:58 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:52968 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229589AbiIYRz6 (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Sun, 25 Sep 2022 13:55:58 -0400
Received: from mail-wm1-x32c.google.com (mail-wm1-x32c.google.com [IPv6:2a00:1450:4864:20::32c])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 9F30C26132;
        Sun, 25 Sep 2022 10:55:53 -0700 (PDT)
Received: by mail-wm1-x32c.google.com with SMTP id r133-20020a1c448b000000b003b494ffc00bso6210404wma.0;
        Sun, 25 Sep 2022 10:55:53 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=content-transfer-encoding:in-reply-to:from:references:to
         :content-language:subject:user-agent:mime-version:date:message-id
         :from:to:cc:subject:date;
        bh=ErKLQpp98oYY9v9ittLiWQ76Krt7tBBS5Y0YDMuJc1U=;
        b=olvIrqpj4dPlF002MKpbE4WXZB4ZBm/5ca0aEquIXzCawq+raHXR3E4pNqjn4uFS5r
         YVcKVhZ2Iot/Dtpztoct9voE95Ry99gne0qtp88kPXEc2rfVpo5+q6yUOo34UFYan44M
         zOmG1EcVsRdJAPztjamQ2NN6eZiRTPBXW9m0TIxODMExGW1mTNM5seAUMIpjr2CzkpQg
         cP4/GpQfpO6kMZC5pUkCsgoGhNwOqEF4rJUv0GYZEI72zotoEVwE76ofN2LxWD7tOJmO
         5kelSat90Gk/C5HX60tbI/yalaQ/DETrgyLkEdBgXD0fvOO2KIVyZrM97oBnEjlQNOeD
         ciFQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=content-transfer-encoding:in-reply-to:from:references:to
         :content-language:subject:user-agent:mime-version:date:message-id
         :x-gm-message-state:from:to:cc:subject:date;
        bh=ErKLQpp98oYY9v9ittLiWQ76Krt7tBBS5Y0YDMuJc1U=;
        b=nZjkNne8aNULUaEB+Z1UpgORDWNZL8Oc0oHGbYGlR9z4K1scN7P+xYn6UDEax0d6g6
         2kK3g4CxJ41VZz7P+FgOvs5pDl3t/adQN2YEjj86mRIMqVIqQWzOOVdjzHcFm0TYEu7t
         CNmXKfyx6noEnJBsh7LdWATU63qaZZap/qk74znjrJWGh14cNk0Smunk0lFh5Q2zkR/q
         5rJlHMrJ8rWTFGhuoTBXnVYbIPEdobrO5IjNAUI6kkJ3rB/kKRHagMKIQxrLKEF/pbSu
         nUyK5iKQVO2ADU2pNtaayU0SzYR26304OpugW8eqWW6EPhsB7GEhpsPB2mF6NO27dym0
         xFnQ==
X-Gm-Message-State: ACrzQf0ePxSNdWhs5OT0iT6G3xyGDzDTu1tsrMyMTJ8rxGzESNd8hHNJ
        AkbhXflfZH01HR2bBusoTcs=
X-Google-Smtp-Source: AMsMyM40hXUiKC+mU40dI2eWxo+7HKVo75CFe2KZa4QoFzKlfO3NPwBC8fkYf+aTWTckMO2xdeRJuQ==
X-Received: by 2002:a1c:7716:0:b0:3b4:b2ba:d190 with SMTP id t22-20020a1c7716000000b003b4b2bad190mr12645714wmi.35.1664128552015;
        Sun, 25 Sep 2022 10:55:52 -0700 (PDT)
Received: from [192.168.8.198] (94.196.6.209.threembb.co.uk. [94.196.6.209])
        by smtp.gmail.com with ESMTPSA id x13-20020adff0cd000000b002205cbc1c74sm12089553wro.101.2022.09.25.10.55.50
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Sun, 25 Sep 2022 10:55:51 -0700 (PDT)
Message-ID: <8c9845cf-a5fe-21c0-10a5-2369758dd23c@gmail.com>
Date:   Sun, 25 Sep 2022 18:54:38 +0100
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:91.0) Gecko/20100101
 Thunderbird/91.12.0
Subject: Re: [syzbot] KASAN: invalid-free in io_clean_op
Content-Language: en-US
To:     syzbot <syzbot+edfd15cd4246a3fc615a@syzkaller.appspotmail.com>,
        axboe@kernel.dk, io-uring@vger.kernel.org,
        linux-kernel@vger.kernel.org, syzkaller-bugs@googlegroups.com
References: <00000000000091b65005e983c19d@google.com>
From:   Pavel Begunkov <asml.silence@gmail.com>
In-Reply-To: <00000000000091b65005e983c19d@google.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=-5.9 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_FROM,NICE_REPLY_A,
        RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org

On 9/25/22 18:29, syzbot wrote:
> Hello,
> 
> syzbot found the following issue on:
> 
> HEAD commit:    aaa11ce2ffc8 Add linux-next specific files for 20220923
> git tree:       linux-next
> console+strace: https://syzkaller.appspot.com/x/log.txt?x=1608cadf080000
> kernel config:  https://syzkaller.appspot.com/x/.config?x=186d1ff305f10294
> dashboard link: https://syzkaller.appspot.com/bug?extid=edfd15cd4246a3fc615a
> compiler:       gcc (Debian 10.2.1-6) 10.2.1 20210110, GNU ld (GNU Binutils for Debian) 2.35.2
> syz repro:      https://syzkaller.appspot.com/x/repro.syz?x=144acdef080000
> C reproducer:   https://syzkaller.appspot.com/x/repro.c?x=10686540880000
> 
> IMPORTANT: if you fix the issue, please add the following tag to the commit:
> Reported-by: syzbot+edfd15cd4246a3fc615a@syzkaller.appspotmail.com

#syz test: git://git.kernel.dk/linux.git for-6.1/io_uring

> ==================================================================
> BUG: KASAN: double-free in slab_free mm/slub.c:3599 [inline]
> BUG: KASAN: double-free in __kmem_cache_free+0xab/0x3b0 mm/slub.c:3612
> Free of addr ffff88801e642000 by task syz-executor374/3609
> 
> CPU: 0 PID: 3609 Comm: syz-executor374 Not tainted 6.0.0-rc6-next-20220923-syzkaller #0
> Hardware name: Google Google Compute Engine/Google Compute Engine, BIOS Google 08/26/2022
> Call Trace:
>   <TASK>
>   __dump_stack lib/dump_stack.c:88 [inline]
>   dump_stack_lvl+0xcd/0x134 lib/dump_stack.c:106
>   print_address_description mm/kasan/report.c:284 [inline]
>   print_report+0x15e/0x45d mm/kasan/report.c:395
>   kasan_report_invalid_free+0x97/0x1b0 mm/kasan/report.c:460
>   ____kasan_slab_free+0x185/0x1c0 mm/kasan/common.c:225
>   kasan_slab_free include/linux/kasan.h:177 [inline]
>   slab_free_hook mm/slub.c:1669 [inline]
>   slab_free_freelist_hook+0x8b/0x1c0 mm/slub.c:1695
>   slab_free mm/slub.c:3599 [inline]
>   __kmem_cache_free+0xab/0x3b0 mm/slub.c:3612
>   io_clean_op+0x581/0xb10 io_uring/io_uring.c:1699
>   io_free_batch_list+0x46f/0x7e0 io_uring/io_uring.c:1305
>   __io_submit_flush_completions+0x22b/0x2e0 io_uring/io_uring.c:1343
>   io_submit_flush_completions io_uring/io_uring.c:171 [inline]
>   ctx_flush_and_put+0xdf/0x1b0 io_uring/io_uring.c:1003
>   tctx_task_work+0x153/0x4a0 io_uring/io_uring.c:1087
>   task_work_run+0x16b/0x270 kernel/task_work.c:179
>   ptrace_notify+0x114/0x140 kernel/signal.c:2354
>   ptrace_report_syscall include/linux/ptrace.h:420 [inline]
>   ptrace_report_syscall_exit include/linux/ptrace.h:482 [inline]
>   syscall_exit_work kernel/entry/common.c:251 [inline]
>   syscall_exit_to_user_mode_prepare+0x129/0x280 kernel/entry/common.c:278
>   __syscall_exit_to_user_mode_work kernel/entry/common.c:283 [inline]
>   syscall_exit_to_user_mode+0x9/0x50 kernel/entry/common.c:296
>   do_syscall_64+0x42/0xb0 arch/x86/entry/common.c:86
>   entry_SYSCALL_64_after_hwframe+0x63/0xcd
> RIP: 0033:0x7f10ee5d8bb9
> Code: 28 c3 e8 2a 14 00 00 66 2e 0f 1f 84 00 00 00 00 00 48 89 f8 48 89 f7 48 89 d6 48 89 ca 4d 89 c2 4d 89 c8 4c 8b 4c 24 08 0f 05 <48> 3d 01 f0 ff ff 73 01 c3 48 c7 c1 c0 ff ff ff f7 d8 64 89 01 48
> RSP: 002b:00007fff7120f998 EFLAGS: 00000246 ORIG_RAX: 00000000000001aa
> RAX: 00000000000040b2 RBX: 0000000000000003 RCX: 00007f10ee5d8bb9
> RDX: 0000000000000000 RSI: 00000000000040b2 RDI: 0000000000000003
> RBP: 00007f10ee59cd60 R08: 0000000020000000 R09: 0000000000000008
> R10: 0000000000000000 R11: 0000000000000246 R12: 00007f10ee59cdf0
> R13: 0000000000000000 R14: 0000000000000000 R15: 0000000000000000
>   </TASK>
> 
> Allocated by task 3609:
>   kasan_save_stack+0x1e/0x40 mm/kasan/common.c:45
>   kasan_set_track+0x21/0x30 mm/kasan/common.c:52
>   ____kasan_kmalloc mm/kasan/common.c:371 [inline]
>   ____kasan_kmalloc mm/kasan/common.c:330 [inline]
>   __kasan_kmalloc+0xa1/0xb0 mm/kasan/common.c:380
>   kasan_kmalloc include/linux/kasan.h:211 [inline]
>   __do_kmalloc_node mm/slab_common.c:934 [inline]
>   __kmalloc+0x54/0xc0 mm/slab_common.c:947
>   kmalloc include/linux/slab.h:564 [inline]
>   io_alloc_async_data+0x9b/0x160 io_uring/io_uring.c:1590
>   io_msg_alloc_async io_uring/net.c:138 [inline]
>   io_msg_alloc_async_prep io_uring/net.c:147 [inline]
>   io_sendmsg_prep_async+0x19b/0x3c0 io_uring/net.c:221
>   io_req_prep_async+0x1d9/0x300 io_uring/io_uring.c:1613
>   io_submit_sqe io_uring/io_uring.c:2137 [inline]
>   io_submit_sqes+0xfcd/0x1df0 io_uring/io_uring.c:2276
>   __do_sys_io_uring_enter+0xac6/0x2410 io_uring/io_uring.c:3216
>   do_syscall_x64 arch/x86/entry/common.c:50 [inline]
>   do_syscall_64+0x35/0xb0 arch/x86/entry/common.c:80
>   entry_SYSCALL_64_after_hwframe+0x63/0xcd
> 
> Freed by task 3609:
>   kasan_save_stack+0x1e/0x40 mm/kasan/common.c:45
>   kasan_set_track+0x21/0x30 mm/kasan/common.c:52
>   kasan_save_free_info+0x2a/0x40 mm/kasan/generic.c:511
>   ____kasan_slab_free mm/kasan/common.c:236 [inline]
>   ____kasan_slab_free+0x160/0x1c0 mm/kasan/common.c:200
>   kasan_slab_free include/linux/kasan.h:177 [inline]
>   slab_free_hook mm/slub.c:1669 [inline]
>   slab_free_freelist_hook+0x8b/0x1c0 mm/slub.c:1695
>   slab_free mm/slub.c:3599 [inline]
>   __kmem_cache_free+0xab/0x3b0 mm/slub.c:3612
>   io_send_zc_cleanup+0x133/0x180 io_uring/net.c:916
>   io_clean_op+0xf4/0xb10 io_uring/io_uring.c:1684
>   io_free_batch_list+0x46f/0x7e0 io_uring/io_uring.c:1305
>   __io_submit_flush_completions+0x22b/0x2e0 io_uring/io_uring.c:1343
>   io_submit_flush_completions io_uring/io_uring.c:171 [inline]
>   ctx_flush_and_put+0xdf/0x1b0 io_uring/io_uring.c:1003
>   tctx_task_work+0x153/0x4a0 io_uring/io_uring.c:1087
>   task_work_run+0x16b/0x270 kernel/task_work.c:179
>   ptrace_notify+0x114/0x140 kernel/signal.c:2354
>   ptrace_report_syscall include/linux/ptrace.h:420 [inline]
>   ptrace_report_syscall_exit include/linux/ptrace.h:482 [inline]
>   syscall_exit_work kernel/entry/common.c:251 [inline]
>   syscall_exit_to_user_mode_prepare+0x129/0x280 kernel/entry/common.c:278
>   __syscall_exit_to_user_mode_work kernel/entry/common.c:283 [inline]
>   syscall_exit_to_user_mode+0x9/0x50 kernel/entry/common.c:296
>   do_syscall_64+0x42/0xb0 arch/x86/entry/common.c:86
>   entry_SYSCALL_64_after_hwframe+0x63/0xcd
> 
> The buggy address belongs to the object at ffff88801e642000
>   which belongs to the cache kmalloc-512 of size 512
> The buggy address is located 0 bytes inside of
>   512-byte region [ffff88801e642000, ffff88801e642200)
> 
> The buggy address belongs to the physical page:
> page:ffffea0000799000 refcount:1 mapcount:0 mapping:0000000000000000 index:0x0 pfn:0x1e640
> head:ffffea0000799000 order:2 compound_mapcount:0 compound_pincount:0
> flags: 0xfff00000010200(slab|head|node=0|zone=1|lastcpupid=0x7ff)
> raw: 00fff00000010200 ffff888011841c80 dead000000100010 0000000000000000
> raw: 0000000000000000 dead000000000001 00000001ffffffff 0000000000000000
> page dumped because: kasan: bad access detected
> page_owner tracks the page as allocated
> page last allocated via order 2, migratetype Unmovable, gfp_mask 0x52800(GFP_NOWAIT|__GFP_NOWARN|__GFP_NORETRY|__GFP_COMP), pid 1, tgid 1 (swapper/0), ts 7630490778, free_ts 0
>   prep_new_page mm/page_alloc.c:2538 [inline]
>   get_page_from_freelist+0x1092/0x2d20 mm/page_alloc.c:4287
>   __alloc_pages+0x1c7/0x5a0 mm/page_alloc.c:5546
>   alloc_page_interleave+0x1e/0x200 mm/mempolicy.c:2113
>   alloc_pages+0x22f/0x270 mm/mempolicy.c:2275
>   alloc_slab_page mm/slub.c:1739 [inline]
>   allocate_slab+0x213/0x300 mm/slub.c:1884
>   new_slab mm/slub.c:1937 [inline]
>   ___slab_alloc+0xac1/0x1430 mm/slub.c:3119
>   __slab_alloc.constprop.0+0x4d/0xa0 mm/slub.c:3217
>   slab_alloc_node mm/slub.c:3302 [inline]
>   __kmem_cache_alloc_node+0x18a/0x3d0 mm/slub.c:3375
>   kmalloc_node_trace+0x1d/0x60 mm/slab_common.c:1027
>   kmalloc_node include/linux/slab.h:581 [inline]
>   kzalloc_node include/linux/slab.h:706 [inline]
>   iolatency_pd_alloc+0xc1/0x1c0 block/blk-iolatency.c:961
>   blkcg_activate_policy block/blk-cgroup.c:1425 [inline]
>   blkcg_activate_policy+0x1e4/0xba0 block/blk-cgroup.c:1398
>   blk_iolatency_init+0x290/0x5e0 block/blk-iolatency.c:777
>   blkcg_init_queue+0x17d/0x620 block/blk-cgroup.c:1302
>   __alloc_disk_node+0x29d/0x650 block/genhd.c:1366
>   __blk_alloc_disk+0x35/0x90 block/genhd.c:1405
>   brd_alloc.part.0+0x281/0x760 drivers/block/brd.c:391
> page_owner free stack trace missing
> 
> Memory state around the buggy address:
>   ffff88801e641f00: fc fc fc fc fc fc fc fc fc fc fc fc fc fc fc fc
>   ffff88801e641f80: fc fc fc fc fc fc fc fc fc fc fc fc fc fc fc fc
>> ffff88801e642000: fa fb fb fb fb fb fb fb fb fb fb fb fb fb fb fb
>                     ^
>   ffff88801e642080: fb fb fb fb fb fb fb fb fb fb fb fb fb fb fb fb
>   ffff88801e642100: fb fb fb fb fb fb fb fb fb fb fb fb fb fb fb fb
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
> syzbot can test patches for this issue, for details see:
> https://goo.gl/tpsmEJ#testing-patches

-- 
Pavel Begunkov
