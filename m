Return-Path: <io-uring+bounces-9027-lists+io-uring=lfdr.de@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [147.75.80.249])
	by mail.lfdr.de (Postfix) with ESMTPS id 2022CB2A8C2
	for <lists+io-uring@lfdr.de>; Mon, 18 Aug 2025 16:08:56 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id 387A91BA6445
	for <lists+io-uring@lfdr.de>; Mon, 18 Aug 2025 14:01:12 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 948D03375A3;
	Mon, 18 Aug 2025 13:56:55 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="Tt/4X2r5"
X-Original-To: io-uring@vger.kernel.org
Received: from mail-wm1-f45.google.com (mail-wm1-f45.google.com [209.85.128.45])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 637F933470A;
	Mon, 18 Aug 2025 13:56:53 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.128.45
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1755525415; cv=none; b=g0AwK2U49B7hTCNYJGRySG+k9OHmQXj9hdSiPEg718+DrPrYJLloZP02A88xZjSvRd22qxdIgUenm5cjWj+UvbdDZ2vWHvYu0NxTiYHr/XayXzzD60fNvLXbCrTxu4nxP1qPtbdIEZeSVJx0/b4q9G87uX2nbyzwqGuM/AsObrU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1755525415; c=relaxed/simple;
	bh=a2tSau1Prgm8aMIUbNg2AY5nRr9zXWTwa7wmxAIG6Og=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=DLqc+oTt2sFLN5J2GB7EJdF6DYpH+j8Acxu85VlIP9SqnA2ltG18JCyNS1axCeAemIp3rT94AHsA0c0nkElEmeZSGYlGvqBL8jdN/5d+mNj82/hl3VV+5LgP/q11M2kXlgI9EIaSbV0FRIdx8rm5wwUrJp+Gl21vGDU6UAu0MbM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=Tt/4X2r5; arc=none smtp.client-ip=209.85.128.45
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Received: by mail-wm1-f45.google.com with SMTP id 5b1f17b1804b1-45a1abf5466so22817945e9.0;
        Mon, 18 Aug 2025 06:56:53 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1755525412; x=1756130212; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=qLOfpFL3Logct7nx+8SP8xfFgxsOuVroouEMrQa6oto=;
        b=Tt/4X2r5NssYpwrrbCxq2Eq/+TjHQa4N/o4lkI9vMGYElZ0fecVEYKJ5FItkIw/joG
         3J0Zff/v7HllNGvyTX0uxowrVff8R4i80dNfWnRX4Hvt0RykdgNMmtclpAAr4R/jJoZL
         p3Ix8LIA6rdF/5bz+r3Ys2ilb0Dx6HaSbEa+su6n9LSECBEVvSxAIfYFD1zPM3fmiMWa
         GttB2CgIY9M/WKL8CAvdLf11FRIbCJz5T++r0lJceVfjeLM8Di5bT0XXcyAJ/d6CmYFc
         1vRJNbYJgHIxhh5hEieSsaCaIHk2odVw9JgUR/782Jgsrz+Kn93+h7JnH8pZVsHQCcw3
         XsBQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1755525412; x=1756130212;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=qLOfpFL3Logct7nx+8SP8xfFgxsOuVroouEMrQa6oto=;
        b=hc7pTQPGYo+x+qHAj96aPHxzxan2qR1AyxkrZu1QXb1nOjklklVXNXBQlLqXPD6b9C
         pPZR/82+qU0+PgPUu3ius8uS3XBEzX8pWfMVJHCP9pPU4Sr1HrKBDWuscewx+Y1u4N2Q
         NhXg3DwIR0fWJHLDKZrRKLKWo6/EZWeGgCtNdTctFSP4uvINdjHDdufa85zYjZW0BFyj
         A8ZsyWxbtvK4mVD+3QYZjsoqO6wD0V6zImHwWKlDAjgUPEysp0BgI8y5ZmGpttgX7IPV
         H1SZTznY3waeWOAquqUXSQeu3wCxqKMji1gkXBBaAA/gNuMyNILDuZRVUU9ZnQM2fnEr
         k83A==
X-Forwarded-Encrypted: i=1; AJvYcCUJCx0XYjlz+TLEalhzhfEUwDrA9z1y03DtidfNf+wuXxjFmx0QoDvSPqIOdaqmnZ3vIP1qOv18SQ==@vger.kernel.org, AJvYcCWKajd3plYsY807lDTIEcDhF6sMd3MOh5dihxlaWKRfZ5pBK0JIYzOnApVlxNqmfGtvJN1KsFng@vger.kernel.org, AJvYcCWPHnsiLLOIFRIorenZJ7V3KScnq3iiWeiVAb3heg8s5Y+FCNhMJPXe9Ck3V05zLABqTcG7b3/taZL2yU3K@vger.kernel.org
X-Gm-Message-State: AOJu0Ywe0AYPorBjKBDQnoiJ0yYWXBSRJoY+dRJkzF79gFAhvBzQdQkJ
	SeWrSIE1QFDTiu2PgqeJCRTdLjBmcwnktbi28/g0zZoKQ5FprL/Umdvu
X-Gm-Gg: ASbGncu+VSa65/nAPg8KqY0qdV7e4O6X5wIJVbHii/5RIjNXspySOExrlqyGZkr5olJ
	dqc60oq6VUW1+bjLuDTB8g1ZCJnoFEaWth7ctkARZIT+MTN8v+9Nz2Vh+NrsUqP57G6oa73YsT8
	RCf6/akx+RQlIUWYb5Yl+ULqQjFhV+ZrXhSGcTXbHdPnlmIm9Hkj+WGFJplM4YJebz2AYJH5gUk
	2NlpHtAiOwQDRoJBpawK+Vnsvse7r33CW+QktdOAQcxZJSBehraUaXQGr0278ZbDRorh+gYWKPl
	0kPRIRYXqp/wjNkCwYBRTs2Zy/fdExnKXODK9ECF77got7dtQo7MylqnhVG/b7bJj/ht9lwJYBX
	JF5otT+NX6IeWFnMM+IzPspNzcEaFwodn2g==
X-Google-Smtp-Source: AGHT+IE8BX+hBP+7NWUwcL6iS6tM5ciblIDuThyWtpUiHHefNpdVM1pmakzwRM43MuTYi1L7SQczbg==
X-Received: by 2002:a05:600c:4ed0:b0:456:1146:5c01 with SMTP id 5b1f17b1804b1-45a1b6bde0bmr133335055e9.12.1755525411625;
        Mon, 18 Aug 2025 06:56:51 -0700 (PDT)
Received: from 127.0.0.1localhost ([185.69.144.43])
        by smtp.gmail.com with ESMTPSA id 5b1f17b1804b1-45a1b899338sm91187345e9.7.2025.08.18.06.56.50
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 18 Aug 2025 06:56:50 -0700 (PDT)
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
Subject: [PATCH net-next v3 12/23] net: allocate per-queue config structs and pass them thru the queue API
Date: Mon, 18 Aug 2025 14:57:28 +0100
Message-ID: <9a2571a308e1a2ac600bc23db4911c03fc923d11.1755499376.git.asml.silence@gmail.com>
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

Create an array of config structs to store per-queue config.
Pass these structs in the queue API. Drivers can also retrieve
the config for a single queue calling netdev_queue_config()
directly.

Signed-off-by: Jakub Kicinski <kuba@kernel.org>
[pavel: patch up mlx callbacks with unused qcfg]
Signed-off-by: Pavel Begunkov <asml.silence@gmail.com>
---
 drivers/net/ethernet/broadcom/bnxt/bnxt.c     |  8 ++-
 drivers/net/ethernet/google/gve/gve_main.c    |  9 ++-
 .../net/ethernet/mellanox/mlx5/core/en_main.c |  9 +--
 drivers/net/netdevsim/netdev.c                |  6 +-
 include/net/netdev_queues.h                   | 19 ++++++
 net/core/dev.h                                |  3 +
 net/core/netdev_config.c                      | 58 +++++++++++++++++++
 net/core/netdev_rx_queue.c                    | 11 +++-
 8 files changed, 109 insertions(+), 14 deletions(-)

diff --git a/drivers/net/ethernet/broadcom/bnxt/bnxt.c b/drivers/net/ethernet/broadcom/bnxt/bnxt.c
index d3d9b72ef313..48ff6f024e07 100644
--- a/drivers/net/ethernet/broadcom/bnxt/bnxt.c
+++ b/drivers/net/ethernet/broadcom/bnxt/bnxt.c
@@ -15824,7 +15824,9 @@ static const struct netdev_stat_ops bnxt_stat_ops = {
 	.get_base_stats		= bnxt_get_base_stats,
 };
 
-static int bnxt_queue_mem_alloc(struct net_device *dev, void *qmem, int idx)
+static int bnxt_queue_mem_alloc(struct net_device *dev,
+				struct netdev_queue_config *qcfg,
+				void *qmem, int idx)
 {
 	struct bnxt_rx_ring_info *rxr, *clone;
 	struct bnxt *bp = netdev_priv(dev);
@@ -15992,7 +15994,9 @@ static void bnxt_copy_rx_ring(struct bnxt *bp,
 	dst->rx_agg_bmap = src->rx_agg_bmap;
 }
 
-static int bnxt_queue_start(struct net_device *dev, void *qmem, int idx)
+static int bnxt_queue_start(struct net_device *dev,
+			    struct netdev_queue_config *qcfg,
+			    void *qmem, int idx)
 {
 	struct bnxt *bp = netdev_priv(dev);
 	struct bnxt_rx_ring_info *rxr, *clone;
diff --git a/drivers/net/ethernet/google/gve/gve_main.c b/drivers/net/ethernet/google/gve/gve_main.c
index 1f411d7c4373..f40edab616d8 100644
--- a/drivers/net/ethernet/google/gve/gve_main.c
+++ b/drivers/net/ethernet/google/gve/gve_main.c
@@ -2580,8 +2580,9 @@ static void gve_rx_queue_mem_free(struct net_device *dev, void *per_q_mem)
 		gve_rx_free_ring_dqo(priv, gve_per_q_mem, &cfg);
 }
 
-static int gve_rx_queue_mem_alloc(struct net_device *dev, void *per_q_mem,
-				  int idx)
+static int gve_rx_queue_mem_alloc(struct net_device *dev,
+				  struct netdev_queue_config *qcfg,
+				  void *per_q_mem, int idx)
 {
 	struct gve_priv *priv = netdev_priv(dev);
 	struct gve_rx_alloc_rings_cfg cfg = {0};
@@ -2602,7 +2603,9 @@ static int gve_rx_queue_mem_alloc(struct net_device *dev, void *per_q_mem,
 	return err;
 }
 
-static int gve_rx_queue_start(struct net_device *dev, void *per_q_mem, int idx)
+static int gve_rx_queue_start(struct net_device *dev,
+			      struct netdev_queue_config *qcfg,
+			      void *per_q_mem, int idx)
 {
 	struct gve_priv *priv = netdev_priv(dev);
 	struct gve_rx_ring *gve_per_q_mem;
diff --git a/drivers/net/ethernet/mellanox/mlx5/core/en_main.c b/drivers/net/ethernet/mellanox/mlx5/core/en_main.c
index 21bb88c5d3dc..83264c17a4f7 100644
--- a/drivers/net/ethernet/mellanox/mlx5/core/en_main.c
+++ b/drivers/net/ethernet/mellanox/mlx5/core/en_main.c
@@ -5541,8 +5541,9 @@ struct mlx5_qmgmt_data {
 	struct mlx5e_channel_param cparam;
 };
 
-static int mlx5e_queue_mem_alloc(struct net_device *dev, void *newq,
-				 int queue_index)
+static int mlx5e_queue_mem_alloc(struct net_device *dev,
+				 struct netdev_queue_config *qcfg,
+				 void *newq, int queue_index)
 {
 	struct mlx5_qmgmt_data *new = (struct mlx5_qmgmt_data *)newq;
 	struct mlx5e_priv *priv = netdev_priv(dev);
@@ -5603,8 +5604,8 @@ static int mlx5e_queue_stop(struct net_device *dev, void *oldq, int queue_index)
 	return 0;
 }
 
-static int mlx5e_queue_start(struct net_device *dev, void *newq,
-			     int queue_index)
+static int mlx5e_queue_start(struct net_device *dev, struct netdev_queue_config *qcfg,
+			     void *newq, int queue_index)
 {
 	struct mlx5_qmgmt_data *new = (struct mlx5_qmgmt_data *)newq;
 	struct mlx5e_priv *priv = netdev_priv(dev);
diff --git a/drivers/net/netdevsim/netdev.c b/drivers/net/netdevsim/netdev.c
index 0178219f0db5..985c3403ec57 100644
--- a/drivers/net/netdevsim/netdev.c
+++ b/drivers/net/netdevsim/netdev.c
@@ -733,7 +733,8 @@ struct nsim_queue_mem {
 };
 
 static int
-nsim_queue_mem_alloc(struct net_device *dev, void *per_queue_mem, int idx)
+nsim_queue_mem_alloc(struct net_device *dev, struct netdev_queue_config *qcfg,
+		     void *per_queue_mem, int idx)
 {
 	struct nsim_queue_mem *qmem = per_queue_mem;
 	struct netdevsim *ns = netdev_priv(dev);
@@ -782,7 +783,8 @@ static void nsim_queue_mem_free(struct net_device *dev, void *per_queue_mem)
 }
 
 static int
-nsim_queue_start(struct net_device *dev, void *per_queue_mem, int idx)
+nsim_queue_start(struct net_device *dev, struct netdev_queue_config *qcfg,
+		 void *per_queue_mem, int idx)
 {
 	struct nsim_queue_mem *qmem = per_queue_mem;
 	struct netdevsim *ns = netdev_priv(dev);
diff --git a/include/net/netdev_queues.h b/include/net/netdev_queues.h
index d73f9023c96f..b850cff71d12 100644
--- a/include/net/netdev_queues.h
+++ b/include/net/netdev_queues.h
@@ -32,6 +32,13 @@ struct netdev_config {
 	/** @hds_config: HDS enabled (ETHTOOL_A_RINGS_TCP_DATA_SPLIT).
 	 */
 	u8	hds_config;
+
+	/** @qcfg: per-queue configuration */
+	struct netdev_queue_config *qcfg;
+};
+
+/* Same semantics as fields in struct netdev_config */
+struct netdev_queue_config {
 };
 
 /* See the netdev.yaml spec for definition of each statistic */
@@ -136,6 +143,10 @@ void netdev_stat_queue_sum(struct net_device *netdev,
  *
  * @ndo_queue_mem_size: Size of the struct that describes a queue's memory.
  *
+ * @ndo_queue_cfg_defaults: (Optional) Populate queue config struct with
+ *			defaults. Queue config structs are passed to this
+ *			helper before the user-requested settings are applied.
+ *
  * @ndo_queue_mem_alloc: Allocate memory for an RX queue at the specified index.
  *			 The new memory is written at the specified address.
  *
@@ -153,12 +164,17 @@ void netdev_stat_queue_sum(struct net_device *netdev,
  */
 struct netdev_queue_mgmt_ops {
 	size_t	ndo_queue_mem_size;
+	void	(*ndo_queue_cfg_defaults)(struct net_device *dev,
+					  int idx,
+					  struct netdev_queue_config *qcfg);
 	int	(*ndo_queue_mem_alloc)(struct net_device *dev,
+				       struct netdev_queue_config *qcfg,
 				       void *per_queue_mem,
 				       int idx);
 	void	(*ndo_queue_mem_free)(struct net_device *dev,
 				      void *per_queue_mem);
 	int	(*ndo_queue_start)(struct net_device *dev,
+				   struct netdev_queue_config *qcfg,
 				   void *per_queue_mem,
 				   int idx);
 	int	(*ndo_queue_stop)(struct net_device *dev,
@@ -166,6 +182,9 @@ struct netdev_queue_mgmt_ops {
 				  int idx);
 };
 
+void netdev_queue_config(struct net_device *dev, int rxq,
+			 struct netdev_queue_config *qcfg);
+
 /**
  * DOC: Lockless queue stopping / waking helpers.
  *
diff --git a/net/core/dev.h b/net/core/dev.h
index 7041c8bd2a0f..a553a0f1f846 100644
--- a/net/core/dev.h
+++ b/net/core/dev.h
@@ -9,6 +9,7 @@
 #include <net/netdev_lock.h>
 
 struct net;
+struct netdev_queue_config;
 struct netlink_ext_ack;
 struct cpumask;
 
@@ -96,6 +97,8 @@ int netdev_alloc_config(struct net_device *dev);
 void __netdev_free_config(struct netdev_config *cfg);
 void netdev_free_config(struct net_device *dev);
 int netdev_reconfig_start(struct net_device *dev);
+void __netdev_queue_config(struct net_device *dev, int rxq,
+			   struct netdev_queue_config *qcfg, bool pending);
 
 /* netdev management, shared between various uAPI entry points */
 struct netdev_name_node {
diff --git a/net/core/netdev_config.c b/net/core/netdev_config.c
index 270b7f10a192..bad2d53522f0 100644
--- a/net/core/netdev_config.c
+++ b/net/core/netdev_config.c
@@ -8,18 +8,29 @@
 int netdev_alloc_config(struct net_device *dev)
 {
 	struct netdev_config *cfg;
+	unsigned int maxqs;
 
 	cfg = kzalloc(sizeof(*dev->cfg), GFP_KERNEL_ACCOUNT);
 	if (!cfg)
 		return -ENOMEM;
 
+	maxqs = max(dev->num_rx_queues, dev->num_tx_queues);
+	cfg->qcfg = kcalloc(maxqs, sizeof(*cfg->qcfg), GFP_KERNEL_ACCOUNT);
+	if (!cfg->qcfg)
+		goto err_free_cfg;
+
 	dev->cfg = cfg;
 	dev->cfg_pending = cfg;
 	return 0;
+
+err_free_cfg:
+	kfree(cfg);
+	return -ENOMEM;
 }
 
 void __netdev_free_config(struct netdev_config *cfg)
 {
+	kfree(cfg->qcfg);
 	kfree(cfg);
 }
 
@@ -32,12 +43,59 @@ void netdev_free_config(struct net_device *dev)
 int netdev_reconfig_start(struct net_device *dev)
 {
 	struct netdev_config *cfg;
+	unsigned int maxqs;
 
 	WARN_ON(dev->cfg != dev->cfg_pending);
 	cfg = kmemdup(dev->cfg, sizeof(*dev->cfg), GFP_KERNEL_ACCOUNT);
 	if (!cfg)
 		return -ENOMEM;
 
+	maxqs = max(dev->num_rx_queues, dev->num_tx_queues);
+	cfg->qcfg = kmemdup_array(dev->cfg->qcfg, maxqs, sizeof(*cfg->qcfg),
+				  GFP_KERNEL_ACCOUNT);
+	if (!cfg->qcfg)
+		goto err_free_cfg;
+
 	dev->cfg_pending = cfg;
 	return 0;
+
+err_free_cfg:
+	kfree(cfg);
+	return -ENOMEM;
+}
+
+void __netdev_queue_config(struct net_device *dev, int rxq,
+			   struct netdev_queue_config *qcfg, bool pending)
+{
+	memset(qcfg, 0, sizeof(*qcfg));
+
+	/* Get defaults from the driver, in case user config not set */
+	if (dev->queue_mgmt_ops->ndo_queue_cfg_defaults)
+		dev->queue_mgmt_ops->ndo_queue_cfg_defaults(dev, rxq, qcfg);
+}
+
+/**
+ * netdev_queue_config() - get configuration for a given queue
+ * @dev:  net_device instance
+ * @rxq:  index of the queue of interest
+ * @qcfg: queue configuration struct (output)
+ *
+ * Render the configuration for a given queue. This helper should be used
+ * by drivers which support queue configuration to retrieve config for
+ * a particular queue.
+ *
+ * @qcfg is an output parameter and is always fully initialized by this
+ * function. Some values may not be set by the user, drivers may either
+ * deal with the "unset" values in @qcfg, or provide the callback
+ * to populate defaults in queue_management_ops.
+ *
+ * Note that this helper returns pending config, as it is expected that
+ * "old" queues are retained until config is successful so they can
+ * be restored directly without asking for the config.
+ */
+void netdev_queue_config(struct net_device *dev, int rxq,
+			 struct netdev_queue_config *qcfg)
+{
+	__netdev_queue_config(dev, rxq, qcfg, true);
 }
+EXPORT_SYMBOL(netdev_queue_config);
diff --git a/net/core/netdev_rx_queue.c b/net/core/netdev_rx_queue.c
index 3bf1151d8061..fb87ce219a8a 100644
--- a/net/core/netdev_rx_queue.c
+++ b/net/core/netdev_rx_queue.c
@@ -7,12 +7,14 @@
 #include <net/netdev_rx_queue.h>
 #include <net/page_pool/memory_provider.h>
 
+#include "dev.h"
 #include "page_pool_priv.h"
 
 int netdev_rx_queue_restart(struct net_device *dev, unsigned int rxq_idx)
 {
 	struct netdev_rx_queue *rxq = __netif_get_rx_queue(dev, rxq_idx);
 	const struct netdev_queue_mgmt_ops *qops = dev->queue_mgmt_ops;
+	struct netdev_queue_config qcfg;
 	void *new_mem, *old_mem;
 	int err;
 
@@ -32,7 +34,9 @@ int netdev_rx_queue_restart(struct net_device *dev, unsigned int rxq_idx)
 		goto err_free_new_mem;
 	}
 
-	err = qops->ndo_queue_mem_alloc(dev, new_mem, rxq_idx);
+	netdev_queue_config(dev, rxq_idx, &qcfg);
+
+	err = qops->ndo_queue_mem_alloc(dev, &qcfg, new_mem, rxq_idx);
 	if (err)
 		goto err_free_old_mem;
 
@@ -45,7 +49,7 @@ int netdev_rx_queue_restart(struct net_device *dev, unsigned int rxq_idx)
 		if (err)
 			goto err_free_new_queue_mem;
 
-		err = qops->ndo_queue_start(dev, new_mem, rxq_idx);
+		err = qops->ndo_queue_start(dev, &qcfg, new_mem, rxq_idx);
 		if (err)
 			goto err_start_queue;
 	} else {
@@ -60,6 +64,7 @@ int netdev_rx_queue_restart(struct net_device *dev, unsigned int rxq_idx)
 	return 0;
 
 err_start_queue:
+	__netdev_queue_config(dev, rxq_idx, &qcfg, false);
 	/* Restarting the queue with old_mem should be successful as we haven't
 	 * changed any of the queue configuration, and there is not much we can
 	 * do to recover from a failure here.
@@ -67,7 +72,7 @@ int netdev_rx_queue_restart(struct net_device *dev, unsigned int rxq_idx)
 	 * WARN if we fail to recover the old rx queue, and at least free
 	 * old_mem so we don't also leak that.
 	 */
-	if (qops->ndo_queue_start(dev, old_mem, rxq_idx)) {
+	if (qops->ndo_queue_start(dev, &qcfg, old_mem, rxq_idx)) {
 		WARN(1,
 		     "Failed to restart old queue in error path. RX queue %d may be unhealthy.",
 		     rxq_idx);
-- 
2.49.0


