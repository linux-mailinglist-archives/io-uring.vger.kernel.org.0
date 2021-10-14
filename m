Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 3906942D6A6
	for <lists+io-uring@lfdr.de>; Thu, 14 Oct 2021 12:01:18 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229691AbhJNKDV (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Thu, 14 Oct 2021 06:03:21 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:34712 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229468AbhJNKDV (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Thu, 14 Oct 2021 06:03:21 -0400
Received: from mail-wr1-x431.google.com (mail-wr1-x431.google.com [IPv6:2a00:1450:4864:20::431])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 698D1C061570;
        Thu, 14 Oct 2021 03:01:16 -0700 (PDT)
Received: by mail-wr1-x431.google.com with SMTP id e3so17479962wrc.11;
        Thu, 14 Oct 2021 03:01:16 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=message-id:date:mime-version:user-agent:subject:content-language:to
         :cc:references:from:in-reply-to:content-transfer-encoding;
        bh=R4iHv57OnUQKlDr2pJjWFCYfJDrK2T+I467cnaGKuhc=;
        b=U5JD3nFhtwicBbvo1777pXTWsG0xPgtE3epuE44PbBfQl8WyymtR4z9XRESGef9gSx
         3vleexaxGou9USbplJWz8cg5Ks4dNvOpT//gIC+KFfR1Zg3uvHGPYYmSUdTsD6Ahnvv7
         WPD1njchbdgkATtkzhYd5/Ve5FWTa4tTJhaJit46DMpQPJ6SoYDhLTXRmJ3hRIULfVun
         i2EOTr1R4a2twnzxYJT9TYTszopwPOV4vOcFa75E3d1EJxgUgI6iW248FQR79z7rCf3h
         pTF91oVEj9BMacRaxney4DZmQ6vrfZzUXW4QhGNS0eAaUPDtWb1uzaulU4538bjaye8Q
         Y4rA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:message-id:date:mime-version:user-agent:subject
         :content-language:to:cc:references:from:in-reply-to
         :content-transfer-encoding;
        bh=R4iHv57OnUQKlDr2pJjWFCYfJDrK2T+I467cnaGKuhc=;
        b=iY7Zlw+dnHY3mwaFlMk2rG8J2avxGJFn19Ons81i/sMs+TeROj5bk9aL3ZOzzfItTI
         B8IuF8ObiHjAHf4tUb8bNnKFyjrD/SkyT3ftE7Kzra64npKE01h6ZfJ0T99J/9EJC0jk
         tigaUjmMpicFsjijHHqejCgWezsLrphKRe52YQHZXvHu6a0HCqx+eGE6Y+KsTLcpOywM
         P64LSrD0yAd4pYLOiIBi/7eWifepJNsNW/N78mM9mMZwPtYUKRwB1hg/CfmOIRvblhaR
         tuBt1M7B/bfr6ENZYBdlLlBGsVXybku9LQEpDItuSF53A53l8SuGXvDLLgDt1/RbCR0Q
         D7Uw==
X-Gm-Message-State: AOAM533ZuyL/q4o0tUi/t1mW9nIq5YIHfKqVs/AJW98gvCpNmIrI31Hg
        Jjx3qDGte6KX99ahtUTn6Kg=
X-Google-Smtp-Source: ABdhPJzUFrDwFpCIbAQcSIb5WB3ANTG3DELEDWn/Gotb+vymbp3vd2FUiLW8f2L0jHt2QU5L8W2bgw==
X-Received: by 2002:adf:d1c5:: with SMTP id b5mr5356650wrd.419.1634205674889;
        Thu, 14 Oct 2021 03:01:14 -0700 (PDT)
Received: from [192.168.8.197] ([185.69.145.214])
        by smtp.gmail.com with ESMTPSA id o11sm2530757wry.0.2021.10.14.03.01.14
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Thu, 14 Oct 2021 03:01:14 -0700 (PDT)
Message-ID: <2fc312e5-81f1-1efa-4f35-97131e51d1b3@gmail.com>
Date:   Thu, 14 Oct 2021 11:00:35 +0100
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:91.0) Gecko/20100101
 Thunderbird/91.1.2
Subject: Re: INFO: task hung in io_ring_exit_work
Content-Language: en-US
To:     Hao Sun <sunhao.th@gmail.com>, Jens Axboe <axboe@kernel.dk>,
        io-uring@vger.kernel.org
Cc:     Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
References: <CACkBjsZawnG=g7yMAgLiXxFggzuzwnJ2yq=340az7tG37HKHyQ@mail.gmail.com>
From:   Pavel Begunkov <asml.silence@gmail.com>
In-Reply-To: <CACkBjsZawnG=g7yMAgLiXxFggzuzwnJ2yq=340az7tG37HKHyQ@mail.gmail.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org

On 10/14/21 03:27, Hao Sun wrote:
> Hello,
> 
> When using Healer to fuzz the latest Linux kernel, the following crash
> was triggered.
> 
> HEAD commit: 64570fbc14f8 Linux 5.15-rc5
> git tree: upstream
> console output:
> https://drive.google.com/file/d/1JeHQP3cxmLK6WDSLxyOrUGLDujuTCXeU/view?usp=sharing
> kernel config: https://drive.google.com/file/d/1em3xgUIMNN_-LUUdySzwN-UDPc3qiiKD/view?usp=sharing
> Similar report from syzbot:
> https://syzkaller.appspot.com/bug?id=db58a4022d476752fca3c46386b33ca799d3a7f0
> 
> Sorry, I don't have a reproducer for this crash, hope the symbolized
> report can help.
> If you fix this issue, please add the following tag to the commit:
> Reported-by: Hao Sun <sunhao.th@gmail.com>

That's interesting, tws are not being run again. I'm afraid the
report doesn't help, but hopefully it'll be able to find a repro


> INFO: task kworker/u10:0:24 blocked for more than 143 seconds.
>        Not tainted 5.15.0-rc5 #3
> "echo 0 > /proc/sys/kernel/hung_task_timeout_secs" disables this message.
> task:kworker/u10:0   state:D stack:24944 pid:   24 ppid:     2 flags:0x00004000
> Workqueue: events_unbound io_ring_exit_work
> Call Trace:
>   context_switch kernel/sched/core.c:4940 [inline]
>   __schedule+0xcd9/0x2530 kernel/sched/core.c:6287
>   schedule+0xd3/0x270 kernel/sched/core.c:6366
>   schedule_timeout+0x5e5/0x890 kernel/time/timer.c:1857
>   do_wait_for_common kernel/sched/completion.c:85 [inline]
>   __wait_for_common kernel/sched/completion.c:106 [inline]
>   wait_for_common kernel/sched/completion.c:117 [inline]
>   wait_for_completion+0x17d/0x280 kernel/sched/completion.c:138
>   io_ring_exit_work+0x530/0x1550 fs/io_uring.c:9442
>   process_one_work+0x9df/0x16d0 kernel/workqueue.c:2297
>   worker_thread+0x90/0xed0 kernel/workqueue.c:2444
>   kthread+0x3e5/0x4d0 kernel/kthread.c:319
>   ret_from_fork+0x1f/0x30 arch/x86/entry/entry_64.S:295
> INFO: lockdep is turned off.
> NMI backtrace for cpu 0
> CPU: 0 PID: 39 Comm: khungtaskd Not tainted 5.15.0-rc5 #3
> Hardware name: QEMU Standard PC (i440FX + PIIX, 1996), BIOS
> 1.13.0-1ubuntu1.1 04/01/2014
> Call Trace:
>   __dump_stack lib/dump_stack.c:88 [inline]
>   dump_stack_lvl+0xcd/0x134 lib/dump_stack.c:106
>   nmi_cpu_backtrace.cold+0x47/0x144 lib/nmi_backtrace.c:105
>   nmi_trigger_cpumask_backtrace+0x1e1/0x220 lib/nmi_backtrace.c:62
>   trigger_all_cpu_backtrace include/linux/nmi.h:146 [inline]
>   check_hung_uninterruptible_tasks kernel/hung_task.c:210 [inline]
>   watchdog+0xcc8/0x1010 kernel/hung_task.c:295
>   kthread+0x3e5/0x4d0 kernel/kthread.c:319
>   ret_from_fork+0x1f/0x30 arch/x86/entry/entry_64.S:295
> Sending NMI from CPU 0 to CPUs 1-3:
> NMI backtrace for cpu 1
> CPU: 1 PID: 13884 Comm: syz-executor Not tainted 5.15.0-rc5 #3
> Hardware name: QEMU Standard PC (i440FX + PIIX, 1996), BIOS
> 1.13.0-1ubuntu1.1 04/01/2014
> RIP: 0010:irqentry_enter+0x28/0x50 kernel/entry/common.c:380
> Code: 00 00 f6 87 88 00 00 00 03 75 37 65 48 8b 04 25 40 f0 01 00 f6
> 40 2c 02 48 8b 3c 24 75 0f e8 1f f4 ff ff eb 00 e8 d8 87 49 f8 <31> c0
> c3 e8 10 f4 ff ff e8 cb fc ff ff e8 c6 87 49 f8 b8 01 00 00
> RSP: 0018:ffffc90009db7db0 EFLAGS: 00000046
> RAX: 0000000000000000 RBX: 0000000000000000 RCX: ffff888017765580
> RDX: 0000000000000000 RSI: ffff888017765580 RDI: 0000000000000002
> RBP: ffffc90009db7de8 R08: ffffffff8932db28 R09: 0000000000000000
> R10: 0000000000000001 R11: fffffbfff1adb0b2 R12: 0000000000000000
> R13: 0000000000000000 R14: 0000000000000003 R15: 0000000000000000
> FS:  00007ff54513e700(0000) GS:ffff888135c00000(0000) knlGS:0000000000000000
> CS:  0010 DS: 0000 ES: 0000 CR0: 0000000080050033
> CR2: 0000000000000003 CR3: 00000000149e3000 CR4: 0000000000350ee0
> Call Trace:
>   exc_page_fault+0x45/0x180 arch/x86/mm/fault.c:1538
>   asm_exc_page_fault+0x1e/0x30 arch/x86/include/asm/idtentry.h:568
> RIP: 0010:do_strncpy_from_user lib/strncpy_from_user.c:41 [inline]
> RIP: 0010:strncpy_from_user+0x1e6/0x3f0 lib/strncpy_from_user.c:139
> Code: 83 eb 08 4d 89 7c 2d 00 bf 07 00 00 00 48 83 c5 08 48 89 de e8
> cb 40 7b fd 48 83 fb 07 0f 86 c4 01 00 00 e8 3c 3f 7b fd 31 c0 <4d> 8b
> 3c 2c 31 ff 89 c6 89 04 24 e8 8a 40 7b fd 8b 04 24 85 c0 0f
> RSP: 0018:ffffc90009db7e90 EFLAGS: 00050246
> RAX: 0000000000000000 RBX: 0000000000000fe0 RCX: ffff888017765580
> RDX: 0000000000000000 RSI: ffff888017765580 RDI: 0000000000000002
> RBP: 0000000000000000 R08: ffffffff83fb1f84 R09: 0000000000000007
> R10: 0000000000000007 R11: fffff94000862c40 R12: 0000000000000003
> R13: ffff88810c589120 R14: 0000000000000fe0 R15: 0000000000000fe3
>   getname_flags fs/namei.c:149 [inline]
>   getname_flags+0x117/0x5b0 fs/namei.c:128
>   getname fs/namei.c:217 [inline]
>   __do_sys_rename fs/namei.c:4825 [inline]
>   __se_sys_rename fs/namei.c:4823 [inline]
>   __x64_sys_rename+0x56/0xa0 fs/namei.c:4823
>   do_syscall_x64 arch/x86/entry/common.c:50 [inline]
>   do_syscall_64+0x35/0xb0 arch/x86/entry/common.c:80
>   entry_SYSCALL_64_after_hwframe+0x44/0xae
> RIP: 0033:0x2000028a
> Code: 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00
> 00 00 00 00 00 00 00 00 00 00 00 98 4a 2a e9 2c b8 b6 4c 0f 05 <bf> 00
> 00 40 00 c4 a3 7b f0 c5 01 41 e2 e9 c4 22 e9 aa bb 3c 00 00
> RSP: 002b:00007ff54513dbb8 EFLAGS: 00000203 ORIG_RAX: 0000000000000052
> RAX: ffffffffffffffda RBX: 0000000000000009 RCX: 000000002000028a
> RDX: 0000000000004c01 RSI: 0000000000000003 RDI: 0000000000400000
> RBP: 000000000000008b R08: 0000000000000005 R09: 0000000000000006
> R10: 0000000000000007 R11: 0000000000000203 R12: 000000000000000b
> R13: 000000000000000c R14: 000000000000000d R15: 00007ff54513ddc0
> NMI backtrace for cpu 2 skipped: idling at native_safe_halt
> arch/x86/include/asm/irqflags.h:51 [inline]
> NMI backtrace for cpu 2 skipped: idling at arch_safe_halt
> arch/x86/include/asm/irqflags.h:89 [inline]
> NMI backtrace for cpu 2 skipped: idling at default_idle+0xb/0x10
> arch/x86/kernel/process.c:716
> NMI backtrace for cpu 3
> CPU: 3 PID: 3019 Comm: systemd-journal Not tainted 5.15.0-rc5 #3
> Hardware name: QEMU Standard PC (i440FX + PIIX, 1996), BIOS
> 1.13.0-1ubuntu1.1 04/01/2014
> RIP: 0033:0x7ffc3d1c69b5
> Code: 00 0f 84 b9 00 00 00 4c 63 cf 49 c1 e1 04 4d 01 c1 45 8b 10 41
> f6 c2 01 0f 85 8d 00 00 00 41 8b 40 04 83 f8 01 75 6f 0f 01 f9 <66> 90
> 48 c1 e2 20 48 09 c2 48 85 d2 78 63 49 8b 48 08 49 8b 41 28
> RSP: 002b:00007ffc3d110910 EFLAGS: 00000246
> RAX: 000000007fa7dd4e RBX: 0000000000000007 RCX: 0000000000001003
> RDX: 0000000000000096 RSI: 00007ffc3d110960 RDI: 0000000000000007
> RBP: 00007ffc3d110930 R08: 00007ffc3d1c2080 R09: 00007ffc3d1c20f0
> R10: 000000000000dd10 R11: 000000000000011d R12: 00007ffc3d1109a0
> R13: 0000000000000001 R14: 0000000000000001 R15: 0005ce1974964533
> FS:  00007f9157d9a8c0 GS:  0000000000000000
> ----------------
> Code disassembly (best guess):
>     0: 00 00                add    %al,(%rax)
>     2: f6 87 88 00 00 00 03 testb  $0x3,0x88(%rdi)
>     9: 75 37                jne    0x42
>     b: 65 48 8b 04 25 40 f0 mov    %gs:0x1f040,%rax
>    12: 01 00
>    14: f6 40 2c 02          testb  $0x2,0x2c(%rax)
>    18: 48 8b 3c 24          mov    (%rsp),%rdi
>    1c: 75 0f                jne    0x2d
>    1e: e8 1f f4 ff ff        callq  0xfffff442
>    23: eb 00                jmp    0x25
>    25: e8 d8 87 49 f8        callq  0xf8498802
> * 2a: 31 c0                xor    %eax,%eax <-- trapping instruction
>    2c: c3                    retq
>    2d: e8 10 f4 ff ff        callq  0xfffff442
>    32: e8 cb fc ff ff        callq  0xfffffd02
>    37: e8 c6 87 49 f8        callq  0xf8498802
>    3c: b8                    .byte 0xb8
>    3d: 01 00                add    %eax,(%rax)%
> 

-- 
Pavel Begunkov
