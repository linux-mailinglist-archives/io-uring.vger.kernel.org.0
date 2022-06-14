Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 8B62A54B38B
	for <lists+io-uring@lfdr.de>; Tue, 14 Jun 2022 16:42:58 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S239570AbiFNOiQ (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Tue, 14 Jun 2022 10:38:16 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:33022 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S237979AbiFNOiH (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Tue, 14 Jun 2022 10:38:07 -0400
Received: from mail-wr1-x431.google.com (mail-wr1-x431.google.com [IPv6:2a00:1450:4864:20::431])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 90C82219C
        for <io-uring@vger.kernel.org>; Tue, 14 Jun 2022 07:38:05 -0700 (PDT)
Received: by mail-wr1-x431.google.com with SMTP id m24so11546658wrb.10
        for <io-uring@vger.kernel.org>; Tue, 14 Jun 2022 07:38:05 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=OlumRzI1KLIbIp9c72c5FvGFwKCu8xvw16ufWxwZEZY=;
        b=A+K4eUB+qwwaPdIdkHOwvSAMP1jVfJjw6StzphTSpfIkn2UkVbUsyFtNqxazqGvG0v
         b1KaeA/k0PFCf22vRCQFDYAcNBcWSDnxBqZBj8iz3XmuoebzwwvcqBhfpxGbA0lV8fxY
         mAjQ7jwzwyewBhphwvoVphcbPXTvMoK5HIxPXepnnuWsk3wmR6fBrvYtcsFMpc89yd+S
         5LQipqZioInwE1YgOHojfJx6qtjj9XqpH5XXwATenFeIvJiHK9NZVD+wCK0HbXte5Lk1
         RmB/0SrnGlowwLWevGRB+BCUjedXNJnAo3HpemXEsfbFjeMVsZWmM7gPZcwQ9JOqLcrt
         EJnw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=OlumRzI1KLIbIp9c72c5FvGFwKCu8xvw16ufWxwZEZY=;
        b=NrHUoghEhfGDWRR1ACQLn0hjV0odLBY1RunQwMT29/mnQRDR9mpIBPhgRJvVkPNP0Y
         KVo+SyrMIfmNc+LWFNam3mX1M4/9RKgqcAzayPYSYcbczmzhlN1PpxCJwczrepiul7VN
         bDJ6LcyqlJIKSM5/DXO2SGkSFrKbLLFn9sun1IpebEogdeXPF20+Yxtq/p75LgdzzXGe
         X6UEapGgmX623r7VdwzCok8UPB+tXtyPCRCuSKxr4j+xcO0v7mJukySMoJDp2BmnH+Ij
         YVLyiIiXHOVSNwVrZlYhtInTSqafBVPCW8vGbjd3cg0TWekkKCKQuAcMkAY2ozH2yFkp
         ud5g==
X-Gm-Message-State: AJIora8JkpOffgrwuwab+mRac4ExP4X+B0fTMNZhUJfFl95qULDztkf3
        NlpwlapHWvoMVJ0XP6VuYUErxQwRfjAvnQ==
X-Google-Smtp-Source: AGRyM1sc2mJcRJtWDKBGJ7afWeQ9m8zvMwrhON5YORChE+jO8Ht63YyHWA9gNZzu9yTvR4SSw0BuJg==
X-Received: by 2002:a5d:6d84:0:b0:217:e7af:224b with SMTP id l4-20020a5d6d84000000b00217e7af224bmr5338266wrs.512.1655217483761;
        Tue, 14 Jun 2022 07:38:03 -0700 (PDT)
Received: from 127.0.0.1localhost (188.28.125.106.threembb.co.uk. [188.28.125.106])
        by smtp.gmail.com with ESMTPSA id a4-20020adff7c4000000b0021033caa332sm12353064wrq.42.2022.06.14.07.38.02
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 14 Jun 2022 07:38:03 -0700 (PDT)
From:   Pavel Begunkov <asml.silence@gmail.com>
To:     io-uring@vger.kernel.org
Cc:     Jens Axboe <axboe@kernel.dk>, asml.silence@gmail.com
Subject: [PATCH for-next v2 21/25] io_uring: add IORING_SETUP_SINGLE_ISSUER
Date:   Tue, 14 Jun 2022 15:37:11 +0100
Message-Id: <d6235e12830a225584b90cf3b29f09a0681acc95.1655213915.git.asml.silence@gmail.com>
X-Mailer: git-send-email 2.36.1
In-Reply-To: <cover.1655213915.git.asml.silence@gmail.com>
References: <cover.1655213915.git.asml.silence@gmail.com>
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

Add a new IORING_SETUP_SINGLE_ISSUER flag and the userspace visible part
of it, i.e. put limitations of submitters. Also, don't allow it together
with IOPOLL as we're not going to put it to good use.

Signed-off-by: Pavel Begunkov <asml.silence@gmail.com>
---
 include/uapi/linux/io_uring.h |  5 ++++-
 io_uring/io_uring.c           |  7 +++++--
 io_uring/io_uring_types.h     |  1 +
 io_uring/tctx.c               | 27 ++++++++++++++++++++++++---
 io_uring/tctx.h               |  4 ++--
 5 files changed, 36 insertions(+), 8 deletions(-)

diff --git a/include/uapi/linux/io_uring.h b/include/uapi/linux/io_uring.h
index a41ddb8c5e1f..a3a691340d3e 100644
--- a/include/uapi/linux/io_uring.h
+++ b/include/uapi/linux/io_uring.h
@@ -138,9 +138,12 @@ enum {
  * IORING_SQ_TASKRUN in the sq ring flags. Not valid with COOP_TASKRUN.
  */
 #define IORING_SETUP_TASKRUN_FLAG	(1U << 9)
-
 #define IORING_SETUP_SQE128		(1U << 10) /* SQEs are 128 byte */
 #define IORING_SETUP_CQE32		(1U << 11) /* CQEs are 32 byte */
+/*
+ * Only one task is allowed to submit requests
+ */
+#define IORING_SETUP_SINGLE_ISSUER	(1U << 12)
 
 enum io_uring_op {
 	IORING_OP_NOP,
diff --git a/io_uring/io_uring.c b/io_uring/io_uring.c
index 15d209f334eb..4b90439808e3 100644
--- a/io_uring/io_uring.c
+++ b/io_uring/io_uring.c
@@ -3020,6 +3020,8 @@ static __cold void io_ring_ctx_free(struct io_ring_ctx *ctx)
 	io_destroy_buffers(ctx);
 	if (ctx->sq_creds)
 		put_cred(ctx->sq_creds);
+	if (ctx->submitter_task)
+		put_task_struct(ctx->submitter_task);
 
 	/* there are no registered resources left, nobody uses it */
 	if (ctx->rsrc_node)
@@ -3752,7 +3754,7 @@ static int io_uring_install_fd(struct io_ring_ctx *ctx, struct file *file)
 	if (fd < 0)
 		return fd;
 
-	ret = io_uring_add_tctx_node(ctx);
+	ret = __io_uring_add_tctx_node(ctx, false);
 	if (ret) {
 		put_unused_fd(fd);
 		return ret;
@@ -3972,7 +3974,8 @@ static long io_uring_setup(u32 entries, struct io_uring_params __user *params)
 			IORING_SETUP_CLAMP | IORING_SETUP_ATTACH_WQ |
 			IORING_SETUP_R_DISABLED | IORING_SETUP_SUBMIT_ALL |
 			IORING_SETUP_COOP_TASKRUN | IORING_SETUP_TASKRUN_FLAG |
-			IORING_SETUP_SQE128 | IORING_SETUP_CQE32))
+			IORING_SETUP_SQE128 | IORING_SETUP_CQE32 |
+			IORING_SETUP_SINGLE_ISSUER))
 		return -EINVAL;
 
 	return io_uring_create(entries, &p, params);
diff --git a/io_uring/io_uring_types.h b/io_uring/io_uring_types.h
index aba0f8cd6f49..f6d0ad25f377 100644
--- a/io_uring/io_uring_types.h
+++ b/io_uring/io_uring_types.h
@@ -241,6 +241,7 @@ struct io_ring_ctx {
 	/* Keep this last, we don't need it for the fast path */
 
 	struct io_restriction		restrictions;
+	struct task_struct		*submitter_task;
 
 	/* slow path rsrc auxilary data, used by update/register */
 	struct io_rsrc_node		*rsrc_backup_node;
diff --git a/io_uring/tctx.c b/io_uring/tctx.c
index 6adf659687f8..012be261dc50 100644
--- a/io_uring/tctx.c
+++ b/io_uring/tctx.c
@@ -81,12 +81,32 @@ __cold int io_uring_alloc_task_context(struct task_struct *task,
 	return 0;
 }
 
-int __io_uring_add_tctx_node(struct io_ring_ctx *ctx)
+static int io_register_submitter(struct io_ring_ctx *ctx)
+{
+	int ret = 0;
+
+	mutex_lock(&ctx->uring_lock);
+	if (!ctx->submitter_task)
+		ctx->submitter_task = get_task_struct(current);
+	else if (ctx->submitter_task != current)
+		ret = -EEXIST;
+	mutex_unlock(&ctx->uring_lock);
+
+	return ret;
+}
+
+int __io_uring_add_tctx_node(struct io_ring_ctx *ctx, bool submitter)
 {
 	struct io_uring_task *tctx = current->io_uring;
 	struct io_tctx_node *node;
 	int ret;
 
+	if ((ctx->flags & IORING_SETUP_SINGLE_ISSUER) && submitter) {
+		ret = io_register_submitter(ctx);
+		if (ret)
+			return ret;
+	}
+
 	if (unlikely(!tctx)) {
 		ret = io_uring_alloc_task_context(current, ctx);
 		if (unlikely(ret))
@@ -120,7 +140,8 @@ int __io_uring_add_tctx_node(struct io_ring_ctx *ctx)
 		list_add(&node->ctx_node, &ctx->tctx_list);
 		mutex_unlock(&ctx->uring_lock);
 	}
-	tctx->last = ctx;
+	if (submitter)
+		tctx->last = ctx;
 	return 0;
 }
 
@@ -228,7 +249,7 @@ int io_ringfd_register(struct io_ring_ctx *ctx, void __user *__arg,
 		return -EINVAL;
 
 	mutex_unlock(&ctx->uring_lock);
-	ret = io_uring_add_tctx_node(ctx);
+	ret = __io_uring_add_tctx_node(ctx, false);
 	mutex_lock(&ctx->uring_lock);
 	if (ret)
 		return ret;
diff --git a/io_uring/tctx.h b/io_uring/tctx.h
index 7684713e950f..dde82ce4d8e2 100644
--- a/io_uring/tctx.h
+++ b/io_uring/tctx.h
@@ -34,7 +34,7 @@ struct io_tctx_node {
 int io_uring_alloc_task_context(struct task_struct *task,
 				struct io_ring_ctx *ctx);
 void io_uring_del_tctx_node(unsigned long index);
-int __io_uring_add_tctx_node(struct io_ring_ctx *ctx);
+int __io_uring_add_tctx_node(struct io_ring_ctx *ctx, bool submitter);
 void io_uring_clean_tctx(struct io_uring_task *tctx);
 
 void io_uring_unreg_ringfd(void);
@@ -52,5 +52,5 @@ static inline int io_uring_add_tctx_node(struct io_ring_ctx *ctx)
 
 	if (likely(tctx && tctx->last == ctx))
 		return 0;
-	return __io_uring_add_tctx_node(ctx);
+	return __io_uring_add_tctx_node(ctx, true);
 }
-- 
2.36.1

