Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 4D5E942D06D
	for <lists+io-uring@lfdr.de>; Thu, 14 Oct 2021 04:30:26 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229892AbhJNCc3 (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Wed, 13 Oct 2021 22:32:29 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:45932 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229882AbhJNCc2 (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Wed, 13 Oct 2021 22:32:28 -0400
Received: from mail-pj1-x1032.google.com (mail-pj1-x1032.google.com [IPv6:2607:f8b0:4864:20::1032])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id CF8C0C061570;
        Wed, 13 Oct 2021 19:30:24 -0700 (PDT)
Received: by mail-pj1-x1032.google.com with SMTP id kk10so3680309pjb.1;
        Wed, 13 Oct 2021 19:30:24 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=mime-version:from:date:message-id:subject:to:cc;
        bh=5TfSYwPVCreRqvYRDnReTo0UAgBThbgMSWbbZKWTk3E=;
        b=Ivid6cDDH8YkHeViErsuuGUbJMc8cr+ewB6vehMrtEttFaP1ESEqAVzLFymLBCJGqw
         kmAU59iV8izS9rtoCC5fOO44W5HgnhAMSOPqu2UhSDKO9WE7NZFHq8ySML27SbM4f/1T
         RjBHGkePT3SCdSVK6ybzacqjc+2SdKymhZXCPmCCKyjI9gXpug41Gjvju463Phr41A3Q
         12uSaj6OAGRBYwssBfQ6fb4AqF2EJ7UxicbEAB1Qr2/tHakbYRYMJLmATQqumooGaAt8
         TCrIHA7BWQ9I9Zo8PEy034E49OeP+JENWCJ3n2KvXpX+N/tEBJ96NaLp6Nt1N2jGvpMr
         kNHg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:mime-version:from:date:message-id:subject:to:cc;
        bh=5TfSYwPVCreRqvYRDnReTo0UAgBThbgMSWbbZKWTk3E=;
        b=N0+wFN55mijDyZb/Q7xzd/TLZ8NSr+bMy/fp1gvpS9Rf5CLKK0eHKDc/BsAVOloJOs
         46DXJAlIN8NkoxCpSrixdhEQp3QqU0KLMX2rd76da44qf2nGXIdlaUZFaoqzK0IuXdgS
         8tztOGuuXUOJ0+ji/MYTgqg88yEahFo3wprNXE41NTnr4eOajj/nVT0UxrQIibDtkEQq
         bVF7Ymdm8YMcPCQ7hEjQqToJ328G4KXRyepZg5on8Rbgs1h+LKYTN13EaK9PsTCe5bEN
         C5c+zSnoG4q9Vf/hkUgfjWRkHi6OQaT7dWjrokIQ1kNZlLrPwVWvTILWzRnWAkJJBr+g
         m6zg==
X-Gm-Message-State: AOAM533HulcQjRnD/+AHvRibboXCoExGZ8uQNsPtR1TEHuD/zNZFNOr9
        0XABaIypPmE+8XFT6Ms8kXIjtnPEqWgOoPIVd7ovSdOGD4Ul+QM=
X-Google-Smtp-Source: ABdhPJwEkp01ZY+81HXvtoTEZBS7OLKcIpjjXUtC0l3MIKm5lYWR6x1MhqIc4OTpWJBUF1W81t1fTA2p6j92V+rKwf4=
X-Received: by 2002:a17:902:e5cb:b0:13f:25b7:4d50 with SMTP id
 u11-20020a170902e5cb00b0013f25b74d50mr2605248plf.38.1634178624150; Wed, 13
 Oct 2021 19:30:24 -0700 (PDT)
MIME-Version: 1.0
From:   Hao Sun <sunhao.th@gmail.com>
Date:   Thu, 14 Oct 2021 10:30:13 +0800
Message-ID: <CACkBjsYuWu4JdnBF8H_jo0s0AD-UQD-r8kr-JRjgepsVgD18=w@mail.gmail.com>
Subject: INFO: task hung in io_wqe_worker
To:     Pavel Begunkov <asml.silence@gmail.com>,
        Jens Axboe <axboe@kernel.dk>, io-uring@vger.kernel.org
Cc:     Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org

Hello,

When using Healer to fuzz the latest Linux kernel, the following crash
was triggered.

HEAD commit: 64570fbc14f8 Linux 5.15-rc5
git tree: upstream
console output:
https://drive.google.com/file/d/1hdBEBUsJntgG25NqJZm8rSQTgcqf5S36/view?usp=sharing
kernel config: https://drive.google.com/file/d/1em3xgUIMNN_-LUUdySzwN-UDPc3qiiKD/view?usp=sharing

Sorry, I don't have a reproducer for this crash, hope the symbolized
report can help.
If you fix this issue, please add the following tag to the commit:
Reported-by: Hao Sun <sunhao.th@gmail.com>

INFO: task iou-wrk-13358:13360 blocked for more than 143 seconds.
      Not tainted 5.15.0-rc5 #3
"echo 0 > /proc/sys/kernel/hung_task_timeout_secs" disables this message.
task:iou-wrk-13358   state:D stack:29952 pid:13360 ppid: 12622 flags:0x00004004
Call Trace:
 context_switch kernel/sched/core.c:4940 [inline]
 __schedule+0xcd9/0x2530 kernel/sched/core.c:6287
 schedule+0xd3/0x270 kernel/sched/core.c:6366
 schedule_timeout+0x5e5/0x890 kernel/time/timer.c:1857
 do_wait_for_common kernel/sched/completion.c:85 [inline]
 __wait_for_common kernel/sched/completion.c:106 [inline]
 wait_for_common kernel/sched/completion.c:117 [inline]
 wait_for_completion+0x17d/0x280 kernel/sched/completion.c:138
 io_worker_exit fs/io-wq.c:183 [inline]
 io_wqe_worker+0x72e/0xc90 fs/io-wq.c:597
 ret_from_fork+0x1f/0x30 arch/x86/entry/entry_64.S:295
INFO: lockdep is turned off.
NMI backtrace for cpu 0
CPU: 0 PID: 40 Comm: khungtaskd Not tainted 5.15.0-rc5 #3
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
Sending NMI from CPU 0 to CPUs 1-3:
NMI backtrace for cpu 3
CPU: 3 PID: 3017 Comm: systemd-journal Not tainted 5.15.0-rc5 #3
Hardware name: QEMU Standard PC (i440FX + PIIX, 1996), BIOS
1.13.0-1ubuntu1.1 04/01/2014
RIP: 0010:check_preemption_disabled+0x31/0x170 lib/smp_processor_id.c:16
Code: 41 54 55 48 89 fd 53 0f 1f 44 00 00 65 44 8b 25 9d b6 ce 76 65
8b 1d 2e 11 cf 76 81 e3 ff ff ff 7f 31 ff 89 de 0f 1f 44 00 00 <85> db
74 11 0f 1f 44 00 00 44 89 e0 5b 5d 41 5c 41 5d 41 5e c3 0f
RSP: 0018:ffffc9000124fee8 EFLAGS: 00000046
RAX: 0000000000000001 RBX: 0000000000000000 RCX: 1ffffffff1adb731
RDX: 0000000000000000 RSI: 0000000000000000 RDI: 0000000000000000
RBP: ffffffff89e43240 R08: ffffffff8932da7e R09: 0000000000000000
R10: 0000000000000001 R11: fffffbfff1adb0b2 R12: 0000000000000003
R13: ffffffff899509e0 R14: 0000000000000000 R15: 0000000000000000
FS:  00007fa5748518c0(0000) GS:ffff888135d00000(0000) knlGS:0000000000000000
CS:  0010 DS: 0000 ES: 0000 CR0: 0000000080050033
CR2: 00007fa571e89018 CR3: 0000000014595000 CR4: 0000000000350ee0
Call Trace:
 __context_tracking_enter+0x51/0x100 kernel/context_tracking.c:70
 user_enter_irqoff include/linux/context_tracking.h:41 [inline]
 __exit_to_user_mode kernel/entry/common.c:130 [inline]
 syscall_exit_to_user_mode+0x48/0x60 kernel/entry/common.c:302
 do_syscall_64+0x42/0xb0 arch/x86/entry/common.c:86
 entry_SYSCALL_64_after_hwframe+0x44/0xae
RIP: 0033:0x7fa573de1210
Code: 73 01 c3 48 8b 0d 98 7d 20 00 f7 d8 64 89 01 48 83 c8 ff c3 66
0f 1f 44 00 00 83 3d b9 c1 20 00 00 75 10 b8 00 00 00 00 0f 05 <48> 3d
01 f0 ff ff 73 31 c3 48 83 ec 08 e8 4e fc ff ff 48 89 04 24
RSP: 002b:00007ffc0019fba8 EFLAGS: 00000246 ORIG_RAX: 0000000000000000
RAX: 0000000000000037 RBX: 00007ffc001a2620 RCX: 00007fa573de1210
RDX: 0000000000002000 RSI: 00007ffc001a0420 RDI: 0000000000000009
RBP: 0000000000000000 R08: 0000000000000008 R09: 00007ffc001f00f0
R10: 000000000001297e R11: 0000000000000246 R12: 00007ffc001a0420
R13: 00007ffc001a2578 R14: 00005610cf4ba958 R15: 0005ce2963112ee5
NMI backtrace for cpu 1
CPU: 1 PID: 6291 Comm: rs:main Q:Reg Not tainted 5.15.0-rc5 #3
Hardware name: QEMU Standard PC (i440FX + PIIX, 1996), BIOS
1.13.0-1ubuntu1.1 04/01/2014
RIP: 0010:orc_ip arch/x86/kernel/unwind_orc.c:30 [inline]
RIP: 0010:__orc_find+0x6f/0xf0 arch/x86/kernel/unwind_orc.c:52
Code: 72 4d 4c 89 e2 48 29 ea 48 89 d0 48 c1 ea 3f 48 c1 f8 02 48 01
c2 48 d1 fa 48 8d 5c 95 00 48 89 d8 48 c1 e8 03 42 0f b6 14 38 <48> 89
d8 83 e0 07 83 c0 03 38 d0 7c 04 84 d2 75 48 48 63 13 48 01
RSP: 0018:ffffc9000fe5f268 EFLAGS: 00000213
RAX: 1ffffffff1b08658 RBX: ffffffff8d8432c4 RCX: ffffffff81d980ef
RDX: 0000000000000000 RSI: ffffffff8df65e26 RDI: ffffffff8d8432b0
RBP: ffffffff8d8432b0 R08: 0000000000000000 R09: ffffffff8df65e26
R10: ffffc9000fe5f407 R11: 0000000000086088 R12: ffffffff8d8432dc
R13: ffffffff8d8432b0 R14: ffffffff8d8432b0 R15: dffffc0000000000
FS:  00007fbe3fbba700(0000) GS:ffff888135c00000(0000) knlGS:0000000000000000
CS:  0010 DS: 0000 ES: 0000 CR0: 0000000080050033
CR2: 000055dd85e43be0 CR3: 0000000019a84000 CR4: 0000000000350ee0
Call Trace:
 orc_find arch/x86/kernel/unwind_orc.c:173 [inline]
 unwind_next_frame+0x33a/0x1770 arch/x86/kernel/unwind_orc.c:443
 arch_stack_walk+0x7d/0xe0 arch/x86/kernel/stacktrace.c:25
 stack_trace_save+0x8c/0xc0 kernel/stacktrace.c:121
 kasan_save_stack+0x1b/0x40 mm/kasan/common.c:38
 kasan_set_track mm/kasan/common.c:46 [inline]
 set_alloc_info mm/kasan/common.c:434 [inline]
 __kasan_slab_alloc+0x83/0xb0 mm/kasan/common.c:467
 kasan_slab_alloc include/linux/kasan.h:254 [inline]
 slab_post_alloc_hook+0x4d/0x4b0 mm/slab.h:519
 slab_alloc_node mm/slub.c:3206 [inline]
 slab_alloc mm/slub.c:3214 [inline]
 kmem_cache_alloc+0x150/0x340 mm/slub.c:3219
 kmem_cache_zalloc include/linux/slab.h:711 [inline]
 alloc_buffer_head+0x20/0x110 fs/buffer.c:3309
 alloc_page_buffers+0x2a5/0x820 fs/buffer.c:832
 create_empty_buffers+0x2c/0x8e0 fs/buffer.c:1560
 ext4_block_write_begin+0x10d2/0x1760 fs/ext4/inode.c:1060
 ext4_da_write_begin+0x3eb/0xad0 fs/ext4/inode.c:2969
 generic_perform_write+0x1fe/0x510 mm/filemap.c:3770
 ext4_buffered_write_iter+0x206/0x4c0 fs/ext4/file.c:269
 ext4_file_write_iter+0x42e/0x14a0 fs/ext4/file.c:680
 call_write_iter include/linux/fs.h:2163 [inline]
 new_sync_write+0x432/0x660 fs/read_write.c:507
 vfs_write+0x67a/0xae0 fs/read_write.c:594
 ksys_write+0x12d/0x250 fs/read_write.c:647
 do_syscall_x64 arch/x86/entry/common.c:50 [inline]
 do_syscall_64+0x35/0xb0 arch/x86/entry/common.c:80
 entry_SYSCALL_64_after_hwframe+0x44/0xae
RIP: 0033:0x7fbe425fe1cd
Code: c2 20 00 00 75 10 b8 01 00 00 00 0f 05 48 3d 01 f0 ff ff 73 31
c3 48 83 ec 08 e8 ae fc ff ff 48 89 04 24 b8 01 00 00 00 0f 05 <48> 8b
3c 24 48 89 c2 e8 f7 fc ff ff 48 89 d0 48 83 c4 08 48 3d 01
RSP: 002b:00007fbe3fbb9590 EFLAGS: 00000293 ORIG_RAX: 0000000000000001
RAX: ffffffffffffffda RBX: 00007fbe30006840 RCX: 00007fbe425fe1cd
RDX: 00000000000007e0 RSI: 00007fbe30006840 RDI: 0000000000000006
RBP: 0000000000000000 R08: 0000000000000000 R09: 00007fbe41758487
R10: 0000000000000000 R11: 0000000000000293 R12: 00007fbe300065c0
R13: 00007fbe3fbb95b0 R14: 000055758f55f360 R15: 00000000000007e0
NMI backtrace for cpu 2 skipped: idling at native_safe_halt
arch/x86/include/asm/irqflags.h:51 [inline]
NMI backtrace for cpu 2 skipped: idling at arch_safe_halt
arch/x86/include/asm/irqflags.h:89 [inline]
NMI backtrace for cpu 2 skipped: idling at default_idle+0xb/0x10
arch/x86/kernel/process.c:716
----------------
Code disassembly (best guess):
   0: 41 54                push   %r12
   2: 55                    push   %rbp
   3: 48 89 fd              mov    %rdi,%rbp
   6: 53                    push   %rbx
   7: 0f 1f 44 00 00        nopl   0x0(%rax,%rax,1)
   c: 65 44 8b 25 9d b6 ce mov    %gs:0x76ceb69d(%rip),%r12d        # 0x76ceb6b1
  13: 76
  14: 65 8b 1d 2e 11 cf 76 mov    %gs:0x76cf112e(%rip),%ebx        # 0x76cf1149
  1b: 81 e3 ff ff ff 7f    and    $0x7fffffff,%ebx
  21: 31 ff                xor    %edi,%edi
  23: 89 de                mov    %ebx,%esi
  25: 0f 1f 44 00 00        nopl   0x0(%rax,%rax,1)
* 2a: 85 db                test   %ebx,%ebx <-- trapping instruction
  2c: 74 11                je     0x3f
  2e: 0f 1f 44 00 00        nopl   0x0(%rax,%rax,1)
  33: 44 89 e0              mov    %r12d,%eax
  36: 5b                    pop    %rbx
  37: 5d                    pop    %rbp
  38: 41 5c                pop    %r12
  3a: 41 5d                pop    %r13
  3c: 41 5e                pop    %r14
  3e: c3                    retq
  3f: 0f                    .byte 0xf
