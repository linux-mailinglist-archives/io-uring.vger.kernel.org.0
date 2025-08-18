Return-Path: <io-uring+bounces-9038-lists+io-uring=lfdr.de@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [147.75.80.249])
	by mail.lfdr.de (Postfix) with ESMTPS id 1F1B8B2A8F8
	for <lists+io-uring@lfdr.de>; Mon, 18 Aug 2025 16:13:18 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id 7FDC51B66B72
	for <lists+io-uring@lfdr.de>; Mon, 18 Aug 2025 14:05:25 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 61A68341AB5;
	Mon, 18 Aug 2025 13:57:17 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="SHoIT5lE"
X-Original-To: io-uring@vger.kernel.org
Received: from mail-wm1-f49.google.com (mail-wm1-f49.google.com [209.85.128.49])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 92C85322C87;
	Mon, 18 Aug 2025 13:57:15 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.128.49
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1755525437; cv=none; b=ilwTb7L9Y7tdvWFl+XmLLd5fRMS1qn3JVNgoDhWTigC/cZsdbvUy3cJoQ8fP+GGD6lRp39jw/T8HEA7iAFUXxm0pGeOA2ueB9ThUMsDYSy0S3B3dWYhTh+YWY3S6QCXXnUi0F8fYS+rJxGtvnjrNLhjtMnbQQtH4AAgCvMHt7ws=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1755525437; c=relaxed/simple;
	bh=uPhOZodCNAiYT0WW4/0KEJWaonMqErn9eznseuAcoic=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=oIj746RHnRRp21hx47shaijfC84u5mscbQoYeNFfsxxMgZZ4LetIFui3IkrtIqSt83u8zgVAz/n/yttCYpBPKVnzUnDypUQRlk88lu8fUYyx201pKMdSwd5f6JwufpVvl46HmN1cEZ8B2WLJHP3rcVu6YlhmvMuioN1qE3XCyXI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=SHoIT5lE; arc=none smtp.client-ip=209.85.128.49
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Received: by mail-wm1-f49.google.com with SMTP id 5b1f17b1804b1-45a1b004954so29738605e9.0;
        Mon, 18 Aug 2025 06:57:15 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1755525434; x=1756130234; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=EO4rhFnxoPdE6uV4o0KSojzsehfdwFllHuXNXl4bHdg=;
        b=SHoIT5lEMwesPGETf6FwuGGzHZh8PAUCaMtGAAOYK1Dr9FlygA62n3tN7wNheE1PVO
         NdkgLUVEctchgzBucj5hSjZHRVHTlMx0luWSQA45K7m6YbpIrgtYbbWgOqaU9ZsQdlZE
         nydilSvXs0JKT8R3TfLifE2rAm+oAAYltxPeW+Tzsi7dHjtyol7SgXSDwUUKxU5rMxJB
         idve7QdEScSz6xgCufrt1sTq2+6bkSk6HnrKGbiz4xlagimfT01FCvmG9H1Gch+TvnOJ
         j0UNKnHPju/6TwewrUdNI826hCLR171scnUt5iOQrmvGb5W1XCEyTy1pxYV4ikxoE8mi
         NdUQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1755525434; x=1756130234;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=EO4rhFnxoPdE6uV4o0KSojzsehfdwFllHuXNXl4bHdg=;
        b=sZuc3kaiJfcVnmQPJsH4Ck46csYidTrZl/WgfSBRQHUy2aCloF/BzwRk1szoNDZ3jb
         Jj8jO1ILJe/XjrdBDttwIc/RxrSFmKhH+VI7miWLN3JgYZOW6RuogjS+M/Qf5pNusmuj
         gWCLqTp8k8cTuSkMs0soi7kPQjWrqyfVlc39+4xCABGRA0dwUMZqatW9CZlpuRfbzlsS
         JQPHe7+hB3sx862XqJKVlkVyvUnlzBegbLSwzinaHVdg9FWvK8h6ZI33eYjYaag45j9z
         ajVT/Rt6NG29DS3XQp6ZCz9ycZVGY45PxSGU7alkQ8rJyT7lSXicVXtkYXALmKVN8yvR
         6FqA==
X-Forwarded-Encrypted: i=1; AJvYcCUs6d1RWVM8f9cI6c5lRiV2erlIz5usVJak4NxeODwBx+n8o3OybaA8rwSoZRsNLT4e17uEZdxQ@vger.kernel.org, AJvYcCWpFk9qBRJkE8hJB+93L1Hzx8UQ3YpoYd2Bl0JWLVuY3GfSCSRnZcUidh6NQ/AxQ80+h3DUqHbdLg==@vger.kernel.org, AJvYcCXaH8WXn/dNHgx8QvPxRaXiWEvViR0DH7Hy1FDTvYNpa4gyVtymAmPjPqiHtELbXLvf/+vwMynsPr7jliM1@vger.kernel.org
X-Gm-Message-State: AOJu0YzVwdaa1bpm/o8TSHmraWxbl47XUx0RkYAfUFoMZyGArKXoshXS
	rIKTeAf3FCD+AeCO2mH6C4cDHypud4lB39mD1bAJwJ/XIYX0vvbi3VcM
X-Gm-Gg: ASbGncvmJLMWYkK5SR2NrQwhXrwixckKi9uh3LVTi5jbzJadn2ZMg+UV/Tktk8P0MfG
	aCJ8YPEc29fRwqVtr/nk0RFN0VS15K2ZoOn1woD1JQZa3cM9jM5rYWom9T02oTPpMIxHQHx33o9
	rGE3pnFmEHcpEUq0V/fqQ3wRuS+kKi/ayBLwdqqwwLyP0Zo52I3IulBcpV7n/3i5YYyEwwMgi2y
	n3d0rq8JDUvgYWWh6DFTw+Cyz5Y5x7lxogn/U19UpXNCQezP4SkUV+0qeZS0d3v9iATXcmRWQBZ
	bwZjjpun9cXK82lrXq4362AhCUHOKvZQ7o9ctV6VZwGJ8o9VGAn29EaducHHrLbZikJ0ePPm7Qd
	REthksHgfSlEWevU8NM5j82n5n45wA0Q5jg==
X-Google-Smtp-Source: AGHT+IGwIAP1mf1GI9G+rzGUBGLqZz7cZDoMgatT5HDZq6aN5orhtgKenBZxfYBMO0vD4Z/+YO1Ymw==
X-Received: by 2002:a05:600c:1f10:b0:450:cabd:b4a9 with SMTP id 5b1f17b1804b1-45a26790db8mr66136765e9.29.1755525433654;
        Mon, 18 Aug 2025 06:57:13 -0700 (PDT)
Received: from 127.0.0.1localhost ([185.69.144.43])
        by smtp.gmail.com with ESMTPSA id 5b1f17b1804b1-45a1b899338sm91187345e9.7.2025.08.18.06.57.12
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 18 Aug 2025 06:57:12 -0700 (PDT)
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
Subject: [PATCH net-next v3 23/23] net: validate driver supports passed qcfg params
Date: Mon, 18 Aug 2025 14:57:39 +0100
Message-ID: <417cf28f3bf129d1a0d1b231220aa045abac3263.1755499376.git.asml.silence@gmail.com>
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

When we pass a qcfg to a driver, make sure it supports the set
parameters by checking it against ->supported_ring_params.

Suggested-by: Jakub Kicinski <kuba@kernel.org>
Signed-off-by: Pavel Begunkov <asml.silence@gmail.com>
---
 net/core/dev.h             |  3 +++
 net/core/netdev_config.c   | 26 ++++++++++++++++++++++++++
 net/core/netdev_rx_queue.c |  8 +++-----
 3 files changed, 32 insertions(+), 5 deletions(-)

diff --git a/net/core/dev.h b/net/core/dev.h
index c1cc54e38fe4..c53b8045d685 100644
--- a/net/core/dev.h
+++ b/net/core/dev.h
@@ -103,6 +103,9 @@ int netdev_queue_config_revalidate(struct net_device *dev,
 				   struct netlink_ext_ack *extack);
 void netdev_queue_config_update_cnt(struct net_device *dev, unsigned int txq,
 				    unsigned int rxq);
+int netdev_queue_config_validate(struct net_device *dev, int rxq_idx,
+				  struct netdev_queue_config *qcfg,
+				  struct netlink_ext_ack *extack);
 
 /* netdev management, shared between various uAPI entry points */
 struct netdev_name_node {
diff --git a/net/core/netdev_config.c b/net/core/netdev_config.c
index 2c9b06f94e01..ffe997893cd1 100644
--- a/net/core/netdev_config.c
+++ b/net/core/netdev_config.c
@@ -1,6 +1,7 @@
 // SPDX-License-Identifier: GPL-2.0-only
 
 #include <linux/netdevice.h>
+#include <linux/ethtool.h>
 #include <net/netdev_queues.h>
 #include <net/netdev_rx_queue.h>
 
@@ -136,6 +137,31 @@ void netdev_queue_config(struct net_device *dev, int rxq,
 }
 EXPORT_SYMBOL(netdev_queue_config);
 
+int netdev_queue_config_validate(struct net_device *dev, int rxq_idx,
+				  struct netdev_queue_config *qcfg,
+				  struct netlink_ext_ack *extack)
+{
+	const struct netdev_queue_mgmt_ops *qops = dev->queue_mgmt_ops;
+	int err;
+
+	if (WARN_ON_ONCE(!qops))
+		return -EINVAL;
+
+	if (!(qops->supported_ring_params & ETHTOOL_RING_USE_RX_BUF_LEN) &&
+	    qcfg->rx_buf_len &&
+	    qcfg->rx_buf_len != dev->cfg_pending->rx_buf_len) {
+		NL_SET_ERR_MSG_MOD(extack, "changing rx-buf-len not supported");
+		return -EINVAL;
+	}
+
+	if (qops->ndo_queue_cfg_validate) {
+		err = qops->ndo_queue_cfg_validate(dev, rxq_idx, qcfg, extack);
+		if (err)
+			return err;
+	}
+	return 0;
+}
+
 int netdev_queue_config_revalidate(struct net_device *dev,
 				   struct netlink_ext_ack *extack)
 {
diff --git a/net/core/netdev_rx_queue.c b/net/core/netdev_rx_queue.c
index 39834b196e95..d583a9ead9c4 100644
--- a/net/core/netdev_rx_queue.c
+++ b/net/core/netdev_rx_queue.c
@@ -37,11 +37,9 @@ int netdev_rx_queue_restart(struct net_device *dev, unsigned int rxq_idx,
 
 	netdev_queue_config(dev, rxq_idx, &qcfg);
 
-	if (qops->ndo_queue_cfg_validate) {
-		err = qops->ndo_queue_cfg_validate(dev, rxq_idx, &qcfg, extack);
-		if (err)
-			goto err_free_old_mem;
-	}
+	err = netdev_queue_config_validate(dev, rxq_idx, &qcfg, extack);
+	if (err)
+		goto err_free_old_mem;
 
 	err = qops->ndo_queue_mem_alloc(dev, &qcfg, new_mem, rxq_idx);
 	if (err)
-- 
2.49.0


