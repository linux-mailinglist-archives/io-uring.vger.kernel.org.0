Return-Path: <io-uring+bounces-7414-lists+io-uring=lfdr.de@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [147.75.80.249])
	by mail.lfdr.de (Postfix) with ESMTPS id 269E6A7C8B4
	for <lists+io-uring@lfdr.de>; Sat,  5 Apr 2025 12:17:27 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id BFB631894A8E
	for <lists+io-uring@lfdr.de>; Sat,  5 Apr 2025 10:17:36 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 5424B19D8B2;
	Sat,  5 Apr 2025 10:17:22 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="SNojJH2Q"
X-Original-To: io-uring@vger.kernel.org
Received: from mail-ej1-f47.google.com (mail-ej1-f47.google.com [209.85.218.47])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8718E182BC
	for <io-uring@vger.kernel.org>; Sat,  5 Apr 2025 10:17:20 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.218.47
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1743848242; cv=none; b=lwKE2UuVxRxN+/atPOVtfuXVjq8c1LUD4f9SOOJADqpkbG9hhK3dtD3QVuZwxzcuV4LYHkZ0rTZrIqGElXEkbBDR9EE/bIFYrMbbtE7ttMPLDrDmJVFCCOTZ/8Hn4E2vtjSuHqoY76LalJHrsUpcVN1yptjvybiyhxntJiqQNck=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1743848242; c=relaxed/simple;
	bh=3C09jkOZdXiZSy3mDrBRbbYCj6ac6Rf7pysrU/EONYs=;
	h=From:To:Cc:Subject:Date:Message-ID:MIME-Version; b=cms0srMV5/MEDbE27Bs/qRBz9iQ0F6SYek2B9NTt5WCD4z9alE5TQLdkg+UsYwuGVppY/EV3YG62wz3ZvrsfnmN3SIFSDIhx7Gstvq872XIqRgcsyH8Ce+dfCxNKOgOoP+AR1hMqlhGI5k0NLTrOrJD3JhtXj7q+QsNYZUJEgWs=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=SNojJH2Q; arc=none smtp.client-ip=209.85.218.47
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Received: by mail-ej1-f47.google.com with SMTP id a640c23a62f3a-ac2a9a74d9cso166884566b.1
        for <io-uring@vger.kernel.org>; Sat, 05 Apr 2025 03:17:20 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1743848238; x=1744453038; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:from:to:cc:subject:date:message-id:reply-to;
        bh=REdE3/7hFN2YpAh2WCSjY3gFaHMsRBG2vecOWCFkKFI=;
        b=SNojJH2QalJS4qaU9K0j7wpSJWgNElQ1V5X/2akRCSzs264fPOEDBm+xCMu15EjOtj
         UquVlWdt6pfgcMvtfVSbn7CEl2Lv4coWbm6qDMoXX8TY2htI9YD1P4U5oWbScvBDK1xR
         9bT6SiLeiC5hp4Q8gjZIdnOsTLHDGLA7B1v1SFSFqK7ItwjUQ5kSgq7rlr+ciN7cU22e
         CMB/u6C2Zr1qA71ROkrm9iA8WhzMmJMVUQ1mvnUzgab8UT/4ubvxyG2LtPXF9dao62CY
         aY1zHwo8xdjDWHg4VBdHPgarb1Hb7j9ulDmuj4sdmmysKBNJPes+W7tJmBXB0MHpK+ju
         YYlg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1743848238; x=1744453038;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=REdE3/7hFN2YpAh2WCSjY3gFaHMsRBG2vecOWCFkKFI=;
        b=GkoFjco1yw/XD77bh/EiNStKI3pz+lQ/kTe6SNs5MNyS61Hvtsb3zOOv7p/Oc5JFfH
         G0LNJU45ilNTA/6mLtpu3MTdDDuxM5AWt/VEU6Y+l+AIL76iVGcDq81iKFg2NAS9UXSn
         O1e/DLHwZZd2wYR0hKxiqlAdohCi9LDNcG+xPoOVcDPacJBrRK++rMpoaPV4HyNq4dxf
         yVjjNF/Q1cXMS1yLVnjmQc4Y+dJdhHLSRzXSuLSr3CtA0JoTjV2Lj8YJVW/10S0j3b6h
         QNDGttLzEICfKRB49yHupGtzNrobDblftbqQn020ScEZbQQzJgCMRakwpP9yQvCjINIj
         uEVA==
X-Gm-Message-State: AOJu0Yys+P2G77Vpj0w6oOHCwOP23a9f1H3LdRX+E8punsukdRJlGm/J
	cxhCCsG0PTIOQVp9Cgnc+9gPP00punbRW8jATaga763qaxqVxWc+SYCRtA==
X-Gm-Gg: ASbGncuuMeNrnvSFLnfJ98c3r4+K118Eck5QJeCFd8/Tb47gKMAyYrpGUnmX4ck1M3Y
	pEdEw3IBSasXPINZi5vDAuaDhL8yNRIQ6tUX3cR0ByeRWMU8q3PHCD/Ixv7ULHddY2RuRdfXYKp
	D3GrRaJoGUgcL8fHt0rwp7RwUQfw2DLp58XuO/PCqgZRvLDJDpMtXyDmFpayeHmSZAh32VW7ztf
	+qwoVOwKzcFd9oS1TwuTQmP0c18iMsI76+jBkiXcIbMl0kRzn5GspUqBMsTrW0oK2Q2n90yqtXm
	OaGqn627xGBIf7BgrULu3CtjxpyKe1QgJTYsq+IV1Gssdc28MjZxnTDcZlI=
X-Google-Smtp-Source: AGHT+IG/mVwII8hnTSPn8mPZWbZmX0XB7JdlaZ6ekuUi4fccb3KG9rovSZJ9QR7Nej3PZq3+Sr9XiA==
X-Received: by 2002:a17:906:c115:b0:ac6:ba4e:e769 with SMTP id a640c23a62f3a-ac7d18e2570mr485045266b.35.1743848238050;
        Sat, 05 Apr 2025 03:17:18 -0700 (PDT)
Received: from 127.0.0.1localhost ([148.252.128.155])
        by smtp.gmail.com with ESMTPSA id a640c23a62f3a-ac7bfee2591sm396142366b.79.2025.04.05.03.17.16
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sat, 05 Apr 2025 03:17:17 -0700 (PDT)
From: Pavel Begunkov <asml.silence@gmail.com>
To: io-uring@vger.kernel.org
Cc: asml.silence@gmail.com
Subject: [PATCH 1/1] io_uring/zcrx: separate niov number from pages
Date: Sat,  5 Apr 2025 11:18:29 +0100
Message-ID: <0780ac966ee84200385737f45bb0f2ada052392b.1743848231.git.asml.silence@gmail.com>
X-Mailer: git-send-email 2.48.1
Precedence: bulk
X-Mailing-List: io-uring@vger.kernel.org
List-Id: <io-uring.vger.kernel.org>
List-Subscribe: <mailto:io-uring+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:io-uring+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

A preparation patch that separates the number of pages / folios from
the number of niovs. They will not match in the future to support huge
pages, improved dma mapping and/or larger chunk sizes.

Signed-off-by: Pavel Begunkov <asml.silence@gmail.com>
---
 io_uring/zcrx.c | 19 ++++++++++---------
 io_uring/zcrx.h |  1 +
 2 files changed, 11 insertions(+), 9 deletions(-)

diff --git a/io_uring/zcrx.c b/io_uring/zcrx.c
index 80d4a6f71d29..0f46e0404c04 100644
--- a/io_uring/zcrx.c
+++ b/io_uring/zcrx.c
@@ -181,7 +181,7 @@ static void io_zcrx_free_area(struct io_zcrx_area *area)
 	kvfree(area->nia.niovs);
 	kvfree(area->user_refs);
 	if (area->pages) {
-		unpin_user_pages(area->pages, area->nia.num_niovs);
+		unpin_user_pages(area->pages, area->nr_folios);
 		kvfree(area->pages);
 	}
 	kfree(area);
@@ -192,7 +192,7 @@ static int io_zcrx_create_area(struct io_zcrx_ifq *ifq,
 			       struct io_uring_zcrx_area_reg *area_reg)
 {
 	struct io_zcrx_area *area;
-	int i, ret, nr_pages;
+	int i, ret, nr_pages, nr_iovs;
 	struct iovec iov;
 
 	if (area_reg->flags || area_reg->rq_area_token)
@@ -220,27 +220,28 @@ static int io_zcrx_create_area(struct io_zcrx_ifq *ifq,
 		area->pages = NULL;
 		goto err;
 	}
-	area->nia.num_niovs = nr_pages;
+	area->nr_folios = nr_iovs = nr_pages;
+	area->nia.num_niovs = nr_iovs;
 
-	area->nia.niovs = kvmalloc_array(nr_pages, sizeof(area->nia.niovs[0]),
+	area->nia.niovs = kvmalloc_array(nr_iovs, sizeof(area->nia.niovs[0]),
 					 GFP_KERNEL | __GFP_ZERO);
 	if (!area->nia.niovs)
 		goto err;
 
-	area->freelist = kvmalloc_array(nr_pages, sizeof(area->freelist[0]),
+	area->freelist = kvmalloc_array(nr_iovs, sizeof(area->freelist[0]),
 					GFP_KERNEL | __GFP_ZERO);
 	if (!area->freelist)
 		goto err;
 
-	for (i = 0; i < nr_pages; i++)
+	for (i = 0; i < nr_iovs; i++)
 		area->freelist[i] = i;
 
-	area->user_refs = kvmalloc_array(nr_pages, sizeof(area->user_refs[0]),
+	area->user_refs = kvmalloc_array(nr_iovs, sizeof(area->user_refs[0]),
 					GFP_KERNEL | __GFP_ZERO);
 	if (!area->user_refs)
 		goto err;
 
-	for (i = 0; i < nr_pages; i++) {
+	for (i = 0; i < nr_iovs; i++) {
 		struct net_iov *niov = &area->nia.niovs[i];
 
 		niov->owner = &area->nia;
@@ -248,7 +249,7 @@ static int io_zcrx_create_area(struct io_zcrx_ifq *ifq,
 		atomic_set(&area->user_refs[i], 0);
 	}
 
-	area->free_count = nr_pages;
+	area->free_count = nr_iovs;
 	area->ifq = ifq;
 	/* we're only supporting one area per ifq for now */
 	area->area_id = 0;
diff --git a/io_uring/zcrx.h b/io_uring/zcrx.h
index b59c560d5d84..47f1c0e8c197 100644
--- a/io_uring/zcrx.h
+++ b/io_uring/zcrx.h
@@ -15,6 +15,7 @@ struct io_zcrx_area {
 	bool			is_mapped;
 	u16			area_id;
 	struct page		**pages;
+	unsigned long		nr_folios;
 
 	/* freelist */
 	spinlock_t		freelist_lock ____cacheline_aligned_in_smp;
-- 
2.48.1


