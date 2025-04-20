Return-Path: <io-uring+bounces-7578-lists+io-uring=lfdr.de@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from sy.mirrors.kernel.org (sy.mirrors.kernel.org [147.75.48.161])
	by mail.lfdr.de (Postfix) with ESMTPS id 5A994A94759
	for <lists+io-uring@lfdr.de>; Sun, 20 Apr 2025 11:30:34 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sy.mirrors.kernel.org (Postfix) with ESMTPS id 55F9F7AA1CE
	for <lists+io-uring@lfdr.de>; Sun, 20 Apr 2025 09:29:23 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id B7E6C18E76B;
	Sun, 20 Apr 2025 09:30:27 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="NrY2Q7BC"
X-Original-To: io-uring@vger.kernel.org
Received: from mail-wr1-f42.google.com (mail-wr1-f42.google.com [209.85.221.42])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B6A2A15F330
	for <io-uring@vger.kernel.org>; Sun, 20 Apr 2025 09:30:25 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.221.42
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1745141427; cv=none; b=ELHXb9ju13Fq9wlpZ5SJEDJlQujBpHP3GDN8V2WP6UEWS5RQZVRHAUOW1vIpww2B6sB49v5NMjED1BW0cgxgvKCupxBTr1um8Rdu/iQEU1s8C3WIaBzY9umTUmxUAh9UL9kj1nCDwyuR8Q2lWsvLBFkMJiwE7/mao7djhGLUwzs=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1745141427; c=relaxed/simple;
	bh=UV6zfvKc3LAGhksGRwyyopDUzCczCn5NfsTHtwBYYEg=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=h14NWfTHCYHnJX2bKuW7a/ZF4/5/KLJIxbr6dT0YYtaVXhzVRqBEqsWE8K/E79cUINRLQExwUgMunwN0bA5qPsGKaZHfiAtLL+ygyFHEUvf+WwwXHuyiSKylGsSocYYTxjvFqed4GNLrOwjRbPrxwfc3nP8miR0B0bsHk+2QH80=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=NrY2Q7BC; arc=none smtp.client-ip=209.85.221.42
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Received: by mail-wr1-f42.google.com with SMTP id ffacd0b85a97d-39c1efbefc6so1826295f8f.1
        for <io-uring@vger.kernel.org>; Sun, 20 Apr 2025 02:30:25 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1745141423; x=1745746223; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=uLZ12wWXjl9tGTLw3o/B/UqWs1SdR2U4FWGtcpdTgu0=;
        b=NrY2Q7BCUqhiCgoKOSMOaQzR5gMhBgcXfWwzeEoKyzTGRYiF3a0vmSIkvn06kjRepH
         Se+DHQr1kSNqWUU5oU0evvWZsVRIoRTgUaXmeg+/7SKS+1HX6/LtC6JiBefN/NAR5pni
         jY/Dk9tRqZSANqlkfqbCYwe/0jF/uEaIlOL6FE6/oAQibIVhb7p1pqKxAAm5NYoIzZsz
         +xF85XGmRf9ieiHooJXhv2xB3X+nX+YdHBiCrP5/SizhXjvMslbALsa6XWsRk74z96Mc
         QgVKjD5j4wjp1mfgsxcw4M9r3+ra9GBtiEadf+8AsIftOMFEawwFTxx2ZNXE/IDItzR/
         mksw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1745141423; x=1745746223;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=uLZ12wWXjl9tGTLw3o/B/UqWs1SdR2U4FWGtcpdTgu0=;
        b=X3LlhmVydsIF8WmwCIvkuKgYnVA+6X/Sw16IjqPEeR8xfpFnBLdXftoK59QQCte5j0
         CfHVCVEdTF4Wwvk7IiC6M0G7rpLf6KEw81fqrRwM94nrhxM1rDU06JqTdq4ADv0Wi1hb
         9jXVhYiLifTt4bHH3xdfnCW8ZplJccdc/Nc6qS0HjZ7b8/Bi5xcMNXD2IjJj4R16/xU/
         po6jEIep8LnqMYa+LuNh6LYnEI7GiQCPZaaPpJMK0IgNhOEn6pG3bsQFooBiL+KAFuRR
         nukyLVdYy2blqbUKWPeUVB6DNwX0Z6xw3gKOnagoKVrZikwOy+ThRdVwgcsiCVWFvtZm
         Q8BQ==
X-Gm-Message-State: AOJu0YwdtWV8oN4pmERMJbR4qgASFBYvBokVpkRqEu030AWyYZGUrY/l
	nB2AOQLJsq4QK4LWCzYKzzsDmsJ1GkAKfFGVCO9taGb6poZRViYXy7pPTQ==
X-Gm-Gg: ASbGncsk3CfUUQACrX4VjwDbDijMK0v94yplAieMzJHi8H9hEH8dj9C9VxZPjw5EWcV
	BXlpBm+kaibbX9Syv445HVMGcUg3mNvxJ4rkBRTW4hHdU2S7t/PMy5F2Xua0VGDjXyCryxsqcwp
	DP3anJ2bMv/ilOI6vAV4xrLsLBOOp3Sym/VEZaOytmnmJ+Bky926rRo6b9WpwD3hbnZPH1B1WN9
	MWYKrGCeEp5BO6XdUQxmjDrgqEcpi8N5zzs+NawPyufq7/WUTgoh0t2fun/mrzqtEUjiSg5GwyK
	nGJXlXkyXBL+cnpMWEqMiHVEwsd02/DpMxxisV1/Ue2gbJcIP+JX3g==
X-Google-Smtp-Source: AGHT+IEgXlC7GYHYpKCSAX5NXiGGY/hcpVWtxvcNIiC5YrelceHads0gW2TRWMhHJ1BC17vcTsKlWw==
X-Received: by 2002:a5d:5f49:0:b0:39e:cbe3:881 with SMTP id ffacd0b85a97d-39efba246e0mr5979275f8f.12.1745141423374;
        Sun, 20 Apr 2025 02:30:23 -0700 (PDT)
Received: from 127.0.0.1localhost ([148.252.128.74])
        by smtp.gmail.com with ESMTPSA id 5b1f17b1804b1-4406d5ccd43sm91188675e9.26.2025.04.20.02.30.22
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sun, 20 Apr 2025 02:30:22 -0700 (PDT)
From: Pavel Begunkov <asml.silence@gmail.com>
To: io-uring@vger.kernel.org
Cc: asml.silence@gmail.com,
	David Wei <dw@davidwei.uk>
Subject: [PATCH v2 6/6] io_uring/zcrx: add support for multiple ifqs
Date: Sun, 20 Apr 2025 10:31:20 +0100
Message-ID: <668b03bee03b5216564482edcfefbc2ee337dd30.1745141261.git.asml.silence@gmail.com>
X-Mailer: git-send-email 2.48.1
In-Reply-To: <cover.1745141261.git.asml.silence@gmail.com>
References: <cover.1745141261.git.asml.silence@gmail.com>
Precedence: bulk
X-Mailing-List: io-uring@vger.kernel.org
List-Id: <io-uring.vger.kernel.org>
List-Subscribe: <mailto:io-uring+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:io-uring+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

Allow the user to register multiple ifqs / zcrx contexts. With that we
can use multiple interfaces / interface queues in a single io_uring
instance.

Signed-off-by: Pavel Begunkov <asml.silence@gmail.com>
---
 include/linux/io_uring_types.h |  5 +--
 io_uring/io_uring.c            |  3 +-
 io_uring/net.c                 |  5 +--
 io_uring/zcrx.c                | 72 +++++++++++++++++++++++-----------
 4 files changed, 55 insertions(+), 30 deletions(-)

diff --git a/include/linux/io_uring_types.h b/include/linux/io_uring_types.h
index 06d722289fc5..7e23e993280e 100644
--- a/include/linux/io_uring_types.h
+++ b/include/linux/io_uring_types.h
@@ -40,8 +40,6 @@ enum io_uring_cmd_flags {
 	IO_URING_F_TASK_DEAD		= (1 << 13),
 };
 
-struct io_zcrx_ifq;
-
 struct io_wq_work_node {
 	struct io_wq_work_node *next;
 };
@@ -394,7 +392,8 @@ struct io_ring_ctx {
 	struct wait_queue_head		poll_wq;
 	struct io_restriction		restrictions;
 
-	struct io_zcrx_ifq		*ifq;
+	/* Stores zcrx object pointers of type struct io_zcrx_ifq */
+	struct xarray			zcrx_ctxs;
 
 	u32			pers_next;
 	struct xarray		personalities;
diff --git a/io_uring/io_uring.c b/io_uring/io_uring.c
index 61514b14ee3f..ed85c9374f6e 100644
--- a/io_uring/io_uring.c
+++ b/io_uring/io_uring.c
@@ -359,6 +359,7 @@ static __cold struct io_ring_ctx *io_ring_ctx_alloc(struct io_uring_params *p)
 	INIT_LIST_HEAD(&ctx->tctx_list);
 	ctx->submit_state.free_list.next = NULL;
 	INIT_HLIST_HEAD(&ctx->waitid_list);
+	xa_init_flags(&ctx->zcrx_ctxs, XA_FLAGS_ALLOC);
 #ifdef CONFIG_FUTEX
 	INIT_HLIST_HEAD(&ctx->futex_list);
 #endif
@@ -2888,7 +2889,7 @@ static __cold void io_ring_exit_work(struct work_struct *work)
 			io_cqring_overflow_kill(ctx);
 			mutex_unlock(&ctx->uring_lock);
 		}
-		if (ctx->ifq) {
+		if (!xa_empty(&ctx->zcrx_ctxs)) {
 			mutex_lock(&ctx->uring_lock);
 			io_shutdown_zcrx_ifqs(ctx);
 			mutex_unlock(&ctx->uring_lock);
diff --git a/io_uring/net.c b/io_uring/net.c
index 782f8e76c5c7..b3a643675ce8 100644
--- a/io_uring/net.c
+++ b/io_uring/net.c
@@ -1189,11 +1189,10 @@ int io_recvzc_prep(struct io_kiocb *req, const struct io_uring_sqe *sqe)
 		return -EINVAL;
 
 	ifq_idx = READ_ONCE(sqe->zcrx_ifq_idx);
-	if (ifq_idx != 0)
-		return -EINVAL;
-	zc->ifq = req->ctx->ifq;
+	zc->ifq = xa_load(&req->ctx->zcrx_ctxs, ifq_idx);
 	if (!zc->ifq)
 		return -EINVAL;
+
 	zc->len = READ_ONCE(sqe->len);
 	zc->flags = READ_ONCE(sqe->ioprio);
 	zc->msg_flags = READ_ONCE(sqe->msg_flags);
diff --git a/io_uring/zcrx.c b/io_uring/zcrx.c
index d56665fd103d..a47acf75b8d6 100644
--- a/io_uring/zcrx.c
+++ b/io_uring/zcrx.c
@@ -149,8 +149,10 @@ static void io_zcrx_get_niov_uref(struct net_iov *niov)
 
 static int io_allocate_rbuf_ring(struct io_zcrx_ifq *ifq,
 				 struct io_uring_zcrx_ifq_reg *reg,
-				 struct io_uring_region_desc *rd)
+				 struct io_uring_region_desc *rd,
+				 u32 id)
 {
+	u64 mmap_offset;
 	size_t off, size;
 	void *ptr;
 	int ret;
@@ -160,7 +162,10 @@ static int io_allocate_rbuf_ring(struct io_zcrx_ifq *ifq,
 	if (size > rd->size)
 		return -EINVAL;
 
-	ret = io_create_region(ifq->ctx, &ifq->region, rd, IORING_MAP_OFF_ZCRX_REGION);
+	mmap_offset = IORING_MAP_OFF_ZCRX_REGION;
+	mmap_offset += id << IORING_OFF_PBUF_SHIFT;
+
+	ret = io_create_region(ifq->ctx, &ifq->region, rd, mmap_offset);
 	if (ret < 0)
 		return ret;
 
@@ -172,9 +177,6 @@ static int io_allocate_rbuf_ring(struct io_zcrx_ifq *ifq,
 
 static void io_free_rbuf_ring(struct io_zcrx_ifq *ifq)
 {
-	if (WARN_ON_ONCE(ifq->ctx->ifq))
-		return;
-
 	io_free_region(ifq->ctx, &ifq->region);
 	ifq->rq_ring = NULL;
 	ifq->rqes = NULL;
@@ -334,11 +336,11 @@ static void io_zcrx_ifq_free(struct io_zcrx_ifq *ifq)
 struct io_mapped_region *io_zcrx_get_region(struct io_ring_ctx *ctx,
 					    unsigned int id)
 {
+	struct io_zcrx_ifq *ifq = xa_load(&ctx->zcrx_ctxs, id);
+
 	lockdep_assert_held(&ctx->mmap_lock);
 
-	if (id != 0 || !ctx->ifq)
-		return NULL;
-	return &ctx->ifq->region;
+	return ifq ? &ifq->region : NULL;
 }
 
 int io_register_zcrx_ifq(struct io_ring_ctx *ctx,
@@ -350,6 +352,7 @@ int io_register_zcrx_ifq(struct io_ring_ctx *ctx,
 	struct io_uring_region_desc rd;
 	struct io_zcrx_ifq *ifq;
 	int ret;
+	u32 id;
 
 	/*
 	 * 1. Interface queue allocation.
@@ -362,8 +365,6 @@ int io_register_zcrx_ifq(struct io_ring_ctx *ctx,
 	if (!(ctx->flags & IORING_SETUP_DEFER_TASKRUN &&
 	      ctx->flags & IORING_SETUP_CQE32))
 		return -EINVAL;
-	if (ctx->ifq)
-		return -EBUSY;
 	if (copy_from_user(&reg, arg, sizeof(reg)))
 		return -EFAULT;
 	if (copy_from_user(&rd, u64_to_user_ptr(reg.region_ptr), sizeof(rd)))
@@ -387,7 +388,14 @@ int io_register_zcrx_ifq(struct io_ring_ctx *ctx,
 	if (!ifq)
 		return -ENOMEM;
 
-	ret = io_allocate_rbuf_ring(ifq, &reg, &rd);
+	scoped_guard(mutex, &ctx->mmap_lock) {
+		/* preallocate id */
+		ret = xa_alloc(&ctx->zcrx_ctxs, &id, NULL, xa_limit_31b, GFP_KERNEL);
+		if (ret)
+			goto err;
+	}
+
+	ret = io_allocate_rbuf_ring(ifq, &reg, &rd, id);
 	if (ret)
 		goto err;
 
@@ -423,6 +431,14 @@ int io_register_zcrx_ifq(struct io_ring_ctx *ctx,
 	reg.offsets.rqes = sizeof(struct io_uring);
 	reg.offsets.head = offsetof(struct io_uring, head);
 	reg.offsets.tail = offsetof(struct io_uring, tail);
+	reg.zcrx_id = id;
+
+	scoped_guard(mutex, &ctx->mmap_lock) {
+		/* publish ifq */
+		ret = -ENOMEM;
+		if (xa_store(&ctx->zcrx_ctxs, id, ifq, GFP_KERNEL))
+			goto err;
+	}
 
 	if (copy_to_user(arg, &reg, sizeof(reg)) ||
 	    copy_to_user(u64_to_user_ptr(reg.region_ptr), &rd, sizeof(rd)) ||
@@ -430,26 +446,33 @@ int io_register_zcrx_ifq(struct io_ring_ctx *ctx,
 		ret = -EFAULT;
 		goto err;
 	}
-	scoped_guard(mutex, &ctx->mmap_lock)
-		ctx->ifq = ifq;
 	return 0;
 err:
+	scoped_guard(mutex, &ctx->mmap_lock)
+		xa_erase(&ctx->zcrx_ctxs, id);
 	io_zcrx_ifq_free(ifq);
 	return ret;
 }
 
 void io_unregister_zcrx_ifqs(struct io_ring_ctx *ctx)
 {
-	struct io_zcrx_ifq *ifq = ctx->ifq;
+	struct io_zcrx_ifq *ifq;
+	unsigned long id;
 
 	lockdep_assert_held(&ctx->uring_lock);
 
-	if (!ifq)
-		return;
+	while (1) {
+		scoped_guard(mutex, &ctx->mmap_lock) {
+			ifq = xa_find(&ctx->zcrx_ctxs, &id, ULONG_MAX, XA_PRESENT);
+			if (ifq)
+				xa_erase(&ctx->zcrx_ctxs, id);
+		}
+		if (!ifq)
+			break;
+		io_zcrx_ifq_free(ifq);
+	}
 
-	scoped_guard(mutex, &ctx->mmap_lock)
-		ctx->ifq = NULL;
-	io_zcrx_ifq_free(ifq);
+	xa_destroy(&ctx->zcrx_ctxs);
 }
 
 static struct net_iov *__io_zcrx_get_free_niov(struct io_zcrx_area *area)
@@ -506,12 +529,15 @@ static void io_zcrx_scrub(struct io_zcrx_ifq *ifq)
 
 void io_shutdown_zcrx_ifqs(struct io_ring_ctx *ctx)
 {
+	struct io_zcrx_ifq *ifq;
+	unsigned long index;
+
 	lockdep_assert_held(&ctx->uring_lock);
 
-	if (!ctx->ifq)
-		return;
-	io_zcrx_scrub(ctx->ifq);
-	io_close_queue(ctx->ifq);
+	xa_for_each(&ctx->zcrx_ctxs, index, ifq) {
+		io_zcrx_scrub(ifq);
+		io_close_queue(ifq);
+	}
 }
 
 static inline u32 io_zcrx_rqring_entries(struct io_zcrx_ifq *ifq)
-- 
2.48.1


