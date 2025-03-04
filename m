Return-Path: <io-uring+bounces-6951-lists+io-uring=lfdr.de@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [IPv6:2604:1380:4601:e00::3])
	by mail.lfdr.de (Postfix) with ESMTPS id F3CF3A4EDCA
	for <lists+io-uring@lfdr.de>; Tue,  4 Mar 2025 20:48:59 +0100 (CET)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id 573C5188F299
	for <lists+io-uring@lfdr.de>; Tue,  4 Mar 2025 19:49:03 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 60D9A259CB0;
	Tue,  4 Mar 2025 19:48:49 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=purestorage.com header.i=@purestorage.com header.b="F1vOBcGN"
X-Original-To: io-uring@vger.kernel.org
Received: from mail-io1-f98.google.com (mail-io1-f98.google.com [209.85.166.98])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 996D925A334
	for <io-uring@vger.kernel.org>; Tue,  4 Mar 2025 19:48:46 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.166.98
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1741117729; cv=none; b=ro/upSRZLZVsY2iDoe2DPHOz7ckI8rPW/1GaPTYYkIRPLqLd3LqCzXKg/Iw7k017nNKilhOB6WZ5WkQwbXbYtZmwFweXpVWnhQj+ImdQpzJvJoPYKU4++I7PRyEVrTrfSo6iqSGsJu84cx/iXSExnaTnghiBnaRAqGlS1QTmhE4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1741117729; c=relaxed/simple;
	bh=U7RK7zT79MVlCj/w2IYbO/iMQiwCr9vkz1Pab+1t88E=;
	h=From:To:Cc:Subject:Date:Message-ID:MIME-Version; b=nnnKf1dVqVZJeBjeAqTuNMbGiD+9W+ND6rHq8KGZ2YTFG0pLt2TuS8GQANGkrfUNfYozR8nFg17F85tFsu0D/8jTBU1ip5VfqImsezIMmpLQuuqbjmWMdF6gSd5YGV6c2XKPxjKHxQD1ciPFom9mwnTXct5GmDisAmLrCO/Ipf0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=purestorage.com; spf=fail smtp.mailfrom=purestorage.com; dkim=pass (2048-bit key) header.d=purestorage.com header.i=@purestorage.com header.b=F1vOBcGN; arc=none smtp.client-ip=209.85.166.98
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=purestorage.com
Authentication-Results: smtp.subspace.kernel.org; spf=fail smtp.mailfrom=purestorage.com
Received: by mail-io1-f98.google.com with SMTP id ca18e2360f4ac-844c0d5934fso19693139f.2
        for <io-uring@vger.kernel.org>; Tue, 04 Mar 2025 11:48:46 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=purestorage.com; s=google2022; t=1741117725; x=1741722525; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:from:to:cc:subject:date:message-id:reply-to;
        bh=5Io/XTa/jSTok/cOQAf7shKW/Y71+MJlJ2IZz8P0siY=;
        b=F1vOBcGNs2z47wDLEGyRAGk8v+MXZuqexHFXxPIk4bb1FuIOIGZulllU1mqTpJQzO5
         AmPi8gloIExMcbtpxFbXMfPKcIXAaZ87FDpbi9XxR8FBLw6XUdCKyAtpouSnhledCvJR
         nEE2uuBLpUYsUuyzWFkVAt/OENRjuvW7M4D7yZVUe2XRMWEP5NmiDrC0CFf105QtlZC/
         QwNormDSLoSOVTeEFqYfywEdpya0FyUH6Fl/LFlb+l3RF5f3Kfo5cA7n8WQNqsbaHDkb
         Z+8CMCFBnY5VUBxwXmqq82lz+qsF9+4XXukYrID5DlqXuQIZl7kgUnHDeA+Z7kpCaMOX
         Grdw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1741117725; x=1741722525;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=5Io/XTa/jSTok/cOQAf7shKW/Y71+MJlJ2IZz8P0siY=;
        b=SWxEAawI40MpCH/lY2FeUoEeyco/dOuLqqjjN19En4/kunWAjd0i7RV2CwixQTcQ0C
         Eb+k3Om2ls+mzVpGkepJsgfH/OnDM2BWOxkrgH5C6Y/VRBAdkIJWDoXAvOaMmEQNuqjR
         N1wUGvNjqYXGNKM2Z0AaRjnFZuuTm9Nv1bwxawgZm0mp7kmIveIKLLAOqdIF6RLMEmfe
         1zY/8nknkyH9il/F6DXAUwKnadW13kmO0k+3AwOgtO0ck/U449wLvlzh+h8WbG312AyG
         XW9vulOtGAPXFzXQ+hz0HBR63BiqW1qXjnLgihh+09ry6Ube8PcR2Xo83aHpSHGzqt1p
         c2uw==
X-Forwarded-Encrypted: i=1; AJvYcCWnERZm3J3cGLTOhMyhxYIeZEu8lYcwBVpYBpE9VPMDcvqrQtcxbldVGXa9dlk1MdvbDvWRYeVWYw==@vger.kernel.org
X-Gm-Message-State: AOJu0Yy5eZdvM5ke2daFyAv84QSwE3KstkpWF+Av/AQbzdyAagp4hnzD
	KqO6oN3Uxa9N7yVXxDgq63rC7c3B4+hf6O7Asf+0B/6GxgnmmVwEPzBWZL7C37bjFoA+pZpjyI4
	HdcjzoiLqR9i8me4JvT7IqknBsvwX/KNvob1WvjxtFGCHS04v
X-Gm-Gg: ASbGncvIYnnlUudX27Q0rQ0Bugjlti3K667rZbLxvvHZmMIXf0k+B8sbQlcoR+QYTru
	AzmItwSyPMfN/wzoZ2g07hwNYhashS07soriTf0ZNm5ukL7PJ6ih2I+UEeTJVdGDy4U+RToIQ1d
	ynQUVLiFoqxkgd+fPap0JOPnbpGids1edDgaAG6ke0kWiJMZ+vZcnqvvmW4YYqRGYibCwX55aN+
	Oy6y16IEGIhdA/K8NE5FPw1SB6TxGVVY//2hvVyl+PZA7RoJJoGz/+oCT8dlhUtYJ+g5CSNcT4O
	llk5KAcOWiTBFfPu0kQCmNr4aTMwPSL+CQ==
X-Google-Smtp-Source: AGHT+IFKuz4LulLuhFyx2WplI30Kx5BbBsbJ5lWU9pZ5K4JINKqZTrTqblw0OAPyvNHbkeASBfFYGZsS5pnj
X-Received: by 2002:a05:6e02:1c8e:b0:3d3:dcd5:cde5 with SMTP id e9e14a558f8ab-3d42b96eaaemr1812915ab.4.1741117725615;
        Tue, 04 Mar 2025 11:48:45 -0800 (PST)
Received: from c7-smtp-2023.dev.purestorage.com ([2620:125:9017:12:36:3:5:0])
        by smtp-relay.gmail.com with ESMTPS id e9e14a558f8ab-3d3f6081093sm4142685ab.54.2025.03.04.11.48.45
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 04 Mar 2025 11:48:45 -0800 (PST)
X-Relaying-Domain: purestorage.com
Received: from dev-csander.dev.purestorage.com (dev-csander.dev.purestorage.com [10.7.70.37])
	by c7-smtp-2023.dev.purestorage.com (Postfix) with ESMTP id 81F5E34039C;
	Tue,  4 Mar 2025 12:48:44 -0700 (MST)
Received: by dev-csander.dev.purestorage.com (Postfix, from userid 1557716354)
	id 787BAE41B75; Tue,  4 Mar 2025 12:48:14 -0700 (MST)
From: Caleb Sander Mateos <csander@purestorage.com>
To: Jens Axboe <axboe@kernel.dk>,
	Pavel Begunkov <asml.silence@gmail.com>
Cc: Caleb Sander Mateos <csander@purestorage.com>,
	io-uring@vger.kernel.org,
	linux-kernel@vger.kernel.org
Subject: [PATCH] io_uring: introduce io_cache_free() helper
Date: Tue,  4 Mar 2025 12:48:12 -0700
Message-ID: <20250304194814.2346705-1-csander@purestorage.com>
X-Mailer: git-send-email 2.45.2
Precedence: bulk
X-Mailing-List: io-uring@vger.kernel.org
List-Id: <io-uring.vger.kernel.org>
List-Subscribe: <mailto:io-uring+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:io-uring+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

Add a helper function io_cache_free() that returns an allocation to a
io_alloc_cache, falling back on kfree() if the io_alloc_cache is full.
This is the inverse of io_cache_alloc(), which takes an allocation from
an io_alloc_cache and falls back on kmalloc() if the cache is empty.

Convert 4 callers to use the helper.

Signed-off-by: Caleb Sander Mateos <csander@purestorage.com>
Suggested-by: Li Zetao <lizetao1@huawei.com>
---
 io_uring/alloc_cache.h |  6 ++++++
 io_uring/futex.c       |  4 +---
 io_uring/io_uring.c    |  3 +--
 io_uring/rsrc.c        | 15 +++++----------
 4 files changed, 13 insertions(+), 15 deletions(-)

diff --git a/io_uring/alloc_cache.h b/io_uring/alloc_cache.h
index 0dd17d8ba93a..7f68eff2e7f3 100644
--- a/io_uring/alloc_cache.h
+++ b/io_uring/alloc_cache.h
@@ -66,6 +66,12 @@ static inline void *io_cache_alloc(struct io_alloc_cache *cache, gfp_t gfp)
 	if (obj)
 		return obj;
 	return io_cache_alloc_new(cache, gfp);
 }
 
+static inline void io_cache_free(struct io_alloc_cache *cache, void *obj)
+{
+	if (!io_alloc_cache_put(cache, obj))
+		kfree(obj);
+}
+
 #endif
diff --git a/io_uring/futex.c b/io_uring/futex.c
index b7581766406c..0ea4820cd8ff 100644
--- a/io_uring/futex.c
+++ b/io_uring/futex.c
@@ -51,16 +51,14 @@ static void __io_futex_complete(struct io_kiocb *req, io_tw_token_t tw)
 	io_req_task_complete(req, tw);
 }
 
 static void io_futex_complete(struct io_kiocb *req, io_tw_token_t tw)
 {
-	struct io_futex_data *ifd = req->async_data;
 	struct io_ring_ctx *ctx = req->ctx;
 
 	io_tw_lock(ctx, tw);
-	if (!io_alloc_cache_put(&ctx->futex_cache, ifd))
-		kfree(ifd);
+	io_cache_free(&ctx->futex_cache, req->async_data);
 	__io_futex_complete(req, tw);
 }
 
 static void io_futexv_complete(struct io_kiocb *req, io_tw_token_t tw)
 {
diff --git a/io_uring/io_uring.c b/io_uring/io_uring.c
index ccc343f61a57..58003fa6b327 100644
--- a/io_uring/io_uring.c
+++ b/io_uring/io_uring.c
@@ -1420,12 +1420,11 @@ static void io_free_batch_list(struct io_ring_ctx *ctx,
 			if ((req->flags & REQ_F_POLLED) && req->apoll) {
 				struct async_poll *apoll = req->apoll;
 
 				if (apoll->double_poll)
 					kfree(apoll->double_poll);
-				if (!io_alloc_cache_put(&ctx->apoll_cache, apoll))
-					kfree(apoll);
+				io_cache_free(&ctx->apoll_cache, apoll);
 				req->flags &= ~REQ_F_POLLED;
 			}
 			if (req->flags & IO_REQ_LINK_FLAGS)
 				io_queue_next(req);
 			if (unlikely(req->flags & IO_REQ_CLEAN_FLAGS))
diff --git a/io_uring/rsrc.c b/io_uring/rsrc.c
index 3fb1bd616eef..5dd1e0827559 100644
--- a/io_uring/rsrc.c
+++ b/io_uring/rsrc.c
@@ -122,12 +122,13 @@ static struct io_mapped_ubuf *io_alloc_imu(struct io_ring_ctx *ctx,
 			GFP_KERNEL);
 }
 
 static void io_free_imu(struct io_ring_ctx *ctx, struct io_mapped_ubuf *imu)
 {
-	if (imu->nr_bvecs > IO_CACHED_BVECS_SEGS ||
-	    !io_alloc_cache_put(&ctx->imu_cache, imu))
+	if (imu->nr_bvecs <= IO_CACHED_BVECS_SEGS)
+		io_cache_free(&ctx->imu_cache, imu);
+	else
 		kvfree(imu);
 }
 
 static void io_buffer_unmap(struct io_ring_ctx *ctx, struct io_mapped_ubuf *imu)
 {
@@ -485,16 +486,10 @@ int io_files_update(struct io_kiocb *req, unsigned int issue_flags)
 		req_set_fail(req);
 	io_req_set_res(req, ret, 0);
 	return IOU_OK;
 }
 
-static void io_free_node(struct io_ring_ctx *ctx, struct io_rsrc_node *node)
-{
-	if (!io_alloc_cache_put(&ctx->node_cache, node))
-		kfree(node);
-}
-
 void io_free_rsrc_node(struct io_ring_ctx *ctx, struct io_rsrc_node *node)
 {
 	if (node->tag)
 		io_post_aux_cqe(ctx, node->tag, 0, 0);
 
@@ -508,11 +503,11 @@ void io_free_rsrc_node(struct io_ring_ctx *ctx, struct io_rsrc_node *node)
 	default:
 		WARN_ON_ONCE(1);
 		break;
 	}
 
-	io_free_node(ctx, node);
+	io_cache_free(&ctx->node_cache, node);
 }
 
 int io_sqe_files_unregister(struct io_ring_ctx *ctx)
 {
 	if (!ctx->file_table.data.nr)
@@ -833,11 +828,11 @@ static struct io_rsrc_node *io_sqe_buffer_register(struct io_ring_ctx *ctx,
 	}
 done:
 	if (ret) {
 		if (imu)
 			io_free_imu(ctx, imu);
-		io_free_node(ctx, node);
+		io_cache_free(&ctx->node_cache, node);
 		node = ERR_PTR(ret);
 	}
 	kvfree(pages);
 	return node;
 }
-- 
2.45.2


