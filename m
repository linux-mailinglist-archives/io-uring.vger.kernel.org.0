Return-Path: <io-uring+bounces-4051-lists+io-uring=lfdr.de@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [139.178.88.99])
	by mail.lfdr.de (Postfix) with ESMTPS id CA9DB9B1B48
	for <lists+io-uring@lfdr.de>; Sun, 27 Oct 2024 00:24:06 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 84D832828F1
	for <lists+io-uring@lfdr.de>; Sat, 26 Oct 2024 22:24:05 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id BA3441D47AC;
	Sat, 26 Oct 2024 22:24:04 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel-dk.20230601.gappssmtp.com header.i=@kernel-dk.20230601.gappssmtp.com header.b="Dc/lqAq9"
X-Original-To: io-uring@vger.kernel.org
Received: from mail-pl1-f177.google.com (mail-pl1-f177.google.com [209.85.214.177])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 35AAD1D461B
	for <io-uring@vger.kernel.org>; Sat, 26 Oct 2024 22:24:01 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.214.177
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1729981444; cv=none; b=Ar9s87jqcIHDDc1P6Xe5MqXizM4azFEn1EDQ5x1cq+BrWpUulQAgxZWVV/V8xVVLW7EVE0RRAMitBo5YhxzNJDIqO4I6mgJ4OST5B5M4HBhFH5MIenDHFNkudTfOcRH0muDz1eVcvZNgDv8h5nehpzzCmQL7og++dQ72DhxiFDc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1729981444; c=relaxed/simple;
	bh=HaRHgExVHYvR3LpjtwRGLKGiWieHlxX77HTAFVNc2lk=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=KAPOkGj6XP2If7Nnyv1Ur39GekrMqeD3eXxjtYgi9nAvbr0xKpbZnO3WvzesA+MR+MpHcWVIn6DXASqgJeMQH1nFPLtTQOfnmya0FdYZzoIcDOBxoR8MTXCU0aMRbASiV2yfkwg7MIWCuGK7SGUd6hNE2Tn7RnvTzP/MpgF7NG0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=kernel.dk; spf=pass smtp.mailfrom=kernel.dk; dkim=pass (2048-bit key) header.d=kernel-dk.20230601.gappssmtp.com header.i=@kernel-dk.20230601.gappssmtp.com header.b=Dc/lqAq9; arc=none smtp.client-ip=209.85.214.177
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=kernel.dk
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=kernel.dk
Received: by mail-pl1-f177.google.com with SMTP id d9443c01a7336-20ce65c8e13so26440555ad.1
        for <io-uring@vger.kernel.org>; Sat, 26 Oct 2024 15:24:01 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernel-dk.20230601.gappssmtp.com; s=20230601; t=1729981441; x=1730586241; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=nJ1XKYylAS5g6MXJsNyLduviD0yVNQeg99x/fT/sC04=;
        b=Dc/lqAq9X+z2PfyMkJ4BkqnFCmST3bMoVcWYha2F1eEGCHne3gcKztmk6n5H5CWNSR
         LEMOk5IwizeZa+iMxoLqU0vvuaW070PZ4GO7uwRogHdel+K8Whc7RMZQXnx9YWmB3rlL
         pAPUSnIvv6/2OVK+lZ9R4iqWzGlZ2ebxMY7n4molmFehjb/COoSN3REJlORSA4J9G2ah
         OqTQk8yYUMN/Nu0aFWR0kKVZIFWlXDxEQR6v5hCbmz8jiFUK48QpWeuk4u1AqsorcSJp
         DJhiO5yjyO5ukRKlOutOvFEy9p0A3y5k7LvVhsPY9YgGXKpifERVbP84bUIo+7uRYEeb
         hyGg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1729981441; x=1730586241;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=nJ1XKYylAS5g6MXJsNyLduviD0yVNQeg99x/fT/sC04=;
        b=OYT4Jnm0uft71B2s8B1NFmyU+DBX+Tjz9k6eedPaS6xP0Hld3kwmthVHjNksH6lUM0
         rzT/0fmdI1NHTLjTHlA0lcng+22TPaZ0yIyEYBVKni/qfeFwNJeWwzK7p3jTmR4t0N4O
         Ie84L6raOmofL1+LMB726NtSLiNeBOpDiwaOL4cpuP5/BS9ihRzjUlEZERJ7gJAPJWo/
         +pz3Ecfbu646sNQF1oSRBqUX/E9q1uSB/lpox0/9iYwiaJ5b7KEufdNIKH0VNzoxcBJb
         TFBKY0ha0hIm63YiZOjzrhLYkG7stzFkuY18r/eHVNlIxx5NXeHfzILiW5j0s9Shdxhb
         fUKg==
X-Gm-Message-State: AOJu0Yyws4Bv49xHBWX69TiAwWckqpv5oqf5fsYMfjCKBIU6d0RP6GeR
	WSsDB+7h1+ZgRhf+nFOkLh+eubqvEN6WFRqAg0nsDsoWvG/5AzRU+fAexFGWIZWbwF6c4sUi6dL
	R
X-Google-Smtp-Source: AGHT+IE0xY3wQDfeJVACMmH/M1N1re9d95M8pZ0OMm8G+QPRBIZRlTct7bV3DurAT8Tu+mjk07n/ag==
X-Received: by 2002:a17:902:dac9:b0:20c:f3be:2f82 with SMTP id d9443c01a7336-210c6c82bb4mr44970015ad.33.1729981440986;
        Sat, 26 Oct 2024 15:24:00 -0700 (PDT)
Received: from localhost.localdomain ([198.8.77.157])
        by smtp.gmail.com with ESMTPSA id d9443c01a7336-210bbf44321sm28134705ad.30.2024.10.26.15.23.58
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sat, 26 Oct 2024 15:23:59 -0700 (PDT)
From: Jens Axboe <axboe@kernel.dk>
To: io-uring@vger.kernel.org
Cc: Jens Axboe <axboe@kernel.dk>
Subject: [PATCH 4/7] io_uring/rsrc: get rid of io_rsrc_node allocation cache
Date: Sat, 26 Oct 2024 16:08:29 -0600
Message-ID: <20241026222348.90331-5-axboe@kernel.dk>
X-Mailer: git-send-email 2.45.2
In-Reply-To: <20241026222348.90331-1-axboe@kernel.dk>
References: <20241026222348.90331-1-axboe@kernel.dk>
Precedence: bulk
X-Mailing-List: io-uring@vger.kernel.org
List-Id: <io-uring.vger.kernel.org>
List-Subscribe: <mailto:io-uring+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:io-uring+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

It's not going to be needed in the fast path going forward, so kill it
off.

Signed-off-by: Jens Axboe <axboe@kernel.dk>
---
 include/linux/io_uring_types.h |  3 ---
 io_uring/io_uring.c            |  6 +-----
 io_uring/rsrc.c                | 24 +++++++++---------------
 3 files changed, 10 insertions(+), 23 deletions(-)

diff --git a/include/linux/io_uring_types.h b/include/linux/io_uring_types.h
index 93111d87a88a..60541da6b875 100644
--- a/include/linux/io_uring_types.h
+++ b/include/linux/io_uring_types.h
@@ -362,9 +362,6 @@ struct io_ring_ctx {
 	struct io_rsrc_data		*file_data;
 	struct io_rsrc_data		*buf_data;
 
-	/* protected by ->uring_lock */
-	struct io_alloc_cache		rsrc_node_cache;
-
 	u32			pers_next;
 	struct xarray		personalities;
 
diff --git a/io_uring/io_uring.c b/io_uring/io_uring.c
index 95ad74993a3f..8e24373c1c98 100644
--- a/io_uring/io_uring.c
+++ b/io_uring/io_uring.c
@@ -312,9 +312,7 @@ static __cold struct io_ring_ctx *io_ring_ctx_alloc(struct io_uring_params *p)
 	INIT_LIST_HEAD(&ctx->sqd_list);
 	INIT_LIST_HEAD(&ctx->cq_overflow_list);
 	INIT_LIST_HEAD(&ctx->io_buffers_cache);
-	ret = io_alloc_cache_init(&ctx->rsrc_node_cache, IO_NODE_ALLOC_CACHE_MAX,
-			    sizeof(struct io_rsrc_node));
-	ret |= io_alloc_cache_init(&ctx->apoll_cache, IO_POLL_ALLOC_CACHE_MAX,
+	ret = io_alloc_cache_init(&ctx->apoll_cache, IO_POLL_ALLOC_CACHE_MAX,
 			    sizeof(struct async_poll));
 	ret |= io_alloc_cache_init(&ctx->netmsg_cache, IO_ALLOC_CACHE_MAX,
 			    sizeof(struct io_async_msghdr));
@@ -358,7 +356,6 @@ static __cold struct io_ring_ctx *io_ring_ctx_alloc(struct io_uring_params *p)
 free_ref:
 	percpu_ref_exit(&ctx->refs);
 err:
-	io_alloc_cache_free(&ctx->rsrc_node_cache, kfree);
 	io_alloc_cache_free(&ctx->apoll_cache, kfree);
 	io_alloc_cache_free(&ctx->netmsg_cache, io_netmsg_cache_free);
 	io_alloc_cache_free(&ctx->rw_cache, io_rw_cache_free);
@@ -2743,7 +2740,6 @@ static __cold void io_ring_ctx_free(struct io_ring_ctx *ctx)
 
 	WARN_ON_ONCE(!list_empty(&ctx->ltimeout_list));
 
-	io_alloc_cache_free(&ctx->rsrc_node_cache, kfree);
 	if (ctx->mm_account) {
 		mmdrop(ctx->mm_account);
 		ctx->mm_account = NULL;
diff --git a/io_uring/rsrc.c b/io_uring/rsrc.c
index 9822222a7acb..322749c7dee9 100644
--- a/io_uring/rsrc.c
+++ b/io_uring/rsrc.c
@@ -13,7 +13,6 @@
 #include <uapi/linux/io_uring.h>
 
 #include "io_uring.h"
-#include "alloc_cache.h"
 #include "openclose.h"
 #include "rsrc.h"
 #include "memmap.h"
@@ -132,19 +131,15 @@ struct io_rsrc_node *io_rsrc_node_alloc(struct io_ring_ctx *ctx,
 {
 	struct io_rsrc_node *node;
 
-	node = io_alloc_cache_get(&ctx->rsrc_node_cache);
-	if (!node) {
-		node = kzalloc(sizeof(*node), GFP_KERNEL);
-		if (!node)
-			return NULL;
+	node = kzalloc(sizeof(*node), GFP_KERNEL);
+	if (node) {
+		node->ctx = ctx;
+		node->refs = 1;
+		node->type = type;
+		node->index = index;
+		node->tag = 0;
+		node->rsrc = NULL;
 	}
-
-	node->ctx = ctx;
-	node->refs = 1;
-	node->type = type;
-	node->index = index;
-	node->tag = 0;
-	node->rsrc = NULL;
 	return node;
 }
 
@@ -493,8 +488,7 @@ void io_free_rsrc_node(struct io_rsrc_node *node)
 		break;
 	}
 
-	if (!io_alloc_cache_put(&ctx->rsrc_node_cache, node))
-		kfree(node);
+	kfree(node);
 }
 
 static void __io_sqe_files_unregister(struct io_ring_ctx *ctx)
-- 
2.45.2


