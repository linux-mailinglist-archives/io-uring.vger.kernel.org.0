Return-Path: <io-uring+bounces-5936-lists+io-uring=lfdr.de@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [IPv6:2604:1380:45e3:2400::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 056E3A1454A
	for <lists+io-uring@lfdr.de>; Fri, 17 Jan 2025 00:18:59 +0100 (CET)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 443183AA98B
	for <lists+io-uring@lfdr.de>; Thu, 16 Jan 2025 23:18:30 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 0024324225A;
	Thu, 16 Jan 2025 23:17:24 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=davidwei-uk.20230601.gappssmtp.com header.i=@davidwei-uk.20230601.gappssmtp.com header.b="MvZZe1Y1"
X-Original-To: io-uring@vger.kernel.org
Received: from mail-pl1-f176.google.com (mail-pl1-f176.google.com [209.85.214.176])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 59CEF244FAB
	for <io-uring@vger.kernel.org>; Thu, 16 Jan 2025 23:17:22 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.214.176
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1737069443; cv=none; b=RQ9fPFUsx/ynfITsEPGgnfdk4CM90UAsgrv04GloYzHSHe/TUOaJiwXRJvyN8ks6o7pbQtYPL5kOS/7aoCBUyNjwehS4jrmDvBc7mlCLIqd0V8iFk+7iOUTFySqJ8jsXKeLzejKAZ7Y3OtSwseLcdrLjcRHQJaArjQ8Bg1Lz3bA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1737069443; c=relaxed/simple;
	bh=XVYbxLhQjPLjRXvHRi0K/kcnMc22GtAVQg7MWFvQ9yk=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=nFqGiLmV899K/H7sp0+IqITiAJfQynK45DSHdLZ6MS9NgM81LAQjB9c/pRbb4Dnpg2A0wNUrRtpvFyUxBK6y73mMQ0lFC5CJQwSzhQtFxfKy0G2p6W4qHWXhxaWW6OT0Cpyjd96WAN4o6iiiDi7rG12P5j0xCh5CKxT0c74K6lg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=davidwei.uk; spf=none smtp.mailfrom=davidwei.uk; dkim=pass (2048-bit key) header.d=davidwei-uk.20230601.gappssmtp.com header.i=@davidwei-uk.20230601.gappssmtp.com header.b=MvZZe1Y1; arc=none smtp.client-ip=209.85.214.176
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=davidwei.uk
Authentication-Results: smtp.subspace.kernel.org; spf=none smtp.mailfrom=davidwei.uk
Received: by mail-pl1-f176.google.com with SMTP id d9443c01a7336-21bc1512a63so29741245ad.1
        for <io-uring@vger.kernel.org>; Thu, 16 Jan 2025 15:17:22 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=davidwei-uk.20230601.gappssmtp.com; s=20230601; t=1737069441; x=1737674241; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=HANf/wnrk/pvHPDftSyBB7C0ozx5QMtCSP2F71f05Iw=;
        b=MvZZe1Y1O7rb32DRE+4qjIZeJs2csAUutgPoZ9eHczjgW1AAou+NIxFH0HttnAC6RZ
         s8H0X9OWmlYCDE2O7xwwU+xfvQB9lx6eQ2VmMxG1ccPCwopDzRm7T7rTcSVsTN//udD7
         xtpmqEyLMxYVLowBeaDDD9SKALUqkaCqNPOLPeInLdAYlP8+XAR24Vnpnt8kB3u0IZy/
         b4MoOGITknKTrSGIw+/xxqtZcS7YvC3S+Ceksz3YDqIgysUAxCTOuJxiVjLJnqniCfaD
         9maJddZoJz4uWPpIp5BCX2Praa79ofJrIccika9SRR0/zhibo01pJPqg0X0MBHCnemRk
         le2A==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1737069441; x=1737674241;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=HANf/wnrk/pvHPDftSyBB7C0ozx5QMtCSP2F71f05Iw=;
        b=SnJ5YGgw6vpH/z7u4ZxkBrCubXjKKnQHjHg7ROj7SwXh0dk+qY7ES439Q9trFCiEZa
         8p+pzS9De1c83eAvv+wbwmRU0bDTR3wsxVcRvTRDG31Q/2hO/7n8xbA+a0HBUkFqNbp0
         B4Zwh6kdiX1TZnrwcfeQQqWfE8jWGYyYZiAeL2yuWUOcpwiDxGQrtULZjtaKBvnLN91i
         5+1X3elRzScESfg/7DpuPDnvg4QZBK/dDD6O13Lhnws5C0LHQ1DLZ06j5jqa/BAedFkX
         p9qJX2JCif9CEkDmmOIWZc+aa3w11MLy2BZ3X+sxcVK3jd6EH+imjwD1+CINRKW/NECU
         czHw==
X-Gm-Message-State: AOJu0Yx7vlj4Rjp809rX9Gr/u25ILwAg3VUcQF44eNAJkg3rctLU7Qxj
	rBe68Njc+9LF1+jjVW0NrJgs5y8gtDNUgiW0dzhXI/1ahNHXaSJTn91zD2YcIzvC6wjyxpGC7Ks
	w
X-Gm-Gg: ASbGncvQwxtEqreumzRNf+zYV9fYa3DPhkENYlyY/UDWgbp8qVCqIP1kGde6TLaM7cq
	FP7clvxRtK4cztvApLjHux0yPsFfHeiw73q8CTE5nfFKdwwDUOmS5lEg1r7rcO4X4hGGhm6pwLi
	nGPJ74meBJbVOGmtHbAqi+dR+TiuPtDfH/ER2PaXzQ9NSr2l1YYnlAwHxMiJfGPn1JCyFv7uebf
	62Nfrdp1ejdiHfCpW+RWnWsI/LcPnTsrwnx3NCj
X-Google-Smtp-Source: AGHT+IHKmtqGZ3DuT1s5D1Hn2JAQovJAToxkSXCy1ODozv0T3FPBRLo5+NSdTtDZeaNF7dKNCmzj8A==
X-Received: by 2002:a17:902:e802:b0:21b:d105:26b8 with SMTP id d9443c01a7336-21c3553b20fmr8203195ad.7.1737069441620;
        Thu, 16 Jan 2025 15:17:21 -0800 (PST)
Received: from localhost ([2a03:2880:ff:9::])
        by smtp.gmail.com with ESMTPSA id d9443c01a7336-21c2ceb833csm5107095ad.67.2025.01.16.15.17.21
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 16 Jan 2025 15:17:21 -0800 (PST)
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
Subject: [PATCH net-next v11 12/21] io_uring/zcrx: add io_zcrx_area
Date: Thu, 16 Jan 2025 15:16:54 -0800
Message-ID: <20250116231704.2402455-13-dw@davidwei.uk>
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


