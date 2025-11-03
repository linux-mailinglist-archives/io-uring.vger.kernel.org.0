Return-Path: <io-uring+bounces-10350-lists+io-uring=lfdr.de@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from dfw.mirrors.kernel.org (dfw.mirrors.kernel.org [142.0.200.124])
	by mail.lfdr.de (Postfix) with ESMTPS id 11351C2E716
	for <lists+io-uring@lfdr.de>; Tue, 04 Nov 2025 00:42:43 +0100 (CET)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by dfw.mirrors.kernel.org (Postfix) with ESMTPS id 0FC3A4EE5B3
	for <lists+io-uring@lfdr.de>; Mon,  3 Nov 2025 23:42:20 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 272783191C9;
	Mon,  3 Nov 2025 23:41:30 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=davidwei-uk.20230601.gappssmtp.com header.i=@davidwei-uk.20230601.gappssmtp.com header.b="0+j27Hia"
X-Original-To: io-uring@vger.kernel.org
Received: from mail-oa1-f42.google.com (mail-oa1-f42.google.com [209.85.160.42])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 676DE3148B1
	for <io-uring@vger.kernel.org>; Mon,  3 Nov 2025 23:41:28 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.160.42
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1762213290; cv=none; b=Puf7Vwlxo0n6QNRZAmMwvQSy9USn0mhWH4R26zx7N+jItHCA9ZR/toBc7mF81glvR6nZGESAj48BJ5kaDv/U+xeHt4bUzT+IBXDOfgo11/xaO01aVE+kVvyYtxYxjUyCMGIaiQQk2bzEYnsmeMl2coR0xhtbgVm5mcRkna3NypI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1762213290; c=relaxed/simple;
	bh=mV1J2JWvGkTG7ZrjzMvfykSXiumc2Gfk8ItPfrlz6WQ=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=H29R+1vbSZ8SCVtOrCJs/YRh0sHEXxsh3lPlCAbXVZ0Sx7uHlrsdtacqI0z+Dh+ZIoYN4AlsOUGR9qW/irGRlyEMhYKsTmakbxij7zyYntMgni/gAbzBcbV/R9UEfXyTxQh2V4q3Bpg2oMmCf9/9Ed3x3d7nbQbmONRLHlIvK0E=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=davidwei.uk; spf=none smtp.mailfrom=davidwei.uk; dkim=pass (2048-bit key) header.d=davidwei-uk.20230601.gappssmtp.com header.i=@davidwei-uk.20230601.gappssmtp.com header.b=0+j27Hia; arc=none smtp.client-ip=209.85.160.42
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=davidwei.uk
Authentication-Results: smtp.subspace.kernel.org; spf=none smtp.mailfrom=davidwei.uk
Received: by mail-oa1-f42.google.com with SMTP id 586e51a60fabf-3d322b3fd7eso1881381fac.0
        for <io-uring@vger.kernel.org>; Mon, 03 Nov 2025 15:41:28 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=davidwei-uk.20230601.gappssmtp.com; s=20230601; t=1762213287; x=1762818087; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=PQoyqckx2QGKJjUYjNUvJfG1gloXHwlR0zFAshtBxIw=;
        b=0+j27HiaMdNbnaNVo36E6dyVKnbO1MjfsUQXIQ2A3wQy4pIB2fFc/EfWllp8bm/svQ
         Yjeig496Yb0+kH39+CCWDmUNEqFLSHz96PvMJisA70/znrD+f7ElosqWv0ajOogNZk3d
         tGtZPy7DkVfj/XkG4BvrZnvx6N48X6DN59l/x6MrIktbxq521QN6ymFbfRj7yjkfDmzc
         9Id0RHlgeYr9fU082dix9Q2ap2Ke3BAsGeXt4fYTj6USCoBa6tz1zfTc1cCe6ulEU/v1
         CzVcI8zBDeVUIw54e1s1OQl1DaH9AfQYolAXB5ulknw32OyxCiPSxiKqjPQccUWzJcy2
         5rkw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1762213287; x=1762818087;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=PQoyqckx2QGKJjUYjNUvJfG1gloXHwlR0zFAshtBxIw=;
        b=WSUUK5D/KYrdBMKXqk71Mlv+YFCYQk5IUoJVsCDf4CyechfSJIkgmGyFI3z58sk5Oo
         KX7ZXF+n+4uufxB8JQLoQwbnnQFNHFGVKuPTtppJEEN96jUXb/CTFBgxIkONf9Bn8vly
         0Btmbk8U+s43DdEXW0eTgulPfPU0xfOsUGXxHn5YsrehJ2b9joq0ybVZBnT5cXzvLXI5
         ujzeuWQ82ZdC9TlYbiMAgqK1786UOliwQPL7uZajE9z9hqL0ihiJRCmzLF2WAm7k3dkz
         mJ+m3vCbmIE26nLRGiwzkPb2gRujeSa76QwbzHuTz7/49Sydb0WzYhuu2ykbiQ3QbFsr
         t2Mg==
X-Gm-Message-State: AOJu0YzUvAXV+jF+wJYvE05AjKDEQhtLSqyp9fu6EVzue743noIBpJSL
	hcsyfwUMUxeDdOPRw/0e2MBL6lWq0IgHFod40FaoC0KJ4Sr7pYFOSTzW8g0fHquTLigtgLZbfKp
	3Ymz9
X-Gm-Gg: ASbGncu6tn9r4mb2Hixj+wjxyWlnlmYg/U6DGN5hDmPcCgAOiA9v71QOQ9ME/NvFjPG
	HTDMJV4WfZUPmTIhRWNW1mPfRENtpUYE+QEF/THwgQv58h4jBg+jfkCBAG+nnisd9tJrjrO2xNB
	FqgxZAtW4mfesSDhSxv+rAntnFqo2qpMh026uqWUcdhwLfRV2xJtxT+Dmoh8jAGttQpIBYaxhAJ
	4/ZwrMLf2Sy8sH3Ay2wtpGEA9K/qG2BnGdiAQmqKEy/fdbiVsG3D85C36qDwXI1zcKYBb6LFs0L
	NXJUiKA/Kdcgt5w92h02e4NG1ECXCYf6tVH00zcYv3J6gHftDATBGqR0pmRrTj0Pqg9h7X43bi7
	HBxdk3Rpp7qLx7D5X9SoNDo7/oHONzC4xydCVnwec7bpxnDYe2qc4jgg0p6iu2XgxVIZ7VUGO66
	8yz4OTZB+ug94AY58=
X-Google-Smtp-Source: AGHT+IF8RGwvZ8ackx96j8qWiiSrFBo8OpgVKM16CnH1hIBqjBlp21nj4cqI/71aCESo2oo7ArabMQ==
X-Received: by 2002:a05:6870:aa0e:b0:399:58c2:2e5b with SMTP id 586e51a60fabf-3dacd1110ccmr7489365fac.51.1762213287363;
        Mon, 03 Nov 2025 15:41:27 -0800 (PST)
Received: from localhost ([2a03:2880:12ff::])
        by smtp.gmail.com with ESMTPSA id 586e51a60fabf-3dff521394esm519083fac.9.2025.11.03.15.41.26
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 03 Nov 2025 15:41:26 -0800 (PST)
From: David Wei <dw@davidwei.uk>
To: io-uring@vger.kernel.org,
	netdev@vger.kernel.org
Cc: Jens Axboe <axboe@kernel.dk>,
	Pavel Begunkov <asml.silence@gmail.com>
Subject: [PATCH v4 07/12] io_uring/zcrx: add user_struct and mm_struct to io_zcrx_ifq
Date: Mon,  3 Nov 2025 15:41:05 -0800
Message-ID: <20251103234110.127790-8-dw@davidwei.uk>
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

In preparation for removing ifq->ctx and making ifq lifetime independent
of ring ctx, add user_struct and mm_struct to io_zcrx_ifq.

In the ifq cleanup path, these are the only fields used from the main
ring ctx to do accounting. Taking a copy in the ifq allows ifq->ctx to
be removed later, including the ctx->refs held by the ifq.

Signed-off-by: David Wei <dw@davidwei.uk>
---
 io_uring/zcrx.c | 24 ++++++++++++++++++------
 io_uring/zcrx.h |  2 ++
 2 files changed, 20 insertions(+), 6 deletions(-)

diff --git a/io_uring/zcrx.c b/io_uring/zcrx.c
index 5dd93e4e0ee7..dcf5297c0330 100644
--- a/io_uring/zcrx.c
+++ b/io_uring/zcrx.c
@@ -200,7 +200,7 @@ static int io_import_umem(struct io_zcrx_ifq *ifq,
 	}
 
 	mem->account_pages = io_count_account_pages(pages, nr_pages);
-	ret = io_account_mem(ifq->ctx->user, ifq->ctx->mm_account, mem->account_pages);
+	ret = io_account_mem(ifq->user, ifq->mm_account, mem->account_pages);
 	if (ret < 0)
 		mem->account_pages = 0;
 
@@ -344,7 +344,8 @@ static void io_zcrx_get_niov_uref(struct net_iov *niov)
 	atomic_inc(io_get_user_counter(niov));
 }
 
-static int io_allocate_rbuf_ring(struct io_zcrx_ifq *ifq,
+static int io_allocate_rbuf_ring(struct io_ring_ctx *ctx,
+				 struct io_zcrx_ifq *ifq,
 				 struct io_uring_zcrx_ifq_reg *reg,
 				 struct io_uring_region_desc *rd,
 				 u32 id)
@@ -362,7 +363,7 @@ static int io_allocate_rbuf_ring(struct io_zcrx_ifq *ifq,
 	mmap_offset = IORING_MAP_OFF_ZCRX_REGION;
 	mmap_offset += id << IORING_OFF_PBUF_SHIFT;
 
-	ret = io_create_region(ifq->ctx, &ifq->region, rd, mmap_offset);
+	ret = io_create_region(ctx, &ifq->region, rd, mmap_offset);
 	if (ret < 0)
 		return ret;
 
@@ -378,7 +379,7 @@ static int io_allocate_rbuf_ring(struct io_zcrx_ifq *ifq,
 
 static void io_free_rbuf_ring(struct io_zcrx_ifq *ifq)
 {
-	io_free_region(ifq->ctx->user, &ifq->region);
+	io_free_region(ifq->user, &ifq->region);
 	ifq->rq_ring = NULL;
 	ifq->rqes = NULL;
 }
@@ -390,7 +391,7 @@ static void io_zcrx_free_area(struct io_zcrx_ifq *ifq,
 	io_release_area_mem(&area->mem);
 
 	if (area->mem.account_pages)
-		io_unaccount_mem(area->ifq->ctx->user, area->ifq->ctx->mm_account,
+		io_unaccount_mem(ifq->user, ifq->mm_account,
 				 area->mem.account_pages);
 
 	kvfree(area->freelist);
@@ -525,6 +526,9 @@ static void io_zcrx_ifq_free(struct io_zcrx_ifq *ifq)
 
 	if (ifq->area)
 		io_zcrx_free_area(ifq, ifq->area);
+	free_uid(ifq->user);
+	if (ifq->mm_account)
+		mmdrop(ifq->mm_account);
 	if (ifq->dev)
 		put_device(ifq->dev);
 
@@ -607,6 +611,14 @@ int io_register_zcrx_ifq(struct io_ring_ctx *ctx,
 	ifq = io_zcrx_ifq_alloc(ctx);
 	if (!ifq)
 		return -ENOMEM;
+	if (ctx->user) {
+		get_uid(ctx->user);
+		ifq->user = ctx->user;
+	}
+	if (ctx->mm_account) {
+		mmgrab(ctx->mm_account);
+		ifq->mm_account = ctx->mm_account;
+	}
 	ifq->rq_entries = reg.rq_entries;
 
 	scoped_guard(mutex, &ctx->mmap_lock) {
@@ -616,7 +628,7 @@ int io_register_zcrx_ifq(struct io_ring_ctx *ctx,
 			goto ifq_free;
 	}
 
-	ret = io_allocate_rbuf_ring(ifq, &reg, &rd, id);
+	ret = io_allocate_rbuf_ring(ctx, ifq, &reg, &rd, id);
 	if (ret)
 		goto err;
 
diff --git a/io_uring/zcrx.h b/io_uring/zcrx.h
index d7bef619e8ad..2396436643e5 100644
--- a/io_uring/zcrx.h
+++ b/io_uring/zcrx.h
@@ -42,6 +42,8 @@ struct io_zcrx_ifq {
 	struct io_ring_ctx		*ctx;
 	struct io_zcrx_area		*area;
 	unsigned			niov_shift;
+	struct user_struct		*user;
+	struct mm_struct		*mm_account;
 
 	spinlock_t			rq_lock ____cacheline_aligned_in_smp;
 	struct io_uring			*rq_ring;
-- 
2.47.3


