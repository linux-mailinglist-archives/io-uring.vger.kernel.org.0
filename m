Return-Path: <io-uring+bounces-8016-lists+io-uring=lfdr.de@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [147.75.199.223])
	by mail.lfdr.de (Postfix) with ESMTPS id 06931ABA482
	for <lists+io-uring@lfdr.de>; Fri, 16 May 2025 22:10:27 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id 2612A505E77
	for <lists+io-uring@lfdr.de>; Fri, 16 May 2025 20:10:27 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 46BC622C356;
	Fri, 16 May 2025 20:10:23 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel-dk.20230601.gappssmtp.com header.i=@kernel-dk.20230601.gappssmtp.com header.b="ixwsf2gP"
X-Original-To: io-uring@vger.kernel.org
Received: from mail-io1-f46.google.com (mail-io1-f46.google.com [209.85.166.46])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4764C27AC42
	for <io-uring@vger.kernel.org>; Fri, 16 May 2025 20:10:20 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.166.46
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1747426223; cv=none; b=cNUewb1DjY442MRyEzB4z7GnoRIi1bEXSZzPDRAK3Dk8RzlhbeeXcofFUOexml2CNhtdLW/dW2+RaMFAYeL8rDfYZKqWntEYnp2dRHHh9dLQx2IC+6uz7RC7MHPUhCytdf0IG1Ym46w/Xl0a42FzEUb9xHdoMn1Sos1PExaer3g=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1747426223; c=relaxed/simple;
	bh=1ES4DNBFfjGwAZsW+l73DrTiaZol7i4KhRHBFkiURgg=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=fW2SDJxjdYAP8kbiQEWH9dA62Gy456RyCy1jQ1bUQATTb0ZYKuA+lIYRrnsYLVBZDWtRtO9pmL8PHl7/gKtJriGKbnzS0BnNXtXR/VtTapTWqBf8hgQhGjIFUVLBhFMZRGgLu8t5kCjD6zFpTNCrL1HzTNsr6XKO/fVeNogMvBU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=kernel.dk; spf=pass smtp.mailfrom=kernel.dk; dkim=pass (2048-bit key) header.d=kernel-dk.20230601.gappssmtp.com header.i=@kernel-dk.20230601.gappssmtp.com header.b=ixwsf2gP; arc=none smtp.client-ip=209.85.166.46
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=kernel.dk
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=kernel.dk
Received: by mail-io1-f46.google.com with SMTP id ca18e2360f4ac-85e46f5c50fso211596839f.3
        for <io-uring@vger.kernel.org>; Fri, 16 May 2025 13:10:20 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernel-dk.20230601.gappssmtp.com; s=20230601; t=1747426219; x=1748031019; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=R22WHCzjhDcJKwCV+6xueYRSknEc+hiHIaAHNieFMrQ=;
        b=ixwsf2gPeuZIA1JUAOq374EUmuZuBX+oRDjieq/vG6NNeutLnDIL9FVZwp7Zsb5mQb
         KgtUzCjmTpKlHgNP6AMZ9cNBQOgqrYuJh///Z1q0a7yBFdzupQS6geYSiXIp0HIVHyrY
         h9dalixcWXf9sXV8iwS50wISd6RrIJitsArRNaP0HSZ4vRinI5EzkQcNC3PB6BnTr5dO
         MNh1cPdZRmfNK8Nf4Ab0hbpSP2PSDZ0FgXMQB83WLmcUoaS+Gt4VT7OZ0AzoNJC9Vppa
         dqY9ymXr+nFGq+48onGivTT+3gNTad61aypWc2FPcAaS32deOoclvR1d7HveJyCuY3tx
         1lyQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1747426219; x=1748031019;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=R22WHCzjhDcJKwCV+6xueYRSknEc+hiHIaAHNieFMrQ=;
        b=Bs+LOz/O9fPblmRH21ewwr5TiZ+rgGk1+RY68gEHfkQ3Q/XCVtx+ujVFpRudcWX8Za
         BykAiiDP14Uhmsq3J/egQ1zEFHl0eG/mx5wvLgVB08NNDAhqsAa/slAMh5n4hS96LGWf
         griOoW19CFa4vHyTuj1bf5sLr6+nMqiIpib5veo5Q2MS6D0n6e++jEqMRQkZOsEyOiNj
         YqI7OZyCvFb1v9yr8946Mg2gjgC/R1CoEpwYw1IHca66SkX9zq8TPXPHHvptB37R0XEu
         VXuNH7CFFx6xHbhuFp9RK6xOqjtlQrvyhw2SdllSROfCEMhvXXMbKmbXq3kkL0C5IekZ
         8wcQ==
X-Gm-Message-State: AOJu0YzZ5aMwDGNAFZ6+1J81YdEoHO9htwhikgSNPmLOrJZWYooL4t0v
	l10f3tLTzI9oLlCQtt09BJfi4hC+OSNeTxZwvRoiuQSULo9qiigbx/mhpPoweAjSZROZhdyCCxS
	EOecO
X-Gm-Gg: ASbGncstqCJiAX8/bNPbyWkzLk9VQ2QESCRdnT0Qp7eSvSerrF2jyT/itL0nJA3vWXw
	XeV1+eEXAlUGjpKHPMjxG31zYktCUnrh+qCd3FQePCfN8MzEficJV3AQ4fi4Tr6tY558BWaY7rw
	3113TlS+JgQdpgVvLsOCNP8h5Wg+9iubEbr5asIjYnIbvnjZ/ULmp1weIzPuhhaG10PG9uKvKOU
	G6SQ6e29EUisEwSHoWVQ8zSI8Xkb6AjlGUqENFr8V7sNn9moiEIsMdgjT4N3ra4EiRKs+wfnnds
	5YjP7p/G6MEmfixuaLMlmGJIBdo/zEPgknrNx12+fzZzM+XQ2GWqMZEV
X-Google-Smtp-Source: AGHT+IEuQ8K3fXgnQMMX7Qe2nL5IX+BWR3mGwH73k811YJjiPMfZKVNCID4pn0nZ43HkbIXG1gabjA==
X-Received: by 2002:a05:6602:4808:b0:867:6680:8191 with SMTP id ca18e2360f4ac-86a2306ee1cmr808388939f.0.1747426218790;
        Fri, 16 May 2025 13:10:18 -0700 (PDT)
Received: from localhost.localdomain ([198.8.77.157])
        by smtp.gmail.com with ESMTPSA id 8926c6da1cb9f-4fbcc4ea4b5sm541805173.136.2025.05.16.13.10.17
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 16 May 2025 13:10:17 -0700 (PDT)
From: Jens Axboe <axboe@kernel.dk>
To: io-uring@vger.kernel.org
Cc: asml.silence@gmail.com,
	csander@purestorage.com,
	Jens Axboe <axboe@kernel.dk>
Subject: [PATCH 5/5] io_uring: add new helpers for posting overflows
Date: Fri, 16 May 2025 14:05:10 -0600
Message-ID: <20250516201007.482667-6-axboe@kernel.dk>
X-Mailer: git-send-email 2.49.0
In-Reply-To: <20250516201007.482667-1-axboe@kernel.dk>
References: <20250516201007.482667-1-axboe@kernel.dk>
Precedence: bulk
X-Mailing-List: io-uring@vger.kernel.org
List-Id: <io-uring.vger.kernel.org>
List-Subscribe: <mailto:io-uring+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:io-uring+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

Add two helpers, one for posting overflows for lockless_cq rings, and
one for non-lockless_cq rings. The former can allocate sanely with
GFP_KERNEL, but needs to grab the completion lock for posting, while the
latter must do non-sleeping allocs as it already holds the completion
lock.

While at it, mark the overflow handling functions as __cold as well, as
they should not generally be called during normal operations of the
ring.

Signed-off-by: Jens Axboe <axboe@kernel.dk>
---
 io_uring/io_uring.c | 50 ++++++++++++++++++++++++++-------------------
 1 file changed, 29 insertions(+), 21 deletions(-)

diff --git a/io_uring/io_uring.c b/io_uring/io_uring.c
index c66fc4b7356b..52087b079a0c 100644
--- a/io_uring/io_uring.c
+++ b/io_uring/io_uring.c
@@ -697,8 +697,8 @@ static __cold void io_uring_drop_tctx_refs(struct task_struct *task)
 	}
 }
 
-static bool io_cqring_add_overflow(struct io_ring_ctx *ctx,
-				   struct io_overflow_cqe *ocqe)
+static __cold bool io_cqring_add_overflow(struct io_ring_ctx *ctx,
+					  struct io_overflow_cqe *ocqe)
 {
 	lockdep_assert_held(&ctx->completion_lock);
 
@@ -808,6 +808,27 @@ static bool io_fill_cqe_aux(struct io_ring_ctx *ctx, u64 user_data, s32 res,
 	return false;
 }
 
+static __cold void io_cqe_overflow_lockless(struct io_ring_ctx *ctx,
+					    struct io_cqe *cqe,
+					    struct io_big_cqe *big_cqe)
+{
+	struct io_overflow_cqe *ocqe;
+
+	ocqe = io_alloc_ocqe(ctx, cqe, big_cqe, GFP_KERNEL);
+	spin_lock(&ctx->completion_lock);
+	io_cqring_add_overflow(ctx, ocqe);
+	spin_unlock(&ctx->completion_lock);
+}
+
+static __cold bool io_cqe_overflow(struct io_ring_ctx *ctx, struct io_cqe *cqe,
+				   struct io_big_cqe *big_cqe)
+{
+	struct io_overflow_cqe *ocqe;
+
+	ocqe = io_alloc_ocqe(ctx, cqe, big_cqe, GFP_ATOMIC);
+	return io_cqring_add_overflow(ctx, ocqe);
+}
+
 #define io_init_cqe(user_data, res, cflags)	\
 	(struct io_cqe) { .user_data = user_data, .res = res, .flags = cflags }
 
@@ -818,11 +839,9 @@ bool io_post_aux_cqe(struct io_ring_ctx *ctx, u64 user_data, s32 res, u32 cflags
 	io_cq_lock(ctx);
 	filled = io_fill_cqe_aux(ctx, user_data, res, cflags);
 	if (unlikely(!filled)) {
-		struct io_overflow_cqe *ocqe;
 		struct io_cqe cqe = io_init_cqe(user_data, res, cflags);
 
-		ocqe = io_alloc_ocqe(ctx, &cqe, NULL, GFP_ATOMIC);
-		filled = io_cqring_add_overflow(ctx, ocqe);
+		filled = io_cqe_overflow(ctx, &cqe, NULL);
 	}
 	io_cq_unlock_post(ctx);
 	return filled;
@@ -838,13 +857,9 @@ void io_add_aux_cqe(struct io_ring_ctx *ctx, u64 user_data, s32 res, u32 cflags)
 	lockdep_assert(ctx->lockless_cq);
 
 	if (!io_fill_cqe_aux(ctx, user_data, res, cflags)) {
-		struct io_overflow_cqe *ocqe;
 		struct io_cqe cqe = io_init_cqe(user_data, res, cflags);
 
-		ocqe = io_alloc_ocqe(ctx, &cqe, NULL, GFP_KERNEL);
-		spin_lock(&ctx->completion_lock);
-		io_cqring_add_overflow(ctx, ocqe);
-		spin_unlock(&ctx->completion_lock);
+		io_cqe_overflow_lockless(ctx, &cqe, NULL);
 	}
 	ctx->submit_state.cq_flush = true;
 }
@@ -1448,17 +1463,10 @@ void __io_submit_flush_completions(struct io_ring_ctx *ctx)
 		 */
 		if (!(req->flags & (REQ_F_CQE_SKIP | REQ_F_REISSUE)) &&
 		    unlikely(!io_fill_cqe_req(ctx, req))) {
-			gfp_t gfp = ctx->lockless_cq ? GFP_KERNEL : GFP_ATOMIC;
-			struct io_overflow_cqe *ocqe;
-
-			ocqe = io_alloc_ocqe(ctx, &req->cqe, &req->big_cqe, gfp);
-			if (ctx->lockless_cq) {
-				spin_lock(&ctx->completion_lock);
-				io_cqring_add_overflow(ctx, ocqe);
-				spin_unlock(&ctx->completion_lock);
-			} else {
-				io_cqring_add_overflow(ctx, ocqe);
-			}
+			if (ctx->lockless_cq)
+				io_cqe_overflow_lockless(ctx, &req->cqe, &req->big_cqe);
+			else
+				io_cqe_overflow(ctx, &req->cqe, &req->big_cqe);
 		}
 	}
 	__io_cq_unlock_post(ctx);
-- 
2.49.0


