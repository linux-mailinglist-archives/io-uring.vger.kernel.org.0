Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 66A7632751E
	for <lists+io-uring@lfdr.de>; Mon,  1 Mar 2021 00:11:43 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231367AbhB1XJf (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Sun, 28 Feb 2021 18:09:35 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:40324 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231382AbhB1XJX (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Sun, 28 Feb 2021 18:09:23 -0500
Received: from mail-pg1-x52e.google.com (mail-pg1-x52e.google.com [IPv6:2607:f8b0:4864:20::52e])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 5D814C06178B
        for <io-uring@vger.kernel.org>; Sun, 28 Feb 2021 15:08:19 -0800 (PST)
Received: by mail-pg1-x52e.google.com with SMTP id t26so10360140pgv.3
        for <io-uring@vger.kernel.org>; Sun, 28 Feb 2021 15:08:19 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernel-dk.20150623.gappssmtp.com; s=20150623;
        h=subject:to:references:from:message-id:date:user-agent:mime-version
         :in-reply-to:content-language:content-transfer-encoding;
        bh=SmQMsrGoUKJ4zXu9YtAmV2nQB1dfM6MYK666mtQb/K8=;
        b=g31OoGZGFUnX4krXGaFWn4eV6UTBvSMWM0CrGCtI49f6Ex4gcUMZ8xq0CDBbHm1uFI
         AOkvFmL6mRZWcAkGsFqkkeH+aJUZiZE7zCcn1OW7C4KxqLd9PYFYKctKTJPFsZqLBV8z
         o6gtVbS4+ZKAegoYu1c5YP+NeAl8frowCxDCF8jPc8ZM2cR4OOizrVpqhZ6C5US4THVn
         nL4nNpu1Vo7F6glp1NrK1QzwX9r1fQ2ejROUwN60Hxf99iggFGQSGVPbx+3lW57tTNiC
         iKmUjgk1rkXR6sywWZNX2WZbgdP2JfwXOx/O5W6hPe/SXdbQS1IlhUS5dZNdFg5xZzO7
         YQfQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=SmQMsrGoUKJ4zXu9YtAmV2nQB1dfM6MYK666mtQb/K8=;
        b=BT21WGcW4IblHajBsaoZSchfKb0eURpzeSaOlr/oWpiLUBZUBc8l0yfuzFepaWofGG
         Y1o400HKPlOV9miwGizoSONKGaKdGaMPuAcAjXqEc5qStLQPw8XdsVfHsiMdWXQszJWH
         rBhoLpioCAij4+721RPAgkjbN4hMYQwauR9FkGZBesI6u6Hvod2yyF7zyZplvTnvtB9w
         YXlpSo6ywzsSAbtlRk1CKRZp42zRytwU00vH4VBscHbZga/CSmetaXMSywsr4MH1FxXf
         PURohmExcHsW3GC5SES7TSP39kpA/xqbRyxrXqBjoi8OkxYv+2xEgk/Y8Q085QF+1wyc
         kNSw==
X-Gm-Message-State: AOAM533BHUSBbO5x5blcigvJkzfQj0YuA+IF37YSZ5/aWHgn9xAbYPll
        /URkGKiWws56oH3AsRoPs/1Ogw==
X-Google-Smtp-Source: ABdhPJxJtumVB71k4TqXBUAdw3zeznGsRyBEmpMItWv0L4FRLCHdd9/yi9a0nPVuJVUBmbgyz4PwXw==
X-Received: by 2002:aa7:90c5:0:b029:1e3:5e84:4a7c with SMTP id k5-20020aa790c50000b02901e35e844a7cmr12133417pfk.71.1614553698815;
        Sun, 28 Feb 2021 15:08:18 -0800 (PST)
Received: from [192.168.1.134] ([66.219.217.173])
        by smtp.gmail.com with ESMTPSA id t2sm14656086pfg.152.2021.02.28.15.08.17
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Sun, 28 Feb 2021 15:08:18 -0800 (PST)
Subject: Re: possible deadlock in io_poll_double_wake (2)
To:     syzbot <syzbot+28abd693db9e92c160d8@syzkaller.appspotmail.com>,
        asml.silence@gmail.com, io-uring@vger.kernel.org,
        linux-fsdevel@vger.kernel.org, linux-kernel@vger.kernel.org,
        syzkaller-bugs@googlegroups.com, viro@zeniv.linux.org.uk
References: <000000000000e61a7605bc5ac540@google.com>
From:   Jens Axboe <axboe@kernel.dk>
Message-ID: <900e27f3-6503-ed03-4c58-ccc946df7a6a@kernel.dk>
Date:   Sun, 28 Feb 2021 16:08:17 -0700
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.10.0
MIME-Version: 1.0
In-Reply-To: <000000000000e61a7605bc5ac540@google.com>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org

On 2/27/21 5:42 PM, syzbot wrote:
> syzbot has found a reproducer for the following issue on:
> 
> HEAD commit:    5695e516 Merge tag 'io_uring-worker.v3-2021-02-25' of git:..
> git tree:       upstream
> console output: https://syzkaller.appspot.com/x/log.txt?x=114e3866d00000
> kernel config:  https://syzkaller.appspot.com/x/.config?x=8c76dad0946df1f3
> dashboard link: https://syzkaller.appspot.com/bug?extid=28abd693db9e92c160d8
> syz repro:      https://syzkaller.appspot.com/x/repro.syz?x=122ed9b6d00000
> C reproducer:   https://syzkaller.appspot.com/x/repro.c?x=14d5a292d00000
> 
> IMPORTANT: if you fix the issue, please add the following tag to the commit:
> Reported-by: syzbot+28abd693db9e92c160d8@syzkaller.appspotmail.com
> 
> ============================================
> WARNING: possible recursive locking detected
> 5.11.0-syzkaller #0 Not tainted
> --------------------------------------------
> swapper/1/0 is trying to acquire lock:
> ffff88801b2b1130 (&runtime->sleep){..-.}-{2:2}, at: spin_lock include/linux/spinlock.h:354 [inline]
> ffff88801b2b1130 (&runtime->sleep){..-.}-{2:2}, at: io_poll_double_wake+0x25f/0x6a0 fs/io_uring.c:4960
> 
> but task is already holding lock:
> ffff88801b2b3130 (&runtime->sleep){..-.}-{2:2}, at: __wake_up_common_lock+0xb4/0x130 kernel/sched/wait.c:137
> 
> other info that might help us debug this:
>  Possible unsafe locking scenario:
> 
>        CPU0
>        ----
>   lock(&runtime->sleep);
>   lock(&runtime->sleep);
> 
>  *** DEADLOCK ***
> 
>  May be due to missing lock nesting notation
> 
> 2 locks held by swapper/1/0:
>  #0: ffff888147474908 (&group->lock){..-.}-{2:2}, at: _snd_pcm_stream_lock_irqsave+0x9f/0xd0 sound/core/pcm_native.c:170
>  #1: ffff88801b2b3130 (&runtime->sleep){..-.}-{2:2}, at: __wake_up_common_lock+0xb4/0x130 kernel/sched/wait.c:137
> 
> stack backtrace:
> CPU: 1 PID: 0 Comm: swapper/1 Not tainted 5.11.0-syzkaller #0
> Hardware name: Google Google Compute Engine/Google Compute Engine, BIOS Google 01/01/2011
> Call Trace:
>  <IRQ>
>  __dump_stack lib/dump_stack.c:79 [inline]
>  dump_stack+0xfa/0x151 lib/dump_stack.c:120
>  print_deadlock_bug kernel/locking/lockdep.c:2829 [inline]
>  check_deadlock kernel/locking/lockdep.c:2872 [inline]
>  validate_chain kernel/locking/lockdep.c:3661 [inline]
>  __lock_acquire.cold+0x14c/0x3b4 kernel/locking/lockdep.c:4900
>  lock_acquire kernel/locking/lockdep.c:5510 [inline]
>  lock_acquire+0x1ab/0x730 kernel/locking/lockdep.c:5475
>  __raw_spin_lock include/linux/spinlock_api_smp.h:142 [inline]
>  _raw_spin_lock+0x2a/0x40 kernel/locking/spinlock.c:151
>  spin_lock include/linux/spinlock.h:354 [inline]
>  io_poll_double_wake+0x25f/0x6a0 fs/io_uring.c:4960
>  __wake_up_common+0x147/0x650 kernel/sched/wait.c:108
>  __wake_up_common_lock+0xd0/0x130 kernel/sched/wait.c:138
>  snd_pcm_update_state+0x46a/0x540 sound/core/pcm_lib.c:203
>  snd_pcm_update_hw_ptr0+0xa75/0x1a50 sound/core/pcm_lib.c:464
>  snd_pcm_period_elapsed+0x160/0x250 sound/core/pcm_lib.c:1805
>  dummy_hrtimer_callback+0x94/0x1b0 sound/drivers/dummy.c:378
>  __run_hrtimer kernel/time/hrtimer.c:1519 [inline]
>  __hrtimer_run_queues+0x609/0xe40 kernel/time/hrtimer.c:1583
>  hrtimer_run_softirq+0x17b/0x360 kernel/time/hrtimer.c:1600
>  __do_softirq+0x29b/0x9f6 kernel/softirq.c:345
>  invoke_softirq kernel/softirq.c:221 [inline]
>  __irq_exit_rcu kernel/softirq.c:422 [inline]
>  irq_exit_rcu+0x134/0x200 kernel/softirq.c:434
>  sysvec_apic_timer_interrupt+0x93/0xc0 arch/x86/kernel/apic/apic.c:1100
>  </IRQ>
>  asm_sysvec_apic_timer_interrupt+0x12/0x20 arch/x86/include/asm/idtentry.h:632
> RIP: 0010:native_save_fl arch/x86/include/asm/irqflags.h:29 [inline]
> RIP: 0010:arch_local_save_flags arch/x86/include/asm/irqflags.h:70 [inline]
> RIP: 0010:arch_irqs_disabled arch/x86/include/asm/irqflags.h:137 [inline]
> RIP: 0010:acpi_safe_halt drivers/acpi/processor_idle.c:111 [inline]
> RIP: 0010:acpi_idle_do_entry+0x1c9/0x250 drivers/acpi/processor_idle.c:516
> Code: dd 38 6e f8 84 db 75 ac e8 54 32 6e f8 e8 0f 1c 74 f8 e9 0c 00 00 00 e8 45 32 6e f8 0f 00 2d 4e 4a c5 00 e8 39 32 6e f8 fb f4 <9c> 5b 81 e3 00 02 00 00 fa 31 ff 48 89 de e8 14 3a 6e f8 48 85 db
> RSP: 0018:ffffc90000d47d18 EFLAGS: 00000293
> RAX: 0000000000000000 RBX: 0000000000000000 RCX: 0000000000000000
> RDX: ffff8880115c3780 RSI: ffffffff89052537 RDI: 0000000000000000
> RBP: ffff888141127064 R08: 0000000000000001 R09: 0000000000000001
> R10: ffffffff81794168 R11: 0000000000000000 R12: 0000000000000001
> R13: ffff888141127000 R14: ffff888141127064 R15: ffff888143331804
>  acpi_idle_enter+0x361/0x500 drivers/acpi/processor_idle.c:647
>  cpuidle_enter_state+0x1b1/0xc80 drivers/cpuidle/cpuidle.c:237
>  cpuidle_enter+0x4a/0xa0 drivers/cpuidle/cpuidle.c:351
>  call_cpuidle kernel/sched/idle.c:158 [inline]
>  cpuidle_idle_call kernel/sched/idle.c:239 [inline]
>  do_idle+0x3e1/0x590 kernel/sched/idle.c:300
>  cpu_startup_entry+0x14/0x20 kernel/sched/idle.c:397
>  start_secondary+0x274/0x350 arch/x86/kernel/smpboot.c:272
>  secondary_startup_64_no_verify+0xb0/0xbb

This looks very odd, only thing I can think of is someone doing
poll_wait() twice with different entries but for the same
waitqueue head.

#syz test: git://git.kernel.dk/linux-block syzbot-test

-- 
Jens Axboe

