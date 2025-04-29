Return-Path: <io-uring+bounces-7774-lists+io-uring=lfdr.de@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [IPv6:2604:1380:45e3:2400::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 7C9E8AA0057
	for <lists+io-uring@lfdr.de>; Tue, 29 Apr 2025 05:28:09 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 1F31A3BF502
	for <lists+io-uring@lfdr.de>; Tue, 29 Apr 2025 03:27:51 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 329E02749EA;
	Tue, 29 Apr 2025 03:26:56 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="CfedDe7L"
X-Original-To: io-uring@vger.kernel.org
Received: from mail-pf1-f201.google.com (mail-pf1-f201.google.com [209.85.210.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 089E82741D4
	for <io-uring@vger.kernel.org>; Tue, 29 Apr 2025 03:26:53 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.210.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1745897216; cv=none; b=e5C1bjC3k36bkP04odTVsibVRPd1ofMfXCIhRKkXrGmUg7lRNbZ9GEW8xiMISTmXZoaL+U3dQqGrCMxQ8BEKHmcfHtGmPtfUNtaotkmTn1HKoix/D6SqD/sM2eyd2xHwpmi1AI2O9j3jMERJILMKvOJtbx3T1XFXepAoQbArDCw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1745897216; c=relaxed/simple;
	bh=YB1mutMSKbaQasQDLVhSuAGFhy+albYp7NJnhaOP2Z0=;
	h=Date:In-Reply-To:Mime-Version:References:Message-ID:Subject:From:
	 To:Cc:Content-Type; b=hUxVgbmWXTFHWiSIhFky6KNCTzQy361xojWE1xWk57DcTN/R99hZWoO4g4f+DtuaoBwhnwuSNhbXsyiV2FlFG1PjkfwUqLiTl4ULltt2lEtO0gI1dBTmJ1oIW5Ao2vWDBkYCU9Aj6yxCFTmqgg+FY392s/Woi+MBoEWMQrzl0U0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=flex--almasrymina.bounces.google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=CfedDe7L; arc=none smtp.client-ip=209.85.210.201
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=flex--almasrymina.bounces.google.com
Received: by mail-pf1-f201.google.com with SMTP id d2e1a72fcca58-7391d68617cso5303181b3a.0
        for <io-uring@vger.kernel.org>; Mon, 28 Apr 2025 20:26:53 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1745897213; x=1746502013; darn=vger.kernel.org;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:from:to:cc:subject:date:message-id:reply-to;
        bh=wtgnXQOQRcIqqTCsidK0zKoiXhB8fSgu5a7dWwM8MV4=;
        b=CfedDe7Lvf7HoqRjJnY987Qycho1wz1/fpLIyqmmjrrTmVTOYkj5EsTxqVSasR8JMD
         HKiAKFW03xBvpb9y/Ok26dFLzt0dj54wg2D4DiVhF2EhtYY/or+fAngv59yg7PKkqNIx
         JBSKjDuKB/hRKRWkaeJ8nALY1xomVvUP55LZmw5fbcsY9SXg+iLxxdRQHIWm/LaLM63Q
         fh6EUsS2JT0k8g+blw4eGOFyuzCMdgs84V30grU/w0CTg4upkK29j2bkJIqTs3hG1Rv8
         KyHKwcQ4iCAg6kpOmVlA6DXqEvVnb5oAkNEwAwKThrfLw6r2VZshl0oY7MUsruH7zqys
         hCeg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1745897213; x=1746502013;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=wtgnXQOQRcIqqTCsidK0zKoiXhB8fSgu5a7dWwM8MV4=;
        b=QJH/sFqSTuYCcOUp4a6OdVj5ZuUZ/5Lex/mgZe2WZz20OckpOgiGeA4TnHfF/cILGL
         hUkEu2vdZ37RutNndONrqtfGEO4Hz3LBz91/s/4abtxsr5bYzoZX07cFMvSfRLsIBgV/
         +Rdz/u6m4hiNEZLysmtPr3gRVlj96M2UwBitpyuAK+wtwFB0mjgbOob2doeEdiL3jLef
         QbBkj1PPHHekDNgFUflIGxGXPWzK5+JtxkEl/dblBwXegBot75Mg1TIoFvo5HraTdiLX
         Pvt2hCwD1HQNcRtPJp70NvFJ1NZ0OuSDf3YyfSCCbl/7BCm+fqHCfrU8sNLWWrZgR7GW
         Oamw==
X-Forwarded-Encrypted: i=1; AJvYcCXq1o3/5h4+gC7fXG2iojeCbdUUX+ePJHSNdHs0HEHjI8J5zltobSEmx4W9cmAq0uJjmWRcFtQ47w==@vger.kernel.org
X-Gm-Message-State: AOJu0Ywxl+OOlVQjWtq+D3fLoNfFYYvA6xL7wQV4URpWlrNtU0xHgO1m
	cmtKZCrBlFoMRx6dLKx16PEbygT9CXcj3LPaN8B7pKLIQTjc8o1wui6TGdpOfoeFvW9ZMKqvY0k
	ptseKFAgL15SulqXa9qHa1Q==
X-Google-Smtp-Source: AGHT+IGvWlY/glrlef9Mo9UDeLC84iRK+6a/2Ngn+n8lGcE/c9SSbaaz5avQkkZFj/oJ7icm3CBYsxgbEeUR1Ilejw==
X-Received: from pgbfe21.prod.google.com ([2002:a05:6a02:2895:b0:b15:27b5:b663])
 (user=almasrymina job=prod-delivery.src-stubby-dispatcher) by
 2002:a05:6a21:101b:b0:1f0:e6db:b382 with SMTP id adf61e73a8af0-2094f6705e2mr2301290637.8.1745897213221;
 Mon, 28 Apr 2025 20:26:53 -0700 (PDT)
Date: Tue, 29 Apr 2025 03:26:39 +0000
In-Reply-To: <20250429032645.363766-1-almasrymina@google.com>
Precedence: bulk
X-Mailing-List: io-uring@vger.kernel.org
List-Id: <io-uring.vger.kernel.org>
List-Subscribe: <mailto:io-uring+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:io-uring+unsubscribe@vger.kernel.org>
Mime-Version: 1.0
References: <20250429032645.363766-1-almasrymina@google.com>
X-Mailer: git-send-email 2.49.0.901.g37484f566f-goog
Message-ID: <20250429032645.363766-4-almasrymina@google.com>
Subject: [PATCH net-next v13 3/9] net: devmem: TCP tx netlink api
From: Mina Almasry <almasrymina@google.com>
To: netdev@vger.kernel.org, linux-kernel@vger.kernel.org, 
	linux-doc@vger.kernel.org, io-uring@vger.kernel.org, 
	virtualization@lists.linux.dev, kvm@vger.kernel.org, 
	linux-kselftest@vger.kernel.org
Cc: Mina Almasry <almasrymina@google.com>, "David S. Miller" <davem@davemloft.net>, 
	Eric Dumazet <edumazet@google.com>, Jakub Kicinski <kuba@kernel.org>, Paolo Abeni <pabeni@redhat.com>, 
	Simon Horman <horms@kernel.org>, Donald Hunter <donald.hunter@gmail.com>, 
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
2.49.0.901.g37484f566f-goog


