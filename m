Return-Path: <io-uring+bounces-10496-lists+io-uring=lfdr.de@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [IPv6:2604:1380:45e3:2400::1])
	by mail.lfdr.de (Postfix) with ESMTPS id A902EC46C20
	for <lists+io-uring@lfdr.de>; Mon, 10 Nov 2025 14:05:04 +0100 (CET)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id D05CB3B7041
	for <lists+io-uring@lfdr.de>; Mon, 10 Nov 2025 13:05:02 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id BF1EA1F63F9;
	Mon, 10 Nov 2025 13:05:01 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="CpzFDTFT"
X-Original-To: io-uring@vger.kernel.org
Received: from mail-wr1-f52.google.com (mail-wr1-f52.google.com [209.85.221.52])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0E1DA1A704B
	for <io-uring@vger.kernel.org>; Mon, 10 Nov 2025 13:04:59 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.221.52
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1762779901; cv=none; b=OL4PNO1uK58rTx2T85jMIr5MILFaM9CCEltCYuDraiUkVg9kn97coPfnyLPs7m26P3L1mLO0gEWZPghT5TJl3BgrYg29dSYrvdGFzNJBfo7mOETkKafdicFxWQZ0PPmc1te8GWBpdsaaogCbBLslyLUtiPjbDeeELRvk5NjXt7s=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1762779901; c=relaxed/simple;
	bh=USdl8wx0OZ4NcLMSQrwBr/01iPmWFWLcUQUM7Ojt5Vk=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=aHTbbx7b7jlSFUqnCacvsjmaRiVxrKwcmEpqytOA+/coU7tT9A/wAj2viLO31tfCIwlYYYFWf1kXyVcf3cfhv0Ygf4HRo/NJh4d1nqnTeHQY1pa7KlVmXHrz2kKIzE9BORhmJmksUwhboG8e+HbIAYw2Yob8FlSINH8+l2vw+IU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=CpzFDTFT; arc=none smtp.client-ip=209.85.221.52
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Received: by mail-wr1-f52.google.com with SMTP id ffacd0b85a97d-42b3d7c1321so414521f8f.3
        for <io-uring@vger.kernel.org>; Mon, 10 Nov 2025 05:04:59 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1762779898; x=1763384698; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=ixkmHxQuOosCuA7buSKgbZx7USj4ijnqk/+8sNsuHfQ=;
        b=CpzFDTFTeTDN7qoNFlqjM4mx9E1ydbmPiOw5nwfy2/Qz3jxj0KGUcla3nSSF4RnjOt
         ux2XHDqACTparMN+grs3tH7V1u2mZNNkD/lX+TFUxSINXSrsP36GC5E6XZANvJwf8N2l
         faSD1GzSgwqtZH+/v0X5Lva4oCewBlq5NSidm2WxgjEJApUomr9eJYaSYQ5SHCW3OsE/
         Pnabj2OnsjSeyP5FAm/56FaYwHjK+pR43Z7q4z0GgV5qYUi2IPEoaNeoyAMYjGH0GOri
         w9ZFsaQ4hpbpBczfFkjpkrJsp4fMhcGkuwBkpSe1ddJH9b687xF3Qc1GDzKLn88rCfmN
         sUFw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1762779898; x=1763384698;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to;
        bh=ixkmHxQuOosCuA7buSKgbZx7USj4ijnqk/+8sNsuHfQ=;
        b=wreyOJk14mPyeRpLwx1f2QV3IKUHvGN6voizenurpd+m43KFubEXySmgtffT2HPNP7
         YM7noSkQevvqq6QRDVt9HKw/FC1WL0JmEpVZkiO5tGgOlQ0YhudSgdhSwfTa8e49W1t4
         l6j16V5CJP0arEaZqXqAqDQmTYqDRsIU2rtR06/X8WxCRzRUDh61l7bRR1Lv1byHuh1k
         GgGEXan7w57czdKj0PHGZeokpE9NmB938HxMMYgaod+oVkHB/qdmFDSmYODT6KW+zo/f
         vBA30pvYUhglm+0PDkGNzscZeU2kdW35E20D/bk1I8bjrKFiPc2S6KOJy8Fy3md7sc3W
         fWTA==
X-Gm-Message-State: AOJu0YxOkeCUr/aaxRRdJg28PZpvepEoq069WzSKiQBp1qcNufVBCE8Q
	zVwrzioOSw7o4OLBTTx5PJfHwPA2wW8wGqu0oNamAnTKvhNzQhjaZSR8kGSesQ==
X-Gm-Gg: ASbGnct7LAglCt7jcVMEPZw8dEuUnzlt9zXdKt4RkZtry/5wyPnSDAo9xyArYBgKAci
	ZBNrC+yKa7RKQ+UBWfOeQgpACIBgr+HVVvJP0DX8jVBYU7b3p49m8nHxf1wwg5jSwZJufJPvwZF
	pq/5AyweI33RVxBX6Nfoy/tDLKzK5j+pLcFSSx1RyVOy+29IzA50NRSNohtjSs2sJGbEnYfkI5q
	kc6bRZ3JLhs5guRmTPwyBMvPU6yauueHrZl5xaaw4jSKpHKMfJ6oNyslSvBIL6CaLuNevZhPc0a
	rLKo9shwsKkCTtFFgkWPvAqQTU+KisPXRvNiep+p5XhlzJdwt1uhcJHaJyspgMOXC5vI1NuiqPF
	80irC/VBqusdXo1HQ3RRjgge/x1bkgOIgv2SaMzeuMI13rwazzJeb6n8nV+mmMYsyrH1NPyThmU
	wYrYZavvnYR/WN7A==
X-Google-Smtp-Source: AGHT+IETNmL1lVmr7+cxQvVOw/i1u7Q5fZl6FByhbKMG6yfRUtx3ip6JbmX+B4qRwvzR2hjW8zXSIg==
X-Received: by 2002:a05:6000:26d1:b0:42b:3302:f7d4 with SMTP id ffacd0b85a97d-42b3302fd6cmr4553909f8f.22.1762779897487;
        Mon, 10 Nov 2025 05:04:57 -0800 (PST)
Received: from 127.mynet ([2a01:4b00:bd21:4f00:7cc6:d3ca:494:116c])
        by smtp.gmail.com with ESMTPSA id ffacd0b85a97d-42b330f6899sm10584648f8f.21.2025.11.10.05.04.56
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 10 Nov 2025 05:04:56 -0800 (PST)
From: Pavel Begunkov <asml.silence@gmail.com>
To: io-uring@vger.kernel.org
Cc: asml.silence@gmail.com
Subject: [PATCH 1/4] io_uring: add helper calculating region byte size
Date: Mon, 10 Nov 2025 13:04:49 +0000
Message-ID: <e42e7f3fa3b43a8b8af896f7edc251b113ad7b77.1762701490.git.asml.silence@gmail.com>
X-Mailer: git-send-email 2.49.0
In-Reply-To: <cover.1762701490.git.asml.silence@gmail.com>
References: <cover.1762701490.git.asml.silence@gmail.com>
Precedence: bulk
X-Mailing-List: io-uring@vger.kernel.org
List-Id: <io-uring.vger.kernel.org>
List-Subscribe: <mailto:io-uring+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:io-uring+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

There has been type related issues with region size calculation, add an
utility helper function that returns the size and handles type
conversions right.

Signed-off-by: Pavel Begunkov <asml.silence@gmail.com>
---
 io_uring/memmap.c | 4 ++--
 io_uring/memmap.h | 5 +++++
 2 files changed, 7 insertions(+), 2 deletions(-)

diff --git a/io_uring/memmap.c b/io_uring/memmap.c
index 24da17a5f08f..dc4bfc5b6fb8 100644
--- a/io_uring/memmap.c
+++ b/io_uring/memmap.c
@@ -134,7 +134,7 @@ static int io_region_init_ptr(struct io_mapped_region *mr)
 static int io_region_pin_pages(struct io_mapped_region *mr,
 			       struct io_uring_region_desc *reg)
 {
-	unsigned long size = mr->nr_pages << PAGE_SHIFT;
+	size_t size = io_region_size(mr);
 	struct page **pages;
 	int nr_pages;
 
@@ -154,7 +154,7 @@ static int io_region_allocate_pages(struct io_mapped_region *mr,
 				    unsigned long mmap_offset)
 {
 	gfp_t gfp = GFP_KERNEL_ACCOUNT | __GFP_ZERO | __GFP_NOWARN;
-	size_t size = (size_t) mr->nr_pages << PAGE_SHIFT;
+	size_t size = io_region_size(mr);
 	unsigned long nr_allocated;
 	struct page **pages;
 
diff --git a/io_uring/memmap.h b/io_uring/memmap.h
index a6c63ca2c6f1..d2a940682d19 100644
--- a/io_uring/memmap.h
+++ b/io_uring/memmap.h
@@ -43,4 +43,9 @@ static inline void io_region_publish(struct io_ring_ctx *ctx,
 	*dst_region = *src_region;
 }
 
+static inline size_t io_region_size(struct io_mapped_region *mr)
+{
+	return (size_t)mr->nr_pages << PAGE_SHIFT;
+}
+
 #endif
-- 
2.49.0


