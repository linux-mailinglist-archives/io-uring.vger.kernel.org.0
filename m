Return-Path: <io-uring+bounces-8566-lists+io-uring=lfdr.de@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [147.75.199.223])
	by mail.lfdr.de (Postfix) with ESMTPS id 52061AF5A60
	for <lists+io-uring@lfdr.de>; Wed,  2 Jul 2025 16:02:16 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id 0C2EC4E6CEA
	for <lists+io-uring@lfdr.de>; Wed,  2 Jul 2025 14:02:15 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 547916FC5;
	Wed,  2 Jul 2025 14:02:11 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="el/BXJss"
X-Original-To: io-uring@vger.kernel.org
Received: from mail-pl1-f177.google.com (mail-pl1-f177.google.com [209.85.214.177])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id DFAC119342F
	for <io-uring@vger.kernel.org>; Wed,  2 Jul 2025 14:02:09 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.214.177
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1751464931; cv=none; b=ZmF8NxbPkrscjzWlFPRPrqxUiJvt6MQs/ebGRqIw/xnWx17AVw9qNAXc/gTJq+gjA0hJe+ycMx6ew4+b0XqvfUJu6/sqTyq9UIL9vwm4nGGamZBOSGWxltGPvys/mZG2zSqLINx+deFBL1HzmRApeDDp20jwl6PV665tqZ3CDNw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1751464931; c=relaxed/simple;
	bh=4OFf5Hb905eFuvFC3PdSs9Tv2OSIUaSCSMnXgwpLnT0=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=KcZ4JBqAo7COXFHKSNj18U2H2/Qel0/N3kuBIPFPVfHzwGdKDAoAEHaAnEBI2IkuldZ1rwFWLmy2GztjgOGOvdfW77cpDvIViiVE4gtVF5UlCBs68g0OUzjtDx35kiRalivzcaARXzzIYj5FwpgCHdkrMsa5kZZe3T0MB5f+s2E=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=el/BXJss; arc=none smtp.client-ip=209.85.214.177
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Received: by mail-pl1-f177.google.com with SMTP id d9443c01a7336-234b9dfb842so41292245ad.1
        for <io-uring@vger.kernel.org>; Wed, 02 Jul 2025 07:02:09 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1751464929; x=1752069729; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=IAc+jVeSquKm/tIell4OX+9rFxYJdq94AKJ2GG1EWOY=;
        b=el/BXJssBJSriRNjfcxw89JE0o75rWFMj/Ub+KKlxipTsCIJ/Vp220RlGyvwLXLoI4
         j5YBvDKwpTAtJlvinkzijsYC87qyGh0SDH1Rp8/QS1L1X7sedVjcm9gHbSDfZufLT+SY
         DETBj0O22YdQEj5VzC1x0iil37id1s623Rwb1/qcU4qR7Cha38i1K2/Ppk0LAr0JATHO
         ztJaDJqLtQt76lc4B5SBHyU42dsvDMGmfBNWYUYj+fNnLZq8idHsi0be1I2jvs7N+sNL
         BmvzlXQlWb/VUKAlRR1oFllcYXJUdwgd74q2urxJxKLocu3dL5EqSyET+35d9SKaXLDl
         wc4A==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1751464929; x=1752069729;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=IAc+jVeSquKm/tIell4OX+9rFxYJdq94AKJ2GG1EWOY=;
        b=XN6B9uhcNe+EE2A/VQaxVxAippOloGPinCMGdBqlJ+UbQYqmpUVlHceM95HrNjJn2J
         9pDXa9LtyxORQPhJ1qEDoh+BMu0+4dbdU67GY0ydx6KvrWF7dknd40PmSWLlKCflQNFk
         5IsSkRHp/TDR6/0vRQuTmH0se6h/r6veriDCfxGj9cc9XjbwH4KkXac+iXwRoKmzTMFK
         zGs3Cy+bSOZ+Zk5O6hohb+O1HGfBw5fXZtYrkCx0OuziG894UAvocj3fDV1UETw9kCQL
         xODASZ8+dMQ5pgOE6y+eAche1BQ58KNodMMZe0ba0M7+2GUH0iiNjYVY6za//ptPo8qw
         0EmQ==
X-Gm-Message-State: AOJu0Yzc/L3O3u9s+6FI/fdkRatZpjn4TwsumlWoOmUSmoZjAV0wD1Pk
	EIrR9rXGAFA4v4cj6DJanoDKyCSoyWl+gBA05r9x2hobACJMgNtozzssG03TEnVL
X-Gm-Gg: ASbGnctp3jz85B/TH3YuBMat2t4KTSitdG7526zsNx37D6Hm8fb2tckSa5eUQ6Gsj/t
	+XARplqUS9iFUzrXHdkXpYGLj5pY9DufS2ZEDblqjEXBLl3iK0Aoe0qdLV91dhAEGj25YLdortG
	ugHMFifWuSLji05dLryifqUVBzrtrrfnPwH4ignF3XqD9xguiDAmcxmVKCN9u68MCSi76bUghwv
	5m3LUPuFKqu0ZCT2/CBo/1eP4EKizPXyotmzsyp2COvfOxD6DFF5xI+L4GKQ7xy9Rb4UgMfCwwP
	mZlcnrArtsUJmR0lgjU9M5Q4HSR1UetHANmTFqvBT2TwyK4Ij0L/GBqOzlE=
X-Google-Smtp-Source: AGHT+IGrYlkAWSAGIzXlo65Gz3/5dwzbbfISlTDsywmC8FM2o6lZXY3VIGGkU67An0qww9Vmhwq/IQ==
X-Received: by 2002:a17:902:d4c8:b0:234:f182:a735 with SMTP id d9443c01a7336-23c6e58aa8emr54528375ad.34.1751464928387;
        Wed, 02 Jul 2025 07:02:08 -0700 (PDT)
Received: from 127.com ([50.230.198.98])
        by smtp.gmail.com with ESMTPSA id d9443c01a7336-23acb3c6e14sm126828135ad.228.2025.07.02.07.02.07
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 02 Jul 2025 07:02:07 -0700 (PDT)
From: Pavel Begunkov <asml.silence@gmail.com>
To: io-uring@vger.kernel.org
Cc: asml.silence@gmail.com
Subject: [PATCH v3 1/6] io_uring/zcrx: always pass page to io_zcrx_copy_chunk
Date: Wed,  2 Jul 2025 15:03:21 +0100
Message-ID: <b8f9f4bac027f5f44a9ccf85350912d1db41ceb8.1751464343.git.asml.silence@gmail.com>
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

io_zcrx_copy_chunk() currently takes either a page or virtual address.
Unify the parameters, make it take pages and resolve the linear part
into a page the same way general networking code does that.

Signed-off-by: Pavel Begunkov <asml.silence@gmail.com>
---
 io_uring/zcrx.c | 21 ++++++++++-----------
 1 file changed, 10 insertions(+), 11 deletions(-)

diff --git a/io_uring/zcrx.c b/io_uring/zcrx.c
index 797247a34cb7..99a253c1c6c5 100644
--- a/io_uring/zcrx.c
+++ b/io_uring/zcrx.c
@@ -943,8 +943,8 @@ static struct net_iov *io_zcrx_alloc_fallback(struct io_zcrx_area *area)
 }
 
 static ssize_t io_zcrx_copy_chunk(struct io_kiocb *req, struct io_zcrx_ifq *ifq,
-				  void *src_base, struct page *src_page,
-				  unsigned int src_offset, size_t len)
+				  struct page *src_page, unsigned int src_offset,
+				  size_t len)
 {
 	struct io_zcrx_area *area = ifq->area;
 	size_t copied = 0;
@@ -958,7 +958,7 @@ static ssize_t io_zcrx_copy_chunk(struct io_kiocb *req, struct io_zcrx_ifq *ifq,
 		const int dst_off = 0;
 		struct net_iov *niov;
 		struct page *dst_page;
-		void *dst_addr;
+		void *dst_addr, *src_addr;
 
 		niov = io_zcrx_alloc_fallback(area);
 		if (!niov) {
@@ -968,13 +968,11 @@ static ssize_t io_zcrx_copy_chunk(struct io_kiocb *req, struct io_zcrx_ifq *ifq,
 
 		dst_page = io_zcrx_iov_page(niov);
 		dst_addr = kmap_local_page(dst_page);
-		if (src_page)
-			src_base = kmap_local_page(src_page);
+		src_addr = kmap_local_page(src_page);
 
-		memcpy(dst_addr, src_base + src_offset, copy_size);
+		memcpy(dst_addr, src_addr + src_offset, copy_size);
 
-		if (src_page)
-			kunmap_local(src_base);
+		kunmap_local(src_addr);
 		kunmap_local(dst_addr);
 
 		if (!io_zcrx_queue_cqe(req, niov, ifq, dst_off, copy_size)) {
@@ -1003,7 +1001,7 @@ static int io_zcrx_copy_frag(struct io_kiocb *req, struct io_zcrx_ifq *ifq,
 
 	skb_frag_foreach_page(frag, off, len,
 			      page, p_off, p_len, t) {
-		ret = io_zcrx_copy_chunk(req, ifq, NULL, page, p_off, p_len);
+		ret = io_zcrx_copy_chunk(req, ifq, page, p_off, p_len);
 		if (ret < 0)
 			return copied ? copied : ret;
 		copied += ret;
@@ -1065,8 +1063,9 @@ io_zcrx_recv_skb(read_descriptor_t *desc, struct sk_buff *skb,
 		size_t to_copy;
 
 		to_copy = min_t(size_t, skb_headlen(skb) - offset, len);
-		copied = io_zcrx_copy_chunk(req, ifq, skb->data, NULL,
-					    offset, to_copy);
+		copied = io_zcrx_copy_chunk(req, ifq, virt_to_page(skb->data),
+					    offset_in_page(skb->data) + offset,
+					    to_copy);
 		if (copied < 0) {
 			ret = copied;
 			goto out;
-- 
2.49.0


