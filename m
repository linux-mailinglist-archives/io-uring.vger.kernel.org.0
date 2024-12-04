Return-Path: <io-uring+bounces-5216-lists+io-uring=lfdr.de@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [139.178.88.99])
	by mail.lfdr.de (Postfix) with ESMTPS id 935439E428D
	for <lists+io-uring@lfdr.de>; Wed,  4 Dec 2024 18:57:05 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 4EA4928310E
	for <lists+io-uring@lfdr.de>; Wed,  4 Dec 2024 17:57:04 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 985AC2144B4;
	Wed,  4 Dec 2024 17:22:47 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=davidwei-uk.20230601.gappssmtp.com header.i=@davidwei-uk.20230601.gappssmtp.com header.b="kygfaWUB"
X-Original-To: io-uring@vger.kernel.org
Received: from mail-pf1-f173.google.com (mail-pf1-f173.google.com [209.85.210.173])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 137E62144A0
	for <io-uring@vger.kernel.org>; Wed,  4 Dec 2024 17:22:45 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.210.173
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1733332967; cv=none; b=b3qFRJSuXChZ6IkUHLLdVbZjtCyQ3zujYyCFWcAvEizkXVXuLg+FiHHT5uj9o1Mtn1+thtRDiq6PfcJGzzt8Iw7klmZzZIMeqAJImfl/aNosp3DGh4wGGmSQhyEWuPJdPyWWHaWPbPC/Ng7QoHqZh1KnznELkVXwHkB2gl55gec=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1733332967; c=relaxed/simple;
	bh=CWs2zlA0ej7HQHqSKA3Q8FsG7wJD5tSuONWopDWc4ew=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=PaBN3cVVuJ+XfSeD9PWHAcDI+hzoWpjHGSMJ/EMzt8Bz1M31J7aLzDmEWtVIWE6pbfR4lh7iBjYciU6d8VbqyKXY75mZh5Pr7qdmyJLmcus73hTmvsHoyTu0l1yZMeHZYyZYJzd2SaopYxVeNMK6uL9kLD42XTL4SLdqK5sU5uc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=davidwei.uk; spf=none smtp.mailfrom=davidwei.uk; dkim=pass (2048-bit key) header.d=davidwei-uk.20230601.gappssmtp.com header.i=@davidwei-uk.20230601.gappssmtp.com header.b=kygfaWUB; arc=none smtp.client-ip=209.85.210.173
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=davidwei.uk
Authentication-Results: smtp.subspace.kernel.org; spf=none smtp.mailfrom=davidwei.uk
Received: by mail-pf1-f173.google.com with SMTP id d2e1a72fcca58-7259d6ae0c8so39028b3a.0
        for <io-uring@vger.kernel.org>; Wed, 04 Dec 2024 09:22:45 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=davidwei-uk.20230601.gappssmtp.com; s=20230601; t=1733332965; x=1733937765; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=JH3riVm4NLkjQBfMuLeksWLMkrvRu8BR3SQaEJKT7Rw=;
        b=kygfaWUBSdVz5xqx8JTRoo/8pG1jbR1Y3TFFfRnEgExSYLjrgWi8CNyZ9hNDt4GV6S
         uzeVbhnO3N9hRoGEqYikKASMMHsWpUYhHstp2CrohbtAWq0SX9UphorbduWT32ZTqdFb
         LWFF+DpyYvLYwTaeDWrz863jSH5x1LgXYC+pis9jB+cE81dBj5TheZ+alYSpmT5QYWWg
         j+WZTnuf4v5VqqOz9e3hz5IfC4U7FhACTJVVY5JLT+6XEX0OhF90z37AxnUn5EBxkD+c
         aVNlfoy9qicyuWh1YFmly6+0EEbzgtHkPnD8oaVFw2ueUpOYv+BZUkSbxmPkFwIusSyG
         0eDQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1733332965; x=1733937765;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=JH3riVm4NLkjQBfMuLeksWLMkrvRu8BR3SQaEJKT7Rw=;
        b=f5tsGyQnigjIi7eyKzG7fjjeX01R8CXAfBoItDhEu0folLLVis8v5WbWhYgjgapcLO
         33z7ZDRnEyGfDQRmHZs+KswplI740hpK6Hk2YMKay5JAxBcgRr1/QiRmDS0l/fFoB+sw
         Tmi1ZrHEUk+zExuQ4mzqWGtT9ZVLJYAo7qwF0AIcrjD+CPG6wxKV8Uk714/paHLTLcKq
         ZDE9V0iTD/FFZXeIueaNP7SZdYSaazXZwRXAl3yW1ZGq5dYAXCmuEGV6Oopexl6PW97e
         NtGdS5+ur0z5PFRoUzGpeou6XyLdrkLnNT5x4pKdgFa5KyOssz9aIyjdn1tfAk7uhZCc
         UvcA==
X-Gm-Message-State: AOJu0YxgF9sj5dJ5hBWXnSDKHqug+wr6Uxsh6rk2OOR3Gu7Yf8AKZ+mf
	hcLBn0tAaw+UdrHt0yvNaLKzaBM673yv8ZiIs82Aw9Z5KOsjwz1YR4OVI6PnbjoDsalsu3Bar1g
	D
X-Gm-Gg: ASbGncsUo3OuCatwPOR1Z1OHjV8miyga3ibpI/LRNBPNZjMfedLZpim/8//qRms7xxN
	H/K7HLPHNkb0oARyX9aP/G3m6ZW+B0V33hyVe5xiWtgINtamBshR+nDgGG+BW1BEKRg944BhVMC
	juvLh4dYtphiP+/0CN+iJJjRhUSSerPl8JDNh7W0Bdjw2vcLbKyPbRygQQuS2pf2IgIwN6EI9EY
	s7Tyk4vAEGflA4Lf2aNIlqS2CJYcQ+sS+c=
X-Google-Smtp-Source: AGHT+IFLNESG52Hxk+Q3BHxEn2/pmAxxJclMcKSQNELp4I9dJY56e6lubxSsLfm7mcXVC2UoKfGrxw==
X-Received: by 2002:a17:902:d4c5:b0:211:fcad:d6ea with SMTP id d9443c01a7336-215bd244a30mr62174785ad.45.1733332965454;
        Wed, 04 Dec 2024 09:22:45 -0800 (PST)
Received: from localhost ([2a03:2880:ff:21::])
        by smtp.gmail.com with ESMTPSA id d9443c01a7336-2158394eb05sm63052455ad.82.2024.12.04.09.22.44
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 04 Dec 2024 09:22:44 -0800 (PST)
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
Subject: [PATCH net-next v8 03/17] net: page_pool: create hooks for custom page providers
Date: Wed,  4 Dec 2024 09:21:42 -0800
Message-ID: <20241204172204.4180482-4-dw@davidwei.uk>
X-Mailer: git-send-email 2.43.5
In-Reply-To: <20241204172204.4180482-1-dw@davidwei.uk>
References: <20241204172204.4180482-1-dw@davidwei.uk>
Precedence: bulk
X-Mailing-List: io-uring@vger.kernel.org
List-Id: <io-uring.vger.kernel.org>
List-Subscribe: <mailto:io-uring+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:io-uring+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

From: Jakub Kicinski <kuba@kernel.org>

The page providers which try to reuse the same pages will
need to hold onto the ref, even if page gets released from
the pool - as in releasing the page from the pp just transfers
the "ownership" reference from pp to the provider, and provider
will wait for other references to be gone before feeding this
page back into the pool.

Signed-off-by: Jakub Kicinski <kuba@kernel.org>
[Pavel] Rebased, renamed callback, +converted devmem
Signed-off-by: Pavel Begunkov <asml.silence@gmail.com>
Signed-off-by: David Wei <dw@davidwei.uk>
---
 include/net/page_pool/types.h |  9 +++++++++
 net/core/devmem.c             | 14 +++++++++++++-
 net/core/page_pool.c          | 17 +++++++++--------
 3 files changed, 31 insertions(+), 9 deletions(-)

diff --git a/include/net/page_pool/types.h b/include/net/page_pool/types.h
index c022c410abe3..8a35fe474adb 100644
--- a/include/net/page_pool/types.h
+++ b/include/net/page_pool/types.h
@@ -152,8 +152,16 @@ struct page_pool_stats {
  */
 #define PAGE_POOL_FRAG_GROUP_ALIGN	(4 * sizeof(long))
 
+struct memory_provider_ops {
+	netmem_ref (*alloc_netmems)(struct page_pool *pool, gfp_t gfp);
+	bool (*release_netmem)(struct page_pool *pool, netmem_ref netmem);
+	int (*init)(struct page_pool *pool);
+	void (*destroy)(struct page_pool *pool);
+};
+
 struct pp_memory_provider_params {
 	void *mp_priv;
+	const struct memory_provider_ops *mp_ops;
 };
 
 struct page_pool {
@@ -215,6 +223,7 @@ struct page_pool {
 	struct ptr_ring ring;
 
 	void *mp_priv;
+	const struct memory_provider_ops *mp_ops;
 
 #ifdef CONFIG_PAGE_POOL_STATS
 	/* recycle stats are per-cpu to avoid locking */
diff --git a/net/core/devmem.c b/net/core/devmem.c
index 5c10cf0e2a18..01738029e35c 100644
--- a/net/core/devmem.c
+++ b/net/core/devmem.c
@@ -26,6 +26,8 @@
 /* Protected by rtnl_lock() */
 static DEFINE_XARRAY_FLAGS(net_devmem_dmabuf_bindings, XA_FLAGS_ALLOC1);
 
+static const struct memory_provider_ops dmabuf_devmem_ops;
+
 static void net_devmem_dmabuf_free_chunk_owner(struct gen_pool *genpool,
 					       struct gen_pool_chunk *chunk,
 					       void *not_used)
@@ -117,6 +119,7 @@ void net_devmem_unbind_dmabuf(struct net_devmem_dmabuf_binding *binding)
 		WARN_ON(rxq->mp_params.mp_priv != binding);
 
 		rxq->mp_params.mp_priv = NULL;
+		rxq->mp_params.mp_ops = NULL;
 
 		rxq_idx = get_netdev_rx_queue_index(rxq);
 
@@ -142,7 +145,7 @@ int net_devmem_bind_dmabuf_to_queue(struct net_device *dev, u32 rxq_idx,
 	}
 
 	rxq = __netif_get_rx_queue(dev, rxq_idx);
-	if (rxq->mp_params.mp_priv) {
+	if (rxq->mp_params.mp_ops) {
 		NL_SET_ERR_MSG(extack, "designated queue already memory provider bound");
 		return -EEXIST;
 	}
@@ -160,6 +163,7 @@ int net_devmem_bind_dmabuf_to_queue(struct net_device *dev, u32 rxq_idx,
 		return err;
 
 	rxq->mp_params.mp_priv = binding;
+	rxq->mp_params.mp_ops = &dmabuf_devmem_ops;
 
 	err = netdev_rx_queue_restart(dev, rxq_idx);
 	if (err)
@@ -169,6 +173,7 @@ int net_devmem_bind_dmabuf_to_queue(struct net_device *dev, u32 rxq_idx,
 
 err_xa_erase:
 	rxq->mp_params.mp_priv = NULL;
+	rxq->mp_params.mp_ops = NULL;
 	xa_erase(&binding->bound_rxqs, xa_idx);
 
 	return err;
@@ -388,3 +393,10 @@ bool mp_dmabuf_devmem_release_page(struct page_pool *pool, netmem_ref netmem)
 	/* We don't want the page pool put_page()ing our net_iovs. */
 	return false;
 }
+
+static const struct memory_provider_ops dmabuf_devmem_ops = {
+	.init			= mp_dmabuf_devmem_init,
+	.destroy		= mp_dmabuf_devmem_destroy,
+	.alloc_netmems		= mp_dmabuf_devmem_alloc_netmems,
+	.release_netmem		= mp_dmabuf_devmem_release_page,
+};
diff --git a/net/core/page_pool.c b/net/core/page_pool.c
index f89cf93f6eb4..36f61a1e4ffe 100644
--- a/net/core/page_pool.c
+++ b/net/core/page_pool.c
@@ -284,10 +284,11 @@ static int page_pool_init(struct page_pool *pool,
 		rxq = __netif_get_rx_queue(pool->slow.netdev,
 					   pool->slow.queue_idx);
 		pool->mp_priv = rxq->mp_params.mp_priv;
+		pool->mp_ops = rxq->mp_params.mp_ops;
 	}
 
-	if (pool->mp_priv) {
-		err = mp_dmabuf_devmem_init(pool);
+	if (pool->mp_ops) {
+		err = pool->mp_ops->init(pool);
 		if (err) {
 			pr_warn("%s() mem-provider init failed %d\n", __func__,
 				err);
@@ -584,8 +585,8 @@ netmem_ref page_pool_alloc_netmem(struct page_pool *pool, gfp_t gfp)
 		return netmem;
 
 	/* Slow-path: cache empty, do real allocation */
-	if (static_branch_unlikely(&page_pool_mem_providers) && pool->mp_priv)
-		netmem = mp_dmabuf_devmem_alloc_netmems(pool, gfp);
+	if (static_branch_unlikely(&page_pool_mem_providers) && pool->mp_ops)
+		netmem = pool->mp_ops->alloc_netmems(pool, gfp);
 	else
 		netmem = __page_pool_alloc_pages_slow(pool, gfp);
 	return netmem;
@@ -676,8 +677,8 @@ void page_pool_return_page(struct page_pool *pool, netmem_ref netmem)
 	bool put;
 
 	put = true;
-	if (static_branch_unlikely(&page_pool_mem_providers) && pool->mp_priv)
-		put = mp_dmabuf_devmem_release_page(pool, netmem);
+	if (static_branch_unlikely(&page_pool_mem_providers) && pool->mp_ops)
+		put = pool->mp_ops->release_netmem(pool, netmem);
 	else
 		__page_pool_release_page_dma(pool, netmem);
 
@@ -1010,8 +1011,8 @@ static void __page_pool_destroy(struct page_pool *pool)
 	page_pool_unlist(pool);
 	page_pool_uninit(pool);
 
-	if (pool->mp_priv) {
-		mp_dmabuf_devmem_destroy(pool);
+	if (pool->mp_ops) {
+		pool->mp_ops->destroy(pool);
 		static_branch_dec(&page_pool_mem_providers);
 	}
 
-- 
2.43.5


