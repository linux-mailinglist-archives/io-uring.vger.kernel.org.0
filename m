Return-Path: <io-uring+bounces-8569-lists+io-uring=lfdr.de@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [IPv6:2604:1380:4601:e00::3])
	by mail.lfdr.de (Postfix) with ESMTPS id 470D9AF5A63
	for <lists+io-uring@lfdr.de>; Wed,  2 Jul 2025 16:02:20 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id 0657E1C22DA1
	for <lists+io-uring@lfdr.de>; Wed,  2 Jul 2025 14:02:35 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 6CAC4277CA6;
	Wed,  2 Jul 2025 14:02:13 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="HIMW0qaz"
X-Original-To: io-uring@vger.kernel.org
Received: from mail-pl1-f170.google.com (mail-pl1-f170.google.com [209.85.214.170])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id EB53727D782
	for <io-uring@vger.kernel.org>; Wed,  2 Jul 2025 14:02:11 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.214.170
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1751464933; cv=none; b=uY336RtT5VCargZXSXsgUgMG4qNHQrg1Gkm++tb6lfQEh2YjIEcKpfJ1+6NJxVRlRLwOLvZGXcEVW51rVh+bcRWRapjYYpBJKngjT0PV7x9PW62kUuWq8Mn1BXfS2KO/7q2fdB9x7UC3K+eSX9yy3iFBZw2Nkjd5QVc2BE6PLEY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1751464933; c=relaxed/simple;
	bh=q44OxrFtZOhFQT9osumhX9S3b5HnaDQhGvmMAn5tXes=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=b8q1PRLwDS3QQj7L+vf8MVpFVBGy8UUwlVzCiD3rMyya2ICXTdTSQcWv5k2NHida+kjaZdG3uVNNXaK218ZYmG4wU4PTiwjApkAP+zuS06G+ZIG9ox38TV4XB9LEAYkOz+VkV4VEMmYz9nUrWPUryYClgolhG7QRQvoZi+PVWLQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=HIMW0qaz; arc=none smtp.client-ip=209.85.214.170
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Received: by mail-pl1-f170.google.com with SMTP id d9443c01a7336-234f17910d8so66670815ad.3
        for <io-uring@vger.kernel.org>; Wed, 02 Jul 2025 07:02:11 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1751464931; x=1752069731; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=YPx08quPNBwV5MOyLqfQgZOUKmsPp21mhER8U/xkdjM=;
        b=HIMW0qaz7bdoIAyA0hsXWZe24nMgQCREocxZvG6gZQw7qjJ/9GcobAxwBTAdm3vwHB
         WG6CJHKveGLAE4ziR6fd/1RhUQnHMI5xz9gLq6UvPbytZmlshspTM1/Cl8Ffv1nHWGQV
         jf3lv2zw6G0iFl780T/BcyGasFZZ7Zz601z9HIBRbtU3lRwx8M3ydr4+1t8WnamAG+VO
         R3mVXftU0+4CQ5o3MVuMtdtDUKm4C07xA3zCL0/WsV0tFJQZwiwG8bUBnbfZvHR33F34
         ApdYIHvbtOHUoAMK5CJsJvESdXBcfEVpZ61uXZrmc1dL3rmDEo1KH/i4+4VGh8UoV/Sn
         3f/g==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1751464931; x=1752069731;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=YPx08quPNBwV5MOyLqfQgZOUKmsPp21mhER8U/xkdjM=;
        b=K2854BWKjJiffcu9Kt5Ygs+U/HEpzpdzETDyFfa7kz/EH8D4Os1l8ffb7IdZ6dycr8
         i3sVk+0U5UfO9yJFhOukcW19YcfrUE7DQMh2KMbQW15Vn/8s5B9XioKF8kQ4Ib2NwXv6
         UvZCnUZ65HuFMY24Cti6z+QkXuvvSFWcDtLW4syikR7eQGS3fc5TI+wFYWxRej5luAlw
         PN9GzcEa6DUuSWOvLDV+hGpI+5BuqmF2s/O+tXt+D4kd2BUqTOL5sr3uluU3620TPvIw
         AwxtszyK3DZ0z+5xrmQ2s0c8r8xQKYS6zkhtUJkCq72Kxy9rYso9LAMPleEXORH/8yVA
         /aMQ==
X-Gm-Message-State: AOJu0Ywpct8D3I038hl/tkCefIhogAnpSHwx+lhUftsQv0COeKFmLKlm
	QeosKvP/Y4pHFPAykAMN1+BsEr5TWPrL+NetIHYV4p30j6BNgb2a14+qjirteObw
X-Gm-Gg: ASbGncvhVAnO6p2c87Mwdnar3jKq7nPXghWlqALjiffMffhs6rAf22caJT/uMHo1UJM
	DlIO3O0bmVrluGgf1UDu1/qeTWRpE1rR1IcMRduaXhCoGzTzJTW2ROpf1+PAvuie3SnMEwdzA5Y
	GGR/JktAc4/yreyK+R+opBCQXaeLHsh3ze8HbFypgy6qZTueeaN/XP78Gx4rEsMNKFZFhrkZJRY
	ZcSsYZQSsjZQj37SIIcoFQEDoUdjNcH6ZN/Ay2PvqHlEHGl8CHG0nLSF9YumEyoJGOTZiQlJZww
	SXO0/z3lZ77e21FooUAoVFSV6Et6qBGwBdAmJvi+W6S1htC73qcV25SDImA=
X-Google-Smtp-Source: AGHT+IFm04MCwZPgkFTV8wkVxdOsWA+zRPfK9zpofpj+UzeS8zy7jr4ntKtobjR4LXO07QS/F1E8ig==
X-Received: by 2002:a17:903:1aab:b0:235:e1e4:ec5e with SMTP id d9443c01a7336-23c6e6335dcmr46088185ad.49.1751464929973;
        Wed, 02 Jul 2025 07:02:09 -0700 (PDT)
Received: from 127.com ([50.230.198.98])
        by smtp.gmail.com with ESMTPSA id d9443c01a7336-23acb3c6e14sm126828135ad.228.2025.07.02.07.02.09
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 02 Jul 2025 07:02:09 -0700 (PDT)
From: Pavel Begunkov <asml.silence@gmail.com>
To: io-uring@vger.kernel.org
Cc: asml.silence@gmail.com
Subject: [PATCH v3 3/6] io_uring/zcrx: introduce io_populate_area_dma
Date: Wed,  2 Jul 2025 15:03:23 +0100
Message-ID: <a8972a77be9b5675abc585d6e2e6e30f9c7dbd85.1751464343.git.asml.silence@gmail.com>
X-Mailer: git-send-email 2.49.0
In-Reply-To: <cover.1751464343.git.asml.silence@gmail.com>
References: <cover.1751464343.git.asml.silence@gmail.com>
Precedence: bulk
X-Mailing-List: io-uring@vger.kernel.org
List-Id: <io-uring.vger.kernel.org>
List-Subscribe: <mailto:io-uring+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:io-uring+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

Add a helper that initialises page-pool dma addresses from a sg table.
It'll be reused in following patches.

Signed-off-by: Pavel Begunkov <asml.silence@gmail.com>
---
 io_uring/zcrx.c | 56 +++++++++++++++++++++++++++----------------------
 1 file changed, 31 insertions(+), 25 deletions(-)

diff --git a/io_uring/zcrx.c b/io_uring/zcrx.c
index 2cde88988260..cef0763010a0 100644
--- a/io_uring/zcrx.c
+++ b/io_uring/zcrx.c
@@ -47,6 +47,35 @@ static inline struct page *io_zcrx_iov_page(const struct net_iov *niov)
 	return area->mem.pages[net_iov_idx(niov)];
 }
 
+static int io_populate_area_dma(struct io_zcrx_ifq *ifq,
+				struct io_zcrx_area *area,
+				struct sg_table *sgt, unsigned long off)
+{
+	struct scatterlist *sg;
+	unsigned i, niov_idx = 0;
+
+	for_each_sgtable_dma_sg(sgt, sg, i) {
+		dma_addr_t dma = sg_dma_address(sg);
+		unsigned long sg_len = sg_dma_len(sg);
+		unsigned long sg_off = min(sg_len, off);
+
+		off -= sg_off;
+		sg_len -= sg_off;
+		dma += sg_off;
+
+		while (sg_len && niov_idx < area->nia.num_niovs) {
+			struct net_iov *niov = &area->nia.niovs[niov_idx];
+
+			if (net_mp_niov_set_dma_addr(niov, dma))
+				return -EFAULT;
+			sg_len -= PAGE_SIZE;
+			dma += PAGE_SIZE;
+			niov_idx++;
+		}
+	}
+	return 0;
+}
+
 static void io_release_dmabuf(struct io_zcrx_mem *mem)
 {
 	if (!IS_ENABLED(CONFIG_DMA_SHARED_BUFFER))
@@ -119,33 +148,10 @@ static int io_import_dmabuf(struct io_zcrx_ifq *ifq,
 
 static int io_zcrx_map_area_dmabuf(struct io_zcrx_ifq *ifq, struct io_zcrx_area *area)
 {
-	unsigned long off = area->mem.dmabuf_offset;
-	struct scatterlist *sg;
-	unsigned i, niov_idx = 0;
-
 	if (!IS_ENABLED(CONFIG_DMA_SHARED_BUFFER))
 		return -EINVAL;
-
-	for_each_sgtable_dma_sg(area->mem.sgt, sg, i) {
-		dma_addr_t dma = sg_dma_address(sg);
-		unsigned long sg_len = sg_dma_len(sg);
-		unsigned long sg_off = min(sg_len, off);
-
-		off -= sg_off;
-		sg_len -= sg_off;
-		dma += sg_off;
-
-		while (sg_len && niov_idx < area->nia.num_niovs) {
-			struct net_iov *niov = &area->nia.niovs[niov_idx];
-
-			if (net_mp_niov_set_dma_addr(niov, dma))
-				return -EFAULT;
-			sg_len -= PAGE_SIZE;
-			dma += PAGE_SIZE;
-			niov_idx++;
-		}
-	}
-	return 0;
+	return io_populate_area_dma(ifq, area, area->mem.sgt,
+				    area->mem.dmabuf_offset);
 }
 
 static int io_import_umem(struct io_zcrx_ifq *ifq,
-- 
2.49.0


