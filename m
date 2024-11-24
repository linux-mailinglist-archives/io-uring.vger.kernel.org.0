Return-Path: <io-uring+bounces-5008-lists+io-uring=lfdr.de@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [IPv6:2604:1380:45d1:ec00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 61BBA9D7835
	for <lists+io-uring@lfdr.de>; Sun, 24 Nov 2024 22:12:08 +0100 (CET)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id 0558E162C23
	for <lists+io-uring@lfdr.de>; Sun, 24 Nov 2024 21:12:05 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 74FC315B97D;
	Sun, 24 Nov 2024 21:12:05 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="ErhkeFsh"
X-Original-To: io-uring@vger.kernel.org
Received: from mail-wm1-f44.google.com (mail-wm1-f44.google.com [209.85.128.44])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9071613FD72
	for <io-uring@vger.kernel.org>; Sun, 24 Nov 2024 21:12:03 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.128.44
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1732482725; cv=none; b=S21xsfv29r8ir5Km6tfKUJhC0w9+t04lKf4u1CQrImd/u+/rEj9gQN9ZTHMMxpz84t1obtJ9oHkjnXMzsg/zAe9TjDmwUAq/Eb9jyCbpIU5wW/nRjGsLY4Znn4RSZCQ92uNdzwDOBKNNcCkLBaANQtO/GzvhgkJRJOwzHWhc5+A=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1732482725; c=relaxed/simple;
	bh=QA+01plKRIkmGEc891jaogWe5XZER36lyT3oLddZ68E=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=hrQa4fydy7qOSV3eJ3eQFg2sjH9wV+rvLMiWVXC4qzEU79H+pZExRaD8yCsuhefjgW900399Aom+/86UuSttfHuZBcAsSBiZuf0cVZJ0ER8uAieP87zbIdsKjvy+HPiVWTKnwUVbXDql2xxjV4odd44cNNUXfivUXA9eKv6EjRw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=ErhkeFsh; arc=none smtp.client-ip=209.85.128.44
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Received: by mail-wm1-f44.google.com with SMTP id 5b1f17b1804b1-4349cc45219so6848425e9.3
        for <io-uring@vger.kernel.org>; Sun, 24 Nov 2024 13:12:03 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1732482722; x=1733087522; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=J8cmqKslAko5zF5qRZC7c7DtkzAvHjFueUMLswLyZOw=;
        b=ErhkeFshrCdNhjRCbHSe1CeJfo1rkLz/hLkDWSwE9hy70oYXJy8FcRZCN0dAJLGoDC
         K38EMRKEuLmFWcYKHnzJLZdzVHQ+GWJ40evCZ3IXRTJHeWDikDKP1EbVnVhDq++us1o9
         LvIBF3poYpHTVXWmlslAACEb53xB/W7hRgh4M39G5omBkCr3rODtEgKTI30VpFBWiDtH
         BInrQNat5dJ3Ojmr1ub3HzZ+1gFZQ4XE+eRwM+69rQmvlhrBJHarHtzPdqtpK0hSCcmi
         I+EA9a4VDX/a0j/ilSZhs+ib8XUaEUVqMQEJUjXKBESRn8MYouTbm4ukipuRQpyGhYSj
         KYfA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1732482722; x=1733087522;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=J8cmqKslAko5zF5qRZC7c7DtkzAvHjFueUMLswLyZOw=;
        b=hEpIfLTlUl8k5MR03s1d+pC23Grrmx/p0z3eFmuEdNUY4ZDPbMjhdUrRWhScFyrCkG
         LOXAxh3htJcIbklPZp2EyCPj1J0H9sF8yhi8yznpsHElkimYjd/Uo/m16QyL23Ix/0kQ
         Z2xasKLVWupy3zTIKNTnCqTntpE5Kbdx5xZl0VZlUVpCbuzUqUH8bN+fjsdxj55ANugi
         N2MDBL7M+sVocEeFBpYw+Wpuw9VgRu312iP8anmdW+NudgcraRA2wCwdDDoTIF3Lc1Jc
         c0Qj5mEY/83gkIXIIrlIHNFgz9gpRUs5rCQSuHZx8pYMUUZ3bk+r9jpmgPiGF/M1EY4W
         7u5A==
X-Gm-Message-State: AOJu0Yxl0WsBWfZrd9b17pLsnQU2FYek1e+SMtakU0kA7H0KEEAyT0ws
	EOJl8fkD9t9KEcdgQUiSpp01KhuV3HIKegbxca2n+XN+su6gvFfa9nr9rA==
X-Gm-Gg: ASbGnct93t/c1FMh8VE//Ivo114CXyFGdbIC/T7iOecuacD/lrymnEKbNdI6Y5fCe0u
	FUb4tGGgJ6rZSlo3kRQn+hQHkosnBfVEKGKBlkVlA7qVdWQrNqBdhX6bwydt6FuHd5PrPon3Lz5
	ipOO8N4rttNs/FjoflrzvU7K32LWWPPryVaKQu/nVvyWwtNIAFQJaOD+4mEUgK4sG580O8SdGsF
	NMEB41qD565rylet3wx/5MPGdnNe1FEig8p9PTvzOkuQVEQtkvCarsJCTnaO40=
X-Google-Smtp-Source: AGHT+IFM/h858U0X4lLXNs4Y0gGcK3hy36gRenWrADttddu7sssVWGQRt/zQzttG/DhVbQLx/j7zsQ==
X-Received: by 2002:a05:600c:a06:b0:42c:bb10:7292 with SMTP id 5b1f17b1804b1-433ce4100c1mr79800945e9.1.1732482721499;
        Sun, 24 Nov 2024 13:12:01 -0800 (PST)
Received: from 127.0.0.1localhost ([85.255.235.224])
        by smtp.gmail.com with ESMTPSA id 5b1f17b1804b1-432f643b299sm132733745e9.0.2024.11.24.13.12.00
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sun, 24 Nov 2024 13:12:01 -0800 (PST)
From: Pavel Begunkov <asml.silence@gmail.com>
To: io-uring@vger.kernel.org
Cc: asml.silence@gmail.com
Subject: [PATCH v2 01/18] io_uring: rename ->resize_lock
Date: Sun, 24 Nov 2024 21:12:18 +0000
Message-ID: <d05df413f877c7163f882febb3277d1e499aa3be.1732481694.git.asml.silence@gmail.com>
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
index bfa93888f862..fee3b7f50176 100644
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


