Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id D943D2B74CB
	for <lists+io-uring@lfdr.de>; Wed, 18 Nov 2020 04:29:24 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727550AbgKRD3G (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Tue, 17 Nov 2020 22:29:06 -0500
Received: from out30-131.freemail.mail.aliyun.com ([115.124.30.131]:58395 "EHLO
        out30-131.freemail.mail.aliyun.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1725808AbgKRD3F (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Tue, 17 Nov 2020 22:29:05 -0500
X-Alimail-AntiSpam: AC=PASS;BC=-1|-1;BR=01201311R811e4;CH=green;DM=||false|;DS=||;FP=0|-1|-1|-1|0|-1|-1|-1;HT=e01e04426;MF=xiaoguang.wang@linux.alibaba.com;NM=1;PH=DS;RN=7;SR=0;TI=SMTPD_---0UFlQ429_1605670141;
Received: from 30.225.32.174(mailfrom:xiaoguang.wang@linux.alibaba.com fp:SMTPD_---0UFlQ429_1605670141)
          by smtp.aliyun-inc.com(127.0.0.1);
          Wed, 18 Nov 2020 11:29:01 +0800
Subject: Re: INFO: task can't die in io_sq_thread_stop
From:   Xiaoguang Wang <xiaoguang.wang@linux.alibaba.com>
To:     syzbot <syzbot+03beeb595f074db9cfd1@syzkaller.appspotmail.com>,
        axboe@kernel.dk, io-uring@vger.kernel.org,
        linux-fsdevel@vger.kernel.org, linux-kernel@vger.kernel.org,
        syzkaller-bugs@googlegroups.com, viro@zeniv.linux.org.uk
References: <00000000000038569805b4211287@google.com>
 <39be8d01-6550-ee8a-5a8d-2707b372b711@linux.alibaba.com>
Message-ID: <d57f9c10-e640-08f5-4c20-2553768aff65@linux.alibaba.com>
Date:   Wed, 18 Nov 2020 11:27:42 +0800
User-Agent: Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:78.0) Gecko/20100101
 Thunderbird/78.4.3
MIME-Version: 1.0
In-Reply-To: <39be8d01-6550-ee8a-5a8d-2707b372b711@linux.alibaba.com>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org

hi,

A gentle reminder, in case you overlooked this syzbot report.

Regards,
Xiaoguang Wang

> hi jens,
> 
>> Hello,
>>
>> syzbot found the following issue on:
>>
>> HEAD commit:    6dd65e60 Add linux-next specific files for 20201110
>> git tree:       linux-next
>> console output: https://syzkaller.appspot.com/x/log.txt?x=14727d42500000
>> kernel config:  https://syzkaller.appspot.com/x/.config?x=4fab43daf5c54712
>> dashboard link: https://syzkaller.appspot.com/bug?extid=03beeb595f074db9cfd1
>> compiler:       gcc (GCC) 10.1.0-syz 20200507
>>
>> Unfortunately, I don't have any reproducer for this issue yet.
>>
>> IMPORTANT: if you fix the issue, please add the following tag to the commit:
>> Reported-by: syzbot+03beeb595f074db9cfd1@syzkaller.appspotmail.com
>>
>> INFO: task syz-executor.2:12399 can't die for more than 143 seconds.
>> task:syz-executor.2  state:D stack:28744 pid:12399 ppid:  8504 flags:0x00004004
>> Call Trace:
>>   context_switch kernel/sched/core.c:3773 [inline]
>>   __schedule+0x893/0x2170 kernel/sched/core.c:4522
>>   schedule+0xcf/0x270 kernel/sched/core.c:4600
>>   schedule_timeout+0x1d8/0x250 kernel/time/timer.c:1847
>>   do_wait_for_common kernel/sched/completion.c:85 [inline]
>>   __wait_for_common kernel/sched/completion.c:106 [inline]
>>   wait_for_common kernel/sched/completion.c:117 [inline]
>>   wait_for_completion+0x163/0x260 kernel/sched/completion.c:138
>>   kthread_stop+0x17a/0x720 kernel/kthread.c:596
>>   io_put_sq_data fs/io_uring.c:7193 [inline]
>>   io_sq_thread_stop+0x452/0x570 fs/io_uring.c:7290
>>   io_finish_async fs/io_uring.c:7297 [inline]
>>   io_sq_offload_create fs/io_uring.c:8015 [inline]
>>   io_uring_create fs/io_uring.c:9433 [inline]
>>   io_uring_setup+0x19b7/0x3730 fs/io_uring.c:9507
>>   do_syscall_64+0x2d/0x70 arch/x86/entry/common.c:46
>>   entry_SYSCALL_64_after_hwframe+0x44/0xa9
> I also don't have a reproducer yet, but seems that there is a race
> in current codes:                  |
> => io_put_sq_data                  |
> ==> kthread_park(sqd->thread);     |
>                                     | T1: sq thread is parked now.
> ==> kthread_stop(sqd->thread);     |
> ===> kthread_unpark(k);            |
>                                     | T2: sq thread is now unpared, can run again
>                                     |
>                                     | T3: sq thread is now preempted out.
>                                     |
> ===> wake_up_process(k);           |
>                                     |
>                                     | T4: Since sqd ctx list is empty, needs_sched will be true,
>                                     | then sq thread sets task state to TASK_INTERRUPTIBLE,
>                                     | and schedule, now sq thread will never be waken up.
> ===> wait_for_completion           |
> 
> I have artificially used mdelay() to simulate above race, will get same stack like
> this syzbot report.
> 
> -               if (kthread_should_park())
> +               if (kthread_should_park()) {
>                          kthread_parkme();
> +                       if (kthread_should_stop())
> +                               break;
> +               }
> this diff can fix this issue, and if ctx_list is empty, we don't need to call schedule().
> 
> Regards,
> Xiaoguang Wang
> 
> 
>> RIP: 0033:0x45deb9
>> Code: Unable to access opcode bytes at RIP 0x45de8f.
>> RSP: 002b:00007f174e51ac78 EFLAGS: 00000246 ORIG_RAX: 00000000000001a9
>> RAX: ffffffffffffffda RBX: 0000000000008640 RCX: 000000000045deb9
>> RDX: 0000000000000000 RSI: 0000000020000140 RDI: 00000000000050e5
>> RBP: 000000000118bf58 R08: 0000000000000000 R09: 0000000000000000
>> R10: 0000000000000000 R11: 0000000000000246 R12: 000000000118bf2c
>> R13: 00007ffed9ca723f R14: 00007f174e51b9c0 R15: 000000000118bf2c
>> INFO: task syz-executor.2:12399 blocked for more than 143 seconds.
>>        Not tainted 5.10.0-rc3-next-20201110-syzkaller #0
>> "echo 0 > /proc/sys/kernel/hung_task_timeout_secs" disables this message.
>> task:syz-executor.2  state:D stack:28744 pid:12399 ppid:  8504 flags:0x00004004
>> Call Trace:
>>   context_switch kernel/sched/core.c:3773 [inline]
>>   __schedule+0x893/0x2170 kernel/sched/core.c:4522
>>   schedule+0xcf/0x270 kernel/sched/core.c:4600
>>   schedule_timeout+0x1d8/0x250 kernel/time/timer.c:1847
>>   do_wait_for_common kernel/sched/completion.c:85 [inline]
>>   __wait_for_common kernel/sched/completion.c:106 [inline]
>>   wait_for_common kernel/sched/completion.c:117 [inline]
>>   wait_for_completion+0x163/0x260 kernel/sched/completion.c:138
>>   kthread_stop+0x17a/0x720 kernel/kthread.c:596
>>   io_put_sq_data fs/io_uring.c:7193 [inline]
>>   io_sq_thread_stop+0x452/0x570 fs/io_uring.c:7290
>>   io_finish_async fs/io_uring.c:7297 [inline]
>>   io_sq_offload_create fs/io_uring.c:8015 [inline]
>>   io_uring_create fs/io_uring.c:9433 [inline]
>>   io_uring_setup+0x19b7/0x3730 fs/io_uring.c:9507
>>   do_syscall_64+0x2d/0x70 arch/x86/entry/common.c:46
>>   entry_SYSCALL_64_after_hwframe+0x44/0xa9
>> RIP: 0033:0x45deb9
>> Code: Unable to access opcode bytes at RIP 0x45de8f.
>> RSP: 002b:00007f174e51ac78 EFLAGS: 00000246 ORIG_RAX: 00000000000001a9
>> RAX: ffffffffffffffda RBX: 0000000000008640 RCX: 000000000045deb9
>> RDX: 0000000000000000 RSI: 0000000020000140 RDI: 00000000000050e5
>> RBP: 000000000118bf58 R08: 0000000000000000 R09: 0000000000000000
>> R10: 0000000000000000 R11: 0000000000000246 R12: 000000000118bf2c
>> R13: 00007ffed9ca723f R14: 00007f174e51b9c0 R15: 000000000118bf2c
>>
>> Showing all locks held in the system:
>> 1 lock held by khungtaskd/1653:
>>   #0: ffffffff8b3386a0 (rcu_read_lock){....}-{1:2}, at: debug_show_all_locks+0x53/0x260 kernel/locking/lockdep.c:6253
>> 1 lock held by systemd-journal/4873:
>> 1 lock held by in:imklog/8167:
>>   #0: ffff88801c86e0f0 (&f->f_pos_lock){+.+.}-{3:3}, at: __fdget_pos+0xe9/0x100 fs/file.c:932
>>
>> =============================================
>>
>> NMI backtrace for cpu 1
>> CPU: 1 PID: 1653 Comm: khungtaskd Not tainted 5.10.0-rc3-next-20201110-syzkaller #0
>> Hardware name: Google Google Compute Engine/Google Compute Engine, BIOS Google 01/01/2011
>> Call Trace:
>>   __dump_stack lib/dump_stack.c:77 [inline]
>>   dump_stack+0x107/0x163 lib/dump_stack.c:118
>>   nmi_cpu_backtrace.cold+0x44/0xd7 lib/nmi_backtrace.c:105
>>   nmi_trigger_cpumask_backtrace+0x1b3/0x230 lib/nmi_backtrace.c:62
>>   trigger_all_cpu_backtrace include/linux/nmi.h:147 [inline]
>>   check_hung_uninterruptible_tasks kernel/hung_task.c:253 [inline]
>>   watchdog+0xd89/0xf30 kernel/hung_task.c:338
>>   kthread+0x3af/0x4a0 kernel/kthread.c:292
>>   ret_from_fork+0x1f/0x30 arch/x86/entry/entry_64.S:296
>> Sending NMI from CPU 1 to CPUs 0:
>> NMI backtrace for cpu 0
>> CPU: 0 PID: 5 Comm: kworker/0:0 Not tainted 5.10.0-rc3-next-20201110-syzkaller #0
>> Hardware name: Google Google Compute Engine/Google Compute Engine, BIOS Google 01/01/2011
>> Workqueue: events nsim_dev_trap_report_work
>> RIP: 0010:mark_lock+0x30/0x24c0 kernel/locking/lockdep.c:4371
>> Code: 41 54 41 89 d4 48 ba 00 00 00 00 00 fc ff df 55 53 48 81 ec 18 01 00 00 48 8d 5c 24 38 48 89 3c 24 48 c7 44 24 38 b3 8a b5 41 <48> c1 eb 03 48 c7 44 24 40 30 1b c6 8a 48 8d 04 13 48 c7 44 24 48
>> RSP: 0018:ffffc90000ca7988 EFLAGS: 00000096
>> RAX: 0000000000000004 RBX: ffffc90000ca79c0 RCX: ffffffff8155b947
>> RDX: dffffc0000000000 RSI: ffff888010d20918 RDI: ffff888010d20000
>> RBP: 0000000000000006 R08: 0000000000000000 R09: ffffffff8ebb477f
>> R10: fffffbfff1d768ef R11: 000000004fb6aa4b R12: 0000000000000006
>> R13: dffffc0000000000 R14: ffff888010d20918 R15: 0000000000000022
>> FS:  0000000000000000(0000) GS:ffff8880b9e00000(0000) knlGS:0000000000000000
>> CS:  0010 DS: 0000 ES: 0000 CR0: 0000000080050033
>> CR2: 00007f8ffcf99000 CR3: 000000001b2e7000 CR4: 00000000001506f0
>> DR0: 0000000000000000 DR1: 0000000000000000 DR2: 0000000000000000
>> DR3: 0000000000000000 DR6: 00000000fffe0ff0 DR7: 0000000000000400
>> Call Trace:
>>   mark_held_locks+0x9f/0xe0 kernel/locking/lockdep.c:4011
>>   __trace_hardirqs_on_caller kernel/locking/lockdep.c:4037 [inline]
>>   lockdep_hardirqs_on_prepare kernel/locking/lockdep.c:4097 [inline]
>>   lockdep_hardirqs_on_prepare+0x28b/0x400 kernel/locking/lockdep.c:4049
>>   trace_hardirqs_on+0x5b/0x1c0 kernel/trace/trace_preemptirq.c:49
>>   __raw_spin_unlock_irqrestore include/linux/spinlock_api_smp.h:160 [inline]
>>   _raw_spin_unlock_irqrestore+0x42/0x50 kernel/locking/spinlock.c:191
>>   extract_crng drivers/char/random.c:1026 [inline]
>>   _get_random_bytes+0x229/0x670 drivers/char/random.c:1562
>>   nsim_dev_trap_skb_build drivers/net/netdevsim/dev.c:538 [inline]
>>   nsim_dev_trap_report drivers/net/netdevsim/dev.c:568 [inline]
>>   nsim_dev_trap_report_work+0x740/0xbd0 drivers/net/netdevsim/dev.c:609
>>   process_one_work+0x933/0x15a0 kernel/workqueue.c:2272
>>   worker_thread+0x64c/0x1120 kernel/workqueue.c:2418
>>   kthread+0x3af/0x4a0 kernel/kthread.c:292
>>   ret_from_fork+0x1f/0x30 arch/x86/entry/entry_64.S:296
>>
>>
>> ---
>> This report is generated by a bot. It may contain errors.
>> See https://goo.gl/tpsmEJ for more information about syzbot.
>> syzbot engineers can be reached at syzkaller@googlegroups.com.
>>
>> syzbot will keep track of this issue. See:
>> https://goo.gl/tpsmEJ#status for how to communicate with syzbot.
>>
