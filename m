Return-Path: <io-uring+bounces-9034-lists+io-uring=lfdr.de@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [139.178.88.99])
	by mail.lfdr.de (Postfix) with ESMTPS id 1341EB2A8E1
	for <lists+io-uring@lfdr.de>; Mon, 18 Aug 2025 16:10:44 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 8BEFE3BB25A
	for <lists+io-uring@lfdr.de>; Mon, 18 Aug 2025 14:03:18 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 031F2343D6E;
	Mon, 18 Aug 2025 13:57:09 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="IQFPKWmd"
X-Original-To: io-uring@vger.kernel.org
Received: from mail-wm1-f44.google.com (mail-wm1-f44.google.com [209.85.128.44])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 523BB342CA8;
	Mon, 18 Aug 2025 13:57:07 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.128.44
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1755525428; cv=none; b=N5RU2nQhViW4uWCkRveIQ49rdY6huNjOaIH1TOZmVzIXdvR2kNzcXhneXmHSqXttJEiKrlp0slJyoUHfmHCuOsAVjWvlR2itm6qmXJBO4kE8u3wBSRYyvzP05lbKO6wMQFKv+Rpjlk3rr1SugMpWD+1pF89Ttmryi9HphiLoc+8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1755525428; c=relaxed/simple;
	bh=mYVcN2+csBFSxHU70gBvzCskHp+H0qUc9gIK7qA6Aa8=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=bKwT5Pcf2ScfRe/K8zEKxxNY/96J4rwrG38geaHb4+7+jjiaLSV4/7bjgTAoYrf5qxAKvDn5+AvTVbWBJYYU4BABaE7+/27Cew3Erl+7CGkgMdJ4KvYxRaeeUDhFdmhfmP7X6bP07V+wOQAa2v/EyZDAN7/l75wKFiXOVeU5gDE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=IQFPKWmd; arc=none smtp.client-ip=209.85.128.44
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Received: by mail-wm1-f44.google.com with SMTP id 5b1f17b1804b1-45a286135c8so7919645e9.0;
        Mon, 18 Aug 2025 06:57:07 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1755525426; x=1756130226; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=Sa32ZzLQriCKbCG36ZxiaTopjAbCU2hYd913+NJy9Lo=;
        b=IQFPKWmdVU76tMEjA0nDhPelBlgawEJjGnsxy5PaFiZl1kqTuk6CaHj2LDufQsYqV+
         4celp01SB/JnCwOsUZP6UvyaaaD2V2O9CU5QoGVX2NlNTavDYzjN6OeLL0aGOIbD110l
         lSaOSPdSNn+y8rf7ibGGvSAeYCI6/Lj2nbxQpKZQy5dQhhnj6UpQQaNJuJhVkiJmvWqN
         l25z+303ANYJBimQL+tfSWjbjXd2bLpZSDiK/vzdER+m6f4c/q6QK/gSwVfJ9b2O90U9
         g0ZwCy/iD7mlfecP8MR9wesgWw0BkfcLpUMIEvdZR1I+smtb2zk2C54sGiMmJX5s28BV
         /Y5w==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1755525426; x=1756130226;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=Sa32ZzLQriCKbCG36ZxiaTopjAbCU2hYd913+NJy9Lo=;
        b=OX847ZM/r2dodwjc4nHZ//MwLZLJjiWVDHxxmQzgOsCONfx7LKw1idMMKIOE59Z/sx
         Y3yxLk9JUbkbtDfFQo9vZuy8MldXqxClvMq33vhioB0Ak4jOV/M1c7sLxj/SFRYwX6ms
         3bytmz5goyFg6sWGH6IocK/xFNgsPFK1xx1RGc30KcevcZ1f5xcE8UiBx/fjYVMF1sZE
         kjOOCVLhWwW+BHfYoj6XznfxbDJjsshjc6d3HEYQp8MBjwEiTOFlJ2+c8ef/RAg046Qc
         ioAlneHx7Mo3u9CZ5WlsLckImGIGetYs/DQGUDdNY0WtoJgBJsy9HF/tTaDydwauP2xv
         E/xQ==
X-Forwarded-Encrypted: i=1; AJvYcCUNEcJq8/GfSk0I7LhZW8f3M93F+ly3Fz/+gbSI3agSI5D90r/amv4XeV2sdcTIdg827XkW+dvw@vger.kernel.org, AJvYcCVIR2ligEJd6bzGT56pv9S4YlM0nkTc9JrNr7p1nPHAPJGxdVcMIg0HvdPm2RR+ObvCDH65OsdWh5NWCC0x@vger.kernel.org, AJvYcCWFphlCPCCCJD7fkUBZNfbbTzd2IW3cpKRxKEfNQHNcwEh6uXasmRIJ+UjTOPJgUp4uNlubPj9F2A==@vger.kernel.org
X-Gm-Message-State: AOJu0YxBUMg2SsDpCiFGYszeYY1WraVUROUcVTSbAz509VNieIrRXT2X
	h5pT46/rrbGNaq3zPOkqIXSODOvgQF8uD+PNPwsnsuITuO+Nxkoi4gLw
X-Gm-Gg: ASbGncu/lWlVAhURCG6VaDceXEtBpppSXuoKWwae6AEVMb8pkWgjj1E+f8CCQrZ8QWx
	Ntr/v9ET9m6CdE9BuvuaNefApxSBtj2xWlXH5ESRn4twZ0HJXhQzFoOKH5OOP3EyuCfXOcJV3NR
	zE8hlq1bk8GtqpO3+ex8P/g3nfYhOwIc5dJoz4B4OVD2ftWgASIPk/JIzvU72KgqEqNMuiKZLpd
	exmWwoVBNhbfTTrYcuYPPazBIEFHKHjIeuBiw4XqHB1Pk1NDzI9zHftbkbgr6/BfzfM1RM6HbxR
	HGMtQcvlRI6BdST3GWJeKjqdngDM8seP3/Btq2DXowPgVU1LhInG6gVZ9cjid5ymSaOlBIN//iq
	dJJU7zYIIxAXUThld+kIB2SKwsL4s1OAZGQ==
X-Google-Smtp-Source: AGHT+IGxje0boceoHSgbUFO9JG94L54W4nuJRwC7Np/Ze6s0syJcX+0dN1vsh13l4qdUSMafyjvz0Q==
X-Received: by 2002:a05:600c:3006:b0:459:db88:c4ca with SMTP id 5b1f17b1804b1-45a1b65c7c9mr102367055e9.3.1755525425519;
        Mon, 18 Aug 2025 06:57:05 -0700 (PDT)
Received: from 127.0.0.1localhost ([185.69.144.43])
        by smtp.gmail.com with ESMTPSA id 5b1f17b1804b1-45a1b899338sm91187345e9.7.2025.08.18.06.57.03
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 18 Aug 2025 06:57:04 -0700 (PDT)
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
Subject: [PATCH net-next v3 19/23] net: wipe the setting of deactived queues
Date: Mon, 18 Aug 2025 14:57:35 +0100
Message-ID: <0ac4e47001e1e7adea755a3c45552079104549b9.1755499376.git.asml.silence@gmail.com>
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

Clear out all settings of deactived queues when user changes
the number of channels. We already perform similar cleanup
for shapers.

Signed-off-by: Jakub Kicinski <kuba@kernel.org>
Signed-off-by: Pavel Begunkov <asml.silence@gmail.com>
---
 net/core/dev.c           |  5 +++++
 net/core/dev.h           |  2 ++
 net/core/netdev_config.c | 13 +++++++++++++
 3 files changed, 20 insertions(+)

diff --git a/net/core/dev.c b/net/core/dev.c
index 7cd4e5eab441..457ba1d111e4 100644
--- a/net/core/dev.c
+++ b/net/core/dev.c
@@ -3188,6 +3188,8 @@ int netif_set_real_num_tx_queues(struct net_device *dev, unsigned int txq)
 		if (dev->num_tc)
 			netif_setup_tc(dev, txq);
 
+		netdev_queue_config_update_cnt(dev, txq,
+					       dev->real_num_rx_queues);
 		net_shaper_set_real_num_tx_queues(dev, txq);
 
 		dev_qdisc_change_real_num_tx(dev, txq);
@@ -3233,6 +3235,9 @@ int netif_set_real_num_rx_queues(struct net_device *dev, unsigned int rxq)
 						  rxq);
 		if (rc)
 			return rc;
+
+		netdev_queue_config_update_cnt(dev, dev->real_num_tx_queues,
+					       rxq);
 	}
 
 	dev->real_num_rx_queues = rxq;
diff --git a/net/core/dev.h b/net/core/dev.h
index 523d50e6f88d..c1cc54e38fe4 100644
--- a/net/core/dev.h
+++ b/net/core/dev.h
@@ -101,6 +101,8 @@ void __netdev_queue_config(struct net_device *dev, int rxq,
 			   struct netdev_queue_config *qcfg, bool pending);
 int netdev_queue_config_revalidate(struct net_device *dev,
 				   struct netlink_ext_ack *extack);
+void netdev_queue_config_update_cnt(struct net_device *dev, unsigned int txq,
+				    unsigned int rxq);
 
 /* netdev management, shared between various uAPI entry points */
 struct netdev_name_node {
diff --git a/net/core/netdev_config.c b/net/core/netdev_config.c
index ede02b77470e..c5ae39e76f40 100644
--- a/net/core/netdev_config.c
+++ b/net/core/netdev_config.c
@@ -64,6 +64,19 @@ int netdev_reconfig_start(struct net_device *dev)
 	return -ENOMEM;
 }
 
+void netdev_queue_config_update_cnt(struct net_device *dev, unsigned int txq,
+				    unsigned int rxq)
+{
+	size_t len;
+
+	if (rxq < dev->real_num_rx_queues) {
+		len = (dev->real_num_rx_queues - rxq) * sizeof(*dev->cfg->qcfg);
+
+		memset(&dev->cfg->qcfg[rxq], 0, len);
+		memset(&dev->cfg_pending->qcfg[rxq], 0, len);
+	}
+}
+
 void __netdev_queue_config(struct net_device *dev, int rxq,
 			   struct netdev_queue_config *qcfg, bool pending)
 {
-- 
2.49.0


