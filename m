Return-Path: <io-uring+bounces-3742-lists+io-uring=lfdr.de@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [IPv6:2604:1380:45d1:ec00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 8BC539A11EA
	for <lists+io-uring@lfdr.de>; Wed, 16 Oct 2024 20:53:34 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id 83F8E1C22895
	for <lists+io-uring@lfdr.de>; Wed, 16 Oct 2024 18:53:33 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 9D2262144BB;
	Wed, 16 Oct 2024 18:53:06 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=davidwei-uk.20230601.gappssmtp.com header.i=@davidwei-uk.20230601.gappssmtp.com header.b="TdwWyC0v"
X-Original-To: io-uring@vger.kernel.org
Received: from mail-pl1-f172.google.com (mail-pl1-f172.google.com [209.85.214.172])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1FC0D2141DD
	for <io-uring@vger.kernel.org>; Wed, 16 Oct 2024 18:53:04 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.214.172
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1729104786; cv=none; b=Rlp3x5SB42n4xFHZEFYuyS+SRhl474dCycOMwXvHQpscEkcFUkGrf+Tfjqd3JAJcjVzXdJaM8PDhIK4W0Dc1oBmj9T1+LPbyotIswnFif9WFtV5Z0PaUpz/R1uf18iCKapiXAF87sDXBwjxdrfagUBwtVGH9C4b5GDNfRysmyKU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1729104786; c=relaxed/simple;
	bh=c/hs9Erraa93gXWEWREOKQp+/LMKJ82xklT+mxet+Hs=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=RDB/rqKtF95WDHYocIhOP6C0vI7PmLf+Hyzs4jsPHvZiV/xZ4eG3YGZU56crpVdoHB6O+xm29yNygPNccMZ6vukLurwDLTUBCUe9zkj0crYHu51ka6LotdEJ1POY6FVyo3TuuIWB+betjk9YYCmYohmL6TU006sGYJ83KrKrqog=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=davidwei.uk; spf=none smtp.mailfrom=davidwei.uk; dkim=pass (2048-bit key) header.d=davidwei-uk.20230601.gappssmtp.com header.i=@davidwei-uk.20230601.gappssmtp.com header.b=TdwWyC0v; arc=none smtp.client-ip=209.85.214.172
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=davidwei.uk
Authentication-Results: smtp.subspace.kernel.org; spf=none smtp.mailfrom=davidwei.uk
Received: by mail-pl1-f172.google.com with SMTP id d9443c01a7336-20ce5e3b116so1256365ad.1
        for <io-uring@vger.kernel.org>; Wed, 16 Oct 2024 11:53:04 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=davidwei-uk.20230601.gappssmtp.com; s=20230601; t=1729104784; x=1729709584; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=TnQKuPWcDSploXBkZqG6nFOkPs0h6NssQB03UgU7Hn8=;
        b=TdwWyC0vwI43FgjV4+V1vV7wi9CyGMit0sCfkgc869Td0+IJ63xaeMlza+tGALeIen
         NMf0YNe1aaXTFvM5HUM4Xm28rvM8SswDKRxb0l0jKQ3RwxOZ6CdyFd8WHq+9OeA3kIOT
         dq78iBNjRAjBtATg74+5ZV3bxm/mcXoNFQRBTuJG0w77RwnEZFRJYZBuLRmIsxiYUlvz
         U/kngPSbnkQ+Y2+XscZqgCuL50dFEu08wkWXNqzm+611EtUFQm2HZ6bYOEhKNDWuNFQ1
         BHU27yV+Nxqy3RP4WeMxrBl3mmCfTVxnSivUyGciyFmbCrcxJkZEahawBA/Dlvq2SEFR
         AfNQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1729104784; x=1729709584;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=TnQKuPWcDSploXBkZqG6nFOkPs0h6NssQB03UgU7Hn8=;
        b=LFLZtGiy/JSOl4apL2YfeoGO6OFsWWfTk65rXSyNNj5s3wwpB6qUWjYo3sTo7cBW2W
         7VxGODSjESbgFOc6u8F2Twi0PAmKfRmeY3v3/IoBR6EI0qxYvGKhHOyXuwC78CV5RVSe
         4s4BaEP/J/0NdcF6QmO0skH77L0PQAZUK6txfGmz2KFZ6w6CW6xGIvCs3Fd1c4iEctb0
         6DvyVHiluOXcs/50RDoPZW6wUnA2Zuy08jwPRptApHTj6bgB5u47aa4l1nKjGVPgEjI4
         9fGcmro0YSfGNBy4/uPIyQF4AVkIyM0fxtyA7L1EyPb6OwHjlg0HPcWF9mv+u8L/i8v8
         zeow==
X-Gm-Message-State: AOJu0Yxl6ZTHvaQhRIXDUTIoVogs54Coo/Ep1xsFR7Pq1aSWPBdIwuH5
	zOiil0l9q6ca4fS+wyINC68KwCH9EI560hqCodD4g5wnkN9m8UH9DvT1H1f3YeiRZMaCcKgjZXB
	c
X-Google-Smtp-Source: AGHT+IEh5cu2mu0MJPXxPBYOPgZupLKE6ZtIE//SyXgeftoFTcJvPeuX00cX/dFi3ndeTU/P/rUpag==
X-Received: by 2002:a17:902:cec2:b0:20c:7485:891c with SMTP id d9443c01a7336-20cbb24ca76mr204201315ad.54.1729104784455;
        Wed, 16 Oct 2024 11:53:04 -0700 (PDT)
Received: from localhost (fwdproxy-prn-033.fbsv.net. [2a03:2880:ff:21::face:b00c])
        by smtp.gmail.com with ESMTPSA id d9443c01a7336-20d1805caa6sm31680975ad.271.2024.10.16.11.53.03
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 16 Oct 2024 11:53:03 -0700 (PDT)
From: David Wei <dw@davidwei.uk>
To: io-uring@vger.kernel.org,
	netdev@vger.kernel.org
Cc: David Wei <dw@davidwei.uk>,
	Jens Axboe <axboe@kernel.dk>,
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
Subject: [PATCH v6 03/15] net: page_pool: create hooks for custom page providers
Date: Wed, 16 Oct 2024 11:52:40 -0700
Message-ID: <20241016185252.3746190-4-dw@davidwei.uk>
X-Mailer: git-send-email 2.43.5
In-Reply-To: <20241016185252.3746190-1-dw@davidwei.uk>
References: <20241016185252.3746190-1-dw@davidwei.uk>
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
index a813d30d2135..c21c5b9edc68 100644
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


