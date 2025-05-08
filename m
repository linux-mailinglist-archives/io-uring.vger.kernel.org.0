Return-Path: <io-uring+bounces-7899-lists+io-uring=lfdr.de@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [IPv6:2604:1380:45d1:ec00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 989A2AAF025
	for <lists+io-uring@lfdr.de>; Thu,  8 May 2025 02:49:43 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id 04CB4500EFB
	for <lists+io-uring@lfdr.de>; Thu,  8 May 2025 00:49:44 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 7FC431DC075;
	Thu,  8 May 2025 00:48:40 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="G03+Jp8P"
X-Original-To: io-uring@vger.kernel.org
Received: from mail-pj1-f73.google.com (mail-pj1-f73.google.com [209.85.216.73])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 568AD1A5BA6
	for <io-uring@vger.kernel.org>; Thu,  8 May 2025 00:48:38 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.216.73
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1746665320; cv=none; b=FqquYom2/hllcTkKjqI0AG7xIqb9e5NgnbBoBUGw6vvcuCbjai9WTddUFjC5yHsUCYibJC17bSU9IjWvm+AHNXxI96wWQg59jzqDbwU2gfWfYIgn8zTx6t1Yc7WLFYn6k1PE54p8AHQpM9xz3MhI2D0On+4fVRolJW/WgsSqt9E=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1746665320; c=relaxed/simple;
	bh=tkF+WM1as8AMZrjftw0ZklT5Vwj2gs7cOGIEwT4XG3A=;
	h=Date:In-Reply-To:Mime-Version:References:Message-ID:Subject:From:
	 To:Cc:Content-Type; b=o38Hx57zYAeFMnYi4nq5JqFb8g3AplIvfHTx9XzPoonz1yvf0ypKFMR8oWhW6zdOfHb4dpjT6FGpMHnw63Dxd0gkcOXGujQ26Y3zVjarkqo0gYCVG4cCtevslVZsvua9Aeg24qvu9oaesXSu+FUiSoACRYAH7peBPYj2bmEcGrI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=flex--almasrymina.bounces.google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=G03+Jp8P; arc=none smtp.client-ip=209.85.216.73
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=flex--almasrymina.bounces.google.com
Received: by mail-pj1-f73.google.com with SMTP id 98e67ed59e1d1-30c06465976so167796a91.0
        for <io-uring@vger.kernel.org>; Wed, 07 May 2025 17:48:38 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1746665318; x=1747270118; darn=vger.kernel.org;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:from:to:cc:subject:date:message-id:reply-to;
        bh=BK/olUtKxzz6g7493MeBHcvCN1wA7OwLTEGU/g/qO6o=;
        b=G03+Jp8PoOy9l6qWIrLW7+RELAs9nINRbP3Ydw80JJyRrm/OuQ9VIOXMRbqn7L0wya
         a4JGBvAstC7vqaGic3uihHRr1BrJX/KXnFaE+bL5H4NdQR9t+aJxD7HJYflfDOp8xxHe
         0jhhkeh/PiBdNejGUcr7RwMlw5iUR68Mao/x+kbcqWVfr3bVszrokIqgsr3krdhiCWeq
         9JUJpc8HSnlNQ5v29YNh1DMFvROqhnrssWHJZhh6OfJoJahU95cY2JKBKPOoEhbk33j0
         v87+nO7SX+mXm84LM8mCHINfnfa8/rh8rRs+cv2Bqw9TOwka5MgpNO2FRUMUQXoEaFq7
         fc2Q==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1746665318; x=1747270118;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=BK/olUtKxzz6g7493MeBHcvCN1wA7OwLTEGU/g/qO6o=;
        b=egGliB/7BBQ20W7/0mSfyQ3ZDtziiTJdjQjU/5tlxrHy8qPM0qCzPlC6nPdxA2r8dE
         9twkCVS6UNm98zkKBIagIJNcqdEmDeDGHktCkZYbeQABHlWNVtoWSNnuY1ju3eW+VMd0
         3BOQtzdtdMTZzqJx33CtcJ4HqXPLaYL/01Glb47wFC6Eu8gmSyZGa9E+pSuS0UHB1lgj
         UBWHizr1N6NMQCoUvbo0Nzj33U79+A35hqZSfiNZHyunuVRhBndUTlvVzvwNPFnDTQuL
         EvMCR1LOUrqCu2ccr07mOFc/SZI2lmHlKFPwptQE72En4jb5ed9FEl6M6QGG2enFKccf
         gBpw==
X-Forwarded-Encrypted: i=1; AJvYcCWUtVDfeG4g5rlR2Db8q2/mkbPcLjKzBk8iuP1AFodnBTsIwYBbjEjn60FqtOCrDRWUppGH1iUJrQ==@vger.kernel.org
X-Gm-Message-State: AOJu0YzqB3DYliQP9dj2NL+JotbZLscAIarN8aNQKuVIuSanPW3CoKky
	clIMMdCb5CYC2QX4zFhLLRLj9R3HmBhxmwLhsTi3ZUuHkeRz0qNyWGM6oqHg1LbyRr2ZtpGErfI
	EWOAhbHcMczGf9aqFALYmAA==
X-Google-Smtp-Source: AGHT+IEORzeMQ1yw8JX0LBzJ49McEf43iLt2XkuQ1cA3MmMcj7NSD/O+CbFXAIpE2g0v4lMJL8MK8cHDWcD3Iw+dNw==
X-Received: from pjyp7.prod.google.com ([2002:a17:90a:e707:b0:309:f831:28e0])
 (user=almasrymina job=prod-delivery.src-stubby-dispatcher) by
 2002:a17:90a:ec85:b0:305:2d68:8d55 with SMTP id 98e67ed59e1d1-30b3a65ded4mr1687986a91.8.1746665317530;
 Wed, 07 May 2025 17:48:37 -0700 (PDT)
Date: Thu,  8 May 2025 00:48:23 +0000
In-Reply-To: <20250508004830.4100853-1-almasrymina@google.com>
Precedence: bulk
X-Mailing-List: io-uring@vger.kernel.org
List-Id: <io-uring.vger.kernel.org>
List-Subscribe: <mailto:io-uring+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:io-uring+unsubscribe@vger.kernel.org>
Mime-Version: 1.0
References: <20250508004830.4100853-1-almasrymina@google.com>
X-Mailer: git-send-email 2.49.0.987.g0cc8ee98dc-goog
Message-ID: <20250508004830.4100853-4-almasrymina@google.com>
Subject: [PATCH net-next v14 3/9] net: devmem: TCP tx netlink api
From: Mina Almasry <almasrymina@google.com>
To: netdev@vger.kernel.org, linux-kernel@vger.kernel.org, 
	linux-doc@vger.kernel.org, io-uring@vger.kernel.org, 
	virtualization@lists.linux.dev, kvm@vger.kernel.org, 
	linux-kselftest@vger.kernel.org
Cc: Mina Almasry <almasrymina@google.com>, Donald Hunter <donald.hunter@gmail.com>, 
	Jakub Kicinski <kuba@kernel.org>, "David S. Miller" <davem@davemloft.net>, 
	Eric Dumazet <edumazet@google.com>, Paolo Abeni <pabeni@redhat.com>, Simon Horman <horms@kernel.org>, 
	Jonathan Corbet <corbet@lwn.net>, Andrew Lunn <andrew+netdev@lunn.ch>, 
	Jeroen de Borst <jeroendb@google.com>, Harshitha Ramamurthy <hramamurthy@google.com>, 
	Kuniyuki Iwashima <kuniyu@amazon.com>, Willem de Bruijn <willemb@google.com>, Jens Axboe <axboe@kernel.dk>, 
	Pavel Begunkov <asml.silence@gmail.com>, David Ahern <dsahern@kernel.org>, 
	Neal Cardwell <ncardwell@google.com>, "Michael S. Tsirkin" <mst@redhat.com>, Jason Wang <jasowang@redhat.com>, 
	Xuan Zhuo <xuanzhuo@linux.alibaba.com>, 
	"=?UTF-8?q?Eugenio=20P=C3=A9rez?=" <eperezma@redhat.com>, Stefan Hajnoczi <stefanha@redhat.com>, 
	Stefano Garzarella <sgarzare@redhat.com>, Shuah Khan <shuah@kernel.org>, sdf@fomichev.me, dw@davidwei.uk, 
	Jamal Hadi Salim <jhs@mojatatu.com>, Victor Nogueira <victor@mojatatu.com>, 
	Pedro Tammela <pctammela@mojatatu.com>, Samiullah Khawaja <skhawaja@google.com>
Content-Type: text/plain; charset="UTF-8"

From: Stanislav Fomichev <sdf@fomichev.me>

Add bind-tx netlink call to attach dmabuf for TX; queue is not
required, only ifindex and dmabuf fd for attachment.

Signed-off-by: Stanislav Fomichev <sdf@fomichev.me>
Signed-off-by: Mina Almasry <almasrymina@google.com>

---

v3:
- Fix ynl-regen.sh error (Simon).

---
 Documentation/netlink/specs/netdev.yaml | 12 ++++++++++++
 include/uapi/linux/netdev.h             |  1 +
 net/core/netdev-genl-gen.c              | 13 +++++++++++++
 net/core/netdev-genl-gen.h              |  1 +
 net/core/netdev-genl.c                  |  6 ++++++
 tools/include/uapi/linux/netdev.h       |  1 +
 6 files changed, 34 insertions(+)

diff --git a/Documentation/netlink/specs/netdev.yaml b/Documentation/netlink/specs/netdev.yaml
index f5e0750ab71db..c0ef6d0d77865 100644
--- a/Documentation/netlink/specs/netdev.yaml
+++ b/Documentation/netlink/specs/netdev.yaml
@@ -743,6 +743,18 @@ operations:
             - defer-hard-irqs
             - gro-flush-timeout
             - irq-suspend-timeout
+    -
+      name: bind-tx
+      doc: Bind dmabuf to netdev for TX
+      attribute-set: dmabuf
+      do:
+        request:
+          attributes:
+            - ifindex
+            - fd
+        reply:
+          attributes:
+            - id
 
 kernel-family:
   headers: [ "net/netdev_netlink.h"]
diff --git a/include/uapi/linux/netdev.h b/include/uapi/linux/netdev.h
index 7600bf62dbdf0..7eb9571786b83 100644
--- a/include/uapi/linux/netdev.h
+++ b/include/uapi/linux/netdev.h
@@ -219,6 +219,7 @@ enum {
 	NETDEV_CMD_QSTATS_GET,
 	NETDEV_CMD_BIND_RX,
 	NETDEV_CMD_NAPI_SET,
+	NETDEV_CMD_BIND_TX,
 
 	__NETDEV_CMD_MAX,
 	NETDEV_CMD_MAX = (__NETDEV_CMD_MAX - 1)
diff --git a/net/core/netdev-genl-gen.c b/net/core/netdev-genl-gen.c
index 739f7b6506a6a..4fc44587f4936 100644
--- a/net/core/netdev-genl-gen.c
+++ b/net/core/netdev-genl-gen.c
@@ -99,6 +99,12 @@ static const struct nla_policy netdev_napi_set_nl_policy[NETDEV_A_NAPI_IRQ_SUSPE
 	[NETDEV_A_NAPI_IRQ_SUSPEND_TIMEOUT] = { .type = NLA_UINT, },
 };
 
+/* NETDEV_CMD_BIND_TX - do */
+static const struct nla_policy netdev_bind_tx_nl_policy[NETDEV_A_DMABUF_FD + 1] = {
+	[NETDEV_A_DMABUF_IFINDEX] = NLA_POLICY_MIN(NLA_U32, 1),
+	[NETDEV_A_DMABUF_FD] = { .type = NLA_U32, },
+};
+
 /* Ops table for netdev */
 static const struct genl_split_ops netdev_nl_ops[] = {
 	{
@@ -190,6 +196,13 @@ static const struct genl_split_ops netdev_nl_ops[] = {
 		.maxattr	= NETDEV_A_NAPI_IRQ_SUSPEND_TIMEOUT,
 		.flags		= GENL_ADMIN_PERM | GENL_CMD_CAP_DO,
 	},
+	{
+		.cmd		= NETDEV_CMD_BIND_TX,
+		.doit		= netdev_nl_bind_tx_doit,
+		.policy		= netdev_bind_tx_nl_policy,
+		.maxattr	= NETDEV_A_DMABUF_FD,
+		.flags		= GENL_CMD_CAP_DO,
+	},
 };
 
 static const struct genl_multicast_group netdev_nl_mcgrps[] = {
diff --git a/net/core/netdev-genl-gen.h b/net/core/netdev-genl-gen.h
index 17d39fd64c948..cf3fad74511f5 100644
--- a/net/core/netdev-genl-gen.h
+++ b/net/core/netdev-genl-gen.h
@@ -34,6 +34,7 @@ int netdev_nl_qstats_get_dumpit(struct sk_buff *skb,
 				struct netlink_callback *cb);
 int netdev_nl_bind_rx_doit(struct sk_buff *skb, struct genl_info *info);
 int netdev_nl_napi_set_doit(struct sk_buff *skb, struct genl_info *info);
+int netdev_nl_bind_tx_doit(struct sk_buff *skb, struct genl_info *info);
 
 enum {
 	NETDEV_NLGRP_MGMT,
diff --git a/net/core/netdev-genl.c b/net/core/netdev-genl.c
index 2a1a399fc15d2..919ce851f1174 100644
--- a/net/core/netdev-genl.c
+++ b/net/core/netdev-genl.c
@@ -937,6 +937,12 @@ int netdev_nl_bind_rx_doit(struct sk_buff *skb, struct genl_info *info)
 	return err;
 }
 
+/* stub */
+int netdev_nl_bind_tx_doit(struct sk_buff *skb, struct genl_info *info)
+{
+	return 0;
+}
+
 void netdev_nl_sock_priv_init(struct netdev_nl_sock *priv)
 {
 	INIT_LIST_HEAD(&priv->bindings);
diff --git a/tools/include/uapi/linux/netdev.h b/tools/include/uapi/linux/netdev.h
index 7600bf62dbdf0..7eb9571786b83 100644
--- a/tools/include/uapi/linux/netdev.h
+++ b/tools/include/uapi/linux/netdev.h
@@ -219,6 +219,7 @@ enum {
 	NETDEV_CMD_QSTATS_GET,
 	NETDEV_CMD_BIND_RX,
 	NETDEV_CMD_NAPI_SET,
+	NETDEV_CMD_BIND_TX,
 
 	__NETDEV_CMD_MAX,
 	NETDEV_CMD_MAX = (__NETDEV_CMD_MAX - 1)
-- 
2.49.0.987.g0cc8ee98dc-goog


