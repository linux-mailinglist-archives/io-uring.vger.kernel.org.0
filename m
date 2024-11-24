Return-Path: <io-uring+bounces-5017-lists+io-uring=lfdr.de@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from sy.mirrors.kernel.org (sy.mirrors.kernel.org [IPv6:2604:1380:40f1:3f00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 6C2849D783E
	for <lists+io-uring@lfdr.de>; Sun, 24 Nov 2024 22:12:20 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sy.mirrors.kernel.org (Postfix) with ESMTPS id AAD2FB21F24
	for <lists+io-uring@lfdr.de>; Sun, 24 Nov 2024 21:12:17 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 55C6713FD72;
	Sun, 24 Nov 2024 21:12:16 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="eKhu1FoK"
X-Original-To: io-uring@vger.kernel.org
Received: from mail-wm1-f53.google.com (mail-wm1-f53.google.com [209.85.128.53])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 985E215A848
	for <io-uring@vger.kernel.org>; Sun, 24 Nov 2024 21:12:14 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.128.53
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1732482736; cv=none; b=G0+GzKVgVRgS74R5+TRd1myq9M5KCxyuFvVrgXgGUkFqwuFzxElCyuSU07/E2y0q6gUVPo3KHhSrvxAwdh0bFU1jBBYP/x0xGc1u/9AvUptyEr28OYfyddgDbg5bbccVk/IvqNq5R/Y864hrYLJK3c4ULF8FDp5qz+71Uc3Rc9M=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1732482736; c=relaxed/simple;
	bh=Ojbg/pyG/fWFfozOjF7t6/LoeMXwPm8VkT4/RWIuwuo=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=YVieGsuMQWhBWB/fjb/e9pDSsxgc/VdFFexu70Fj4pJrycNMWvTGd5eAA4goWRtuzoylAZhkx5w4uT99djXijFLTNkhN8U8N2At0B3paLbMYr7iVItT9oOu8B/0WnGLul2gJeG7vVkjd0kCMbRSZINelzW2yWZNhJ67XDqjkQ7I=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=eKhu1FoK; arc=none smtp.client-ip=209.85.128.53
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Received: by mail-wm1-f53.google.com with SMTP id 5b1f17b1804b1-4315f24a6bbso32132115e9.1
        for <io-uring@vger.kernel.org>; Sun, 24 Nov 2024 13:12:14 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1732482733; x=1733087533; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=HuAPtcJgL3o5hKcE460Eafo6KlyiNWFiJdD3Q2BBUe8=;
        b=eKhu1FoKQVQdeWiIU3sLyvDjX6fA8ZW1KySaPy9mvyGr1cQikg3mhM2ZdrKvtJd6mh
         GXsMumbh+npJM633ZOt0Sc1rdjzejQsb4908r2oh59fDOVdCrfNHLHa/fGlTRHJ+g+XN
         rSUj+Qlx8HhUP9BFjnV0xqkKzUsx2zVp26HQ+bNIDFUozQVEcOYGBlA/xjckrK+VJWJT
         YfwQRAiYfY9BEdZOCADS4/FaUiIYcHEPxvcmx6St+qYlBl35JcZY21FgSxTKUdwnEUza
         8Rb0HM5aGlD1djm7TEECrsu42eBLxd0Jma3w8eHKIVgNzlgc7cdv3rHdEp6ick0h4cAl
         UvjA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1732482733; x=1733087533;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=HuAPtcJgL3o5hKcE460Eafo6KlyiNWFiJdD3Q2BBUe8=;
        b=q1Dbh+z34X+t94CHlqXMEw2PuTOOi0Y4bcVjboc0nwVIJG1dCe9t2fLVrQ2BND7Eve
         9SJdOPg/xwsWU5sSVGyZKDkPPPdItxMRGrTMFR0qIOqbodUopY4ehddlFLMDFuQFOZhO
         plnqSrPMvxUdMtdRcT6cXXVt2zkyUjEcffZtynp55hc9Gdk+OMYW0IvwLcsBBZ15u/4C
         GzGUimMXGJnGxlndysj5mED9LKb4zNrvmMidnSdnTbW8Ywqek8dZn0eBo2XqWCQKlMt8
         uWD49Kx90tUm6WEdhcUV16PrHRoc8M0c+xQiPG280PrHmgWEpv1w/Xm2APeO15FIAtvu
         rVJQ==
X-Gm-Message-State: AOJu0YzQQmPZk6jPmYjIB78V8d1sJ77rxd567maZbWS5BaL0Xr3qYPgx
	POOUl3i4x7Zk+bnoI4Lf9mUPcmf2ehpO/hTFkOmErPUjewVPueRYg/D1Cg==
X-Gm-Gg: ASbGncs7AE4lJm4iGEwy5k3gN9rFX0KlxZX4XLax4T8Xvv3vtb4UyOlqfwk+TuJ6Akp
	uavGLt5mBZiDnDK1KERI8Kb1XGBYI0XRdD8+y9t5dz64CXeZ/yqy0nFHHO5eedLQGpGGEzbXpGy
	BsOJSbl9LWI/FlakyWkUCVrzSK3iLeSNdL1Cu3nEYhQw/mVdn2bQ0LV8tOHGrH9EFoddXneTwjx
	mLiEIwmzHIst7dZd9bU6p44GkMa96a7AzXIEysbPPJoZsKYfzKW1MvSt8tWxDg=
X-Google-Smtp-Source: AGHT+IGAj+cll/siFaAuCJRudSw1QW7TbwmjdYDBUMr4tX9aschVIPIEmUX8r8/ee0KyWnazjGFGSQ==
X-Received: by 2002:a05:600c:1d0f:b0:430:54a4:5b03 with SMTP id 5b1f17b1804b1-433ce420a72mr83342015e9.6.1732482732703;
        Sun, 24 Nov 2024 13:12:12 -0800 (PST)
Received: from 127.0.0.1localhost ([85.255.235.224])
        by smtp.gmail.com with ESMTPSA id 5b1f17b1804b1-432f643b299sm132733745e9.0.2024.11.24.13.12.11
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sun, 24 Nov 2024 13:12:12 -0800 (PST)
From: Pavel Begunkov <asml.silence@gmail.com>
To: io-uring@vger.kernel.org
Cc: asml.silence@gmail.com
Subject: [PATCH v2 10/18] io_uring/memmap: implement kernel allocated regions
Date: Sun, 24 Nov 2024 21:12:27 +0000
Message-ID: <ac94993483502474e2afccb87d03c193e41c0f50.1732481694.git.asml.silence@gmail.com>
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


