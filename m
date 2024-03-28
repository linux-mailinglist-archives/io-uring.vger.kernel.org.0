Return-Path: <io-uring+bounces-1317-lists+io-uring=lfdr.de@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from sy.mirrors.kernel.org (sy.mirrors.kernel.org [IPv6:2604:1380:40f1:3f00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 7F4F6890E90
	for <lists+io-uring@lfdr.de>; Fri, 29 Mar 2024 00:35:13 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sy.mirrors.kernel.org (Postfix) with ESMTPS id 05889B2338D
	for <lists+io-uring@lfdr.de>; Thu, 28 Mar 2024 23:35:11 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 90EDD225A8;
	Thu, 28 Mar 2024 23:35:09 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel-dk.20230601.gappssmtp.com header.i=@kernel-dk.20230601.gappssmtp.com header.b="oljRFRg6"
X-Original-To: io-uring@vger.kernel.org
Received: from mail-pf1-f181.google.com (mail-pf1-f181.google.com [209.85.210.181])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1BAAD1311AC
	for <io-uring@vger.kernel.org>; Thu, 28 Mar 2024 23:35:07 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.210.181
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1711668909; cv=none; b=Bj2yYrk4es4NeZ6BwLed/dFQFv03H/j6VvvLxjL5ixWH8tDSqNEVlOxmM3aT0tx2txBa3HK9LH90TUaZ5jn/r1PO2Z6SjsHoOTn6g6BdXrlPnGm3iLBiGMIYYD++tKL6vr11y1EIDBVlEOg1KKGB5ll9xwOGMYTilnGrWqkPQs0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1711668909; c=relaxed/simple;
	bh=zMV6299kW5W5BslYzGX1FoPZfGMJUyscqS/rq0NYjuQ=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=iAgo0n/R9Ko4NlQ7HG/TWSgfr4YZM0G4UHITeuRSqZ3x3Y26cvO/mOKbmE11wbf4Bja8NUV5vf48KIp9rFlA/EdgdUa7OotTM6adi7E/Zvw1o8wfqmCflJHzk0z+nV4c/MHYJelvakklEMBM0kchlhqrJ5ZJAhuouJ0nWdrjSpo=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=kernel.dk; spf=pass smtp.mailfrom=kernel.dk; dkim=pass (2048-bit key) header.d=kernel-dk.20230601.gappssmtp.com header.i=@kernel-dk.20230601.gappssmtp.com header.b=oljRFRg6; arc=none smtp.client-ip=209.85.210.181
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=kernel.dk
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=kernel.dk
Received: by mail-pf1-f181.google.com with SMTP id d2e1a72fcca58-6ea895eaaadso292263b3a.1
        for <io-uring@vger.kernel.org>; Thu, 28 Mar 2024 16:35:07 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernel-dk.20230601.gappssmtp.com; s=20230601; t=1711668907; x=1712273707; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=NkC1wgxtZXdI83W5YRayAah5RZJ0rineL5BY43A7LG0=;
        b=oljRFRg6jCXuCQ/cODwP3i6CYX5rfA3eA0TR6+RXoz0/XI8C2OM7RscFBa908gPK/3
         qLY7NyIFPsZkPvZaDyF6y7TmONbKYqen78RNFytyV+QZ8chvyHGmBUit7Ec8IAWuaUX8
         El38zLtVqg4C0WJ5kaSjpVA8DVcpq+ul5JTsW+UlltbkiwbmzYoJlXPHx8ygexPADajP
         elq8xpVBN5jjgNXjkqAhw+vHY9tbS7pCF2bAirEvWul7EtFHakHXW8JaJtKTR2Q+IJRl
         UB8wCtxKe7+AUv829ZFN5y+kGC+FBpYWV0QTEkWVC6KU8Qchr24NnD4TcIjfMXw7L/Oa
         7N/w==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1711668907; x=1712273707;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=NkC1wgxtZXdI83W5YRayAah5RZJ0rineL5BY43A7LG0=;
        b=Ft2ds+CEGJnoAbyIIzskyNORr+OqkQr3HVd7BMy3FAylMYuu42dZu/jNI8zhZGpRzK
         uWB7p4fnSvytFtCbGYejtioUr/VIVYDQMSv3MctY3YCWhc8fSbvC2GJSCREWrL+Z6Udp
         UB5Icb5PCcQZnsIkJTaAOcFkS5jhylUdtcrUoHKQjeCfteOKk4SVOZvCXb5fI9mStugA
         UTOIm4Ppco2gV+VnT43TZb49l9V0cr9hhBjAY9MY0DgfoMEvFlUaHkPcP2WV+N51IoO2
         UgGS8Jupk0H+sdzSXEHWTisC4FknOsLNtHg9ecTQg5qgoXq7RAmtlgUKaM8kiAmdRgDl
         8uSg==
X-Gm-Message-State: AOJu0YwXcAXmFtZGnY5irS29sn5yeVgg+FsWzd39HA6sA34Z08HmRbD6
	0Qh07n37TCM/sKLPy6Y/VhEwRg0RnZvTnMrs16h3h8sLHjViNd71LJezD48b9hrVjIyHbb/AMlL
	4
X-Google-Smtp-Source: AGHT+IHV7qFGvLhFDkfJInmeimD1Xk7KxxufcP/2kLUppZVO+LZtyHJaJ5TzDRwZ3bKaijCKPTJSQA==
X-Received: by 2002:a05:6a21:a593:b0:1a3:c61f:c2d5 with SMTP id gd19-20020a056a21a59300b001a3c61fc2d5mr594044pzc.6.1711668906764;
        Thu, 28 Mar 2024 16:35:06 -0700 (PDT)
Received: from localhost.localdomain ([50.234.116.5])
        by smtp.gmail.com with ESMTPSA id i6-20020a170902c94600b001e0b3c9fe60sm2216981pla.46.2024.03.28.16.35.04
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 28 Mar 2024 16:35:05 -0700 (PDT)
From: Jens Axboe <axboe@kernel.dk>
To: io-uring@vger.kernel.org
Cc: hannes@cmpxchg.org,
	Jens Axboe <axboe@kernel.dk>
Subject: [PATCH 10/11] io_uring: use unpin_user_pages() where appropriate
Date: Thu, 28 Mar 2024 17:31:37 -0600
Message-ID: <20240328233443.797828-11-axboe@kernel.dk>
X-Mailer: git-send-email 2.43.0
In-Reply-To: <20240328233443.797828-1-axboe@kernel.dk>
References: <20240328233443.797828-1-axboe@kernel.dk>
Precedence: bulk
X-Mailing-List: io-uring@vger.kernel.org
List-Id: <io-uring.vger.kernel.org>
List-Subscribe: <mailto:io-uring+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:io-uring+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

There are a few cases of open-rolled loops around unpin_user_page(), use
the generic helper instead.

Signed-off-by: Jens Axboe <axboe@kernel.dk>
---
 io_uring/io_uring.c | 4 +---
 io_uring/kbuf.c     | 5 ++---
 2 files changed, 3 insertions(+), 6 deletions(-)

diff --git a/io_uring/io_uring.c b/io_uring/io_uring.c
index 83f63630365a..00b98e80f8ca 100644
--- a/io_uring/io_uring.c
+++ b/io_uring/io_uring.c
@@ -2621,13 +2621,11 @@ void io_pages_unmap(void *ptr, struct page ***pages, unsigned short *npages,
 static void io_pages_free(struct page ***pages, int npages)
 {
 	struct page **page_array = *pages;
-	int i;
 
 	if (!page_array)
 		return;
 
-	for (i = 0; i < npages; i++)
-		unpin_user_page(page_array[i]);
+	unpin_user_pages(page_array, npages);
 	kvfree(page_array);
 	*pages = NULL;
 }
diff --git a/io_uring/kbuf.c b/io_uring/kbuf.c
index 99b349930a1a..3ba576ccb1d9 100644
--- a/io_uring/kbuf.c
+++ b/io_uring/kbuf.c
@@ -457,8 +457,8 @@ static int io_pin_pbuf_ring(struct io_uring_buf_reg *reg,
 			    struct io_buffer_list *bl)
 {
 	struct io_uring_buf_ring *br = NULL;
-	int nr_pages, ret, i;
 	struct page **pages;
+	int nr_pages, ret;
 
 	pages = io_pin_pages(reg->ring_addr,
 			     flex_array_size(br, bufs, reg->ring_entries),
@@ -494,8 +494,7 @@ static int io_pin_pbuf_ring(struct io_uring_buf_reg *reg,
 	bl->is_mmap = 0;
 	return 0;
 error_unpin:
-	for (i = 0; i < nr_pages; i++)
-		unpin_user_page(pages[i]);
+	unpin_user_pages(pages, nr_pages);
 	kvfree(pages);
 	vunmap(br);
 	return ret;
-- 
2.43.0


