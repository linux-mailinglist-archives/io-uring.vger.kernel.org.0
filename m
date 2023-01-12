Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 5D63B667025
	for <lists+io-uring@lfdr.de>; Thu, 12 Jan 2023 11:47:18 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231872AbjALKrO (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Thu, 12 Jan 2023 05:47:14 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:43538 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231781AbjALKqP (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Thu, 12 Jan 2023 05:46:15 -0500
Received: from mail-wr1-x430.google.com (mail-wr1-x430.google.com [IPv6:2a00:1450:4864:20::430])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id E96DD5951B;
        Thu, 12 Jan 2023 02:39:48 -0800 (PST)
Received: by mail-wr1-x430.google.com with SMTP id bn26so17662728wrb.0;
        Thu, 12 Jan 2023 02:39:48 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=content-transfer-encoding:in-reply-to:from:references:to
         :content-language:subject:user-agent:mime-version:date:message-id
         :from:to:cc:subject:date:message-id:reply-to;
        bh=byw1rrNpJ6Z3f9KPEBNbtWL4cD48bu1uksgV7TXAdVk=;
        b=QGhU437myqPQmLP7n1v4LO1lP5iyF+NSXfiNuyJy2wRJukxJ1wnVF7iC741P+F2Bb3
         Bd5dnMwe38NFeNSnhCsyUhac4owZ+Yp5cqYD9hKYUYE2S8wk6CAHkGgrq3RqS6pPMRpo
         MX0+wBYdQ9dUwNaZgCocNLTkieVIAlzRB3uyKy8wU2s9dVcEYgzY6XzB77im5Y7ExqNH
         ubN2Zh4Y+pCdWURH9r4pIx+uy1DDEL0RvpQJV5aEA3+z4WGfV8Hm5cb/jk3p3BdJugBG
         tIAvywGW8bWxeI7YqXEnZ5rogCBpNL/1QxvIuhLNXvl7O9IJYuBl7TQoWr11PaI2/NGi
         na9Q==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=content-transfer-encoding:in-reply-to:from:references:to
         :content-language:subject:user-agent:mime-version:date:message-id
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=byw1rrNpJ6Z3f9KPEBNbtWL4cD48bu1uksgV7TXAdVk=;
        b=0vBwknOTOs/oTDSDdJfDonHgxL4fYPhahBZBbOCLDmlyDXxx9o/R0jjlb5P7kORNmn
         u7l1ATVHIaOWibKtK3rPBnGAgMljkubXgIgU8rXdAbAE++t0tvhwH2700MIFQDZBxuD5
         tEDXN8IbKoIVFGS07UJonAlMiheCJ4M3rgartLgWApobPKsOr4vwkJT8xx1pcPajKSGj
         2B10ObPCIcBAdAJdfjtReE7TjDeJgqRA1HUK/ITNkhNYHPGB5CnboZr3z/9IC3lHIH2+
         FmzKf7ZqjB/w/dwpej5dHPlTJVOOEXiT61GApSjcUpVUV3YVg1E7XsdHXcFmB+DMrmK4
         ssRw==
X-Gm-Message-State: AFqh2krNu5WMCHf41Fm9w9lHN33VMH6EfwYE06S5JUXU0C/ItyyPOaF/
        h2aFb6VO8T4kT8aysI0sZ+WXqoeZXrY=
X-Google-Smtp-Source: AMrXdXvZ75oFcwstAfEoXIfEyRfDIDXm4vK9P+rt4cbGykKOr6t6ZEJ/fYKHQkfF+8Pr3aqByrTh2Q==
X-Received: by 2002:adf:ecc1:0:b0:26e:666:3a08 with SMTP id s1-20020adfecc1000000b0026e06663a08mr48835323wro.69.1673519987462;
        Thu, 12 Jan 2023 02:39:47 -0800 (PST)
Received: from ?IPV6:2620:10d:c096:310::21ef? ([2620:10d:c092:600::2:478])
        by smtp.gmail.com with ESMTPSA id j11-20020adfd20b000000b0024207478de3sm16129134wrh.93.2023.01.12.02.39.46
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Thu, 12 Jan 2023 02:39:47 -0800 (PST)
Message-ID: <24c14545-53ee-7217-0eab-584516f8dbed@gmail.com>
Date:   Thu, 12 Jan 2023 10:38:19 +0000
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:102.0) Gecko/20100101
 Thunderbird/102.5.1
Subject: Re: [syzbot] KASAN: use-after-free Read in __io_req_task_work_add
Content-Language: en-US
To:     syzbot <syzbot+01db4d8aed628ede44b1@syzkaller.appspotmail.com>,
        axboe@kernel.dk, io-uring@vger.kernel.org,
        linux-kernel@vger.kernel.org, syzkaller-bugs@googlegroups.com
References: <000000000000044bca05f20e8e16@google.com>
From:   Pavel Begunkov <asml.silence@gmail.com>
In-Reply-To: <000000000000044bca05f20e8e16@google.com>
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

On 1/12/23 10:26, syzbot wrote:
> Hello,
> 
> syzbot found the following issue on:
> 
> HEAD commit:    0a093b2893c7 Add linux-next specific files for 20230112
> git tree:       linux-next
> console output: https://syzkaller.appspot.com/x/log.txt?x=111a5a86480000
> kernel config:  https://syzkaller.appspot.com/x/.config?x=835f3591019836d5
> dashboard link: https://syzkaller.appspot.com/bug?extid=01db4d8aed628ede44b1
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
> Reported-by: syzbot+01db4d8aed628ede44b1@syzkaller.appspotmail.com
> 
> ==================================================================
> BUG: KASAN: use-after-free in __io_req_task_work_add+0x6b4/0x760 io_uring/io_uring.c:1287
> Read of size 8 at addr ffff888027236018 by task syz-executor.3/11047
> 
> CPU: 0 PID: 11047 Comm: syz-executor.3 Not tainted 6.2.0-rc3-next-20230112-syzkaller #0
> Hardware name: Google Google Compute Engine/Google Compute Engine, BIOS Google 10/26/2022
> Call Trace:
>   <TASK>
>   __dump_stack lib/dump_stack.c:88 [inline]
>   dump_stack_lvl+0xd1/0x138 lib/dump_stack.c:106
>   print_address_description mm/kasan/report.c:306 [inline]
>   print_report+0x15e/0x45d mm/kasan/report.c:417
>   kasan_report+0xc0/0xf0 mm/kasan/report.c:517
>   __io_req_task_work_add+0x6b4/0x760 io_uring/io_uring.c:1287
>   io_req_task_work_add io_uring/io_uring.h:95 [inline]
>   __io_poll_execute io_uring/poll.c:366 [inline]
>   io_poll_execute.constprop.0+0x15b/0x190 io_uring/poll.c:372
>   io_poll_cancel_req io_uring/poll.c:379 [inline]
>   io_poll_remove_all_table+0x26d/0x2bd io_uring/poll.c:741
>   io_poll_remove_all+0x2e/0x4b io_uring/poll.c:759
>   io_ring_ctx_wait_and_kill+0x1a0/0x340 io_uring/io_uring.c:3017
>   io_uring_release+0x46/0x4a io_uring/io_uring.c:3042
>   __fput+0x27c/0xa90 fs/file_table.c:321
>   task_work_run+0x16f/0x270 kernel/task_work.c:179
>   exit_task_work include/linux/task_work.h:38 [inline]
>   do_exit+0xb17/0x2a90 kernel/exit.c:867
>   do_group_exit+0xd4/0x2a0 kernel/exit.c:1012
>   __do_sys_exit_group kernel/exit.c:1023 [inline]
>   __se_sys_exit_group kernel/exit.c:1021 [inline]
>   __x64_sys_exit_group+0x3e/0x50 kernel/exit.c:1021
>   do_syscall_x64 arch/x86/entry/common.c:50 [inline]
>   do_syscall_64+0x39/0xb0 arch/x86/entry/common.c:80
>   entry_SYSCALL_64_after_hwframe+0x63/0xcd
> RIP: 0033:0x7fd01608c0c9
> Code: Unable to access opcode bytes at 0x7fd01608c09f.
> RSP: 002b:00007ffe4aaf8e78 EFLAGS: 00000246 ORIG_RAX: 00000000000000e7
> RAX: ffffffffffffffda RBX: 000000000000001e RCX: 00007fd01608c0c9
> RDX: 00007fd01603df7b RSI: ffffffffffffffb8 RDI: 0000000000000000
> RBP: 0000000000000000 R08: 0000000023b38e02 R09: 0000000000000000
> R10: 0000000000000000 R11: 0000000000000246 R12: 0000000000000001
> R13: 0000000000000000 R14: 0000000000000001 R15: 00007ffe4aaf8f60
>   </TASK>
> 
> Allocated by task 11047:
>   kasan_save_stack+0x22/0x40 mm/kasan/common.c:45
>   kasan_set_track+0x25/0x30 mm/kasan/common.c:52
>   __kasan_slab_alloc+0x7f/0x90 mm/kasan/common.c:325
>   kasan_slab_alloc include/linux/kasan.h:186 [inline]
>   slab_post_alloc_hook mm/slab.h:769 [inline]
>   slab_alloc_node mm/slub.c:3452 [inline]
>   kmem_cache_alloc_node+0x183/0x350 mm/slub.c:3497
>   alloc_task_struct_node kernel/fork.c:171 [inline]
>   dup_task_struct kernel/fork.c:979 [inline]
>   copy_process+0x3aa/0x7740 kernel/fork.c:2103
>   kernel_clone+0xeb/0x9a0 kernel/fork.c:2687
>   __do_sys_clone+0xba/0x100 kernel/fork.c:2828
>   do_syscall_x64 arch/x86/entry/common.c:50 [inline]
>   do_syscall_64+0x39/0xb0 arch/x86/entry/common.c:80
>   entry_SYSCALL_64_after_hwframe+0x63/0xcd
> 
> Freed by task 15:
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
>   put_task_struct include/linux/sched/task.h:119 [inline]
>   delayed_put_task_struct+0x26e/0x3f0 kernel/exit.c:225
>   rcu_do_batch kernel/rcu/tree.c:2113 [inline]
>   rcu_core+0x821/0x1920 kernel/rcu/tree.c:2373
>   __do_softirq+0x1fb/0xaf6 kernel/softirq.c:571
> 
> Last potentially related work creation:
>   kasan_save_stack+0x22/0x40 mm/kasan/common.c:45
>   __kasan_record_aux_stack+0xbc/0xd0 mm/kasan/generic.c:488
>   __call_rcu_common.constprop.0+0x99/0x780 kernel/rcu/tree.c:2622
>   put_task_struct_rcu_user+0x83/0xc0 kernel/exit.c:231
>   context_switch kernel/sched/core.c:5304 [inline]
>   __schedule+0x25d8/0x5a70 kernel/sched/core.c:6619
>   preempt_schedule_common+0x45/0xc0 kernel/sched/core.c:6788
>   preempt_schedule_thunk+0x1a/0x20 arch/x86/entry/thunk_64.S:34
>   __raw_spin_unlock_irq include/linux/spinlock_api_smp.h:160 [inline]
>   _raw_spin_unlock_irq+0x40/0x50 kernel/locking/spinlock.c:202
>   spin_unlock_irq include/linux/spinlock.h:400 [inline]
>   do_group_exit+0x1c5/0x2a0 kernel/exit.c:1009
>   __do_sys_exit_group kernel/exit.c:1023 [inline]
>   __se_sys_exit_group kernel/exit.c:1021 [inline]
>   __x64_sys_exit_group+0x3e/0x50 kernel/exit.c:1021
>   do_syscall_x64 arch/x86/entry/common.c:50 [inline]
>   do_syscall_64+0x39/0xb0 arch/x86/entry/common.c:80
>   entry_SYSCALL_64_after_hwframe+0x63/0xcd
> 
> Second to last potentially related work creation:
>   kasan_save_stack+0x22/0x40 mm/kasan/common.c:45
>   __kasan_record_aux_stack+0xbc/0xd0 mm/kasan/generic.c:488
>   __call_rcu_common.constprop.0+0x99/0x780 kernel/rcu/tree.c:2622
>   put_task_struct_rcu_user+0x83/0xc0 kernel/exit.c:231
>   release_task+0xcc8/0x1870 kernel/exit.c:281
>   wait_task_zombie kernel/exit.c:1198 [inline]
>   wait_consider_task+0x306d/0x3ce0 kernel/exit.c:1425
>   do_wait_thread kernel/exit.c:1488 [inline]
>   do_wait+0x7cd/0xd90 kernel/exit.c:1605
>   kernel_wait4+0x150/0x260 kernel/exit.c:1768
>   __do_sys_wait4+0x13f/0x150 kernel/exit.c:1796
>   do_syscall_x64 arch/x86/entry/common.c:50 [inline]
>   do_syscall_64+0x39/0xb0 arch/x86/entry/common.c:80
>   entry_SYSCALL_64_after_hwframe+0x63/0xcd
> 
> The buggy address belongs to the object at ffff8880272357c0
>   which belongs to the cache task_struct of size 7232
> The buggy address is located 2136 bytes inside of
>   7232-byte region [ffff8880272357c0, ffff888027237400)
> 
> The buggy address belongs to the physical page:
> page:ffffea00009c8c00 refcount:1 mapcount:0 mapping:0000000000000000 index:0x0 pfn:0x27230
> head:ffffea00009c8c00 order:3 entire_mapcount:0 nr_pages_mapped:0 pincount:0
> memcg:ffff8880219a5c01
> ksm flags: 0xfff00000010200(slab|head|node=0|zone=1|lastcpupid=0x7ff)
> raw: 00fff00000010200 ffff8880125ec500 ffffea0000ab3800 dead000000000003
> raw: 0000000000000000 0000000000040004 00000001ffffffff ffff8880219a5c01
> page dumped because: kasan: bad access detected
> page_owner tracks the page as allocated
> page last allocated via order 3, migratetype Unmovable, gfp_mask 0xd20c0(__GFP_IO|__GFP_FS|__GFP_NOWARN|__GFP_NORETRY|__GFP_COMP|__GFP_NOMEMALLOC), pid 56, tgid 56 (kworker/u4:4), ts 11164250893, free_ts 0
>   prep_new_page mm/page_alloc.c:2549 [inline]
>   get_page_from_freelist+0x11bb/0x2d50 mm/page_alloc.c:4324
>   __alloc_pages+0x1cb/0x5c0 mm/page_alloc.c:5590
>   alloc_pages+0x1aa/0x270 mm/mempolicy.c:2281
>   alloc_slab_page mm/slub.c:1851 [inline]
>   allocate_slab+0x25f/0x350 mm/slub.c:1998
>   new_slab mm/slub.c:2051 [inline]
>   ___slab_alloc+0xa91/0x1400 mm/slub.c:3193
>   __slab_alloc.constprop.0+0x56/0xa0 mm/slub.c:3292
>   __slab_alloc_node mm/slub.c:3345 [inline]
>   slab_alloc_node mm/slub.c:3442 [inline]
>   kmem_cache_alloc_node+0x136/0x350 mm/slub.c:3497
>   alloc_task_struct_node kernel/fork.c:171 [inline]
>   dup_task_struct kernel/fork.c:979 [inline]
>   copy_process+0x3aa/0x7740 kernel/fork.c:2103
>   kernel_clone+0xeb/0x9a0 kernel/fork.c:2687
>   user_mode_thread+0xb1/0xf0 kernel/fork.c:2763
>   call_usermodehelper_exec_work kernel/umh.c:175 [inline]
>   call_usermodehelper_exec_work+0xd0/0x180 kernel/umh.c:161
>   process_one_work+0x9bf/0x1750 kernel/workqueue.c:2293
>   worker_thread+0x669/0x1090 kernel/workqueue.c:2440
>   kthread+0x2e8/0x3a0 kernel/kthread.c:376
>   ret_from_fork+0x1f/0x30 arch/x86/entry/entry_64.S:308
> page_owner free stack trace missing
> 
> Memory state around the buggy address:
>   ffff888027235f00: fb fb fb fb fb fb fb fb fb fb fb fb fb fb fb fb
>   ffff888027235f80: fb fb fb fb fb fb fb fb fb fb fb fb fb fb fb fb
>> ffff888027236000: fb fb fb fb fb fb fb fb fb fb fb fb fb fb fb fb
>                              ^
>   ffff888027236080: fb fb fb fb fb fb fb fb fb fb fb fb fb fb fb fb
>   ffff888027236100: fb fb fb fb fb fb fb fb fb fb fb fb fb fb fb fb
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
