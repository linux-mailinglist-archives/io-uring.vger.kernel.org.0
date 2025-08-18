Return-Path: <io-uring+bounces-9033-lists+io-uring=lfdr.de@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [IPv6:2604:1380:4601:e00::3])
	by mail.lfdr.de (Postfix) with ESMTPS id 52A69B2A948
	for <lists+io-uring@lfdr.de>; Mon, 18 Aug 2025 16:18:08 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id 476631B27DED
	for <lists+io-uring@lfdr.de>; Mon, 18 Aug 2025 14:03:24 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 119F9342CB5;
	Mon, 18 Aug 2025 13:57:08 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="RX76MQ5o"
X-Original-To: io-uring@vger.kernel.org
Received: from mail-wm1-f42.google.com (mail-wm1-f42.google.com [209.85.128.42])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C5B07342C90;
	Mon, 18 Aug 2025 13:57:05 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.128.42
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1755525428; cv=none; b=u8Yk9Y8TGiGjn3y0z+jHnSZQXM4B2QdFppj8Q7bsluWgQS7CO00GiacOorxLAVxBARq/q/XODl2jHWPfnpP+D2dBkzWsL0nu6NvzDp5V6ojQJwAN47FIrNKEE9N0uQ9KvwzCzDeYf1D4UXOnL8XbqJ0jXhYJe5xKs8KYU2jxo8Q=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1755525428; c=relaxed/simple;
	bh=dKemawYs6tmRpVp4P/ZJ5e8Z9CA9cpAAwsABO80XNsY=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=suUtB4exHXLChZmHzBz82mLHxFWfvLzvENpr0hN2coZK8cJ0ipT4R3LLU1Tc0hE17Rda2LC4+oqanrSP71ENCDPoqyjbtM2sq5AcVNV5j92Rp8HPVluOjc5/XRuuKot2npFVix6PSpMKTx+9I8gfnFO8fy/mgFJlUbFgUYEmYzk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=RX76MQ5o; arc=none smtp.client-ip=209.85.128.42
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Received: by mail-wm1-f42.google.com with SMTP id 5b1f17b1804b1-45a1b0b2d21so19554895e9.2;
        Mon, 18 Aug 2025 06:57:05 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1755525424; x=1756130224; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=IaRoaXadLVFNZS0CAr8CbfPwOM7w7w9VFRM/7RWs6iY=;
        b=RX76MQ5op6qhucjBA+8vIsbFL1GhMdl/yx+WecySJ5bpWzTIGO+5IE/N35QCCQDZ2u
         l6bDIqqqAYS+uQtXSxW6Y9ixdZJzn5PfLpm8xXr7uzsXKLzNZ1AQX8K0FR8wkeMvn5OJ
         eTFAaPLyGPZhimxg4hrUFNhexlw81172aiU9G0jUrBVkSQxff6MAC/+xyALKwXz2N6UA
         US/ABL6iOrLG7oG4EnySBSNspogJomWdblR3wE8iIQ+xKkJRC9jrXkIAkR7VCeuc//Q6
         xdpP7IJRiTLNKTmw+kv1RTUpWxPIUGDOi0oHNyO/1YeX9L+E1Wo0GHwM4FUufrbBc+hg
         QkPg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1755525424; x=1756130224;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=IaRoaXadLVFNZS0CAr8CbfPwOM7w7w9VFRM/7RWs6iY=;
        b=QXY5zo46JxMcZsRaV9JrCyTabg2MqdGlqVE1UPTACeiOeVJRamp3uGpZw96jXmzQsj
         I8anfZt2+KZLHI0ny4Is9UOPD/HecTtTobiLAdL6hoknhFqtEZQ8+dDOVJmPWv6+bWIJ
         /ra9URHEH2K46Mk0ToKEkNmtBBYKirlRHoE8AJmhCwUzdCTHigCmxzO358spNUOvUtf8
         IardHoFNAtEuQGRQ4x90h/r7NZGwe6f00g7oSgQtx/S93PI3RtRNhUnJQPEBtxo9QlIj
         V55i/jOaqYlKVKIO+C28exI7ZFb1pg/L710OhEQc1r9K3ru6wtkWw8+3t+KTEyhG0br7
         YHbg==
X-Forwarded-Encrypted: i=1; AJvYcCUnLbZ3Zg94nvhMz93h27h1qOHB2PeH6Bnmb+xpOwB9zTeWT7clEKS0w5EtlEi4b3FpHRw77heU@vger.kernel.org, AJvYcCV6aq+Joifshz/QQYjsUKGmWOrgcGeREU+Z8g4upeguT6FCJ9TIHvs0so5Riv8gZBp9opqnD4nuNw==@vger.kernel.org, AJvYcCXGJHGIl5LzeEjklvpeK2EmQdpFrrkJtidVU8PtH0PHeR237DelWvjTHJJYe9nIA7DE+U4F3tyS5vrGVs8h@vger.kernel.org
X-Gm-Message-State: AOJu0YzpBKEBAATk/Ar7CEPKcTCdmjBacKQXnAkQrPDRRLQsh7z0e++I
	5qgpOGrsypvOkEDtStFZBQpgoqYJMRVh3o2AdZoCkmzPpfnwejMpuox6
X-Gm-Gg: ASbGnctF/ulqM2SL5fY6P6NTuQzWwhe0GjMf+73sTLsUpl3W5g4ww6OeTdM/Bzso4Y3
	CmQvtP9to3R7cvAxWGp7vN+LkaR4ryFgFiZY7TsFhyAhJiBjRarvfisjauSprEJ8Hkwx3GR2fiS
	7MHpcjqW2gQcvS9BeaVHXDszMI5eSJ5rWPv02u1bxl9d9dt3rnZT45+itPmvcjexX1UKdSsv2Zx
	8WLKBszaulDmQEOMKoW8lXF0KHIcrhjRfR4Xuee0yElTqyToDaa2CPXlqP+DhO4svchTgr9Gtgt
	SPB2axnlymtt8IWbYGywk3ja8c3echCGQtC1TQ81Aogvcpw67xF8dMYANFuQ5UGR7vZb/2REYPB
	GzgAqjrnhpFdIB0VUGSP7LiVk1iK7wRsyAQ==
X-Google-Smtp-Source: AGHT+IHFpkjBoZA6K71P9o/tTFhDYmXJ8FdMdG6nqViRdJyxe78EWhY6+Vtlg9ACTTfyO/RIFIM8xw==
X-Received: by 2002:a05:600c:4ecd:b0:456:1846:6566 with SMTP id 5b1f17b1804b1-45a218573e1mr99589145e9.29.1755525423813;
        Mon, 18 Aug 2025 06:57:03 -0700 (PDT)
Received: from 127.0.0.1localhost ([185.69.144.43])
        by smtp.gmail.com with ESMTPSA id 5b1f17b1804b1-45a1b899338sm91187345e9.7.2025.08.18.06.57.02
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 18 Aug 2025 06:57:02 -0700 (PDT)
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
Subject: [PATCH net-next v3 18/23] netdev: add support for setting rx-buf-len per queue
Date: Mon, 18 Aug 2025 14:57:34 +0100
Message-ID: <5273e2bf83c1f22a6448363b5a51ec85854f03d6.1755499376.git.asml.silence@gmail.com>
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

Zero-copy APIs increase the cost of buffer management. They also extend
this cost to user space applications which may be used to dealing with
much larger buffers. Allow setting rx-buf-len per queue, devices with
HW-GRO support can commonly fill buffers up to 32k (or rather 64k - 1
but that's not a power of 2..)

The implementation adds a new option to the netdev netlink, rather
than ethtool. The NIC-wide setting lives in ethtool ringparams so
one could argue that we should be extending the ethtool API.
OTOH netdev API is where we already have queue-get, and it's how
zero-copy applications bind memory providers.

Signed-off-by: Jakub Kicinski <kuba@kernel.org>
Signed-off-by: Pavel Begunkov <asml.silence@gmail.com>
---
 Documentation/netlink/specs/netdev.yaml | 15 ++++
 include/net/netdev_queues.h             |  5 ++
 include/net/netlink.h                   | 19 +++++
 include/uapi/linux/netdev.h             |  2 +
 net/core/netdev-genl-gen.c              | 15 ++++
 net/core/netdev-genl-gen.h              |  1 +
 net/core/netdev-genl.c                  | 92 +++++++++++++++++++++++++
 net/core/netdev_config.c                | 16 +++++
 tools/include/uapi/linux/netdev.h       |  2 +
 9 files changed, 167 insertions(+)

diff --git a/Documentation/netlink/specs/netdev.yaml b/Documentation/netlink/specs/netdev.yaml
index c035dc0f64fd..498c4bcafdbd 100644
--- a/Documentation/netlink/specs/netdev.yaml
+++ b/Documentation/netlink/specs/netdev.yaml
@@ -338,6 +338,10 @@ attribute-sets:
         doc: XSK information for this queue, if any.
         type: nest
         nested-attributes: xsk-info
+      -
+        name: rx-buf-len
+        doc: Per-queue configuration of ETHTOOL_A_RINGS_RX_BUF_LEN.
+        type: u32
   -
     name: qstats
     doc: |
@@ -771,6 +775,17 @@ operations:
         reply:
           attributes:
             - id
+    -
+      name: queue-set
+      doc: Set per-queue configurable options.
+      attribute-set: queue
+      do:
+        request:
+          attributes:
+            - ifindex
+            - type
+            - id
+            - rx-buf-len
 
 kernel-family:
   headers: ["net/netdev_netlink.h"]
diff --git a/include/net/netdev_queues.h b/include/net/netdev_queues.h
index d0cc475ec51e..b69b1d519dcb 100644
--- a/include/net/netdev_queues.h
+++ b/include/net/netdev_queues.h
@@ -39,6 +39,7 @@ struct netdev_config {
 
 /* Same semantics as fields in struct netdev_config */
 struct netdev_queue_config {
+	u32	rx_buf_len;
 };
 
 /* See the netdev.yaml spec for definition of each statistic */
@@ -141,6 +142,8 @@ void netdev_stat_queue_sum(struct net_device *netdev,
 /**
  * struct netdev_queue_mgmt_ops - netdev ops for queue management
  *
+ * @supported_ring_params: ring params supported per queue (ETHTOOL_RING_USE_*).
+ *
  * @ndo_queue_mem_size: Size of the struct that describes a queue's memory.
  *
  * @ndo_queue_cfg_defaults: (Optional) Populate queue config struct with
@@ -171,6 +174,8 @@ void netdev_stat_queue_sum(struct net_device *netdev,
  * be called for an interface which is open.
  */
 struct netdev_queue_mgmt_ops {
+	u32     supported_ring_params;
+
 	size_t	ndo_queue_mem_size;
 	void	(*ndo_queue_cfg_defaults)(struct net_device *dev,
 					  int idx,
diff --git a/include/net/netlink.h b/include/net/netlink.h
index 1a8356ca4b78..29989ad81ddd 100644
--- a/include/net/netlink.h
+++ b/include/net/netlink.h
@@ -2200,6 +2200,25 @@ static inline struct nla_bitfield32 nla_get_bitfield32(const struct nlattr *nla)
 	return tmp;
 }
 
+/**
+ * nla_update_u32() - update u32 value from NLA_U32 attribute
+ * @dst:  value to update
+ * @attr: netlink attribute with new value or null
+ *
+ * Copy the u32 value from NLA_U32 netlink attribute @attr into variable
+ * pointed to by @dst; do nothing if @attr is null.
+ *
+ * Return: true if this function changed the value of @dst, otherwise false.
+ */
+static inline bool nla_update_u32(u32 *dst, const struct nlattr *attr)
+{
+	u32 old_val = *dst;
+
+	if (attr)
+		*dst = nla_get_u32(attr);
+	return *dst != old_val;
+}
+
 /**
  * nla_memdup - duplicate attribute memory (kmemdup)
  * @src: netlink attribute to duplicate from
diff --git a/include/uapi/linux/netdev.h b/include/uapi/linux/netdev.h
index 48eb49aa03d4..820f89b67a72 100644
--- a/include/uapi/linux/netdev.h
+++ b/include/uapi/linux/netdev.h
@@ -158,6 +158,7 @@ enum {
 	NETDEV_A_QUEUE_DMABUF,
 	NETDEV_A_QUEUE_IO_URING,
 	NETDEV_A_QUEUE_XSK,
+	NETDEV_A_QUEUE_RX_BUF_LEN,
 
 	__NETDEV_A_QUEUE_MAX,
 	NETDEV_A_QUEUE_MAX = (__NETDEV_A_QUEUE_MAX - 1)
@@ -226,6 +227,7 @@ enum {
 	NETDEV_CMD_BIND_RX,
 	NETDEV_CMD_NAPI_SET,
 	NETDEV_CMD_BIND_TX,
+	NETDEV_CMD_QUEUE_SET,
 
 	__NETDEV_CMD_MAX,
 	NETDEV_CMD_MAX = (__NETDEV_CMD_MAX - 1)
diff --git a/net/core/netdev-genl-gen.c b/net/core/netdev-genl-gen.c
index e9a2a6f26cb7..d053306a3af8 100644
--- a/net/core/netdev-genl-gen.c
+++ b/net/core/netdev-genl-gen.c
@@ -106,6 +106,14 @@ static const struct nla_policy netdev_bind_tx_nl_policy[NETDEV_A_DMABUF_FD + 1]
 	[NETDEV_A_DMABUF_FD] = { .type = NLA_U32, },
 };
 
+/* NETDEV_CMD_QUEUE_SET - do */
+static const struct nla_policy netdev_queue_set_nl_policy[NETDEV_A_QUEUE_RX_BUF_LEN + 1] = {
+	[NETDEV_A_QUEUE_IFINDEX] = NLA_POLICY_MIN(NLA_U32, 1),
+	[NETDEV_A_QUEUE_TYPE] = NLA_POLICY_MAX(NLA_U32, 1),
+	[NETDEV_A_QUEUE_ID] = { .type = NLA_U32, },
+	[NETDEV_A_QUEUE_RX_BUF_LEN] = { .type = NLA_U32, },
+};
+
 /* Ops table for netdev */
 static const struct genl_split_ops netdev_nl_ops[] = {
 	{
@@ -204,6 +212,13 @@ static const struct genl_split_ops netdev_nl_ops[] = {
 		.maxattr	= NETDEV_A_DMABUF_FD,
 		.flags		= GENL_CMD_CAP_DO,
 	},
+	{
+		.cmd		= NETDEV_CMD_QUEUE_SET,
+		.doit		= netdev_nl_queue_set_doit,
+		.policy		= netdev_queue_set_nl_policy,
+		.maxattr	= NETDEV_A_QUEUE_RX_BUF_LEN,
+		.flags		= GENL_CMD_CAP_DO,
+	},
 };
 
 static const struct genl_multicast_group netdev_nl_mcgrps[] = {
diff --git a/net/core/netdev-genl-gen.h b/net/core/netdev-genl-gen.h
index cf3fad74511f..b7f5e5d9fca9 100644
--- a/net/core/netdev-genl-gen.h
+++ b/net/core/netdev-genl-gen.h
@@ -35,6 +35,7 @@ int netdev_nl_qstats_get_dumpit(struct sk_buff *skb,
 int netdev_nl_bind_rx_doit(struct sk_buff *skb, struct genl_info *info);
 int netdev_nl_napi_set_doit(struct sk_buff *skb, struct genl_info *info);
 int netdev_nl_bind_tx_doit(struct sk_buff *skb, struct genl_info *info);
+int netdev_nl_queue_set_doit(struct sk_buff *skb, struct genl_info *info);
 
 enum {
 	NETDEV_NLGRP_MGMT,
diff --git a/net/core/netdev-genl.c b/net/core/netdev-genl.c
index 6314eb7bdf69..abb128e45fcf 100644
--- a/net/core/netdev-genl.c
+++ b/net/core/netdev-genl.c
@@ -386,6 +386,30 @@ static int nla_put_napi_id(struct sk_buff *skb, const struct napi_struct *napi)
 	return 0;
 }
 
+static int
+netdev_nl_queue_fill_cfg(struct sk_buff *rsp, struct net_device *netdev,
+			 u32 q_idx, u32 q_type)
+{
+	struct netdev_queue_config *qcfg;
+
+	if (!netdev_need_ops_lock(netdev))
+		return 0;
+
+	qcfg = &netdev->cfg->qcfg[q_idx];
+	switch (q_type) {
+	case NETDEV_QUEUE_TYPE_RX:
+		if (qcfg->rx_buf_len &&
+		    nla_put_u32(rsp, NETDEV_A_QUEUE_RX_BUF_LEN,
+				qcfg->rx_buf_len))
+			return -EMSGSIZE;
+		break;
+	default:
+		break;
+	}
+
+	return 0;
+}
+
 static int
 netdev_nl_queue_fill_one(struct sk_buff *rsp, struct net_device *netdev,
 			 u32 q_idx, u32 q_type, const struct genl_info *info)
@@ -433,6 +457,9 @@ netdev_nl_queue_fill_one(struct sk_buff *rsp, struct net_device *netdev,
 		break;
 	}
 
+	if (netdev_nl_queue_fill_cfg(rsp, netdev, q_idx, q_type))
+		goto nla_put_failure;
+
 	genlmsg_end(rsp, hdr);
 
 	return 0;
@@ -572,6 +599,71 @@ int netdev_nl_queue_get_dumpit(struct sk_buff *skb, struct netlink_callback *cb)
 	return err;
 }
 
+int netdev_nl_queue_set_doit(struct sk_buff *skb, struct genl_info *info)
+{
+	struct nlattr * const *tb = info->attrs;
+	struct netdev_queue_config *qcfg;
+	u32 q_id, q_type, ifindex;
+	struct net_device *netdev;
+	bool mod;
+	int ret;
+
+	if (GENL_REQ_ATTR_CHECK(info, NETDEV_A_QUEUE_ID) ||
+	    GENL_REQ_ATTR_CHECK(info, NETDEV_A_QUEUE_TYPE) ||
+	    GENL_REQ_ATTR_CHECK(info, NETDEV_A_QUEUE_IFINDEX))
+		return -EINVAL;
+
+	q_id = nla_get_u32(tb[NETDEV_A_QUEUE_ID]);
+	q_type = nla_get_u32(tb[NETDEV_A_QUEUE_TYPE]);
+	ifindex = nla_get_u32(tb[NETDEV_A_QUEUE_IFINDEX]);
+
+	if (q_type != NETDEV_QUEUE_TYPE_RX) {
+		/* Only Rx params exist right now */
+		NL_SET_BAD_ATTR(info->extack, tb[NETDEV_A_QUEUE_TYPE]);
+		return -EINVAL;
+	}
+
+	ret = 0;
+	netdev = netdev_get_by_index_lock(genl_info_net(info), ifindex);
+	if (!netdev || !netif_device_present(netdev))
+		ret = -ENODEV;
+	else if (!netdev->queue_mgmt_ops)
+		ret = -EOPNOTSUPP;
+	if (ret) {
+		NL_SET_BAD_ATTR(info->extack, tb[NETDEV_A_QUEUE_IFINDEX]);
+		goto exit_unlock;
+	}
+
+	ret = netdev_nl_queue_validate(netdev, q_id, q_type);
+	if (ret) {
+		NL_SET_BAD_ATTR(info->extack, tb[NETDEV_A_QUEUE_ID]);
+		goto exit_unlock;
+	}
+
+	ret = netdev_reconfig_start(netdev);
+	if (ret)
+		goto exit_unlock;
+
+	qcfg = &netdev->cfg_pending->qcfg[q_id];
+	mod = nla_update_u32(&qcfg->rx_buf_len, tb[NETDEV_A_QUEUE_RX_BUF_LEN]);
+	if (!mod)
+		goto exit_free_cfg;
+
+	ret = netdev_rx_queue_restart(netdev, q_id, info->extack);
+	if (ret)
+		goto exit_free_cfg;
+
+	swap(netdev->cfg, netdev->cfg_pending);
+
+exit_free_cfg:
+	__netdev_free_config(netdev->cfg_pending);
+	netdev->cfg_pending = netdev->cfg;
+exit_unlock:
+	if (netdev)
+		netdev_unlock(netdev);
+	return ret;
+}
+
 #define NETDEV_STAT_NOT_SET		(~0ULL)
 
 static void netdev_nl_stats_add(void *_sum, const void *_add, size_t size)
diff --git a/net/core/netdev_config.c b/net/core/netdev_config.c
index fc700b77e4eb..ede02b77470e 100644
--- a/net/core/netdev_config.c
+++ b/net/core/netdev_config.c
@@ -67,11 +67,27 @@ int netdev_reconfig_start(struct net_device *dev)
 void __netdev_queue_config(struct net_device *dev, int rxq,
 			   struct netdev_queue_config *qcfg, bool pending)
 {
+	const struct netdev_config *cfg;
+
+	cfg = pending ? dev->cfg_pending : dev->cfg;
+
 	memset(qcfg, 0, sizeof(*qcfg));
 
 	/* Get defaults from the driver, in case user config not set */
 	if (dev->queue_mgmt_ops->ndo_queue_cfg_defaults)
 		dev->queue_mgmt_ops->ndo_queue_cfg_defaults(dev, rxq, qcfg);
+
+	/* Set config based on device-level settings */
+	if (cfg->rx_buf_len)
+		qcfg->rx_buf_len = cfg->rx_buf_len;
+
+	/* Set config dedicated to this queue */
+	if (rxq >= 0) {
+		const struct netdev_queue_config *user_cfg = &cfg->qcfg[rxq];
+
+		if (user_cfg->rx_buf_len)
+			qcfg->rx_buf_len = user_cfg->rx_buf_len;
+	}
 }
 
 /**
diff --git a/tools/include/uapi/linux/netdev.h b/tools/include/uapi/linux/netdev.h
index 48eb49aa03d4..820f89b67a72 100644
--- a/tools/include/uapi/linux/netdev.h
+++ b/tools/include/uapi/linux/netdev.h
@@ -158,6 +158,7 @@ enum {
 	NETDEV_A_QUEUE_DMABUF,
 	NETDEV_A_QUEUE_IO_URING,
 	NETDEV_A_QUEUE_XSK,
+	NETDEV_A_QUEUE_RX_BUF_LEN,
 
 	__NETDEV_A_QUEUE_MAX,
 	NETDEV_A_QUEUE_MAX = (__NETDEV_A_QUEUE_MAX - 1)
@@ -226,6 +227,7 @@ enum {
 	NETDEV_CMD_BIND_RX,
 	NETDEV_CMD_NAPI_SET,
 	NETDEV_CMD_BIND_TX,
+	NETDEV_CMD_QUEUE_SET,
 
 	__NETDEV_CMD_MAX,
 	NETDEV_CMD_MAX = (__NETDEV_CMD_MAX - 1)
-- 
2.49.0


