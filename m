Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 470926A7249
	for <lists+io-uring@lfdr.de>; Wed,  1 Mar 2023 18:49:54 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229754AbjCARtw (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Wed, 1 Mar 2023 12:49:52 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:47232 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229718AbjCARtv (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Wed, 1 Mar 2023 12:49:51 -0500
Received: from mail-il1-f199.google.com (mail-il1-f199.google.com [209.85.166.199])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 410E71EFE1
        for <io-uring@vger.kernel.org>; Wed,  1 Mar 2023 09:49:48 -0800 (PST)
Received: by mail-il1-f199.google.com with SMTP id p3-20020a056e02104300b00316f4afe7bfso8293963ilj.5
        for <io-uring@vger.kernel.org>; Wed, 01 Mar 2023 09:49:48 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=to:from:subject:message-id:date:mime-version:x-gm-message-state
         :from:to:cc:subject:date:message-id:reply-to;
        bh=VBx//GI9fBkRoJskyjmm33eUZriiBlsrIgQfYTTtXm0=;
        b=LBQR0reX8shyq0J/gPObaJTLqb9um3pf3ZgFGU5BCc8XP3fYqI6Q1cEnJqumiPQXpo
         bvsyzTSFwUEWESy4oRvcqIRQx6dpYL8o5bcdrRnsl8Opl3eakscQwlnR1dscobsMLOav
         Fii//zOkQSFLaG7Iff6RAMx1B1ppspwwPOPGkJY304e6FeVuZ1NV+H4EKc8kfIwx4xsg
         PtNuIcQ093qh5RMqeh0xMVwnDXU5Pspdczo2C39kOn4y0wvOcWn7Qtud/A2xRWdGCVGF
         haftJJxsulCquxiwpE/XldKJRWB/4VkMvKeeAPdoAPI0zN/VasfLBx7WIy5mrPrveYQz
         ugNg==
X-Gm-Message-State: AO0yUKWXdiQ/sKh5pKEASBGKvFcs2g81gUyucA5FAQ7d/SWoSwT+CVFe
        mZAk4y8FjLNtVtnPOXdFOj6YyQEO/Hpt52dbFo7LkAYCOoKn
X-Google-Smtp-Source: AK7set+Hr7yofe802yN+zu8f02fkiDyCg4i5o11TtP3Zxcd4ilTyD8nC9EHVytz2bZsip85ukJ9f6RjcZd0Qiib6UrvVhG5vHklA
MIME-Version: 1.0
X-Received: by 2002:a92:a005:0:b0:316:ff39:6bbf with SMTP id
 e5-20020a92a005000000b00316ff396bbfmr3322766ili.6.1677692987526; Wed, 01 Mar
 2023 09:49:47 -0800 (PST)
Date:   Wed, 01 Mar 2023 09:49:47 -0800
X-Google-Appengine-App-Id: s~syzkaller
X-Google-Appengine-App-Id-Alias: syzkaller
Message-ID: <00000000000090551605f5da56de@google.com>
Subject: [syzbot] [io-uring?] INFO: task hung in io_uring_register (3)
From:   syzbot <syzbot+dd640f307fbbd98248ae@syzkaller.appspotmail.com>
To:     asml.silence@gmail.com, axboe@kernel.dk, io-uring@vger.kernel.org,
        linux-kernel@vger.kernel.org, syzkaller-bugs@googlegroups.com
Content-Type: text/plain; charset="UTF-8"
X-Spam-Status: No, score=-1.6 required=5.0 tests=BAYES_00,FROM_LOCAL_HEX,
        HEADER_FROM_DIFFERENT_DOMAINS,RCVD_IN_DNSWL_NONE,RCVD_IN_MSPIKE_H2,
        SPF_HELO_NONE,SPF_PASS autolearn=no autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org

Hello,

syzbot found the following issue on:

HEAD commit:    489fa31ea873 Merge branch 'work.misc' of git://git.kernel...
git tree:       upstream
console output: https://syzkaller.appspot.com/x/log.txt?x=128ddea8c80000
kernel config:  https://syzkaller.appspot.com/x/.config?x=a8fa629ede9e7b9
dashboard link: https://syzkaller.appspot.com/bug?extid=dd640f307fbbd98248ae
compiler:       gcc (Debian 10.2.1-6) 10.2.1 20210110, GNU ld (GNU Binutils for Debian) 2.35.2
syz repro:      https://syzkaller.appspot.com/x/repro.syz?x=16426550c80000

Downloadable assets:
disk image: https://storage.googleapis.com/syzbot-assets/2f2344129720/disk-489fa31e.raw.xz
vmlinux: https://storage.googleapis.com/syzbot-assets/e1be11fcb953/vmlinux-489fa31e.xz
kernel image: https://storage.googleapis.com/syzbot-assets/4549005e4fa5/bzImage-489fa31e.xz

IMPORTANT: if you fix the issue, please add the following tag to the commit:
Reported-by: syzbot+dd640f307fbbd98248ae@syzkaller.appspotmail.com

INFO: task syz-executor.2:5302 blocked for more than 143 seconds.
      Not tainted 6.2.0-syzkaller-10827-g489fa31ea873 #0
"echo 0 > /proc/sys/kernel/hung_task_timeout_secs" disables this message.
task:syz-executor.2  state:D stack:30256 pid:5302  ppid:5194   flags:0x00004004
Call Trace:
 <TASK>
 context_switch kernel/sched/core.c:5304 [inline]
 __schedule+0xcce/0x5b20 kernel/sched/core.c:6622
 schedule+0xde/0x1a0 kernel/sched/core.c:6698
 schedule_preempt_disabled+0x13/0x20 kernel/sched/core.c:6757
 __mutex_lock_common kernel/locking/mutex.c:679 [inline]
 __mutex_lock+0xa3b/0x1350 kernel/locking/mutex.c:747
 __do_sys_io_uring_register+0x1a3/0x26e0 io_uring/io_uring.c:4342
 do_syscall_x64 arch/x86/entry/common.c:50 [inline]
 do_syscall_64+0x39/0xb0 arch/x86/entry/common.c:80
 entry_SYSCALL_64_after_hwframe+0x63/0xcd
RIP: 0033:0x7f23bae8c0f9
RSP: 002b:00007f23bbb9c168 EFLAGS: 00000246 ORIG_RAX: 00000000000001ab
RAX: ffffffffffffffda RBX: 00007f23bafac050 RCX: 00007f23bae8c0f9
RDX: 0000000000000000 RSI: 0000000000000008 RDI: 0000000000000003
RBP: 00007f23baee7ae9 R08: 0000000000000000 R09: 0000000000000000
R10: 0000000000000000 R11: 0000000000000246 R12: 0000000000000000
R13: 00007fff0d4913df R14: 00007f23bbb9c300 R15: 0000000000022000
 </TASK>
INFO: task syz-executor.3:5305 blocked for more than 144 seconds.
      Not tainted 6.2.0-syzkaller-10827-g489fa31ea873 #0
"echo 0 > /proc/sys/kernel/hung_task_timeout_secs" disables this message.
task:syz-executor.3  state:D stack:30256 pid:5305  ppid:5179   flags:0x00004004
Call Trace:
 <TASK>
 context_switch kernel/sched/core.c:5304 [inline]
 __schedule+0xcce/0x5b20 kernel/sched/core.c:6622
 schedule+0xde/0x1a0 kernel/sched/core.c:6698
 schedule_preempt_disabled+0x13/0x20 kernel/sched/core.c:6757
 __mutex_lock_common kernel/locking/mutex.c:679 [inline]
 __mutex_lock+0xa3b/0x1350 kernel/locking/mutex.c:747
 __do_sys_io_uring_register+0x1a3/0x26e0 io_uring/io_uring.c:4342
 do_syscall_x64 arch/x86/entry/common.c:50 [inline]
 do_syscall_64+0x39/0xb0 arch/x86/entry/common.c:80
 entry_SYSCALL_64_after_hwframe+0x63/0xcd
RIP: 0033:0x7f067608c0f9
RSP: 002b:00007f0676e67168 EFLAGS: 00000246 ORIG_RAX: 00000000000001ab
RAX: ffffffffffffffda RBX: 00007f06761ac050 RCX: 00007f067608c0f9
RDX: 0000000000000000 RSI: 0000000000000008 RDI: 0000000000000003
RBP: 00007f06760e7ae9 R08: 0000000000000000 R09: 0000000000000000
R10: 0000000000000000 R11: 0000000000000246 R12: 0000000000000000
R13: 00007ffd0036de8f R14: 00007f0676e67300 R15: 0000000000022000
 </TASK>
INFO: task syz-executor.5:5315 blocked for more than 145 seconds.
      Not tainted 6.2.0-syzkaller-10827-g489fa31ea873 #0
"echo 0 > /proc/sys/kernel/hung_task_timeout_secs" disables this message.
task:syz-executor.5  state:D stack:30256 pid:5315  ppid:5190   flags:0x00004004
Call Trace:
 <TASK>
 context_switch kernel/sched/core.c:5304 [inline]
 __schedule+0xcce/0x5b20 kernel/sched/core.c:6622
 schedule+0xde/0x1a0 kernel/sched/core.c:6698
 schedule_preempt_disabled+0x13/0x20 kernel/sched/core.c:6757
 __mutex_lock_common kernel/locking/mutex.c:679 [inline]
 __mutex_lock+0xa3b/0x1350 kernel/locking/mutex.c:747
 __do_sys_io_uring_register+0x1a3/0x26e0 io_uring/io_uring.c:4342
 do_syscall_x64 arch/x86/entry/common.c:50 [inline]
 do_syscall_64+0x39/0xb0 arch/x86/entry/common.c:80
 entry_SYSCALL_64_after_hwframe+0x63/0xcd
RIP: 0033:0x7f45d6a8c0f9
RSP: 002b:00007f45d77d1168 EFLAGS: 00000246 ORIG_RAX: 00000000000001ab
RAX: ffffffffffffffda RBX: 00007f45d6bac050 RCX: 00007f45d6a8c0f9
RDX: 0000000000000000 RSI: 0000000000000008 RDI: 0000000000000003
RBP: 00007f45d6ae7ae9 R08: 0000000000000000 R09: 0000000000000000
R10: 0000000000000000 R11: 0000000000000246 R12: 0000000000000000
R13: 00007ffd06c2e81f R14: 00007f45d77d1300 R15: 0000000000022000
 </TASK>
INFO: task syz-executor.4:5318 blocked for more than 145 seconds.
      Not tainted 6.2.0-syzkaller-10827-g489fa31ea873 #0
"echo 0 > /proc/sys/kernel/hung_task_timeout_secs" disables this message.
task:syz-executor.4  state:D stack:30256 pid:5318  ppid:5187   flags:0x00004004
Call Trace:
 <TASK>
 context_switch kernel/sched/core.c:5304 [inline]
 __schedule+0xcce/0x5b20 kernel/sched/core.c:6622
 schedule+0xde/0x1a0 kernel/sched/core.c:6698
 schedule_preempt_disabled+0x13/0x20 kernel/sched/core.c:6757
 __mutex_lock_common kernel/locking/mutex.c:679 [inline]
 __mutex_lock+0xa3b/0x1350 kernel/locking/mutex.c:747
 __do_sys_io_uring_register+0x1a3/0x26e0 io_uring/io_uring.c:4342
 do_syscall_x64 arch/x86/entry/common.c:50 [inline]
 do_syscall_64+0x39/0xb0 arch/x86/entry/common.c:80
 entry_SYSCALL_64_after_hwframe+0x63/0xcd
RIP: 0033:0x7f425968c0f9
RSP: 002b:00007f425a2ff168 EFLAGS: 00000246 ORIG_RAX: 00000000000001ab
RAX: ffffffffffffffda RBX: 00007f42597ac050 RCX: 00007f425968c0f9
RDX: 0000000000000000 RSI: 0000000000000008 RDI: 0000000000000003
RBP: 00007f42596e7ae9 R08: 0000000000000000 R09: 0000000000000000
R10: 0000000000000000 R11: 0000000000000246 R12: 0000000000000000
R13: 00007ffe718d541f R14: 00007f425a2ff300 R15: 0000000000022000
 </TASK>

Showing all locks held in the system:
1 lock held by rcu_tasks_kthre/12:
 #0: ffffffff8c796830 (rcu_tasks.tasks_gp_mutex){+.+.}-{3:3}, at: rcu_tasks_one_gp+0x31/0xd80 kernel/rcu/tasks.h:510
1 lock held by rcu_tasks_trace/13:
 #0: ffffffff8c796530 (rcu_tasks_trace.tasks_gp_mutex){+.+.}-{3:3}, at: rcu_tasks_one_gp+0x31/0xd80 kernel/rcu/tasks.h:510
1 lock held by khungtaskd/28:
 #0: ffffffff8c797380 (rcu_read_lock){....}-{1:2}, at: debug_show_all_locks+0x55/0x340 kernel/locking/lockdep.c:6495
2 locks held by getty/4760:
 #0: ffff888027b82098 (&tty->ldisc_sem){++++}-{0:0}, at: tty_ldisc_ref_wait+0x26/0x80 drivers/tty/tty_ldisc.c:244
 #1: ffffc900015902f0 (&ldata->atomic_read_lock){+.+.}-{3:3}, at: n_tty_read+0xef4/0x13e0 drivers/tty/n_tty.c:2177
3 locks held by kworker/u4:1/5222:
3 locks held by kworker/1:5/5239:
 #0: ffff888012470d38 ((wq_completion)events){+.+.}-{0:0}, at: arch_atomic64_set arch/x86/include/asm/atomic64_64.h:34 [inline]
 #0: ffff888012470d38 ((wq_completion)events){+.+.}-{0:0}, at: arch_atomic_long_set include/linux/atomic/atomic-long.h:41 [inline]
 #0: ffff888012470d38 ((wq_completion)events){+.+.}-{0:0}, at: atomic_long_set include/linux/atomic/atomic-instrumented.h:1280 [inline]
 #0: ffff888012470d38 ((wq_completion)events){+.+.}-{0:0}, at: set_work_data kernel/workqueue.c:639 [inline]
 #0: ffff888012470d38 ((wq_completion)events){+.+.}-{0:0}, at: set_work_pool_and_clear_pending kernel/workqueue.c:666 [inline]
 #0: ffff888012470d38 ((wq_completion)events){+.+.}-{0:0}, at: process_one_work+0x86d/0x1820 kernel/workqueue.c:2361
 #1: ffffc90004a57da8 ((work_completion)(&data->fib_event_work)){+.+.}-{0:0}, at: process_one_work+0x8a1/0x1820 kernel/workqueue.c:2365
 #2: ffff888068bfd240 (&data->fib_lock){+.+.}-{3:3}, at: nsim_fib_event_work+0x1d5/0x24a0 drivers/net/netdevsim/fib.c:1489
1 lock held by syz-executor.2/5301:
1 lock held by syz-executor.2/5302:
 #0: ffff8880250140a8 (&ctx->uring_lock){+.+.}-{3:3}, at: __do_sys_io_uring_register+0x1a3/0x26e0 io_uring/io_uring.c:4342
1 lock held by syz-executor.3/5304:
1 lock held by syz-executor.3/5305:
 #0: ffff888026c1c0a8 (&ctx->uring_lock){+.+.}-{3:3}, at: __do_sys_io_uring_register+0x1a3/0x26e0 io_uring/io_uring.c:4342
1 lock held by syz-executor.1/5308:
1 lock held by syz-executor.0/5311:
1 lock held by syz-executor.5/5314:
1 lock held by syz-executor.5/5315:
 #0: ffff88807ce8c0a8 (&ctx->uring_lock){+.+.}-{3:3}, at: __do_sys_io_uring_register+0x1a3/0x26e0 io_uring/io_uring.c:4342
1 lock held by syz-executor.4/5317:
1 lock held by syz-executor.4/5318:
 #0: ffff88802975e0a8 (&ctx->uring_lock){+.+.}-{3:3}, at: __do_sys_io_uring_register+0x1a3/0x26e0 io_uring/io_uring.c:4342
2 locks held by kworker/u4:9/5424:
 #0: ffff888012479138 ((wq_completion)events_unbound){+.+.}-{0:0}, at: arch_atomic64_set arch/x86/include/asm/atomic64_64.h:34 [inline]
 #0: ffff888012479138 ((wq_completion)events_unbound){+.+.}-{0:0}, at: arch_atomic_long_set include/linux/atomic/atomic-long.h:41 [inline]
 #0: ffff888012479138 ((wq_completion)events_unbound){+.+.}-{0:0}, at: atomic_long_set include/linux/atomic/atomic-instrumented.h:1280 [inline]
 #0: ffff888012479138 ((wq_completion)events_unbound){+.+.}-{0:0}, at: set_work_data kernel/workqueue.c:639 [inline]
 #0: ffff888012479138 ((wq_completion)events_unbound){+.+.}-{0:0}, at: set_work_pool_and_clear_pending kernel/workqueue.c:666 [inline]
 #0: ffff888012479138 ((wq_completion)events_unbound){+.+.}-{0:0}, at: process_one_work+0x86d/0x1820 kernel/workqueue.c:2361
 #1: ffffc900051f7da8 ((work_completion)(&sub_info->work)){+.+.}-{0:0}, at: process_one_work+0x8a1/0x1820 kernel/workqueue.c:2365
1 lock held by syz-executor.2/5427:
1 lock held by syz-executor.2/5433:
 #0: ffff888066b440a8 (&ctx->uring_lock){+.+.}-{3:3}, at: __do_sys_io_uring_register+0x1a3/0x26e0 io_uring/io_uring.c:4342
1 lock held by syz-executor.1/5443:
1 lock held by syz-executor.3/5444:
1 lock held by syz-executor.0/5457:
1 lock held by syz-executor.0/5458:
 #0: ffff888075eac0a8 (&ctx->uring_lock){+.+.}-{3:3}, at: __do_sys_io_uring_register+0x1a3/0x26e0 io_uring/io_uring.c:4342
1 lock held by syz-executor.5/5460:
1 lock held by syz-executor.5/5461:
 #0: ffff88806d1ac0a8 (&ctx->uring_lock){+.+.}-{3:3}, at: __do_sys_io_uring_register+0x1a3/0x26e0 io_uring/io_uring.c:4342
1 lock held by syz-executor.4/5463:
1 lock held by syz-executor.2/5471:
 #0: ffffffff8e104248 (rtnl_mutex){+.+.}-{3:3}, at: rtnl_lock net/core/rtnetlink.c:75 [inline]
 #0: ffffffff8e104248 (rtnl_mutex){+.+.}-{3:3}, at: rtnetlink_rcv_msg+0x3e8/0xd50 net/core/rtnetlink.c:6171
2 locks held by syz-executor.0/5485:
 #0: ffffffff8e104248 (rtnl_mutex){+.+.}-{3:3}, at: rtnl_lock net/core/rtnetlink.c:75 [inline]
 #0: ffffffff8e104248 (rtnl_mutex){+.+.}-{3:3}, at: rtnetlink_rcv_msg+0x3e8/0xd50 net/core/rtnetlink.c:6171
 #1: ffffffff8c7a2678 (rcu_state.exp_mutex){+.+.}-{3:3}, at: exp_funnel_lock kernel/rcu/tree_exp.h:293 [inline]
 #1: ffffffff8c7a2678 (rcu_state.exp_mutex){+.+.}-{3:3}, at: synchronize_rcu_expedited+0x64a/0x770 kernel/rcu/tree_exp.h:989
2 locks held by syz-executor.5/5497:
 #0: ffffffff8e0f0610 (pernet_ops_rwsem){++++}-{3:3}, at: copy_net_ns+0x4cb/0x8e0 net/core/net_namespace.c:486
 #1: ffffffff8e104248 (rtnl_mutex){+.+.}-{3:3}, at: smc_pnet_create_pnetids_list net/smc/smc_pnet.c:809 [inline]
 #1: ffffffff8e104248 (rtnl_mutex){+.+.}-{3:3}, at: smc_pnet_net_init+0x131/0x230 net/smc/smc_pnet.c:878

=============================================

NMI backtrace for cpu 1
CPU: 1 PID: 28 Comm: khungtaskd Not tainted 6.2.0-syzkaller-10827-g489fa31ea873 #0
Hardware name: Google Google Compute Engine/Google Compute Engine, BIOS Google 02/16/2023
Call Trace:
 <TASK>
 __dump_stack lib/dump_stack.c:88 [inline]
 dump_stack_lvl+0xd9/0x150 lib/dump_stack.c:106
 nmi_cpu_backtrace+0x316/0x3e0 lib/nmi_backtrace.c:113
 nmi_trigger_cpumask_backtrace+0x33f/0x460 lib/nmi_backtrace.c:62
 trigger_all_cpu_backtrace include/linux/nmi.h:148 [inline]
 check_hung_uninterruptible_tasks kernel/hung_task.c:222 [inline]
 watchdog+0xe94/0x11e0 kernel/hung_task.c:379
 kthread+0x2e8/0x3a0 kernel/kthread.c:376
 ret_from_fork+0x1f/0x30 arch/x86/entry/entry_64.S:308
 </TASK>
Sending NMI from CPU 1 to CPUs 0:
NMI backtrace for cpu 0
CPU: 0 PID: 5317 Comm: syz-executor.4 Not tainted 6.2.0-syzkaller-10827-g489fa31ea873 #0
Hardware name: Google Google Compute Engine/Google Compute Engine, BIOS Google 02/16/2023
RIP: 0010:check_kcov_mode kernel/kcov.c:173 [inline]
RIP: 0010:__sanitizer_cov_trace_pc+0x11/0x70 kernel/kcov.c:207
Code: a8 01 00 00 e8 b0 ff ff ff 31 c0 c3 66 66 2e 0f 1f 84 00 00 00 00 00 66 90 f3 0f 1e fa 65 8b 05 3d f1 7e 7e 89 c1 48 8b 34 24 <81> e1 00 01 00 00 65 48 8b 14 25 80 b8 03 00 a9 00 01 ff 00 74 0e
RSP: 0018:ffffc90004d77a68 EFLAGS: 00000202
RAX: 0000000080000000 RBX: ffff888068962140 RCX: 0000000080000000
RDX: ffff8880201a8000 RSI: ffffffff84145c61 RDI: 0000000000000005
RBP: ffff888068962184 R08: 0000000000000005 R09: 0000000000000000
R10: 0000000000000010 R11: 0000000000000000 R12: 000000000004001c
R13: ffff88802975e000 R14: 0000000000000010 R15: ffff888068962210
FS:  00007f425a320700(0000) GS:ffff8880b9800000(0000) knlGS:0000000000000000
CS:  0010 DS: 0000 ES: 0000 CR0: 0000000080050033
CR2: 00007f25da7fee20 CR3: 0000000076bfe000 CR4: 00000000003506f0
DR0: 0000000000000000 DR1: 0000000000000000 DR2: 0000000000000000
DR3: 0000000000000000 DR6: 00000000fffe0ff0 DR7: 0000000000000400
Call Trace:
 <TASK>
 io_prep_async_work+0x1e1/0x6f0 io_uring/io_uring.c:422
 io_prep_async_link+0x71/0x150 io_uring/io_uring.c:449
 io_queue_iowq+0xfd/0x5d0 io_uring/io_uring.c:462
 io_req_task_submit+0x190/0x290 io_uring/io_uring.c:1423
 handle_tw_list io_uring/io_uring.c:1184 [inline]
 tctx_task_work+0x2d7/0xb30 io_uring/io_uring.c:1246
 task_work_run+0x16f/0x270 kernel/task_work.c:179
 get_signal+0x1c7/0x25b0 kernel/signal.c:2635
 arch_do_signal_or_restart+0x79/0x5c0 arch/x86/kernel/signal.c:306
 exit_to_user_mode_loop kernel/entry/common.c:168 [inline]
 exit_to_user_mode_prepare+0x15f/0x250 kernel/entry/common.c:203
 __syscall_exit_to_user_mode_work kernel/entry/common.c:285 [inline]
 syscall_exit_to_user_mode+0x1d/0x50 kernel/entry/common.c:296
 do_syscall_64+0x46/0xb0 arch/x86/entry/common.c:86
 entry_SYSCALL_64_after_hwframe+0x63/0xcd
RIP: 0033:0x7f425968c0f9
Code: 28 00 00 00 75 05 48 83 c4 28 c3 e8 f1 19 00 00 90 48 89 f8 48 89 f7 48 89 d6 48 89 ca 4d 89 c2 4d 89 c8 4c 8b 4c 24 08 0f 05 <48> 3d 01 f0 ff ff 73 01 c3 48 c7 c1 b8 ff ff ff f7 d8 64 89 01 48
RSP: 002b:00007f425a320168 EFLAGS: 00000246 ORIG_RAX: 00000000000001aa
RAX: 00000000000040b3 RBX: 00007f42597abf80 RCX: 00007f425968c0f9
RDX: 0000000000000000 RSI: 00000000000040b3 RDI: 0000000000000003
RBP: 00007f42596e7ae9 R08: 0000000020000000 R09: 0000000000000008
R10: 0000000000000000 R11: 0000000000000246 R12: 0000000000000000
R13: 00007ffe718d541f R14: 00007f425a320300 R15: 0000000000022000
 </TASK>


---
This report is generated by a bot. It may contain errors.
See https://goo.gl/tpsmEJ for more information about syzbot.
syzbot engineers can be reached at syzkaller@googlegroups.com.

syzbot will keep track of this issue. See:
https://goo.gl/tpsmEJ#status for how to communicate with syzbot.
syzbot can test patches for this issue, for details see:
https://goo.gl/tpsmEJ#testing-patches
