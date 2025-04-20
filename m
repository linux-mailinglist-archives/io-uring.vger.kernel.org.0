Return-Path: <io-uring+bounces-7577-lists+io-uring=lfdr.de@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [147.75.199.223])
	by mail.lfdr.de (Postfix) with ESMTPS id 984A2A94758
	for <lists+io-uring@lfdr.de>; Sun, 20 Apr 2025 11:30:30 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id B9C95171C12
	for <lists+io-uring@lfdr.de>; Sun, 20 Apr 2025 09:30:30 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 023AB14D29B;
	Sun, 20 Apr 2025 09:30:26 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="YKv32UaD"
X-Original-To: io-uring@vger.kernel.org
Received: from mail-wr1-f46.google.com (mail-wr1-f46.google.com [209.85.221.46])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 238AD18E76B
	for <io-uring@vger.kernel.org>; Sun, 20 Apr 2025 09:30:23 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.221.46
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1745141425; cv=none; b=eIOwAOBHXYurL4cvYGGzHN7/+9phqjTBEDVeLIxD2Up2+vEYcRaQBDdBLP6ddOMAmzB5Y5z/yXH93DA9zmper3YAbNX87608Linv2tw4tqmcYmLzvWph7UTfOuNB/i7PS+7kcDM95XUEx/SBwsRV+ivSOrg0rocY2b6bWZ+5KFA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1745141425; c=relaxed/simple;
	bh=BluF1cmuwv/1hNkpnBDLmePDq50Uch1NfCiDWpvPGNg=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=NU3SUyLY/Ylb+qgqOfN6VdtZp73YBSbSsnlfAX9xFPwJzBeNWNENv07Pguc3pLVaZM/DEiFRh4ZqZNRCbzxK9WVP9kTXUeEWIzncCbgihktSgzP6yn36LIxekQ0gxqV9UpEJuiKlZeztJWET+Y7d3NtBbZK0Ai/jELu/l7FoWgw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=YKv32UaD; arc=none smtp.client-ip=209.85.221.46
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Received: by mail-wr1-f46.google.com with SMTP id ffacd0b85a97d-3914bc3e01aso1892595f8f.2
        for <io-uring@vger.kernel.org>; Sun, 20 Apr 2025 02:30:23 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1745141422; x=1745746222; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=uQwgODJ6Vb7kWPYrfcPrYscgy1QhFfPjJg0VE6PizWQ=;
        b=YKv32UaDQ16w56wNGcEJgWZh9EsXLNjafo/6W24c8g2mpIE/Dp7S0CfrsbB6cUStN+
         W2s4JE6PbLRK1F2pT1+GRyz+cU3NmeA8nh9nrC1pFytN1MmieWN7h2OYnU+wcLv/nAVd
         FRb4LPN48a44OusdfKix3+bDbmmdaqfjoGmLuZe2z/DY5+ZA1LmS3VgDrFKiqFDQOg9D
         ZnoyOsD+BedeItMMVuaZpOjYjBT3YVrc+PNsrObPuK1aD3qZmmz/XhOnj3eXhanLlEg9
         VZ2FiLFxq4rzbFI45M5JwBSoT8ZcmGF17qdPT6QQN3Ss+LkbDjRzAtRl0mDKx38cGg1O
         brhQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1745141422; x=1745746222;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=uQwgODJ6Vb7kWPYrfcPrYscgy1QhFfPjJg0VE6PizWQ=;
        b=GH4FEc/7hw7Y9liJwzKiUnoaezJDcoLiHOhXD1on/jiA16Gs0RXSEnKiQ0DgO9acSN
         TEsdCPdRq01DIvt7lnxxWYCJazjsoup3W+WRyCEnk4jikzOzTHZvvBdk/GKeO9JnJ8BR
         UvaP9o9LVrS6FI2fjT3zeQqCp7/+q6ZWtenO0T2KEGzSEzks/eUaC78WY9oPsD4AY0d+
         xH/uErjf9Ryw0RvFtO7GJi0Oj+GVlwzAcBjuzPWSawZIlvVgrYtBn0utYS2AQ5fi1TAH
         ecTKVgqFBvxTBu526Ll3g7bTlITlLPoPDdEjEM8Ps1ExyChHbk4aMd2/v9GNTbYPsZXJ
         p+nA==
X-Gm-Message-State: AOJu0Ywx73ICOpNaSCfxIdS0HFKVNBAR9Mjb1/+lQ5Qtwl/d8waTrq04
	O35iMngrPJpG3eNmrQDhsJUdPvIa62lk57w+hNhD+l5iAnjnKh5tSCJnVw==
X-Gm-Gg: ASbGncupH7hCgdRI+lx/7kLAm+gy5P7NPWcRvwOaRDitUVZDFyK6T9/Bcw6hVPg3Q1d
	yGKmo/8+HkYqKZdaWAs19UubZpYG5qXSUlbTxpN7MOG+Xou++vanlpcaC0/Lgum/ztiaH8VWDuK
	GWGBCV3kwA6MOskp84l/HOFJVlKBTr7FF2fe3MvBsOuCl7Bxz26A+4OPtjgubsPdnnNj7lGsPyZ
	m2I03I/EX5qaCoV/DRIcUbblALaKwDxEi9aKq+ocmiDnZMHBJT1igDWXu+oGfG7fWs8jg+3TjPG
	OMmBDBOSfGxNhDKF9AH+87c1i6fzOOEl1qNt2gYHUKK2DheD3w9AG0uHmzUtKdZT
X-Google-Smtp-Source: AGHT+IEVFMQZIpZUQnXx/Pm+hV9cIwD7msbHL3VmIKwhxC9IU1enOAo+Zl35B++HdUlPuG9iA+IcmQ==
X-Received: by 2002:a05:6000:438a:b0:39e:cc0c:9789 with SMTP id ffacd0b85a97d-39efba2ad6emr6836321f8f.11.1745141421992;
        Sun, 20 Apr 2025 02:30:21 -0700 (PDT)
Received: from 127.0.0.1localhost ([148.252.128.74])
        by smtp.gmail.com with ESMTPSA id 5b1f17b1804b1-4406d5ccd43sm91188675e9.26.2025.04.20.02.30.20
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sun, 20 Apr 2025 02:30:21 -0700 (PDT)
From: Pavel Begunkov <asml.silence@gmail.com>
To: io-uring@vger.kernel.org
Cc: asml.silence@gmail.com,
	David Wei <dw@davidwei.uk>
Subject: [PATCH v2 5/6] io_uring/zcrx: move zcrx region to struct io_zcrx_ifq
Date: Sun, 20 Apr 2025 10:31:19 +0100
Message-ID: <24f1a728fc03d0166f16d099575457e10d9d90f2.1745141261.git.asml.silence@gmail.com>
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

Refill queue region is a part of zcrx and should stay in struct
io_zcrx_ifq. We can't have multiple queues without it, so move it there.

As a result there is no context global zcrx region anymore, and the
region is looked up together with its ifq. To protect a concurrent mmap
from seeing an inconsistent region we were protecting changes to
->zcrx_region with mmap_lock, but now it protect the publishing of the
ifq.

Reviewed-by: David Wei <dw@davidwei.uk>
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


