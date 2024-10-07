Return-Path: <io-uring+bounces-3452-lists+io-uring=lfdr.de@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from sy.mirrors.kernel.org (sy.mirrors.kernel.org [147.75.48.161])
	by mail.lfdr.de (Postfix) with ESMTPS id C643E993A03
	for <lists+io-uring@lfdr.de>; Tue,  8 Oct 2024 00:17:43 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sy.mirrors.kernel.org (Postfix) with ESMTPS id 3116CB23146
	for <lists+io-uring@lfdr.de>; Mon,  7 Oct 2024 22:17:41 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 0EFC5194A4B;
	Mon,  7 Oct 2024 22:16:42 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=davidwei-uk.20230601.gappssmtp.com header.i=@davidwei-uk.20230601.gappssmtp.com header.b="FlIOqRmw"
X-Original-To: io-uring@vger.kernel.org
Received: from mail-pl1-f170.google.com (mail-pl1-f170.google.com [209.85.214.170])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9086419306C
	for <io-uring@vger.kernel.org>; Mon,  7 Oct 2024 22:16:40 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.214.170
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1728339401; cv=none; b=CEC8W8hso45C9Z68t/4SJSnVZA+LyqbOiCsFqG8RXcozEgKoRl3CFdF2pQq6n8w5L7ktl5FKmSP9z23k2brPExH/R24G+WY+QXsLZ3P2StZ979FvAod0Hv4DuLshvx8YQkgFnb2GvHqkK4obGA8jxZbxMQrDd3K+z/UYiyNTyVk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1728339401; c=relaxed/simple;
	bh=iQqYs6usFP25njJko5JRYcKx1VwHRiofw9tOmNkUUg4=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=oBSLnrnQynz6mAFkBef3DEz16sMZ6JBtje0TQReo/ipSyrf/W07Tk+qN8ptF3Qey4ehBfj1pUsqcL/3+DKjdRkMHMJkrV3yfIwrvDndlyGbHt4KOMi8Tce+hJ1PYshnRxVnj22yLm6AMt2RDPZIQHJsVwJ2UC1/kH89NRWXdR98=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=davidwei.uk; spf=none smtp.mailfrom=davidwei.uk; dkim=pass (2048-bit key) header.d=davidwei-uk.20230601.gappssmtp.com header.i=@davidwei-uk.20230601.gappssmtp.com header.b=FlIOqRmw; arc=none smtp.client-ip=209.85.214.170
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=davidwei.uk
Authentication-Results: smtp.subspace.kernel.org; spf=none smtp.mailfrom=davidwei.uk
Received: by mail-pl1-f170.google.com with SMTP id d9443c01a7336-20b90ab6c19so53135785ad.0
        for <io-uring@vger.kernel.org>; Mon, 07 Oct 2024 15:16:40 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=davidwei-uk.20230601.gappssmtp.com; s=20230601; t=1728339400; x=1728944200; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=W6nAZRIB2D57h+CRarYB+vjyW8oJUse6eShdZAdmZOQ=;
        b=FlIOqRmwetFct0+1Ci7igyS/To0PC0h4A6vyT1VG5pRmDHXX/tlPCnUtq+vqQjtQHF
         EAypSWDZxy3+B7UzEP7CCVRTOX3mpc+3Q8LMLbyyZhA9ZVgG1KZwvQcilZijqJVfu68u
         xJfdBLEhHpiHv74GTgDsaivLs7moURT2lUVRl1h7famy0GukrdvflLcoPIrSdZTP9lOg
         Sd2OfzetyccaUwaKqvM65SQUq248heMO9WjI75khb38cmdMTr/0FO3MuHGDg0g5n6A4z
         222/FltIO1nBqGDNCz1WHZPMd7ZonFChGjuAqHUFZRt2FNY7UEefGW6ZJxn//yqzP6Bd
         D1/A==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1728339400; x=1728944200;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=W6nAZRIB2D57h+CRarYB+vjyW8oJUse6eShdZAdmZOQ=;
        b=d39ZNhzknshV74ze7croe6EM6k5Nu45AZo8su51+L5ME6IyoU1KrV7Zfpt+h3kcnqp
         0x19GVLMoxi3W0sCCLAGPanodKLa7y8ThxYpWQktBYOus5pOB1gT3pfkvy7MOYxXoAzE
         3rByDEKekU4Xj5yNtfArtPIV1NZ7UT1+m2ISWXQrYMKcGfHGhwEscTgpgmMzq0OPbhZp
         sFNXhaSCK3uTHkqUYOLP72t8uRueaea/FdiMCp1NZtuNojfwv4xdLbeIGhs1wh/Zkmxj
         N0H/PpU9vAPB8RU3WmWLmB+fY21L9wQH4eyFPReYNHeCRdojVi50IN+6ajCIlAUr8B9o
         G8mg==
X-Gm-Message-State: AOJu0Yy2J2FqvH2Zc1dDE3Ld6YoixwjXo728LndD0SBuIJvIjSupbirR
	qw2AnMxlLBma/kQT3M8GDeLu+HRh8BJHI0TYxqI37eB82ddjDiSKaKEEdCSmzIzGdb2lBl2YZm+
	b
X-Google-Smtp-Source: AGHT+IHlR+Ip6p5EQgh0qVKVZ71k4429xDchgj1lklos+meUcc/KSh5DkItonBDDj01eGwoTz0hezw==
X-Received: by 2002:a17:903:2442:b0:207:1675:6709 with SMTP id d9443c01a7336-20bfd9a527bmr195733225ad.0.1728339399777;
        Mon, 07 Oct 2024 15:16:39 -0700 (PDT)
Received: from localhost (fwdproxy-prn-018.fbsv.net. [2a03:2880:ff:12::face:b00c])
        by smtp.gmail.com with ESMTPSA id d9443c01a7336-20c139a125asm44245585ad.292.2024.10.07.15.16.39
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 07 Oct 2024 15:16:39 -0700 (PDT)
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
Subject: [PATCH v1 10/15] io_uring/zcrx: add io_zcrx_area
Date: Mon,  7 Oct 2024 15:15:58 -0700
Message-ID: <20241007221603.1703699-11-dw@davidwei.uk>
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
index 567cdb89711e..ffd315d8c6b5 100644
--- a/include/uapi/linux/io_uring.h
+++ b/include/uapi/linux/io_uring.h
@@ -831,6 +831,15 @@ struct io_uring_zcrx_offsets {
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
index 453867add7ca..42606404019e 100644
--- a/io_uring/rsrc.c
+++ b/io_uring/rsrc.c
@@ -85,7 +85,7 @@ static int io_account_mem(struct io_ring_ctx *ctx, unsigned long nr_pages)
 	return 0;
 }
 
-static int io_buffer_validate(struct iovec *iov)
+int io_buffer_validate(struct iovec *iov)
 {
 	unsigned long tmp, acct_len = iov->iov_len + (PAGE_SIZE - 1);
 
diff --git a/io_uring/rsrc.h b/io_uring/rsrc.h
index c032ca3436ca..e691e8ed849b 100644
--- a/io_uring/rsrc.h
+++ b/io_uring/rsrc.h
@@ -74,6 +74,7 @@ int io_register_rsrc_update(struct io_ring_ctx *ctx, void __user *arg,
 			    unsigned size, unsigned type);
 int io_register_rsrc(struct io_ring_ctx *ctx, void __user *arg,
 			unsigned int size, unsigned int type);
+int io_buffer_validate(struct iovec *iov);
 
 static inline void io_put_rsrc_node(struct io_ring_ctx *ctx, struct io_rsrc_node *node)
 {
diff --git a/io_uring/zcrx.c b/io_uring/zcrx.c
index 79d79b9b8df8..8382129402ac 100644
--- a/io_uring/zcrx.c
+++ b/io_uring/zcrx.c
@@ -10,6 +10,7 @@
 #include "kbuf.h"
 #include "memmap.h"
 #include "zcrx.h"
+#include "rsrc.h"
 
 #define IO_RQ_MAX_ENTRIES		32768
 
@@ -40,6 +41,83 @@ static void io_free_rbuf_ring(struct io_zcrx_ifq *ifq)
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
@@ -55,6 +133,9 @@ static struct io_zcrx_ifq *io_zcrx_ifq_alloc(struct io_ring_ctx *ctx)
 
 static void io_zcrx_ifq_free(struct io_zcrx_ifq *ifq)
 {
+	if (ifq->area)
+		io_zcrx_free_area(ifq->area);
+
 	io_free_rbuf_ring(ifq);
 	kfree(ifq);
 }
@@ -62,6 +143,7 @@ static void io_zcrx_ifq_free(struct io_zcrx_ifq *ifq)
 int io_register_zcrx_ifq(struct io_ring_ctx *ctx,
 			  struct io_uring_zcrx_ifq_reg __user *arg)
 {
+	struct io_uring_zcrx_area_reg area;
 	struct io_uring_zcrx_ifq_reg reg;
 	struct io_zcrx_ifq *ifq;
 	size_t ring_sz, rqes_sz;
@@ -93,7 +175,7 @@ int io_register_zcrx_ifq(struct io_ring_ctx *ctx,
 	}
 	reg.rq_entries = roundup_pow_of_two(reg.rq_entries);
 
-	if (!reg.area_ptr)
+	if (copy_from_user(&area, u64_to_user_ptr(reg.area_ptr), sizeof(area)))
 		return -EFAULT;
 
 	ifq = io_zcrx_ifq_alloc(ctx);
@@ -104,6 +186,10 @@ int io_register_zcrx_ifq(struct io_ring_ctx *ctx,
 	if (ret)
 		goto err;
 
+	ret = io_zcrx_create_area(ctx, ifq, &ifq->area, &area);
+	if (ret)
+		goto err;
+
 	ifq->rq_entries = reg.rq_entries;
 	ifq->if_rxq = reg.if_rxq;
 
@@ -118,7 +204,10 @@ int io_register_zcrx_ifq(struct io_ring_ctx *ctx,
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
index 4ef94e19d36b..2fcbeb3d5501 100644
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


