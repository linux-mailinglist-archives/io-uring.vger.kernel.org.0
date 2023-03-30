Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 3910D6D08CE
	for <lists+io-uring@lfdr.de>; Thu, 30 Mar 2023 16:54:59 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232543AbjC3Oy5 (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Thu, 30 Mar 2023 10:54:57 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:34434 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232566AbjC3Oyt (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Thu, 30 Mar 2023 10:54:49 -0400
Received: from mail-wr1-x42e.google.com (mail-wr1-x42e.google.com [IPv6:2a00:1450:4864:20::42e])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id C665FA273;
        Thu, 30 Mar 2023 07:54:41 -0700 (PDT)
Received: by mail-wr1-x42e.google.com with SMTP id j24so19424969wrd.0;
        Thu, 30 Mar 2023 07:54:41 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112; t=1680188080;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=0i8xnepg2BvrVcYo9lxg1ps1ZVOTUo6D6qHGZbwYEt0=;
        b=cl2ADzpkTY/LFYdmyRhsDqzayDOvTYOGD2jnCQGmZx/Kgyw4F9oopSiAn7OUyNZTJ7
         USRzQoUySTxFUnfOZROxaZQku9kXxtLAoJZiF4XFTdiCm7k9xkhfV0Wa/thfKM3o86UG
         ee1EQqQSWJNTdPcBxtCxl+yfeTZeG0OXhETx/dSmZd80H3IaFb/Cy7TfFvCj14JBY4OK
         hdcoQ4dllmyuqg86bTKJ3D5DfneriZ03NKkt3XaCbtt0GmgFV7LtZXrkPzSI/W0DSrPK
         whCN5fxCyTMxC6FKcmgsxf0ejVKAnbEl3S6PNgARe6JSPpaQbSpE5Uaj/BjAxRPjLjAK
         jxxw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112; t=1680188080;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=0i8xnepg2BvrVcYo9lxg1ps1ZVOTUo6D6qHGZbwYEt0=;
        b=V8IPxSGx3e/yb8N2rupvqa5G53NttYJ1XY19vZePRNWgY8hdcOZDg46Y3DeRhrvDd8
         e7p8HG3/hmSokIwAIag3N5tOAUIKmeSFlxYVB8oP30fjOaZAu8AxSAfoXxSSAZO0my71
         fqDMBubaLQ02cGIZ2ASt0tqTQYEmrgn/CAHGvSca6K4j9RLAZIu/wpKQcTCywlt5qgsJ
         yr2iNtGjl3uWGCh5Pkr8IuXtrfEGw5H3vqmkS5dTTQYvB8PJlKRfYtEqj+9CvlboO35O
         8OrdzCzFQzKs4D3o5CykDHMD4OjFBS3huWuxudF1tRyPA7UCSkDfoeh75c0gvIAjUuc/
         GfgA==
X-Gm-Message-State: AAQBX9dC1EKf7DzNjW9lwD+W33oUQ6Ys07FVpcsYN7nvWmSvOTAh/JdS
        8xpT/wgmUnYO+8t0xbF1xYq+GU99qRo=
X-Google-Smtp-Source: AKy350aOWs6f6OFlrpRR+jpIV9FKwKggOI1fZUva9Raq1y/g/EqWO+plAudB1rPo0xC99aBoaTz7DQ==
X-Received: by 2002:adf:f185:0:b0:2e4:b4f8:896c with SMTP id h5-20020adff185000000b002e4b4f8896cmr2517301wro.48.1680188080053;
        Thu, 30 Mar 2023 07:54:40 -0700 (PDT)
Received: from 127.0.0.1localhost (82-132-231-234.dab.02.net. [82.132.231.234])
        by smtp.gmail.com with ESMTPSA id d7-20020adffbc7000000b002d5a8d8442asm28727962wrs.37.2023.03.30.07.54.39
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 30 Mar 2023 07:54:39 -0700 (PDT)
From:   Pavel Begunkov <asml.silence@gmail.com>
To:     io-uring@vger.kernel.org
Cc:     Jens Axboe <axboe@kernel.dk>, asml.silence@gmail.com,
        linux-kernel@vger.kernel.org
Subject: [PATCH 05/11] io_uring/rsrc: protect node refs with uring_lock
Date:   Thu, 30 Mar 2023 15:53:23 +0100
Message-Id: <af5eecb33fd78144d97c1228c54fe1a5dcc9ee9a.1680187408.git.asml.silence@gmail.com>
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
index 52a88da65f57..e55c48d91209 100644
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
@@ -1120,7 +1124,10 @@ __cold void io_free_req_tw(struct io_kiocb *req, struct io_tw_state *ts)
 {
 	struct io_ring_ctx *ctx = req->ctx;
 
-	io_put_rsrc_node(req->rsrc_node);
+	if (req->rsrc_node) {
+		io_tw_lock(ctx, ts);
+		io_put_rsrc_node(req->rsrc_node);
+	}
 	io_dismantle_req(req);
 	io_put_task_remote(req->task, 1);
 
@@ -2791,7 +2798,6 @@ static void io_req_caches_free(struct io_ring_ctx *ctx)
 static __cold void io_ring_ctx_free(struct io_ring_ctx *ctx)
 {
 	io_sq_thread_finish(ctx);
-	io_rsrc_refs_drop(ctx);
 	/* __io_rsrc_put_work() may need uring_lock to progress, wait w/o it */
 	io_wait_rsrc_data(ctx->buf_data);
 	io_wait_rsrc_data(ctx->file_data);
diff --git a/io_uring/rsrc.c b/io_uring/rsrc.c
index 1e7c960737fd..1237fc77c250 100644
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
index 8164777279ba..fd3bdd30a993 100644
--- a/io_uring/rsrc.h
+++ b/io_uring/rsrc.h
@@ -37,13 +37,12 @@ struct io_rsrc_data {
 };
 
 struct io_rsrc_node {
-	refcount_t			refs;
+	int refs;
 	struct list_head		node;
 	struct list_head		rsrc_list;
 	struct io_rsrc_data		*rsrc_data;
 	struct llist_node		llist;
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

