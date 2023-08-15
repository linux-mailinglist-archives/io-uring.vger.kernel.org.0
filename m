Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 5DFEB77D125
	for <lists+io-uring@lfdr.de>; Tue, 15 Aug 2023 19:34:06 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S238900AbjHORde (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Tue, 15 Aug 2023 13:33:34 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:49666 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S238922AbjHORdV (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Tue, 15 Aug 2023 13:33:21 -0400
Received: from mail-ed1-x52a.google.com (mail-ed1-x52a.google.com [IPv6:2a00:1450:4864:20::52a])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 9CD181BE2
        for <io-uring@vger.kernel.org>; Tue, 15 Aug 2023 10:33:19 -0700 (PDT)
Received: by mail-ed1-x52a.google.com with SMTP id 4fb4d7f45d1cf-52164adea19so7373245a12.1
        for <io-uring@vger.kernel.org>; Tue, 15 Aug 2023 10:33:19 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20221208; t=1692120798; x=1692725598;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=sKStySJbeJj78mrIoTJYsb3Dd14PzI0c1EBmjN6i/cc=;
        b=C1+H39Q09sPqfZTf0P36rdVSFHw0vSGCKy6IgunC17pgd0z3Go59bZaS3Y1AjJuJ2G
         v7B0fK9QevzWyyUVn6XkAKFbshaxy5zTwGEuWJKh37Qp902q209EG+wKGob/kLQXLQ/S
         4Q5I1xfidNHuDqmTQIznNToopCc60ikvOjnKJA7k+GZlyX+d65f5DbrW3pK1c1qDOTyQ
         HRRsxZpC8ibFRfQKVB1rsr1u2DsedTwbpDyWloWmDkBP+DOgjdail+8NHZ8hBQklSuOr
         9FvP8DsDKcjYBJ//OVbDOKpCUsR0QjKaIGxMtAVviNbLZ7PwTjSwSuRWC6zbaM4jacsF
         Euvw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20221208; t=1692120798; x=1692725598;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=sKStySJbeJj78mrIoTJYsb3Dd14PzI0c1EBmjN6i/cc=;
        b=R7Ee/eh8ItHfVjc9fS3UBjpriHs6nZkhQtcnpfFJL7GcAB842A+wV3gD/A4j7FvKo5
         3M5FtXs13vPOZ5w7GsGnfcKbN1HDEIyEUFKpzMxoevNGQJO7TKqsWsi8pzFAiVsisxZK
         oGGxMI/udhajBVrPS7DrssQlbkujqnd2lVVnCzrB99AdZk7CYzKy0QWVyvl/oM74GLon
         n8pxMnPjgII9YfyDstcBOJTlZFO8tKLf+KzNd3lkdyOsnT6JCtSn5XhG/05zPll881sY
         IeWsG+7TdTcgQTO2hLqYZL6dJumnndHG5rKV+PnwiCQxfV5S2sOMEIO1+dmnUVt/0qHV
         +3Mg==
X-Gm-Message-State: AOJu0YxnE7Rgnn8TwmwjtES5UCF4aN9RF0jKVwNT/54/wQCb1XLtzmCR
        tidzWcIWWHGmCPUFT9Y2Q24X49SapVU=
X-Google-Smtp-Source: AGHT+IFY2mHgTXOaiLJSQPPd7U/s56LiSSkAGf1Vv1+lX+/6D2zT25Q/MFMyYwsqOYXPs3EwJ2XQ4g==
X-Received: by 2002:a17:907:2724:b0:993:d536:3cb7 with SMTP id d4-20020a170907272400b00993d5363cb7mr10013824ejl.11.1692120797669;
        Tue, 15 Aug 2023 10:33:17 -0700 (PDT)
Received: from 127.com ([2620:10d:c092:600::2:6d35])
        by smtp.gmail.com with ESMTPSA id kk9-20020a170907766900b0099cc36c4681sm7269878ejc.157.2023.08.15.10.33.17
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 15 Aug 2023 10:33:17 -0700 (PDT)
From:   Pavel Begunkov <asml.silence@gmail.com>
To:     io-uring@vger.kernel.org
Cc:     Jens Axboe <axboe@kernel.dk>, asml.silence@gmail.com
Subject: [PATCH 04/16] io_uring: refactor __io_get_cqe()
Date:   Tue, 15 Aug 2023 18:31:33 +0100
Message-ID: <988404c49503827bdf705a14fed5d9c3e95383af.1692119257.git.asml.silence@gmail.com>
X-Mailer: git-send-email 2.41.0
In-Reply-To: <cover.1692119257.git.asml.silence@gmail.com>
References: <cover.1692119257.git.asml.silence@gmail.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_FROM,
        RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org

Make __io_get_cqe simpler by not grabbing the cqe from refilled cached,
but letting io_get_cqe() do it for us. That's cleaner and removes some
duplication.

Signed-off-by: Pavel Begunkov <asml.silence@gmail.com>
---
 io_uring/io_uring.c | 13 ++++---------
 io_uring/io_uring.h | 23 ++++++++++++-----------
 2 files changed, 16 insertions(+), 20 deletions(-)

diff --git a/io_uring/io_uring.c b/io_uring/io_uring.c
index 20b46e64cc07..623d41755714 100644
--- a/io_uring/io_uring.c
+++ b/io_uring/io_uring.c
@@ -818,7 +818,7 @@ void io_req_cqe_overflow(struct io_kiocb *req)
  * control dependency is enough as we're using WRITE_ONCE to
  * fill the cq entry
  */
-struct io_uring_cqe *__io_get_cqe(struct io_ring_ctx *ctx, bool overflow)
+bool io_cqe_cache_refill(struct io_ring_ctx *ctx, bool overflow)
 {
 	struct io_rings *rings = ctx->rings;
 	unsigned int off = ctx->cached_cq_tail & (ctx->cq_entries - 1);
@@ -830,7 +830,7 @@ struct io_uring_cqe *__io_get_cqe(struct io_ring_ctx *ctx, bool overflow)
 	 * Force overflow the completion.
 	 */
 	if (!overflow && (ctx->check_cq & BIT(IO_CHECK_CQ_OVERFLOW_BIT)))
-		return NULL;
+		return false;
 
 	/* userspace may cheat modifying the tail, be safe and do min */
 	queued = min(__io_cqring_events(ctx), ctx->cq_entries);
@@ -838,7 +838,7 @@ struct io_uring_cqe *__io_get_cqe(struct io_ring_ctx *ctx, bool overflow)
 	/* we need a contiguous range, limit based on the current array offset */
 	len = min(free, ctx->cq_entries - off);
 	if (!len)
-		return NULL;
+		return false;
 
 	if (ctx->flags & IORING_SETUP_CQE32) {
 		off <<= 1;
@@ -847,12 +847,7 @@ struct io_uring_cqe *__io_get_cqe(struct io_ring_ctx *ctx, bool overflow)
 
 	ctx->cqe_cached = &rings->cqes[off];
 	ctx->cqe_sentinel = ctx->cqe_cached + len;
-
-	ctx->cached_cq_tail++;
-	ctx->cqe_cached++;
-	if (ctx->flags & IORING_SETUP_CQE32)
-		ctx->cqe_cached++;
-	return &rings->cqes[off];
+	return true;
 }
 
 static bool io_fill_cqe_aux(struct io_ring_ctx *ctx, u64 user_data, s32 res,
diff --git a/io_uring/io_uring.h b/io_uring/io_uring.h
index 9b5dfb6ef484..9c80d20fe18f 100644
--- a/io_uring/io_uring.h
+++ b/io_uring/io_uring.h
@@ -38,7 +38,7 @@ enum {
 	IOU_STOP_MULTISHOT	= -ECANCELED,
 };
 
-struct io_uring_cqe *__io_get_cqe(struct io_ring_ctx *ctx, bool overflow);
+bool io_cqe_cache_refill(struct io_ring_ctx *ctx, bool overflow);
 void io_req_cqe_overflow(struct io_kiocb *req);
 int io_run_task_work_sig(struct io_ring_ctx *ctx);
 void io_req_defer_failed(struct io_kiocb *req, s32 res);
@@ -112,19 +112,20 @@ static inline void io_req_task_work_add(struct io_kiocb *req)
 static inline struct io_uring_cqe *io_get_cqe_overflow(struct io_ring_ctx *ctx,
 						       bool overflow)
 {
-	io_lockdep_assert_cq_locked(ctx);
+	struct io_uring_cqe *cqe;
 
-	if (likely(ctx->cqe_cached < ctx->cqe_sentinel)) {
-		struct io_uring_cqe *cqe = ctx->cqe_cached;
+	io_lockdep_assert_cq_locked(ctx);
 
-		ctx->cached_cq_tail++;
-		ctx->cqe_cached++;
-		if (ctx->flags & IORING_SETUP_CQE32)
-			ctx->cqe_cached++;
-		return cqe;
+	if (unlikely(ctx->cqe_cached >= ctx->cqe_sentinel)) {
+		if (unlikely(!io_cqe_cache_refill(ctx, overflow)))
+			return NULL;
 	}
-
-	return __io_get_cqe(ctx, overflow);
+	cqe = ctx->cqe_cached;
+	ctx->cached_cq_tail++;
+	ctx->cqe_cached++;
+	if (ctx->flags & IORING_SETUP_CQE32)
+		ctx->cqe_cached++;
+	return cqe;
 }
 
 static inline struct io_uring_cqe *io_get_cqe(struct io_ring_ctx *ctx)
-- 
2.41.0

