Return-Path: <io-uring+bounces-3947-lists+io-uring=lfdr.de@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [IPv6:2604:1380:4601:e00::3])
	by mail.lfdr.de (Postfix) with ESMTPS id DC2589ACF9A
	for <lists+io-uring@lfdr.de>; Wed, 23 Oct 2024 18:01:15 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id 618CF1F21EBE
	for <lists+io-uring@lfdr.de>; Wed, 23 Oct 2024 16:01:15 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 431E63A1DA;
	Wed, 23 Oct 2024 16:01:12 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel-dk.20230601.gappssmtp.com header.i=@kernel-dk.20230601.gappssmtp.com header.b="pPbhU5x7"
X-Original-To: io-uring@vger.kernel.org
Received: from mail-io1-f44.google.com (mail-io1-f44.google.com [209.85.166.44])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A725813B7AF
	for <io-uring@vger.kernel.org>; Wed, 23 Oct 2024 16:01:10 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.166.44
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1729699272; cv=none; b=Iq3xoRuNkA2xfS8XV//nlvTen36sehRN+T0AjiC0K6TtKHbTQojRfrzYVjrPe+alfSyYEtAVz1OxFDdZ0oAvXhsHCNIm2gnRLK0BmsHOtx/0EGsG7I7Kt18qmFRqVfggRuZsRcCi53MAwYAXrdm1m4NymY+/k2YgDufX0HxkC3A=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1729699272; c=relaxed/simple;
	bh=eAiFpPAvsaYS5b4WbjNYVCeDTzqN4Sf1Y8gYz+2RCoM=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=VlfHJI5gtX+z2VQiYCExdpG/QhWDaWEXETJEgFwswTQOCXgjFENBOg/6d/FydqrEwyqI984GgROa8x0b8rWDyGl+Do/+VE17rPOCAPNs2U4APyD21He4nc27XfZkMQdxs6MFCwTa+hLZq8Lk1i4PuhHmG886/ExVc2CfryQPTpc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=kernel.dk; spf=pass smtp.mailfrom=kernel.dk; dkim=pass (2048-bit key) header.d=kernel-dk.20230601.gappssmtp.com header.i=@kernel-dk.20230601.gappssmtp.com header.b=pPbhU5x7; arc=none smtp.client-ip=209.85.166.44
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=kernel.dk
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=kernel.dk
Received: by mail-io1-f44.google.com with SMTP id ca18e2360f4ac-83abe4524ccso210997439f.1
        for <io-uring@vger.kernel.org>; Wed, 23 Oct 2024 09:01:10 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernel-dk.20230601.gappssmtp.com; s=20230601; t=1729699269; x=1730304069; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=QifmuGZt0bFh+Z2AH/dkkDK+RN42GNXgBlCpLjpKI7Y=;
        b=pPbhU5x7tTQToIq5VVcYomttQcEVp1dUJv7Ufg2E8pqFKj2uyMGhgtbf+ziEhBlyxX
         90AieVweBYYuti+76BmCLU3IGm5AIL+KJCTkTwkJNbh7Iqh9lxsj1VhuHMFH2xl84h7p
         VAur9sBnA7xmqDKtHmYmCHcP5N5phva5aGZboj8HaDmgLQINnUa2NLk4TYL34W08q6XK
         p4onOnEiSgBkKIGcGym4SRzyv4n8OEHfcAqdDM3TF+OXNGEDV58zNjJCpDu838vibRKN
         mZ8xL6s7XdNBrvixkxjkCIQ3ZiBfHQLymMCBXWein29LtNsgQ6ACzZcY4W5PTei6buWv
         WVig==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1729699269; x=1730304069;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=QifmuGZt0bFh+Z2AH/dkkDK+RN42GNXgBlCpLjpKI7Y=;
        b=B4LscoLvCrDEz82cjtAJcnjbwOExVx4o7BnL8onOHjbFrsNj4cY8O3DR0rScL5S5cQ
         mqnxRiV7fRd3H1vEBXztnNpMoaohP3hcNavxvdGr7YhyPELpCOYP7hEZG+4u8A1A06rH
         +lurWF9ho94O2LDvVJHURaaqv6jXGr0wymWpsSCsxXhQL359JdlrdABhhXdY55m6wEuc
         1OFD58etDrivk4rMqD5QiP9/UaFfFQhcbrqanmannIdAxsbIVZyNv0JdxUcdLU6TxUoy
         Qm7Ri7pPa2iMfcltXQLHARlNY7c9dCi3s0QuaOoR7qmoU2IQ+/snzM1TQTVurheguqYV
         P0Bg==
X-Gm-Message-State: AOJu0Yz6QGbQO2lThPd1o0i4ELOa80iYe/KBI3y2rHzJKrF+Ip+HzFgq
	hqgPxIsYNq9K9mnlYrD1vNlAVh3fDQ5HWQGCoDrCVUVi49pjEi5HHLuxCf6rqgt7ysM+Htptz89
	K
X-Google-Smtp-Source: AGHT+IHvhx1RWpkyYrb/4c/i2ZxD4bsb13Yjhk05MELTfDNYr4w6s6Y66dEAkW4Dt9bC7esKLtrIwg==
X-Received: by 2002:a05:6602:485:b0:837:6dae:207b with SMTP id ca18e2360f4ac-83af6407c0amr414711139f.16.1729699268753;
        Wed, 23 Oct 2024 09:01:08 -0700 (PDT)
Received: from localhost.localdomain ([96.43.243.2])
        by smtp.gmail.com with ESMTPSA id 8926c6da1cb9f-4dc2a6301ecsm2115191173.135.2024.10.23.09.01.08
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 23 Oct 2024 09:01:08 -0700 (PDT)
From: Jens Axboe <axboe@kernel.dk>
To: io-uring@vger.kernel.org
Cc: Jens Axboe <axboe@kernel.dk>
Subject: [PATCH 1/3] io_uring: move max entry definition and ring sizing into header
Date: Wed, 23 Oct 2024 09:59:51 -0600
Message-ID: <20241023160105.1125315-2-axboe@kernel.dk>
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

In preparation for needing this somewhere else, move the definitions
for the maximum CQ and SQ ring size into io_uring.h. Make the
rings_size() helper available as well, and have it take just the setup
flags argument rather than the fill ring pointer. That's all that is
needed.

Signed-off-by: Jens Axboe <axboe@kernel.dk>
---
 io_uring/io_uring.c | 14 ++++++--------
 io_uring/io_uring.h |  5 +++++
 2 files changed, 11 insertions(+), 8 deletions(-)

diff --git a/io_uring/io_uring.c b/io_uring/io_uring.c
index 58b401900b41..6dea5242d666 100644
--- a/io_uring/io_uring.c
+++ b/io_uring/io_uring.c
@@ -105,9 +105,6 @@
 #include "alloc_cache.h"
 #include "eventfd.h"
 
-#define IORING_MAX_ENTRIES	32768
-#define IORING_MAX_CQ_ENTRIES	(2 * IORING_MAX_ENTRIES)
-
 #define SQE_COMMON_FLAGS (IOSQE_FIXED_FILE | IOSQE_IO_LINK | \
 			  IOSQE_IO_HARDLINK | IOSQE_ASYNC)
 
@@ -2667,8 +2664,8 @@ static void io_rings_free(struct io_ring_ctx *ctx)
 	ctx->sq_sqes = NULL;
 }
 
-static unsigned long rings_size(struct io_ring_ctx *ctx, unsigned int sq_entries,
-				unsigned int cq_entries, size_t *sq_offset)
+unsigned long rings_size(unsigned int flags, unsigned int sq_entries,
+			 unsigned int cq_entries, size_t *sq_offset)
 {
 	struct io_rings *rings;
 	size_t off, sq_array_size;
@@ -2676,7 +2673,7 @@ static unsigned long rings_size(struct io_ring_ctx *ctx, unsigned int sq_entries
 	off = struct_size(rings, cqes, cq_entries);
 	if (off == SIZE_MAX)
 		return SIZE_MAX;
-	if (ctx->flags & IORING_SETUP_CQE32) {
+	if (flags & IORING_SETUP_CQE32) {
 		if (check_shl_overflow(off, 1, &off))
 			return SIZE_MAX;
 	}
@@ -2687,7 +2684,7 @@ static unsigned long rings_size(struct io_ring_ctx *ctx, unsigned int sq_entries
 		return SIZE_MAX;
 #endif
 
-	if (ctx->flags & IORING_SETUP_NO_SQARRAY) {
+	if (flags & IORING_SETUP_NO_SQARRAY) {
 		*sq_offset = SIZE_MAX;
 		return off;
 	}
@@ -3434,7 +3431,8 @@ static __cold int io_allocate_scq_urings(struct io_ring_ctx *ctx,
 	ctx->sq_entries = p->sq_entries;
 	ctx->cq_entries = p->cq_entries;
 
-	size = rings_size(ctx, p->sq_entries, p->cq_entries, &sq_array_offset);
+	size = rings_size(ctx->flags, p->sq_entries, p->cq_entries,
+			  &sq_array_offset);
 	if (size == SIZE_MAX)
 		return -EOVERFLOW;
 
diff --git a/io_uring/io_uring.h b/io_uring/io_uring.h
index 9cd9a127e9ed..4a471a810f02 100644
--- a/io_uring/io_uring.h
+++ b/io_uring/io_uring.h
@@ -65,6 +65,11 @@ static inline bool io_should_wake(struct io_wait_queue *iowq)
 	return dist >= 0 || atomic_read(&ctx->cq_timeouts) != iowq->nr_timeouts;
 }
 
+#define IORING_MAX_ENTRIES	32768
+#define IORING_MAX_CQ_ENTRIES	(2 * IORING_MAX_ENTRIES)
+
+unsigned long rings_size(unsigned int flags, unsigned int sq_entries,
+			 unsigned int cq_entries, size_t *sq_offset);
 bool io_cqe_cache_refill(struct io_ring_ctx *ctx, bool overflow);
 int io_run_task_work_sig(struct io_ring_ctx *ctx);
 void io_req_defer_failed(struct io_kiocb *req, s32 res);
-- 
2.45.2


