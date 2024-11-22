Return-Path: <io-uring+bounces-4980-lists+io-uring=lfdr.de@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [IPv6:2604:1380:45d1:ec00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 6EBB09D61EC
	for <lists+io-uring@lfdr.de>; Fri, 22 Nov 2024 17:17:53 +0100 (CET)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id 985971615BE
	for <lists+io-uring@lfdr.de>; Fri, 22 Nov 2024 16:17:16 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 0E8A01DF754;
	Fri, 22 Nov 2024 16:17:00 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel-dk.20230601.gappssmtp.com header.i=@kernel-dk.20230601.gappssmtp.com header.b="L47Mc4gE"
X-Original-To: io-uring@vger.kernel.org
Received: from mail-ot1-f41.google.com (mail-ot1-f41.google.com [209.85.210.41])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 66D9D1DF26F
	for <io-uring@vger.kernel.org>; Fri, 22 Nov 2024 16:16:56 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.210.41
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1732292219; cv=none; b=NHMfDmNzYJi2UGbi6S6iUAXmp0eZV11WDVlwAOc6LfJcIXki0ls8tN76xJy+a6jtE4sl0/UQ9oUzVxNpMh2RSIpB7JoYX6VMInODq5hgrzHs/L10Z754Z0wt0oS0KMzVKJ9D+MrNIrxaG4NBzeLLRo94/XTdxJabWGI+xoIIFIQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1732292219; c=relaxed/simple;
	bh=yPILdr0n5a/b/9EBm7Q1Fd6Lbk+fM6gyG8Vf3pHnTKY=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=Uf2egEr6rN+4gUwz6SJjvOpEQi1Pd6xbXZtn/tS+aMv2Ww39SrHPzEEhrk12JNgOFpCdg7tkhEov9KieUF5cPJMKp3HBtdxYNztndwiRhdT2pZMi8rfCyGUXm2Xoex7QdHNrMkDG+J7l36fCW8CpAPed4Tz87R1w3bfRaKIGkuk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=kernel.dk; spf=pass smtp.mailfrom=kernel.dk; dkim=pass (2048-bit key) header.d=kernel-dk.20230601.gappssmtp.com header.i=@kernel-dk.20230601.gappssmtp.com header.b=L47Mc4gE; arc=none smtp.client-ip=209.85.210.41
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=kernel.dk
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=kernel.dk
Received: by mail-ot1-f41.google.com with SMTP id 46e09a7af769-7180a400238so1209256a34.0
        for <io-uring@vger.kernel.org>; Fri, 22 Nov 2024 08:16:56 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernel-dk.20230601.gappssmtp.com; s=20230601; t=1732292215; x=1732897015; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=wwKTUKk4/aeX7Mm0SYUVKtjnKaUfU61dnF7rxZwYaAs=;
        b=L47Mc4gEQp+68IyJiDLDpTbpC+xFPffKzOBgc/CrSuKBjqrLLiVP0Gwq8SxRXHeUzF
         ex8JX0Werr4AE7wXFDnW4IMQPadI8fjc8eCcxVOZAMaAHux+dW7qYQaqwiECwCCW867d
         y0PdtjG1SAqfJfgoxgfLejBidj9Qb0kqUEJOkqncTURIShFmCshzdqQLgxPCwP038K+h
         Gd81fuffdU92KNJfufSQaF++ImClQAz2/xR9VcohMrYfWzGD9spbfM2V5IniEG+bbzs6
         ZUO6U4A2Mdl3FQ2fCK/qnAapIbRKjgjzvQXXviPkfdXtxRt5Lo3RjNVwaUs9ubK0suJl
         PFOw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1732292215; x=1732897015;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=wwKTUKk4/aeX7Mm0SYUVKtjnKaUfU61dnF7rxZwYaAs=;
        b=QLjevgApfKK4WhKSlwTnZ7iJKawNt2if6y+Age9Z7V3ENu65NmOUc/8wBUCDhFpL62
         H0EPZ4PemEtl2+qtiL+vU8LuESNQ6Nqn83gqzf8JyNAhZEnzgPQT1zBq898+J6WyYsAt
         e5y2XzVSOaehFrco1PkisEsXs1DXXkeoyNs9LOyz5PJVSscR1+3/IjUpXt5XtPs2GvZJ
         SkzxGnPupiKI6Ss+BMINPrMK8QpDDFZLTezFCPiPL5u5w8oSM/LOpeKcpY3N8ViwfN8F
         wPUlw0kAqC9u0K0LfhThKgSOko3AfxmsX++RX/SFEZC1+zu6eU+6nZQg57lkp+5vgMC7
         xuFA==
X-Gm-Message-State: AOJu0YxIViwFdAiRffZlRVhFZXc7OcrqXiZK6eIynJuZuQGi3UhaEC7A
	b5h8hKC18EytQoq1O0hAqGUx4gnsC3b4PjfNNSk0bCfZAk95JdN/UkG1V3ZAlRREBfrBd10zuRy
	CWkE=
X-Gm-Gg: ASbGncusedAONf2I7gobry9aVKNIUtU5amEAbUAEySwJYmbEViJ/3ToDx3Mu2sU1C3v
	e7ewpPgXn/Q44+pIwwH09NYSjnO5vZWx8VaDA+s02LMQzNhNMfH+4mWCcLfBoqliqARfErX0uwA
	v/orF+af+wo5W6GAXvXrYoquOb/R1oBVHyJf+aOSEjnyoMSDJT0rZq9ja95iJprSBMCqBu056js
	C2+eme+oEGkPZ4DP8UQ83ferIs/7ljRk2hJDro2VwKKcT/EHw8nSg==
X-Google-Smtp-Source: AGHT+IFkawxGIHMWyQBv3L79mVryWx022uEtQ0eOb20oR0OVb15N0PycLkJRoTVdJSN447mkAoI6RA==
X-Received: by 2002:a05:6830:65cd:b0:718:8ce4:6912 with SMTP id 46e09a7af769-71b0e69c35bmr5646508a34.14.1732292214936;
        Fri, 22 Nov 2024 08:16:54 -0800 (PST)
Received: from localhost.localdomain ([96.43.243.2])
        by smtp.gmail.com with ESMTPSA id 006d021491bc7-5f06976585esm436958eaf.18.2024.11.22.08.16.53
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 22 Nov 2024 08:16:54 -0800 (PST)
From: Jens Axboe <axboe@kernel.dk>
To: io-uring@vger.kernel.org
Cc: Jens Axboe <axboe@kernel.dk>
Subject: [PATCH 4/6] io_uring: switch non-defer task_work to io_wq_work_list
Date: Fri, 22 Nov 2024 09:12:42 -0700
Message-ID: <20241122161645.494868-5-axboe@kernel.dk>
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

Switch the normal task_work to io_wq_work_list as well, to both unify
with defer task_work, but also to avoid needing to reverse the ordering
of the list when running it.

Note that this still keeps the manual retry list for SQPOLL task_work.
That could go away as well, as now the task_work list is fully ordered
and SQPOLL could just leave entries on there when it chops up the
running of the list.

Signed-off-by: Jens Axboe <axboe@kernel.dk>
---
 include/linux/io_uring_types.h |  14 ++-
 io_uring/io_uring.c            | 167 ++++++++++++++++++++-------------
 io_uring/io_uring.h            |   6 +-
 io_uring/sqpoll.c              |   8 +-
 io_uring/tctx.c                |   3 +-
 5 files changed, 116 insertions(+), 82 deletions(-)

diff --git a/include/linux/io_uring_types.h b/include/linux/io_uring_types.h
index e9ba99cb0ed0..7ddac4d1d4b3 100644
--- a/include/linux/io_uring_types.h
+++ b/include/linux/io_uring_types.h
@@ -102,7 +102,8 @@ struct io_uring_task {
 	struct percpu_counter		inflight;
 
 	struct { /* task_work */
-		struct llist_head	task_list;
+		struct io_wq_work_list	task_list;
+		spinlock_t		task_lock;
 		struct callback_head	task_work;
 	} ____cacheline_aligned_in_smp;
 };
@@ -390,8 +391,9 @@ struct io_ring_ctx {
 	struct mm_struct		*mm_account;
 
 	/* ctx exit and cancelation */
-	struct llist_head		fallback_llist;
-	struct delayed_work		fallback_work;
+	struct io_wq_work_list		fallback_list;
+	spinlock_t			fallback_lock;
+	struct work_struct		fallback_work;
 	struct work_struct		exit_work;
 	struct list_head		tctx_list;
 	struct completion		ref_comp;
@@ -567,11 +569,7 @@ enum {
 typedef void (*io_req_tw_func_t)(struct io_kiocb *req, struct io_tw_state *ts);
 
 struct io_task_work {
-	/* DEFER_TASKRUN uses work_node, regular task_work node */
-	union {
-		struct io_wq_work_node	work_node;
-		struct llist_node	node;
-	};
+	struct io_wq_work_node		node;
 	io_req_tw_func_t		func;
 };
 
diff --git a/io_uring/io_uring.c b/io_uring/io_uring.c
index b7eb962e9872..3bb93c77ac3f 100644
--- a/io_uring/io_uring.c
+++ b/io_uring/io_uring.c
@@ -245,15 +245,26 @@ static __cold void io_ring_ctx_ref_free(struct percpu_ref *ref)
 static __cold void io_fallback_req_func(struct work_struct *work)
 {
 	struct io_ring_ctx *ctx = container_of(work, struct io_ring_ctx,
-						fallback_work.work);
-	struct llist_node *node = llist_del_all(&ctx->fallback_llist);
-	struct io_kiocb *req, *tmp;
+						fallback_work);
+	struct io_wq_work_node *node;
 	struct io_tw_state ts = {};
+	struct io_wq_work_list list;
+
+	spin_lock_irq(&ctx->fallback_lock);
+	list = ctx->fallback_list;
+	INIT_WQ_LIST(&ctx->fallback_list);
+	spin_unlock_irq(&ctx->fallback_lock);
 
 	percpu_ref_get(&ctx->refs);
 	mutex_lock(&ctx->uring_lock);
-	llist_for_each_entry_safe(req, tmp, node, io_task_work.node)
+	node = list.first;
+	while (node) {
+		struct io_kiocb *req;
+
+		req = container_of(node, struct io_kiocb, io_task_work.node);
+		node = node->next;
 		req->io_task_work.func(req, &ts);
+	}
 	io_submit_flush_completions(ctx);
 	mutex_unlock(&ctx->uring_lock);
 	percpu_ref_put(&ctx->refs);
@@ -347,7 +358,9 @@ static __cold struct io_ring_ctx *io_ring_ctx_alloc(struct io_uring_params *p)
 #ifdef CONFIG_FUTEX
 	INIT_HLIST_HEAD(&ctx->futex_list);
 #endif
-	INIT_DELAYED_WORK(&ctx->fallback_work, io_fallback_req_func);
+	INIT_WORK(&ctx->fallback_work, io_fallback_req_func);
+	INIT_WQ_LIST(&ctx->fallback_list);
+	spin_lock_init(&ctx->fallback_lock);
 	INIT_WQ_LIST(&ctx->submit_state.compl_reqs);
 	INIT_HLIST_HEAD(&ctx->cancelable_uring_cmd);
 	io_napi_init(ctx);
@@ -1033,15 +1046,15 @@ static void ctx_flush_and_put(struct io_ring_ctx *ctx, struct io_tw_state *ts)
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
 						    io_task_work.node);
 
@@ -1067,55 +1080,84 @@ struct llist_node *io_handle_tw_list(struct llist_node *node,
 	return node;
 }
 
-static __cold void __io_fallback_tw(struct io_kiocb *req, bool sync,
-				    struct io_ring_ctx **last_ctx)
+static __cold void __io_fallback_schedule(struct io_ring_ctx *ctx,
+					  struct io_wq_work_list *list,
+					  bool sync)
 {
-	if (sync && *last_ctx != req->ctx) {
-		if (*last_ctx) {
-			flush_delayed_work(&(*last_ctx)->fallback_work);
-			percpu_ref_put(&(*last_ctx)->refs);
-		}
-		*last_ctx = req->ctx;
-		percpu_ref_get(&(*last_ctx)->refs);
-	}
-	if (llist_add(&req->io_task_work.node, &req->ctx->fallback_llist))
-		schedule_delayed_work(&req->ctx->fallback_work, 1);
+	bool kick_work = true;
+	unsigned long flags;
+
+	spin_lock_irqsave(&ctx->fallback_lock, flags);
+	kick_work = !wq_list_splice_list(list, &ctx->fallback_list);
+	spin_unlock_irqrestore(&ctx->fallback_lock, flags);
+	if (kick_work)
+		schedule_work(&ctx->fallback_work);
+
+	if (sync)
+		flush_work(&ctx->fallback_work);
+	percpu_ref_put(&ctx->refs);
 }
 
-static void io_fallback_tw(struct io_uring_task *tctx, bool sync)
+static void __io_fallback_tw(struct io_wq_work_list *list, spinlock_t *lock,
+			     bool sync)
 {
-	struct llist_node *node = llist_del_all(&tctx->task_list);
+	struct io_wq_work_list local_list, ctx_list;
 	struct io_ring_ctx *last_ctx = NULL;
+	struct io_wq_work_node *node;
 	struct io_kiocb *req;
+	unsigned long flags;
+
+	spin_lock_irqsave(lock, flags);
+	local_list = *list;
+	INIT_WQ_LIST(list);
+	spin_unlock_irqrestore(lock, flags);
 
+	INIT_WQ_LIST(&ctx_list);
+	node = local_list.first;
 	while (node) {
+		struct io_wq_work_node *next = node->next;
+
 		req = container_of(node, struct io_kiocb, io_task_work.node);
-		node = node->next;
-		__io_fallback_tw(req, sync, &last_ctx);
+		if (last_ctx != req->ctx) {
+			if (last_ctx)
+				__io_fallback_schedule(last_ctx, &ctx_list, sync);
+			last_ctx = req->ctx;
+			percpu_ref_get(&last_ctx->refs);
+		}
+		wq_list_add_tail(node, &ctx_list);
+		node = next;
 	}
 
-	if (last_ctx) {
-		flush_delayed_work(&last_ctx->fallback_work);
-		percpu_ref_put(&last_ctx->refs);
-	}
+	if (last_ctx)
+		__io_fallback_schedule(last_ctx, &ctx_list, sync);
+}
+
+static void io_fallback_tw(struct io_uring_task *tctx, bool sync)
+{
+	__io_fallback_tw(&tctx->task_list, &tctx->task_lock, sync);
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
+	if (!READ_ONCE(tctx->task_list.first))
+		return NULL;
+
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
@@ -1128,13 +1170,11 @@ struct llist_node *tctx_task_work_run(struct io_uring_task *tctx,
 void tctx_task_work(struct callback_head *cb)
 {
 	struct io_uring_task *tctx;
-	struct llist_node *ret;
 	unsigned int count = 0;
 
 	tctx = container_of(cb, struct io_uring_task, task_work);
-	ret = tctx_task_work_run(tctx, UINT_MAX, &count);
-	/* can't happen */
-	WARN_ON_ONCE(ret);
+	if (tctx_task_work_run(tctx, UINT_MAX, &count))
+		WARN_ON_ONCE(1);
 }
 
 static inline void io_req_local_work_add(struct io_kiocb *req,
@@ -1155,7 +1195,7 @@ static inline void io_req_local_work_add(struct io_kiocb *req,
 		tw_flags &= ~IOU_F_TWQ_LAZY_WAKE;
 
 	spin_lock_irqsave(&ctx->work_lock, flags);
-	wq_list_add_tail(&req->io_task_work.work_node, &ctx->work_list);
+	wq_list_add_tail(&req->io_task_work.node, &ctx->work_list);
 	nr_tw_prev = ctx->work_items++;
 	spin_unlock_irqrestore(&ctx->work_lock, flags);
 
@@ -1192,9 +1232,16 @@ static void io_req_normal_work_add(struct io_kiocb *req)
 {
 	struct io_uring_task *tctx = req->tctx;
 	struct io_ring_ctx *ctx = req->ctx;
+	unsigned long flags;
+	bool was_empty;
+
+	spin_lock_irqsave(&tctx->task_lock, flags);
+	was_empty = tctx->task_list.first == NULL;
+	wq_list_add_tail(&req->io_task_work.node, &tctx->task_list);
+	spin_unlock_irqrestore(&tctx->task_lock, flags);
 
 	/* task_work already pending, we're done */
-	if (!llist_add(&req->io_task_work.node, &tctx->task_list))
+	if (!was_empty)
 		return;
 
 	if (ctx->flags & IORING_SETUP_TASKRUN_FLAG)
@@ -1233,27 +1280,13 @@ void io_req_task_work_add_remote(struct io_kiocb *req, struct io_ring_ctx *ctx,
 
 static void __cold io_move_task_work_from_local(struct io_ring_ctx *ctx)
 {
-	struct io_ring_ctx *last_ctx = NULL;
-	struct io_wq_work_node *node;
-	unsigned long flags;
-
-	spin_lock_irqsave(&ctx->work_lock, flags);
-	node = ctx->work_list.first;
-	INIT_WQ_LIST(&ctx->work_list);
-	ctx->work_items = 0;
-	spin_unlock_irqrestore(&ctx->work_lock, flags);
-
-	while (node) {
-		struct io_kiocb *req;
-
-		req = container_of(node, struct io_kiocb, io_task_work.work_node);
-		node = node->next;
-		__io_fallback_tw(req, false, &last_ctx);
-	}
-	if (last_ctx) {
-		flush_delayed_work(&last_ctx->fallback_work);
-		percpu_ref_put(&last_ctx->refs);
-	}
+	/*
+	 * __io_fallback_tw() handles lists that can have multiple
+	 * rings in it, which isn't the case here. But it'll work just
+	 * fine, so use it anyway rather than have a special case for
+	 * just a single ctx.
+	 */
+	__io_fallback_tw(&ctx->work_list, &ctx->work_lock, false);
 }
 
 static bool io_run_local_work_continue(struct io_ring_ctx *ctx, int events,
@@ -1292,7 +1325,7 @@ static int __io_run_local_work(struct io_ring_ctx *ctx, struct io_tw_state *ts,
 
 	while (node) {
 		struct io_kiocb *req = container_of(node, struct io_kiocb,
-						    io_task_work.work_node);
+						    io_task_work.node);
 		node = node->next;
 		INDIRECT_CALL_2(req->io_task_work.func,
 				io_poll_task_func, io_req_rw_complete,
@@ -2967,7 +3000,7 @@ static __cold void io_ring_ctx_wait_and_kill(struct io_ring_ctx *ctx)
 		io_unregister_personality(ctx, index);
 	mutex_unlock(&ctx->uring_lock);
 
-	flush_delayed_work(&ctx->fallback_work);
+	flush_work(&ctx->fallback_work);
 
 	INIT_WORK(&ctx->exit_work, io_ring_exit_work);
 	/*
@@ -3106,7 +3139,7 @@ static __cold bool io_uring_try_cancel_requests(struct io_ring_ctx *ctx,
 	if (tctx)
 		ret |= io_run_task_work() > 0;
 	else
-		ret |= flush_delayed_work(&ctx->fallback_work);
+		ret |= flush_work(&ctx->fallback_work);
 	return ret;
 }
 
diff --git a/io_uring/io_uring.h b/io_uring/io_uring.h
index 2fae27803116..0b5181b128aa 100644
--- a/io_uring/io_uring.h
+++ b/io_uring/io_uring.h
@@ -91,8 +91,10 @@ void io_req_task_queue(struct io_kiocb *req);
 void io_req_task_complete(struct io_kiocb *req, struct io_tw_state *ts);
 void io_req_task_queue_fail(struct io_kiocb *req, int ret);
 void io_req_task_submit(struct io_kiocb *req, struct io_tw_state *ts);
-struct llist_node *io_handle_tw_list(struct llist_node *node, unsigned int *count, unsigned int max_entries);
-struct llist_node *tctx_task_work_run(struct io_uring_task *tctx, unsigned int max_entries, unsigned int *count);
+struct io_wq_work_node *io_handle_tw_list(struct io_wq_work_node *node,
+	unsigned int *count, unsigned int max_entries);
+struct io_wq_work_node *tctx_task_work_run(struct io_uring_task *tctx,
+	unsigned int max_entries, unsigned int *count);
 void tctx_task_work(struct callback_head *cb);
 __cold void io_uring_cancel_generic(bool cancel_all, struct io_sq_data *sqd);
 int io_uring_alloc_task_context(struct task_struct *task,
diff --git a/io_uring/sqpoll.c b/io_uring/sqpoll.c
index 6df5e649c413..615707260f25 100644
--- a/io_uring/sqpoll.c
+++ b/io_uring/sqpoll.c
@@ -221,7 +221,7 @@ static bool io_sqd_handle_event(struct io_sq_data *sqd)
  * than we were asked to process. Newly queued task_work isn't run until the
  * retry list has been fully processed.
  */
-static unsigned int io_sq_tw(struct llist_node **retry_list, int max_entries)
+static unsigned int io_sq_tw(struct io_wq_work_node **retry_list, int max_entries)
 {
 	struct io_uring_task *tctx = current->io_uring;
 	unsigned int count = 0;
@@ -239,11 +239,11 @@ static unsigned int io_sq_tw(struct llist_node **retry_list, int max_entries)
 	return count;
 }
 
-static bool io_sq_tw_pending(struct llist_node *retry_list)
+static bool io_sq_tw_pending(struct io_wq_work_node *retry_list)
 {
 	struct io_uring_task *tctx = current->io_uring;
 
-	return retry_list || !llist_empty(&tctx->task_list);
+	return retry_list || READ_ONCE(tctx->task_list.first);
 }
 
 static void io_sq_update_worktime(struct io_sq_data *sqd, struct rusage *start)
@@ -259,7 +259,7 @@ static void io_sq_update_worktime(struct io_sq_data *sqd, struct rusage *start)
 
 static int io_sq_thread(void *data)
 {
-	struct llist_node *retry_list = NULL;
+	struct io_wq_work_node *retry_list = NULL;
 	struct io_sq_data *sqd = data;
 	struct io_ring_ctx *ctx;
 	struct rusage start;
diff --git a/io_uring/tctx.c b/io_uring/tctx.c
index 503f3ff8bc4f..7155b3c56c85 100644
--- a/io_uring/tctx.c
+++ b/io_uring/tctx.c
@@ -87,7 +87,8 @@ __cold int io_uring_alloc_task_context(struct task_struct *task,
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
2.45.2


