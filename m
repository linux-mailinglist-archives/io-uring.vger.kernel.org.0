Return-Path: <io-uring+bounces-11906-lists+io-uring=lfdr.de@vger.kernel.org>
Delivered-To: lists+io-uring@lfdr.de
Received: from mail.lfdr.de
	by lfdr with LMTP
	id WCdWG7ygdGmd8AAAu9opvQ
	(envelope-from <io-uring+bounces-11906-lists+io-uring=lfdr.de@vger.kernel.org>)
	for <lists+io-uring@lfdr.de>; Sat, 24 Jan 2026 11:36:44 +0100
X-Original-To: lists+io-uring@lfdr.de
Received: from tor.lore.kernel.org (tor.lore.kernel.org [172.105.105.114])
	by mail.lfdr.de (Postfix) with ESMTPS id CD2E47D419
	for <lists+io-uring@lfdr.de>; Sat, 24 Jan 2026 11:36:43 +0100 (CET)
Received: from smtp.subspace.kernel.org (conduit.subspace.kernel.org [100.90.174.1])
	by tor.lore.kernel.org (Postfix) with ESMTP id 1B8D730120D7
	for <lists+io-uring@lfdr.de>; Sat, 24 Jan 2026 10:36:33 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id EF55A1A00F0;
	Sat, 24 Jan 2026 10:36:27 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="AzmYVQeU"
X-Original-To: io-uring@vger.kernel.org
Received: from mail-wm1-f53.google.com (mail-wm1-f53.google.com [209.85.128.53])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7682020DD48
	for <io-uring@vger.kernel.org>; Sat, 24 Jan 2026 10:36:26 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.128.53
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1769250987; cv=none; b=bDcN2RNMiSmfm77HYNfWl1jp75CCMIeBrEX+XKqBBCSRfTfZVag3CwU3Q7ocOhNnBYg3Vd9DSZf5W7T6XhT3kofDwwL00U/c5JPTigA8drWdj8cN82aqt3TIeOOa8ul5j19+dQijtKi9pwzNPek35BBSJEn82Yi/RwsVhAoX7xE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1769250987; c=relaxed/simple;
	bh=W4mv9bF5vFIZK4l3eWDDVmqOH+YfFUGsXXyKaxRl7aA=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=ReSQLyYmAWYNj+vTEs5OSU60rkIQblQkRd13NlynM6Ey1dtT45RWBz/80DRxKt0vVTr1M1uT35PJobffCPp29ndzF/0NxLx/QVq7e/vkPQeg7Ef/FZISPbNB3dh727QC/eNBC74QUomxedloCwBD6sWGSmwbMLXL+kaDEBIanNM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=AzmYVQeU; arc=none smtp.client-ip=209.85.128.53
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Received: by mail-wm1-f53.google.com with SMTP id 5b1f17b1804b1-47fedb7c68dso29883625e9.2
        for <io-uring@vger.kernel.org>; Sat, 24 Jan 2026 02:36:26 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1769250984; x=1769855784; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=Y9YsneOEu6En3PSnY2Lt6kHwiPzc9SW0T0VMkDOTKEw=;
        b=AzmYVQeUTZAQy1yhuetSc/o6QmOACDFqplxSXKP4sPWLtXsnvLBbASmBMmHKL/Ejm/
         lB3pkfonG4ZR/o/rYbOsMwwg6hIRs61CSdInZ8pic1n5G/QHivWZ8NvUrBHstrh9uuMV
         Bg8XH2iBNsjPw9m3mlEoLrCxpYVYZhUOFa/cm07jCUori1+qowXgoPP1oMm38Pm5Z8+n
         d+wMA17fFrwZythzYSDzzdEHnIaFNo+w7+qIzLGYpZcMWc/Jq7XR5zNGc39U57iTT7Jz
         98b1WqH9DpZlZhy73FpNGQF6WZUDRV0zbSO8SM2TMh/MhJA/OrAZuoAQ3/AD7BS5kYl/
         FMXA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1769250984; x=1769855784;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to;
        bh=Y9YsneOEu6En3PSnY2Lt6kHwiPzc9SW0T0VMkDOTKEw=;
        b=vcC5/JcNQGuFwXM10feO0RzOvqQFi3p86xAV/rk3pMJVTyKnf9ybdaCDF/GvKgcU0B
         3klucpK0Yz4LqFFu1vS0WGOJZdJ6BnM/E/xQWVaQ5aV9GD9K3UwXcWvLlkcrFfk3ce1y
         iDyeC50QY8Akn1F+vvboiqH2Z5nHt67n9FgMMd6EzT+qdvrGn+2jnNYfgcnArBSZSi9C
         uR/b19vtAl1SnrJDL5kc77037lvh7eEgLK/OMLeg65nglnznMrZ1juDzMHrpy06rfjeh
         X3jhjPdEQ+A/QSDUCrqsixofnlAeg73M4kmwFo4DBweTN3R+pByxs4rPvSs9kBejOYNy
         +BPA==
X-Gm-Message-State: AOJu0YyF1Xbn5av1LDLTcEwzIF8GL8eHAhXJBCv0RZoKig4Ok+C3lhes
	1wmLJAYXTrDFFldXar7nwbkQe/cZ18l7TlIEwZ5OPR2m4eU3Pose5LzdnciKtQ==
X-Gm-Gg: AZuq6aJcG1J/a1+/KICAAmmf5I0kZ2XmRZA/yONTbJdsNGs4HgT7oLVPlIJ9sKF7fBN
	Md1j7fisEyAbEPlqef4569EMUpvkFjAXvdzr1Sty+nRZGVvR2UIdYpjDuBjNGGD8qT3iIcIU3a4
	8V+exDCqJoOagvD+3YkLNnYvi0DoT6w3TGeqETS6obPzIRUZXx54gmXAL04liT9nPWHqGBT5XQN
	iVI/uXWkXLGRHyD9GYwh41y/3I3YNDq6FJAxgjELITcheJu1EUgsV/2bZIk7k/fkrvWdm5PpwT3
	dXSpKutHxv8yTsGwnpjTCrGG+OWsbY96LC+rtt13vhKXVXiBn040ZSXYe6ZM525BsUbB3J4Wyyj
	MtdnoKg8eI4DzD1NwpP8DIt3NAgqLvhmntvn4E0GrLM92gLJo+nbrTdRbkDtjKJyNgGR3mbGOAT
	UwGKpvP8E2/TtL4tlSNek1mMrMK0zuBFVgkOtvQilrCnEXYD6LEu2aTaOpwvlUhkoXI9VFNaB7k
	DhmBRQEJmHdcRnUqg==
X-Received: by 2002:a05:600c:45cd:b0:479:2f95:5179 with SMTP id 5b1f17b1804b1-480511f46c5mr65277085e9.15.1769250984485;
        Sat, 24 Jan 2026 02:36:24 -0800 (PST)
Received: from 127.mynet ([2a01:4b00:bd21:4f00:7cc6:d3ca:494:116c])
        by smtp.gmail.com with ESMTPSA id 5b1f17b1804b1-4804db8da59sm46164855e9.5.2026.01.24.02.36.23
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sat, 24 Jan 2026 02:36:23 -0800 (PST)
From: Pavel Begunkov <asml.silence@gmail.com>
To: io-uring@vger.kernel.org
Cc: asml.silence@gmail.com,
	axboe@kernel.dk,
	netdev@vger.kernel.org
Subject: [PATCH 1/1] io_uring/zcrx: implement large rx buffer support
Date: Sat, 24 Jan 2026 10:36:17 +0000
Message-ID: <a840a38936ddcaa4c03b81e66e571a38ca68694f.1769249792.git.asml.silence@gmail.com>
X-Mailer: git-send-email 2.52.0
In-Reply-To: <cover.1769249792.git.asml.silence@gmail.com>
References: <cover.1769249792.git.asml.silence@gmail.com>
Precedence: bulk
X-Mailing-List: io-uring@vger.kernel.org
List-Id: <io-uring.vger.kernel.org>
List-Subscribe: <mailto:io-uring+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:io-uring+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspamd-Server: lfdr
X-Spamd-Result: default: False [-1.66 / 15.00];
	ARC_ALLOW(-1.00)[subspace.kernel.org:s=arc-20240116:i=1];
	DMARC_POLICY_ALLOW(-0.50)[gmail.com,none];
	R_MISSING_CHARSET(0.50)[];
	R_SPF_ALLOW(-0.20)[+ip4:172.105.105.114:c];
	R_DKIM_ALLOW(-0.20)[gmail.com:s=20230601];
	MAILLIST(-0.15)[generic];
	MIME_GOOD(-0.10)[text/plain];
	HAS_LIST_UNSUB(-0.01)[];
	MIME_TRACE(0.00)[0:+];
	DKIM_TRACE(0.00)[gmail.com:+];
	TAGGED_FROM(0.00)[bounces-11906-lists,io-uring=lfdr.de];
	FORGED_SENDER_MAILLIST(0.00)[];
	FORGED_RECIPIENTS_MAILLIST(0.00)[];
	FREEMAIL_CC(0.00)[gmail.com,kernel.dk,vger.kernel.org];
	RCVD_TLS_LAST(0.00)[];
	RCPT_COUNT_THREE(0.00)[4];
	RCVD_VIA_SMTP_AUTH(0.00)[];
	FREEMAIL_FROM(0.00)[gmail.com];
	PRECEDENCE_BULK(0.00)[];
	FROM_NEQ_ENVFROM(0.00)[asmlsilence@gmail.com,io-uring@vger.kernel.org];
	FROM_HAS_DN(0.00)[];
	ASN(0.00)[asn:63949, ipnet:172.105.96.0/20, country:SG];
	RCVD_COUNT_FIVE(0.00)[5];
	NEURAL_HAM(-0.00)[-1.000];
	TO_DN_NONE(0.00)[];
	TAGGED_RCPT(0.00)[io-uring];
	MID_RHS_MATCH_FROM(0.00)[];
	DBL_BLOCKED_OPENRESOLVER(0.00)[tor.lore.kernel.org:helo,tor.lore.kernel.org:rdns]
X-Rspamd-Queue-Id: CD2E47D419
X-Rspamd-Action: no action

There are network cards that support receive buffers larger than 4K, and
that can be vastly beneficial for performance, and benchmarks for this
patch showed up to 30% CPU util improvement for 32K vs 4K buffers.

Allows zcrx users to specify the size in struct
io_uring_zcrx_ifq_reg::rx_buf_len. If set to zero, zcrx will use a
default value. zcrx will check and fail if the memory backing the area
can't be split into physically contiguous chunks of the required size.
It's more restrictive as it only needs dma addresses to be contig, but
that's beyond this series.

Signed-off-by: Pavel Begunkov <asml.silence@gmail.com>
---
 include/uapi/linux/io_uring.h |  2 +-
 io_uring/zcrx.c               | 39 ++++++++++++++++++++++++++++++-----
 2 files changed, 35 insertions(+), 6 deletions(-)

diff --git a/include/uapi/linux/io_uring.h b/include/uapi/linux/io_uring.h
index 475094c7a668..ec13ff37db39 100644
--- a/include/uapi/linux/io_uring.h
+++ b/include/uapi/linux/io_uring.h
@@ -1094,7 +1094,7 @@ struct io_uring_zcrx_ifq_reg {
 
 	struct io_uring_zcrx_offsets offsets;
 	__u32	zcrx_id;
-	__u32	__resv2;
+	__u32	rx_buf_len;
 	__u64	__resv[3];
 };
 
diff --git a/io_uring/zcrx.c b/io_uring/zcrx.c
index b99cf2c6670a..b5166c9118e5 100644
--- a/io_uring/zcrx.c
+++ b/io_uring/zcrx.c
@@ -15,6 +15,7 @@
 #include <net/netlink.h>
 #include <net/netdev_queues.h>
 #include <net/netdev_rx_queue.h>
+#include <net/netdev_queues.h>
 #include <net/tcp.h>
 #include <net/rps.h>
 
@@ -55,6 +56,18 @@ static inline struct page *io_zcrx_iov_page(const struct net_iov *niov)
 	return area->mem.pages[net_iov_idx(niov) << niov_pages_shift];
 }
 
+static int io_area_max_shift(struct io_zcrx_mem *mem)
+{
+	struct sg_table *sgt = mem->sgt;
+	struct scatterlist *sg;
+	unsigned shift = -1U;
+	unsigned i;
+
+	for_each_sgtable_dma_sg(sgt, sg, i)
+		shift = min(shift, __ffs(sg->length));
+	return shift;
+}
+
 static int io_populate_area_dma(struct io_zcrx_ifq *ifq,
 				struct io_zcrx_area *area)
 {
@@ -416,12 +429,21 @@ static int io_zcrx_append_area(struct io_zcrx_ifq *ifq,
 }
 
 static int io_zcrx_create_area(struct io_zcrx_ifq *ifq,
-			       struct io_uring_zcrx_area_reg *area_reg)
+			       struct io_uring_zcrx_area_reg *area_reg,
+			       struct io_uring_zcrx_ifq_reg *reg)
 {
+	int buf_size_shift = PAGE_SHIFT;
 	struct io_zcrx_area *area;
 	unsigned nr_iovs;
 	int i, ret;
 
+	if (reg->rx_buf_len) {
+		if (!is_power_of_2(reg->rx_buf_len) ||
+		     reg->rx_buf_len < PAGE_SIZE)
+			return -EINVAL;
+		buf_size_shift = ilog2(reg->rx_buf_len);
+	}
+
 	ret = -ENOMEM;
 	area = kzalloc(sizeof(*area), GFP_KERNEL);
 	if (!area)
@@ -432,7 +454,12 @@ static int io_zcrx_create_area(struct io_zcrx_ifq *ifq,
 	if (ret)
 		goto err;
 
-	ifq->niov_shift = PAGE_SHIFT;
+	if (buf_size_shift > io_area_max_shift(&area->mem)) {
+		ret = -ERANGE;
+		goto err;
+	}
+
+	ifq->niov_shift = buf_size_shift;
 	nr_iovs = area->mem.size >> ifq->niov_shift;
 	area->nia.num_niovs = nr_iovs;
 
@@ -742,8 +769,7 @@ int io_register_zcrx_ifq(struct io_ring_ctx *ctx,
 		return -EINVAL;
 	if (copy_from_user(&reg, arg, sizeof(reg)))
 		return -EFAULT;
-	if (!mem_is_zero(&reg.__resv, sizeof(reg.__resv)) ||
-	    reg.__resv2 || reg.zcrx_id)
+	if (!mem_is_zero(&reg.__resv, sizeof(reg.__resv)) || reg.zcrx_id)
 		return -EINVAL;
 	if (reg.flags & ZCRX_REG_IMPORT)
 		return import_zcrx(ctx, arg, &reg);
@@ -800,10 +826,11 @@ int io_register_zcrx_ifq(struct io_ring_ctx *ctx,
 	}
 	get_device(ifq->dev);
 
-	ret = io_zcrx_create_area(ifq, &area);
+	ret = io_zcrx_create_area(ifq, &area, &reg);
 	if (ret)
 		goto netdev_put_unlock;
 
+	mp_param.rx_page_size = 1U << ifq->niov_shift;
 	mp_param.mp_ops = &io_uring_pp_zc_ops;
 	mp_param.mp_priv = ifq;
 	ret = __net_mp_open_rxq(ifq->netdev, reg.if_rxq, &mp_param, NULL);
@@ -821,6 +848,8 @@ int io_register_zcrx_ifq(struct io_ring_ctx *ctx,
 			goto err;
 	}
 
+	reg.rx_buf_len = 1U << ifq->niov_shift;
+
 	if (copy_to_user(arg, &reg, sizeof(reg)) ||
 	    copy_to_user(u64_to_user_ptr(reg.region_ptr), &rd, sizeof(rd)) ||
 	    copy_to_user(u64_to_user_ptr(reg.area_ptr), &area, sizeof(area))) {
-- 
2.52.0


