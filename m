Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 1073F556EEA
	for <lists+io-uring@lfdr.de>; Thu, 23 Jun 2022 01:16:40 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234047AbiFVXQT (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Wed, 22 Jun 2022 19:16:19 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:34330 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1358418AbiFVXQS (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Wed, 22 Jun 2022 19:16:18 -0400
Received: from mail-pf1-x42e.google.com (mail-pf1-x42e.google.com [IPv6:2607:f8b0:4864:20::42e])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 654E941F9A
        for <io-uring@vger.kernel.org>; Wed, 22 Jun 2022 16:16:17 -0700 (PDT)
Received: by mail-pf1-x42e.google.com with SMTP id d17so8460947pfq.9
        for <io-uring@vger.kernel.org>; Wed, 22 Jun 2022 16:16:17 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernel-dk.20210112.gappssmtp.com; s=20210112;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=IVhYLA++CI2NZr1wuP4YODcUVvCchVXJmhT/DHeM2tU=;
        b=bE3LNM8mjfIuESuZSokusucqj84plNRxXuIe8mog3AA5/gou+zMc2O9slQaz3OiflR
         /HTkNKQ39aschVGWo8imqCtws4CzYpEQE0+xXhmhV0n/utsS90YnTTEcE2ntuBFZdKhV
         cCrWsxO6TB19XN7UntA8As20E4ERmKD2PvUWaDGhsCADFnu1NylYfRZSqmDaaH00GFae
         +66+eyB4eFYKXV1M4DNfiEz+mzXNv6yH0j+s3HB0sdmiSVTXL8bVPa+MFuu9vEeksPvQ
         lZPsvY9JsVxII3bE020Y629niyQO91McOSd5B1K6WUVNlPSchNoLENlKkno5gmy+0jfX
         S76w==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=IVhYLA++CI2NZr1wuP4YODcUVvCchVXJmhT/DHeM2tU=;
        b=z0gP5v4/RB6gN++noHeiWD24hp9rZb9ca/SU8uOJYHhmfs24hea+Zcp7o2IZyDrhPA
         1XBsVERYlaa4xyztlEGQkRBZAn1m+X4EjFOBG/UiaPujUD0lQdryJTmhJBmjt+lIt9x4
         Yv+dxlnsO2mjqk9aIE6OUmpFV7XkdkpHS++vHKKyr+YsFkWEVVYbd97wra+tSVfF5DEe
         Cl1RFnd8N3Iir3dahHFeYf6eQnb2+7i2Rn/5Fodq6gHorEP9jd0PwzkeZaFOuI0fms6E
         pOzy6G6hEputCHTBnkHmQOu898ZCaT4B35vV/6085XoMb+UMUS+eF+OM21nolmqTCTZ7
         CSSQ==
X-Gm-Message-State: AJIora8rrFHWHk3zphjGTZulHlTSP3fC2QxTgEzYVwME+4Nu61YXROzQ
        Yn18XgnXeXoIQn7j5JfAJSqB3zQ6L5I60g==
X-Google-Smtp-Source: AGRyM1uroM3odinvz5FlInp4PxKOOLL5g0lYVaQywhAA9rf6ZzDjIOG96HkwQ7d2+mdhXaPCWhG2Sg==
X-Received: by 2002:a63:3c58:0:b0:40c:83b6:1a4e with SMTP id i24-20020a633c58000000b0040c83b61a4emr5088224pgn.194.1655939776649;
        Wed, 22 Jun 2022 16:16:16 -0700 (PDT)
Received: from localhost.localdomain ([198.8.77.157])
        by smtp.gmail.com with ESMTPSA id d2-20020a056a00198200b0051b9ecb53e6sm13947437pfl.105.2022.06.22.16.16.15
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 22 Jun 2022 16:16:16 -0700 (PDT)
From:   Jens Axboe <axboe@kernel.dk>
To:     io-uring@vger.kernel.org
Cc:     asml.silence@gmail.com, carter.li@eoitek.com, hao.xu@linux.dev,
        Jens Axboe <axboe@kernel.dk>
Subject: [PATCH 2/2] io_uring: add support for passing fixed file descriptors
Date:   Wed, 22 Jun 2022 17:16:11 -0600
Message-Id: <20220622231611.178300-3-axboe@kernel.dk>
X-Mailer: git-send-email 2.35.1
In-Reply-To: <20220622231611.178300-1-axboe@kernel.dk>
References: <20220622231611.178300-1-axboe@kernel.dk>
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

Two common use cases for this are:

1) Server needs to be shutdown or restarted, pass file descriptors to
   another onei

2) Backend is split, and one accepts connections, while others then get
  the fd passed and handle the actual connection.

Both of those are classic SCM_RIGHTS use cases, and it's not possible to
support them with direct descriptors today.

By default, this will post a CQE to the target ring, similarly to how
IORING_MSG_DATA does it. If IORING_MSG_RING_CQE_SKIP is set, no message
is posted to the target ring. The issuer is expected to notify the
receiver side separately.

Signed-off-by: Jens Axboe <axboe@kernel.dk>
---
 include/uapi/linux/io_uring.h |  17 +++++
 io_uring/msg_ring.c           | 130 ++++++++++++++++++++++++++++++++--
 2 files changed, 140 insertions(+), 7 deletions(-)

diff --git a/include/uapi/linux/io_uring.h b/include/uapi/linux/io_uring.h
index 8715f0942ec2..15e54e633ee2 100644
--- a/include/uapi/linux/io_uring.h
+++ b/include/uapi/linux/io_uring.h
@@ -47,6 +47,7 @@ struct io_uring_sqe {
 		__u32		unlink_flags;
 		__u32		hardlink_flags;
 		__u32		xattr_flags;
+		__u32		msg_ring_flags;
 	};
 	__u64	user_data;	/* data to be passed back at completion time */
 	/* pack this to avoid bogus arm OABI complaints */
@@ -264,6 +265,22 @@ enum io_uring_op {
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
+/*
+ * IORING_OP_MSG_RING flags (sqe->msg_ring_flags)
+ *
+ * IORING_MSG_RING_CQE_SKIP	Don't post a CQE to the target ring. Not
+ *				applicable for IORING_MSG_DATA, obviously.
+ */
+#define IORING_MSG_RING_CQE_SKIP	(1U << 0)
+
 /*
  * IO completion data structure (Completion Queue Entry)
  */
diff --git a/io_uring/msg_ring.c b/io_uring/msg_ring.c
index b02be2349652..939205b30c8b 100644
--- a/io_uring/msg_ring.c
+++ b/io_uring/msg_ring.c
@@ -3,46 +3,162 @@
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
+	u32 flags;
 };
 
+static int io_msg_ring_data(struct io_kiocb *req)
+{
+	struct io_ring_ctx *target_ctx = req->file->private_data;
+	struct io_msg *msg = io_kiocb_to_cmd(req);
+
+	if (msg->src_fd || msg->dst_fd || msg->flags)
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
+	/* Always grab smallest value ctx first. We know ctx != octx. */
+	if (ctx < octx) {
+		mutex_lock(&ctx->uring_lock);
+		mutex_lock(&octx->uring_lock);
+	} else {
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
+		goto out_unlock;
+
+	msg->src_fd = array_index_nospec(msg->src_fd, ctx->nr_user_files);
+	file_ptr = io_fixed_file_slot(&ctx->file_table, msg->src_fd)->file_ptr;
+	src_file = (struct file *) (file_ptr & FFS_MASK);
+	get_file(src_file);
+
+	ret = __io_fixed_fd_install(target_ctx, src_file, msg->dst_fd);
+	if (ret < 0) {
+		fput(src_file);
+		goto out_unlock;
+	}
+
+	if (msg->flags & IORING_MSG_RING_CQE_SKIP)
+		goto out_unlock;
+
+	/*
+	 * If this fails, the target still received the file descriptor but
+	 * wasn't notified of the fact. This means that if this request
+	 * completes with -EOVERFLOW, then the sender must ensure that a
+	 * later IORING_OP_MSG_RING delivers the message.
+	 */
+	if (!io_post_aux_cqe(target_ctx, msg->user_data, msg->len, 0))
+		ret = -EOVERFLOW;
+out_unlock:
+	io_double_unlock_ctx(ctx, target_ctx, issue_flags);
+	return ret;
+}
+
 int io_msg_ring_prep(struct io_kiocb *req, const struct io_uring_sqe *sqe)
 {
 	struct io_msg *msg = io_kiocb_to_cmd(req);
 
-	if (unlikely(sqe->addr || sqe->rw_flags || sqe->splice_fd_in ||
-		     sqe->buf_index || sqe->personality))
+	if (unlikely(sqe->buf_index || sqe->personality))
 		return -EINVAL;
 
 	msg->user_data = READ_ONCE(sqe->off);
 	msg->len = READ_ONCE(sqe->len);
+	msg->cmd = READ_ONCE(sqe->addr);
+	msg->src_fd = READ_ONCE(sqe->addr3);
+	msg->dst_fd = READ_ONCE(sqe->file_index);
+	msg->flags = READ_ONCE(sqe->msg_ring_flags);
+	if (msg->flags & ~IORING_MSG_RING_CQE_SKIP)
+		return -EINVAL;
+
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

