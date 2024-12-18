Return-Path: <io-uring+bounces-5549-lists+io-uring=lfdr.de@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [147.75.80.249])
	by mail.lfdr.de (Postfix) with ESMTPS id DD6239F5BCA
	for <lists+io-uring@lfdr.de>; Wed, 18 Dec 2024 01:41:02 +0100 (CET)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id C41B5188484E
	for <lists+io-uring@lfdr.de>; Wed, 18 Dec 2024 00:39:43 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 2175A13A87C;
	Wed, 18 Dec 2024 00:38:11 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=davidwei-uk.20230601.gappssmtp.com header.i=@davidwei-uk.20230601.gappssmtp.com header.b="wI2Bf7vk"
X-Original-To: io-uring@vger.kernel.org
Received: from mail-pf1-f180.google.com (mail-pf1-f180.google.com [209.85.210.180])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8D607136671
	for <io-uring@vger.kernel.org>; Wed, 18 Dec 2024 00:38:09 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.210.180
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1734482291; cv=none; b=lXHMLYxOTf1WHIWLQbtFQvQywDD/Nmwf/qgRqSJrxCat7zJtKo1CFsVlbdqBZKDRprTXE9kGIcD5e6ZxMYI5UIRLCTW2WMfnppNKNNUHz7RysmtSidTq/jk4+OJj9+ed/7YVOa+31KP2F+WyE/kkNmyEnNUNZVN3g5al/1NI2EM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1734482291; c=relaxed/simple;
	bh=XVYbxLhQjPLjRXvHRi0K/kcnMc22GtAVQg7MWFvQ9yk=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=YU4qtqvNwofQAEKyCcUqQcaC6HTX8mOmYXu6zLzDnqS69Mgx/8m6Vj3zYetFvsLMA6RKsfdGWUwSbHpDQjneqAZUI4e/wY8F+ueoelK+86iU4K3KSihwOtTtxqbnIu7KRXUgIg0Okri7Ep1OTyJ9CTrZEdy4eOKFxP9TPnU7ouY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=davidwei.uk; spf=none smtp.mailfrom=davidwei.uk; dkim=pass (2048-bit key) header.d=davidwei-uk.20230601.gappssmtp.com header.i=@davidwei-uk.20230601.gappssmtp.com header.b=wI2Bf7vk; arc=none smtp.client-ip=209.85.210.180
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=davidwei.uk
Authentication-Results: smtp.subspace.kernel.org; spf=none smtp.mailfrom=davidwei.uk
Received: by mail-pf1-f180.google.com with SMTP id d2e1a72fcca58-7273967f2f0so6378560b3a.1
        for <io-uring@vger.kernel.org>; Tue, 17 Dec 2024 16:38:09 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=davidwei-uk.20230601.gappssmtp.com; s=20230601; t=1734482289; x=1735087089; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=HANf/wnrk/pvHPDftSyBB7C0ozx5QMtCSP2F71f05Iw=;
        b=wI2Bf7vkEgNSMpNGiJieO4cjUkpsU46eQtAJzuECjeH+wTEPm27o408YgF4eQp7uzN
         Xuwkqo10mrX4tfVjwON/hJNasQsaqizdMGFARCQXiq7A6RRdt8pDh3kHDgRzIHYBI9wO
         SYzVKbTHPrWYzHQjtFFcl5mVM+A+Nwy23QdOC9PaoJKR4VTj0BRZYK1fqjvvsEOqImID
         YJ9gEB/NfFJAjE2PPFX58E8I6GQNp4u98vOdM/vdU6RClRZ9Mduato0PySkkTBKln8YN
         0kzlqbDanEMzrdV9WNSUl1qui29PaYDbMHSg26idfWPg+JCbdbZF2vK30SMqlpOIadkJ
         NszA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1734482289; x=1735087089;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=HANf/wnrk/pvHPDftSyBB7C0ozx5QMtCSP2F71f05Iw=;
        b=ZQ1fotjFE++FlTv+LKUyVTIDg5soVoCheh1IJ2u4cuRF8pRPiHWJDnkF6hA+/fT/8U
         0jKZ9XpYbS4uAqWhrz/rsgzt2S5BdOhLALbepTNtOVmADZWN8EYKS0wwauW5jbKmwwOw
         Hkc3JBRhFNvMU0fTg6V1ejKpqE4Qcg+wyDi3DyqAvuIc3+fVgxOBSpr2+/Em4UwgtJ4e
         nxm5DM8o19lvP9HXltrEhIDaXDptKE/ewhlq4ScaqMtRLFffxCpHkwKiET50ENcSXc21
         iA7GkM/uLHRl7QtsRE3BdyoCKtnoqlKTfFioilCua/JLhbP1q6WGb5gXid2sG8uHG5xF
         FwNw==
X-Gm-Message-State: AOJu0YwRrhADBWDTQ32GQJB/BPcpXjpxh1o3yJDu0UDZ90FJJ3C21NWX
	APlFT+KrCHP3ZQAbmswCalE6duuLEQWKVWhOHJlx5XlU9B6QPTu5guWFaaujWmEnlFTz6u13AEn
	u
X-Gm-Gg: ASbGnctoHyikYvtLoODdfOgiy6OZogqFIaQNMct/gPxs6Bzgo7bVU633ET7vS1WloCz
	kk+zrF4bltWoOXaSasbUo8kLV5wDUsTEENQ40DBq9KqoXWo9K+zh3r3jDDtlFwFBNqPNkbtxK4V
	pBEZZYe42fWbbp1Hn2ubyqjc9nRm+dTWyKd57aYp42asuQSMm/2lGJ9Bxej+yy92pp6D3HX82ug
	vyVJL2ijDYQ2R8zxyR2KuLxbEpCPwjRjWfzy7DmFQ==
X-Google-Smtp-Source: AGHT+IEJ4oMREpx4hC8kdpG2v5TKjl5T0w2x7ZOX3BVlIgvY0lWq99NTd4GiF/rpFhPK3mVC2Bitmg==
X-Received: by 2002:a05:6a00:3a28:b0:725:e05a:c975 with SMTP id d2e1a72fcca58-72a8d2c9a60mr1680795b3a.19.1734482288800;
        Tue, 17 Dec 2024 16:38:08 -0800 (PST)
Received: from localhost ([2a03:2880:ff:1d::])
        by smtp.gmail.com with ESMTPSA id d2e1a72fcca58-72918bb4635sm7321271b3a.169.2024.12.17.16.38.08
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 17 Dec 2024 16:38:08 -0800 (PST)
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
Subject: [PATCH net-next v9 11/20] io_uring/zcrx: add io_zcrx_area
Date: Tue, 17 Dec 2024 16:37:37 -0800
Message-ID: <20241218003748.796939-12-dw@davidwei.uk>
X-Mailer: git-send-email 2.43.5
In-Reply-To: <20241218003748.796939-1-dw@davidwei.uk>
References: <20241218003748.796939-1-dw@davidwei.uk>
Precedence: bulk
X-Mailing-List: io-uring@vger.kernel.org
List-Id: <io-uring.vger.kernel.org>
List-Subscribe: <mailto:io-uring+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:io-uring+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

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

Reviewed-by: Jens Axboe <axboe@kernel.dk>
Signed-off-by: Pavel Begunkov <asml.silence@gmail.com>
Signed-off-by: David Wei <dw@davidwei.uk>
---
 include/uapi/linux/io_uring.h |  9 ++++
 io_uring/rsrc.c               |  2 +-
 io_uring/rsrc.h               |  1 +
 io_uring/zcrx.c               | 89 ++++++++++++++++++++++++++++++++++-
 io_uring/zcrx.h               | 16 +++++++
 5 files changed, 114 insertions(+), 3 deletions(-)

diff --git a/include/uapi/linux/io_uring.h b/include/uapi/linux/io_uring.h
index 3af8b7a19824..e251f28507ce 100644
--- a/include/uapi/linux/io_uring.h
+++ b/include/uapi/linux/io_uring.h
@@ -980,6 +980,15 @@ struct io_uring_zcrx_offsets {
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
index f2ff108485c8..d0f11b5aec0d 100644
--- a/io_uring/rsrc.c
+++ b/io_uring/rsrc.c
@@ -77,7 +77,7 @@ static int io_account_mem(struct io_ring_ctx *ctx, unsigned long nr_pages)
 	return 0;
 }
 
-static int io_buffer_validate(struct iovec *iov)
+int io_buffer_validate(struct iovec *iov)
 {
 	unsigned long tmp, acct_len = iov->iov_len + (PAGE_SIZE - 1);
 
diff --git a/io_uring/rsrc.h b/io_uring/rsrc.h
index c8b093584461..0ae54ddeb1fd 100644
--- a/io_uring/rsrc.h
+++ b/io_uring/rsrc.h
@@ -66,6 +66,7 @@ int io_register_rsrc_update(struct io_ring_ctx *ctx, void __user *arg,
 			    unsigned size, unsigned type);
 int io_register_rsrc(struct io_ring_ctx *ctx, void __user *arg,
 			unsigned int size, unsigned int type);
+int io_buffer_validate(struct iovec *iov);
 
 bool io_check_coalesce_buffer(struct page **page_array, int nr_pages,
 			      struct io_imu_folio_data *data);
diff --git a/io_uring/zcrx.c b/io_uring/zcrx.c
index f3ace7e8264d..04883a3ae80c 100644
--- a/io_uring/zcrx.c
+++ b/io_uring/zcrx.c
@@ -10,6 +10,7 @@
 #include "kbuf.h"
 #include "memmap.h"
 #include "zcrx.h"
+#include "rsrc.h"
 
 #define IO_RQ_MAX_ENTRIES		32768
 
@@ -44,6 +45,79 @@ static void io_free_rbuf_ring(struct io_zcrx_ifq *ifq)
 	ifq->rqes = NULL;
 }
 
+static void io_zcrx_free_area(struct io_zcrx_area *area)
+{
+	kvfree(area->freelist);
+	kvfree(area->nia.niovs);
+	if (area->pages) {
+		unpin_user_pages(area->pages, area->nia.num_niovs);
+		kvfree(area->pages);
+	}
+	kfree(area);
+}
+
+static int io_zcrx_create_area(struct io_zcrx_ifq *ifq,
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
+	for (i = 0; i < nr_pages; i++)
+		area->freelist[i] = i;
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
@@ -59,6 +133,9 @@ static struct io_zcrx_ifq *io_zcrx_ifq_alloc(struct io_ring_ctx *ctx)
 
 static void io_zcrx_ifq_free(struct io_zcrx_ifq *ifq)
 {
+	if (ifq->area)
+		io_zcrx_free_area(ifq->area);
+
 	io_free_rbuf_ring(ifq);
 	kfree(ifq);
 }
@@ -66,6 +143,7 @@ static void io_zcrx_ifq_free(struct io_zcrx_ifq *ifq)
 int io_register_zcrx_ifq(struct io_ring_ctx *ctx,
 			  struct io_uring_zcrx_ifq_reg __user *arg)
 {
+	struct io_uring_zcrx_area_reg area;
 	struct io_uring_zcrx_ifq_reg reg;
 	struct io_uring_region_desc rd;
 	struct io_zcrx_ifq *ifq;
@@ -99,7 +177,7 @@ int io_register_zcrx_ifq(struct io_ring_ctx *ctx,
 	}
 	reg.rq_entries = roundup_pow_of_two(reg.rq_entries);
 
-	if (!reg.area_ptr)
+	if (copy_from_user(&area, u64_to_user_ptr(reg.area_ptr), sizeof(area)))
 		return -EFAULT;
 
 	ifq = io_zcrx_ifq_alloc(ctx);
@@ -110,6 +188,10 @@ int io_register_zcrx_ifq(struct io_ring_ctx *ctx,
 	if (ret)
 		goto err;
 
+	ret = io_zcrx_create_area(ifq, &ifq->area, &area);
+	if (ret)
+		goto err;
+
 	ifq->rq_entries = reg.rq_entries;
 	ifq->if_rxq = reg.if_rxq;
 
@@ -122,7 +204,10 @@ int io_register_zcrx_ifq(struct io_ring_ctx *ctx,
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
index 58e4ab6c6083..53fd94b65b38 100644
--- a/io_uring/zcrx.h
+++ b/io_uring/zcrx.h
@@ -3,9 +3,25 @@
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
+	struct io_zcrx_area		*area;
+
 	struct io_uring			*rq_ring;
 	struct io_uring_zcrx_rqe	*rqes;
 	u32				rq_entries;
-- 
2.43.5


