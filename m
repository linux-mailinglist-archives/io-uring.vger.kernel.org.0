Return-Path: <io-uring+bounces-5009-lists+io-uring=lfdr.de@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [IPv6:2604:1380:45e3:2400::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 91C5C9D7836
	for <lists+io-uring@lfdr.de>; Sun, 24 Nov 2024 22:12:09 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 537DB281EA5
	for <lists+io-uring@lfdr.de>; Sun, 24 Nov 2024 21:12:08 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id ECB6913FD72;
	Sun, 24 Nov 2024 21:12:06 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="btr6UIMz"
X-Original-To: io-uring@vger.kernel.org
Received: from mail-wm1-f42.google.com (mail-wm1-f42.google.com [209.85.128.42])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1CF5B163
	for <io-uring@vger.kernel.org>; Sun, 24 Nov 2024 21:12:04 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.128.42
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1732482726; cv=none; b=h4/kUCsz/PY93yyPTPNvJ4bz6RqzdYeFsqejLxEnQfqURYfjlwbpNmBqti1T9BfufiGpQl3bfXjbgV3EIoV7PuekF2QC4gPRWO06cCzFwldVLfrmqNDJxG9SXdGJ2RVK44Wi9twXLKydPP0SSmI4RHgXcZl436rzP3PngtPEgDg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1732482726; c=relaxed/simple;
	bh=1jmb/YGUScs5yrYsukVscAuiJXOxz0cRSODGRVeVGzI=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=SKOYXeU/KnVUWTqGIxPlmi9N6sPSulSybkCom3S8uqBO7hNhV3kfZMS9NCpjWgTdVxz/MeqzlNIO/WogE8FydNiVZsQ+phxkCSAyT8jr7abzYyYS/KNxNUEJLTmmFz4rAyWOWo3HBFQdLEEYFq+HLpFACDJmu5ua+LqLEtvtY9M=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=btr6UIMz; arc=none smtp.client-ip=209.85.128.42
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Received: by mail-wm1-f42.google.com with SMTP id 5b1f17b1804b1-434a099ba95so129555e9.0
        for <io-uring@vger.kernel.org>; Sun, 24 Nov 2024 13:12:04 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1732482723; x=1733087523; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=gaPvSNc+wa5krf/6t9pRuh8xeS0CHz0dlFRi5Cy4Ht8=;
        b=btr6UIMzI88dtQ0kKhuLu1jrhnNZ9jqjCfhixpxFAmtXPfkHF2nxdF0hZdT9h+7CAt
         meQW7CKMZdOT8THsrsB5GfbhysL2j1ldO1UjttS8O7GNZkyR7QtnKNxqH7iBxmPqFjWz
         wX+wNFv6m5XBpwbyWWze+1eXozP7tP3NUOUFfeYr6nQAcFYx6sH4McxxBEZFNhNIE9Sa
         lkbSVhyO9C5r3etmw3+Aju+6Km1fdzB2Fn+zYLSV4Jm5rJlCFdv6qwBCLlnyiElifGoV
         KZ9f8J/4uVYH3KC9L06KxT2zJA611xSzzzRcr1h6SewPSRfxnUOefuNNkFTtarIthFCD
         UzKg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1732482723; x=1733087523;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=gaPvSNc+wa5krf/6t9pRuh8xeS0CHz0dlFRi5Cy4Ht8=;
        b=jH9F5Atjk4v/Qw2N77GxK5/b/2gL3Vg98moG6N2veyFPfCBtmjRk0Jz7nrwhnavcfN
         cTblDy0VSC5JKVMtrex8I43A7ld5zdhInAWjUMbUifIljDLpQ3ClTXjo5MEqbsU+/SIQ
         EKurx4s/wZlaRSJ6M64bI7dt+vpQwROaOIei0fA9R2c7qoGpos0kjgEKLxP/1BdDp7kp
         c+YT8DKs7fe/S7eFcyeY0rMgpFOT5EWpJJ9cfiXscGGM37B74e8zjbvxDE070m9guJ1p
         42t0Q6PhGh9N21iUGI5A1phUAJdvgCEwpWzN499783WR3eIojIg+gnTpmmcwqynXm3dM
         DnPg==
X-Gm-Message-State: AOJu0Ywyplx0cCH+SK+Zlbf9t2RUzPmWkN292CJWuxLboeNrjLRekvM+
	ZNTQBgCfSBMp7BLaZ5rzkhvCe3IZ//jtpmmIh2amRet4TaigqGIynoWiBg==
X-Gm-Gg: ASbGncvPyR/0rkA1weSEBzWo+fFSgUWk9gipr+OMJiYaR2sk0x/jBv00QjejYliO5rN
	8jGHy7tL+b1SExKRBjpBGy7McCdrBNYlPMkU1SJfapu+jxOb2Uw3DJ//xFgAfMBofcRqejjMc6X
	xk8uK6GDLkrp7CerZSLcbr8KYK61oonJVwQNSAsKaAs+UB9the0DFqagBw7WbOtTrEbD5/vi02F
	5gJZ6daexg6/i3M1NJ8GrJ/9A55nNXSX2cNXbLyTpGe5If8NH0VkO/PWxVuxRQ=
X-Google-Smtp-Source: AGHT+IGZO+gfmdQKj8NYX5z7sQDyeONWOeooKM6+STiKR/au2AZVcwRCAKoSsARdhKCyRCHSTIBFug==
X-Received: by 2002:a05:6000:401f:b0:37c:d57d:71cd with SMTP id ffacd0b85a97d-38260be22f9mr9864420f8f.52.1732482722480;
        Sun, 24 Nov 2024 13:12:02 -0800 (PST)
Received: from 127.0.0.1localhost ([85.255.235.224])
        by smtp.gmail.com with ESMTPSA id 5b1f17b1804b1-432f643b299sm132733745e9.0.2024.11.24.13.12.01
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sun, 24 Nov 2024 13:12:01 -0800 (PST)
From: Pavel Begunkov <asml.silence@gmail.com>
To: io-uring@vger.kernel.org
Cc: asml.silence@gmail.com
Subject: [PATCH v2 02/18] io_uring/rsrc: export io_check_coalesce_buffer
Date: Sun, 24 Nov 2024 21:12:19 +0000
Message-ID: <4a82c18ed2615f3381f1849f108a421c2022c846.1732481694.git.asml.silence@gmail.com>
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


