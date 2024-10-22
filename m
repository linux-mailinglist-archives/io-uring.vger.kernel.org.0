Return-Path: <io-uring+bounces-3885-lists+io-uring=lfdr.de@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [IPv6:2604:1380:4601:e00::3])
	by mail.lfdr.de (Postfix) with ESMTPS id EDAF59A960B
	for <lists+io-uring@lfdr.de>; Tue, 22 Oct 2024 04:12:18 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id 66D431F22AAF
	for <lists+io-uring@lfdr.de>; Tue, 22 Oct 2024 02:12:18 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 714C8135A79;
	Tue, 22 Oct 2024 02:12:09 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel-dk.20230601.gappssmtp.com header.i=@kernel-dk.20230601.gappssmtp.com header.b="OHpk4MoY"
X-Original-To: io-uring@vger.kernel.org
Received: from mail-pg1-f171.google.com (mail-pg1-f171.google.com [209.85.215.171])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7A767132114
	for <io-uring@vger.kernel.org>; Tue, 22 Oct 2024 02:12:07 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.215.171
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1729563129; cv=none; b=Bvqv5xO7kDpst4ae+g1b/fm5Vj0+wB3DjvRiofnfadk97Q97nnSJkTEPKF/7eYpqUq/UncEBpS/pYo9pSeJD3V6H0HLLVpIK/VvFurYF2iburm8Xh8qJUuoe+p85/EVZvwXzY8j2SzMsb5wTvNWXy9N8ZhIdu67Wzfy+3K4/AXw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1729563129; c=relaxed/simple;
	bh=eAiFpPAvsaYS5b4WbjNYVCeDTzqN4Sf1Y8gYz+2RCoM=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=Qwqjj6l2k3EuOM/nAaKJkSI5ABwlL/z4CT/mA3YOJX9slzANlEiabX9z2CfJZ1smE60GLbxon87v1jEEulSJQ0KCr2oHTT8pkYtiU0cowpokV+KP2ocP6OuaG7qnV9HfRWPBYgW8RV8AVUADLT7MDMylE4SZCn5VL/odidG+Nec=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=kernel.dk; spf=pass smtp.mailfrom=kernel.dk; dkim=pass (2048-bit key) header.d=kernel-dk.20230601.gappssmtp.com header.i=@kernel-dk.20230601.gappssmtp.com header.b=OHpk4MoY; arc=none smtp.client-ip=209.85.215.171
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=kernel.dk
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=kernel.dk
Received: by mail-pg1-f171.google.com with SMTP id 41be03b00d2f7-7ea7e2ff5ceso3913507a12.2
        for <io-uring@vger.kernel.org>; Mon, 21 Oct 2024 19:12:07 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernel-dk.20230601.gappssmtp.com; s=20230601; t=1729563126; x=1730167926; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=QifmuGZt0bFh+Z2AH/dkkDK+RN42GNXgBlCpLjpKI7Y=;
        b=OHpk4MoY005NYMRXVWsFKgkkv6CsH9GCxWIhMG2mmPMCOJemiuvHyXL2XPO7+8Am2J
         k8iZ3g2qMJu6sZKQ2/rj/PmxoSa6HUz2mh0GBYztvxoDGPzXnY2HTGtMSypE8WoRP8W6
         WmYddhdUEo0yvX6LX4voHsd1pglJNvIBVp4+frMds44UBVkLYIUdbLxgM8l1044oskPN
         aCe+vxQGbxPDmBR24HXeuBphT7h5FdAoaDLyq8m0xMQ4LnhRH6i1ot/biEMIu3WRtzXJ
         AXfuKKUNbbz7e1W1CqNstyyrZr0aTiCdiW5+y319IjVpNIgERdhs3GRo2jFYqe4YRiub
         gw6A==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1729563126; x=1730167926;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=QifmuGZt0bFh+Z2AH/dkkDK+RN42GNXgBlCpLjpKI7Y=;
        b=r+OW9SNWB+owU8VSF+zB/ONOwZqA3Pa1WxxzUu47DIxL2XlVy7eDC8YJU3b0QpWJqH
         7H680+HQ2GQqRMpkLD6AQnen/alsKxFxL3fnye2djfE6n/u5ZV85HpLinvbWNeDDba9a
         VM6/NU8bKGYxTYHyoiCZs4N4a5ORD5BZ/KbE/86mniFLkqPrnsg+LUvL/mAaG2uJSMX2
         477AUZVdLPL+Fj1o9g9s1tmXvEuRUBASJcgfgMqrB5BYVz1VAy9RwvYc9icrTnzZyk69
         70vPQsXpVtE97RjRS2oQHUQmCpcSWrWMsq97qXH9iSf6Up9wfheyizCUeeWcFfs1vrQZ
         rsew==
X-Gm-Message-State: AOJu0YzkO3qWC1O2AB5eAUEvnrP9besaqbncyLcXhtCnL7NjsU378a6W
	9jvJqObPv7oNALOY7/Ek+A9oV2C5MQftXKixA8OPTwu/RQ6YGptFFc4451fGOtqBjS6a1U+VmWa
	y
X-Google-Smtp-Source: AGHT+IFEOe+mT/omPgjJ48sFjTJYf1o4s/x22UW5Qq40w5mXrAKpCmKZa4A4wUyb3hZLPZ+KiBQdiw==
X-Received: by 2002:a05:6a21:2fc7:b0:1d9:d04:586d with SMTP id adf61e73a8af0-1d96b83f27emr2433533637.38.1729563126255;
        Mon, 21 Oct 2024 19:12:06 -0700 (PDT)
Received: from localhost.localdomain ([198.8.77.157])
        by smtp.gmail.com with ESMTPSA id d2e1a72fcca58-71ec131477asm3747060b3a.10.2024.10.21.19.12.04
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 21 Oct 2024 19:12:05 -0700 (PDT)
From: Jens Axboe <axboe@kernel.dk>
To: io-uring@vger.kernel.org
Cc: Jens Axboe <axboe@kernel.dk>
Subject: [PATCH 1/3] io_uring: move max entry definition and ring sizing into header
Date: Mon, 21 Oct 2024 20:08:28 -0600
Message-ID: <20241022021159.820925-2-axboe@kernel.dk>
X-Mailer: git-send-email 2.45.2
In-Reply-To: <20241022021159.820925-1-axboe@kernel.dk>
References: <20241022021159.820925-1-axboe@kernel.dk>
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


