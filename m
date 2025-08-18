Return-Path: <io-uring+bounces-9021-lists+io-uring=lfdr.de@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from sy.mirrors.kernel.org (sy.mirrors.kernel.org [147.75.48.161])
	by mail.lfdr.de (Postfix) with ESMTPS id DFCD9B2A803
	for <lists+io-uring@lfdr.de>; Mon, 18 Aug 2025 15:59:02 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sy.mirrors.kernel.org (Postfix) with ESMTPS id E5B097ABF55
	for <lists+io-uring@lfdr.de>; Mon, 18 Aug 2025 13:57:20 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 03780322A08;
	Mon, 18 Aug 2025 13:56:47 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="FosrnFtC"
X-Original-To: io-uring@vger.kernel.org
Received: from mail-wm1-f46.google.com (mail-wm1-f46.google.com [209.85.128.46])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id F2501279351;
	Mon, 18 Aug 2025 13:56:44 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.128.46
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1755525406; cv=none; b=W/sq1iGI25SABbwfoab/E/tlS2KXaCZ9e0KlJ+IFFWRWCfaihUehRA9hWzeew2rwxvuVA1ZXyDGhTDHwQs+W4Nwd7NX/RcsW5KN833+WTqF/6oNEJuKbmqLoxFw37WneB8fTI6n12feOlyEM3ggMoziVkHCF/0AUdBOHhtDbFEg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1755525406; c=relaxed/simple;
	bh=CgnCS789qvKVwzwumupDp5m+5OOfkM3ifrvTrILtyKk=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=Uu0Rm/U3leqHX+0NW3wbmtFszESByR+CYMxA03pjmuyV8PLlp5ZVDXT7THY2JtayXQ9pH0hv931NRA7xeSkghGSrAc3TQZm567S7VLN5hpz+N0gNbCj+f1H6QHT8d0rRBlpxaOjALD+oV0yge99nXSCo3DDgqtjvjZr6ZOSxeX8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=FosrnFtC; arc=none smtp.client-ip=209.85.128.46
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Received: by mail-wm1-f46.google.com with SMTP id 5b1f17b1804b1-45a1b004954so29732755e9.0;
        Mon, 18 Aug 2025 06:56:44 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1755525403; x=1756130203; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=7O2qpU61yLG+Mk1UKSRopcAs3GQir6McvQEEMmetOFw=;
        b=FosrnFtCWD2IuETHIG+neMzKbeJ/QuQbB0mKwo26ETt8HOfZQg6jNSLeah+Z7W0k1N
         x5GFufqrkqOsA6sGAiUU4F+62PHlDwsNIPCE0ZuYFtbbRk18+U5yt6IyL1n6LrXHsjqo
         lGuapsmQe5wGajQJK39fRS8toDKed3lGka2xwuRNX+7iY0r3YPVGhBjyY65NElL11Hbz
         GMsooNFAYSrwEfseMPe+1HD7piI0tUt3OMcsJ8r+xcTgek0B36NgXcD9yBVrMrVieKeb
         F4VLREP4ICDndtB78h7kDAcLlChxBa0Q+8SHuFRpj5OxkFdcb+/HAvJp/pIIuJdRVPZi
         jSKw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1755525403; x=1756130203;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=7O2qpU61yLG+Mk1UKSRopcAs3GQir6McvQEEMmetOFw=;
        b=FUiC1xXwAIrizkSq2Y+ndlAwL5gHHGOJkYFIrcQ7rRE2STWm//c2q4yNuACTEMDy/T
         cumBxjkiBIYCcp1po9hNh6MrHG8cTa9Sg3wU7GntsTv63csQg0JlL/nuLyklDlqCEvZl
         S0cdlp/5NIk5TXLyZXivWKV67q6WzCQRKhzeXpPK/HF0kEvePVbk/Fqr7Bvu4Ghzbrtz
         E5/yXTBVZphMhPEIaOE3EqkXLcZVWTj7o12IKjLGzE96jkUbHMK+5PWKEek+TyMCZGE9
         AiBnF8Y8ItzqkTQ33Dro+wmGucoNYn3487o5Qaqxd340sx9ehwrF9tLugZQOCG63CFBo
         21tQ==
X-Forwarded-Encrypted: i=1; AJvYcCUAWPyXL79xPg/ISaxb7jbjB/Rt/gn8VZsVCQguFhef5i947QgCGVUECf0OpQBGqyGHTS8z6K08@vger.kernel.org, AJvYcCVJ+/ypv92J0kguy2hJcNfv/wWDdm7tXjwG3o43zMzyF7q610wYW+KuwBeb8M0BqvMepPU7bYIRdQ==@vger.kernel.org, AJvYcCXrg+QHjGK2kcqiEtcVjgkP/gjuy9v6RODpkRJ+rl4pd9Ab26ejcbxxQiUGvwFhd3xARAlDIqSIsyKl9oJj@vger.kernel.org
X-Gm-Message-State: AOJu0YyylR+xXSwSbagG2ettVh8kT42PzqjwozgkSzZIo4nHyOLc3Ucp
	3UmRm+I8PGAURpZne6ziQXXH7igKaPkoZdcHEma8b8rIRUZFnBG6ALwF
X-Gm-Gg: ASbGncuoFbfKi4Zzr/INXs1RC0QiRPri4DNGGTBhiQgxbx7qRYQD2/LxLia6jcm8LEx
	nE85DxQTF9hn4NZnpTx4ZEDQNCJkh8vWWLeEfORtJOBms0QNKZCaN7HhNC3zBPYz4pfN+1TA34k
	iTCE2/JvzujnhyD6fgQq1o+ReLjcUl5UP9/iW6GqPWfu4CWc4gsdDcWSiuqKpctGaqLtFFwth7E
	UMP7ZDUH/7xyAdA6T0jzR2drTRw4g+OTUA5QTACxJzjmnzl262so2Xl8G4VJBKeAdNLVkNR2Z2B
	sJyEeBN2OqlOEdGpYqoS96cqkVHZntOZ4i4SqQVeJu0iGwTvx7LqmLNnT/0kAeci+aZoDup9PeY
	Om6l5ViTXW3i/batiqF47Q7ulwjjxdPTjWw==
X-Google-Smtp-Source: AGHT+IG1e9ou+R7/TQ91yRS1rz1AyimiJdrMTabVI/BDwjSt/EF2gC8/NB+92Jrt8A/prcv/uXS+Jg==
X-Received: by 2002:a05:600c:46c6:b0:458:a7b5:9f6c with SMTP id 5b1f17b1804b1-45a26744554mr73348105e9.11.1755525403041;
        Mon, 18 Aug 2025 06:56:43 -0700 (PDT)
Received: from 127.0.0.1localhost ([185.69.144.43])
        by smtp.gmail.com with ESMTPSA id 5b1f17b1804b1-45a1b899338sm91187345e9.7.2025.08.18.06.56.41
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 18 Aug 2025 06:56:42 -0700 (PDT)
From: Pavel Begunkov <asml.silence@gmail.com>
To: Jakub Kicinski <kuba@kernel.org>,
	netdev@vger.kernel.org
Cc: asml.silence@gmail.com,
	Eric Dumazet <edumazet@google.com>,
	Willem de Bruijn <willemb@google.com>,
	Paolo Abeni <pabeni@redhat.com>,
	andrew+netdev@lunn.ch,
	horms@kernel.org,
	davem@davemloft.net,
	sdf@fomichev.me,
	almasrymina@google.com,
	dw@davidwei.uk,
	michael.chan@broadcom.com,
	dtatulea@nvidia.com,
	ap420073@gmail.com,
	linux-kernel@vger.kernel.org,
	io-uring@vger.kernel.org
Subject: [PATCH net-next v3 07/23] eth: bnxt: read the page size from the adapter struct
Date: Mon, 18 Aug 2025 14:57:23 +0100
Message-ID: <43a256bdc70e9a0201f25e60305516aed6b1e97c.1755499376.git.asml.silence@gmail.com>
X-Mailer: git-send-email 2.49.0
In-Reply-To: <cover.1755499375.git.asml.silence@gmail.com>
References: <cover.1755499375.git.asml.silence@gmail.com>
Precedence: bulk
X-Mailing-List: io-uring@vger.kernel.org
List-Id: <io-uring.vger.kernel.org>
List-Subscribe: <mailto:io-uring+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:io-uring+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

From: Jakub Kicinski <kuba@kernel.org>

Switch from using a constant to storing the BNXT_RX_PAGE_SIZE
inside struct bnxt. This will allow configuring the page size
at runtime in subsequent patches.

The MSS size calculation for older chip continues to use the constant.
I'm intending to support the configuration only on more recent HW,
looks like on older chips setting this per queue won't work,
and that's the ultimate goal.

This patch should not change the current behavior as value
read from the struct will always be BNXT_RX_PAGE_SIZE at this stage.

Signed-off-by: Jakub Kicinski <kuba@kernel.org>
Signed-off-by: Pavel Begunkov <asml.silence@gmail.com>
---
 drivers/net/ethernet/broadcom/bnxt/bnxt.c     | 27 ++++++++++---------
 drivers/net/ethernet/broadcom/bnxt/bnxt.h     |  1 +
 drivers/net/ethernet/broadcom/bnxt/bnxt_xdp.c |  4 +--
 3 files changed, 17 insertions(+), 15 deletions(-)

diff --git a/drivers/net/ethernet/broadcom/bnxt/bnxt.c b/drivers/net/ethernet/broadcom/bnxt/bnxt.c
index 2800a90fba1f..5307b33ea1c7 100644
--- a/drivers/net/ethernet/broadcom/bnxt/bnxt.c
+++ b/drivers/net/ethernet/broadcom/bnxt/bnxt.c
@@ -900,7 +900,7 @@ static void bnxt_tx_int(struct bnxt *bp, struct bnxt_napi *bnapi, int budget)
 
 static bool bnxt_separate_head_pool(struct bnxt_rx_ring_info *rxr)
 {
-	return rxr->need_head_pool || PAGE_SIZE > BNXT_RX_PAGE_SIZE;
+	return rxr->need_head_pool || PAGE_SIZE > rxr->bnapi->bp->rx_page_size;
 }
 
 static struct page *__bnxt_alloc_rx_page(struct bnxt *bp, dma_addr_t *mapping,
@@ -910,9 +910,9 @@ static struct page *__bnxt_alloc_rx_page(struct bnxt *bp, dma_addr_t *mapping,
 {
 	struct page *page;
 
-	if (PAGE_SIZE > BNXT_RX_PAGE_SIZE) {
+	if (PAGE_SIZE > bp->rx_page_size) {
 		page = page_pool_dev_alloc_frag(rxr->page_pool, offset,
-						BNXT_RX_PAGE_SIZE);
+						bp->rx_page_size);
 	} else {
 		page = page_pool_dev_alloc_pages(rxr->page_pool);
 		*offset = 0;
@@ -1150,9 +1150,9 @@ static struct sk_buff *bnxt_rx_multi_page_skb(struct bnxt *bp,
 		return NULL;
 	}
 	dma_addr -= bp->rx_dma_offset;
-	dma_sync_single_for_cpu(&bp->pdev->dev, dma_addr, BNXT_RX_PAGE_SIZE,
+	dma_sync_single_for_cpu(&bp->pdev->dev, dma_addr, bp->rx_page_size,
 				bp->rx_dir);
-	skb = napi_build_skb(data_ptr - bp->rx_offset, BNXT_RX_PAGE_SIZE);
+	skb = napi_build_skb(data_ptr - bp->rx_offset, bp->rx_page_size);
 	if (!skb) {
 		page_pool_recycle_direct(rxr->page_pool, page);
 		return NULL;
@@ -1184,7 +1184,7 @@ static struct sk_buff *bnxt_rx_page_skb(struct bnxt *bp,
 		return NULL;
 	}
 	dma_addr -= bp->rx_dma_offset;
-	dma_sync_single_for_cpu(&bp->pdev->dev, dma_addr, BNXT_RX_PAGE_SIZE,
+	dma_sync_single_for_cpu(&bp->pdev->dev, dma_addr, bp->rx_page_size,
 				bp->rx_dir);
 
 	if (unlikely(!payload))
@@ -1198,7 +1198,7 @@ static struct sk_buff *bnxt_rx_page_skb(struct bnxt *bp,
 
 	skb_mark_for_recycle(skb);
 	off = (void *)data_ptr - page_address(page);
-	skb_add_rx_frag(skb, 0, page, off, len, BNXT_RX_PAGE_SIZE);
+	skb_add_rx_frag(skb, 0, page, off, len, bp->rx_page_size);
 	memcpy(skb->data - NET_IP_ALIGN, data_ptr - NET_IP_ALIGN,
 	       payload + NET_IP_ALIGN);
 
@@ -1283,7 +1283,7 @@ static u32 __bnxt_rx_agg_netmems(struct bnxt *bp,
 		if (skb) {
 			skb_add_rx_frag_netmem(skb, i, cons_rx_buf->netmem,
 					       cons_rx_buf->offset,
-					       frag_len, BNXT_RX_PAGE_SIZE);
+					       frag_len, bp->rx_page_size);
 		} else {
 			skb_frag_t *frag = &shinfo->frags[i];
 
@@ -1308,7 +1308,7 @@ static u32 __bnxt_rx_agg_netmems(struct bnxt *bp,
 			if (skb) {
 				skb->len -= frag_len;
 				skb->data_len -= frag_len;
-				skb->truesize -= BNXT_RX_PAGE_SIZE;
+				skb->truesize -= bp->rx_page_size;
 			}
 
 			--shinfo->nr_frags;
@@ -1323,7 +1323,7 @@ static u32 __bnxt_rx_agg_netmems(struct bnxt *bp,
 		}
 
 		page_pool_dma_sync_netmem_for_cpu(rxr->page_pool, netmem, 0,
-						  BNXT_RX_PAGE_SIZE);
+						  bp->rx_page_size);
 
 		total_frag_len += frag_len;
 		prod = NEXT_RX_AGG(prod);
@@ -4472,7 +4472,7 @@ static void bnxt_init_one_rx_agg_ring_rxbd(struct bnxt *bp,
 	ring = &rxr->rx_agg_ring_struct;
 	ring->fw_ring_id = INVALID_HW_RING_ID;
 	if ((bp->flags & BNXT_FLAG_AGG_RINGS)) {
-		type = ((u32)BNXT_RX_PAGE_SIZE << RX_BD_LEN_SHIFT) |
+		type = ((u32)bp->rx_page_size << RX_BD_LEN_SHIFT) |
 			RX_BD_TYPE_RX_AGG_BD | RX_BD_FLAGS_SOP;
 
 		bnxt_init_rxbd_pages(ring, type);
@@ -4734,7 +4734,7 @@ void bnxt_set_ring_params(struct bnxt *bp)
 	bp->rx_agg_nr_pages = 0;
 
 	if (bp->flags & BNXT_FLAG_TPA || bp->flags & BNXT_FLAG_HDS)
-		agg_factor = min_t(u32, 4, 65536 / BNXT_RX_PAGE_SIZE);
+		agg_factor = min_t(u32, 4, 65536 / bp->rx_page_size);
 
 	bp->flags &= ~BNXT_FLAG_JUMBO;
 	if (rx_space > PAGE_SIZE && !(bp->flags & BNXT_FLAG_NO_AGG_RINGS)) {
@@ -7046,7 +7046,7 @@ static void bnxt_set_rx_ring_params_p5(struct bnxt *bp, u32 ring_type,
 	if (ring_type == HWRM_RING_ALLOC_AGG) {
 		req->ring_type = RING_ALLOC_REQ_RING_TYPE_RX_AGG;
 		req->rx_ring_id = cpu_to_le16(grp_info->rx_fw_ring_id);
-		req->rx_buf_size = cpu_to_le16(BNXT_RX_PAGE_SIZE);
+		req->rx_buf_size = cpu_to_le16(bp->rx_page_size);
 		enables |= RING_ALLOC_REQ_ENABLES_RX_RING_ID_VALID;
 	} else {
 		req->rx_buf_size = cpu_to_le16(bp->rx_buf_use_size);
@@ -16576,6 +16576,7 @@ static int bnxt_init_one(struct pci_dev *pdev, const struct pci_device_id *ent)
 	bp = netdev_priv(dev);
 	bp->board_idx = ent->driver_data;
 	bp->msg_enable = BNXT_DEF_MSG_ENABLE;
+	bp->rx_page_size = BNXT_RX_PAGE_SIZE;
 	bnxt_set_max_func_irqs(bp, max_irqs);
 
 	if (bnxt_vf_pciid(bp->board_idx))
diff --git a/drivers/net/ethernet/broadcom/bnxt/bnxt.h b/drivers/net/ethernet/broadcom/bnxt/bnxt.h
index fda0d3cc6227..ac841d02d7ad 100644
--- a/drivers/net/ethernet/broadcom/bnxt/bnxt.h
+++ b/drivers/net/ethernet/broadcom/bnxt/bnxt.h
@@ -2358,6 +2358,7 @@ struct bnxt {
 	u16			max_tpa;
 	u32			rx_buf_size;
 	u32			rx_buf_use_size;	/* useable size */
+	u16			rx_page_size;
 	u16			rx_offset;
 	u16			rx_dma_offset;
 	enum dma_data_direction	rx_dir;
diff --git a/drivers/net/ethernet/broadcom/bnxt/bnxt_xdp.c b/drivers/net/ethernet/broadcom/bnxt/bnxt_xdp.c
index 58d579dca3f1..41d3ba56ba41 100644
--- a/drivers/net/ethernet/broadcom/bnxt/bnxt_xdp.c
+++ b/drivers/net/ethernet/broadcom/bnxt/bnxt_xdp.c
@@ -183,7 +183,7 @@ void bnxt_xdp_buff_init(struct bnxt *bp, struct bnxt_rx_ring_info *rxr,
 			u16 cons, u8 *data_ptr, unsigned int len,
 			struct xdp_buff *xdp)
 {
-	u32 buflen = BNXT_RX_PAGE_SIZE;
+	u32 buflen = bp->rx_page_size;
 	struct bnxt_sw_rx_bd *rx_buf;
 	struct pci_dev *pdev;
 	dma_addr_t mapping;
@@ -470,7 +470,7 @@ bnxt_xdp_build_skb(struct bnxt *bp, struct sk_buff *skb, u8 num_frags,
 
 	xdp_update_skb_shared_info(skb, num_frags,
 				   sinfo->xdp_frags_size,
-				   BNXT_RX_PAGE_SIZE * num_frags,
+				   bp->rx_page_size * num_frags,
 				   xdp_buff_is_frag_pfmemalloc(xdp));
 	return skb;
 }
-- 
2.49.0


