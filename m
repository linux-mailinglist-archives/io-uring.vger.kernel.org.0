Return-Path: <io-uring+bounces-6348-lists+io-uring=lfdr.de@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [139.178.88.99])
	by mail.lfdr.de (Postfix) with ESMTPS id D4F3CA3181D
	for <lists+io-uring@lfdr.de>; Tue, 11 Feb 2025 22:46:32 +0100 (CET)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id E9B383A6793
	for <lists+io-uring@lfdr.de>; Tue, 11 Feb 2025 21:46:11 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 4DB6E267706;
	Tue, 11 Feb 2025 21:46:16 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=purestorage.com header.i=@purestorage.com header.b="XtofYxTk"
X-Original-To: io-uring@vger.kernel.org
Received: from mail-yb1-f227.google.com (mail-yb1-f227.google.com [209.85.219.227])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 840A826770D
	for <io-uring@vger.kernel.org>; Tue, 11 Feb 2025 21:46:13 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.219.227
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1739310376; cv=none; b=Jt7+MkYTCtyhgcts3BbHDt4nduIDwgM+KYyv+2B5ltUYGoTdiGJSCZ5jkz+b0JpMXMKEllPUdaYlEPlFSiUPniUsovHBmr4HSM4Gmz9FHgI80wWsBRFMoheWuZAB/bh6tpIHVw8fnHV9JjidqlPblPzC1HtBkiWK1D3BODH/84c=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1739310376; c=relaxed/simple;
	bh=7Lf6p7N3HlnvQa5JtAb75YT3ak/ha3dmGlp/zQZR2Ps=;
	h=From:To:Cc:Subject:Date:Message-ID:MIME-Version; b=DtPyjC+D3mualp7cdvBo8Fku46CRTt7NIOiuz3kOJuA5XoRF53ddTUGRY2RXu2WeeOlbtelk/v435NFyMCXvsmR+AZyX4ksFcb5rMQLSa2o5+iYakahxw2SDaIWsxOQ2O4NE4rHlEwaSj0judnuzJba6c1XOSseqpN5/nTaOTjk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=purestorage.com; spf=fail smtp.mailfrom=purestorage.com; dkim=pass (2048-bit key) header.d=purestorage.com header.i=@purestorage.com header.b=XtofYxTk; arc=none smtp.client-ip=209.85.219.227
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=purestorage.com
Authentication-Results: smtp.subspace.kernel.org; spf=fail smtp.mailfrom=purestorage.com
Received: by mail-yb1-f227.google.com with SMTP id 3f1490d57ef6-e5b422fa57aso523605276.0
        for <io-uring@vger.kernel.org>; Tue, 11 Feb 2025 13:46:13 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=purestorage.com; s=google2022; t=1739310372; x=1739915172; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:from:to:cc:subject:date:message-id:reply-to;
        bh=nuaCEFbKKBYS818LbmXOKgvG2gzO/8rjG0e2ZaF20S0=;
        b=XtofYxTkCXlq5VOrnR+UCEJ8/WbdCPBU81NersrXgIXKGYPJm6RkBVXwZxbr1rKYOq
         XOg7kH8dnXxGBLRLYlX6PH8nu6kH/Hd0s2r3ceDwkbUQCBP663+7DNeLAI7GvjQbz/iZ
         /5LU73DiyJc4seY2nLP6Ai8+aUF9qqHBQuqorIf/ABX721cDSaZPHJ88e/r/GJ6Sf3Ap
         rao35PCl5SW1c7pc4BHDFhWZx7Oj86RO982fK6+WvZ7gMdTNWzvm/1qCHbcbjgbqgcTg
         N4EqQymK7N4EZk4eTLm+/yvty7sbhOJeSgdcGqsAvgFiG5vrBZmhNUKq3tXq4v1b3xW/
         D98w==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1739310372; x=1739915172;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=nuaCEFbKKBYS818LbmXOKgvG2gzO/8rjG0e2ZaF20S0=;
        b=wrk8jz30bqr3vxHvtjBYrhNeo+bE1b3tPQYuBSYbtNKVaNQwvJz3yIBKetIjIwuEMK
         2pfoVy+B4h6RJmejNet+mdg/Tpx6KSCooIpDcrU51/aSzbVR99SnumtwHhRLIe2OAXCd
         rs52qTNG6aPqkxjevqgaqLYoTePtooSidYIwS5m90Dt3DZRRmaDoJVbkNiath+o2c2Ej
         N7dwZu+fL0ZImDOXvhg5uDYHjVhoitpwiNnSmyAvn2aiUOA4VcVQSjpBPdP86IyJGaD8
         5/gMBLIesI0IKPYY3DeyNDuK+OUjvxCBlm77iWcNyqczDQid3U6QwTPb7ojF2AdjOSlA
         FBpw==
X-Forwarded-Encrypted: i=1; AJvYcCXaoSL7QfU9KjeVvwnWclhv6w6waUQB1Gkq4As5LAn3cA/KImC+liCm1OTXEN2BGlrsPLwGnJufRg==@vger.kernel.org
X-Gm-Message-State: AOJu0Yy593NjvqIziFzw2K8HcgxJ/fIY1xtRLIi1wEZiCowzzebUpYX8
	+PN8/Zkvn0zW+0NgCTFHSUwIy/l8hkjV+S8Em5RnUIn2RYmUanKHzXWrYKbHJe69t1OkZmFk/zi
	t/Z7vLa5MqMHDmtTAXP42eLvBR4geIq+eKcazlxANFj3KC12O
X-Gm-Gg: ASbGnctwa368Q+OQg4iX8VJHLf/O9yhaIKxrkkrGI2akl0FgotJx5qbxxH9TCyQhNf1
	Js//8xVRZrWkA8EjYSfF6o7xFVnD3vFeU6EAbrkCCeXYh3BvUUKVJw+d523PUHYw3fd8D3rVUeC
	6ZeKwvkJQX4bRqwuF5wWwF5QfgxQs6yXVS607HNNsTQCt/Y2Y6y0wPD2xibou6xFo2iV1WFwk+G
	BgxpcZrfClQFV6B8n0J/t9J0lgF6qAfkeuu5gdzaxtz2X3FMUSb7mZlhz3GnycH6VjRTqpzQOmx
	6noSJrLpuMPXT8pMyrAvzJs=
X-Google-Smtp-Source: AGHT+IERSI9Tszr02rK0GAbwnSaYDAExDYQLRTSDc1rq7gIAMgjc+mWLLFwYtmn3gO6I8npsMkZtmc5syEK3
X-Received: by 2002:a05:690c:39b:b0:6e2:ada7:ab3a with SMTP id 00721157ae682-6fb1f263840mr5582507b3.5.1739310372360;
        Tue, 11 Feb 2025 13:46:12 -0800 (PST)
Received: from c7-smtp-2023.dev.purestorage.com ([2620:125:9017:12:36:3:5:0])
        by smtp-relay.gmail.com with ESMTPS id 00721157ae682-6f9a001ece0sm1395867b3.70.2025.02.11.13.46.12
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 11 Feb 2025 13:46:12 -0800 (PST)
X-Relaying-Domain: purestorage.com
Received: from dev-csander.dev.purestorage.com (dev-csander.dev.purestorage.com [10.7.70.37])
	by c7-smtp-2023.dev.purestorage.com (Postfix) with ESMTP id 58A683400C7;
	Tue, 11 Feb 2025 14:46:11 -0700 (MST)
Received: by dev-csander.dev.purestorage.com (Postfix, from userid 1557716354)
	id 4C7D0E40DF3; Tue, 11 Feb 2025 14:45:41 -0700 (MST)
From: Caleb Sander Mateos <csander@purestorage.com>
To: Jens Axboe <axboe@kernel.dk>,
	Pavel Begunkov <asml.silence@gmail.com>
Cc: Caleb Sander Mateos <csander@purestorage.com>,
	io-uring@vger.kernel.org,
	linux-kernel@vger.kernel.org
Subject: [PATCH] io_uring: pass struct io_tw_state by value
Date: Tue, 11 Feb 2025 14:45:32 -0700
Message-ID: <20250211214539.3378714-1-csander@purestorage.com>
X-Mailer: git-send-email 2.45.2
Precedence: bulk
X-Mailing-List: io-uring@vger.kernel.org
List-Id: <io-uring.vger.kernel.org>
List-Subscribe: <mailto:io-uring+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:io-uring+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

8e5b3b89ecaf ("io_uring: remove struct io_tw_state::locked") removed the
only field of io_tw_state but kept it as a task work callback argument
to "forc[e] users not to invoke them carelessly out of a wrong context".
Passing the struct io_tw_state * argument adds a few instructions to all
callers that can't inline the functions and see the argument is unused.

So pass struct io_tw_state by value instead. Since it's a 0-sized value,
it can be passed without any instructions needed to initialize it.

Also add a comment to struct io_tw_state to explain its purpose.

Signed-off-by: Caleb Sander Mateos <csander@purestorage.com>
---
 include/linux/io_uring_types.h |  3 ++-
 io_uring/futex.c               |  6 +++---
 io_uring/io_uring.c            | 30 +++++++++++++++---------------
 io_uring/io_uring.h            |  8 ++++----
 io_uring/msg_ring.c            |  2 +-
 io_uring/notif.c               |  2 +-
 io_uring/poll.c                |  4 ++--
 io_uring/poll.h                |  2 +-
 io_uring/rw.c                  |  2 +-
 io_uring/rw.h                  |  2 +-
 io_uring/timeout.c             |  6 +++---
 io_uring/uring_cmd.c           |  2 +-
 io_uring/waitid.c              |  6 +++---
 13 files changed, 38 insertions(+), 37 deletions(-)

diff --git a/include/linux/io_uring_types.h b/include/linux/io_uring_types.h
index e2fef264ff8b..4abd0299fdfb 100644
--- a/include/linux/io_uring_types.h
+++ b/include/linux/io_uring_types.h
@@ -434,10 +434,11 @@ struct io_ring_ctx {
 	struct io_mapped_region		ring_region;
 	/* used for optimised request parameter and wait argument passing  */
 	struct io_mapped_region		param_region;
 };
 
+/* Token passed to task work callbacks to indicate ctx->uring_lock is held */
 struct io_tw_state {
 };
 
 enum {
 	REQ_F_FIXED_FILE_BIT	= IOSQE_FIXED_FILE_BIT,
@@ -561,11 +562,11 @@ enum {
 	REQ_F_BUF_NODE		= IO_REQ_FLAG(REQ_F_BUF_NODE_BIT),
 	/* request has read/write metadata assigned */
 	REQ_F_HAS_METADATA	= IO_REQ_FLAG(REQ_F_HAS_METADATA_BIT),
 };
 
-typedef void (*io_req_tw_func_t)(struct io_kiocb *req, struct io_tw_state *ts);
+typedef void (*io_req_tw_func_t)(struct io_kiocb *req, struct io_tw_state ts);
 
 struct io_task_work {
 	struct llist_node		node;
 	io_req_tw_func_t		func;
 };
diff --git a/io_uring/futex.c b/io_uring/futex.c
index 54b9760f2aa6..d4f9591c821f 100644
--- a/io_uring/futex.c
+++ b/io_uring/futex.c
@@ -42,29 +42,29 @@ bool io_futex_cache_init(struct io_ring_ctx *ctx)
 void io_futex_cache_free(struct io_ring_ctx *ctx)
 {
 	io_alloc_cache_free(&ctx->futex_cache, kfree);
 }
 
-static void __io_futex_complete(struct io_kiocb *req, struct io_tw_state *ts)
+static void __io_futex_complete(struct io_kiocb *req, struct io_tw_state ts)
 {
 	req->async_data = NULL;
 	hlist_del_init(&req->hash_node);
 	io_req_task_complete(req, ts);
 }
 
-static void io_futex_complete(struct io_kiocb *req, struct io_tw_state *ts)
+static void io_futex_complete(struct io_kiocb *req, struct io_tw_state ts)
 {
 	struct io_futex_data *ifd = req->async_data;
 	struct io_ring_ctx *ctx = req->ctx;
 
 	io_tw_lock(ctx, ts);
 	if (!io_alloc_cache_put(&ctx->futex_cache, ifd))
 		kfree(ifd);
 	__io_futex_complete(req, ts);
 }
 
-static void io_futexv_complete(struct io_kiocb *req, struct io_tw_state *ts)
+static void io_futexv_complete(struct io_kiocb *req, struct io_tw_state ts)
 {
 	struct io_futex *iof = io_kiocb_to_cmd(req, struct io_futex);
 	struct futex_vector *futexv = req->async_data;
 
 	io_tw_lock(req->ctx, ts);
diff --git a/io_uring/io_uring.c b/io_uring/io_uring.c
index ec98a0ec6f34..578f894a3bdb 100644
--- a/io_uring/io_uring.c
+++ b/io_uring/io_uring.c
@@ -252,11 +252,11 @@ static __cold void io_fallback_req_func(struct work_struct *work)
 	struct io_tw_state ts = {};
 
 	percpu_ref_get(&ctx->refs);
 	mutex_lock(&ctx->uring_lock);
 	llist_for_each_entry_safe(req, tmp, node, io_task_work.node)
-		req->io_task_work.func(req, &ts);
+		req->io_task_work.func(req, ts);
 	io_submit_flush_completions(ctx);
 	mutex_unlock(&ctx->uring_lock);
 	percpu_ref_put(&ctx->refs);
 }
 
@@ -540,11 +540,11 @@ static void io_queue_iowq(struct io_kiocb *req)
 	io_wq_enqueue(tctx->io_wq, &req->work);
 	if (link)
 		io_queue_linked_timeout(link);
 }
 
-static void io_req_queue_iowq_tw(struct io_kiocb *req, struct io_tw_state *ts)
+static void io_req_queue_iowq_tw(struct io_kiocb *req, struct io_tw_state ts)
 {
 	io_queue_iowq(req);
 }
 
 void io_req_queue_iowq(struct io_kiocb *req)
@@ -1019,11 +1019,11 @@ static inline struct io_kiocb *io_req_find_next(struct io_kiocb *req)
 	nxt = req->link;
 	req->link = NULL;
 	return nxt;
 }
 
-static void ctx_flush_and_put(struct io_ring_ctx *ctx, struct io_tw_state *ts)
+static void ctx_flush_and_put(struct io_ring_ctx *ctx, struct io_tw_state ts)
 {
 	if (!ctx)
 		return;
 	if (ctx->flags & IORING_SETUP_TASKRUN_FLAG)
 		atomic_andnot(IORING_SQ_TASKRUN, &ctx->rings->sq_flags);
@@ -1049,28 +1049,28 @@ struct llist_node *io_handle_tw_list(struct llist_node *node,
 		struct llist_node *next = node->next;
 		struct io_kiocb *req = container_of(node, struct io_kiocb,
 						    io_task_work.node);
 
 		if (req->ctx != ctx) {
-			ctx_flush_and_put(ctx, &ts);
+			ctx_flush_and_put(ctx, ts);
 			ctx = req->ctx;
 			mutex_lock(&ctx->uring_lock);
 			percpu_ref_get(&ctx->refs);
 		}
 		INDIRECT_CALL_2(req->io_task_work.func,
 				io_poll_task_func, io_req_rw_complete,
-				req, &ts);
+				req, ts);
 		node = next;
 		(*count)++;
 		if (unlikely(need_resched())) {
-			ctx_flush_and_put(ctx, &ts);
+			ctx_flush_and_put(ctx, ts);
 			ctx = NULL;
 			cond_resched();
 		}
 	} while (node && *count < max_entries);
 
-	ctx_flush_and_put(ctx, &ts);
+	ctx_flush_and_put(ctx, ts);
 	return node;
 }
 
 static __cold void __io_fallback_tw(struct llist_node *node, bool sync)
 {
@@ -1274,11 +1274,11 @@ static bool io_run_local_work_continue(struct io_ring_ctx *ctx, int events,
 		atomic_or(IORING_SQ_TASKRUN, &ctx->rings->sq_flags);
 	return false;
 }
 
 static int __io_run_local_work_loop(struct llist_node **node,
-				    struct io_tw_state *ts,
+				    struct io_tw_state ts,
 				    int events)
 {
 	int ret = 0;
 
 	while (*node) {
@@ -1294,11 +1294,11 @@ static int __io_run_local_work_loop(struct llist_node **node,
 	}
 
 	return ret;
 }
 
-static int __io_run_local_work(struct io_ring_ctx *ctx, struct io_tw_state *ts,
+static int __io_run_local_work(struct io_ring_ctx *ctx, struct io_tw_state ts,
 			       int min_events, int max_events)
 {
 	struct llist_node *node;
 	unsigned int loops = 0;
 	int ret = 0;
@@ -1338,33 +1338,33 @@ static inline int io_run_local_work_locked(struct io_ring_ctx *ctx,
 {
 	struct io_tw_state ts = {};
 
 	if (!io_local_work_pending(ctx))
 		return 0;
-	return __io_run_local_work(ctx, &ts, min_events,
+	return __io_run_local_work(ctx, ts, min_events,
 					max(IO_LOCAL_TW_DEFAULT_MAX, min_events));
 }
 
 static int io_run_local_work(struct io_ring_ctx *ctx, int min_events,
 			     int max_events)
 {
 	struct io_tw_state ts = {};
 	int ret;
 
 	mutex_lock(&ctx->uring_lock);
-	ret = __io_run_local_work(ctx, &ts, min_events, max_events);
+	ret = __io_run_local_work(ctx, ts, min_events, max_events);
 	mutex_unlock(&ctx->uring_lock);
 	return ret;
 }
 
-static void io_req_task_cancel(struct io_kiocb *req, struct io_tw_state *ts)
+static void io_req_task_cancel(struct io_kiocb *req, struct io_tw_state ts)
 {
 	io_tw_lock(req->ctx, ts);
 	io_req_defer_failed(req, req->cqe.res);
 }
 
-void io_req_task_submit(struct io_kiocb *req, struct io_tw_state *ts)
+void io_req_task_submit(struct io_kiocb *req, struct io_tw_state ts)
 {
 	io_tw_lock(req->ctx, ts);
 	if (unlikely(io_should_terminate_tw()))
 		io_req_defer_failed(req, -EFAULT);
 	else if (req->flags & REQ_F_FORCE_ASYNC)
@@ -1580,11 +1580,11 @@ static int io_iopoll_check(struct io_ring_ctx *ctx, long min)
 	} while (nr_events < min);
 
 	return 0;
 }
 
-void io_req_task_complete(struct io_kiocb *req, struct io_tw_state *ts)
+void io_req_task_complete(struct io_kiocb *req, struct io_tw_state ts)
 {
 	io_req_complete_defer(req);
 }
 
 /*
@@ -1760,11 +1760,11 @@ static int io_issue_sqe(struct io_kiocb *req, unsigned int issue_flags)
 			io_iopoll_req_issued(req, issue_flags);
 	}
 	return ret;
 }
 
-int io_poll_issue(struct io_kiocb *req, struct io_tw_state *ts)
+int io_poll_issue(struct io_kiocb *req, struct io_tw_state ts)
 {
 	io_tw_lock(req->ctx, ts);
 	return io_issue_sqe(req, IO_URING_F_NONBLOCK|IO_URING_F_MULTISHOT|
 				 IO_URING_F_COMPLETE_DEFER);
 }
diff --git a/io_uring/io_uring.h b/io_uring/io_uring.h
index 85bc8f76ca19..230653b97d12 100644
--- a/io_uring/io_uring.h
+++ b/io_uring/io_uring.h
@@ -88,13 +88,13 @@ struct file *io_file_get_fixed(struct io_kiocb *req, int fd,
 void __io_req_task_work_add(struct io_kiocb *req, unsigned flags);
 void io_req_task_work_add_remote(struct io_kiocb *req, struct io_ring_ctx *ctx,
 				 unsigned flags);
 bool io_alloc_async_data(struct io_kiocb *req);
 void io_req_task_queue(struct io_kiocb *req);
-void io_req_task_complete(struct io_kiocb *req, struct io_tw_state *ts);
+void io_req_task_complete(struct io_kiocb *req, struct io_tw_state ts);
 void io_req_task_queue_fail(struct io_kiocb *req, int ret);
-void io_req_task_submit(struct io_kiocb *req, struct io_tw_state *ts);
+void io_req_task_submit(struct io_kiocb *req, struct io_tw_state ts);
 struct llist_node *io_handle_tw_list(struct llist_node *node, unsigned int *count, unsigned int max_entries);
 struct llist_node *tctx_task_work_run(struct io_uring_task *tctx, unsigned int max_entries, unsigned int *count);
 void tctx_task_work(struct callback_head *cb);
 __cold void io_uring_cancel_generic(bool cancel_all, struct io_sq_data *sqd);
 int io_uring_alloc_task_context(struct task_struct *task,
@@ -102,11 +102,11 @@ int io_uring_alloc_task_context(struct task_struct *task,
 
 int io_ring_add_registered_file(struct io_uring_task *tctx, struct file *file,
 				     int start, int end);
 void io_req_queue_iowq(struct io_kiocb *req);
 
-int io_poll_issue(struct io_kiocb *req, struct io_tw_state *ts);
+int io_poll_issue(struct io_kiocb *req, struct io_tw_state ts);
 int io_submit_sqes(struct io_ring_ctx *ctx, unsigned int nr);
 int io_do_iopoll(struct io_ring_ctx *ctx, bool force_nonspin);
 void __io_submit_flush_completions(struct io_ring_ctx *ctx);
 
 struct io_wq_work *io_wq_free_work(struct io_wq_work *work);
@@ -374,11 +374,11 @@ static inline bool io_local_work_pending(struct io_ring_ctx *ctx)
 static inline bool io_task_work_pending(struct io_ring_ctx *ctx)
 {
 	return task_work_pending(current) || io_local_work_pending(ctx);
 }
 
-static inline void io_tw_lock(struct io_ring_ctx *ctx, struct io_tw_state *ts)
+static inline void io_tw_lock(struct io_ring_ctx *ctx, struct io_tw_state ts)
 {
 	lockdep_assert_held(&ctx->uring_lock);
 }
 
 /*
diff --git a/io_uring/msg_ring.c b/io_uring/msg_ring.c
index 7e6f68e911f1..aae1e7f84615 100644
--- a/io_uring/msg_ring.c
+++ b/io_uring/msg_ring.c
@@ -69,11 +69,11 @@ void io_msg_ring_cleanup(struct io_kiocb *req)
 static inline bool io_msg_need_remote(struct io_ring_ctx *target_ctx)
 {
 	return target_ctx->task_complete;
 }
 
-static void io_msg_tw_complete(struct io_kiocb *req, struct io_tw_state *ts)
+static void io_msg_tw_complete(struct io_kiocb *req, struct io_tw_state ts)
 {
 	struct io_ring_ctx *ctx = req->ctx;
 
 	io_add_aux_cqe(ctx, req->cqe.user_data, req->cqe.res, req->cqe.flags);
 	if (spin_trylock(&ctx->msg_lock)) {
diff --git a/io_uring/notif.c b/io_uring/notif.c
index ee3a33510b3c..c3460b295dcc 100644
--- a/io_uring/notif.c
+++ b/io_uring/notif.c
@@ -9,11 +9,11 @@
 #include "notif.h"
 #include "rsrc.h"
 
 static const struct ubuf_info_ops io_ubuf_ops;
 
-static void io_notif_tw_complete(struct io_kiocb *notif, struct io_tw_state *ts)
+static void io_notif_tw_complete(struct io_kiocb *notif, struct io_tw_state ts)
 {
 	struct io_notif_data *nd = io_notif_to_data(notif);
 
 	do {
 		notif = cmd_to_io_kiocb(nd);
diff --git a/io_uring/poll.c b/io_uring/poll.c
index bb1c0cd4f809..bc5e0125db3f 100644
--- a/io_uring/poll.c
+++ b/io_uring/poll.c
@@ -218,11 +218,11 @@ static inline void io_poll_execute(struct io_kiocb *req, int res)
  * require, which is either spurious wakeup or multishot CQE is served.
  * IOU_POLL_DONE when it's done with the request, then the mask is stored in
  * req->cqe.res. IOU_POLL_REMOVE_POLL_USE_RES indicates to remove multishot
  * poll and that the result is stored in req->cqe.
  */
-static int io_poll_check_events(struct io_kiocb *req, struct io_tw_state *ts)
+static int io_poll_check_events(struct io_kiocb *req, struct io_tw_state ts)
 {
 	int v;
 
 	if (unlikely(io_should_terminate_tw()))
 		return -ECANCELED;
@@ -309,11 +309,11 @@ static int io_poll_check_events(struct io_kiocb *req, struct io_tw_state *ts)
 
 	io_napi_add(req);
 	return IOU_POLL_NO_ACTION;
 }
 
-void io_poll_task_func(struct io_kiocb *req, struct io_tw_state *ts)
+void io_poll_task_func(struct io_kiocb *req, struct io_tw_state ts)
 {
 	int ret;
 
 	ret = io_poll_check_events(req, ts);
 	if (ret == IOU_POLL_NO_ACTION) {
diff --git a/io_uring/poll.h b/io_uring/poll.h
index 04ede93113dc..7825688aab3d 100644
--- a/io_uring/poll.h
+++ b/io_uring/poll.h
@@ -41,6 +41,6 @@ int io_poll_cancel(struct io_ring_ctx *ctx, struct io_cancel_data *cd,
 		   unsigned issue_flags);
 int io_arm_poll_handler(struct io_kiocb *req, unsigned issue_flags);
 bool io_poll_remove_all(struct io_ring_ctx *ctx, struct io_uring_task *tctx,
 			bool cancel_all);
 
-void io_poll_task_func(struct io_kiocb *req, struct io_tw_state *ts);
+void io_poll_task_func(struct io_kiocb *req, struct io_tw_state ts);
diff --git a/io_uring/rw.c b/io_uring/rw.c
index 7aa1e4c9f64a..17f08b3b754f 100644
--- a/io_uring/rw.c
+++ b/io_uring/rw.c
@@ -509,11 +509,11 @@ static inline int io_fixup_rw_res(struct io_kiocb *req, long res)
 			res += io->bytes_done;
 	}
 	return res;
 }
 
-void io_req_rw_complete(struct io_kiocb *req, struct io_tw_state *ts)
+void io_req_rw_complete(struct io_kiocb *req, struct io_tw_state ts)
 {
 	struct io_rw *rw = io_kiocb_to_cmd(req, struct io_rw);
 	struct kiocb *kiocb = &rw->kiocb;
 
 	if ((kiocb->ki_flags & IOCB_DIO_CALLER_COMP) && kiocb->dio_complete) {
diff --git a/io_uring/rw.h b/io_uring/rw.h
index eaa59bd64870..e0c1d760cbc2 100644
--- a/io_uring/rw.h
+++ b/io_uring/rw.h
@@ -37,9 +37,9 @@ int io_prep_read(struct io_kiocb *req, const struct io_uring_sqe *sqe);
 int io_prep_write(struct io_kiocb *req, const struct io_uring_sqe *sqe);
 int io_read(struct io_kiocb *req, unsigned int issue_flags);
 int io_write(struct io_kiocb *req, unsigned int issue_flags);
 void io_readv_writev_cleanup(struct io_kiocb *req);
 void io_rw_fail(struct io_kiocb *req);
-void io_req_rw_complete(struct io_kiocb *req, struct io_tw_state *ts);
+void io_req_rw_complete(struct io_kiocb *req, struct io_tw_state ts);
 int io_read_mshot_prep(struct io_kiocb *req, const struct io_uring_sqe *sqe);
 int io_read_mshot(struct io_kiocb *req, unsigned int issue_flags);
 void io_rw_cache_free(const void *entry);
diff --git a/io_uring/timeout.c b/io_uring/timeout.c
index 48fc8cf70784..31fadd3342a5 100644
--- a/io_uring/timeout.c
+++ b/io_uring/timeout.c
@@ -63,11 +63,11 @@ static inline bool io_timeout_finish(struct io_timeout *timeout,
 	return true;
 }
 
 static enum hrtimer_restart io_timeout_fn(struct hrtimer *timer);
 
-static void io_timeout_complete(struct io_kiocb *req, struct io_tw_state *ts)
+static void io_timeout_complete(struct io_kiocb *req, struct io_tw_state ts)
 {
 	struct io_timeout *timeout = io_kiocb_to_cmd(req, struct io_timeout);
 	struct io_timeout_data *data = req->async_data;
 	struct io_ring_ctx *ctx = req->ctx;
 
@@ -152,11 +152,11 @@ __cold void io_flush_timeouts(struct io_ring_ctx *ctx)
 	ctx->cq_last_tm_flush = seq;
 	raw_spin_unlock_irq(&ctx->timeout_lock);
 	io_flush_killed_timeouts(&list, 0);
 }
 
-static void io_req_tw_fail_links(struct io_kiocb *link, struct io_tw_state *ts)
+static void io_req_tw_fail_links(struct io_kiocb *link, struct io_tw_state ts)
 {
 	io_tw_lock(link->ctx, ts);
 	while (link) {
 		struct io_kiocb *nxt = link->link;
 		long res = -ECANCELED;
@@ -310,11 +310,11 @@ int io_timeout_cancel(struct io_ring_ctx *ctx, struct io_cancel_data *cd)
 		return PTR_ERR(req);
 	io_req_task_queue_fail(req, -ECANCELED);
 	return 0;
 }
 
-static void io_req_task_link_timeout(struct io_kiocb *req, struct io_tw_state *ts)
+static void io_req_task_link_timeout(struct io_kiocb *req, struct io_tw_state ts)
 {
 	struct io_timeout *timeout = io_kiocb_to_cmd(req, struct io_timeout);
 	struct io_kiocb *prev = timeout->prev;
 	int ret;
 
diff --git a/io_uring/uring_cmd.c b/io_uring/uring_cmd.c
index 1f6a82128b47..0a6688b72041 100644
--- a/io_uring/uring_cmd.c
+++ b/io_uring/uring_cmd.c
@@ -103,11 +103,11 @@ void io_uring_cmd_mark_cancelable(struct io_uring_cmd *cmd,
 		io_ring_submit_unlock(ctx, issue_flags);
 	}
 }
 EXPORT_SYMBOL_GPL(io_uring_cmd_mark_cancelable);
 
-static void io_uring_cmd_work(struct io_kiocb *req, struct io_tw_state *ts)
+static void io_uring_cmd_work(struct io_kiocb *req, struct io_tw_state ts)
 {
 	struct io_uring_cmd *ioucmd = io_kiocb_to_cmd(req, struct io_uring_cmd);
 	unsigned int flags = IO_URING_F_COMPLETE_DEFER;
 
 	if (io_should_terminate_tw())
diff --git a/io_uring/waitid.c b/io_uring/waitid.c
index 4fb465b48560..8b2f606b047b 100644
--- a/io_uring/waitid.c
+++ b/io_uring/waitid.c
@@ -14,11 +14,11 @@
 #include "io_uring.h"
 #include "cancel.h"
 #include "waitid.h"
 #include "../kernel/exit.h"
 
-static void io_waitid_cb(struct io_kiocb *req, struct io_tw_state *ts);
+static void io_waitid_cb(struct io_kiocb *req, struct io_tw_state ts);
 
 #define IO_WAITID_CANCEL_FLAG	BIT(31)
 #define IO_WAITID_REF_MASK	GENMASK(30, 0)
 
 struct io_waitid {
@@ -129,11 +129,11 @@ static void io_waitid_complete(struct io_kiocb *req, int ret)
 
 	ret = io_waitid_finish(req, ret);
 	if (ret < 0)
 		req_set_fail(req);
 	io_req_set_res(req, ret, 0);
-	io_req_task_complete(req, &ts);
+	io_req_task_complete(req, ts);
 }
 
 static bool __io_waitid_cancel(struct io_kiocb *req)
 {
 	struct io_waitid *iw = io_kiocb_to_cmd(req, struct io_waitid);
@@ -184,11 +184,11 @@ static inline bool io_waitid_drop_issue_ref(struct io_kiocb *req)
 	io_req_task_work_add(req);
 	remove_wait_queue(iw->head, &iwa->wo.child_wait);
 	return true;
 }
 
-static void io_waitid_cb(struct io_kiocb *req, struct io_tw_state *ts)
+static void io_waitid_cb(struct io_kiocb *req, struct io_tw_state ts)
 {
 	struct io_waitid_async *iwa = req->async_data;
 	struct io_ring_ctx *ctx = req->ctx;
 	int ret;
 
-- 
2.45.2


