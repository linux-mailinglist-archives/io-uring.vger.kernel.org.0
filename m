Return-Path: <io-uring+bounces-10828-lists+io-uring=lfdr.de@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from ams.mirrors.kernel.org (ams.mirrors.kernel.org [213.196.21.55])
	by mail.lfdr.de (Postfix) with ESMTPS id 259CCC9026A
	for <lists+io-uring@lfdr.de>; Thu, 27 Nov 2025 21:45:35 +0100 (CET)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ams.mirrors.kernel.org (Postfix) with ESMTPS id 454A6352175
	for <lists+io-uring@lfdr.de>; Thu, 27 Nov 2025 20:45:17 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id A665831B117;
	Thu, 27 Nov 2025 20:44:38 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="IzposqnL"
X-Original-To: io-uring@vger.kernel.org
Received: from mail-wr1-f47.google.com (mail-wr1-f47.google.com [209.85.221.47])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6D96E319877
	for <io-uring@vger.kernel.org>; Thu, 27 Nov 2025 20:44:36 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.221.47
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1764276278; cv=none; b=ZqFJ3adNi2ECs+iWj1Q5HA1SwAeGYSak69ujRwwg+b6qZPxu6fUobeSRtTZI4F/a/S1Kntr4P0bFym7Kd93s4G62z/go+4CT/BzaNMly+vjHi4uG0JqjjA6byoKfApcUxZ7BIBo4VUh/Uvvvl8/5CHS8yhHVkjzv+1AYIkDTWTc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1764276278; c=relaxed/simple;
	bh=uEGzlDiVU0J1DPM077m+k2M5cF68ly3S+S+LQCQel4w=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=tecibf0J/xYNgw+vmHNhH75EdQSMVmJ9+6bfTGPlvJZZdxTMY5k/aXltyxJNznxK5YPBQ/oKJlJRxmAkHPooBUc6sPEsjFWJq0VV0D8ZrgLob+6T3lltPdf7yEa3YTlE/miRey9TkmjssTa6EOfgPHxltvsdaKDZW49sOglRIpg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=IzposqnL; arc=none smtp.client-ip=209.85.221.47
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Received: by mail-wr1-f47.google.com with SMTP id ffacd0b85a97d-42b3108f41fso810219f8f.3
        for <io-uring@vger.kernel.org>; Thu, 27 Nov 2025 12:44:36 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1764276275; x=1764881075; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=AWSz7Oxvl5k3ho4hFT8nJ/15pZSdozyIVnJKK9qwc24=;
        b=IzposqnLi+uZ1GuGMvq6j47Q9MWfpdhfwF8BhpKXuQNtU83JHAoJPcJThacyDj/K1M
         0+wjuufXCYFVMcqVNJn36IP2Rco2SzdTPzS3zieqcBnZYvbCzkIwsErmIOmzg8mAGzLX
         OaQAGrumKU92Pe6nSq73J1HQkXSt0HbMpHfKMjlp8evgD8GUnuwOxiJ6/AaKPDlhnDoy
         If1pGX28Dn/Wf7yIhlhCXXEDDrswF2+q5qMHrnq5155lSJd7DHImmKpG2HqZht+XzKvh
         ORe+4AJOeaTKKzdbRTNul0Kyj6asumu2SIdBfMuBT/9Oca4GkPeiB2o//BwcrLx91yux
         XuiA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1764276275; x=1764881075;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to;
        bh=AWSz7Oxvl5k3ho4hFT8nJ/15pZSdozyIVnJKK9qwc24=;
        b=E4W3Fz3pU8tIT9joHihkn3iPeEBH50a+UDRIkMw7pNcJ+obRTUrSsXCATTOdNML1Dm
         QUXTxBLdk+gM8aUGddvdwE8aqfPBxanj8KOUt7O+HbjsO3XEUDkR2kfa90nqtvrnhANI
         3N50dnvjSKk0xfcYXE1h5CedVF1G0y6rkPVb3CgSr9KYnMNfDKwMO7WOOKLYmJc7xQlG
         VKbAAB8ws8NA9+Q9BupIoqdCsJqQh+7cHYnAWRMg9Ja0tS1ESHT+iy7gIToIkvEWErlc
         3rLUQGcB9om0LkCgPwhzfS4uKfy/Va/kHy1x2WQDcNnjRpmPJ/zN/7Eo1hIouYFhFdB0
         jzqg==
X-Forwarded-Encrypted: i=1; AJvYcCWqSioigz1/iSegT7M6xZqhCqdQz48qMw/qUbdvMs8bZMeaGGVLRwkI24fTkns0s9pQQ3/uk9SC4Q==@vger.kernel.org
X-Gm-Message-State: AOJu0YyqtRCBARGIdX1qxO+BKd6nPjK2zG2SV1uXEOWw66UP8yJMHg/e
	+Q7pZw/lNZZl53otwkgPacMsNqgPRCamqEjmWUVNmp+g6ZMYCnIDBtEP
X-Gm-Gg: ASbGncvqYCJTw1qtW38K4k1IQ6+Qd0H6g+tb7yaXTg74bz5f6IUTXrD2G165Wksgrjw
	slGfplinlaviSBMFYK82dxkxgIBziI0KZ1W+Ok3nMNjX+YJ+J5ctg9h4ytCpVIWZNgOOEgcrHs4
	Bo9fV37//MGhXe/aColQwaxiPumzs3yh9YAYoUVOdyrzXCZa6qojQq2dHhpkaa+0ZG2UPs+XD3b
	H9x7/FOBAjpUWxr6izyVEl9DNI1gFQ1QUbyeGs3jV/ZNiTJNWtz1A7hV98uEEzFUyudf0O060MP
	OnVBF4+oNzMJ9H478rqlnHphR2j7o410F7P5S2MpzL1DnXHf/5uQ0RIKkqvF+zYShXW67NdkcBT
	rcpgm5fUaATTgASmuT85cc/XHPdKr77ayxCAforJNxYc4mJMvsB5/F/sC1X9sUz3KlvOBqs0noG
	HJVz14qa3zREgCHg==
X-Google-Smtp-Source: AGHT+IG4ismn+GhR+5gvS889MPzZH1dMb9XaEixm7LXOsd3I9isJV3ogQv/TiaxRHtQ+ElithKQLlg==
X-Received: by 2002:a05:6000:2c11:b0:42b:3ee9:4776 with SMTP id ffacd0b85a97d-42cc1abe2bbmr26221291f8f.5.1764276274479;
        Thu, 27 Nov 2025 12:44:34 -0800 (PST)
Received: from 127.mynet ([2a01:4b00:bd21:4f00:7cc6:d3ca:494:116c])
        by smtp.gmail.com with ESMTPSA id ffacd0b85a97d-42e1c5d614asm5346105f8f.12.2025.11.27.12.44.33
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 27 Nov 2025 12:44:33 -0800 (PST)
From: Pavel Begunkov <asml.silence@gmail.com>
To: netdev@vger.kernel.org
Cc: "David S . Miller" <davem@davemloft.net>,
	Eric Dumazet <edumazet@google.com>,
	Jakub Kicinski <kuba@kernel.org>,
	Paolo Abeni <pabeni@redhat.com>,
	Jonathan Corbet <corbet@lwn.net>,
	Michael Chan <michael.chan@broadcom.com>,
	Pavan Chebbi <pavan.chebbi@broadcom.com>,
	Andrew Lunn <andrew+netdev@lunn.ch>,
	Ilias Apalodimas <ilias.apalodimas@linaro.org>,
	Stanislav Fomichev <sdf@fomichev.me>,
	Pavel Begunkov <asml.silence@gmail.com>,
	Jens Axboe <axboe@kernel.dk>,
	Simon Horman <horms@kernel.org>,
	linux-doc@vger.kernel.org,
	linux-kselftest@vger.kernel.org,
	io-uring@vger.kernel.org,
	dtatulea@nvidia.com
Subject: [PATCH net-next v6 4/8] eth: bnxt: store rx buffer size per queue
Date: Thu, 27 Nov 2025 20:44:17 +0000
Message-ID: <1245c7c7a30a79efbf05a8afbc5eb17913640b8d.1764264798.git.asml.silence@gmail.com>
X-Mailer: git-send-email 2.52.0
In-Reply-To: <cover.1764264798.git.asml.silence@gmail.com>
References: <cover.1764264798.git.asml.silence@gmail.com>
Precedence: bulk
X-Mailing-List: io-uring@vger.kernel.org
List-Id: <io-uring.vger.kernel.org>
List-Subscribe: <mailto:io-uring+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:io-uring+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

Instead of using a constant buffer length, allow configuring the size
for each queue separately. There is no way to change the length yet, and
it'll be passed from memory providers in a later patch.

Suggested-by: Jakub Kicinski <kuba@kernel.org>
Signed-off-by: Pavel Begunkov <asml.silence@gmail.com>
---
 drivers/net/ethernet/broadcom/bnxt/bnxt.c     | 56 +++++++++++--------
 drivers/net/ethernet/broadcom/bnxt/bnxt.h     |  1 +
 drivers/net/ethernet/broadcom/bnxt/bnxt_xdp.c |  6 +-
 drivers/net/ethernet/broadcom/bnxt/bnxt_xdp.h |  2 +-
 4 files changed, 38 insertions(+), 27 deletions(-)

diff --git a/drivers/net/ethernet/broadcom/bnxt/bnxt.c b/drivers/net/ethernet/broadcom/bnxt/bnxt.c
index a625e7c311dd..091da26fdf7c 100644
--- a/drivers/net/ethernet/broadcom/bnxt/bnxt.c
+++ b/drivers/net/ethernet/broadcom/bnxt/bnxt.c
@@ -905,7 +905,7 @@ static void bnxt_tx_int(struct bnxt *bp, struct bnxt_napi *bnapi, int budget)
 
 static bool bnxt_separate_head_pool(struct bnxt_rx_ring_info *rxr)
 {
-	return rxr->need_head_pool || PAGE_SIZE > BNXT_RX_PAGE_SIZE;
+	return rxr->need_head_pool || rxr->rx_page_size < PAGE_SIZE;
 }
 
 static struct page *__bnxt_alloc_rx_page(struct bnxt *bp, dma_addr_t *mapping,
@@ -915,9 +915,9 @@ static struct page *__bnxt_alloc_rx_page(struct bnxt *bp, dma_addr_t *mapping,
 {
 	struct page *page;
 
-	if (PAGE_SIZE > BNXT_RX_PAGE_SIZE) {
+	if (rxr->rx_page_size < PAGE_SIZE) {
 		page = page_pool_dev_alloc_frag(rxr->page_pool, offset,
-						BNXT_RX_PAGE_SIZE);
+						rxr->rx_page_size);
 	} else {
 		page = page_pool_dev_alloc_pages(rxr->page_pool);
 		*offset = 0;
@@ -936,8 +936,9 @@ static netmem_ref __bnxt_alloc_rx_netmem(struct bnxt *bp, dma_addr_t *mapping,
 {
 	netmem_ref netmem;
 
-	if (PAGE_SIZE > BNXT_RX_PAGE_SIZE) {
-		netmem = page_pool_alloc_frag_netmem(rxr->page_pool, offset, BNXT_RX_PAGE_SIZE, gfp);
+	if (rxr->rx_page_size < PAGE_SIZE) {
+		netmem = page_pool_alloc_frag_netmem(rxr->page_pool, offset,
+						     rxr->rx_page_size, gfp);
 	} else {
 		netmem = page_pool_alloc_netmems(rxr->page_pool, gfp);
 		*offset = 0;
@@ -1155,9 +1156,9 @@ static struct sk_buff *bnxt_rx_multi_page_skb(struct bnxt *bp,
 		return NULL;
 	}
 	dma_addr -= bp->rx_dma_offset;
-	dma_sync_single_for_cpu(&bp->pdev->dev, dma_addr, BNXT_RX_PAGE_SIZE,
+	dma_sync_single_for_cpu(&bp->pdev->dev, dma_addr, rxr->rx_page_size,
 				bp->rx_dir);
-	skb = napi_build_skb(data_ptr - bp->rx_offset, BNXT_RX_PAGE_SIZE);
+	skb = napi_build_skb(data_ptr - bp->rx_offset, rxr->rx_page_size);
 	if (!skb) {
 		page_pool_recycle_direct(rxr->page_pool, page);
 		return NULL;
@@ -1189,7 +1190,7 @@ static struct sk_buff *bnxt_rx_page_skb(struct bnxt *bp,
 		return NULL;
 	}
 	dma_addr -= bp->rx_dma_offset;
-	dma_sync_single_for_cpu(&bp->pdev->dev, dma_addr, BNXT_RX_PAGE_SIZE,
+	dma_sync_single_for_cpu(&bp->pdev->dev, dma_addr, rxr->rx_page_size,
 				bp->rx_dir);
 
 	if (unlikely(!payload))
@@ -1203,7 +1204,7 @@ static struct sk_buff *bnxt_rx_page_skb(struct bnxt *bp,
 
 	skb_mark_for_recycle(skb);
 	off = (void *)data_ptr - page_address(page);
-	skb_add_rx_frag(skb, 0, page, off, len, BNXT_RX_PAGE_SIZE);
+	skb_add_rx_frag(skb, 0, page, off, len, rxr->rx_page_size);
 	memcpy(skb->data - NET_IP_ALIGN, data_ptr - NET_IP_ALIGN,
 	       payload + NET_IP_ALIGN);
 
@@ -1288,7 +1289,7 @@ static u32 __bnxt_rx_agg_netmems(struct bnxt *bp,
 		if (skb) {
 			skb_add_rx_frag_netmem(skb, i, cons_rx_buf->netmem,
 					       cons_rx_buf->offset,
-					       frag_len, BNXT_RX_PAGE_SIZE);
+					       frag_len, rxr->rx_page_size);
 		} else {
 			skb_frag_t *frag = &shinfo->frags[i];
 
@@ -1313,7 +1314,7 @@ static u32 __bnxt_rx_agg_netmems(struct bnxt *bp,
 			if (skb) {
 				skb->len -= frag_len;
 				skb->data_len -= frag_len;
-				skb->truesize -= BNXT_RX_PAGE_SIZE;
+				skb->truesize -= rxr->rx_page_size;
 			}
 
 			--shinfo->nr_frags;
@@ -1328,7 +1329,7 @@ static u32 __bnxt_rx_agg_netmems(struct bnxt *bp,
 		}
 
 		page_pool_dma_sync_netmem_for_cpu(rxr->page_pool, netmem, 0,
-						  BNXT_RX_PAGE_SIZE);
+						  rxr->rx_page_size);
 
 		total_frag_len += frag_len;
 		prod = NEXT_RX_AGG(prod);
@@ -2281,8 +2282,7 @@ static int bnxt_rx_pkt(struct bnxt *bp, struct bnxt_cp_ring_info *cpr,
 			if (!skb)
 				goto oom_next_rx;
 		} else {
-			skb = bnxt_xdp_build_skb(bp, skb, agg_bufs,
-						 rxr->page_pool, &xdp);
+			skb = bnxt_xdp_build_skb(bp, skb, agg_bufs, rxr, &xdp);
 			if (!skb) {
 				/* we should be able to free the old skb here */
 				bnxt_xdp_buff_frags_free(rxr, &xdp);
@@ -3828,11 +3828,13 @@ static int bnxt_alloc_rx_page_pool(struct bnxt *bp,
 	pp.pool_size = bp->rx_agg_ring_size / agg_size_fac;
 	if (BNXT_RX_PAGE_MODE(bp))
 		pp.pool_size += bp->rx_ring_size / rx_size_fac;
+
+	pp.order = get_order(rxr->rx_page_size);
 	pp.nid = numa_node;
 	pp.netdev = bp->dev;
 	pp.dev = &bp->pdev->dev;
 	pp.dma_dir = bp->rx_dir;
-	pp.max_len = PAGE_SIZE;
+	pp.max_len = PAGE_SIZE << pp.order;
 	pp.flags = PP_FLAG_DMA_MAP | PP_FLAG_DMA_SYNC_DEV |
 		   PP_FLAG_ALLOW_UNREADABLE_NETMEM;
 	pp.queue_idx = rxr->bnapi->index;
@@ -3843,7 +3845,10 @@ static int bnxt_alloc_rx_page_pool(struct bnxt *bp,
 	rxr->page_pool = pool;
 
 	rxr->need_head_pool = page_pool_is_unreadable(pool);
+	rxr->need_head_pool |= !!pp.order;
 	if (bnxt_separate_head_pool(rxr)) {
+		pp.order = 0;
+		pp.max_len = PAGE_SIZE;
 		pp.pool_size = min(bp->rx_ring_size / rx_size_fac, 1024);
 		pp.flags = PP_FLAG_DMA_MAP | PP_FLAG_DMA_SYNC_DEV;
 		pool = page_pool_create(&pp);
@@ -4319,6 +4324,8 @@ static void bnxt_init_ring_struct(struct bnxt *bp)
 		if (!rxr)
 			goto skip_rx;
 
+		rxr->rx_page_size = BNXT_RX_PAGE_SIZE;
+
 		ring = &rxr->rx_ring_struct;
 		rmem = &ring->ring_mem;
 		rmem->nr_pages = bp->rx_nr_pages;
@@ -4478,7 +4485,7 @@ static void bnxt_init_one_rx_agg_ring_rxbd(struct bnxt *bp,
 	ring = &rxr->rx_agg_ring_struct;
 	ring->fw_ring_id = INVALID_HW_RING_ID;
 	if ((bp->flags & BNXT_FLAG_AGG_RINGS)) {
-		type = ((u32)BNXT_RX_PAGE_SIZE << RX_BD_LEN_SHIFT) |
+		type = ((u32)rxr->rx_page_size << RX_BD_LEN_SHIFT) |
 			RX_BD_TYPE_RX_AGG_BD | RX_BD_FLAGS_SOP;
 
 		bnxt_init_rxbd_pages(ring, type);
@@ -7045,6 +7052,7 @@ static void bnxt_hwrm_ring_grp_free(struct bnxt *bp)
 
 static void bnxt_set_rx_ring_params_p5(struct bnxt *bp, u32 ring_type,
 				       struct hwrm_ring_alloc_input *req,
+				       struct bnxt_rx_ring_info *rxr,
 				       struct bnxt_ring_struct *ring)
 {
 	struct bnxt_ring_grp_info *grp_info = &bp->grp_info[ring->grp_idx];
@@ -7054,7 +7062,7 @@ static void bnxt_set_rx_ring_params_p5(struct bnxt *bp, u32 ring_type,
 	if (ring_type == HWRM_RING_ALLOC_AGG) {
 		req->ring_type = RING_ALLOC_REQ_RING_TYPE_RX_AGG;
 		req->rx_ring_id = cpu_to_le16(grp_info->rx_fw_ring_id);
-		req->rx_buf_size = cpu_to_le16(BNXT_RX_PAGE_SIZE);
+		req->rx_buf_size = cpu_to_le16(rxr->rx_page_size);
 		enables |= RING_ALLOC_REQ_ENABLES_RX_RING_ID_VALID;
 	} else {
 		req->rx_buf_size = cpu_to_le16(bp->rx_buf_use_size);
@@ -7068,6 +7076,7 @@ static void bnxt_set_rx_ring_params_p5(struct bnxt *bp, u32 ring_type,
 }
 
 static int hwrm_ring_alloc_send_msg(struct bnxt *bp,
+				    struct bnxt_rx_ring_info *rxr,
 				    struct bnxt_ring_struct *ring,
 				    u32 ring_type, u32 map_index)
 {
@@ -7124,7 +7133,8 @@ static int hwrm_ring_alloc_send_msg(struct bnxt *bp,
 			      cpu_to_le32(bp->rx_ring_mask + 1) :
 			      cpu_to_le32(bp->rx_agg_ring_mask + 1);
 		if (bp->flags & BNXT_FLAG_CHIP_P5_PLUS)
-			bnxt_set_rx_ring_params_p5(bp, ring_type, req, ring);
+			bnxt_set_rx_ring_params_p5(bp, ring_type, req,
+						   rxr, ring);
 		break;
 	case HWRM_RING_ALLOC_CMPL:
 		req->ring_type = RING_ALLOC_REQ_RING_TYPE_L2_CMPL;
@@ -7272,7 +7282,7 @@ static int bnxt_hwrm_rx_ring_alloc(struct bnxt *bp,
 	u32 map_idx = bnapi->index;
 	int rc;
 
-	rc = hwrm_ring_alloc_send_msg(bp, ring, type, map_idx);
+	rc = hwrm_ring_alloc_send_msg(bp, rxr, ring, type, map_idx);
 	if (rc)
 		return rc;
 
@@ -7292,7 +7302,7 @@ static int bnxt_hwrm_rx_agg_ring_alloc(struct bnxt *bp,
 	int rc;
 
 	map_idx = grp_idx + bp->rx_nr_rings;
-	rc = hwrm_ring_alloc_send_msg(bp, ring, type, map_idx);
+	rc = hwrm_ring_alloc_send_msg(bp, rxr, ring, type, map_idx);
 	if (rc)
 		return rc;
 
@@ -7316,7 +7326,7 @@ static int bnxt_hwrm_cp_ring_alloc_p5(struct bnxt *bp,
 
 	ring = &cpr->cp_ring_struct;
 	ring->handle = BNXT_SET_NQ_HDL(cpr);
-	rc = hwrm_ring_alloc_send_msg(bp, ring, type, map_idx);
+	rc = hwrm_ring_alloc_send_msg(bp, NULL, ring, type, map_idx);
 	if (rc)
 		return rc;
 	bnxt_set_db(bp, &cpr->cp_db, type, map_idx, ring->fw_ring_id);
@@ -7331,7 +7341,7 @@ static int bnxt_hwrm_tx_ring_alloc(struct bnxt *bp,
 	const u32 type = HWRM_RING_ALLOC_TX;
 	int rc;
 
-	rc = hwrm_ring_alloc_send_msg(bp, ring, type, tx_idx);
+	rc = hwrm_ring_alloc_send_msg(bp, NULL, ring, type, tx_idx);
 	if (rc)
 		return rc;
 	bnxt_set_db(bp, &txr->tx_db, type, tx_idx, ring->fw_ring_id);
@@ -7357,7 +7367,7 @@ static int bnxt_hwrm_ring_alloc(struct bnxt *bp)
 
 		vector = bp->irq_tbl[map_idx].vector;
 		disable_irq_nosync(vector);
-		rc = hwrm_ring_alloc_send_msg(bp, ring, type, map_idx);
+		rc = hwrm_ring_alloc_send_msg(bp, NULL, ring, type, map_idx);
 		if (rc) {
 			enable_irq(vector);
 			goto err_out;
diff --git a/drivers/net/ethernet/broadcom/bnxt/bnxt.h b/drivers/net/ethernet/broadcom/bnxt/bnxt.h
index 3613a172483a..bfe36ea1e7c5 100644
--- a/drivers/net/ethernet/broadcom/bnxt/bnxt.h
+++ b/drivers/net/ethernet/broadcom/bnxt/bnxt.h
@@ -1106,6 +1106,7 @@ struct bnxt_rx_ring_info {
 
 	unsigned long		*rx_agg_bmap;
 	u16			rx_agg_bmap_size;
+	u16			rx_page_size;
 	bool                    need_head_pool;
 
 	dma_addr_t		rx_desc_mapping[MAX_RX_PAGES];
diff --git a/drivers/net/ethernet/broadcom/bnxt/bnxt_xdp.c b/drivers/net/ethernet/broadcom/bnxt/bnxt_xdp.c
index 3e77a96e5a3e..619235b151a4 100644
--- a/drivers/net/ethernet/broadcom/bnxt/bnxt_xdp.c
+++ b/drivers/net/ethernet/broadcom/bnxt/bnxt_xdp.c
@@ -183,7 +183,7 @@ void bnxt_xdp_buff_init(struct bnxt *bp, struct bnxt_rx_ring_info *rxr,
 			u16 cons, u8 *data_ptr, unsigned int len,
 			struct xdp_buff *xdp)
 {
-	u32 buflen = BNXT_RX_PAGE_SIZE;
+	u32 buflen = rxr->rx_page_size;
 	struct bnxt_sw_rx_bd *rx_buf;
 	struct pci_dev *pdev;
 	dma_addr_t mapping;
@@ -461,7 +461,7 @@ int bnxt_xdp(struct net_device *dev, struct netdev_bpf *xdp)
 
 struct sk_buff *
 bnxt_xdp_build_skb(struct bnxt *bp, struct sk_buff *skb, u8 num_frags,
-		   struct page_pool *pool, struct xdp_buff *xdp)
+		   struct bnxt_rx_ring_info *rxr, struct xdp_buff *xdp)
 {
 	struct skb_shared_info *sinfo = xdp_get_shared_info_from_buff(xdp);
 
@@ -469,7 +469,7 @@ bnxt_xdp_build_skb(struct bnxt *bp, struct sk_buff *skb, u8 num_frags,
 		return NULL;
 
 	xdp_update_skb_frags_info(skb, num_frags, sinfo->xdp_frags_size,
-				  BNXT_RX_PAGE_SIZE * num_frags,
+				  rxr->rx_page_size * num_frags,
 				  xdp_buff_get_skb_flags(xdp));
 	return skb;
 }
diff --git a/drivers/net/ethernet/broadcom/bnxt/bnxt_xdp.h b/drivers/net/ethernet/broadcom/bnxt/bnxt_xdp.h
index 220285e190fc..8933a0dec09a 100644
--- a/drivers/net/ethernet/broadcom/bnxt/bnxt_xdp.h
+++ b/drivers/net/ethernet/broadcom/bnxt/bnxt_xdp.h
@@ -32,6 +32,6 @@ void bnxt_xdp_buff_init(struct bnxt *bp, struct bnxt_rx_ring_info *rxr,
 void bnxt_xdp_buff_frags_free(struct bnxt_rx_ring_info *rxr,
 			      struct xdp_buff *xdp);
 struct sk_buff *bnxt_xdp_build_skb(struct bnxt *bp, struct sk_buff *skb,
-				   u8 num_frags, struct page_pool *pool,
+				   u8 num_frags, struct bnxt_rx_ring_info *rxr,
 				   struct xdp_buff *xdp);
 #endif
-- 
2.52.0


