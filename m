Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id C320432C9A2
	for <lists+io-uring@lfdr.de>; Thu,  4 Mar 2021 02:19:09 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S239418AbhCDBKE (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Wed, 3 Mar 2021 20:10:04 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:51060 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S241792AbhCDAd5 (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Wed, 3 Mar 2021 19:33:57 -0500
Received: from mail-pf1-x431.google.com (mail-pf1-x431.google.com [IPv6:2607:f8b0:4864:20::431])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 881B0C0611A2
        for <io-uring@vger.kernel.org>; Wed,  3 Mar 2021 16:27:26 -0800 (PST)
Received: by mail-pf1-x431.google.com with SMTP id 192so10535256pfv.0
        for <io-uring@vger.kernel.org>; Wed, 03 Mar 2021 16:27:26 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernel-dk.20150623.gappssmtp.com; s=20150623;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=j/L40xpYzpPBCpZjWQfeZTDBKS7iDk+hknELTUV0LOg=;
        b=x3aaExG/+qf8vRAmIpqAilpklg8pvuuCaoSuLfC/3A+LaWOg1sPip7c//AfvTkge8J
         xPaXE/1tdOww8lUIq9B9wiR6MNi+b72NSnDPQnY0e/zXmVKdlGoF1K+nNgJuG1Dz6yDT
         JAfv+AlpWFv9vx8r6+u4/266+ixTB+IzAIf/znaDmujSTSnNqXq2qVSWxDNJQrJAmWHX
         be+l/OdYl4FOtj9236ldPFXBAdkmJMqtrFOfap5aEBK417Z7jCEY7hbc3XGD+pNr+my8
         8wkdR0CWUadOOCBHuumAKQpqO/igYbhZCpzrf0qTi0urHkrskpXuVVbiuvMd3RyCy+FM
         CbCQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=j/L40xpYzpPBCpZjWQfeZTDBKS7iDk+hknELTUV0LOg=;
        b=EP5lCHU/E+jYvCEOVOcb2jMfnPFtFGoVJ2g1RW2y1rE0I2Z/KCWJPpqQt88vFcrkhT
         Uwkq1SZiXw/t2bhhIkipA6VEIy9di/DJPHpbcWzlZUWzBPPuOtdjjp9K10jJeYFxwrfd
         6cU4NcOQGIL1X3TGVA4Q0m9fvjDuEy3Co9raanEZEh8RpjUoL1ka8BfB2Eyh554RiJBo
         ab1fsgUoIjmnq/uKpE8vRGbBuMfEzKit6qlg0OElL3eAN1ed34725WJFSeduGEfITAA5
         sKGOolkW2fzotsoKTE0i/s/TSlztidmulZH+kUwMwuGn57mqOV1dSslhlXxavOJ4T+lq
         0RjA==
X-Gm-Message-State: AOAM533oZmo9hP4mFQy+bvrDbVr4iW8oyYivdUTNvNWktTZknOn7X11d
        z5jC+xXXNUggk+VZA2fqronBz/uC2JFjYJIm
X-Google-Smtp-Source: ABdhPJwkvh5YeyFiA8SR+F6CojX4v73PTLsKOQUKT/Cxh4elX0H0bPL0H4CgwndVaoSxsy5nRpI3DQ==
X-Received: by 2002:aa7:8719:0:b029:1ef:365:90a2 with SMTP id b25-20020aa787190000b02901ef036590a2mr1358925pfo.38.1614817645645;
        Wed, 03 Mar 2021 16:27:25 -0800 (PST)
Received: from localhost.localdomain ([2600:380:7540:52b5:3f01:150c:3b2:bf47])
        by smtp.gmail.com with ESMTPSA id b6sm23456983pgt.69.2021.03.03.16.27.24
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 03 Mar 2021 16:27:25 -0800 (PST)
From:   Jens Axboe <axboe@kernel.dk>
To:     io-uring@vger.kernel.org
Cc:     Jens Axboe <axboe@kernel.dk>,
        Pavel Begunkov <asml.silence@gmail.com>
Subject: [PATCH 17/33] io_uring: move cred assignment into io_issue_sqe()
Date:   Wed,  3 Mar 2021 17:26:44 -0700
Message-Id: <20210304002700.374417-18-axboe@kernel.dk>
X-Mailer: git-send-email 2.30.1
In-Reply-To: <20210304002700.374417-1-axboe@kernel.dk>
References: <20210304002700.374417-1-axboe@kernel.dk>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org

If we move it in there, then we no longer have to care about it in io-wq.
This means we can drop the cred handling in io-wq, and we can drop the
REQ_F_WORK_INITIALIZED flag and async init functions as that was the last
user of it since we moved to the new workers. Then we can also drop
io_wq_work->creds, and just hold the personality u16 in there instead.

Suggested-by: Pavel Begunkov <asml.silence@gmail.com>
Signed-off-by: Jens Axboe <axboe@kernel.dk>
---
 fs/io-wq.c    | 26 ------------------
 fs/io-wq.h    |  2 +-
 fs/io_uring.c | 75 +++++++++++++++------------------------------------
 3 files changed, 22 insertions(+), 81 deletions(-)

diff --git a/fs/io-wq.c b/fs/io-wq.c
index c24473231eee..327e390bc0c2 100644
--- a/fs/io-wq.c
+++ b/fs/io-wq.c
@@ -52,9 +52,6 @@ struct io_worker {
 	struct io_wq_work *cur_work;
 	spinlock_t lock;
 
-	const struct cred *cur_creds;
-	const struct cred *saved_creds;
-
 	struct completion ref_done;
 	struct completion started;
 
@@ -180,11 +177,6 @@ static void io_worker_exit(struct io_worker *worker)
 	worker->flags = 0;
 	preempt_enable();
 
-	if (worker->saved_creds) {
-		revert_creds(worker->saved_creds);
-		worker->cur_creds = worker->saved_creds = NULL;
-	}
-
 	raw_spin_lock_irq(&wqe->lock);
 	if (flags & IO_WORKER_F_FREE)
 		hlist_nulls_del_rcu(&worker->nulls_node);
@@ -326,10 +318,6 @@ static void __io_worker_idle(struct io_wqe *wqe, struct io_worker *worker)
 		worker->flags |= IO_WORKER_F_FREE;
 		hlist_nulls_add_head_rcu(&worker->nulls_node, &wqe->free_list);
 	}
-	if (worker->saved_creds) {
-		revert_creds(worker->saved_creds);
-		worker->cur_creds = worker->saved_creds = NULL;
-	}
 }
 
 static inline unsigned int io_get_work_hash(struct io_wq_work *work)
@@ -404,18 +392,6 @@ static void io_flush_signals(void)
 	}
 }
 
-static void io_wq_switch_creds(struct io_worker *worker,
-			       struct io_wq_work *work)
-{
-	const struct cred *old_creds = override_creds(work->creds);
-
-	worker->cur_creds = work->creds;
-	if (worker->saved_creds)
-		put_cred(old_creds); /* creds set by previous switch */
-	else
-		worker->saved_creds = old_creds;
-}
-
 static void io_assign_current_work(struct io_worker *worker,
 				   struct io_wq_work *work)
 {
@@ -465,8 +441,6 @@ static void io_worker_handle_work(struct io_worker *worker)
 			unsigned int hash = io_get_work_hash(work);
 
 			next_hashed = wq_next_work(work);
-			if (work->creds && worker->cur_creds != work->creds)
-				io_wq_switch_creds(worker, work);
 			wq->do_work(work);
 			io_assign_current_work(worker, NULL);
 
diff --git a/fs/io-wq.h b/fs/io-wq.h
index 57e478af1e1d..024a5f5f03af 100644
--- a/fs/io-wq.h
+++ b/fs/io-wq.h
@@ -79,8 +79,8 @@ static inline void wq_list_del(struct io_wq_work_list *list,
 
 struct io_wq_work {
 	struct io_wq_work_node list;
-	const struct cred *creds;
 	unsigned flags;
+	unsigned short personality;
 };
 
 static inline struct io_wq_work *wq_next_work(struct io_wq_work *work)
diff --git a/fs/io_uring.c b/fs/io_uring.c
index 3bd9198c5a86..7d309795d910 100644
--- a/fs/io_uring.c
+++ b/fs/io_uring.c
@@ -688,7 +688,6 @@ enum {
 	REQ_F_POLLED_BIT,
 	REQ_F_BUFFER_SELECTED_BIT,
 	REQ_F_NO_FILE_TABLE_BIT,
-	REQ_F_WORK_INITIALIZED_BIT,
 	REQ_F_LTIMEOUT_ACTIVE_BIT,
 	REQ_F_COMPLETE_INLINE_BIT,
 
@@ -730,8 +729,6 @@ enum {
 	REQ_F_BUFFER_SELECTED	= BIT(REQ_F_BUFFER_SELECTED_BIT),
 	/* doesn't need file table for this request */
 	REQ_F_NO_FILE_TABLE	= BIT(REQ_F_NO_FILE_TABLE_BIT),
-	/* io_wq_work is initialized */
-	REQ_F_WORK_INITIALIZED	= BIT(REQ_F_WORK_INITIALIZED_BIT),
 	/* linked timeout is active, i.e. prepared by link's head */
 	REQ_F_LTIMEOUT_ACTIVE	= BIT(REQ_F_LTIMEOUT_ACTIVE_BIT),
 	/* completion is deferred through io_comp_state */
@@ -1094,24 +1091,6 @@ static inline void req_set_fail_links(struct io_kiocb *req)
 		req->flags |= REQ_F_FAIL_LINK;
 }
 
-static inline void __io_req_init_async(struct io_kiocb *req)
-{
-	memset(&req->work, 0, sizeof(req->work));
-	req->flags |= REQ_F_WORK_INITIALIZED;
-}
-
-/*
- * Note: must call io_req_init_async() for the first time you
- * touch any members of io_wq_work.
- */
-static inline void io_req_init_async(struct io_kiocb *req)
-{
-	if (req->flags & REQ_F_WORK_INITIALIZED)
-		return;
-
-	__io_req_init_async(req);
-}
-
 static void io_ring_ctx_ref_free(struct percpu_ref *ref)
 {
 	struct io_ring_ctx *ctx = container_of(ref, struct io_ring_ctx, refs);
@@ -1196,13 +1175,6 @@ static bool req_need_defer(struct io_kiocb *req, u32 seq)
 
 static void io_req_clean_work(struct io_kiocb *req)
 {
-	if (!(req->flags & REQ_F_WORK_INITIALIZED))
-		return;
-
-	if (req->work.creds) {
-		put_cred(req->work.creds);
-		req->work.creds = NULL;
-	}
 	if (req->flags & REQ_F_INFLIGHT) {
 		struct io_ring_ctx *ctx = req->ctx;
 		struct io_uring_task *tctx = req->task->io_uring;
@@ -1215,8 +1187,6 @@ static void io_req_clean_work(struct io_kiocb *req)
 		if (atomic_read(&tctx->in_idle))
 			wake_up(&tctx->wait);
 	}
-
-	req->flags &= ~REQ_F_WORK_INITIALIZED;
 }
 
 static void io_req_track_inflight(struct io_kiocb *req)
@@ -1224,7 +1194,6 @@ static void io_req_track_inflight(struct io_kiocb *req)
 	struct io_ring_ctx *ctx = req->ctx;
 
 	if (!(req->flags & REQ_F_INFLIGHT)) {
-		io_req_init_async(req);
 		req->flags |= REQ_F_INFLIGHT;
 
 		spin_lock_irq(&ctx->inflight_lock);
@@ -1238,8 +1207,6 @@ static void io_prep_async_work(struct io_kiocb *req)
 	const struct io_op_def *def = &io_op_defs[req->opcode];
 	struct io_ring_ctx *ctx = req->ctx;
 
-	io_req_init_async(req);
-
 	if (req->flags & REQ_F_FORCE_ASYNC)
 		req->work.flags |= IO_WQ_WORK_CONCURRENT;
 
@@ -1250,8 +1217,6 @@ static void io_prep_async_work(struct io_kiocb *req)
 		if (def->unbound_nonreg_file)
 			req->work.flags |= IO_WQ_WORK_UNBOUND;
 	}
-	if (!req->work.creds)
-		req->work.creds = get_current_cred();
 }
 
 static void io_prep_async_link(struct io_kiocb *req)
@@ -3578,7 +3543,6 @@ static int __io_splice_prep(struct io_kiocb *req,
 		 * Splice operation will be punted aync, and here need to
 		 * modify io_wq_work.flags, so initialize io_wq_work firstly.
 		 */
-		io_req_init_async(req);
 		req->work.flags |= IO_WQ_WORK_UNBOUND;
 	}
 
@@ -5935,8 +5899,22 @@ static void __io_clean_op(struct io_kiocb *req)
 static int io_issue_sqe(struct io_kiocb *req, unsigned int issue_flags)
 {
 	struct io_ring_ctx *ctx = req->ctx;
+	const struct cred *creds = NULL;
 	int ret;
 
+	if (req->work.personality) {
+		const struct cred *new_creds;
+
+		if (!(issue_flags & IO_URING_F_NONBLOCK))
+			mutex_lock(&ctx->uring_lock);
+		new_creds = idr_find(&ctx->personality_idr, req->work.personality);
+		if (!(issue_flags & IO_URING_F_NONBLOCK))
+			mutex_unlock(&ctx->uring_lock);
+		if (!new_creds)
+			return -EINVAL;
+		creds = override_creds(new_creds);
+	}
+
 	switch (req->opcode) {
 	case IORING_OP_NOP:
 		ret = io_nop(req, issue_flags);
@@ -6043,6 +6021,9 @@ static int io_issue_sqe(struct io_kiocb *req, unsigned int issue_flags)
 		break;
 	}
 
+	if (creds)
+		revert_creds(creds);
+
 	if (ret)
 		return ret;
 
@@ -6206,18 +6187,10 @@ static struct io_kiocb *io_prep_linked_timeout(struct io_kiocb *req)
 static void __io_queue_sqe(struct io_kiocb *req)
 {
 	struct io_kiocb *linked_timeout = io_prep_linked_timeout(req);
-	const struct cred *old_creds = NULL;
 	int ret;
 
-	if ((req->flags & REQ_F_WORK_INITIALIZED) && req->work.creds &&
-	    req->work.creds != current_cred())
-		old_creds = override_creds(req->work.creds);
-
 	ret = io_issue_sqe(req, IO_URING_F_NONBLOCK|IO_URING_F_COMPLETE_DEFER);
 
-	if (old_creds)
-		revert_creds(old_creds);
-
 	/*
 	 * We async punt it if the file wasn't marked NOWAIT, or if the file
 	 * doesn't support non-blocking read/write attempts
@@ -6304,7 +6277,7 @@ static int io_init_req(struct io_ring_ctx *ctx, struct io_kiocb *req,
 {
 	struct io_submit_state *state;
 	unsigned int sqe_flags;
-	int id, ret = 0;
+	int ret = 0;
 
 	req->opcode = READ_ONCE(sqe->opcode);
 	/* same numerical values with corresponding REQ_F_*, safe to copy */
@@ -6336,15 +6309,9 @@ static int io_init_req(struct io_ring_ctx *ctx, struct io_kiocb *req,
 	    !io_op_defs[req->opcode].buffer_select)
 		return -EOPNOTSUPP;
 
-	id = READ_ONCE(sqe->personality);
-	if (id) {
-		__io_req_init_async(req);
-		req->work.creds = idr_find(&ctx->personality_idr, id);
-		if (unlikely(!req->work.creds))
-			return -EINVAL;
-		get_cred(req->work.creds);
-	}
-
+	req->work.list.next = NULL;
+	req->work.flags = 0;
+	req->work.personality = READ_ONCE(sqe->personality);
 	state = &ctx->submit_state;
 
 	/*
-- 
2.30.1

