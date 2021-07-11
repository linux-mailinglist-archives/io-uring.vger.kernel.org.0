Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 2913F3C3DA7
	for <lists+io-uring@lfdr.de>; Sun, 11 Jul 2021 17:27:09 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235728AbhGKP3y (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Sun, 11 Jul 2021 11:29:54 -0400
Received: from mail-il1-f197.google.com ([209.85.166.197]:36738 "EHLO
        mail-il1-f197.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S235702AbhGKP3y (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Sun, 11 Jul 2021 11:29:54 -0400
Received: by mail-il1-f197.google.com with SMTP id h17-20020a056e021d91b02902004a17fb0aso10186444ila.3
        for <io-uring@vger.kernel.org>; Sun, 11 Jul 2021 08:27:07 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:date:in-reply-to:message-id:subject
         :from:to;
        bh=dZEK6nTFfkV4goGQ4GXCl5xxN0f/xTz9QHPehmetKY0=;
        b=hQc0evUhDMu8QnanL0QD2jPQ4ZmFQC0C38Akvh2p538S2r3kDzMK6i5UOW3ggKEGS0
         4H6tA1OvMtCXjsTSVuAaBndmlCn18/cljzkmCfIRwnxpp4Yrbr/z2HiO+U5tw4BGkip/
         12ny4vYbHy5Awf3yrb4ZUIqLGp4xFlA4CdRofbk+R2Mdgt4udX++rnqnaxTFxt4yyZ7i
         8q8Hpo8RNbMCwghstF1sl376Z0IOy29RVjaY+PhG4qAzOJWVFPdavNZZn2snggI+McvN
         YBvLewvfp/5fkbOh0tVMxtOPEBpF5rsBHEy8PgX61i6sGTVVXDeQi0D1jgf3GZCWEYMC
         ghoA==
X-Gm-Message-State: AOAM5329f3Zh5qatLDR7lavJdZc28AjEiFDIVqiJLXynSeaeFoAdjmMY
        dn7hXqWcSD591AUKljai7N65ZvDh8DQKnA924sIElrvzvpkE
X-Google-Smtp-Source: ABdhPJy61WBTYD7i10gg0M1QAC5oufwxBSHdGqXe5sH+MEYWmd6pU0XFC6WxCClO4559Bcp1g40AnwR1S9NCMAGQPVJg6ZOU23Zk
MIME-Version: 1.0
X-Received: by 2002:a92:c0c3:: with SMTP id t3mr2350185ilf.80.1626017227540;
 Sun, 11 Jul 2021 08:27:07 -0700 (PDT)
Date:   Sun, 11 Jul 2021 08:27:07 -0700
In-Reply-To: <8c598db4-396c-2193-6353-9f3a6be49b5d@kernel.dk>
X-Google-Appengine-App-Id: s~syzkaller
X-Google-Appengine-App-Id-Alias: syzkaller
Message-ID: <0000000000003f0feb05c6daa326@google.com>
Subject: Re: [syzbot] INFO: task hung in io_uring_cancel_generic
From:   syzbot <syzbot+ba6fcd859210f4e9e109@syzkaller.appspotmail.com>
To:     asml.silence@gmail.com, axboe@kernel.dk, io-uring@vger.kernel.org,
        linux-kernel@vger.kernel.org, syzkaller-bugs@googlegroups.com
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org

Hello,

syzbot has tested the proposed patch but the reproducer is still triggering an issue:
INFO: task hung in io_uring_cancel_generic

INFO: task syz-executor.5:10156 blocked for more than 143 seconds.
      Tainted: G        W         5.13.0-syzkaller #0
"echo 0 > /proc/sys/kernel/hung_task_timeout_secs" disables this message.
task:syz-executor.5  state:D stack:27976 pid:10156 ppid:  8832 flags:0x00004004
Call Trace:
 context_switch kernel/sched/core.c:4683 [inline]
 __schedule+0x934/0x2710 kernel/sched/core.c:5940
 schedule+0xd3/0x270 kernel/sched/core.c:6019
 io_uring_cancel_generic+0x54d/0x890 fs/io_uring.c:9148
 io_uring_files_cancel include/linux/io_uring.h:16 [inline]
 do_exit+0x28b/0x2a50 kernel/exit.c:780
 do_group_exit+0x125/0x310 kernel/exit.c:922
 get_signal+0x47f/0x2150 kernel/signal.c:2796
 arch_do_signal_or_restart+0x2a9/0x1eb0 arch/x86/kernel/signal.c:789
 handle_signal_work kernel/entry/common.c:148 [inline]
 exit_to_user_mode_loop kernel/entry/common.c:172 [inline]
 exit_to_user_mode_prepare+0x17d/0x290 kernel/entry/common.c:209
 __syscall_exit_to_user_mode_work kernel/entry/common.c:291 [inline]
 syscall_exit_to_user_mode+0x19/0x60 kernel/entry/common.c:302
 do_syscall_64+0x42/0xb0 arch/x86/entry/common.c:86
 entry_SYSCALL_64_after_hwframe+0x44/0xae
RIP: 0033:0x4665d9
RSP: 002b:00007fc32f0d4218 EFLAGS: 00000246 ORIG_RAX: 00000000000000ca
RAX: fffffffffffffe00 RBX: 000000000056bf88 RCX: 00000000004665d9
RDX: 0000000000000000 RSI: 0000000000000080 RDI: 000000000056bf88
RBP: 000000000056bf80 R08: 0000000000000000 R09: 0000000000000000
R10: 0000000000000000 R11: 0000000000000246 R12: 000000000056bf8c
R13: 00007ffee94563df R14: 00007fc32f0d4300 R15: 0000000000022000
INFO: task syz-executor.2:10228 blocked for more than 143 seconds.
      Tainted: G        W         5.13.0-syzkaller #0
"echo 0 > /proc/sys/kernel/hung_task_timeout_secs" disables this message.
task:syz-executor.2  state:D stack:29192 pid:10228 ppid:  8825 flags:0x00004004
Call Trace:
 context_switch kernel/sched/core.c:4683 [inline]
 __schedule+0x934/0x2710 kernel/sched/core.c:5940
 schedule+0xd3/0x270 kernel/sched/core.c:6019
 io_uring_cancel_generic+0x54d/0x890 fs/io_uring.c:9148
 io_uring_files_cancel include/linux/io_uring.h:16 [inline]
 do_exit+0x28b/0x2a50 kernel/exit.c:780
 do_group_exit+0x125/0x310 kernel/exit.c:922
 get_signal+0x47f/0x2150 kernel/signal.c:2796
 arch_do_signal_or_restart+0x2a9/0x1eb0 arch/x86/kernel/signal.c:789
 handle_signal_work kernel/entry/common.c:148 [inline]
 exit_to_user_mode_loop kernel/entry/common.c:172 [inline]
 exit_to_user_mode_prepare+0x17d/0x290 kernel/entry/common.c:209
 __syscall_exit_to_user_mode_work kernel/entry/common.c:291 [inline]
 syscall_exit_to_user_mode+0x19/0x60 kernel/entry/common.c:302
 do_syscall_64+0x42/0xb0 arch/x86/entry/common.c:86
 entry_SYSCALL_64_after_hwframe+0x44/0xae
RIP: 0033:0x4665d9
RSP: 002b:00007f48eed2e218 EFLAGS: 00000246 ORIG_RAX: 00000000000000ca
RAX: 0000000000000000 RBX: 000000000056bf88 RCX: 00000000004665d9
RDX: 0000000000000000 RSI: 0000000000000080 RDI: 000000000056bf88
RBP: 000000000056bf80 R08: 0000000000000000 R09: 0000000000000000
R10: 0000000000000000 R11: 0000000000000246 R12: 000000000056bf8c
R13: 00007ffc352d975f R14: 00007f48eed2e300 R15: 0000000000022000
INFO: task syz-executor.3:10229 blocked for more than 143 seconds.
      Tainted: G        W         5.13.0-syzkaller #0
"echo 0 > /proc/sys/kernel/hung_task_timeout_secs" disables this message.
task:syz-executor.3  state:D stack:27976 pid:10229 ppid:  8828 flags:0x00004004
Call Trace:
 context_switch kernel/sched/core.c:4683 [inline]
 __schedule+0x934/0x2710 kernel/sched/core.c:5940
 schedule+0xd3/0x270 kernel/sched/core.c:6019
 io_uring_cancel_generic+0x54d/0x890 fs/io_uring.c:9148
 io_uring_files_cancel include/linux/io_uring.h:16 [inline]
 do_exit+0x28b/0x2a50 kernel/exit.c:780
 do_group_exit+0x125/0x310 kernel/exit.c:922
 get_signal+0x47f/0x2150 kernel/signal.c:2796
 arch_do_signal_or_restart+0x2a9/0x1eb0 arch/x86/kernel/signal.c:789
 handle_signal_work kernel/entry/common.c:148 [inline]
 exit_to_user_mode_loop kernel/entry/common.c:172 [inline]
 exit_to_user_mode_prepare+0x17d/0x290 kernel/entry/common.c:209
 __syscall_exit_to_user_mode_work kernel/entry/common.c:291 [inline]
 syscall_exit_to_user_mode+0x19/0x60 kernel/entry/common.c:302
 do_syscall_64+0x42/0xb0 arch/x86/entry/common.c:86
 entry_SYSCALL_64_after_hwframe+0x44/0xae
RIP: 0033:0x4665d9
RSP: 002b:00007fb1b5eac218 EFLAGS: 00000246 ORIG_RAX: 00000000000000ca
RAX: 0000000000000000 RBX: 000000000056bf88 RCX: 00000000004665d9
RDX: 0000000000000000 RSI: 0000000000000080 RDI: 000000000056bf88
RBP: 000000000056bf80 R08: 0000000000000000 R09: 0000000000000000
R10: 0000000000000000 R11: 0000000000000246 R12: 000000000056bf8c
R13: 00007ffdb651a9bf R14: 00007fb1b5eac300 R15: 0000000000022000
INFO: task syz-executor.0:10241 blocked for more than 144 seconds.
      Tainted: G        W         5.13.0-syzkaller #0
"echo 0 > /proc/sys/kernel/hung_task_timeout_secs" disables this message.
task:syz-executor.0  state:D stack:27976 pid:10241 ppid:  8830 flags:0x00004004
Call Trace:
 context_switch kernel/sched/core.c:4683 [inline]
 __schedule+0x934/0x2710 kernel/sched/core.c:5940
 schedule+0xd3/0x270 kernel/sched/core.c:6019
 io_uring_cancel_generic+0x54d/0x890 fs/io_uring.c:9148
 io_uring_files_cancel include/linux/io_uring.h:16 [inline]
 do_exit+0x28b/0x2a50 kernel/exit.c:780
 do_group_exit+0x125/0x310 kernel/exit.c:922
 get_signal+0x47f/0x2150 kernel/signal.c:2796
 arch_do_signal_or_restart+0x2a9/0x1eb0 arch/x86/kernel/signal.c:789
 handle_signal_work kernel/entry/common.c:148 [inline]
 exit_to_user_mode_loop kernel/entry/common.c:172 [inline]
 exit_to_user_mode_prepare+0x17d/0x290 kernel/entry/common.c:209
 __syscall_exit_to_user_mode_work kernel/entry/common.c:291 [inline]
 syscall_exit_to_user_mode+0x19/0x60 kernel/entry/common.c:302
 do_syscall_64+0x42/0xb0 arch/x86/entry/common.c:86
 entry_SYSCALL_64_after_hwframe+0x44/0xae
RIP: 0033:0x4665d9
RSP: 002b:00007fa3ce68b218 EFLAGS: 00000246 ORIG_RAX: 00000000000000ca
RAX: 0000000000000000 RBX: 000000000056bf88 RCX: 00000000004665d9
RDX: 0000000000000000 RSI: 0000000000000080 RDI: 000000000056bf88
RBP: 000000000056bf80 R08: 0000000000000000 R09: 0000000000000000
R10: 0000000000000000 R11: 0000000000000246 R12: 000000000056bf8c
R13: 00007ffcf35d4ebf R14: 00007fa3ce68b300 R15: 0000000000022000
INFO: task syz-executor.1:10247 blocked for more than 144 seconds.
      Tainted: G        W         5.13.0-syzkaller #0
"echo 0 > /proc/sys/kernel/hung_task_timeout_secs" disables this message.
task:syz-executor.1  state:D stack:27976 pid:10247 ppid:  8831 flags:0x00004004
Call Trace:
 context_switch kernel/sched/core.c:4683 [inline]
 __schedule+0x934/0x2710 kernel/sched/core.c:5940
 schedule+0xd3/0x270 kernel/sched/core.c:6019
 io_uring_cancel_generic+0x54d/0x890 fs/io_uring.c:9148
 io_uring_files_cancel include/linux/io_uring.h:16 [inline]
 do_exit+0x28b/0x2a50 kernel/exit.c:780
 do_group_exit+0x125/0x310 kernel/exit.c:922
 get_signal+0x47f/0x2150 kernel/signal.c:2796
 arch_do_signal_or_restart+0x2a9/0x1eb0 arch/x86/kernel/signal.c:789
 handle_signal_work kernel/entry/common.c:148 [inline]
 exit_to_user_mode_loop kernel/entry/common.c:172 [inline]
 exit_to_user_mode_prepare+0x17d/0x290 kernel/entry/common.c:209
 __syscall_exit_to_user_mode_work kernel/entry/common.c:291 [inline]
 syscall_exit_to_user_mode+0x19/0x60 kernel/entry/common.c:302
 do_syscall_64+0x42/0xb0 arch/x86/entry/common.c:86
 entry_SYSCALL_64_after_hwframe+0x44/0xae
RIP: 0033:0x4665d9
RSP: 002b:00007f7c4a218218 EFLAGS: 00000246 ORIG_RAX: 00000000000000ca
RAX: 0000000000000000 RBX: 000000000056bf88 RCX: 00000000004665d9
RDX: 0000000000000000 RSI: 0000000000000080 RDI: 000000000056bf88
RBP: 000000000056bf80 R08: 0000000000000000 R09: 0000000000000000
R10: 0000000000000000 R11: 0000000000000246 R12: 000000000056bf8c
R13: 00007ffdaa7cc7af R14: 00007f7c4a218300 R15: 0000000000022000
INFO: task syz-executor.4:10271 blocked for more than 144 seconds.
      Tainted: G        W         5.13.0-syzkaller #0
"echo 0 > /proc/sys/kernel/hung_task_timeout_secs" disables this message.
task:syz-executor.4  state:D stack:27976 pid:10271 ppid:  8827 flags:0x00004004
Call Trace:
 context_switch kernel/sched/core.c:4683 [inline]
 __schedule+0x934/0x2710 kernel/sched/core.c:5940
 schedule+0xd3/0x270 kernel/sched/core.c:6019
 io_uring_cancel_generic+0x54d/0x890 fs/io_uring.c:9148
 io_uring_files_cancel include/linux/io_uring.h:16 [inline]
 do_exit+0x28b/0x2a50 kernel/exit.c:780
 do_group_exit+0x125/0x310 kernel/exit.c:922
 get_signal+0x47f/0x2150 kernel/signal.c:2796
 arch_do_signal_or_restart+0x2a9/0x1eb0 arch/x86/kernel/signal.c:789
 handle_signal_work kernel/entry/common.c:148 [inline]
 exit_to_user_mode_loop kernel/entry/common.c:172 [inline]
 exit_to_user_mode_prepare+0x17d/0x290 kernel/entry/common.c:209
 __syscall_exit_to_user_mode_work kernel/entry/common.c:291 [inline]
 syscall_exit_to_user_mode+0x19/0x60 kernel/entry/common.c:302
 do_syscall_64+0x42/0xb0 arch/x86/entry/common.c:86
 entry_SYSCALL_64_after_hwframe+0x44/0xae
RIP: 0033:0x4665d9
RSP: 002b:00007fcb3ff30218 EFLAGS: 00000246 ORIG_RAX: 00000000000000ca
RAX: 0000000000000000 RBX: 000000000056bf88 RCX: 00000000004665d9
RDX: 0000000000000000 RSI: 0000000000000080 RDI: 000000000056bf88
RBP: 000000000056bf80 R08: 0000000000000000 R09: 0000000000000000
R10: 0000000000000000 R11: 0000000000000246 R12: 000000000056bf8c
R13: 00007ffd6fb6745f R14: 00007fcb3ff30300 R15: 0000000000022000
INFO: lockdep is turned off.
NMI backtrace for cpu 1
CPU: 1 PID: 1635 Comm: khungtaskd Tainted: G        W         5.13.0-syzkaller #0
Hardware name: Google Google Compute Engine/Google Compute Engine, BIOS Google 01/01/2011
Call Trace:
 __dump_stack lib/dump_stack.c:79 [inline]
 dump_stack_lvl+0xcd/0x134 lib/dump_stack.c:96
 nmi_cpu_backtrace.cold+0x44/0xd7 lib/nmi_backtrace.c:105
 nmi_trigger_cpumask_backtrace+0x1b3/0x230 lib/nmi_backtrace.c:62
 trigger_all_cpu_backtrace include/linux/nmi.h:146 [inline]
 check_hung_uninterruptible_tasks kernel/hung_task.c:209 [inline]
 watchdog+0xd4b/0xfb0 kernel/hung_task.c:294
 kthread+0x3e5/0x4d0 kernel/kthread.c:319
 ret_from_fork+0x1f/0x30 arch/x86/entry/entry_64.S:295
Sending NMI from CPU 1 to CPUs 0:
NMI backtrace for cpu 0
CPU: 0 PID: 8 Comm: kworker/0:2 Tainted: G        W         5.13.0-syzkaller #0
Hardware name: Google Google Compute Engine/Google Compute Engine, BIOS Google 01/01/2011
Workqueue: events_power_efficient toggle_allocation_gate
RIP: 0010:__kasan_check_read+0x4/0x10 mm/kasan/shadow.c:31
Code: 24 07 48 85 db 0f 85 f6 0d 26 07 48 83 c4 60 5b 5d 41 5c 41 5d c3 c3 e9 f6 0e 26 07 cc cc cc cc cc cc cc cc cc cc 48 8b 0c 24 <89> f6 31 d2 e9 03 f9 ff ff 0f 1f 00 48 8b 0c 24 89 f6 ba 01 00 00
RSP: 0018:ffffc90000cd79a8 EFLAGS: 00000046
RAX: 0000000000000001 RBX: ffff888140158660 RCX: ffffffff81347c5f
RDX: ffffed102802b0cd RSI: 0000000000000008 RDI: ffffffff8baa4870
RBP: ffffffff8baa4460 R08: 0000000000000001 R09: ffff888140158667
R10: ffffed102802b0cc R11: 000000000000003f R12: ffff888140158000
R13: ffffffff8baa4870 R14: ffff888140158660 R15: ffffffff8baa4400
FS:  0000000000000000(0000) GS:ffff8880b9c00000(0000) knlGS:0000000000000000
CS:  0010 DS: 0000 ES: 0000 CR0: 0000000080050033
CR2: 00007f089e135020 CR3: 000000013fe38000 CR4: 0000000000350ef0
Call Trace:
 instrument_atomic_read include/linux/instrumented.h:71 [inline]
 atomic64_read include/asm-generic/atomic-instrumented.h:605 [inline]
 switch_mm_irqs_off+0x1df/0x9b0 arch/x86/mm/tlb.c:556
 unuse_temporary_mm arch/x86/kernel/alternative.c:763 [inline]
 __text_poke+0x541/0x8c0 arch/x86/kernel/alternative.c:859
 text_poke_bp_batch+0x3d7/0x560 arch/x86/kernel/alternative.c:1178
 text_poke_flush arch/x86/kernel/alternative.c:1268 [inline]
 text_poke_flush arch/x86/kernel/alternative.c:1265 [inline]
 text_poke_finish+0x16/0x30 arch/x86/kernel/alternative.c:1275
 arch_jump_label_transform_apply+0x13/0x20 arch/x86/kernel/jump_label.c:145
 jump_label_update+0x1d5/0x430 kernel/jump_label.c:827
 static_key_enable_cpuslocked+0x1b1/0x260 kernel/jump_label.c:177
 static_key_enable+0x16/0x20 kernel/jump_label.c:190
 toggle_allocation_gate mm/kfence/core.c:623 [inline]
 toggle_allocation_gate+0x100/0x390 mm/kfence/core.c:615
 process_one_work+0x98d/0x1630 kernel/workqueue.c:2276
 worker_thread+0x658/0x11f0 kernel/workqueue.c:2422
 kthread+0x3e5/0x4d0 kernel/kthread.c:319
 ret_from_fork+0x1f/0x30 arch/x86/entry/entry_64.S:295


Tested on:

commit:         dfa01077 io_uring: use right task for exiting checks
git tree:       git://git.kernel.dk/linux-block io_uring-5.14-test
console output: https://syzkaller.appspot.com/x/log.txt?x=13b501e2300000
kernel config:  https://syzkaller.appspot.com/x/.config?x=c650d78cfe48974c
dashboard link: https://syzkaller.appspot.com/bug?extid=ba6fcd859210f4e9e109
compiler:       

