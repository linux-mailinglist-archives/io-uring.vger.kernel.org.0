Return-Path: <io-uring+bounces-7491-lists+io-uring=lfdr.de@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [139.178.88.99])
	by mail.lfdr.de (Postfix) with ESMTPS id 726D8A90791
	for <lists+io-uring@lfdr.de>; Wed, 16 Apr 2025 17:20:37 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id E62183B45E8
	for <lists+io-uring@lfdr.de>; Wed, 16 Apr 2025 15:20:20 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id B167D20C497;
	Wed, 16 Apr 2025 15:20:15 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="enangsgB"
X-Original-To: io-uring@vger.kernel.org
Received: from mail-ed1-f51.google.com (mail-ed1-f51.google.com [209.85.208.51])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id CF76A208973
	for <io-uring@vger.kernel.org>; Wed, 16 Apr 2025 15:20:13 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.208.51
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1744816815; cv=none; b=UAxM2zUROuHW6XF1B0E1ObsdiQ6LgJ/yYex19hCbxW63ToG21Ojpz3IQkGcXBiS1CW6XTFXkms+IRMlwo14JgzQLqosTngnpiIqeEBIgzyWJ9qAC7z3QShKrDDavtPp89DxsCS8BiYnVF2zfjrjPaEAGGovBtYhvRPJSOIRWcpU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1744816815; c=relaxed/simple;
	bh=1ePJyRu6W/I6SmleKQ3yQktN6PgQQTjfZfz064GYiYY=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=fzQOFKWyZDNl+33Yqgl4kKDmKFtjVSl9mT0hhZCGOz2F0vS44LlmGuK/+at/FN5qFSu83goEEda8No8L79YCAMrcwb21ZOGb4/DPUZ8Q3Vx0E7c0Mq9L5wn8fJ1ccMaTzDE9SbpSPBDk/zUVEYSq6OX7XEogBMM21XM/ai15K7M=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=enangsgB; arc=none smtp.client-ip=209.85.208.51
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Received: by mail-ed1-f51.google.com with SMTP id 4fb4d7f45d1cf-5e5e34f4e89so5196529a12.1
        for <io-uring@vger.kernel.org>; Wed, 16 Apr 2025 08:20:13 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1744816812; x=1745421612; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=yqk0dwcv+WXlX7iSuMOHO7EetCa6wGQFZf8zB+QYfKM=;
        b=enangsgBTScyt11R7dQ8w+W0uuRLRWmOA9esCZRndJrrfvCyOINl+SPpOJ8R0pIpDo
         NTFMSo2h4i7/j4gsAkygBuHAA16wYj8LYKK75AWm04/GXF6pkceHDIfSwkDydWgb5mfz
         xgvA3wDVaUaYj/YMI/Ol2iD47gY+WR7kpe1GFDzRUyGAIpQZ8XL3KBN2fo4x1B3xjpkL
         zgDIPA3PRYgRKX44ev/TMPfJFI0AkgBcFPs3dcIeRO2O+vSdtVxdHGeudFxd/xJRIDoS
         zldrt5EYGYY9ZeuAoeYxXxoREmqCD6FzW/vwmZHNby35YbfFB/VB7x5RPpgmfXm6D30N
         vphA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1744816812; x=1745421612;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=yqk0dwcv+WXlX7iSuMOHO7EetCa6wGQFZf8zB+QYfKM=;
        b=GYq3gpPZws9+R2rS35thYMRe+sD7xK1gtSkRHmrGJbKy+OamOekf+ircGf1Ng7noqw
         be8ivV6mVvvzj3AYpCoxe9FggmWaPu6A7cFCWSy3SHiU76/FxthHzzleK5TZqrvB8omh
         cn49ckke9ivWbN4/qo60zkheUfAI0IO6t8O4BtzJ9rxYUxgSh/AVCK9ahSyb+B5lMJUW
         mJqlOUSzR15Tlq7kPffLih4Y7ZJu9VBJUN6gpkvQfSuAzxR/r9hs1jH8SCaSg1sVea3b
         x7Mei3zRq4rjvEMtjDyDeLSkXxlXxMUsxyPKzIcK4i9oQaAxKUz+BFNY2FYVETUPuqlc
         psNw==
X-Gm-Message-State: AOJu0YzVm+XSKmgHFE+xa1lhrv+Lf/u48OiAD/wzLeUPQLFIwSqPmfG1
	FCbkHiyfug7bttBWBfP4Btaz1Cs1GynCgwoP19/UxCj+joO7FcvApdIiXnz8
X-Gm-Gg: ASbGncsK6iScnSvfuEqRiQj7LDMOHpMekN6leZEhtsQf+zsdAsT/t8lKgKAe5l6Vr6y
	Mqh4kSLY/ejbDzZVnNTl+eLL1YzoCyd8m6DhqZ7Me/82O8fs5FkavVclxOn8lSLai+uqdyvxWtW
	/322g5x7sI4/AbbqIKETc0qnJPV8AwbbFnz58M4E264gwIRocMpYwI29/yG7hHXkCjfxzH4zgX+
	+w7XZjhIcWp8+QR/eXvzwTJIuahKcG8fxRIfhGLUR971KndwYnZQ35LM1DCgcy4e51cXD0wi4Gj
	ZxCKv6Q2r3x2Ry1AVCIwYEYjrcUrvlSEBfo=
X-Google-Smtp-Source: AGHT+IFXeSkN5oADVzT2DsqFQc1OT0JgnxsDNWrxmGNs92bSsFYiN4QkmMdz2ycF3mXB8QtzSZtZag==
X-Received: by 2002:a17:907:d716:b0:ac7:e5c4:1187 with SMTP id a640c23a62f3a-acb4288417emr203890966b.11.1744816811353;
        Wed, 16 Apr 2025 08:20:11 -0700 (PDT)
Received: from 127.com ([2620:10d:c092:600::1:1ccb])
        by smtp.gmail.com with ESMTPSA id a640c23a62f3a-acb3cd61f75sm144579566b.35.2025.04.16.08.20.10
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 16 Apr 2025 08:20:10 -0700 (PDT)
From: Pavel Begunkov <asml.silence@gmail.com>
To: io-uring@vger.kernel.org
Cc: asml.silence@gmail.com,
	David Wei <dw@davidwei.uk>
Subject: [PATCH 5/5] io_uring/zcrx: add support for multiple ifqs
Date: Wed, 16 Apr 2025 16:21:20 +0100
Message-ID: <8d8ddd5862a4793cdb1b4486601e285d427df22e.1744815316.git.asml.silence@gmail.com>
X-Mailer: git-send-email 2.48.1
In-Reply-To: <cover.1744815316.git.asml.silence@gmail.com>
References: <cover.1744815316.git.asml.silence@gmail.com>
Precedence: bulk
X-Mailing-List: io-uring@vger.kernel.org
List-Id: <io-uring.vger.kernel.org>
List-Subscribe: <mailto:io-uring+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:io-uring+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

Allow the user to register multiple ifqs / zcrx contexts. With that we
can use multiple interfaces / interface queues in a single io_uring
instance.

Signed-off-by: Pavel Begunkov <asml.silence@gmail.com>
---
 include/linux/io_uring_types.h |  5 ++--
 io_uring/io_uring.c            |  3 +-
 io_uring/net.c                 |  8 ++---
 io_uring/zcrx.c                | 53 +++++++++++++++++++++-------------
 4 files changed, 40 insertions(+), 29 deletions(-)

diff --git a/include/linux/io_uring_types.h b/include/linux/io_uring_types.h
index 06d722289fc5..7e23e993280e 100644
--- a/include/linux/io_uring_types.h
+++ b/include/linux/io_uring_types.h
@@ -40,8 +40,6 @@ enum io_uring_cmd_flags {
 	IO_URING_F_TASK_DEAD		= (1 << 13),
 };
 
-struct io_zcrx_ifq;
-
 struct io_wq_work_node {
 	struct io_wq_work_node *next;
 };
@@ -394,7 +392,8 @@ struct io_ring_ctx {
 	struct wait_queue_head		poll_wq;
 	struct io_restriction		restrictions;
 
-	struct io_zcrx_ifq		*ifq;
+	/* Stores zcrx object pointers of type struct io_zcrx_ifq */
+	struct xarray			zcrx_ctxs;
 
 	u32			pers_next;
 	struct xarray		personalities;
diff --git a/io_uring/io_uring.c b/io_uring/io_uring.c
index 61514b14ee3f..ed85c9374f6e 100644
--- a/io_uring/io_uring.c
+++ b/io_uring/io_uring.c
@@ -359,6 +359,7 @@ static __cold struct io_ring_ctx *io_ring_ctx_alloc(struct io_uring_params *p)
 	INIT_LIST_HEAD(&ctx->tctx_list);
 	ctx->submit_state.free_list.next = NULL;
 	INIT_HLIST_HEAD(&ctx->waitid_list);
+	xa_init_flags(&ctx->zcrx_ctxs, XA_FLAGS_ALLOC);
 #ifdef CONFIG_FUTEX
 	INIT_HLIST_HEAD(&ctx->futex_list);
 #endif
@@ -2888,7 +2889,7 @@ static __cold void io_ring_exit_work(struct work_struct *work)
 			io_cqring_overflow_kill(ctx);
 			mutex_unlock(&ctx->uring_lock);
 		}
-		if (ctx->ifq) {
+		if (!xa_empty(&ctx->zcrx_ctxs)) {
 			mutex_lock(&ctx->uring_lock);
 			io_shutdown_zcrx_ifqs(ctx);
 			mutex_unlock(&ctx->uring_lock);
diff --git a/io_uring/net.c b/io_uring/net.c
index 5f1a519d1fc6..b3a643675ce8 100644
--- a/io_uring/net.c
+++ b/io_uring/net.c
@@ -1185,16 +1185,14 @@ int io_recvzc_prep(struct io_kiocb *req, const struct io_uring_sqe *sqe)
 	struct io_recvzc *zc = io_kiocb_to_cmd(req, struct io_recvzc);
 	unsigned ifq_idx;
 
-	if (unlikely(sqe->file_index || sqe->addr2 || sqe->addr ||
-		     sqe->addr3))
+	if (unlikely(sqe->addr2 || sqe->addr || sqe->addr3))
 		return -EINVAL;
 
 	ifq_idx = READ_ONCE(sqe->zcrx_ifq_idx);
-	if (ifq_idx != 0)
-		return -EINVAL;
-	zc->ifq = req->ctx->ifq;
+	zc->ifq = xa_load(&req->ctx->zcrx_ctxs, ifq_idx);
 	if (!zc->ifq)
 		return -EINVAL;
+
 	zc->len = READ_ONCE(sqe->len);
 	zc->flags = READ_ONCE(sqe->ioprio);
 	zc->msg_flags = READ_ONCE(sqe->msg_flags);
diff --git a/io_uring/zcrx.c b/io_uring/zcrx.c
index d56665fd103d..e4ce971b1257 100644
--- a/io_uring/zcrx.c
+++ b/io_uring/zcrx.c
@@ -172,9 +172,6 @@ static int io_allocate_rbuf_ring(struct io_zcrx_ifq *ifq,
 
 static void io_free_rbuf_ring(struct io_zcrx_ifq *ifq)
 {
-	if (WARN_ON_ONCE(ifq->ctx->ifq))
-		return;
-
 	io_free_region(ifq->ctx, &ifq->region);
 	ifq->rq_ring = NULL;
 	ifq->rqes = NULL;
@@ -334,11 +331,11 @@ static void io_zcrx_ifq_free(struct io_zcrx_ifq *ifq)
 struct io_mapped_region *io_zcrx_get_region(struct io_ring_ctx *ctx,
 					    unsigned int id)
 {
+	struct io_zcrx_ifq *ifq = xa_load(&ctx->zcrx_ctxs, id);
+
 	lockdep_assert_held(&ctx->mmap_lock);
 
-	if (id != 0 || !ctx->ifq)
-		return NULL;
-	return &ctx->ifq->region;
+	return ifq ? &ifq->region : NULL;
 }
 
 int io_register_zcrx_ifq(struct io_ring_ctx *ctx,
@@ -350,6 +347,7 @@ int io_register_zcrx_ifq(struct io_ring_ctx *ctx,
 	struct io_uring_region_desc rd;
 	struct io_zcrx_ifq *ifq;
 	int ret;
+	u32 id;
 
 	/*
 	 * 1. Interface queue allocation.
@@ -362,8 +360,6 @@ int io_register_zcrx_ifq(struct io_ring_ctx *ctx,
 	if (!(ctx->flags & IORING_SETUP_DEFER_TASKRUN &&
 	      ctx->flags & IORING_SETUP_CQE32))
 		return -EINVAL;
-	if (ctx->ifq)
-		return -EBUSY;
 	if (copy_from_user(&reg, arg, sizeof(reg)))
 		return -EFAULT;
 	if (copy_from_user(&rd, u64_to_user_ptr(reg.region_ptr), sizeof(rd)))
@@ -424,14 +420,21 @@ int io_register_zcrx_ifq(struct io_ring_ctx *ctx,
 	reg.offsets.head = offsetof(struct io_uring, head);
 	reg.offsets.tail = offsetof(struct io_uring, tail);
 
+	scoped_guard(mutex, &ctx->mmap_lock) {
+		ret = xa_alloc(&ctx->zcrx_ctxs, &id, ifq, xa_limit_31b, GFP_KERNEL);
+		if (ret)
+			goto err;
+	}
+
+	reg.zcrx_id = id;
 	if (copy_to_user(arg, &reg, sizeof(reg)) ||
 	    copy_to_user(u64_to_user_ptr(reg.region_ptr), &rd, sizeof(rd)) ||
 	    copy_to_user(u64_to_user_ptr(reg.area_ptr), &area, sizeof(area))) {
+		scoped_guard(mutex, &ctx->mmap_lock)
+			xa_erase(&ctx->zcrx_ctxs, id);
 		ret = -EFAULT;
 		goto err;
 	}
-	scoped_guard(mutex, &ctx->mmap_lock)
-		ctx->ifq = ifq;
 	return 0;
 err:
 	io_zcrx_ifq_free(ifq);
@@ -440,16 +443,23 @@ int io_register_zcrx_ifq(struct io_ring_ctx *ctx,
 
 void io_unregister_zcrx_ifqs(struct io_ring_ctx *ctx)
 {
-	struct io_zcrx_ifq *ifq = ctx->ifq;
+	struct io_zcrx_ifq *ifq;
+	unsigned long id;
 
 	lockdep_assert_held(&ctx->uring_lock);
 
-	if (!ifq)
-		return;
+	while (1) {
+		scoped_guard(mutex, &ctx->mmap_lock) {
+			ifq = xa_find(&ctx->zcrx_ctxs, &id, ULONG_MAX, XA_PRESENT);
+			if (ifq)
+				xa_erase(&ctx->zcrx_ctxs, id);
+		}
+		if (!ifq)
+			break;
+		io_zcrx_ifq_free(ifq);
+	}
 
-	scoped_guard(mutex, &ctx->mmap_lock)
-		ctx->ifq = NULL;
-	io_zcrx_ifq_free(ifq);
+	xa_destroy(&ctx->zcrx_ctxs);
 }
 
 static struct net_iov *__io_zcrx_get_free_niov(struct io_zcrx_area *area)
@@ -506,12 +516,15 @@ static void io_zcrx_scrub(struct io_zcrx_ifq *ifq)
 
 void io_shutdown_zcrx_ifqs(struct io_ring_ctx *ctx)
 {
+	struct io_zcrx_ifq *ifq;
+	unsigned long index;
+
 	lockdep_assert_held(&ctx->uring_lock);
 
-	if (!ctx->ifq)
-		return;
-	io_zcrx_scrub(ctx->ifq);
-	io_close_queue(ctx->ifq);
+	xa_for_each(&ctx->zcrx_ctxs, index, ifq) {
+		io_zcrx_scrub(ifq);
+		io_close_queue(ifq);
+	}
 }
 
 static inline u32 io_zcrx_rqring_entries(struct io_zcrx_ifq *ifq)
-- 
2.48.1


