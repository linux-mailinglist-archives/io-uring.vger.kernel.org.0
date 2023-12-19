Return-Path: <io-uring+bounces-317-lists+io-uring=lfdr.de@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [139.178.88.99])
	by mail.lfdr.de (Postfix) with ESMTPS id 635C4819207
	for <lists+io-uring@lfdr.de>; Tue, 19 Dec 2023 22:06:15 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 1C26228295F
	for <lists+io-uring@lfdr.de>; Tue, 19 Dec 2023 21:06:14 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id C49A540C03;
	Tue, 19 Dec 2023 21:04:24 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=davidwei-uk.20230601.gappssmtp.com header.i=@davidwei-uk.20230601.gappssmtp.com header.b="EJ4kPyrn"
X-Original-To: io-uring@vger.kernel.org
Received: from mail-oo1-f43.google.com (mail-oo1-f43.google.com [209.85.161.43])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 329DF40BF3
	for <io-uring@vger.kernel.org>; Tue, 19 Dec 2023 21:04:23 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=davidwei.uk
Authentication-Results: smtp.subspace.kernel.org; spf=none smtp.mailfrom=davidwei.uk
Received: by mail-oo1-f43.google.com with SMTP id 006d021491bc7-591c3dc7265so2418596eaf.0
        for <io-uring@vger.kernel.org>; Tue, 19 Dec 2023 13:04:23 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=davidwei-uk.20230601.gappssmtp.com; s=20230601; t=1703019862; x=1703624662; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=cIyS0qBLv2Ng8nfVCtfxHFE9coSuv9Yrxpz6D1RsN7A=;
        b=EJ4kPyrnCLitPryvfTEVArLlCVcYyLCXDto2g82tCT15oFvzVGUgRzScnbWKo6qEjv
         9PCMqpC/OZkop3Eazrw6kRU+gA+eu1zYgodHDmcg9wgN68d5zaa7PPn8XZgpOfPYz+ld
         7pai523V4SNVMAVmovIRUL7SiX5wLuGxt5Csliv0OLj3sP8rdYx92xliFvXmuHHcOHWo
         AmeTgpiebhyqVIuXXDBfnFqm1eSy+r5SgZDbbW27K4QfQAq3TMl1GSa3PwcoDx02QUve
         6MY7KDLmI98kjRbwYMLS+4jNiX5dbBL+I2iNSX4KxwrLjzWE7GvftT4jl/GyuoE+hXLb
         Sfhg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1703019862; x=1703624662;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=cIyS0qBLv2Ng8nfVCtfxHFE9coSuv9Yrxpz6D1RsN7A=;
        b=b7+xSoA4BlFNE69++XXJmT8irUNy70Py3YD08Gemo9z784TIyFrlxooClv7+Ih96Br
         H4Fe2hUe4cKWmq5GvJju9RrdOGnjzjrxdsk5ZkD+l7i1SNRbk1Jsx8AGL/x+RUccJjmC
         Mw+1VlED7KTOIjVbRM5KfalZtpJkamMDp5yqym7va7fDnzyFp36jokqnlFgNOSk0A0T7
         ZMJ3FxK8tmpOrhCVmMXnsz2O+5m4c47r12/Q4KoDwQlpiZ6jm7+X6pnWNvYELECCP/c0
         7A6PhtpRyMv/gBKLZJeWhyh7xJDv8YTCbwFwnWPpQ0ko7bA96WpDbRytn9FCxfk/bO/1
         c1GA==
X-Gm-Message-State: AOJu0Yzv9ZJWMqTSOdHdFbUGiDPrzK3EuY9bG0feORQfQ7P3pLEGZlo4
	nVPNswm90lq/CTdV0n2dFMT+J1SNsqR5fSH1PuAfUw==
X-Google-Smtp-Source: AGHT+IFvVsl5rOhi1y2F4/tSu5S+c7GqtoW/ErMsl6lkfBz1N/WlWCxRk6BDJFQtIHdc0xjgKGXyDA==
X-Received: by 2002:a05:6358:c325:b0:173:50b:26ed with SMTP id fk37-20020a056358c32500b00173050b26edmr286038rwb.36.1703019862058;
        Tue, 19 Dec 2023 13:04:22 -0800 (PST)
Received: from localhost (fwdproxy-prn-005.fbsv.net. [2a03:2880:ff:5::face:b00c])
        by smtp.gmail.com with ESMTPSA id e7-20020a056a001a8700b006ce835b77d9sm3615155pfv.20.2023.12.19.13.04.21
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 19 Dec 2023 13:04:21 -0800 (PST)
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
Subject: [RFC PATCH v3 18/20] veth: add support for io_uring zc rx
Date: Tue, 19 Dec 2023 13:03:55 -0800
Message-Id: <20231219210357.4029713-19-dw@davidwei.uk>
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

NOT FOR UPSTREAM, TESTING ONLY.

Add io_uring zerocopy support for veth. It's not actually zerocopy, we
copy data in napi, which is early enough in the stack to be useful for
testing.

Note, we'll need some virtual dev support for testing, but that should
not be in the way of real workloads.

Signed-off-by: David Wei <dw@davidwei.uk>
---
 drivers/net/veth.c | 211 +++++++++++++++++++++++++++++++++++++++++++--
 1 file changed, 205 insertions(+), 6 deletions(-)

diff --git a/drivers/net/veth.c b/drivers/net/veth.c
index 57efb3454c57..dd00e172979f 100644
--- a/drivers/net/veth.c
+++ b/drivers/net/veth.c
@@ -26,6 +26,7 @@
 #include <linux/ptr_ring.h>
 #include <linux/bpf_trace.h>
 #include <linux/net_tstamp.h>
+#include <linux/io_uring/net.h>
 #include <net/page_pool/helpers.h>
 
 #define DRV_NAME	"veth"
@@ -75,6 +76,7 @@ struct veth_priv {
 	struct bpf_prog		*_xdp_prog;
 	struct veth_rq		*rq;
 	unsigned int		requested_headroom;
+	bool			zc_installed;
 };
 
 struct veth_xdp_tx_bq {
@@ -335,9 +337,12 @@ static bool veth_skb_is_eligible_for_gro(const struct net_device *dev,
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
@@ -726,6 +731,9 @@ static int veth_convert_skb_to_xdp_buff(struct veth_rq *rq,
 	struct sk_buff *skb = *pskb;
 	u32 frame_sz;
 
+	if (WARN_ON_ONCE(1))
+		return -EFAULT;
+
 	if (skb_shared(skb) || skb_head_is_locked(skb) ||
 	    skb_shinfo(skb)->nr_frags ||
 	    skb_headroom(skb) < XDP_PACKET_HEADROOM) {
@@ -827,6 +835,90 @@ static int veth_convert_skb_to_xdp_buff(struct veth_rq *rq,
 	return -ENOMEM;
 }
 
+static noinline struct sk_buff *veth_iou_rcv_skb(struct veth_rq *rq,
+					struct sk_buff *skb)
+{
+	struct sk_buff *nskb;
+	u32 size, len, off, max_head_size;
+	struct page *page;
+	int ret, i, head_off;
+	void *vaddr;
+
+	/* Testing only, randomly send normal pages to test copy fallback */
+	if (ktime_get_ns() % 16 == 0)
+		return skb;
+
+	skb_prepare_for_gro(skb);
+	max_head_size = skb_headlen(skb);
+
+	rcu_read_lock();
+	nskb = napi_alloc_skb(&rq->xdp_napi, max_head_size);
+	if (!nskb)
+		goto drop;
+
+	skb_copy_header(nskb, skb);
+	skb_mark_for_recycle(nskb);
+
+	size = max_head_size;
+	if (skb_copy_bits(skb, 0, nskb->data, size)) {
+	consume_skb(nskb);
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
+		struct io_zc_rx_buf *buf;
+		void *ppage;
+
+		ppage = page_pool_dev_alloc_pages(rq->page_pool);
+		if (!ppage) {
+			consume_skb(nskb);
+			goto drop;
+		}
+		if (WARN_ON_ONCE(!page_is_page_pool_iov(ppage))) {
+			consume_skb(nskb);
+			goto drop;
+		}
+
+		buf = container_of(page_to_page_pool_iov(ppage),
+				   struct io_zc_rx_buf, ppiov);
+		page = buf->page;
+
+		if (WARN_ON_ONCE(buf->ppiov.pp != rq->page_pool))
+			goto drop;
+
+		size = min_t(u32, len, PAGE_SIZE);
+		skb_add_rx_frag(nskb, i, ppage, 0, size, PAGE_SIZE);
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
@@ -970,8 +1062,13 @@ static int veth_xdp_rcv(struct veth_rq *rq, int budget,
 			/* ndo_start_xmit */
 			struct sk_buff *skb = ptr;
 
-			stats->xdp_bytes += skb->len;
-			skb = veth_xdp_rcv_skb(rq, skb, bq, stats);
+			if (rq->page_pool->p.memory_provider == PP_MP_IOU_ZCRX) {
+				skb = veth_iou_rcv_skb(rq, skb);
+			} else {
+				stats->xdp_bytes += skb->len;
+				skb = veth_xdp_rcv_skb(rq, skb, bq, stats);
+			}
+
 			if (skb) {
 				if (skb_shared(skb) || skb_unclone(skb, GFP_ATOMIC))
 					netif_receive_skb(skb);
@@ -1030,15 +1127,21 @@ static int veth_poll(struct napi_struct *napi, int budget)
 	return done;
 }
 
-static int veth_create_page_pool(struct veth_rq *rq)
+static int veth_create_page_pool(struct veth_rq *rq, struct io_zc_rx_ifq *ifq)
 {
 	struct page_pool_params pp_params = {
 		.order = 0,
 		.pool_size = VETH_RING_SIZE,
 		.nid = NUMA_NO_NODE,
 		.dev = &rq->dev->dev,
+		.napi = &rq->xdp_napi,
 	};
 
+	if (ifq) {
+		pp_params.mp_priv = ifq;
+		pp_params.memory_provider = PP_MP_IOU_ZCRX;
+	}
+
 	rq->page_pool = page_pool_create(&pp_params);
 	if (IS_ERR(rq->page_pool)) {
 		int err = PTR_ERR(rq->page_pool);
@@ -1056,7 +1159,7 @@ static int __veth_napi_enable_range(struct net_device *dev, int start, int end)
 	int err, i;
 
 	for (i = start; i < end; i++) {
-		err = veth_create_page_pool(&priv->rq[i]);
+		err = veth_create_page_pool(&priv->rq[i], NULL);
 		if (err)
 			goto err_page_pool;
 	}
@@ -1112,9 +1215,17 @@ static void veth_napi_del_range(struct net_device *dev, int start, int end)
 
 	for (i = start; i < end; i++) {
 		struct veth_rq *rq = &priv->rq[i];
+		void *ptr;
+		int nr = 0;
 
 		rq->rx_notify_masked = false;
-		ptr_ring_cleanup(&rq->xdp_ring, veth_ptr_free);
+
+		while ((ptr = ptr_ring_consume(&rq->xdp_ring))) {
+			veth_ptr_free(ptr);
+			nr++;
+		}
+
+		ptr_ring_cleanup(&rq->xdp_ring, NULL);
 	}
 
 	for (i = start; i < end; i++) {
@@ -1350,6 +1461,9 @@ static int veth_set_channels(struct net_device *dev,
 	struct net_device *peer;
 	int err;
 
+	if (priv->zc_installed)
+		return -EINVAL;
+
 	/* sanity check. Upper bounds are already enforced by the caller */
 	if (!ch->rx_count || !ch->tx_count)
 		return -EINVAL;
@@ -1427,6 +1541,8 @@ static int veth_open(struct net_device *dev)
 	struct net_device *peer = rtnl_dereference(priv->peer);
 	int err;
 
+	priv->zc_installed = false;
+
 	if (!peer)
 		return -ENOTCONN;
 
@@ -1604,6 +1720,84 @@ static void veth_set_rx_headroom(struct net_device *dev, int new_hr)
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
+	rq = &priv->rq[qid];
+
+	if (!xdp->zc_rx.ifq) {
+		if (!priv->zc_installed)
+			return -EINVAL;
+
+		veth_napi_del(dev);
+		priv->zc_installed = false;
+		if (!veth_gro_requested(dev) && netif_running(dev)) {
+			dev->features &= ~NETIF_F_GRO;
+			netdev_features_change(dev);
+		}
+		return 0;
+	}
+
+	if (priv->zc_installed)
+		return -EINVAL;
+
+	peer = rtnl_dereference(priv->peer);
+	peer->hw_features &= ~NETIF_F_GSO_SOFTWARE;
+
+	ret = veth_create_page_pool(rq, xdp->zc_rx.ifq);
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
@@ -1613,6 +1807,9 @@ static int veth_xdp_set(struct net_device *dev, struct bpf_prog *prog,
 	unsigned int max_mtu;
 	int err;
 
+	if (priv->zc_installed)
+		return -EINVAL;
+
 	old_prog = priv->_xdp_prog;
 	priv->_xdp_prog = prog;
 	peer = rtnl_dereference(priv->peer);
@@ -1691,6 +1888,8 @@ static int veth_xdp(struct net_device *dev, struct netdev_bpf *xdp)
 	switch (xdp->command) {
 	case XDP_SETUP_PROG:
 		return veth_xdp_set(dev, xdp->prog, xdp->extack);
+	case XDP_SETUP_ZC_RX:
+		return veth_iou_set(dev, xdp);
 	default:
 		return -EINVAL;
 	}
-- 
2.39.3


