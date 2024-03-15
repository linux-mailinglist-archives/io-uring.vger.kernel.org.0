Return-Path: <io-uring+bounces-961-lists+io-uring=lfdr.de@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [147.75.199.223])
	by mail.lfdr.de (Postfix) with ESMTPS id 8E17A87D059
	for <lists+io-uring@lfdr.de>; Fri, 15 Mar 2024 16:31:47 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id B207E1C20F57
	for <lists+io-uring@lfdr.de>; Fri, 15 Mar 2024 15:31:46 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 9A90A3E474;
	Fri, 15 Mar 2024 15:31:23 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="mbpE9O8b"
X-Original-To: io-uring@vger.kernel.org
Received: from mail-wr1-f51.google.com (mail-wr1-f51.google.com [209.85.221.51])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 98C2A40BED;
	Fri, 15 Mar 2024 15:31:21 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.221.51
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1710516683; cv=none; b=jUPHjqpxUrSQmLgNANL9YlQgbMbPk4DRt2aezFSkstCQbZ/5nqXzaE/e0XItWLs9hbOcjCp+Dkv2iGRXzXZoT5hc9fATKD5ejSH7jaqwIFnOz9E56SfoU05tNnExDyQArxtMpndw6Wt3OAnzilQ0/rlD1JnrwzqzbLlaUVtELec=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1710516683; c=relaxed/simple;
	bh=2IVgJelfwSrUZxl7VJW3YC+UA79e6CehL+UHqoNILCM=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=f8e0rFue95XnypkhY2do6dUGMgdBwb07jVOEHYN5SAn/4Tef5yOiZYUrSMNGivXNLakXuOKPukEP67a9ps9xZhSPUwVPjJ+yk2GpD11actXloSQMQUvfa62OHaOvzPI1Ss3WGORp7xba9nTcAcKsIjHJu3wiBf7OWQCXD6f7I6E=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=mbpE9O8b; arc=none smtp.client-ip=209.85.221.51
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Received: by mail-wr1-f51.google.com with SMTP id ffacd0b85a97d-33e5978fc1bso1113763f8f.3;
        Fri, 15 Mar 2024 08:31:21 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1710516680; x=1711121480; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=8u+FxQNKf+A4K+mkGN1fRUo4gZebAM7P2pFv3PfIxx8=;
        b=mbpE9O8bLvJRtRcVpsaiV4tOJG5BauSH46hCaO2o8g8q9JB2VdmusPMO6YNKWmjjhg
         0mm+WBWHkEWjpK9YH9mAcLyNkS7TxBU8CUkOQK7CX6ln5Lw1lEQm46SktTOn9i7mdxzS
         97/lrBu2BqSzC0pfCmRFeN8syeWuuk9SXBUPFVVX9Zvy0IWRV8wxNY/eF+NAVnoe6IMU
         ayDVYpIuFCEZxkJw5KdaRquauh0d1L2vWi3TV13TCKkB30T3lBWkkuIHMEnou7MADghN
         lIiJTmrEhyX/Ti1/g82EFQRSmWYMGA0TW7v7Xk/q1fvXEHiBCSoBngdn34UzvaiDNZHa
         +OGw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1710516680; x=1711121480;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=8u+FxQNKf+A4K+mkGN1fRUo4gZebAM7P2pFv3PfIxx8=;
        b=YcsPjO5lPItQ8qP9hXdVxWVUtPMu3sqT5CvvUZSmPjOGPrGIjTdu4dzsrZ6eYkRs42
         uwfXH6v+ClDplM+heDqkBEP8hAMKMet07d0IiFWLUIkV6EZYX9QURZ9qelDTyI+fREwT
         gbKY39Uv+3YLZfhE3D8SaTHrU9vmeU7p14vqX/Owso3qJFj4T2taPen/+mFDp8Yi6Xcz
         SuWw5BLfooCZFcOYgGCG9EvxalGuRINIGwwl9LIvjWHwyMcRtCxC6PftXb4KP4uYv0aD
         jAu9bxVY+ZvlTdjA8FsDc34ge8FfKEHRAQwQk0JQDIt1dQRW+vgoMnHBZVxJssBYltoS
         Nttg==
X-Gm-Message-State: AOJu0YwS3ne8MjOsDNIMomCq20/7cjh/dieO29kCPXuqt/tvHyi0FuuP
	oREmcmIsrdqMYT9jF6+8XMzRpSBUQ0J4nCvZxfpc6orGwQjvLSjoDjMp2Yai
X-Google-Smtp-Source: AGHT+IFBvbBF/MveCOkzmUn3I+LiMMKkuRvn/X5whcqxDAiWgGUz8B7q5d268IZY5IPVrw+cgr62yA==
X-Received: by 2002:a05:6000:d49:b0:33e:6db4:e89f with SMTP id du9-20020a0560000d4900b0033e6db4e89fmr4302469wrb.22.1710516679681;
        Fri, 15 Mar 2024 08:31:19 -0700 (PDT)
Received: from 127.0.0.1localhost ([148.252.141.58])
        by smtp.gmail.com with ESMTPSA id u3-20020a5d6ac3000000b0033dd2c3131fsm3415671wrw.65.2024.03.15.08.31.18
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 15 Mar 2024 08:31:19 -0700 (PDT)
From: Pavel Begunkov <asml.silence@gmail.com>
To: io-uring@vger.kernel.org
Cc: linux-block@vger.kernel.org,
	Jens Axboe <axboe@kernel.dk>,
	asml.silence@gmail.com,
	Kanchan Joshi <joshi.k@samsung.com>,
	Ming Lei <ming.lei@redhat.com>
Subject: [PATCH 09/11] io_uring: remove struct io_tw_state::locked
Date: Fri, 15 Mar 2024 15:29:59 +0000
Message-ID: <04482ca7bfea9eb47ba483c590aa46c83315a6ea.1710514702.git.asml.silence@gmail.com>
X-Mailer: git-send-email 2.43.0
In-Reply-To: <cover.1710514702.git.asml.silence@gmail.com>
References: <cover.1710514702.git.asml.silence@gmail.com>
Precedence: bulk
X-Mailing-List: io-uring@vger.kernel.org
List-Id: <io-uring.vger.kernel.org>
List-Subscribe: <mailto:io-uring+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:io-uring+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

ctx is always locked for task_work now, so get rid of struct
io_tw_state::locked. Note I'm stopping one step before removing
io_tw_state altogether, which is not empty, because it still serves the
purpose of indicating which function is a tw callback and forcing users
not to invoke them carelessly out of a wrong context. The removal can
always be done later.

Signed-off-by: Pavel Begunkov <asml.silence@gmail.com>
---
 include/linux/io_uring_types.h |  2 --
 io_uring/io_uring.c            | 31 ++++++++-----------------------
 io_uring/io_uring.h            |  5 +----
 io_uring/poll.c                |  2 +-
 io_uring/rw.c                  |  6 ++----
 io_uring/timeout.c             |  8 ++------
 io_uring/uring_cmd.c           |  8 ++------
 io_uring/waitid.c              |  2 +-
 8 files changed, 17 insertions(+), 47 deletions(-)

diff --git a/include/linux/io_uring_types.h b/include/linux/io_uring_types.h
index e24893625085..5a2afbc93887 100644
--- a/include/linux/io_uring_types.h
+++ b/include/linux/io_uring_types.h
@@ -439,8 +439,6 @@ struct io_ring_ctx {
 };
 
 struct io_tw_state {
-	/* ->uring_lock is taken, callbacks can use io_tw_lock to lock it */
-	bool locked;
 };
 
 enum {
diff --git a/io_uring/io_uring.c b/io_uring/io_uring.c
index 0cef5c4ddc98..1c4bbfc411d1 100644
--- a/io_uring/io_uring.c
+++ b/io_uring/io_uring.c
@@ -252,14 +252,12 @@ static __cold void io_fallback_req_func(struct work_struct *work)
 						fallback_work.work);
 	struct llist_node *node = llist_del_all(&ctx->fallback_llist);
 	struct io_kiocb *req, *tmp;
-	struct io_tw_state ts = { .locked = true, };
+	struct io_tw_state ts = {};
 
 	percpu_ref_get(&ctx->refs);
 	mutex_lock(&ctx->uring_lock);
 	llist_for_each_entry_safe(req, tmp, node, io_task_work.node)
 		req->io_task_work.func(req, &ts);
-	if (WARN_ON_ONCE(!ts.locked))
-		return;
 	io_submit_flush_completions(ctx);
 	mutex_unlock(&ctx->uring_lock);
 	percpu_ref_put(&ctx->refs);
@@ -1163,11 +1161,9 @@ static void ctx_flush_and_put(struct io_ring_ctx *ctx, struct io_tw_state *ts)
 		return;
 	if (ctx->flags & IORING_SETUP_TASKRUN_FLAG)
 		atomic_andnot(IORING_SQ_TASKRUN, &ctx->rings->sq_flags);
-	if (ts->locked) {
-		io_submit_flush_completions(ctx);
-		mutex_unlock(&ctx->uring_lock);
-		ts->locked = false;
-	}
+
+	io_submit_flush_completions(ctx);
+	mutex_unlock(&ctx->uring_lock);
 	percpu_ref_put(&ctx->refs);
 }
 
@@ -1191,8 +1187,6 @@ struct llist_node *io_handle_tw_list(struct llist_node *node,
 		if (req->ctx != ctx) {
 			ctx_flush_and_put(ctx, &ts);
 			ctx = req->ctx;
-
-			ts.locked = true;
 			mutex_lock(&ctx->uring_lock);
 			percpu_ref_get(&ctx->refs);
 		}
@@ -1465,22 +1459,16 @@ static int __io_run_local_work(struct io_ring_ctx *ctx, struct io_tw_state *ts,
 static inline int io_run_local_work_locked(struct io_ring_ctx *ctx,
 					   int min_events)
 {
-	struct io_tw_state ts = { .locked = true, };
-	int ret;
+	struct io_tw_state ts = {};
 
 	if (llist_empty(&ctx->work_llist))
 		return 0;
-
-	ret = __io_run_local_work(ctx, &ts, min_events);
-	/* shouldn't happen! */
-	if (WARN_ON_ONCE(!ts.locked))
-		mutex_lock(&ctx->uring_lock);
-	return ret;
+	return __io_run_local_work(ctx, &ts, min_events);
 }
 
 static int io_run_local_work(struct io_ring_ctx *ctx, int min_events)
 {
-	struct io_tw_state ts = { .locked = true };
+	struct io_tw_state ts = {};
 	int ret;
 
 	mutex_lock(&ctx->uring_lock);
@@ -1708,10 +1696,7 @@ static int io_iopoll_check(struct io_ring_ctx *ctx, long min)
 
 void io_req_task_complete(struct io_kiocb *req, struct io_tw_state *ts)
 {
-	if (ts->locked)
-		io_req_complete_defer(req);
-	else
-		io_req_complete_post(req, IO_URING_F_UNLOCKED);
+	io_req_complete_defer(req);
 }
 
 /*
diff --git a/io_uring/io_uring.h b/io_uring/io_uring.h
index 472ba5692ba8..6cad3ef3408b 100644
--- a/io_uring/io_uring.h
+++ b/io_uring/io_uring.h
@@ -344,10 +344,7 @@ static inline bool io_task_work_pending(struct io_ring_ctx *ctx)
 
 static inline void io_tw_lock(struct io_ring_ctx *ctx, struct io_tw_state *ts)
 {
-	if (!ts->locked) {
-		mutex_lock(&ctx->uring_lock);
-		ts->locked = true;
-	}
+	lockdep_assert_held(&ctx->uring_lock);
 }
 
 /*
diff --git a/io_uring/poll.c b/io_uring/poll.c
index 6db1dcb2c797..8901dd118e50 100644
--- a/io_uring/poll.c
+++ b/io_uring/poll.c
@@ -322,7 +322,7 @@ static int io_poll_check_events(struct io_kiocb *req, struct io_tw_state *ts)
 			__poll_t mask = mangle_poll(req->cqe.res &
 						    req->apoll_events);
 
-			if (!io_fill_cqe_req_aux(req, ts->locked, mask,
+			if (!io_fill_cqe_req_aux(req, true, mask,
 						 IORING_CQE_F_MORE)) {
 				io_req_set_res(req, mask, 0);
 				return IOU_POLL_REMOVE_POLL_USE_RES;
diff --git a/io_uring/rw.c b/io_uring/rw.c
index 576934dbf833..c7f9246ff508 100644
--- a/io_uring/rw.c
+++ b/io_uring/rw.c
@@ -305,11 +305,9 @@ void io_req_rw_complete(struct io_kiocb *req, struct io_tw_state *ts)
 
 	io_req_io_end(req);
 
-	if (req->flags & (REQ_F_BUFFER_SELECTED|REQ_F_BUFFER_RING)) {
-		unsigned issue_flags = ts->locked ? 0 : IO_URING_F_UNLOCKED;
+	if (req->flags & (REQ_F_BUFFER_SELECTED|REQ_F_BUFFER_RING))
+		req->cqe.flags |= io_put_kbuf(req, 0);
 
-		req->cqe.flags |= io_put_kbuf(req, issue_flags);
-	}
 	io_req_task_complete(req, ts);
 }
 
diff --git a/io_uring/timeout.c b/io_uring/timeout.c
index 7fd7dbb211d6..0a48e6acd0b2 100644
--- a/io_uring/timeout.c
+++ b/io_uring/timeout.c
@@ -72,10 +72,7 @@ static void io_timeout_complete(struct io_kiocb *req, struct io_tw_state *ts)
 	struct io_ring_ctx *ctx = req->ctx;
 
 	if (!io_timeout_finish(timeout, data)) {
-		bool filled;
-		filled = io_fill_cqe_req_aux(req, ts->locked, -ETIME,
-					     IORING_CQE_F_MORE);
-		if (filled) {
+		if (io_fill_cqe_req_aux(req, true, -ETIME, IORING_CQE_F_MORE)) {
 			/* re-arm timer */
 			spin_lock_irq(&ctx->timeout_lock);
 			list_add(&timeout->list, ctx->timeout_list.prev);
@@ -301,7 +298,6 @@ int io_timeout_cancel(struct io_ring_ctx *ctx, struct io_cancel_data *cd)
 
 static void io_req_task_link_timeout(struct io_kiocb *req, struct io_tw_state *ts)
 {
-	unsigned issue_flags = ts->locked ? 0 : IO_URING_F_UNLOCKED;
 	struct io_timeout *timeout = io_kiocb_to_cmd(req, struct io_timeout);
 	struct io_kiocb *prev = timeout->prev;
 	int ret = -ENOENT;
@@ -313,7 +309,7 @@ static void io_req_task_link_timeout(struct io_kiocb *req, struct io_tw_state *t
 				.data		= prev->cqe.user_data,
 			};
 
-			ret = io_try_cancel(req->task->io_uring, &cd, issue_flags);
+			ret = io_try_cancel(req->task->io_uring, &cd, 0);
 		}
 		io_req_set_res(req, ret ?: -ETIME, 0);
 		io_req_task_complete(req, ts);
diff --git a/io_uring/uring_cmd.c b/io_uring/uring_cmd.c
index ec38a8d4836d..e45d4cd5ef82 100644
--- a/io_uring/uring_cmd.c
+++ b/io_uring/uring_cmd.c
@@ -56,13 +56,9 @@ EXPORT_SYMBOL_GPL(io_uring_cmd_mark_cancelable);
 static void io_uring_cmd_work(struct io_kiocb *req, struct io_tw_state *ts)
 {
 	struct io_uring_cmd *ioucmd = io_kiocb_to_cmd(req, struct io_uring_cmd);
-	unsigned issue_flags = IO_URING_F_UNLOCKED;
 
-	/* locked task_work executor checks the deffered list completion */
-	if (ts->locked)
-		issue_flags = IO_URING_F_COMPLETE_DEFER;
-
-	ioucmd->task_work_cb(ioucmd, issue_flags);
+	/* task_work executor checks the deffered list completion */
+	ioucmd->task_work_cb(ioucmd, IO_URING_F_COMPLETE_DEFER);
 }
 
 void __io_uring_cmd_do_in_task(struct io_uring_cmd *ioucmd,
diff --git a/io_uring/waitid.c b/io_uring/waitid.c
index 6f851978606d..791ea752b0b1 100644
--- a/io_uring/waitid.c
+++ b/io_uring/waitid.c
@@ -118,7 +118,7 @@ static int io_waitid_finish(struct io_kiocb *req, int ret)
 static void io_waitid_complete(struct io_kiocb *req, int ret)
 {
 	struct io_waitid *iw = io_kiocb_to_cmd(req, struct io_waitid);
-	struct io_tw_state ts = { .locked = true };
+	struct io_tw_state ts = {};
 
 	/* anyone completing better be holding a reference */
 	WARN_ON_ONCE(!(atomic_read(&iw->refs) & IO_WAITID_REF_MASK));
-- 
2.43.0


