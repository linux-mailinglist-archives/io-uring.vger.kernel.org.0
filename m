Return-Path: <io-uring+bounces-69-lists+io-uring=lfdr.de@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [IPv6:2604:1380:45e3:2400::1])
	by mail.lfdr.de (Postfix) with ESMTPS id CF8E27E4B01
	for <lists+io-uring@lfdr.de>; Tue,  7 Nov 2023 22:42:42 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 858A52814D1
	for <lists+io-uring@lfdr.de>; Tue,  7 Nov 2023 21:42:41 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 872862CCCB;
	Tue,  7 Nov 2023 21:41:17 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=davidwei-uk.20230601.gappssmtp.com header.i=@davidwei-uk.20230601.gappssmtp.com header.b="ZPbJ/rM5"
X-Original-To: io-uring@vger.kernel.org
Received: from lindbergh.monkeyblade.net (lindbergh.monkeyblade.net [23.128.96.19])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id CC7942A8CA
	for <io-uring@vger.kernel.org>; Tue,  7 Nov 2023 21:41:13 +0000 (UTC)
Received: from mail-pj1-x1032.google.com (mail-pj1-x1032.google.com [IPv6:2607:f8b0:4864:20::1032])
	by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 6E7D810DF
	for <io-uring@vger.kernel.org>; Tue,  7 Nov 2023 13:41:13 -0800 (PST)
Received: by mail-pj1-x1032.google.com with SMTP id 98e67ed59e1d1-2800bb246ceso4635056a91.1
        for <io-uring@vger.kernel.org>; Tue, 07 Nov 2023 13:41:13 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=davidwei-uk.20230601.gappssmtp.com; s=20230601; t=1699393272; x=1699998072; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=Tamxuyrmc9V5WDiAondngZpJ00DNIyR1wLlFf3mWuNQ=;
        b=ZPbJ/rM5Tnj+cefBpWPBlXoyIu+xU80BiuU0t9YskyRFCPmeIDeHU/fjBvoN/Oe2n4
         RzCg630Ghrf6joNBMzrRhbkve/rF8m4nMcwPp8NthSvLy2Ug5yPytyE/Y+qb5barYg4m
         IX/DNKuzPkiFN/kBnJMelBCpb3LnqhL8kZnf9WAalaZZ0wg0/GG+yMmpJI/AHh+2h5Kt
         MW+TBCu7noOWFVfdaXyijdH9qyvXW4Jwr55GvO1R4MIRJ0wCJynigbDjx0oXZcvY4xoB
         LLTg/GBteXY5o7Z4NAnH8JkAGMpksgDDodXNax6wP7oJ2p5fAdnIKurD/5yI7t3WuicC
         oxeg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1699393272; x=1699998072;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=Tamxuyrmc9V5WDiAondngZpJ00DNIyR1wLlFf3mWuNQ=;
        b=J+vjeNDrU70uU5WlqDwl6cFSiWRdmNEuwmaAHiRrvfzgU4BE49J4yMpY1S5XWn9xnB
         Kq8fDX8G+4uPlPEdyxd9VrSxvF/DycbA2t6BXtKJy+GghAsFoF9sEVQM9NF5isHfBYK9
         B0BzaUDgnEaMRhzaFDSbbjtfKcm/ZBiaqpWKehKGObgQUrlEtg/BGyk5/Gdp+yxh8Yf+
         UPh26VFaJmT3CU/cPi1QNlebLSqKoIyV2/dapO4GSo1GVLSl6hW5DjbXH+x5zHEOwmDo
         R+y63mXcpRo+g03sPlcoJEVGYyVa4qNeAVaH+wmaaqIx+4pIG0nSO9oortQLOP2pNhU5
         32Tw==
X-Gm-Message-State: AOJu0YyYRyUz6D01ZKDJDFfRCfNxIr1haooOuou63yFu1N++r5s92bEP
	0fFyzuqrLAF5hvDZsd/LAxfFq5bSMz0Da4wFIzNHWQ==
X-Google-Smtp-Source: AGHT+IG96zwTBgW1kaJGEH38MmWnZ8QQVo84jeNgQowFRn8jQbKuxQkyDCagBqHMDZInNEFklcM3pA==
X-Received: by 2002:a17:90b:1bc7:b0:281:691:e58c with SMTP id oa7-20020a17090b1bc700b002810691e58cmr6076553pjb.37.1699393272478;
        Tue, 07 Nov 2023 13:41:12 -0800 (PST)
Received: from localhost (fwdproxy-prn-009.fbsv.net. [2a03:2880:ff:9::face:b00c])
        by smtp.gmail.com with ESMTPSA id a3-20020a17090acb8300b002774d7e2fefsm250892pju.36.2023.11.07.13.41.12
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 07 Nov 2023 13:41:12 -0800 (PST)
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
Subject: [PATCH 18/20] veth: add support for io_uring zc rx
Date: Tue,  7 Nov 2023 13:40:43 -0800
Message-Id: <20231107214045.2172393-19-dw@davidwei.uk>
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

From: Pavel Begunkov <asml.silence@gmail.com>

Dirty and hacky, testing only

Add io_uring zerocopy support for veth. It's not actually zerocopy, we
copy data in napi, which is early enough in the stack to be useful for
testing.

Signed-off-by: Pavel Begunkov <asml.silence@gmail.com>
Signed-off-by: David Wei <dw@davidwei.uk>
---
 drivers/net/veth.c | 179 ++++++++++++++++++++++++++++++++++++++++++++-
 io_uring/zc_rx.c   |  15 ++--
 2 files changed, 186 insertions(+), 8 deletions(-)

diff --git a/drivers/net/veth.c b/drivers/net/veth.c
index 0deefd1573cf..08420d43ac00 100644
--- a/drivers/net/veth.c
+++ b/drivers/net/veth.c
@@ -27,6 +27,8 @@
 #include <linux/bpf_trace.h>
 #include <linux/net_tstamp.h>
 #include <net/page_pool/helpers.h>
+#include <net/netdev_rx_queue.h>
+#include <net/data_pool.h>
 
 #define DRV_NAME	"veth"
 #define DRV_VERSION	"1.0"
@@ -67,6 +69,8 @@ struct veth_rq {
 	struct ptr_ring		xdp_ring;
 	struct xdp_rxq_info	xdp_rxq;
 	struct page_pool	*page_pool;
+
+	struct data_pool	zc_dp;
 };
 
 struct veth_priv {
@@ -75,6 +79,7 @@ struct veth_priv {
 	struct bpf_prog		*_xdp_prog;
 	struct veth_rq		*rq;
 	unsigned int		requested_headroom;
+	bool			zc_installed;
 };
 
 struct veth_xdp_tx_bq {
@@ -335,9 +340,12 @@ static bool veth_skb_is_eligible_for_gro(const struct net_device *dev,
 					 const struct net_device *rcv,
 					 const struct sk_buff *skb)
 {
+	struct veth_priv *rcv_priv = netdev_priv(rcv);
+
 	return !(dev->features & NETIF_F_ALL_TSO) ||
 		(skb->destructor == sock_wfree &&
-		 rcv->features & (NETIF_F_GRO_FRAGLIST | NETIF_F_GRO_UDP_FWD));
+		 rcv->features & (NETIF_F_GRO_FRAGLIST | NETIF_F_GRO_UDP_FWD)) ||
+		rcv_priv->zc_installed;
 }
 
 static netdev_tx_t veth_xmit(struct sk_buff *skb, struct net_device *dev)
@@ -828,6 +836,73 @@ static int veth_convert_skb_to_xdp_buff(struct veth_rq *rq,
 	return -ENOMEM;
 }
 
+static struct sk_buff *veth_iou_rcv_skb(struct veth_rq *rq,
+					struct sk_buff *skb)
+{
+	struct sk_buff *nskb;
+	u32 size, len, off, max_head_size;
+	struct page *page;
+	int ret, i, head_off;
+	void *vaddr;
+
+	skb_prepare_for_gro(skb);
+	max_head_size = skb_headlen(skb);
+
+	rcu_read_lock();
+	nskb = napi_alloc_skb(&rq->xdp_napi, max_head_size);
+	if (!nskb)
+		goto drop;
+
+	skb_zcopy_init(nskb, rq->zc_dp.zc_uarg);
+	skb_copy_header(nskb, skb);
+	skb_mark_for_recycle(nskb);
+
+	size = max_head_size;
+	if (skb_copy_bits(skb, 0, nskb->data, size)) {
+		consume_skb(nskb);
+		goto drop;
+	}
+	skb_put(nskb, size);
+	head_off = skb_headroom(nskb) - skb_headroom(skb);
+	skb_headers_offset_update(nskb, head_off);
+
+	/* Allocate paged area of new skb */
+	off = size;
+	len = skb->len - off;
+
+	for (i = 0; i < MAX_SKB_FRAGS && off < skb->len; i++) {
+		page = data_pool_alloc_page(&rq->zc_dp);
+		if (!page) {
+			consume_skb(nskb);
+			goto drop;
+		}
+
+		size = min_t(u32, len, PAGE_SIZE);
+		skb_add_rx_frag(nskb, i, page, 0, size, PAGE_SIZE);
+
+		vaddr = kmap_atomic(page);
+		ret = skb_copy_bits(skb, off, vaddr, size);
+		kunmap_atomic(vaddr);
+
+		if (ret) {
+			consume_skb(nskb);
+			goto drop;
+		}
+		len -= size;
+		off += size;
+	}
+	rcu_read_unlock();
+
+	consume_skb(skb);
+	skb = nskb;
+	return skb;
+drop:
+	rcu_read_unlock();
+	kfree_skb(skb);
+	return NULL;
+}
+
+
 static struct sk_buff *veth_xdp_rcv_skb(struct veth_rq *rq,
 					struct sk_buff *skb,
 					struct veth_xdp_tx_bq *bq,
@@ -971,8 +1046,13 @@ static int veth_xdp_rcv(struct veth_rq *rq, int budget,
 			/* ndo_start_xmit */
 			struct sk_buff *skb = ptr;
 
-			stats->xdp_bytes += skb->len;
-			skb = veth_xdp_rcv_skb(rq, skb, bq, stats);
+			if (!rq->zc_dp.zc_ifq) {
+				stats->xdp_bytes += skb->len;
+				skb = veth_xdp_rcv_skb(rq, skb, bq, stats);
+			} else {
+				skb = veth_iou_rcv_skb(rq, skb);
+			}
+
 			if (skb) {
 				if (skb_shared(skb) || skb_unclone(skb, GFP_ATOMIC))
 					netif_receive_skb(skb);
@@ -1351,6 +1431,9 @@ static int veth_set_channels(struct net_device *dev,
 	struct net_device *peer;
 	int err;
 
+	if (priv->zc_installed)
+		return -EINVAL;
+
 	/* sanity check. Upper bounds are already enforced by the caller */
 	if (!ch->rx_count || !ch->tx_count)
 		return -EINVAL;
@@ -1428,6 +1511,8 @@ static int veth_open(struct net_device *dev)
 	struct net_device *peer = rtnl_dereference(priv->peer);
 	int err;
 
+	priv->zc_installed = false;
+
 	if (!peer)
 		return -ENOTCONN;
 
@@ -1618,6 +1703,89 @@ static void veth_set_rx_headroom(struct net_device *dev, int new_hr)
 	rcu_read_unlock();
 }
 
+static int __veth_iou_set(struct net_device *dev,
+			  struct netdev_bpf *xdp)
+{
+	bool napi_already_on = veth_gro_requested(dev) && (dev->flags & IFF_UP);
+	unsigned qid = xdp->zc_rx.queue_id;
+	struct veth_priv *priv = netdev_priv(dev);
+	struct net_device *peer;
+	struct veth_rq *rq;
+	int ret;
+
+	if (priv->_xdp_prog)
+		return -EINVAL;
+	if (qid >= dev->real_num_rx_queues)
+		return -EINVAL;
+	if (!(dev->flags & IFF_UP))
+		return -EOPNOTSUPP;
+	if (dev->real_num_rx_queues != 1)
+		return -EINVAL;
+
+	rq = &priv->rq[qid];
+	if (!!rq->zc_dp.zc_ifq == !!xdp->zc_rx.ifq)
+		return -EINVAL;
+
+	if (rq->zc_dp.zc_ifq) {
+		veth_napi_del(dev);
+		rq->zc_dp.zc_ifq = NULL;
+		rq->zc_dp.page_pool = NULL;
+		rq->zc_dp.zc_uarg = NULL;
+		priv->zc_installed = false;
+
+		if (!veth_gro_requested(dev) && netif_running(dev)) {
+			dev->features &= ~NETIF_F_GRO;
+			netdev_features_change(dev);
+		}
+		return 0;
+	}
+
+	peer = rtnl_dereference(priv->peer);
+	peer->hw_features &= ~NETIF_F_GSO_SOFTWARE;
+
+	ret = veth_create_page_pool(rq);
+	if (ret)
+		return ret;
+
+	ret = ptr_ring_init(&rq->xdp_ring, VETH_RING_SIZE, GFP_KERNEL);
+	if (ret) {
+		page_pool_destroy(rq->page_pool);
+		rq->page_pool = NULL;
+		return ret;
+	}
+
+	rq->zc_dp.zc_ifq = xdp->zc_rx.ifq;
+	rq->zc_dp.zc_uarg = xdp->zc_rx.uarg;
+	rq->zc_dp.page_pool = rq->page_pool;
+	priv->zc_installed = true;
+
+	if (!veth_gro_requested(dev)) {
+		/* user-space did not require GRO, but adding XDP
+		 * is supposed to get GRO working
+		 */
+		dev->features |= NETIF_F_GRO;
+		netdev_features_change(dev);
+	}
+	if (!napi_already_on) {
+		netif_napi_add(dev, &rq->xdp_napi, veth_poll);
+		napi_enable(&rq->xdp_napi);
+		rcu_assign_pointer(rq->napi, &rq->xdp_napi);
+	}
+	io_zc_rx_set_napi(rq->zc_dp.zc_ifq, rq->xdp_napi.napi_id);
+	return 0;
+}
+
+static int veth_iou_set(struct net_device *dev,
+			struct netdev_bpf *xdp)
+{
+	int ret;
+
+	rtnl_lock();
+	ret = __veth_iou_set(dev, xdp);
+	rtnl_unlock();
+	return ret;
+}
+
 static int veth_xdp_set(struct net_device *dev, struct bpf_prog *prog,
 			struct netlink_ext_ack *extack)
 {
@@ -1627,6 +1795,9 @@ static int veth_xdp_set(struct net_device *dev, struct bpf_prog *prog,
 	unsigned int max_mtu;
 	int err;
 
+	if (priv->zc_installed)
+		return -EINVAL;
+
 	old_prog = priv->_xdp_prog;
 	priv->_xdp_prog = prog;
 	peer = rtnl_dereference(priv->peer);
@@ -1705,6 +1876,8 @@ static int veth_xdp(struct net_device *dev, struct netdev_bpf *xdp)
 	switch (xdp->command) {
 	case XDP_SETUP_PROG:
 		return veth_xdp_set(dev, xdp->prog, xdp->extack);
+	case XDP_SETUP_ZC_RX:
+		return veth_iou_set(dev, xdp);
 	default:
 		return -EINVAL;
 	}
diff --git a/io_uring/zc_rx.c b/io_uring/zc_rx.c
index 14328024a550..611a068c3402 100644
--- a/io_uring/zc_rx.c
+++ b/io_uring/zc_rx.c
@@ -122,11 +122,14 @@ static void io_zc_rx_skb_free(struct sk_buff *skb, struct ubuf_info *uarg,
 static int io_zc_rx_map_buf(struct device *dev, struct page *page, u16 pool_id,
 			    u32 pgid, struct io_zc_rx_buf *buf)
 {
-	dma_addr_t addr;
+	dma_addr_t addr = 0;
 
 	SetPagePrivate(page);
 	set_page_private(page, mk_page_info(pool_id, pgid));
 
+	if (!dev)
+		goto out;
+
 	addr = dma_map_page_attrs(dev, page, 0, PAGE_SIZE,
 				  DMA_BIDIRECTIONAL,
 				  DMA_ATTR_SKIP_CPU_SYNC);
@@ -135,7 +138,7 @@ static int io_zc_rx_map_buf(struct device *dev, struct page *page, u16 pool_id,
 		ClearPagePrivate(page);
 		return -ENOMEM;
 	}
-
+out:
 	buf->dma = addr;
 	buf->page = page;
 	atomic_set(&buf->refcount, 0);
@@ -151,9 +154,11 @@ static void io_zc_rx_unmap_buf(struct device *dev, struct io_zc_rx_buf *buf)
 	page = buf->page;
 	set_page_private(page, 0);
 	ClearPagePrivate(page);
-	dma_unmap_page_attrs(dev, buf->dma, PAGE_SIZE,
-			     DMA_BIDIRECTIONAL,
-			     DMA_ATTR_SKIP_CPU_SYNC);
+
+	if (dev)
+		dma_unmap_page_attrs(dev, buf->dma, PAGE_SIZE,
+				     DMA_BIDIRECTIONAL,
+				     DMA_ATTR_SKIP_CPU_SYNC);
 	put_page(page);
 }
 
-- 
2.39.3


