Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 16497666FFD
	for <lists+io-uring@lfdr.de>; Thu, 12 Jan 2023 11:44:23 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230373AbjALKoR (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Thu, 12 Jan 2023 05:44:17 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:43230 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234936AbjALKnU (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Thu, 12 Jan 2023 05:43:20 -0500
Received: from mail-wm1-x330.google.com (mail-wm1-x330.google.com [IPv6:2a00:1450:4864:20::330])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 2588C53721;
        Thu, 12 Jan 2023 02:39:04 -0800 (PST)
Received: by mail-wm1-x330.google.com with SMTP id o15so12852066wmr.4;
        Thu, 12 Jan 2023 02:39:04 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=content-transfer-encoding:in-reply-to:from:references:to
         :content-language:subject:user-agent:mime-version:date:message-id
         :from:to:cc:subject:date:message-id:reply-to;
        bh=Rh+WvtST8EOSf+C1fCAb9FxEhC2+IwJsQhXphxFSuOE=;
        b=Q/c9ePgMo3fu3qJo6fQ8CYd/CUjI2utr4hCuusgxjd+gsQBw3CD7pRGcV+4U1ztQPS
         p7ncA/vN+2J8ubbK7lwlDzUov75BCGyi192LnWaQbWOp0jIojMv/q5HDUi98m6u2fIH+
         9uyIGe4r6rUqW80Hv4cpbBiijdljgHuoz6wPhV/CbSDLTadi0GCKJAe5oEA9ZhzTrHOn
         cVsfCX/vG7iTavbTNvlUL9KzmxTWCPJPvElhM43A3DdoIs9U+Lu70Dbrmf/FcWctJG2A
         KdiE6H8eNVN4ozLAMHa89af65IHLS0lTBnB0WVvLZePpZUDpRSoGSy0ERMNJlLFrSNeA
         3TBg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=content-transfer-encoding:in-reply-to:from:references:to
         :content-language:subject:user-agent:mime-version:date:message-id
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=Rh+WvtST8EOSf+C1fCAb9FxEhC2+IwJsQhXphxFSuOE=;
        b=Y9D6DQQjCAQXUUnTEgs4W8s1CDUw5jvEFDLXT43SEmmHAF1EJ20U5KzOG3Mcgdme+/
         cph67k6Vg49TR2IH+D5qTyYZ3PZosgZyHPqc1efLhbjib77HmCRM8tsH5+SVM29emmaO
         stbaim4lgZ3klNwpl1hLT8cShA3yK8D8aeuKbA5oLrVH6EZ7JUzvBSDIg7d4fPq+yBAX
         vppDkVJixo/ODWB5KE9LLQHtbwgWLPQfW/jMRgzQv9BAwUeS7DTYE/crj1dYILMzPi/a
         V4cV5x5Xu0BOtqHiowfjoGkIuty6ELv9NLKaU7EjoqDGMYCsy17WUsSJbwN+fd7gC9lE
         4mbA==
X-Gm-Message-State: AFqh2kqI2AP/nFGOF7jCpBSiH22xPnNU16+NerWYFsESAZHex8Eo1TUd
        udLLYTzwBTXucRlhe0pQpL0=
X-Google-Smtp-Source: AMrXdXtLmT6LHlW++WSgvV2IoPCX2vw6MJzDMfTGAloFFIT375zh10ncNw3Vlu5YtgHzvLLDE909Qg==
X-Received: by 2002:a05:600c:4f55:b0:3cf:7197:e67c with SMTP id m21-20020a05600c4f5500b003cf7197e67cmr53684056wmq.25.1673519942599;
        Thu, 12 Jan 2023 02:39:02 -0800 (PST)
Received: from ?IPV6:2620:10d:c096:310::21ef? ([2620:10d:c092:600::2:478])
        by smtp.gmail.com with ESMTPSA id r126-20020a1c2b84000000b003d35c845cbbsm25236166wmr.21.2023.01.12.02.39.01
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Thu, 12 Jan 2023 02:39:02 -0800 (PST)
Message-ID: <c337e751-165b-bd55-5f97-8e27b59165e9@gmail.com>
Date:   Thu, 12 Jan 2023 10:37:34 +0000
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:102.0) Gecko/20100101
 Thunderbird/102.5.1
Subject: Re: [syzbot] KASAN: use-after-free Read in io_fallback_tw
Content-Language: en-US
To:     syzbot <syzbot+ebcc33c1e81093c9224f@syzkaller.appspotmail.com>,
        axboe@kernel.dk, io-uring@vger.kernel.org,
        linux-kernel@vger.kernel.org, syzkaller-bugs@googlegroups.com
References: <00000000000062f20e05f20e5b9e@google.com>
From:   Pavel Begunkov <asml.silence@gmail.com>
In-Reply-To: <00000000000062f20e05f20e5b9e@google.com>
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

On 1/12/23 10:12, syzbot wrote:
> Hello,
> 
> syzbot found the following issue on:
> 
> HEAD commit:    0a093b2893c7 Add linux-next specific files for 20230112
> git tree:       linux-next
> console output: https://syzkaller.appspot.com/x/log.txt?x=11419c5e480000
> kernel config:  https://syzkaller.appspot.com/x/.config?x=835f3591019836d5
> dashboard link: https://syzkaller.appspot.com/bug?extid=ebcc33c1e81093c9224f
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
> Reported-by: syzbot+ebcc33c1e81093c9224f@syzkaller.appspotmail.com
> 
> ==================================================================
> BUG: KASAN: use-after-free in io_fallback_tw+0x6d/0x119 io_uring/io_uring.c:1249
> Read of size 8 at addr ffff88804ae3f088 by task syz-executor.0/9602
> 
> CPU: 0 PID: 9602 Comm: syz-executor.0 Not tainted 6.2.0-rc3-next-20230112-syzkaller #0
> Hardware name: Google Google Compute Engine/Google Compute Engine, BIOS Google 10/26/2022
> Call Trace:
>   <TASK>
>   __dump_stack lib/dump_stack.c:88 [inline]
>   dump_stack_lvl+0xd1/0x138 lib/dump_stack.c:106
>   print_address_description mm/kasan/report.c:306 [inline]
>   print_report+0x15e/0x45d mm/kasan/report.c:417
>   kasan_report+0xc0/0xf0 mm/kasan/report.c:517
>   io_fallback_tw+0x6d/0x119 io_uring/io_uring.c:1249
>   tctx_task_work.cold+0xf/0x2c io_uring/io_uring.c:1219
>   task_work_run+0x16f/0x270 kernel/task_work.c:179
>   exit_task_work include/linux/task_work.h:38 [inline]
>   do_exit+0xb17/0x2a90 kernel/exit.c:867
>   do_group_exit+0xd4/0x2a0 kernel/exit.c:1012
>   get_signal+0x225f/0x24f0 kernel/signal.c:2859
>   arch_do_signal_or_restart+0x79/0x5c0 arch/x86/kernel/signal.c:306
>   exit_to_user_mode_loop kernel/entry/common.c:168 [inline]
>   exit_to_user_mode_prepare+0x11f/0x240 kernel/entry/common.c:204
>   __syscall_exit_to_user_mode_work kernel/entry/common.c:286 [inline]
>   syscall_exit_to_user_mode+0x1d/0x50 kernel/entry/common.c:297
>   do_syscall_64+0x46/0xb0 arch/x86/entry/common.c:86
>   entry_SYSCALL_64_after_hwframe+0x63/0xcd
> RIP: 0033:0x7fd3d3a8c0c9
> Code: Unable to access opcode bytes at 0x7fd3d3a8c09f.
> RSP: 002b:00007fd3d47c8218 EFLAGS: 00000246 ORIG_RAX: 00000000000000ca
> RAX: fffffffffffffe00 RBX: 00007fd3d3babf88 RCX: 00007fd3d3a8c0c9
> RDX: 0000000000000000 RSI: 0000000000000080 RDI: 00007fd3d3babf88
> RBP: 00007fd3d3babf80 R08: 0000000000000000 R09: 0000000000000000
> R10: 0000000000000000 R11: 0000000000000246 R12: 00007fd3d3babf8c
> R13: 00007fffea21180f R14: 00007fd3d47c8300 R15: 0000000000022000
>   </TASK>
> 
> Allocated by task 9602:
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
> Freed by task 9123:
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
> The buggy address belongs to the object at ffff88804ae3f000
>   which belongs to the cache io_kiocb of size 216
> The buggy address is located 136 bytes inside of
>   216-byte region [ffff88804ae3f000, ffff88804ae3f0d8)
> 
> The buggy address belongs to the physical page:
> page:ffffea00012b8fc0 refcount:1 mapcount:0 mapping:0000000000000000 index:0x0 pfn:0x4ae3f
> memcg:ffff88807dd24601
> flags: 0xfff00000000200(slab|node=0|zone=1|lastcpupid=0x7ff)
> raw: 00fff00000000200 ffff88801c182b40 dead000000000122 0000000000000000
> raw: 0000000000000000 00000000800c000c 00000001ffffffff ffff88807dd24601
> page dumped because: kasan: bad access detected
> page_owner tracks the page as allocated
> page last allocated via order 0, migratetype Unmovable, gfp_mask 0x112cc0(GFP_USER|__GFP_NOWARN|__GFP_NORETRY), pid 8866, tgid 8865 (syz-executor.2), ts 589707217229, free_ts 589630456902
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
>   free_unref_page_list+0x176/0xcd0 mm/page_alloc.c:3528
>   release_pages+0xcb1/0x1330 mm/swap.c:1072
>   tlb_batch_pages_flush+0xa8/0x1a0 mm/mmu_gather.c:97
>   tlb_flush_mmu_free mm/mmu_gather.c:292 [inline]
>   tlb_flush_mmu mm/mmu_gather.c:299 [inline]
>   tlb_finish_mmu+0x14b/0x7e0 mm/mmu_gather.c:391
>   exit_mmap+0x202/0x7c0 mm/mmap.c:3100
>   __mmput+0x128/0x4c0 kernel/fork.c:1212
>   mmput+0x60/0x70 kernel/fork.c:1234
>   exit_mm kernel/exit.c:563 [inline]
>   do_exit+0x9ac/0x2a90 kernel/exit.c:854
>   do_group_exit+0xd4/0x2a0 kernel/exit.c:1012
>   __do_sys_exit_group kernel/exit.c:1023 [inline]
>   __se_sys_exit_group kernel/exit.c:1021 [inline]
>   __x64_sys_exit_group+0x3e/0x50 kernel/exit.c:1021
>   do_syscall_x64 arch/x86/entry/common.c:50 [inline]
>   do_syscall_64+0x39/0xb0 arch/x86/entry/common.c:80
>   entry_SYSCALL_64_after_hwframe+0x63/0xcd
> 
> Memory state around the buggy address:
>   ffff88804ae3ef80: fc fc fc fc fc fc fc fc fc fc fc fc fc fc fc fc
>   ffff88804ae3f000: fa fb fb fb fb fb fb fb fb fb fb fb fb fb fb fb
>> ffff88804ae3f080: fb fb fb fb fb fb fb fb fb fb fb fc fc fc fc fc
>                        ^
>   ffff88804ae3f100: fc fc fc fc fc fc fc fc fb fb fb fb fb fb fb fb
>   ffff88804ae3f180: fb fb fb fb fb fb fb fb fb fb fb fb fb fb fb fb
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
