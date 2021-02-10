Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 36A53315DA6
	for <lists+io-uring@lfdr.de>; Wed, 10 Feb 2021 04:03:11 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233310AbhBJDCJ (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Tue, 9 Feb 2021 22:02:09 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:35132 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233269AbhBJDBy (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Tue, 9 Feb 2021 22:01:54 -0500
Received: from mail-wr1-x434.google.com (mail-wr1-x434.google.com [IPv6:2a00:1450:4864:20::434])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 263C2C061574;
        Tue,  9 Feb 2021 19:01:08 -0800 (PST)
Received: by mail-wr1-x434.google.com with SMTP id g10so876426wrx.1;
        Tue, 09 Feb 2021 19:01:08 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=to:references:from:autocrypt:subject:message-id:date:user-agent
         :mime-version:in-reply-to:content-language:content-transfer-encoding;
        bh=SZpeGJBANvU2r9ZP0ZGRrtQSpmzcKHK0wPD8Lnu19CY=;
        b=veHrbQETC7YCYEy7ziAOzeqnE+2BiieIHDlr8ayrkoRt+lYFxVr1HCFcZ3F++KkwB3
         1ULLDvJXTL9s5snM5ia/DjstTjb+YbpaPjJTjG/HbyFcM5yrGYpIs48vG3NSMX+gs5Xv
         TNz7agtc4aVoln+jhr3Fx5IFW/52N0LDDGllS72/qX5tnvVuOFpcOTU7I+/ypJuKbVBI
         3r3pywjYDq+Gjk/Vcwkl/LIjAlNHPMV6x0hJPEh/ISKaJY64H5U3OJ5ZZhy6G7asiNYH
         /pm2e3ektbk0gtOGqdO91Axq7Np4vyMu92AdFEpLhStnq4T+KXBI7z6Y3jNh7RrJW8Gh
         2XKQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:to:references:from:autocrypt:subject:message-id
         :date:user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=SZpeGJBANvU2r9ZP0ZGRrtQSpmzcKHK0wPD8Lnu19CY=;
        b=tQTvuUla831qtGo5CwU+vwBX70Y3eX7aTu9ipOiNGRoJw325tovkVab4oVV7aqNEGb
         DucdGxVyKzHBL903zg9VETF6QVxo+5twhi1em3eX3oXHrEEh/t+vEFM2+zuPAHUOdMRB
         kATkIxXiVV7xLddV8SRpouqASfhH1Th9I876KIQ6mierAW106mXL11kOdXoL2tVX7lzU
         DVGGAtr0s4A1nLEU3p/l/2tFJmu+qm+bScZscJ5AfIl1t4sDLvT/zopoAY+VRyjLXTSp
         taoI1pC9vljFHW7q+MsSsrEX6k4gOc+pCnfzN5C5baKv88bFQabgJZEIBbiWyAv1f7UK
         dxHg==
X-Gm-Message-State: AOAM531KjvRX5tr0a5c1/Nwi5M42oijDDZt4wWjcbB8dEvd05Xg3Tt+N
        dwz55P3L6DZNSigBNHd4xhWv63sxS97Frg==
X-Google-Smtp-Source: ABdhPJyDw9m4/rr1t3EQkptSdY8H7wtQOgfeNk6gLSal8qXwAS2bJi9ekVsXa6Z1Lk3bIW1YPDWDcQ==
X-Received: by 2002:a5d:4ac5:: with SMTP id y5mr1089058wrs.345.1612926066670;
        Tue, 09 Feb 2021 19:01:06 -0800 (PST)
Received: from [192.168.8.191] ([148.252.132.126])
        by smtp.gmail.com with ESMTPSA id s23sm748116wmc.35.2021.02.09.19.01.05
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Tue, 09 Feb 2021 19:01:06 -0800 (PST)
To:     syzbot <syzbot+695b03d82fa8e4901b06@syzkaller.appspotmail.com>,
        axboe@kernel.dk, io-uring@vger.kernel.org,
        linux-fsdevel@vger.kernel.org, linux-kernel@vger.kernel.org,
        syzkaller-bugs@googlegroups.com, viro@zeniv.linux.org.uk
References: <00000000000075f90305baf0d732@google.com>
From:   Pavel Begunkov <asml.silence@gmail.com>
Autocrypt: addr=asml.silence@gmail.com; prefer-encrypt=mutual; keydata=
 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 bA==
Subject: Re: INFO: task hung in io_uring_cancel_task_requests
Message-ID: <4ccfa4de-b63e-10c6-786a-d745cdf22535@gmail.com>
Date:   Wed, 10 Feb 2021 02:57:20 +0000
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.3.0
MIME-Version: 1.0
In-Reply-To: <00000000000075f90305baf0d732@google.com>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org

On 10/02/2021 00:54, syzbot wrote:
> Hello,
> 
> syzbot found the following issue on:
> 
> HEAD commit:    dd86e7fa Merge tag 'pci-v5.11-fixes-2' of git://git.kernel..
> git tree:       upstream
> console output: https://syzkaller.appspot.com/x/log.txt?x=13e43f90d00000
> kernel config:  https://syzkaller.appspot.com/x/.config?x=e83e68d0a6aba5f6
> dashboard link: https://syzkaller.appspot.com/bug?extid=695b03d82fa8e4901b06
> syz repro:      https://syzkaller.appspot.com/x/repro.syz?x=1490f0d4d00000
> C reproducer:   https://syzkaller.appspot.com/x/repro.c?x=17aedf1cd00000
> 
> IMPORTANT: if you fix the issue, please add the following tag to the commit:
> Reported-by: syzbot+695b03d82fa8e4901b06@syzkaller.appspotmail.com

It looks like SQPOLL. I wonder if that's due to parked SQPOLL task that
won't be able to do task_work run, and so reap poll-cancelled requests
killed by io_put_deferred().

I'll test it out tomorrow.

> 
> INFO: task syz-executor893:8493 blocked for more than 143 seconds.
>       Not tainted 5.11.0-rc6-syzkaller #0
> "echo 0 > /proc/sys/kernel/hung_task_timeout_secs" disables this message.
> task:syz-executor893 state:D stack:28144 pid: 8493 ppid:  8480 flags:0x00000004
> Call Trace:
>  context_switch kernel/sched/core.c:4327 [inline]
>  __schedule+0x90c/0x21a0 kernel/sched/core.c:5078
>  schedule+0xcf/0x270 kernel/sched/core.c:5157
>  io_uring_cancel_files fs/io_uring.c:8912 [inline]
>  io_uring_cancel_task_requests+0xe70/0x11a0 fs/io_uring.c:8979
>  __io_uring_files_cancel+0x110/0x1b0 fs/io_uring.c:9067
>  io_uring_files_cancel include/linux/io_uring.h:51 [inline]
>  do_exit+0x2fe/0x2ae0 kernel/exit.c:780
>  do_group_exit+0x125/0x310 kernel/exit.c:922
>  __do_sys_exit_group kernel/exit.c:933 [inline]
>  __se_sys_exit_group kernel/exit.c:931 [inline]
>  __x64_sys_exit_group+0x3a/0x50 kernel/exit.c:931
>  do_syscall_64+0x2d/0x70 arch/x86/entry/common.c:46
>  entry_SYSCALL_64_after_hwframe+0x44/0xa9
> RIP: 0033:0x43eb19
> RSP: 002b:00007ffda99d64d8 EFLAGS: 00000246 ORIG_RAX: 00000000000000e7
> RAX: ffffffffffffffda RBX: 00000000004b02f0 RCX: 000000000043eb19
> RDX: 000000000000003c RSI: 00000000000000e7 RDI: 0000000000000000
> RBP: 0000000000000000 R08: ffffffffffffffc0 R09: 0000000010000000
> R10: 0000000000008011 R11: 0000000000000246 R12: 00000000004b02f0
> R13: 0000000000000001 R14: 0000000000000000 R15: 0000000000000001
> INFO: task syz-executor893:8571 blocked for more than 143 seconds.
>       Not tainted 5.11.0-rc6-syzkaller #0
> "echo 0 > /proc/sys/kernel/hung_task_timeout_secs" disables this message.
> task:syz-executor893 state:D stack:28144 pid: 8571 ppid:  8479 flags:0x00004004
> Call Trace:
>  context_switch kernel/sched/core.c:4327 [inline]
>  __schedule+0x90c/0x21a0 kernel/sched/core.c:5078
>  schedule+0xcf/0x270 kernel/sched/core.c:5157
>  io_uring_cancel_files fs/io_uring.c:8912 [inline]
>  io_uring_cancel_task_requests+0xe70/0x11a0 fs/io_uring.c:8979
>  __io_uring_files_cancel+0x110/0x1b0 fs/io_uring.c:9067
>  io_uring_files_cancel include/linux/io_uring.h:51 [inline]
>  do_exit+0x2fe/0x2ae0 kernel/exit.c:780
>  do_group_exit+0x125/0x310 kernel/exit.c:922
>  __do_sys_exit_group kernel/exit.c:933 [inline]
>  __se_sys_exit_group kernel/exit.c:931 [inline]
>  __x64_sys_exit_group+0x3a/0x50 kernel/exit.c:931
>  do_syscall_64+0x2d/0x70 arch/x86/entry/common.c:46
>  entry_SYSCALL_64_after_hwframe+0x44/0xa9
> RIP: 0033:0x43eb19
> RSP: 002b:00007ffda99d64d8 EFLAGS: 00000246 ORIG_RAX: 00000000000000e7
> RAX: ffffffffffffffda RBX: 00000000004b02f0 RCX: 000000000043eb19
> RDX: 000000000000003c RSI: 00000000000000e7 RDI: 0000000000000000
> RBP: 0000000000000000 R08: ffffffffffffffc0 R09: 0000000010000000
> R10: 0000000000008011 R11: 0000000000000246 R12: 00000000004b02f0
> R13: 0000000000000001 R14: 0000000000000000 R15: 0000000000000001
> INFO: task syz-executor893:8579 blocked for more than 143 seconds.
>       Not tainted 5.11.0-rc6-syzkaller #0
> "echo 0 > /proc/sys/kernel/hung_task_timeout_secs" disables this message.
> task:syz-executor893 state:D stack:28144 pid: 8579 ppid:  8482 flags:0x00004004
> Call Trace:
>  context_switch kernel/sched/core.c:4327 [inline]
>  __schedule+0x90c/0x21a0 kernel/sched/core.c:5078
>  schedule+0xcf/0x270 kernel/sched/core.c:5157
>  io_uring_cancel_files fs/io_uring.c:8912 [inline]
>  io_uring_cancel_task_requests+0xe70/0x11a0 fs/io_uring.c:8979
>  __io_uring_files_cancel+0x110/0x1b0 fs/io_uring.c:9067
>  io_uring_files_cancel include/linux/io_uring.h:51 [inline]
>  do_exit+0x2fe/0x2ae0 kernel/exit.c:780
>  do_group_exit+0x125/0x310 kernel/exit.c:922
>  __do_sys_exit_group kernel/exit.c:933 [inline]
>  __se_sys_exit_group kernel/exit.c:931 [inline]
>  __x64_sys_exit_group+0x3a/0x50 kernel/exit.c:931
>  do_syscall_64+0x2d/0x70 arch/x86/entry/common.c:46
>  entry_SYSCALL_64_after_hwframe+0x44/0xa9
> RIP: 0033:0x43eb19
> RSP: 002b:00007ffda99d64d8 EFLAGS: 00000246 ORIG_RAX: 00000000000000e7
> RAX: ffffffffffffffda RBX: 00000000004b02f0 RCX: 000000000043eb19
> RDX: 000000000000003c RSI: 00000000000000e7 RDI: 0000000000000000
> RBP: 0000000000000000 R08: ffffffffffffffc0 R09: 0000000010000000
> R10: 0000000000008011 R11: 0000000000000246 R12: 00000000004b02f0
> R13: 0000000000000001 R14: 0000000000000000 R15: 0000000000000001
> INFO: task syz-executor893:8591 blocked for more than 143 seconds.
>       Not tainted 5.11.0-rc6-syzkaller #0
> "echo 0 > /proc/sys/kernel/hung_task_timeout_secs" disables this message.
> task:syz-executor893 state:D stack:28144 pid: 8591 ppid:  8481 flags:0x00000004
> Call Trace:
>  context_switch kernel/sched/core.c:4327 [inline]
>  __schedule+0x90c/0x21a0 kernel/sched/core.c:5078
>  schedule+0xcf/0x270 kernel/sched/core.c:5157
>  io_uring_cancel_files fs/io_uring.c:8912 [inline]
>  io_uring_cancel_task_requests+0xe70/0x11a0 fs/io_uring.c:8979
>  __io_uring_files_cancel+0x110/0x1b0 fs/io_uring.c:9067
>  io_uring_files_cancel include/linux/io_uring.h:51 [inline]
>  do_exit+0x2fe/0x2ae0 kernel/exit.c:780
>  do_group_exit+0x125/0x310 kernel/exit.c:922
>  __do_sys_exit_group kernel/exit.c:933 [inline]
>  __se_sys_exit_group kernel/exit.c:931 [inline]
>  __x64_sys_exit_group+0x3a/0x50 kernel/exit.c:931
>  do_syscall_64+0x2d/0x70 arch/x86/entry/common.c:46
>  entry_SYSCALL_64_after_hwframe+0x44/0xa9
> RIP: 0033:0x43eb19
> RSP: 002b:00007ffda99d64d8 EFLAGS: 00000246 ORIG_RAX: 00000000000000e7
> RAX: ffffffffffffffda RBX: 00000000004b02f0 RCX: 000000000043eb19
> RDX: 000000000000003c RSI: 00000000000000e7 RDI: 0000000000000000
> RBP: 0000000000000000 R08: ffffffffffffffc0 R09: 0000000010000000
> R10: 0000000000008011 R11: 0000000000000246 R12: 00000000004b02f0
> R13: 0000000000000001 R14: 0000000000000000 R15: 0000000000000001
> INFO: task syz-executor893:8624 blocked for more than 144 seconds.
>       Not tainted 5.11.0-rc6-syzkaller #0
> "echo 0 > /proc/sys/kernel/hung_task_timeout_secs" disables this message.
> task:syz-executor893 state:D stack:28144 pid: 8624 ppid:  8477 flags:0x00004004
> Call Trace:
>  context_switch kernel/sched/core.c:4327 [inline]
>  __schedule+0x90c/0x21a0 kernel/sched/core.c:5078
>  schedule+0xcf/0x270 kernel/sched/core.c:5157
>  io_uring_cancel_files fs/io_uring.c:8912 [inline]
>  io_uring_cancel_task_requests+0xe70/0x11a0 fs/io_uring.c:8979
>  __io_uring_files_cancel+0x110/0x1b0 fs/io_uring.c:9067
>  io_uring_files_cancel include/linux/io_uring.h:51 [inline]
>  do_exit+0x2fe/0x2ae0 kernel/exit.c:780
>  do_group_exit+0x125/0x310 kernel/exit.c:922
>  __do_sys_exit_group kernel/exit.c:933 [inline]
>  __se_sys_exit_group kernel/exit.c:931 [inline]
>  __x64_sys_exit_group+0x3a/0x50 kernel/exit.c:931
>  do_syscall_64+0x2d/0x70 arch/x86/entry/common.c:46
>  entry_SYSCALL_64_after_hwframe+0x44/0xa9
> RIP: 0033:0x43eb19
> RSP: 002b:00007ffda99d64d8 EFLAGS: 00000246 ORIG_RAX: 00000000000000e7
> RAX: ffffffffffffffda RBX: 00000000004b02f0 RCX: 000000000043eb19
> RDX: 000000000000003c RSI: 00000000000000e7 RDI: 0000000000000000
> RBP: 0000000000000000 R08: ffffffffffffffc0 R09: 0000000010000000
> R10: 0000000000008011 R11: 0000000000000246 R12: 00000000004b02f0
> R13: 0000000000000001 R14: 0000000000000000 R15: 0000000000000001
> INFO: task syz-executor893:8633 blocked for more than 144 seconds.
>       Not tainted 5.11.0-rc6-syzkaller #0
> "echo 0 > /proc/sys/kernel/hung_task_timeout_secs" disables this message.
> task:syz-executor893 state:D stack:27648 pid: 8633 ppid:  8478 flags:0x00004004
> Call Trace:
>  context_switch kernel/sched/core.c:4327 [inline]
>  __schedule+0x90c/0x21a0 kernel/sched/core.c:5078
>  schedule+0xcf/0x270 kernel/sched/core.c:5157
>  io_uring_cancel_files fs/io_uring.c:8912 [inline]
>  io_uring_cancel_task_requests+0xe70/0x11a0 fs/io_uring.c:8979
>  __io_uring_files_cancel+0x110/0x1b0 fs/io_uring.c:9067
>  io_uring_files_cancel include/linux/io_uring.h:51 [inline]
>  do_exit+0x2fe/0x2ae0 kernel/exit.c:780
>  do_group_exit+0x125/0x310 kernel/exit.c:922
>  __do_sys_exit_group kernel/exit.c:933 [inline]
>  __se_sys_exit_group kernel/exit.c:931 [inline]
>  __x64_sys_exit_group+0x3a/0x50 kernel/exit.c:931
>  do_syscall_64+0x2d/0x70 arch/x86/entry/common.c:46
>  entry_SYSCALL_64_after_hwframe+0x44/0xa9
> RIP: 0033:0x43eb19
> RSP: 002b:00007ffda99d64d8 EFLAGS: 00000246 ORIG_RAX: 00000000000000e7
> RAX: ffffffffffffffda RBX: 00000000004b02f0 RCX: 000000000043eb19
> RDX: 000000000000003c RSI: 00000000000000e7 RDI: 0000000000000000
> RBP: 0000000000000000 R08: ffffffffffffffc0 R09: 0000000010000000
> R10: 0000000000008011 R11: 0000000000000246 R12: 00000000004b02f0
> R13: 0000000000000001 R14: 0000000000000000 R15: 0000000000000001
> 
> Showing all locks held in the system:
> 1 lock held by khungtaskd/1638:
>  #0: ffffffff8bd73da0 (rcu_read_lock){....}-{1:2}, at: debug_show_all_locks+0x53/0x260 kernel/locking/lockdep.c:6259
> 2 locks held by in:imklog/8193:
>  #0: ffff888019c15bb0 (&f->f_pos_lock){+.+.}-{3:3}, at: __fdget_pos+0xe9/0x100 fs/file.c:947
>  #1: ffffffff8bd73da0 (rcu_read_lock){....}-{1:2}, at: is_bpf_text_address+0x0/0x160 kernel/bpf/core.c:687
> 1 lock held by syz-executor893/8493:
>  #0: ffff88801362dc70 (&sqd->lock){+.+.}-{3:3}, at: io_sq_thread_park fs/io_uring.c:7468 [inline]
>  #0: ffff88801362dc70 (&sqd->lock){+.+.}-{3:3}, at: io_sq_thread_park fs/io_uring.c:7463 [inline]
>  #0: ffff88801362dc70 (&sqd->lock){+.+.}-{3:3}, at: io_uring_cancel_task_requests+0x311/0x11a0 fs/io_uring.c:8973
> 1 lock held by syz-executor893/8571:
>  #0: ffff8880232b3470 (&sqd->lock){+.+.}-{3:3}, at: io_sq_thread_park fs/io_uring.c:7468 [inline]
>  #0: ffff8880232b3470 (&sqd->lock){+.+.}-{3:3}, at: io_sq_thread_park fs/io_uring.c:7463 [inline]
>  #0: ffff8880232b3470 (&sqd->lock){+.+.}-{3:3}, at: io_uring_cancel_task_requests+0x311/0x11a0 fs/io_uring.c:8973
> 1 lock held by syz-executor893/8579:
>  #0: ffff888014271070 (&sqd->lock){+.+.}-{3:3}, at: io_sq_thread_park fs/io_uring.c:7468 [inline]
>  #0: ffff888014271070 (&sqd->lock){+.+.}-{3:3}, at: io_sq_thread_park fs/io_uring.c:7463 [inline]
>  #0: ffff888014271070 (&sqd->lock){+.+.}-{3:3}, at: io_uring_cancel_task_requests+0x311/0x11a0 fs/io_uring.c:8973
> 1 lock held by syz-executor893/8591:
>  #0: ffff8880195b2470 (&sqd->lock){+.+.}-{3:3}, at: io_sq_thread_park fs/io_uring.c:7468 [inline]
>  #0: ffff8880195b2470 (&sqd->lock){+.+.}-{3:3}, at: io_sq_thread_park fs/io_uring.c:7463 [inline]
>  #0: ffff8880195b2470 (&sqd->lock){+.+.}-{3:3}, at: io_uring_cancel_task_requests+0x311/0x11a0 fs/io_uring.c:8973
> 1 lock held by syz-executor893/8624:
>  #0: ffff8880161a4870 (&sqd->lock){+.+.}-{3:3}, at: io_sq_thread_park fs/io_uring.c:7468 [inline]
>  #0: ffff8880161a4870 (&sqd->lock){+.+.}-{3:3}, at: io_sq_thread_park fs/io_uring.c:7463 [inline]
>  #0: ffff8880161a4870 (&sqd->lock){+.+.}-{3:3}, at: io_uring_cancel_task_requests+0x311/0x11a0 fs/io_uring.c:8973
> 1 lock held by syz-executor893/8633:
>  #0: ffff888025448c70 (&sqd->lock){+.+.}-{3:3}, at: io_sq_thread_park fs/io_uring.c:7468 [inline]
>  #0: ffff888025448c70 (&sqd->lock){+.+.}-{3:3}, at: io_sq_thread_park fs/io_uring.c:7463 [inline]
>  #0: ffff888025448c70 (&sqd->lock){+.+.}-{3:3}, at: io_uring_cancel_task_requests+0x311/0x11a0 fs/io_uring.c:8973
> 
> =============================================
> 
> NMI backtrace for cpu 0
> CPU: 0 PID: 1638 Comm: khungtaskd Not tainted 5.11.0-rc6-syzkaller #0
> Hardware name: Google Google Compute Engine/Google Compute Engine, BIOS Google 01/01/2011
> Call Trace:
>  __dump_stack lib/dump_stack.c:79 [inline]
>  dump_stack+0x107/0x163 lib/dump_stack.c:120
>  nmi_cpu_backtrace.cold+0x44/0xd7 lib/nmi_backtrace.c:105
>  nmi_trigger_cpumask_backtrace+0x1b3/0x230 lib/nmi_backtrace.c:62
>  trigger_all_cpu_backtrace include/linux/nmi.h:146 [inline]
>  check_hung_uninterruptible_tasks kernel/hung_task.c:209 [inline]
>  watchdog+0xd43/0xfa0 kernel/hung_task.c:294
>  kthread+0x3b1/0x4a0 kernel/kthread.c:292
>  ret_from_fork+0x1f/0x30 arch/x86/entry/entry_64.S:296
> Sending NMI from CPU 0 to CPUs 1:
> NMI backtrace for cpu 1
> CPU: 1 PID: 4885 Comm: systemd-journal Not tainted 5.11.0-rc6-syzkaller #0
> Hardware name: Google Google Compute Engine/Google Compute Engine, BIOS Google 01/01/2011
> RIP: 0010:latch_tree_find include/linux/rbtree_latch.h:209 [inline]
> RIP: 0010:bpf_ksym_find+0x6a/0x1c0 kernel/bpf/core.c:667
> Code: 68 ff ff ff 48 89 ef 4c 89 fe e8 41 66 f4 ff 4c 39 fd 0f 83 e9 00 00 00 e8 c3 5e f4 ff 8b 1d ad 7e 22 0a 44 8b 74 24 04 89 de <44> 89 f7 e8 ae 65 f4 ff 41 39 de 0f 84 e3 00 00 00 e8 a0 5e f4 ff
> RSP: 0018:ffffc90001207aa0 EFLAGS: 00000093
> RAX: 0000000000000000 RBX: 0000000000000000 RCX: 0000000000000000
> RDX: ffff888015d6a200 RSI: 0000000000000000 RDI: ffffffff8ba0f3b0
> RBP: 00007fb450c54840 R08: 0000000000000000 R09: 0000000000000001
> R10: ffffffff817ec8c7 R11: 0000000000000000 R12: 0000000000000000
> R13: dffffc0000000000 R14: 0000000000000000 R15: 0000000000000200
> FS:  00007fb4516c58c0(0000) GS:ffff8880b9d00000(0000) knlGS:0000000000000000
> CS:  0010 DS: 0000 ES: 0000 CR0: 0000000080050033
> CR2: 00007fb44eab7000 CR3: 0000000015593000 CR4: 00000000001506e0
> DR0: 0000000000000000 DR1: 0000000000000000 DR2: 0000000000000000
> DR3: 0000000000000000 DR6: 00000000fffe0ff0 DR7: 0000000000000400
> Call Trace:
>  is_bpf_text_address+0x75/0x160 kernel/bpf/core.c:701
>  kernel_text_address kernel/extable.c:151 [inline]
>  kernel_text_address+0xbd/0xf0 kernel/extable.c:120
>  __kernel_text_address+0x9/0x30 kernel/extable.c:105
>  unwind_get_return_address arch/x86/kernel/unwind_orc.c:318 [inline]
>  unwind_get_return_address+0x51/0x90 arch/x86/kernel/unwind_orc.c:313
>  arch_stack_walk+0x93/0xe0 arch/x86/kernel/stacktrace.c:26
>  stack_trace_save+0x8c/0xc0 kernel/stacktrace.c:121
>  kasan_save_stack+0x1b/0x40 mm/kasan/common.c:38
>  kasan_record_aux_stack+0x87/0xb0 mm/kasan/generic.c:344
>  __call_rcu kernel/rcu/tree.c:2965 [inline]
>  call_rcu+0xbb/0x700 kernel/rcu/tree.c:3038
>  task_work_run+0xdd/0x190 kernel/task_work.c:140
>  tracehook_notify_resume include/linux/tracehook.h:189 [inline]
>  exit_to_user_mode_loop kernel/entry/common.c:174 [inline]
>  exit_to_user_mode_prepare+0x249/0x250 kernel/entry/common.c:201
>  __syscall_exit_to_user_mode_work kernel/entry/common.c:291 [inline]
>  syscall_exit_to_user_mode+0x19/0x50 kernel/entry/common.c:302
>  entry_SYSCALL_64_after_hwframe+0x44/0xa9
> RIP: 0033:0x7fb450c54840
> Code: 73 01 c3 48 8b 0d 68 77 20 00 f7 d8 64 89 01 48 83 c8 ff c3 66 0f 1f 44 00 00 83 3d 89 bb 20 00 00 75 10 b8 02 00 00 00 0f 05 <48> 3d 01 f0 ff ff 73 31 c3 48 83 ec 08 e8 1e f6 ff ff 48 89 04 24
> RSP: 002b:00007ffd66c13138 EFLAGS: 00000246 ORIG_RAX: 0000000000000002
> RAX: fffffffffffffffe RBX: 00007ffd66c13440 RCX: 00007fb450c54840
> RDX: 00000000000001a0 RSI: 0000000000080042 RDI: 000055b07430c150
> RBP: 000000000000000d R08: 000000000000ffc0 R09: 00000000ffffffff
> R10: 0000000000000069 R11: 0000000000000246 R12: 00000000ffffffff
> R13: 000055b0742fe060 R14: 00007ffd66c13400 R15: 000055b07430c1a0
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
