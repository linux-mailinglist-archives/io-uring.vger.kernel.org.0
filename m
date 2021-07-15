Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id BBC963C9AC6
	for <lists+io-uring@lfdr.de>; Thu, 15 Jul 2021 10:44:35 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S240366AbhGOIr1 (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Thu, 15 Jul 2021 04:47:27 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:58474 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229620AbhGOIr0 (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Thu, 15 Jul 2021 04:47:26 -0400
Received: from mail-wr1-x42d.google.com (mail-wr1-x42d.google.com [IPv6:2a00:1450:4864:20::42d])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id E18D7C06175F;
        Thu, 15 Jul 2021 01:44:32 -0700 (PDT)
Received: by mail-wr1-x42d.google.com with SMTP id d12so6645899wre.13;
        Thu, 15 Jul 2021 01:44:32 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=subject:to:references:from:message-id:date:user-agent:mime-version
         :in-reply-to:content-language:content-transfer-encoding;
        bh=LSUy9NOxy6hOpKl6Aw+8n6kDjWrrR5sMtz1GRiZPtkM=;
        b=PkZcauHySiA+pqWu6Qoq00hWsLEN0p9yR5ej+OU2rKPKZfJthJQn+kKjjEC8HzU2hZ
         qt70NvfE7J6DZRkhwQbbibmYULmMuH7FHxdpOa7TnAasZcveU7qyuQqmlxyCyoRMO+OL
         X8dij2ilT4RV3zmMO2U3TeeIty2nR6F1NrdsXAMDhs4O+46pjlroC8z/haDHHAnRDZub
         7rP0/lNn3LFuWlNzgBNNW0Yeny8ODVyi6ZX8fyQyaxFgrhHIQuP9C8mq/eNsfbBURLqO
         AlQxZdlh8cR6GHdLlNvPz5xKx0wbBi9UbZLWzSl4YW7Vd5rwjrr/VRf8KsBNmQ46+3lO
         GdgQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=LSUy9NOxy6hOpKl6Aw+8n6kDjWrrR5sMtz1GRiZPtkM=;
        b=b5gefE/+NQhoPvadvEiFjzN4sKSIF1GzECzKhZtNNPGWxypwMlrQPfOWACzB8Qv854
         71eiltmMJWhH0jrBjqPwM7QJthFebS8QgQIk14xrohUAAWDIkCE2C8VPNNlhp13sm39G
         asy38V9hPqelR/qMRgbEfAJYSKZsEUKr8Qo56+iRAfqyyOcePzssVD0tjKyYSxBFgscE
         nQ8AJsCNxgYL6yoke2sPcpgMFhnS/fyxlAJ4nArRV6jq+Eg/YFgxaeLjfJCMUjLXQyJc
         /ZOs61PfsraSquWepdy0hm+gia2jBhPdKmZYSmPjH9fxUiFo/sx4ULkzNqnloH8SdkcV
         1tzA==
X-Gm-Message-State: AOAM532GQPtn5hGz2PQtwaeSP1oZgMYQCr/Fg3nQDDjX2PbOMxI33b0c
        YPg2+HsD4Z6bFkrQgfm+9OY=
X-Google-Smtp-Source: ABdhPJwOHmkmkuu1LkfKbETpymuNd/KwYPjAay4a5vy8+iA0Rwx/aYXh/84N5dR2ZwEqNUqNFNJyVQ==
X-Received: by 2002:adf:ebd2:: with SMTP id v18mr4114081wrn.248.1626338671305;
        Thu, 15 Jul 2021 01:44:31 -0700 (PDT)
Received: from [192.168.8.197] ([185.69.144.177])
        by smtp.gmail.com with ESMTPSA id e3sm5657788wra.15.2021.07.15.01.44.30
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Thu, 15 Jul 2021 01:44:30 -0700 (PDT)
Subject: Re: [syzbot] INFO: task hung in io_sq_thread_park (2)
To:     syzbot <syzbot+ac957324022b7132accf@syzkaller.appspotmail.com>,
        axboe@kernel.dk, io-uring@vger.kernel.org,
        linux-kernel@vger.kernel.org, mingo@kernel.org, mingo@redhat.com,
        peterz@infradead.org, rostedt@goodmis.org,
        syzkaller-bugs@googlegroups.com, will@kernel.org
References: <000000000000b25c8c05c720ef3b@google.com>
From:   Pavel Begunkov <asml.silence@gmail.com>
Message-ID: <9c692289-0d4b-a462-99b3-37f3c6521d84@gmail.com>
Date:   Thu, 15 Jul 2021 09:44:10 +0100
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:78.0) Gecko/20100101
 Thunderbird/78.11.0
MIME-Version: 1.0
In-Reply-To: <000000000000b25c8c05c720ef3b@google.com>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org

On 7/15/21 4:19 AM, syzbot wrote:
> Hello,
> 
> syzbot found the following issue on:

#syz test: git://git.kernel.dk/linux-block io_uring-5.14

> 
> HEAD commit:    3dbdb38e2869 Merge branch 'for-5.14' of git://git.kernel.o..
> git tree:       upstream
> console output: https://syzkaller.appspot.com/x/log.txt?x=12ed1402300000
> kernel config:  https://syzkaller.appspot.com/x/.config?x=a1fcf15a09815757
> dashboard link: https://syzkaller.appspot.com/bug?extid=ac957324022b7132accf
> syz repro:      https://syzkaller.appspot.com/x/repro.syz?x=1088c06c300000
> 
> The issue was bisected to:
> 
> commit 4d004099a668c41522242aa146a38cc4eb59cb1e
> Author: Peter Zijlstra <peterz@infradead.org>
> Date:   Fri Oct 2 09:04:21 2020 +0000
> 
>     lockdep: Fix lockdep recursion
> 
> bisection log:  https://syzkaller.appspot.com/x/bisect.txt?x=13e4f19c300000
> final oops:     https://syzkaller.appspot.com/x/report.txt?x=1014f19c300000
> console output: https://syzkaller.appspot.com/x/log.txt?x=17e4f19c300000
> 
> IMPORTANT: if you fix the issue, please add the following tag to the commit:
> Reported-by: syzbot+ac957324022b7132accf@syzkaller.appspotmail.com
> Fixes: 4d004099a668 ("lockdep: Fix lockdep recursion")
> 
> INFO: task kworker/u4:4:9930 blocked for more than 143 seconds.
>       Not tainted 5.13.0-syzkaller #0
> "echo 0 > /proc/sys/kernel/hung_task_timeout_secs" disables this message.
> task:kworker/u4:4    state:D stack:25664 pid: 9930 ppid:     2 flags:0x00004000
> Workqueue: events_unbound io_ring_exit_work
> Call Trace:
>  context_switch kernel/sched/core.c:4683 [inline]
>  __schedule+0x934/0x2710 kernel/sched/core.c:5940
>  schedule+0xd3/0x270 kernel/sched/core.c:6019
>  schedule_preempt_disabled+0xf/0x20 kernel/sched/core.c:6078
>  __mutex_lock_common kernel/locking/mutex.c:1036 [inline]
>  __mutex_lock+0x7b6/0x10a0 kernel/locking/mutex.c:1104
>  io_sq_thread_park+0x79/0xd0 fs/io_uring.c:7361
>  io_ring_exit_work+0x15a/0x15d0 fs/io_uring.c:8823
>  process_one_work+0x98d/0x1630 kernel/workqueue.c:2276
>  worker_thread+0x658/0x11f0 kernel/workqueue.c:2422
>  kthread+0x3e5/0x4d0 kernel/kthread.c:319
>  ret_from_fork+0x1f/0x30 arch/x86/entry/entry_64.S:295
> INFO: task iou-sqp-2939:2946 blocked for more than 143 seconds.
>       Not tainted 5.13.0-syzkaller #0
> "echo 0 > /proc/sys/kernel/hung_task_timeout_secs" disables this message.
> task:iou-sqp-2939    state:D stack:28696 pid: 2946 ppid:  8489 flags:0x00004004
> Call Trace:
>  context_switch kernel/sched/core.c:4683 [inline]
>  __schedule+0x934/0x2710 kernel/sched/core.c:5940
>  schedule+0xd3/0x270 kernel/sched/core.c:6019
>  io_uring_cancel_generic+0x54d/0x890 fs/io_uring.c:9203
>  io_sq_thread+0xa99/0x1250 fs/io_uring.c:6963
>  ret_from_fork+0x1f/0x30 arch/x86/entry/entry_64.S:295
> 
> Showing all locks held in the system:
> 1 lock held by khungtaskd/1643:
>  #0: ffffffff8c17bb80 (rcu_read_lock){....}-{1:2}, at: debug_show_all_locks+0x53/0x260 kernel/locking/lockdep.c:6446
> 1 lock held by in:imklog/8150:
>  #0: ffff888034297270 (&f->f_pos_lock){+.+.}-{3:3}, at: __fdget_pos+0xe9/0x100 fs/file.c:974
> 3 locks held by kworker/u4:4/9930:
>  #0: ffff888011069138 ((wq_completion)events_unbound){+.+.}-{0:0}, at: arch_atomic64_set arch/x86/include/asm/atomic64_64.h:34 [inline]
>  #0: ffff888011069138 ((wq_completion)events_unbound){+.+.}-{0:0}, at: atomic64_set include/asm-generic/atomic-instrumented.h:620 [inline]
>  #0: ffff888011069138 ((wq_completion)events_unbound){+.+.}-{0:0}, at: atomic_long_set include/asm-generic/atomic-long.h:41 [inline]
>  #0: ffff888011069138 ((wq_completion)events_unbound){+.+.}-{0:0}, at: set_work_data kernel/workqueue.c:617 [inline]
>  #0: ffff888011069138 ((wq_completion)events_unbound){+.+.}-{0:0}, at: set_work_pool_and_clear_pending kernel/workqueue.c:644 [inline]
>  #0: ffff888011069138 ((wq_completion)events_unbound){+.+.}-{0:0}, at: process_one_work+0x871/0x1630 kernel/workqueue.c:2247
>  #1: ffffc9000b31fdb0 ((work_completion)(&ctx->exit_work)){+.+.}-{0:0}, at: process_one_work+0x8a5/0x1630 kernel/workqueue.c:2251
>  #2: ffff888045068870 (&sqd->lock){+.+.}-{3:3}, at: io_sq_thread_park+0x79/0xd0 fs/io_uring.c:7361
> 1 lock held by iou-sqp-2939/2946:
>  #0: ffff888045068870 (&sqd->lock){+.+.}-{3:3}, at: io_sqd_handle_event+0x2d6/0x350 fs/io_uring.c:6883
> 
> =============================================
> 
> NMI backtrace for cpu 1
> CPU: 1 PID: 1643 Comm: khungtaskd Not tainted 5.13.0-syzkaller #0
> Hardware name: Google Google Compute Engine/Google Compute Engine, BIOS Google 01/01/2011
> Call Trace:
>  __dump_stack lib/dump_stack.c:79 [inline]
>  dump_stack_lvl+0xcd/0x134 lib/dump_stack.c:96
>  nmi_cpu_backtrace.cold+0x44/0xd7 lib/nmi_backtrace.c:105
>  nmi_trigger_cpumask_backtrace+0x1b3/0x230 lib/nmi_backtrace.c:62
>  trigger_all_cpu_backtrace include/linux/nmi.h:146 [inline]
>  check_hung_uninterruptible_tasks kernel/hung_task.c:209 [inline]
>  watchdog+0xd4b/0xfb0 kernel/hung_task.c:294
>  kthread+0x3e5/0x4d0 kernel/kthread.c:319
>  ret_from_fork+0x1f/0x30 arch/x86/entry/entry_64.S:295
> Sending NMI from CPU 1 to CPUs 0:
> NMI backtrace for cpu 0
> CPU: 0 PID: 9784 Comm: kworker/0:7 Not tainted 5.13.0-syzkaller #0
> Hardware name: Google Google Compute Engine/Google Compute Engine, BIOS Google 01/01/2011
> Workqueue: events_power_efficient gc_worker
> RIP: 0010:check_region_inline mm/kasan/generic.c:175 [inline]
> RIP: 0010:kasan_check_range+0x2a/0x180 mm/kasan/generic.c:189
> Code: 48 85 f6 0f 84 70 01 00 00 49 89 f9 41 54 44 0f b6 c2 49 01 f1 55 53 0f 82 18 01 00 00 48 b8 ff ff ff ff ff 7f ff ff 48 39 c7 <0f> 86 05 01 00 00 49 83 e9 01 48 89 fd 48 b8 00 00 00 00 00 fc ff
> RSP: 0018:ffffc9000aedfad8 EFLAGS: 00000016
> RAX: ffff7fffffffffff RBX: 00000000000004c2 RCX: ffffffff815ac59f
> RDX: 0000000000000000 RSI: 0000000000000008 RDI: ffffffff9049d938
> RBP: ffff88802d62267a R08: 0000000000000000 R09: ffffffff9049d940
> R10: fffffbfff2093b27 R11: 0000000000000000 R12: ffff88802d622658
> R13: ffff88802d621c40 R14: 0000000000000000 R15: 23147e44cee2677e
> FS:  0000000000000000(0000) GS:ffff8880b9c00000(0000) knlGS:0000000000000000
> CS:  0010 DS: 0000 ES: 0000 CR0: 0000000080050033
> CR2: 00007fb48abd5000 CR3: 000000000be8e000 CR4: 0000000000350ef0
> Call Trace:
>  instrument_atomic_read include/linux/instrumented.h:71 [inline]
>  test_bit include/asm-generic/bitops/instrumented-non-atomic.h:134 [inline]
>  hlock_class kernel/locking/lockdep.c:199 [inline]
>  lookup_chain_cache_add kernel/locking/lockdep.c:3701 [inline]
>  validate_chain kernel/locking/lockdep.c:3757 [inline]
>  __lock_acquire+0x162f/0x54a0 kernel/locking/lockdep.c:5015
>  lock_acquire kernel/locking/lockdep.c:5625 [inline]
>  lock_acquire+0x1ab/0x510 kernel/locking/lockdep.c:5590
>  process_one_work+0x8fc/0x1630 kernel/workqueue.c:2252
>  worker_thread+0x658/0x11f0 kernel/workqueue.c:2422
>  kthread+0x3e5/0x4d0 kernel/kthread.c:319
>  ret_from_fork+0x1f/0x30 arch/x86/entry/entry_64.S:295
> 
> 
> ---
> This report is generated by a bot. It may contain errors.
> See https://goo.gl/tpsmEJ for more information about syzbot.
> syzbot engineers can be reached at syzkaller@googlegroups.com.
> 
> syzbot will keep track of this issue. See:
> https://goo.gl/tpsmEJ#status for how to communicate with syzbot.
> For information about bisection process see: https://goo.gl/tpsmEJ#bisection
> syzbot can test patches for this issue, for details see:
> https://goo.gl/tpsmEJ#testing-patches
> 

-- 
Pavel Begunkov
