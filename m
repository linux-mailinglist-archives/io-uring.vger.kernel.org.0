Return-Path: <io-uring+bounces-9008-lists+io-uring=lfdr.de@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [139.178.88.99])
	by mail.lfdr.de (Postfix) with ESMTPS id 5A22DB29593
	for <lists+io-uring@lfdr.de>; Mon, 18 Aug 2025 00:43:42 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id AA9394E27D7
	for <lists+io-uring@lfdr.de>; Sun, 17 Aug 2025 22:43:30 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 1280212DDA1;
	Sun, 17 Aug 2025 22:43:29 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="WA1hdWQy"
X-Original-To: io-uring@vger.kernel.org
Received: from mail-wm1-f54.google.com (mail-wm1-f54.google.com [209.85.128.54])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5B88E21B9C0
	for <io-uring@vger.kernel.org>; Sun, 17 Aug 2025 22:43:27 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.128.54
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1755470609; cv=none; b=LWg4NDakpSaiNzjcAikSNJ8QtHs5oeQGvrQZqkKi44BeDu7fwkjCHoEkahv4vAaL47xT/FjNzXE5H5R8UDaHZGKDKH9fm/JZ/AQSgj6+MSEjOWv9f/Nv02bwH+29NrWhImOsr5vEwyR6dlDKycYMPc44jAsiHYMpyPBJTPbOdM0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1755470609; c=relaxed/simple;
	bh=HLU+lRv2uhEZnc23qmeYvuosbyGid+8MMgWrtRiBgp0=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=l1RmYc6LPnOtA6pfK2CwAuWnpL++A0qYenMi8PLVuQuPuOlUhnvUCtObCCelanHEyHSyrFF4Q0gESAwk34qm8xCd1YxUmT+aPQTQGPJdf7UJM6gkodYLGCBD/A1q86+NjWSoAC79rhBiRn0+s/6TYoBrdIAf0DLI/ljCrM2Igfg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=WA1hdWQy; arc=none smtp.client-ip=209.85.128.54
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Received: by mail-wm1-f54.google.com with SMTP id 5b1f17b1804b1-45a1b0bde14so17289845e9.2
        for <io-uring@vger.kernel.org>; Sun, 17 Aug 2025 15:43:27 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1755470605; x=1756075405; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=O67MjheFYuaXpzL/kQ/uOz3tSlYV6xBn1z9Frt2M1DE=;
        b=WA1hdWQyhMIiAFH45f5KvvIGFfR68lMNNT9EiCtuyx4jexXXHtsxuvYRMUYKSlFfxS
         5/KklUTyruJEE1mebCaxkfWOpxzrdb+cG66ieT3qYqzzZ2ckL+JiePvr5RDDag4sI5iu
         aq6qlEPs7qdKG2+kap8fRh/24OIrB/+eG2bLQSgataZ+NQ+XJWVvNFaUf7NWDitAwzZt
         nPjWFjHpmJmM09Vqw7yxThxQMxROIbUvaN5cd6UFLE+uquCUH0RyDYQXgeqgTgsivt0f
         SapNTQVzjuvXVaPKq/dnJpUlKG119X0r6ciu0XIAOc7ZYrPQbLs+8xPV3mfGH0VNE2xG
         q+9Q==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1755470605; x=1756075405;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=O67MjheFYuaXpzL/kQ/uOz3tSlYV6xBn1z9Frt2M1DE=;
        b=rHuJ9Lcn55wZJ670j7EsWSV8fJKIm77LITa2E7fUs+Dm8c7bzq4/gPs/l9JkC6j3YB
         Q6yRet8uodGcpM2bN7oqcGc9LJkB5zU7aqZbcwiYcmLnQagLCp79AI5bICeVFkGybVeN
         jwyJtUmFEWsPABtyEUNTffg+mbZA1KxT2ijnIjwuJxAza/j2mV6RCthy8aT8Nbd3a9BU
         OL8stRv4+6VyR/Mv5oVdkTVnTsjP0EkAMBW8sBomyW32daEziBoYv0vIjm56/YsLbjFN
         pmLtYI4yBWyRCyJ41BozYYiAd5iuS/FWFGvLHbVrXCnUO+/cK6m7ori1riwfohFn9Tn7
         4NNA==
X-Gm-Message-State: AOJu0YztMSV8c7p6ELWl/c+8UaI6i+HysT6pt4EDOpLMucBiifcRmmrP
	AatifREje68blGIqI3qpNS8V10RAOQA5yhVBXEejLBkdv2GJyjalO/tB8fFZGg==
X-Gm-Gg: ASbGncu67Dq4NHVNPzCCmPceq0Nk3K7Ky15xLLYSRYoSrZVqqJnE0rPMbH5ln6hCu0K
	3MP8GMvwWA5gLT5xkEU6Bc1EYaOkdRsxEXTR6J3UBlibLUK/LBoqdyu7+46U3hoqqTusKSPbgOF
	/+KGGJgZ+fr3r+JfX7b4LhEX8ZS6eYRGCQO0IQebiqxTR6JnhJUA2kSWsnFr5DsdFjNQyKknAyf
	xgV/b0rjZXwLu+KBTfS1635voVS5anVWPZlK0EpCe662t4oEJxAzGN0HjFfbBUUB1AA0h0PSnan
	9Mq3f/7sE4ibHOCfmVfYbIQfE1f7xW5ABJK2rl3H7wQvcWy/yXFCMjuMojDyc8WvkWax9T+F1kv
	9b0YnY4T+je5rtKr1113frQPiuzGr69WGCw==
X-Google-Smtp-Source: AGHT+IFX47q+iyCmWCMpELmwDNjFo4l++gxsor/cQTuj6RXoabDYyda9OWaShDyGeyDkFE/S6X8tZg==
X-Received: by 2002:a05:600c:474a:b0:459:e025:8c5b with SMTP id 5b1f17b1804b1-45a21864826mr95180945e9.30.1755470605208;
        Sun, 17 Aug 2025 15:43:25 -0700 (PDT)
Received: from 127.0.0.1localhost ([185.69.144.43])
        by smtp.gmail.com with ESMTPSA id ffacd0b85a97d-3bb676c9a7fsm10554786f8f.37.2025.08.17.15.43.23
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sun, 17 Aug 2025 15:43:23 -0700 (PDT)
From: Pavel Begunkov <asml.silence@gmail.com>
To: io-uring@vger.kernel.org
Cc: asml.silence@gmail.com
Subject: [zcrx-next 7/8] io_uring/zcrx: make niov size variable
Date: Sun, 17 Aug 2025 23:44:18 +0100
Message-ID: <08c3405810ebacbb8cbf59e3c0a1dfa6eb415f5f.1755467608.git.asml.silence@gmail.com>
X-Mailer: git-send-email 2.49.0
In-Reply-To: <cover.1755467608.git.asml.silence@gmail.com>
References: <cover.1755467608.git.asml.silence@gmail.com>
Precedence: bulk
X-Mailing-List: io-uring@vger.kernel.org
List-Id: <io-uring.vger.kernel.org>
List-Subscribe: <mailto:io-uring+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:io-uring+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

Instead of using PAGE_SIZE for the niov size add a niov_shift field to
ifq, and patch up all important places. Copy fallback still assumes
PAGE_SIZE, so it'll be wasting some memory for now.

Signed-off-by: Pavel Begunkov <asml.silence@gmail.com>
---
 io_uring/zcrx.c | 32 +++++++++++++++++++++-----------
 io_uring/zcrx.h |  1 +
 2 files changed, 22 insertions(+), 11 deletions(-)

diff --git a/io_uring/zcrx.c b/io_uring/zcrx.c
index 87ba34c5a22f..952cd7669589 100644
--- a/io_uring/zcrx.c
+++ b/io_uring/zcrx.c
@@ -45,16 +45,19 @@ static inline struct io_zcrx_area *io_zcrx_iov_to_area(const struct net_iov *nio
 static inline struct page *io_zcrx_iov_page(const struct net_iov *niov)
 {
 	struct io_zcrx_area *area = io_zcrx_iov_to_area(niov);
+	unsigned niov_pages_shift;
 
 	lockdep_assert(!area->mem.is_dmabuf);
 
-	return area->mem.pages[net_iov_idx(niov)];
+	niov_pages_shift = area->ifq->niov_shift - PAGE_SHIFT;
+	return area->mem.pages[net_iov_idx(niov) << niov_pages_shift];
 }
 
 static int io_populate_area_dma(struct io_zcrx_ifq *ifq,
 				struct io_zcrx_area *area,
 				struct sg_table *sgt)
 {
+	unsigned niov_size = 1U << ifq->niov_shift;
 	struct scatterlist *sg;
 	unsigned i, niov_idx = 0;
 
@@ -62,13 +65,16 @@ static int io_populate_area_dma(struct io_zcrx_ifq *ifq,
 		dma_addr_t dma = sg_dma_address(sg);
 		unsigned long sg_len = sg_dma_len(sg);
 
+		if (WARN_ON_ONCE(sg_len % niov_size))
+			return -EINVAL;
+
 		while (sg_len && niov_idx < area->nia.num_niovs) {
 			struct net_iov *niov = &area->nia.niovs[niov_idx];
 
 			if (net_mp_niov_set_dma_addr(niov, dma))
 				return -EFAULT;
-			sg_len -= PAGE_SIZE;
-			dma += PAGE_SIZE;
+			sg_len -= niov_size;
+			dma += niov_size;
 			niov_idx++;
 		}
 	}
@@ -396,7 +402,8 @@ static int io_zcrx_create_area(struct io_zcrx_ifq *ifq,
 	if (ret)
 		goto err;
 
-	nr_iovs = area->mem.size >> PAGE_SHIFT;
+	ifq->niov_shift = PAGE_SHIFT;
+	nr_iovs = area->mem.size >> ifq->niov_shift;
 	area->nia.num_niovs = nr_iovs;
 
 	ret = -ENOMEM;
@@ -742,7 +749,7 @@ static void io_zcrx_ring_refill(struct page_pool *pp,
 		netmem_ref netmem;
 
 		area_idx = rqe->off >> IORING_ZCRX_AREA_SHIFT;
-		niov_idx = (rqe->off & ~IORING_ZCRX_AREA_MASK) >> PAGE_SHIFT;
+		niov_idx = (rqe->off & ~IORING_ZCRX_AREA_MASK) >> ifq->niov_shift;
 
 		if (unlikely(rqe->__pad || area_idx))
 			continue;
@@ -785,20 +792,23 @@ static void io_zcrx_refill_slow(struct page_pool *pp, struct io_zcrx_ifq *ifq)
 	spin_unlock_bh(&area->freelist_lock);
 }
 
-static void io_sync_allocated_niovs(struct page_pool *pp)
+static void io_sync_allocated_niovs(struct io_zcrx_ifq *ifq,
+				    struct page_pool *pp)
 {
 #if defined(CONFIG_HAS_DMA) && defined(CONFIG_DMA_NEED_SYNC)
+	unsigned niov_size;
 	int i;
 
 	if (!dma_dev_need_sync(pp->p.dev))
 		return;
 
+	niov_size = 1U << ifq->niov_shift;
 	for (i = 0; i < pp->alloc.count; i++) {
 		netmem_ref netmem = pp->alloc.cache[i];
 		dma_addr_t dma_addr = page_pool_get_dma_addr_netmem(netmem);
 
 		__dma_sync_single_for_device(pp->p.dev, dma_addr + pp->p.offset,
-					     PAGE_SIZE, pp->p.dma_dir);
+					     niov_size, pp->p.dma_dir);
 	}
 #endif
 }
@@ -819,7 +829,7 @@ static netmem_ref io_pp_zc_alloc_netmems(struct page_pool *pp, gfp_t gfp)
 	if (!pp->alloc.count)
 		return 0;
 out_return:
-	io_sync_allocated_niovs(pp);
+	io_sync_allocated_niovs(ifq, pp);
 	return pp->alloc.cache[--pp->alloc.count];
 }
 
@@ -847,8 +857,8 @@ static int io_pp_zc_init(struct page_pool *pp)
 		return -EINVAL;
 	if (WARN_ON_ONCE(!pp->dma_map))
 		return -EOPNOTSUPP;
-	if (pp->p.order != 0)
-		return -EOPNOTSUPP;
+	if (pp->p.order + PAGE_SHIFT != ifq->niov_shift)
+		return -EINVAL;
 	if (pp->p.dma_dir != DMA_FROM_DEVICE)
 		return -EOPNOTSUPP;
 
@@ -920,7 +930,7 @@ static bool io_zcrx_queue_cqe(struct io_kiocb *req, struct net_iov *niov,
 	cqe->flags = IORING_CQE_F_MORE;
 
 	area = io_zcrx_iov_to_area(niov);
-	offset = off + (net_iov_idx(niov) << PAGE_SHIFT);
+	offset = off + (net_iov_idx(niov) << ifq->niov_shift);
 	rcqe = (struct io_uring_zcrx_cqe *)(cqe + 1);
 	rcqe->off = offset + ((u64)area->area_id << IORING_ZCRX_AREA_SHIFT);
 	rcqe->__pad = 0;
diff --git a/io_uring/zcrx.h b/io_uring/zcrx.h
index 4e94cfa720e6..41e4ceab8dd6 100644
--- a/io_uring/zcrx.h
+++ b/io_uring/zcrx.h
@@ -41,6 +41,7 @@ struct io_zcrx_area {
 struct io_zcrx_ifq {
 	struct io_ring_ctx		*ctx;
 	struct io_zcrx_area		*area;
+	unsigned			niov_shift;
 
 	spinlock_t			rq_lock ____cacheline_aligned_in_smp;
 	struct io_uring			*rq_ring;
-- 
2.49.0


