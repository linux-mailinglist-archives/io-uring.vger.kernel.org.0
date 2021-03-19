Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 1BE6C341A44
	for <lists+io-uring@lfdr.de>; Fri, 19 Mar 2021 11:43:01 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229469AbhCSKm0 (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Fri, 19 Mar 2021 06:42:26 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:34548 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229634AbhCSKmT (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Fri, 19 Mar 2021 06:42:19 -0400
Received: from mail-wm1-x32b.google.com (mail-wm1-x32b.google.com [IPv6:2a00:1450:4864:20::32b])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 01795C06174A;
        Fri, 19 Mar 2021 03:42:18 -0700 (PDT)
Received: by mail-wm1-x32b.google.com with SMTP id a132-20020a1c668a0000b029010f141fe7c2so4824094wmc.0;
        Fri, 19 Mar 2021 03:42:17 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=subject:to:references:from:autocrypt:message-id:date:user-agent
         :mime-version:in-reply-to:content-language:content-transfer-encoding;
        bh=Q1yaN7e9GPVamcewGzphJ6L/LYG+A5MEt1/nqn4TNow=;
        b=mWQXvFo/3dwwVa9lSp5pdVl4a+o2uryjvhftoZnZ182LSMGZ2HL2bhTQhXQH94aQiE
         OX3gZwX3T4PhT0NaW3g4xALM3efCG++WZF0wjP94sSyyvi9yLvzc8buABZ0tlL1gV/7k
         p41UBwconSw0vukr1OrpRCuhfQy/Z7GCHcxsLZE0GUGiVNuFTcF/++uoauBVmQUQLoXJ
         7dah2TjP8wGPeFy6BM6fP/ReRzONfjKdYeR5xZQ8/IoAIz9CD4YtGRCqgseWkY9zvpgA
         3hDoi/rF799sv308wYWsn68Sr0Sunhn675LWs7LOx4UL1vj+eCDxmydUYcR/Bnl9cQ+s
         KqRQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:references:from:autocrypt:message-id
         :date:user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=Q1yaN7e9GPVamcewGzphJ6L/LYG+A5MEt1/nqn4TNow=;
        b=d2T68aV4TvCksypajt3SH5oRbJKXxX+OyYPqgVxOzLaPg0uJTdNd+us920Hi762J7t
         lrhlQ/5tuD8NNghE8G4i7IGqtQ2vm9xF6Nej6FXJkPa+CN2ekPzybStcvo9xnva7KSMN
         e2qTzcLVS6DztXYT2v8n6KauXOrfUXUD2T+UqorP3somWf7Qas43PmsRIGqifobT5heT
         L8sqWWpBwRZVsHH63ulT9dT+gCecsD82rZVWiwawN6+2AcUfoNbyTe8cVV/3TxsNUReU
         eA0uIJCbPlPOhmAOI/dt0rBKFfeo4C/OSkuGIw8i9Jg/e9GxCkCLxaDPrPqpU1zd0j19
         2xRA==
X-Gm-Message-State: AOAM532QS3MXB4yQYJmyy56GhH5V+3c8K1Q+7WsRXGuBjL2mGTonDTPJ
        ygeJs4/p99k+mMeu+OjR3yY=
X-Google-Smtp-Source: ABdhPJzLxHbyKmKjJ7nQ3knuGoNpyME+MmkAb/6UGWzAsfGJBsVx3/yPq20daa5nc+j8mMxi8wL/JA==
X-Received: by 2002:a05:600c:2301:: with SMTP id 1mr3224466wmo.36.1616150536775;
        Fri, 19 Mar 2021 03:42:16 -0700 (PDT)
Received: from [192.168.8.173] ([185.69.144.156])
        by smtp.gmail.com with ESMTPSA id y16sm7388007wrh.3.2021.03.19.03.42.15
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Fri, 19 Mar 2021 03:42:16 -0700 (PDT)
Subject: Re: KASAN: use-after-free Read in idr_for_each (2)
To:     syzbot <syzbot+12056a09a0311d758e60@syzkaller.appspotmail.com>,
        axboe@kernel.dk, io-uring@vger.kernel.org,
        linux-fsdevel@vger.kernel.org, linux-kernel@vger.kernel.org,
        syzkaller-bugs@googlegroups.com, viro@zeniv.linux.org.uk
References: <000000000000e3ec8005b6bfd042@google.com>
From:   Pavel Begunkov <asml.silence@gmail.com>
Autocrypt: addr=asml.silence@gmail.com; prefer-encrypt=mutual; keydata=
 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 bA==
Message-ID: <cd88eb14-f250-54d1-d36b-7af3917d3bec@gmail.com>
Date:   Fri, 19 Mar 2021 10:38:17 +0000
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.3.0
MIME-Version: 1.0
In-Reply-To: <000000000000e3ec8005b6bfd042@google.com>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org

On 18/12/2020 16:44, syzbot wrote:
> Hello,
> 
> syzbot has tested the proposed patch but the reproducer is still triggering an issue:
> KASAN: use-after-free Read in idr_for_each

#syz test: git://git.kernel.dk/linux-block io_uring-5.12

> 
> ==================================================================
> BUG: KASAN: use-after-free in radix_tree_next_slot include/linux/radix-tree.h:422 [inline]
> BUG: KASAN: use-after-free in idr_for_each+0x206/0x220 lib/idr.c:202
> Read of size 8 at addr ffff888042e76040 by task kworker/u4:5/3340
> 
> CPU: 0 PID: 3340 Comm: kworker/u4:5 Not tainted 5.10.0-syzkaller #0
> Hardware name: Google Google Compute Engine/Google Compute Engine, BIOS Google 01/01/2011
> Workqueue: events_unbound io_ring_exit_work
> Call Trace:
>  __dump_stack lib/dump_stack.c:79 [inline]
>  dump_stack+0x107/0x163 lib/dump_stack.c:120
>  print_address_description.constprop.0.cold+0xae/0x4c8 mm/kasan/report.c:385
>  __kasan_report mm/kasan/report.c:545 [inline]
>  kasan_report.cold+0x1f/0x37 mm/kasan/report.c:562
>  radix_tree_next_slot include/linux/radix-tree.h:422 [inline]
>  idr_for_each+0x206/0x220 lib/idr.c:202
>  io_destroy_buffers fs/io_uring.c:8541 [inline]
>  io_ring_ctx_free fs/io_uring.c:8564 [inline]
>  io_ring_exit_work+0x394/0x730 fs/io_uring.c:8639
>  process_one_work+0x98d/0x1630 kernel/workqueue.c:2275
>  worker_thread+0x64c/0x1120 kernel/workqueue.c:2421
>  kthread+0x3b1/0x4a0 kernel/kthread.c:292
>  ret_from_fork+0x1f/0x30 arch/x86/entry/entry_64.S:296
> 
> Allocated by task 28625:
>  kasan_save_stack+0x1b/0x40 mm/kasan/common.c:48
>  kasan_set_track mm/kasan/common.c:56 [inline]
>  __kasan_kmalloc.constprop.0+0xc2/0xd0 mm/kasan/common.c:461
>  slab_post_alloc_hook mm/slab.h:512 [inline]
>  slab_alloc_node mm/slub.c:2889 [inline]
>  slab_alloc mm/slub.c:2897 [inline]
>  kmem_cache_alloc+0x145/0x350 mm/slub.c:2902
>  radix_tree_node_alloc.constprop.0+0x7c/0x350 lib/radix-tree.c:274
>  idr_get_free+0x554/0xa60 lib/radix-tree.c:1504
>  idr_alloc_u32+0x170/0x2d0 lib/idr.c:46
>  idr_alloc+0xc2/0x130 lib/idr.c:87
>  io_provide_buffers fs/io_uring.c:4230 [inline]
>  io_issue_sqe+0x3681/0x44e0 fs/io_uring.c:6264
>  __io_queue_sqe+0x228/0x1120 fs/io_uring.c:6477
>  io_queue_sqe+0x631/0x10f0 fs/io_uring.c:6543
>  io_submit_sqe fs/io_uring.c:6616 [inline]
>  io_submit_sqes+0x135a/0x2530 fs/io_uring.c:6864
>  __do_sys_io_uring_enter+0x591/0x1c00 fs/io_uring.c:9174
>  do_syscall_64+0x2d/0x70 arch/x86/entry/common.c:46
>  entry_SYSCALL_64_after_hwframe+0x44/0xa9
> 
> Freed by task 8890:
>  kasan_save_stack+0x1b/0x40 mm/kasan/common.c:48
>  kasan_set_track+0x1c/0x30 mm/kasan/common.c:56
>  kasan_set_free_info+0x1b/0x30 mm/kasan/generic.c:352
>  __kasan_slab_free+0x102/0x140 mm/kasan/common.c:422
>  slab_free_hook mm/slub.c:1544 [inline]
>  slab_free_freelist_hook+0x5d/0x150 mm/slub.c:1577
>  slab_free mm/slub.c:3140 [inline]
>  kmem_cache_free+0x82/0x360 mm/slub.c:3156
>  rcu_do_batch kernel/rcu/tree.c:2489 [inline]
>  rcu_core+0x75d/0xf80 kernel/rcu/tree.c:2723
>  __do_softirq+0x2bc/0xa77 kernel/softirq.c:343
> 
> Last potentially related work creation:
>  kasan_save_stack+0x1b/0x40 mm/kasan/common.c:48
>  kasan_record_aux_stack+0xc0/0xf0 mm/kasan/generic.c:343
>  __call_rcu kernel/rcu/tree.c:2965 [inline]
>  call_rcu+0xbb/0x710 kernel/rcu/tree.c:3038
>  radix_tree_node_free lib/radix-tree.c:308 [inline]
>  delete_node+0x591/0x8c0 lib/radix-tree.c:571
>  __radix_tree_delete+0x190/0x370 lib/radix-tree.c:1377
>  radix_tree_delete_item+0xe7/0x230 lib/radix-tree.c:1428
>  __io_remove_buffers fs/io_uring.c:4122 [inline]
>  __io_remove_buffers fs/io_uring.c:4101 [inline]
>  __io_destroy_buffers+0x161/0x200 fs/io_uring.c:8535
>  idr_for_each+0x113/0x220 lib/idr.c:208
>  io_destroy_buffers fs/io_uring.c:8541 [inline]
>  io_ring_ctx_free fs/io_uring.c:8564 [inline]
>  io_ring_exit_work+0x394/0x730 fs/io_uring.c:8639
>  process_one_work+0x98d/0x1630 kernel/workqueue.c:2275
>  worker_thread+0x64c/0x1120 kernel/workqueue.c:2421
>  kthread+0x3b1/0x4a0 kernel/kthread.c:292
>  ret_from_fork+0x1f/0x30 arch/x86/entry/entry_64.S:296
> 
> Second to last potentially related work creation:
>  kasan_save_stack+0x1b/0x40 mm/kasan/common.c:48
>  kasan_record_aux_stack+0xc0/0xf0 mm/kasan/generic.c:343
>  __call_rcu kernel/rcu/tree.c:2965 [inline]
>  call_rcu+0xbb/0x710 kernel/rcu/tree.c:3038
>  xa_node_free lib/xarray.c:258 [inline]
>  xas_delete_node lib/xarray.c:494 [inline]
>  update_node lib/xarray.c:756 [inline]
>  xas_store+0xbeb/0x1c10 lib/xarray.c:841
>  __xa_erase lib/xarray.c:1489 [inline]
>  xa_erase+0xb0/0x170 lib/xarray.c:1510
>  io_uring_del_task_file fs/io_uring.c:8889 [inline]
>  __io_uring_files_cancel+0xdbf/0x1550 fs/io_uring.c:8925
>  io_uring_files_cancel include/linux/io_uring.h:51 [inline]
>  exit_files+0xe4/0x170 fs/file.c:431
>  do_exit+0xb4f/0x2a00 kernel/exit.c:818
>  do_group_exit+0x125/0x310 kernel/exit.c:920
>  get_signal+0x3e9/0x2160 kernel/signal.c:2770
>  arch_do_signal_or_restart+0x2a8/0x1eb0 arch/x86/kernel/signal.c:811
>  handle_signal_work kernel/entry/common.c:147 [inline]
>  exit_to_user_mode_loop kernel/entry/common.c:171 [inline]
>  exit_to_user_mode_prepare+0x124/0x200 kernel/entry/common.c:201
>  __syscall_exit_to_user_mode_work kernel/entry/common.c:291 [inline]
>  syscall_exit_to_user_mode+0x19/0x50 kernel/entry/common.c:302
>  entry_SYSCALL_64_after_hwframe+0x44/0xa9
> 
> The buggy address belongs to the object at ffff888042e76000
>  which belongs to the cache radix_tree_node of size 576
> The buggy address is located 64 bytes inside of
>  576-byte region [ffff888042e76000, ffff888042e76240)
> The buggy address belongs to the page:
> page:0000000090e8be83 refcount:1 mapcount:0 mapping:0000000000000000 index:0x0 pfn:0x42e76
> head:0000000090e8be83 order:1 compound_mapcount:0
> flags: 0xfff00000010200(slab|head)
> raw: 00fff00000010200 dead000000000100 dead000000000122 ffff88801084db40
> raw: ffff888042e76580 00000000800b000a 00000001ffffffff 0000000000000000
> page dumped because: kasan: bad access detected
> 
> Memory state around the buggy address:
>  ffff888042e75f00: fc fc fc fc fc fc fc fc fc fc fc fc fc fc fc fc
>  ffff888042e75f80: fc fc fc fc fc fc fc fc fc fc fc fc fc fc fc fc
>> ffff888042e76000: fa fb fb fb fb fb fb fb fb fb fb fb fb fb fb fb
>                                            ^
>  ffff888042e76080: fb fb fb fb fb fb fb fb fb fb fb fb fb fb fb fb
>  ffff888042e76100: fb fb fb fb fb fb fb fb fb fb fb fb fb fb fb fb
> ==================================================================
> 
> 
> Tested on:
> 
> commit:         dfea9fce io_uring: close a small race gap for files cancel
> git tree:       git://git.kernel.dk/linux-block
> console output: https://syzkaller.appspot.com/x/log.txt?x=1263a46b500000
> kernel config:  https://syzkaller.appspot.com/x/.config?x=4db50a97037d9f3e
> dashboard link: https://syzkaller.appspot.com/bug?extid=12056a09a0311d758e60
> compiler:       gcc (GCC) 10.1.0-syz 20200507
> 

-- 
Pavel Begunkov
