Return-Path: <io-uring+bounces-8820-lists+io-uring=lfdr.de@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [147.75.80.249])
	by mail.lfdr.de (Postfix) with ESMTPS id DC92EB13986
	for <lists+io-uring@lfdr.de>; Mon, 28 Jul 2025 13:05:09 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id 99B091884221
	for <lists+io-uring@lfdr.de>; Mon, 28 Jul 2025 11:04:34 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 2393F26158B;
	Mon, 28 Jul 2025 11:03:28 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="Vg5XMMUp"
X-Original-To: io-uring@vger.kernel.org
Received: from mail-wm1-f43.google.com (mail-wm1-f43.google.com [209.85.128.43])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 67D6F19AD70;
	Mon, 28 Jul 2025 11:03:26 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.128.43
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1753700608; cv=none; b=MwckPOWJbaeSVisLkZBLW/6RaA+pm4At+2h3TEbsshzUn9aYo9vGj3Ld7rSTNwat7oNvZsPFVhz99LGo0VVREKtGKW8CqAxPNJUROcAPuhkaLcX7bS1CwskgR6iVaDwPY3dz6Ld5TU9lazfgdGfnUWHMoo4JwLt/4ZPuSRxiitk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1753700608; c=relaxed/simple;
	bh=BgRPM6OXIcOO36g3loJUK4tBZzs7WWA8o08CMx74vV4=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=gyocSexI7Ffx/bKeM6W/ZxCsmjca09wHWb4oyW5CVck2KnrmbGFwNrsvv6G3jkj0WvuqaM4sjP8u+BvW3fH6v8WlUlXiIdOD6b75LLpSzZNCA4DpAlzZnAPDZ3aoNZGQZ3eIrSz+uAqZxcr3GK2BRKl7nLeY3DoyEL6dRxbxj20=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=Vg5XMMUp; arc=none smtp.client-ip=209.85.128.43
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Received: by mail-wm1-f43.google.com with SMTP id 5b1f17b1804b1-451d6ade159so29299675e9.1;
        Mon, 28 Jul 2025 04:03:26 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1753700605; x=1754305405; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=xAgVBUepJQj3kJVlz/4Xdnuk9T7SGwghvju4eo2dsts=;
        b=Vg5XMMUpZNgCJILU1YorJwXss/rbEs0z/jvEBhmjIO4zTAKzAna3w+Jhzh00j1w0iO
         t/hgfC28LAjSrA/bXh6GSA3TxhkDaVMybzr2HraAkuMtQtdMNxK9Q3aT1tvhHDiYy5Kf
         0IJ/f9uD0+YDVzsFIcMZSX5RAFGfPBNNzeYCbXPsGN66gZW+Z3lCaZmNY9r7PoHhMlvJ
         guOIGMgjkICzmJXTedgenb/wpnT/wql/ioMhPRocdFVKox8bNUO3HXzamN/7FK52degD
         60r/bKA2mXc4IvkYBhO9PhakQY65SUHBNBUSd5ngT45yRxf9nYpLgpDkSUrgwqCw+eak
         QkCg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1753700605; x=1754305405;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=xAgVBUepJQj3kJVlz/4Xdnuk9T7SGwghvju4eo2dsts=;
        b=Glup5oX7ca5Yf35oEJEiz5igKqMmi+2ERQfA5Fvtfh5FRCAfdVph6g61d4HtNEQdy5
         voBMeCg5arbBiu29/dqSbru11whaOsy7TPRM5F02KK0av2gnNBDNoYziOrXOG+D1Odbf
         QLVyQnhF4tp1IBmm7T9PW1HGAEfoy7oJ9xBVfbuVSxSQrNYM7I2/CRR7SfN4zDfHU+UV
         gpR/ZaH3hBh8bFl7Hf5VpHr6dWMPpEePxf/i7bGayWF5tVaqpPPWuGyBdfee2OqZeaN0
         FfBSRHIrLsN1VbBDLCQYlbopOPbh9epm2nrqFiexTzla1CWaUY49MbYTGl7CxsBxBP5b
         Vnjg==
X-Forwarded-Encrypted: i=1; AJvYcCVB9SfJI1IjNWds527inlMZuX+DryC+1B+Qqwzm33ul2JJmTSWq0GX5ek60tmXG/qIL8BFxfzJa@vger.kernel.org, AJvYcCXlDPlXJvWOCcTSsPRxetvQPbOHKGTOTwuv9xpJ/oRxjP+ZPqkNgx6T0XI8PtkPczunbN9pWgSJtQ==@vger.kernel.org
X-Gm-Message-State: AOJu0YwmllRHUgcwiBh8ee0B3U2S7yjCQpafqysveRIw/AL0hgrnorF5
	BcztJYwb0IlPOKec8YtLOVibbWjchlgt3sQY0jPXX0qYxu4a7kSDyGA6hmNAOQ==
X-Gm-Gg: ASbGncu2R2JCNOXabhw7dy3Ko4aZTOyUZbPMl/PoIXwdszHkcdAjNOu3tzxrHqpT/21
	xrj67l1VyUMm6JgaXMsbnxzhZwfZlatdxnIodo80yMjaLkaiWsAR8zpoYfJYTcTJ9nw3k6iScf+
	Xjhdc51tXAZLGchOUWTSZg/NOVbda3p6CX8o1KoJ27mSIp/6Bunqpp5GUIDs49JFQlfUr0EpURL
	Gkvl4sjM3y6sw/50q0fSM9PuJwNuhk12tiTGUBT5+1zzR5BF4ASiusLP6jHVoM/0qS8Klb7XpKg
	hy8QctCTyUttLJeo0vJkPc2whAJGk1ncPl24+Vx1wm4z2VSl1RtbgAYQcYUWjIVSyMkAu6BPFUH
	i4uQ=
X-Google-Smtp-Source: AGHT+IGrUWL+I3ZNKp0ipB6QcHyHeOunmal4DWlagBLcCsZgjjYcrKeiQhydp5EmkBf63hEE0PKrgA==
X-Received: by 2002:a05:600c:1d1e:b0:456:3b21:ad1e with SMTP id 5b1f17b1804b1-45876442799mr100942515e9.17.1753700604566;
        Mon, 28 Jul 2025 04:03:24 -0700 (PDT)
Received: from 127.com ([2620:10d:c092:600::1:75])
        by smtp.gmail.com with ESMTPSA id 5b1f17b1804b1-458705c4fdasm157410235e9.28.2025.07.28.04.03.23
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 28 Jul 2025 04:03:23 -0700 (PDT)
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
Subject: [RFC v1 09/22] net: move netdev_config manipulation to dedicated helpers
Date: Mon, 28 Jul 2025 12:04:13 +0100
Message-ID: <fbd14f401e7b4a18c43d15e0b87c80d5f0382f5b.1753694913.git.asml.silence@gmail.com>
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

netdev_config manipulation will become slightly more complicated
soon and we will need to call if from ethtool as well as queue API.
Encapsulate the logic into helper functions.

Signed-off-by: Jakub Kicinski <kuba@kernel.org>
Signed-off-by: Pavel Begunkov <asml.silence@gmail.com>
---
 net/core/Makefile        |  2 +-
 net/core/dev.c           |  7 ++-----
 net/core/dev.h           |  5 +++++
 net/core/netdev_config.c | 43 ++++++++++++++++++++++++++++++++++++++++
 net/ethtool/netlink.c    | 14 ++++++-------
 5 files changed, 57 insertions(+), 14 deletions(-)
 create mode 100644 net/core/netdev_config.c

diff --git a/net/core/Makefile b/net/core/Makefile
index b2a76ce33932..4db487396094 100644
--- a/net/core/Makefile
+++ b/net/core/Makefile
@@ -19,7 +19,7 @@ obj-$(CONFIG_NETDEV_ADDR_LIST_TEST) += dev_addr_lists_test.o
 
 obj-y += net-sysfs.o
 obj-y += hotdata.o
-obj-y += netdev_rx_queue.o
+obj-y += netdev_config.o netdev_rx_queue.o
 obj-$(CONFIG_PAGE_POOL) += page_pool.o page_pool_user.o
 obj-$(CONFIG_PROC_FS) += net-procfs.o
 obj-$(CONFIG_NET_PKTGEN) += pktgen.o
diff --git a/net/core/dev.c b/net/core/dev.c
index be97c440ecd5..757fa06d7392 100644
--- a/net/core/dev.c
+++ b/net/core/dev.c
@@ -11784,10 +11784,8 @@ struct net_device *alloc_netdev_mqs(int sizeof_priv, const char *name,
 	if (!dev->ethtool)
 		goto free_all;
 
-	dev->cfg = kzalloc(sizeof(*dev->cfg), GFP_KERNEL_ACCOUNT);
-	if (!dev->cfg)
+	if (netdev_alloc_config(dev))
 		goto free_all;
-	dev->cfg_pending = dev->cfg;
 
 	napi_config_sz = array_size(maxqs, sizeof(*dev->napi_config));
 	dev->napi_config = kvzalloc(napi_config_sz, GFP_KERNEL_ACCOUNT);
@@ -11857,8 +11855,7 @@ void free_netdev(struct net_device *dev)
 		return;
 	}
 
-	WARN_ON(dev->cfg != dev->cfg_pending);
-	kfree(dev->cfg);
+	netdev_free_config(dev);
 	kfree(dev->ethtool);
 	netif_free_tx_queues(dev);
 	netif_free_rx_queues(dev);
diff --git a/net/core/dev.h b/net/core/dev.h
index e93f36b7ddf3..c8971c6f1fcd 100644
--- a/net/core/dev.h
+++ b/net/core/dev.h
@@ -92,6 +92,11 @@ extern struct rw_semaphore dev_addr_sem;
 extern struct list_head net_todo_list;
 void netdev_run_todo(void);
 
+int netdev_alloc_config(struct net_device *dev);
+void __netdev_free_config(struct netdev_config *cfg);
+void netdev_free_config(struct net_device *dev);
+int netdev_reconfig_start(struct net_device *dev);
+
 /* netdev management, shared between various uAPI entry points */
 struct netdev_name_node {
 	struct hlist_node hlist;
diff --git a/net/core/netdev_config.c b/net/core/netdev_config.c
new file mode 100644
index 000000000000..270b7f10a192
--- /dev/null
+++ b/net/core/netdev_config.c
@@ -0,0 +1,43 @@
+// SPDX-License-Identifier: GPL-2.0-only
+
+#include <linux/netdevice.h>
+#include <net/netdev_queues.h>
+
+#include "dev.h"
+
+int netdev_alloc_config(struct net_device *dev)
+{
+	struct netdev_config *cfg;
+
+	cfg = kzalloc(sizeof(*dev->cfg), GFP_KERNEL_ACCOUNT);
+	if (!cfg)
+		return -ENOMEM;
+
+	dev->cfg = cfg;
+	dev->cfg_pending = cfg;
+	return 0;
+}
+
+void __netdev_free_config(struct netdev_config *cfg)
+{
+	kfree(cfg);
+}
+
+void netdev_free_config(struct net_device *dev)
+{
+	WARN_ON(dev->cfg != dev->cfg_pending);
+	__netdev_free_config(dev->cfg);
+}
+
+int netdev_reconfig_start(struct net_device *dev)
+{
+	struct netdev_config *cfg;
+
+	WARN_ON(dev->cfg != dev->cfg_pending);
+	cfg = kmemdup(dev->cfg, sizeof(*dev->cfg), GFP_KERNEL_ACCOUNT);
+	if (!cfg)
+		return -ENOMEM;
+
+	dev->cfg_pending = cfg;
+	return 0;
+}
diff --git a/net/ethtool/netlink.c b/net/ethtool/netlink.c
index 9de828df46cd..2f1eb5748cb6 100644
--- a/net/ethtool/netlink.c
+++ b/net/ethtool/netlink.c
@@ -6,6 +6,7 @@
 #include <linux/ethtool_netlink.h>
 #include <linux/phy_link_topology.h>
 #include <linux/pm_runtime.h>
+#include "../core/dev.h"
 #include "netlink.h"
 #include "module_fw.h"
 
@@ -891,12 +892,9 @@ static int ethnl_default_set_doit(struct sk_buff *skb, struct genl_info *info)
 
 	rtnl_lock();
 	netdev_lock_ops(dev);
-	dev->cfg_pending = kmemdup(dev->cfg, sizeof(*dev->cfg),
-				   GFP_KERNEL_ACCOUNT);
-	if (!dev->cfg_pending) {
-		ret = -ENOMEM;
-		goto out_tie_cfg;
-	}
+	ret = netdev_reconfig_start(dev);
+	if (ret)
+		goto out_unlock;
 
 	ret = ethnl_ops_begin(dev);
 	if (ret < 0)
@@ -915,9 +913,9 @@ static int ethnl_default_set_doit(struct sk_buff *skb, struct genl_info *info)
 out_ops:
 	ethnl_ops_complete(dev);
 out_free_cfg:
-	kfree(dev->cfg_pending);
-out_tie_cfg:
+	__netdev_free_config(dev->cfg_pending);
 	dev->cfg_pending = dev->cfg;
+out_unlock:
 	netdev_unlock_ops(dev);
 	rtnl_unlock();
 out_dev:
-- 
2.49.0


