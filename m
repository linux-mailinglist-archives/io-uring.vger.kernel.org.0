Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 11120351C9F
	for <lists+io-uring@lfdr.de>; Thu,  1 Apr 2021 20:47:05 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S237202AbhDASS7 (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Thu, 1 Apr 2021 14:18:59 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:35694 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S235918AbhDASLM (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Thu, 1 Apr 2021 14:11:12 -0400
Received: from mail-wr1-x434.google.com (mail-wr1-x434.google.com [IPv6:2a00:1450:4864:20::434])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 51FBDC0045F8
        for <io-uring@vger.kernel.org>; Thu,  1 Apr 2021 07:48:25 -0700 (PDT)
Received: by mail-wr1-x434.google.com with SMTP id k8so2109674wrc.3
        for <io-uring@vger.kernel.org>; Thu, 01 Apr 2021 07:48:25 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:subject:date:message-id:in-reply-to:references:mime-version
         :content-transfer-encoding;
        bh=B/94I1Q8v1RnrkbjHWhaXWVB9RO32eVycG0cKuMYBbo=;
        b=XbNdISmop5sKUJaTwy8OQgniyFgXYFZ7cLyvMSz5YsAFhfjUHvNOnbPihmfCq+pKbf
         6jgSpkX8jGXlArEfFeFkeJCDYXsehKs6+5Z1nOP0vYDFWVweBa5tNjQWAI/bgnzxKLVr
         X//CODd9xvy8vCqZBNUdzQRGENmtEC/HxJjvhjemFxBxfJ+rIq8YZsMpghl0EjJs4ZIi
         fE1wzPU1gXlE5WkIXmznWKhYaMHXNrX93sgf1rDfOXjdy4uYqaMSIPRFO5PtOHwFU19E
         yNMyyy+arM3c3JaWGjJ7lzD9XwHPpBAvUbZ/8V/3rJVAUQtS6YfVisi7fZ4WNCDWKNKk
         dIWg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=B/94I1Q8v1RnrkbjHWhaXWVB9RO32eVycG0cKuMYBbo=;
        b=gyMIs9iMY8ziLmhHQL/ETlpDK8bMtaaH7TU9gmpvNF5tJmOgEvGIqAI20d4fIM2sVB
         V52GKMj7Pzana7xpmLISBXR1JFxEBi2cBx7bD6stlBoXSLvLVemq85DHuNLOSeYF0dqa
         NyZsiVyVwje7fqGe8Hjul+lffNY53VTBFqTuEeJxN1fTH61fmFjorTIAPxmIGvbOwCh7
         KV4MY0+SR1R5oqYHBjaMf+kt5qamt8OUC0L0Q2phHksGs+8RKH7vmf2KzzcucGtANDtN
         i1lJamvFDO5nMfiQmXmusF9goqHq+4k6uimDG0615fTostHeSug5jjlJKatzTbCssat1
         LrDQ==
X-Gm-Message-State: AOAM532Pl6d1HA7OutjED6juBxCTUY49ips6XhooB3y0nB0vtKT8JOTP
        BcC81+Pu2ytmPMhEIw+7XHE=
X-Google-Smtp-Source: ABdhPJzpUQHXivZN6I2BkdKCZ4ptOaHd9Y0G4ijmBM/uPw2odx3tDnVV3nBm3yzar5yvJRJh9ReK3g==
X-Received: by 2002:adf:d1eb:: with SMTP id g11mr10495686wrd.164.1617288504068;
        Thu, 01 Apr 2021 07:48:24 -0700 (PDT)
Received: from localhost.localdomain ([148.252.132.152])
        by smtp.gmail.com with ESMTPSA id x13sm8183948wmp.39.2021.04.01.07.48.22
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 01 Apr 2021 07:48:23 -0700 (PDT)
From:   Pavel Begunkov <asml.silence@gmail.com>
To:     Jens Axboe <axboe@kernel.dk>, io-uring@vger.kernel.org
Subject: [PATCH v4 07/26] io_uring: ctx-wide rsrc nodes
Date:   Thu,  1 Apr 2021 15:43:46 +0100
Message-Id: <7e9c693b4b9a2f47aa784b616ce29843021bb65a.1617287883.git.asml.silence@gmail.com>
X-Mailer: git-send-email 2.24.0
In-Reply-To: <cover.1617287883.git.asml.silence@gmail.com>
References: <cover.1617287883.git.asml.silence@gmail.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org

If we're going to ever support multiple types of resources we need
shared rsrc nodes to not bloat requests, that is implemented in this
patch. It also gives a nicer API and saves one pointer dereference
in io_req_set_rsrc_node().

We may say that all requests bound to a resource belong to one and only
one rsrc node, and considering that nodes are removed and recycled
strictly in-order, this separates requests into generations, where
generation are changed on each node switch (i.e. io_rsrc_node_switch()).

The API is simple, io_rsrc_node_switch() switches to a new generation if
needed, and also optionally kills a passed in io_rsrc_data. Each call to
io_rsrc_node_switch() have to be preceded with
io_rsrc_node_switch_start(). The start function is idempotent and should
not necessarily be followed by switch.

One difference is that once a node was set it will always retain a valid
rsrc node, even on unregister. It may be a nuisance at the moment, but
makes much sense for multiple types of resources. Another thing changed
is that nodes are bound to/associated with a io_rsrc_data later just
before killing (i.e. switching).

Signed-off-by: Pavel Begunkov <asml.silence@gmail.com>
---
 fs/io_uring.c | 73 ++++++++++++++++++++++++++-------------------------
 1 file changed, 37 insertions(+), 36 deletions(-)

diff --git a/fs/io_uring.c b/fs/io_uring.c
index 5dc4f6bb643a..47c76ec422ba 100644
--- a/fs/io_uring.c
+++ b/fs/io_uring.c
@@ -235,7 +235,6 @@ struct io_rsrc_data {
 	struct io_ring_ctx		*ctx;
 
 	rsrc_put_fn			*do_put;
-	struct io_rsrc_node		*node;
 	struct percpu_ref		refs;
 	struct completion		done;
 	bool				quiesce;
@@ -448,6 +447,7 @@ struct io_ring_ctx {
 	struct llist_head		rsrc_put_llist;
 	struct list_head		rsrc_ref_list;
 	spinlock_t			rsrc_ref_lock;
+	struct io_rsrc_node		*rsrc_node;
 	struct io_rsrc_node		*rsrc_backup_node;
 
 	struct io_restriction		restrictions;
@@ -1077,7 +1077,7 @@ static inline void io_req_set_rsrc_node(struct io_kiocb *req)
 	struct io_ring_ctx *ctx = req->ctx;
 
 	if (!req->fixed_rsrc_refs) {
-		req->fixed_rsrc_refs = &ctx->file_data->node->refs;
+		req->fixed_rsrc_refs = &ctx->rsrc_node->refs;
 		percpu_ref_get(req->fixed_rsrc_refs);
 	}
 }
@@ -7075,36 +7075,32 @@ static inline void io_rsrc_ref_unlock(struct io_ring_ctx *ctx)
 	spin_unlock_bh(&ctx->rsrc_ref_lock);
 }
 
-static void io_rsrc_node_set(struct io_ring_ctx *ctx,
-			     struct io_rsrc_data *rsrc_data)
+static void io_rsrc_node_switch(struct io_ring_ctx *ctx,
+				struct io_rsrc_data *data_to_kill)
 {
-	struct io_rsrc_node *rsrc_node = ctx->rsrc_backup_node;
+	WARN_ON_ONCE(!ctx->rsrc_backup_node);
+	WARN_ON_ONCE(data_to_kill && !ctx->rsrc_node);
 
-	WARN_ON_ONCE(!rsrc_node);
+	if (data_to_kill) {
+		struct io_rsrc_node *rsrc_node = ctx->rsrc_node;
 
-	ctx->rsrc_backup_node = NULL;
-	rsrc_node->rsrc_data = rsrc_data;
+		rsrc_node->rsrc_data = data_to_kill;
+		io_rsrc_ref_lock(ctx);
+		list_add_tail(&rsrc_node->node, &ctx->rsrc_ref_list);
+		io_rsrc_ref_unlock(ctx);
 
-	io_rsrc_ref_lock(ctx);
-	rsrc_data->node = rsrc_node;
-	list_add_tail(&rsrc_node->node, &ctx->rsrc_ref_list);
-	io_rsrc_ref_unlock(ctx);
-	percpu_ref_get(&rsrc_data->refs);
-}
-
-static void io_rsrc_node_kill(struct io_ring_ctx *ctx, struct io_rsrc_data *data)
-{
-	struct io_rsrc_node *ref_node = NULL;
+		percpu_ref_get(&data_to_kill->refs);
+		percpu_ref_kill(&rsrc_node->refs);
+		ctx->rsrc_node = NULL;
+	}
 
-	io_rsrc_ref_lock(ctx);
-	ref_node = data->node;
-	data->node = NULL;
-	io_rsrc_ref_unlock(ctx);
-	if (ref_node)
-		percpu_ref_kill(&ref_node->refs);
+	if (!ctx->rsrc_node) {
+		ctx->rsrc_node = ctx->rsrc_backup_node;
+		ctx->rsrc_backup_node = NULL;
+	}
 }
 
-static int io_rsrc_node_prealloc(struct io_ring_ctx *ctx)
+static int io_rsrc_node_switch_start(struct io_ring_ctx *ctx)
 {
 	if (ctx->rsrc_backup_node)
 		return 0;
@@ -7121,10 +7117,11 @@ static int io_rsrc_ref_quiesce(struct io_rsrc_data *data, struct io_ring_ctx *ct
 
 	data->quiesce = true;
 	do {
-		ret = io_rsrc_node_prealloc(ctx);
+		ret = io_rsrc_node_switch_start(ctx);
 		if (ret)
 			break;
-		io_rsrc_node_kill(ctx, data);
+		io_rsrc_node_switch(ctx, data);
+
 		percpu_ref_kill(&data->refs);
 		flush_delayed_work(&ctx->rsrc_put_work);
 
@@ -7133,7 +7130,6 @@ static int io_rsrc_ref_quiesce(struct io_rsrc_data *data, struct io_ring_ctx *ct
 			break;
 
 		percpu_ref_resurrect(&data->refs);
-		io_rsrc_node_set(ctx, data);
 		reinit_completion(&data->done);
 
 		mutex_unlock(&ctx->uring_lock);
@@ -7614,7 +7610,7 @@ static int io_sqe_files_register(struct io_ring_ctx *ctx, void __user *arg,
 		return -EINVAL;
 	if (nr_args > IORING_MAX_FIXED_FILES)
 		return -EMFILE;
-	ret = io_rsrc_node_prealloc(ctx);
+	ret = io_rsrc_node_switch_start(ctx);
 	if (ret)
 		return ret;
 
@@ -7676,7 +7672,7 @@ static int io_sqe_files_register(struct io_ring_ctx *ctx, void __user *arg,
 		return ret;
 	}
 
-	io_rsrc_node_set(ctx, file_data);
+	io_rsrc_node_switch(ctx, NULL);
 	return ret;
 out_fput:
 	for (i = 0; i < ctx->nr_user_files; i++) {
@@ -7765,7 +7761,7 @@ static int __io_sqe_files_update(struct io_ring_ctx *ctx,
 		return -EOVERFLOW;
 	if (done > ctx->nr_user_files)
 		return -EINVAL;
-	err = io_rsrc_node_prealloc(ctx);
+	err = io_rsrc_node_switch_start(ctx);
 	if (err)
 		return err;
 
@@ -7784,7 +7780,7 @@ static int __io_sqe_files_update(struct io_ring_ctx *ctx,
 
 		if (*file_slot) {
 			file = (struct file *) ((unsigned long) *file_slot & FFS_MASK);
-			err = io_queue_rsrc_removal(data, data->node, file);
+			err = io_queue_rsrc_removal(data, ctx->rsrc_node, file);
 			if (err)
 				break;
 			*file_slot = NULL;
@@ -7819,10 +7815,8 @@ static int __io_sqe_files_update(struct io_ring_ctx *ctx,
 		}
 	}
 
-	if (needs_switch) {
-		percpu_ref_kill(&data->node->refs);
-		io_rsrc_node_set(ctx, data);
-	}
+	if (needs_switch)
+		io_rsrc_node_switch(ctx, data);
 	return done ? done : err;
 }
 
@@ -8496,8 +8490,15 @@ static void io_ring_ctx_free(struct io_ring_ctx *ctx)
 	io_eventfd_unregister(ctx);
 	io_destroy_buffers(ctx);
 
+	/* there are no registered resources left, nobody uses it */
+	if (ctx->rsrc_node)
+		io_rsrc_node_destroy(ctx->rsrc_node);
 	if (ctx->rsrc_backup_node)
 		io_rsrc_node_destroy(ctx->rsrc_backup_node);
+	flush_delayed_work(&ctx->rsrc_put_work);
+
+	WARN_ON_ONCE(!list_empty(&ctx->rsrc_ref_list));
+	WARN_ON_ONCE(!llist_empty(&ctx->rsrc_put_llist));
 
 #if defined(CONFIG_UNIX)
 	if (ctx->ring_sock) {
-- 
2.24.0

