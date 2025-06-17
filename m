Return-Path: <io-uring+bounces-8393-lists+io-uring=lfdr.de@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [147.75.199.223])
	by mail.lfdr.de (Postfix) with ESMTPS id 365DFADD06B
	for <lists+io-uring@lfdr.de>; Tue, 17 Jun 2025 16:50:03 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id 889FA1631F4
	for <lists+io-uring@lfdr.de>; Tue, 17 Jun 2025 14:47:54 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 738182DE1FE;
	Tue, 17 Jun 2025 14:47:26 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="CT8I9Va9"
X-Original-To: io-uring@vger.kernel.org
Received: from mail-ed1-f50.google.com (mail-ed1-f50.google.com [209.85.208.50])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8ADDD18DB35
	for <io-uring@vger.kernel.org>; Tue, 17 Jun 2025 14:47:24 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.208.50
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1750171646; cv=none; b=O4yafNMwYNlV3flNDH3rexFM7y4DVVJaZlunnIiOr0PKO0cmzy+LwlawKDZiYhDIW5VQSpQjuMyTQPuC9KPbQeA1EHJA+6UZF2vAyOMDq2x7XPOnyN4f8I1UaSN/73/bIUPrmWXJ/nUyFpgxxkKm8s37NezYGYXw17kF34bDZ0k=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1750171646; c=relaxed/simple;
	bh=FJDFvTmM3C7pSboLU5Dt/Rz2aTBj2GJ8jafNQsX8cSQ=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=emgjEw2o8s8/D9fcIGrZF9hJXz35k+RMkdNO/RTP/oGoXj8wyB4aP88rwHdW+hnwl7yH40ZvzE6YJS0QC1nwWLxQxPmiQd6Da6ndQQtE9t1AWe9x7MBt6c0nSN4UFrQoYqxZXyOB2ju305pd7QtvywJ/ncUc4wkEaSzXn355YzY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=CT8I9Va9; arc=none smtp.client-ip=209.85.208.50
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Received: by mail-ed1-f50.google.com with SMTP id 4fb4d7f45d1cf-607ea238c37so12295959a12.2
        for <io-uring@vger.kernel.org>; Tue, 17 Jun 2025 07:47:24 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1750171642; x=1750776442; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=n7CHf+4Y+97qMEen+cZb6fPSANgZGTYqmjXcr7CFEZE=;
        b=CT8I9Va9Mye5Dzx66yg1fPB0zyAMsZEEx1lIEW6CaWag22KkoTGNAf/D4rNdulj8f0
         UcTDW/IISNpxsN3wh+kGT8Tq2rGxxgWtDW9iaTLv/W0IQuvQfc50mOl8k5gcvzSSclbS
         7SuY+0PZXZTKF/q5UPKim4fBEi6ViAGmSSHIlq08s4joMq6R4AM7ZmHcYNwXMbxtErFC
         UCiBtvThd0svjmunKJZzEOR5+vIkcCvBHS6rO2rRoWHniCVLPjlhJRfxan7x6id+tn+m
         XVmIj0sS3aaCr3MbFwsufzw99rv5dinxg+c7yp/wKx821SxT/DcUSBupaZiqelgMW6XF
         CFoQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1750171642; x=1750776442;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=n7CHf+4Y+97qMEen+cZb6fPSANgZGTYqmjXcr7CFEZE=;
        b=AB6YwreFLLjNREHZNml3Pv07GXgZMCKRmQscYg/p7K9wILkR2MPaVv19HGgxWB64sL
         1nPP1+f8H/YnuAUZ9+LVYtOx9FFrheIffV8jvWOVwcnCiF3fhfrlOTozrhcYMFh96KVx
         MgVISGU42OZCTgtPfWSwiGKeJ4HjchNYRoZJoPIIlZY8YjfSRiN5NP9laWLxmlkCCJNI
         DhUavvNBK/92GZpTyeCO4tPhFHxSH30y6HxWeuzIcrSiaUwZ5WO90UL9nuDnwCNDkAaa
         JWwAGr8gknQDqoBaeQ1eA3ToiBRYk/xBlvdtYO05BoHKnCF/j6WFA0DokABCt7SSncAZ
         cTvw==
X-Gm-Message-State: AOJu0Yzmt0L87gNnap+fDBrj4ch1qglYNja/z9Uq+fXAl0X2Mzwk2Qws
	i4q3F6dholdxJzxodn9xPevOp9bgd+np/DENTIe8eRjaPOzR5XwSB8XRpnB+Bw==
X-Gm-Gg: ASbGnctGkTWw79LTyq/ZdVyYkrUhSZQ64hwoS263v4kZwN20poU20+T4XdAW6MMqO38
	C3Vw/A1OukuzTc/3x5VQ2aYwBCcP7dFp3jU7ZATkFz4YILbNT19a6ZV16512wz4aoyChndSGKMp
	oPJwqOno9usLfvxBRh/ByxpcIsqhiQSaZ1FVSJJal+e3gtk2EX6UHgXTe+MZdcJJaNfJnPV/TnM
	kB3tqhWj5jrVycUNF3wfq/+HqNLenxeac2I7E1dSn0k9tUmsUYRS/oqbEwl3u8FEZ+fXDH5gdIl
	+dWwjHuFIOS41qCqDbk+nJBC9JCfBifd0aAEzIgeZqwyWQ==
X-Google-Smtp-Source: AGHT+IFzscD19rd9QC+ArqaRPC+Ipbi7LBiXb7sttdgfUVIx5gAQaOvzwMVG+N/R1BZ49iUSBXi+IA==
X-Received: by 2002:a05:6402:2812:b0:607:f082:5fbf with SMTP id 4fb4d7f45d1cf-608d0861c42mr12157966a12.12.1750171642212;
        Tue, 17 Jun 2025 07:47:22 -0700 (PDT)
Received: from 127.com ([2620:10d:c092:600::1:b491])
        by smtp.gmail.com with ESMTPSA id 4fb4d7f45d1cf-608b4a9288csm7951040a12.57.2025.06.17.07.47.21
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 17 Jun 2025 07:47:21 -0700 (PDT)
From: Pavel Begunkov <asml.silence@gmail.com>
To: io-uring@vger.kernel.org
Cc: asml.silence@gmail.com,
	David Wei <dw@davidwei.uk>
Subject: [PATCH 2/8] io_uring/zcrx: introduce io_populate_area_dma
Date: Tue, 17 Jun 2025 15:48:20 +0100
Message-ID: <ca658cc6db27b51c6ac6804a0d30780771a181b3.1750171297.git.asml.silence@gmail.com>
X-Mailer: git-send-email 2.49.0
In-Reply-To: <cover.1750171297.git.asml.silence@gmail.com>
References: <cover.1750171297.git.asml.silence@gmail.com>
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
index 7d361b661ccb..2b82fda6d934 100644
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


