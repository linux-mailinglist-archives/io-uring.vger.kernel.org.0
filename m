Return-Path: <io-uring+bounces-8013-lists+io-uring=lfdr.de@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [IPv6:2604:1380:45d1:ec00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 2207FABA47F
	for <lists+io-uring@lfdr.de>; Fri, 16 May 2025 22:10:23 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id A6E57506982
	for <lists+io-uring@lfdr.de>; Fri, 16 May 2025 20:10:23 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 44F7527AC56;
	Fri, 16 May 2025 20:10:19 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel-dk.20230601.gappssmtp.com header.i=@kernel-dk.20230601.gappssmtp.com header.b="y7dU1zyU"
X-Original-To: io-uring@vger.kernel.org
Received: from mail-il1-f180.google.com (mail-il1-f180.google.com [209.85.166.180])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id DD2E322B8AA
	for <io-uring@vger.kernel.org>; Fri, 16 May 2025 20:10:15 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.166.180
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1747426219; cv=none; b=jjhI4VQxUCUKfvItfO4e5MsVpEEu/3CDL7P0zbXLD70RfAgheag4md89IxH1DSoV5l9zIVrITlmSjrmqY5eOHBEp2qzrIwBRj8newRDjHy9P8IxdyVq/RZUsaiROcOZHRL2Q8TmHvFg3gaEtjR563gW2lo18GTxiC/Qjm9pYFYE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1747426219; c=relaxed/simple;
	bh=HGM6yg1C4cbgxAzHO4E/HPH9vkWkiLYHprtAeHs2QfU=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=KW0YfVk3n5bvvdUE0DUBb00SdQy0t/+knaKZTnQpjn0Pda/u/Pz4SwHYEoB+vwCX8/75rBrfx1UnzVXDSoXNr0VWMbAy7W2t7nZWwEM5ib5/LXEDtxD6asG1OPURAiwquXDa8jPxgUg5FxZ0jISPjSW+eJ25Vq6WsZLsrbOfaoQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=kernel.dk; spf=pass smtp.mailfrom=kernel.dk; dkim=pass (2048-bit key) header.d=kernel-dk.20230601.gappssmtp.com header.i=@kernel-dk.20230601.gappssmtp.com header.b=y7dU1zyU; arc=none smtp.client-ip=209.85.166.180
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=kernel.dk
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=kernel.dk
Received: by mail-il1-f180.google.com with SMTP id e9e14a558f8ab-3da73df6b6bso8263195ab.3
        for <io-uring@vger.kernel.org>; Fri, 16 May 2025 13:10:15 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernel-dk.20230601.gappssmtp.com; s=20230601; t=1747426214; x=1748031014; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=y9TGYAqkgac0cMi5ap6g73F1RYmizkyRa3CX2CdEt78=;
        b=y7dU1zyUo7+mbsFn+lqVO1OxfPIC4BZHG/I8ze3TJ1oFZM0++dEzuD8zKfFbVQfx0o
         vWAsibDsDpA79Ii2qtwM4q14GYL6waJs3J+hLskYBiNOGZWyjTTvCU4SDDYwX48ehma5
         tYiJgo65GqD2RBsBv0Hu7hY/X+GSEIiPxoI/yTc46kgieOdERu3yimp4gPz54CKl+sk9
         Uf0RFFM292BVoz8SZ+Pwj9DANinqqqyz0dl1icbGc1s9RKrIEscJaC2NFezcyD+c1/M3
         yTSVoe792U/Yaqb4z3GyrShIPW5CqGFIdiasSVwwnvfLVr1IihyRpcCmrIAhOyUiJOKz
         B7VQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1747426214; x=1748031014;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=y9TGYAqkgac0cMi5ap6g73F1RYmizkyRa3CX2CdEt78=;
        b=Xu7y+++dR5EIloYbr5LvSqzp4X32HhURk2opy7K6/pVTre+XGTKHew0ZKS8ok//Fo2
         ctjcCG/Lwu+9WAG7uyW4RvM9rFqkhjUpg+uGoXggvRL297YI9VUx9r2IxHIJYWm/uz1i
         LOiOIiv/4EUGzH8XgXK64Y1iqY7yKf+nQIzidWosQZbAMUZX44vXrFj/sYIuV8lG0ULt
         FrEMqoVxyDyzv5qOZTDYi7xaDPVajwYeHxQIwoaaILbxcDcETAsRPTvUL+GgfRZ2YG8l
         bOJRSlaJE7M4cY46aLnu4SWnZ05EyND0ltWohfatLCQVA4zM/Mwer7toGUfthkBb9FM7
         hXtA==
X-Gm-Message-State: AOJu0YzFiSal42mC9kqFj9bTyc8bbu5tRiOj8mGJZZndicBD78SsDJCn
	EAIgkyx7K5wwNDzwQwpwOmjXpSlur5KiyaE2iUnZ83WRDHiGlV9rcpemKvwOfRah5IEr1i4Uop/
	tjsR/
X-Gm-Gg: ASbGncuL8/0YmpfBEEmTqy6CxC1TfdGYWTdW/L8HTxL6B/xNlcmQ8DW0CHB9DNxigZR
	wzA3mD9r35b71K/v0J69RlsogAC/bSAhNdf5YyiX4HX5PC12lUUO/GynlnSTEt+UgJsYSyqVGTE
	qeJlQq6B67y6mWyDXnAuoGXW5ryShOcDaMx9nXVqY8szlVQwVOpCnaSiMl4dkZFID103fR4SBAs
	3hVdkG+uMQzQvi4q65xipvCs7Zi8OWrizeT9VSMY/bsKU4veZKYLG+Mk2MAD5AAVMI8IIUQ/RjT
	wjQMbJvXv27k+OwtbSNyHRlxJLBB1dOMovqIY2WYLZtC1EKyVYPAxDdo
X-Google-Smtp-Source: AGHT+IGewnuNkB7SowubaR9/fEgqS0+sKQMsvzbIpT3S36MZ+W6Oo5gssosp96F0iI/vdg31hxVsIA==
X-Received: by 2002:a05:6e02:d:b0:3d4:3ab3:5574 with SMTP id e9e14a558f8ab-3db84297809mr61406335ab.3.1747426214424;
        Fri, 16 May 2025 13:10:14 -0700 (PDT)
Received: from localhost.localdomain ([198.8.77.157])
        by smtp.gmail.com with ESMTPSA id 8926c6da1cb9f-4fbcc4ea4b5sm541805173.136.2025.05.16.13.10.13
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 16 May 2025 13:10:13 -0700 (PDT)
From: Jens Axboe <axboe@kernel.dk>
To: io-uring@vger.kernel.org
Cc: asml.silence@gmail.com,
	csander@purestorage.com,
	Jens Axboe <axboe@kernel.dk>
Subject: [PATCH 2/5] io_uring: split alloc and add of overflow
Date: Fri, 16 May 2025 14:05:07 -0600
Message-ID: <20250516201007.482667-3-axboe@kernel.dk>
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

Add a new helper, io_alloc_ocqe(), that simply allocates and fills an
overflow entry. Then it can get done outside of the locking section,
and hence use more appropriate gfp_t allocation flags rather than always
default to GFP_ATOMIC.

Inspired by a previous series from Pavel:

https://lore.kernel.org/io-uring/cover.1747209332.git.asml.silence@gmail.com/

Signed-off-by: Jens Axboe <axboe@kernel.dk>
---
 io_uring/io_uring.c | 75 +++++++++++++++++++++++++++------------------
 1 file changed, 45 insertions(+), 30 deletions(-)

diff --git a/io_uring/io_uring.c b/io_uring/io_uring.c
index e4d6e572eabc..b564a1bdc068 100644
--- a/io_uring/io_uring.c
+++ b/io_uring/io_uring.c
@@ -697,20 +697,11 @@ static __cold void io_uring_drop_tctx_refs(struct task_struct *task)
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
 
@@ -728,17 +719,35 @@ static bool io_cqring_event_overflow(struct io_ring_ctx *ctx, u64 user_data,
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
 /*
  * writes to the cq entry need to come after reading head; the
  * control dependency is enough as we're using WRITE_ONCE to
@@ -803,8 +812,12 @@ bool io_post_aux_cqe(struct io_ring_ctx *ctx, u64 user_data, s32 res, u32 cflags
 
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
@@ -819,8 +832,11 @@ void io_add_aux_cqe(struct io_ring_ctx *ctx, u64 user_data, s32 res, u32 cflags)
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
@@ -1425,20 +1441,19 @@ void __io_submit_flush_completions(struct io_ring_ctx *ctx)
 		 */
 		if (!(req->flags & (REQ_F_CQE_SKIP | REQ_F_REISSUE)) &&
 		    unlikely(!io_fill_cqe_req(ctx, req))) {
+			gfp_t gfp = ctx->lockless_cq ? GFP_KERNEL : GFP_ATOMIC;
+			struct io_overflow_cqe *ocqe;
+
+			ocqe = io_alloc_ocqe(ctx, req->cqe.user_data, req->cqe.res,
+					     req->cqe.flags, req->big_cqe.extra1,
+					     req->big_cqe.extra2, gfp);
 			if (ctx->lockless_cq) {
 				spin_lock(&ctx->completion_lock);
-				io_cqring_event_overflow(req->ctx, req->cqe.user_data,
-							req->cqe.res, req->cqe.flags,
-							req->big_cqe.extra1,
-							req->big_cqe.extra2);
+				io_cqring_add_overflow(ctx, ocqe);
 				spin_unlock(&ctx->completion_lock);
 			} else {
-				io_cqring_event_overflow(req->ctx, req->cqe.user_data,
-							req->cqe.res, req->cqe.flags,
-							req->big_cqe.extra1,
-							req->big_cqe.extra2);
+				io_cqring_add_overflow(ctx, ocqe);
 			}
-
 			memset(&req->big_cqe, 0, sizeof(req->big_cqe));
 		}
 	}
-- 
2.49.0


