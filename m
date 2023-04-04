Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 5C8A56D60F9
	for <lists+io-uring@lfdr.de>; Tue,  4 Apr 2023 14:41:05 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234983AbjDDMlE (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Tue, 4 Apr 2023 08:41:04 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:60190 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234701AbjDDMk7 (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Tue, 4 Apr 2023 08:40:59 -0400
Received: from mail-ed1-x52d.google.com (mail-ed1-x52d.google.com [IPv6:2a00:1450:4864:20::52d])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id EB0B910D5;
        Tue,  4 Apr 2023 05:40:54 -0700 (PDT)
Received: by mail-ed1-x52d.google.com with SMTP id ew6so129934902edb.7;
        Tue, 04 Apr 2023 05:40:54 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112; t=1680612053;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=xiac71Z/ZNmEtbhG51KDumqDuoRCwK/TNCs/88XmD5g=;
        b=U8OeirzID3x78bkm6uM+W+9QCYE12gVuYh81wBNSQwgCJJLGxwcL7ywn9tFsztqHoT
         GIzO/RQ6ILUyY2mcydQI1pEE6Iwpmy2J1996VbH2YIzI+9QdtEitqVjiM06o0RCOm6gv
         7k+qms1j7uV/HWmKcWn20z+9SdnImxuiQ4q6M+xg4yEjPJ8yCxYc1B9v4uLvs4h+Duwm
         C43c+4kjrRCeQJtd6BzoS5DpHNA4xbAxlWeCENEMs7Md3bcRRmzEgkBUpKbxD75YHaEh
         r1HArHEoleAI5HANib7wu/Me+6RV74k+cj0HgCxmqRiCrcKaGQegNCRQ+WSbfRjD3etP
         C7Ew==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112; t=1680612053;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=xiac71Z/ZNmEtbhG51KDumqDuoRCwK/TNCs/88XmD5g=;
        b=N6O38GAHXhia43wJt9bRRkmu+CPPw+U+PYn0KlN++6WZwLvYoD3kp/8D0CMawHYOZ3
         VpQeSmgCxB6/UMAtsRbmhSE/i0M+hED84pSoS5mXnO+RyJUObeZMNUuEeoP1YxKdpL78
         ckBROjlWN5I1wtdDMYx86bCXLQgWK+hus/n3mjx/CJzEbWQSIWtgVAhUFhdrfh+ngo3x
         fAWaP7lJIN+6pYPa26nGhwqxPf91GFG/QxIgXr5jFEORmj+7OIgqjBvlko36XT+STNlw
         nh6x+OGV50fnVORDgh7HJre2ZttDPgUMNErUtwfQDThTRapO18fAUWnrWZtM7iIEn4sa
         XmHQ==
X-Gm-Message-State: AAQBX9cggxnhX5inkqjCzVPU+TJxHehZ8tnwQdovVnTZBURifSfkBXBm
        e5NOdx/JFiNuHKMwXO63LBE7dawWsqw=
X-Google-Smtp-Source: AKy350ZIxWv6qjzrpYQCmaXMhyoEcnTfOTD5xbGhWN8Fi4s5H0Gqv2MUaSBsGqJKLHOx/rSM0hnmEA==
X-Received: by 2002:a17:906:bc4c:b0:947:d3f0:8328 with SMTP id s12-20020a170906bc4c00b00947d3f08328mr11696047ejv.1.1680612053390;
        Tue, 04 Apr 2023 05:40:53 -0700 (PDT)
Received: from 127.com ([2620:10d:c092:600::2:2b22])
        by smtp.gmail.com with ESMTPSA id g8-20020a170906394800b008cafeec917dsm5978851eje.101.2023.04.04.05.40.52
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 04 Apr 2023 05:40:53 -0700 (PDT)
From:   Pavel Begunkov <asml.silence@gmail.com>
To:     io-uring@vger.kernel.org
Cc:     Jens Axboe <axboe@kernel.dk>, asml.silence@gmail.com,
        linux-kernel@vger.kernel.org
Subject: [PATCH v2 05/13] io_uring/rsrc: protect node refs with uring_lock
Date:   Tue,  4 Apr 2023 13:39:49 +0100
Message-Id: <25b142feed7d831008257d90c8b17c0115d4fc15.1680576071.git.asml.silence@gmail.com>
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

Currently, for nodes we have an atomic counter and some cached
(non-atomic) refs protected by uring_lock. Let's put all ref
manipulations under uring_lock and get rid of the atomic part.
It's free as in all cases we care about we already hold the lock.

Signed-off-by: Pavel Begunkov <asml.silence@gmail.com>
---
 io_uring/io_uring.c | 18 ++++++++++++------
 io_uring/rsrc.c     | 30 ++++--------------------------
 io_uring/rsrc.h     | 29 +++++------------------------
 3 files changed, 21 insertions(+), 56 deletions(-)

diff --git a/io_uring/io_uring.c b/io_uring/io_uring.c
index 98320f4b0bca..36a76c7b34f0 100644
--- a/io_uring/io_uring.c
+++ b/io_uring/io_uring.c
@@ -967,7 +967,7 @@ bool io_aux_cqe(struct io_ring_ctx *ctx, bool defer, u64 user_data, s32 res, u32
 	return true;
 }
 
-static void __io_req_complete_post(struct io_kiocb *req)
+static void __io_req_complete_post(struct io_kiocb *req, unsigned issue_flags)
 {
 	struct io_ring_ctx *ctx = req->ctx;
 	struct io_rsrc_node *rsrc_node = NULL;
@@ -1003,7 +1003,11 @@ static void __io_req_complete_post(struct io_kiocb *req)
 	}
 	io_cq_unlock_post(ctx);
 
-	io_put_rsrc_node(rsrc_node);
+	if (rsrc_node) {
+		io_ring_submit_lock(ctx, issue_flags);
+		io_put_rsrc_node(rsrc_node);
+		io_ring_submit_unlock(ctx, issue_flags);
+	}
 }
 
 void io_req_complete_post(struct io_kiocb *req, unsigned issue_flags)
@@ -1013,12 +1017,12 @@ void io_req_complete_post(struct io_kiocb *req, unsigned issue_flags)
 		io_req_task_work_add(req);
 	} else if (!(issue_flags & IO_URING_F_UNLOCKED) ||
 		   !(req->ctx->flags & IORING_SETUP_IOPOLL)) {
-		__io_req_complete_post(req);
+		__io_req_complete_post(req, issue_flags);
 	} else {
 		struct io_ring_ctx *ctx = req->ctx;
 
 		mutex_lock(&ctx->uring_lock);
-		__io_req_complete_post(req);
+		__io_req_complete_post(req, issue_flags & ~IO_URING_F_UNLOCKED);
 		mutex_unlock(&ctx->uring_lock);
 	}
 }
@@ -1120,7 +1124,10 @@ static __cold void io_free_req_tw(struct io_kiocb *req, struct io_tw_state *ts)
 {
 	struct io_ring_ctx *ctx = req->ctx;
 
-	io_put_rsrc_node(req->rsrc_node);
+	if (req->rsrc_node) {
+		io_tw_lock(ctx, ts);
+		io_put_rsrc_node(req->rsrc_node);
+	}
 	io_dismantle_req(req);
 	io_put_task_remote(req->task, 1);
 
@@ -2790,7 +2797,6 @@ static void io_req_caches_free(struct io_ring_ctx *ctx)
 static __cold void io_ring_ctx_free(struct io_ring_ctx *ctx)
 {
 	io_sq_thread_finish(ctx);
-	io_rsrc_refs_drop(ctx);
 	/* __io_rsrc_put_work() may need uring_lock to progress, wait w/o it */
 	io_wait_rsrc_data(ctx->buf_data);
 	io_wait_rsrc_data(ctx->file_data);
diff --git a/io_uring/rsrc.c b/io_uring/rsrc.c
index e9187d49d558..89e43e59b490 100644
--- a/io_uring/rsrc.c
+++ b/io_uring/rsrc.c
@@ -27,23 +27,10 @@ static int io_sqe_buffer_register(struct io_ring_ctx *ctx, struct iovec *iov,
 				  struct io_mapped_ubuf **pimu,
 				  struct page **last_hpage);
 
-#define IO_RSRC_REF_BATCH	100
-
 /* only define max */
 #define IORING_MAX_FIXED_FILES	(1U << 20)
 #define IORING_MAX_REG_BUFFERS	(1U << 14)
 
-void io_rsrc_refs_drop(struct io_ring_ctx *ctx)
-	__must_hold(&ctx->uring_lock)
-{
-	struct io_rsrc_node *node = ctx->rsrc_node;
-
-	if (node && node->cached_refs) {
-		io_rsrc_put_node(node, node->cached_refs);
-		node->cached_refs = 0;
-	}
-}
-
 int __io_account_mem(struct user_struct *user, unsigned long nr_pages)
 {
 	unsigned long page_limit, cur_pages, new_pages;
@@ -153,13 +140,6 @@ static void io_buffer_unmap(struct io_ring_ctx *ctx, struct io_mapped_ubuf **slo
 	*slot = NULL;
 }
 
-void io_rsrc_refs_refill(struct io_ring_ctx *ctx, struct io_rsrc_node *node)
-	__must_hold(&ctx->uring_lock)
-{
-	node->cached_refs += IO_RSRC_REF_BATCH;
-	refcount_add(IO_RSRC_REF_BATCH, &node->refs);
-}
-
 static void __io_rsrc_put_work(struct io_rsrc_node *ref_node)
 {
 	struct io_rsrc_data *rsrc_data = ref_node->rsrc_data;
@@ -225,7 +205,8 @@ void io_rsrc_node_destroy(struct io_rsrc_node *ref_node)
 	kfree(ref_node);
 }
 
-__cold void io_rsrc_node_ref_zero(struct io_rsrc_node *node)
+void io_rsrc_node_ref_zero(struct io_rsrc_node *node)
+	__must_hold(&node->rsrc_data->ctx->uring_lock)
 {
 	struct io_ring_ctx *ctx = node->rsrc_data->ctx;
 	unsigned long flags;
@@ -269,7 +250,7 @@ static struct io_rsrc_node *io_rsrc_node_alloc(void)
 	if (!ref_node)
 		return NULL;
 
-	refcount_set(&ref_node->refs, 1);
+	ref_node->refs = 1;
 	INIT_LIST_HEAD(&ref_node->node);
 	INIT_LIST_HEAD(&ref_node->rsrc_list);
 	ref_node->done = false;
@@ -283,8 +264,6 @@ void io_rsrc_node_switch(struct io_ring_ctx *ctx,
 	WARN_ON_ONCE(!ctx->rsrc_backup_node);
 	WARN_ON_ONCE(data_to_kill && !ctx->rsrc_node);
 
-	io_rsrc_refs_drop(ctx);
-
 	if (data_to_kill) {
 		struct io_rsrc_node *rsrc_node = ctx->rsrc_node;
 
@@ -295,14 +274,13 @@ void io_rsrc_node_switch(struct io_ring_ctx *ctx,
 
 		atomic_inc(&data_to_kill->refs);
 		/* put master ref */
-		io_rsrc_put_node(rsrc_node, 1);
+		io_put_rsrc_node(rsrc_node);
 		ctx->rsrc_node = NULL;
 	}
 
 	if (!ctx->rsrc_node) {
 		ctx->rsrc_node = ctx->rsrc_backup_node;
 		ctx->rsrc_backup_node = NULL;
-		ctx->rsrc_node->cached_refs = 0;
 	}
 }
 
diff --git a/io_uring/rsrc.h b/io_uring/rsrc.h
index 8164777279ba..a96103095f0f 100644
--- a/io_uring/rsrc.h
+++ b/io_uring/rsrc.h
@@ -37,13 +37,12 @@ struct io_rsrc_data {
 };
 
 struct io_rsrc_node {
-	refcount_t			refs;
 	struct list_head		node;
 	struct list_head		rsrc_list;
 	struct io_rsrc_data		*rsrc_data;
 	struct llist_node		llist;
+	int				refs;
 	bool				done;
-	int				cached_refs;
 };
 
 struct io_mapped_ubuf {
@@ -57,10 +56,8 @@ struct io_mapped_ubuf {
 void io_rsrc_put_tw(struct callback_head *cb);
 void io_rsrc_node_ref_zero(struct io_rsrc_node *node);
 void io_rsrc_put_work(struct work_struct *work);
-void io_rsrc_refs_refill(struct io_ring_ctx *ctx, struct io_rsrc_node *node);
 void io_wait_rsrc_data(struct io_rsrc_data *data);
 void io_rsrc_node_destroy(struct io_rsrc_node *ref_node);
-void io_rsrc_refs_drop(struct io_ring_ctx *ctx);
 int io_rsrc_node_switch_start(struct io_ring_ctx *ctx);
 int io_queue_rsrc_removal(struct io_rsrc_data *data, unsigned idx,
 			  struct io_rsrc_node *node, void *rsrc);
@@ -109,38 +106,22 @@ int io_register_rsrc_update(struct io_ring_ctx *ctx, void __user *arg,
 int io_register_rsrc(struct io_ring_ctx *ctx, void __user *arg,
 			unsigned int size, unsigned int type);
 
-static inline void io_rsrc_put_node(struct io_rsrc_node *node, int nr)
-{
-	if (refcount_sub_and_test(nr, &node->refs))
-		io_rsrc_node_ref_zero(node);
-}
-
 static inline void io_put_rsrc_node(struct io_rsrc_node *node)
 {
-	if (node)
-		io_rsrc_put_node(node, 1);
+	if (node && !--node->refs)
+		io_rsrc_node_ref_zero(node);
 }
 
 static inline void io_req_put_rsrc_locked(struct io_kiocb *req,
 					  struct io_ring_ctx *ctx)
-	__must_hold(&ctx->uring_lock)
 {
-	struct io_rsrc_node *node = req->rsrc_node;
-
-	if (node) {
-		if (node == ctx->rsrc_node)
-			node->cached_refs++;
-		else
-			io_rsrc_put_node(node, 1);
-	}
+	io_put_rsrc_node(req->rsrc_node);
 }
 
 static inline void io_charge_rsrc_node(struct io_ring_ctx *ctx,
 				       struct io_rsrc_node *node)
 {
-	node->cached_refs--;
-	if (unlikely(node->cached_refs < 0))
-		io_rsrc_refs_refill(ctx, node);
+	node->refs++;
 }
 
 static inline void io_req_set_rsrc_node(struct io_kiocb *req,
-- 
2.39.1

