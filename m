Return-Path: <io-uring+bounces-5535-lists+io-uring=lfdr.de@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [147.75.199.223])
	by mail.lfdr.de (Postfix) with ESMTPS id BB6879F5BA5
	for <lists+io-uring@lfdr.de>; Wed, 18 Dec 2024 01:37:03 +0100 (CET)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id 02F781639E7
	for <lists+io-uring@lfdr.de>; Wed, 18 Dec 2024 00:37:01 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id A5AEF35972;
	Wed, 18 Dec 2024 00:36:04 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=davidwei-uk.20230601.gappssmtp.com header.i=@davidwei-uk.20230601.gappssmtp.com header.b="fWP9b3uS"
X-Original-To: io-uring@vger.kernel.org
Received: from mail-pf1-f182.google.com (mail-pf1-f182.google.com [209.85.210.182])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id DB2273595B
	for <io-uring@vger.kernel.org>; Wed, 18 Dec 2024 00:36:02 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.210.182
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1734482164; cv=none; b=bBrdI6zuonmg00l57UiHljwKOOnHn1RnE4+ZecdHjYCKtbjK64thWTGlkobvvu3oGaI9sHC51WweIv0jSN15Y44KnXIqJbEjzlOlIyf/Ra4R+9v0RON+OUXzP/c9aRwfyJnYuf14grJVxyDB4qZkuUrx5o3Fmk3ZiacaWMs+g0o=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1734482164; c=relaxed/simple;
	bh=pcgA9iCs/ieieDW/xSNKiw2slohdBDWi6PwGr9syOoI=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=O91M5mhoCaMtyKjwm3vuJIN0lZGeRYM2nr02m1zy+eHkde9EtXgnWbtJ4EID2+X3nS51MYS7/X/V+AMpgOghpcJ+eU0FQzm/T6ZgePuSwmTSm0AudKHsEoTVcw2P/rFMmaWf86KlWDReSnjROMteiJrk6mlpgRlEFSuYgzGdZNs=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=davidwei.uk; spf=none smtp.mailfrom=davidwei.uk; dkim=pass (2048-bit key) header.d=davidwei-uk.20230601.gappssmtp.com header.i=@davidwei-uk.20230601.gappssmtp.com header.b=fWP9b3uS; arc=none smtp.client-ip=209.85.210.182
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=davidwei.uk
Authentication-Results: smtp.subspace.kernel.org; spf=none smtp.mailfrom=davidwei.uk
Received: by mail-pf1-f182.google.com with SMTP id d2e1a72fcca58-728eccf836bso5208873b3a.1
        for <io-uring@vger.kernel.org>; Tue, 17 Dec 2024 16:36:02 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=davidwei-uk.20230601.gappssmtp.com; s=20230601; t=1734482162; x=1735086962; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=jpi18jMRooqrSQpnsZ+v4ZIObLSk5Puxja5FgSfrqcQ=;
        b=fWP9b3uSPqIq1k7ZyATulfjELeCDRScNMdBy28pPGzdQ4pp+Fl1HUJL341Zj9QrpOa
         5ri8kTU8gz9TqCj61ncSXsda4oPEIZcq/p69WGDtF+ZQRMegVQN+wf6iR6OGTAAcpErE
         YPb5CjqqXBuOL73bWMoHpKQldkjPkaqTBoGuGh2YI1aPBqTuakaFLxl6q5kUfuJFCErX
         Zc4gf96krDCdZKBbVV6FqadDhHe7LcXNKsbAqylAZBuPtWaFLCTF+P4OXaWAH0H59Kum
         x/0hc+W5nUAbAlTb/vRN7rpQZwS2ck2+n4MJEmTh0nSw6aOHYcqBvyZvCCDhsNwuJYjI
         GqLA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1734482162; x=1735086962;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=jpi18jMRooqrSQpnsZ+v4ZIObLSk5Puxja5FgSfrqcQ=;
        b=NXRRd08BcWN4aOhILrMqAOqXY2N3ugZnUnhfDDIJTEaizIhvBe9eE0dKARh6vVh+35
         tnL54pAcdKztxAWcR+EBT95sMxNTTLZYGS9wgxRlx32Xb8DC5gaCbQdEyz6tW5bMMK9z
         03jqxKeDSb9Ch3EuX8PG3uXkscgGe9WgQMM7/YlXdTch3hi5JorBCihiVyEtqHonYDGe
         JqI3fYJijKYFKnTu4PaX6/hwvPzh5dq21pPmYtr9RFd/qMSXGOe1XZMtKb7+KCOfN7m+
         BEFwyV0IBIm26eiinx/vhNU9gQVtKoEGxCUy/O+n9ikixkKB8PQMce16d41RL1wBNbpm
         GNJw==
X-Gm-Message-State: AOJu0YwUBn5qWc1BKz6JQ1IaUbMdd/WGnM6UAkaYyHOmnwDCFBRzU9sd
	hQ/KvBk+ILRmxdLwu+kJFAo8ZJhFJm2qWajlXj+u4cTIc0pbF5qM6bzwQ/hIQ27gtUSj3P7RN2U
	/
X-Gm-Gg: ASbGncsCxbUCJpEM20FDNkyh/VmALE2CZUuWycULj+s5Dy6fcCucZ2aV04yixVDg/QR
	/cez7e1eD3sLi9pnMwEzv/8+J/q/n/W4kXdUzV+AJzRQ4pQbNzWO5pOwNT/eK793W/t+eIt6gvZ
	2ViuMQk0hZSjzQZB7GFoCBdDOiXd/duQ3wSEsD8TYxVqmTw6axSTsUktKsm5X0yqcAzDgHzy6NV
	kYSaro+IqI+8DUwAw2fw7CJL+DdZmaPrH54b7Sk+g==
X-Google-Smtp-Source: AGHT+IEwEBH8ItE2D1j8RkGo5OX0xOea+KM1TEW/rpFI1ZULCb28ELCF4raPmOAzOAIMhoqxdOxNVQ==
X-Received: by 2002:a05:6a21:3985:b0:1e1:a716:316a with SMTP id adf61e73a8af0-1e5b47fc5a5mr1685143637.10.1734482162244;
        Tue, 17 Dec 2024 16:36:02 -0800 (PST)
Received: from localhost ([2a03:2880:ff:1e::])
        by smtp.gmail.com with ESMTPSA id d2e1a72fcca58-72918ad5ac5sm7569268b3a.67.2024.12.17.16.36.01
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 17 Dec 2024 16:36:01 -0800 (PST)
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
Subject: [--bla-- 03/20] net: generalise net_iov chunk owners
Date: Tue, 17 Dec 2024 16:35:31 -0800
Message-ID: <20241218003549.786301-4-dw@davidwei.uk>
X-Mailer: git-send-email 2.43.5
In-Reply-To: <20241218003549.786301-1-dw@davidwei.uk>
References: <20241218003549.786301-1-dw@davidwei.uk>
Precedence: bulk
X-Mailing-List: io-uring@vger.kernel.org
List-Id: <io-uring.vger.kernel.org>
List-Subscribe: <mailto:io-uring+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:io-uring+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

From: Pavel Begunkov <asml.silence@gmail.com>

Currently net_iov stores a pointer to struct dmabuf_genpool_chunk_owner,
which serves as a useful abstraction to share data and provide a
context. However, it's too devmem specific, and we want to reuse it for
other memory providers, and for that we need to decouple net_iov from
devmem. Make net_iov to point to a new base structure called
net_iov_area, which dmabuf_genpool_chunk_owner extends.

Reviewed-by: Mina Almasry <almasrymina@google.com>
Signed-off-by: Pavel Begunkov <asml.silence@gmail.com>
Signed-off-by: David Wei <dw@davidwei.uk>
---
 include/net/netmem.h | 21 ++++++++++++++++++++-
 net/core/devmem.c    | 25 +++++++++++++------------
 net/core/devmem.h    | 25 +++++++++----------------
 3 files changed, 42 insertions(+), 29 deletions(-)

diff --git a/include/net/netmem.h b/include/net/netmem.h
index 1b58faa4f20f..c61d5b21e7b4 100644
--- a/include/net/netmem.h
+++ b/include/net/netmem.h
@@ -24,11 +24,20 @@ struct net_iov {
 	unsigned long __unused_padding;
 	unsigned long pp_magic;
 	struct page_pool *pp;
-	struct dmabuf_genpool_chunk_owner *owner;
+	struct net_iov_area *owner;
 	unsigned long dma_addr;
 	atomic_long_t pp_ref_count;
 };
 
+struct net_iov_area {
+	/* Array of net_iovs for this area. */
+	struct net_iov *niovs;
+	size_t num_niovs;
+
+	/* Offset into the dma-buf where this chunk starts.  */
+	unsigned long base_virtual;
+};
+
 /* These fields in struct page are used by the page_pool and net stack:
  *
  *        struct {
@@ -54,6 +63,16 @@ NET_IOV_ASSERT_OFFSET(dma_addr, dma_addr);
 NET_IOV_ASSERT_OFFSET(pp_ref_count, pp_ref_count);
 #undef NET_IOV_ASSERT_OFFSET
 
+static inline struct net_iov_area *net_iov_owner(const struct net_iov *niov)
+{
+	return niov->owner;
+}
+
+static inline unsigned int net_iov_idx(const struct net_iov *niov)
+{
+	return niov - net_iov_owner(niov)->niovs;
+}
+
 /* netmem */
 
 /**
diff --git a/net/core/devmem.c b/net/core/devmem.c
index 5e1a05082ab8..c250db6993d3 100644
--- a/net/core/devmem.c
+++ b/net/core/devmem.c
@@ -32,14 +32,15 @@ static void net_devmem_dmabuf_free_chunk_owner(struct gen_pool *genpool,
 {
 	struct dmabuf_genpool_chunk_owner *owner = chunk->owner;
 
-	kvfree(owner->niovs);
+	kvfree(owner->area.niovs);
 	kfree(owner);
 }
 
 static dma_addr_t net_devmem_get_dma_addr(const struct net_iov *niov)
 {
-	struct dmabuf_genpool_chunk_owner *owner = net_iov_owner(niov);
+	struct dmabuf_genpool_chunk_owner *owner;
 
+	owner = net_devmem_iov_to_chunk_owner(niov);
 	return owner->base_dma_addr +
 	       ((dma_addr_t)net_iov_idx(niov) << PAGE_SHIFT);
 }
@@ -82,7 +83,7 @@ net_devmem_alloc_dmabuf(struct net_devmem_dmabuf_binding *binding)
 
 	offset = dma_addr - owner->base_dma_addr;
 	index = offset / PAGE_SIZE;
-	niov = &owner->niovs[index];
+	niov = &owner->area.niovs[index];
 
 	niov->pp_magic = 0;
 	niov->pp = NULL;
@@ -250,9 +251,9 @@ net_devmem_bind_dmabuf(struct net_device *dev, unsigned int dmabuf_fd,
 			goto err_free_chunks;
 		}
 
-		owner->base_virtual = virtual;
+		owner->area.base_virtual = virtual;
 		owner->base_dma_addr = dma_addr;
-		owner->num_niovs = len / PAGE_SIZE;
+		owner->area.num_niovs = len / PAGE_SIZE;
 		owner->binding = binding;
 
 		err = gen_pool_add_owner(binding->chunk_pool, dma_addr,
@@ -264,17 +265,17 @@ net_devmem_bind_dmabuf(struct net_device *dev, unsigned int dmabuf_fd,
 			goto err_free_chunks;
 		}
 
-		owner->niovs = kvmalloc_array(owner->num_niovs,
-					      sizeof(*owner->niovs),
-					      GFP_KERNEL);
-		if (!owner->niovs) {
+		owner->area.niovs = kvmalloc_array(owner->area.num_niovs,
+						   sizeof(*owner->area.niovs),
+						   GFP_KERNEL);
+		if (!owner->area.niovs) {
 			err = -ENOMEM;
 			goto err_free_chunks;
 		}
 
-		for (i = 0; i < owner->num_niovs; i++) {
-			niov = &owner->niovs[i];
-			niov->owner = owner;
+		for (i = 0; i < owner->area.num_niovs; i++) {
+			niov = &owner->area.niovs[i];
+			niov->owner = &owner->area;
 			page_pool_set_dma_addr_netmem(net_iov_to_netmem(niov),
 						      net_devmem_get_dma_addr(niov));
 		}
diff --git a/net/core/devmem.h b/net/core/devmem.h
index 99782ddeca40..a2b9913e9a17 100644
--- a/net/core/devmem.h
+++ b/net/core/devmem.h
@@ -10,6 +10,8 @@
 #ifndef _NET_DEVMEM_H
 #define _NET_DEVMEM_H
 
+#include <net/netmem.h>
+
 struct netlink_ext_ack;
 
 struct net_devmem_dmabuf_binding {
@@ -51,17 +53,11 @@ struct net_devmem_dmabuf_binding {
  * allocations from this chunk.
  */
 struct dmabuf_genpool_chunk_owner {
-	/* Offset into the dma-buf where this chunk starts.  */
-	unsigned long base_virtual;
+	struct net_iov_area area;
+	struct net_devmem_dmabuf_binding *binding;
 
 	/* dma_addr of the start of the chunk.  */
 	dma_addr_t base_dma_addr;
-
-	/* Array of net_iovs for this chunk. */
-	struct net_iov *niovs;
-	size_t num_niovs;
-
-	struct net_devmem_dmabuf_binding *binding;
 };
 
 void __net_devmem_dmabuf_binding_free(struct net_devmem_dmabuf_binding *binding);
@@ -75,20 +71,17 @@ int net_devmem_bind_dmabuf_to_queue(struct net_device *dev, u32 rxq_idx,
 void dev_dmabuf_uninstall(struct net_device *dev);
 
 static inline struct dmabuf_genpool_chunk_owner *
-net_iov_owner(const struct net_iov *niov)
+net_devmem_iov_to_chunk_owner(const struct net_iov *niov)
 {
-	return niov->owner;
-}
+	struct net_iov_area *owner = net_iov_owner(niov);
 
-static inline unsigned int net_iov_idx(const struct net_iov *niov)
-{
-	return niov - net_iov_owner(niov)->niovs;
+	return container_of(owner, struct dmabuf_genpool_chunk_owner, area);
 }
 
 static inline struct net_devmem_dmabuf_binding *
 net_devmem_iov_binding(const struct net_iov *niov)
 {
-	return net_iov_owner(niov)->binding;
+	return net_devmem_iov_to_chunk_owner(niov)->binding;
 }
 
 static inline u32 net_devmem_iov_binding_id(const struct net_iov *niov)
@@ -98,7 +91,7 @@ static inline u32 net_devmem_iov_binding_id(const struct net_iov *niov)
 
 static inline unsigned long net_iov_virtual_addr(const struct net_iov *niov)
 {
-	struct dmabuf_genpool_chunk_owner *owner = net_iov_owner(niov);
+	struct net_iov_area *owner = net_iov_owner(niov);
 
 	return owner->base_virtual +
 	       ((unsigned long)net_iov_idx(niov) << PAGE_SHIFT);
-- 
2.43.5


