Return-Path: <io-uring+bounces-10352-lists+io-uring=lfdr.de@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [147.75.80.249])
	by mail.lfdr.de (Postfix) with ESMTPS id AA39BC2E725
	for <lists+io-uring@lfdr.de>; Tue, 04 Nov 2025 00:43:00 +0100 (CET)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id 1CD70189B1F8
	for <lists+io-uring@lfdr.de>; Mon,  3 Nov 2025 23:42:57 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id E6ACA31B80C;
	Mon,  3 Nov 2025 23:41:32 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=davidwei-uk.20230601.gappssmtp.com header.i=@davidwei-uk.20230601.gappssmtp.com header.b="RQbQZPQZ"
X-Original-To: io-uring@vger.kernel.org
Received: from mail-oa1-f50.google.com (mail-oa1-f50.google.com [209.85.160.50])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3CC2E319872
	for <io-uring@vger.kernel.org>; Mon,  3 Nov 2025 23:41:31 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.160.50
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1762213292; cv=none; b=h2KsDv0osOqdRLmG3sQ7t4cz4ZnB0zwO7dgIjSLolAacJdTyqD6Pbq6QgSEsZ1bfUyBHvZBQcDcDuFVNr/NGZvHwekizuOt2cZz7cWvWIJKZ+avgCyZ1YiWjyqJ06BoM5zJ7WqtjJdT5I5u05CFsb2UuisPZhOTM8edAnJ7wO+8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1762213292; c=relaxed/simple;
	bh=1OLS/0yvwaf5d+sHAX8W0GDbPIQ9bnPvBEe4g9Sc5QY=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=gy+9XM7ImT35ycJkYZJUfAfdBSOSqFTqhauEMKoExOE/+bUAGUi+LsH3Z9bJAybMbQj3VjDcORz/QCTmjIgKsKJVa0Zp5q+C4W+yP6sMRp5AokRbdm9K09Ji6kl/Rh3Pd9uNsvqAFdKB2cBKYa6r5RNZdZtqdXz3mPNf/g4TOYY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=davidwei.uk; spf=none smtp.mailfrom=davidwei.uk; dkim=pass (2048-bit key) header.d=davidwei-uk.20230601.gappssmtp.com header.i=@davidwei-uk.20230601.gappssmtp.com header.b=RQbQZPQZ; arc=none smtp.client-ip=209.85.160.50
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=davidwei.uk
Authentication-Results: smtp.subspace.kernel.org; spf=none smtp.mailfrom=davidwei.uk
Received: by mail-oa1-f50.google.com with SMTP id 586e51a60fabf-3d238ab4d9fso3934650fac.1
        for <io-uring@vger.kernel.org>; Mon, 03 Nov 2025 15:41:31 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=davidwei-uk.20230601.gappssmtp.com; s=20230601; t=1762213290; x=1762818090; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=KYugGlUm1QG3RSCIiMKw62nFrw0/PRs6ahB4+c7pzJ4=;
        b=RQbQZPQZoZPsDHX1T8tixfwZIjELeUhrws0Un+J2C2RwObO2XiTiXJoW3idbZuaVPR
         nuBlBoOWRTbEc+J9p7OB0NU/bWhLvkYnEOjrIY+PWsv3EF0QvyOC5X6QWW3GHBegV8mu
         iBooffiqyvw15n2Sv5IcxuNBartVP/6YkHjqMQPxhXnOWLcfDqlFOZioSGeazWY64Z0s
         d8Tgi4CEGlptgc/eZlx867Z5qv7SOy0qmJVXjNDMKILe5M76zc5TpVzrhEM2WMobgOWe
         kLG1lKkL3F2m6ThU4A+V5mBOJW/LMxAObDOrxLVbaNR1zKtnLdoUnKvYn0U5Zer81QKC
         W1cw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1762213290; x=1762818090;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=KYugGlUm1QG3RSCIiMKw62nFrw0/PRs6ahB4+c7pzJ4=;
        b=XoBDVJsSGSOw23HD7tcJ4u1XpComoGa9ZtUVqdZRgZVHKlAnyTXBygkYwxD1vNdJVH
         Bso2FYdpOzfMNQqRDtk8hEJYpMygghegxHcJkUXdOR+PjsJVZjUJCym+RBUaq7YQxGAE
         tcbpG3D5zkZ9bIyEMUIuQLhiWUvhiaj32QbmGxOcqYkl5fidGlwaeOI1Vezg2/3d7hJo
         ckdukLgNPUtU+OVpGIvy0GxQVAvO7Xqco2bp9Yk9oex3QQIzG0PHziwBFgdLpoPeiK29
         URXEsZpRDsPfyelnNW5C0msUH36eByIgX+W/m6xd96uRcqOL2UogthJpEtk8KyeufYi7
         qgxQ==
X-Gm-Message-State: AOJu0Yz4IghA6gvhux5NZU+wbKux+DjqgoVpIeJzzjEHczW/qElY1AWa
	smywlrU3BYuWEGOpwqSv882JI93sdKPzeRv8pBk9B4gXvO+zeqpDMSWrccnKbi3yxYXeb9XteiR
	VoGzh
X-Gm-Gg: ASbGncvYFiQBNNj+N5EhbVl7z0fRuXvEkW3PnlFLSxUeon1IckXW10i8+IB9oKMCVSd
	eOSJPVZJVp3OvHHCwUBQFtQedlh/6NGuty5+2h/4BpuEQWquQ1UDKc2U+cvrcBrmlEbkyH4vs+F
	SiJwUd4uoEeFbho8LtwQgOSM4lvU63KDlEnJE7yWG4lj1tCAUlQqxx7xhGld8oTulCqObCdQ2vH
	D6rru/3+MBKyOCzW1Bgr9A4Wd8a0gO5Nddv6KwcsTMSxH1pH3s0CzZHkxUTbbb21wjPeJAA6p3h
	Fd2LQoY2IksCQxzsVF6p0NM1iKUhvtq1k6NwSqcn9Lr9hxS5cRgcmT7r0xj8dRwA/uk5mkvJ5fy
	bZq2X1YMGCrFcVA6JgB0CsxmijfJjOUb25JiWGJtgyciAeOxy2a/fBPruUkg3u8j4WXNc/kG9pD
	CSqvjiB9C0U5SE5NRFBMGHrTbm5r1U
X-Google-Smtp-Source: AGHT+IEW3k8jc4pLNnI2/FbgrhuOA/EQYwUPg8LnkTE9oSPdA1nn/Rt+yO/8D/ZQQiWlwM406NUciw==
X-Received: by 2002:a05:6870:3411:b0:3d1:a15c:f06a with SMTP id 586e51a60fabf-3e037344ea7mr592868fac.0.1762213290284;
        Mon, 03 Nov 2025 15:41:30 -0800 (PST)
Received: from localhost ([2a03:2880:12ff:7::])
        by smtp.gmail.com with ESMTPSA id 586e51a60fabf-3dff5213959sm542166fac.10.2025.11.03.15.41.29
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 03 Nov 2025 15:41:29 -0800 (PST)
From: David Wei <dw@davidwei.uk>
To: io-uring@vger.kernel.org,
	netdev@vger.kernel.org
Cc: Jens Axboe <axboe@kernel.dk>,
	Pavel Begunkov <asml.silence@gmail.com>
Subject: [PATCH v4 09/12] io_uring/zcrx: reverse ifq refcount
Date: Mon,  3 Nov 2025 15:41:07 -0800
Message-ID: <20251103234110.127790-10-dw@davidwei.uk>
X-Mailer: git-send-email 2.47.3
In-Reply-To: <20251103234110.127790-1-dw@davidwei.uk>
References: <20251103234110.127790-1-dw@davidwei.uk>
Precedence: bulk
X-Mailing-List: io-uring@vger.kernel.org
List-Id: <io-uring.vger.kernel.org>
List-Subscribe: <mailto:io-uring+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:io-uring+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

Add two refcounts to struct io_zcrx_ifq to reverse the refcounting
relationship i.e. rings now reference ifqs instead. As a result of this,
remove ctx->refs that an ifq holds on a ring via the page pool memory
provider.

The first ref is ifq->refs, held by internal users of an ifq, namely
rings and the page pool memory provider associated with an ifq. This is
needed to keep the ifq around until the page pool is destroyed.

The second ref is ifq->user_refs, held by userspace facing users like
rings. For now, only the ring that created the ifq will have a ref, but
with ifq sharing added, this will include multiple rings.

ifq->refs will be 1 larger than ifq->user_refs, with the extra ref held
by the page pool. Once ifq->user_refs falls to 0, the ifq is cleaned up
including destroying the page pool. Once the page pool is destroyed,
ifq->refs will fall to 0 and free the ifq.

Since ifqs now no longer hold refs to ring ctx, there isn't a need to
split the cleanup of ifqs into two: io_shutdown_zcrx_ifqs() in
io_ring_exit_work() while waiting for ctx->refs to drop to 0, and
io_unregister_zcrx_ifqs() after. Remove io_shutdown_zcrx_ifqs().

Signed-off-by: David Wei <dw@davidwei.uk>
Co-developed-by: Pavel Begunkov <asml.silence@gmail.com>
Signed-off-by: Pavel Begunkov <asml.silence@gmail.com>
---
 io_uring/io_uring.c |  5 -----
 io_uring/zcrx.c     | 36 +++++++++++++++++-------------------
 io_uring/zcrx.h     |  8 +++-----
 3 files changed, 20 insertions(+), 29 deletions(-)

diff --git a/io_uring/io_uring.c b/io_uring/io_uring.c
index 7d42748774f8..8af5efda9c11 100644
--- a/io_uring/io_uring.c
+++ b/io_uring/io_uring.c
@@ -3042,11 +3042,6 @@ static __cold void io_ring_exit_work(struct work_struct *work)
 			io_cqring_overflow_kill(ctx);
 			mutex_unlock(&ctx->uring_lock);
 		}
-		if (!xa_empty(&ctx->zcrx_ctxs)) {
-			mutex_lock(&ctx->uring_lock);
-			io_shutdown_zcrx_ifqs(ctx);
-			mutex_unlock(&ctx->uring_lock);
-		}
 
 		if (ctx->flags & IORING_SETUP_DEFER_TASKRUN)
 			io_move_task_work_from_local(ctx);
diff --git a/io_uring/zcrx.c b/io_uring/zcrx.c
index bb5cc6ec5b9b..00498e3dcbd3 100644
--- a/io_uring/zcrx.c
+++ b/io_uring/zcrx.c
@@ -479,9 +479,10 @@ static struct io_zcrx_ifq *io_zcrx_ifq_alloc(struct io_ring_ctx *ctx)
 		return NULL;
 
 	ifq->if_rxq = -1;
-	ifq->ctx = ctx;
 	spin_lock_init(&ifq->rq_lock);
 	mutex_init(&ifq->pp_lock);
+	refcount_set(&ifq->refs, 1);
+	refcount_set(&ifq->user_refs, 1);
 	return ifq;
 }
 
@@ -537,6 +538,12 @@ static void io_zcrx_ifq_free(struct io_zcrx_ifq *ifq)
 	kfree(ifq);
 }
 
+static void io_put_zcrx_ifq(struct io_zcrx_ifq *ifq)
+{
+	if (refcount_dec_and_test(&ifq->refs))
+		io_zcrx_ifq_free(ifq);
+}
+
 struct io_mapped_region *io_zcrx_get_region(struct io_ring_ctx *ctx,
 					    unsigned int id)
 {
@@ -611,6 +618,7 @@ int io_register_zcrx_ifq(struct io_ring_ctx *ctx,
 	ifq = io_zcrx_ifq_alloc(ctx);
 	if (!ifq)
 		return -ENOMEM;
+
 	if (ctx->user) {
 		get_uid(ctx->user);
 		ifq->user = ctx->user;
@@ -733,19 +741,6 @@ static void io_zcrx_scrub(struct io_zcrx_ifq *ifq)
 	}
 }
 
-void io_shutdown_zcrx_ifqs(struct io_ring_ctx *ctx)
-{
-	struct io_zcrx_ifq *ifq;
-	unsigned long index;
-
-	lockdep_assert_held(&ctx->uring_lock);
-
-	xa_for_each(&ctx->zcrx_ctxs, index, ifq) {
-		io_zcrx_scrub(ifq);
-		io_close_queue(ifq);
-	}
-}
-
 void io_unregister_zcrx_ifqs(struct io_ring_ctx *ctx)
 {
 	struct io_zcrx_ifq *ifq;
@@ -762,7 +757,12 @@ void io_unregister_zcrx_ifqs(struct io_ring_ctx *ctx)
 		}
 		if (!ifq)
 			break;
-		io_zcrx_ifq_free(ifq);
+
+		if (refcount_dec_and_test(&ifq->user_refs)) {
+			io_close_queue(ifq);
+			io_zcrx_scrub(ifq);
+		}
+		io_put_zcrx_ifq(ifq);
 	}
 
 	xa_destroy(&ctx->zcrx_ctxs);
@@ -913,15 +913,13 @@ static int io_pp_zc_init(struct page_pool *pp)
 	if (ret)
 		return ret;
 
-	percpu_ref_get(&ifq->ctx->refs);
+	refcount_inc(&ifq->refs);
 	return 0;
 }
 
 static void io_pp_zc_destroy(struct page_pool *pp)
 {
-	struct io_zcrx_ifq *ifq = io_pp_to_ifq(pp);
-
-	percpu_ref_put(&ifq->ctx->refs);
+	io_put_zcrx_ifq(io_pp_to_ifq(pp));
 }
 
 static int io_pp_nl_fill(void *mp_priv, struct sk_buff *rsp,
diff --git a/io_uring/zcrx.h b/io_uring/zcrx.h
index 2396436643e5..9014a1fd0f61 100644
--- a/io_uring/zcrx.h
+++ b/io_uring/zcrx.h
@@ -39,7 +39,6 @@ struct io_zcrx_area {
 };
 
 struct io_zcrx_ifq {
-	struct io_ring_ctx		*ctx;
 	struct io_zcrx_area		*area;
 	unsigned			niov_shift;
 	struct user_struct		*user;
@@ -55,6 +54,9 @@ struct io_zcrx_ifq {
 	struct device			*dev;
 	struct net_device		*netdev;
 	netdevice_tracker		netdev_tracker;
+	refcount_t			refs;
+	/* counts userspace facing users like io_uring */
+	refcount_t			user_refs;
 
 	/*
 	 * Page pool and net configuration lock, can be taken deeper in the
@@ -69,7 +71,6 @@ int io_zcrx_ctrl(struct io_ring_ctx *ctx, void __user *arg, unsigned nr_arg);
 int io_register_zcrx_ifq(struct io_ring_ctx *ctx,
 			 struct io_uring_zcrx_ifq_reg __user *arg);
 void io_unregister_zcrx_ifqs(struct io_ring_ctx *ctx);
-void io_shutdown_zcrx_ifqs(struct io_ring_ctx *ctx);
 int io_zcrx_recv(struct io_kiocb *req, struct io_zcrx_ifq *ifq,
 		 struct socket *sock, unsigned int flags,
 		 unsigned issue_flags, unsigned int *len);
@@ -84,9 +85,6 @@ static inline int io_register_zcrx_ifq(struct io_ring_ctx *ctx,
 static inline void io_unregister_zcrx_ifqs(struct io_ring_ctx *ctx)
 {
 }
-static inline void io_shutdown_zcrx_ifqs(struct io_ring_ctx *ctx)
-{
-}
 static inline int io_zcrx_recv(struct io_kiocb *req, struct io_zcrx_ifq *ifq,
 			       struct socket *sock, unsigned int flags,
 			       unsigned issue_flags, unsigned int *len)
-- 
2.47.3


