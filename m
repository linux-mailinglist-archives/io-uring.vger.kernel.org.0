Return-Path: <io-uring+bounces-8577-lists+io-uring=lfdr.de@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [139.178.88.99])
	by mail.lfdr.de (Postfix) with ESMTPS id AB817AF5B1E
	for <lists+io-uring@lfdr.de>; Wed,  2 Jul 2025 16:27:59 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 45F0D3AA037
	for <lists+io-uring@lfdr.de>; Wed,  2 Jul 2025 14:27:31 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 8A2072F531B;
	Wed,  2 Jul 2025 14:27:51 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="IW3d1ZLP"
X-Original-To: io-uring@vger.kernel.org
Received: from mail-pf1-f173.google.com (mail-pf1-f173.google.com [209.85.210.173])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 05C3E28983B
	for <io-uring@vger.kernel.org>; Wed,  2 Jul 2025 14:27:49 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.210.173
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1751466471; cv=none; b=QyGkt2r1pi+3i7a10xNU8S2Kszz1ODY6w5soJoHZKOAjZ2u/TBLMQrvsfKqmN9RtE5lyKiFlsxgBr8Xfvyrtknig5rgWcUO1/371HdK1klhSZrACHIv0tMnm4P2oTn9issQQ4Fm7eZVWv+zlf9oa1DWl8TSVoXNV5BJxax0Bmwc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1751466471; c=relaxed/simple;
	bh=q44OxrFtZOhFQT9osumhX9S3b5HnaDQhGvmMAn5tXes=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=aWjzqjo0gbc3Kf7KnHb4dRy0+3Q19Vf414hUavViol6nKXU4wc3aJoLBTO0oiYt9hptUiUAvbFO92T8ECgZq2JKsf1RG5on6AgNt+eD9/vqr0bjQbx+dUJWP/rHnkctBFAXSVzYieQH8FW2p7owiT1bpMb+mCYjWrdbxCXj/Ya8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=IW3d1ZLP; arc=none smtp.client-ip=209.85.210.173
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Received: by mail-pf1-f173.google.com with SMTP id d2e1a72fcca58-73972a54919so4342795b3a.3
        for <io-uring@vger.kernel.org>; Wed, 02 Jul 2025 07:27:49 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1751466469; x=1752071269; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=YPx08quPNBwV5MOyLqfQgZOUKmsPp21mhER8U/xkdjM=;
        b=IW3d1ZLPWFR94KSiIaAxDnwGh/RgkgaZSNcTlRqHyNcIXkoqWhTnmkziAi0t/MQzw7
         1IpU0ONFJwGJ/EozX4Z2POGA+Mz7+pG3XmivK5TLplnzrAXThNqABbMbXaGu8Z2ppd2L
         SJTKkjzTvNA9kiSJL0rdRMqMoaricFitXrM4bq4zUwtE4jhaKcq/F+qUekj3dpHHXO6o
         OubhYIPkjJ+2h/FBI33hDdQFH7ZTinLkdWAsM7sBnh+tyxiBwYN5jYgd5/5PLXe3OfEU
         BSAbrrn4M0LE/tlq/13SV16DJd741XCfEJIccOJ0mK7JR2FcModllZHoRT+1KQliVJDm
         udWA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1751466469; x=1752071269;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=YPx08quPNBwV5MOyLqfQgZOUKmsPp21mhER8U/xkdjM=;
        b=EUeQrGwC+UDxUd++dLfuk9sG/ZqdFoHyq3CkPXviHBxx9NPUSw0gG8iSWJerc7dUV6
         rTGrS00b+mqPfyTFVB/1zfS8hZFg7cvJhdC1HA8FSU8HkWq9VtF5XxaMbygV8SoLytCQ
         xRMNTkPAIjNt+ebXrR9YLBVF4qb6uQxXi7Tr/6rLC1W8GAgOFS/jLpOsbxtAqEpD+mOA
         bWMrVsqdSJcak2eZAba0uTnvFe1y77Gse5qTFT/Rj1Qzmir7c3yb/sEqrhCyiENqT6tl
         5JjohrDowbqGwdj54BXExwjcH+r4ZqFLSsiZrrYHW3ULrpcpu1YvaWqu1RVGhD6ufhQH
         OV1g==
X-Gm-Message-State: AOJu0Yz0sV/qXGC1L+2SosgPDuRRek1N26qKO8m/JZJdtqWrtiUO7c78
	m82T+Qx6CNDk9Xb+IJ5QcMzc4gtVcbl90Eku80173f/ZhdXmGD3UtPQTmSG/yZxm
X-Gm-Gg: ASbGncvc/isu16I+nqayJe63NXdDSkrKBcrM4JboycwdbsyVs2eVheV8qaBiGorCV6u
	Y0jpLsyJIFdV611GeRJaAgpRI1pLDp0F9Du0O5ld+1nrtyv374NkvEKrkrb7PP8lUz8ZrlTKYTS
	xAMuXYtlvv15/+5GD4uq6nPLriipUDbuU3x+TrcJ/De9JKs6T34Q9NH8f9xdg3LquRPmWi4lnqa
	42s0Fa9KyUKjfvI2zJMtBvCrdeM0r6j/Hy9Lf0yK1i80BJq1IC2ssmJkEvhIQOET0whYsCjIH0y
	65uvJ8cg3ljTh8z4oECFCR1uziMtubsP2CRVCxqNlxL3SuN3tWOeBZOmkcgT0+bP1KRSbw==
X-Google-Smtp-Source: AGHT+IHEIfSNCtm6GdjYJM+EQYbbDKJZAuEWvrKudpg/eoq7dFoGCusoAaeRTPnViVibkVOFd4c0XA==
X-Received: by 2002:a05:6a00:23c3:b0:742:a91d:b2f6 with SMTP id d2e1a72fcca58-74b50f2a035mr4546918b3a.13.1751466468800;
        Wed, 02 Jul 2025 07:27:48 -0700 (PDT)
Received: from 127.com ([50.230.198.98])
        by smtp.gmail.com with ESMTPSA id d2e1a72fcca58-74af5409a41sm13765094b3a.29.2025.07.02.07.27.48
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 02 Jul 2025 07:27:48 -0700 (PDT)
From: Pavel Begunkov <asml.silence@gmail.com>
To: io-uring@vger.kernel.org
Cc: asml.silence@gmail.com
Subject: [PATCH v4 3/6] io_uring/zcrx: introduce io_populate_area_dma
Date: Wed,  2 Jul 2025 15:29:06 +0100
Message-ID: <a8972a77be9b5675abc585d6e2e6e30f9c7dbd85.1751466461.git.asml.silence@gmail.com>
X-Mailer: git-send-email 2.49.0
In-Reply-To: <cover.1751466461.git.asml.silence@gmail.com>
References: <cover.1751466461.git.asml.silence@gmail.com>
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


