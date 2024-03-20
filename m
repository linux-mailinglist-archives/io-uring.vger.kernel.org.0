Return-Path: <io-uring+bounces-1158-lists+io-uring=lfdr.de@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from sy.mirrors.kernel.org (sy.mirrors.kernel.org [147.75.48.161])
	by mail.lfdr.de (Postfix) with ESMTPS id EB24888090E
	for <lists+io-uring@lfdr.de>; Wed, 20 Mar 2024 02:23:29 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sy.mirrors.kernel.org (Postfix) with ESMTPS id 3D349B236BB
	for <lists+io-uring@lfdr.de>; Wed, 20 Mar 2024 01:23:27 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 7215E1364;
	Wed, 20 Mar 2024 01:23:25 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel-dk.20230601.gappssmtp.com header.i=@kernel-dk.20230601.gappssmtp.com header.b="Z+GVLGxE"
X-Original-To: io-uring@vger.kernel.org
Received: from mail-oa1-f41.google.com (mail-oa1-f41.google.com [209.85.160.41])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B3C342582
	for <io-uring@vger.kernel.org>; Wed, 20 Mar 2024 01:23:23 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.160.41
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1710897805; cv=none; b=VyOjSVYXC9jhc2DfO1garNOAmFt8I/USALHqX8pXvauncDduNO7ULjMfmm1S9bTyNzOqhPRxP8KnB8Z8KTAFtaLLLCzhY2+bwvC6/UbLjXUwwdKM3hxwJtbGzmxIEXoLOe+JfscLq1b8yQuy2F5JXjjuFxM4FA4GT6UNzmFDbBw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1710897805; c=relaxed/simple;
	bh=5v5AJa3hf+RSZ1LSk3M8sECmSGIhmGrRWTING2w7Xq4=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=tI6LNBMpRMmAqjY3U/GJ4Ac9cWo5PcNCMZuIqbwSV4hiOt5MMZAWK87GKyzoNXaSuL/ZZ/LhOLT+TwnO5zAUhwE6hxYiM58BZU/2C1KxZuFsmo1WKDQbMEPcHhZKv4CbfMxp2PA1OnmYExHOJVfO/9Ak6cNu+lUlhN8wRtZ3vdY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=kernel.dk; spf=pass smtp.mailfrom=kernel.dk; dkim=pass (2048-bit key) header.d=kernel-dk.20230601.gappssmtp.com header.i=@kernel-dk.20230601.gappssmtp.com header.b=Z+GVLGxE; arc=none smtp.client-ip=209.85.160.41
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=kernel.dk
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=kernel.dk
Received: by mail-oa1-f41.google.com with SMTP id 586e51a60fabf-221d4c52759so905131fac.1
        for <io-uring@vger.kernel.org>; Tue, 19 Mar 2024 18:23:23 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernel-dk.20230601.gappssmtp.com; s=20230601; t=1710897802; x=1711502602; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=blSLYhbZMEETgrYUItaGDGnFinyIemETqAcvMDs0Nsg=;
        b=Z+GVLGxEP25PM5w8UodY6LuMm4yBH0tfMOY6/1/W5yxVfA4NT8TAv4niNc7GH88Nk+
         ThShtMeU119XMA+uJ7iMJT1yMgCUyYB4EyRMo9usUeux8ucENekteb5CVV+XNGL7iE0K
         8vpsgE/0wRvn4IVEJjUEVjpS6KKGcRR33g5MS5A38gu1AJOX4wxmnqCDI0loLEwWNUs3
         IAu6RDIKAoeLR6uf4qkGBE2y0HdfBmj186PYJNGIEt+2S+mg9pedDOEvSLK+Nfb3oV4r
         8SM9k1aIjliT48XpCE86ODyXtJmf+MPxEdKOVeuTlekEP/bRkNqIfew1DltVheyMxdaI
         rHGg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1710897802; x=1711502602;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=blSLYhbZMEETgrYUItaGDGnFinyIemETqAcvMDs0Nsg=;
        b=aGqAkemQs+YlJr2GkafMAvaoxzfT2nKm42L/UbAOPIOQPEav6ulU7tUUhxMjsZ0eGg
         AXS2hsMNQAmEmPbiM+iRZL+KEehGhipI2TSfC0R7ac3z+yQQHI9MBREh5F3Vny8AYIIc
         4aTL+Zz1uhREBsotMwZ4pcCHbDwkEmpQyXMH0jKcCmom3u4PoccHO6iMvn8RNNkqMG2C
         TsJxCjoy3NX3u2TKBC/29oMcV0z2HtlpN/+7ivulYML8JWvLtsCj5PQKPybWm6Szxwss
         5BHk0/vWg/dU5XYO/wuvwj4oZOWtdJQfGwg2IiJVPX8D2112jYQuOxOtGc4JGj/qm9nc
         sJsw==
X-Gm-Message-State: AOJu0YzkK0bQQXB8ycLsx8vj+OVlHgWrjgLG+UFU5rHJ6BonBZ+qOaK4
	RZQf44+DQFROKk5Kj131jRiqvK1bXrXT+0R9XlXejEBNGDkSqONi0NdESQv/Ar+sEZg7+Dzb1UT
	Q
X-Google-Smtp-Source: AGHT+IH5J9fJce+ZSF1aMFQMTYaGSI1P1/6agnPf7c1nXWO99A2+vABUTnGpYMZY2HQPgO5lAknwPQ==
X-Received: by 2002:a05:6358:7e16:b0:17e:b6bc:f73e with SMTP id o22-20020a0563587e1600b0017eb6bcf73emr264930rwm.0.1710897802586;
        Tue, 19 Mar 2024 18:23:22 -0700 (PDT)
Received: from localhost.localdomain ([198.8.77.194])
        by smtp.gmail.com with ESMTPSA id v22-20020a634816000000b005dc26144d96sm9618007pga.75.2024.03.19.18.23.21
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 19 Mar 2024 18:23:21 -0700 (PDT)
From: Jens Axboe <axboe@kernel.dk>
To: io-uring@vger.kernel.org
Cc: Jens Axboe <axboe@kernel.dk>
Subject: [PATCH 14/15] io_uring/uring_cmd: switch to always allocating async data
Date: Tue, 19 Mar 2024 19:17:42 -0600
Message-ID: <20240320012251.1120361-15-axboe@kernel.dk>
X-Mailer: git-send-email 2.43.0
In-Reply-To: <20240320012251.1120361-1-axboe@kernel.dk>
References: <20240320012251.1120361-1-axboe@kernel.dk>
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
index 065c92c57878..4c0e9688a159 100644
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


