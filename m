Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 925BD404020
	for <lists+io-uring@lfdr.de>; Wed,  8 Sep 2021 22:16:49 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1345241AbhIHUR4 (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Wed, 8 Sep 2021 16:17:56 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:54682 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233179AbhIHUR4 (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Wed, 8 Sep 2021 16:17:56 -0400
Received: from mail-wm1-x329.google.com (mail-wm1-x329.google.com [IPv6:2a00:1450:4864:20::329])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 909D2C061575;
        Wed,  8 Sep 2021 13:16:47 -0700 (PDT)
Received: by mail-wm1-x329.google.com with SMTP id y132so2672696wmc.1;
        Wed, 08 Sep 2021 13:16:47 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=subject:to:cc:references:from:message-id:date:user-agent
         :mime-version:in-reply-to:content-language:content-transfer-encoding;
        bh=CsCxlyyBkM+9pVONuUKttThrrFrN/a6bSIPojN51siw=;
        b=OTO0lT6m8/JbKRKOStnBt8XJN+Ox4swhLkK58fvACLhdYXLKpBdgnS+xVJR9f9LgGN
         PUgKkT75Eb+9WXjAB4YW23fGWwYRjBrJl/4wrJBR3ZOUhbAkjKzFnXw3EZ5TuFOGbv8H
         R6Y5tJNJqNIjcvZ5BjJ1e2oK04qHcWHb+04YOGugcbVNg6XJAjDpSeh4j2obUhnN2LTy
         6aZ1VjzH9XFzrIQUwqNxM0tALcXaWeHv+7Sg1IO7jEmdfxZPLeSQQsdAMAa939nTaOLF
         smYx41ffAE1DEnHBbeyg1zSz7xx7ofNrqvDK4s0WCtpflSKqAgWluJ0RNft559QXuCIA
         QphQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=CsCxlyyBkM+9pVONuUKttThrrFrN/a6bSIPojN51siw=;
        b=AMho7mOTsZ71OGKSuA5roBetlverJrBu4eReMTYk4EuzOzaANmjLtYwAIJstymrTk5
         AeaByhgwhxThcVD3rE+C9aIIIzjc8OKX40xr+HCyhZK6FqGKrAo75Wcl45/agzxU6LQG
         NztTWbsmr7faXYhj2X74j+uT79AUoin2OyvrxJ5FX7hMYNRHYy9UnFQFzqLVs4H8YjRJ
         vaUBbEERbpkv6Yot14fXHwBsYeRJMstwU+DyLUUhlFgN6gKFN3+eZxIJsCe0WGS8y8JP
         9JtyAYKdKrR/IWp3AoaM215lPZCpYLvDL0b8CHPfBDXC1kuhIQauIHP4QYF6io51K4ts
         +3mw==
X-Gm-Message-State: AOAM5326hPX808LuSTEEUerM51XNSarBGLr+ah3HiQEl5DHWLDaWQTA3
        df6aEEIKKbHdsUKB/JfAg9vCUSRZhyQ=
X-Google-Smtp-Source: ABdhPJw1xq4JqF7AWky052AUlwTzHKDWLX5kmfQoJ6eapKcQfcRmhYy8dwdbEyxVitGaAGw8Cx8iOw==
X-Received: by 2002:a05:600c:2245:: with SMTP id a5mr5384701wmm.19.1631132205680;
        Wed, 08 Sep 2021 13:16:45 -0700 (PDT)
Received: from [192.168.8.197] ([185.69.144.232])
        by smtp.gmail.com with ESMTPSA id l10sm151117wrg.50.2021.09.08.13.16.44
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Wed, 08 Sep 2021 13:16:45 -0700 (PDT)
Subject: Re: INFO: task hung in io_uring_cancel_generic
To:     Hao Sun <sunhao.th@gmail.com>
Cc:     Jens Axboe <axboe@kernel.dk>, io-uring@vger.kernel.org,
        linux-kernel@vger.kernel.org
References: <CACkBjsbs2tahJMC_TBZhQUBQiFYhLo-CW+kyzNxyUqgs5NCaXA@mail.gmail.com>
 <df072429-3f45-4d9d-c81d-73174aaf2e7d@kernel.dk>
 <e5ac817b-bc96-bea6-aadb-89d3c201446d@gmail.com>
 <CACkBjsZLyNbMwyoZc8T9ggq+R6-0aBFPCRB54jzAOF8f2QCH0Q@mail.gmail.com>
 <CACkBjsaGTkxsrBW+HNsgR0Pj7kbbrK-F5E4hp3CJJjYf3ASimQ@mail.gmail.com>
From:   Pavel Begunkov <asml.silence@gmail.com>
Message-ID: <ce4db530-3e7c-1a90-f271-42d471b098ed@gmail.com>
Date:   Wed, 8 Sep 2021 21:16:12 +0100
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:78.0) Gecko/20100101
 Thunderbird/78.13.0
MIME-Version: 1.0
In-Reply-To: <CACkBjsaGTkxsrBW+HNsgR0Pj7kbbrK-F5E4hp3CJJjYf3ASimQ@mail.gmail.com>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org

On 9/8/21 7:57 AM, Hao Sun wrote:
> Another similar report: INFO: task hung in io_ring_exit_work
> 
> INFO: task kworker/u9:3:1867 blocked for more than 143 seconds.
>       Not tainted 5.14.0+ #13
> "echo 0 > /proc/sys/kernel/hung_task_timeout_secs" disables this message.
> task:kworker/u9:3    state:D stack:12344 pid: 1867 ppid:     2 flags:0x00004000
> Workqueue: events_unbound io_ring_exit_work

This one is different. I guess it may be difficult for syz to
find a repro because of the delay before the warning appears.
How about to reduce it to a lower value? like 2-5 seconds

echo 5 > /proc/sys/kernel/hung_task_timeout_secs

> Call Trace:
>  context_switch kernel/sched/core.c:4940 [inline]
>  __schedule+0x323/0xae0 kernel/sched/core.c:6287
>  schedule+0x36/0xe0 kernel/sched/core.c:6366
>  schedule_timeout+0x189/0x430 kernel/time/timer.c:1857
>  do_wait_for_common kernel/sched/completion.c:85 [inline]
>  __wait_for_common kernel/sched/completion.c:106 [inline]
>  wait_for_common kernel/sched/completion.c:117 [inline]
>  wait_for_completion+0xb4/0x110 kernel/sched/completion.c:138
>  io_ring_exit_work+0x287/0x850 fs/io_uring.c:9297
>  process_one_work+0x359/0x850 kernel/workqueue.c:2297
>  worker_thread+0x41/0x4d0 kernel/workqueue.c:2444
>  kthread+0x178/0x1b0 kernel/kthread.c:319
>  ret_from_fork+0x1f/0x30 arch/x86/entry/entry_64.S:295
> INFO: task kworker/u9:4:2050 blocked for more than 143 seconds.
>       Not tainted 5.14.0+ #13
> "echo 0 > /proc/sys/kernel/hung_task_timeout_secs" disables this message.
> task:kworker/u9:4    state:D stack:12232 pid: 2050 ppid:     2 flags:0x00004000
> Workqueue: events_unbound io_ring_exit_work
> Call Trace:
>  context_switch kernel/sched/core.c:4940 [inline]
>  __schedule+0x323/0xae0 kernel/sched/core.c:6287
>  schedule+0x36/0xe0 kernel/sched/core.c:6366
>  schedule_timeout+0x189/0x430 kernel/time/timer.c:1857
>  do_wait_for_common kernel/sched/completion.c:85 [inline]
>  __wait_for_common kernel/sched/completion.c:106 [inline]
>  wait_for_common kernel/sched/completion.c:117 [inline]
>  wait_for_completion+0xb4/0x110 kernel/sched/completion.c:138
>  io_ring_exit_work+0x287/0x850 fs/io_uring.c:9297
>  process_one_work+0x359/0x850 kernel/workqueue.c:2297
>  worker_thread+0x41/0x4d0 kernel/workqueue.c:2444
>  kthread+0x178/0x1b0 kernel/kthread.c:319
>  ret_from_fork+0x1f/0x30 arch/x86/entry/entry_64.S:295
> 
> Showing all locks held in the system:
> 1 lock held by khungtaskd/1340:
>  #0: ffffffff85a1d3a0 (rcu_read_lock){....}-{1:2}, at:
> debug_show_all_locks+0xe/0x1a0 kernel/locking/lockdep.c:6446
> 2 locks held by kworker/u9:3/1867:
>  #0: ffff888008c5c938 ((wq_completion)events_unbound){+.+.}-{0:0}, at:
> set_work_data kernel/workqueue.c:633 [inline]
>  #0: ffff888008c5c938 ((wq_completion)events_unbound){+.+.}-{0:0}, at:
> set_work_pool_and_clear_pending kernel/workqueue.c:661 [inline]
>  #0: ffff888008c5c938 ((wq_completion)events_unbound){+.+.}-{0:0}, at:
> process_one_work+0x2a0/0x850 kernel/workqueue.c:2268
>  #1: ffffc90003e67e70
> ((work_completion)(&ctx->exit_work)){+.+.}-{0:0}, at: set_work_data
> kernel/workqueue.c:633 [inline]
>  #1: ffffc90003e67e70
> ((work_completion)(&ctx->exit_work)){+.+.}-{0:0}, at:
> set_work_pool_and_clear_pending kernel/workqueue.c:661 [inline]
>  #1: ffffc90003e67e70
> ((work_completion)(&ctx->exit_work)){+.+.}-{0:0}, at:
> process_one_work+0x2a0/0x850 kernel/workqueue.c:2268
> 2 locks held by kworker/u9:4/2050:
>  #0: ffff888008c5c938 ((wq_completion)events_unbound){+.+.}-{0:0}, at:
> set_work_data kernel/workqueue.c:633 [inline]
>  #0: ffff888008c5c938 ((wq_completion)events_unbound){+.+.}-{0:0}, at:
> set_work_pool_and_clear_pending kernel/workqueue.c:661 [inline]
>  #0: ffff888008c5c938 ((wq_completion)events_unbound){+.+.}-{0:0}, at:
> process_one_work+0x2a0/0x850 kernel/workqueue.c:2268
>  #1: ffffc90004327e70
> ((work_completion)(&ctx->exit_work)){+.+.}-{0:0}, at: set_work_data
> kernel/workqueue.c:633 [inline]
>  #1: ffffc90004327e70
> ((work_completion)(&ctx->exit_work)){+.+.}-{0:0}, at:
> set_work_pool_and_clear_pending kernel/workqueue.c:661 [inline]
>  #1: ffffc90004327e70
> ((work_completion)(&ctx->exit_work)){+.+.}-{0:0}, at:
> process_one_work+0x2a0/0x850 kernel/workqueue.c:2268
> 1 lock held by in:imklog/8089:
>  #0: ffff88800ece7ef0 (&f->f_pos_lock){+.+.}-{3:3}, at:
> __fdget_pos+0x55/0x60 fs/file.c:990
> 
> =============================================
> 
> NMI backtrace for cpu 0
> CPU: 0 PID: 1340 Comm: khungtaskd Not tainted 5.14.0+ #13
> Hardware name: QEMU Standard PC (i440FX + PIIX, 1996), BIOS
> rel-1.12.0-59-gc9ba5276e321-prebuilt.qemu.org 04/01/2014
> Call Trace:
>  __dump_stack lib/dump_stack.c:88 [inline]
>  dump_stack_lvl+0x8d/0xcf lib/dump_stack.c:105
>  nmi_cpu_backtrace+0x1e9/0x210 lib/nmi_backtrace.c:105
>  nmi_trigger_cpumask_backtrace+0x120/0x180 lib/nmi_backtrace.c:62
>  trigger_all_cpu_backtrace include/linux/nmi.h:146 [inline]
>  check_hung_uninterruptible_tasks kernel/hung_task.c:210 [inline]
>  watchdog+0x4e1/0x980 kernel/hung_task.c:295
>  kthread+0x178/0x1b0 kernel/kthread.c:319
>  ret_from_fork+0x1f/0x30 arch/x86/entry/entry_64.S:295
> Sending NMI from CPU 0 to CPUs 1-3:
> NMI backtrace for cpu 1
> CPU: 1 PID: 4934 Comm: systemd-journal Not tainted 5.14.0+ #13
> Hardware name: QEMU Standard PC (i440FX + PIIX, 1996), BIOS
> rel-1.12.0-59-gc9ba5276e321-prebuilt.qemu.org 04/01/2014
> RIP: 0010:lockdep_enabled kernel/locking/lockdep.c:91 [inline]
> RIP: 0010:lock_acquire+0x1a4/0x340 kernel/locking/lockdep.c:5601
> Code: 04 25 28 00 00 00 0f 85 b5 01 00 00 48 83 c4 38 5b 5d 41 5c 41
> 5d 41 5e 41 5f c3 65 48 8b 04 25 40 70 01 00 8b 80 f4 09 00 00 <85> c0
> 0f 85 c5 fe ff ff 9c 8f 04 24 fa 48 c7 c7 a0 36 5d 85 e8 e3
> RSP: 0018:ffffc9000086fe18 EFLAGS: 00000246
> RAX: 0000000000000000 RBX: 0000000000000000 RCX: 0000000000000000
> RDX: 0000000000000001 RSI: ffffffff852a8b94 RDI: ffffffff853cae8e
> RBP: 0000000000000000 R08: 0000000000000000 R09: 0000000000000000
> R10: 0000000000000000 R11: 0000000000000000 R12: ffffffff85a1d3a0
> R13: 0000000000000002 R14: 0000000000000000 R15: 0000000000000000
> FS:  00007f940a97b8c0(0000) GS:ffff88813dc00000(0000) knlGS:0000000000000000
> CS:  0010 DS: 0000 ES: 0000 CR0: 0000000080050033
> CR2: 00007f9407aa3000 CR3: 000000000f49a000 CR4: 0000000000750ee0
> DR0: 0000000000000000 DR1: 0000000000000000 DR2: 0000000000000000
> DR3: 0000000000000000 DR6: 00000000fffe0ff0 DR7: 0000000000000400
> PKRU: 55555554
> Call Trace:
>  rcu_lock_acquire include/linux/rcupdate.h:267 [inline]
>  rcu_read_lock include/linux/rcupdate.h:687 [inline]
>  dput+0x72/0x650 fs/dcache.c:874
>  path_put+0x12/0x20 fs/namei.c:557
>  do_faccessat+0x1fa/0x370 fs/open.c:455
>  do_syscall_x64 arch/x86/entry/common.c:50 [inline]
>  do_syscall_64+0x34/0xb0 arch/x86/entry/common.c:80
>  entry_SYSCALL_64_after_hwframe+0x44/0xae
> RIP: 0033:0x7f9409c379c7
> Code: 83 c4 08 48 3d 01 f0 ff ff 73 01 c3 48 8b 0d c8 d4 2b 00 f7 d8
> 64 89 01 48 83 c8 ff c3 66 0f 1f 44 00 00 b8 15 00 00 00 0f 05 <48> 3d
> 01 f0 ff ff 73 01 c3 48 8b 0d a1 d4 2b 00 f7 d8 64 89 01 48
> RSP: 002b:00007ffeead2d338 EFLAGS: 00000246 ORIG_RAX: 0000000000000015
> RAX: ffffffffffffffda RBX: 00007ffeead30250 RCX: 00007f9409c379c7
> RDX: 00007f940a6a8a00 RSI: 0000000000000000 RDI: 000055d9e89aa9a3
> RBP: 00007ffeead2d370 R08: 0000000000000000 R09: 0000000000000000
> R10: 0000000000000069 R11: 0000000000000246 R12: 0000000000000000
> R13: 0000000000000000 R14: 00007ffeead30250 R15: 00007ffeead2d860
> NMI backtrace for cpu 2 skipped: idling at native_safe_halt
> arch/x86/include/asm/irqflags.h:51 [inline]
> NMI backtrace for cpu 2 skipped: idling at arch_safe_halt
> arch/x86/include/asm/irqflags.h:89 [inline]
> NMI backtrace for cpu 2 skipped: idling at default_idle+0xb/0x10
> arch/x86/kernel/process.c:716
> NMI backtrace for cpu 3
> CPU: 3 PID: 8091 Comm: rs:main Q:Reg Not tainted 5.14.0+ #13
> Hardware name: QEMU Standard PC (i440FX + PIIX, 1996), BIOS
> rel-1.12.0-59-gc9ba5276e321-prebuilt.qemu.org 04/01/2014
> RIP: 0010:memset_erms+0x9/0x10 arch/x86/lib/memset_64.S:64
> Code: c1 e9 03 40 0f b6 f6 48 b8 01 01 01 01 01 01 01 01 48 0f af c6
> f3 48 ab 89 d1 f3 aa 4c 89 c8 c3 90 49 89 f9 40 88 f0 48 89 d1 <f3> aa
> 4c 89 c8 c3 90 49 89 fa 40 0f b6 ce 48 b8 01 01 01 01 01 01
> RSP: 0018:ffffc90007a23ba8 EFLAGS: 00010216
> RAX: 0000000000000000 RBX: ffff88810cd3ec78 RCX: 0000000000000c85
> RDX: 0000000000000d05 RSI: 0000000000000000 RDI: ffff888107f7b37b
> RBP: 0000000000001000 R08: 0000000000000000 R09: ffff888107f7b2fb
> R10: ffffc90007a23978 R11: 0000000000000005 R12: 0000000000000000
> R13: 0000000000000000 R14: 0000000000001000 R15: ffffea00041fdec0
> FS:  00007fd86dba4700(0000) GS:ffff88813dd00000(0000) knlGS:0000000000000000
> CS:  0010 DS: 0000 ES: 0000 CR0: 0000000080050033
> CR2: 000055d6e0599858 CR3: 0000000012b38000 CR4: 0000000000750ee0
> DR0: 0000000000000000 DR1: 0000000000000000 DR2: 0000000000000000
> DR3: 0000000000000000 DR6: 00000000fffe0ff0 DR7: 0000000000000400
> PKRU: 55555554
> Call Trace:
>  memset include/linux/fortify-string.h:175 [inline]
>  zero_user_segments include/linux/highmem.h:211 [inline]
>  ext4_block_write_begin+0x63e/0x980 fs/ext4/inode.c:1089
>  ext4_da_write_begin+0x275/0x610 fs/ext4/inode.c:3021
>  generic_perform_write+0xce/0x220 mm/filemap.c:3770
>  ext4_buffered_write_iter+0xd6/0x190 fs/ext4/file.c:269
>  ext4_file_write_iter+0x80/0x940 fs/ext4/file.c:680
>  call_write_iter include/linux/fs.h:2163 [inline]
>  new_sync_write+0x18d/0x260 fs/read_write.c:507
>  vfs_write+0x43b/0x4a0 fs/read_write.c:594
>  ksys_write+0xd2/0x120 fs/read_write.c:647
>  do_syscall_x64 arch/x86/entry/common.c:50 [inline]
>  do_syscall_64+0x34/0xb0 arch/x86/entry/common.c:80
>  entry_SYSCALL_64_after_hwframe+0x44/0xae
> RIP: 0033:0x7fd8705e81cd
> Code: c2 20 00 00 75 10 b8 01 00 00 00 0f 05 48 3d 01 f0 ff ff 73 31
> c3 48 83 ec 08 e8 ae fc ff ff 48 89 04 24 b8 01 00 00 00 0f 05 <48> 8b
> 3c 24 48 89 c2 e8 f7 fc ff ff 48 89 d0 48 83 c4 08 48 3d 01
> RSP: 002b:00007fd86dba3590 EFLAGS: 00000293 ORIG_RAX: 0000000000000001
> RAX: ffffffffffffffda RBX: 00007fd8640268f0 RCX: 00007fd8705e81cd
> RDX: 00000000000004ce RSI: 00007fd8640268f0 RDI: 0000000000000008
> RBP: 0000000000000000 R08: 0000000000000000 R09: 0000000000000000
> R10: 0000000000000000 R11: 0000000000000293 R12: 00007fd864026670
> R13: 00007fd86dba35b0 R14: 00005563e5cf4440 R15: 00000000000004ce
> ----------------
> Code disassembly (best guess):
>    0: 04 25                add    $0x25,%al
>    2: 28 00                sub    %al,(%rax)
>    4: 00 00                add    %al,(%rax)
>    6: 0f 85 b5 01 00 00    jne    0x1c1
>    c: 48 83 c4 38          add    $0x38,%rsp
>   10: 5b                    pop    %rbx
>   11: 5d                    pop    %rbp
>   12: 41 5c                pop    %r12
>   14: 41 5d                pop    %r13
>   16: 41 5e                pop    %r14
>   18: 41 5f                pop    %r15
>   1a: c3                    retq
>   1b: 65 48 8b 04 25 40 70 mov    %gs:0x17040,%rax
>   22: 01 00
>   24: 8b 80 f4 09 00 00    mov    0x9f4(%rax),%eax
> * 2a: 85 c0                test   %eax,%eax <-- trapping instruction
>   2c: 0f 85 c5 fe ff ff    jne    0xfffffef7
>   32: 9c                    pushfq
>   33: 8f 04 24              popq   (%rsp)
>   36: fa                    cli
>   37: 48 c7 c7 a0 36 5d 85 mov    $0xffffffff855d36a0,%rdi
>   3e: e8                    .byte 0xe8
>   3f: e3                    .byte 0xe3%
> 
> Hao Sun <sunhao.th@gmail.com> 于2021年9月8日周三 上午9:01写道：
>>
>> Pavel Begunkov <asml.silence@gmail.com> 于2021年9月8日周三 上午5:31写道：
>>>
>>> On 9/7/21 8:30 PM, Jens Axboe wrote:
>>>> On 9/7/21 5:50 AM, Hao Sun wrote:
>>>>> Hello,
>>>>>
>>>>> When using Healer to fuzz the latest Linux kernel, the following crash
>>>>> was triggered.
>>>>>
>>>>> HEAD commit: 7d2a07b76933 Linux 5.14
>>>>> git tree: upstream
>>>>> console output:
>>>>> https://drive.google.com/file/d/1c8uRooM0TwJiTIwEviOCB4RC-hhOgGHR/view?usp=sharing
>>>>> kernel config: https://drive.google.com/file/d/1XD9WYDViQLSXN7RGwH8AGGDvP9JvOghx/view?usp=sharing
>>>>> Similar report:
>>>>> https://groups.google.com/u/1/g/syzkaller-bugs/c/FvdcTiJIGtY/m/PcXkoenUAAAJ
>>>>>
>>>>> Sorry, I don't have a reproducer for this crash, hope the symbolized
>>>>> report can help.
>>>>> If you fix this issue, please add the following tag to the commit:
>>>>> Reported-by: Hao Sun <sunhao.th@gmail.com>
>>>>
>>>> Would be great with a reproducer for this one, though...
>>>
>>> And syzbot usually sends an execution log with all syz programs
>>> it run, which may be helpful. Any chance you have anything similar
>>> left?
>>>
>>
>> Yes, found it[1]. Here is an execution history with latest 1024
>> executed progs before crash saved.
>> Hope it can help. I'll also follow this crash closely, see if Healer
>> can find a reproducer and send it to you once it found.
>>
>> [1] https://drive.google.com/file/d/14k8qOFeyKPD4HsqOpIjud3b9jsxFSo-u/view?usp=sharing
>>
>>> --
>>> Pavel Begunkov

-- 
Pavel Begunkov
