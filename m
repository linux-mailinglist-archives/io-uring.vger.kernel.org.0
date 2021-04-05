Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id A280735470A
	for <lists+io-uring@lfdr.de>; Mon,  5 Apr 2021 21:15:55 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236055AbhDETQA (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Mon, 5 Apr 2021 15:16:00 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:46638 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232387AbhDETQA (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Mon, 5 Apr 2021 15:16:00 -0400
Received: from mail-wm1-x330.google.com (mail-wm1-x330.google.com [IPv6:2a00:1450:4864:20::330])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 98556C061756;
        Mon,  5 Apr 2021 12:15:52 -0700 (PDT)
Received: by mail-wm1-x330.google.com with SMTP id j20-20020a05600c1914b029010f31e15a7fso8071141wmq.1;
        Mon, 05 Apr 2021 12:15:52 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=subject:to:references:from:autocrypt:message-id:date:user-agent
         :mime-version:in-reply-to:content-language:content-transfer-encoding;
        bh=tTzu5TiHnkfh02XAu6W17RTC/YFyRAf2y0hTYY+SROo=;
        b=FzlyMnZql1TMowAFRF4apbcHKPFpThyga7uj8P5uIewSXdpLmIN3G6VzwwNd5FLie7
         uf4ybyZqM1BDryokDHmAvw9NZJViKx0Q99PGVURyXm2HVbQG99iqO0Qr4IQZ2N9U+SPx
         7vFrt5jxl/3UERVinlhQZ5jQFxN2Zn6R4//IgnYa5pRpIDuhu/7AZOKJ/rILvPFkjn6n
         tipB2mVEzZRBWbkKKzVWVQ6US4Edha77FG/KuR5U29ezDm8Nk/EQzn20VoWFx+g6m9VT
         dIJPuNg+DXGWNJ13K2tSwpFZVMsqKJnv8UwMlEsUV9vG/6bsl8I2kScSSk7q48a1ct0X
         zb1w==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:references:from:autocrypt:message-id
         :date:user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=tTzu5TiHnkfh02XAu6W17RTC/YFyRAf2y0hTYY+SROo=;
        b=RNQkM+BrgTkIC8agLZXFc0bjR8WOri4rN6a+5tNHpBN7//KQUl6ysvkVv+hVfX78rE
         vhqoBbSAbr8+hLauKTUxgMXul4JcDI1/sDZoLoYv9M6LcbFx5Vzy7ZfhSfCFlAKUYwcG
         rqsKfznOn0hjUCx8eo46K6WhYXb2fW4rW5wxL1xHy56wZhJmBfxflkmkuo92rmEgfdTY
         hF2rNWvSxQvgSKqeG6bswE2rQk2DJplWCATFuRw/a61iuPRm6Gn3O5npURcI5UD4Y0h3
         DJ8qSqqEVwcUiifM0HmJGjmTYqz/H85/x8wSffnnoSYP9LExv6EInvn2ddsR6GTPOO2o
         /BEA==
X-Gm-Message-State: AOAM531p7YphBawDvKRl5eRz1+a8NN9f9R5gwu9SrxZDqz+h3XABOy/E
        FljVskiBE68DwwWW05Ovp8Q=
X-Google-Smtp-Source: ABdhPJx4bQ8DdGEXvpkrP5u+lLZiUlAepYZ0MpDwK1scFWvrk7dihxYlxKi+pc3WzMgtuVsa8Yl5kA==
X-Received: by 2002:a05:600c:4b86:: with SMTP id e6mr532917wmp.78.1617650151331;
        Mon, 05 Apr 2021 12:15:51 -0700 (PDT)
Received: from [192.168.8.142] ([185.69.145.134])
        by smtp.gmail.com with ESMTPSA id h63sm575688wmh.13.2021.04.05.12.15.50
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Mon, 05 Apr 2021 12:15:50 -0700 (PDT)
Subject: Re: [syzbot] INFO: task hung in io_ring_exit_work
To:     syzbot <syzbot+93f72b3885406bb09e0d@syzkaller.appspotmail.com>,
        axboe@kernel.dk, io-uring@vger.kernel.org,
        linux-kernel@vger.kernel.org, syzkaller-bugs@googlegroups.com
References: <0000000000008aed3505bf362671@google.com>
From:   Pavel Begunkov <asml.silence@gmail.com>
Autocrypt: addr=asml.silence@gmail.com; prefer-encrypt=mutual; keydata=
 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 bA==
Message-ID: <9bf45acd-39f8-8c4c-5450-76f3c2b0116e@gmail.com>
Date:   Mon, 5 Apr 2021 20:11:45 +0100
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.3.0
MIME-Version: 1.0
In-Reply-To: <0000000000008aed3505bf362671@google.com>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org

On 05/04/2021 10:16, syzbot wrote:
> Hello,
> 
> syzbot found the following issue on:
> 
> HEAD commit:    e49d033b Linux 5.12-rc6
> git tree:       upstream
> console output: https://syzkaller.appspot.com/x/log.txt?x=16217d16d00000
> kernel config:  https://syzkaller.appspot.com/x/.config?x=9320464bf47598bd
> dashboard link: https://syzkaller.appspot.com/bug?extid=93f72b3885406bb09e0d
> syz repro:      https://syzkaller.appspot.com/x/repro.syz?x=15741cfcd00000
> C reproducer:   https://syzkaller.appspot.com/x/repro.c?x=14c10a96d00000
> 
> IMPORTANT: if you fix the issue, please add the following tag to the commit:
> Reported-by: syzbot+93f72b3885406bb09e0d@syzkaller.appspotmail.com


#syz test: https://github.com/isilence/linux.git iowq_cancel_unbounded

> 
> INFO: task kworker/u4:6:3091 blocked for more than 143 seconds.
>       Not tainted 5.12.0-rc6-syzkaller #0
> "echo 0 > /proc/sys/kernel/hung_task_timeout_secs" disables this message.
> task:kworker/u4:6    state:D stack:24792 pid: 3091 ppid:     2 flags:0x00004000
> Workqueue: events_unbound io_ring_exit_work
> Call Trace:
>  context_switch kernel/sched/core.c:4322 [inline]
>  __schedule+0x911/0x21b0 kernel/sched/core.c:5073
>  schedule+0xcf/0x270 kernel/sched/core.c:5152
>  schedule_timeout+0x1db/0x250 kernel/time/timer.c:1868
>  do_wait_for_common kernel/sched/completion.c:85 [inline]
>  __wait_for_common kernel/sched/completion.c:106 [inline]
>  wait_for_common kernel/sched/completion.c:117 [inline]
>  wait_for_completion+0x168/0x270 kernel/sched/completion.c:138
>  io_ring_exit_work+0x4e8/0x12d0 fs/io_uring.c:8596
>  process_one_work+0x98d/0x1600 kernel/workqueue.c:2275
>  worker_thread+0x64c/0x1120 kernel/workqueue.c:2421
>  kthread+0x3b1/0x4a0 kernel/kthread.c:292
>  ret_from_fork+0x1f/0x30 arch/x86/entry/entry_64.S:294
> 
> Showing all locks held in the system:
> 2 locks held by kworker/u4:5/235:
>  #0: ffff888010469138 ((wq_completion)events_unbound){+.+.}-{0:0}, at: arch_atomic64_set arch/x86/include/asm/atomic64_64.h:34 [inline]
>  #0: ffff888010469138 ((wq_completion)events_unbound){+.+.}-{0:0}, at: atomic64_set include/asm-generic/atomic-instrumented.h:856 [inline]
>  #0: ffff888010469138 ((wq_completion)events_unbound){+.+.}-{0:0}, at: atomic_long_set include/asm-generic/atomic-long.h:41 [inline]
>  #0: ffff888010469138 ((wq_completion)events_unbound){+.+.}-{0:0}, at: set_work_data kernel/workqueue.c:616 [inline]
>  #0: ffff888010469138 ((wq_completion)events_unbound){+.+.}-{0:0}, at: set_work_pool_and_clear_pending kernel/workqueue.c:643 [inline]
>  #0: ffff888010469138 ((wq_completion)events_unbound){+.+.}-{0:0}, at: process_one_work+0x871/0x1600 kernel/workqueue.c:2246
>  #1: ffffc900019bfda8 ((work_completion)(&ctx->exit_work)){+.+.}-{0:0}, at: process_one_work+0x8a5/0x1600 kernel/workqueue.c:2250
> 1 lock held by khungtaskd/1630:
>  #0: ffffffff8bf74320 (rcu_read_lock){....}-{1:2}, at: debug_show_all_locks+0x53/0x260 kernel/locking/lockdep.c:6327
> 2 locks held by kworker/u4:6/3091:
>  #0: ffff888010469138 ((wq_completion)events_unbound){+.+.}-{0:0}, at: arch_atomic64_set arch/x86/include/asm/atomic64_64.h:34 [inline]
>  #0: ffff888010469138 ((wq_completion)events_unbound){+.+.}-{0:0}, at: atomic64_set include/asm-generic/atomic-instrumented.h:856 [inline]
>  #0: ffff888010469138 ((wq_completion)events_unbound){+.+.}-{0:0}, at: atomic_long_set include/asm-generic/atomic-long.h:41 [inline]
>  #0: ffff888010469138 ((wq_completion)events_unbound){+.+.}-{0:0}, at: set_work_data kernel/workqueue.c:616 [inline]
>  #0: ffff888010469138 ((wq_completion)events_unbound){+.+.}-{0:0}, at: set_work_pool_and_clear_pending kernel/workqueue.c:643 [inline]
>  #0: ffff888010469138 ((wq_completion)events_unbound){+.+.}-{0:0}, at: process_one_work+0x871/0x1600 kernel/workqueue.c:2246
>  #1: ffffc90001cbfda8 ((work_completion)(&ctx->exit_work)){+.+.}-{0:0}, at: process_one_work+0x8a5/0x1600 kernel/workqueue.c:2250
> 1 lock held by in:imklog/8101:
>  #0: ffff88801523b270 (&f->f_pos_lock){+.+.}-{3:3}, at: __fdget_pos+0xe9/0x100 fs/file.c:961
> 2 locks held by kworker/u4:1/11499:
>  #0: ffff888010469138 ((wq_completion)events_unbound){+.+.}-{0:0}, at: arch_atomic64_set arch/x86/include/asm/atomic64_64.h:34 [inline]
>  #0: ffff888010469138 ((wq_completion)events_unbound){+.+.}-{0:0}, at: atomic64_set include/asm-generic/atomic-instrumented.h:856 [inline]
>  #0: ffff888010469138 ((wq_completion)events_unbound){+.+.}-{0:0}, at: atomic_long_set include/asm-generic/atomic-long.h:41 [inline]
>  #0: ffff888010469138 ((wq_completion)events_unbound){+.+.}-{0:0}, at: set_work_data kernel/workqueue.c:616 [inline]
>  #0: ffff888010469138 ((wq_completion)events_unbound){+.+.}-{0:0}, at: set_work_pool_and_clear_pending kernel/workqueue.c:643 [inline]
>  #0: ffff888010469138 ((wq_completion)events_unbound){+.+.}-{0:0}, at: process_one_work+0x871/0x1600 kernel/workqueue.c:2246
>  #1: ffffc9000d957da8 ((work_completion)(&ctx->exit_work)){+.+.}-{0:0}, at: process_one_work+0x8a5/0x1600 kernel/workqueue.c:2250
> 2 locks held by syz-executor633/15066:
>  #0: ffff8880b9d35198 (&rq->lock){-.-.}-{2:2}, at: rq_lock kernel/sched/sched.h:1321 [inline]
>  #0: ffff8880b9d35198 (&rq->lock){-.-.}-{2:2}, at: __schedule+0x21c/0x21b0 kernel/sched/core.c:4990
>  #1: ffff8880b9d1f948 (&per_cpu_ptr(group->pcpu, cpu)->seq){-.-.}-{0:0}, at: psi_task_switch+0x305/0x440 kernel/sched/psi.c:833
> 1 lock held by syz-executor633/15068:
>  #0: ffffffff8bf7cee8 (rcu_state.exp_mutex){+.+.}-{3:3}, at: exp_funnel_lock kernel/rcu/tree_exp.h:290 [inline]
>  #0: ffffffff8bf7cee8 (rcu_state.exp_mutex){+.+.}-{3:3}, at: synchronize_rcu_expedited+0x4fa/0x620 kernel/rcu/tree_exp.h:836
> 
> =============================================
> 
> NMI backtrace for cpu 1
> CPU: 1 PID: 1630 Comm: khungtaskd Not tainted 5.12.0-rc6-syzkaller #0
> Hardware name: Google Google Compute Engine/Google Compute Engine, BIOS Google 01/01/2011
> Call Trace:
>  __dump_stack lib/dump_stack.c:79 [inline]
>  dump_stack+0x141/0x1d7 lib/dump_stack.c:120
>  nmi_cpu_backtrace.cold+0x44/0xd7 lib/nmi_backtrace.c:105
>  nmi_trigger_cpumask_backtrace+0x1b3/0x230 lib/nmi_backtrace.c:62
>  trigger_all_cpu_backtrace include/linux/nmi.h:146 [inline]
>  check_hung_uninterruptible_tasks kernel/hung_task.c:209 [inline]
>  watchdog+0xd48/0xfb0 kernel/hung_task.c:294
>  kthread+0x3b1/0x4a0 kernel/kthread.c:292
>  ret_from_fork+0x1f/0x30 arch/x86/entry/entry_64.S:294
> Sending NMI from CPU 1 to CPUs 0:
> NMI backtrace for cpu 0
> CPU: 0 PID: 8393 Comm: syz-executor633 Not tainted 5.12.0-rc6-syzkaller #0
> Hardware name: Google Google Compute Engine/Google Compute Engine, BIOS Google 01/01/2011
> RIP: 0010:wait_consider_task+0x99/0x3b40 kernel/exit.c:1288
> Code: 28 00 00 00 48 89 84 24 f0 00 00 00 31 c0 e8 ae 8e 2f 00 49 8d 8f ec 04 00 00 48 89 c8 48 89 4c 24 10 48 c1 e8 03 0f b6 14 28 <48> 89 c8 83 e0 07 83 c0 03 38 d0 7c 08 84 d2 0f 85 4b 1d 00 00 45
> RSP: 0018:ffffc9000146fb20 EFLAGS: 00000a07
> RAX: 1ffff11015477b35 RBX: 0000000000000000 RCX: ffff8880aa3bd9ac
> RDX: 0000000000000000 RSI: ffffffff814462a2 RDI: ffffc9000146fd20
> RBP: dffffc0000000000 R08: 0000000000000000 R09: ffffffff8bc0a083
> R10: ffffffff8144a0e2 R11: 0000000000000001 R12: ffffc9000146fd20
> R13: ffff888020ff9c40 R14: 0000000000000000 R15: ffff8880aa3bd4c0
> FS:  0000000001688300(0000) GS:ffff8880b9c00000(0000) knlGS:0000000000000000
> CS:  0010 DS: 0000 ES: 0000 CR0: 0000000080050033
> CR2: 00007f42f9b4c000 CR3: 0000000025681000 CR4: 00000000001506f0
> DR0: 0000000000000000 DR1: 0000000000000000 DR2: 0000000000000000
> DR3: 0000000000000000 DR6: 00000000fffe0ff0 DR7: 0000000000000400
> Call Trace:
>  do_wait_thread kernel/exit.c:1397 [inline]
>  do_wait+0x376/0xa00 kernel/exit.c:1468
>  kernel_wait4+0x14c/0x260 kernel/exit.c:1630
>  __do_sys_wait4+0x13f/0x150 kernel/exit.c:1658
>  do_syscall_64+0x2d/0x70 arch/x86/entry/common.c:46
>  entry_SYSCALL_64_after_hwframe+0x44/0xae
> RIP: 0033:0x444d06
> Code: 0f 1f 40 00 31 c9 e9 09 00 00 00 66 0f 1f 84 00 00 00 00 00 49 89 ca 64 8b 04 25 18 00 00 00 85 c0 75 11 b8 3d 00 00 00 0f 05 <48> 3d 00 f0 ff ff 77 5a c3 90 48 83 ec 28 89 54 24 14 48 89 74 24
> RSP: 002b:00007ffe758f7cb8 EFLAGS: 00000246 ORIG_RAX: 000000000000003d
> RAX: ffffffffffffffda RBX: 00000000000d35a7 RCX: 0000000000444d06
> RDX: 0000000040000001 RSI: 00007ffe758f7ce4 RDI: 00000000ffffffff
> RBP: 00000000000019f2 R08: 0000000000000000 R09: 00007ffe75923090
> R10: 0000000000000000 R11: 0000000000000246 R12: 00007ffe758f7ce4
> R13: 00007ffe758f7d40 R14: 000000000000028f R15: 00007ffe758f7d20
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
