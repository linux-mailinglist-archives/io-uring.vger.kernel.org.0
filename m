Return-Path: <io-uring+bounces-4165-lists+io-uring=lfdr.de@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [IPv6:2604:1380:45d1:ec00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 381C19B566D
	for <lists+io-uring@lfdr.de>; Wed, 30 Oct 2024 00:07:08 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id 5BDD51C20F0B
	for <lists+io-uring@lfdr.de>; Tue, 29 Oct 2024 23:07:07 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 4C7FF20B210;
	Tue, 29 Oct 2024 23:06:14 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=davidwei-uk.20230601.gappssmtp.com header.i=@davidwei-uk.20230601.gappssmtp.com header.b="gNDjPtQB"
X-Original-To: io-uring@vger.kernel.org
Received: from mail-pl1-f170.google.com (mail-pl1-f170.google.com [209.85.214.170])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 13CDD20B1FC
	for <io-uring@vger.kernel.org>; Tue, 29 Oct 2024 23:06:11 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.214.170
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1730243174; cv=none; b=T5Z9m9lNQxSzP4ChcMvSO3PtwyNwuz39JFXL4HCmAsL8hdia7A2YbJerbyzlJAK9EbWSwPdeaGHy/IUzPJJR81x5g43SNIlfmAkomt6TSvIBhIKbPjFb7FjWpGys2uOt2pzIVvoxnRo8rff69/0DtYGkKDssa9Dbj38YydXsQFk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1730243174; c=relaxed/simple;
	bh=tV0k/VZ5TuoEDloS5JPFNUwbenb6xvdGhosyfJGcNcE=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=FiWixAxbSQbjlsp60D3r7/YuvLZBgYHc8fU40ZFYepbFeHInFa5W/myi0hTnexAVQWs0BqQZ55SISQfVzeRrn3E56DE4WktzhDjBhHj4hqaQT9zGD2+dwIQjWCWLT4We8csm/A7WxmQNEN8UOIKtCvZ6TsTjouP3EatsFNPeGek=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=davidwei.uk; spf=none smtp.mailfrom=davidwei.uk; dkim=pass (2048-bit key) header.d=davidwei-uk.20230601.gappssmtp.com header.i=@davidwei-uk.20230601.gappssmtp.com header.b=gNDjPtQB; arc=none smtp.client-ip=209.85.214.170
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=davidwei.uk
Authentication-Results: smtp.subspace.kernel.org; spf=none smtp.mailfrom=davidwei.uk
Received: by mail-pl1-f170.google.com with SMTP id d9443c01a7336-20ca7fc4484so41594745ad.3
        for <io-uring@vger.kernel.org>; Tue, 29 Oct 2024 16:06:11 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=davidwei-uk.20230601.gappssmtp.com; s=20230601; t=1730243171; x=1730847971; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=LOYfVYNcOfGrm8jaT/3TDfKqx5ARC0ADEimsIx4MBr8=;
        b=gNDjPtQBhsr1Ve0v+zkMk0eZizqNWb7OGKhUTz9O8PAEEvPRX6Eq+5eyvXdZQBXLU9
         xOXnAfkLq2txb+RPEyJbsnXOIFLg9O3R4Q6JH58tm/GSuDQrF6hiEn+f4aVDzVtJ/Pkj
         0BXUIh97l8Xr2umDN7/b6YyC9LDWUQ7eHz+vwk389UTZuM7Dpw7/gRYgWxa5YbCRwzD1
         9aX9/C6fNtFiVHHXLh8GeTpiC2pQk2HbRzOOqCJD/7EMoz+zFXnemuTNIpYl0uxQc8M6
         lxKcMtzqJPSFAdpWKhoYPxHZCdSO5oracaYQKd4ivYmfLHrAH+qvO242/wHX/ppVN7Gb
         spIQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1730243171; x=1730847971;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=LOYfVYNcOfGrm8jaT/3TDfKqx5ARC0ADEimsIx4MBr8=;
        b=HHmRLUm1iFJcRm/CSMNa8PR18LtXC5eV5CODYC90Ca7emsHwDHfaVAVjsQrjAflu40
         S3cOpLhojmOYQtQ6fbvORyMRlaRfsBxcdwyRgN3wZscPbYvx90W2DQoWFFLAfI5uAczT
         Cio72n96WUXojpX53ayl6/yrvZIGsCjqas6ca/BfAO6SbXCEZCb9Jd5wVCuiPIglh8Id
         TJEl1OcFSyahcDbr4TvbC/x0V3fZPr5vzSL7E3ytyvC297cFsFmujA4GhW5dllp4IYcs
         UuGXGhKvuwAnQFNo0fflbQO2EDts3fuoCVsYx33fGoeXuM5/DHV+jBZoS37uJrUioVRc
         mY5Q==
X-Gm-Message-State: AOJu0YxGM2FIMTnoUBszz8RdDHoGd0jGaVLXMAz7so1GMP8AWxXP6rhs
	ZCMNu87Ri5r6NrCYQOOi0JQAmOZMcNG3Ltcqqdge81h9P3ir4EuEi+rT48l35yVizK9SFjERNyr
	vF9c=
X-Google-Smtp-Source: AGHT+IFx3ivi834yYSwMNCReU/N56jKb4K3093EdWRMD1bzZlUsNDrpnr1tXcpunPI16gYSWvQfl8w==
X-Received: by 2002:a17:902:e542:b0:20b:7388:f74 with SMTP id d9443c01a7336-210c687ce91mr190144355ad.12.1730243171316;
        Tue, 29 Oct 2024 16:06:11 -0700 (PDT)
Received: from localhost (fwdproxy-prn-008.fbsv.net. [2a03:2880:ff:8::face:b00c])
        by smtp.gmail.com with ESMTPSA id d9443c01a7336-210bbf6d31csm70319895ad.77.2024.10.29.16.06.10
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 29 Oct 2024 16:06:10 -0700 (PDT)
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
Subject: [PATCH v7 10/15] io_uring/zcrx: add io_zcrx_area
Date: Tue, 29 Oct 2024 16:05:13 -0700
Message-ID: <20241029230521.2385749-11-dw@davidwei.uk>
X-Mailer: git-send-email 2.43.5
In-Reply-To: <20241029230521.2385749-1-dw@davidwei.uk>
References: <20241029230521.2385749-1-dw@davidwei.uk>
Precedence: bulk
X-Mailing-List: io-uring@vger.kernel.org
List-Id: <io-uring.vger.kernel.org>
List-Subscribe: <mailto:io-uring+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:io-uring+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

From: David Wei <davidhwei@meta.com>

Add io_zcrx_area that represents a region of userspace memory that is
used for zero copy. During ifq registration, userspace passes in the
uaddr and len of userspace memory, which is then pinned by the kernel.
Each net_iov is mapped to one of these pages.

The freelist is a spinlock protected list that keeps track of all the
net_iovs/pages that aren't used.

For now, there is only one area per ifq and area registration happens
implicitly as part of ifq registration. There is no API for
adding/removing areas yet. The struct for area registration is there for
future extensibility once we support multiple areas and TCP devmem.

Signed-off-by: Pavel Begunkov <asml.silence@gmail.com>
Signed-off-by: David Wei <dw@davidwei.uk>
---
 include/uapi/linux/io_uring.h |  9 ++++
 io_uring/rsrc.c               |  2 +-
 io_uring/rsrc.h               |  1 +
 io_uring/zcrx.c               | 93 ++++++++++++++++++++++++++++++++++-
 io_uring/zcrx.h               | 16 ++++++
 5 files changed, 118 insertions(+), 3 deletions(-)

diff --git a/include/uapi/linux/io_uring.h b/include/uapi/linux/io_uring.h
index d398e19f8eea..d43183264dcf 100644
--- a/include/uapi/linux/io_uring.h
+++ b/include/uapi/linux/io_uring.h
@@ -874,6 +874,15 @@ struct io_uring_zcrx_offsets {
 	__u64	__resv[2];
 };
 
+struct io_uring_zcrx_area_reg {
+	__u64	addr;
+	__u64	len;
+	__u64	rq_area_token;
+	__u32	flags;
+	__u32	__resv1;
+	__u64	__resv2[2];
+};
+
 /*
  * Argument for IORING_REGISTER_ZCRX_IFQ
  */
diff --git a/io_uring/rsrc.c b/io_uring/rsrc.c
index fa5f27496aef..a6d44d81f1a1 100644
--- a/io_uring/rsrc.c
+++ b/io_uring/rsrc.c
@@ -86,7 +86,7 @@ static int io_account_mem(struct io_ring_ctx *ctx, unsigned long nr_pages)
 	return 0;
 }
 
-static int io_buffer_validate(struct iovec *iov)
+int io_buffer_validate(struct iovec *iov)
 {
 	unsigned long tmp, acct_len = iov->iov_len + (PAGE_SIZE - 1);
 
diff --git a/io_uring/rsrc.h b/io_uring/rsrc.h
index c50d4be4aa6d..9cc9b1b320e3 100644
--- a/io_uring/rsrc.h
+++ b/io_uring/rsrc.h
@@ -83,6 +83,7 @@ int io_register_rsrc_update(struct io_ring_ctx *ctx, void __user *arg,
 			    unsigned size, unsigned type);
 int io_register_rsrc(struct io_ring_ctx *ctx, void __user *arg,
 			unsigned int size, unsigned int type);
+int io_buffer_validate(struct iovec *iov);
 
 static inline void io_put_rsrc_node(struct io_ring_ctx *ctx, struct io_rsrc_node *node)
 {
diff --git a/io_uring/zcrx.c b/io_uring/zcrx.c
index 4c53fd4f7bb3..a276572fe953 100644
--- a/io_uring/zcrx.c
+++ b/io_uring/zcrx.c
@@ -10,6 +10,7 @@
 #include "kbuf.h"
 #include "memmap.h"
 #include "zcrx.h"
+#include "rsrc.h"
 
 #define IO_RQ_MAX_ENTRIES		32768
 
@@ -38,6 +39,83 @@ static void io_free_rbuf_ring(struct io_zcrx_ifq *ifq)
 	ifq->rqes = NULL;
 }
 
+static void io_zcrx_free_area(struct io_zcrx_area *area)
+{
+	if (area->freelist)
+		kvfree(area->freelist);
+	if (area->nia.niovs)
+		kvfree(area->nia.niovs);
+	if (area->pages) {
+		unpin_user_pages(area->pages, area->nia.num_niovs);
+		kvfree(area->pages);
+	}
+	kfree(area);
+}
+
+static int io_zcrx_create_area(struct io_ring_ctx *ctx,
+			       struct io_zcrx_ifq *ifq,
+			       struct io_zcrx_area **res,
+			       struct io_uring_zcrx_area_reg *area_reg)
+{
+	struct io_zcrx_area *area;
+	int i, ret, nr_pages;
+	struct iovec iov;
+
+	if (area_reg->flags || area_reg->rq_area_token)
+		return -EINVAL;
+	if (area_reg->__resv1 || area_reg->__resv2[0] || area_reg->__resv2[1])
+		return -EINVAL;
+	if (area_reg->addr & ~PAGE_MASK || area_reg->len & ~PAGE_MASK)
+		return -EINVAL;
+
+	iov.iov_base = u64_to_user_ptr(area_reg->addr);
+	iov.iov_len = area_reg->len;
+	ret = io_buffer_validate(&iov);
+	if (ret)
+		return ret;
+
+	ret = -ENOMEM;
+	area = kzalloc(sizeof(*area), GFP_KERNEL);
+	if (!area)
+		goto err;
+
+	area->pages = io_pin_pages((unsigned long)area_reg->addr, area_reg->len,
+				   &nr_pages);
+	if (IS_ERR(area->pages)) {
+		ret = PTR_ERR(area->pages);
+		area->pages = NULL;
+		goto err;
+	}
+	area->nia.num_niovs = nr_pages;
+
+	area->nia.niovs = kvmalloc_array(nr_pages, sizeof(area->nia.niovs[0]),
+					 GFP_KERNEL | __GFP_ZERO);
+	if (!area->nia.niovs)
+		goto err;
+
+	area->freelist = kvmalloc_array(nr_pages, sizeof(area->freelist[0]),
+					GFP_KERNEL | __GFP_ZERO);
+	if (!area->freelist)
+		goto err;
+
+	for (i = 0; i < nr_pages; i++) {
+		area->freelist[i] = i;
+	}
+
+	area->free_count = nr_pages;
+	area->ifq = ifq;
+	/* we're only supporting one area per ifq for now */
+	area->area_id = 0;
+	area_reg->rq_area_token = (u64)area->area_id << IORING_ZCRX_AREA_SHIFT;
+	spin_lock_init(&area->freelist_lock);
+	*res = area;
+	return 0;
+err:
+	if (area)
+		io_zcrx_free_area(area);
+	return ret;
+}
+
 static struct io_zcrx_ifq *io_zcrx_ifq_alloc(struct io_ring_ctx *ctx)
 {
 	struct io_zcrx_ifq *ifq;
@@ -53,6 +131,9 @@ static struct io_zcrx_ifq *io_zcrx_ifq_alloc(struct io_ring_ctx *ctx)
 
 static void io_zcrx_ifq_free(struct io_zcrx_ifq *ifq)
 {
+	if (ifq->area)
+		io_zcrx_free_area(ifq->area);
+
 	io_free_rbuf_ring(ifq);
 	kfree(ifq);
 }
@@ -60,6 +141,7 @@ static void io_zcrx_ifq_free(struct io_zcrx_ifq *ifq)
 int io_register_zcrx_ifq(struct io_ring_ctx *ctx,
 			  struct io_uring_zcrx_ifq_reg __user *arg)
 {
+	struct io_uring_zcrx_area_reg area;
 	struct io_uring_zcrx_ifq_reg reg;
 	struct io_zcrx_ifq *ifq;
 	size_t ring_sz, rqes_sz;
@@ -91,7 +173,7 @@ int io_register_zcrx_ifq(struct io_ring_ctx *ctx,
 	}
 	reg.rq_entries = roundup_pow_of_two(reg.rq_entries);
 
-	if (!reg.area_ptr)
+	if (copy_from_user(&area, u64_to_user_ptr(reg.area_ptr), sizeof(area)))
 		return -EFAULT;
 
 	ifq = io_zcrx_ifq_alloc(ctx);
@@ -102,6 +184,10 @@ int io_register_zcrx_ifq(struct io_ring_ctx *ctx,
 	if (ret)
 		goto err;
 
+	ret = io_zcrx_create_area(ctx, ifq, &ifq->area, &area);
+	if (ret)
+		goto err;
+
 	ifq->rq_entries = reg.rq_entries;
 	ifq->if_rxq = reg.if_rxq;
 
@@ -116,7 +202,10 @@ int io_register_zcrx_ifq(struct io_ring_ctx *ctx,
 		ret = -EFAULT;
 		goto err;
 	}
-
+	if (copy_to_user(u64_to_user_ptr(reg.area_ptr), &area, sizeof(area))) {
+		ret = -EFAULT;
+		goto err;
+	}
 	ctx->ifq = ifq;
 	return 0;
 err:
diff --git a/io_uring/zcrx.h b/io_uring/zcrx.h
index 1f76eecac5fd..a8db61498c67 100644
--- a/io_uring/zcrx.h
+++ b/io_uring/zcrx.h
@@ -3,10 +3,26 @@
 #define IOU_ZC_RX_H
 
 #include <linux/io_uring_types.h>
+#include <net/page_pool/types.h>
+
+struct io_zcrx_area {
+	struct net_iov_area	nia;
+	struct io_zcrx_ifq	*ifq;
+
+	u16			area_id;
+	struct page		**pages;
+
+	/* freelist */
+	spinlock_t		freelist_lock ____cacheline_aligned_in_smp;
+	u32			free_count;
+	u32			*freelist;
+};
 
 struct io_zcrx_ifq {
 	struct io_ring_ctx		*ctx;
 	struct net_device		*dev;
+	struct io_zcrx_area		*area;
+
 	struct io_uring			*rq_ring;
 	struct io_uring_zcrx_rqe 	*rqes;
 	u32				rq_entries;
-- 
2.43.5


