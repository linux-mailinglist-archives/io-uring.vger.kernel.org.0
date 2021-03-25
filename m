Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 3B5623492D7
	for <lists+io-uring@lfdr.de>; Thu, 25 Mar 2021 14:13:13 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230204AbhCYNMc (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Thu, 25 Mar 2021 09:12:32 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:34172 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230306AbhCYNMZ (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Thu, 25 Mar 2021 09:12:25 -0400
Received: from mail-wm1-x334.google.com (mail-wm1-x334.google.com [IPv6:2a00:1450:4864:20::334])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 0A811C061761
        for <io-uring@vger.kernel.org>; Thu, 25 Mar 2021 06:12:23 -0700 (PDT)
Received: by mail-wm1-x334.google.com with SMTP id d191so1155067wmd.2
        for <io-uring@vger.kernel.org>; Thu, 25 Mar 2021 06:12:22 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:subject:date:message-id:in-reply-to:references:mime-version
         :content-transfer-encoding;
        bh=UPcNy0aJkq4cXe4BO4jdNU0zYYUapiPIj9UfPW6eAV8=;
        b=VzBtVnBVjI71k5fjlOhR/wDgyHOsX2fGSnS+Fjm0k/hbjuEw+V9DcKfn7JplVD6hbk
         kd/MNY5lu/scxMYaXvAOxv53jgEIoLO9Caojp1ZJuEXSTQm/qkKrWt5XqbDw9h/Hvv7E
         plT8+iCDPFMOY6Y3/R6QvpYrIQTxMvwVurjTAcoO+y2+ZQfGmQiqcGekA0ItHeUdGxx3
         jBjunxQTasB7nQN4LDMpxz2NyrQc9mHW69ffBR0LzIwvwVH1TNJwy6t5s5SDlQMu+i+x
         Um08qMA5qpWsk0I5yOdk47t0QXmpipA6ieAAyEVe5yo1aP3YU5qtlIYUQeZfIQdT5KNK
         6xng==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=UPcNy0aJkq4cXe4BO4jdNU0zYYUapiPIj9UfPW6eAV8=;
        b=iXqj/snCqg1gWBm5qkTnn3CiJI9kExr4St7VdYHZaXpRv//97PcCcI41i8jj2sF5pc
         fbw47WqmyeqY8Oi3fiOTqo7hZ+IsQIOxfOoqp1DjTuCO4aLa2IQxPxCtwuZPAOqCvPSl
         yT8bgJRY1SeW6reS0M0Q6SXXKJvr8KP1Yc0M/FQ3MfVSl/WTABCfcXxS0qGNb4ANmH82
         l0Th5F70mkrqCxEwSGGc5Qt02ooTnVXarZx9dl9UxeoFIex+4M9+V3w/XmUk85xL0Z0Z
         37/vtfv2o6f7NfaS6az/JwclTXWt8t7WC5ruje3njfNhfmJQMefJw5WG7PKeKTCx13VQ
         E5fQ==
X-Gm-Message-State: AOAM533Ipp6T8JeJMydlAkadY07g+1f20enjZxqOCs+Orqq7ykcdUS5o
        3PdM+J46tlbXKEXHgDnun3/ICYPb077/6w==
X-Google-Smtp-Source: ABdhPJwd212CDK/P1Gd1h8BIpEYgxFULRUQzbX7kxaB4jTzXi6kt7qeJkobk/m9WYc7bdggVp6c3XA==
X-Received: by 2002:a1c:a74b:: with SMTP id q72mr7899363wme.158.1616677941747;
        Thu, 25 Mar 2021 06:12:21 -0700 (PDT)
Received: from localhost.localdomain ([148.252.129.162])
        by smtp.gmail.com with ESMTPSA id i4sm5754285wmq.12.2021.03.25.06.12.20
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 25 Mar 2021 06:12:21 -0700 (PDT)
From:   Pavel Begunkov <asml.silence@gmail.com>
To:     Jens Axboe <axboe@kernel.dk>, io-uring@vger.kernel.org
Subject: [PATCH v3 07/17] io_uring: ctx-wide rsrc nodes
Date:   Thu, 25 Mar 2021 13:07:56 +0000
Message-Id: <51c5e836791a3faf46d996e403f9ca4241d7951b.1616677487.git.asml.silence@gmail.com>
X-Mailer: git-send-email 2.24.0
In-Reply-To: <cover.1616677487.git.asml.silence@gmail.com>
References: <cover.1616677487.git.asml.silence@gmail.com>
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
index 6d2e3a3c202e..1328ff24d557 100644
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
@@ -6963,36 +6963,32 @@ static inline void io_rsrc_ref_unlock(struct io_ring_ctx *ctx)
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
@@ -7009,10 +7005,11 @@ static int io_rsrc_ref_quiesce(struct io_rsrc_data *data, struct io_ring_ctx *ct
 
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
 
@@ -7021,7 +7018,6 @@ static int io_rsrc_ref_quiesce(struct io_rsrc_data *data, struct io_ring_ctx *ct
 			break;
 
 		percpu_ref_resurrect(&data->refs);
-		io_rsrc_node_set(ctx, data);
 		reinit_completion(&data->done);
 
 		mutex_unlock(&ctx->uring_lock);
@@ -7502,7 +7498,7 @@ static int io_sqe_files_register(struct io_ring_ctx *ctx, void __user *arg,
 		return -EINVAL;
 	if (nr_args > IORING_MAX_FIXED_FILES)
 		return -EMFILE;
-	ret = io_rsrc_node_prealloc(ctx);
+	ret = io_rsrc_node_switch_start(ctx);
 	if (ret)
 		return ret;
 
@@ -7564,7 +7560,7 @@ static int io_sqe_files_register(struct io_ring_ctx *ctx, void __user *arg,
 		return ret;
 	}
 
-	io_rsrc_node_set(ctx, file_data);
+	io_rsrc_node_switch(ctx, NULL);
 	return ret;
 out_fput:
 	for (i = 0; i < ctx->nr_user_files; i++) {
@@ -7653,7 +7649,7 @@ static int __io_sqe_files_update(struct io_ring_ctx *ctx,
 		return -EOVERFLOW;
 	if (done > ctx->nr_user_files)
 		return -EINVAL;
-	err = io_rsrc_node_prealloc(ctx);
+	err = io_rsrc_node_switch_start(ctx);
 	if (err)
 		return err;
 
@@ -7672,7 +7668,7 @@ static int __io_sqe_files_update(struct io_ring_ctx *ctx,
 
 		if (*file_slot) {
 			file = (struct file *) ((unsigned long) *file_slot & FFS_MASK);
-			err = io_queue_rsrc_removal(data, data->node, file);
+			err = io_queue_rsrc_removal(data, ctx->rsrc_node, file);
 			if (err)
 				break;
 			*file_slot = NULL;
@@ -7707,10 +7703,8 @@ static int __io_sqe_files_update(struct io_ring_ctx *ctx,
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
 
@@ -8386,8 +8380,15 @@ static void io_ring_ctx_free(struct io_ring_ctx *ctx)
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

