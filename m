Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 7911E550DDF
	for <lists+io-uring@lfdr.de>; Mon, 20 Jun 2022 02:29:25 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S237280AbiFTA0k (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Sun, 19 Jun 2022 20:26:40 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:34960 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S237272AbiFTA0i (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Sun, 19 Jun 2022 20:26:38 -0400
Received: from mail-wr1-x42b.google.com (mail-wr1-x42b.google.com [IPv6:2a00:1450:4864:20::42b])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 7AA21A1B0
        for <io-uring@vger.kernel.org>; Sun, 19 Jun 2022 17:26:37 -0700 (PDT)
Received: by mail-wr1-x42b.google.com with SMTP id q9so12469261wrd.8
        for <io-uring@vger.kernel.org>; Sun, 19 Jun 2022 17:26:37 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=Z2uPrsk7BEZP8sHdJzPwYohfCoy3RRkhF5HGc7u3Tgc=;
        b=NO5q4vnfRZgc0MZh8SNifkQ/fs3EPGkZr4JN0LeBuFhvliZ8/z8a3HXmdpcIrsgaz8
         i8DW2UgplxaCcqp1UQAIxM9Ygg/ZUNGNx1p1FL0L+nnwfQYvqiJ8wWM6bB0MwZRbFFz1
         Wdekh7ji2i/11zYkCsekwuFKFLXZ9Gmwwpbrq1Fuufg4O1lmGAKCWDbRC2mLMbnc8iZ2
         HYMxC8m9Ru2zDRu1tQjIbapca+bZJBeaPhl/T4kbz5QxkD2pKKxrX1KzTeb2YmK7VQH0
         EM1+KO7H0T0PfSNvsIJBvBGFw/byCpRPP4yyGND0gzw/Nn/OBozqrIsscAZCXtluh5zi
         NhoA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=Z2uPrsk7BEZP8sHdJzPwYohfCoy3RRkhF5HGc7u3Tgc=;
        b=Em9pZaQzJcOVpBYR3KtN8V4T43MlcEk6icAJvXedxA3+ofQrmokSZsbCHZbsunLOkO
         sE9Kfo3x92GnoicKhXbnsqum7GO2NInNJqe0uvfBTcD+it9pLbrbGJdx7D1gBVH9VplG
         59vTQv9LqEskfY+e565meLWnBIc1pj6Ol7v5V8j94VvJ7+7AjAMZgkmbKk0r/xTaZ6ze
         wqcnb6AMMqcY9mA+59a9GyWLd1nHTIVj9IVU4zERg6vKGzV3OmyUwDEwAKeTHvCnWcu/
         BgSLFk9xgF96eQOe0NPL1uTEgcJ+lyloX9TdjxVCjTYfirh9w7mxd+pZcX0qiVU6V0kQ
         qlYA==
X-Gm-Message-State: AJIora+OkCpVs5I7JlNlSQw5UYXDPk52tF7HVx8jKVzBqk+Rmy7iLK9X
        B064RUi+eLQIqlpdvnRhgBFCJ4qC8LJstg==
X-Google-Smtp-Source: AGRyM1u2lUOYo6uIC27D3KtiVtmc4ls3+KViZwrDvu2w5EjfnwmzEs2QThs69GcM5L1QcUXlckl/nw==
X-Received: by 2002:a05:6000:168c:b0:218:4523:c975 with SMTP id y12-20020a056000168c00b002184523c975mr19922370wrd.23.1655684795691;
        Sun, 19 Jun 2022 17:26:35 -0700 (PDT)
Received: from 127.0.0.1localhost (188.28.125.106.threembb.co.uk. [188.28.125.106])
        by smtp.gmail.com with ESMTPSA id h18-20020a5d4312000000b002167efdd549sm11543807wrq.38.2022.06.19.17.26.34
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sun, 19 Jun 2022 17:26:35 -0700 (PDT)
From:   Pavel Begunkov <asml.silence@gmail.com>
To:     io-uring@vger.kernel.org
Cc:     Jens Axboe <axboe@kernel.dk>, asml.silence@gmail.com
Subject: [PATCH for-next 05/10] io_uring: introduce locking helpers for CQE posting
Date:   Mon, 20 Jun 2022 01:25:56 +0100
Message-Id: <fe0c682bf7f7b55d9be55b0d034be9c1949277dc.1655684496.git.asml.silence@gmail.com>
X-Mailer: git-send-email 2.36.1
In-Reply-To: <cover.1655684496.git.asml.silence@gmail.com>
References: <cover.1655684496.git.asml.silence@gmail.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_FROM,
        RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org

spin_lock(&ctx->completion_lock);
/* post CQEs */
io_commit_cqring(ctx);
spin_unlock(&ctx->completion_lock);
io_cqring_ev_posted(ctx);

We have many places repeating this sequence, and the three function
unlock section is not perfect from the maintainance perspective and also
makes harder to add new locking/sync trick.

Introduce to helpers. io_cq_lock(), which is simple and only grabs
->completion_lock, and io_cq_unlock_post() encapsulating the three call
section.

Signed-off-by: Pavel Begunkov <asml.silence@gmail.com>
---
 io_uring/io_uring.c | 57 +++++++++++++++++++++------------------------
 io_uring/io_uring.h |  9 ++++++-
 io_uring/timeout.c  |  6 ++---
 3 files changed, 36 insertions(+), 36 deletions(-)

diff --git a/io_uring/io_uring.c b/io_uring/io_uring.c
index ded42d884c49..82a9e4e2a3e2 100644
--- a/io_uring/io_uring.c
+++ b/io_uring/io_uring.c
@@ -527,7 +527,7 @@ void __io_commit_cqring_flush(struct io_ring_ctx *ctx)
 		io_eventfd_signal(ctx);
 }
 
-void io_cqring_ev_posted(struct io_ring_ctx *ctx)
+static inline void io_cqring_ev_posted(struct io_ring_ctx *ctx)
 {
 	if (unlikely(ctx->off_timeout_used || ctx->drain_active ||
 		     ctx->has_evfd))
@@ -536,6 +536,19 @@ void io_cqring_ev_posted(struct io_ring_ctx *ctx)
 	io_cqring_wake(ctx);
 }
 
+static inline void __io_cq_unlock_post(struct io_ring_ctx *ctx)
+	__releases(ctx->completion_lock)
+{
+	io_commit_cqring(ctx);
+	spin_unlock(&ctx->completion_lock);
+	io_cqring_ev_posted(ctx);
+}
+
+void io_cq_unlock_post(struct io_ring_ctx *ctx)
+{
+	__io_cq_unlock_post(ctx);
+}
+
 /* Returns true if there are no backlogged entries after the flush */
 static bool __io_cqring_overflow_flush(struct io_ring_ctx *ctx, bool force)
 {
@@ -548,7 +561,7 @@ static bool __io_cqring_overflow_flush(struct io_ring_ctx *ctx, bool force)
 	if (ctx->flags & IORING_SETUP_CQE32)
 		cqe_size <<= 1;
 
-	spin_lock(&ctx->completion_lock);
+	io_cq_lock(ctx);
 	while (!list_empty(&ctx->cq_overflow_list)) {
 		struct io_uring_cqe *cqe = io_get_cqe(ctx);
 		struct io_overflow_cqe *ocqe;
@@ -572,9 +585,7 @@ static bool __io_cqring_overflow_flush(struct io_ring_ctx *ctx, bool force)
 		atomic_andnot(IORING_SQ_CQ_OVERFLOW, &ctx->rings->sq_flags);
 	}
 
-	io_commit_cqring(ctx);
-	spin_unlock(&ctx->completion_lock);
-	io_cqring_ev_posted(ctx);
+	io_cq_unlock_post(ctx);
 	return all_flushed;
 }
 
@@ -760,11 +771,9 @@ bool io_post_aux_cqe(struct io_ring_ctx *ctx,
 {
 	bool filled;
 
-	spin_lock(&ctx->completion_lock);
+	io_cq_lock(ctx);
 	filled = io_fill_cqe_aux(ctx, user_data, res, cflags);
-	io_commit_cqring(ctx);
-	spin_unlock(&ctx->completion_lock);
-	io_cqring_ev_posted(ctx);
+	io_cq_unlock_post(ctx);
 	return filled;
 }
 
@@ -810,11 +819,9 @@ void io_req_complete_post(struct io_kiocb *req)
 {
 	struct io_ring_ctx *ctx = req->ctx;
 
-	spin_lock(&ctx->completion_lock);
+	io_cq_lock(ctx);
 	__io_req_complete_post(req);
-	io_commit_cqring(ctx);
-	spin_unlock(&ctx->completion_lock);
-	io_cqring_ev_posted(ctx);
+	io_cq_unlock_post(ctx);
 }
 
 inline void __io_req_complete(struct io_kiocb *req, unsigned issue_flags)
@@ -946,11 +953,9 @@ static void __io_req_find_next_prep(struct io_kiocb *req)
 {
 	struct io_ring_ctx *ctx = req->ctx;
 
-	spin_lock(&ctx->completion_lock);
+	io_cq_lock(ctx);
 	io_disarm_next(req);
-	io_commit_cqring(ctx);
-	spin_unlock(&ctx->completion_lock);
-	io_cqring_ev_posted(ctx);
+	io_cq_unlock_post(ctx);
 }
 
 static inline struct io_kiocb *io_req_find_next(struct io_kiocb *req)
@@ -984,13 +989,6 @@ static void ctx_flush_and_put(struct io_ring_ctx *ctx, bool *locked)
 	percpu_ref_put(&ctx->refs);
 }
 
-static inline void ctx_commit_and_unlock(struct io_ring_ctx *ctx)
-{
-	io_commit_cqring(ctx);
-	spin_unlock(&ctx->completion_lock);
-	io_cqring_ev_posted(ctx);
-}
-
 static void handle_prev_tw_list(struct io_wq_work_node *node,
 				struct io_ring_ctx **ctx, bool *uring_locked)
 {
@@ -1006,7 +1004,7 @@ static void handle_prev_tw_list(struct io_wq_work_node *node,
 
 		if (req->ctx != *ctx) {
 			if (unlikely(!*uring_locked && *ctx))
-				ctx_commit_and_unlock(*ctx);
+				io_cq_unlock_post(*ctx);
 
 			ctx_flush_and_put(*ctx, uring_locked);
 			*ctx = req->ctx;
@@ -1014,7 +1012,7 @@ static void handle_prev_tw_list(struct io_wq_work_node *node,
 			*uring_locked = mutex_trylock(&(*ctx)->uring_lock);
 			percpu_ref_get(&(*ctx)->refs);
 			if (unlikely(!*uring_locked))
-				spin_lock(&(*ctx)->completion_lock);
+				io_cq_lock(*ctx);
 		}
 		if (likely(*uring_locked)) {
 			req->io_task_work.func(req, uring_locked);
@@ -1026,7 +1024,7 @@ static void handle_prev_tw_list(struct io_wq_work_node *node,
 	} while (node);
 
 	if (unlikely(!*uring_locked))
-		ctx_commit_and_unlock(*ctx);
+		io_cq_unlock_post(*ctx);
 }
 
 static void handle_tw_list(struct io_wq_work_node *node,
@@ -1261,10 +1259,7 @@ static void __io_submit_flush_completions(struct io_ring_ctx *ctx)
 		if (!(req->flags & REQ_F_CQE_SKIP))
 			__io_fill_cqe_req(ctx, req);
 	}
-
-	io_commit_cqring(ctx);
-	spin_unlock(&ctx->completion_lock);
-	io_cqring_ev_posted(ctx);
+	__io_cq_unlock_post(ctx);
 
 	io_free_batch_list(ctx, state->compl_reqs.first);
 	INIT_WQ_LIST(&state->compl_reqs);
diff --git a/io_uring/io_uring.h b/io_uring/io_uring.h
index bdc62727638b..738fb96575ab 100644
--- a/io_uring/io_uring.h
+++ b/io_uring/io_uring.h
@@ -24,7 +24,6 @@ void __io_req_complete(struct io_kiocb *req, unsigned issue_flags);
 void io_req_complete_post(struct io_kiocb *req);
 void __io_req_complete_post(struct io_kiocb *req);
 bool io_post_aux_cqe(struct io_ring_ctx *ctx, u64 user_data, s32 res, u32 cflags);
-void io_cqring_ev_posted(struct io_ring_ctx *ctx);
 void __io_commit_cqring_flush(struct io_ring_ctx *ctx);
 
 struct page **io_pin_pages(unsigned long ubuf, unsigned long len, int *npages);
@@ -66,6 +65,14 @@ bool io_match_task_safe(struct io_kiocb *head, struct task_struct *task,
 #define io_for_each_link(pos, head) \
 	for (pos = (head); pos; pos = pos->link)
 
+static inline void io_cq_lock(struct io_ring_ctx *ctx)
+	__acquires(ctx->completion_lock)
+{
+	spin_lock(&ctx->completion_lock);
+}
+
+void io_cq_unlock_post(struct io_ring_ctx *ctx);
+
 static inline struct io_uring_cqe *io_get_cqe(struct io_ring_ctx *ctx)
 {
 	if (likely(ctx->cqe_cached < ctx->cqe_sentinel)) {
diff --git a/io_uring/timeout.c b/io_uring/timeout.c
index 424b2fc858b8..7e2c341f9762 100644
--- a/io_uring/timeout.c
+++ b/io_uring/timeout.c
@@ -617,7 +617,7 @@ __cold bool io_kill_timeouts(struct io_ring_ctx *ctx, struct task_struct *tsk,
 	struct io_timeout *timeout, *tmp;
 	int canceled = 0;
 
-	spin_lock(&ctx->completion_lock);
+	io_cq_lock(ctx);
 	spin_lock_irq(&ctx->timeout_lock);
 	list_for_each_entry_safe(timeout, tmp, &ctx->timeout_list, list) {
 		struct io_kiocb *req = cmd_to_io_kiocb(timeout);
@@ -627,8 +627,6 @@ __cold bool io_kill_timeouts(struct io_ring_ctx *ctx, struct task_struct *tsk,
 			canceled++;
 	}
 	spin_unlock_irq(&ctx->timeout_lock);
-	io_commit_cqring(ctx);
-	spin_unlock(&ctx->completion_lock);
-	io_cqring_ev_posted(ctx);
+	io_cq_unlock_post(ctx);
 	return canceled != 0;
 }
-- 
2.36.1

