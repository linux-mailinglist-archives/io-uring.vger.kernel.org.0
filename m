Return-Path: <io-uring+bounces-7540-lists+io-uring=lfdr.de@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [IPv6:2604:1380:45e3:2400::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 3EE79A936C1
	for <lists+io-uring@lfdr.de>; Fri, 18 Apr 2025 14:01:33 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 38A888E3B0C
	for <lists+io-uring@lfdr.de>; Fri, 18 Apr 2025 12:01:16 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 1958A16D4E6;
	Fri, 18 Apr 2025 12:01:29 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="KA6bzeNl"
X-Original-To: io-uring@vger.kernel.org
Received: from mail-wr1-f51.google.com (mail-wr1-f51.google.com [209.85.221.51])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 438CC4206B;
	Fri, 18 Apr 2025 12:01:27 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.221.51
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1744977689; cv=none; b=QzU+UhjMWxnoRqgjnAPzMrKH0dHynylDHP6Q6SRiwXZyHNQgLMBzDPPCfUJAisaZY0xSCgVNIX9WEp0mpNcmSSD0dP7N/2fyXYEPpnVZEzv9vR/B+xc1X1EG5GPo4H1XnybiXdTJXtFHM1ZmZVa9iFnrxSHGEy5729Hcz16WjiU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1744977689; c=relaxed/simple;
	bh=E/NHlan4t/IE+Ujm3JZGvDngEaicXBYnH29+Ik6rJ90=;
	h=From:To:Cc:Subject:Date:Message-ID:MIME-Version; b=sFwdOperrA+uSM6E9g+zUg/TXw/65J3yIjjNTBKz7lTmFzb3/QODTvghqXgE4pmjy2uzqtRpgTrn6iota0ioeVMgt/A7TJzxlImrcbUUS+XSjcBgkvkwrz/iUVA2L6hJtwXb4R8srgMNqOAE51LHgRhEumPGfXUq9TSxHyNC4ng=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=KA6bzeNl; arc=none smtp.client-ip=209.85.221.51
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Received: by mail-wr1-f51.google.com with SMTP id ffacd0b85a97d-39ee5ac4321so1605397f8f.1;
        Fri, 18 Apr 2025 05:01:26 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1744977685; x=1745582485; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:from:to:cc:subject:date:message-id:reply-to;
        bh=NHHBsU4eJxL8dT/X7azx6NU+bYNM0X++bMlAxbsyK/E=;
        b=KA6bzeNljJswD1U8EV1Op76zMRNqEFeYabLkaTDnSH8cnwfdQYbWXvPtgnpYAWebxC
         0Pbdf5veO9GFyOUDTjtoVbgtxk25jJqsYyIXZcmUqsPZnAe6r2KGTorEtfKj/C852tIE
         J97qrRAvMGcaXiRwTxTeKDqDdgrJqh7cZ+8BW2QO9H5U3C1XMj/gqKtCVlYG14WqEt4s
         BlqKSnzgcQwoZea2w+hktBa56THj8uOC9KHMSgesHRHxut6DGnB00MncOCn3Z0lb+4Mc
         tOMetXZSrGFG9gBJVkHteb65dHCBAQJ3S9WNm0xSmGj2DAdAG472Jr1SUli3MABLsj2Q
         9cBg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1744977685; x=1745582485;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=NHHBsU4eJxL8dT/X7azx6NU+bYNM0X++bMlAxbsyK/E=;
        b=ePtrrDTv3T8cIOlrYrjEBZDVZqnAVaSmAp1sxIW6vpcxkAt1o1ksGM1KK3et59yvFp
         TS4V1Y40fwJg0gN23x5HYAVWc8/Zpy00DoKnbbmC7tMF8JIEy+CLNDDdlLB/Ho2L52K2
         RHsBKA6X/0TrKijNO5KEJFA9zWgB4eGcoWaUCTLKQWluW9njx/cQSnWz4QMGczjd00Dv
         3OtWy1SmAFknfP6d/kxQs0GJpo8uIEzziUsHIVxVIIFnIdre40ginq6fdWIbe2Sk+wqk
         1wQ56IWj9cGFZZyaltx3jHsZ3/2P0bZ4mGIHAO1+QDimSSoAw9R2/0hGANesY3NPe6Fh
         dx3Q==
X-Forwarded-Encrypted: i=1; AJvYcCU68Vq1lvJdT6Ao8PoAkmm/WHh1OrEE+AIXfHOmT2cXfHHdeMZ+b7iIW3srn1CG5y4v4uCSKgM=@vger.kernel.org
X-Gm-Message-State: AOJu0YxsugFtp6yG3BfFfAc8Ns90wIdy9VkOqHQBXIoprh/Vyx6Tg90G
	PTieHqsnwM+Jck2b/vMloTrewV5VWr/7MX5tTDrhekzBxaOcDoGyw9mlAQ==
X-Gm-Gg: ASbGnct2hj8WnT72AGpY+UE7/R4coJW+ALwi/YG9iYeOclHY+Ys/nVG2fQ12c2VloRz
	xl/jwQ8XIQQU/JjCDHybmj9N9BbuLKfBayrr4UqW2rqRXrXBgczPVTmx3VluEDjCZm5S5dz1vYn
	JHDyDqftHRcLcM/nnOVCndltRCtwyPqlOT0c+Apwq9uoXID4tApeyOi3ulgq2WL8dO1d4NTq/vV
	rKiANXv658mqG1hHIFWeWK6T7ejOCso/zWZwxfS4ZIDeAagSUvHBfgLLbySS9L9GMPyP7wQSF3Q
	8Ll31NizhfrVYOTUpg8V8/1+L+nevRrFUm/rlZ0Sdt7VSvkpcl4n9w==
X-Google-Smtp-Source: AGHT+IFFKJgQQtaccMRq3UmcoFfR/VVHbCVvEBVua75ii/e/q045tneKm0TM2ByO7zwqMfEf1cbDZg==
X-Received: by 2002:a05:6000:186e:b0:39c:1f10:d294 with SMTP id ffacd0b85a97d-39efba5ee5emr1936405f8f.26.1744977684880;
        Fri, 18 Apr 2025 05:01:24 -0700 (PDT)
Received: from 127.0.0.1localhost ([148.252.144.40])
        by smtp.gmail.com with ESMTPSA id ffacd0b85a97d-39efa493207sm2570239f8f.79.2025.04.18.05.01.23
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 18 Apr 2025 05:01:23 -0700 (PDT)
From: Pavel Begunkov <asml.silence@gmail.com>
To: io-uring@vger.kernel.org
Cc: asml.silence@gmail.com,
	David Wei <dw@davidwei.uk>,
	=?UTF-8?q?Toke=20H=C3=B8iland-J=C3=B8rgensen?= <toke@redhat.com>,
	Jakub Kicinski <kuba@kernel.org>,
	Mina Almasry <almasrymina@google.com>,
	netdev@vger.kernel.org
Subject: [PATCH io_uring-6.15] io_uring/zcrx: fix late dma unmap for a dead dev
Date: Fri, 18 Apr 2025 13:02:27 +0100
Message-ID: <ef9b7db249b14f6e0b570a1bb77ff177389f881c.1744965853.git.asml.silence@gmail.com>
X-Mailer: git-send-email 2.48.1
Precedence: bulk
X-Mailing-List: io-uring@vger.kernel.org
List-Id: <io-uring.vger.kernel.org>
List-Subscribe: <mailto:io-uring+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:io-uring+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

There is a problem with page pools not dma-unmapping immediately
when the device is going down, and delaying it until the page pool is
destroyed, which is not allowed (see links). That just got fixed for
normal page pools, and we need to address memory providers as well.

Unmap pages in the memory provider uninstall callback, and protect it
with a new lock. There is also a gap between a dma mapping is created
and the mp is installed, so if the device is killed in between,
io_uring would be hodling dma mapping to a dead device with no one to
call ->uninstall. Move it to page pool init and rely on ->is_mapped to
make sure it's only done once.

Link: https://lore.kernel.org/lkml/8067f204-1380-4d37-8ffd-007fc6f26738@kernel.org/T/
Link: https://lore.kernel.org/all/20250409-page-pool-track-dma-v9-0-6a9ef2e0cba8@redhat.com/
Fixes: 34a3e60821ab9 ("io_uring/zcrx: implement zerocopy receive pp memory provider")
Signed-off-by: Pavel Begunkov <asml.silence@gmail.com>
---
 io_uring/zcrx.c | 21 +++++++++++++++++----
 io_uring/zcrx.h |  1 +
 2 files changed, 18 insertions(+), 4 deletions(-)

diff --git a/io_uring/zcrx.c b/io_uring/zcrx.c
index 5defbe8f95f9..fe86606b9f30 100644
--- a/io_uring/zcrx.c
+++ b/io_uring/zcrx.c
@@ -51,14 +51,21 @@ static void __io_zcrx_unmap_area(struct io_zcrx_ifq *ifq,
 
 static void io_zcrx_unmap_area(struct io_zcrx_ifq *ifq, struct io_zcrx_area *area)
 {
+	guard(mutex)(&ifq->dma_lock);
+
 	if (area->is_mapped)
 		__io_zcrx_unmap_area(ifq, area, area->nia.num_niovs);
+	area->is_mapped = false;
 }
 
 static int io_zcrx_map_area(struct io_zcrx_ifq *ifq, struct io_zcrx_area *area)
 {
 	int i;
 
+	guard(mutex)(&ifq->dma_lock);
+	if (area->is_mapped)
+		return 0;
+
 	for (i = 0; i < area->nia.num_niovs; i++) {
 		struct net_iov *niov = &area->nia.niovs[i];
 		dma_addr_t dma;
@@ -280,6 +287,7 @@ static struct io_zcrx_ifq *io_zcrx_ifq_alloc(struct io_ring_ctx *ctx)
 	ifq->ctx = ctx;
 	spin_lock_init(&ifq->lock);
 	spin_lock_init(&ifq->rq_lock);
+	mutex_init(&ifq->dma_lock);
 	return ifq;
 }
 
@@ -329,6 +337,7 @@ static void io_zcrx_ifq_free(struct io_zcrx_ifq *ifq)
 		put_device(ifq->dev);
 
 	io_free_rbuf_ring(ifq);
+	mutex_destroy(&ifq->dma_lock);
 	kfree(ifq);
 }
 
@@ -400,10 +409,6 @@ int io_register_zcrx_ifq(struct io_ring_ctx *ctx,
 		goto err;
 	get_device(ifq->dev);
 
-	ret = io_zcrx_map_area(ifq, ifq->area);
-	if (ret)
-		goto err;
-
 	mp_param.mp_ops = &io_uring_pp_zc_ops;
 	mp_param.mp_priv = ifq;
 	ret = net_mp_open_rxq(ifq->netdev, reg.if_rxq, &mp_param);
@@ -624,6 +629,7 @@ static bool io_pp_zc_release_netmem(struct page_pool *pp, netmem_ref netmem)
 static int io_pp_zc_init(struct page_pool *pp)
 {
 	struct io_zcrx_ifq *ifq = io_pp_to_ifq(pp);
+	int ret;
 
 	if (WARN_ON_ONCE(!ifq))
 		return -EINVAL;
@@ -636,6 +642,10 @@ static int io_pp_zc_init(struct page_pool *pp)
 	if (pp->p.dma_dir != DMA_FROM_DEVICE)
 		return -EOPNOTSUPP;
 
+	ret = io_zcrx_map_area(ifq, ifq->area);
+	if (ret)
+		return ret;
+
 	percpu_ref_get(&ifq->ctx->refs);
 	return 0;
 }
@@ -671,6 +681,9 @@ static void io_pp_uninstall(void *mp_priv, struct netdev_rx_queue *rxq)
 	struct io_zcrx_ifq *ifq = mp_priv;
 
 	io_zcrx_drop_netdev(ifq);
+	if (ifq->area)
+		io_zcrx_unmap_area(ifq, ifq->area);
+
 	p->mp_ops = NULL;
 	p->mp_priv = NULL;
 }
diff --git a/io_uring/zcrx.h b/io_uring/zcrx.h
index 47f1c0e8c197..f2bc811f022c 100644
--- a/io_uring/zcrx.h
+++ b/io_uring/zcrx.h
@@ -38,6 +38,7 @@ struct io_zcrx_ifq {
 	struct net_device		*netdev;
 	netdevice_tracker		netdev_tracker;
 	spinlock_t			lock;
+	struct mutex			dma_lock;
 };
 
 #if defined(CONFIG_IO_URING_ZCRX)
-- 
2.48.1


