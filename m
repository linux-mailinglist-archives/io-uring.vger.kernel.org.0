Return-Path: <io-uring+bounces-8832-lists+io-uring=lfdr.de@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [147.75.80.249])
	by mail.lfdr.de (Postfix) with ESMTPS id 5E94AB139A6
	for <lists+io-uring@lfdr.de>; Mon, 28 Jul 2025 13:07:38 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id 8446B189DFF3
	for <lists+io-uring@lfdr.de>; Mon, 28 Jul 2025 11:05:52 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 592742652BD;
	Mon, 28 Jul 2025 11:03:47 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="gvP/c8+I"
X-Original-To: io-uring@vger.kernel.org
Received: from mail-wr1-f52.google.com (mail-wr1-f52.google.com [209.85.221.52])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 69DE1246BA5;
	Mon, 28 Jul 2025 11:03:45 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.221.52
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1753700627; cv=none; b=YD6mEs3CEqzL/jzsgfF6vCxmy5lI+UkUHhq2xTAcn/Kh2dOAWegcTD6E4QNRAQ19ldIzBNSwjl1lKDX90euHVdJoUWnjlZrJllcUqrrurHAbh0nyTdD9m6AebMfVeeiN2Xt8Tbb8yErVp/ZSsGVoSrmp6XVv8glcnX7oN/nRGqE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1753700627; c=relaxed/simple;
	bh=2ZmmWhyxV2Xy5ZDPcNbqfoH6WF+knYxUATYyF45hSWc=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=e6IT5KCjRljd9Ox55aioegC85rFCW5h7Zt2MJwrToC9KKkgVEmfasBAnr9qiTR9IBdzIxsSPPqtUzG1pxkosADjAPGQ8phUtK9krlL3rG7k/ExmK9JLva2oh/QjOuI4zD/2ebV+o3gprOfvXlBw7DtW5CjWsEtdRNvDHCYHKY1A=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=gvP/c8+I; arc=none smtp.client-ip=209.85.221.52
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Received: by mail-wr1-f52.google.com with SMTP id ffacd0b85a97d-3b782cca9a0so1040641f8f.1;
        Mon, 28 Jul 2025 04:03:45 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1753700624; x=1754305424; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=4Y+o/wT2besHkW28d0LfyCbVOhyMrKYx3whk232pX7A=;
        b=gvP/c8+IldUG3U+6AngN+/YI81lKHbanUDhxsfvBqgNT4PONyEKNkZirpSwcZFNcDJ
         opRfNUO5HEu2pBFyoDx4/RaIFg0xZq/FO2nh+Zy3tBKQhRnfAYYD6ylHcO5EZZ/5kgzT
         JNxf7IdxZru69uOTihxesEuFbZfsVwrJWNzpWY9Y73oyAoyrPaGY9t+c8a9kSrLlrVEx
         sK0ji/Vr4eG98EfgA9fEPFyUtJQwUYWJPvFchGBxO9Lcv/zWib3az6s8dJaXXkXnPHVO
         xVIeet8t6JHE60n5pcIXTHaRmFDgHE64wVydToZZIlizNiCAFHFaEM5N2KbBYqXc18EA
         VgxA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1753700624; x=1754305424;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=4Y+o/wT2besHkW28d0LfyCbVOhyMrKYx3whk232pX7A=;
        b=Ms372fvmsRXmATn7u72NoVp1iytrzVWVsErreVdVXjUC02RRSDQv+nyOCJciVQE0sJ
         3C9Wd1LFgOpZgw6SLeNzsKTx+u/8m5/KemENmA4E7YqaWiAzUE7E4jciKTd9/TcqtENZ
         pzy3VYbtzAVwEcsjJDUWDuFSDLDSMd8SN1O+ROJkkqMcWLEBUSpdCC4EL/cAqJ+/kPQF
         5voeNKjVZ3njXN8HXycSUt4Yx9+nwt0Pw3uKg8BSxI6G9CblI/rsUIUXuokpT2Suozl+
         Uwx35HEjNUfMj+1Ae7UMACQsQeW92oHuS8bD/M97MGMdM1sdZv72Ch0XPs07V0PVAGhk
         5q/A==
X-Forwarded-Encrypted: i=1; AJvYcCUe+uAD95X9JAR0QOfE8GP8YSxFrR30kz9wd6wl97q2Z+wLVO/ABobOfMzmEe2l3lNjqy8vr5wjqg==@vger.kernel.org, AJvYcCVFt9bUk5fwm7uiyiQh8dTTW7y1bFwdyYuXnmVNFPpJLfTuE2eOVtm+/UEcTA3e3Trcx5Cfq0Te@vger.kernel.org
X-Gm-Message-State: AOJu0YxLt1y5GkSxCQT7NfOudX9/a2jKNiB3CC3G8viBsl+1cpJTCogC
	vWOpr+8k5+X44zywt1IOU7ujeSQBnkj2QRjNOdZ72ITqt6TyhKfNCqBw
X-Gm-Gg: ASbGncuD/kago0LbeYlfTyMd5R4NSwLrq10PBVXq0W2W1LRfvuM68NtGP5pZDp0uTWf
	2C5nZ+7h12s+pgCD94KMV9mxUivB5USvtUOl+y1EEnjyOuqqU/Zx0P8fTu/raAZCoFfbnF6KzCM
	6B1kdCKkHL0ZJu8RAtCkHTRfST680ZT+hC0R0288qdMr0ozht5gTYoKz+pu1of5Y6ftZiLuPFKH
	qqQa5bFrlFaYGlUA0o36JiTwQBi1CI/5wONx/mV4XaBnpbvHsbzFYhFCcOJfzYClZ2oYmqx2kx/
	W3hWBzL8z7BAaArCHDQuJ13aLV8mK0cJAoVzXRcWMs0hohFa0JbmLpmY3vOQ4d0+6bgmEVS+xKo
	jOp60gfgkfOrznQ==
X-Google-Smtp-Source: AGHT+IG6qmTQvyjl072/BWHKZ22s4OpG2ZUt5jWgUWEivx3IGW0nkZYpaFLampJ1mtD4CMxFLsLRxw==
X-Received: by 2002:a05:6000:3111:b0:3a4:f6ba:51da with SMTP id ffacd0b85a97d-3b7765eda40mr7169043f8f.15.1753700623509;
        Mon, 28 Jul 2025 04:03:43 -0700 (PDT)
Received: from 127.com ([2620:10d:c092:600::1:75])
        by smtp.gmail.com with ESMTPSA id 5b1f17b1804b1-458705c4fdasm157410235e9.28.2025.07.28.04.03.41
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 28 Jul 2025 04:03:42 -0700 (PDT)
From: Pavel Begunkov <asml.silence@gmail.com>
To: Jakub Kicinski <kuba@kernel.org>,
	netdev@vger.kernel.org
Cc: asml.silence@gmail.com,
	io-uring@vger.kernel.org,
	Eric Dumazet <edumazet@google.com>,
	Willem de Bruijn <willemb@google.com>,
	Paolo Abeni <pabeni@redhat.com>,
	andrew+netdev@lunn.ch,
	horms@kernel.org,
	davem@davemloft.net,
	sdf@fomichev.me,
	almasrymina@google.com,
	dw@davidwei.uk,
	michael.chan@broadcom.com,
	dtatulea@nvidia.com,
	ap420073@gmail.com
Subject: [RFC v1 21/22] net: parametrise mp open with a queue config
Date: Mon, 28 Jul 2025 12:04:25 +0100
Message-ID: <ca874424e226417fa174ac015ee62cc0e3092400.1753694914.git.asml.silence@gmail.com>
X-Mailer: git-send-email 2.49.0
In-Reply-To: <cover.1753694913.git.asml.silence@gmail.com>
References: <cover.1753694913.git.asml.silence@gmail.com>
Precedence: bulk
X-Mailing-List: io-uring@vger.kernel.org
List-Id: <io-uring.vger.kernel.org>
List-Subscribe: <mailto:io-uring+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:io-uring+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

This patch allows memory providers to pass a queue config when opening a
queue. It'll be used in the next patch to pass a custom rx buffer length
from zcrx. As there are many users of netdev_rx_queue_restart(), it's
allowed to pass a NULL qcfg, in which case the function will use the
default configuration.

Signed-off-by: Pavel Begunkov <asml.silence@gmail.com>
---
 include/net/page_pool/memory_provider.h |  4 +-
 io_uring/zcrx.c                         |  2 +-
 net/core/netdev_rx_queue.c              | 50 +++++++++++++++++--------
 3 files changed, 39 insertions(+), 17 deletions(-)

diff --git a/include/net/page_pool/memory_provider.h b/include/net/page_pool/memory_provider.h
index ada4f968960a..c08ba208f67d 100644
--- a/include/net/page_pool/memory_provider.h
+++ b/include/net/page_pool/memory_provider.h
@@ -5,6 +5,7 @@
 #include <net/netmem.h>
 #include <net/page_pool/types.h>
 
+struct netdev_queue_config;
 struct netdev_rx_queue;
 struct netlink_ext_ack;
 struct sk_buff;
@@ -24,7 +25,8 @@ void net_mp_niov_set_page_pool(struct page_pool *pool, struct net_iov *niov);
 void net_mp_niov_clear_page_pool(struct net_iov *niov);
 
 int net_mp_open_rxq(struct net_device *dev, unsigned ifq_idx,
-		    struct pp_memory_provider_params *p);
+		    struct pp_memory_provider_params *p,
+		    struct netdev_queue_config *qcfg);
 int __net_mp_open_rxq(struct net_device *dev, unsigned int rxq_idx,
 		      const struct pp_memory_provider_params *p,
 		      struct netlink_ext_ack *extack);
diff --git a/io_uring/zcrx.c b/io_uring/zcrx.c
index 985c7386e24b..a00243e10164 100644
--- a/io_uring/zcrx.c
+++ b/io_uring/zcrx.c
@@ -595,7 +595,7 @@ int io_register_zcrx_ifq(struct io_ring_ctx *ctx,
 
 	mp_param.mp_ops = &io_uring_pp_zc_ops;
 	mp_param.mp_priv = ifq;
-	ret = net_mp_open_rxq(ifq->netdev, reg.if_rxq, &mp_param);
+	ret = net_mp_open_rxq(ifq->netdev, reg.if_rxq, &mp_param, NULL);
 	if (ret)
 		goto err;
 	ifq->if_rxq = reg.if_rxq;
diff --git a/net/core/netdev_rx_queue.c b/net/core/netdev_rx_queue.c
index 7c691eb1a48b..0dbfdb5f5b91 100644
--- a/net/core/netdev_rx_queue.c
+++ b/net/core/netdev_rx_queue.c
@@ -10,12 +10,14 @@
 #include "dev.h"
 #include "page_pool_priv.h"
 
-int netdev_rx_queue_restart(struct net_device *dev, unsigned int rxq_idx,
-			    struct netlink_ext_ack *extack)
+static int netdev_rx_queue_restart_cfg(struct net_device *dev,
+				unsigned int rxq_idx,
+				struct netlink_ext_ack *extack,
+				struct netdev_queue_config *qcfg)
 {
 	struct netdev_rx_queue *rxq = __netif_get_rx_queue(dev, rxq_idx);
 	const struct netdev_queue_mgmt_ops *qops = dev->queue_mgmt_ops;
-	struct netdev_queue_config qcfg;
+	struct netdev_queue_config tmp_qcfg;
 	void *new_mem, *old_mem;
 	int err;
 
@@ -35,15 +37,18 @@ int netdev_rx_queue_restart(struct net_device *dev, unsigned int rxq_idx,
 		goto err_free_new_mem;
 	}
 
-	netdev_queue_config(dev, rxq_idx, &qcfg);
+	if (!qcfg) {
+		qcfg = &tmp_qcfg;
+		netdev_queue_config(dev, rxq_idx, qcfg);
+	}
 
 	if (qops->ndo_queue_cfg_validate) {
-		err = qops->ndo_queue_cfg_validate(dev, rxq_idx, &qcfg, extack);
+		err = qops->ndo_queue_cfg_validate(dev, rxq_idx, qcfg, extack);
 		if (err)
 			goto err_free_old_mem;
 	}
 
-	err = qops->ndo_queue_mem_alloc(dev, &qcfg, new_mem, rxq_idx);
+	err = qops->ndo_queue_mem_alloc(dev, qcfg, new_mem, rxq_idx);
 	if (err)
 		goto err_free_old_mem;
 
@@ -56,7 +61,7 @@ int netdev_rx_queue_restart(struct net_device *dev, unsigned int rxq_idx,
 		if (err)
 			goto err_free_new_queue_mem;
 
-		err = qops->ndo_queue_start(dev, &qcfg, new_mem, rxq_idx);
+		err = qops->ndo_queue_start(dev, qcfg, new_mem, rxq_idx);
 		if (err)
 			goto err_start_queue;
 	} else {
@@ -71,7 +76,7 @@ int netdev_rx_queue_restart(struct net_device *dev, unsigned int rxq_idx,
 	return 0;
 
 err_start_queue:
-	__netdev_queue_config(dev, rxq_idx, &qcfg, false);
+	__netdev_queue_config(dev, rxq_idx, qcfg, false);
 	/* Restarting the queue with old_mem should be successful as we haven't
 	 * changed any of the queue configuration, and there is not much we can
 	 * do to recover from a failure here.
@@ -79,7 +84,7 @@ int netdev_rx_queue_restart(struct net_device *dev, unsigned int rxq_idx,
 	 * WARN if we fail to recover the old rx queue, and at least free
 	 * old_mem so we don't also leak that.
 	 */
-	if (qops->ndo_queue_start(dev, &qcfg, old_mem, rxq_idx)) {
+	if (qops->ndo_queue_start(dev, qcfg, old_mem, rxq_idx)) {
 		WARN(1,
 		     "Failed to restart old queue in error path. RX queue %d may be unhealthy.",
 		     rxq_idx);
@@ -97,11 +102,18 @@ int netdev_rx_queue_restart(struct net_device *dev, unsigned int rxq_idx,
 
 	return err;
 }
+
+int netdev_rx_queue_restart(struct net_device *dev, unsigned int rxq_idx,
+			    struct netlink_ext_ack *extack)
+{
+	return netdev_rx_queue_restart_cfg(dev, rxq_idx, extack, NULL);
+}
 EXPORT_SYMBOL_NS_GPL(netdev_rx_queue_restart, "NETDEV_INTERNAL");
 
-int __net_mp_open_rxq(struct net_device *dev, unsigned int rxq_idx,
-		      const struct pp_memory_provider_params *p,
-		      struct netlink_ext_ack *extack)
+static int __net_mp_open_rxq_cfg(struct net_device *dev, unsigned int rxq_idx,
+				const struct pp_memory_provider_params *p,
+				struct netlink_ext_ack *extack,
+				struct netdev_queue_config *qcfg)
 {
 	struct netdev_rx_queue *rxq;
 	int ret;
@@ -143,7 +155,7 @@ int __net_mp_open_rxq(struct net_device *dev, unsigned int rxq_idx,
 #endif
 
 	rxq->mp_params = *p;
-	ret = netdev_rx_queue_restart(dev, rxq_idx, extack);
+	ret = netdev_rx_queue_restart_cfg(dev, rxq_idx, extack, qcfg);
 	if (ret) {
 		rxq->mp_params.mp_ops = NULL;
 		rxq->mp_params.mp_priv = NULL;
@@ -151,13 +163,21 @@ int __net_mp_open_rxq(struct net_device *dev, unsigned int rxq_idx,
 	return ret;
 }
 
+int __net_mp_open_rxq(struct net_device *dev, unsigned int rxq_idx,
+		      const struct pp_memory_provider_params *p,
+		      struct netlink_ext_ack *extack)
+{
+	return __net_mp_open_rxq_cfg(dev, rxq_idx, p, extack, NULL);
+}
+
 int net_mp_open_rxq(struct net_device *dev, unsigned int rxq_idx,
-		    struct pp_memory_provider_params *p)
+		    struct pp_memory_provider_params *p,
+		    struct netdev_queue_config *qcfg)
 {
 	int ret;
 
 	netdev_lock(dev);
-	ret = __net_mp_open_rxq(dev, rxq_idx, p, NULL);
+	ret = __net_mp_open_rxq_cfg(dev, rxq_idx, p, NULL, qcfg);
 	netdev_unlock(dev);
 	return ret;
 }
-- 
2.49.0


