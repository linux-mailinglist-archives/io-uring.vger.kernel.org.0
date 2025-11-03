Return-Path: <io-uring+bounces-10346-lists+io-uring=lfdr.de@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [147.75.80.249])
	by mail.lfdr.de (Postfix) with ESMTPS id 19E98C2E6FF
	for <lists+io-uring@lfdr.de>; Tue, 04 Nov 2025 00:42:11 +0100 (CET)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id B2A651883FE3
	for <lists+io-uring@lfdr.de>; Mon,  3 Nov 2025 23:42:21 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 1166530FC22;
	Mon,  3 Nov 2025 23:41:24 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=davidwei-uk.20230601.gappssmtp.com header.i=@davidwei-uk.20230601.gappssmtp.com header.b="ehsjjTJe"
X-Original-To: io-uring@vger.kernel.org
Received: from mail-oa1-f42.google.com (mail-oa1-f42.google.com [209.85.160.42])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 58B94309DAB
	for <io-uring@vger.kernel.org>; Mon,  3 Nov 2025 23:41:22 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.160.42
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1762213283; cv=none; b=tqY0CGV502AVfA+/nDJGhzLVU4xaC3baL9eeeiQIBSdPjd3BhyqgOLb+9C6IZ0WNTv8TRZKuRLaaAe4Kmzu/X1LgxBUOuu5ZGo3VuJAUJRS0E3FYlZcg7V4PWhU+e1NgymwBfJEghAlxevIqfXsP7ivS3qbIjVmf3TPFR+8J1cI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1762213283; c=relaxed/simple;
	bh=cIXg+tN9h9zlfWJjNBcrzbEYMhJ5IW2HJ5uhk4M9KsA=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=BuYbA2YMxDR2c5jqauwkoICNjkaXmuFWEHAKwIhHzepVJfNzfHf0kHnWvn8aPJmvp96kWYcg3HF8VBXtvgoy70jTLMyOzc2G6VyetRayDVod66ZOIUb8revihx8O0CcDwWjCNC/x+EbfURrOPZvDv3iStsL6B9DzfKFmHamJolg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=davidwei.uk; spf=none smtp.mailfrom=davidwei.uk; dkim=pass (2048-bit key) header.d=davidwei-uk.20230601.gappssmtp.com header.i=@davidwei-uk.20230601.gappssmtp.com header.b=ehsjjTJe; arc=none smtp.client-ip=209.85.160.42
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=davidwei.uk
Authentication-Results: smtp.subspace.kernel.org; spf=none smtp.mailfrom=davidwei.uk
Received: by mail-oa1-f42.google.com with SMTP id 586e51a60fabf-3c9a42d6349so6222287fac.1
        for <io-uring@vger.kernel.org>; Mon, 03 Nov 2025 15:41:22 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=davidwei-uk.20230601.gappssmtp.com; s=20230601; t=1762213281; x=1762818081; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=7Du3rc+vnvYBpwFFWNDgSM6MmBUWouZFTL1+wbgJzm0=;
        b=ehsjjTJedhehZam+IUZSBR6Jm3nUoibU37tEza/HEk0prU1RoL8OSO2dElTBn3r0E4
         BpizlpHD7zeUIfVegLkNz2Pvs8wM4MBBLMusfysyzmsNe2016DEGmJDXcW3/rMRJhf+4
         pJk1pm5QCKBh/xAgGOGQzyHzrh0v5JBETZy4gPiZjNXmM5aqQkDch6gTW7vv4K3DPCeD
         nnOOnY6q2THCtP+6jtg2/eGY9fgPO4UEo1XiYSj2+ILShM+m0W4IXCJjfCIfzhdpGveU
         U7na23EZtkagIlFzzsoP5OBq2xomvzkE0et6GsKxcNGvUYSiDWCNhw6Mag6v9jyUqMxf
         IE4g==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1762213281; x=1762818081;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=7Du3rc+vnvYBpwFFWNDgSM6MmBUWouZFTL1+wbgJzm0=;
        b=APU7xwqyIJm23QGQdyzdu+7LK0Gym/NnhZ8/cnvtZ+4y9M/Toc0hz3hooLBVfBNtQn
         KMEp3aUANlVKxV7hfB/wSKZaJ8uXw2ioTMx5I8MHP6IUA8PSuhiMVvnMcNWhPtJgnv1m
         F/UB7BsuuGkSn25y16DTAde5SnIamq2sWUJCV1YnDa+qn8Z5kml9TiUiJeGe8/oju3Cv
         8nBoBColNC0+TRn2f19DUh2mzUEdB0D0M/LNFe+QYQQGXMsIShN23DZBDImmxQVH6MMK
         mL58iLZTUcEq92RC2nAC+hAZ8MT2SCEKbQRL/D2/42QSYPduoeGssfpfXobmbr2p3wL/
         oAkA==
X-Gm-Message-State: AOJu0Yw8uTrbSaHmdqx6aFH2HqYfuCuSKesS39KlvUIb77b3EIRM6PGn
	4P80/wNhlP7DZseKtNMEFSGNCBzba6oImC1Gg1ofTcbSgxc7qFnvzDMuI4nbAr58C1GtnMOBrWU
	gcwjY
X-Gm-Gg: ASbGncue7xf/dx4LWUBTzPq7Eh3KpxIhC3d5sywZj2okx1j+42kzCuWFNX5+69R2jpH
	2oShVg6sqTFYWhEq1R9Ey1X6kJCFCJhr0JzEMxr0+TBwBY336khirXWiuTzWtnj8CxkJimCP8Nf
	MQggUw3SLc52dKzw08mWvvHM7F8Lv+C0Egu/z6wrM32JtOrA5MOk2hfMBvcExj5+awPW/kU8IU/
	ax10iVaVs17ljCtQayE3GCKCwZd+9+7MXU1UHtc2/MUuXQxPqH4U1TZYl/CHJdex7mdtDXraXoJ
	yii/iq+R6wykQtDf+SDCI1xR/Xw41FUJQOql3mu+OF9wTioVSXhLrub43Ez/YOd7s+MSudQt9Sk
	pTj8rp8w+FXkOoMdpK/7oM2KFK/rtMWbV2nrhp0o1wYcEwArkVohUEHYzF6Vouf+XZELsLE4wdo
	+R1zLdaAIi9EQx+lhjQU6AeUiT83wJQg==
X-Google-Smtp-Source: AGHT+IHxScxSSuSgLTqjWhOCow+BFw3hFTHDVH/SZE0r8rxc/e2eU7jEi88LOGeSkmX3N2qFx4pjXQ==
X-Received: by 2002:a05:6870:d373:b0:3c3:1ec8:2aa9 with SMTP id 586e51a60fabf-3dacbfbea23mr6752173fac.24.1762213281420;
        Mon, 03 Nov 2025 15:41:21 -0800 (PST)
Received: from localhost ([2a03:2880:12ff:72::])
        by smtp.gmail.com with ESMTPSA id 586e51a60fabf-3dff4c0e8a4sm533685fac.8.2025.11.03.15.41.20
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 03 Nov 2025 15:41:21 -0800 (PST)
From: David Wei <dw@davidwei.uk>
To: io-uring@vger.kernel.org,
	netdev@vger.kernel.org
Cc: Jens Axboe <axboe@kernel.dk>,
	Pavel Begunkov <asml.silence@gmail.com>
Subject: [PATCH v4 03/12] io_uring/memmap: remove unneeded io_ring_ctx arg
Date: Mon,  3 Nov 2025 15:41:01 -0800
Message-ID: <20251103234110.127790-4-dw@davidwei.uk>
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

Remove io_ring_ctx arg from io_region_pin_pages() and
io_region_allocate_pages() that isn't used.

Signed-off-by: David Wei <dw@davidwei.uk>
---
 io_uring/memmap.c | 12 +++++-------
 1 file changed, 5 insertions(+), 7 deletions(-)

diff --git a/io_uring/memmap.c b/io_uring/memmap.c
index aa388ecd4754..d1318079c337 100644
--- a/io_uring/memmap.c
+++ b/io_uring/memmap.c
@@ -131,9 +131,8 @@ static int io_region_init_ptr(struct io_mapped_region *mr)
 	return 0;
 }
 
-static int io_region_pin_pages(struct io_ring_ctx *ctx,
-				struct io_mapped_region *mr,
-				struct io_uring_region_desc *reg)
+static int io_region_pin_pages(struct io_mapped_region *mr,
+			       struct io_uring_region_desc *reg)
 {
 	unsigned long size = mr->nr_pages << PAGE_SHIFT;
 	struct page **pages;
@@ -150,8 +149,7 @@ static int io_region_pin_pages(struct io_ring_ctx *ctx,
 	return 0;
 }
 
-static int io_region_allocate_pages(struct io_ring_ctx *ctx,
-				    struct io_mapped_region *mr,
+static int io_region_allocate_pages(struct io_mapped_region *mr,
 				    struct io_uring_region_desc *reg,
 				    unsigned long mmap_offset)
 {
@@ -219,9 +217,9 @@ int io_create_region(struct io_ring_ctx *ctx, struct io_mapped_region *mr,
 	mr->nr_pages = nr_pages;
 
 	if (reg->flags & IORING_MEM_REGION_TYPE_USER)
-		ret = io_region_pin_pages(ctx, mr, reg);
+		ret = io_region_pin_pages(mr, reg);
 	else
-		ret = io_region_allocate_pages(ctx, mr, reg, mmap_offset);
+		ret = io_region_allocate_pages(mr, reg, mmap_offset);
 	if (ret)
 		goto out_free;
 
-- 
2.47.3


