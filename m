Return-Path: <io-uring+bounces-913-lists+io-uring=lfdr.de@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [147.75.80.249])
	by mail.lfdr.de (Postfix) with ESMTPS id A2738879DCC
	for <lists+io-uring@lfdr.de>; Tue, 12 Mar 2024 22:47:33 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id 2F7B51F21B65
	for <lists+io-uring@lfdr.de>; Tue, 12 Mar 2024 21:47:33 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 653A7145FF7;
	Tue, 12 Mar 2024 21:44:47 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=davidwei-uk.20230601.gappssmtp.com header.i=@davidwei-uk.20230601.gappssmtp.com header.b="wv9r2612"
X-Original-To: io-uring@vger.kernel.org
Received: from mail-pf1-f176.google.com (mail-pf1-f176.google.com [209.85.210.176])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id AFB1B145354
	for <io-uring@vger.kernel.org>; Tue, 12 Mar 2024 21:44:45 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.210.176
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1710279887; cv=none; b=kHVSPV99khaRlci6QG8aEC7NGEbcoCURN9aSp+bfDzgWgx2T56/PE1bDx68isHQJ7S6iSJ5NHGKxBFyWcro4nvVGjOYUVgNSZA+xEDIRntlbR3sjRICfBaR/ZHFWdsuR2WtU9j+82Zbk+Dd7iy81rrgshAIwm0RxTNYQeh1TAnc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1710279887; c=relaxed/simple;
	bh=fBd7aiW8lj0+VawSo9hjm9m3CrBu6h6cjHpI8ufQ6Tc=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=Z1cyJu7HixczCmsn1TN/m5de6izuUiBFv1MM+SzSK1GPiDZ7E6k8bEjO3MR3C12Os51BZ1sxBj/kWFEYbyUVxEt4Ppm8WIjhqxq7Bs+G+O2dD9gBjRZWckdABEYEYOU8oAg3H4ne84NMcf/+6PSWOKXEO1kmTpqmZPXIu/1iQ90=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=davidwei.uk; spf=none smtp.mailfrom=davidwei.uk; dkim=pass (2048-bit key) header.d=davidwei-uk.20230601.gappssmtp.com header.i=@davidwei-uk.20230601.gappssmtp.com header.b=wv9r2612; arc=none smtp.client-ip=209.85.210.176
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=davidwei.uk
Authentication-Results: smtp.subspace.kernel.org; spf=none smtp.mailfrom=davidwei.uk
Received: by mail-pf1-f176.google.com with SMTP id d2e1a72fcca58-6e6b6e000a4so86941b3a.0
        for <io-uring@vger.kernel.org>; Tue, 12 Mar 2024 14:44:45 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=davidwei-uk.20230601.gappssmtp.com; s=20230601; t=1710279885; x=1710884685; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=Q/bJ5cz00biADxk0xZyDduH11+GpxHGkffjZ4B+okoY=;
        b=wv9r2612y5iNlXIYo0aFlA5vi3rdcmbWskyr9IetP0sSh6LNUh8TZD4V7JQ8lY3WF6
         gpOK8gHVVK2swHHbIyB5UfZLbW17hHXjeKW4PbSB3I2lxeMdinC2cVxbNyTX/IYl0bJ1
         ZmzAPkWFAXssWSvQWqTFRGuLy08LqZC6wsxLYipP/yUJa2uLRhL7Gy2JeGArJ77Ap3xW
         BI4dSEdJ+Ecwv1IfYwGn0EkVGSCmHWyB8aU548Pv89zlzWVngHIqojulAKSFZXUoftST
         9s0DhmUbuQxgcv7ozzROi4gz8qh0dXo2CVsPUoFPL5SY0w59YzTXhBe1lCQ7MBX1Wwhe
         vqDw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1710279885; x=1710884685;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=Q/bJ5cz00biADxk0xZyDduH11+GpxHGkffjZ4B+okoY=;
        b=XsPwUSM6oxLw2+/0aFlw6T5/cUNpkKHVa0DejHMf3nZdUXwWk1Fm0/65vGpF2Ab/bo
         87cDoYkIQ+RmFkGxFqmBRgPrz7V+cyZBsPWsHVrPTxUpnsRTt6ASXSQAaWGdoWheymLK
         1mn8epxQ5bppKmyVJaeVgjXvdRIHWUkVYpi5XZLZ0nkT7phwTnl/y2TIXgWgwvkd1+Rz
         Ltz9foT+ELpYPrO/M0oA3QKgfHIqoxOxAHApJ0k+zY3s0YCdv3M20spVV/5CXSb35uKt
         YCwmwhXeZI3MO24Izm8Zd17xgDufBVjssOeAAoCj/qMj+wEnn6yWij1pykcqX9/IsYfY
         Y8WQ==
X-Gm-Message-State: AOJu0Yx/uMPr0ToWsb/UrIY/JWVIhh86ZMR1wlSngi0xRstvwGqSXfTz
	LDrpJ2ZqDo83uy6Ptm7u10ZIns9kfIluxvoiEt/8Zkaaqrec3P+7oecxXAH6t2pOWLjcXITEgzx
	Z
X-Google-Smtp-Source: AGHT+IEyzPjJqpvSE1n18GL+g6MedsBAuXrULBa6xfyiiV4h7LYMzOL0v6SLuCy5/J6G/1xX4hfCVQ==
X-Received: by 2002:a05:6a00:803:b0:6e6:75d8:3d19 with SMTP id m3-20020a056a00080300b006e675d83d19mr822851pfk.8.1710279884624;
        Tue, 12 Mar 2024 14:44:44 -0700 (PDT)
Received: from localhost (fwdproxy-prn-118.fbsv.net. [2a03:2880:ff:76::face:b00c])
        by smtp.gmail.com with ESMTPSA id p1-20020a62b801000000b006e66a76d877sm6877532pfe.153.2024.03.12.14.44.44
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 12 Mar 2024 14:44:44 -0700 (PDT)
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
Subject: [RFC PATCH v4 11/16] io_uring: implement pp memory provider for zc rx
Date: Tue, 12 Mar 2024 14:44:25 -0700
Message-ID: <20240312214430.2923019-12-dw@davidwei.uk>
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

Implement a new pp memory provider for io_uring zerocopy receive.

All buffers are backed by struct io_zc_rx_buf, which is a thin extension
of struct net_iov. Initially, all of them are unallocated and placed in
a spinlock protected ->freelist. Then, they will be allocate via
the ->alloc_pages callback, which sets refcount to 1.

Later, buffers would either be dropped by the net stack and recycled
back into page pool / released by ->release_page, or, more likely, get
transferred to the userspace by posting a corresponding CQE and
elevating refcount by IO_ZC_RX_UREF. When the user is done with a buffer,
it should be put into the refill ring.

Next time io_pp_zc_alloc_pages() runs it'll check the ring, put user
refs and ultimately grab buffers from there. That's done in the attached
napi context and so doesn't need any additional synchronisation. That is
the second hottest path after getting a buffer from the pp lockless cache.

Signed-off-by: Pavel Begunkov <asml.silence@gmail.com>
Signed-off-by: David Wei <dw@davidwei.uk>
---
 include/linux/io_uring/net.h  |   5 +
 include/net/page_pool/types.h |   1 +
 io_uring/zc_rx.c              | 202 ++++++++++++++++++++++++++++++++++
 io_uring/zc_rx.h              |   5 +
 net/core/page_pool.c          |   2 +-
 5 files changed, 214 insertions(+), 1 deletion(-)

diff --git a/include/linux/io_uring/net.h b/include/linux/io_uring/net.h
index 05d5a6a97264..a225d7090b6b 100644
--- a/include/linux/io_uring/net.h
+++ b/include/linux/io_uring/net.h
@@ -12,6 +12,11 @@ struct io_zc_rx_buf {
 };
 
 #if defined(CONFIG_IO_URING)
+
+#if defined(CONFIG_PAGE_POOL)
+extern const struct memory_provider_ops io_uring_pp_zc_ops;
+#endif
+
 int io_uring_cmd_sock(struct io_uring_cmd *cmd, unsigned int issue_flags);
 
 #else
diff --git a/include/net/page_pool/types.h b/include/net/page_pool/types.h
index 347837b83d36..9e91f2cdbe61 100644
--- a/include/net/page_pool/types.h
+++ b/include/net/page_pool/types.h
@@ -227,6 +227,7 @@ netmem_ref page_pool_alloc_frag_netmem(struct page_pool *pool,
 struct page_pool *page_pool_create(const struct page_pool_params *params);
 struct page_pool *page_pool_create_percpu(const struct page_pool_params *params,
 					  int cpuid);
+void page_pool_set_pp_info(struct page_pool *pool, netmem_ref netmem);
 
 struct xdp_mem_info;
 
diff --git a/io_uring/zc_rx.c b/io_uring/zc_rx.c
index 326ae3fcc643..b2507df121fb 100644
--- a/io_uring/zc_rx.c
+++ b/io_uring/zc_rx.c
@@ -8,6 +8,7 @@
 #include <linux/nospec.h>
 #include <net/tcp.h>
 #include <net/af_unix.h>
+#include <trace/events/page_pool.h>
 
 #include <uapi/linux/io_uring.h>
 
@@ -357,4 +358,205 @@ int io_register_zc_rx_sock(struct io_ring_ctx *ctx,
 	return 0;
 }
 
+static inline struct io_zc_rx_buf *io_niov_to_buf(struct net_iov *niov)
+{
+	return container_of(niov, struct io_zc_rx_buf, niov);
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
+	atomic_long_add(IO_ZC_RX_UREF, &buf->niov.pp_ref_count);
+}
+
+static bool io_zc_rx_buf_put(struct io_zc_rx_buf *buf, int nr)
+{
+	return atomic_long_sub_and_test(nr, &buf->niov.pp_ref_count);
+}
+
+static bool io_zc_rx_put_buf_uref(struct io_zc_rx_buf *buf)
+{
+	if (atomic_long_read(&buf->niov.pp_ref_count) < IO_ZC_RX_UREF)
+		return false;
+
+	return io_zc_rx_buf_put(buf, IO_ZC_RX_UREF);
+}
+
+static inline netmem_ref io_zc_buf_to_netmem(struct io_zc_rx_buf *buf)
+{
+	return net_iov_to_netmem(&buf->niov);
+}
+
+static inline void io_zc_add_pp_cache(struct page_pool *pp,
+				      struct io_zc_rx_buf *buf)
+{
+	netmem_ref netmem = io_zc_buf_to_netmem(buf);
+
+	page_pool_set_pp_info(pp, netmem);
+	pp->alloc.cache[pp->alloc.count++] = netmem;
+}
+
+static inline u32 io_zc_rx_rqring_entries(struct io_zc_rx_ifq *ifq)
+{
+	u32 entries;
+
+	entries = smp_load_acquire(&ifq->rq_ring->tail) - ifq->cached_rq_head;
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
+	smp_store_release(&ifq->rq_ring->head, ifq->cached_rq_head);
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
+		trace_page_pool_state_hold(pp, io_zc_buf_to_netmem(buf),
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
+static netmem_ref io_pp_zc_alloc_pages(struct page_pool *pp, gfp_t gfp)
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
+		return 0;
+out_return:
+	return pp->alloc.cache[--pp->alloc.count];
+}
+
+static bool io_pp_zc_release_page(struct page_pool *pp, netmem_ref netmem)
+{
+	struct io_zc_rx_ifq *ifq = pp->mp_priv;
+	struct io_zc_rx_buf *buf;
+	struct net_iov *niov;
+
+	if (WARN_ON_ONCE(!netmem_is_net_iov(netmem)))
+		return false;
+
+	niov = netmem_to_net_iov(netmem);
+	buf = io_niov_to_buf(niov);
+
+	if (io_zc_rx_buf_put(buf, 1))
+		io_zc_rx_recycle_buf(ifq->pool, buf);
+	return false;
+}
+
+static void io_pp_zc_scrub(struct page_pool *pp)
+{
+	struct io_zc_rx_ifq *ifq = pp->mp_priv;
+	struct io_zc_rx_pool *pool = ifq->pool;
+	int i;
+
+	for (i = 0; i < pool->nr_bufs; i++) {
+		struct io_zc_rx_buf *buf = &pool->bufs[i];
+		int count;
+
+		if (!io_zc_rx_put_buf_uref(buf))
+			continue;
+		io_zc_rx_recycle_buf(pool, buf);
+
+		count = atomic_inc_return_relaxed(&pp->pages_state_release_cnt);
+		trace_page_pool_state_release(pp, io_zc_buf_to_netmem(buf), count);
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
+	if (pp->p.flags & PP_FLAG_DMA_MAP)
+		return -EOPNOTSUPP;
+	if (pp->p.flags & PP_FLAG_DMA_SYNC_DEV)
+		return -EOPNOTSUPP;
+
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
+const struct memory_provider_ops io_uring_pp_zc_ops = {
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
index 466b2b8f9813..c02bf8cabc6c 100644
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
@@ -26,10 +29,12 @@ struct io_zc_rx_ifq {
 	struct io_ring_ctx		*ctx;
 	struct net_device		*dev;
 	struct io_zc_rx_pool		*pool;
+	struct page_pool		*pp;
 
 	struct io_uring			*rq_ring;
 	struct io_uring_rbuf_rqe 	*rqes;
 	u32				rq_entries;
+	u32				cached_rq_head;
 
 	/* hw rx descriptor ring id */
 	u32				if_rxq_id;
diff --git a/net/core/page_pool.c b/net/core/page_pool.c
index fc92e551ed13..f83ddbb4ebd8 100644
--- a/net/core/page_pool.c
+++ b/net/core/page_pool.c
@@ -460,7 +460,7 @@ static bool page_pool_dma_map(struct page_pool *pool, netmem_ref netmem)
 	return false;
 }
 
-static void page_pool_set_pp_info(struct page_pool *pool, netmem_ref netmem)
+void page_pool_set_pp_info(struct page_pool *pool, netmem_ref netmem)
 {
 	netmem_set_pp(netmem, pool);
 	netmem_or_pp_magic(netmem, PP_SIGNATURE);
-- 
2.43.0


