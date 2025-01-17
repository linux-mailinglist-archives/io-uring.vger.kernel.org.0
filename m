Return-Path: <io-uring+bounces-5984-lists+io-uring=lfdr.de@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [147.75.199.223])
	by mail.lfdr.de (Postfix) with ESMTPS id C31D7A153D8
	for <lists+io-uring@lfdr.de>; Fri, 17 Jan 2025 17:12:21 +0100 (CET)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id EB8231609DB
	for <lists+io-uring@lfdr.de>; Fri, 17 Jan 2025 16:12:03 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 715E519F438;
	Fri, 17 Jan 2025 16:11:28 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="CJLcDhhQ"
X-Original-To: io-uring@vger.kernel.org
Received: from mail-ej1-f49.google.com (mail-ej1-f49.google.com [209.85.218.49])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8E43519F128;
	Fri, 17 Jan 2025 16:11:26 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.218.49
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1737130288; cv=none; b=DiWIkmf/pno+Gr/o0pseZH/a5dAwxEekEfUD+doh8D9dHZjJB6tPe9DswGn5MJ0tU0d8LYWBepFfLm2AuBTb4Qk+0UnlTBNhJLfIrBqfMD2+G6HoxxzTQsDzr23puOHo3Cih0Hs6Wa9c2zQwNtbwatXQD70mIr0S/yZIpEf3LHA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1737130288; c=relaxed/simple;
	bh=p7K/xdJLgGwHUuPTNQQLhCdfTcMkRBmh6lhbm8pt8hs=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=uKzP8gznt9ZQXA4cVeZDEShvDyP1ihD+UkaRp3VhZmUWRZ8FG1hP/NB7QLd7uRqWbgqlOZPq9w4WFiA/P2cOmyPWfP4ZXuKwXoH27yf5L1LtjoP7KBbnQjdY5ua4P/QAUEodiejrW6kGEtp5YjWEhcbUJq1HhvuFitWp5cfjp3k=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=CJLcDhhQ; arc=none smtp.client-ip=209.85.218.49
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Received: by mail-ej1-f49.google.com with SMTP id a640c23a62f3a-ab39f84cbf1so37248866b.3;
        Fri, 17 Jan 2025 08:11:26 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1737130285; x=1737735085; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=WzVMUBn7a26Q24qLiDr8VqZp5nQZKrJFA5mDpOlyJHE=;
        b=CJLcDhhQqehYpH6v92DQ739Ck6Of+GonMVINHx8fKiKspD1UX6l1g+4Fe44LmCMANm
         h6QhYlGOYExC17KC8ax9tbBFjex5ZhYX3ihl2zN44jlM5ywYbzlL5D+q2wrFTCGCIWT5
         1PdndcgZru3F29FjXMgZ05uzbZ4x2ra20PLGACPaTiW0QCqMzr73FBwZspysB3X70dCt
         zw0Jiza7LKJKK7loaws9X9XSuoMMOZADtafJigyl8vbZewJmuXpxWp+fcRJnnxas/sVa
         RHQBtGdQB2i+GpSNLdBZ/6hFhUZU7rRxM7V5EZBeVS/F3XNmnI8EOHDTsXFqTXweh7lc
         3s8A==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1737130285; x=1737735085;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=WzVMUBn7a26Q24qLiDr8VqZp5nQZKrJFA5mDpOlyJHE=;
        b=PI8BchzEx67Vrwnp9LOSholteoB6gbErA0U3z1PVL/ajqYf6OokIh6a8n67tA0sJQw
         03F/DB1BPzkoNvMO8vvBs3AtVqhuETZBQdq5/QBKzfmaoPg8gWLeJ9hu88FBDi2q1qkq
         id2qTGJ+17HQJJQMjKO2Fubd2GwzoAlAj7HkhUkCs+IBHMWCMwMe9X/qm0qxLqthyrCE
         l0NtHScGbH5vcQhrqRLeR+IJDi0HspHH5ku4Rj9LUUI58Wj4O4Yu7iHqtZu4mYczOpmT
         YLhs3No7q3WK1KGQAEfd4fMudJ2ieKyDbM6xTf+Ouyb+LQv5OGgMhk0Xf0grCSaPgOok
         maNg==
X-Forwarded-Encrypted: i=1; AJvYcCW3W44ZxMfmS17lHcPMQVjRt0WRZZrDT24Rof+uoRgs97F6T0vT13E8WHcPWNJY+GkHgEjaCd4=@vger.kernel.org
X-Gm-Message-State: AOJu0Yze5jHH1tijo7s28z7u4DSyqxMl9XL14eXc1naJ9yrSx7+wg/fe
	Qt16pd6edxf/9oOdxHDuLlSLEOGxaR46NJxKYlUXsLM7/DOsKluWiB82HQ==
X-Gm-Gg: ASbGnctGKOh61kVIohg0HNxk+RWdN/4bq37OPLGaBVQQFYG7cUakqXmVdAR+k50H5yM
	EGd76N5BldElNrD0+HiMRbfrtRSywR38BWvjvCQwj9oh8DowRlINZPLfZgFzzUhZpTSiRSsqrzs
	nqetniwfxNPwCi23Y1fVFAhtboC/8ZsViMnN6TlW33UZL4EVeiacibHZcGvQL6FDW9x4pLgq8xW
	hD3hKPiY0QbdyotAkjYyEgL4JexbGBthEWwf1gX
X-Google-Smtp-Source: AGHT+IH9+qbulkER8NHWk8rXthdHqvzyCEzohkqKSf7pN01ZQo5ySq/Mo5p8QpNaGvTeQzSU7fJ86Q==
X-Received: by 2002:a17:907:86a9:b0:aa6:88f5:5fef with SMTP id a640c23a62f3a-ab38b1bb297mr270786166b.32.1737130283000;
        Fri, 17 Jan 2025 08:11:23 -0800 (PST)
Received: from 127.com ([2620:10d:c092:600::1:56de])
        by smtp.gmail.com with ESMTPSA id a640c23a62f3a-ab384f23007sm193716366b.96.2025.01.17.08.11.22
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 17 Jan 2025 08:11:22 -0800 (PST)
From: Pavel Begunkov <asml.silence@gmail.com>
To: io-uring@vger.kernel.org,
	netdev@vger.kernel.org
Cc: asml.silence@gmail.com,
	Jens Axboe <axboe@kernel.dk>,
	Jakub Kicinski <kuba@kernel.org>,
	Paolo Abeni <pabeni@redhat.com>,
	"David S . Miller" <davem@davemloft.net>,
	Eric Dumazet <edumazet@google.com>,
	Jesper Dangaard Brouer <hawk@kernel.org>,
	David Ahern <dsahern@kernel.org>,
	Mina Almasry <almasrymina@google.com>,
	Stanislav Fomichev <stfomichev@gmail.com>,
	Joe Damato <jdamato@fastly.com>,
	Pedro Tammela <pctammela@mojatatu.com>,
	David Wei <dw@davidwei.uk>
Subject: [PATCH net-next v12 06/10] net: page_pool: add callback for mp info printing
Date: Fri, 17 Jan 2025 16:11:44 +0000
Message-ID: <ad3352a697d4cf89d6fdfe4a17f045bc1ff00b41.1737129699.git.asml.silence@gmail.com>
X-Mailer: git-send-email 2.47.1
In-Reply-To: <cover.1737129699.git.asml.silence@gmail.com>
References: <cover.1737129699.git.asml.silence@gmail.com>
Precedence: bulk
X-Mailing-List: io-uring@vger.kernel.org
List-Id: <io-uring.vger.kernel.org>
List-Subscribe: <mailto:io-uring+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:io-uring+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

Add a mandatory callback that prints information about the memory
provider to netlink.

Reviewed-by: Jakub Kicinski <kuba@kernel.org>
Signed-off-by: Pavel Begunkov <asml.silence@gmail.com>
---
 include/net/page_pool/memory_provider.h |  5 +++++
 net/core/devmem.c                       | 10 ++++++++++
 net/core/netdev-genl.c                  | 11 ++++++-----
 net/core/page_pool_user.c               |  5 ++---
 4 files changed, 23 insertions(+), 8 deletions(-)

diff --git a/include/net/page_pool/memory_provider.h b/include/net/page_pool/memory_provider.h
index e49d0a52629d..6d10a0959d00 100644
--- a/include/net/page_pool/memory_provider.h
+++ b/include/net/page_pool/memory_provider.h
@@ -5,11 +5,16 @@
 #include <net/netmem.h>
 #include <net/page_pool/types.h>
 
+struct netdev_rx_queue;
+struct sk_buff;
+
 struct memory_provider_ops {
 	netmem_ref (*alloc_netmems)(struct page_pool *pool, gfp_t gfp);
 	bool (*release_netmem)(struct page_pool *pool, netmem_ref netmem);
 	int (*init)(struct page_pool *pool);
 	void (*destroy)(struct page_pool *pool);
+	int (*nl_fill)(void *mp_priv, struct sk_buff *rsp,
+		       struct netdev_rx_queue *rxq);
 };
 
 #endif
diff --git a/net/core/devmem.c b/net/core/devmem.c
index 1a88ab6faf06..b33b978fa28f 100644
--- a/net/core/devmem.c
+++ b/net/core/devmem.c
@@ -406,9 +406,19 @@ bool mp_dmabuf_devmem_release_page(struct page_pool *pool, netmem_ref netmem)
 	return false;
 }
 
+static int mp_dmabuf_devmem_nl_fill(void *mp_priv, struct sk_buff *rsp,
+				    struct netdev_rx_queue *rxq)
+{
+	const struct net_devmem_dmabuf_binding *binding = mp_priv;
+	int type = rxq ? NETDEV_A_QUEUE_DMABUF : NETDEV_A_PAGE_POOL_DMABUF;
+
+	return nla_put_u32(rsp, type, binding->id);
+}
+
 static const struct memory_provider_ops dmabuf_devmem_ops = {
 	.init			= mp_dmabuf_devmem_init,
 	.destroy		= mp_dmabuf_devmem_destroy,
 	.alloc_netmems		= mp_dmabuf_devmem_alloc_netmems,
 	.release_netmem		= mp_dmabuf_devmem_release_page,
+	.nl_fill		= mp_dmabuf_devmem_nl_fill,
 };
diff --git a/net/core/netdev-genl.c b/net/core/netdev-genl.c
index 715f85c6b62e..5b459b4fef46 100644
--- a/net/core/netdev-genl.c
+++ b/net/core/netdev-genl.c
@@ -10,6 +10,7 @@
 #include <net/sock.h>
 #include <net/xdp.h>
 #include <net/xdp_sock.h>
+#include <net/page_pool/memory_provider.h>
 
 #include "dev.h"
 #include "devmem.h"
@@ -368,7 +369,7 @@ static int
 netdev_nl_queue_fill_one(struct sk_buff *rsp, struct net_device *netdev,
 			 u32 q_idx, u32 q_type, const struct genl_info *info)
 {
-	struct net_devmem_dmabuf_binding *binding;
+	struct pp_memory_provider_params *params;
 	struct netdev_rx_queue *rxq;
 	struct netdev_queue *txq;
 	void *hdr;
@@ -385,15 +386,15 @@ netdev_nl_queue_fill_one(struct sk_buff *rsp, struct net_device *netdev,
 	switch (q_type) {
 	case NETDEV_QUEUE_TYPE_RX:
 		rxq = __netif_get_rx_queue(netdev, q_idx);
+
 		if (rxq->napi && nla_put_u32(rsp, NETDEV_A_QUEUE_NAPI_ID,
 					     rxq->napi->napi_id))
 			goto nla_put_failure;
 
-		binding = rxq->mp_params.mp_priv;
-		if (binding &&
-		    nla_put_u32(rsp, NETDEV_A_QUEUE_DMABUF, binding->id))
+		params = &rxq->mp_params;
+		if (params->mp_ops &&
+		    params->mp_ops->nl_fill(params->mp_priv, rsp, rxq))
 			goto nla_put_failure;
-
 		break;
 	case NETDEV_QUEUE_TYPE_TX:
 		txq = netdev_get_tx_queue(netdev, q_idx);
diff --git a/net/core/page_pool_user.c b/net/core/page_pool_user.c
index 8d31c71bea1a..bd017537fa80 100644
--- a/net/core/page_pool_user.c
+++ b/net/core/page_pool_user.c
@@ -7,9 +7,9 @@
 #include <net/netdev_rx_queue.h>
 #include <net/page_pool/helpers.h>
 #include <net/page_pool/types.h>
+#include <net/page_pool/memory_provider.h>
 #include <net/sock.h>
 
-#include "devmem.h"
 #include "page_pool_priv.h"
 #include "netdev-genl-gen.h"
 
@@ -214,7 +214,6 @@ static int
 page_pool_nl_fill(struct sk_buff *rsp, const struct page_pool *pool,
 		  const struct genl_info *info)
 {
-	struct net_devmem_dmabuf_binding *binding = pool->mp_priv;
 	size_t inflight, refsz;
 	void *hdr;
 
@@ -244,7 +243,7 @@ page_pool_nl_fill(struct sk_buff *rsp, const struct page_pool *pool,
 			 pool->user.detach_time))
 		goto err_cancel;
 
-	if (binding && nla_put_u32(rsp, NETDEV_A_PAGE_POOL_DMABUF, binding->id))
+	if (pool->mp_ops && pool->mp_ops->nl_fill(pool->mp_priv, rsp, NULL))
 		goto err_cancel;
 
 	genlmsg_end(rsp, hdr);
-- 
2.47.1


