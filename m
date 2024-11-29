Return-Path: <io-uring+bounces-5134-lists+io-uring=lfdr.de@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from sy.mirrors.kernel.org (sy.mirrors.kernel.org [IPv6:2604:1380:40f1:3f00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id C943B9DE7A6
	for <lists+io-uring@lfdr.de>; Fri, 29 Nov 2024 14:34:07 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sy.mirrors.kernel.org (Postfix) with ESMTPS id 4A174B20C82
	for <lists+io-uring@lfdr.de>; Fri, 29 Nov 2024 13:34:05 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 1CB7D19CC3F;
	Fri, 29 Nov 2024 13:34:03 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="L8pD3vXs"
X-Original-To: io-uring@vger.kernel.org
Received: from mail-ej1-f48.google.com (mail-ej1-f48.google.com [209.85.218.48])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5435019E806
	for <io-uring@vger.kernel.org>; Fri, 29 Nov 2024 13:34:01 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.218.48
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1732887243; cv=none; b=HlMQ+BQzrUSv2OMzVGqEWLYK7VLBmVzJL9XIMhUZ1IaedaKBll7gwMScH7dzHd31YH9d4Etn5B8S2XxgZ0UQ+dU/oeJo9V4/ijg9/bX8TaNE+qttGOSbis3lWvJxH7Cv2Hae4NHMU9IxTY3ks8V3VRBTbNL1Tj4LoLvJA/Ci+BI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1732887243; c=relaxed/simple;
	bh=lxgwNXsgAQULEZiqtAC9jgEbihBiURSI4NO0D5BvzgI=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=ggYemEcjQ8ZNb/i4WS0jAh2j1VwcBt1uTtR44mhqSKAZdbvpKvQqC1ZLLUfQPzsiBk3kLut7DTuqhNFOPRy8BxCoxdISjKvp8RF+WNbjJYuaXpC5jgqys/klbp1QRTabJQ8xER9VCbVti8QyQ1zE3JfHdKNvBoo2PuKdkexvLHg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=L8pD3vXs; arc=none smtp.client-ip=209.85.218.48
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Received: by mail-ej1-f48.google.com with SMTP id a640c23a62f3a-a9a0ef5179dso248258766b.1
        for <io-uring@vger.kernel.org>; Fri, 29 Nov 2024 05:34:01 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1732887239; x=1733492039; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=Mpfk03/A34fMYNA5TQQ0uM4WtTPml/veC3omIRerQwY=;
        b=L8pD3vXs47swq7GXWagx5xYNXjktIM/5g+jQiwlVGWROlt2CJ9IPNgpjtZi1BSmCZv
         qLNqN5Hz4+BwzzIQKwS/sxD3UyYyNQF3zUppG2WESMmAGfLAbM+21XhRLYWHhL06+ddW
         CxWNQcoBFBip070S/zQCnqvzpn9g4DgB9XuVHTsV+QB7WjoJbOxe/LYMs/92rMthmdnc
         EGfaXKY9RxfOinSr3l5djX7oBdq3Wj9dAi6UTzbo6jCTLNmV/HNLzdft90tvA4RDC9nF
         o5wltqCMjY+y8dG2XTWVCe5GE9Azj2q3dn1zT3dLrQfgqNyHTMuWWAyTxKggJGplMq0o
         N6qQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1732887239; x=1733492039;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=Mpfk03/A34fMYNA5TQQ0uM4WtTPml/veC3omIRerQwY=;
        b=Hd7WlWDiJ6+/3V0NJfX1Ea3Wy2N7fnXYnwQ1awe5I20CelNmrSYbgjrj/1CE8roovD
         0ZIURtwCZRHWNb6JKprjoqCVjhnRzSEbrWNA5UwVNeVHlNrdt7fN0dYEloED+wPxt3fs
         FzucE0MwQtbIF0BBGw8AItWVFs+qZr3saN6LLU+Q9BSqMSz1XEQKyEubHONoVjQ8hgra
         3mcV9C9XfV49OfWeGjZYESaSZbI8kiBg1V29+VNe/PRxFNrIEa0x2sxEGrUAouIHfJ5e
         ZZ39wdAPxWMyz4VKf+NND4JdU9Z3UVDGBgzbeU+UEdW+Ze/kruOHGEvMhrd8dotvWB1W
         r0oA==
X-Gm-Message-State: AOJu0YzdIeahkoKYhFtjo/Ad2m3XGLiQ9Dos2JytUxGobY/GQRZ4V+Q8
	OPtGuAk3BnzHHlYHIaEtlYFEv8xd2wCBOif2AJYbfppdE7E07bIss1RCHA==
X-Gm-Gg: ASbGncs09TXKFajmbmDIJ3HHP5bGTd7jvvV7nVePmOA04Btc88BUqJZnVb40Tj7FCp3
	VfIdzvxQzGHdznvQ0Q8N9ErMJKEMyQS1ciUM9drtIWWHMzguN+LhPhgdbvr4D1SQ6dcBoFApnml
	37TenrP/vu8eGpQWbZtddKFOk7BZb+1QKp2nqJ96NvfWSHpOD61v1CjjrQKndSYzXCov0jMDwMH
	5zS1L84ErN0IOvSja2hMhQtEOeJID7267fRDPnrBfzDqwBoFnN9MgyzR2y40YQ/
X-Google-Smtp-Source: AGHT+IEx18Y2eRtotDUUoSe+2iSEZqfzTfnJPAJbSK38mnVNFhgip4sxnRbnhNtPhyMBDVTtINGL7A==
X-Received: by 2002:a17:907:7241:b0:a9e:c947:8c5e with SMTP id a640c23a62f3a-aa5810634e2mr1147167466b.57.1732887238785;
        Fri, 29 Nov 2024 05:33:58 -0800 (PST)
Received: from 127.0.0.1localhost ([163.114.131.193])
        by smtp.gmail.com with ESMTPSA id a640c23a62f3a-aa5996c2471sm173996866b.13.2024.11.29.05.33.58
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 29 Nov 2024 05:33:58 -0800 (PST)
From: Pavel Begunkov <asml.silence@gmail.com>
To: io-uring@vger.kernel.org
Cc: asml.silence@gmail.com
Subject: [PATCH v3 03/18] io_uring/memmap: flag vmap'ed regions
Date: Fri, 29 Nov 2024 13:34:24 +0000
Message-ID: <5a3d8046a038da97c0f8a8c8f1733fa3fc689d31.1732886067.git.asml.silence@gmail.com>
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

Add internal flags for struct io_mapped_region. The first flag we need
is IO_REGION_F_VMAPPED, that indicates that the pointer has to be
unmapped on region destruction. For now all regions are vmap'ed, so it's
set unconditionally.

Signed-off-by: Pavel Begunkov <asml.silence@gmail.com>
---
 include/linux/io_uring_types.h |  5 +++--
 io_uring/memmap.c              | 14 ++++++++++----
 io_uring/memmap.h              |  2 +-
 3 files changed, 14 insertions(+), 7 deletions(-)

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
index a0d4151d11af..31fb8c8ffe4e 100644
--- a/io_uring/memmap.c
+++ b/io_uring/memmap.c
@@ -202,14 +202,19 @@ void *__io_uaddr_map(struct page ***pages, unsigned short *npages,
 	return ERR_PTR(-ENOMEM);
 }
 
+enum {
+	/* memory was vmap'ed for the kernel, freeing the region vunmap's it */
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
 
@@ -225,7 +230,7 @@ int io_create_region(struct io_ring_ctx *ctx, struct io_mapped_region *mr,
 	void *vptr;
 	u64 end;
 
-	if (WARN_ON_ONCE(mr->pages || mr->vmap_ptr || mr->nr_pages))
+	if (WARN_ON_ONCE(mr->pages || mr->ptr || mr->nr_pages))
 		return -EFAULT;
 	if (memchr_inv(&reg->__resv, 0, sizeof(reg->__resv)))
 		return -EINVAL;
@@ -260,8 +265,9 @@ int io_create_region(struct io_ring_ctx *ctx, struct io_mapped_region *mr,
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
2.47.1


