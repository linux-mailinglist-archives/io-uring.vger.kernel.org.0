Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id F377145F030
	for <lists+io-uring@lfdr.de>; Fri, 26 Nov 2021 15:52:35 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1353615AbhKZOzq (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Fri, 26 Nov 2021 09:55:46 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:40200 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1377875AbhKZOxp (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Fri, 26 Nov 2021 09:53:45 -0500
Received: from mail-wm1-x329.google.com (mail-wm1-x329.google.com [IPv6:2a00:1450:4864:20::329])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 65340C06173E;
        Fri, 26 Nov 2021 06:29:36 -0800 (PST)
Received: by mail-wm1-x329.google.com with SMTP id i12so8274093wmq.4;
        Fri, 26 Nov 2021 06:29:36 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=message-id:date:mime-version:user-agent:subject:content-language:to
         :references:from:in-reply-to:content-transfer-encoding;
        bh=6yZSUzHsHrZQqVc3BNhvg2qfEGhiI4az9dICi+ntNoc=;
        b=epmmcNP9K7UHlKMOzAuVxfP+VvN1r6zDoNMem9kuh/gXEOZVgKyDKHAx3VYGjE+Sz7
         GOBTKRbuSiyUXYkQNrsRRav3Le2mPgQLu2U7dN83i8YZqAZTztLEYQCVaJS1WkQAhghi
         K+9HF4UGm7Kf8y/uD+lwPwvKhWoX1d42Nt6eGv2ZxqmuQJrA2ejWxBMFCDHX5wDGnM1J
         oJJnHwP+6TwsM2f7SycO8WYaP09LR41eVGBih6gt6mwVci/fPp5XN0ToQjlDdLqQRIpT
         3krZy5QEGd3lTdFSR7ABrT/GHG7SrI0xpbomSlg0zZnEg48No3wLSP7a0WSSFcxiCFcy
         wZPg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:message-id:date:mime-version:user-agent:subject
         :content-language:to:references:from:in-reply-to
         :content-transfer-encoding;
        bh=6yZSUzHsHrZQqVc3BNhvg2qfEGhiI4az9dICi+ntNoc=;
        b=wKiYPwvHSFNs2D0CzWhrqX80V/Sf2GP/S6Nid43cCQ2L5cCLLSUog42D74HJrLMrrm
         dxoISqaxkK0ufedL/QREjndjJRSKMwDJYBntgEuJbxFAaslqvESfEDAL805iPCp4qimv
         88rHMm3XmFW5Mpfz4FRPP21wd+MHonjW6j2lipqGuEKGyt82eLZ/sCk6sWZmhibHs4tf
         j67rc0IWjDOq5+cFxf5MxBLHpOyC49n26w2j0vQ9OuD3lQthgSu8S6RqXzqN0VLVFbng
         LFwWl8/58//SRfLigBbfoCobq/BTwZFSjLB4ymm4WGScHYNMCt/KdBk0z8JiKT3Y07NR
         B7bg==
X-Gm-Message-State: AOAM533GutfaEDQR8e+W7AqVxGsN4ZgEzxMBjo2oUhWb8pgjavQ6QOFX
        X21/0CDJFQz4XWQ7ERS1bak=
X-Google-Smtp-Source: ABdhPJw/6JxmBPR5SzOhY12cOXXRbb051VVoQSWbHgmNaJXrSrlOIEmKXmNCzmCCLxqRBsmatqn16g==
X-Received: by 2002:a05:600c:6025:: with SMTP id az37mr16017023wmb.194.1637936975015;
        Fri, 26 Nov 2021 06:29:35 -0800 (PST)
Received: from [192.168.43.77] (82-132-231-175.dab.02.net. [82.132.231.175])
        by smtp.gmail.com with ESMTPSA id f18sm5645513wre.7.2021.11.26.06.29.33
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Fri, 26 Nov 2021 06:29:34 -0800 (PST)
Message-ID: <8ca96a69-cf86-8e2e-2c15-6d802d6a79d8@gmail.com>
Date:   Fri, 26 Nov 2021 14:29:35 +0000
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:91.0) Gecko/20100101
 Thunderbird/91.3.2
Subject: Re: [syzbot] inconsistent lock state in io_link_timeout_fn
Content-Language: en-US
To:     syzbot <syzbot+3368aadcd30425ceb53b@syzkaller.appspotmail.com>,
        axboe@kernel.dk, io-uring@vger.kernel.org,
        linux-kernel@vger.kernel.org, syzkaller-bugs@googlegroups.com
References: <000000000000e12a2605d1add69d@google.com>
From:   Pavel Begunkov <asml.silence@gmail.com>
In-Reply-To: <000000000000e12a2605d1add69d@google.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org

On 11/26/21 09:37, syzbot wrote:
> Hello,
> 
> syzbot found the following issue on:

#syz dup: inconsistent lock state in io_poll_remove_all

> 
> HEAD commit:    a4849f6000e2 Merge tag 'drm-fixes-2021-11-26' of git://ano..
> git tree:       upstream
> console output: https://syzkaller.appspot.com/x/log.txt?x=1542553eb00000
> kernel config:  https://syzkaller.appspot.com/x/.config?x=75f05fb8d1a152d3
> dashboard link: https://syzkaller.appspot.com/bug?extid=3368aadcd30425ceb53b
> compiler:       gcc (Debian 10.2.1-6) 10.2.1 20210110, GNU ld (GNU Binutils for Debian) 2.35.2
> 
> Unfortunately, I don't have any reproducer for this issue yet.
> 
> IMPORTANT: if you fix the issue, please add the following tag to the commit:
> Reported-by: syzbot+3368aadcd30425ceb53b@syzkaller.appspotmail.com
> 
> ================================
> WARNING: inconsistent lock state
> 5.16.0-rc2-syzkaller #0 Not tainted
> --------------------------------
> inconsistent {HARDIRQ-ON-W} -> {IN-HARDIRQ-W} usage.
> syz-executor.1/14925 [HC1[1]:SC0[0]:HE0:SE1] takes:
> ffff888028b7e418 (&ctx->timeout_lock){?.+.}-{2:2}, at: io_link_timeout_fn+0x6b/0x470 fs/io_uring.c:6904
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
>    tracehook_notify_resume include/linux/tracehook.h:189 [inline]
>    exit_to_user_mode_loop kernel/entry/common.c:175 [inline]
>    exit_to_user_mode_prepare+0x27e/0x290 kernel/entry/common.c:207
>    __syscall_exit_to_user_mode_work kernel/entry/common.c:289 [inline]
>    syscall_exit_to_user_mode+0x19/0x60 kernel/entry/common.c:300
>    do_syscall_64+0x42/0xb0 arch/x86/entry/common.c:86
>    entry_SYSCALL_64_after_hwframe+0x44/0xae
> irq event stamp: 1634
> hardirqs last  enabled at (1633): [<ffffffff8946bc7f>] __raw_spin_unlock_irq include/linux/spinlock_api_smp.h:159 [inline]
> hardirqs last  enabled at (1633): [<ffffffff8946bc7f>] _raw_spin_unlock_irq+0x1f/0x40 kernel/locking/spinlock.c:202
> hardirqs last disabled at (1634): [<ffffffff8943d3fb>] sysvec_apic_timer_interrupt+0xb/0xc0 arch/x86/kernel/apic/apic.c:1097
> softirqs last  enabled at (238): [<ffffffff8146a9b3>] invoke_softirq kernel/softirq.c:432 [inline]
> softirqs last  enabled at (238): [<ffffffff8146a9b3>] __irq_exit_rcu+0x123/0x180 kernel/softirq.c:636
> softirqs last disabled at (233): [<ffffffff8146a9b3>] invoke_softirq kernel/softirq.c:432 [inline]
> softirqs last disabled at (233): [<ffffffff8146a9b3>] __irq_exit_rcu+0x123/0x180 kernel/softirq.c:636
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
> 1 lock held by syz-executor.1/14925:
>   #0: ffff888028b7e0a8 (&ctx->uring_lock){+.+.}-{3:3}, at: __do_sys_io_uring_enter+0xf60/0x1f50 fs/io_uring.c:10042
> 
> stack backtrace:
> CPU: 0 PID: 14925 Comm: syz-executor.1 Not tainted 5.16.0-rc2-syzkaller #0
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
>   io_link_timeout_fn+0x6b/0x470 fs/io_uring.c:6904
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
> RSP: 0018:ffffc90004827ae8 EFLAGS: 00000202
> RAX: 0000000000000661 RBX: ffff888028b7e000 RCX: 1ffffffff1ffa99e
> RDX: 0000000000000000 RSI: 0000000000000001 RDI: 0000000000000001
> RBP: ffff888028b7e400 R08: 0000000000000001 R09: ffffffff8ff71b07
> R10: 0000000000000001 R11: 0000000000000000 R12: 0000000000000001
> R13: ffff888028b7e400 R14: ffff888028b7e188 R15: ffff88802650a290
>   spin_unlock_irq include/linux/spinlock.h:399 [inline]
>   io_queue_linked_timeout+0x292/0x430 fs/io_uring.c:6943
>   io_queue_sqe_arm_apoll+0x15d/0x1a0 fs/io_uring.c:6967
>   __io_queue_sqe fs/io_uring.c:6991 [inline]
>   io_queue_sqe fs/io_uring.c:7018 [inline]
>   io_submit_sqe fs/io_uring.c:7221 [inline]
>   io_submit_sqes+0x796a/0x8a20 fs/io_uring.c:7327
>   __do_sys_io_uring_enter+0xf6e/0x1f50 fs/io_uring.c:10043
>   do_syscall_x64 arch/x86/entry/common.c:50 [inline]
>   do_syscall_64+0x35/0xb0 arch/x86/entry/common.c:80
>   entry_SYSCALL_64_after_hwframe+0x44/0xae
> RIP: 0033:0x7ff8e9ef4ae9
> Code: ff ff c3 66 2e 0f 1f 84 00 00 00 00 00 0f 1f 40 00 48 89 f8 48 89 f7 48 89 d6 48 89 ca 4d 89 c2 4d 89 c8 4c 8b 4c 24 08 0f 05 <48> 3d 01 f0 ff ff 73 01 c3 48 c7 c1 bc ff ff ff f7 d8 64 89 01 48
> RSP: 002b:00007ff8e746a188 EFLAGS: 00000246 ORIG_RAX: 00000000000001aa
> RAX: ffffffffffffffda RBX: 00007ff8ea007f60 RCX: 00007ff8e9ef4ae9
> RDX: 0000000000000000 RSI: 0000000000006700 RDI: 0000000000000005
> RBP: 00007ff8e9f4ef6d R08: 0000000000000000 R09: 0000000000000000
> R10: 0000000000000000 R11: 0000000000000246 R12: 0000000000000000
> R13: 00007ff8ea53bb2f R14: 00007ff8e746a300 R15: 0000000000022000
>   </TASK>
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
