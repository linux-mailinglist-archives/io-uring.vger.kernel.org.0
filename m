Return-Path: <io-uring+bounces-9029-lists+io-uring=lfdr.de@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [IPv6:2604:1380:45d1:ec00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 0EBC1B2A915
	for <lists+io-uring@lfdr.de>; Mon, 18 Aug 2025 16:15:13 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id A67515A0C5E
	for <lists+io-uring@lfdr.de>; Mon, 18 Aug 2025 14:01:28 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 3075533A00C;
	Mon, 18 Aug 2025 13:56:59 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="bXxYq9NG"
X-Original-To: io-uring@vger.kernel.org
Received: from mail-wm1-f49.google.com (mail-wm1-f49.google.com [209.85.128.49])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 42FCB3375C0;
	Mon, 18 Aug 2025 13:56:57 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.128.49
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1755525419; cv=none; b=ltS86xEpX1UIiPO4wN1AZaLyj5rRo7OZAefalXyAQLuvexS6QqTFe4xhJoi8BtCfb+OP00EHodYoIuE2r/NiyR9UlJhY0/IVvtHREDabgwDUuHqFsprSGV7iLL6DjNk92OvMbMSiZ1QJpyPHMnK64LTN8WQ1eHZE3ush48Y3zwQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1755525419; c=relaxed/simple;
	bh=rItQ1FaDqGqniICF4r0l4EGOYimzKaifFQoIxkujB4U=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=QEtlDYWKQNOETq8aDsKJApYb9sK+kp24Br30pe/R2uquFveWW+y8PhQa4jxSYL3sJkMsOmm05Bci3fIuP6ux4wATxqzr2XaSXP0IRLAqR7F2wgMLAfzahJQvo+y7Mj/xODeim0jcgHmK0jETlIm465njppCaH/I8SuBVmHz9jeA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=bXxYq9NG; arc=none smtp.client-ip=209.85.128.49
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Received: by mail-wm1-f49.google.com with SMTP id 5b1f17b1804b1-45a1b0bde14so21627305e9.2;
        Mon, 18 Aug 2025 06:56:57 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1755525416; x=1756130216; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=ZHaJLKiQ+hzCfw0tJkKNJaBQathEy1NNmqz8lEijMqM=;
        b=bXxYq9NGOa9Ms5mFDTo+ZDSIVYYqNME2VO98YctV3jS/bkTOe4tgmagT8lrqlssryD
         /v8+Atdq5S44wW29JoC6TKWD9fhS6CSLVUQKdbg/Lh2l6Vzf5im37zVNCkQzBw91LXGU
         /+lrKgACPTNdNCZhCYv/hiphhNr7wt15LBiQzmeUJ/i5dsuJSEussmQpj4gtwi17Jons
         zjQHf4U+nidnmITxQQ0FLF4nnj/7LtVwdVEWNv7z9uJnmzS/CsXP9zR0oxUhMzywS76u
         xynW/e0eSvSZglsqsH3NNIm/bRRtXTJvwHekhiZr6VZJDvpDKClTJSKorIBwzA1XeTNt
         91pw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1755525416; x=1756130216;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=ZHaJLKiQ+hzCfw0tJkKNJaBQathEy1NNmqz8lEijMqM=;
        b=KxXEq0sGxPyZrdVNdVQX8Dpsq7HgX7mkgXwWmFDq4l72Nv1xCvXnaDCkOvECaN1Kcv
         N0yyK6ws/ETn/yJl3zfEf1svZf82kZKnMrBjkwEmwrsof+v0BXL8atuSlkJu4NSxgmAp
         iubHVoKbbyx+Xs0cceHey/7XOa9Aix2sVx1B5O6mabBV/b+aY0UI92QpJHmzei0HoX/o
         WPv4MYzQBcK7w+f4wnHkZmFcUJqaqp0Z7Xx2x07EKhMpqANATpI/4O7us3xDlqC19+Sh
         QbGNrGAHe4hr86KaLMO7MyRpBXHf7c8y+Wuy0gpRuwdG3AoYNhjKSS/WhgO9NVuFs1gv
         iArA==
X-Forwarded-Encrypted: i=1; AJvYcCVSVR70puwO95FgnzDBPtoq2xxMMaPLDwVFYjEruw+TMo6TN6szq09apaR0Vde2PpP5twpwGuY1/A==@vger.kernel.org, AJvYcCXAIVhPv2jHiZ+UM7U8uZN0KwAUbr2xa3TN21bQh+mtnKzL7FaMoFxX/3CwF586t5upYFQYCKzN@vger.kernel.org, AJvYcCXcvxqyL19XaK2faNpMEkaYp2qPvhy6mHnW1/0osTKqa9lViGN73EabG4BRV5gdoHbGFdYFkCM8962e8RKE@vger.kernel.org
X-Gm-Message-State: AOJu0YxNdY69QnzEcybDTZgZ7DOzrU+3WzveGrv8yrHzsxOyPsXOe2r6
	9wrw8J5fKnZpBIvB44WLIPZszJwCH8tCAiafmuAO/Gjr27W4UGnd2ITp
X-Gm-Gg: ASbGncvLIuVKwnNklT8B2qj1bi3Z5VoiWqEgpWGc695ZpHs2hFZ4qnXA6YD+2sRWW68
	ZD369zogVPk4+kt3UDQpV5QeAm28BuCQXNiPNotEoScwlZXituqHwhlGVDkjd874d8cQdjRTvyV
	hEh4BBzPtJ3wVMZwcpy8XYC8MwY+FilMoXjkycjV54JEAe3fJoel2oIKWivEk4qhpKa2VHm72KK
	uR28el0EMKbr6TkbfihIIJS7PPi1KrEIZfQwLiVPmSneKO3/AovB2hytjPu4nwC7e9UpDGELh2M
	Mfx8qyoGjPAxFHUwfXGXqHb7sYroxmHxO/5Ppz/wf3/MwSruvg/FC4nN8e+jCSffDSfPYojxaKi
	NZ8uW/3QGJy5Mxi4DVh8O4wSDAk8OmAYGbw==
X-Google-Smtp-Source: AGHT+IFQXMXIqOUwUve9nBMNNE61co037mpqKcoM8hBl9Y/qq6DfVe4ICkECU/EvqtYznHyoGvJlIA==
X-Received: by 2002:a5d:64e7:0:b0:3b8:d7c7:62d7 with SMTP id ffacd0b85a97d-3bb66e16fecmr9143322f8f.16.1755525415494;
        Mon, 18 Aug 2025 06:56:55 -0700 (PDT)
Received: from 127.0.0.1localhost ([185.69.144.43])
        by smtp.gmail.com with ESMTPSA id 5b1f17b1804b1-45a1b899338sm91187345e9.7.2025.08.18.06.56.53
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 18 Aug 2025 06:56:54 -0700 (PDT)
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
Subject: [PATCH net-next v3 14/23] net: add queue config validation callback
Date: Mon, 18 Aug 2025 14:57:30 +0100
Message-ID: <819d46e1354b0c7cc97945c6c7bde09f12df1da6.1755499376.git.asml.silence@gmail.com>
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
index b850cff71d12..d0cc475ec51e 100644
--- a/include/net/netdev_queues.h
+++ b/include/net/netdev_queues.h
@@ -147,6 +147,14 @@ void netdev_stat_queue_sum(struct net_device *netdev,
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
@@ -167,6 +175,10 @@ struct netdev_queue_mgmt_ops {
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
index a553a0f1f846..523d50e6f88d 100644
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
index 420b956a40e4..39834b196e95 100644
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


