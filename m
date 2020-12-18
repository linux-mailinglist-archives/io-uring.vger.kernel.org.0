Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 978032DE6EB
	for <lists+io-uring@lfdr.de>; Fri, 18 Dec 2020 16:48:14 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728119AbgLRPr6 (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Fri, 18 Dec 2020 10:47:58 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:43822 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726885AbgLRPr6 (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Fri, 18 Dec 2020 10:47:58 -0500
Received: from mail-wm1-x32e.google.com (mail-wm1-x32e.google.com [IPv6:2a00:1450:4864:20::32e])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id D3D3AC0617A7;
        Fri, 18 Dec 2020 07:47:17 -0800 (PST)
Received: by mail-wm1-x32e.google.com with SMTP id a6so2749604wmc.2;
        Fri, 18 Dec 2020 07:47:17 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=subject:to:references:cc:from:autocrypt:message-id:date:user-agent
         :mime-version:in-reply-to:content-language:content-transfer-encoding;
        bh=oKeywUwxIFVpxfmzIXgUIjRv9qPJ6f/hKNDe4u3p2h0=;
        b=toCMd65m2zeRYQ5W6W+DREuYgPUDn5+gHCzGtNbWhNk0LNRZIw3WBsQIFMjTHMNfG/
         7iIs20fY0ueAxN+gl1Z54HoAqlynh4/zNTcfZsplRGJPLU063Sb3soVO+V18W2fJomfQ
         Jb0eMs41PHi1CV4aBluYffgq+jOqiee5RhYV3xViBlZ4jV5wYpKAVj0jD/ivRDojHd4d
         KOIxkJNnbNjjESEstUkItVMgwC7j6FCsMMreoBpM4Xwx/FL7Ony910p1EpeulVLh9sbJ
         LJI4fnkTrh74OCR64mjnNb512MuUlkRgwEhAbU3UkBUu1+MuhIXcV+gakWNvA/RLsH0J
         bkpA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:references:cc:from:autocrypt
         :message-id:date:user-agent:mime-version:in-reply-to
         :content-language:content-transfer-encoding;
        bh=oKeywUwxIFVpxfmzIXgUIjRv9qPJ6f/hKNDe4u3p2h0=;
        b=SvvXHAQ87UUmkxjdzAlLNKQ84zrkKPgj3oah4ubf1SaE6Qstd/wJN6lYFepObxpKwv
         5kijMZMx/2rnOTCcuE3sD0eZF4j4DmbIEBkJryv741oS55+dOVdIMW3tY2/xai18cBzh
         pTdUSfre0Zf+H8HCwlC75sM3KTNqZiS1Stn5JWjrq7ad1Ec6Ng05wpBMnmiRWE2eMYwt
         yxlqhfQZrGvq+Lyr/VyWph7j2cGdPpnHLlVGZ2+CRW4rD+O0gwZSfGf4OAT+dNSEyL2G
         7NEKL158Rg1ZB9r6FshbQUUlO9KXP6Z0PgH18uBCSf+LGM57UQXG5wRV+qOBeWLLSd2b
         RgFA==
X-Gm-Message-State: AOAM530wEe76p16M4n+QR0mevvrw+NR2DDPwwYKMNGdF00a6mMG+Dqao
        JKXx2CotTrR1dAU9Xr8Wh6EUCvvUN8MJPQ==
X-Google-Smtp-Source: ABdhPJzKNWNktPYYU9z4WBj5V2AFq3RKJKBXqvd9D4ONj7sxsxBZBTZm1J4UzhU2Do2ffc7UCLcx4Q==
X-Received: by 2002:a7b:c5d6:: with SMTP id n22mr4696784wmk.70.1608306436619;
        Fri, 18 Dec 2020 07:47:16 -0800 (PST)
Received: from [192.168.8.132] ([85.255.234.120])
        by smtp.gmail.com with ESMTPSA id q1sm13541008wrj.8.2020.12.18.07.47.15
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Fri, 18 Dec 2020 07:47:16 -0800 (PST)
Subject: Re: KASAN: use-after-free Read in idr_for_each (2)
To:     syzbot <syzbot+12056a09a0311d758e60@syzkaller.appspotmail.com>
References: <00000000000052c1e805b52dfa16@google.com>
Cc:     axboe@kernel.dk, io-uring@vger.kernel.org,
        linux-fsdevel@vger.kernel.org, linux-kernel@vger.kernel.org,
        syzkaller-bugs@googlegroups.com, viro@zeniv.linux.org.uk
From:   Pavel Begunkov <asml.silence@gmail.com>
Autocrypt: addr=asml.silence@gmail.com; prefer-encrypt=mutual; keydata=
 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 bA==
Message-ID: <af4caaab-93c0-622f-9ab0-e540eb3bc049@gmail.com>
Date:   Fri, 18 Dec 2020 15:43:57 +0000
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.3.0
MIME-Version: 1.0
In-Reply-To: <00000000000052c1e805b52dfa16@google.com>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org

On 28/11/2020 17:19, syzbot wrote:
> syzbot has found a reproducer for the following issue on:
> 
> HEAD commit:    c84e1efa Merge tag 'asm-generic-fixes-5.10-2' of git://git..
> git tree:       upstream
> console output: https://syzkaller.appspot.com/x/log.txt?x=1251d759500000
> kernel config:  https://syzkaller.appspot.com/x/.config?x=cb8d1a3819ba4356
> dashboard link: https://syzkaller.appspot.com/bug?extid=12056a09a0311d758e60
> compiler:       gcc (GCC) 10.1.0-syz 20200507
> syz repro:      https://syzkaller.appspot.com/x/repro.syz?x=1126cce9500000
> C reproducer:   https://syzkaller.appspot.com/x/repro.c?x=1173d2e9500000
> 
> IMPORTANT: if you fix the issue, please add the following tag to the commit:
> Reported-by: syzbot+12056a09a0311d758e60@syzkaller.appspotmail.com
> 
> ==================================================================
> BUG: KASAN: use-after-free in radix_tree_next_slot include/linux/radix-tree.h:422 [inline]
> BUG: KASAN: use-after-free in idr_for_each+0x206/0x220 lib/idr.c:202
> Read of size 8 at addr ffff888032eb2c40 by task kworker/u4:4/186
> 
> CPU: 1 PID: 186 Comm: kworker/u4:4 Not tainted 5.10.0-rc5-syzkaller #0
> Hardware name: Google Google Compute Engine/Google Compute Engine, BIOS Google 01/01/2011
> Workqueue: events_unbound io_ring_exit_work
> Call Trace:
>  __dump_stack lib/dump_stack.c:77 [inline]
>  dump_stack+0x107/0x163 lib/dump_stack.c:118
>  print_address_description.constprop.0.cold+0xae/0x4c8 mm/kasan/report.c:385
>  __kasan_report mm/kasan/report.c:545 [inline]
>  kasan_report.cold+0x1f/0x37 mm/kasan/report.c:562
>  radix_tree_next_slot include/linux/radix-tree.h:422 [inline]
>  idr_for_each+0x206/0x220 lib/idr.c:202
>  io_destroy_buffers fs/io_uring.c:8275 [inline]
>  io_ring_ctx_free fs/io_uring.c:8298 [inline]
>  io_ring_exit_work+0x3f7/0x7a0 fs/io_uring.c:8375
>  process_one_work+0x933/0x15a0 kernel/workqueue.c:2272
>  worker_thread+0x64c/0x1120 kernel/workqueue.c:2418
>  kthread+0x3b1/0x4a0 kernel/kthread.c:292
>  ret_from_fork+0x1f/0x30 arch/x86/entry/entry_64.S:296
> 
> Allocated by task 10961:
>  kasan_save_stack+0x1b/0x40 mm/kasan/common.c:48
>  kasan_set_track mm/kasan/common.c:56 [inline]
>  __kasan_kmalloc.constprop.0+0xc2/0xd0 mm/kasan/common.c:461
>  slab_post_alloc_hook mm/slab.h:526 [inline]
>  slab_alloc_node mm/slub.c:2891 [inline]
>  slab_alloc mm/slub.c:2899 [inline]
>  kmem_cache_alloc+0x122/0x460 mm/slub.c:2904
>  radix_tree_node_alloc.constprop.0+0x7c/0x350 lib/radix-tree.c:274
>  idr_get_free+0x4c5/0x940 lib/radix-tree.c:1504
>  idr_alloc_u32+0x170/0x2d0 lib/idr.c:46
>  idr_alloc+0xc2/0x130 lib/idr.c:87
>  io_provide_buffers fs/io_uring.c:4032 [inline]
>  io_issue_sqe+0x2fc4/0x3d10 fs/io_uring.c:6012
>  __io_queue_sqe+0x132/0xda0 fs/io_uring.c:6232
>  io_queue_sqe+0x623/0x11f0 fs/io_uring.c:6298
>  io_submit_sqe fs/io_uring.c:6367 [inline]
>  io_submit_sqes+0x15e1/0x28a0 fs/io_uring.c:6596
>  __do_sys_io_uring_enter+0xc90/0x1ab0 fs/io_uring.c:8983
>  do_syscall_64+0x2d/0x70 arch/x86/entry/common.c:46
>  entry_SYSCALL_64_after_hwframe+0x44/0xa9
> 
> Freed by task 8546:
>  kasan_save_stack+0x1b/0x40 mm/kasan/common.c:48
>  kasan_set_track+0x1c/0x30 mm/kasan/common.c:56
>  kasan_set_free_info+0x1b/0x30 mm/kasan/generic.c:355
>  __kasan_slab_free+0x102/0x140 mm/kasan/common.c:422
>  slab_free_hook mm/slub.c:1544 [inline]
>  slab_free_freelist_hook+0x5d/0x150 mm/slub.c:1577
>  slab_free mm/slub.c:3142 [inline]
>  kmem_cache_free+0x82/0x350 mm/slub.c:3158
>  rcu_do_batch kernel/rcu/tree.c:2476 [inline]
>  rcu_core+0x5df/0xe80 kernel/rcu/tree.c:2711
>  __do_softirq+0x2a0/0x9f6 kernel/softirq.c:298
> 
> Last call_rcu():
>  kasan_save_stack+0x1b/0x40 mm/kasan/common.c:48
>  kasan_record_aux_stack+0xc0/0xf0 mm/kasan/generic.c:346
>  __call_rcu kernel/rcu/tree.c:2953 [inline]
>  call_rcu+0xbb/0x700 kernel/rcu/tree.c:3027
>  radix_tree_node_free lib/radix-tree.c:308 [inline]
>  delete_node+0x591/0x8c0 lib/radix-tree.c:571
>  __radix_tree_delete+0x190/0x370 lib/radix-tree.c:1377
>  radix_tree_delete_item+0xe7/0x230 lib/radix-tree.c:1428
>  __io_remove_buffers fs/io_uring.c:3930 [inline]
>  __io_remove_buffers fs/io_uring.c:3909 [inline]
>  __io_destroy_buffers+0x161/0x200 fs/io_uring.c:8269
>  idr_for_each+0x113/0x220 lib/idr.c:208
>  io_destroy_buffers fs/io_uring.c:8275 [inline]
>  io_ring_ctx_free fs/io_uring.c:8298 [inline]
>  io_ring_exit_work+0x3f7/0x7a0 fs/io_uring.c:8375
>  process_one_work+0x933/0x15a0 kernel/workqueue.c:2272
>  worker_thread+0x64c/0x1120 kernel/workqueue.c:2418
>  kthread+0x3b1/0x4a0 kernel/kthread.c:292
>  ret_from_fork+0x1f/0x30 arch/x86/entry/entry_64.S:296
> 
> The buggy address belongs to the object at ffff888032eb2c00
>  which belongs to the cache radix_tree_node of size 576
> The buggy address is located 64 bytes inside of
>  576-byte region [ffff888032eb2c00, ffff888032eb2e40)
> The buggy address belongs to the page:
> page:00000000102f3139 refcount:1 mapcount:0 mapping:0000000000000000 index:0x0 pfn:0x32eb0
> head:00000000102f3139 order:2 compound_mapcount:0 compound_pincount:0
> flags: 0xfff00000010200(slab|head)
> raw: 00fff00000010200 dead000000000100 dead000000000122 ffff88801004db40
> raw: 0000000000000000 0000000000170017 00000001ffffffff 0000000000000000
> page dumped because: kasan: bad access detected
> 
> Memory state around the buggy address:
>  ffff888032eb2b00: fb fb fb fb fb fb fb fb fb fb fb fb fb fb fb fb
>  ffff888032eb2b80: fc fc fc fc fc fc fc fc fc fc fc fc fc fc fc fc
>> ffff888032eb2c00: fa fb fb fb fb fb fb fb fb fb fb fb fb fb fb fb
>                                            ^
>  ffff888032eb2c80: fb fb fb fb fb fb fb fb fb fb fb fb fb fb fb fb
>  ffff888032eb2d00: fb fb fb fb fb fb fb fb fb fb fb fb fb fb fb fb
> ==================================================================
> 

#syz test: git://git.kernel.dk/linux-block dfea9fce29fda6f2f91161677e0e0d9b671bc099

-- 
Pavel Begunkov
