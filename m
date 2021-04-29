Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 1E5C636EEC2
	for <lists+io-uring@lfdr.de>; Thu, 29 Apr 2021 19:20:58 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233329AbhD2RVl (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Thu, 29 Apr 2021 13:21:41 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:50444 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233552AbhD2RVl (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Thu, 29 Apr 2021 13:21:41 -0400
Received: from mail-wr1-x42e.google.com (mail-wr1-x42e.google.com [IPv6:2a00:1450:4864:20::42e])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 677EAC06138C
        for <io-uring@vger.kernel.org>; Thu, 29 Apr 2021 10:20:54 -0700 (PDT)
Received: by mail-wr1-x42e.google.com with SMTP id z6so6423095wrm.4
        for <io-uring@vger.kernel.org>; Thu, 29 Apr 2021 10:20:54 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:subject:date:message-id:in-reply-to:references:mime-version
         :content-transfer-encoding;
        bh=afTnP62qb92jH5uIvHL0LOvP3JYGeVL9jzQRaetWkGk=;
        b=KnAVwbTZb5r0GViQSspHyN3V7UF3XryTKbnMYDL2qrdfbHd3LFn3yrG5hHTiRAHYbH
         CCXnrfFCxVDN9qkTeInXyLRADuaySxjk7SocQclXQOxlOZiawHQWMAJM/BIvInZwgAYg
         j8fCLf0WLDB3WhPvKb74eRRB1H04/QvtK6lKYmvvan68NXVe4d745zShFZAN6RfXGN23
         6FzIwd+56HcnnwJkw3cLeJ9wocdnSrWVFKVJm9xI4YXT9xuoyEHwo3N1lu5p54x41HF9
         PzLLxLHmDeFEzLVK/U3xudg6rYmFvBKWr3mvyurv6O/7/NcdtP3lxpFEcu/U48Ghlg9e
         x+2w==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=afTnP62qb92jH5uIvHL0LOvP3JYGeVL9jzQRaetWkGk=;
        b=p9a3GxA6LmZUQxdn2etCxv5F5fHBWa6Co+BQqjR1t7fHfKJC/ogpLlQcbm9O5+1RXm
         CLE28Bo+fHomTDOsryEn6hCQhEFT9vdSdhjl52dyjJ5W/LqVaIDFplMR4Czyv5eUwEZB
         cgigmyer+vjsZ5+dVVUSqwv3r2uhhyNofg5EQOqEmU8XaJVUEaPuV/p2u6WpLBQKS8gw
         e1Z6SaH5bhjgWg1XAXtKPbLnWrnmhpjP443L4sey4d8SZLPy0UmxEGPi+AtdNnLv9mzn
         moe1wFlSxLn2OamUbRFedzMIm6KnEOCphk6rRcGA31/yQqrRele9gmk9PseR9XpcJFwm
         +7Rg==
X-Gm-Message-State: AOAM533gUHPoiMYnwnmMp4cXszBz6t39ms1whnn0D78NDaIGT5Cww+tq
        T4OtlFkpuZnbZz+p8ftrJY/+h/lzlsE=
X-Google-Smtp-Source: ABdhPJwDxdjnTxocyNhNe6qbCn0I0bbiF5aVq5gfGFgMiRSdhQHh6bMxN0qKNYxz/H0OqJzbe36Z6Q==
X-Received: by 2002:a5d:4707:: with SMTP id y7mr958887wrq.137.1619716853209;
        Thu, 29 Apr 2021 10:20:53 -0700 (PDT)
Received: from localhost.localdomain ([148.252.132.80])
        by smtp.gmail.com with ESMTPSA id f6sm5498593wrt.19.2021.04.29.10.20.52
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 29 Apr 2021 10:20:52 -0700 (PDT)
From:   Pavel Begunkov <asml.silence@gmail.com>
To:     Jens Axboe <axboe@kernel.dk>, io-uring@vger.kernel.org
Subject: [PATCH v2 1/2] io_uring: defer submission ref put
Date:   Thu, 29 Apr 2021 18:20:41 +0100
Message-Id: <702e726ec0dedb97513ac4819f4ce6aea8cfc848.1619716401.git.asml.silence@gmail.com>
X-Mailer: git-send-email 2.31.1
In-Reply-To: <cover.1619716401.git.asml.silence@gmail.com>
References: <cover.1619716401.git.asml.silence@gmail.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org

Signed-off-by: Pavel Begunkov <asml.silence@gmail.com>
---
 fs/io_uring.c | 27 ++++++++++++---------------
 1 file changed, 12 insertions(+), 15 deletions(-)

diff --git a/fs/io_uring.c b/fs/io_uring.c
index 43b00077dbd3..9c8e1e773a34 100644
--- a/fs/io_uring.c
+++ b/fs/io_uring.c
@@ -2124,7 +2124,7 @@ static void io_req_free_batch(struct req_batch *rb, struct io_kiocb *req,
 static void io_submit_flush_completions(struct io_comp_state *cs,
 					struct io_ring_ctx *ctx)
 {
-	int i, nr = cs->nr;
+	int refs, i, nr = cs->nr;
 	struct io_kiocb *req;
 	struct req_batch rb;
 
@@ -2132,8 +2132,9 @@ static void io_submit_flush_completions(struct io_comp_state *cs,
 	spin_lock_irq(&ctx->completion_lock);
 	for (i = 0; i < nr; i++) {
 		req = cs->reqs[i];
-		__io_cqring_fill_event(ctx, req->user_data, req->result,
-					req->compl.cflags);
+		if (req->flags & REQ_F_COMPLETE_INLINE)
+			__io_cqring_fill_event(ctx, req->user_data, req->result,
+						req->compl.cflags);
 	}
 	io_commit_cqring(ctx);
 	spin_unlock_irq(&ctx->completion_lock);
@@ -2141,9 +2142,10 @@ static void io_submit_flush_completions(struct io_comp_state *cs,
 	io_cqring_ev_posted(ctx);
 	for (i = 0; i < nr; i++) {
 		req = cs->reqs[i];
+		refs = 1 + !!(req->flags & REQ_F_COMPLETE_INLINE);
 
 		/* submission and completion refs */
-		if (req_ref_sub_and_test(req, 2))
+		if (req_ref_sub_and_test(req, refs))
 			io_req_free_batch(&rb, req, &ctx->submit_state);
 	}
 
@@ -6417,17 +6419,12 @@ static void __io_queue_sqe(struct io_kiocb *req)
 	 * doesn't support non-blocking read/write attempts
 	 */
 	if (likely(!ret)) {
-		/* drop submission reference */
-		if (req->flags & REQ_F_COMPLETE_INLINE) {
-			struct io_ring_ctx *ctx = req->ctx;
-			struct io_comp_state *cs = &ctx->submit_state.comp;
-
-			cs->reqs[cs->nr++] = req;
-			if (cs->nr == ARRAY_SIZE(cs->reqs))
-				io_submit_flush_completions(cs, ctx);
-		} else {
-			io_put_req(req);
-		}
+		struct io_ring_ctx *ctx = req->ctx;
+		struct io_comp_state *cs = &ctx->submit_state.comp;
+
+		cs->reqs[cs->nr++] = req;
+		if (cs->nr == ARRAY_SIZE(cs->reqs))
+			io_submit_flush_completions(cs, ctx);
 	} else if (ret == -EAGAIN && !(req->flags & REQ_F_NOWAIT)) {
 		if (!io_arm_poll_handler(req)) {
 			/*
-- 
2.31.1

