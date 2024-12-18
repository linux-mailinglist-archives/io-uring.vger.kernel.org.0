Return-Path: <io-uring+bounces-5544-lists+io-uring=lfdr.de@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [147.75.199.223])
	by mail.lfdr.de (Postfix) with ESMTPS id 3A7A09F5BB3
	for <lists+io-uring@lfdr.de>; Wed, 18 Dec 2024 01:38:58 +0100 (CET)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id 76375164EF0
	for <lists+io-uring@lfdr.de>; Wed, 18 Dec 2024 00:38:55 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id C533B49652;
	Wed, 18 Dec 2024 00:38:04 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=davidwei-uk.20230601.gappssmtp.com header.i=@davidwei-uk.20230601.gappssmtp.com header.b="IizXIM2T"
X-Original-To: io-uring@vger.kernel.org
Received: from mail-pj1-f45.google.com (mail-pj1-f45.google.com [209.85.216.45])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 49FF34436E
	for <io-uring@vger.kernel.org>; Wed, 18 Dec 2024 00:38:03 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.216.45
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1734482284; cv=none; b=NnzRmSx60TipbIzg2K26+lC641MMJ/27BzJP9+4WqjNSGfwvpDzQSkurZM9AJSYl8t2+zRnlh4SRcDcBX1XpH2B7htrtexba2WXRkw9qbfpN8Ik/jCc689U+gx7PmpZsKaa1s/7JQQdQV2aDc9sumX6lUpdC6S+Qsh5AQWCJFAA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1734482284; c=relaxed/simple;
	bh=rCxxW/itp5x+499AxEs1p7a9ucFkJqEo/t2FhOUVYr8=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=sJdDgGOO3V6Tonzgol8MhErE6SrSnNOaolVtSseAjgAQLITL1GILPVsjrPB/ZH/bAI/babin5vgdoCkR9ScG11zRr71xC/hlu9ePRHkjFq79X520f4EWAH29uoJn7iliqVDRx7S3mzK6xY/1x1d4n+oYG6M8R2E/KAdCWgQ/liQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=davidwei.uk; spf=none smtp.mailfrom=davidwei.uk; dkim=pass (2048-bit key) header.d=davidwei-uk.20230601.gappssmtp.com header.i=@davidwei-uk.20230601.gappssmtp.com header.b=IizXIM2T; arc=none smtp.client-ip=209.85.216.45
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=davidwei.uk
Authentication-Results: smtp.subspace.kernel.org; spf=none smtp.mailfrom=davidwei.uk
Received: by mail-pj1-f45.google.com with SMTP id 98e67ed59e1d1-2ef8c012913so4256744a91.3
        for <io-uring@vger.kernel.org>; Tue, 17 Dec 2024 16:38:03 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=davidwei-uk.20230601.gappssmtp.com; s=20230601; t=1734482282; x=1735087082; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=6AfGsKFHOkdqeOf3FsE461f86oQPOHTvgRIj0UuaaTA=;
        b=IizXIM2TxHQthfI2Nt5WB82fKY3ajugmqa6MrH9htFN/5JhnAwuQzH+1bAbWmN7W/k
         8etCF+ZWOw6K7Re6OCMo/YYlgPnQWYL98wk+z1ZGhhQxSzULOeBc0vme6kjK1CRaioWE
         gvN8m39njxL4VipouV3I5N8JwVCLtcw7MmbWNiTmsFRIY4G2xzHme9huMUYCYuPxtOyA
         9S3DD5bhIXE2LW0A9HQD33uD6PS38BpU37vRZesw7ZtpBOYnuUa1B8QiZ7fCU7+pM8Nh
         gbkPlFz/LWId6DN1TGr2eq0n6nEKEo/x8rAcLxTAk4Rb2SuUeirJf0lklhTcwxldG8E7
         gQ8A==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1734482282; x=1735087082;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=6AfGsKFHOkdqeOf3FsE461f86oQPOHTvgRIj0UuaaTA=;
        b=RXqF5f9hbqB4fD3H8HfcBL760Qt+AdFtAJT4820nrBm7kTJL1/jzoxmiIh19lbf8V8
         5GgiJ1Wu07iPr/lO2vYOzxKMt8u3T/DSXk643jhsrtv75d8ar8jfVEPgutt5dOILb+SB
         Korf3bc5QEN0UnyottPxdfTZzNe/7mttvXdLnEKY1QeVDgaoqXqSU6jakhOKvaBziGjT
         8eeUXV4MB0BlH9j4geMhbVVfzhlj5+f1ZCqKz3tw+aZM2Jr57ebRgorLzi76Oj2/h+P1
         RAJ0TFmfhk08WliVcD2pkUIOppkNQ0DimkYWDvBmgyoB4spviUjC1OMKuNkK92bONOiZ
         m4fg==
X-Gm-Message-State: AOJu0Yy3yhLhOMD3VeA0txBiLlZsuCghJbDELxvqcfKFKzCNaVICNbMm
	klvCPkyZXYN1MXpp5nibwoR3SFx6prLC5K/WLWVUX9CiLm8egXe7h5dI/WznD1SV2oAEMi5Jpqr
	j
X-Gm-Gg: ASbGncsCAH29VK0lHOxBoS/lswLC1KrlmxMUb4wFihXb09VUhuN/5bjXIrOTatlAxzA
	wF0wEbz8wnUXbunOthFIDhZPA7scbuHDAq6lbTHEhKJ3j/jgy41rktK6zf7frAnoisyQuiIWQIS
	9hOU1Iv69iyxpz4x2B1sfUeq+KZVxfD6kcd1Pu7/15f0kTxEw4nBpopcYeMlR7dvpYIk8a+qH4K
	wTcrVTP0qXoL/CbNBAnGqIyN39jNnZgquQbhEe9
X-Google-Smtp-Source: AGHT+IGR5LtCiHdpBMT9BbBFtuBIuICGu+bP7i6GvYwDVpp1zApjpbwEqvUEmYFj/DD4IWaUS2GokQ==
X-Received: by 2002:a17:90b:2b87:b0:2ee:45fe:63b5 with SMTP id 98e67ed59e1d1-2f2e91c4fcbmr1321471a91.3.1734482282595;
        Tue, 17 Dec 2024 16:38:02 -0800 (PST)
Received: from localhost ([2a03:2880:ff:c::])
        by smtp.gmail.com with ESMTPSA id 98e67ed59e1d1-2f2ed52cdc3sm111852a91.3.2024.12.17.16.38.01
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 17 Dec 2024 16:38:02 -0800 (PST)
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
Subject: [PATCH net-next v9 06/20] net: page_pool: add a mp hook to unregister_netdevice*
Date: Tue, 17 Dec 2024 16:37:32 -0800
Message-ID: <20241218003748.796939-7-dw@davidwei.uk>
X-Mailer: git-send-email 2.43.5
In-Reply-To: <20241218003748.796939-1-dw@davidwei.uk>
References: <20241218003748.796939-1-dw@davidwei.uk>
Precedence: bulk
X-Mailing-List: io-uring@vger.kernel.org
List-Id: <io-uring.vger.kernel.org>
List-Subscribe: <mailto:io-uring+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:io-uring+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

From: Pavel Begunkov <asml.silence@gmail.com>

Devmem TCP needs a hook in unregister_netdevice_many_notify() to upkeep
the set tracking queues it's bound to, i.e. ->bound_rxqs. Instead of
devmem sticking directly out of the genetic path, add a mp function.

Signed-off-by: Pavel Begunkov <asml.silence@gmail.com>
Signed-off-by: David Wei <dw@davidwei.uk>
---
 include/net/page_pool/types.h |  3 +++
 net/core/dev.c                | 15 ++++++++++++++-
 net/core/devmem.c             | 36 ++++++++++++++++-------------------
 net/core/devmem.h             |  5 -----
 4 files changed, 33 insertions(+), 26 deletions(-)

diff --git a/include/net/page_pool/types.h b/include/net/page_pool/types.h
index a473ea0c48c4..140fec6857c6 100644
--- a/include/net/page_pool/types.h
+++ b/include/net/page_pool/types.h
@@ -152,12 +152,15 @@ struct page_pool_stats {
  */
 #define PAGE_POOL_FRAG_GROUP_ALIGN	(4 * sizeof(long))
 
+struct netdev_rx_queue;
+
 struct memory_provider_ops {
 	netmem_ref (*alloc_netmems)(struct page_pool *pool, gfp_t gfp);
 	bool (*release_netmem)(struct page_pool *pool, netmem_ref netmem);
 	int (*init)(struct page_pool *pool);
 	void (*destroy)(struct page_pool *pool);
 	int (*nl_report)(const struct page_pool *pool, struct sk_buff *rsp);
+	void (*uninstall)(void *mp_priv, struct netdev_rx_queue *rxq);
 };
 
 struct pp_memory_provider_params {
diff --git a/net/core/dev.c b/net/core/dev.c
index c7f3dea3e0eb..aa082770ab1c 100644
--- a/net/core/dev.c
+++ b/net/core/dev.c
@@ -11464,6 +11464,19 @@ void unregister_netdevice_queue(struct net_device *dev, struct list_head *head)
 }
 EXPORT_SYMBOL(unregister_netdevice_queue);
 
+static void dev_memory_provider_uninstall(struct net_device *dev)
+{
+	unsigned int i;
+
+	for (i = 0; i < dev->real_num_rx_queues; i++) {
+		struct netdev_rx_queue *rxq = &dev->_rx[i];
+		struct pp_memory_provider_params *p = &rxq->mp_params;
+
+		if (p->mp_ops && p->mp_ops->uninstall)
+			p->mp_ops->uninstall(rxq->mp_params.mp_priv, rxq);
+	}
+}
+
 void unregister_netdevice_many_notify(struct list_head *head,
 				      u32 portid, const struct nlmsghdr *nlh)
 {
@@ -11516,7 +11529,7 @@ void unregister_netdevice_many_notify(struct list_head *head,
 		dev_tcx_uninstall(dev);
 		dev_xdp_uninstall(dev);
 		bpf_dev_bound_netdev_unregister(dev);
-		dev_dmabuf_uninstall(dev);
+		dev_memory_provider_uninstall(dev);
 
 		netdev_offload_xstats_disable_all(dev);
 
diff --git a/net/core/devmem.c b/net/core/devmem.c
index df51a6c312db..4ef67b63ea74 100644
--- a/net/core/devmem.c
+++ b/net/core/devmem.c
@@ -308,26 +308,6 @@ net_devmem_bind_dmabuf(struct net_device *dev, unsigned int dmabuf_fd,
 	return ERR_PTR(err);
 }
 
-void dev_dmabuf_uninstall(struct net_device *dev)
-{
-	struct net_devmem_dmabuf_binding *binding;
-	struct netdev_rx_queue *rxq;
-	unsigned long xa_idx;
-	unsigned int i;
-
-	for (i = 0; i < dev->real_num_rx_queues; i++) {
-		binding = dev->_rx[i].mp_params.mp_priv;
-		if (!binding)
-			continue;
-
-		xa_for_each(&binding->bound_rxqs, xa_idx, rxq)
-			if (rxq == &dev->_rx[i]) {
-				xa_erase(&binding->bound_rxqs, xa_idx);
-				break;
-			}
-	}
-}
-
 /*** "Dmabuf devmem memory provider" ***/
 
 int mp_dmabuf_devmem_init(struct page_pool *pool)
@@ -402,10 +382,26 @@ static int mp_dmabuf_devmem_nl_report(const struct page_pool *pool,
 	return nla_put_u32(rsp, NETDEV_A_PAGE_POOL_DMABUF, binding->id);
 }
 
+static void mp_dmabuf_devmem_uninstall(void *mp_priv,
+				       struct netdev_rx_queue *rxq)
+{
+	struct net_devmem_dmabuf_binding *binding = mp_priv;
+	struct netdev_rx_queue *bound_rxq;
+	unsigned long xa_idx;
+
+	xa_for_each(&binding->bound_rxqs, xa_idx, bound_rxq) {
+		if (bound_rxq == rxq) {
+			xa_erase(&binding->bound_rxqs, xa_idx);
+			break;
+		}
+	}
+}
+
 static const struct memory_provider_ops dmabuf_devmem_ops = {
 	.init			= mp_dmabuf_devmem_init,
 	.destroy		= mp_dmabuf_devmem_destroy,
 	.alloc_netmems		= mp_dmabuf_devmem_alloc_netmems,
 	.release_netmem		= mp_dmabuf_devmem_release_page,
 	.nl_report		= mp_dmabuf_devmem_nl_report,
+	.uninstall		= mp_dmabuf_devmem_uninstall,
 };
diff --git a/net/core/devmem.h b/net/core/devmem.h
index a2b9913e9a17..8e999fe2ae67 100644
--- a/net/core/devmem.h
+++ b/net/core/devmem.h
@@ -68,7 +68,6 @@ void net_devmem_unbind_dmabuf(struct net_devmem_dmabuf_binding *binding);
 int net_devmem_bind_dmabuf_to_queue(struct net_device *dev, u32 rxq_idx,
 				    struct net_devmem_dmabuf_binding *binding,
 				    struct netlink_ext_ack *extack);
-void dev_dmabuf_uninstall(struct net_device *dev);
 
 static inline struct dmabuf_genpool_chunk_owner *
 net_devmem_iov_to_chunk_owner(const struct net_iov *niov)
@@ -145,10 +144,6 @@ net_devmem_bind_dmabuf_to_queue(struct net_device *dev, u32 rxq_idx,
 	return -EOPNOTSUPP;
 }
 
-static inline void dev_dmabuf_uninstall(struct net_device *dev)
-{
-}
-
 static inline struct net_iov *
 net_devmem_alloc_dmabuf(struct net_devmem_dmabuf_binding *binding)
 {
-- 
2.43.5


