Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 78A686D08C4
	for <lists+io-uring@lfdr.de>; Thu, 30 Mar 2023 16:54:40 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232537AbjC3Oyh (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Thu, 30 Mar 2023 10:54:37 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:33738 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232508AbjC3Oyg (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Thu, 30 Mar 2023 10:54:36 -0400
Received: from mail-wr1-x433.google.com (mail-wr1-x433.google.com [IPv6:2a00:1450:4864:20::433])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 0F043186;
        Thu, 30 Mar 2023 07:54:35 -0700 (PDT)
Received: by mail-wr1-x433.google.com with SMTP id v1so19392294wrv.1;
        Thu, 30 Mar 2023 07:54:34 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112; t=1680188074;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=QZd7Q0w7/z/xq1l37RPu+7/1znEwBdl9Vpp14WIchi8=;
        b=oF/E6TAr4lrfZC3fmGeL29xj5v2LilnNvXGMYN+gdNTEYSTobcTwHL6LMKkTnvTilM
         guWV31Ph4qQ12vMVFlMB9ziYdjPcyyFyUsGiPQlTbFQTPIuT/h/y7KoNi5T3NvGWxZXS
         btEX8m6FwtdOP1vj2Xk0DudDnm0Z4lJxtRd75g9EBhQIW8PmRDGrJ5M+2yv3yevg0Z0Y
         z3EOIPlf1W67j7MJZTP7tTv5DGVjSaCwuRN4D+6umji+8us0pcx4vt1FPWIsSwP2/BBK
         2Qj0AS1PinRa6wnfLaukPvvitAD67UH7whoWpVytPV9clOKYcEZr+Qw4xNomkHHYSsSK
         t4hQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112; t=1680188074;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=QZd7Q0w7/z/xq1l37RPu+7/1znEwBdl9Vpp14WIchi8=;
        b=riWvFsM7E8fx0B2T40iZEvXFzW74SBenDk3odP9lvs2gxuzZvqUPPyzL4GQu9XISMO
         JhQ/lq/7zA+HPmJa751y/iHlkPgwGSPmZJQrfx5e58AlZouDBw1oSmLqHhBPru5X8yCs
         2LJNdVwzC/NBGE1xsEii0Q3mq8QOJP+ejeQKm/nJtNrnwYTwU7/r3mKXy5lP3cOHHAN8
         gNDU1LkBKQYe/TPig90n6G2SZf0ULitcWltKqUTYnfJditkxYPPxl8Iysd72v9pNZzEl
         tlhF6TLvUDoof8nM2C3kLGTc5z6ngzp0XX3f/zC+irM0e6tt/p53oaU3YxcicgGrKuC4
         9t7w==
X-Gm-Message-State: AAQBX9chM8VXRmM6OVk5RdOJroJc5yuh3e3tNb0LKXmJclXucaTbTyaz
        w2AhoamhpYp79ueTocEUWBAPXDlCPrw=
X-Google-Smtp-Source: AKy350Y/uNss0dH9UJEjHVr3ULZNinKqCUYLvQ+llFtcI5K/Q44twm7N8/1LPksPqh49OQZR8Pn+Gw==
X-Received: by 2002:a05:6000:12c3:b0:2ce:9f35:b645 with SMTP id l3-20020a05600012c300b002ce9f35b645mr19081107wrx.20.1680188074358;
        Thu, 30 Mar 2023 07:54:34 -0700 (PDT)
Received: from 127.0.0.1localhost (82-132-231-234.dab.02.net. [82.132.231.234])
        by smtp.gmail.com with ESMTPSA id d7-20020adffbc7000000b002d5a8d8442asm28727962wrs.37.2023.03.30.07.54.33
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 30 Mar 2023 07:54:34 -0700 (PDT)
From:   Pavel Begunkov <asml.silence@gmail.com>
To:     io-uring@vger.kernel.org
Cc:     Jens Axboe <axboe@kernel.dk>, asml.silence@gmail.com,
        linux-kernel@vger.kernel.org
Subject: [PATCH 02/11] io_uring/rsrc: keep cached refs per node
Date:   Thu, 30 Mar 2023 15:53:20 +0100
Message-Id: <c2cce457579b157b91c358ed0224343171be08c3.1680187408.git.asml.silence@gmail.com>
X-Mailer: git-send-email 2.39.1
In-Reply-To: <cover.1680187408.git.asml.silence@gmail.com>
References: <cover.1680187408.git.asml.silence@gmail.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-0.2 required=5.0 tests=DKIM_SIGNED,DKIM_VALID,
        DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_FROM,RCVD_IN_DNSWL_NONE,
        SPF_HELO_NONE,SPF_PASS autolearn=unavailable autolearn_force=no
        version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org

We cache refs of the current node (i.e. ctx->rsrc_node) in
ctx->rsrc_cached_refs. We'll be moving away from atomics, so move the
cached refs in struct io_rsrc_node for now. It's a prep patch and
shouldn't change anything in practise.

Signed-off-by: Pavel Begunkov <asml.silence@gmail.com>
---
 include/linux/io_uring_types.h |  1 -
 io_uring/rsrc.c                | 15 +++++++++------
 io_uring/rsrc.h                | 16 +++++++++-------
 3 files changed, 18 insertions(+), 14 deletions(-)

diff --git a/include/linux/io_uring_types.h b/include/linux/io_uring_types.h
index 561fa421c453..a0a5b5964d3a 100644
--- a/include/linux/io_uring_types.h
+++ b/include/linux/io_uring_types.h
@@ -240,7 +240,6 @@ struct io_ring_ctx {
 		 * uring_lock, and updated through io_uring_register(2)
 		 */
 		struct io_rsrc_node	*rsrc_node;
-		int			rsrc_cached_refs;
 		atomic_t		cancel_seq;
 		struct io_file_table	file_table;
 		unsigned		nr_user_files;
diff --git a/io_uring/rsrc.c b/io_uring/rsrc.c
index f2da9e251e3f..1e7c960737fd 100644
--- a/io_uring/rsrc.c
+++ b/io_uring/rsrc.c
@@ -36,9 +36,11 @@ static int io_sqe_buffer_register(struct io_ring_ctx *ctx, struct iovec *iov,
 void io_rsrc_refs_drop(struct io_ring_ctx *ctx)
 	__must_hold(&ctx->uring_lock)
 {
-	if (ctx->rsrc_cached_refs) {
-		io_rsrc_put_node(ctx->rsrc_node, ctx->rsrc_cached_refs);
-		ctx->rsrc_cached_refs = 0;
+	struct io_rsrc_node *node = ctx->rsrc_node;
+
+	if (node && node->cached_refs) {
+		io_rsrc_put_node(node, node->cached_refs);
+		node->cached_refs = 0;
 	}
 }
 
@@ -151,11 +153,11 @@ static void io_buffer_unmap(struct io_ring_ctx *ctx, struct io_mapped_ubuf **slo
 	*slot = NULL;
 }
 
-void io_rsrc_refs_refill(struct io_ring_ctx *ctx)
+void io_rsrc_refs_refill(struct io_ring_ctx *ctx, struct io_rsrc_node *node)
 	__must_hold(&ctx->uring_lock)
 {
-	ctx->rsrc_cached_refs += IO_RSRC_REF_BATCH;
-	refcount_add(IO_RSRC_REF_BATCH, &ctx->rsrc_node->refs);
+	node->cached_refs += IO_RSRC_REF_BATCH;
+	refcount_add(IO_RSRC_REF_BATCH, &node->refs);
 }
 
 static void __io_rsrc_put_work(struct io_rsrc_node *ref_node)
@@ -300,6 +302,7 @@ void io_rsrc_node_switch(struct io_ring_ctx *ctx,
 	if (!ctx->rsrc_node) {
 		ctx->rsrc_node = ctx->rsrc_backup_node;
 		ctx->rsrc_backup_node = NULL;
+		ctx->rsrc_node->cached_refs = 0;
 	}
 }
 
diff --git a/io_uring/rsrc.h b/io_uring/rsrc.h
index 1467b31843bc..950535e2b9f4 100644
--- a/io_uring/rsrc.h
+++ b/io_uring/rsrc.h
@@ -43,6 +43,7 @@ struct io_rsrc_node {
 	struct io_rsrc_data		*rsrc_data;
 	struct llist_node		llist;
 	bool				done;
+	int				cached_refs;
 };
 
 struct io_mapped_ubuf {
@@ -56,7 +57,7 @@ struct io_mapped_ubuf {
 void io_rsrc_put_tw(struct callback_head *cb);
 void io_rsrc_node_ref_zero(struct io_rsrc_node *node);
 void io_rsrc_put_work(struct work_struct *work);
-void io_rsrc_refs_refill(struct io_ring_ctx *ctx);
+void io_rsrc_refs_refill(struct io_ring_ctx *ctx, struct io_rsrc_node *node);
 void io_wait_rsrc_data(struct io_rsrc_data *data);
 void io_rsrc_node_destroy(struct io_rsrc_node *ref_node);
 void io_rsrc_refs_drop(struct io_ring_ctx *ctx);
@@ -128,17 +129,18 @@ static inline void io_req_put_rsrc_locked(struct io_kiocb *req,
 
 	if (node) {
 		if (node == ctx->rsrc_node)
-			ctx->rsrc_cached_refs++;
+			node->cached_refs++;
 		else
 			io_rsrc_put_node(node, 1);
 	}
 }
 
-static inline void io_charge_rsrc_node(struct io_ring_ctx *ctx)
+static inline void io_charge_rsrc_node(struct io_ring_ctx *ctx,
+				       struct io_rsrc_node *node)
 {
-	ctx->rsrc_cached_refs--;
-	if (unlikely(ctx->rsrc_cached_refs < 0))
-		io_rsrc_refs_refill(ctx);
+	node->cached_refs--;
+	if (unlikely(node->cached_refs < 0))
+		io_rsrc_refs_refill(ctx, node);
 }
 
 static inline void io_req_set_rsrc_node(struct io_kiocb *req,
@@ -151,7 +153,7 @@ static inline void io_req_set_rsrc_node(struct io_kiocb *req,
 		lockdep_assert_held(&ctx->uring_lock);
 
 		req->rsrc_node = ctx->rsrc_node;
-		io_charge_rsrc_node(ctx);
+		io_charge_rsrc_node(ctx, ctx->rsrc_node);
 		io_ring_submit_unlock(ctx, issue_flags);
 	}
 }
-- 
2.39.1

