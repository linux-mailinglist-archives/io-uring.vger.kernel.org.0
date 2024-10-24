Return-Path: <io-uring+bounces-3991-lists+io-uring=lfdr.de@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [IPv6:2604:1380:4601:e00::3])
	by mail.lfdr.de (Postfix) with ESMTPS id 60E869AED31
	for <lists+io-uring@lfdr.de>; Thu, 24 Oct 2024 19:08:46 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id DA8651F23834
	for <lists+io-uring@lfdr.de>; Thu, 24 Oct 2024 17:08:45 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 490621F81A8;
	Thu, 24 Oct 2024 17:08:41 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel-dk.20230601.gappssmtp.com header.i=@kernel-dk.20230601.gappssmtp.com header.b="avDo21cG"
X-Original-To: io-uring@vger.kernel.org
Received: from mail-io1-f49.google.com (mail-io1-f49.google.com [209.85.166.49])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id AC38C19DF7A
	for <io-uring@vger.kernel.org>; Thu, 24 Oct 2024 17:08:38 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.166.49
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1729789721; cv=none; b=BW5wUqIgb/nrkFaHpiByUCNRSfBiE19EPbT1WEAE8eKtMtT+M+iL/BPEBb8JVJm+o5dLybTQEt1vW6W4n77UQNONvg0B8h5JJmp2GSV5fN9bbn+dBzpVtlMeoWwjprvaBVxFV/IfMCoGv2DeMU9hsjb+HfKAR3RF4DmtT+HnQls=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1729789721; c=relaxed/simple;
	bh=j3VmYIUYlyBTGlqvUIMc0JUgVTjmWoaF5EMC9Dn7Zk0=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=GZHcxiklGp7VbA90uU0W+rFs46Nu+EGwSxizSF8CPR0QcW0paMep5ey29H2EiXVFnlqfMYUUyaGlsAQToNIV+eTfM7oKUUd9kghLumTj2+7+lkMzPalLqW6n0uA/774qKtcFdVmtlRhrNfNwIcCT6evb0c1G9wGmMf0XrN99Aj8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=kernel.dk; spf=pass smtp.mailfrom=kernel.dk; dkim=pass (2048-bit key) header.d=kernel-dk.20230601.gappssmtp.com header.i=@kernel-dk.20230601.gappssmtp.com header.b=avDo21cG; arc=none smtp.client-ip=209.85.166.49
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=kernel.dk
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=kernel.dk
Received: by mail-io1-f49.google.com with SMTP id ca18e2360f4ac-83aad99d6bfso44974339f.0
        for <io-uring@vger.kernel.org>; Thu, 24 Oct 2024 10:08:38 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernel-dk.20230601.gappssmtp.com; s=20230601; t=1729789717; x=1730394517; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=5+0vcL80oErDAtwoUFPo8e5XBLS2uO6xNRw7O3/obNg=;
        b=avDo21cG8vpvWrsdIpdqeZaXBymApLXUNrRsL+ZJ2cMQLj5bNL9fsO1XbzopZZdH5D
         +HpvX5TUQQTErrZT1+M1ulKcn25VIxd+yQNNXCWv+Dba/wdmHCkOnWIUy3qOE9EKPCJN
         LuzF8Q7IyRxMeI4UgUUCC6ce1Q2ptc+SgZvdxHYPDlTFYvH5ih/WD68WO8S3OR+rNpng
         WdJFxvPyTqtNG4gjtw8uyhYGDUkuQEF1UVPmGEGodOfYjdKfFlZ7Fnd6A1Vems7GBLIY
         uZumlNWGZQ+VtfJ1O9nG3zNS6abhGMDbUK5uNIy0dU5GzjNcvkXxDjwJCOJd2t+1rlcH
         78SQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1729789717; x=1730394517;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=5+0vcL80oErDAtwoUFPo8e5XBLS2uO6xNRw7O3/obNg=;
        b=bq/UXNyeQLoin3UZyd22//pLMXTx652fG/3s10LW5hA0OD0BrBTwJF9hXtZ3qYYySp
         zpVAvBjyod5ulhKbMv9adg1CUcfhSqJ74fOLfg+SIO6+ykR/LIrKL/SIaJNZro7bJEgK
         BrAaqvUBrQI7LpgX3nM8oQQ0DoRCJ87ZuB+rij+ElewwQCYsgnHsgdexSLMrbByUhmYw
         f5qLnn8JmCciTgUeMWloITS10hR7VRgitHS80bvPpH7TWee6vUYTJ2zk8NGLggS7WKpn
         0/oP0dEJUndvPBFAtfJq7o5B0cOfJueUPqdce3uomy3lPDFQ2B57EWaZ0hac2YV+8ODT
         JOhw==
X-Gm-Message-State: AOJu0YwXc1CgaNnZLsu27UFsVbGO3gKdLHd1lFFSPe79zsG+77dcUE1l
	Yn1HyFMOHEg+afiCiwb6KzlUlY1cPMszIiTjmEyQh7k/MwQa72LRZzPnIikqA5R0av83wiq9NIi
	f
X-Google-Smtp-Source: AGHT+IG70rOEhgDa+XfsRbOn+lxE4A8i/O3PO1R7G4Kg562ovTYd1Y8hXCtyBb19X6WB0CrhG1muVg==
X-Received: by 2002:a05:6e02:214d:b0:3a0:9fa5:8f1 with SMTP id e9e14a558f8ab-3a4d59df6d6mr81512095ab.24.1729789717134;
        Thu, 24 Oct 2024 10:08:37 -0700 (PDT)
Received: from localhost.localdomain ([96.43.243.2])
        by smtp.gmail.com with ESMTPSA id e9e14a558f8ab-3a400b63981sm31368045ab.67.2024.10.24.10.08.36
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 24 Oct 2024 10:08:36 -0700 (PDT)
From: Jens Axboe <axboe@kernel.dk>
To: io-uring@vger.kernel.org
Cc: jannh@google.com,
	Jens Axboe <axboe@kernel.dk>
Subject: [PATCH 2/4] io_uring: abstract out a bit of the ring filling logic
Date: Thu, 24 Oct 2024 11:07:37 -0600
Message-ID: <20241024170829.1266002-3-axboe@kernel.dk>
X-Mailer: git-send-email 2.45.2
In-Reply-To: <20241024170829.1266002-1-axboe@kernel.dk>
References: <20241024170829.1266002-1-axboe@kernel.dk>
Precedence: bulk
X-Mailing-List: io-uring@vger.kernel.org
List-Id: <io-uring.vger.kernel.org>
List-Subscribe: <mailto:io-uring+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:io-uring+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

Abstract out a io_uring_fill_params() helper, which fills out the
necessary bits of struct io_uring_params. Add it to io_uring.h as well,
in preparation for having another internal user of it.

Signed-off-by: Jens Axboe <axboe@kernel.dk>
---
 io_uring/io_uring.c | 70 ++++++++++++++++++++++++++-------------------
 io_uring/io_uring.h |  1 +
 2 files changed, 41 insertions(+), 30 deletions(-)

diff --git a/io_uring/io_uring.c b/io_uring/io_uring.c
index 6dea5242d666..b5974bdad48b 100644
--- a/io_uring/io_uring.c
+++ b/io_uring/io_uring.c
@@ -3498,14 +3498,8 @@ static struct file *io_uring_get_file(struct io_ring_ctx *ctx)
 					 O_RDWR | O_CLOEXEC, NULL);
 }
 
-static __cold int io_uring_create(unsigned entries, struct io_uring_params *p,
-				  struct io_uring_params __user *params)
+int io_uring_fill_params(unsigned entries, struct io_uring_params *p)
 {
-	struct io_ring_ctx *ctx;
-	struct io_uring_task *tctx;
-	struct file *file;
-	int ret;
-
 	if (!entries)
 		return -EINVAL;
 	if (entries > IORING_MAX_ENTRIES) {
@@ -3547,6 +3541,42 @@ static __cold int io_uring_create(unsigned entries, struct io_uring_params *p,
 		p->cq_entries = 2 * p->sq_entries;
 	}
 
+	p->sq_off.head = offsetof(struct io_rings, sq.head);
+	p->sq_off.tail = offsetof(struct io_rings, sq.tail);
+	p->sq_off.ring_mask = offsetof(struct io_rings, sq_ring_mask);
+	p->sq_off.ring_entries = offsetof(struct io_rings, sq_ring_entries);
+	p->sq_off.flags = offsetof(struct io_rings, sq_flags);
+	p->sq_off.dropped = offsetof(struct io_rings, sq_dropped);
+	p->sq_off.resv1 = 0;
+	if (!(p->flags & IORING_SETUP_NO_MMAP))
+		p->sq_off.user_addr = 0;
+
+	p->cq_off.head = offsetof(struct io_rings, cq.head);
+	p->cq_off.tail = offsetof(struct io_rings, cq.tail);
+	p->cq_off.ring_mask = offsetof(struct io_rings, cq_ring_mask);
+	p->cq_off.ring_entries = offsetof(struct io_rings, cq_ring_entries);
+	p->cq_off.overflow = offsetof(struct io_rings, cq_overflow);
+	p->cq_off.cqes = offsetof(struct io_rings, cqes);
+	p->cq_off.flags = offsetof(struct io_rings, cq_flags);
+	p->cq_off.resv1 = 0;
+	if (!(p->flags & IORING_SETUP_NO_MMAP))
+		p->cq_off.user_addr = 0;
+
+	return 0;
+}
+
+static __cold int io_uring_create(unsigned entries, struct io_uring_params *p,
+				  struct io_uring_params __user *params)
+{
+	struct io_ring_ctx *ctx;
+	struct io_uring_task *tctx;
+	struct file *file;
+	int ret;
+
+	ret = io_uring_fill_params(entries, p);
+	if (unlikely(ret))
+		return ret;
+
 	ctx = io_ring_ctx_alloc(p);
 	if (!ctx)
 		return -ENOMEM;
@@ -3630,6 +3660,9 @@ static __cold int io_uring_create(unsigned entries, struct io_uring_params *p,
 	if (ret)
 		goto err;
 
+	if (!(p->flags & IORING_SETUP_NO_SQARRAY))
+		p->sq_off.array = (char *)ctx->sq_array - (char *)ctx->rings;
+
 	ret = io_sq_offload_create(ctx, p);
 	if (ret)
 		goto err;
@@ -3638,29 +3671,6 @@ static __cold int io_uring_create(unsigned entries, struct io_uring_params *p,
 	if (ret)
 		goto err;
 
-	p->sq_off.head = offsetof(struct io_rings, sq.head);
-	p->sq_off.tail = offsetof(struct io_rings, sq.tail);
-	p->sq_off.ring_mask = offsetof(struct io_rings, sq_ring_mask);
-	p->sq_off.ring_entries = offsetof(struct io_rings, sq_ring_entries);
-	p->sq_off.flags = offsetof(struct io_rings, sq_flags);
-	p->sq_off.dropped = offsetof(struct io_rings, sq_dropped);
-	if (!(ctx->flags & IORING_SETUP_NO_SQARRAY))
-		p->sq_off.array = (char *)ctx->sq_array - (char *)ctx->rings;
-	p->sq_off.resv1 = 0;
-	if (!(ctx->flags & IORING_SETUP_NO_MMAP))
-		p->sq_off.user_addr = 0;
-
-	p->cq_off.head = offsetof(struct io_rings, cq.head);
-	p->cq_off.tail = offsetof(struct io_rings, cq.tail);
-	p->cq_off.ring_mask = offsetof(struct io_rings, cq_ring_mask);
-	p->cq_off.ring_entries = offsetof(struct io_rings, cq_ring_entries);
-	p->cq_off.overflow = offsetof(struct io_rings, cq_overflow);
-	p->cq_off.cqes = offsetof(struct io_rings, cqes);
-	p->cq_off.flags = offsetof(struct io_rings, cq_flags);
-	p->cq_off.resv1 = 0;
-	if (!(ctx->flags & IORING_SETUP_NO_MMAP))
-		p->cq_off.user_addr = 0;
-
 	p->features = IORING_FEAT_SINGLE_MMAP | IORING_FEAT_NODROP |
 			IORING_FEAT_SUBMIT_STABLE | IORING_FEAT_RW_CUR_POS |
 			IORING_FEAT_CUR_PERSONALITY | IORING_FEAT_FAST_POLL |
diff --git a/io_uring/io_uring.h b/io_uring/io_uring.h
index 4a471a810f02..e3e6cb14de5d 100644
--- a/io_uring/io_uring.h
+++ b/io_uring/io_uring.h
@@ -70,6 +70,7 @@ static inline bool io_should_wake(struct io_wait_queue *iowq)
 
 unsigned long rings_size(unsigned int flags, unsigned int sq_entries,
 			 unsigned int cq_entries, size_t *sq_offset);
+int io_uring_fill_params(unsigned entries, struct io_uring_params *p);
 bool io_cqe_cache_refill(struct io_ring_ctx *ctx, bool overflow);
 int io_run_task_work_sig(struct io_ring_ctx *ctx);
 void io_req_defer_failed(struct io_kiocb *req, s32 res);
-- 
2.45.2


