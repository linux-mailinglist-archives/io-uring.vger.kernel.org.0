Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id C54C3417CAA
	for <lists+io-uring@lfdr.de>; Fri, 24 Sep 2021 23:01:02 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1346467AbhIXVC2 (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Fri, 24 Sep 2021 17:02:28 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:44002 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231531AbhIXVC2 (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Fri, 24 Sep 2021 17:02:28 -0400
Received: from mail-ed1-x52c.google.com (mail-ed1-x52c.google.com [IPv6:2a00:1450:4864:20::52c])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 95487C061571
        for <io-uring@vger.kernel.org>; Fri, 24 Sep 2021 14:00:54 -0700 (PDT)
Received: by mail-ed1-x52c.google.com with SMTP id s17so22184180edd.8
        for <io-uring@vger.kernel.org>; Fri, 24 Sep 2021 14:00:54 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=from:to:subject:date:message-id:in-reply-to:references:mime-version
         :content-transfer-encoding;
        bh=+YFN3sNp1iCCC/kEpufNcxNUuVijs73AzPY6EZD2PPc=;
        b=Elkjof5OcT0/f1PqoPAMGDSWDmEZeYd/JTLu9sgZjRY7BqRpmLOh+fIVkifBzSXbMH
         RKBQ/SKi+X0IbIhXfjhUpCE7J47kdmUm+Q1XQJUT5u+RXvImYJKi4eRuPNs8PNfYQ8ov
         QDD12Do/Sg+GkSMarEaXXBOTDOxhqOmEdBlnK/yUT1uD+yI2By2mlODZT93N9W7nPQY+
         tVzrShNuGTqGrHF4vNKja+I5kBgWG7J8QHcBB1/SQgHsxegje02IQGHJJbSnrBjfTt0l
         GvYGmostBDup5+bpn2oYDcfsJ7Yic7QXJzUc0s5zxZfxTFHi5TR4I50dDpFbyNkywnFB
         sINA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:from:to:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=+YFN3sNp1iCCC/kEpufNcxNUuVijs73AzPY6EZD2PPc=;
        b=iI2SVmipUwjL7s/l8rcQHY2TUe5Z0kdnIBaHurqAK908X7oLz70d+syQYzwz4mX94l
         SjScFu3eY4nzjQnb2+3kj2R7Xz0GCpbdwp7CZGZxcdkI/NA8nGIhtjMne2gwe/RHY/cS
         6toBeCjn8jVzqJ1s0YuC914veXR6funn3cvylNVc+Rq+KmV+TKTjcF4Zjgm9/Z62H6I7
         7Ak+x0epH0e0VwCkc+BzhNqVpir8ijjlqkti08spGsdXWPM2JyKIOCCxsNEaaAhZ67od
         Fjis6UdBNce8hraWt7xOlJhrzn2pm2aFc4AE0+JwfUUukXbUWRYwFp4Byg3fsIafWWlP
         CQVQ==
X-Gm-Message-State: AOAM532GKh0wJKG6ZoURJ/TrfMs+dhAR6gIQZ0Iz8VIuUvKr3zNFUqgw
        /fBmlFHN+zjOlH/uB1ZZ5PSVmUl/A+Q=
X-Google-Smtp-Source: ABdhPJwYcxjrx51x8hxAtYu0ZSVWP35uHXbzuRXx6xkx4x5XFndVl2QsD+pfpRLvvsRi+N5/wwyrQg==
X-Received: by 2002:a50:da8f:: with SMTP id q15mr7566495edj.139.1632517253167;
        Fri, 24 Sep 2021 14:00:53 -0700 (PDT)
Received: from localhost.localdomain ([85.255.232.225])
        by smtp.gmail.com with ESMTPSA id bc4sm6276048edb.18.2021.09.24.14.00.52
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 24 Sep 2021 14:00:52 -0700 (PDT)
From:   Pavel Begunkov <asml.silence@gmail.com>
To:     Jens Axboe <axboe@kernel.dk>, io-uring@vger.kernel.org
Subject: [PATCH v2 04/24] io_uring: use slist for completion batching
Date:   Fri, 24 Sep 2021 21:59:44 +0100
Message-Id: <a666826f2854d17e9fb9417fb302edfeb750f425.1632516769.git.asml.silence@gmail.com>
X-Mailer: git-send-email 2.33.0
In-Reply-To: <cover.1632516769.git.asml.silence@gmail.com>
References: <cover.1632516769.git.asml.silence@gmail.com>
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
index 9c14e9e722ba..9a76c4f84311 100644
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
@@ -883,6 +883,8 @@ struct io_kiocb {
 	struct io_wq_work		work;
 	const struct cred		*creds;
 
+	struct io_wq_work_node		comp_list;
+
 	/* store used ubuf, so we can prevent reloading */
 	struct io_mapped_ubuf		*imu;
 };
@@ -1169,7 +1171,7 @@ static inline void req_ref_get(struct io_kiocb *req)
 
 static inline void io_submit_flush_completions(struct io_ring_ctx *ctx)
 {
-	if (ctx->submit_state.compl_nr)
+	if (!wq_list_empty(&ctx->submit_state.compl_reqs))
 		__io_submit_flush_completions(ctx);
 }
 
@@ -1326,6 +1328,7 @@ static struct io_ring_ctx *io_ring_ctx_alloc(struct io_uring_params *p)
 	INIT_LIST_HEAD(&ctx->submit_state.free_list);
 	INIT_LIST_HEAD(&ctx->locked_free_list);
 	INIT_DELAYED_WORK(&ctx->fallback_work, io_fallback_req_func);
+	INIT_WQ_LIST(&ctx->submit_state.compl_reqs);
 	return ctx;
 err:
 	kfree(ctx->dummy_ubuf);
@@ -1831,11 +1834,16 @@ static inline bool io_req_needs_clean(struct io_kiocb *req)
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
@@ -2324,13 +2332,14 @@ static void io_req_free_batch(struct req_batch *rb, struct io_kiocb *req,
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
@@ -2340,15 +2349,18 @@ static void __io_submit_flush_completions(struct io_ring_ctx *ctx)
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
@@ -2668,17 +2680,10 @@ static void io_req_task_complete(struct io_kiocb *req, bool *locked)
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
@@ -6969,15 +6974,8 @@ static void __io_queue_sqe(struct io_kiocb *req)
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

