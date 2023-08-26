Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 50A587892FB
	for <lists+io-uring@lfdr.de>; Sat, 26 Aug 2023 03:22:38 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231623AbjHZBWH (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Fri, 25 Aug 2023 21:22:07 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:34890 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231625AbjHZBVk (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Fri, 25 Aug 2023 21:21:40 -0400
Received: from mail-pl1-x636.google.com (mail-pl1-x636.google.com [IPv6:2607:f8b0:4864:20::636])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 6B62E2683
        for <io-uring@vger.kernel.org>; Fri, 25 Aug 2023 18:21:33 -0700 (PDT)
Received: by mail-pl1-x636.google.com with SMTP id d9443c01a7336-1bdca7cc28dso12650035ad.1
        for <io-uring@vger.kernel.org>; Fri, 25 Aug 2023 18:21:33 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=davidwei-uk.20221208.gappssmtp.com; s=20221208; t=1693012893; x=1693617693;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=2ynVwsxmMrwAG9Nkn/12Q+RcMuGojnsZ7syWTa5mUqI=;
        b=sScyon73ZfPCd5COdaruZOMvd2yb5cFxfqTJEizlywXPasyRc/ri4S1DQPkJuu0D8T
         GD962rQa5CRpcWX9jw9WHhaG6cqUyYUB03zL7b0+tFne0fRR5x9EdIwB2VSN4YK19H2J
         fz6oH+aikAZgxH5f98/zi+7OHCdMMxUrEttcLgm9qm/EHwTh+azC0TFpvKH7/eXcIS8Q
         FYVrhRk6mw0RVycbkbeDtV+hmxMy//DPPfBfWKldWaD/Fd/5OwQQXjlx3GQBjAsoUXbV
         E8s1qAK8WJsR1dKjVMh/cYzPqtjFgcNDLfu11t+KllXtjmXce/0xiHehQZiGVAJfpa9F
         1sfQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20221208; t=1693012893; x=1693617693;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=2ynVwsxmMrwAG9Nkn/12Q+RcMuGojnsZ7syWTa5mUqI=;
        b=Xvf46iJYerYo3q8dW4c/Rr2s7yYDl0iGeb65YTrBw8/PnxFXF9QDkf4cZcZJbwKRYM
         67zpy36x1A0/IDfl7DxxmJRjaL8uyoTWJ3YilDLwUP3r8+vCR5j0ilBQIwimIHc4GY1T
         vxq92+M7b5E8QJAUwd/MrZB8Vk0GtVVtKH4GblFXlObG2TonJuDNWm2fNMQFIcRqEXC+
         ggoJyv23pixd2ODFx9KdeEVKiWBEPMmJ2GUP+UoWzRcs8WmDq8q5hWjphvqXg5o0Gp9t
         M1fGRIc6AEjs1r30//CoIab+xKnEYdubNEMuNd0eQHrvH67J9NkI0O6D71EIhvJnKqKv
         PX4Q==
X-Gm-Message-State: AOJu0YycohUjXKIj1SX7rArLEkbT24FW2blkYUoO8psX/s/uRCpIGt7J
        k4JTgQqFzJzMRX6g072PLp2IjRzbuNVBtVfLC5gPEg==
X-Google-Smtp-Source: AGHT+IHrObKFTZupRASNWAVoKD8zWxjg7OzV1ODlDgotGdGYZbjP47UkUmFk/MbtBg+KLZptfmBD5g==
X-Received: by 2002:a17:902:e5cd:b0:1b0:f8:9b2d with SMTP id u13-20020a170902e5cd00b001b000f89b2dmr23494952plf.29.1693012892911;
        Fri, 25 Aug 2023 18:21:32 -0700 (PDT)
Received: from localhost (fwdproxy-prn-004.fbsv.net. [2a03:2880:ff:4::face:b00c])
        by smtp.gmail.com with ESMTPSA id e4-20020a170902744400b001b03b7f8adfsm2410764plt.246.2023.08.25.18.21.32
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 25 Aug 2023 18:21:32 -0700 (PDT)
From:   David Wei <dw@davidwei.uk>
To:     Jens Axboe <axboe@kernel.dk>,
        Pavel Begunkov <asml.silence@gmail.com>
Cc:     io-uring@vger.kernel.org, netdev@vger.kernel.org,
        Mina Almasry <almasrymina@google.com>,
        Jakub Kicinski <kuba@kernel.org>
Subject: [PATCH 05/11] io_uring: add ZC buf and pool
Date:   Fri, 25 Aug 2023 18:19:48 -0700
Message-Id: <20230826011954.1801099-6-dw@davidwei.uk>
X-Mailer: git-send-email 2.39.3
In-Reply-To: <20230826011954.1801099-1-dw@davidwei.uk>
References: <20230826011954.1801099-1-dw@davidwei.uk>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-1.9 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,RCVD_IN_DNSWL_BLOCKED,SPF_HELO_NONE,SPF_NONE
        autolearn=unavailable autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org

From: David Wei <davidhwei@meta.com>

This patch adds two objects:

* Zero copy buffer representation, holding a page, its mapped dma_addr,
  and a refcount for lifetime management.
* Zero copy pool, spiritually similar to page pool, that holds ZC bufs
  and hands them out to net devices.

The ZC pool is tiered with currently two tiers: a fast lockless cache
that should only be accessed from the NAPI context of a single RX queue,
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

Signed-off-by: David Wei <davidhwei@meta.com>
Co-developed-by: Jonathan Lemon <jonathan.lemon@gmail.com>
---
 include/linux/io_uring.h |   6 ++
 io_uring/zc_rx.c         | 173 ++++++++++++++++++++++++++++++++++++++-
 io_uring/zc_rx.h         |   1 +
 3 files changed, 179 insertions(+), 1 deletion(-)

diff --git a/include/linux/io_uring.h b/include/linux/io_uring.h
index 7fe31b2cd02f..cf1993befa6a 100644
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
index 8cc66731af5b..317127d0d4e7 100644
--- a/io_uring/zc_rx.c
+++ b/io_uring/zc_rx.c
@@ -4,13 +4,43 @@
 #include <linux/mm.h>
 #include <linux/io_uring.h>
 #include <linux/netdevice.h>
+#include <linux/nospec.h>
 
 #include <uapi/linux/io_uring.h>
 
 #include "io_uring.h"
 #include "kbuf.h"
+#include "rsrc.h"
 #include "zc_rx.h"
 
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
+static struct device *netdev2dev(struct net_device *dev)
+{
+	return dev->dev.parent;
+}
+
+static u64 mk_page_info(u16 pool_id, u32 pgid)
+{
+	return (u64)0xface << 48 | (u64)pool_id << 32 | (u64)pgid;
+}
+
 typedef int (*bpf_op_t)(struct net_device *dev, struct netdev_bpf *bpf);
 
 static int __io_queue_mgmt(struct net_device *dev, struct io_zc_rx_ifq *ifq,
@@ -40,6 +70,143 @@ static int io_close_zc_rxq(struct io_zc_rx_ifq *ifq)
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
+int io_zc_rx_create_pool(struct io_ring_ctx *ctx,
+			 struct io_zc_rx_ifq *ifq,
+			 u16 id)
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
@@ -58,6 +225,8 @@ static void io_zc_rx_ifq_free(struct io_zc_rx_ifq *ifq)
 {
 	if (ifq->if_rxq_id != -1)
 		io_close_zc_rxq(ifq);
+	if (ifq->pool)
+		io_zc_rx_destroy_pool(ifq->pool);
 	if (ifq->dev)
 		dev_put(ifq->dev);
 	io_free_rbuf_ring(ifq);
@@ -92,7 +261,9 @@ int io_register_zc_rx_ifq(struct io_ring_ctx *ctx,
 	if (!ifq->dev)
 		goto err;
 
-	/* TODO: map zc region and initialise zc pool */
+	ret = io_zc_rx_create_pool(ctx, ifq, reg.region_id);
+	if (ret)
+		goto err;
 
 	ifq->rq_entries = reg.rq_entries;
 	ifq->cq_entries = reg.cq_entries;
diff --git a/io_uring/zc_rx.h b/io_uring/zc_rx.h
index 340ececa9f9c..3cd0e730115d 100644
--- a/io_uring/zc_rx.h
+++ b/io_uring/zc_rx.h
@@ -18,5 +18,6 @@ struct io_zc_rx_ifq {
 int io_register_zc_rx_ifq(struct io_ring_ctx *ctx,
 			  struct io_uring_zc_rx_ifq_reg __user *arg);
 int io_unregister_zc_rx_ifq(struct io_ring_ctx *ctx);
+int io_zc_rx_pool_create(struct io_zc_rx_ifq *ifq, u16 id);
 
 #endif
-- 
2.39.3

