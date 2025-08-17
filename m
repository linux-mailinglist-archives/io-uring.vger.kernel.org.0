Return-Path: <io-uring+bounces-9007-lists+io-uring=lfdr.de@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [139.178.88.99])
	by mail.lfdr.de (Postfix) with ESMTPS id 8C697B29592
	for <lists+io-uring@lfdr.de>; Mon, 18 Aug 2025 00:43:38 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 18CF94E2032
	for <lists+io-uring@lfdr.de>; Sun, 17 Aug 2025 22:43:27 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 9919621147B;
	Sun, 17 Aug 2025 22:43:26 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="RzjIpfFt"
X-Original-To: io-uring@vger.kernel.org
Received: from mail-wr1-f53.google.com (mail-wr1-f53.google.com [209.85.221.53])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id EC59022A7F2
	for <io-uring@vger.kernel.org>; Sun, 17 Aug 2025 22:43:24 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.221.53
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1755470606; cv=none; b=cO/hBsfRKjJK2ohmNcGa5yVbg7+Iah7zJtO+W/zEUgDy3DdFOvbpF+bCkBGs16oXgHiuF+/Go3hhg+UHK0vMQ/M20rwQzocQUWqkCJovQHn6wTUD7HIma0juXlfAcJQiqrFlIXGNazbkwo/qu68aZhW8Xz3g3c4jnnsRu/dJcYI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1755470606; c=relaxed/simple;
	bh=TR65QDD5wKpgHGZnvz/hieHG5Gm0R2G4nHpaHItUCUg=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=FwULPPWG3IJgecDHbQNbHMrRi4Mt7C51ihTOBu44XkzI17ufTJW6mZoHIhQmygjzqqhj4Z2en+BUQKbEU1tiOyIDrVcVJuuBSG69cIeGdz5fhTMqN72TYtvd669oPD5RgDxhFd4Roiok5VcOMMLVtiragQjSdQczLXsgZ5l0oFo=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=RzjIpfFt; arc=none smtp.client-ip=209.85.221.53
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Received: by mail-wr1-f53.google.com with SMTP id ffacd0b85a97d-3bb2fb3a436so1860443f8f.1
        for <io-uring@vger.kernel.org>; Sun, 17 Aug 2025 15:43:24 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1755470603; x=1756075403; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=PuaREnrMvMf/T0Qu+7O01JFaSN3nsJ4NYcbOxEHtBL8=;
        b=RzjIpfFtyC0/QNXwfTdtwG1VGv0kIyCYlvEJU7xhoIMBO9xZkRHtWfXi9ySBQ2c/od
         gXHDrEp4U4FpRP8iq3VM/7Th/1trwt5RKun4WItinDgVCWlwMYwpAl3zhPzZBjjQX/Zt
         HsRDtnGvtzuWW61xDCmgWIqqoDIzKFNnq+c80x0Ft3frGMnX9ulK5aPS+KNNSZNcQImB
         qZbLiuiE+Q2V+/GQnJd33xpaQ9HNnSAHaaWu2oeK4aXzB9ZbRiB2uUcTmCP2bal7vxO6
         yqLbIMnKtIntLO+aapJiPR7x02KocM+bS9uqluuFnlyY7hGllXWbqEYY3nvfNwxcFIkf
         eSfg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1755470603; x=1756075403;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=PuaREnrMvMf/T0Qu+7O01JFaSN3nsJ4NYcbOxEHtBL8=;
        b=bb/jvRJN/96FSl01p194y5R4iwp4G7ypdaW+RZc9M+Bw7yrDd01Pji3u0P4EXkPVmA
         Sz+gh9QiBBjP34OYX/KMxq3EwVyMf9B5J256Ke7x+8boVz+0IxMIUA8C/s+iBEqfiy8I
         wbOEPzR7ISYpR6tod2EhFMWCQx454EqLNHNMjnrvQqk5Z4ljI8tShOVDqwdfTcpyzNge
         XMqYvN5r/AQs0xX9tbl9tswqCUXsqagYkzCQ7YvNAIhZ4P0vy1t/SSDggSdGh9fLmvfq
         xaCMqcvJQOlv49f/NqH6vt+qiS3dVIFy0D2PtegLb0JxlC5zEyhje+47FrBb4lb35FCs
         VDNg==
X-Gm-Message-State: AOJu0YxGe4f/oQ/CR5hNUAgh9TyfBV0wEh9fvqHiJaZld/AXqoFWdt1/
	hXn+Aq0WY025ql6QgvyAhJhLvk2Zb/71vuWnm/YgjcQQnNyARbpnwSIwVg/BYw==
X-Gm-Gg: ASbGnctlBOOcifSLV5WiaoQLw4WoH2mTkUPwiUk+qw413RUQdhSxgrIpDQlrcUrGJl0
	WpVzUQm8wANbUQTa2O8KLhChnGKUaSWF5hpvMCOfs5+xnAtMg04kJ47V/66TNbSzv3wNPnS29kp
	cBZppnDK6Q8hdALs9j11rNUzcHQzucBFhRechREIRsKgqxA903BFl3fxrf0HOA+xDWCFmPgoyGe
	LBNPGxo+ZaBPq3t1iakp+oYngvWKlm/EVQwu6zH/JS9ImAG+SvukGjd/2Mwkb0xhL9if+9IcgeT
	JHMcSH9C3ieyXIincX2s6qL8NccBLYGp2E6PUT6WjXik+nH3pZbCyE6gv4SUWoqWf8P5RQbWgMz
	T41xjAVxpNOrzdmy6bOVZHCD6NxAVqe/F1g==
X-Google-Smtp-Source: AGHT+IHPREQXiVACZspsvJ3OWhsQ+jDl8DK1BWhvK5g2uU7/q8HcERW3Um4SetE9G6WHZejZuobMNA==
X-Received: by 2002:a05:6000:2387:b0:3b8:d901:fa33 with SMTP id ffacd0b85a97d-3bc6a18bd77mr5077546f8f.42.1755470602892;
        Sun, 17 Aug 2025 15:43:22 -0700 (PDT)
Received: from 127.0.0.1localhost ([185.69.144.43])
        by smtp.gmail.com with ESMTPSA id ffacd0b85a97d-3bb676c9a7fsm10554786f8f.37.2025.08.17.15.43.20
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sun, 17 Aug 2025 15:43:21 -0700 (PDT)
From: Pavel Begunkov <asml.silence@gmail.com>
To: io-uring@vger.kernel.org
Cc: asml.silence@gmail.com
Subject: [zcrx-next 6/8] io_uring/zcrx: remove dmabuf_offset
Date: Sun, 17 Aug 2025 23:44:17 +0100
Message-ID: <29793317bf5dec6010d19a4c77d9041367b8e743.1755467608.git.asml.silence@gmail.com>
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

It was removed from uapi, so now it's always 0 and can be removed
together with offset handling in io_populate_area_dma().

Signed-off-by: Pavel Begunkov <asml.silence@gmail.com>
---
 io_uring/zcrx.c | 13 ++-----------
 io_uring/zcrx.h |  1 -
 2 files changed, 2 insertions(+), 12 deletions(-)

diff --git a/io_uring/zcrx.c b/io_uring/zcrx.c
index 2bd6e0bcc645..87ba34c5a22f 100644
--- a/io_uring/zcrx.c
+++ b/io_uring/zcrx.c
@@ -53,7 +53,7 @@ static inline struct page *io_zcrx_iov_page(const struct net_iov *niov)
 
 static int io_populate_area_dma(struct io_zcrx_ifq *ifq,
 				struct io_zcrx_area *area,
-				struct sg_table *sgt, unsigned long off)
+				struct sg_table *sgt)
 {
 	struct scatterlist *sg;
 	unsigned i, niov_idx = 0;
@@ -61,11 +61,6 @@ static int io_populate_area_dma(struct io_zcrx_ifq *ifq,
 	for_each_sgtable_dma_sg(sgt, sg, i) {
 		dma_addr_t dma = sg_dma_address(sg);
 		unsigned long sg_len = sg_dma_len(sg);
-		unsigned long sg_off = min(sg_len, off);
-
-		off -= sg_off;
-		sg_len -= sg_off;
-		dma += sg_off;
 
 		while (sg_len && niov_idx < area->nia.num_niovs) {
 			struct net_iov *niov = &area->nia.niovs[niov_idx];
@@ -149,7 +144,6 @@ static int io_import_dmabuf(struct io_zcrx_ifq *ifq,
 		goto err;
 	}
 
-	mem->dmabuf_offset = off;
 	mem->size = len;
 	return 0;
 err:
@@ -269,7 +263,6 @@ static void io_zcrx_unmap_area(struct io_zcrx_ifq *ifq,
 
 static int io_zcrx_map_area(struct io_zcrx_ifq *ifq, struct io_zcrx_area *area)
 {
-	unsigned long offset;
 	struct sg_table *sgt;
 	int ret;
 
@@ -283,13 +276,11 @@ static int io_zcrx_map_area(struct io_zcrx_ifq *ifq, struct io_zcrx_area *area)
 		if (ret < 0)
 			return ret;
 		sgt = &area->mem.page_sg_table;
-		offset = 0;
 	} else {
 		sgt = area->mem.sgt;
-		offset = area->mem.dmabuf_offset;
 	}
 
-	ret = io_populate_area_dma(ifq, area, sgt, offset);
+	ret = io_populate_area_dma(ifq, area, sgt);
 	if (ret == 0)
 		area->is_mapped = true;
 	return ret;
diff --git a/io_uring/zcrx.h b/io_uring/zcrx.h
index f6a9ecf3e08a..4e94cfa720e6 100644
--- a/io_uring/zcrx.h
+++ b/io_uring/zcrx.h
@@ -20,7 +20,6 @@ struct io_zcrx_mem {
 	struct dma_buf_attachment	*attach;
 	struct dma_buf			*dmabuf;
 	struct sg_table			*sgt;
-	unsigned long			dmabuf_offset;
 };
 
 struct io_zcrx_area {
-- 
2.49.0


