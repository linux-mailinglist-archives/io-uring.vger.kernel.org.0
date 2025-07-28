Return-Path: <io-uring+bounces-8829-lists+io-uring=lfdr.de@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [139.178.88.99])
	by mail.lfdr.de (Postfix) with ESMTPS id 9FB38B13994
	for <lists+io-uring@lfdr.de>; Mon, 28 Jul 2025 13:06:12 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 0BFF73BDF27
	for <lists+io-uring@lfdr.de>; Mon, 28 Jul 2025 11:04:40 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 6D87426463B;
	Mon, 28 Jul 2025 11:03:42 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="jh/iaVV1"
X-Original-To: io-uring@vger.kernel.org
Received: from mail-wm1-f50.google.com (mail-wm1-f50.google.com [209.85.128.50])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5546A264638;
	Mon, 28 Jul 2025 11:03:38 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.128.50
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1753700622; cv=none; b=Tvx6sbfV7nIu6QpTE4kNG4+eG35/G5MaxqS4pFO5zoua7OyFdLLnJnW27EM4AwoWFiu9wowM+KHP1Xgtl2AfAlD/wpC36W3XCE4Qmn4S/xxB0zFUcCzPkEgKIqwv9glowVxyEw/8/wMKfrIa8BUAs7LWCYjqYB/Jm8JqbLf6H3E=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1753700622; c=relaxed/simple;
	bh=MOYfhlQUTRo44dhkqbQEalJMeYCf6lWFNyV3noXKqZI=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=qnx2NnaZHfx2DJ7WFQ/RpLY7viT5BIC29rcmmg/RhzwphGVa8ux2p5AMPbzObs22PC5uTjgPUO0Ae196TNg3QbinGpKRpqPqZFEcRy26D3Fm56AfCAo26Z4kV22XNMklLk8BCbYVM4y1y7oJuF+yCTAX5PGfD7rMkUq6TNJKS8o=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=jh/iaVV1; arc=none smtp.client-ip=209.85.128.50
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Received: by mail-wm1-f50.google.com with SMTP id 5b1f17b1804b1-4561a4a8bf2so48251715e9.1;
        Mon, 28 Jul 2025 04:03:38 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1753700617; x=1754305417; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=3aIHOu0agWerK4KdkqjSh1PwY21jcrIA9F0ZwYm7qyU=;
        b=jh/iaVV1a7nD9hsyi5LfO61En3qEClREWIwLByPF26y+RDWWgI3d85Wtv7OnZzK/tb
         9shPLHzRoIjwZ5XXBJtiZRmi/rehAAFAu1FHqNlkbT6jSbdoT07iqAW5iaPmf+9UaxFW
         NHuSQ5ESIWBJJHLL3CHRr2fCqujsPV6lI5scVMgILDgArVk6dnO2suQkVQjL2lPVG9Aw
         8NQYtafy0N1GhaRZ33jI80JR91HnWUDYFAJG6vKFUYXLRknWWCQOORJzQsglFjSgyf88
         jy53vzIW6Af3zmnhzgVmM3/f7cFepcFUnOTUmhiL+zhovkKa1ZUPTygaZ9yrAY/F28NU
         1kuw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1753700617; x=1754305417;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=3aIHOu0agWerK4KdkqjSh1PwY21jcrIA9F0ZwYm7qyU=;
        b=L0sXNdvw4CV2vCYbXXnkmn6Uwd+FY2c3N479DNoTSz/ce2qw2YzmKIEOu35qzglEeI
         oZ2yPeaNk+iVJjAusJ6l3CSDbSKc3otuHXT1LE0a0Wmr8gV1a6clRPu2Aaugq6Xms4kG
         kh63MDJNYttiAOw5jnYttOI/SI1TvhRm+YosJsYNvnRhDVIwmq3AN/6dWYXateKTKpzK
         bUYPmpNUpKB/KozjsrtQWNG9nfpP6aQzOvD4u4BA9iQt5+1yRNWsHtpah83TpAopSfZl
         Erh6KAqKvn1p6nE5+BSecKyavLR8yKxFXyXZ63a5DHMLUDATrN2Gt2NgRfXBDXVX2b/l
         De8Q==
X-Forwarded-Encrypted: i=1; AJvYcCUqyaAHL/PQJOryzlHP95FgC1ZSk1vGXQy7rCmzByxvXElAIMUTkR3yjylA6H+V1oB6ezAN9qDuwQ==@vger.kernel.org, AJvYcCVmtXV3xVYUlFbDzPGh/aUYbJpSKjOsaW4Kkt3w8XVGkcm3FsMcgCykX2KUAWsetNvRZy0jaZYm@vger.kernel.org
X-Gm-Message-State: AOJu0YzHtKTPLE0zt8hWjL/yW8SXLqIZmMcj9hG+E5/E6iOhsegv44Y4
	r2iMeUJ8iW755VrqKWA1LdiHzricWLbUThe+Sp8aoeGAEFeYs01ZHIhBp32EYg==
X-Gm-Gg: ASbGncuF8uh9FYYNJGqZ/ZZ8UIQnt9PamefYQUZWtfQ2y6lb6W5ijmYzuYDaaMCJ1Es
	CjI61qC2ITuy160J8KUaHqDTHr869fy1zwpzwc/BDGvNPRO2/nf6UcyG04ZvYzQ32nrMQ4+EwPI
	+kefU8vqAgON11DFxRzikUwRWDtVGgHvk9D9p4PFWfaqPzcvV7/PrXdtUG/90bsqCUmcAxlTPN3
	G66ukSEOJVhgNQq2BKiSb730qrMu9uG6EK6Oz4qnVsuP6tKkQEES5ZtAZjDxOakMmR88S/gh3a3
	PHhLDK1atjYzxJPKZBgHkn/QJNSq77MTCar8tB+yxfzJwruhbzGD+sw4StDMw4U2ZLADg6bCUDA
	yLlMnEnlYs8NDrQ==
X-Google-Smtp-Source: AGHT+IFZuDhA4fhPZjGuhsvIBFn7CWdYfNMMp5KCEThI+vAVxFwGQaOfHiFn/uDKy+PuUHopdhgt/g==
X-Received: by 2002:a05:600c:c173:b0:456:28d4:ef1 with SMTP id 5b1f17b1804b1-45877c53a3dmr77694155e9.29.1753700617098;
        Mon, 28 Jul 2025 04:03:37 -0700 (PDT)
Received: from 127.com ([2620:10d:c092:600::1:75])
        by smtp.gmail.com with ESMTPSA id 5b1f17b1804b1-458705c4fdasm157410235e9.28.2025.07.28.04.03.35
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 28 Jul 2025 04:03:36 -0700 (PDT)
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
Subject: [RFC v1 17/22] netdev: add support for setting rx-buf-len per queue
Date: Mon, 28 Jul 2025 12:04:21 +0100
Message-ID: <4db7b749277d4c0723f448cb143dab66959d618c.1753694914.git.asml.silence@gmail.com>
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
index c0ef6d0d7786..5dd1eb5909cd 100644
--- a/Documentation/netlink/specs/netdev.yaml
+++ b/Documentation/netlink/specs/netdev.yaml
@@ -324,6 +324,10 @@ attribute-sets:
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
@@ -755,6 +759,17 @@ operations:
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
   headers: [ "net/netdev_netlink.h"]
diff --git a/include/net/netdev_queues.h b/include/net/netdev_queues.h
index f75313fc78ba..cfd2d59861e1 100644
--- a/include/net/netdev_queues.h
+++ b/include/net/netdev_queues.h
@@ -38,6 +38,7 @@ struct netdev_config {
 
 /* Same semantics as fields in struct netdev_config */
 struct netdev_queue_config {
+	u32	rx_buf_len;
 };
 
 /* See the netdev.yaml spec for definition of each statistic */
@@ -140,6 +141,8 @@ void netdev_stat_queue_sum(struct net_device *netdev,
 /**
  * struct netdev_queue_mgmt_ops - netdev ops for queue management
  *
+ * @supported_ring_params: ring params supported per queue (ETHTOOL_RING_USE_*).
+ *
  * @ndo_queue_mem_size: Size of the struct that describes a queue's memory.
  *
  * @ndo_queue_cfg_defaults: (Optional) Populate queue config struct with
@@ -170,6 +173,8 @@ void netdev_stat_queue_sum(struct net_device *netdev,
  * be called for an interface which is open.
  */
 struct netdev_queue_mgmt_ops {
+	u32     supported_ring_params;
+
 	size_t	ndo_queue_mem_size;
 	void	(*ndo_queue_cfg_defaults)(struct net_device *dev,
 					  int idx,
diff --git a/include/net/netlink.h b/include/net/netlink.h
index 90a560dc167a..c892cae8f592 100644
--- a/include/net/netlink.h
+++ b/include/net/netlink.h
@@ -2186,6 +2186,25 @@ static inline struct nla_bitfield32 nla_get_bitfield32(const struct nlattr *nla)
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
index 7eb9571786b8..98fa988c8db2 100644
--- a/include/uapi/linux/netdev.h
+++ b/include/uapi/linux/netdev.h
@@ -152,6 +152,7 @@ enum {
 	NETDEV_A_QUEUE_DMABUF,
 	NETDEV_A_QUEUE_IO_URING,
 	NETDEV_A_QUEUE_XSK,
+	NETDEV_A_QUEUE_RX_BUF_LEN,
 
 	__NETDEV_A_QUEUE_MAX,
 	NETDEV_A_QUEUE_MAX = (__NETDEV_A_QUEUE_MAX - 1)
@@ -220,6 +221,7 @@ enum {
 	NETDEV_CMD_BIND_RX,
 	NETDEV_CMD_NAPI_SET,
 	NETDEV_CMD_BIND_TX,
+	NETDEV_CMD_QUEUE_SET,
 
 	__NETDEV_CMD_MAX,
 	NETDEV_CMD_MAX = (__NETDEV_CMD_MAX - 1)
diff --git a/net/core/netdev-genl-gen.c b/net/core/netdev-genl-gen.c
index 4fc44587f493..ac25584a829d 100644
--- a/net/core/netdev-genl-gen.c
+++ b/net/core/netdev-genl-gen.c
@@ -105,6 +105,14 @@ static const struct nla_policy netdev_bind_tx_nl_policy[NETDEV_A_DMABUF_FD + 1]
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
@@ -203,6 +211,13 @@ static const struct genl_split_ops netdev_nl_ops[] = {
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
index 2afa7b2141aa..52ec8287e835 100644
--- a/net/core/netdev-genl.c
+++ b/net/core/netdev-genl.c
@@ -372,6 +372,30 @@ static int nla_put_napi_id(struct sk_buff *skb, const struct napi_struct *napi)
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
@@ -419,6 +443,9 @@ netdev_nl_queue_fill_one(struct sk_buff *rsp, struct net_device *netdev,
 		break;
 	}
 
+	if (netdev_nl_queue_fill_cfg(rsp, netdev, q_idx, q_type))
+		goto nla_put_failure;
+
 	genlmsg_end(rsp, hdr);
 
 	return 0;
@@ -558,6 +585,71 @@ int netdev_nl_queue_get_dumpit(struct sk_buff *skb, struct netlink_callback *cb)
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
index 7eb9571786b8..98fa988c8db2 100644
--- a/tools/include/uapi/linux/netdev.h
+++ b/tools/include/uapi/linux/netdev.h
@@ -152,6 +152,7 @@ enum {
 	NETDEV_A_QUEUE_DMABUF,
 	NETDEV_A_QUEUE_IO_URING,
 	NETDEV_A_QUEUE_XSK,
+	NETDEV_A_QUEUE_RX_BUF_LEN,
 
 	__NETDEV_A_QUEUE_MAX,
 	NETDEV_A_QUEUE_MAX = (__NETDEV_A_QUEUE_MAX - 1)
@@ -220,6 +221,7 @@ enum {
 	NETDEV_CMD_BIND_RX,
 	NETDEV_CMD_NAPI_SET,
 	NETDEV_CMD_BIND_TX,
+	NETDEV_CMD_QUEUE_SET,
 
 	__NETDEV_CMD_MAX,
 	NETDEV_CMD_MAX = (__NETDEV_CMD_MAX - 1)
-- 
2.49.0


