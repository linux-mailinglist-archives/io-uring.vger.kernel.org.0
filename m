Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 48248322BBF
	for <lists+io-uring@lfdr.de>; Tue, 23 Feb 2021 14:54:40 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229886AbhBWNyg (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Tue, 23 Feb 2021 08:54:36 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:49686 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229823AbhBWNyd (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Tue, 23 Feb 2021 08:54:33 -0500
Received: from mail-wm1-x32f.google.com (mail-wm1-x32f.google.com [IPv6:2a00:1450:4864:20::32f])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 194CBC061786;
        Tue, 23 Feb 2021 05:53:53 -0800 (PST)
Received: by mail-wm1-x32f.google.com with SMTP id l13so2509007wmg.5;
        Tue, 23 Feb 2021 05:53:53 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=subject:to:references:from:autocrypt:message-id:date:user-agent
         :mime-version:in-reply-to:content-language:content-transfer-encoding;
        bh=6tw76VnuLjFMgn4T9bkfd6VafA8xKP4Ai1as7ZXDqK8=;
        b=EWoz4W1c3moghCzHWSkNfyPb2a9fzaRkvlbUo3+PzQgCiRjMJaVYCcfyVEUkKMgKKZ
         CeLMt2Jubkr5tBxyktTslceNBqg+VrZ3ogB5hGd7hFP8gtNmqeQdh2fTnPvf7mKf7ofs
         ZV6t6vwMXKNGWW8JhXxz/yAgvDT3FO+VVv0HETZ4WOZveKAXcy9ZzqiEdCAgirsMDDA9
         CyeV9a32OTD93vFbPCEvO6nbWTH+Ad0Ip2RkFj81dASHg8A+b/2iihGnoB+6+P4bXPIY
         cd3dbXxxydPFUxAPosPWM+djIgHd1sSijWqykv3LDUnj1eQhodN3TF46ZOQ7iDbNXLNK
         FExw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:references:from:autocrypt:message-id
         :date:user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=6tw76VnuLjFMgn4T9bkfd6VafA8xKP4Ai1as7ZXDqK8=;
        b=oPO4OKKq9oPIESr2zlEI9kfOSXVZpIbvl36gAFQbK5mWb++UWf8pBkecKzj0WrR4Bp
         S2w5/ElMshgK65HECC/tdh5HsV8FiALq44xNpXwjQH3EZ7mjCrONhnMegr/6NPbmptzT
         nrZOsDyDagV54xRHeIxqKbvXuL5hZ+Tt4mEF7mIXqmZE8JiUPg101ns1gvcDGtPO8MCR
         ouIG6CjgC6Ch2qJclGGqt2Wm+zr6Ktp1OLu+2nBUkkrFHoE5v8ZBnzvOXiDCLzwwgeLo
         byC+qqYXa4PB9LRoKGEeflKcgRh/l+UTR/KL2wuEjpPd3EpyXaElXar32YpxHtgrcd8h
         lprQ==
X-Gm-Message-State: AOAM532qeEqSW/jWOz4KtNfw9ctlDnKeTDelubqTNkss3p/Miz1Tk2pj
        yidmcyjMr0NfwsDQgZAsu40=
X-Google-Smtp-Source: ABdhPJwSlYkhRpoHY8gfXgCF/0newcJwAPpOWODvyjNoJybBOjC3CtBTLMxhQbuEFWvHw8znwaTX5A==
X-Received: by 2002:a1c:41c3:: with SMTP id o186mr25305633wma.7.1614088431816;
        Tue, 23 Feb 2021 05:53:51 -0800 (PST)
Received: from [192.168.8.157] ([148.252.132.56])
        by smtp.gmail.com with ESMTPSA id o9sm841748wmc.8.2021.02.23.05.53.50
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Tue, 23 Feb 2021 05:53:51 -0800 (PST)
Subject: Re: possible deadlock in io_link_timeout_fn
To:     syzbot <syzbot+9a512c5bdc15635eab70@syzkaller.appspotmail.com>,
        axboe@kernel.dk, io-uring@vger.kernel.org,
        linux-kernel@vger.kernel.org, syzkaller-bugs@googlegroups.com
References: <00000000000097f98905bc00fd53@google.com>
From:   Pavel Begunkov <asml.silence@gmail.com>
Autocrypt: addr=asml.silence@gmail.com; prefer-encrypt=mutual; keydata=
 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 bA==
Message-ID: <5003d05e-4fd9-5d0b-86ed-4e81b48ccf76@gmail.com>
Date:   Tue, 23 Feb 2021 13:50:00 +0000
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.3.0
MIME-Version: 1.0
In-Reply-To: <00000000000097f98905bc00fd53@google.com>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org

On 23/02/2021 13:35, syzbot wrote:
> Hello,
> 
> syzbot found the following issue on:
> 
> HEAD commit:    31caf8b2 Merge branch 'linus' of git://git.kernel.org/pub/..
> git tree:       upstream
> console output: https://syzkaller.appspot.com/x/log.txt?x=11c64f12d00000
> kernel config:  https://syzkaller.appspot.com/x/.config?x=5a8f3a57fabb4015
> dashboard link: https://syzkaller.appspot.com/bug?extid=9a512c5bdc15635eab70
> 
> Unfortunately, I don't have any reproducer for this issue yet.
> 
> IMPORTANT: if you fix the issue, please add the following tag to the commit:
> Reported-by: syzbot+9a512c5bdc15635eab70@syzkaller.appspotmail.com

Ok, that IRQ recycling stuff kicks in. I guess we can take
work_clean out of spin, I'll try it out this evening.

Either, Jen's io-wq patches go 5.12 in the end, and it would probably be
solved naturally.

> 
> =====================================================
> WARNING: HARDIRQ-safe -> HARDIRQ-unsafe lock order detected
> 5.11.0-syzkaller #0 Not tainted
> -----------------------------------------------------
> syz-executor.0/12185 [HC0[0]:SC0[0]:HE0:SE1] is trying to acquire:
> ffff888013db4820 (&fs->lock){+.+.}-{2:2}, at: spin_lock include/linux/spinlock.h:354 [inline]
> ffff888013db4820 (&fs->lock){+.+.}-{2:2}, at: io_req_clean_work fs/io_uring.c:1405 [inline]
> ffff888013db4820 (&fs->lock){+.+.}-{2:2}, at: io_dismantle_req+0x90f/0xf90 fs/io_uring.c:2051
> 
> and this task is already holding:
> ffff88806bea6718 (&ctx->completion_lock){-...}-{2:2}, at: io_req_complete_post+0x4e/0x920 fs/io_uring.c:1923
> which would create a new lock dependency:
>  (&ctx->completion_lock){-...}-{2:2} -> (&fs->lock){+.+.}-{2:2}
> 
> but this new dependency connects a HARDIRQ-irq-safe lock:
>  (&ctx->completion_lock){-...}-{2:2}
> 
> ... which became HARDIRQ-irq-safe at:
>   lock_acquire kernel/locking/lockdep.c:5510 [inline]
>   lock_acquire+0x1ab/0x730 kernel/locking/lockdep.c:5475
>   __raw_spin_lock_irqsave include/linux/spinlock_api_smp.h:110 [inline]
>   _raw_spin_lock_irqsave+0x39/0x50 kernel/locking/spinlock.c:159
>   io_link_timeout_fn+0xbf/0x720 fs/io_uring.c:6495
>   __run_hrtimer kernel/time/hrtimer.c:1519 [inline]
>   __hrtimer_run_queues+0x609/0xe40 kernel/time/hrtimer.c:1583
>   hrtimer_interrupt+0x334/0x940 kernel/time/hrtimer.c:1645
>   local_apic_timer_interrupt arch/x86/kernel/apic/apic.c:1089 [inline]
>   __sysvec_apic_timer_interrupt+0x146/0x540 arch/x86/kernel/apic/apic.c:1106
>   asm_call_irq_on_stack+0xf/0x20
>   __run_sysvec_on_irqstack arch/x86/include/asm/irq_stack.h:37 [inline]
>   run_sysvec_on_irqstack_cond arch/x86/include/asm/irq_stack.h:89 [inline]
>   sysvec_apic_timer_interrupt+0xbd/0x100 arch/x86/kernel/apic/apic.c:1100
>   asm_sysvec_apic_timer_interrupt+0x12/0x20 arch/x86/include/asm/idtentry.h:635
>   __raw_spin_unlock_irq include/linux/spinlock_api_smp.h:169 [inline]
>   _raw_spin_unlock_irq+0x25/0x40 kernel/locking/spinlock.c:199
>   spin_unlock_irq include/linux/spinlock.h:404 [inline]
>   io_queue_linked_timeout+0x194/0x1f0 fs/io_uring.c:6541
>   __io_queue_sqe+0x32f/0xdb0 fs/io_uring.c:6607
>   __io_req_task_submit+0x18e/0x240 fs/io_uring.c:2344
>   __tctx_task_work fs/io_uring.c:2204 [inline]
>   tctx_task_work+0x12b/0x330 fs/io_uring.c:2230
>   task_work_run+0xdd/0x1a0 kernel/task_work.c:140
>   tracehook_notify_signal include/linux/tracehook.h:212 [inline]
>   handle_signal_work kernel/entry/common.c:145 [inline]
>   exit_to_user_mode_loop kernel/entry/common.c:171 [inline]
>   exit_to_user_mode_prepare+0x221/0x250 kernel/entry/common.c:208
>   __syscall_exit_to_user_mode_work kernel/entry/common.c:290 [inline]
>   syscall_exit_to_user_mode+0x19/0x50 kernel/entry/common.c:301
>   entry_SYSCALL_64_after_hwframe+0x44/0xae
> 
> to a HARDIRQ-irq-unsafe lock:
>  (&fs->lock){+.+.}-{2:2}
> 
> ... which became HARDIRQ-irq-unsafe at:
> ...
>   lock_acquire kernel/locking/lockdep.c:5510 [inline]
>   lock_acquire+0x1ab/0x730 kernel/locking/lockdep.c:5475
>   __raw_spin_lock include/linux/spinlock_api_smp.h:142 [inline]
>   _raw_spin_lock+0x2a/0x40 kernel/locking/spinlock.c:151
>   spin_lock include/linux/spinlock.h:354 [inline]
>   set_fs_pwd+0x85/0x2a0 fs/fs_struct.c:39
>   init_chdir+0x106/0x14e fs/init.c:54
>   devtmpfs_setup drivers/base/devtmpfs.c:415 [inline]
>   devtmpfsd+0x76/0x333 drivers/base/devtmpfs.c:430
>   kthread+0x3b1/0x4a0 kernel/kthread.c:292
>   ret_from_fork+0x1f/0x30 arch/x86/entry/entry_64.S:294
> 
> other info that might help us debug this:
> 
>  Possible interrupt unsafe locking scenario:
> 
>        CPU0                    CPU1
>        ----                    ----
>   lock(&fs->lock);
>                                local_irq_disable();
>                                lock(&ctx->completion_lock);
>                                lock(&fs->lock);
>   <Interrupt>
>     lock(&ctx->completion_lock);
> 
>  *** DEADLOCK ***
> 
> 1 lock held by syz-executor.0/12185:
>  #0: ffff88806bea6718 (&ctx->completion_lock){-...}-{2:2}, at: io_req_complete_post+0x4e/0x920 fs/io_uring.c:1923
> 
> the dependencies between HARDIRQ-irq-safe lock and the holding lock:
> -> (&ctx->completion_lock){-...}-{2:2} {
>    IN-HARDIRQ-W at:
>                     lock_acquire kernel/locking/lockdep.c:5510 [inline]
>                     lock_acquire+0x1ab/0x730 kernel/locking/lockdep.c:5475
>                     __raw_spin_lock_irqsave include/linux/spinlock_api_smp.h:110 [inline]
>                     _raw_spin_lock_irqsave+0x39/0x50 kernel/locking/spinlock.c:159
>                     io_link_timeout_fn+0xbf/0x720 fs/io_uring.c:6495
>                     __run_hrtimer kernel/time/hrtimer.c:1519 [inline]
>                     __hrtimer_run_queues+0x609/0xe40 kernel/time/hrtimer.c:1583
>                     hrtimer_interrupt+0x334/0x940 kernel/time/hrtimer.c:1645
>                     local_apic_timer_interrupt arch/x86/kernel/apic/apic.c:1089 [inline]
>                     __sysvec_apic_timer_interrupt+0x146/0x540 arch/x86/kernel/apic/apic.c:1106
>                     asm_call_irq_on_stack+0xf/0x20
>                     __run_sysvec_on_irqstack arch/x86/include/asm/irq_stack.h:37 [inline]
>                     run_sysvec_on_irqstack_cond arch/x86/include/asm/irq_stack.h:89 [inline]
>                     sysvec_apic_timer_interrupt+0xbd/0x100 arch/x86/kernel/apic/apic.c:1100
>                     asm_sysvec_apic_timer_interrupt+0x12/0x20 arch/x86/include/asm/idtentry.h:635
>                     __raw_spin_unlock_irq include/linux/spinlock_api_smp.h:169 [inline]
>                     _raw_spin_unlock_irq+0x25/0x40 kernel/locking/spinlock.c:199
>                     spin_unlock_irq include/linux/spinlock.h:404 [inline]
>                     io_queue_linked_timeout+0x194/0x1f0 fs/io_uring.c:6541
>                     __io_queue_sqe+0x32f/0xdb0 fs/io_uring.c:6607
>                     __io_req_task_submit+0x18e/0x240 fs/io_uring.c:2344
>                     __tctx_task_work fs/io_uring.c:2204 [inline]
>                     tctx_task_work+0x12b/0x330 fs/io_uring.c:2230
>                     task_work_run+0xdd/0x1a0 kernel/task_work.c:140
>                     tracehook_notify_signal include/linux/tracehook.h:212 [inline]
>                     handle_signal_work kernel/entry/common.c:145 [inline]
>                     exit_to_user_mode_loop kernel/entry/common.c:171 [inline]
>                     exit_to_user_mode_prepare+0x221/0x250 kernel/entry/common.c:208
>                     __syscall_exit_to_user_mode_work kernel/entry/common.c:290 [inline]
>                     syscall_exit_to_user_mode+0x19/0x50 kernel/entry/common.c:301
>                     entry_SYSCALL_64_after_hwframe+0x44/0xae
>    INITIAL USE at:
>                    lock_acquire kernel/locking/lockdep.c:5510 [inline]
>                    lock_acquire+0x1ab/0x730 kernel/locking/lockdep.c:5475
>                    __raw_spin_lock_irqsave include/linux/spinlock_api_smp.h:110 [inline]
>                    _raw_spin_lock_irqsave+0x39/0x50 kernel/locking/spinlock.c:159
>                    io_req_complete_post+0x4e/0x920 fs/io_uring.c:1923
>                    __io_req_complete fs/io_uring.c:1963 [inline]
>                    io_req_complete fs/io_uring.c:1968 [inline]
>                    io_queue_sqe+0xa3b/0xfa0 fs/io_uring.c:6620
>                    io_submit_sqe fs/io_uring.c:6707 [inline]
>                    io_submit_sqes+0x15f5/0x2b60 fs/io_uring.c:6939
>                    __do_sys_io_uring_enter+0x1154/0x1f50 fs/io_uring.c:9454
>                    do_syscall_64+0x2d/0x70 arch/x86/entry/common.c:46
>                    entry_SYSCALL_64_after_hwframe+0x44/0xae
>  }
>  ... key      at: [<ffffffff8fe69a80>] __key.9+0x0/0x40
>  ... acquired at:
>    lock_acquire kernel/locking/lockdep.c:5510 [inline]
>    lock_acquire+0x1ab/0x730 kernel/locking/lockdep.c:5475
>    __raw_spin_lock include/linux/spinlock_api_smp.h:142 [inline]
>    _raw_spin_lock+0x2a/0x40 kernel/locking/spinlock.c:151
>    spin_lock include/linux/spinlock.h:354 [inline]
>    io_req_clean_work fs/io_uring.c:1405 [inline]
>    io_dismantle_req+0x90f/0xf90 fs/io_uring.c:2051
>    io_req_complete_post+0xf6/0x920 fs/io_uring.c:1933
>    __io_req_complete fs/io_uring.c:1963 [inline]
>    io_req_complete fs/io_uring.c:1968 [inline]
>    io_cancel_defer_files fs/io_uring.c:8945 [inline]
>    io_uring_cancel_task_requests+0x67e/0xea0 fs/io_uring.c:9052
>    __io_uring_files_cancel+0x110/0x1b0 fs/io_uring.c:9140
>    io_uring_files_cancel include/linux/io_uring.h:65 [inline]
>    do_exit+0x2fe/0x2ae0 kernel/exit.c:780
>    do_group_exit+0x125/0x310 kernel/exit.c:922
>    get_signal+0x42c/0x2100 kernel/signal.c:2773
>    arch_do_signal_or_restart+0x2a8/0x1eb0 arch/x86/kernel/signal.c:811
>    handle_signal_work kernel/entry/common.c:147 [inline]
>    exit_to_user_mode_loop kernel/entry/common.c:171 [inline]
>    exit_to_user_mode_prepare+0x148/0x250 kernel/entry/common.c:208
>    __syscall_exit_to_user_mode_work kernel/entry/common.c:290 [inline]
>    syscall_exit_to_user_mode+0x19/0x50 kernel/entry/common.c:301
>    entry_SYSCALL_64_after_hwframe+0x44/0xae
> 
> 
> the dependencies between the lock to be acquired
>  and HARDIRQ-irq-unsafe lock:
> -> (&fs->lock){+.+.}-{2:2} {
>    HARDIRQ-ON-W at:
>                     lock_acquire kernel/locking/lockdep.c:5510 [inline]
>                     lock_acquire+0x1ab/0x730 kernel/locking/lockdep.c:5475
>                     __raw_spin_lock include/linux/spinlock_api_smp.h:142 [inline]
>                     _raw_spin_lock+0x2a/0x40 kernel/locking/spinlock.c:151
>                     spin_lock include/linux/spinlock.h:354 [inline]
>                     set_fs_pwd+0x85/0x2a0 fs/fs_struct.c:39
>                     init_chdir+0x106/0x14e fs/init.c:54
>                     devtmpfs_setup drivers/base/devtmpfs.c:415 [inline]
>                     devtmpfsd+0x76/0x333 drivers/base/devtmpfs.c:430
>                     kthread+0x3b1/0x4a0 kernel/kthread.c:292
>                     ret_from_fork+0x1f/0x30 arch/x86/entry/entry_64.S:294
>    SOFTIRQ-ON-W at:
>                     lock_acquire kernel/locking/lockdep.c:5510 [inline]
>                     lock_acquire+0x1ab/0x730 kernel/locking/lockdep.c:5475
>                     __raw_spin_lock include/linux/spinlock_api_smp.h:142 [inline]
>                     _raw_spin_lock+0x2a/0x40 kernel/locking/spinlock.c:151
>                     spin_lock include/linux/spinlock.h:354 [inline]
>                     set_fs_pwd+0x85/0x2a0 fs/fs_struct.c:39
>                     init_chdir+0x106/0x14e fs/init.c:54
>                     devtmpfs_setup drivers/base/devtmpfs.c:415 [inline]
>                     devtmpfsd+0x76/0x333 drivers/base/devtmpfs.c:430
>                     kthread+0x3b1/0x4a0 kernel/kthread.c:292
>                     ret_from_fork+0x1f/0x30 arch/x86/entry/entry_64.S:294
>    INITIAL USE at:
>                    lock_acquire kernel/locking/lockdep.c:5510 [inline]
>                    lock_acquire+0x1ab/0x730 kernel/locking/lockdep.c:5475
>                    __raw_spin_lock include/linux/spinlock_api_smp.h:142 [inline]
>                    _raw_spin_lock+0x2a/0x40 kernel/locking/spinlock.c:151
>                    spin_lock include/linux/spinlock.h:354 [inline]
>                    set_fs_pwd+0x85/0x2a0 fs/fs_struct.c:39
>                    init_chdir+0x106/0x14e fs/init.c:54
>                    devtmpfs_setup drivers/base/devtmpfs.c:415 [inline]
>                    devtmpfsd+0x76/0x333 drivers/base/devtmpfs.c:430
>                    kthread+0x3b1/0x4a0 kernel/kthread.c:292
>                    ret_from_fork+0x1f/0x30 arch/x86/entry/entry_64.S:294
>  }
>  ... key      at: [<ffffffff8fe68260>] __key.1+0x0/0x40
>  ... acquired at:
>    lock_acquire kernel/locking/lockdep.c:5510 [inline]
>    lock_acquire+0x1ab/0x730 kernel/locking/lockdep.c:5475
>    __raw_spin_lock include/linux/spinlock_api_smp.h:142 [inline]
>    _raw_spin_lock+0x2a/0x40 kernel/locking/spinlock.c:151
>    spin_lock include/linux/spinlock.h:354 [inline]
>    io_req_clean_work fs/io_uring.c:1405 [inline]
>    io_dismantle_req+0x90f/0xf90 fs/io_uring.c:2051
>    io_req_complete_post+0xf6/0x920 fs/io_uring.c:1933
>    __io_req_complete fs/io_uring.c:1963 [inline]
>    io_req_complete fs/io_uring.c:1968 [inline]
>    io_cancel_defer_files fs/io_uring.c:8945 [inline]
>    io_uring_cancel_task_requests+0x67e/0xea0 fs/io_uring.c:9052
>    __io_uring_files_cancel+0x110/0x1b0 fs/io_uring.c:9140
>    io_uring_files_cancel include/linux/io_uring.h:65 [inline]
>    do_exit+0x2fe/0x2ae0 kernel/exit.c:780
>    do_group_exit+0x125/0x310 kernel/exit.c:922
>    get_signal+0x42c/0x2100 kernel/signal.c:2773
>    arch_do_signal_or_restart+0x2a8/0x1eb0 arch/x86/kernel/signal.c:811
>    handle_signal_work kernel/entry/common.c:147 [inline]
>    exit_to_user_mode_loop kernel/entry/common.c:171 [inline]
>    exit_to_user_mode_prepare+0x148/0x250 kernel/entry/common.c:208
>    __syscall_exit_to_user_mode_work kernel/entry/common.c:290 [inline]
>    syscall_exit_to_user_mode+0x19/0x50 kernel/entry/common.c:301
>    entry_SYSCALL_64_after_hwframe+0x44/0xae
> 
> 
> stack backtrace:
> CPU: 3 PID: 12185 Comm: syz-executor.0 Not tainted 5.11.0-syzkaller #0
> Hardware name: QEMU Standard PC (Q35 + ICH9, 2009), BIOS 1.14.0-2 04/01/2014
> Call Trace:
>  __dump_stack lib/dump_stack.c:79 [inline]
>  dump_stack+0xfa/0x151 lib/dump_stack.c:120
>  print_bad_irq_dependency kernel/locking/lockdep.c:2460 [inline]
>  check_irq_usage.cold+0x50d/0x744 kernel/locking/lockdep.c:2689
>  check_prev_add kernel/locking/lockdep.c:2940 [inline]
>  check_prevs_add kernel/locking/lockdep.c:3059 [inline]
>  validate_chain kernel/locking/lockdep.c:3674 [inline]
>  __lock_acquire+0x2b2c/0x54c0 kernel/locking/lockdep.c:4900
>  lock_acquire kernel/locking/lockdep.c:5510 [inline]
>  lock_acquire+0x1ab/0x730 kernel/locking/lockdep.c:5475
>  __raw_spin_lock include/linux/spinlock_api_smp.h:142 [inline]
>  _raw_spin_lock+0x2a/0x40 kernel/locking/spinlock.c:151
>  spin_lock include/linux/spinlock.h:354 [inline]
>  io_req_clean_work fs/io_uring.c:1405 [inline]
>  io_dismantle_req+0x90f/0xf90 fs/io_uring.c:2051
>  io_req_complete_post+0xf6/0x920 fs/io_uring.c:1933
>  __io_req_complete fs/io_uring.c:1963 [inline]
>  io_req_complete fs/io_uring.c:1968 [inline]
>  io_cancel_defer_files fs/io_uring.c:8945 [inline]
>  io_uring_cancel_task_requests+0x67e/0xea0 fs/io_uring.c:9052
>  __io_uring_files_cancel+0x110/0x1b0 fs/io_uring.c:9140
>  io_uring_files_cancel include/linux/io_uring.h:65 [inline]
>  do_exit+0x2fe/0x2ae0 kernel/exit.c:780
>  do_group_exit+0x125/0x310 kernel/exit.c:922
>  get_signal+0x42c/0x2100 kernel/signal.c:2773
>  arch_do_signal_or_restart+0x2a8/0x1eb0 arch/x86/kernel/signal.c:811
>  handle_signal_work kernel/entry/common.c:147 [inline]
>  exit_to_user_mode_loop kernel/entry/common.c:171 [inline]
>  exit_to_user_mode_prepare+0x148/0x250 kernel/entry/common.c:208
>  __syscall_exit_to_user_mode_work kernel/entry/common.c:290 [inline]
>  syscall_exit_to_user_mode+0x19/0x50 kernel/entry/common.c:301
>  entry_SYSCALL_64_after_hwframe+0x44/0xae
> RIP: 0033:0x465ef9
> Code: ff ff c3 66 2e 0f 1f 84 00 00 00 00 00 0f 1f 40 00 48 89 f8 48 89 f7 48 89 d6 48 89 ca 4d 89 c2 4d 89 c8 4c 8b 4c 24 08 0f 05 <48> 3d 01 f0 ff ff 73 01 c3 48 c7 c1 bc ff ff ff f7 d8 64 89 01 48
> RSP: 002b:00007ffb56aa0218 EFLAGS: 00000246 ORIG_RAX: 00000000000000ca
> RAX: 0000000000000000 RBX: 000000000056bf68 RCX: 0000000000465ef9
> RDX: 0000000000000000 RSI: 0000000000000080 RDI: 000000000056bf68
> RBP: 000000000056bf60 R08: 0000000000000000 R09: 0000000000000000
> R10: 0000000000000000 R11: 0000000000000246 R12: 000000000056bf6c
> R13: 00007fff198147ff R14: 00007ffb56aa0300 R15: 0000000000022000
> 
> 
> ---
> This report is generated by a bot. It may contain errors.
> See https://goo.gl/tpsmEJ for more information about syzbot.
> syzbot engineers can be reached at syzkaller@googlegroups.com.
> 
> syzbot will keep track of this issue. See:
> https://goo.gl/tpsmEJ#status for how to communicate with syzbot.
> 

-- 
Pavel Begunkov
