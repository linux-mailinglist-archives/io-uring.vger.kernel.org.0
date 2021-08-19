Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 5DB9B3F1708
	for <lists+io-uring@lfdr.de>; Thu, 19 Aug 2021 12:04:11 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S237700AbhHSKEm (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Thu, 19 Aug 2021 06:04:42 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:37638 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S237743AbhHSKEl (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Thu, 19 Aug 2021 06:04:41 -0400
Received: from mail-wr1-x436.google.com (mail-wr1-x436.google.com [IPv6:2a00:1450:4864:20::436])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 5B276C061575;
        Thu, 19 Aug 2021 03:04:05 -0700 (PDT)
Received: by mail-wr1-x436.google.com with SMTP id v4so8139599wro.12;
        Thu, 19 Aug 2021 03:04:05 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=subject:to:references:from:message-id:date:user-agent:mime-version
         :in-reply-to:content-language:content-transfer-encoding;
        bh=b/caRtf32/S2/reVjg6DZxbLynBG2BkYEYoMEVU2wsU=;
        b=TQ9iY5pmpXThPWON0hCUKYF3EVTMvR7KwC0ROw8P8fvMskjpHGbdi6tWXQo+rOdwXH
         WhcGQeiaOCDuKlgEf1vIjXbu6D4GRRxIs+5QG58LAfl4958qBxjQgjHuJ89+quDKt3In
         pczN25jZfAmQinF9WRMo2TG/YEKv0j0/Mp0t+0OTEhcen7qVey8LdgDtFDeGMvhZnvD2
         /uxapM2vGWSlin3md7AnNXhfuxrMxijJH62WSVW1F2a13ZDVVMS4Cuv8p2apk82xxJOK
         0WBSotM1r+h4R4Xh2Z9lcuB1VpvEf4L8psYcP807MHZA5PcJPUjiRcuCm0QZvM7Jdy0G
         ryDQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=b/caRtf32/S2/reVjg6DZxbLynBG2BkYEYoMEVU2wsU=;
        b=acEyWYYjjfVMmQgDAnnAJejPI48BAKeIye+WSJJpSyXNvM8cQbpyB+DJRwuLuTHTaW
         Kc6xFwe5Olhax7RBaNevBiZat3fUFuPxZIN1f/hMftlmCSK3wY9SqM5q9haAK5GgHOS8
         xP2LMitijNdDp5QWWBzq2M1mo8AVP1Ap1b4JeZhzB7LPc/uolvZBVhWEz5E0YeCup8Fq
         dxzFzvXL+jzrXDy3dlM8YyJzXx0W9sJgGPo+UYkPJqsufV/l1biu98pXq89UaB+Ugl2v
         OtsQ2foBljgUG2blGpC1diM7Q601LX7NIhGx3AM6VThNtYeXMGTsK0wwd4ayNSPkB/k+
         usKA==
X-Gm-Message-State: AOAM533+gZaN7pF43oMTWL9ho8XGsoaUjnemqXCIddDgvRm4mM8oNnRY
        mRLzorXAHywuQWTSYy9nR7M=
X-Google-Smtp-Source: ABdhPJxgsKEje8USaQPTlDcDYdO8wbVrthpYmO4v53wvoPZ6n7eg93vD6T1dkkv4TkLfHTxUNZ3wmg==
X-Received: by 2002:adf:ab0e:: with SMTP id q14mr2802735wrc.171.1629367443969;
        Thu, 19 Aug 2021 03:04:03 -0700 (PDT)
Received: from [192.168.8.197] ([185.69.145.21])
        by smtp.gmail.com with ESMTPSA id n3sm6766119wms.2.2021.08.19.03.04.03
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Thu, 19 Aug 2021 03:04:03 -0700 (PDT)
Subject: Re: [syzbot] KASAN: use-after-free Read in tctx_task_work (2)
To:     syzbot <syzbot+9c3492b27d10dc49ffa6@syzkaller.appspotmail.com>,
        axboe@kernel.dk, io-uring@vger.kernel.org,
        linux-kernel@vger.kernel.org, syzkaller-bugs@googlegroups.com
References: <000000000000e1a5d005c9e514ed@google.com>
From:   Pavel Begunkov <asml.silence@gmail.com>
Message-ID: <858d47f0-48d5-fff5-24bb-346ebde4e127@gmail.com>
Date:   Thu, 19 Aug 2021 11:03:33 +0100
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:78.0) Gecko/20100101
 Thunderbird/78.12.0
MIME-Version: 1.0
In-Reply-To: <000000000000e1a5d005c9e514ed@google.com>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org

On 8/19/21 9:10 AM, syzbot wrote:
> Hello,
> 
> syzbot found the following issue on:
> 
> HEAD commit:    f26c3abc432a Add linux-next specific files for 20210818
> git tree:       linux-next
> console output: https://syzkaller.appspot.com/x/log.txt?x=169f1731300000
> kernel config:  https://syzkaller.appspot.com/x/.config?x=d472f8be79a62b44
> dashboard link: https://syzkaller.appspot.com/bug?extid=9c3492b27d10dc49ffa6
> compiler:       gcc (Debian 10.2.1-6) 10.2.1 20210110, GNU ld (GNU Binutils for Debian) 2.35.1
> syz repro:      https://syzkaller.appspot.com/x/repro.syz?x=15f35e16300000
> C reproducer:   https://syzkaller.appspot.com/x/repro.c?x=161c1765300000
> 
> IMPORTANT: if you fix the issue, please add the following tag to the commit:
> Reported-by: syzbot+9c3492b27d10dc49ffa6@syzkaller.appspotmail.com

Can't find f26c3abc432a nor reproduce it. Let's try the latest branch.

#syz test: git://git.kernel.dk/linux-block for-5.15/io_uring


> ==================================================================
> BUG: KASAN: use-after-free in ctx_flush_and_put fs/io_uring.c:2031 [inline]
> BUG: KASAN: use-after-free in tctx_task_work+0x307/0x310 fs/io_uring.c:2078
> Read of size 4 at addr ffff88801da62358 by task syz-executor959/7251
> 
> CPU: 0 PID: 7251 Comm: syz-executor959 Not tainted 5.14.0-rc6-next-20210818-syzkaller #0
> Hardware name: Google Google Compute Engine/Google Compute Engine, BIOS Google 01/01/2011
> Call Trace:
>  __dump_stack lib/dump_stack.c:88 [inline]
>  dump_stack_lvl+0xcd/0x134 lib/dump_stack.c:106
>  print_address_description.constprop.0.cold+0x6c/0x309 mm/kasan/report.c:256
>  __kasan_report mm/kasan/report.c:442 [inline]
>  kasan_report.cold+0x83/0xdf mm/kasan/report.c:459
>  ctx_flush_and_put fs/io_uring.c:2031 [inline]
>  tctx_task_work+0x307/0x310 fs/io_uring.c:2078
>  task_work_run+0xdd/0x1a0 kernel/task_work.c:164
>  exit_task_work include/linux/task_work.h:32 [inline]
>  do_exit+0xbae/0x2a30 kernel/exit.c:825
>  do_group_exit+0x129/0x310 kernel/exit.c:922
>  get_signal+0x482/0x2170 kernel/signal.c:2846
>  arch_do_signal_or_restart+0x2a9/0x1c40 arch/x86/kernel/signal.c:865
>  handle_signal_work kernel/entry/common.c:148 [inline]
>  exit_to_user_mode_loop kernel/entry/common.c:172 [inline]
>  exit_to_user_mode_prepare+0x17d/0x290 kernel/entry/common.c:209
>  __syscall_exit_to_user_mode_work kernel/entry/common.c:291 [inline]
>  syscall_exit_to_user_mode+0x19/0x60 kernel/entry/common.c:302
>  do_syscall_64+0x46/0xb0 arch/x86/entry/common.c:86
>  entry_SYSCALL_64_after_hwframe+0x44/0xae
> RIP: 0033:0x446749
> Code: Unable to access opcode bytes at RIP 0x44671f.
> RSP: 002b:00007f2e177871e8 EFLAGS: 00000246 ORIG_RAX: 00000000000001aa
> RAX: 000000000000039b RBX: 00000000004cb468 RCX: 0000000000446749
> RDX: 0000000000000000 RSI: 0000000000006b46 RDI: 0000000000000006
> RBP: 00000000004cb460 R08: 0000000000000000 R09: 0000000000000000
> R10: 0000000000000000 R11: 0000000000000246 R12: 00000000004cb46c
> R13: 00007ffe292df50f R14: 00007f2e17787300 R15: 0000000000022000
> 
> Allocated by task 7251:
>  kasan_save_stack+0x1b/0x40 mm/kasan/common.c:38
>  kasan_set_track mm/kasan/common.c:46 [inline]
>  set_alloc_info mm/kasan/common.c:434 [inline]
>  ____kasan_kmalloc mm/kasan/common.c:513 [inline]
>  ____kasan_kmalloc mm/kasan/common.c:472 [inline]
>  __kasan_kmalloc+0x9f/0xd0 mm/kasan/common.c:522
>  kmalloc include/linux/slab.h:591 [inline]
>  kzalloc include/linux/slab.h:721 [inline]
>  io_ring_ctx_alloc fs/io_uring.c:1235 [inline]
>  io_uring_create fs/io_uring.c:9876 [inline]
>  io_uring_setup+0x27d/0x2d00 fs/io_uring.c:9982
>  do_syscall_x64 arch/x86/entry/common.c:50 [inline]
>  do_syscall_64+0x39/0xb0 arch/x86/entry/common.c:80
>  entry_SYSCALL_64_after_hwframe+0x44/0xae
> 
> Freed by task 6731:
>  kasan_save_stack+0x1b/0x40 mm/kasan/common.c:38
>  kasan_set_track+0x1c/0x30 mm/kasan/common.c:46
>  kasan_set_free_info+0x20/0x30 mm/kasan/generic.c:360
>  ____kasan_slab_free mm/kasan/common.c:366 [inline]
>  ____kasan_slab_free mm/kasan/common.c:328 [inline]
>  __kasan_slab_free+0xff/0x140 mm/kasan/common.c:374
>  kasan_slab_free include/linux/kasan.h:230 [inline]
>  slab_free_hook mm/slub.c:1681 [inline]
>  slab_free_freelist_hook+0x82/0x190 mm/slub.c:1706
>  slab_free mm/slub.c:3463 [inline]
>  kfree+0xea/0x540 mm/slub.c:4523
>  io_ring_ctx_free fs/io_uring.c:8902 [inline]
>  io_ring_exit_work+0x13c7/0x1940 fs/io_uring.c:9051
>  process_one_work+0x9c9/0x16b0 kernel/workqueue.c:2297
>  worker_thread+0x65b/0x1200 kernel/workqueue.c:2444
>  kthread+0x3e5/0x4d0 kernel/kthread.c:319
>  ret_from_fork+0x1f/0x30 arch/x86/entry/entry_64.S:295
> 
> Last potentially related work creation:
>  kasan_save_stack+0x1b/0x40 mm/kasan/common.c:38
>  kasan_record_aux_stack+0xe9/0x110 mm/kasan/generic.c:348
>  insert_work+0x48/0x370 kernel/workqueue.c:1353
>  __queue_work+0x5d1/0xf30 kernel/workqueue.c:1519
>  queue_work_on+0xf6/0x110 kernel/workqueue.c:1546
>  queue_work include/linux/workqueue.h:502 [inline]
>  io_ring_ctx_wait_and_kill+0x314/0x3d0 fs/io_uring.c:9104
>  io_uring_release+0x3e/0x50 fs/io_uring.c:9112
>  __fput+0x288/0x9f0 fs/file_table.c:280
>  task_work_run+0xdd/0x1a0 kernel/task_work.c:164
>  exit_task_work include/linux/task_work.h:32 [inline]
>  do_exit+0xbae/0x2a30 kernel/exit.c:825
>  do_group_exit+0x129/0x310 kernel/exit.c:922
>  get_signal+0x482/0x2170 kernel/signal.c:2846
>  arch_do_signal_or_restart+0x2a9/0x1c40 arch/x86/kernel/signal.c:865
>  handle_signal_work kernel/entry/common.c:148 [inline]
>  exit_to_user_mode_loop kernel/entry/common.c:172 [inline]
>  exit_to_user_mode_prepare+0x17d/0x290 kernel/entry/common.c:209
>  __syscall_exit_to_user_mode_work kernel/entry/common.c:291 [inline]
>  syscall_exit_to_user_mode+0x19/0x60 kernel/entry/common.c:302
>  do_syscall_64+0x46/0xb0 arch/x86/entry/common.c:86
>  entry_SYSCALL_64_after_hwframe+0x44/0xae
> 
> The buggy address belongs to the object at ffff88801da62000
>  which belongs to the cache kmalloc-4k of size 4096
> The buggy address is located 856 bytes inside of
>  4096-byte region [ffff88801da62000, ffff88801da63000)
> The buggy address belongs to the page:
> page:ffffea0000769800 refcount:1 mapcount:0 mapping:0000000000000000 index:0x0 pfn:0x1da60
> head:ffffea0000769800 order:3 compound_mapcount:0 compound_pincount:0
> flags: 0xfff00000010200(slab|head|node=0|zone=1|lastcpupid=0x7ff)
> raw: 00fff00000010200 dead000000000100 dead000000000122 ffff888010c42140
> raw: 0000000000000000 0000000000040004 00000001ffffffff 0000000000000000
> page dumped because: kasan: bad access detected
> page_owner tracks the page as allocated
> page last allocated via order 3, migratetype Unmovable, gfp_mask 0xd20c0(__GFP_IO|__GFP_FS|__GFP_NOWARN|__GFP_NORETRY|__GFP_COMP|__GFP_NOMEMALLOC), pid 254, ts 8722226076, free_ts 8721850730
>  prep_new_page mm/page_alloc.c:2424 [inline]
>  get_page_from_freelist+0xa76/0x2f90 mm/page_alloc.c:4151
>  __alloc_pages+0x1ba/0x510 mm/page_alloc.c:5373
>  alloc_pages+0x1a7/0x300 mm/mempolicy.c:2188
>  alloc_slab_page mm/slub.c:1744 [inline]
>  allocate_slab mm/slub.c:1881 [inline]
>  new_slab+0x321/0x490 mm/slub.c:1944
>  ___slab_alloc+0x90b/0xfb0 mm/slub.c:2974
>  __slab_alloc.constprop.0+0x51/0xa0 mm/slub.c:3061
>  slab_alloc_node mm/slub.c:3152 [inline]
>  slab_alloc mm/slub.c:3194 [inline]
>  kmem_cache_alloc_trace+0x30a/0x3c0 mm/slub.c:3211
>  kmalloc include/linux/slab.h:591 [inline]
>  kzalloc include/linux/slab.h:721 [inline]
>  kobject_uevent_env+0x240/0x1650 lib/kobject_uevent.c:524
>  device_add+0xbc6/0x21b0 drivers/base/core.c:3340
>  scsi_target_add drivers/scsi/scsi_sysfs.c:1309 [inline]
>  scsi_sysfs_add_sdev+0x464/0x750 drivers/scsi/scsi_sysfs.c:1336
>  scsi_sysfs_add_devices drivers/scsi/scsi_scan.c:1727 [inline]
>  scsi_finish_async_scan drivers/scsi/scsi_scan.c:1812 [inline]
>  do_scan_async+0x211/0x500 drivers/scsi/scsi_scan.c:1855
>  async_run_entry_fn+0x9d/0x550 kernel/async.c:127
>  process_one_work+0x9c9/0x16b0 kernel/workqueue.c:2297
>  worker_thread+0x65b/0x1200 kernel/workqueue.c:2444
>  kthread+0x3e5/0x4d0 kernel/kthread.c:319
>  ret_from_fork+0x1f/0x30 arch/x86/entry/entry_64.S:295
> page last free stack trace:
>  reset_page_owner include/linux/page_owner.h:24 [inline]
>  free_pages_prepare mm/page_alloc.c:1338 [inline]
>  free_pcp_prepare+0x377/0x860 mm/page_alloc.c:1389
>  free_unref_page_prepare mm/page_alloc.c:3315 [inline]
>  free_unref_page+0x19/0x690 mm/page_alloc.c:3394
>  sbitmap_free include/linux/sbitmap.h:165 [inline]
>  scsi_device_dev_release_usercontext+0x65a/0xd60 drivers/scsi/scsi_sysfs.c:479
>  execute_in_process_context+0x37/0x160 kernel/workqueue.c:3358
>  device_release+0xa3/0x240 drivers/base/core.c:2195
>  kobject_cleanup lib/kobject.c:705 [inline]
>  kobject_release lib/kobject.c:736 [inline]
>  kref_put include/linux/kref.h:65 [inline]
>  kobject_put+0x1d0/0x540 lib/kobject.c:753
>  put_device+0x1b/0x30 drivers/base/core.c:3466
>  __scsi_remove_device+0x1e1/0x3e0 drivers/scsi/scsi_sysfs.c:1477
>  scsi_probe_and_add_lun+0x266d/0x35a0 drivers/scsi/scsi_scan.c:1205
>  __scsi_scan_target+0x229/0xdc0 drivers/scsi/scsi_scan.c:1588
>  scsi_scan_channel drivers/scsi/scsi_scan.c:1676 [inline]
>  scsi_scan_channel+0x148/0x1e0 drivers/scsi/scsi_scan.c:1652
>  scsi_scan_host_selected+0x2df/0x3b0 drivers/scsi/scsi_scan.c:1705
>  do_scsi_scan_host+0x1eb/0x260 drivers/scsi/scsi_scan.c:1844
>  do_scan_async+0x3e/0x500 drivers/scsi/scsi_scan.c:1854
>  async_run_entry_fn+0x9d/0x550 kernel/async.c:127
>  process_one_work+0x9c9/0x16b0 kernel/workqueue.c:2297
> 
> Memory state around the buggy address:
>  ffff88801da62200: fb fb fb fb fb fb fb fb fb fb fb fb fb fb fb fb
>  ffff88801da62280: fb fb fb fb fb fb fb fb fb fb fb fb fb fb fb fb
>> ffff88801da62300: fb fb fb fb fb fb fb fb fb fb fb fb fb fb fb fb
>                                                     ^
>  ffff88801da62380: fb fb fb fb fb fb fb fb fb fb fb fb fb fb fb fb
>  ffff88801da62400: fb fb fb fb fb fb fb fb fb fb fb fb fb fb fb fb
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
> 

-- 
Pavel Begunkov
