Return-Path: <io-uring+bounces-4981-lists+io-uring=lfdr.de@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [IPv6:2604:1380:45d1:ec00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 8C0E69D61ED
	for <lists+io-uring@lfdr.de>; Fri, 22 Nov 2024 17:18:00 +0100 (CET)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id F2DD616162E
	for <lists+io-uring@lfdr.de>; Fri, 22 Nov 2024 16:17:21 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id C55F61DEFFC;
	Fri, 22 Nov 2024 16:17:01 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel-dk.20230601.gappssmtp.com header.i=@kernel-dk.20230601.gappssmtp.com header.b="xvNdOuwo"
X-Original-To: io-uring@vger.kernel.org
Received: from mail-oa1-f50.google.com (mail-oa1-f50.google.com [209.85.160.50])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2AB6F1DE2BE
	for <io-uring@vger.kernel.org>; Fri, 22 Nov 2024 16:16:58 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.160.50
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1732292221; cv=none; b=faPftNViZi+W6VWjcshEu9R0jnPAZ/2gG1K/cqmzEmNJDvNcushWZn9+RzWvgNWf/55muYJudyXyIbL632PGD8gilirh7N0zgxoQ28O9ymB3zJbaxbnFWfWVzBDd394sADsSmY0eVbPuTOCHlfcpjwiuFp4K+2O+4Wtp+y1VMXQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1732292221; c=relaxed/simple;
	bh=Sx7Z+8UdA2+RRGv0MaBPB+SqAcBDuC10NJpQzFkxep0=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=UOjuVis5bD93ObtWmtWZJmTHPzCyer1uSyFha1DEEIJcrwMuC6O9X9XIYotmiOFxcTepvHtva2ZQjy8r7ScmAINa7/osL0sWOdSDVEvyO4UjVaHpM561+Dw4zaF1qRZcofp1PGzd+vVu/h+G1HkMVbeSiAlYil/49OaaGm3KREQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=kernel.dk; spf=pass smtp.mailfrom=kernel.dk; dkim=pass (2048-bit key) header.d=kernel-dk.20230601.gappssmtp.com header.i=@kernel-dk.20230601.gappssmtp.com header.b=xvNdOuwo; arc=none smtp.client-ip=209.85.160.50
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=kernel.dk
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=kernel.dk
Received: by mail-oa1-f50.google.com with SMTP id 586e51a60fabf-27b7a1480bdso1288280fac.2
        for <io-uring@vger.kernel.org>; Fri, 22 Nov 2024 08:16:58 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernel-dk.20230601.gappssmtp.com; s=20230601; t=1732292217; x=1732897017; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=psFPyPZEURJCFZnrPeS8wFL/Z8gpnok+wNuirh5Dqm8=;
        b=xvNdOuwoSFjEWh4TFxZqeI5f+LSlR2157OE6xPQL2b49+Ukc6rh8kDyF/QPYTWQYw5
         AkKSRV4cci6UiVA3n47rme7FFeFsbi+at99leHMJ8s1VKrCI2hGBD2e/Nw6JERIK+mo/
         DeRNK/rMQ77WVR2/bbcA1st65X3k/ctkg5ilQNMjL5vgCfb+PBd2V5lwMl8wxSHz/G1+
         Gq1Gte2DTynpv3H+vwwF9er3/JkgfpOuUOv+avcPehzHXiSm7dCY6Tt988tVRStwS37K
         gZLJA9W2kksZNT6oob+WHQyU5p+hkyEeq4JSc9LdKXdW3OhK3SyfqQpQ9k+dnr0xSiTl
         4RTA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1732292217; x=1732897017;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=psFPyPZEURJCFZnrPeS8wFL/Z8gpnok+wNuirh5Dqm8=;
        b=bxqkyh2+e7YxGdu1KzF20T0r4i/nHh+9mCmTHD1NZe2D2QY3abKsr/N8m0mEcMcHa3
         dDZ/RsRjd7tn21Ov3okDcxDitDUoY1LsNjiMcuTsKcguchDNqERFm157un07e6NfCG55
         75ARHWrteD/lomxZkqc46EQ0LPkDY21vUsIz0MVUHthII8hwq0MmRvcRt5ou0UmdvVem
         Sd2bCXZKpWEw9qbkgNV6E2YfMmT8+rbS9Ijh/ZeKm0t7z47iLpuyZTST6XFMF+cIzMR8
         U1N0IrJxVNLRie0z7zN0zYA3wiieNdb+AfXV9jun352HB/DGYj2LLYCPufTDB9ieIZ3o
         ICGQ==
X-Gm-Message-State: AOJu0YyB+AGHGyLmz9WnlPWXMUyEhQIm9fv8BYUNpWhVNNMUmN3kF6Vv
	OngOlE00fH3epEcAKws4yBdSUzqi8kUhOHMNWrdHRxsRxGz9fYfYbo9u7ypMXkMn/IfP+WWTP4H
	p1ZM=
X-Gm-Gg: ASbGnctFai9cYW9+37tzKIU1qq0b+RhAjWP5IpwCRstbEX/DdUPaGkWsoqI1vVfXdyK
	tePeKbKLSPsR8ltTzpcXZSG1pWM+vidb7WHTmYVsx9RRrPqgBBhH7Rznwkh7z9OULbIeMGkACIs
	z0j+SnBEyYqChXFCwevdd605jeKTq6eaQx8d+mdMW1yMa5TR9/1LrQv1h346+CaQj5e+Ax8VhuY
	D0kYJb0hEc2Lbl42XX22vMACCUOdsYP3dv9EcHZies5EwGU7cReLA==
X-Google-Smtp-Source: AGHT+IHyvujbI0j7KjJUO5J9PTZWB89UCenjCzkqOjB7ByEW8xtrUXxxhaKAX89983rwJh2g1sa+Sw==
X-Received: by 2002:a05:6870:d69c:b0:296:de15:f27d with SMTP id 586e51a60fabf-29720e08c8bmr4174309fac.30.1732292217656;
        Fri, 22 Nov 2024 08:16:57 -0800 (PST)
Received: from localhost.localdomain ([96.43.243.2])
        by smtp.gmail.com with ESMTPSA id 006d021491bc7-5f06976585esm436958eaf.18.2024.11.22.08.16.56
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 22 Nov 2024 08:16:56 -0800 (PST)
From: Jens Axboe <axboe@kernel.dk>
To: io-uring@vger.kernel.org
Cc: Jens Axboe <axboe@kernel.dk>
Subject: [PATCH 6/6] io_uring: make __tctx_task_work_run() take an io_wq_work_list
Date: Fri, 22 Nov 2024 09:12:44 -0700
Message-ID: <20241122161645.494868-7-axboe@kernel.dk>
X-Mailer: git-send-email 2.45.2
In-Reply-To: <20241122161645.494868-1-axboe@kernel.dk>
References: <20241122161645.494868-1-axboe@kernel.dk>
Precedence: bulk
X-Mailing-List: io-uring@vger.kernel.org
List-Id: <io-uring.vger.kernel.org>
List-Subscribe: <mailto:io-uring+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:io-uring+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

The normal task_work logic doesn't really need it, as it always runs
all of the pending work. But for SQPOLL, it can now pass in its
retry_list which simplifies the tracking of split up task_work running.

This avoids passing io_wq_work_node around. Rather than pass in a list,
SQPOLL could re-add the leftover items to the generic task_work list.
But that requires re-locking the task_lock and using task_list for that,
whereas having a separate retry list allows for skipping those steps.
The downside is that now two lists need checking, but that's now it
was before as well.

Signed-off-by: Jens Axboe <axboe@kernel.dk>
---
 io_uring/io_uring.c | 36 ++++++++++++++++--------------------
 io_uring/io_uring.h |  9 +++++----
 io_uring/sqpoll.c   | 20 +++++++++++---------
 3 files changed, 32 insertions(+), 33 deletions(-)

diff --git a/io_uring/io_uring.c b/io_uring/io_uring.c
index bc520a67fc03..5e52d8db3dca 100644
--- a/io_uring/io_uring.c
+++ b/io_uring/io_uring.c
@@ -1044,20 +1044,20 @@ static void ctx_flush_and_put(struct io_ring_ctx *ctx, struct io_tw_state *ts)
 /*
  * Run queued task_work, returning the number of entries processed in *count.
  * If more entries than max_entries are available, stop processing once this
- * is reached and return the rest of the list.
+ * is reached.
  */
-struct io_wq_work_node *io_handle_tw_list(struct io_wq_work_node *node,
-					  unsigned int *count,
-					  unsigned int max_entries)
+void io_handle_tw_list(struct io_wq_work_list *list, unsigned int *count,
+		       unsigned int max_entries)
 {
 	struct io_ring_ctx *ctx = NULL;
 	struct io_tw_state ts = { };
 
 	do {
-		struct io_wq_work_node *next = node->next;
+		struct io_wq_work_node *node = list->first;
 		struct io_kiocb *req = container_of(node, struct io_kiocb,
 						    io_task_work.node);
 
+		list->first = node->next;
 		if (req->ctx != ctx) {
 			ctx_flush_and_put(ctx, &ts);
 			ctx = req->ctx;
@@ -1067,17 +1067,15 @@ struct io_wq_work_node *io_handle_tw_list(struct io_wq_work_node *node,
 		INDIRECT_CALL_2(req->io_task_work.func,
 				io_poll_task_func, io_req_rw_complete,
 				req, &ts);
-		node = next;
 		(*count)++;
 		if (unlikely(need_resched())) {
 			ctx_flush_and_put(ctx, &ts);
 			ctx = NULL;
 			cond_resched();
 		}
-	} while (node && *count < max_entries);
+	} while (list->first && *count < max_entries);
 
 	ctx_flush_and_put(ctx, &ts);
-	return node;
 }
 
 static __cold void __io_fallback_schedule(struct io_ring_ctx *ctx,
@@ -1137,41 +1135,39 @@ static void io_fallback_tw(struct io_uring_task *tctx, bool sync)
 	__io_fallback_tw(&tctx->task_list, &tctx->task_lock, sync);
 }
 
-struct io_wq_work_node *__tctx_task_work_run(struct io_uring_task *tctx,
-					     unsigned int max_entries,
-					     unsigned int *count)
+void __tctx_task_work_run(struct io_uring_task *tctx,
+			  struct io_wq_work_list *list,
+			  unsigned int max_entries, unsigned int *count)
 {
-	struct io_wq_work_node *node;
-
 	if (unlikely(current->flags & PF_EXITING)) {
 		io_fallback_tw(tctx, true);
-		return NULL;
+		return;
 	}
 
 	if (!READ_ONCE(tctx->task_list.first))
-		return NULL;
+		return;
 
 	spin_lock_irq(&tctx->task_lock);
-	node = tctx->task_list.first;
+	*list = tctx->task_list;
 	INIT_WQ_LIST(&tctx->task_list);
 	spin_unlock_irq(&tctx->task_lock);
 
-	if (node)
-		node = io_handle_tw_list(node, count, max_entries);
+	if (!wq_list_empty(list))
+		io_handle_tw_list(list, count, max_entries);
 
 	/* relaxed read is enough as only the task itself sets ->in_cancel */
 	if (unlikely(atomic_read(&tctx->in_cancel)))
 		io_uring_drop_tctx_refs(current);
 
 	trace_io_uring_task_work_run(tctx, *count);
-	return node;
 }
 
 unsigned int tctx_task_work_run(struct io_uring_task *tctx)
 {
+	struct io_wq_work_list list;
 	unsigned int count = 0;
 
-	__tctx_task_work_run(tctx, UINT_MAX, &count);
+	__tctx_task_work_run(tctx, &list, UINT_MAX, &count);
 	return count;
 }
 
diff --git a/io_uring/io_uring.h b/io_uring/io_uring.h
index 2b0e7c5db30d..74b1468aefda 100644
--- a/io_uring/io_uring.h
+++ b/io_uring/io_uring.h
@@ -91,10 +91,11 @@ void io_req_task_queue(struct io_kiocb *req);
 void io_req_task_complete(struct io_kiocb *req, struct io_tw_state *ts);
 void io_req_task_queue_fail(struct io_kiocb *req, int ret);
 void io_req_task_submit(struct io_kiocb *req, struct io_tw_state *ts);
-struct io_wq_work_node *io_handle_tw_list(struct io_wq_work_node *node,
-	unsigned int *count, unsigned int max_entries);
-struct io_wq_work_node *__tctx_task_work_run(struct io_uring_task *tctx,
-	unsigned int max_entries, unsigned int *count);
+void io_handle_tw_list(struct io_wq_work_list *list, unsigned int *count,
+	unsigned int max_entries);
+void __tctx_task_work_run(struct io_uring_task *tctx,
+	struct io_wq_work_list *list, unsigned int max_entries,
+	unsigned int *count);
 unsigned int tctx_task_work_run(struct io_uring_task *tctx);
 void tctx_task_work(struct callback_head *cb);
 __cold void io_uring_cancel_generic(bool cancel_all, struct io_sq_data *sqd);
diff --git a/io_uring/sqpoll.c b/io_uring/sqpoll.c
index aec6c2d56910..3cd50369db5a 100644
--- a/io_uring/sqpoll.c
+++ b/io_uring/sqpoll.c
@@ -221,29 +221,29 @@ static bool io_sqd_handle_event(struct io_sq_data *sqd)
  * than we were asked to process. Newly queued task_work isn't run until the
  * retry list has been fully processed.
  */
-static unsigned int io_sq_tw(struct io_wq_work_node **retry_list, int max_entries)
+static unsigned int io_sq_tw(struct io_wq_work_list *retry_list, int max_entries)
 {
 	struct io_uring_task *tctx = current->io_uring;
 	unsigned int count = 0;
 
-	if (*retry_list) {
-		*retry_list = io_handle_tw_list(*retry_list, &count, max_entries);
+	if (!wq_list_empty(retry_list)) {
+		io_handle_tw_list(retry_list, &count, max_entries);
 		if (count >= max_entries)
 			goto out;
 		max_entries -= count;
 	}
-	*retry_list = __tctx_task_work_run(tctx, max_entries, &count);
+	__tctx_task_work_run(tctx, retry_list, max_entries, &count);
 out:
 	if (task_work_pending(current))
 		task_work_run();
 	return count;
 }
 
-static bool io_sq_tw_pending(struct io_wq_work_node *retry_list)
+static bool io_sq_tw_pending(struct io_wq_work_list *retry_list)
 {
 	struct io_uring_task *tctx = current->io_uring;
 
-	return retry_list || READ_ONCE(tctx->task_list.first);
+	return !wq_list_empty(retry_list) || !wq_list_empty(&tctx->task_list);
 }
 
 static void io_sq_update_worktime(struct io_sq_data *sqd, struct rusage *start)
@@ -259,7 +259,7 @@ static void io_sq_update_worktime(struct io_sq_data *sqd, struct rusage *start)
 
 static int io_sq_thread(void *data)
 {
-	struct io_wq_work_node *retry_list = NULL;
+	struct io_wq_work_list retry_list;
 	struct io_sq_data *sqd = data;
 	struct io_ring_ctx *ctx;
 	struct rusage start;
@@ -292,6 +292,7 @@ static int io_sq_thread(void *data)
 	audit_uring_entry(IORING_OP_NOP);
 	audit_uring_exit(true, 0);
 
+	INIT_WQ_LIST(&retry_list);
 	mutex_lock(&sqd->lock);
 	while (1) {
 		bool cap_entries, sqt_spin = false;
@@ -332,7 +333,8 @@ static int io_sq_thread(void *data)
 		}
 
 		prepare_to_wait(&sqd->wait, &wait, TASK_INTERRUPTIBLE);
-		if (!io_sqd_events_pending(sqd) && !io_sq_tw_pending(retry_list)) {
+		if (!io_sqd_events_pending(sqd) &&
+		    !io_sq_tw_pending(&retry_list)) {
 			bool needs_sched = true;
 
 			list_for_each_entry(ctx, &sqd->ctx_list, sqd_list) {
@@ -371,7 +373,7 @@ static int io_sq_thread(void *data)
 		timeout = jiffies + sqd->sq_thread_idle;
 	}
 
-	if (retry_list)
+	if (!wq_list_empty(&retry_list))
 		io_sq_tw(&retry_list, UINT_MAX);
 
 	io_uring_cancel_generic(true, sqd);
-- 
2.45.2


