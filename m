Return-Path: <io-uring+bounces-5763-lists+io-uring=lfdr.de@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [147.75.80.249])
	by mail.lfdr.de (Postfix) with ESMTPS id 739D0A067DC
	for <lists+io-uring@lfdr.de>; Wed,  8 Jan 2025 23:08:06 +0100 (CET)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id 0331018887D1
	for <lists+io-uring@lfdr.de>; Wed,  8 Jan 2025 22:08:08 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id CA992204F7C;
	Wed,  8 Jan 2025 22:07:16 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=davidwei-uk.20230601.gappssmtp.com header.i=@davidwei-uk.20230601.gappssmtp.com header.b="Dl9r/Xgr"
X-Original-To: io-uring@vger.kernel.org
Received: from mail-pj1-f48.google.com (mail-pj1-f48.google.com [209.85.216.48])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4AA4D204F75
	for <io-uring@vger.kernel.org>; Wed,  8 Jan 2025 22:07:15 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.216.48
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1736374036; cv=none; b=ZaF/XDSKd8yKh44qCP1yIc8MlcnomP2p5zrT0X0V5aFgXUwHH7aLfeeu8Kv7QVoBfMgA2NR0M5py8vmm8gHqi+zYalI0vD+FpqpDwp3kHMFTZiXkCJKMXGVFciuKjSu6ZocwNLu3Z4kNuiEepdKjfeCdKVOg3Z2G6BgTrlsYJa8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1736374036; c=relaxed/simple;
	bh=aHuuTS4lj9jHydflnLw45LXqHHlddqracVR8/7S9y1Q=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=tmjou69heFvOBgh0/Wjt4H0rygdEcbFDvTk2EvzByZgiHFchqNPnU3b02LEBWy8dj9CrXx7cHdSEtifvN028PnkQiBBSurrq3kQzdNYNtJ/rmSE43NcIpvO5Icq/Fpuc13sAqh/vXj0tRDYNSTsUHsD28wwa/rfXMUMdDttoUdU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=davidwei.uk; spf=none smtp.mailfrom=davidwei.uk; dkim=pass (2048-bit key) header.d=davidwei-uk.20230601.gappssmtp.com header.i=@davidwei-uk.20230601.gappssmtp.com header.b=Dl9r/Xgr; arc=none smtp.client-ip=209.85.216.48
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=davidwei.uk
Authentication-Results: smtp.subspace.kernel.org; spf=none smtp.mailfrom=davidwei.uk
Received: by mail-pj1-f48.google.com with SMTP id 98e67ed59e1d1-2ee8e8e29f6so396048a91.0
        for <io-uring@vger.kernel.org>; Wed, 08 Jan 2025 14:07:15 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=davidwei-uk.20230601.gappssmtp.com; s=20230601; t=1736374034; x=1736978834; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=Pgcp/Pu4u1HA5kSIl2CYgQKpujUzs/1MRh8eEoDuahI=;
        b=Dl9r/Xgr3KIhrJlDkrHn9vRxKf3tFdlkHpEyCW6GL50i8qYYesvCUX060BxdSy+xng
         3NVRPK3680svmsQktQ5SDbdMn+/VQS3C6mBTXnvYtScGXqWnYSA1ivhKF5xaI+2v/8lM
         pOn5vOn+Ql6xZLGJNbqFXc9f/xHPS5AR0pT9MU1RJCfXYz2plpwt7YoFawjwHV8wxqee
         vCUOlW3qisVhDH8kP24M8jjTm/zzqkGPcGH1Opu1gEyDj+CX5e9gab9yBGAct0c3T+hv
         Fk1dK8H7/FEW9Ffl6bG/Y92v45Q6TcGfEcciA62naqtPB86PXGtyT7IewEIRLrM7cc8f
         +jBA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1736374034; x=1736978834;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=Pgcp/Pu4u1HA5kSIl2CYgQKpujUzs/1MRh8eEoDuahI=;
        b=wg8rEw6LEbbT9f0OzPsjw6Xwu04t4CrndOu85X7kt9r06iUfGUD4wnjYoecbYctGZ1
         VewQhil3tKJexMx6h7GvUoum4AG+0DF2syJSSbToU9EREn2hwbFjVo3P4ywDUPyLGFTM
         egIcWWcZJUsbeKRHrjqWzO2j58EyQG1EAX5lfcPIkxfqg3JC9RnVe+xPvYn2wgvpkOzs
         SSnkpl7ydoOGlSaHeozSmkZJ7yqEiUhysfJIoxyT9YYgozrF8Avk7Ta6hdrTvIkWR8DD
         1yq7hbiLP1/3sDe++tLN288NMmHIQrFbYMT+zGX6Ztu9t7K2+mFNeSHeuac6dhEF/GQ2
         /D9g==
X-Gm-Message-State: AOJu0YwNvVqoPkuNAn89q2u3HEvrtAiNTUCXqdfSWlcEhOjnKiifS+Yd
	DYMkyaHau0cBmVck0lo9X35TBAi2Z8cgsh/0WE2P2QUk6KjdTZOWgW3Bgi4d8cq40qwq+QbHk5L
	w
X-Gm-Gg: ASbGncvqTB3sw90qZaz1OvRxoM6E4GASxQ7yHkEK7DPBtVDHmJQiQD6pJUD1VJTkAxK
	J7gXOJ4efAORzH6rZzAAnfZQqNllgoBY3O3w/1iV+LVYkaRY6VECtzYBlJo2Ddf1c7PZNdH/GIz
	cRGqTXbCZCGC7j4AuUHTv3MdwdRFRmJvwAF8zoZ52jb6M43wEOmQO7Q1weQ73vE0JDv7kOIP/Dg
	UX43p1vJlhxFNBazu4w7Ds3R8Dx1ZzITN234c2Y
X-Google-Smtp-Source: AGHT+IEiy8bLVMUcIbGyXB/kIMWCKTwETpPN2YvRhGL+63aBroakDn8FcEMI9x5hecd7xU3G1xEF4g==
X-Received: by 2002:a17:90b:2d43:b0:2ee:9d36:6821 with SMTP id 98e67ed59e1d1-2f5490bd0d6mr5942226a91.27.1736374034633;
        Wed, 08 Jan 2025 14:07:14 -0800 (PST)
Received: from localhost ([2a03:2880:ff:3::])
        by smtp.gmail.com with ESMTPSA id 98e67ed59e1d1-2f54a26ac45sm2106877a91.7.2025.01.08.14.07.14
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 08 Jan 2025 14:07:14 -0800 (PST)
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
Subject: [PATCH net-next v10 09/22] net: page_pool: add a mp hook to unregister_netdevice*
Date: Wed,  8 Jan 2025 14:06:30 -0800
Message-ID: <20250108220644.3528845-10-dw@davidwei.uk>
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

Devmem TCP needs a hook in unregister_netdevice_many_notify() to upkeep
the set tracking queues it's bound to, i.e. ->bound_rxqs. Instead of
devmem sticking directly out of the genetic path, add a mp function.

Reviewed-by: Jakub Kicinski <kuba@kernel.org>
Reviewed-by: Mina Almasry <almasrymina@google.com>
Signed-off-by: Pavel Begunkov <asml.silence@gmail.com>
Signed-off-by: David Wei <dw@davidwei.uk>
---
 include/net/page_pool/memory_provider.h |  1 +
 net/core/dev.c                          | 16 ++++++++++-
 net/core/devmem.c                       | 36 +++++++++++--------------
 net/core/devmem.h                       |  5 ----
 4 files changed, 32 insertions(+), 26 deletions(-)

diff --git a/include/net/page_pool/memory_provider.h b/include/net/page_pool/memory_provider.h
index 5f9d4834235d..ef7c28ddf39d 100644
--- a/include/net/page_pool/memory_provider.h
+++ b/include/net/page_pool/memory_provider.h
@@ -20,6 +20,7 @@ struct memory_provider_ops {
 	void (*destroy)(struct page_pool *pool);
 	int (*nl_fill)(void *mp_priv, struct sk_buff *rsp,
 		       struct netdev_rx_queue *rxq);
+	void (*uninstall)(void *mp_priv, struct netdev_rx_queue *rxq);
 };
 
 #endif
diff --git a/net/core/dev.c b/net/core/dev.c
index c7f3dea3e0eb..1d99974e8fba 100644
--- a/net/core/dev.c
+++ b/net/core/dev.c
@@ -157,6 +157,7 @@
 #include <net/netdev_rx_queue.h>
 #include <net/page_pool/types.h>
 #include <net/page_pool/helpers.h>
+#include <net/page_pool/memory_provider.h>
 #include <net/rps.h>
 #include <linux/phy_link_topology.h>
 
@@ -11464,6 +11465,19 @@ void unregister_netdevice_queue(struct net_device *dev, struct list_head *head)
 }
 EXPORT_SYMBOL(unregister_netdevice_queue);
 
+static void dev_memory_provider_uninstall(struct net_device *dev)
+{
+	unsigned int i;
+
+	for (i = 0; i < dev->real_num_rx_queues; i++) {
+		struct netdev_rx_queue *rxq = &dev->_rx[i];
+		struct pp_memory_provider_params *p = &rxq->mp_params;
+
+		if (p->mp_ops && p->mp_ops->uninstall)
+			p->mp_ops->uninstall(rxq->mp_params.mp_priv, rxq);
+	}
+}
+
 void unregister_netdevice_many_notify(struct list_head *head,
 				      u32 portid, const struct nlmsghdr *nlh)
 {
@@ -11516,7 +11530,7 @@ void unregister_netdevice_many_notify(struct list_head *head,
 		dev_tcx_uninstall(dev);
 		dev_xdp_uninstall(dev);
 		bpf_dev_bound_netdev_unregister(dev);
-		dev_dmabuf_uninstall(dev);
+		dev_memory_provider_uninstall(dev);
 
 		netdev_offload_xstats_disable_all(dev);
 
diff --git a/net/core/devmem.c b/net/core/devmem.c
index c0bde0869f72..6f46286d45a9 100644
--- a/net/core/devmem.c
+++ b/net/core/devmem.c
@@ -309,26 +309,6 @@ net_devmem_bind_dmabuf(struct net_device *dev, unsigned int dmabuf_fd,
 	return ERR_PTR(err);
 }
 
-void dev_dmabuf_uninstall(struct net_device *dev)
-{
-	struct net_devmem_dmabuf_binding *binding;
-	struct netdev_rx_queue *rxq;
-	unsigned long xa_idx;
-	unsigned int i;
-
-	for (i = 0; i < dev->real_num_rx_queues; i++) {
-		binding = dev->_rx[i].mp_params.mp_priv;
-		if (!binding)
-			continue;
-
-		xa_for_each(&binding->bound_rxqs, xa_idx, rxq)
-			if (rxq == &dev->_rx[i]) {
-				xa_erase(&binding->bound_rxqs, xa_idx);
-				break;
-			}
-	}
-}
-
 /*** "Dmabuf devmem memory provider" ***/
 
 int mp_dmabuf_devmem_init(struct page_pool *pool)
@@ -404,10 +384,26 @@ static int mp_dmabuf_devmem_nl_fill(void *mp_priv, struct sk_buff *rsp,
 	return nla_put_u32(rsp, type, binding->id);
 }
 
+static void mp_dmabuf_devmem_uninstall(void *mp_priv,
+				       struct netdev_rx_queue *rxq)
+{
+	struct net_devmem_dmabuf_binding *binding = mp_priv;
+	struct netdev_rx_queue *bound_rxq;
+	unsigned long xa_idx;
+
+	xa_for_each(&binding->bound_rxqs, xa_idx, bound_rxq) {
+		if (bound_rxq == rxq) {
+			xa_erase(&binding->bound_rxqs, xa_idx);
+			break;
+		}
+	}
+}
+
 static const struct memory_provider_ops dmabuf_devmem_ops = {
 	.init			= mp_dmabuf_devmem_init,
 	.destroy		= mp_dmabuf_devmem_destroy,
 	.alloc_netmems		= mp_dmabuf_devmem_alloc_netmems,
 	.release_netmem		= mp_dmabuf_devmem_release_page,
 	.nl_fill		= mp_dmabuf_devmem_nl_fill,
+	.uninstall		= mp_dmabuf_devmem_uninstall,
 };
diff --git a/net/core/devmem.h b/net/core/devmem.h
index a2b9913e9a17..8e999fe2ae67 100644
--- a/net/core/devmem.h
+++ b/net/core/devmem.h
@@ -68,7 +68,6 @@ void net_devmem_unbind_dmabuf(struct net_devmem_dmabuf_binding *binding);
 int net_devmem_bind_dmabuf_to_queue(struct net_device *dev, u32 rxq_idx,
 				    struct net_devmem_dmabuf_binding *binding,
 				    struct netlink_ext_ack *extack);
-void dev_dmabuf_uninstall(struct net_device *dev);
 
 static inline struct dmabuf_genpool_chunk_owner *
 net_devmem_iov_to_chunk_owner(const struct net_iov *niov)
@@ -145,10 +144,6 @@ net_devmem_bind_dmabuf_to_queue(struct net_device *dev, u32 rxq_idx,
 	return -EOPNOTSUPP;
 }
 
-static inline void dev_dmabuf_uninstall(struct net_device *dev)
-{
-}
-
 static inline struct net_iov *
 net_devmem_alloc_dmabuf(struct net_devmem_dmabuf_binding *binding)
 {
-- 
2.43.5


