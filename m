Return-Path: <io-uring+bounces-4109-lists+io-uring=lfdr.de@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [IPv6:2604:1380:45e3:2400::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 961B59B4DB9
	for <lists+io-uring@lfdr.de>; Tue, 29 Oct 2024 16:23:51 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 54EE0281A43
	for <lists+io-uring@lfdr.de>; Tue, 29 Oct 2024 15:23:50 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id D3C5C195808;
	Tue, 29 Oct 2024 15:23:14 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel-dk.20230601.gappssmtp.com header.i=@kernel-dk.20230601.gappssmtp.com header.b="n39jF4pQ"
X-Original-To: io-uring@vger.kernel.org
Received: from mail-io1-f41.google.com (mail-io1-f41.google.com [209.85.166.41])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B74CD1957E2
	for <io-uring@vger.kernel.org>; Tue, 29 Oct 2024 15:23:12 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.166.41
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1730215394; cv=none; b=qdwov7NGpkr0dG/FHd3SGOmpgGmO5fDClIhq75qkCJCWR4gQwzkAeOdypp3/eRR6bfYBvjdxYJzeZqb0gxr3ZXwLlqyGPPWVaneWBkjNv4SSOkkMaskxl8On8OFT6vtKjp0tQVdkx7YY3K1CY+e2LW/V1lRhu1ybCSiX9qKiFTA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1730215394; c=relaxed/simple;
	bh=XWTjycJNGezjwQNpGO6yWqozhi9nGJETzkw/g1JhUnc=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=ZcAajUyzlM3Hq0oY9C/+uOpG8bUewxhjfGQ4HgqCAschVsl7VUlqpSsMLq5OyIhe8MmXjifev+iWGcNEgtbqmGZ1jExsnPuV/s2uT+ygHLXlZqHbehroRA3HhsxQAkYEzu8e2nc9cdksNRU1j0BwfRb0yrZSGQ495Hj3qWjPh6M=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=kernel.dk; spf=pass smtp.mailfrom=kernel.dk; dkim=pass (2048-bit key) header.d=kernel-dk.20230601.gappssmtp.com header.i=@kernel-dk.20230601.gappssmtp.com header.b=n39jF4pQ; arc=none smtp.client-ip=209.85.166.41
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=kernel.dk
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=kernel.dk
Received: by mail-io1-f41.google.com with SMTP id ca18e2360f4ac-83aa3ced341so213629339f.0
        for <io-uring@vger.kernel.org>; Tue, 29 Oct 2024 08:23:12 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernel-dk.20230601.gappssmtp.com; s=20230601; t=1730215391; x=1730820191; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=8DnQshDir80p0zue4y/aQViw49t3hlJtFYMH8XjWl8c=;
        b=n39jF4pQ0wphC1orvwHujuq+r9fHVAm/p0wkUpRteG8e3HO/zoUQC67nKTrFLFmcts
         sVqkQDG1beIIdGoZ7BphTHcNNaIk+KiQupATFzrMFRS4VvM381p76xeYcfPRn6rjQels
         HIoLjf2TZcYCF8cDZE0jccB5CjVmhaduXYI0fjWC8+5Fo0iDZpGytHUaZ1IypcCe1ADA
         qdX9NNGUBWwa8Fth1paPJwvUpriPSXlFNJKn26VWNcxwr2xSxxJjYGjHphmvnU5K0zA8
         aMhjM2D6ycasNIzj5IXiA6ki9CaNlOX0Qo1vG+67TL0Byfye4+dfp8/VR/o2vkSPRrLw
         VaWg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1730215391; x=1730820191;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=8DnQshDir80p0zue4y/aQViw49t3hlJtFYMH8XjWl8c=;
        b=RR4RQesznQIhFrKUr+fCn4RM9gye+DMDP5IGYlrGQPMwxLp+RBOvWXUz00/oU7hkL1
         R75ymJJ/HME8AWVJUWos/Kb5Y8uuZrvvDl2NFXey/yIQ2ixo3juA0j4JcQwwPYaQGWLt
         w4mLVvqMjmN4ZkG4yOE23jDqmPip8Q8B0WDuVlZLatrLRQ4crCJIZWfLupL+BDi/82ir
         i1oVniI7SoL4e8ouxB0hTG+V/wQT9F/wrXDTEOSwYsrjc9zh1TusrJzJz/BKhN+3Ot6O
         C5a/wnj7JvJx+6anC0CfwY+gTrvIE4NslkCls5S9DL/Am49R7E1+BEQ0GGR5J6hp2fUw
         L/mA==
X-Gm-Message-State: AOJu0YyDO6sdOKvJw6aFNBbKoTcp53+L8/PxbAlon1qplhnJE1qCUg50
	wBOQddAPTSEyOe4XdDaas7tbe9ActOjrYq04zVah3MLhnIJSKqBjqmfoirtXBPscfRlFiRRIOQW
	a
X-Google-Smtp-Source: AGHT+IGau73ja+HiZ0WHm5SGBK0AM3xYqxLkc0m0LdOpRN8F1LEJ9d3VxFkoaBJsI/Q6CGpKnzdPIw==
X-Received: by 2002:a05:6602:641c:b0:83a:a8c6:21ad with SMTP id ca18e2360f4ac-83b1c41a25amr1139322739f.7.1730215391397;
        Tue, 29 Oct 2024 08:23:11 -0700 (PDT)
Received: from localhost.localdomain ([96.43.243.2])
        by smtp.gmail.com with ESMTPSA id 8926c6da1cb9f-4dc725eb58esm2434160173.27.2024.10.29.08.23.10
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 29 Oct 2024 08:23:10 -0700 (PDT)
From: Jens Axboe <axboe@kernel.dk>
To: io-uring@vger.kernel.org
Cc: Jens Axboe <axboe@kernel.dk>
Subject: [PATCH 07/14] io_uring/rsrc: get rid of io_rsrc_node allocation cache
Date: Tue, 29 Oct 2024 09:16:36 -0600
Message-ID: <20241029152249.667290-8-axboe@kernel.dk>
X-Mailer: git-send-email 2.45.2
In-Reply-To: <20241029152249.667290-1-axboe@kernel.dk>
References: <20241029152249.667290-1-axboe@kernel.dk>
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
 io_uring/rsrc.c                | 18 ++++++------------
 3 files changed, 7 insertions(+), 20 deletions(-)

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
index e32c4d1bef86..16e769ebca87 100644
--- a/io_uring/rsrc.c
+++ b/io_uring/rsrc.c
@@ -13,7 +13,6 @@
 #include <uapi/linux/io_uring.h>
 
 #include "io_uring.h"
-#include "alloc_cache.h"
 #include "openclose.h"
 #include "rsrc.h"
 #include "memmap.h"
@@ -130,16 +129,12 @@ struct io_rsrc_node *io_rsrc_node_alloc(struct io_ring_ctx *ctx,
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
 	}
-
-	node->ctx = ctx;
-	node->refs = 1;
-	node->type = type;
 	return node;
 }
 
@@ -488,8 +483,7 @@ void io_free_rsrc_node(struct io_rsrc_node *node)
 		break;
 	}
 
-	if (!io_alloc_cache_put(&ctx->rsrc_node_cache, node))
-		kfree(node);
+	kfree(node);
 }
 
 static void __io_sqe_files_unregister(struct io_ring_ctx *ctx)
-- 
2.45.2


