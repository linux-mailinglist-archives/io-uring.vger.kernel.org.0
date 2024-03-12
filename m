Return-Path: <io-uring+bounces-914-lists+io-uring=lfdr.de@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from sy.mirrors.kernel.org (sy.mirrors.kernel.org [IPv6:2604:1380:40f1:3f00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 08261879DCE
	for <lists+io-uring@lfdr.de>; Tue, 12 Mar 2024 22:47:41 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sy.mirrors.kernel.org (Postfix) with ESMTPS id 111BEB20B04
	for <lists+io-uring@lfdr.de>; Tue, 12 Mar 2024 21:47:38 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 0DAD1145FFF;
	Tue, 12 Mar 2024 21:44:48 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=davidwei-uk.20230601.gappssmtp.com header.i=@davidwei-uk.20230601.gappssmtp.com header.b="XSUj7XUb"
X-Original-To: io-uring@vger.kernel.org
Received: from mail-pl1-f173.google.com (mail-pl1-f173.google.com [209.85.214.173])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 87C57145FEC
	for <io-uring@vger.kernel.org>; Tue, 12 Mar 2024 21:44:46 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.214.173
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1710279887; cv=none; b=GUnjuCbO5J8c5hPcWiOxTgecR1tlDHiqhN8pRkFIrligUiRSxZ99sxHKTcakNowppMnMyoqpj6oCdlOTKVbwoZg5xFFwfC5GfP4N70OovhSDEHUvjwfhdfutH0DofUiuVktng+SFEynwM9SoBG4sLzqa4pCQ2a/7oSaTOgzuYq4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1710279887; c=relaxed/simple;
	bh=aeHuFMOyRuZ3XW+Rnr2l0qtWQLXFbMfZhOAAcqgGQ2Q=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=hVEwBnoBGzx5GgXZeKyNEWofGM5c98jEUyDuKokueix6gOg+wNZvVzoUpld2/AIbA+yu3Z87joAGbftXYiy7lC8pTeHzKIA75wwpSzSvp24XnBQt7XYIwOmZG6QJuhEMUjxwEDI4Cliy3pUTjCk/aHqhJcQhAdn3Sp7I2/HOlkY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=davidwei.uk; spf=none smtp.mailfrom=davidwei.uk; dkim=pass (2048-bit key) header.d=davidwei-uk.20230601.gappssmtp.com header.i=@davidwei-uk.20230601.gappssmtp.com header.b=XSUj7XUb; arc=none smtp.client-ip=209.85.214.173
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=davidwei.uk
Authentication-Results: smtp.subspace.kernel.org; spf=none smtp.mailfrom=davidwei.uk
Received: by mail-pl1-f173.google.com with SMTP id d9443c01a7336-1dc09556599so49856835ad.1
        for <io-uring@vger.kernel.org>; Tue, 12 Mar 2024 14:44:46 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=davidwei-uk.20230601.gappssmtp.com; s=20230601; t=1710279886; x=1710884686; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=wAVR2O4v3CTtiY0k6MfQnUcvPzTNjtLVzW6+B1SUorQ=;
        b=XSUj7XUbLVzsTFJjQFtzb2sF05IafY7VEjIqHcN8oLrYy97wM2xSD54BTQmgX6zOQd
         nVdU56hbcpw1NghWz7IYnow3Nj1NOYwu2V/ocoWwozVtD3QKsSdG5nIAnA65Wp+G2tKX
         24sQ11duV0qjvG8FyuKVY3TVI8cGlRXkRAFOG8GRCjefqoVq0kACuhv7tussnS1rqVtI
         YlZIXzadQDhmhp2c7RvsQdFI9Qu/q1uh+FELRbhRvAgF2cylJrvqS2k+05A+BEOLKZze
         vOFcqkB/vPZpLvs2D2jF4PU1frBcNDaO6ZfDNE7AeXoRq9eLWkrLImbBf2NQeJaOp1Bj
         OZ1g==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1710279886; x=1710884686;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=wAVR2O4v3CTtiY0k6MfQnUcvPzTNjtLVzW6+B1SUorQ=;
        b=xOke9H3amxlx0JA3B2kLTFmR1v3xPZVSX0x6s+IjKY0r/DD+RNUtxGcN1Tyy1o4r9Y
         l6bTetAcTP6vh+MVLqfpQ4Bt4AYdKOaHtQwhsUZOfZJ+4SwH9RPZCYIb1eWJ/6dH3nBv
         a+tOmguaF0zI6ZpaxNHrDYqr7ZqcURDnwtkMJSMqf0NDsphHkoCRhX+teEB/QqIwMKPk
         70KzkkOgephp6hudrqQsrD9G72fFfxSxRp9jO3UyRbv3DXC5lgO1PHnI2JrrfBdNAonT
         FcJgZhqqkOauKp1sZ1e8GHw1X2eprDK679Fl6ChWZ5RVn139xxMpCnK4u4iRaVjfcFi/
         1/3Q==
X-Gm-Message-State: AOJu0Yw5Fs0Chc7QD23+M6o8IhW3Lflt/OoPELTbuoGdIRBeWoeqfmHK
	uvM9Fq48OsIK25ybDIIVRLCME9GjmKXfiyY1iu+2uOd5KnPpeiibwiWSjLxtQAznkUDCqOnKGzH
	Q
X-Google-Smtp-Source: AGHT+IGmqJhtdBjWOobQoRY8deHIp2H+HZWi2xEjoE27n/25R3VmXSVpOS4wZto79bOen1D1uAkOng==
X-Received: by 2002:a17:903:244d:b0:1dd:b140:d00e with SMTP id l13-20020a170903244d00b001ddb140d00emr5551806pls.18.1710279885698;
        Tue, 12 Mar 2024 14:44:45 -0700 (PDT)
Received: from localhost (fwdproxy-prn-016.fbsv.net. [2a03:2880:ff:10::face:b00c])
        by smtp.gmail.com with ESMTPSA id k8-20020a170902760800b001dc10796951sm7250819pll.19.2024.03.12.14.44.45
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 12 Mar 2024 14:44:45 -0700 (PDT)
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
	Mina Almasry <almasrymina@google.com>
Subject: [RFC PATCH v4 12/16] io_uring/zcrx: implement PP_FLAG_DMA_* handling
Date: Tue, 12 Mar 2024 14:44:26 -0700
Message-ID: <20240312214430.2923019-13-dw@davidwei.uk>
X-Mailer: git-send-email 2.43.0
In-Reply-To: <20240312214430.2923019-1-dw@davidwei.uk>
References: <20240312214430.2923019-1-dw@davidwei.uk>
Precedence: bulk
X-Mailing-List: io-uring@vger.kernel.org
List-Id: <io-uring.vger.kernel.org>
List-Subscribe: <mailto:io-uring+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:io-uring+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

From: Pavel Begunkov <asml.silence@gmail.com>

The patch implements support for PP_FLAG_DMA_MAP and
PP_FLAG_DMA_SYNC_DEV. Dma map buffers when creating a page pool if
needed, and unmap on tear down. Most of synching is done by page pool
apart from when we're grabbing buffers from the refill ring, in which
case it we need to do it by hand.

Signed-off-by: Pavel Begunkov <asml.silence@gmail.com>
Signed-off-by: David Wei <dw@davidwei.uk>
---
 io_uring/zc_rx.c | 90 +++++++++++++++++++++++++++++++++++++++++++++---
 1 file changed, 86 insertions(+), 4 deletions(-)

diff --git a/io_uring/zc_rx.c b/io_uring/zc_rx.c
index b2507df121fb..4bd27eda4bc9 100644
--- a/io_uring/zc_rx.c
+++ b/io_uring/zc_rx.c
@@ -9,6 +9,7 @@
 #include <net/tcp.h>
 #include <net/af_unix.h>
 #include <trace/events/page_pool.h>
+#include <net/page_pool/helpers.h>
 
 #include <uapi/linux/io_uring.h>
 
@@ -72,6 +73,7 @@ static int io_zc_rx_init_buf(struct page *page, struct io_zc_rx_buf *buf)
 {
 	memset(&buf->niov, 0, sizeof(buf->niov));
 	atomic_long_set(&buf->niov.pp_ref_count, 0);
+	page_pool_set_dma_addr_netmem(net_iov_to_netmem(&buf->niov), 0);
 
 	buf->page = page;
 	get_page(page);
@@ -392,12 +394,25 @@ static inline netmem_ref io_zc_buf_to_netmem(struct io_zc_rx_buf *buf)
 	return net_iov_to_netmem(&buf->niov);
 }
 
+static inline void io_zc_sync_for_device(struct page_pool *pp,
+					 netmem_ref netmem)
+{
+	if (pp->p.flags & PP_FLAG_DMA_SYNC_DEV) {
+		dma_addr_t dma_addr = page_pool_get_dma_addr_netmem(netmem);
+
+		dma_sync_single_range_for_device(pp->p.dev, dma_addr,
+						 pp->p.offset, pp->p.max_len,
+						 pp->p.dma_dir);
+	}
+}
+
 static inline void io_zc_add_pp_cache(struct page_pool *pp,
 				      struct io_zc_rx_buf *buf)
 {
 	netmem_ref netmem = io_zc_buf_to_netmem(buf);
 
 	page_pool_set_pp_info(pp, netmem);
+	io_zc_sync_for_device(pp, netmem);
 	pp->alloc.cache[pp->alloc.count++] = netmem;
 }
 
@@ -517,9 +532,71 @@ static void io_pp_zc_scrub(struct page_pool *pp)
 	}
 }
 
+#define IO_PP_DMA_ATTRS (DMA_ATTR_SKIP_CPU_SYNC | DMA_ATTR_WEAK_ORDERING)
+
+static void io_pp_unmap_buf(struct io_zc_rx_buf *buf, struct page_pool *pp)
+{
+	netmem_ref netmem = net_iov_to_netmem(&buf->niov);
+	dma_addr_t dma = page_pool_get_dma_addr_netmem(netmem);
+
+	dma_unmap_page_attrs(pp->p.dev, dma, PAGE_SIZE << pp->p.order,
+			     pp->p.dma_dir, IO_PP_DMA_ATTRS);
+	page_pool_set_dma_addr_netmem(netmem, 0);
+}
+
+static int io_pp_map_buf(struct io_zc_rx_buf *buf, struct page_pool *pp)
+{
+	netmem_ref netmem = net_iov_to_netmem(&buf->niov);
+	dma_addr_t dma_addr;
+	int ret;
+
+	dma_addr = dma_map_page_attrs(pp->p.dev, buf->page, 0,
+				      PAGE_SIZE << pp->p.order, pp->p.dma_dir,
+				      IO_PP_DMA_ATTRS);
+	ret = dma_mapping_error(pp->p.dev, dma_addr);
+	if (ret)
+		return ret;
+
+	if (WARN_ON_ONCE(page_pool_set_dma_addr_netmem(netmem, dma_addr))) {
+		dma_unmap_page_attrs(pp->p.dev, dma_addr,
+				     PAGE_SIZE << pp->p.order, pp->p.dma_dir,
+				     IO_PP_DMA_ATTRS);
+		return -EFAULT;
+	}
+
+	io_zc_sync_for_device(pp, netmem);
+	return 0;
+}
+
+static int io_pp_map_pool(struct io_zc_rx_pool *pool, struct page_pool *pp)
+{
+	int i, ret = 0;
+
+	for (i = 0; i < pool->nr_bufs; i++) {
+		ret = io_pp_map_buf(&pool->bufs[i], pp);
+		if (ret)
+			break;
+	}
+
+	if (ret) {
+		while (i--)
+			io_pp_unmap_buf(&pool->bufs[i], pp);
+	}
+	return ret;
+}
+
+static void io_pp_unmap_pool(struct io_zc_rx_pool *pool, struct page_pool *pp)
+{
+	int i;
+
+	for (i = 0; i < pool->nr_bufs; i++)
+		io_pp_unmap_buf(&pool->bufs[i], pp);
+}
+
 static int io_pp_zc_init(struct page_pool *pp)
 {
 	struct io_zc_rx_ifq *ifq = pp->mp_priv;
+	int ret;
 
 	if (!ifq)
 		return -EINVAL;
@@ -527,10 +604,12 @@ static int io_pp_zc_init(struct page_pool *pp)
 		return -EINVAL;
 	if (!pp->p.napi)
 		return -EINVAL;
-	if (pp->p.flags & PP_FLAG_DMA_MAP)
-		return -EOPNOTSUPP;
-	if (pp->p.flags & PP_FLAG_DMA_SYNC_DEV)
-		return -EOPNOTSUPP;
+
+	if (pp->p.flags & PP_FLAG_DMA_MAP) {
+		ret = io_pp_map_pool(ifq->pool, pp);
+		if (ret)
+			return ret;
+	}
 
 	percpu_ref_get(&ifq->ctx->refs);
 	ifq->pp = pp;
@@ -542,6 +621,9 @@ static void io_pp_zc_destroy(struct page_pool *pp)
 	struct io_zc_rx_ifq *ifq = pp->mp_priv;
 	struct io_zc_rx_pool *pool = ifq->pool;
 
+	if (pp->p.flags & PP_FLAG_DMA_MAP)
+		io_pp_unmap_pool(ifq->pool, pp);
+
 	ifq->pp = NULL;
 
 	if (WARN_ON_ONCE(pool->free_count != pool->nr_bufs))
-- 
2.43.0


