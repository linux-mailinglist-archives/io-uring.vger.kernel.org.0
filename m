Return-Path: <io-uring+bounces-2260-lists+io-uring=lfdr.de@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from sy.mirrors.kernel.org (sy.mirrors.kernel.org [IPv6:2604:1380:40f1:3f00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 9D2E990DC04
	for <lists+io-uring@lfdr.de>; Tue, 18 Jun 2024 20:56:54 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sy.mirrors.kernel.org (Postfix) with ESMTPS id BFDA9B22355
	for <lists+io-uring@lfdr.de>; Tue, 18 Jun 2024 18:56:51 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 5055715ECCE;
	Tue, 18 Jun 2024 18:56:46 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel-dk.20230601.gappssmtp.com header.i=@kernel-dk.20230601.gappssmtp.com header.b="VbNfz30o"
X-Original-To: io-uring@vger.kernel.org
Received: from mail-oa1-f50.google.com (mail-oa1-f50.google.com [209.85.160.50])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A9FB615ECDE
	for <io-uring@vger.kernel.org>; Tue, 18 Jun 2024 18:56:44 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.160.50
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1718737006; cv=none; b=sTahrzpUQL3ixfTFLFTOxcdV5aD3BWUC1V80kv5ZiWDh7nUgiSjhaqiTuEqhurQHkrVlpw/+DF0Ur7ZoUCOZHTf1mxLyjxvpVohhGAgrYH0f5+MV84B/RVm0X2MMpJcBL5sE1l00ki6WC7NniqhrgMlAuNQkIxCmFVo2TvrinZA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1718737006; c=relaxed/simple;
	bh=WEDhBoYN5pLLdRV/+qAT7wA3ka28+zo2raRt0QVG6Hk=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=LXWqi3CA4kyI7zgAz9V6ppyDXd1SOVzmv4xTp7/JjAw360UrN9BgATxruY+i9kf45n2hoSf17Sp/qRxQ5eAOm10o9BjPCO2ezAhNQhAu9ALhmwfLrf8dZ2O8oXyJwrH4m8fJfAMn4Djmd2uxG8xS8b4vY4Tay6cEtZZ0zD+waDE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=kernel.dk; spf=pass smtp.mailfrom=kernel.dk; dkim=pass (2048-bit key) header.d=kernel-dk.20230601.gappssmtp.com header.i=@kernel-dk.20230601.gappssmtp.com header.b=VbNfz30o; arc=none smtp.client-ip=209.85.160.50
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=kernel.dk
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=kernel.dk
Received: by mail-oa1-f50.google.com with SMTP id 586e51a60fabf-25075f3f472so798356fac.2
        for <io-uring@vger.kernel.org>; Tue, 18 Jun 2024 11:56:44 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernel-dk.20230601.gappssmtp.com; s=20230601; t=1718737003; x=1719341803; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=PXJyIJemjNC4yU1UV6G6l8eOfwcbX9iQfdK4+39fx6Q=;
        b=VbNfz30oSgYKD42AtwOkWs5kthv80Clss3q+sjpb9HZWLo8CkwxFMtwjJybZCoEpqb
         qIQ9UrG/OFaFWWhc4jdmThajddqJ2w71IEt7vcSrcwFuE1wZvwmCPSoDsUcsajIe0Qkx
         ejD6EQg7zyQnX0YvTcscchTR8l6xDOfdQjXWmM/XWOUXfmW5svDmR1jsmOFomR+vlGtI
         7fneCcIwpG+x8B7zOzJchFhe5GHhoJHWVnW2TK8kQjY7RV9vHmzmsIUBUZfX8qYHvh2f
         logwZ3H2uY3apwBfpmwWS2qReAubD/iq0qAmmqRIQ0yYbJJt0J0ZOlQJkrioI3LwHWrb
         SShw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1718737003; x=1719341803;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=PXJyIJemjNC4yU1UV6G6l8eOfwcbX9iQfdK4+39fx6Q=;
        b=RZIUiznX9TBj2Ag/LYmO5YaMKFfl7rKmPd4ja3KtMW33LSpUK3VS/SMlIhjp1BhpP6
         H3ivF07DriL5pwp6lgO1gSCIdbuFjzAKvr8L795yJnalPT+jHdRPS4KP3ouR3xg6wiHs
         ZcP0P7gxQAYpKhEbAAhFiXOJNbLwWMT8PQp1BFpRXaxjiffl9RYTqPgbZTAjXDrxQeD0
         vghbPOZgdVNbzSzuHTv5suKt8P7BwcyLlEXMiGBJCUS93MDKo7ePvNf9qdsdR7ttxStx
         xHLrVAeR1BodI5qCBpPRVUpA4Bv3wPadCjqV/ZJOkLZ4oNO1LJOnhFgGXWvQXU5X808D
         OLnw==
X-Gm-Message-State: AOJu0Yzma+dzfn5/nQAM4gtv+IEncBwrmvKOmRRLz2D9VzQTb0BYqb2g
	reYIQaDk9uGjK2RzGFb4siqthjvTF/H4kcrYx3wn/XIB4lnJd5TugDvl7eypF6aJxj8wh15H7bF
	p
X-Google-Smtp-Source: AGHT+IFnG9Qpqarvqyd8b59T09u0HxIYK1LWUKhFkxwOXUp6jee4erPuKg8LqqewlNFmZNGF0Jbo9w==
X-Received: by 2002:a05:6870:a2cc:b0:254:affe:5a08 with SMTP id 586e51a60fabf-25c94983780mr709673fac.2.1718737003295;
        Tue, 18 Jun 2024 11:56:43 -0700 (PDT)
Received: from localhost.localdomain ([96.43.243.2])
        by smtp.gmail.com with ESMTPSA id 586e51a60fabf-2567a9f7d6fsm3255492fac.20.2024.06.18.11.56.42
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 18 Jun 2024 11:56:42 -0700 (PDT)
From: Jens Axboe <axboe@kernel.dk>
To: io-uring@vger.kernel.org
Cc: asml.silence@gmail.com,
	Jens Axboe <axboe@kernel.dk>
Subject: [PATCH 5/5] io_uring/msg_ring: add an alloc cache for io_kiocb entries
Date: Tue, 18 Jun 2024 12:48:44 -0600
Message-ID: <20240618185631.71781-6-axboe@kernel.dk>
X-Mailer: git-send-email 2.43.0
In-Reply-To: <20240618185631.71781-1-axboe@kernel.dk>
References: <20240618185631.71781-1-axboe@kernel.dk>
Precedence: bulk
X-Mailing-List: io-uring@vger.kernel.org
List-Id: <io-uring.vger.kernel.org>
List-Subscribe: <mailto:io-uring+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:io-uring+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

With slab accounting, allocating and freeing memory has considerable
overhead. Add a basic alloc cache for the io_kiocb allocations that
msg_ring needs to do. Unlike other caches, this one is used by the
sender, grabbing it from the remote ring. When the remote ring gets
the posted completion, it'll free it locally. Hence it is separately
locked, using ctx->msg_lock.

Signed-off-by: Jens Axboe <axboe@kernel.dk>
---
 include/linux/io_uring_types.h |  3 +++
 io_uring/io_uring.c            |  6 ++++++
 io_uring/msg_ring.c            | 31 +++++++++++++++++++++++++++++--
 io_uring/msg_ring.h            |  1 +
 4 files changed, 39 insertions(+), 2 deletions(-)

diff --git a/include/linux/io_uring_types.h b/include/linux/io_uring_types.h
index 1052a68fd68d..ede42dce1506 100644
--- a/include/linux/io_uring_types.h
+++ b/include/linux/io_uring_types.h
@@ -397,6 +397,9 @@ struct io_ring_ctx {
 	struct callback_head		poll_wq_task_work;
 	struct list_head		defer_list;
 
+	struct io_alloc_cache		msg_cache;
+	spinlock_t			msg_lock;
+
 #ifdef CONFIG_NET_RX_BUSY_POLL
 	struct list_head	napi_list;	/* track busy poll napi_id */
 	spinlock_t		napi_lock;	/* napi_list lock */
diff --git a/io_uring/io_uring.c b/io_uring/io_uring.c
index cdeb94d2a26b..7ed1e009aaec 100644
--- a/io_uring/io_uring.c
+++ b/io_uring/io_uring.c
@@ -95,6 +95,7 @@
 #include "futex.h"
 #include "napi.h"
 #include "uring_cmd.h"
+#include "msg_ring.h"
 #include "memmap.h"
 
 #include "timeout.h"
@@ -315,6 +316,9 @@ static __cold struct io_ring_ctx *io_ring_ctx_alloc(struct io_uring_params *p)
 			    sizeof(struct io_async_rw));
 	ret |= io_alloc_cache_init(&ctx->uring_cache, IO_ALLOC_CACHE_MAX,
 			    sizeof(struct uring_cache));
+	spin_lock_init(&ctx->msg_lock);
+	ret |= io_alloc_cache_init(&ctx->msg_cache, IO_ALLOC_CACHE_MAX,
+			    sizeof(struct io_kiocb));
 	ret |= io_futex_cache_init(ctx);
 	if (ret)
 		goto err;
@@ -351,6 +355,7 @@ static __cold struct io_ring_ctx *io_ring_ctx_alloc(struct io_uring_params *p)
 	io_alloc_cache_free(&ctx->netmsg_cache, io_netmsg_cache_free);
 	io_alloc_cache_free(&ctx->rw_cache, io_rw_cache_free);
 	io_alloc_cache_free(&ctx->uring_cache, kfree);
+	io_alloc_cache_free(&ctx->msg_cache, io_msg_cache_free);
 	io_futex_cache_free(ctx);
 	kfree(ctx->cancel_table.hbs);
 	kfree(ctx->cancel_table_locked.hbs);
@@ -2599,6 +2604,7 @@ static __cold void io_ring_ctx_free(struct io_ring_ctx *ctx)
 	io_alloc_cache_free(&ctx->netmsg_cache, io_netmsg_cache_free);
 	io_alloc_cache_free(&ctx->rw_cache, io_rw_cache_free);
 	io_alloc_cache_free(&ctx->uring_cache, kfree);
+	io_alloc_cache_free(&ctx->msg_cache, io_msg_cache_free);
 	io_futex_cache_free(ctx);
 	io_destroy_buffers(ctx);
 	mutex_unlock(&ctx->uring_lock);
diff --git a/io_uring/msg_ring.c b/io_uring/msg_ring.c
index ad7d67d44461..47a754e83b49 100644
--- a/io_uring/msg_ring.c
+++ b/io_uring/msg_ring.c
@@ -11,6 +11,7 @@
 #include "io_uring.h"
 #include "rsrc.h"
 #include "filetable.h"
+#include "alloc_cache.h"
 #include "msg_ring.h"
 
 /* All valid masks for MSG_RING */
@@ -75,7 +76,13 @@ static void io_msg_tw_complete(struct io_kiocb *req, struct io_tw_state *ts)
 	struct io_ring_ctx *ctx = req->ctx;
 
 	io_add_aux_cqe(ctx, req->cqe.user_data, req->cqe.res, req->cqe.flags);
-	kmem_cache_free(req_cachep, req);
+	if (spin_trylock(&ctx->msg_lock)) {
+		if (io_alloc_cache_put(&ctx->msg_cache, req))
+			req = NULL;
+		spin_unlock(&ctx->msg_lock);
+	}
+	if (req)
+		kfree(req);
 	percpu_ref_put(&ctx->refs);
 }
 
@@ -91,6 +98,19 @@ static void io_msg_remote_post(struct io_ring_ctx *ctx, struct io_kiocb *req,
 	io_req_task_work_add_remote(req, ctx, IOU_F_TWQ_LAZY_WAKE);
 }
 
+static struct io_kiocb *io_msg_get_kiocb(struct io_ring_ctx *ctx)
+{
+	struct io_kiocb *req = NULL;
+
+	if (spin_trylock(&ctx->msg_lock)) {
+		req = io_alloc_cache_get(&ctx->msg_cache);
+		spin_unlock(&ctx->msg_lock);
+	}
+	if (req)
+		return req;
+	return kmem_cache_alloc(req_cachep, GFP_KERNEL | __GFP_NOWARN);
+}
+
 static int io_msg_data_remote(struct io_kiocb *req)
 {
 	struct io_ring_ctx *target_ctx = req->file->private_data;
@@ -98,7 +118,7 @@ static int io_msg_data_remote(struct io_kiocb *req)
 	struct io_kiocb *target;
 	u32 flags = 0;
 
-	target = kmem_cache_alloc(req_cachep, GFP_KERNEL);
+	target = io_msg_get_kiocb(req->ctx);
 	if (unlikely(!target))
 		return -ENOMEM;
 
@@ -296,3 +316,10 @@ int io_msg_ring(struct io_kiocb *req, unsigned int issue_flags)
 	io_req_set_res(req, ret, 0);
 	return IOU_OK;
 }
+
+void io_msg_cache_free(const void *entry)
+{
+	struct io_kiocb *req = (struct io_kiocb *) entry;
+
+	kmem_cache_free(req_cachep, req);
+}
diff --git a/io_uring/msg_ring.h b/io_uring/msg_ring.h
index 3987ee6c0e5f..3030f3942f0f 100644
--- a/io_uring/msg_ring.h
+++ b/io_uring/msg_ring.h
@@ -3,3 +3,4 @@
 int io_msg_ring_prep(struct io_kiocb *req, const struct io_uring_sqe *sqe);
 int io_msg_ring(struct io_kiocb *req, unsigned int issue_flags);
 void io_msg_ring_cleanup(struct io_kiocb *req);
+void io_msg_cache_free(const void *entry);
-- 
2.43.0


