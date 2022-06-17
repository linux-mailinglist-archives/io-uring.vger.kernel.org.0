Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id B721254F876
	for <lists+io-uring@lfdr.de>; Fri, 17 Jun 2022 15:46:24 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233691AbiFQNpP (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Fri, 17 Jun 2022 09:45:15 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:54158 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1382256AbiFQNpO (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Fri, 17 Jun 2022 09:45:14 -0400
Received: from mail-pj1-x102b.google.com (mail-pj1-x102b.google.com [IPv6:2607:f8b0:4864:20::102b])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 236132A424
        for <io-uring@vger.kernel.org>; Fri, 17 Jun 2022 06:45:14 -0700 (PDT)
Received: by mail-pj1-x102b.google.com with SMTP id d14so882309pjs.3
        for <io-uring@vger.kernel.org>; Fri, 17 Jun 2022 06:45:14 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernel-dk.20210112.gappssmtp.com; s=20210112;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=foN1vSqyO+jcdalea1XeRJvRQO2tNOlHRMFuTFVF5Lc=;
        b=ajGUKHs/h4C06TmJDWovsu3tkIl7781dMgygEW4fkBmJVClwS0rp86jJYuCxufD24l
         ZKI+hfhQKPq1vbuuY6VT3T6yu103A+N3BrEVuCaKwpO9pYyik9ohrZCVZkfRYopPbAFF
         O4gon6OOG4f/KUryzz/+YEnq5fwCXZpCazRwF+xWBqbw62AhKL6U0JwsZ8gDebh52K3w
         +wCxjvJGhtKh44KlhFx8RClJdxX7L+nksOyeclECfqhwGy664mKAZlrHc7ttbZQXRUb2
         boaRWiTkfl95H2jhPohp9nAUZxC60rJ7agmqHPAm4C8MSIaBpPtVH/XkeXJkYNahEBfH
         yQSQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=foN1vSqyO+jcdalea1XeRJvRQO2tNOlHRMFuTFVF5Lc=;
        b=UQmhI7Fr2lTdDolzA5SKtASuKGCSkC3i7Gm6owt8y9OndU31HwojvMloAc9YwCeZay
         FOz/IGs6NyrL+317tFUAIwApw11xHkcFZrpRVME4Jky4yB05J3yIHxKyjm+5mcnQtQoj
         q5UP4CPqYgM9MV+lPDNhtkHgdb5Uwy7rQMvjwNlUFqamy1HGTFw4o2DJ50YwiMIIfR7a
         C2G2fbEwQf6aZnTgKx0ZRSaOfPPqD/7X4bQ5HQGi01WMh47QfxdHSK3j2ya/9aAjFkeI
         4h+U/xfgAHiA3VfQulOkbNm5En1m3MV6CuiiokwK4LOTrrc3dRIgqJ91waLkGPjPixy1
         Bx2Q==
X-Gm-Message-State: AJIora+OfUpOjQDIxD4EGCqCaDjVJfQluqb8uCto17IspHYh+eon5Smf
        RFr8cyg6g2hflyl2F7yrutM3UG+1gsR75w==
X-Google-Smtp-Source: AGRyM1v6DzC+o4SL134rYoHj2tb3Bnk5cz85klw31z7GZZYmC86P3D1ZthMlzrPFgR2laPCutd5+bw==
X-Received: by 2002:a17:902:c951:b0:163:ed13:7acd with SMTP id i17-20020a170902c95100b00163ed137acdmr9679426pla.51.1655473513200;
        Fri, 17 Jun 2022 06:45:13 -0700 (PDT)
Received: from localhost.localdomain ([198.8.77.157])
        by smtp.gmail.com with ESMTPSA id t13-20020a1709027fcd00b0016392bd5060sm2214075plb.142.2022.06.17.06.45.11
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 17 Jun 2022 06:45:12 -0700 (PDT)
From:   Jens Axboe <axboe@kernel.dk>
To:     io-uring@vger.kernel.org
Cc:     asml.silence@gmail.com, Jens Axboe <axboe@kernel.dk>
Subject: [PATCH 2/2] io_uring: add support for passing fixed file descriptors
Date:   Fri, 17 Jun 2022 07:45:04 -0600
Message-Id: <20220617134504.368706-3-axboe@kernel.dk>
X-Mailer: git-send-email 2.35.1
In-Reply-To: <20220617134504.368706-1-axboe@kernel.dk>
References: <20220617134504.368706-1-axboe@kernel.dk>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-1.9 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS,
        T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org

With IORING_OP_MSG_RING, one ring can send a message to another ring.
Extend that support to also allow sending a fixed file descriptor to
that ring, enabling one ring to pass a registered descriptor to another
one.

Arguments are extended to pass in:

sqe->addr3	fixed file slot in source ring
sqe->file_index	fixed file slot in destination ring

IORING_OP_MSG_RING is extended to take a command argument in sqe->addr.
If set to zero (or IORING_MSG_DATA), it sends just a message like before.
If set to IORING_MSG_SEND_FD, a fixed file descriptor is sent according
to the above arguments.

Undecided:
	- Should we post a cqe with the send, or require that the sender
	  just link a separate IORING_OP_MSG_RING? This makes error
	  handling easier, as we cannot easily retract the installed
	  file descriptor if the target CQ ring is full. Right now we do
	  fill a CQE. If the request completes with -EOVERFLOW, then the
	  sender must re-send a CQE if the target must get notified.

	- Add an IORING_MSG_MOVE_FD which moves the descriptor, removing
	  it from the source ring when installed in the target? Again
	  error handling is difficult.

Signed-off-by: Jens Axboe <axboe@kernel.dk>
---
 include/uapi/linux/io_uring.h |   8 +++
 io_uring/msg_ring.c           | 122 ++++++++++++++++++++++++++++++++--
 2 files changed, 123 insertions(+), 7 deletions(-)

diff --git a/include/uapi/linux/io_uring.h b/include/uapi/linux/io_uring.h
index 8715f0942ec2..dbdaeef3ea89 100644
--- a/include/uapi/linux/io_uring.h
+++ b/include/uapi/linux/io_uring.h
@@ -264,6 +264,14 @@ enum io_uring_op {
  */
 #define IORING_ACCEPT_MULTISHOT	(1U << 0)
 
+/*
+ * IORING_OP_MSG_RING command types, stored in sqe->addr
+ */
+enum {
+	IORING_MSG_DATA,	/* pass sqe->len as 'res' and off as user_data */
+	IORING_MSG_SEND_FD,	/* send a registered fd to another ring */
+};
+
 /*
  * IO completion data structure (Completion Queue Entry)
  */
diff --git a/io_uring/msg_ring.c b/io_uring/msg_ring.c
index b02be2349652..e9d6fb25d141 100644
--- a/io_uring/msg_ring.c
+++ b/io_uring/msg_ring.c
@@ -3,46 +3,154 @@
 #include <linux/errno.h>
 #include <linux/file.h>
 #include <linux/slab.h>
+#include <linux/nospec.h>
 #include <linux/io_uring.h>
 
 #include <uapi/linux/io_uring.h>
 
 #include "io_uring.h"
+#include "rsrc.h"
+#include "filetable.h"
 #include "msg_ring.h"
 
 struct io_msg {
 	struct file			*file;
 	u64 user_data;
 	u32 len;
+	u32 cmd;
+	u32 src_fd;
+	u32 dst_fd;
 };
 
+static int io_msg_ring_data(struct io_kiocb *req)
+{
+	struct io_ring_ctx *target_ctx = req->file->private_data;
+	struct io_msg *msg = io_kiocb_to_cmd(req);
+
+	if (msg->src_fd || msg->dst_fd)
+		return -EINVAL;
+
+	if (io_post_aux_cqe(target_ctx, msg->user_data, msg->len, 0))
+		return 0;
+
+	return -EOVERFLOW;
+}
+
+static void io_double_unlock_ctx(struct io_ring_ctx *ctx,
+				 struct io_ring_ctx *octx,
+				 unsigned int issue_flags)
+{
+	if (issue_flags & IO_URING_F_UNLOCKED)
+		mutex_unlock(&ctx->uring_lock);
+	mutex_unlock(&octx->uring_lock);
+}
+
+static int io_double_lock_ctx(struct io_ring_ctx *ctx,
+			      struct io_ring_ctx *octx,
+			      unsigned int issue_flags)
+{
+	/*
+	 * To ensure proper ordering between the two ctxs, we can only
+	 * attempt a trylock on the target. If that fails and we already have
+	 * the source ctx lock, punt to io-wq.
+	 */
+	if (!(issue_flags & IO_URING_F_UNLOCKED)) {
+		if (!mutex_trylock(&octx->uring_lock))
+			return -EAGAIN;
+		return 0;
+	}
+
+	/* Always grab smallest value ctx first. */
+	if (ctx < octx) {
+		mutex_lock(&ctx->uring_lock);
+		mutex_lock(&octx->uring_lock);
+	} else if (ctx > octx) {
+		mutex_lock(&octx->uring_lock);
+		mutex_lock(&ctx->uring_lock);
+	}
+
+	return 0;
+}
+
+static int io_msg_send_fd(struct io_kiocb *req, unsigned int issue_flags)
+{
+	struct io_ring_ctx *target_ctx = req->file->private_data;
+	struct io_msg *msg = io_kiocb_to_cmd(req);
+	struct io_ring_ctx *ctx = req->ctx;
+	unsigned long file_ptr;
+	struct file *src_file;
+	int ret;
+
+	if (target_ctx == ctx)
+		return -EINVAL;
+
+	ret = io_double_lock_ctx(ctx, target_ctx, issue_flags);
+	if (unlikely(ret))
+		return ret;
+
+	ret = -EBADF;
+	if (unlikely(msg->src_fd >= ctx->nr_user_files))
+		goto err_unlock;
+
+	msg->src_fd = array_index_nospec(msg->src_fd, ctx->nr_user_files);
+	file_ptr = io_fixed_file_slot(&ctx->file_table, msg->src_fd)->file_ptr;
+	src_file = (struct file *) (file_ptr & FFS_MASK);
+	get_file(src_file);
+
+	ret = __io_fixed_fd_install(target_ctx, src_file, msg->dst_fd);
+	if (ret < 0) {
+		fput(src_file);
+		goto err_unlock;
+	}
+
+	/*
+	 * If this fails, the target still received the file descriptor but
+	 * wasn't notified of the fact. This means that if this request
+	 * completes with -EOVERFLOW, then the sender must ensure that a
+	 * later IORING_OP_MSG_RING delivers the message.
+	 */
+	if (!io_post_aux_cqe(target_ctx, msg->user_data, msg->len, 0))
+		ret = -EOVERFLOW;
+err_unlock:
+	io_double_unlock_ctx(ctx, target_ctx, issue_flags);
+	return ret;
+}
+
 int io_msg_ring_prep(struct io_kiocb *req, const struct io_uring_sqe *sqe)
 {
 	struct io_msg *msg = io_kiocb_to_cmd(req);
 
-	if (unlikely(sqe->addr || sqe->rw_flags || sqe->splice_fd_in ||
-		     sqe->buf_index || sqe->personality))
+	if (unlikely(sqe->rw_flags || sqe->buf_index || sqe->personality))
 		return -EINVAL;
 
 	msg->user_data = READ_ONCE(sqe->off);
 	msg->len = READ_ONCE(sqe->len);
+	msg->cmd = READ_ONCE(sqe->addr);
+	msg->src_fd = READ_ONCE(sqe->addr3);
+	msg->dst_fd = READ_ONCE(sqe->file_index);
 	return 0;
 }
 
 int io_msg_ring(struct io_kiocb *req, unsigned int issue_flags)
 {
 	struct io_msg *msg = io_kiocb_to_cmd(req);
-	struct io_ring_ctx *target_ctx;
 	int ret;
 
 	ret = -EBADFD;
 	if (!io_is_uring_fops(req->file))
 		goto done;
 
-	ret = -EOVERFLOW;
-	target_ctx = req->file->private_data;
-	if (io_post_aux_cqe(target_ctx, msg->user_data, msg->len, 0))
-		ret = 0;
+	switch (msg->cmd) {
+	case IORING_MSG_DATA:
+		ret = io_msg_ring_data(req);
+		break;
+	case IORING_MSG_SEND_FD:
+		ret = io_msg_send_fd(req, issue_flags);
+		break;
+	default:
+		ret = -EINVAL;
+		break;
+	}
 
 done:
 	if (ret < 0)
-- 
2.35.1

