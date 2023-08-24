Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 3A686787BBC
	for <lists+io-uring@lfdr.de>; Fri, 25 Aug 2023 00:56:18 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S243975AbjHXWzp (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Thu, 24 Aug 2023 18:55:45 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:46000 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S244040AbjHXWzg (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Thu, 24 Aug 2023 18:55:36 -0400
Received: from mail-ej1-x636.google.com (mail-ej1-x636.google.com [IPv6:2a00:1450:4864:20::636])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id CD4061FDF
        for <io-uring@vger.kernel.org>; Thu, 24 Aug 2023 15:55:27 -0700 (PDT)
Received: by mail-ej1-x636.google.com with SMTP id a640c23a62f3a-9a2a4a5472dso110125166b.1
        for <io-uring@vger.kernel.org>; Thu, 24 Aug 2023 15:55:27 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20221208; t=1692917726; x=1693522526;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=YciofNNRWO0hDofU9tD/NJE19dwmkWDsnusL9jDimeY=;
        b=cKkXfWWv7Ecm+WNKx6aR2JBoXXIaqW/0aabtghpTyR7JTnZXSDM4s4z6445bFk1GK5
         GuCBP2KhoXzlqaknyu0fhRbDsoSbf0n2LbvRWcIiFgxR0sHN9iQUUgt3TiGU3wj7Qsmr
         C+9OIDlFlmofcuUDXegUPPfPzWwE5doeuAm8cc8Vq7q1Ga1Jgb8LEsASloToTQHclots
         Hjxk/4U8UVt6e6I/VxEstgVyvR7Ow5OFOyK6LbDESFmJHyVMd9zwWWXsgx9dP01y53Mt
         b9W1CWSoCxywgs18s7HMmUsYKMM7d8wsZSzWotgOjvQShSLm7+ztvbeEmFByobxdTqI1
         9TOw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20221208; t=1692917726; x=1693522526;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=YciofNNRWO0hDofU9tD/NJE19dwmkWDsnusL9jDimeY=;
        b=djUi+glBZHmzmI6Awbuneakxxam72hl2FB6HLeqab8h8feS6Cg0M+yjUpJt7N9ENdm
         HNNXUWntCxuSrq65oFmJW323UTLHCxcivr/vq35QLXAxADS9ott/nTWDAmRn3/vsUGOW
         KhK3WUFusRDXMQ1X3b0yGnPIRD7qHSdh4ryHs0Cv8LOF8yidOpPuH9pMSQTTd3aUayXp
         m9vRV9SiOTXECCW0tpWeDFqI5GJJcHxzvNh7zDS5XWBtToEAK++b6RWLbp8PYFx0RJih
         N8Ktza/oyQNxhgKlGy1oQrLh4L7Nhp1mEFyR6cAnb2Iuz/9ehEPOJZJbtQ0I0OcjlCrG
         RLAQ==
X-Gm-Message-State: AOJu0Ywso6J48tJCCVGyByjqz49t0PM9dbKfXFvaahB3IhebVPSGIP+o
        0y7FY6EvsutgHJtUz+ZFfXZYu0Q3RLg=
X-Google-Smtp-Source: AGHT+IFCT6Mns4bDEm4FqcvDSE6yhPqweI01StpmmidW6TBXe4jeQQP+mfV5W427wbRBhmaifxCwUw==
X-Received: by 2002:a17:906:748c:b0:9a1:f415:7c23 with SMTP id e12-20020a170906748c00b009a1f4157c23mr5413245ejl.26.1692917726064;
        Thu, 24 Aug 2023 15:55:26 -0700 (PDT)
Received: from 127.0.0.1localhost ([148.252.140.69])
        by smtp.gmail.com with ESMTPSA id q4-20020a170906144400b00992f81122e1sm173469ejc.21.2023.08.24.15.55.25
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 24 Aug 2023 15:55:25 -0700 (PDT)
From:   Pavel Begunkov <asml.silence@gmail.com>
To:     io-uring@vger.kernel.org
Cc:     Jens Axboe <axboe@kernel.dk>, asml.silence@gmail.com
Subject: [PATCH v2 10/15] io_uring: add option to remove SQ indirection
Date:   Thu, 24 Aug 2023 23:53:32 +0100
Message-ID: <0ffa3268a5ef61d326201ff43a233315c96312e0.1692916914.git.asml.silence@gmail.com>
X-Mailer: git-send-email 2.41.0
In-Reply-To: <cover.1692916914.git.asml.silence@gmail.com>
References: <cover.1692916914.git.asml.silence@gmail.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_FROM,
        RCVD_IN_DNSWL_BLOCKED,SPF_HELO_NONE,SPF_PASS autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org

Not many aware, but io_uring submission queue has two levels. The first
level usually appears as sq_array and stores indexes into the actual SQ.

To my knowledge, no one has ever seriously used it, nor liburing exposes
it to users. Add IORING_SETUP_NO_SQARRAY, when set we don't bother
creating and using the sq_array and SQ heads/tails will be pointing
directly into the SQ. Improves memory footprint, in term of both
allocations as well as cache usage, and also should make io_get_sqe()
less branchy in the end.

Signed-off-by: Pavel Begunkov <asml.silence@gmail.com>
---
 include/uapi/linux/io_uring.h |  5 ++++
 io_uring/io_uring.c           | 52 +++++++++++++++++++++--------------
 2 files changed, 37 insertions(+), 20 deletions(-)

diff --git a/include/uapi/linux/io_uring.h b/include/uapi/linux/io_uring.h
index 9fc7195f25df..8e61f8b7c2ce 100644
--- a/include/uapi/linux/io_uring.h
+++ b/include/uapi/linux/io_uring.h
@@ -185,6 +185,11 @@ enum {
  */
 #define IORING_SETUP_REGISTERED_FD_ONLY	(1U << 15)
 
+/*
+ * Removes indirection through the SQ index array.
+ */
+#define IORING_SETUP_NO_SQARRAY		(1U << 16)
+
 enum io_uring_op {
 	IORING_OP_NOP,
 	IORING_OP_READV,
diff --git a/io_uring/io_uring.c b/io_uring/io_uring.c
index e8321903e3f3..a6eea3938802 100644
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

