Return-Path: <io-uring+bounces-5296-lists+io-uring=lfdr.de@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [147.75.199.223])
	by mail.lfdr.de (Postfix) with ESMTPS id 2AD269E882B
	for <lists+io-uring@lfdr.de>; Sun,  8 Dec 2024 22:45:17 +0100 (CET)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id 26E55163929
	for <lists+io-uring@lfdr.de>; Sun,  8 Dec 2024 21:45:14 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 314D246B8;
	Sun,  8 Dec 2024 21:45:14 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="XVfzggZ1"
X-Original-To: io-uring@vger.kernel.org
Received: from mail-wm1-f52.google.com (mail-wm1-f52.google.com [209.85.128.52])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6F62684D29
	for <io-uring@vger.kernel.org>; Sun,  8 Dec 2024 21:45:12 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.128.52
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1733694314; cv=none; b=BgndDySWyTqmQK++MBDsmjSxHAjA2KLpc7OdjnMgYVXXqCICRkLHrCntr9lqfJAxVu546EF3v64/6M19m2wtB4jVBOxEaB8Skw4gpRqza6QUceH7xCKtnkWSbt4/tiO+ATci9PLhBTGySMr9M+V5+RKmrlsU62ZvzUsshNvRtoo=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1733694314; c=relaxed/simple;
	bh=mA4vngv1U6tHbaWaEKMAlZz7zOtGtxLGVyzRcyfL0gs=;
	h=From:To:Cc:Subject:Date:Message-ID:MIME-Version; b=SBOCuemN9oP4w2CWENSbESLXCB5qU4zgVtq1MqBOIeBvj/NSW3bIRjD+fAHyYKLPVJuG+cgsettNEmwEZynkLpmmB4KhfL19u6Zx//Ojcze+NL26T1ljtTd9nN+I4cj/94ktQ9HHfgy22Q/nkn1g+TC2TR8QBUAO0VJjaWmv66M=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=XVfzggZ1; arc=none smtp.client-ip=209.85.128.52
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Received: by mail-wm1-f52.google.com with SMTP id 5b1f17b1804b1-434aa222d96so40573905e9.0
        for <io-uring@vger.kernel.org>; Sun, 08 Dec 2024 13:45:12 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1733694310; x=1734299110; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:from:to:cc:subject:date:message-id:reply-to;
        bh=e1JOt/zNLFqhFH4ivuWeR4V8pWnXgp2EAajFVomYtio=;
        b=XVfzggZ1ACDV1Fp/73uLx0Qyxw1CVfSSZne3duF4UCL/PiPd7LMI6kAgo9IDvEr7CI
         AfWzuBV9TiUJJAXpUCylXTYVmR43J5IHJMP+rijwIN7yF28dZ27leMyb2F9vcEcZXNvH
         JhEqucFp2Bk+ZqmXEWC4sN99ie+ScNOfHCqXqVpGfVCNQO7+SQn21t3DFujs4AJhoL6W
         s3GwQMTqxgsAEA5mDQA+BcY2m7C9fv98ynwBY5GnDVN/Q/SAU1UFP2xJAFvlvTGkyvZs
         oJXEp30eSNDyx6n8Opp8Re4EaurXaEI6CHJHBLO4g72tUXcdi0RR25f+n+UsI2N+OzDA
         3Jcw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1733694310; x=1734299110;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=e1JOt/zNLFqhFH4ivuWeR4V8pWnXgp2EAajFVomYtio=;
        b=eWenPcFusQ0jtH5PnjwIrJiFQ4TnhmEEiWPCCwV79CJskNrqXg4jsoYPxBVRDAGrC1
         A/ey1cdKcr2wbt8eLWs4admoLROcKvC5jsErSdtQaaVX2+JormDKF4626CsL/JEV+BoC
         Vf+4NpCYT34inQ1VJ3vlblT5D4Jw2Y0QQCNNrStqjAd+SDYSwPeoe7NQA6LQOT98luqm
         WoeV/29GGpb6VCy6xgparA4wmBomAxA9gF5Sz455ahjhaEQsVACn7ibdOG7qTBAmzqYg
         nztW8u0ukfvLirsK6OfEXoTT+ZEA9oNkg2Fa96j5/fbjmi0h5aYMd1IikDWRTtiOFNFx
         ITwQ==
X-Gm-Message-State: AOJu0YwLZQz/8ppN3Gturrd+3eJNvkZqr4l/Sw57SYSix0lC0RhWkj+b
	b2ZeiDzpZRuYXgrhmqioLHOsdlzkKZlSrQj7RY7QVMAcxfe+lLpncwAg6g==
X-Gm-Gg: ASbGncuiIp06MFsFm9hOdnGrRLx8ljOBDf/oIHlxaN27BHz0/MTpOuxFM1whCCGkWmZ
	INnGOttSmjwfe5/cbFpGYJJ8IaMmXgBy7/h1Yt5sdYX4xh1ubjTy+oFsm8sz4XSxfLrmjJSwbKi
	7lw7U6ICnYyYyTaDxUS5tXm7rzL5gNjSSOi1ZH4T/VZSFbJqoEX8/hwBMiVtNBHpgVLKDPg40RK
	v+OMDg7AlbcZPDdLbOK5Te+QhCoa4gLxPFugraM71hubsL/2fHquZ2FHyKhE2g=
X-Google-Smtp-Source: AGHT+IEWRk2OWsWRWVwtorguPnxAVx/B1fBRU/kEsL1q6ApzTTw5GVMKV8fubDN7bmZl16KDrOMY/Q==
X-Received: by 2002:a05:600c:a08d:b0:434:f586:7520 with SMTP id 5b1f17b1804b1-434f5867a3cmr16528755e9.6.1733694310239;
        Sun, 08 Dec 2024 13:45:10 -0800 (PST)
Received: from 127.0.0.1localhost ([85.255.235.149])
        by smtp.gmail.com with ESMTPSA id 5b1f17b1804b1-434d526b577sm172335155e9.3.2024.12.08.13.45.09
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sun, 08 Dec 2024 13:45:09 -0800 (PST)
From: Pavel Begunkov <asml.silence@gmail.com>
To: io-uring@vger.kernel.org
Cc: asml.silence@gmail.com
Subject: [PATCH 1/1] io_uring: don't vmap single page regions
Date: Sun,  8 Dec 2024 21:46:01 +0000
Message-ID: <cb83e053f318857068447d40c95becebcd8aeced.1733689833.git.asml.silence@gmail.com>
X-Mailer: git-send-email 2.47.1
Precedence: bulk
X-Mailing-List: io-uring@vger.kernel.org
List-Id: <io-uring.vger.kernel.org>
List-Subscribe: <mailto:io-uring+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:io-uring+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

When io_check_coalesce_buffer() meets a single page buffer it bails out
and tells that it can be coalesced. That's fine for registered buffers
as io_coalesce_buffer() wouldn't change anything, but the region code
now uses the function to decided on whether to vmap the buffer or not.

Report that a single page buffer is trivially coalescable and let
io_sqe_buffer_register() to filter them.

Fixes: cc2f1a864c27a ("io_uring/memmap: optimise single folio regions")
Signed-off-by: Pavel Begunkov <asml.silence@gmail.com>
---
 io_uring/rsrc.c | 13 +++++--------
 1 file changed, 5 insertions(+), 8 deletions(-)

diff --git a/io_uring/rsrc.c b/io_uring/rsrc.c
index 9208cf77c41e..0f1cd0a1d880 100644
--- a/io_uring/rsrc.c
+++ b/io_uring/rsrc.c
@@ -675,14 +675,9 @@ bool io_check_coalesce_buffer(struct page **page_array, int nr_pages,
 	unsigned int count = 1, nr_folios = 1;
 	int i;
 
-	if (nr_pages <= 1)
-		return false;
-
 	data->nr_pages_mid = folio_nr_pages(folio);
-	if (data->nr_pages_mid == 1)
-		return false;
-
 	data->folio_shift = folio_shift(folio);
+
 	/*
 	 * Check if pages are contiguous inside a folio, and all folios have
 	 * the same page count except for the head and tail.
@@ -750,8 +745,10 @@ static struct io_rsrc_node *io_sqe_buffer_register(struct io_ring_ctx *ctx,
 	}
 
 	/* If it's huge page(s), try to coalesce them into fewer bvec entries */
-	if (io_check_coalesce_buffer(pages, nr_pages, &data))
-		coalesced = io_coalesce_buffer(&pages, &nr_pages, &data);
+	if (nr_pages > 1 && io_check_coalesce_buffer(pages, nr_pages, &data)) {
+		if (data.nr_pages_mid != 1)
+			coalesced = io_coalesce_buffer(&pages, &nr_pages, &data);
+	}
 
 	imu = kvmalloc(struct_size(imu, bvec, nr_pages), GFP_KERNEL);
 	if (!imu)
-- 
2.47.1


