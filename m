Return-Path: <io-uring+bounces-5932-lists+io-uring=lfdr.de@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [IPv6:2604:1380:4601:e00::3])
	by mail.lfdr.de (Postfix) with ESMTPS id 64192A14540
	for <lists+io-uring@lfdr.de>; Fri, 17 Jan 2025 00:18:12 +0100 (CET)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id 975FF188B663
	for <lists+io-uring@lfdr.de>; Thu, 16 Jan 2025 23:18:15 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 2C80F2442F3;
	Thu, 16 Jan 2025 23:17:20 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=davidwei-uk.20230601.gappssmtp.com header.i=@davidwei-uk.20230601.gappssmtp.com header.b="pqc0tYwf"
X-Original-To: io-uring@vger.kernel.org
Received: from mail-pj1-f51.google.com (mail-pj1-f51.google.com [209.85.216.51])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 993962442C6
	for <io-uring@vger.kernel.org>; Thu, 16 Jan 2025 23:17:16 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.216.51
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1737069440; cv=none; b=LXGWZwAyY6xjDaViOWYTnBPXECUHsHzIaNoZAtz3m+1PVnzjUOG6M3lKsPMccwC6Vo33kP/6cojFV0qF9pXYr39xx2+NFdtQfsjRQbR6C4A5IuglCmKsYSI8I5IrVcm2AVAw58zvyH8KoMn2j/DCwz0hxO/ntgMS59j9lS/CJuc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1737069440; c=relaxed/simple;
	bh=nbNQmvcwm0FGW4HaDmOtxcNekDPwpF6gnNCFwbehIWE=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=qkGpXnXj87hEheyUPzzgP6nGR9G0GBrBAnUs/LBUeFewM5NP2rtUv9csKRQTdMR02QIsTECP8ugKoTOfgUYWjjnw1QRje/N+2SmdL9EsUddLUKLPhNpfV62vPkea/K83nGIY3i4aDciNT4ihW1XSWxZIJu31ECeOeUYFleIFcMM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=davidwei.uk; spf=none smtp.mailfrom=davidwei.uk; dkim=pass (2048-bit key) header.d=davidwei-uk.20230601.gappssmtp.com header.i=@davidwei-uk.20230601.gappssmtp.com header.b=pqc0tYwf; arc=none smtp.client-ip=209.85.216.51
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=davidwei.uk
Authentication-Results: smtp.subspace.kernel.org; spf=none smtp.mailfrom=davidwei.uk
Received: by mail-pj1-f51.google.com with SMTP id 98e67ed59e1d1-2ee989553c1so2621622a91.3
        for <io-uring@vger.kernel.org>; Thu, 16 Jan 2025 15:17:16 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=davidwei-uk.20230601.gappssmtp.com; s=20230601; t=1737069436; x=1737674236; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=UXQENGImtt4RlCkb7YV/TGKoODmx+IzagWKK6k97kDE=;
        b=pqc0tYwfvAHeckLJzMUk6NGRj+YMKnysgDwfm/OrguvI4XULYLxXVmDVFSge9h5R2l
         Dn01r8U5uQvSa5nRDaDDRqs9PDWGmGxHQ45oB1aEOziRo7ITMm7eNO9EVOpzQK6Ol0hY
         flAwflhbT97vYYmvmQykvwF5fsCUUHw6uEar7liHWihGI/iSvPBrnce/n2us1tB0b5KJ
         grKqBL+M7O0E6GmkXNGS6ks4AbdoY0NhwYW3M6A36BQ3wBlCwiYhTFkCSwOy4gDnw99q
         j/Yw/7oTVRpche2dx5M+1XimRG715XoeEvVquUy6Sho4ORNPDbATux1AMLNXa7Rd41LA
         5k/g==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1737069436; x=1737674236;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=UXQENGImtt4RlCkb7YV/TGKoODmx+IzagWKK6k97kDE=;
        b=iQt2GlGZPABZKaKpFe5UjSp+O4w4luhJaQFTgaIQQycup77xN943L384mLWlaLz6OH
         CbG6blgaL2vX4CWKSOLmqjJewgkgZUtGNG1NmH+q7+9hAhWMhQ7kWJ9bU5BpzOVYOMqe
         u+pRGyZyuLLgBjsKvBzJhGlVWqfyv4n5xtMju0ukplCdAeb06e/z7QTk+8nud/nxBD23
         gp4CJJTxe5OBpJ+nvxoX+/tnbrh1S6Jd6ytfaoWuNkKEbp2TcIov6FKIf7VSoX0ZVhKh
         UTC23xDG+9pZTKzlNRfgUGXVkNjqxrUnpvBkjssQcrDGzUqFqCpkoRaRk1wPEROykh0Y
         MgKw==
X-Gm-Message-State: AOJu0Yy8aLO/TtIcYbFni6+RE07dAP6v/x5X6ZjRE5VDBJ+ae08zTV8R
	PHVSv+aBRRkCs9KcJQ8/UfrT2iq3IvNNQm0mexg6OSFwyIDpfallw4En8i4uVat1qAdwE8mGs6a
	H
X-Gm-Gg: ASbGncthNNiQFglsRH8f73QAgXo85RqLEFczAIzb1WuY73TL3BnAPIuraY9gnIuJOg8
	rm+bP0v+iB8rEcWnY9C5D0Wiamvc+mmuBIUBiZc2PbD0bWw0tEnbAvpPrExvcwqd3moN7A3QwT+
	YPiDePJYtpBl5NjtRbY/8VkqnIK8hOLbUoiEGj+S1zKlwAOCYjMuYLvsPnnpaq5gOZ95q8TwE0d
	qvLQD4TkFna5azOV1CYpYQL17jFn6piFznlQKTifg==
X-Google-Smtp-Source: AGHT+IEGFKqSoSekoBRce5bWyn/VrKoW0zkaZl+nl3oqGv69mbBo3HWt5w0Hw0+7kT8xvVhr9Q9yBw==
X-Received: by 2002:a17:90b:2703:b0:2ee:d63f:d71 with SMTP id 98e67ed59e1d1-2f782c7252dmr667140a91.14.1737069436010;
        Thu, 16 Jan 2025 15:17:16 -0800 (PST)
Received: from localhost ([2a03:2880:ff:73::])
        by smtp.gmail.com with ESMTPSA id 98e67ed59e1d1-2f72c14ffaasm3859710a91.4.2025.01.16.15.17.15
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 16 Jan 2025 15:17:15 -0800 (PST)
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
Subject: [PATCH net-next v11 06/21] net: page_pool: add callback for mp info printing
Date: Thu, 16 Jan 2025 15:16:48 -0800
Message-ID: <20250116231704.2402455-7-dw@davidwei.uk>
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

Add a mandatory callback that prints information about the memory
provider to netlink.

Reviewed-by: Jakub Kicinski <kuba@kernel.org>
Signed-off-by: Pavel Begunkov <asml.silence@gmail.com>
Signed-off-by: David Wei <dw@davidwei.uk>
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
index 48833c1dcbd4..c0bde0869f72 100644
--- a/net/core/devmem.c
+++ b/net/core/devmem.c
@@ -395,9 +395,19 @@ bool mp_dmabuf_devmem_release_page(struct page_pool *pool, netmem_ref netmem)
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
index 2d3ae0cd3ad2..4bc05fb27890 100644
--- a/net/core/netdev-genl.c
+++ b/net/core/netdev-genl.c
@@ -10,6 +10,7 @@
 #include <net/sock.h>
 #include <net/xdp.h>
 #include <net/xdp_sock.h>
+#include <net/page_pool/memory_provider.h>
 
 #include "dev.h"
 #include "devmem.h"
@@ -368,7 +369,6 @@ static int
 netdev_nl_queue_fill_one(struct sk_buff *rsp, struct net_device *netdev,
 			 u32 q_idx, u32 q_type, const struct genl_info *info)
 {
-	struct net_devmem_dmabuf_binding *binding;
 	struct netdev_rx_queue *rxq;
 	struct netdev_queue *txq;
 	void *hdr;
@@ -385,15 +385,16 @@ netdev_nl_queue_fill_one(struct sk_buff *rsp, struct net_device *netdev,
 	switch (q_type) {
 	case NETDEV_QUEUE_TYPE_RX:
 		rxq = __netif_get_rx_queue(netdev, q_idx);
+		struct pp_memory_provider_params *params;
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
2.43.5


