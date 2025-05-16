Return-Path: <io-uring+bounces-8015-lists+io-uring=lfdr.de@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [139.178.88.99])
	by mail.lfdr.de (Postfix) with ESMTPS id 1B738ABA481
	for <lists+io-uring@lfdr.de>; Fri, 16 May 2025 22:10:26 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 75556A2601C
	for <lists+io-uring@lfdr.de>; Fri, 16 May 2025 20:10:05 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id DD43822CBC7;
	Fri, 16 May 2025 20:10:20 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel-dk.20230601.gappssmtp.com header.i=@kernel-dk.20230601.gappssmtp.com header.b="yTRhdP8l"
X-Original-To: io-uring@vger.kernel.org
Received: from mail-il1-f174.google.com (mail-il1-f174.google.com [209.85.166.174])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C89F527AC42
	for <io-uring@vger.kernel.org>; Fri, 16 May 2025 20:10:18 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.166.174
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1747426220; cv=none; b=SXHaIRyCL2ek11VAwhBEw9zPCWpgnlHPfKEsMyW3eaVhjFAsD3Hor3ctyp7yN+qB7TAdeCsBWawQQw2g8Us1XjMKSO8HzZ5JTL+JXFbrEx9pvzu6db9e9r8NldlWK7b7l9vw5W8JvA7Rp32DV00LTlLYVGoaXwi1A0xoXLQJz9w=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1747426220; c=relaxed/simple;
	bh=E7X7dWOk2Ar//+XhnVX3s84K9ULkd7PoJLw2RIaFav8=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=l7i8Rv5ZvND4ctKh2VRnAtiXzIsgv6+qo50f7HRj6GEZsUxfIcZd/fgY/0+xBfEvB/b3U6B0Ph7y1SbJ7OgcyUL60LjyWXTv6PTLObl0nM0rGemkPpvIpuEXQQul448/RyvQRdb2KpxYGwEum/85jUQWQT36vmU3wT7uhtWwktE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=kernel.dk; spf=pass smtp.mailfrom=kernel.dk; dkim=pass (2048-bit key) header.d=kernel-dk.20230601.gappssmtp.com header.i=@kernel-dk.20230601.gappssmtp.com header.b=yTRhdP8l; arc=none smtp.client-ip=209.85.166.174
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=kernel.dk
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=kernel.dk
Received: by mail-il1-f174.google.com with SMTP id e9e14a558f8ab-3da6fb115a6so17518435ab.1
        for <io-uring@vger.kernel.org>; Fri, 16 May 2025 13:10:18 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernel-dk.20230601.gappssmtp.com; s=20230601; t=1747426217; x=1748031017; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=VInqMdyFIH5q9LA+Ep0kL0dwS75RvDVps1EdpYeTozs=;
        b=yTRhdP8lhSdMAULtEpdQIcfFhG01BbgZNgXz8i6VzYe4g+PN8yJMk4Sl7zUO9U1e8b
         7PISTnhaWrh3Nzv/5ddOSkSYcREthulV+m89xWcbZOLJ2+zHUhy3wrtXvKSwCMy22PUU
         YvrVgT2/wNGLWsW8MggeS9T3WnKaBcn79TThzJbJ/xzsf1C2MvFidtDJD8yRFGeI7e1M
         Ht32c+PZodAPtdh03RL+3nf8WkUJC80Vv+ctg5YN/XEYcWeY0PWVtVD877Ij8KuiypJA
         1qd7KLEWOhC6HrhPXn3zc9Tsma84eXBP1qUDojdJIFms51lghP4k+Rp2jDPs3q4yoJIz
         90Hg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1747426217; x=1748031017;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=VInqMdyFIH5q9LA+Ep0kL0dwS75RvDVps1EdpYeTozs=;
        b=U6Zmp5Of+fO/HB8lneifz2mrUmuDKkPDWd83vpn2wGc6R5rY1tRl5vkKvPT6OTgSjA
         lQwVPoU/+cceNAH56qqsvEpJxzaxwQidVo2qcKCeTfWS8n6k8oh/lJ9Mx3VcWBBaqHyX
         h7Twjr3vrtZJ1RlCzHMOrAjBzVkkADhkWvzaAnTqQ74CWFX+xxLk8Z/bZGOdTl4jMPI9
         tyhl2SqH7hqPdzuyjX2RGbitVhaIELtZIq8ewvNtoyrsz0UOHgyPxXZZkAHEJekFJDkl
         vwHcDL/6umd9QDOaMGR+bI+TFFG7MsynBDi5d8+fFnVG3kIRn0eZdmzKl1BI5pVUd9TT
         Z2cw==
X-Gm-Message-State: AOJu0Yw8DlOXAa3uDXn6D2EjvAhQj0BB+Y7CEDCspYTqED2gWortWJGM
	aBy9kEHW9MRoFYqYI6DPP6e+qNwutxo9aNvGnfIAAfP6oY1sxrTNdgchZXlXSRGl0zw2SG1UdOa
	YQirk
X-Gm-Gg: ASbGnctFpVIDn9Q0yrNVtYCC7tzJctTAMXyUhdqGn1ze8gvmEEFd03QFRtiC9Hmo26+
	KOedX9k70vXTnE7erIJHGS76kjoIAWuLfCFOUtLAnM8lActzw/i/751Hpf5pa8GgwPqbGfhuaa5
	WcbmLSCgIygFOIw9w9+6prjyPUqEOfgYyuSzFxu5AJrpYMh9GnPEDiumkLzEJ9e1cKalRKox2LL
	fWPFHBLTEJxoGjHyDTEuhMPV2c7zK+Z8YU2aK25Dl2YT8l/DwFyBTXKm9eJLK2b7xqOqAtKpVgf
	dqzgvCF+ooFmJPhvmhU6UQJYqNi9R28MPYAuQRLeZ11/1c5P/4/FfHDA
X-Google-Smtp-Source: AGHT+IGjh7BKZCofcV3RFCyqg+ai+Q/ZFNKt/k5kBdNjAKNu4GSKKffh0kpvLbmJ8Tr8br4H/+n6fg==
X-Received: by 2002:a05:6e02:1544:b0:3d9:6d52:5483 with SMTP id e9e14a558f8ab-3db842de15amr54782035ab.11.1747426217376;
        Fri, 16 May 2025 13:10:17 -0700 (PDT)
Received: from localhost.localdomain ([198.8.77.157])
        by smtp.gmail.com with ESMTPSA id 8926c6da1cb9f-4fbcc4ea4b5sm541805173.136.2025.05.16.13.10.16
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 16 May 2025 13:10:16 -0700 (PDT)
From: Jens Axboe <axboe@kernel.dk>
To: io-uring@vger.kernel.org
Cc: asml.silence@gmail.com,
	csander@purestorage.com,
	Jens Axboe <axboe@kernel.dk>
Subject: [PATCH 4/5] io_uring: pass in struct io_big_cqe to io_alloc_ocqe()
Date: Fri, 16 May 2025 14:05:09 -0600
Message-ID: <20250516201007.482667-5-axboe@kernel.dk>
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

Rather than pass extra1/extra2 separately, just pass in the (now) named
io_big_cqe struct instead. The callers that don't use/support CQE32 will
now just pass a single NULL, rather than two seperate mystery zero
values.

Move the clearing of the big_cqe elements into io_alloc_ocqe() as well,
so it can get moved out of the generic code.

Signed-off-by: Jens Axboe <axboe@kernel.dk>
---
 include/linux/io_uring_types.h |  2 +-
 io_uring/io_uring.c            | 22 +++++++++++-----------
 2 files changed, 12 insertions(+), 12 deletions(-)

diff --git a/include/linux/io_uring_types.h b/include/linux/io_uring_types.h
index 00dbd7cd0e7d..2922635986f5 100644
--- a/include/linux/io_uring_types.h
+++ b/include/linux/io_uring_types.h
@@ -710,7 +710,7 @@ struct io_kiocb {
 	const struct cred		*creds;
 	struct io_wq_work		work;
 
-	struct {
+	struct io_big_cqe {
 		u64			extra1;
 		u64			extra2;
 	} big_cqe;
diff --git a/io_uring/io_uring.c b/io_uring/io_uring.c
index b50c2d434e74..c66fc4b7356b 100644
--- a/io_uring/io_uring.c
+++ b/io_uring/io_uring.c
@@ -724,8 +724,8 @@ static bool io_cqring_add_overflow(struct io_ring_ctx *ctx,
 }
 
 static struct io_overflow_cqe *io_alloc_ocqe(struct io_ring_ctx *ctx,
-					     struct io_cqe *cqe, u64 extra1,
-					     u64 extra2, gfp_t gfp)
+					     struct io_cqe *cqe,
+					     struct io_big_cqe *big_cqe, gfp_t gfp)
 {
 	struct io_overflow_cqe *ocqe;
 	size_t ocq_size = sizeof(struct io_overflow_cqe);
@@ -734,17 +734,19 @@ static struct io_overflow_cqe *io_alloc_ocqe(struct io_ring_ctx *ctx,
 	if (is_cqe32)
 		ocq_size += sizeof(struct io_uring_cqe);
 
-	ocqe = kmalloc(ocq_size, gfp | __GFP_ACCOUNT);
+	ocqe = kzalloc(ocq_size, gfp | __GFP_ACCOUNT);
 	trace_io_uring_cqe_overflow(ctx, cqe->user_data, cqe->res, cqe->flags, ocqe);
 	if (ocqe) {
 		ocqe->cqe.user_data = cqe->user_data;
 		ocqe->cqe.res = cqe->res;
 		ocqe->cqe.flags = cqe->flags;
-		if (is_cqe32) {
-			ocqe->cqe.big_cqe[0] = extra1;
-			ocqe->cqe.big_cqe[1] = extra2;
+		if (is_cqe32 && big_cqe) {
+			ocqe->cqe.big_cqe[0] = big_cqe->extra1;
+			ocqe->cqe.big_cqe[1] = big_cqe->extra2;
 		}
 	}
+	if (big_cqe)
+		big_cqe->extra1 = big_cqe->extra2 = 0;
 	return ocqe;
 }
 
@@ -819,7 +821,7 @@ bool io_post_aux_cqe(struct io_ring_ctx *ctx, u64 user_data, s32 res, u32 cflags
 		struct io_overflow_cqe *ocqe;
 		struct io_cqe cqe = io_init_cqe(user_data, res, cflags);
 
-		ocqe = io_alloc_ocqe(ctx, &cqe, 0, 0, GFP_ATOMIC);
+		ocqe = io_alloc_ocqe(ctx, &cqe, NULL, GFP_ATOMIC);
 		filled = io_cqring_add_overflow(ctx, ocqe);
 	}
 	io_cq_unlock_post(ctx);
@@ -839,7 +841,7 @@ void io_add_aux_cqe(struct io_ring_ctx *ctx, u64 user_data, s32 res, u32 cflags)
 		struct io_overflow_cqe *ocqe;
 		struct io_cqe cqe = io_init_cqe(user_data, res, cflags);
 
-		ocqe = io_alloc_ocqe(ctx, &cqe, 0, 0, GFP_KERNEL);
+		ocqe = io_alloc_ocqe(ctx, &cqe, NULL, GFP_KERNEL);
 		spin_lock(&ctx->completion_lock);
 		io_cqring_add_overflow(ctx, ocqe);
 		spin_unlock(&ctx->completion_lock);
@@ -1449,8 +1451,7 @@ void __io_submit_flush_completions(struct io_ring_ctx *ctx)
 			gfp_t gfp = ctx->lockless_cq ? GFP_KERNEL : GFP_ATOMIC;
 			struct io_overflow_cqe *ocqe;
 
-			ocqe = io_alloc_ocqe(ctx, &req->cqe, req->big_cqe.extra1,
-					     req->big_cqe.extra2, gfp);
+			ocqe = io_alloc_ocqe(ctx, &req->cqe, &req->big_cqe, gfp);
 			if (ctx->lockless_cq) {
 				spin_lock(&ctx->completion_lock);
 				io_cqring_add_overflow(ctx, ocqe);
@@ -1458,7 +1459,6 @@ void __io_submit_flush_completions(struct io_ring_ctx *ctx)
 			} else {
 				io_cqring_add_overflow(ctx, ocqe);
 			}
-			memset(&req->big_cqe, 0, sizeof(req->big_cqe));
 		}
 	}
 	__io_cq_unlock_post(ctx);
-- 
2.49.0


