Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 00B972798A5
	for <lists+io-uring@lfdr.de>; Sat, 26 Sep 2020 13:00:57 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726309AbgIZLA5 (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Sat, 26 Sep 2020 07:00:57 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:46366 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726239AbgIZLA4 (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Sat, 26 Sep 2020 07:00:56 -0400
Received: from mail-pg1-x543.google.com (mail-pg1-x543.google.com [IPv6:2607:f8b0:4864:20::543])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id A6A4CC0613CE
        for <io-uring@vger.kernel.org>; Sat, 26 Sep 2020 04:00:56 -0700 (PDT)
Received: by mail-pg1-x543.google.com with SMTP id m34so4534517pgl.9
        for <io-uring@vger.kernel.org>; Sat, 26 Sep 2020 04:00:56 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernel-dk.20150623.gappssmtp.com; s=20150623;
        h=subject:to:references:from:message-id:date:user-agent:mime-version
         :in-reply-to:content-language:content-transfer-encoding;
        bh=Cx3thS4X/NSw+l4f7lgS4pcF5d3RKriO6PVDAEOPiw0=;
        b=Kr2tJk6vLrM4TyaLUv3bkK+QZA+92cY95gVCO9z5TYFRdwhtM3pOTSRnkXGNdPSkXB
         OQs8lFOA1W6Id1s8C8Y/SFpBX/IMpTRvxxP9wQcmieE/ilo6nAogLwF3qZL1Dju+j8bU
         mgyKrpXO3/yXbvxhPqvm2w8DrEw8u0zUNEfLJc+KWlvqqINS8Xq9VLnyYosMO43YtppX
         iUhpb3fctkllBNZ9sijFK4/K7D8cZ0mzPnxJDKW51HyOA/G8K4rd3jdt3d5CU24N+RLE
         hyvBdh/wy8LjxTq3Ped6V7zPuj9E97g3lnir3rDlxCM0ZkqtwVUwStqb+ftOB0DTRyYa
         Virw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=Cx3thS4X/NSw+l4f7lgS4pcF5d3RKriO6PVDAEOPiw0=;
        b=CXrk+uz+agOd/NJVIeujVSoPx4Cr+0uBKMYmywo+TqqKy6rTvIutwi3ENwbEJJ16oi
         ATE8XGG+/qhDsiF7sZAj492rqzE4MkUQ/ocXnS/xEMw7fhZhAogsv79oVdNgc2aJJoal
         mjn7NDjAWbzBDEfN0bM3eK7sWbv6wPYNu+WhhJujL5ntTJpNNnpb2wP4/3AaM5uhodrF
         lUyHpJqarqDTwXpIh4Ohn24b40ngTsnPsUWkLsqr28krvTCWQwyBEcKpWvYKi5Xxtz5O
         zBTAF2nzd3PGLgZ99zHnmwsuqFbHUESQay2vm0ovPz5Sx1VGDqR9MazlWlvQOe5hwPJn
         OVQw==
X-Gm-Message-State: AOAM531ZzJUAuXNTg+9niVMc1XpyXjCUkb4TGRDXAWkhkMgN5F6SkM3M
        mm1gM8O3X3JnrNvSjjfoLrrpjg==
X-Google-Smtp-Source: ABdhPJwREFOh+FLzNUwMDICVMnfGPY4wHWuS39gp/59b987SaqVBOCkotyemTmL0mschSdY3+sbvww==
X-Received: by 2002:a63:1a66:: with SMTP id a38mr2379396pgm.253.1601118055676;
        Sat, 26 Sep 2020 04:00:55 -0700 (PDT)
Received: from [192.168.1.134] ([66.219.217.173])
        by smtp.gmail.com with ESMTPSA id i25sm4846359pgi.9.2020.09.26.04.00.54
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Sat, 26 Sep 2020 04:00:55 -0700 (PDT)
Subject: Re: KASAN: use-after-free Read in io_wqe_worker
To:     syzbot <syzbot+9af99580130003da82b1@syzkaller.appspotmail.com>,
        io-uring@vger.kernel.org, linux-fsdevel@vger.kernel.org,
        linux-kernel@vger.kernel.org, syzkaller-bugs@googlegroups.com,
        viro@zeniv.linux.org.uk, Hillf Danton <hdanton@sina.com>
References: <0000000000007e88ec05b0354fdd@google.com>
From:   Jens Axboe <axboe@kernel.dk>
Message-ID: <1e5298b6-0e2e-d2e7-dea7-36b524671493@kernel.dk>
Date:   Sat, 26 Sep 2020 05:00:53 -0600
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.10.0
MIME-Version: 1.0
In-Reply-To: <0000000000007e88ec05b0354fdd@google.com>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org

On 9/26/20 4:58 AM, syzbot wrote:
> Hello,
> 
> syzbot found the following issue on:
> 
> HEAD commit:    98477740 Merge branch 'rcu/urgent' of git://git.kernel.org..
> git tree:       upstream
> console output: https://syzkaller.appspot.com/x/log.txt?x=153e929b900000
> kernel config:  https://syzkaller.appspot.com/x/.config?x=af502ec9a451c9fc
> dashboard link: https://syzkaller.appspot.com/bug?extid=9af99580130003da82b1
> compiler:       clang version 10.0.0 (https://github.com/llvm/llvm-project/ c2443155a0fb245c8f17f2c1c72b6ea391e86e81)
> syz repro:      https://syzkaller.appspot.com/x/repro.syz?x=14138009900000
> C reproducer:   https://syzkaller.appspot.com/x/repro.c?x=17d0f809900000
> 
> IMPORTANT: if you fix the issue, please add the following tag to the commit:
> Reported-by: syzbot+9af99580130003da82b1@syzkaller.appspotmail.com
> 
> ==================================================================
> BUG: KASAN: use-after-free in __lock_acquire+0x92/0x2ae0 kernel/locking/lockdep.c:4311
> Read of size 8 at addr ffff88821ae5f818 by task io_wqe_worker-0/11054
> 
> CPU: 1 PID: 11054 Comm: io_wqe_worker-0 Not tainted 5.9.0-rc6-syzkaller #0
> Hardware name: Google Google Compute Engine/Google Compute Engine, BIOS Google 01/01/2011
> Call Trace:
>  __dump_stack lib/dump_stack.c:77 [inline]
>  dump_stack+0x1d6/0x29e lib/dump_stack.c:118
>  print_address_description+0x66/0x620 mm/kasan/report.c:383
>  __kasan_report mm/kasan/report.c:513 [inline]
>  kasan_report+0x132/0x1d0 mm/kasan/report.c:530
>  __lock_acquire+0x92/0x2ae0 kernel/locking/lockdep.c:4311
>  lock_acquire+0x148/0x720 kernel/locking/lockdep.c:5029
>  __raw_spin_lock_irq include/linux/spinlock_api_smp.h:128 [inline]
>  _raw_spin_lock_irq+0xa6/0xc0 kernel/locking/spinlock.c:167
>  spin_lock_irq include/linux/spinlock.h:379 [inline]
>  io_wqe_worker+0x756/0x810 fs/io-wq.c:589
>  kthread+0x37e/0x3a0 drivers/block/aoe/aoecmd.c:1234
>  ret_from_fork+0x1f/0x30 arch/x86/entry/entry_64.S:294
> 
> Allocated by task 11048:
>  kasan_save_stack mm/kasan/common.c:48 [inline]
>  kasan_set_track mm/kasan/common.c:56 [inline]
>  __kasan_kmalloc+0x100/0x130 mm/kasan/common.c:461
>  kmem_cache_alloc_node_trace+0x1f7/0x2a0 mm/slab.c:3594
>  kmalloc_node include/linux/slab.h:572 [inline]
>  kzalloc_node include/linux/slab.h:677 [inline]
>  io_wq_create+0x295/0x880 fs/io-wq.c:1064
>  io_init_wq_offload fs/io_uring.c:7432 [inline]
>  io_sq_offload_start fs/io_uring.c:7504 [inline]
>  io_uring_create fs/io_uring.c:8625 [inline]
>  io_uring_setup fs/io_uring.c:8694 [inline]
>  __do_sys_io_uring_setup fs/io_uring.c:8700 [inline]
>  __se_sys_io_uring_setup+0x18ed/0x2a00 fs/io_uring.c:8697
>  do_syscall_64+0x31/0x70 arch/x86/entry/common.c:46
>  entry_SYSCALL_64_after_hwframe+0x44/0xa9
> 
> Freed by task 128:
>  kasan_save_stack mm/kasan/common.c:48 [inline]
>  kasan_set_track+0x3d/0x70 mm/kasan/common.c:56
>  kasan_set_free_info+0x17/0x30 mm/kasan/generic.c:355
>  __kasan_slab_free+0xdd/0x110 mm/kasan/common.c:422
>  __cache_free mm/slab.c:3418 [inline]
>  kfree+0x113/0x200 mm/slab.c:3756
>  __io_wq_destroy fs/io-wq.c:1138 [inline]
>  io_wq_destroy+0x470/0x510 fs/io-wq.c:1146
>  io_finish_async fs/io_uring.c:6836 [inline]
>  io_ring_ctx_free fs/io_uring.c:7870 [inline]
>  io_ring_exit_work+0x195/0x520 fs/io_uring.c:7954
>  process_one_work+0x789/0xfc0 kernel/workqueue.c:2269
>  worker_thread+0xaa4/0x1460 kernel/workqueue.c:2415
>  kthread+0x37e/0x3a0 drivers/block/aoe/aoecmd.c:1234
>  ret_from_fork+0x1f/0x30 arch/x86/entry/entry_64.S:294
> 
> The buggy address belongs to the object at ffff88821ae5f800
>  which belongs to the cache kmalloc-1k of size 1024
> The buggy address is located 24 bytes inside of
>  1024-byte region [ffff88821ae5f800, ffff88821ae5fc00)
> The buggy address belongs to the page:
> page:000000008e41b1c2 refcount:1 mapcount:0 mapping:0000000000000000 index:0x0 pfn:0x21ae5f
> flags: 0x57ffe0000000200(slab)
> raw: 057ffe0000000200 ffffea00086a10c8 ffffea00085d1848 ffff8880aa440700
> raw: 0000000000000000 ffff88821ae5f000 0000000100000002 0000000000000000
> page dumped because: kasan: bad access detected
> 
> Memory state around the buggy address:
>  ffff88821ae5f700: fc fc fc fc fc fc fc fc fc fc fc fc fc fc fc fc
>  ffff88821ae5f780: fc fc fc fc fc fc fc fc fc fc fc fc fc fc fc fc
>> ffff88821ae5f800: fa fb fb fb fb fb fb fb fb fb fb fb fb fb fb fb
>                             ^
>  ffff88821ae5f880: fb fb fb fb fb fb fb fb fb fb fb fb fb fb fb fb
>  ffff88821ae5f900: fb fb fb fb fb fb fb fb fb fb fb fb fb fb fb fb
> ==================================================================

Hillf, you've been looking at this one, care to spend a bit of time on it
and pull it to completion?

-- 
Jens Axboe

