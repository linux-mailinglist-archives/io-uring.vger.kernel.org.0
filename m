Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 5EFC23E4538
	for <lists+io-uring@lfdr.de>; Mon,  9 Aug 2021 14:05:15 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235349AbhHIMFd (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Mon, 9 Aug 2021 08:05:33 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:40378 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S235342AbhHIMFc (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Mon, 9 Aug 2021 08:05:32 -0400
Received: from mail-wr1-x429.google.com (mail-wr1-x429.google.com [IPv6:2a00:1450:4864:20::429])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 48141C0613D3
        for <io-uring@vger.kernel.org>; Mon,  9 Aug 2021 05:05:12 -0700 (PDT)
Received: by mail-wr1-x429.google.com with SMTP id m12so21076725wru.12
        for <io-uring@vger.kernel.org>; Mon, 09 Aug 2021 05:05:12 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:subject:date:message-id:in-reply-to:references:mime-version
         :content-transfer-encoding;
        bh=GJeixBekq7Lrn568rXpE1ZEzomJ3HEd99esapdptNaA=;
        b=qIpd+VIzTeOuJotd6ANezBI4DM8lZTMawzlXBidf4VfkeO5TdYOhiDqRCK8JpimB92
         CzlPFQp0+kDuZSa++KmCh0VFsmD29yoGhK+7e/dVceUZNZzjET6tU5u/gffVdxOWCDPx
         KC3JOoaazN0Mpn56kAPmausGSOJT8cSv13K6cSRCRzF68hnS8kcT95McK0vUH1RgAZ76
         v4coCubOyNx4hdRthJj6FLeJddLsgUS5tgwr8w7I6xZaBLFxqFVVzQbk7mxbDspoNANF
         S2Or8a+UYjt+QhjMUBFT8I3JumIu654OZ8Hsbr7mEhKHIRr67fluCsxrGyL+iJ4hm2L4
         8Xlw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=GJeixBekq7Lrn568rXpE1ZEzomJ3HEd99esapdptNaA=;
        b=cMaJoOdTAorpwOqf+WRyMHAJfEnTnOeQnwcDbuKHz1xm7mJjWQGxCeqrfOXoaG0/+d
         7AvuW35bjmr1AKYM/JrhSLHZHsY4K1eNKeLnpFwcKGeY1BKEWV1XOYgKck4becMMb8qH
         ft1uHSZ8AC5AL3wQHhXEEwYltj99yxs8DlaO8hibPTMCqg49NbLUN9BtvL8IGJS6bC18
         0Y50Mc/v5i1EbH+QD7nffvOLnvtlajuUwgnpiNFCWBE89HvqsNtTTl5JvLfOCHgce4EA
         t1h8sCqs5ycJ1nnKs2tiLYzqdUbIBSM9xhygdOuwpVOPHJ0T2WCqtB6RbEC8r6B5xPdg
         N8Kg==
X-Gm-Message-State: AOAM533Ipo0uoL/5yrtxU3shAfKaGHhJIUiNtZ/jcv1FuErsyZOot62j
        o+dK/yS68je8CEX/miR70mM=
X-Google-Smtp-Source: ABdhPJyiQwjYbcBSG5jnaq5jqXvu34Ll4z+RJixgjfetqHOXqA7mdCK1Y/pumk8vfVUwe3PqY78jVw==
X-Received: by 2002:adf:f90e:: with SMTP id b14mr22965434wrr.28.1628510710889;
        Mon, 09 Aug 2021 05:05:10 -0700 (PDT)
Received: from localhost.localdomain ([85.255.236.119])
        by smtp.gmail.com with ESMTPSA id g35sm4757062wmp.9.2021.08.09.05.05.10
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 09 Aug 2021 05:05:10 -0700 (PDT)
From:   Pavel Begunkov <asml.silence@gmail.com>
To:     Jens Axboe <axboe@kernel.dk>, io-uring@vger.kernel.org
Subject: [PATCH 08/28] io_uring: refactor io_alloc_req
Date:   Mon,  9 Aug 2021 13:04:08 +0100
Message-Id: <1abcba1f7b55dc53bf1dbe95036e345ffb1d5b01.1628471125.git.asml.silence@gmail.com>
X-Mailer: git-send-email 2.32.0
In-Reply-To: <cover.1628471125.git.asml.silence@gmail.com>
References: <cover.1628471125.git.asml.silence@gmail.com>
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
index ba1df6ae6024..80d7f79db911 100644
--- a/fs/io_uring.c
+++ b/fs/io_uring.c
@@ -1699,6 +1699,19 @@ static void io_req_complete_failed(struct io_kiocb *req, long res)
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
@@ -1741,45 +1754,31 @@ static bool io_flush_cached_reqs(struct io_ring_ctx *ctx)
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
@@ -6570,6 +6569,7 @@ static int io_init_req(struct io_ring_ctx *ctx, struct io_kiocb *req,
 	unsigned int sqe_flags;
 	int personality, ret = 0;
 
+	/* req is partially pre-initialised, see io_preinit_req() */
 	req->opcode = READ_ONCE(sqe->opcode);
 	/* same numerical values with corresponding REQ_F_*, safe to copy */
 	req->flags = sqe_flags = READ_ONCE(sqe->flags);
-- 
2.32.0

