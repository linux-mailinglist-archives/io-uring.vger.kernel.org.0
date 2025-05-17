Return-Path: <io-uring+bounces-8026-lists+io-uring=lfdr.de@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [139.178.88.99])
	by mail.lfdr.de (Postfix) with ESMTPS id CC8BBABA9E4
	for <lists+io-uring@lfdr.de>; Sat, 17 May 2025 13:49:54 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 807209E2497
	for <lists+io-uring@lfdr.de>; Sat, 17 May 2025 11:49:34 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 001BD1FBE9E;
	Sat, 17 May 2025 11:49:49 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel-dk.20230601.gappssmtp.com header.i=@kernel-dk.20230601.gappssmtp.com header.b="GXYwKU+6"
X-Original-To: io-uring@vger.kernel.org
Received: from mail-il1-f175.google.com (mail-il1-f175.google.com [209.85.166.175])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 935671F4C9F
	for <io-uring@vger.kernel.org>; Sat, 17 May 2025 11:49:46 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.166.175
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1747482588; cv=none; b=NtpcbQ108pi+XU05z0C9BRA9MBLtvuhf6NdeG7XNIyoJ098pL75RrtUGozWIMoZZpVoVPR4NkeEWDAnikYrdkd/huHaYJyQZezEexam+36Sx0hu9NgTYxkvx6FkC2EQ8KQdwYRl+PuiiHvpJEok40XqGpLwo9oS0sUVQ7V2awbM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1747482588; c=relaxed/simple;
	bh=B1ifQAIjw+BnfIYVY2ThqGsFB4AXXBm1B0+mtr0lKbE=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=ByF7QRv8rm1YIIoVHaMx5I5T1wtyg7uwnvSi//QRAJOvr1Qf85/hUHD7YWWb5JII5u0qhDsC+ekEGkLJ3ii3pE0hE89cYjZb1QwSQmy9pEPwfeLaeMCQBGTgqCXrge4MhbJux5mJSsOj0LNb7n5lHNI2kvJcieN6+Nso3HAeWmo=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=kernel.dk; spf=pass smtp.mailfrom=kernel.dk; dkim=pass (2048-bit key) header.d=kernel-dk.20230601.gappssmtp.com header.i=@kernel-dk.20230601.gappssmtp.com header.b=GXYwKU+6; arc=none smtp.client-ip=209.85.166.175
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=kernel.dk
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=kernel.dk
Received: by mail-il1-f175.google.com with SMTP id e9e14a558f8ab-3db87b9605bso12680965ab.3
        for <io-uring@vger.kernel.org>; Sat, 17 May 2025 04:49:46 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernel-dk.20230601.gappssmtp.com; s=20230601; t=1747482585; x=1748087385; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=z8vhUgakmBIUA6fqWv4nPLoDT8d4uEii4t1oMqUbehs=;
        b=GXYwKU+62oq+ju8dpdEHxursJDDhf/eoG32mLlJ4QQhhAZLHlG6gDKROjf5bOCJTkp
         ZeVd8yQ5XixiAeH3Ql2FonPYoCrQ+u25RWz5Zjpl4lGCTPHRpatMEMQb8od2alM/4zTQ
         8ce8EpoElTjjghFMGjlK/r0c7SSh8XFjK2D+rmDUiPB+kLOQSC31cpMHZSKQfCCGIkFb
         UzIe7yI7jAO9KLQvVeIxoKJhKv8WmD+I1zgCGSdnUcWWiJkmu9JiK0V9qGFDaDP7+siP
         Lv7BDwPfBfNoaTW/L3DP9Xq3+B9FbK6zaBlHkGus0/cZuByLCxHZHXDw6AEizVXcyxvn
         3Dzg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1747482585; x=1748087385;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=z8vhUgakmBIUA6fqWv4nPLoDT8d4uEii4t1oMqUbehs=;
        b=kGfFfONLljLDdFm5gkUIOOEjl5Ylns852lWVwBv6T3jwrIcgt2OWxkNBDLVQw9mOG5
         iWWQi5z5tb7zptkVeBah+hCVirgpV/DKrxMWTEQT4XQGInJ4aOwSHN945BbO6Jxjo55+
         ZnEHSJU4Gvw92T66nwGcz/KPTs+4WgvjspzVH14mxK8cUnEhCWvPmLMiV8ik1YuWuIkr
         BxE2+tV1PFEER+Tf1rE2sq1KsJRdkHQG53PHNQWX6m6XpuA1ZfE8bUU7LZVV08lz25e9
         NgoDkueCA8o3wQheG3E7GzDHMsQRhPB+szZC9KhRfADGwcjA9gHKo1A9T3Ymi6qhTp4a
         XXEg==
X-Gm-Message-State: AOJu0YwPnaQpAS9X1jwsohz0M3OYS1OxgZhpA+rKKQE3gPP4zGctx1KW
	hcwxBbjRkI5tG0Eupc0aDNEYVBtH1lmzbFnGSWoqbeXVsu51muPhySoC8zTeUJ7M7q2QUoMJch2
	ws/iV
X-Gm-Gg: ASbGncvQvXOrqYw9zQXS+vreCa2mO+Fb6Mjpe7X37K2JdyARlZWO8GlQjKwoqkPx/MS
	0ypduYEx/69GwZuUlQ5EAQA3qtZCgyy55TyCxNPKm1mdqwidv4l0LuHdxtJGqS3L3duYWHFqJDM
	hOFoyOI3fpIZ69zHMSBMNCydEV3YqgQIZN3FoMXlKwsGkVxYY7o43OHSzOo8cu5shYqWnZp+iWM
	4IjUYfI2kCpor7yo4K56VhWmwZYk1nPDDpyhrcZ5PtEZRpRES8yNHYLfm5n7rd/fbO8tUOk5+3G
	y9lMiSlC7VZwkzwJwvUsBB39mnzG0BD20KYetkWmmKMC1s/tt4kzQBLF
X-Google-Smtp-Source: AGHT+IGoEwcnbnjiuYWgEbxBsMhcbWu5oR+Bhob0IdeyZbc5uJ91+Ou/4FxVxWzOX1mbxK1CLSBoLA==
X-Received: by 2002:a05:6e02:2409:b0:3d9:6dfe:5137 with SMTP id e9e14a558f8ab-3db842ca128mr70266405ab.10.1747482585218;
        Sat, 17 May 2025 04:49:45 -0700 (PDT)
Received: from localhost.localdomain ([198.8.77.157])
        by smtp.gmail.com with ESMTPSA id 8926c6da1cb9f-4fbcc3b1a8bsm874354173.47.2025.05.17.04.49.44
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sat, 17 May 2025 04:49:44 -0700 (PDT)
From: Jens Axboe <axboe@kernel.dk>
To: io-uring@vger.kernel.org
Cc: asml.silence@gmail.com,
	csander@purestorage.com,
	Jens Axboe <axboe@kernel.dk>
Subject: [PATCH 2/5] io_uring: split alloc and add of overflow
Date: Sat, 17 May 2025 05:42:12 -0600
Message-ID: <20250517114938.533378-3-axboe@kernel.dk>
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

Add a new helper, io_alloc_ocqe(), that simply allocates and fills an
overflow entry. Then it can get done outside of the locking section,
and hence use more appropriate gfp_t allocation flags rather than always
default to GFP_ATOMIC.

Inspired by a previous series from Pavel:

https://lore.kernel.org/io-uring/cover.1747209332.git.asml.silence@gmail.com/

Reviewed-by: Caleb Sander Mateos <csander@purestorage.com>
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


