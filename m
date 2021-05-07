Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id F342B376AD9
	for <lists+io-uring@lfdr.de>; Fri,  7 May 2021 21:53:45 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229801AbhEGTyo (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Fri, 7 May 2021 15:54:44 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:43372 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229658AbhEGTyo (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Fri, 7 May 2021 15:54:44 -0400
Received: from mail-wr1-x42f.google.com (mail-wr1-x42f.google.com [IPv6:2a00:1450:4864:20::42f])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 441DFC061574;
        Fri,  7 May 2021 12:53:43 -0700 (PDT)
Received: by mail-wr1-x42f.google.com with SMTP id l14so10397056wrx.5;
        Fri, 07 May 2021 12:53:43 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=subject:to:references:from:message-id:date:user-agent:mime-version
         :in-reply-to:content-language:content-transfer-encoding;
        bh=9NAGhc6Ivqq4n+9KD59epIgjP0uciH+JGFWa7c7sVyc=;
        b=XlviFJHSBqCvLI33lSrclO0Lr3TTWcjo0SCX+BODda/tufpnYkqWvwkEYfBbzCxIv+
         cwUMuMgXT35rOXzmwHk6iAxP5CoQtWHc7UdzVugvkuC6ZOii7vYTuprTIK1KxrygAyj/
         btBFM8VX5HbGFPP/vOR86+G7suCfNvaQf2xJdc6zBlJRbX9odrBztDY9L6H8gGGehav/
         GZ5sWcXCi3jnUXAJWvq8mZX5FV1P841Ck/0qjWkZXeHlA0m7c3Djb3bS8bwM9w0DGssf
         m1wq25B7UVh2jwHJKfckWLjhn94uMpM9sWEDSW+MACOytAtOZ2QP38VXaj4y0FCZZlwl
         cQVg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=9NAGhc6Ivqq4n+9KD59epIgjP0uciH+JGFWa7c7sVyc=;
        b=Y6bZV2pj2vF3/rSdnU/e0sCIpdeVRye9hY0cqr5VsSV0aIeL8cXtXon6RodbAu8ZqQ
         uRX2JJDymAy7gl19+W2mlEa6NlK6zkYMOSLFHRODWZp3hLACTnAruMLt9NIHPJoUtlnV
         re/O0LPWV2o1tvyFwQWMYLIdanZPWwoFHGnHjoowSHMW0DznxNWJ0eqing5fLKRErbza
         skwgqrI2sJ8xxezwExyIDEi+xL3ri21/nFc8by6pBPj7Ds3UsRufp4khPQyap+l/wcg0
         dyz0JaZ2OU/PPHsl0AGATmbWsXLpi4xHebfOmdfzYC7rglI+UJgZaBZiAQvduFrdFS6P
         si9Q==
X-Gm-Message-State: AOAM531MZVQegNs5tj1ACc6ea8AxNqQoBEYRONPAjL7n3968kbu9AleR
        tWc3sZkUhwFo5dGm4tjBoCk=
X-Google-Smtp-Source: ABdhPJwhrfbR6hWlVnCJx2EzNfd/lT1dY1qX9HeNx+LeKfZWZmor79kQ/LOrpJ9OUHjbfGC8QaBCvA==
X-Received: by 2002:adf:ffc4:: with SMTP id x4mr13904947wrs.415.1620417222065;
        Fri, 07 May 2021 12:53:42 -0700 (PDT)
Received: from [192.168.8.197] ([148.252.132.80])
        by smtp.gmail.com with ESMTPSA id o15sm333914wme.22.2021.05.07.12.53.41
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Fri, 07 May 2021 12:53:41 -0700 (PDT)
Subject: Re: [syzbot] INFO: task hung in io_ring_exit_work
To:     syzbot <syzbot+93f72b3885406bb09e0d@syzkaller.appspotmail.com>,
        axboe@kernel.dk, io-uring@vger.kernel.org,
        linux-kernel@vger.kernel.org, syzkaller-bugs@googlegroups.com
References: <0000000000008aed3505bf362671@google.com>
From:   Pavel Begunkov <asml.silence@gmail.com>
Message-ID: <e2fe2053-c413-daa4-1151-c4476d32d23a@gmail.com>
Date:   Fri, 7 May 2021 20:53:36 +0100
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:78.0) Gecko/20100101
 Thunderbird/78.10.0
MIME-Version: 1.0
In-Reply-To: <0000000000008aed3505bf362671@google.com>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org

On 4/5/21 10:16 AM, syzbot wrote:
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

#syz test: git://git.kernel.dk/linux-block io_uring-5.13

> 
> IMPORTANT: if you fix the issue, please add the following tag to the commit:
> Reported-by: syzbot+93f72b3885406bb09e0d@syzkaller.appspotmail.com
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
