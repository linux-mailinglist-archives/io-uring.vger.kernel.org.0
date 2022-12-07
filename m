Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id E775F6452BB
	for <lists+io-uring@lfdr.de>; Wed,  7 Dec 2022 04:54:47 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229832AbiLGDyp (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Tue, 6 Dec 2022 22:54:45 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:41744 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229842AbiLGDym (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Tue, 6 Dec 2022 22:54:42 -0500
Received: from mail-ej1-x62b.google.com (mail-ej1-x62b.google.com [IPv6:2a00:1450:4864:20::62b])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 909A152170
        for <io-uring@vger.kernel.org>; Tue,  6 Dec 2022 19:54:41 -0800 (PST)
Received: by mail-ej1-x62b.google.com with SMTP id b2so11029618eja.7
        for <io-uring@vger.kernel.org>; Tue, 06 Dec 2022 19:54:41 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=1dAS4NoPFKX7V/NJNTiJJVwYipVppvXjw+VoTzli/nA=;
        b=logkz+rQdHGzgGba8RsimyabzGJ4VfPvKMFC+rDc4KuotpES7UCVRKWVgmwrbzOphI
         STfH2QaEL7yUx924Lali1K+tT6WPoO5paw4wmXPa5To8YvrT+Irk8aFOw3vEPy1rEq77
         AtfwJIannntZkwbDHWFtozPdU62BMiaxOtOvOHXPUZv52Z+SAzYmbycd6KcaT4v4+Y0O
         RNzqKHuCisqyGF2oHiZ54Wq+ufkmQgJ8d9uPQWKaTeF/Hiri6gmBXudtmIwBu51cH187
         jnwoWe7dL4Mqy74runmVo0dZj/ao5poLMINkahjfIgPiuGgdLxySied8LqZ7jVOdnNzy
         Bb1g==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=1dAS4NoPFKX7V/NJNTiJJVwYipVppvXjw+VoTzli/nA=;
        b=R9ha+0ZlmzRmHdq4pJw7kUvNCg8FZj+vqX/rIvDlLcp8VMsZjJEm/dYCwN+QrbDc7V
         dEHsdQ8TyKqRrUR1c8k7UtCXDjvKB4tzbZQpUW3AaHWw8C2VWOWiZ0LYtuKVIs7tcxoj
         FLA12mKmfSHCdKG+R6V76jzIW/d7QkVkuuDV8QSXMydfUsFtcrxe06pjRAkcfLNhQpee
         g7nB0AREinydE160RLtTTQgjqgAO31FfxmDLLuGbZwhkg+TmlzsgBEGxlhPvbRat6c2a
         ED2cHFb9JPU64oKczBS8LCspZbjVKBooi9pRoju3eTuehLnGfDjsZkPqnSijYDBQ23s4
         o4eg==
X-Gm-Message-State: ANoB5plM7LDaKjeJFYFiMkT/G9OvYO5ICY8ydcxZpuLRfuNob1SrGpGB
        OguOOjQbx4h/7cRhtpyChhCg0WP64Fo=
X-Google-Smtp-Source: AA0mqf6eE4NKoXSX9/6GjHtGFti2+Vv5ig137VcgOoCZUWGZvZNLqZ/SoOpzTZQzIJZZutSPHmZuRA==
X-Received: by 2002:a17:906:404:b0:781:f54c:1947 with SMTP id d4-20020a170906040400b00781f54c1947mr64030473eja.69.1670385279982;
        Tue, 06 Dec 2022 19:54:39 -0800 (PST)
Received: from 127.0.0.1localhost (94.196.241.58.threembb.co.uk. [94.196.241.58])
        by smtp.gmail.com with ESMTPSA id 9-20020a170906210900b0073de0506745sm7938939ejt.197.2022.12.06.19.54.39
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 06 Dec 2022 19:54:39 -0800 (PST)
From:   Pavel Begunkov <asml.silence@gmail.com>
To:     io-uring@vger.kernel.org
Cc:     Jens Axboe <axboe@kernel.dk>, asml.silence@gmail.com
Subject: [PATCH for-next v2 09/12] io_uring: get rid of double locking
Date:   Wed,  7 Dec 2022 03:53:34 +0000
Message-Id: <a80ecc2bc99c3b3f2cf20015d618b7c51419a797.1670384893.git.asml.silence@gmail.com>
X-Mailer: git-send-email 2.38.1
In-Reply-To: <cover.1670384893.git.asml.silence@gmail.com>
References: <cover.1670384893.git.asml.silence@gmail.com>
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

We don't need to take both uring_locks at once, msg_ring can be split in
two parts, first getting a file from the filetable of the first ring and
then installing it into the second one.

Signed-off-by: Pavel Begunkov <asml.silence@gmail.com>
---
 io_uring/msg_ring.c | 85 ++++++++++++++++++++++++++-------------------
 io_uring/msg_ring.h |  1 +
 io_uring/opdef.c    |  1 +
 3 files changed, 51 insertions(+), 36 deletions(-)

diff --git a/io_uring/msg_ring.c b/io_uring/msg_ring.c
index c7d6586164ca..387c45a58654 100644
--- a/io_uring/msg_ring.c
+++ b/io_uring/msg_ring.c
@@ -15,6 +15,7 @@
 
 struct io_msg {
 	struct file			*file;
+	struct file			*src_file;
 	u64 user_data;
 	u32 len;
 	u32 cmd;
@@ -23,6 +24,17 @@ struct io_msg {
 	u32 flags;
 };
 
+void io_msg_ring_cleanup(struct io_kiocb *req)
+{
+	struct io_msg *msg = io_kiocb_to_cmd(req, struct io_msg);
+
+	if (WARN_ON_ONCE(!msg->src_file))
+		return;
+
+	fput(msg->src_file);
+	msg->src_file = NULL;
+}
+
 static int io_msg_ring_data(struct io_kiocb *req)
 {
 	struct io_ring_ctx *target_ctx = req->file->private_data;
@@ -37,17 +49,13 @@ static int io_msg_ring_data(struct io_kiocb *req)
 	return -EOVERFLOW;
 }
 
-static void io_double_unlock_ctx(struct io_ring_ctx *ctx,
-				 struct io_ring_ctx *octx,
+static void io_double_unlock_ctx(struct io_ring_ctx *octx,
 				 unsigned int issue_flags)
 {
-	if (issue_flags & IO_URING_F_UNLOCKED)
-		mutex_unlock(&ctx->uring_lock);
 	mutex_unlock(&octx->uring_lock);
 }
 
-static int io_double_lock_ctx(struct io_ring_ctx *ctx,
-			      struct io_ring_ctx *octx,
+static int io_double_lock_ctx(struct io_ring_ctx *octx,
 			      unsigned int issue_flags)
 {
 	/*
@@ -60,17 +68,28 @@ static int io_double_lock_ctx(struct io_ring_ctx *ctx,
 			return -EAGAIN;
 		return 0;
 	}
+	mutex_lock(&octx->uring_lock);
+	return 0;
+}
 
-	/* Always grab smallest value ctx first. We know ctx != octx. */
-	if (ctx < octx) {
-		mutex_lock(&ctx->uring_lock);
-		mutex_lock(&octx->uring_lock);
-	} else {
-		mutex_lock(&octx->uring_lock);
-		mutex_lock(&ctx->uring_lock);
+static struct file *io_msg_grab_file(struct io_kiocb *req, unsigned int issue_flags)
+{
+	struct io_msg *msg = io_kiocb_to_cmd(req, struct io_msg);
+	struct io_ring_ctx *ctx = req->ctx;
+	struct file *file = NULL;
+	unsigned long file_ptr;
+	int idx = msg->src_fd;
+
+	io_ring_submit_lock(ctx, issue_flags);
+	if (likely(idx < ctx->nr_user_files)) {
+		idx = array_index_nospec(idx, ctx->nr_user_files);
+		file_ptr = io_fixed_file_slot(&ctx->file_table, idx)->file_ptr;
+		file = (struct file *) (file_ptr & FFS_MASK);
+		if (file)
+			get_file(file);
 	}
-
-	return 0;
+	io_ring_submit_unlock(ctx, issue_flags);
+	return file;
 }
 
 static int io_msg_send_fd(struct io_kiocb *req, unsigned int issue_flags)
@@ -78,34 +97,27 @@ static int io_msg_send_fd(struct io_kiocb *req, unsigned int issue_flags)
 	struct io_ring_ctx *target_ctx = req->file->private_data;
 	struct io_msg *msg = io_kiocb_to_cmd(req, struct io_msg);
 	struct io_ring_ctx *ctx = req->ctx;
-	unsigned long file_ptr;
-	struct file *src_file;
+	struct file *src_file = msg->src_file;
 	int ret;
 
 	if (target_ctx == ctx)
 		return -EINVAL;
+	if (!src_file) {
+		src_file = io_msg_grab_file(req, issue_flags);
+		if (!src_file)
+			return -EBADF;
+		msg->src_file = src_file;
+		req->flags |= REQ_F_NEED_CLEANUP;
+	}
 
-	ret = io_double_lock_ctx(ctx, target_ctx, issue_flags);
-	if (unlikely(ret))
-		return ret;
-
-	ret = -EBADF;
-	if (unlikely(msg->src_fd >= ctx->nr_user_files))
-		goto out_unlock;
-
-	msg->src_fd = array_index_nospec(msg->src_fd, ctx->nr_user_files);
-	file_ptr = io_fixed_file_slot(&ctx->file_table, msg->src_fd)->file_ptr;
-	if (!file_ptr)
-		goto out_unlock;
-
-	src_file = (struct file *) (file_ptr & FFS_MASK);
-	get_file(src_file);
+	if (unlikely(io_double_lock_ctx(target_ctx, issue_flags)))
+		return -EAGAIN;
 
 	ret = __io_fixed_fd_install(target_ctx, src_file, msg->dst_fd);
-	if (ret < 0) {
-		fput(src_file);
+	if (ret < 0)
 		goto out_unlock;
-	}
+	msg->src_file = NULL;
+	req->flags &= ~REQ_F_NEED_CLEANUP;
 
 	if (msg->flags & IORING_MSG_RING_CQE_SKIP)
 		goto out_unlock;
@@ -119,7 +131,7 @@ static int io_msg_send_fd(struct io_kiocb *req, unsigned int issue_flags)
 	if (!io_post_aux_cqe(target_ctx, msg->user_data, msg->len, 0))
 		ret = -EOVERFLOW;
 out_unlock:
-	io_double_unlock_ctx(ctx, target_ctx, issue_flags);
+	io_double_unlock_ctx(target_ctx, issue_flags);
 	return ret;
 }
 
@@ -130,6 +142,7 @@ int io_msg_ring_prep(struct io_kiocb *req, const struct io_uring_sqe *sqe)
 	if (unlikely(sqe->buf_index || sqe->personality))
 		return -EINVAL;
 
+	msg->src_file = NULL;
 	msg->user_data = READ_ONCE(sqe->off);
 	msg->len = READ_ONCE(sqe->len);
 	msg->cmd = READ_ONCE(sqe->addr);
diff --git a/io_uring/msg_ring.h b/io_uring/msg_ring.h
index fb9601f202d0..3987ee6c0e5f 100644
--- a/io_uring/msg_ring.h
+++ b/io_uring/msg_ring.h
@@ -2,3 +2,4 @@
 
 int io_msg_ring_prep(struct io_kiocb *req, const struct io_uring_sqe *sqe);
 int io_msg_ring(struct io_kiocb *req, unsigned int issue_flags);
+void io_msg_ring_cleanup(struct io_kiocb *req);
diff --git a/io_uring/opdef.c b/io_uring/opdef.c
index 04dd2c983fce..3aa0d65c50e3 100644
--- a/io_uring/opdef.c
+++ b/io_uring/opdef.c
@@ -445,6 +445,7 @@ const struct io_op_def io_op_defs[] = {
 		.name			= "MSG_RING",
 		.prep			= io_msg_ring_prep,
 		.issue			= io_msg_ring,
+		.cleanup		= io_msg_ring_cleanup,
 	},
 	[IORING_OP_FSETXATTR] = {
 		.needs_file = 1,
-- 
2.38.1

