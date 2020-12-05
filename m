Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id CB5952CFDE0
	for <lists+io-uring@lfdr.de>; Sat,  5 Dec 2020 19:53:53 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726396AbgLESpb (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Sat, 5 Dec 2020 13:45:31 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:54516 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726610AbgLEQsV (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Sat, 5 Dec 2020 11:48:21 -0500
Received: from mail-wm1-x341.google.com (mail-wm1-x341.google.com [IPv6:2a00:1450:4864:20::341])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 2550CC02B8FB
        for <io-uring@vger.kernel.org>; Sat,  5 Dec 2020 08:19:57 -0800 (PST)
Received: by mail-wm1-x341.google.com with SMTP id a6so7911533wmc.2
        for <io-uring@vger.kernel.org>; Sat, 05 Dec 2020 08:19:57 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=to:cc:references:from:autocrypt:subject:message-id:date:user-agent
         :mime-version:in-reply-to:content-language:content-transfer-encoding;
        bh=jfiHndyVZ3VqQM2qfUSVXQYPX3px8cg6qNZOQnIKKxA=;
        b=jhoa0lIqKb9K6rLN0xXVmc/WvNH/PsDqMLRsgy/mf1k2zcqq4Of2VtY45+DLDV9tPP
         HoKDbngb/7CKVkYEmOmG24CAjcwdOexBtb8kLGFWIMVH5WxSEl5tqhLe0mCJxdQVZoRF
         V5CLmzt6ANDkedpqMGGu4K19aQd1Yh96QWOxLp3agYkBiITbKVSeD1XSKGhdHb2IVgPi
         Y1nG4ZZHZNk7InKR7Sw0xqJOC2wKKqYyICAE0UsbSZqMkDJCyxJcYHYvUrJspmCW1Z9s
         f6+gDPyKZdbU8UpId1usD+vsYDPAA6WrtO9IwOcwp08QqDkBvjFcPZVIXoMUbOHLARmQ
         KtNw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:to:cc:references:from:autocrypt:subject
         :message-id:date:user-agent:mime-version:in-reply-to
         :content-language:content-transfer-encoding;
        bh=jfiHndyVZ3VqQM2qfUSVXQYPX3px8cg6qNZOQnIKKxA=;
        b=gmmyGFr3Gm+/I+Lmawxt6SHfxE787X7NRcgcEBxfUthltDUhW8ITIu4KIgFdY2XEgT
         WUDVCxFr9WPZ2pC8zn6aJSL9rN3ulOSy47OGC2aUWQanvi4umIrBUwOe0WT8M9FcNT9p
         M/PPvjgnfDZupApPiC6e8WdV402fwVFvZ6+4/s0UwxxStHBogKdbLYgMI/yueF1TXG5L
         iDOCQ6ncjQcImvZeRw5dgybrltNFvfEpSzjMZ90hHqqgYhuAYT6q8s7pswHCXI5YeXEK
         w42GAA+la7YUqjggU4nLdZPd9alR+WBqQMfRNTMn3Zy/IoqTBcqw2jrB55d26Usw+QsW
         IW+g==
X-Gm-Message-State: AOAM530cPt1ulld2xWO0yHfIECBRAjElXrSRQsSj0hOt8eYwVnEtLFrE
        r1gj0vs7P545yZ6vY0mHTtDLsmr7mZWDqA==
X-Google-Smtp-Source: ABdhPJyfseBqgPe8nt+GKmraHw+6oNqsaTd6QBH1L7Uqxsh4UiBGHW/CA744Lv7/7LtBbtRiFrGs9w==
X-Received: by 2002:a1c:1fc2:: with SMTP id f185mr10137027wmf.134.1607185195618;
        Sat, 05 Dec 2020 08:19:55 -0800 (PST)
Received: from [192.168.8.100] ([185.69.145.45])
        by smtp.gmail.com with ESMTPSA id i16sm8295697wru.92.2020.12.05.08.19.54
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Sat, 05 Dec 2020 08:19:55 -0800 (PST)
To:     Joseph Qi <joseph.qi@linux.alibaba.com>,
        Xiaoguang Wang <xiaoguang.wang@linux.alibaba.com>,
        io-uring@vger.kernel.org
Cc:     axboe@kernel.dk
References: <20201202113151.1680-1-xiaoguang.wang@linux.alibaba.com>
 <32e75a1d-4e53-e096-7368-9614174db1e5@linux.alibaba.com>
 <c29edc14-01f1-08a8-6b7a-fbf87a43b866@gmail.com>
 <afe74b24-01ad-4e73-42b4-a004057c464f@linux.alibaba.com>
From:   Pavel Begunkov <asml.silence@gmail.com>
Autocrypt: addr=asml.silence@gmail.com; prefer-encrypt=mutual; keydata=
 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 bA==
Subject: Re: [PATCH] io_uring: always let io_iopoll_complete() complete polled
 io.
Message-ID: <8b23f892-ae86-675d-3d57-bed2cf753df3@gmail.com>
Date:   Sat, 5 Dec 2020 16:16:39 +0000
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.3.0
MIME-Version: 1.0
In-Reply-To: <afe74b24-01ad-4e73-42b4-a004057c464f@linux.alibaba.com>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org

On 05/12/2020 12:32, Joseph Qi wrote:
> On 12/5/20 4:31 AM, Pavel Begunkov wrote:
>> On 03/12/2020 02:30, Joseph Qi wrote:
>>> This patch can also fix another BUG I'm looking at:
>>>
>>> [   61.359713] BUG: KASAN: double-free or invalid-free in io_dismantle_req+0x938/0xf40
>>> ...
>>> [   61.409315] refcount_t: underflow; use-after-free.
>>> [   61.410261] WARNING: CPU: 1 PID: 1022 at lib/refcount.c:28 refcount_warn_saturate+0x266/0x2a0
>>> ...
>>>
>>> It blames io_put_identity() has been called more than once and then
>>> identity->count is underflow.
>>
>> Joseph, regarding your double-free
>> 1. did you figure out how exactly this happens?
> From the a little deep analysis, it looks like it caused by a corrupted
> identity->count. Sorry for the misleading before.
> 
>> 2. is it appears consistently so you can be sure that it's fixed> 3. do you have a reproducer?
> 
> Yes, it's a syzkaller C reproducer. It can be reproduced every
> time before applying this patch.
> Attached please find the defails.

Perfect, thanks. It's important to understand for what's really happening,
so I can find similar problems or make it more resilient.

If that's one of those recent syzkaller reports posted to
io-uring@vger.kernel.org, please reply to it so we can keep track
on what is fixed.

> 
>> 4. can you paste a full log of this BUG? (not cutting the stacktrace)
>>
> 
> [   61.358485] ==================================================================
> [   61.359713] BUG: KASAN: double-free or invalid-free in io_dismantle_req+0x938/0xf40
> [   61.360820]
> [   61.361096] CPU: 0 PID: 1022 Comm: io_wqe_worker-0 Not tainted 5.10.0-rc5+ #1
> [   61.362079] Hardware name: Red Hat KVM, BIOS 0.5.1 01/01/2011
> [   61.362904] Call Trace:
> [   61.363370]  dump_stack+0x107/0x163
> [   61.363914]  ? io_dismantle_req+0x938/0xf40
> [   61.364584]  print_address_description.constprop.0+0x3e/0x60
> [   61.365583]  ? vprintk_func+0x98/0x140
> [   61.366246]  ? io_dismantle_req+0x938/0xf40
> [   61.366940]  ? io_dismantle_req+0x938/0xf40
> [   61.367643]  kasan_report_invalid_free+0x51/0x80
> [   61.368428]  ? io_dismantle_req+0x938/0xf40
> [   61.369192]  __kasan_slab_free+0x141/0x160
> [   61.369904]  kfree+0xd1/0x390
> [   61.370526]  io_dismantle_req+0x938/0xf40
> [   61.371199]  __io_free_req+0x95/0x5b0
> [   61.371823]  io_put_req+0x77/0xa0
> [   61.372386]  io_worker_handle_work+0xef3/0x1c00
> [   61.373130]  io_wqe_worker+0xc94/0x11a0
> [   61.373782]  ? io_worker_handle_work+0x1c00/0x1c00
> [   61.374579]  ? __kthread_parkme+0x11d/0x1d0
> [   61.375244]  ? io_worker_handle_work+0x1c00/0x1c00
> [   61.375968]  ? io_worker_handle_work+0x1c00/0x1c00
> [   61.376705]  kthread+0x396/0x470
> [   61.377271]  ? _raw_spin_unlock_irq+0x24/0x30
> [   61.377965]  ? kthread_mod_delayed_work+0x180/0x180
> [   61.378780]  ret_from_fork+0x22/0x30
> [   61.379457]
> [   61.379794] Allocated by task 1023:
> [   61.380413]  kasan_save_stack+0x1b/0x40
> [   61.381048]  __kasan_kmalloc.constprop.0+0xc2/0xd0
> [   61.381798]  kmem_cache_alloc_trace+0x17b/0x310
> [   61.382459]  io_uring_alloc_task_context+0x48/0x2b0
> [   61.383217]  io_uring_add_task_file+0x1f2/0x290
> [   61.383916]  io_uring_create+0x1745/0x2500
> [   61.384582]  io_uring_setup+0xbf/0x110
> [   61.385197]  do_syscall_64+0x33/0x40
> [   61.385797]  entry_SYSCALL_64_after_hwframe+0x44/0xa9
> [   61.386580]
> [   61.386905] The buggy address belongs to the object at ffff8881091d0800
> [   61.386905]  which belongs to the cache kmalloc-512 of size 512
> [   61.388735] The buggy address is located 264 bytes inside of
> [   61.388735]  512-byte region [ffff8881091d0800, ffff8881091d0a00)
> [   61.390398] The buggy address belongs to the page:
> [   61.391107] page:00000000f5dbd49a refcount:1 mapcount:0 mapping:0000000000000000 index:0x0 pfn:0x1091d0
> [   61.392496] head:00000000f5dbd49a order:2 compound_mapcount:0 compound_pincount:0
> [   61.393642] flags: 0x17fffc00010200(slab|head)
> [   61.394341] raw: 0017fffc00010200 dead000000000100 dead000000000122 ffff888100041280
> [   61.395436] raw: 0000000000000000 0000000080100010 00000001ffffffff ffff888100bf0301
> [   61.396571] page dumped because: kasan: bad access detected
> [   61.397432] page->mem_cgroup:ffff888100bf0301
> [   61.398123]
> [   61.398443] Memory state around the buggy address:
> [   61.399217]  ffff8881091d0800: 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00
> [   61.400382]  ffff8881091d0880: 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00
> [   61.401549] >ffff8881091d0900: 00 00 00 00 00 00 00 00 00 00 00 00 fc fc fc fc
> [   61.402654]                       ^
> [   61.403232]  ffff8881091d0980: fc fc fc fc fc fc fc fc fc fc fc fc fc fc fc fc
> [   61.404343]  ffff8881091d0a00: fc fc fc fc fc fc fc fc fc fc fc fc fc fc fc fc
> [   61.405506] ==================================================================
> [   61.406619] Disabling lock debugging due to kernel taint
> [   61.408513] ------------[ cut here ]------------
> [   61.409315] refcount_t: underflow; use-after-free.
> [   61.410261] WARNING: CPU: 1 PID: 1022 at lib/refcount.c:28 refcount_warn_saturate+0x266/0x2a0
> [   61.411489] Modules linked in:
> [   61.411989] CPU: 1 PID: 1022 Comm: io_wqe_worker-0 Tainted: G    B             5.10.0-rc5+ #1
> [   61.413202] Hardware name: Red Hat KVM, BIOS 0.5.1 01/01/2011
> [   61.414026] RIP: 0010:refcount_warn_saturate+0x266/0x2a0
> [   61.415488] Code: 01 31 ff 89 de e8 4a bc 34 ff 84 db 0f 85 bb fe ff ff e8 dd ba 34 ff 48 c7 c7 00 54 c7 83 c6 05 c2 b2 20 03 01 e8 40 56 22 01 <0f> 0b e9 9c fe ff ff 48 89 ef e8 2b 1d 77 ff e9 c9 fd ff ff e8 b1
> [   61.418943] RSP: 0018:ffff88810e467c98 EFLAGS: 00010286
> [   61.420053] RAX: 0000000000000000 RBX: 0000000000000000 RCX: 0000000000000000
> [   61.421434] RDX: 0000000000000000 RSI: ffffffff81348588 RDI: ffffed1021c8cf89
> [   61.422871] RBP: ffff8881091d0948 R08: ffff88810a4e2240 R09: ffffed1023466048
> [   61.424551] R10: ffff88811a33023b R11: ffffed1023466047 R12: ffff8881091d0908
> [   61.425955] R13: ffff8881090e30c8 R14: ffff8881091d0948 R15: ffff8881049b3300
> [   61.427361] FS:  0000000000000000(0000) GS:ffff88811a300000(0000) knlGS:0000000000000000
> [   61.428920] CS:  0010 DS: 0000 ES: 0000 CR0: 0000000080050033
> [   61.430036] CR2: 00007ff46b29eef8 CR3: 000000010df64004 CR4: 00000000003706e0
> [   61.431380] DR0: 0000000000000000 DR1: 0000000000000000 DR2: 0000000000000000
> [   61.432794] DR3: 0000000000000000 DR6: 00000000fffe0ff0 DR7: 0000000000000400
> [   61.434178] Call Trace:
> [   61.434797]  io_dismantle_req+0x907/0xf40
> [   61.435676]  __io_free_req+0x95/0x5b0
> [   61.436408]  io_put_req+0x77/0xa0
> [   61.437141]  io_worker_handle_work+0xef3/0x1c00
> [   61.438073]  io_wqe_worker+0xc94/0x11a0
> [   61.438868]  ? io_worker_handle_work+0x1c00/0x1c00
> [   61.439862]  ? __kthread_parkme+0x11d/0x1d0
> [   61.440767]  ? io_worker_handle_work+0x1c00/0x1c00
> [   61.441760]  ? io_worker_handle_work+0x1c00/0x1c00
> [   61.442766]  kthread+0x396/0x470
> [   61.443491]  ? _raw_spin_unlock_irq+0x24/0x30
> [   61.444348]  ? kthread_mod_delayed_work+0x180/0x180
> [   61.445325]  ret_from_fork+0x22/0x30
> [   61.446118] irq event stamp: 38
> [   61.446867] hardirqs last  enabled at (37): [<ffffffff818e95d7>] kfree+0x1c7/0x390
> [   61.448351] hardirqs last disabled at (38): [<ffffffff834976e0>] _raw_spin_lock_irqsave+0x50/0x60
> [   61.449826] softirqs last  enabled at (0): [<ffffffff811a5989>] copy_process+0x18a9/0x67d0
> [   61.450930] softirqs last disabled at (0): [<0000000000000000>] 0x0
> [   61.451756] ---[ end trace 67489de2f872e2d0 ]---
> [   61.498486] audit: type=1326 audit(1606805588.425:5): auid=0 uid=0 gid=0 ses=1 pid=1027 comm="a.out" exe="/root/a.out" sig=31 arch=c000003e syscall=202 compat=0 ip=0x7ff46abfc239 code=0x0
> [   61.503570] ------------[ cut here ]------------
> [   61.504505] WARNING: CPU: 0 PID: 725 at fs/io_uring.c:7769 __io_uring_free+0x179/0x1e0
> [   61.506114] Modules linked in:
> [   61.506869] CPU: 0 PID: 725 Comm: kworker/u4:3 Tainted: G    B   W         5.10.0-rc5+ #1
> [   61.508567] Hardware name: Red Hat KVM, BIOS 0.5.1 01/01/2011
> [   61.509774] Workqueue: events_unbound io_ring_exit_work
> [   61.510863] RIP: 0010:__io_uring_free+0x179/0x1e0
> [   61.511979] Code: 00 00 fc ff df 48 c1 ea 03 80 3c 02 00 75 6c 48 c7 83 b0 07 00 00 00 00 00 00 5b 5d 41 5c 41 5d 41 5e 41 5f c3 e8 37 96 9a ff <0f> 0b e9 6e ff ff ff e8 2b 96 9a ff 0f 0b e9 de fe ff ff 4c 89 e7
> [   61.515559] RSP: 0018:ffff888109b17cb0 EFLAGS: 00010293
> [   61.516733] RAX: ffff888108fa2240 RBX: ffff888100f04480 RCX: ffffffff81b22c24
> [   61.518237] RDX: 0000000000000000 RSI: ffffffff81b22cb9 RDI: 0000000000000005
> [   61.519635] RBP: ffff8881091d0800 R08: ffff888108fa2240 R09: ffffed102123a12a
> [   61.521169] R10: ffff8881091d094b R11: ffffed102123a129 R12: 00000000c0000000
> [   61.522662] R13: ffff888100f04c30 R14: ffff8881091d0950 R15: ffff8881091d0908
> [   61.523840] FS:  0000000000000000(0000) GS:ffff88811a200000(0000) knlGS:0000000000000000
> [   61.525130] CS:  0010 DS: 0000 ES: 0000 CR0: 0000000080050033
> [   61.526063] CR2: 00007f05a8ecbfc0 CR3: 0000000108f80001 CR4: 00000000003706f0
> [   61.527285] DR0: 0000000000000000 DR1: 0000000000000000 DR2: 0000000000000000
> [   61.528435] DR3: 0000000000000000 DR6: 00000000fffe0ff0 DR7: 0000000000000400
> [   61.529717] Call Trace:
> [   61.530384]  __put_task_struct+0x104/0x400
> [   61.531340]  io_ring_exit_work+0x777/0x9d0
> [   61.532279]  process_one_work+0x8aa/0x1520
> [   61.533275]  ? check_flags+0x60/0x60
> [   61.534085]  ? pwq_dec_nr_in_flight+0x360/0x360
> [   61.535067]  ? rwlock_bug.part.0+0x90/0x90
> [   61.535885]  worker_thread+0x9b/0xe20
> [   61.536535]  ? process_one_work+0x1520/0x1520
> [   61.537242]  ? process_one_work+0x1520/0x1520
> [   61.537902]  kthread+0x396/0x470
> [   61.538570]  ? _raw_spin_unlock_irq+0x24/0x30
> [   61.539239]  ? kthread_mod_delayed_work+0x180/0x180
> [   61.540058]  ret_from_fork+0x22/0x30
> [   61.540678] irq event stamp: 1626
> [   61.541272] hardirqs last  enabled at (1625): [<ffffffff83497894>] _raw_spin_unlock_irq+0x24/0x30
> [   61.542633] hardirqs last disabled at (1626): [<ffffffff834860e4>] __schedule+0x1114/0x2190
> [   61.543882] softirqs last  enabled at (1586): [<ffffffff81a477ea>] wb_workfn+0x64a/0x830
> [   61.545094] softirqs last disabled at (1582): [<ffffffff817b63c7>] wb_wakeup_delayed+0x67/0xf0
> [   61.546416] ---[ end trace 67489de2f872e2d1 ]---
> 

-- 
Pavel Begunkov
