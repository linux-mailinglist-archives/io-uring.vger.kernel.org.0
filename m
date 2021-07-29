Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 4C9903DA711
	for <lists+io-uring@lfdr.de>; Thu, 29 Jul 2021 17:06:29 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S237585AbhG2PGb (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Thu, 29 Jul 2021 11:06:31 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:42404 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229864AbhG2PGb (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Thu, 29 Jul 2021 11:06:31 -0400
Received: from mail-wm1-x333.google.com (mail-wm1-x333.google.com [IPv6:2a00:1450:4864:20::333])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id DCDA3C061765
        for <io-uring@vger.kernel.org>; Thu, 29 Jul 2021 08:06:26 -0700 (PDT)
Received: by mail-wm1-x333.google.com with SMTP id u15so3946894wmj.1
        for <io-uring@vger.kernel.org>; Thu, 29 Jul 2021 08:06:26 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:subject:date:message-id:in-reply-to:references:mime-version
         :content-transfer-encoding;
        bh=2GkY6ij29I3bPlR/3/60akCshl6NMq8dZDAsADTnWRM=;
        b=nW4BlNGLyOK7M7g4tafZJRWSs+F+RTOSJUFiZKb4tq7bj2R0ikDt4yvQeKUJoYlSLB
         ha7MZJdJ2wsfNIWCRKOSZLQrD1/eADvTKeLoU/NOsskNjEbXa/cMrIzXHS3jrTvoZJjf
         hXQceyqJKhjXr7FNwmFOzPLFadpWKcQx+qu0Gbu3rbsCIejvqakGqTDZoxB2r8+Pljxm
         Dkd1OCnAhjXF25msdkvJ30sSxJGPZXhG9NridDmoF065pP10XYEQFFC/4otsKgmllc6m
         5oa8qn8CejCYujBk4TB8ndQraU56xuv1HsgOQxb41om4aD9MvY2Huuv6p0gjrXUnZIVb
         TBEQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=2GkY6ij29I3bPlR/3/60akCshl6NMq8dZDAsADTnWRM=;
        b=R6USKdqghmlwcG/vQtJJvuLlvyYb1USAAbmHtcT/zV/qfzDh2t2aDPS7hO+CTomggz
         p7NsC71eKu0xE8W6YeAfXui1R/lcJ1jZLb49FUaTrCrHHJ3U1IYH/EWEPJ93bq0KOyhX
         9pwhG1KVRHQyLHe6BO+mWjfo3VZ3GzeRZJYah3IeDIf5sOsQhqgWxkyGLNt+ubUZT3ww
         9kDreOWVttEwYrKcAWhCtIPscKSDkr+lXNzqMtDO7cLTSxB6RoUG6lZAn8AllbSG1BQR
         /kGUKlAoBNjU33PEmEhxXRgbp/vPMRl+2XuPMIsf59ldluYXqqIOwv6l5LeUEo7nYwKV
         jDTg==
X-Gm-Message-State: AOAM531Ra6vI20PKErGAFjYwc/XhyxEIitR0p5TypOu+QrkLvLa/y2J7
        8pa3X3knYYMtQdTT6KFfchc=
X-Google-Smtp-Source: ABdhPJxRgZfdlVcCKWHxXMVXCFKCY7iBw3i3sNI0LvE9A1LID8AlgPrMNtlzHUH9iW7NRdKJIlWYNg==
X-Received: by 2002:a05:600c:2204:: with SMTP id z4mr5229677wml.164.1627571185529;
        Thu, 29 Jul 2021 08:06:25 -0700 (PDT)
Received: from localhost.localdomain ([148.252.128.141])
        by smtp.gmail.com with ESMTPSA id e6sm4764577wrg.18.2021.07.29.08.06.24
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 29 Jul 2021 08:06:25 -0700 (PDT)
From:   Pavel Begunkov <asml.silence@gmail.com>
To:     Jens Axboe <axboe@kernel.dk>, io-uring@vger.kernel.org
Subject: [PATCH 03/23] io_uring: refactor io_alloc_req
Date:   Thu, 29 Jul 2021 16:05:30 +0100
Message-Id: <7dee2dfb97c69726d5998779cddb76fdf6ccc3c9.1627570633.git.asml.silence@gmail.com>
X-Mailer: git-send-email 2.32.0
In-Reply-To: <cover.1627570633.git.asml.silence@gmail.com>
References: <cover.1627570633.git.asml.silence@gmail.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org

Replace the main if of io_flush_cached_reqs() with inverted condition +
goto, so all the cases are handled in the same way. And also extract
io_preinit_req() to make it cleaner and easier to refer to.

Signed-off-by: Pavel Begunkov <asml.silence@gmail.com>
---
 fs/io_uring.c | 66 +++++++++++++++++++++++++--------------------------
 1 file changed, 33 insertions(+), 33 deletions(-)

diff --git a/fs/io_uring.c b/fs/io_uring.c
index 2c4a61153bd1..6dca33fdb012 100644
--- a/fs/io_uring.c
+++ b/fs/io_uring.c
@@ -1690,6 +1690,19 @@ static void io_req_complete_failed(struct io_kiocb *req, long res)
 	io_req_complete_post(req, res, 0);
 }
 
+/*
+ * Don't initialise the fields below on every allocation, but do that in
+ * advance and keep them valid across allocations.
+ */
+static void io_preinit_req(struct io_kiocb *req, struct io_ring_ctx *ctx)
+{
+	req->ctx = ctx;
+	req->link = NULL;
+	req->async_data = NULL;
+	/* not necessary, but safer to zero */
+	req->result = 0;
+}
+
 static void io_flush_cached_locked_reqs(struct io_ring_ctx *ctx,
 					struct io_comp_state *cs)
 {
@@ -1732,45 +1745,31 @@ static bool io_flush_cached_reqs(struct io_ring_ctx *ctx)
 static struct io_kiocb *io_alloc_req(struct io_ring_ctx *ctx)
 {
 	struct io_submit_state *state = &ctx->submit_state;
+	gfp_t gfp = GFP_KERNEL | __GFP_NOWARN;
+	int ret, i;
 
 	BUILD_BUG_ON(ARRAY_SIZE(state->reqs) < IO_REQ_ALLOC_BATCH);
 
-	if (!state->free_reqs) {
-		gfp_t gfp = GFP_KERNEL | __GFP_NOWARN;
-		int ret, i;
-
-		if (io_flush_cached_reqs(ctx))
-			goto got_req;
-
-		ret = kmem_cache_alloc_bulk(req_cachep, gfp, IO_REQ_ALLOC_BATCH,
-					    state->reqs);
-
-		/*
-		 * Bulk alloc is all-or-nothing. If we fail to get a batch,
-		 * retry single alloc to be on the safe side.
-		 */
-		if (unlikely(ret <= 0)) {
-			state->reqs[0] = kmem_cache_alloc(req_cachep, gfp);
-			if (!state->reqs[0])
-				return NULL;
-			ret = 1;
-		}
+	if (likely(state->free_reqs || io_flush_cached_reqs(ctx)))
+		goto got_req;
 
-		/*
-		 * Don't initialise the fields below on every allocation, but
-		 * do that in advance and keep valid on free.
-		 */
-		for (i = 0; i < ret; i++) {
-			struct io_kiocb *req = state->reqs[i];
+	ret = kmem_cache_alloc_bulk(req_cachep, gfp, IO_REQ_ALLOC_BATCH,
+				    state->reqs);
 
-			req->ctx = ctx;
-			req->link = NULL;
-			req->async_data = NULL;
-			/* not necessary, but safer to zero */
-			req->result = 0;
-		}
-		state->free_reqs = ret;
+	/*
+	 * Bulk alloc is all-or-nothing. If we fail to get a batch,
+	 * retry single alloc to be on the safe side.
+	 */
+	if (unlikely(ret <= 0)) {
+		state->reqs[0] = kmem_cache_alloc(req_cachep, gfp);
+		if (!state->reqs[0])
+			return NULL;
+		ret = 1;
 	}
+
+	for (i = 0; i < ret; i++)
+		io_preinit_req(state->reqs[i], ctx);
+	state->free_reqs = ret;
 got_req:
 	state->free_reqs--;
 	return state->reqs[state->free_reqs];
@@ -6546,6 +6545,7 @@ static int io_init_req(struct io_ring_ctx *ctx, struct io_kiocb *req,
 	unsigned int sqe_flags;
 	int personality, ret = 0;
 
+	/* req is partially pre-initialised, see io_preinit_req() */
 	req->opcode = READ_ONCE(sqe->opcode);
 	/* same numerical values with corresponding REQ_F_*, safe to copy */
 	req->flags = sqe_flags = READ_ONCE(sqe->flags);
-- 
2.32.0

