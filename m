Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 9C7A236A790
	for <lists+io-uring@lfdr.de>; Sun, 25 Apr 2021 15:32:50 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229997AbhDYNd3 (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Sun, 25 Apr 2021 09:33:29 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:57876 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230239AbhDYNd2 (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Sun, 25 Apr 2021 09:33:28 -0400
Received: from mail-wr1-x430.google.com (mail-wr1-x430.google.com [IPv6:2a00:1450:4864:20::430])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 0086DC06175F
        for <io-uring@vger.kernel.org>; Sun, 25 Apr 2021 06:32:47 -0700 (PDT)
Received: by mail-wr1-x430.google.com with SMTP id x5so2760557wrv.13
        for <io-uring@vger.kernel.org>; Sun, 25 Apr 2021 06:32:47 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=vzKfxhTs4XNdcWRhCH0bQnYFTxzOtogJKjKga9i5Kl8=;
        b=ITL1m8QqDEd42+CHYGVISihMjYVc+VWTky1I0Zzfh2rtPdIUPUxwCEG0EiHN5CgKwX
         vx8nckkmWozUw1BPPI2ILa2HBvmAxx0VOTrgSfr6iMBotoTRHSA0KWoyX6FC6gmvxU9u
         m0lLcdmCLGomNoAt/GqsYswu1yZD5dKU8oWUTUaZhERh5nogKbVz8HWfYZ2gHFN0047o
         B3sBxp4rG5YtlTgVaoundRR00kxub3rWQZC1qAXFa/ds5W6R+7kAj6M69jzCTamQVtfF
         ylGIaK04Q7NvRSQX/pTADbF4G/Z9F8j7G3YuecEHz3Pt0jS6GaFCTAEVgK6z3KotU3aN
         OTpw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=vzKfxhTs4XNdcWRhCH0bQnYFTxzOtogJKjKga9i5Kl8=;
        b=RTIQhxQH4gx7bhFtEDE2C86cFKMHJEBzct2wgdmQvlDoO87FJWb72S5CcA2O81sM6d
         iaKyTDY/XP7nuM5cGJBaSk52res2Nw/Q5tz8dC9U6wS0/09o8jtDKa8ab/aQizeZXxmA
         /V0IxWUrttLzM4xtOZfuQghGZKk0dIfdyeRp1qXfZDNYST9MPihgX8OtOjk65ok7qi4M
         CDQy77STD+4nK/U0+0B9zEPSvSojFcwiwNA7pU0e9GdVTnNnVrpRAMpcMCz9alYfTreZ
         woveSxaKkUX+YC/rDMSbWaxUr19Qail7RdsLPcUcTUh0CZj+1hTgZC60AUcx81JpMs0z
         oqrg==
X-Gm-Message-State: AOAM532KMzXZ+47n5c77AWYJAa0qbYmNseOyOoZ2JYec05/yVzjd6Q4p
        6p4WtVRjP4V06dlCY0Sr5fIgPukkQBQ=
X-Google-Smtp-Source: ABdhPJxiPQtINCuSHcHkeeNNPOlaMAEFbcjx2bkbRBYw3YLdWdjosGZJx7l9AKORw+YUDbCKYzxjqQ==
X-Received: by 2002:a5d:6a04:: with SMTP id m4mr16994968wru.421.1619357566825;
        Sun, 25 Apr 2021 06:32:46 -0700 (PDT)
Received: from localhost.localdomain ([148.252.133.108])
        by smtp.gmail.com with ESMTPSA id a2sm16551552wrt.82.2021.04.25.06.32.46
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sun, 25 Apr 2021 06:32:46 -0700 (PDT)
From:   Pavel Begunkov <asml.silence@gmail.com>
To:     Jens Axboe <axboe@kernel.dk>, io-uring@vger.kernel.org
Cc:     Bijan Mottahedeh <bijan.mottahedeh@oracle.com>
Subject: [PATCH v2 12/12] io_uring: add full-fledged dynamic buffers support
Date:   Sun, 25 Apr 2021 14:32:26 +0100
Message-Id: <119ed51d68a491dae87eb55fb467a47870c86aad.1619356238.git.asml.silence@gmail.com>
X-Mailer: git-send-email 2.31.1
In-Reply-To: <cover.1619356238.git.asml.silence@gmail.com>
References: <cover.1619356238.git.asml.silence@gmail.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org

Hook buffers into all rsrc infrastructure, including tagging and
updates.

Suggested-by: Bijan Mottahedeh <bijan.mottahedeh@oracle.com>
Signed-off-by: Pavel Begunkov <asml.silence@gmail.com>
---
 fs/io_uring.c                 | 76 +++++++++++++++++++++++++++++++++--
 include/uapi/linux/io_uring.h |  1 +
 2 files changed, 73 insertions(+), 4 deletions(-)

diff --git a/fs/io_uring.c b/fs/io_uring.c
index 30f0563349db..fd953a96f5af 100644
--- a/fs/io_uring.c
+++ b/fs/io_uring.c
@@ -8109,8 +8109,8 @@ static void io_buffer_unmap(struct io_ring_ctx *ctx, struct io_mapped_ubuf **slo
 
 static void io_rsrc_buf_put(struct io_ring_ctx *ctx, struct io_rsrc_put *prsrc)
 {
-	/* no updates yet, so not used */
-	WARN_ON_ONCE(1);
+	io_buffer_unmap(ctx, &prsrc->buf);
+	prsrc->buf = NULL;
 }
 
 static void __io_sqe_buffers_unregister(struct io_ring_ctx *ctx)
@@ -8354,7 +8354,7 @@ static int io_buffer_validate(struct iovec *iov)
 }
 
 static int io_sqe_buffers_register(struct io_ring_ctx *ctx, void __user *arg,
-				   unsigned int nr_args)
+				   unsigned int nr_args, u64 __user *tags)
 {
 	struct page *last_hpage = NULL;
 	struct io_rsrc_data *data;
@@ -8378,6 +8378,12 @@ static int io_sqe_buffers_register(struct io_ring_ctx *ctx, void __user *arg,
 	}
 
 	for (i = 0; i < nr_args; i++, ctx->nr_user_bufs++) {
+		u64 tag = 0;
+
+		if (tags && copy_from_user(&tag, &tags[i], sizeof(tag))) {
+			ret = -EFAULT;
+			break;
+		}
 		ret = io_copy_iov(ctx, &iov, arg, i);
 		if (ret)
 			break;
@@ -8389,6 +8395,7 @@ static int io_sqe_buffers_register(struct io_ring_ctx *ctx, void __user *arg,
 					     &last_hpage);
 		if (ret)
 			break;
+		data->tags[i] = tag;
 	}
 
 	WARN_ON_ONCE(ctx->buf_data);
@@ -8401,6 +8408,62 @@ static int io_sqe_buffers_register(struct io_ring_ctx *ctx, void __user *arg,
 	return ret;
 }
 
+static int __io_sqe_buffers_update(struct io_ring_ctx *ctx,
+				   struct io_uring_rsrc_update2 *up,
+				   unsigned int nr_args)
+{
+	u64 __user *tags = u64_to_user_ptr(up->tags);
+	struct iovec iov, __user *iovs = u64_to_user_ptr(up->data);
+	struct io_mapped_ubuf *imu;
+	struct page *last_hpage = NULL;
+	bool needs_switch = false;
+	__u32 done;
+	int i, err;
+
+	if (!ctx->buf_data)
+		return -ENXIO;
+	if (up->offset + nr_args > ctx->nr_user_bufs)
+		return -EINVAL;
+
+	for (done = 0; done < nr_args; done++) {
+		u64 tag = 0;
+
+		err = io_copy_iov(ctx, &iov, iovs, done);
+		if (err)
+			break;
+		if (tags && copy_from_user(&tag, &tags[done], sizeof(tag))) {
+			err = -EFAULT;
+			break;
+		}
+
+		i = array_index_nospec(up->offset + done, ctx->nr_user_bufs);
+		imu = ctx->user_bufs[i];
+		if (imu) {
+			err = io_queue_rsrc_removal(ctx->buf_data, up->offset + done,
+						    ctx->rsrc_node, imu);
+			if (err)
+				break;
+			ctx->user_bufs[i] = NULL;
+			needs_switch = true;
+		}
+
+		if (iov.iov_base || iov.iov_len) {
+			err = io_buffer_validate(&iov);
+			if (err)
+				break;
+			err = io_sqe_buffer_register(ctx, &iov, &ctx->user_bufs[i],
+						     &last_hpage);
+			if (err)
+				break;
+			ctx->buf_data->tags[up->offset + done] = tag;
+		}
+	}
+
+	if (needs_switch)
+		io_rsrc_node_switch(ctx, ctx->buf_data);
+	return done ? done : err;
+}
+
 static int io_eventfd_register(struct io_ring_ctx *ctx, void __user *arg)
 {
 	__s32 __user *fds = arg;
@@ -9764,6 +9827,8 @@ static int __io_register_rsrc_update(struct io_ring_ctx *ctx, unsigned type,
 	switch (type) {
 	case IORING_RSRC_FILE:
 		return __io_sqe_files_update(ctx, up, nr_args);
+	case IORING_RSRC_BUFFER:
+		return __io_sqe_buffers_update(ctx, up, nr_args);
 	}
 	return -EINVAL;
 }
@@ -9814,6 +9879,9 @@ static int io_register_rsrc(struct io_ring_ctx *ctx, void __user *arg,
 	case IORING_RSRC_FILE:
 		return io_sqe_files_register(ctx, u64_to_user_ptr(rr.data),
 					     rr.nr, u64_to_user_ptr(rr.tags));
+	case IORING_RSRC_BUFFER:
+		return io_sqe_buffers_register(ctx, u64_to_user_ptr(rr.data),
+					       rr.nr, u64_to_user_ptr(rr.tags));
 	}
 	return -EINVAL;
 }
@@ -9894,7 +9962,7 @@ static int __io_uring_register(struct io_ring_ctx *ctx, unsigned opcode,
 
 	switch (opcode) {
 	case IORING_REGISTER_BUFFERS:
-		ret = io_sqe_buffers_register(ctx, arg, nr_args);
+		ret = io_sqe_buffers_register(ctx, arg, nr_args, NULL);
 		break;
 	case IORING_UNREGISTER_BUFFERS:
 		ret = -EINVAL;
diff --git a/include/uapi/linux/io_uring.h b/include/uapi/linux/io_uring.h
index 6d8360b5b9c5..e1ae46683301 100644
--- a/include/uapi/linux/io_uring.h
+++ b/include/uapi/linux/io_uring.h
@@ -314,6 +314,7 @@ struct io_uring_files_update {
 
 enum {
 	IORING_RSRC_FILE		= 0,
+	IORING_RSRC_BUFFER		= 1,
 };
 
 struct io_uring_rsrc_register {
-- 
2.31.1

