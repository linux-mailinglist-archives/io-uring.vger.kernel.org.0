Return-Path: <io-uring+bounces-5939-lists+io-uring=lfdr.de@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [147.75.80.249])
	by mail.lfdr.de (Postfix) with ESMTPS id 0256DA1454D
	for <lists+io-uring@lfdr.de>; Fri, 17 Jan 2025 00:19:04 +0100 (CET)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id 96F2918807E9
	for <lists+io-uring@lfdr.de>; Thu, 16 Jan 2025 23:18:59 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 2CA6F2419F1;
	Thu, 16 Jan 2025 23:17:26 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=davidwei-uk.20230601.gappssmtp.com header.i=@davidwei-uk.20230601.gappssmtp.com header.b="uDpyN/8N"
X-Original-To: io-uring@vger.kernel.org
Received: from mail-pl1-f176.google.com (mail-pl1-f176.google.com [209.85.214.176])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5E6B1244FBE
	for <io-uring@vger.kernel.org>; Thu, 16 Jan 2025 23:17:24 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.214.176
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1737069446; cv=none; b=JcHuTU49HaXVO8hTXN8ZdkOUBV+TZjmyhq5L3/aI7WXV82w3qHGEstPnjQJ2P3Ecy0S1ATZBjf0YwjPj/s7J1dTaxi3ZeBfqEO55JxzpNIt94iS9nSwdZ4uJAvTHXv+uZOeqKKXML0IErwIxsa5uO0jVYenE9bN1ldz7csC6CAY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1737069446; c=relaxed/simple;
	bh=M2OzfYpywdq6iTm6K8uQP/OfvoeLl0KtGbk6eyj5Dt8=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=Tp7rGSHl6fQgsL89zeyTYlicEq7SHdyduyJx+ls0aBMm7bZZuU98xPzhXUavzg8FKSSThZ+MZ/QWnMbqbA2vVeocUh1PJqARIAxquUTBPdEcxrOfcQXl7rSN0Sbpt8v6Lfb8M8NCbIS15H8jyz0ctl1Se0caNJbZrrsP3+Obe+I=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=davidwei.uk; spf=none smtp.mailfrom=davidwei.uk; dkim=pass (2048-bit key) header.d=davidwei-uk.20230601.gappssmtp.com header.i=@davidwei-uk.20230601.gappssmtp.com header.b=uDpyN/8N; arc=none smtp.client-ip=209.85.214.176
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=davidwei.uk
Authentication-Results: smtp.subspace.kernel.org; spf=none smtp.mailfrom=davidwei.uk
Received: by mail-pl1-f176.google.com with SMTP id d9443c01a7336-2162c0f6a39so51359735ad.0
        for <io-uring@vger.kernel.org>; Thu, 16 Jan 2025 15:17:24 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=davidwei-uk.20230601.gappssmtp.com; s=20230601; t=1737069444; x=1737674244; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=HCbv9zrg2RTuKravn+6cPY6Vx77zCXxosEzAttkO/ZA=;
        b=uDpyN/8NRREuIckfoJVGA/A9oRP22zFAlOsVWkvmMVehVUCapoOLfSRRiczcTqCsf4
         SyExPat6tjX/M6pA6GfWk/YyJPaMB89GhlU+IVte3MqXUeIXmptEfoMDSS3sXpxGVrM8
         jZiAmc9yWnoS1KLSeXh9MzsOsWzzlNv/gOGaPPEIYLJguJnwZ684r8I5LaLIZp23okln
         a1iNJYIHixGNb+EELpaA72ErLSBDtdEELfxq9a9BA7GFDQrZF9ib+Z7ONDCDMwMVGfPN
         eISZRWiQ8Hu2xIAmeVAAx+sniue1p24vVfRpChUJZl4ankj09ZEg9j5yd9Y9TNECnWDr
         nZFg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1737069444; x=1737674244;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=HCbv9zrg2RTuKravn+6cPY6Vx77zCXxosEzAttkO/ZA=;
        b=Wn48VR8iHsmruSK9vBvJcDzIFMh7QfPnEoOOP6VH6j804BT2fL/TH9QwNvvLZosGZH
         zJINcX6ZJ2/lFKNhMVrfonKCgeKtY+KSAp26ygBGLSD33peQcsbkq5JjQ+HgqDcA0QQi
         Kv3NUA5tu/P8faOxkDbsw9wmoG4zHLxRKZ+zRXTr8TDEtgNzFKs5M5wRWXLdKtRKee84
         r/AnUiZ5TH+asUyCKUI6HtlgHLL3mWx6da6kQkEVSvD+WseX/BVe91N+GjGAqNVXW8DX
         aggJSvXighrki4DR6eRGwedCVs/f+CdzTGNT8DRS51OM1F8yDdbS8LgatFB8vrWmcCon
         dJEQ==
X-Gm-Message-State: AOJu0YxpYdIV9sVEzH4+rfpof4qaPzdXCwEm4FsdK7wmWEO+5pT1bLL1
	TbY0qnKvvlRnj1meXOxcv7JmaFCc0/JwfLYlxlZoP39Nn7SC/7xMbz6LaAJd3jCExg2QXfXeSW/
	A
X-Gm-Gg: ASbGncviZDHag4fxSqSqk/0+eZ4lUm5QQg1UucMuUwpozU9xip2yqPkMFbLzXjXQB8V
	68548quqaZ9XpZjbMbc0Uuh9zrPd0A2ywtpKKLD0+X+DRX9I6j3GIgeL5a5juCGo0hzhRDjqgj2
	/EAKaBWdCd6DpSYSHI0emQ/ujBrJ3j6Uk4katymoKY3C5DrXx2Qo+YOstjobTTVpCPdytG7eUgM
	uNo/cwYRqBlNhcoNG7gaTlM8a9NHlust7eOD3y0iA==
X-Google-Smtp-Source: AGHT+IFfSVZmR/JD9nKef9R2uiu76LwbOmJT1JQxWRasICwF2GZIFUm1+1GkEz0w46VQ329Xq8juPQ==
X-Received: by 2002:a05:6a21:6d9c:b0:1d9:d5e:8297 with SMTP id adf61e73a8af0-1eb216034b9mr722979637.6.1737069443700;
        Thu, 16 Jan 2025 15:17:23 -0800 (PST)
Received: from localhost ([2a03:2880:ff:74::])
        by smtp.gmail.com with ESMTPSA id d2e1a72fcca58-72dab848475sm554860b3a.81.2025.01.16.15.17.23
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 16 Jan 2025 15:17:23 -0800 (PST)
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
	Stanislav Fomichev <stfomichev@gmail.com>,
	Joe Damato <jdamato@fastly.com>,
	Pedro Tammela <pctammela@mojatatu.com>
Subject: [PATCH net-next v11 14/21] io_uring/zcrx: implement zerocopy receive pp memory provider
Date: Thu, 16 Jan 2025 15:16:56 -0800
Message-ID: <20250116231704.2402455-15-dw@davidwei.uk>
X-Mailer: git-send-email 2.43.5
In-Reply-To: <20250116231704.2402455-1-dw@davidwei.uk>
References: <20250116231704.2402455-1-dw@davidwei.uk>
Precedence: bulk
X-Mailing-List: io-uring@vger.kernel.org
List-Id: <io-uring.vger.kernel.org>
List-Subscribe: <mailto:io-uring+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:io-uring+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

From: Pavel Begunkov <asml.silence@gmail.com>

Implement a page pool memory provider for io_uring to receieve in a
zero copy fashion. For that, the provider allocates user pages wrapped
around into struct net_iovs, that are stored in a previously registered
struct net_iov_area.

Unlike the traditional receive, that frees pages and returns them back
to the page pool right after data was copied to the user, e.g. inside
recv(2), we extend the lifetime until the user space confirms that it's
done processing the data. That's done by taking a net_iov reference.
When the user is done with the buffer, it must return it back to the
kernel by posting an entry into the refill ring, which is usually polled
off the io_uring memory provider callback in the page pool's netmem
allocation path.

There is also a separate set of per net_iov "user" references accounting
whether a buffer is currently given to the user (including possible
fragmentation).

Reviewed-by: Jens Axboe <axboe@kernel.dk>
Signed-off-by: Pavel Begunkov <asml.silence@gmail.com>
Signed-off-by: David Wei <dw@davidwei.uk>
---
 io_uring/zcrx.c | 269 ++++++++++++++++++++++++++++++++++++++++++++++++
 io_uring/zcrx.h |   3 +
 2 files changed, 272 insertions(+)

diff --git a/io_uring/zcrx.c b/io_uring/zcrx.c
index 435cd634f91c..c007ff80b325 100644
--- a/io_uring/zcrx.c
+++ b/io_uring/zcrx.c
@@ -2,10 +2,17 @@
 #include <linux/kernel.h>
 #include <linux/errno.h>
 #include <linux/mm.h>
+#include <linux/nospec.h>
 #include <linux/io_uring.h>
 #include <linux/netdevice.h>
 #include <linux/rtnetlink.h>
 
+#include <net/page_pool/helpers.h>
+#include <net/page_pool/memory_provider.h>
+#include <net/netlink.h>
+
+#include <trace/events/page_pool.h>
+
 #include <uapi/linux/io_uring.h>
 
 #include "io_uring.h"
@@ -16,6 +23,33 @@
 
 #define IO_RQ_MAX_ENTRIES		32768
 
+__maybe_unused
+static const struct memory_provider_ops io_uring_pp_zc_ops;
+
+static inline struct io_zcrx_area *io_zcrx_iov_to_area(const struct net_iov *niov)
+{
+	struct net_iov_area *owner = net_iov_owner(niov);
+
+	return container_of(owner, struct io_zcrx_area, nia);
+}
+
+static inline atomic_t *io_get_user_counter(struct net_iov *niov)
+{
+	struct io_zcrx_area *area = io_zcrx_iov_to_area(niov);
+
+	return &area->user_refs[net_iov_idx(niov)];
+}
+
+static bool io_zcrx_put_niov_uref(struct net_iov *niov)
+{
+	atomic_t *uref = io_get_user_counter(niov);
+
+	if (unlikely(!atomic_read(uref)))
+		return false;
+	atomic_dec(uref);
+	return true;
+}
+
 static int io_allocate_rbuf_ring(struct io_zcrx_ifq *ifq,
 				 struct io_uring_zcrx_ifq_reg *reg,
 				 struct io_uring_region_desc *rd)
@@ -51,6 +85,7 @@ static void io_zcrx_free_area(struct io_zcrx_area *area)
 {
 	kvfree(area->freelist);
 	kvfree(area->nia.niovs);
+	kvfree(area->user_refs);
 	if (area->pages) {
 		unpin_user_pages(area->pages, area->nia.num_niovs);
 		kvfree(area->pages);
@@ -106,6 +141,19 @@ static int io_zcrx_create_area(struct io_zcrx_ifq *ifq,
 	for (i = 0; i < nr_pages; i++)
 		area->freelist[i] = i;
 
+	area->user_refs = kvmalloc_array(nr_pages, sizeof(area->user_refs[0]),
+					GFP_KERNEL | __GFP_ZERO);
+	if (!area->user_refs)
+		goto err;
+
+	for (i = 0; i < nr_pages; i++) {
+		struct net_iov *niov = &area->nia.niovs[i];
+
+		niov->owner = &area->nia;
+		area->freelist[i] = i;
+		atomic_set(&area->user_refs[i], 0);
+	}
+
 	area->free_count = nr_pages;
 	area->ifq = ifq;
 	/* we're only supporting one area per ifq for now */
@@ -131,6 +179,7 @@ static struct io_zcrx_ifq *io_zcrx_ifq_alloc(struct io_ring_ctx *ctx)
 	ifq->if_rxq = -1;
 	ifq->ctx = ctx;
 	spin_lock_init(&ifq->lock);
+	spin_lock_init(&ifq->rq_lock);
 	return ifq;
 }
 
@@ -256,7 +305,227 @@ void io_unregister_zcrx_ifqs(struct io_ring_ctx *ctx)
 	io_zcrx_ifq_free(ifq);
 }
 
+static struct net_iov *__io_zcrx_get_free_niov(struct io_zcrx_area *area)
+{
+	unsigned niov_idx;
+
+	lockdep_assert_held(&area->freelist_lock);
+
+	niov_idx = area->freelist[--area->free_count];
+	return &area->nia.niovs[niov_idx];
+}
+
+static void io_zcrx_return_niov_freelist(struct net_iov *niov)
+{
+	struct io_zcrx_area *area = io_zcrx_iov_to_area(niov);
+
+	spin_lock_bh(&area->freelist_lock);
+	area->freelist[area->free_count++] = net_iov_idx(niov);
+	spin_unlock_bh(&area->freelist_lock);
+}
+
+static void io_zcrx_return_niov(struct net_iov *niov)
+{
+	netmem_ref netmem = net_iov_to_netmem(niov);
+
+	page_pool_put_unrefed_netmem(niov->pp, netmem, -1, false);
+}
+
+static void io_zcrx_scrub(struct io_zcrx_ifq *ifq)
+{
+	struct io_zcrx_area *area = ifq->area;
+	int i;
+
+	if (!area)
+		return;
+
+	/* Reclaim back all buffers given to the user space. */
+	for (i = 0; i < area->nia.num_niovs; i++) {
+		struct net_iov *niov = &area->nia.niovs[i];
+		int nr;
+
+		if (!atomic_read(io_get_user_counter(niov)))
+			continue;
+		nr = atomic_xchg(io_get_user_counter(niov), 0);
+		if (nr && !page_pool_unref_netmem(net_iov_to_netmem(niov), nr))
+			io_zcrx_return_niov(niov);
+	}
+}
+
 void io_shutdown_zcrx_ifqs(struct io_ring_ctx *ctx)
 {
 	lockdep_assert_held(&ctx->uring_lock);
+
+	if (ctx->ifq)
+		io_zcrx_scrub(ctx->ifq);
+}
+
+static inline u32 io_zcrx_rqring_entries(struct io_zcrx_ifq *ifq)
+{
+	u32 entries;
+
+	entries = smp_load_acquire(&ifq->rq_ring->tail) - ifq->cached_rq_head;
+	return min(entries, ifq->rq_entries);
 }
+
+static struct io_uring_zcrx_rqe *io_zcrx_get_rqe(struct io_zcrx_ifq *ifq,
+						 unsigned mask)
+{
+	unsigned int idx = ifq->cached_rq_head++ & mask;
+
+	return &ifq->rqes[idx];
+}
+
+static void io_zcrx_ring_refill(struct page_pool *pp,
+				struct io_zcrx_ifq *ifq)
+{
+	unsigned int mask = ifq->rq_entries - 1;
+	unsigned int entries;
+	netmem_ref netmem;
+
+	spin_lock_bh(&ifq->rq_lock);
+
+	entries = io_zcrx_rqring_entries(ifq);
+	entries = min_t(unsigned, entries, PP_ALLOC_CACHE_REFILL - pp->alloc.count);
+	if (unlikely(!entries)) {
+		spin_unlock_bh(&ifq->rq_lock);
+		return;
+	}
+
+	do {
+		struct io_uring_zcrx_rqe *rqe = io_zcrx_get_rqe(ifq, mask);
+		struct io_zcrx_area *area;
+		struct net_iov *niov;
+		unsigned niov_idx, area_idx;
+
+		area_idx = rqe->off >> IORING_ZCRX_AREA_SHIFT;
+		niov_idx = (rqe->off & ~IORING_ZCRX_AREA_MASK) >> PAGE_SHIFT;
+
+		if (unlikely(rqe->__pad || area_idx))
+			continue;
+		area = ifq->area;
+
+		if (unlikely(niov_idx >= area->nia.num_niovs))
+			continue;
+		niov_idx = array_index_nospec(niov_idx, area->nia.num_niovs);
+
+		niov = &area->nia.niovs[niov_idx];
+		if (!io_zcrx_put_niov_uref(niov))
+			continue;
+
+		netmem = net_iov_to_netmem(niov);
+		if (page_pool_unref_netmem(netmem, 1) != 0)
+			continue;
+
+		if (unlikely(niov->pp != pp)) {
+			io_zcrx_return_niov(niov);
+			continue;
+		}
+
+		net_mp_netmem_place_in_cache(pp, netmem);
+	} while (--entries);
+
+	smp_store_release(&ifq->rq_ring->head, ifq->cached_rq_head);
+	spin_unlock_bh(&ifq->rq_lock);
+}
+
+static void io_zcrx_refill_slow(struct page_pool *pp, struct io_zcrx_ifq *ifq)
+{
+	struct io_zcrx_area *area = ifq->area;
+
+	spin_lock_bh(&area->freelist_lock);
+	while (area->free_count && pp->alloc.count < PP_ALLOC_CACHE_REFILL) {
+		struct net_iov *niov = __io_zcrx_get_free_niov(area);
+		netmem_ref netmem = net_iov_to_netmem(niov);
+
+		net_mp_niov_set_page_pool(pp, niov);
+		net_mp_netmem_place_in_cache(pp, netmem);
+	}
+	spin_unlock_bh(&area->freelist_lock);
+}
+
+static netmem_ref io_pp_zc_alloc_netmems(struct page_pool *pp, gfp_t gfp)
+{
+	struct io_zcrx_ifq *ifq = pp->mp_priv;
+
+	/* pp should already be ensuring that */
+	if (unlikely(pp->alloc.count))
+		goto out_return;
+
+	io_zcrx_ring_refill(pp, ifq);
+	if (likely(pp->alloc.count))
+		goto out_return;
+
+	io_zcrx_refill_slow(pp, ifq);
+	if (!pp->alloc.count)
+		return 0;
+out_return:
+	return pp->alloc.cache[--pp->alloc.count];
+}
+
+static bool io_pp_zc_release_netmem(struct page_pool *pp, netmem_ref netmem)
+{
+	struct net_iov *niov;
+
+	if (WARN_ON_ONCE(!netmem_is_net_iov(netmem)))
+		return false;
+
+	niov = netmem_to_net_iov(netmem);
+	net_mp_niov_clear_page_pool(niov);
+	io_zcrx_return_niov_freelist(niov);
+	return false;
+}
+
+static int io_pp_zc_init(struct page_pool *pp)
+{
+	struct io_zcrx_ifq *ifq = pp->mp_priv;
+
+	if (WARN_ON_ONCE(!ifq))
+		return -EINVAL;
+	if (pp->dma_map)
+		return -EOPNOTSUPP;
+	if (pp->p.order != 0)
+		return -EOPNOTSUPP;
+
+	percpu_ref_get(&ifq->ctx->refs);
+	return 0;
+}
+
+static void io_pp_zc_destroy(struct page_pool *pp)
+{
+	struct io_zcrx_ifq *ifq = pp->mp_priv;
+	struct io_zcrx_area *area = ifq->area;
+
+	if (WARN_ON_ONCE(area->free_count != area->nia.num_niovs))
+		return;
+	percpu_ref_put(&ifq->ctx->refs);
+}
+
+static int io_pp_nl_fill(void *mp_priv, struct sk_buff *rsp,
+			 struct netdev_rx_queue *rxq)
+{
+	struct nlattr *nest;
+	int type;
+
+	type = rxq ? NETDEV_A_QUEUE_IO_URING : NETDEV_A_PAGE_POOL_IO_URING;
+	nest = nla_nest_start(rsp, type);
+	nla_nest_end(rsp, nest);
+
+	return 0;
+}
+
+static void io_pp_uninstall(void *mp_priv, struct netdev_rx_queue *rxq)
+{
+	struct io_zcrx_ifq *ifq = mp_priv;
+
+	io_zcrx_drop_netdev(ifq);
+}
+
+static const struct memory_provider_ops io_uring_pp_zc_ops = {
+	.alloc_netmems		= io_pp_zc_alloc_netmems,
+	.release_netmem		= io_pp_zc_release_netmem,
+	.init			= io_pp_zc_init,
+	.destroy		= io_pp_zc_destroy,
+	.nl_fill		= io_pp_nl_fill,
+	.uninstall		= io_pp_uninstall,
+};
diff --git a/io_uring/zcrx.h b/io_uring/zcrx.h
index 595bca0001d2..6c808240ac91 100644
--- a/io_uring/zcrx.h
+++ b/io_uring/zcrx.h
@@ -9,6 +9,7 @@
 struct io_zcrx_area {
 	struct net_iov_area	nia;
 	struct io_zcrx_ifq	*ifq;
+	atomic_t		*user_refs;
 
 	u16			area_id;
 	struct page		**pages;
@@ -26,6 +27,8 @@ struct io_zcrx_ifq {
 	struct io_uring			*rq_ring;
 	struct io_uring_zcrx_rqe	*rqes;
 	u32				rq_entries;
+	u32				cached_rq_head;
+	spinlock_t			rq_lock;
 
 	u32				if_rxq;
 	struct device			*dev;
-- 
2.43.5


