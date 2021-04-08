Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 1E4133584DA
	for <lists+io-uring@lfdr.de>; Thu,  8 Apr 2021 15:39:16 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231255AbhDHNjZ (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Thu, 8 Apr 2021 09:39:25 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:40986 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231195AbhDHNjZ (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Thu, 8 Apr 2021 09:39:25 -0400
Received: from mail-wr1-x42c.google.com (mail-wr1-x42c.google.com [IPv6:2a00:1450:4864:20::42c])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 8C06CC061760;
        Thu,  8 Apr 2021 06:39:13 -0700 (PDT)
Received: by mail-wr1-x42c.google.com with SMTP id e12so2176312wro.11;
        Thu, 08 Apr 2021 06:39:13 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=to:references:from:autocrypt:subject:message-id:date:user-agent
         :mime-version:in-reply-to:content-language:content-transfer-encoding;
        bh=FHdopgoMhqQHJWzkSIk2QAZRie07t8rOJOKrScTVhU4=;
        b=HLUy7yTqdxDi7dir6acRxZVAZ7Vq2VE3dPha8VuNN+6BRa2i7hMBUX4SYXhCBIJVqg
         rn71QvB4qZzNN3Dwq/W1+0n3rkFugESn1oQaF9w3jRdMZZezqoW6ugk7tLtXl9yglB+b
         jF7tCGQfBQt08x/glk50+jC2DmxbzUqpF9hSCn32gj0CPdJYwUs51i7kRs3IgnaENPAG
         uD5YGD60CfZkIJQe8x8WFILT+IWLyfjBHmJX9ja0vuVI8v1AC9jbxd/YOJFfrFriL3NS
         WpbqZkONq0yYtEZKAFnZBw+W9fOGLJS72HYrLSER7V12270uiY5bmqBEgJbNpGPy1JdA
         lg3Q==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:to:references:from:autocrypt:subject:message-id
         :date:user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=FHdopgoMhqQHJWzkSIk2QAZRie07t8rOJOKrScTVhU4=;
        b=b0t74Epr4EvKPh0aVa32g/EyV8Z/uGAJKYKOir3v452ttY1fJ8Aj16FoSIuYuqCW8q
         DT2q18dkK6jC33Rzsh+fDqoNFthwzEh5zefPWKIk8hM7adXhsMcBV+iUO6f0AwT3SGev
         I8xO/nnvssq2L4Js5Tj+SKXrD6HqMom4DXotIEzpCIaXIPw5AVgj/UZW0Jfz6BnymEdD
         uIWjozrLfYWaSRXjThZkDlbChPy8llhtb0ZE7HxUNIu6GXL1LY+ysbxl5wt1FU/xXVFb
         1EaPDxvJ0nn7kn1JIcnL/sMRMApYS4/pshEi7cfZOpYo00VCsN0oLOFytQI1fwURvnDV
         a8Cw==
X-Gm-Message-State: AOAM5324Mn2ANNRG2AsSiMrgB5D8PSfLP3jk8RCLdwXm2chX4wH08rSK
        93QE9ajfoszarN/+XCnVioE=
X-Google-Smtp-Source: ABdhPJxcK/ujQmgB5tUCsoHJwUiLJ4LJt8iigpdhauMtA53qehSX8fy26CCzxR+Kz8RJ7y1bF/2Gxg==
X-Received: by 2002:a5d:6550:: with SMTP id z16mr11476298wrv.366.1617889152056;
        Thu, 08 Apr 2021 06:39:12 -0700 (PDT)
Received: from [192.168.8.158] ([148.252.128.224])
        by smtp.gmail.com with ESMTPSA id g189sm12187504wmf.14.2021.04.08.06.39.10
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Thu, 08 Apr 2021 06:39:11 -0700 (PDT)
To:     syzbot <syzbot+93f72b3885406bb09e0d@syzkaller.appspotmail.com>,
        axboe@kernel.dk, io-uring@vger.kernel.org,
        linux-kernel@vger.kernel.org, syzkaller-bugs@googlegroups.com
References: <000000000000933dd705bf6efd97@google.com>
From:   Pavel Begunkov <asml.silence@gmail.com>
Autocrypt: addr=asml.silence@gmail.com; prefer-encrypt=mutual; keydata=
 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 bA==
Subject: Re: [syzbot] INFO: task hung in io_ring_exit_work
Message-ID: <43b11ce3-2b81-6280-3073-76c7cf0a42ef@gmail.com>
Date:   Thu, 8 Apr 2021 14:35:05 +0100
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.3.0
MIME-Version: 1.0
In-Reply-To: <000000000000933dd705bf6efd97@google.com>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org

On 08/04/2021 06:05, syzbot wrote:
> Hello,
> 
> syzbot has tested the proposed patch but the reproducer is still triggering an issue:
> INFO: task hung in io_ring_exit_work

Ok, it's really fancy, we add task_work with TWA_SIGNAL to a guaranteed
not exited/exec task, it succeeds, but the apparently the task work is
never executed.

Let's try something more exoteric -- TIF_NOTIFY_SIGNAL handling.

#syz test: https://github.com/isilence/linux.git syz_test2

> 
> INFO: task kworker/u4:0:9 blocked for more than 143 seconds.
>       Not tainted 5.12.0-rc2-syzkaller #0
> "echo 0 > /proc/sys/kernel/hung_task_timeout_secs" disables this message.
> task:kworker/u4:0    state:D stack:26336 pid:    9 ppid:     2 flags:0x00004000
> Workqueue: events_unbound io_ring_exit_work
> Call Trace:
>  context_switch kernel/sched/core.c:4324 [inline]
>  __schedule+0x911/0x21b0 kernel/sched/core.c:5075
>  schedule+0xcf/0x270 kernel/sched/core.c:5154
>  schedule_timeout+0x1db/0x250 kernel/time/timer.c:1868
>  do_wait_for_common kernel/sched/completion.c:85 [inline]
>  __wait_for_common kernel/sched/completion.c:106 [inline]
>  wait_for_common kernel/sched/completion.c:117 [inline]
>  wait_for_completion+0x168/0x270 kernel/sched/completion.c:138
>  io_ring_exit_work+0x4e8/0x12d0 fs/io_uring.c:8611
>  process_one_work+0x98d/0x1600 kernel/workqueue.c:2275
>  worker_thread+0x64c/0x1120 kernel/workqueue.c:2421
>  kthread+0x3b1/0x4a0 kernel/kthread.c:292
>  ret_from_fork+0x1f/0x30 arch/x86/entry/entry_64.S:294
> INFO: task kworker/u4:1:25 blocked for more than 144 seconds.
>       Not tainted 5.12.0-rc2-syzkaller #0
> "echo 0 > /proc/sys/kernel/hung_task_timeout_secs" disables this message.
> task:kworker/u4:1    state:D stack:25312 pid:   25 ppid:     2 flags:0x00004000
> Workqueue: events_unbound io_ring_exit_work
> Call Trace:
>  context_switch kernel/sched/core.c:4324 [inline]
>  __schedule+0x911/0x21b0 kernel/sched/core.c:5075
>  schedule+0xcf/0x270 kernel/sched/core.c:5154
>  schedule_timeout+0x1db/0x250 kernel/time/timer.c:1868
>  do_wait_for_common kernel/sched/completion.c:85 [inline]
>  __wait_for_common kernel/sched/completion.c:106 [inline]
>  wait_for_common kernel/sched/completion.c:117 [inline]
>  wait_for_completion+0x168/0x270 kernel/sched/completion.c:138
>  io_ring_exit_work+0x4e8/0x12d0 fs/io_uring.c:8611
>  process_one_work+0x98d/0x1600 kernel/workqueue.c:2275
>  worker_thread+0x64c/0x1120 kernel/workqueue.c:2421
>  kthread+0x3b1/0x4a0 kernel/kthread.c:292
>  ret_from_fork+0x1f/0x30 arch/x86/entry/entry_64.S:294
> INFO: task kworker/u4:3:110 blocked for more than 145 seconds.
>       Not tainted 5.12.0-rc2-syzkaller #0
> "echo 0 > /proc/sys/kernel/hung_task_timeout_secs" disables this message.
> task:kworker/u4:3    state:D stack:23608 pid:  110 ppid:     2 flags:0x00004000
> Workqueue: events_unbound io_ring_exit_work
> Call Trace:
>  context_switch kernel/sched/core.c:4324 [inline]
>  __schedule+0x911/0x21b0 kernel/sched/core.c:5075
>  schedule+0xcf/0x270 kernel/sched/core.c:5154
>  schedule_timeout+0x1db/0x250 kernel/time/timer.c:1868
>  do_wait_for_common kernel/sched/completion.c:85 [inline]
>  __wait_for_common kernel/sched/completion.c:106 [inline]
>  wait_for_common kernel/sched/completion.c:117 [inline]
>  wait_for_completion+0x168/0x270 kernel/sched/completion.c:138
>  io_ring_exit_work+0x4e8/0x12d0 fs/io_uring.c:8611
>  process_one_work+0x98d/0x1600 kernel/workqueue.c:2275
>  worker_thread+0x64c/0x1120 kernel/workqueue.c:2421
>  kthread+0x3b1/0x4a0 kernel/kthread.c:292
>  ret_from_fork+0x1f/0x30 arch/x86/entry/entry_64.S:294
> INFO: task kworker/u4:4:185 blocked for more than 145 seconds.
>       Not tainted 5.12.0-rc2-syzkaller #0
> "echo 0 > /proc/sys/kernel/hung_task_timeout_secs" disables this message.
> task:kworker/u4:4    state:D stack:25584 pid:  185 ppid:     2 flags:0x00004000
> Workqueue: events_unbound io_ring_exit_work
> Call Trace:
>  context_switch kernel/sched/core.c:4324 [inline]
>  __schedule+0x911/0x21b0 kernel/sched/core.c:5075
>  schedule+0xcf/0x270 kernel/sched/core.c:5154
>  schedule_timeout+0x1db/0x250 kernel/time/timer.c:1868
>  do_wait_for_common kernel/sched/completion.c:85 [inline]
>  __wait_for_common kernel/sched/completion.c:106 [inline]
>  wait_for_common kernel/sched/completion.c:117 [inline]
>  wait_for_completion+0x168/0x270 kernel/sched/completion.c:138
>  io_ring_exit_work+0x4e8/0x12d0 fs/io_uring.c:8611
>  process_one_work+0x98d/0x1600 kernel/workqueue.c:2275
>  worker_thread+0x64c/0x1120 kernel/workqueue.c:2421
>  kthread+0x3b1/0x4a0 kernel/kthread.c:292
>  ret_from_fork+0x1f/0x30 arch/x86/entry/entry_64.S:294
> 
> Showing all locks held in the system:
> 2 locks held by kworker/u4:0/9:
>  #0: ffff88800fc69138 ((wq_completion)events_unbound){+.+.}-{0:0}, at: arch_atomic64_set arch/x86/include/asm/atomic64_64.h:34 [inline]
>  #0: ffff88800fc69138 ((wq_completion)events_unbound){+.+.}-{0:0}, at: atomic64_set include/asm-generic/atomic-instrumented.h:856 [inline]
>  #0: ffff88800fc69138 ((wq_completion)events_unbound){+.+.}-{0:0}, at: atomic_long_set include/asm-generic/atomic-long.h:41 [inline]
>  #0: ffff88800fc69138 ((wq_completion)events_unbound){+.+.}-{0:0}, at: set_work_data kernel/workqueue.c:616 [inline]
>  #0: ffff88800fc69138 ((wq_completion)events_unbound){+.+.}-{0:0}, at: set_work_pool_and_clear_pending kernel/workqueue.c:643 [inline]
>  #0: ffff88800fc69138 ((wq_completion)events_unbound){+.+.}-{0:0}, at: process_one_work+0x871/0x1600 kernel/workqueue.c:2246
>  #1: ffffc90000ce7da8 ((work_completion)(&ctx->exit_work)){+.+.}-{0:0}, at: process_one_work+0x8a5/0x1600 kernel/workqueue.c:2250
> 2 locks held by kworker/u4:1/25:
>  #0: ffff88800fc69138 ((wq_completion)events_unbound){+.+.}-{0:0}, at: arch_atomic64_set arch/x86/include/asm/atomic64_64.h:34 [inline]
>  #0: ffff88800fc69138 ((wq_completion)events_unbound){+.+.}-{0:0}, at: atomic64_set include/asm-generic/atomic-instrumented.h:856 [inline]
>  #0: ffff88800fc69138 ((wq_completion)events_unbound){+.+.}-{0:0}, at: atomic_long_set include/asm-generic/atomic-long.h:41 [inline]
>  #0: ffff88800fc69138 ((wq_completion)events_unbound){+.+.}-{0:0}, at: set_work_data kernel/workqueue.c:616 [inline]
>  #0: ffff88800fc69138 ((wq_completion)events_unbound){+.+.}-{0:0}, at: set_work_pool_and_clear_pending kernel/workqueue.c:643 [inline]
>  #0: ffff88800fc69138 ((wq_completion)events_unbound){+.+.}-{0:0}, at: process_one_work+0x871/0x1600 kernel/workqueue.c:2246
>  #1: ffffc90000dffda8 ((work_completion)(&ctx->exit_work)){+.+.}-{0:0}, at: process_one_work+0x8a5/0x1600 kernel/workqueue.c:2250
> 2 locks held by kworker/u4:2/28:
>  #0: ffff88800fc69138 ((wq_completion)events_unbound){+.+.}-{0:0}, at: arch_atomic64_set arch/x86/include/asm/atomic64_64.h:34 [inline]
>  #0: ffff88800fc69138 ((wq_completion)events_unbound){+.+.}-{0:0}, at: atomic64_set include/asm-generic/atomic-instrumented.h:856 [inline]
>  #0: ffff88800fc69138 ((wq_completion)events_unbound){+.+.}-{0:0}, at: atomic_long_set include/asm-generic/atomic-long.h:41 [inline]
>  #0: ffff88800fc69138 ((wq_completion)events_unbound){+.+.}-{0:0}, at: set_work_data kernel/workqueue.c:616 [inline]
>  #0: ffff88800fc69138 ((wq_completion)events_unbound){+.+.}-{0:0}, at: set_work_pool_and_clear_pending kernel/workqueue.c:643 [inline]
>  #0: ffff88800fc69138 ((wq_completion)events_unbound){+.+.}-{0:0}, at: process_one_work+0x871/0x1600 kernel/workqueue.c:2246
>  #1: ffffc90000e3fda8 ((work_completion)(&ctx->exit_work)){+.+.}-{0:0}, at: process_one_work+0x8a5/0x1600 kernel/workqueue.c:2250
> 2 locks held by kworker/u4:3/110:
>  #0: ffff88800fc69138 ((wq_completion)events_unbound){+.+.}-{0:0}, at: arch_atomic64_set arch/x86/include/asm/atomic64_64.h:34 [inline]
>  #0: ffff88800fc69138 ((wq_completion)events_unbound){+.+.}-{0:0}, at: atomic64_set include/asm-generic/atomic-instrumented.h:856 [inline]
>  #0: ffff88800fc69138 ((wq_completion)events_unbound){+.+.}-{0:0}, at: atomic_long_set include/asm-generic/atomic-long.h:41 [inline]
>  #0: ffff88800fc69138 ((wq_completion)events_unbound){+.+.}-{0:0}, at: set_work_data kernel/workqueue.c:616 [inline]
>  #0: ffff88800fc69138 ((wq_completion)events_unbound){+.+.}-{0:0}, at: set_work_pool_and_clear_pending kernel/workqueue.c:643 [inline]
>  #0: ffff88800fc69138 ((wq_completion)events_unbound){+.+.}-{0:0}, at: process_one_work+0x871/0x1600 kernel/workqueue.c:2246
>  #1: ffffc9000127fda8 ((work_completion)(&ctx->exit_work)){+.+.}-{0:0}, at: process_one_work+0x8a5/0x1600 kernel/workqueue.c:2250
> 2 locks held by kworker/u4:4/185:
>  #0: ffff88800fc69138 ((wq_completion)events_unbound){+.+.}-{0:0}, at: arch_atomic64_set arch/x86/include/asm/atomic64_64.h:34 [inline]
>  #0: ffff88800fc69138 ((wq_completion)events_unbound){+.+.}-{0:0}, at: atomic64_set include/asm-generic/atomic-instrumented.h:856 [inline]
>  #0: ffff88800fc69138 ((wq_completion)events_unbound){+.+.}-{0:0}, at: atomic_long_set include/asm-generic/atomic-long.h:41 [inline]
>  #0: ffff88800fc69138 ((wq_completion)events_unbound){+.+.}-{0:0}, at: set_work_data kernel/workqueue.c:616 [inline]
>  #0: ffff88800fc69138 ((wq_completion)events_unbound){+.+.}-{0:0}, at: set_work_pool_and_clear_pending kernel/workqueue.c:643 [inline]
>  #0: ffff88800fc69138 ((wq_completion)events_unbound){+.+.}-{0:0}, at: process_one_work+0x871/0x1600 kernel/workqueue.c:2246
>  #1: ffffc900011afda8 ((work_completion)(&ctx->exit_work)){+.+.}-{0:0}, at: process_one_work+0x8a5/0x1600 kernel/workqueue.c:2250
> 2 locks held by kworker/u4:5/218:
>  #0: ffff88800fc69138 ((wq_completion)events_unbound){+.+.}-{0:0}, at: arch_atomic64_set arch/x86/include/asm/atomic64_64.h:34 [inline]
>  #0: ffff88800fc69138 ((wq_completion)events_unbound){+.+.}-{0:0}, at: atomic64_set include/asm-generic/atomic-instrumented.h:856 [inline]
>  #0: ffff88800fc69138 ((wq_completion)events_unbound){+.+.}-{0:0}, at: atomic_long_set include/asm-generic/atomic-long.h:41 [inline]
>  #0: ffff88800fc69138 ((wq_completion)events_unbound){+.+.}-{0:0}, at: set_work_data kernel/workqueue.c:616 [inline]
>  #0: ffff88800fc69138 ((wq_completion)events_unbound){+.+.}-{0:0}, at: set_work_pool_and_clear_pending kernel/workqueue.c:643 [inline]
>  #0: ffff88800fc69138 ((wq_completion)events_unbound){+.+.}-{0:0}, at: process_one_work+0x871/0x1600 kernel/workqueue.c:2246
>  #1: ffffc900018ffda8 ((work_completion)(&ctx->exit_work)){+.+.}-{0:0}, at: process_one_work+0x8a5/0x1600 kernel/workqueue.c:2250
> 2 locks held by kworker/u4:6/275:
>  #0: ffff88800fc69138 ((wq_completion)events_unbound){+.+.}-{0:0}, at: arch_atomic64_set arch/x86/include/asm/atomic64_64.h:34 [inline]
>  #0: ffff88800fc69138 ((wq_completion)events_unbound){+.+.}-{0:0}, at: atomic64_set include/asm-generic/atomic-instrumented.h:856 [inline]
>  #0: ffff88800fc69138 ((wq_completion)events_unbound){+.+.}-{0:0}, at: atomic_long_set include/asm-generic/atomic-long.h:41 [inline]
>  #0: ffff88800fc69138 ((wq_completion)events_unbound){+.+.}-{0:0}, at: set_work_data kernel/workqueue.c:616 [inline]
>  #0: ffff88800fc69138 ((wq_completion)events_unbound){+.+.}-{0:0}, at: set_work_pool_and_clear_pending kernel/workqueue.c:643 [inline]
>  #0: ffff88800fc69138 ((wq_completion)events_unbound){+.+.}-{0:0}, at: process_one_work+0x871/0x1600 kernel/workqueue.c:2246
>  #1: ffffc900018dfda8 ((work_completion)(&ctx->exit_work)){+.+.}-{0:0}, at: process_one_work+0x8a5/0x1600 kernel/workqueue.c:2250
> 1 lock held by khungtaskd/1622:
>  #0: ffffffff8b774760 (rcu_read_lock){....}-{1:2}, at: debug_show_all_locks+0x53/0x260 kernel/locking/lockdep.c:6327
> 2 locks held by kswapd0/2125:
> 3 locks held by kswapd1/2126:
> 2 locks held by systemd-journal/4828:
>  #0: ffff88814399f110 (&ei->i_mmap_sem){++++}-{3:3}, at: ext4_filemap_fault+0x7f/0xc0 fs/ext4/inode.c:6193
>  #1: ffffffff8b88ca40 (fs_reclaim){+.+.}-{0:0}, at: fs_reclaim_acquire+0xf7/0x150 mm/page_alloc.c:4349
> 2 locks held by systemd-udevd/4830:
>  #0: ffff88801bb2dd10 (&ei->i_mmap_sem){++++}-{3:3}, at: ext4_filemap_fault+0x7f/0xc0 fs/ext4/inode.c:6193
>  #1: ffffffff8b88ca40 (fs_reclaim){+.+.}-{0:0}, at: fs_reclaim_acquire+0xf7/0x150 mm/page_alloc.c:4349
> 1 lock held by in:imklog/8091:
>  #0: ffff888012020af0 (&f->f_pos_lock){+.+.}-{3:3}, at: __fdget_pos+0xe9/0x100 fs/file.c:961
> 4 locks held by rs:main Q:Reg/8092:
>  #0: ffff8880116d00f0 (&f->f_pos_lock){+.+.}-{3:3}, at: __fdget_pos+0xe9/0x100 fs/file.c:961
>  #1: ffff888021b78460 (sb_writers#5){.+.+}-{0:0}, at: ksys_write+0x12d/0x250 fs/read_write.c:658
>  #2: ffff88802d418e88 (&sb->s_type->i_mutex_key#10){+.+.}-{3:3}, at: inode_lock include/linux/fs.h:775 [inline]
>  #2: ffff88802d418e88 (&sb->s_type->i_mutex_key#10){+.+.}-{3:3}, at: ext4_buffered_write_iter+0xb6/0x4d0 fs/ext4/file.c:263
>  #3: ffffffff8b88ca40 (fs_reclaim){+.+.}-{0:0}, at: fs_reclaim_acquire+0xf7/0x150 mm/page_alloc.c:4349
> 3 locks held by sshd/8739:
>  #0: ffff88802b433510 (&ei->i_mmap_sem){++++}-{3:3}, at: ext4_filemap_fault+0x7f/0xc0 fs/ext4/inode.c:6193
>  #1: ffffffff8b88ca40 (fs_reclaim){+.+.}-{0:0}, at: fs_reclaim_acquire+0xf7/0x150 mm/page_alloc.c:4349
>  #2: ffff88802d5c1048 (&mapping->i_mmap_rwsem){++++}-{3:3}, at: i_mmap_lock_read include/linux/fs.h:510 [inline]
>  #2: ffff88802d5c1048 (&mapping->i_mmap_rwsem){++++}-{3:3}, at: rmap_walk_file+0x6d1/0xca0 mm/rmap.c:1926
> 1 lock held by syz-execprog/8746:
>  #0: ffff8880318add10 (&ei->i_mmap_sem){++++}-{3:3}, at: ext4_filemap_fault+0x7f/0xc0 fs/ext4/inode.c:6193
> 2 locks held by syz-execprog/8755:
>  #0: ffff8880b9f35198 (&rq->lock){-.-.}-{2:2}, at: rq_lock kernel/sched/sched.h:1321 [inline]
>  #0: ffff8880b9f35198 (&rq->lock){-.-.}-{2:2}, at: __schedule+0x21c/0x21b0 kernel/sched/core.c:4992
>  #1: ffff8880b9f1f948 (&per_cpu_ptr(group->pcpu, cpu)->seq){-.-.}-{0:0}, at: psi_task_switch+0x305/0x440 kernel/sched/psi.c:833
> 2 locks held by syz-executor.2/8769:
>  #0: ffff888023e6ea58 (&mm->mmap_lock#2){++++}-{3:3}, at: mmap_read_trylock include/linux/mmap_lock.h:136 [inline]
>  #0: ffff888023e6ea58 (&mm->mmap_lock#2){++++}-{3:3}, at: do_user_addr_fault+0x285/0x1210 arch/x86/mm/fault.c:1331
>  #1: ffffffff8b88ca40 (fs_reclaim){+.+.}-{0:0}, at: fs_reclaim_acquire+0xf7/0x150 mm/page_alloc.c:4349
> 1 lock held by syz-executor.0/8770:
>  #0: ffff8880b9f35198 (&rq->lock){-.-.}-{2:2}, at: rq_lock kernel/sched/sched.h:1321 [inline]
>  #0: ffff8880b9f35198 (&rq->lock){-.-.}-{2:2}, at: __schedule+0x21c/0x21b0 kernel/sched/core.c:4992
> 2 locks held by syz-executor.1/8771:
>  #0: ffff88801fd4c458 (&xt[i].mutex){+.+.}-{3:3}, at: xt_find_table_lock+0x41/0x540 net/netfilter/x_tables.c:1206
>  #1: ffffffff8b77d328 (rcu_state.exp_mutex){+.+.}-{3:3}, at: exp_funnel_lock kernel/rcu/tree_exp.h:322 [inline]
>  #1: ffffffff8b77d328 (rcu_state.exp_mutex){+.+.}-{3:3}, at: synchronize_rcu_expedited+0x27e/0x620 kernel/rcu/tree_exp.h:836
> 2 locks held by syz-executor.3/8773:
>  #0: ffff88802d5c0d10 (&ei->i_mmap_sem){++++}-{3:3}, at: ext4_filemap_fault+0x7f/0xc0 fs/ext4/inode.c:6193
>  #1: ffffffff8b88ca40 (fs_reclaim){+.+.}-{0:0}, at: fs_reclaim_acquire+0xf7/0x150 mm/page_alloc.c:4349
> 1 lock held by syz-executor.4/8775:
>  #0: ffff88801fd4cd88 (&xt[i].mutex){+.+.}-{3:3}, at: xt_find_table_lock+0x41/0x540 net/netfilter/x_tables.c:1206
> 2 locks held by kworker/u4:7/10347:
>  #0: ffff88800fc69138 ((wq_completion)events_unbound){+.+.}-{0:0}, at: arch_atomic64_set arch/x86/include/asm/atomic64_64.h:34 [inline]
>  #0: ffff88800fc69138 ((wq_completion)events_unbound){+.+.}-{0:0}, at: atomic64_set include/asm-generic/atomic-instrumented.h:856 [inline]
>  #0: ffff88800fc69138 ((wq_completion)events_unbound){+.+.}-{0:0}, at: atomic_long_set include/asm-generic/atomic-long.h:41 [inline]
>  #0: ffff88800fc69138 ((wq_completion)events_unbound){+.+.}-{0:0}, at: set_work_data kernel/workqueue.c:616 [inline]
>  #0: ffff88800fc69138 ((wq_completion)events_unbound){+.+.}-{0:0}, at: set_work_pool_and_clear_pending kernel/workqueue.c:643 [inline]
>  #0: ffff88800fc69138 ((wq_completion)events_unbound){+.+.}-{0:0}, at: process_one_work+0x871/0x1600 kernel/workqueue.c:2246
>  #1: ffffc9000b07fda8 ((work_completion)(&ctx->exit_work)){+.+.}-{0:0}, at: process_one_work+0x8a5/0x1600 kernel/workqueue.c:2250
> 2 locks held by kworker/u4:8/10640:
>  #0: ffff88800fc69138 ((wq_completion)events_unbound){+.+.}-{0:0}, at: arch_atomic64_set arch/x86/include/asm/atomic64_64.h:34 [inline]
>  #0: ffff88800fc69138 ((wq_completion)events_unbound){+.+.}-{0:0}, at: atomic64_set include/asm-generic/atomic-instrumented.h:856 [inline]
>  #0: ffff88800fc69138 ((wq_completion)events_unbound){+.+.}-{0:0}, at: atomic_long_set include/asm-generic/atomic-long.h:41 [inline]
>  #0: ffff88800fc69138 ((wq_completion)events_unbound){+.+.}-{0:0}, at: set_work_data kernel/workqueue.c:616 [inline]
>  #0: ffff88800fc69138 ((wq_completion)events_unbound){+.+.}-{0:0}, at: set_work_pool_and_clear_pending kernel/workqueue.c:643 [inline]
>  #0: ffff88800fc69138 ((wq_completion)events_unbound){+.+.}-{0:0}, at: process_one_work+0x871/0x1600 kernel/workqueue.c:2246
>  #1: ffffc9000bd0fda8 ((work_completion)(&ctx->exit_work)){+.+.}-{0:0}, at: process_one_work+0x8a5/0x1600 kernel/workqueue.c:2250
> 2 locks held by kworker/u4:9/10726:
>  #0: ffff88800fc69138 ((wq_completion)events_unbound){+.+.}-{0:0}, at: arch_atomic64_set arch/x86/include/asm/atomic64_64.h:34 [inline]
>  #0: ffff88800fc69138 ((wq_completion)events_unbound){+.+.}-{0:0}, at: atomic64_set include/asm-generic/atomic-instrumented.h:856 [inline]
>  #0: ffff88800fc69138 ((wq_completion)events_unbound){+.+.}-{0:0}, at: atomic_long_set include/asm-generic/atomic-long.h:41 [inline]
>  #0: ffff88800fc69138 ((wq_completion)events_unbound){+.+.}-{0:0}, at: set_work_data kernel/workqueue.c:616 [inline]
>  #0: ffff88800fc69138 ((wq_completion)events_unbound){+.+.}-{0:0}, at: set_work_pool_and_clear_pending kernel/workqueue.c:643 [inline]
>  #0: ffff88800fc69138 ((wq_completion)events_unbound){+.+.}-{0:0}, at: process_one_work+0x871/0x1600 kernel/workqueue.c:2246
>  #1: ffffc9000a6dfda8 ((work_completion)(&ctx->exit_work)){+.+.}-{0:0}, at: process_one_work+0x8a5/0x1600 kernel/workqueue.c:2250
> 2 locks held by kworker/u4:10/10915:
>  #0: ffff88800fc69138 ((wq_completion)events_unbound){+.+.}-{0:0}, at: arch_atomic64_set arch/x86/include/asm/atomic64_64.h:34 [inline]
>  #0: ffff88800fc69138 ((wq_completion)events_unbound){+.+.}-{0:0}, at: atomic64_set include/asm-generic/atomic-instrumented.h:856 [inline]
>  #0: ffff88800fc69138 ((wq_completion)events_unbound){+.+.}-{0:0}, at: atomic_long_set include/asm-generic/atomic-long.h:41 [inline]
>  #0: ffff88800fc69138 ((wq_completion)events_unbound){+.+.}-{0:0}, at: set_work_data kernel/workqueue.c:616 [inline]
>  #0: ffff88800fc69138 ((wq_completion)events_unbound){+.+.}-{0:0}, at: set_work_pool_and_clear_pending kernel/workqueue.c:643 [inline]
>  #0: ffff88800fc69138 ((wq_completion)events_unbound){+.+.}-{0:0}, at: process_one_work+0x871/0x1600 kernel/workqueue.c:2246
>  #1: ffffc9000c81fda8 ((work_completion)(&ctx->exit_work)){+.+.}-{0:0}, at: process_one_work+0x8a5/0x1600 kernel/workqueue.c:2250
> 2 locks held by kworker/u4:11/11278:
>  #0: ffff88800fc69138 ((wq_completion)events_unbound){+.+.}-{0:0}, at: arch_atomic64_set arch/x86/include/asm/atomic64_64.h:34 [inline]
>  #0: ffff88800fc69138 ((wq_completion)events_unbound){+.+.}-{0:0}, at: atomic64_set include/asm-generic/atomic-instrumented.h:856 [inline]
>  #0: ffff88800fc69138 ((wq_completion)events_unbound){+.+.}-{0:0}, at: atomic_long_set include/asm-generic/atomic-long.h:41 [inline]
>  #0: ffff88800fc69138 ((wq_completion)events_unbound){+.+.}-{0:0}, at: set_work_data kernel/workqueue.c:616 [inline]
>  #0: ffff88800fc69138 ((wq_completion)events_unbound){+.+.}-{0:0}, at: set_work_pool_and_clear_pending kernel/workqueue.c:643 [inline]
>  #0: ffff88800fc69138 ((wq_completion)events_unbound){+.+.}-{0:0}, at: process_one_work+0x871/0x1600 kernel/workqueue.c:2246
>  #1: ffffc9000d5cfda8 ((work_completion)(&ctx->exit_work)){+.+.}-{0:0}, at: process_one_work+0x8a5/0x1600 kernel/workqueue.c:2250
> 2 locks held by kworker/u4:12/11561:
>  #0: ffff88800fc69138 ((wq_completion)events_unbound){+.+.}-{0:0}, at: arch_atomic64_set arch/x86/include/asm/atomic64_64.h:34 [inline]
>  #0: ffff88800fc69138 ((wq_completion)events_unbound){+.+.}-{0:0}, at: atomic64_set include/asm-generic/atomic-instrumented.h:856 [inline]
>  #0: ffff88800fc69138 ((wq_completion)events_unbound){+.+.}-{0:0}, at: atomic_long_set include/asm-generic/atomic-long.h:41 [inline]
>  #0: ffff88800fc69138 ((wq_completion)events_unbound){+.+.}-{0:0}, at: set_work_data kernel/workqueue.c:616 [inline]
>  #0: ffff88800fc69138 ((wq_completion)events_unbound){+.+.}-{0:0}, at: set_work_pool_and_clear_pending kernel/workqueue.c:643 [inline]
>  #0: ffff88800fc69138 ((wq_completion)events_unbound){+.+.}-{0:0}, at: process_one_work+0x871/0x1600 kernel/workqueue.c:2246
>  #1: ffffc9000e00fda8 ((work_completion)(&ctx->exit_work)){+.+.}-{0:0}, at: process_one_work+0x8a5/0x1600 kernel/workqueue.c:2250
> 2 locks held by kworker/u4:13/11663:
>  #0: ffff88800fc69138 ((wq_completion)events_unbound){+.+.}-{0:0}, at: arch_atomic64_set arch/x86/include/asm/atomic64_64.h:34 [inline]
>  #0: ffff88800fc69138 ((wq_completion)events_unbound){+.+.}-{0:0}, at: atomic64_set include/asm-generic/atomic-instrumented.h:856 [inline]
>  #0: ffff88800fc69138 ((wq_completion)events_unbound){+.+.}-{0:0}, at: atomic_long_set include/asm-generic/atomic-long.h:41 [inline]
>  #0: ffff88800fc69138 ((wq_completion)events_unbound){+.+.}-{0:0}, at: set_work_data kernel/workqueue.c:616 [inline]
>  #0: ffff88800fc69138 ((wq_completion)events_unbound){+.+.}-{0:0}, at: set_work_pool_and_clear_pending kernel/workqueue.c:643 [inline]
>  #0: ffff88800fc69138 ((wq_completion)events_unbound){+.+.}-{0:0}, at: process_one_work+0x871/0x1600 kernel/workqueue.c:2246
>  #1: ffffc9000e38fda8 ((work_completion)(&ctx->exit_work)){+.+.}-{0:0}, at: process_one_work+0x8a5/0x1600 kernel/workqueue.c:2250
> 2 locks held by kworker/u4:14/11950:
>  #0: ffff88800fc69138 ((wq_completion)events_unbound){+.+.}-{0:0}, at: arch_atomic64_set arch/x86/include/asm/atomic64_64.h:34 [inline]
>  #0: ffff88800fc69138 ((wq_completion)events_unbound){+.+.}-{0:0}, at: atomic64_set include/asm-generic/atomic-instrumented.h:856 [inline]
>  #0: ffff88800fc69138 ((wq_completion)events_unbound){+.+.}-{0:0}, at: atomic_long_set include/asm-generic/atomic-long.h:41 [inline]
>  #0: ffff88800fc69138 ((wq_completion)events_unbound){+.+.}-{0:0}, at: set_work_data kernel/workqueue.c:616 [inline]
>  #0: ffff88800fc69138 ((wq_completion)events_unbound){+.+.}-{0:0}, at: set_work_pool_and_clear_pending kernel/workqueue.c:643 [inline]
>  #0: ffff88800fc69138 ((wq_completion)events_unbound){+.+.}-{0:0}, at: process_one_work+0x871/0x1600 kernel/workqueue.c:2246
>  #1: ffffc9000ee6fda8 ((work_completion)(&ctx->exit_work)){+.+.}-{0:0}, at: process_one_work+0x8a5/0x1600 kernel/workqueue.c:2250
> 2 locks held by kworker/u4:15/12154:
>  #0: ffff88800fc69138 ((wq_completion)events_unbound){+.+.}-{0:0}, at: arch_atomic64_set arch/x86/include/asm/atomic64_64.h:34 [inline]
>  #0: ffff88800fc69138 ((wq_completion)events_unbound){+.+.}-{0:0}, at: atomic64_set include/asm-generic/atomic-instrumented.h:856 [inline]
>  #0: ffff88800fc69138 ((wq_completion)events_unbound){+.+.}-{0:0}, at: atomic_long_set include/asm-generic/atomic-long.h:41 [inline]
>  #0: ffff88800fc69138 ((wq_completion)events_unbound){+.+.}-{0:0}, at: set_work_data kernel/workqueue.c:616 [inline]
>  #0: ffff88800fc69138 ((wq_completion)events_unbound){+.+.}-{0:0}, at: set_work_pool_and_clear_pending kernel/workqueue.c:643 [inline]
>  #0: ffff88800fc69138 ((wq_completion)events_unbound){+.+.}-{0:0}, at: process_one_work+0x871/0x1600 kernel/workqueue.c:2246
>  #1: ffffc9000216fda8 ((work_completion)(&ctx->exit_work)){+.+.}-{0:0}, at: process_one_work+0x8a5/0x1600 kernel/workqueue.c:2250
> 2 locks held by kworker/u4:16/12256:
>  #0: ffff88800fc69138 ((wq_completion)events_unbound){+.+.}-{0:0}, at: arch_atomic64_set arch/x86/include/asm/atomic64_64.h:34 [inline]
>  #0: ffff88800fc69138 ((wq_completion)events_unbound){+.+.}-{0:0}, at: atomic64_set include/asm-generic/atomic-instrumented.h:856 [inline]
>  #0: ffff88800fc69138 ((wq_completion)events_unbound){+.+.}-{0:0}, at: atomic_long_set include/asm-generic/atomic-long.h:41 [inline]
>  #0: ffff88800fc69138 ((wq_completion)events_unbound){+.+.}-{0:0}, at: set_work_data kernel/workqueue.c:616 [inline]
>  #0: ffff88800fc69138 ((wq_completion)events_unbound){+.+.}-{0:0}, at: set_work_pool_and_clear_pending kernel/workqueue.c:643 [inline]
>  #0: ffff88800fc69138 ((wq_completion)events_unbound){+.+.}-{0:0}, at: process_one_work+0x871/0x1600 kernel/workqueue.c:2246
>  #1: ffffc9000263fda8 ((work_completion)(&ctx->exit_work)){+.+.}-{0:0}, at: process_one_work+0x8a5/0x1600 kernel/workqueue.c:2250
> 2 locks held by kworker/u4:17/12391:
>  #0: ffff88800fc69138 ((wq_completion)events_unbound){+.+.}-{0:0}, at: arch_atomic64_set arch/x86/include/asm/atomic64_64.h:34 [inline]
>  #0: ffff88800fc69138 ((wq_completion)events_unbound){+.+.}-{0:0}, at: atomic64_set include/asm-generic/atomic-instrumented.h:856 [inline]
>  #0: ffff88800fc69138 ((wq_completion)events_unbound){+.+.}-{0:0}, at: atomic_long_set include/asm-generic/atomic-long.h:41 [inline]
>  #0: ffff88800fc69138 ((wq_completion)events_unbound){+.+.}-{0:0}, at: set_work_data kernel/workqueue.c:616 [inline]
>  #0: ffff88800fc69138 ((wq_completion)events_unbound){+.+.}-{0:0}, at: set_work_pool_and_clear_pending kernel/workqueue.c:643 [inline]
>  #0: ffff88800fc69138 ((wq_completion)events_unbound){+.+.}-{0:0}, at: process_one_work+0x871/0x1600 kernel/workqueue.c:2246
>  #1: ffffc90002befda8 ((work_completion)(&ctx->exit_work)){+.+.}-{0:0}, at: process_one_work+0x8a5/0x1600 kernel/workqueue.c:2250
> 2 locks held by kworker/u4:18/12443:
>  #0: ffff88800fc69138 ((wq_completion)events_unbound){+.+.}-{0:0}, at: arch_atomic64_set arch/x86/include/asm/atomic64_64.h:34 [inline]
>  #0: ffff88800fc69138 ((wq_completion)events_unbound){+.+.}-{0:0}, at: atomic64_set include/asm-generic/atomic-instrumented.h:856 [inline]
>  #0: ffff88800fc69138 ((wq_completion)events_unbound){+.+.}-{0:0}, at: atomic_long_set include/asm-generic/atomic-long.h:41 [inline]
>  #0: ffff88800fc69138 ((wq_completion)events_unbound){+.+.}-{0:0}, at: set_work_data kernel/workqueue.c:616 [inline]
>  #0: ffff88800fc69138 ((wq_completion)events_unbound){+.+.}-{0:0}, at: set_work_pool_and_clear_pending kernel/workqueue.c:643 [inline]
>  #0: ffff88800fc69138 ((wq_completion)events_unbound){+.+.}-{0:0}, at: process_one_work+0x871/0x1600 kernel/workqueue.c:2246
>  #1: ffffc90002dbfda8 ((work_completion)(&ctx->exit_work)){+.+.}-{0:0}, at: process_one_work+0x8a5/0x1600 kernel/workqueue.c:2250
> 2 locks held by kworker/u4:19/12596:
>  #0: ffff88800fc69138 ((wq_completion)events_unbound){+.+.}-{0:0}, at: arch_atomic64_set arch/x86/include/asm/atomic64_64.h:34 [inline]
>  #0: ffff88800fc69138 ((wq_completion)events_unbound){+.+.}-{0:0}, at: atomic64_set include/asm-generic/atomic-instrumented.h:856 [inline]
>  #0: ffff88800fc69138 ((wq_completion)events_unbound){+.+.}-{0:0}, at: atomic_long_set include/asm-generic/atomic-long.h:41 [inline]
>  #0: ffff88800fc69138 ((wq_completion)events_unbound){+.+.}-{0:0}, at: set_work_data kernel/workqueue.c:616 [inline]
>  #0: ffff88800fc69138 ((wq_completion)events_unbound){+.+.}-{0:0}, at: set_work_pool_and_clear_pending kernel/workqueue.c:643 [inline]
>  #0: ffff88800fc69138 ((wq_completion)events_unbound){+.+.}-{0:0}, at: process_one_work+0x871/0x1600 kernel/workqueue.c:2246
>  #1: ffffc900030b7da8 ((work_completion)(&ctx->exit_work)){+.+.}-{0:0}, at: process_one_work+0x8a5/0x1600 kernel/workqueue.c:2250
> 2 locks held by kworker/u4:20/12663:
>  #0: ffff88800fc69138 ((wq_completion)events_unbound){+.+.}-{0:0}, at: arch_atomic64_set arch/x86/include/asm/atomic64_64.h:34 [inline]
>  #0: ffff88800fc69138 ((wq_completion)events_unbound){+.+.}-{0:0}, at: atomic64_set include/asm-generic/atomic-instrumented.h:856 [inline]
>  #0: ffff88800fc69138 ((wq_completion)events_unbound){+.+.}-{0:0}, at: atomic_long_set include/asm-generic/atomic-long.h:41 [inline]
>  #0: ffff88800fc69138 ((wq_completion)events_unbound){+.+.}-{0:0}, at: set_work_data kernel/workqueue.c:616 [inline]
>  #0: ffff88800fc69138 ((wq_completion)events_unbound){+.+.}-{0:0}, at: set_work_pool_and_clear_pending kernel/workqueue.c:643 [inline]
>  #0: ffff88800fc69138 ((wq_completion)events_unbound){+.+.}-{0:0}, at: process_one_work+0x871/0x1600 kernel/workqueue.c:2246
>  #1: ffffc90003077da8 ((work_completion)(&ctx->exit_work)){+.+.}-{0:0}, at: process_one_work+0x8a5/0x1600 kernel/workqueue.c:2250
> 2 locks held by kworker/u4:21/12823:
>  #0: ffff88800fc69138 ((wq_completion)events_unbound){+.+.}-{0:0}, at: arch_atomic64_set arch/x86/include/asm/atomic64_64.h:34 [inline]
>  #0: ffff88800fc69138 ((wq_completion)events_unbound){+.+.}-{0:0}, at: atomic64_set include/asm-generic/atomic-instrumented.h:856 [inline]
>  #0: ffff88800fc69138 ((wq_completion)events_unbound){+.+.}-{0:0}, at: atomic_long_set include/asm-generic/atomic-long.h:41 [inline]
>  #0: ffff88800fc69138 ((wq_completion)events_unbound){+.+.}-{0:0}, at: set_work_data kernel/workqueue.c:616 [inline]
>  #0: ffff88800fc69138 ((wq_completion)events_unbound){+.+.}-{0:0}, at: set_work_pool_and_clear_pending kernel/workqueue.c:643 [inline]
>  #0: ffff88800fc69138 ((wq_completion)events_unbound){+.+.}-{0:0}, at: process_one_work+0x871/0x1600 kernel/workqueue.c:2246
>  #1: ffffc900091e7da8 ((work_completion)(&ctx->exit_work)){+.+.}-{0:0}, at: process_one_work+0x8a5/0x1600 kernel/workqueue.c:2250
> 2 locks held by kworker/u4:22/12831:
>  #0: ffff88800fc69138 ((wq_completion)events_unbound){+.+.}-{0:0}, at: arch_atomic64_set arch/x86/include/asm/atomic64_64.h:34 [inline]
>  #0: ffff88800fc69138 ((wq_completion)events_unbound){+.+.}-{0:0}, at: atomic64_set include/asm-generic/atomic-instrumented.h:856 [inline]
>  #0: ffff88800fc69138 ((wq_completion)events_unbound){+.+.}-{0:0}, at: atomic_long_set include/asm-generic/atomic-long.h:41 [inline]
>  #0: ffff88800fc69138 ((wq_completion)events_unbound){+.+.}-{0:0}, at: set_work_data kernel/workqueue.c:616 [inline]
>  #0: ffff88800fc69138 ((wq_completion)events_unbound){+.+.}-{0:0}, at: set_work_pool_and_clear_pending kernel/workqueue.c:643 [inline]
>  #0: ffff88800fc69138 ((wq_completion)events_unbound){+.+.}-{0:0}, at: process_one_work+0x871/0x1600 kernel/workqueue.c:2246
>  #1: ffffc90005237da8 ((work_completion)(&ctx->exit_work)){+.+.}-{0:0}, at: process_one_work+0x8a5/0x1600 kernel/workqueue.c:2250
> 2 locks held by kworker/u4:23/13064:
>  #0: ffff88800fc69138 ((wq_completion)events_unbound){+.+.}-{0:0}, at: arch_atomic64_set arch/x86/include/asm/atomic64_64.h:34 [inline]
>  #0: ffff88800fc69138 ((wq_completion)events_unbound){+.+.}-{0:0}, at: atomic64_set include/asm-generic/atomic-instrumented.h:856 [inline]
>  #0: ffff88800fc69138 ((wq_completion)events_unbound){+.+.}-{0:0}, at: atomic_long_set include/asm-generic/atomic-long.h:41 [inline]
>  #0: ffff88800fc69138 ((wq_completion)events_unbound){+.+.}-{0:0}, at: set_work_data kernel/workqueue.c:616 [inline]
>  #0: ffff88800fc69138 ((wq_completion)events_unbound){+.+.}-{0:0}, at: set_work_pool_and_clear_pending kernel/workqueue.c:643 [inline]
>  #0: ffff88800fc69138 ((wq_completion)events_unbound){+.+.}-{0:0}, at: process_one_work+0x871/0x1600 kernel/workqueue.c:2246
>  #1: ffffc90009d17da8 ((work_completion)(&ctx->exit_work)){+.+.}-{0:0}, at: process_one_work+0x8a5/0x1600 kernel/workqueue.c:2250
> 2 locks held by kworker/u4:24/13470:
>  #0: ffff88800fc69138 ((wq_completion)events_unbound){+.+.}-{0:0}, at: arch_atomic64_set arch/x86/include/asm/atomic64_64.h:34 [inline]
>  #0: ffff88800fc69138 ((wq_completion)events_unbound){+.+.}-{0:0}, at: atomic64_set include/asm-generic/atomic-instrumented.h:856 [inline]
>  #0: ffff88800fc69138 ((wq_completion)events_unbound){+.+.}-{0:0}, at: atomic_long_set include/asm-generic/atomic-long.h:41 [inline]
>  #0: ffff88800fc69138 ((wq_completion)events_unbound){+.+.}-{0:0}, at: set_work_data kernel/workqueue.c:616 [inline]
>  #0: ffff88800fc69138 ((wq_completion)events_unbound){+.+.}-{0:0}, at: set_work_pool_and_clear_pending kernel/workqueue.c:643 [inline]
>  #0: ffff88800fc69138 ((wq_completion)events_unbound){+.+.}-{0:0}, at: process_one_work+0x871/0x1600 kernel/workqueue.c:2246
>  #1: ffffc9000b47fda8 ((work_completion)(&ctx->exit_work)){+.+.}-{0:0}, at: process_one_work+0x8a5/0x1600 kernel/workqueue.c:2250
> 2 locks held by kworker/u4:25/13565:
>  #0: ffff88800fc69138 ((wq_completion)events_unbound){+.+.}-{0:0}, at: arch_atomic64_set arch/x86/include/asm/atomic64_64.h:34 [inline]
>  #0: ffff88800fc69138 ((wq_completion)events_unbound){+.+.}-{0:0}, at: atomic64_set include/asm-generic/atomic-instrumented.h:856 [inline]
>  #0: ffff88800fc69138 ((wq_completion)events_unbound){+.+.}-{0:0}, at: atomic_long_set include/asm-generic/atomic-long.h:41 [inline]
>  #0: ffff88800fc69138 ((wq_completion)events_unbound){+.+.}-{0:0}, at: set_work_data kernel/workqueue.c:616 [inline]
>  #0: ffff88800fc69138 ((wq_completion)events_unbound){+.+.}-{0:0}, at: set_work_pool_and_clear_pending kernel/workqueue.c:643 [inline]
>  #0: ffff88800fc69138 ((wq_completion)events_unbound){+.+.}-{0:0}, at: process_one_work+0x871/0x1600 kernel/workqueue.c:2246
>  #1: ffffc9000bbbfda8 ((work_completion)(&ctx->exit_work)){+.+.}-{0:0}, at: process_one_work+0x8a5/0x1600 kernel/workqueue.c:2250
> 2 locks held by kworker/u4:26/14589:
>  #0: ffff88800fc69138 ((wq_completion)events_unbound){+.+.}-{0:0}, at: arch_atomic64_set arch/x86/include/asm/atomic64_64.h:34 [inline]
>  #0: ffff88800fc69138 ((wq_completion)events_unbound){+.+.}-{0:0}, at: atomic64_set include/asm-generic/atomic-instrumented.h:856 [inline]
>  #0: ffff88800fc69138 ((wq_completion)events_unbound){+.+.}-{0:0}, at: atomic_long_set include/asm-generic/atomic-long.h:41 [inline]
>  #0: ffff88800fc69138 ((wq_completion)events_unbound){+.+.}-{0:0}, at: set_work_data kernel/workqueue.c:616 [inline]
>  #0: ffff88800fc69138 ((wq_completion)events_unbound){+.+.}-{0:0}, at: set_work_pool_and_clear_pending kernel/workqueue.c:643 [inline]
>  #0: ffff88800fc69138 ((wq_completion)events_unbound){+.+.}-{0:0}, at: process_one_work+0x871/0x1600 kernel/workqueue.c:2246
>  #1: ffffc9000fe9fda8 ((work_completion)(&ctx->exit_work)){+.+.}-{0:0}, at: process_one_work+0x8a5/0x1600 kernel/workqueue.c:2250
> 2 locks held by kworker/u4:27/14673:
>  #0: ffff88800fc69138 ((wq_completion)events_unbound){+.+.}-{0:0}, at: arch_atomic64_set arch/x86/include/asm/atomic64_64.h:34 [inline]
>  #0: ffff88800fc69138 ((wq_completion)events_unbound){+.+.}-{0:0}, at: atomic64_set include/asm-generic/atomic-instrumented.h:856 [inline]
>  #0: ffff88800fc69138 ((wq_completion)events_unbound){+.+.}-{0:0}, at: atomic_long_set include/asm-generic/atomic-long.h:41 [inline]
>  #0: ffff88800fc69138 ((wq_completion)events_unbound){+.+.}-{0:0}, at: set_work_data kernel/workqueue.c:616 [inline]
>  #0: ffff88800fc69138 ((wq_completion)events_unbound){+.+.}-{0:0}, at: set_work_pool_and_clear_pending kernel/workqueue.c:643 [inline]
>  #0: ffff88800fc69138 ((wq_completion)events_unbound){+.+.}-{0:0}, at: process_one_work+0x871/0x1600 kernel/workqueue.c:2246
>  #1: ffffc9001017fda8 ((work_completion)(&ctx->exit_work)){+.+.}-{0:0}, at: process_one_work+0x8a5/0x1600 kernel/workqueue.c:2250
> 2 locks held by kworker/u4:28/14712:
>  #0: ffff88800fc69138 ((wq_completion)events_unbound){+.+.}-{0:0}, at: arch_atomic64_set arch/x86/include/asm/atomic64_64.h:34 [inline]
>  #0: ffff88800fc69138 ((wq_completion)events_unbound){+.+.}-{0:0}, at: atomic64_set include/asm-generic/atomic-instrumented.h:856 [inline]
>  #0: ffff88800fc69138 ((wq_completion)events_unbound){+.+.}-{0:0}, at: atomic_long_set include/asm-generic/atomic-long.h:41 [inline]
>  #0: ffff88800fc69138 ((wq_completion)events_unbound){+.+.}-{0:0}, at: set_work_data kernel/workqueue.c:616 [inline]
>  #0: ffff88800fc69138 ((wq_completion)events_unbound){+.+.}-{0:0}, at: set_work_pool_and_clear_pending kernel/workqueue.c:643 [inline]
>  #0: ffff88800fc69138 ((wq_completion)events_unbound){+.+.}-{0:0}, at: process_one_work+0x871/0x1600 kernel/workqueue.c:2246
>  #1: ffffc9000fbdfda8 ((work_completion)(&ctx->exit_work)){+.+.}-{0:0}, at: process_one_work+0x8a5/0x1600 kernel/workqueue.c:2250
> 2 locks held by kworker/u4:29/14738:
>  #0: ffff88800fc69138 ((wq_completion)events_unbound){+.+.}-{0:0}, at: arch_atomic64_set arch/x86/include/asm/atomic64_64.h:34 [inline]
>  #0: ffff88800fc69138 ((wq_completion)events_unbound){+.+.}-{0:0}, at: atomic64_set include/asm-generic/atomic-instrumented.h:856 [inline]
>  #0: ffff88800fc69138 ((wq_completion)events_unbound){+.+.}-{0:0}, at: atomic_long_set include/asm-generic/atomic-long.h:41 [inline]
>  #0: ffff88800fc69138 ((wq_completion)events_unbound){+.+.}-{0:0}, at: set_work_data kernel/workqueue.c:616 [inline]
>  #0: ffff88800fc69138 ((wq_completion)events_unbound){+.+.}-{0:0}, at: set_work_pool_and_clear_pending kernel/workqueue.c:643 [inline]
>  #0: ffff88800fc69138 ((wq_completion)events_unbound){+.+.}-{0:0}, at: process_one_work+0x871/0x1600 kernel/workqueue.c:2246
>  #1: ffffc900103bfda8 ((work_completion)(&ctx->exit_work)){+.+.}-{0:0}, at: process_one_work+0x8a5/0x1600 kernel/workqueue.c:2250
> 2 locks held by kworker/u4:30/14985:
>  #0: ffff88800fc69138 ((wq_completion)events_unbound){+.+.}-{0:0}, at: arch_atomic64_set arch/x86/include/asm/atomic64_64.h:34 [inline]
>  #0: ffff88800fc69138 ((wq_completion)events_unbound){+.+.}-{0:0}, at: atomic64_set include/asm-generic/atomic-instrumented.h:856 [inline]
>  #0: ffff88800fc69138 ((wq_completion)events_unbound){+.+.}-{0:0}, at: atomic_long_set include/asm-generic/atomic-long.h:41 [inline]
>  #0: ffff88800fc69138 ((wq_completion)events_unbound){+.+.}-{0:0}, at: set_work_data kernel/workqueue.c:616 [inline]
>  #0: ffff88800fc69138 ((wq_completion)events_unbound){+.+.}-{0:0}, at: set_work_pool_and_clear_pending kernel/workqueue.c:643 [inline]
>  #0: ffff88800fc69138 ((wq_completion)events_unbound){+.+.}-{0:0}, at: process_one_work+0x871/0x1600 kernel/workqueue.c:2246
>  #1: ffffc90010cdfda8 ((work_completion)(&ctx->exit_work)){+.+.}-{0:0}, at: process_one_work+0x8a5/0x1600 kernel/workqueue.c:2250
> 2 locks held by kworker/u4:31/15019:
>  #0: ffff88800fc69138 ((wq_completion)events_unbound){+.+.}-{0:0}, at: arch_atomic64_set arch/x86/include/asm/atomic64_64.h:34 [inline]
>  #0: ffff88800fc69138 ((wq_completion)events_unbound){+.+.}-{0:0}, at: atomic64_set include/asm-generic/atomic-instrumented.h:856 [inline]
>  #0: ffff88800fc69138 ((wq_completion)events_unbound){+.+.}-{0:0}, at: atomic_long_set include/asm-generic/atomic-long.h:41 [inline]
>  #0: ffff88800fc69138 ((wq_completion)events_unbound){+.+.}-{0:0}, at: set_work_data kernel/workqueue.c:616 [inline]
>  #0: ffff88800fc69138 ((wq_completion)events_unbound){+.+.}-{0:0}, at: set_work_pool_and_clear_pending kernel/workqueue.c:643 [inline]
>  #0: ffff88800fc69138 ((wq_completion)events_unbound){+.+.}-{0:0}, at: process_one_work+0x871/0x1600 kernel/workqueue.c:2246
>  #1: ffffc90010e4fda8 ((work_completion)(&ctx->exit_work)){+.+.}-{0:0}, at: process_one_work+0x8a5/0x1600 kernel/workqueue.c:2250
> 2 locks held by kworker/u4:32/15295:
>  #0: ffff88800fc69138 ((wq_completion)events_unbound){+.+.}-{0:0}, at: arch_atomic64_set arch/x86/include/asm/atomic64_64.h:34 [inline]
>  #0: ffff88800fc69138 ((wq_completion)events_unbound){+.+.}-{0:0}, at: atomic64_set include/asm-generic/atomic-instrumented.h:856 [inline]
>  #0: ffff88800fc69138 ((wq_completion)events_unbound){+.+.}-{0:0}, at: atomic_long_set include/asm-generic/atomic-long.h:41 [inline]
>  #0: ffff88800fc69138 ((wq_completion)events_unbound){+.+.}-{0:0}, at: set_work_data kernel/workqueue.c:616 [inline]
>  #0: ffff88800fc69138 ((wq_completion)events_unbound){+.+.}-{0:0}, at: set_work_pool_and_clear_pending kernel/workqueue.c:643 [inline]
>  #0: ffff88800fc69138 ((wq_completion)events_unbound){+.+.}-{0:0}, at: process_one_work+0x871/0x1600 kernel/workqueue.c:2246
>  #1: ffffc9001186fda8 ((work_completion)(&ctx->exit_work)){+.+.}-{0:0}, at: process_one_work+0x8a5/0x1600 kernel/workqueue.c:2250
> 2 locks held by kworker/u4:33/15304:
>  #0: ffff88800fc69138 ((wq_completion)events_unbound){+.+.}-{0:0}, at: arch_atomic64_set arch/x86/include/asm/atomic64_64.h:34 [inline]
>  #0: ffff88800fc69138 ((wq_completion)events_unbound){+.+.}-{0:0}, at: atomic64_set include/asm-generic/atomic-instrumented.h:856 [inline]
>  #0: ffff88800fc69138 ((wq_completion)events_unbound){+.+.}-{0:0}, at: atomic_long_set include/asm-generic/atomic-long.h:41 [inline]
>  #0: ffff88800fc69138 ((wq_completion)events_unbound){+.+.}-{0:0}, at: set_work_data kernel/workqueue.c:616 [inline]
>  #0: ffff88800fc69138 ((wq_completion)events_unbound){+.+.}-{0:0}, at: set_work_pool_and_clear_pending kernel/workqueue.c:643 [inline]
>  #0: ffff88800fc69138 ((wq_completion)events_unbound){+.+.}-{0:0}, at: process_one_work+0x871/0x1600 kernel/workqueue.c:2246
>  #1: ffffc900116bfda8 ((work_completion)(&ctx->exit_work)){+.+.}-{0:0}, at: process_one_work+0x8a5/0x1600 kernel/workqueue.c:2250
> 2 locks held by kworker/u4:34/15535:
>  #0: ffff88800fc69138 ((wq_completion)events_unbound){+.+.}-{0:0}, at: arch_atomic64_set arch/x86/include/asm/atomic64_64.h:34 [inline]
>  #0: ffff88800fc69138 ((wq_completion)events_unbound){+.+.}-{0:0}, at: atomic64_set include/asm-generic/atomic-instrumented.h:856 [inline]
>  #0: ffff88800fc69138 ((wq_completion)events_unbound){+.+.}-{0:0}, at: atomic_long_set include/asm-generic/atomic-long.h:41 [inline]
>  #0: ffff88800fc69138 ((wq_completion)events_unbound){+.+.}-{0:0}, at: set_work_data kernel/workqueue.c:616 [inline]
>  #0: ffff88800fc69138 ((wq_completion)events_unbound){+.+.}-{0:0}, at: set_work_pool_and_clear_pending kernel/workqueue.c:643 [inline]
>  #0: ffff88800fc69138 ((wq_completion)events_unbound){+.+.}-{0:0}, at: process_one_work+0x871/0x1600 kernel/workqueue.c:2246
>  #1: ffffc9000237fda8 ((work_completion)(&ctx->exit_work)){+.+.}-{0:0}, at: process_one_work+0x8a5/0x1600 kernel/workqueue.c:2250
> 2 locks held by kworker/u4:35/15640:
>  #0: ffff88800fc69138 ((wq_completion)events_unbound){+.+.}-{0:0}, at: arch_atomic64_set arch/x86/include/asm/atomic64_64.h:34 [inline]
>  #0: ffff88800fc69138 ((wq_completion)events_unbound){+.+.}-{0:0}, at: atomic64_set include/asm-generic/atomic-instrumented.h:856 [inline]
>  #0: ffff88800fc69138 ((wq_completion)events_unbound){+.+.}-{0:0}, at: atomic_long_set include/asm-generic/atomic-long.h:41 [inline]
>  #0: ffff88800fc69138 ((wq_completion)events_unbound){+.+.}-{0:0}, at: set_work_data kernel/workqueue.c:616 [inline]
>  #0: ffff88800fc69138 ((wq_completion)events_unbound){+.+.}-{0:0}, at: set_work_pool_and_clear_pending kernel/workqueue.c:643 [inline]
>  #0: ffff88800fc69138 ((wq_completion)events_unbound){+.+.}-{0:0}, at: process_one_work+0x871/0x1600 kernel/workqueue.c:2246
>  #1: ffffc90002defda8 ((work_completion)(&ctx->exit_work)){+.+.}-{0:0}, at: process_one_work+0x8a5/0x1600 kernel/workqueue.c:2250
> 2 locks held by kworker/u4:36/15854:
>  #0: ffff88800fc69138 ((wq_completion)events_unbound){+.+.}-{0:0}, at: arch_atomic64_set arch/x86/include/asm/atomic64_64.h:34 [inline]
>  #0: ffff88800fc69138 ((wq_completion)events_unbound){+.+.}-{0:0}, at: atomic64_set include/asm-generic/atomic-instrumented.h:856 [inline]
>  #0: ffff88800fc69138 ((wq_completion)events_unbound){+.+.}-{0:0}, at: atomic_long_set include/asm-generic/atomic-long.h:41 [inline]
>  #0: ffff88800fc69138 ((wq_completion)events_unbound){+.+.}-{0:0}, at: set_work_data kernel/workqueue.c:616 [inline]
>  #0: ffff88800fc69138 ((wq_completion)events_unbound){+.+.}-{0:0}, at: set_work_pool_and_clear_pending kernel/workqueue.c:643 [inline]
>  #0: ffff88800fc69138 ((wq_completion)events_unbound){+.+.}-{0:0}, at: process_one_work+0x871/0x1600 kernel/workqueue.c:2246
>  #1: ffffc90009ba7da8 ((work_completion)(&ctx->exit_work)){+.+.}-{0:0}, at: process_one_work+0x8a5/0x1600 kernel/workqueue.c:2250
> 2 locks held by kworker/u4:37/16150:
>  #0: ffff88800fc69138 ((wq_completion)events_unbound){+.+.}-{0:0}, at: arch_atomic64_set arch/x86/include/asm/atomic64_64.h:34 [inline]
>  #0: ffff88800fc69138 ((wq_completion)events_unbound){+.+.}-{0:0}, at: atomic64_set include/asm-generic/atomic-instrumented.h:856 [inline]
>  #0: ffff88800fc69138 ((wq_completion)events_unbound){+.+.}-{0:0}, at: atomic_long_set include/asm-generic/atomic-long.h:41 [inline]
>  #0: ffff88800fc69138 ((wq_completion)events_unbound){+.+.}-{0:0}, at: set_work_data kernel/workqueue.c:616 [inline]
>  #0: ffff88800fc69138 ((wq_completion)events_unbound){+.+.}-{0:0}, at: set_work_pool_and_clear_pending kernel/workqueue.c:643 [inline]
>  #0: ffff88800fc69138 ((wq_completion)events_unbound){+.+.}-{0:0}, at: process_one_work+0x871/0x1600 kernel/workqueue.c:2246
>  #1: ffffc9000b71fda8 ((work_completion)(&ctx->exit_work)){+.+.}-{0:0}, at: process_one_work+0x8a5/0x1600 kernel/workqueue.c:2250
> 2 locks held by kworker/u4:39/17160:
>  #0: ffff88800fc69138 ((wq_completion)events_unbound){+.+.}-{0:0}, at: arch_atomic64_set arch/x86/include/asm/atomic64_64.h:34 [inline]
>  #0: ffff88800fc69138 ((wq_completion)events_unbound){+.+.}-{0:0}, at: atomic64_set include/asm-generic/atomic-instrumented.h:856 [inline]
>  #0: ffff88800fc69138 ((wq_completion)events_unbound){+.+.}-{0:0}, at: atomic_long_set include/asm-generic/atomic-long.h:41 [inline]
>  #0: ffff88800fc69138 ((wq_completion)events_unbound){+.+.}-{0:0}, at: set_work_data kernel/workqueue.c:616 [inline]
>  #0: ffff88800fc69138 ((wq_completion)events_unbound){+.+.}-{0:0}, at: set_work_pool_and_clear_pending kernel/workqueue.c:643 [inline]
>  #0: ffff88800fc69138 ((wq_completion)events_unbound){+.+.}-{0:0}, at: process_one_work+0x871/0x1600 kernel/workqueue.c:2246
>  #1: ffffc90012a8fda8 ((work_completion)(&ctx->exit_work)){+.+.}-{0:0}, at: process_one_work+0x8a5/0x1600 kernel/workqueue.c:2250
> 5 locks held by kworker/u4:40/17617:
> 2 locks held by kworker/u4:41/17633:
>  #0: ffff88800fc69138 ((wq_completion)events_unbound){+.+.}-{0:0}, at: arch_atomic64_set arch/x86/include/asm/atomic64_64.h:34 [inline]
>  #0: ffff88800fc69138 ((wq_completion)events_unbound){+.+.}-{0:0}, at: atomic64_set include/asm-generic/atomic-instrumented.h:856 [inline]
>  #0: ffff88800fc69138 ((wq_completion)events_unbound){+.+.}-{0:0}, at: atomic_long_set include/asm-generic/atomic-long.h:41 [inline]
>  #0: ffff88800fc69138 ((wq_completion)events_unbound){+.+.}-{0:0}, at: set_work_data kernel/workqueue.c:616 [inline]
>  #0: ffff88800fc69138 ((wq_completion)events_unbound){+.+.}-{0:0}, at: set_work_pool_and_clear_pending kernel/workqueue.c:643 [inline]
>  #0: ffff88800fc69138 ((wq_completion)events_unbound){+.+.}-{0:0}, at: process_one_work+0x871/0x1600 kernel/workqueue.c:2246
>  #1: ffffc90013aefda8 ((work_completion)(&ctx->exit_work)){+.+.}-{0:0}, at: process_one_work+0x8a5/0x1600 kernel/workqueue.c:2250
> 2 locks held by kworker/u4:43/17720:
> 2 locks held by kworker/u4:45/17770:
>  #0: ffff88800fc69138 ((wq_completion)events_unbound){+.+.}-{0:0}, at: arch_atomic64_set arch/x86/include/asm/atomic64_64.h:34 [inline]
>  #0: ffff88800fc69138 ((wq_completion)events_unbound){+.+.}-{0:0}, at: atomic64_set include/asm-generic/atomic-instrumented.h:856 [inline]
>  #0: ffff88800fc69138 ((wq_completion)events_unbound){+.+.}-{0:0}, at: atomic_long_set include/asm-generic/atomic-long.h:41 [inline]
>  #0: ffff88800fc69138 ((wq_completion)events_unbound){+.+.}-{0:0}, at: set_work_data kernel/workqueue.c:616 [inline]
>  #0: ffff88800fc69138 ((wq_completion)events_unbound){+.+.}-{0:0}, at: set_work_pool_and_clear_pending kernel/workqueue.c:643 [inline]
>  #0: ffff88800fc69138 ((wq_completion)events_unbound){+.+.}-{0:0}, at: process_one_work+0x871/0x1600 kernel/workqueue.c:2246
>  #1: ffffc90013f9fda8 ((work_completion)(&ctx->exit_work)){+.+.}-{0:0}, at: process_one_work+0x8a5/0x1600 kernel/workqueue.c:2250
> 2 locks held by kworker/u4:46/17829:
>  #0: ffff88800fc69138 ((wq_completion)events_unbound){+.+.}-{0:0}, at: arch_atomic64_set arch/x86/include/asm/atomic64_64.h:34 [inline]
>  #0: ffff88800fc69138 ((wq_completion)events_unbound){+.+.}-{0:0}, at: atomic64_set include/asm-generic/atomic-instrumented.h:856 [inline]
>  #0: ffff88800fc69138 ((wq_completion)events_unbound){+.+.}-{0:0}, at: atomic_long_set include/asm-generic/atomic-long.h:41 [inline]
>  #0: ffff88800fc69138 ((wq_completion)events_unbound){+.+.}-{0:0}, at: set_work_data kernel/workqueue.c:616 [inline]
>  #0: ffff88800fc69138 ((wq_completion)events_unbound){+.+.}-{0:0}, at: set_work_pool_and_clear_pending kernel/workqueue.c:643 [inline]
>  #0: ffff88800fc69138 ((wq_completion)events_unbound){+.+.}-{0:0}, at: process_one_work+0x871/0x1600 kernel/workqueue.c:2246
>  #1: ffffc90013f5fda8 ((work_completion)(&ctx->exit_work)){+.+.}-{0:0}, at: process_one_work+0x8a5/0x1600 kernel/workqueue.c:2250
> 2 locks held by kworker/u4:47/17991:
>  #0: ffff88800fc69138 ((wq_completion)events_unbound){+.+.}-{0:0}, at: arch_atomic64_set arch/x86/include/asm/atomic64_64.h:34 [inline]
>  #0: ffff88800fc69138 ((wq_completion)events_unbound){+.+.}-{0:0}, at: atomic64_set include/asm-generic/atomic-instrumented.h:856 [inline]
>  #0: ffff88800fc69138 ((wq_completion)events_unbound){+.+.}-{0:0}, at: atomic_long_set include/asm-generic/atomic-long.h:41 [inline]
>  #0: ffff88800fc69138 ((wq_completion)events_unbound){+.+.}-{0:0}, at: set_work_data kernel/workqueue.c:616 [inline]
>  #0: ffff88800fc69138 ((wq_completion)events_unbound){+.+.}-{0:0}, at: set_work_pool_and_clear_pending kernel/workqueue.c:643 [inline]
>  #0: ffff88800fc69138 ((wq_completion)events_unbound){+.+.}-{0:0}, at: process_one_work+0x871/0x1600 kernel/workqueue.c:2246
>  #1: ffffc9001479fda8 ((work_completion)(&ctx->exit_work)){+.+.}-{0:0}, at: process_one_work+0x8a5/0x1600 kernel/workqueue.c:2250
> 2 locks held by kworker/u4:48/19272:
>  #0: ffff88800fc69138 ((wq_completion)events_unbound){+.+.}-{0:0}, at: arch_atomic64_set arch/x86/include/asm/atomic64_64.h:34 [inline]
>  #0: ffff88800fc69138 ((wq_completion)events_unbound){+.+.}-{0:0}, at: atomic64_set include/asm-generic/atomic-instrumented.h:856 [inline]
>  #0: ffff88800fc69138 ((wq_completion)events_unbound){+.+.}-{0:0}, at: atomic_long_set include/asm-generic/atomic-long.h:41 [inline]
>  #0: ffff88800fc69138 ((wq_completion)events_unbound){+.+.}-{0:0}, at: set_work_data kernel/workqueue.c:616 [inline]
>  #0: ffff88800fc69138 ((wq_completion)events_unbound){+.+.}-{0:0}, at: set_work_pool_and_clear_pending kernel/workqueue.c:643 [inline]
>  #0: ffff88800fc69138 ((wq_completion)events_unbound){+.+.}-{0:0}, at: process_one_work+0x871/0x1600 kernel/workqueue.c:2246
>  #1: ffffc9001280fda8 ((work_completion)(&ctx->exit_work)){+.+.}-{0:0}, at: process_one_work+0x8a5/0x1600 kernel/workqueue.c:2250
> 2 locks held by systemd-udevd/21711:
>  #0: ffff88801b9c4910 (&ei->i_mmap_sem){++++}-{3:3}, at: ext4_filemap_fault+0x7f/0xc0 fs/ext4/inode.c:6193
>  #1: ffffffff8b88ca40 (fs_reclaim){+.+.}-{0:0}, at: fs_reclaim_acquire+0xf7/0x150 mm/page_alloc.c:4349
> 1 lock held by syz-executor.0/21744:
>  #0: ffffffff8b77d328 (rcu_state.exp_mutex){+.+.}-{3:3}, at: exp_funnel_lock kernel/rcu/tree_exp.h:290 [inline]
>  #0: ffffffff8b77d328 (rcu_state.exp_mutex){+.+.}-{3:3}, at: synchronize_rcu_expedited+0x4fa/0x620 kernel/rcu/tree_exp.h:836
> 
> =============================================
> 
> NMI backtrace for cpu 1
> CPU: 1 PID: 1622 Comm: khungtaskd Not tainted 5.12.0-rc2-syzkaller #0
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
> CPU: 0 PID: 2126 Comm: kswapd1 Not tainted 5.12.0-rc2-syzkaller #0
> Hardware name: Google Google Compute Engine/Google Compute Engine, BIOS Google 01/01/2011
> RIP: 0010:lockdep_enabled kernel/locking/lockdep.c:90 [inline]
> RIP: 0010:lock_is_held_type+0x3a/0x140 kernel/locking/lockdep.c:5542
> Code: 48 83 ec 08 8b 0d b2 5d 44 04 85 c9 0f 84 d7 00 00 00 65 8b 05 97 3d 01 77 85 c0 0f 85 c8 00 00 00 65 4c 8b 24 25 00 f0 01 00 <41> 8b 94 24 e4 09 00 00 85 d2 0f 85 af 00 00 00 48 89 fd 41 89 f6
> RSP: 0018:ffffc90007fe7148 EFLAGS: 00000246
> RAX: 0000000000000000 RBX: 0000000000000000 RCX: 0000000000000001
> RDX: 0000000000000000 RSI: 00000000ffffffff RDI: ffffffff8b7746a0
> RBP: ffffffff897625c0 R08: 0000000000000000 R09: 0000000000000000
> R10: ffffffff81abc9e6 R11: 0000000000000000 R12: ffff888016a5b880
> R13: 0000000000000001 R14: 0000000000000000 R15: ffffea0008dba480
> FS:  0000000000000000(0000) GS:ffff8880b9e00000(0000) knlGS:0000000000000000
> CS:  0010 DS: 0000 ES: 0000 CR0: 0000000080050033
> CR2: 00007fff403f6f7c CR3: 000000000b48e000 CR4: 00000000001506f0
> DR0: 0000000000000000 DR1: 0000000000000000 DR2: 0000000000000000
> DR3: 0000000000000000 DR6: 00000000fffe0ff0 DR7: 0000000000000400
> Call Trace:
>  lock_is_held include/linux/lockdep.h:278 [inline]
>  ___might_sleep+0x23f/0x2c0 kernel/sched/core.c:8296
>  mmu_notifier_invalidate_range_start include/linux/mmu_notifier.h:448 [inline]
>  try_to_unmap_one+0x376/0x2b10 mm/rmap.c:1440
>  rmap_walk_file+0x567/0xca0 mm/rmap.c:1936
>  rmap_walk+0x105/0x190 mm/rmap.c:1954
>  try_to_unmap+0x315/0x390 mm/rmap.c:1778
>  shrink_page_list+0x2dd1/0x6420 mm/vmscan.c:1306
>  shrink_inactive_list+0x347/0xca0 mm/vmscan.c:1948
>  shrink_list mm/vmscan.c:2170 [inline]
>  shrink_lruvec+0x7f9/0x14f0 mm/vmscan.c:2465
>  shrink_node_memcgs mm/vmscan.c:2653 [inline]
>  shrink_node+0x868/0x1de0 mm/vmscan.c:2770
>  kswapd_shrink_node mm/vmscan.c:3513 [inline]
>  balance_pgdat+0x745/0x1270 mm/vmscan.c:3671
>  kswapd+0x5b6/0xdb0 mm/vmscan.c:3928
>  kthread+0x3b1/0x4a0 kernel/kthread.c:292
>  ret_from_fork+0x1f/0x30 arch/x86/entry/entry_64.S:294
> 
> 
> Tested on:
> 
> commit:         07c3d710 Revert "Revert "io_uring: wait potential ->releas..
> git tree:       https://github.com/isilence/linux.git syz_test2
> console output: https://syzkaller.appspot.com/x/log.txt?x=13e6e986d00000
> kernel config:  https://syzkaller.appspot.com/x/.config?x=86318203e865a02b
> dashboard link: https://syzkaller.appspot.com/bug?extid=93f72b3885406bb09e0d
> compiler:       
> 

-- 
Pavel Begunkov
