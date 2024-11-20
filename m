Return-Path: <io-uring+bounces-4897-lists+io-uring=lfdr.de@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [139.178.88.99])
	by mail.lfdr.de (Postfix) with ESMTPS id BFC099D448B
	for <lists+io-uring@lfdr.de>; Thu, 21 Nov 2024 00:33:40 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 7E0932832BE
	for <lists+io-uring@lfdr.de>; Wed, 20 Nov 2024 23:33:39 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id E79671BDA84;
	Wed, 20 Nov 2024 23:33:18 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="h9R1VwFQ"
X-Original-To: io-uring@vger.kernel.org
Received: from mail-ed1-f45.google.com (mail-ed1-f45.google.com [209.85.208.45])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1B6051BDA80
	for <io-uring@vger.kernel.org>; Wed, 20 Nov 2024 23:33:16 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.208.45
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1732145598; cv=none; b=JDFqrOEZhPGt8t3pyiMMNQ0EYZaMM6VNiXDckdKM8qsHOicDwmfxKGgr+xjlMn8+crZwRobcQri1OtYnYOgPxYPIKy65JDApEOV5HiNANXnck2TbiVdRzDXXe6hdJZTi825eo6DXoz6+gqmxa33gyjtOpuzMWTZtUovI25kdIrM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1732145598; c=relaxed/simple;
	bh=Ojbg/pyG/fWFfozOjF7t6/LoeMXwPm8VkT4/RWIuwuo=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=UP/9aTQoW3YPTC4gIjTkWkMzEt6S3VCArrU7PVPCgp6Yt1NLVbuVNCRsFaEUEbH5+X9BPDMdONL4Kqed7AQBA8YXmUc+ycXGqOjNzmeplvW/tlMaqacaeQ/hLF/E0Z4gyoAltPoNJJsOqtlhiY5l0G19Iy+0oxghaeXhfDwyAWc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=h9R1VwFQ; arc=none smtp.client-ip=209.85.208.45
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Received: by mail-ed1-f45.google.com with SMTP id 4fb4d7f45d1cf-5cfc19065ffso286261a12.3
        for <io-uring@vger.kernel.org>; Wed, 20 Nov 2024 15:33:16 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1732145595; x=1732750395; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=HuAPtcJgL3o5hKcE460Eafo6KlyiNWFiJdD3Q2BBUe8=;
        b=h9R1VwFQv5wt1LijTlaSJV4whMQjXPrkWV/0GC0RGc7g8s5HWFTF7TLNmc2HBwWFXj
         tLpDwpRmS1wBCp74B21eIoktsd3jgI6end+FWqpWC9DNwmxlESTYpv94JayMdWg4Ccln
         Z2d7G3OZjvN9I7Sxt4lpgC88hGTpcw8VqlC9wFdAiI+1ejEmdANIUwGo8c1sj+lrVNg5
         qW4AIqDNiK0qseHNFLCgG9tB1z/RmD7mFtnAy9hpDLfhcjdZgq4KtAuEUyi72Co1TQsk
         ZevwiHCUq+V+xldJ4wA/bhiFNS2flZC9LjHZAcKFEP5EaP/35DsO7D5CSOiO/G8uX6oB
         9FVQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1732145595; x=1732750395;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=HuAPtcJgL3o5hKcE460Eafo6KlyiNWFiJdD3Q2BBUe8=;
        b=PU0sL9ApUady0RGbrPjk75816SZNGCEKuiGFxNi0uP4b48LOzNQh5KFswfXX0qCr8a
         IB44VCVf0/C7Jwkp99oeHe/fJ5DJyaTkoYmXg2A48cat6mTzmtMlgwOSnt17HaCaR5pX
         VMViegDYcLSudpF+fRpVTmd9RolGPJ6FlxHmhUpmSJdBtUiNeLLzhPLkiupXr3ab85K4
         SZ4xkPGI4VTTR+Kt9k7MXikFGp5X6jmbH5DxNtLN3+/rAcZdfLX2IMZo4rJEUC/22Wup
         EUYhlKEGOV3C4WUiHw5/NgXgSHx6p9dZx1GPYyDwpE+9re9W58RPCRlpQ3rKuOZvJmRI
         53hw==
X-Gm-Message-State: AOJu0YzGmwUEvuvI0rDg0K3PVfeE9uywzDmgteAUKe7LHNFq2dGkn9mU
	IPabwPVjmnuRMP1rmaS4ChncPsqECwQWImH9dchUYIPORRS5CyvrM/z0Rg==
X-Gm-Gg: ASbGncvrxiWs3mzPKdoFWJyozR2kexQgLpSN3DmkQqjN9HySQ57PQ2Jcj54bebK0Wvq
	zyERbq8QFBVhbZmGScONDHNY/8RXxLnxrKFEr7LkcbFprmj2hubD1Hw48IqFDSwbi/+DwBfV68u
	6ZjZvq6RyhIreQgd8z4z9oxdvnohQ/apxuQ9oR21l0YvpwqgjjIrueANFTK/7c763bYAb32AaQG
	OtUvdRlSZRsSdKwUtDM4F+rnXp6LQ78sCG7w47x1l/hCaflPYAhLB2bs4dSYkOD
X-Google-Smtp-Source: AGHT+IEKV+EtifM6EBVWu4s4rPv+rgk+a9A4sxkLdHwTEXFfr76ZnOCtbb5hAmcwFDvpgiSw4I6LYA==
X-Received: by 2002:a17:907:7242:b0:a99:4aa7:4d6f with SMTP id a640c23a62f3a-aa4dd50d3d7mr397922966b.12.1732145595087;
        Wed, 20 Nov 2024 15:33:15 -0800 (PST)
Received: from 127.0.0.1localhost ([148.252.141.165])
        by smtp.gmail.com with ESMTPSA id a640c23a62f3a-aa4f415372bsm12166066b.13.2024.11.20.15.33.14
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 20 Nov 2024 15:33:14 -0800 (PST)
From: Pavel Begunkov <asml.silence@gmail.com>
To: io-uring@vger.kernel.org
Cc: asml.silence@gmail.com
Subject: [PATCH 10/11] io_uring/memmap: implement kernel allocated regions
Date: Wed, 20 Nov 2024 23:33:33 +0000
Message-ID: <fa3707470d34967935b25cf4dbcacf23f609dda2.1732144783.git.asml.silence@gmail.com>
X-Mailer: git-send-email 2.46.0
In-Reply-To: <cover.1732144783.git.asml.silence@gmail.com>
References: <cover.1732144783.git.asml.silence@gmail.com>
Precedence: bulk
X-Mailing-List: io-uring@vger.kernel.org
List-Id: <io-uring.vger.kernel.org>
List-Subscribe: <mailto:io-uring+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:io-uring+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

Allow the kernel to allocate memory for a region. That's the classical
way SQ/CQ are allocated. It's not yet useful to user space as there
is no way to mmap it, which is why it's explicitly disabled in
io_register_mem_region().

Signed-off-by: Pavel Begunkov <asml.silence@gmail.com>
---
 io_uring/memmap.c   | 44 +++++++++++++++++++++++++++++++++++++++++---
 io_uring/register.c |  2 ++
 2 files changed, 43 insertions(+), 3 deletions(-)

diff --git a/io_uring/memmap.c b/io_uring/memmap.c
index cdd620bdd3ee..8598770bc385 100644
--- a/io_uring/memmap.c
+++ b/io_uring/memmap.c
@@ -263,6 +263,39 @@ static int io_region_pin_pages(struct io_ring_ctx *ctx,
 	return 0;
 }
 
+static int io_region_allocate_pages(struct io_ring_ctx *ctx,
+				    struct io_mapped_region *mr,
+				    struct io_uring_region_desc *reg)
+{
+	gfp_t gfp = GFP_KERNEL_ACCOUNT | __GFP_ZERO | __GFP_NOWARN;
+	unsigned long size = mr->nr_pages << PAGE_SHIFT;
+	unsigned long nr_allocated;
+	struct page **pages;
+	void *p;
+
+	pages = kvmalloc_array(mr->nr_pages, sizeof(*pages), gfp);
+	if (!pages)
+		return -ENOMEM;
+
+	p = io_mem_alloc_compound(pages, mr->nr_pages, size, gfp);
+	if (!IS_ERR(p)) {
+		mr->flags |= IO_REGION_F_SINGLE_REF;
+		mr->pages = pages;
+		return 0;
+	}
+
+	nr_allocated = alloc_pages_bulk_noprof(gfp, numa_node_id(), NULL,
+					       mr->nr_pages, NULL, pages);
+	if (nr_allocated != mr->nr_pages) {
+		if (nr_allocated)
+			release_pages(pages, nr_allocated);
+		kvfree(pages);
+		return -ENOMEM;
+	}
+	mr->pages = pages;
+	return 0;
+}
+
 int io_create_region(struct io_ring_ctx *ctx, struct io_mapped_region *mr,
 		     struct io_uring_region_desc *reg)
 {
@@ -273,9 +306,10 @@ int io_create_region(struct io_ring_ctx *ctx, struct io_mapped_region *mr,
 		return -EFAULT;
 	if (memchr_inv(&reg->__resv, 0, sizeof(reg->__resv)))
 		return -EINVAL;
-	if (reg->flags != IORING_MEM_REGION_TYPE_USER)
+	if (reg->flags & ~IORING_MEM_REGION_TYPE_USER)
 		return -EINVAL;
-	if (!reg->user_addr)
+	/* user_addr should be set IFF it's a user memory backed region */
+	if ((reg->flags & IORING_MEM_REGION_TYPE_USER) != !!reg->user_addr)
 		return -EFAULT;
 	if (!reg->size || reg->mmap_offset || reg->id)
 		return -EINVAL;
@@ -294,9 +328,13 @@ int io_create_region(struct io_ring_ctx *ctx, struct io_mapped_region *mr,
 	}
 	mr->nr_pages = nr_pages;
 
-	ret = io_region_pin_pages(ctx, mr, reg);
+	if (reg->flags & IORING_MEM_REGION_TYPE_USER)
+		ret = io_region_pin_pages(ctx, mr, reg);
+	else
+		ret = io_region_allocate_pages(ctx, mr, reg);
 	if (ret)
 		goto out_free;
+
 	ret = io_region_init_ptr(mr);
 	if (ret)
 		goto out_free;
diff --git a/io_uring/register.c b/io_uring/register.c
index ba61697d7a53..f043d3f6b026 100644
--- a/io_uring/register.c
+++ b/io_uring/register.c
@@ -586,6 +586,8 @@ static int io_register_mem_region(struct io_ring_ctx *ctx, void __user *uarg)
 	if (copy_from_user(&rd, rd_uptr, sizeof(rd)))
 		return -EFAULT;
 
+	if (!(rd.flags & IORING_MEM_REGION_TYPE_USER))
+		return -EINVAL;
 	if (memchr_inv(&reg.__resv, 0, sizeof(reg.__resv)))
 		return -EINVAL;
 	if (reg.flags & ~IORING_MEM_REGION_REG_WAIT_ARG)
-- 
2.46.0


