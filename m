Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id B7D90402807
	for <lists+io-uring@lfdr.de>; Tue,  7 Sep 2021 13:50:54 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229827AbhIGLv7 (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Tue, 7 Sep 2021 07:51:59 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:34542 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S241698AbhIGLv7 (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Tue, 7 Sep 2021 07:51:59 -0400
Received: from mail-pj1-x1030.google.com (mail-pj1-x1030.google.com [IPv6:2607:f8b0:4864:20::1030])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 33830C061575;
        Tue,  7 Sep 2021 04:50:53 -0700 (PDT)
Received: by mail-pj1-x1030.google.com with SMTP id j1so6139194pjv.3;
        Tue, 07 Sep 2021 04:50:53 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=mime-version:from:date:message-id:subject:to:cc;
        bh=FIrH1EHJJlehDiSVoWBZEQSuCL6J7GqsVIIbBMxroX4=;
        b=PG4CGeFeTMW5GXiGOAma2eSvW85ivsVVB9ki8WO+HkCmUol4C7SMPg0p93sTSrsqFM
         6DM7RXllvoP7rA0ux7o7n5Frhaqb9PPqMQmFRYvfqBTGxy2p019KsVN/42vLeWW4V6wI
         69TRNMneltaX7p+MzLvY7MzfiqtXqDDunJegObxz4n6mQfj5AlF4ftgwifMJ7JZB/8N/
         Ag1fsKkV7bq18PDCb4KJMxk96Kftps8WfkGXQWfjNh7/HXQRXVuaw+hZ0ivNZFXr4iSE
         Qbzinq/7QP3xxkn0+q/CbiUeOHvqwKAMwRr5VNbEEExzD1R1+/VaEB+k30WhYM8Q0tYM
         fjZQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:from:date:message-id:subject:to:cc;
        bh=FIrH1EHJJlehDiSVoWBZEQSuCL6J7GqsVIIbBMxroX4=;
        b=aBFB9VXsQRraGQBRFy9cjDJcrEsn5dO1Xx2U7NkVJzQO631pfFWjOvnnCWYDMq5q2D
         7ROlVa6zNU4P+Sj0CXJynXxrm7RiVmMnR/ZFAseIUBgIKB0wOR9+Rx+yYeoxkOo4WDw+
         w00VSZ4EogAIBtkBwGRNl7OpvGsmX95EoD+6+Gdz2dN2315+Qas5Oz/eJsqQAfI60Zi3
         /0DL4GxdTwFBK2c5Wd97Wlo+N1KJYOD9Ze64C2V9PdyMEBov2jSFhdb4uoM2wrPmBKGm
         Ku4C7YPc7I2dWWpZ4xTBWA/xeYWy6B4jeKC3Uljwz6zDR4EOmuQG6aZnO2MjkRS5HkpO
         vZYw==
X-Gm-Message-State: AOAM532gD1YBsAQxkglWbIrgYcXn8dRBNH9hNaFlF1ojOQTu0beC/f+F
        rGDBZ5SNRU8oelkP/tzdmRMBJaZjr2HnlUKHgA==
X-Google-Smtp-Source: ABdhPJzPtby+EBQ0gTTFPjZzBa3bb74TN9k56WuzF/1iX5m4VtZLYcN0pTK2N089sCorTZkgF6vXOhbe3tDzHNTqbUA=
X-Received: by 2002:a17:902:e743:b0:13a:eb0:d124 with SMTP id
 p3-20020a170902e74300b0013a0eb0d124mr13873114plf.38.1631015452538; Tue, 07
 Sep 2021 04:50:52 -0700 (PDT)
MIME-Version: 1.0
From:   Hao Sun <sunhao.th@gmail.com>
Date:   Tue, 7 Sep 2021 19:50:41 +0800
Message-ID: <CACkBjsbs2tahJMC_TBZhQUBQiFYhLo-CW+kyzNxyUqgs5NCaXA@mail.gmail.com>
Subject: INFO: task hung in io_uring_cancel_generic
To:     axboe@kernel.dk, io-uring@vger.kernel.org
Cc:     Pavel Begunkov <asml.silence@gmail.com>,
        linux-kernel@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org

Hello,

When using Healer to fuzz the latest Linux kernel, the following crash
was triggered.

HEAD commit: 7d2a07b76933 Linux 5.14
git tree: upstream
console output:
https://drive.google.com/file/d/1c8uRooM0TwJiTIwEviOCB4RC-hhOgGHR/view?usp=sharing
kernel config: https://drive.google.com/file/d/1XD9WYDViQLSXN7RGwH8AGGDvP9JvOghx/view?usp=sharing
Similar report:
https://groups.google.com/u/1/g/syzkaller-bugs/c/FvdcTiJIGtY/m/PcXkoenUAAAJ

Sorry, I don't have a reproducer for this crash, hope the symbolized
report can help.
If you fix this issue, please add the following tag to the commit:
Reported-by: Hao Sun <sunhao.th@gmail.com>

INFO: task syz-executor:10969 blocked for more than 143 seconds.
      Not tainted 5.14.0+ #26
"echo 0 > /proc/sys/kernel/hung_task_timeout_secs" disables this message.
task:syz-executor    state:D stack:28528 pid:10969 ppid:  9213 flags:0x00024004
Call Trace:
 context_switch kernel/sched/core.c:4940 [inline]
 __schedule+0xcd9/0x2530 kernel/sched/core.c:6287
 schedule+0xd3/0x270 kernel/sched/core.c:6366
 io_uring_cancel_generic+0x458/0x740 fs/io_uring.c:9646
 io_uring_files_cancel include/linux/io_uring.h:16 [inline]
 do_exit+0x25c/0x2dd0 kernel/exit.c:780
 do_group_exit+0x125/0x340 kernel/exit.c:922
 get_signal+0x4d5/0x25a0 kernel/signal.c:2868
 arch_do_signal_or_restart+0x2ed/0x1c40 arch/x86/kernel/signal.c:865
 handle_signal_work kernel/entry/common.c:148 [inline]
 exit_to_user_mode_loop kernel/entry/common.c:172 [inline]
 exit_to_user_mode_prepare+0x192/0x2a0 kernel/entry/common.c:209
 __syscall_exit_to_user_mode_work kernel/entry/common.c:291 [inline]
 syscall_exit_to_user_mode+0x19/0x60 kernel/entry/common.c:302
 do_syscall_64+0x42/0xb0 arch/x86/entry/common.c:86
 entry_SYSCALL_64_after_hwframe+0x44/0xae
RIP: 0033:0x4739cd
RSP: 002b:00007fb8de229218 EFLAGS: 00000246 ORIG_RAX: 00000000000000ca
RAX: fffffffffffffe00 RBX: 000000000059c0a0 RCX: 00000000004739cd
RDX: 0000000000000000 RSI: 0000000000000080 RDI: 000000000059c0a8
RBP: 000000000059c0a8 R08: 0000000000000000 R09: 0000000000000000
R10: 0000000000000000 R11: 0000000000000246 R12: 000000000059c0ac
R13: 00007ffc3738731f R14: 00007ffc373874c0 R15: 00007fb8de229300

Showing all locks held in the system:
1 lock held by khungtaskd/1674:
 #0: ffffffff8b97dde0 (rcu_read_lock){....}-{1:2}, at:
debug_show_all_locks+0x53/0x260 kernel/locking/lockdep.c:6446
1 lock held by in:imklog/8129:
 #0: ffff888016f972f0 (&f->f_pos_lock){+.+.}-{3:3}, at:
__fdget_pos+0xe9/0x100 fs/file.c:990

=============================================

NMI backtrace for cpu 1
CPU: 1 PID: 1674 Comm: khungtaskd Not tainted 5.14.0+ #26
Hardware name: QEMU Standard PC (i440FX + PIIX, 1996), BIOS
1.13.0-1ubuntu1.1 04/01/2014
Call Trace:
 __dump_stack lib/dump_stack.c:88 [inline]
 dump_stack_lvl+0xcd/0x134 lib/dump_stack.c:105
 nmi_cpu_backtrace.cold+0x47/0x144 lib/nmi_backtrace.c:105
 nmi_trigger_cpumask_backtrace+0x1e1/0x220 lib/nmi_backtrace.c:62
 trigger_all_cpu_backtrace include/linux/nmi.h:146 [inline]
 check_hung_uninterruptible_tasks kernel/hung_task.c:210 [inline]
 watchdog+0xcc8/0x1010 kernel/hung_task.c:295
 kthread+0x3e5/0x4d0 kernel/kthread.c:319
 ret_from_fork+0x1f/0x30 arch/x86/entry/entry_64.S:295
Sending NMI from CPU 1 to CPUs 0,2-3:
NMI backtrace for cpu 2
CPU: 2 PID: 4927 Comm: systemd-journal Not tainted 5.14.0+ #26
Hardware name: QEMU Standard PC (i440FX + PIIX, 1996), BIOS
1.13.0-1ubuntu1.1 04/01/2014
RIP: 0010:preempt_count arch/x86/include/asm/preempt.h:27 [inline]
RIP: 0010:check_kcov_mode+0x0/0x40 kernel/kcov.c:163
Code: 48 89 df e8 02 80 47 00 e9 59 fe ff ff 48 8b 7c 24 08 e8 f3 7f
47 00 e9 61 fd ff ff cc cc cc cc cc cc cc cc cc cc cc cc cc cc <65> 8b
05 29 d0 8b 7e 89 c2 81 e2 00 01 00 00 a9 00 01 ff 00 74 10
RSP: 0018:ffffc90001077d08 EFLAGS: 00000046
RAX: 0000000000000000 RBX: 0000000000000000 RCX: ffff888014fa9d40
RDX: 0000000000000000 RSI: ffff888014fa9d40 RDI: 0000000000000002
RBP: ffff88802cb20000 R08: ffffffff817c1bfe R09: 0000000000000000
R10: 0000000000000005 R11: ffffed100c7e6531 R12: ffff888010e0af00
R13: 0000000000000200 R14: 0000000000000000 R15: 0000000000000000
FS:  00007f9028f938c0(0000) GS:ffff888063f00000(0000) knlGS:0000000000000000
CS:  0010 DS: 0000 ES: 0000 CR0: 0000000080050033
CR2: 00007f90256da000 CR3: 00000000193df000 CR4: 0000000000750ee0
PKRU: 55555554
Call Trace:
 __sanitizer_cov_trace_pc+0x1a/0x40 kernel/kcov.c:197
 trace_hardirqs_on+0x6e/0x1c0 kernel/trace/trace_preemptirq.c:44
 kasan_quarantine_put+0x11d/0x1c0 mm/kasan/quarantine.c:220
 kasan_slab_free include/linux/kasan.h:230 [inline]
 slab_free_hook mm/slub.c:1628 [inline]
 slab_free_freelist_hook+0xe1/0x240 mm/slub.c:1653
 slab_free mm/slub.c:3213 [inline]
 kmem_cache_free+0x8a/0x5c0 mm/slub.c:3229
 putname+0x10c/0x150 fs/namei.c:270
 do_mkdirat+0x18a/0x2b0 fs/namei.c:3920
 __do_sys_mkdir fs/namei.c:3931 [inline]
 __se_sys_mkdir fs/namei.c:3929 [inline]
 __x64_sys_mkdir+0x61/0x80 fs/namei.c:3929
 do_syscall_x64 arch/x86/entry/common.c:50 [inline]
 do_syscall_64+0x35/0xb0 arch/x86/entry/common.c:80
 entry_SYSCALL_64_after_hwframe+0x44/0xae
RIP: 0033:0x7f902824f687
Code: 00 b8 ff ff ff ff c3 0f 1f 40 00 48 8b 05 09 d8 2b 00 64 c7 00
5f 00 00 00 b8 ff ff ff ff c3 0f 1f 40 00 b8 53 00 00 00 0f 05 <48> 3d
01 f0 ff ff 73 01 c3 48 8b 0d e1 d7 2b 00 f7 d8 64 89 01 48
RSP: 002b:00007ffd1a764c18 EFLAGS: 00000293 ORIG_RAX: 0000000000000053
RAX: ffffffffffffffda RBX: 00007ffd1a767b30 RCX: 00007f902824f687
RDX: 00007f9028cc0a00 RSI: 00000000000001ed RDI: 00005650418998a0
RBP: 00007ffd1a764c50 R08: 000000000000eec0 R09: 0000000000000000
R10: 0000000000000069 R11: 0000000000000293 R12: 0000000000000000
R13: 0000000000000000 R14: 00007ffd1a767b30 R15: 00007ffd1a765140
NMI backtrace for cpu 3
CPU: 3 PID: 15560 Comm: syz-executor Not tainted 5.14.0+ #26
Hardware name: QEMU Standard PC (i440FX + PIIX, 1996), BIOS
1.13.0-1ubuntu1.1 04/01/2014
RIP: 0010:memchr+0x2e/0x80 lib/string.c:1070
Code: 48 bd 00 00 00 00 00 fc ff df 53 48 83 ec 18 eb 26 48 8d 5f 01
48 89 f8 48 89 f9 48 c1 e8 03 83 e1 07 0f b6 04 28 38 c8 7f 04 <84> c0
75 21 40 3a 73 ff 74 11 48 89 df 48 39 d7 75 d5 48 83 c4 18
RSP: 0018:ffffc90007f7f910 EFLAGS: 00000293
RAX: 0000000000000000 RBX: ffffffff90212e86 RCX: 0000000000000005
RDX: ffffffff90212e93 RSI: 000000000000000a RDI: ffffffff90212e85
RBP: dffffc0000000000 R08: ffffffff815dff8f R09: 0000000000000000
R10: 0000000000000005 R11: fffff52000feff84 R12: 0000000000000001
R13: dffffc0000000000 R14: 000000000000001b R15: ffffffff90212e78
FS:  00007f917dcd5700(0000) GS:ffff888135d00000(0000) knlGS:0000000000000000
CS:  0010 DS: 0000 ES: 0000 CR0: 0000000080050033
CR2: 000000000000005f CR3: 00000001133e5000 CR4: 0000000000750ee0
PKRU: 55555554
Call Trace:
 memchr include/linux/fortify-string.h:246 [inline]
 count_lines kernel/printk/printk_ringbuffer.c:1675 [inline]
 copy_data kernel/printk/printk_ringbuffer.c:1721 [inline]
 prb_read kernel/printk/printk_ringbuffer.c:1814 [inline]
 _prb_read_valid+0x3ae/0x6b0 kernel/printk/printk_ringbuffer.c:1880
 prb_read_valid_info+0xa7/0xe0 kernel/printk/printk_ringbuffer.c:1963
 find_first_fitting_seq+0xfd/0x210 kernel/printk/printk.c:1450
 syslog_print_all+0x15a/0x3a0 kernel/printk/printk.c:1590
 do_syslog kernel/printk/printk.c:1669 [inline]
 do_syslog+0x53f/0x650 kernel/printk/printk.c:1632
 __do_sys_syslog kernel/printk/printk.c:1747 [inline]
 __se_sys_syslog kernel/printk/printk.c:1745 [inline]
 __x64_sys_syslog+0x71/0xb0 kernel/printk/printk.c:1745
 do_syscall_x64 arch/x86/entry/common.c:50 [inline]
 do_syscall_64+0x35/0xb0 arch/x86/entry/common.c:80
 entry_SYSCALL_64_after_hwframe+0x44/0xae
RIP: 0033:0x2000010c
Code: 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00
00 fc 0d 00 00 00 00 00 00 36 e1 06 4a 2a e9 2c b8 b6 4c 0f 05 <bf> 03
00 00 00 c4 a3 7b f0 c5 01 41 e2 e9 c4 22 e9 aa bb 3c 00 00
RSP: 002b:00007f917dcd50f8 EFLAGS: 00000203 ORIG_RAX: 0000000000000067
RAX: ffffffffffffffda RBX: 0000000000000009 RCX: 000000002000010c
RDX: 0000000000004c01 RSI: 0000000000000003 RDI: 0000000000000003
RBP: 0000000000000033 R08: 0000000000000005 R09: 0000000000000006
R10: 0000000000000007 R11: 0000000000000203 R12: 000000000000000b
R13: 000000000000000c R14: 000000000000000d R15: 00007f917dcd5300
NMI backtrace for cpu 0 skipped: idling at native_safe_halt
arch/x86/include/asm/irqflags.h:51 [inline]
NMI backtrace for cpu 0 skipped: idling at arch_safe_halt
arch/x86/include/asm/irqflags.h:89 [inline]
NMI backtrace for cpu 0 skipped: idling at default_idle+0xb/0x10
arch/x86/kernel/process.c:716
----------------
Code disassembly (best guess):
   0: 48 89 df              mov    %rbx,%rdi
   3: e8 02 80 47 00        callq  0x47800a
   8: e9 59 fe ff ff        jmpq   0xfffffe66
   d: 48 8b 7c 24 08        mov    0x8(%rsp),%rdi
  12: e8 f3 7f 47 00        callq  0x47800a
  17: e9 61 fd ff ff        jmpq   0xfffffd7d
  1c: cc                    int3
  1d: cc                    int3
  1e: cc                    int3
  1f: cc                    int3
  20: cc                    int3
  21: cc                    int3
  22: cc                    int3
  23: cc                    int3
  24: cc                    int3
  25: cc                    int3
  26: cc                    int3
  27: cc                    int3
  28: cc                    int3
  29: cc                    int3
* 2a: 65 8b 05 29 d0 8b 7e mov    %gs:0x7e8bd029(%rip),%eax        #
0x7e8bd05a <-- trapping instruction
  31: 89 c2                mov    %eax,%edx
  33: 81 e2 00 01 00 00    and    $0x100,%edx
  39: a9 00 01 ff 00        test   $0xff0100,%eax
  3e: 74 10                je     0x50%
