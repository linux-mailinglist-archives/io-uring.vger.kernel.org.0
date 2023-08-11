Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 355B1778FF4
	for <lists+io-uring@lfdr.de>; Fri, 11 Aug 2023 14:55:18 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235068AbjHKMzR (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Fri, 11 Aug 2023 08:55:17 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:51776 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229449AbjHKMzP (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Fri, 11 Aug 2023 08:55:15 -0400
Received: from mail-ej1-x62d.google.com (mail-ej1-x62d.google.com [IPv6:2a00:1450:4864:20::62d])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id C37ED109
        for <io-uring@vger.kernel.org>; Fri, 11 Aug 2023 05:55:14 -0700 (PDT)
Received: by mail-ej1-x62d.google.com with SMTP id a640c23a62f3a-99bcfe28909so266636066b.3
        for <io-uring@vger.kernel.org>; Fri, 11 Aug 2023 05:55:14 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20221208; t=1691758513; x=1692363313;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=3Gq8cfrl9gYUlpuskr6LbK2kqwA488iyjn0SSaKnIaM=;
        b=QCNwAp/YikysLZ9JyaMgFdUksbktzfAjAWxIwxfrff/SaTI80wwZLR/j+qR9029HXj
         awXTfa+SxelngWnx/bYYettzYd76EmSqjhF1aDFOaWOh9ybRiD33i0WbJStN8ea6lqeh
         B8hY5gAdtaZGSIrU5ym97gK9X7URBPVH2fe+dyemv+UpiVjJokI5tcU3FJEJIrFFODie
         OGaeMYjDSaRZJ1huAm+v03CZvkpQ+rfGN7Fov/dr9HOzFQYzkvmRkRg8wNAxvlEiykRr
         sxkAHHvKVYnmvNwqXNTjcUUP8BvSqQyJ29WhurBpM3WaLqdUPJTJWkZKRGsM3BmSzewc
         ci5g==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20221208; t=1691758513; x=1692363313;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=3Gq8cfrl9gYUlpuskr6LbK2kqwA488iyjn0SSaKnIaM=;
        b=X58wxW3HvaFGhPWjzszgUhx5zqRhkzZFQxT42LFLVLXKH31ahmO9FMqrlAU8JjuiqL
         plF/q1g88ZvgvIuSwtl/FwWRMczmCpjT+KRfQuccxZdMO7YytpIKMFCpX1QZJJgSEtQD
         /DkanVkpDIvc6Cy2vWeJMySyz9t7Y5IVf9G+J3aaAGp/YQm3bmMbqBzLOhVi5VSkjQYH
         6UC60XgE5xt0l8z0tnfcha1dA3ryyNQCRQmFcZXY/qwl+0lmp5pBiPLFOx39C63luYAg
         Vdv8Ebgicpkfc5u3xGKyYQYmEQEbzZ6ofjNH6OjBga3GrbKUTmP17kc0MzPhJyJ+33M3
         NxRQ==
X-Gm-Message-State: AOJu0Yx+jXhcZF1/88AdaUNGcEw4HN8YTOl3zEvsr2BnHnlOJFkKn0He
        3xGBsdbaNXXC8fZBQRL4PCzpDE5Ln2M=
X-Google-Smtp-Source: AGHT+IHkmtQswa5dgjfLsrINWwsjRF9qTnT/kdotZ698eALX6obvLuyLr8AeNPJMC1C/hjWUdMnA8Q==
X-Received: by 2002:a17:906:76ca:b0:991:b834:af83 with SMTP id q10-20020a17090676ca00b00991b834af83mr1595744ejn.59.1691758512427;
        Fri, 11 Aug 2023 05:55:12 -0700 (PDT)
Received: from 127.com ([2620:10d:c092:600::2:a57e])
        by smtp.gmail.com with ESMTPSA id kk9-20020a170907766900b0099cc36c4681sm2206943ejc.157.2023.08.11.05.55.12
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 11 Aug 2023 05:55:12 -0700 (PDT)
From:   Pavel Begunkov <asml.silence@gmail.com>
To:     io-uring@vger.kernel.org
Cc:     Jens Axboe <axboe@kernel.dk>, asml.silence@gmail.com
Subject: [PATCH 3/7] io_uring: open code io_fill_cqe_req()
Date:   Fri, 11 Aug 2023 13:53:43 +0100
Message-ID: <f432ce75bb1c94cadf0bd2add4d6aa510bd1fb36.1691757663.git.asml.silence@gmail.com>
X-Mailer: git-send-email 2.41.0
In-Reply-To: <cover.1691757663.git.asml.silence@gmail.com>
References: <cover.1691757663.git.asml.silence@gmail.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_FROM,
        RCVD_IN_DNSWL_BLOCKED,SPF_HELO_NONE,SPF_PASS autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org

io_fill_cqe_req() is only called from one place, open code it, and
rename __io_fill_cqe_req().

Signed-off-by: Pavel Begunkov <asml.silence@gmail.com>
---
 io_uring/io_uring.c |  8 +++++---
 io_uring/io_uring.h | 11 +----------
 io_uring/rw.c       |  2 +-
 3 files changed, 7 insertions(+), 14 deletions(-)

diff --git a/io_uring/io_uring.c b/io_uring/io_uring.c
index 047576bc98d0..e969b4ca1c47 100644
--- a/io_uring/io_uring.c
+++ b/io_uring/io_uring.c
@@ -978,8 +978,10 @@ static void __io_req_complete_post(struct io_kiocb *req, unsigned issue_flags)
 	struct io_rsrc_node *rsrc_node = NULL;
 
 	io_cq_lock(ctx);
-	if (!(req->flags & REQ_F_CQE_SKIP))
-		io_fill_cqe_req(ctx, req);
+	if (!(req->flags & REQ_F_CQE_SKIP)) {
+		if (!io_fill_cqe_req(ctx, req))
+			io_req_cqe_overflow(req);
+	}
 
 	/*
 	 * If we're the last reference to this request, add to our locked
@@ -1556,7 +1558,7 @@ static void __io_submit_flush_completions(struct io_ring_ctx *ctx)
 					    comp_list);
 
 		if (!(req->flags & REQ_F_CQE_SKIP) &&
-		    unlikely(!__io_fill_cqe_req(ctx, req))) {
+		    unlikely(!io_fill_cqe_req(ctx, req))) {
 			if (ctx->task_complete) {
 				spin_lock(&ctx->completion_lock);
 				io_req_cqe_overflow(req);
diff --git a/io_uring/io_uring.h b/io_uring/io_uring.h
index ff153af28236..3aa208fbe905 100644
--- a/io_uring/io_uring.h
+++ b/io_uring/io_uring.h
@@ -133,8 +133,7 @@ static inline struct io_uring_cqe *io_get_cqe(struct io_ring_ctx *ctx)
 	return io_get_cqe_overflow(ctx, false);
 }
 
-static inline bool __io_fill_cqe_req(struct io_ring_ctx *ctx,
-				     struct io_kiocb *req)
+static inline bool io_fill_cqe_req(struct io_ring_ctx *ctx, struct io_kiocb *req)
 {
 	struct io_uring_cqe *cqe;
 
@@ -168,14 +167,6 @@ static inline bool __io_fill_cqe_req(struct io_ring_ctx *ctx,
 	return true;
 }
 
-static inline bool io_fill_cqe_req(struct io_ring_ctx *ctx,
-				   struct io_kiocb *req)
-{
-	if (likely(__io_fill_cqe_req(ctx, req)))
-		return true;
-	return io_req_cqe_overflow(req);
-}
-
 static inline void req_set_fail(struct io_kiocb *req)
 {
 	req->flags |= REQ_F_FAIL;
diff --git a/io_uring/rw.c b/io_uring/rw.c
index 1bce2208b65c..9b51afdae505 100644
--- a/io_uring/rw.c
+++ b/io_uring/rw.c
@@ -1064,7 +1064,7 @@ int io_do_iopoll(struct io_ring_ctx *ctx, bool force_nonspin)
 			continue;
 
 		req->cqe.flags = io_put_kbuf(req, 0);
-		if (unlikely(!__io_fill_cqe_req(ctx, req))) {
+		if (unlikely(!io_fill_cqe_req(ctx, req))) {
 			spin_lock(&ctx->completion_lock);
 			io_req_cqe_overflow(req);
 			spin_unlock(&ctx->completion_lock);
-- 
2.41.0

