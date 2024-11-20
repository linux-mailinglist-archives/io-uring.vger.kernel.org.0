Return-Path: <io-uring+bounces-4889-lists+io-uring=lfdr.de@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [IPv6:2604:1380:45e3:2400::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 92CD39D4484
	for <lists+io-uring@lfdr.de>; Thu, 21 Nov 2024 00:33:29 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 52E0B28337B
	for <lists+io-uring@lfdr.de>; Wed, 20 Nov 2024 23:33:28 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 93BFD1C82E2;
	Wed, 20 Nov 2024 23:33:10 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="aKrlgvtd"
X-Original-To: io-uring@vger.kernel.org
Received: from mail-ej1-f49.google.com (mail-ej1-f49.google.com [209.85.218.49])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B33BA1C1F12
	for <io-uring@vger.kernel.org>; Wed, 20 Nov 2024 23:33:08 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.218.49
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1732145590; cv=none; b=jNROM7GduA7gTni/9Bf4K5JhSF2QhwN/f/CwNtENbs+5R2dsyoMDagSD3SBHJjTldG9IWCwze1+bfuxln6vThsDzTM7F9b4aa1ODqypfty5M2S3ltgeNR6TNNKu/291S9FqAdy68ujCY6wF3xKMZjxDmue7MbFRQR9IrGySujP4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1732145590; c=relaxed/simple;
	bh=1jmb/YGUScs5yrYsukVscAuiJXOxz0cRSODGRVeVGzI=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=FSeSV4+H2elIQx1WhnsvEDkk/sB1Ig9c0l/JzBD+/sUHR5dmpzxD0997Nqo8eBvzwhMeFzO7rzQlOqTztbCbMb5K7s+m2RcFvH1Al63DPO8Yf6dLWwkafXKes/uvc8EcHQali4sPWY+vbOgigOOlSJLjiY8dZTm6GdJdbFUD1/E=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=aKrlgvtd; arc=none smtp.client-ip=209.85.218.49
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Received: by mail-ej1-f49.google.com with SMTP id a640c23a62f3a-a9ed7d8c86cso55750766b.2
        for <io-uring@vger.kernel.org>; Wed, 20 Nov 2024 15:33:08 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1732145587; x=1732750387; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=gaPvSNc+wa5krf/6t9pRuh8xeS0CHz0dlFRi5Cy4Ht8=;
        b=aKrlgvtdgH2K1WA7ahLerSEHx1UKpj+Zrv/f37k71mrEPdswfb3dEl+e8YHBpjHF7U
         2L1naNqlVpExDo8IRR5wUtJEBCqqc3LI5fjJdTbu2LhpQepvkGrIiXO+Ko9o2EoM8syA
         V7pGd2xfhEgq7rhH4TEShTHVYyLNKNsHZchRXuR76DEWzsbBUMHgOGNX9hkFHe93th1K
         F8+IuU2rlDfZ3lepRIsx1EJaSVpogVo1dVrA45yLXfEVXEUNydz3WjiTFyiJ93dTiydu
         zsdlWu4GIOG7CZYK1PupI/mAvqQGkby4GGav73jCjB/lNkAhQIuNmJRJrNpP9XGg5Xsi
         T4nw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1732145587; x=1732750387;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=gaPvSNc+wa5krf/6t9pRuh8xeS0CHz0dlFRi5Cy4Ht8=;
        b=QFT0y96+LQlWznGP+EOtBRUv1Mqe5XWw/xhYXN2eDBujP5LJLF+FFde2g6GKrQgbk5
         DDidRz2gBw6Bx4HP4C+CQsMe4WJBVFa03suqBSA0IwELXbZRSeLWDOm8X0sN1doGQCLD
         vp1PyalW+LVAsmDQN9JRZID9c2i315BWSNdX9z2CG99WclqNs6/E/Cn6QYj1fd1YEXl0
         tTIAzTrf0IY/K5lVhyUIcSOLIk2UuUVl6wtRlW9j8PzWQYIhnXkMwRrkU/swmJH47h8V
         Lb6DXbbfjVHV/4SiX68aJ3zjminT9hywBgF8WOU1VywiAesfeUjgI6WIJ7nOykSj8Nqb
         xBDA==
X-Gm-Message-State: AOJu0YygUmnwkTJJScEEfEfA6NOd5OjkfRJ2vqIB7yqqWch6Sp2g+sXM
	Pxka10iwzZE6LRHA+QeICOTaVnOAFvKJKJislNFe9/qoR8KmHVfueYIbGg==
X-Google-Smtp-Source: AGHT+IGBSQEtAl8P79cU/or/f2yAqVDkAV5rooLl9Yl4zSiub5mFOYSn4T4qDa2p4OX/f6pwTycqBA==
X-Received: by 2002:a17:906:c10a:b0:a9d:e1d6:41fc with SMTP id a640c23a62f3a-aa4dd752639mr439733766b.53.1732145586555;
        Wed, 20 Nov 2024 15:33:06 -0800 (PST)
Received: from 127.0.0.1localhost ([148.252.141.165])
        by smtp.gmail.com with ESMTPSA id a640c23a62f3a-aa4f415372bsm12166066b.13.2024.11.20.15.33.05
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 20 Nov 2024 15:33:06 -0800 (PST)
From: Pavel Begunkov <asml.silence@gmail.com>
To: io-uring@vger.kernel.org
Cc: asml.silence@gmail.com
Subject: [PATCH 02/11] io_uring/rsrc: export io_check_coalesce_buffer
Date: Wed, 20 Nov 2024 23:33:25 +0000
Message-ID: <8085256a8f07fc2c11c63c810a56b8fd8fe7a5eb.1732144783.git.asml.silence@gmail.com>
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

io_try_coalesce_buffer() is a useful helper collecting useful info about
a set of pages, I want to reuse it for analysing ring/etc. mappings. I
don't need the entire thing and only interested if it can be coalesced
into a single page, but that's better than duplicating the parsing.

Signed-off-by: Pavel Begunkov <asml.silence@gmail.com>
---
 io_uring/rsrc.c | 22 ++++++++++++----------
 io_uring/rsrc.h |  4 ++++
 2 files changed, 16 insertions(+), 10 deletions(-)

diff --git a/io_uring/rsrc.c b/io_uring/rsrc.c
index adaae8630932..e51e5ddae728 100644
--- a/io_uring/rsrc.c
+++ b/io_uring/rsrc.c
@@ -626,11 +626,12 @@ static int io_buffer_account_pin(struct io_ring_ctx *ctx, struct page **pages,
 	return ret;
 }
 
-static bool io_do_coalesce_buffer(struct page ***pages, int *nr_pages,
-				struct io_imu_folio_data *data, int nr_folios)
+static bool io_coalesce_buffer(struct page ***pages, int *nr_pages,
+				struct io_imu_folio_data *data)
 {
 	struct page **page_array = *pages, **new_array = NULL;
 	int nr_pages_left = *nr_pages, i, j;
+	int nr_folios = data->nr_folios;
 
 	/* Store head pages only*/
 	new_array = kvmalloc_array(nr_folios, sizeof(struct page *),
@@ -667,15 +668,14 @@ static bool io_do_coalesce_buffer(struct page ***pages, int *nr_pages,
 	return true;
 }
 
-static bool io_try_coalesce_buffer(struct page ***pages, int *nr_pages,
-					 struct io_imu_folio_data *data)
+bool io_check_coalesce_buffer(struct page **page_array, int nr_pages,
+			      struct io_imu_folio_data *data)
 {
-	struct page **page_array = *pages;
 	struct folio *folio = page_folio(page_array[0]);
 	unsigned int count = 1, nr_folios = 1;
 	int i;
 
-	if (*nr_pages <= 1)
+	if (nr_pages <= 1)
 		return false;
 
 	data->nr_pages_mid = folio_nr_pages(folio);
@@ -687,7 +687,7 @@ static bool io_try_coalesce_buffer(struct page ***pages, int *nr_pages,
 	 * Check if pages are contiguous inside a folio, and all folios have
 	 * the same page count except for the head and tail.
 	 */
-	for (i = 1; i < *nr_pages; i++) {
+	for (i = 1; i < nr_pages; i++) {
 		if (page_folio(page_array[i]) == folio &&
 			page_array[i] == page_array[i-1] + 1) {
 			count++;
@@ -715,7 +715,8 @@ static bool io_try_coalesce_buffer(struct page ***pages, int *nr_pages,
 	if (nr_folios == 1)
 		data->nr_pages_head = count;
 
-	return io_do_coalesce_buffer(pages, nr_pages, data, nr_folios);
+	data->nr_folios = nr_folios;
+	return true;
 }
 
 static struct io_rsrc_node *io_sqe_buffer_register(struct io_ring_ctx *ctx,
@@ -729,7 +730,7 @@ static struct io_rsrc_node *io_sqe_buffer_register(struct io_ring_ctx *ctx,
 	size_t size;
 	int ret, nr_pages, i;
 	struct io_imu_folio_data data;
-	bool coalesced;
+	bool coalesced = false;
 
 	if (!iov->iov_base)
 		return NULL;
@@ -749,7 +750,8 @@ static struct io_rsrc_node *io_sqe_buffer_register(struct io_ring_ctx *ctx,
 	}
 
 	/* If it's huge page(s), try to coalesce them into fewer bvec entries */
-	coalesced = io_try_coalesce_buffer(&pages, &nr_pages, &data);
+	if (io_check_coalesce_buffer(pages, nr_pages, &data))
+		coalesced = io_coalesce_buffer(&pages, &nr_pages, &data);
 
 	imu = kvmalloc(struct_size(imu, bvec, nr_pages), GFP_KERNEL);
 	if (!imu)
diff --git a/io_uring/rsrc.h b/io_uring/rsrc.h
index 7a4668deaa1a..c8b093584461 100644
--- a/io_uring/rsrc.h
+++ b/io_uring/rsrc.h
@@ -40,6 +40,7 @@ struct io_imu_folio_data {
 	/* For non-head/tail folios, has to be fully included */
 	unsigned int	nr_pages_mid;
 	unsigned int	folio_shift;
+	unsigned int	nr_folios;
 };
 
 struct io_rsrc_node *io_rsrc_node_alloc(struct io_ring_ctx *ctx, int type);
@@ -66,6 +67,9 @@ int io_register_rsrc_update(struct io_ring_ctx *ctx, void __user *arg,
 int io_register_rsrc(struct io_ring_ctx *ctx, void __user *arg,
 			unsigned int size, unsigned int type);
 
+bool io_check_coalesce_buffer(struct page **page_array, int nr_pages,
+			      struct io_imu_folio_data *data);
+
 static inline struct io_rsrc_node *io_rsrc_node_lookup(struct io_rsrc_data *data,
 						       int index)
 {
-- 
2.46.0


