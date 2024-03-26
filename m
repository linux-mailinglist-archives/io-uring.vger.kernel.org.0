Return-Path: <io-uring+bounces-1235-lists+io-uring=lfdr.de@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [147.75.80.249])
	by mail.lfdr.de (Postfix) with ESMTPS id DDFE388CC3E
	for <lists+io-uring@lfdr.de>; Tue, 26 Mar 2024 19:46:54 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id 6DB4C1F833DD
	for <lists+io-uring@lfdr.de>; Tue, 26 Mar 2024 18:46:54 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 2938513C836;
	Tue, 26 Mar 2024 18:46:29 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel-dk.20230601.gappssmtp.com header.i=@kernel-dk.20230601.gappssmtp.com header.b="Dgh2WF0l"
X-Original-To: io-uring@vger.kernel.org
Received: from mail-pf1-f174.google.com (mail-pf1-f174.google.com [209.85.210.174])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 26A6713CA98
	for <io-uring@vger.kernel.org>; Tue, 26 Mar 2024 18:46:26 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.210.174
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1711478789; cv=none; b=PwpXzilhuqQDN8dIjgnnPSv28uSM+4K8TJnTEoDfuEvWlIHVw8I5ioZI0Pq1gr1uhlaDjJ3KaNGqs/PWQolhr6rszCDkdwp4+PmUDqLP62xQUTC4EluvV/IhMly5SwXh8qme41dfHwEWu3QT/UKn4b47zStBvFPZTRQBlFOlB3Y=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1711478789; c=relaxed/simple;
	bh=nSLlOmzfA7Cm3nJYUHKzPufzNumVqrnn2odB+zqlAmg=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=s9A0VqRxzoNJfRGQfUCljpu/Tom7ZBvCOi/+KRBKokJrf+R5fiB/JgkyNIawyFODNmgD6ZJPve2byEMAJukTZIGV9ok0b8gPslhDMiaYeDdHP8D6/VuE8TuLuB++Dq3Wf1Kkus1pidASqS0cR45IewpelC7D0AM/ma9rF0ZSfU8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=kernel.dk; spf=pass smtp.mailfrom=kernel.dk; dkim=pass (2048-bit key) header.d=kernel-dk.20230601.gappssmtp.com header.i=@kernel-dk.20230601.gappssmtp.com header.b=Dgh2WF0l; arc=none smtp.client-ip=209.85.210.174
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=kernel.dk
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=kernel.dk
Received: by mail-pf1-f174.google.com with SMTP id d2e1a72fcca58-6e694337fffso815464b3a.1
        for <io-uring@vger.kernel.org>; Tue, 26 Mar 2024 11:46:26 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernel-dk.20230601.gappssmtp.com; s=20230601; t=1711478786; x=1712083586; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=oy1+wEsVZVxa1c5Jv66XkxfdSyCZlLPbJeIh1zOl9gM=;
        b=Dgh2WF0lBY+6XYVXp5N+hOdE49Lo2j2i1ILjKBunRxC8xVr5mJzu3yjOVEb8Z1va4y
         XMvo2Agv9xCfZQpDS44yuw4lKq05/+Lvy/sfPP383BBKe14MM9EFq7H22qHD8wlAwla3
         /JDjEsTumBYAGYtIg3YBeCUWKVHL94/78YKYJ4q4/pz27bYUhaSVKLcPuPUENlD4df3h
         EFNArsmFZxYcwoJrhjuEfn8jJENbzq587zxRNzTZLBNLEIeGRUa9wQZNG2KUXdNHnGNE
         sAIVYR8GmBfRun4s8to6L6HCpevN5YBKh+6nCQRTnrQuCLOgHEy0xO7MMZtwN1YKS85f
         vl9g==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1711478786; x=1712083586;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=oy1+wEsVZVxa1c5Jv66XkxfdSyCZlLPbJeIh1zOl9gM=;
        b=opOBieKhN5+aIYJfOAOTk+iELTPXHbAZ9TDklrekvQTZ4/aziKjXqZcLzgEqxqi8o4
         CW9EAGmU0G4Pqe94AP8ccZvDm+l+5p0o9XTgn5TCwIObIYZMjjeoVCDshYdgZkSSJdMW
         o3EEUUWBE8bY3Cv4Yddt4KRbHOYQ267l6cN3cftjuGnWq5FHsAZt6rvkf4ePP1ejE+yY
         bvm8oZXze+iAfkIjsBrUW2uB2Il1TdpdfqklclENN2shTgzhILnMni5nK/b3+1zmmrGM
         7G5N8JX43PYNxqFgen1qokhPasmOu8BAIpSru89E8WEGT35bue2pIohDz2lgAKwbGjfL
         bS4w==
X-Gm-Message-State: AOJu0YzNcjU+ASZLSZwQc91Qovqhm6hrIsl+71LQVT/PliUhtdJ1w67I
	MmH3Cn6WA7eaLllvKyWUHuGhRehIa7hwBPZ6QvQ0qMUs/jiTHPVEs7TrWcUm512CxeR+lHYAorR
	L
X-Google-Smtp-Source: AGHT+IEFLjtQAVpMcxs7TIwWaepF6oirYCWqGvg7aIAUosmhFdSIiK1+p7vmmGvtEAW0rS9/Nv9RPQ==
X-Received: by 2002:a17:902:8a83:b0:1dc:df03:ad86 with SMTP id p3-20020a1709028a8300b001dcdf03ad86mr11781585plo.2.1711478785808;
        Tue, 26 Mar 2024 11:46:25 -0700 (PDT)
Received: from m2max.thefacebook.com ([2620:10d:c090:600::1:163c])
        by smtp.gmail.com with ESMTPSA id lg4-20020a170902fb8400b001dede7dd3c7sm7152833plb.111.2024.03.26.11.46.23
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 26 Mar 2024 11:46:24 -0700 (PDT)
From: Jens Axboe <axboe@kernel.dk>
To: io-uring@vger.kernel.org
Cc: Jens Axboe <axboe@kernel.dk>
Subject: [PATCH 4/4] io_uring: switch normal task_work to io_wq_work_list
Date: Tue, 26 Mar 2024 12:42:48 -0600
Message-ID: <20240326184615.458820-5-axboe@kernel.dk>
X-Mailer: git-send-email 2.43.0
In-Reply-To: <20240326184615.458820-1-axboe@kernel.dk>
References: <20240326184615.458820-1-axboe@kernel.dk>
Precedence: bulk
X-Mailing-List: io-uring@vger.kernel.org
List-Id: <io-uring.vger.kernel.org>
List-Subscribe: <mailto:io-uring+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:io-uring+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

This concludes the transition, now all times of task_work are using the
same mechanism.

Signed-off-by: Jens Axboe <axboe@kernel.dk>
---
 include/linux/io_uring_types.h |  8 ++----
 io_uring/io_uring.c            | 50 ++++++++++++++++++++++------------
 io_uring/io_uring.h            |  4 +--
 io_uring/sqpoll.c              |  8 +++---
 io_uring/tctx.c                |  3 +-
 5 files changed, 43 insertions(+), 30 deletions(-)

diff --git a/include/linux/io_uring_types.h b/include/linux/io_uring_types.h
index 2bc253f8147d..f46f871c09fe 100644
--- a/include/linux/io_uring_types.h
+++ b/include/linux/io_uring_types.h
@@ -95,7 +95,8 @@ struct io_uring_task {
 	struct percpu_counter		inflight;
 
 	struct { /* task_work */
-		struct llist_head	task_list;
+		struct io_wq_work_list	task_list;
+		spinlock_t		task_lock;
 		struct callback_head	task_work;
 	} ____cacheline_aligned_in_smp;
 };
@@ -561,10 +562,7 @@ enum {
 typedef void (*io_req_tw_func_t)(struct io_kiocb *req, struct io_tw_state *ts);
 
 struct io_task_work {
-	union {
-		struct io_wq_work_node		node;
-		struct llist_node		llist_node;
-	};
+	struct io_wq_work_node		node;
 	io_req_tw_func_t		func;
 };
 
diff --git a/io_uring/io_uring.c b/io_uring/io_uring.c
index 8d7138eaa921..e12b518e0b84 100644
--- a/io_uring/io_uring.c
+++ b/io_uring/io_uring.c
@@ -1134,17 +1134,17 @@ static void ctx_flush_and_put(struct io_ring_ctx *ctx, struct io_tw_state *ts)
  * If more entries than max_entries are available, stop processing once this
  * is reached and return the rest of the list.
  */
-struct llist_node *io_handle_tw_list(struct llist_node *node,
-				     unsigned int *count,
-				     unsigned int max_entries)
+struct io_wq_work_node *io_handle_tw_list(struct io_wq_work_node *node,
+					  unsigned int *count,
+					  unsigned int max_entries)
 {
 	struct io_ring_ctx *ctx = NULL;
 	struct io_tw_state ts = { };
 
 	do {
-		struct llist_node *next = node->next;
+		struct io_wq_work_node *next = node->next;
 		struct io_kiocb *req = container_of(node, struct io_kiocb,
-						    io_task_work.llist_node);
+						    io_task_work.node);
 
 		if (req->ctx != ctx) {
 			ctx_flush_and_put(ctx, &ts);
@@ -1170,15 +1170,20 @@ struct llist_node *io_handle_tw_list(struct llist_node *node,
 
 static __cold void io_fallback_tw(struct io_uring_task *tctx, bool sync)
 {
-	struct llist_node *node = llist_del_all(&tctx->task_list);
 	struct io_ring_ctx *last_ctx = NULL;
+	struct io_wq_work_node *node;
 	struct io_kiocb *req;
+	unsigned long flags;
+
+	spin_lock_irqsave(&tctx->task_lock, flags);
+	node = tctx->task_list.first;
+	INIT_WQ_LIST(&tctx->task_list);
+	spin_unlock_irqrestore(&tctx->task_lock, flags);
 
 	while (node) {
-		unsigned long flags;
 		bool do_wake;
 
-		req = container_of(node, struct io_kiocb, io_task_work.llist_node);
+		req = container_of(node, struct io_kiocb, io_task_work.node);
 		node = node->next;
 		if (sync && last_ctx != req->ctx) {
 			if (last_ctx) {
@@ -1202,22 +1207,24 @@ static __cold void io_fallback_tw(struct io_uring_task *tctx, bool sync)
 	}
 }
 
-struct llist_node *tctx_task_work_run(struct io_uring_task *tctx,
-				      unsigned int max_entries,
-				      unsigned int *count)
+struct io_wq_work_node *tctx_task_work_run(struct io_uring_task *tctx,
+					   unsigned int max_entries,
+					   unsigned int *count)
 {
-	struct llist_node *node;
+	struct io_wq_work_node *node;
 
 	if (unlikely(current->flags & PF_EXITING)) {
 		io_fallback_tw(tctx, true);
 		return NULL;
 	}
 
-	node = llist_del_all(&tctx->task_list);
-	if (node) {
-		node = llist_reverse_order(node);
+	spin_lock_irq(&tctx->task_lock);
+	node = tctx->task_list.first;
+	INIT_WQ_LIST(&tctx->task_list);
+	spin_unlock_irq(&tctx->task_lock);
+
+	if (node)
 		node = io_handle_tw_list(node, count, max_entries);
-	}
 
 	/* relaxed read is enough as only the task itself sets ->in_cancel */
 	if (unlikely(atomic_read(&tctx->in_cancel)))
@@ -1229,8 +1236,8 @@ struct llist_node *tctx_task_work_run(struct io_uring_task *tctx,
 
 void tctx_task_work(struct callback_head *cb)
 {
+	struct io_wq_work_node *ret;
 	struct io_uring_task *tctx;
-	struct llist_node *ret;
 	unsigned int count = 0;
 
 	tctx = container_of(cb, struct io_uring_task, task_work);
@@ -1284,9 +1291,16 @@ static void io_req_normal_work_add(struct io_kiocb *req)
 {
 	struct io_uring_task *tctx = req->task->io_uring;
 	struct io_ring_ctx *ctx = req->ctx;
+	unsigned long flags;
+	bool was_empty;
+
+	spin_lock_irqsave(&tctx->task_lock, flags);
+	was_empty = wq_list_empty(&tctx->task_list);
+	wq_list_add_tail(&req->io_task_work.node, &tctx->task_list);
+	spin_unlock_irqrestore(&tctx->task_lock, flags);
 
 	/* task_work already pending, we're done */
-	if (!llist_add(&req->io_task_work.llist_node, &tctx->task_list))
+	if (!was_empty)
 		return;
 
 	if (ctx->flags & IORING_SETUP_TASKRUN_FLAG)
diff --git a/io_uring/io_uring.h b/io_uring/io_uring.h
index bb30a29d0e27..e1582529bc58 100644
--- a/io_uring/io_uring.h
+++ b/io_uring/io_uring.h
@@ -87,8 +87,8 @@ void io_req_task_queue(struct io_kiocb *req);
 void io_req_task_complete(struct io_kiocb *req, struct io_tw_state *ts);
 void io_req_task_queue_fail(struct io_kiocb *req, int ret);
 void io_req_task_submit(struct io_kiocb *req, struct io_tw_state *ts);
-struct llist_node *io_handle_tw_list(struct llist_node *node, unsigned int *count, unsigned int max_entries);
-struct llist_node *tctx_task_work_run(struct io_uring_task *tctx, unsigned int max_entries, unsigned int *count);
+struct io_wq_work_node *io_handle_tw_list(struct io_wq_work_node *node, unsigned int *count, unsigned int max_entries);
+struct io_wq_work_node *tctx_task_work_run(struct io_uring_task *tctx, unsigned int max_entries, unsigned int *count);
 void tctx_task_work(struct callback_head *cb);
 __cold void io_uring_cancel_generic(bool cancel_all, struct io_sq_data *sqd);
 int io_uring_alloc_task_context(struct task_struct *task,
diff --git a/io_uring/sqpoll.c b/io_uring/sqpoll.c
index 3983708cef5b..3a34b867d5c0 100644
--- a/io_uring/sqpoll.c
+++ b/io_uring/sqpoll.c
@@ -230,7 +230,7 @@ static bool io_sqd_handle_event(struct io_sq_data *sqd)
  * than we were asked to process. Newly queued task_work isn't run until the
  * retry list has been fully processed.
  */
-static unsigned int io_sq_tw(struct llist_node **retry_list, int max_entries)
+static unsigned int io_sq_tw(struct io_wq_work_node **retry_list, int max_entries)
 {
 	struct io_uring_task *tctx = current->io_uring;
 	unsigned int count = 0;
@@ -246,11 +246,11 @@ static unsigned int io_sq_tw(struct llist_node **retry_list, int max_entries)
 	return count;
 }
 
-static bool io_sq_tw_pending(struct llist_node *retry_list)
+static bool io_sq_tw_pending(struct io_wq_work_node *retry_list)
 {
 	struct io_uring_task *tctx = current->io_uring;
 
-	return retry_list || !llist_empty(&tctx->task_list);
+	return retry_list || !wq_list_empty(&tctx->task_list);
 }
 
 static void io_sq_update_worktime(struct io_sq_data *sqd, struct rusage *start)
@@ -266,7 +266,7 @@ static void io_sq_update_worktime(struct io_sq_data *sqd, struct rusage *start)
 
 static int io_sq_thread(void *data)
 {
-	struct llist_node *retry_list = NULL;
+	struct io_wq_work_node *retry_list = NULL;
 	struct io_sq_data *sqd = data;
 	struct io_ring_ctx *ctx;
 	struct rusage start;
diff --git a/io_uring/tctx.c b/io_uring/tctx.c
index c043fe93a3f2..9bc0e203b780 100644
--- a/io_uring/tctx.c
+++ b/io_uring/tctx.c
@@ -86,7 +86,8 @@ __cold int io_uring_alloc_task_context(struct task_struct *task,
 	atomic_set(&tctx->in_cancel, 0);
 	atomic_set(&tctx->inflight_tracked, 0);
 	task->io_uring = tctx;
-	init_llist_head(&tctx->task_list);
+	INIT_WQ_LIST(&tctx->task_list);
+	spin_lock_init(&tctx->task_lock);
 	init_task_work(&tctx->task_work, tctx_task_work);
 	return 0;
 }
-- 
2.43.0


