Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id DE1494178DC
	for <lists+io-uring@lfdr.de>; Fri, 24 Sep 2021 18:36:25 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1347591AbhIXQh5 (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Fri, 24 Sep 2021 12:37:57 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:38454 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1344615AbhIXQh3 (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Fri, 24 Sep 2021 12:37:29 -0400
Received: from mail-ed1-x533.google.com (mail-ed1-x533.google.com [IPv6:2a00:1450:4864:20::533])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id A8FB0C0613A9
        for <io-uring@vger.kernel.org>; Fri, 24 Sep 2021 09:32:51 -0700 (PDT)
Received: by mail-ed1-x533.google.com with SMTP id y89so27463781ede.2
        for <io-uring@vger.kernel.org>; Fri, 24 Sep 2021 09:32:51 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=from:to:subject:date:message-id:in-reply-to:references:mime-version
         :content-transfer-encoding;
        bh=/YyOKk9OvH+bWyTLrOJ1FGWXjWzy5Y0TnB0KZJRQoBY=;
        b=ewsnfUHT9gIExWdTJXBVIHAR+KAgOTfNYlPd6laIm3XimAjo2HgitbuwnvF2aWy07f
         3hknkw+3eY+76KPZKt2lWffACy+JnO0xpzrG7MpBPc23NMJPtZErcX7DhvtYvxFVHB/R
         uj8SX3/Rjnk6lsPVEVls0xJfe7nq8SZGcJZqi7DhbHdp9kCvr0A9+H23Bj/kiT5GIRdX
         VvdWB/5lIg4MQcBM8nPLl3UCzzoQYgZVKFTedtKfit8aoCtfir/XhSoy+9zd2hlphvNa
         Qt5opEttgfzvLUTD4hhGjLJ5x1nC7No5mybZgI3H6RoNAesrTUWf8OLYOMVKFMB6+w9v
         zvng==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:from:to:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=/YyOKk9OvH+bWyTLrOJ1FGWXjWzy5Y0TnB0KZJRQoBY=;
        b=HH6DtyWnx/ZS055YsAIODLCqyDOMaz8SnEu0RJYyeCJq+JVa8kOpke6YZ7yiGoxSXN
         Nt65s/tornLJLvmbZDxcCDluzxrJqmAy8JEPonXuhuO9nKryuA+1lwJkS4yAk+uF/rxy
         10/bjyygOwdyQDUdE18OkWAWCMXdjEmtyb/0Jbks2w/IzHM+ifhEv/mmgF8bKXfao/92
         vIkhR/KuQ5EDmh3xr4UgywmDVzksS+u/ZSS95HFlX1+9Wj0lpYrRByy8giqJA43tPvBY
         09hb1Y+iu0qoYDubxWCMvTolZxHChbAeQgs3Fh6aH4MIdNbUbu4rbJmVwd1b1qwYhN2e
         UF8A==
X-Gm-Message-State: AOAM5338BMiXdFtSQACB4F0nJEhSBst94ErWmOxrWadUCkDOMMgxEDjw
        iTva+c+9hrCBzOKMgFz2doRXUJ3Nkcc=
X-Google-Smtp-Source: ABdhPJwm7azPnk64lmpQh32u8fS2o+8HbcE6fi0Uotqn1mviYqk+QGv6YF2CqLnnzqbbDH+dgUGztQ==
X-Received: by 2002:a17:906:38e:: with SMTP id b14mr12557314eja.229.1632501170280;
        Fri, 24 Sep 2021 09:32:50 -0700 (PDT)
Received: from localhost.localdomain ([85.255.232.225])
        by smtp.gmail.com with ESMTPSA id w10sm6167021eds.30.2021.09.24.09.32.49
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 24 Sep 2021 09:32:49 -0700 (PDT)
From:   Pavel Begunkov <asml.silence@gmail.com>
To:     Jens Axboe <axboe@kernel.dk>, io-uring@vger.kernel.org
Subject: [PATCH 04/23] io_uring: use slist for completion batching
Date:   Fri, 24 Sep 2021 17:31:42 +0100
Message-Id: <d20814e98046cdaca8c07a6d125b94c9b8de6f3f.1632500264.git.asml.silence@gmail.com>
X-Mailer: git-send-email 2.33.0
In-Reply-To: <cover.1632500264.git.asml.silence@gmail.com>
References: <cover.1632500264.git.asml.silence@gmail.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org

Currently we collect requests for completion batching in an array.
Replace them with a singly linked list. It's as fast as arrays but
doesn't take some much space in ctx, and will be used in future patches.

Signed-off-by: Pavel Begunkov <asml.silence@gmail.com>
---
 fs/io_uring.c | 52 +++++++++++++++++++++++++--------------------------
 1 file changed, 25 insertions(+), 27 deletions(-)

diff --git a/fs/io_uring.c b/fs/io_uring.c
index 13cb40d8ce08..027e6595321e 100644
--- a/fs/io_uring.c
+++ b/fs/io_uring.c
@@ -322,8 +322,8 @@ struct io_submit_state {
 	/*
 	 * Batch completion logic
 	 */
-	struct io_kiocb		*compl_reqs[IO_COMPL_BATCH];
-	unsigned int		compl_nr;
+	struct io_wq_work_list	compl_reqs;
+
 	/* inline/task_work completion list, under ->uring_lock */
 	struct list_head	free_list;
 };
@@ -882,6 +882,8 @@ struct io_kiocb {
 	struct io_wq_work		work;
 	const struct cred		*creds;
 
+	struct io_wq_work_node		comp_list;
+
 	/* store used ubuf, so we can prevent reloading */
 	struct io_mapped_ubuf		*imu;
 };
@@ -1166,7 +1168,7 @@ static inline void req_ref_get(struct io_kiocb *req)
 
 static inline void io_submit_flush_completions(struct io_ring_ctx *ctx)
 {
-	if (ctx->submit_state.compl_nr)
+	if (!wq_list_empty(&ctx->submit_state.compl_reqs))
 		__io_submit_flush_completions(ctx);
 }
 
@@ -1323,6 +1325,7 @@ static struct io_ring_ctx *io_ring_ctx_alloc(struct io_uring_params *p)
 	INIT_LIST_HEAD(&ctx->submit_state.free_list);
 	INIT_LIST_HEAD(&ctx->locked_free_list);
 	INIT_DELAYED_WORK(&ctx->fallback_work, io_fallback_req_func);
+	INIT_WQ_LIST(&ctx->submit_state.compl_reqs);
 	return ctx;
 err:
 	kfree(ctx->dummy_ubuf);
@@ -1828,11 +1831,16 @@ static inline bool io_req_needs_clean(struct io_kiocb *req)
 static void io_req_complete_state(struct io_kiocb *req, long res,
 				  unsigned int cflags)
 {
+	struct io_submit_state *state;
+
 	if (io_req_needs_clean(req))
 		io_clean_op(req);
 	req->result = res;
 	req->compl.cflags = cflags;
 	req->flags |= REQ_F_COMPLETE_INLINE;
+
+	state = &req->ctx->submit_state;
+	wq_list_add_tail(&req->comp_list, &state->compl_reqs);
 }
 
 static inline void __io_req_complete(struct io_kiocb *req, unsigned issue_flags,
@@ -2321,13 +2329,14 @@ static void io_req_free_batch(struct req_batch *rb, struct io_kiocb *req,
 static void __io_submit_flush_completions(struct io_ring_ctx *ctx)
 	__must_hold(&ctx->uring_lock)
 {
+	struct io_wq_work_node *node, *prev;
 	struct io_submit_state *state = &ctx->submit_state;
-	int i, nr = state->compl_nr;
 	struct req_batch rb;
 
 	spin_lock(&ctx->completion_lock);
-	for (i = 0; i < nr; i++) {
-		struct io_kiocb *req = state->compl_reqs[i];
+	wq_list_for_each(node, prev, &state->compl_reqs) {
+		struct io_kiocb *req = container_of(node, struct io_kiocb,
+						    comp_list);
 
 		__io_cqring_fill_event(ctx, req->user_data, req->result,
 					req->compl.cflags);
@@ -2337,15 +2346,18 @@ static void __io_submit_flush_completions(struct io_ring_ctx *ctx)
 	io_cqring_ev_posted(ctx);
 
 	io_init_req_batch(&rb);
-	for (i = 0; i < nr; i++) {
-		struct io_kiocb *req = state->compl_reqs[i];
+	node = state->compl_reqs.first;
+	do {
+		struct io_kiocb *req = container_of(node, struct io_kiocb,
+						    comp_list);
 
+		node = req->comp_list.next;
 		if (req_ref_put_and_test(req))
 			io_req_free_batch(&rb, req, &ctx->submit_state);
-	}
+	} while (node);
 
 	io_req_free_batch_finish(ctx, &rb);
-	state->compl_nr = 0;
+	INIT_WQ_LIST(&state->compl_reqs);
 }
 
 /*
@@ -2665,17 +2677,10 @@ static void io_req_task_complete(struct io_kiocb *req, bool *locked)
 	unsigned int cflags = io_put_rw_kbuf(req);
 	long res = req->result;
 
-	if (*locked) {
-		struct io_ring_ctx *ctx = req->ctx;
-		struct io_submit_state *state = &ctx->submit_state;
-
+	if (*locked)
 		io_req_complete_state(req, res, cflags);
-		state->compl_reqs[state->compl_nr++] = req;
-		if (state->compl_nr == ARRAY_SIZE(state->compl_reqs))
-			io_submit_flush_completions(ctx);
-	} else {
+	else
 		io_req_complete_post(req, res, cflags);
-	}
 }
 
 static void __io_complete_rw(struct io_kiocb *req, long res, long res2,
@@ -6953,15 +6958,8 @@ static void __io_queue_sqe(struct io_kiocb *req)
 	 * doesn't support non-blocking read/write attempts
 	 */
 	if (likely(!ret)) {
-		if (req->flags & REQ_F_COMPLETE_INLINE) {
-			struct io_ring_ctx *ctx = req->ctx;
-			struct io_submit_state *state = &ctx->submit_state;
-
-			state->compl_reqs[state->compl_nr++] = req;
-			if (state->compl_nr == ARRAY_SIZE(state->compl_reqs))
-				io_submit_flush_completions(ctx);
+		if (req->flags & REQ_F_COMPLETE_INLINE)
 			return;
-		}
 
 		linked_timeout = io_prep_linked_timeout(req);
 		if (linked_timeout)
-- 
2.33.0

