Return-Path: <io-uring+bounces-4890-lists+io-uring=lfdr.de@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from sy.mirrors.kernel.org (sy.mirrors.kernel.org [147.75.48.161])
	by mail.lfdr.de (Postfix) with ESMTPS id 828989D4486
	for <lists+io-uring@lfdr.de>; Thu, 21 Nov 2024 00:33:33 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sy.mirrors.kernel.org (Postfix) with ESMTPS id DE2D6B21A7D
	for <lists+io-uring@lfdr.de>; Wed, 20 Nov 2024 23:33:30 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 97E451C830B;
	Wed, 20 Nov 2024 23:33:11 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="Hb9CFjvS"
X-Original-To: io-uring@vger.kernel.org
Received: from mail-ej1-f42.google.com (mail-ej1-f42.google.com [209.85.218.42])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id BCE6B1C7B63
	for <io-uring@vger.kernel.org>; Wed, 20 Nov 2024 23:33:09 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.218.42
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1732145591; cv=none; b=UgKrOUxCGbrOALSLSGA7FIkVQAkUAl8PGV8vJ8weSBDBuJcd+R2fIiHwn067TgMxdI6J2wgV7h7zatxOoGSqwmzUR8/Exn8rnHgzbMzxI7617RB8kFbardbXEw55JclUOcjkn905J83Y4faf4+jNOlgDlLc9NmFSrFJGo89LHQE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1732145591; c=relaxed/simple;
	bh=3guHR+zYJfa16yyG7x/vkhKd1mBgkHtCczZEsPnZxYQ=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=V82/eEXfWE1iS89QXnNyvEcm57He3KiI6r8pmgK1V4r10706z0GrCT+du1LEpdtcD554ff5dhOPBxkUEiVpHkh/WVUCK7kntSuEjcGfg+4s900e6tchsbXFMWet9CA2Jt+1NPgGgEq1R4PW/lXCT2keUKxvSu2x6mRr8H5Lfgtk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=Hb9CFjvS; arc=none smtp.client-ip=209.85.218.42
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Received: by mail-ej1-f42.google.com with SMTP id a640c23a62f3a-a99eb8b607aso28532166b.2
        for <io-uring@vger.kernel.org>; Wed, 20 Nov 2024 15:33:09 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1732145588; x=1732750388; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=wymql0mU7Zf6dtk9Kzjz2Ao5/EDbYR0HVIjkz1dGWIE=;
        b=Hb9CFjvSs0JI1pziuG0Txvx+kuywNcJMmW0i0nhNsGlzam+KTAGTR5n5NGXUKuCHwe
         J2e8+J2r2PF4I/43pQBxdsbvRCjVjlz6FdHd7qhhRTFSUzL5IP4Yzb5Be0gAsejXG7ky
         9a60CmUwel9FMNbkf1zI/I/3OeoraaX7wttoldOWcgOYuDgfg/FfPxCa4kEZa9cBlXLC
         IBNHmbaRXH9dCf+u3OP+qxk9Q7cgVepVxOmY+c6WtUDEi/UkCZFAip9kNPRnnMVXHv3l
         63L3hg/MxBWQrc1HLhDuaMjVtSXNIXCSCDzCJP9alnWUdJ8g72wjehR5JNSkQfltX5aE
         8S8g==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1732145588; x=1732750388;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=wymql0mU7Zf6dtk9Kzjz2Ao5/EDbYR0HVIjkz1dGWIE=;
        b=retT+jZOlU16KJOdI9BXeDapFgj3jvx+UZC7i3XboeBBp+1hl53SZAmvg7bYSf49F7
         yVWeTvyxiA2xlOr2hLb956IPQbLmFtH9NLU1k7P3Qb+sdGi5tGLacTRlPUeOs1Xg819y
         juBNHQFA4DGC2sVFzfHebaZh7fFR/zJ/GZWUOCJ79BtKQlYtJ1lmQihJYRe9FWvPcMsZ
         CvJoMfKSNoeGOyr7kt/3JS6SvjR/p19ZmIYe0EEtAe9JkKjmMO/PxpR7gc8LylrhFPwh
         tvoZMfnRB2IsK5sAF0AbR+l/Hg+5Q0auZFK98zgIHzPr5Q0nPkiJbgv6xPZ36sOXV4hR
         VwwQ==
X-Gm-Message-State: AOJu0YxmZGth9g4M+8IJoy6REQ9Er/n1WcF3fNOf6QXY2x4eU7GZaoEC
	OifSUyx/mVE005IWWryBMS542PUE0WzKsXLONfAcXP4ULpGAGsJe1zkGQA==
X-Gm-Gg: ASbGncuDweE4zYbRN56AXBKTwZbi4PXT069t/qQnUDruizRk84hZSoM7Y1qkB1JkWXQ
	FgJIQ2PRlXOiaG4H1JJ29rCMuUKHyIYQZNdUPn2pIaIT49StO5t9+eD0Ws2oFbg/sISMwx5wcJV
	CXuFYH+Xgd75NB5Tg88R1nAotIkv2bX+rzi426IjT6qOGEGHHykPB8gwhkAiP2//p6maYjoUo55
	Rs4HnWPWO/lRhacKIkxtdfxr1K3s6LyKfh6GbEZJd1rt3nRQIEDujxb36/cGwP3
X-Google-Smtp-Source: AGHT+IEWZRZ+uFLV5ycaqb0WUe4bYSdUYNejW9UCFniUzvGb5F02ZUCVb4+N8QWlxN9FECzm+VKp8g==
X-Received: by 2002:a17:906:7953:b0:a9e:d4a9:2c28 with SMTP id a640c23a62f3a-aa4dd748bd2mr405608466b.53.1732145587687;
        Wed, 20 Nov 2024 15:33:07 -0800 (PST)
Received: from 127.0.0.1localhost ([148.252.141.165])
        by smtp.gmail.com with ESMTPSA id a640c23a62f3a-aa4f415372bsm12166066b.13.2024.11.20.15.33.06
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 20 Nov 2024 15:33:07 -0800 (PST)
From: Pavel Begunkov <asml.silence@gmail.com>
To: io-uring@vger.kernel.org
Cc: asml.silence@gmail.com
Subject: [PATCH 03/11] io_uring/memmap: add internal region flags
Date: Wed, 20 Nov 2024 23:33:26 +0000
Message-ID: <e46a4522ac58e92482d0e5c483a19c3e79ed0a90.1732144783.git.asml.silence@gmail.com>
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
index ac7b2b6484a9..31b420b8ecd9 100644
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


