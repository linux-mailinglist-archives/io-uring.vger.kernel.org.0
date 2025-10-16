Return-Path: <io-uring+bounces-10039-lists+io-uring=lfdr.de@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [IPv6:2604:1380:45e3:2400::1])
	by mail.lfdr.de (Postfix) with ESMTPS id F179CBE3ABA
	for <lists+io-uring@lfdr.de>; Thu, 16 Oct 2025 15:22:25 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 4E0483BB854
	for <lists+io-uring@lfdr.de>; Thu, 16 Oct 2025 13:22:20 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 6FD922417D1;
	Thu, 16 Oct 2025 13:22:17 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="CR0W+avm"
X-Original-To: io-uring@vger.kernel.org
Received: from mail-wm1-f41.google.com (mail-wm1-f41.google.com [209.85.128.41])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9151E1FDA82
	for <io-uring@vger.kernel.org>; Thu, 16 Oct 2025 13:22:15 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.128.41
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1760620937; cv=none; b=jkiVv+jCxKyCEeOEOwEYgDuUcCznCN234AQ1jj+JOpxWdXjRAA8QzY7lokRkHLgMwjUnIC9kHRQJO9E9DpoZ9Wg5q+/qYOti1iZ1Iy8fhzQXx7sgU2CjGNTTvvy220FPg5QY9fnA5a93hjhcv+4HJyDCjeBP6CghrUxZXeG0l30=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1760620937; c=relaxed/simple;
	bh=k+0RSGIlge1rBX1fjwUzceAMVDiyoCaTau4ud4/+ot8=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=jhTMYEEKRp5xTMe+KV9LaT9k2Hh1UvYvZI5DXSW0U52NEKxCUte1ueIf1IbmlobWb7ipcNH79L2u8xke57F/zUFchFD3QSXR0fpNgG6BGMR1ks9ay4NtEk2elmaTv1pWTAcX4IHX2AOHRUKWLdnzEmar7h+AxAGM9o91dc8XdfE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=CR0W+avm; arc=none smtp.client-ip=209.85.128.41
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Received: by mail-wm1-f41.google.com with SMTP id 5b1f17b1804b1-47103b6058fso5522005e9.1
        for <io-uring@vger.kernel.org>; Thu, 16 Oct 2025 06:22:15 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1760620933; x=1761225733; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=v9h+4YJ9vTud1BMEp64YwrzYNz8R5Fy5uCsd7jRqnc0=;
        b=CR0W+avmSR72nROUQAjMlo6z/dlzy7QNnOmq7YNBQ4vhIAMn6uGROWZINPFBz8LiXG
         C0bLF7L9Skr97n35zpjHmV7RjO1RJrZLl8pKl6UK/tkwqgkPl5R56a5JI93dB2iI8SH2
         FChmpD6JHGYX41ILrklt+Z5d0RiHsbip0K0l6Nw+hVEdhzmr/3/9lR5E+NB7x77AAyTM
         6ipUCp0z7SHuuQMq9z9UvbaxGk+jJajSyylNUOF4E8ml+ItsGYWyiJ9IS0g00erPIgQQ
         iH3mUkIxrLU2OkLL8tJJf8yt5dy3OGlzbw+EHzDW1A+1ZH0IqaEV17v6jzBRNGUaZ1Ss
         Z/vQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1760620933; x=1761225733;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=v9h+4YJ9vTud1BMEp64YwrzYNz8R5Fy5uCsd7jRqnc0=;
        b=L47fwdv4eV5JWFmtQ8A6Lt0BmHsxfsOj9s9kfjKvjF0OGzUYm43EFRnFsS+Ou3Q81s
         rMs5xSk23XeHI8hALpiBf1eU969cj3MWecibQiGQHH7FGUSiWIR1MrAZFW5n3cTTYrD2
         kFg8aDAVPZ8J07uO9QsslERuxQoVF5JRaDP2kDQhqtg+wG2IUZqudvVdifHezAWeMhKp
         TF14ftUaNSt9eMvUvyfACYefJyR+B/sgNtV6kcq90R355MCTvESlD6dUwI1L3OBmh2ma
         WZcD86ig2lCQMwRv0EBoHOXjjInMTHk+8Bv0HXoKfZWlczIg5j5uelTutUA+wiui/aC1
         rkEA==
X-Gm-Message-State: AOJu0Yx/ergqz+E1vDDiz/28QPhfnwnnCyzvhUmcWWqmUB4Nz/gNTryK
	owYLFyIGMXvChQjVt/g+zjWgfyxCJUmycLdGXS3idL2xotTevujIC4XE3oVD3g==
X-Gm-Gg: ASbGncsU9MAbq8zVqfBEGXWCPPzSBCTw1k2G59thmsSitUPihucEUcrT4JWIAIcFUPE
	1Oo0JVGsA75ZKHABpO6Cv9rIUBiZ8Ue3sza2eardSkoG2XVT5L4QhRtbFOBQIdlnt6IZYzkRroA
	ACYyDmpwmaxS4SbBoZSPrxC9KQ9x1+qhbhG8FAvy2yIeGtIqIInwwPvNovE0LVrZlzjViUnzZ9/
	CrYKDsssDCLGr5wMCSbrgbE91C3GtS1bGGxDIa2XzirhIzqyk3WHq4J0GXqWAeBtBI+J20kme0y
	Dnr4MaLYQK7HF0YaL+wDZnqyy31teLCyNFWpiOkHICMHnS5kxPkgg5ekob/kZrn34cvsF5zEWtg
	GxM5Zyk5Gdd57f5ZkkfZ5kukcPwv7KTGprt3rCs5rJm3ZeR3+s+kQ9k96wCB9EfIVQv38ASrDpg
	JA5IyH
X-Google-Smtp-Source: AGHT+IEv5mo1WQfKCCYPkLgQ8izPIzOlUa2WSR6zH7K8kdjNElr+681bUTVkeL6xR1wm3PfxUYdb+Q==
X-Received: by 2002:a05:600c:3b23:b0:46d:1a9b:6d35 with SMTP id 5b1f17b1804b1-47117300e79mr1392285e9.14.1760620933352;
        Thu, 16 Oct 2025 06:22:13 -0700 (PDT)
Received: from 127.com ([2620:10d:c092:600::1:2b54])
        by smtp.gmail.com with ESMTPSA id 5b1f17b1804b1-471144239bdsm41834385e9.3.2025.10.16.06.22.12
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 16 Oct 2025 06:22:12 -0700 (PDT)
From: Pavel Begunkov <asml.silence@gmail.com>
To: io-uring@vger.kernel.org
Cc: asml.silence@gmail.com
Subject: [PATCH 7/7] io_uring: only publish fully handled mem region
Date: Thu, 16 Oct 2025 14:23:23 +0100
Message-ID: <b2409b3f4e628cd0c10f5d70be54cb0121917ae5.1760620698.git.asml.silence@gmail.com>
X-Mailer: git-send-email 2.49.0
In-Reply-To: <cover.1760620698.git.asml.silence@gmail.com>
References: <cover.1760620698.git.asml.silence@gmail.com>
Precedence: bulk
X-Mailing-List: io-uring@vger.kernel.org
List-Id: <io-uring.vger.kernel.org>
List-Subscribe: <mailto:io-uring+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:io-uring+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

io_register_mem_region() can try to remove a region right after
publishing it. This non-atomicity is annoying. Do it in two steps
similar to io_register_mem_region(), create memory first and publish it
once the rest of the handling is done. Remove now unused
io_create_region_mmap_safe(), which was assumed to be a temporary
solution from day one.

Signed-off-by: Pavel Begunkov <asml.silence@gmail.com>
---
 io_uring/memmap.c   | 21 ---------------------
 io_uring/memmap.h   | 12 ++++++++++++
 io_uring/register.c | 11 ++++++-----
 3 files changed, 18 insertions(+), 26 deletions(-)

diff --git a/io_uring/memmap.c b/io_uring/memmap.c
index 2e99dffddfc5..aa388ecd4754 100644
--- a/io_uring/memmap.c
+++ b/io_uring/memmap.c
@@ -234,27 +234,6 @@ int io_create_region(struct io_ring_ctx *ctx, struct io_mapped_region *mr,
 	return ret;
 }
 
-int io_create_region_mmap_safe(struct io_ring_ctx *ctx, struct io_mapped_region *mr,
-				struct io_uring_region_desc *reg,
-				unsigned long mmap_offset)
-{
-	struct io_mapped_region tmp_mr;
-	int ret;
-
-	memcpy(&tmp_mr, mr, sizeof(tmp_mr));
-	ret = io_create_region(ctx, &tmp_mr, reg, mmap_offset);
-	if (ret)
-		return ret;
-
-	/*
-	 * Once published mmap can find it without holding only the ->mmap_lock
-	 * and not ->uring_lock.
-	 */
-	guard(mutex)(&ctx->mmap_lock);
-	memcpy(mr, &tmp_mr, sizeof(tmp_mr));
-	return 0;
-}
-
 static struct io_mapped_region *io_mmap_get_region(struct io_ring_ctx *ctx,
 						   loff_t pgoff)
 {
diff --git a/io_uring/memmap.h b/io_uring/memmap.h
index 08419684e4bc..58002976e0c3 100644
--- a/io_uring/memmap.h
+++ b/io_uring/memmap.h
@@ -36,4 +36,16 @@ static inline bool io_region_is_set(struct io_mapped_region *mr)
 	return !!mr->nr_pages;
 }
 
+static inline void io_region_publish(struct io_ring_ctx *ctx,
+				     struct io_mapped_region *src_region,
+				     struct io_mapped_region *dst_region)
+{
+	/*
+	 * Once published mmap can find it without holding only the ->mmap_lock
+	 * and not ->uring_lock.
+	 */
+	guard(mutex)(&ctx->mmap_lock);
+	*dst_region = *src_region;
+}
+
 #endif
diff --git a/io_uring/register.c b/io_uring/register.c
index b11550ed940c..43eb02004824 100644
--- a/io_uring/register.c
+++ b/io_uring/register.c
@@ -576,6 +576,7 @@ static int io_register_mem_region(struct io_ring_ctx *ctx, void __user *uarg)
 	struct io_uring_mem_region_reg reg;
 	struct io_uring_region_desc __user *rd_uptr;
 	struct io_uring_region_desc rd;
+	struct io_mapped_region region = {};
 	int ret;
 
 	if (io_region_is_set(&ctx->param_region))
@@ -599,20 +600,20 @@ static int io_register_mem_region(struct io_ring_ctx *ctx, void __user *uarg)
 	    !(ctx->flags & IORING_SETUP_R_DISABLED))
 		return -EINVAL;
 
-	ret = io_create_region_mmap_safe(ctx, &ctx->param_region, &rd,
-					 IORING_MAP_OFF_PARAM_REGION);
+	ret = io_create_region(ctx, &region, &rd, IORING_MAP_OFF_PARAM_REGION);
 	if (ret)
 		return ret;
 	if (copy_to_user(rd_uptr, &rd, sizeof(rd))) {
-		guard(mutex)(&ctx->mmap_lock);
-		io_free_region(ctx, &ctx->param_region);
+		io_free_region(ctx, &region);
 		return -EFAULT;
 	}
 
 	if (reg.flags & IORING_MEM_REGION_REG_WAIT_ARG) {
-		ctx->cq_wait_arg = io_region_get_ptr(&ctx->param_region);
+		ctx->cq_wait_arg = io_region_get_ptr(&region);
 		ctx->cq_wait_size = rd.size;
 	}
+
+	io_region_publish(ctx, &region, &ctx->param_region);
 	return 0;
 }
 
-- 
2.49.0


