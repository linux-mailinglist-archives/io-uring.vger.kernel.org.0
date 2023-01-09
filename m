Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 196F6662694
	for <lists+io-uring@lfdr.de>; Mon,  9 Jan 2023 14:12:13 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230415AbjAINLk (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Mon, 9 Jan 2023 08:11:40 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:58490 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S237016AbjAINLU (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Mon, 9 Jan 2023 08:11:20 -0500
Received: from mail-ej1-x62c.google.com (mail-ej1-x62c.google.com [IPv6:2a00:1450:4864:20::62c])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id BD80BCE9;
        Mon,  9 Jan 2023 05:10:11 -0800 (PST)
Received: by mail-ej1-x62c.google.com with SMTP id az20so869828ejc.1;
        Mon, 09 Jan 2023 05:10:11 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=content-transfer-encoding:in-reply-to:from:references:to
         :content-language:subject:user-agent:mime-version:date:message-id
         :from:to:cc:subject:date:message-id:reply-to;
        bh=VEKfW1MMz+xi7SiDhu3RvNMDCXxNl1B3fl7jdPgIA40=;
        b=pE0CoIyaTHrtkeQMfmlLkYuEUEyQm++6fO2vy3/YIsBluQeRiLqwmH5JT9jRBItQFc
         +JSuIjOCbmN9qOnysfbnprmwMKj1g1mU02i4JDYUN/S90wZVeIFOsyumBSuT1/UjsuEN
         zMwJA4Q5Ox0kTJK72amRGWa08j8GpnNU9y9vIn1HVCfvMimz5+FS1QeyWqV80wmoAtHz
         xwsgqDLGQ/2b8SwHKKKFyZtTFe63MpwXyfVyHPYvTxorKJLxi+7woT9trRYftjINeO3S
         amSzFsgD60OwET0tUA9MOwjJQEHSWEObUQ0/n6pawJlB4u18GZT1tUL5RZS6iJMpxznR
         69YA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=content-transfer-encoding:in-reply-to:from:references:to
         :content-language:subject:user-agent:mime-version:date:message-id
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=VEKfW1MMz+xi7SiDhu3RvNMDCXxNl1B3fl7jdPgIA40=;
        b=HUWC/YEUN/RJ1ru3odc+iArOlVX0NOQhwF++LhcnTyr9QfYb4MSwTlPR/YzCstnPHN
         iKHxiPJvA8k7DA575SO/UZqzqpg1tz21Y4tVv/mBVi/yWPduyutnJ4LCkF+qTozM0iAn
         jjO3YXSJAEM4M11+l4igbtONbgo8tPrG2YBjAz6fFSIsZofTcGgZINd11gukMS5Pquyo
         KcSo6cJzBd5HE++4zQaSZ5NLDSjiqfHgzkzGrUaFyPcUDSj9RnW6uSofYZVLhMkH5JrD
         YcAipfKBg7J1lJxnn3YiZJITqiBzsm5Nh2sh0rpDjgOr6792UuGT/51ftQaYzOaYrewl
         rNEQ==
X-Gm-Message-State: AFqh2kr0ASrUE8nV15StdISDz+dgopPuz9gs3xoNgHxH20QjAhH4l0/4
        0fFElKhYkrLzI7wFt6HEe86ZAQuIqMA=
X-Google-Smtp-Source: AMrXdXtslCAMVEwgLYOiBBPoi29MNYqfvzX1tv2CkYQv5NZksL4vpWNYy8jj3ZO2RVspnYtUtOPWfg==
X-Received: by 2002:a17:906:3095:b0:7be:fb2c:c112 with SMTP id 21-20020a170906309500b007befb2cc112mr52434298ejv.66.1673269810136;
        Mon, 09 Jan 2023 05:10:10 -0800 (PST)
Received: from [192.168.8.100] (188.29.102.7.threembb.co.uk. [188.29.102.7])
        by smtp.gmail.com with ESMTPSA id fm19-20020a1709072ad300b007c16430e5c8sm3771169ejc.92.2023.01.09.05.10.09
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Mon, 09 Jan 2023 05:10:09 -0800 (PST)
Message-ID: <36d665d6-3cd7-ffa8-da4f-1ceb67052ce7@gmail.com>
Date:   Mon, 9 Jan 2023 13:09:13 +0000
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:102.0) Gecko/20100101
 Thunderbird/102.5.1
Subject: Re: [syzbot] KASAN: use-after-free Read in io_wqe_worker (2)
Content-Language: en-US
To:     syzbot <syzbot+ad53b671c30ddaba634d@syzkaller.appspotmail.com>,
        axboe@kernel.dk, io-uring@vger.kernel.org,
        linux-kernel@vger.kernel.org, syzkaller-bugs@googlegroups.com
References: <0000000000009bff3c05f1ce87f1@google.com>
From:   Pavel Begunkov <asml.silence@gmail.com>
In-Reply-To: <0000000000009bff3c05f1ce87f1@google.com>
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

On 1/9/23 06:03, syzbot wrote:
> Hello,
> 
> syzbot found the following issue on:

#syz test: git://git.kernel.dk/linux.git syztest

> 
> HEAD commit:    9b43a525db12 Merge tag 'nfs-for-6.2-2' of git://git.linux-..
> git tree:       upstream
> console output: https://syzkaller.appspot.com/x/log.txt?x=161784d2480000
> kernel config:  https://syzkaller.appspot.com/x/.config?x=ff5cf657dd0e7643
> dashboard link: https://syzkaller.appspot.com/bug?extid=ad53b671c30ddaba634d
> compiler:       gcc (Debian 10.2.1-6) 10.2.1 20210110, GNU ld (GNU Binutils for Debian) 2.35.2
> syz repro:      https://syzkaller.appspot.com/x/repro.syz?x=160480ba480000
> C reproducer:   https://syzkaller.appspot.com/x/repro.c?x=14cddc6a480000
> 
> Downloadable assets:
> disk image: https://storage.googleapis.com/syzbot-assets/ddf8271f0077/disk-9b43a525.raw.xz
> vmlinux: https://storage.googleapis.com/syzbot-assets/5a43fe665720/vmlinux-9b43a525.xz
> kernel image: https://storage.googleapis.com/syzbot-assets/323f0f0f7267/bzImage-9b43a525.xz
> 
> IMPORTANT: if you fix the issue, please add the following tag to the commit:
> Reported-by: syzbot+ad53b671c30ddaba634d@syzkaller.appspotmail.com
> 
> ==================================================================
> BUG: KASAN: use-after-free in __list_del_entry_valid+0xec/0x110 lib/list_debug.c:62
> Read of size 8 at addr ffff88807ba8f020 by task iou-wrk-10331/10338
> 
> CPU: 0 PID: 10338 Comm: iou-wrk-10331 Not tainted 6.2.0-rc2-syzkaller-00313-g9b43a525db12 #0
> Hardware name: Google Google Compute Engine/Google Compute Engine, BIOS Google 10/26/2022
> Call Trace:
>   <TASK>
>   __dump_stack lib/dump_stack.c:88 [inline]
>   dump_stack_lvl+0xd1/0x138 lib/dump_stack.c:106
>   print_address_description mm/kasan/report.c:306 [inline]
>   print_report+0x15e/0x45d mm/kasan/report.c:417
>   kasan_report+0xbf/0x1f0 mm/kasan/report.c:517
>   __list_del_entry_valid+0xec/0x110 lib/list_debug.c:62
>   __list_del_entry include/linux/list.h:134 [inline]
>   list_del_rcu include/linux/rculist.h:157 [inline]
>   io_worker_exit io_uring/io-wq.c:229 [inline]
>   io_wqe_worker+0x852/0xe40 io_uring/io-wq.c:661
>   ret_from_fork+0x1f/0x30 arch/x86/entry/entry_64.S:308
>   </TASK>
> 
> Allocated by task 10331:
>   kasan_save_stack+0x22/0x40 mm/kasan/common.c:45
>   kasan_set_track+0x25/0x30 mm/kasan/common.c:52
>   ____kasan_kmalloc mm/kasan/common.c:371 [inline]
>   ____kasan_kmalloc mm/kasan/common.c:330 [inline]
>   __kasan_kmalloc+0xa5/0xb0 mm/kasan/common.c:380
>   kmalloc_node include/linux/slab.h:606 [inline]
>   kzalloc_node include/linux/slab.h:731 [inline]
>   create_io_worker+0x10c/0x630 io_uring/io-wq.c:801
>   io_wqe_create_worker io_uring/io-wq.c:310 [inline]
>   io_wqe_enqueue+0x6c3/0xbc0 io_uring/io-wq.c:936
>   io_queue_iowq+0x282/0x5c0 io_uring/io_uring.c:475
>   io_queue_sqe_fallback+0xf3/0x190 io_uring/io_uring.c:2059
>   io_submit_sqe io_uring/io_uring.c:2281 [inline]
>   io_submit_sqes+0x11db/0x1e60 io_uring/io_uring.c:2397
>   __do_sys_io_uring_enter+0xc1d/0x2540 io_uring/io_uring.c:3345
>   do_syscall_x64 arch/x86/entry/common.c:50 [inline]
>   do_syscall_64+0x39/0xb0 arch/x86/entry/common.c:80
>   entry_SYSCALL_64_after_hwframe+0x63/0xcd
> 
> Last potentially related work creation:
>   kasan_save_stack+0x22/0x40 mm/kasan/common.c:45
>   __kasan_record_aux_stack+0xbc/0xd0 mm/kasan/generic.c:488
>   task_work_add+0x7f/0x2c0 kernel/task_work.c:48
>   io_queue_worker_create+0x41d/0x660 io_uring/io-wq.c:373
>   io_wqe_dec_running+0x1e4/0x240 io_uring/io-wq.c:410
>   io_wq_worker_sleeping+0xa6/0xc0 io_uring/io-wq.c:698
>   sched_submit_work kernel/sched/core.c:6597 [inline]
>   schedule+0x16e/0x1b0 kernel/sched/core.c:6628
>   schedule_preempt_disabled+0x13/0x20 kernel/sched/core.c:6690
>   __mutex_lock_common kernel/locking/mutex.c:679 [inline]
>   __mutex_lock+0xa48/0x1360 kernel/locking/mutex.c:747
>   io_ring_submit_lock io_uring/io_uring.h:215 [inline]
>   io_file_get_fixed io_uring/io_uring.c:1966 [inline]
>   io_assign_file io_uring/io_uring.c:1834 [inline]
>   io_assign_file io_uring/io_uring.c:1828 [inline]
>   io_wq_submit_work+0x5f7/0xdc0 io_uring/io_uring.c:1916
>   io_worker_handle_work+0xc41/0x1c60 io_uring/io-wq.c:587
>   io_wqe_worker+0xa5b/0xe40 io_uring/io-wq.c:632
>   ret_from_fork+0x1f/0x30 arch/x86/entry/entry_64.S:308
> 
> The buggy address belongs to the object at ffff88807ba8f000
>   which belongs to the cache kmalloc-512 of size 512
> The buggy address is located 32 bytes inside of
>   512-byte region [ffff88807ba8f000, ffff88807ba8f200)
> 
> The buggy address belongs to the physical page:
> page:ffffea0001eea300 refcount:1 mapcount:0 mapping:0000000000000000 index:0x0 pfn:0x7ba8c
> head:ffffea0001eea300 order:2 compound_mapcount:0 subpages_mapcount:0 compound_pincount:0
> flags: 0xfff00000010200(slab|head|node=0|zone=1|lastcpupid=0x7ff)
> raw: 00fff00000010200 ffff888012441c80 dead000000000122 0000000000000000
> raw: 0000000000000000 0000000000100010 00000001ffffffff 0000000000000000
> page dumped because: kasan: bad access detected
> page_owner tracks the page as allocated
> page last allocated via order 2, migratetype Unmovable, gfp_mask 0xd20c0(__GFP_IO|__GFP_FS|__GFP_NOWARN|__GFP_NORETRY|__GFP_COMP|__GFP_NOMEMALLOC), pid 10143, tgid 10077 (syz-executor429), ts 196666481357, free_ts 195660604482
>   prep_new_page mm/page_alloc.c:2531 [inline]
>   get_page_from_freelist+0x119c/0x2ce0 mm/page_alloc.c:4283
>   __alloc_pages+0x1cb/0x5b0 mm/page_alloc.c:5549
>   __alloc_pages_node include/linux/gfp.h:237 [inline]
>   alloc_slab_page mm/slub.c:1853 [inline]
>   allocate_slab+0xa7/0x350 mm/slub.c:1998
>   new_slab mm/slub.c:2051 [inline]
>   ___slab_alloc+0xa91/0x1400 mm/slub.c:3193
>   __slab_alloc.constprop.0+0x56/0xa0 mm/slub.c:3292
>   __slab_alloc_node mm/slub.c:3345 [inline]
>   slab_alloc_node mm/slub.c:3442 [inline]
>   __kmem_cache_alloc_node+0x1a4/0x430 mm/slub.c:3491
>   kmalloc_node_trace+0x21/0x60 mm/slab_common.c:1075
>   kmalloc_node include/linux/slab.h:606 [inline]
>   kzalloc_node include/linux/slab.h:731 [inline]
>   create_io_worker+0x10c/0x630 io_uring/io-wq.c:801
>   io_wqe_create_worker io_uring/io-wq.c:310 [inline]
>   io_wqe_enqueue+0x6c3/0xbc0 io_uring/io-wq.c:936
>   io_queue_iowq+0x282/0x5c0 io_uring/io_uring.c:475
>   io_queue_sqe_fallback+0xf3/0x190 io_uring/io_uring.c:2059
>   io_submit_sqe io_uring/io_uring.c:2281 [inline]
>   io_submit_sqes+0x11db/0x1e60 io_uring/io_uring.c:2397
>   __do_sys_io_uring_enter+0xc1d/0x2540 io_uring/io_uring.c:3345
>   do_syscall_x64 arch/x86/entry/common.c:50 [inline]
>   do_syscall_64+0x39/0xb0 arch/x86/entry/common.c:80
>   entry_SYSCALL_64_after_hwframe+0x63/0xcd
> page last free stack trace:
>   reset_page_owner include/linux/page_owner.h:24 [inline]
>   free_pages_prepare mm/page_alloc.c:1446 [inline]
>   free_pcp_prepare+0x65c/0xc00 mm/page_alloc.c:1496
>   free_unref_page_prepare mm/page_alloc.c:3369 [inline]
>   free_unref_page+0x1d/0x490 mm/page_alloc.c:3464
>   __unfreeze_partials+0x17c/0x1a0 mm/slub.c:2637
>   qlink_free mm/kasan/quarantine.c:168 [inline]
>   qlist_free_all+0x6a/0x170 mm/kasan/quarantine.c:187
>   kasan_quarantine_reduce+0x192/0x220 mm/kasan/quarantine.c:294
>   __kasan_slab_alloc+0x66/0x90 mm/kasan/common.c:302
>   kasan_slab_alloc include/linux/kasan.h:201 [inline]
>   slab_post_alloc_hook mm/slab.h:761 [inline]
>   slab_alloc_node mm/slub.c:3452 [inline]
>   slab_alloc mm/slub.c:3460 [inline]
>   __kmem_cache_alloc_lru mm/slub.c:3467 [inline]
>   kmem_cache_alloc+0x1e4/0x430 mm/slub.c:3476
>   kmem_cache_zalloc include/linux/slab.h:710 [inline]
>   taskstats_tgid_alloc kernel/taskstats.c:583 [inline]
>   taskstats_exit+0x5f3/0xb80 kernel/taskstats.c:622
>   do_exit+0x822/0x2950 kernel/exit.c:852
>   do_group_exit+0xd4/0x2a0 kernel/exit.c:1012
>   __do_sys_exit_group kernel/exit.c:1023 [inline]
>   __se_sys_exit_group kernel/exit.c:1021 [inline]
>   __x64_sys_exit_group+0x3e/0x50 kernel/exit.c:1021
>   do_syscall_x64 arch/x86/entry/common.c:50 [inline]
>   do_syscall_64+0x39/0xb0 arch/x86/entry/common.c:80
>   entry_SYSCALL_64_after_hwframe+0x63/0xcd
> 
> Memory state around the buggy address:
>   ffff88807ba8ef00: fc fc fc fc fc fc fc fc fc fc fc fc fc fc fc fc
>   ffff88807ba8ef80: fc fc fc fc fc fc fc fc fc fc fc fc fc fc fc fc
>> ffff88807ba8f000: fb fb fb fb fb fb fb fb fb fb fb fb fb fb fb fb
>                                 ^
>   ffff88807ba8f080: fb fb fb fb fb fb fb fb fb fb fb fb fb fb fb fb
>   ffff88807ba8f100: fb fb fb fb fb fb fb fb fb fb fb fb fb fb fb fb
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
