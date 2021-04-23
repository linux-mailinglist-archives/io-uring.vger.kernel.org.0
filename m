Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id AAF2E3689B8
	for <lists+io-uring@lfdr.de>; Fri, 23 Apr 2021 02:19:55 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S237141AbhDWAUZ (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Thu, 22 Apr 2021 20:20:25 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:53782 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S236068AbhDWAUZ (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Thu, 22 Apr 2021 20:20:25 -0400
Received: from mail-wr1-x42d.google.com (mail-wr1-x42d.google.com [IPv6:2a00:1450:4864:20::42d])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 2713EC06174A
        for <io-uring@vger.kernel.org>; Thu, 22 Apr 2021 17:19:48 -0700 (PDT)
Received: by mail-wr1-x42d.google.com with SMTP id p6so39873790wrn.9
        for <io-uring@vger.kernel.org>; Thu, 22 Apr 2021 17:19:48 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=srpJ1PyXuVMJmdNAMSQK+CBmugVoC8i95/hakaBVJCk=;
        b=AZe8GevmIlBvYlXgksdSuVZyHAqbx2gW+v/+Fql/CernBVQon9ClfT1c7imuOEPIrS
         yGPXFbYGpbSg6HBrnjEoO2emMryvR9HiK886htGawArbuCpR+pT99r7W6jAi+nQtS1Y8
         aHqNPithJoZ9MvYH1dQ/C3VsRPngN/qVgU4uqIHWOocCm8Zk0RIanlNGboNaTss/jcz0
         LBCz7qcZ0e/30KAlkLumMGfRQ4ySHAUo9wuOcq+NbF2y8PK8IaqlBdK6s8mW3p88cIhi
         DPOHYagQ4BKTbE6NVSoO1G54NxZGvY6vRh1CqwS71msg3WSUgtMGTGVWJeZjXk3qYGNT
         oeow==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=srpJ1PyXuVMJmdNAMSQK+CBmugVoC8i95/hakaBVJCk=;
        b=jtwJgcOh1lpxNh5AbllqpmD47GdaE1XnSsmpoGM+8gT7qnRYxGiln+U3E2A0a3Vpom
         /pxykeTdh7mUBolzza8l2UjtNJTwjsiYLK5mSLZjBisTJmGcDIqynndYReJLdM6Vy5TN
         wBluDJX2IVYeDcuGclvUYFZ30yMMpu9BmYQVfK/1NJlcRK7xWX93tKrmmYqxRUDvj1Hf
         3TpIrZFziFYSvubOTv8sot/oReLcSVfuzuVvkP7SbKarXCR4U39pz4VIi/XF5t7y8vhx
         JqiB6svtqayh/sYceq7zJEAiIm6SCUhgIpB3VpzLW3RFBt89L5QmMepqhFsO0Rqdfqwg
         DBfQ==
X-Gm-Message-State: AOAM531ps7bsO4fX2F9k7W7C4dmoUua7xwWZTarWiCjccK3R/agMLt2n
        XyxWWIHbJfv7Kov8QhwkuJI=
X-Google-Smtp-Source: ABdhPJxtBbqcH3JcNeZ2u2gH/qZqlrlqUE6J6AU0b+bJ87s1tWIqppmKfAHnYrtwoIYqDshtXJXBuQ==
X-Received: by 2002:a5d:4488:: with SMTP id j8mr1072506wrq.83.1619137186945;
        Thu, 22 Apr 2021 17:19:46 -0700 (PDT)
Received: from localhost.localdomain ([148.252.128.225])
        by smtp.gmail.com with ESMTPSA id g12sm6369605wru.47.2021.04.22.17.19.46
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 22 Apr 2021 17:19:46 -0700 (PDT)
From:   Pavel Begunkov <asml.silence@gmail.com>
To:     Jens Axboe <axboe@kernel.dk>, io-uring@vger.kernel.org
Cc:     Bijan Mottahedeh <bijan.mottahedeh@oracle.com>
Subject: [PATCH 10/11] io_uring: implement fixed buffers registration similar to fixed files
Date:   Fri, 23 Apr 2021 01:19:27 +0100
Message-Id: <763249b4553e73f822b318640bcd67fc6ddb99f4.1619128798.git.asml.silence@gmail.com>
X-Mailer: git-send-email 2.31.1
In-Reply-To: <cover.1619128798.git.asml.silence@gmail.com>
References: <cover.1619128798.git.asml.silence@gmail.com>
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
index c80b5fef159d..0e938c87d6db 100644
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
 	struct io_mapped_ubuf	*user_bufs;
 
@@ -5911,7 +5913,7 @@ static int io_req_prep(struct io_kiocb *req, const struct io_uring_sqe *sqe)
 
 	printk_once(KERN_WARNING "io_uring: unhandled opcode %d\n",
 			req->opcode);
-	return-EINVAL;
+	return -EINVAL;
 }
 
 static int io_req_prep_async(struct io_kiocb *req)
@@ -8097,19 +8099,36 @@ static void io_buffer_unmap(struct io_ring_ctx *ctx, struct io_mapped_ubuf *imu)
 	imu->nr_bvecs = 0;
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
@@ -8327,17 +8346,26 @@ static int io_buffer_validate(struct iovec *iov)
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
 		struct io_mapped_ubuf *imu = &ctx->user_bufs[i];
@@ -8353,9 +8381,13 @@ static int io_sqe_buffers_register(struct io_ring_ctx *ctx, void __user *arg,
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
 
@@ -8430,10 +8462,18 @@ static void io_req_caches_free(struct io_ring_ctx *ctx)
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
@@ -8441,11 +8481,10 @@ static void io_ring_ctx_free(struct io_ring_ctx *ctx)
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
@@ -9769,6 +9808,8 @@ static int io_register_rsrc(struct io_ring_ctx *ctx, void __user *arg,
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

