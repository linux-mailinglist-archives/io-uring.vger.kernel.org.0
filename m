Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id E40664808D3
	for <lists+io-uring@lfdr.de>; Tue, 28 Dec 2021 12:35:55 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229823AbhL1Lfy (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Tue, 28 Dec 2021 06:35:54 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:46282 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229490AbhL1Lfy (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Tue, 28 Dec 2021 06:35:54 -0500
Received: from mail-wr1-x429.google.com (mail-wr1-x429.google.com [IPv6:2a00:1450:4864:20::429])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 96CDCC061574;
        Tue, 28 Dec 2021 03:35:53 -0800 (PST)
Received: by mail-wr1-x429.google.com with SMTP id q16so37816139wrg.7;
        Tue, 28 Dec 2021 03:35:53 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=message-id:date:mime-version:user-agent:subject:content-language:to
         :references:from:in-reply-to:content-transfer-encoding;
        bh=1uJa5vI+v/N2e6VTMA8oApsiGZBcTkfP9ylNai8lMQ4=;
        b=oxK12rp6SkqFa53JA94zhguFw30FDYdw6tDReSJaeyZTYJiGseKxDuIvrrw6LopUCb
         QGSbvDUSBppFecQo4NX+HMXHO+6Y7J2qA3/PXee1YdDKAxfRcCsbJbHXm6O7d6/6xSr2
         BCCGFfBSR2fZOR6cH89P5COzMDpysP5x8F/tK91QNi1CRao4ep6MvoPHEC4TFUEIqgXb
         LrDIkANluXaLp0OViJENIxZRJTecoK9gZzmuwdE8cjlRLXwJymvu1tYbcgKcJVbG/IqT
         3+i9UWFEwGN2iv8NWgemeH+2wjZYJp7AA9NsghMyPpqM49INpdhEVAes+y/or9esqIC7
         GXIQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:message-id:date:mime-version:user-agent:subject
         :content-language:to:references:from:in-reply-to
         :content-transfer-encoding;
        bh=1uJa5vI+v/N2e6VTMA8oApsiGZBcTkfP9ylNai8lMQ4=;
        b=DM89u/iZTxlxFI+Ne9bnfTsGDPc89zKRQkPUJ44gurouwbTwxqAn5uK3ih/dSs028e
         gpKnjHtBZnJ4SjmWn6OmgW/2mZHSLlslbepJystVIVAyUULPOe09L/8x2PijdRUfFUor
         vsX4C65fI7gSUPHwwxygTFhIMHTYae9yj3t0r7Kx/MkLUnqOfY+3Oe+RtKsWKWwb9OGZ
         s7PP71rwsKrlW0rhIMScsXYxQiHb0iq6vtC8mH976s9Z/4xe7t6LQwP/BbFW784HWquF
         n91IpmxfwSHSze21UccGrOW/TBGR3ocEDOE2kECgx/B/b8BvRcBMb4D288yHgcaI/Mo2
         pwKw==
X-Gm-Message-State: AOAM533BE7vBqIl3sjLl5NLpr1vRS4v5Dxdp0zCywINlVJ4WpLuxII9P
        WwhXb+uO8wNaoWtH636EltA+3YgeKPY=
X-Google-Smtp-Source: ABdhPJwhCa9r8MPUjmuARPJViArfcb+NkXN3iGLogtqaNdOd+pW8MzOOXUBH3q6nbxBvJEa3IdaBug==
X-Received: by 2002:a05:6000:1188:: with SMTP id g8mr7990627wrx.134.1640691352141;
        Tue, 28 Dec 2021 03:35:52 -0800 (PST)
Received: from [192.168.8.198] ([148.252.128.140])
        by smtp.gmail.com with ESMTPSA id p62sm18088485wmp.10.2021.12.28.03.35.51
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Tue, 28 Dec 2021 03:35:51 -0800 (PST)
Message-ID: <e1f63836-704f-c24c-a029-10dcf6f47a41@gmail.com>
Date:   Tue, 28 Dec 2021 11:34:18 +0000
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:91.0) Gecko/20100101
 Thunderbird/91.4.0
Subject: Re: [syzbot] INFO: task hung in io_uring_release (2)
Content-Language: en-US
To:     syzbot <syzbot+f4dee1c474a6e3f68100@syzkaller.appspotmail.com>,
        axboe@kernel.dk, io-uring@vger.kernel.org,
        linux-kernel@vger.kernel.org, syzkaller-bugs@googlegroups.com
References: <000000000000ed500e05d4257b54@google.com>
From:   Pavel Begunkov <asml.silence@gmail.com>
In-Reply-To: <000000000000ed500e05d4257b54@google.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org

On 12/27/21 19:12, syzbot wrote:
> Hello,
> 
> syzbot found the following issue on:
> 
> HEAD commit:    bc491fb12513 Merge tag 'fixes-2021-12-22' of git://git.ker..
> git tree:       upstream
> console output: https://syzkaller.appspot.com/x/log.txt?x=165b1a5db00000
> kernel config:  https://syzkaller.appspot.com/x/.config?x=6104739ac5f067ea
> dashboard link: https://syzkaller.appspot.com/bug?extid=f4dee1c474a6e3f68100
> compiler:       Debian clang version 11.0.1-2, GNU ld (GNU Binutils for Debian) 2.35.2
> 
> Unfortunately, I don't have any reproducer for this issue yet.
> 
> IMPORTANT: if you fix the issue, please add the following tag to the commit:
> Reported-by: syzbot+f4dee1c474a6e3f68100@syzkaller.appspotmail.com

Neither io_uring_release() nor io_uring_del_tctx_node() can take
->uring_lock and so hung. Apparently, the lock is held by

1 lock held by syz-executor.2/8302:
   #0: ffff88801de6e0a8 (&ctx->uring_lock){+.+.}-{3:3}, at: tctx_task_work+0x2e5/0x560 fs/io_uring.c:2242


The most likely scenario is that some lower layer doesn't honour
NOWAIT/NOBLOCK flags/etc. E.g. I'd guess it can happen with
io_uring using O_NONBLOCK pipes.

Also possible that tctx_task_work() screwed locking somehow, but
it's 5.16 and related bits shouldn't have been changed for a couple
of releases and so less likely.

Would be lovely to find a repro and/or see what ops were issued/etc.


> INFO: task syz-executor.2:8284 blocked for more than 143 seconds.
>        Not tainted 5.16.0-rc6-syzkaller #0
> "echo 0 > /proc/sys/kernel/hung_task_timeout_secs" disables this message.
> task:syz-executor.2  state:D stack:26704 pid: 8284 ppid:  3729 flags:0x00004004
> Call Trace:
>   <TASK>
>   context_switch kernel/sched/core.c:4972 [inline]
>   __schedule+0xb72/0x1460 kernel/sched/core.c:6253
>   schedule+0x12b/0x1f0 kernel/sched/core.c:6326
>   schedule_preempt_disabled+0xf/0x20 kernel/sched/core.c:6385
>   __mutex_lock_common+0xd1f/0x2590 kernel/locking/mutex.c:680
>   __mutex_lock kernel/locking/mutex.c:740 [inline]
>   mutex_lock_nested+0x1a/0x20 kernel/locking/mutex.c:792
>   io_ring_ctx_wait_and_kill+0xa0/0x36a fs/io_uring.c:9565
>   io_uring_release+0x59/0x63 fs/io_uring.c:9594
>   __fput+0x3fc/0x870 fs/file_table.c:280
>   task_work_run+0x146/0x1c0 kernel/task_work.c:164
>   tracehook_notify_resume include/linux/tracehook.h:189 [inline]
>   exit_to_user_mode_loop kernel/entry/common.c:175 [inline]
>   exit_to_user_mode_prepare+0x209/0x220 kernel/entry/common.c:207
>   __syscall_exit_to_user_mode_work kernel/entry/common.c:289 [inline]
>   syscall_exit_to_user_mode+0x2e/0x70 kernel/entry/common.c:300
>   do_syscall_64+0x53/0xd0 arch/x86/entry/common.c:86
>   entry_SYSCALL_64_after_hwframe+0x44/0xae
> RIP: 0033:0x7f7b18378adb
> RSP: 002b:00007ffe8c741150 EFLAGS: 00000293 ORIG_RAX: 0000000000000003
> RAX: 0000000000000000 RBX: 0000000000000004 RCX: 00007f7b18378adb
> RDX: 0000001b2cc20000 RSI: 0000000000000000 RDI: 0000000000000003
> RBP: 00007f7b184da960 R08: 0000000000000000 R09: 0000000000000010
> R10: 00007ffe8c76b0b8 R11: 0000000000000293 R12: 000000000007cb81
> R13: 00007f7b184dfb50 R14: 00007f7b184d9370 R15: 0000000000000005
>   </TASK>
> INFO: task syz-executor.2:8285 blocked for more than 143 seconds.
>        Not tainted 5.16.0-rc6-syzkaller #0
> "echo 0 > /proc/sys/kernel/hung_task_timeout_secs" disables this message.
> task:syz-executor.2  state:D stack:23728 pid: 8285 ppid:  3729 flags:0x00004004
> Call Trace:
>   <TASK>
>   context_switch kernel/sched/core.c:4972 [inline]
>   __schedule+0xb72/0x1460 kernel/sched/core.c:6253
>   schedule+0x12b/0x1f0 kernel/sched/core.c:6326
>   schedule_preempt_disabled+0xf/0x20 kernel/sched/core.c:6385
>   __mutex_lock_common+0xd1f/0x2590 kernel/locking/mutex.c:680
>   __mutex_lock kernel/locking/mutex.c:740 [inline]
>   mutex_lock_nested+0x1a/0x20 kernel/locking/mutex.c:792
>   io_uring_del_tctx_node+0xe4/0x2a9 fs/io_uring.c:9777
>   io_uring_clean_tctx+0x192/0x1d5 fs/io_uring.c:9793
>   io_uring_cancel_generic+0x629/0x671 fs/io_uring.c:9884
>   io_uring_files_cancel include/linux/io_uring.h:16 [inline]
>   do_exit+0x281/0x24f0 kernel/exit.c:787
>   do_group_exit+0x168/0x2d0 kernel/exit.c:929
>   get_signal+0x1740/0x2120 kernel/signal.c:2852
>   arch_do_signal_or_restart+0x9c/0x730 arch/x86/kernel/signal.c:868
>   handle_signal_work kernel/entry/common.c:148 [inline]
>   exit_to_user_mode_loop kernel/entry/common.c:172 [inline]
>   exit_to_user_mode_prepare+0x191/0x220 kernel/entry/common.c:207
>   __syscall_exit_to_user_mode_work kernel/entry/common.c:289 [inline]
>   syscall_exit_to_user_mode+0x2e/0x70 kernel/entry/common.c:300
>   do_syscall_64+0x53/0xd0 arch/x86/entry/common.c:86
>   entry_SYSCALL_64_after_hwframe+0x44/0xae
> RIP: 0033:0x7f7b183c5e99
> RSP: 002b:00007f7b16d3b218 EFLAGS: 00000246 ORIG_RAX: 00000000000000ca
> RAX: fffffffffffffe00 RBX: 00007f7b184d8f68 RCX: 00007f7b183c5e99
> RDX: 0000000000000000 RSI: 0000000000000080 RDI: 00007f7b184d8f68
> RBP: 00007f7b184d8f60 R08: 0000000000000000 R09: 0000000000000000
> R10: 0000000000000000 R11: 0000000000000246 R12: 00007f7b184d8f6c
> R13: 00007ffe8c7410ef R14: 00007f7b16d3b300 R15: 0000000000022000
>   </TASK>
> 
> Showing all locks held in the system:
> 1 lock held by khungtaskd/27:
>   #0: ffffffff8cb1de00 (rcu_read_lock){....}-{1:2}, at: rcu_lock_acquire+0x0/0x30
> 2 locks held by getty/3280:
>   #0: ffff88807f219098 (&tty->ldisc_sem){++++}-{0:0}, at: tty_ldisc_ref_wait+0x21/0x70 drivers/tty/tty_ldisc.c:252
>   #1: ffffc90002b962e8 (&ldata->atomic_read_lock){+.+.}-{3:3}, at: n_tty_read+0x6c5/0x1c60 drivers/tty/n_tty.c:2113
> 1 lock held by syz-executor.2/8284:
>   #0: ffff88801de6e0a8 (&ctx->uring_lock){+.+.}-{3:3}, at: io_ring_ctx_wait_and_kill+0xa0/0x36a fs/io_uring.c:9565
> 1 lock held by syz-executor.2/8285:
>   #0: ffff88801de6e0a8 (&ctx->uring_lock){+.+.}-{3:3}, at: io_uring_del_tctx_node+0xe4/0x2a9 fs/io_uring.c:9777
> 1 lock held by syz-executor.2/8302:
>   #0: ffff88801de6e0a8 (&ctx->uring_lock){+.+.}-{3:3}, at: tctx_task_work+0x2e5/0x560 fs/io_uring.c:2242
> 
[...]
-- 
Pavel Begunkov
