Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id CAADB4D9F12
	for <lists+io-uring@lfdr.de>; Tue, 15 Mar 2022 16:47:26 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1349742AbiCOPsg (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Tue, 15 Mar 2022 11:48:36 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:59938 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1349741AbiCOPsg (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Tue, 15 Mar 2022 11:48:36 -0400
Received: from mail-io1-f70.google.com (mail-io1-f70.google.com [209.85.166.70])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id C15531706E
        for <io-uring@vger.kernel.org>; Tue, 15 Mar 2022 08:47:23 -0700 (PDT)
Received: by mail-io1-f70.google.com with SMTP id g11-20020a056602072b00b00645cc0735d7so14809274iox.1
        for <io-uring@vger.kernel.org>; Tue, 15 Mar 2022 08:47:23 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:mime-version:date:message-id:subject:from:to;
        bh=28O813Gr5PUQvn0MMcHbwsRx/N+acJ5kb7o53u4YKO0=;
        b=HO1l32Xnelq6PonGMRqABFQZfduUyPF02Ic6m85yBPK4zaNFzIvnYktBTi3vnohiZr
         O9PRdItINuQf5NpuoIG+8XuEVcuyvMjx1n3dNnKmLPD3HDav9pRml+dOrbeQQRxDVjhV
         uyHmgiAsNLBw+ebP9LDVmVmgp5kUiK0HdWFmtk0Mk6t2rvkiaJZDHJ2oNNXhY3WFcC8Q
         nPkSsXSt79xoCk5as/2dzTu1JRP0V8C/H0iMOcNvxe/iXPGriy5otsJElL6ZDk1SCFyP
         pNSDqMjLGT/hcApdYmiRjNTFCY0QfpA9WPlYXAZb1T8lx1w4dD73LtdtYHnog43MXoDf
         JvNQ==
X-Gm-Message-State: AOAM532EPtKCq6mhRdzbXh2Jolzi2Fh1iRHE5Qz/b90cf7ZVcSd3feeb
        vRo/XS/1JfZU5/HzbHvLFN978D3gbMrVSYDuKpndvBdT45tu
X-Google-Smtp-Source: ABdhPJywPzr6mlKfw7AaKLCUPTJJ+2D7GtE9sQ9pZnQv49hU59a+AxAQHQyin3UVAh22WzaEKIHWZuZq+pP/icf7fEczCloQZBP1
MIME-Version: 1.0
X-Received: by 2002:a02:b048:0:b0:311:85be:a797 with SMTP id
 q8-20020a02b048000000b0031185bea797mr24041450jah.284.1647359243136; Tue, 15
 Mar 2022 08:47:23 -0700 (PDT)
Date:   Tue, 15 Mar 2022 08:47:23 -0700
X-Google-Appengine-App-Id: s~syzkaller
X-Google-Appengine-App-Id-Alias: syzkaller
Message-ID: <00000000000081366905da43b67d@google.com>
Subject: [syzbot] INFO: task hung in io_uring_del_tctx_node (2)
From:   syzbot <syzbot+771a9fd5d128e0a5708c@syzkaller.appspotmail.com>
To:     asml.silence@gmail.com, axboe@kernel.dk, io-uring@vger.kernel.org,
        linux-kernel@vger.kernel.org, syzkaller-bugs@googlegroups.com
Content-Type: text/plain; charset="UTF-8"
X-Spam-Status: No, score=-1.7 required=5.0 tests=BAYES_00,FROM_LOCAL_HEX,
        HEADER_FROM_DIFFERENT_DOMAINS,RCVD_IN_DNSWL_NONE,RCVD_IN_MSPIKE_H2,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=no
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org

Hello,

syzbot found the following issue on:

HEAD commit:    dda64ead7e82 Merge tag 'trace-v5.17-rc6' of git://git.kern..
git tree:       upstream
console output: https://syzkaller.appspot.com/x/log.txt?x=15d7671d700000
kernel config:  https://syzkaller.appspot.com/x/.config?x=aba0ab2928a512c2
dashboard link: https://syzkaller.appspot.com/bug?extid=771a9fd5d128e0a5708c
compiler:       gcc (Debian 10.2.1-6) 10.2.1 20210110, GNU ld (GNU Binutils for Debian) 2.35.2
syz repro:      https://syzkaller.appspot.com/x/repro.syz?x=11cb0461700000

IMPORTANT: if you fix the issue, please add the following tag to the commit:
Reported-by: syzbot+771a9fd5d128e0a5708c@syzkaller.appspotmail.com

INFO: task syz-executor.1:31000 blocked for more than 143 seconds.
      Not tainted 5.17.0-rc7-syzkaller-00200-gdda64ead7e82 #0
"echo 0 > /proc/sys/kernel/hung_task_timeout_secs" disables this message.
task:syz-executor.1  state:D stack:29160 pid:31000 ppid: 15800 flags:0x00004004
Call Trace:
 <TASK>
 context_switch kernel/sched/core.c:4995 [inline]
 __schedule+0xa94/0x4910 kernel/sched/core.c:6304
 schedule+0xd2/0x260 kernel/sched/core.c:6377
 schedule_preempt_disabled+0xf/0x20 kernel/sched/core.c:6436
 __mutex_lock_common kernel/locking/mutex.c:673 [inline]
 __mutex_lock+0xa32/0x12f0 kernel/locking/mutex.c:733
 io_uring_del_tctx_node+0x109/0x20a fs/io_uring.c:9875
 io_uring_clean_tctx fs/io_uring.c:9891 [inline]
 io_uring_cancel_generic+0x5c3/0x695 fs/io_uring.c:9969
 io_uring_files_cancel include/linux/io_uring.h:16 [inline]
 do_exit+0x523/0x2a30 kernel/exit.c:761
 do_group_exit+0xd2/0x2f0 kernel/exit.c:935
 get_signal+0x45a/0x2490 kernel/signal.c:2863
 arch_do_signal_or_restart+0x2a9/0x1c40 arch/x86/kernel/signal.c:868
 handle_signal_work kernel/entry/common.c:148 [inline]
 exit_to_user_mode_loop kernel/entry/common.c:172 [inline]
 exit_to_user_mode_prepare+0x17d/0x290 kernel/entry/common.c:207
 __syscall_exit_to_user_mode_work kernel/entry/common.c:289 [inline]
 syscall_exit_to_user_mode+0x19/0x60 kernel/entry/common.c:300
 do_syscall_64+0x42/0xb0 arch/x86/entry/common.c:86
 entry_SYSCALL_64_after_hwframe+0x44/0xae
RIP: 0033:0x7fe6cca58049
RSP: 002b:00007fe6cc1cd218 EFLAGS: 00000246 ORIG_RAX: 00000000000000ca
RAX: fffffffffffffe00 RBX: 00007fe6ccb6af68 RCX: 00007fe6cca58049
RDX: 0000000000000000 RSI: 0000000000000080 RDI: 00007fe6ccb6af68
RBP: 00007fe6ccb6af60 R08: 0000000000000000 R09: 0000000000000000
R10: 0000000000000000 R11: 0000000000000246 R12: 00007fe6ccb6af6c
R13: 00007ffc7aa5c47f R14: 00007fe6cc1cd300 R15: 0000000000022000
 </TASK>

Showing all locks held in the system:
1 lock held by khungtaskd/27:
 #0: ffffffff8bb820a0 (rcu_read_lock){....}-{1:2}, at: debug_show_all_locks+0x53/0x260 kernel/locking/lockdep.c:6460
2 locks held by getty/3275:
 #0: ffff88814aeae098 (&tty->ldisc_sem){++++}-{0:0}, at: tty_ldisc_ref_wait+0x22/0x80 drivers/tty/tty_ldisc.c:244
 #1: ffffc90002b5e2e8 (&ldata->atomic_read_lock){+.+.}-{3:3}, at: n_tty_read+0xcf0/0x1230 drivers/tty/n_tty.c:2075
1 lock held by syz-executor.1/31000:
 #0: ffff88801f8d10a8 (&ctx->uring_lock){+.+.}-{3:3}, at: io_uring_del_tctx_node+0x109/0x20a fs/io_uring.c:9875
2 locks held by syz-executor.1/31016:

=============================================

NMI backtrace for cpu 1
CPU: 1 PID: 27 Comm: khungtaskd Not tainted 5.17.0-rc7-syzkaller-00200-gdda64ead7e82 #0
Hardware name: Google Google Compute Engine/Google Compute Engine, BIOS Google 01/01/2011
Call Trace:
 <TASK>
 __dump_stack lib/dump_stack.c:88 [inline]
 dump_stack_lvl+0xcd/0x134 lib/dump_stack.c:106
 nmi_cpu_backtrace.cold+0x47/0x144 lib/nmi_backtrace.c:111
 nmi_trigger_cpumask_backtrace+0x1e6/0x230 lib/nmi_backtrace.c:62
 trigger_all_cpu_backtrace include/linux/nmi.h:146 [inline]
 check_hung_uninterruptible_tasks kernel/hung_task.c:212 [inline]
 watchdog+0xc1d/0xf50 kernel/hung_task.c:369
 kthread+0x2e9/0x3a0 kernel/kthread.c:377
 ret_from_fork+0x1f/0x30 arch/x86/entry/entry_64.S:295
 </TASK>
Sending NMI from CPU 1 to CPUs 0:
NMI backtrace for cpu 0
CPU: 0 PID: 3752 Comm: kworker/u4:5 Not tainted 5.17.0-rc7-syzkaller-00200-gdda64ead7e82 #0
Hardware name: Google Google Compute Engine/Google Compute Engine, BIOS Google 01/01/2011
Workqueue: bat_events batadv_nc_worker
RIP: 0010:__lock_is_held kernel/locking/lockdep.c:5380 [inline]
RIP: 0010:lock_is_held_type+0xa7/0x140 kernel/locking/lockdep.c:5682
Code: 12 e9 8a 00 00 00 83 c3 01 41 3b 9c 24 58 0a 00 00 7d 7d 48 63 c3 48 89 ee 48 8d 04 80 4d 8d 7c c5 00 4c 89 ff e8 99 fe ff ff <85> c0 74 d8 41 83 fe ff 41 bd 01 00 00 00 74 14 31 c0 41 f6 47 22
RSP: 0018:ffffc90002db7b00 EFLAGS: 00000096
RAX: 0000000000000000 RBX: 0000000000000001 RCX: 0000000000000001
RDX: 0000000000000000 RSI: ffffffff8bb81fe0 RDI: ffff888075e36b08
RBP: ffffffff8bb81fe0 R08: 0000000000000000 R09: ffffffff8d93f017
R10: fffffbfff1b27e02 R11: 0000000000000000 R12: ffff888075e36080
R13: ffff888075e36ae0 R14: 00000000ffffffff R15: ffff888075e36b08
FS:  0000000000000000(0000) GS:ffff8880b9c00000(0000) knlGS:0000000000000000
CS:  0010 DS: 0000 ES: 0000 CR0: 0000000080050033
CR2: 000055f753521608 CR3: 000000002103b000 CR4: 00000000003506f0
DR0: 0000000000000000 DR1: 0000000000000000 DR2: 0000000000000000
DR3: 0000000000000000 DR6: 00000000fffe0ff0 DR7: 0000000000000400
Call Trace:
 <TASK>
 lock_is_held include/linux/lockdep.h:283 [inline]
 rcu_read_lock_sched_held+0x3a/0x70 kernel/rcu/update.c:125
 trace_lock_release include/trace/events/lock.h:58 [inline]
 lock_release+0x522/0x720 kernel/locking/lockdep.c:5650
 __raw_spin_unlock_bh include/linux/spinlock_api_smp.h:165 [inline]
 _raw_spin_unlock_bh+0x12/0x30 kernel/locking/spinlock.c:210
 spin_unlock_bh include/linux/spinlock.h:394 [inline]
 batadv_nc_purge_paths+0x2a5/0x3a0 net/batman-adv/network-coding.c:471
 batadv_nc_worker+0x8f9/0xfa0 net/batman-adv/network-coding.c:720
 process_one_work+0x9ac/0x1650 kernel/workqueue.c:2307
 worker_thread+0x657/0x1110 kernel/workqueue.c:2454
 kthread+0x2e9/0x3a0 kernel/kthread.c:377
 ret_from_fork+0x1f/0x30 arch/x86/entry/entry_64.S:295
 </TASK>
----------------
Code disassembly (best guess):
   0:	12 e9                	adc    %cl,%ch
   2:	8a 00                	mov    (%rax),%al
   4:	00 00                	add    %al,(%rax)
   6:	83 c3 01             	add    $0x1,%ebx
   9:	41 3b 9c 24 58 0a 00 	cmp    0xa58(%r12),%ebx
  10:	00
  11:	7d 7d                	jge    0x90
  13:	48 63 c3             	movslq %ebx,%rax
  16:	48 89 ee             	mov    %rbp,%rsi
  19:	48 8d 04 80          	lea    (%rax,%rax,4),%rax
  1d:	4d 8d 7c c5 00       	lea    0x0(%r13,%rax,8),%r15
  22:	4c 89 ff             	mov    %r15,%rdi
  25:	e8 99 fe ff ff       	callq  0xfffffec3
* 2a:	85 c0                	test   %eax,%eax <-- trapping instruction
  2c:	74 d8                	je     0x6
  2e:	41 83 fe ff          	cmp    $0xffffffff,%r14d
  32:	41 bd 01 00 00 00    	mov    $0x1,%r13d
  38:	74 14                	je     0x4e
  3a:	31 c0                	xor    %eax,%eax
  3c:	41                   	rex.B
  3d:	f6                   	.byte 0xf6
  3e:	47                   	rex.RXB
  3f:	22                   	.byte 0x22


---
This report is generated by a bot. It may contain errors.
See https://goo.gl/tpsmEJ for more information about syzbot.
syzbot engineers can be reached at syzkaller@googlegroups.com.

syzbot will keep track of this issue. See:
https://goo.gl/tpsmEJ#status for how to communicate with syzbot.
syzbot can test patches for this issue, for details see:
https://goo.gl/tpsmEJ#testing-patches
