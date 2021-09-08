Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 1FE8240344F
	for <lists+io-uring@lfdr.de>; Wed,  8 Sep 2021 08:36:58 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235956AbhIHGhj (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Wed, 8 Sep 2021 02:37:39 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:35720 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229634AbhIHGhj (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Wed, 8 Sep 2021 02:37:39 -0400
Received: from mail-pf1-x42a.google.com (mail-pf1-x42a.google.com [IPv6:2607:f8b0:4864:20::42a])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id CF66AC061575;
        Tue,  7 Sep 2021 23:36:31 -0700 (PDT)
Received: by mail-pf1-x42a.google.com with SMTP id f65so1169716pfb.10;
        Tue, 07 Sep 2021 23:36:31 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=mime-version:from:date:message-id:subject:to;
        bh=REqAq0TQ03LuKhzd+LhB8acuVBtqXUemFDgaAKLAStQ=;
        b=EHrE7iF2/32yXZ6fEmgY8pXUvr4wGzbChcWKEDxwn8WzEmxUVhEfTdubKhXc4estOB
         OK1+dz1HiOW0BBIGClGmd8CGcgYMwZFRMy68c9TdYVcHuSnnqxlDqvgO/bTnhnJnuBCl
         0ktXUrlZ0H39AAI9KErzdmLjGIq+LHq3q3+1oFmXcYdQq66kAAqjiEQBlHyQAXG/Hnx7
         X8lc+Jnz+f/6v//lbnYuGJsQATIfkZZSjGn7HPTAA/ufFpCEkT4zX4H103OLmZF3VUDp
         njfbD8nu63Z5NOiYpmjNHkNLyensaUZexQy9YYm4iaIeCiH3tW7LOVGP0arl80SpZJvv
         vvQA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:from:date:message-id:subject:to;
        bh=REqAq0TQ03LuKhzd+LhB8acuVBtqXUemFDgaAKLAStQ=;
        b=odeK1715dedUiHswfSXsleDbG7E2SAUVv5LFsdnoJDYpnd5n1B4nGMnoQP+bIYBuEx
         tnqlcAFnvHw+HKJ5mpZZZtza0QWHQfD7kYX/cOfRlDudVkH9hFbNwn3TNonI8g8uy0a9
         Dr7ikz1sJachyY+9y88pQcxCWekvWw76G2nVND+EMW8yq++535nHgUvfe/PYG2aA9CJ0
         VjZQsbGd95IEuToKi5MPE7FcqOwHtqe6H+RxqmxJI53udQINTTD5EnzesdsJ8GzID8el
         jNESdw2Rd385CQFxrt5CxaqBp4bsxCmBkhbuCuB+Z1xP5k5kBMBXNjJYh+Wrxk/j5uMP
         eh6Q==
X-Gm-Message-State: AOAM533K0OksQ/aDneLluTiyfr0omKupkDES0eFWhYR5wpW8dQ+/6ZSJ
        lUqsiTtO4jKSwHdxIYDtb76L8BXv2pPpkXxNlSY0lUVZqOSl
X-Google-Smtp-Source: ABdhPJy92+P0vEVeFEzRE8q16XIFtjJfCqTWqdby5iVs60b6VV47lY2H6shmsIY9kaVqJS75c5xCbKEazNwOi4i2Hng=
X-Received: by 2002:a63:e04a:: with SMTP id n10mr2149199pgj.381.1631082991145;
 Tue, 07 Sep 2021 23:36:31 -0700 (PDT)
MIME-Version: 1.0
From:   Hao Sun <sunhao.th@gmail.com>
Date:   Wed, 8 Sep 2021 14:36:20 +0800
Message-ID: <CACkBjsYSkne6QHbVL+kBWp5rMMQ_Mx66g2qEstW+asMFAfkOQQ@mail.gmail.com>
Subject: INFO: task hung in io_wq_put_and_exit
To:     Jens Axboe <axboe@kernel.dk>,
        Pavel Begunkov <asml.silence@gmail.com>,
        io-uring@vger.kernel.org, linux-kernel@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org

Hello,

When using Healer to fuzz the latest Linux kernel, the following crash
was triggered.

HEAD commit: 4b93c544e90e-thunderbolt: test: split up test cases
git tree: upstream
console output:
https://drive.google.com/file/d/1fR5UsoLxFVUrCd1Q9Jri5gcL73FRwHZ6/view?usp=sharing
kernel config: https://drive.google.com/file/d/1c0u2EeRDhRO-ZCxr9MP2VvAtJd6kfg-p/view?usp=sharing

Sorry, I don't have a reproducer for this crash, hope the symbolized
report can help.
Again, I'll follow this crash closely and send a reproducer to you
once Healer found it.
If you fix this issue, please add the following tag to the commit:
Reported-by: Hao Sun <sunhao.th@gmail.com>

INFO: task syz-executor:15090 blocked for more than 143 seconds.
      Not tainted 5.14.0+ #1
"echo 0 > /proc/sys/kernel/hung_task_timeout_secs" disables this message.
task:syz-executor    state:D stack:28528 pid:15090 ppid: 14496 flags:0x00024004
Call Trace:
 context_switch kernel/sched/core.c:4940 [inline]
 __schedule+0xcd9/0x2530 kernel/sched/core.c:6287
 schedule+0xd3/0x270 kernel/sched/core.c:6366
 schedule_timeout+0x5e5/0x890 kernel/time/timer.c:1857
 do_wait_for_common kernel/sched/completion.c:85 [inline]
 __wait_for_common kernel/sched/completion.c:106 [inline]
 wait_for_common kernel/sched/completion.c:117 [inline]
 wait_for_completion+0x17d/0x280 kernel/sched/completion.c:138
 io_wq_exit_workers fs/io-wq.c:1162 [inline]
 io_wq_put_and_exit+0x39a/0xc10 fs/io-wq.c:1197
 io_uring_clean_tctx fs/io_uring.c:9607 [inline]
 io_uring_cancel_generic+0x5fe/0x740 fs/io_uring.c:9687
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
RIP: 0033:0x4739cb
RSP: 002b:00007f284961dcd8 EFLAGS: 00000246 ORIG_RAX: 00000000000000ca
RAX: 00000000000000ca RBX: 000000000059c0a0 RCX: 00000000004739cd
RDX: 0000000000000000 RSI: 0000000000000080 RDI: 000000000059c0a8
RBP: 000000000059c0a8 R08: 0000000000000000 R09: 0000000000000000
R10: 0000000000000000 R11: 0000000000000246 R12: 000000000059c0ac
R13: 00007ffc50a8281f R14: 00007ffc50a829c0 R15: 00007f284961ddc0

Showing all locks held in the system:
2 locks held by kworker/0:1/7:
 #0: ffff888010c66538 ((wq_completion)rcu_gp){+.+.}-{0:0}, at:
arch_atomic64_set arch/x86/include/asm/atomic64_64.h:34 [inline]
 #0: ffff888010c66538 ((wq_completion)rcu_gp){+.+.}-{0:0}, at:
arch_atomic_long_set include/linux/atomic/atomic-long.h:41 [inline]
 #0: ffff888010c66538 ((wq_completion)rcu_gp){+.+.}-{0:0}, at:
atomic_long_set include/linux/atomic/atomic-instrumented.h:1198
[inline]
 #0: ffff888010c66538 ((wq_completion)rcu_gp){+.+.}-{0:0}, at:
set_work_data kernel/workqueue.c:634 [inline]
 #0: ffff888010c66538 ((wq_completion)rcu_gp){+.+.}-{0:0}, at:
set_work_pool_and_clear_pending kernel/workqueue.c:661 [inline]
 #0: ffff888010c66538 ((wq_completion)rcu_gp){+.+.}-{0:0}, at:
process_one_work+0x8c3/0x16d0 kernel/workqueue.c:2268
 #1: ffffc900006a7dc8 ((work_completion)(&rew.rew_work)){+.+.}-{0:0},
at: process_one_work+0x8f7/0x16d0 kernel/workqueue.c:2272
1 lock held by khungtaskd/984:
 #0: ffffffff8b97dde0 (rcu_read_lock){....}-{1:2}, at:
debug_show_all_locks+0x53/0x260 kernel/locking/lockdep.c:6446
1 lock held by in:imklog/8209:
 #0: ffff88801a11d4f0 (&f->f_pos_lock){+.+.}-{3:3}, at:
__fdget_pos+0xe9/0x100 fs/file.c:990
2 locks held by kworker/u8:2/9035:
 #0: ffff888135c319d8 (&rq->__lock){-.-.}-{2:2}, at:
raw_spin_rq_lock_nested+0x1e/0x30 kernel/sched/core.c:474
 #1: ffff888135c1f9c8 (&per_cpu_ptr(group->pcpu,
cpu)->seq){-.-.}-{0:0}, at: psi_task_switch+0x3ab/0x490
kernel/sched/psi.c:880
5 locks held by kworker/u8:5/15070:
 #0: ffff8881000ad138 ((wq_completion)netns){+.+.}-{0:0}, at:
arch_atomic64_set arch/x86/include/asm/atomic64_64.h:34 [inline]
 #0: ffff8881000ad138 ((wq_completion)netns){+.+.}-{0:0}, at:
arch_atomic_long_set include/linux/atomic/atomic-long.h:41 [inline]
 #0: ffff8881000ad138 ((wq_completion)netns){+.+.}-{0:0}, at:
atomic_long_set include/linux/atomic/atomic-instrumented.h:1198
[inline]
 #0: ffff8881000ad138 ((wq_completion)netns){+.+.}-{0:0}, at:
set_work_data kernel/workqueue.c:634 [inline]
 #0: ffff8881000ad138 ((wq_completion)netns){+.+.}-{0:0}, at:
set_work_pool_and_clear_pending kernel/workqueue.c:661 [inline]
 #0: ffff8881000ad138 ((wq_completion)netns){+.+.}-{0:0}, at:
process_one_work+0x8c3/0x16d0 kernel/workqueue.c:2268
 #1: ffffc9000773fdc8 (net_cleanup_work){+.+.}-{0:0}, at:
process_one_work+0x8f7/0x16d0 kernel/workqueue.c:2272
 #2: ffffffff8d0cc610 (pernet_ops_rwsem){++++}-{3:3}, at:
cleanup_net+0x9b/0xa90 net/core/net_namespace.c:553
 #3: ffffffff8d0e0228 (rtnl_mutex){+.+.}-{3:3}, at:
ip_tunnel_delete_nets+0x8f/0x5e0 net/ipv4/ip_tunnel.c:1118
 #4: ffffffff8b986f28 (rcu_state.exp_mutex){+.+.}-{3:3}, at:
exp_funnel_lock kernel/rcu/tree_exp.h:290 [inline]
 #4: ffffffff8b986f28 (rcu_state.exp_mutex){+.+.}-{3:3}, at:
synchronize_rcu_expedited+0x519/0x650 kernel/rcu/tree_exp.h:837
3 locks held by syz-executor/20774:

=============================================

NMI backtrace for cpu 0
CPU: 0 PID: 984 Comm: khungtaskd Not tainted 5.14.0+ #1
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
CPU: 1 PID: 20774 Comm: syz-executor Not tainted 5.14.0+ #1
Hardware name: QEMU Standard PC (i440FX + PIIX, 1996), BIOS
1.13.0-1ubuntu1.1 04/01/2014
RIP: 0010:hlock_id kernel/locking/lockdep.c:401 [inline]
RIP: 0010:__lock_acquire+0xa64/0x57e0 kernel/locking/lockdep.c:5003
Code: 89 c1 89 44 24 58 01 d8 c1 c1 04 89 44 24 48 89 4c 24 50 48 b8
00 00 00 00 00 fc ff df 48 8b 54 24 30 48 c1 ea 03 0f b6 04 02 <84> c0
74 08 3c 03 0f 8e ed 3c 00 00 0f b7 45 20 66 25 ff 1f 66 89
RSP: 0018:ffffc900007e0550 EFLAGS: 00000016
RAX: 0000000000000000 RBX: f501fefe41178ce3 RCX: ffff8880139c09f8
RDX: 1ffff1100273814d RSI: 0000000000000008 RDI: ffff8880139c0a69
RBP: ffff8880139c0a48 R08: 0000000000000001 R09: fffffbfff1fa011e
R10: ffffffff8fd008ef R11: fffffbfff1fa011d R12: 0000000000000040
R13: ffff8880139c0000 R14: 0000000000000002 R15: 0000000000000001
FS:  00007f496dccf700(0000) GS:ffff888135c00000(0000) knlGS:0000000000000000
CS:  0010 DS: 0000 ES: 0000 CR0: 0000000080050033
CR2: 00007f0079749710 CR3: 0000000017a50000 CR4: 0000000000350ee0
Call Trace:
 <IRQ>
 lock_acquire kernel/locking/lockdep.c:5625 [inline]
 lock_acquire+0x1ab/0x520 kernel/locking/lockdep.c:5590
 seqcount_lockdep_reader_access include/linux/seqlock.h:103 [inline]
 timekeeping_get_delta kernel/time/timekeeping.c:252 [inline]
 timekeeping_get_ns kernel/time/timekeeping.c:386 [inline]
 ktime_get+0x147/0x470 kernel/time/timekeeping.c:829
 clockevents_program_event+0x14a/0x370 kernel/time/clockevents.c:326
 tick_program_event+0xb9/0x150 kernel/time/tick-oneshot.c:44
 hrtimer_interrupt+0x36e/0x790 kernel/time/hrtimer.c:1824
 local_apic_timer_interrupt arch/x86/kernel/apic/apic.c:1086 [inline]
 __sysvec_apic_timer_interrupt+0x146/0x540 arch/x86/kernel/apic/apic.c:1103
 sysvec_apic_timer_interrupt+0x40/0xc0 arch/x86/kernel/apic/apic.c:1097
 asm_sysvec_apic_timer_interrupt+0x12/0x20 arch/x86/include/asm/idtentry.h:638
RIP: 0010:check_kcov_mode+0x14/0x40 kernel/kcov.c:163
Code: 7f 47 00 e9 61 fd ff ff cc cc cc cc cc cc cc cc cc cc cc cc cc
cc 65 8b 05 29 d0 8b 7e 89 c2 81 e2 00 01 00 00 a9 00 01 ff 00 <74> 10
31 c0 85 d2 74 15 8b 96 3c 15 00 00 85 d2 74 0b 8b 86 18 15
RSP: 0018:ffffc900007e09e8 EFLAGS: 00000206
RAX: 0000000080000301 RBX: 0000000000000000 RCX: ffffffff87bdf369
RDX: 0000000000000100 RSI: ffff8880139c0000 RDI: 0000000000000003
RBP: 0000000000000000 R08: 0000000000000000 R09: 0000000000000000
R10: 0000000000000004 R11: ffffed1026b86531 R12: 0000000000000000
R13: ffff88801985b840 R14: ffff88801985b800 R15: dffffc0000000000
 write_comp_data+0x1c/0x70 kernel/kcov.c:218
 ip_packet_match net/ipv4/netfilter/ip_tables.c:54 [inline]
 ipt_do_table+0x5f9/0x1970 net/ipv4/netfilter/ip_tables.c:284
 nf_hook_entry_hookfn include/linux/netfilter.h:142 [inline]
 nf_hook_slow+0xba/0x1e0 net/netfilter/core.c:589
 nf_hook include/linux/netfilter.h:262 [inline]
 NF_HOOK include/linux/netfilter.h:305 [inline]
 ip_rcv+0x204/0x3b0 net/ipv4/ip_input.c:540
 __netif_receive_skb_one_core+0x114/0x180 net/core/dev.c:5436
 __netif_receive_skb+0x24/0x1c0 net/core/dev.c:5550
 process_backlog+0x223/0x770 net/core/dev.c:6427
 __napi_poll+0xb3/0x630 net/core/dev.c:6982
 napi_poll net/core/dev.c:7049 [inline]
 net_rx_action+0x823/0xbc0 net/core/dev.c:7136
 __do_softirq+0x1d7/0x93b kernel/softirq.c:558
 do_softirq kernel/softirq.c:459 [inline]
 do_softirq+0xb1/0xf0 kernel/softirq.c:446
 </IRQ>
 __local_bh_enable_ip+0xf4/0x110 kernel/softirq.c:383
 local_bh_enable include/linux/bottom_half.h:32 [inline]
 rcu_read_unlock_bh include/linux/rcupdate.h:757 [inline]
 ip_finish_output2+0x8c1/0x21e0 net/ipv4/ip_output.c:222
 __ip_finish_output net/ipv4/ip_output.c:299 [inline]
 __ip_finish_output+0x856/0x1450 net/ipv4/ip_output.c:281
 ip_finish_output+0x32/0x200 net/ipv4/ip_output.c:309
 NF_HOOK_COND include/linux/netfilter.h:296 [inline]
 ip_mc_output+0x268/0xec0 net/ipv4/ip_output.c:408
 dst_output include/net/dst.h:450 [inline]
 ip_local_out+0xaf/0x1a0 net/ipv4/ip_output.c:126
 ip_send_skb+0x3e/0xe0 net/ipv4/ip_output.c:1555
 udp_send_skb.isra.0+0x6d2/0x11c0 net/ipv4/udp.c:966
 udp_sendmsg+0x1d86/0x2820 net/ipv4/udp.c:1253
 inet_sendmsg+0x99/0xe0 net/ipv4/af_inet.c:821
 sock_sendmsg_nosec net/socket.c:704 [inline]
 sock_sendmsg+0xcf/0x120 net/socket.c:724
 ____sys_sendmsg+0x331/0x810 net/socket.c:2409
 ___sys_sendmsg+0x100/0x170 net/socket.c:2463
 __sys_sendmmsg+0x195/0x470 net/socket.c:2549
 __do_sys_sendmmsg net/socket.c:2578 [inline]
 __se_sys_sendmmsg net/socket.c:2575 [inline]
 __x64_sys_sendmmsg+0x99/0x100 net/socket.c:2575
 do_syscall_x64 arch/x86/entry/common.c:50 [inline]
 do_syscall_64+0x35/0xb0 arch/x86/entry/common.c:80
 entry_SYSCALL_64_after_hwframe+0x44/0xae
RIP: 0033:0x4739cd
Code: 02 b8 ff ff ff ff c3 66 0f 1f 44 00 00 f3 0f 1e fa 48 89 f8 48
89 f7 48 89 d6 48 89 ca 4d 89 c2 4d 89 c8 4c 8b 4c 24 08 0f 05 <48> 3d
01 f0 ff ff 73 01 c3 48 c7 c1 bc ff ff ff f7 d8 64 89 01 48
RSP: 002b:00007f496dccec58 EFLAGS: 00000246 ORIG_RAX: 0000000000000133
RAX: ffffffffffffffda RBX: 000000000059c0a0 RCX: 00000000004739cd
RDX: 04000000000000a8 RSI: 0000000020000140 RDI: 0000000000000004
RBP: 00000000004ebd80 R08: 0000000000000000 R09: 0000000000000000
R10: 0000000000000000 R11: 0000000000000246 R12: 000000000059c0a0
R13: 00007ffc673401af R14: 00007ffc67340350 R15: 00007f496dccedc0
NMI backtrace for cpu 3 skipped: idling at native_safe_halt
arch/x86/include/asm/irqflags.h:51 [inline]
NMI backtrace for cpu 3 skipped: idling at arch_safe_halt
arch/x86/include/asm/irqflags.h:89 [inline]
NMI backtrace for cpu 3 skipped: idling at default_idle+0xb/0x10
arch/x86/kernel/process.c:716
NMI backtrace for cpu 2
CPU: 2 PID: 4951 Comm: systemd-journal Not tainted 5.14.0+ #1
Hardware name: QEMU Standard PC (i440FX + PIIX, 1996), BIOS
1.13.0-1ubuntu1.1 04/01/2014
RIP: 0010:dput+0x1a9/0xbd0 fs/dcache.c:890
Code: 9d 02 00 00 e8 18 8a a6 ff e8 33 49 93 ff e8 0e 8a a6 ff 48 c7
c6 23 96 cf 81 48 c7 c7 e0 dd 97 8b e8 6b c9 8b ff 48 83 c4 20 <5b> 5d
41 5c 41 5d 41 5e 41 5f e9 e8 89 a6 ff e8 e3 89 a6 ff 4c 89
RSP: 0018:ffffc9000104fbb8 EFLAGS: 00000286
RAX: 0000000000000000 RBX: 0000000000000001 RCX: ffff888015f30000
RDX: 0000000000000000 RSI: ffff888015f30000 RDI: 0000000000000002
RBP: 0000000000000000 R08: ffffffff81cf94b6 R09: 0000000000000000
R10: 0000000000000005 R11: ffffed100c7e6531 R12: 0000000000000000
R13: ffffc9000104fce8 R14: 0000000000000007 R15: 0000000000000000
FS:  00007f456d6698c0(0000) GS:ffff888063f00000(0000) knlGS:0000000000000000
CS:  0010 DS: 0000 ES: 0000 CR0: 0000000080050033
CR2: 00007f456ac62070 CR3: 000000001a2ce000 CR4: 0000000000350ee0
Call Trace:
 path_put fs/namei.c:557 [inline]
 terminate_walk+0x18f/0x5b0 fs/namei.c:672
 path_lookupat.isra.0+0x21e/0x580 fs/namei.c:2466
 __filename_lookup+0x1ca/0x410 fs/namei.c:2478
 filename_lookup fs/namei.c:2494 [inline]
 user_path_at_empty+0x42/0x60 fs/namei.c:2801
 user_path_at include/linux/namei.h:57 [inline]
 do_faccessat+0x127/0x850 fs/open.c:421
 do_syscall_x64 arch/x86/entry/common.c:50 [inline]
 do_syscall_64+0x35/0xb0 arch/x86/entry/common.c:80
 entry_SYSCALL_64_after_hwframe+0x44/0xae
RIP: 0033:0x7f456c9259c7
Code: 83 c4 08 48 3d 01 f0 ff ff 73 01 c3 48 8b 0d c8 d4 2b 00 f7 d8
64 89 01 48 83 c8 ff c3 66 0f 1f 44 00 00 b8 15 00 00 00 0f 05 <48> 3d
01 f0 ff ff 73 01 c3 48 8b 0d a1 d4 2b 00 f7 d8 64 89 01 48
RSP: 002b:00007ffcc2832828 EFLAGS: 00000246 ORIG_RAX: 0000000000000015
RAX: ffffffffffffffda RBX: 00007ffcc2835740 RCX: 00007f456c9259c7
RDX: 00007f456d396a00 RSI: 0000000000000000 RDI: 00005569e73aa9a3
RBP: 00007ffcc2832860 R08: 000000000000d0c0 R09: 0000000000000000
R10: 0000000000000069 R11: 0000000000000246 R12: 0000000000000000
R13: 0000000000000000 R14: 00007ffcc2835740 R15: 00007ffcc2832d50
----------------
Code disassembly (best guess):
   0: 89 c1                mov    %eax,%ecx
   2: 89 44 24 58          mov    %eax,0x58(%rsp)
   6: 01 d8                add    %ebx,%eax
   8: c1 c1 04              rol    $0x4,%ecx
   b: 89 44 24 48          mov    %eax,0x48(%rsp)
   f: 89 4c 24 50          mov    %ecx,0x50(%rsp)
  13: 48 b8 00 00 00 00 00 movabs $0xdffffc0000000000,%rax
  1a: fc ff df
  1d: 48 8b 54 24 30        mov    0x30(%rsp),%rdx
  22: 48 c1 ea 03          shr    $0x3,%rdx
  26: 0f b6 04 02          movzbl (%rdx,%rax,1),%eax
* 2a: 84 c0                test   %al,%al <-- trapping instruction
  2c: 74 08                je     0x36
  2e: 3c 03                cmp    $0x3,%al
  30: 0f 8e ed 3c 00 00    jle    0x3d23
  36: 0f b7 45 20          movzwl 0x20(%rbp),%eax
  3a: 66 25 ff 1f          and    $0x1fff,%ax
  3e: 66                    data16
  3f: 89                    .byte 0x89%
