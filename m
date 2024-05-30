Return-Path: <io-uring+bounces-2006-lists+io-uring=lfdr.de@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [IPv6:2604:1380:45d1:ec00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 6A2448D4F13
	for <lists+io-uring@lfdr.de>; Thu, 30 May 2024 17:28:47 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id 83FBA1C24979
	for <lists+io-uring@lfdr.de>; Thu, 30 May 2024 15:28:46 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 14586176253;
	Thu, 30 May 2024 15:28:43 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel-dk.20230601.gappssmtp.com header.i=@kernel-dk.20230601.gappssmtp.com header.b="oGNB6Bay"
X-Original-To: io-uring@vger.kernel.org
Received: from mail-oi1-f173.google.com (mail-oi1-f173.google.com [209.85.167.173])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 14AB9176257
	for <io-uring@vger.kernel.org>; Thu, 30 May 2024 15:28:40 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.167.173
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1717082923; cv=none; b=o4no0UgT+DmJyw5dhdbtEIu5oktDTO1s4JVFwYZPOH573YNygdpCOXtSXGrHKucz8Unixtsh8kizIEZrSAau3cG+LbQ8Rgsb9j6oLFT+FgLgbsQbRxlx6Zv7GSGem7OZ0iiQqSafa+8vPOabcdEJd9cai3dFGY6lgw/yItQOEKc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1717082923; c=relaxed/simple;
	bh=5aRBLTLFFjZCBnQRaWREwbsqDiAByQrqRTQa26ZH0ZU=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=eP4ODm7X42E19VmHsEHPBHCPn6PGXnwo8aq8jR1GLuGRPpVjI4qgnzZ+AjCwY5sTasd2SZAfTtOZPBbS8cD0ynTEeSQhf6bS4od/4o+2yeTwoXfSEQVzjCqtsj6tSwLSqUAS+NoQF5qq3gc8lkvPWhQuVv6tqY6zsMEDkLSlkFg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=kernel.dk; spf=pass smtp.mailfrom=kernel.dk; dkim=pass (2048-bit key) header.d=kernel-dk.20230601.gappssmtp.com header.i=@kernel-dk.20230601.gappssmtp.com header.b=oGNB6Bay; arc=none smtp.client-ip=209.85.167.173
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=kernel.dk
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=kernel.dk
Received: by mail-oi1-f173.google.com with SMTP id 5614622812f47-3d1dbf0d2deso114941b6e.0
        for <io-uring@vger.kernel.org>; Thu, 30 May 2024 08:28:40 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernel-dk.20230601.gappssmtp.com; s=20230601; t=1717082919; x=1717687719; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=/EA1Comx7gvP1IGy42avlgdpDFbynZPpuWfpbA6DKD8=;
        b=oGNB6Baym2kJEHbZhZO5djvK3rNvBcN3R1bFkuF0lgfkA8EhXOt14MD213us5QiiTA
         ZqVwQWwQqyCLUGCU6xlw5j5zaLCnXBFl9C06CS1rWk5MJypQ5COmuMfYcU9ir8HFNZ9D
         /1W99s9MSgodjhdldbanYB22rNlEep4rr6qbUkVDnTAA3b4iL1NLYRazpkROqTFxvXqu
         2lz+HCyIXhuZ3wxXObz7IEqlKszGxFTfCPLb54QJ3m+T+zSuYe0+XO39Or0PxAQ3HnUW
         8zAnnzwJ2h1RM/N4BPNUvboLyKXi5Y8JjzVZLtlVbESvO5Y9a7Mcg6P3BUQBUdRs/Jlq
         +UoA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1717082919; x=1717687719;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=/EA1Comx7gvP1IGy42avlgdpDFbynZPpuWfpbA6DKD8=;
        b=CoWqrJtVwrKMWGOTanIhGs16GDEEOKFUvTWSjsm+vmZJzAvEtSjWfeClnfe/VeodvF
         Q2pBCrvs+SDtV+QdPffNlcquwLJwudl8SqK8aLC2FRRtrRXhT9NvGkaB9ouAxRQqAsQh
         KnsKre1HmfbnDBshMBDN5wUgMTRQ98vpz5u8uBpaca4WXyvglE10JI8y99BOuuqq//nK
         afzQ1xBhrZNG2/PmnL8TClte5+MOWx8LJm7hwVzdnc0snoArHxqKdRyvDMHMGunxD7n+
         AFDvskJo1rt9kem0t/7/crfmoKnZ2vBIbGwGIjzLjH5lptDYY6O5eGAzvAhUsJUFGkh2
         lLkg==
X-Gm-Message-State: AOJu0YynFD3H2rwE+WfDshB/6YCNCcYPkmnpNRhuiY3P7jzPFmAcDPMG
	YXr6zV3YqurToHiKJkO26pZHvn46F9bVsrVuiF8s1VYoI3kvteIu26jjZYzDZ89bp7LDnkLhZRQ
	N
X-Google-Smtp-Source: AGHT+IEEH5Zw4vDaBQbPn/IL+fEFxkAwz45fRS2a26sFCdrgFrkNjbzUmA3kWm2WsHEicGoC5O1csA==
X-Received: by 2002:a05:6808:18a7:b0:3d1:e162:10a7 with SMTP id 5614622812f47-3d1e1622b79mr116694b6e.3.1717082919547;
        Thu, 30 May 2024 08:28:39 -0700 (PDT)
Received: from localhost.localdomain ([96.43.243.2])
        by smtp.gmail.com with ESMTPSA id 5614622812f47-3d1b3682381sm2008136b6e.2.2024.05.30.08.28.38
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 30 May 2024 08:28:38 -0700 (PDT)
From: Jens Axboe <axboe@kernel.dk>
To: io-uring@vger.kernel.org
Cc: Jens Axboe <axboe@kernel.dk>
Subject: [PATCH 5/7] io_uring/msg_ring: add an alloc cache for CQE entries
Date: Thu, 30 May 2024 09:23:42 -0600
Message-ID: <20240530152822.535791-7-axboe@kernel.dk>
X-Mailer: git-send-email 2.43.0
In-Reply-To: <20240530152822.535791-2-axboe@kernel.dk>
References: <20240530152822.535791-2-axboe@kernel.dk>
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
 io_uring/msg_ring.c            | 67 +++++++++++++++++++++++-----------
 io_uring/msg_ring.h            |  3 ++
 4 files changed, 62 insertions(+), 22 deletions(-)

diff --git a/include/linux/io_uring_types.h b/include/linux/io_uring_types.h
index 91224bbcfa73..0f8fc6070b12 100644
--- a/include/linux/io_uring_types.h
+++ b/include/linux/io_uring_types.h
@@ -357,6 +357,13 @@ struct io_ring_ctx {
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
index 816e93e7f949..bdb2636dc939 100644
--- a/io_uring/io_uring.c
+++ b/io_uring/io_uring.c
@@ -95,6 +95,7 @@
 #include "futex.h"
 #include "napi.h"
 #include "uring_cmd.h"
+#include "msg_ring.h"
 #include "memmap.h"
 
 #include "timeout.h"
@@ -315,6 +316,7 @@ static __cold struct io_ring_ctx *io_ring_ctx_alloc(struct io_uring_params *p)
 	ret |= io_alloc_cache_init(&ctx->uring_cache, IO_ALLOC_CACHE_MAX,
 			    sizeof(struct uring_cache));
 	ret |= io_futex_cache_init(ctx);
+	ret |= io_msg_cache_init(ctx);
 	if (ret)
 		goto err;
 	init_completion(&ctx->ref_comp);
@@ -351,6 +353,7 @@ static __cold struct io_ring_ctx *io_ring_ctx_alloc(struct io_uring_params *p)
 	io_alloc_cache_free(&ctx->rw_cache, io_rw_cache_free);
 	io_alloc_cache_free(&ctx->uring_cache, kfree);
 	io_futex_cache_free(ctx);
+	io_msg_cache_free(ctx);
 	kfree(ctx->cancel_table.hbs);
 	kfree(ctx->cancel_table_locked.hbs);
 	xa_destroy(&ctx->io_bl_xa);
@@ -695,7 +698,8 @@ static void __io_cqring_overflow_flush(struct io_ring_ctx *ctx, bool dying)
 			memcpy(cqe, &ocqe->cqe, cqe_size);
 		}
 		list_del(&ocqe->list);
-		kfree(ocqe);
+		if (!io_alloc_cache_put(&ctx->msg_cache, ocqe))
+			kfree(ocqe);
 	}
 
 	if (list_empty(&ctx->cq_overflow_list)) {
@@ -2649,6 +2653,7 @@ static __cold void io_ring_ctx_free(struct io_ring_ctx *ctx)
 	io_alloc_cache_free(&ctx->rw_cache, io_rw_cache_free);
 	io_alloc_cache_free(&ctx->uring_cache, kfree);
 	io_futex_cache_free(ctx);
+	io_msg_cache_free(ctx);
 	io_destroy_buffers(ctx);
 	mutex_unlock(&ctx->uring_lock);
 	if (ctx->sq_creds)
diff --git a/io_uring/msg_ring.c b/io_uring/msg_ring.c
index 74590e66d7f7..392763f3f090 100644
--- a/io_uring/msg_ring.c
+++ b/io_uring/msg_ring.c
@@ -11,6 +11,7 @@
 #include "io_uring.h"
 #include "rsrc.h"
 #include "filetable.h"
+#include "alloc_cache.h"
 #include "msg_ring.h"
 
 
@@ -73,19 +74,24 @@ static inline bool io_msg_need_remote(struct io_ring_ctx *target_ctx)
 
 static struct io_overflow_cqe *io_alloc_overflow(struct io_ring_ctx *target_ctx)
 {
-	bool is_cqe32 = target_ctx->flags & IORING_SETUP_CQE32;
-	size_t cqe_size = sizeof(struct io_overflow_cqe);
 	struct io_overflow_cqe *ocqe;
 
-	if (is_cqe32)
-		cqe_size += sizeof(struct io_uring_cqe);
+	ocqe = io_alloc_cache_get(&target_ctx->msg_cache);
+	if (!ocqe) {
+		bool is_cqe32 = target_ctx->flags & IORING_SETUP_CQE32;
+		size_t cqe_size = sizeof(struct io_overflow_cqe);
 
-	ocqe = kmalloc(cqe_size, GFP_ATOMIC | __GFP_ACCOUNT);
-	if (!ocqe)
-		return NULL;
+		if (is_cqe32)
+			cqe_size += sizeof(struct io_uring_cqe);
 
-	if (is_cqe32)
-		ocqe->cqe.big_cqe[0] = ocqe->cqe.big_cqe[1] = 0;
+		ocqe = kmalloc(cqe_size, GFP_ATOMIC | __GFP_ACCOUNT);
+		if (!ocqe)
+			return NULL;
+
+		/* just init at alloc time, won't change */
+		if (is_cqe32)
+			ocqe->cqe.big_cqe[0] = ocqe->cqe.big_cqe[1] = 0;
+	}
 
 	return ocqe;
 }
@@ -119,13 +125,16 @@ static int io_msg_fill_remote(struct io_msg *msg, unsigned int issue_flags,
 {
 	struct io_overflow_cqe *ocqe;
 
+	spin_lock(&target_ctx->completion_lock);
+
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
@@ -228,17 +237,16 @@ static int io_msg_install_remote(struct io_kiocb *req, unsigned int issue_flags,
 	struct io_overflow_cqe *ocqe = NULL;
 	int ret;
 
+	if (unlikely(io_double_lock_ctx(target_ctx, issue_flags)))
+		return -EAGAIN;
+
 	if (!skip_cqe) {
+		spin_lock(&target_ctx->completion_lock);
 		ocqe = io_alloc_overflow(target_ctx);
 		if (!ocqe)
 			return -ENOMEM;
 	}
 
-	if (unlikely(io_double_lock_ctx(target_ctx, issue_flags))) {
-		kfree(ocqe);
-		return -EAGAIN;
-	}
-
 	ret = __io_fixed_fd_install(target_ctx, msg->src_file, msg->dst_fd);
 	mutex_unlock(&target_ctx->uring_lock);
 
@@ -246,12 +254,14 @@ static int io_msg_install_remote(struct io_kiocb *req, unsigned int issue_flags,
 		msg->src_file = NULL;
 		req->flags &= ~REQ_F_NEED_CLEANUP;
 		if (!skip_cqe) {
-			spin_lock(&target_ctx->completion_lock);
 			io_msg_add_overflow(msg, target_ctx, ocqe, ret, 0);
 			return 0;
 		}
 	}
-	kfree(ocqe);
+	if (ocqe) {
+		spin_unlock(&target_ctx->completion_lock);
+		kfree(ocqe);
+	}
 	return ret;
 }
 
@@ -331,3 +341,18 @@ int io_msg_ring(struct io_kiocb *req, unsigned int issue_flags)
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


