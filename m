Return-Path: <io-uring+bounces-5011-lists+io-uring=lfdr.de@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from sy.mirrors.kernel.org (sy.mirrors.kernel.org [147.75.48.161])
	by mail.lfdr.de (Postfix) with ESMTPS id 269EA9D7839
	for <lists+io-uring@lfdr.de>; Sun, 24 Nov 2024 22:12:14 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sy.mirrors.kernel.org (Postfix) with ESMTPS id 8810DB22020
	for <lists+io-uring@lfdr.de>; Sun, 24 Nov 2024 21:12:11 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 24C5C166307;
	Sun, 24 Nov 2024 21:12:09 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="KNE0Lbp7"
X-Original-To: io-uring@vger.kernel.org
Received: from mail-wr1-f49.google.com (mail-wr1-f49.google.com [209.85.221.49])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 56E17163
	for <io-uring@vger.kernel.org>; Sun, 24 Nov 2024 21:12:07 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.221.49
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1732482729; cv=none; b=FNfxh7lbg/28mIobqp0AjsT1WB8uaWq7uECLm2ZXP2jPNxwnWFOetzzR7hSJK4y2mqoKQi7E1Dod4MppjsbToiILZJhOMMO1HDosu277dS4iAHd3OxAfv7pc0F4lWCPvIgjo7bZXHCrUbPK0GVB2rxKrgDK4+W2U6iHlEurEsnY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1732482729; c=relaxed/simple;
	bh=5erk2yEKdY6mg7w6j7Qd+n7h2gEJkjZ3W2/qXdoyLx4=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=QXs9i54W9Q4XFghKd2dhHqKViB3za3BOa7IzAf0r+FF/bF/gFh9yGc0f82oseG+cEyP020OrNkQc+jCNFF2DOf0uGmDd0JhvxJ4CYv8Ia3xmyCTDM7FvaT0ya99c6GY7qwvEyv+nCbVzGkHaaUPwNXpZ/YQnAc4AL0xSGrZvLXI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=KNE0Lbp7; arc=none smtp.client-ip=209.85.221.49
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Received: by mail-wr1-f49.google.com with SMTP id ffacd0b85a97d-3823194a879so2732275f8f.0
        for <io-uring@vger.kernel.org>; Sun, 24 Nov 2024 13:12:07 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1732482725; x=1733087525; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=GUoVGY3EqP0iERkK/1XCe67cv9MaIdhCuF65Sh1CrCU=;
        b=KNE0Lbp7JH7G395omFNkfWch0Tm4iq8RJqvGA3WZAnDd5wsJZtCjLpFEXgOABYBvX5
         qWy2n5mzb5/Nf8EX/FQ9f9nKjcM6qy40JksORAvab9oBc/yb1BnNOuCWS0NLI9xNHCUk
         9JN/z4vJa+K7nU2I0fFmePgagK98vtpAKhRYLusjqeIuw6FewRNlQEI2pKEI4QufYajs
         L295KwSxIC8DqkuNyqB1CN56WW8Z4RklV9M0s1GII/w27FDt17LJLlRmobwTJtsIkHom
         SaNE/EUcJ8y2pvIRi370jF/lcPP60+GSVRiRCazuAsZjhFDvZ0eP+2U37tI/0KPf7BGC
         OAug==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1732482725; x=1733087525;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=GUoVGY3EqP0iERkK/1XCe67cv9MaIdhCuF65Sh1CrCU=;
        b=bCXNvKs+hFYtVyEwZDDJSVLUjlypjmKG+I3EE9TOKX9SZVITiMhghFGtd882Apoksi
         bOMWslJTj9VBrGsnbralbRj0t/n7ykALarvsxmvYBR0RjNlLuXpHaSrLd6YGgYtxMKS4
         sD351c9fhndrYH0cwXYVVsFvXl0fwpfBZvynI2LuLWAf9fBdNDLcAUrjplJ/CgSG4THG
         mgRHs/GFVMvTiJ8uFJojW28SKhOUUhJKpuTvuiAAIxrJifGYsqMepsJafA3HcVfrTx02
         vFMcpCICwGYCQg+NEpD4PxFiV6k28ps//QJQBQCEeVF4uBq2dvtx66aCjzBf8LJ3Ebum
         B7SA==
X-Gm-Message-State: AOJu0YznqzOMDnhNpTUP5C7fj6nUbtvX9UQ37eUZ2ImUy6FulHA/qriD
	9kiAwcw3qCBu3HIM+e6Dq3meZlX49905yp0RiDnJ5luB33qwFyUcH1nmVQ==
X-Gm-Gg: ASbGncuchQDcwUFHReF39o64+4m3ACUTlSFlyJKOn9teZAvq/PvP9pOo5wHGZ/1civx
	b08NhFuTWzct0ADyWzuzYak7SoYjlChWKqBjWYB/YMF+v39Mt1PjoFTHhY3ha2qme0cP5uYbvO6
	V5940qrYWZf3guB/9NkOnk82u0zK/YUsNuj5fQ0PB3kcCi8q0Xebo1QhqfdB9VmU65fXvNAXdw3
	M/ox4zUATKPg4feoIXodYQWuVWECDCpVkZ/cwOZN+ln5YdIpMRxNTSWKiMsLjc=
X-Google-Smtp-Source: AGHT+IEuwLa5Gv7urFIak8BJ8372UL+hiNxZR36FeGAiq0+UVeS6Y9JT1/tn/pFH8RuJL3E39cJBtg==
X-Received: by 2002:a5d:64ad:0:b0:382:4721:2391 with SMTP id ffacd0b85a97d-38260bf7395mr8628238f8f.57.1732482723975;
        Sun, 24 Nov 2024 13:12:03 -0800 (PST)
Received: from 127.0.0.1localhost ([85.255.235.224])
        by smtp.gmail.com with ESMTPSA id 5b1f17b1804b1-432f643b299sm132733745e9.0.2024.11.24.13.12.02
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sun, 24 Nov 2024 13:12:03 -0800 (PST)
From: Pavel Begunkov <asml.silence@gmail.com>
To: io-uring@vger.kernel.org
Cc: asml.silence@gmail.com
Subject: [PATCH v2 03/18] io_uring/memmap: add internal region flags
Date: Sun, 24 Nov 2024 21:12:20 +0000
Message-ID: <42ed6e9ec19f0391188f405716aeb86bb6396fba.1732481694.git.asml.silence@gmail.com>
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

Add internal flags for struct io_mapped_region, it will help to add more
functionality while not bloating struct io_mapped_region. Use it to mark
if the pointer needs to be vunmap'ed.

Signed-off-by: Pavel Begunkov <asml.silence@gmail.com>
---
 include/linux/io_uring_types.h |  5 +++--
 io_uring/memmap.c              | 13 +++++++++----
 io_uring/memmap.h              |  2 +-
 3 files changed, 13 insertions(+), 7 deletions(-)

diff --git a/include/linux/io_uring_types.h b/include/linux/io_uring_types.h
index adb36e0da40e..4cee414080fd 100644
--- a/include/linux/io_uring_types.h
+++ b/include/linux/io_uring_types.h
@@ -77,8 +77,9 @@ struct io_hash_table {
 
 struct io_mapped_region {
 	struct page		**pages;
-	void			*vmap_ptr;
-	size_t			nr_pages;
+	void			*ptr;
+	unsigned		nr_pages;
+	unsigned		flags;
 };
 
 /*
diff --git a/io_uring/memmap.c b/io_uring/memmap.c
index 771a57a4a16b..21353ea09b39 100644
--- a/io_uring/memmap.c
+++ b/io_uring/memmap.c
@@ -195,14 +195,18 @@ void *__io_uaddr_map(struct page ***pages, unsigned short *npages,
 	return ERR_PTR(-ENOMEM);
 }
 
+enum {
+	IO_REGION_F_VMAP			= 1,
+};
+
 void io_free_region(struct io_ring_ctx *ctx, struct io_mapped_region *mr)
 {
 	if (mr->pages) {
 		unpin_user_pages(mr->pages, mr->nr_pages);
 		kvfree(mr->pages);
 	}
-	if (mr->vmap_ptr)
-		vunmap(mr->vmap_ptr);
+	if ((mr->flags & IO_REGION_F_VMAP) && mr->ptr)
+		vunmap(mr->ptr);
 	if (mr->nr_pages && ctx->user)
 		__io_unaccount_mem(ctx->user, mr->nr_pages);
 
@@ -218,7 +222,7 @@ int io_create_region(struct io_ring_ctx *ctx, struct io_mapped_region *mr,
 	void *vptr;
 	u64 end;
 
-	if (WARN_ON_ONCE(mr->pages || mr->vmap_ptr || mr->nr_pages))
+	if (WARN_ON_ONCE(mr->pages || mr->ptr || mr->nr_pages))
 		return -EFAULT;
 	if (memchr_inv(&reg->__resv, 0, sizeof(reg->__resv)))
 		return -EINVAL;
@@ -253,8 +257,9 @@ int io_create_region(struct io_ring_ctx *ctx, struct io_mapped_region *mr,
 	}
 
 	mr->pages = pages;
-	mr->vmap_ptr = vptr;
+	mr->ptr = vptr;
 	mr->nr_pages = nr_pages;
+	mr->flags |= IO_REGION_F_VMAP;
 	return 0;
 out_free:
 	if (pages_accounted)
diff --git a/io_uring/memmap.h b/io_uring/memmap.h
index f361a635b6c7..2096a8427277 100644
--- a/io_uring/memmap.h
+++ b/io_uring/memmap.h
@@ -28,7 +28,7 @@ int io_create_region(struct io_ring_ctx *ctx, struct io_mapped_region *mr,
 
 static inline void *io_region_get_ptr(struct io_mapped_region *mr)
 {
-	return mr->vmap_ptr;
+	return mr->ptr;
 }
 
 static inline bool io_region_is_set(struct io_mapped_region *mr)
-- 
2.46.0


