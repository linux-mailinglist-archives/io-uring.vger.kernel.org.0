Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id B9B30666FFF
	for <lists+io-uring@lfdr.de>; Thu, 12 Jan 2023 11:44:23 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231821AbjALKoP (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Thu, 12 Jan 2023 05:44:15 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:43194 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234628AbjALKnS (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Thu, 12 Jan 2023 05:43:18 -0500
Received: from mail-wm1-x331.google.com (mail-wm1-x331.google.com [IPv6:2a00:1450:4864:20::331])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id D1281517D7;
        Thu, 12 Jan 2023 02:38:50 -0800 (PST)
Received: by mail-wm1-x331.google.com with SMTP id ay12-20020a05600c1e0c00b003d9ea12bafcso10843170wmb.3;
        Thu, 12 Jan 2023 02:38:50 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=content-transfer-encoding:in-reply-to:from:content-language
         :references:to:subject:user-agent:mime-version:date:message-id:from
         :to:cc:subject:date:message-id:reply-to;
        bh=Q1D85eVn9WxV+fM2UKENnmIZ1Gzsn094gNwU1BnL7aY=;
        b=AaS5vrChysMLyvTTJmKpbV1ZlsC2mgeohBppQ+4tL/JOsEu15+dJ9EhL1qb97R1hB6
         WwJbOcEj3PgwZD3D/FYdF52JzExIimXlwgC1NyZTUmzvLRWOuktSVFCgVGD7PB3tcTtG
         1gYv7F3zbX9Z7xHEJblT92njuI5LlwI5YxEMUfSA96gsCZWorF4L5cv20hY0A/T5r4Ev
         1KO9OTI4sXI4+RL1Ycod//R8SP3VfOkSN6umOfcrRzdf7ijrHHpzRx58tT6wKaJWx/KK
         L48/S9fyKPLLpKGwao9nQiNR3xeC1oA6HXIdxPc7Ixg5wxL2UFICwww5gGxED8olyfsf
         9JCA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=content-transfer-encoding:in-reply-to:from:content-language
         :references:to:subject:user-agent:mime-version:date:message-id
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=Q1D85eVn9WxV+fM2UKENnmIZ1Gzsn094gNwU1BnL7aY=;
        b=VAaDLHvUUt4MC9y039VI54k3pVOJx0L1aZVmNCYypmWHvsePsrNJz5NK4Cpa69mkyb
         gBb4JR9Nms9GS4F5CJZXHB6+OhexjzTdysF+OkrxZAE4c5PIMcUpU2dqDSj7KJih6j8I
         1f7hM4gmotSIMY54V93EDCtHVMgFPPxEjLQJLb748V34kTFCf9ox3B2XKtGRvAMc82xV
         d2e1Z59+D93SALsxu6z68ASM1QJMoQhaaeiDjjFLWLnyFHGQZ9LvKRBVrt9MaEo9Q/cY
         ogZkO6tEup/OTQDuRgVHsU1AVQsx5KIPhlWu5hRUF2lFgQWEpU2TlLcU/OjPpnpSC3g9
         Eepg==
X-Gm-Message-State: AFqh2kqnCiEipX/vBtsySIlON4SERDQTWY4uA1rBVvG9xIJHc63Nl4X9
        QPacCVNZ+KCchd3iLRqm0UwmZ5VLeow=
X-Google-Smtp-Source: AMrXdXtDndVBk16AriRdwIb4hBGmCHc1CuBG0ZzvYdf10oVfcp5Ja/UrwN6LrUpLnXnmv03UIbUziQ==
X-Received: by 2002:a05:600c:3485:b0:3d1:ee6c:f897 with SMTP id a5-20020a05600c348500b003d1ee6cf897mr55327070wmq.3.1673519929201;
        Thu, 12 Jan 2023 02:38:49 -0800 (PST)
Received: from ?IPV6:2620:10d:c096:310::21ef? ([2620:10d:c092:600::2:478])
        by smtp.gmail.com with ESMTPSA id l24-20020a1ced18000000b003d99da8d30asm25641195wmh.46.2023.01.12.02.38.48
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Thu, 12 Jan 2023 02:38:48 -0800 (PST)
Message-ID: <3f4c1d69-cca2-ee6a-55e0-95028cf739da@gmail.com>
Date:   Thu, 12 Jan 2023 10:37:20 +0000
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:102.0) Gecko/20100101
 Thunderbird/102.5.1
Subject: Re: [syzbot] KASAN: use-after-free Read in io_fallback_req_func
To:     syzbot <syzbot+bc022c162e3b001bf607@syzkaller.appspotmail.com>,
        axboe@kernel.dk, io-uring@vger.kernel.org,
        linux-kernel@vger.kernel.org, syzkaller-bugs@googlegroups.com
References: <000000000000cf0f4905f20e504c@google.com>
Content-Language: en-US
From:   Pavel Begunkov <asml.silence@gmail.com>
In-Reply-To: <000000000000cf0f4905f20e504c@google.com>
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

On 1/12/23 10:09, syzbot wrote:
> Hello,
> 
> syzbot found the following issue on:
> 
> HEAD commit:    0a093b2893c7 Add linux-next specific files for 20230112
> git tree:       linux-next
> console output: https://syzkaller.appspot.com/x/log.txt?x=103269ce480000
> kernel config:  https://syzkaller.appspot.com/x/.config?x=835f3591019836d5
> dashboard link: https://syzkaller.appspot.com/bug?extid=bc022c162e3b001bf607
> compiler:       gcc (Debian 10.2.1-6) 10.2.1 20210110, GNU ld (GNU Binutils for Debian) 2.35.2
> 
> Unfortunately, I don't have any reproducer for this issue yet.

#syz test: git://git.kernel.dk/linux.git syztest

> 
> Downloadable assets:
> disk image: https://storage.googleapis.com/syzbot-assets/8111a570d6cb/disk-0a093b28.raw.xz
> vmlinux: https://storage.googleapis.com/syzbot-assets/ecc135b7fc9a/vmlinux-0a093b28.xz
> kernel image: https://storage.googleapis.com/syzbot-assets/ca8d73b446ea/bzImage-0a093b28.xz
> 
> IMPORTANT: if you fix the issue, please add the following tag to the commit:
> Reported-by: syzbot+bc022c162e3b001bf607@syzkaller.appspotmail.com
> 
> ==================================================================
> BUG: KASAN: use-after-free in io_fallback_req_func+0xc7/0x204 io_uring/io_uring.c:251
> Read of size 8 at addr ffff888070ac2e48 by task kworker/0:0/7
> 
> CPU: 0 PID: 7 Comm: kworker/0:0 Not tainted 6.2.0-rc3-next-20230112-syzkaller #0
> Hardware name: Google Google Compute Engine/Google Compute Engine, BIOS Google 10/26/2022
> Workqueue: events io_fallback_req_func
> Call Trace:
>   <TASK>
>   __dump_stack lib/dump_stack.c:88 [inline]
>   dump_stack_lvl+0xd1/0x138 lib/dump_stack.c:106
>   print_address_description mm/kasan/report.c:306 [inline]
>   print_report+0x15e/0x45d mm/kasan/report.c:417
>   kasan_report+0xc0/0xf0 mm/kasan/report.c:517
>   io_fallback_req_func+0xc7/0x204 io_uring/io_uring.c:251
>   process_one_work+0x9bf/0x1750 kernel/workqueue.c:2293
>   worker_thread+0x669/0x1090 kernel/workqueue.c:2440
>   kthread+0x2e8/0x3a0 kernel/kthread.c:376
>   ret_from_fork+0x1f/0x30 arch/x86/entry/entry_64.S:308
>   </TASK>
> 
> Allocated by task 7766:
>   kasan_save_stack+0x22/0x40 mm/kasan/common.c:45
>   kasan_set_track+0x25/0x30 mm/kasan/common.c:52
>   __kasan_slab_alloc+0x7f/0x90 mm/kasan/common.c:325
>   kasan_slab_alloc include/linux/kasan.h:186 [inline]
>   slab_post_alloc_hook mm/slab.h:769 [inline]
>   kmem_cache_alloc_bulk+0x3aa/0x730 mm/slub.c:4033
>   __io_alloc_req_refill+0xcc/0x40b io_uring/io_uring.c:1062
>   io_alloc_req_refill io_uring/io_uring.h:348 [inline]
>   io_submit_sqes.cold+0x7c/0xc2 io_uring/io_uring.c:2407
>   __do_sys_io_uring_enter+0x9e4/0x2c10 io_uring/io_uring.c:3429
>   do_syscall_x64 arch/x86/entry/common.c:50 [inline]
>   do_syscall_64+0x39/0xb0 arch/x86/entry/common.c:80
>   entry_SYSCALL_64_after_hwframe+0x63/0xcd
> 
> Freed by task 5179:
>   kasan_save_stack+0x22/0x40 mm/kasan/common.c:45
>   kasan_set_track+0x25/0x30 mm/kasan/common.c:52
>   kasan_save_free_info+0x2e/0x40 mm/kasan/generic.c:518
>   ____kasan_slab_free mm/kasan/common.c:236 [inline]
>   ____kasan_slab_free+0x160/0x1c0 mm/kasan/common.c:200
>   kasan_slab_free include/linux/kasan.h:162 [inline]
>   slab_free_hook mm/slub.c:1781 [inline]
>   slab_free_freelist_hook+0x8b/0x1c0 mm/slub.c:1807
>   slab_free mm/slub.c:3787 [inline]
>   kmem_cache_free+0xec/0x4e0 mm/slub.c:3809
>   io_req_caches_free+0x1a9/0x1e6 io_uring/io_uring.c:2737
>   io_ring_exit_work+0x2e7/0xc80 io_uring/io_uring.c:2967
>   process_one_work+0x9bf/0x1750 kernel/workqueue.c:2293
>   worker_thread+0x669/0x1090 kernel/workqueue.c:2440
>   kthread+0x2e8/0x3a0 kernel/kthread.c:376
>   ret_from_fork+0x1f/0x30 arch/x86/entry/entry_64.S:308
> 
> The buggy address belongs to the object at ffff888070ac2dc0
>   which belongs to the cache io_kiocb of size 216
> The buggy address is located 136 bytes inside of
>   216-byte region [ffff888070ac2dc0, ffff888070ac2e98)
> 
> The buggy address belongs to the physical page:
> page:ffffea0001c2b080 refcount:1 mapcount:0 mapping:0000000000000000 index:0x0 pfn:0x70ac2
> memcg:ffff88802a81d181
> flags: 0xfff00000000200(slab|node=0|zone=1|lastcpupid=0x7ff)
> raw: 00fff00000000200 ffff8881461d1780 dead000000000122 0000000000000000
> raw: 0000000000000000 00000000800c000c 00000001ffffffff ffff88802a81d181
> page dumped because: kasan: bad access detected
> page_owner tracks the page as allocated
> page last allocated via order 0, migratetype Unmovable, gfp_mask 0x112cc0(GFP_USER|__GFP_NOWARN|__GFP_NORETRY), pid 5547, tgid 5545 (syz-executor.4), ts 182131630120, free_ts 181898498774
>   prep_new_page mm/page_alloc.c:2549 [inline]
>   get_page_from_freelist+0x11bb/0x2d50 mm/page_alloc.c:4324
>   __alloc_pages+0x1cb/0x5c0 mm/page_alloc.c:5590
>   alloc_pages+0x1aa/0x270 mm/mempolicy.c:2281
>   alloc_slab_page mm/slub.c:1851 [inline]
>   allocate_slab+0x25f/0x350 mm/slub.c:1998
>   new_slab mm/slub.c:2051 [inline]
>   ___slab_alloc+0xa91/0x1400 mm/slub.c:3193
>   __kmem_cache_alloc_bulk mm/slub.c:3951 [inline]
>   kmem_cache_alloc_bulk+0x23d/0x730 mm/slub.c:4026
>   __io_alloc_req_refill+0xcc/0x40b io_uring/io_uring.c:1062
>   io_alloc_req_refill io_uring/io_uring.h:348 [inline]
>   io_submit_sqes.cold+0x7c/0xc2 io_uring/io_uring.c:2407
>   __do_sys_io_uring_enter+0x9e4/0x2c10 io_uring/io_uring.c:3429
>   do_syscall_x64 arch/x86/entry/common.c:50 [inline]
>   do_syscall_64+0x39/0xb0 arch/x86/entry/common.c:80
>   entry_SYSCALL_64_after_hwframe+0x63/0xcd
> page last free stack trace:
>   reset_page_owner include/linux/page_owner.h:24 [inline]
>   free_pages_prepare mm/page_alloc.c:1451 [inline]
>   free_pcp_prepare+0x4d0/0x910 mm/page_alloc.c:1501
>   free_unref_page_prepare mm/page_alloc.c:3387 [inline]
>   free_unref_page+0x1d/0x490 mm/page_alloc.c:3482
>   qlink_free mm/kasan/quarantine.c:168 [inline]
>   qlist_free_all+0x6a/0x170 mm/kasan/quarantine.c:187
>   kasan_quarantine_reduce+0x192/0x220 mm/kasan/quarantine.c:294
>   __kasan_slab_alloc+0x63/0x90 mm/kasan/common.c:302
>   kasan_slab_alloc include/linux/kasan.h:186 [inline]
>   slab_post_alloc_hook mm/slab.h:769 [inline]
>   slab_alloc_node mm/slub.c:3452 [inline]
>   slab_alloc mm/slub.c:3460 [inline]
>   __kmem_cache_alloc_lru mm/slub.c:3467 [inline]
>   kmem_cache_alloc+0x175/0x320 mm/slub.c:3476
>   kmem_cache_zalloc include/linux/slab.h:710 [inline]
>   taskstats_tgid_alloc kernel/taskstats.c:583 [inline]
>   taskstats_exit+0x5f3/0xb80 kernel/taskstats.c:622
>   do_exit+0x822/0x2a90 kernel/exit.c:852
>   do_group_exit+0xd4/0x2a0 kernel/exit.c:1012
>   get_signal+0x225f/0x24f0 kernel/signal.c:2859
>   arch_do_signal_or_restart+0x79/0x5c0 arch/x86/kernel/signal.c:306
>   exit_to_user_mode_loop kernel/entry/common.c:168 [inline]
>   exit_to_user_mode_prepare+0x11f/0x240 kernel/entry/common.c:204
>   __syscall_exit_to_user_mode_work kernel/entry/common.c:286 [inline]
>   syscall_exit_to_user_mode+0x1d/0x50 kernel/entry/common.c:297
>   do_syscall_64+0x46/0xb0 arch/x86/entry/common.c:86
>   entry_SYSCALL_64_after_hwframe+0x63/0xcd
> 
> Memory state around the buggy address:
>   ffff888070ac2d00: fb fb fb fb fb fb fb fb fb fb fb fc fc fc fc fc
>   ffff888070ac2d80: fc fc fc fc fc fc fc fc fa fb fb fb fb fb fb fb
>> ffff888070ac2e00: fb fb fb fb fb fb fb fb fb fb fb fb fb fb fb fb
>                                                ^
>   ffff888070ac2e80: fb fb fb fc fc fc fc fc fc fc fc fc fc fc fc fc
>   ffff888070ac2f00: fc fc fc fc fc fc fc fc fc fc fc fc fc fc fc fc
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

-- 
Pavel Begunkov
