Return-Path: <io-uring+bounces-5536-lists+io-uring=lfdr.de@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from sy.mirrors.kernel.org (sy.mirrors.kernel.org [IPv6:2604:1380:40f1:3f00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 079B19F5BA7
	for <lists+io-uring@lfdr.de>; Wed, 18 Dec 2024 01:37:23 +0100 (CET)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sy.mirrors.kernel.org (Postfix) with ESMTPS id 3DA227A54BA
	for <lists+io-uring@lfdr.de>; Wed, 18 Dec 2024 00:37:16 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 93F393F9D5;
	Wed, 18 Dec 2024 00:36:06 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=davidwei-uk.20230601.gappssmtp.com header.i=@davidwei-uk.20230601.gappssmtp.com header.b="m5QOy1A2"
X-Original-To: io-uring@vger.kernel.org
Received: from mail-pl1-f179.google.com (mail-pl1-f179.google.com [209.85.214.179])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 469693596C
	for <io-uring@vger.kernel.org>; Wed, 18 Dec 2024 00:36:04 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.214.179
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1734482166; cv=none; b=CO8BcSs1AtDtOVcBgQdy9F2jEBnOGQvct6T81SbDVCqyaOfl8xIRTDhSDgkGeYJJjExPyoSYnhVv4jfcNv3qwUPIix3rme0ZP5HL3dtBMMM/W4/b5CzW8++MWU/uYodnoenOyRZYbX+h2UTYg+PxaRslqVLmMyG65F3PZh58fTo=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1734482166; c=relaxed/simple;
	bh=EBvFIsawVGxLxMU3p1j1YX1UqSiCQdW1wkhcOZFyBMQ=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=Hnd4ku2kxsldbk80Awi6dd51npLgdYH5b5XnYL7DltKbOuBKDLspGuF15hQtgvZ+s866PdVdgGct5NUz0MSrNfiLbhXx3WKI3ATJ0/TJ7nUycWQfFV2+WMTqQba3CezBOA5BNqeZm2hX5BTJV3sRVuPXvslKnl9Gpv2/zqAUo3w=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=davidwei.uk; spf=none smtp.mailfrom=davidwei.uk; dkim=pass (2048-bit key) header.d=davidwei-uk.20230601.gappssmtp.com header.i=@davidwei-uk.20230601.gappssmtp.com header.b=m5QOy1A2; arc=none smtp.client-ip=209.85.214.179
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=davidwei.uk
Authentication-Results: smtp.subspace.kernel.org; spf=none smtp.mailfrom=davidwei.uk
Received: by mail-pl1-f179.google.com with SMTP id d9443c01a7336-21675fd60feso61593495ad.2
        for <io-uring@vger.kernel.org>; Tue, 17 Dec 2024 16:36:04 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=davidwei-uk.20230601.gappssmtp.com; s=20230601; t=1734482163; x=1735086963; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=7+YHcXEAtBvssxU5fzHig35lu0TSHQacf/OaCK3OLTg=;
        b=m5QOy1A2r31UB7TyarF0k7oZ5syYtxSu176MseJEbO8HAQvmyPxZmktK6JebkkinAT
         OfnN59ugxTjsqbX5MKVK4QxtQQiIM/eYE/7xK6E0ixOrmnsbPXCbh2C0jKLfRkKZlkQ7
         2xPXT8aXW1RMqiJFnb/LPAlMlyqGXroFBrtTb2P49zfUKSby1HysBI4bvxvSVSuE/Q3P
         BtpFNuIB39SYRfYkxeO3bIXMAXzUSvr+/JD2Nlb8m/j4lIydTNG9H8/Pd4kPQQXYqa0p
         xliZVDFsI95RGHc2s7H+JvDU3AH+s9SiRLITliNNK7DeALWOEjLHxAaYdnNng0EXkcDH
         TiMQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1734482163; x=1735086963;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=7+YHcXEAtBvssxU5fzHig35lu0TSHQacf/OaCK3OLTg=;
        b=AAjAe0Xb782A12PNN7MOXVABmU2eRDztDOL03R/NLxH/4diDUu3TXSIc1AzuDBmHnm
         bQhVwf5ZtamfZiQ879Fd4LF9hH+VVTMAova345/AcJH1maYepcConejmMGLCs7HXsJvZ
         g5ycO+v5gfKjWo+8J+n2R0nqdI8lvFneQn54ENjJcqBK8Jt7rX9dg7UWO6yYlbbRrLRE
         2HMQkTvG16r4OtCpn+0zlwOrcoPFywQd07QhToFdAupAWjpQztT2aqEVUWaRuZhBJ3oG
         DXV//HjbeoUZP3VrTvaJk6AX2U2DCv3p8xN9H7b1NjRFiSgmdYdJEdLyXDOpaov2TqK/
         sPnA==
X-Gm-Message-State: AOJu0YwCN33u0izXdARoAcZUBTbTI4myZYo22uI/tonOv9WwKrmmXSWt
	Qgj2UUcNtWfnMR5BtExj5onsxznfYwOI1JqUyyNwqdWuo3khuaLQzn06L8b+o0VmufUny29HsmZ
	5
X-Gm-Gg: ASbGnctLGJC3bf+wJMLcLwQ7eRW89nLJVRnDoUDvMQFpEOpLkGy7f7W7qQezZFkaRdY
	5JiRjqtWSLIcyhRnp+g9WSQHest6UZYx8IUDZ/hiu2BZDXYXiHfoSKc+dYt/O/66y4iHPKz7i/r
	sDgfp4y98eQv7TGWN/kbDwT4ZYLAqvBba9o/XAf9BCD1o7YlshLp//ifDlqJ6EVW3mAf06HfcLs
	a2/teV0Yo+vTpK3VBqeQUXM0x+Mmj1piSpnWvuj
X-Google-Smtp-Source: AGHT+IG9eZOp7o24F0/wYICCIexTeTkUf+O5Z4ADqX8ZWVX0DN3EdsMA37bLTB4Nn7tgXsIOn+hHHg==
X-Received: by 2002:a17:903:2447:b0:216:725c:a12c with SMTP id d9443c01a7336-218d6fd7926mr11915495ad.9.1734482163605;
        Tue, 17 Dec 2024 16:36:03 -0800 (PST)
Received: from localhost ([2a03:2880:ff:d::])
        by smtp.gmail.com with ESMTPSA id d9443c01a7336-218a1db5e05sm65238145ad.44.2024.12.17.16.36.02
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 17 Dec 2024 16:36:03 -0800 (PST)
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
Subject: [--bla-- 04/20] net: page_pool: create hooks for custom page providers
Date: Tue, 17 Dec 2024 16:35:32 -0800
Message-ID: <20241218003549.786301-5-dw@davidwei.uk>
X-Mailer: git-send-email 2.43.5
In-Reply-To: <20241218003549.786301-1-dw@davidwei.uk>
References: <20241218003549.786301-1-dw@davidwei.uk>
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


