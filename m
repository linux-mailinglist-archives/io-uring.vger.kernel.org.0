Return-Path: <io-uring+bounces-7490-lists+io-uring=lfdr.de@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [147.75.199.223])
	by mail.lfdr.de (Postfix) with ESMTPS id 6B451A90790
	for <lists+io-uring@lfdr.de>; Wed, 16 Apr 2025 17:20:32 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id 754E8444E93
	for <lists+io-uring@lfdr.de>; Wed, 16 Apr 2025 15:20:32 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id DFF9A209F54;
	Wed, 16 Apr 2025 15:20:14 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="jHJx/qlt"
X-Original-To: io-uring@vger.kernel.org
Received: from mail-ej1-f41.google.com (mail-ej1-f41.google.com [209.85.218.41])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 160C7207E1D
	for <io-uring@vger.kernel.org>; Wed, 16 Apr 2025 15:20:12 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.218.41
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1744816814; cv=none; b=l8IYF+GpAl4L/SndZm8us0DItO+J0VbBQH6mjH7BGrTHcLJwDp/kLQ5MGX+q5v3GQqe4zaOHgDDdr4Tv7aVAr/SlYxoJ25Odxy2QWEkOxHYGqOEMC6qgsViDXHv7qnQ0+XEZwcqS3kDawjrES9/m5HkT9PnViGcK8M7dVZeBQWo=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1744816814; c=relaxed/simple;
	bh=f5Tc0QwUmbFxEhNDXobyGcw3Gr2zM6ZOq2IGDdQ/UAY=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=Bt3GL+8EpQPnU5fiSHeqtRIoDXhbnTStRJ80+HK8nNS5vzMgQDW2Jn56Y+5a1XXkoacmrCVIr8UFh5T6RBEPS6cq1qLPyG8sT5DMasAD/1/MnTgY1aGl2t4TEWdREzWZphE14Hi9LSQFPTOkDYbsOpotEMdoOV4J8gGEUnz86QA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=jHJx/qlt; arc=none smtp.client-ip=209.85.218.41
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Received: by mail-ej1-f41.google.com with SMTP id a640c23a62f3a-ac2ab99e16eso1402726466b.0
        for <io-uring@vger.kernel.org>; Wed, 16 Apr 2025 08:20:12 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1744816811; x=1745421611; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=zuhAwB2L+A0InFaLOio9izeR8cPsStYdkoFWrkFKFU0=;
        b=jHJx/qltJBGMWkFFLTffUNee5TNollxkSfQ0QsMZcye/CoB3iPthjbAqRuYve0EFM8
         i1xHFyfDZJEMn/tWJj/ssTU2EwvxJln1OD3Z0Y/5iUsOxhHlIZe+KoySzAY78Ff2Zjt+
         9RWzKSBnYswk1XNgMCWx4mb46d5oytnzHBCwQLmpgpgx7yHSTNNIC8b5dGdHTcN10Vsf
         4bYfXizl4GGoDxwrRN5FRdkxBnFTh9um7b+Gw+VeibJENploJ2VV3YBWgmZNY01S5+yi
         qXx0ZMzbQPGvxFGI8yMPqfVJwJP2ge0i9oz1gRq1nRm8g03KcClbp4/wKQWp7WMIHcSR
         0jqQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1744816811; x=1745421611;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=zuhAwB2L+A0InFaLOio9izeR8cPsStYdkoFWrkFKFU0=;
        b=JO8L2rt8Hnbj+GvfVPw6Gb2FMU73KkXzvcRChWNX4tMiOQ+EaA1dC4m4ylGGNL5TAi
         XdK+rzNPGfdmG9uywdCYys7IHwl+B1tMICfpm0Ej5iVUQP8iijpp0zzvHwtlYoZHVNxX
         AYW6vuMhqF9qak9R0R0++2Lxwxljj+qp9QUSVX04ZJr2rHVlJn/mSYHp4LXkW1wYD+0r
         bnDNCXoiFKiB1prjCcEQL2Lk/s3RZqfZ4GGn941E3HZq40s6Dw/n8H4CCMntYRi/AeQ7
         Je/tND7/W+kXryjFr8lBZL8lfMrCVHHWUsC9SYKBEVMkWuLsBjjdHo23fBMCy5trmhPa
         dgOg==
X-Gm-Message-State: AOJu0YwzfdfRb7kjIZbShg9jc4j2mD7BFZh/6FlciPMzn2Fm6q5CS2j9
	8nLmnDrzqL+q7D2x9hfa22VAJRnejjKMUbNw+o9sGOyJE5RPhGPbeLzjjFy/
X-Gm-Gg: ASbGncuxDdKEy+NXC9oSPWyIxA6w4Nz2ZOHqGQ/LJF/hfQGruPXhGkxaRJ49zwV1Q5c
	dFJlelN2EjU3buSLZKvKVCYCYUCMRKWAInLcabgjW8unY00xLqP85sdcbySbYrLP38t/U2DDFiJ
	wu9j2TlgolO5NkJwI0p7zmjK3yeRBACSXV+HYT3Nq+a1xZzCoNdAZtKNAGSvSAaYAYC4R+REhVz
	HcOTfNkCiH5s/Nmm2e3/S4R2u2ycirfaq+8Fmj1GfWTkE670mumlCulvw3xpgQRL5qhPHQJ2iIj
	qi1M5hy80vOX0lub5XVzUgoP
X-Google-Smtp-Source: AGHT+IHv9twwBYjt57VC7jJbmW1nMC4x/sGifqHIhCV2vgYFp7RjDTxNJqdMiqVDUqXE/V+V90JBmA==
X-Received: by 2002:a17:907:1c94:b0:ac7:e80a:7fc9 with SMTP id a640c23a62f3a-acb429c24d6mr223023066b.31.1744816810449;
        Wed, 16 Apr 2025 08:20:10 -0700 (PDT)
Received: from 127.com ([2620:10d:c092:600::1:1ccb])
        by smtp.gmail.com with ESMTPSA id a640c23a62f3a-acb3cd61f75sm144579566b.35.2025.04.16.08.20.09
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 16 Apr 2025 08:20:09 -0700 (PDT)
From: Pavel Begunkov <asml.silence@gmail.com>
To: io-uring@vger.kernel.org
Cc: asml.silence@gmail.com,
	David Wei <dw@davidwei.uk>
Subject: [PATCH 4/5] io_uring/zcrx: move zcrx region to struct io_zcrx_ifq
Date: Wed, 16 Apr 2025 16:21:19 +0100
Message-ID: <6d2bb3ce1d1fb0653a5330a67f6b9b60d069b284.1744815316.git.asml.silence@gmail.com>
X-Mailer: git-send-email 2.48.1
In-Reply-To: <cover.1744815316.git.asml.silence@gmail.com>
References: <cover.1744815316.git.asml.silence@gmail.com>
Precedence: bulk
X-Mailing-List: io-uring@vger.kernel.org
List-Id: <io-uring.vger.kernel.org>
List-Subscribe: <mailto:io-uring+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:io-uring+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

Refill queue region is a part of zcrx and should stay in struct
io_zcrx_ifq. We can't have multiple queues without it.

Note: ctx->ifq assignments are now protected by mmap_lock as it's in
the mmap region look up path.

Signed-off-by: Pavel Begunkov <asml.silence@gmail.com>
---
 include/linux/io_uring_types.h |  2 --
 io_uring/zcrx.c                | 20 ++++++++++++--------
 io_uring/zcrx.h                |  1 +
 3 files changed, 13 insertions(+), 10 deletions(-)

diff --git a/include/linux/io_uring_types.h b/include/linux/io_uring_types.h
index 3b467879bca8..06d722289fc5 100644
--- a/include/linux/io_uring_types.h
+++ b/include/linux/io_uring_types.h
@@ -448,8 +448,6 @@ struct io_ring_ctx {
 	struct io_mapped_region		ring_region;
 	/* used for optimised request parameter and wait argument passing  */
 	struct io_mapped_region		param_region;
-	/* just one zcrx per ring for now, will move to io_zcrx_ifq eventually */
-	struct io_mapped_region		zcrx_region;
 };
 
 /*
diff --git a/io_uring/zcrx.c b/io_uring/zcrx.c
index 652daff0eb8d..d56665fd103d 100644
--- a/io_uring/zcrx.c
+++ b/io_uring/zcrx.c
@@ -160,12 +160,11 @@ static int io_allocate_rbuf_ring(struct io_zcrx_ifq *ifq,
 	if (size > rd->size)
 		return -EINVAL;
 
-	ret = io_create_region_mmap_safe(ifq->ctx, &ifq->ctx->zcrx_region, rd,
-					 IORING_MAP_OFF_ZCRX_REGION);
+	ret = io_create_region(ifq->ctx, &ifq->region, rd, IORING_MAP_OFF_ZCRX_REGION);
 	if (ret < 0)
 		return ret;
 
-	ptr = io_region_get_ptr(&ifq->ctx->zcrx_region);
+	ptr = io_region_get_ptr(&ifq->region);
 	ifq->rq_ring = (struct io_uring *)ptr;
 	ifq->rqes = (struct io_uring_zcrx_rqe *)(ptr + off);
 	return 0;
@@ -173,7 +172,10 @@ static int io_allocate_rbuf_ring(struct io_zcrx_ifq *ifq,
 
 static void io_free_rbuf_ring(struct io_zcrx_ifq *ifq)
 {
-	io_free_region(ifq->ctx, &ifq->ctx->zcrx_region);
+	if (WARN_ON_ONCE(ifq->ctx->ifq))
+		return;
+
+	io_free_region(ifq->ctx, &ifq->region);
 	ifq->rq_ring = NULL;
 	ifq->rqes = NULL;
 }
@@ -334,9 +336,9 @@ struct io_mapped_region *io_zcrx_get_region(struct io_ring_ctx *ctx,
 {
 	lockdep_assert_held(&ctx->mmap_lock);
 
-	if (id != 0)
+	if (id != 0 || !ctx->ifq)
 		return NULL;
-	return &ctx->zcrx_region;
+	return &ctx->ifq->region;
 }
 
 int io_register_zcrx_ifq(struct io_ring_ctx *ctx,
@@ -428,7 +430,8 @@ int io_register_zcrx_ifq(struct io_ring_ctx *ctx,
 		ret = -EFAULT;
 		goto err;
 	}
-	ctx->ifq = ifq;
+	scoped_guard(mutex, &ctx->mmap_lock)
+		ctx->ifq = ifq;
 	return 0;
 err:
 	io_zcrx_ifq_free(ifq);
@@ -444,7 +447,8 @@ void io_unregister_zcrx_ifqs(struct io_ring_ctx *ctx)
 	if (!ifq)
 		return;
 
-	ctx->ifq = NULL;
+	scoped_guard(mutex, &ctx->mmap_lock)
+		ctx->ifq = NULL;
 	io_zcrx_ifq_free(ifq);
 }
 
diff --git a/io_uring/zcrx.h b/io_uring/zcrx.h
index a183125e69f0..e58191d56249 100644
--- a/io_uring/zcrx.h
+++ b/io_uring/zcrx.h
@@ -38,6 +38,7 @@ struct io_zcrx_ifq {
 	struct net_device		*netdev;
 	netdevice_tracker		netdev_tracker;
 	spinlock_t			lock;
+	struct io_mapped_region		region;
 };
 
 #if defined(CONFIG_IO_URING_ZCRX)
-- 
2.48.1


