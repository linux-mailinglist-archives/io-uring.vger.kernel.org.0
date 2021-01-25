Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 329253024AF
	for <lists+io-uring@lfdr.de>; Mon, 25 Jan 2021 13:12:53 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727749AbhAYML6 (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Mon, 25 Jan 2021 07:11:58 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:42866 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727795AbhAYMKU (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Mon, 25 Jan 2021 07:10:20 -0500
Received: from mail-wr1-x435.google.com (mail-wr1-x435.google.com [IPv6:2a00:1450:4864:20::435])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 8B20AC0611C1
        for <io-uring@vger.kernel.org>; Mon, 25 Jan 2021 03:46:18 -0800 (PST)
Received: by mail-wr1-x435.google.com with SMTP id m1so11342785wrq.12
        for <io-uring@vger.kernel.org>; Mon, 25 Jan 2021 03:46:18 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:subject:date:message-id:in-reply-to:references:mime-version
         :content-transfer-encoding;
        bh=H4kR/mVmbSSVjBahDcrwZpSo0mgNYwRZJmsU/iCprtg=;
        b=vMWjoBrQvN+qR/NLKajSP8vI+/qkrjNbHpDK50vAvYE4T+Zz3iPDFMIfgrzYipCxVI
         toHSI84qPmyTYMuOr8POY2Q70L2VRfuXG9YSSDFn4BlACAOnd7ZRdkNp71Dy3OPmSBN8
         2DsINsKNCCuAJLPzmboak9A8oe7ZtimpCUvQmUtQoUQzznoaChBmoANWZl62PPUDY2gA
         V8EN+xc1+XmWz2rTXtM+zWInGX6zuwjv4fkFAFCEBywFwCqRwQe7OcCmtll+p2EdWzDE
         E8pOdOBFPO/QxzdOxUAvu3RGFBhkwEFhuTwgdLPsGf8J+nOlzmEfNSs7rcD6r8dXoGzE
         BBeA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=H4kR/mVmbSSVjBahDcrwZpSo0mgNYwRZJmsU/iCprtg=;
        b=iHVTfzTx65xaHH8E589kX20qVlHCxD3twnXRc3HSpihcxz9yyUWfUDQfFwISZcGjom
         3S6Fgzl+Bk/A3vdnT9LBGLsCxfB3yVUPf34J58+N8kylujtQxeEC/q6cmVl3pcA7Em68
         JEuhN5ePTR10xsiEmRt6tr+Yr2l9G6Md/GiOcpwLH3rOkS4Rz+qS8LieCGuTJsSwnMQ6
         ULx+LVa2O3tEpzcBpDXRJc7gWnOYK+hnnwde2CpWNGIZx6wUlA8EziWTFi2HPIF9dNLT
         c+UmjRs98W3x+FSC4nyaz3NGx48sSlewqiKjxL1u3XnUHcbSjQ8gTihWhEkgqKMLiKAU
         ALqA==
X-Gm-Message-State: AOAM5307v4oboqBlFtLu1WWt576qJRSD30Gg96XCfjjhSjhqT4TxyVNj
        6NZ8gX5CZx9xHeXGHCw7Nkc=
X-Google-Smtp-Source: ABdhPJzL+cuYMH9COfl9LSgaT3EEbG7fp9NQixp3oUlpPzt53D4iWu+Ice8W3jE/8dcJh1XUK7JX3A==
X-Received: by 2002:a5d:525c:: with SMTP id k28mr479411wrc.157.1611575177381;
        Mon, 25 Jan 2021 03:46:17 -0800 (PST)
Received: from localhost.localdomain ([85.255.234.11])
        by smtp.gmail.com with ESMTPSA id a6sm12571433wru.66.2021.01.25.03.46.16
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 25 Jan 2021 03:46:16 -0800 (PST)
From:   Pavel Begunkov <asml.silence@gmail.com>
To:     Jens Axboe <axboe@kernel.dk>, io-uring@vger.kernel.org
Subject: [PATCH 4/8] io_uring: remove ctx from comp_state
Date:   Mon, 25 Jan 2021 11:42:23 +0000
Message-Id: <96e8497dd75f2a85b64fd456673c6c28d8a9a0b2.1611573970.git.asml.silence@gmail.com>
X-Mailer: git-send-email 2.24.0
In-Reply-To: <cover.1611573970.git.asml.silence@gmail.com>
References: <cover.1611573970.git.asml.silence@gmail.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org

completion state is closely bound to ctx, we don't need to store ctx
inside as we always have it around to pass to flush.

Signed-off-by: Pavel Begunkov <asml.silence@gmail.com>
---
 fs/io_uring.c | 20 +++++++++-----------
 1 file changed, 9 insertions(+), 11 deletions(-)

diff --git a/fs/io_uring.c b/fs/io_uring.c
index 9ba33ee08d2a..7d811cf0c27b 100644
--- a/fs/io_uring.c
+++ b/fs/io_uring.c
@@ -264,7 +264,6 @@ struct io_sq_data {
 struct io_comp_state {
 	unsigned int		nr;
 	struct list_head	list;
-	struct io_ring_ctx	*ctx;
 };
 
 struct io_submit_state {
@@ -1892,10 +1891,9 @@ static void io_req_complete_nostate(struct io_kiocb *req, long res,
 	io_put_req(req);
 }
 
-static void io_submit_flush_completions(struct io_comp_state *cs)
+static void io_submit_flush_completions(struct io_comp_state *cs,
+					struct io_ring_ctx *ctx)
 {
-	struct io_ring_ctx *ctx = cs->ctx;
-
 	spin_lock_irq(&ctx->completion_lock);
 	while (!list_empty(&cs->list)) {
 		struct io_kiocb *req;
@@ -6562,7 +6560,7 @@ static void __io_queue_sqe(struct io_kiocb *req, struct io_comp_state *cs)
 		if (req->flags & REQ_F_COMPLETE_INLINE) {
 			list_add_tail(&req->compl.list, &cs->list);
 			if (++cs->nr >= 32)
-				io_submit_flush_completions(cs);
+				io_submit_flush_completions(cs, req->ctx);
 			req = NULL;
 		} else {
 			req = io_put_req_find_next(req);
@@ -6697,10 +6695,11 @@ static int io_submit_sqe(struct io_kiocb *req, const struct io_uring_sqe *sqe,
 /*
  * Batched submission is done, ensure local IO is flushed out.
  */
-static void io_submit_state_end(struct io_submit_state *state)
+static void io_submit_state_end(struct io_submit_state *state,
+				struct io_ring_ctx *ctx)
 {
 	if (!list_empty(&state->comp.list))
-		io_submit_flush_completions(&state->comp);
+		io_submit_flush_completions(&state->comp, ctx);
 	if (state->plug_started)
 		blk_finish_plug(&state->plug);
 	io_state_file_put(state);
@@ -6712,12 +6711,11 @@ static void io_submit_state_end(struct io_submit_state *state)
  * Start submission side cache.
  */
 static void io_submit_state_start(struct io_submit_state *state,
-				  struct io_ring_ctx *ctx, unsigned int max_ios)
+				  unsigned int max_ios)
 {
 	state->plug_started = false;
 	state->comp.nr = 0;
 	INIT_LIST_HEAD(&state->comp.list);
-	state->comp.ctx = ctx;
 	state->free_reqs = 0;
 	state->file_refs = 0;
 	state->ios_left = max_ios;
@@ -6902,7 +6900,7 @@ static int io_submit_sqes(struct io_ring_ctx *ctx, unsigned int nr)
 	percpu_counter_add(&current->io_uring->inflight, nr);
 	refcount_add(nr, &current->usage);
 
-	io_submit_state_start(&ctx->submit_state, ctx, nr);
+	io_submit_state_start(&ctx->submit_state, nr);
 	link.head = NULL;
 
 	for (i = 0; i < nr; i++) {
@@ -6951,7 +6949,7 @@ static int io_submit_sqes(struct io_ring_ctx *ctx, unsigned int nr)
 	}
 	if (link.head)
 		io_queue_link_head(link.head, &ctx->submit_state.comp);
-	io_submit_state_end(&ctx->submit_state);
+	io_submit_state_end(&ctx->submit_state, ctx);
 
 	 /* Commit SQ ring head once we've consumed and submitted all SQEs */
 	io_commit_sqring(ctx);
-- 
2.24.0

