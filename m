Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 6F84433F587
	for <lists+io-uring@lfdr.de>; Wed, 17 Mar 2021 17:30:47 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232577AbhCQQaQ (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Wed, 17 Mar 2021 12:30:16 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:52908 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232550AbhCQQ3s (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Wed, 17 Mar 2021 12:29:48 -0400
Received: from mail-io1-xd33.google.com (mail-io1-xd33.google.com [IPv6:2607:f8b0:4864:20::d33])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 7C168C06174A
        for <io-uring@vger.kernel.org>; Wed, 17 Mar 2021 09:29:48 -0700 (PDT)
Received: by mail-io1-xd33.google.com with SMTP id o11so41683003iob.1
        for <io-uring@vger.kernel.org>; Wed, 17 Mar 2021 09:29:48 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernel-dk.20150623.gappssmtp.com; s=20150623;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=kpPDvXNpevj8lhojXAQU6JR+4Ed7UPfrgg63kToNCU4=;
        b=gkJOrSFWlSBfHRvuR/kZrrzfOVgWfAULd5abmyqDZFyEAtlRS7YHRx532A+3+rSyst
         //v2OoTBmRMnnV5YC1teiH/2lVeioh51EqYlZWQ08T4qGKdtx5ariGNiqw7bk1x+hTQy
         CsvOP/d8WPnPeOXHQzZqVP6IQs77rFQEl5exivCcnJPwAaONtIUdGnl3l5bHkIjdamPI
         luo0gAEGxkwB6oY3epXsJaM3tmydZbTfFKrjEKe6+z6IjK1bf42HHyNaGL50mqmNvF+i
         lxBiu+bkZvSyaDmEyeI/V+EZBBsYNYWUDL8V81lJtVHSXI04rvRSHWPuxHmVfylVbIPn
         L2wA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=kpPDvXNpevj8lhojXAQU6JR+4Ed7UPfrgg63kToNCU4=;
        b=eZvZ00Z3fhfvYNGBtElu/tr1+8VC7fEw3jdyx+Yn9pX2sME22/4Zzdspfl+kz399zu
         BY82QRZYU3IPEeUPGKC71pDAZ7IT50Oq4EjpsEDg+WOpH7X0AoXojxRi9FDYKoVoOmmw
         j+XTYVkGmhqOLiQ6/SOazR8XVlGUzRZ5FlaS8gNXIU34KEPPWJfUfAhrfBEQ+UMnk3vp
         GBPcMwzgpRxGlt6HvOhpPrYaoAbUmUwkdbu9ZOazJYNWm8Hv+YFsLwSDTkcUP2ITphIx
         wS+l7d7f/+B+9QWHBrxPFfQyjWjBZxEvIA3iUhHz7HcuCZ09cMCzmA19dhecTh+XDhvm
         YkMw==
X-Gm-Message-State: AOAM531OD1zGBh6Lmrbs6+VwVgz7/HPH1DJnR6PfG2N+poM8M9lVJtJa
        Iyi0il5JjCPI641NjAlOoh1MeRXso/Vsaw==
X-Google-Smtp-Source: ABdhPJwkLpeXUdk4UEKaMchVQCqb4alVvAQiXgQR/KWfPLL+/64Z3bVJB9JPjzelJBBKIZM8KEdmtg==
X-Received: by 2002:a02:c017:: with SMTP id y23mr3510136jai.3.1615998587624;
        Wed, 17 Mar 2021 09:29:47 -0700 (PDT)
Received: from p1.localdomain ([65.144.74.34])
        by smtp.gmail.com with ESMTPSA id h1sm11164271ilo.64.2021.03.17.09.29.46
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 17 Mar 2021 09:29:47 -0700 (PDT)
From:   Jens Axboe <axboe@kernel.dk>
To:     io-uring@vger.kernel.org
Cc:     Pavel Begunkov <asml.silence@gmail.com>,
        Jens Axboe <axboe@kernel.dk>
Subject: [PATCH 3/9] io_uring: allocate memory for overflowed CQEs
Date:   Wed, 17 Mar 2021 10:29:37 -0600
Message-Id: <20210317162943.173837-4-axboe@kernel.dk>
X-Mailer: git-send-email 2.31.0
In-Reply-To: <20210317162943.173837-1-axboe@kernel.dk>
References: <20210317162943.173837-1-axboe@kernel.dk>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org

From: Pavel Begunkov <asml.silence@gmail.com>

Instead of using a request itself for overflowed CQE stashing, allocate a
separate entry. The disadvantage is that the allocation may fail and it
will be accounted as lost (see rings->cq_overflow), so we lose reliability
in case of memory pressure if the application is driving the CQ ring into
overflow. However, it opens a way for for multiple CQEs per an SQE and
even generating SQE-less CQEs.

Signed-off-by: Pavel Begunkov <asml.silence@gmail.com>
[axboe: use GFP_ATOMIC | __GFP_ACCOUNT]
Signed-off-by: Jens Axboe <axboe@kernel.dk>
---
 fs/io_uring.c | 99 ++++++++++++++++++++++++---------------------------
 1 file changed, 46 insertions(+), 53 deletions(-)

diff --git a/fs/io_uring.c b/fs/io_uring.c
index dbca1de0be2f..37413a9127b7 100644
--- a/fs/io_uring.c
+++ b/fs/io_uring.c
@@ -203,6 +203,11 @@ struct io_mapped_ubuf {
 
 struct io_ring_ctx;
 
+struct io_overflow_cqe {
+	struct io_uring_cqe cqe;
+	struct list_head list;
+};
+
 struct io_rsrc_put {
 	struct list_head list;
 	union {
@@ -1404,41 +1409,33 @@ static void io_cqring_ev_posted_iopoll(struct io_ring_ctx *ctx)
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
@@ -1453,19 +1450,10 @@ static bool __io_cqring_overflow_flush(struct io_ring_ctx *ctx, bool force,
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
 
-static bool io_cqring_overflow_flush(struct io_ring_ctx *ctx, bool force,
-				     struct task_struct *tsk,
-				     struct files_struct *files)
+static bool io_cqring_overflow_flush(struct io_ring_ctx *ctx, bool force)
 {
 	bool ret = true;
 
@@ -1473,7 +1461,7 @@ static bool io_cqring_overflow_flush(struct io_ring_ctx *ctx, bool force,
 		/* iopoll syncs against uring_lock, not completion_lock */
 		if (ctx->flags & IORING_SETUP_IOPOLL)
 			mutex_lock(&ctx->uring_lock);
-		ret = __io_cqring_overflow_flush(ctx, force, tsk, files);
+		ret = __io_cqring_overflow_flush(ctx, force);
 		if (ctx->flags & IORING_SETUP_IOPOLL)
 			mutex_unlock(&ctx->uring_lock);
 	}
@@ -1534,27 +1522,33 @@ static void __io_cqring_fill_event(struct io_kiocb *req, long res,
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
+		struct io_overflow_cqe *ocqe;
+
+		ocqe = kmalloc(sizeof(*ocqe), GFP_ATOMIC | __GFP_ACCOUNT);
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
-		req_ref_get(req);
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
@@ -2421,7 +2415,7 @@ static int io_iopoll_check(struct io_ring_ctx *ctx, long min)
 		 * already triggered a CQE (eg in error).
 		 */
 		if (test_bit(0, &ctx->cq_check_overflow))
-			__io_cqring_overflow_flush(ctx, false, NULL, NULL);
+			__io_cqring_overflow_flush(ctx, false);
 		if (io_cqring_events(ctx))
 			break;
 
@@ -6608,7 +6602,7 @@ static int io_submit_sqes(struct io_ring_ctx *ctx, unsigned int nr)
 
 	/* if we have a backlog and couldn't flush it all, return BUSY */
 	if (test_bit(0, &ctx->sq_check_overflow)) {
-		if (!__io_cqring_overflow_flush(ctx, false, NULL, NULL))
+		if (!__io_cqring_overflow_flush(ctx, false))
 			return -EBUSY;
 	}
 
@@ -6901,7 +6895,7 @@ static int io_cqring_wait(struct io_ring_ctx *ctx, int min_events,
 	int ret;
 
 	do {
-		io_cqring_overflow_flush(ctx, false, NULL, NULL);
+		io_cqring_overflow_flush(ctx, false);
 		if (io_cqring_events(ctx) >= min_events)
 			return 0;
 		if (!io_run_task_work())
@@ -6933,7 +6927,7 @@ static int io_cqring_wait(struct io_ring_ctx *ctx, int min_events,
 	trace_io_uring_cqring_wait(ctx, min_events);
 	do {
 		/* if we can't even flush overflow, don't wait for more */
-		if (!io_cqring_overflow_flush(ctx, false, NULL, NULL)) {
+		if (!io_cqring_overflow_flush(ctx, false)) {
 			ret = -EBUSY;
 			break;
 		}
@@ -8596,7 +8590,7 @@ static void io_ring_ctx_wait_and_kill(struct io_ring_ctx *ctx)
 	/* if force is set, the ring is going away. always drop after that */
 	ctx->cq_overflow_flushed = 1;
 	if (ctx->rings)
-		__io_cqring_overflow_flush(ctx, true, NULL, NULL);
+		__io_cqring_overflow_flush(ctx, true);
 	xa_for_each(&ctx->personalities, index, creds)
 		io_unregister_personality(ctx, index);
 	mutex_unlock(&ctx->uring_lock);
@@ -8754,7 +8748,6 @@ static void io_uring_try_cancel_requests(struct io_ring_ctx *ctx,
 		ret |= io_kill_timeouts(ctx, task, files);
 		ret |= io_run_task_work();
 		ret |= io_run_ctx_fallback(ctx);
-		io_cqring_overflow_flush(ctx, true, task, files);
 		if (!ret)
 			break;
 		cond_resched();
@@ -9166,7 +9159,7 @@ SYSCALL_DEFINE6(io_uring_enter, unsigned int, fd, u32, to_submit,
 	 */
 	ret = 0;
 	if (ctx->flags & IORING_SETUP_SQPOLL) {
-		io_cqring_overflow_flush(ctx, false, NULL, NULL);
+		io_cqring_overflow_flush(ctx, false);
 
 		ret = -EOWNERDEAD;
 		if (unlikely(ctx->sq_data->thread == NULL)) {
-- 
2.31.0

