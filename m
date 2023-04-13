Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 964A86E1001
	for <lists+io-uring@lfdr.de>; Thu, 13 Apr 2023 16:29:06 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231524AbjDMO3F (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Thu, 13 Apr 2023 10:29:05 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:58782 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229821AbjDMO3D (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Thu, 13 Apr 2023 10:29:03 -0400
Received: from mail-wr1-x42c.google.com (mail-wr1-x42c.google.com [IPv6:2a00:1450:4864:20::42c])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 5464CAD2A
        for <io-uring@vger.kernel.org>; Thu, 13 Apr 2023 07:29:00 -0700 (PDT)
Received: by mail-wr1-x42c.google.com with SMTP id s12so5902502wrb.1
        for <io-uring@vger.kernel.org>; Thu, 13 Apr 2023 07:29:00 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20221208; t=1681396138; x=1683988138;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=XNhLZukWHJN4z1mvPxjsyOxj4OpV4VMzlRf/y/OXoMM=;
        b=QNXWvBtWP97MB0Q1XQ3yJZqBPAtwU+wmsYjq+vP5Ri78oeAKCEtHAofZkKSRhYtkHE
         Hesfo9J3Vc/W3v5WljhP2rmLV7pch9RWge6ju5dpinctaMhMlq/grqtR0H4ORwZldhYf
         Hfq0rl0Zd7ZwVtDQ/8aUgUjHvM9S+15BP+O4zp3b1AJ+x8aCTpxutnfWLldRSpUagu2O
         p836krlgtT3SvghKh0iOwAwXyZcTRVXCTc0zShMWhqJUgvp8k67AXcx2Zjq7Dgi3s1uz
         Ulxa4qtcXBBicAUVvge0mVqn96ygLPtEgQy9mR5KVayLzsZGzKDWiLTcOECeuv1Az2y7
         HHWA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20221208; t=1681396138; x=1683988138;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=XNhLZukWHJN4z1mvPxjsyOxj4OpV4VMzlRf/y/OXoMM=;
        b=iI7N9EcBLI6u5DAuuYiOnQVlmvN8iO9N+g/bWpYHAO0wU2c+gPtUdAJR81BMf3X3A7
         5jFOX+VPoCTzDXy4oyyMXrXqGgWuEo1krVW+yPAWjd4MkHD8y2vZrh4JcJd6SY0UWhqN
         6cPilNv8LTQFMdj0zSXIZazRG5PQ6eo/u5iY2J2JxUSuVXOy5hM2oR1Yg3VlgvcyZjO+
         bgEGytM81kPp8fEqHzM3C9zDn1CGGly61di75GvR82u9rUiHOsb9yarsxZ3GX7ZnBuZg
         RnhFGuP39Gd3dP2r9NeBOxj4WFHI7SgjVYLlMbPJjK9PIervggmjHWQJYtFd6EZ2QMLj
         29Qg==
X-Gm-Message-State: AAQBX9fgLnLKYFIgGKBhofO2mFX5Ce1snK4ltZz4qxvRl5TdfXKgeoZk
        sfQY26lM6RKgTjsiMPp3NncL5GJgeKg=
X-Google-Smtp-Source: AKy350ZcC+rMcwKs5CF9/ujbjPKB21IVHgT8mePOHEVqjqG8rRKw8iR/Fct5bDMm0D0KyLGxt5K9cw==
X-Received: by 2002:a05:6000:128f:b0:2f0:69c4:3900 with SMTP id f15-20020a056000128f00b002f069c43900mr1532275wrx.54.1681396138708;
        Thu, 13 Apr 2023 07:28:58 -0700 (PDT)
Received: from 127.0.0.1localhost (94.196.97.186.threembb.co.uk. [94.196.97.186])
        by smtp.gmail.com with ESMTPSA id z14-20020adff1ce000000b002f28de9f73bsm1387391wro.55.2023.04.13.07.28.57
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 13 Apr 2023 07:28:58 -0700 (PDT)
From:   Pavel Begunkov <asml.silence@gmail.com>
To:     io-uring@vger.kernel.org
Cc:     Jens Axboe <axboe@kernel.dk>, asml.silence@gmail.com
Subject: [PATCH 06/10] io_uring/rsrc: remove rsrc_data refs
Date:   Thu, 13 Apr 2023 15:28:10 +0100
Message-Id: <8e33fd143d83e11af3e386aea28eb6d6c6a1be10.1681395792.git.asml.silence@gmail.com>
X-Mailer: git-send-email 2.40.0
In-Reply-To: <cover.1681395792.git.asml.silence@gmail.com>
References: <cover.1681395792.git.asml.silence@gmail.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_FROM,
        RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org

Instead of waiting for rsrc_data->refs to be downed to zero, check
whether there are rsrc nodes queued for completion, that's easier then
maintaining references.

Signed-off-by: Pavel Begunkov <asml.silence@gmail.com>
---
 include/linux/io_uring_types.h |  1 +
 io_uring/io_uring.c            |  4 ++--
 io_uring/rsrc.c                | 32 ++++++++------------------------
 io_uring/rsrc.h                |  2 --
 4 files changed, 11 insertions(+), 28 deletions(-)

diff --git a/include/linux/io_uring_types.h b/include/linux/io_uring_types.h
index 5c9645319770..1b2a20a42413 100644
--- a/include/linux/io_uring_types.h
+++ b/include/linux/io_uring_types.h
@@ -334,6 +334,7 @@ struct io_ring_ctx {
 	struct list_head		rsrc_ref_list;
 	struct io_alloc_cache		rsrc_node_cache;
 	struct wait_queue_head		rsrc_quiesce_wq;
+	unsigned			rsrc_quiesce;
 
 	struct list_head		io_buffers_pages;
 
diff --git a/io_uring/io_uring.c b/io_uring/io_uring.c
index 3c1c8c788b7b..3d43df8f1e4e 100644
--- a/io_uring/io_uring.c
+++ b/io_uring/io_uring.c
@@ -2831,8 +2831,8 @@ static __cold void io_ring_ctx_free(struct io_ring_ctx *ctx)
 {
 	io_sq_thread_finish(ctx);
 	/* __io_rsrc_put_work() may need uring_lock to progress, wait w/o it */
-	io_wait_rsrc_data(ctx->buf_data);
-	io_wait_rsrc_data(ctx->file_data);
+	if (WARN_ON_ONCE(!list_empty(&ctx->rsrc_ref_list)))
+		return;
 
 	mutex_lock(&ctx->uring_lock);
 	if (ctx->buf_data)
diff --git a/io_uring/rsrc.c b/io_uring/rsrc.c
index e634ef384724..5415a18844e0 100644
--- a/io_uring/rsrc.c
+++ b/io_uring/rsrc.c
@@ -31,11 +31,6 @@ static int io_sqe_buffer_register(struct io_ring_ctx *ctx, struct iovec *iov,
 #define IORING_MAX_FIXED_FILES	(1U << 20)
 #define IORING_MAX_REG_BUFFERS	(1U << 14)
 
-static inline bool io_put_rsrc_data_ref(struct io_rsrc_data *rsrc_data)
-{
-	return !--rsrc_data->refs;
-}
-
 int __io_account_mem(struct user_struct *user, unsigned long nr_pages)
 {
 	unsigned long page_limit, cur_pages, new_pages;
@@ -158,7 +153,6 @@ static void io_rsrc_put_work_one(struct io_rsrc_data *rsrc_data,
 static void __io_rsrc_put_work(struct io_rsrc_node *ref_node)
 {
 	struct io_rsrc_data *rsrc_data = ref_node->rsrc_data;
-	struct io_ring_ctx *ctx = rsrc_data->ctx;
 	struct io_rsrc_put *prsrc, *tmp;
 
 	if (ref_node->inline_items)
@@ -171,14 +165,6 @@ static void __io_rsrc_put_work(struct io_rsrc_node *ref_node)
 	}
 
 	io_rsrc_node_destroy(rsrc_data->ctx, ref_node);
-	if (io_put_rsrc_data_ref(rsrc_data))
-		wake_up_all(&ctx->rsrc_quiesce_wq);
-}
-
-void io_wait_rsrc_data(struct io_rsrc_data *data)
-{
-	if (data)
-		WARN_ON_ONCE(!io_put_rsrc_data_ref(data));
 }
 
 void io_rsrc_node_destroy(struct io_ring_ctx *ctx, struct io_rsrc_node *node)
@@ -201,6 +187,8 @@ void io_rsrc_node_ref_zero(struct io_rsrc_node *node)
 		list_del(&node->node);
 		__io_rsrc_put_work(node);
 	}
+	if (list_empty(&ctx->rsrc_ref_list) && unlikely(ctx->rsrc_quiesce))
+		wake_up_all(&ctx->rsrc_quiesce_wq);
 }
 
 struct io_rsrc_node *io_rsrc_node_alloc(struct io_ring_ctx *ctx)
@@ -235,7 +223,6 @@ void io_rsrc_node_switch(struct io_ring_ctx *ctx,
 	if (WARN_ON_ONCE(!backup))
 		return;
 
-	data_to_kill->refs++;
 	node->rsrc_data = data_to_kill;
 	list_add_tail(&node->node, &ctx->rsrc_ref_list);
 	/* put master ref */
@@ -269,8 +256,7 @@ __cold static int io_rsrc_ref_quiesce(struct io_rsrc_data *data,
 		return ret;
 	io_rsrc_node_switch(ctx, data);
 
-	/* kill initial ref */
-	if (io_put_rsrc_data_ref(data))
+	if (list_empty(&ctx->rsrc_ref_list))
 		return 0;
 
 	if (ctx->flags & IORING_SETUP_DEFER_TASKRUN) {
@@ -278,6 +264,7 @@ __cold static int io_rsrc_ref_quiesce(struct io_rsrc_data *data,
 		smp_mb();
 	}
 
+	ctx->rsrc_quiesce++;
 	data->quiesce = true;
 	do {
 		prepare_to_wait(&ctx->rsrc_quiesce_wq, &we, TASK_INTERRUPTIBLE);
@@ -286,12 +273,8 @@ __cold static int io_rsrc_ref_quiesce(struct io_rsrc_data *data,
 		ret = io_run_task_work_sig(ctx);
 		if (ret < 0) {
 			mutex_lock(&ctx->uring_lock);
-			if (!data->refs) {
+			if (list_empty(&ctx->rsrc_ref_list))
 				ret = 0;
-			} else {
-				/* restore the master reference */
-				data->refs++;
-			}
 			break;
 		}
 
@@ -299,10 +282,12 @@ __cold static int io_rsrc_ref_quiesce(struct io_rsrc_data *data,
 		__set_current_state(TASK_RUNNING);
 		mutex_lock(&ctx->uring_lock);
 		ret = 0;
-	} while (data->refs);
+	} while (!list_empty(&ctx->rsrc_ref_list));
 
 	finish_wait(&ctx->rsrc_quiesce_wq, &we);
 	data->quiesce = false;
+	ctx->rsrc_quiesce--;
+
 	if (ctx->flags & IORING_SETUP_DEFER_TASKRUN) {
 		atomic_set(&ctx->cq_wait_nr, 0);
 		smp_mb();
@@ -371,7 +356,6 @@ __cold static int io_rsrc_data_alloc(struct io_ring_ctx *ctx,
 	data->nr = nr;
 	data->ctx = ctx;
 	data->do_put = do_put;
-	data->refs = 1;
 	if (utags) {
 		ret = -EFAULT;
 		for (i = 0; i < nr; i++) {
diff --git a/io_uring/rsrc.h b/io_uring/rsrc.h
index d93ba4e9742a..5dd2fcb28069 100644
--- a/io_uring/rsrc.h
+++ b/io_uring/rsrc.h
@@ -35,7 +35,6 @@ struct io_rsrc_data {
 	u64				**tags;
 	unsigned int			nr;
 	rsrc_put_fn			*do_put;
-	int				refs;
 	bool				quiesce;
 };
 
@@ -69,7 +68,6 @@ struct io_mapped_ubuf {
 void io_rsrc_put_tw(struct callback_head *cb);
 void io_rsrc_node_ref_zero(struct io_rsrc_node *node);
 void io_rsrc_put_work(struct work_struct *work);
-void io_wait_rsrc_data(struct io_rsrc_data *data);
 void io_rsrc_node_destroy(struct io_ring_ctx *ctx, struct io_rsrc_node *ref_node);
 int io_rsrc_node_switch_start(struct io_ring_ctx *ctx);
 struct io_rsrc_node *io_rsrc_node_alloc(struct io_ring_ctx *ctx);
-- 
2.40.0

