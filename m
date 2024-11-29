Return-Path: <io-uring+bounces-5149-lists+io-uring=lfdr.de@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from sy.mirrors.kernel.org (sy.mirrors.kernel.org [IPv6:2604:1380:40f1:3f00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 659289DE7B4
	for <lists+io-uring@lfdr.de>; Fri, 29 Nov 2024 14:34:23 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sy.mirrors.kernel.org (Postfix) with ESMTPS id 7CA71B23B9E
	for <lists+io-uring@lfdr.de>; Fri, 29 Nov 2024 13:34:20 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id D10C819F419;
	Fri, 29 Nov 2024 13:34:14 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="B+BEPJuq"
X-Original-To: io-uring@vger.kernel.org
Received: from mail-ej1-f50.google.com (mail-ej1-f50.google.com [209.85.218.50])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 090E019CC27
	for <io-uring@vger.kernel.org>; Fri, 29 Nov 2024 13:34:12 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.218.50
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1732887254; cv=none; b=hmt9WsRpNbOoOtDpiArK6kudsnjtAKuP5yKVy3dGt8DL0L9N/4/mQ2384I5SVxb5uxH3UTB1N5wD7OVhlxIb7wYNQr/hYFoq0yE/1/d1nsQZVe2UPIKA9OaLBtz4wjDzXshbYMFqtuE8dKNI5GrjGQxUFQOMbCKXOVcmlvGBWaY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1732887254; c=relaxed/simple;
	bh=OwrKJ3LmdCtYc4BXuj3h5dzn1NBkc6lMUM2lySWds5c=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=tbYNEAHlskciZ3Sd0Bfxyq7l2UKBidejqZxqFI9DgkSI5Xnbavkzy7w6IzvmTl+NuhZOhBisixwD9oUWeQrTMkY915Bxm2UJxAgaE8pIAy4u6HG0hMSoFXuFR1gnRNgRqnIuJdVjiwYR/rMpKCL6M3yJxXN/J5silY37RyhxlWo=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=B+BEPJuq; arc=none smtp.client-ip=209.85.218.50
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Received: by mail-ej1-f50.google.com with SMTP id a640c23a62f3a-aa51b8c5f4dso248433366b.2
        for <io-uring@vger.kernel.org>; Fri, 29 Nov 2024 05:34:12 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1732887251; x=1733492051; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=vJTYzsUPh3C46ZWrdJuDJ1PJh9BVCFJmJ/mZBbSroxA=;
        b=B+BEPJuqDsCi5xBj/o2tbkjJvcbeL1K0I0y+g9GFKm7Af6purpLYN8sZg8f7/M/OMV
         hbQhzxolQ1Tuwfv7gNHpy2FitmaBRbUkiyyBT+vKdA+Ah9K1Fvj0r1as4OBjYHxEkm6E
         qqJ+OGsZbIk7snANKLEf0vhH2PsWr8Wix9epq975laRTtk+DZtHjwuaxnbSeyTyz0PVQ
         GmvUEF+dTvj9Hoa7u7j19EpE14pYkdLxplupDKkHVSOljKmRgP2yQiEes1BAHXU6PqgV
         CN1fNOwhWuN75upikFEqiDnj/ES+ClAaQ+8q2BTbRsFRPlkZCxWVedhFy5W8DgDnIi5b
         Kp3w==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1732887251; x=1733492051;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=vJTYzsUPh3C46ZWrdJuDJ1PJh9BVCFJmJ/mZBbSroxA=;
        b=qaE8uNa7OzHXMXdfCB6Q8aCwl55r3Vitwbrzj+WDIDrbfJ51NcILEbg9NcjEJNK4A5
         TnqHvvBF3R5fnUd7jt049JVp7LvPMsCj5hPDrz3Ls5DSIV+DHPG7UKpVz+0pcduBWZU4
         pj/mCgU1YGnB58Sc5S8ke39Pt1UxGaNPLKIdEinDf+wQvcARx0qVNmF9RFNy+SI5tPX5
         1djzg96NCk78+Qtc0fR5lz4anuWVHxk7QPv/2bAsmA7MjY2ofXuUjRuB+MZ2VXNlZs9t
         /ANlk60vaYaKPDcANnPJSmJWzpq1AlsbrH5N/cUM4QIgHxgnku/XiLHTAbkNk3vcoh8W
         Ee0A==
X-Gm-Message-State: AOJu0Yzzmtpl05wkINQ+RoqQVSgi53gd2TrlqZ8ur6q70E9vw+FzPXIh
	GbsvSq9j+lxMvyi6RNc6F5oaZ0vb1fRUtIjgubm678V95mM3wVEUyDBpRw==
X-Gm-Gg: ASbGnctRElkHDgMEd/VTI5CDwvLCzeth6aJKLo7MBruB+ZzqVHGTfzOdTWovpB1EWXB
	Iix3A1lNYdevdzEvGevL5nydm8bNX0oWl1QIkJhVx6MqeiFcw3LFdNQYuo2d101Oc4J+tkBAu3R
	1Shkx+6A/BJytqQXkkzdvwWCiAlsQ9jKanJt98nU+wXwCanhzaR8wE5q/ns9mFMdSY8whA1Q2P2
	ge2RBKv2hPE11BbWpTCzZst36P8VJ0k7dBHO+8eeKHHapNZvuOCc69d5K7GpD+O
X-Google-Smtp-Source: AGHT+IGam5cvw79/xPeSq5Xvfj3nUPVd4iz3o2K7s2sp7OVQth96hOXHQBgUn7j7xtvkLtzSEEosHQ==
X-Received: by 2002:a17:907:770a:b0:aa5:26ac:18d6 with SMTP id a640c23a62f3a-aa58102872cmr945963866b.43.1732887250237;
        Fri, 29 Nov 2024 05:34:10 -0800 (PST)
Received: from 127.0.0.1localhost ([163.114.131.193])
        by smtp.gmail.com with ESMTPSA id a640c23a62f3a-aa5996c2471sm173996866b.13.2024.11.29.05.34.09
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 29 Nov 2024 05:34:09 -0800 (PST)
From: Pavel Begunkov <asml.silence@gmail.com>
To: io-uring@vger.kernel.org
Cc: asml.silence@gmail.com
Subject: [PATCH v3 18/18] io_uring/memmap: unify io_uring mmap'ing code
Date: Fri, 29 Nov 2024 13:34:39 +0000
Message-ID: <f5e1eda1562bfd34276de07465525ae5f10e1e84.1732886067.git.asml.silence@gmail.com>
X-Mailer: git-send-email 2.47.1
In-Reply-To: <cover.1732886067.git.asml.silence@gmail.com>
References: <cover.1732886067.git.asml.silence@gmail.com>
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
 io_uring/memmap.c | 81 ++++++++++++++++++-----------------------------
 2 files changed, 31 insertions(+), 53 deletions(-)

diff --git a/io_uring/kbuf.c b/io_uring/kbuf.c
index 2dfb9f9419a0..e91260a6156b 100644
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
index 6d8a98bd9cac..dda846190fbd 100644
--- a/io_uring/memmap.c
+++ b/io_uring/memmap.c
@@ -254,6 +254,27 @@ int io_create_region_mmap_safe(struct io_ring_ctx *ctx, struct io_mapped_region
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
@@ -271,39 +292,12 @@ static void *io_uring_validate_mmap_request(struct file *file, loff_t pgoff,
 					    size_t sz)
 {
 	struct io_ring_ctx *ctx = file->private_data;
-	loff_t offset = pgoff << PAGE_SHIFT;
+	struct io_mapped_region *region;
 
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
-
-	return ERR_PTR(-EINVAL);
+	region = io_mmap_get_region(ctx, pgoff);
+	if (!region)
+		return ERR_PTR(-EINVAL);
+	return io_region_validate_mmap(ctx, region);
 }
 
 #ifdef CONFIG_MMU
@@ -324,7 +318,8 @@ __cold int io_uring_mmap(struct file *file, struct vm_area_struct *vma)
 	struct io_ring_ctx *ctx = file->private_data;
 	size_t sz = vma->vm_end - vma->vm_start;
 	long offset = vma->vm_pgoff << PAGE_SHIFT;
-	unsigned int page_limit;
+	unsigned int page_limit = UINT_MAX;
+	struct io_mapped_region *region;
 	void *ptr;
 
 	guard(mutex)(&ctx->mmap_lock);
@@ -337,25 +332,11 @@ __cold int io_uring_mmap(struct file *file, struct vm_area_struct *vma)
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
2.47.1


