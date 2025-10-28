Return-Path: <io-uring+bounces-10267-lists+io-uring=lfdr.de@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from dfw.mirrors.kernel.org (dfw.mirrors.kernel.org [142.0.200.124])
	by mail.lfdr.de (Postfix) with ESMTPS id 1AC5DC164D9
	for <lists+io-uring@lfdr.de>; Tue, 28 Oct 2025 18:50:52 +0100 (CET)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by dfw.mirrors.kernel.org (Postfix) with ESMTPS id BA3B4542754
	for <lists+io-uring@lfdr.de>; Tue, 28 Oct 2025 17:46:47 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 1D15534C9BF;
	Tue, 28 Oct 2025 17:46:45 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=davidwei-uk.20230601.gappssmtp.com header.i=@davidwei-uk.20230601.gappssmtp.com header.b="M3VGDJmb"
X-Original-To: io-uring@vger.kernel.org
Received: from mail-oa1-f51.google.com (mail-oa1-f51.google.com [209.85.160.51])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 69C9F34CFDF
	for <io-uring@vger.kernel.org>; Tue, 28 Oct 2025 17:46:43 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.160.51
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1761673605; cv=none; b=M9wQaTxRZJsVln4p/vjcLSkJ4L4ed1Cjs6FSL9RGyfk6+ext1jlswtDxeuEAQ6e7n/GGFyZ2Y5JTN5yesLvH71aJI7rG6ehWV+cfdMVihi3DXQNnow66Vn+7G505rt+3ouV1Mg4eodQhwoAzh2wfXThWeJM2qCK/13J0lMA4tfU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1761673605; c=relaxed/simple;
	bh=cIXg+tN9h9zlfWJjNBcrzbEYMhJ5IW2HJ5uhk4M9KsA=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=O+u+uUFxaYj22wx1/YZ7ZMAF8BMzhHJ+UGhz2bJ2x1J93rhy86bIA/z+iKDtTduoqKVyqCnRNZM3NXBWfeIjzSdW4KyGskDy8rshcI6OOrPTXZ3ujnfLSY8b5Jfxbet4ja7EM7+VokcDBx+yw1jPU7CrYpx3HnPPmGXVcSJvhIQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=davidwei.uk; spf=none smtp.mailfrom=davidwei.uk; dkim=pass (2048-bit key) header.d=davidwei-uk.20230601.gappssmtp.com header.i=@davidwei-uk.20230601.gappssmtp.com header.b=M3VGDJmb; arc=none smtp.client-ip=209.85.160.51
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=davidwei.uk
Authentication-Results: smtp.subspace.kernel.org; spf=none smtp.mailfrom=davidwei.uk
Received: by mail-oa1-f51.google.com with SMTP id 586e51a60fabf-3d3b1042e72so1918206fac.2
        for <io-uring@vger.kernel.org>; Tue, 28 Oct 2025 10:46:43 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=davidwei-uk.20230601.gappssmtp.com; s=20230601; t=1761673602; x=1762278402; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=7Du3rc+vnvYBpwFFWNDgSM6MmBUWouZFTL1+wbgJzm0=;
        b=M3VGDJmb06eovMgvwpf0LY33OxgC/QZY4Aa0d4nupvt5qu31UnI0O66H3gCZSa6vAy
         FO+zdZycaRnsF5/3y2CWtv0aIt2g+c9s6uZnIUGMPt3whnLZ8ibF0yd41XwmTFXI8q9M
         sP5aQS28F0MrV2j73Qsd/bx3rGFyg/ecZ+xNzAHJIHqhUlYZTTWTQkjxMsamFAsVavSY
         d0I4ycbqjVjvSiYFUD9XYX7Hc0o/KRkPjRFN52HQ/b/5BewMr2D/dVDD9fe+IDFo60sl
         5xfiYOfIyRAhLXazeEzdVBk5dq1jSehpnGxg74/bqCM8f5QqdmeehVuaJzKNS3Cl9Elx
         FSmg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1761673602; x=1762278402;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=7Du3rc+vnvYBpwFFWNDgSM6MmBUWouZFTL1+wbgJzm0=;
        b=uEtyoPVoKqbRHl6K5GMHCRunWo3+gZ0Sa2HAGsY8KNi5sVAL1ilLHrDHQWvmbL6heg
         wNQmKSjEGhuTo5BTFDzfqQ/hLjyvte7kZuDyB7nrbLJUQzBqnwK7LvkjoNHdkwXEip9A
         IP8rqng/l+QtOe8FyyNBFaifT/x6Qv8VsD2Hz2/WIijYfr4yCKMQQX19AkLjwW9s4nY/
         GlVs+Avzw5Z3VaIEVbLFwSWVNqap8F6FSGvsLCH16UifaR2c+356hDB86BUeUdFuAITf
         eKFjJLL7OANJoxXqDsUjKqgpXNUl9ueU6vGDAltILV7Xw4cKBnhu5uCuFUu9NhTQ+zYd
         WDGA==
X-Gm-Message-State: AOJu0YwXfAYygZl9yyvPIUq1aXK17GWOfPvT6R5tyuAbNXG7QpzZJ2Mf
	hI7hm+qzagi/ak4/vNtn8yq2sh5R+f8h6U6ynYDQaELQ8QYRlZ/lh74d8abJbnIrgVVPamewY3V
	OPHjI
X-Gm-Gg: ASbGncu+n/RMwXG+Dw2P1tkxrIA1XTxLrSudJUgbIgJzR3ZN3i6UnfSsigfj3NBZhUN
	LeQQ2GdGC/Q9neFAeF3zIF11/uwxgkGfEVQHR1q3fVxuvA9bPRJ7AuGvtlsO7+oe+IN3rOme3kc
	14iP4GL+Zwwx6oiEDfgtZPBV2Wq6+sy+DhjSSBF1btgWEzRRtPweR+ioLlseaOBzwd55pT5zWSI
	gYxQZqm2DX5uHMnxdn6ix/lPR99ZdUNqAAx7te0TVvvI+AYxRKVlYzhEqGRJZCusacoSYdCwhD8
	vRcSCfG9Gp+Qu37/NfeB5hgSUOjST1rXhzJCTf24fkZ+UCQ9THb1bAIcZLehLcE5MDGEGVBijwp
	vGwFL4qt8tU0Gvvg60DlRaEpPiIuGNeOp4P0QGG71v1zbLpx0XjuRUdsC+Or/PSSKNQ3HEXTfnQ
	EpRlE2pNvlnlLuGd9ByQ==
X-Google-Smtp-Source: AGHT+IHNBwaTuVlKbviFRStplaOVwH6U1T0/n+dfNL00nvGwBLr9BA86MrTQMPJz2TmJ7wDktJPApQ==
X-Received: by 2002:a05:6871:5290:b0:3d3:4834:b3c with SMTP id 586e51a60fabf-3d747d47867mr137879fac.35.1761673602432;
        Tue, 28 Oct 2025 10:46:42 -0700 (PDT)
Received: from localhost ([2a03:2880:12ff:9::])
        by smtp.gmail.com with ESMTPSA id 586e51a60fabf-3d1e2c30b50sm3837001fac.11.2025.10.28.10.46.42
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 28 Oct 2025 10:46:42 -0700 (PDT)
From: David Wei <dw@davidwei.uk>
To: io-uring@vger.kernel.org,
	netdev@vger.kernel.org
Cc: Jens Axboe <axboe@kernel.dk>,
	Pavel Begunkov <asml.silence@gmail.com>
Subject: [PATCH v4 1/8] io_uring/memmap: remove unneeded io_ring_ctx arg
Date: Tue, 28 Oct 2025 10:46:32 -0700
Message-ID: <20251028174639.1244592-2-dw@davidwei.uk>
X-Mailer: git-send-email 2.47.3
In-Reply-To: <20251028174639.1244592-1-dw@davidwei.uk>
References: <20251028174639.1244592-1-dw@davidwei.uk>
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


