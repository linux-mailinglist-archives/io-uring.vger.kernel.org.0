Return-Path: <io-uring+bounces-2258-lists+io-uring=lfdr.de@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [139.178.88.99])
	by mail.lfdr.de (Postfix) with ESMTPS id 56D7990DC05
	for <lists+io-uring@lfdr.de>; Tue, 18 Jun 2024 20:56:57 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 3F6B62852E2
	for <lists+io-uring@lfdr.de>; Tue, 18 Jun 2024 18:56:47 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 905D915E5CA;
	Tue, 18 Jun 2024 18:56:43 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel-dk.20230601.gappssmtp.com header.i=@kernel-dk.20230601.gappssmtp.com header.b="0gjfTgis"
X-Original-To: io-uring@vger.kernel.org
Received: from mail-ot1-f53.google.com (mail-ot1-f53.google.com [209.85.210.53])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 151E215ECE0
	for <io-uring@vger.kernel.org>; Tue, 18 Jun 2024 18:56:41 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.210.53
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1718737003; cv=none; b=FnKIKEtUnuXDe1AmR/ePc/qb1k1N5PKKiD38ypD2BDxfCiB/2+nSDIE03QILIJZ6/PwtDSIxizN30dqfCltMJBNT63kHZNKnLgUdvIM81kII674OnyCjZTeV7AXCY8zjr8n+gNTvtQp9nU2jbgmKvcVLN5MfVnGmm3/gcLXq124=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1718737003; c=relaxed/simple;
	bh=tRPO2ZimasNp6SbR6mX4GdyVsUhzV0yZwZPDdD//dJ0=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=c1l6AMxu2MaIHA2UsJIUAAodiI4NVWD74XjbXCj7MU+PTYrJvswK3AG+6eH/8jh0Y8BCoDpFgjzSHtf6Wnx5QOhSnfro46c3FMPh2PmYRqEN7r1GjhFZGAtWETfmRZIp+551o+com8KIQffUCelMjuq39gw9GMYjMMk3kaOYjGs=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=kernel.dk; spf=pass smtp.mailfrom=kernel.dk; dkim=pass (2048-bit key) header.d=kernel-dk.20230601.gappssmtp.com header.i=@kernel-dk.20230601.gappssmtp.com header.b=0gjfTgis; arc=none smtp.client-ip=209.85.210.53
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=kernel.dk
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=kernel.dk
Received: by mail-ot1-f53.google.com with SMTP id 46e09a7af769-6f96064f38cso216386a34.0
        for <io-uring@vger.kernel.org>; Tue, 18 Jun 2024 11:56:41 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernel-dk.20230601.gappssmtp.com; s=20230601; t=1718737000; x=1719341800; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=bDkIUVphJ5Gu6fW81wBdY4aANtGjmFYFCl9rBMHNECY=;
        b=0gjfTgisSTOLQKnkD0BgSACjOwoPrln3KzmsLlOrTgl/1VgEFWw7ZCYZbD+AKBX9M3
         plxG5HgBJ4s/YvcfU7zMgI2ybPxhv5AdfSnpXUlAKAAcnTITeABULvm6L3CNjee/MX+S
         Kw0o5OYqhZdjz/iMFdY1O8f2Sbb60EomzzHaD8dAJoOsgbo87yoGcPdwas3mRR4wpHnN
         KyPiMrlxIWsQIjkyGxY5U4ediElEJ26/1YFQgZMPcuI7Dcm38gXFK2b03DjiplaSIKjY
         B+uQGVrpmw66eUr25wmEBToxip5Yi+HAzRsQjTWZoH7EtR700bzRFMj7Q4YFbP4qnwbl
         e2zw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1718737000; x=1719341800;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=bDkIUVphJ5Gu6fW81wBdY4aANtGjmFYFCl9rBMHNECY=;
        b=dyPsEQHqHPTDSRPYlXRcBKAChW5sAyjrwKQtOj429wHrMyz/AWCgBVy/H4PRF0Bk6E
         oLnUdntDAb6q/BHdbMeXSYs8+aZ8gCw7QFtfN+gXSnuOq3uzVKvljeIHa/rSP9i2/ok2
         BBIhKc3dS5aF9qdb0XsoOGRJvsKzIklxeHzDEFv5GmR9LoLEvuxUPq/d2wOJ+fFZ0kFX
         2LSCweE3WFirbYAgYacNRIo1DwTdVoh43fTEhjFtEjJR4DfhCiIj0Ggq26I+CYGz3xll
         gYKSe7ZmBNGubNBs/0WTl400ND1C4jM8TWuf3v0YcbPUxxDVILx4FnFq8lniClzcc+5w
         sG7g==
X-Gm-Message-State: AOJu0Yx5V08snNiBCdnBTqjKXRgqJ7xKdSHoHHIb+TBMWWi2bcu7wfqe
	38E2GJaN0+Wrv8Zjil20R5aAQNGR3ymL52xAUaBqTmriXYRS8JcNERBgVhyb6bSh3QwARWSRYup
	V
X-Google-Smtp-Source: AGHT+IEWIPLgrgcTLXUGx/ahHkyz2xQKNEIxjnDJf8kWDkAfT0w3hLSQ+G0nD80up8kA64KgSi/6Ag==
X-Received: by 2002:a05:6870:6490:b0:254:7dbe:1b89 with SMTP id 586e51a60fabf-25c948c42c8mr742385fac.1.1718737000461;
        Tue, 18 Jun 2024 11:56:40 -0700 (PDT)
Received: from localhost.localdomain ([96.43.243.2])
        by smtp.gmail.com with ESMTPSA id 586e51a60fabf-2567a9f7d6fsm3255492fac.20.2024.06.18.11.56.39
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 18 Jun 2024 11:56:40 -0700 (PDT)
From: Jens Axboe <axboe@kernel.dk>
To: io-uring@vger.kernel.org
Cc: asml.silence@gmail.com,
	Jens Axboe <axboe@kernel.dk>
Subject: [PATCH 3/5] io_uring: add io_add_aux_cqe() helper
Date: Tue, 18 Jun 2024 12:48:42 -0600
Message-ID: <20240618185631.71781-4-axboe@kernel.dk>
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

This helper will post a CQE, and can be called from task_work where we
now that the ctx is already properly locked and that deferred
completions will get flushed later on.

Signed-off-by: Jens Axboe <axboe@kernel.dk>
---
 io_uring/io_uring.c | 23 +++++++++++++++++++++--
 io_uring/io_uring.h |  1 +
 2 files changed, 22 insertions(+), 2 deletions(-)

diff --git a/io_uring/io_uring.c b/io_uring/io_uring.c
index 85b2ce54328c..cdeb94d2a26b 100644
--- a/io_uring/io_uring.c
+++ b/io_uring/io_uring.c
@@ -801,19 +801,38 @@ static bool io_fill_cqe_aux(struct io_ring_ctx *ctx, u64 user_data, s32 res,
 	return false;
 }
 
-bool io_post_aux_cqe(struct io_ring_ctx *ctx, u64 user_data, s32 res, u32 cflags)
+static bool __io_post_aux_cqe(struct io_ring_ctx *ctx, u64 user_data, s32 res,
+			      u32 cflags)
 {
 	bool filled;
 
-	io_cq_lock(ctx);
 	filled = io_fill_cqe_aux(ctx, user_data, res, cflags);
 	if (!filled)
 		filled = io_cqring_event_overflow(ctx, user_data, res, cflags, 0, 0);
 
+	return filled;
+}
+
+bool io_post_aux_cqe(struct io_ring_ctx *ctx, u64 user_data, s32 res, u32 cflags)
+{
+	bool filled;
+
+	io_cq_lock(ctx);
+	filled = __io_post_aux_cqe(ctx, user_data, res, cflags);
 	io_cq_unlock_post(ctx);
 	return filled;
 }
 
+/*
+ * Must be called from inline task_work so we now a flush will happen later,
+ * and obviously with ctx->uring_lock held (tw always has that).
+ */
+void io_add_aux_cqe(struct io_ring_ctx *ctx, u64 user_data, s32 res, u32 cflags)
+{
+	__io_post_aux_cqe(ctx, user_data, res, cflags);
+	ctx->submit_state.cq_flush = true;
+}
+
 /*
  * A helper for multishot requests posting additional CQEs.
  * Should only be used from a task_work including IO_URING_F_MULTISHOT.
diff --git a/io_uring/io_uring.h b/io_uring/io_uring.h
index 7a8641214509..e1ce908f0679 100644
--- a/io_uring/io_uring.h
+++ b/io_uring/io_uring.h
@@ -65,6 +65,7 @@ bool io_cqe_cache_refill(struct io_ring_ctx *ctx, bool overflow);
 int io_run_task_work_sig(struct io_ring_ctx *ctx);
 void io_req_defer_failed(struct io_kiocb *req, s32 res);
 bool io_post_aux_cqe(struct io_ring_ctx *ctx, u64 user_data, s32 res, u32 cflags);
+void io_add_aux_cqe(struct io_ring_ctx *ctx, u64 user_data, s32 res, u32 cflags);
 bool io_req_post_cqe(struct io_kiocb *req, s32 res, u32 cflags);
 void __io_commit_cqring_flush(struct io_ring_ctx *ctx);
 
-- 
2.43.0


