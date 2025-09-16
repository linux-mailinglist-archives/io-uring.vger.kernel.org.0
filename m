Return-Path: <io-uring+bounces-9810-lists+io-uring=lfdr.de@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [IPv6:2604:1380:45e3:2400::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 4B620B59A3B
	for <lists+io-uring@lfdr.de>; Tue, 16 Sep 2025 16:34:00 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 6D0C2525E15
	for <lists+io-uring@lfdr.de>; Tue, 16 Sep 2025 14:27:59 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 890B334166B;
	Tue, 16 Sep 2025 14:27:03 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="iXsJz+PV"
X-Original-To: io-uring@vger.kernel.org
Received: from mail-wr1-f50.google.com (mail-wr1-f50.google.com [209.85.221.50])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id BE61D316904
	for <io-uring@vger.kernel.org>; Tue, 16 Sep 2025 14:27:01 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.221.50
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1758032823; cv=none; b=C4eOAjPDSVlil9z0AJw2dH+X8o0pA2BJQUg8Gh3YmiyxOlR3QuB0hv8tJg+2n/IvV4o5fJMR+UmvTdKMU7JvbbHx+FXxZIbsf5Lbid2lDPB6OovVkyX7MRux5AH3i8xNr9Hfkfu0I3lrNuWJr2j/nO32R9zj/JUf2xSJ256Yzbk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1758032823; c=relaxed/simple;
	bh=StXOhSyFL75NeRitAWeKs5bCicJEc+YXL0Sldl8wGFU=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=WDRuaITXba+HdRbwclRPWAb2hxLJEycwIyqqPn/gtf8Kw6FDILZLrGIX0SawRKhK1V3VDrkAmrrixRGQ9FJFfOuo0NhxBxVl9jBIa5RnNIL6Q9r+EHnjWW95wsnXxZZGXFwuKVj6IatPQ1Brd58iY6D8N1hKnIKee0FiHjbGtGo=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=iXsJz+PV; arc=none smtp.client-ip=209.85.221.50
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Received: by mail-wr1-f50.google.com with SMTP id ffacd0b85a97d-3d44d734cabso3363484f8f.3
        for <io-uring@vger.kernel.org>; Tue, 16 Sep 2025 07:27:01 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1758032820; x=1758637620; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=9wbyZuzv7Pkv9kcTX/Gpz/2kxggq153qwmXmK4qfh5Q=;
        b=iXsJz+PVW4TnIxQn3+J4Ww8t5zUzOCLBWnWSJ5L9ioB4QA+xIXmQ/uNM7VDgm+NONK
         J+ECYxVUt+lNmXGthoUbW8siLX3qKhPwBat/JAfyP4YU5COEGZzOzZ16SPnarohXNTdh
         0TQxIHi+6cvdUS9Zu0xyaS43CLkENpQYKH2CjjzU4mJ6LhLbCJ5u+9xpJRywZKCQD9E3
         nAMesQNxY2FDpIyjaXjQim2Pbj1LgmEq6KBppTZFVzOu6veBkVJeXpf29YXO4R+70u5q
         ffaZ35RraB4Jdry9izOBRGY2SfAJ7YXYCqsxXj9n9Yzzt6Zn2eSDpLLtjc+Lcg1CC1bz
         GnQA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1758032820; x=1758637620;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=9wbyZuzv7Pkv9kcTX/Gpz/2kxggq153qwmXmK4qfh5Q=;
        b=BJDaxruQDGGqx2NuuZwMg4zYDkvFyUx2XdyFJLajzucmpSZQaJsFTbb22L4S/JCBp+
         03L3ogEuFbAvn+BD2QtBmd8TyoT3v3h7t6adrJXPonPbCwQ35ubO7jN0v/hqCqJYLdvz
         NG0yxYFqpHYLXrP13ojsEkXM3mYV+/ch6wvbejMDKghrgNA3R1tv5y0KSrbCGCVsyoG+
         zW4hDiMS4csUYqSuPmkWHRIfI3Qo4BG8hBPVWZ/SnPSKsyi50lNobQ6/eh+Jr6Nrf+sc
         mL35eyAi3fTm6EXJyMu/2ZHD3OODcDuq6sH37MTEbN+WEJXZJKec5KDzWJqyeCTB52ru
         TZeA==
X-Gm-Message-State: AOJu0YzDGnU3aQpye4eR3/5vNxs++jkj1/h0/xHaZAHjElqOJ7MHO0F1
	gwfteIarSolzD+KloPoKA+0KI4tZ4wB19H19N5uZuHexGGihqbrwqjoUVbsb+w==
X-Gm-Gg: ASbGncuRAGkrJQkTEfEFRyIB7iWxLNecrdTU3sRBvQkfoKFotbUlPyYZLQgzCjP2zoT
	D4r3l9Vv9Dkwg5g252JoY2jMWaeXc2ndq1KexIWplKUNAgwGY8ODk9QtiEl9D+tjZbT7UmRzxPg
	YLy+3JDDbZJ2bANkaufbIYDQEOqu6XBGb2r4i7rZyhAfndl2HJDWRCy7v6xcIpAzLwgX9ggkbV3
	eiz4Ex5n4C1OeXKF2JFM+oegbPSjTe9uVnfkBl3QON6dtNqsY218/PClN6v9ZINVpEqSTfuGUQI
	2ZYipQABhFWnEaE+RH2NMitFtBAvtbSvDqeoTvCnMX1fvngxjZGPI3tPzJ5BamjbmXKI2srHHsl
	ccuCWhw==
X-Google-Smtp-Source: AGHT+IF11D7Z39SuGn1mAS2KcDTQWn4IURGhKXMmsIQr9LAEX/FjyeAVRFuj2datvLInyrHX0lQ4bw==
X-Received: by 2002:a05:6000:1846:b0:3e7:45c7:828e with SMTP id ffacd0b85a97d-3e7659d3b19mr16438038f8f.33.1758032819511;
        Tue, 16 Sep 2025 07:26:59 -0700 (PDT)
Received: from 127.com ([2620:10d:c092:600::1:8149])
        by smtp.gmail.com with ESMTPSA id ffacd0b85a97d-3ecdc967411sm327971f8f.46.2025.09.16.07.26.58
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 16 Sep 2025 07:26:58 -0700 (PDT)
From: Pavel Begunkov <asml.silence@gmail.com>
To: io-uring@vger.kernel.org
Cc: asml.silence@gmail.com,
	axboe@kernel.dk,
	netdev@vger.kernel.org
Subject: [PATCH io_uring for-6.18 10/20] io_uring/zcrx: remove dmabuf_offset
Date: Tue, 16 Sep 2025 15:27:53 +0100
Message-ID: <249a6bd973c8e3d8e35fcb6ac338b4928f06e394.1758030357.git.asml.silence@gmail.com>
X-Mailer: git-send-email 2.49.0
In-Reply-To: <cover.1758030357.git.asml.silence@gmail.com>
References: <cover.1758030357.git.asml.silence@gmail.com>
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
index bba92774c801..bcefb302aadf 100644
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
index 109c4ca36434..24ed473632c6 100644
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


