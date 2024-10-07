Return-Path: <io-uring+bounces-3449-lists+io-uring=lfdr.de@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [147.75.80.249])
	by mail.lfdr.de (Postfix) with ESMTPS id 1CA239939FD
	for <lists+io-uring@lfdr.de>; Tue,  8 Oct 2024 00:17:23 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id A1BE21F23DD0
	for <lists+io-uring@lfdr.de>; Mon,  7 Oct 2024 22:17:22 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id B883C1925A7;
	Mon,  7 Oct 2024 22:16:38 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=davidwei-uk.20230601.gappssmtp.com header.i=@davidwei-uk.20230601.gappssmtp.com header.b="LlFkMGEN"
X-Original-To: io-uring@vger.kernel.org
Received: from mail-pj1-f48.google.com (mail-pj1-f48.google.com [209.85.216.48])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4476518C92C
	for <io-uring@vger.kernel.org>; Mon,  7 Oct 2024 22:16:36 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.216.48
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1728339398; cv=none; b=qsbr2D2qPFukQR4UQP37KERIiFO5N9IeuuMXNvbu93mSjI+dHE4+0Mj6dBVoM0rvQ4YXvFH3ZTB4I7Gj/6qeNDumU+/jB+FE5ZQV4MMub1YxebmZM5pDEUK1QiuvsSsm2TpHBxYvZRnWi+5/6AcRQefniOY6ToDTnkOJANs7R0c=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1728339398; c=relaxed/simple;
	bh=tdW7pVO2vzBEUkGSIwk+fjycaNg7WG9R5dNLkTWuiiU=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=u/2IRjjk3PY6dSoUX2dR2DzMsvidpNGrqOPVMEb8zA52MNorZyIys/5pOM9nBOh7NQ7FWMddSBRen52A+Kdz9gJnuhoVDCdixvdQRFHQKpHVD4cOg0oIn3wWPNDlu5h8ecYSX3PoZwLu2fbSqj47zJqtt379egUiudrxlfzmNi0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=davidwei.uk; spf=none smtp.mailfrom=davidwei.uk; dkim=pass (2048-bit key) header.d=davidwei-uk.20230601.gappssmtp.com header.i=@davidwei-uk.20230601.gappssmtp.com header.b=LlFkMGEN; arc=none smtp.client-ip=209.85.216.48
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=davidwei.uk
Authentication-Results: smtp.subspace.kernel.org; spf=none smtp.mailfrom=davidwei.uk
Received: by mail-pj1-f48.google.com with SMTP id 98e67ed59e1d1-2e07d85e956so4050741a91.3
        for <io-uring@vger.kernel.org>; Mon, 07 Oct 2024 15:16:36 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=davidwei-uk.20230601.gappssmtp.com; s=20230601; t=1728339396; x=1728944196; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=pL6pmSI5HRx43rRiACnUGu/bYld5yRw2M0KqvIw/BxM=;
        b=LlFkMGENRCEJa7cSjymMEDOMUvkYqCkXntrAiv26FTyJpY1r1BhvyWWMFyz3roOE4k
         omdRI+oIGBOzbj5XOhU4hHc0WPTE9pf/O9IogxBfvacHbdjJYOXL3IQyHTvL28Egzi9z
         rPn1GYcl4/orRVTc8UNAGYjwq1yTFmtZhK33WJLtuOrXk+9hPnqoaLcCnaM4mQBHlAjW
         NtRLIaXo07kxfhmUe2GWcCI9+h/Pnbp1irxRO2HgNJfbXl39ytoGSAB6Bad9E+6OTTr0
         kBlLK2tH1bxvChly/R2De34J79agECmXUJat6hv1uQZRHaGTmbYauLybcgXCOBIJ4bLW
         97Sg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1728339396; x=1728944196;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=pL6pmSI5HRx43rRiACnUGu/bYld5yRw2M0KqvIw/BxM=;
        b=Krw+GMJ+Nz+dw5tE70+BJczmeZUlxhKGe4l2cZq/zy2zpdC2fZ7PQVaGhrRwG5FVTZ
         rc2JkzqtMy8AfA8Uuv+5XyuJ18xXRLthjprw0d3b5z0zpk20ReADBN6HrhCWoArlCSNg
         KzIYxI+GLGQ34Xx2NycOvE8Oq417tIKs9aYmxezE7M34tLsmmRhOX3JDRxJFfh/RgBhV
         lyUzvP2hna9cb0AxZDdXQU8IQ8tCQfhJZYOScllm94tjlzmkQa5esgsp18LlqQ50s8/j
         4wSiwZcCm7JEp0xXQIPSxqfagjPXBmxvroJDkVAwM40VD61IlWvyABpvjbszmDFI/jSf
         YOTA==
X-Gm-Message-State: AOJu0Yy9zdkIpQ5Iyh3uMbwatwnpEhFuu0RMe6uQRFDiwPcXLn5MA6p0
	yuz8jqhJr4ECVUjWgSbitFH1MOkMy/BKOCE3Ibf3h4+H2uqUbgTHrObzZGAcDXhMTmozv8IvVf7
	9
X-Google-Smtp-Source: AGHT+IFRfdWCHOJB3tc8iWXlTfj3dlGdrL6fQ9NuLBzBh6SI0mbyBXqFiz/MSvvzHcfdZcJRJBXAkg==
X-Received: by 2002:a17:90a:7085:b0:2dd:4f93:9af1 with SMTP id 98e67ed59e1d1-2e1e626de09mr15350798a91.21.1728339390835;
        Mon, 07 Oct 2024 15:16:30 -0700 (PDT)
Received: from localhost (fwdproxy-prn-060.fbsv.net. [2a03:2880:ff:3c::face:b00c])
        by smtp.gmail.com with ESMTPSA id 98e67ed59e1d1-2e1e83cab42sm7886103a91.2.2024.10.07.15.16.30
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 07 Oct 2024 15:16:30 -0700 (PDT)
From: David Wei <dw@davidwei.uk>
To: io-uring@vger.kernel.org,
	netdev@vger.kernel.org
Cc: David Wei <dw@davidwei.uk>,
	Jens Axboe <axboe@kernel.dk>,
	Pavel Begunkov <asml.silence@gmail.com>,
	Jakub Kicinski <kuba@kernel.org>,
	Paolo Abeni <pabeni@redhat.com>,
	"David S. Miller" <davem@davemloft.net>,
	Eric Dumazet <edumazet@google.com>,
	Jesper Dangaard Brouer <hawk@kernel.org>,
	David Ahern <dsahern@kernel.org>,
	Mina Almasry <almasrymina@google.com>
Subject: [PATCH v1 03/15] net: generalise net_iov chunk owners
Date: Mon,  7 Oct 2024 15:15:51 -0700
Message-ID: <20241007221603.1703699-4-dw@davidwei.uk>
X-Mailer: git-send-email 2.43.5
In-Reply-To: <20241007221603.1703699-1-dw@davidwei.uk>
References: <20241007221603.1703699-1-dw@davidwei.uk>
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

Signed-off-by: Pavel Begunkov <asml.silence@gmail.com>
Signed-off-by: David Wei <dw@davidwei.uk>
---
 include/net/netmem.h | 21 ++++++++++++++++++++-
 net/core/devmem.c    | 25 +++++++++++++------------
 net/core/devmem.h    | 25 +++++++++----------------
 3 files changed, 42 insertions(+), 29 deletions(-)

diff --git a/include/net/netmem.h b/include/net/netmem.h
index 8a6e20be4b9d..3795ded30d2c 100644
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
index 858982858f81..5c10cf0e2a18 100644
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
index 80f38fe46930..12b14377ed3f 100644
--- a/net/core/devmem.h
+++ b/net/core/devmem.h
@@ -10,6 +10,8 @@
 #ifndef _NET_DEVMEM_H
 #define _NET_DEVMEM_H
 
+#include <net/netmem.h>
+
 struct netlink_ext_ack;
 
 struct net_devmem_dmabuf_binding {
@@ -50,34 +52,25 @@ struct net_devmem_dmabuf_binding {
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
@@ -87,7 +80,7 @@ static inline u32 net_devmem_iov_binding_id(const struct net_iov *niov)
 
 static inline unsigned long net_iov_virtual_addr(const struct net_iov *niov)
 {
-	struct dmabuf_genpool_chunk_owner *owner = net_iov_owner(niov);
+	struct net_iov_area *owner = net_iov_owner(niov);
 
 	return owner->base_virtual +
 	       ((unsigned long)net_iov_idx(niov) << PAGE_SHIFT);
-- 
2.43.5


