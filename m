Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id AE30734614A
	for <lists+io-uring@lfdr.de>; Tue, 23 Mar 2021 15:18:26 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232296AbhCWOSM (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Tue, 23 Mar 2021 10:18:12 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:46352 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232319AbhCWORg (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Tue, 23 Mar 2021 10:17:36 -0400
Received: from mail-wm1-x329.google.com (mail-wm1-x329.google.com [IPv6:2a00:1450:4864:20::329])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 78AC3C061765
        for <io-uring@vger.kernel.org>; Tue, 23 Mar 2021 07:17:35 -0700 (PDT)
Received: by mail-wm1-x329.google.com with SMTP id z6-20020a1c4c060000b029010f13694ba2so10914842wmf.5
        for <io-uring@vger.kernel.org>; Tue, 23 Mar 2021 07:17:35 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:subject:date:message-id:in-reply-to:references:mime-version
         :content-transfer-encoding;
        bh=ovgYRxem5zTUDKbnv01IwoJhXRQ1IcnF0gHmTCD5ex8=;
        b=NtXrFsdkQUww0JFUwTux5kAxIUKzmk89DAjjdC+PsFYzW31+mhEPRxrr/D7py6qif2
         AdV31l0CkezagCXmGYGAciiBhV9I0luHaCAzuxsotC9+jR7TzWx6tbtuGuZA7IL4cd7n
         MWATs2delLJFK7afhfKbPAo04ky5ScZUFUFhQxLyIFDay1+n/PHn4TbjYELbEWe61yLo
         7nZYr6AQpif/CinhzRSenJJ515U6BpdUg91GVqj2TN68IYnzIGuIqk4NJc1B6XbsJLS9
         uA+3cb4p1+y6RMCxd2R/WlEx5iiDlH+74q9DiMKSM06lQdCV8BB2B7CuEfdh54XDLnw5
         FcJA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=ovgYRxem5zTUDKbnv01IwoJhXRQ1IcnF0gHmTCD5ex8=;
        b=bjMpC2yD4M+9Y3ShRbbZJF2xDF+B8h8YSQJK3ddBEeHhBpJqIgptJQBxUZaJvNhXOG
         UXDKZlGEVezrvJSYvoE/Pm7W2Eu3B97hLxGzccTfnPAf65Umg68r6G5uqlQmLKImi0w0
         zwhtw/D+tVaLUqk1Rs8ttoxjj6gjsLJDLYIHWXcFQD9Ksfuz3HhBFjGQ2x8ZF9XOsSZx
         Mrf/SzpTAjIkHtMRKy11UD5Ul2gHWUk+xQsEgDbkZ/Ms0qrZ67STkOxEEqY8ENtf16bN
         +WfkMDAnmO2xIINQCedN93lzlbG19geeAhOaQFWtKdcaFtwzFw4mNh8Ig/ttXcZ0hIKQ
         9tBg==
X-Gm-Message-State: AOAM531P0ma31E+t5f27IYDWnt3+H0pAOE7QzqfKAKaqB9IdwixYt4Rr
        ZkrKRM9/2i/K8iV/c6MTs+9ziBA7cRK0nQ==
X-Google-Smtp-Source: ABdhPJxwCdOk7ip121tdeXXIPi6b8e9n7cSFeDPBAt6eapwBfb41r2rw+10iPXdz1ZG94Uo4e3oW/A==
X-Received: by 2002:a1c:3b43:: with SMTP id i64mr3558794wma.43.1616509054206;
        Tue, 23 Mar 2021 07:17:34 -0700 (PDT)
Received: from localhost.localdomain ([85.255.236.147])
        by smtp.gmail.com with ESMTPSA id c2sm2861277wmr.22.2021.03.23.07.17.31
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 23 Mar 2021 07:17:32 -0700 (PDT)
From:   Pavel Begunkov <asml.silence@gmail.com>
To:     Jens Axboe <axboe@kernel.dk>, io-uring@vger.kernel.org
Subject: [PATCH 7/7] io_uring: ctx-wide rsrc nodes
Date:   Tue, 23 Mar 2021 14:13:17 +0000
Message-Id: <906e97c999e8c5c6267d8c6732f3a38b96a0b105.1616508751.git.asml.silence@gmail.com>
X-Mailer: git-send-email 2.24.0
In-Reply-To: <cover.1616508751.git.asml.silence@gmail.com>
References: <cover.1616508751.git.asml.silence@gmail.com>
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
makes much sense for multiple types of resources, though requires some
additional handling on free. Another thing changed is that nodes are
bound to/associated with a io_rsrc_data later just before killing
(i.e. switching).

Signed-off-by: Pavel Begunkov <asml.silence@gmail.com>
---
 fs/io_uring.c | 95 +++++++++++++++++++++++++++++++--------------------
 1 file changed, 58 insertions(+), 37 deletions(-)

diff --git a/fs/io_uring.c b/fs/io_uring.c
index 175dd2c00991..b20caae75be6 100644
--- a/fs/io_uring.c
+++ b/fs/io_uring.c
@@ -222,6 +222,9 @@ struct io_rsrc_node {
 	struct io_rsrc_data		*rsrc_data;
 	struct llist_node		llist;
 	bool				done;
+
+	/* use only with dying ctx, lists and rsrc_data should not be used */
+	struct completion		*completion;
 };
 
 typedef void (rsrc_put_fn)(struct io_ring_ctx *ctx, struct io_rsrc_put *prsrc);
@@ -231,7 +234,6 @@ struct io_rsrc_data {
 	struct io_ring_ctx		*ctx;
 
 	rsrc_put_fn			*do_put;
-	struct io_rsrc_node		*node;
 	struct percpu_ref		refs;
 	struct completion		done;
 	bool				quiesce;
@@ -444,6 +446,7 @@ struct io_ring_ctx {
 	struct llist_head		rsrc_put_llist;
 	struct list_head		rsrc_ref_list;
 	spinlock_t			rsrc_ref_lock;
+	struct io_rsrc_node		*rsrc_node;
 	struct io_rsrc_node		*rsrc_backup_node;
 
 	struct io_restriction		restrictions;
@@ -1064,7 +1067,7 @@ static inline void io_req_set_rsrc_node(struct io_kiocb *req)
 	struct io_ring_ctx *ctx = req->ctx;
 
 	if (!req->fixed_rsrc_refs) {
-		req->fixed_rsrc_refs = &ctx->file_data->node->refs;
+		req->fixed_rsrc_refs = &ctx->rsrc_node->refs;
 		percpu_ref_get(req->fixed_rsrc_refs);
 	}
 }
@@ -6958,36 +6961,32 @@ static inline void io_rsrc_ref_unlock(struct io_ring_ctx *ctx)
 	spin_unlock_bh(&ctx->rsrc_ref_lock);
 }
 
-static void io_rsrc_node_set(struct io_ring_ctx *ctx,
-			     struct io_rsrc_data *rsrc_data)
+static void io_rsrc_node_switch(struct io_ring_ctx *ctx,
+				struct io_rsrc_data *data_to_kill)
 {
-	struct io_rsrc_node *rsrc_node = ctx->rsrc_backup_node;
-
-	WARN_ON_ONCE(!rsrc_node);
+	WARN_ON_ONCE(!ctx->rsrc_backup_node);
+	WARN_ON_ONCE(data_to_kill && !ctx->rsrc_node);
 
-	ctx->rsrc_backup_node = NULL;
-	rsrc_node->rsrc_data = rsrc_data;
+	if (data_to_kill) {
+		struct io_rsrc_node *rsrc_node = ctx->rsrc_node;
 
-	io_rsrc_ref_lock(ctx);
-	rsrc_data->node = rsrc_node;
-	list_add_tail(&rsrc_node->node, &ctx->rsrc_ref_list);
-	io_rsrc_ref_unlock(ctx);
-	percpu_ref_get(&rsrc_data->refs);
-}
+		rsrc_node->rsrc_data = data_to_kill;
+		io_rsrc_ref_lock(ctx);
+		list_add_tail(&rsrc_node->node, &ctx->rsrc_ref_list);
+		io_rsrc_ref_unlock(ctx);
 
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
@@ -7004,10 +7003,11 @@ static int io_rsrc_ref_quiesce(struct io_rsrc_data *data, struct io_ring_ctx *ct
 
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
 
@@ -7016,7 +7016,6 @@ static int io_rsrc_ref_quiesce(struct io_rsrc_data *data, struct io_ring_ctx *ct
 			break;
 
 		percpu_ref_resurrect(&data->refs);
-		io_rsrc_node_set(ctx, data);
 		reinit_completion(&data->done);
 
 		mutex_unlock(&ctx->uring_lock);
@@ -7434,10 +7433,18 @@ static void io_rsrc_node_ref_zero(struct percpu_ref *ref)
 {
 	struct io_rsrc_node *node = container_of(ref, struct io_rsrc_node, refs);
 	struct io_rsrc_data *data = node->rsrc_data;
-	struct io_ring_ctx *ctx = data->ctx;
+	struct io_ring_ctx *ctx;
 	bool first_add = false;
 	int delay;
 
+	if (node->completion) {
+		complete(node->completion);
+		percpu_ref_exit(&node->refs);
+		kfree(node);
+		return;
+	}
+
+	ctx =  data->ctx;
 	io_rsrc_ref_lock(ctx);
 	node->done = true;
 
@@ -7497,7 +7504,7 @@ static int io_sqe_files_register(struct io_ring_ctx *ctx, void __user *arg,
 		return -EINVAL;
 	if (nr_args > IORING_MAX_FIXED_FILES)
 		return -EMFILE;
-	ret = io_rsrc_node_prealloc(ctx);
+	ret = io_rsrc_node_switch_start(ctx);
 	if (ret)
 		return ret;
 
@@ -7559,7 +7566,7 @@ static int io_sqe_files_register(struct io_ring_ctx *ctx, void __user *arg,
 		return ret;
 	}
 
-	io_rsrc_node_set(ctx, file_data);
+	io_rsrc_node_switch(ctx, NULL);
 	return ret;
 out_fput:
 	for (i = 0; i < ctx->nr_user_files; i++) {
@@ -7648,7 +7655,7 @@ static int __io_sqe_files_update(struct io_ring_ctx *ctx,
 		return -EOVERFLOW;
 	if (done > ctx->nr_user_files)
 		return -EINVAL;
-	err = io_rsrc_node_prealloc(ctx);
+	err = io_rsrc_node_switch_start(ctx);
 	if (err)
 		return err;
 
@@ -7667,7 +7674,7 @@ static int __io_sqe_files_update(struct io_ring_ctx *ctx,
 
 		if (*file_slot) {
 			file = (struct file *) ((unsigned long) *file_slot & FFS_MASK);
-			err = io_queue_rsrc_removal(data, data->node, file);
+			err = io_queue_rsrc_removal(data, ctx->rsrc_node, file);
 			if (err)
 				break;
 			*file_slot = NULL;
@@ -7702,10 +7709,8 @@ static int __io_sqe_files_update(struct io_ring_ctx *ctx,
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
 
@@ -8376,6 +8381,22 @@ static void io_ring_ctx_free(struct io_ring_ctx *ctx)
 	io_eventfd_unregister(ctx);
 	io_destroy_buffers(ctx);
 
+	if (ctx->rsrc_node) {
+		struct io_rsrc_node *node = ctx->rsrc_node;
+		struct completion compl;
+
+		ctx->rsrc_node = NULL;
+		init_completion(&compl);
+		node->completion = &compl;
+		node->rsrc_data = NULL;
+		percpu_ref_kill(&node->refs);
+		wait_for_completion(&compl);
+	}
+	flush_delayed_work(&ctx->rsrc_put_work);
+
+	WARN_ON_ONCE(!list_empty(&ctx->rsrc_ref_list));
+	WARN_ON_ONCE(!llist_empty(&ctx->rsrc_put_llist));
+
 	if (ctx->rsrc_backup_node)
 		io_rsrc_node_destroy(ctx->rsrc_backup_node);
 
-- 
2.24.0

