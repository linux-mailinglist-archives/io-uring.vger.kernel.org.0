Return-Path: <io-uring+bounces-3446-lists+io-uring=lfdr.de@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [IPv6:2604:1380:4601:e00::3])
	by mail.lfdr.de (Postfix) with ESMTPS id 23A4F9939F7
	for <lists+io-uring@lfdr.de>; Tue,  8 Oct 2024 00:17:08 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id DF2601F23488
	for <lists+io-uring@lfdr.de>; Mon,  7 Oct 2024 22:17:06 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 86854190463;
	Mon,  7 Oct 2024 22:16:35 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=davidwei-uk.20230601.gappssmtp.com header.i=@davidwei-uk.20230601.gappssmtp.com header.b="AAMLnG2x"
X-Original-To: io-uring@vger.kernel.org
Received: from mail-pg1-f175.google.com (mail-pg1-f175.google.com [209.85.215.175])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1E16818E359
	for <io-uring@vger.kernel.org>; Mon,  7 Oct 2024 22:16:33 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.215.175
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1728339395; cv=none; b=lgVJx9MKxHl0SSeSFiCEdHyaGBSRT4Bzt+fC14c7/bMWlPdJsVO2Dr3uv7Fi49rgaFCMCR3RxQGKf08aGazqKYsDqY/r2xcIDVmDzOzW1KJRPLJF3dM8jzd859FGsciXbrblaTT2LHtTZELZC8uVuUD3IuOO/VHiBghHeMx6Pyk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1728339395; c=relaxed/simple;
	bh=PzvHDCZ7021Z0HKhDmIQWr7NYdzsNljWLWXKZ7LyhwI=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=pyY6vifndb1X9ThX9jB2nBA1mtreDDLGanxcdCfD8kM9+fT6wQ+CydRzquxQe8AhzMtZr7miGiOAjfFfdL0uAzRQfGyPSk114DfzwqwPQH6dMS736fAuFDzK61Wi3pbLcRaxBcjj5rU6bfM4Zrz72UVU+RwRTN5d+XAB84sCzCU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=davidwei.uk; spf=none smtp.mailfrom=davidwei.uk; dkim=pass (2048-bit key) header.d=davidwei-uk.20230601.gappssmtp.com header.i=@davidwei-uk.20230601.gappssmtp.com header.b=AAMLnG2x; arc=none smtp.client-ip=209.85.215.175
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=davidwei.uk
Authentication-Results: smtp.subspace.kernel.org; spf=none smtp.mailfrom=davidwei.uk
Received: by mail-pg1-f175.google.com with SMTP id 41be03b00d2f7-7db637d1e4eso3609317a12.2
        for <io-uring@vger.kernel.org>; Mon, 07 Oct 2024 15:16:33 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=davidwei-uk.20230601.gappssmtp.com; s=20230601; t=1728339393; x=1728944193; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=T9pcBB36/ecxZhukt1XlNbWeZgVQ3rKv4Hy/wLZFefI=;
        b=AAMLnG2x+FkHGh/nWF9+ABrYdLcH0rqncL4q3Xk9JfT2yOVeLpQ9JYG86qSkCrojRG
         +El+lxnKMyA72pVUurfwJ5C/V76En9UK371eI6ktWt6WiQm+j93rLlan8YLK0RwQxHBL
         9Imn1+txtA0JMqzWu59HBh2F0JwcHUq+rzpc6N01NapD67d9XCGcX0/ZkJjI7Si97p2N
         C7UjhS9n+Fj2MNNW803b+KE+epeswJCBOpYGvHynNV25DEArE8GWsJrPgxD6o/dkqgvk
         AxbWPKjD1QU49uFbLRJ47jIFv1MpPEAp9nFNcVlaVH10leH1VYi9qZKzO7BHcaP1kSvi
         C/xA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1728339393; x=1728944193;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=T9pcBB36/ecxZhukt1XlNbWeZgVQ3rKv4Hy/wLZFefI=;
        b=VWfe2Pxr52agThanxNvBNaEVgozq73t7t3cN6V2eFHCmPTJr//FMdQcgG6WJDwN0JR
         x1DzgLfHqgJOoYMhF5LVho8Xvj/XRAhfHtxH/ywEHGEyqZjx5BHaDAyIzSwWiWYyI8Rp
         nTXwpVmOufcnTfa6PFUKdWPwCLM6vsEtVPpswIqMzNE1rIAZsdxVKq7rdAMGXsAI1Fh/
         U7WhQQuGwsvuOAP+6UdwDQemwtH48qM6Cn+F8WFvqqZKVbgBatlDyt6ej4S2X2A2Lc6e
         B/xvkA25oSTyFqmJLAxxXU3BFimJOZ7oAyjXSjh3i2fYRx8QaXxe1sP4bqW31aNS/g/K
         aNPQ==
X-Gm-Message-State: AOJu0Yy6m4bsiARg3FLK+CdwqZerS/S5Wx0p8Cf4oWIZuod4pkDBA9N1
	l12ypyNcS3yEPz2hHwYLNRWiFoO7pXHae0eRDHf0IdH+GaIKGQT3xHCqk8xbAGctOA+fk6QfaEs
	D
X-Google-Smtp-Source: AGHT+IETMvKxdjMQtaM8iuhPGelqYhvGKkMtsR+IfLNdg5zFQkOW4alFDxqcPGfPi/W8pkNtVtb7ew==
X-Received: by 2002:a05:6a20:6f9c:b0:1d1:13de:68c6 with SMTP id adf61e73a8af0-1d6dfa406b7mr20127507637.29.1728339393417;
        Mon, 07 Oct 2024 15:16:33 -0700 (PDT)
Received: from localhost (fwdproxy-prn-037.fbsv.net. [2a03:2880:ff:25::face:b00c])
        by smtp.gmail.com with ESMTPSA id d2e1a72fcca58-71df0d7d02asm4887626b3a.197.2024.10.07.15.16.32
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 07 Oct 2024 15:16:33 -0700 (PDT)
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
	Mina Almasry <almasrymina@google.com>
Subject: [PATCH v1 05/15] net: prepare for non devmem TCP memory providers
Date: Mon,  7 Oct 2024 15:15:53 -0700
Message-ID: <20241007221603.1703699-6-dw@davidwei.uk>
X-Mailer: git-send-email 2.43.5
In-Reply-To: <20241007221603.1703699-1-dw@davidwei.uk>
References: <20241007221603.1703699-1-dw@davidwei.uk>
Precedence: bulk
X-Mailing-List: io-uring@vger.kernel.org
List-Id: <io-uring.vger.kernel.org>
List-Subscribe: <mailto:io-uring+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:io-uring+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

From: Pavel Begunkov <asml.silence@gmail.com>

There is a good bunch of places in generic paths assuming that the only
page pool memory provider is devmem TCP. As we want to reuse the net_iov
and provider infrastructure, we need to patch it up and explicitly check
the provider type when we branch into devmem TCP code.

Signed-off-by: Pavel Begunkov <asml.silence@gmail.com>
Signed-off-by: David Wei <dw@davidwei.uk>
---
 net/core/devmem.c         |  4 ++--
 net/core/page_pool_user.c | 15 +++++++++------
 net/ipv4/tcp.c            |  6 ++++++
 3 files changed, 17 insertions(+), 8 deletions(-)

diff --git a/net/core/devmem.c b/net/core/devmem.c
index 83d13eb441b6..b0733cf42505 100644
--- a/net/core/devmem.c
+++ b/net/core/devmem.c
@@ -314,10 +314,10 @@ void dev_dmabuf_uninstall(struct net_device *dev)
 	unsigned int i;
 
 	for (i = 0; i < dev->real_num_rx_queues; i++) {
-		binding = dev->_rx[i].mp_params.mp_priv;
-		if (!binding)
+		if (dev->_rx[i].mp_params.mp_ops != &dmabuf_devmem_ops)
 			continue;
 
+		binding = dev->_rx[i].mp_params.mp_priv;
 		xa_for_each(&binding->bound_rxqs, xa_idx, rxq)
 			if (rxq == &dev->_rx[i]) {
 				xa_erase(&binding->bound_rxqs, xa_idx);
diff --git a/net/core/page_pool_user.c b/net/core/page_pool_user.c
index 48335766c1bf..0d6cb7fb562c 100644
--- a/net/core/page_pool_user.c
+++ b/net/core/page_pool_user.c
@@ -214,7 +214,7 @@ static int
 page_pool_nl_fill(struct sk_buff *rsp, const struct page_pool *pool,
 		  const struct genl_info *info)
 {
-	struct net_devmem_dmabuf_binding *binding = pool->mp_priv;
+	struct net_devmem_dmabuf_binding *binding;
 	size_t inflight, refsz;
 	void *hdr;
 
@@ -244,8 +244,11 @@ page_pool_nl_fill(struct sk_buff *rsp, const struct page_pool *pool,
 			 pool->user.detach_time))
 		goto err_cancel;
 
-	if (binding && nla_put_u32(rsp, NETDEV_A_PAGE_POOL_DMABUF, binding->id))
-		goto err_cancel;
+	if (pool->mp_ops == &dmabuf_devmem_ops) {
+		binding = pool->mp_priv;
+		if (nla_put_u32(rsp, NETDEV_A_PAGE_POOL_DMABUF, binding->id))
+			goto err_cancel;
+	}
 
 	genlmsg_end(rsp, hdr);
 
@@ -353,16 +356,16 @@ void page_pool_unlist(struct page_pool *pool)
 int page_pool_check_memory_provider(struct net_device *dev,
 				    struct netdev_rx_queue *rxq)
 {
-	struct net_devmem_dmabuf_binding *binding = rxq->mp_params.mp_priv;
+	void *mp_priv = rxq->mp_params.mp_priv;
 	struct page_pool *pool;
 	struct hlist_node *n;
 
-	if (!binding)
+	if (!mp_priv)
 		return 0;
 
 	mutex_lock(&page_pools_lock);
 	hlist_for_each_entry_safe(pool, n, &dev->page_pools, user.list) {
-		if (pool->mp_priv != binding)
+		if (pool->mp_priv != mp_priv)
 			continue;
 
 		if (pool->slow.queue_idx == get_netdev_rx_queue_index(rxq)) {
diff --git a/net/ipv4/tcp.c b/net/ipv4/tcp.c
index 5feef46426f4..2140fa1ec9f8 100644
--- a/net/ipv4/tcp.c
+++ b/net/ipv4/tcp.c
@@ -277,6 +277,7 @@
 #include <net/ip.h>
 #include <net/sock.h>
 #include <net/rstreason.h>
+#include <net/page_pool/types.h>
 
 #include <linux/uaccess.h>
 #include <asm/ioctls.h>
@@ -2475,6 +2476,11 @@ static int tcp_recvmsg_dmabuf(struct sock *sk, const struct sk_buff *skb,
 			}
 
 			niov = skb_frag_net_iov(frag);
+			if (niov->pp->mp_ops != &dmabuf_devmem_ops) {
+				err = -ENODEV;
+				goto out;
+			}
+
 			end = start + skb_frag_size(frag);
 			copy = end - offset;
 
-- 
2.43.5


