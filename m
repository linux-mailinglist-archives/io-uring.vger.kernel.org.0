Return-Path: <io-uring+bounces-8822-lists+io-uring=lfdr.de@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [IPv6:2604:1380:4601:e00::3])
	by mail.lfdr.de (Postfix) with ESMTPS id 613C4B1398D
	for <lists+io-uring@lfdr.de>; Mon, 28 Jul 2025 13:05:46 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id 156A6188553E
	for <lists+io-uring@lfdr.de>; Mon, 28 Jul 2025 11:04:47 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id BD04325B2FA;
	Mon, 28 Jul 2025 11:03:31 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="MfZwhQ2q"
X-Original-To: io-uring@vger.kernel.org
Received: from mail-wm1-f50.google.com (mail-wm1-f50.google.com [209.85.128.50])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 97C022620E9;
	Mon, 28 Jul 2025 11:03:29 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.128.50
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1753700611; cv=none; b=YllbZ8ErbnNvbaR5mpd7EznOnjm74kE2jxKvktBnBV1hSkJo+Bs5Fhq29k0pA94OB2/IsQ6PPphcpdBQcDxmqqB2YDr7M9yIue50O0rbVd+QcrNxpe0HE2Bb576Z198fGKDsjA0zA8oU49mis8Nrmrnl6DmjEvhWhQ+PLoHVBUk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1753700611; c=relaxed/simple;
	bh=5ZWvB2uU+mCs05H7DXw4AzZXTuS3wiYVljhyM65pOZo=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=hzTkg3wGR54qjWZEoORpd21gJqYju8BU5R7qfJ67Y44QxEc9YssGF9lSkqbcTVw/aTfMJadie2qMjnS1Eg/7ov2rOOzxLSJ9/lkLKGFFpMnNLk88Y/fPjLT8L6Piq5c3HXS2wTOBpLNBuu2551dGep+gT7mVTHXwNYZ0ck+c9So=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=MfZwhQ2q; arc=none smtp.client-ip=209.85.128.50
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Received: by mail-wm1-f50.google.com with SMTP id 5b1f17b1804b1-45629703011so29803425e9.0;
        Mon, 28 Jul 2025 04:03:29 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1753700608; x=1754305408; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=Qpr6c6tHtDpUj7cDBjlWEsWjMpSMTQI+BTTKoTompxU=;
        b=MfZwhQ2qcwNdzga8Eo3GfikeNpoe2DNCw4b+T+FxaIbI5xNEJMefDPASNPI13ZzrZd
         5CPnfphqEYh/X00nKFGLiwrwyS+U5hDIEVuvwIyc/w0pDwKUQCW6BLWjHlOJB64zcQYL
         hlYb7B73vfPI5aC/sYxq0P2JJL7NCRFPLFnf7sh9K4jjJpBQURWC5kvxZTHxqg3skD2R
         bDis/j2zHHQ1G++rx6syy9d7XU2U+VOGshw9sHKWb7k2RemADVCAI9SeDp1H2sifIgMf
         EqBnPonJLJajitI3tfbp3x7kUZLc83+l4Fta3+osvHP5KLpMfqhkScFwsX1pmO9KrJfe
         0jvw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1753700608; x=1754305408;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=Qpr6c6tHtDpUj7cDBjlWEsWjMpSMTQI+BTTKoTompxU=;
        b=DnZXD/FFeQWghUQKJSvbb8Xchve0V6QdD3z0YduXo7QPuzlmjKm+PStu3k2a/2SqYR
         Uh/3E4Q28fhKRo0QW/i7ZUpSr/U6zAi9xjTmsX2/qLQC5l3qkV0wgNqyGpTk+dx6lDzq
         vpxpWBCV6uh/v/CLbo/pjNaWGGlOsWd/IiE6+0bnOAR7OdBb1fe0wl/l4B0znFXqULZp
         fd5PPmgVLW337h6kKDa34Cd1c7nJgShNOh6vaRwc1CvbjC4lIt5lX9wizK6IqlWFiuAd
         IGOFoOHeRXahzf0XGg7VSH7kY20Ln7kjQmhbuc/OgxqosO/QyeqkMmLf0AuoYNe3b9b/
         tJWg==
X-Forwarded-Encrypted: i=1; AJvYcCU4qB1qbq5VdjYrg4UCSZFKHcbGx+vmq7+vCnRclkmMFKzQsU3L+Cgwq4waOGiv+ELCLTki7al6@vger.kernel.org, AJvYcCVe5Y8Zbm+yoyFufVLcrTtrCUWdTYJvndzjK7Ro7eN1Fjl+sCD0Y1nb6D4V4JUHLl5oX5j2fBn8lA==@vger.kernel.org
X-Gm-Message-State: AOJu0Yx64UYYNuyP0lPPoBhte7dT444pFB5Frzu91Iq3VwblRfuCBrcN
	1vjFRzc6o7Is7cXLhEEjwxvgwqVcQT5ZyxE4fE4PPgmuDvLxETIcCOQa
X-Gm-Gg: ASbGncskpfUjq1mbo/Tn6OeCzuquDPutOkJxGdUaPvwslGi6GMkzI2dfD1PW7+LQAOB
	CGOQZ+CHlsZlB7A6SOv4pR7isouFRKVf9mTRSN67FMqxcl7+b++3zqHW+LmEXIc0V9ol4niJOoF
	tpbjam6DjYD6VmxGJOo+9/u2C4SxFKz6DDJQgs1GrrQzfKVALFowZkUz2x8CRi+Bs3jlD1isGiH
	07e7YWV6IU5Y+DHbg9+DbLQgscZ2FMpG+kEySDAsQ/7+2WEA2DDPb0I3Pp0VagLHmOmOkaMuWqY
	lFAsVr9WKFfT30BKjrdcyPF/F+cDOgRoj6GciwOvVrItHSoNaKsxXkv9qLrz21J2HVmMItnOfHa
	Zz4M=
X-Google-Smtp-Source: AGHT+IFfSSxkWqPN4XbmYu5KdebBwGq5xZZkqMueKkOJGkVetjEpVYVlNWikon7adoc4ieRKyCVlYw==
X-Received: by 2002:a05:600c:8283:b0:455:bd8a:7e7 with SMTP id 5b1f17b1804b1-458763127a4mr103960115e9.9.1753700607677;
        Mon, 28 Jul 2025 04:03:27 -0700 (PDT)
Received: from 127.com ([2620:10d:c092:600::1:75])
        by smtp.gmail.com with ESMTPSA id 5b1f17b1804b1-458705c4fdasm157410235e9.28.2025.07.28.04.03.26
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 28 Jul 2025 04:03:26 -0700 (PDT)
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
Subject: [RFC v1 11/22] net: allocate per-queue config structs and pass them thru the queue API
Date: Mon, 28 Jul 2025 12:04:15 +0100
Message-ID: <4eab05f74ac798f8035a64174ccf404048fe748d.1753694913.git.asml.silence@gmail.com>
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

From: Jakub Kicinski <kuba@kernel.org>

Create an array of config structs to store per-queue config.
Pass these structs in the queue API. Drivers can also retrieve
the config for a single queue calling netdev_queue_config()
directly.

Signed-off-by: Jakub Kicinski <kuba@kernel.org>
Signed-off-by: Pavel Begunkov <asml.silence@gmail.com>
---
 drivers/net/ethernet/broadcom/bnxt/bnxt.c  |  8 ++-
 drivers/net/ethernet/google/gve/gve_main.c |  9 ++--
 drivers/net/netdevsim/netdev.c             |  6 ++-
 include/net/netdev_queues.h                | 19 +++++++
 net/core/dev.h                             |  3 ++
 net/core/netdev_config.c                   | 58 ++++++++++++++++++++++
 net/core/netdev_rx_queue.c                 | 11 ++--
 7 files changed, 104 insertions(+), 10 deletions(-)

diff --git a/drivers/net/ethernet/broadcom/bnxt/bnxt.c b/drivers/net/ethernet/broadcom/bnxt/bnxt.c
index 55685ed60519..c3195be0ac26 100644
--- a/drivers/net/ethernet/broadcom/bnxt/bnxt.c
+++ b/drivers/net/ethernet/broadcom/bnxt/bnxt.c
@@ -15820,7 +15820,9 @@ static const struct netdev_stat_ops bnxt_stat_ops = {
 	.get_base_stats		= bnxt_get_base_stats,
 };
 
-static int bnxt_queue_mem_alloc(struct net_device *dev, void *qmem, int idx)
+static int bnxt_queue_mem_alloc(struct net_device *dev,
+				struct netdev_queue_config *qcfg,
+				void *qmem, int idx)
 {
 	struct bnxt_rx_ring_info *rxr, *clone;
 	struct bnxt *bp = netdev_priv(dev);
@@ -15988,7 +15990,9 @@ static void bnxt_copy_rx_ring(struct bnxt *bp,
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
index dc35a23ec47f..dffe3ebc456b 100644
--- a/drivers/net/ethernet/google/gve/gve_main.c
+++ b/drivers/net/ethernet/google/gve/gve_main.c
@@ -2429,8 +2429,9 @@ static void gve_rx_queue_mem_free(struct net_device *dev, void *per_q_mem)
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
@@ -2451,7 +2452,9 @@ static int gve_rx_queue_mem_alloc(struct net_device *dev, void *per_q_mem,
 	return err;
 }
 
-static int gve_rx_queue_start(struct net_device *dev, void *per_q_mem, int idx)
+static int gve_rx_queue_start(struct net_device *dev,
+			      struct netdev_queue_config *qcfg,
+			      void *per_q_mem, int idx)
 {
 	struct gve_priv *priv = netdev_priv(dev);
 	struct gve_rx_ring *gve_per_q_mem;
diff --git a/drivers/net/netdevsim/netdev.c b/drivers/net/netdevsim/netdev.c
index fa5fbd97ad69..03003adc41fb 100644
--- a/drivers/net/netdevsim/netdev.c
+++ b/drivers/net/netdevsim/netdev.c
@@ -664,7 +664,8 @@ struct nsim_queue_mem {
 };
 
 static int
-nsim_queue_mem_alloc(struct net_device *dev, void *per_queue_mem, int idx)
+nsim_queue_mem_alloc(struct net_device *dev, struct netdev_queue_config *qcfg,
+		     void *per_queue_mem, int idx)
 {
 	struct nsim_queue_mem *qmem = per_queue_mem;
 	struct netdevsim *ns = netdev_priv(dev);
@@ -713,7 +714,8 @@ static void nsim_queue_mem_free(struct net_device *dev, void *per_queue_mem)
 }
 
 static int
-nsim_queue_start(struct net_device *dev, void *per_queue_mem, int idx)
+nsim_queue_start(struct net_device *dev, struct netdev_queue_config *qcfg,
+		 void *per_queue_mem, int idx)
 {
 	struct nsim_queue_mem *qmem = per_queue_mem;
 	struct netdevsim *ns = netdev_priv(dev);
diff --git a/include/net/netdev_queues.h b/include/net/netdev_queues.h
index 070a1150241d..e3e7ecf91bac 100644
--- a/include/net/netdev_queues.h
+++ b/include/net/netdev_queues.h
@@ -31,6 +31,13 @@ struct netdev_config {
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
@@ -135,6 +142,10 @@ void netdev_stat_queue_sum(struct net_device *netdev,
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
@@ -152,12 +163,17 @@ void netdev_stat_queue_sum(struct net_device *netdev,
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
@@ -165,6 +181,9 @@ struct netdev_queue_mgmt_ops {
 				  int idx);
 };
 
+void netdev_queue_config(struct net_device *dev, int rxq,
+			 struct netdev_queue_config *qcfg);
+
 /**
  * DOC: Lockless queue stopping / waking helpers.
  *
diff --git a/net/core/dev.h b/net/core/dev.h
index c8971c6f1fcd..6d7f5e920018 100644
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
index d126f10197bf..d8a710db21cd 100644
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


