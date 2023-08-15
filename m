Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 6C2CB77D122
	for <lists+io-uring@lfdr.de>; Tue, 15 Aug 2023 19:34:05 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S238876AbjHORdc (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Tue, 15 Aug 2023 13:33:32 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:49742 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S238930AbjHORdY (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Tue, 15 Aug 2023 13:33:24 -0400
Received: from mail-ej1-x629.google.com (mail-ej1-x629.google.com [IPv6:2a00:1450:4864:20::629])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id B5F3111A
        for <io-uring@vger.kernel.org>; Tue, 15 Aug 2023 10:33:22 -0700 (PDT)
Received: by mail-ej1-x629.google.com with SMTP id a640c23a62f3a-99c3d3c3db9so762524266b.3
        for <io-uring@vger.kernel.org>; Tue, 15 Aug 2023 10:33:22 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20221208; t=1692120801; x=1692725601;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=7fqoJ9wK3l0OutAHn1RjfCmGlPQMfmmuyh2e116EeUs=;
        b=Ec20YhQrAhRGJS7/7cgefR9F8GK9b+n689fQazNHEbooyjq843yEY8w4H1CTYepNi+
         bERPSgc6lC8igefEHavXREJnnYCTJzgzlLAKzWCQoFGHJpbZ+QE7ERcY0zNiVTmS2EQu
         WT7F6+bTBod4FN/v0wd9bRU+KzNN9nPwc9tXh39ThvGNXWWMWQGUQLqDcTzIMPuM61Xl
         7yn7+isezYzGMu1I6rMHU7jRDo+/o35/Mr1LeI6L9drDrrSv0bEyYHIDtXWf+Lz5kWlO
         bPeNoFPvL0MB37BvDkkO54pC7LOlR1R+c+Mi24ECJBPbydyVEotkVTtXKdcirqobYO+e
         22Pg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20221208; t=1692120801; x=1692725601;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=7fqoJ9wK3l0OutAHn1RjfCmGlPQMfmmuyh2e116EeUs=;
        b=En8PHcy6aymDaSqqfjOm+6lpYLdJeydVvIPZxNdO0Twd7f5YRqJ9rMMKNyLpsE6IbU
         Rh9TsZXyBu+ClT29/wInDFbpHjMWCFRjH5cnX8VRJcV9o2secyXgHxHONNRI078Z+ylb
         Tr+CHXSkkU5sq5zl3HMA8b82Udi087ie9io3818LNZlljfqokTXYNkOa0Z357CcKcqYs
         +NAI3VNjQOj5EGl7d2jpqh7WmSoCg8733sgNLoOj6/YP+PZLlDAIrZ8GPDc9ZglDsV1e
         vC2uYEFg86KsUzkdCLgzEin9c/gd0iWp6el9RdTgxA0iQcDxx/scPB3v0JRUWQtG4Crp
         Ftuw==
X-Gm-Message-State: AOJu0YzQ+ysfCATBNHH10IdEAAOYDQt3RmBmBBvBw2m5zJDYXZL1rK7A
        tvKgDpOfvO93dvxSIlvJSxUDsbOV+G8=
X-Google-Smtp-Source: AGHT+IEyVpzkTgh1IlRRCQDze4BfGrhVmn2gIeyCj37LBTfB+TtUQIfqli5y51YsXbBPGgWUCt4sSw==
X-Received: by 2002:a17:906:314c:b0:99b:64d0:f6c8 with SMTP id e12-20020a170906314c00b0099b64d0f6c8mr9946378eje.50.1692120800646;
        Tue, 15 Aug 2023 10:33:20 -0700 (PDT)
Received: from 127.com ([2620:10d:c092:600::2:6d35])
        by smtp.gmail.com with ESMTPSA id kk9-20020a170907766900b0099cc36c4681sm7269878ejc.157.2023.08.15.10.33.19
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 15 Aug 2023 10:33:19 -0700 (PDT)
From:   Pavel Begunkov <asml.silence@gmail.com>
To:     io-uring@vger.kernel.org
Cc:     Jens Axboe <axboe@kernel.dk>, asml.silence@gmail.com
Subject: [PATCH 09/16] io_uring: add option to remove SQ indirection
Date:   Tue, 15 Aug 2023 18:31:38 +0100
Message-ID: <0672f81d64ffe9f91835e240d8fef7a72bd895ec.1692119257.git.asml.silence@gmail.com>
X-Mailer: git-send-email 2.41.0
In-Reply-To: <cover.1692119257.git.asml.silence@gmail.com>
References: <cover.1692119257.git.asml.silence@gmail.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_FROM,
        RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org

Not many aware, but io_uring submission queue has two levels. The first
level usually appears as sq_array and stores indexes into the actual SQ.
To my knowledge, no one has ever seriously used it, nor liburing exposes
it to users.

Add IORING_SETUP_NO_SQARRAY, when set we don't bother creating and using
the sq_array and SQ heads/tails will be pointing directly into the SQ.
Improves memory footprint, in term of both allocations as well as cache
usage, and also should make io_get_sqe() less branchy in the end.

Signed-off-by: Pavel Begunkov <asml.silence@gmail.com>
---
 include/uapi/linux/io_uring.h |  5 ++++
 io_uring/io_uring.c           | 52 +++++++++++++++++++++--------------
 2 files changed, 37 insertions(+), 20 deletions(-)

diff --git a/include/uapi/linux/io_uring.h b/include/uapi/linux/io_uring.h
index 9fc7195f25df..f669b1ed33be 100644
--- a/include/uapi/linux/io_uring.h
+++ b/include/uapi/linux/io_uring.h
@@ -185,6 +185,11 @@ enum {
  */
 #define IORING_SETUP_REGISTERED_FD_ONLY	(1U << 15)
 
+/*
+ * Disables the SQ index array.
+ */
+#define IORING_SETUP_NO_SQARRAY		(1U << 16)
+
 enum io_uring_op {
 	IORING_OP_NOP,
 	IORING_OP_READV,
diff --git a/io_uring/io_uring.c b/io_uring/io_uring.c
index 204c6a31c5d1..ac6d1687ba6c 100644
--- a/io_uring/io_uring.c
+++ b/io_uring/io_uring.c
@@ -2339,8 +2339,21 @@ static void io_commit_sqring(struct io_ring_ctx *ctx)
  */
 static bool io_get_sqe(struct io_ring_ctx *ctx, const struct io_uring_sqe **sqe)
 {
-	unsigned head, mask = ctx->sq_entries - 1;
-	unsigned sq_idx = ctx->cached_sq_head++ & mask;
+	unsigned mask = ctx->sq_entries - 1;
+	unsigned head = ctx->cached_sq_head++ & mask;
+
+	if (!(ctx->flags & IORING_SETUP_NO_SQARRAY)) {
+		head = READ_ONCE(ctx->sq_array[head]);
+		if (unlikely(head >= ctx->sq_entries)) {
+			/* drop invalid entries */
+			spin_lock(&ctx->completion_lock);
+			ctx->cq_extra--;
+			spin_unlock(&ctx->completion_lock);
+			WRITE_ONCE(ctx->rings->sq_dropped,
+				   READ_ONCE(ctx->rings->sq_dropped) + 1);
+			return false;
+		}
+	}
 
 	/*
 	 * The cached sq head (or cq tail) serves two purposes:
@@ -2350,22 +2363,12 @@ static bool io_get_sqe(struct io_ring_ctx *ctx, const struct io_uring_sqe **sqe)
 	 * 2) allows the kernel side to track the head on its own, even
 	 *    though the application is the one updating it.
 	 */
-	head = READ_ONCE(ctx->sq_array[sq_idx]);
-	if (likely(head < ctx->sq_entries)) {
-		/* double index for 128-byte SQEs, twice as long */
-		if (ctx->flags & IORING_SETUP_SQE128)
-			head <<= 1;
-		*sqe = &ctx->sq_sqes[head];
-		return true;
-	}
 
-	/* drop invalid entries */
-	spin_lock(&ctx->completion_lock);
-	ctx->cq_extra--;
-	spin_unlock(&ctx->completion_lock);
-	WRITE_ONCE(ctx->rings->sq_dropped,
-		   READ_ONCE(ctx->rings->sq_dropped) + 1);
-	return false;
+	/* double index for 128-byte SQEs, twice as long */
+	if (ctx->flags & IORING_SETUP_SQE128)
+		head <<= 1;
+	*sqe = &ctx->sq_sqes[head];
+	return true;
 }
 
 int io_submit_sqes(struct io_ring_ctx *ctx, unsigned int nr)
@@ -2734,6 +2737,12 @@ static unsigned long rings_size(struct io_ring_ctx *ctx, unsigned int sq_entries
 		return SIZE_MAX;
 #endif
 
+	if (ctx->flags & IORING_SETUP_NO_SQARRAY) {
+		if (sq_offset)
+			*sq_offset = SIZE_MAX;
+		return off;
+	}
+
 	if (sq_offset)
 		*sq_offset = off;
 
@@ -3710,7 +3719,8 @@ static __cold int io_allocate_scq_urings(struct io_ring_ctx *ctx,
 		return PTR_ERR(rings);
 
 	ctx->rings = rings;
-	ctx->sq_array = (u32 *)((char *)rings + sq_array_offset);
+	if (!(ctx->flags & IORING_SETUP_NO_SQARRAY))
+		ctx->sq_array = (u32 *)((char *)rings + sq_array_offset);
 	rings->sq_ring_mask = p->sq_entries - 1;
 	rings->cq_ring_mask = p->cq_entries - 1;
 	rings->sq_ring_entries = p->sq_entries;
@@ -3921,7 +3931,8 @@ static __cold int io_uring_create(unsigned entries, struct io_uring_params *p,
 	p->sq_off.ring_entries = offsetof(struct io_rings, sq_ring_entries);
 	p->sq_off.flags = offsetof(struct io_rings, sq_flags);
 	p->sq_off.dropped = offsetof(struct io_rings, sq_dropped);
-	p->sq_off.array = (char *)ctx->sq_array - (char *)ctx->rings;
+	if (!(ctx->flags & IORING_SETUP_NO_SQARRAY))
+		p->sq_off.array = (char *)ctx->sq_array - (char *)ctx->rings;
 	p->sq_off.resv1 = 0;
 	if (!(ctx->flags & IORING_SETUP_NO_MMAP))
 		p->sq_off.user_addr = 0;
@@ -4010,7 +4021,8 @@ static long io_uring_setup(u32 entries, struct io_uring_params __user *params)
 			IORING_SETUP_COOP_TASKRUN | IORING_SETUP_TASKRUN_FLAG |
 			IORING_SETUP_SQE128 | IORING_SETUP_CQE32 |
 			IORING_SETUP_SINGLE_ISSUER | IORING_SETUP_DEFER_TASKRUN |
-			IORING_SETUP_NO_MMAP | IORING_SETUP_REGISTERED_FD_ONLY))
+			IORING_SETUP_NO_MMAP | IORING_SETUP_REGISTERED_FD_ONLY |
+			IORING_SETUP_NO_SQARRAY))
 		return -EINVAL;
 
 	return io_uring_create(entries, &p, params);
-- 
2.41.0

