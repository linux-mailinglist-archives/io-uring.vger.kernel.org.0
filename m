Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 2FF8E43BEE5
	for <lists+io-uring@lfdr.de>; Wed, 27 Oct 2021 03:17:23 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236340AbhJ0BTq (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Tue, 26 Oct 2021 21:19:46 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:33804 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233535AbhJ0BTq (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Tue, 26 Oct 2021 21:19:46 -0400
Received: from mail-pg1-x529.google.com (mail-pg1-x529.google.com [IPv6:2607:f8b0:4864:20::529])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id E8289C061570;
        Tue, 26 Oct 2021 18:17:21 -0700 (PDT)
Received: by mail-pg1-x529.google.com with SMTP id 75so1297300pga.3;
        Tue, 26 Oct 2021 18:17:21 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=mime-version:from:date:message-id:subject:to;
        bh=ntgIb+EtG1GB86pD1+aLP04E+11BkH7l5yZLkTlgL7Y=;
        b=OWTkgBJPFnzIf8gRoPnzgSxSX0KlnBxGebMwpwbrRhb4NC9vdI/3vCxVuvoNsDyXTj
         zuh6YIjCZSeMlQG2/2lILQTGsHHlXZo4MdHVhOWk3upeZPMEyJW0dZdxnCy3K1jP+gKG
         RnHzwHv4xP3ZMeJM4DUFLocZvTh4yyqxEawTgv9qtPcuFpuhtoW9Pdc34jrD37aMc+np
         o4HVOp9KJM4jQ4IWpg35KEQGwmNvxXOLdMEmmU9ZHlyXdiw4id4rFvQIjiA/oVbHQuam
         RMFYZWi+yp+ism9I2EhX65d0d644TJ5ZjSEvt4Iy1AGPb0eFkrDD1jj8/arpHQYs19t3
         hhRQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:mime-version:from:date:message-id:subject:to;
        bh=ntgIb+EtG1GB86pD1+aLP04E+11BkH7l5yZLkTlgL7Y=;
        b=ltkY3BWXE1fIdyhU3Aziyv2/G9FAuHCiIp0UtLkYpTAhhtN6rne1cq14RSk23xexwM
         3dLN92EQo1AmBXsnKUIedMurbv4E6tAaROlaYJWnQnJ5EwaOrkOdyQ0E+EndI3o09zba
         xISZHlcdKDznE9xr6JMFrrpcJiGq7uEelGf5gD2ckiK0ayt4NQhdJRK/vnUgiztMvmc0
         BNL7eWsoZ34i6ldzwdeFNqRrqDG0MshmAj3fE/mySVFYgmBNcbpnB3EGDC1e977ZRLcO
         ePIvDg9h9FJvim6C9u9sIaIldBO9S2RMGhlt0KfL5/F4ZVAPfUmuO3YP6gWwVbIXu2Pw
         eZsg==
X-Gm-Message-State: AOAM532eBPfiIFlrlpS5gWqlcXfcuaAEvH6FIRrcLuUzlFp1GyuQW+QS
        Uj52fIa4mLxKDWtTDX4pwT+1H4xw0tE5vGpOiVSohGgqh1zGzNDJYw==
X-Google-Smtp-Source: ABdhPJz27L3SwFsIkhEbIYICtmc6wY4wxUvHY0t54e5+pWlbFFxdsu1t0DpP6O+/ohJsEzdQ1xr/u6BJJUEtrwhTdFQ=
X-Received: by 2002:a05:6a00:1242:b0:44c:2025:29e3 with SMTP id
 u2-20020a056a00124200b0044c202529e3mr29808327pfi.59.1635297441276; Tue, 26
 Oct 2021 18:17:21 -0700 (PDT)
MIME-Version: 1.0
From:   Hao Sun <sunhao.th@gmail.com>
Date:   Wed, 27 Oct 2021 09:17:08 +0800
Message-ID: <CACkBjsY_xKQWb80T53W76Upazws1+to72ux1RVFCDC29OQ-gKQ@mail.gmail.com>
Subject: INFO: task hung in io_wq_put_and_exit
To:     Jens Axboe <axboe@kernel.dk>, io-uring@vger.kernel.org,
        Pavel Begunkov <asml.silence@gmail.com>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org

Hello,

When using Healer to fuzz the latest Linux kernel, the following crash
was triggered.

HEAD commit: 519d81956ee2 Linux 5.15-rc6
git tree: upstream
console output:
https://drive.google.com/file/d/13rSoYeSyLgYZ_8i4uYYH9hKWHmKh7wtl/view?usp=sharing
kernel config: https://drive.google.com/file/d/12PUnxIM1EPBgW4ZJmI7WJBRaY1lA83an/view?usp=sharing

Sorry, I don't have a reproducer for this crash, hope the symbolized
report can help.
If you fix this issue, please add the following tag to the commit:
Reported-by: Hao Sun <sunhao.th@gmail.com>

INFO: task syz-executor:8213 blocked for more than 143 seconds.
      Not tainted 5.15.0-rc6 #4
"echo 0 > /proc/sys/kernel/hung_task_timeout_secs" disables this message.
task:syz-executor    state:D stack:27784 pid: 8213 ppid:  7441 flags:0x00024004
Call Trace:
 context_switch kernel/sched/core.c:4940 [inline]
 __schedule+0xcd9/0x2530 kernel/sched/core.c:6287
 schedule+0xd3/0x270 kernel/sched/core.c:6366
 schedule_timeout+0x5e5/0x890 kernel/time/timer.c:1857
 do_wait_for_common kernel/sched/completion.c:85 [inline]
 __wait_for_common kernel/sched/completion.c:106 [inline]
 wait_for_common kernel/sched/completion.c:117 [inline]
 wait_for_completion+0x17d/0x280 kernel/sched/completion.c:138
 io_wq_exit_workers fs/io-wq.c:1174 [inline]
 io_wq_put_and_exit+0x44e/0xcc0 fs/io-wq.c:1209
 io_uring_clean_tctx fs/io_uring.c:9718 [inline]
 io_uring_cancel_generic+0x616/0x760 fs/io_uring.c:9798
 io_uring_files_cancel include/linux/io_uring.h:16 [inline]
 do_exit+0x25c/0x2dd0 kernel/exit.c:780
 do_group_exit+0x125/0x340 kernel/exit.c:922
 get_signal+0x4d5/0x25a0 kernel/signal.c:2868
 arch_do_signal_or_restart+0x2ed/0x1c40 arch/x86/kernel/signal.c:865
 handle_signal_work kernel/entry/common.c:148 [inline]
 exit_to_user_mode_loop kernel/entry/common.c:172 [inline]
 exit_to_user_mode_prepare+0x192/0x2a0 kernel/entry/common.c:207
 __syscall_exit_to_user_mode_work kernel/entry/common.c:289 [inline]
 syscall_exit_to_user_mode+0x19/0x60 kernel/entry/common.c:300
 do_syscall_64+0x42/0xb0 arch/x86/entry/common.c:86
 entry_SYSCALL_64_after_hwframe+0x44/0xae
RIP: 0033:0x7f6d07ffec4d
RSP: 002b:00007f6d05524c58 EFLAGS: 00000246 ORIG_RAX: 00000000000001aa
RAX: 0000000000000100 RBX: 00007f6d08125210 RCX: 00007f6d07ffec4d
RDX: 0000000000000000 RSI: 000000000000450c RDI: 0000000000000005
RBP: 00007f6d08077d80 R08: 0000000000000000 R09: 0000000000000000
R10: 0000000000000000 R11: 0000000000000246 R12: 00007f6d08125210
R13: 00007ffea7b3783f R14: 00007ffea7b379e0 R15: 00007f6d05524dc0
INFO: lockdep is turned off.
NMI backtrace for cpu 2
CPU: 2 PID: 39 Comm: khungtaskd Not tainted 5.15.0-rc6 #4
Hardware name: QEMU Standard PC (i440FX + PIIX, 1996), BIOS
1.13.0-1ubuntu1.1 04/01/2014
Call Trace:
 __dump_stack lib/dump_stack.c:88 [inline]
 dump_stack_lvl+0xcd/0x134 lib/dump_stack.c:106
 nmi_cpu_backtrace.cold+0x47/0x144 lib/nmi_backtrace.c:105
 nmi_trigger_cpumask_backtrace+0x1e1/0x220 lib/nmi_backtrace.c:62
 trigger_all_cpu_backtrace include/linux/nmi.h:146 [inline]
 check_hung_uninterruptible_tasks kernel/hung_task.c:210 [inline]
 watchdog+0xcc8/0x1010 kernel/hung_task.c:295
 kthread+0x3e5/0x4d0 kernel/kthread.c:319
 ret_from_fork+0x1f/0x30 arch/x86/entry/entry_64.S:295
Sending NMI from CPU 2 to CPUs 0-1,3:
NMI backtrace for cpu 0 skipped: idling at native_safe_halt
arch/x86/include/asm/irqflags.h:51 [inline]
NMI backtrace for cpu 0 skipped: idling at arch_safe_halt
arch/x86/include/asm/irqflags.h:89 [inline]
NMI backtrace for cpu 0 skipped: idling at default_idle+0xb/0x10
arch/x86/kernel/process.c:716
NMI backtrace for cpu 1 skipped: idling at native_safe_halt
arch/x86/include/asm/irqflags.h:51 [inline]
NMI backtrace for cpu 1 skipped: idling at arch_safe_halt
arch/x86/include/asm/irqflags.h:89 [inline]
NMI backtrace for cpu 1 skipped: idling at default_idle+0xb/0x10
arch/x86/kernel/process.c:716
NMI backtrace for cpu 3
CPU: 3 PID: 11026 Comm: syz-executor Not tainted 5.15.0-rc6 #4
Hardware name: QEMU Standard PC (i440FX + PIIX, 1996), BIOS
1.13.0-1ubuntu1.1 04/01/2014
RIP: 0010:__sanitizer_cov_trace_pc+0x1c/0x40 kernel/kcov.c:197
Code: 66 66 2e 0f 1f 84 00 00 00 00 00 0f 1f 00 65 48 8b 0c 25 40 f0
01 00 bf 02 00 00 00 48 89 ce 4c 8b 04 24 e8 76 ff ff ff 84 c0 <74> 20
48 8b 91 20 15 00 00 8b 89 1c 15 00 00 48 8b 02 48 83 c0 01
RSP: 0018:ffffc9000573f8b8 EFLAGS: 00000246
RAX: 0000000000000000 RBX: 000000000000000b RCX: ffff8880318f1c80
RDX: 0000000000000000 RSI: ffff8880318f1c80 RDI: 0000000000000002
RBP: ffff8881038b0880 R08: ffffffff83a8fb86 R09: 0000000000000010
R10: 0000000000000001 R11: fffffbfff2078908 R12: 0000000000000010
R13: 0000000000000288 R14: dffffc0000000000 R15: 0000000000000000
FS:  0000555557215940(0000) GS:ffff888135d00000(0000) knlGS:0000000000000000
CS:  0010 DS: 0000 ES: 0000 CR0: 0000000080050033
CR2: 00007ffd2317ab68 CR3: 000000003196b000 CR4: 0000000000350ee0
Call Trace:
 tomoyo_domain_quota_is_ok+0x2f6/0x540 security/tomoyo/util.c:1093
 tomoyo_supervisor+0x290/0xe30 security/tomoyo/common.c:2089
 tomoyo_audit_path_log security/tomoyo/file.c:168 [inline]
 tomoyo_path_permission security/tomoyo/file.c:587 [inline]
 tomoyo_path_permission+0x270/0x3a0 security/tomoyo/file.c:573
 tomoyo_path_perm+0x2fc/0x420 security/tomoyo/file.c:838
 tomoyo_path_unlink+0x8e/0xd0 security/tomoyo/tomoyo.c:149
 security_path_unlink+0xd7/0x150 security/security.c:1155
 do_unlinkat+0x369/0x660 fs/namei.c:4165
 __do_sys_unlink fs/namei.c:4217 [inline]
 __se_sys_unlink fs/namei.c:4215 [inline]
 __x64_sys_unlink+0x3e/0x50 fs/namei.c:4215
 do_syscall_x64 arch/x86/entry/common.c:50 [inline]
 do_syscall_64+0x35/0xb0 arch/x86/entry/common.c:80
 entry_SYSCALL_64_after_hwframe+0x44/0xae
RIP: 0033:0x7f1b1317153b
Code: 73 01 c3 48 c7 c1 bc ff ff ff f7 d8 64 89 01 48 83 c8 ff c3 66
2e 0f 1f 84 00 00 00 00 00 90 f3 0f 1e fa b8 57 00 00 00 0f 05 <48> 3d
01 f0 ff ff 73 01 c3 48 c7 c1 bc ff ff ff f7 d8 64 89 01 48
RSP: 002b:00007ffd2317ab68 EFLAGS: 00000202 ORIG_RAX: 0000000000000057
RAX: ffffffffffffffda RBX: 0000000000009d6e RCX: 00007f1b1317153b
RDX: 00007ffd2317ab98 RSI: 0000000040086602 RDI: 00007ffd2317ac30
RBP: 00007ffd2317ac30 R08: 0000000000000000 R09: 00007ffd2317a9f0
R10: 0000000000000000 R11: 0000000000000202 R12: 00007f1b131e9e46
R13: 00007ffd2317bcd0 R14: 000055555721ee50 R15: 0000000000000004
----------------
Code disassembly (best guess):
   0: 66 66 2e 0f 1f 84 00 data16 nopw %cs:0x0(%rax,%rax,1)
   7: 00 00 00 00
   b: 0f 1f 00              nopl   (%rax)
   e: 65 48 8b 0c 25 40 f0 mov    %gs:0x1f040,%rcx
  15: 01 00
  17: bf 02 00 00 00        mov    $0x2,%edi
  1c: 48 89 ce              mov    %rcx,%rsi
  1f: 4c 8b 04 24          mov    (%rsp),%r8
  23: e8 76 ff ff ff        callq  0xffffff9e
  28: 84 c0                test   %al,%al
* 2a: 74 20                je     0x4c <-- trapping instruction
  2c: 48 8b 91 20 15 00 00 mov    0x1520(%rcx),%rdx
  33: 8b 89 1c 15 00 00    mov    0x151c(%rcx),%ecx
  39: 48 8b 02              mov    (%rdx),%rax
  3c: 48 83 c0 01          add    $0x1,%rax
