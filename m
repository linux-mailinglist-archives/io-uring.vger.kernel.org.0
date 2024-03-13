Return-Path: <io-uring+bounces-919-lists+io-uring=lfdr.de@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [139.178.88.99])
	by mail.lfdr.de (Postfix) with ESMTPS id 2F14987AAE3
	for <lists+io-uring@lfdr.de>; Wed, 13 Mar 2024 17:06:29 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id DE2552855B3
	for <lists+io-uring@lfdr.de>; Wed, 13 Mar 2024 16:06:27 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id C67A345BF3;
	Wed, 13 Mar 2024 16:06:19 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="Eywtc7P3"
X-Original-To: io-uring@vger.kernel.org
Received: from mail-ej1-f41.google.com (mail-ej1-f41.google.com [209.85.218.41])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0F34947A73
	for <io-uring@vger.kernel.org>; Wed, 13 Mar 2024 16:06:17 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.218.41
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1710345979; cv=none; b=l4HVU5QYQSjCHdPeUuS+LRIbb2rt2uFO+A3Dz0+TF0XXYRZxhPktpS4bJpRu6lhIO9nc8g1e61QZzI5n/kOmlf5Uo/RUw6vUw8JPYbtkZby+LESfkXZfZE153L54k9rYbzgnsB16nXcS0kco177s2cW6o3/zXGL+W8Z1Om/GFIM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1710345979; c=relaxed/simple;
	bh=HfZzI34XZIHjhiUozFM3sOIVp/4aAKA58HPcv1NS5Sw=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=cg/fDgdYlmpYNKygW/UA2sJaI+pHRhQ14B+dxx/G/wm72XQUg0rcVnJVRxwlA6e+tmAgsjhgtM76Nnfs4cSUgzMfp/igHMqBXCkk4DwuaKlqIrFV/wVva9RH5CI3RhQ7sDej8wLgw28oFjhMojdAaf3oDKY0IKNrv1yCkL7qBTE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=Eywtc7P3; arc=none smtp.client-ip=209.85.218.41
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Received: by mail-ej1-f41.google.com with SMTP id a640c23a62f3a-a46692ec303so83766b.1
        for <io-uring@vger.kernel.org>; Wed, 13 Mar 2024 09:06:17 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1710345976; x=1710950776; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=cuzBS4rylPNeMH/HTgBXireaznvaak6s6Kt8HPky/Eo=;
        b=Eywtc7P3Xx87LZgMp6oW4cJXeVR43UMLiHk2cVjAKCY3YzUqYxHWR+bQ3FLN1WM7qW
         6Oh8nFGMnQHT1HY54opxb1iKaXuXKvDMRc8XW+GI5pH9yQ8XEN20D2zkmuul5QBE/VXj
         /CEKYyJyhQ69/RblebCAGHCae1tzKc3PNgDvgVoFct6X3RW6T6FeyizKKym8sbj6pdEX
         ImPttJGYby2gjB7xQ1I9+iE/+ARqXWQT61pqQ+jCjQR1NXZkgw1WUIpCAKFVDrGhI1nj
         7FdRmXlKlRIjXmJ6+tkjxs/v53IqTTt18+qFmR+WrbBEYuSoFQwtav94ekgLRktD6d60
         sC0Q==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1710345976; x=1710950776;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=cuzBS4rylPNeMH/HTgBXireaznvaak6s6Kt8HPky/Eo=;
        b=RfG56AHM4074HD1f/2Frlobr+icPWcXhj2CBemD6dfc4K/Wb/NvlRU1xeR328LjLBg
         K2ZsNuQYLmkqG3PtE3vgnPEw3biA1vr/Ll7LlUQdkhsvYnUDCtjtR/+2yUbw81yOMjgP
         aeh2xTvF56b0i9m8L7CxCqfjqYBF7aS7W6rQmd6qmfyX91DOsGiNFRbHmEl7bDK8f6el
         m7ofy1PXdKdqQqmQLHoeajK8EGNINc4Fu0PUNmYMGQM5HGIqU4yudc0MXratSRYVb5iI
         5PMdXvBj2dhsHBnLSy+2zxRYMPNNS5UjiVOGdh9+bhUpX9IzQ/AJ2JaI8G8EQy9bHtxi
         OGiA==
X-Gm-Message-State: AOJu0YxDHb+py668NloYXWyVsrDVx4qM+dYh1Xh1hyT55kxZDsHz+fgd
	lKhzhjCQN1Sd4XCYHj6HvkRkQmgSRXL8a1G5sYUgpOSNbjQxOv7B0xrIUCUX
X-Google-Smtp-Source: AGHT+IEUCPJveqqszKIFuZ8kc6+zuLGBkrrIRQtIGjZrR/gljdrVtaqxSpmlAqnXKsBTh+7GESLGpw==
X-Received: by 2002:a17:907:96a8:b0:a46:141d:bf62 with SMTP id hd40-20020a17090796a800b00a46141dbf62mr8919105ejc.73.1710345975956;
        Wed, 13 Mar 2024 09:06:15 -0700 (PDT)
Received: from 127.com ([2620:10d:c092:600::1:7461])
        by smtp.gmail.com with ESMTPSA id k16-20020a1709067ad000b00a4655976025sm798328ejo.82.2024.03.13.09.06.15
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 13 Mar 2024 09:06:15 -0700 (PDT)
From: Pavel Begunkov <asml.silence@gmail.com>
To: io-uring@vger.kernel.org
Cc: Jens Axboe <axboe@kernel.dk>,
	asml.silence@gmail.com
Subject: [PATCH 1/3] io_uring: simplify io_mem_alloc return values
Date: Wed, 13 Mar 2024 15:52:39 +0000
Message-ID: <ba1f5a30be45eec6cf73cfdbf4b4e1679a03cef8.1710343154.git.asml.silence@gmail.com>
X-Mailer: git-send-email 2.43.0
In-Reply-To: <cover.1710343154.git.asml.silence@gmail.com>
References: <cover.1710343154.git.asml.silence@gmail.com>
Precedence: bulk
X-Mailing-List: io-uring@vger.kernel.org
List-Id: <io-uring.vger.kernel.org>
List-Subscribe: <mailto:io-uring+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:io-uring+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

io_mem_alloc() returns a pointer on success and a pointer-encoded error
otherwise. However, it can only fail with -ENOMEM, just return NULL on
failure. PTR_ERR is usually pretty error prone.

Signed-off-by: Pavel Begunkov <asml.silence@gmail.com>
---
 io_uring/io_uring.c | 14 +++++---------
 io_uring/kbuf.c     |  4 ++--
 2 files changed, 7 insertions(+), 11 deletions(-)

diff --git a/io_uring/io_uring.c b/io_uring/io_uring.c
index e7d7a456b489..1d0eac0cc8aa 100644
--- a/io_uring/io_uring.c
+++ b/io_uring/io_uring.c
@@ -2802,12 +2802,8 @@ static void io_rings_free(struct io_ring_ctx *ctx)
 void *io_mem_alloc(size_t size)
 {
 	gfp_t gfp = GFP_KERNEL_ACCOUNT | __GFP_ZERO | __GFP_NOWARN | __GFP_COMP;
-	void *ret;
 
-	ret = (void *) __get_free_pages(gfp, get_order(size));
-	if (ret)
-		return ret;
-	return ERR_PTR(-ENOMEM);
+	return (void *) __get_free_pages(gfp, get_order(size));
 }
 
 static unsigned long rings_size(struct io_ring_ctx *ctx, unsigned int sq_entries,
@@ -3762,8 +3758,8 @@ static __cold int io_allocate_scq_urings(struct io_ring_ctx *ctx,
 	else
 		rings = io_rings_map(ctx, p->cq_off.user_addr, size);
 
-	if (IS_ERR(rings))
-		return PTR_ERR(rings);
+	if (!rings)
+		return -ENOMEM;
 
 	ctx->rings = rings;
 	if (!(ctx->flags & IORING_SETUP_NO_SQARRAY))
@@ -3787,9 +3783,9 @@ static __cold int io_allocate_scq_urings(struct io_ring_ctx *ctx,
 	else
 		ptr = io_sqes_map(ctx, p->sq_off.user_addr, size);
 
-	if (IS_ERR(ptr)) {
+	if (!ptr) {
 		io_rings_free(ctx);
-		return PTR_ERR(ptr);
+		return -ENOMEM;
 	}
 
 	ctx->sq_sqes = ptr;
diff --git a/io_uring/kbuf.c b/io_uring/kbuf.c
index 9be42bff936b..0677eae92e79 100644
--- a/io_uring/kbuf.c
+++ b/io_uring/kbuf.c
@@ -627,8 +627,8 @@ static int io_alloc_pbuf_ring(struct io_ring_ctx *ctx,
 	ibf = io_lookup_buf_free_entry(ctx, ring_size);
 	if (!ibf) {
 		ptr = io_mem_alloc(ring_size);
-		if (IS_ERR(ptr))
-			return PTR_ERR(ptr);
+		if (!ptr)
+			return -ENOMEM;
 
 		/* Allocate and store deferred free entry */
 		ibf = kmalloc(sizeof(*ibf), GFP_KERNEL_ACCOUNT);
-- 
2.43.0


