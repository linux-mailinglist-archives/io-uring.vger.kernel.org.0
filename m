Return-Path: <io-uring+bounces-11850-lists+io-uring=lfdr.de@vger.kernel.org>
Delivered-To: lists+io-uring@lfdr.de
Received: from mail.lfdr.de
	by lfdr with LMTP
	id kBkcNVPob2lhUQAAu9opvQ
	(envelope-from <io-uring+bounces-11850-lists+io-uring=lfdr.de@vger.kernel.org>)
	for <lists+io-uring@lfdr.de>; Tue, 20 Jan 2026 21:40:51 +0100
X-Original-To: lists+io-uring@lfdr.de
Received: from ams.mirrors.kernel.org (ams.mirrors.kernel.org [213.196.21.55])
	by mail.lfdr.de (Postfix) with ESMTPS id 80D914B774
	for <lists+io-uring@lfdr.de>; Tue, 20 Jan 2026 21:40:51 +0100 (CET)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ams.mirrors.kernel.org (Postfix) with ESMTPS id 9BED58A7BBA
	for <lists+io-uring@lfdr.de>; Tue, 20 Jan 2026 18:31:11 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id B3EA7274FE8;
	Tue, 20 Jan 2026 18:31:06 +0000 (UTC)
X-Original-To: io-uring@vger.kernel.org
Received: from mail-oa1-f71.google.com (mail-oa1-f71.google.com [209.85.160.71])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 94C8D310771
	for <io-uring@vger.kernel.org>; Tue, 20 Jan 2026 18:31:04 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.160.71
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1768933866; cv=none; b=l90P2P30kZ2Wxp8TZuO2eLqFZb3OiRn/qVopPaa3luKIuILfbKBYvggSGMmD+wAp7FPFVXti/suexAqMqNFZSUmSLM9K2OXcUbNgmnPdX+yt7Bn4uT6xjzxsk9d1Ea91EENHOnvYXTWCAnkYyWQzswBK/DLqyUj1U9UZTboUzCI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1768933866; c=relaxed/simple;
	bh=5Ch2/yqDPPGfYbdjcBKG/5RLFkrnGbHdmtqcS4ingJI=;
	h=MIME-Version:Date:In-Reply-To:Message-ID:Subject:From:To:
	 Content-Type; b=o1ZdSHTBl51S2HoumuzYtXyeD3p3jckAiDL10tDq84Xbu2JYYS0BaqTpLvGyqyeWlZVZKOlZQ/4A28Ms8NnM6dQDbLezk7lU0NhsKB/dZkviSDRRp6oNvi7Gacu0VWivOXk9yCuE3ymtey8Mk6jrQy4uDxWBKWIbXRfFI8j7wBc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=fail (p=none dis=none) header.from=syzkaller.appspotmail.com; spf=pass smtp.mailfrom=M3KW2WVRGUFZ5GODRSRYTGD7.apphosting.bounces.google.com; arc=none smtp.client-ip=209.85.160.71
Authentication-Results: smtp.subspace.kernel.org; dmarc=fail (p=none dis=none) header.from=syzkaller.appspotmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=M3KW2WVRGUFZ5GODRSRYTGD7.apphosting.bounces.google.com
Received: by mail-oa1-f71.google.com with SMTP id 586e51a60fabf-404201da527so732783fac.0
        for <io-uring@vger.kernel.org>; Tue, 20 Jan 2026 10:31:04 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1768933863; x=1769538663;
        h=to:from:subject:message-id:in-reply-to:date:mime-version
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=ReYjMd3Id8kSdbx9FoxSFAnvsrMyl7q3Bwd3t/uAhZk=;
        b=PrxBbLwXdoyU002eVVnJsrUGqM363tJ1Atl6ui0ij51QIh9GFbhRXosYSAMYPzyhb+
         ocfpI3KxojpaOfQdeUqhAfp8aO/aJkUn9L8GoaYJoooN5dHhbVLG4pCDV8Pt/sJXJmLX
         EzvMoB/pAd4zpCBGoCd9Sut0KcJY7ilsCbn2SjdOdkJ58CXhMgs5tm3eB/u766Fdu1cH
         rR7KhVauwBoviZmvoI+U1gTNLNDsW863MiL2WYIThj7IK5yXMlnh8vNLXpyVlu0vnJLh
         EaLK9oYXrsJxI6rR1Ns2RfNe4Y3KEDcwc0lz7055SjZafL9SBn9zoU0VONgKN0JmEVG/
         XW1A==
X-Forwarded-Encrypted: i=1; AJvYcCWCc/HcqpB3AzUt/TRzUylj2Pjx+uYyymMkATGCGRIt+3xYeJqO4JEhx7dgHnuHYtXCJWeBe8/aeA==@vger.kernel.org
X-Gm-Message-State: AOJu0Ywcw6eB9oasOjeMUU4XubhxjVZ37hO1COyrMQG+fsawuBPWz2Ps
	av+LgR/GPKpux9WagZJ8rStLenSey5KF1Qh8X8b1Pyi1tHHYJDKY00CXu0OfUy3M4XmLJHi7fNa
	pqgpSBu4b1VmBSx18aqTPgerwDtE/lZOj5bEBSPluhh1Jxl3Q8/RdFJshIvs=
Precedence: bulk
X-Mailing-List: io-uring@vger.kernel.org
List-Id: <io-uring.vger.kernel.org>
List-Subscribe: <mailto:io-uring+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:io-uring+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-Received: by 2002:a4a:c483:0:b0:65f:cda0:e00d with SMTP id
 006d021491bc7-6610e5c4c38mr7075476eaf.17.1768933863349; Tue, 20 Jan 2026
 10:31:03 -0800 (PST)
Date: Tue, 20 Jan 2026 10:31:03 -0800
In-Reply-To: <48ccf244-6af6-4a62-b18f-e9fee573b319@kernel.dk>
X-Google-Appengine-App-Id: s~syzkaller
X-Google-Appengine-App-Id-Alias: syzkaller
Message-ID: <696fc9e7.a70a0220.111c58.0006.GAE@google.com>
Subject: Re: [syzbot] [io-uring?] INFO: task hung in io_wq_put_and_exit (6)
From: syzbot <syzbot+4eb282331cab6d5b6588@syzkaller.appspotmail.com>
To: axboe@kernel.dk, io-uring@vger.kernel.org, linux-kernel@vger.kernel.org, 
	syzkaller-bugs@googlegroups.com
Content-Type: text/plain; charset="UTF-8"
X-Spamd-Result: default: False [-0.16 / 15.00];
	ARC_ALLOW(-1.00)[subspace.kernel.org:s=arc-20240116:i=1];
	URI_HIDDEN_PATH(1.00)[https://syzkaller.appspot.com/x/.config?x=8f75eb998b5774eb];
	MAILLIST(-0.15)[generic];
	DMARC_POLICY_SOFTFAIL(0.10)[appspotmail.com : No valid SPF, No valid DKIM,none];
	MIME_GOOD(-0.10)[text/plain];
	HAS_LIST_UNSUB(-0.01)[];
	FORGED_RECIPIENTS_MAILLIST(0.00)[];
	RCPT_COUNT_THREE(0.00)[4];
	TAGGED_FROM(0.00)[bounces-11850-lists,io-uring=lfdr.de,4eb282331cab6d5b6588];
	FORGED_SENDER_MAILLIST(0.00)[];
	RCVD_TLS_LAST(0.00)[];
	RCVD_COUNT_THREE(0.00)[4];
	MISSING_XM_UA(0.00)[];
	SUBJECT_HAS_QUESTION(0.00)[];
	MIME_TRACE(0.00)[0:+];
	PRECEDENCE_BULK(0.00)[];
	FROM_NEQ_ENVFROM(0.00)[syzbot@syzkaller.appspotmail.com,io-uring@vger.kernel.org];
	FROM_HAS_DN(0.00)[];
	ASN(0.00)[asn:7979, ipnet:213.196.21.0/24, country:US];
	R_SPF_SOFTFAIL(0.00)[~all:c];
	R_DKIM_NA(0.00)[];
	TO_DN_NONE(0.00)[];
	TAGGED_RCPT(0.00)[io-uring];
	DBL_BLOCKED_OPENRESOLVER(0.00)[ams.mirrors.kernel.org:rdns,ams.mirrors.kernel.org:helo,syzkaller.appspot.com:url]
X-Rspamd-Queue-Id: 80D914B774
X-Rspamd-Action: no action
X-Rspamd-Server: lfdr

Hello,

syzbot has tested the proposed patch but the reproducer is still triggering an issue:
INFO: task hung in io_wq_put_and_exit

INFO: task syz.1.135:6891 blocked for more than 143 seconds.
      Not tainted syzkaller #0
      Blocked by coredump.
"echo 0 > /proc/sys/kernel/hung_task_timeout_secs" disables this message.
task:syz.1.135       state:D stack:25688 pid:6891  tgid:6887  ppid:6342   task_flags:0x400548 flags:0x00080000
Call Trace:
 <TASK>
 context_switch kernel/sched/core.c:5260 [inline]
 __schedule+0xfe4/0x5e10 kernel/sched/core.c:6867
 __schedule_loop kernel/sched/core.c:6949 [inline]
 schedule+0xdd/0x390 kernel/sched/core.c:6964
 schedule_timeout+0x1b2/0x280 kernel/time/sleep_timeout.c:75
 do_wait_for_common kernel/sched/completion.c:100 [inline]
 __wait_for_common+0x2e7/0x4c0 kernel/sched/completion.c:121
 io_wq_exit_workers io_uring/io-wq.c:1325 [inline]
 io_wq_put_and_exit+0x27b/0x8b0 io_uring/io-wq.c:1353
 io_uring_clean_tctx+0x114/0x180 io_uring/tctx.c:203
 io_uring_cancel_generic+0x7b9/0x810 io_uring/cancel.c:651
 io_uring_files_cancel include/linux/io_uring.h:19 [inline]
 do_exit+0x2be/0x2a30 kernel/exit.c:911
 do_group_exit+0xd5/0x2a0 kernel/exit.c:1112
 get_signal+0x1ec7/0x21e0 kernel/signal.c:3034
 arch_do_signal_or_restart+0x91/0x7a0 arch/x86/kernel/signal.c:337
 __exit_to_user_mode_loop kernel/entry/common.c:41 [inline]
 exit_to_user_mode_loop+0x86/0x4b0 kernel/entry/common.c:75
 __exit_to_user_mode_prepare include/linux/irq-entry-common.h:226 [inline]
 syscall_exit_to_user_mode_prepare include/linux/irq-entry-common.h:256 [inline]
 syscall_exit_to_user_mode_work include/linux/entry-common.h:159 [inline]
 syscall_exit_to_user_mode include/linux/entry-common.h:194 [inline]
 do_syscall_64+0x4fe/0xf80 arch/x86/entry/syscall_64.c:100
 entry_SYSCALL_64_after_hwframe+0x77/0x7f
RIP: 0033:0x7fee4299aef9
RSP: 002b:00007fee41fdd0e8 EFLAGS: 00000246 ORIG_RAX: 00000000000000ca
RAX: fffffffffffffe00 RBX: 00007fee42c06098 RCX: 00007fee4299aef9
RDX: 0000000000000000 RSI: 0000000000000080 RDI: 00007fee42c06098
RBP: 00007fee42c06090 R08: 0000000000000000 R09: 0000000000000000
R10: 0000000000000000 R11: 0000000000000246 R12: 0000000000000000
R13: 00007fee42c06128 R14: 00007fffcc8d1220 R15: 00007fffcc8d1308
 </TASK>

Showing all locks held in the system:
1 lock held by khungtaskd/31:
 #0: ffffffff8e3ca3a0 (rcu_read_lock){....}-{1:3}, at: rcu_lock_acquire include/linux/rcupdate.h:331 [inline]
 #0: ffffffff8e3ca3a0 (rcu_read_lock){....}-{1:3}, at: rcu_read_lock include/linux/rcupdate.h:867 [inline]
 #0: ffffffff8e3ca3a0 (rcu_read_lock){....}-{1:3}, at: debug_show_all_locks+0x3d/0x184 kernel/locking/lockdep.c:6775
3 locks held by kworker/u8:4/60:
3 locks held by kworker/u8:6/640:
 #0: ffff88813ff69948 ((wq_completion)events_unbound#2){+.+.}-{0:0}, at: process_one_work+0x11ae/0x1840 kernel/workqueue.c:3232
 #1: ffffc90003767c98 ((linkwatch_work).work){+.+.}-{0:0}, at: process_one_work+0x927/0x1840 kernel/workqueue.c:3233
 #2: ffffffff90158368 (rtnl_mutex){+.+.}-{4:4}, at: linkwatch_event+0x51/0xc0 net/core/link_watch.c:303
1 lock held by klogd/5176:
 #0: ffff8880b853ac98 (&rq->__lock){-.-.}-{2:2}, at: raw_spin_rq_lock_nested+0x29/0x130 kernel/sched/core.c:639
2 locks held by getty/5577:
 #0: ffff88814e2a20a0 (&tty->ldisc_sem){++++}-{0:0}, at: tty_ldisc_ref_wait+0x24/0x80 drivers/tty/tty_ldisc.c:243
 #1: ffffc9000332b2f0 (&ldata->atomic_read_lock){+.+.}-{4:4}, at: n_tty_read+0x419/0x1500 drivers/tty/n_tty.c:2211
2 locks held by kworker/u8:16/6594:
 #0: ffff8880b853ac98 (&rq->__lock){-.-.}-{2:2}, at: raw_spin_rq_lock_nested+0x29/0x130 kernel/sched/core.c:639
 #1: ffff8880b8524608 (psi_seq){-.-.}-{0:0}, at: psi_sched_switch kernel/sched/stats.h:225 [inline]
 #1: ffff8880b8524608 (psi_seq){-.-.}-{0:0}, at: __schedule+0x2b6f/0x5e10 kernel/sched/core.c:6861
2 locks held by kworker/u8:17/6607:
 #0: ffff88801d31e948 ((wq_completion)iou_exit){+.+.}-{0:0}, at: process_one_work+0x11ae/0x1840 kernel/workqueue.c:3232
 #1: ffffc90004207c98 ((work_completion)(&ctx->exit_work)){+.+.}-{0:0}, at: process_one_work+0x927/0x1840 kernel/workqueue.c:3233
2 locks held by kworker/u8:21/6678:
 #0: ffff88801d31e948 ((wq_completion)iou_exit){+.+.}-{0:0}, at: process_one_work+0x11ae/0x1840 kernel/workqueue.c:3232
 #1: ffffc9000465fc98 ((work_completion)(&ctx->exit_work)){+.+.}-{0:0}, at: process_one_work+0x927/0x1840 kernel/workqueue.c:3233
2 locks held by syz.1.135/6891:
1 lock held by iou-wrk-6891/6895:
3 locks held by kworker/u8:23/6986:
 #0: ffff88814cced948 ((wq_completion)ipv6_addrconf){+.+.}-{0:0}, at: process_one_work+0x11ae/0x1840 kernel/workqueue.c:3232
 #1: ffffc900053d7c98 ((work_completion)(&(&net->ipv6.addr_chk_work)->work)){+.+.}-{0:0}, at: process_one_work+0x927/0x1840 kernel/workqueue.c:3233
 #2: ffffffff90158368 (rtnl_mutex){+.+.}-{4:4}, at: rtnl_net_lock include/linux/rtnetlink.h:130 [inline]
 #2: ffffffff90158368 (rtnl_mutex){+.+.}-{4:4}, at: addrconf_verify_work+0x12/0x30 net/ipv6/addrconf.c:4734
2 locks held by kworker/u8:24/7246:
 #0: ffff88801d31e948 ((wq_completion)iou_exit){+.+.}-{0:0}, at: process_one_work+0x11ae/0x1840 kernel/workqueue.c:3232
 #1: ffffc90004b3fc98 ((work_completion)(&ctx->exit_work)){+.+.}-{0:0}, at: process_one_work+0x927/0x1840 kernel/workqueue.c:3233
1 lock held by iou-wrk-7337/7340:
2 locks held by kworker/u8:27/7716:
 #0: ffff88801d31e948 ((wq_completion)iou_exit){+.+.}-{0:0}
, at: process_one_work+0x11ae/0x1840 kernel/workqueue.c:3232
 #1: ffffc9000bea7c98 ((work_completion)(&ctx->exit_work)){+.+.}-{0:0}, at: process_one_work+0x927/0x1840 kernel/workqueue.c:3233
3 locks held by kworker/u8:28/7784:
3 locks held by kworker/0:11/8074:
 #0: ffff88813ff52948 ((wq_completion)events_power_efficient){+.+.}-{0:0}, at: process_one_work+0x11ae/0x1840 kernel/workqueue.c:3232
 #1: ffffc9000d847c98 ((reg_check_chans).work){+.+.}-{0:0}, at: process_one_work+0x927/0x1840 kernel/workqueue.c:3233
 #2: ffffffff90158368 (rtnl_mutex){+.+.}-{4:4}, at: reg_check_chans_work+0x91/0x10e0 net/wireless/reg.c:2453
3 locks held by syz-executor/8129:
 #0: ffffffff8f4e5fe8 (&ops->srcu#2){.+.+}-{0:0}, at: srcu_lock_acquire include/linux/srcu.h:185 [inline]
 #0: ffffffff8f4e5fe8 (&ops->srcu#2){.+.+}-{0:0}, at: srcu_read_lock include/linux/srcu.h:277 [inline]
 #0: ffffffff8f4e5fe8 (&ops->srcu#2){.+.+}-{0:0}, at: rtnl_link_ops_get+0x113/0x2c0 net/core/rtnetlink.c:574
 #1: ffffffff90158368 (rtnl_mutex){+.+.}-{4:4}, at: rtnl_lock net/core/rtnetlink.c:80 [inline]
 #1: ffffffff90158368 (rtnl_mutex){+.+.}-{4:4}, at: rtnl_nets_lock net/core/rtnetlink.c:341 [inline]
 #1: ffffffff90158368 (rtnl_mutex){+.+.}-{4:4}, at: rtnl_newlink+0x8bb/0x2380 net/core/rtnetlink.c:4071
 #2: ffffffff8e3d5db8 (rcu_state.exp_mutex){+.+.}-{4:4}, at: exp_funnel_lock+0x19e/0x3c0 kernel/rcu/tree_exp.h:343
1 lock held by dhcpcd/8197:
 #0: ffff888053802a48 (&sb->s_type->i_mutex_key#12){+.+.}-{4:4}, at: inode_lock include/linux/fs.h:1027 [inline]
 #0: ffff888053802a48 (&sb->s_type->i_mutex_key#12){+.+.}-{4:4}, at: __sock_release+0x86/0x260 net/socket.c:661
1 lock held by dhcpcd/8199:
 #0: ffff888053803008 (&sb->s_type->i_mutex_key#12){+.+.}-{4:4}, at: inode_lock include/linux/fs.h:1027 [inline]
 #0: ffff888053803008 (&sb->s_type->i_mutex_key#12){+.+.}-{4:4}, at: __sock_release+0x86/0x260 net/socket.c:661
2 locks held by dhcpcd/8202:
 #0: ffff88805380bb88 (&sb->s_type->i_mutex_key#12){+.+.}-{4:4}, at: inode_lock include/linux/fs.h:1027 [inline]
 #0: ffff88805380bb88 (&sb->s_type->i_mutex_key#12){+.+.}-{4:4}, at: __sock_release+0x86/0x260 net/socket.c:661
 #1: ffffffff8e3d5db8 (rcu_state.exp_mutex){+.+.}-{4:4}, at: exp_funnel_lock+0x19e/0x3c0 kernel/rcu/tree_exp.h:343
1 lock held by dhcpcd/8205:
 #0: ffff88807561b5c8 (&sb->s_type->i_mutex_key#12){+.+.}-{4:4}, at: inode_lock include/linux/fs.h:1027 [inline]
 #0: ffff88807561b5c8 (&sb->s_type->i_mutex_key#12){+.+.}-{4:4}, at: __sock_release+0x86/0x260 net/socket.c:661
1 lock held by dhcpcd/8208:
 #0: ffff888026d0e260 (sk_lock-AF_PACKET){+.+.}-{0:0}, at: lock_sock include/net/sock.h:1700 [inline]
 #0: ffff888026d0e260 (sk_lock-AF_PACKET){+.+.}-{0:0}, at: packet_do_bind+0x2c/0xf50 net/packet/af_packet.c:3197
1 lock held by syz-executor/8219:
 #0: ffffffff90158368 (rtnl_mutex){+.+.}-{4:4}, at: rtnl_net_lock include/linux/rtnetlink.h:130 [inline]
 #0: ffffffff90158368 (rtnl_mutex){+.+.}-{4:4}, at: inet_rtm_newaddr+0x30c/0x18b0 net/ipv4/devinet.c:978
2 locks held by syz.4.646/8226:
2 locks held by syz.5.647/8228:

=============================================

NMI backtrace for cpu 1
CPU: 1 UID: 0 PID: 31 Comm: khungtaskd Not tainted syzkaller #0 PREEMPT(full) 
Hardware name: Google Google Compute Engine/Google Compute Engine, BIOS Google 01/13/2026
Call Trace:
 <TASK>
 __dump_stack lib/dump_stack.c:94 [inline]
 dump_stack_lvl+0x100/0x190 lib/dump_stack.c:120
 nmi_cpu_backtrace.cold+0x12d/0x151 lib/nmi_backtrace.c:113
 nmi_trigger_cpumask_backtrace+0x1d7/0x230 lib/nmi_backtrace.c:62
 trigger_all_cpu_backtrace include/linux/nmi.h:161 [inline]
 __sys_info lib/sys_info.c:157 [inline]
 sys_info+0x141/0x190 lib/sys_info.c:165
 check_hung_uninterruptible_tasks kernel/hung_task.c:346 [inline]
 watchdog+0xcc3/0xfe0 kernel/hung_task.c:515
 kthread+0x3b3/0x730 kernel/kthread.c:463
 ret_from_fork+0x754/0xaf0 arch/x86/kernel/process.c:158
 ret_from_fork_asm+0x1a/0x30 arch/x86/entry/entry_64.S:246
 </TASK>
Sending NMI from CPU 1 to CPUs 0:
NMI backtrace for cpu 0
CPU: 0 UID: 0 PID: 8074 Comm: kworker/0:11 Not tainted syzkaller #0 PREEMPT(full) 
Hardware name: Google Google Compute Engine/Google Compute Engine, BIOS Google 01/13/2026
Workqueue: wg-crypt-wg1 wg_packet_encrypt_worker
RIP: 0010:wg_queue_enqueue_per_peer_tx+0x155/0x500 drivers/net/wireguard/queueing.h:183
Code: 00 00 00 00 00 fc ff df 48 8b 2b 48 8d bd b8 05 00 00 48 89 fa 48 c1 ea 03 80 3c 02 00 0f 85 69 03 00 00 48 8b 85 b8 05 00 00 <48> 8d bb 60 09 00 00 48 89 fa 48 89 44 24 08 48 c1 ea 03 48 b8 00
RSP: 0018:ffffc9000d847a90 EFLAGS: 00000246
RAX: ffff88806967b800 RBX: ffff88807f6c27a0 RCX: ffffffff8686ebc4
RDX: 1ffff1100643ba67 RSI: 0000000000000004 RDI: ffff8880321dd338
RBP: ffff8880321dcd80 R08: 0000000000000001 R09: ffffed100a3aea07
R10: ffff888051d7503b R11: caadeee402246cc6 R12: ffff888051d75000
R13: 0000000000000001 R14: ffff88807f6c2eb0 R15: dffffc0000000000
FS:  0000000000000000(0000) GS:ffff8881248c5000(0000) knlGS:0000000000000000
CS:  0010 DS: 0000 ES: 0000 CR0: 0000000080050033
CR2: 000020000017c000 CR3: 000000000e186000 CR4: 00000000003526f0
Call Trace:
 <TASK>
 wg_packet_encrypt_worker+0x7dc/0xbd0 drivers/net/wireguard/send.c:305
 process_one_work+0x9c2/0x1840 kernel/workqueue.c:3257
 process_scheduled_works kernel/workqueue.c:3340 [inline]
 worker_thread+0x5da/0xe40 kernel/workqueue.c:3421
 kthread+0x3b3/0x730 kernel/kthread.c:463
 ret_from_fork+0x754/0xaf0 arch/x86/kernel/process.c:158
 ret_from_fork_asm+0x1a/0x30 arch/x86/entry/entry_64.S:246
 </TASK>


Tested on:

commit:         c45d825f Merge branch 'io_uring-6.19' into syztest
git tree:       git://git.kernel.org/pub/scm/linux/kernel/git/axboe/linux.git syztest
console output: https://syzkaller.appspot.com/x/log.txt?x=10fe3c44580000
kernel config:  https://syzkaller.appspot.com/x/.config?x=8f75eb998b5774eb
dashboard link: https://syzkaller.appspot.com/bug?extid=4eb282331cab6d5b6588
compiler:       gcc (Debian 14.2.0-19) 14.2.0, GNU ld (GNU Binutils for Debian) 2.44

Note: no patches were applied.

