Return-Path: <io-uring+bounces-9028-lists+io-uring=lfdr.de@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [147.75.80.249])
	by mail.lfdr.de (Postfix) with ESMTPS id 5E8D3B2A926
	for <lists+io-uring@lfdr.de>; Mon, 18 Aug 2025 16:16:23 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id 40ED11B63C47
	for <lists+io-uring@lfdr.de>; Mon, 18 Aug 2025 14:01:29 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 937CB2E22AF;
	Mon, 18 Aug 2025 13:56:57 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="cnFT/iPv"
X-Original-To: io-uring@vger.kernel.org
Received: from mail-wm1-f43.google.com (mail-wm1-f43.google.com [209.85.128.43])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C61E53375AB;
	Mon, 18 Aug 2025 13:56:55 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.128.43
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1755525417; cv=none; b=dtM2PBDIXRvers020WSMnjMVxreJ7JC8wm1hVAMt/gKiZLEejMX1WHcfgHZHsmHsXS+oZwa3nv+CuFOr7Jvl7RYhnXcWC3GKlFKlwGmtaj00XXlLXiY9Thu7YmALV9NGEpaKg7zDxYODW2nHfj8LXOtFNeZkI0ubFaEpKUYYUow=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1755525417; c=relaxed/simple;
	bh=T38WdbqlOu0L/d0CPuCwxUvdVJTQcYf+YLV3SNPIqIU=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=OSRIZZ4wJryWUMjNBQ2jJf3xi1yjd9e+5zbSai6PWJXr8ZEc/GzEAG/2cpGQTYP7AH/6adTcGRQImUH3HQS/tCC34Fz2Ptl57i67ADnRI6Z+DJgxkyIbCJh6Wo+4wpGSfgjvszdTzt8Whjp2u+V62RyBwN0PIRlXmEQ/dPpxnxM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=cnFT/iPv; arc=none smtp.client-ip=209.85.128.43
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Received: by mail-wm1-f43.google.com with SMTP id 5b1f17b1804b1-45a1b066b5eso20329855e9.1;
        Mon, 18 Aug 2025 06:56:55 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1755525414; x=1756130214; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=y+9QuFvmE//f2/12kNYpsjakiZdwYBZ/xWTrgRI26g0=;
        b=cnFT/iPvE9+Vx8t53rNAjhoYON0QwhPfPxnNB0mAS1e4/WVjlH8b8vnKaQXcArekK3
         ip6ENlu/bkEcMP2T+QvnQyjul6GHZUXtyW0SEa7q8kW/3T0nm2M/x68SFRfFhGrx0/Gy
         qdUQy2ML/ySyI44hXDu97GeC8UhtXIhWB0jI9biIEfiOmWJhJgPCMidPbAd8jj/N1wxt
         bOz3yGVu3YZdqLdZ+HytduduOR+IFBkUMnn2fw0oQ+BJWnKGa9zEZKglCPd09VbJVU2a
         Rq9Z2pe/JXK0cIA1jXul+SAfiAdVnaUelBOC+G+152n9MxQelJekuGGdVhXGH2GXv8DC
         B86A==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1755525414; x=1756130214;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=y+9QuFvmE//f2/12kNYpsjakiZdwYBZ/xWTrgRI26g0=;
        b=GgthWydUFMXFlJvAKWzy9AKW0BgORtE4704pZbLbhWTlQLHMJbbxWH7HK7qYaZ1MKJ
         hvd6bZLZEpAOvVgHgr8t9SVFvwFgQjDJrl8IcN1/wX/FtF8ON+4ni+gHal4Vo59RImdc
         VjfVsqDjYjg8l0D3Nkl4PeIBJrqo8ZuKYGn+AthefWDcRGoF/GXMDzszNKCesFBUwIsT
         CtoED6qpEtSNspL5VIkhwCw0xjAURYz4k8iG2giMHsBqS/xApismbIoz70jKQtheQrqa
         gwBoAv7GBcDnwweaRJcieD0SJ+xPkxEaxQ/tCq3Ze56e3zPBi4t8Plsjn7Bv8aVa7kZz
         45lQ==
X-Forwarded-Encrypted: i=1; AJvYcCU5PCoDoFLUHT0ZwSe4iwpCL5AxVHupPU2waR9HD0TxXGdHXUKz+/NSEAzxu8AZI+7CwMZO6PZhnKj7xFw2@vger.kernel.org, AJvYcCUI9GFG9xLBuxPtdS8gzqWb/1Qcwh0n4DNIw93COUYgJPu7Gf9MpqSq3YBafgja8ycjeghcolic@vger.kernel.org, AJvYcCW8ZH8IkcAOVXlxMkiLsm9fd61v9DQpITV3b3GVwKEk8j8i2D4dxQA3Ct6y/FftwgXiTVgpSnQMMg==@vger.kernel.org
X-Gm-Message-State: AOJu0YyCPhVNrVk1leRTwSMuyiZK92sS6dy3YE4V19wGvfJPIha/hkem
	eDkHiKq7B8o/HPbtdEu6KWXJQ3BL0wBcj2zns/AszUDa2pBJAZ7BGXK6
X-Gm-Gg: ASbGncv+3GBep7KMVBhbXYBCBQOsfHG9avARdlGNfHHL3dfhwa5jFg80uQkhyIIcA1B
	7PFQtH2rv/nNHNGBP99JEMgX/PjS8wa5oCqOmASsXimm9cuLiI/cwajUsiZBoPo52r7KgrQ8Tt9
	Mu3Kq9u/a5GtnQWWkSch10le88ofZYKcxMrgb4p0fzzkATA7A6bkkvCQm8TByxmjgW4JFTr9Tt9
	s9u0Qe0YV0lB3LJLiy5qoTrv8CBQHY8spVTI0WzvTuvQ4koLzV+FxoKRBjoshZwCRO4dV5pN3LA
	KhtuXRS6USMV58RKsv4cprsujXbWdx3Eb/sVzOpUEMSZXoDFv/iOh878rNMo/66OYuaE4W9f9pg
	B9fzN8ZBtIJKuMiKSV5kqek+3+365eVevHA==
X-Google-Smtp-Source: AGHT+IGMMKADJ4Wfgv/Orzs7rhoSRaxE6IDC3PJ6RUVwcUkunnT0+U507mQcQxG6mnv0i6XdCxbwFQ==
X-Received: by 2002:a05:600c:474a:b0:459:e025:8c5b with SMTP id 5b1f17b1804b1-45a21864826mr123943255e9.30.1755525413701;
        Mon, 18 Aug 2025 06:56:53 -0700 (PDT)
Received: from 127.0.0.1localhost ([185.69.144.43])
        by smtp.gmail.com with ESMTPSA id 5b1f17b1804b1-45a1b899338sm91187345e9.7.2025.08.18.06.56.51
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 18 Aug 2025 06:56:52 -0700 (PDT)
From: Pavel Begunkov <asml.silence@gmail.com>
To: Jakub Kicinski <kuba@kernel.org>,
	netdev@vger.kernel.org
Cc: asml.silence@gmail.com,
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
	ap420073@gmail.com,
	linux-kernel@vger.kernel.org,
	io-uring@vger.kernel.org
Subject: [PATCH net-next v3 13/23] net: pass extack to netdev_rx_queue_restart()
Date: Mon, 18 Aug 2025 14:57:29 +0100
Message-ID: <bc5d49dc4dcc97b4dcf2504720e9d043b56c911f.1755499376.git.asml.silence@gmail.com>
X-Mailer: git-send-email 2.49.0
In-Reply-To: <cover.1755499375.git.asml.silence@gmail.com>
References: <cover.1755499375.git.asml.silence@gmail.com>
Precedence: bulk
X-Mailing-List: io-uring@vger.kernel.org
List-Id: <io-uring.vger.kernel.org>
List-Subscribe: <mailto:io-uring+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:io-uring+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

From: Jakub Kicinski <kuba@kernel.org>

Pass extack to netdev_rx_queue_restart(). Subsequent change will need it.

Signed-off-by: Jakub Kicinski <kuba@kernel.org>
Signed-off-by: Pavel Begunkov <asml.silence@gmail.com>
---
 drivers/net/ethernet/broadcom/bnxt/bnxt.c | 2 +-
 drivers/net/netdevsim/netdev.c            | 2 +-
 include/net/netdev_rx_queue.h             | 3 ++-
 net/core/netdev_rx_queue.c                | 7 ++++---
 4 files changed, 8 insertions(+), 6 deletions(-)

diff --git a/drivers/net/ethernet/broadcom/bnxt/bnxt.c b/drivers/net/ethernet/broadcom/bnxt/bnxt.c
index 48ff6f024e07..4cb92267251d 100644
--- a/drivers/net/ethernet/broadcom/bnxt/bnxt.c
+++ b/drivers/net/ethernet/broadcom/bnxt/bnxt.c
@@ -11544,7 +11544,7 @@ static void bnxt_irq_affinity_notify(struct irq_affinity_notify *notify,
 
 	netdev_lock(irq->bp->dev);
 	if (netif_running(irq->bp->dev)) {
-		err = netdev_rx_queue_restart(irq->bp->dev, irq->ring_nr);
+		err = netdev_rx_queue_restart(irq->bp->dev, irq->ring_nr, NULL);
 		if (err)
 			netdev_err(irq->bp->dev,
 				   "RX queue restart failed: err=%d\n", err);
diff --git a/drivers/net/netdevsim/netdev.c b/drivers/net/netdevsim/netdev.c
index 985c3403ec57..919088822159 100644
--- a/drivers/net/netdevsim/netdev.c
+++ b/drivers/net/netdevsim/netdev.c
@@ -869,7 +869,7 @@ nsim_qreset_write(struct file *file, const char __user *data,
 	}
 
 	ns->rq_reset_mode = mode;
-	ret = netdev_rx_queue_restart(ns->netdev, queue);
+	ret = netdev_rx_queue_restart(ns->netdev, queue, NULL);
 	ns->rq_reset_mode = 0;
 	if (ret)
 		goto exit_unlock;
diff --git a/include/net/netdev_rx_queue.h b/include/net/netdev_rx_queue.h
index 8cdcd138b33f..a7def1f94823 100644
--- a/include/net/netdev_rx_queue.h
+++ b/include/net/netdev_rx_queue.h
@@ -56,6 +56,7 @@ get_netdev_rx_queue_index(struct netdev_rx_queue *queue)
 	return index;
 }
 
-int netdev_rx_queue_restart(struct net_device *dev, unsigned int rxq);
+int netdev_rx_queue_restart(struct net_device *dev, unsigned int rxq,
+			    struct netlink_ext_ack *extack);
 
 #endif
diff --git a/net/core/netdev_rx_queue.c b/net/core/netdev_rx_queue.c
index fb87ce219a8a..420b956a40e4 100644
--- a/net/core/netdev_rx_queue.c
+++ b/net/core/netdev_rx_queue.c
@@ -10,7 +10,8 @@
 #include "dev.h"
 #include "page_pool_priv.h"
 
-int netdev_rx_queue_restart(struct net_device *dev, unsigned int rxq_idx)
+int netdev_rx_queue_restart(struct net_device *dev, unsigned int rxq_idx,
+			    struct netlink_ext_ack *extack)
 {
 	struct netdev_rx_queue *rxq = __netif_get_rx_queue(dev, rxq_idx);
 	const struct netdev_queue_mgmt_ops *qops = dev->queue_mgmt_ops;
@@ -134,7 +135,7 @@ int __net_mp_open_rxq(struct net_device *dev, unsigned int rxq_idx,
 #endif
 
 	rxq->mp_params = *p;
-	ret = netdev_rx_queue_restart(dev, rxq_idx);
+	ret = netdev_rx_queue_restart(dev, rxq_idx, extack);
 	if (ret) {
 		rxq->mp_params.mp_ops = NULL;
 		rxq->mp_params.mp_priv = NULL;
@@ -177,7 +178,7 @@ void __net_mp_close_rxq(struct net_device *dev, unsigned int ifq_idx,
 
 	rxq->mp_params.mp_ops = NULL;
 	rxq->mp_params.mp_priv = NULL;
-	err = netdev_rx_queue_restart(dev, ifq_idx);
+	err = netdev_rx_queue_restart(dev, ifq_idx, NULL);
 	WARN_ON(err && err != -ENETDOWN);
 }
 
-- 
2.49.0


