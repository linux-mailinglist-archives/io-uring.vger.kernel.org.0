Return-Path: <io-uring+bounces-12428-lists+io-uring=lfdr.de@vger.kernel.org>
Delivered-To: lists+io-uring@lfdr.de
Received: from mail.lfdr.de
	by lfdr with LMTP
	id 8Du8Etbnn2lLewQAu9opvQ
	(envelope-from <io-uring+bounces-12428-lists+io-uring=lfdr.de@vger.kernel.org>)
	for <lists+io-uring@lfdr.de>; Thu, 26 Feb 2026 07:27:34 +0100
X-Original-To: lists+io-uring@lfdr.de
Received: from sin.lore.kernel.org (sin.lore.kernel.org [IPv6:2600:3c15:e001:75::12fc:5321])
	by mail.lfdr.de (Postfix) with ESMTPS id 5D7B21A14F3
	for <lists+io-uring@lfdr.de>; Thu, 26 Feb 2026 07:27:33 +0100 (CET)
Received: from smtp.subspace.kernel.org (conduit.subspace.kernel.org [100.90.174.1])
	by sin.lore.kernel.org (Postfix) with ESMTP id BE578301492B
	for <lists+io-uring@lfdr.de>; Thu, 26 Feb 2026 06:27:30 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id D23FC38B7BD;
	Thu, 26 Feb 2026 06:27:26 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=sina.cn header.i=@sina.cn header.b="q8YWIllZ"
X-Original-To: io-uring@vger.kernel.org
Received: from mail115-76.sinamail.sina.com.cn (mail115-76.sinamail.sina.com.cn [218.30.115.76])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5DDF838B7A8
	for <io-uring@vger.kernel.org>; Thu, 26 Feb 2026 06:27:24 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=218.30.115.76
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1772087246; cv=none; b=ngg18pcQQ8vJsTALT+v7UIuHEt3vTNbC5M4NJBCbczG+VAIbFFh3/p/We4m2mKA5GNVS8QffxfoztOrJuG6Mx4fZl54nijH33t4PRk1qRmKV6JSHstZM2dBGNVx8MVTX0sGCvsEQXrBJ7wSzZO1m9iINXEs6XNDXMZX31uEJ86I=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1772087246; c=relaxed/simple;
	bh=yoBeoacMbK1NAn82kU0drfaAQYOiincR4WZfeQfH/ZE=;
	h=From:To:Cc:Subject:Date:Message-Id:MIME-Version; b=YYnNQUKfn4Vc+l3fumGxpJ9zrd870hcVzmAgpeYJIH6sKHDpUnJJ2TE+cwrG6rofiVkOeTCr6IsD90oO/lwDH0NBiTUHC/1AlRCzXj13UTdWOFw4zHl1w/kPyJStH0wmzs3bbJHxZ6xZ2hUeMEqOm7XugRPdt8cTb7dTLrU9STg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=sina.cn; spf=pass smtp.mailfrom=sina.cn; dkim=pass (1024-bit key) header.d=sina.cn header.i=@sina.cn header.b=q8YWIllZ; arc=none smtp.client-ip=218.30.115.76
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=sina.cn
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=sina.cn
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=sina.cn; s=201208; t=1772087244;
	bh=+ll0j7P6gB1YHU/QPLWIwnmbPeyItOm5mPcLbuIqgOg=;
	h=From:Subject:Date:Message-Id;
	b=q8YWIllZwKhvfX8MDR87Fblnq7RqSFOTUxscAow1vpnDlt6GKhpo4A8HowlIqsbqe
	 B743+PNRHzvc6mxbcxKINlA7GbMK7T0ZJNMe/K+z2u+SgZBCV/YPyQT980jYWrVPsn
	 jCl653qLgBB4JfYg7GnEYLmuBJooKfU/ji3ln/Jk=
X-SMAIL-HELO: NTT-kernel-dev
Received: from unknown (HELO NTT-kernel-dev)([60.247.85.88])
	by sina.cn (10.185.250.22) with ESMTP
	id 699FE7C00000554F; Thu, 26 Feb 2026 14:27:20 +0800 (CST)
X-Sender: jianqkang@sina.cn
X-Auth-ID: jianqkang@sina.cn
Authentication-Results: sina.cn;
	 spf=none smtp.mailfrom=jianqkang@sina.cn;
	 dkim=none header.i=none;
	 dmarc=none action=none header.from=jianqkang@sina.cn
X-SMAIL-MID: 5292787602219
X-SMAIL-UIID: 3D228B6872754FE994F61C7BCD9CC217-20260226-142720-1
From: Jianqiang kang <jianqkang@sina.cn>
To: gregkh@linuxfoundation.org,
	stable@vger.kernel.org,
	axboe@kernel.dk
Cc: patches@lists.linux.dev,
	linux-kernel@vger.kernel.org,
	asml.silence@gmail.com,
	io-uring@vger.kernel.org
Subject: [PATCH 5.15.y] io_uring/io-wq: check IO_WQ_BIT_EXIT inside work run loop
Date: Thu, 26 Feb 2026 14:27:11 +0800
Message-Id: <20260226062711.426301-1-jianqkang@sina.cn>
X-Mailer: git-send-email 2.34.1
Precedence: bulk
X-Mailing-List: io-uring@vger.kernel.org
List-Id: <io-uring.vger.kernel.org>
List-Subscribe: <mailto:io-uring+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:io-uring+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspamd-Server: lfdr
X-Spamd-Result: default: False [0.84 / 15.00];
	SUSPICIOUS_RECIPS(1.50)[];
	MID_CONTAINS_FROM(1.00)[];
	ARC_ALLOW(-1.00)[subspace.kernel.org:s=arc-20240116:i=1];
	R_MISSING_CHARSET(0.50)[];
	DMARC_POLICY_ALLOW(-0.50)[sina.cn,none];
	R_DKIM_ALLOW(-0.20)[sina.cn:s=201208];
	R_SPF_ALLOW(-0.20)[+ip6:2600:3c15:e001:75::/64:c];
	MAILLIST(-0.15)[generic];
	MIME_GOOD(-0.10)[text/plain];
	HAS_LIST_UNSUB(-0.01)[];
	RCVD_TLS_LAST(0.00)[];
	FREEMAIL_CC(0.00)[lists.linux.dev,vger.kernel.org,gmail.com];
	TAGGED_FROM(0.00)[bounces-12428-lists,io-uring=lfdr.de];
	MIME_TRACE(0.00)[0:+];
	RCVD_COUNT_THREE(0.00)[4];
	FORGED_SENDER_MAILLIST(0.00)[];
	ASN(0.00)[asn:63949, ipnet:2600:3c15::/32, country:SG];
	FORGED_RECIPIENTS_MAILLIST(0.00)[];
	PRECEDENCE_BULK(0.00)[];
	FROM_NEQ_ENVFROM(0.00)[jianqkang@sina.cn,io-uring@vger.kernel.org];
	FROM_HAS_DN(0.00)[];
	DKIM_TRACE(0.00)[sina.cn:+];
	TO_DN_NONE(0.00)[];
	RCPT_COUNT_SEVEN(0.00)[7];
	NEURAL_HAM(-0.00)[-0.992];
	FREEMAIL_FROM(0.00)[sina.cn];
	TAGGED_RCPT(0.00)[io-uring];
	DBL_BLOCKED_OPENRESOLVER(0.00)[sin.lore.kernel.org:helo,sin.lore.kernel.org:rdns,sina.cn:mid,sina.cn:dkim,sina.cn:email,appspotmail.com:email]
X-Rspamd-Queue-Id: 5D7B21A14F3
X-Rspamd-Action: no action

From: Jens Axboe <axboe@kernel.dk>

[ Upstream commit 10dc959398175736e495f71c771f8641e1ca1907 ]

Currently this is checked before running the pending work. Normally this
is quite fine, as work items either end up blocking (which will create a
new worker for other items), or they complete fairly quickly. But syzbot
reports an issue where io-wq takes seemingly forever to exit, and with a
bit of debugging, this turns out to be because it queues a bunch of big
(2GB - 4096b) reads with a /dev/msr* file. Since this file type doesn't
support ->read_iter(), loop_rw_iter() ends up handling them. Each read
returns 16MB of data read, which takes 20 (!!) seconds. With a bunch of
these pending, processing the whole chain can take a long time. Easily
longer than the syzbot uninterruptible sleep timeout of 140 seconds.
This then triggers a complaint off the io-wq exit path:

INFO: task syz.4.135:6326 blocked for more than 143 seconds.
      Not tainted syzkaller #0
      Blocked by coredump.
"echo 0 > /proc/sys/kernel/hung_task_timeout_secs" disables this message.
task:syz.4.135       state:D stack:26824 pid:6326  tgid:6324  ppid:5957   task_flags:0x400548 flags:0x00080000
Call Trace:
 <TASK>
 context_switch kernel/sched/core.c:5256 [inline]
 __schedule+0x1139/0x6150 kernel/sched/core.c:6863
 __schedule_loop kernel/sched/core.c:6945 [inline]
 schedule+0xe7/0x3a0 kernel/sched/core.c:6960
 schedule_timeout+0x257/0x290 kernel/time/sleep_timeout.c:75
 do_wait_for_common kernel/sched/completion.c:100 [inline]
 __wait_for_common+0x2fc/0x4e0 kernel/sched/completion.c:121
 io_wq_exit_workers io_uring/io-wq.c:1328 [inline]
 io_wq_put_and_exit+0x271/0x8a0 io_uring/io-wq.c:1356
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
RIP: 0033:0x7fa02738f749
RSP: 002b:00007fa0281ae0e8 EFLAGS: 00000246 ORIG_RAX: 00000000000000ca
RAX: fffffffffffffe00 RBX: 00007fa0275e6098 RCX: 00007fa02738f749
RDX: 0000000000000000 RSI: 0000000000000080 RDI: 00007fa0275e6098
RBP: 00007fa0275e6090 R08: 0000000000000000 R09: 0000000000000000
R10: 0000000000000000 R11: 0000000000000246 R12: 0000000000000000
R13: 00007fa0275e6128 R14: 00007fff14e4fcb0 R15: 00007fff14e4fd98

There's really nothing wrong here, outside of processing these reads
will take a LONG time. However, we can speed up the exit by checking the
IO_WQ_BIT_EXIT inside the io_worker_handle_work() loop, as syzbot will
exit the ring after queueing up all of these reads. Then once the first
item is processed, io-wq will simply cancel the rest. That should avoid
syzbot running into this complaint again.

Cc: stable@vger.kernel.org
Link: https://lore.kernel.org/all/68a2decc.050a0220.e29e5.0099.GAE@google.com/
Reported-by: syzbot+4eb282331cab6d5b6588@syzkaller.appspotmail.com
Signed-off-by: Jens Axboe <axboe@kernel.dk>
[ Minor conflict resolved. ]
Signed-off-by: Jianqiang kang <jianqkang@sina.cn>
---
 io_uring/io-wq.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/io_uring/io-wq.c b/io_uring/io-wq.c
index c5d249f5d214..926890f5086e 100644
--- a/io_uring/io-wq.c
+++ b/io_uring/io-wq.c
@@ -554,9 +554,9 @@ static void io_worker_handle_work(struct io_worker *worker)
 	struct io_wqe_acct *acct = io_wqe_get_acct(worker);
 	struct io_wqe *wqe = worker->wqe;
 	struct io_wq *wq = wqe->wq;
-	bool do_kill = test_bit(IO_WQ_BIT_EXIT, &wq->state);
 
 	do {
+		bool do_kill = test_bit(IO_WQ_BIT_EXIT, &wq->state);
 		struct io_wq_work *work;
 get_next:
 		/*
-- 
2.34.1


