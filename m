Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 9BF6945F033
	for <lists+io-uring@lfdr.de>; Fri, 26 Nov 2021 15:52:37 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1377941AbhKZOzr (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Fri, 26 Nov 2021 09:55:47 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:40202 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1353619AbhKZOxp (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Fri, 26 Nov 2021 09:53:45 -0500
Received: from mail-wr1-x42b.google.com (mail-wr1-x42b.google.com [IPv6:2a00:1450:4864:20::42b])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 04182C0619E8;
        Fri, 26 Nov 2021 06:29:45 -0800 (PST)
Received: by mail-wr1-x42b.google.com with SMTP id i5so19084370wrb.2;
        Fri, 26 Nov 2021 06:29:44 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=message-id:date:mime-version:user-agent:subject:content-language:to
         :references:from:in-reply-to:content-transfer-encoding;
        bh=FrLySbjZ9E1F9zRrwmGwcOg25lzZF4XjLGaGVsdgmDA=;
        b=gNpt5KmepNoac+im9j4z6O+Qq9gstvxi+4UKNHxe4cwD3JJpAWBSL4wG4PhHZi16eB
         GKY9IxQJsljVP61aLXoXkm8nzIbIRHNKY/iBp+hjSpKru1ysWNZRubRnbloEIqjjY2Jy
         I8LgtWEtHKL6Q7rh6nsb/n5wG3Me3Hc/hHMsmZuP0ckz3QspnIknb4Gycty5baOFiRlG
         32KOhq4oYSJGwMs+z4Vzhx3q3/a7enhaAI0CMydBHXA7QLmLcLaiYY5x6/xY9pK0x4qy
         xQOqaRU9S91M0TqROwoIBcDHsA6ZUR9/wW7780uozGgO5NY+vREyToyM1Vr9exQlvrMt
         RIZg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:message-id:date:mime-version:user-agent:subject
         :content-language:to:references:from:in-reply-to
         :content-transfer-encoding;
        bh=FrLySbjZ9E1F9zRrwmGwcOg25lzZF4XjLGaGVsdgmDA=;
        b=DQ2owk3fWff4TFKLPX687E3Z10mrmu7FGtefmmvZ1CJzlqEtMvNeDU5GZDlkOHv3si
         1wDZvEeZWswM6iU88ePXzUox8gqeud39xZKCkw49pqThgYOAmnigA079ukcsjOT5pGh6
         3ubBhxwZaCM4T8sQ1XszuXyCygSYm+IA8Gvz3VVC1Cls3VmLa4i0zoRPaBEcrFWwpbiT
         FuEpObB9LMK3WYgxZdg5PChx6REHMxOticPXSEA8A1+TTJ62vWaioYwCjnhAzQnH+rk8
         2uSgXCTQFZ0ZrEanE3tG4wSen4oV4xphAEnrwGwFhaAUj4PCawacXTl0tXOYnOh14Xmv
         dzLQ==
X-Gm-Message-State: AOAM5332DqqakhfW7WcpHLXfNMNISsBiiM/2mFi4H0fwRizrw1cgQAMn
        r2QXOE+xwfcHnm61ZWNkF+I=
X-Google-Smtp-Source: ABdhPJz27gLBiTKfmnPixiy6RRnVVVZWTOBCQQ3UmQyQ+Cv/dLnQbvn3uD/SLr4/UGnu3gRg1aWAeA==
X-Received: by 2002:a05:6000:1788:: with SMTP id e8mr15222159wrg.45.1637936983578;
        Fri, 26 Nov 2021 06:29:43 -0800 (PST)
Received: from [192.168.43.77] (82-132-231-175.dab.02.net. [82.132.231.175])
        by smtp.gmail.com with ESMTPSA id bd18sm5982759wmb.43.2021.11.26.06.29.41
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Fri, 26 Nov 2021 06:29:43 -0800 (PST)
Message-ID: <125c6257-7156-9815-c6fd-f29a1ef4bdb7@gmail.com>
Date:   Fri, 26 Nov 2021 14:29:43 +0000
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:91.0) Gecko/20100101
 Thunderbird/91.3.2
Subject: Re: [syzbot] inconsistent lock state in io_timeout_fn
Content-Language: en-US
To:     syzbot <syzbot+3cb756a49d2f394a9ee3@syzkaller.appspotmail.com>,
        axboe@kernel.dk, io-uring@vger.kernel.org,
        linux-kernel@vger.kernel.org, syzkaller-bugs@googlegroups.com
References: <000000000000e3eee305d1ad47e7@google.com>
From:   Pavel Begunkov <asml.silence@gmail.com>
In-Reply-To: <000000000000e3eee305d1ad47e7@google.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org

On 11/26/21 08:57, syzbot wrote:
> Hello,
> 
> syzbot found the following issue on:

#syz dup: inconsistent lock state in io_poll_remove_all

> 
> HEAD commit:    a4849f6000e2 Merge tag 'drm-fixes-2021-11-26' of git://ano..
> git tree:       upstream
> console output: https://syzkaller.appspot.com/x/log.txt?x=14388465b00000
> kernel config:  https://syzkaller.appspot.com/x/.config?x=75f05fb8d1a152d3
> dashboard link: https://syzkaller.appspot.com/bug?extid=3cb756a49d2f394a9ee3
> compiler:       gcc (Debian 10.2.1-6) 10.2.1 20210110, GNU ld (GNU Binutils for Debian) 2.35.2
> 
> Unfortunately, I don't have any reproducer for this issue yet.
> 
> IMPORTANT: if you fix the issue, please add the following tag to the commit:
> Reported-by: syzbot+3cb756a49d2f394a9ee3@syzkaller.appspotmail.com
> 
> ================================
> WARNING: inconsistent lock state
> 5.16.0-rc2-syzkaller #0 Not tainted
> --------------------------------
> inconsistent {HARDIRQ-ON-W} -> {IN-HARDIRQ-W} usage.
> syz-executor.1/22058 [HC1[1]:SC0[0]:HE0:SE1] takes:
> ffff888078e11418 (&ctx->timeout_lock
> ){?.+.}-{2:2}
> , at: io_timeout_fn+0x6f/0x360 fs/io_uring.c:5943
> {HARDIRQ-ON-W} state was registered at:
>    __trace_hardirqs_on_caller kernel/locking/lockdep.c:4224 [inline]
>    lockdep_hardirqs_on_prepare kernel/locking/lockdep.c:4292 [inline]
>    lockdep_hardirqs_on_prepare+0x135/0x400 kernel/locking/lockdep.c:4244
>    trace_hardirqs_on+0x5b/0x1c0 kernel/trace/trace_preemptirq.c:49
>    __raw_spin_unlock_irq include/linux/spinlock_api_smp.h:159 [inline]
>    _raw_spin_unlock_irq+0x1f/0x40 kernel/locking/spinlock.c:202
>    spin_unlock_irq include/linux/spinlock.h:399 [inline]
>    __io_poll_remove_one fs/io_uring.c:5669 [inline]
>    __io_poll_remove_one fs/io_uring.c:5654 [inline]
>    io_poll_remove_one+0x236/0x870 fs/io_uring.c:5680
>    io_poll_remove_all+0x1af/0x235 fs/io_uring.c:5709
>    io_ring_ctx_wait_and_kill+0x1cc/0x322 fs/io_uring.c:9534
>    io_uring_release+0x42/0x46 fs/io_uring.c:9554
>    __fput+0x286/0x9f0 fs/file_table.c:280
>    task_work_run+0xdd/0x1a0 kernel/task_work.c:164
>    exit_task_work include/linux/task_work.h:32 [inline]
>    do_exit+0xc14/0x2b40 kernel/exit.c:832
>    do_group_exit+0x125/0x310 kernel/exit.c:929
>    get_signal+0x47d/0x2220 kernel/signal.c:2852
>    arch_do_signal_or_restart+0x2a9/0x1c40 arch/x86/kernel/signal.c:868
>    handle_signal_work kernel/entry/common.c:148 [inline]
>    exit_to_user_mode_loop kernel/entry/common.c:172 [inline]
>    exit_to_user_mode_prepare+0x17d/0x290 kernel/entry/common.c:207
>    __syscall_exit_to_user_mode_work kernel/entry/common.c:289 [inline]
>    syscall_exit_to_user_mode+0x19/0x60 kernel/entry/common.c:300
>    do_syscall_64+0x42/0xb0 arch/x86/entry/common.c:86
>    entry_SYSCALL_64_after_hwframe+0x44/0xae
> irq event stamp: 24938
> hardirqs last  enabled at (24937): [<ffffffff8946bc7f>] __raw_spin_unlock_irq include/linux/spinlock_api_smp.h:159 [inline]
> hardirqs last  enabled at (24937): [<ffffffff8946bc7f>] _raw_spin_unlock_irq+0x1f/0x40 kernel/locking/spinlock.c:202
> hardirqs last disabled at (24938): [<ffffffff8943d3fb>] sysvec_apic_timer_interrupt+0xb/0xc0 arch/x86/kernel/apic/apic.c:1097
> softirqs last  enabled at (24820): [<ffffffff8146a9b3>] invoke_softirq kernel/softirq.c:432 [inline]
> softirqs last  enabled at (24820): [<ffffffff8146a9b3>] __irq_exit_rcu+0x123/0x180 kernel/softirq.c:636
> softirqs last disabled at (24739): [<ffffffff8146a9b3>] invoke_softirq kernel/softirq.c:432 [inline]
> softirqs last disabled at (24739): [<ffffffff8146a9b3>] __irq_exit_rcu+0x123/0x180 kernel/softirq.c:636
> 
> other info that might help us debug this:
>   Possible unsafe locking scenario:
> 
>         CPU0
>         ----
>    lock(&ctx->timeout_lock);
>    <Interrupt>
>      lock(&ctx->timeout_lock);
> 
>   *** DEADLOCK ***
> 
> 1 lock held by syz-executor.1/22058:
>   #0: ffff888078e110a8 (&ctx->uring_lock){+.+.}-{3:3}, at: tctx_task_work+0x2b3/0x630 fs/io_uring.c:2203
> 
> stack backtrace:
> CPU: 1 PID: 22058 Comm: syz-executor.1 Not tainted 5.16.0-rc2-syzkaller #0
> Hardware name: Google Google Compute Engine/Google Compute Engine, BIOS Google 01/01/2011
> Call Trace:
>   <IRQ>
>   __dump_stack lib/dump_stack.c:88 [inline]
>   dump_stack_lvl+0xcd/0x134 lib/dump_stack.c:106
>   print_usage_bug kernel/locking/lockdep.c:203 [inline]
>   valid_state kernel/locking/lockdep.c:3945 [inline]
>   mark_lock_irq kernel/locking/lockdep.c:4148 [inline]
>   mark_lock.cold+0x61/0x8e kernel/locking/lockdep.c:4605
>   mark_usage kernel/locking/lockdep.c:4497 [inline]
>   __lock_acquire+0x149d/0x54a0 kernel/locking/lockdep.c:4981
>   lock_acquire kernel/locking/lockdep.c:5637 [inline]
>   lock_acquire+0x1ab/0x510 kernel/locking/lockdep.c:5602
>   __raw_spin_lock_irqsave include/linux/spinlock_api_smp.h:110 [inline]
>   _raw_spin_lock_irqsave+0x39/0x50 kernel/locking/spinlock.c:162
>   io_timeout_fn+0x6f/0x360 fs/io_uring.c:5943
>   __run_hrtimer kernel/time/hrtimer.c:1685 [inline]
>   __hrtimer_run_queues+0x609/0xe50 kernel/time/hrtimer.c:1749
>   hrtimer_interrupt+0x31c/0x790 kernel/time/hrtimer.c:1811
>   local_apic_timer_interrupt arch/x86/kernel/apic/apic.c:1086 [inline]
>   __sysvec_apic_timer_interrupt+0x146/0x530 arch/x86/kernel/apic/apic.c:1103
>   sysvec_apic_timer_interrupt+0x8e/0xc0 arch/x86/kernel/apic/apic.c:1097
>   </IRQ>
>   <TASK>
>   asm_sysvec_apic_timer_interrupt+0x12/0x20 arch/x86/include/asm/idtentry.h:638
> RIP: 0010:__raw_spin_unlock_irq include/linux/spinlock_api_smp.h:160 [inline]
> RIP: 0010:_raw_spin_unlock_irq+0x25/0x40 kernel/locking/spinlock.c:202
> Code: 0f 1f 44 00 00 55 48 8b 74 24 08 48 89 fd 48 83 c7 18 e8 6e f0 15 f8 48 89 ef e8 b6 66 16 f8 e8 81 20 37 f8 fb bf 01 00 00 00 <e8> 86 30 09 f8 65 8b 05 6f b3 bb 76 85 c0 74 02 5d c3 e8 8b 88 b9
> RSP: 0018:ffffc90017697c40 EFLAGS: 00000206
> RAX: 0000000000006169 RBX: 0000000000000000 RCX: 1ffffffff1ffcf06
> RDX: 0000000000000000 RSI: 0000000000000001 RDI: 0000000000000001
> RBP: ffff888078e11400 R08: 0000000000000001 R09: ffffffff8ff71b3f
> R10: 0000000000000001 R11: 0000000000000000 R12: 0000000000000000
> R13: ffff88806fb39c80 R14: 0000000003938700 R15: ffff888035613b40
>   spin_unlock_irq include/linux/spinlock.h:399 [inline]
>   io_timeout fs/io_uring.c:6223 [inline]
>   io_issue_sqe+0x3789/0x7010 fs/io_uring.c:6662
>   __io_queue_sqe fs/io_uring.c:6976 [inline]
>   io_req_task_submit+0xce/0x450 fs/io_uring.c:2282
>   tctx_task_work+0x1b3/0x630 fs/io_uring.c:2206
>   task_work_run+0xdd/0x1a0 kernel/task_work.c:164
>   tracehook_notify_signal include/linux/tracehook.h:214 [inline]
>   handle_signal_work kernel/entry/common.c:146 [inline]
>   exit_to_user_mode_loop kernel/entry/common.c:172 [inline]
>   exit_to_user_mode_prepare+0x256/0x290 kernel/entry/common.c:207
>   __syscall_exit_to_user_mode_work kernel/entry/common.c:289 [inline]
>   syscall_exit_to_user_mode+0x19/0x60 kernel/entry/common.c:300
>   do_syscall_64+0x42/0xb0 arch/x86/entry/common.c:86
>   entry_SYSCALL_64_after_hwframe+0x44/0xae
> RIP: 0033:0x7f4040412ae9
> Code: ff ff c3 66 2e 0f 1f 84 00 00 00 00 00 0f 1f 40 00 48 89 f8 48 89 f7 48 89 d6 48 89 ca 4d 89 c2 4d 89 c8 4c 8b 4c 24 08 0f 05 <48> 3d 01 f0 ff ff 73 01 c3 48 c7 c1 bc ff ff ff f7 d8 64 89 01 48
> RSP: 002b:00007f403d988188 EFLAGS: 00000246 ORIG_RAX: 00000000000001aa
> RAX: 0000000000000200 RBX: 00007f4040525f60 RCX: 00007f4040412ae9
> RDX: 0000000000000000 RSI: 00000000000045f5 RDI: 0000000000000004
> RBP: 00007f404046cf6d R08: 0000000000000000 R09: 0000000000000000
> R10: 0000000000000000 R11: 0000000000000246 R12: 0000000000000000
> R13: 00007fff712de00f R14: 00007f403d988300 R15: 0000000000022000
>   </TASK>
> I/O error, dev loop3, sector 0 op 0x0:(READ) flags 0x0 phys_seg 1 prio class 0
> Buffer I/O error on dev loop3, logical block 0, async page read
> I/O error, dev loop3, sector 0 op 0x0:(READ) flags 0x0 phys_seg 1 prio class 0
> Buffer I/O error on dev loop3, logical block 0, async page read
> I/O error, dev loop3, sector 0 op 0x0:(READ) flags 0x0 phys_seg 1 prio class 0
> Buffer I/O error on dev loop3, logical block 0, async page read
> ----------------
> Code disassembly (best guess):
>     0:	0f 1f 44 00 00       	nopl   0x0(%rax,%rax,1)
>     5:	55                   	push   %rbp
>     6:	48 8b 74 24 08       	mov    0x8(%rsp),%rsi
>     b:	48 89 fd             	mov    %rdi,%rbp
>     e:	48 83 c7 18          	add    $0x18,%rdi
>    12:	e8 6e f0 15 f8       	callq  0xf815f085
>    17:	48 89 ef             	mov    %rbp,%rdi
>    1a:	e8 b6 66 16 f8       	callq  0xf81666d5
>    1f:	e8 81 20 37 f8       	callq  0xf83720a5
>    24:	fb                   	sti
>    25:	bf 01 00 00 00       	mov    $0x1,%edi
> * 2a:	e8 86 30 09 f8       	callq  0xf80930b5 <-- trapping instruction
>    2f:	65 8b 05 6f b3 bb 76 	mov    %gs:0x76bbb36f(%rip),%eax        # 0x76bbb3a5
>    36:	85 c0                	test   %eax,%eax
>    38:	74 02                	je     0x3c
>    3a:	5d                   	pop    %rbp
>    3b:	c3                   	retq
>    3c:	e8                   	.byte 0xe8
>    3d:	8b                   	.byte 0x8b
>    3e:	88                   	.byte 0x88
>    3f:	b9                   	.byte 0xb9
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
