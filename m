Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 042A030A635
	for <lists+io-uring@lfdr.de>; Mon,  1 Feb 2021 12:09:15 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233301AbhBALIc (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Mon, 1 Feb 2021 06:08:32 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:41900 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233013AbhBALI3 (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Mon, 1 Feb 2021 06:08:29 -0500
Received: from mail-wr1-x434.google.com (mail-wr1-x434.google.com [IPv6:2a00:1450:4864:20::434])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 618CAC061573;
        Mon,  1 Feb 2021 03:07:48 -0800 (PST)
Received: by mail-wr1-x434.google.com with SMTP id 6so16093243wri.3;
        Mon, 01 Feb 2021 03:07:48 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=subject:to:references:from:autocrypt:message-id:date:user-agent
         :mime-version:in-reply-to:content-language:content-transfer-encoding;
        bh=LcOqa57+wDWNXngr1Vsho/uylvVvhlNXId8LmNBtEKY=;
        b=r+pgbrgIosJZzK1av8jh3I3H8mkjmc5/J+/SFoTDBksYii4iXOy+cDs9yJt3Vhp++e
         k58naFBNReRaNuhNGsCUok9POzyt+AW/q0MV6eEJn9dYJOxAWoI2l4PlU/+WPWC8Kp5Z
         P5Nze/hcYNb/eXx3oH4bAK73EIeq4sUweT9Y8LyFWsp9QJ7eRGYrfiicI8rp7EbVZUW2
         VZC6r6jEBq9iIO5B7D3mcGX5D/akIIkGRBmyHaAZmJ6Kd95A52Apn2q1dOUsBrzFa5+D
         7RFQWUIfOU4TpVRA9qhj8hn9TLEK5TvrX3yHTOTk6qfAveHBk4pJFDBG0zp/Y60q8kM2
         dVcg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:references:from:autocrypt:message-id
         :date:user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=LcOqa57+wDWNXngr1Vsho/uylvVvhlNXId8LmNBtEKY=;
        b=Pu92E9vPXecCOolMCqUDPuzo561w7SMEm+ykWD+fS8Ry9tcdy7CxRgtVKyu9p5Ggqs
         MSG9iqUhm23pW2gsSbZIkZsblFQjEdZcsyPyUf91shzBWX3n5Hus0NmmXiYPi2tq+OXs
         LfcpZ9h1yp2GHIecdWh+uynaKkYyogYXL7VVB2gMsOm7nKIqP5CzneTPaLXLXH+Ghrwk
         lbkrKTVe1R0t010GNM3CcqJ0XkWsPNJ9V6zag70zLsdj3tgmKrZA97myLMxPA/MhQc/p
         iUi06zDGCeRmSfSDfHlxLjF1K7gfQ5m1FlYL+w+YN5bSj7d5zFGxfegEAmdyufHuss+Q
         lRGQ==
X-Gm-Message-State: AOAM531NNhXr3OZpomeulKyNSKoE7ToldEZbJyC1SOBcs8QPiV9FMoD4
        5ii2hQhUrIVg27TS4YvwmrI=
X-Google-Smtp-Source: ABdhPJxBoDXxVVioQkDc8o6hCNsXGI2LrfOAXF0qzKWo0r/johOUVMC9FvyxKGHwem0+IroBQMAm4Q==
X-Received: by 2002:a5d:4d4c:: with SMTP id a12mr2906503wru.154.1612177666912;
        Mon, 01 Feb 2021 03:07:46 -0800 (PST)
Received: from [192.168.8.166] ([185.69.145.241])
        by smtp.gmail.com with ESMTPSA id a27sm26243131wrc.94.2021.02.01.03.07.45
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Mon, 01 Feb 2021 03:07:46 -0800 (PST)
Subject: Re: WARNING in io_disable_sqo_submit
To:     syzbot <syzbot+2f5d1785dc624932da78@syzkaller.appspotmail.com>,
        axboe@kernel.dk, hdanton@sina.com, io-uring@vger.kernel.org,
        linux-fsdevel@vger.kernel.org, linux-kernel@vger.kernel.org,
        syzkaller-bugs@googlegroups.com, viro@zeniv.linux.org.uk
References: <00000000000042c22b05b92c1b44@google.com>
From:   Pavel Begunkov <asml.silence@gmail.com>
Autocrypt: addr=asml.silence@gmail.com; prefer-encrypt=mutual; keydata=
 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 bA==
Message-ID: <39ebb181-6760-cdfd-88f8-5578ad4d7c85@gmail.com>
Date:   Mon, 1 Feb 2021 11:04:04 +0000
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.3.0
MIME-Version: 1.0
In-Reply-To: <00000000000042c22b05b92c1b44@google.com>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org

On 18/01/2021 12:46, syzbot wrote:
> Hello,
> 
> syzbot has tested the proposed patch but the reproducer is still triggering an issue:
> INFO: task hung in io_sq_thread_stop

#syz test: git://git.kernel.dk/linux-block for-5.12/io_uring

> INFO: task kworker/u4:0:8 blocked for more than 143 seconds.
>       Not tainted 5.11.0-rc1-syzkaller #0
> "echo 0 > /proc/sys/kernel/hung_task_timeout_secs" disables this message.
> task:kworker/u4:0    state:D stack:24056 pid:    8 ppid:     2 flags:0x00004000
> Workqueue: events_unbound io_ring_exit_work
> Call Trace:
>  context_switch kernel/sched/core.c:4313 [inline]
>  __schedule+0x90c/0x21a0 kernel/sched/core.c:5064
>  schedule+0xcf/0x270 kernel/sched/core.c:5143
>  schedule_timeout+0x1d8/0x250 kernel/time/timer.c:1854
>  do_wait_for_common kernel/sched/completion.c:85 [inline]
>  __wait_for_common kernel/sched/completion.c:106 [inline]
>  wait_for_common kernel/sched/completion.c:117 [inline]
>  wait_for_completion+0x163/0x260 kernel/sched/completion.c:138
>  kthread_park+0x122/0x1b0 kernel/kthread.c:557
>  io_sq_thread_park fs/io_uring.c:7445 [inline]
>  io_sq_thread_park fs/io_uring.c:7439 [inline]
>  io_sq_thread_stop+0xfe/0x570 fs/io_uring.c:7463
>  io_finish_async fs/io_uring.c:7481 [inline]
>  io_ring_ctx_free fs/io_uring.c:8646 [inline]
>  io_ring_exit_work+0x62/0x6d0 fs/io_uring.c:8739
>  process_one_work+0x98d/0x15f0 kernel/workqueue.c:2275
>  worker_thread+0x64c/0x1120 kernel/workqueue.c:2421
>  kthread+0x3b1/0x4a0 kernel/kthread.c:292
>  ret_from_fork+0x1f/0x30 arch/x86/entry/entry_64.S:296
> 
> Showing all locks held in the system:
> 3 locks held by kworker/u4:0/8:
>  #0: ffff888010069138 ((wq_completion)events_unbound){+.+.}-{0:0}, at: arch_atomic64_set arch/x86/include/asm/atomic64_64.h:34 [inline]
>  #0: ffff888010069138 ((wq_completion)events_unbound){+.+.}-{0:0}, at: atomic64_set include/asm-generic/atomic-instrumented.h:856 [inline]
>  #0: ffff888010069138 ((wq_completion)events_unbound){+.+.}-{0:0}, at: atomic_long_set include/asm-generic/atomic-long.h:41 [inline]
>  #0: ffff888010069138 ((wq_completion)events_unbound){+.+.}-{0:0}, at: set_work_data kernel/workqueue.c:616 [inline]
>  #0: ffff888010069138 ((wq_completion)events_unbound){+.+.}-{0:0}, at: set_work_pool_and_clear_pending kernel/workqueue.c:643 [inline]
>  #0: ffff888010069138 ((wq_completion)events_unbound){+.+.}-{0:0}, at: process_one_work+0x871/0x15f0 kernel/workqueue.c:2246
>  #1: ffffc90000cd7da8 ((work_completion)(&ctx->exit_work)){+.+.}-{0:0}, at: process_one_work+0x8a5/0x15f0 kernel/workqueue.c:2250
>  #2: ffff88801bfd4870 (&sqd->lock){+.+.}-{3:3}, at: io_sq_thread_park fs/io_uring.c:7444 [inline]
>  #2: ffff88801bfd4870 (&sqd->lock){+.+.}-{3:3}, at: io_sq_thread_park fs/io_uring.c:7439 [inline]
>  #2: ffff88801bfd4870 (&sqd->lock){+.+.}-{3:3}, at: io_sq_thread_stop+0xd6/0x570 fs/io_uring.c:7463
> 1 lock held by khungtaskd/1647:
>  #0: ffffffff8b373aa0 (rcu_read_lock){....}-{1:2}, at: debug_show_all_locks+0x53/0x260 kernel/locking/lockdep.c:6254
> 1 lock held by in:imklog/8164:
>  #0: ffff8880151b8870 (&f->f_pos_lock){+.+.}-{3:3}, at: __fdget_pos+0xe9/0x100 fs/file.c:947
> 2 locks held by kworker/u4:6/8415:
> 2 locks held by kworker/0:4/8690:
>  #0: ffff88801007c538 ((wq_completion)rcu_gp){+.+.}-{0:0}, at: arch_atomic64_set arch/x86/include/asm/atomic64_64.h:34 [inline]
>  #0: ffff88801007c538 ((wq_completion)rcu_gp){+.+.}-{0:0}, at: atomic64_set include/asm-generic/atomic-instrumented.h:856 [inline]
>  #0: ffff88801007c538 ((wq_completion)rcu_gp){+.+.}-{0:0}, at: atomic_long_set include/asm-generic/atomic-long.h:41 [inline]
>  #0: ffff88801007c538 ((wq_completion)rcu_gp){+.+.}-{0:0}, at: set_work_data kernel/workqueue.c:616 [inline]
>  #0: ffff88801007c538 ((wq_completion)rcu_gp){+.+.}-{0:0}, at: set_work_pool_and_clear_pending kernel/workqueue.c:643 [inline]
>  #0: ffff88801007c538 ((wq_completion)rcu_gp){+.+.}-{0:0}, at: process_one_work+0x871/0x15f0 kernel/workqueue.c:2246
>  #1: ffffc9000288fda8 ((work_completion)(&rew.rew_work)){+.+.}-{0:0}, at: process_one_work+0x8a5/0x15f0 kernel/workqueue.c:2250
> 1 lock held by syz-executor.3/8865:
>  #0: ffff888146ddcd88 (&xt[i].mutex){+.+.}-{3:3}, at: xt_find_table_lock+0x41/0x540 net/netfilter/x_tables.c:1206
> 1 lock held by syz-executor.2/8867:
>  #0: ffff888146ddcd88 (&xt[i].mutex){+.+.}-{3:3}, at: xt_find_table_lock+0x41/0x540 net/netfilter/x_tables.c:1206
> 2 locks held by syz-executor.5/8869:
>  #0: ffff888146ddcd88 (&xt[i].mutex){+.+.}-{3:3}, at: xt_find_table_lock+0x41/0x540 net/netfilter/x_tables.c:1206
>  #1: ffffffff8b37c368 (rcu_state.exp_mutex){+.+.}-{3:3}, at: exp_funnel_lock kernel/rcu/tree_exp.h:290 [inline]
>  #1: ffffffff8b37c368 (rcu_state.exp_mutex){+.+.}-{3:3}, at: synchronize_rcu_expedited+0x4f2/0x610 kernel/rcu/tree_exp.h:836
> 1 lock held by syz-executor.4/8870:
>  #0: ffff888146ddcd88 (&xt[i].mutex){+.+.}-{3:3}, at: xt_find_table_lock+0x41/0x540 net/netfilter/x_tables.c:1206
> 1 lock held by syz-executor.0/8872:
>  #0: ffff888146ddcd88 (&xt[i].mutex){+.+.}-{3:3}, at: xt_find_table_lock+0x41/0x540 net/netfilter/x_tables.c:1206
> 1 lock held by syz-executor.1/8873:
>  #0: ffff888146ddcd88 (&xt[i].mutex){+.+.}-{3:3}, at: xt_find_table_lock+0x41/0x540 net/netfilter/x_tables.c:1206
> 
> =============================================
> 
> NMI backtrace for cpu 1
> CPU: 1 PID: 1647 Comm: khungtaskd Not tainted 5.11.0-rc1-syzkaller #0
> Hardware name: Google Google Compute Engine/Google Compute Engine, BIOS Google 01/01/2011
> Call Trace:
>  __dump_stack lib/dump_stack.c:79 [inline]
>  dump_stack+0x107/0x163 lib/dump_stack.c:120
>  nmi_cpu_backtrace.cold+0x44/0xd7 lib/nmi_backtrace.c:105
>  nmi_trigger_cpumask_backtrace+0x1b3/0x230 lib/nmi_backtrace.c:62
>  trigger_all_cpu_backtrace include/linux/nmi.h:146 [inline]
>  check_hung_uninterruptible_tasks kernel/hung_task.c:209 [inline]
>  watchdog+0xd43/0xfa0 kernel/hung_task.c:294
>  kthread+0x3b1/0x4a0 kernel/kthread.c:292
>  ret_from_fork+0x1f/0x30 arch/x86/entry/entry_64.S:296
> Sending NMI from CPU 1 to CPUs 0:
> NMI backtrace for cpu 0
> CPU: 0 PID: 8415 Comm: kworker/u4:6 Not tainted 5.11.0-rc1-syzkaller #0
> Hardware name: Google Google Compute Engine/Google Compute Engine, BIOS Google 01/01/2011
> Workqueue: bat_events batadv_nc_worker
> RIP: 0010:__this_cpu_preempt_check+0xd/0x20 lib/smp_processor_id.c:70
> Code: 00 00 48 c7 c6 00 d9 9e 89 48 c7 c7 40 d9 9e 89 e9 98 fe ff ff 0f 1f 84 00 00 00 00 00 55 48 89 fd 0f 1f 44 00 00 48 89 ee 5d <48> c7 c7 80 d9 9e 89 e9 77 fe ff ff cc cc cc cc cc cc cc 0f 1f 44
> RSP: 0018:ffffc9000c507af0 EFLAGS: 00000046
> RAX: 0000000000000001 RBX: 0000000000000000 RCX: 1ffffffff1a077ab
> RDX: 0000000000000000 RSI: ffffffff894bac40 RDI: ffffffff894bac40
> RBP: ffffffff8b3739e0 R08: 0000000000000000 R09: ffffffff8d038b8f
> R10: fffffbfff1a07171 R11: 0000000000000000 R12: 0000000000000001
> R13: ffff88802f858bc0 R14: 00000000ffffffff R15: ffffffff889a5430
> FS:  0000000000000000(0000) GS:ffff8880b9e00000(0000) knlGS:0000000000000000
> CS:  0010 DS: 0000 ES: 0000 CR0: 0000000080050033
> CR2: 00007fbcc03ca000 CR3: 0000000011523000 CR4: 0000000000350ef0
> Call Trace:
>  lockdep_recursion_inc kernel/locking/lockdep.c:432 [inline]
>  lock_is_held_type+0x34/0x100 kernel/locking/lockdep.c:5475
>  lock_is_held include/linux/lockdep.h:271 [inline]
>  rcu_read_lock_sched_held+0x3a/0x70 kernel/rcu/update.c:123
>  trace_lock_release include/trace/events/lock.h:58 [inline]
>  lock_release+0x5b7/0x710 kernel/locking/lockdep.c:5448
>  __raw_spin_unlock_bh include/linux/spinlock_api_smp.h:174 [inline]
>  _raw_spin_unlock_bh+0x12/0x30 kernel/locking/spinlock.c:207
>  spin_unlock_bh include/linux/spinlock.h:399 [inline]
>  batadv_nc_purge_paths+0x2a5/0x3a0 net/batman-adv/network-coding.c:467
>  batadv_nc_worker+0x831/0xe50 net/batman-adv/network-coding.c:716
>  process_one_work+0x98d/0x15f0 kernel/workqueue.c:2275
>  worker_thread+0x64c/0x1120 kernel/workqueue.c:2421
>  kthread+0x3b1/0x4a0 kernel/kthread.c:292
>  ret_from_fork+0x1f/0x30 arch/x86/entry/entry_64.S:296
> 
> 
> Tested on:
> 
> commit:         a1235e44 io_uring: cancel all requests on task exit
> git tree:       git://git.kernel.dk/linux-block io_uring-5.11
> console output: https://syzkaller.appspot.com/x/log.txt?x=10c53584d00000
> kernel config:  https://syzkaller.appspot.com/x/.config?x=c6b6b5cccb0f38f2
> dashboard link: https://syzkaller.appspot.com/bug?extid=2f5d1785dc624932da78
> compiler:       gcc (GCC) 10.1.0-syz 20200507
> 

-- 
Pavel Begunkov
