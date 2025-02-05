Return-Path: <io-uring+bounces-6270-lists+io-uring=lfdr.de@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [147.75.199.223])
	by mail.lfdr.de (Postfix) with ESMTPS id 25AB3A28962
	for <lists+io-uring@lfdr.de>; Wed,  5 Feb 2025 12:37:02 +0100 (CET)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id A7727163AFF
	for <lists+io-uring@lfdr.de>; Wed,  5 Feb 2025 11:37:00 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 9E61B22A4D9;
	Wed,  5 Feb 2025 11:36:56 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="hyifcIC4"
X-Original-To: io-uring@vger.kernel.org
Received: from mail-wm1-f45.google.com (mail-wm1-f45.google.com [209.85.128.45])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9E75E22ACD4
	for <io-uring@vger.kernel.org>; Wed,  5 Feb 2025 11:36:54 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.128.45
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1738755416; cv=none; b=BsfO13dVyKH3zlopWmLiFoBdC4Dh1bTzhKvVGeTe5XFS+Dumhxv8WNvy15T8apDDNI+ZaAA68alMa4rvEEZ7g5jkzcbLo+3LXGu0d+2UAvReSZSoz1WjvMoz3j/VBsM2zKBpakfxcZGl5Y0LF1ToNg6i5dNAb6vt4RR2FhDLa/s=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1738755416; c=relaxed/simple;
	bh=ieQ5RJtNYpG3cYQtlgg0tvsBWaNrxS5OnuBbL0M+NgE=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=C47TwyHw1qys3pNKLXTdLfb23GbmuvtD3qkoGF139gqgn70wn57/BKGWNIgKt8ouogS6hUq8ueEx7OiNpooGEXmEXmFh9UN93jkmPWdDI7rd65N3cMb3T3Xs9pFqifqmc1ZO7KsLbX1TjiHMArF2WfVjR7jAASa/RrirArhUebw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=hyifcIC4; arc=none smtp.client-ip=209.85.128.45
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Received: by mail-wm1-f45.google.com with SMTP id 5b1f17b1804b1-4361f796586so77748585e9.3
        for <io-uring@vger.kernel.org>; Wed, 05 Feb 2025 03:36:54 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1738755413; x=1739360213; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=nvfjTyzYru3H2UPC+6JsGGKZyTnjPYYlWkSpj0N0sAA=;
        b=hyifcIC4Szsr9m5ZSAti0p4Z6FCxNdffQsaTD9PxAYEnMPiU+zmSfI/u9Hxa2n4vpM
         XBO5kNUkRI/HdYOowrdlMar+5jtb5nU4nuGO1HBdD4ql8nXzRkGKeYXVifE+C6HM39r2
         jiaKVdELSLRhY5PGM87cAQN4uh4K50FB0vTHU6pYM2G0pEGvw70G16+FqqwEQJkKI4bW
         goCWNe02x9TfSdxMz/6TRHzZylS68LVQEEBa/8k7uth9ztutkzV1mHDC5ETxY/jfDxzf
         JdB/XBN8MkGcw3A0AjlmggkVAU08CnpK8gV8XY/ih+pzER+c3Jo9Y2z1O6Xa4FR0clC6
         /kdw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1738755413; x=1739360213;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=nvfjTyzYru3H2UPC+6JsGGKZyTnjPYYlWkSpj0N0sAA=;
        b=sVdJkK3LPYhn4TQam5FgvhogGnv0e3HmevV265Uh9ahreMb4wVAs1XCxb5DO8gDPP9
         zb/aBjJNKKuclnizq3aIfv1rwiTDwv4WmyzDhZ6vlUf8wrfLbF8t+jIMZ8IL1Pea6X5q
         0UatSb+UIMg3YOim9BDuf8skVoxrVoWPVKvwObBKC579ZaKsQMQPVFbFBMCGel6Gbaw8
         +B/HQu522b1RorIhV4sBTr/KX0k/J6VleEccIZfK4QnqqDr2MGX8OraOTOCjsxaPA7wT
         rw4eRpAXTK8UA5XOBuLRTDdBbbcJzKY4XrUV3dGyUqTea0xaYtxz9zswoME56zreTY4T
         arSg==
X-Gm-Message-State: AOJu0YxW1swJ1wG5eZ9sp211IawRGvuFbR7xHVT8hxjVyPvjY2AIZWmd
	nL2sBvv5MSW+dfzsp5hhpZumMBpaI+YA37bFMA9GDpL6IFWLOXEjikip1g==
X-Gm-Gg: ASbGnctks9kKthnR4QmcWVItOejVAO/7nNOja1tXIc6VEczjiqlrJeQEJDrpyTg3+l6
	KxGKNQEtcbAaVbDnY1P1OwY5Y48CYEh4SV8JwUc2D3C7vG8xFamOocF6q/k4pqSRIa0ZhmkDsL1
	Cc7KNbCTXDQT1qtC29UAXsIOb8g+LcM0bbLlQksVo7dWWlia2CwAUE7NJbnGH/kCTPNCE8LuKEK
	8EnyI7MSjPAr618+VarvD07Jn3+vRkHlm+wNDpWZbQm9reIi5W5e9vB0T6Ohb9qA01u939R6Y2R
	wMjoCdrPwHS2VuQy/3GIQViZgUE=
X-Google-Smtp-Source: AGHT+IGMLybgnH7DkczH23rfnoEyuwj0+d76Thfe8Uyds7kuy605k/TkXkSsKHHuExOp5hg8hFxjjQ==
X-Received: by 2002:a05:600c:3baa:b0:434:f817:4492 with SMTP id 5b1f17b1804b1-4390d591b4emr21591285e9.31.1738755412422;
        Wed, 05 Feb 2025 03:36:52 -0800 (PST)
Received: from 127.0.0.1localhost ([148.252.128.4])
        by smtp.gmail.com with ESMTPSA id 5b1f17b1804b1-4390d94d7d4sm18514505e9.10.2025.02.05.03.36.51
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 05 Feb 2025 03:36:51 -0800 (PST)
From: Pavel Begunkov <asml.silence@gmail.com>
To: io-uring@vger.kernel.org
Cc: asml.silence@gmail.com
Subject: [PATCH 5/8] io_uring/kbuf: remove legacy kbuf caching
Date: Wed,  5 Feb 2025 11:36:46 +0000
Message-ID: <18287217466ee2576ea0b1e72daccf7b22c7e856.1738724373.git.asml.silence@gmail.com>
X-Mailer: git-send-email 2.47.1
In-Reply-To: <cover.1738724373.git.asml.silence@gmail.com>
References: <cover.1738724373.git.asml.silence@gmail.com>
Precedence: bulk
X-Mailing-List: io-uring@vger.kernel.org
List-Id: <io-uring.vger.kernel.org>
List-Subscribe: <mailto:io-uring+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:io-uring+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

Remove all struct io_buffer caches. It makes it a fair bit simpler.
Apart from from killing a bunch of lines and juggling between lists,
__io_put_kbuf_list() doesn't need ->completion_lock locking now.

Signed-off-by: Pavel Begunkov <asml.silence@gmail.com>
---
 include/linux/io_uring_types.h |  3 --
 io_uring/io_uring.c            |  2 --
 io_uring/kbuf.c                | 57 +++++-----------------------------
 io_uring/kbuf.h                |  5 ++-
 4 files changed, 9 insertions(+), 58 deletions(-)

diff --git a/include/linux/io_uring_types.h b/include/linux/io_uring_types.h
index 3def525a1da37..e2fef264ff8b8 100644
--- a/include/linux/io_uring_types.h
+++ b/include/linux/io_uring_types.h
@@ -360,7 +360,6 @@ struct io_ring_ctx {
 
 	spinlock_t		completion_lock;
 
-	struct list_head	io_buffers_comp;
 	struct list_head	cq_overflow_list;
 
 	struct hlist_head	waitid_list;
@@ -379,8 +378,6 @@ struct io_ring_ctx {
 	unsigned int		file_alloc_start;
 	unsigned int		file_alloc_end;
 
-	struct list_head	io_buffers_cache;
-
 	/* Keep this last, we don't need it for the fast path */
 	struct wait_queue_head		poll_wq;
 	struct io_restriction		restrictions;
diff --git a/io_uring/io_uring.c b/io_uring/io_uring.c
index ed7c9081352a4..969caaccce9d8 100644
--- a/io_uring/io_uring.c
+++ b/io_uring/io_uring.c
@@ -323,7 +323,6 @@ static __cold struct io_ring_ctx *io_ring_ctx_alloc(struct io_uring_params *p)
 	init_waitqueue_head(&ctx->sqo_sq_wait);
 	INIT_LIST_HEAD(&ctx->sqd_list);
 	INIT_LIST_HEAD(&ctx->cq_overflow_list);
-	INIT_LIST_HEAD(&ctx->io_buffers_cache);
 	ret = io_alloc_cache_init(&ctx->apoll_cache, IO_POLL_ALLOC_CACHE_MAX,
 			    sizeof(struct async_poll), 0);
 	ret |= io_alloc_cache_init(&ctx->netmsg_cache, IO_ALLOC_CACHE_MAX,
@@ -348,7 +347,6 @@ static __cold struct io_ring_ctx *io_ring_ctx_alloc(struct io_uring_params *p)
 	spin_lock_init(&ctx->completion_lock);
 	raw_spin_lock_init(&ctx->timeout_lock);
 	INIT_WQ_LIST(&ctx->iopoll_list);
-	INIT_LIST_HEAD(&ctx->io_buffers_comp);
 	INIT_LIST_HEAD(&ctx->defer_list);
 	INIT_LIST_HEAD(&ctx->timeout_list);
 	INIT_LIST_HEAD(&ctx->ltimeout_list);
diff --git a/io_uring/kbuf.c b/io_uring/kbuf.c
index eae6cf502b57f..ef0c06d1bc86f 100644
--- a/io_uring/kbuf.c
+++ b/io_uring/kbuf.c
@@ -70,9 +70,7 @@ bool io_kbuf_recycle_legacy(struct io_kiocb *req, unsigned issue_flags)
 
 void __io_put_kbuf(struct io_kiocb *req, int len, unsigned issue_flags)
 {
-	spin_lock(&req->ctx->completion_lock);
 	__io_put_kbuf_list(req, len);
-	spin_unlock(&req->ctx->completion_lock);
 }
 
 static void __user *io_provided_buffer_select(struct io_kiocb *req, size_t *len,
@@ -345,7 +343,9 @@ static int __io_remove_buffers(struct io_ring_ctx *ctx,
 		struct io_buffer *nxt;
 
 		nxt = list_first_entry(&bl->buf_list, struct io_buffer, list);
-		list_move(&nxt->list, &ctx->io_buffers_cache);
+		list_del(&nxt->list);
+		kfree(nxt);
+
 		if (++i == nbufs)
 			return i;
 		cond_resched();
@@ -363,8 +363,6 @@ static void io_put_bl(struct io_ring_ctx *ctx, struct io_buffer_list *bl)
 void io_destroy_buffers(struct io_ring_ctx *ctx)
 {
 	struct io_buffer_list *bl;
-	struct list_head *item, *tmp;
-	struct io_buffer *buf;
 
 	while (1) {
 		unsigned long index = 0;
@@ -378,19 +376,6 @@ void io_destroy_buffers(struct io_ring_ctx *ctx)
 			break;
 		io_put_bl(ctx, bl);
 	}
-
-	/*
-	 * Move deferred locked entries to cache before pruning
-	 */
-	spin_lock(&ctx->completion_lock);
-	if (!list_empty(&ctx->io_buffers_comp))
-		list_splice_init(&ctx->io_buffers_comp, &ctx->io_buffers_cache);
-	spin_unlock(&ctx->completion_lock);
-
-	list_for_each_safe(item, tmp, &ctx->io_buffers_cache) {
-		buf = list_entry(item, struct io_buffer, list);
-		kfree(buf);
-	}
 }
 
 int io_remove_buffers_prep(struct io_kiocb *req, const struct io_uring_sqe *sqe)
@@ -472,33 +457,6 @@ int io_provide_buffers_prep(struct io_kiocb *req, const struct io_uring_sqe *sqe
 	return 0;
 }
 
-static int io_refill_buffer_cache(struct io_ring_ctx *ctx)
-{
-	struct io_buffer *buf;
-
-	/*
-	 * Completions that don't happen inline (eg not under uring_lock) will
-	 * add to ->io_buffers_comp. If we don't have any free buffers, check
-	 * the completion list and splice those entries first.
-	 */
-	if (!list_empty_careful(&ctx->io_buffers_comp)) {
-		spin_lock(&ctx->completion_lock);
-		if (!list_empty(&ctx->io_buffers_comp)) {
-			list_splice_init(&ctx->io_buffers_comp,
-						&ctx->io_buffers_cache);
-			spin_unlock(&ctx->completion_lock);
-			return 0;
-		}
-		spin_unlock(&ctx->completion_lock);
-	}
-
-	buf = kmalloc(sizeof(*buf), GFP_KERNEL_ACCOUNT);
-	if (!buf)
-		return -ENOMEM;
-	list_add_tail(&buf->list, &ctx->io_buffers_cache);
-	return 0;
-}
-
 static int io_add_buffers(struct io_ring_ctx *ctx, struct io_provide_buf *pbuf,
 			  struct io_buffer_list *bl)
 {
@@ -507,12 +465,11 @@ static int io_add_buffers(struct io_ring_ctx *ctx, struct io_provide_buf *pbuf,
 	int i, bid = pbuf->bid;
 
 	for (i = 0; i < pbuf->nbufs; i++) {
-		if (list_empty(&ctx->io_buffers_cache) &&
-		    io_refill_buffer_cache(ctx))
+		buf = kmalloc(sizeof(*buf), GFP_KERNEL_ACCOUNT);
+		if (!buf)
 			break;
-		buf = list_first_entry(&ctx->io_buffers_cache, struct io_buffer,
-					list);
-		list_move_tail(&buf->list, &bl->buf_list);
+
+		list_add_tail(&buf->list, &bl->buf_list);
 		buf->addr = addr;
 		buf->len = min_t(__u32, pbuf->len, MAX_RW_COUNT);
 		buf->bid = bid;
diff --git a/io_uring/kbuf.h b/io_uring/kbuf.h
index 1f28770648298..c0b9636c5c4ae 100644
--- a/io_uring/kbuf.h
+++ b/io_uring/kbuf.h
@@ -166,8 +166,9 @@ static inline void __io_put_kbuf_list(struct io_kiocb *req, int len)
 		__io_put_kbuf_ring(req, len, 1);
 	} else {
 		req->buf_index = req->kbuf->bgid;
-		list_add(&req->kbuf->list, &req->ctx->io_buffers_comp);
 		req->flags &= ~REQ_F_BUFFER_SELECTED;
+		kfree(req->kbuf);
+		req->kbuf = NULL;
 	}
 }
 
@@ -176,10 +177,8 @@ static inline void io_kbuf_drop(struct io_kiocb *req)
 	if (!(req->flags & (REQ_F_BUFFER_SELECTED|REQ_F_BUFFER_RING)))
 		return;
 
-	spin_lock(&req->ctx->completion_lock);
 	/* len == 0 is fine here, non-ring will always drop all of it */
 	__io_put_kbuf_list(req, 0);
-	spin_unlock(&req->ctx->completion_lock);
 }
 
 static inline unsigned int __io_put_kbufs(struct io_kiocb *req, int len,
-- 
2.47.1


