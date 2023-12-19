Return-Path: <io-uring+bounces-319-lists+io-uring=lfdr.de@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [139.178.88.99])
	by mail.lfdr.de (Postfix) with ESMTPS id D725981920C
	for <lists+io-uring@lfdr.de>; Tue, 19 Dec 2023 22:06:33 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 8DA1B284CAF
	for <lists+io-uring@lfdr.de>; Tue, 19 Dec 2023 21:06:32 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 23CFB3BB47;
	Tue, 19 Dec 2023 21:04:27 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=davidwei-uk.20230601.gappssmtp.com header.i=@davidwei-uk.20230601.gappssmtp.com header.b="WJhzViu7"
X-Original-To: io-uring@vger.kernel.org
Received: from mail-ot1-f43.google.com (mail-ot1-f43.google.com [209.85.210.43])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C5BE340C07
	for <io-uring@vger.kernel.org>; Tue, 19 Dec 2023 21:04:24 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=davidwei.uk
Authentication-Results: smtp.subspace.kernel.org; spf=none smtp.mailfrom=davidwei.uk
Received: by mail-ot1-f43.google.com with SMTP id 46e09a7af769-6d9f4eed60eso3868580a34.1
        for <io-uring@vger.kernel.org>; Tue, 19 Dec 2023 13:04:24 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=davidwei-uk.20230601.gappssmtp.com; s=20230601; t=1703019864; x=1703624664; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=UaWUxwWMhpizTTTVDJEx3BaZ8y03KGcwpzKbAhXUqpk=;
        b=WJhzViu7VLsvKmdEJt8RM9QWBU830WM/jDux05YkwR1Sejx4gfuMWXu4yNwnOGbos5
         oQsaO0qiJ0BG4SS5l/BUNx5l/E4rhlw9uH+32WCTRp+RXtIsv4mpQrYzuoP0M8Bj7eiW
         mpDi/NPj/Dte0Ng7ooZSM34nvjkGVFy/52OSU3VFZYJ8k3zRC5Q5wPvAk9khZMoYPqMW
         UrYonltAPTRMxpkQAEP3wcdpb6XLzXj5He4SC4ta+F/f5rmQb/7sTpRxxpL53cj5ESBt
         ywPHELf6d1avOHjRBIbh+QRU7LHPse2X10Q6tGV0Xfn2Wl1A9PtJMbltrXgL6JqBbtRn
         3B/A==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1703019864; x=1703624664;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=UaWUxwWMhpizTTTVDJEx3BaZ8y03KGcwpzKbAhXUqpk=;
        b=xKUXxBpz8PK3JETYA5wWkfHHSS6xudpahseKxw8ap0NzyqGh8s/goQ7/sh9dgPOtG6
         sHqTrwDyWSToDAFhUH8a9/aOGugLOuoZc6MOQuZu3fRn8cJECZVy5YMRbbm6hrwO35Ln
         kSQWmd5X/8LramXF+e8C0akqgpJ5OC2hGeHfo1bjB49sNSAvy7lEsDVTzdM5v1zRdoZ0
         XKDW36BgG9vVl4S2ghSyH5Gktfkpn+5M3sFX4/OpdREgh3qyiwwwA2Y1IopdMIJb9eXy
         SyBsENGw8F7BQurvhDoXNC5xHrYrEqhhGRF00c2spH90lvbf6+75w7DDZIgSWl0lO1lx
         fWtw==
X-Gm-Message-State: AOJu0YzEbGT15o9a2DmUXBNVqkWYvWJOlyndLe6Dh99X5uZoFqiQLB4j
	3wk9hA1xmG1RYG3J0Q9U16VQ+wmDSxoloUJABE8qwQ==
X-Google-Smtp-Source: AGHT+IEtTwvrmgbTpMQqNKAuQVjNzW+eoJccv8bAayAZyfBOqrS0CFXslrtBQSxc+fixpkFaqhl1Kw==
X-Received: by 2002:a05:6358:99a0:b0:170:17eb:203c with SMTP id j32-20020a05635899a000b0017017eb203cmr19345106rwb.37.1703019863804;
        Tue, 19 Dec 2023 13:04:23 -0800 (PST)
Received: from localhost (fwdproxy-prn-118.fbsv.net. [2a03:2880:ff:76::face:b00c])
        by smtp.gmail.com with ESMTPSA id fn6-20020a056a002fc600b006d838632671sm3803511pfb.101.2023.12.19.13.04.23
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 19 Dec 2023 13:04:23 -0800 (PST)
From: David Wei <dw@davidwei.uk>
To: io-uring@vger.kernel.org,
	netdev@vger.kernel.org
Cc: Jens Axboe <axboe@kernel.dk>,
	Pavel Begunkov <asml.silence@gmail.com>,
	Jakub Kicinski <kuba@kernel.org>,
	Paolo Abeni <pabeni@redhat.com>,
	"David S. Miller" <davem@davemloft.net>,
	Eric Dumazet <edumazet@google.com>,
	Jesper Dangaard Brouer <hawk@kernel.org>,
	David Ahern <dsahern@kernel.org>,
	Mina Almasry <almasrymina@google.com>
Subject: [RFC PATCH v3 20/20] bnxt: enable io_uring zc page pool
Date: Tue, 19 Dec 2023 13:03:57 -0800
Message-Id: <20231219210357.4029713-21-dw@davidwei.uk>
X-Mailer: git-send-email 2.39.3
In-Reply-To: <20231219210357.4029713-1-dw@davidwei.uk>
References: <20231219210357.4029713-1-dw@davidwei.uk>
Precedence: bulk
X-Mailing-List: io-uring@vger.kernel.org
List-Id: <io-uring.vger.kernel.org>
List-Subscribe: <mailto:io-uring+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:io-uring+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

From: Pavel Begunkov <asml.silence@gmail.com>

TESTING ONLY

Signed-off-by: Pavel Begunkov <asml.silence@gmail.com>
Signed-off-by: David Wei <dw@davidwei.uk>
---
 drivers/net/ethernet/broadcom/bnxt/bnxt.c     | 71 +++++++++++++++++--
 drivers/net/ethernet/broadcom/bnxt/bnxt.h     |  7 ++
 drivers/net/ethernet/broadcom/bnxt/bnxt_xdp.c |  3 +
 3 files changed, 75 insertions(+), 6 deletions(-)

diff --git a/drivers/net/ethernet/broadcom/bnxt/bnxt.c b/drivers/net/ethernet/broadcom/bnxt/bnxt.c
index 039f8d995a26..d9fb8633f226 100644
--- a/drivers/net/ethernet/broadcom/bnxt/bnxt.c
+++ b/drivers/net/ethernet/broadcom/bnxt/bnxt.c
@@ -55,6 +55,7 @@
 #include <net/page_pool/helpers.h>
 #include <linux/align.h>
 #include <net/netdev_queues.h>
+#include <linux/io_uring/net.h>
 
 #include "bnxt_hsi.h"
 #include "bnxt.h"
@@ -875,6 +876,25 @@ static inline u8 *__bnxt_alloc_rx_frag(struct bnxt *bp, dma_addr_t *mapping,
 	return data;
 }
 
+static inline struct page *bnxt_get_real_page(struct page *page)
+{
+	struct io_zc_rx_buf *buf;
+
+	if (page_is_page_pool_iov(page)) {
+		buf = container_of(page_to_page_pool_iov(page),
+				struct io_zc_rx_buf, ppiov);
+		page = buf->page;
+	}
+	return page;
+}
+
+static inline void *bnxt_get_page_address(struct page *frag)
+{
+	struct page *page = bnxt_get_real_page(frag);
+
+	return page_address(page);
+}
+
 int bnxt_alloc_rx_data(struct bnxt *bp, struct bnxt_rx_ring_info *rxr,
 		       u16 prod, gfp_t gfp)
 {
@@ -892,7 +912,7 @@ int bnxt_alloc_rx_data(struct bnxt *bp, struct bnxt_rx_ring_info *rxr,
 
 		mapping += bp->rx_dma_offset;
 		rx_buf->data = page;
-		rx_buf->data_ptr = page_address(page) + offset + bp->rx_offset;
+		rx_buf->data_ptr = bnxt_get_page_address(page) + offset + bp->rx_offset;
 	} else {
 		u8 *data = __bnxt_alloc_rx_frag(bp, &mapping, gfp);
 
@@ -954,8 +974,9 @@ static inline int bnxt_alloc_rx_page(struct bnxt *bp,
 
 	if (PAGE_SIZE <= BNXT_RX_PAGE_SIZE)
 		page = __bnxt_alloc_rx_page(bp, &mapping, rxr, &offset, gfp);
-	else
+	else {
 		page = __bnxt_alloc_rx_64k_page(bp, &mapping, rxr, gfp, &offset);
+	}
 
 	if (!page)
 		return -ENOMEM;
@@ -1079,6 +1100,7 @@ static struct sk_buff *bnxt_rx_multi_page_skb(struct bnxt *bp,
 		return NULL;
 	}
 	skb_mark_for_recycle(skb);
+
 	skb_reserve(skb, bp->rx_offset);
 	__skb_put(skb, len);
 
@@ -1118,7 +1140,7 @@ static struct sk_buff *bnxt_rx_page_skb(struct bnxt *bp,
 	}
 
 	skb_mark_for_recycle(skb);
-	off = (void *)data_ptr - page_address(page);
+	off = (void *)data_ptr - bnxt_get_page_address(page);
 	skb_add_rx_frag(skb, 0, page, off, len, BNXT_RX_PAGE_SIZE);
 	memcpy(skb->data - NET_IP_ALIGN, data_ptr - NET_IP_ALIGN,
 	       payload + NET_IP_ALIGN);
@@ -2032,7 +2054,6 @@ static int bnxt_rx_pkt(struct bnxt *bp, struct bnxt_cp_ring_info *cpr,
 				goto next_rx;
 			}
 		} else {
-			skb = bnxt_xdp_build_skb(bp, skb, agg_bufs, rxr->page_pool, &xdp, rxcmp1);
 			if (!skb) {
 				/* we should be able to free the old skb here */
 				bnxt_xdp_buff_frags_free(rxr, &xdp);
@@ -3402,7 +3423,8 @@ static void bnxt_free_rx_rings(struct bnxt *bp)
 }
 
 static int bnxt_alloc_rx_page_pool(struct bnxt *bp,
-				   struct bnxt_rx_ring_info *rxr)
+				   struct bnxt_rx_ring_info *rxr,
+				   int qid)
 {
 	struct page_pool_params pp = { 0 };
 
@@ -3416,6 +3438,13 @@ static int bnxt_alloc_rx_page_pool(struct bnxt *bp,
 	pp.max_len = PAGE_SIZE;
 	pp.flags = PP_FLAG_DMA_MAP | PP_FLAG_DMA_SYNC_DEV;
 
+	if (bp->iou_ifq && qid == bp->iou_qid) {
+		pp.mp_priv = bp->iou_ifq;
+		pp.memory_provider = PP_MP_IOU_ZCRX;
+		pp.max_len = PAGE_SIZE;
+		pp.flags = 0;
+	}
+
 	rxr->page_pool = page_pool_create(&pp);
 	if (IS_ERR(rxr->page_pool)) {
 		int err = PTR_ERR(rxr->page_pool);
@@ -3442,7 +3471,7 @@ static int bnxt_alloc_rx_rings(struct bnxt *bp)
 
 		ring = &rxr->rx_ring_struct;
 
-		rc = bnxt_alloc_rx_page_pool(bp, rxr);
+		rc = bnxt_alloc_rx_page_pool(bp, rxr, i);
 		if (rc)
 			return rc;
 
@@ -14347,6 +14376,36 @@ void bnxt_print_device_info(struct bnxt *bp)
 	pcie_print_link_status(bp->pdev);
 }
 
+int bnxt_zc_rx(struct bnxt *bp, struct netdev_bpf *xdp)
+{
+	unsigned ifq_idx = xdp->zc_rx.queue_id;
+
+	if (ifq_idx >= bp->rx_nr_rings)
+		return -EINVAL;
+	if (PAGE_SIZE != BNXT_RX_PAGE_SIZE)
+		return -EINVAL;
+
+	bnxt_rtnl_lock_sp(bp);
+	if (!!bp->iou_ifq == !!xdp->zc_rx.ifq) {
+		bnxt_rtnl_unlock_sp(bp);
+		return -EINVAL;
+	}
+	if (netif_running(bp->dev)) {
+		int rc;
+
+		bnxt_ulp_stop(bp);
+		bnxt_close_nic(bp, true, false);
+
+		bp->iou_qid = ifq_idx;
+		bp->iou_ifq = xdp->zc_rx.ifq;
+
+		rc = bnxt_open_nic(bp, true, false);
+		bnxt_ulp_start(bp, rc);
+	}
+	bnxt_rtnl_unlock_sp(bp);
+	return 0;
+}
+
 static int bnxt_init_one(struct pci_dev *pdev, const struct pci_device_id *ent)
 {
 	struct net_device *dev;
diff --git a/drivers/net/ethernet/broadcom/bnxt/bnxt.h b/drivers/net/ethernet/broadcom/bnxt/bnxt.h
index e31164e3b8fb..1003f9260805 100644
--- a/drivers/net/ethernet/broadcom/bnxt/bnxt.h
+++ b/drivers/net/ethernet/broadcom/bnxt/bnxt.h
@@ -2342,6 +2342,10 @@ struct bnxt {
 #endif
 	u32			thermal_threshold_type;
 	enum board_idx		board_idx;
+
+	/* io_uring zerocopy */
+	void			*iou_ifq;
+	unsigned		iou_qid;
 };
 
 #define BNXT_NUM_RX_RING_STATS			8
@@ -2556,4 +2560,7 @@ int bnxt_get_port_parent_id(struct net_device *dev,
 void bnxt_dim_work(struct work_struct *work);
 int bnxt_hwrm_set_ring_coal(struct bnxt *bp, struct bnxt_napi *bnapi);
 void bnxt_print_device_info(struct bnxt *bp);
+
+int bnxt_zc_rx(struct bnxt *bp, struct netdev_bpf *xdp);
+
 #endif
diff --git a/drivers/net/ethernet/broadcom/bnxt/bnxt_xdp.c b/drivers/net/ethernet/broadcom/bnxt/bnxt_xdp.c
index 4791f6a14e55..a3ae02c31ffc 100644
--- a/drivers/net/ethernet/broadcom/bnxt/bnxt_xdp.c
+++ b/drivers/net/ethernet/broadcom/bnxt/bnxt_xdp.c
@@ -466,6 +466,9 @@ int bnxt_xdp(struct net_device *dev, struct netdev_bpf *xdp)
 	case XDP_SETUP_PROG:
 		rc = bnxt_xdp_set(bp, xdp->prog);
 		break;
+	case XDP_SETUP_ZC_RX:
+		return bnxt_zc_rx(bp, xdp);
+		break;
 	default:
 		rc = -EINVAL;
 		break;
-- 
2.39.3


