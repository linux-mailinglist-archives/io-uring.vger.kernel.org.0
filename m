Return-Path: <io-uring+bounces-5137-lists+io-uring=lfdr.de@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [IPv6:2604:1380:45d1:ec00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 19A0E9DE7AA
	for <lists+io-uring@lfdr.de>; Fri, 29 Nov 2024 14:34:12 +0100 (CET)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id BCFE0161CDA
	for <lists+io-uring@lfdr.de>; Fri, 29 Nov 2024 13:34:04 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 54BC819CC27;
	Fri, 29 Nov 2024 13:34:05 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="E9R+olGs"
X-Original-To: io-uring@vger.kernel.org
Received: from mail-ej1-f45.google.com (mail-ej1-f45.google.com [209.85.218.45])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 918D4199E89
	for <io-uring@vger.kernel.org>; Fri, 29 Nov 2024 13:34:03 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.218.45
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1732887245; cv=none; b=hTprEHtAMAE3tcsHk79+9aLy5v6iUWS1uKXvHCOqRxuDcSkZeSaX9atOKNUg8E4Jf0oEJnuu3i04HvCy7paculqJvioOtuDrfz4nXTfWw1MGKyYe+2vVWkO8033bSd1zYkXIupeRmeAdmBDcW9fz45zANDdxNMdCxW/dyzkHKwQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1732887245; c=relaxed/simple;
	bh=pBLhP4NZ4pOh05aVAZiGGkEMhocl1kPcI5Pr5RxnovM=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=NYxx8nss2dz0enZsyTXjYzQWSG62qo8TYexKhyzC5iVX01Lm99o/7+pGWsVxX+EtzzwGGlGW+crHW3R+wL6/XmVZrclmdumKX8du5Soy+ppX9JW5C9oNmnEXCQY6PusMFh4AlcP8J6wg+Oeto4qv5sfZzZH/rk7t9S7tJvIhH10=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=E9R+olGs; arc=none smtp.client-ip=209.85.218.45
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Received: by mail-ej1-f45.google.com with SMTP id a640c23a62f3a-a9e8522445dso237266966b.1
        for <io-uring@vger.kernel.org>; Fri, 29 Nov 2024 05:34:03 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1732887242; x=1733492042; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=sZ7BAkceaUfZ0ygLKPzexSiQI9CZCsSE4oQUbtNBp1s=;
        b=E9R+olGs1BRtbXo1pKe8l4hqU8MMPp7HPFgHqBAGNuKBajNhRjH5Bjf3kIA5mE/Y1z
         s0grzXA+oBIbtk9grgVwRb2yRXPu8aqAkHKkkWzJrIcGprkXiT7s05tBAaknwo4bE8CJ
         tQa2QmLdKZ4omw3ECuE1Gca4SM3KIiqnqH88nkLtj6f8DjVO3iRQCwlRSdMl7iNwowui
         utAFCL5iY2oGs1H+81HiNsDkQLzEXs6NumL0ahr9M/aFFtIImRVnrGv8AyO/0yKgpQM7
         BmFxS0seZZt2Rsl9SV/mVnkDJ+el/FegefC6YJ2284WaK8nsZ3ELd7QahN4lj19MnTvN
         qaAQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1732887242; x=1733492042;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=sZ7BAkceaUfZ0ygLKPzexSiQI9CZCsSE4oQUbtNBp1s=;
        b=whityf/jzoznXcdQHCkA3W+MO+lrQdZQsTvq8Ewimhxq1nxfQjuhwTDHn7F9hXDxev
         2h50xoBfhQgSG1w0YTyFZreU4eUdX8/td8f0pUxQqLMjSOVfUEVW3o56IvyGxw86gD+C
         /3NoQ5fkMLnlg7GTIx39Z8zzy65vf+YZV5gPyM7+RKcC248QUmomuVcvSGCGJKCJma/d
         BKNDFbvgaCDSX2UDbcmB75FvBgOkyYVLCka5w4QmK//5KutF2VWeAA0miIDp2FTtgcHx
         7cZzmvBaFuhYqr1TUZiOEftEUnvvJ3Bn+wK02a38uquirTW54NhfngUFcDBHNz2+eDzv
         Ky6Q==
X-Gm-Message-State: AOJu0YyIQfs9tkRPZIHJ0ENTE4k1Tu1bfS8n6pvBxzpLwbKoR7fDrqR3
	3/GJ0IDhROLr3/6YRWwbXDdpxwGLFUJx1ESXKbxksENBBVdTQVROiOn/TA==
X-Gm-Gg: ASbGncv5Mn9Pq3XHK61Q7fw2mFp5zdiPvUZAT3/2e/Fzm4vxWYGW+lhEIHu3aYQtnRa
	qM/odXmFnqNCi2bQXQ0qjMQg74LrSMfWWzPVDBo7wPXq057xdmLjkMvdZjw3uI1tn2/ttl3vaIy
	OgY9rSxEMxXTk2xPeYZ6VTM7TTnwuCo56E6UmiEPyMB4a6pROOMlbxg6uSG+akX0BZSxxR3KEEo
	a34eeUCKq8Y07mkpcU/1pRVQWDSEQWLRcPUgR6D6vKQq1JfvaOUJzabi3T20hsa
X-Google-Smtp-Source: AGHT+IF2vJU6NJbS+0nAllT9v43ZpTqRQ9fh0cQ9UFZzdQu7bvdMUe3D6CySLLxcRKtkh0c7jucb8Q==
X-Received: by 2002:a17:907:6ea9:b0:aa5:297a:429f with SMTP id a640c23a62f3a-aa58108036dmr1135156166b.51.1732887241653;
        Fri, 29 Nov 2024 05:34:01 -0800 (PST)
Received: from 127.0.0.1localhost ([163.114.131.193])
        by smtp.gmail.com with ESMTPSA id a640c23a62f3a-aa5996c2471sm173996866b.13.2024.11.29.05.34.01
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 29 Nov 2024 05:34:01 -0800 (PST)
From: Pavel Begunkov <asml.silence@gmail.com>
To: io-uring@vger.kernel.org
Cc: asml.silence@gmail.com
Subject: [PATCH v3 06/18] io_uring/memmap: reuse io_free_region for failure path
Date: Fri, 29 Nov 2024 13:34:27 +0000
Message-ID: <b853b4ec407cc80d033d021bdd2c14e22378fc78.1732886067.git.asml.silence@gmail.com>
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

Regions are going to become more complex with allocation options and
optimisations, I want to split initialisation into steps and for that it
needs a sane fail path. Reuse io_free_region(), it's smart enough to
undo only what's needed and leaves the structure in a consistent state.

Signed-off-by: Pavel Begunkov <asml.silence@gmail.com>
---
 io_uring/memmap.c | 16 +++++-----------
 1 file changed, 5 insertions(+), 11 deletions(-)

diff --git a/io_uring/memmap.c b/io_uring/memmap.c
index fca93bc4c6f1..96c4f6b61171 100644
--- a/io_uring/memmap.c
+++ b/io_uring/memmap.c
@@ -229,7 +229,6 @@ void io_free_region(struct io_ring_ctx *ctx, struct io_mapped_region *mr)
 int io_create_region(struct io_ring_ctx *ctx, struct io_mapped_region *mr,
 		     struct io_uring_region_desc *reg)
 {
-	int pages_accounted = 0;
 	struct page **pages;
 	int nr_pages, ret;
 	void *vptr;
@@ -257,32 +256,27 @@ int io_create_region(struct io_ring_ctx *ctx, struct io_mapped_region *mr,
 		ret = __io_account_mem(ctx->user, nr_pages);
 		if (ret)
 			return ret;
-		pages_accounted = nr_pages;
 	}
+	mr->nr_pages = nr_pages;
 
 	pages = io_pin_pages(reg->user_addr, reg->size, &nr_pages);
 	if (IS_ERR(pages)) {
 		ret = PTR_ERR(pages);
-		pages = NULL;
 		goto out_free;
 	}
+	mr->pages = pages;
+	mr->flags |= IO_REGION_F_USER_PROVIDED;
 
 	vptr = vmap(pages, nr_pages, VM_MAP, PAGE_KERNEL);
 	if (!vptr) {
 		ret = -ENOMEM;
 		goto out_free;
 	}
-
-	mr->pages = pages;
 	mr->ptr = vptr;
-	mr->nr_pages = nr_pages;
-	mr->flags |= IO_REGION_F_VMAP | IO_REGION_F_USER_PROVIDED;
+	mr->flags |= IO_REGION_F_VMAP;
 	return 0;
 out_free:
-	if (pages_accounted)
-		__io_unaccount_mem(ctx->user, pages_accounted);
-	if (pages)
-		io_pages_free(&pages, nr_pages);
+	io_free_region(ctx, mr);
 	return ret;
 }
 
-- 
2.47.1


