Return-Path: <io-uring+bounces-310-lists+io-uring=lfdr.de@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from sy.mirrors.kernel.org (sy.mirrors.kernel.org [IPv6:2604:1380:40f1:3f00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 74B048191FA
	for <lists+io-uring@lfdr.de>; Tue, 19 Dec 2023 22:05:30 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sy.mirrors.kernel.org (Postfix) with ESMTPS id 81BB5B222AB
	for <lists+io-uring@lfdr.de>; Tue, 19 Dec 2023 21:05:27 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 483063EA94;
	Tue, 19 Dec 2023 21:04:19 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=davidwei-uk.20230601.gappssmtp.com header.i=@davidwei-uk.20230601.gappssmtp.com header.b="QHalPbvH"
X-Original-To: io-uring@vger.kernel.org
Received: from mail-pj1-f45.google.com (mail-pj1-f45.google.com [209.85.216.45])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3ECD63D0D9
	for <io-uring@vger.kernel.org>; Tue, 19 Dec 2023 21:04:16 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=davidwei.uk
Authentication-Results: smtp.subspace.kernel.org; spf=none smtp.mailfrom=davidwei.uk
Received: by mail-pj1-f45.google.com with SMTP id 98e67ed59e1d1-28b71490fbbso1613341a91.0
        for <io-uring@vger.kernel.org>; Tue, 19 Dec 2023 13:04:16 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=davidwei-uk.20230601.gappssmtp.com; s=20230601; t=1703019856; x=1703624656; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=tJ8hPjWHfatZ/BzlXTQEl7ypf6OdinK6dQcdfVsR+fI=;
        b=QHalPbvH6VAGFB+ML/YOP8G66Y1pJOMJ7PVotVN4kS9dVIi9GujUUEApSeSm/i+QjS
         ZyI0Ejrw0PxFYXM6lwHRKlz88kYi+JIXzg+JKp8Y6fKNccsYHHG5HfcwvbuP1arjpYsq
         Xlrpvg4hBF2h8K3ak0lKLYxC5WRPZiB/pCFrxpjLLoNylbzUyjoyyBpU6hdV6Vlew38r
         yutxbLnF9S9BqJOQ06JCLB4UnfCZ+C/ZaD3n7M60VxBg0AN+41mwRoHP2SMSZBU/xEKA
         8V+SuB/OZpfJWGSuRXeJcFomQ72iw1Z0bt1UfyWmTPRmkdjlIGb0VzqjZ55g/lF4vIy1
         9VIQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1703019856; x=1703624656;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=tJ8hPjWHfatZ/BzlXTQEl7ypf6OdinK6dQcdfVsR+fI=;
        b=XAAfCQ9+eWfxfoG8y2g+eLi+DRUmjZaCE6HSGR8eArHoydL/cWc/dDv6KsNgc2IpOT
         mLxyoQjK2ejpZHoP0/3c2K2ZgFs3kEiTsdIAoobgrDaWdIOKreHp0mex2kAiucfT8pHt
         ZdrviHpMGts94ntCwyWUoG4QgX//4IxUue0MkZYpurN4GoZQy6J7WOA1GjuQIRK2PBVj
         VVKnR7pP6h2Hrjufr8MpOaqD6d43QhTZLZJjyy9NUAdbRRcFBHNi9bSBjPZVl231Zypz
         EKRS8KuyptmvUYdxkIHT5+KQ32m2cXoFHHavEJP9uYmSIZ8spKUpNu2uRIsdhWeToYVc
         SRhQ==
X-Gm-Message-State: AOJu0Yx4mokwziNm9TfmpdOEqn6Yi5zCFPhOZEiBEzri/CMWAEaq0B2h
	3ecFfZ2pUiglrdqdcnvTlIsY4i05IW/8yTiEOK+Asw==
X-Google-Smtp-Source: AGHT+IHvfTVtAhN39iKMzYo0U58+EnVbhBRtZTa0KHZT79kAWK1dvewUF2g8Zu6YRl+BF77iiu/Htw==
X-Received: by 2002:a17:90a:a40b:b0:28b:440f:766d with SMTP id y11-20020a17090aa40b00b0028b440f766dmr2611424pjp.90.1703019856226;
        Tue, 19 Dec 2023 13:04:16 -0800 (PST)
Received: from localhost (fwdproxy-prn-020.fbsv.net. [2a03:2880:ff:14::face:b00c])
        by smtp.gmail.com with ESMTPSA id u12-20020a17090a890c00b0028bbd30172csm1965513pjn.56.2023.12.19.13.04.15
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 19 Dec 2023 13:04:15 -0800 (PST)
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
Subject: [RFC PATCH v3 12/20] io_uring: add ZC buf and pool
Date: Tue, 19 Dec 2023 13:03:49 -0800
Message-Id: <20231219210357.4029713-13-dw@davidwei.uk>
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

From: David Wei <davidhwei@meta.com>

[TODO: REVIEW COMMIT MESSAGE]

This patch adds two objects:

* Zero copy buffer representation, holding a page, its mapped dma_addr,
  and a refcount for lifetime management.
* Zero copy pool, spiritually similar to page pool, that holds ZC bufs
  and hands them out to net devices.

Pool regions are registered w/ io_uring using the registered buffer API,
with a 1:1 mapping between region and nr_iovec in
io_uring_register_buffers. This does the heavy lifting of pinning and
chunking into bvecs into a struct io_mapped_ubuf for us.

For now as there is only one pool region per ifq, there is no separate
API for adding/removing regions yet and it is mapped implicitly during
ifq registration.

Signed-off-by: David Wei <dw@davidwei.uk>
---
 include/linux/io_uring/net.h |   8 +++
 io_uring/zc_rx.c             | 135 ++++++++++++++++++++++++++++++++++-
 io_uring/zc_rx.h             |  15 ++++
 3 files changed, 157 insertions(+), 1 deletion(-)

diff --git a/include/linux/io_uring/net.h b/include/linux/io_uring/net.h
index b58f39fed4d5..d994d26116d0 100644
--- a/include/linux/io_uring/net.h
+++ b/include/linux/io_uring/net.h
@@ -2,8 +2,16 @@
 #ifndef _LINUX_IO_URING_NET_H
 #define _LINUX_IO_URING_NET_H
 
+#include <net/page_pool/types.h>
+
 struct io_uring_cmd;
 
+struct io_zc_rx_buf {
+	struct page_pool_iov	ppiov;
+	struct page		*page;
+	dma_addr_t		dma;
+};
+
 #if defined(CONFIG_IO_URING)
 int io_uring_cmd_sock(struct io_uring_cmd *cmd, unsigned int issue_flags);
 
diff --git a/io_uring/zc_rx.c b/io_uring/zc_rx.c
index 06e2c54d3f3d..1e656b481725 100644
--- a/io_uring/zc_rx.c
+++ b/io_uring/zc_rx.c
@@ -5,6 +5,7 @@
 #include <linux/mm.h>
 #include <linux/io_uring.h>
 #include <linux/netdevice.h>
+#include <linux/nospec.h>
 
 #include <uapi/linux/io_uring.h>
 
@@ -15,6 +16,11 @@
 
 typedef int (*bpf_op_t)(struct net_device *dev, struct netdev_bpf *bpf);
 
+static inline struct device *netdev2dev(struct net_device *dev)
+{
+	return dev->dev.parent;
+}
+
 static int __io_queue_mgmt(struct net_device *dev, struct io_zc_rx_ifq *ifq,
 			   u16 queue_id)
 {
@@ -67,6 +73,129 @@ static void io_free_rbuf_ring(struct io_zc_rx_ifq *ifq)
 		folio_put(virt_to_folio(ifq->ring));
 }
 
+static int io_zc_rx_init_buf(struct device *dev, struct page *page, u16 pool_id,
+			     u32 pgid, struct io_zc_rx_buf *buf)
+{
+	dma_addr_t addr = 0;
+
+	/* Skip dma setup for devices that don't do any DMA transfers */
+	if (dev) {
+		addr = dma_map_page_attrs(dev, page, 0, PAGE_SIZE,
+					  DMA_BIDIRECTIONAL,
+					  DMA_ATTR_SKIP_CPU_SYNC);
+		if (dma_mapping_error(dev, addr))
+			return -ENOMEM;
+	}
+
+	buf->dma = addr;
+	buf->page = page;
+	refcount_set(&buf->ppiov.refcount, 0);
+	buf->ppiov.owner = NULL;
+	buf->ppiov.pp = NULL;
+	get_page(page);
+	return 0;
+}
+
+static void io_zc_rx_free_buf(struct device *dev, struct io_zc_rx_buf *buf)
+{
+	struct page *page = buf->page;
+
+	if (dev)
+		dma_unmap_page_attrs(dev, buf->dma, PAGE_SIZE,
+				     DMA_BIDIRECTIONAL,
+				     DMA_ATTR_SKIP_CPU_SYNC);
+	put_page(page);
+}
+
+static int io_zc_rx_map_pool(struct io_zc_rx_pool *pool,
+			     struct io_mapped_ubuf *imu,
+			     struct device *dev)
+{
+	struct io_zc_rx_buf *buf;
+	struct page *page;
+	int i, ret;
+
+	for (i = 0; i < imu->nr_bvecs; i++) {
+		page = imu->bvec[i].bv_page;
+		buf = &pool->bufs[i];
+		ret = io_zc_rx_init_buf(dev, page, pool->pool_id, i, buf);
+		if (ret)
+			goto err;
+
+		pool->freelist[i] = i;
+	}
+
+	pool->free_count = imu->nr_bvecs;
+	return 0;
+err:
+	while (i--) {
+		buf = &pool->bufs[i];
+		io_zc_rx_free_buf(dev, buf);
+	}
+	return ret;
+}
+
+static int io_zc_rx_create_pool(struct io_ring_ctx *ctx,
+				struct io_zc_rx_ifq *ifq,
+				u16 id)
+{
+	struct device *dev = netdev2dev(ifq->dev);
+	struct io_mapped_ubuf *imu;
+	struct io_zc_rx_pool *pool;
+	int nr_pages;
+	int ret;
+
+	if (ifq->pool)
+		return -EFAULT;
+
+	if (unlikely(id >= ctx->nr_user_bufs))
+		return -EFAULT;
+	id = array_index_nospec(id, ctx->nr_user_bufs);
+	imu = ctx->user_bufs[id];
+	if (imu->ubuf & ~PAGE_MASK || imu->ubuf_end & ~PAGE_MASK)
+		return -EFAULT;
+
+	ret = -ENOMEM;
+	nr_pages = imu->nr_bvecs;
+	pool = kvmalloc(struct_size(pool, freelist, nr_pages), GFP_KERNEL);
+	if (!pool)
+		goto err;
+
+	pool->bufs = kvmalloc_array(nr_pages, sizeof(*pool->bufs), GFP_KERNEL);
+	if (!pool->bufs)
+		goto err_buf;
+
+	ret = io_zc_rx_map_pool(pool, imu, dev);
+	if (ret)
+		goto err_map;
+
+	pool->ifq = ifq;
+	pool->pool_id = id;
+	pool->nr_bufs = nr_pages;
+	spin_lock_init(&pool->freelist_lock);
+	ifq->pool = pool;
+	return 0;
+err_map:
+	kvfree(pool->bufs);
+err_buf:
+	kvfree(pool);
+err:
+	return ret;
+}
+
+static void io_zc_rx_destroy_pool(struct io_zc_rx_pool *pool)
+{
+	struct device *dev = netdev2dev(pool->ifq->dev);
+	struct io_zc_rx_buf *buf;
+
+	for (int i = 0; i < pool->nr_bufs; i++) {
+		buf = &pool->bufs[i];
+		io_zc_rx_free_buf(dev, buf);
+	}
+	kvfree(pool->bufs);
+	kvfree(pool);
+}
+
 static struct io_zc_rx_ifq *io_zc_rx_ifq_alloc(struct io_ring_ctx *ctx)
 {
 	struct io_zc_rx_ifq *ifq;
@@ -105,6 +234,8 @@ static void io_zc_rx_ifq_free(struct io_zc_rx_ifq *ifq)
 {
 	io_shutdown_ifq(ifq);
 
+	if (ifq->pool)
+		io_zc_rx_destroy_pool(ifq->pool);
 	if (ifq->dev)
 		dev_put(ifq->dev);
 	io_free_rbuf_ring(ifq);
@@ -141,7 +272,9 @@ int io_register_zc_rx_ifq(struct io_ring_ctx *ctx,
 	if (!ifq->dev)
 		goto err;
 
-	/* TODO: map zc region and initialise zc pool */
+	ret = io_zc_rx_create_pool(ctx, ifq, reg.region_id);
+	if (ret)
+		goto err;
 
 	ifq->rq_entries = reg.rq_entries;
 	ifq->cq_entries = reg.cq_entries;
diff --git a/io_uring/zc_rx.h b/io_uring/zc_rx.h
index 9257dda77e92..af1d865525d2 100644
--- a/io_uring/zc_rx.h
+++ b/io_uring/zc_rx.h
@@ -3,15 +3,30 @@
 #define IOU_ZC_RX_H
 
 #include <linux/io_uring_types.h>
+#include <linux/io_uring/net.h>
 #include <linux/skbuff.h>
 
 #define IO_ZC_MAX_IFQ_SOCKETS		16
 #define IO_ZC_IFQ_IDX_OFFSET		16
 #define IO_ZC_IFQ_IDX_MASK		((1U << IO_ZC_IFQ_IDX_OFFSET) - 1)
 
+struct io_zc_rx_pool {
+	struct io_zc_rx_ifq	*ifq;
+	struct io_zc_rx_buf	*bufs;
+	u32			nr_bufs;
+	u16			pool_id;
+
+	/* freelist */
+	spinlock_t		freelist_lock;
+	u32			free_count;
+	u32			freelist[];
+};
+
 struct io_zc_rx_ifq {
 	struct io_ring_ctx		*ctx;
 	struct net_device		*dev;
+	struct io_zc_rx_pool		*pool;
+
 	struct io_rbuf_ring		*ring;
 	struct io_uring_rbuf_rqe 	*rqes;
 	struct io_uring_rbuf_cqe 	*cqes;
-- 
2.39.3


