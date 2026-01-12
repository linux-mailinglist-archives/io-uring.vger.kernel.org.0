Return-Path: <io-uring+bounces-11594-lists+io-uring=lfdr.de@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from sto.lore.kernel.org (sto.lore.kernel.org [172.232.135.74])
	by mail.lfdr.de (Postfix) with ESMTPS id 7860DD13A78
	for <lists+io-uring@lfdr.de>; Mon, 12 Jan 2026 16:28:26 +0100 (CET)
Received: from smtp.subspace.kernel.org (conduit.subspace.kernel.org [100.90.174.1])
	by sto.lore.kernel.org (Postfix) with ESMTP id 2842C301834C
	for <lists+io-uring@lfdr.de>; Mon, 12 Jan 2026 15:21:38 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 4F1312DF130;
	Mon, 12 Jan 2026 15:19:17 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel-dk.20230601.gappssmtp.com header.i=@kernel-dk.20230601.gappssmtp.com header.b="aK3H8QL2"
X-Original-To: io-uring@vger.kernel.org
Received: from mail-oi1-f173.google.com (mail-oi1-f173.google.com [209.85.167.173])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id BC8EB2E9EB5
	for <io-uring@vger.kernel.org>; Mon, 12 Jan 2026 15:19:15 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.167.173
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1768231157; cv=none; b=EUQg0l8vPcprpbvUvALL1a4XsYaPk1HwPD+1WbMf4zbT1DVsiHSJJiDG2+Vsq0WlnDKx9HSMRzV/NbbGMryAvLDaII5grXWGs5palQ0/0GXyUPNCnAYmf5MqwB7ofsR6H3JH/6I9u6EB4lLc1e716pm6sLvf8MO7buJWUKxC4QA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1768231157; c=relaxed/simple;
	bh=/mVKUtNMODeACVPSg3r0iOJuPfB8rjWPn1Clocl45yM=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=Q41pZOGxVP3cV9P0v3tLliwCyLRgLPlLmBkFQeo0IEDgEU5Ilc6as9dkWKs0CIWvI1xTPH79jzFpWIIkTR9NXnm3Kp2t+LCG+nja+37KygHP+p7gwkiKikko7QjV8YZ6NOBWQMbfzLW/fEM6Ps+pbmyMdBPfRy5tGFY/IMsnlJw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=kernel.dk; spf=pass smtp.mailfrom=kernel.dk; dkim=pass (2048-bit key) header.d=kernel-dk.20230601.gappssmtp.com header.i=@kernel-dk.20230601.gappssmtp.com header.b=aK3H8QL2; arc=none smtp.client-ip=209.85.167.173
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=kernel.dk
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=kernel.dk
Received: by mail-oi1-f173.google.com with SMTP id 5614622812f47-45a85a05a70so1188074b6e.3
        for <io-uring@vger.kernel.org>; Mon, 12 Jan 2026 07:19:15 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernel-dk.20230601.gappssmtp.com; s=20230601; t=1768231154; x=1768835954; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=88VsNDXBhplsmI0bAKxLpws65Q/Bx0a9d+9y89kwrs4=;
        b=aK3H8QL25wW9yzgMWOlI1xL8IBhYHLwwB2yzkaumoSoPlJYLwwbhhhap0pUK4kKNZK
         UV2seb7w7g/ONUIejt57uYL/ORmQtEaNHntKZMaLm1otHbKQODc2jssRXc6FYKg3WHlS
         dcVCNgaD+ixBM0H8LN/CfwurV/tJWADzL58K6JTQZL7qeekcdjCQE5R9Nqt+KLtcx9mv
         TDG7FvhNQmxJ+N1K3M3cXXH4Vg+WgiD98mv4h1nxTS2ksKHtDRuyJVBZpyO+KcJX1AzK
         PWldjOfUgPpCmB5vwkuNpjfabTKGt3XvhjwoTJdzp0/riU8PddTmpqPSGGPDMjwUmBJl
         TzUQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1768231154; x=1768835954;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to;
        bh=88VsNDXBhplsmI0bAKxLpws65Q/Bx0a9d+9y89kwrs4=;
        b=DePrINQjdF48BDwiG5Pq/YMA4xCRRVt6qzlkDt+fJ94QaXYqfuxmbNBPyJa6W8kYrz
         FRYQAFRtoh8go8mFEjx1jfRryzVkcEJPAyxRu2yP3NNqtsX+byFrW+4BTNBgvMmxeK5Q
         Ojl2BuWBrGaEM2wFC5xeN3uHvjGFV7JL7EchZWwNK0KZUYURvUol+TQdzu0ZYNV+33pa
         8gMd+OY8jdx4H57g5OD0/DY+0x6fLsq30kCyZFnR+I9Z4IPQdwSWmsRqtOo1/JU2z9wN
         n2LqfXGHbw4Dy6xxT1GqCbuz7w1skxnYtQRFftuVB7jA5ji+H4y6YIp9a3keutg6T2C7
         Gx0w==
X-Gm-Message-State: AOJu0YwN+PLe+EAN21SkiKZQTaN6XBQmiCPmvDPl0uQdLb/mNRB4tjvv
	8OQ4SijP7zzli8UT44sHOoUXAvaBXfB86Q4PuunBspV01cuhVTAP750PwtZzBu1Emo/f/U2ifv3
	8XjNN
X-Gm-Gg: AY/fxX7IrrnqGtLPhz9yKgyC3APUK+GAqNPgvddkPrhg1n8fdBFlmFyxMS2AQORfVCk
	XHTl2zQdfE8mGrJIkhQZSvkbZISjsrfrVKxeIP7ObNw8S6TLJaeTJL/K5Ui28Qiyn6YzgdBCkxU
	T8LZBznJp9huJTNMsedwwwp8I9OiqFZTnlYyE95w3r7wlvN5+RrX+/0XUwKaGODxND7ehx8qB/p
	LC4nollw940DckEgek/newJ/UYk1GUvZvZ0YMmauBAnWSGJrz+Hcx0QlUviRosMqVuqiXdOeYa8
	RugTB/tvkbRdnHs4idQJoDx+HyruVJa75/4LqLYFP48F/NbRmbAvIGHyS6R4bfn8aIYjg9MWw2T
	Cv94eoGO8iquxwRZnup+M+FMuyZlIZ7yDSxM5MJM6F6OsW91mXDRxoPOtxHNYbjpTHn21FRI=
X-Google-Smtp-Source: AGHT+IG49q8snAat6f+KL9lpawCP/bdwrwf4oH+R8jq5t44Iah2H6Ddfv7eZjlaujfwbk0wkOTZQsw==
X-Received: by 2002:a05:6808:c2d8:b0:45a:5584:b84d with SMTP id 5614622812f47-45a6bebe564mr8399137b6e.32.1768231154191;
        Mon, 12 Jan 2026 07:19:14 -0800 (PST)
Received: from m2max ([198.8.77.157])
        by smtp.gmail.com with ESMTPSA id 5614622812f47-45a8c6b3fdfsm4210561b6e.17.2026.01.12.07.19.13
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 12 Jan 2026 07:19:13 -0800 (PST)
From: Jens Axboe <axboe@kernel.dk>
To: io-uring@vger.kernel.org
Cc: Jens Axboe <axboe@kernel.dk>
Subject: [PATCH 5/5] io_uring: track restrictions separately for IORING_OP and IORING_REGISTER
Date: Mon, 12 Jan 2026 08:14:45 -0700
Message-ID: <20260112151905.200261-6-axboe@kernel.dk>
X-Mailer: git-send-email 2.51.0
In-Reply-To: <20260112151905.200261-1-axboe@kernel.dk>
References: <20260112151905.200261-1-axboe@kernel.dk>
Precedence: bulk
X-Mailing-List: io-uring@vger.kernel.org
List-Id: <io-uring.vger.kernel.org>
List-Subscribe: <mailto:io-uring+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:io-uring+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

It's quite likely that only register opcode restrictions exists, in
which case we'd never need to check the normal opcodes. Split
ctx->restricted into two separate fields, one for I/O opcodes, and one
for register opcodes.

Signed-off-by: Jens Axboe <axboe@kernel.dk>
---
 include/linux/io_uring_types.h |  8 ++++++--
 io_uring/io_uring.c            |  4 ++--
 io_uring/register.c            | 19 ++++++++++++++-----
 3 files changed, 22 insertions(+), 9 deletions(-)

diff --git a/include/linux/io_uring_types.h b/include/linux/io_uring_types.h
index 54fd30abf2b8..e4c804f99c30 100644
--- a/include/linux/io_uring_types.h
+++ b/include/linux/io_uring_types.h
@@ -224,7 +224,10 @@ struct io_restriction {
 	DECLARE_BITMAP(sqe_op, IORING_OP_LAST);
 	u8 sqe_flags_allowed;
 	u8 sqe_flags_required;
-	bool registered;
+	/* IORING_OP_* restrictions exist */
+	bool op_registered;
+	/* IORING_REGISTER_* restrictions exist */
+	bool reg_registered;
 };
 
 struct io_submit_link {
@@ -259,7 +262,8 @@ struct io_ring_ctx {
 	struct {
 		unsigned int		flags;
 		unsigned int		drain_next: 1;
-		unsigned int		restricted: 1;
+		unsigned int		op_restricted: 1;
+		unsigned int		reg_restricted: 1;
 		unsigned int		off_timeout_used: 1;
 		unsigned int		drain_active: 1;
 		unsigned int		has_evfd: 1;
diff --git a/io_uring/io_uring.c b/io_uring/io_uring.c
index 452d87057527..8a1dfdc2c3a6 100644
--- a/io_uring/io_uring.c
+++ b/io_uring/io_uring.c
@@ -2056,7 +2056,7 @@ static inline bool io_check_restriction(struct io_ring_ctx *ctx,
 					struct io_kiocb *req,
 					unsigned int sqe_flags)
 {
-	if (!ctx->restricted)
+	if (!ctx->op_restricted)
 		return true;
 	if (!test_bit(req->opcode, ctx->restrictions.sqe_op))
 		return false;
@@ -2159,7 +2159,7 @@ static int io_init_req(struct io_ring_ctx *ctx, struct io_kiocb *req,
 			io_init_drain(ctx);
 		}
 	}
-	if (unlikely(ctx->restricted || ctx->drain_active || ctx->drain_next)) {
+	if (unlikely(ctx->op_restricted || ctx->drain_active || ctx->drain_next)) {
 		if (!io_check_restriction(ctx, req, sqe_flags))
 			return io_init_fail_req(req, -EACCES);
 		/* knock it to the slow queue path, will be drained there */
diff --git a/io_uring/register.c b/io_uring/register.c
index b3aac668a665..abbc8cb1934c 100644
--- a/io_uring/register.c
+++ b/io_uring/register.c
@@ -133,24 +133,31 @@ static __cold int io_parse_restrictions(void __user *arg, unsigned int nr_args,
 			if (res[i].register_op >= IORING_REGISTER_LAST)
 				goto err;
 			__set_bit(res[i].register_op, restrictions->register_op);
+			restrictions->reg_registered = true;
 			break;
 		case IORING_RESTRICTION_SQE_OP:
 			if (res[i].sqe_op >= IORING_OP_LAST)
 				goto err;
 			__set_bit(res[i].sqe_op, restrictions->sqe_op);
+			restrictions->op_registered = true;
 			break;
 		case IORING_RESTRICTION_SQE_FLAGS_ALLOWED:
 			restrictions->sqe_flags_allowed = res[i].sqe_flags;
+			restrictions->op_registered = true;
 			break;
 		case IORING_RESTRICTION_SQE_FLAGS_REQUIRED:
 			restrictions->sqe_flags_required = res[i].sqe_flags;
+			restrictions->op_registered = true;
 			break;
 		default:
 			goto err;
 		}
 	}
 	ret = nr_args;
-	restrictions->registered = true;
+	if (!nr_args) {
+		restrictions->op_registered = true;
+		restrictions->reg_registered = true;
+	}
 err:
 	kfree(res);
 	return ret;
@@ -166,7 +173,7 @@ static __cold int io_register_restrictions(struct io_ring_ctx *ctx,
 		return -EBADFD;
 
 	/* We allow only a single restrictions registration */
-	if (ctx->restrictions.registered)
+	if (ctx->restrictions.op_registered || ctx->restrictions.reg_registered)
 		return -EBUSY;
 
 	ret = io_parse_restrictions(arg, nr_args, &ctx->restrictions);
@@ -175,8 +182,10 @@ static __cold int io_register_restrictions(struct io_ring_ctx *ctx,
 		memset(&ctx->restrictions, 0, sizeof(ctx->restrictions));
 		return ret;
 	}
-	if (ctx->restrictions.registered)
-		ctx->restricted = 1;
+	if (ctx->restrictions.op_registered)
+		ctx->op_restricted = 1;
+	if (ctx->restrictions.reg_registered)
+		ctx->reg_restricted = 1;
 	return 0;
 }
 
@@ -625,7 +634,7 @@ static int __io_uring_register(struct io_ring_ctx *ctx, unsigned opcode,
 	if (ctx->submitter_task && ctx->submitter_task != current)
 		return -EEXIST;
 
-	if (ctx->restricted && !(ctx->flags & IORING_SETUP_R_DISABLED)) {
+	if (ctx->reg_restricted && !(ctx->flags & IORING_SETUP_R_DISABLED)) {
 		opcode = array_index_nospec(opcode, IORING_REGISTER_LAST);
 		if (!test_bit(opcode, ctx->restrictions.register_op))
 			return -EACCES;
-- 
2.51.0


