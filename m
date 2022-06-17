Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 6395A54F389
	for <lists+io-uring@lfdr.de>; Fri, 17 Jun 2022 10:50:01 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232153AbiFQIto (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Fri, 17 Jun 2022 04:49:44 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:37012 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1381202AbiFQItn (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Fri, 17 Jun 2022 04:49:43 -0400
Received: from mail-ej1-x62f.google.com (mail-ej1-x62f.google.com [IPv6:2a00:1450:4864:20::62f])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id BB35E694A7
        for <io-uring@vger.kernel.org>; Fri, 17 Jun 2022 01:49:42 -0700 (PDT)
Received: by mail-ej1-x62f.google.com with SMTP id me5so7500933ejb.2
        for <io-uring@vger.kernel.org>; Fri, 17 Jun 2022 01:49:42 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=rKPW3KVlt1u18qMCZgYvTymdgmCgX21z8bSne7YHzn8=;
        b=Ca+nd77mLXzQHrj06OwyJ4YKgNt/7rYQWPtXKHmVChbJNP5LAHS3R+q+EKXqBaCUJ3
         GJxV86YLcMCfn4tykwRK8XgAo2YxTPL4TRr+kkDT2rmofeK3gr2py7xlz4zJbgI9OoIg
         XnuDB1CZaGOrV7KkiRrjboxthDCIPTIxat6cUab/dJ7eQur3w5mHHy1Q3x3z/sERSoxa
         9qEckefNWuBwclOHwxku6Ob7ImvXEJJeDwNsLXfIIU/49y4WNwubFKg4hiuBjNAI8bIO
         yrRPd+R7pPCZJcK88ha8RcxKlK9J+IY1heELlsuvPRQR+DBv25uPnG77pmnrXc2/2AC0
         DMXg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=rKPW3KVlt1u18qMCZgYvTymdgmCgX21z8bSne7YHzn8=;
        b=14etbfg3bTkAyo2W8nhmfIZVHs4K+LGrSonURj3nZ0kVez33FD7/dannamPGemETlJ
         9IfVeRmMNwct6U/kdAE/Skj20KWCnxle+ueZquEI2zfLLgrorV60fjEeH70ohQb8fjrX
         ktcRNxFKviL3ylHbGWI9GL9cAGghbXZ9yqVhtHEWmKr4Hj86YnF4TD94Xc5NIQMxxBv9
         xkamJ4JDR7PpmWMXyeTo36su7GSBLqLCc/X4BSLbEuo4zYtpOlbQmuWs7HtABC0Nu0C3
         ELhSJpYqODejZ5tJMqNdjJACmkFnfx0OPz7lG9by/BWFRaW2EoN5Fn8qOza24/9KF8vc
         6DdQ==
X-Gm-Message-State: AJIora9fpn3Ln0XqvvdMY+DdJC7wqJSaPHBqB1b4XegCT3mffdWXFNBy
        HzFQ3r1vr2eenNdiq2SVb9Zd/2oPYh2s9Q==
X-Google-Smtp-Source: AGRyM1vDafAULjC2YAIkAJKKA2PcyXBE5uzAdwo1ukg3we0ULIlcOhjzbx/MZC2VSY69hEyK4mIwsA==
X-Received: by 2002:a17:907:3f92:b0:706:db40:a0ef with SMTP id hr18-20020a1709073f9200b00706db40a0efmr8148832ejc.524.1655455780971;
        Fri, 17 Jun 2022 01:49:40 -0700 (PDT)
Received: from 127.0.0.1localhost.com ([2620:10d:c092:600::2:b65a])
        by smtp.gmail.com with ESMTPSA id u17-20020a1709060b1100b006ff52dfccf3sm1851895ejg.211.2022.06.17.01.49.40
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 17 Jun 2022 01:49:40 -0700 (PDT)
From:   Pavel Begunkov <asml.silence@gmail.com>
To:     io-uring@vger.kernel.org
Cc:     Jens Axboe <axboe@kernel.dk>, asml.silence@gmail.com
Subject: [PATCH for-next 2/6] io_uring: don't inline __io_get_cqe()
Date:   Fri, 17 Jun 2022 09:48:01 +0100
Message-Id: <c1ac829198a881b7af8710926f99a3559b9f24c0.1655455613.git.asml.silence@gmail.com>
X-Mailer: git-send-email 2.36.1
In-Reply-To: <cover.1655455613.git.asml.silence@gmail.com>
References: <cover.1655455613.git.asml.silence@gmail.com>
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

__io_get_cqe() is not as hot as io_get_cqe(), no need to inline it, it
sheds ~500B from the binary.

Signed-off-by: Pavel Begunkov <asml.silence@gmail.com>
---
 io_uring/io_uring.c | 35 +++++++++++++++++++++++++++++++++++
 io_uring/io_uring.h | 36 +-----------------------------------
 2 files changed, 36 insertions(+), 35 deletions(-)

diff --git a/io_uring/io_uring.c b/io_uring/io_uring.c
index 7ffb8422e7d0..a3b1339335c5 100644
--- a/io_uring/io_uring.c
+++ b/io_uring/io_uring.c
@@ -165,6 +165,11 @@ static inline void io_submit_flush_completions(struct io_ring_ctx *ctx)
 		__io_submit_flush_completions(ctx);
 }
 
+static inline unsigned int __io_cqring_events(struct io_ring_ctx *ctx)
+{
+	return ctx->cached_cq_tail - READ_ONCE(ctx->rings->cq.head);
+}
+
 static bool io_match_linked(struct io_kiocb *head)
 {
 	struct io_kiocb *req;
@@ -673,6 +678,36 @@ bool io_cqring_event_overflow(struct io_ring_ctx *ctx, u64 user_data, s32 res,
 	return true;
 }
 
+/*
+ * writes to the cq entry need to come after reading head; the
+ * control dependency is enough as we're using WRITE_ONCE to
+ * fill the cq entry
+ */
+struct io_uring_cqe *__io_get_cqe(struct io_ring_ctx *ctx)
+{
+	struct io_rings *rings = ctx->rings;
+	unsigned int off = ctx->cached_cq_tail & (ctx->cq_entries - 1);
+	unsigned int shift = 0;
+	unsigned int free, queued, len;
+
+	if (ctx->flags & IORING_SETUP_CQE32)
+		shift = 1;
+
+	/* userspace may cheat modifying the tail, be safe and do min */
+	queued = min(__io_cqring_events(ctx), ctx->cq_entries);
+	free = ctx->cq_entries - queued;
+	/* we need a contiguous range, limit based on the current array offset */
+	len = min(free, ctx->cq_entries - off);
+	if (!len)
+		return NULL;
+
+	ctx->cached_cq_tail++;
+	ctx->cqe_cached = &rings->cqes[off];
+	ctx->cqe_sentinel = ctx->cqe_cached + len;
+	ctx->cqe_cached++;
+	return &rings->cqes[off << shift];
+}
+
 static bool io_fill_cqe_aux(struct io_ring_ctx *ctx,
 			    u64 user_data, s32 res, u32 cflags)
 {
diff --git a/io_uring/io_uring.h b/io_uring/io_uring.h
index ce6538c9aed3..51032a494aec 100644
--- a/io_uring/io_uring.h
+++ b/io_uring/io_uring.h
@@ -16,44 +16,10 @@ enum {
 	IOU_ISSUE_SKIP_COMPLETE	= -EIOCBQUEUED,
 };
 
+struct io_uring_cqe *__io_get_cqe(struct io_ring_ctx *ctx);
 bool io_cqring_event_overflow(struct io_ring_ctx *ctx, u64 user_data, s32 res,
 			      u32 cflags, u64 extra1, u64 extra2);
 
-static inline unsigned int __io_cqring_events(struct io_ring_ctx *ctx)
-{
-	return ctx->cached_cq_tail - READ_ONCE(ctx->rings->cq.head);
-}
-
-/*
- * writes to the cq entry need to come after reading head; the
- * control dependency is enough as we're using WRITE_ONCE to
- * fill the cq entry
- */
-static inline struct io_uring_cqe *__io_get_cqe(struct io_ring_ctx *ctx)
-{
-	struct io_rings *rings = ctx->rings;
-	unsigned int off = ctx->cached_cq_tail & (ctx->cq_entries - 1);
-	unsigned int shift = 0;
-	unsigned int free, queued, len;
-
-	if (ctx->flags & IORING_SETUP_CQE32)
-		shift = 1;
-
-	/* userspace may cheat modifying the tail, be safe and do min */
-	queued = min(__io_cqring_events(ctx), ctx->cq_entries);
-	free = ctx->cq_entries - queued;
-	/* we need a contiguous range, limit based on the current array offset */
-	len = min(free, ctx->cq_entries - off);
-	if (!len)
-		return NULL;
-
-	ctx->cached_cq_tail++;
-	ctx->cqe_cached = &rings->cqes[off];
-	ctx->cqe_sentinel = ctx->cqe_cached + len;
-	ctx->cqe_cached++;
-	return &rings->cqes[off << shift];
-}
-
 static inline struct io_uring_cqe *io_get_cqe(struct io_ring_ctx *ctx)
 {
 	if (likely(ctx->cqe_cached < ctx->cqe_sentinel)) {
-- 
2.36.1

