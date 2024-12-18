Return-Path: <io-uring+bounces-5542-lists+io-uring=lfdr.de@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [IPv6:2604:1380:4601:e00::3])
	by mail.lfdr.de (Postfix) with ESMTPS id 0E2C09F5BB8
	for <lists+io-uring@lfdr.de>; Wed, 18 Dec 2024 01:39:29 +0100 (CET)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id 71ACD1882FF9
	for <lists+io-uring@lfdr.de>; Wed, 18 Dec 2024 00:38:39 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id E89B83597E;
	Wed, 18 Dec 2024 00:38:01 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=davidwei-uk.20230601.gappssmtp.com header.i=@davidwei-uk.20230601.gappssmtp.com header.b="bxVd30/T"
X-Original-To: io-uring@vger.kernel.org
Received: from mail-pf1-f175.google.com (mail-pf1-f175.google.com [209.85.210.175])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6321A3596A
	for <io-uring@vger.kernel.org>; Wed, 18 Dec 2024 00:38:00 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.210.175
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1734482281; cv=none; b=Gcns/bV+BoaWYt52sEy8+QGM9Me1pLzLkAIY2GGeHqyElDTXQOKBMqrtbyiPEydL0yVGMolOohsfLuuVkgFbYJo/iFBFnbOhfJqL9rM+EGLIAGuBWfjqus9rw6aCLRn6qFn0m09VFyUiEhkfMyVXEEGI1fOgy2GXN4qlWoVWQLo=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1734482281; c=relaxed/simple;
	bh=EBvFIsawVGxLxMU3p1j1YX1UqSiCQdW1wkhcOZFyBMQ=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=m6j4m3sje4iQOXAueqqKQDZJvpww06ydzoh8MS1Oz7Y7pRvUEzi2d056C95VkUwyoiele8Fnq+EzYgkcVAvtOJuRbcDHNYC/C4KRTDRklSrESUVnGXpsr0GNlawSz46KTBW0i8aC2LUh2Y+Qbe5AW+ovOcIGbVUQTXyOWoCY178=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=davidwei.uk; spf=none smtp.mailfrom=davidwei.uk; dkim=pass (2048-bit key) header.d=davidwei-uk.20230601.gappssmtp.com header.i=@davidwei-uk.20230601.gappssmtp.com header.b=bxVd30/T; arc=none smtp.client-ip=209.85.210.175
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=davidwei.uk
Authentication-Results: smtp.subspace.kernel.org; spf=none smtp.mailfrom=davidwei.uk
Received: by mail-pf1-f175.google.com with SMTP id d2e1a72fcca58-725dac69699so5189596b3a.0
        for <io-uring@vger.kernel.org>; Tue, 17 Dec 2024 16:38:00 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=davidwei-uk.20230601.gappssmtp.com; s=20230601; t=1734482280; x=1735087080; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=7+YHcXEAtBvssxU5fzHig35lu0TSHQacf/OaCK3OLTg=;
        b=bxVd30/TDcvR+Esh7VtUU7P1YMAG2Cqx/q8o6i0lnUUJc6YjRdYjvLl9FnFnH78/t6
         HB5h6FD7lHKbBpHoEd+a/xa6W9Q2Lg9exbo/T0CVoCNHgyOxP8XLbePi8MlH6eEqFGFj
         +ncR4mBvxRZD6gvXjmp0EZMqGdlA6l4UpxonD4lireq/6x72udBrw6EXK39XzNY47zqP
         M62dTaplEjPPDpX/Z5rBkB5IzT1gB08IQ9mZdJ0blsMXx484whunMktywSBS43H5t4y1
         YfXzTVCeXDQieggMhUsW3GFAbDXuAlXBJtY8GqLte51F9QvaokZVFA4rQDgQHw8dj8VH
         EjCA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1734482280; x=1735087080;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=7+YHcXEAtBvssxU5fzHig35lu0TSHQacf/OaCK3OLTg=;
        b=RHIAIQZ6CWawXoXWaYHechKORJuJ0C4VUHQ9O4jwqDMvn59qyOW8R/zmiMpcM5IUdY
         NT7tndWH5x54Q9VlEWqDTeE8UJz9HfrDzOuyQeQfKkzCnCj/5EFErocijK177mOYMvH+
         F85/GXHJt4t90INtd+vgc7ainE1APm0KiHKUfbDHyKzkpzn64erTP1vwwlD+91qmwFMb
         X8Z8M6z4dc5wCP91P0mR5tMK5aW7Fw94Qrkgvs8Sfp5a6Bav/6tqNBhaicTpV3YGsqF0
         PLe0FoEeSPFy2JjXFe/Ta80MBHcfwUJwOUUqU6VrIT4Z69Ff7uZBzKIx8206R8dmtUd+
         4fGQ==
X-Gm-Message-State: AOJu0YyGU+66kjhRMk5psREzrOkh6SdD7ye0UG+nNHCEeWXV+7AYDpUo
	5aIaOmr5kKWaJ+aBmDK2wvkBmFVrXDorXMm9xVO/Q+gvqRkffUdehLU9/f73fgHu1Cs3vB5Tn/F
	i
X-Gm-Gg: ASbGncucAJuS7TU64MtMLOM8a3OhmpF/QErmeQxNF56dEQnRqGnI/MkF16udzOUlgH5
	M0AWLBhjt0DVFVp+33bRsl3x3aieSzcNE8I1oXRSwdgRdlxKLHt/4u2J7AI1wDRsLIC799sYi52
	W5IRSfcDglFc9jB5ddpkqkagE5MRyGOXcx4fztpQmVYaUIo8zXv82tmyixXR9wmoHXQCwSATMXL
	4QODYRJ6E5D4BD1VSPksFzn1jBE6qpozEuFSw43
X-Google-Smtp-Source: AGHT+IHNaclYzql/KiG+f8dQp/Qdpzpc2xkSKZ9c3EdFR/saiYZ/O/25OFfs9MN3+2HMMxYSmkpHVA==
X-Received: by 2002:a05:6a00:3693:b0:725:9f02:489f with SMTP id d2e1a72fcca58-72a8d2dfd73mr1599294b3a.26.1734482279804;
        Tue, 17 Dec 2024 16:37:59 -0800 (PST)
Received: from localhost ([2a03:2880:ff:5::])
        by smtp.gmail.com with ESMTPSA id 41be03b00d2f7-801d5a90693sm6473914a12.9.2024.12.17.16.37.59
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 17 Dec 2024 16:37:59 -0800 (PST)
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
Subject: [PATCH net-next v9 04/20] net: page_pool: create hooks for custom page providers
Date: Tue, 17 Dec 2024 16:37:30 -0800
Message-ID: <20241218003748.796939-5-dw@davidwei.uk>
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

From: Jakub Kicinski <kuba@kernel.org>

The page providers which try to reuse the same pages will
need to hold onto the ref, even if page gets released from
the pool - as in releasing the page from the pp just transfers
the "ownership" reference from pp to the provider, and provider
will wait for other references to be gone before feeding this
page back into the pool.

Signed-off-by: Jakub Kicinski <kuba@kernel.org>
Signed-off-by: Pavel Begunkov <asml.silence@gmail.com>
Signed-off-by: David Wei <dw@davidwei.uk>
---
 include/net/page_pool/types.h |  9 +++++++++
 net/core/devmem.c             | 14 +++++++++++++-
 net/core/page_pool.c          | 22 ++++++++++++++--------
 3 files changed, 36 insertions(+), 9 deletions(-)

diff --git a/include/net/page_pool/types.h b/include/net/page_pool/types.h
index ed4cd114180a..d6241e8a5106 100644
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
@@ -216,6 +224,7 @@ struct page_pool {
 	struct ptr_ring ring;
 
 	void *mp_priv;
+	const struct memory_provider_ops *mp_ops;
 
 #ifdef CONFIG_PAGE_POOL_STATS
 	/* recycle stats are per-cpu to avoid locking */
diff --git a/net/core/devmem.c b/net/core/devmem.c
index c250db6993d3..48903b7ab215 100644
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
index e07ad7315955..784a547b2ca4 100644
--- a/net/core/page_pool.c
+++ b/net/core/page_pool.c
@@ -285,13 +285,19 @@ static int page_pool_init(struct page_pool *pool,
 		rxq = __netif_get_rx_queue(pool->slow.netdev,
 					   pool->slow.queue_idx);
 		pool->mp_priv = rxq->mp_params.mp_priv;
+		pool->mp_ops = rxq->mp_params.mp_ops;
 	}
 
-	if (pool->mp_priv) {
+	if (pool->mp_ops) {
 		if (!pool->dma_map || !pool->dma_sync)
 			return -EOPNOTSUPP;
 
-		err = mp_dmabuf_devmem_init(pool);
+		if (WARN_ON(!is_kernel_rodata((unsigned long)pool->mp_ops))) {
+			err = -EFAULT;
+			goto free_ptr_ring;
+		}
+
+		err = pool->mp_ops->init(pool);
 		if (err) {
 			pr_warn("%s() mem-provider init failed %d\n", __func__,
 				err);
@@ -588,8 +594,8 @@ netmem_ref page_pool_alloc_netmems(struct page_pool *pool, gfp_t gfp)
 		return netmem;
 
 	/* Slow-path: cache empty, do real allocation */
-	if (static_branch_unlikely(&page_pool_mem_providers) && pool->mp_priv)
-		netmem = mp_dmabuf_devmem_alloc_netmems(pool, gfp);
+	if (static_branch_unlikely(&page_pool_mem_providers) && pool->mp_ops)
+		netmem = pool->mp_ops->alloc_netmems(pool, gfp);
 	else
 		netmem = __page_pool_alloc_pages_slow(pool, gfp);
 	return netmem;
@@ -680,8 +686,8 @@ void page_pool_return_page(struct page_pool *pool, netmem_ref netmem)
 	bool put;
 
 	put = true;
-	if (static_branch_unlikely(&page_pool_mem_providers) && pool->mp_priv)
-		put = mp_dmabuf_devmem_release_page(pool, netmem);
+	if (static_branch_unlikely(&page_pool_mem_providers) && pool->mp_ops)
+		put = pool->mp_ops->release_netmem(pool, netmem);
 	else
 		__page_pool_release_page_dma(pool, netmem);
 
@@ -1049,8 +1055,8 @@ static void __page_pool_destroy(struct page_pool *pool)
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


