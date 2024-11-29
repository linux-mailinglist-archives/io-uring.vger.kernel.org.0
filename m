Return-Path: <io-uring+bounces-5139-lists+io-uring=lfdr.de@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [139.178.88.99])
	by mail.lfdr.de (Postfix) with ESMTPS id B71809DE7A8
	for <lists+io-uring@lfdr.de>; Fri, 29 Nov 2024 14:34:09 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 7D7842817F0
	for <lists+io-uring@lfdr.de>; Fri, 29 Nov 2024 13:34:08 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 9A77419D091;
	Fri, 29 Nov 2024 13:34:06 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="QTJxMkR+"
X-Original-To: io-uring@vger.kernel.org
Received: from mail-lf1-f43.google.com (mail-lf1-f43.google.com [209.85.167.43])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C21551990C1
	for <io-uring@vger.kernel.org>; Fri, 29 Nov 2024 13:34:04 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.167.43
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1732887246; cv=none; b=O69sBYDc2ARRASCzKbEwW0/b2tKSXcK6mDB+R28nw5bP9VeOMfqknJZfyYoBMmfH77QAmKfjQ7bVmhHLDJZd4Q44vTpo5kQfcE3uaafVcctKryrsMwUqLh+5KOHJ1wRAY0OEBaYcN2v7P84EjyEuhVVvcBhXgP/E9jy4mI1YoqU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1732887246; c=relaxed/simple;
	bh=0HSMXa5ydW7c2+PHnx1xmN1oHJJ2GN/Ij2zM+mEECIA=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=ondViAQIWMjel3DrlAawLqSAp64epCMwPs7jb/pfjfh1dOk+11b2O8zu/z8GjNZu40uEOQm6PQwsKpPjrEv921KlAZalncEYbngcS2US65bENEOYHF6jNdz7TiK7yr+p01Qyu6R7uygCjTzxX4O00hqk3tpUOG2YFhvlwt1Q1PE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=QTJxMkR+; arc=none smtp.client-ip=209.85.167.43
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Received: by mail-lf1-f43.google.com with SMTP id 2adb3069b0e04-53de579f775so2841440e87.2
        for <io-uring@vger.kernel.org>; Fri, 29 Nov 2024 05:34:04 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1732887243; x=1733492043; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=y7DUsvzcDYnCxbLMe5yWIbUXISp/cV61F4ZJFZF0PUI=;
        b=QTJxMkR+aicmk9AabuPPX1DYtyqYip1nNUAJZCU/3GxGaJ6jiISMoR+kSRxgN9/f49
         3M2ZNZfAeeEbVEp7zMKo+asvFQ+VBdumhsSD+tSaXIp6EIpeS3yuR+PD2ovMNdLmuc4R
         JydtdCiYcET1cBraXi/IeXu7tSN2ZxqEh6yAIPY4jVnceRO8nhHUl4BplhSyT4ldkr0Y
         A16tHCTudT4FlX5zkV9uoPGP+4qkdCt1OoPyvpvckTsBIkwN8PLppqHrksQD03LMDbeG
         hF+joAhIP5SMRRu7YgeMd50QOdBPKm5lezSWkVMIh8LUwHsssoyjE9xDM2T91Hfvf73L
         PR7Q==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1732887243; x=1733492043;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=y7DUsvzcDYnCxbLMe5yWIbUXISp/cV61F4ZJFZF0PUI=;
        b=C1xF8bd9sH1nMDLGzgxSDCzF/zHdcLKv4bhkwX3gXXVxx8gjBesVVAiIMn1kw/62ma
         mgJMTwjd99vbcBNYerBtC98PLENlmkcl7fcBQC7fDc8PxEV/YSKgBNtJRyXz1TZxvnqx
         /e47CBO6tKlaUr+BlhxHkDRWA/pYiC58OiwZF9mefi3nAZAinDQEoI153Biv8dABxyeE
         3wRok1hMd/Ixjxk0AvrzwaaMqNptixaiD8TvOI4y4AVblLqBaGKHJpsagNHQnk0YJ4EN
         7JQmmSqE30YJNGiWocSEFvGs5MR9ZPTF/CAMVdaq8l1frUYgMhJYBweKZPkPlJW/rBJv
         4cUQ==
X-Gm-Message-State: AOJu0Ywc0j2udEcYJgNZws8VV3BdQjjiZT6BSf7fH7DRZplbrRKAm2fJ
	E2+X61anDgOPBkOoVf/kbEsMcnO0qU30vsp1tfma0fp5qFk4+/ogNOwqZA==
X-Gm-Gg: ASbGnctTJJyx5gZBxLdRwpoGKOCqm6bFBZQEjkmuzZXKLt9vXHzETrgjztMdCOQUDov
	fnz1aTl9ol05xMf4DtrEPY9lChYU7a44OlGsn1Gr5A6Nl1WtitLHxv4gE664yTMBWySLscaEovw
	4PwIWtHbAPX6pR2L6cmUEkVOu0NPcfsZcv/okABoyvshdLzDXdlNYhsACbtDNZGw4QP7CSkzxhQ
	0w4XBkU0OnOv6c/u6ABuQAFUTkOqejw3D8q11dycfBC+mh+Y/GvXRY6MlmSxZYL
X-Google-Smtp-Source: AGHT+IF40+OtybuLZ3RxOqfCt3cLscbhQoVOgRNJ6yeSzp6q/4Ezf2kngq10/YxeHrZ33Bw5If5Cyw==
X-Received: by 2002:a19:9147:0:b0:53d:f0ca:41f2 with SMTP id 2adb3069b0e04-53df0ca4242mr8444911e87.41.1732887242480;
        Fri, 29 Nov 2024 05:34:02 -0800 (PST)
Received: from 127.0.0.1localhost ([163.114.131.193])
        by smtp.gmail.com with ESMTPSA id a640c23a62f3a-aa5996c2471sm173996866b.13.2024.11.29.05.34.01
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 29 Nov 2024 05:34:01 -0800 (PST)
From: Pavel Begunkov <asml.silence@gmail.com>
To: io-uring@vger.kernel.org
Cc: asml.silence@gmail.com
Subject: [PATCH v3 07/18] io_uring/memmap: optimise single folio regions
Date: Fri, 29 Nov 2024 13:34:28 +0000
Message-ID: <d5240af23064a824c29d14d2406f1ae764bf4505.1732886067.git.asml.silence@gmail.com>
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

We don't need to vmap if memory is already physically contiguous. There
are two important cases it covers: PAGE_SIZE regions and huge pages.
Use io_check_coalesce_buffer() to get the number of contiguous folios.

Signed-off-by: Pavel Begunkov <asml.silence@gmail.com>
---
 io_uring/memmap.c | 29 ++++++++++++++++++++++-------
 1 file changed, 22 insertions(+), 7 deletions(-)

diff --git a/io_uring/memmap.c b/io_uring/memmap.c
index 96c4f6b61171..fd348c98f64f 100644
--- a/io_uring/memmap.c
+++ b/io_uring/memmap.c
@@ -226,12 +226,31 @@ void io_free_region(struct io_ring_ctx *ctx, struct io_mapped_region *mr)
 	memset(mr, 0, sizeof(*mr));
 }
 
+static int io_region_init_ptr(struct io_mapped_region *mr)
+{
+	struct io_imu_folio_data ifd;
+	void *ptr;
+
+	if (io_check_coalesce_buffer(mr->pages, mr->nr_pages, &ifd)) {
+		if (ifd.nr_folios == 1) {
+			mr->ptr = page_address(mr->pages[0]);
+			return 0;
+		}
+	}
+	ptr = vmap(mr->pages, mr->nr_pages, VM_MAP, PAGE_KERNEL);
+	if (!ptr)
+		return -ENOMEM;
+
+	mr->ptr = ptr;
+	mr->flags |= IO_REGION_F_VMAP;
+	return 0;
+}
+
 int io_create_region(struct io_ring_ctx *ctx, struct io_mapped_region *mr,
 		     struct io_uring_region_desc *reg)
 {
 	struct page **pages;
 	int nr_pages, ret;
-	void *vptr;
 	u64 end;
 
 	if (WARN_ON_ONCE(mr->pages || mr->ptr || mr->nr_pages))
@@ -267,13 +286,9 @@ int io_create_region(struct io_ring_ctx *ctx, struct io_mapped_region *mr,
 	mr->pages = pages;
 	mr->flags |= IO_REGION_F_USER_PROVIDED;
 
-	vptr = vmap(pages, nr_pages, VM_MAP, PAGE_KERNEL);
-	if (!vptr) {
-		ret = -ENOMEM;
+	ret = io_region_init_ptr(mr);
+	if (ret)
 		goto out_free;
-	}
-	mr->ptr = vptr;
-	mr->flags |= IO_REGION_F_VMAP;
 	return 0;
 out_free:
 	io_free_region(ctx, mr);
-- 
2.47.1


