Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id D90AF3274C6
	for <lists+io-uring@lfdr.de>; Sun, 28 Feb 2021 23:21:32 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231495AbhB1WVc (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Sun, 28 Feb 2021 17:21:32 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:58364 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231334AbhB1WVb (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Sun, 28 Feb 2021 17:21:31 -0500
Received: from mail-pl1-x62c.google.com (mail-pl1-x62c.google.com [IPv6:2607:f8b0:4864:20::62c])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 23AC7C061756
        for <io-uring@vger.kernel.org>; Sun, 28 Feb 2021 14:20:51 -0800 (PST)
Received: by mail-pl1-x62c.google.com with SMTP id u11so8690214plg.13
        for <io-uring@vger.kernel.org>; Sun, 28 Feb 2021 14:20:51 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernel-dk.20150623.gappssmtp.com; s=20150623;
        h=subject:to:references:from:message-id:date:user-agent:mime-version
         :in-reply-to:content-language:content-transfer-encoding;
        bh=d2tTWRIqf82xDvJfwgEBICQ0OghkJ9FjaiIuaE1mNow=;
        b=aZm8dFk2SXXhWnMcJJBmRj8CvnF/vt3vxR3Ur3YHjbt1pJPTKyswPmKqYVCntM5F7Z
         MTAlJE4ee/wPBC6ImA6OwjPY3XOaOksUnp+69S5jUsgJb2se9S394to8N7iqI5ykM9HG
         wuNcOXH87drD1OFyIA8pt/BnFIfjowJn47BsVNIYrDzdSj+vllGfkdItFLHvmzkc93a/
         cxdRIczNT5M5CYtZ1clQHn7fCjNfy81BK6WQFNE5fHZO4lDg8wdzrslvfllz5UBePaVc
         fqz6+jLpuh/USmY9T1XOGfvH7GkXwn2dm5vcan7dB+HDaW49HTvwfH7lNIoCnlrFGG5Z
         t/kA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=d2tTWRIqf82xDvJfwgEBICQ0OghkJ9FjaiIuaE1mNow=;
        b=VRSj5SfymYxCH8byoAOvqx59cENomnYAzLts9HWGFnXsaIM9+lq8tR91Bh/Nr+P4AX
         EPGQX2pYMyq8WLfJ9JHoJw9NpothHDk/pbK6XJ+hscoiZ+7ZclbGaanaRK0SLb8vrVHN
         mt6lvcY+5vdbLvqJ1idb3iSBm7RcAvhd98h3bcJ/A+Ane7xy8qMPT35xdqvIMH16GvDV
         YVP+oVQAxi2IeYuy9gOkMi/KpZK45yzV67zzZym9ckL6gb1rV8Dct8TQkPYwdf/aXyOF
         Ft2WMBizewrYHlym4uxUhELdbwGHJm3gX9KOHTzCzmIL/S+iaIzyePrcclwhXyPt3CWu
         /1Cw==
X-Gm-Message-State: AOAM532MVQm9c+e2OYPFOwhwLfTDlKpiiF/lJaK27fL+KAbuGZ1KV6vA
        1Fh98BxtB2Mz91AOOSluAyjSng==
X-Google-Smtp-Source: ABdhPJzLtG73YuzB/Xt7YswlkAP2gQS+GWJSs7irKHWsQZOkC/XYycklqgiwJM1/EwRSLQCapLbLxw==
X-Received: by 2002:a17:90a:5993:: with SMTP id l19mr14328450pji.235.1614550850485;
        Sun, 28 Feb 2021 14:20:50 -0800 (PST)
Received: from [192.168.1.134] ([66.219.217.173])
        by smtp.gmail.com with ESMTPSA id ha8sm10529197pjb.6.2021.02.28.14.20.49
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Sun, 28 Feb 2021 14:20:49 -0800 (PST)
Subject: Re: INFO: task hung in io_sq_thread_park
To:     syzbot <syzbot+fb5458330b4442f2090d@syzkaller.appspotmail.com>,
        asml.silence@gmail.com, io-uring@vger.kernel.org,
        linux-kernel@vger.kernel.org, syzkaller-bugs@googlegroups.com
References: <0000000000002feb3505bc6c99ee@google.com>
From:   Jens Axboe <axboe@kernel.dk>
Message-ID: <28ff7305-945e-4566-788a-78ec3f2cd268@kernel.dk>
Date:   Sun, 28 Feb 2021 15:20:48 -0700
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.10.0
MIME-Version: 1.0
In-Reply-To: <0000000000002feb3505bc6c99ee@google.com>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org

On 2/28/21 2:58 PM, syzbot wrote:
> Hello,
> 
> syzbot found the following issue on:
> 
> HEAD commit:    d01f2f7e Add linux-next specific files for 20210226
> git tree:       linux-next
> console output: https://syzkaller.appspot.com/x/log.txt?x=1265dcead00000
> kernel config:  https://syzkaller.appspot.com/x/.config?x=a1746d2802a82a05
> dashboard link: https://syzkaller.appspot.com/bug?extid=fb5458330b4442f2090d
> syz repro:      https://syzkaller.appspot.com/x/repro.syz?x=175427f2d00000
> C reproducer:   https://syzkaller.appspot.com/x/repro.c?x=11109782d00000
> 
> IMPORTANT: if you fix the issue, please add the following tag to the commit:
> Reported-by: syzbot+fb5458330b4442f2090d@syzkaller.appspotmail.com
> 
> INFO: task syz-executor458:8401 blocked for more than 143 seconds.
>       Not tainted 5.11.0-next-20210226-syzkaller #0
> "echo 0 > /proc/sys/kernel/hung_task_timeout_secs" disables this message.
> task:syz-executor458 state:D stack:27536 pid: 8401 ppid:  8400 flags:0x00004004
> Call Trace:
>  context_switch kernel/sched/core.c:4324 [inline]
>  __schedule+0x90c/0x21a0 kernel/sched/core.c:5075
>  schedule+0xcf/0x270 kernel/sched/core.c:5154
>  schedule_timeout+0x1db/0x250 kernel/time/timer.c:1868
>  do_wait_for_common kernel/sched/completion.c:85 [inline]
>  __wait_for_common kernel/sched/completion.c:106 [inline]
>  wait_for_common kernel/sched/completion.c:117 [inline]
>  wait_for_completion+0x168/0x270 kernel/sched/completion.c:138
>  io_sq_thread_park fs/io_uring.c:7115 [inline]
>  io_sq_thread_park+0xd5/0x130 fs/io_uring.c:7103
>  io_uring_cancel_task_requests+0x24c/0xd90 fs/io_uring.c:8745
>  __io_uring_files_cancel+0x110/0x230 fs/io_uring.c:8840
>  io_uring_files_cancel include/linux/io_uring.h:47 [inline]
>  do_exit+0x299/0x2a60 kernel/exit.c:780
>  do_group_exit+0x125/0x310 kernel/exit.c:922
>  __do_sys_exit_group kernel/exit.c:933 [inline]
>  __se_sys_exit_group kernel/exit.c:931 [inline]
>  __x64_sys_exit_group+0x3a/0x50 kernel/exit.c:931
>  do_syscall_64+0x2d/0x70 arch/x86/entry/common.c:46
>  entry_SYSCALL_64_after_hwframe+0x44/0xae
> RIP: 0033:0x43e899
> RSP: 002b:00007ffe89376d48 EFLAGS: 00000246 ORIG_RAX: 00000000000000e7
> RAX: ffffffffffffffda RBX: 00000000004af2f0 RCX: 000000000043e899
> RDX: 000000000000003c RSI: 00000000000000e7 RDI: 0000000000000000
> RBP: 0000000000000000 R08: ffffffffffffffc0 R09: 0000000010000000
> R10: 0000000000008011 R11: 0000000000000246 R12: 00000000004af2f0
> R13: 0000000000000001 R14: 0000000000000000 R15: 0000000000000001
> INFO: task iou-sqp-8401:8402 can't die for more than 143 seconds.
> task:iou-sqp-8401    state:D stack:30272 pid: 8402 ppid:  8400 flags:0x00004004
> Call Trace:
>  context_switch kernel/sched/core.c:4324 [inline]
>  __schedule+0x90c/0x21a0 kernel/sched/core.c:5075
>  schedule+0xcf/0x270 kernel/sched/core.c:5154
>  schedule_timeout+0x1db/0x250 kernel/time/timer.c:1868
>  do_wait_for_common kernel/sched/completion.c:85 [inline]
>  __wait_for_common kernel/sched/completion.c:106 [inline]
>  wait_for_common kernel/sched/completion.c:117 [inline]
>  wait_for_completion+0x168/0x270 kernel/sched/completion.c:138
>  io_sq_thread+0x27d/0x1ae0 fs/io_uring.c:6717
>  ret_from_fork+0x1f/0x30 arch/x86/entry/entry_64.S:294
> INFO: task iou-sqp-8401:8402 blocked for more than 143 seconds.
>       Not tainted 5.11.0-next-20210226-syzkaller #0
> "echo 0 > /proc/sys/kernel/hung_task_timeout_secs" disables this message.
> task:iou-sqp-8401    state:D stack:30272 pid: 8402 ppid:  8400 flags:0x00004004
> Call Trace:
>  context_switch kernel/sched/core.c:4324 [inline]
>  __schedule+0x90c/0x21a0 kernel/sched/core.c:5075
>  schedule+0xcf/0x270 kernel/sched/core.c:5154
>  schedule_timeout+0x1db/0x250 kernel/time/timer.c:1868
>  do_wait_for_common kernel/sched/completion.c:85 [inline]
>  __wait_for_common kernel/sched/completion.c:106 [inline]
>  wait_for_common kernel/sched/completion.c:117 [inline]
>  wait_for_completion+0x168/0x270 kernel/sched/completion.c:138
>  io_sq_thread+0x27d/0x1ae0 fs/io_uring.c:6717
>  ret_from_fork+0x1f/0x30 arch/x86/entry/entry_64.S:294
> 
> Showing all locks held in the system:
> 1 lock held by khungtaskd/1666:
>  #0: ffffffff8bf741e0 (rcu_read_lock){....}-{1:2}, at: debug_show_all_locks+0x53/0x260 kernel/locking/lockdep.c:6327
> 1 lock held by syz-executor458/8401:
>  #0: ffff88801cafe870 (&sqd->lock){+.+.}-{3:3}, at: io_sq_thread_park+0x5d/0x130 fs/io_uring.c:7108
> 
> =============================================
> 
> NMI backtrace for cpu 0
> CPU: 0 PID: 1666 Comm: khungtaskd Not tainted 5.11.0-next-20210226-syzkaller #0
> Hardware name: Google Google Compute Engine/Google Compute Engine, BIOS Google 01/01/2011
> Call Trace:
>  __dump_stack lib/dump_stack.c:79 [inline]
>  dump_stack+0xfa/0x151 lib/dump_stack.c:120
>  nmi_cpu_backtrace.cold+0x44/0xd7 lib/nmi_backtrace.c:105
>  nmi_trigger_cpumask_backtrace+0x1b3/0x230 lib/nmi_backtrace.c:62
>  trigger_all_cpu_backtrace include/linux/nmi.h:147 [inline]
>  check_hung_uninterruptible_tasks kernel/hung_task.c:253 [inline]
>  watchdog+0xd8e/0xf40 kernel/hung_task.c:338
>  kthread+0x3b1/0x4a0 kernel/kthread.c:292
>  ret_from_fork+0x1f/0x30 arch/x86/entry/entry_64.S:294
> Sending NMI from CPU 0 to CPUs 1:
> NMI backtrace for cpu 1 skipped: idling at native_safe_halt arch/x86/include/asm/irqflags.h:51 [inline]
> NMI backtrace for cpu 1 skipped: idling at arch_safe_halt arch/x86/include/asm/irqflags.h:89 [inline]
> NMI backtrace for cpu 1 skipped: idling at acpi_safe_halt drivers/acpi/processor_idle.c:110 [inline]
> NMI backtrace for cpu 1 skipped: idling at acpi_idle_do_entry+0x1c9/0x250 drivers/acpi/processor_idle.c:516

Once for-next gets to something more recent, then this one (and others) will
be gone.

-- 
Jens Axboe

