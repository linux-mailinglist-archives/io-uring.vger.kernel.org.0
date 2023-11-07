Return-Path: <io-uring+bounces-58-lists+io-uring=lfdr.de@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [139.178.88.99])
	by mail.lfdr.de (Postfix) with ESMTPS id 5A7AA7E4AE8
	for <lists+io-uring@lfdr.de>; Tue,  7 Nov 2023 22:41:43 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 0EA182814D7
	for <lists+io-uring@lfdr.de>; Tue,  7 Nov 2023 21:41:42 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 4C13B2B2E2;
	Tue,  7 Nov 2023 21:41:07 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=davidwei-uk.20230601.gappssmtp.com header.i=@davidwei-uk.20230601.gappssmtp.com header.b="rAlFztHq"
X-Original-To: io-uring@vger.kernel.org
Received: from lindbergh.monkeyblade.net (lindbergh.monkeyblade.net [23.128.96.19])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4DD682A8F2
	for <io-uring@vger.kernel.org>; Tue,  7 Nov 2023 21:41:04 +0000 (UTC)
Received: from mail-pf1-x430.google.com (mail-pf1-x430.google.com [IPv6:2607:f8b0:4864:20::430])
	by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 7CB5810E7
	for <io-uring@vger.kernel.org>; Tue,  7 Nov 2023 13:41:03 -0800 (PST)
Received: by mail-pf1-x430.google.com with SMTP id d2e1a72fcca58-6c431b91b2aso1138636b3a.1
        for <io-uring@vger.kernel.org>; Tue, 07 Nov 2023 13:41:03 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=davidwei-uk.20230601.gappssmtp.com; s=20230601; t=1699393263; x=1699998063; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=QAg0Jz6lJH3QD8K6wvrjVW15K9s2A8jtw8v6eF5xseE=;
        b=rAlFztHqWLTLhgIFyZjUTBG1xOjq/9Nr9ueCzJTXlMn5BPWKRxOhsfh45DzhhR4Fjy
         dypaAiJbLyz6xrULQm4aQE2FmBclja+XuHGncjde9F99tZ+JjpqaCJ6sp/lCY5smEd9j
         Sl+G4WC5vEWA38ZbtV8RebuSoWNGHlTZflF1jREF/ecPes+msYDGzR//pg1oDCa0afNe
         tBdo/mvW41QOzSEZ84QKJ655rNkNvPF7sv04U7ZWBrBuJwrNa7UKv9Vt5NdpcDmNIwuR
         a4I7I/Xt+T2TPWVYIuOpLEQtwFilortTUCV7RofHGypJJ1pp+bg0s6T+p/TH5hNMLQqE
         cu/Q==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1699393263; x=1699998063;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=QAg0Jz6lJH3QD8K6wvrjVW15K9s2A8jtw8v6eF5xseE=;
        b=F0SypF3azn/fWCSDjZ7qzMuTqh8cHgRjRx8+MaU/+mNenPNPy9N5nRHj2lnHAOrMGR
         i0dSzqyBvWpmG+441EiqOxnN61xMeXFJzHeC/3TpQCuV8aGED/nu1anXvxYVHN3v6qHp
         Sv3Ndyp5vNvbXd67czGuc0JkR9uwnP3r82Ilr5nFiMmqZElOvXpUtjilBfzhFu+ixhI9
         14FOGyrv7loKe9jpyvJaK0yQ1WkPQIKyjdkVucmsxnFWa0dgHRr2wP7PgsiJIzWZnFvN
         rvJYNvH6ccmNc0hOyzpp3GVS/oDOQUMNPtBhf0eX814OX5vx73l24/bhOr4yPConDvb1
         gF9Q==
X-Gm-Message-State: AOJu0Yy0AYkFJKweLgyu1GzSZAOmRsQIGLZBqiCDp3YA6lxBNc5jMf/h
	Vs7ZEQWZZ+IHcrcRm1XJWgOwkz1Hjvr7xvFCYwYCvw==
X-Google-Smtp-Source: AGHT+IHWYyJ4PUWdPclTsrmoG8Zst9HyiUfl18diZ3k13PQj+J9uDi1i72YwmExYAzIS6Djd7WPR0w==
X-Received: by 2002:a05:6a20:da8a:b0:181:b86b:41f with SMTP id iy10-20020a056a20da8a00b00181b86b041fmr291675pzb.33.1699393262766;
        Tue, 07 Nov 2023 13:41:02 -0800 (PST)
Received: from localhost (fwdproxy-prn-021.fbsv.net. [2a03:2880:ff:15::face:b00c])
        by smtp.gmail.com with ESMTPSA id m5-20020a62f205000000b006c0678eab2csm7792252pfh.90.2023.11.07.13.41.02
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 07 Nov 2023 13:41:02 -0800 (PST)
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
Subject: [PATCH 07/20] io_uring: add ZC pool API
Date: Tue,  7 Nov 2023 13:40:32 -0800
Message-Id: <20231107214045.2172393-8-dw@davidwei.uk>
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

This patch adds an API to get/put bufs from a ZC pool added in the
previous patch.

Recall that there is an rbuf refill ring in an ifq that is shared w/
userspace, which puts bufs it is done with back into it. A new tier is
added to the ZC pool that drains entries from the refill ring to put
into the cache. So when the cache is empty, it is refilled from the
refill ring first, then the freelist.

ZC bufs are refcounted. Userspace is given an off + len into the entire
ZC pool region, not individual pages from ZC bufs. A net device may pack
multiple packets into the same page it gets from a ZC buf, so it is
possible for the same ZC buf to be handed out to userspace multiple
times.

This means it is possible to drain the entire refill ring, and have no
usable free bufs. Suggestions for dealing w/ this are very welcome!

Only up to POOL_REFILL_COUNT entries are refilled from the refill ring.
Given the above, we may want to limit the amount of work being done
since refilling happens inside the NAPI softirq context.

Co-developed-by: Pavel Begunkov <asml.silence@gmail.com>
Signed-off-by: Pavel Begunkov <asml.silence@gmail.com>
Signed-off-by: David Wei <dw@davidwei.uk>
---
 include/linux/io_uring.h | 19 ++++++++
 io_uring/zc_rx.c         | 95 ++++++++++++++++++++++++++++++++++++++++
 io_uring/zc_rx.h         | 11 +++++
 3 files changed, 125 insertions(+)

diff --git a/include/linux/io_uring.h b/include/linux/io_uring.h
index abfb73e257a4..624515a8bdd5 100644
--- a/include/linux/io_uring.h
+++ b/include/linux/io_uring.h
@@ -70,6 +70,18 @@ static inline void io_uring_cmd_complete_in_task(struct io_uring_cmd *ioucmd,
 	__io_uring_cmd_do_in_task(ioucmd, task_work_cb, 0);
 }
 
+struct io_zc_rx_ifq;
+struct io_zc_rx_buf *io_zc_rx_get_buf(struct io_zc_rx_ifq *ifq);
+void io_zc_rx_put_buf(struct io_zc_rx_ifq *ifq, struct io_zc_rx_buf *buf);
+
+static inline dma_addr_t io_zc_rx_buf_dma(struct io_zc_rx_buf *buf)
+{
+	return buf->dma;
+}
+static inline struct page *io_zc_rx_buf_page(struct io_zc_rx_buf *buf)
+{
+	return buf->page;
+}
 static inline void io_uring_files_cancel(void)
 {
 	if (current->io_uring) {
@@ -106,6 +118,13 @@ static inline void io_uring_cmd_do_in_task_lazy(struct io_uring_cmd *ioucmd,
 			void (*task_work_cb)(struct io_uring_cmd *, unsigned))
 {
 }
+static inline struct io_zc_rx_buf *io_zc_rx_get_buf(struct io_zc_rx_ifq *ifq)
+{
+	return NULL;
+}
+static inline void io_zc_rx_put_buf(struct io_zc_rx_ifq *ifq, struct io_zc_rx_buf *buf)
+{
+}
 static inline struct sock *io_uring_get_socket(struct file *file)
 {
 	return NULL;
diff --git a/io_uring/zc_rx.c b/io_uring/zc_rx.c
index 0f5fa9ab5cec..840a21549d89 100644
--- a/io_uring/zc_rx.c
+++ b/io_uring/zc_rx.c
@@ -16,6 +16,9 @@
 #include "rsrc.h"
 
 #define POOL_CACHE_SIZE	128
+#define POOL_REFILL_COUNT	64
+#define IO_ZC_RX_UREF		0x10000
+#define IO_ZC_RX_KREF_MASK	(IO_ZC_RX_UREF - 1)
 
 struct io_zc_rx_pool {
 	struct io_zc_rx_ifq  	*ifq;
@@ -269,6 +272,8 @@ int io_register_zc_rx_ifq(struct io_ring_ctx *ctx,
 
 	ifq->rq_entries = reg.rq_entries;
 	ifq->cq_entries = reg.cq_entries;
+	ifq->cached_rq_head = 0;
+	ifq->cached_cq_tail = 0;
 	ifq->if_rxq_id = reg.if_rxq_id;
 	ctx->ifq = ifq;
 
@@ -371,4 +376,94 @@ int io_register_zc_rx_sock(struct io_ring_ctx *ctx,
 	ifq->nr_sockets++;
 	return 0;
 }
+
+static bool io_zc_rx_put_buf_uref(struct io_zc_rx_buf *buf)
+{
+	if (atomic_read(&buf->refcount) < IO_ZC_RX_UREF)
+		return false;
+
+	return atomic_sub_and_test(IO_ZC_RX_UREF, &buf->refcount);
+}
+
+static void io_zc_rx_refill_cache(struct io_zc_rx_ifq *ifq, int count)
+{
+	unsigned int entries = io_zc_rx_rqring_entries(ifq);
+	unsigned int mask = ifq->rq_entries - 1;
+	struct io_zc_rx_pool *pool = ifq->pool;
+	struct io_uring_rbuf_rqe *rqe;
+	struct io_zc_rx_buf *buf;
+	int i, filled;
+
+	if (!entries)
+		return;
+
+	for (i = 0, filled = 0; i < entries && filled < count; i++) {
+		unsigned int rq_idx = ifq->cached_rq_head++ & mask;
+		u32 pgid;
+
+		rqe = &ifq->rqes[rq_idx];
+		pgid = rqe->off / PAGE_SIZE;
+		buf = &pool->bufs[pgid];
+		if (!io_zc_rx_put_buf_uref(buf))
+			continue;
+		pool->cache[filled++] = pgid;
+	}
+
+	smp_store_release(&ifq->ring->rq.head, ifq->cached_rq_head);
+	pool->cache_count += filled;
+}
+
+struct io_zc_rx_buf *io_zc_rx_get_buf(struct io_zc_rx_ifq *ifq)
+{
+	struct io_zc_rx_pool *pool = ifq->pool;
+	struct io_zc_rx_buf *buf;
+	int count;
+	u32 pgid;
+
+	lockdep_assert_no_hardirq();
+
+	if (likely(pool->cache_count))
+		goto out;
+
+	io_zc_rx_refill_cache(ifq, POOL_REFILL_COUNT);
+	if (pool->cache_count)
+		goto out;
+
+	spin_lock_bh(&pool->freelist_lock);
+	count = min_t(u32, pool->free_count, POOL_CACHE_SIZE);
+	pool->free_count -= count;
+	pool->cache_count += count;
+	memcpy(pool->cache, &pool->freelist[pool->free_count],
+	       count * sizeof(u32));
+	spin_unlock_bh(&pool->freelist_lock);
+
+	if (!pool->cache_count)
+		return NULL;
+out:
+	pgid = pool->cache[--pool->cache_count];
+	buf = &pool->bufs[pgid];
+	atomic_set(&buf->refcount, 1);
+	return buf;
+}
+EXPORT_SYMBOL(io_zc_rx_get_buf);
+
+static void io_zc_rx_recycle_buf(struct io_zc_rx_pool *pool,
+				 struct io_zc_rx_buf *buf)
+{
+	spin_lock_bh(&pool->freelist_lock);
+	pool->freelist[pool->free_count++] = buf - pool->bufs;
+	spin_unlock_bh(&pool->freelist_lock);
+}
+
+void io_zc_rx_put_buf(struct io_zc_rx_ifq *ifq, struct io_zc_rx_buf *buf)
+{
+	struct io_zc_rx_pool *pool = ifq->pool;
+
+	if (!atomic_dec_and_test(&buf->refcount))
+		return;
+
+	io_zc_rx_recycle_buf(pool, buf);
+}
+EXPORT_SYMBOL(io_zc_rx_put_buf);
+
 #endif
diff --git a/io_uring/zc_rx.h b/io_uring/zc_rx.h
index ab25f8dbb433..a3df820e52e7 100644
--- a/io_uring/zc_rx.h
+++ b/io_uring/zc_rx.h
@@ -16,6 +16,8 @@ struct io_zc_rx_ifq {
 	struct io_uring_rbuf_rqe *rqes;
 	struct io_uring_rbuf_cqe *cqes;
 	u32			rq_entries, cq_entries;
+	u32			cached_rq_head;
+	u32			cached_cq_tail;
 	void			*pool;
 
 	unsigned		nr_sockets;
@@ -26,6 +28,15 @@ struct io_zc_rx_ifq {
 };
 
 #if defined(CONFIG_NET)
+static inline u32 io_zc_rx_rqring_entries(struct io_zc_rx_ifq *ifq)
+{
+	struct io_rbuf_ring *ring = ifq->ring;
+	u32 entries;
+
+	entries = smp_load_acquire(&ring->rq.tail) - ifq->cached_rq_head;
+	return min(entries, ifq->rq_entries);
+}
+
 int io_register_zc_rx_ifq(struct io_ring_ctx *ctx,
 			  struct io_uring_zc_rx_ifq_reg __user *arg);
 int io_unregister_zc_rx_ifq(struct io_ring_ctx *ctx);
-- 
2.39.3


