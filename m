Return-Path: <io-uring+bounces-7622-lists+io-uring=lfdr.de@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from sy.mirrors.kernel.org (sy.mirrors.kernel.org [147.75.48.161])
	by mail.lfdr.de (Postfix) with ESMTPS id 5A00CA96F2B
	for <lists+io-uring@lfdr.de>; Tue, 22 Apr 2025 16:43:53 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sy.mirrors.kernel.org (Postfix) with ESMTPS id D2ACC7A2C41
	for <lists+io-uring@lfdr.de>; Tue, 22 Apr 2025 14:42:41 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 3A38D28D826;
	Tue, 22 Apr 2025 14:43:37 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="HymQ5237"
X-Original-To: io-uring@vger.kernel.org
Received: from mail-ej1-f54.google.com (mail-ej1-f54.google.com [209.85.218.54])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4C9E128CF7F
	for <io-uring@vger.kernel.org>; Tue, 22 Apr 2025 14:43:34 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.218.54
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1745333017; cv=none; b=aeBq/aW3dcsEcVASJq7jS2xuA1ZB6aOd/ChZdcbVDIcQG31S43Cx95luiYhP6vCEYkNqHNGyp806HMgRWuAvNTy9VKrTveUdLglUL2y/vCEIw5ZmL6fcvqkv0b1Mw34H832zvDYKEAghEt1lhWxQCWGtoo4M+Sq9nCdcSJL2a90=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1745333017; c=relaxed/simple;
	bh=9z1gE7Cmht5hF9YP8kvgcSGMmB0x3nE/QsqA6Hh6zWM=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=bmtVu3s/q10i7Y/ZzLnbLkFRN6islSpqB957D4I38V5kz4WPPkI62clF4eKA6OwFPUFen6B5dTiZFjVrrdyTe8oFelSJWy/LwiyOgqkhTAZnLxeSmbJalSRoUE7GlhPMtZFljLOvORfEd84GkQJPR1tpnoPYebYnupOcOiQynnM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=HymQ5237; arc=none smtp.client-ip=209.85.218.54
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Received: by mail-ej1-f54.google.com with SMTP id a640c23a62f3a-ace333d5f7bso86248866b.3
        for <io-uring@vger.kernel.org>; Tue, 22 Apr 2025 07:43:34 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1745333013; x=1745937813; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=eMCKjJwL6kCRk+BjDBq/JFnq5DC6T+bdiOKZfCpidec=;
        b=HymQ5237lUO1hg835s/RFZBEmwBs35dAmVQQu3Xh0r3WUlB9RKG559HKMFQ+yNCsH+
         H4fW6b53YFUvbPkw8x9IB3kiV6863JVerAv8p9hFh68u9tiN/Tk85YHqQ7CBQAKCB3u2
         5+cCfYdMB2sfRAC5RXsFbCV2DCWoYuj1NnDu2kLxVu12TQhCBI3oI2tmgj/BT+j9ERSz
         wokcCF075R6unDg68iwvtx3jodr8spCjzoxC5vlyFTY9aGZ2TjD76qwAlxhk8hMwv39d
         L7HdXqHyLB5v7olBOM4UmTaEaxXFndczzSNi+quAVc9oKIRAlY98gypN59y/dftEbiqd
         D46A==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1745333013; x=1745937813;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=eMCKjJwL6kCRk+BjDBq/JFnq5DC6T+bdiOKZfCpidec=;
        b=c3eyrhsHmhPSiUvnPBXriIT2inOG8R570s7IK+q46hQxE1uLaTUQFkuzUymMtepPOp
         FEt2ytMoAGmTYIeyaU0AUHEMBjEgFVbTPMTOLEiWuIiicZB9OM34sdNuAUvUDXBGTfKV
         YDm30SmVhfJ3Ijpm8angxN8C2iGq4v54OuKeDCuAt/8ATL3OWZh4Fz1DF7y/gobVgFVb
         S6lIi5WgHWBeToqA0ccSb+Yn6YWATyBd5TgkAC9csP7wW4Kq0fYKWeOAylUjUeJXT912
         IKlxath+sTkzMR24AguJ4aW3NK/gf3BoMU4PJLiUuAE0evRl/xUlc9r+ITEh2AuDIE5W
         liCQ==
X-Gm-Message-State: AOJu0Yw60q7NGfYoyNZBbVNqc6QQ+BSyQoHHbXdhk1N8RAqzlxxqUjub
	fO8SYfgLSJT3Abz8Vp5YJVqy/VP507SHO4O5rOlqism0wnCRHIVqOMt/SA==
X-Gm-Gg: ASbGnctYsdo1OW0/A9tCwXpinSfbnno3hN0IYYnx117jS/QAp8MXiNxW10N+KAUurcO
	AxeS0Qu9kzcL38h/rSc2ZjPwFYwbK0/LOeBX0VU6kONMJ4CqM7ssMcL/iAfHc7AHQktxomOuNCc
	j6NbsoadvJWaAl86rWx4AubdXs/j7Mixx6dZRHxs83f1nyBcfzcVRnpaPmju8UYrpeoJF8fLh3P
	G2OFbWKV+m7yAC91pYO2vhShYTWzocIaY5+p806X+oni9s1Xqx07W8VcepvbiBJQaGcXHjNK9Oj
	39ZrE2p+gAHWVqPOKBnBGpzI
X-Google-Smtp-Source: AGHT+IHJ39WplyiUMkord2EaNN+EDfd8zfEcI/EdziqMEZUFk3QAWm6STwgrab5lkzJfJBV4+ol0NQ==
X-Received: by 2002:a17:907:9802:b0:acb:bc91:39b6 with SMTP id a640c23a62f3a-acbbc914045mr340674666b.41.1745333012783;
        Tue, 22 Apr 2025 07:43:32 -0700 (PDT)
Received: from 127.com ([2620:10d:c092:600::1:be5e])
        by smtp.gmail.com with ESMTPSA id a640c23a62f3a-acb6ef475c1sm655374966b.126.2025.04.22.07.43.32
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 22 Apr 2025 07:43:32 -0700 (PDT)
From: Pavel Begunkov <asml.silence@gmail.com>
To: io-uring@vger.kernel.org
Cc: asml.silence@gmail.com,
	David Wei <dw@davidwei.uk>
Subject: [PATCH 2/4] io_uring/zcrx: add initial infra for large pages
Date: Tue, 22 Apr 2025 15:44:42 +0100
Message-ID: <3f5949a63571e9eb3d2e4c7450d805b0ed23ff8e.1745328503.git.asml.silence@gmail.com>
X-Mailer: git-send-email 2.48.1
In-Reply-To: <cover.1745328503.git.asml.silence@gmail.com>
References: <cover.1745328503.git.asml.silence@gmail.com>
Precedence: bulk
X-Mailing-List: io-uring@vger.kernel.org
List-Id: <io-uring.vger.kernel.org>
List-Subscribe: <mailto:io-uring+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:io-uring+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

Currently, the page array and net_iovs are 4K sized and have the same
number of elements. Allow the page array to be of a different shape,
which will be needed to support huge pages. The total size should always
match, but now we can store fewer larger pages / folios. The only
restriction here is that the folios size should always be equal or
larger than the niov size.

Note, there is no way just yet to really shrink the page array, and
it'll be added in following patches.

Signed-off-by: Pavel Begunkov <asml.silence@gmail.com>
---
 io_uring/zcrx.c | 24 +++++++++++++++++++-----
 io_uring/zcrx.h |  3 +++
 2 files changed, 22 insertions(+), 5 deletions(-)

diff --git a/io_uring/zcrx.c b/io_uring/zcrx.c
index 0f9375e889c3..784c4ed6c780 100644
--- a/io_uring/zcrx.c
+++ b/io_uring/zcrx.c
@@ -38,11 +38,21 @@ static inline struct io_zcrx_area *io_zcrx_iov_to_area(const struct net_iov *nio
 	return container_of(owner, struct io_zcrx_area, nia);
 }
 
-static inline struct page *io_zcrx_iov_page(const struct net_iov *niov)
+/* shift from chunk / niov to folio size */
+static inline unsigned io_chunk_folio_shift(struct io_zcrx_area *area)
 {
-	struct io_zcrx_area *area = io_zcrx_iov_to_area(niov);
+	return area->folio_shift - PAGE_SHIFT;
+}
+
+static struct page *io_zcrx_iov_page(struct io_zcrx_area *area,
+				     const struct net_iov *niov)
+{
+	unsigned chunk_gid = net_iov_idx(niov) + area->chunk_id_offset;
+	unsigned folio_idx, base_chunk_gid;
 
-	return area->pages[net_iov_idx(niov)];
+	folio_idx = chunk_gid >> io_chunk_folio_shift(area);
+	base_chunk_gid = folio_idx << io_chunk_folio_shift(area);
+	return area->pages[folio_idx] + (chunk_gid - base_chunk_gid);
 }
 
 #define IO_DMA_ATTR (DMA_ATTR_SKIP_CPU_SYNC | DMA_ATTR_WEAK_ORDERING)
@@ -82,9 +92,11 @@ static int io_zcrx_map_area(struct io_zcrx_ifq *ifq, struct io_zcrx_area *area)
 
 	for (i = 0; i < area->nia.num_niovs; i++) {
 		struct net_iov *niov = &area->nia.niovs[i];
+		struct page *page;
 		dma_addr_t dma;
 
-		dma = dma_map_page_attrs(ifq->dev, area->pages[i], 0, PAGE_SIZE,
+		page = io_zcrx_iov_page(area, niov);
+		dma = dma_map_page_attrs(ifq->dev, page, 0, PAGE_SIZE,
 					 DMA_FROM_DEVICE, IO_DMA_ATTR);
 		if (dma_mapping_error(ifq->dev, dma))
 			break;
@@ -225,6 +237,8 @@ static int io_import_area_memory(struct io_zcrx_ifq *ifq,
 		return ret;
 	}
 	area->nr_folios = nr_pages;
+	area->folio_shift = PAGE_SHIFT;
+	area->chunk_id_offset = 0;
 	return 0;
 }
 
@@ -807,7 +821,7 @@ static ssize_t io_zcrx_copy_chunk(struct io_kiocb *req, struct io_zcrx_ifq *ifq,
 			break;
 		}
 
-		dst_page = io_zcrx_iov_page(niov);
+		dst_page = io_zcrx_iov_page(area, niov);
 		dst_addr = kmap_local_page(dst_page);
 		if (src_page)
 			src_base = kmap_local_page(src_page);
diff --git a/io_uring/zcrx.h b/io_uring/zcrx.h
index e3c7c4e647f1..dd29cfef637f 100644
--- a/io_uring/zcrx.h
+++ b/io_uring/zcrx.h
@@ -15,7 +15,10 @@ struct io_zcrx_area {
 	bool			is_mapped;
 	u16			area_id;
 	struct page		**pages;
+	/* offset into the first folio in allocation chunks  */
+	unsigned long		chunk_id_offset;
 	unsigned long		nr_folios;
+	unsigned		folio_shift;
 
 	/* freelist */
 	spinlock_t		freelist_lock ____cacheline_aligned_in_smp;
-- 
2.48.1


