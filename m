Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 465AA42D065
	for <lists+io-uring@lfdr.de>; Thu, 14 Oct 2021 04:28:09 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229496AbhJNCaK (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Wed, 13 Oct 2021 22:30:10 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:45410 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229992AbhJNCaK (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Wed, 13 Oct 2021 22:30:10 -0400
Received: from mail-pj1-x1030.google.com (mail-pj1-x1030.google.com [IPv6:2607:f8b0:4864:20::1030])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 09D90C061570;
        Wed, 13 Oct 2021 19:28:06 -0700 (PDT)
Received: by mail-pj1-x1030.google.com with SMTP id ls18so3657398pjb.3;
        Wed, 13 Oct 2021 19:28:06 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=mime-version:from:date:message-id:subject:to:cc;
        bh=kpnlanDVmAbSRkt717gR/dCVidax45ruzhrwKrZGbTY=;
        b=HOBgXQi0U89P0QwyOKtWlvRG6h52UGFOKlXVLwDYwz5puUlVrbbppb9CoDWmNZMjZv
         B3EpuGWOtN8Cf67ZBjf9DnCkj8pw3SOZeJiY2H5Ap3CFFq5ugF+0PyUEbImlfctHrzPD
         1X+j2vRQ4t36TWmERIw6lytJAwoEMV6vFUgBJHibGWK6PxAOZ5AGhaS4uq+vAn7DiFT6
         62EBqPoHTYIUry0C43tiXRGTvYkFwV3l+7N9cdCQGCYNtAmViHk/ThZc4cNtYL90GEZl
         pUzIvDhkZWxU106/pHZAjro7MI6Tg9wS0DikX20Sjh8rExV+hJ5wibJpNPP4oydVuaTP
         P5xQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:mime-version:from:date:message-id:subject:to:cc;
        bh=kpnlanDVmAbSRkt717gR/dCVidax45ruzhrwKrZGbTY=;
        b=LPt6bSlhW13A1kMcYlPxeML47xCmj1b3pCpCVZUzNHNSBcgyftDpG9cIrftJ60ub4f
         7JxzloySUf+QSjCJ2YBbQFeDJraoZ4OxIASvFgxn/cQzD7ywjQRvcabzgpbGSY/jv9br
         4hvMLFnZXdWJlbL2H95m97vu3/HG6M+ME8S+rdUw+wq6XOPbOFcJsh3bKEv3AireT4T+
         7Jxa7kChFb/9+wIskNrI4/7tSZ4mMzZYiv+NYmK2SbOV5o+e/y9hwlj9CdgPoCDqEVvD
         Z97FwOfhPpGrniSJ1/IwZwrhkmGqstt6tjH3rmu5ONteo2KqECAQ+Ts6/FLtGLMKjxXA
         n6aw==
X-Gm-Message-State: AOAM532JPFQft37f/prBvypJzSAz+yOkVSrmh+o4SEaEeQyLo0yvyecA
        Ax14ppoomRCE2YyGqLDqup2WB2Z5RxFAWJ5lQTfY0+Hu+myz
X-Google-Smtp-Source: ABdhPJwrjt5UT3QJM4Axp37g67DE/5z9Eus70nmWaISp3HiTmetIcW7B/+TOgNfmcSfBP/3SO9KbNA4x5xnd6ltBYow=
X-Received: by 2002:a17:90b:17ce:: with SMTP id me14mr3373293pjb.112.1634178485348;
 Wed, 13 Oct 2021 19:28:05 -0700 (PDT)
MIME-Version: 1.0
From:   Hao Sun <sunhao.th@gmail.com>
Date:   Thu, 14 Oct 2021 10:27:54 +0800
Message-ID: <CACkBjsZawnG=g7yMAgLiXxFggzuzwnJ2yq=340az7tG37HKHyQ@mail.gmail.com>
Subject: INFO: task hung in io_ring_exit_work
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
https://drive.google.com/file/d/1JeHQP3cxmLK6WDSLxyOrUGLDujuTCXeU/view?usp=sharing
kernel config: https://drive.google.com/file/d/1em3xgUIMNN_-LUUdySzwN-UDPc3qiiKD/view?usp=sharing
Similar report from syzbot:
https://syzkaller.appspot.com/bug?id=db58a4022d476752fca3c46386b33ca799d3a7f0

Sorry, I don't have a reproducer for this crash, hope the symbolized
report can help.
If you fix this issue, please add the following tag to the commit:
Reported-by: Hao Sun <sunhao.th@gmail.com>

INFO: task kworker/u10:0:24 blocked for more than 143 seconds.
      Not tainted 5.15.0-rc5 #3
"echo 0 > /proc/sys/kernel/hung_task_timeout_secs" disables this message.
task:kworker/u10:0   state:D stack:24944 pid:   24 ppid:     2 flags:0x00004000
Workqueue: events_unbound io_ring_exit_work
Call Trace:
 context_switch kernel/sched/core.c:4940 [inline]
 __schedule+0xcd9/0x2530 kernel/sched/core.c:6287
 schedule+0xd3/0x270 kernel/sched/core.c:6366
 schedule_timeout+0x5e5/0x890 kernel/time/timer.c:1857
 do_wait_for_common kernel/sched/completion.c:85 [inline]
 __wait_for_common kernel/sched/completion.c:106 [inline]
 wait_for_common kernel/sched/completion.c:117 [inline]
 wait_for_completion+0x17d/0x280 kernel/sched/completion.c:138
 io_ring_exit_work+0x530/0x1550 fs/io_uring.c:9442
 process_one_work+0x9df/0x16d0 kernel/workqueue.c:2297
 worker_thread+0x90/0xed0 kernel/workqueue.c:2444
 kthread+0x3e5/0x4d0 kernel/kthread.c:319
 ret_from_fork+0x1f/0x30 arch/x86/entry/entry_64.S:295
INFO: lockdep is turned off.
NMI backtrace for cpu 0
CPU: 0 PID: 39 Comm: khungtaskd Not tainted 5.15.0-rc5 #3
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
NMI backtrace for cpu 1
CPU: 1 PID: 13884 Comm: syz-executor Not tainted 5.15.0-rc5 #3
Hardware name: QEMU Standard PC (i440FX + PIIX, 1996), BIOS
1.13.0-1ubuntu1.1 04/01/2014
RIP: 0010:irqentry_enter+0x28/0x50 kernel/entry/common.c:380
Code: 00 00 f6 87 88 00 00 00 03 75 37 65 48 8b 04 25 40 f0 01 00 f6
40 2c 02 48 8b 3c 24 75 0f e8 1f f4 ff ff eb 00 e8 d8 87 49 f8 <31> c0
c3 e8 10 f4 ff ff e8 cb fc ff ff e8 c6 87 49 f8 b8 01 00 00
RSP: 0018:ffffc90009db7db0 EFLAGS: 00000046
RAX: 0000000000000000 RBX: 0000000000000000 RCX: ffff888017765580
RDX: 0000000000000000 RSI: ffff888017765580 RDI: 0000000000000002
RBP: ffffc90009db7de8 R08: ffffffff8932db28 R09: 0000000000000000
R10: 0000000000000001 R11: fffffbfff1adb0b2 R12: 0000000000000000
R13: 0000000000000000 R14: 0000000000000003 R15: 0000000000000000
FS:  00007ff54513e700(0000) GS:ffff888135c00000(0000) knlGS:0000000000000000
CS:  0010 DS: 0000 ES: 0000 CR0: 0000000080050033
CR2: 0000000000000003 CR3: 00000000149e3000 CR4: 0000000000350ee0
Call Trace:
 exc_page_fault+0x45/0x180 arch/x86/mm/fault.c:1538
 asm_exc_page_fault+0x1e/0x30 arch/x86/include/asm/idtentry.h:568
RIP: 0010:do_strncpy_from_user lib/strncpy_from_user.c:41 [inline]
RIP: 0010:strncpy_from_user+0x1e6/0x3f0 lib/strncpy_from_user.c:139
Code: 83 eb 08 4d 89 7c 2d 00 bf 07 00 00 00 48 83 c5 08 48 89 de e8
cb 40 7b fd 48 83 fb 07 0f 86 c4 01 00 00 e8 3c 3f 7b fd 31 c0 <4d> 8b
3c 2c 31 ff 89 c6 89 04 24 e8 8a 40 7b fd 8b 04 24 85 c0 0f
RSP: 0018:ffffc90009db7e90 EFLAGS: 00050246
RAX: 0000000000000000 RBX: 0000000000000fe0 RCX: ffff888017765580
RDX: 0000000000000000 RSI: ffff888017765580 RDI: 0000000000000002
RBP: 0000000000000000 R08: ffffffff83fb1f84 R09: 0000000000000007
R10: 0000000000000007 R11: fffff94000862c40 R12: 0000000000000003
R13: ffff88810c589120 R14: 0000000000000fe0 R15: 0000000000000fe3
 getname_flags fs/namei.c:149 [inline]
 getname_flags+0x117/0x5b0 fs/namei.c:128
 getname fs/namei.c:217 [inline]
 __do_sys_rename fs/namei.c:4825 [inline]
 __se_sys_rename fs/namei.c:4823 [inline]
 __x64_sys_rename+0x56/0xa0 fs/namei.c:4823
 do_syscall_x64 arch/x86/entry/common.c:50 [inline]
 do_syscall_64+0x35/0xb0 arch/x86/entry/common.c:80
 entry_SYSCALL_64_after_hwframe+0x44/0xae
RIP: 0033:0x2000028a
Code: 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00
00 00 00 00 00 00 00 00 00 00 00 98 4a 2a e9 2c b8 b6 4c 0f 05 <bf> 00
00 40 00 c4 a3 7b f0 c5 01 41 e2 e9 c4 22 e9 aa bb 3c 00 00
RSP: 002b:00007ff54513dbb8 EFLAGS: 00000203 ORIG_RAX: 0000000000000052
RAX: ffffffffffffffda RBX: 0000000000000009 RCX: 000000002000028a
RDX: 0000000000004c01 RSI: 0000000000000003 RDI: 0000000000400000
RBP: 000000000000008b R08: 0000000000000005 R09: 0000000000000006
R10: 0000000000000007 R11: 0000000000000203 R12: 000000000000000b
R13: 000000000000000c R14: 000000000000000d R15: 00007ff54513ddc0
NMI backtrace for cpu 2 skipped: idling at native_safe_halt
arch/x86/include/asm/irqflags.h:51 [inline]
NMI backtrace for cpu 2 skipped: idling at arch_safe_halt
arch/x86/include/asm/irqflags.h:89 [inline]
NMI backtrace for cpu 2 skipped: idling at default_idle+0xb/0x10
arch/x86/kernel/process.c:716
NMI backtrace for cpu 3
CPU: 3 PID: 3019 Comm: systemd-journal Not tainted 5.15.0-rc5 #3
Hardware name: QEMU Standard PC (i440FX + PIIX, 1996), BIOS
1.13.0-1ubuntu1.1 04/01/2014
RIP: 0033:0x7ffc3d1c69b5
Code: 00 0f 84 b9 00 00 00 4c 63 cf 49 c1 e1 04 4d 01 c1 45 8b 10 41
f6 c2 01 0f 85 8d 00 00 00 41 8b 40 04 83 f8 01 75 6f 0f 01 f9 <66> 90
48 c1 e2 20 48 09 c2 48 85 d2 78 63 49 8b 48 08 49 8b 41 28
RSP: 002b:00007ffc3d110910 EFLAGS: 00000246
RAX: 000000007fa7dd4e RBX: 0000000000000007 RCX: 0000000000001003
RDX: 0000000000000096 RSI: 00007ffc3d110960 RDI: 0000000000000007
RBP: 00007ffc3d110930 R08: 00007ffc3d1c2080 R09: 00007ffc3d1c20f0
R10: 000000000000dd10 R11: 000000000000011d R12: 00007ffc3d1109a0
R13: 0000000000000001 R14: 0000000000000001 R15: 0005ce1974964533
FS:  00007f9157d9a8c0 GS:  0000000000000000
----------------
Code disassembly (best guess):
   0: 00 00                add    %al,(%rax)
   2: f6 87 88 00 00 00 03 testb  $0x3,0x88(%rdi)
   9: 75 37                jne    0x42
   b: 65 48 8b 04 25 40 f0 mov    %gs:0x1f040,%rax
  12: 01 00
  14: f6 40 2c 02          testb  $0x2,0x2c(%rax)
  18: 48 8b 3c 24          mov    (%rsp),%rdi
  1c: 75 0f                jne    0x2d
  1e: e8 1f f4 ff ff        callq  0xfffff442
  23: eb 00                jmp    0x25
  25: e8 d8 87 49 f8        callq  0xf8498802
* 2a: 31 c0                xor    %eax,%eax <-- trapping instruction
  2c: c3                    retq
  2d: e8 10 f4 ff ff        callq  0xfffff442
  32: e8 cb fc ff ff        callq  0xfffffd02
  37: e8 c6 87 49 f8        callq  0xf8498802
  3c: b8                    .byte 0xb8
  3d: 01 00                add    %eax,(%rax)%
