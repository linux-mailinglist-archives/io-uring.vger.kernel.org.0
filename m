Return-Path: <io-uring+bounces-5141-lists+io-uring=lfdr.de@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from sy.mirrors.kernel.org (sy.mirrors.kernel.org [147.75.48.161])
	by mail.lfdr.de (Postfix) with ESMTPS id D59849DE7AE
	for <lists+io-uring@lfdr.de>; Fri, 29 Nov 2024 14:34:14 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sy.mirrors.kernel.org (Postfix) with ESMTPS id 4F7E0B20B8B
	for <lists+io-uring@lfdr.de>; Fri, 29 Nov 2024 13:34:12 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 3D61A19E98A;
	Fri, 29 Nov 2024 13:34:08 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="b26mwhFN"
X-Original-To: io-uring@vger.kernel.org
Received: from mail-ej1-f54.google.com (mail-ej1-f54.google.com [209.85.218.54])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8BE2019CCEC
	for <io-uring@vger.kernel.org>; Fri, 29 Nov 2024 13:34:06 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.218.54
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1732887248; cv=none; b=S4CqTOkeu0mxXDRcRZJu14E1Yk64OOQYzdSETipWUVYa0J3VJ+GCIeVbhz8B8oPbYETT8Yp04EKx6Uaub/ntnMuaGNP/rXSaOd731KrCk4/wbm9XxKNFBfB6egoSAclt4nBBWIOH3bAlmzPnRtfLrs+r+K+qXwurl+Q05i8ITvc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1732887248; c=relaxed/simple;
	bh=6Bd/a5v9AEqg0j98Oe5um3EMkG0fzT+YgEbObd2aOrE=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=fhVT1QQwUL6sWUFJY/zuV3V5WSYOAuhDPYS4hVlifVkmordchwcJU5AOrBaTdWrb/AFRl43GsC0tQfc1jGqYaiLVYNjabdiEdjtZjJ09gCyqY0rrRkXG54nBgiWiB5ps4BsIaZAcl+O4apxDXrRiAp4TuigFRTRutftlOs31SKc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=b26mwhFN; arc=none smtp.client-ip=209.85.218.54
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Received: by mail-ej1-f54.google.com with SMTP id a640c23a62f3a-a9a68480164so229043466b.3
        for <io-uring@vger.kernel.org>; Fri, 29 Nov 2024 05:34:06 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1732887245; x=1733492045; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=/UQKdyTiZH5uaJ1y0f+rSObixzhXikWpmqvSjDY1JnE=;
        b=b26mwhFNb+hYzv+hz6BzCyjb/XCRrsAQ0Z8voSogolDYXftVa501E+nS7C4bn7tD6/
         nIjCQUx8v9bOimRShXMBGhRkzS0pLH2NQ594WnIb1M0nAiHAiYwr0kFCNtQ8daLjMWqS
         ZBy7rsviP5aR2y7nRD6Sa10NkW6tyyQwtuIC2A2aR4Bpk6iLOkiOjyUyf0G2nqSilZ7C
         iRPnEK0a5qujA+4K5FJJEMKepb3DrbAIFl5ROR4CEtpMgNRQBKo9SXQjSYdabF8BCp7p
         A1WODe2lSB6g9MrMjVp0L84xXq5B+TA3Inl92RhqvDs6Pu4oreCrHpb6h4gMz+Pugp1q
         bedQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1732887245; x=1733492045;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=/UQKdyTiZH5uaJ1y0f+rSObixzhXikWpmqvSjDY1JnE=;
        b=Spo5OofvGlOhuRb/mcE4QHa5D8H4DsTf7QLm42emYAbO1Kk1oiel0Z/kKGyYpmdWMP
         xl1fJAtdI05PUSUE7rRm8JhQ6eO0zgC89Gd6pi8301nuDiM5Am+Qs/vNyGYccjvfOREt
         tyy/OD+iGSbl8E+YyLAblsuTTSmFxsutSAdZgrIWVaZYMI5AC/0kzQQbpcJgmwQ3E1cT
         NERlSFLJgwOSraREBKXPMSXPMP4fLZZSh7GOADoUSkgd0xF7YOZq2/JsQ45IvoInFv1P
         SFuvDB2gT/j6AbSRyT+6rno4eop7geK7o0n6CsCDeuDwPscnLrVGoHhIM8IB3mn51n9l
         J30Q==
X-Gm-Message-State: AOJu0YyUSDreqYGsjZXstJ1YAdz8Q59KvURU39sQ+zs5+4P5fFxb2q+t
	htMhr2VRO60zA6SaaQ/+Suv9b/DnK+jENwjXmU8BTDSoVa7dlwh3M3E7Hg==
X-Gm-Gg: ASbGnct0ZhE0t/AMVu+oJo6T9AyqF/9rQGf3P5bGcv3ZC/so5AZBAMK1FeXZEMgn4it
	WYpGQkMY7Ob3MnxOowzzRAptt371Ej7T1sA3dxhgWXPI0qY8rOoy6Jwu/n6UlKnz/Kd8XDHDaAU
	/6oKV4HmY7BsMa0f4ed2zecDN0X3mKopfyq61gAuDIJueB8GgKjQeQ62zB4DwLLkmD8l8LxZM1C
	D+QDRvlhwJFyOIjV2iqbTFDaLCNtD9lz18E9wtrzfYR1A5JIkrGcV4YeQyHvuam
X-Google-Smtp-Source: AGHT+IGmYMtMZQGdhO76urFlW/rbRxMhM/uSoEmMs8DAg49ruRtY7G8dZnYnShfOk1DW9C4Gq1CKPg==
X-Received: by 2002:a17:906:3d29:b0:aa4:8186:4e93 with SMTP id a640c23a62f3a-aa580ef37f6mr901087166b.1.1732887244445;
        Fri, 29 Nov 2024 05:34:04 -0800 (PST)
Received: from 127.0.0.1localhost ([163.114.131.193])
        by smtp.gmail.com with ESMTPSA id a640c23a62f3a-aa5996c2471sm173996866b.13.2024.11.29.05.34.04
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 29 Nov 2024 05:34:04 -0800 (PST)
From: Pavel Begunkov <asml.silence@gmail.com>
To: io-uring@vger.kernel.org
Cc: asml.silence@gmail.com
Subject: [PATCH v3 10/18] io_uring/memmap: implement kernel allocated regions
Date: Fri, 29 Nov 2024 13:34:31 +0000
Message-ID: <7b8c40e6542546bbf93f4842a9a42a7373b81e0d.1732886067.git.asml.silence@gmail.com>
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

Allow the kernel to allocate memory for a region. That's the classical
way SQ/CQ are allocated. It's not yet useful to user space as there
is no way to mmap it, which is why it's explicitly disabled in
io_register_mem_region().

Signed-off-by: Pavel Begunkov <asml.silence@gmail.com>
---
 io_uring/memmap.c   | 43 ++++++++++++++++++++++++++++++++++++++++---
 io_uring/register.c |  2 ++
 2 files changed, 42 insertions(+), 3 deletions(-)

diff --git a/io_uring/memmap.c b/io_uring/memmap.c
index a37ccb167258..0908a71bf57e 100644
--- a/io_uring/memmap.c
+++ b/io_uring/memmap.c
@@ -273,6 +273,39 @@ static int io_region_pin_pages(struct io_ring_ctx *ctx,
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
+	nr_allocated = alloc_pages_bulk_array_node(gfp, NUMA_NO_NODE,
+						   mr->nr_pages, pages);
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
@@ -283,9 +316,10 @@ int io_create_region(struct io_ring_ctx *ctx, struct io_mapped_region *mr,
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
@@ -304,7 +338,10 @@ int io_create_region(struct io_ring_ctx *ctx, struct io_mapped_region *mr,
 	}
 	mr->nr_pages = nr_pages;
 
-	ret = io_region_pin_pages(ctx, mr, reg);
+	if (reg->flags & IORING_MEM_REGION_TYPE_USER)
+		ret = io_region_pin_pages(ctx, mr, reg);
+	else
+		ret = io_region_allocate_pages(ctx, mr, reg);
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
2.47.1


