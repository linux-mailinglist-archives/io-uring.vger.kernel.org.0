Return-Path: <io-uring+bounces-57-lists+io-uring=lfdr.de@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [IPv6:2604:1380:4601:e00::3])
	by mail.lfdr.de (Postfix) with ESMTPS id 528A37E4AE6
	for <lists+io-uring@lfdr.de>; Tue,  7 Nov 2023 22:41:41 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id BA9C41F21D05
	for <lists+io-uring@lfdr.de>; Tue,  7 Nov 2023 21:41:40 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 2143D2B2DE;
	Tue,  7 Nov 2023 21:41:07 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=davidwei-uk.20230601.gappssmtp.com header.i=@davidwei-uk.20230601.gappssmtp.com header.b="pwmWGQP1"
X-Original-To: io-uring@vger.kernel.org
Received: from lindbergh.monkeyblade.net (lindbergh.monkeyblade.net [23.128.96.19])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 905932A8E3
	for <io-uring@vger.kernel.org>; Tue,  7 Nov 2023 21:41:03 +0000 (UTC)
Received: from mail-pf1-x42a.google.com (mail-pf1-x42a.google.com [IPv6:2607:f8b0:4864:20::42a])
	by lindbergh.monkeyblade.net (Postfix) with ESMTPS id B4C8010E4
	for <io-uring@vger.kernel.org>; Tue,  7 Nov 2023 13:41:02 -0800 (PST)
Received: by mail-pf1-x42a.google.com with SMTP id d2e1a72fcca58-6c39ad730aaso2687487b3a.0
        for <io-uring@vger.kernel.org>; Tue, 07 Nov 2023 13:41:02 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=davidwei-uk.20230601.gappssmtp.com; s=20230601; t=1699393262; x=1699998062; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=XkwQzujPT5BBrG7XX0IftjDx25OJwjZS66fFII/4OGU=;
        b=pwmWGQP1rHaPNKS+SBY2kKuln/d7o5GQWVSvdTzs2PjNh6NmS7CA5WLXwl88n6Ib+e
         asdvGrkT7HW1TN34gBtR5wCyOIzF6Z52Xq2GAgTNAoIlIksXG90hVlU1JYNS3By3UT0W
         U08bSWiVv3JklZthJ373sD/Mv2km58LJ5WG14xBbJIGM1qMGPKu3n8y2ZgDNsVWGFBMs
         zdKWHtuki74Epmx+mAoa1FYeoTOHTF1rAbzoCraoqTimoxyG+4Eb8pr2iX9oR54+nkkZ
         5sTp8PNnxBC+xSqsjLtEyQMC+Ih1mEPVIxeULMqJOH2M/xF6ZqjobCprsElRt8Ub/N/Q
         zIgQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1699393262; x=1699998062;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=XkwQzujPT5BBrG7XX0IftjDx25OJwjZS66fFII/4OGU=;
        b=a9rX7lV8ueHuBNO0CeW3N4oq9w1rHqTrgKz29yTj3acvYWWTCtNQIQHOQ0If+Ix+rR
         8WawJpQFMewyouiQPpsjFrfj6aMPsLN+/OdlRFEnBYLhZozG2YtGsv+FueinNRHaNV4s
         +nhIlMF+whIrdjEriA3xvngeJF8eMouIu5IoM3v/7+zOPPaSlItZvpzErfv7/Z53/+oA
         K3KHWoxJbK8JnpmH93m5UUaknyFKNcOleJALjziU4X9fS5UHjYl+OD+84tL71VbUq7jT
         HpFZWwRxs8J/HrDpWmB/dM9W+NUVUIeyGmV5g1tzfnlwTZIX3RyP7H7gTH/H+y+nUPfe
         PnCw==
X-Gm-Message-State: AOJu0Ywx02fM746VSOttvDfWZvr/ie5cROdBzkmPL9qOmWuwnwUE0rBi
	QTYgeZTilNvO3cxYNuiwn58whqA8wBC33MgTxpOdHA==
X-Google-Smtp-Source: AGHT+IHVZxWBoccQ5Jk/sZcBfoYdsYWzKFv9LsnMbT9hBrQCPhgOuD1Vl7DAtvQDuLIwn97Ua+5CfQ==
X-Received: by 2002:a05:6a20:8419:b0:16b:d3d5:a5c5 with SMTP id c25-20020a056a20841900b0016bd3d5a5c5mr245524pzd.52.1699393261935;
        Tue, 07 Nov 2023 13:41:01 -0800 (PST)
Received: from localhost (fwdproxy-prn-014.fbsv.net. [2a03:2880:ff:e::face:b00c])
        by smtp.gmail.com with ESMTPSA id ey18-20020a056a0038d200b00690d255b5a1sm7560681pfb.217.2023.11.07.13.41.01
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 07 Nov 2023 13:41:01 -0800 (PST)
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
Subject: [PATCH 06/20] io_uring: add ZC buf and pool
Date: Tue,  7 Nov 2023 13:40:31 -0800
Message-Id: <20231107214045.2172393-7-dw@davidwei.uk>
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

This patch adds two objects:

* Zero copy buffer representation, holding a page, its mapped dma_addr,
  and a refcount for lifetime management.
* Zero copy pool, spiritually similar to page pool, that holds ZC bufs
  and hands them out to net devices.

The ZC pool is tiered with currently two tiers: a fast lockless cache
that should only be accessed from the NAPI context of a single Rx queue,
and a freelist. When a ZC pool region is first mapped, it is added to
the freelist.

During normal operation, bufs are moved from the freelist into the cache
in POOL_CACHE_SIZE blocks before being given out.

Pool regions are registered w/ io_uring using the registered buffer API,
with a 1:1 mapping between region and nr_iovec in
io_uring_register_buffers. This does the heavy lifting of pinning and
chunking into bvecs into a struct io_mapped_ubuf for us.

For now as there is only one pool region per ifq, there is no separate
API for adding/removing regions yet and it is mapped implicitly during
ifq registration.

Co-developed-by: Pavel Begunkov <asml.silence@gmail.com>
Signed-off-by: Pavel Begunkov <asml.silence@gmail.com>
Signed-off-by: David Wei <dw@davidwei.uk>
---
 include/linux/io_uring.h |   6 ++
 io_uring/zc_rx.c         | 173 ++++++++++++++++++++++++++++++++++++++-
 2 files changed, 178 insertions(+), 1 deletion(-)

diff --git a/include/linux/io_uring.h b/include/linux/io_uring.h
index 106cdc55ff3b..abfb73e257a4 100644
--- a/include/linux/io_uring.h
+++ b/include/linux/io_uring.h
@@ -41,6 +41,12 @@ static inline const void *io_uring_sqe_cmd(const struct io_uring_sqe *sqe)
 	return sqe->cmd;
 }
 
+struct io_zc_rx_buf {
+	dma_addr_t	dma;
+	struct page	*page;
+	atomic_t	refcount;
+};
+
 #if defined(CONFIG_IO_URING)
 int io_uring_cmd_import_fixed(u64 ubuf, unsigned long len, int rw,
 			      struct iov_iter *iter, void *ioucmd);
diff --git a/io_uring/zc_rx.c b/io_uring/zc_rx.c
index b5266a67395e..0f5fa9ab5cec 100644
--- a/io_uring/zc_rx.c
+++ b/io_uring/zc_rx.c
@@ -5,14 +5,44 @@
 #include <linux/mm.h>
 #include <linux/io_uring.h>
 #include <linux/netdevice.h>
+#include <linux/nospec.h>
 
 #include <uapi/linux/io_uring.h>
 
 #include "io_uring.h"
 #include "kbuf.h"
+#include "rsrc.h"
 #include "zc_rx.h"
 #include "rsrc.h"
 
+#define POOL_CACHE_SIZE	128
+
+struct io_zc_rx_pool {
+	struct io_zc_rx_ifq  	*ifq;
+	struct io_zc_rx_buf	*bufs;
+	u16			pool_id;
+	u32			nr_pages;
+
+	/* fast cache */
+	u32			cache_count;
+	u32			cache[POOL_CACHE_SIZE];
+
+	/* freelist */
+	spinlock_t		freelist_lock;
+	u32			free_count;
+	u32			freelist[];
+};
+
+static inline struct device *netdev2dev(struct net_device *dev)
+{
+	return dev->dev.parent;
+}
+
+static inline u64 mk_page_info(u16 pool_id, u32 pgid)
+{
+	return (u64)0xface << 48 | (u64)pool_id << 32 | (u64)pgid;
+}
+
 typedef int (*bpf_op_t)(struct net_device *dev, struct netdev_bpf *bpf);
 
 static int __io_queue_mgmt(struct net_device *dev, struct io_zc_rx_ifq *ifq,
@@ -42,6 +72,143 @@ static int io_close_zc_rxq(struct io_zc_rx_ifq *ifq)
 	return __io_queue_mgmt(ifq->dev, NULL, ifq->if_rxq_id);
 }
 
+static int io_zc_rx_map_buf(struct device *dev, struct page *page, u16 pool_id,
+			    u32 pgid, struct io_zc_rx_buf *buf)
+{
+	dma_addr_t addr;
+
+	SetPagePrivate(page);
+	set_page_private(page, mk_page_info(pool_id, pgid));
+
+	addr = dma_map_page_attrs(dev, page, 0, PAGE_SIZE,
+				  DMA_BIDIRECTIONAL,
+				  DMA_ATTR_SKIP_CPU_SYNC);
+	if (dma_mapping_error(dev, addr)) {
+		set_page_private(page, 0);
+		ClearPagePrivate(page);
+		return -ENOMEM;
+	}
+
+	buf->dma = addr;
+	buf->page = page;
+	atomic_set(&buf->refcount, 0);
+	get_page(page);
+
+	return 0;
+}
+
+static void io_zc_rx_unmap_buf(struct device *dev, struct io_zc_rx_buf *buf)
+{
+	struct page *page;
+
+	page = buf->page;
+	set_page_private(page, 0);
+	ClearPagePrivate(page);
+	dma_unmap_page_attrs(dev, buf->dma, PAGE_SIZE,
+			     DMA_BIDIRECTIONAL,
+			     DMA_ATTR_SKIP_CPU_SYNC);
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
+		if (PagePrivate(page)) {
+			ret = -EEXIST;
+			goto err;
+		}
+
+		buf = &pool->bufs[i];
+		ret = io_zc_rx_map_buf(dev, page, pool->pool_id, i, buf);
+		if (ret)
+			goto err;
+
+		pool->freelist[i] = i;
+	}
+
+	return 0;
+err:
+	while (i--) {
+		buf = &pool->bufs[i];
+		io_zc_rx_unmap_buf(dev, buf);
+	}
+
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
+	pool->nr_pages = nr_pages;
+	pool->cache_count = 0;
+	spin_lock_init(&pool->freelist_lock);
+	pool->free_count = nr_pages;
+	ifq->pool = pool;
+
+	return 0;
+
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
+	for (int i = 0; i < pool->nr_pages; i++) {
+		buf = &pool->bufs[i];
+
+		io_zc_rx_unmap_buf(dev, buf);
+	}
+	kvfree(pool->bufs);
+	kvfree(pool);
+}
+
 static struct io_zc_rx_ifq *io_zc_rx_ifq_alloc(struct io_ring_ctx *ctx)
 {
 	struct io_zc_rx_ifq *ifq;
@@ -60,6 +227,8 @@ static void io_zc_rx_ifq_free(struct io_zc_rx_ifq *ifq)
 {
 	if (ifq->if_rxq_id != -1)
 		io_close_zc_rxq(ifq);
+	if (ifq->pool)
+		io_zc_rx_destroy_pool(ifq->pool);
 	if (ifq->dev)
 		dev_put(ifq->dev);
 	io_free_rbuf_ring(ifq);
@@ -94,7 +263,9 @@ int io_register_zc_rx_ifq(struct io_ring_ctx *ctx,
 	if (!ifq->dev)
 		goto err;
 
-	/* TODO: map zc region and initialise zc pool */
+	ret = io_zc_rx_create_pool(ctx, ifq, reg.region_id);
+	if (ret)
+		goto err;
 
 	ifq->rq_entries = reg.rq_entries;
 	ifq->cq_entries = reg.cq_entries;
-- 
2.39.3


