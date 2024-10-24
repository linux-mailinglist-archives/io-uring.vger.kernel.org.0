Return-Path: <io-uring+bounces-3990-lists+io-uring=lfdr.de@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [147.75.80.249])
	by mail.lfdr.de (Postfix) with ESMTPS id D86C49AED30
	for <lists+io-uring@lfdr.de>; Thu, 24 Oct 2024 19:08:44 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id 6499C1F23142
	for <lists+io-uring@lfdr.de>; Thu, 24 Oct 2024 17:08:44 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 91C71167DAC;
	Thu, 24 Oct 2024 17:08:40 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel-dk.20230601.gappssmtp.com header.i=@kernel-dk.20230601.gappssmtp.com header.b="jYyg2aSy"
X-Original-To: io-uring@vger.kernel.org
Received: from mail-io1-f53.google.com (mail-io1-f53.google.com [209.85.166.53])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 68B1F1F81A8
	for <io-uring@vger.kernel.org>; Thu, 24 Oct 2024 17:08:37 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.166.53
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1729789720; cv=none; b=MTXvL+Cn08fGHEWJ4382YJEzymPXRBkLT32x1YkjcOMpfGZMN2hQOc7CVvsqFnp7gWMtclIfpO8koBhx45T5WV1Gwr99pEgjDwFWEpOGQHfML9t4KG0Jb1zLZslTZlcHmpzbrqhHkbHFiaiM/1l3ZABgRzl/Ue9BAy9HpSD7P5k=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1729789720; c=relaxed/simple;
	bh=eAiFpPAvsaYS5b4WbjNYVCeDTzqN4Sf1Y8gYz+2RCoM=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=aakZzwoGoUuxtizKojxyPKyHm3y4Cz1eALABndyJlJxTx0yZ+K9hws02cNiHutotwve9AZCELff+5MOX2glgZyebymQDC2Wh8+nJjTFv19/Joalfax9NSRFYSzimYLM4f/3mcp25pa/hQ3hZQ2HZKDZcKmGXs5Teph+jtyEYmAM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=kernel.dk; spf=pass smtp.mailfrom=kernel.dk; dkim=pass (2048-bit key) header.d=kernel-dk.20230601.gappssmtp.com header.i=@kernel-dk.20230601.gappssmtp.com header.b=jYyg2aSy; arc=none smtp.client-ip=209.85.166.53
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=kernel.dk
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=kernel.dk
Received: by mail-io1-f53.google.com with SMTP id ca18e2360f4ac-83aff992087so49709339f.3
        for <io-uring@vger.kernel.org>; Thu, 24 Oct 2024 10:08:37 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernel-dk.20230601.gappssmtp.com; s=20230601; t=1729789716; x=1730394516; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=QifmuGZt0bFh+Z2AH/dkkDK+RN42GNXgBlCpLjpKI7Y=;
        b=jYyg2aSyh48GDmBo5xEeEfpa05sC/wq3xwUtmrV9NC4cTAHS7pkfGgNsKXOlcfR3t9
         RwthkKhpUYcqYhO9gtIOjj2wYhuipogU+dBoN2anRlRZWIWQIWcm3nPePXQA54xsQp37
         Gd6QA2KEi21Uvn7agp5Qmxgnjp10HkJKDfqp0T+dbqWM/IdhSua8nsDkxDBQGlJ/cuVE
         bzEouAPaD5MILKwXBfbwoXqL988K3jOcmnx/ggiOzS6iTXLdtrB1g64fTZS+TR84rggw
         zjHlqYWRqNPs+LmU0qVSBuYzx94WdDy/Jsulf1K6n2n/NcdxdcWBKu+iJmHKArv48LFz
         Wwhg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1729789716; x=1730394516;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=QifmuGZt0bFh+Z2AH/dkkDK+RN42GNXgBlCpLjpKI7Y=;
        b=Y6IU7DcjlaRyTrwBFKGbzLHrks8ExkJVk938CU98thRL6uJGSFEO+oVLmARoWfE3gb
         bOBGZcMfU9qw3KP4GCx+GdpvVKGMl1RETvS+LcB3rUOI+LDHchj6w4XouYO8kylqValu
         Gq8nO3hAVk4LYZO/mzI10WxjgniFt3xhhKqxTkPCeydyGQ32sn/rz7Qv23IVojZKyXMR
         PEQ7bc8au8AP3YAsrDZHtXeTkEQDna1eJi08TuOWEW98RNlOz+rQAXhVaSQl+yghXdHC
         BflE9kPnrU1+NAqQcLq//3JzN980nall02pnsURonOHXSEtld9O8hX0D4FjcIV4CAMuZ
         F1lg==
X-Gm-Message-State: AOJu0YxzK9hJweHo3K4LAnrTg1fDjE5wKZklfsqLDHTK+4hobFIzr/a0
	XSs2UCLJuMUi8NX5I6COUD9vG0x19Jjyp6zMycnh0/mm9H3qtsuiQ9qDtSfbmnvRRzR0u9D1ZTT
	E
X-Google-Smtp-Source: AGHT+IFLilFyzrpOUsc/c+COE+9KN1Pu6NEY8OFB8KEHWAz+wTaKrnph6kHhYXf7iqa+a+NIbzOswA==
X-Received: by 2002:a05:6e02:1ca3:b0:3a0:4250:165f with SMTP id e9e14a558f8ab-3a4de6e251dmr30189255ab.0.1729789715885;
        Thu, 24 Oct 2024 10:08:35 -0700 (PDT)
Received: from localhost.localdomain ([96.43.243.2])
        by smtp.gmail.com with ESMTPSA id e9e14a558f8ab-3a400b63981sm31368045ab.67.2024.10.24.10.08.33
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 24 Oct 2024 10:08:34 -0700 (PDT)
From: Jens Axboe <axboe@kernel.dk>
To: io-uring@vger.kernel.org
Cc: jannh@google.com,
	Jens Axboe <axboe@kernel.dk>
Subject: [PATCH 1/4] io_uring: move max entry definition and ring sizing into header
Date: Thu, 24 Oct 2024 11:07:36 -0600
Message-ID: <20241024170829.1266002-2-axboe@kernel.dk>
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


