Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 807EA25C4AD
	for <lists+io-uring@lfdr.de>; Thu,  3 Sep 2020 17:13:59 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728670AbgICPNV (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Thu, 3 Sep 2020 11:13:21 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:38672 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1728642AbgICLoa (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Thu, 3 Sep 2020 07:44:30 -0400
Received: from mail-pf1-x443.google.com (mail-pf1-x443.google.com [IPv6:2607:f8b0:4864:20::443])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 69A9CC061245
        for <io-uring@vger.kernel.org>; Thu,  3 Sep 2020 04:44:27 -0700 (PDT)
Received: by mail-pf1-x443.google.com with SMTP id b124so2093608pfg.13
        for <io-uring@vger.kernel.org>; Thu, 03 Sep 2020 04:44:27 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernel-dk.20150623.gappssmtp.com; s=20150623;
        h=subject:to:cc:references:from:message-id:date:user-agent
         :mime-version:in-reply-to:content-language:content-transfer-encoding;
        bh=XYy9iYDtNLGL5bCOfRQT00miN6fAigIFaBe5iRl8NBM=;
        b=A5dpKCSiFWMcaqGBkED2BMCrklwy4dFrpX1BEZ/WXRqS9eenB8Q2t7m7ORN3djgbvE
         /KKNn1V2Lo979vjwx6iPr4hy0okEObBarbSDJjpbEOxOU9LIIfrhrTjqGIN5ePmEXeZW
         ZpagM9tTrO8Sp66tvHtM1dFwPDJh7me0T/Z1hnhqA8yNsf3dOhtb3JfoYGsa2PFLmiAH
         LtCzUaE63pYMsMvfjpct4lRT5gg8kP6v2+P/KOLQNqnxeuUkSH4Kxzy7l07z03W9RME6
         IXGkIU+6ZLySer4986cO7MgdNRuhoaESlB6kIWK8505sWY3Phe7RE1Kp3glvO5zCYolr
         2t3g==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=XYy9iYDtNLGL5bCOfRQT00miN6fAigIFaBe5iRl8NBM=;
        b=AMj6/7fmn8SM9v9OmJv6TwIWkT2q7N6Z+2F/b/E7qewCNt9cITlBv8sFpxQZSXKybr
         hpQ3OIZ9zTLWgqJAk4/Us5QoWwrlMX2q/BwZWNsHWn+X6pC0bfzH2W6SPnd3QJmp7r/L
         AGqxOtJZEY6dhZz8otei7MURw0TLVYa13CsEXJkLX/npmC3ZyEHIMDOgvrSVjwa4v1ea
         tZ8SbVeBJp10InG4PGDBiUMZzJjUaF9gP+765KKMKR0vFZbPmG2o8eMRZLmWO5rmMagY
         AhN2Kyd/3YcQYO/QR4vdCsV1pydQfgp8S/PA0JMmXhD1hW9mYSSx0loQ2ruos7cKedJU
         zN3g==
X-Gm-Message-State: AOAM533u28UwlKn4cCKuiVnjFDLwn8wLzPFU6RRPa02tBLLGy1LygSIo
        GNGlhzZtndHD9GYppy3DpnjRNA==
X-Google-Smtp-Source: ABdhPJxep3XrOLrT8PFWfPtq/ViLuJfRMw+LB80arLFqvajOiIfofIKxBlLX/9bENc7kVMkSDS2NKg==
X-Received: by 2002:a63:355:: with SMTP id 82mr2544110pgd.384.1599133467090;
        Thu, 03 Sep 2020 04:44:27 -0700 (PDT)
Received: from [192.168.1.187] ([66.219.217.173])
        by smtp.gmail.com with ESMTPSA id lw2sm2206432pjb.34.2020.09.03.04.44.25
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Thu, 03 Sep 2020 04:44:26 -0700 (PDT)
Subject: Re: INFO: task hung in io_uring_setup
To:     Hillf Danton <hdanton@sina.com>,
        syzbot <syzbot+107dd59d1efcaf3ffca4@syzkaller.appspotmail.com>
Cc:     io-uring@vger.kernel.org, keescook@chromium.org,
        linux-fsdevel@vger.kernel.org, linux-kernel@vger.kernel.org,
        sgarzare@redhat.com, syzkaller-bugs@googlegroups.com,
        viro@zeniv.linux.org.uk
References: <000000000000602d0405ae64aca3@google.com>
 <20200903111515.17364-1-hdanton@sina.com>
From:   Jens Axboe <axboe@kernel.dk>
Message-ID: <5e0d35fb-73f7-cbb1-3932-1a1c55fa57fc@kernel.dk>
Date:   Thu, 3 Sep 2020 05:44:25 -0600
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.10.0
MIME-Version: 1.0
In-Reply-To: <20200903111515.17364-1-hdanton@sina.com>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Sender: io-uring-owner@vger.kernel.org
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org

On 9/3/20 5:15 AM, Hillf Danton wrote:
> 
> Thu, 03 Sep 2020 01:38:15 -0700
>> syzbot found the following issue on:
>>
>> HEAD commit:    4442749a Add linux-next specific files for 20200902
>> git tree:       linux-next
>> console output: https://syzkaller.appspot.com/x/log.txt?x=12f9e915900000
>> kernel config:  https://syzkaller.appspot.com/x/.config?x=39134fcec6c78e33
>> dashboard link: https://syzkaller.appspot.com/bug?extid=107dd59d1efcaf3ffca4
>> compiler:       gcc (GCC) 10.1.0-syz 20200507
>> syz repro:      https://syzkaller.appspot.com/x/repro.syz?x=11594671900000
>> C reproducer:   https://syzkaller.appspot.com/x/repro.c?x=111ca835900000
>>
>> The issue was bisected to:
>>
>> commit dfe127799f8e663c7e3e48b5275ca538b278177b
>> Author: Stefano Garzarella <sgarzare@redhat.com>
>> Date:   Thu Aug 27 14:58:31 2020 +0000
>>
>>     io_uring: allow disabling rings during the creation
>>
>> bisection log:  https://syzkaller.appspot.com/x/bisect.txt?x=11bc66c1900000
>> final oops:     https://syzkaller.appspot.com/x/report.txt?x=13bc66c1900000
>> console output: https://syzkaller.appspot.com/x/log.txt?x=15bc66c1900000
>>
>> IMPORTANT: if you fix the issue, please add the following tag to the commit:
>> Reported-by: syzbot+107dd59d1efcaf3ffca4@syzkaller.appspotmail.com
>> Fixes: dfe127799f8e ("io_uring: allow disabling rings during the creation")
>>
>> INFO: task syz-executor047:6853 blocked for more than 143 seconds.
>>       Not tainted 5.9.0-rc3-next-20200902-syzkaller #0
>> "echo 0 > /proc/sys/kernel/hung_task_timeout_secs" disables this message.
>> task:syz-executor047 state:D stack:28104 pid: 6853 ppid:  6847 flags:0x00004000
>> Call Trace:
>>  context_switch kernel/sched/core.c:3777 [inline]
>>  __schedule+0xea9/0x2230 kernel/sched/core.c:4526
>>  schedule+0xd0/0x2a0 kernel/sched/core.c:4601
>>  schedule_timeout+0x1d8/0x250 kernel/time/timer.c:1855
>>  do_wait_for_common kernel/sched/completion.c:85 [inline]
>>  __wait_for_common kernel/sched/completion.c:106 [inline]
>>  wait_for_common kernel/sched/completion.c:117 [inline]
>>  wait_for_completion+0x163/0x260 kernel/sched/completion.c:138
>>  io_sq_thread_stop fs/io_uring.c:6906 [inline]
>>  io_finish_async fs/io_uring.c:6920 [inline]
>>  io_sq_offload_create fs/io_uring.c:7595 [inline]
>>  io_uring_create fs/io_uring.c:8671 [inline]
>>  io_uring_setup+0x1495/0x29a0 fs/io_uring.c:8744
>>  do_syscall_64+0x2d/0x70 arch/x86/entry/common.c:46
>>  entry_SYSCALL_64_after_hwframe+0x44/0xa9
>> RIP: 0033:0x440299
>> Code: Bad RIP value.
>> RSP: 002b:00007ffc57cff668 EFLAGS: 00000246 ORIG_RAX: 00000000000001a9
>> RAX: ffffffffffffffda RBX: 00000000004002c8 RCX: 0000000000440299
>> RDX: 0000000000400b40 RSI: 0000000020000100 RDI: 0000000000003ffe
>> RBP: 00000000006ca018 R08: 0000000000000000 R09: 0000000000000000
>> R10: 00000000ffffffff R11: 0000000000000246 R12: 0000000000401aa0
>> R13: 0000000000401b30 R14: 0000000000000000 R15: 0000000000000000
>> INFO: task io_uring-sq:6854 blocked for more than 143 seconds.
>>       Not tainted 5.9.0-rc3-next-20200902-syzkaller #0
>> "echo 0 > /proc/sys/kernel/hung_task_timeout_secs" disables this message.
>> task:io_uring-sq     state:D stack:31200 pid: 6854 ppid:     2 flags:0x00004000
>> Call Trace:
>>  context_switch kernel/sched/core.c:3777 [inline]
>>  __schedule+0xea9/0x2230 kernel/sched/core.c:4526
>>  schedule+0xd0/0x2a0 kernel/sched/core.c:4601
>>  schedule_preempt_disabled+0xf/0x20 kernel/sched/core.c:4660
>>  kthread+0x2ac/0x4a0 kernel/kthread.c:285
>>  ret_from_fork+0x1f/0x30 arch/x86/entry/entry_64.S:294
>>
>> Showing all locks held in the system:
>> 1 lock held by khungtaskd/1174:
>>  #0: ffffffff89c67980 (rcu_read_lock){....}-{1:2}, at: debug_show_all_locks+0x53/0x260 kernel/locking/lockdep.c:5829
>> 3 locks held by in:imklog/6525:
>>  #0: ffff8880a3de2df0 (&f->f_pos_lock){+.+.}-{3:3}, at: __fdget_pos+0xe9/0x100 fs/file.c:930
>>  #1: ffff8880907d8968 (&mm->mmap_lock#2){++++}-{3:3}, at: rq_lock kernel/sched/sched.h:1292 [inline]
>>  #1: ffff8880907d8968 (&mm->mmap_lock#2){++++}-{3:3}, at: ttwu_queue kernel/sched/core.c:2698 [inline]
>>  #1: ffff8880907d8968 (&mm->mmap_lock#2){++++}-{3:3}, at: try_to_wake_up+0x52b/0x12b0 kernel/sched/core.c:2978
>>  #2: ffff8880ae620ec8 (&per_cpu_ptr(group->pcpu, cpu)->seq){-.-.}-{0:0}, at: psi_task_switch+0x2fb/0x400 kernel/sched/psi.c:833
>>
>> =============================================
>>
>> NMI backtrace for cpu 1
>> CPU: 1 PID: 1174 Comm: khungtaskd Not tainted 5.9.0-rc3-next-20200902-syzkaller #0
>> Hardware name: Google Google Compute Engine/Google Compute Engine, BIOS Google 01/01/2011
>> Call Trace:
>>  __dump_stack lib/dump_stack.c:77 [inline]
>>  dump_stack+0x198/0x1fd lib/dump_stack.c:118
>>  nmi_cpu_backtrace.cold+0x44/0xd7 lib/nmi_backtrace.c:105
>>  nmi_trigger_cpumask_backtrace+0x1b3/0x223 lib/nmi_backtrace.c:62
>>  trigger_all_cpu_backtrace include/linux/nmi.h:147 [inline]
>>  check_hung_uninterruptible_tasks kernel/hung_task.c:253 [inline]
>>  watchdog+0xd89/0xf30 kernel/hung_task.c:339
>>  kthread+0x3b5/0x4a0 kernel/kthread.c:292
>>  ret_from_fork+0x1f/0x30 arch/x86/entry/entry_64.S:294
>> Sending NMI from CPU 1 to CPUs 0:
>> NMI backtrace for cpu 0
>> CPU: 0 PID: 3901 Comm: systemd-journal Not tainted 5.9.0-rc3-next-20200902-syzkaller #0
>> Hardware name: Google Google Compute Engine/Google Compute Engine, BIOS Google 01/01/2011
>> RIP: 0010:unwind_next_frame+0x139a/0x1f90 arch/x86/kernel/unwind_orc.c:607
>> Code: 49 39 47 28 0f 85 3e f0 ff ff 80 3d df 2c 84 09 00 0f 85 31 f0 ff ff e9 06 18 00 00 48 b8 00 00 00 00 00 fc ff df 48 8b 14 24 <48> c1 ea 03 80 3c 02 00 0f 85 02 08 00 00 49 8d 7f 08 49 8b 6f 38
>> RSP: 0018:ffffc900040475f8 EFLAGS: 00000246
>> RAX: dffffc0000000000 RBX: 1ffff92000808ec7 RCX: 1ffff92000808ee2
>> RDX: ffffc90004047708 RSI: ffffc90004047aa8 RDI: ffffc90004047aa8
>> RBP: 0000000000000001 R08: ffffffff8b32a670 R09: 0000000000000001
>> R10: 000000000007201e R11: 0000000000000001 R12: ffffc90004047ac8
>> R13: ffffc90004047705 R14: ffffc90004047720 R15: ffffc900040476d0
>> FS:  00007efc659ac8c0(0000) GS:ffff8880ae600000(0000) knlGS:0000000000000000
>> CS:  0010 DS: 0000 ES: 0000 CR0: 0000000080050033
>> CR2: 00007efc62d51000 CR3: 0000000093d6a000 CR4: 00000000001506f0
>> DR0: 0000000000000000 DR1: 0000000000000000 DR2: 0000000000000000
>> DR3: 0000000000000000 DR6: 00000000fffe0ff0 DR7: 0000000000000400
>> Call Trace:
>>  arch_stack_walk+0x81/0xf0 arch/x86/kernel/stacktrace.c:25
>>  stack_trace_save+0x8c/0xc0 kernel/stacktrace.c:123
>>  kasan_save_stack+0x1b/0x40 mm/kasan/common.c:48
>>  kasan_set_track mm/kasan/common.c:56 [inline]
>>  __kasan_kmalloc.constprop.0+0xbf/0xd0 mm/kasan/common.c:461
>>  slab_post_alloc_hook mm/slab.h:517 [inline]
>>  slab_alloc mm/slab.c:3312 [inline]
>>  kmem_cache_alloc+0x13a/0x3a0 mm/slab.c:3482
>>  kmem_cache_zalloc include/linux/slab.h:656 [inline]
>>  __alloc_file+0x21/0x350 fs/file_table.c:101
>>  alloc_empty_file+0x6d/0x170 fs/file_table.c:151
>>  path_openat+0xe3/0x2730 fs/namei.c:3354
>>  do_filp_open+0x17e/0x3c0 fs/namei.c:3395
>>  do_sys_openat2+0x16d/0x420 fs/open.c:1168
>>  do_sys_open fs/open.c:1184 [inline]
>>  __do_sys_open fs/open.c:1192 [inline]
>>  __se_sys_open fs/open.c:1188 [inline]
>>  __x64_sys_open+0x119/0x1c0 fs/open.c:1188
>>  do_syscall_64+0x2d/0x70 arch/x86/entry/common.c:46
>>  entry_SYSCALL_64_after_hwframe+0x44/0xa9
> 
> Add wakeup to make sure the wait for completion will be completed.
> 
> --- a/fs/io_uring.c
> +++ b/fs/io_uring.c
> @@ -6903,6 +6903,7 @@ static int io_sqe_files_unregister(struc
>  static void io_sq_thread_stop(struct io_ring_ctx *ctx)
>  {
>  	if (ctx->sqo_thread) {
> +		wake_up_process(ctx->sqo_thread);
>  		wait_for_completion(&ctx->sq_thread_comp);
>  		/*
>  		 * The park is a bit of a work-around, without it we get

Yeah this looks reasonable, if the thread is attempted stopped if it
was created de-activated and never started.

Needs a comment to that effect. Care to add that and send it as a
properly formatted patch (with commit message, etc)?

-- 
Jens Axboe

