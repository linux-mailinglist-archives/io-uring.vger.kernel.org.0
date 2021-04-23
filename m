Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 32D403689B9
	for <lists+io-uring@lfdr.de>; Fri, 23 Apr 2021 02:19:56 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S239881AbhDWAU0 (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Thu, 22 Apr 2021 20:20:26 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:53792 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S236068AbhDWAU0 (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Thu, 22 Apr 2021 20:20:26 -0400
Received: from mail-wr1-x42d.google.com (mail-wr1-x42d.google.com [IPv6:2a00:1450:4864:20::42d])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id E274CC061574
        for <io-uring@vger.kernel.org>; Thu, 22 Apr 2021 17:19:49 -0700 (PDT)
Received: by mail-wr1-x42d.google.com with SMTP id c15so37605260wro.13
        for <io-uring@vger.kernel.org>; Thu, 22 Apr 2021 17:19:49 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=OmQWl9Z8jiCHJfTGaDyM8IM2jB2CwdIcfxJvLRVm2Jc=;
        b=JKoXpfv3c4ZhiKPz8GgEUXqMg+3N4pJ56PtoFxFha9ox/1RvXPhc1mETdPv24I2Vh4
         VgkYlM2BMKTn4kRhO54yp8FN+Xz+HbZc/GmG+7/F9CBMpYsAWpu8RNd/HoBf/vOwYnch
         SZmNIqSuScWdnOGhez5ZutKxxCnxaRksCxJ7zvHUUR93QgrBa+9cs09Vya4TsirYFuFq
         UrpZv04Qxo9K/kBLr1PrzWXc8eHAHeHLIQeKuKtnom2PlMOOS4Rpgn9R75LRl7CB+yQC
         safat9N/fplhKn2NfMfaR30moLO0l3JfnP5ToGVy6Y6xVFUaRA9wI0vX2buxAAbKaLQ6
         euPg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=OmQWl9Z8jiCHJfTGaDyM8IM2jB2CwdIcfxJvLRVm2Jc=;
        b=c9fOG96MGMz5/9PcYnbyt1DyCggd4XQmzKzVDHVEaVCSTvqcOGywz7g03zAN3jMPnf
         d6m81miKSCTfZBLoxMzFEBPtgz/HbDLWQlGgAc4+M2lCp6XWArNg0f3bFGqBVqYkbo4s
         UTWwjI7kl3gnusi4P51drAQ0+XOuO3W2tmpESTt7q1hP+xkekly5R5Odqx/GBPJPwZae
         BRkGu4C/j2YINC7TaOKhoiLvB+MDK9zuYDxOE3VrVBwdwDttrtNwQX0LofGOWZDS9hY1
         PK1SjoJAh9Q2IpS5DlnvFlmiCVDaEftWYgtxPJREnsVdwORQuWxVQb6r2u/g7NY7q9ls
         zZKQ==
X-Gm-Message-State: AOAM5325fran6XZE+mrZaKTRSUAvSXSWptRaQypC3Q2kKPbrtsUzk7x5
        J1uDa3tvEomyBicay4WgXOc=
X-Google-Smtp-Source: ABdhPJwkwdmrdvzJwv3eun7sP/+jpCuBbpjJ7hHu47yz3LsgIc96oRZ/unCP7Io4s2vrOEQrZBCNZw==
X-Received: by 2002:adf:de08:: with SMTP id b8mr1003270wrm.279.1619137187917;
        Thu, 22 Apr 2021 17:19:47 -0700 (PDT)
Received: from localhost.localdomain ([148.252.128.225])
        by smtp.gmail.com with ESMTPSA id g12sm6369605wru.47.2021.04.22.17.19.47
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 22 Apr 2021 17:19:47 -0700 (PDT)
From:   Pavel Begunkov <asml.silence@gmail.com>
To:     Jens Axboe <axboe@kernel.dk>, io-uring@vger.kernel.org
Cc:     Bijan Mottahedeh <bijan.mottahedeh@oracle.com>
Subject: [PATCH 11/11] io_uring: add full-fledged dynamic buffers support
Date:   Fri, 23 Apr 2021 01:19:28 +0100
Message-Id: <01e67483c80a435387b7a67fd959f1eee5b83da0.1619128798.git.asml.silence@gmail.com>
X-Mailer: git-send-email 2.31.1
In-Reply-To: <cover.1619128798.git.asml.silence@gmail.com>
References: <cover.1619128798.git.asml.silence@gmail.com>
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
 fs/io_uring.c                 | 84 +++++++++++++++++++++++++++++++++--
 include/uapi/linux/io_uring.h |  1 +
 2 files changed, 81 insertions(+), 4 deletions(-)

diff --git a/fs/io_uring.c b/fs/io_uring.c
index 0e938c87d6db..e59ac0a39c5c 100644
--- a/fs/io_uring.c
+++ b/fs/io_uring.c
@@ -8101,8 +8101,9 @@ static void io_buffer_unmap(struct io_ring_ctx *ctx, struct io_mapped_ubuf *imu)
 
 static void io_rsrc_buf_put(struct io_ring_ctx *ctx, struct io_rsrc_put *prsrc)
 {
-	/* no updates yet, so not used */
-	WARN_ON_ONCE(1);
+	io_buffer_unmap(ctx, prsrc->buf);
+	kfree(prsrc->buf);
+	prsrc->buf = NULL;
 }
 
 static void __io_sqe_buffers_unregister(struct io_ring_ctx *ctx)
@@ -8344,7 +8345,7 @@ static int io_buffer_validate(struct iovec *iov)
 }
 
 static int io_sqe_buffers_register(struct io_ring_ctx *ctx, void __user *arg,
-				   unsigned int nr_args)
+				   unsigned int nr_args, u64 __user *tags)
 {
 	struct page *last_hpage = NULL;
 	struct io_rsrc_data *data;
@@ -8369,7 +8370,12 @@ static int io_sqe_buffers_register(struct io_ring_ctx *ctx, void __user *arg,
 
 	for (i = 0; i < nr_args; i++, ctx->nr_user_bufs++) {
 		struct io_mapped_ubuf *imu = &ctx->user_bufs[i];
+		u64 tag = 0;
 
+		if (tags && copy_from_user(&tag, &tags[i], sizeof(tag))) {
+			ret = -EFAULT;
+			break;
+		}
 		ret = io_copy_iov(ctx, &iov, arg, i);
 		if (ret)
 			break;
@@ -8379,6 +8385,7 @@ static int io_sqe_buffers_register(struct io_ring_ctx *ctx, void __user *arg,
 		ret = io_sqe_buffer_register(ctx, &iov, imu, &last_hpage);
 		if (ret)
 			break;
+		data->tags[i] = tag;
 	}
 
 	WARN_ON_ONCE(ctx->buf_data);
@@ -8391,6 +8398,70 @@ static int io_sqe_buffers_register(struct io_ring_ctx *ctx, void __user *arg,
 	return ret;
 }
 
+static int __io_sqe_buffers_update(struct io_ring_ctx *ctx,
+				   struct io_uring_rsrc_update2 *up,
+				   unsigned int nr_args)
+{
+	u64 __user *tags = u64_to_user_ptr(up->tags);
+	struct iovec iov, __user *iovs = u64_to_user_ptr(up->data);
+	struct io_mapped_ubuf *imu, *dup;
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
+		imu = &ctx->user_bufs[i];
+		if (imu) {
+			dup = kmemdup(imu, sizeof(*imu), GFP_KERNEL);
+			if (!dup) {
+				err = -ENOMEM;
+				break;
+			}
+			err = io_queue_rsrc_removal(ctx->buf_data, up->offset + done,
+						    ctx->rsrc_node, dup);
+			if (err) {
+				kfree(dup);
+				break;
+			}
+			memset(imu, 0, sizeof(*imu));
+			needs_switch = true;
+		}
+
+		if (iov.iov_base || iov.iov_len) {
+			err = io_buffer_validate(&iov);
+			if (err)
+				break;
+			err = io_sqe_buffer_register(ctx, &iov, imu, &last_hpage);
+			if (err) {
+				memset(imu, 0, sizeof(*imu));
+				break;
+			}
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
@@ -9751,6 +9822,8 @@ static int __io_register_rsrc_update(struct io_ring_ctx *ctx, unsigned type,
 	switch (type) {
 	case IORING_RSRC_FILE:
 		return __io_sqe_files_update(ctx, up, nr_args);
+	case IORING_RSRC_BUFFER:
+		return __io_sqe_buffers_update(ctx, up, nr_args);
 	}
 	return -EINVAL;
 }
@@ -9801,6 +9874,9 @@ static int io_register_rsrc(struct io_ring_ctx *ctx, void __user *arg,
 	case IORING_RSRC_FILE:
 		return io_sqe_files_register(ctx, u64_to_user_ptr(rr.data),
 					     rr.nr, u64_to_user_ptr(rr.tags));
+	case IORING_RSRC_BUFFER:
+		return io_sqe_buffers_register(ctx, u64_to_user_ptr(rr.data),
+					       rr.nr, u64_to_user_ptr(rr.tags));
 	}
 	return -EINVAL;
 }
@@ -9881,7 +9957,7 @@ static int __io_uring_register(struct io_ring_ctx *ctx, unsigned opcode,
 
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

