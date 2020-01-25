Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id CD87D14979C
	for <lists+io-uring@lfdr.de>; Sat, 25 Jan 2020 20:55:00 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728901AbgAYTyr (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Sat, 25 Jan 2020 14:54:47 -0500
Received: from mail-wr1-f66.google.com ([209.85.221.66]:45910 "EHLO
        mail-wr1-f66.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1728831AbgAYTyr (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Sat, 25 Jan 2020 14:54:47 -0500
Received: by mail-wr1-f66.google.com with SMTP id j42so6083573wrj.12;
        Sat, 25 Jan 2020 11:54:45 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:subject:date:message-id:in-reply-to:references:mime-version
         :content-transfer-encoding;
        bh=LEomyjfyePXMKFQtL5GHUiv9AxI5e32kC21LMJy+xQE=;
        b=hGJcZKWNsi4Fh2EVh8w/oEREqlwu2cb1d3Uy00Qgn37QeUM3Kt+8jWUGDlfkRdqSBZ
         PsMhbv+C4SonzbWgBEXPZ6BkoLPIP7cy8AlKzBUCaxbpiZ6qFn5Cz9yX2ZwMtrlhNwpQ
         5oLM4Tk3GFpjc+YKDsX8rssOgV1IFD22Q1N/50pOtDXT++crYTSOuW/+XsPxt0q+85kT
         0uSmPJAJhvTAD6/N4pmRg18GhTrsF5ptOjcts8ACSv2gqUqEfc15M5PZs/oX77VDxMIM
         oN0H6Kc/7SPNHMBeTbC3U7sIWTrjEws3BsUzoWO+hI28G0jC2fDAMqIhuem1Wn0Xw2sZ
         c0Zg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=LEomyjfyePXMKFQtL5GHUiv9AxI5e32kC21LMJy+xQE=;
        b=p7ynKbla8mCGiK36LfRvCY6zIqp9U3uEluX2IsSnUcziDJH2LV2l2TVkPe1/aTZUiX
         gdtV3eVkSVmlf30BOLGbtOlelB8tO3HLAe6C693GnKnrNKSpweTmAlsCzuArXRXu9ygL
         zar3WqYZMkqAZIshakwkeQ5eFpWcedFsS67PADUubmRnZFeO+SV5sDcOSJ12zDWZlNNL
         O+FjPjW8ARxiAYRZNM69QgQFJErRwGNJn4oV5/BHXfuregYrUB+o8/ayrq90+NYc3KWK
         2zLPTW87AzGWAZ84VZQj72jRyp0kglmzIQ3WVbEpHLgqlNUyGFocPWMtXqRhiVBpBmSN
         b8ug==
X-Gm-Message-State: APjAAAV3ZZtQxuBlNhycE5TIUqBHiHLGZkmS3JCwcYwJtUy0rSW9mVw7
        B5O8hoQohxMINIriMuaNGss=
X-Google-Smtp-Source: APXvYqxzzmVXB74Ejfw3Y2sawxEYl2E4aRxoSaZkCMmlFp8777//ukym88nFN4x64UJPcZDj6Jf9bQ==
X-Received: by 2002:adf:c74f:: with SMTP id b15mr11595083wrh.272.1579982085032;
        Sat, 25 Jan 2020 11:54:45 -0800 (PST)
Received: from localhost.localdomain ([109.126.145.157])
        by smtp.gmail.com with ESMTPSA id m21sm11883712wmi.27.2020.01.25.11.54.43
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sat, 25 Jan 2020 11:54:44 -0800 (PST)
From:   Pavel Begunkov <asml.silence@gmail.com>
To:     Jens Axboe <axboe@kernel.dk>, io-uring@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: [PATCH v2 7/8] io_uring: persistent req bulk allocation cache
Date:   Sat, 25 Jan 2020 22:53:44 +0300
Message-Id: <6693a657d9811a0d04b28c3f851021a56e1f69e4.1579981749.git.asml.silence@gmail.com>
X-Mailer: git-send-email 2.24.0
In-Reply-To: <cover.1579981749.git.asml.silence@gmail.com>
References: <cover.1579981749.git.asml.silence@gmail.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: io-uring-owner@vger.kernel.org
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org

Save bulk allocated requests across io_uring_enter(), so lower QD also
could benefit from that. This is not much of an optimisation, and for
current cache sizes would probably affect only offloaded ~QD=1.

Signed-off-by: Pavel Begunkov <asml.silence@gmail.com>
---
 fs/io_uring.c | 38 ++++++++++++++++++++++++++------------
 1 file changed, 26 insertions(+), 12 deletions(-)

diff --git a/fs/io_uring.c b/fs/io_uring.c
index 5022eb4cb9a4..82df6171baae 100644
--- a/fs/io_uring.c
+++ b/fs/io_uring.c
@@ -834,6 +834,25 @@ static struct io_ring_ctx *io_ring_ctx_alloc(struct io_uring_params *p)
 	return NULL;
 }
 
+static void io_init_submit_state(struct io_ring_ctx *ctx)
+{
+	struct io_submit_state *state = &ctx->submit_state;
+
+	state->mm = (ctx->flags & IORING_SETUP_SQPOLL) ? NULL : ctx->sqo_mm;
+
+	state->free_reqs = 0;
+	state->cur_req = 0;
+}
+
+static void io_clear_submit_state(struct io_ring_ctx *ctx)
+{
+	struct io_submit_state *state = &ctx->submit_state;
+
+	if (state->free_reqs)
+		kmem_cache_free_bulk(req_cachep, state->free_reqs,
+					&state->reqs[state->cur_req]);
+}
+
 static inline bool __req_need_defer(struct io_kiocb *req)
 {
 	struct io_ring_ctx *ctx = req->ctx;
@@ -1132,10 +1151,9 @@ static struct io_kiocb *io_get_req(struct io_ring_ctx *ctx)
 	struct io_submit_state *state = &ctx->submit_state;
 
 	if (!state->free_reqs) {
-		size_t sz;
+		size_t sz = ARRAY_SIZE(state->reqs);
 		int ret;
 
-		sz = min_t(size_t, state->ios_left, ARRAY_SIZE(state->reqs));
 		ret = kmem_cache_alloc_bulk(req_cachep, gfp, sz, state->reqs);
 
 		/*
@@ -4759,9 +4777,6 @@ static void io_submit_end(struct io_ring_ctx *ctx)
 	struct io_submit_state *state = &ctx->submit_state;
 
 	io_file_put(state);
-	if (state->free_reqs)
-		kmem_cache_free_bulk(req_cachep, state->free_reqs,
-					&state->reqs[state->cur_req]);
 	if (state->link)
 		io_queue_link_head(state->link);
 }
@@ -4774,7 +4789,6 @@ static void io_submit_start(struct io_ring_ctx *ctx, unsigned int max_ios,
 {
 	struct io_submit_state *state = &ctx->submit_state;
 
-	state->free_reqs = 0;
 	state->file = NULL;
 	state->ios_left = max_ios;
 
@@ -5765,12 +5779,6 @@ static int io_sq_offload_start(struct io_ring_ctx *ctx,
 	int ret;
 
 	init_waitqueue_head(&ctx->sqo_wait);
-	mmgrab(current->mm);
-	ctx->sqo_mm = current->mm;
-
-	ctx->submit_state.mm = NULL;
-	if (!(ctx->flags & IORING_SETUP_SQPOLL))
-		ctx->submit_state.mm = ctx->sqo_mm;
 
 	if (ctx->flags & IORING_SETUP_SQPOLL) {
 		ret = -EPERM;
@@ -6146,6 +6154,8 @@ static void io_ring_ctx_free(struct io_ring_ctx *ctx)
 	if (ctx->sqo_mm)
 		mmdrop(ctx->sqo_mm);
 
+	io_clear_submit_state(ctx);
+
 	io_iopoll_reap_events(ctx);
 	io_sqe_buffer_unregister(ctx);
 	io_sqe_files_unregister(ctx);
@@ -6584,6 +6594,10 @@ static int io_uring_create(unsigned entries, struct io_uring_params *p)
 	if (ret)
 		goto err;
 
+	mmgrab(current->mm);
+	ctx->sqo_mm = current->mm;
+	io_init_submit_state(ctx);
+
 	ret = io_sq_offload_start(ctx, p);
 	if (ret)
 		goto err;
-- 
2.24.0

