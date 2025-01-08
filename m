Return-Path: <io-uring+bounces-5762-lists+io-uring=lfdr.de@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from sy.mirrors.kernel.org (sy.mirrors.kernel.org [IPv6:2604:1380:40f1:3f00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id C1EA5A067DA
	for <lists+io-uring@lfdr.de>; Wed,  8 Jan 2025 23:08:04 +0100 (CET)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sy.mirrors.kernel.org (Postfix) with ESMTPS id 871E57A27E9
	for <lists+io-uring@lfdr.de>; Wed,  8 Jan 2025 22:07:56 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 98246204F78;
	Wed,  8 Jan 2025 22:07:15 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=davidwei-uk.20230601.gappssmtp.com header.i=@davidwei-uk.20230601.gappssmtp.com header.b="dN+BxL+h"
X-Original-To: io-uring@vger.kernel.org
Received: from mail-pj1-f43.google.com (mail-pj1-f43.google.com [209.85.216.43])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0A99A204F65
	for <io-uring@vger.kernel.org>; Wed,  8 Jan 2025 22:07:13 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.216.43
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1736374035; cv=none; b=KOc3YdmWld4anCLfl2n7goiBDf4K5DB2U0DGHjk5d6zHSy2aWgejSmPvOl6CMnrw+SeegRbGZVeEz+/7rpZ13JfGh1gbeDbWm1Yif1wBkudwX4jOn/HMLYXMNdwTrs7qF3zM71n9oJaWnV1eYLdoVpZZA3uH8wO9WYblPKUMILY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1736374035; c=relaxed/simple;
	bh=BvfCg8XrKhKo+Hk/JZ2OOE7Gn15jev1hzSbcDK9JqTc=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=udmtGcdcu2cMu/yKq3v/IUl/os8N50Tsk4YCX2oa9KRKJrnhXdrrrhRHN3VYu8vJ3SS+d06SRD+53qa2HtMQ6x8MDRZPBpBELYkPVlHfmp5oauhI7r/QSEUFU0cC3hv+jMiaryMnqMIbsLnzPzj2LpsQASYBlw8nfEWgUNv6hLI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=davidwei.uk; spf=none smtp.mailfrom=davidwei.uk; dkim=pass (2048-bit key) header.d=davidwei-uk.20230601.gappssmtp.com header.i=@davidwei-uk.20230601.gappssmtp.com header.b=dN+BxL+h; arc=none smtp.client-ip=209.85.216.43
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=davidwei.uk
Authentication-Results: smtp.subspace.kernel.org; spf=none smtp.mailfrom=davidwei.uk
Received: by mail-pj1-f43.google.com with SMTP id 98e67ed59e1d1-2ef89dbd8eeso396761a91.0
        for <io-uring@vger.kernel.org>; Wed, 08 Jan 2025 14:07:13 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=davidwei-uk.20230601.gappssmtp.com; s=20230601; t=1736374033; x=1736978833; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=xOwH1TpuoWZADqKN7mEhLSZxCObxMi7MjYf6hC9Eb50=;
        b=dN+BxL+hHm1w4Nb+CcA4G9t09t/zwCQBrlB1KvSLx4ksZzOI2qgj/fxDRoWXRM5ope
         f+fsZrfv0EfARkLZt9kwyNeG+KSQtEBuaM1d79YUh5xJ5D2G7bViZaQ//QlqH5hUGG9H
         i9UXD7b6RxUvhBFhTr+DcQlsv1AthLxgbNvCmLo2D71XkSB5d4QEjAizNaqen7hGt0Hk
         4y4WSEN0bLEwa8pz0yyv9xO1oWxfYj8YFcRhCppYV35qOjUcC22lsKr1drpKnUEPmEhm
         V8ajrqMF99hAxNaETvXEPVSMe0yqOB9QLRXan57hEKoiNHt5kep9ZA4Iqz2kgxQjmije
         8M/w==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1736374033; x=1736978833;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=xOwH1TpuoWZADqKN7mEhLSZxCObxMi7MjYf6hC9Eb50=;
        b=KiATeHI+cgZ7WFD2dJ1U9SxvxH752ydhWW4FAkEfgJxkmfcL0OhNEqJ+SSGhgH5/Jp
         2uxiKzA1Q88xVVz+XCxb2GL/uYb3ZR3QrWq7KnOa+iiJ8aGkhp35PvdQ7tQnal4g+4PY
         7BcraAop9G22DTvMNsW68hX9HwLEZy7cGFT+GlO7H6VufXKLJ+IL0RO6cqnp6XNm60Iz
         0L4c+OjkUIUqMG8iHMPQabZ2vjtu2/BNQNLiDWOeqDhtRrm7XEhuG06vXGL2tWOxY8Og
         MXTFeYrDDWy+8nHwpNef1RAZojim2gkUcBroMeXxP6L/ZlKmvDkr6RDSQliKAyc3QOwo
         IJOw==
X-Gm-Message-State: AOJu0Yy5o+JmWY+uXFx5HS8x0V7tX2Qn4g/iXP6IcbPyCSwiETWb1lS7
	RwVVO+4HapR+yNKaSftipB1wVg/p2tgMOaYB4Rc+4vObdY1Og5dh9OR1CvIbS24ooSVwr+Q1vt3
	/
X-Gm-Gg: ASbGncs/2nC18Z6uKAXucNG8ymngrv6sMbrpEtpZbqdjye9MFLTFXG/9YZFYPmat3x+
	+tqBSnGk94vl4+/+0H2yqLFPywKlupomJDUEEI8P/W9lpBIdvyk80OCC1/Ds0KpnVJBKoqfg0MN
	+GIgwvMqDP9KqkQ6Izfq98wtiklbB2Y4k9P+WL24A4u1sQUwKzmO6ckK990koZYfQcTMTRSvJEj
	1Mt/oPp+YrUujWzvTVIUQxPTBXoiqyM+afUQMO7
X-Google-Smtp-Source: AGHT+IGUwFlPuQwssBrA77nLgmuppWrqbXs2hiwqrPLXGXlmES2mfWsoRU0mbok3y06DaBxzYzsStw==
X-Received: by 2002:a17:90a:d64f:b0:2ee:94d1:7a89 with SMTP id 98e67ed59e1d1-2f548ea62aemr6394544a91.1.1736374033276;
        Wed, 08 Jan 2025 14:07:13 -0800 (PST)
Received: from localhost ([2a03:2880:ff:2::])
        by smtp.gmail.com with ESMTPSA id 98e67ed59e1d1-2f54a2f4d55sm2077432a91.51.2025.01.08.14.07.12
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 08 Jan 2025 14:07:12 -0800 (PST)
From: David Wei <dw@davidwei.uk>
To: io-uring@vger.kernel.org,
	netdev@vger.kernel.org
Cc: Jens Axboe <axboe@kernel.dk>,
	Pavel Begunkov <asml.silence@gmail.com>,
	Jakub Kicinski <kuba@kernel.org>,
	Paolo Abeni <pabeni@redhat.com>,
	"David S. Miller" <davem@davemloft.net>,
	Eric Dumazet <edumazet@google.com>,
	Jesper Dangaard Brouer <hawk@kernel.org>,
	David Ahern <dsahern@kernel.org>,
	Mina Almasry <almasrymina@google.com>,
	Stanislav Fomichev <stfomichev@gmail.com>,
	Joe Damato <jdamato@fastly.com>,
	Pedro Tammela <pctammela@mojatatu.com>
Subject: [PATCH net-next v10 08/22] net: page_pool: add callback for mp info printing
Date: Wed,  8 Jan 2025 14:06:29 -0800
Message-ID: <20250108220644.3528845-9-dw@davidwei.uk>
X-Mailer: git-send-email 2.43.5
In-Reply-To: <20250108220644.3528845-1-dw@davidwei.uk>
References: <20250108220644.3528845-1-dw@davidwei.uk>
Precedence: bulk
X-Mailing-List: io-uring@vger.kernel.org
List-Id: <io-uring.vger.kernel.org>
List-Subscribe: <mailto:io-uring+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:io-uring+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

From: Pavel Begunkov <asml.silence@gmail.com>

Add a mandatory callback that prints information about the memory
provider to netlink.

Signed-off-by: Pavel Begunkov <asml.silence@gmail.com>
Signed-off-by: David Wei <dw@davidwei.uk>
---
 include/net/page_pool/memory_provider.h |  5 +++++
 net/core/devmem.c                       | 10 ++++++++++
 net/core/netdev-genl.c                  | 11 ++++++-----
 net/core/page_pool_user.c               |  5 ++---
 4 files changed, 23 insertions(+), 8 deletions(-)

diff --git a/include/net/page_pool/memory_provider.h b/include/net/page_pool/memory_provider.h
index 79412a8714fa..5f9d4834235d 100644
--- a/include/net/page_pool/memory_provider.h
+++ b/include/net/page_pool/memory_provider.h
@@ -10,11 +10,16 @@
 #include <net/netmem.h>
 #include <net/page_pool/types.h>
 
+struct netdev_rx_queue;
+struct sk_buff;
+
 struct memory_provider_ops {
 	netmem_ref (*alloc_netmems)(struct page_pool *pool, gfp_t gfp);
 	bool (*release_netmem)(struct page_pool *pool, netmem_ref netmem);
 	int (*init)(struct page_pool *pool);
 	void (*destroy)(struct page_pool *pool);
+	int (*nl_fill)(void *mp_priv, struct sk_buff *rsp,
+		       struct netdev_rx_queue *rxq);
 };
 
 #endif
diff --git a/net/core/devmem.c b/net/core/devmem.c
index 48833c1dcbd4..c0bde0869f72 100644
--- a/net/core/devmem.c
+++ b/net/core/devmem.c
@@ -395,9 +395,19 @@ bool mp_dmabuf_devmem_release_page(struct page_pool *pool, netmem_ref netmem)
 	return false;
 }
 
+static int mp_dmabuf_devmem_nl_fill(void *mp_priv, struct sk_buff *rsp,
+				    struct netdev_rx_queue *rxq)
+{
+	const struct net_devmem_dmabuf_binding *binding = mp_priv;
+	int type = rxq ? NETDEV_A_QUEUE_DMABUF : NETDEV_A_PAGE_POOL_DMABUF;
+
+	return nla_put_u32(rsp, type, binding->id);
+}
+
 static const struct memory_provider_ops dmabuf_devmem_ops = {
 	.init			= mp_dmabuf_devmem_init,
 	.destroy		= mp_dmabuf_devmem_destroy,
 	.alloc_netmems		= mp_dmabuf_devmem_alloc_netmems,
 	.release_netmem		= mp_dmabuf_devmem_release_page,
+	.nl_fill		= mp_dmabuf_devmem_nl_fill,
 };
diff --git a/net/core/netdev-genl.c b/net/core/netdev-genl.c
index 2d3ae0cd3ad2..4bc05fb27890 100644
--- a/net/core/netdev-genl.c
+++ b/net/core/netdev-genl.c
@@ -10,6 +10,7 @@
 #include <net/sock.h>
 #include <net/xdp.h>
 #include <net/xdp_sock.h>
+#include <net/page_pool/memory_provider.h>
 
 #include "dev.h"
 #include "devmem.h"
@@ -368,7 +369,6 @@ static int
 netdev_nl_queue_fill_one(struct sk_buff *rsp, struct net_device *netdev,
 			 u32 q_idx, u32 q_type, const struct genl_info *info)
 {
-	struct net_devmem_dmabuf_binding *binding;
 	struct netdev_rx_queue *rxq;
 	struct netdev_queue *txq;
 	void *hdr;
@@ -385,15 +385,16 @@ netdev_nl_queue_fill_one(struct sk_buff *rsp, struct net_device *netdev,
 	switch (q_type) {
 	case NETDEV_QUEUE_TYPE_RX:
 		rxq = __netif_get_rx_queue(netdev, q_idx);
+		struct pp_memory_provider_params *params;
+
 		if (rxq->napi && nla_put_u32(rsp, NETDEV_A_QUEUE_NAPI_ID,
 					     rxq->napi->napi_id))
 			goto nla_put_failure;
 
-		binding = rxq->mp_params.mp_priv;
-		if (binding &&
-		    nla_put_u32(rsp, NETDEV_A_QUEUE_DMABUF, binding->id))
+		params = &rxq->mp_params;
+		if (params->mp_ops &&
+		    params->mp_ops->nl_fill(params->mp_priv, rsp, rxq))
 			goto nla_put_failure;
-
 		break;
 	case NETDEV_QUEUE_TYPE_TX:
 		txq = netdev_get_tx_queue(netdev, q_idx);
diff --git a/net/core/page_pool_user.c b/net/core/page_pool_user.c
index 8d31c71bea1a..bd017537fa80 100644
--- a/net/core/page_pool_user.c
+++ b/net/core/page_pool_user.c
@@ -7,9 +7,9 @@
 #include <net/netdev_rx_queue.h>
 #include <net/page_pool/helpers.h>
 #include <net/page_pool/types.h>
+#include <net/page_pool/memory_provider.h>
 #include <net/sock.h>
 
-#include "devmem.h"
 #include "page_pool_priv.h"
 #include "netdev-genl-gen.h"
 
@@ -214,7 +214,6 @@ static int
 page_pool_nl_fill(struct sk_buff *rsp, const struct page_pool *pool,
 		  const struct genl_info *info)
 {
-	struct net_devmem_dmabuf_binding *binding = pool->mp_priv;
 	size_t inflight, refsz;
 	void *hdr;
 
@@ -244,7 +243,7 @@ page_pool_nl_fill(struct sk_buff *rsp, const struct page_pool *pool,
 			 pool->user.detach_time))
 		goto err_cancel;
 
-	if (binding && nla_put_u32(rsp, NETDEV_A_PAGE_POOL_DMABUF, binding->id))
+	if (pool->mp_ops && pool->mp_ops->nl_fill(pool->mp_priv, rsp, NULL))
 		goto err_cancel;
 
 	genlmsg_end(rsp, hdr);
-- 
2.43.5


