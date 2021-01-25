Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id AD1C7304A3F
	for <lists+io-uring@lfdr.de>; Tue, 26 Jan 2021 21:39:27 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726819AbhAZFKV (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Tue, 26 Jan 2021 00:10:21 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:42886 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727774AbhAYMKU (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Mon, 25 Jan 2021 07:10:20 -0500
Received: from mail-wr1-x42d.google.com (mail-wr1-x42d.google.com [IPv6:2a00:1450:4864:20::42d])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id A2D77C061226
        for <io-uring@vger.kernel.org>; Mon, 25 Jan 2021 03:46:17 -0800 (PST)
Received: by mail-wr1-x42d.google.com with SMTP id d16so11362631wro.11
        for <io-uring@vger.kernel.org>; Mon, 25 Jan 2021 03:46:17 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:subject:date:message-id:in-reply-to:references:mime-version
         :content-transfer-encoding;
        bh=E7Kb/DvOca0pgAeCKEcd9WG8kVkAt5KYzWbyP/P1aJI=;
        b=lXYu/ltqqXol3N4GR0Yc0AleVgagf8YUBVQqJDjjm7nrsUklydGYMX7PoBc1SNvU6T
         SIbi7i7oNM4GSPNTBiIVxiltmZ8A1ps9oDcOI+dWZTgiAQ804CU++VzPJGpdryBPkLvz
         y6b41ed10N/m8LxUMtHnzxxSbN9nIhtxCcTbhRdP/7ILhbZ+50OEh7w2fB9zrWsvTx8F
         KODto7BhXt63d3VEjspBySIYyUrojbgAIjvLaYZvAsynX4/aO3Q57eYlVWfpptQRqyvT
         XRqMQkEBAK1YwSrwl8u5gq8mi5eX9Eqt+6JNlHC8X/traj6+FaGzj4cBGhU4tQ0c4HP9
         LpSw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=E7Kb/DvOca0pgAeCKEcd9WG8kVkAt5KYzWbyP/P1aJI=;
        b=FHCoV7O3f30cbwlwXmwjiZaNNPXxDDLFcyOsM9+v6eiH9tcwv4w5bZDw1DMmrO0fcQ
         n4iO7EmS7PUfOi9HXW8zQG22cb8KJ0ygUoEoPnlhf+uKKP883Sir+D8jQksFODeNMy6X
         4LnVEVkTB5Fvxn2Pgb82+GF2zIxNfMr7MPrUmtPvHfShtQPvbRvb4/hdFkqE2DJpgWrS
         ilhsnHaIp89K7wD/FQndVVHtgG/0YqR+zhBDf8yj1PXGp4bACcsaLbmA5KH2Ag/He9Tu
         6Hd4wK0ELvPWafyYJdjL1Y5PnH5OjLbYJDVpF1vueMM/zWheKjHOfS+zz5SJJm/+/mRv
         3mkQ==
X-Gm-Message-State: AOAM531AIy+jLA66sILC0mLvnTV4B07AnYRA13jq4SgYLziKyb5s0Irz
        ISjxG3lnkhOM3eAHh2iJrrg=
X-Google-Smtp-Source: ABdhPJzHNIlWcxYlOFvEqkYLiAuF6PufDVQ5Pn3QF3VgJGwQ92iGSgJ5YZ4EDREmkSA5w+FadDQs+g==
X-Received: by 2002:adf:f452:: with SMTP id f18mr476985wrp.11.1611575176455;
        Mon, 25 Jan 2021 03:46:16 -0800 (PST)
Received: from localhost.localdomain ([85.255.234.11])
        by smtp.gmail.com with ESMTPSA id a6sm12571433wru.66.2021.01.25.03.46.15
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 25 Jan 2021 03:46:16 -0800 (PST)
From:   Pavel Begunkov <asml.silence@gmail.com>
To:     Jens Axboe <axboe@kernel.dk>, io-uring@vger.kernel.org
Subject: [PATCH 3/8] io_uring: don't keep submit_state on stack
Date:   Mon, 25 Jan 2021 11:42:22 +0000
Message-Id: <dc52b7b5761ad78f0883ec7ca433c0a8d7089285.1611573970.git.asml.silence@gmail.com>
X-Mailer: git-send-email 2.24.0
In-Reply-To: <cover.1611573970.git.asml.silence@gmail.com>
References: <cover.1611573970.git.asml.silence@gmail.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org

struct io_submit_state is quite big (168 bytes) and going to grow. It's
better to not keep it on stack as it is now. Move it to context, it's
always protected by uring_lock, so it's fine to have only one instance
of it.

Signed-off-by: Pavel Begunkov <asml.silence@gmail.com>
---
 fs/io_uring.c | 90 ++++++++++++++++++++++++++-------------------------
 1 file changed, 46 insertions(+), 44 deletions(-)

diff --git a/fs/io_uring.c b/fs/io_uring.c
index fa421555ab8b..9ba33ee08d2a 100644
--- a/fs/io_uring.c
+++ b/fs/io_uring.c
@@ -259,6 +259,39 @@ struct io_sq_data {
 	unsigned		sq_thread_idle;
 };
 
+#define IO_IOPOLL_BATCH			8
+
+struct io_comp_state {
+	unsigned int		nr;
+	struct list_head	list;
+	struct io_ring_ctx	*ctx;
+};
+
+struct io_submit_state {
+	struct blk_plug		plug;
+
+	/*
+	 * io_kiocb alloc cache
+	 */
+	void			*reqs[IO_IOPOLL_BATCH];
+	unsigned int		free_reqs;
+
+	bool			plug_started;
+
+	/*
+	 * Batch completion logic
+	 */
+	struct io_comp_state	comp;
+
+	/*
+	 * File reference cache
+	 */
+	struct file		*file;
+	unsigned int		fd;
+	unsigned int		file_refs;
+	unsigned int		ios_left;
+};
+
 struct io_ring_ctx {
 	struct {
 		struct percpu_ref	refs;
@@ -401,6 +434,7 @@ struct io_ring_ctx {
 
 	struct work_struct		exit_work;
 	struct io_restriction		restrictions;
+	struct io_submit_state		submit_state;
 };
 
 /*
@@ -752,39 +786,6 @@ struct io_defer_entry {
 	u32			seq;
 };
 
-#define IO_IOPOLL_BATCH			8
-
-struct io_comp_state {
-	unsigned int		nr;
-	struct list_head	list;
-	struct io_ring_ctx	*ctx;
-};
-
-struct io_submit_state {
-	struct blk_plug		plug;
-
-	/*
-	 * io_kiocb alloc cache
-	 */
-	void			*reqs[IO_IOPOLL_BATCH];
-	unsigned int		free_reqs;
-
-	bool			plug_started;
-
-	/*
-	 * Batch completion logic
-	 */
-	struct io_comp_state	comp;
-
-	/*
-	 * File reference cache
-	 */
-	struct file		*file;
-	unsigned int		fd;
-	unsigned int		file_refs;
-	unsigned int		ios_left;
-};
-
 struct io_op_def {
 	/* needs req->file assigned */
 	unsigned		needs_file : 1;
@@ -1965,9 +1966,10 @@ static struct io_kiocb *io_get_fallback_req(struct io_ring_ctx *ctx)
 	return NULL;
 }
 
-static struct io_kiocb *io_alloc_req(struct io_ring_ctx *ctx,
-				     struct io_submit_state *state)
+static struct io_kiocb *io_alloc_req(struct io_ring_ctx *ctx)
 {
+	struct io_submit_state *state = &ctx->submit_state;
+
 	if (!state->free_reqs) {
 		gfp_t gfp = GFP_KERNEL | __GFP_NOWARN;
 		size_t sz;
@@ -6800,9 +6802,9 @@ static inline bool io_check_restriction(struct io_ring_ctx *ctx,
 				IOSQE_BUFFER_SELECT)
 
 static int io_init_req(struct io_ring_ctx *ctx, struct io_kiocb *req,
-		       const struct io_uring_sqe *sqe,
-		       struct io_submit_state *state)
+		       const struct io_uring_sqe *sqe)
 {
+	struct io_submit_state *state;
 	unsigned int sqe_flags;
 	int id, ret;
 
@@ -6854,6 +6856,7 @@ static int io_init_req(struct io_ring_ctx *ctx, struct io_kiocb *req,
 
 	/* same numerical values with corresponding REQ_F_*, safe to copy */
 	req->flags |= sqe_flags;
+	state = &ctx->submit_state;
 
 	/*
 	 * Plug now if we have more than 1 IO left after this, and the target
@@ -6881,7 +6884,6 @@ static int io_init_req(struct io_ring_ctx *ctx, struct io_kiocb *req,
 
 static int io_submit_sqes(struct io_ring_ctx *ctx, unsigned int nr)
 {
-	struct io_submit_state state;
 	struct io_submit_link link;
 	int i, submitted = 0;
 
@@ -6900,7 +6902,7 @@ static int io_submit_sqes(struct io_ring_ctx *ctx, unsigned int nr)
 	percpu_counter_add(&current->io_uring->inflight, nr);
 	refcount_add(nr, &current->usage);
 
-	io_submit_state_start(&state, ctx, nr);
+	io_submit_state_start(&ctx->submit_state, ctx, nr);
 	link.head = NULL;
 
 	for (i = 0; i < nr; i++) {
@@ -6913,7 +6915,7 @@ static int io_submit_sqes(struct io_ring_ctx *ctx, unsigned int nr)
 			io_consume_sqe(ctx);
 			break;
 		}
-		req = io_alloc_req(ctx, &state);
+		req = io_alloc_req(ctx);
 		if (unlikely(!req)) {
 			if (!submitted)
 				submitted = -EAGAIN;
@@ -6923,7 +6925,7 @@ static int io_submit_sqes(struct io_ring_ctx *ctx, unsigned int nr)
 		/* will complete beyond this point, count as submitted */
 		submitted++;
 
-		err = io_init_req(ctx, req, sqe, &state);
+		err = io_init_req(ctx, req, sqe);
 		if (unlikely(err)) {
 fail_req:
 			io_put_req(req);
@@ -6933,7 +6935,7 @@ static int io_submit_sqes(struct io_ring_ctx *ctx, unsigned int nr)
 
 		trace_io_uring_submit_sqe(ctx, req->opcode, req->user_data,
 					true, ctx->flags & IORING_SETUP_SQPOLL);
-		err = io_submit_sqe(req, sqe, &link, &state.comp);
+		err = io_submit_sqe(req, sqe, &link, &ctx->submit_state.comp);
 		if (err)
 			goto fail_req;
 	}
@@ -6948,8 +6950,8 @@ static int io_submit_sqes(struct io_ring_ctx *ctx, unsigned int nr)
 		put_task_struct_many(current, unused);
 	}
 	if (link.head)
-		io_queue_link_head(link.head, &state.comp);
-	io_submit_state_end(&state);
+		io_queue_link_head(link.head, &ctx->submit_state.comp);
+	io_submit_state_end(&ctx->submit_state);
 
 	 /* Commit SQ ring head once we've consumed and submitted all SQEs */
 	io_commit_sqring(ctx);
-- 
2.24.0

