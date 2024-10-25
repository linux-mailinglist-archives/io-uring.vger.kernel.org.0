Return-Path: <io-uring+bounces-4030-lists+io-uring=lfdr.de@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [139.178.88.99])
	by mail.lfdr.de (Postfix) with ESMTPS id A86B69B0502
	for <lists+io-uring@lfdr.de>; Fri, 25 Oct 2024 16:05:35 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 6881C282608
	for <lists+io-uring@lfdr.de>; Fri, 25 Oct 2024 14:05:34 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id BA2C41FB89D;
	Fri, 25 Oct 2024 14:05:20 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel-dk.20230601.gappssmtp.com header.i=@kernel-dk.20230601.gappssmtp.com header.b="MWa5V2PH"
X-Original-To: io-uring@vger.kernel.org
Received: from mail-il1-f179.google.com (mail-il1-f179.google.com [209.85.166.179])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7E42E1B394C
	for <io-uring@vger.kernel.org>; Fri, 25 Oct 2024 14:05:17 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.166.179
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1729865120; cv=none; b=mO2xW0/cNcZpbz3vVVLK2PJz5SJ8FRp2E+p2gCbdhscjiLO6LCknZGq5QVWGHTnwwfeqrH6t7E/bppoHBeLBlyW9riQP9Fq+6jshUrCl93LwpEYTEq43gFW9uS9wVZB2cT076aRTDMGplnf/OqE+HwEz9VbvnRFP0b6MONgjVi0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1729865120; c=relaxed/simple;
	bh=eAiFpPAvsaYS5b4WbjNYVCeDTzqN4Sf1Y8gYz+2RCoM=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=t6BVYwksuTKekam97Qfl8h4szxBTQCdou3iSDvgEf7aqO7vfVLXwlXAlU3aXh2N4+1oF8d6+yeRkGGCIUa/eJmLyvanB57rqiZCFYWmMBrTvFFG/gw4DlDrrf/MeXh4j3a2Xz4c3vZDQJPoC47u68+pHfX2EbtFwt/BPcvl2Kz8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=kernel.dk; spf=pass smtp.mailfrom=kernel.dk; dkim=pass (2048-bit key) header.d=kernel-dk.20230601.gappssmtp.com header.i=@kernel-dk.20230601.gappssmtp.com header.b=MWa5V2PH; arc=none smtp.client-ip=209.85.166.179
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=kernel.dk
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=kernel.dk
Received: by mail-il1-f179.google.com with SMTP id e9e14a558f8ab-3a3f8543f5eso10256025ab.0
        for <io-uring@vger.kernel.org>; Fri, 25 Oct 2024 07:05:17 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernel-dk.20230601.gappssmtp.com; s=20230601; t=1729865116; x=1730469916; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=QifmuGZt0bFh+Z2AH/dkkDK+RN42GNXgBlCpLjpKI7Y=;
        b=MWa5V2PHqTruiwnrt9cYScKH65bHFmMint8HuPQT+bZ8j+uRHXqIN6XIVRhV50ddvR
         S/TVBcqMetN+Xl/lOUVF+9ouV6DrpbkH9FGWoHNdzDb/7KhqE5rmw25sqyiArGEnO4E7
         lkCsN7Hz0ITmBxqcPsv2O96iy2dw3WxhFlo0yJhZYfqr5fdpsZjPGdKXIF4JdD53vKF7
         rDoW7HwWx7TqyN43Byu1KcXDGpjxPZXkLruNlYDe8lUr1/o7xjzOHvWMHWa6KT58ICIZ
         DE4PxzcpUMKLQsiXGGTbmO7V9v0HcfJoVvjBftonV7dLcOTxg9PY9AAhIZMmPOxS5zQF
         i2/g==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1729865116; x=1730469916;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=QifmuGZt0bFh+Z2AH/dkkDK+RN42GNXgBlCpLjpKI7Y=;
        b=h0CqiMnSOtsCg2/b0S4/CObB8Nu3W8EwqtMM6Kha07jhZ4lr4PXyQXHAOOg+2yY2To
         aELCz0I0S3mOxyLrdLqJrxbcHBitEhLDZw1z3WK8qE5oOlRstnKzLrTBS0RJwJNePu2B
         f2GGEVISXiPj+PW/VhLG5L9VMIisLZT2Ck421DQOlWguoZC4Zpap/qQXv1YZnugRiTbc
         kARYaJTQfsC5i9Q/bLLA1qqDJ3VSluR1rWg47TGhHBYRu8iO4T6vtHcoQuX3so1pCGU2
         71OFnJ81r7haXdqfdsvPnW+KDiskWI5QSKyTjJA909v03jDN27CVFQLIuFU+MdNw1Xhj
         H3cw==
X-Gm-Message-State: AOJu0Yz2rw9jNhpaT8QZYRENNvw3Uq76TwjcSn8Js4nsHm3/JBNXdOqS
	C1/uzJxem0kCmk/yya/LrgjdVDTVbI1hlI19+DbKSvJ5jcJHtHGQYqu+jrmOmPuB4D+HFzKqXYe
	E
X-Google-Smtp-Source: AGHT+IF0uJbHhwil04AuolESzdF5+aKyXKr3xrVf94Zf7JrzBPv3vMwBrK6MhGWOIWFipHDAWsC+gg==
X-Received: by 2002:a05:6e02:1a26:b0:3a0:b0dc:1910 with SMTP id e9e14a558f8ab-3a4de74ccd6mr42784295ab.13.1729865116102;
        Fri, 25 Oct 2024 07:05:16 -0700 (PDT)
Received: from localhost.localdomain ([96.43.243.2])
        by smtp.gmail.com with ESMTPSA id e9e14a558f8ab-3a4e6e56641sm2924635ab.65.2024.10.25.07.05.14
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 25 Oct 2024 07:05:14 -0700 (PDT)
From: Jens Axboe <axboe@kernel.dk>
To: io-uring@vger.kernel.org
Cc: jannh@google.com,
	Jens Axboe <axboe@kernel.dk>
Subject: [PATCH 1/4] io_uring: move max entry definition and ring sizing into header
Date: Fri, 25 Oct 2024 08:02:28 -0600
Message-ID: <20241025140502.167623-3-axboe@kernel.dk>
X-Mailer: git-send-email 2.45.2
In-Reply-To: <20241025140502.167623-2-axboe@kernel.dk>
References: <20241025140502.167623-2-axboe@kernel.dk>
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


