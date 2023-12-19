Return-Path: <io-uring+bounces-311-lists+io-uring=lfdr.de@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [IPv6:2604:1380:45d1:ec00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 5363D8191FB
	for <lists+io-uring@lfdr.de>; Tue, 19 Dec 2023 22:05:36 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id 77DA31C25015
	for <lists+io-uring@lfdr.de>; Tue, 19 Dec 2023 21:05:35 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 1694C3FB12;
	Tue, 19 Dec 2023 21:04:20 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=davidwei-uk.20230601.gappssmtp.com header.i=@davidwei-uk.20230601.gappssmtp.com header.b="cyivTOJr"
X-Original-To: io-uring@vger.kernel.org
Received: from mail-pg1-f174.google.com (mail-pg1-f174.google.com [209.85.215.174])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1B69A3DB8C
	for <io-uring@vger.kernel.org>; Tue, 19 Dec 2023 21:04:17 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=davidwei.uk
Authentication-Results: smtp.subspace.kernel.org; spf=none smtp.mailfrom=davidwei.uk
Received: by mail-pg1-f174.google.com with SMTP id 41be03b00d2f7-5cdbc7bebecso515737a12.1
        for <io-uring@vger.kernel.org>; Tue, 19 Dec 2023 13:04:17 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=davidwei-uk.20230601.gappssmtp.com; s=20230601; t=1703019857; x=1703624657; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=eEGPLnsr8EuY8VD2FnKVCOVQnMaFt7IkWGFTilccx/A=;
        b=cyivTOJrwoLI0/YLu3/Ahq31WLXLq4pkB4jViJT9/yx4PwKdylYdEnL5Epq4TWmRUD
         oyAiY5C1B/+M/ySO9TjFvXA+6XBLhMt97/Dx2XardPGVBuFHDL7m8ZgFRVXjlJ2tu08C
         VUhLE3zh/zeWAhYiggyYZi3inWeBoxaSTM/8MWf2udzQFHgZAUq39AtJ4RJ8Xcva+wMn
         C7xi8vvUK9SBTfJ0QtLB9IvJqgIN/3MmwXl4cBr1KXx4X99tL7nVu1JotwzCAArY0VoF
         FT3nY+h3jhoz1MKz9cWaaW8VxtyWbZH19thI+ARrQDspG6inheCgirph0dCzk74cKArq
         a5DA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1703019857; x=1703624657;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=eEGPLnsr8EuY8VD2FnKVCOVQnMaFt7IkWGFTilccx/A=;
        b=MsnJtgAk1bXO3Yca9u9CsDHwFs9vVrqe3jscyHwvCqeTmPQ/Yr8tSnFAV3TwSUGoIj
         6ir0PnayYQTYI8zeOuMlG+7O9W0MKjPdWxBL3hp+vPLHXtbfjaQ7Ig0sWHHqR+Fl1vpz
         +YkQU6wgmJYnr/Iobu5kg6C18rtUzfSPSHWTxw0/xCoxVDcGUzfcrQTn4LnETW1FJkyF
         IVqzFE7XPOGICHT0hmOCB5NvDApUC2f7P63dzFG3bDofjCxl/FRUxV8nF1AzUk+zaYyq
         gf5zHSjteDwS4j/+k9BeSNRpzgDTMYxuL3F/WlA7Ns9b4Ll7Egzn2tfVTN3gEKLFmAD4
         iCgQ==
X-Gm-Message-State: AOJu0YyXg7SRakXr+cvrzC02lvELVTWThg4lL7UOrJe/k6W/BA0UjJnJ
	orUyyO+5DPzZ6DmuodVkilsQLxwhUSBfuJpse7Qa3A==
X-Google-Smtp-Source: AGHT+IF8bw1k9pZ9asY2+rvU14RiZot/ft1Sk+wFRr4Kw+D4bW9SqnE775wocw9nZCzUzNSxjlss3A==
X-Received: by 2002:a05:6a21:1f03:b0:18a:d4c3:1350 with SMTP id ry3-20020a056a211f0300b0018ad4c31350mr7409363pzb.44.1703019857139;
        Tue, 19 Dec 2023 13:04:17 -0800 (PST)
Received: from localhost (fwdproxy-prn-003.fbsv.net. [2a03:2880:ff:3::face:b00c])
        by smtp.gmail.com with ESMTPSA id c14-20020aa781ce000000b006d082dd8086sm16864175pfn.214.2023.12.19.13.04.16
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 19 Dec 2023 13:04:16 -0800 (PST)
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
Subject: [RFC PATCH v3 13/20] io_uring: implement pp memory provider for zc rx
Date: Tue, 19 Dec 2023 13:03:50 -0800
Message-Id: <20231219210357.4029713-14-dw@davidwei.uk>
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

We're adding a new pp memory provider to implement io_uring zerocopy
receive. It'll be "registered" in pp and used in later paches.

The typical life cycle of a buffer goes as follows: first it's allocated
to a driver with the initial refcount set to 1. The drivers fills it
with data, puts it into an skb and passes down the stack, where it gets
queued up to a socket. Later, a zc io_uring request will be receiving
data from the socket from a task context. At that point io_uring will
tell the userspace that this buffer has some data by posting an
appropriate completion. It'll also elevating the refcount by
IO_ZC_RX_UREF, so the buffer is not recycled while userspace is reading
the data. When the userspace is done with the buffer it should return it
back to io_uring by adding an entry to the buffer refill ring. When
necessary io_uring will poll the refill ring, compare references
including IO_ZC_RX_UREF and reuse the buffer.

Initally, all buffers are placed in a spinlock protected ->freelist.
It's a slow path stash, where buffers are considered to be unallocated
and not exposed to core page pool. On allocation, pp will first try
all its caches, and the ->alloc_pages callback if everything else
failed.

The hot path for io_pp_zc_alloc_pages() is to grab pages from the refill
ring. The consumption from the ring is always done in the attached napi
context, so no additional synchronisation required. If that fails we'll
be getting buffers from the ->freelist.

Note: only ->freelist are considered unallocated for page pool, so we
only add pages_state_hold_cnt when allocating from there. Subsequently,
as page_pool_return_page() and others bump the ->pages_state_release_cnt
counter, io_pp_zc_release_page() can only use ->freelist, which is not a
problem as it's not a slow path.

Signed-off-by: Pavel Begunkov <asml.silence@gmail.com>
Signed-off-by: David Wei <dw@davidwei.uk>
---
 include/linux/io_uring/net.h |   5 +
 io_uring/zc_rx.c             | 204 +++++++++++++++++++++++++++++++++++
 io_uring/zc_rx.h             |   6 ++
 3 files changed, 215 insertions(+)

diff --git a/include/linux/io_uring/net.h b/include/linux/io_uring/net.h
index d994d26116d0..13244ae5fc4a 100644
--- a/include/linux/io_uring/net.h
+++ b/include/linux/io_uring/net.h
@@ -13,6 +13,11 @@ struct io_zc_rx_buf {
 };
 
 #if defined(CONFIG_IO_URING)
+
+#if defined(CONFIG_PAGE_POOL)
+extern const struct pp_memory_provider_ops io_uring_pp_zc_ops;
+#endif
+
 int io_uring_cmd_sock(struct io_uring_cmd *cmd, unsigned int issue_flags);
 
 #else
diff --git a/io_uring/zc_rx.c b/io_uring/zc_rx.c
index 1e656b481725..ff1dac24ac40 100644
--- a/io_uring/zc_rx.c
+++ b/io_uring/zc_rx.c
@@ -6,6 +6,7 @@
 #include <linux/io_uring.h>
 #include <linux/netdevice.h>
 #include <linux/nospec.h>
+#include <trace/events/page_pool.h>
 
 #include <uapi/linux/io_uring.h>
 
@@ -387,4 +388,207 @@ int io_register_zc_rx_sock(struct io_ring_ctx *ctx,
 	return 0;
 }
 
+static inline struct io_zc_rx_buf *io_iov_to_buf(struct page_pool_iov *iov)
+{
+	return container_of(iov, struct io_zc_rx_buf, ppiov);
+}
+
+static inline unsigned io_buf_pgid(struct io_zc_rx_pool *pool,
+				   struct io_zc_rx_buf *buf)
+{
+	return buf - pool->bufs;
+}
+
+static __maybe_unused void io_zc_rx_get_buf_uref(struct io_zc_rx_buf *buf)
+{
+	refcount_add(IO_ZC_RX_UREF, &buf->ppiov.refcount);
+}
+
+static bool io_zc_rx_put_buf_uref(struct io_zc_rx_buf *buf)
+{
+	if (page_pool_iov_refcount(&buf->ppiov) < IO_ZC_RX_UREF)
+		return false;
+
+	return page_pool_iov_sub_and_test(&buf->ppiov, IO_ZC_RX_UREF);
+}
+
+static inline struct page *io_zc_buf_to_pp_page(struct io_zc_rx_buf *buf)
+{
+	return page_pool_mangle_ppiov(&buf->ppiov);
+}
+
+static inline void io_zc_add_pp_cache(struct page_pool *pp,
+				      struct io_zc_rx_buf *buf)
+{
+	refcount_set(&buf->ppiov.refcount, 1);
+	pp->alloc.cache[pp->alloc.count++] = io_zc_buf_to_pp_page(buf);
+}
+
+static inline u32 io_zc_rx_rqring_entries(struct io_zc_rx_ifq *ifq)
+{
+	struct io_rbuf_ring *ring = ifq->ring;
+	u32 entries;
+
+	entries = smp_load_acquire(&ring->rq.tail) - ifq->cached_rq_head;
+	return min(entries, ifq->rq_entries);
+}
+
+static void io_zc_rx_ring_refill(struct page_pool *pp,
+				 struct io_zc_rx_ifq *ifq)
+{
+	unsigned int entries = io_zc_rx_rqring_entries(ifq);
+	unsigned int mask = ifq->rq_entries - 1;
+	struct io_zc_rx_pool *pool = ifq->pool;
+
+	if (unlikely(!entries))
+		return;
+
+	while (entries--) {
+		unsigned int rq_idx = ifq->cached_rq_head++ & mask;
+		struct io_uring_rbuf_rqe *rqe = &ifq->rqes[rq_idx];
+		u32 pgid = rqe->off / PAGE_SIZE;
+		struct io_zc_rx_buf *buf = &pool->bufs[pgid];
+
+		if (!io_zc_rx_put_buf_uref(buf))
+			continue;
+		io_zc_add_pp_cache(pp, buf);
+		if (pp->alloc.count >= PP_ALLOC_CACHE_REFILL)
+			break;
+	}
+	smp_store_release(&ifq->ring->rq.head, ifq->cached_rq_head);
+}
+
+static void io_zc_rx_refill_slow(struct page_pool *pp, struct io_zc_rx_ifq *ifq)
+{
+	struct io_zc_rx_pool *pool = ifq->pool;
+
+	spin_lock_bh(&pool->freelist_lock);
+	while (pool->free_count && pp->alloc.count < PP_ALLOC_CACHE_REFILL) {
+		struct io_zc_rx_buf *buf;
+		u32 pgid;
+
+		pgid = pool->freelist[--pool->free_count];
+		buf = &pool->bufs[pgid];
+
+		io_zc_add_pp_cache(pp, buf);
+		pp->pages_state_hold_cnt++;
+		trace_page_pool_state_hold(pp, io_zc_buf_to_pp_page(buf),
+					   pp->pages_state_hold_cnt);
+	}
+	spin_unlock_bh(&pool->freelist_lock);
+}
+
+static void io_zc_rx_recycle_buf(struct io_zc_rx_pool *pool,
+				 struct io_zc_rx_buf *buf)
+{
+	spin_lock_bh(&pool->freelist_lock);
+	pool->freelist[pool->free_count++] = io_buf_pgid(pool, buf);
+	spin_unlock_bh(&pool->freelist_lock);
+}
+
+static struct page *io_pp_zc_alloc_pages(struct page_pool *pp, gfp_t gfp)
+{
+	struct io_zc_rx_ifq *ifq = pp->mp_priv;
+
+	/* pp should already be ensuring that */
+	if (unlikely(pp->alloc.count))
+		goto out_return;
+
+	io_zc_rx_ring_refill(pp, ifq);
+	if (likely(pp->alloc.count))
+		goto out_return;
+
+	io_zc_rx_refill_slow(pp, ifq);
+	if (!pp->alloc.count)
+		return NULL;
+out_return:
+	return pp->alloc.cache[--pp->alloc.count];
+}
+
+static bool io_pp_zc_release_page(struct page_pool *pp, struct page *page)
+{
+	struct io_zc_rx_ifq *ifq = pp->mp_priv;
+	struct page_pool_iov *ppiov;
+
+	if (WARN_ON_ONCE(!page_is_page_pool_iov(page)))
+		return false;
+
+	ppiov = page_to_page_pool_iov(page);
+
+	if (!page_pool_iov_sub_and_test(ppiov, 1))
+		return false;
+
+	io_zc_rx_recycle_buf(ifq->pool, io_iov_to_buf(ppiov));
+	return true;
+}
+
+static void io_pp_zc_scrub(struct page_pool *pp)
+{
+	struct io_zc_rx_ifq *ifq = pp->mp_priv;
+	struct io_zc_rx_pool *pool = ifq->pool;
+	struct io_zc_rx_buf *buf;
+	int i;
+
+	for (i = 0; i < pool->nr_bufs; i++) {
+		buf = &pool->bufs[i];
+
+		if (io_zc_rx_put_buf_uref(buf)) {
+			/* just return it to the page pool, it'll clean it up */
+			refcount_set(&buf->ppiov.refcount, 1);
+			page_pool_iov_put_many(&buf->ppiov, 1);
+		}
+	}
+}
+
+static void io_zc_rx_init_pool(struct io_zc_rx_pool *pool,
+			       struct page_pool *pp)
+{
+	struct io_zc_rx_buf *buf;
+	int i;
+
+	for (i = 0; i < pool->nr_bufs; i++) {
+		buf = &pool->bufs[i];
+		buf->ppiov.pp = pp;
+	}
+}
+
+static int io_pp_zc_init(struct page_pool *pp)
+{
+	struct io_zc_rx_ifq *ifq = pp->mp_priv;
+
+	if (!ifq)
+		return -EINVAL;
+	if (pp->p.order != 0)
+		return -EINVAL;
+	if (!pp->p.napi)
+		return -EINVAL;
+
+	io_zc_rx_init_pool(ifq->pool, pp);
+	percpu_ref_get(&ifq->ctx->refs);
+	ifq->pp = pp;
+	return 0;
+}
+
+static void io_pp_zc_destroy(struct page_pool *pp)
+{
+	struct io_zc_rx_ifq *ifq = pp->mp_priv;
+	struct io_zc_rx_pool *pool = ifq->pool;
+
+	ifq->pp = NULL;
+
+	if (WARN_ON_ONCE(pool->free_count != pool->nr_bufs))
+		return;
+	percpu_ref_put(&ifq->ctx->refs);
+}
+
+const struct pp_memory_provider_ops io_uring_pp_zc_ops = {
+	.alloc_pages		= io_pp_zc_alloc_pages,
+	.release_page		= io_pp_zc_release_page,
+	.init			= io_pp_zc_init,
+	.destroy		= io_pp_zc_destroy,
+	.scrub			= io_pp_zc_scrub,
+};
+EXPORT_SYMBOL(io_uring_pp_zc_ops);
+
+
 #endif
diff --git a/io_uring/zc_rx.h b/io_uring/zc_rx.h
index af1d865525d2..00d864700c67 100644
--- a/io_uring/zc_rx.h
+++ b/io_uring/zc_rx.h
@@ -10,6 +10,9 @@
 #define IO_ZC_IFQ_IDX_OFFSET		16
 #define IO_ZC_IFQ_IDX_MASK		((1U << IO_ZC_IFQ_IDX_OFFSET) - 1)
 
+#define IO_ZC_RX_UREF			0x10000
+#define IO_ZC_RX_KREF_MASK		(IO_ZC_RX_UREF - 1)
+
 struct io_zc_rx_pool {
 	struct io_zc_rx_ifq	*ifq;
 	struct io_zc_rx_buf	*bufs;
@@ -26,12 +29,15 @@ struct io_zc_rx_ifq {
 	struct io_ring_ctx		*ctx;
 	struct net_device		*dev;
 	struct io_zc_rx_pool		*pool;
+	struct page_pool		*pp;
 
 	struct io_rbuf_ring		*ring;
 	struct io_uring_rbuf_rqe 	*rqes;
 	struct io_uring_rbuf_cqe 	*cqes;
 	u32				rq_entries;
 	u32				cq_entries;
+	u32				cached_rq_head;
+	u32				cached_cq_tail;
 
 	/* hw rx descriptor ring id */
 	u32				if_rxq_id;
-- 
2.39.3


