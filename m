Return-Path: <io-uring+bounces-8555-lists+io-uring=lfdr.de@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [139.178.88.99])
	by mail.lfdr.de (Postfix) with ESMTPS id E0C91AEFA9B
	for <lists+io-uring@lfdr.de>; Tue,  1 Jul 2025 15:31:36 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id C1A41481AE2
	for <lists+io-uring@lfdr.de>; Tue,  1 Jul 2025 13:27:52 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id D5B45276037;
	Tue,  1 Jul 2025 13:26:21 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="cAk1Z8Tl"
X-Original-To: io-uring@vger.kernel.org
Received: from mail-pf1-f181.google.com (mail-pf1-f181.google.com [209.85.210.181])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3ED312737F3
	for <io-uring@vger.kernel.org>; Tue,  1 Jul 2025 13:26:19 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.210.181
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1751376381; cv=none; b=HkWdC0iHmbIi9oh+VDTegyiYMrfqsur19uC8gkN6N9N2hPQeWCZAV/OTPArERoRA1wthxiLxOMwGYnzmUUNshMSFDuzatjx/HC8oN+gVp/1Kr8x8Y+1sGy/Cl/V7n5lgHpBMhB2gxU4FtS/n0xPiQH3v6SvWwRwFqqACUpE8jkE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1751376381; c=relaxed/simple;
	bh=q44OxrFtZOhFQT9osumhX9S3b5HnaDQhGvmMAn5tXes=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=uk/DPTZuDrHzsbj3PILGIju5ujX4zJZQJ+AFUxgZNpjsOWvDugPiadY1rOVeyBqlHYzv7G3OnxhE4LkeK9cVpkbnQsrmRH+MWd/NQIgVLUmsE0g0/cC4Z668enm/ciIO7Q29IlYxqKegxwAOTD862lkBWRVIIhuKbtp+nB4ySRk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=cAk1Z8Tl; arc=none smtp.client-ip=209.85.210.181
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Received: by mail-pf1-f181.google.com with SMTP id d2e1a72fcca58-747fc77bb2aso3024058b3a.3
        for <io-uring@vger.kernel.org>; Tue, 01 Jul 2025 06:26:19 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1751376378; x=1751981178; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=YPx08quPNBwV5MOyLqfQgZOUKmsPp21mhER8U/xkdjM=;
        b=cAk1Z8TlJC9Ge5VxVJXKEZr68JeryGV6yTI1WSaz31qAd0OBGpzTYJVooNYXLvEY3M
         xFtSS0ClDxxnhArtAWi3OBprj7B6+UonyZFo4kq0HA+EmcHTjutScxoFmGaehyWP5kqU
         mWYlWnLcXTVlOQyI9Bth+6S/lN70MpjOyApCxA4as1rBnH1y9+mTJTK07fXUR0o8Ndlu
         /asV50O8aYi2LkGi706BQdkhsHMXU9Gjp94ap5YjWn1uOiq/hnV4udrQwkY8nZROS9wG
         3SJOvqy43j0Y3C4dVGajuQtHrNgs+kLLSWu/9usHCGWTIO+UcLtKie3+mA9StRv7Dyor
         5Ozw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1751376378; x=1751981178;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=YPx08quPNBwV5MOyLqfQgZOUKmsPp21mhER8U/xkdjM=;
        b=LkGIMj1gfcTa/6HiyXB90iYlw7muxC69F02eJkY5xhAUcbmSsOLI2eXCcjSvB+G4Up
         I/CPjgrETsliVeMUEZ6+3kmxF2pqU3x13XTgY+o6UTpVMuzacxCjYwoVIwsi6FTXbmkT
         mON9eiOBrlp/01Y40YrflTRSljscYGXS3hYZAlU1VZotJKawpaLIby7bga6dwVNcBcCj
         gghEKut+8DZdqmRrlRk6oNZbPr+BSvTjU+G7ow6iIlACoer786h3ysoIk+9jocNQxZBw
         2vuZkuyzIxJG3Zqy9sSQz8VZ5WQ6UnRvxNgWRBFoCpUkocyq/HmcQ2AA2Y8fDctBmGNv
         ld0g==
X-Gm-Message-State: AOJu0YwGYi6pQf5F1rSwBRHPKftN1bMKeqj9S4IF88vh+JLb4Dcu66b7
	5XPLrl1b5l5KmhHEeMRBad8KTUA0JTJ7LL+9UbJE+IrfYGTnZe/KA1M/u85a/cQT
X-Gm-Gg: ASbGncvscrL4gKyJBMhkm5kpaTpfxjqu/dLpin8wzN9bvaQCCglTpkVhVnD2VwmiAxI
	HKY/Z4QY5Q9a57K86w/7wsLa5NC8HecYbPrr0dL9x5jwk6SZPqjNRom02yQ144h1rJgH68UpynW
	WgxVjpL10KD8G2BqWXkFbR8w6JQrEaRyzaKCjRs/ahmD6GH2z3+PcGANZwI55yxfJr+8vVjbTZ5
	lqg3nZs1qHzK8wzTukbVMprJ7tbxXHDzqVQrqWSOawcPBEzW0lAOmyl4FHFPQvFqblMEJeklAIe
	ByxKtRh5IZWs39dmBDSbVFLVAdjwNZzNs6lwQGP/xS3AmJqUZvcfg3b54y4=
X-Google-Smtp-Source: AGHT+IHULRZCBx/KnJ8HjIzon71lQcArQfUsL16GedGu+V4qyaNrCYp9kl8U7+rpZ+AXLUaE1A3O/Q==
X-Received: by 2002:a05:6a00:2ea0:b0:736:51ab:7aed with SMTP id d2e1a72fcca58-74af6f4323fmr23547454b3a.16.1751376378053;
        Tue, 01 Jul 2025 06:26:18 -0700 (PDT)
Received: from 127.com ([50.230.198.98])
        by smtp.gmail.com with ESMTPSA id d2e1a72fcca58-74af557439csm11788025b3a.80.2025.07.01.06.26.17
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 01 Jul 2025 06:26:17 -0700 (PDT)
From: Pavel Begunkov <asml.silence@gmail.com>
To: io-uring@vger.kernel.org
Cc: asml.silence@gmail.com
Subject: [PATCH v2 3/6] io_uring/zcrx: introduce io_populate_area_dma
Date: Tue,  1 Jul 2025 14:27:29 +0100
Message-ID: <a8972a77be9b5675abc585d6e2e6e30f9c7dbd85.1751376214.git.asml.silence@gmail.com>
X-Mailer: git-send-email 2.49.0
In-Reply-To: <cover.1751376214.git.asml.silence@gmail.com>
References: <cover.1751376214.git.asml.silence@gmail.com>
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


