Return-Path: <io-uring+bounces-6591-lists+io-uring=lfdr.de@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from sy.mirrors.kernel.org (sy.mirrors.kernel.org [147.75.48.161])
	by mail.lfdr.de (Postfix) with ESMTPS id 1E6D7A3EBD5
	for <lists+io-uring@lfdr.de>; Fri, 21 Feb 2025 05:27:17 +0100 (CET)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sy.mirrors.kernel.org (Postfix) with ESMTPS id B848B7A257C
	for <lists+io-uring@lfdr.de>; Fri, 21 Feb 2025 04:26:17 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 6B22D1FBC8C;
	Fri, 21 Feb 2025 04:26:58 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="mS4bABxB"
X-Original-To: io-uring@vger.kernel.org
Received: from mail-pl1-f177.google.com (mail-pl1-f177.google.com [209.85.214.177])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id AAD913C3C;
	Fri, 21 Feb 2025 04:26:56 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.214.177
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1740112018; cv=none; b=rXuPs+/C3nJlRvgTNjIDGUzP7N8BKlGPeE5VphQKt7mSPWLLlk+3zGSyeGdCZ4qfNof+zX9kz+L7IBe4PH647O2VM2DKjWjnNQ7vQpsbTYTRrxJtRdX2S6uxYSiYFACMyeyWMOznUf1z9EyF1+eerVEec/g7ELqqJUBa7UUXUIo=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1740112018; c=relaxed/simple;
	bh=Ea4219ooDO1EniOFkCiKof+gI8YN40VRM+J6vw4MEPw=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=rMTPsI/fRrGBD6w21IywETPLzKbhxAEiQnbAZrZGV8gRl6pxpdvBpy6AXtMSD66aeoFH80RgNnPwUeEGxRm/86XN7Ybtxzm3M3zhV/2Y7TV0wWtVihJTmPueG0CfYMJTLO21bPr8QovNFSbAkZ6pjx9GBnYV/J7onCHS9/OEzOo=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=mS4bABxB; arc=none smtp.client-ip=209.85.214.177
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Received: by mail-pl1-f177.google.com with SMTP id d9443c01a7336-2212a930001so44918435ad.0;
        Thu, 20 Feb 2025 20:26:56 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1740112015; x=1740716815; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=SjEhKfycrLbgv/538+UuibgLqcEAOguZ+J6XiO5Q9OQ=;
        b=mS4bABxBKRGhS+MC4vEAhiGQdeZZ+VjDdUVPv8D74pw1i/UEXJqFpr8vV8Oui6knWo
         4DXFI06MyqWt8PsG+LL/zlCB2MLgSx/5UgrvkSbxuiw2i7yO/NitTDaXxG0kYVT0j95m
         NreM0s3zdgVx4UrRyc4EH65BBxWg9zTzUZofz6CdtaelJ9MmXi6Nuq54or9KmHgpkr8k
         aP2zQ1+GRGT3xB4zbir9WwXak2zItHHsA/UWkkcodtfnK3tV2VGGgTokYL27HftS37Br
         idshkYh9nAxgwKJ96D53x+QKdKZYKvTr3T/42bT+E4yxRtsnzzX3V6ZfOw4ynuuMB2p6
         KNcA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1740112015; x=1740716815;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=SjEhKfycrLbgv/538+UuibgLqcEAOguZ+J6XiO5Q9OQ=;
        b=PVH4paUtD0dpM769oLGJ2e2T6PGbhHYCHJpfGhryT8WSgpiqcX9ZqxswoNnyfvJ1AV
         qEdtoG0+yHHUK8B3HBZi04FQ8VNlwrHAfobXnEyJxGE9n3yrgIxkFHYB2x9VjlEyAXiK
         OCBoFVhXZhG3uYI11Eh2X8o/b0m39CYDbxY8Zbsv9IiHOa9zMZGLCwNeV0pg+RiGRpjn
         pT/OfWwCOHWz9Z3KhV/76hZaC4NsdxzODbFuAl2+x9RqKMGFGHkXQ0JL7gcXp4eizgyo
         XtWacVPZiNz8kgHbN8JjGsDqkhfotvegxmzbaaaGxS9P+IpsRnSt0pbxIARZBlZ/wyRJ
         OtUA==
X-Forwarded-Encrypted: i=1; AJvYcCVyA4S8yTo0O4TeaXLflFnsx/GZpA/UeNrJjlZ5KjHbfjMQ2phPUMovG+A/oq6ktoA0TDIDPK+aQF4HX60=@vger.kernel.org
X-Gm-Message-State: AOJu0YzBM79OA45LXrekX3PG7SzAEAxedqiD5JoANzio0RssFtuEO5sS
	KyV5F/BtHTsZctnwhTUbrDRHOC2RrsbtrBnHoCNt7wr3qGi9FGlB4vTuvA==
X-Gm-Gg: ASbGncvnDzj9E3oOTpMkf6/AsnKVNG6tKVzgbpz9t4BE4iE8takHb/PiXxd2VxcPaHB
	gwWfBWAgu1jotBb/dRxBQfpeyk6fYQVDPIl4Cg7TBEK2Wt/rsolagD+cauuDi9CJQPs/BZs+Yxz
	RMwpvlXzRdca9VwWJtB+D9Ywy0x+i73P73FpPHvmLaOFqkcPwvOnMr1IP2ahDeNtmkhmwjhQ/ib
	pGgbF2+7Cd7gTcinTwprPaYbedyc99GoaYJDdPagYac1JwPTXymrRAq5ZDztCdrfOiXZ8271BRx
	Uu4NjpJfkPmgq24vkjOYNsYTPp3l
X-Google-Smtp-Source: AGHT+IGDa9dcAoo53tWGxA2n0P8xfbUvjODqYi+UtqbBATdXkzff0z9b96ewC3YeMOc/Lth5/IBvOw==
X-Received: by 2002:a17:902:cecc:b0:210:f706:dc4b with SMTP id d9443c01a7336-221a0ed71c5mr19103545ad.13.1740112015541;
        Thu, 20 Feb 2025 20:26:55 -0800 (PST)
Received: from minh.. ([2001:ee0:4f4d:ece0:cdf5:64ad:9d8c:d0ba])
        by smtp.googlemail.com with ESMTPSA id d9443c01a7336-220d5586080sm128162165ad.229.2025.02.20.20.26.53
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 20 Feb 2025 20:26:55 -0800 (PST)
From: Bui Quang Minh <minhquangbui99@gmail.com>
To: io-uring@vger.kernel.org
Cc: Jens Axboe <axboe@kernel.dk>,
	Pavel Begunkov <asml.silence@gmail.com>,
	linux-kernel@vger.kernel.org,
	Bui Quang Minh <minhquangbui99@gmail.com>
Subject: [RFC PATCH 2/2] io_uring/io-wq: try to batch multiple free work
Date: Fri, 21 Feb 2025 11:19:26 +0700
Message-ID: <20250221041927.8470-3-minhquangbui99@gmail.com>
X-Mailer: git-send-email 2.43.0
In-Reply-To: <20250221041927.8470-1-minhquangbui99@gmail.com>
References: <20250221041927.8470-1-minhquangbui99@gmail.com>
Precedence: bulk
X-Mailing-List: io-uring@vger.kernel.org
List-Id: <io-uring.vger.kernel.org>
List-Subscribe: <mailto:io-uring+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:io-uring+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

Currently, in case we don't use IORING_SETUP_DEFER_TASKRUN, when io
worker frees work, it needs to add a task work. This creates contention
on tctx->task_list. With this commit, io work queues free work on a
local list and batch multiple free work in one call when the number of
free work in local list exceeds IO_REQ_ALLOC_BATCH.

Signed-off-by: Bui Quang Minh <minhquangbui99@gmail.com>
---
 io_uring/io-wq.c    | 62 +++++++++++++++++++++++++++++++++++++++++++--
 io_uring/io-wq.h    |  4 ++-
 io_uring/io_uring.c | 23 ++++++++++++++---
 io_uring/io_uring.h |  6 ++++-
 4 files changed, 87 insertions(+), 8 deletions(-)

diff --git a/io_uring/io-wq.c b/io_uring/io-wq.c
index 5d0928f37471..096711707db9 100644
--- a/io_uring/io-wq.c
+++ b/io_uring/io-wq.c
@@ -544,6 +544,20 @@ static void io_assign_current_work(struct io_worker *worker,
 	raw_spin_unlock(&worker->lock);
 }
 
+static void flush_req_free_list(struct llist_head *free_list,
+				struct llist_node *tail)
+{
+	struct io_kiocb *first_req, *last_req;
+
+	first_req = container_of(free_list->first, struct io_kiocb,
+				 io_task_work.node);
+	last_req = container_of(tail, struct io_kiocb,
+				io_task_work.node);
+
+	io_req_normal_work_add(first_req, last_req);
+	init_llist_head(free_list);
+}
+
 /*
  * Called with acct->lock held, drops it before returning
  */
@@ -553,6 +567,10 @@ static void io_worker_handle_work(struct io_wq_acct *acct,
 {
 	struct io_wq *wq = worker->wq;
 	bool do_kill = test_bit(IO_WQ_BIT_EXIT, &wq->state);
+	LLIST_HEAD(free_list);
+	int free_req = 0;
+	struct llist_node *tail = NULL;
+	struct io_ring_ctx *last_added_ctx = NULL;
 
 	do {
 		struct io_wq_work *work;
@@ -592,6 +610,9 @@ static void io_worker_handle_work(struct io_wq_acct *acct,
 		do {
 			struct io_wq_work *next_hashed, *linked;
 			unsigned int hash = io_get_work_hash(work);
+			struct io_kiocb *req = container_of(work,
+						struct io_kiocb, work);
+			bool did_free = false;
 
 			next_hashed = wq_next_work(work);
 
@@ -601,7 +622,41 @@ static void io_worker_handle_work(struct io_wq_acct *acct,
 			wq->do_work(work);
 			io_assign_current_work(worker, NULL);
 
-			linked = wq->free_work(work);
+			/*
+			 * All requests in free list must have the same
+			 * io_ring_ctx.
+			 */
+			if (last_added_ctx && last_added_ctx != req->ctx) {
+				flush_req_free_list(&free_list, tail);
+				tail = NULL;
+				last_added_ctx = NULL;
+				free_req = 0;
+			}
+
+			/*
+			 * Try to batch free work when
+			 * !IORING_SETUP_DEFER_TASKRUN to reduce contention
+			 * on tctx->task_list.
+			 */
+			if (req->ctx->flags & IORING_SETUP_DEFER_TASKRUN)
+				linked = wq->free_work(work, NULL, NULL);
+			else
+				linked = wq->free_work(work, &free_list, &did_free);
+
+			if (did_free) {
+				if (!tail)
+					tail = free_list.first;
+
+				last_added_ctx = req->ctx;
+				free_req++;
+				if (free_req == IO_REQ_ALLOC_BATCH) {
+					flush_req_free_list(&free_list, tail);
+					tail = NULL;
+					last_added_ctx = NULL;
+					free_req = 0;
+				}
+			}
+
 			work = next_hashed;
 			if (!work && linked && !io_wq_is_hashed(linked)) {
 				work = linked;
@@ -626,6 +681,9 @@ static void io_worker_handle_work(struct io_wq_acct *acct,
 			break;
 		raw_spin_lock(&acct->lock);
 	} while (1);
+
+	if (free_list.first)
+		flush_req_free_list(&free_list, tail);
 }
 
 static int io_wq_worker(void *data)
@@ -899,7 +957,7 @@ static void io_run_cancel(struct io_wq_work *work, struct io_wq *wq)
 	do {
 		atomic_or(IO_WQ_WORK_CANCEL, &work->flags);
 		wq->do_work(work);
-		work = wq->free_work(work);
+		work = wq->free_work(work, NULL, NULL);
 	} while (work);
 }
 
diff --git a/io_uring/io-wq.h b/io_uring/io-wq.h
index b3b004a7b625..4f1674d3d68e 100644
--- a/io_uring/io-wq.h
+++ b/io_uring/io-wq.h
@@ -21,7 +21,9 @@ enum io_wq_cancel {
 	IO_WQ_CANCEL_NOTFOUND,	/* work not found */
 };
 
-typedef struct io_wq_work *(free_work_fn)(struct io_wq_work *);
+typedef struct io_wq_work *(free_work_fn)(struct io_wq_work *,
+					  struct llist_head *,
+					  bool *did_free);
 typedef void (io_wq_work_fn)(struct io_wq_work *);
 
 struct io_wq_hash {
diff --git a/io_uring/io_uring.c b/io_uring/io_uring.c
index 0c111f7d7832..0343c9ec7271 100644
--- a/io_uring/io_uring.c
+++ b/io_uring/io_uring.c
@@ -120,7 +120,6 @@
 #define IO_TCTX_REFS_CACHE_NR	(1U << 10)
 
 #define IO_COMPL_BATCH			32
-#define IO_REQ_ALLOC_BATCH		8
 #define IO_LOCAL_TW_DEFAULT_MAX		20
 
 struct io_defer_entry {
@@ -985,13 +984,18 @@ __cold bool __io_alloc_req_refill(struct io_ring_ctx *ctx)
 	return true;
 }
 
-__cold void io_free_req(struct io_kiocb *req)
+static __cold void io_set_req_free(struct io_kiocb *req)
 {
 	/* refs were already put, restore them for io_req_task_complete() */
 	req->flags &= ~REQ_F_REFCOUNT;
 	/* we only want to free it, don't post CQEs */
 	req->flags |= REQ_F_CQE_SKIP;
 	req->io_task_work.func = io_req_task_complete;
+}
+
+__cold void io_free_req(struct io_kiocb *req)
+{
+	io_set_req_free(req);
 	io_req_task_work_add(req);
 }
 
@@ -1772,16 +1776,27 @@ int io_poll_issue(struct io_kiocb *req, struct io_tw_state *ts)
 				 IO_URING_F_COMPLETE_DEFER);
 }
 
-struct io_wq_work *io_wq_free_work(struct io_wq_work *work)
+struct io_wq_work *io_wq_free_work(struct io_wq_work *work,
+				   struct llist_head *free_list,
+				   bool *did_free)
 {
 	struct io_kiocb *req = container_of(work, struct io_kiocb, work);
 	struct io_kiocb *nxt = NULL;
+	bool free_req = false;
 
 	if (req_ref_put_and_test(req)) {
 		if (req->flags & IO_REQ_LINK_FLAGS)
 			nxt = io_req_find_next(req);
-		io_free_req(req);
+		io_set_req_free(req);
+		if (free_list)
+			__llist_add(&req->io_task_work.node, free_list);
+		else
+			io_req_task_work_add(req);
+		free_req = true;
 	}
+	if (did_free)
+		*did_free = free_req;
+
 	return nxt ? &nxt->work : NULL;
 }
 
diff --git a/io_uring/io_uring.h b/io_uring/io_uring.h
index bdd6407c14d0..dc050bc44b65 100644
--- a/io_uring/io_uring.h
+++ b/io_uring/io_uring.h
@@ -54,6 +54,8 @@ struct io_wait_queue {
 #endif
 };
 
+#define IO_REQ_ALLOC_BATCH	8
+
 static inline bool io_should_wake(struct io_wait_queue *iowq)
 {
 	struct io_ring_ctx *ctx = iowq->ctx;
@@ -111,7 +113,9 @@ int io_submit_sqes(struct io_ring_ctx *ctx, unsigned int nr);
 int io_do_iopoll(struct io_ring_ctx *ctx, bool force_nonspin);
 void __io_submit_flush_completions(struct io_ring_ctx *ctx);
 
-struct io_wq_work *io_wq_free_work(struct io_wq_work *work);
+struct io_wq_work *io_wq_free_work(struct io_wq_work *work,
+				   struct llist_head *free_req,
+				   bool *did_free);
 void io_wq_submit_work(struct io_wq_work *work);
 
 void io_free_req(struct io_kiocb *req);
-- 
2.43.0


