Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id B734F315AF3
	for <lists+io-uring@lfdr.de>; Wed, 10 Feb 2021 01:21:25 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234518AbhBJAS5 (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Tue, 9 Feb 2021 19:18:57 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:54178 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234139AbhBJAJJ (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Tue, 9 Feb 2021 19:09:09 -0500
Received: from mail-wr1-x42d.google.com (mail-wr1-x42d.google.com [IPv6:2a00:1450:4864:20::42d])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 6CE3CC06178B
        for <io-uring@vger.kernel.org>; Tue,  9 Feb 2021 16:07:21 -0800 (PST)
Received: by mail-wr1-x42d.google.com with SMTP id u14so438086wri.3
        for <io-uring@vger.kernel.org>; Tue, 09 Feb 2021 16:07:21 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:subject:date:message-id:in-reply-to:references:mime-version
         :content-transfer-encoding;
        bh=4dry6CCaIBUkMu2F1ipz/+c4RFHwg1uG9hT57nTkRjE=;
        b=VEwWTX5uA1ZXcugen2f0VbHF8BGxDoSDwGafNr2tOMb6mi4vosh0qcPQrzJy5blgDy
         iDcTIfJxjOjN6cUGrkUr/E46WmsbbF5qTbuMXG72uu+1u2Al31WpdcfMBLg3jXJqtwWh
         ZOY8A8LgLA4ozUWTzjalYXoggX1mpR+7JRTd+gVi9THT21Js3FhG3XKAaXrhhbqcT1nx
         yuWMWnpORmOJoiy//Ko4eUfuLXg90GswKJ1EiGuGEdSwudr0yjQDqu8Jxo5lyKXQqp6n
         +OiN1Q38bJk++BlUdmTnqUhdqHO91fV/JMCkiYL9ionzayA7AeNbAESEuiDIxLpotNyF
         9fPw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=4dry6CCaIBUkMu2F1ipz/+c4RFHwg1uG9hT57nTkRjE=;
        b=uVZ65TwY3jg1TMN4+/c+SboceJMUfE9Lbxh7C7MEcRapqTydHWoqgMsHmXhDj3/fp1
         wH8M9cO9IU4oLRt4kBEJDZYqDpnDFMr6+XVxHLM4tsGSMgVGD2miBWU/zNtyceF1I6mx
         Bgbit96YmZt3SwYle9DBbvUNOmtWfygrFnMqE6+D2nPyl5crkT2md0XKgTU9EJzsjblR
         Tal+JwRI88BxPzkWLjo5bICRWo9shWxhh93PY+hLXyKbaIYnleE7+YCZNU4C8VXgvMJU
         2ih0IHN3gLEq6tgccj28IN1wF1hszEC9NE8PAzK58K9lr5H1IavEXaoZnSE8kZwAc6lD
         ZPcA==
X-Gm-Message-State: AOAM531G9/EDN3nYTmzoVRbkeL7/4YDzTm1ubii7H/TfFRUGR9s90Sn9
        60EDAMktESyAt2JDllvWPhrX0E2yuZrrxw==
X-Google-Smtp-Source: ABdhPJzhGoq/ETV1QWvnpl9UuZO0iu2AULEsKBuGrbwq0MplxkOvSIUh8N/eBtkYeSFDozAvUpLBbA==
X-Received: by 2002:a5d:460e:: with SMTP id t14mr589892wrq.68.1612915640112;
        Tue, 09 Feb 2021 16:07:20 -0800 (PST)
Received: from localhost.localdomain ([148.252.132.126])
        by smtp.gmail.com with ESMTPSA id n15sm391082wrx.2.2021.02.09.16.07.19
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 09 Feb 2021 16:07:19 -0800 (PST)
From:   Pavel Begunkov <asml.silence@gmail.com>
To:     Jens Axboe <axboe@kernel.dk>, io-uring@vger.kernel.org
Subject: [PATCH 05/17] io_uring: remove ctx from comp_state
Date:   Wed, 10 Feb 2021 00:03:11 +0000
Message-Id: <c30b6ba7652d6a4befef24a38d3cefa64c1abd73.1612915326.git.asml.silence@gmail.com>
X-Mailer: git-send-email 2.24.0
In-Reply-To: <cover.1612915326.git.asml.silence@gmail.com>
References: <cover.1612915326.git.asml.silence@gmail.com>
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
index 0606fa5f9eb0..f0cc5ccd6fe4 100644
--- a/fs/io_uring.c
+++ b/fs/io_uring.c
@@ -269,7 +269,6 @@ struct io_sq_data {
 struct io_comp_state {
 	unsigned int		nr;
 	struct list_head	list;
-	struct io_ring_ctx	*ctx;
 };
 
 struct io_submit_state {
@@ -1924,10 +1923,9 @@ static inline void io_req_complete_nostate(struct io_kiocb *req, long res,
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
@@ -6526,7 +6524,7 @@ static void __io_queue_sqe(struct io_kiocb *req, struct io_comp_state *cs)
 		if (req->flags & REQ_F_COMPLETE_INLINE) {
 			list_add_tail(&req->compl.list, &cs->list);
 			if (++cs->nr >= 32)
-				io_submit_flush_completions(cs);
+				io_submit_flush_completions(cs, req->ctx);
 			req = NULL;
 		} else {
 			req = io_put_req_find_next(req);
@@ -6661,10 +6659,11 @@ static int io_submit_sqe(struct io_kiocb *req, const struct io_uring_sqe *sqe,
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
@@ -6676,12 +6675,11 @@ static void io_submit_state_end(struct io_submit_state *state)
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
@@ -6865,7 +6863,7 @@ static int io_submit_sqes(struct io_ring_ctx *ctx, unsigned int nr)
 	percpu_counter_add(&current->io_uring->inflight, nr);
 	refcount_add(nr, &current->usage);
 
-	io_submit_state_start(&ctx->submit_state, ctx, nr);
+	io_submit_state_start(&ctx->submit_state, nr);
 	link.head = NULL;
 
 	for (i = 0; i < nr; i++) {
@@ -6914,7 +6912,7 @@ static int io_submit_sqes(struct io_ring_ctx *ctx, unsigned int nr)
 	}
 	if (link.head)
 		io_queue_link_head(link.head, &ctx->submit_state.comp);
-	io_submit_state_end(&ctx->submit_state);
+	io_submit_state_end(&ctx->submit_state, ctx);
 
 	 /* Commit SQ ring head once we've consumed and submitted all SQEs */
 	io_commit_sqring(ctx);
-- 
2.24.0

