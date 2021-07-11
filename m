Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 75EEC3C3D18
	for <lists+io-uring@lfdr.de>; Sun, 11 Jul 2021 15:54:21 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232907AbhGKN5E (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Sun, 11 Jul 2021 09:57:04 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:34614 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231658AbhGKN5D (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Sun, 11 Jul 2021 09:57:03 -0400
Received: from mail-io1-xd36.google.com (mail-io1-xd36.google.com [IPv6:2607:f8b0:4864:20::d36])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 515AAC0613DD
        for <io-uring@vger.kernel.org>; Sun, 11 Jul 2021 06:54:17 -0700 (PDT)
Received: by mail-io1-xd36.google.com with SMTP id x10so95889ion.9
        for <io-uring@vger.kernel.org>; Sun, 11 Jul 2021 06:54:17 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernel-dk.20150623.gappssmtp.com; s=20150623;
        h=subject:to:references:from:message-id:date:user-agent:mime-version
         :in-reply-to:content-language:content-transfer-encoding;
        bh=/YvtWPTJ/Sigm91P10YlQHwW65x9ity0qL45ceSgdKk=;
        b=iPNutmJnLXLrwwKl3+eHeJw0m/JtLIMKQG/fnmhIPi4acO7onTqbJnzX5ZicROFtuS
         725KyfWn8YWQKsGb3DFmuHFoVArpWd09AYG1J72UgovKOSV0n3lLOS/mEndRiwFRAava
         2X6IVCIb2/I+5QxVwM60Ip4TIoSXBLEv5nZ4a4Lf/iQQkxadYMUiRCPsL8MEQO0dx3Qm
         5Yj9swtUrLR8p0uxaT6uYrEa1tGMOKzTQIyk/WkPubtnUtxiTMCgxdyoUvnwXA0hnZeb
         uy1nnF/JbbG37wcELDYRRXeKXs1is6uYf9vIT1lA9dKu3/d5iR0/q7jsAYuly5RRE6wi
         2iIA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=/YvtWPTJ/Sigm91P10YlQHwW65x9ity0qL45ceSgdKk=;
        b=Ox+oQl6IF5aA1TtkkJThYq6hZiuCuTPhVQCgqujtzePB0lnQPF7ePbiI5vUJrGEwnI
         SAgKD9XMgprywTKyaM2EHRxJ/vq0RyQfsZUdzjPhl4uS3G+tmZZ09mBZ5cQFW1+pGefY
         uT06TAM6pRfMjeiB06vowfU0lM4eq2T2ntCL75FGoIqDyXUr+d/rfIFzs1wfOyCY+SmP
         j2LDeKDuPbm46LiRbB5mjo7eh3r9LbuREVgXj7XeiG5tQRcXlULTlSB6xG8UGnto60uY
         pbEXAKhv6RTtDx3FoYPqoeG+WtaAbR7dd2QZe/Oad86n/VL5MJnUHMOiMc0btc0Her0P
         0blA==
X-Gm-Message-State: AOAM533fhIsYxE7LBzEmbWQFZVB52W3Rf4ygPbzHqBF7/Lrzs51WTWAM
        XjoN0t8bLTtfPDacopErttnj6w==
X-Google-Smtp-Source: ABdhPJy7pDUFMoPB6r1+9pQY5PZ0DttVp7+4GJ0tDVw6llrCi88gvq4EOetqVa9aKUnvCt62S9DrVQ==
X-Received: by 2002:a5d:928f:: with SMTP id s15mr7925042iom.142.1626011656603;
        Sun, 11 Jul 2021 06:54:16 -0700 (PDT)
Received: from [192.168.1.134] ([198.8.77.61])
        by smtp.gmail.com with ESMTPSA id o7sm6494063ilt.29.2021.07.11.06.54.15
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Sun, 11 Jul 2021 06:54:16 -0700 (PDT)
Subject: Re: [syzbot] INFO: task hung in io_uring_cancel_generic
To:     syzbot <syzbot+ba6fcd859210f4e9e109@syzkaller.appspotmail.com>,
        asml.silence@gmail.com, io-uring@vger.kernel.org,
        linux-kernel@vger.kernel.org, syzkaller-bugs@googlegroups.com
References: <00000000000053572d05c6d81503@google.com>
From:   Jens Axboe <axboe@kernel.dk>
Message-ID: <f48e63f0-f193-586a-a98d-640359631ee4@kernel.dk>
Date:   Sun, 11 Jul 2021 07:54:22 -0600
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.10.0
MIME-Version: 1.0
In-Reply-To: <00000000000053572d05c6d81503@google.com>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org

On 7/11/21 6:24 AM, syzbot wrote:
> Hello,
> 
> syzbot found the following issue on:
> 
> HEAD commit:    3dbdb38e Merge branch 'for-5.14' of git://git.kernel.org/p..
> git tree:       upstream
> console output: https://syzkaller.appspot.com/x/log.txt?x=14cd9efbd00000
> kernel config:  https://syzkaller.appspot.com/x/.config?x=a1fcf15a09815757
> dashboard link: https://syzkaller.appspot.com/bug?extid=ba6fcd859210f4e9e109
> syz repro:      https://syzkaller.appspot.com/x/repro.syz?x=13bbf280300000
> C reproducer:   https://syzkaller.appspot.com/x/repro.c?x=1111ec9c300000
> 
> IMPORTANT: if you fix the issue, please add the following tag to the commit:
> Reported-by: syzbot+ba6fcd859210f4e9e109@syzkaller.appspotmail.com
> 
> INFO: task syz-executor015:8439 blocked for more than 143 seconds.
>       Tainted: G        W         5.13.0-syzkaller #0
> "echo 0 > /proc/sys/kernel/hung_task_timeout_secs" disables this message.
> task:syz-executor015 state:D stack:28184 pid: 8439 ppid:  8438 flags:0x00000004
> Call Trace:
>  context_switch kernel/sched/core.c:4683 [inline]
>  __schedule+0x934/0x2710 kernel/sched/core.c:5940
>  schedule+0xd3/0x270 kernel/sched/core.c:6019
>  io_uring_cancel_generic+0x54d/0x890 fs/io_uring.c:9203
>  io_uring_files_cancel include/linux/io_uring.h:16 [inline]
>  do_exit+0x28b/0x2a50 kernel/exit.c:780
>  do_group_exit+0x125/0x310 kernel/exit.c:922
>  __do_sys_exit_group kernel/exit.c:933 [inline]
>  __se_sys_exit_group kernel/exit.c:931 [inline]
>  __x64_sys_exit_group+0x3a/0x50 kernel/exit.c:931
>  do_syscall_x64 arch/x86/entry/common.c:50 [inline]
>  do_syscall_64+0x35/0xb0 arch/x86/entry/common.c:80
>  entry_SYSCALL_64_after_hwframe+0x44/0xae
> RIP: 0033:0x43eac9
> RSP: 002b:00007ffc2d1b6378 EFLAGS: 00000246 ORIG_RAX: 00000000000000e7
> RAX: ffffffffffffffda RBX: 00000000004b02f0 RCX: 000000000043eac9
> RDX: 000000000000003c RSI: 00000000000000e7 RDI: 0000000000000000
> RBP: 0000000000000000 R08: ffffffffffffffc0 R09: 00000000f0ffffff
> R10: 0000000000000000 R11: 0000000000000246 R12: 00000000004b02f0
> R13: 0000000000000001 R14: 0000000000000000 R15: 0000000000000001
> INFO: lockdep is turned off.
> NMI backtrace for cpu 0
> CPU: 0 PID: 1650 Comm: khungtaskd Tainted: G        W         5.13.0-syzkaller #0
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
> Sending NMI from CPU 0 to CPUs 1:
> NMI backtrace for cpu 1 skipped: idling at native_safe_halt arch/x86/include/asm/irqflags.h:51 [inline]
> NMI backtrace for cpu 1 skipped: idling at arch_safe_halt arch/x86/include/asm/irqflags.h:89 [inline]
> NMI backtrace for cpu 1 skipped: idling at acpi_safe_halt drivers/acpi/processor_idle.c:109 [inline]
> NMI backtrace for cpu 1 skipped: idling at acpi_idle_do_entry+0x1c6/0x250 drivers/acpi/processor_idle.c:553

#syz test: git://git.kernel.dk/linux-block io_uring-5.14

-- 
Jens Axboe

