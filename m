Return-Path: <io-uring+bounces-70-lists+io-uring=lfdr.de@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from sy.mirrors.kernel.org (sy.mirrors.kernel.org [IPv6:2604:1380:40f1:3f00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 3F0917E4B04
	for <lists+io-uring@lfdr.de>; Tue,  7 Nov 2023 22:42:51 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sy.mirrors.kernel.org (Postfix) with ESMTPS id 30EE9B20F78
	for <lists+io-uring@lfdr.de>; Tue,  7 Nov 2023 21:42:48 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 337D32CCD8;
	Tue,  7 Nov 2023 21:41:18 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=davidwei-uk.20230601.gappssmtp.com header.i=@davidwei-uk.20230601.gappssmtp.com header.b="NPBxlArz"
X-Original-To: io-uring@vger.kernel.org
Received: from lindbergh.monkeyblade.net (lindbergh.monkeyblade.net [23.128.96.19])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9B3682CCA6
	for <io-uring@vger.kernel.org>; Tue,  7 Nov 2023 21:41:14 +0000 (UTC)
Received: from mail-pj1-x1031.google.com (mail-pj1-x1031.google.com [IPv6:2607:f8b0:4864:20::1031])
	by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 31F1510F0
	for <io-uring@vger.kernel.org>; Tue,  7 Nov 2023 13:41:14 -0800 (PST)
Received: by mail-pj1-x1031.google.com with SMTP id 98e67ed59e1d1-28041176e77so4662480a91.0
        for <io-uring@vger.kernel.org>; Tue, 07 Nov 2023 13:41:14 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=davidwei-uk.20230601.gappssmtp.com; s=20230601; t=1699393273; x=1699998073; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=24NMvuwsm8opdmLI6RaThqDP9FkcBYT5SzyW1mwOoUk=;
        b=NPBxlArzKZXH2jXMbgP8j7xomkQmrggyA5JD8zYQbubi6gRLdQ06VDarLDMotMR980
         Jv6WGZ7RV1HipXeC0sizxTj7mSms9lU7aj+0SemMjgTqrnky5F8k7EYNv07hr2rfFKLN
         R2LAkGCTIn1WMg44TFo3f0rfD8oUzmnYFT1XR+X3FnTP9liWRn0HHIkhUerFV2Y+8TPv
         D1EPd2HxzooNlo8uSSKmn9aUa9DUPP6DqqL6/5mP65bYFpSKsP9oGBOWcYdwGv/pCMqj
         mBu4vtEfxbtzqnZlBa1fZMYvOsFOz3Oq9Jdbo20yTn8tIfy1jz5099IQydBEI4YSMO+L
         07pA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1699393273; x=1699998073;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=24NMvuwsm8opdmLI6RaThqDP9FkcBYT5SzyW1mwOoUk=;
        b=suKg5vOpvpxtPKLQoV4yUL1r6ThVORJB2O5O1iyVQdsEeLYPGaPymG7bpnxLSzZwGE
         NXtRH2b1pcvPjjz186fM6JOY8z4xWxQu6Uvb4H6bCOm8AOH8TC3s05BWY9hUNJ+kiG6x
         FnJODwA3Vw6TphNqVYyksV84E4eFUrJsiqN9M3LL+IMyABcRRPWLFzRBiSgL1jrY/aqY
         ZzgghFvDhnPg7NhlpjZr3Cs5NJ+3Qj2k+L4iv9x5XIsAW+PHDxlALK2vdJiGsHtSBi4T
         EIp4hv/+rc5RgPw5h6gIu4dRorCitdkoq95Z5j+8UOheH3pvOdyhBMOcklHpyzIgqexp
         Jn7w==
X-Gm-Message-State: AOJu0Yx+rPzKq81lXogo34q43Ip/rOBPltptmvgR/qUuakUz5SCZTWYT
	Tq/jbuDZesEb2dpBd/HBSiWQ0ijXjy6u29nq9qigqQ==
X-Google-Smtp-Source: AGHT+IEsCCxIQ4zudTGP6Cjux/XiAMHHW5H4f2S8Qmp0qUYHU0tHtdYyhYBfoPuRWZjiqf1BB8wdAw==
X-Received: by 2002:a17:90a:7e8d:b0:280:ff37:8981 with SMTP id j13-20020a17090a7e8d00b00280ff378981mr5558242pjl.44.1699393273530;
        Tue, 07 Nov 2023 13:41:13 -0800 (PST)
Received: from localhost (fwdproxy-prn-013.fbsv.net. [2a03:2880:ff:d::face:b00c])
        by smtp.gmail.com with ESMTPSA id ml10-20020a17090b360a00b0027d0af2e9c3sm255218pjb.40.2023.11.07.13.41.13
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 07 Nov 2023 13:41:13 -0800 (PST)
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
	Mina Almasry <almasrymina@google.com>,
	Willem de Bruijn <willemdebruijn.kernel@gmail.com>,
	Dragos Tatulea <dtatulea@nvidia.com>
Subject: [PATCH 19/20] bnxt: use data pool
Date: Tue,  7 Nov 2023 13:40:44 -0800
Message-Id: <20231107214045.2172393-20-dw@davidwei.uk>
X-Mailer: git-send-email 2.39.3
In-Reply-To: <20231107214045.2172393-1-dw@davidwei.uk>
References: <20231107214045.2172393-1-dw@davidwei.uk>
Precedence: bulk
X-Mailing-List: io-uring@vger.kernel.org
List-Id: <io-uring.vger.kernel.org>
List-Subscribe: <mailto:io-uring+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:io-uring+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

The BNXT driver is modified to use data pool in order to support ZC Rx.
A setup function bnxt_zc_rx is added that is called on XDP_SETUP_ZC_RX
XDP command which initialises a data_pool in a netdev_rx_queue.

Co-developed-by: Pavel Begunkov <asml.silence@gmail.com>
Signed-off-by: Pavel Begunkov <asml.silence@gmail.com>
Signed-off-by: David Wei <dw@davidwei.uk>
---
 drivers/net/ethernet/broadcom/bnxt/bnxt.c     | 61 ++++++++++++++++---
 drivers/net/ethernet/broadcom/bnxt/bnxt.h     |  5 ++
 drivers/net/ethernet/broadcom/bnxt/bnxt_xdp.c |  3 +
 include/net/netdev_rx_queue.h                 |  2 +
 4 files changed, 61 insertions(+), 10 deletions(-)

diff --git a/drivers/net/ethernet/broadcom/bnxt/bnxt.c b/drivers/net/ethernet/broadcom/bnxt/bnxt.c
index ca1088f7107e..2787c1b474db 100644
--- a/drivers/net/ethernet/broadcom/bnxt/bnxt.c
+++ b/drivers/net/ethernet/broadcom/bnxt/bnxt.c
@@ -55,6 +55,8 @@
 #include <net/page_pool/helpers.h>
 #include <linux/align.h>
 #include <net/netdev_queues.h>
+#include <net/netdev_rx_queue.h>
+#include <net/data_pool.h>
 
 #include "bnxt_hsi.h"
 #include "bnxt.h"
@@ -798,13 +800,7 @@ static struct page *__bnxt_alloc_rx_64k_page(struct bnxt *bp, dma_addr_t *mappin
 	if (!page)
 		return NULL;
 
-	*mapping = dma_map_page_attrs(&bp->pdev->dev, page, offset,
-				      BNXT_RX_PAGE_SIZE, DMA_FROM_DEVICE,
-				      DMA_ATTR_WEAK_ORDERING);
-	if (dma_mapping_error(&bp->pdev->dev, *mapping)) {
-		page_pool_recycle_direct(rxr->page_pool, page);
-		return NULL;
-	}
+	*mapping = page_pool_get_dma_addr(page);
 
 	if (page_offset)
 		*page_offset = offset;
@@ -824,13 +820,13 @@ static struct page *__bnxt_alloc_rx_page(struct bnxt *bp, dma_addr_t *mapping,
 		page = page_pool_dev_alloc_frag(rxr->page_pool, offset,
 						BNXT_RX_PAGE_SIZE);
 	} else {
-		page = page_pool_dev_alloc_pages(rxr->page_pool);
+		page = data_pool_alloc_page(&rxr->rx_dp);
 		*offset = 0;
 	}
 	if (!page)
 		return NULL;
 
-	*mapping = page_pool_get_dma_addr(page) + *offset;
+	*mapping = data_pool_get_dma_addr(&rxr->rx_dp, page) + *offset;
 	return page;
 }
 
@@ -1816,6 +1812,8 @@ static void bnxt_deliver_skb(struct bnxt *bp, struct bnxt_napi *bnapi,
 		return;
 	}
 	skb_record_rx_queue(skb, bnapi->index);
+	if (bnapi->rx_ring->rx_dp.zc_uarg)
+		skb_zcopy_init(skb, bnapi->rx_ring->rx_dp.zc_uarg);
 	skb_mark_for_recycle(skb);
 	napi_gro_receive(&bnapi->napi, skb);
 }
@@ -3100,7 +3098,7 @@ static void bnxt_free_one_rx_ring_skbs(struct bnxt *bp, int ring_nr)
 		rx_agg_buf->page = NULL;
 		__clear_bit(i, rxr->rx_agg_bmap);
 
-		page_pool_recycle_direct(rxr->page_pool, page);
+		data_pool_put_page(&rxr->rx_dp, page);
 	}
 
 skip_rx_agg_free:
@@ -3305,6 +3303,8 @@ static void bnxt_free_rx_rings(struct bnxt *bp)
 
 		page_pool_destroy(rxr->page_pool);
 		rxr->page_pool = NULL;
+		rxr->rx_dp.page_pool = NULL;
+		rxr->rx_dp.zc_ifq = NULL;
 
 		kfree(rxr->rx_agg_bmap);
 		rxr->rx_agg_bmap = NULL;
@@ -3333,6 +3333,8 @@ static int bnxt_alloc_rx_page_pool(struct bnxt *bp,
 	pp.flags = PP_FLAG_DMA_MAP | PP_FLAG_DMA_SYNC_DEV;
 	if (PAGE_SIZE > BNXT_RX_PAGE_SIZE)
 		pp.flags |= PP_FLAG_PAGE_FRAG;
+	pp.flags |= PP_FLAG_DMA_MAP | PP_FLAG_DMA_SYNC_DEV;
+	pp.max_len = PAGE_SIZE;
 
 	rxr->page_pool = page_pool_create(&pp);
 	if (IS_ERR(rxr->page_pool)) {
@@ -3341,6 +3343,7 @@ static int bnxt_alloc_rx_page_pool(struct bnxt *bp,
 		rxr->page_pool = NULL;
 		return err;
 	}
+	rxr->rx_dp.page_pool = rxr->page_pool;
 	return 0;
 }
 
@@ -3803,6 +3806,7 @@ static int bnxt_init_one_rx_ring(struct bnxt *bp, int ring_nr)
 {
 	struct bnxt_rx_ring_info *rxr;
 	struct bnxt_ring_struct *ring;
+	struct netdev_rx_queue *rxq;
 	u32 type;
 
 	type = (bp->rx_buf_use_size << RX_BD_LEN_SHIFT) |
@@ -3831,6 +3835,12 @@ static int bnxt_init_one_rx_ring(struct bnxt *bp, int ring_nr)
 		bnxt_init_rxbd_pages(ring, type);
 	}
 
+	rxq = __netif_get_rx_queue(bp->dev, ring_nr);
+	if (rxq->data_pool.zc_ifq) {
+		rxr->rx_dp.zc_ifq = rxq->data_pool.zc_ifq;
+		rxr->rx_dp.zc_uarg = rxq->data_pool.zc_uarg;
+	}
+
 	return bnxt_alloc_one_rx_ring(bp, ring_nr);
 }
 
@@ -13974,6 +13984,37 @@ void bnxt_print_device_info(struct bnxt *bp)
 	pcie_print_link_status(bp->pdev);
 }
 
+int bnxt_zc_rx(struct bnxt *bp, struct netdev_bpf *xdp)
+{
+	unsigned ifq_idx = xdp->zc_rx.queue_id;
+
+	if (ifq_idx >= bp->rx_nr_rings)
+		return -EINVAL;
+
+	bnxt_rtnl_lock_sp(bp);
+	if (netif_running(bp->dev)) {
+		struct netdev_rx_queue *rxq;
+		int rc, napi_id;
+
+		bnxt_ulp_stop(bp);
+		bnxt_close_nic(bp, true, false);
+
+		rxq = __netif_get_rx_queue(bp->dev, ifq_idx);
+		rxq->data_pool.zc_ifq = xdp->zc_rx.ifq;
+		rxq->data_pool.zc_uarg = xdp->zc_rx.uarg;
+
+		rc = bnxt_open_nic(bp, true, false);
+		bnxt_ulp_start(bp, rc);
+
+		if (xdp->zc_rx.ifq) {
+			napi_id = bp->bnapi[ifq_idx]->napi.napi_id;
+			io_zc_rx_set_napi(xdp->zc_rx.ifq, napi_id);
+		}
+	}
+	bnxt_rtnl_unlock_sp(bp);
+	return 0;
+}
+
 static int bnxt_init_one(struct pci_dev *pdev, const struct pci_device_id *ent)
 {
 	struct net_device *dev;
diff --git a/drivers/net/ethernet/broadcom/bnxt/bnxt.h b/drivers/net/ethernet/broadcom/bnxt/bnxt.h
index d95d0ca91f3f..7f3b03fa5960 100644
--- a/drivers/net/ethernet/broadcom/bnxt/bnxt.h
+++ b/drivers/net/ethernet/broadcom/bnxt/bnxt.h
@@ -33,6 +33,7 @@
 #ifdef CONFIG_TEE_BNXT_FW
 #include <linux/firmware/broadcom/tee_bnxt_fw.h>
 #endif
+#include <net/data_pool.h>
 
 extern struct list_head bnxt_block_cb_list;
 
@@ -946,6 +947,7 @@ struct bnxt_rx_ring_info {
 	struct bnxt_ring_struct	rx_agg_ring_struct;
 	struct xdp_rxq_info	xdp_rxq;
 	struct page_pool	*page_pool;
+	struct data_pool	rx_dp;
 };
 
 struct bnxt_rx_sw_stats {
@@ -2485,4 +2487,7 @@ int bnxt_get_port_parent_id(struct net_device *dev,
 void bnxt_dim_work(struct work_struct *work);
 int bnxt_hwrm_set_ring_coal(struct bnxt *bp, struct bnxt_napi *bnapi);
 void bnxt_print_device_info(struct bnxt *bp);
+
+int bnxt_zc_rx(struct bnxt *bp, struct netdev_bpf *xdp);
+
 #endif
diff --git a/drivers/net/ethernet/broadcom/bnxt/bnxt_xdp.c b/drivers/net/ethernet/broadcom/bnxt/bnxt_xdp.c
index 96f5ca778c67..b7ef2e551334 100644
--- a/drivers/net/ethernet/broadcom/bnxt/bnxt_xdp.c
+++ b/drivers/net/ethernet/broadcom/bnxt/bnxt_xdp.c
@@ -465,6 +465,9 @@ int bnxt_xdp(struct net_device *dev, struct netdev_bpf *xdp)
 	case XDP_SETUP_PROG:
 		rc = bnxt_xdp_set(bp, xdp->prog);
 		break;
+	case XDP_SETUP_ZC_RX:
+		return bnxt_zc_rx(bp, xdp);
+		break;
 	default:
 		rc = -EINVAL;
 		break;
diff --git a/include/net/netdev_rx_queue.h b/include/net/netdev_rx_queue.h
index cdcafb30d437..1b2944e61e19 100644
--- a/include/net/netdev_rx_queue.h
+++ b/include/net/netdev_rx_queue.h
@@ -6,6 +6,7 @@
 #include <linux/netdevice.h>
 #include <linux/sysfs.h>
 #include <net/xdp.h>
+#include <net/data_pool.h>
 
 /* This structure contains an instance of an RX queue. */
 struct netdev_rx_queue {
@@ -18,6 +19,7 @@ struct netdev_rx_queue {
 	struct net_device		*dev;
 	netdevice_tracker		dev_tracker;
 
+	struct data_pool		data_pool;
 #ifdef CONFIG_XDP_SOCKETS
 	struct xsk_buff_pool            *pool;
 #endif
-- 
2.39.3


