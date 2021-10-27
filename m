Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id F17EF43C745
	for <lists+io-uring@lfdr.de>; Wed, 27 Oct 2021 12:02:32 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231950AbhJ0KEz (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Wed, 27 Oct 2021 06:04:55 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:38842 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231666AbhJ0KEy (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Wed, 27 Oct 2021 06:04:54 -0400
Received: from mail-wr1-x435.google.com (mail-wr1-x435.google.com [IPv6:2a00:1450:4864:20::435])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 2A9CAC061570;
        Wed, 27 Oct 2021 03:02:29 -0700 (PDT)
Received: by mail-wr1-x435.google.com with SMTP id e4so3134577wrc.7;
        Wed, 27 Oct 2021 03:02:29 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=message-id:date:mime-version:user-agent:subject:content-language:to
         :references:from:in-reply-to:content-transfer-encoding;
        bh=rqKarvgNFKXVXCfg89IgQ4ExIFIjM/Z9tUoMZEr1X7w=;
        b=bB1rJCNY/3Quwi8KpENraPMnUMs6pCRa/SvQrJqUtJkQ+cBrCHLo/y6p+d0Nvm7aRT
         XFgz8P7n54hT49DNaM0gX49Ju8rIWIHSkEH1g+Z8BVCjLUI2arwiygXqy2nMQlRn8v6r
         mH4vB3P+5Bh0x16DL+2TPcQ+ZlFTsSuUIsJIrQwr7gLSQSx1gKgjzpAxDAgPp+MicwL9
         CZS3w2XbnVMShlTb6au92bd6s4QQhitXjDUeo+6V5BNOx0oWWn3XAlLl9xclZeLIpHAv
         /tvvt5Y8hPdxgMgQ/mhrR+iKooCFwZOaX/3W6/NF2DXxzTIWaNdjaZEFT7RXyvEkStoU
         1LDw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:message-id:date:mime-version:user-agent:subject
         :content-language:to:references:from:in-reply-to
         :content-transfer-encoding;
        bh=rqKarvgNFKXVXCfg89IgQ4ExIFIjM/Z9tUoMZEr1X7w=;
        b=kzSU9remqlJGDfZ0MFQPVyUXpk2FTcOzYly9SfsvFPOM/NHAxZR3GgcfoE1lPPrrCd
         PpT4nItojAr5ETeHTuq0xKd/m/ReXaUEu5Rns5v/kPC4Wd5osjdLPclWvXcjr4LtOisY
         rnWHRdeu0Otu/lKdS3YgQaFlk7hCdaBM8+CQuHDqLisyUsXfxGpqaTXLg40dcLGbpBeY
         YZeoKa9jaVgyNf40yDgm9Vw+9zQDcOubRT+pLs2guCFKdrhS1QL9/rtocvvqN3hAlWrK
         Qldd73JyQ9qeqOH/oPp/0OQZ+xy6pV8mzdNY430pDEhOtv+NFWbS2CI2NlP6HWO8CrCS
         a2UQ==
X-Gm-Message-State: AOAM531DIAj11i1lzg2TX68VdfRZZuZV8vc5fsMQGUh95QMxV1lrlfi6
        twFfC17P5063c0WKFoz6ggY=
X-Google-Smtp-Source: ABdhPJw4FX0/22B2p0FcaO6ph/s3Raok7TifhDrdpkyqz48JSm5IRMXu5W0A7yuPDdWJ0x0eoB9kDw==
X-Received: by 2002:a5d:59a9:: with SMTP id p9mr41261184wrr.386.1635328947500;
        Wed, 27 Oct 2021 03:02:27 -0700 (PDT)
Received: from [192.168.8.198] ([148.252.132.100])
        by smtp.gmail.com with ESMTPSA id m20sm3407217wmq.5.2021.10.27.03.02.26
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Wed, 27 Oct 2021 03:02:27 -0700 (PDT)
Message-ID: <d8422d8a-b7f4-6544-c336-267dcc1b18d1@gmail.com>
Date:   Wed, 27 Oct 2021 10:58:13 +0100
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:91.0) Gecko/20100101
 Thunderbird/91.2.0
Subject: Re: INFO: task hung in io_wq_put_and_exit
Content-Language: en-US
To:     Hao Sun <sunhao.th@gmail.com>, Jens Axboe <axboe@kernel.dk>,
        io-uring@vger.kernel.org,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
References: <CACkBjsY_xKQWb80T53W76Upazws1+to72ux1RVFCDC29OQ-gKQ@mail.gmail.com>
From:   Pavel Begunkov <asml.silence@gmail.com>
In-Reply-To: <CACkBjsY_xKQWb80T53W76Upazws1+to72ux1RVFCDC29OQ-gKQ@mail.gmail.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org

On 10/27/21 02:17, Hao Sun wrote:
> Hello,
> 
> When using Healer to fuzz the latest Linux kernel, the following crash
> was triggered.
> 
> HEAD commit: 519d81956ee2 Linux 5.15-rc6
> git tree: upstream
> console output:
> https://drive.google.com/file/d/13rSoYeSyLgYZ_8i4uYYH9hKWHmKh7wtl/view?usp=sharing
> kernel config: https://drive.google.com/file/d/12PUnxIM1EPBgW4ZJmI7WJBRaY1lA83an/view?usp=sharing
> 
> Sorry, I don't have a reproducer for this crash, hope the symbolized
> report can help.
> If you fix this issue, please add the following tag to the commit:
> Reported-by: Hao Sun <sunhao.th@gmail.com>

This looks like a similar report with a repro sent by syzbot,
the problem is narrowed (tw + sleeping in coredump), under
discussion.


> INFO: task syz-executor:8213 blocked for more than 143 seconds.
>        Not tainted 5.15.0-rc6 #4
> "echo 0 > /proc/sys/kernel/hung_task_timeout_secs" disables this message.
> task:syz-executor    state:D stack:27784 pid: 8213 ppid:  7441 flags:0x00024004
> Call Trace:
>   context_switch kernel/sched/core.c:4940 [inline]
>   __schedule+0xcd9/0x2530 kernel/sched/core.c:6287
>   schedule+0xd3/0x270 kernel/sched/core.c:6366
>   schedule_timeout+0x5e5/0x890 kernel/time/timer.c:1857
>   do_wait_for_common kernel/sched/completion.c:85 [inline]
>   __wait_for_common kernel/sched/completion.c:106 [inline]
>   wait_for_common kernel/sched/completion.c:117 [inline]
>   wait_for_completion+0x17d/0x280 kernel/sched/completion.c:138
>   io_wq_exit_workers fs/io-wq.c:1174 [inline]
>   io_wq_put_and_exit+0x44e/0xcc0 fs/io-wq.c:1209
>   io_uring_clean_tctx fs/io_uring.c:9718 [inline]
>   io_uring_cancel_generic+0x616/0x760 fs/io_uring.c:9798
>   io_uring_files_cancel include/linux/io_uring.h:16 [inline]
>   do_exit+0x25c/0x2dd0 kernel/exit.c:780
>   do_group_exit+0x125/0x340 kernel/exit.c:922
>   get_signal+0x4d5/0x25a0 kernel/signal.c:2868
>   arch_do_signal_or_restart+0x2ed/0x1c40 arch/x86/kernel/signal.c:865
>   handle_signal_work kernel/entry/common.c:148 [inline]
>   exit_to_user_mode_loop kernel/entry/common.c:172 [inline]
>   exit_to_user_mode_prepare+0x192/0x2a0 kernel/entry/common.c:207
>   __syscall_exit_to_user_mode_work kernel/entry/common.c:289 [inline]
>   syscall_exit_to_user_mode+0x19/0x60 kernel/entry/common.c:300
>   do_syscall_64+0x42/0xb0 arch/x86/entry/common.c:86
>   entry_SYSCALL_64_after_hwframe+0x44/0xae
> RIP: 0033:0x7f6d07ffec4d
> RSP: 002b:00007f6d05524c58 EFLAGS: 00000246 ORIG_RAX: 00000000000001aa
> RAX: 0000000000000100 RBX: 00007f6d08125210 RCX: 00007f6d07ffec4d
> RDX: 0000000000000000 RSI: 000000000000450c RDI: 0000000000000005
> RBP: 00007f6d08077d80 R08: 0000000000000000 R09: 0000000000000000
> R10: 0000000000000000 R11: 0000000000000246 R12: 00007f6d08125210
> R13: 00007ffea7b3783f R14: 00007ffea7b379e0 R15: 00007f6d05524dc0
> INFO: lockdep is turned off.
> NMI backtrace for cpu 2
> CPU: 2 PID: 39 Comm: khungtaskd Not tainted 5.15.0-rc6 #4
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
> Sending NMI from CPU 2 to CPUs 0-1,3:
> NMI backtrace for cpu 0 skipped: idling at native_safe_halt
> arch/x86/include/asm/irqflags.h:51 [inline]
> NMI backtrace for cpu 0 skipped: idling at arch_safe_halt
> arch/x86/include/asm/irqflags.h:89 [inline]
> NMI backtrace for cpu 0 skipped: idling at default_idle+0xb/0x10
> arch/x86/kernel/process.c:716
> NMI backtrace for cpu 1 skipped: idling at native_safe_halt
> arch/x86/include/asm/irqflags.h:51 [inline]
> NMI backtrace for cpu 1 skipped: idling at arch_safe_halt
> arch/x86/include/asm/irqflags.h:89 [inline]
> NMI backtrace for cpu 1 skipped: idling at default_idle+0xb/0x10
> arch/x86/kernel/process.c:716
> NMI backtrace for cpu 3
> CPU: 3 PID: 11026 Comm: syz-executor Not tainted 5.15.0-rc6 #4
> Hardware name: QEMU Standard PC (i440FX + PIIX, 1996), BIOS
> 1.13.0-1ubuntu1.1 04/01/2014
> RIP: 0010:__sanitizer_cov_trace_pc+0x1c/0x40 kernel/kcov.c:197
> Code: 66 66 2e 0f 1f 84 00 00 00 00 00 0f 1f 00 65 48 8b 0c 25 40 f0
> 01 00 bf 02 00 00 00 48 89 ce 4c 8b 04 24 e8 76 ff ff ff 84 c0 <74> 20
> 48 8b 91 20 15 00 00 8b 89 1c 15 00 00 48 8b 02 48 83 c0 01
> RSP: 0018:ffffc9000573f8b8 EFLAGS: 00000246
> RAX: 0000000000000000 RBX: 000000000000000b RCX: ffff8880318f1c80
> RDX: 0000000000000000 RSI: ffff8880318f1c80 RDI: 0000000000000002
> RBP: ffff8881038b0880 R08: ffffffff83a8fb86 R09: 0000000000000010
> R10: 0000000000000001 R11: fffffbfff2078908 R12: 0000000000000010
> R13: 0000000000000288 R14: dffffc0000000000 R15: 0000000000000000
> FS:  0000555557215940(0000) GS:ffff888135d00000(0000) knlGS:0000000000000000
> CS:  0010 DS: 0000 ES: 0000 CR0: 0000000080050033
> CR2: 00007ffd2317ab68 CR3: 000000003196b000 CR4: 0000000000350ee0
> Call Trace:
>   tomoyo_domain_quota_is_ok+0x2f6/0x540 security/tomoyo/util.c:1093
>   tomoyo_supervisor+0x290/0xe30 security/tomoyo/common.c:2089
>   tomoyo_audit_path_log security/tomoyo/file.c:168 [inline]
>   tomoyo_path_permission security/tomoyo/file.c:587 [inline]
>   tomoyo_path_permission+0x270/0x3a0 security/tomoyo/file.c:573
>   tomoyo_path_perm+0x2fc/0x420 security/tomoyo/file.c:838
>   tomoyo_path_unlink+0x8e/0xd0 security/tomoyo/tomoyo.c:149
>   security_path_unlink+0xd7/0x150 security/security.c:1155
>   do_unlinkat+0x369/0x660 fs/namei.c:4165
>   __do_sys_unlink fs/namei.c:4217 [inline]
>   __se_sys_unlink fs/namei.c:4215 [inline]
>   __x64_sys_unlink+0x3e/0x50 fs/namei.c:4215
>   do_syscall_x64 arch/x86/entry/common.c:50 [inline]
>   do_syscall_64+0x35/0xb0 arch/x86/entry/common.c:80
>   entry_SYSCALL_64_after_hwframe+0x44/0xae
> RIP: 0033:0x7f1b1317153b
> Code: 73 01 c3 48 c7 c1 bc ff ff ff f7 d8 64 89 01 48 83 c8 ff c3 66
> 2e 0f 1f 84 00 00 00 00 00 90 f3 0f 1e fa b8 57 00 00 00 0f 05 <48> 3d
> 01 f0 ff ff 73 01 c3 48 c7 c1 bc ff ff ff f7 d8 64 89 01 48
> RSP: 002b:00007ffd2317ab68 EFLAGS: 00000202 ORIG_RAX: 0000000000000057
> RAX: ffffffffffffffda RBX: 0000000000009d6e RCX: 00007f1b1317153b
> RDX: 00007ffd2317ab98 RSI: 0000000040086602 RDI: 00007ffd2317ac30
> RBP: 00007ffd2317ac30 R08: 0000000000000000 R09: 00007ffd2317a9f0
> R10: 0000000000000000 R11: 0000000000000202 R12: 00007f1b131e9e46
> R13: 00007ffd2317bcd0 R14: 000055555721ee50 R15: 0000000000000004
> ----------------
> Code disassembly (best guess):
>     0: 66 66 2e 0f 1f 84 00 data16 nopw %cs:0x0(%rax,%rax,1)
>     7: 00 00 00 00
>     b: 0f 1f 00              nopl   (%rax)
>     e: 65 48 8b 0c 25 40 f0 mov    %gs:0x1f040,%rcx
>    15: 01 00
>    17: bf 02 00 00 00        mov    $0x2,%edi
>    1c: 48 89 ce              mov    %rcx,%rsi
>    1f: 4c 8b 04 24          mov    (%rsp),%r8
>    23: e8 76 ff ff ff        callq  0xffffff9e
>    28: 84 c0                test   %al,%al
> * 2a: 74 20                je     0x4c <-- trapping instruction
>    2c: 48 8b 91 20 15 00 00 mov    0x1520(%rcx),%rdx
>    33: 8b 89 1c 15 00 00    mov    0x151c(%rcx),%ecx
>    39: 48 8b 02              mov    (%rdx),%rax
>    3c: 48 83 c0 01          add    $0x1,%rax
> 

-- 
Pavel Begunkov
