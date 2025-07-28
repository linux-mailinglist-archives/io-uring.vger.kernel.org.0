Return-Path: <io-uring+bounces-8824-lists+io-uring=lfdr.de@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [139.178.88.99])
	by mail.lfdr.de (Postfix) with ESMTPS id 715EDB1398C
	for <lists+io-uring@lfdr.de>; Mon, 28 Jul 2025 13:05:33 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id DBC9C3BDD0D
	for <lists+io-uring@lfdr.de>; Mon, 28 Jul 2025 11:04:11 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 87DD2262FFF;
	Mon, 28 Jul 2025 11:03:34 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="cWHRBM9V"
X-Original-To: io-uring@vger.kernel.org
Received: from mail-wr1-f52.google.com (mail-wr1-f52.google.com [209.85.221.52])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id BE246262FDD;
	Mon, 28 Jul 2025 11:03:32 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.221.52
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1753700614; cv=none; b=L4zDi7w+UgAwLm+OuUxD1HPgxAhTe0PP+Kqg7mWcMV1fyIapQFVmH1r7psGkQE3aTVKtgrWlQEiuRhHLOAYNCNLRJMRO83PVQ1YHcoU9iOByJwLbLy8BD5LoOkjkiA4mFKxK/MvqMR9w5NFbOkYcnnKPbF+DL4fZTlCoSNw0rt4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1753700614; c=relaxed/simple;
	bh=TktAd/tGJVHZMXR2/nBSYwzcH1Mr52cFonk3w9GQj14=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=j0zNLmXr9DocHTCA0WpqmZ4bmFBWLhLJaDcJoPg3opVXTWx4bJWn6/b9sEjUXud3tCvgIm3nFHGnOLt2rL7qG5FRlsx3HXkb8J6FmwJ9uUOsJc8ZXqLEwHy0GfB0nlV+5EtC192ffJUAf/gFt2sPhHnKfRtDwBH9LU62gr8U+fs=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=cWHRBM9V; arc=none smtp.client-ip=209.85.221.52
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Received: by mail-wr1-f52.google.com with SMTP id ffacd0b85a97d-3b7823559a5so780251f8f.0;
        Mon, 28 Jul 2025 04:03:32 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1753700611; x=1754305411; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=BtseTz3MzbAwOQFxhKIEKEjkp/IzqaUFUVPsgWJxw6w=;
        b=cWHRBM9V5oa2LL5VL553axDA8q2oSI9f/9LnvCbrjYwlUu9NW0nhrWwUGU9YqFHvza
         rHW9lRESQok358kjm1W1ElvbHAxS6LW5Vn6o8iSU/XLNVD+47zyv4a0OwSfDc4bzbG9h
         2UG0CLTdvrO8VXv3tdT7+s5O7G1+OigH7wr2JDu8RHpcEO3S2QujXli5lB4PcPIUdcAJ
         ayzrx2rN4+leHl+zPwTvTKE3GJ6UfIcWqtQ8nEwZNJgjAD7pUihUqu6pMXRvsV+6KQm3
         Ledtio6jGtmJioMDLjwEmC/dML7il5ifS8gSpi6ZLKZt2W1nrX0iHqXq3QYOx3h+Zjzb
         Zakw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1753700611; x=1754305411;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=BtseTz3MzbAwOQFxhKIEKEjkp/IzqaUFUVPsgWJxw6w=;
        b=dRFOlsDmkvrMYpzGJ87XA+wCQb3sb5Za30/hAaqAhLApAVJX0tNDTvCHC7b21BHAUI
         DEOq8ccCaZyivWJz4N2kSEmWRC6QLHBylnlREs5OIaip1DP9vUcbRiUkvZrpibKRYUxo
         CMt4Vg0zBrzfYRqs8pmEa6WaM8p0Nd9N/aB++h0w8JXI2Dh9SG0X+6lQqtcJlASJMUIj
         QprffihPHeArbYYQ9z2b1hfyh4wSxJYCO8QJN1mg1/QYO4KzVbl+bmWrxKqHjZVOx0UO
         XldTkiWS6aVkVxG3/IIDz0wKfO1hejqIJWIXjA/uZC7FQCnRwRxsi+VsmTDzvwkEs2mv
         i7JQ==
X-Forwarded-Encrypted: i=1; AJvYcCW787qpad4DlCQkHwDnieerwos2HkXtOFFL2liGE7J74gHHDBc+i4wEofh05vHz9d4G94K8UlAf9g==@vger.kernel.org, AJvYcCWreF+PeZfgC3JBXxd4Tm2zSYH5/Njl03Xa4x5j1yYR0arMvgGmD4tDT6ZPDZ22Wi3vxAY40GRP@vger.kernel.org
X-Gm-Message-State: AOJu0YwpMfVxvOyitwswQjs003tsXuPlDf9cdNug1sdbQ1RBKO02WtDa
	auM8/XvsMR1igTX6QgT0tg4OZbqEwIt1yFLTvPu2HpTqNXgpEImeLkLa+/vqCw==
X-Gm-Gg: ASbGnctnJRa6CgiRTzIJuj6J4DrmI7EDhxgTXTETjMlf2kO9V1D1JY8jXoa5EfngVJ9
	RVPn9DVAnwdc/UVqILdbvfbCHJpiKIQiOqs7mylnE/W8G9ZRiANdv8WPo9gfDfxZPFoSXhGgD/c
	xOZfM99F/mv71aJYS7FfM0i8tJ1zz84Ds17PeG3nafnCAOTieakeECXDsxTzMR9nzjvnM4nxsVg
	rw0xsYI1MoQMuUsGzTZUiA73MSiimBjiPUGq8GAC/B18OAajgbmsjDeV/Wq8huo85WzxQjaekOR
	Jp7ROxh9mlYIEIwI6FHByhGWHnRRQ/EUYSmMussTVuEaclR3dwl5Eow8ttmPIVmsPe/8X6SgLzs
	JHh83P0wqoFRf+Q==
X-Google-Smtp-Source: AGHT+IEZCxVgoCxIxxNK6Mt1glprNLOiGC91+UX5brCfjXoEBCbo+/wffvQCK1zoZV2qCVV0vMowCA==
X-Received: by 2002:a05:6000:2288:b0:3aa:34f4:d437 with SMTP id ffacd0b85a97d-3b77675bd71mr6292540f8f.37.1753700610744;
        Mon, 28 Jul 2025 04:03:30 -0700 (PDT)
Received: from 127.com ([2620:10d:c092:600::1:75])
        by smtp.gmail.com with ESMTPSA id 5b1f17b1804b1-458705c4fdasm157410235e9.28.2025.07.28.04.03.29
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 28 Jul 2025 04:03:29 -0700 (PDT)
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
Subject: [RFC v1 13/22] net: add queue config validation callback
Date: Mon, 28 Jul 2025 12:04:17 +0100
Message-ID: <afd04f9bc1611bb16152021c161624f43f6b5a22.1753694914.git.asml.silence@gmail.com>
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

I imagine (tm) that as the number of per-queue configuration
options grows some of them may conflict for certain drivers.
While the drivers can obviously do all the validation locally
doing so is fairly inconvenient as the config is fed to drivers
piecemeal via different ops (for different params and NIC-wide
vs per-queue).

Add a centralized callback for validating the queue config
in queue ops. The callback gets invoked before each queue restart
and when ring params are modified.

For NIC-wide changes the callback gets invoked for each active
(or active to-be) queue, and additionally with a negative queue
index for NIC-wide defaults. The NIC-wide check is needed in
case all queues have an override active when NIC-wide setting
is changed to an unsupported one. Alternatively we could check
the settings when new queues are enabled (in the channel API),
but accepting invalid config is a bad idea. Users may expect
that resetting a queue override will always work.

The "trick" of passing a negative index is a bit ugly, we may
want to revisit if it causes confusion and bugs. Existing drivers
don't care about the index so it "just works".

Signed-off-by: Jakub Kicinski <kuba@kernel.org>
Signed-off-by: Pavel Begunkov <asml.silence@gmail.com>
---
 include/net/netdev_queues.h | 12 ++++++++++++
 net/core/dev.h              |  2 ++
 net/core/netdev_config.c    | 20 ++++++++++++++++++++
 net/core/netdev_rx_queue.c  |  6 ++++++
 net/ethtool/rings.c         |  5 +++++
 5 files changed, 45 insertions(+)

diff --git a/include/net/netdev_queues.h b/include/net/netdev_queues.h
index e3e7ecf91bac..f75313fc78ba 100644
--- a/include/net/netdev_queues.h
+++ b/include/net/netdev_queues.h
@@ -146,6 +146,14 @@ void netdev_stat_queue_sum(struct net_device *netdev,
  *			defaults. Queue config structs are passed to this
  *			helper before the user-requested settings are applied.
  *
+ * @ndo_queue_cfg_validate: (Optional) Check if queue config is supported.
+ *			Called when configuration affecting a queue may be
+ *			changing, either due to NIC-wide config, or config
+ *			scoped to the queue at a specified index.
+ *			When NIC-wide config is changed the callback will
+ *			be invoked for all queues, and in addition to that
+ *			with a negative queue index for the base settings.
+ *
  * @ndo_queue_mem_alloc: Allocate memory for an RX queue at the specified index.
  *			 The new memory is written at the specified address.
  *
@@ -166,6 +174,10 @@ struct netdev_queue_mgmt_ops {
 	void	(*ndo_queue_cfg_defaults)(struct net_device *dev,
 					  int idx,
 					  struct netdev_queue_config *qcfg);
+	int	(*ndo_queue_cfg_validate)(struct net_device *dev,
+					  int idx,
+					  struct netdev_queue_config *qcfg,
+					  struct netlink_ext_ack *extack);
 	int	(*ndo_queue_mem_alloc)(struct net_device *dev,
 				       struct netdev_queue_config *qcfg,
 				       void *per_queue_mem,
diff --git a/net/core/dev.h b/net/core/dev.h
index 6d7f5e920018..e0d433fb6325 100644
--- a/net/core/dev.h
+++ b/net/core/dev.h
@@ -99,6 +99,8 @@ void netdev_free_config(struct net_device *dev);
 int netdev_reconfig_start(struct net_device *dev);
 void __netdev_queue_config(struct net_device *dev, int rxq,
 			   struct netdev_queue_config *qcfg, bool pending);
+int netdev_queue_config_revalidate(struct net_device *dev,
+				   struct netlink_ext_ack *extack);
 
 /* netdev management, shared between various uAPI entry points */
 struct netdev_name_node {
diff --git a/net/core/netdev_config.c b/net/core/netdev_config.c
index bad2d53522f0..fc700b77e4eb 100644
--- a/net/core/netdev_config.c
+++ b/net/core/netdev_config.c
@@ -99,3 +99,23 @@ void netdev_queue_config(struct net_device *dev, int rxq,
 	__netdev_queue_config(dev, rxq, qcfg, true);
 }
 EXPORT_SYMBOL(netdev_queue_config);
+
+int netdev_queue_config_revalidate(struct net_device *dev,
+				   struct netlink_ext_ack *extack)
+{
+	const struct netdev_queue_mgmt_ops *qops = dev->queue_mgmt_ops;
+	struct netdev_queue_config qcfg;
+	int i, err;
+
+	if (!qops || !qops->ndo_queue_cfg_validate)
+		return 0;
+
+	for (i = -1; i < (int)dev->real_num_rx_queues; i++) {
+		netdev_queue_config(dev, i, &qcfg);
+		err = qops->ndo_queue_cfg_validate(dev, i, &qcfg, extack);
+		if (err)
+			return err;
+	}
+
+	return 0;
+}
diff --git a/net/core/netdev_rx_queue.c b/net/core/netdev_rx_queue.c
index b0523eb44e10..7c691eb1a48b 100644
--- a/net/core/netdev_rx_queue.c
+++ b/net/core/netdev_rx_queue.c
@@ -37,6 +37,12 @@ int netdev_rx_queue_restart(struct net_device *dev, unsigned int rxq_idx,
 
 	netdev_queue_config(dev, rxq_idx, &qcfg);
 
+	if (qops->ndo_queue_cfg_validate) {
+		err = qops->ndo_queue_cfg_validate(dev, rxq_idx, &qcfg, extack);
+		if (err)
+			goto err_free_old_mem;
+	}
+
 	err = qops->ndo_queue_mem_alloc(dev, &qcfg, new_mem, rxq_idx);
 	if (err)
 		goto err_free_old_mem;
diff --git a/net/ethtool/rings.c b/net/ethtool/rings.c
index 6a74e7e4064e..7884d10c090f 100644
--- a/net/ethtool/rings.c
+++ b/net/ethtool/rings.c
@@ -4,6 +4,7 @@
 
 #include "netlink.h"
 #include "common.h"
+#include "../core/dev.h"
 
 struct rings_req_info {
 	struct ethnl_req_info		base;
@@ -307,6 +308,10 @@ ethnl_set_rings(struct ethnl_req_info *req_info, struct genl_info *info)
 	dev->cfg_pending->hds_config = kernel_ringparam.tcp_data_split;
 	dev->cfg_pending->hds_thresh = kernel_ringparam.hds_thresh;
 
+	ret = netdev_queue_config_revalidate(dev, info->extack);
+	if (ret)
+		return ret;
+
 	ret = dev->ethtool_ops->set_ringparam(dev, &ringparam,
 					      &kernel_ringparam, info->extack);
 	return ret < 0 ? ret : 1;
-- 
2.49.0


