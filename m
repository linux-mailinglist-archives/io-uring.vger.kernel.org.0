Return-Path: <io-uring+bounces-5133-lists+io-uring=lfdr.de@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from sy.mirrors.kernel.org (sy.mirrors.kernel.org [IPv6:2604:1380:40f1:3f00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id BE7AD9DE7A5
	for <lists+io-uring@lfdr.de>; Fri, 29 Nov 2024 14:34:06 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sy.mirrors.kernel.org (Postfix) with ESMTPS id 19539B20E8F
	for <lists+io-uring@lfdr.de>; Fri, 29 Nov 2024 13:34:04 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 4D31819CC27;
	Fri, 29 Nov 2024 13:34:02 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="PT/sjML/"
X-Original-To: io-uring@vger.kernel.org
Received: from mail-ej1-f50.google.com (mail-ej1-f50.google.com [209.85.218.50])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6BFD61990C1
	for <io-uring@vger.kernel.org>; Fri, 29 Nov 2024 13:34:00 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.218.50
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1732887242; cv=none; b=a8+/vhAbaEcVnl5wD8+2FsDkIHhR0nhkKWKhPMNnx6ffjhNvG0mHMD2INPBxSPZHNM06FPf4+NuyFWuu53jy4qYm7FKVewKe5rkmwg83cSipjKrrf9vojUPjay8FNIIkAiNtu/ERqdB2sgeMKXFV7BnMctwPGu6nRya//CBX/Vo=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1732887242; c=relaxed/simple;
	bh=gaoXkVQK/6Blrim3pGwGX4MUitHU/mfc/W6Tz0e1OaQ=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=ANyXkoQSqlOBicAbe8I2WVeDB9gO9IP1Lu43ybkR4FnE+Ud3P3C69uXviEpKUnj33WTQCn0z8g8C60FX5UZ0sUq4/l88YWQtas0s6i9/J3JLs46TT0OE10SULYPwT9EP1mJpsuCTNs1QMgtdts2IZDovWPWHeyN6IUltjxuntPo=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=PT/sjML/; arc=none smtp.client-ip=209.85.218.50
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Received: by mail-ej1-f50.google.com with SMTP id a640c23a62f3a-aa503cced42so260484266b.3
        for <io-uring@vger.kernel.org>; Fri, 29 Nov 2024 05:34:00 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1732887238; x=1733492038; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=3ioUfww6d+xizvBRIqAxbXDWFBnTg25uUcpGNl2DpxI=;
        b=PT/sjML/WRqH+sBtbU37oybP5L0xFZnK4MSt2gJJaLPTqypltzzZqQLBHeSrfynrEz
         VAJUeCTtq2gRVXYf9cvVSmCbMBoNWfWtQVd8MxtOGuSC1TEj8wiZe/TtbUUkBVHE1Haj
         bnofmWXGzbLrkV+7oIKILrkM9xoLPUIyxmZ9z1wCLfOS+cBIwv2OlExYWUS4M+XkudGl
         bbFkh6x2/8+Kgf6rA8saO8UAixFH57IWqgOliLVTuz6d8wZSBN8EEGNNk33kCNjymD3j
         G9qxq69WXMfbgljouhle1YfsUdw1HRYbfVpzDOl3LKCzrJTUmBK9M/5VjVt7wiAbiops
         gXJw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1732887238; x=1733492038;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=3ioUfww6d+xizvBRIqAxbXDWFBnTg25uUcpGNl2DpxI=;
        b=t7JPMg4r7GHLEORSdb+d5TlJsK13zA2UNyIFtxCej7xnHFleEYn922OJtqf5ycXxi5
         r4+3qjMpn9NEczVU3X60F6K8cSS2SKQhvystNmJ6poYBzsqhp9WQNjtAy+P8LiSF0HrH
         0J3lj8xnHZ5/OtcgE+7C4xVspGsAOF4PWwAWap+Ru3utC6NUJ6tWGVSU8aVrh6zb+vbb
         qBCbucD1/JYiMbQ4NEU5U7SWudmzwSsvCbX4F1Nw3zePnA1VvuY6KDWwhDM+gEa1cw9w
         XcRlup/G++TrwUwPkyM1PgNbdrKHS3X6ll+vJBAnYxC0gTbCJhXBgI8R5IKUClpxIL+e
         ulZg==
X-Gm-Message-State: AOJu0YwFjsWS4LR4/R/4mtTKmktswFJ2q+5V29cFo0gHms0sYOPs0F1W
	meKwGZjZD8XAos0rYndOyyjnzYvVXw8bu6VPb3pS5cNMeR7PJESNalUf4Q==
X-Gm-Gg: ASbGncvjmBCXuN8ubfzUlkXWBuq3CY23G7Vb83dyq1RQw42FpH17+FsGjL5wuHZj1Ps
	gL6+y98o/sWksAAY6Wpwqoq4GKKSjt7VxeGaB5DsAfXMILuC3Dervjaw2b9Lgle3xYmFCwgyRaG
	3lQwxOvqimQpeKCQNAb0Nr3W6yPXlzpjSEcMCp6rO9Oap5rqvGv7AHl0GmSTRH6lHJW/rBRia/q
	AOAtlle3/8ZRYobAbzj+L6u4PJ+FW0UjwePEF6+6rsucP3KXx+pXvKre4VAL9Lm
X-Google-Smtp-Source: AGHT+IG/E9Pevr9S3N9dRvZeS4JpzGj93YMh+NZmIjGRxBdZJychllAeQAR5qarAGwrwcdCw82CC9A==
X-Received: by 2002:a17:907:7808:b0:aa5:2d9a:152c with SMTP id a640c23a62f3a-aa580f1e03emr863113866b.13.1732887238290;
        Fri, 29 Nov 2024 05:33:58 -0800 (PST)
Received: from 127.0.0.1localhost ([163.114.131.193])
        by smtp.gmail.com with ESMTPSA id a640c23a62f3a-aa5996c2471sm173996866b.13.2024.11.29.05.33.57
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 29 Nov 2024 05:33:57 -0800 (PST)
From: Pavel Begunkov <asml.silence@gmail.com>
To: io-uring@vger.kernel.org
Cc: asml.silence@gmail.com
Subject: [PATCH v3 02/18] io_uring/rsrc: export io_check_coalesce_buffer
Date: Fri, 29 Nov 2024 13:34:23 +0000
Message-ID: <353b447953cd5d34c454a7d909bb6024c391d6e2.1732886067.git.asml.silence@gmail.com>
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
2.47.1


