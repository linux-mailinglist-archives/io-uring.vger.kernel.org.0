Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 9D9244082D3
	for <lists+io-uring@lfdr.de>; Mon, 13 Sep 2021 04:26:56 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236902AbhIMC2J (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Sun, 12 Sep 2021 22:28:09 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:50984 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S235364AbhIMC2J (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Sun, 12 Sep 2021 22:28:09 -0400
Received: from mail-pj1-x102a.google.com (mail-pj1-x102a.google.com [IPv6:2607:f8b0:4864:20::102a])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 5AE73C061574;
        Sun, 12 Sep 2021 19:26:54 -0700 (PDT)
Received: by mail-pj1-x102a.google.com with SMTP id oc9so5212361pjb.4;
        Sun, 12 Sep 2021 19:26:54 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc:content-transfer-encoding;
        bh=0fkfIZUAJ/vlTqVT+hs/hXqMweAj341t1XAYl67Mq+E=;
        b=gKQEXhAvaoBrLJTEh7qf4GWWMOyaMWsi1hU2Fn/t91UTsgVAamAQnenFbbkdhZpBEg
         N9hlSz0CB7oyrAGgy13Cm9WpIM3pWrb1acx/qQwpKn8NY5JhEPHPk59YgiVVn6jfHzq1
         w9EmKLohSPbGl5vcKUS6Jd5X2xl5s34/W4aseVVUluf4wnbT+BeXF3+TTOG7Et7fDaV9
         o1svii9LWB9diD0Q7fnRjF/h1IQ8+nHzOCCYzDAWi7tl9S1OIBvc1AEvvABzuaETcn8v
         DGHoqfOAb40RcsHsYx7STBM92DxXhWTS5+B/ANyfHLccLHO0rlu6WZtI2rXKr+QrPHXJ
         KwUg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc:content-transfer-encoding;
        bh=0fkfIZUAJ/vlTqVT+hs/hXqMweAj341t1XAYl67Mq+E=;
        b=ymfuEjSwL8CgCIHAYA2JdKWARgo0tRLNpPD52DOeRjIKCsrBRMqNxXuesAp2UIz3UB
         gSsOpg1YtJL48qTTOJDE7eUABf1dK98A+SnxU/kWfsjgsUd2pI2hNnAoRFAryq5KJFbh
         lOQntqtpXBj1IFOxY/GNO1EVWykCdqsPxSvNwac/PT2UG8zuH1D6+YP/0568aLWSAwlY
         VnjhfuByLNl3Ap9zFym0jBooV9POn+UGQTc6aDYRh5LxUEqpcte1738m8JHLf+NtOajM
         XXKM58aLjf9GRnDWH++I885q29mo55xi1a3JGAsy8CTSdQlcRH14p2XhNFZviWIDIv+f
         BqDA==
X-Gm-Message-State: AOAM532b2XwgBV00q4Pn3mJtn4S30OnNItP88waDrCFT6Rj2bmGeOnio
        rf1S+72z41OjMRe22JepMVg8m1XvelT6B37fuI8RSu+Bx4ei
X-Google-Smtp-Source: ABdhPJxJIeu9vKFwBnY8jvcoBptXQLZWZChwguL8jqzu09qBpS0XWJJBc3EQWOqwFVPNibYIVqvBCnxyyWPtSQl1AeA=
X-Received: by 2002:a17:90b:4b52:: with SMTP id mi18mr10211914pjb.112.1631500013258;
 Sun, 12 Sep 2021 19:26:53 -0700 (PDT)
MIME-Version: 1.0
References: <CACkBjsbs2tahJMC_TBZhQUBQiFYhLo-CW+kyzNxyUqgs5NCaXA@mail.gmail.com>
 <df072429-3f45-4d9d-c81d-73174aaf2e7d@kernel.dk> <e5ac817b-bc96-bea6-aadb-89d3c201446d@gmail.com>
 <CACkBjsZLyNbMwyoZc8T9ggq+R6-0aBFPCRB54jzAOF8f2QCH0Q@mail.gmail.com>
 <CACkBjsaGTkxsrBW+HNsgR0Pj7kbbrK-F5E4hp3CJJjYf3ASimQ@mail.gmail.com> <ce4db530-3e7c-1a90-f271-42d471b098ed@gmail.com>
In-Reply-To: <ce4db530-3e7c-1a90-f271-42d471b098ed@gmail.com>
From:   Hao Sun <sunhao.th@gmail.com>
Date:   Mon, 13 Sep 2021 10:26:41 +0800
Message-ID: <CACkBjsYvCPQ2PpryOT5rHNTg5AuFpzOYip4UNjh40HwW2+XbsA@mail.gmail.com>
Subject: Re: INFO: task hung in io_uring_cancel_generic
To:     Pavel Begunkov <asml.silence@gmail.com>,
        Jens Axboe <axboe@kernel.dk>
Cc:     io-uring@vger.kernel.org, linux-kernel@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org

Hi

Healer found a C reproducer for this crash ("INFO: task hung in
io_ring_exit_work").

HEAD commit: 4b93c544e90e-thunderbolt: test: split up test cases
git tree: upstream
console output:
https://drive.google.com/file/d/1NswMU2yMRTc8-EqbZcVvcJejV92cuZIk/view?usp=
=3Dsharing
kernel config: https://drive.google.com/file/d/1c0u2EeRDhRO-ZCxr9MP2VvAtJd6=
kfg-p/view?usp=3Dsharing
C reproducer: https://drive.google.com/file/d/170wk5_T8mYDaAtDcrdVi2UU9_dW1=
894s/view?usp=3Dsharing
Syzlang reproducer:
https://drive.google.com/file/d/1eo-jAS9lncm4i-1kaCBkexrjpQHXboBq/view?usp=
=3Dsharing

If you fix this issue, please add the following tag to the commit:
Reported-by: Hao Sun <sunhao.th@gmail.com>

INFO: task kworker/u10:0:24 blocked for more than 143 seconds.
      Not tainted 5.14.0+ #1
"echo 0 > /proc/sys/kernel/hung_task_timeout_secs" disables this message.
task:kworker/u10:0   state:D stack:27224 pid:   24 ppid:     2 flags:0x0000=
4000
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
 io_ring_exit_work+0x530/0x1540 fs/io_uring.c:9333
 process_one_work+0x9df/0x16d0 kernel/workqueue.c:2297
 worker_thread+0x90/0xed0 kernel/workqueue.c:2444
 kthread+0x3e5/0x4d0 kernel/kthread.c:319
 ret_from_fork+0x1f/0x30 arch/x86/entry/entry_64.S:295

Showing all locks held in the system:
2 locks held by kworker/u10:0/24:
 #0: ffff888010c71138 ((wq_completion)events_unbound){+.+.}-{0:0}, at:
arch_atomic64_set arch/x86/include/asm/atomic64_64.h:34 [inline]
 #0: ffff888010c71138 ((wq_completion)events_unbound){+.+.}-{0:0}, at:
arch_atomic_long_set include/linux/atomic/atomic-long.h:41 [inline]
 #0: ffff888010c71138 ((wq_completion)events_unbound){+.+.}-{0:0}, at:
atomic_long_set include/linux/atomic/atomic-instrumented.h:1198
[inline]
 #0: ffff888010c71138 ((wq_completion)events_unbound){+.+.}-{0:0}, at:
set_work_data kernel/workqueue.c:634 [inline]
 #0: ffff888010c71138 ((wq_completion)events_unbound){+.+.}-{0:0}, at:
set_work_pool_and_clear_pending kernel/workqueue.c:661 [inline]
 #0: ffff888010c71138 ((wq_completion)events_unbound){+.+.}-{0:0}, at:
process_one_work+0x8c3/0x16d0 kernel/workqueue.c:2268
 #1: ffffc900007efdc8
((work_completion)(&ctx->exit_work)){+.+.}-{0:0}, at:
process_one_work+0x8f7/0x16d0 kernel/workqueue.c:2272
1 lock held by khungtaskd/1161:
 #0: ffffffff8b97dde0 (rcu_read_lock){....}-{1:2}, at:
debug_show_all_locks+0x53/0x260 kernel/locking/lockdep.c:6446
1 lock held by in:imklog/8220:
 #0: ffff88802031d4f0 (&f->f_pos_lock){+.+.}-{3:3}, at:
__fdget_pos+0xe9/0x100 fs/file.c:990

=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D

NMI backtrace for cpu 0
CPU: 0 PID: 1161 Comm: khungtaskd Not tainted 5.14.0+ #1
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
Sending NMI from CPU 0 to CPUs 1-3:
NMI backtrace for cpu 1
CPU: 1 PID: 10654 Comm: syz-executor Not tainted 5.14.0+ #1
Hardware name: QEMU Standard PC (i440FX + PIIX, 1996), BIOS
1.13.0-1ubuntu1.1 04/01/2014
RIP: 0010:__sanitizer_cov_trace_pc+0x1c/0x40 kernel/kcov.c:197
Code: 66 66 2e 0f 1f 84 00 00 00 00 00 0f 1f 00 65 48 8b 0c 25 40 f0
01 00 bf 02 00 00 00 48 89 ce 4c 8b 04 24 e8 76 ff ff ff 84 c0 <74> 20
48 8b 91 20 15 00 00 8b 89 1c 15 00 00 48 8b 02 48 83 c0 01
RSP: 0018:ffffc900085df560 EFLAGS: 00000202
RAX: 0000000000000001 RBX: 0000000000000002 RCX: ffff888011b08000
RDX: 0000000000000000 RSI: ffff888011b08000 RDI: 0000000000000002
RBP: ffffc900085df728 R08: ffffffff88b6a994 R09: 0000000000000002
R10: 0000000000000005 R11: ffffed1002361000 R12: ffff88802d8fa100
R13: ffffc900085df620 R14: 00000000fffffe00 R15: 0000000000000002
FS:  00007f7828b86700(0000) GS:ffff888135c00000(0000) knlGS:000000000000000=
0
CS:  0010 DS: 0000 ES: 0000 CR0: 0000000080050033
CR2: 00007f3570c3c0a0 CR3: 0000000106990000 CR4: 0000000000350ee0
Call Trace:
 p9_client_rpc+0x3d4/0x11c0 net/9p/client.c:759
 p9_client_flush+0xe9/0x1e0 net/9p/client.c:667
 p9_client_rpc+0x107e/0x11c0 net/9p/client.c:784
 p9_client_version net/9p/client.c:955 [inline]
 p9_client_create+0xbe0/0x13e0 net/9p/client.c:1055
 v9fs_session_init+0x1e4/0x1900 fs/9p/v9fs.c:406
 v9fs_mount+0x73/0x9d0 fs/9p/vfs_super.c:126
 legacy_get_tree+0x105/0x220 fs/fs_context.c:610
 vfs_get_tree+0x89/0x2f0 fs/super.c:1498
 do_new_mount fs/namespace.c:2988 [inline]
 path_mount+0x1228/0x1cb0 fs/namespace.c:3318
 do_mount+0xf3/0x110 fs/namespace.c:3331
 __do_sys_mount fs/namespace.c:3539 [inline]
 __se_sys_mount fs/namespace.c:3516 [inline]
 __x64_sys_mount+0x18f/0x230 fs/namespace.c:3516
 do_syscall_x64 arch/x86/entry/common.c:50 [inline]
 do_syscall_64+0x35/0xb0 arch/x86/entry/common.c:80
 entry_SYSCALL_64_after_hwframe+0x44/0xae
RIP: 0033:0x4739cd
Code: 02 b8 ff ff ff ff c3 66 0f 1f 44 00 00 f3 0f 1e fa 48 89 f8 48
89 f7 48 89 d6 48 89 ca 4d 89 c2 4d 89 c8 4c 8b 4c 24 08 0f 05 <48> 3d
01 f0 ff ff 73 01 c3 48 c7 c1 bc ff ff ff f7 d8 64 89 01 48
RSP: 002b:00007f7828b85c58 EFLAGS: 00000246 ORIG_RAX: 00000000000000a5
RAX: ffffffffffffffda RBX: 000000000059c0a0 RCX: 00000000004739cd
RDX: 0000000020000380 RSI: 0000000020000340 RDI: 0000000000000000
RBP: 00000000004ebd80 R08: 00000000200003c0 R09: 0000000000000000
R10: 0000000000000000 R11: 0000000000000246 R12: 000000000059c0a0
R13: 00007ffd0845607f R14: 00007ffd08456220 R15: 00007f7828b85dc0
NMI backtrace for cpu 3
CPU: 3 PID: 4948 Comm: systemd-journal Not tainted 5.14.0+ #1
Hardware name: QEMU Standard PC (i440FX + PIIX, 1996), BIOS
1.13.0-1ubuntu1.1 04/01/2014
RIP: 0010:lookup_chain_cache kernel/locking/lockdep.c:3682 [inline]
RIP: 0010:lookup_chain_cache_add kernel/locking/lockdep.c:3702 [inline]
RIP: 0010:validate_chain kernel/locking/lockdep.c:3757 [inline]
RIP: 0010:__lock_acquire+0x1877/0x57e0 kernel/locking/lockdep.c:5015
Code: e5 40 08 c7 8f 48 89 5c 24 08 0f 84 6f 04 00 00 4a 8d 14 e5 40
08 c7 8f 48 b8 00 00 00 00 00 fc ff df 48 c1 ea 03 80 3c 02 00 <0f> 85
66 2f 00 00 4a 8b 1c e5 40 08 c7 8f 48 85 db 74 58 48 83 eb
RSP: 0018:ffffc9000107f868 EFLAGS: 00000046
RAX: dffffc0000000000 RBX: ffffffff8fc8e4b0 RCX: ffffffff815b148b
RDX: 1ffffffff1f91c96 RSI: 0000000000000008 RDI: ffffffff8fd008f8
RBP: ffff888013f4dfa0 R08: 0000000000000001 R09: fffffbfff1fa0120
R10: ffffffff8fd008ff R11: fffffbfff1fa011f R12: 0000000000003b8e
R13: ffff888013f4d580 R14: d03c86651a37c6c3 R15: 0000000000000000
FS:  00007f35737908c0(0000) GS:ffff888135d00000(0000) knlGS:000000000000000=
0
CS:  0010 DS: 0000 ES: 0000 CR0: 0000000080050033
CR2: 00007f3570caf000 CR3: 000000001b4d1000 CR4: 0000000000350ee0
Call Trace:
 lock_acquire kernel/locking/lockdep.c:5625 [inline]
 lock_acquire+0x1ab/0x520 kernel/locking/lockdep.c:5590
 seqcount_lockdep_reader_access include/linux/seqlock.h:103 [inline]
 set_root+0x3be/0x560 fs/namei.c:940
 nd_jump_root+0x38d/0x520 fs/namei.c:961
 path_init+0xf81/0x1700 fs/namei.c:2359
 path_lookupat.isra.0+0x30/0x580 fs/namei.c:2439
 __filename_lookup+0x1ca/0x410 fs/namei.c:2478
 filename_lookup fs/namei.c:2494 [inline]
 user_path_at_empty+0x42/0x60 fs/namei.c:2801
 user_path_at include/linux/namei.h:57 [inline]
 do_faccessat+0x127/0x850 fs/open.c:421
 do_syscall_x64 arch/x86/entry/common.c:50 [inline]
 do_syscall_64+0x35/0xb0 arch/x86/entry/common.c:80
 entry_SYSCALL_64_after_hwframe+0x44/0xae
RIP: 0033:0x7f3572a4c9c7
Code: 83 c4 08 48 3d 01 f0 ff ff 73 01 c3 48 8b 0d c8 d4 2b 00 f7 d8
64 89 01 48 83 c8 ff c3 66 0f 1f 44 00 00 b8 15 00 00 00 0f 05 <48> 3d
01 f0 ff ff 73 01 c3 48 8b 0d a1 d4 2b 00 f7 d8 64 89 01 48
RSP: 002b:00007ffcba7c9ca8 EFLAGS: 00000246 ORIG_RAX: 0000000000000015
RAX: ffffffffffffffda RBX: 00007ffcba7cccd0 RCX: 00007f3572a4c9c7
RDX: 0000000000000000 RSI: 0000000000000000 RDI: 00005623bd6869a3
RBP: 00007ffcba7c9df0 R08: 00005623bd67c3e5 R09: 0000000000000018
R10: 0000000000000069 R11: 0000000000000246 R12: 0000000000000000
R13: 0000000000000000 R14: 00005623bd7558a0 R15: 00007ffcba7ca2e0
NMI backtrace for cpu 2 skipped: idling at native_safe_halt
arch/x86/include/asm/irqflags.h:51 [inline]
NMI backtrace for cpu 2 skipped: idling at arch_safe_halt
arch/x86/include/asm/irqflags.h:89 [inline]
NMI backtrace for cpu 2 skipped: idling at default_idle+0xb/0x10
arch/x86/kernel/process.c:716
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
  3c: 48 83 c0 01          add    $0x1,%rax%

Pavel Begunkov <asml.silence@gmail.com> =E4=BA=8E2021=E5=B9=B49=E6=9C=889=
=E6=97=A5=E5=91=A8=E5=9B=9B =E4=B8=8A=E5=8D=884:16=E5=86=99=E9=81=93=EF=BC=
=9A

>
> On 9/8/21 7:57 AM, Hao Sun wrote:
> > Another similar report: INFO: task hung in io_ring_exit_work
> >
> > INFO: task kworker/u9:3:1867 blocked for more than 143 seconds.
> >       Not tainted 5.14.0+ #13
> > "echo 0 > /proc/sys/kernel/hung_task_timeout_secs" disables this messag=
e.
> > task:kworker/u9:3    state:D stack:12344 pid: 1867 ppid:     2 flags:0x=
00004000
> > Workqueue: events_unbound io_ring_exit_work
>
> This one is different. I guess it may be difficult for syz to
> find a repro because of the delay before the warning appears.
> How about to reduce it to a lower value? like 2-5 seconds
>
> echo 5 > /proc/sys/kernel/hung_task_timeout_secs
>
> > Call Trace:
> >  context_switch kernel/sched/core.c:4940 [inline]
> >  __schedule+0x323/0xae0 kernel/sched/core.c:6287
> >  schedule+0x36/0xe0 kernel/sched/core.c:6366
> >  schedule_timeout+0x189/0x430 kernel/time/timer.c:1857
> >  do_wait_for_common kernel/sched/completion.c:85 [inline]
> >  __wait_for_common kernel/sched/completion.c:106 [inline]
> >  wait_for_common kernel/sched/completion.c:117 [inline]
> >  wait_for_completion+0xb4/0x110 kernel/sched/completion.c:138
> >  io_ring_exit_work+0x287/0x850 fs/io_uring.c:9297
> >  process_one_work+0x359/0x850 kernel/workqueue.c:2297
> >  worker_thread+0x41/0x4d0 kernel/workqueue.c:2444
> >  kthread+0x178/0x1b0 kernel/kthread.c:319
> >  ret_from_fork+0x1f/0x30 arch/x86/entry/entry_64.S:295
> > INFO: task kworker/u9:4:2050 blocked for more than 143 seconds.
> >       Not tainted 5.14.0+ #13
> > "echo 0 > /proc/sys/kernel/hung_task_timeout_secs" disables this messag=
e.
> > task:kworker/u9:4    state:D stack:12232 pid: 2050 ppid:     2 flags:0x=
00004000
> > Workqueue: events_unbound io_ring_exit_work
> > Call Trace:
> >  context_switch kernel/sched/core.c:4940 [inline]
> >  __schedule+0x323/0xae0 kernel/sched/core.c:6287
> >  schedule+0x36/0xe0 kernel/sched/core.c:6366
> >  schedule_timeout+0x189/0x430 kernel/time/timer.c:1857
> >  do_wait_for_common kernel/sched/completion.c:85 [inline]
> >  __wait_for_common kernel/sched/completion.c:106 [inline]
> >  wait_for_common kernel/sched/completion.c:117 [inline]
> >  wait_for_completion+0xb4/0x110 kernel/sched/completion.c:138
> >  io_ring_exit_work+0x287/0x850 fs/io_uring.c:9297
> >  process_one_work+0x359/0x850 kernel/workqueue.c:2297
> >  worker_thread+0x41/0x4d0 kernel/workqueue.c:2444
> >  kthread+0x178/0x1b0 kernel/kthread.c:319
> >  ret_from_fork+0x1f/0x30 arch/x86/entry/entry_64.S:295
> >
> > Showing all locks held in the system:
> > 1 lock held by khungtaskd/1340:
> >  #0: ffffffff85a1d3a0 (rcu_read_lock){....}-{1:2}, at:
> > debug_show_all_locks+0xe/0x1a0 kernel/locking/lockdep.c:6446
> > 2 locks held by kworker/u9:3/1867:
> >  #0: ffff888008c5c938 ((wq_completion)events_unbound){+.+.}-{0:0}, at:
> > set_work_data kernel/workqueue.c:633 [inline]
> >  #0: ffff888008c5c938 ((wq_completion)events_unbound){+.+.}-{0:0}, at:
> > set_work_pool_and_clear_pending kernel/workqueue.c:661 [inline]
> >  #0: ffff888008c5c938 ((wq_completion)events_unbound){+.+.}-{0:0}, at:
> > process_one_work+0x2a0/0x850 kernel/workqueue.c:2268
> >  #1: ffffc90003e67e70
> > ((work_completion)(&ctx->exit_work)){+.+.}-{0:0}, at: set_work_data
> > kernel/workqueue.c:633 [inline]
> >  #1: ffffc90003e67e70
> > ((work_completion)(&ctx->exit_work)){+.+.}-{0:0}, at:
> > set_work_pool_and_clear_pending kernel/workqueue.c:661 [inline]
> >  #1: ffffc90003e67e70
> > ((work_completion)(&ctx->exit_work)){+.+.}-{0:0}, at:
> > process_one_work+0x2a0/0x850 kernel/workqueue.c:2268
> > 2 locks held by kworker/u9:4/2050:
> >  #0: ffff888008c5c938 ((wq_completion)events_unbound){+.+.}-{0:0}, at:
> > set_work_data kernel/workqueue.c:633 [inline]
> >  #0: ffff888008c5c938 ((wq_completion)events_unbound){+.+.}-{0:0}, at:
> > set_work_pool_and_clear_pending kernel/workqueue.c:661 [inline]
> >  #0: ffff888008c5c938 ((wq_completion)events_unbound){+.+.}-{0:0}, at:
> > process_one_work+0x2a0/0x850 kernel/workqueue.c:2268
> >  #1: ffffc90004327e70
> > ((work_completion)(&ctx->exit_work)){+.+.}-{0:0}, at: set_work_data
> > kernel/workqueue.c:633 [inline]
> >  #1: ffffc90004327e70
> > ((work_completion)(&ctx->exit_work)){+.+.}-{0:0}, at:
> > set_work_pool_and_clear_pending kernel/workqueue.c:661 [inline]
> >  #1: ffffc90004327e70
> > ((work_completion)(&ctx->exit_work)){+.+.}-{0:0}, at:
> > process_one_work+0x2a0/0x850 kernel/workqueue.c:2268
> > 1 lock held by in:imklog/8089:
> >  #0: ffff88800ece7ef0 (&f->f_pos_lock){+.+.}-{3:3}, at:
> > __fdget_pos+0x55/0x60 fs/file.c:990
> >
> > =3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D
> >
> > NMI backtrace for cpu 0
> > CPU: 0 PID: 1340 Comm: khungtaskd Not tainted 5.14.0+ #13
> > Hardware name: QEMU Standard PC (i440FX + PIIX, 1996), BIOS
> > rel-1.12.0-59-gc9ba5276e321-prebuilt.qemu.org 04/01/2014
> > Call Trace:
> >  __dump_stack lib/dump_stack.c:88 [inline]
> >  dump_stack_lvl+0x8d/0xcf lib/dump_stack.c:105
> >  nmi_cpu_backtrace+0x1e9/0x210 lib/nmi_backtrace.c:105
> >  nmi_trigger_cpumask_backtrace+0x120/0x180 lib/nmi_backtrace.c:62
> >  trigger_all_cpu_backtrace include/linux/nmi.h:146 [inline]
> >  check_hung_uninterruptible_tasks kernel/hung_task.c:210 [inline]
> >  watchdog+0x4e1/0x980 kernel/hung_task.c:295
> >  kthread+0x178/0x1b0 kernel/kthread.c:319
> >  ret_from_fork+0x1f/0x30 arch/x86/entry/entry_64.S:295
> > Sending NMI from CPU 0 to CPUs 1-3:
> > NMI backtrace for cpu 1
> > CPU: 1 PID: 4934 Comm: systemd-journal Not tainted 5.14.0+ #13
> > Hardware name: QEMU Standard PC (i440FX + PIIX, 1996), BIOS
> > rel-1.12.0-59-gc9ba5276e321-prebuilt.qemu.org 04/01/2014
> > RIP: 0010:lockdep_enabled kernel/locking/lockdep.c:91 [inline]
> > RIP: 0010:lock_acquire+0x1a4/0x340 kernel/locking/lockdep.c:5601
> > Code: 04 25 28 00 00 00 0f 85 b5 01 00 00 48 83 c4 38 5b 5d 41 5c 41
> > 5d 41 5e 41 5f c3 65 48 8b 04 25 40 70 01 00 8b 80 f4 09 00 00 <85> c0
> > 0f 85 c5 fe ff ff 9c 8f 04 24 fa 48 c7 c7 a0 36 5d 85 e8 e3
> > RSP: 0018:ffffc9000086fe18 EFLAGS: 00000246
> > RAX: 0000000000000000 RBX: 0000000000000000 RCX: 0000000000000000
> > RDX: 0000000000000001 RSI: ffffffff852a8b94 RDI: ffffffff853cae8e
> > RBP: 0000000000000000 R08: 0000000000000000 R09: 0000000000000000
> > R10: 0000000000000000 R11: 0000000000000000 R12: ffffffff85a1d3a0
> > R13: 0000000000000002 R14: 0000000000000000 R15: 0000000000000000
> > FS:  00007f940a97b8c0(0000) GS:ffff88813dc00000(0000) knlGS:00000000000=
00000
> > CS:  0010 DS: 0000 ES: 0000 CR0: 0000000080050033
> > CR2: 00007f9407aa3000 CR3: 000000000f49a000 CR4: 0000000000750ee0
> > DR0: 0000000000000000 DR1: 0000000000000000 DR2: 0000000000000000
> > DR3: 0000000000000000 DR6: 00000000fffe0ff0 DR7: 0000000000000400
> > PKRU: 55555554
> > Call Trace:
> >  rcu_lock_acquire include/linux/rcupdate.h:267 [inline]
> >  rcu_read_lock include/linux/rcupdate.h:687 [inline]
> >  dput+0x72/0x650 fs/dcache.c:874
> >  path_put+0x12/0x20 fs/namei.c:557
> >  do_faccessat+0x1fa/0x370 fs/open.c:455
> >  do_syscall_x64 arch/x86/entry/common.c:50 [inline]
> >  do_syscall_64+0x34/0xb0 arch/x86/entry/common.c:80
> >  entry_SYSCALL_64_after_hwframe+0x44/0xae
> > RIP: 0033:0x7f9409c379c7
> > Code: 83 c4 08 48 3d 01 f0 ff ff 73 01 c3 48 8b 0d c8 d4 2b 00 f7 d8
> > 64 89 01 48 83 c8 ff c3 66 0f 1f 44 00 00 b8 15 00 00 00 0f 05 <48> 3d
> > 01 f0 ff ff 73 01 c3 48 8b 0d a1 d4 2b 00 f7 d8 64 89 01 48
> > RSP: 002b:00007ffeead2d338 EFLAGS: 00000246 ORIG_RAX: 0000000000000015
> > RAX: ffffffffffffffda RBX: 00007ffeead30250 RCX: 00007f9409c379c7
> > RDX: 00007f940a6a8a00 RSI: 0000000000000000 RDI: 000055d9e89aa9a3
> > RBP: 00007ffeead2d370 R08: 0000000000000000 R09: 0000000000000000
> > R10: 0000000000000069 R11: 0000000000000246 R12: 0000000000000000
> > R13: 0000000000000000 R14: 00007ffeead30250 R15: 00007ffeead2d860
> > NMI backtrace for cpu 2 skipped: idling at native_safe_halt
> > arch/x86/include/asm/irqflags.h:51 [inline]
> > NMI backtrace for cpu 2 skipped: idling at arch_safe_halt
> > arch/x86/include/asm/irqflags.h:89 [inline]
> > NMI backtrace for cpu 2 skipped: idling at default_idle+0xb/0x10
> > arch/x86/kernel/process.c:716
> > NMI backtrace for cpu 3
> > CPU: 3 PID: 8091 Comm: rs:main Q:Reg Not tainted 5.14.0+ #13
> > Hardware name: QEMU Standard PC (i440FX + PIIX, 1996), BIOS
> > rel-1.12.0-59-gc9ba5276e321-prebuilt.qemu.org 04/01/2014
> > RIP: 0010:memset_erms+0x9/0x10 arch/x86/lib/memset_64.S:64
> > Code: c1 e9 03 40 0f b6 f6 48 b8 01 01 01 01 01 01 01 01 48 0f af c6
> > f3 48 ab 89 d1 f3 aa 4c 89 c8 c3 90 49 89 f9 40 88 f0 48 89 d1 <f3> aa
> > 4c 89 c8 c3 90 49 89 fa 40 0f b6 ce 48 b8 01 01 01 01 01 01
> > RSP: 0018:ffffc90007a23ba8 EFLAGS: 00010216
> > RAX: 0000000000000000 RBX: ffff88810cd3ec78 RCX: 0000000000000c85
> > RDX: 0000000000000d05 RSI: 0000000000000000 RDI: ffff888107f7b37b
> > RBP: 0000000000001000 R08: 0000000000000000 R09: ffff888107f7b2fb
> > R10: ffffc90007a23978 R11: 0000000000000005 R12: 0000000000000000
> > R13: 0000000000000000 R14: 0000000000001000 R15: ffffea00041fdec0
> > FS:  00007fd86dba4700(0000) GS:ffff88813dd00000(0000) knlGS:00000000000=
00000
> > CS:  0010 DS: 0000 ES: 0000 CR0: 0000000080050033
> > CR2: 000055d6e0599858 CR3: 0000000012b38000 CR4: 0000000000750ee0
> > DR0: 0000000000000000 DR1: 0000000000000000 DR2: 0000000000000000
> > DR3: 0000000000000000 DR6: 00000000fffe0ff0 DR7: 0000000000000400
> > PKRU: 55555554
> > Call Trace:
> >  memset include/linux/fortify-string.h:175 [inline]
> >  zero_user_segments include/linux/highmem.h:211 [inline]
> >  ext4_block_write_begin+0x63e/0x980 fs/ext4/inode.c:1089
> >  ext4_da_write_begin+0x275/0x610 fs/ext4/inode.c:3021
> >  generic_perform_write+0xce/0x220 mm/filemap.c:3770
> >  ext4_buffered_write_iter+0xd6/0x190 fs/ext4/file.c:269
> >  ext4_file_write_iter+0x80/0x940 fs/ext4/file.c:680
> >  call_write_iter include/linux/fs.h:2163 [inline]
> >  new_sync_write+0x18d/0x260 fs/read_write.c:507
> >  vfs_write+0x43b/0x4a0 fs/read_write.c:594
> >  ksys_write+0xd2/0x120 fs/read_write.c:647
> >  do_syscall_x64 arch/x86/entry/common.c:50 [inline]
> >  do_syscall_64+0x34/0xb0 arch/x86/entry/common.c:80
> >  entry_SYSCALL_64_after_hwframe+0x44/0xae
> > RIP: 0033:0x7fd8705e81cd
> > Code: c2 20 00 00 75 10 b8 01 00 00 00 0f 05 48 3d 01 f0 ff ff 73 31
> > c3 48 83 ec 08 e8 ae fc ff ff 48 89 04 24 b8 01 00 00 00 0f 05 <48> 8b
> > 3c 24 48 89 c2 e8 f7 fc ff ff 48 89 d0 48 83 c4 08 48 3d 01
> > RSP: 002b:00007fd86dba3590 EFLAGS: 00000293 ORIG_RAX: 0000000000000001
> > RAX: ffffffffffffffda RBX: 00007fd8640268f0 RCX: 00007fd8705e81cd
> > RDX: 00000000000004ce RSI: 00007fd8640268f0 RDI: 0000000000000008
> > RBP: 0000000000000000 R08: 0000000000000000 R09: 0000000000000000
> > R10: 0000000000000000 R11: 0000000000000293 R12: 00007fd864026670
> > R13: 00007fd86dba35b0 R14: 00005563e5cf4440 R15: 00000000000004ce
> > ----------------
> > Code disassembly (best guess):
> >    0: 04 25                add    $0x25,%al
> >    2: 28 00                sub    %al,(%rax)
> >    4: 00 00                add    %al,(%rax)
> >    6: 0f 85 b5 01 00 00    jne    0x1c1
> >    c: 48 83 c4 38          add    $0x38,%rsp
> >   10: 5b                    pop    %rbx
> >   11: 5d                    pop    %rbp
> >   12: 41 5c                pop    %r12
> >   14: 41 5d                pop    %r13
> >   16: 41 5e                pop    %r14
> >   18: 41 5f                pop    %r15
> >   1a: c3                    retq
> >   1b: 65 48 8b 04 25 40 70 mov    %gs:0x17040,%rax
> >   22: 01 00
> >   24: 8b 80 f4 09 00 00    mov    0x9f4(%rax),%eax
> > * 2a: 85 c0                test   %eax,%eax <-- trapping instruction
> >   2c: 0f 85 c5 fe ff ff    jne    0xfffffef7
> >   32: 9c                    pushfq
> >   33: 8f 04 24              popq   (%rsp)
> >   36: fa                    cli
> >   37: 48 c7 c7 a0 36 5d 85 mov    $0xffffffff855d36a0,%rdi
> >   3e: e8                    .byte 0xe8
> >   3f: e3                    .byte 0xe3%
> >
> > Hao Sun <sunhao.th@gmail.com> =E4=BA=8E2021=E5=B9=B49=E6=9C=888=E6=97=
=A5=E5=91=A8=E4=B8=89 =E4=B8=8A=E5=8D=889:01=E5=86=99=E9=81=93=EF=BC=9A
> >>
> >> Pavel Begunkov <asml.silence@gmail.com> =E4=BA=8E2021=E5=B9=B49=E6=9C=
=888=E6=97=A5=E5=91=A8=E4=B8=89 =E4=B8=8A=E5=8D=885:31=E5=86=99=E9=81=93=EF=
=BC=9A
> >>>
> >>> On 9/7/21 8:30 PM, Jens Axboe wrote:
> >>>> On 9/7/21 5:50 AM, Hao Sun wrote:
> >>>>> Hello,
> >>>>>
> >>>>> When using Healer to fuzz the latest Linux kernel, the following cr=
ash
> >>>>> was triggered.
> >>>>>
> >>>>> HEAD commit: 7d2a07b76933 Linux 5.14
> >>>>> git tree: upstream
> >>>>> console output:
> >>>>> https://drive.google.com/file/d/1c8uRooM0TwJiTIwEviOCB4RC-hhOgGHR/v=
iew?usp=3Dsharing
> >>>>> kernel config: https://drive.google.com/file/d/1XD9WYDViQLSXN7RGwH8=
AGGDvP9JvOghx/view?usp=3Dsharing
> >>>>> Similar report:
> >>>>> https://groups.google.com/u/1/g/syzkaller-bugs/c/FvdcTiJIGtY/m/PcXk=
oenUAAAJ
> >>>>>
> >>>>> Sorry, I don't have a reproducer for this crash, hope the symbolize=
d
> >>>>> report can help.
> >>>>> If you fix this issue, please add the following tag to the commit:
> >>>>> Reported-by: Hao Sun <sunhao.th@gmail.com>
> >>>>
> >>>> Would be great with a reproducer for this one, though...
> >>>
> >>> And syzbot usually sends an execution log with all syz programs
> >>> it run, which may be helpful. Any chance you have anything similar
> >>> left?
> >>>
> >>
> >> Yes, found it[1]. Here is an execution history with latest 1024
> >> executed progs before crash saved.
> >> Hope it can help. I'll also follow this crash closely, see if Healer
> >> can find a reproducer and send it to you once it found.
> >>
> >> [1] https://drive.google.com/file/d/14k8qOFeyKPD4HsqOpIjud3b9jsxFSo-u/=
view?usp=3Dsharing
> >>
> >>> --
> >>> Pavel Begunkov
>
> --
> Pavel Begunkov
