Return-Path: <io-uring+bounces-4888-lists+io-uring=lfdr.de@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [147.75.80.249])
	by mail.lfdr.de (Postfix) with ESMTPS id 56FE49D4483
	for <lists+io-uring@lfdr.de>; Thu, 21 Nov 2024 00:33:24 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id 0F9C11F221D6
	for <lists+io-uring@lfdr.de>; Wed, 20 Nov 2024 23:33:24 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 94CC31C68AA;
	Wed, 20 Nov 2024 23:33:09 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="EjSJqGDY"
X-Original-To: io-uring@vger.kernel.org
Received: from mail-ej1-f48.google.com (mail-ej1-f48.google.com [209.85.218.48])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B23481BC07B
	for <io-uring@vger.kernel.org>; Wed, 20 Nov 2024 23:33:07 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.218.48
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1732145589; cv=none; b=rRXX2Vn0rbIm+5YS6j4mXO4fOTVcDlbsEkXKDRegNaBzQ+xtaa9wGPeTx5fGZxrrSaK3ISuyfs5MTrcsF+heUA3g9+7Ss6WGpJ4mVdicU6fAxZSv68REm5pOm4IkVW76RomHJMcTs9YMAdZTuWZhO3Nyf6ieF2XzaEkPFHrqUXQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1732145589; c=relaxed/simple;
	bh=UPTbRG9neEhUTCuJVFBoQHbF7x+O860/DGHGgPzDdYI=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=sS5QREKlTVhgKO/1zn2tNE3dFAGVNEQFxIsD6RI9OiIFQFSJ9Dxg4L75+Fyg2K8jYX2qYitbbabBN32QdhA50yCxiafioAMiLnMsPO1cPmQ9+crFC5DYs8IzrxjXaBzLN6h5B8HzQY9Hwrz8+n3ZWDMGxHHqxQN0gYXoHHHzL94=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=EjSJqGDY; arc=none smtp.client-ip=209.85.218.48
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Received: by mail-ej1-f48.google.com with SMTP id a640c23a62f3a-a9a6acac4c3so53726766b.0
        for <io-uring@vger.kernel.org>; Wed, 20 Nov 2024 15:33:07 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1732145586; x=1732750386; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=d1Ts0VuPNUivf/LvKiwdXOLn5cp6FT5YlAICwjVUTc4=;
        b=EjSJqGDYJ+vXpgq4nf9Sr/QlDmx5L+192QF1Mow0t7u8csPxbs9oe4q5akIAVW2KYC
         PQuHXyb2N8LNLBc/XoAuGABWNijG8ZvvuzJSfAoDrRMlnrxKdE8t9UBIQGcddYTZnfHq
         5eMAoJUseRL8cXic5mYdKrhML0Hc/xoRlEZEv2/rtwjnqj5UHBd1+iOBWfnRT79SbcpX
         P64ZbZdJuU6RyJK2RWhQwZZ8fsGdvAFEJlJStBRRD4uxOjeF9FUzNGFCBfU1I94x0iWJ
         Q6FszRin3H29zIX4jY8tdo5KJCEcj8Xt2zeZJ1XCws3i9Rcp4IImHjEau2iT94p7+wrX
         qcvA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1732145586; x=1732750386;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=d1Ts0VuPNUivf/LvKiwdXOLn5cp6FT5YlAICwjVUTc4=;
        b=FPEewt8oZwzQ+G6UACjz2mRbXSiW6xDe8jABidu6AYPOIdTQEJL/hPC92iSsGo2th4
         ojjtREQG5wPfcFYXafpzFQQf/Ik2T2Gl9T/cpOsFWG2hsTZinRpTiv3IDAm9IRn46mxn
         myel/G+xAIm9W1aUms/hTgxxTakeIREBu9NHCdS7iut7PcuefNNi0lVf61TwUKlnhJNB
         5jRsmK8V/cFXfVnzCzNNX5IUTSA7Jciwod7q4ixmxBVtV0FV0eplRU5wB4prHGBl4Sha
         xjlTpjuMkurL2sYz+EN7l6MtoJuw/hLOUs5XXG8nUd9V/Y0Z1Qqej0zCQG9kKaUTprF4
         lNsQ==
X-Gm-Message-State: AOJu0Yy7ZzdEseJNeWAvTFSUrNaDPnsFY0lOAfA0VOtFnvjzMJsjWM4w
	q2FIQAqduNWK7vqTve4+R2rALrStU7bfdnnrviYCad1afqrmEjUK0IqMPA==
X-Gm-Gg: ASbGncv04bIxqaIq2RAITmVgFLE5cg6+kXnQ6KfDpILVu2QrkCN+n8xUGLFtlgysUpL
	A9BwDJvWoctBD7AxI6uertljbDNCbVUy41Iq986rt9Y0R/ieX6Y9pTAwkIZ4gsNupVrYz9ywUs9
	lMpsMAjCCOrBGDeSfnBRoiT0rixt9XmC8KxXGumBRscisvJMZMpeyi2ZTXSGsEUatfDwpuybqWf
	Wyo/92vUotzl5eusyg8bN/iW+afzucivCX2ODpzaYrLDrWp0oYodaqE9wCSehkW
X-Google-Smtp-Source: AGHT+IG1/ExHUUYFnGg5SMZsUZmjMkTTrG8ySnGdqIAz5eTRFWeAWakAX7EwZ8PDawjlj9laal2Qig==
X-Received: by 2002:a17:907:1c14:b0:a9a:8034:3644 with SMTP id a640c23a62f3a-aa4dd5517c4mr414818566b.14.1732145585436;
        Wed, 20 Nov 2024 15:33:05 -0800 (PST)
Received: from 127.0.0.1localhost ([148.252.141.165])
        by smtp.gmail.com with ESMTPSA id a640c23a62f3a-aa4f415372bsm12166066b.13.2024.11.20.15.33.04
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 20 Nov 2024 15:33:05 -0800 (PST)
From: Pavel Begunkov <asml.silence@gmail.com>
To: io-uring@vger.kernel.org
Cc: asml.silence@gmail.com
Subject: [PATCH 01/11] io_uring: rename ->resize_lock
Date: Wed, 20 Nov 2024 23:33:24 +0000
Message-ID: <6b0a570e4685d1a66bec720dd1fd3fb735a0844c.1732144783.git.asml.silence@gmail.com>
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
index aa5f5ea98076..ac7b2b6484a9 100644
--- a/include/linux/io_uring_types.h
+++ b/include/linux/io_uring_types.h
@@ -422,7 +422,7 @@ struct io_ring_ctx {
 	 * side will need to grab this lock, to prevent either side from
 	 * being run concurrently with the other.
 	 */
-	struct mutex			resize_lock;
+	struct mutex			mmap_lock;
 
 	/*
 	 * If IORING_SETUP_NO_MMAP is used, then the below holds
diff --git a/io_uring/io_uring.c b/io_uring/io_uring.c
index da8fd460977b..d565b1589951 100644
--- a/io_uring/io_uring.c
+++ b/io_uring/io_uring.c
@@ -350,7 +350,7 @@ static __cold struct io_ring_ctx *io_ring_ctx_alloc(struct io_uring_params *p)
 	INIT_WQ_LIST(&ctx->submit_state.compl_reqs);
 	INIT_HLIST_HEAD(&ctx->cancelable_uring_cmd);
 	io_napi_init(ctx);
-	mutex_init(&ctx->resize_lock);
+	mutex_init(&ctx->mmap_lock);
 
 	return ctx;
 
diff --git a/io_uring/memmap.c b/io_uring/memmap.c
index 3d71756bc598..771a57a4a16b 100644
--- a/io_uring/memmap.c
+++ b/io_uring/memmap.c
@@ -322,7 +322,7 @@ __cold int io_uring_mmap(struct file *file, struct vm_area_struct *vma)
 	unsigned int npages;
 	void *ptr;
 
-	guard(mutex)(&ctx->resize_lock);
+	guard(mutex)(&ctx->mmap_lock);
 
 	ptr = io_uring_validate_mmap_request(file, vma->vm_pgoff, sz);
 	if (IS_ERR(ptr))
@@ -358,7 +358,7 @@ unsigned long io_uring_get_unmapped_area(struct file *filp, unsigned long addr,
 	if (addr)
 		return -EINVAL;
 
-	guard(mutex)(&ctx->resize_lock);
+	guard(mutex)(&ctx->mmap_lock);
 
 	ptr = io_uring_validate_mmap_request(filp, pgoff, len);
 	if (IS_ERR(ptr))
@@ -408,7 +408,7 @@ unsigned long io_uring_get_unmapped_area(struct file *file, unsigned long addr,
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
2.46.0


