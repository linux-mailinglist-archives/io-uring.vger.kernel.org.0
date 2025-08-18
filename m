Return-Path: <io-uring+bounces-9025-lists+io-uring=lfdr.de@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [IPv6:2604:1380:45d1:ec00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 9E410B2A8EE
	for <lists+io-uring@lfdr.de>; Mon, 18 Aug 2025 16:12:11 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id B3B5F5A128D
	for <lists+io-uring@lfdr.de>; Mon, 18 Aug 2025 13:59:59 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id B1E9232A3D9;
	Mon, 18 Aug 2025 13:56:51 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="egeatfAG"
X-Original-To: io-uring@vger.kernel.org
Received: from mail-wr1-f46.google.com (mail-wr1-f46.google.com [209.85.221.46])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id DE7F8322DBF;
	Mon, 18 Aug 2025 13:56:49 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.221.46
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1755525411; cv=none; b=SSiY/10NBrNSGQjXDMRicYOrsCn8pUuN4H2FxyY1TVjNS9Mwbtqtn6YtYn6Q4erwxSlPMtYYz98LuQkAxx2SGUhZacYN06bcDrRjnoZRoWX5IIxJTih2od1KbcZs4D9RihwGYnsTvjZPZ5HBzvry7PGkcKW7rU+eFZqn3VlhTmo=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1755525411; c=relaxed/simple;
	bh=DvFXxblauZ96VafpOgvufX2U0H591Fff3g6A9dC69o8=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=HfBDaftTANWN4sxU77JsVnhuYoTdjxAYTV4B3WT1cvmj3iFKcViczyZJOo9po2W2nXXp9h7NvM6ehWroudHlXUArEvn0wnnj45TQJHJX8OXMTiNd9bRzBKOU63yR5k+WWKsjXfsAx4YaQILrQ5LASKDkJ4ypAmlVP1SoV20RBng=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=egeatfAG; arc=none smtp.client-ip=209.85.221.46
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Received: by mail-wr1-f46.google.com with SMTP id ffacd0b85a97d-3b9a342e8ffso2987089f8f.0;
        Mon, 18 Aug 2025 06:56:49 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1755525408; x=1756130208; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=8AxLYhi8kKcwzw7gKfW047K4r67KlE0o7DzHo3l/cZg=;
        b=egeatfAG3NYEMLunKvMYgnmedZAc/cuGeqIEobEcYTJpKsIlqMcEEH+83VSg5KucHy
         HiRaZTofI8GNlHbMMRviPmsAKXR6aCkeolHwWcS8xma8VTD1jkoFuYsYR0ufewTluE+r
         vQO+/ARxhqU2DbKT5nlE3YmyTAZ1TWsDU9uvC7EquQrZXS/Kf5hYyQb1FZQaMvMzY6d4
         EDx8xzNAEJf1r4dwXv1xUVrKaF2O9PT6RFVSUI+NW3MF1+Zv40TG5aU0WUnzxRB38ey9
         MH96zqv+EhPPyYTH5yYTmUJHW/oHd8fSufexn1nXcJP/mYwbHAliNM5OCbNqSOSWBdzM
         sU5g==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1755525408; x=1756130208;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=8AxLYhi8kKcwzw7gKfW047K4r67KlE0o7DzHo3l/cZg=;
        b=fOahhs79aqUwQhD329MzOUobR3r4zPSgp1L+Iliews7yfn382M4YWv+qr/ak070p8y
         eviX/q1otQBco3B4Sh2vya4WT9NQLn9iZG2rvsHiWkfEaUbAFnrKXd07bOAbJ2cfylAW
         iJUaxfuozSU9xkWkoIQeKGKueXgVwZUP3AVIUWxs2KPpOKhCVUgY6u3fuDatycR7KNtx
         TuoNGdPQdXs1H2y0DIW169Z/kz5zai2EBSOVHl+rwQIWI6pz1HPB4WMyuylUkqiRNnlV
         +d+1cpS7O2+TCOqFkQkim5qcaIrxF7yDnhkRWUA5jmCbldeyOe7jAD2Z88ClsLjV103s
         8DoQ==
X-Forwarded-Encrypted: i=1; AJvYcCV8xQYrUz8bAdCerJ+vPmWeLQgwJGjgAnglCIzq219Dh/o705Y0umPPwCA2g3+ObiMfGkvndWau2GqZa+Jx@vger.kernel.org, AJvYcCX/u3g1veLPRZc9uGgbhgYtwIQlwInnzD2GTfveU1y94FsK6s4vTOGzPirWVKnQ8R6am5Nwe6b/@vger.kernel.org, AJvYcCX4hVndAsvdWwMO/39jt/tM7C7/aWgayXoApId/YqpVyOqP1XcHHgLBma6lrNpQNmw+jSVS2GFNGA==@vger.kernel.org
X-Gm-Message-State: AOJu0YzEPUtt0klRwBcbDGj63FUOdelm6tG7R7t7wOcWxNA9Key1nXkO
	yWjqJVVdOMV14vgbd42YEqKsXLI+yJxgs8+rkd87iD7MXs6+dUNSZYCXd/JQIQ==
X-Gm-Gg: ASbGncubR8GEufz9wD6l5PEhsd42Ybh1Y/9DctusLeXtZk4JSj8XrJ/sqI7OtNdSlhY
	MCFxsTnYqAP09fmqhtERrhcprOeVGRh/aGTHHl1dmcmli78hbMuX8iBaBGTXOeki8aZhI7oLhhl
	FwRPGjN7pnmiDm1Qnw8M7WJMJntNpivle4NiKu+ZsY/JGukXnxod49+CFrG8liKqXpirm8cyS69
	kEkV40FBestoqTE856oZv7NzNUgeHlxuP8G5MI0jZJfKBKHMc8mhCaD7aSVlTt/FOkVmpormZVU
	PXYESo00VKDoNe775Ihh3eVn/VYREnO2cqxXBo27nonLkAoFi8YtgSqsXu5FFNhaG4oqkKSfiAJ
	7nLmOF3QYK2RJ/OGUSFKVqhQAahC5mOFDgw==
X-Google-Smtp-Source: AGHT+IGqnDE72P9mmAK7XWqI7iqEancIsOOzddFZ1FKbJa4KK1w018iwE5+9sfYxuPxvv8Ikzr3pMg==
X-Received: by 2002:a05:6000:26c3:b0:3a5:8934:4959 with SMTP id ffacd0b85a97d-3ba5093a6bfmr12759862f8f.27.1755525408154;
        Mon, 18 Aug 2025 06:56:48 -0700 (PDT)
Received: from 127.0.0.1localhost ([185.69.144.43])
        by smtp.gmail.com with ESMTPSA id 5b1f17b1804b1-45a1b899338sm91187345e9.7.2025.08.18.06.56.46
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 18 Aug 2025 06:56:47 -0700 (PDT)
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
Subject: [PATCH net-next v3 10/23] net: move netdev_config manipulation to dedicated helpers
Date: Mon, 18 Aug 2025 14:57:26 +0100
Message-ID: <536e37960e3d75c633bdcdcfec37a89636581f2c.1755499376.git.asml.silence@gmail.com>
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
index 5a3c0f40a93f..7cd4e5eab441 100644
--- a/net/core/dev.c
+++ b/net/core/dev.c
@@ -11873,10 +11873,8 @@ struct net_device *alloc_netdev_mqs(int sizeof_priv, const char *name,
 	if (!dev->ethtool)
 		goto free_all;
 
-	dev->cfg = kzalloc(sizeof(*dev->cfg), GFP_KERNEL_ACCOUNT);
-	if (!dev->cfg)
+	if (netdev_alloc_config(dev))
 		goto free_all;
-	dev->cfg_pending = dev->cfg;
 
 	dev->num_napi_configs = maxqs;
 	napi_config_sz = array_size(maxqs, sizeof(*dev->napi_config));
@@ -11947,8 +11945,7 @@ void free_netdev(struct net_device *dev)
 		return;
 	}
 
-	WARN_ON(dev->cfg != dev->cfg_pending);
-	kfree(dev->cfg);
+	netdev_free_config(dev);
 	kfree(dev->ethtool);
 	netif_free_tx_queues(dev);
 	netif_free_rx_queues(dev);
diff --git a/net/core/dev.h b/net/core/dev.h
index d6b08d435479..7041c8bd2a0f 100644
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
index 2f813f25f07e..d376d3043177 100644
--- a/net/ethtool/netlink.c
+++ b/net/ethtool/netlink.c
@@ -6,6 +6,7 @@
 #include <linux/ethtool_netlink.h>
 #include <linux/phy_link_topology.h>
 #include <linux/pm_runtime.h>
+#include "../core/dev.h"
 #include "netlink.h"
 #include "module_fw.h"
 
@@ -906,12 +907,9 @@ static int ethnl_default_set_doit(struct sk_buff *skb, struct genl_info *info)
 
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
@@ -930,9 +928,9 @@ static int ethnl_default_set_doit(struct sk_buff *skb, struct genl_info *info)
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


