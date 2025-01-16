Return-Path: <io-uring+bounces-5931-lists+io-uring=lfdr.de@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [IPv6:2604:1380:45e3:2400::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 86556A14541
	for <lists+io-uring@lfdr.de>; Fri, 17 Jan 2025 00:18:20 +0100 (CET)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id E480B3AA406
	for <lists+io-uring@lfdr.de>; Thu, 16 Jan 2025 23:17:58 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 5DE5C2442DC;
	Thu, 16 Jan 2025 23:17:19 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=davidwei-uk.20230601.gappssmtp.com header.i=@davidwei-uk.20230601.gappssmtp.com header.b="ObnjEmLP"
X-Original-To: io-uring@vger.kernel.org
Received: from mail-pl1-f170.google.com (mail-pl1-f170.google.com [209.85.214.170])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A777E243864
	for <io-uring@vger.kernel.org>; Thu, 16 Jan 2025 23:17:17 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.214.170
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1737069439; cv=none; b=OAg/4XMasAxvZQx6LPOIXrxQn65F79MJOtGNyo6TjZ2yiTalIp5Pnkd1MIfJ4nnDi866dgfIwH/UCytGNpzBYok9lgrnwCY+RcPp+o2YeSbUaWU49XRIajm77ND2elp04ABj65mFatiTBgPhvk3Q+rXfpRW7XMqWTHNrmHDfJJw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1737069439; c=relaxed/simple;
	bh=3biTJFdUOXAOi6w31VGG1oNYsJz079fKm5kofQxzt+Y=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=MuV2GC8f83XQtiHohPF6ucxyaodXd9fcKa85lK3yXfeoggafms7P8oOTME4A9bmumOESCUWn3in4XtZz1azQ7q1juhPiFRWibQDna34xXtaRCrBzxA1sJ6e6JrNIil5xPIY3SG/HxiM+QttVfrKrBhvEtztSe180oCbYrjq4/uM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=davidwei.uk; spf=none smtp.mailfrom=davidwei.uk; dkim=pass (2048-bit key) header.d=davidwei-uk.20230601.gappssmtp.com header.i=@davidwei-uk.20230601.gappssmtp.com header.b=ObnjEmLP; arc=none smtp.client-ip=209.85.214.170
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=davidwei.uk
Authentication-Results: smtp.subspace.kernel.org; spf=none smtp.mailfrom=davidwei.uk
Received: by mail-pl1-f170.google.com with SMTP id d9443c01a7336-21654fdd5daso25848385ad.1
        for <io-uring@vger.kernel.org>; Thu, 16 Jan 2025 15:17:17 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=davidwei-uk.20230601.gappssmtp.com; s=20230601; t=1737069437; x=1737674237; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=5HjpNvJntS7mBirVUx5S3IKUa/AMALIP3oGkqWJMCMM=;
        b=ObnjEmLPm4ke28zV+LBCFYXXF0f78cuQ1qVbVaZuHg9enLI4SHoGkdJIX+v+9KjNXy
         0HamaGJHzQNMDARDz1mfJVhcoGG4jLoqzgTL790I76NtU1LpdAuV6U5agRPmRnZNmy8Z
         OXfSrysnXdK9MyNU3nbY/+FvP0jA+JAp4LAtfo42VnaWT1Hw/qCVFRv8Xz3OPtjHp82V
         LESNSx3+PW/3pWhRHckkl3B/wLE+xuSxe6AiKhDI2+mZtVy6nC/OiO+NipC2CRg9eeeJ
         FDuOg4gxfAWoSH/NpB6RzCwKhIX4Uw8knp+57nO0wk7OQjQke6nwfrdCgf2lrlNay6UM
         b9iQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1737069437; x=1737674237;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=5HjpNvJntS7mBirVUx5S3IKUa/AMALIP3oGkqWJMCMM=;
        b=NxsnSX9aXkEJAIdVQV0drp/mPoMhm89xeg1LQ6h0VVdiIso9Sf1mAVlYxhuS6CG+vX
         UNUrXcK1gkyLrVeW+xv+/mykHaXRNxG89Wcw/QFuaa9N6FKAuV2l1MB1YAgfKArvNntI
         cqE244D0BfUghurBOks5OzCD8S2j5b4aig4/Dc6S46hXD8Qr8n0VSbtcJefRnbGv/pSN
         3kvhAoOBMD6AcgQRsvjRLmn9qXIP4pO8tmAKUJx5VOF72b7X93uWfePe70pTUt7Zxotg
         XsKQYKXfqjc1pjPg1z0v00SIzyJJU6c6oYMHGenS2VJ5XfQ2zeKl9JJDaE4HCE6WNXkd
         yjow==
X-Gm-Message-State: AOJu0YxA0j3Kr20/s7fYVsIpCiUjkgLJVEjL419Oc+sXAkczjhRfXa1L
	ZMA2z3KiUKHn48C0qggVV2Mxl4EhAsHC+ni4ZsuVQAIzV6/NgjE5QlGOjyFcoz2CQugBGyvBf3v
	M
X-Gm-Gg: ASbGncvukWaY1lap7R+WFzyNzjtMG05ztHH/NVezsCu0O8Qy/1KifoMXVmpFdv6ZcBR
	KujFu2BdgYrnf1xbxibrPOafoxa3aOF6PQPqgMXKMoR85daoNJRvr9GDvOVnKQz+0kqn0tkB4hZ
	8+UWZnNVlsBB3PxZ1vPlh+MqdwxuGxmgwf+S/p+8+XOy15B11RJYFR4nu/Ho2P9XmH1gW0EIfUA
	jYiVi78IjyPEElUKHcoU7i3QP4MaKlSXOKaXjX/5w==
X-Google-Smtp-Source: AGHT+IHkrl3VnkvScu3B92v7++EOueBneTakU3T0NPFC7aQQKHJ5Vd70/bRIrDYsb9C8jV9/X3+wng==
X-Received: by 2002:a17:902:ea03:b0:215:b33b:e26d with SMTP id d9443c01a7336-21c3550c5d3mr8824175ad.21.1737069436984;
        Thu, 16 Jan 2025 15:17:16 -0800 (PST)
Received: from localhost ([2a03:2880:ff:13::])
        by smtp.gmail.com with ESMTPSA id d9443c01a7336-21c2d402e5esm4889275ad.210.2025.01.16.15.17.16
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 16 Jan 2025 15:17:16 -0800 (PST)
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
Subject: [PATCH net-next v11 07/21] net: page_pool: add a mp hook to unregister_netdevice*
Date: Thu, 16 Jan 2025 15:16:49 -0800
Message-ID: <20250116231704.2402455-8-dw@davidwei.uk>
X-Mailer: git-send-email 2.43.5
In-Reply-To: <20250116231704.2402455-1-dw@davidwei.uk>
References: <20250116231704.2402455-1-dw@davidwei.uk>
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
index 6d10a0959d00..36469a7e649f 100644
--- a/include/net/page_pool/memory_provider.h
+++ b/include/net/page_pool/memory_provider.h
@@ -15,6 +15,7 @@ struct memory_provider_ops {
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


