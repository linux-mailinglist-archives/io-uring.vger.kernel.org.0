Return-Path: <io-uring+bounces-5132-lists+io-uring=lfdr.de@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [147.75.199.223])
	by mail.lfdr.de (Postfix) with ESMTPS id 4D6C19DE7A4
	for <lists+io-uring@lfdr.de>; Fri, 29 Nov 2024 14:34:05 +0100 (CET)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id CF466164364
	for <lists+io-uring@lfdr.de>; Fri, 29 Nov 2024 13:33:59 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id B85F919E83E;
	Fri, 29 Nov 2024 13:34:01 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="ILN2QUae"
X-Original-To: io-uring@vger.kernel.org
Received: from mail-ej1-f52.google.com (mail-ej1-f52.google.com [209.85.218.52])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D672319CC27
	for <io-uring@vger.kernel.org>; Fri, 29 Nov 2024 13:33:59 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.218.52
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1732887241; cv=none; b=C8aegCkn7E1l60yxrXB3a3LMdzVZNTZsgc9GWz/kCgfn8Wf/mnu+xVjTOX5vJ54S6NIgKT7axhG5b2BFGLV6pxO+BfM3x7rjlGenHjYjlFQyPs/5ILdeWrFujxcJltqM36saLTCNmROrm2anzWheCaygbYPZIwxKn7tGu1R0l/s=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1732887241; c=relaxed/simple;
	bh=CCi4Jix1uDK9GQZ7mtxGXbPW/dWToASaiUqwAxORkwY=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=iYEL+lTroeCJoYPs3xEJ8oDN32echfY73uOjm2il0bDggX+49sompz67HSczwJl03jjCpxGINVC/Gj/rcHJJx4BJ1SeMIhmVY9XDWia9y/kfr95YPbpmlHHs6C22ZY5uhdO2iFssFRPFTiac3g02qwJrVe6gQLDMTpKycUp+Ho4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=ILN2QUae; arc=none smtp.client-ip=209.85.218.52
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Received: by mail-ej1-f52.google.com with SMTP id a640c23a62f3a-aa549d9dffdso254434666b.2
        for <io-uring@vger.kernel.org>; Fri, 29 Nov 2024 05:33:59 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1732887238; x=1733492038; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=HGyGpWFvQ4t6xuQJn1Ep7HeBT0Y2mnZvrg/LEd7v9FA=;
        b=ILN2QUae2qJ40VqhBjryOAjy7aVXYWSePFichVJby+OxDLhM3E7ewt/bWRvyj79vQ3
         8iznIwo47We4i2aBgL02ppZqcbOMkNSpXaYy6VDdSYcaZ0iLy/IZ7RB6jyMENg9hv38i
         5iOCkggfXrqb6qFLzYM3Kw5NiU/EbvYwcG+chr48c2MxdT4Lw23bFnjebLm2tmc9HMCp
         iiIi1lEYPIjQcZlLMVaaD4d8DKGPa54J9mLvI1cFI4r3jH2755VGtFILYEGL3AEI4FET
         NVtLWE/rBvkxKCcxdHEZbKp+6B8LYFkhr2fE6/BI8XYu3UHawjXuDG8DzM8ARSNKLt5Q
         NNxQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1732887238; x=1733492038;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=HGyGpWFvQ4t6xuQJn1Ep7HeBT0Y2mnZvrg/LEd7v9FA=;
        b=uVNqRsjZniB3eaHldkq/ChWX8lRg9Y9Jzh/WeEfU6aAZrfRjZdxZ1eYsDjMZ94N5km
         X0F6amkLFSwc20T35WnyyDELm17UUdD+lJnB2lXVPxyYnhogFrX7m2NaSxUZ5wkkEnW8
         EGgt1+q/TZRjks+xJwpwQfcPY102qFi90w/TJPpyo3TiGmCj2+IVG2pJa0kyZiYSqZPj
         RN4IbOwuCbZCYl3ex10I1op7LWeozITl5A8JxEzwDy8XLfeaZscZ/3FLi+aLg8CBuFxz
         e1VsrrDdDrcG7WPe/qxA78801zGgtUYpjnaOmlm9hou7M7rwALs75imIbUTZoxLMi+oj
         K+1Q==
X-Gm-Message-State: AOJu0YzAdWfb4+zPMNW2H1MK/vYD+86Cl0vPaEacHCj+C2WVe2r2TGmf
	e2yWwxQjGFe4OFXSUuAPpdqOOuOCU47xZ0D1Eg0CNq9P4J08ibjbBeKFXQ==
X-Gm-Gg: ASbGncvMN1E7RWZLVNoJSOI3j2RZkeKkqmctQ7Xmhny3BL//3ZHF+phRUTv8qyH519z
	M9UwW87oNfLsL9RxFOIK71GCaGUW93IRGcydClHfvrC41vY0o8pUZTtoLowt5mSP6LHaC4+S4R8
	3moD39R+wCGzTYKvt0p9vHvaN/Vagay2VmV9OJ7qew4UNkEc8yMSFPrTJfvkJqHo82xpDQ46gmp
	Nr5+ln/DqN49BR5lhPtpvpxHbpYD4VwpjZzEHpb2/hxVvED5feO+CdVif4gXsBO
X-Google-Smtp-Source: AGHT+IF6V+WpI2m2lFCw9V9kU+mgpmhycxyl5zmaRsXQiiIPWim7xoFpqI5JFdw3zaOGOvN7OM53SQ==
X-Received: by 2002:a17:906:2192:b0:aa4:fc7c:ea6d with SMTP id a640c23a62f3a-aa580f2c4a3mr939871666b.17.1732887237643;
        Fri, 29 Nov 2024 05:33:57 -0800 (PST)
Received: from 127.0.0.1localhost ([163.114.131.193])
        by smtp.gmail.com with ESMTPSA id a640c23a62f3a-aa5996c2471sm173996866b.13.2024.11.29.05.33.57
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 29 Nov 2024 05:33:57 -0800 (PST)
From: Pavel Begunkov <asml.silence@gmail.com>
To: io-uring@vger.kernel.org
Cc: asml.silence@gmail.com
Subject: [PATCH v3 01/18] io_uring: rename ->resize_lock
Date: Fri, 29 Nov 2024 13:34:22 +0000
Message-ID: <68f705306f3ac4d2fb999eb80ea1615015ce9f7f.1732886067.git.asml.silence@gmail.com>
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

->resize_lock is used for resizing rings, but it's a good idea to reuse
it in other cases as well. Rename it into mmap_lock as it's protects
from races with mmap.

Signed-off-by: Pavel Begunkov <asml.silence@gmail.com>
---
 include/linux/io_uring_types.h | 2 +-
 io_uring/io_uring.c            | 2 +-
 io_uring/memmap.c              | 6 +++---
 io_uring/register.c            | 8 ++++----
 4 files changed, 9 insertions(+), 9 deletions(-)

diff --git a/include/linux/io_uring_types.h b/include/linux/io_uring_types.h
index 3e934feb3187..adb36e0da40e 100644
--- a/include/linux/io_uring_types.h
+++ b/include/linux/io_uring_types.h
@@ -423,7 +423,7 @@ struct io_ring_ctx {
 	 * side will need to grab this lock, to prevent either side from
 	 * being run concurrently with the other.
 	 */
-	struct mutex			resize_lock;
+	struct mutex			mmap_lock;
 
 	/*
 	 * If IORING_SETUP_NO_MMAP is used, then the below holds
diff --git a/io_uring/io_uring.c b/io_uring/io_uring.c
index ae199e44da57..c713ef35447b 100644
--- a/io_uring/io_uring.c
+++ b/io_uring/io_uring.c
@@ -351,7 +351,7 @@ static __cold struct io_ring_ctx *io_ring_ctx_alloc(struct io_uring_params *p)
 	INIT_WQ_LIST(&ctx->submit_state.compl_reqs);
 	INIT_HLIST_HEAD(&ctx->cancelable_uring_cmd);
 	io_napi_init(ctx);
-	mutex_init(&ctx->resize_lock);
+	mutex_init(&ctx->mmap_lock);
 
 	return ctx;
 
diff --git a/io_uring/memmap.c b/io_uring/memmap.c
index 57de9bccbf50..a0d4151d11af 100644
--- a/io_uring/memmap.c
+++ b/io_uring/memmap.c
@@ -329,7 +329,7 @@ __cold int io_uring_mmap(struct file *file, struct vm_area_struct *vma)
 	unsigned int npages;
 	void *ptr;
 
-	guard(mutex)(&ctx->resize_lock);
+	guard(mutex)(&ctx->mmap_lock);
 
 	ptr = io_uring_validate_mmap_request(file, vma->vm_pgoff, sz);
 	if (IS_ERR(ptr))
@@ -365,7 +365,7 @@ unsigned long io_uring_get_unmapped_area(struct file *filp, unsigned long addr,
 	if (addr)
 		return -EINVAL;
 
-	guard(mutex)(&ctx->resize_lock);
+	guard(mutex)(&ctx->mmap_lock);
 
 	ptr = io_uring_validate_mmap_request(filp, pgoff, len);
 	if (IS_ERR(ptr))
@@ -415,7 +415,7 @@ unsigned long io_uring_get_unmapped_area(struct file *file, unsigned long addr,
 	struct io_ring_ctx *ctx = file->private_data;
 	void *ptr;
 
-	guard(mutex)(&ctx->resize_lock);
+	guard(mutex)(&ctx->mmap_lock);
 
 	ptr = io_uring_validate_mmap_request(file, pgoff, len);
 	if (IS_ERR(ptr))
diff --git a/io_uring/register.c b/io_uring/register.c
index 1e99c783abdf..ba61697d7a53 100644
--- a/io_uring/register.c
+++ b/io_uring/register.c
@@ -486,15 +486,15 @@ static int io_register_resize_rings(struct io_ring_ctx *ctx, void __user *arg)
 	}
 
 	/*
-	 * We'll do the swap. Grab the ctx->resize_lock, which will exclude
+	 * We'll do the swap. Grab the ctx->mmap_lock, which will exclude
 	 * any new mmap's on the ring fd. Clear out existing mappings to prevent
 	 * mmap from seeing them, as we'll unmap them. Any attempt to mmap
 	 * existing rings beyond this point will fail. Not that it could proceed
 	 * at this point anyway, as the io_uring mmap side needs go grab the
-	 * ctx->resize_lock as well. Likewise, hold the completion lock over the
+	 * ctx->mmap_lock as well. Likewise, hold the completion lock over the
 	 * duration of the actual swap.
 	 */
-	mutex_lock(&ctx->resize_lock);
+	mutex_lock(&ctx->mmap_lock);
 	spin_lock(&ctx->completion_lock);
 	o.rings = ctx->rings;
 	ctx->rings = NULL;
@@ -561,7 +561,7 @@ static int io_register_resize_rings(struct io_ring_ctx *ctx, void __user *arg)
 	ret = 0;
 out:
 	spin_unlock(&ctx->completion_lock);
-	mutex_unlock(&ctx->resize_lock);
+	mutex_unlock(&ctx->mmap_lock);
 	io_register_free_rings(&p, to_free);
 
 	if (ctx->sq_data)
-- 
2.47.1


