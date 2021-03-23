Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 629A434632D
	for <lists+io-uring@lfdr.de>; Tue, 23 Mar 2021 16:43:51 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233005AbhCWPlU (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Tue, 23 Mar 2021 11:41:20 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:36256 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232941AbhCWPlP (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Tue, 23 Mar 2021 11:41:15 -0400
Received: from mail-wm1-x335.google.com (mail-wm1-x335.google.com [IPv6:2a00:1450:4864:20::335])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id AF5A5C061574
        for <io-uring@vger.kernel.org>; Tue, 23 Mar 2021 08:41:14 -0700 (PDT)
Received: by mail-wm1-x335.google.com with SMTP id z6-20020a1c4c060000b029010f13694ba2so11080819wmf.5
        for <io-uring@vger.kernel.org>; Tue, 23 Mar 2021 08:41:14 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:subject:date:message-id:in-reply-to:references:mime-version
         :content-transfer-encoding;
        bh=iE3Ha5MWaOhT5CYHxWTsS24+AL4L6FKuwI5fISfACew=;
        b=IH42QdpE9XUMraMJd8cNLL6LrYB+57Gxf9fLCGsl8d4GCllrj6H7TlBhJ5NYUlJtbm
         Sx31YTIcwognRm+VYOuFmWOryuOv3PrgBZj83Y36gUxW1NNo1ciBFrGTV1ne5GC7MDGC
         WbJkjgZeBdhdgzR+ZYKNGzDRMqPu70J2kTIC3/OJCHp3FlfUbMi54oBJTooxZ/sK1Rru
         vcQNALSq5dAtcr5XU/BUE97Bh2k6fjVMk/qMpXGj8/uR87W5rGs81Ws6o1BM7MVNwy01
         30e9ZX1AXnJx9rvn2tnATa+dmZOnrPakqxc5aufQGSYehnDnKl5xDdCkpkqJe1At/rKF
         TpIw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=iE3Ha5MWaOhT5CYHxWTsS24+AL4L6FKuwI5fISfACew=;
        b=os6qrIjbeqMSqu1jkuNooRlpAx3SXJQiutEJKKSwIRGxeDtj8fZww2J4lDe2Lqhax4
         Ql7TtQ60UcL4yEJDM2zo+chgeiZUAkfd9/hWK13PtMJX8uNW88JZ1kdaeMXHqF1Ijp7J
         EftPj+BRUOC5C8iDoMIxuwXfbRuOh8lLNtCMDJ5dNyBVFSCcMvRfBPAcZRjIVWDvuiFE
         1GHqfZhDT2w6nVGPtNaZ8/Scsc8QbFrVfIhZU6DGg4ee8yx1q4IRR+TKWNgZpXDLRkgP
         9aNJ9rJk4f6mmmGsEBm3c4rTrQ9m03tXwopoiefH6B97YOd7ORyyF7tqbB6qdJRB/t6x
         dMsQ==
X-Gm-Message-State: AOAM530P3cAXqHEfpJOCcSS5W6THptQ5pkPsdTFHIX+PlAlmcQQ1PKSc
        htcfV1Ai/l3dEN+HXHV0NFs=
X-Google-Smtp-Source: ABdhPJyDtYpAYj+oEXTNuJC6YRMcrrPJJkue4vKBcA6cKuaZ1amPz6tPbNeX1etWZr9D0LfFD6Wbyw==
X-Received: by 2002:a7b:c399:: with SMTP id s25mr3897632wmj.124.1616514073505;
        Tue, 23 Mar 2021 08:41:13 -0700 (PDT)
Received: from localhost.localdomain ([85.255.236.168])
        by smtp.gmail.com with ESMTPSA id u2sm24493271wrp.12.2021.03.23.08.41.12
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 23 Mar 2021 08:41:13 -0700 (PDT)
From:   Pavel Begunkov <asml.silence@gmail.com>
To:     Jens Axboe <axboe@kernel.dk>, io-uring@vger.kernel.org
Subject: [PATCH v2 7/7] io_uring: ctx-wide rsrc nodes
Date:   Tue, 23 Mar 2021 15:36:58 +0000
Message-Id: <a458a7b16666d50d12905aa0bf976778a55b53ee.1616513699.git.asml.silence@gmail.com>
X-Mailer: git-send-email 2.24.0
In-Reply-To: <cover.1616513699.git.asml.silence@gmail.com>
References: <cover.1616513699.git.asml.silence@gmail.com>
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
index 175dd2c00991..29d8f0ac471e 100644
--- a/fs/io_uring.c
+++ b/fs/io_uring.c
@@ -231,7 +231,6 @@ struct io_rsrc_data {
 	struct io_ring_ctx		*ctx;
 
 	rsrc_put_fn			*do_put;
-	struct io_rsrc_node		*node;
 	struct percpu_ref		refs;
 	struct completion		done;
 	bool				quiesce;
@@ -444,6 +443,7 @@ struct io_ring_ctx {
 	struct llist_head		rsrc_put_llist;
 	struct list_head		rsrc_ref_list;
 	spinlock_t			rsrc_ref_lock;
+	struct io_rsrc_node		*rsrc_node;
 	struct io_rsrc_node		*rsrc_backup_node;
 
 	struct io_restriction		restrictions;
@@ -1064,7 +1064,7 @@ static inline void io_req_set_rsrc_node(struct io_kiocb *req)
 	struct io_ring_ctx *ctx = req->ctx;
 
 	if (!req->fixed_rsrc_refs) {
-		req->fixed_rsrc_refs = &ctx->file_data->node->refs;
+		req->fixed_rsrc_refs = &ctx->rsrc_node->refs;
 		percpu_ref_get(req->fixed_rsrc_refs);
 	}
 }
@@ -6958,36 +6958,32 @@ static inline void io_rsrc_ref_unlock(struct io_ring_ctx *ctx)
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
@@ -7004,10 +7000,11 @@ static int io_rsrc_ref_quiesce(struct io_rsrc_data *data, struct io_ring_ctx *ct
 
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
 
@@ -7016,7 +7013,6 @@ static int io_rsrc_ref_quiesce(struct io_rsrc_data *data, struct io_ring_ctx *ct
 			break;
 
 		percpu_ref_resurrect(&data->refs);
-		io_rsrc_node_set(ctx, data);
 		reinit_completion(&data->done);
 
 		mutex_unlock(&ctx->uring_lock);
@@ -7497,7 +7493,7 @@ static int io_sqe_files_register(struct io_ring_ctx *ctx, void __user *arg,
 		return -EINVAL;
 	if (nr_args > IORING_MAX_FIXED_FILES)
 		return -EMFILE;
-	ret = io_rsrc_node_prealloc(ctx);
+	ret = io_rsrc_node_switch_start(ctx);
 	if (ret)
 		return ret;
 
@@ -7559,7 +7555,7 @@ static int io_sqe_files_register(struct io_ring_ctx *ctx, void __user *arg,
 		return ret;
 	}
 
-	io_rsrc_node_set(ctx, file_data);
+	io_rsrc_node_switch(ctx, NULL);
 	return ret;
 out_fput:
 	for (i = 0; i < ctx->nr_user_files; i++) {
@@ -7648,7 +7644,7 @@ static int __io_sqe_files_update(struct io_ring_ctx *ctx,
 		return -EOVERFLOW;
 	if (done > ctx->nr_user_files)
 		return -EINVAL;
-	err = io_rsrc_node_prealloc(ctx);
+	err = io_rsrc_node_switch_start(ctx);
 	if (err)
 		return err;
 
@@ -7667,7 +7663,7 @@ static int __io_sqe_files_update(struct io_ring_ctx *ctx,
 
 		if (*file_slot) {
 			file = (struct file *) ((unsigned long) *file_slot & FFS_MASK);
-			err = io_queue_rsrc_removal(data, data->node, file);
+			err = io_queue_rsrc_removal(data, ctx->rsrc_node, file);
 			if (err)
 				break;
 			*file_slot = NULL;
@@ -7702,10 +7698,8 @@ static int __io_sqe_files_update(struct io_ring_ctx *ctx,
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
 
@@ -8376,8 +8370,15 @@ static void io_ring_ctx_free(struct io_ring_ctx *ctx)
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

