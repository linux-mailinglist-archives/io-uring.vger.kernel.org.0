Return-Path: <io-uring+bounces-9991-lists+io-uring=lfdr.de@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [147.75.80.249])
	by mail.lfdr.de (Postfix) with ESMTPS id 64F95BD8D62
	for <lists+io-uring@lfdr.de>; Tue, 14 Oct 2025 12:57:11 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id A4F3E188A0A6
	for <lists+io-uring@lfdr.de>; Tue, 14 Oct 2025 10:57:34 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 28F863BB40;
	Tue, 14 Oct 2025 10:57:06 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="JTvMyAE0"
X-Original-To: io-uring@vger.kernel.org
Received: from mail-wm1-f49.google.com (mail-wm1-f49.google.com [209.85.128.49])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E9BE02FC02E
	for <io-uring@vger.kernel.org>; Tue, 14 Oct 2025 10:57:03 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.128.49
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1760439425; cv=none; b=jX9bZkxYW0oe8l5HYeY8cfp+nDXubXpAZW8ylHA+KsI6kYZZFIKzuBJ5N1Z0P/4s4qmLIHjhyhX0dJjnV00BuVeFmsMSYzkX9391Jj2d0Nis+Y7LyADjA8eXshR4hrfryPAI9EK9I/E9IsA/LGsnv1d5GB/yun87FRGb0F99xR8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1760439425; c=relaxed/simple;
	bh=ksuFeBoP8a+tbzMB+yoXvyzK0UHb9PeD4xdjXE5PTRo=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=MgVPpxE3BOdeDAnnDH2pYB90NCJdzIixD2N03R5HwaEVOyDsHhtgpeWHJjxsIOgNhkkz3taVMErWmwJxj98KundaCZMMfZKiQsmbdLaZVZ0RWDfgZv+Rfjifj60caPhH6QtHTHigOhWRwZdnhcgb4FC0lXSZwkrLauGFfrvftFc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=JTvMyAE0; arc=none smtp.client-ip=209.85.128.49
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Received: by mail-wm1-f49.google.com with SMTP id 5b1f17b1804b1-46e3af7889fso28252885e9.2
        for <io-uring@vger.kernel.org>; Tue, 14 Oct 2025 03:57:03 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1760439422; x=1761044222; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=hjgDXicB8S9JUms+F4Ot9xVd1QiQ0K4XC5uKmcY58GI=;
        b=JTvMyAE04dqALahfKMySShAV3vPQesuqiBJ/vaSY1ZvjIHXj7nku/ds0sRfIni1bC3
         lJb/7edRM+9It3vNBdEbVQrf/fMJA8YqfFb1I3aMG0660TzKUqlSDvCxo2gTcFgLnKaa
         bN96s/rHsrOewyDLCaIYEmYwqkZYLPCqMgbtOVtkl4P7HvP5OQ9tveBcCGG6lt+hr/W8
         KCZVBzcfjsgQe+hlivwTjgkiIs7qoO95wH8R7egAhx2FsVawI6/jdJXZ2CEeNRWP6pKs
         md1ncTMYK2rl+yVskgifRiC+46S7565Bhe+Z0/lGHL42LfwG7/CyAqHlubTMA+3Ai9bI
         42EA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1760439422; x=1761044222;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=hjgDXicB8S9JUms+F4Ot9xVd1QiQ0K4XC5uKmcY58GI=;
        b=Y9Gvd1JnU3O0kZE4xhPKEXBbM0o0Y+im9nxYRQq12Ez5rGdPKAiRXGr3pvGGfLkoQj
         SCdU0Y8cbEi9EAS3hj87wHjEVrv+3aEE9vDieRBb2yuPc2k1iIr+lw1OgjIjylKdKi0b
         72bY1sm9v3yRurtV9AWeylweHpL71nki+IpW8EBUbFgWGOC9PCj29zJE4+It0OmjiijV
         y1K4oza25FEPKeRWSnNcxh5ll1nYgnQB5/l8BgomsL/IbULWdJbQy1Vytt9ghrWmuMK3
         /QGj5kCRABZet/+LO/AP+5s9c3l/EOFC46rT7cP+ElbQQAJi0YYfUBEC75GbdyO0VsZT
         gQ2A==
X-Gm-Message-State: AOJu0Yx8UyKssBqadXb02c82qIJHX1QwxNWyX37bOX/UmOIvmZg5ahjm
	9Q6UnfOw0/0voAZjrJno2KpJC8/kLmHu/D+2KICwPofRjRgCTTJ9d5BrZlFT4Q==
X-Gm-Gg: ASbGncsRNUncf9ulyAfn6aZMLLdlWugS/zhgZ4lhydB9Rh9N4B1TRSai3KQJ0rZTs1m
	K2jqABCZWDMo4INfrqaKDfrzwmXB03BKiUcPTfmV3cv+ZWvhRRKwokn66o74aCEVyTqPFiWJ/89
	9oFAObh0bUTiVi9ZQKbsr7EpnQ4oaOKhfGIzT7JP/BLfVmEQIj/kvdSHcW0rOsIix27IT4xUaHQ
	CA+LpGFM7gcLZNf3ynt2es1PrZCJ5BE5GOIONdz647PngGmFOTYUjGXR0g6TaH8yximKbygnthQ
	GDSqjjU3hu5+eSFP4o83mKR2TEKefFIJkAHKZxvoGTlODAFzdSyIb7mjiy4o+B0mo1qA7+ITz3V
	oZy334UotKyc7MTh4Za31JtF0
X-Google-Smtp-Source: AGHT+IG9o3zVjPkanAUlEdv8YtjdTFFiQiQs91zJq3WKlmRVlAwHpvYxDSn12vDkD5qkhmnEhEF7wg==
X-Received: by 2002:a05:600c:529a:b0:46e:4912:d02a with SMTP id 5b1f17b1804b1-46fa9aef4cbmr152317685e9.23.1760439421651;
        Tue, 14 Oct 2025 03:57:01 -0700 (PDT)
Received: from 127.com ([2620:10d:c092:600::1:7ec0])
        by smtp.gmail.com with ESMTPSA id 5b1f17b1804b1-46fb497b8fcsm235694115e9.2.2025.10.14.03.57.00
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 14 Oct 2025 03:57:01 -0700 (PDT)
From: Pavel Begunkov <asml.silence@gmail.com>
To: io-uring@vger.kernel.org
Cc: asml.silence@gmail.com
Subject: [PATCH 2/2] io_uring: introduce non-circular SQ
Date: Tue, 14 Oct 2025 11:58:10 +0100
Message-ID: <d2cb4a123518196c2f33b9adfad8a8828969808c.1760438982.git.asml.silence@gmail.com>
X-Mailer: git-send-email 2.49.0
In-Reply-To: <cover.1760438982.git.asml.silence@gmail.com>
References: <cover.1760438982.git.asml.silence@gmail.com>
Precedence: bulk
X-Mailing-List: io-uring@vger.kernel.org
List-Id: <io-uring.vger.kernel.org>
List-Subscribe: <mailto:io-uring+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:io-uring+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

Outside of SQPOLL, normally SQ entries are consumed by the time the
submission syscall returns. For those cases we don't need a circular
buffer and the head/tail tracking, instead the kernel can assume that
entries always start from the beginning of the SQ at index 0. This patch
introduces a setup flag doing exactly that.

This method is simpler in general, needs fewer operations, doesn't
require looking up heads and tails, however, the main goal here is to
keep caches hot. The userspace might overprovision SQ, and in the normal
way we'd be touching all the cache lines, but with this feature it
reuses first entries and keeps them hot. This simplicity will also be
quite handy for bpf-io_uring.

To use the feature the user should set the IORING_SETUP_SQ_REWIND flag,
and have a compatible liburing/userspace. The flag is restricted to
IORING_SETUP_NO_SQARRAY rings and is not compatible with
IORING_SETUP_SQPOLL.

Note, it uses relaxed ring synchronisation as the userspace doing the
syscall is naturally in sync, and setups that share a SQ should be
rolling their own intra process/thread synchronisation.

Signed-off-by: Pavel Begunkov <asml.silence@gmail.com>
---
 include/uapi/linux/io_uring.h |  6 ++++++
 io_uring/io_uring.c           | 29 ++++++++++++++++++++++-------
 io_uring/io_uring.h           |  3 ++-
 3 files changed, 30 insertions(+), 8 deletions(-)

diff --git a/include/uapi/linux/io_uring.h b/include/uapi/linux/io_uring.h
index a0cc1cc0dd01..d1c654a7fa9a 100644
--- a/include/uapi/linux/io_uring.h
+++ b/include/uapi/linux/io_uring.h
@@ -231,6 +231,12 @@ enum io_uring_sqe_flags_bit {
  */
 #define IORING_SETUP_CQE_MIXED		(1U << 18)
 
+/*
+ * SQEs always start at index 0 in the submission ring instead of using a
+ * wrap around indexing.
+ */
+#define IORING_SETUP_SQ_REWIND		(1U << 19)
+
 enum io_uring_op {
 	IORING_OP_NOP,
 	IORING_OP_READV,
diff --git a/io_uring/io_uring.c b/io_uring/io_uring.c
index ee04ab9bf968..e8af963d3233 100644
--- a/io_uring/io_uring.c
+++ b/io_uring/io_uring.c
@@ -2367,12 +2367,16 @@ static void io_commit_sqring(struct io_ring_ctx *ctx)
 {
 	struct io_rings *rings = ctx->rings;
 
-	/*
-	 * Ensure any loads from the SQEs are done at this point,
-	 * since once we write the new head, the application could
-	 * write new data to them.
-	 */
-	smp_store_release(&rings->sq.head, ctx->cached_sq_head);
+	if (ctx->flags & IORING_SETUP_SQ_REWIND) {
+		ctx->cached_sq_head = 0;
+	} else {
+		/*
+		 * Ensure any loads from the SQEs are done at this point,
+		 * since once we write the new head, the application could
+		 * write new data to them.
+		 */
+		smp_store_release(&rings->sq.head, ctx->cached_sq_head);
+	}
 }
 
 /*
@@ -2418,10 +2422,15 @@ static bool io_get_sqe(struct io_ring_ctx *ctx, const struct io_uring_sqe **sqe)
 int io_submit_sqes(struct io_ring_ctx *ctx, unsigned int nr)
 	__must_hold(&ctx->uring_lock)
 {
-	unsigned int entries = io_sqring_entries(ctx);
+	unsigned int entries;
 	unsigned int left;
 	int ret;
 
+	if (ctx->flags & IORING_SETUP_SQ_REWIND)
+		entries = ctx->sq_entries;
+	else
+		entries = io_sqring_entries(ctx);
+
 	entries = min(nr, entries);
 	if (unlikely(!entries))
 		return 0;
@@ -3678,6 +3687,12 @@ static int io_uring_sanitise_params(struct io_uring_params *p)
 {
 	unsigned flags = p->flags;
 
+	if (flags & IORING_SETUP_SQ_REWIND) {
+		if ((flags & IORING_SETUP_SQPOLL) ||
+		    !(flags & IORING_SETUP_NO_SQARRAY))
+		return -EINVAL;
+	}
+
 	/* There is no way to mmap rings without a real fd */
 	if ((flags & IORING_SETUP_REGISTERED_FD_ONLY) &&
 	    !(flags & IORING_SETUP_NO_MMAP))
diff --git a/io_uring/io_uring.h b/io_uring/io_uring.h
index 46d9141d772a..b998ed57dd93 100644
--- a/io_uring/io_uring.h
+++ b/io_uring/io_uring.h
@@ -54,7 +54,8 @@
 			IORING_SETUP_REGISTERED_FD_ONLY |\
 			IORING_SETUP_NO_SQARRAY |\
 			IORING_SETUP_HYBRID_IOPOLL |\
-			IORING_SETUP_CQE_MIXED)
+			IORING_SETUP_CQE_MIXED |\
+			IORING_SETUP_SQ_REWIND)
 
 #define IORING_ENTER_FLAGS (IORING_ENTER_GETEVENTS |\
 			IORING_ENTER_SQ_WAKEUP |\
-- 
2.49.0


