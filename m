Return-Path: <io-uring+bounces-551-lists+io-uring=lfdr.de@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [139.178.88.99])
	by mail.lfdr.de (Postfix) with ESMTPS id 1A18484BAEC
	for <lists+io-uring@lfdr.de>; Tue,  6 Feb 2024 17:27:53 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id C6B78288F8A
	for <lists+io-uring@lfdr.de>; Tue,  6 Feb 2024 16:27:51 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 6131712E1ED;
	Tue,  6 Feb 2024 16:27:50 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel-dk.20230601.gappssmtp.com header.i=@kernel-dk.20230601.gappssmtp.com header.b="CPkMMR0D"
X-Original-To: io-uring@vger.kernel.org
Received: from mail-io1-f52.google.com (mail-io1-f52.google.com [209.85.166.52])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9BE731AB7E2
	for <io-uring@vger.kernel.org>; Tue,  6 Feb 2024 16:27:48 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.166.52
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1707236870; cv=none; b=TQyV7YmwK7IEwCjwOKHIO33OUujEQxYb1KVk7QrnwCFGBpBUrtzx5uWhnq3akZbsRL92JBX+qN1GNnaATYw1XaOJhgvxGU5GABAk+mz6A69Ols/dob0Fyf/JYlQipAYVrVP6VYSn6z9V37S2Fx/u4Vi0NEDdWVKd8u1XMU+8iKY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1707236870; c=relaxed/simple;
	bh=ctpng8E34OqQL0TkbrLgWGZdXTSzthGt5vhwv6vtCUU=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=rPQ++3myeugMW6fhdiwD1jEnnzanYqbVaQ/DwJQE/R5OCgfWNyHRMaJC4LBES5TRRRWwaSeV2meqJyhz+409e3FMFrz/SXTp8eOEiwkCdHx3RceuoVlnEEkoLSYiCV8S1KN2swZERzm14U84HbxYOESoYP2L/f9tANrhpJK4Vb0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=kernel.dk; spf=pass smtp.mailfrom=kernel.dk; dkim=pass (2048-bit key) header.d=kernel-dk.20230601.gappssmtp.com header.i=@kernel-dk.20230601.gappssmtp.com header.b=CPkMMR0D; arc=none smtp.client-ip=209.85.166.52
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=kernel.dk
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=kernel.dk
Received: by mail-io1-f52.google.com with SMTP id ca18e2360f4ac-7bff8f21b74so59144239f.0
        for <io-uring@vger.kernel.org>; Tue, 06 Feb 2024 08:27:48 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernel-dk.20230601.gappssmtp.com; s=20230601; t=1707236867; x=1707841667; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=OOXs2/DYRwIPiYEttFk1hLxTH7tUIHXaBKEkUZ29kqY=;
        b=CPkMMR0D39KbgpaM5jyp/oexnva7tFkgScfv5mzrgvPIpcfrdEO/1Q6zV2MWWIXaOI
         v6jNtIHElGRkxgcgvHkuHqgLAY2i2fFqxd0toC/iBuuBvQfjYWAYewHd4fJrSg/Ub+4y
         h6zsQbsiPlIywQfob0US7Edw+644GrHvcOptF0OKjjz9vcSZ7KqgJDKmKIeWFI/4Ft76
         hzW4YWN9G9TkdDkvuHjuCrkaGuIeCJrtoqXwpssfqKkK4i7CrV/NEuo0Q/IgyTCItc+7
         0U4prNKJ29hq0H3bnFXZxGX3c+VNylt0WxvcK59lR/4g2GL/AWDD3h3gRcvIrttOFMCQ
         duhA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1707236867; x=1707841667;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=OOXs2/DYRwIPiYEttFk1hLxTH7tUIHXaBKEkUZ29kqY=;
        b=SWy3FnagHisWg+7M12B4G9RONIV+BbLs8ibeLp0INoxGqMUBoFuKBRui1VhD8O6mia
         GEFKtrBTjj8UzG88rong3SgRY9E6BbtIvQrttxEj/BxWoJISX7DNTDo6vczxit7zqU/z
         opOZBwtb7jBxx5sT7mEikxlC0PoZnL1INb4zUwW47UIqU/dAg3YQKFXjHr4hhRYn+9BK
         TV+h4abMAHdL9zM4wxLvdbGzl7GCMjz8HFDTi1GBp6DcwHO6ktGU1zPs8IKoVDaULVR0
         lzBUHLpe9RPornaDWQH6gVDXqz+pQBwzg+xJzjqcTgrkn3HdpQCY3Ls6iqGJz1w6KNCs
         9dew==
X-Gm-Message-State: AOJu0Yy6d4F2YpIiD5aOWf8FjP0hKLMI0FSCkaxHdKOpRnXJ1pU9z2IV
	r4MiDixb6iPMBr+Iizk+BkS2/cR73aDAidGu5rwSAroGn5r3k5CFIR1EsdHsAqJIvcdNpWN/54O
	zODI=
X-Google-Smtp-Source: AGHT+IFklKH8v0uZewFQHDqYukoAG9n8WqD5TdLJgiSU66v5bwecFzSQyC1rIPJWyUHZQbzJCRq6Bg==
X-Received: by 2002:a05:6602:70c:b0:7c2:caa4:561a with SMTP id f12-20020a056602070c00b007c2caa4561amr3311550iox.2.1707236867123;
        Tue, 06 Feb 2024 08:27:47 -0800 (PST)
Received: from localhost.localdomain ([96.43.243.2])
        by smtp.gmail.com with ESMTPSA id a1-20020a6b6601000000b007bffd556183sm513309ioc.14.2024.02.06.08.27.46
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 06 Feb 2024 08:27:46 -0800 (PST)
From: Jens Axboe <axboe@kernel.dk>
To: io-uring@vger.kernel.org
Cc: Jens Axboe <axboe@kernel.dk>
Subject: [PATCH 10/10] io_uring/sqpoll: manage task_work privately
Date: Tue,  6 Feb 2024 09:24:44 -0700
Message-ID: <20240206162726.644202-11-axboe@kernel.dk>
X-Mailer: git-send-email 2.43.0
In-Reply-To: <20240206162726.644202-1-axboe@kernel.dk>
References: <20240206162726.644202-1-axboe@kernel.dk>
Precedence: bulk
X-Mailing-List: io-uring@vger.kernel.org
List-Id: <io-uring.vger.kernel.org>
List-Subscribe: <mailto:io-uring+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:io-uring+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

Decouple from task_work running, and cap the number of entries we process
at the time. If we exceed that number, push remaining entries to a retry
list that we'll process first next time.

We cap the number of entries to process at 8, which is fairly random.
We just want to get enough per-ctx batching here, while not processing
endlessly.

Since we manually run PF_IO_WORKER related task_work anyway as the task
never exits to userspace, with this we no longer need to add an actual
task_work item to the per-process list.

Signed-off-by: Jens Axboe <axboe@kernel.dk>
---
 io_uring/io_uring.c | 46 +++++++++++++++++++++++++++++++++++----------
 io_uring/io_uring.h | 24 +++++++++++++++++------
 io_uring/sqpoll.c   | 29 +++++++++++++++++++++++++++-
 3 files changed, 82 insertions(+), 17 deletions(-)

diff --git a/io_uring/io_uring.c b/io_uring/io_uring.c
index 20421bf36cc1..9ba2244c624e 100644
--- a/io_uring/io_uring.c
+++ b/io_uring/io_uring.c
@@ -1173,7 +1173,14 @@ static void ctx_flush_and_put(struct io_ring_ctx *ctx, struct io_tw_state *ts)
 	percpu_ref_put(&ctx->refs);
 }
 
-static void handle_tw_list(struct llist_node *node, unsigned int *count)
+/*
+ * Run queued task_work, returning the number of entries processed in *count.
+ * If more entries than max_entries are available, stop processing once this
+ * is reached and return the rest of the list.
+ */
+struct llist_node *io_handle_tw_list(struct llist_node *node,
+				     unsigned int *count,
+				     unsigned int max_entries)
 {
 	struct io_ring_ctx *ctx = NULL;
 	struct io_tw_state ts = { };
@@ -1200,9 +1207,10 @@ static void handle_tw_list(struct llist_node *node, unsigned int *count)
 			ctx = NULL;
 			cond_resched();
 		}
-	} while (node);
+	} while (node && *count < max_entries);
 
 	ctx_flush_and_put(ctx, &ts);
+	return node;
 }
 
 /**
@@ -1247,27 +1255,41 @@ static __cold void io_fallback_tw(struct io_uring_task *tctx, bool sync)
 	}
 }
 
-void tctx_task_work(struct callback_head *cb)
+struct llist_node *tctx_task_work_run(struct io_uring_task *tctx,
+				      unsigned int max_entries,
+				      unsigned int *count)
 {
-	struct io_uring_task *tctx = container_of(cb, struct io_uring_task,
-						  task_work);
 	struct llist_node *node;
-	unsigned int count = 0;
 
 	if (unlikely(current->flags & PF_EXITING)) {
 		io_fallback_tw(tctx, true);
-		return;
+		return NULL;
 	}
 
 	node = llist_del_all(&tctx->task_list);
-	if (node)
-		handle_tw_list(llist_reverse_order(node), &count);
+	if (node) {
+		node = llist_reverse_order(node);
+		node = io_handle_tw_list(node, count, max_entries);
+	}
 
 	/* relaxed read is enough as only the task itself sets ->in_cancel */
 	if (unlikely(atomic_read(&tctx->in_cancel)))
 		io_uring_drop_tctx_refs(current);
 
-	trace_io_uring_task_work_run(tctx, count);
+	trace_io_uring_task_work_run(tctx, *count);
+	return node;
+}
+
+void tctx_task_work(struct callback_head *cb)
+{
+	struct io_uring_task *tctx;
+	struct llist_node *ret;
+	unsigned int count = 0;
+
+	tctx = container_of(cb, struct io_uring_task, task_work);
+	ret = tctx_task_work_run(tctx, UINT_MAX, &count);
+	/* can't happen */
+	WARN_ON_ONCE(ret);
 }
 
 static inline void io_req_local_work_add(struct io_kiocb *req, unsigned flags)
@@ -1350,6 +1372,10 @@ static void io_req_normal_work_add(struct io_kiocb *req)
 	if (ctx->flags & IORING_SETUP_TASKRUN_FLAG)
 		atomic_or(IORING_SQ_TASKRUN, &ctx->rings->sq_flags);
 
+	/* SQPOLL doesn't need the task_work added, it'll run it itself */
+	if (ctx->flags & IORING_SETUP_SQPOLL)
+		return;
+
 	if (likely(!task_work_add(req->task, &tctx->task_work, ctx->notify_method)))
 		return;
 
diff --git a/io_uring/io_uring.h b/io_uring/io_uring.h
index 46795ee462df..38af82788786 100644
--- a/io_uring/io_uring.h
+++ b/io_uring/io_uring.h
@@ -57,6 +57,8 @@ void io_queue_iowq(struct io_kiocb *req, struct io_tw_state *ts_dont_use);
 void io_req_task_complete(struct io_kiocb *req, struct io_tw_state *ts);
 void io_req_task_queue_fail(struct io_kiocb *req, int ret);
 void io_req_task_submit(struct io_kiocb *req, struct io_tw_state *ts);
+struct llist_node *io_handle_tw_list(struct llist_node *node, unsigned int *count, unsigned int max_entries);
+struct llist_node *tctx_task_work_run(struct io_uring_task *tctx, unsigned int max_entries, unsigned int *count);
 void tctx_task_work(struct callback_head *cb);
 __cold void io_uring_cancel_generic(bool cancel_all, struct io_sq_data *sqd);
 int io_uring_alloc_task_context(struct task_struct *task,
@@ -275,6 +277,8 @@ static inline unsigned int io_sqring_entries(struct io_ring_ctx *ctx)
 
 static inline int io_run_task_work(void)
 {
+	bool ret = false;
+
 	/*
 	 * Always check-and-clear the task_work notification signal. With how
 	 * signaling works for task_work, we can find it set with nothing to
@@ -286,18 +290,26 @@ static inline int io_run_task_work(void)
 	 * PF_IO_WORKER never returns to userspace, so check here if we have
 	 * notify work that needs processing.
 	 */
-	if (current->flags & PF_IO_WORKER &&
-	    test_thread_flag(TIF_NOTIFY_RESUME)) {
-		__set_current_state(TASK_RUNNING);
-		resume_user_mode_work(NULL);
+	if (current->flags & PF_IO_WORKER) {
+		if (test_thread_flag(TIF_NOTIFY_RESUME)) {
+			__set_current_state(TASK_RUNNING);
+			resume_user_mode_work(NULL);
+		}
+		if (current->io_uring) {
+			unsigned int count = 0;
+
+			tctx_task_work_run(current->io_uring, UINT_MAX, &count);
+			if (count)
+				ret = true;
+		}
 	}
 	if (task_work_pending(current)) {
 		__set_current_state(TASK_RUNNING);
 		task_work_run();
-		return 1;
+		ret = true;
 	}
 
-	return 0;
+	return ret;
 }
 
 static inline bool io_task_work_pending(struct io_ring_ctx *ctx)
diff --git a/io_uring/sqpoll.c b/io_uring/sqpoll.c
index 65b5dbe3c850..28bf0e085d31 100644
--- a/io_uring/sqpoll.c
+++ b/io_uring/sqpoll.c
@@ -18,6 +18,7 @@
 #include "sqpoll.h"
 
 #define IORING_SQPOLL_CAP_ENTRIES_VALUE 8
+#define IORING_TW_CAP_ENTRIES_VALUE	8
 
 enum {
 	IO_SQ_THREAD_SHOULD_STOP = 0,
@@ -219,8 +220,31 @@ static bool io_sqd_handle_event(struct io_sq_data *sqd)
 	return did_sig || test_bit(IO_SQ_THREAD_SHOULD_STOP, &sqd->state);
 }
 
+/*
+ * Run task_work, processing the retry_list first. The retry_list holds
+ * entries that we passed on in the previous run, if we had more task_work
+ * than we were asked to process. Newly queued task_work isn't run until the
+ * retry list has been fully processed.
+ */
+static unsigned int io_sq_tw(struct llist_node **retry_list, int max_entries)
+{
+	struct io_uring_task *tctx = current->io_uring;
+	unsigned int count = 0;
+
+	if (*retry_list) {
+		*retry_list = io_handle_tw_list(*retry_list, &count, max_entries);
+		if (count >= max_entries)
+			return count;
+		max_entries -= count;
+	}
+
+	*retry_list = tctx_task_work_run(tctx, max_entries, &count);
+	return count;
+}
+
 static int io_sq_thread(void *data)
 {
+	struct llist_node *retry_list = NULL;
 	struct io_sq_data *sqd = data;
 	struct io_ring_ctx *ctx;
 	unsigned long timeout = 0;
@@ -257,7 +281,7 @@ static int io_sq_thread(void *data)
 			if (!sqt_spin && (ret > 0 || !wq_list_empty(&ctx->iopoll_list)))
 				sqt_spin = true;
 		}
-		if (io_run_task_work())
+		if (io_sq_tw(&retry_list, IORING_TW_CAP_ENTRIES_VALUE))
 			sqt_spin = true;
 
 		if (sqt_spin || !time_after(jiffies, timeout)) {
@@ -312,6 +336,9 @@ static int io_sq_thread(void *data)
 		timeout = jiffies + sqd->sq_thread_idle;
 	}
 
+	if (retry_list)
+		io_sq_tw(&retry_list, UINT_MAX);
+
 	io_uring_cancel_generic(true, sqd);
 	sqd->thread = NULL;
 	list_for_each_entry(ctx, &sqd->ctx_list, sqd_list)
-- 
2.43.0


