Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id D27916E6564
	for <lists+io-uring@lfdr.de>; Tue, 18 Apr 2023 15:07:28 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231847AbjDRNH1 (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Tue, 18 Apr 2023 09:07:27 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:34112 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231464AbjDRNHX (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Tue, 18 Apr 2023 09:07:23 -0400
Received: from mail-ej1-x62c.google.com (mail-ej1-x62c.google.com [IPv6:2a00:1450:4864:20::62c])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 9B89A3A8C
        for <io-uring@vger.kernel.org>; Tue, 18 Apr 2023 06:07:11 -0700 (PDT)
Received: by mail-ej1-x62c.google.com with SMTP id c9so34168637ejz.1
        for <io-uring@vger.kernel.org>; Tue, 18 Apr 2023 06:07:11 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20221208; t=1681823230; x=1684415230;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=SHGOcSbO4CFktsigyjeHOrQ9+I9wddk/Bik1I4oZ3is=;
        b=COD635/B7XacYaQFFVX1xojIdiqVy8Mm1TTUtDUOd3drzYR++Zioxb3jQgZ5yi2sDt
         aCS5rNqSa13q0w5BhLyFMkkPCHQaYc5r0mBny6W5xVXwRZOJTKQAjDHzZN4qu4WRbH15
         yKvv46LUh30m6dEvQvFOpM/QdCltGQlMOjYpsFEqOZEiXhMO+vBnJ6jYZKJ3yZ70FNPm
         1WLiCjpgOsko4eR6X2yshof+jqZyM5dwKpS9/wqJ1y9XT9vsBtlM9ezpC9NsjRCvBMb6
         j2XwOEU0DI5UwzURote2OdrKVjLfBLboiu6YTrB8IioLmsEym3h/LjPpb3WU3NEPslZa
         I+6w==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20221208; t=1681823230; x=1684415230;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=SHGOcSbO4CFktsigyjeHOrQ9+I9wddk/Bik1I4oZ3is=;
        b=CDwY7kfnhQNG4dMeYd2+dBIR/+lgZ6DsV7pZavryvoFm0jjbNeRjgRQrlZ6msfeEwX
         A/BYWwueWgq1Ebk5jwLv2WOtSykXGJZWfK3eVuoYH7EeQQj0BAPsbJiFCzN7V4GsGK8D
         Nbe8Z4sOeT4DnuIiOVxZLlsHnF7dC6GXDlaowfElxNiTuJjyYtLbitkA7/jpZBjBlUZX
         OOZUiIOdBJsnNWfhOKQbSv8BsBammqCZ3bjsszB4WiqTaq5cV2Gi9PsEuhpe0iQoaqWi
         O9vlqW4XTV1RpLH2hADmAoiEeGgdCQeAi21npQKC8o3KL2mUeEIdqT96ihr30ND/BjHq
         4qoA==
X-Gm-Message-State: AAQBX9c4VkP/1IIrj36VBBrKQvKgOheAvGefos9pG0ulPUNKcp1fqpVK
        0hnjsejWYHgb+UPgMBt3TZmbQ7B9Zq0=
X-Google-Smtp-Source: AKy350aZ24dyAUcs+DhUZyUjIco1rcW3NFUS17SYrE0FosZX5k8Hss/OmZG6KVNqT4Ana7yppI3dAA==
X-Received: by 2002:a17:906:3a82:b0:8a0:7158:15dc with SMTP id y2-20020a1709063a8200b008a0715815dcmr8709761ejd.74.1681823229859;
        Tue, 18 Apr 2023 06:07:09 -0700 (PDT)
Received: from 127.com ([2620:10d:c092:600::2:cfa6])
        by smtp.gmail.com with ESMTPSA id o26-20020a1709061d5a00b0094e44899367sm7924919ejh.101.2023.04.18.06.07.09
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 18 Apr 2023 06:07:09 -0700 (PDT)
From:   Pavel Begunkov <asml.silence@gmail.com>
To:     io-uring@vger.kernel.org
Cc:     Jens Axboe <axboe@kernel.dk>, asml.silence@gmail.com
Subject: [PATCH for-next 3/8] io_uring/rsrc: merge nodes and io_rsrc_put
Date:   Tue, 18 Apr 2023 14:06:36 +0100
Message-Id: <c7d3a45b30cc14cd93700a710dd112edc703db98.1681822823.git.asml.silence@gmail.com>
X-Mailer: git-send-email 2.40.0
In-Reply-To: <cover.1681822823.git.asml.silence@gmail.com>
References: <cover.1681822823.git.asml.silence@gmail.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_FROM,
        RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org

struct io_rsrc_node carries a number of resources represented by struct
io_rsrc_put. That was handy before for sync overhead ammortisation, but
all complexity is gone and nodes are simple and lightweight. Let's
allocate a separate node for each resource.

Nodes and io_rsrc_put and not much different in size, and former are
cached, so node allocation should work better. That also removes some
overhead for nested iteration in io_rsrc_node_ref_zero() /
__io_rsrc_put_work().

Another reason for the patch is that it greatly reduces complexity
by moving io_rsrc_node_switch[_start]() inside io_queue_rsrc_removal(),
so users don't have to care about it.

Signed-off-by: Pavel Begunkov <asml.silence@gmail.com>
---
 io_uring/filetable.c |  9 -----
 io_uring/rsrc.c      | 91 +++++++++++---------------------------------
 io_uring/rsrc.h      | 22 +----------
 3 files changed, 25 insertions(+), 97 deletions(-)

diff --git a/io_uring/filetable.c b/io_uring/filetable.c
index 367a44a6c8c5..0f6fa791a47d 100644
--- a/io_uring/filetable.c
+++ b/io_uring/filetable.c
@@ -80,10 +80,6 @@ static int io_install_fixed_file(struct io_ring_ctx *ctx, struct file *file,
 	if (file_slot->file_ptr) {
 		struct file *old_file;
 
-		ret = io_rsrc_node_switch_start(ctx);
-		if (ret)
-			return ret;
-
 		old_file = (struct file *)(file_slot->file_ptr & FFS_MASK);
 		ret = io_queue_rsrc_removal(ctx->file_data, slot_index, old_file);
 		if (ret)
@@ -91,7 +87,6 @@ static int io_install_fixed_file(struct io_ring_ctx *ctx, struct file *file,
 
 		file_slot->file_ptr = 0;
 		io_file_bitmap_clear(&ctx->file_table, slot_index);
-		io_rsrc_node_switch(ctx, ctx->file_data);
 	}
 
 	ret = io_scm_file_account(ctx, file);
@@ -152,9 +147,6 @@ int io_fixed_fd_remove(struct io_ring_ctx *ctx, unsigned int offset)
 		return -ENXIO;
 	if (offset >= ctx->nr_user_files)
 		return -EINVAL;
-	ret = io_rsrc_node_switch_start(ctx);
-	if (ret)
-		return ret;
 
 	offset = array_index_nospec(offset, ctx->nr_user_files);
 	file_slot = io_fixed_file_slot(&ctx->file_table, offset);
@@ -168,7 +160,6 @@ int io_fixed_fd_remove(struct io_ring_ctx *ctx, unsigned int offset)
 
 	file_slot->file_ptr = 0;
 	io_file_bitmap_clear(&ctx->file_table, offset);
-	io_rsrc_node_switch(ctx, ctx->file_data);
 	return 0;
 }
 
diff --git a/io_uring/rsrc.c b/io_uring/rsrc.c
index 3be483de613e..a54a222a20b8 100644
--- a/io_uring/rsrc.c
+++ b/io_uring/rsrc.c
@@ -153,17 +153,10 @@ static void io_rsrc_put_work_one(struct io_rsrc_data *rsrc_data,
 static void __io_rsrc_put_work(struct io_rsrc_node *ref_node)
 {
 	struct io_rsrc_data *rsrc_data = ref_node->rsrc_data;
-	struct io_rsrc_put *prsrc, *tmp;
 
-	if (ref_node->inline_items)
+	if (likely(ref_node->inline_items))
 		io_rsrc_put_work_one(rsrc_data, &ref_node->item);
 
-	list_for_each_entry_safe(prsrc, tmp, &ref_node->item_list, list) {
-		list_del(&prsrc->list);
-		io_rsrc_put_work_one(rsrc_data, prsrc);
-		kfree(prsrc);
-	}
-
 	io_rsrc_node_destroy(rsrc_data->ctx, ref_node);
 }
 
@@ -206,53 +199,29 @@ struct io_rsrc_node *io_rsrc_node_alloc(struct io_ring_ctx *ctx)
 	}
 
 	ref_node->rsrc_data = NULL;
-	ref_node->refs = 1;
-	INIT_LIST_HEAD(&ref_node->node);
-	INIT_LIST_HEAD(&ref_node->item_list);
 	ref_node->inline_items = 0;
+	ref_node->refs = 1;
 	return ref_node;
 }
 
-void io_rsrc_node_switch(struct io_ring_ctx *ctx,
-			 struct io_rsrc_data *data_to_kill)
-	__must_hold(&ctx->uring_lock)
-{
-	struct io_rsrc_node *node = ctx->rsrc_node;
-	struct io_rsrc_node *backup = io_rsrc_node_alloc(ctx);
-
-	if (WARN_ON_ONCE(!backup))
-		return;
-
-	node->rsrc_data = data_to_kill;
-	list_add_tail(&node->node, &ctx->rsrc_ref_list);
-	/* put master ref */
-	io_put_rsrc_node(ctx, node);
-	ctx->rsrc_node = backup;
-}
-
-int __io_rsrc_node_switch_start(struct io_ring_ctx *ctx)
-{
-	struct io_rsrc_node *node = kzalloc(sizeof(*node), GFP_KERNEL);
-
-	if (!node)
-		return -ENOMEM;
-	io_alloc_cache_put(&ctx->rsrc_node_cache, &node->cache);
-	return 0;
-}
-
 __cold static int io_rsrc_ref_quiesce(struct io_rsrc_data *data,
 				      struct io_ring_ctx *ctx)
 {
+	struct io_rsrc_node *backup;
 	DEFINE_WAIT(we);
 	int ret;
 
-	/* As we may drop ->uring_lock, other task may have started quiesce */
+	/* As We may drop ->uring_lock, other task may have started quiesce */
 	if (data->quiesce)
 		return -ENXIO;
-	ret = io_rsrc_node_switch_start(ctx);
-	if (ret)
-		return ret;
-	io_rsrc_node_switch(ctx, data);
+
+	backup = io_rsrc_node_alloc(ctx);
+	if (!backup)
+		return -ENOMEM;
+	ctx->rsrc_node->rsrc_data = data;
+	list_add_tail(&ctx->rsrc_node->node, &ctx->rsrc_ref_list);
+	io_put_rsrc_node(ctx, ctx->rsrc_node);
+	ctx->rsrc_node = backup;
 
 	if (list_empty(&ctx->rsrc_ref_list))
 		return 0;
@@ -382,7 +351,6 @@ static int __io_sqe_files_update(struct io_ring_ctx *ctx,
 	struct file *file;
 	int fd, i, err = 0;
 	unsigned int done;
-	bool needs_switch = false;
 
 	if (!ctx->file_data)
 		return -ENXIO;
@@ -414,7 +382,6 @@ static int __io_sqe_files_update(struct io_ring_ctx *ctx,
 				break;
 			file_slot->file_ptr = 0;
 			io_file_bitmap_clear(&ctx->file_table, i);
-			needs_switch = true;
 		}
 		if (fd != -1) {
 			file = fget(fd);
@@ -445,9 +412,6 @@ static int __io_sqe_files_update(struct io_ring_ctx *ctx,
 			io_file_bitmap_set(&ctx->file_table, i);
 		}
 	}
-
-	if (needs_switch)
-		io_rsrc_node_switch(ctx, data);
 	return done ? done : err;
 }
 
@@ -458,7 +422,6 @@ static int __io_sqe_buffers_update(struct io_ring_ctx *ctx,
 	u64 __user *tags = u64_to_user_ptr(up->tags);
 	struct iovec iov, __user *iovs = u64_to_user_ptr(up->data);
 	struct page *last_hpage = NULL;
-	bool needs_switch = false;
 	__u32 done;
 	int i, err;
 
@@ -498,15 +461,11 @@ static int __io_sqe_buffers_update(struct io_ring_ctx *ctx,
 				break;
 			}
 			ctx->user_bufs[i] = ctx->dummy_ubuf;
-			needs_switch = true;
 		}
 
 		ctx->user_bufs[i] = imu;
 		*io_get_tag_slot(ctx->buf_data, i) = tag;
 	}
-
-	if (needs_switch)
-		io_rsrc_node_switch(ctx, ctx->buf_data);
 	return done ? done : err;
 }
 
@@ -515,15 +474,11 @@ static int __io_register_rsrc_update(struct io_ring_ctx *ctx, unsigned type,
 				     unsigned nr_args)
 {
 	__u32 tmp;
-	int err;
 
 	lockdep_assert_held(&ctx->uring_lock);
 
 	if (check_add_overflow(up->offset, nr_args, &tmp))
 		return -EOVERFLOW;
-	err = io_rsrc_node_switch_start(ctx);
-	if (err)
-		return err;
 
 	switch (type) {
 	case IORING_RSRC_FILE:
@@ -685,21 +640,21 @@ int io_queue_rsrc_removal(struct io_rsrc_data *data, unsigned idx, void *rsrc)
 	struct io_ring_ctx *ctx = data->ctx;
 	struct io_rsrc_node *node = ctx->rsrc_node;
 	u64 *tag_slot = io_get_tag_slot(data, idx);
-	struct io_rsrc_put *prsrc;
 
-	if (!node->inline_items) {
-		prsrc = &node->item;
-		node->inline_items++;
-	} else {
-		prsrc = kzalloc(sizeof(*prsrc), GFP_KERNEL);
-		if (!prsrc)
-			return -ENOMEM;
-		list_add(&prsrc->list, &node->item_list);
+	ctx->rsrc_node = io_rsrc_node_alloc(ctx);
+	if (unlikely(!ctx->rsrc_node)) {
+		ctx->rsrc_node = node;
+		return -ENOMEM;
 	}
 
-	prsrc->tag = *tag_slot;
+	node->item.rsrc = rsrc;
+	node->item.tag = *tag_slot;
+	node->inline_items = 1;
 	*tag_slot = 0;
-	prsrc->rsrc = rsrc;
+
+	node->rsrc_data = data;
+	list_add_tail(&node->node, &ctx->rsrc_ref_list);
+	io_put_rsrc_node(ctx, node);
 	return 0;
 }
 
diff --git a/io_uring/rsrc.h b/io_uring/rsrc.h
index 8ed3e6a65cf6..bad7103f5033 100644
--- a/io_uring/rsrc.h
+++ b/io_uring/rsrc.h
@@ -18,7 +18,6 @@ enum {
 };
 
 struct io_rsrc_put {
-	struct list_head list;
 	u64 tag;
 	union {
 		void *rsrc;
@@ -43,17 +42,10 @@ struct io_rsrc_node {
 		struct io_cache_entry		cache;
 		struct io_rsrc_data		*rsrc_data;
 	};
-	struct list_head		node;
 	int				refs;
-
-	/*
-	 * Keeps a list of struct io_rsrc_put to be completed. Each entry
-	 * represents one rsrc (e.g. file or buffer), but all of them should've
-	 * came from the same table and so are of the same type.
-	 */
-	struct list_head		item_list;
-	struct io_rsrc_put		item;
 	int				inline_items;
+	struct list_head		node;
+	struct io_rsrc_put		item;
 };
 
 struct io_mapped_ubuf {
@@ -68,11 +60,8 @@ void io_rsrc_put_tw(struct callback_head *cb);
 void io_rsrc_node_ref_zero(struct io_rsrc_node *node);
 void io_rsrc_put_work(struct work_struct *work);
 void io_rsrc_node_destroy(struct io_ring_ctx *ctx, struct io_rsrc_node *ref_node);
-int __io_rsrc_node_switch_start(struct io_ring_ctx *ctx);
 struct io_rsrc_node *io_rsrc_node_alloc(struct io_ring_ctx *ctx);
 int io_queue_rsrc_removal(struct io_rsrc_data *data, unsigned idx, void *rsrc);
-void io_rsrc_node_switch(struct io_ring_ctx *ctx,
-			 struct io_rsrc_data *data_to_kill);
 
 int io_import_fixed(int ddir, struct iov_iter *iter,
 			   struct io_mapped_ubuf *imu,
@@ -109,13 +98,6 @@ static inline int io_scm_file_account(struct io_ring_ctx *ctx,
 	return __io_scm_file_account(ctx, file);
 }
 
-static inline int io_rsrc_node_switch_start(struct io_ring_ctx *ctx)
-{
-	if (unlikely(io_alloc_cache_empty(&ctx->rsrc_node_cache)))
-		return __io_rsrc_node_switch_start(ctx);
-	return 0;
-}
-
 int io_register_files_update(struct io_ring_ctx *ctx, void __user *arg,
 			     unsigned nr_args);
 int io_register_rsrc_update(struct io_ring_ctx *ctx, void __user *arg,
-- 
2.40.0

