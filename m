Return-Path: <io-uring+bounces-1176-lists+io-uring=lfdr.de@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from sy.mirrors.kernel.org (sy.mirrors.kernel.org [147.75.48.161])
	by mail.lfdr.de (Postfix) with ESMTPS id 09E4B8819B8
	for <lists+io-uring@lfdr.de>; Wed, 20 Mar 2024 23:58:26 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sy.mirrors.kernel.org (Postfix) with ESMTPS id 7641BB2509D
	for <lists+io-uring@lfdr.de>; Wed, 20 Mar 2024 22:58:23 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 9D08285C6C;
	Wed, 20 Mar 2024 22:58:21 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel-dk.20230601.gappssmtp.com header.i=@kernel-dk.20230601.gappssmtp.com header.b="evb9yOPy"
X-Original-To: io-uring@vger.kernel.org
Received: from mail-io1-f48.google.com (mail-io1-f48.google.com [209.85.166.48])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D4A798595C
	for <io-uring@vger.kernel.org>; Wed, 20 Mar 2024 22:58:19 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.166.48
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1710975501; cv=none; b=bCMyHOn1oRUntHw1m64CXmHZsX648/vgba2z40OcTTo/emP9XGk2yRPVOaheNdeTY8at1cKeosORXr3iUoiESoRM6YNWx1Tpn3+nlR8RuBIF/1IKUqkeOV28dD2qwXTcd4UIQaf+1z6q8pd9qPDnaaPqFF8J3lAQp7CJSsw+TaU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1710975501; c=relaxed/simple;
	bh=imKW6bzR+X9Wmqgjzn5fcP0ioCp4iaCKMIBfhG+5UBc=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=ZPENfQVjn++d7Zi6hEQ7BlC/SoB0vYmS2GjPNMGyyAil/pEap0OstcJW02IBMECh/09LCBRUepvOVMGTVrmhMiRyLHf4VP1hKXBFQqCAcQggK8u9DFSDp9uR/Yl4IDeOSoTOKOY+68H3/wK86AX/tZTymKQKwPL67Y4eHd0Z8/Y=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=kernel.dk; spf=pass smtp.mailfrom=kernel.dk; dkim=pass (2048-bit key) header.d=kernel-dk.20230601.gappssmtp.com header.i=@kernel-dk.20230601.gappssmtp.com header.b=evb9yOPy; arc=none smtp.client-ip=209.85.166.48
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=kernel.dk
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=kernel.dk
Received: by mail-io1-f48.google.com with SMTP id ca18e2360f4ac-7cc0e831e11so2542239f.1
        for <io-uring@vger.kernel.org>; Wed, 20 Mar 2024 15:58:19 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernel-dk.20230601.gappssmtp.com; s=20230601; t=1710975498; x=1711580298; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=81BPzzmBgQzVbYIwH3OxkEDfqVr96cHlM67nUhExOn0=;
        b=evb9yOPyVPOpfc3wdmvXiBYBFx2NamRF1e0GrICJLGyHY8CKG9z8XkYMO2fHjX/voC
         6acyE03ble4GZyQpQYe3r09s0m0JJJNp2pWEBlQlMx6hvfK3y5OGkLHkz2wz45DBO6FI
         6dHSkyrqi9diahGqegDlAolN10QJI+YsmG5NvMI8urJSVqcXVun0QY5cgrzuumreEoNP
         L8bwTNI6cpIQ8cfge7lcwHV6faBgNNv8mLLmMrHhIJF6HGiX1e4poLYdLiw4pwkObkpu
         YY837nOgd2QAHjqKI9p90fYy40kdEigvujD1EFU1pIki4kKmVqXk7sm3ZTwdcIPpa7xZ
         w6Yw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1710975498; x=1711580298;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=81BPzzmBgQzVbYIwH3OxkEDfqVr96cHlM67nUhExOn0=;
        b=Y2lyqFVNNSm4eQRnVr+ue8REV8/R7pjev/2DjhQ+sDDzJRaWFsoWJR4LA3jI7snyps
         fAamGEIhaNo3sYah6Q2jZEzUCajQa1q/qG10GD5QyKGfFcmHMb4JMGfJxHnpM2lQ34FK
         r3DENmd1zR+yGG08Lffm/HvS9roJgBsgriMbtm7ycJyKfaE/HnSp8G8vE6yTkJTleSOq
         jl8mKxGXgz6cu9VsA+QW8pgFDxqzUxli00d3UFDa+DtsSDtpvSAgGldTDSiNTY3tsIsY
         SG6yDURlOvtz9g0VUPjpECwqYdb86cI01pOXKIDFi1z4F3CPWUrF5yhUy+Bkhd02Ix41
         2eGg==
X-Gm-Message-State: AOJu0YwPfyi3QVVEKPh6zvIyEGHpL4riFFLssYAU7huepvb4uLiK5aqZ
	OZqWFEpy0o/OFGgALyyaMV9VlOQs4MeoiGMiOaaugTCIuUtXAcqH1q7MZ0Q3w9aljPV2fKK9LCY
	6
X-Google-Smtp-Source: AGHT+IGBi51SgQKuDNVaIXwZUDTuaXBOuD6tFsdn38krvVzbUTarP9creIDGauOJkjzq410giq2Gfg==
X-Received: by 2002:a5e:c10d:0:b0:7cf:28df:79e2 with SMTP id v13-20020a5ec10d000000b007cf28df79e2mr701194iol.1.1710975498480;
        Wed, 20 Mar 2024 15:58:18 -0700 (PDT)
Received: from localhost.localdomain ([96.43.243.2])
        by smtp.gmail.com with ESMTPSA id z19-20020a6b0a13000000b007cf23a498dcsm434384ioi.38.2024.03.20.15.58.16
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 20 Mar 2024 15:58:17 -0700 (PDT)
From: Jens Axboe <axboe@kernel.dk>
To: io-uring@vger.kernel.org
Cc: Jens Axboe <axboe@kernel.dk>
Subject: [PATCH 14/17] io_uring/uring_cmd: switch to always allocating async data
Date: Wed, 20 Mar 2024 16:55:29 -0600
Message-ID: <20240320225750.1769647-15-axboe@kernel.dk>
X-Mailer: git-send-email 2.43.0
In-Reply-To: <20240320225750.1769647-1-axboe@kernel.dk>
References: <20240320225750.1769647-1-axboe@kernel.dk>
Precedence: bulk
X-Mailing-List: io-uring@vger.kernel.org
List-Id: <io-uring.vger.kernel.org>
List-Subscribe: <mailto:io-uring+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:io-uring+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

Basic conversion ensuring async_data is allocated off the prep path. Adds
a basic alloc cache as well, as passthrough IO can be quite high in rate.

Signed-off-by: Jens Axboe <axboe@kernel.dk>
---
 include/linux/io_uring_types.h |  1 +
 io_uring/io_uring.c            |  3 ++
 io_uring/opdef.c               |  1 -
 io_uring/uring_cmd.c           | 77 ++++++++++++++++++++++++----------
 io_uring/uring_cmd.h           | 10 ++++-
 5 files changed, 69 insertions(+), 23 deletions(-)

diff --git a/include/linux/io_uring_types.h b/include/linux/io_uring_types.h
index 2ba8676f83cc..e3ec84c43f1a 100644
--- a/include/linux/io_uring_types.h
+++ b/include/linux/io_uring_types.h
@@ -301,6 +301,7 @@ struct io_ring_ctx {
 		struct io_alloc_cache	apoll_cache;
 		struct io_alloc_cache	netmsg_cache;
 		struct io_alloc_cache	rw_cache;
+		struct io_alloc_cache	uring_cache;
 
 		/*
 		 * Any cancelable uring_cmd is added to this list in
diff --git a/io_uring/io_uring.c b/io_uring/io_uring.c
index cc8ce830ff4b..e2b9b00eedef 100644
--- a/io_uring/io_uring.c
+++ b/io_uring/io_uring.c
@@ -310,6 +310,8 @@ static __cold struct io_ring_ctx *io_ring_ctx_alloc(struct io_uring_params *p)
 			    sizeof(struct io_async_msghdr));
 	io_alloc_cache_init(&ctx->rw_cache, IO_ALLOC_CACHE_MAX,
 			    sizeof(struct io_async_rw));
+	io_alloc_cache_init(&ctx->uring_cache, IO_ALLOC_CACHE_MAX,
+			    sizeof(struct uring_cache));
 	io_futex_cache_init(ctx);
 	init_completion(&ctx->ref_comp);
 	xa_init_flags(&ctx->personalities, XA_FLAGS_ALLOC1);
@@ -2901,6 +2903,7 @@ static __cold void io_ring_ctx_free(struct io_ring_ctx *ctx)
 	io_alloc_cache_free(&ctx->apoll_cache, io_apoll_cache_free);
 	io_alloc_cache_free(&ctx->netmsg_cache, io_netmsg_cache_free);
 	io_alloc_cache_free(&ctx->rw_cache, io_rw_cache_free);
+	io_alloc_cache_free(&ctx->uring_cache, io_uring_cache_free);
 	io_futex_cache_free(ctx);
 	io_destroy_buffers(ctx);
 	mutex_unlock(&ctx->uring_lock);
diff --git a/io_uring/opdef.c b/io_uring/opdef.c
index 1951107210d4..745246086c23 100644
--- a/io_uring/opdef.c
+++ b/io_uring/opdef.c
@@ -677,7 +677,6 @@ const struct io_cold_def io_cold_defs[] = {
 	[IORING_OP_URING_CMD] = {
 		.name			= "URING_CMD",
 		.async_size		= 2 * sizeof(struct io_uring_sqe),
-		.prep_async		= io_uring_cmd_prep_async,
 	},
 	[IORING_OP_SEND_ZC] = {
 		.name			= "SEND_ZC",
diff --git a/io_uring/uring_cmd.c b/io_uring/uring_cmd.c
index 4614ce734fee..9bd0ba87553f 100644
--- a/io_uring/uring_cmd.c
+++ b/io_uring/uring_cmd.c
@@ -14,6 +14,38 @@
 #include "rsrc.h"
 #include "uring_cmd.h"
 
+static struct uring_cache *io_uring_async_get(struct io_kiocb *req)
+{
+	struct io_ring_ctx *ctx = req->ctx;
+	struct io_cache_entry *entry;
+	struct uring_cache *cache;
+
+	entry = io_alloc_cache_get(&ctx->uring_cache);
+	if (entry) {
+		cache = container_of(entry, struct uring_cache, cache);
+		req->flags |= REQ_F_ASYNC_DATA;
+		req->async_data = cache;
+		return cache;
+	}
+	if (!io_alloc_async_data(req))
+		return req->async_data;
+	return NULL;
+}
+
+static void io_req_uring_cleanup(struct io_kiocb *req, unsigned int issue_flags)
+{
+	struct io_uring_cmd *ioucmd = io_kiocb_to_cmd(req, struct io_uring_cmd);
+	struct uring_cache *cache = req->async_data;
+
+	if (issue_flags & IO_URING_F_UNLOCKED)
+		return;
+	if (io_alloc_cache_put(&req->ctx->uring_cache, &cache->cache)) {
+		ioucmd->sqe = NULL;
+		req->async_data = NULL;
+		req->flags &= ~REQ_F_ASYNC_DATA;
+	}
+}
+
 bool io_uring_try_cancel_uring_cmd(struct io_ring_ctx *ctx,
 				   struct task_struct *task, bool cancel_all)
 {
@@ -128,6 +160,7 @@ void io_uring_cmd_done(struct io_uring_cmd *ioucmd, ssize_t ret, ssize_t res2,
 	io_req_set_res(req, ret, 0);
 	if (req->ctx->flags & IORING_SETUP_CQE32)
 		io_req_set_cqe32_extra(req, res2, 0);
+	io_req_uring_cleanup(req, issue_flags);
 	if (req->ctx->flags & IORING_SETUP_IOPOLL) {
 		/* order with io_iopoll_req_issued() checking ->iopoll_complete */
 		smp_store_release(&req->iopoll_completed, 1);
@@ -142,13 +175,19 @@ void io_uring_cmd_done(struct io_uring_cmd *ioucmd, ssize_t ret, ssize_t res2,
 }
 EXPORT_SYMBOL_GPL(io_uring_cmd_done);
 
-int io_uring_cmd_prep_async(struct io_kiocb *req)
+static int io_uring_cmd_prep_setup(struct io_kiocb *req,
+				   const struct io_uring_sqe *sqe)
 {
 	struct io_uring_cmd *ioucmd = io_kiocb_to_cmd(req, struct io_uring_cmd);
+	struct uring_cache *cache;
 
-	memcpy(req->async_data, ioucmd->sqe, uring_sqe_size(req->ctx));
-	ioucmd->sqe = req->async_data;
-	return 0;
+	cache = io_uring_async_get(req);
+	if (cache) {
+		memcpy(cache->sqes, sqe, uring_sqe_size(req->ctx));
+		ioucmd->sqe = req->async_data;
+		return 0;
+	}
+	return -ENOMEM;
 }
 
 int io_uring_cmd_prep(struct io_kiocb *req, const struct io_uring_sqe *sqe)
@@ -173,9 +212,9 @@ int io_uring_cmd_prep(struct io_kiocb *req, const struct io_uring_sqe *sqe)
 		req->imu = ctx->user_bufs[index];
 		io_req_set_rsrc_node(req, ctx, 0);
 	}
-	ioucmd->sqe = sqe;
 	ioucmd->cmd_op = READ_ONCE(sqe->cmd_op);
-	return 0;
+
+	return io_uring_cmd_prep_setup(req, sqe);
 }
 
 int io_uring_cmd(struct io_kiocb *req, unsigned int issue_flags)
@@ -206,23 +245,14 @@ int io_uring_cmd(struct io_kiocb *req, unsigned int issue_flags)
 	}
 
 	ret = file->f_op->uring_cmd(ioucmd, issue_flags);
-	if (ret == -EAGAIN) {
-		if (!req_has_async_data(req)) {
-			if (io_alloc_async_data(req))
-				return -ENOMEM;
-			io_uring_cmd_prep_async(req);
-		}
-		return -EAGAIN;
-	}
-
-	if (ret != -EIOCBQUEUED) {
-		if (ret < 0)
-			req_set_fail(req);
-		io_req_set_res(req, ret, 0);
+	if (ret == -EAGAIN || ret == -EIOCBQUEUED)
 		return ret;
-	}
 
-	return IOU_ISSUE_SKIP_COMPLETE;
+	if (ret < 0)
+		req_set_fail(req);
+	io_req_uring_cleanup(req, issue_flags);
+	io_req_set_res(req, ret, 0);
+	return ret;
 }
 
 int io_uring_cmd_import_fixed(u64 ubuf, unsigned long len, int rw,
@@ -311,3 +341,8 @@ int io_uring_cmd_sock(struct io_uring_cmd *cmd, unsigned int issue_flags)
 }
 EXPORT_SYMBOL_GPL(io_uring_cmd_sock);
 #endif
+
+void io_uring_cache_free(struct io_cache_entry *entry)
+{
+	kfree(container_of(entry, struct uring_cache, cache));
+}
diff --git a/io_uring/uring_cmd.h b/io_uring/uring_cmd.h
index 7356bf9aa655..b0ccff7091ee 100644
--- a/io_uring/uring_cmd.h
+++ b/io_uring/uring_cmd.h
@@ -1,8 +1,16 @@
 // SPDX-License-Identifier: GPL-2.0
 
+struct uring_cache {
+	union {
+		struct io_cache_entry cache;
+		struct io_uring_sqe sqes[2];
+	};
+};
+
 int io_uring_cmd(struct io_kiocb *req, unsigned int issue_flags);
 int io_uring_cmd_prep(struct io_kiocb *req, const struct io_uring_sqe *sqe);
 int io_uring_cmd_prep_async(struct io_kiocb *req);
+void io_uring_cache_free(struct io_cache_entry *entry);
 
 bool io_uring_try_cancel_uring_cmd(struct io_ring_ctx *ctx,
-				   struct task_struct *task, bool cancel_all);
\ No newline at end of file
+				   struct task_struct *task, bool cancel_all);
-- 
2.43.0


