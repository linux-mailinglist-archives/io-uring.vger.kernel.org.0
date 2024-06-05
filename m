Return-Path: <io-uring+bounces-2116-lists+io-uring=lfdr.de@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [IPv6:2604:1380:45d1:ec00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 727B68FD0B4
	for <lists+io-uring@lfdr.de>; Wed,  5 Jun 2024 16:20:14 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id 769BB1C23018
	for <lists+io-uring@lfdr.de>; Wed,  5 Jun 2024 14:20:13 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 202DF1CAAC;
	Wed,  5 Jun 2024 14:19:52 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel-dk.20230601.gappssmtp.com header.i=@kernel-dk.20230601.gappssmtp.com header.b="nZNV+Cxj"
X-Original-To: io-uring@vger.kernel.org
Received: from mail-oi1-f177.google.com (mail-oi1-f177.google.com [209.85.167.177])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 27C271BC3C
	for <io-uring@vger.kernel.org>; Wed,  5 Jun 2024 14:19:49 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.167.177
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1717597192; cv=none; b=MavDvkDi9mGHqZ/2sr0r8up2O0UzP6l51d2nRn6EmDXRyHQnrOaLcJPAXLJsXp99ObkAEvgcVB/J9Uw1QtWLCTWyWV2zrkOhU2CBpcPtQBCvbg56T5GyUMPnoFvFuP/oo2MiYPogoQ8kOb9YnKgDUiD8zABcwbVXyRNl/kvx4eY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1717597192; c=relaxed/simple;
	bh=+sGrQpS/TqRgBayPAV7HC0UunlbFm9y/mjMTsCzMl2E=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=BBgtSMw+5HlA+tYyOX3fziSepAe5bwiNlIQLY7LPyB7JPoQmo9B8SnZUIIaOd9S1ZTX0M7PPMqDL4i9j72MI0Evo8jsg5JxXZ9aJ/4B0vXGLIbMEMGw8kcIE+OREKRLdkEvMCKMJuVWaHJqZsd4Hr6unFovk3jC/93y3GZjQMko=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=kernel.dk; spf=pass smtp.mailfrom=kernel.dk; dkim=pass (2048-bit key) header.d=kernel-dk.20230601.gappssmtp.com header.i=@kernel-dk.20230601.gappssmtp.com header.b=nZNV+Cxj; arc=none smtp.client-ip=209.85.167.177
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=kernel.dk
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=kernel.dk
Received: by mail-oi1-f177.google.com with SMTP id 5614622812f47-3d1dbf0d2deso686280b6e.0
        for <io-uring@vger.kernel.org>; Wed, 05 Jun 2024 07:19:49 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernel-dk.20230601.gappssmtp.com; s=20230601; t=1717597188; x=1718201988; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=KdSk0OgXTLJoOarsefZ+rdTaqGB+4c8ZJAicy/5Kyq8=;
        b=nZNV+CxjL3X2KJDwKVlcsUlqw08tBnw9fgBYxa1Upt/ixlDPED9uEA18Q8KBW3+ffw
         0C6i5uUaEuM8vksx1pXOUrjq5gjEoNfZwAAYwuO38upJOu/dO4ksLMxYy80CJ5PamR8U
         G7uBwgIcvyn4Y9lX1hFnpGbIQiKhnt4YK7KpRdDqtVxihPtRRw/Sb87PrkMd+zEI+i1i
         QqEUVE6JRKJ1gIxBHUQ/cEMCPVd3Z05nmxxGRNQbORLhNHBdwZzen0rK3P2TGkg9p9Y3
         +43ZuXs/P9ys8hOwL1DvPF2GId3WunbGZF88i4yYKsyMXPeoILAW29qKGeufhE6im8qi
         Lz7g==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1717597188; x=1718201988;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=KdSk0OgXTLJoOarsefZ+rdTaqGB+4c8ZJAicy/5Kyq8=;
        b=bWl+SsbwN1PQi9LfSNYnvmYL9MXhdgMxtgXwr2pi/PAx0vEQptxrCYZ9Ks5uGicUNd
         6k4W9xU+UyevtOpKg7RdIqCh6BF6oKQVaQPW1eGJx6mmhWK9G/5T9ObVTq39wNH4qUuX
         kEx3l2iqL2fLdMHfBx5xAQohlQgSx3/sB1o1CzXr8BqLj2A8HL1vm+s4U2eChP2d+Trh
         oCU90S41Dy1t259Ydy3/geNQHLrPPI2AuXoxZgzBQG3IsBFCpvYtOxamjUNs6Or75fcY
         6oeEXvGRLETJ2zJ7YYu2tC2zWhjq7VcsBknGfvvD4ZffNLJk5J5yZNnPFeQ2fLNwXeE9
         ORnw==
X-Gm-Message-State: AOJu0YzN/GdwcU+5NAOCpeADJSNo/TPlxcLJxkGEfHK9dCKxYW8KZ3f4
	ZG00U+HYBZ23MP/8VjZ/EziMIsFBUZXrKYEMgyOyAsxFKSabj2LXI3kCVOOrLewZHlrYYDSKwJy
	N
X-Google-Smtp-Source: AGHT+IFMhnrJHSuDv4a2Px3hpNxUJIfLc0co5dJKch4g0zc3JjzgI7na/L5QHJue2BY4Bgt5pqYZeQ==
X-Received: by 2002:a05:6870:4d18:b0:24c:b092:fd38 with SMTP id 586e51a60fabf-25121cf42eamr3315780fac.1.1717597188389;
        Wed, 05 Jun 2024 07:19:48 -0700 (PDT)
Received: from localhost.localdomain ([96.43.243.2])
        by smtp.gmail.com with ESMTPSA id 586e51a60fabf-250853ca28esm4048918fac.55.2024.06.05.07.19.47
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 05 Jun 2024 07:19:47 -0700 (PDT)
From: Jens Axboe <axboe@kernel.dk>
To: io-uring@vger.kernel.org
Cc: asml.silence@gmail.com,
	Jens Axboe <axboe@kernel.dk>
Subject: [PATCH 6/9] io_uring/msg_ring: add an alloc cache for CQE entries
Date: Wed,  5 Jun 2024 07:51:14 -0600
Message-ID: <20240605141933.11975-7-axboe@kernel.dk>
X-Mailer: git-send-email 2.43.0
In-Reply-To: <20240605141933.11975-1-axboe@kernel.dk>
References: <20240605141933.11975-1-axboe@kernel.dk>
Precedence: bulk
X-Mailing-List: io-uring@vger.kernel.org
List-Id: <io-uring.vger.kernel.org>
List-Subscribe: <mailto:io-uring+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:io-uring+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

io_uring accounts the memory allocated, which is quite expensive. Wrap
the allocation and frees in the provided alloc cache framework. The
target ctx needs to be locked anyway for posting the overflow entry,
so just move the overflow alloc inside that section. Flushing the
entries has it locked as well, so io_cache_alloc_free() can be used.

In a simple test, most of the overhead of DEFER_TASKRUN message passing
ends up being accounting for allocation and free, and with this change
it's completely gone.

Signed-off-by: Jens Axboe <axboe@kernel.dk>
---
 include/linux/io_uring_types.h |  7 ++++
 io_uring/io_uring.c            |  7 +++-
 io_uring/msg_ring.c            | 76 +++++++++++++++++++++++-----------
 io_uring/msg_ring.h            |  3 ++
 4 files changed, 68 insertions(+), 25 deletions(-)

diff --git a/include/linux/io_uring_types.h b/include/linux/io_uring_types.h
index d795f3f3a705..c7f3a330482d 100644
--- a/include/linux/io_uring_types.h
+++ b/include/linux/io_uring_types.h
@@ -350,6 +350,13 @@ struct io_ring_ctx {
 	struct io_alloc_cache	futex_cache;
 #endif
 
+	/*
+	 * Unlike the other caches, this one is used by the sender of messages
+	 * to this ring, not by the ring itself. As such, protection for this
+	 * cache is under ->completion_lock, not ->uring_lock.
+	 */
+	struct io_alloc_cache	msg_cache;
+
 	const struct cred	*sq_creds;	/* cred used for __io_sq_thread() */
 	struct io_sq_data	*sq_data;	/* if using sq thread polling */
 
diff --git a/io_uring/io_uring.c b/io_uring/io_uring.c
index 499255ef62c7..3c77d96fc6d7 100644
--- a/io_uring/io_uring.c
+++ b/io_uring/io_uring.c
@@ -95,6 +95,7 @@
 #include "futex.h"
 #include "napi.h"
 #include "uring_cmd.h"
+#include "msg_ring.h"
 #include "memmap.h"
 
 #include "timeout.h"
@@ -316,6 +317,7 @@ static __cold struct io_ring_ctx *io_ring_ctx_alloc(struct io_uring_params *p)
 	ret |= io_alloc_cache_init(&ctx->uring_cache, IO_ALLOC_CACHE_MAX,
 			    sizeof(struct uring_cache));
 	ret |= io_futex_cache_init(ctx);
+	ret |= io_msg_cache_init(ctx);
 	if (ret)
 		goto err;
 	init_completion(&ctx->ref_comp);
@@ -352,6 +354,7 @@ static __cold struct io_ring_ctx *io_ring_ctx_alloc(struct io_uring_params *p)
 	io_alloc_cache_free(&ctx->rw_cache, io_rw_cache_free);
 	io_alloc_cache_free(&ctx->uring_cache, kfree);
 	io_futex_cache_free(ctx);
+	io_msg_cache_free(ctx);
 	kfree(ctx->cancel_table.hbs);
 	kfree(ctx->cancel_table_locked.hbs);
 	xa_destroy(&ctx->io_bl_xa);
@@ -619,7 +622,8 @@ static void __io_cqring_overflow_flush(struct io_ring_ctx *ctx, bool dying)
 		}
 		list_del(&ocqe->list);
 		ctx->nr_overflow--;
-		kfree(ocqe);
+		if (!io_alloc_cache_put(&ctx->msg_cache, ocqe))
+			kfree(ocqe);
 	}
 
 	if (list_empty(&ctx->cq_overflow_list)) {
@@ -2556,6 +2560,7 @@ static __cold void io_ring_ctx_free(struct io_ring_ctx *ctx)
 	io_alloc_cache_free(&ctx->rw_cache, io_rw_cache_free);
 	io_alloc_cache_free(&ctx->uring_cache, kfree);
 	io_futex_cache_free(ctx);
+	io_msg_cache_free(ctx);
 	io_destroy_buffers(ctx);
 	mutex_unlock(&ctx->uring_lock);
 	if (ctx->sq_creds)
diff --git a/io_uring/msg_ring.c b/io_uring/msg_ring.c
index 1ee89bdbbb5b..a33228f8c364 100644
--- a/io_uring/msg_ring.c
+++ b/io_uring/msg_ring.c
@@ -11,6 +11,7 @@
 #include "io_uring.h"
 #include "rsrc.h"
 #include "filetable.h"
+#include "alloc_cache.h"
 #include "msg_ring.h"
 
 
@@ -72,20 +73,28 @@ static inline bool io_msg_need_remote(struct io_ring_ctx *target_ctx)
 }
 
 static struct io_overflow_cqe *io_alloc_overflow(struct io_ring_ctx *target_ctx)
+	__acquires(&target_ctx->completion_lock)
 {
-	bool is_cqe32 = target_ctx->flags & IORING_SETUP_CQE32;
-	size_t cqe_size = sizeof(struct io_overflow_cqe);
 	struct io_overflow_cqe *ocqe;
 
-	if (is_cqe32)
-		cqe_size += sizeof(struct io_uring_cqe);
+	spin_lock(&target_ctx->completion_lock);
+
+	ocqe = io_alloc_cache_get(&target_ctx->msg_cache);
+	if (!ocqe) {
+		bool is_cqe32 = target_ctx->flags & IORING_SETUP_CQE32;
+		size_t cqe_size = sizeof(struct io_overflow_cqe);
 
-	ocqe = kmalloc(cqe_size, GFP_ATOMIC | __GFP_ACCOUNT);
-	if (!ocqe)
-		return NULL;
+		if (is_cqe32)
+			cqe_size += sizeof(struct io_uring_cqe);
+
+		ocqe = kmalloc(cqe_size, GFP_ATOMIC | __GFP_ACCOUNT);
+		if (!ocqe)
+			return NULL;
 
-	if (is_cqe32)
-		ocqe->cqe.big_cqe[0] = ocqe->cqe.big_cqe[1] = 0;
+		/* just init at alloc time, won't change */
+		if (is_cqe32)
+			ocqe->cqe.big_cqe[0] = ocqe->cqe.big_cqe[1] = 0;
+	}
 
 	return ocqe;
 }
@@ -121,12 +130,13 @@ static int io_msg_fill_remote(struct io_msg *msg, unsigned int issue_flags,
 	struct io_overflow_cqe *ocqe;
 
 	ocqe = io_alloc_overflow(target_ctx);
-	if (!ocqe)
-		return -ENOMEM;
+	if (ocqe) {
+		io_msg_add_overflow(msg, target_ctx, ocqe, msg->len, flags);
+		return 0;
+	}
 
-	spin_lock(&target_ctx->completion_lock);
-	io_msg_add_overflow(msg, target_ctx, ocqe, msg->len, flags);
-	return 0;
+	spin_unlock(&target_ctx->completion_lock);
+	return -ENOMEM;
 }
 
 static int io_msg_ring_data(struct io_kiocb *req, unsigned int issue_flags)
@@ -216,17 +226,17 @@ static int io_msg_install_remote(struct io_kiocb *req, unsigned int issue_flags,
 {
 	struct io_msg *msg = io_kiocb_to_cmd(req, struct io_msg);
 	struct io_overflow_cqe *ocqe = NULL;
-	int ret;
+	int ret = -ENOMEM;
+
+	if (unlikely(io_double_lock_ctx(target_ctx, issue_flags)))
+		return -EAGAIN;
 
 	if (!(msg->flags & IORING_MSG_RING_CQE_SKIP)) {
 		ocqe = io_alloc_overflow(target_ctx);
-		if (!ocqe)
-			return -ENOMEM;
-	}
-
-	if (unlikely(io_double_lock_ctx(target_ctx, issue_flags))) {
-		kfree(ocqe);
-		return -EAGAIN;
+		if (unlikely(!ocqe)) {
+			mutex_unlock(&target_ctx->uring_lock);
+			goto err;
+		}
 	}
 
 	ret = __io_fixed_fd_install(target_ctx, msg->src_file, msg->dst_fd);
@@ -236,12 +246,15 @@ static int io_msg_install_remote(struct io_kiocb *req, unsigned int issue_flags,
 		msg->src_file = NULL;
 		req->flags &= ~REQ_F_NEED_CLEANUP;
 		if (ocqe) {
-			spin_lock(&target_ctx->completion_lock);
 			io_msg_add_overflow(msg, target_ctx, ocqe, ret, 0);
 			return 0;
 		}
 	}
-	kfree(ocqe);
+	if (ocqe) {
+err:
+		spin_unlock(&target_ctx->completion_lock);
+		kfree(ocqe);
+	}
 	return ret;
 }
 
@@ -321,3 +334,18 @@ int io_msg_ring(struct io_kiocb *req, unsigned int issue_flags)
 	io_req_set_res(req, ret, 0);
 	return IOU_OK;
 }
+
+int io_msg_cache_init(struct io_ring_ctx *ctx)
+{
+	size_t size = sizeof(struct io_overflow_cqe);
+
+	if (ctx->flags & IORING_SETUP_CQE32)
+		size += sizeof(struct io_uring_cqe);
+
+	return io_alloc_cache_init(&ctx->msg_cache, IO_ALLOC_CACHE_MAX, size);
+}
+
+void io_msg_cache_free(struct io_ring_ctx *ctx)
+{
+	io_alloc_cache_free(&ctx->msg_cache, kfree);
+}
diff --git a/io_uring/msg_ring.h b/io_uring/msg_ring.h
index 3987ee6c0e5f..94f5716d522e 100644
--- a/io_uring/msg_ring.h
+++ b/io_uring/msg_ring.h
@@ -3,3 +3,6 @@
 int io_msg_ring_prep(struct io_kiocb *req, const struct io_uring_sqe *sqe);
 int io_msg_ring(struct io_kiocb *req, unsigned int issue_flags);
 void io_msg_ring_cleanup(struct io_kiocb *req);
+
+int io_msg_cache_init(struct io_ring_ctx *ctx);
+void io_msg_cache_free(struct io_ring_ctx *ctx);
-- 
2.43.0


