Return-Path: <io-uring+bounces-5983-lists+io-uring=lfdr.de@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [IPv6:2604:1380:45e3:2400::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 9C351A153DB
	for <lists+io-uring@lfdr.de>; Fri, 17 Jan 2025 17:12:29 +0100 (CET)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id D536B3A81B5
	for <lists+io-uring@lfdr.de>; Fri, 17 Jan 2025 16:11:55 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 0033B19994F;
	Fri, 17 Jan 2025 16:11:28 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="Y+rktN6O"
X-Original-To: io-uring@vger.kernel.org
Received: from mail-ej1-f46.google.com (mail-ej1-f46.google.com [209.85.218.46])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 25C0F19F116;
	Fri, 17 Jan 2025 16:11:26 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.218.46
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1737130287; cv=none; b=ZF8cxNkieOOuKIUrGI6IRbaAxfIcxvuZIg5hZcH2zlyAmdk1w6OJtE6aUwygMOi/ZtbPo/olUVtnFu2Dz3IdqQZ1BYAvUzLPW0/FLYX/oKLCCsKVWjWhb5aWcQdwcNUppfW3/4oiMfNDdEubx1JAfDRZYKDxzx1r6PWoqYm1P9Y=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1737130287; c=relaxed/simple;
	bh=Y/NBjhmAC2GWFXk9LV84G6TfpcdH39Vpnhp62cne8uk=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=eK/zdmxE6DjqWIVzKOfcyHwdlecqCB0vPRPQ6PqKOQxqp6Hofai4fxTaWYD3YQCTB6BeRbV+LWOYw4RkzxmIxY+xJKJhlEyOTtp8WGbix5iGCG8Y0ngFS28R8PMQL55g16wi9cGP6nAFu5LBLeMXvbgcoMT0G1PB1I1D22uwo74=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=Y+rktN6O; arc=none smtp.client-ip=209.85.218.46
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Received: by mail-ej1-f46.google.com with SMTP id a640c23a62f3a-ab2aea81cd8so384441066b.2;
        Fri, 17 Jan 2025 08:11:25 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1737130284; x=1737735084; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=N6GPHVXnzoSzCcTCYbLC1dfjzUc0I8n6DCqe9YSVcw0=;
        b=Y+rktN6O4051cMm/UEsHb8RvN8bPJZgVh4TUowcrvcrvDMIwoT6rxjglQh6/JiIAig
         GuV39TCQyaaGMF3zH1UdUwD0Bxj9Jy5Jd+vNkS1GQtq7vPAC1Lc0d9CHOhKu7V8n8aBB
         fHhmnX9ueZgseF1nqjqnpl9wPJeEDxxEl1BMQ4CVdY+FcxZwKJO0PVTfqrNfqdi/zY+Z
         50JS1HM9QyJqnJ+rmrEbml5TLPg13zgByK131P2SRKQ3LabZwws6bFJvcEM7M/mO+lXr
         46APTKEAE1RUkPyiktWgjnQu54Be66xVtGq6lgFDvdlnPYSvgv9Rs2aqSuiMoe/LCczM
         Uorg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1737130284; x=1737735084;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=N6GPHVXnzoSzCcTCYbLC1dfjzUc0I8n6DCqe9YSVcw0=;
        b=mWKBuXDPzvGxR7tjJLRufSuq98bxGdhWvBX29RwSXWLDyMSHQM2RAp4urMziWuawTT
         3Yz8H2pWzh5uvkrOB2un+53Bbe4xRvQnzdbfKKM5LbYjnPiET9UrVwbk8bkm4ccdQwYq
         Ibe1iKAN+bpDUrMD0+qZcCNWSoM1ltQCuepm+mawNuke2/1dqEnQeu0+YUHXAlbN9ny3
         adkMmJWfhQ3IboscD8AFEL7mQBOVfyxjFL4hEp5W6zcgeKkh9TYneyorDJfj8+MHq/5H
         WYH1DUkz9oEBJvQkoRdyj8ABJOAydLHlmxLjdw5Ksq58lAnWklTQhIv4REws+xtnqVdq
         3C7g==
X-Forwarded-Encrypted: i=1; AJvYcCWw25zwMOup7mAa77oX0/dK5hM1oZ4488oVpOpeNyq2vHF34AQh5rVoL91GFJhnWHEueNypryg=@vger.kernel.org
X-Gm-Message-State: AOJu0YzNruRwoSL3A5T5qqg1+fZR7Dt4Tn+gaevcOWA+mBP1Twoj+37I
	27MnU0aKdCjOqtmZay+rRTuaLBWu+zPou3ClTIdBaNpto2cN/pknDXHA2w==
X-Gm-Gg: ASbGnctrp8fICa5WmQI183Uq6En4JLnJy0+CAGrhXJrlv4WXYNH9DJvpMd5ByK4krz6
	3iOFvE5RC3I9bLWA1j91EAQ2RYGyNhKKYrg0KEOiO+/4wcyggHtcMxJLmh3+JMmEP+iqf3/Tv1f
	V9Fs3xtOLz89VFpE74SnHlnYe3vtJ2iIbpz1JUlJod4KuAPQZQqUP0/amHFfhPqHK8+GRr/4kuH
	CGJQfKs2uMfBzZYbbOXtHQbL2dZRVTMafzf+XNZ
X-Google-Smtp-Source: AGHT+IGEUJIylfalCzblTC3hI3yckpPg3cyrTqdILk5+YiaoI48GdujOKGPfhAwV51E5J+FY0gH4wA==
X-Received: by 2002:a17:907:930b:b0:aab:c78c:a705 with SMTP id a640c23a62f3a-ab38b3d4253mr329812766b.52.1737130283907;
        Fri, 17 Jan 2025 08:11:23 -0800 (PST)
Received: from 127.com ([2620:10d:c092:600::1:56de])
        by smtp.gmail.com with ESMTPSA id a640c23a62f3a-ab384f23007sm193716366b.96.2025.01.17.08.11.23
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 17 Jan 2025 08:11:23 -0800 (PST)
From: Pavel Begunkov <asml.silence@gmail.com>
To: io-uring@vger.kernel.org,
	netdev@vger.kernel.org
Cc: asml.silence@gmail.com,
	Jens Axboe <axboe@kernel.dk>,
	Jakub Kicinski <kuba@kernel.org>,
	Paolo Abeni <pabeni@redhat.com>,
	"David S . Miller" <davem@davemloft.net>,
	Eric Dumazet <edumazet@google.com>,
	Jesper Dangaard Brouer <hawk@kernel.org>,
	David Ahern <dsahern@kernel.org>,
	Mina Almasry <almasrymina@google.com>,
	Stanislav Fomichev <stfomichev@gmail.com>,
	Joe Damato <jdamato@fastly.com>,
	Pedro Tammela <pctammela@mojatatu.com>,
	David Wei <dw@davidwei.uk>
Subject: [PATCH net-next v12 07/10] net: page_pool: add a mp hook to unregister_netdevice*
Date: Fri, 17 Jan 2025 16:11:45 +0000
Message-ID: <e2c2e9f8fb22e3b53363a67e8f47a78d825892ad.1737129699.git.asml.silence@gmail.com>
X-Mailer: git-send-email 2.47.1
In-Reply-To: <cover.1737129699.git.asml.silence@gmail.com>
References: <cover.1737129699.git.asml.silence@gmail.com>
Precedence: bulk
X-Mailing-List: io-uring@vger.kernel.org
List-Id: <io-uring.vger.kernel.org>
List-Subscribe: <mailto:io-uring+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:io-uring+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

Devmem TCP needs a hook in unregister_netdevice_many_notify() to upkeep
the set tracking queues it's bound to, i.e. ->bound_rxqs. Instead of
devmem sticking directly out of the genetic path, add a mp function.

Reviewed-by: Jakub Kicinski <kuba@kernel.org>
Reviewed-by: Mina Almasry <almasrymina@google.com>
Signed-off-by: Pavel Begunkov <asml.silence@gmail.com>
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
index fe5f5855593d..e5a4ba3fc24f 100644
--- a/net/core/dev.c
+++ b/net/core/dev.c
@@ -158,6 +158,7 @@
 #include <net/netdev_rx_queue.h>
 #include <net/page_pool/types.h>
 #include <net/page_pool/helpers.h>
+#include <net/page_pool/memory_provider.h>
 #include <net/rps.h>
 #include <linux/phy_link_topology.h>
 
@@ -11721,6 +11722,19 @@ void unregister_netdevice_queue(struct net_device *dev, struct list_head *head)
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
@@ -11777,7 +11791,7 @@ void unregister_netdevice_many_notify(struct list_head *head,
 		dev_tcx_uninstall(dev);
 		dev_xdp_uninstall(dev);
 		bpf_dev_bound_netdev_unregister(dev);
-		dev_dmabuf_uninstall(dev);
+		dev_memory_provider_uninstall(dev);
 
 		netdev_offload_xstats_disable_all(dev);
 
diff --git a/net/core/devmem.c b/net/core/devmem.c
index b33b978fa28f..ebb77d2f30f4 100644
--- a/net/core/devmem.c
+++ b/net/core/devmem.c
@@ -320,26 +320,6 @@ net_devmem_bind_dmabuf(struct net_device *dev, unsigned int dmabuf_fd,
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
@@ -415,10 +395,26 @@ static int mp_dmabuf_devmem_nl_fill(void *mp_priv, struct sk_buff *rsp,
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
2.47.1


