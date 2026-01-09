Return-Path: <io-uring+bounces-11564-lists+io-uring=lfdr.de@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from tor.lore.kernel.org (tor.lore.kernel.org [IPv6:2600:3c04:e001:36c::12fc:5321])
	by mail.lfdr.de (Postfix) with ESMTPS id 7BD5FD08E58
	for <lists+io-uring@lfdr.de>; Fri, 09 Jan 2026 12:30:31 +0100 (CET)
Received: from smtp.subspace.kernel.org (conduit.subspace.kernel.org [100.90.174.1])
	by tor.lore.kernel.org (Postfix) with ESMTP id 1D89A304F645
	for <lists+io-uring@lfdr.de>; Fri,  9 Jan 2026 11:29:33 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 118D635B143;
	Fri,  9 Jan 2026 11:29:16 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="JVLwpLVH"
X-Original-To: io-uring@vger.kernel.org
Received: from mail-wm1-f41.google.com (mail-wm1-f41.google.com [209.85.128.41])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C89C735A927
	for <io-uring@vger.kernel.org>; Fri,  9 Jan 2026 11:29:10 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.128.41
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1767958155; cv=none; b=k1ZJ6SJ9233VwYd3yCWtIffk1mpW8J5KJ/efjycm1yNIpKWjYU2Z0R9rVdzExZOR0+oCJiq8cJ38V2CGuIlHV0Nv/0v6cYbVpJBMHvR9YLXS70Pu/DViczko5m6cyjX4cA6Uc3nINRdFfxVfejuiIGlligG+kqPxKO/cZ7e3ieQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1767958155; c=relaxed/simple;
	bh=QZXEA2+NYMD7lIXsZ2nJV6uQaLTc157QE8KSkpAr83g=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=EOY5VknJz5A5rOHi3oJn/coQ/daYG/zRKVUQVXkDbgHjE2xMVBuUUVB/dXaCEt95XSOwI5b7xOamH5cxdeZ31wDTSUqIBbGwHy400xCBET2QVaaMm+MvokLaHrvA9X2Rp5X0CASdotF1LN8DYpNw5lmKGaLwVLAXLHpgO6sDMAo=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=JVLwpLVH; arc=none smtp.client-ip=209.85.128.41
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Received: by mail-wm1-f41.google.com with SMTP id 5b1f17b1804b1-47d59da3d81so14008135e9.0
        for <io-uring@vger.kernel.org>; Fri, 09 Jan 2026 03:29:10 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1767958148; x=1768562948; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=nZD5Wx1jyZXUWe5yKYezCw7KRgK+3rTGuK1KYHQq5VM=;
        b=JVLwpLVHuBi7ybwLaq1H6ZGCcHvwRcgM4c5hYLnGZpLo/cWv7bx/eAYBv12z5zP1fP
         WoScqF4zYl6NcNET1aCkG0hmoCNF+ab4SGGJodg1ixCmdq84tOkWwjCCHsyNBQM8IPu0
         w8czIfufXohhSd3FQ2pQ7TDfZZG+VZ2hD9qg0LHriluIcaO4vPcAZ2T+Dt2tJCRdYyxA
         gK/+DTf4odgXJRqadja4+iPhhbvjlbwZIpQxDP39e2RGW6/r8qpb6vFptYx3GIa+DajR
         Jl1Qf6b/mCJVnLhvzEray0QA/OcOD+20NFTJtAvBEVLZ4AQ2cQPZRNkdHbkWxmeUXWDR
         m1pg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1767958148; x=1768562948;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to;
        bh=nZD5Wx1jyZXUWe5yKYezCw7KRgK+3rTGuK1KYHQq5VM=;
        b=NjTGcA7iCQfT7Mimz4a7v5sogLSe+B3/O+HQobpcAz5H2FQ8t+Jpzgxnq0ZJYTG9Sk
         Ay7J7pRE6JoAhncLR/T8cn4w4pViBDA4t38nOqvTzXrZwtwYfAvJ5+4ipo6e+FaRORm3
         oHLCqBlJybtJlEagbuYU4rxDFHoaVsZvw4qyyKHJjR/KUXrgqvzgYP9obHIXx99lbrvu
         E0AydugDCZnjuHs3PizF7YdhgstIxGYU91UEZV9Q5beOUCF8fQKNYmefLGixxhm8EZb7
         erAhOp1dfIdNBT6J8J4XvHerFmlDQBCbub13DLHHiou3V3GGhYDgaB11ieS8nNWofnWK
         xGzg==
X-Forwarded-Encrypted: i=1; AJvYcCW0iNOjnSoAPm5Ikdm+ySxsgEFAoENQhc0CHOkJvXVlFr+VORjotKbXe/BzREXBC4uDP4/HnqrjeA==@vger.kernel.org
X-Gm-Message-State: AOJu0YyUIaXiChFNBF3mC7zBzVqYPxRb4ObQoyKMGqwlLSbr4MEIv5Hm
	VhkfLxUS3mGEfbN0moD1DrHkOWlKC8RF7KVkZEtthkrKjFRuFS75/boL
X-Gm-Gg: AY/fxX7Tjeu+ZSSotH/a3HDpkPlLlJgMrWom4Et5aDGZCONFy6ZtNtlU5aR7iAhzMnJ
	yEeHcqz9pagyHd3fU7XmNgSkDFyqF/HbX66BUe16ozHS2RrqtQ/5eJX7Esp07hu6+TAMt3rJq7c
	0Y6SxUn/mR1IbQlXwCSb6UysSacDztSAv7YXGJeh++L9aC0pPUjq9+eD60vIG+MCl4v1h22KrJN
	8xMarp/J+ne/VwXvH4FBYcUEvLTirxq8OzSjh8ctI9dCl8UCFRfUqYp/t99UkWj2K9dvFbyDwWD
	3XWXbTKbwzJohV5vZgvUGi/i7H20emfhE4MGaUj7peVsZx6DLCOjiA19PI9iMbY/fNdDLEV233y
	Qlu4JlIivQxMt+M4C3hcxpM26xAMM5OU3gg1FyAWNhPmItg/vW3WjEp/+6Ab8MwKRF1uJ4/uwsU
	7N8El7+JHdHjMdOE+TH7Dw+RvOMEo2TOJ9HBdZv9mA/C8+Mhy0bqSaEJf4li/VkQ4KRlgBwQ==
X-Google-Smtp-Source: AGHT+IFCZxx8Wr/pDbni51TxgkC0jyiIt2gDlEMICKp850CkohI8JdFYYguYo7ByEs5Bde0EWv+Mdw==
X-Received: by 2002:a05:600c:8b37:b0:47d:333d:99c with SMTP id 5b1f17b1804b1-47d84881c77mr97821025e9.18.1767958147570;
        Fri, 09 Jan 2026 03:29:07 -0800 (PST)
Received: from 127.com ([2620:10d:c092:600::1:69b5])
        by smtp.gmail.com with ESMTPSA id 5b1f17b1804b1-47d8636c610sm60056985e9.0.2026.01.09.03.29.05
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 09 Jan 2026 03:29:06 -0800 (PST)
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
	Alexei Starovoitov <ast@kernel.org>,
	Daniel Borkmann <daniel@iogearbox.net>,
	Jesper Dangaard Brouer <hawk@kernel.org>,
	John Fastabend <john.fastabend@gmail.com>,
	Joshua Washington <joshwash@google.com>,
	Harshitha Ramamurthy <hramamurthy@google.com>,
	Saeed Mahameed <saeedm@nvidia.com>,
	Tariq Toukan <tariqt@nvidia.com>,
	Mark Bloch <mbloch@nvidia.com>,
	Leon Romanovsky <leon@kernel.org>,
	Alexander Duyck <alexanderduyck@fb.com>,
	Ilias Apalodimas <ilias.apalodimas@linaro.org>,
	Shuah Khan <shuah@kernel.org>,
	Willem de Bruijn <willemb@google.com>,
	Ankit Garg <nktgrg@google.com>,
	Tim Hostetler <thostet@google.com>,
	Alok Tiwari <alok.a.tiwari@oracle.com>,
	Ziwei Xiao <ziweixiao@google.com>,
	John Fraker <jfraker@google.com>,
	Praveen Kaligineedi <pkaligineedi@google.com>,
	Mohsin Bashir <mohsin.bashr@gmail.com>,
	Joe Damato <joe@dama.to>,
	Mina Almasry <almasrymina@google.com>,
	Dimitri Daskalakis <dimitri.daskalakis1@gmail.com>,
	Stanislav Fomichev <sdf@fomichev.me>,
	Kuniyuki Iwashima <kuniyu@google.com>,
	Samiullah Khawaja <skhawaja@google.com>,
	Ahmed Zaki <ahmed.zaki@intel.com>,
	Alexander Lobakin <aleksander.lobakin@intel.com>,
	Pavel Begunkov <asml.silence@gmail.com>,
	David Wei <dw@davidwei.uk>,
	Yue Haibing <yuehaibing@huawei.com>,
	Haiyue Wang <haiyuewa@163.com>,
	Jens Axboe <axboe@kernel.dk>,
	Simon Horman <horms@kernel.org>,
	Vishwanath Seshagiri <vishs@fb.com>,
	linux-doc@vger.kernel.org,
	linux-kernel@vger.kernel.org,
	bpf@vger.kernel.org,
	linux-rdma@vger.kernel.org,
	linux-kselftest@vger.kernel.org,
	dtatulea@nvidia.com,
	io-uring@vger.kernel.org
Subject: [PATCH net-next v8 5/9] eth: bnxt: store rx buffer size per queue
Date: Fri,  9 Jan 2026 11:28:44 +0000
Message-ID: <e01023029e10a8ff72b5d85cb15e7863b3613ff4.1767819709.git.asml.silence@gmail.com>
X-Mailer: git-send-email 2.52.0
In-Reply-To: <cover.1767819709.git.asml.silence@gmail.com>
References: <cover.1767819709.git.asml.silence@gmail.com>
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
index 73f954da39b9..8f42885a7c86 100644
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
+		type = ((u32)(u32)rxr->rx_page_size << RX_BD_LEN_SHIFT) |
 			RX_BD_TYPE_RX_AGG_BD;
 
 		/* On P7, setting EOP will cause the chip to disable
@@ -7056,6 +7063,7 @@ static void bnxt_hwrm_ring_grp_free(struct bnxt *bp)
 
 static void bnxt_set_rx_ring_params_p5(struct bnxt *bp, u32 ring_type,
 				       struct hwrm_ring_alloc_input *req,
+				       struct bnxt_rx_ring_info *rxr,
 				       struct bnxt_ring_struct *ring)
 {
 	struct bnxt_ring_grp_info *grp_info = &bp->grp_info[ring->grp_idx];
@@ -7065,7 +7073,7 @@ static void bnxt_set_rx_ring_params_p5(struct bnxt *bp, u32 ring_type,
 	if (ring_type == HWRM_RING_ALLOC_AGG) {
 		req->ring_type = RING_ALLOC_REQ_RING_TYPE_RX_AGG;
 		req->rx_ring_id = cpu_to_le16(grp_info->rx_fw_ring_id);
-		req->rx_buf_size = cpu_to_le16(BNXT_RX_PAGE_SIZE);
+		req->rx_buf_size = cpu_to_le16(rxr->rx_page_size);
 		enables |= RING_ALLOC_REQ_ENABLES_RX_RING_ID_VALID;
 	} else {
 		req->rx_buf_size = cpu_to_le16(bp->rx_buf_use_size);
@@ -7079,6 +7087,7 @@ static void bnxt_set_rx_ring_params_p5(struct bnxt *bp, u32 ring_type,
 }
 
 static int hwrm_ring_alloc_send_msg(struct bnxt *bp,
+				    struct bnxt_rx_ring_info *rxr,
 				    struct bnxt_ring_struct *ring,
 				    u32 ring_type, u32 map_index)
 {
@@ -7135,7 +7144,8 @@ static int hwrm_ring_alloc_send_msg(struct bnxt *bp,
 			      cpu_to_le32(bp->rx_ring_mask + 1) :
 			      cpu_to_le32(bp->rx_agg_ring_mask + 1);
 		if (bp->flags & BNXT_FLAG_CHIP_P5_PLUS)
-			bnxt_set_rx_ring_params_p5(bp, ring_type, req, ring);
+			bnxt_set_rx_ring_params_p5(bp, ring_type, req,
+						   rxr, ring);
 		break;
 	case HWRM_RING_ALLOC_CMPL:
 		req->ring_type = RING_ALLOC_REQ_RING_TYPE_L2_CMPL;
@@ -7283,7 +7293,7 @@ static int bnxt_hwrm_rx_ring_alloc(struct bnxt *bp,
 	u32 map_idx = bnapi->index;
 	int rc;
 
-	rc = hwrm_ring_alloc_send_msg(bp, ring, type, map_idx);
+	rc = hwrm_ring_alloc_send_msg(bp, rxr, ring, type, map_idx);
 	if (rc)
 		return rc;
 
@@ -7303,7 +7313,7 @@ static int bnxt_hwrm_rx_agg_ring_alloc(struct bnxt *bp,
 	int rc;
 
 	map_idx = grp_idx + bp->rx_nr_rings;
-	rc = hwrm_ring_alloc_send_msg(bp, ring, type, map_idx);
+	rc = hwrm_ring_alloc_send_msg(bp, rxr, ring, type, map_idx);
 	if (rc)
 		return rc;
 
@@ -7327,7 +7337,7 @@ static int bnxt_hwrm_cp_ring_alloc_p5(struct bnxt *bp,
 
 	ring = &cpr->cp_ring_struct;
 	ring->handle = BNXT_SET_NQ_HDL(cpr);
-	rc = hwrm_ring_alloc_send_msg(bp, ring, type, map_idx);
+	rc = hwrm_ring_alloc_send_msg(bp, NULL, ring, type, map_idx);
 	if (rc)
 		return rc;
 	bnxt_set_db(bp, &cpr->cp_db, type, map_idx, ring->fw_ring_id);
@@ -7342,7 +7352,7 @@ static int bnxt_hwrm_tx_ring_alloc(struct bnxt *bp,
 	const u32 type = HWRM_RING_ALLOC_TX;
 	int rc;
 
-	rc = hwrm_ring_alloc_send_msg(bp, ring, type, tx_idx);
+	rc = hwrm_ring_alloc_send_msg(bp, NULL, ring, type, tx_idx);
 	if (rc)
 		return rc;
 	bnxt_set_db(bp, &txr->tx_db, type, tx_idx, ring->fw_ring_id);
@@ -7368,7 +7378,7 @@ static int bnxt_hwrm_ring_alloc(struct bnxt *bp)
 
 		vector = bp->irq_tbl[map_idx].vector;
 		disable_irq_nosync(vector);
-		rc = hwrm_ring_alloc_send_msg(bp, ring, type, map_idx);
+		rc = hwrm_ring_alloc_send_msg(bp, NULL, ring, type, map_idx);
 		if (rc) {
 			enable_irq(vector);
 			goto err_out;
diff --git a/drivers/net/ethernet/broadcom/bnxt/bnxt.h b/drivers/net/ethernet/broadcom/bnxt/bnxt.h
index f5f07a7e6b29..4c880a9fba92 100644
--- a/drivers/net/ethernet/broadcom/bnxt/bnxt.h
+++ b/drivers/net/ethernet/broadcom/bnxt/bnxt.h
@@ -1107,6 +1107,7 @@ struct bnxt_rx_ring_info {
 
 	unsigned long		*rx_agg_bmap;
 	u16			rx_agg_bmap_size;
+	u16			rx_page_size;
 	bool                    need_head_pool;
 
 	dma_addr_t		rx_desc_mapping[MAX_RX_PAGES];
diff --git a/drivers/net/ethernet/broadcom/bnxt/bnxt_xdp.c b/drivers/net/ethernet/broadcom/bnxt/bnxt_xdp.c
index c94a391b1ba5..85cbeb35681c 100644
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
@@ -460,7 +460,7 @@ int bnxt_xdp(struct net_device *dev, struct netdev_bpf *xdp)
 
 struct sk_buff *
 bnxt_xdp_build_skb(struct bnxt *bp, struct sk_buff *skb, u8 num_frags,
-		   struct page_pool *pool, struct xdp_buff *xdp)
+		   struct bnxt_rx_ring_info *rxr, struct xdp_buff *xdp)
 {
 	struct skb_shared_info *sinfo = xdp_get_shared_info_from_buff(xdp);
 
@@ -468,7 +468,7 @@ bnxt_xdp_build_skb(struct bnxt *bp, struct sk_buff *skb, u8 num_frags,
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


