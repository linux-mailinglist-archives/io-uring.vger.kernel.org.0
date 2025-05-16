Return-Path: <io-uring+bounces-7990-lists+io-uring=lfdr.de@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [IPv6:2604:1380:45d1:ec00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 58B83ABA0AD
	for <lists+io-uring@lfdr.de>; Fri, 16 May 2025 18:15:04 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id 32D3D504D43
	for <lists+io-uring@lfdr.de>; Fri, 16 May 2025 16:15:04 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 3090C1C5D46;
	Fri, 16 May 2025 16:15:02 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel-dk.20230601.gappssmtp.com header.i=@kernel-dk.20230601.gappssmtp.com header.b="H4V6MO26"
X-Original-To: io-uring@vger.kernel.org
Received: from mail-il1-f173.google.com (mail-il1-f173.google.com [209.85.166.173])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7924E1B4F0F
	for <io-uring@vger.kernel.org>; Fri, 16 May 2025 16:14:59 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.166.173
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1747412102; cv=none; b=cKjd/sD3Az32443Q+3F8N93ZZXm4+e/+ytafQb6GGqsa/Z7eTpnDNKzUuIvCQwluJNg2VnbRTCPDLeYcXDZypkZD0rFXnyD5vJ21nhOoOxUEs1Nm9hHaFiPiXm7GqxaB64yy9wIZq5IlRc+1ouL48/Hnhdw5rRjLsGE+ZOOhztU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1747412102; c=relaxed/simple;
	bh=QA2f9fFgiHmyRRwz1R71+u/hV+HRh1rohgEbSnWyjXY=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=mxR+b+bsXW+bjQJna7taGFTqDLI7DQMwcU6A7wkrA5Bg27zKJWVgQXAM6QQDS4wOVlJEbNNqgoqA+Ij5kw82IjHOZsE5FPcI6AEfQcZreW0lO0pDm4hVy+yGKRewW2CI9UbitGA0WKReeKBj/EyjW3oFSP/w9IOKcOd3QUg/b1A=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=kernel.dk; spf=pass smtp.mailfrom=kernel.dk; dkim=pass (2048-bit key) header.d=kernel-dk.20230601.gappssmtp.com header.i=@kernel-dk.20230601.gappssmtp.com header.b=H4V6MO26; arc=none smtp.client-ip=209.85.166.173
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=kernel.dk
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=kernel.dk
Received: by mail-il1-f173.google.com with SMTP id e9e14a558f8ab-3d8020ba858so21768195ab.0
        for <io-uring@vger.kernel.org>; Fri, 16 May 2025 09:14:59 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernel-dk.20230601.gappssmtp.com; s=20230601; t=1747412097; x=1748016897; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=fdOGanNe0d+pUbTu19b5nHiwa1m7JkBbEGvi/kZja90=;
        b=H4V6MO26TSElWU2Tt/4AvMEaTIJso+ZpAccwxzaoUVxiFBEzC0kf4jNzKm9cecditJ
         DwMEEH8HJzRrAYlwwcXkVf1avXk/wgQAC1tMTrLxKkCx14dUI4OsiIiFwccjFgN0uehI
         1a5hKLVGOaRxKgExM3SYUdK7p3TW9QaQtpcyPX8yh1ShWj3jcW1GDQAKfweL8x1bmDFF
         kS6fhDhi419zZpPBJOHmIscKgw40fFuo4p93NzxEeVVUHrTQWA/0Q8nWA3duSeY3kcLb
         Tk189N8BgL7uibzQ0oeiBWC7AGTz/XinS7Z9j4eLdf6NqREwX4z87PmcUe78JnSzVhuM
         ZP0w==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1747412097; x=1748016897;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=fdOGanNe0d+pUbTu19b5nHiwa1m7JkBbEGvi/kZja90=;
        b=qHC/T4/xje9EYbVqEGD1FUkTEca9WiTVipFCQU+9OHzHIREvES5+mmB2/54lHIKOzT
         dEsbFr3dctl3ag3hDLU/7J730wKM2A4U22nAC3UV8xbVPfGeZtKZ1SEEE3DtfIBRjLTs
         JyGDul9CbjNtH8eBLKYd/7O1hFziTnGG59vgjaiUB2gps/QeS+ry6Vx0Ag+k/J0/9qF9
         qTu+YcnUzbHWVa7uhFVbuxKzamDciq2RG3Rz2W7WWCoDD84JDcTSwuIAccHdiq1Wl6KM
         Tp+iGah8zGdTJQWlxO5OpK1DD8UOAfKkAsnuBJriQCjKcf0tfrIdcItqOWwDGyLHjq9X
         c1wg==
X-Gm-Message-State: AOJu0Yzu6bVPtyazLDaNJbDwOaYmVeXZvmujQKraDpZOkdNlnoT1HLKa
	tukw7whPWZrojR6uRJmJ4ctlcdMXW8Tjxr8MXw0IroqMdJ+GpumLBGt4CwCjbCOyxSglh1DTRxq
	7NsDa
X-Gm-Gg: ASbGncs48CirSFHVOUm4FMrl7UKQmybcupskKZUAHNH/O+GB+hPDZyBjH4KLUlUxzVm
	NGyxBx/dyuwM795ki7mMrGZoweAJWs4PuF2EReMfGLolZHhuYfb6xsIk+qb0YmJwVoGoaUS5EHG
	T1rYXToDj8hDVsPMou0emP4eEnNJX02VcIiZEl89e+B5oNp9dHA0r+wwg3XhnZoejBek2fhDi6B
	ErZwqMKFhSHoaDnsS7a9Otf0vn+SRrW7Ct7Cp79nllRgHJZDuLK4yz4tO00mRrdzdgJo1cDRH1n
	rmlJKU3MCE13BUDfUvmTzpaZb7NkNy0rIcMJSgkAjYU2YzbciUqa6WA=
X-Google-Smtp-Source: AGHT+IHwbYRPD/epWmcZD9VRCNlEvMsUcxwUzwOD3rOiaoD/uGFLh+6nntczdST1lyiISgtQ2wwPqw==
X-Received: by 2002:a05:6e02:16ca:b0:3d0:10a6:99aa with SMTP id e9e14a558f8ab-3db8427f511mr51019075ab.4.1747412097438;
        Fri, 16 May 2025 09:14:57 -0700 (PDT)
Received: from localhost.localdomain ([96.43.243.2])
        by smtp.gmail.com with ESMTPSA id 8926c6da1cb9f-4fbcc48c5cdsm467439173.84.2025.05.16.09.14.55
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 16 May 2025 09:14:56 -0700 (PDT)
From: Jens Axboe <axboe@kernel.dk>
To: io-uring@vger.kernel.org
Cc: asml.silence@gmail.com,
	Jens Axboe <axboe@kernel.dk>
Subject: [PATCH 1/2] io_uring: split alloc and add of overflow
Date: Fri, 16 May 2025 10:08:56 -0600
Message-ID: <20250516161452.395927-2-axboe@kernel.dk>
X-Mailer: git-send-email 2.49.0
In-Reply-To: <20250516161452.395927-1-axboe@kernel.dk>
References: <20250516161452.395927-1-axboe@kernel.dk>
Precedence: bulk
X-Mailing-List: io-uring@vger.kernel.org
List-Id: <io-uring.vger.kernel.org>
List-Subscribe: <mailto:io-uring+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:io-uring+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

Add a new helper, io_alloc_ocqe(), that simply allocates and fills an
overflow entry. Then it can get done outside of the locking section,
and hence use more appropriate gfp_t allocation flags rather than always
default to GFP_ATOMIC.

Suggested-by: Pavel Begunkov <asml.silence@gmail.com>
Signed-off-by: Jens Axboe <axboe@kernel.dk>
---
 io_uring/io_uring.c | 75 +++++++++++++++++++++++++++++----------------
 1 file changed, 48 insertions(+), 27 deletions(-)

diff --git a/io_uring/io_uring.c b/io_uring/io_uring.c
index 9a9b8d35349b..2519fab303c4 100644
--- a/io_uring/io_uring.c
+++ b/io_uring/io_uring.c
@@ -718,20 +718,11 @@ static __cold void io_uring_drop_tctx_refs(struct task_struct *task)
 	}
 }
 
-static bool io_cqring_event_overflow(struct io_ring_ctx *ctx, u64 user_data,
-				     s32 res, u32 cflags, u64 extra1, u64 extra2)
+static bool io_cqring_add_overflow(struct io_ring_ctx *ctx,
+				   struct io_overflow_cqe *ocqe)
 {
-	struct io_overflow_cqe *ocqe;
-	size_t ocq_size = sizeof(struct io_overflow_cqe);
-	bool is_cqe32 = (ctx->flags & IORING_SETUP_CQE32);
-
 	lockdep_assert_held(&ctx->completion_lock);
 
-	if (is_cqe32)
-		ocq_size += sizeof(struct io_uring_cqe);
-
-	ocqe = kmalloc(ocq_size, GFP_ATOMIC | __GFP_ACCOUNT);
-	trace_io_uring_cqe_overflow(ctx, user_data, res, cflags, ocqe);
 	if (!ocqe) {
 		struct io_rings *r = ctx->rings;
 
@@ -749,22 +740,44 @@ static bool io_cqring_event_overflow(struct io_ring_ctx *ctx, u64 user_data,
 		atomic_or(IORING_SQ_CQ_OVERFLOW, &ctx->rings->sq_flags);
 
 	}
-	ocqe->cqe.user_data = user_data;
-	ocqe->cqe.res = res;
-	ocqe->cqe.flags = cflags;
-	if (is_cqe32) {
-		ocqe->cqe.big_cqe[0] = extra1;
-		ocqe->cqe.big_cqe[1] = extra2;
-	}
 	list_add_tail(&ocqe->list, &ctx->cq_overflow_list);
 	return true;
 }
 
-static void io_req_cqe_overflow(struct io_kiocb *req)
+static struct io_overflow_cqe *io_alloc_ocqe(struct io_ring_ctx *ctx,
+					     u64 user_data, s32 res, u32 cflags,
+					     u64 extra1, u64 extra2, gfp_t gfp)
+{
+	struct io_overflow_cqe *ocqe;
+	size_t ocq_size = sizeof(struct io_overflow_cqe);
+	bool is_cqe32 = (ctx->flags & IORING_SETUP_CQE32);
+
+	if (is_cqe32)
+		ocq_size += sizeof(struct io_uring_cqe);
+
+	ocqe = kmalloc(ocq_size, gfp | __GFP_ACCOUNT);
+	trace_io_uring_cqe_overflow(ctx, user_data, res, cflags, ocqe);
+	if (ocqe) {
+		ocqe->cqe.user_data = user_data;
+		ocqe->cqe.res = res;
+		ocqe->cqe.flags = cflags;
+		if (is_cqe32) {
+			ocqe->cqe.big_cqe[0] = extra1;
+			ocqe->cqe.big_cqe[1] = extra2;
+		}
+	}
+	return ocqe;
+}
+
+static void io_req_cqe_overflow(struct io_kiocb *req, gfp_t gfp)
 {
-	io_cqring_event_overflow(req->ctx, req->cqe.user_data,
-				req->cqe.res, req->cqe.flags,
-				req->big_cqe.extra1, req->big_cqe.extra2);
+	struct io_ring_ctx *ctx = req->ctx;
+	struct io_overflow_cqe *ocqe;
+
+	ocqe = io_alloc_ocqe(ctx, req->cqe.user_data, req->cqe.res,
+			     req->cqe.flags, req->big_cqe.extra1,
+			     req->big_cqe.extra2, gfp);
+	io_cqring_add_overflow(ctx, ocqe);
 	memset(&req->big_cqe, 0, sizeof(req->big_cqe));
 }
 
@@ -832,8 +845,12 @@ bool io_post_aux_cqe(struct io_ring_ctx *ctx, u64 user_data, s32 res, u32 cflags
 
 	io_cq_lock(ctx);
 	filled = io_fill_cqe_aux(ctx, user_data, res, cflags);
-	if (!filled)
-		filled = io_cqring_event_overflow(ctx, user_data, res, cflags, 0, 0);
+	if (unlikely(!filled)) {
+		struct io_overflow_cqe *ocqe;
+
+		ocqe = io_alloc_ocqe(ctx, user_data, res, cflags, 0, 0, GFP_ATOMIC);
+		filled = io_cqring_add_overflow(ctx, ocqe);
+	}
 	io_cq_unlock_post(ctx);
 	return filled;
 }
@@ -848,8 +865,11 @@ void io_add_aux_cqe(struct io_ring_ctx *ctx, u64 user_data, s32 res, u32 cflags)
 	lockdep_assert(ctx->lockless_cq);
 
 	if (!io_fill_cqe_aux(ctx, user_data, res, cflags)) {
+		struct io_overflow_cqe *ocqe;
+
+		ocqe = io_alloc_ocqe(ctx, user_data, res, cflags, 0, 0, GFP_KERNEL);
 		spin_lock(&ctx->completion_lock);
-		io_cqring_event_overflow(ctx, user_data, res, cflags, 0, 0);
+		io_cqring_add_overflow(ctx, ocqe);
 		spin_unlock(&ctx->completion_lock);
 	}
 	ctx->submit_state.cq_flush = true;
@@ -1442,10 +1462,11 @@ void __io_submit_flush_completions(struct io_ring_ctx *ctx)
 		    unlikely(!io_fill_cqe_req(ctx, req))) {
 			if (ctx->lockless_cq) {
 				spin_lock(&ctx->completion_lock);
-				io_req_cqe_overflow(req);
+				io_req_cqe_overflow(req, GFP_ATOMIC);
 				spin_unlock(&ctx->completion_lock);
 			} else {
-				io_req_cqe_overflow(req);
+				gfp_t gfp = ctx->lockless_cq ? GFP_KERNEL : GFP_ATOMIC;
+				io_req_cqe_overflow(req, gfp);
 			}
 		}
 	}
-- 
2.49.0


