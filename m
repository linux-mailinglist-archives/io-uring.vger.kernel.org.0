Return-Path: <io-uring+bounces-12017-lists+io-uring=lfdr.de@vger.kernel.org>
Delivered-To: lists+io-uring@lfdr.de
Received: from mail.lfdr.de
	by lfdr with LMTP
	id MB8qLKi4gGl3AgMAu9opvQ
	(envelope-from <io-uring+bounces-12017-lists+io-uring=lfdr.de@vger.kernel.org>)
	for <lists+io-uring@lfdr.de>; Mon, 02 Feb 2026 15:46:00 +0100
X-Original-To: lists+io-uring@lfdr.de
Received: from sea.lore.kernel.org (sea.lore.kernel.org [172.234.253.10])
	by mail.lfdr.de (Postfix) with ESMTPS id 119D5CD8BE
	for <lists+io-uring@lfdr.de>; Mon, 02 Feb 2026 15:46:00 +0100 (CET)
Received: from smtp.subspace.kernel.org (conduit.subspace.kernel.org [100.90.174.1])
	by sea.lore.kernel.org (Postfix) with ESMTP id 68B9F3064660
	for <lists+io-uring@lfdr.de>; Mon,  2 Feb 2026 14:38:24 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 83C5736C5A1;
	Mon,  2 Feb 2026 14:38:18 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux.beauty header.i=me@linux.beauty header.b="SNRykqRz"
X-Original-To: io-uring@vger.kernel.org
Received: from sender4-pp-f112.zoho.com (sender4-pp-f112.zoho.com [136.143.188.112])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 132FA36D503;
	Mon,  2 Feb 2026 14:38:15 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=pass smtp.client-ip=136.143.188.112
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1770043098; cv=pass; b=uZ8Wy0i+nuAnT7/OlwIgOGuqQlWLHTwIqSgCaS1yflDO3BxNXXtJOyjYdCnXLucDr2fL95sFUrf2AxOJNQ0H/kOU3NQygH7gPWbJfXL5i1inT+A+aZmxf8pz+Oy4dlxfZiz5QtoUXKw3DIM+SBJ/x86e6kmoc5pE4e3N77Y08Jg=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1770043098; c=relaxed/simple;
	bh=t6Y5H4kB1QH/4ParZV6ejK0CSejebBMkbwmLzAWC8rk=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=HxAE6Am1UOtdfq04qppe5hVL1Ct41fDXZ/kM085l3SjnQynTt+ZIry1khOwmzmE0QFFwXxJhGVHWA7M4WVTimiBQkNwb6m2Dftm8yWz7M8GrMpMqpPJTKg4jOm7C9otbTaC4qIB5ant8d3WTXAlIsB+KWBbPY1/KMI9DBf4kFzI=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=linux.beauty; spf=pass smtp.mailfrom=linux.beauty; dkim=pass (1024-bit key) header.d=linux.beauty header.i=me@linux.beauty header.b=SNRykqRz; arc=pass smtp.client-ip=136.143.188.112
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=linux.beauty
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linux.beauty
ARC-Seal: i=1; a=rsa-sha256; t=1770043089; cv=none; 
	d=zohomail.com; s=zohoarc; 
	b=MiKQJkODclm+nUu1xNF3eOfelgksjfA7QkQ2W184tvBJiGmMe05lIIDn7IMEq7CbH2z6X4M3wOQUkOK6IVSoe9Q4ZGV8nUMqsDMca32SLuhKwU01CzqA8J3ZhxjjGmVwE/yEYMtamynXrKSLXNwUGlcBBdOd/r7sUchQHxz07Ek=
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=zohomail.com; s=zohoarc; 
	t=1770043089; h=Content-Transfer-Encoding:Cc:Cc:Date:Date:From:From:In-Reply-To:MIME-Version:Message-ID:References:Subject:Subject:To:To:Message-Id:Reply-To; 
	bh=VTPS+j7rvZFemJysvebWwUvJl/gHYBMD3ApxpBcFUxg=; 
	b=BymOiKINoldMluOTM9niWPT2RL7XG9RLltlK1TP5HL1Tcpt0kmB+LpUIJSPhhjH4znytGo2QZYt/NoLcXha5/YTMa//YJhO9NaKyTJY9nW7GzL5MvoPVNMY4DllG1rCOD30fB+DqTPUscyTaG1Bd1jOEsssGbmbJGphz+GSVyRE=
ARC-Authentication-Results: i=1; mx.zohomail.com;
	dkim=pass  header.i=linux.beauty;
	spf=pass  smtp.mailfrom=me@linux.beauty;
	dmarc=pass header.from=<me@linux.beauty>
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; t=1770043089;
	s=zmail; d=linux.beauty; i=me@linux.beauty;
	h=From:From:To:To:Cc:Cc:Subject:Subject:Date:Date:Message-ID:In-Reply-To:References:MIME-Version:Content-Transfer-Encoding:Message-Id:Reply-To;
	bh=VTPS+j7rvZFemJysvebWwUvJl/gHYBMD3ApxpBcFUxg=;
	b=SNRykqRzYnrw/FaoEgzFDs9SWxXM2RWqGL26g15rJwmgpoTTxtwIgxwrIv9t2Sqr
	8cihMINnzo+yA9I+PYkfZAsdi/hPpoXhmbRLFZC9LyiWvC9bsy8ARXhV+nvVjv2BE3X
	kBIU2OpXODT3rr8qi5oWC4EUxX0Z7HJ9ibRZzhFg=
Received: by mx.zohomail.com with SMTPS id 17700430880721022.5747565802877;
	Mon, 2 Feb 2026 06:38:08 -0800 (PST)
From: Li Chen <me@linux.beauty>
To: Jens Axboe <axboe@kernel.dk>,
	Pavel Begunkov <asml.silence@gmail.com>,
	io-uring@vger.kernel.org,
	linux-kernel@vger.kernel.org
Cc: Li Chen <me@linux.beauty>
Subject: [PATCH v1 1/2] io-wq: add exit-on-idle mode
Date: Mon,  2 Feb 2026 22:37:53 +0800
Message-ID: <20260202143755.789114-2-me@linux.beauty>
X-Mailer: git-send-email 2.52.0
In-Reply-To: <20260202143755.789114-1-me@linux.beauty>
References: <20260202143755.789114-1-me@linux.beauty>
Precedence: bulk
X-Mailing-List: io-uring@vger.kernel.org
List-Id: <io-uring.vger.kernel.org>
List-Subscribe: <mailto:io-uring+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:io-uring+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-ZohoMailClient: External
X-Rspamd-Server: lfdr
X-Spamd-Result: default: False [1.34 / 15.00];
	SUSPICIOUS_RECIPS(1.50)[];
	MID_CONTAINS_FROM(1.00)[];
	ARC_ALLOW(-1.00)[subspace.kernel.org:s=arc-20240116:i=2];
	R_MISSING_CHARSET(0.50)[];
	R_DKIM_ALLOW(-0.20)[linux.beauty:s=zmail];
	R_SPF_ALLOW(-0.20)[+ip4:172.234.253.10:c];
	MAILLIST(-0.15)[generic];
	MIME_GOOD(-0.10)[text/plain];
	HAS_LIST_UNSUB(-0.01)[];
	RCVD_TLS_LAST(0.00)[];
	RCVD_COUNT_THREE(0.00)[4];
	DMARC_NA(0.00)[linux.beauty];
	FORGED_SENDER_MAILLIST(0.00)[];
	FREEMAIL_TO(0.00)[kernel.dk,gmail.com,vger.kernel.org];
	TO_DN_SOME(0.00)[];
	MIME_TRACE(0.00)[0:+];
	TAGGED_FROM(0.00)[bounces-12017-lists,io-uring=lfdr.de];
	DKIM_TRACE(0.00)[linux.beauty:+];
	FORGED_RECIPIENTS_MAILLIST(0.00)[];
	FROM_NEQ_ENVFROM(0.00)[me@linux.beauty,io-uring@vger.kernel.org];
	FROM_HAS_DN(0.00)[];
	RCPT_COUNT_FIVE(0.00)[5];
	PRECEDENCE_BULK(0.00)[];
	TAGGED_RCPT(0.00)[io-uring];
	NEURAL_HAM(-0.00)[-1.000];
	ASN(0.00)[asn:63949, ipnet:172.234.224.0/19, country:SG];
	DBL_BLOCKED_OPENRESOLVER(0.00)[sea.lore.kernel.org:helo,sea.lore.kernel.org:rdns,linux.beauty:email,linux.beauty:dkim,linux.beauty:mid]
X-Rspamd-Queue-Id: 119D5CD8BE
X-Rspamd-Action: no action

io-wq uses an idle timeout to shrink the pool, but keeps the last worker
around indefinitely to avoid churn.

For tasks that used io_uring for file I/O and then stop using io_uring,
this can leave an iou-wrk-* thread behind even after all io_uring instances
are gone. This is unnecessary overhead and also gets in the way of process
checkpoint/restore.

Add an exit-on-idle mode that makes all io-wq workers exit as soon as they
become idle, and provide io_wq_set_exit_on_idle() to toggle it.

Signed-off-by: Li Chen <me@linux.beauty>
---
 io_uring/io-wq.c | 31 +++++++++++++++++++++++++++++++
 io_uring/io-wq.h |  1 +
 2 files changed, 32 insertions(+)

diff --git a/io_uring/io-wq.c b/io_uring/io-wq.c
index 5d0928f37471..97e7eb847c6e 100644
--- a/io_uring/io-wq.c
+++ b/io_uring/io-wq.c
@@ -35,6 +35,7 @@ enum {
 
 enum {
 	IO_WQ_BIT_EXIT		= 0,	/* wq exiting */
+	IO_WQ_BIT_EXIT_ON_IDLE	= 1,	/* allow all workers to exit on idle */
 };
 
 enum {
@@ -655,6 +656,18 @@ static int io_wq_worker(void *data)
 			io_worker_handle_work(acct, worker);
 
 		raw_spin_lock(&wq->lock);
+		/*
+		 * If wq is marked idle-exit, drop this worker as soon as it
+		 * becomes idle. This is used to avoid keeping io-wq worker
+		 * threads around for tasks that no longer have any active
+		 * io_uring instances.
+		 */
+		if (test_bit(IO_WQ_BIT_EXIT_ON_IDLE, &wq->state)) {
+			acct->nr_workers--;
+			raw_spin_unlock(&wq->lock);
+			__set_current_state(TASK_RUNNING);
+			break;
+		}
 		/*
 		 * Last sleep timed out. Exit if we're not the last worker,
 		 * or if someone modified our affinity.
@@ -894,6 +907,24 @@ static bool io_wq_worker_wake(struct io_worker *worker, void *data)
 	return false;
 }
 
+void io_wq_set_exit_on_idle(struct io_wq *wq, bool enable)
+{
+	if (!wq->task)
+		return;
+
+	if (!enable) {
+		clear_bit(IO_WQ_BIT_EXIT_ON_IDLE, &wq->state);
+		return;
+	}
+
+	if (test_and_set_bit(IO_WQ_BIT_EXIT_ON_IDLE, &wq->state))
+		return;
+
+	rcu_read_lock();
+	io_wq_for_each_worker(wq, io_wq_worker_wake, NULL);
+	rcu_read_unlock();
+}
+
 static void io_run_cancel(struct io_wq_work *work, struct io_wq *wq)
 {
 	do {
diff --git a/io_uring/io-wq.h b/io_uring/io-wq.h
index b3b004a7b625..f7f17a23693e 100644
--- a/io_uring/io-wq.h
+++ b/io_uring/io-wq.h
@@ -46,6 +46,7 @@ struct io_wq_data {
 struct io_wq *io_wq_create(unsigned bounded, struct io_wq_data *data);
 void io_wq_exit_start(struct io_wq *wq);
 void io_wq_put_and_exit(struct io_wq *wq);
+void io_wq_set_exit_on_idle(struct io_wq *wq, bool enable);
 
 void io_wq_enqueue(struct io_wq *wq, struct io_wq_work *work);
 void io_wq_hash_work(struct io_wq_work *work, void *val);
-- 
2.52.0


