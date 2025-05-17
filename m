Return-Path: <io-uring+bounces-8029-lists+io-uring=lfdr.de@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [IPv6:2604:1380:45e3:2400::1])
	by mail.lfdr.de (Postfix) with ESMTPS id A0420ABA9E7
	for <lists+io-uring@lfdr.de>; Sat, 17 May 2025 13:49:59 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id A39E99E23AD
	for <lists+io-uring@lfdr.de>; Sat, 17 May 2025 11:49:37 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id EF2301F4C9F;
	Sat, 17 May 2025 11:49:52 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel-dk.20230601.gappssmtp.com header.i=@kernel-dk.20230601.gappssmtp.com header.b="d53wucTy"
X-Original-To: io-uring@vger.kernel.org
Received: from mail-il1-f170.google.com (mail-il1-f170.google.com [209.85.166.170])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 06BDD1F5425
	for <io-uring@vger.kernel.org>; Sat, 17 May 2025 11:49:50 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.166.170
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1747482592; cv=none; b=nRZMFrppZy+zmarPkm5+6uZBSOuLyIuSMmNSYhDAWs/OLUvr1lCdRgOLeeTlQt6B4BG19OIFbvGDeSKSjAXKvwRCbeDHyw+E53p/mb3GFB+Ml2FFV9fC0GURz/jwdDv+iQg9Y7+Mt4yDFp0GZTAeFRbUZt4sL5zVH1RWhzZbsU4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1747482592; c=relaxed/simple;
	bh=LJE9R47X4Aq5cfC4sSmQVP/3gfoCRVdrXOSvm48axLI=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=GroI27HDDNkPMA1ksLK+M1//Iore2th2NRq05ttIHh2wVCNc7Qozk3mf9Hjx0OY9C+y+ZEE8Uw+IHsHOZ4IOErZqK34KRFRdTVVCkiHL7pVg5xsW4Wb3570IQ7grV4BrzaQa5ww0U9Qu4Uqot7APaQey9IBNY+Pct3ypW2hOpKM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=kernel.dk; spf=pass smtp.mailfrom=kernel.dk; dkim=pass (2048-bit key) header.d=kernel-dk.20230601.gappssmtp.com header.i=@kernel-dk.20230601.gappssmtp.com header.b=d53wucTy; arc=none smtp.client-ip=209.85.166.170
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=kernel.dk
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=kernel.dk
Received: by mail-il1-f170.google.com with SMTP id e9e14a558f8ab-3dc636c80d1so543275ab.1
        for <io-uring@vger.kernel.org>; Sat, 17 May 2025 04:49:50 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernel-dk.20230601.gappssmtp.com; s=20230601; t=1747482589; x=1748087389; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=GFS9mzuh1BPwBjO1OFeSgl547C44qXbEsPHn6qeYufI=;
        b=d53wucTy2exPv3rWcNyxjM7ut50G4W02/VYV1NjzCZEYKseKWLFDPIod0utFOHiB9b
         t8L2ybLKxHprCfXVAojJZb4SjtgDjM2vJ7oYWzfluD2erFmCPgmFA8Ditmi2rK4gC3L8
         L75C4QlSHskZazVyVVGbwRTnD1uT0tIT3g3mEqPWdLExO35HVPhMhMi8BTJa+fLHk+mF
         Myuz903csHR686uB8Q+5xDlmNQJ/Rl5Ze2XryMTa8rEW5OE4bqc2v73SIBZ0YFKpdR7v
         NRrxM2fh4YyrepOOvAwqqeX+4f4+RdMoBDzP+zig/5UseSq09G72IIhupRYyn/9hy2TS
         R+rA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1747482589; x=1748087389;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=GFS9mzuh1BPwBjO1OFeSgl547C44qXbEsPHn6qeYufI=;
        b=vJGzD+XfPxs3v3l1T9OQ7JKgycRtqAqS0ndUBT9ZHb1A/0JXio+xCNOLsBRuKt+CVy
         TkZ0QD+kPbmJT4Jn1tyK9TnZrrfDlDHRCPapXO3KRjagonQ1MzU3bI44K+bbbAVnXAjw
         7PfPFnpLY4TxIGM2jcleEEUtokuGoovd3K8mwbnsiY+0CGuhxCRW+6SrpPWhZURFAW+u
         69G9nDWkInYLyNbkq8lwnMC+ySmmhFQpHuoGdehy+eQqALk1D5Mg8cbP3fxUgTWaN4rS
         0M3ei4CU33bi7IerODRRewScZWRty3lLQhyWVwiOrQ1CEjcLMj3Z+gHmFPNU0DJGLvL+
         CjLw==
X-Gm-Message-State: AOJu0YylsTb6zFruJKmUKJqA7I0IooYwqFzFMELA6rNZeTJXIIwNqzen
	ieEvBXupsoLxDa789/fSzXr4W9eJqIq2HE1o8K7io/fv7Fen3w3qgH6zKfu3yjlLGoebkpGhxt5
	JpxEf
X-Gm-Gg: ASbGnctsGbQ/Lkg1d4yYzP5odOSxJTtIIph69718V5rxTvwJ40aSfeyPWkHZkRU/PGw
	jWOnxvCsOYK60agV4B2iqmpzaTSavoAsDEwDUkP4PUYUfu4flZr84odtFgK0/oP2QDl6VZGIs7H
	rVOUlmg/qoDT/pe9kcH5Ug6Ux+eeQYJsoFkanlGJ7bIncEO9JiC0S6scqUV8rQwIGv/R44Xt4ZZ
	aYaS+iuwG5+udWue9NKEh/j0KiJRox/gFdrKrpiZFQBAI5TVJm0wN88sS0k8GDBbBdx/X7vnSp9
	YG1IVlz3wG1lZwLsbFqUjjInDUe+VuwCxHpDj+SxsTwh+djPeB5ggi1X
X-Google-Smtp-Source: AGHT+IEnK6ovOT39P04kv4OQEhSiOHR5tCZ3/QXvYIgqKwU6QOAra/EFwa/OyACaugrFwcGUrF/glg==
X-Received: by 2002:a05:6e02:2407:b0:3d6:cd54:ba53 with SMTP id e9e14a558f8ab-3db857c0338mr51384685ab.22.1747482589446;
        Sat, 17 May 2025 04:49:49 -0700 (PDT)
Received: from localhost.localdomain ([198.8.77.157])
        by smtp.gmail.com with ESMTPSA id 8926c6da1cb9f-4fbcc3b1a8bsm874354173.47.2025.05.17.04.49.48
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sat, 17 May 2025 04:49:48 -0700 (PDT)
From: Jens Axboe <axboe@kernel.dk>
To: io-uring@vger.kernel.org
Cc: asml.silence@gmail.com,
	csander@purestorage.com,
	Jens Axboe <axboe@kernel.dk>
Subject: [PATCH 5/5] io_uring: add new helpers for posting overflows
Date: Sat, 17 May 2025 05:42:15 -0600
Message-ID: <20250517114938.533378-6-axboe@kernel.dk>
X-Mailer: git-send-email 2.49.0
In-Reply-To: <20250517114938.533378-1-axboe@kernel.dk>
References: <20250517114938.533378-1-axboe@kernel.dk>
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

Reviewed-by: Caleb Sander Mateos <csander@purestorage.com>
Signed-off-by: Jens Axboe <axboe@kernel.dk>
---
 io_uring/io_uring.c | 50 ++++++++++++++++++++++++++-------------------
 1 file changed, 29 insertions(+), 21 deletions(-)

diff --git a/io_uring/io_uring.c b/io_uring/io_uring.c
index 4081ffd890af..3c4a9561941f 100644
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
 
@@ -813,6 +813,27 @@ static inline struct io_cqe io_init_cqe(u64 user_data, s32 res, u32 cflags)
 	return (struct io_cqe) { .user_data = user_data, .res = res, .flags = cflags };
 }
 
+static __cold void io_cqe_overflow(struct io_ring_ctx *ctx, struct io_cqe *cqe,
+			           struct io_big_cqe *big_cqe)
+{
+	struct io_overflow_cqe *ocqe;
+
+	ocqe = io_alloc_ocqe(ctx, cqe, big_cqe, GFP_KERNEL);
+	spin_lock(&ctx->completion_lock);
+	io_cqring_add_overflow(ctx, ocqe);
+	spin_unlock(&ctx->completion_lock);
+}
+
+static __cold bool io_cqe_overflow_locked(struct io_ring_ctx *ctx,
+					  struct io_cqe *cqe,
+					  struct io_big_cqe *big_cqe)
+{
+	struct io_overflow_cqe *ocqe;
+
+	ocqe = io_alloc_ocqe(ctx, cqe, big_cqe, GFP_ATOMIC);
+	return io_cqring_add_overflow(ctx, ocqe);
+}
+
 bool io_post_aux_cqe(struct io_ring_ctx *ctx, u64 user_data, s32 res, u32 cflags)
 {
 	bool filled;
@@ -820,11 +841,9 @@ bool io_post_aux_cqe(struct io_ring_ctx *ctx, u64 user_data, s32 res, u32 cflags
 	io_cq_lock(ctx);
 	filled = io_fill_cqe_aux(ctx, user_data, res, cflags);
 	if (unlikely(!filled)) {
-		struct io_overflow_cqe *ocqe;
 		struct io_cqe cqe = io_init_cqe(user_data, res, cflags);
 
-		ocqe = io_alloc_ocqe(ctx, &cqe, NULL, GFP_ATOMIC);
-		filled = io_cqring_add_overflow(ctx, ocqe);
+		filled = io_cqe_overflow_locked(ctx, &cqe, NULL);
 	}
 	io_cq_unlock_post(ctx);
 	return filled;
@@ -840,13 +859,9 @@ void io_add_aux_cqe(struct io_ring_ctx *ctx, u64 user_data, s32 res, u32 cflags)
 	lockdep_assert(ctx->lockless_cq);
 
 	if (!io_fill_cqe_aux(ctx, user_data, res, cflags)) {
-		struct io_overflow_cqe *ocqe;
 		struct io_cqe cqe = io_init_cqe(user_data, res, cflags);
 
-		ocqe = io_alloc_ocqe(ctx, &cqe, NULL, GFP_KERNEL);
-		spin_lock(&ctx->completion_lock);
-		io_cqring_add_overflow(ctx, ocqe);
-		spin_unlock(&ctx->completion_lock);
+		io_cqe_overflow(ctx, &cqe, NULL);
 	}
 	ctx->submit_state.cq_flush = true;
 }
@@ -1450,17 +1465,10 @@ void __io_submit_flush_completions(struct io_ring_ctx *ctx)
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
+				io_cqe_overflow(ctx, &req->cqe, &req->big_cqe);
+			else
+				io_cqe_overflow_locked(ctx, &req->cqe, &req->big_cqe);
 		}
 	}
 	__io_cq_unlock_post(ctx);
-- 
2.49.0


