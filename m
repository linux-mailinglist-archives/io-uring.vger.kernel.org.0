Return-Path: <io-uring+bounces-8996-lists+io-uring=lfdr.de@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from sy.mirrors.kernel.org (sy.mirrors.kernel.org [IPv6:2604:1380:40f1:3f00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id A6544B29587
	for <lists+io-uring@lfdr.de>; Mon, 18 Aug 2025 00:42:52 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sy.mirrors.kernel.org (Postfix) with ESMTPS id 7440C7AB83A
	for <lists+io-uring@lfdr.de>; Sun, 17 Aug 2025 22:41:18 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 725C221D3E4;
	Sun, 17 Aug 2025 22:42:48 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="JPhfLemO"
X-Original-To: io-uring@vger.kernel.org
Received: from mail-wr1-f42.google.com (mail-wr1-f42.google.com [209.85.221.42])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A56072264DB
	for <io-uring@vger.kernel.org>; Sun, 17 Aug 2025 22:42:46 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.221.42
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1755470568; cv=none; b=f1iymUrvjlIv4y75s6zUIW5o0Z3jZUbiQXDHtaL827NmndN/XsP+eX6Q1R+E14yp9CCyH+qrpdvgevn1nbAWkkGW8tjHiyOq/okuMpYr0E7HWOem1GSZcMZeIME1j+lodf4q00U3JGIr286YZBD6O2TVIwlGysT/+UoAwOH4b+s=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1755470568; c=relaxed/simple;
	bh=Xt+TuCg2Gyj/zJJ0qyCaGmI35lcMdyPjOGcEQd38uro=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=MScj4590ku30Y/KZ7C17CUOknpBq+pfWkih5Fv8hT63vtKbketio5IhET6Xv7ZJqEGXxCT7F1zapV6u389JLNJZNxgq9QV9MlwpEMYdVPOcK6pDXZIpKiobREtsf0t9xcLsOTN0Vp0jpZgDww3FEjLlF0VRl5XbhVkwVTInb5Mc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=JPhfLemO; arc=none smtp.client-ip=209.85.221.42
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Received: by mail-wr1-f42.google.com with SMTP id ffacd0b85a97d-3b9e4193083so3369910f8f.3
        for <io-uring@vger.kernel.org>; Sun, 17 Aug 2025 15:42:46 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1755470564; x=1756075364; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=s3LLC84EjqB1Eg1JhuyGC8oLmtkPgZC5y8qL389WX5U=;
        b=JPhfLemOofAP4FovQvLUTt8ykRl9Atf9S7gYcBv0Hh1LTZmvtFAEtIThW16Uooax3u
         9YpPf76jGvjDdwv8jpAelpnbf0e2Bf21lRclK+s1nxudLNjGyMm4SdiuZ+dfsbMahYn9
         AtBV+XkrVfFeHF2a7/dW16DMszmTyQkn0oTbctAd0Cp6xQFytrymPNzVA0aePumnawZi
         mHGw9vFWnlGBpMqo8RRWrP3eTNJMsmC/5GYqwViIzGL4GKz+0Ord4y3KVnZ2uHbKc+rt
         EQwD47X8tKEnRdLX+0WSR5FKK+CrK9DWngyvBDsc3jEYztrFLbjSC0bIkqtftLC5+Etm
         HtVg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1755470564; x=1756075364;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=s3LLC84EjqB1Eg1JhuyGC8oLmtkPgZC5y8qL389WX5U=;
        b=hsk5Bt0q4viEHv4CN8Y1+UksTppWsgLQhJngk4OJuWhcIbfm9RNbt8T8mRRB2N5JHG
         KA0OXOOEA+SrBEFyoYB3ZIW5zSKhfPNScQ0nt+AZF/AzwzGLpEhcXUdHQ+zqQbio+4GO
         vKau3W4YTkD7W8SJsNBV2rxuz5isLTgu0Yh006Ujzvi5VBEUXrutaj7fOJXsDJ5Gcuts
         4WBPRfnihrnQlLvpP/uqKWJihSlvy3V3TnQ2jttn8o1oxtVq5acTBB7ie7pTsyxGRMdl
         364x/+aDQL6V4467iqzjkZrasr1GClhXxsaLiwBVhR5mUpsimGJDRRxWMan7SV2i5Uct
         hO2g==
X-Gm-Message-State: AOJu0YxFrWcAxDQIq4LY442m3qXwo9H/dgdM8s01O25NPItZiOrGsKPq
	CMb3E42conqnJ0vA0sJsP7iYuCujNa/bP3xwZhjiym4NFfvV+oZkfHv5J3rk6g==
X-Gm-Gg: ASbGncvTS1LO6V/UTJWxVlFXvyCshBAicqspj53X0qtKPemboKZwSeoAkP78ApQ85Un
	IiEs178Ru6c2e0x76/rwT/dNIEhZzdP+/adOvnFjmnPeFsoCp/ZRvtfV7yU1J0180nwbxab6DOq
	fjcPCdCNNRDih4b6r4cpgee6u+k6eZML2mGhfSgHS4tQsz4uBTZQFW/Y2nivYNP0evUvbVvCqBY
	bocL0bmLttK7MW95wCQAUZttniUBQ2ZUOg2Ve3u5XcfFzvo9+SO4nSFL14iIf/60XSf63zfBR2T
	NtUFCXhWT7N6VEZ6eho3ald3fxBiv5t9tf7ZYy6qqH9kla8ew8sCL9HzkUOwFXSxBe5PUdMJoTQ
	ioz1EuVYxgh7S0jzJI0rZlZHLBhr9eytjng==
X-Google-Smtp-Source: AGHT+IHqhccG+FpXNayFfVam/54PWbhHjZr8AAuNmY4dUiR/EKHzTzNoNiimNPDEAfCxOmhBSSLoDg==
X-Received: by 2002:a05:6000:25c2:b0:3b7:9dc1:74a5 with SMTP id ffacd0b85a97d-3bb69699db6mr7771901f8f.52.1755470564389;
        Sun, 17 Aug 2025 15:42:44 -0700 (PDT)
Received: from 127.0.0.1localhost ([185.69.144.43])
        by smtp.gmail.com with ESMTPSA id 5b1f17b1804b1-45a2231f7e8sm112001565e9.14.2025.08.17.15.42.43
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sun, 17 Aug 2025 15:42:43 -0700 (PDT)
From: Pavel Begunkov <asml.silence@gmail.com>
To: io-uring@vger.kernel.org
Cc: asml.silence@gmail.com
Subject: [zcrx-next 06/10] io_uring/zcrx: unify allocation dma sync
Date: Sun, 17 Aug 2025 23:43:32 +0100
Message-ID: <b0d53ed2e576134dda0a3bde1099c7e1edf96edd.1755467432.git.asml.silence@gmail.com>
X-Mailer: git-send-email 2.49.0
In-Reply-To: <cover.1755467432.git.asml.silence@gmail.com>
References: <cover.1755467432.git.asml.silence@gmail.com>
Precedence: bulk
X-Mailing-List: io-uring@vger.kernel.org
List-Id: <io-uring.vger.kernel.org>
List-Subscribe: <mailto:io-uring+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:io-uring+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

First, I want niov dma sync'ing during page pool allocation out of
spinlocked sections, i.e. rq_lock for ring refilling and freelist_lock
for slow path allocation. Move it all to a common section, which can
further optimise by checking dma_dev_need_sync() only once per batch.

Signed-off-by: Pavel Begunkov <asml.silence@gmail.com>
---
 io_uring/zcrx.c | 39 ++++++++++++++++++++-------------------
 1 file changed, 20 insertions(+), 19 deletions(-)

diff --git a/io_uring/zcrx.c b/io_uring/zcrx.c
index d8dd4624f8f8..555d4d9ff479 100644
--- a/io_uring/zcrx.c
+++ b/io_uring/zcrx.c
@@ -292,21 +292,6 @@ static int io_zcrx_map_area(struct io_zcrx_ifq *ifq, struct io_zcrx_area *area)
 	return ret;
 }
 
-static void io_zcrx_sync_for_device(const struct page_pool *pool,
-				    struct net_iov *niov)
-{
-#if defined(CONFIG_HAS_DMA) && defined(CONFIG_DMA_NEED_SYNC)
-	dma_addr_t dma_addr;
-
-	if (!dma_dev_need_sync(pool->p.dev))
-		return;
-
-	dma_addr = page_pool_get_dma_addr_netmem(net_iov_to_netmem(niov));
-	__dma_sync_single_for_device(pool->p.dev, dma_addr + pool->p.offset,
-				     PAGE_SIZE, pool->p.dma_dir);
-#endif
-}
-
 #define IO_RQ_MAX_ENTRIES		32768
 
 #define IO_SKBS_PER_CALL_LIMIT	20
@@ -791,7 +776,6 @@ static void io_zcrx_ring_refill(struct page_pool *pp,
 			continue;
 		}
 
-		io_zcrx_sync_for_device(pp, niov);
 		net_mp_netmem_place_in_cache(pp, netmem);
 	} while (--entries);
 
@@ -806,15 +790,31 @@ static void io_zcrx_refill_slow(struct page_pool *pp, struct io_zcrx_ifq *ifq)
 	spin_lock_bh(&area->freelist_lock);
 	while (area->free_count && pp->alloc.count < PP_ALLOC_CACHE_REFILL) {
 		struct net_iov *niov = __io_zcrx_get_free_niov(area);
-		netmem_ref netmem = net_iov_to_netmem(niov);
 
 		net_mp_niov_set_page_pool(pp, niov);
-		io_zcrx_sync_for_device(pp, niov);
-		net_mp_netmem_place_in_cache(pp, netmem);
+		net_mp_netmem_place_in_cache(pp, net_iov_to_netmem(niov));
 	}
 	spin_unlock_bh(&area->freelist_lock);
 }
 
+static void io_sync_allocated_niovs(struct page_pool *pp)
+{
+#if defined(CONFIG_HAS_DMA) && defined(CONFIG_DMA_NEED_SYNC)
+	int i;
+
+	if (!dma_dev_need_sync(pp->p.dev))
+		return;
+
+	for (i = 0; i < pp->alloc.count; i++) {
+		netmem_ref netmem = pp->alloc.cache[i];
+		dma_addr_t dma_addr = page_pool_get_dma_addr_netmem(netmem);
+
+		__dma_sync_single_for_device(pp->p.dev, dma_addr + pp->p.offset,
+					     PAGE_SIZE, pp->p.dma_dir);
+	}
+#endif
+}
+
 static netmem_ref io_pp_zc_alloc_netmems(struct page_pool *pp, gfp_t gfp)
 {
 	struct io_zcrx_ifq *ifq = io_pp_to_ifq(pp);
@@ -831,6 +831,7 @@ static netmem_ref io_pp_zc_alloc_netmems(struct page_pool *pp, gfp_t gfp)
 	if (!pp->alloc.count)
 		return 0;
 out_return:
+	io_sync_allocated_niovs(pp);
 	return pp->alloc.cache[--pp->alloc.count];
 }
 
-- 
2.49.0


