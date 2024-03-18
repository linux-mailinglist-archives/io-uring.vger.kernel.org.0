Return-Path: <io-uring+bounces-1071-lists+io-uring=lfdr.de@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from sy.mirrors.kernel.org (sy.mirrors.kernel.org [147.75.48.161])
	by mail.lfdr.de (Postfix) with ESMTPS id 0769787E159
	for <lists+io-uring@lfdr.de>; Mon, 18 Mar 2024 01:44:27 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sy.mirrors.kernel.org (Postfix) with ESMTPS id 625C2B2169A
	for <lists+io-uring@lfdr.de>; Mon, 18 Mar 2024 00:44:24 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id D30DB20DFF;
	Mon, 18 Mar 2024 00:43:52 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="jGjAyyMb"
X-Original-To: io-uring@vger.kernel.org
Received: from mail-lf1-f52.google.com (mail-lf1-f52.google.com [209.85.167.52])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B4B0D208CB;
	Mon, 18 Mar 2024 00:43:50 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.167.52
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1710722632; cv=none; b=AsfgGWcnslLTROv6VVBEuzAdIQAgsvhMgfKbo+9nrOtXgvcMRcNi4MSCjosF2fB2LtAulQz37lS70pxGP9jfFFGxlfr2cRztzm5i+wFKQBztbZp4ha3xCHObWY37aYr0lxr3+82Mwjxw0Vgv7hD6LRbxaXfyEhU0uGrbqxWeCeY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1710722632; c=relaxed/simple;
	bh=02HujhgwnfkOWVmPn2Yk089NvVni5bJATFLrT2ChMok=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=EltMs4Y4DeD3vq6HbF50VWCNz9FRgoj3M6L1sdwavND2be8ndmlft54RDBjTZnh0Perq0OwtWFSfIlK3GwEN63dvPHkelBuWFIumBZl4+kI3SHUNRvTOryECHBElhdeIC6fL93Ni1gNTqbaiRBKS/P1MdvUgjR1gkUGIsm2Rm20=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=jGjAyyMb; arc=none smtp.client-ip=209.85.167.52
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Received: by mail-lf1-f52.google.com with SMTP id 2adb3069b0e04-513d717269fso3581460e87.0;
        Sun, 17 Mar 2024 17:43:50 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1710722628; x=1711327428; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=M3C7yKMELUaSacTHIbXhejLYdgP7SmusGhf9nsXaFx0=;
        b=jGjAyyMb0rwL2qUpdhOSJm7kaWu7pbu07DQbc6DLpGKW7TL0tgZP6DSevk3NHMfbOV
         nMw8KGtakvz1iNveMQKU9VFyGpd7fW0sivH2yftesdFakHrxyGID12+hv+0pKuyrCMIn
         MGS8JhMEstmTrWRhaqjJ4Mz16mV/excymJi0sCjFLJ1P4q7v2z53ORFE28mqRQFPfByD
         7TZNGbj8N9aZR2TJ1V8rxrdTntji/d5rfB3zURm7iySBNi7AXgB0tQV6KHWBiYzEmibp
         Lu9Omsd2YSvvEhH9jvlFgz00mS4u6o3rX0R97vG0o6/Jp84Vjv0qmPybJmPw47ibHbgz
         bl0w==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1710722628; x=1711327428;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=M3C7yKMELUaSacTHIbXhejLYdgP7SmusGhf9nsXaFx0=;
        b=vwD83lHZLrBi/LTd7vyCRdQThfIJKihBWGi2Fn60fyn0MOWX2UfEN7NbeYI+KKnY0Q
         xgOneyJa0V8aoWrFK57cPQvCqrhFAtAwFLNAckDnRn6I54POg+yCTepo1nnEAsoH5Wau
         rBDZd1yj6KnjLCsnobvZhlspIMBHE+T3qG2kjwMoQ90QVOGSZiBCzdlcNIm4Xhnv7YtA
         tJEv9XJYzPwwjU2nkihaWQ0M/+lgxu2c1w8JGz2fpjFeByPRfgaAO0KGtu+LIlJ6EUUQ
         qAe48FM/s+c7p1cxjbKl/yYwdSEpYzmLQOEFY+RRDIl6kB/VuDD18yskxHoqnXAFeSHC
         9BJg==
X-Gm-Message-State: AOJu0YxdFuZjvfJ4lP+LBLW5qm8ablUeRtslrlLxYAurnsIj5sAcJGhp
	RB7lZou25rLhYnGHnUwjMj7DQNdVSCthcQcpUukTBahbUD7Dv1cYLDq+pTEi
X-Google-Smtp-Source: AGHT+IFVGBdvHlJG+ynJ29UPahkl1CoWKwLZkZRRF9dkpQWMsQ3YuUcnZlUQNjMrAdEHKlKpKdUdRA==
X-Received: by 2002:ac2:5f92:0:b0:513:cf4e:941b with SMTP id r18-20020ac25f92000000b00513cf4e941bmr6461889lfe.19.1710722628068;
        Sun, 17 Mar 2024 17:43:48 -0700 (PDT)
Received: from 127.0.0.1localhost ([85.255.232.181])
        by smtp.gmail.com with ESMTPSA id p13-20020a05640243cd00b00568d55c1bbasm888465edc.73.2024.03.17.17.43.46
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sun, 17 Mar 2024 17:43:47 -0700 (PDT)
From: Pavel Begunkov <asml.silence@gmail.com>
To: io-uring@vger.kernel.org
Cc: linux-block@vger.kernel.org,
	Jens Axboe <axboe@kernel.dk>,
	asml.silence@gmail.com,
	Kanchan Joshi <joshi.k@samsung.com>,
	Ming Lei <ming.lei@redhat.com>
Subject: [PATCH v2 09/14] io_uring: remove struct io_tw_state::locked
Date: Mon, 18 Mar 2024 00:41:54 +0000
Message-ID: <1609600918e10b0b8038a6571f5b84254b12d221.1710720150.git.asml.silence@gmail.com>
X-Mailer: git-send-email 2.44.0
In-Reply-To: <cover.1710720150.git.asml.silence@gmail.com>
References: <cover.1710720150.git.asml.silence@gmail.com>
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
Link: https://lore.kernel.org/r/04482ca7bfea9eb47ba483c590aa46c83315a6ea.1710514702.git.asml.silence@gmail.com
Signed-off-by: Jens Axboe <axboe@kernel.dk>
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
index 3184d57f9a35..ef089f6367ea 100644
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
index 9590081feb2d..77c29f6883d3 100644
--- a/io_uring/uring_cmd.c
+++ b/io_uring/uring_cmd.c
@@ -58,13 +58,9 @@ EXPORT_SYMBOL_GPL(io_uring_cmd_mark_cancelable);
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
index 77d340666cb9..6362ec20abc0 100644
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
2.44.0


