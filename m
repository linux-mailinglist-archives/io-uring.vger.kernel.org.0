Return-Path: <io-uring+bounces-8817-lists+io-uring=lfdr.de@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [IPv6:2604:1380:45e3:2400::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 70664B1397F
	for <lists+io-uring@lfdr.de>; Mon, 28 Jul 2025 13:04:23 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 267A63BD4EA
	for <lists+io-uring@lfdr.de>; Mon, 28 Jul 2025 11:03:28 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id CFE0025D535;
	Mon, 28 Jul 2025 11:03:23 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="CPId+i+E"
X-Original-To: io-uring@vger.kernel.org
Received: from mail-wm1-f50.google.com (mail-wm1-f50.google.com [209.85.128.50])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id CCF4125C70C;
	Mon, 28 Jul 2025 11:03:21 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.128.50
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1753700603; cv=none; b=YZz+2af3Gs00sluXN4drmAzv9sRHx0WtpEEsZpuVmjZzynUMCFfpMIIfdN+y625coacgWYrfmgAfncLTNMZGy7KOdbCWIDMktjlesjcH43671aPMFL8ZZn5fzh0P11BU2LGeDDnPUl0l5rCiaqVnC1K41HIvhXa+hyQfEjLWHVI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1753700603; c=relaxed/simple;
	bh=ZdqV4VgSuPlxfhR9HxzQlgg7ncb2cNM7yae6pCmCcxA=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=HnRgyQja94K5Id29I+HwztwdqFueBbNixwKdne1RGe98AvT+zQC+k6gCORfKUkKoqtIJK03UGelebfKva2qDu4X2qKAyXO77V32tJqfLLXJ0rbLADCf6p1LULKhZ00Ea2x2lx8p9IgOMdkfjB0CLbVi3IJTcv84ssAESrf6IRkM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=CPId+i+E; arc=none smtp.client-ip=209.85.128.50
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Received: by mail-wm1-f50.google.com with SMTP id 5b1f17b1804b1-45634205adaso18544915e9.2;
        Mon, 28 Jul 2025 04:03:21 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1753700600; x=1754305400; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=JSgXlx6/k5hAbYES1rB+zzwwMDozMq0lZ2hGLNw8nrE=;
        b=CPId+i+EtXfYyf/AEw3+/kKXsR4vTzvFWTbVI6b2PjQ3ycAeLIF+YMFHlQ5n1ZXAzp
         C8gXOQ2R1mMInf5igTDwj5N7KEBgtSGMNJN0pQn/6xX3QuG1qQlfpaQy1rLqSU+l7FgH
         XEoOMp0rlkOZwkovkrFzL08qLmHOyjOOCaMjqOX/AAEq3myQz9eeWUfIOgoCDaNnpuCr
         eCrRA36U/xx3TffjpkIYeAOT4xbQf8FGH/3ANYXZr9gfPRgIc3n4OL2RyKiMus8QryuB
         FpKj1rJLIZKeTZlE51bic4OMUtSmaWnK9pjn87rOMdyG7m3VFpQ0zvOGOun9QZAg3qd+
         oiYg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1753700600; x=1754305400;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=JSgXlx6/k5hAbYES1rB+zzwwMDozMq0lZ2hGLNw8nrE=;
        b=OZzicHWOKFcfHsUiqFdz85eugrctb5HT4p3Wa0a8ZKI1e8OuyWXUn/tYVkUEUdzxSo
         YSZ6vonVEJq3187hPosFjX2ejZ9CNnox+GmVgPD8CRf3Dt9dkk+dvEz2Iax1zWWkb/6M
         k9FPkPI7TndzdWR+0S7+CGgsMX9S8S7Ed5rZGjAlr+/dR1t9Rg2JC6AtLbyCHd9KpBiR
         hWZ0yBPXoBSIzXhvdy+WCYA1CwVCeDDoxPv/nOBMR2o3wRVbtHrHEJoyzGmYxKRAm8Xu
         Enn9dCR2VNTcSFr8UeGLvnaw6ldGlHLDRK6fJQYbjZGyJRvPCMaWeKMshXrlbs8MBnbQ
         erOg==
X-Forwarded-Encrypted: i=1; AJvYcCVuqBDcGi7XsFOHGoMlkxfk5zH9EfCiiHhG7upecWFtCSOL9IQB7Fokrf7xEfY1LAcblwGRixaWPw==@vger.kernel.org, AJvYcCX1kNKslhIr5e1Whnzh0fCOu6FBXg7Vy91exSPDPcbPMG6pDEhDda2E7auiT+GKf6d2aeU4ic94@vger.kernel.org
X-Gm-Message-State: AOJu0YxrcXE7m+8Y73w2VIDRK0+3k4Gd50svH658vY1V0irIGwdjZhKZ
	jzWGlr4uLXt7fIdkVKwSXnfdNUMj1797Y0BAvY8XIOwtDXfDe0AjVWY/
X-Gm-Gg: ASbGnctgSbsgNEBYIYifXpOoB9K6Nq3U3myfVmlnuv54hKXbN+DER2G6oAoAz4mdq/b
	Nhf0oyNj91wmal35gTuCDXPTmXmUoOWLQWYIJa8+wSQlGAwW5iC0PzLYquih7g5QDESxnZII9vr
	lSk+QZjmBiZ4hvXSdhfVap//N8hWs9UzL2FTNHhO2yXLBEwKVGrb6PocGS4MEcMAVLwsFNsRxX7
	JhUaqxamHxMNjf7kuE8E/fTgBl42qc0/Y5S/sLG+j2IXNhXDFYXFCMo/QAIQGuRbUMKRfY9GmL0
	oWdBZd4FJDqJ6rtLs3rOy8RWyOHQvuNOhZIEbksW44T2qg6vqz/3ZOAkvlvVUP49VmmeavTGlv4
	zeJlDv8ybpr4M3w==
X-Google-Smtp-Source: AGHT+IF5mMhf2EzimtaJfBd9+ayzMNT41/3mCnOMI/1fUG9nCFwwhVk1Mkcr4hb+i533KcYmww+NHQ==
X-Received: by 2002:a05:600c:4590:b0:456:19be:5cc with SMTP id 5b1f17b1804b1-45876324d2bmr99446855e9.14.1753700599800;
        Mon, 28 Jul 2025 04:03:19 -0700 (PDT)
Received: from 127.com ([2620:10d:c092:600::1:75])
        by smtp.gmail.com with ESMTPSA id 5b1f17b1804b1-458705c4fdasm157410235e9.28.2025.07.28.04.03.18
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 28 Jul 2025 04:03:18 -0700 (PDT)
From: Pavel Begunkov <asml.silence@gmail.com>
To: Jakub Kicinski <kuba@kernel.org>,
	netdev@vger.kernel.org
Cc: asml.silence@gmail.com,
	io-uring@vger.kernel.org,
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
	ap420073@gmail.com
Subject: [RFC v1 06/22] eth: bnxt: read the page size from the adapter struct
Date: Mon, 28 Jul 2025 12:04:10 +0100
Message-ID: <e129c6bdfceadeaa4f4fe17524ea24f3c3471be7.1753694913.git.asml.silence@gmail.com>
X-Mailer: git-send-email 2.49.0
In-Reply-To: <cover.1753694913.git.asml.silence@gmail.com>
References: <cover.1753694913.git.asml.silence@gmail.com>
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
index 2cb3185c442c..274ebd63bdd9 100644
--- a/drivers/net/ethernet/broadcom/bnxt/bnxt.c
+++ b/drivers/net/ethernet/broadcom/bnxt/bnxt.c
@@ -895,7 +895,7 @@ static void bnxt_tx_int(struct bnxt *bp, struct bnxt_napi *bnapi, int budget)
 
 static bool bnxt_separate_head_pool(struct bnxt_rx_ring_info *rxr)
 {
-	return rxr->need_head_pool || PAGE_SIZE > BNXT_RX_PAGE_SIZE;
+	return rxr->need_head_pool || PAGE_SIZE > rxr->bnapi->bp->rx_page_size;
 }
 
 static struct page *__bnxt_alloc_rx_page(struct bnxt *bp, dma_addr_t *mapping,
@@ -905,9 +905,9 @@ static struct page *__bnxt_alloc_rx_page(struct bnxt *bp, dma_addr_t *mapping,
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
@@ -1139,9 +1139,9 @@ static struct sk_buff *bnxt_rx_multi_page_skb(struct bnxt *bp,
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
@@ -1173,7 +1173,7 @@ static struct sk_buff *bnxt_rx_page_skb(struct bnxt *bp,
 		return NULL;
 	}
 	dma_addr -= bp->rx_dma_offset;
-	dma_sync_single_for_cpu(&bp->pdev->dev, dma_addr, BNXT_RX_PAGE_SIZE,
+	dma_sync_single_for_cpu(&bp->pdev->dev, dma_addr, bp->rx_page_size,
 				bp->rx_dir);
 
 	if (unlikely(!payload))
@@ -1187,7 +1187,7 @@ static struct sk_buff *bnxt_rx_page_skb(struct bnxt *bp,
 
 	skb_mark_for_recycle(skb);
 	off = (void *)data_ptr - page_address(page);
-	skb_add_rx_frag(skb, 0, page, off, len, BNXT_RX_PAGE_SIZE);
+	skb_add_rx_frag(skb, 0, page, off, len, bp->rx_page_size);
 	memcpy(skb->data - NET_IP_ALIGN, data_ptr - NET_IP_ALIGN,
 	       payload + NET_IP_ALIGN);
 
@@ -1272,7 +1272,7 @@ static u32 __bnxt_rx_agg_netmems(struct bnxt *bp,
 		if (skb) {
 			skb_add_rx_frag_netmem(skb, i, cons_rx_buf->netmem,
 					       cons_rx_buf->offset,
-					       frag_len, BNXT_RX_PAGE_SIZE);
+					       frag_len, bp->rx_page_size);
 		} else {
 			skb_frag_t *frag = &shinfo->frags[i];
 
@@ -1297,7 +1297,7 @@ static u32 __bnxt_rx_agg_netmems(struct bnxt *bp,
 			if (skb) {
 				skb->len -= frag_len;
 				skb->data_len -= frag_len;
-				skb->truesize -= BNXT_RX_PAGE_SIZE;
+				skb->truesize -= bp->rx_page_size;
 			}
 
 			--shinfo->nr_frags;
@@ -1312,7 +1312,7 @@ static u32 __bnxt_rx_agg_netmems(struct bnxt *bp,
 		}
 
 		page_pool_dma_sync_netmem_for_cpu(rxr->page_pool, netmem, 0,
-						  BNXT_RX_PAGE_SIZE);
+						  bp->rx_page_size);
 
 		total_frag_len += frag_len;
 		prod = NEXT_RX_AGG(prod);
@@ -4448,7 +4448,7 @@ static void bnxt_init_one_rx_agg_ring_rxbd(struct bnxt *bp,
 	ring = &rxr->rx_agg_ring_struct;
 	ring->fw_ring_id = INVALID_HW_RING_ID;
 	if ((bp->flags & BNXT_FLAG_AGG_RINGS)) {
-		type = ((u32)BNXT_RX_PAGE_SIZE << RX_BD_LEN_SHIFT) |
+		type = ((u32)bp->rx_page_size << RX_BD_LEN_SHIFT) |
 			RX_BD_TYPE_RX_AGG_BD | RX_BD_FLAGS_SOP;
 
 		bnxt_init_rxbd_pages(ring, type);
@@ -4710,7 +4710,7 @@ void bnxt_set_ring_params(struct bnxt *bp)
 	bp->rx_agg_nr_pages = 0;
 
 	if (bp->flags & BNXT_FLAG_TPA || bp->flags & BNXT_FLAG_HDS)
-		agg_factor = min_t(u32, 4, 65536 / BNXT_RX_PAGE_SIZE);
+		agg_factor = min_t(u32, 4, 65536 / bp->rx_page_size);
 
 	bp->flags &= ~BNXT_FLAG_JUMBO;
 	if (rx_space > PAGE_SIZE && !(bp->flags & BNXT_FLAG_NO_AGG_RINGS)) {
@@ -7022,7 +7022,7 @@ static void bnxt_set_rx_ring_params_p5(struct bnxt *bp, u32 ring_type,
 	if (ring_type == HWRM_RING_ALLOC_AGG) {
 		req->ring_type = RING_ALLOC_REQ_RING_TYPE_RX_AGG;
 		req->rx_ring_id = cpu_to_le16(grp_info->rx_fw_ring_id);
-		req->rx_buf_size = cpu_to_le16(BNXT_RX_PAGE_SIZE);
+		req->rx_buf_size = cpu_to_le16(bp->rx_page_size);
 		enables |= RING_ALLOC_REQ_ENABLES_RX_RING_ID_VALID;
 	} else {
 		req->rx_buf_size = cpu_to_le16(bp->rx_buf_use_size);
@@ -16573,6 +16573,7 @@ static int bnxt_init_one(struct pci_dev *pdev, const struct pci_device_id *ent)
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
index 4a6d8cb9f970..32bcc3aedee6 100644
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


