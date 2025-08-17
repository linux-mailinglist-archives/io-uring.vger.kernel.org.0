Return-Path: <io-uring+bounces-9006-lists+io-uring=lfdr.de@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [147.75.80.249])
	by mail.lfdr.de (Postfix) with ESMTPS id 6677FB2958E
	for <lists+io-uring@lfdr.de>; Mon, 18 Aug 2025 00:43:26 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id F24C21899FEA
	for <lists+io-uring@lfdr.de>; Sun, 17 Aug 2025 22:43:45 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id BE8892253E0;
	Sun, 17 Aug 2025 22:43:24 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="LpUTJrIU"
X-Original-To: io-uring@vger.kernel.org
Received: from mail-wr1-f46.google.com (mail-wr1-f46.google.com [209.85.221.46])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0A3FC21D3E4
	for <io-uring@vger.kernel.org>; Sun, 17 Aug 2025 22:43:22 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.221.46
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1755470604; cv=none; b=jx1WDuLupMYdoLQzSKuy07jrcl6fzBil+KGtfIg73lzw4svQ6IdIPfaJPthNYkNdK8f93LfEJAnJO9cSgVLdSlewZrk3auMOEjKy3xzA4TeV8u6tYCyQVmSBmHxU31FL1Ez4kUM//1zJeLEU06j5leAKxVFqj7eTrf+wpUf8DOg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1755470604; c=relaxed/simple;
	bh=a3u+/Tt5zSzImlAh2Nr5i1EDJlSjtDnCaRc8J9Un4X4=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=hYvKDuyRYoOXRQm7hAeOPPp2fifD0vzXFp2Me2kTrxV0r887TK6v4TpXWMFFUInrfc0nCWC8G5++XM/WkMKfV1up/ykAnEU7NRRXOA2Jbj1TKvBtxNSJCAzrYZAL8iRkWXzwmIEmvDNpXde3zJaNhKgZDWmHCcTiB1USwnTgHGM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=LpUTJrIU; arc=none smtp.client-ip=209.85.221.46
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Received: by mail-wr1-f46.google.com with SMTP id ffacd0b85a97d-3b9a342e8ffso2568901f8f.0
        for <io-uring@vger.kernel.org>; Sun, 17 Aug 2025 15:43:22 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1755470601; x=1756075401; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=iiRz7o6Nkwelkd/ek87DTbtP7QO/s9kYss9uibO1X58=;
        b=LpUTJrIU/YQ7DRCib8cJF6vgDANhYtMzr2w/m11MRuQmdJQ0W1i776K5JBQgiUv/IK
         aMmN3pUy5hu+xzDJAcQF3VaM6DFu+CC8JpdwvbB5BrGSRy2apYuTwo32xc2divsvloM8
         gnME4B1GATyfEWeNY7Ss/bE11TF/CkS0CqH/mTW2JYLsKnKQEImfDDswLTE7K0L+87M1
         yOzi6/vJviizYbvnZwPBYDypYfTs22s+si3pUCt1ANGbUgmEdYs4MkNS7+38DMiYKAGX
         9y2siAFQw2IHDc/cx6QUoUgHs+ASfOIZLQAXYue2qJSP59lQAaYvbPXXbIdxxQCD45GG
         5y1Q==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1755470601; x=1756075401;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=iiRz7o6Nkwelkd/ek87DTbtP7QO/s9kYss9uibO1X58=;
        b=Iq4qWqoyHtr7oL87oAsDrAWVVbRNi2HPO41+T91abK+SaHyFI2+5Rh2WYNgmozCiJD
         4XoOqGYd5aWnV/q7Qk7U31upxlmvmRgqNRSihCKa8kBd5H45n0jkB4p5+u87AEQz7Zj1
         Kq1hgI83zmmPo4QwqQEc2gzZ+aACye7T+Iox/z04OxmVFfQBO85ZAu4Cwp41JX1rSFsO
         /qrRSfS4UFDOKtHizmE1qDIbDZQNCtNNWe1l+hTxUE7+nqGcOkVb560BCxHPYn/g2Y8W
         MOamd7ss5SqAlhEPNvgUWsfiOPTzq4VJxq7ujmxGE4ECR9qOsxCLDha99ynzxpdJvvt0
         hsiA==
X-Gm-Message-State: AOJu0YziqouLsD/37sjWBAazVFVrC6sD0ipN8yG/jelNLSXFdG4U/0o1
	GVV9FEa399cj+iESrUzsW8iw45LfgLpBAXMx9+biBEVtBis662FTXJNLrLKiHg==
X-Gm-Gg: ASbGncvQwwcT/+yD/NISShpaIXsoRLkyNDYL9TsJUEWlfplLOsBFpjL9TVmUZtsxjVN
	wI8ZmQszx5+QF/H3v8naYjaI+L47AQ6Z4WNmJEEVc5GKFFv8NMoNY6sC36bwiHnPQCQ18rRVCpo
	5ExToPJkP4y8F2YviODjFh6qoAv97s+mf8EbAAa1emLFNUx9PSak6PZTBNSERHqNNixxfA4mf6y
	ihc9UCfLFu01UIpY/rjsVpIUztYGCm31GSHn/X5O+b3sIL+EG3lqXyxCrCdV5fGPfFOBvsf6TRd
	KIS9r+lkEjK1VMQH8a8aQJVMrsmat9CfieNDdDoP4AuMfpGWbtfwyMJFvCClDb3b2iXLCzUxR1P
	Wg/wn3z0k0Uy8eSs0J8lX3PMGElsbApr2nQ==
X-Google-Smtp-Source: AGHT+IFDvTU7oy6X/XtXS8ft0GjpZglnaB8hABUodwfX1zPtFAT6RPx2Ap/umezEChRNEHdsiYuN7g==
X-Received: by 2002:a05:6000:2512:b0:3b7:8646:eeb3 with SMTP id ffacd0b85a97d-3bb4c5b6e44mr7393800f8f.15.1755470600824;
        Sun, 17 Aug 2025 15:43:20 -0700 (PDT)
Received: from 127.0.0.1localhost ([185.69.144.43])
        by smtp.gmail.com with ESMTPSA id ffacd0b85a97d-3bb676c9a7fsm10554786f8f.37.2025.08.17.15.43.18
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sun, 17 Aug 2025 15:43:20 -0700 (PDT)
From: Pavel Begunkov <asml.silence@gmail.com>
To: io-uring@vger.kernel.org
Cc: asml.silence@gmail.com
Subject: [zcrx-next 5/8] io_uring/zcrx: deduplicate area mapping
Date: Sun, 17 Aug 2025 23:44:16 +0100
Message-ID: <4ce86e6d7c190c094fddb99294ac9fd1c8b10c59.1755467608.git.asml.silence@gmail.com>
X-Mailer: git-send-email 2.49.0
In-Reply-To: <cover.1755467608.git.asml.silence@gmail.com>
References: <cover.1755467608.git.asml.silence@gmail.com>
Precedence: bulk
X-Mailing-List: io-uring@vger.kernel.org
List-Id: <io-uring.vger.kernel.org>
List-Subscribe: <mailto:io-uring+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:io-uring+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

With a common type for storing dma addresses and io_populate_area_dma(),
type-specific area mapping helpers are trivial, so open code them and
deduplicate the call to io_populate_area_dma().

Signed-off-by: Pavel Begunkov <asml.silence@gmail.com>
---
 io_uring/zcrx.c | 37 ++++++++++++++-----------------------
 1 file changed, 14 insertions(+), 23 deletions(-)

diff --git a/io_uring/zcrx.c b/io_uring/zcrx.c
index cb8113e83311..2bd6e0bcc645 100644
--- a/io_uring/zcrx.c
+++ b/io_uring/zcrx.c
@@ -157,14 +157,6 @@ static int io_import_dmabuf(struct io_zcrx_ifq *ifq,
 	return ret;
 }
 
-static int io_zcrx_map_area_dmabuf(struct io_zcrx_ifq *ifq, struct io_zcrx_area *area)
-{
-	if (!IS_ENABLED(CONFIG_DMA_SHARED_BUFFER))
-		return -EINVAL;
-	return io_populate_area_dma(ifq, area, area->mem.sgt,
-				    area->mem.dmabuf_offset);
-}
-
 static unsigned long io_count_account_pages(struct page **pages, unsigned nr_pages)
 {
 	struct folio *last_folio = NULL;
@@ -275,30 +267,29 @@ static void io_zcrx_unmap_area(struct io_zcrx_ifq *ifq,
 	}
 }
 
-static unsigned io_zcrx_map_area_umem(struct io_zcrx_ifq *ifq, struct io_zcrx_area *area)
-{
-	int ret;
-
-	ret = dma_map_sgtable(ifq->dev, &area->mem.page_sg_table,
-				DMA_FROM_DEVICE, IO_DMA_ATTR);
-	if (ret < 0)
-		return ret;
-	return io_populate_area_dma(ifq, area, &area->mem.page_sg_table, 0);
-}
-
 static int io_zcrx_map_area(struct io_zcrx_ifq *ifq, struct io_zcrx_area *area)
 {
+	unsigned long offset;
+	struct sg_table *sgt;
 	int ret;
 
 	guard(mutex)(&ifq->pp_lock);
 	if (area->is_mapped)
 		return 0;
 
-	if (area->mem.is_dmabuf)
-		ret = io_zcrx_map_area_dmabuf(ifq, area);
-	else
-		ret = io_zcrx_map_area_umem(ifq, area);
+	if (!area->mem.is_dmabuf) {
+		ret = dma_map_sgtable(ifq->dev, &area->mem.page_sg_table,
+				      DMA_FROM_DEVICE, IO_DMA_ATTR);
+		if (ret < 0)
+			return ret;
+		sgt = &area->mem.page_sg_table;
+		offset = 0;
+	} else {
+		sgt = area->mem.sgt;
+		offset = area->mem.dmabuf_offset;
+	}
 
+	ret = io_populate_area_dma(ifq, area, sgt, offset);
 	if (ret == 0)
 		area->is_mapped = true;
 	return ret;
-- 
2.49.0


