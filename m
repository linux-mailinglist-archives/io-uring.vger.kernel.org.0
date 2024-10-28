Return-Path: <io-uring+bounces-4074-lists+io-uring=lfdr.de@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [IPv6:2604:1380:45e3:2400::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 998B39B3451
	for <lists+io-uring@lfdr.de>; Mon, 28 Oct 2024 16:04:59 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 5A4D32812C5
	for <lists+io-uring@lfdr.de>; Mon, 28 Oct 2024 15:04:58 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 255401DD0DB;
	Mon, 28 Oct 2024 15:04:55 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel-dk.20230601.gappssmtp.com header.i=@kernel-dk.20230601.gappssmtp.com header.b="aBTtE8fl"
X-Original-To: io-uring@vger.kernel.org
Received: from mail-il1-f172.google.com (mail-il1-f172.google.com [209.85.166.172])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 089361DE3B4
	for <io-uring@vger.kernel.org>; Mon, 28 Oct 2024 15:04:52 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.166.172
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1730127895; cv=none; b=K9hy441yU/zg3ALMJtN5zpd++oGFERRSeVUwKJaNrZGnVySZp7yAJZL3br4qEwhCNRaSZB5d7Q13/ZhSJaAlfMRWWtPthkonZifi+jySN+sG8EBPDoZx2KiIXfyllE1sdXKkFXCIyJdri3TZXqXSWfjlyQJM6aVQxLepKILyrQQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1730127895; c=relaxed/simple;
	bh=Fo/frzSKlv4OyiJGKpbBRm4RdvJKEoEHG1D8QYdklYc=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=QCs7pttQHPx/eWdmXQYx1K0Tzt8LOKYLQYhE1z5Kkx0/YUc/Flfr8M71uiCdeK4WkeKBT+ytTU58oYcuF46ZTSo7qkuiw7hpg+IZi10rVZrpy+029Uj7ooxNV51+Vsgx5KoTCoDKjW6XffsGdxtRJfhlhzZsXarY4wEen2xTnY8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=kernel.dk; spf=pass smtp.mailfrom=kernel.dk; dkim=pass (2048-bit key) header.d=kernel-dk.20230601.gappssmtp.com header.i=@kernel-dk.20230601.gappssmtp.com header.b=aBTtE8fl; arc=none smtp.client-ip=209.85.166.172
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=kernel.dk
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=kernel.dk
Received: by mail-il1-f172.google.com with SMTP id e9e14a558f8ab-3a4d2d028b3so16367175ab.1
        for <io-uring@vger.kernel.org>; Mon, 28 Oct 2024 08:04:52 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernel-dk.20230601.gappssmtp.com; s=20230601; t=1730127891; x=1730732691; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=GJ3VbKxyariUHBQbk+XVcQESHHWp/zX87MdRysrKFDA=;
        b=aBTtE8fl0Vb0S1nbBvG9fpxL8muszqJTmQldY1OoX7Cw1TWsBW3aL2CCVMwRXPqm1I
         h+KwiPSthUluOBjl+WXAb4xB+2A5vTPiij07taztjaCjuXTGjLd5RhALVGPJej8ivmhD
         +fPA0svzLTNonlJnXjiKZrXrDQFHWeCF1Ip6uj+WwTgfonnxVuNB75U+CuEvLFOx/E9H
         dQ6i/6iuQnSWpwVIhDwDwAS0AbwHdqmhiEv4gBWx0rSInW4C6lk3p7kj4dUhPSZr2GqI
         ajxE+GHGwk6a4UWr9NnfDmOO6k9tQRohOS00HG0xTPeUYf1rLqi16c/qYCDvGoHVFrsC
         VbRg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1730127891; x=1730732691;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=GJ3VbKxyariUHBQbk+XVcQESHHWp/zX87MdRysrKFDA=;
        b=dNCJF/VL9y2JA54/4ZJivld+WIa1gGClt+FDf+mwnPJR25mPBLRMpCPjTaic6BIr05
         CIy6erZgOqhikuBJmafoIhCX0e74+2pqYZh+oVEJf+x90whqLplMsIHdBtmb31eEnvhp
         yOPm/vraJqq8YRoKk1uBCs4v+Xto7St+KZ4R+PePkISH+2Odr76PKiIgNbpg4FreR/Z2
         C9/OHAoq7GsR8d+sh31Uo6L3E/qLBRTWTtzjSgnByL7edVHuOl7lRyCz4E5iqlh5++HE
         QgRxAbK49RYGzebVBE61T8gRzOm+UANZeuP6lvEfRq/j76q9vkOx/9xtEJdVlhM7++C2
         TNYg==
X-Gm-Message-State: AOJu0YwkZgsNlMXjnG9HaSv8ZgnRQp+MRooDChjaNIJKKMUw8AthSvHZ
	B/7CfuMaR89ir8ANygSIXu/OOrSfp93qch7NdmZv+rWml0aJvLZ+hY3etHglGiheYwGojJTlD5E
	g
X-Google-Smtp-Source: AGHT+IES7Jd6cCdJRy1MXc+PrwXrR23NQwRLXweEj2Rq4VrwSLsz0xX2jxdzSutkXImW2Nl3eMClCQ==
X-Received: by 2002:a05:6e02:17ce:b0:3a3:b254:ca2c with SMTP id e9e14a558f8ab-3a4ed3524e1mr78114455ab.25.1730127891270;
        Mon, 28 Oct 2024 08:04:51 -0700 (PDT)
Received: from localhost.localdomain ([96.43.243.2])
        by smtp.gmail.com with ESMTPSA id 8926c6da1cb9f-4dc7261c7e3sm1721616173.72.2024.10.28.08.04.50
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 28 Oct 2024 08:04:50 -0700 (PDT)
From: Jens Axboe <axboe@kernel.dk>
To: io-uring@vger.kernel.org
Cc: Jens Axboe <axboe@kernel.dk>
Subject: [PATCH 07/13] io_uring/rsrc: get rid of io_rsrc_node allocation cache
Date: Mon, 28 Oct 2024 08:52:37 -0600
Message-ID: <20241028150437.387667-8-axboe@kernel.dk>
X-Mailer: git-send-email 2.45.2
In-Reply-To: <20241028150437.387667-1-axboe@kernel.dk>
References: <20241028150437.387667-1-axboe@kernel.dk>
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
 io_uring/rsrc.c                | 22 ++++++++--------------
 3 files changed, 9 insertions(+), 22 deletions(-)

diff --git a/include/linux/io_uring_types.h b/include/linux/io_uring_types.h
index 42c5f2c992c4..696f2a05a98b 100644
--- a/include/linux/io_uring_types.h
+++ b/include/linux/io_uring_types.h
@@ -370,9 +370,6 @@ struct io_ring_ctx {
 	struct io_rsrc_data		*file_data;
 	struct io_rsrc_data		*buf_data;
 
-	/* protected by ->uring_lock */
-	struct io_alloc_cache		rsrc_node_cache;
-
 	u32			pers_next;
 	struct xarray		personalities;
 
diff --git a/io_uring/io_uring.c b/io_uring/io_uring.c
index 0876aa74c739..094788cca47f 100644
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
@@ -2740,7 +2737,6 @@ static __cold void io_ring_ctx_free(struct io_ring_ctx *ctx)
 
 	WARN_ON_ONCE(!list_empty(&ctx->ltimeout_list));
 
-	io_alloc_cache_free(&ctx->rsrc_node_cache, kfree);
 	if (ctx->mm_account) {
 		mmdrop(ctx->mm_account);
 		ctx->mm_account = NULL;
diff --git a/io_uring/rsrc.c b/io_uring/rsrc.c
index cc93d0c2df4c..1ba7f3e55947 100644
--- a/io_uring/rsrc.c
+++ b/io_uring/rsrc.c
@@ -13,7 +13,6 @@
 #include <uapi/linux/io_uring.h>
 
 #include "io_uring.h"
-#include "alloc_cache.h"
 #include "openclose.h"
 #include "rsrc.h"
 #include "memmap.h"
@@ -132,18 +131,14 @@ struct io_rsrc_node *io_rsrc_node_alloc(struct io_ring_ctx *ctx,
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
+		node->tag = 0;
+		node->rsrc = NULL;
 	}
-
-	node->ctx = ctx;
-	node->refs = 1;
-	node->type = type;
-	node->tag = 0;
-	node->rsrc = NULL;
 	return node;
 }
 
@@ -492,8 +487,7 @@ void io_free_rsrc_node(struct io_rsrc_node *node)
 		break;
 	}
 
-	if (!io_alloc_cache_put(&ctx->rsrc_node_cache, node))
-		kfree(node);
+	kfree(node);
 }
 
 static void __io_sqe_files_unregister(struct io_ring_ctx *ctx)
-- 
2.45.2


