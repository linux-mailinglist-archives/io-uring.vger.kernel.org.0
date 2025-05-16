Return-Path: <io-uring+bounces-7998-lists+io-uring=lfdr.de@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [147.75.80.249])
	by mail.lfdr.de (Postfix) with ESMTPS id 9831AABA15B
	for <lists+io-uring@lfdr.de>; Fri, 16 May 2025 18:58:17 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id 6DADD1C02144
	for <lists+io-uring@lfdr.de>; Fri, 16 May 2025 16:57:30 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 09B17215795;
	Fri, 16 May 2025 16:55:30 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel-dk.20230601.gappssmtp.com header.i=@kernel-dk.20230601.gappssmtp.com header.b="sm6TrfhU"
X-Original-To: io-uring@vger.kernel.org
Received: from mail-io1-f45.google.com (mail-io1-f45.google.com [209.85.166.45])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7C087214A77
	for <io-uring@vger.kernel.org>; Fri, 16 May 2025 16:55:27 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.166.45
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1747414529; cv=none; b=SBytgED9h2C6E1n8GgmLQu/s96yau8P6AWE0Rfb/hW0bAw1VSYPVwe/4i4JtWyUCiZUldaYaOx98UD76+hdZ/KgolhSsVPlvyXCLT1r2pTitibXhCkaeWLOhhB4xYd3Ykuv0kGx1hZ/4qHlw3pVe9Ty3M/8pef66z2uGOx2DV0Q=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1747414529; c=relaxed/simple;
	bh=Kxk9TaKdSLqybtLza0S2AZi4YU4oB1oatGYOThnmIjk=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=Gl29vuSe6jaGvN3Eb7HfKsEwuyzBAyQn6DJ8F2/GTZYucw7nYuan+ieTkJI4z+G86jww3mXC5o39yuiIbvQa0Y4hXLOEEjD8+2oiKbhmQMlBWwXByPKANeTd43CtsyfEXiB8YoYz3xG+7YZnnTLWn7Z6qjGI9XE2P4jy7FbVN4M=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=kernel.dk; spf=pass smtp.mailfrom=kernel.dk; dkim=pass (2048-bit key) header.d=kernel-dk.20230601.gappssmtp.com header.i=@kernel-dk.20230601.gappssmtp.com header.b=sm6TrfhU; arc=none smtp.client-ip=209.85.166.45
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=kernel.dk
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=kernel.dk
Received: by mail-io1-f45.google.com with SMTP id ca18e2360f4ac-85b41281b50so67772139f.3
        for <io-uring@vger.kernel.org>; Fri, 16 May 2025 09:55:27 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernel-dk.20230601.gappssmtp.com; s=20230601; t=1747414526; x=1748019326; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=JVF3dQfiRKXXnw3XNH+XogKgzlQ3rnR0nwNSbBbYF+Y=;
        b=sm6TrfhUzrujHO3UWxy5WP+KWrg2dish+Jnnt6zJU1IiO7i8vHN/GhnvIpz/TVt4R7
         PscFNzcXIKWU4+A+k4unmwCWkS7Nuks49Gg6cXIWNBENe292hTJQKDRh6SemUxkLbkH2
         0y2dLu8HBnHZNlizkjvZR6pN4EUXF6aw1EgtjtuSegKURV0vQsC6gHtLY5zMeLTcwebQ
         xSm4TEhNKWR8yOcvkqLoKZMHbToI7uuhy2/16fhKK+Ly/mEjMLbvq4Ebab9UjcUCby8w
         FUBNeMrf8odmtreuA0rF/wKSN47caXPnBYV6PkdazHuHwy8x2g8P7fysQ6QlYxDoGSXz
         Jpng==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1747414526; x=1748019326;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=JVF3dQfiRKXXnw3XNH+XogKgzlQ3rnR0nwNSbBbYF+Y=;
        b=Z71kBUuL7cCjhBfQgF2AqSiMGJan/G/Adv/VXpYS57XPP5L93iokVFtM5eL8L1C7J/
         mrsAobJBJQjXrALqBl3mvLprqzgbl8Y0ltW4BvE+deYsA4SXufGiyXIKf87tE1SyY9ac
         N2KCvAxl+rpomP9gHq0E1UuqmdpZa5e9zkRToJrgJyOX1UxNqMjVECmLzECyGTzCa9+I
         5HxLUEsCdwQJL7SgVEQQ0xpG65zeagsghlS6Wpf6ml1ACWSsZrLjUfESKUB3z6x8gg/x
         oK6tS1PD4Lri7RY5T5WkqUu8P8SVTxo8f4gAB5ZCJ93vhPLNumqtWOYN5V+QCHmKylfv
         hOYQ==
X-Gm-Message-State: AOJu0YxyPUJrUw+Fwbd6EyQc2BzP6ni5hHRCLKTqFlTBDhUQBrWvQqx3
	YzuJCGnlSuC0RqvbHn+L4JYeE6tQiEsUWX9UFm5PBEnrKWFET62b1G50igwPJB1sc7qMobH8Jyq
	V2wuH
X-Gm-Gg: ASbGncu4E2TfgRcdG+mZD7EME6C/nL+p6Wa27XdpcUUkGNBt0WlvlyRmxSlWVMi+l2v
	OYluDAVatFsbGxfrRyWAW39xXKPzkATMXVUG0IHM3/qw7MLsKe05EXUSe/tKB9x8qvk5qi9UUAk
	D6pk769EM2RywVcjje+MYgm4vcCnb453ysm0U4x/wMigQu3x1yfexWV4+JFgTHhvWZMaciU+1wf
	OwEucUHMGDGpOZDpqJAVlXeswjYbnO1cpZEC9UIbA5SOPPSmMMmYRHfEyD+JAIP3PX6m09ip8Vo
	+Tt6r79TSEl1fzfStkU2KICDRW6mB6JeUUvRNcukgWe56Zs7jGLq79g=
X-Google-Smtp-Source: AGHT+IEMRaLuqn9uI4viMD3mTvJAr0tE5fm54/09nfO6LBb5VM4KoqH5H5u4/YxPwH/ZjPmcXrHjCw==
X-Received: by 2002:a05:6e02:1fec:b0:3d6:cbed:3305 with SMTP id e9e14a558f8ab-3db842e26b7mr49453145ab.10.1747414525865;
        Fri, 16 May 2025 09:55:25 -0700 (PDT)
Received: from localhost.localdomain ([96.43.243.2])
        by smtp.gmail.com with ESMTPSA id 8926c6da1cb9f-4fbcc38a87csm480344173.10.2025.05.16.09.55.24
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 16 May 2025 09:55:24 -0700 (PDT)
From: Jens Axboe <axboe@kernel.dk>
To: io-uring@vger.kernel.org
Cc: asml.silence@gmail.com,
	csander@purestorage.com,
	Jens Axboe <axboe@kernel.dk>
Subject: [PATCH 2/3] io_uring: split alloc and add of overflow
Date: Fri, 16 May 2025 10:55:11 -0600
Message-ID: <20250516165518.429979-3-axboe@kernel.dk>
X-Mailer: git-send-email 2.49.0
In-Reply-To: <20250516165518.429979-1-axboe@kernel.dk>
References: <20250516165518.429979-1-axboe@kernel.dk>
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
index 068e140b6bd8..2ee002f878ba 100644
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
 
@@ -749,17 +740,35 @@ static bool io_cqring_event_overflow(struct io_ring_ctx *ctx, u64 user_data,
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
@@ -824,8 +833,12 @@ bool io_post_aux_cqe(struct io_ring_ctx *ctx, u64 user_data, s32 res, u32 cflags
 
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
@@ -840,8 +853,11 @@ void io_add_aux_cqe(struct io_ring_ctx *ctx, u64 user_data, s32 res, u32 cflags)
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
@@ -1432,20 +1448,19 @@ void __io_submit_flush_completions(struct io_ring_ctx *ctx)
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


