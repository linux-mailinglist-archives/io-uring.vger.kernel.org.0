Return-Path: <io-uring+bounces-3818-lists+io-uring=lfdr.de@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from sy.mirrors.kernel.org (sy.mirrors.kernel.org [147.75.48.161])
	by mail.lfdr.de (Postfix) with ESMTPS id B9A269A4367
	for <lists+io-uring@lfdr.de>; Fri, 18 Oct 2024 18:13:54 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sy.mirrors.kernel.org (Postfix) with ESMTPS id 3EBA7B203EF
	for <lists+io-uring@lfdr.de>; Fri, 18 Oct 2024 16:13:52 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 9D42113D52E;
	Fri, 18 Oct 2024 16:13:48 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="Sqf3w05g"
X-Original-To: io-uring@vger.kernel.org
Received: from mail-ed1-f54.google.com (mail-ed1-f54.google.com [209.85.208.54])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7F5AE1F4266
	for <io-uring@vger.kernel.org>; Fri, 18 Oct 2024 16:13:46 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.208.54
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1729268028; cv=none; b=I3C7S/Lu8dvA086nM4WAZRJEJq3sp1wd1ypH2vLwW25VM1p5ZTxklQ0Pwu2hmts9/9FhB/i7mw6qWQsSVOcEvU2h7jEpKkr3mTx/V07MM8IKUib1zMdzGj6JkKvN/eNjwAVUQRQYBOe4mLjT2YVGjLsGSd8OIUHS9rmbLIiFACI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1729268028; c=relaxed/simple;
	bh=S4dOd6Mq+5JNz3Nuyq2EmSYRL8cMidpk1yyQpl57F4c=;
	h=From:To:Cc:Subject:Date:Message-ID:MIME-Version; b=ji0u4AcicFB2narcyjPoeJntyVZzaw+fIqZspCPe7JVu66VSlp6D3vb5EklawrkPby7JRI2oSp7yo77znAljDL98L+zYX6K3+NJyqnsGY+5pW4kYltsMZNTGCQ2weepCEC1MAQ9djGbw+7akcehlLETrQtw2D4Yv6Y8n4NqFstc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=Sqf3w05g; arc=none smtp.client-ip=209.85.208.54
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Received: by mail-ed1-f54.google.com with SMTP id 4fb4d7f45d1cf-5c9fd6dae47so2612181a12.2
        for <io-uring@vger.kernel.org>; Fri, 18 Oct 2024 09:13:46 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1729268024; x=1729872824; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:from:to:cc:subject:date:message-id:reply-to;
        bh=V3gjjfjv//FwUfgXpQAkQ+RYwc9ZtWFvFci/vLqj17k=;
        b=Sqf3w05gGsiGkst1wsf9/4P/33ipWzvO6/FSFkRjnt5kDM1xvhkSkUYURvyyGncfWf
         U3vdU622YYEv2H84LRpkXy8gjoWacVUhJGEVZpO8qXsql9CM9MSWbZvcjcUiti/T1DHa
         XPyByevllyrN+ATpAprwcCrrQnRO7vtgzqR7G2ZoMSK8/OHjVZYWaCf+0k3zo5UiCuwG
         QlHwcgzLdKOsawsooTRejbfo7otCTsiv5SmTmnU+XNz1ae/gM3PbZ8ZsbZMoOWxXgpMX
         Sn0FJMW7bAAtMCIymG7ofzh+Lgx3HSm031FEj+kSkZ+5zF4UviyPfyEe6SdlnV9vbCjj
         rP0Q==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1729268024; x=1729872824;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=V3gjjfjv//FwUfgXpQAkQ+RYwc9ZtWFvFci/vLqj17k=;
        b=VNGWGkx9CUEaYVSguOaTPC8h1MuYtAy5XoeHiyBuh33TGmZgqO7JUe937mQLT3PUap
         U+xwSU74K87q8M7i/qzx740B7qjkMEwNg5Xixa5QH5hkKpKww0cXCi4Q0/5C0N/ly0sT
         9/VioaOGX7y6asOK7VVEk1y896inf5uR45FC5TQzDq7HEE3+YlMNPszv5b8HChwtZx5j
         dZ2JtYfFvFt1zYrszUtt4/vkCLLkodPyWLXSadJCDGp0JLhZOX5kZ0LWKgsyTws9MRXv
         c11yLpeCLsV27lZa+sLmf8NMeKv0WP25wYr5zQ/BL6UX98LBip7FglRFT8UjZBnWxm1E
         NuWg==
X-Gm-Message-State: AOJu0YyKykxTlMK3mc76G2QGVhgxbSeFqsAQUiIAhYrH7WTe14D//LoP
	2dJokbXOYH8GqF9oCu61x+A3qGuuS3FvS0W1uTCDpvBR8ni465BCkIEaZg==
X-Google-Smtp-Source: AGHT+IG+1yV0SwA9XiMnr4CGOKsEte0MqQjyDq93+3BFSgW7oGTburskeru8pTCC4URz9xCQ+03+0g==
X-Received: by 2002:a17:907:9494:b0:a9a:861:5d9f with SMTP id a640c23a62f3a-a9a69c6868amr241071166b.40.1729268024201;
        Fri, 18 Oct 2024 09:13:44 -0700 (PDT)
Received: from 127.0.0.1localhost ([163.114.131.193])
        by smtp.gmail.com with ESMTPSA id a640c23a62f3a-a9a68bf0401sm114815566b.147.2024.10.18.09.13.43
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 18 Oct 2024 09:13:43 -0700 (PDT)
From: Pavel Begunkov <asml.silence@gmail.com>
To: io-uring@vger.kernel.org
Cc: Jens Axboe <axboe@kernel.dk>,
	asml.silence@gmail.com
Subject: [PATCH for-next] io_uring: clean up cqe trace points
Date: Fri, 18 Oct 2024 17:14:00 +0100
Message-ID: <b83c1ca9ee5aed2df0f3bb743bf5ed699cce4c86.1729267437.git.asml.silence@gmail.com>
X-Mailer: git-send-email 2.46.0
Precedence: bulk
X-Mailing-List: io-uring@vger.kernel.org
List-Id: <io-uring.vger.kernel.org>
List-Subscribe: <mailto:io-uring+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:io-uring+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

We have too many helpers posting CQEs, instead of tracing completion
events before filling in a CQE and thus having to pass all the data,
set the CQE first, pass it to the tracing helper and let it extract
everything it needs.

Signed-off-by: Pavel Begunkov <asml.silence@gmail.com>
---
 include/linux/io_uring_types.h  |  5 +++++
 include/trace/events/io_uring.h | 24 +++++++++---------------
 io_uring/io_uring.c             |  4 ++--
 io_uring/io_uring.h             |  7 +++----
 4 files changed, 19 insertions(+), 21 deletions(-)

diff --git a/include/linux/io_uring_types.h b/include/linux/io_uring_types.h
index 4b9ba523978d..b1869d7bdab5 100644
--- a/include/linux/io_uring_types.h
+++ b/include/linux/io_uring_types.h
@@ -667,4 +667,9 @@ struct io_overflow_cqe {
 	struct io_uring_cqe cqe;
 };
 
+static inline bool io_ctx_cqe32(struct io_ring_ctx *ctx)
+{
+	return ctx->flags & IORING_SETUP_CQE32;
+}
+
 #endif
diff --git a/include/trace/events/io_uring.h b/include/trace/events/io_uring.h
index 412c9c210a32..fb81c533b310 100644
--- a/include/trace/events/io_uring.h
+++ b/include/trace/events/io_uring.h
@@ -315,20 +315,14 @@ TRACE_EVENT(io_uring_fail_link,
  * io_uring_complete - called when completing an SQE
  *
  * @ctx:		pointer to a ring context structure
- * @req:		pointer to a submitted request
- * @user_data:		user data associated with the request
- * @res:		result of the request
- * @cflags:		completion flags
- * @extra1:		extra 64-bit data for CQE32
- * @extra2:		extra 64-bit data for CQE32
- *
+ * @req:		(optional) pointer to a submitted request
+ * @cqe:		pointer to the filled in CQE being posted
  */
 TRACE_EVENT(io_uring_complete,
 
-	TP_PROTO(void *ctx, void *req, u64 user_data, int res, unsigned cflags,
-		 u64 extra1, u64 extra2),
+TP_PROTO(struct io_ring_ctx *ctx, void *req, struct io_uring_cqe *cqe),
 
-	TP_ARGS(ctx, req, user_data, res, cflags, extra1, extra2),
+	TP_ARGS(ctx, req, cqe),
 
 	TP_STRUCT__entry (
 		__field(  void *,	ctx		)
@@ -343,11 +337,11 @@ TRACE_EVENT(io_uring_complete,
 	TP_fast_assign(
 		__entry->ctx		= ctx;
 		__entry->req		= req;
-		__entry->user_data	= user_data;
-		__entry->res		= res;
-		__entry->cflags		= cflags;
-		__entry->extra1		= extra1;
-		__entry->extra2		= extra2;
+		__entry->user_data	= cqe->user_data;
+		__entry->res		= cqe->res;
+		__entry->cflags		= cqe->flags;
+		__entry->extra1		= io_ctx_cqe32(ctx) ? cqe->big_cqe[0] : 0;
+		__entry->extra2		= io_ctx_cqe32(ctx) ? cqe->big_cqe[1] : 0;
 	),
 
 	TP_printk("ring %p, req %p, user_data 0x%llx, result %d, cflags 0x%x "
diff --git a/io_uring/io_uring.c b/io_uring/io_uring.c
index e253f0176d0a..9caef6a6ca28 100644
--- a/io_uring/io_uring.c
+++ b/io_uring/io_uring.c
@@ -823,8 +823,6 @@ static bool io_fill_cqe_aux(struct io_ring_ctx *ctx, u64 user_data, s32 res,
 	 * the ring.
 	 */
 	if (likely(io_get_cqe(ctx, &cqe))) {
-		trace_io_uring_complete(ctx, NULL, user_data, res, cflags, 0, 0);
-
 		WRITE_ONCE(cqe->user_data, user_data);
 		WRITE_ONCE(cqe->res, res);
 		WRITE_ONCE(cqe->flags, cflags);
@@ -833,6 +831,8 @@ static bool io_fill_cqe_aux(struct io_ring_ctx *ctx, u64 user_data, s32 res,
 			WRITE_ONCE(cqe->big_cqe[0], 0);
 			WRITE_ONCE(cqe->big_cqe[1], 0);
 		}
+
+		trace_io_uring_complete(ctx, NULL, cqe);
 		return true;
 	}
 	return false;
diff --git a/io_uring/io_uring.h b/io_uring/io_uring.h
index 70b6675941ff..9cd9a127e9ed 100644
--- a/io_uring/io_uring.h
+++ b/io_uring/io_uring.h
@@ -189,16 +189,15 @@ static __always_inline bool io_fill_cqe_req(struct io_ring_ctx *ctx,
 	if (unlikely(!io_get_cqe(ctx, &cqe)))
 		return false;
 
-	if (trace_io_uring_complete_enabled())
-		trace_io_uring_complete(req->ctx, req, req->cqe.user_data,
-					req->cqe.res, req->cqe.flags,
-					req->big_cqe.extra1, req->big_cqe.extra2);
 
 	memcpy(cqe, &req->cqe, sizeof(*cqe));
 	if (ctx->flags & IORING_SETUP_CQE32) {
 		memcpy(cqe->big_cqe, &req->big_cqe, sizeof(*cqe));
 		memset(&req->big_cqe, 0, sizeof(req->big_cqe));
 	}
+
+	if (trace_io_uring_complete_enabled())
+		trace_io_uring_complete(req->ctx, req, cqe);
 	return true;
 }
 
-- 
2.46.0


