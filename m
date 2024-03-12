Return-Path: <io-uring+bounces-918-lists+io-uring=lfdr.de@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [147.75.199.223])
	by mail.lfdr.de (Postfix) with ESMTPS id CBC21879DD6
	for <lists+io-uring@lfdr.de>; Tue, 12 Mar 2024 22:48:06 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id EFA331C21837
	for <lists+io-uring@lfdr.de>; Tue, 12 Mar 2024 21:48:05 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 44D6B14601F;
	Tue, 12 Mar 2024 21:44:52 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=davidwei-uk.20230601.gappssmtp.com header.i=@davidwei-uk.20230601.gappssmtp.com header.b="H2vPnXv3"
X-Original-To: io-uring@vger.kernel.org
Received: from mail-pf1-f172.google.com (mail-pf1-f172.google.com [209.85.210.172])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 996BE146E69
	for <io-uring@vger.kernel.org>; Tue, 12 Mar 2024 21:44:50 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.210.172
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1710279892; cv=none; b=c2tGcQRgj/ffKL5EP5+yGuY4aDOYjxlxHIOSaBWMzJZYstbBL7Pq+nugYZztcQhK4Et3HYClvwhpNPhloInC1k/IwPKqLr9/W3+b/DZKxG8AqL2e9POOTFZMfqO70kgrQljaPJV3z41OG+FexTu7H8zgxQ80QFcew/ou99T9a6I=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1710279892; c=relaxed/simple;
	bh=/tu8OaqjGRKbIV/+P2KUk+/RprWqiM4IZ65Z0Qn3FRA=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=F/YJbv4AxPSWI9b7ZZgr1zrLQhvaEABCEv5UeWiU6ShC3IR5yhro92e99/ELDt3hutRQMXq7j3fnGHdfsxVIgWLARUfKxeqA9e+7NiDAl3Sg8Rda5+xQHIyEoErSJ4ohe1PVMCOzLpkOSjB0vQbz1Q5QPaQGMSU0gaiRXOFhj3w=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=davidwei.uk; spf=none smtp.mailfrom=davidwei.uk; dkim=pass (2048-bit key) header.d=davidwei-uk.20230601.gappssmtp.com header.i=@davidwei-uk.20230601.gappssmtp.com header.b=H2vPnXv3; arc=none smtp.client-ip=209.85.210.172
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=davidwei.uk
Authentication-Results: smtp.subspace.kernel.org; spf=none smtp.mailfrom=davidwei.uk
Received: by mail-pf1-f172.google.com with SMTP id d2e1a72fcca58-6e5dddd3b95so221775b3a.1
        for <io-uring@vger.kernel.org>; Tue, 12 Mar 2024 14:44:50 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=davidwei-uk.20230601.gappssmtp.com; s=20230601; t=1710279889; x=1710884689; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=7Byha3rgEcVqJGeCwdpNjvlHNAMt1U8ih/ENexG1tbU=;
        b=H2vPnXv3/xChQJF93NEaRsLZmPxjrvonsn7s508F3MhoXgvfjv30uuhy+nRzZXfMbr
         SVSNOeeX7L5GWDsL6vL+/V06wkckFOO/lvNbV1zL9jJg//fWFLT5QRv/5tmGqd2olons
         +rVKBu7WjKuQr+tjqJtCejNlsMNDrrgQRJoS1Y0HmHsbYM3kIg2oUB43SojpK03pBeBp
         Fsekue/drGyBSMyuMffZH+1w+2jZRyBCUvI4YEowcbGwTV5BUgnazfRqAQTmWO0y77Jl
         FfmAe+M8kTXrxPjuZdbvKzxKxcJA4JNMMKPwv7G3vbgQ+IecB+Wf7znuZkfepf6PXAlT
         T+CQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1710279889; x=1710884689;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=7Byha3rgEcVqJGeCwdpNjvlHNAMt1U8ih/ENexG1tbU=;
        b=aqkwuwvLOx50AesnB7uR34oVZPyJg8E+f0Bc+u/YF4NjP1Fo2FbBXiTcSvDLmYO2Ju
         uZPHtGHR8ufcuoGDTwnbRBd8BPaGPf+gEw1Pi4JhTykdOCaCTKXjblD8bS4qvHd6xGIM
         sEQxtD6xTuYiaNci178YShs3TLRfd3lN7uEbdqfL7Jb+NT+aNC9yE3kh1dWWukArrcem
         OGwX0KEZ1xv4hL/lYRhb+QbsalbwdZoGyg0tCvhXe6SCBBcPnKERsWEHZ7LFDRP1hEZN
         7TFrDhKoBNowStOnj3X/97glarmOXTfdiPvUDFVcIroAff03Umfnx7J3QFdNSZcw80XG
         xMJA==
X-Gm-Message-State: AOJu0YzA4uJHrgXHpeOecKzEx+GfuzSfCFUZ2NiYbkmtLiyNj2iR6JXo
	23jr2Ve1drzJlIL62ovruu7xe9y3O/uniTfzSghKbnA9EVGYDOdr0OXUmqGBPGPuVgWr4v2zUaL
	y
X-Google-Smtp-Source: AGHT+IFeQGe+SoZYHD9gW4lOdyAL/Eqt5tURDQaxCC+tNryp+pFHXVOaS3pOK8fBrf9BwedyA6o9IQ==
X-Received: by 2002:a05:6a00:cd2:b0:6e6:b4f3:19ec with SMTP id b18-20020a056a000cd200b006e6b4f319ecmr753596pfv.7.1710279889564;
        Tue, 12 Mar 2024 14:44:49 -0700 (PDT)
Received: from localhost (fwdproxy-prn-013.fbsv.net. [2a03:2880:ff:d::face:b00c])
        by smtp.gmail.com with ESMTPSA id d8-20020a056a0010c800b006e685c36d41sm5201452pfu.55.2024.03.12.14.44.49
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 12 Mar 2024 14:44:49 -0700 (PDT)
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
Subject: [RFC PATCH v4 16/16] veth: add support for io_uring zc rx
Date: Tue, 12 Mar 2024 14:44:30 -0700
Message-ID: <20240312214430.2923019-17-dw@davidwei.uk>
X-Mailer: git-send-email 2.43.0
In-Reply-To: <20240312214430.2923019-1-dw@davidwei.uk>
References: <20240312214430.2923019-1-dw@davidwei.uk>
Precedence: bulk
X-Mailing-List: io-uring@vger.kernel.org
List-Id: <io-uring.vger.kernel.org>
List-Subscribe: <mailto:io-uring+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:io-uring+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

From: Pavel Begunkov <asml.silence@gmail.com>

Not for upstream, testing only

Add io_uring zerocopy support for veth. It's not truly zerocopy, the
data is copied in napi, but that's early in the stack and so useful
for now for testing.

Signed-off-by: Pavel Begunkov <asml.silence@gmail.com>
Signed-off-by: David Wei <dw@davidwei.uk>
---
 drivers/net/veth.c | 214 +++++++++++++++++++++++++++++++++++++++++++--
 1 file changed, 208 insertions(+), 6 deletions(-)

diff --git a/drivers/net/veth.c b/drivers/net/veth.c
index 500b9dfccd08..b56e06113453 100644
--- a/drivers/net/veth.c
+++ b/drivers/net/veth.c
@@ -26,6 +26,8 @@
 #include <linux/ptr_ring.h>
 #include <linux/bpf_trace.h>
 #include <linux/net_tstamp.h>
+#include <linux/io_uring/net.h>
+#include <net/netdev_rx_queue.h>
 #include <net/page_pool/helpers.h>
 
 #define DRV_NAME	"veth"
@@ -67,6 +69,7 @@ struct veth_rq {
 	struct ptr_ring		xdp_ring;
 	struct xdp_rxq_info	xdp_rxq;
 	struct page_pool	*page_pool;
+	struct netdev_rx_queue	rq;
 };
 
 struct veth_priv {
@@ -75,6 +78,7 @@ struct veth_priv {
 	struct bpf_prog		*_xdp_prog;
 	struct veth_rq		*rq;
 	unsigned int		requested_headroom;
+	bool			zc_installed;
 };
 
 struct veth_xdp_tx_bq {
@@ -335,9 +339,12 @@ static bool veth_skb_is_eligible_for_gro(const struct net_device *dev,
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
@@ -726,6 +733,9 @@ static int veth_convert_skb_to_xdp_buff(struct veth_rq *rq,
 	struct sk_buff *skb = *pskb;
 	u32 frame_sz;
 
+	if (WARN_ON_ONCE(1))
+		return -EFAULT;
+
 	if (skb_shared(skb) || skb_head_is_locked(skb) ||
 	    skb_shinfo(skb)->nr_frags ||
 	    skb_headroom(skb) < XDP_PACKET_HEADROOM) {
@@ -758,6 +768,90 @@ static int veth_convert_skb_to_xdp_buff(struct veth_rq *rq,
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
+		netmem_ref netmem;
+
+		netmem = page_pool_alloc_netmem(rq->page_pool, GFP_ATOMIC | __GFP_NOWARN);
+		if (!netmem) {
+			consume_skb(nskb);
+			goto drop;
+		}
+		if (WARN_ON_ONCE(!netmem_is_net_iov(netmem))) {
+			consume_skb(nskb);
+			goto drop;
+		}
+
+		buf = container_of(netmem_to_net_iov(netmem),
+				   struct io_zc_rx_buf, niov);
+		page = buf->page;
+
+		if (WARN_ON_ONCE(buf->niov.pp != rq->page_pool))
+			goto drop;
+
+		size = min_t(u32, len, PAGE_SIZE);
+		skb_add_rx_frag_netmem(nskb, i, netmem, 0, size, PAGE_SIZE);
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
@@ -901,8 +995,13 @@ static int veth_xdp_rcv(struct veth_rq *rq, int budget,
 			/* ndo_start_xmit */
 			struct sk_buff *skb = ptr;
 
-			stats->xdp_bytes += skb->len;
-			skb = veth_xdp_rcv_skb(rq, skb, bq, stats);
+			if (rq->page_pool->mp_ops == &io_uring_pp_zc_ops) {
+				skb = veth_iou_rcv_skb(rq, skb);
+			} else {
+				stats->xdp_bytes += skb->len;
+				skb = veth_xdp_rcv_skb(rq, skb, bq, stats);
+			}
+
 			if (skb) {
 				if (skb_shared(skb) || skb_unclone(skb, GFP_ATOMIC))
 					netif_receive_skb(skb);
@@ -961,15 +1060,22 @@ static int veth_poll(struct napi_struct *napi, int budget)
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
+		rq->rq.pp_private = ifq;
+		rq->rq.pp_ops = &io_uring_pp_zc_ops;
+		pp_params.queue = &rq->rq;
+	}
+
 	rq->page_pool = page_pool_create(&pp_params);
 	if (IS_ERR(rq->page_pool)) {
 		int err = PTR_ERR(rq->page_pool);
@@ -987,7 +1093,7 @@ static int __veth_napi_enable_range(struct net_device *dev, int start, int end)
 	int err, i;
 
 	for (i = start; i < end; i++) {
-		err = veth_create_page_pool(&priv->rq[i]);
+		err = veth_create_page_pool(&priv->rq[i], NULL);
 		if (err)
 			goto err_page_pool;
 	}
@@ -1043,9 +1149,17 @@ static void veth_napi_del_range(struct net_device *dev, int start, int end)
 
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
@@ -1281,6 +1395,9 @@ static int veth_set_channels(struct net_device *dev,
 	struct net_device *peer;
 	int err;
 
+	if (priv->zc_installed)
+		return -EINVAL;
+
 	/* sanity check. Upper bounds are already enforced by the caller */
 	if (!ch->rx_count || !ch->tx_count)
 		return -EINVAL;
@@ -1358,6 +1475,8 @@ static int veth_open(struct net_device *dev)
 	struct net_device *peer = rtnl_dereference(priv->peer);
 	int err;
 
+	priv->zc_installed = false;
+
 	if (!peer)
 		return -ENOTCONN;
 
@@ -1536,6 +1655,84 @@ static void veth_set_rx_headroom(struct net_device *dev, int new_hr)
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
@@ -1545,6 +1742,9 @@ static int veth_xdp_set(struct net_device *dev, struct bpf_prog *prog,
 	unsigned int max_mtu;
 	int err;
 
+	if (priv->zc_installed)
+		return -EINVAL;
+
 	old_prog = priv->_xdp_prog;
 	priv->_xdp_prog = prog;
 	peer = rtnl_dereference(priv->peer);
@@ -1623,6 +1823,8 @@ static int veth_xdp(struct net_device *dev, struct netdev_bpf *xdp)
 	switch (xdp->command) {
 	case XDP_SETUP_PROG:
 		return veth_xdp_set(dev, xdp->prog, xdp->extack);
+	case XDP_SETUP_ZC_RX:
+		return veth_iou_set(dev, xdp);
 	default:
 		return -EINVAL;
 	}
-- 
2.43.0


