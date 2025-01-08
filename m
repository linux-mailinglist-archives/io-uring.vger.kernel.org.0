Return-Path: <io-uring+bounces-5758-lists+io-uring=lfdr.de@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from sy.mirrors.kernel.org (sy.mirrors.kernel.org [147.75.48.161])
	by mail.lfdr.de (Postfix) with ESMTPS id DB05AA067D2
	for <lists+io-uring@lfdr.de>; Wed,  8 Jan 2025 23:07:37 +0100 (CET)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sy.mirrors.kernel.org (Postfix) with ESMTPS id D3E597A2756
	for <lists+io-uring@lfdr.de>; Wed,  8 Jan 2025 22:07:29 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 20BFF204C18;
	Wed,  8 Jan 2025 22:07:10 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=davidwei-uk.20230601.gappssmtp.com header.i=@davidwei-uk.20230601.gappssmtp.com header.b="aMLA4gNm"
X-Original-To: io-uring@vger.kernel.org
Received: from mail-pl1-f181.google.com (mail-pl1-f181.google.com [209.85.214.181])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8D7C4204C04
	for <io-uring@vger.kernel.org>; Wed,  8 Jan 2025 22:07:08 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.214.181
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1736374030; cv=none; b=G2PnUAOuW+PxtykiwWHLTzW3XPjEORfdGFXWl87VxQQstJ604q6qb5OAu5rIhQTNBznhBHerD89X3YSmDNZA33ccm0152l+uRAgmwRTQDhsSClo/ysurCEU/dLUiNTtNsvqYaIGx9pruaoG+LQFT1MPEFeoz3u3JiE4/b2oA6Wc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1736374030; c=relaxed/simple;
	bh=pcgA9iCs/ieieDW/xSNKiw2slohdBDWi6PwGr9syOoI=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=LO8Wios1BekVjX0Qno8TnYr/pN2caKYA5rc0iNIVp4oJYyvzILnc+DijF4c+c7GBNVgRPPrlrBs713asSFjIlaePhivcsANx1JegY9P6PEc7YwbBG7f8lHtmWYj4Y4uTYA1MfMGkqVvz723VPf+DFCdrMbd3ceeOFGz1aBZVstg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=davidwei.uk; spf=none smtp.mailfrom=davidwei.uk; dkim=pass (2048-bit key) header.d=davidwei-uk.20230601.gappssmtp.com header.i=@davidwei-uk.20230601.gappssmtp.com header.b=aMLA4gNm; arc=none smtp.client-ip=209.85.214.181
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=davidwei.uk
Authentication-Results: smtp.subspace.kernel.org; spf=none smtp.mailfrom=davidwei.uk
Received: by mail-pl1-f181.google.com with SMTP id d9443c01a7336-2166022c5caso3230755ad.2
        for <io-uring@vger.kernel.org>; Wed, 08 Jan 2025 14:07:08 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=davidwei-uk.20230601.gappssmtp.com; s=20230601; t=1736374028; x=1736978828; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=jpi18jMRooqrSQpnsZ+v4ZIObLSk5Puxja5FgSfrqcQ=;
        b=aMLA4gNmrGCdtVXLhiJlGiku+HsH2mUAKz0q0Krhnyk9fWlR5UYDT+GvXEEi/cEi+i
         ymXwU86ozpM8uEIMiPOvQEs6oDMBZdUHATHKhuagQR+FrnlgQItlX44BkohSAoRvaB3e
         PuAxBgocIbf+RDLNpWxmOKPMkGVI9dtf1eA93sC2JmkvYdLQHQD+vSeKLHubhyZ8Vnmh
         AzidEV2scTTmAjZ6r1RrLboNtSXC+WPlaAHA3PUZ5u37vGULN6EnlOR9TFqbBos4FqkO
         v3nBlp+ombGkD3kFPo3yU/dAGXGQZ1rMkFhv6vZ4F2TB7M9HWLYvLdWKl5IKqMwt+ZUe
         QttQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1736374028; x=1736978828;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=jpi18jMRooqrSQpnsZ+v4ZIObLSk5Puxja5FgSfrqcQ=;
        b=lUseufDj+VA5Tf+DSsar6yUlYagSoDtFNj1xKym/CEXn9QcDRdqH4/BFBsKC5xThEB
         i2UjSaOzLGFBvURANuDJQsq1ASDBAzW++Rx3b18OKMhgpLb2iDqTum4k7fshrgbAw28O
         UQK61B0uqzRKlrfpMTrj8DezFbzMZxLLQWIdqlXZBq6yFCLf1kHFjV4gOFTGzVhHZBb2
         oxBPnOxvTQEQ3GH3oqjh/wRR5DvuZIUKowVzB7rkygk4QM4qgsB1UKvh8xmF0oA5X0vA
         /Rg+Qax219GhUmCb6eB+IT+Ru4G1UG/a/3SkFa7LEK2Z1pLBc2RAqG+i8g78+Uxvj0mt
         Ns3g==
X-Gm-Message-State: AOJu0YwJh90OtICPcUMLpd7FqyJZEkkIgmYx6DENak3kjnrMUq9iPgUp
	LiMBvtZs30aIQ++Bq1gg2o5SReOZrEcBb1XR+W/p4DcRpwk70se49QmUCp4rJgH3FfXiSOlJPpZ
	M
X-Gm-Gg: ASbGncsC8KiEYDvCDu4esn/aAYLlPmq/zTEffZ+ywqje30YABRKZSDlYYx8FOnRMy2J
	WqmSXDua7t5+Px/bTsEFMBUGPYQGbAjYxeLlg6UV/NZBNy2HSkXad4ZX3I4/Rxs3b0lRq9UPTKL
	2VcUzEwt7pkixN/Pw+/82ZevYeoS8YsRkwhOJE2JLNnXvBWEJpVKninaA9LfwzwWlbXG0lNfFt7
	NLLYMG8lZ6vRze6AA8wBC1rkGZs6y6acvVMkXha0g==
X-Google-Smtp-Source: AGHT+IEEqAGG1Jbl6iqi885uTc5/x2au4PnylByqxVldJB+0hhXAjo9UPA1p46olnhoiCpGu4SCe/w==
X-Received: by 2002:a17:902:c94d:b0:215:9f5a:a236 with SMTP id d9443c01a7336-21a83f43b51mr54104465ad.6.1736374027944;
        Wed, 08 Jan 2025 14:07:07 -0800 (PST)
Received: from localhost ([2a03:2880:ff:1b::])
        by smtp.gmail.com with ESMTPSA id d9443c01a7336-219dc96313esm331643545ad.20.2025.01.08.14.07.07
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 08 Jan 2025 14:07:07 -0800 (PST)
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
Subject: [PATCH net-next v10 04/22] net: generalise net_iov chunk owners
Date: Wed,  8 Jan 2025 14:06:25 -0800
Message-ID: <20250108220644.3528845-5-dw@davidwei.uk>
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


