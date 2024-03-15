Return-Path: <io-uring+bounces-986-lists+io-uring=lfdr.de@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [147.75.80.249])
	by mail.lfdr.de (Postfix) with ESMTPS id 8719A87D65F
	for <lists+io-uring@lfdr.de>; Fri, 15 Mar 2024 22:47:37 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id 143D61F22DE7
	for <lists+io-uring@lfdr.de>; Fri, 15 Mar 2024 21:47:37 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 1F0F417BAE;
	Fri, 15 Mar 2024 21:47:32 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="iJ7NqL2P"
X-Original-To: io-uring@vger.kernel.org
Received: from mail-wm1-f42.google.com (mail-wm1-f42.google.com [209.85.128.42])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5A891548E7
	for <io-uring@vger.kernel.org>; Fri, 15 Mar 2024 21:47:30 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.128.42
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1710539252; cv=none; b=AXYOywSg8mNMofgF5F5rPjbFXs5GB7WsAyuk20fpmT9BjHsVfNkbKBHYTfUuK4NFQOfS8OZsYYOBSkBv9Fy08pulWpmAGRq3GqfnK2YP0m0mjv9XEtooIMcEgi5Au+qhSeI/V6Q10NETu/mlr6Xypgxbg6Eckog7AFJp6GCF+Jc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1710539252; c=relaxed/simple;
	bh=a31opw+MDT2rMo7cC3qrdDXOcRpISkWUa8e4q0pMWcA=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=Whlg/ZigM6JYzgysp5nm9chQ/ACQ8/XDs9qrErJu8QDK2UwCNaOE8vSbDTe6jh974F9isNXo1JAGrjbsjLUYF5/kM2jxrEitass3yD1j/D7163wwLNK0tCherQ+rJGDIZkKn4+wWGGdDDHyKfvX2MevbsZLs4rNrrR/J4hUBxWM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=iJ7NqL2P; arc=none smtp.client-ip=209.85.128.42
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Received: by mail-wm1-f42.google.com with SMTP id 5b1f17b1804b1-41405d77c7bso2593585e9.3
        for <io-uring@vger.kernel.org>; Fri, 15 Mar 2024 14:47:30 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1710539248; x=1711144048; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=rW/LRhpLvKrsLND2TJlV/mJ25bg5GhErG6+/+asx+EM=;
        b=iJ7NqL2PKDlEUTXkCmSlWaPHsNaq5dLOzHOCxZHIR6P6aULqY0NIsdRbNZllkCV/5o
         ojQGGJcQHh+fkPKG3vPzLrTMrkPjEM+GMa+dWKdOIXQilNuIMDJwwyAggnXbKc8UUjj4
         iV+4htsAq7N6MR25IXnhGj4OJH9oN1uir3sZ5br7+cyocgBoOoef5z1m5WLdj0t9d3cN
         0EyPzgokSFenSm1b4BRzQIEqis9feYL+xbFxcuQrUPuosN2+BsmOsjIBYVTw3JiyUWng
         6NDn+TxNZhW10+bZU+MWegAqsrsy/A7vnt5A4bHHmV8y0gN9E5TckzeJmsE9A8CcqTr6
         gOvg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1710539248; x=1711144048;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=rW/LRhpLvKrsLND2TJlV/mJ25bg5GhErG6+/+asx+EM=;
        b=e4ye85eiNAM/Y11C6DtrdvSF32oHqsbY4CRICLOYg6+uA3tA7PYe8D4lAiLzx3FGAY
         n+i5XHQ4E6lYWe+2tf6xyjaU496fuuaeXbYtBjDUa5i+eItkjkGw5Cn718/vS2FpDGf8
         eOdTxOzVuuShd4WL6pVgd2plrnjGhRcU6Nkf7kCOS1Dg8f8TVM0l0PKDQY8PjRUEBH/y
         RfRQT94waLMDFzY09VNZctqdDa6+aJemKx+EQ1sOtD9hbdrfAGNyWLhzit05/zYB2Wo+
         JFslYfqZkoXfyKGRHNSt1RxailMXAMvI6uTG3CzuGrhwE6tKH76QRkrTwG7WH89+X02c
         IXGQ==
X-Gm-Message-State: AOJu0YwgpF8849KIQB3mGpcsQ50jFBCRYalPFV/cYFFjfYUULed3SOHa
	e3KCo5LsNVz21b1Gd5gRoeh9WURKkwNewJfPoGvAYP2cR/uksXUdc910ISep
X-Google-Smtp-Source: AGHT+IFCEzQLXKIqN4BqHy3gm5DlzRzSR/1MbojbnzDjpRX85YqJLqiGszknL16tOpmbj1rEt1EsBQ==
X-Received: by 2002:a05:600c:a007:b0:413:f58f:2f66 with SMTP id jg7-20020a05600ca00700b00413f58f2f66mr4274484wmb.9.1710539248420;
        Fri, 15 Mar 2024 14:47:28 -0700 (PDT)
Received: from 127.0.0.1localhost ([185.69.144.99])
        by smtp.gmail.com with ESMTPSA id m15-20020a05600c4f4f00b004130c1dc29csm7040881wmq.22.2024.03.15.14.47.27
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 15 Mar 2024 14:47:27 -0700 (PDT)
From: Pavel Begunkov <asml.silence@gmail.com>
To: io-uring@vger.kernel.org
Cc: Jens Axboe <axboe@kernel.dk>,
	asml.silence@gmail.com
Subject: [PATCH 2/3] io_uring: refactor io_req_complete_post()
Date: Fri, 15 Mar 2024 21:46:01 +0000
Message-ID: <f0d46b81e799e36d85d4daf12e2696c022bf88fb.1710538932.git.asml.silence@gmail.com>
X-Mailer: git-send-email 2.43.0
In-Reply-To: <cover.1710538932.git.asml.silence@gmail.com>
References: <cover.1710538932.git.asml.silence@gmail.com>
Precedence: bulk
X-Mailing-List: io-uring@vger.kernel.org
List-Id: <io-uring.vger.kernel.org>
List-Subscribe: <mailto:io-uring+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:io-uring+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

Make io_req_complete_post() to push all IORING_SETUP_IOPOLL requests
to task_work, it's much cleaner and should normally happen. We couldn't
do it before because there was a possibility of looping in

complete_post() -> tw -> complete_post() -> ...

Also, unexport the function and inline __io_req_complete_post().

Signed-off-by: Pavel Begunkov <asml.silence@gmail.com>
---
 io_uring/io_uring.c | 29 +++++++++++------------------
 io_uring/io_uring.h |  1 -
 2 files changed, 11 insertions(+), 19 deletions(-)

diff --git a/io_uring/io_uring.c b/io_uring/io_uring.c
index 025709cadab9..846d67a9c72e 100644
--- a/io_uring/io_uring.c
+++ b/io_uring/io_uring.c
@@ -926,11 +926,21 @@ bool io_req_post_cqe(struct io_kiocb *req, s32 res, u32 cflags)
 	return posted;
 }
 
-static void __io_req_complete_post(struct io_kiocb *req, unsigned issue_flags)
+static void io_req_complete_post(struct io_kiocb *req, unsigned issue_flags)
 {
 	struct io_ring_ctx *ctx = req->ctx;
 	struct io_rsrc_node *rsrc_node = NULL;
 
+	/*
+	 * Handle special CQ sync cases via task_work. DEFER_TASKRUN requires
+	 * the submitter task context, IOPOLL protects with uring_lock.
+	 */
+	if (ctx->task_complete || (ctx->flags & IORING_SETUP_IOPOLL)) {
+		req->io_task_work.func = io_req_task_complete;
+		io_req_task_work_add(req);
+		return;
+	}
+
 	io_cq_lock(ctx);
 	if (!(req->flags & REQ_F_CQE_SKIP)) {
 		if (!io_fill_cqe_req(ctx, req))
@@ -974,23 +984,6 @@ static void __io_req_complete_post(struct io_kiocb *req, unsigned issue_flags)
 	}
 }
 
-void io_req_complete_post(struct io_kiocb *req, unsigned issue_flags)
-{
-	struct io_ring_ctx *ctx = req->ctx;
-
-	if (ctx->task_complete) {
-		req->io_task_work.func = io_req_task_complete;
-		io_req_task_work_add(req);
-	} else if (!(issue_flags & IO_URING_F_UNLOCKED) ||
-		   !(ctx->flags & IORING_SETUP_IOPOLL)) {
-		__io_req_complete_post(req, issue_flags);
-	} else {
-		mutex_lock(&ctx->uring_lock);
-		__io_req_complete_post(req, issue_flags & ~IO_URING_F_UNLOCKED);
-		mutex_unlock(&ctx->uring_lock);
-	}
-}
-
 void io_req_defer_failed(struct io_kiocb *req, s32 res)
 	__must_hold(&ctx->uring_lock)
 {
diff --git a/io_uring/io_uring.h b/io_uring/io_uring.h
index 4bc96470e591..db6cab40bbbf 100644
--- a/io_uring/io_uring.h
+++ b/io_uring/io_uring.h
@@ -65,7 +65,6 @@ bool io_cqe_cache_refill(struct io_ring_ctx *ctx, bool overflow);
 void io_req_cqe_overflow(struct io_kiocb *req);
 int io_run_task_work_sig(struct io_ring_ctx *ctx);
 void io_req_defer_failed(struct io_kiocb *req, s32 res);
-void io_req_complete_post(struct io_kiocb *req, unsigned issue_flags);
 bool io_post_aux_cqe(struct io_ring_ctx *ctx, u64 user_data, s32 res, u32 cflags);
 bool io_req_post_cqe(struct io_kiocb *req, s32 res, u32 cflags);
 void __io_commit_cqring_flush(struct io_ring_ctx *ctx);
-- 
2.43.0


