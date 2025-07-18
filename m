Return-Path: <io-uring+bounces-8719-lists+io-uring=lfdr.de@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [IPv6:2604:1380:4601:e00::3])
	by mail.lfdr.de (Postfix) with ESMTPS id D880AB0AA79
	for <lists+io-uring@lfdr.de>; Fri, 18 Jul 2025 20:57:52 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id 47A6B18944F5
	for <lists+io-uring@lfdr.de>; Fri, 18 Jul 2025 18:58:10 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 4B7EF2E7F13;
	Fri, 18 Jul 2025 18:57:49 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="JrAu5frR"
X-Original-To: io-uring@vger.kernel.org
Received: from mail-ej1-f52.google.com (mail-ej1-f52.google.com [209.85.218.52])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 829082E764B
	for <io-uring@vger.kernel.org>; Fri, 18 Jul 2025 18:57:47 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.218.52
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1752865069; cv=none; b=X791ViR/kEJh2KXuOjw0Bf5Zj4TvdBDD2izjYdiD1k7XcXDgAJiiRqMS0sHSEk5cfCXJJHmA7aLG1Ivn1295VNFAtibusRiI72udiHJ7NGy/vPLlrDiO586hPhQa6uYC+Jrabu3tJdf1JlPqPtqYRVgc8ocTEt6bgT3dmbdQgWM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1752865069; c=relaxed/simple;
	bh=jOXK6TWXqY1x1BEM+sjwoDZopxMxjIVCZP4rpaY7DY4=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=ODQYOTVyDw8RUVUnp6zgeyY+ScxYJTZ58kr9UXfDVuA987bSEBkKwefx4Zu9X9sDVwaTt8nwXBQpwOduEDSSD27v+zlrrIGBSiubgmN0jVe82C3VPNq9litYFT6Av2LMq8quevONmQyUjZj1tGGlL2EkGMf6jaVTt4DK25vod3E=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=JrAu5frR; arc=none smtp.client-ip=209.85.218.52
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Received: by mail-ej1-f52.google.com with SMTP id a640c23a62f3a-aec5a714ae9so262018666b.3
        for <io-uring@vger.kernel.org>; Fri, 18 Jul 2025 11:57:47 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1752865065; x=1753469865; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=EJtaOLRzQ/rNRFQo8ZsfjEX4wDzxmGNgTfYlHdatD8U=;
        b=JrAu5frRM29ZAwXHO+JPOiMrB9cyVwxAZpE1WU3seXlfsrPOuBqUWIdPkSDUCjxsHY
         U9bXvVdcV4tZPUeS+dREBT7U6VIndIX0vT3XVtcUvf6k/MBMJKPXcggKooWuVxXBTGZ4
         i5/UGTp325VKaNigKa2aqP4iAakpffBIWQKaWEUEf6noAwcnMlE/ImuWDsYJ9sUKIhyq
         3mfEDc0wBqSfnV1TRQTA7j/3lww6Xn4tClKqGEfSGOJazN3bnfeRDI4Hrb7V+xd6B5dO
         m6xTsAMPLAzjmof47nUC9+U+cvaO5v7xkHT2Do/oh2Qub2ZyXrsl0RXmwXveDposVTw5
         OG1g==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1752865065; x=1753469865;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=EJtaOLRzQ/rNRFQo8ZsfjEX4wDzxmGNgTfYlHdatD8U=;
        b=CzgoIy4mkMyKDK4j8gFUsRJN7BRc2VUeMe2V+xYau55+yBGbAalbbYgop6wCJ6r9Xd
         Qa9UlP5IW1TkvkK9H8/VtPuxXl8CkawraA8jTkcESSdAKu/9dWnA1XYrQm6cz/LdGKCZ
         mkS30mU+Fg83i++DR5yWZh8dVkLctMQU5NgN54YGASYmOU/KkE7EL172F7cJgwByA7Il
         NVNPjKeP4z5/5iDwjFViVN5T0pPQuP2C1R0scG046CcamwAcW/1ftBbAmHFmTKD0VVlC
         zV2tnDpYB+b7KOpgYYpM/1m/3S+3f0ATQh9Uss0Qj9u3dwLV5QaupxaaF4o0Xqsw4AzH
         vepg==
X-Gm-Message-State: AOJu0YypV3UHmpsaiMlgTdmClIEpTVBaTPISpeohGg2mznMnUbFQLII9
	Crj6ra9p2GyQBgGVLSWu8v92VLaUaoCwIr2KsP6Pa0SXbLY/uY5hhT8JUs0Nig==
X-Gm-Gg: ASbGncuZlTvX17voYNIZWGsbXepVC0xojlRTzGcZgTYAP+FpBgRb8A5qKMlpG4XZeab
	KkGOjbADXG6n+U5Xd6UUR5YC2RVRRryuX/iFdEd7/mK1AAhTZrorOZdxqt17QpOzsY2RXx200hK
	cGSmPceR9vY0RSPb1GFqbObqk21EWs44/DSJYWf0nnjXaTgd1zadLQ2AxpB0NExkClnTQ81Z/uP
	elFzWheNZmVA/s3oCC5YyB0oIz7dAIBplaKQHFHFBsIrz1Oh1c7FRCm8452l0xXU5JQU9X67sCB
	NM6OHnVDA3aIlGlroqK8uHQhvNZrH5IgwZnDgEjNU6bftW6bgWjCafayW5H8Op1AIN8nMhS7lwa
	FlhNU3TGAgUy3+Lpdketpc/SLGwvQLUspIox0
X-Google-Smtp-Source: AGHT+IFJdUeECglivnZRY/N2BZjy8sjWyj/EDYmMphf4OAgjbPMMgwT1JblxLSneRCcstADeMZ3tUA==
X-Received: by 2002:a17:906:4fc3:b0:ae3:f174:4484 with SMTP id a640c23a62f3a-ae9c9b104e5mr1168434266b.46.1752865064921;
        Fri, 18 Jul 2025 11:57:44 -0700 (PDT)
Received: from 127.0.0.1localhost ([148.252.141.246])
        by smtp.gmail.com with ESMTPSA id 4fb4d7f45d1cf-612c8f09dbcsm1379130a12.12.2025.07.18.11.57.42
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 18 Jul 2025 11:57:43 -0700 (PDT)
From: Pavel Begunkov <asml.silence@gmail.com>
To: io-uring@vger.kernel.org
Cc: asml.silence@gmail.com,
	dw@davidwei.uk
Subject: [PATCH v2 2/3] io_uring/zcrx: account area memory
Date: Fri, 18 Jul 2025 19:59:03 +0100
Message-ID: <ae70e9ff629084062ba1e3474b84714585e856b0.1752865051.git.asml.silence@gmail.com>
X-Mailer: git-send-email 2.49.0
In-Reply-To: <cover.1752865051.git.asml.silence@gmail.com>
References: <cover.1752865051.git.asml.silence@gmail.com>
Precedence: bulk
X-Mailing-List: io-uring@vger.kernel.org
List-Id: <io-uring.vger.kernel.org>
List-Subscribe: <mailto:io-uring+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:io-uring+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

zcrx areas can be quite large and need to be accounted and checked
against RLIMIT_MEMLOCK. In practise it shouldn't be a big issue as
the inteface already requires cap_net_admin.

Cc: stable@vger.kernel.org
Fixes: cf96310c5f9a0 ("io_uring/zcrx: add io_zcrx_area")
Signed-off-by: Pavel Begunkov <asml.silence@gmail.com>
---
 io_uring/zcrx.c | 32 ++++++++++++++++++++++++++++----
 io_uring/zcrx.h |  1 +
 2 files changed, 29 insertions(+), 4 deletions(-)

diff --git a/io_uring/zcrx.c b/io_uring/zcrx.c
index 7d7396ce876c..4f9191f922a1 100644
--- a/io_uring/zcrx.c
+++ b/io_uring/zcrx.c
@@ -158,6 +158,23 @@ static int io_zcrx_map_area_dmabuf(struct io_zcrx_ifq *ifq, struct io_zcrx_area
 				    area->mem.dmabuf_offset);
 }
 
+static unsigned long io_count_account_pages(struct page **pages, unsigned nr_pages)
+{
+	struct folio *last_folio = NULL;
+	unsigned long res = 0;
+	int i;
+
+	for (i = 0; i < nr_pages; i++) {
+		struct folio *folio = page_folio(pages[i]);
+
+		if (folio == last_folio)
+			continue;
+		last_folio = folio;
+		res += 1UL << folio_order(folio);
+	}
+	return res;
+}
+
 static int io_import_umem(struct io_zcrx_ifq *ifq,
 			  struct io_zcrx_mem *mem,
 			  struct io_uring_zcrx_area_reg *area_reg)
@@ -180,10 +197,15 @@ static int io_import_umem(struct io_zcrx_ifq *ifq,
 	if (ret)
 		return ret;
 
+	mem->account_pages = io_count_account_pages(pages, nr_pages);
+	ret = io_account_mem(ifq->ctx, mem->account_pages);
+	if (ret)
+		mem->account_pages = 0;
+
 	mem->pages = pages;
 	mem->nr_folios = nr_pages;
 	mem->size = area_reg->len;
-	return 0;
+	return ret;
 }
 
 static void io_release_area_mem(struct io_zcrx_mem *mem)
@@ -353,10 +375,12 @@ static void io_free_rbuf_ring(struct io_zcrx_ifq *ifq)
 
 static void io_zcrx_free_area(struct io_zcrx_area *area)
 {
-	if (area->ifq)
-		io_zcrx_unmap_area(area->ifq, area);
+	io_zcrx_unmap_area(area->ifq, area);
 	io_release_area_mem(&area->mem);
 
+	if (area->mem.account_pages)
+		io_unaccount_mem(area->ifq->ctx, area->mem.account_pages);
+
 	kvfree(area->freelist);
 	kvfree(area->nia.niovs);
 	kvfree(area->user_refs);
@@ -384,6 +408,7 @@ static int io_zcrx_create_area(struct io_zcrx_ifq *ifq,
 	area = kzalloc(sizeof(*area), GFP_KERNEL);
 	if (!area)
 		goto err;
+	area->ifq = ifq;
 
 	ret = io_import_area(ifq, &area->mem, area_reg);
 	if (ret)
@@ -418,7 +443,6 @@ static int io_zcrx_create_area(struct io_zcrx_ifq *ifq,
 	}
 
 	area->free_count = nr_iovs;
-	area->ifq = ifq;
 	/* we're only supporting one area per ifq for now */
 	area->area_id = 0;
 	area_reg->rq_area_token = (u64)area->area_id << IORING_ZCRX_AREA_SHIFT;
diff --git a/io_uring/zcrx.h b/io_uring/zcrx.h
index 89015b923911..109c4ca36434 100644
--- a/io_uring/zcrx.h
+++ b/io_uring/zcrx.h
@@ -15,6 +15,7 @@ struct io_zcrx_mem {
 	struct page			**pages;
 	unsigned long			nr_folios;
 	struct sg_table			page_sg_table;
+	unsigned long			account_pages;
 
 	struct dma_buf_attachment	*attach;
 	struct dma_buf			*dmabuf;
-- 
2.49.0


