Return-Path: <io-uring+bounces-5025-lists+io-uring=lfdr.de@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [139.178.88.99])
	by mail.lfdr.de (Postfix) with ESMTPS id 1E82D9D7846
	for <lists+io-uring@lfdr.de>; Sun, 24 Nov 2024 22:12:28 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id D545728200F
	for <lists+io-uring@lfdr.de>; Sun, 24 Nov 2024 21:12:26 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 156FE14F136;
	Sun, 24 Nov 2024 21:12:26 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="Ym+cWTQH"
X-Original-To: io-uring@vger.kernel.org
Received: from mail-wm1-f41.google.com (mail-wm1-f41.google.com [209.85.128.41])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3A4D0165EFC
	for <io-uring@vger.kernel.org>; Sun, 24 Nov 2024 21:12:24 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.128.41
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1732482746; cv=none; b=MJxR54CEmk7HnXkUR03L3W1i0AUK9ExNkpD9/uJUfi4JRTuATJwRHQg4PtWCJ9r5QwX49PoJoYPhW2Pq3zc2SAH6TERQlaZzqhi/aByq3OhSASlNdOllrfq8DUaVHRW2JzhZM4+RQTrwvUiQ9dvd858IULAJXaoH8OOHxvtmcRQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1732482746; c=relaxed/simple;
	bh=fPhRBnMHePxLkkKrqQUKSYByjBb44pQDHEKtxX1xlQc=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=eMRMET7nxvV+XnzD/VaFZqBZvqiVgThfrRT+jIYy+uIDq5upjmHFzA2ab77y6UeLLRFXV3XzC5fOucprvcW2a2mkp9ZbE0rSkGI51/0d8N44Ts4EZjNxcLUTOClaH3TvOrJskWiQfxTpNgBP2625N8cEVSDND3bkfM1ax2YvvkE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=Ym+cWTQH; arc=none smtp.client-ip=209.85.128.41
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Received: by mail-wm1-f41.google.com with SMTP id 5b1f17b1804b1-43162cf1eaaso48598485e9.0
        for <io-uring@vger.kernel.org>; Sun, 24 Nov 2024 13:12:24 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1732482742; x=1733087542; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=n+ATPVfD8rX3FECsgDLHC0j20SKGDTPCcG71uC10WDA=;
        b=Ym+cWTQHfdNC3GOzz7w5m1JbFt2E3IHQDodFaWtvK3VblTdndhIple0jFsUw4fxmli
         ucS19seo3Y+zGPup9MZ6B8Pqu6k71HdFEX4Kwiy5s9AlfwistUXyAR+GVGuukkDc7TH2
         2We6+bKJMsrOKszjTcz5dabm2lyTRKL6wBsQdxrt0VKWajjcTQWqvMtN7QBrU/0h+C+G
         jd4O2lSWlSsIsuGmBaI7fPxCCWGkDW8VneaowEvHqlEWhl6Zb3OlPE5r4gDaFocTjaNU
         ICzVNfVMocGP0Ys0tYP0QaXwsYtSfYZwlL7+VLMqOueAKxOJlY29GnH5AFbem4mSScwR
         td1A==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1732482742; x=1733087542;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=n+ATPVfD8rX3FECsgDLHC0j20SKGDTPCcG71uC10WDA=;
        b=JOePySmOjIegyGThW9nOr4oD+Gxio+u6MFrN19pve4UhEv32wG09FnQdCBMSaDBA+m
         WbakMoNJUHxm6BpD3E5KpDpRtv85+CYgm5odIWVPHmzHK8B7xvPoOx9ZBKLZ8wnwl1L3
         AoaTVtizkZjCKCT6OhvEAuliWdARYeqWCkX7KifRVivSyFWnFU6+OrY9RJp2FyVWxHxw
         +l24URgop1hl3dsm3PnYAC+RHeJM5HudK8lH0n3aI0p51ebsXbFPnOBrOpo0au2gRsQE
         xF4jd/QScv0wuxR698hGPZMIMCctE70zr28dUqAk1XPGCcY7N+ucWkngniBJkxJDAbXL
         LE/Q==
X-Gm-Message-State: AOJu0YzvCfz/WwANc8LqXtX0PPvuEh68of1CrK4iYCMD0lK/b9YzJ/Kb
	P7Ho2JTksme1etPrMFRS7JikbxdHlvXibl2pgNrboRLdXyUHqmi2RKgxpA==
X-Gm-Gg: ASbGnctvHZILfvMPxLOce2rTAFcSevVeZEFaLhw7rYVTii4Yv3988y1B2oT6XjC36FK
	LbWdHrSmWtIItMVzsLqVEcueVA98IarkiqQICS0C6jvYgtRLS8cWGsS1lj1OpY8QHf/VYBzacW6
	2sTs4rDGG0F4YPQFNwwDhb2vNEQhqCfKuN6UEa/EO6zNVSrA+AkZXcjHFGskcIcRxgPVFdycfvc
	TbNtjbkrEdwWnXwDWm9ZccVBcjfUyiNFkgmrT5cZ4EXdPcxop8Yw/rhAQ3E3y0=
X-Google-Smtp-Source: AGHT+IHiBDGpcmAYpzc6fSJLKpY+GyS3fogbrN2uXQnJCVNvfBs3+U2pd+DoE7/RMfGJ/e4DZtEwLQ==
X-Received: by 2002:a05:600c:4fcc:b0:42c:ba83:3f00 with SMTP id 5b1f17b1804b1-433ce410337mr95457605e9.1.1732482742484;
        Sun, 24 Nov 2024 13:12:22 -0800 (PST)
Received: from 127.0.0.1localhost ([85.255.235.224])
        by smtp.gmail.com with ESMTPSA id 5b1f17b1804b1-432f643b299sm132733745e9.0.2024.11.24.13.12.21
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sun, 24 Nov 2024 13:12:22 -0800 (PST)
From: Pavel Begunkov <asml.silence@gmail.com>
To: io-uring@vger.kernel.org
Cc: asml.silence@gmail.com
Subject: [PATCH v2 18/18] io_uring/memmap: unify io_uring mmap'ing code
Date: Sun, 24 Nov 2024 21:12:35 +0000
Message-ID: <8cc1f2443b5523674f3662a8654212694c756f9e.1732481694.git.asml.silence@gmail.com>
X-Mailer: git-send-email 2.46.0
In-Reply-To: <cover.1732481694.git.asml.silence@gmail.com>
References: <cover.1732481694.git.asml.silence@gmail.com>
Precedence: bulk
X-Mailing-List: io-uring@vger.kernel.org
List-Id: <io-uring.vger.kernel.org>
List-Subscribe: <mailto:io-uring+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:io-uring+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

All mapped memory is now backed by regions and we can unify and clean
up io_region_validate_mmap() and io_uring_mmap(). Extract a function
looking up a region, the rest of the handling should be generic and just
needs the region.

There is one more ring type specific code, i.e. the mmaping size
truncation quirk for IORING_OFF_[S,C]Q_RING, which is left as is.

Signed-off-by: Pavel Begunkov <asml.silence@gmail.com>
---
 io_uring/kbuf.c   |  3 --
 io_uring/memmap.c | 82 ++++++++++++++++++-----------------------------
 2 files changed, 32 insertions(+), 53 deletions(-)

diff --git a/io_uring/kbuf.c b/io_uring/kbuf.c
index f77d14e4d598..a3847154bd99 100644
--- a/io_uring/kbuf.c
+++ b/io_uring/kbuf.c
@@ -748,8 +748,5 @@ struct io_mapped_region *io_pbuf_get_region(struct io_ring_ctx *ctx,
 	bl = xa_load(&ctx->io_bl_xa, bgid);
 	if (!bl || !(bl->flags & IOBL_BUF_RING))
 		return NULL;
-	if (WARN_ON_ONCE(!io_region_is_set(&bl->region)))
-		return NULL;
-
 	return &bl->region;
 }
diff --git a/io_uring/memmap.c b/io_uring/memmap.c
index 22c3a20bd52b..4b4bc4233e5a 100644
--- a/io_uring/memmap.c
+++ b/io_uring/memmap.c
@@ -246,6 +246,27 @@ int io_create_region_mmap_safe(struct io_ring_ctx *ctx, struct io_mapped_region
 	return 0;
 }
 
+static struct io_mapped_region *io_mmap_get_region(struct io_ring_ctx *ctx,
+						   loff_t pgoff)
+{
+	loff_t offset = pgoff << PAGE_SHIFT;
+	unsigned int bgid;
+
+	switch (offset & IORING_OFF_MMAP_MASK) {
+	case IORING_OFF_SQ_RING:
+	case IORING_OFF_CQ_RING:
+		return &ctx->ring_region;
+	case IORING_OFF_SQES:
+		return &ctx->sq_region;
+	case IORING_OFF_PBUF_RING:
+		bgid = (offset & ~IORING_OFF_MMAP_MASK) >> IORING_OFF_PBUF_SHIFT;
+		return io_pbuf_get_region(ctx, bgid);
+	case IORING_MAP_OFF_PARAM_REGION:
+		return &ctx->param_region;
+	}
+	return NULL;
+}
+
 static void *io_region_validate_mmap(struct io_ring_ctx *ctx,
 				     struct io_mapped_region *mr)
 {
@@ -270,43 +291,17 @@ static int io_region_mmap(struct io_ring_ctx *ctx,
 	return vm_insert_pages(vma, vma->vm_start, mr->pages, &nr_pages);
 }
 
+
 static void *io_uring_validate_mmap_request(struct file *file, loff_t pgoff,
 					    size_t sz)
 {
 	struct io_ring_ctx *ctx = file->private_data;
-	loff_t offset = pgoff << PAGE_SHIFT;
-
-	switch ((pgoff << PAGE_SHIFT) & IORING_OFF_MMAP_MASK) {
-	case IORING_OFF_SQ_RING:
-	case IORING_OFF_CQ_RING:
-		/* Don't allow mmap if the ring was setup without it */
-		if (ctx->flags & IORING_SETUP_NO_MMAP)
-			return ERR_PTR(-EINVAL);
-		if (!ctx->rings)
-			return ERR_PTR(-EFAULT);
-		return ctx->rings;
-	case IORING_OFF_SQES:
-		/* Don't allow mmap if the ring was setup without it */
-		if (ctx->flags & IORING_SETUP_NO_MMAP)
-			return ERR_PTR(-EINVAL);
-		if (!ctx->sq_sqes)
-			return ERR_PTR(-EFAULT);
-		return ctx->sq_sqes;
-	case IORING_OFF_PBUF_RING: {
-		struct io_mapped_region *region;
-		unsigned int bgid;
-
-		bgid = (offset & ~IORING_OFF_MMAP_MASK) >> IORING_OFF_PBUF_SHIFT;
-		region = io_pbuf_get_region(ctx, bgid);
-		if (!region)
-			return ERR_PTR(-EINVAL);
-		return io_region_validate_mmap(ctx, region);
-		}
-	case IORING_MAP_OFF_PARAM_REGION:
-		return io_region_validate_mmap(ctx, &ctx->param_region);
-	}
+	struct io_mapped_region *region;
 
-	return ERR_PTR(-EINVAL);
+	region = io_mmap_get_region(ctx, pgoff);
+	if (!region)
+		return ERR_PTR(-EINVAL);
+	return io_region_validate_mmap(ctx, region);
 }
 
 #ifdef CONFIG_MMU
@@ -316,7 +311,8 @@ __cold int io_uring_mmap(struct file *file, struct vm_area_struct *vma)
 	struct io_ring_ctx *ctx = file->private_data;
 	size_t sz = vma->vm_end - vma->vm_start;
 	long offset = vma->vm_pgoff << PAGE_SHIFT;
-	unsigned int page_limit;
+	unsigned int page_limit = UINT_MAX;
+	struct io_mapped_region *region;
 	void *ptr;
 
 	guard(mutex)(&ctx->mmap_lock);
@@ -329,25 +325,11 @@ __cold int io_uring_mmap(struct file *file, struct vm_area_struct *vma)
 	case IORING_OFF_SQ_RING:
 	case IORING_OFF_CQ_RING:
 		page_limit = (sz + PAGE_SIZE - 1) >> PAGE_SHIFT;
-		return io_region_mmap(ctx, &ctx->ring_region, vma, page_limit);
-	case IORING_OFF_SQES:
-		return io_region_mmap(ctx, &ctx->sq_region, vma, UINT_MAX);
-	case IORING_OFF_PBUF_RING: {
-		struct io_mapped_region *region;
-		unsigned int bgid;
-
-		bgid = (offset & ~IORING_OFF_MMAP_MASK) >> IORING_OFF_PBUF_SHIFT;
-		region = io_pbuf_get_region(ctx, bgid);
-		if (!region)
-			return -EINVAL;
-
-		return io_region_mmap(ctx, region, vma, UINT_MAX);
-	}
-	case IORING_MAP_OFF_PARAM_REGION:
-		return io_region_mmap(ctx, &ctx->param_region, vma, UINT_MAX);
+		break;
 	}
 
-	return -EINVAL;
+	region = io_mmap_get_region(ctx, vma->vm_pgoff);
+	return io_region_mmap(ctx, region, vma, page_limit);
 }
 
 unsigned long io_uring_get_unmapped_area(struct file *filp, unsigned long addr,
-- 
2.46.0


