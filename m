Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id BE12A78921A
	for <lists+io-uring@lfdr.de>; Sat, 26 Aug 2023 00:56:46 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229864AbjHYW4Q (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Fri, 25 Aug 2023 18:56:16 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:52884 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229922AbjHYW4K (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Fri, 25 Aug 2023 18:56:10 -0400
Received: from mail-pf1-x435.google.com (mail-pf1-x435.google.com [IPv6:2607:f8b0:4864:20::435])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 38EE1E77
        for <io-uring@vger.kernel.org>; Fri, 25 Aug 2023 15:56:08 -0700 (PDT)
Received: by mail-pf1-x435.google.com with SMTP id d2e1a72fcca58-68c3ec0578bso53213b3a.2
        for <io-uring@vger.kernel.org>; Fri, 25 Aug 2023 15:56:08 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=davidwei-uk.20221208.gappssmtp.com; s=20221208; t=1693004168; x=1693608968;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=2ynVwsxmMrwAG9Nkn/12Q+RcMuGojnsZ7syWTa5mUqI=;
        b=gLkuJBtSlIqnwjckVQgRowMCnInFNXzfp25EcwMkCDWVGkCqhLW5Gz2Tzzoo9d6aSi
         Zu7Rp/FvFT5pxZcOeZ5iP6qhgXnsc0jl0mQAv5Jt+lPxR6ptZlU1KN8bKx1HQ6YwG7sW
         CylSu0bugrfqnp6ERpgnc69/2MEbMgjbAKdHFmdfHz8CYF97YrREqcXbSfOuLqovLnGG
         kdmjUE763DpmRiOgN/5Sl1NaP6Rv0SHASgwuRfOLG8F94yKxwl4tAKh7ywK62stX5B3P
         SmGhNAEReACa1DyzN90WSTnGp4q7xOAuAJyOan2sQS8sB2iNaqYwZoB0B97QpGx33aqb
         hiNw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20221208; t=1693004168; x=1693608968;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=2ynVwsxmMrwAG9Nkn/12Q+RcMuGojnsZ7syWTa5mUqI=;
        b=YmaUtRPNVqM05FGFx4hOpTtZt65gt8q8Mkn9Rpq0FkAKV0ElHaNINtWLm9wRUarmxI
         fHPtMbPnwuoVdzFZI0b3GcCepTjmn3j/D9RKf8XkEo5BNc8XMF6ms6SyQsq/YoYgSIac
         o9t9YNedqsCdLlqcYkyECttWXEK5fg4BXoEsKtOAZrHPvCWiHBO8+fBzv6M+EayEQfT5
         GgqubSnIao+i7SjHHfa/ywj7qH5vdKi26B/NfIWXu5PR9xrQS+lGbymrdE8DiO4/8+jH
         a479541JKeqDFoViWlW+7GkONaFZsdrgR1+G9LVK6KoZZzLawVh8TDpb5atDnsWpkTyX
         wFSA==
X-Gm-Message-State: AOJu0Yw4a0XigWi1lwXzlXWCsusV2tOLf3yk/FYcx+i0dko/P7KPc+yj
        v40Dv0IfXHpt4N9CezKzxBDiiQ==
X-Google-Smtp-Source: AGHT+IEedHohPjMh+ROCjazwp8Bxlfc99BcCWhNw3XkyNbrXnYAyiblMrAhCNXeR7kw9tDuewkQO0A==
X-Received: by 2002:a05:6a20:4324:b0:14a:ac45:d7d8 with SMTP id h36-20020a056a20432400b0014aac45d7d8mr10338710pzk.31.1693004167690;
        Fri, 25 Aug 2023 15:56:07 -0700 (PDT)
Received: from localhost (fwdproxy-prn-118.fbsv.net. [2a03:2880:ff:76::face:b00c])
        by smtp.gmail.com with ESMTPSA id q14-20020a170902dace00b001aadd0d7364sm2289249plx.83.2023.08.25.15.56.07
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 25 Aug 2023 15:56:07 -0700 (PDT)
From:   David Wei <dw@davidwei.uk>
To:     Jens Axboe <axboe@kernel.dk>,
        Pavel Begunkov <asml.silence@gmail.com>
Cc:     io-uring@vger.kernel.org, Mina Almasry <almasrymina@google.com>,
        Jakub Kicinski <kuba@kernel.org>
Subject: [PATCH 05/11] io_uring: add ZC buf and pool
Date:   Fri, 25 Aug 2023 15:55:44 -0700
Message-Id: <20230825225550.957014-6-dw@davidwei.uk>
X-Mailer: git-send-email 2.39.3
In-Reply-To: <20230825225550.957014-1-dw@davidwei.uk>
References: <20230825225550.957014-1-dw@davidwei.uk>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-1.9 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_NONE autolearn=ham
        autolearn_force=no version=3.4.6
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

