Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 50700322A39
	for <lists+io-uring@lfdr.de>; Tue, 23 Feb 2021 13:12:50 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232387AbhBWMEZ (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Tue, 23 Feb 2021 07:04:25 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:53570 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232489AbhBWMAz (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Tue, 23 Feb 2021 07:00:55 -0500
Received: from mail-wr1-x42e.google.com (mail-wr1-x42e.google.com [IPv6:2a00:1450:4864:20::42e])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 3BE6DC061574
        for <io-uring@vger.kernel.org>; Tue, 23 Feb 2021 04:00:15 -0800 (PST)
Received: by mail-wr1-x42e.google.com with SMTP id u14so22321012wri.3
        for <io-uring@vger.kernel.org>; Tue, 23 Feb 2021 04:00:15 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=+mmyaNmoymJeAz7tX4dL4qDDBGn5l2c5Bd1svoW7oqs=;
        b=GVA4PUAqaw0xB5zREYSbE33o6DdVhpfAUU3tfN/FVktiE1EJGheS5ASv6M0AWVGkR1
         WacW5vxIqb7VopC75p6zA29yNBGDrv1LtO5deTThKjmfhq/Rp3UHmm4Ef867VzWHaj8s
         YQdZhbNUhQtHVju3zcuqlNiFiR7jBU4UyHaudn/3sbL5UicR8nTynntvxBA+5/2NE0lm
         7IoA11yUWexB4XyhIyXuwj+51tyYhGn78XaKI/4UQlScGF76EjQCm7oNo2DDtZPjXL+4
         VojEVY2CHkqU1Vc5HvKlXMElH28vKuFQWU0jkmV5eORNXxSQjpN5h/NiZgnRQNLv7pUn
         Phmg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=+mmyaNmoymJeAz7tX4dL4qDDBGn5l2c5Bd1svoW7oqs=;
        b=EIu8lhji0YPINB4RBB5QfMYIGRCKslxzAuDtYFy9Y8pv68iUcgabjsS8It3fJg84p4
         XVqgCDiU11JVkm9w8N1X3/F7aE8SCmX3U1RLLWFcZNboEpr0j1UIp7W/8EdDLbktaxUN
         wByRIusMSd5ZdBewCOoZw99H1Liq/RatXNVExPnkgEWhNLAvpHPksK4k5RceiVngn+sa
         yeNwjUDRc2oNQmDP0Ccssjlw3PfpxIMC+nM10S1oiaugh4AvjS/fiD6Vh7UXOvs72qZo
         RkeTBZqaiFTEEoHG9nns3iB9R9o9EX7COMAM2zPx7K82Gxth1E4ylOEWu0J27/zQBtNO
         VhJQ==
X-Gm-Message-State: AOAM5328A4k+2QxHK8hze4ivN2YMcGm385JMlcLhJ8DfECbmoauMmAyi
        zrbKJnTCMRBpShgpN5VTiTAZvw/f0BM=
X-Google-Smtp-Source: ABdhPJyvLaa9oYOashm71fpS0QtzLVxxdxpn0JXSgTWx00b3xZXW4hiZauke1cbLa9/mAgA5YWCPCw==
X-Received: by 2002:a5d:5750:: with SMTP id q16mr11956357wrw.315.1614081614025;
        Tue, 23 Feb 2021 04:00:14 -0800 (PST)
Received: from localhost.localdomain ([148.252.132.56])
        by smtp.gmail.com with ESMTPSA id b7sm7873270wrv.6.2021.02.23.04.00.13
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 23 Feb 2021 04:00:13 -0800 (PST)
From:   Pavel Begunkov <asml.silence@gmail.com>
To:     Jens Axboe <axboe@kernel.dk>, io-uring@vger.kernel.org
Subject: [PATCH] io_uring: allocate memory for overflowed CQEs
Date:   Tue, 23 Feb 2021 11:56:15 +0000
Message-Id: <783b4d714de12ea74f24b27fa1a22d377938699c.1614081341.git.asml.silence@gmail.com>
X-Mailer: git-send-email 2.24.0
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org

Instead of using a request itself for overflowed CQE stashing, allocate
a separate entry. The disadvantage is that the allocation may fail and
it will be accounted as lost (see rings->cq_overflow), so we lose
reliability in case of memory pressure. However, it opens a way for for
multiple CQEs per an SQE and even generating SQE-less CQEs.

Signed-off-by: Pavel Begunkov <asml.silence@gmail.com>
---
 fs/io_uring.c | 98 +++++++++++++++++++++++----------------------------
 1 file changed, 45 insertions(+), 53 deletions(-)

diff --git a/fs/io_uring.c b/fs/io_uring.c
index ae976e7088dc..138d5da1ef0e 100644
--- a/fs/io_uring.c
+++ b/fs/io_uring.c
@@ -205,6 +205,11 @@ struct io_mapped_ubuf {
 
 struct io_ring_ctx;
 
+struct io_overflow_cqe {
+	struct io_uring_cqe cqe;
+	struct list_head list;
+};
+
 struct io_rsrc_put {
 	struct list_head list;
 	union {
@@ -1468,41 +1473,33 @@ static void io_cqring_ev_posted_iopoll(struct io_ring_ctx *ctx)
 }
 
 /* Returns true if there are no backlogged entries after the flush */
-static bool __io_cqring_overflow_flush(struct io_ring_ctx *ctx, bool force,
-				       struct task_struct *tsk,
-				       struct files_struct *files)
+static bool __io_cqring_overflow_flush(struct io_ring_ctx *ctx, bool force)
 {
 	struct io_rings *rings = ctx->rings;
-	struct io_kiocb *req, *tmp;
-	struct io_uring_cqe *cqe;
 	unsigned long flags;
 	bool all_flushed, posted;
-	LIST_HEAD(list);
 
 	if (!force && __io_cqring_events(ctx) == rings->cq_ring_entries)
 		return false;
 
 	posted = false;
 	spin_lock_irqsave(&ctx->completion_lock, flags);
-	list_for_each_entry_safe(req, tmp, &ctx->cq_overflow_list, compl.list) {
-		if (!io_match_task(req, tsk, files))
-			continue;
+	while (!list_empty(&ctx->cq_overflow_list)) {
+		struct io_uring_cqe *cqe = io_get_cqring(ctx);
+		struct io_overflow_cqe *ocqe;
 
-		cqe = io_get_cqring(ctx);
 		if (!cqe && !force)
 			break;
-
-		list_move(&req->compl.list, &list);
-		if (cqe) {
-			WRITE_ONCE(cqe->user_data, req->user_data);
-			WRITE_ONCE(cqe->res, req->result);
-			WRITE_ONCE(cqe->flags, req->compl.cflags);
-		} else {
-			ctx->cached_cq_overflow++;
+		ocqe = list_first_entry(&ctx->cq_overflow_list,
+					struct io_overflow_cqe, list);
+		if (cqe)
+			memcpy(cqe, &ocqe->cqe, sizeof(*cqe));
+		else
 			WRITE_ONCE(ctx->rings->cq_overflow,
-				   ctx->cached_cq_overflow);
-		}
+				   ++ctx->cached_cq_overflow);
 		posted = true;
+		list_del(&ocqe->list);
+		kfree(ocqe);
 	}
 
 	all_flushed = list_empty(&ctx->cq_overflow_list);
@@ -1517,25 +1514,16 @@ static bool __io_cqring_overflow_flush(struct io_ring_ctx *ctx, bool force,
 	spin_unlock_irqrestore(&ctx->completion_lock, flags);
 	if (posted)
 		io_cqring_ev_posted(ctx);
-
-	while (!list_empty(&list)) {
-		req = list_first_entry(&list, struct io_kiocb, compl.list);
-		list_del(&req->compl.list);
-		io_put_req(req);
-	}
-
 	return all_flushed;
 }
 
-static void io_cqring_overflow_flush(struct io_ring_ctx *ctx, bool force,
-				     struct task_struct *tsk,
-				     struct files_struct *files)
+static void io_cqring_overflow_flush(struct io_ring_ctx *ctx, bool force)
 {
 	if (test_bit(0, &ctx->cq_check_overflow)) {
 		/* iopoll syncs against uring_lock, not completion_lock */
 		if (ctx->flags & IORING_SETUP_IOPOLL)
 			mutex_lock(&ctx->uring_lock);
-		__io_cqring_overflow_flush(ctx, force, tsk, files);
+		__io_cqring_overflow_flush(ctx, force);
 		if (ctx->flags & IORING_SETUP_IOPOLL)
 			mutex_unlock(&ctx->uring_lock);
 	}
@@ -1559,27 +1547,32 @@ static void __io_cqring_fill_event(struct io_kiocb *req, long res,
 		WRITE_ONCE(cqe->user_data, req->user_data);
 		WRITE_ONCE(cqe->res, res);
 		WRITE_ONCE(cqe->flags, cflags);
-	} else if (ctx->cq_overflow_flushed ||
-		   atomic_read(&req->task->io_uring->in_idle)) {
-		/*
-		 * If we're in ring overflow flush mode, or in task cancel mode,
-		 * then we cannot store the request for later flushing, we need
-		 * to drop it on the floor.
-		 */
-		ctx->cached_cq_overflow++;
-		WRITE_ONCE(ctx->rings->cq_overflow, ctx->cached_cq_overflow);
-	} else {
+		return;
+	}
+	if (!ctx->cq_overflow_flushed &&
+	    !atomic_read(&req->task->io_uring->in_idle)) {
+		struct io_overflow_cqe *ocqe = kmalloc(sizeof(*ocqe), GFP_KERNEL);
+
+		if (!ocqe)
+			goto overflow;
 		if (list_empty(&ctx->cq_overflow_list)) {
 			set_bit(0, &ctx->sq_check_overflow);
 			set_bit(0, &ctx->cq_check_overflow);
 			ctx->rings->sq_flags |= IORING_SQ_CQ_OVERFLOW;
 		}
-		io_clean_op(req);
-		req->result = res;
-		req->compl.cflags = cflags;
-		refcount_inc(&req->refs);
-		list_add_tail(&req->compl.list, &ctx->cq_overflow_list);
+		ocqe->cqe.user_data = req->user_data;
+		ocqe->cqe.res = res;
+		ocqe->cqe.flags = cflags;
+		list_add_tail(&ocqe->list, &ctx->cq_overflow_list);
+		return;
 	}
+overflow:
+	/*
+	 * If we're in ring overflow flush mode, or in task cancel mode,
+	 * or cannot allocate an overflow entry, then we need to drop it
+	 * on the floor.
+	 */
+	WRITE_ONCE(ctx->rings->cq_overflow, ++ctx->cached_cq_overflow);
 }
 
 static void io_cqring_fill_event(struct io_kiocb *req, long res)
@@ -2367,7 +2360,7 @@ static void io_iopoll_try_reap_events(struct io_ring_ctx *ctx)
 static inline bool io_iopoll_check_events(struct io_ring_ctx *ctx)
 {
 	if (test_bit(0, &ctx->cq_check_overflow))
-		__io_cqring_overflow_flush(ctx, false, NULL, NULL);
+		__io_cqring_overflow_flush(ctx, false);
 	return io_cqring_events(ctx);
 }
 
@@ -6463,7 +6456,7 @@ static int io_submit_sqes(struct io_ring_ctx *ctx, unsigned int nr)
 
 	/* if we have a backlog and couldn't flush it all, return BUSY */
 	if (test_bit(0, &ctx->sq_check_overflow)) {
-		if (!__io_cqring_overflow_flush(ctx, false, NULL, NULL))
+		if (!__io_cqring_overflow_flush(ctx, false))
 			return -EBUSY;
 	}
 
@@ -6813,7 +6806,7 @@ static int io_cqring_wait(struct io_ring_ctx *ctx, int min_events,
 	int ret;
 
 	do {
-		io_cqring_overflow_flush(ctx, false, NULL, NULL);
+		io_cqring_overflow_flush(ctx, false);
 		if (io_cqring_events(ctx) >= min_events)
 			return 0;
 		if (!io_run_task_work())
@@ -6844,7 +6837,7 @@ static int io_cqring_wait(struct io_ring_ctx *ctx, int min_events,
 	iowq.nr_timeouts = atomic_read(&ctx->cq_timeouts);
 	trace_io_uring_cqring_wait(ctx, min_events);
 	do {
-		io_cqring_overflow_flush(ctx, false, NULL, NULL);
+		io_cqring_overflow_flush(ctx, false);
 		prepare_to_wait_exclusive(&ctx->wait, &iowq.wq,
 						TASK_INTERRUPTIBLE);
 		ret = io_cqring_wait_schedule(ctx, &iowq, &timeout);
@@ -8444,7 +8437,7 @@ static void io_ring_ctx_wait_and_kill(struct io_ring_ctx *ctx)
 	/* if force is set, the ring is going away. always drop after that */
 	ctx->cq_overflow_flushed = 1;
 	if (ctx->rings)
-		__io_cqring_overflow_flush(ctx, true, NULL, NULL);
+		__io_cqring_overflow_flush(ctx, true);
 	idr_for_each(&ctx->personality_idr, io_remove_personalities, ctx);
 	mutex_unlock(&ctx->uring_lock);
 
@@ -8550,7 +8543,6 @@ static void io_uring_try_cancel_requests(struct io_ring_ctx *ctx,
 		ret |= io_poll_remove_all(ctx, task, files);
 		ret |= io_kill_timeouts(ctx, task, files);
 		ret |= io_run_task_work();
-		io_cqring_overflow_flush(ctx, true, task, files);
 		if (!ret)
 			break;
 		cond_resched();
@@ -9026,7 +9018,7 @@ SYSCALL_DEFINE6(io_uring_enter, unsigned int, fd, u32, to_submit,
 	 */
 	ret = 0;
 	if (ctx->flags & IORING_SETUP_SQPOLL) {
-		io_cqring_overflow_flush(ctx, false, NULL, NULL);
+		io_cqring_overflow_flush(ctx, false);
 
 		ret = -EOWNERDEAD;
 		if (unlikely(ctx->sqo_dead))
-- 
2.24.0

