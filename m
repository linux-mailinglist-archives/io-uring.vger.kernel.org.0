Return-Path: <io-uring+bounces-7167-lists+io-uring=lfdr.de@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from sy.mirrors.kernel.org (sy.mirrors.kernel.org [147.75.48.161])
	by mail.lfdr.de (Postfix) with ESMTPS id C7F9DA6C216
	for <lists+io-uring@lfdr.de>; Fri, 21 Mar 2025 19:05:20 +0100 (CET)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sy.mirrors.kernel.org (Postfix) with ESMTPS id 113E77A86C7
	for <lists+io-uring@lfdr.de>; Fri, 21 Mar 2025 18:02:51 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 8AC4222E3E8;
	Fri, 21 Mar 2025 18:03:49 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="QQ8V6obG"
X-Original-To: io-uring@vger.kernel.org
Received: from mail-ej1-f42.google.com (mail-ej1-f42.google.com [209.85.218.42])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 50E971DB366
	for <io-uring@vger.kernel.org>; Fri, 21 Mar 2025 18:03:46 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.218.42
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1742580229; cv=none; b=m6ewJADQ+HjVASBhZtuGAAv3v4QX9LRZ9XaqhQz9OvlwOREi9w5OkFCxaCmUtvE3Nblp6ZmbGHRn0eTaR7MZYqB7DyKKLoWU9VnX+PC2kMiG0hKMzVkfmd86wjv1l5x2B8gY3VFPnc4Uclo/9r8FQo5lRpJP23umOH0XeiPbEQk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1742580229; c=relaxed/simple;
	bh=c57QQ6t7C1AigZNTzPTEjK1RPP9Q5YHrl1t3mRVf5sI=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=uFVCL9KUY2y7l7d6JluNMO0JrbNCNhHXmv2BRYanyJNP/mrxCQynV/gq5VNiFWr01VrXevPYh+GTA0t+ByWm+vRQJp12GawEDua7ggR6Big9DMPJEDrNGlT1kM0u1qRLoh6Nj3du4W/b3b6K6hu2QZG4onwomt/L7OEUCMBCZII=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=QQ8V6obG; arc=none smtp.client-ip=209.85.218.42
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Received: by mail-ej1-f42.google.com with SMTP id a640c23a62f3a-ac27cb35309so403765166b.2
        for <io-uring@vger.kernel.org>; Fri, 21 Mar 2025 11:03:45 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1742580224; x=1743185024; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=bEw6jKWRjhUbQvTGDrTYeSSfCLGZM3wSVTv+AB5qA04=;
        b=QQ8V6obG7Zxo8481hdaBuXHYb38YV1g7e+LfU5dGaLbdoI+YKH9dMQQpVa18u630T2
         g9vYRP2Lk0xEBADePwvJHqleImdRuZO6L6QBZ0qBCfWY+4dnG/hfZXtb+xelfbuYYWRJ
         xV/mQ2RwRiSSkCL3sZgJs4jrVPpg7jBUEi6cWVqDCk3fNhAZZ9lRuU9FVkqdtj//XrEg
         EyHFKPchag01fNsVx/xosGx/CRG8tFg9pCkB1/w2bvMFom00ignskUWZxDtpF6gqRYew
         t9QAcG/t6Z4iYx3QRADRIsumR5K93di4qsc5VeHRZbdlG+m5pl8vCB9HhLiB1lWO0IdZ
         qgwA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1742580224; x=1743185024;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=bEw6jKWRjhUbQvTGDrTYeSSfCLGZM3wSVTv+AB5qA04=;
        b=Awtxp3AS6KaUOd0+2CKLs1FP7eCZglMDrIjYvAwnLgyhgrrmZSiwMBueXs5j6frS2G
         p9GpbjHNmdEEp1FKmCMatJ8BFlLeMK6j/Nz9SK3DH67TAeMt9hkvSoVVYzVwq61yjnBU
         /u4ljPE/kGqyZohpyI8/m7FpwaQme9S0UJA3L6Vopyo6ETkaCI+DhLs9kTx/NH2E2haA
         JIkdArRFYYQD/1QE8INgst1/2s5lldN65+SI6+4f9asn38Zm3Wtf92Alfi//qHH2yFEP
         h7aYVL/5GcDvcJMcf1F8tlLL9GHWdk17HiYQbEkx+U8VUdlBwPsQOjgIqLvLUfiJxEUn
         wtAg==
X-Gm-Message-State: AOJu0YxjR7AfHd0o6gFO+h1eu0va4UAtHzc8xxZdGLEIIBG851cWHA9S
	sGgZw02LSA35pYDe3hLHUjRgzv+s3d2vxYX/gHCQHyc1SRNSrFSVjjZ4TQ==
X-Gm-Gg: ASbGncuFX0aLdCi1+q00mvm5khT4WaA3vpwDMRon8M7G+mz19FHdUQK7WMap3JsASSE
	pHvoX9IVaoI7JSUBQNIMuaGR9rNq4v4E1tMBCahX25sQ71AwDlCaF/cBLo0BHImxpbtO9TGbMKd
	Omv1hyhSjsh1ylP/Y0JKg+G5gs9niKizut+jy0Lk9wBV1nxZGjT87qgZaEyAba7+MIIZIs11boT
	SaSWLe/fFWRtcIdyz4yo1qsdwqBpI82cq7cZ8tTi6VucxeoFUCdzNpovs4SdFMyRlLXzOeT2kl1
	IvEylzJJbYvSY+dZ9WY3yymqdqF+rc4YjGABX3DcwkVouwCBmApEFI9PNQ==
X-Google-Smtp-Source: AGHT+IF6M8x1x8aPCH4HVxgZNTaNUYNCn+1K8lCX1ll1uGYaMmRS5munx/ESh82U4pOM12hSHBocKw==
X-Received: by 2002:a17:907:97ce:b0:ac3:bd68:24f0 with SMTP id a640c23a62f3a-ac3f2100aeamr465765166b.7.1742580223906;
        Fri, 21 Mar 2025 11:03:43 -0700 (PDT)
Received: from 127.0.0.1localhost ([85.255.236.254])
        by smtp.gmail.com with ESMTPSA id a640c23a62f3a-ac3ef8d3d2dsm191646266b.60.2025.03.21.11.03.42
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 21 Mar 2025 11:03:43 -0700 (PDT)
From: Pavel Begunkov <asml.silence@gmail.com>
To: io-uring@vger.kernel.org
Cc: asml.silence@gmail.com
Subject: [PATCH v2 1/2] io_uring/cmd: add iovec cache for commands
Date: Fri, 21 Mar 2025 18:04:33 +0000
Message-ID: <c0f2145b75791bc6106eb4e72add2cf6a2c72a7a.1742579999.git.asml.silence@gmail.com>
X-Mailer: git-send-email 2.48.1
In-Reply-To: <cover.1742579999.git.asml.silence@gmail.com>
References: <cover.1742579999.git.asml.silence@gmail.com>
Precedence: bulk
X-Mailing-List: io-uring@vger.kernel.org
List-Id: <io-uring.vger.kernel.org>
List-Subscribe: <mailto:io-uring+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:io-uring+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

Add iou_vec to commands and wire caching for it, but don't expose it to
users just yet. We need the vec cleared on initial alloc, but since
we can't place it at the beginning at the moment, zero the entire
async_data. It's cached, and the performance effects only the initial
allocation, and it might be not a bad idea since we're exposing those
bits to outside drivers.

Signed-off-by: Pavel Begunkov <asml.silence@gmail.com>
---
 io_uring/io_uring.c  |  5 +++--
 io_uring/opdef.c     |  1 +
 io_uring/uring_cmd.c | 20 +++++++++++++++++++-
 io_uring/uring_cmd.h |  5 +++++
 4 files changed, 28 insertions(+), 3 deletions(-)

diff --git a/io_uring/io_uring.c b/io_uring/io_uring.c
index 5eb9be063a7c..e1128b9551aa 100644
--- a/io_uring/io_uring.c
+++ b/io_uring/io_uring.c
@@ -289,7 +289,7 @@ static void io_free_alloc_caches(struct io_ring_ctx *ctx)
 	io_alloc_cache_free(&ctx->apoll_cache, kfree);
 	io_alloc_cache_free(&ctx->netmsg_cache, io_netmsg_cache_free);
 	io_alloc_cache_free(&ctx->rw_cache, io_rw_cache_free);
-	io_alloc_cache_free(&ctx->cmd_cache, kfree);
+	io_alloc_cache_free(&ctx->cmd_cache, io_cmd_cache_free);
 	io_alloc_cache_free(&ctx->msg_cache, kfree);
 	io_futex_cache_free(ctx);
 	io_rsrc_cache_free(ctx);
@@ -335,7 +335,8 @@ static __cold struct io_ring_ctx *io_ring_ctx_alloc(struct io_uring_params *p)
 			    sizeof(struct io_async_rw),
 			    offsetof(struct io_async_rw, clear));
 	ret |= io_alloc_cache_init(&ctx->cmd_cache, IO_ALLOC_CACHE_MAX,
-			    sizeof(struct io_async_cmd), 0);
+			    sizeof(struct io_async_cmd),
+			    sizeof(struct io_async_cmd));
 	spin_lock_init(&ctx->msg_lock);
 	ret |= io_alloc_cache_init(&ctx->msg_cache, IO_ALLOC_CACHE_MAX,
 			    sizeof(struct io_kiocb), 0);
diff --git a/io_uring/opdef.c b/io_uring/opdef.c
index e4aa61a414fb..489384c0438b 100644
--- a/io_uring/opdef.c
+++ b/io_uring/opdef.c
@@ -755,6 +755,7 @@ const struct io_cold_def io_cold_defs[] = {
 	},
 	[IORING_OP_URING_CMD] = {
 		.name			= "URING_CMD",
+		.cleanup		= io_uring_cmd_cleanup,
 	},
 	[IORING_OP_SEND_ZC] = {
 		.name			= "SEND_ZC",
diff --git a/io_uring/uring_cmd.c b/io_uring/uring_cmd.c
index 7c126ee497ea..6a21cdaaf495 100644
--- a/io_uring/uring_cmd.c
+++ b/io_uring/uring_cmd.c
@@ -16,6 +16,14 @@
 #include "rsrc.h"
 #include "uring_cmd.h"
 
+void io_cmd_cache_free(const void *entry)
+{
+	struct io_async_cmd *ac = (struct io_async_cmd *)entry;
+
+	io_vec_free(&ac->vec);
+	kfree(ac);
+}
+
 static void io_req_uring_cleanup(struct io_kiocb *req, unsigned int issue_flags)
 {
 	struct io_uring_cmd *ioucmd = io_kiocb_to_cmd(req, struct io_uring_cmd);
@@ -29,13 +37,23 @@ static void io_req_uring_cleanup(struct io_kiocb *req, unsigned int issue_flags)
 
 	if (issue_flags & IO_URING_F_UNLOCKED)
 		return;
+
+	io_alloc_cache_vec_kasan(&ac->vec);
+	if (ac->vec.nr > IO_VEC_CACHE_SOFT_CAP)
+		io_vec_free(&ac->vec);
+
 	if (io_alloc_cache_put(&req->ctx->cmd_cache, cache)) {
 		ioucmd->sqe = NULL;
 		req->async_data = NULL;
-		req->flags &= ~REQ_F_ASYNC_DATA;
+		req->flags &= ~(REQ_F_ASYNC_DATA|REQ_F_NEED_CLEANUP);
 	}
 }
 
+void io_uring_cmd_cleanup(struct io_kiocb *req)
+{
+	io_req_uring_cleanup(req, 0);
+}
+
 bool io_uring_try_cancel_uring_cmd(struct io_ring_ctx *ctx,
 				   struct io_uring_task *tctx, bool cancel_all)
 {
diff --git a/io_uring/uring_cmd.h b/io_uring/uring_cmd.h
index 2ec3a8785534..b45ec7cffcd1 100644
--- a/io_uring/uring_cmd.h
+++ b/io_uring/uring_cmd.h
@@ -1,13 +1,18 @@
 // SPDX-License-Identifier: GPL-2.0
 
 #include <linux/io_uring/cmd.h>
+#include <linux/io_uring_types.h>
 
 struct io_async_cmd {
 	struct io_uring_cmd_data	data;
+	struct iou_vec			vec;
 };
 
 int io_uring_cmd(struct io_kiocb *req, unsigned int issue_flags);
 int io_uring_cmd_prep(struct io_kiocb *req, const struct io_uring_sqe *sqe);
+void io_uring_cmd_cleanup(struct io_kiocb *req);
 
 bool io_uring_try_cancel_uring_cmd(struct io_ring_ctx *ctx,
 				   struct io_uring_task *tctx, bool cancel_all);
+
+void io_cmd_cache_free(const void *entry);
-- 
2.48.1


