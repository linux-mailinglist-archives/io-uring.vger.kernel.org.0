Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 8EFB854DE1F
	for <lists+io-uring@lfdr.de>; Thu, 16 Jun 2022 11:23:17 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1376656AbiFPJW6 (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Thu, 16 Jun 2022 05:22:58 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:47688 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1376655AbiFPJW5 (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Thu, 16 Jun 2022 05:22:57 -0400
Received: from mail-wr1-x436.google.com (mail-wr1-x436.google.com [IPv6:2a00:1450:4864:20::436])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id E0FCC17057
        for <io-uring@vger.kernel.org>; Thu, 16 Jun 2022 02:22:56 -0700 (PDT)
Received: by mail-wr1-x436.google.com with SMTP id m24so1030919wrb.10
        for <io-uring@vger.kernel.org>; Thu, 16 Jun 2022 02:22:56 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=ANZk26/u+omi5h8PfmD2ift8n+Vb8egwsV2O9IpMZAk=;
        b=pZOIM2JWCad4wO8c9t6qYHZ7p/NBcvSxTdksULpHBNvTyWJ09TLLrLgER2TkjzkJR+
         e6FGpGpjk7OIH/8RgshqENVouWe7YDAZUyfBRmx6APegNen59L1tM/bOEjgWTiSJ8coc
         nK9RIBflJoPqsGweq0ZkDLmuL/sRug7h/g/mX2kGMwSrPor6gaXyeIoTVW5QGkx1CFBL
         5SFbh2hSze5wW0JqX+c6DeNUt2TAgqaV0svz0k2CWBO3dGgnRSIfTCg+IRN3EFdqJDqg
         RqBLWF2VRY2+VRw7+sJPifM+/ZXQl/XwTjohIiKP9g4yfPOUsuSmio9CX0cXUhvfszQj
         qzOA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=ANZk26/u+omi5h8PfmD2ift8n+Vb8egwsV2O9IpMZAk=;
        b=ZyUSXW7SgSyyDRH0G0U3vQ1NzrQuUfZ6YSEIw51g3pn6bf5FUlSHXpaamiKoh+/lYm
         tePFnDI8HbPSfyUUuLfgE8xuUvEZnDN3TUCPgf8F//8aNXQSL+21FXhCl/xfoIa1aeyH
         +2D+1VIwGKD5kxMG514Bs0uBI7JjonE+2E+UwyuGCj3TOhOAMFsdtSBt3mbZMgfi8coj
         7v7zkgLa3E75+OlJr7hTroTZhATSTrLkjcSkeT7IM5d+96KflgCVp0fMUnFHKqljN5LL
         +QraYCeuJO2BEt01wQww1RGy+LTpCtANgGZCFpdgrSiNOMCa8wKMeiuSQdrZ6Kwq7Wv5
         bR3A==
X-Gm-Message-State: AJIora8sljmhyH5aGmQkv+O51j5WU5+IdUV9YXMpd025cmrjTtXtitbz
        LOgGBNhwoK/T+TX+a1RoBh7MTYuHkgGuEw==
X-Google-Smtp-Source: AGRyM1uCj61qYBxSs2AhG+uKDRpRfZi0zyeTesNRyiVXmAMXseTVhRg0dGXq4mG2rXpY/rtE9MuZVg==
X-Received: by 2002:a05:6000:186e:b0:218:5f5d:9c55 with SMTP id d14-20020a056000186e00b002185f5d9c55mr3563392wri.128.1655371375989;
        Thu, 16 Jun 2022 02:22:55 -0700 (PDT)
Received: from 127.0.0.1localhost (188.28.125.106.threembb.co.uk. [188.28.125.106])
        by smtp.gmail.com with ESMTPSA id s6-20020a1cf206000000b0039c975aa553sm1695221wmc.25.2022.06.16.02.22.55
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 16 Jun 2022 02:22:55 -0700 (PDT)
From:   Pavel Begunkov <asml.silence@gmail.com>
To:     io-uring@vger.kernel.org
Cc:     Jens Axboe <axboe@kernel.dk>, asml.silence@gmail.com
Subject: [PATCH for-next v3 12/16] io_uring: add IORING_SETUP_SINGLE_ISSUER
Date:   Thu, 16 Jun 2022 10:22:08 +0100
Message-Id: <4bcc41ee467fdf04c8aab8baf6ce3ba21858c3d4.1655371007.git.asml.silence@gmail.com>
X-Mailer: git-send-email 2.36.1
In-Reply-To: <cover.1655371007.git.asml.silence@gmail.com>
References: <cover.1655371007.git.asml.silence@gmail.com>
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
index 1d176f935f5d..8715f0942ec2 100644
--- a/include/uapi/linux/io_uring.h
+++ b/include/uapi/linux/io_uring.h
@@ -137,9 +137,12 @@ enum {
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
index b2bd71cb2be6..1308a1f0c349 100644
--- a/io_uring/io_uring.c
+++ b/io_uring/io_uring.c
@@ -2469,6 +2469,8 @@ static __cold void io_ring_ctx_free(struct io_ring_ctx *ctx)
 	io_destroy_buffers(ctx);
 	if (ctx->sq_creds)
 		put_cred(ctx->sq_creds);
+	if (ctx->submitter_task)
+		put_task_struct(ctx->submitter_task);
 
 	/* there are no registered resources left, nobody uses it */
 	if (ctx->rsrc_node)
@@ -3201,7 +3203,7 @@ static int io_uring_install_fd(struct io_ring_ctx *ctx, struct file *file)
 	if (fd < 0)
 		return fd;
 
-	ret = io_uring_add_tctx_node(ctx);
+	ret = __io_uring_add_tctx_node(ctx, false);
 	if (ret) {
 		put_unused_fd(fd);
 		return ret;
@@ -3421,7 +3423,8 @@ static long io_uring_setup(u32 entries, struct io_uring_params __user *params)
 			IORING_SETUP_CLAMP | IORING_SETUP_ATTACH_WQ |
 			IORING_SETUP_R_DISABLED | IORING_SETUP_SUBMIT_ALL |
 			IORING_SETUP_COOP_TASKRUN | IORING_SETUP_TASKRUN_FLAG |
-			IORING_SETUP_SQE128 | IORING_SETUP_CQE32))
+			IORING_SETUP_SQE128 | IORING_SETUP_CQE32 |
+			IORING_SETUP_SINGLE_ISSUER))
 		return -EINVAL;
 
 	return io_uring_create(entries, &p, params);
diff --git a/io_uring/io_uring_types.h b/io_uring/io_uring_types.h
index 1f8db2dd7af7..8b00243abf65 100644
--- a/io_uring/io_uring_types.h
+++ b/io_uring/io_uring_types.h
@@ -243,6 +243,7 @@ struct io_ring_ctx {
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

