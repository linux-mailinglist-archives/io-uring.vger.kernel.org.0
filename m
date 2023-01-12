Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 2B27466701A
	for <lists+io-uring@lfdr.de>; Thu, 12 Jan 2023 11:46:26 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232249AbjALKqX (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Thu, 12 Jan 2023 05:46:23 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:42618 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229639AbjALKow (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Thu, 12 Jan 2023 05:44:52 -0500
Received: from mail-io1-f70.google.com (mail-io1-f70.google.com [209.85.166.70])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 7A52759330
        for <io-uring@vger.kernel.org>; Thu, 12 Jan 2023 02:39:35 -0800 (PST)
Received: by mail-io1-f70.google.com with SMTP id w12-20020a5e970c000000b0070450f33abbso6118301ioj.14
        for <io-uring@vger.kernel.org>; Thu, 12 Jan 2023 02:39:35 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=cc:to:from:subject:message-id:in-reply-to:date:mime-version
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=oebMrTWRTwPaETfUI1AHbqtvicDCxclysNdcSitLnMs=;
        b=1YXWWz0zjYFh4nDPgmynRJBGyhhqmp+IyPLKNfrbcFT9gJG+xIDbAhoeGEhn1ZGvoS
         c+lgK5x6gnYbD42nsXs1HoyZFYO8ZI4xbjYBcq2kVd9aCItrct4lgHKfdkJ1i2+U8MEM
         7rC8FedMUsd7OhtYnhj0kEReTQUbwWfmXunNbh1ygwxUR8SCSc4M29HpGGpsuMqCBWlb
         0/GWVs69BUpV7Fb1k7hEQmJ13m8fJ4HPlmzK7fn5lAYhOZ9aFXkK8yp0FJUOrYA9G05W
         92ifmyA5Fi+IaSNnclW+OB8SEjY0d6fptfMKhsv56rQyt59vah/OlZCq7Dsfk8/jZCdM
         HSCg==
X-Gm-Message-State: AFqh2kpOuWOtoBum1KE8n0RgMFYn5pn5MrIBJVtYQBzF/gdAmbMrmXSR
        Bs3pE+AhwsepZgqKP3cMNbWHHLbU+7if5wKxN78HV78aD2JA
X-Google-Smtp-Source: AMrXdXtyvYRtIBGdbf8mSs8GfslSzUJSt2R7QIqVqU4uwoJF71MNMtUTnbB7MDiXXQjFBSXDcbTSMlvaObtczV7jhmjIfgPbLSnu
MIME-Version: 1.0
X-Received: by 2002:a92:dc51:0:b0:30d:a94d:d484 with SMTP id
 x17-20020a92dc51000000b0030da94dd484mr1725824ilq.121.1673519974865; Thu, 12
 Jan 2023 02:39:34 -0800 (PST)
Date:   Thu, 12 Jan 2023 02:39:34 -0800
In-Reply-To: <32859f98-6ab9-a4ce-800e-b76f97b97671@gmail.com>
X-Google-Appengine-App-Id: s~syzkaller
X-Google-Appengine-App-Id-Alias: syzkaller
Message-ID: <000000000000a0620d05f20ebbf0@google.com>
Subject: Re: [syzbot] KASAN: use-after-free Read in io_req_caches_free
From:   syzbot <syzbot+131f71f381afff1eaa35@syzkaller.appspotmail.com>
To:     asml.silence@gmail.com
Cc:     asml.silence@gmail.com, axboe@kernel.dk, io-uring@vger.kernel.org,
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

> On 1/12/23 10:26, syzbot wrote:
>> Hello,
>> 
>> syzbot found the following issue on:
>> 
>> HEAD commit:    0a093b2893c7 Add linux-next specific files for 20230112
>> git tree:       linux-next
>> console output: https://syzkaller.appspot.com/x/log.txt?x=1605ee86480000
>> kernel config:  https://syzkaller.appspot.com/x/.config?x=835f3591019836d5
>> dashboard link: https://syzkaller.appspot.com/bug?extid=131f71f381afff1eaa35
>> compiler:       gcc (Debian 10.2.1-6) 10.2.1 20210110, GNU ld (GNU Binutils for Debian) 2.35.2
>> 
>> Unfortunately, I don't have any reproducer for this issue yet.
>
> #syz test: git://git.kernel.dk/linux.git syztest

This crash does not have a reproducer. I cannot test it.

>
>> 
>> Downloadable assets:
>> disk image: https://storage.googleapis.com/syzbot-assets/8111a570d6cb/disk-0a093b28.raw.xz
>> vmlinux: https://storage.googleapis.com/syzbot-assets/ecc135b7fc9a/vmlinux-0a093b28.xz
>> kernel image: https://storage.googleapis.com/syzbot-assets/ca8d73b446ea/bzImage-0a093b28.xz
>> 
>> IMPORTANT: if you fix the issue, please add the following tag to the commit:
>> Reported-by: syzbot+131f71f381afff1eaa35@syzkaller.appspotmail.com
>> 
>> ==================================================================
>> BUG: KASAN: use-after-free in wq_stack_extract io_uring/slist.h:126 [inline]
>> BUG: KASAN: use-after-free in io_alloc_req io_uring/io_uring.h:356 [inline]
>> BUG: KASAN: use-after-free in io_req_caches_free+0x18d/0x1e6 io_uring/io_uring.c:2735
>> Read of size 8 at addr ffff8880263397f8 by task kworker/u4:9/5456
>> 
>> CPU: 0 PID: 5456 Comm: kworker/u4:9 Not tainted 6.2.0-rc3-next-20230112-syzkaller #0
>> Hardware name: Google Google Compute Engine/Google Compute Engine, BIOS Google 10/26/2022
>> Workqueue: events_unbound io_ring_exit_work
>> 
>> Call Trace:
>>   <TASK>
>>   __dump_stack lib/dump_stack.c:88 [inline]
>>   dump_stack_lvl+0xd1/0x138 lib/dump_stack.c:106
>>   print_address_description mm/kasan/report.c:306 [inline]
>>   print_report+0x15e/0x45d mm/kasan/report.c:417
>>   kasan_report+0xc0/0xf0 mm/kasan/report.c:517
>>   wq_stack_extract io_uring/slist.h:126 [inline]
>>   io_alloc_req io_uring/io_uring.h:356 [inline]
>>   io_req_caches_free+0x18d/0x1e6 io_uring/io_uring.c:2735
>>   io_ring_exit_work+0x2e7/0xc80 io_uring/io_uring.c:2967
>>   process_one_work+0x9bf/0x1750 kernel/workqueue.c:2293
>>   worker_thread+0x669/0x1090 kernel/workqueue.c:2440
>>   kthread+0x2e8/0x3a0 kernel/kthread.c:376
>>   ret_from_fork+0x1f/0x30 arch/x86/entry/entry_64.S:308
>>   </TASK>
>> 
>> Allocated by task 6234:
>>   kasan_save_stack+0x22/0x40 mm/kasan/common.c:45
>>   kasan_set_track+0x25/0x30 mm/kasan/common.c:52
>>   __kasan_slab_alloc+0x7f/0x90 mm/kasan/common.c:325
>>   kasan_slab_alloc include/linux/kasan.h:186 [inline]
>>   slab_post_alloc_hook mm/slab.h:769 [inline]
>>   kmem_cache_alloc_bulk+0x3aa/0x730 mm/slub.c:4033
>>   __io_alloc_req_refill+0xcc/0x40b io_uring/io_uring.c:1062
>>   io_alloc_req_refill io_uring/io_uring.h:348 [inline]
>>   io_submit_sqes.cold+0x7c/0xc2 io_uring/io_uring.c:2407
>>   __do_sys_io_uring_enter+0x9e4/0x2c10 io_uring/io_uring.c:3429
>>   do_syscall_x64 arch/x86/entry/common.c:50 [inline]
>>   do_syscall_64+0x39/0xb0 arch/x86/entry/common.c:80
>>   entry_SYSCALL_64_after_hwframe+0x63/0xcd
>> 
>> Freed by task 5456:
>>   kasan_save_stack+0x22/0x40 mm/kasan/common.c:45
>>   kasan_set_track+0x25/0x30 mm/kasan/common.c:52
>>   kasan_save_free_info+0x2e/0x40 mm/kasan/generic.c:518
>>   ____kasan_slab_free mm/kasan/common.c:236 [inline]
>>   ____kasan_slab_free+0x160/0x1c0 mm/kasan/common.c:200
>>   kasan_slab_free include/linux/kasan.h:162 [inline]
>>   slab_free_hook mm/slub.c:1781 [inline]
>>   slab_free_freelist_hook+0x8b/0x1c0 mm/slub.c:1807
>>   slab_free mm/slub.c:3787 [inline]
>>   kmem_cache_free+0xec/0x4e0 mm/slub.c:3809
>>   io_req_caches_free+0x1a9/0x1e6 io_uring/io_uring.c:2737
>>   io_ring_exit_work+0x2e7/0xc80 io_uring/io_uring.c:2967
>>   process_one_work+0x9bf/0x1750 kernel/workqueue.c:2293
>>   worker_thread+0x669/0x1090 kernel/workqueue.c:2440
>>   kthread+0x2e8/0x3a0 kernel/kthread.c:376
>>   ret_from_fork+0x1f/0x30 arch/x86/entry/entry_64.S:308
>> 
>> The buggy address belongs to the object at ffff888026339780
>>   which belongs to the cache io_kiocb of size 216
>> The buggy address is located 120 bytes inside of
>>   216-byte region [ffff888026339780, ffff888026339858)
>> 
>> The buggy address belongs to the physical page:
>> page:ffffea000098ce40 refcount:1 mapcount:0 mapping:0000000000000000 index:0x0 pfn:0x26339
>> memcg:ffff888026d5d401
>> flags: 0xfff00000000200(slab|node=0|zone=1|lastcpupid=0x7ff)
>> raw: 00fff00000000200 ffff8881461f8a00 ffffea0001c18840 0000000000000006
>> raw: 0000000000000000 00000000000c000c 00000001ffffffff ffff888026d5d401
>> page dumped because: kasan: bad access detected
>> page_owner tracks the page as allocated
>> page last allocated via order 0, migratetype Unmovable, gfp_mask 0x112cc0(GFP_USER|__GFP_NOWARN|__GFP_NORETRY), pid 5955, tgid 5954 (syz-executor.2), ts 292007873728, free_ts 283379272604
>>   prep_new_page mm/page_alloc.c:2549 [inline]
>>   get_page_from_freelist+0x11bb/0x2d50 mm/page_alloc.c:4324
>>   __alloc_pages+0x1cb/0x5c0 mm/page_alloc.c:5590
>>   alloc_pages+0x1aa/0x270 mm/mempolicy.c:2281
>>   alloc_slab_page mm/slub.c:1851 [inline]
>>   allocate_slab+0x25f/0x350 mm/slub.c:1998
>>   new_slab mm/slub.c:2051 [inline]
>>   ___slab_alloc+0xa91/0x1400 mm/slub.c:3193
>>   __kmem_cache_alloc_bulk mm/slub.c:3951 [inline]
>>   kmem_cache_alloc_bulk+0x23d/0x730 mm/slub.c:4026
>>   __io_alloc_req_refill+0xcc/0x40b io_uring/io_uring.c:1062
>>   io_alloc_req_refill io_uring/io_uring.h:348 [inline]
>>   io_submit_sqes.cold+0x7c/0xc2 io_uring/io_uring.c:2407
>>   __do_sys_io_uring_enter+0x9e4/0x2c10 io_uring/io_uring.c:3429
>>   do_syscall_x64 arch/x86/entry/common.c:50 [inline]
>>   do_syscall_64+0x39/0xb0 arch/x86/entry/common.c:80
>>   entry_SYSCALL_64_after_hwframe+0x63/0xcd
>> page last free stack trace:
>>   reset_page_owner include/linux/page_owner.h:24 [inline]
>>   free_pages_prepare mm/page_alloc.c:1451 [inline]
>>   free_pcp_prepare+0x4d0/0x910 mm/page_alloc.c:1501
>>   free_unref_page_prepare mm/page_alloc.c:3387 [inline]
>>   free_unref_page+0x1d/0x490 mm/page_alloc.c:3482
>>   relay_destroy_buf+0x121/0x3e0 kernel/relay.c:201
>>   relay_remove_buf kernel/relay.c:221 [inline]
>>   kref_put include/linux/kref.h:65 [inline]
>>   relay_close_buf+0x153/0x1b0 kernel/relay.c:430
>>   relay_close kernel/relay.c:766 [inline]
>>   relay_close+0x3a4/0x590 kernel/relay.c:752
>>   blk_trace_free+0x37/0x190 kernel/trace/blktrace.c:316
>>   blk_trace_cleanup kernel/trace/blktrace.c:384 [inline]
>>   __blk_trace_remove+0x83/0x190 kernel/trace/blktrace.c:397
>>   blk_trace_ioctl+0x24c/0x290 kernel/trace/blktrace.c:760
>>   blkdev_common_ioctl+0x11c7/0x1ba0 block/ioctl.c:536
>>   blkdev_ioctl+0x2c6/0x800 block/ioctl.c:610
>>   vfs_ioctl fs/ioctl.c:51 [inline]
>>   __do_sys_ioctl fs/ioctl.c:870 [inline]
>>   __se_sys_ioctl fs/ioctl.c:856 [inline]
>>   __x64_sys_ioctl+0x197/0x210 fs/ioctl.c:856
>>   do_syscall_x64 arch/x86/entry/common.c:50 [inline]
>>   do_syscall_64+0x39/0xb0 arch/x86/entry/common.c:80
>>   entry_SYSCALL_64_after_hwframe+0x63/0xcd
>> 
>> Memory state around the buggy address:
>>   ffff888026339680: 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00
>>   ffff888026339700: 00 00 00 fc fc fc fc fc fc fc fc fc fc fc fc fc
>>> ffff888026339780: fa fb fb fb fb fb fb fb fb fb fb fb fb fb fb fb
>>                                                                  ^
>>   ffff888026339800: fb fb fb fb fb fb fb fb fb fb fb fc fc fc fc fc
>>   ffff888026339880: fc fc fc fc fc fc fc fc 00 00 00 00 00 00 00 00
>> ==================================================================
>> 
>> 
>> ---
>> This report is generated by a bot. It may contain errors.
>> See https://goo.gl/tpsmEJ for more information about syzbot.
>> syzbot engineers can be reached at syzkaller@googlegroups.com.
>> 
>> syzbot will keep track of this issue. See:
>> https://goo.gl/tpsmEJ#status for how to communicate with syzbot.
>
> -- 
> Pavel Begunkov
