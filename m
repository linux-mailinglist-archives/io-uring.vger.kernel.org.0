Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id BC9C76D60F3
	for <lists+io-uring@lfdr.de>; Tue,  4 Apr 2023 14:41:01 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234911AbjDDMlA (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Tue, 4 Apr 2023 08:41:00 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:60034 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234497AbjDDMk4 (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Tue, 4 Apr 2023 08:40:56 -0400
Received: from mail-ed1-x536.google.com (mail-ed1-x536.google.com [IPv6:2a00:1450:4864:20::536])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 51DFA187;
        Tue,  4 Apr 2023 05:40:53 -0700 (PDT)
Received: by mail-ed1-x536.google.com with SMTP id r11so130054997edd.5;
        Tue, 04 Apr 2023 05:40:53 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112; t=1680612051;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=Gp4fQySUslStHdzI0fEQY4d4pTvLrEwKRJkhU50QDoY=;
        b=pso0Tc26NdvEP4utoF1qPtN5aQJgCmhgkdQZILTriOeyBFvXRLe+oWtQRva7Y7FNv4
         tVAJ4eptJr5L9BwP3aAhaemLpeybTKSRtQSbRzDK7Lp0T2s4XGMisjjwRW6ako2b4MVk
         jBzix4Rm/49oXRZuUmqaUP/BXSXgHRmZKBgE+3sRRU3pQfAJWL91moNjTuUNmk3jd22E
         qIAvg9KaZ2EeiVb71dKnrc4e8g+1GGD8qUsS3juFamrJMpxw8uyRZuDUJN0y2GH+Pall
         ZVo6SW3PAMKY+GKNQiiu/MnGYcXAEnstjz+ugzW7vYQe5/DUqBj1TU7POye6MvfjhTmw
         JsIA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112; t=1680612051;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=Gp4fQySUslStHdzI0fEQY4d4pTvLrEwKRJkhU50QDoY=;
        b=Pytw9CMJfFJ6KBKuA4SYJ63ABfLhZBSzqqn0yFrO2pyVi0RlHt3zjzWIhOJPibP61s
         QQ0JCvxdTnfsg6hzwJXF+1yiIqZEFU7e1Fi+x/Oz+hM/Gshn9p06Hmec27KAtKOhkrSe
         ht/nLezYM6oid+g5qplh+ExxUHmw2mTxU5keihAIzNsC3yttAK9kF9VipCrPa/ciZNmb
         3zCQi9wR88pO0Rqe41AljnyNWNOdV3R0y2NIny65lO2w7HpQuNM8pKEqZ+e/G7nYPaE6
         8IFzf+IKs+DeKKpNaR5QUMZTTH9N6NobAKG3BeqaWJDwYAZdo+P0dgC4176xoajFUndB
         /dXw==
X-Gm-Message-State: AAQBX9e2VcBRjopZkn5JGHwhwvf1OFasGHqwFfhqs10qotyqka8cgGeT
        CgHN592T9HfcN1s+luzDAsZlxvo2WXY=
X-Google-Smtp-Source: AKy350ZP4n7W9Q5n97ILOsegiFTMiApDS70ag35mU/2GrupX2X9dwVL8zbt2wt8WKAVcrsMxdJFfFQ==
X-Received: by 2002:a17:906:1982:b0:878:72f7:bd87 with SMTP id g2-20020a170906198200b0087872f7bd87mr2110265ejd.6.1680612051666;
        Tue, 04 Apr 2023 05:40:51 -0700 (PDT)
Received: from 127.com ([2620:10d:c092:600::2:2b22])
        by smtp.gmail.com with ESMTPSA id g8-20020a170906394800b008cafeec917dsm5978851eje.101.2023.04.04.05.40.51
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 04 Apr 2023 05:40:51 -0700 (PDT)
From:   Pavel Begunkov <asml.silence@gmail.com>
To:     io-uring@vger.kernel.org
Cc:     Jens Axboe <axboe@kernel.dk>, asml.silence@gmail.com,
        linux-kernel@vger.kernel.org
Subject: [PATCH v2 02/13] io_uring/rsrc: keep cached refs per node
Date:   Tue,  4 Apr 2023 13:39:46 +0100
Message-Id: <9edc3669c1d71b06c2dca78b2b2b8bb9292738b9.1680576071.git.asml.silence@gmail.com>
X-Mailer: git-send-email 2.39.1
In-Reply-To: <cover.1680576071.git.asml.silence@gmail.com>
References: <cover.1680576071.git.asml.silence@gmail.com>
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
index 1b9b7f98fb7e..e9187d49d558 100644
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

