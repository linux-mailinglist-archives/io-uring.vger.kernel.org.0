Return-Path: <io-uring+bounces-10318-lists+io-uring=lfdr.de@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [IPv6:2604:1380:4601:e00::3])
	by mail.lfdr.de (Postfix) with ESMTPS id 2D1A6C28928
	for <lists+io-uring@lfdr.de>; Sun, 02 Nov 2025 02:44:38 +0100 (CET)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id 4E1C71892280
	for <lists+io-uring@lfdr.de>; Sun,  2 Nov 2025 01:45:02 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 248FF223702;
	Sun,  2 Nov 2025 01:44:34 +0000 (UTC)
X-Original-To: io-uring@vger.kernel.org
Received: from mail-il1-f205.google.com (mail-il1-f205.google.com [209.85.166.205])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 293C51DF985
	for <io-uring@vger.kernel.org>; Sun,  2 Nov 2025 01:44:31 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.166.205
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1762047874; cv=none; b=RvVQTlz5Nedotz1xNc0HPxrexHGyt4iuWgkpp7pKRRGCue7yYFsbIfgaqG3P03jKLPNYlHW2CSY/UWCc4QFOvvkHB16ck9E+zAkpAJjPZ+nJkiPujyJKIHM93hVPq6w+NS7HWsUCha4ZH2bWlx/gKPh/+BNz+GVsn5Ov22bBaqo=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1762047874; c=relaxed/simple;
	bh=MnHxfTe/ro3pNp+P4+5QksWyWpO2QTWHwpW8O31pDVM=;
	h=MIME-Version:Date:Message-ID:Subject:From:To:Content-Type; b=ZhRMBornRwn1Yj1mlS8gZj3ZqU5EFTcm7mFbwowicqto31lTGiCDbAQdm/eXOrR7UvS3zQHkuGBlh/fDO2HKIy2xKbavxX5buPRmvD9CK0vMw4fxoK2Q83Is3w2FgLYDEe+CqZLeN2/njx+LvIiJSSmeuGhCPXx+vv1G9LL/QJk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=fail (p=none dis=none) header.from=syzkaller.appspotmail.com; spf=pass smtp.mailfrom=M3KW2WVRGUFZ5GODRSRYTGD7.apphosting.bounces.google.com; arc=none smtp.client-ip=209.85.166.205
Authentication-Results: smtp.subspace.kernel.org; dmarc=fail (p=none dis=none) header.from=syzkaller.appspotmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=M3KW2WVRGUFZ5GODRSRYTGD7.apphosting.bounces.google.com
Received: by mail-il1-f205.google.com with SMTP id e9e14a558f8ab-4332ae73d5cso526655ab.1
        for <io-uring@vger.kernel.org>; Sat, 01 Nov 2025 18:44:31 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1762047871; x=1762652671;
        h=to:from:subject:message-id:date:mime-version:x-gm-message-state
         :from:to:cc:subject:date:message-id:reply-to;
        bh=/xnYtSi/k4ns0oXpK2890qilXlLi2kOa/vqykwDxDXU=;
        b=m/ohiIS43NTCO+ZK/QCHwcDGJxWNrh/moueEu6cGj3xv1KqozGAz5ij27/oi7zQ9zg
         M3sIGizHBUxiL5ZGEuScTQVpTG1ZZ9yK8T2E/fJT0wi2w8wcyuePVnxujXjNCh/pv/VO
         4sujf0bYsDrFT3CbUmP7vYUc/qX7phav0lOnPta44RD5oo8EOFrEz0jXFAC16k4QJlTe
         AZws4D8vWN8LuxNI9XGh5E0PQidGTcf1uanapyzxMDRLAeCFj7AKXD5fz3yJG32swPO+
         h6/H0I70eEm5/OkNOOU2GPyzI0dlX453h6IxMvfnVMUjGmlOpGjJdrInm0S5ZAhP7Qlv
         f3xw==
X-Forwarded-Encrypted: i=1; AJvYcCUIc70Dj/Cy28XAI4pc0LCUHXnnDi4KPJHsLrpAt8DanjirA3HvnvjuXoj3rKCUsVSUOC2yV8zMiw==@vger.kernel.org
X-Gm-Message-State: AOJu0YzrW2FSy6idp/6YbYSJfkD4lylB5BiCr3yayOUQKIDDnO+ouO6w
	eDPZQazNjvx2hl2WDjhxaK3GcihBNfGH2SSgLgBYLlDs9MC7Qcq7658a9S8mZaqvN7jUJ7nH/iK
	EZguEwY6hDnHA4XAfyCaLmcHiRDPpfx9hqlDuvDXwGo26mroiBZboa5/bUXY=
X-Google-Smtp-Source: AGHT+IGE0PjZIEcdILk0PkJlW1FXIg8kq6HbFvQSMonQMAm+0CSF6ITQ007rVNw0XtnTNgeNHx/DyPHJvJ5osKh/ID9HXaI158Nu
Precedence: bulk
X-Mailing-List: io-uring@vger.kernel.org
List-Id: <io-uring.vger.kernel.org>
List-Subscribe: <mailto:io-uring+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:io-uring+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-Received: by 2002:a05:6e02:2704:b0:425:744b:52d3 with SMTP id
 e9e14a558f8ab-4330d138f5bmr119543815ab.11.1762047871256; Sat, 01 Nov 2025
 18:44:31 -0700 (PDT)
Date: Sat, 01 Nov 2025 18:44:31 -0700
X-Google-Appengine-App-Id: s~syzkaller
X-Google-Appengine-App-Id-Alias: syzkaller
Message-ID: <6906b77f.050a0220.29fc44.0013.GAE@google.com>
Subject: [syzbot] [io-uring?] INFO: task hung in io_uring_alloc_task_context (6)
From: syzbot <syzbot+898dd95c02117562d35a@syzkaller.appspotmail.com>
To: axboe@kernel.dk, io-uring@vger.kernel.org, linux-kernel@vger.kernel.org, 
	syzkaller-bugs@googlegroups.com
Content-Type: text/plain; charset="UTF-8"

Hello,

syzbot found the following issue on:

HEAD commit:    f7d2388eeec2 Add linux-next specific files for 20251028
git tree:       linux-next
console output: https://syzkaller.appspot.com/x/log.txt?x=1389dfe2580000
kernel config:  https://syzkaller.appspot.com/x/.config?x=ecdce5bceba74f
dashboard link: https://syzkaller.appspot.com/bug?extid=898dd95c02117562d35a
compiler:       Debian clang version 20.1.8 (++20250708063551+0c9f909b7976-1~exp1~20250708183702.136), Debian LLD 20.1.8
syz repro:      https://syzkaller.appspot.com/x/repro.syz?x=127dc32f980000

Downloadable assets:
disk image: https://storage.googleapis.com/syzbot-assets/8aa0aaa475d1/disk-f7d2388e.raw.xz
vmlinux: https://storage.googleapis.com/syzbot-assets/fc97cba5a8b0/vmlinux-f7d2388e.xz
kernel image: https://storage.googleapis.com/syzbot-assets/30e4617d837c/bzImage-f7d2388e.xz

IMPORTANT: if you fix the issue, please add the following tag to the commit:
Reported-by: syzbot+898dd95c02117562d35a@syzkaller.appspotmail.com

INFO: task syz.1.28:6418 blocked for more than 143 seconds.
      Not tainted syzkaller #0
"echo 0 > /proc/sys/kernel/hung_task_timeout_secs" disables this message.
task:syz.1.28        state:D stack:28840 pid:6418  tgid:6416  ppid:6314   task_flags:0x400040 flags:0x00080002
Call Trace:
 <TASK>
 context_switch kernel/sched/core.c:5254 [inline]
 __schedule+0x17c4/0x4d60 kernel/sched/core.c:6862
 __schedule_loop kernel/sched/core.c:6944 [inline]
 schedule+0x165/0x360 kernel/sched/core.c:6959
 schedule_preempt_disabled+0x13/0x30 kernel/sched/core.c:7016
 __mutex_lock_common kernel/locking/mutex.c:676 [inline]
 __mutex_lock+0x7e6/0x1350 kernel/locking/mutex.c:760
 io_init_wq_offload io_uring/tctx.c:22 [inline]
 io_uring_alloc_task_context+0xff/0x570 io_uring/tctx.c:85
 __io_uring_add_tctx_node+0x33e/0x4e0 io_uring/tctx.c:111
 __io_uring_add_tctx_node_from_submit+0x91/0x120 io_uring/tctx.c:154
 io_uring_add_tctx_node io_uring/tctx.h:32 [inline]
 __do_sys_io_uring_enter io_uring/io_uring.c:3545 [inline]
 __se_sys_io_uring_enter+0x2553/0x2b80 io_uring/io_uring.c:3489
 do_syscall_x64 arch/x86/entry/syscall_64.c:63 [inline]
 do_syscall_64+0xfa/0xfa0 arch/x86/entry/syscall_64.c:94
 entry_SYSCALL_64_after_hwframe+0x77/0x7f
RIP: 0033:0x7f20eb38efc9
RSP: 002b:00007f20ec22e038 EFLAGS: 00000246 ORIG_RAX: 00000000000001aa
RAX: ffffffffffffffda RBX: 00007f20eb5e6090 RCX: 00007f20eb38efc9
RDX: 0000000000000000 RSI: 0000000000003516 RDI: 0000000000000003
RBP: 00007f20eb411f91 R08: 0000000000000000 R09: 0000000000000000
R10: 0000000000000000 R11: 0000000000000246 R12: 0000000000000000
R13: 00007f20eb5e6128 R14: 00007f20eb5e6090 R15: 00007ffdbed8bb08
 </TASK>

Showing all locks held in the system:
3 locks held by kworker/u8:1/13:
 #0: ffff8880b873a018 (&rq->__lock){-.-.}-{2:2}, at: raw_spin_rq_lock_nested+0x2a/0x140 kernel/sched/core.c:638
 #1: ffff8880b8724048 (psi_seq){-.-.}-{0:0}, at: psi_task_switch+0x53/0x880 kernel/sched/psi.c:933
 #2: ffff8880b87401d8 (&pcp->lock){+.+.}-{3:3}, at: spin_trylock include/linux/spinlock.h:361 [inline]
 #2: ffff8880b87401d8 (&pcp->lock){+.+.}-{3:3}, at: __free_frozen_pages+0x65e/0xd30 mm/page_alloc.c:2973
1 lock held by khungtaskd/31:
 #0: ffffffff8df3d620 (rcu_read_lock){....}-{1:3}, at: rcu_lock_acquire include/linux/rcupdate.h:331 [inline]
 #0: ffffffff8df3d620 (rcu_read_lock){....}-{1:3}, at: rcu_read_lock include/linux/rcupdate.h:867 [inline]
 #0: ffffffff8df3d620 (rcu_read_lock){....}-{1:3}, at: debug_show_all_locks+0x2e/0x180 kernel/locking/lockdep.c:6775
2 locks held by kworker/u8:2/36:
4 locks held by kworker/u8:4/78:
3 locks held by kworker/u8:6/3509:
 #0: ffff88813fe69948 ((wq_completion)events_unbound#2){+.+.}-{0:0}, at: process_one_work kernel/workqueue.c:3238 [inline]
 #0: ffff88813fe69948 ((wq_completion)events_unbound#2){+.+.}-{0:0}, at: process_scheduled_works+0x9b4/0x17b0 kernel/workqueue.c:3346
 #1: ffffc9000b9d7ba0 ((linkwatch_work).work){+.+.}-{0:0}, at: process_one_work kernel/workqueue.c:3239 [inline]
 #1: ffffc9000b9d7ba0 ((linkwatch_work).work){+.+.}-{0:0}, at: process_scheduled_works+0x9ef/0x17b0 kernel/workqueue.c:3346
 #2: ffffffff8f2d3ac8 (rtnl_mutex){+.+.}-{4:4}, at: linkwatch_event+0xe/0x60 net/core/link_watch.c:303
2 locks held by getty/5585:
 #0: ffff8880350fd0a0 (&tty->ldisc_sem){++++}-{0:0}, at: tty_ldisc_ref_wait+0x25/0x70 drivers/tty/tty_ldisc.c:243
 #1: ffffc9000332e2f0 (&ldata->atomic_read_lock){+.+.}-{4:4}, at: n_tty_read+0x43e/0x1400 drivers/tty/n_tty.c:2222
7 locks held by kworker/u9:3/5945:
 #0: ffff888055c9f948 ((wq_completion)hci19){+.+.}-{0:0}, at: process_one_work kernel/workqueue.c:3238 [inline]
 #0: ffff888055c9f948 ((wq_completion)hci19){+.+.}-{0:0}, at: process_scheduled_works+0x9b4/0x17b0 kernel/workqueue.c:3346
 #1: ffffc90003a7fba0 ((work_completion)(&hdev->cmd_sync_work)){+.+.}-{0:0}, at: process_one_work kernel/workqueue.c:3239 [inline]
 #1: ffffc90003a7fba0 ((work_completion)(&hdev->cmd_sync_work)){+.+.}-{0:0}, at: process_scheduled_works+0x9ef/0x17b0 kernel/workqueue.c:3346
 #2: ffff88805a750dc8 (&hdev->req_lock){+.+.}-{4:4}, at: hci_cmd_sync_work+0x1d3/0x400 net/bluetooth/hci_sync.c:331
 #3: ffff88805a7500b8 (&hdev->lock){+.+.}-{4:4}, at: hci_abort_conn_sync+0x242/0xe30 net/bluetooth/hci_sync.c:5691
 #4: ffffffff8f43d2a8 (hci_cb_list_lock){+.+.}-{4:4}, at: hci_connect_cfm include/net/bluetooth/hci_core.h:2118 [inline]
 #4: ffffffff8f43d2a8 (hci_cb_list_lock){+.+.}-{4:4}, at: hci_conn_failed+0x165/0x340 net/bluetooth/hci_conn.c:1331
 #5: ffff888058307338 (&conn->lock#2){+.+.}-{4:4}, at: l2cap_conn_del+0x7b/0x5b0 net/bluetooth/l2cap_core.c:1762
 #6: ffffffff8df430b8 (rcu_state.exp_mutex){+.+.}-{4:4}, at: exp_funnel_lock kernel/rcu/tree_exp.h:343 [inline]
 #6: ffffffff8df430b8 (rcu_state.exp_mutex){+.+.}-{4:4}, at: synchronize_rcu_expedited+0x3b9/0x730 kernel/rcu/tree_exp.h:957
3 locks held by kworker/u8:7/6102:
 #0: ffff88814c4db148 ((wq_completion)ipv6_addrconf){+.+.}-{0:0}, at: process_one_work kernel/workqueue.c:3238 [inline]
 #0: ffff88814c4db148 ((wq_completion)ipv6_addrconf){+.+.}-{0:0}, at: process_scheduled_works+0x9b4/0x17b0 kernel/workqueue.c:3346
 #1: ffffc90003817ba0 ((work_completion)(&(&ifa->dad_work)->work)){+.+.}-{0:0}, at: process_one_work kernel/workqueue.c:3239 [inline]
 #1: ffffc90003817ba0 ((work_completion)(&(&ifa->dad_work)->work)){+.+.}-{0:0}, at: process_scheduled_works+0x9ef/0x17b0 kernel/workqueue.c:3346
 #2: ffffffff8f2d3ac8 (rtnl_mutex){+.+.}-{4:4}, at: rtnl_net_lock include/linux/rtnetlink.h:130 [inline]
 #2: ffffffff8f2d3ac8 (rtnl_mutex){+.+.}-{4:4}, at: addrconf_dad_work+0x112/0x14b0 net/ipv6/addrconf.c:4194
3 locks held by syz.1.18/6134:
3 locks held by syz.2.19/6137:
3 locks held by syz.4.21/6146:
3 locks held by syz.3.20/6151:
3 locks held by syz.0.17/6154:
3 locks held by syz.5.22/6300:
3 locks held by syz.6.23/6302:
3 locks held by syz.8.27/6308:
3 locks held by syz.7.24/6310:
3 locks held by syz.9.26/6312:
3 locks held by syz.1.28/6417:
1 lock held by syz.1.28/6418:
 #0: ffff88805b0cc0a8 (&ctx->uring_lock){+.+.}-{4:4}, at: io_init_wq_offload io_uring/tctx.c:22 [inline]
 #0: ffff88805b0cc0a8 (&ctx->uring_lock){+.+.}-{4:4}, at: io_uring_alloc_task_context+0xff/0x570 io_uring/tctx.c:85
3 locks held by syz.2.33/6433:
3 locks held by syz.3.31/6435:
3 locks held by syz.0.30/6437:
3 locks held by syz.4.32/6439:
3 locks held by kworker/u9:8/6447:
3 locks held by syz.5.34/6560:
3 locks held by syz.6.39/6589:
3 locks held by syz.7.36/6591:
3 locks held by syz.8.37/6593:
3 locks held by syz.9.38/6595:
3 locks held by syz.1.46/6686:
3 locks held by syz.2.41/6720:
1 lock held by syz-executor/6724:
 #0: ffffffff8f2d3ac8 (rtnl_mutex){+.+.}-{4:4}, at: rtnl_net_lock include/linux/rtnetlink.h:130 [inline]
 #0: ffffffff8f2d3ac8 (rtnl_mutex){+.+.}-{4:4}, at: inet6_rtm_newaddr+0x5b7/0xd20 net/ipv6/addrconf.c:5027
3 locks held by syz.3.50/6737:
3 locks held by syz.4.44/6739:
3 locks held by syz.0.43/6743:
3 locks held by syz-executor/6749:
 #0: ffffffff8ea64160 (&ops->srcu#2){.+.+}-{0:0}, at: rcu_lock_acquire include/linux/rcupdate.h:331 [inline]
 #0: ffffffff8ea64160 (&ops->srcu#2){.+.+}-{0:0}, at: rcu_read_lock include/linux/rcupdate.h:867 [inline]
 #0: ffffffff8ea64160 (&ops->srcu#2){.+.+}-{0:0}, at: rtnl_link_ops_get+0x23/0x250 net/core/rtnetlink.c:570
 #1: ffffffff8f2d3ac8 (rtnl_mutex){+.+.}-{4:4}, at: rtnl_lock net/core/rtnetlink.c:80 [inline]
 #1: ffffffff8f2d3ac8 (rtnl_mutex){+.+.}-{4:4}, at: rtnl_nets_lock net/core/rtnetlink.c:341 [inline]
 #1: ffffffff8f2d3ac8 (rtnl_mutex){+.+.}-{4:4}, at: rtnl_newlink+0x8e9/0x1c80 net/core/rtnetlink.c:4064
 #2: ffffffff8df430b8 (rcu_state.exp_mutex){+.+.}-{4:4}, at: exp_funnel_lock kernel/rcu/tree_exp.h:311 [inline]
 #2: ffffffff8df430b8 (rcu_state.exp_mutex){+.+.}-{4:4}, at: synchronize_rcu_expedited+0x2f6/0x730 kernel/rcu/tree_exp.h:957
1 lock held by syz-executor/6764:
 #0: ffffffff8f2d3ac8 (rtnl_mutex){+.+.}-{4:4}, at: rtnl_net_lock include/linux/rtnetlink.h:130 [inline]
 #0: ffffffff8f2d3ac8 (rtnl_mutex){+.+.}-{4:4}, at: inet_rtm_newaddr+0x3b0/0x18b0 net/ipv4/devinet.c:978
1 lock held by syz-executor/6765:
 #0: ffffffff8f2d3ac8 (rtnl_mutex){+.+.}-{4:4}, at: rtnl_net_lock include/linux/rtnetlink.h:130 [inline]
 #0: ffffffff8f2d3ac8 (rtnl_mutex){+.+.}-{4:4}, at: inet_rtm_newaddr+0x3b0/0x18b0 net/ipv4/devinet.c:978

=============================================

NMI backtrace for cpu 1
CPU: 1 UID: 0 PID: 31 Comm: khungtaskd Not tainted syzkaller #0 PREEMPT(full) 
Hardware name: Google Google Compute Engine/Google Compute Engine, BIOS Google 10/02/2025
Call Trace:
 <TASK>
 dump_stack_lvl+0x189/0x250 lib/dump_stack.c:120
 nmi_cpu_backtrace+0x39e/0x3d0 lib/nmi_backtrace.c:113
 nmi_trigger_cpumask_backtrace+0x17a/0x300 lib/nmi_backtrace.c:62
 trigger_all_cpu_backtrace include/linux/nmi.h:160 [inline]
 check_hung_uninterruptible_tasks kernel/hung_task.c:337 [inline]
 watchdog+0xfa9/0xff0 kernel/hung_task.c:500
 kthread+0x711/0x8a0 kernel/kthread.c:463
 ret_from_fork+0x4bc/0x870 arch/x86/kernel/process.c:158
 ret_from_fork_asm+0x1a/0x30 arch/x86/entry/entry_64.S:245
 </TASK>
Sending NMI from CPU 1 to CPUs 0:
NMI backtrace for cpu 0
CPU: 0 UID: 0 PID: 6310 Comm: syz.7.24 Not tainted syzkaller #0 PREEMPT(full) 
Hardware name: Google Google Compute Engine/Google Compute Engine, BIOS Google 10/02/2025
RIP: 0010:memset_orig+0x15/0xb0 arch/x86/lib/memset_64.S:57
Code: 90 90 90 90 90 90 90 90 90 90 90 90 90 90 90 90 90 90 90 90 90 49 89 fa 40 0f b6 ce 48 b8 01 01 01 01 01 01 01 01 48 0f af c1 <41> 89 f9 41 83 e1 07 75 74 48 89 d1 48 c1 e9 06 74 39 66 0f 1f 84
RSP: 0018:ffffc900044ef7f8 EFLAGS: 00000206
RAX: 0000000000000000 RBX: dffffc0000000000 RCX: 0000000000000000
RDX: 0000000000000018 RSI: 0000000000000000 RDI: ffffc900044ef880
RBP: ffffc900044ef920 R08: ffffc900044ef897 R09: 1ffff9200089df12
R10: ffffc900044ef880 R11: fffff5200089df13 R12: ffff888033d99818
R13: ffff888033d99818 R14: ffffc900044ef880 R15: ffff8880796160d0
FS:  00007f56210dc6c0(0000) GS:ffff888125eeb000(0000) knlGS:0000000000000000
CS:  0010 DS: 0000 ES: 0000 CR0: 0000000080050033
CR2: 00007fff44b6e040 CR3: 0000000011b42000 CR4: 00000000003526f0
Call Trace:
 <TASK>
 seq_printf+0xad/0x270 fs/seq_file.c:403
 __io_uring_show_fdinfo io_uring/fdinfo.c:142 [inline]
 io_uring_show_fdinfo+0x734/0x17d0 io_uring/fdinfo.c:256
 seq_show+0x5bc/0x730 fs/proc/fd.c:68
 seq_read_iter+0x4ef/0xe20 fs/seq_file.c:230
 seq_read+0x369/0x480 fs/seq_file.c:162
 vfs_read+0x200/0xa30 fs/read_write.c:570
 ksys_read+0x145/0x250 fs/read_write.c:715
 do_syscall_x64 arch/x86/entry/syscall_64.c:63 [inline]
 do_syscall_64+0xfa/0xfa0 arch/x86/entry/syscall_64.c:94
 entry_SYSCALL_64_after_hwframe+0x77/0x7f
RIP: 0033:0x7f562018efc9
Code: ff ff c3 66 2e 0f 1f 84 00 00 00 00 00 0f 1f 40 00 48 89 f8 48 89 f7 48 89 d6 48 89 ca 4d 89 c2 4d 89 c8 4c 8b 4c 24 08 0f 05 <48> 3d 01 f0 ff ff 73 01 c3 48 c7 c1 a8 ff ff ff f7 d8 64 89 01 48
RSP: 002b:00007f56210dc038 EFLAGS: 00000246 ORIG_RAX: 0000000000000000
RAX: ffffffffffffffda RBX: 00007f56203e5fa0 RCX: 00007f562018efc9
RDX: 0000000000000039 RSI: 00002000000004c0 RDI: 0000000000000004
RBP: 00007f5620211f91 R08: 0000000000000000 R09: 0000000000000000
R10: 0000000000000000 R11: 0000000000000246 R12: 0000000000000000
R13: 00007f56203e6038 R14: 00007f56203e5fa0 R15: 00007ffec5bbc238
 </TASK>


---
This report is generated by a bot. It may contain errors.
See https://goo.gl/tpsmEJ for more information about syzbot.
syzbot engineers can be reached at syzkaller@googlegroups.com.

syzbot will keep track of this issue. See:
https://goo.gl/tpsmEJ#status for how to communicate with syzbot.

If the report is already addressed, let syzbot know by replying with:
#syz fix: exact-commit-title

If you want syzbot to run the reproducer, reply with:
#syz test: git://repo/address.git branch-or-commit-hash
If you attach or paste a git patch, syzbot will apply it before testing.

If you want to overwrite report's subsystems, reply with:
#syz set subsystems: new-subsystem
(See the list of subsystem names on the web dashboard)

If the report is a duplicate of another one, reply with:
#syz dup: exact-subject-of-another-report

If you want to undo deduplication, reply with:
#syz undup

