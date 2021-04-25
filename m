Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id C5F3936A78F
	for <lists+io-uring@lfdr.de>; Sun, 25 Apr 2021 15:32:49 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230238AbhDYNd2 (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Sun, 25 Apr 2021 09:33:28 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:57892 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229997AbhDYNd2 (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Sun, 25 Apr 2021 09:33:28 -0400
Received: from mail-wr1-x42a.google.com (mail-wr1-x42a.google.com [IPv6:2a00:1450:4864:20::42a])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 271D2C061756
        for <io-uring@vger.kernel.org>; Sun, 25 Apr 2021 06:32:47 -0700 (PDT)
Received: by mail-wr1-x42a.google.com with SMTP id e5so24403083wrg.7
        for <io-uring@vger.kernel.org>; Sun, 25 Apr 2021 06:32:47 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=y5ry5ZCEQKPQ4311QpKvMS+Z84DoM6EOvBGc5rOLRlY=;
        b=i08qJ0AkboGFCtVDWp3bmo4FAcbBEaFxiz2SkLs3jxMFCpiqa6V2uuDYrycxmdOyjK
         FUfPhDOaXnvY90AskjCMu3Vv1IIjIP2hkQfxXWD0Q92/sbCZr4Dt8JizmXWU4dG19lXa
         v1Qbl3ReyYij9pNOepuVIqbhFCanG1IrRWXbmZisMgIalVCqZIZS1jZ/Jo/r/vb4B28L
         jOopVFNrmfdGVlsajEJK8YZz7Zvxxp+RIMJoiIIPw47YB8mrzKy2xzTRwo0JlH9NtZTk
         NFjMxs2UeefYL0bLFpgOz1Uc3IQD/ILcFYzidwAUABFUkJPghUgisgQGOWAcgy2Sx8tl
         DQBw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=y5ry5ZCEQKPQ4311QpKvMS+Z84DoM6EOvBGc5rOLRlY=;
        b=H3ROUDO6QZ5hjSqNcuAs2fp9O7NxfX5oWaTqq8Rah26KiWw9NJtfYR8ND9Ro93klYg
         lFQYbK5KFUr+XiqR4iaEW9I+SASfuHvIOwhekpC5IdiNrA5xbbQHzqLbV0Ep4Toi1IKD
         ylvioLELLiprTWg1z9mBor+hAW+NpAw5C/JNblMACK9q6gbVkfICvtWsUvqGAiNBOmfj
         bYlNvSElWFXtTfulii9acXjqGPjgRkI0VLH5VSkjH7kmUlgMPZ0D9sYrhm5uVMjE0D4d
         tI3nNaarRjpb8LtqBihaMDfh5L9MBiSyBvFTK/sbNg4SUk+PSOyeVqvvdv0/iCkyxz6B
         8yuQ==
X-Gm-Message-State: AOAM533JJqfTfWiSbKIxmETNZBm5cBmt1IKDOE6IXn/bDdBvPdETerVJ
        dBEBCxxqUcPDlGGgRJhpRcE=
X-Google-Smtp-Source: ABdhPJyDG8OBApFypU2V6cPTpMHKRyTbQUcZeMbvwVhytwRAO8VFd+sHcITGUU+b4YE5PgC5uIP0hA==
X-Received: by 2002:a5d:4b8b:: with SMTP id b11mr16813985wrt.256.1619357565979;
        Sun, 25 Apr 2021 06:32:45 -0700 (PDT)
Received: from localhost.localdomain ([148.252.133.108])
        by smtp.gmail.com with ESMTPSA id a2sm16551552wrt.82.2021.04.25.06.32.45
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sun, 25 Apr 2021 06:32:45 -0700 (PDT)
From:   Pavel Begunkov <asml.silence@gmail.com>
To:     Jens Axboe <axboe@kernel.dk>, io-uring@vger.kernel.org
Cc:     Bijan Mottahedeh <bijan.mottahedeh@oracle.com>
Subject: [PATCH v2 11/12] io_uring: implement fixed buffers registration similar to fixed files
Date:   Sun, 25 Apr 2021 14:32:25 +0100
Message-Id: <17035f4f75319dc92962fce4fc04bc0afb5a68dc.1619356238.git.asml.silence@gmail.com>
X-Mailer: git-send-email 2.31.1
In-Reply-To: <cover.1619356238.git.asml.silence@gmail.com>
References: <cover.1619356238.git.asml.silence@gmail.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org

From: Bijan Mottahedeh <bijan.mottahedeh@oracle.com>

Apply fixed_rsrc functionality for fixed buffers support.

Signed-off-by: Bijan Mottahedeh <bijan.mottahedeh@oracle.com>
[rebase, remove multi-level tables, fix unregister on exit]
Signed-off-by: Pavel Begunkov <asml.silence@gmail.com>
---
 fs/io_uring.c | 71 ++++++++++++++++++++++++++++++++++++++++-----------
 1 file changed, 56 insertions(+), 15 deletions(-)

diff --git a/fs/io_uring.c b/fs/io_uring.c
index 083917bd7aa6..30f0563349db 100644
--- a/fs/io_uring.c
+++ b/fs/io_uring.c
@@ -218,6 +218,7 @@ struct io_rsrc_put {
 	union {
 		void *rsrc;
 		struct file *file;
+		struct io_mapped_ubuf *buf;
 	};
 };
 
@@ -404,6 +405,7 @@ struct io_ring_ctx {
 	unsigned		nr_user_files;
 
 	/* if used, fixed mapped user buffers */
+	struct io_rsrc_data	*buf_data;
 	unsigned		nr_user_bufs;
 	struct io_mapped_ubuf	**user_bufs;
 
@@ -5921,7 +5923,7 @@ static int io_req_prep(struct io_kiocb *req, const struct io_uring_sqe *sqe)
 
 	printk_once(KERN_WARNING "io_uring: unhandled opcode %d\n",
 			req->opcode);
-	return-EINVAL;
+	return -EINVAL;
 }
 
 static int io_req_prep_async(struct io_kiocb *req)
@@ -8105,19 +8107,36 @@ static void io_buffer_unmap(struct io_ring_ctx *ctx, struct io_mapped_ubuf **slo
 	*slot = NULL;
 }
 
-static int io_sqe_buffers_unregister(struct io_ring_ctx *ctx)
+static void io_rsrc_buf_put(struct io_ring_ctx *ctx, struct io_rsrc_put *prsrc)
 {
-	unsigned int i;
+	/* no updates yet, so not used */
+	WARN_ON_ONCE(1);
+}
 
-	if (!ctx->user_bufs)
-		return -ENXIO;
+static void __io_sqe_buffers_unregister(struct io_ring_ctx *ctx)
+{
+	unsigned int i;
 
 	for (i = 0; i < ctx->nr_user_bufs; i++)
 		io_buffer_unmap(ctx, &ctx->user_bufs[i]);
 	kfree(ctx->user_bufs);
+	kfree(ctx->buf_data);
 	ctx->user_bufs = NULL;
+	ctx->buf_data = NULL;
 	ctx->nr_user_bufs = 0;
-	return 0;
+}
+
+static int io_sqe_buffers_unregister(struct io_ring_ctx *ctx)
+{
+	int ret;
+
+	if (!ctx->buf_data)
+		return -ENXIO;
+
+	ret = io_rsrc_ref_quiesce(ctx->buf_data, ctx);
+	if (!ret)
+		__io_sqe_buffers_unregister(ctx);
+	return ret;
 }
 
 static int io_copy_iov(struct io_ring_ctx *ctx, struct iovec *dst,
@@ -8337,17 +8356,26 @@ static int io_buffer_validate(struct iovec *iov)
 static int io_sqe_buffers_register(struct io_ring_ctx *ctx, void __user *arg,
 				   unsigned int nr_args)
 {
+	struct page *last_hpage = NULL;
+	struct io_rsrc_data *data;
 	int i, ret;
 	struct iovec iov;
-	struct page *last_hpage = NULL;
 
 	if (ctx->user_bufs)
 		return -EBUSY;
 	if (!nr_args || nr_args > UIO_MAXIOV)
 		return -EINVAL;
-	ret = io_buffers_map_alloc(ctx, nr_args);
+	ret = io_rsrc_node_switch_start(ctx);
 	if (ret)
 		return ret;
+	data = io_rsrc_data_alloc(ctx, io_rsrc_buf_put, nr_args);
+	if (!data)
+		return -ENOMEM;
+	ret = io_buffers_map_alloc(ctx, nr_args);
+	if (ret) {
+		kfree(data);
+		return ret;
+	}
 
 	for (i = 0; i < nr_args; i++, ctx->nr_user_bufs++) {
 		ret = io_copy_iov(ctx, &iov, arg, i);
@@ -8363,9 +8391,13 @@ static int io_sqe_buffers_register(struct io_ring_ctx *ctx, void __user *arg,
 			break;
 	}
 
-	if (ret)
-		io_sqe_buffers_unregister(ctx);
+	WARN_ON_ONCE(ctx->buf_data);
 
+	ctx->buf_data = data;
+	if (ret)
+		__io_sqe_buffers_unregister(ctx);
+	else
+		io_rsrc_node_switch(ctx, NULL);
 	return ret;
 }
 
@@ -8440,10 +8472,18 @@ static void io_req_caches_free(struct io_ring_ctx *ctx)
 	mutex_unlock(&ctx->uring_lock);
 }
 
+static bool io_wait_rsrc_data(struct io_rsrc_data *data)
+{
+	if (!data)
+		return false;
+	if (!atomic_dec_and_test(&data->refs))
+		wait_for_completion(&data->done);
+	return true;
+}
+
 static void io_ring_ctx_free(struct io_ring_ctx *ctx)
 {
 	io_sq_thread_finish(ctx);
-	io_sqe_buffers_unregister(ctx);
 
 	if (ctx->mm_account) {
 		mmdrop(ctx->mm_account);
@@ -8451,11 +8491,10 @@ static void io_ring_ctx_free(struct io_ring_ctx *ctx)
 	}
 
 	mutex_lock(&ctx->uring_lock);
-	if (ctx->file_data) {
-		if (!atomic_dec_and_test(&ctx->file_data->refs))
-			wait_for_completion(&ctx->file_data->done);
+	if (io_wait_rsrc_data(ctx->buf_data))
+		__io_sqe_buffers_unregister(ctx);
+	if (io_wait_rsrc_data(ctx->file_data))
 		__io_sqe_files_unregister(ctx);
-	}
 	if (ctx->rings)
 		__io_cqring_overflow_flush(ctx, true);
 	mutex_unlock(&ctx->uring_lock);
@@ -9782,6 +9821,8 @@ static int io_register_rsrc(struct io_ring_ctx *ctx, void __user *arg,
 static bool io_register_op_must_quiesce(int op)
 {
 	switch (op) {
+	case IORING_REGISTER_BUFFERS:
+	case IORING_UNREGISTER_BUFFERS:
 	case IORING_REGISTER_FILES:
 	case IORING_UNREGISTER_FILES:
 	case IORING_REGISTER_FILES_UPDATE:
-- 
2.31.1

