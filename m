Return-Path: <io-uring+bounces-13503-lists+io-uring=lfdr.de@vger.kernel.org>
Delivered-To: lists+io-uring@lfdr.de
Received: from mail.lfdr.de
	by lfdr with LMTP
	id 0HPsKacKFWpPSQcAu9opvQ
	(envelope-from <io-uring+bounces-13503-lists+io-uring=lfdr.de@vger.kernel.org>)
	for <lists+io-uring@lfdr.de>; Tue, 26 May 2026 04:51:19 +0200
X-Original-To: lists+io-uring@lfdr.de
Received: from sea.lore.kernel.org (sea.lore.kernel.org [IPv6:2600:3c0a:e001:db::12fc:5321])
	by mail.lfdr.de (Postfix) with ESMTPS id 0DDB85D01BA
	for <lists+io-uring@lfdr.de>; Tue, 26 May 2026 04:51:18 +0200 (CEST)
Received: from smtp.subspace.kernel.org (conduit.subspace.kernel.org [100.90.174.1])
	by sea.lore.kernel.org (Postfix) with ESMTP id 7F03F300D470
	for <lists+io-uring@lfdr.de>; Tue, 26 May 2026 02:49:28 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id BF5042F3C0E;
	Tue, 26 May 2026 02:49:27 +0000 (UTC)
X-Original-To: io-uring@vger.kernel.org
Received: from mail-ot1-f77.google.com (mail-ot1-f77.google.com [209.85.210.77])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B300D284B25
	for <io-uring@vger.kernel.org>; Tue, 26 May 2026 02:49:24 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.210.77
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1779763767; cv=none; b=jy4qdmzVCcKisWNG2ELRl7pfZq+wo8xJm9NApvtRd2IWQeMU6z5SFIE4+a8Ikmv++uqK4aWITmhxMFWdW1MlFwlCi+QgvgIRWFXdmt4elNO8ns1XiIfXmQKjjQOWHVWLkOMpD36SlLuWiQpmOWJaRkNUHCyh3+EGfIIrD0HS+Zw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1779763767; c=relaxed/simple;
	bh=dXm0tosg5crGOhhVxldTsBnJf3winDZzNhPZARMk+JU=;
	h=MIME-Version:Date:Message-ID:Subject:From:To:Content-Type; b=AUia6yHXiA1oeIxkN6Qvd6WNdceRdjirdhe8eT4nhuQk9Sr3G2JqWtyN+Rw8/r3mHvefh8SDXs6PIrtLgxDm/7/8udHoyTBbYZ7JBIHMTV58yIX8E/VMfBrz6W2NEfsXksa6t4E7cTHSxKNCHXiC6mY/tTCYEFmTN+pfX4cGZ1w=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=fail (p=none dis=none) header.from=syzkaller.appspotmail.com; spf=pass smtp.mailfrom=M3KW2WVRGUFZ5GODRSRYTGD7.apphosting.bounces.google.com; arc=none smtp.client-ip=209.85.210.77
Authentication-Results: smtp.subspace.kernel.org; dmarc=fail (p=none dis=none) header.from=syzkaller.appspotmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=M3KW2WVRGUFZ5GODRSRYTGD7.apphosting.bounces.google.com
Received: by mail-ot1-f77.google.com with SMTP id 46e09a7af769-7e56d2d6b9dso2434558a34.0
        for <io-uring@vger.kernel.org>; Mon, 25 May 2026 19:49:24 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1779763763; x=1780368563;
        h=to:from:subject:message-id:date:mime-version:x-gm-message-state
         :from:to:cc:subject:date:message-id:reply-to;
        bh=/1P94WsRDxUyQV7p6kTNCwHF2mDoqcRH4+KnTH4eF+0=;
        b=Mlp824+oQhZREI0KPN9QHawLKcq4295J/+sK0rDugG5AwChvt2aK251q4Dd0kd2Uig
         +2b/bFAIEJOU3+2tWPLYeXFfdnCkG21gI6ELWN04iGZfACk7D+u6GIArVuHvdbpDWtAW
         h4vb6tumIt1NYMbvI8D9/Mc/9C1KVa8JRYsnYQe3oavvIAyCWRtN1atbBfI43gGawFiR
         WT1jRhAoHOotmfQVt5F6dqkix7y763ctYGVXESwFHhVaC81WTFw29574QxSnHQH/DG2n
         Fc09eQTzL63AIL3UnI6LZDOtA5qqZOsGxymi+49eII2Jry27N5vdGZPa0jQQQx9YuDxG
         Gxag==
X-Forwarded-Encrypted: i=1; AFNElJ/b7GdgfOhOL46ZbwFSmBoPfG4/kGbsD4/RJDrbPNl/d40hMqr/87tXA1O5bMUidHDQGabnoSfqXg==@vger.kernel.org
X-Gm-Message-State: AOJu0YwV2a/7aqDp9bZqn9peqIDAngugQV9B7UaATkSh/zs+Czc3/d5k
	Xbi1m5jP+r7GgtekPtZeWHXyCdhut9TMfy6oTbBsZ3OJ49gF0h7Vf4GxzrHNkpHfRqeaxIRb8hD
	IRwy58Cifzrab2bGD9Vz4AjDcUIoOU3J1FCXne49b/jvwOmBo8PTYgUh4K4s=
Precedence: bulk
X-Mailing-List: io-uring@vger.kernel.org
List-Id: <io-uring.vger.kernel.org>
List-Subscribe: <mailto:io-uring+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:io-uring+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-Received: by 2002:a05:6820:1c8c:b0:69d:a652:2169 with SMTP id
 006d021491bc7-69da65224bbmr4775409eaf.55.1779763763624; Mon, 25 May 2026
 19:49:23 -0700 (PDT)
Date: Mon, 25 May 2026 19:49:23 -0700
X-Google-Appengine-App-Id: s~syzkaller
X-Google-Appengine-App-Id-Alias: syzkaller
Message-ID: <6a150a33.2b0a0220.185dbd.0006.GAE@google.com>
Subject: [syzbot] [io-uring?] INFO: task hung in io_sq_thread_park (4)
From: syzbot <syzbot+4be91bcb08eab9a156da@syzkaller.appspotmail.com>
To: axboe@kernel.dk, io-uring@vger.kernel.org, linux-kernel@vger.kernel.org, 
	syzkaller-bugs@googlegroups.com
Content-Type: text/plain; charset="UTF-8"
X-Spamd-Result: default: False [-0.36 / 15.00];
	ARC_ALLOW(-1.00)[subspace.kernel.org:s=arc-20240116:i=1];
	URI_HIDDEN_PATH(1.00)[https://syzkaller.appspot.com/x/.config?x=8d24a1331e060dda];
	R_SPF_ALLOW(-0.20)[+ip6:2600:3c0a:e001:db::/64:c];
	MAILLIST(-0.15)[generic];
	MIME_GOOD(-0.10)[text/plain];
	DMARC_POLICY_SOFTFAIL(0.10)[appspotmail.com : SPF not aligned (relaxed), No valid DKIM,none];
	HAS_LIST_UNSUB(-0.01)[];
	RCVD_TLS_LAST(0.00)[];
	RCPT_COUNT_THREE(0.00)[4];
	MISSING_XM_UA(0.00)[];
	FORGED_RECIPIENTS_MAILLIST(0.00)[];
	FORGED_SENDER_MAILLIST(0.00)[];
	RCVD_COUNT_THREE(0.00)[4];
	TAGGED_FROM(0.00)[bounces-13503-lists,io-uring=lfdr.de,4be91bcb08eab9a156da];
	ASN(0.00)[asn:63949, ipnet:2600:3c0a::/32, country:SG];
	SUBJECT_HAS_QUESTION(0.00)[];
	REDIRECTOR_URL(0.00)[goo.gl];
	PRECEDENCE_BULK(0.00)[];
	FROM_NEQ_ENVFROM(0.00)[syzbot@syzkaller.appspotmail.com,io-uring@vger.kernel.org];
	FROM_HAS_DN(0.00)[];
	MIME_TRACE(0.00)[0:+];
	TO_DN_NONE(0.00)[];
	R_DKIM_NA(0.00)[];
	NEURAL_HAM(-0.00)[-0.999];
	TAGGED_RCPT(0.00)[io-uring];
	DBL_BLOCKED_OPENRESOLVER(0.00)[googlegroups.com:email,sea.lore.kernel.org:rdns,sea.lore.kernel.org:helo,syzkaller.appspot.com:url,storage.googleapis.com:url,appspotmail.com:email,goo.gl:url]
X-Rspamd-Queue-Id: 0DDB85D01BA
X-Rspamd-Action: no action
X-Rspamd-Server: lfdr

Hello,

syzbot found the following issue on:

HEAD commit:    45255ea1ca09 Merge tag 'pm-7.1-rc5' of git://git.kernel.or..
git tree:       upstream
console output: https://syzkaller.appspot.com/x/log.txt?x=12030d36580000
kernel config:  https://syzkaller.appspot.com/x/.config?x=8d24a1331e060dda
dashboard link: https://syzkaller.appspot.com/bug?extid=4be91bcb08eab9a156da
compiler:       Debian clang version 21.1.8 (++20251221033036+2078da43e25a-1~exp1~20251221153213.50), Debian LLD 21.1.8
syz repro:      https://syzkaller.appspot.com/x/repro.syz?x=17c2db96580000

Downloadable assets:
disk image: https://storage.googleapis.com/syzbot-assets/55e9065ee7f2/disk-45255ea1.raw.xz
vmlinux: https://storage.googleapis.com/syzbot-assets/f53a442e25dd/vmlinux-45255ea1.xz
kernel image: https://storage.googleapis.com/syzbot-assets/ab16a4623640/bzImage-45255ea1.xz

IMPORTANT: if you fix the issue, please add the following tag to the commit:
Reported-by: syzbot+4be91bcb08eab9a156da@syzkaller.appspotmail.com

INFO: task kworker/u8:2:36 blocked for more than 143 seconds.
      Not tainted syzkaller #0
"echo 0 > /proc/sys/kernel/hung_task_timeout_secs" disables this message.
task:kworker/u8:2    state:D stack:22696 pid:36    tgid:36    ppid:2      task_flags:0x4208060 flags:0x00080000
Workqueue: iou_exit io_ring_exit_work
Call Trace:
 <TASK>
 context_switch kernel/sched/core.c:5388 [inline]
 __schedule+0x1821/0x5740 kernel/sched/core.c:7189
 __schedule_loop kernel/sched/core.c:7268 [inline]
 schedule+0x164/0x360 kernel/sched/core.c:7283
 schedule_preempt_disabled+0x13/0x30 kernel/sched/core.c:7340
 __mutex_lock_common kernel/locking/mutex.c:726 [inline]
 __mutex_lock+0x7f7/0x1550 kernel/locking/mutex.c:820
 io_sq_thread_park+0x44/0x140 io_uring/sqpoll.c:56
 io_ring_exit_work+0x2dd/0x980 io_uring/io_uring.c:2359
 process_one_work kernel/workqueue.c:3314 [inline]
 process_scheduled_works+0xb5d/0x1860 kernel/workqueue.c:3397
 worker_thread+0xa53/0xfc0 kernel/workqueue.c:3478
 kthread+0x389/0x470 kernel/kthread.c:436
 ret_from_fork+0x514/0xb70 arch/x86/kernel/process.c:158
 ret_from_fork_asm+0x1a/0x30 arch/x86/entry/entry_64.S:245
 </TASK>
INFO: task kworker/u8:5:139 blocked for more than 145 seconds.
      Not tainted syzkaller #0
"echo 0 > /proc/sys/kernel/hung_task_timeout_secs" disables this message.
task:kworker/u8:5    state:D stack:24120 pid:139   tgid:139   ppid:2      task_flags:0x4208060 flags:0x00080000
Workqueue: iou_exit io_ring_exit_work
Call Trace:
 <TASK>
 context_switch kernel/sched/core.c:5388 [inline]
 __schedule+0x1821/0x5740 kernel/sched/core.c:7189
 __schedule_loop kernel/sched/core.c:7268 [inline]
 schedule+0x164/0x360 kernel/sched/core.c:7283
 schedule_preempt_disabled+0x13/0x30 kernel/sched/core.c:7340
 __mutex_lock_common kernel/locking/mutex.c:726 [inline]
 __mutex_lock+0x7f7/0x1550 kernel/locking/mutex.c:820
 io_sq_thread_park+0x44/0x140 io_uring/sqpoll.c:56
 io_ring_exit_work+0x2dd/0x980 io_uring/io_uring.c:2359
 process_one_work kernel/workqueue.c:3314 [inline]
 process_scheduled_works+0xb5d/0x1860 kernel/workqueue.c:3397
 worker_thread+0xa53/0xfc0 kernel/workqueue.c:3478
 kthread+0x389/0x470 kernel/kthread.c:436
 ret_from_fork+0x514/0xb70 arch/x86/kernel/process.c:158
 ret_from_fork_asm+0x1a/0x30 arch/x86/entry/entry_64.S:245
 </TASK>
INFO: task kworker/u8:9:5810 blocked for more than 146 seconds.
      Not tainted syzkaller #0
"echo 0 > /proc/sys/kernel/hung_task_timeout_secs" disables this message.
task:kworker/u8:9    state:D stack:24248 pid:5810  tgid:5810  ppid:2      task_flags:0x4208060 flags:0x00080000
Workqueue: iou_exit io_ring_exit_work
Call Trace:
 <TASK>
 context_switch kernel/sched/core.c:5388 [inline]
 __schedule+0x1821/0x5740 kernel/sched/core.c:7189
 __schedule_loop kernel/sched/core.c:7268 [inline]
 schedule+0x164/0x360 kernel/sched/core.c:7283
 schedule_preempt_disabled+0x13/0x30 kernel/sched/core.c:7340
 __mutex_lock_common kernel/locking/mutex.c:726 [inline]
 __mutex_lock+0x7f7/0x1550 kernel/locking/mutex.c:820
 io_sq_thread_park+0x44/0x140 io_uring/sqpoll.c:56
 io_ring_exit_work+0x2dd/0x980 io_uring/io_uring.c:2359
 process_one_work kernel/workqueue.c:3314 [inline]
 process_scheduled_works+0xb5d/0x1860 kernel/workqueue.c:3397
 worker_thread+0xa53/0xfc0 kernel/workqueue.c:3478
 kthread+0x389/0x470 kernel/kthread.c:436
 ret_from_fork+0x514/0xb70 arch/x86/kernel/process.c:158
 ret_from_fork_asm+0x1a/0x30 arch/x86/entry/entry_64.S:245
 </TASK>

Showing all locks held in the system:
3 locks held by kworker/0:0/9:
 #0: ffff88813fe43140 ((wq_completion)events){+.+.}-{0:0}, at: process_one_work kernel/workqueue.c:3289 [inline]
 #0: ffff88813fe43140 ((wq_completion)events){+.+.}-{0:0}, at: process_scheduled_works+0xa35/0x1860 kernel/workqueue.c:3397
 #1: ffffc900000e7c40 (rx_mode_work){+.+.}-{0:0}, at: process_one_work kernel/workqueue.c:3290 [inline]
 #1: ffffc900000e7c40 (rx_mode_work){+.+.}-{0:0}, at: process_scheduled_works+0xa70/0x1860 kernel/workqueue.c:3397
 #2: ffffffff8fdd1400 (rtnl_mutex){+.+.}-{4:4}, at: netdev_rx_mode_work+0x19/0x3c0 net/core/dev_addr_lists.c:1312
3 locks held by kworker/u8:1/13:
 #0: ffff88801af44940 ((wq_completion)iou_exit){+.+.}-{0:0}, at: process_one_work kernel/workqueue.c:3289 [inline]
 #0: ffff88801af44940 ((wq_completion)iou_exit){+.+.}-{0:0}, at: process_scheduled_works+0xa35/0x1860 kernel/workqueue.c:3397
 #1: ffffc90000127c40 ((work_completion)(&ctx->exit_work)){+.+.}-{0:0}, at: process_one_work kernel/workqueue.c:3290 [inline]
 #1: ffffc90000127c40 ((work_completion)(&ctx->exit_work)){+.+.}-{0:0}, at: process_scheduled_works+0xa70/0x1860 kernel/workqueue.c:3397
 #2: ffff88802856dc68 (&sqd->lock){+.+.}-{4:4}, at: io_sq_thread_park+0x44/0x140 io_uring/sqpoll.c:56
1 lock held by khungtaskd/31:
 #0: ffffffff8e95cca0 (rcu_read_lock){....}-{1:3}, at: rcu_lock_acquire include/linux/rcupdate.h:300 [inline]
 #0: ffffffff8e95cca0 (rcu_read_lock){....}-{1:3}, at: rcu_read_lock include/linux/rcupdate.h:838 [inline]
 #0: ffffffff8e95cca0 (rcu_read_lock){....}-{1:3}, at: debug_show_all_locks+0x2e/0x180 kernel/locking/lockdep.c:6775
3 locks held by kworker/u8:2/36:
 #0: ffff88801af44940 ((wq_completion)iou_exit){+.+.}-{0:0}, at: process_one_work kernel/workqueue.c:3289 [inline]
 #0: ffff88801af44940 ((wq_completion)iou_exit){+.+.}-{0:0}, at: process_scheduled_works+0xa35/0x1860 kernel/workqueue.c:3397
 #1: ffffc90000ac7c40 ((work_completion)(&ctx->exit_work)){+.+.}-{0:0}, at: process_one_work kernel/workqueue.c:3290 [inline]
 #1: ffffc90000ac7c40 ((work_completion)(&ctx->exit_work)){+.+.}-{0:0}, at: process_scheduled_works+0xa70/0x1860 kernel/workqueue.c:3397
 #2: ffff888024d77468 (&sqd->lock){+.+.}-{4:4}, at: io_sq_thread_park+0x44/0x140 io_uring/sqpoll.c:56
3 locks held by kworker/u8:3/47:
 #0: ffff88801af44940 ((wq_completion)iou_exit){+.+.}-{0:0}, at: process_one_work kernel/workqueue.c:3289 [inline]
 #0: ffff88801af44940 ((wq_completion)iou_exit){+.+.}-{0:0}, at: process_scheduled_works+0xa35/0x1860 kernel/workqueue.c:3397
 #1: ffffc90000b77c40 ((work_completion)(&ctx->exit_work)){+.+.}-{0:0}, at: process_one_work kernel/workqueue.c:3290 [inline]
 #1: ffffc90000b77c40 ((work_completion)(&ctx->exit_work)){+.+.}-{0:0}, at: process_scheduled_works+0xa70/0x1860 kernel/workqueue.c:3397
 #2: ffff888033183068 (&sqd->lock){+.+.}-{4:4}, at: io_sq_thread_park+0x44/0x140 io_uring/sqpoll.c:56
3 locks held by kworker/u9:0/50:
 #0: ffff888060790940 ((wq_completion)hci11){+.+.}-{0:0}, at: process_one_work kernel/workqueue.c:3289 [inline]
 #0: ffff888060790940 ((wq_completion)hci11){+.+.}-{0:0}, at: process_scheduled_works+0xa35/0x1860 kernel/workqueue.c:3397
 #1: ffffc90000ba7c40 ((work_completion)(&hdev->cmd_sync_work)){+.+.}-{0:0}, at: process_one_work kernel/workqueue.c:3290 [inline]
 #1: ffffc90000ba7c40 ((work_completion)(&hdev->cmd_sync_work)){+.+.}-{0:0}, at: process_scheduled_works+0xa70/0x1860 kernel/workqueue.c:3397
 #2: ffff88807ff38ea0 (&hdev->req_lock){+.+.}-{4:4}, at: hci_cmd_sync_work+0x1d3/0x400 net/bluetooth/hci_sync.c:331
3 locks held by kworker/u8:4/58:
 #0: ffff88801af44940 ((wq_completion)iou_exit){+.+.}-{0:0}, at: process_one_work kernel/workqueue.c:3289 [inline]
 #0: ffff88801af44940 ((wq_completion)iou_exit){+.+.}-{0:0}, at: process_scheduled_works+0xa35/0x1860 kernel/workqueue.c:3397
 #1: ffffc900015f7c40 ((work_completion)(&ctx->exit_work)){+.+.}-{0:0}, at: process_one_work kernel/workqueue.c:3290 [inline]
 #1: ffffc900015f7c40 ((work_completion)(&ctx->exit_work)){+.+.}-{0:0}, at: process_scheduled_works+0xa70/0x1860 kernel/workqueue.c:3397
 #2: ffff88802902ec68 (&sqd->lock){+.+.}-{4:4}, at: io_sq_thread_park+0x44/0x140 io_uring/sqpoll.c:56
3 locks held by kworker/u8:5/139:
 #0: ffff88801af44940 ((wq_completion)iou_exit){+.+.}-{0:0}, at: process_one_work kernel/workqueue.c:3289 [inline]
 #0: ffff88801af44940 ((wq_completion)iou_exit){+.+.}-{0:0}, at: process_scheduled_works+0xa35/0x1860 kernel/workqueue.c:3397
 #1: ffffc90002e17c40 ((work_completion)(&ctx->exit_work)){+.+.}-{0:0}, at: process_one_work kernel/workqueue.c:3290 [inline]
 #1: ffffc90002e17c40 ((work_completion)(&ctx->exit_work)){+.+.}-{0:0}, at: process_scheduled_works+0xa70/0x1860 kernel/workqueue.c:3397
 #2: ffff88807d43c068 (&sqd->lock){+.+.}-{4:4}, at: io_sq_thread_park+0x44/0x140 io_uring/sqpoll.c:56
3 locks held by kworker/u8:7/1145:
 #0: ffff88801af44940 ((wq_completion)iou_exit){+.+.}-{0:0}, at: process_one_work kernel/workqueue.c:3289 [inline]
 #0: ffff88801af44940 ((wq_completion)iou_exit){+.+.}-{0:0}, at: process_scheduled_works+0xa35/0x1860 kernel/workqueue.c:3397
 #1: ffffc900053efc40 ((work_completion)(&ctx->exit_work)){+.+.}-{0:0}, at: process_one_work kernel/workqueue.c:3290 [inline]
 #1: ffffc900053efc40 ((work_completion)(&ctx->exit_work)){+.+.}-{0:0}, at: process_scheduled_works+0xa70/0x1860 kernel/workqueue.c:3397
 #2: ffff88807b88f068 (&sqd->lock){+.+.}-{4:4}, at: io_sq_thread_park+0x44/0x140 io_uring/sqpoll.c:56
3 locks held by kworker/u8:8/3333:
 #0: ffff88801af44940 ((wq_completion)iou_exit){+.+.}-{0:0}, at: process_one_work kernel/workqueue.c:3289 [inline]
 #0: ffff88801af44940 ((wq_completion)iou_exit){+.+.}-{0:0}, at: process_scheduled_works+0xa35/0x1860 kernel/workqueue.c:3397
 #1: ffffc9000e61fc40 ((work_completion)(&ctx->exit_work)){+.+.}-{0:0}, at: process_one_work kernel/workqueue.c:3290 [inline]
 #1: ffffc9000e61fc40 ((work_completion)(&ctx->exit_work)){+.+.}-{0:0}, at: process_scheduled_works+0xa70/0x1860 kernel/workqueue.c:3397
 #2: ffff8880578a1468 (&sqd->lock){+.+.}-{4:4}, at: io_sq_thread_park+0x44/0x140 io_uring/sqpoll.c:56
1 lock held by udevd/4987:
 #0: ffff8880b863aea0 (&rq->__lock){-.-.}-{2:2}, at: raw_spin_rq_lock_nested+0x31/0x150 kernel/sched/core.c:652
2 locks held by getty/5374:
 #0: ffff8880362670a0 (&tty->ldisc_sem){++++}-{0:0}, at: tty_ldisc_ref_wait+0x25/0x70 drivers/tty/tty_ldisc.c:243
 #1: ffffc9000322b2e8 (&ldata->atomic_read_lock){+.+.}-{4:4}, at: n_tty_read+0x45c/0x13a0 drivers/tty/n_tty.c:2211
3 locks held by kworker/u8:9/5810:
 #0: ffff88801af44940 ((wq_completion)iou_exit){+.+.}-{0:0}, at: process_one_work kernel/workqueue.c:3289 [inline]
 #0: ffff88801af44940 ((wq_completion)iou_exit){+.+.}-{0:0}, at: process_scheduled_works+0xa35/0x1860 kernel/workqueue.c:3397
 #1: ffffc900038c7c40 ((work_completion)(&ctx->exit_work)){+.+.}-{0:0}, at: process_one_work kernel/workqueue.c:3290 [inline]
 #1: ffffc900038c7c40 ((work_completion)(&ctx->exit_work)){+.+.}-{0:0}, at: process_scheduled_works+0xa70/0x1860 kernel/workqueue.c:3397
 #2: ffff888075ffdc68 (&sqd->lock){+.+.}-{4:4}, at: io_sq_thread_park+0x44/0x140 io_uring/sqpoll.c:56
2 locks held by kworker/u8:10/5820:
 #0: ffff88801af44940 ((wq_completion)iou_exit){+.+.}-{0:0}, at: process_one_work kernel/workqueue.c:3289 [inline]
 #0: ffff88801af44940 ((wq_completion)iou_exit){+.+.}-{0:0}, at: process_scheduled_works+0xa35/0x1860 kernel/workqueue.c:3397
 #1: ffffc900038e7c40 ((work_completion)(&ctx->exit_work)){+.+.}-{0:0}, at: process_one_work kernel/workqueue.c:3290 [inline]
 #1: ffffc900038e7c40 ((work_completion)(&ctx->exit_work)){+.+.}-{0:0}, at: process_scheduled_works+0xa70/0x1860 kernel/workqueue.c:3397
2 locks held by iou-sqp-6349/6354:
1 lock held by iou-sqp-7229/7232:
2 locks held by iou-sqp-7262/7266:
1 lock held by iou-sqp-7452/7455:
2 locks held by iou-sqp-7518/7521:
2 locks held by kworker/u8:11/7547:
 #0: ffff88801af44940 ((wq_completion)iou_exit){+.+.}-{0:0}, at: process_one_work kernel/workqueue.c:3289 [inline]
 #0: ffff88801af44940 ((wq_completion)iou_exit){+.+.}-{0:0}, at: process_scheduled_works+0xa35/0x1860 kernel/workqueue.c:3397
 #1: ffffc90003f87c40 ((work_completion)(&ctx->exit_work)){+.+.}-{0:0}, at: process_one_work kernel/workqueue.c:3290 [inline]
 #1: ffffc90003f87c40 ((work_completion)(&ctx->exit_work)){+.+.}-{0:0}, at: process_scheduled_works+0xa70/0x1860 kernel/workqueue.c:3397
2 locks held by iou-sqp-7648/7649:
2 locks held by kworker/u8:12/7655:
 #0: ffff88801af44940 ((wq_completion)iou_exit){+.+.}-{0:0}, at: process_one_work kernel/workqueue.c:3289 [inline]
 #0: ffff88801af44940 ((wq_completion)iou_exit){+.+.}-{0:0}, at: process_scheduled_works+0xa35/0x1860 kernel/workqueue.c:3397
 #1: ffffc90003b1fc40 ((work_completion)(&ctx->exit_work)){+.+.}-{0:0}, at: process_one_work kernel/workqueue.c:3290 [inline]
 #1: ffffc90003b1fc40 ((work_completion)(&ctx->exit_work)){+.+.}-{0:0}, at: process_scheduled_works+0xa70/0x1860 kernel/workqueue.c:3397
1 lock held by syz-executor/7715:
3 locks held by kworker/u8:13/7719:
 #0: ffff88801af44940 ((wq_completion)iou_exit){+.+.}-{0:0}, at: process_one_work kernel/workqueue.c:3289 [inline]
 #0: ffff88801af44940 ((wq_completion)iou_exit){+.+.}-{0:0}, at: process_scheduled_works+0xa35/0x1860 kernel/workqueue.c:3397
 #1: ffffc9000206fc40 ((work_completion)(&ctx->exit_work)){+.+.}-{0:0}, at: process_one_work kernel/workqueue.c:3290 [inline]
 #1: ffffc9000206fc40 ((work_completion)(&ctx->exit_work)){+.+.}-{0:0}, at: process_scheduled_works+0xa70/0x1860 kernel/workqueue.c:3397
 #2: ffff888057817068 (&sqd->lock){+.+.}-{4:4}, at: io_sq_thread_park+0x44/0x140 io_uring/sqpoll.c:56


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

