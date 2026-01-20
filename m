Return-Path: <io-uring+bounces-11833-lists+io-uring=lfdr.de@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from ams.mirrors.kernel.org (ams.mirrors.kernel.org [IPv6:2a01:60a::1994:3:14])
	by mail.lfdr.de (Postfix) with ESMTPS id CA7B6D3BE26
	for <lists+io-uring@lfdr.de>; Tue, 20 Jan 2026 05:13:10 +0100 (CET)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ams.mirrors.kernel.org (Postfix) with ESMTPS id 5231F345231
	for <lists+io-uring@lfdr.de>; Tue, 20 Jan 2026 04:13:10 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id DF86633A9CF;
	Tue, 20 Jan 2026 04:13:05 +0000 (UTC)
X-Original-To: io-uring@vger.kernel.org
Received: from mail-oo1-f70.google.com (mail-oo1-f70.google.com [209.85.161.70])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E99B233A9CC
	for <io-uring@vger.kernel.org>; Tue, 20 Jan 2026 04:13:03 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.161.70
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1768882385; cv=none; b=L4rX8kHK1QHk51IlSXK2gXu+pX5+retQEFbYdT3ZCeUNOxHPB+PVxBseeDhJjh+pUlJhbY7cBG/jRdqMThiZrF7jP9Y6NWF4W7SzWjiIM43mD4H2R9MSRm2cZj257DBNciMZWsErHSbxbnrVQcLkqBnWhfz1bB3rWmfIQc8TMUI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1768882385; c=relaxed/simple;
	bh=6f2r5HK0ufFy3xvOBB371cC+YVz/bfQ+cA75ulxM3nc=;
	h=MIME-Version:Date:In-Reply-To:Message-ID:Subject:From:To:
	 Content-Type; b=jYrN+YT8d+KQHDylR9fqDR9ujlg8FWkJusvDsDkKBI+VzIH2asZVigGf5/Jb5kB/4omdIvnHnZm94I09ZtJrcX8heUaCfb9qwdjPS9RfRz8YlYEsghSkMaQcBUQ40lZiAk+5iFPi7xJ5R4r19enEVhXhxBiV1bKDYrUJzL0VxRA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=fail (p=none dis=none) header.from=syzkaller.appspotmail.com; spf=pass smtp.mailfrom=M3KW2WVRGUFZ5GODRSRYTGD7.apphosting.bounces.google.com; arc=none smtp.client-ip=209.85.161.70
Authentication-Results: smtp.subspace.kernel.org; dmarc=fail (p=none dis=none) header.from=syzkaller.appspotmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=M3KW2WVRGUFZ5GODRSRYTGD7.apphosting.bounces.google.com
Received: by mail-oo1-f70.google.com with SMTP id 006d021491bc7-66102e59148so13341093eaf.2
        for <io-uring@vger.kernel.org>; Mon, 19 Jan 2026 20:13:03 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1768882383; x=1769487183;
        h=to:from:subject:message-id:in-reply-to:date:mime-version
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=iJi6wiYUWL2ss0B+GG6C4fCarFIqwWFGnPmTxlr/sj4=;
        b=tWQpVjBxlV+ygODn5N52h9R0OjfBHGSI23f897frvbGWpxxPRvejqC2H00grTWe3uO
         zXGXGuDF+jGTHgRn7hyswymWwli7VinRtGULbBqaUpI6wWrLTR+ciF+sQdujvfDhEjrS
         7mc7zQiN3T0XVcEUljF8F40xhhs9QuPUz26b4N9Q09WMV0+TM0X7sXH++bLt7zYP216/
         jQGLCg28mWtMJsEfnaSJNSiCsO6QuKgAskD83QhG3i1rWLlsDyliXOe2HrbCP53BAV3W
         Dz1pBU5MqKgyMbUP+GVgZWNUyrUA3VEv0axrhaXqLFxCBmbqQSJA0Ynh4XCSMUZ65VJn
         B72g==
X-Forwarded-Encrypted: i=1; AJvYcCWPMu8Pf94yVqrB/PLdamBIkE6p1dBDi6VdNXqk7R5rjzj5i8T4DlKUFy0HyyPHou5Hxv/pQeMRww==@vger.kernel.org
X-Gm-Message-State: AOJu0YzU0FPn0J82YY0JOdIZ8BUovn1J2L6CbuiI4Me0wloM/MqWMsir
	Y7aAtPK/HT7D2j+2tBj4o2dDTRjP/PV4/nou8uN7pkJ2Zkgs/IhTzftE+IqZTulWCRf5k9aE68T
	qclmRho8He7v5xNX1bYdp57ZY2W6beFsD2ETuyLC5H7tGIYStv1CoH2PvA+Y=
Precedence: bulk
X-Mailing-List: io-uring@vger.kernel.org
List-Id: <io-uring.vger.kernel.org>
List-Subscribe: <mailto:io-uring+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:io-uring+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-Received: by 2002:a05:6820:4a88:b0:660:fe2d:312e with SMTP id
 006d021491bc7-662b0063b8emr169639eaf.51.1768882382840; Mon, 19 Jan 2026
 20:13:02 -0800 (PST)
Date: Mon, 19 Jan 2026 20:13:02 -0800
In-Reply-To: <CAKb3OG8BWihCKJdn7WOvQwZ8M8TrC35xjkG-h904ybgJN8w-HA@mail.gmail.com>
X-Google-Appengine-App-Id: s~syzkaller
X-Google-Appengine-App-Id-Alias: syzkaller
Message-ID: <696f00ce.a00a0220.3ad28e.0001.GAE@google.com>
Subject: Re: [syzbot] [io-uring?] INFO: task hung in io_wq_put_and_exit (6)
From: syzbot <syzbot+4eb282331cab6d5b6588@syzkaller.appspotmail.com>
To: anna-maria@linutronix.de, axboe@kernel.dk, frederic@kernel.org, 
	io-uring@vger.kernel.org, linux-kernel@vger.kernel.org, 
	syzkaller-bugs@googlegroups.com, tglx@linutronix.de
Content-Type: text/plain; charset="UTF-8"

Hello,

syzbot has tested the proposed patch but the reproducer is still triggering an issue:
INFO: task hung in io_wq_exit_workers

INFO: task syz.2.600:7996 blocked for more than 143 seconds.
      Not tainted syzkaller #0
      Blocked by coredump.
"echo 0 > /proc/sys/kernel/hung_task_timeout_secs" disables this message.
task:syz.2.600       state:D stack:26824 pid:7996  tgid:7995  ppid:6341   task_flags:0x400548 flags:0x00080000
Call Trace:
 <TASK>
 context_switch kernel/sched/core.c:5260 [inline]
 __schedule+0x1138/0x5ee0 kernel/sched/core.c:6867
 __schedule_loop kernel/sched/core.c:6949 [inline]
 schedule+0xe7/0x3a0 kernel/sched/core.c:6964
 schedule_timeout+0x257/0x290 kernel/time/sleep_timeout.c:75
 do_wait_for_common kernel/sched/completion.c:100 [inline]
 __wait_for_common+0x2fc/0x4e0 kernel/sched/completion.c:121
 io_wq_exit_workers+0x3b7/0x8b0 io_uring/io-wq.c:1383
 io_wq_put_and_exit+0xba/0x270 io_uring/io-wq.c:1414
 io_uring_clean_tctx+0x10d/0x190 io_uring/tctx.c:203
 io_uring_cancel_generic+0x69c/0x9a0 io_uring/cancel.c:651
 io_uring_files_cancel include/linux/io_uring.h:19 [inline]
 do_exit+0x2ce/0x2bd0 kernel/exit.c:911
 do_group_exit+0xd3/0x2a0 kernel/exit.c:1112
 get_signal+0x2671/0x26d0 kernel/signal.c:3034
 arch_do_signal_or_restart+0x8f/0x7e0 arch/x86/kernel/signal.c:337
 __exit_to_user_mode_loop kernel/entry/common.c:41 [inline]
 exit_to_user_mode_loop+0x8c/0x540 kernel/entry/common.c:75
 __exit_to_user_mode_prepare include/linux/irq-entry-common.h:226 [inline]
 syscall_exit_to_user_mode_prepare include/linux/irq-entry-common.h:256 [inline]
 syscall_exit_to_user_mode_work include/linux/entry-common.h:159 [inline]
 syscall_exit_to_user_mode include/linux/entry-common.h:194 [inline]
 do_syscall_64+0x4ee/0xf80 arch/x86/entry/syscall_64.c:100
 entry_SYSCALL_64_after_hwframe+0x77/0x7f
RIP: 0033:0x7f22d238f749
RSP: 002b:00007f22d319b0e8 EFLAGS: 00000246 ORIG_RAX: 00000000000000ca
RAX: fffffffffffffe00 RBX: 00007f22d25e5fa8 RCX: 00007f22d238f749
RDX: 0000000000000000 RSI: 0000000000000080 RDI: 00007f22d25e5fa8
RBP: 00007f22d25e5fa0 R08: 0000000000000000 R09: 0000000000000000
R10: 0000000000000000 R11: 0000000000000246 R12: 0000000000000000
R13: 00007f22d25e6038 R14: 00007ffdc1419da0 R15: 00007ffdc1419e88
 </TASK>

Showing all locks held in the system:
3 locks held by kworker/0:0/9:
 #0: ffff88813ff51948 ((wq_completion)events){+.+.}-{0:0}, at: process_one_work+0x128d/0x1b20 kernel/workqueue.c:3232
 #1: 
ffffc900000e7c90 (deferred_process_work){+.+.}-{0:0}, at: process_one_work+0x914/0x1b20 kernel/workqueue.c:3233
 #2: ffffffff901428a8 (rtnl_mutex){+.+.}-{4:4}, at: switchdev_deferred_process_work+0xe/0x20 net/switchdev/switchdev.c:104
3 locks held by kworker/1:0/24:
1 lock held by khungtaskd/31:
 #0: ffffffff8e3c9620 (rcu_read_lock){....}-{1:3}, at: rcu_lock_acquire include/linux/rcupdate.h:331 [inline]
 #0: ffffffff8e3c9620 (rcu_read_lock){....}-{1:3}, at: rcu_read_lock include/linux/rcupdate.h:867 [inline]
 #0: ffffffff8e3c9620 (rcu_read_lock){....}-{1:3}, at: debug_show_all_locks+0x36/0x1c0 kernel/locking/lockdep.c:6775
2 locks held by kworker/u8:3/37:
 #0: ffff88801c7fd148 ((wq_completion)iou_exit){+.+.}-{0:0}, at: process_one_work+0x128d/0x1b20 kernel/workqueue.c:3232
 #1: ffffc90000ad7c90 ((work_completion)(&ctx->exit_work)){+.+.}-{0:0}, at: process_one_work+0x914/0x1b20 kernel/workqueue.c:3233
5 locks held by kworker/u8:7/1041:
 #0: ffff88801badc948 ((wq_completion)netns){+.+.}-{0:0}, at: process_one_work+0x128d/0x1b20 kernel/workqueue.c:3232
 #1: ffffc90003a4fc90 (net_cleanup_work){+.+.}-{0:0}, at: process_one_work+0x914/0x1b20 kernel/workqueue.c:3233
 #2: ffffffff9012bdd0 (pernet_ops_rwsem){++++}-{4:4}, at: cleanup_net+0xad/0x830 net/core/net_namespace.c:670
 #3: ffffffff901428a8 (rtnl_mutex){+.+.}-{4:4}, at: ops_exit_rtnl_list net/core/net_namespace.c:173 [inline]
 #3: ffffffff901428a8 (rtnl_mutex){+.+.}-{4:4}, at: ops_undo_list+0x7e9/0xab0 net/core/net_namespace.c:248
 #4: ffffffff8e3d4d78 (rcu_state.exp_mutex){+.+.}-{4:4}, at: exp_funnel_lock+0x284/0x3c0 kernel/rcu/tree_exp.h:311
3 locks held by kworker/u8:9/1147:
 #0: ffff88814cf76948 ((wq_completion)ipv6_addrconf){+.+.}-{0:0}, at: process_one_work+0x128d/0x1b20 kernel/workqueue.c:3232
 #1: ffffc90003f4fc90 ((work_completion)(&(&net->ipv6.addr_chk_work)->work)){+.+.}-{0:0}, at: process_one_work+0x914/0x1b20 kernel/workqueue.c:3233
 #2: ffffffff901428a8 (rtnl_mutex){+.+.}-{4:4}, at: rtnl_net_lock include/linux/rtnetlink.h:130 [inline]
 #2: ffffffff901428a8 (rtnl_mutex){+.+.}-{4:4}, at: addrconf_verify_work+0x12/0x30 net/ipv6/addrconf.c:4734
3 locks held by kworker/u8:11/3526:
2 locks held by kworker/u8:12/3877:
 #0: ffff88801c7fd148 ((wq_completion)iou_exit){+.+.}-{0:0}, at: process_one_work+0x128d/0x1b20 kernel/workqueue.c:3232
 #1: ffffc9000c8b7c90 ((work_completion)(&ctx->exit_work)){+.+.}-{0:0}, at: process_one_work+0x914/0x1b20 kernel/workqueue.c:3233
2 locks held by udevd/5186:
1 lock held by dhcpcd/5481:
 #0: ffffffff901428a8 (rtnl_mutex){+.+.}-{4:4}, at: rtnl_net_lock include/linux/rtnetlink.h:130 [inline]
 #0: ffffffff901428a8 (rtnl_mutex){+.+.}-{4:4}, at: devinet_ioctl+0x26d/0x1f30 net/ipv4/devinet.c:1120
2 locks held by getty/5573:
 #0: ffff8880367330a0 (&tty->ldisc_sem){++++}-{0:0}, at: tty_ldisc_ref_wait+0x24/0x80 drivers/tty/tty_ldisc.c:243
 #1: ffffc9000332e2f0 (&ldata->atomic_read_lock){+.+.}-{4:4}, at: n_tty_read+0x41b/0x1510 drivers/tty/n_tty.c:2211
3 locks held by kworker/1:5/6331:
3 locks held by kworker/u8:16/6619:
 #0: ffff88813ff69948 ((wq_completion)events_unbound#2){+.+.}-{0:0}, at: process_one_work+0x128d/0x1b20 kernel/workqueue.c:3232
 #1: ffffc90003e1fc90 ((linkwatch_work).work){+.+.}-{0:0}, at: process_one_work+0x914/0x1b20 kernel/workqueue.c:3233
 #2: ffffffff901428a8 (rtnl_mutex){+.+.}-{4:4}, at: linkwatch_event+0x51/0xc0 net/core/link_watch.c:303
2 locks held by kworker/u8:18/6822:
 #0: ffff88801c7fd148 ((wq_completion)iou_exit){+.+.}-{0:0}, at: process_one_work+0x128d/0x1b20 kernel/workqueue.c:3232
 #1: ffffc90003507c90 ((work_completion)(&ctx->exit_work)){+.+.}-{0:0}, at: process_one_work+0x914/0x1b20 kernel/workqueue.c:3233
7 locks held by kworker/1:10/7907:
2 locks held by kworker/u8:22/7948:
1 lock held by iou-wrk-7996/8005:
2 locks held by iou-wrk-8200/8202:
2 locks held by kworker/0:10/8282:
1 lock held by iou-wrk-8313/8318:
2 locks held by syz-executor/8492:
 #0: ffffffff90890c48 (&ops->srcu#2){.+.+}-{0:0}, at: srcu_lock_acquire include/linux/srcu.h:185 [inline]
 #0: ffffffff90890c48 (&ops->srcu#2){.+.+}-{0:0}, at: srcu_read_lock include/linux/srcu.h:277 [inline]
 #0: ffffffff90890c48 (&ops->srcu#2){.+.+}-{0:0}, at: rtnl_link_ops_get+0x113/0x2c0 net/core/rtnetlink.c:574
 #1: ffffffff901428a8 (rtnl_mutex){+.+.}-{4:4}, at: rtnl_lock net/core/rtnetlink.c:80 [inline]
 #1: ffffffff901428a8 (rtnl_mutex){+.+.}-{4:4}, at: rtnl_nets_lock net/core/rtnetlink.c:341 [inline]
 #1: ffffffff901428a8 (rtnl_mutex){+.+.}-{4:4}, at: rtnl_newlink+0x5f6/0x1f50 net/core/rtnetlink.c:4071
2 locks held by syz-executor/8544:
 #0: ffffffff8f4d9ea8 (
&ops->srcu
#2
){.+.+}-{0:0}
, at: srcu_lock_acquire include/linux/srcu.h:185 [inline]
, at: srcu_read_lock include/linux/srcu.h:277 [inline]
, at: rtnl_link_ops_get+0x113/0x2c0 net/core/rtnetlink.c:574
 #1: ffffffff901428a8 (rtnl_mutex){+.+.}-{4:4}, at: rtnl_lock net/core/rtnetlink.c:80 [inline]
 #1: ffffffff901428a8 (rtnl_mutex){+.+.}-{4:4}, at: rtnl_nets_lock net/core/rtnetlink.c:341 [inline]
 #1: ffffffff901428a8 (rtnl_mutex){+.+.}-{4:4}, at: rtnl_newlink+0x5f6/0x1f50 net/core/rtnetlink.c:4071
1 lock held by syz-executor/8572:
 #0: ffffffff901428a8 (rtnl_mutex){+.+.}-{4:4}, at: rtnl_net_lock include/linux/rtnetlink.h:130 [inline]
 #0: ffffffff901428a8 (rtnl_mutex){+.+.}-{4:4}, at: inet6_rtm_newaddr+0x4e4/0x1c50 net/ipv6/addrconf.c:5027
1 lock held by syz-executor/8691:
 #0: 
ffffffff901428a8 (rtnl_mutex){+.+.}-{4:4}, at: rtnl_net_lock include/linux/rtnetlink.h:130 [inline]
ffffffff901428a8 (rtnl_mutex){+.+.}-{4:4}, at: inet_rtm_newaddr+0x30c/0x1540 net/ipv4/devinet.c:978
1 lock held by syz.4.861/8697:
1 lock held by syz.3.862/8699:

=============================================

NMI backtrace for cpu 1
CPU: 1 UID: 0 PID: 31 Comm: khungtaskd Not tainted syzkaller #0 PREEMPT(full) 
Hardware name: Google Google Compute Engine/Google Compute Engine, BIOS Google 10/25/2025
Call Trace:
 <TASK>
 __dump_stack lib/dump_stack.c:94 [inline]
 dump_stack_lvl+0x116/0x1f0 lib/dump_stack.c:120
 nmi_cpu_backtrace+0x27b/0x390 lib/nmi_backtrace.c:113
 nmi_trigger_cpumask_backtrace+0x29c/0x300 lib/nmi_backtrace.c:62
 trigger_all_cpu_backtrace include/linux/nmi.h:161 [inline]
 __sys_info lib/sys_info.c:157 [inline]
 sys_info+0x133/0x180 lib/sys_info.c:165
 check_hung_uninterruptible_tasks kernel/hung_task.c:346 [inline]
 watchdog+0xe66/0x1180 kernel/hung_task.c:515
 kthread+0x3c5/0x780 kernel/kthread.c:463
 ret_from_fork+0x983/0xb10 arch/x86/kernel/process.c:158
 ret_from_fork_asm+0x1a/0x30 arch/x86/entry/entry_64.S:246
 </TASK>
Sending NMI from CPU 1 to CPUs 0:
NMI backtrace for cpu 0
CPU: 0 UID: 0 PID: 1041 Comm: kworker/u8:7 Not tainted syzkaller #0 PREEMPT(full) 
Hardware name: Google Google Compute Engine/Google Compute Engine, BIOS Google 10/25/2025
Workqueue: netns cleanup_net
RIP: 0010:__trace_hardirqs_on_caller kernel/locking/lockdep.c:4350 [inline]
RIP: 0010:lockdep_hardirqs_on_prepare+0xc2/0x1b0 kernel/locking/lockdep.c:4410
Code: 48 89 83 08 0b 00 00 e8 1c 02 df 09 be 02 00 00 00 48 89 df 65 ff 05 e5 59 19 12 e8 b8 fe ff ff 85 c0 74 0a 8b 83 10 0b 00 00 <85> c0 75 24 48 c7 c7 45 97 aa 8d e8 ee 01 df 09 b8 ff ff ff ff 65
RSP: 0018:ffffc90000007d10 EFLAGS: 00000002
RAX: 0000000000000000 RBX: ffff88802819c980 RCX: 0000000000000002
RDX: 0000000000000000 RSI: ffff88802819d528 RDI: ffff88802819c980
RBP: 0000000000000202 R08: 0000000000000000 R09: 0000000000000001
R10: ffffffff9088cdd7 R11: ffff88802819d4b0 R12: 0000000000000038
R13: dffffc0000000000 R14: ffff888050975f80 R15: 1ffff92000000faa
FS:  0000000000000000(0000) GS:ffff8881248f1000(0000) knlGS:0000000000000000
CS:  0010 DS: 0000 ES: 0000 CR0: 0000000080050033
CR2: 00002000006c6000 CR3: 0000000050306000 CR4: 00000000003526f0
Call Trace:
 <IRQ>
 trace_hardirqs_on+0x36/0x40 kernel/trace/trace_preemptirq.c:78
 __raw_spin_unlock_irqrestore include/linux/spinlock_api_smp.h:151 [inline]
 _raw_spin_unlock_irqrestore+0x52/0x80 kernel/locking/spinlock.c:194
 debug_object_deactivate+0x1ec/0x3a0 lib/debugobjects.c:888
 debug_rcu_head_unqueue kernel/rcu/rcu.h:248 [inline]
 rcu_do_batch kernel/rcu/tree.c:2597 [inline]
 rcu_core+0x72e/0x15f0 kernel/rcu/tree.c:2857
 handle_softirqs+0x219/0x950 kernel/softirq.c:622
 do_softirq kernel/softirq.c:523 [inline]
 do_softirq+0xb2/0xf0 kernel/softirq.c:510
 </IRQ>
 <TASK>
 __local_bh_enable_ip+0x100/0x120 kernel/softirq.c:450
 spin_unlock_bh include/linux/spinlock.h:396 [inline]
 addrconf_ifdown.isra.0+0x589/0x1b90 net/ipv6/addrconf.c:3907
 addrconf_notify+0x220/0x19f0 net/ipv6/addrconf.c:3776
 notifier_call_chain+0xbc/0x3e0 kernel/notifier.c:85
 call_netdevice_notifiers_info+0xbe/0x110 net/core/dev.c:2243
 call_netdevice_notifiers_extack net/core/dev.c:2281 [inline]
 call_netdevice_notifiers net/core/dev.c:2295 [inline]
 unregister_netdevice_many_notify+0xf81/0x2590 net/core/dev.c:12396
 ops_exit_rtnl_list net/core/net_namespace.c:187 [inline]
 ops_undo_list+0x8fc/0xab0 net/core/net_namespace.c:248
 cleanup_net+0x41b/0x830 net/core/net_namespace.c:696
 process_one_work+0x9ba/0x1b20 kernel/workqueue.c:3257
 process_scheduled_works kernel/workqueue.c:3340 [inline]
 worker_thread+0x6c8/0xf10 kernel/workqueue.c:3421
 kthread+0x3c5/0x780 kernel/kthread.c:463
 ret_from_fork+0x983/0xb10 arch/x86/kernel/process.c:158
 ret_from_fork_asm+0x1a/0x30 arch/x86/entry/entry_64.S:246
 </TASK>


Tested on:

commit:         ad6a6cb9 syztest
git tree:       git://git.kernel.org/pub/scm/linux/kernel/git/axboe/linux.git syztest
console output: https://syzkaller.appspot.com/x/log.txt?x=12502b9a580000
kernel config:  https://syzkaller.appspot.com/x/.config?x=1859476832863c41
dashboard link: https://syzkaller.appspot.com/bug?extid=4eb282331cab6d5b6588
compiler:       gcc (Debian 12.2.0-14+deb12u1) 12.2.0, GNU ld (GNU Binutils for Debian) 2.40

Note: no patches were applied.

