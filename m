Return-Path: <io-uring+bounces-68-lists+io-uring=lfdr.de@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [IPv6:2604:1380:45e3:2400::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 34D9D7E4AFF
	for <lists+io-uring@lfdr.de>; Tue,  7 Nov 2023 22:42:37 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id E52C0281465
	for <lists+io-uring@lfdr.de>; Tue,  7 Nov 2023 21:42:35 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id B6D002CCBE;
	Tue,  7 Nov 2023 21:41:16 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=davidwei-uk.20230601.gappssmtp.com header.i=@davidwei-uk.20230601.gappssmtp.com header.b="Damd4j7n"
X-Original-To: io-uring@vger.kernel.org
Received: from lindbergh.monkeyblade.net (lindbergh.monkeyblade.net [23.128.96.19])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B18CD2BD13
	for <io-uring@vger.kernel.org>; Tue,  7 Nov 2023 21:41:12 +0000 (UTC)
Received: from mail-pl1-x62d.google.com (mail-pl1-x62d.google.com [IPv6:2607:f8b0:4864:20::62d])
	by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 3945D10E5
	for <io-uring@vger.kernel.org>; Tue,  7 Nov 2023 13:41:12 -0800 (PST)
Received: by mail-pl1-x62d.google.com with SMTP id d9443c01a7336-1cc3c51f830so47359835ad.1
        for <io-uring@vger.kernel.org>; Tue, 07 Nov 2023 13:41:12 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=davidwei-uk.20230601.gappssmtp.com; s=20230601; t=1699393271; x=1699998071; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=xpoMSiM7fsnsF8gAcS74BCI3r9yY1Vj9o22YU2WHyDA=;
        b=Damd4j7n/+Ewv5u83FOG9R8VcapUTXZkhSjcAjhQD+3wbpzx5NFiubJIJevUDo0c9H
         NsBFDrVMa6vNUk39DfP8WFCLClTZBMT9CD+JGcsDeRgFWPIMWvH6o1TRbKJDD6wFWe4/
         zrxRPRDPjl+JQwNhj6mWUjCZgPgLqbaOYiKfotXM3ifrz8Gtp+Wz+gm4XNQMWS7jNHV4
         m3oLpcw2/rYjamdR9XX6ORRGxoMYQIpBPnfAGoAB9jpNuPdYvx63WBO15cX7ikwUc0WH
         cf/qRqgDmdsrqjTVluyqKhrsoWyjSv9J/HAEWJ5ZLkRiGFnkkaIb3jx9UPiObie5EO1J
         gNCA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1699393271; x=1699998071;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=xpoMSiM7fsnsF8gAcS74BCI3r9yY1Vj9o22YU2WHyDA=;
        b=Ca/oyLuOiRS93W9ERv0Ab9DXOtuQNXB7Jpb4/oEDYdTkflVVZGC36Y0+4lw2OsFSJO
         Mf45otCbPhp3UrI5H6c7QDtA5w/II2wdi/KlMEzgIMep7cZ+9XLvRsVvUrm8kjEt0lrc
         BNclNrN3/xfNZ6ea4VhtWrK09VJiQvlvIqD5OrwtEI7l8+Cga3ibDCs7+aE0bQUV619/
         o2JOQgZ5Vwe4LB6BhpN9DOIdSceXE2gnH8gljYiFpnAg1ARGgwxWaJ/uCSMs3Q++DxFu
         GczYceAUjyZA96F8Msxy/pU88rL1LwNHwToXtv6cS4Ys9vi5v+joeB64dFuf1bf6UjtJ
         wXLQ==
X-Gm-Message-State: AOJu0YzLJwviiQPevrz5vEOKMkYHfqe6n4xFeHB+Ec7WKHExXsqu/KH2
	b9DlnnVZLzSEpksqKT9wTQC2JW+1mEo2gslZAkrs3w==
X-Google-Smtp-Source: AGHT+IHtozb1N6C8iJ3U75mzIC4LwKXFGI/Y3hhHNrrAdS+TnaNZlMdQryi+qh+yEi1QBFVqjwPNYA==
X-Received: by 2002:a17:903:2349:b0:1cc:436d:39dd with SMTP id c9-20020a170903234900b001cc436d39ddmr217210plh.65.1699393271584;
        Tue, 07 Nov 2023 13:41:11 -0800 (PST)
Received: from localhost (fwdproxy-prn-004.fbsv.net. [2a03:2880:ff:4::face:b00c])
        by smtp.gmail.com with ESMTPSA id g10-20020a170902934a00b001b0358848b0sm273327plp.161.2023.11.07.13.41.11
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 07 Nov 2023 13:41:11 -0800 (PST)
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
Subject: [PATCH 17/20] io_uring/zcrx: copy fallback to ring buffers
Date: Tue,  7 Nov 2023 13:40:42 -0800
Message-Id: <20231107214045.2172393-18-dw@davidwei.uk>
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

From: Pavel Begunkov <asml.silence@gmail.com>

The copy fallback is currently limited to spinlock protected ->freelist,
but we also want to be able to grab buffers from the refill queue, which
is napi protected. Use the new napi_execute() helper to inject a
function call into the napi context.

todo: the way we set napi_id with io_zc_rx_set_napi in drivers later is
not reliable, we should catch all netif_napi_del() and update the id.

Signed-off-by: Pavel Begunkov <asml.silence@gmail.com>
Signed-off-by: David Wei <dw@davidwei.uk>
---
 include/linux/io_uring.h |  1 +
 io_uring/zc_rx.c         | 45 ++++++++++++++++++++++++++++++++++++++--
 io_uring/zc_rx.h         |  1 +
 3 files changed, 45 insertions(+), 2 deletions(-)

diff --git a/include/linux/io_uring.h b/include/linux/io_uring.h
index fb88e000c156..bf886d6de4e0 100644
--- a/include/linux/io_uring.h
+++ b/include/linux/io_uring.h
@@ -75,6 +75,7 @@ struct io_zc_rx_buf *io_zc_rx_get_buf(struct io_zc_rx_ifq *ifq);
 struct io_zc_rx_buf *io_zc_rx_buf_from_page(struct io_zc_rx_ifq *ifq,
 					    struct page *page);
 void io_zc_rx_put_buf(struct io_zc_rx_ifq *ifq, struct io_zc_rx_buf *buf);
+void io_zc_rx_set_napi(struct io_zc_rx_ifq *ifq, unsigned napi_id);
 
 static inline dma_addr_t io_zc_rx_buf_dma(struct io_zc_rx_buf *buf)
 {
diff --git a/io_uring/zc_rx.c b/io_uring/zc_rx.c
index c2ed600f0951..14328024a550 100644
--- a/io_uring/zc_rx.c
+++ b/io_uring/zc_rx.c
@@ -7,6 +7,7 @@
 #include <linux/netdevice.h>
 #include <linux/nospec.h>
 #include <net/tcp.h>
+#include <net/busy_poll.h>
 
 #include <uapi/linux/io_uring.h>
 
@@ -41,6 +42,11 @@ struct io_zc_rx_pool {
 	u32			freelist[];
 };
 
+struct io_zc_refill_data {
+	struct io_zc_rx_ifq *ifq;
+	unsigned count;
+};
+
 static inline u32 io_zc_rx_cqring_entries(struct io_zc_rx_ifq *ifq)
 {
 	struct io_rbuf_ring *ring = ifq->ring;
@@ -244,6 +250,12 @@ static void io_zc_rx_destroy_ifq(struct io_zc_rx_ifq *ifq)
 	kfree(ifq);
 }
 
+void io_zc_rx_set_napi(struct io_zc_rx_ifq *ifq, unsigned napi_id)
+{
+	ifq->napi_id = napi_id;
+}
+EXPORT_SYMBOL(io_zc_rx_set_napi);
+
 static void io_zc_rx_destroy_pool_work(struct work_struct *work)
 {
 	struct io_zc_rx_pool *pool = container_of(
@@ -498,14 +510,43 @@ static void io_zc_rx_refill_cache(struct io_zc_rx_ifq *ifq, int count)
 	pool->cache_count += filled;
 }
 
+static bool io_napi_refill(void *data)
+{
+	struct io_zc_refill_data *rd = data;
+	struct io_zc_rx_ifq *ifq = rd->ifq;
+	struct io_zc_rx_pool *pool = ifq->pool;
+	int i, count = rd->count;
+
+	lockdep_assert_no_hardirq();
+
+	if (!pool->cache_count)
+		io_zc_rx_refill_cache(ifq, POOL_REFILL_COUNT);
+
+	spin_lock_bh(&pool->freelist_lock);
+	for (i = 0; i < count && pool->cache_count; i++) {
+		u32 pgid;
+
+		pgid = pool->cache[--pool->cache_count];
+		pool->freelist[pool->free_count++] = pgid;
+	}
+	spin_unlock_bh(&pool->freelist_lock);
+	return true;
+}
+
 static struct io_zc_rx_buf *io_zc_get_buf_task_safe(struct io_zc_rx_ifq *ifq)
 {
 	struct io_zc_rx_pool *pool = ifq->pool;
 	struct io_zc_rx_buf *buf = NULL;
 	u32 pgid;
 
-	if (!READ_ONCE(pool->free_count))
-		return NULL;
+	if (!READ_ONCE(pool->free_count)) {
+		struct io_zc_refill_data rd = {
+			.ifq = ifq,
+			.count = 1,
+		};
+
+		napi_execute(ifq->napi_id, io_napi_refill, &rd);
+	}
 
 	spin_lock_bh(&pool->freelist_lock);
 	if (pool->free_count) {
diff --git a/io_uring/zc_rx.h b/io_uring/zc_rx.h
index fac32089e699..fd8828e4bd7a 100644
--- a/io_uring/zc_rx.h
+++ b/io_uring/zc_rx.h
@@ -20,6 +20,7 @@ struct io_zc_rx_ifq {
 	u32			cached_rq_head;
 	u32			cached_cq_tail;
 	void			*pool;
+	unsigned int		napi_id;
 
 	unsigned		nr_sockets;
 	struct file		*sockets[IO_ZC_MAX_IFQ_SOCKETS];
-- 
2.39.3


