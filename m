Return-Path: <io-uring+bounces-3948-lists+io-uring=lfdr.de@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [147.75.199.223])
	by mail.lfdr.de (Postfix) with ESMTPS id 1AC8C9ACF9B
	for <lists+io-uring@lfdr.de>; Wed, 23 Oct 2024 18:01:20 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id 3B1A11C2404D
	for <lists+io-uring@lfdr.de>; Wed, 23 Oct 2024 16:01:19 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id CC5041BC065;
	Wed, 23 Oct 2024 16:01:14 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel-dk.20230601.gappssmtp.com header.i=@kernel-dk.20230601.gappssmtp.com header.b="Ev5jKhTa"
X-Original-To: io-uring@vger.kernel.org
Received: from mail-io1-f46.google.com (mail-io1-f46.google.com [209.85.166.46])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id EC2881CACC8
	for <io-uring@vger.kernel.org>; Wed, 23 Oct 2024 16:01:12 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.166.46
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1729699274; cv=none; b=mHFFPbEoG8bkr5NnrgDo3oDAq71Mgo3MApQqytEJwXX3u/cOpBxGN74RL8gAFY/XB/H5LNJYJ3wcYQvIqNl3qBOQkhbJoBrQcvA9MZ1H+6cDuFEfZsekv4Hz0bMWG/+vzljLuWRGS51lLv0UdN/EMI5H+Net6JDexccko48fYKg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1729699274; c=relaxed/simple;
	bh=j3VmYIUYlyBTGlqvUIMc0JUgVTjmWoaF5EMC9Dn7Zk0=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=Aq6sRQ0XH31cwKBQMl2UfsAHlNAOo99ds/mCg2TNFMO0sFwHwbkhQ+2Xe5uNnrwWH7WvgNlMu23z/fzYh+0DOmS1UHJmakKzQnAhHI6riEtsoOz7TWYZqE2k0PT8RFWIPNrUF8sLY7Lae5Kgeh6ShnE1QaiSUCZt9HWLFHSSjkM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=kernel.dk; spf=pass smtp.mailfrom=kernel.dk; dkim=pass (2048-bit key) header.d=kernel-dk.20230601.gappssmtp.com header.i=@kernel-dk.20230601.gappssmtp.com header.b=Ev5jKhTa; arc=none smtp.client-ip=209.85.166.46
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=kernel.dk
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=kernel.dk
Received: by mail-io1-f46.google.com with SMTP id ca18e2360f4ac-83aba65556cso245964139f.3
        for <io-uring@vger.kernel.org>; Wed, 23 Oct 2024 09:01:12 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernel-dk.20230601.gappssmtp.com; s=20230601; t=1729699271; x=1730304071; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=5+0vcL80oErDAtwoUFPo8e5XBLS2uO6xNRw7O3/obNg=;
        b=Ev5jKhTahvEwgtm53+SWBPbwaQKNrYwGj7V41sjv4vdzZ9G5d2thWhhYwDVcfWsUW2
         87I3fazEozoZDbni8b1P0gbl5OJel/YfEdU4/nL+sOvXLUKbJEhTFOgiGac/yWGXByu2
         Z2pEVUK4UlLH0nKCiy8G7pVzlGEDq1qw3p1y7S31OEJTzK3+LYto+docVlQo5iq8JDv5
         6ALMYfGa9Ru1frqZ3JzOBAvLVdKhDfKPhaMO+afylgDwI0946xSqk8JnKBg+8httoPAh
         qcviuLg9pkBtJ0Z/kCdKYlb+Wm4hpd1U22e2AtP/xb3SKbodiB4z6s8/aw6J/3mYluBc
         bBzw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1729699271; x=1730304071;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=5+0vcL80oErDAtwoUFPo8e5XBLS2uO6xNRw7O3/obNg=;
        b=Tu2YVXQOShIMeC6Dx/0CisD3j5Ucm1LQcNbj07TfCJKHoTJBcU/suMr9EUEMqv0fKY
         PYhwIHkpGaXuI6BTm9JvMEQRJNIuULwALgOsgxHKlUuhNGDtyEb9X7hB6yFxXJkoxVws
         VmM81bPOUKw/d9dmJNJa0N0q2tcNgesU4q0tPpV6rLA8Lva5FBI1pVNALde5vCYo6Xn7
         jAkBxYr4KyqVcxRdi6ec4WX7qYxYQOZ5RuCP+pSaFBELWSuJORCDh+3GhSsjQnVqOigX
         Cs7Dmt8I8eYjXL4Xt7VyJ3k7qfRfvAgBph0t+0cijZ8BqiNqiJ1IeSmdwa6yPxV1vda8
         UBoA==
X-Gm-Message-State: AOJu0YxwqS6Xjm4aZbopdcIzYwAnHdLsHpdIWvGPJdY3BpByew+p0R9d
	h6dJ0wiKYmHmW+Hx3PhV33H1DlSSqRnvAG5VuWklEwSzAiiOBUL6HvjYB7wJbeT+aeJnDOjwUdA
	k
X-Google-Smtp-Source: AGHT+IH9LRHHyiZiGi+xkkcG4CexnJICeEesOx3IkBJP3YlLqAd/Fdpre1iQtl5RYtCZfFABUhV63A==
X-Received: by 2002:a05:6e02:148d:b0:3a0:98b2:8f3b with SMTP id e9e14a558f8ab-3a4d5963f65mr34090075ab.7.1729699269671;
        Wed, 23 Oct 2024 09:01:09 -0700 (PDT)
Received: from localhost.localdomain ([96.43.243.2])
        by smtp.gmail.com with ESMTPSA id 8926c6da1cb9f-4dc2a6301ecsm2115191173.135.2024.10.23.09.01.08
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 23 Oct 2024 09:01:09 -0700 (PDT)
From: Jens Axboe <axboe@kernel.dk>
To: io-uring@vger.kernel.org
Cc: Jens Axboe <axboe@kernel.dk>
Subject: [PATCH 2/3] io_uring: abstract out a bit of the ring filling logic
Date: Wed, 23 Oct 2024 09:59:52 -0600
Message-ID: <20241023160105.1125315-3-axboe@kernel.dk>
X-Mailer: git-send-email 2.45.2
In-Reply-To: <20241023160105.1125315-1-axboe@kernel.dk>
References: <20241023160105.1125315-1-axboe@kernel.dk>
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


