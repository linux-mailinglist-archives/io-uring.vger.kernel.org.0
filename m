Return-Path: <io-uring+bounces-13525-lists+io-uring=lfdr.de@vger.kernel.org>
Delivered-To: lists+io-uring@lfdr.de
Received: from mail.lfdr.de
	by lfdr with LMTP
	id oAa9AGkDF2qz0wcAu9opvQ
	(envelope-from <io-uring+bounces-13525-lists+io-uring=lfdr.de@vger.kernel.org>)
	for <lists+io-uring@lfdr.de>; Wed, 27 May 2026 16:44:57 +0200
X-Original-To: lists+io-uring@lfdr.de
Received: from sto.lore.kernel.org (sto.lore.kernel.org [IPv6:2600:3c09:e001:a7::12fc:5321])
	by mail.lfdr.de (Postfix) with ESMTPS id 5E74E5E61FC
	for <lists+io-uring@lfdr.de>; Wed, 27 May 2026 16:44:54 +0200 (CEST)
Received: from smtp.subspace.kernel.org (conduit.subspace.kernel.org [100.90.174.1])
	by sto.lore.kernel.org (Postfix) with ESMTP id 0E3EB3002330
	for <lists+io-uring@lfdr.de>; Wed, 27 May 2026 14:43:04 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id A1EE040312F;
	Wed, 27 May 2026 14:43:02 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=seu.edu.cn header.i=@seu.edu.cn header.b="gXt3IGMt"
X-Original-To: io-uring@vger.kernel.org
Received: from mail-m155101.qiye.163.com (mail-m155101.qiye.163.com [101.71.155.101])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id EBE0E3C9895;
	Wed, 27 May 2026 14:42:57 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=101.71.155.101
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1779892982; cv=none; b=aB38Pf79N4xJjijPiKk9+GrESAB/rEfkcEqekhe5wrZ7RUJbgkzd87oD99j4twh5fOf4Kg77KVRZ95uJD7X4vZvzn783drYXXRpZSCdri0HjaFpw4XPZyd+9IrEhBs2AgL5g9VkK2hvBFBgr3wtjtR2smM7fJjzVYiSRQw39odM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1779892982; c=relaxed/simple;
	bh=HBl4uHO9ggkkENKCSIs+KBLQnxZVryB8Q5QaWMbpIek=;
	h=From:To:Cc:Subject:Date:Message-Id:MIME-Version; b=jltotwlKx7jxAnD1PGwCJD3xwjpwAnX1MH7pehAbA6Ncca77TFekBUddep6a844LjzShFzuEedUmdjk/coP8rDsXpTFhp0hotwi2+0JhAiuCOJXPkkg0VbHucheuVPVUjtVWhh3xN3U8VSBbN5cX9e3yyTxGr35YcV5oiOLIG1k=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=seu.edu.cn; spf=pass smtp.mailfrom=seu.edu.cn; dkim=pass (1024-bit key) header.d=seu.edu.cn header.i=@seu.edu.cn header.b=gXt3IGMt; arc=none smtp.client-ip=101.71.155.101
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=seu.edu.cn
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=seu.edu.cn
Received: from DESKTOP-4LEIBBM.localdomain (unknown [223.112.146.162])
	by smtp.qiye.163.com (Hmail) with ESMTP id 400cc03f3;
	Wed, 27 May 2026 22:37:37 +0800 (GMT+08:00)
From: Runyu Xiao <runyu.xiao@seu.edu.cn>
To: axboe@kernel.dk,
	io-uring@vger.kernel.org
Cc: linux-kernel@vger.kernel.org,
	gregkh@linuxfoundation.org,
	jianhao.xu@seu.edu.cn,
	Runyu Xiao <runyu.xiao@seu.edu.cn>,
	stable@vger.kernel.org
Subject: [PATCH] io_uring/io-wq: re-check IO_WQ_BIT_EXIT for each linked work item
Date: Wed, 27 May 2026 22:37:26 +0800
Message-Id: <20260527143726.1272269-1-runyu.xiao@seu.edu.cn>
X-Mailer: git-send-email 2.34.1
Precedence: bulk
X-Mailing-List: io-uring@vger.kernel.org
List-Id: <io-uring.vger.kernel.org>
List-Subscribe: <mailto:io-uring+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:io-uring+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-HM-Tid: 0a9e69de9b2703a1kunmfbe58bea5de0
X-HM-MType: 10
X-HM-Spam-Status: e1kfGhgUHx5ZQUpXWQgPGg8OCBgUHx5ZQUlOS1dZFg8aDwILHllBWSg2Ly
	tZV1koWUFITzdXWRgWCB1ZQUpXWS1ZQUlXWQ8JGhUIEh9ZQVlDTR4fVh9CGRoaHkJMQ0sZGFYeHw
	5VEwETFhoSFyQUDg9ZV1kYEgtZQVlJSUhVSkpJVUpPTVVKTUlZV1kWGg8SFR0UWUFZT0tIVUpLSU
	hOQ0NVSktLVUtZBg++
DKIM-Signature: a=rsa-sha256;
	b=gXt3IGMtZ/I2In3dMLGOF/oWueetYTfvEuqz2AjFmUKExgaYslQWqaZ4xN5Vt/SFYAFeYszMimO9cdfYIn2JoJCnFS9rPF0cuYN+DqUOM/9b5wjOTAx3K8My0LndOsumdNYBRVacNUm0bHFOl4nJlnFLdbX0ePZDdFkhRLEeXX8=; c=relaxed/relaxed; s=default; d=seu.edu.cn; v=1;
	bh=UsxRPjYaQmtiWihHVrdRAhAvQF4W2fWtziaBrLxv9Rk=;
	h=date:mime-version:subject:message-id:from;
X-Spamd-Result: default: False [-0.66 / 15.00];
	ARC_ALLOW(-1.00)[subspace.kernel.org:s=arc-20240116:i=1];
	MID_CONTAINS_FROM(1.00)[];
	R_MISSING_CHARSET(0.50)[];
	DMARC_POLICY_ALLOW(-0.50)[seu.edu.cn,none];
	R_SPF_ALLOW(-0.20)[+ip6:2600:3c09:e001:a7::/64:c];
	R_DKIM_ALLOW(-0.20)[seu.edu.cn:s=default];
	MAILLIST(-0.15)[generic];
	MIME_GOOD(-0.10)[text/plain];
	HAS_LIST_UNSUB(-0.01)[];
	FORGED_SENDER_MAILLIST(0.00)[];
	MIME_TRACE(0.00)[0:+];
	RCVD_COUNT_THREE(0.00)[4];
	RCVD_TLS_LAST(0.00)[];
	TAGGED_FROM(0.00)[bounces-13525-lists,io-uring=lfdr.de];
	DKIM_TRACE(0.00)[seu.edu.cn:+];
	ASN(0.00)[asn:63949, ipnet:2600:3c09::/32, country:SG];
	TO_DN_SOME(0.00)[];
	FROM_NEQ_ENVFROM(0.00)[runyu.xiao@seu.edu.cn,io-uring@vger.kernel.org];
	FROM_HAS_DN(0.00)[];
	FORGED_RECIPIENTS_MAILLIST(0.00)[];
	PRECEDENCE_BULK(0.00)[];
	RCPT_COUNT_SEVEN(0.00)[7];
	NEURAL_HAM(-0.00)[-1.000];
	TAGGED_RCPT(0.00)[io-uring];
	DBL_BLOCKED_OPENRESOLVER(0.00)[sto.lore.kernel.org:rdns,sto.lore.kernel.org:helo]
X-Rspamd-Queue-Id: 5E74E5E61FC
X-Rspamd-Action: no action
X-Rspamd-Server: lfdr

Commit bdf0bf73006e ("io_uring/io-wq: check IO_WQ_BIT_EXIT inside work
run loop") fixed the obvious case where io_worker_handle_work() took one
exit-bit snapshot before draining pending work, but the fix stops one
level too early.

io_worker_handle_work() now re-checks IO_WQ_BIT_EXIT in its outer work
run loop, yet it still snapshots that bit once before processing a
whole dependent linked-work chain. If io_wq_exit_start() sets
IO_WQ_BIT_EXIT after the first linked item has started, the remaining
linked items can still reuse stale do_kill = false, skip
IO_WQ_WORK_CANCEL, and continue running after exit has begun.

That means the previous fix did not fully eliminate the exit-latency
problem; it only narrowed it to linked chains. A long or slow linked
chain can still keep io-wq exit waiting for work that should already
have been canceled.

The issue was found on Linux v6.18.21 by our static-analysis tool,
which flagged linked-work loops that snapshot shared exit state
outside per-item cancel decisions, and was then confirmed by manual
auditing of io_worker_handle_work(). It was later reproduced with a
QEMU no-device validation selftest that preserved the same contract:
a three-node unbound linked chain, an exit actor setting
IO_WQ_BIT_EXIT after work1, and slow post-exit linked work. With a
3000 ms delay injected into each post-exit item, the buggy path
spends about 6066 ms after exit running work2/work3, while the fixed
path cancels both and finishes in about 2 ms.

Re-check test_bit(IO_WQ_BIT_EXIT, &wq->state) for each iteration of the
dependent-link loop, right before deciding whether to cancel the
current work item. That closes the remaining stale-snapshot window and
prevents linked post-exit work from stretching shutdown latency.

Build-tested by compiling io_uring/io-wq.o on x86_64 with the local
.config. No special hardware was required.

Fixes: bdf0bf73006e ("io_uring/io-wq: check IO_WQ_BIT_EXIT inside work run loop")
Cc: stable@vger.kernel.org
Signed-off-by: Runyu Xiao <runyu.xiao@seu.edu.cn>
---
 io_uring/io-wq.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/io_uring/io-wq.c b/io_uring/io-wq.c
index 49a9c914b4e9..28d81398ebee 100644
--- a/io_uring/io-wq.c
+++ b/io_uring/io-wq.c
@@ -601,7 +601,6 @@ static void io_worker_handle_work(struct io_wq_acct *acct,
 	struct io_wq *wq = worker->wq;
 
 	do {
-		bool do_kill = test_bit(IO_WQ_BIT_EXIT, &wq->state);
 		struct io_wq_work *work;
 
 		/*
@@ -637,6 +636,7 @@ static void io_worker_handle_work(struct io_wq_acct *acct,
 
 		/* handle a whole dependent link */
 		do {
+			bool do_kill = test_bit(IO_WQ_BIT_EXIT, &wq->state);
 			struct io_wq_work *next_hashed, *linked;
 			unsigned int work_flags = atomic_read(&work->flags);
 			unsigned int hash = __io_wq_is_hashed(work_flags)
-- 
2.34.1

