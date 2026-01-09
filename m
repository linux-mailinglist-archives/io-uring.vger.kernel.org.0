Return-Path: <io-uring+bounces-11566-lists+io-uring=lfdr.de@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from tor.lore.kernel.org (tor.lore.kernel.org [172.105.105.114])
	by mail.lfdr.de (Postfix) with ESMTPS id EC661D08E94
	for <lists+io-uring@lfdr.de>; Fri, 09 Jan 2026 12:31:58 +0100 (CET)
Received: from smtp.subspace.kernel.org (conduit.subspace.kernel.org [100.90.174.1])
	by tor.lore.kernel.org (Postfix) with ESMTP id B933D307629A
	for <lists+io-uring@lfdr.de>; Fri,  9 Jan 2026 11:29:45 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 1E50435C185;
	Fri,  9 Jan 2026 11:29:21 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="hXe9VPz5"
X-Original-To: io-uring@vger.kernel.org
Received: from mail-wm1-f48.google.com (mail-wm1-f48.google.com [209.85.128.48])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1CFB035B14A
	for <io-uring@vger.kernel.org>; Fri,  9 Jan 2026 11:29:15 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.128.48
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1767958160; cv=none; b=SOjFT6MnMrn5NZz9DzRO012dpX8HwlB0c6IrPuDIRYXOhxlZni+DyVoG29tS/TM6M78+6t3zwmd5AJePA5gm7KYaJx4qMZUhLkMSxFbXpWLiacYgdfdnnIxYu1PpPTgZ7I+TE8TXbzNgQROYDJM31iCXPA7LzELpoxbxKeuRc+4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1767958160; c=relaxed/simple;
	bh=F6waAxUTN0XHkxjyQT+jUXiZnFRXTIpv+p7I9hYKiIU=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=aLYdBcxKiadKcezVUqzVErsiRHz2aA3Y6mivaftromaPZYmA9u7ka7EIx5+/ezXot2Tj4izPn9eFAi9tcRSlosS5NIN5akxTt1GVcGsQ0uHjqflv+TQ8bEmHrMFJGlKzf5Con67FjShJQ2yguKdNDg62kgBe9SwQbaMNRdGNSXo=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=hXe9VPz5; arc=none smtp.client-ip=209.85.128.48
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Received: by mail-wm1-f48.google.com with SMTP id 5b1f17b1804b1-47a8195e515so30228255e9.0
        for <io-uring@vger.kernel.org>; Fri, 09 Jan 2026 03:29:15 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1767958153; x=1768562953; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=HkGYuXz+QxHGRROmceDvRDL3xnFuc5UQrONsfTFdwcU=;
        b=hXe9VPz5zpwUdxHdQiNA7nI7D89AQSveggNCgVpkqkyCGsukQrI2unq7opkC9S70QQ
         Ma3zfkPfDUchjPMEWupLTGaO52psc0mwkWd9sHH0rVDMpJ/s47PPp/C/qQYRoWs5cWOw
         p0zwWsuRel4KPLiXU1oykrX0YVN3ZClfZLk69wJYfhTz2dgqJjX5InV/gzoij6MTQFzj
         ZZcTi2drf7HmcEjpmvWNx1GOynGzLktFNmg/od6VyS2UB7nPosKJXOSHbHPMZufx9OxL
         CuzbUvqb6Ugpd5rIAnXpo+GMO05CiFtWBfNlTCgqkedlFa8dFNmiVxO9h0hHzAqwFhRW
         NJkg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1767958153; x=1768562953;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to;
        bh=HkGYuXz+QxHGRROmceDvRDL3xnFuc5UQrONsfTFdwcU=;
        b=BV7tU+fIyu3AdH5L2WOqkG+ffK+femoY3aSTZcoJ8gHdx4pWT9rZKNAOvzMtI6S8uW
         jT9ZnZaajDHRy1TQffZfG2/0Fmrs4iLEdJzH7AoRxIeSPZ1kdYiZx1v03vXisz2s4gjO
         7D/0c+psCScqKbOb0bqfnPpEbLhQFHXfw+mbxcEIaecUMKsK12ZiU+wvDRWiYImQsw+u
         3rOcISRa/RhqjQLFruC6VVgxjAs9/kwDLz2C1qSBBqcfzXomwjwkupdQqiqVMiqog5dn
         e3u0U7VvimGfnzCILSy6DFmtKs3qbC58U9ZDGgrRyBym2ATSVgci5x4M+wqC/w73FWUz
         H8AQ==
X-Forwarded-Encrypted: i=1; AJvYcCXp6u/7s45Gvhd9/Cgz1+1gFbyeMRjmwjviSX4uH1KTeT6o4LZUkbIq1N10Nq3z9zaOxepCnjnMBg==@vger.kernel.org
X-Gm-Message-State: AOJu0YwULz6srHXVj6QuEdGWa4FHUCK33oT4ToaalfvxzrYVjVHZsqZK
	E9mpv9P4EuSEd5HItluAesHLQ81U/ejwXPJ4C6WjG6JSnL+qj45mVciT
X-Gm-Gg: AY/fxX6lSa7604MoMIPSdeKsMT1tTMMLS/i6l/0Ml0df1FrTZB73EFesHz7wCxoA7Po
	SnP0oFNCLPgJNV3anKuYkfK+QV1bV21kfNdNBI/ZkEMWaMeMa+wkWCJfv6nb/Up/636i0DHuQ2T
	gWZCHirw2n/abDx6jXrmrV/IuE5j0O2HO6Or6GvTRR3Il610zDB8mImjZyJAyTsp3T5TGq/ym1s
	FfQirvy66CTCg4oPJNst/LLSoQDblEIuMUXXwWunCd/4btJ8rYx43/O96jvY6IDHTyK5c5mpUem
	i3EKdozBEaNDReipD0L4aFNbBaBud4y3+d1yjW4HSm265XcwYqgA4SYqlErbHXFWzq1Q2TzOrGf
	rTOKeINPbmQCZXM6JKn6WGiO9Ve5pRG3nMmtDPKa68J9MTUuAJLCNgLRBp9EYjimauX2EWRBnDT
	c+E7dPjZCmKBMZ46GITnpLqGV5S9Tng4Fa2nyf/lyMdHnY4a2NJAvajBgUyb68V0GHHxu7xI0JQ
	PX0seCU
X-Google-Smtp-Source: AGHT+IFSy1+lFxUURQmqDSNKN0HOOFkFOx1ujyLXJg2nypF43Lq0YrQtt9+vrxTHS0Rrgmo+7XmdqQ==
X-Received: by 2002:a05:600c:1d14:b0:477:97c7:9be7 with SMTP id 5b1f17b1804b1-47d84b0a7bdmr104836275e9.1.1767958152875;
        Fri, 09 Jan 2026 03:29:12 -0800 (PST)
Received: from 127.com ([2620:10d:c092:600::1:69b5])
        by smtp.gmail.com with ESMTPSA id 5b1f17b1804b1-47d8636c610sm60056985e9.0.2026.01.09.03.29.09
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 09 Jan 2026 03:29:12 -0800 (PST)
From: Pavel Begunkov <asml.silence@gmail.com>
To: netdev@vger.kernel.org
Cc: "David S . Miller" <davem@davemloft.net>,
	Eric Dumazet <edumazet@google.com>,
	Jakub Kicinski <kuba@kernel.org>,
	Paolo Abeni <pabeni@redhat.com>,
	Jonathan Corbet <corbet@lwn.net>,
	Michael Chan <michael.chan@broadcom.com>,
	Pavan Chebbi <pavan.chebbi@broadcom.com>,
	Andrew Lunn <andrew+netdev@lunn.ch>,
	Alexei Starovoitov <ast@kernel.org>,
	Daniel Borkmann <daniel@iogearbox.net>,
	Jesper Dangaard Brouer <hawk@kernel.org>,
	John Fastabend <john.fastabend@gmail.com>,
	Joshua Washington <joshwash@google.com>,
	Harshitha Ramamurthy <hramamurthy@google.com>,
	Saeed Mahameed <saeedm@nvidia.com>,
	Tariq Toukan <tariqt@nvidia.com>,
	Mark Bloch <mbloch@nvidia.com>,
	Leon Romanovsky <leon@kernel.org>,
	Alexander Duyck <alexanderduyck@fb.com>,
	Ilias Apalodimas <ilias.apalodimas@linaro.org>,
	Shuah Khan <shuah@kernel.org>,
	Willem de Bruijn <willemb@google.com>,
	Ankit Garg <nktgrg@google.com>,
	Tim Hostetler <thostet@google.com>,
	Alok Tiwari <alok.a.tiwari@oracle.com>,
	Ziwei Xiao <ziweixiao@google.com>,
	John Fraker <jfraker@google.com>,
	Praveen Kaligineedi <pkaligineedi@google.com>,
	Mohsin Bashir <mohsin.bashr@gmail.com>,
	Joe Damato <joe@dama.to>,
	Mina Almasry <almasrymina@google.com>,
	Dimitri Daskalakis <dimitri.daskalakis1@gmail.com>,
	Stanislav Fomichev <sdf@fomichev.me>,
	Kuniyuki Iwashima <kuniyu@google.com>,
	Samiullah Khawaja <skhawaja@google.com>,
	Ahmed Zaki <ahmed.zaki@intel.com>,
	Alexander Lobakin <aleksander.lobakin@intel.com>,
	Pavel Begunkov <asml.silence@gmail.com>,
	David Wei <dw@davidwei.uk>,
	Yue Haibing <yuehaibing@huawei.com>,
	Haiyue Wang <haiyuewa@163.com>,
	Jens Axboe <axboe@kernel.dk>,
	Simon Horman <horms@kernel.org>,
	Vishwanath Seshagiri <vishs@fb.com>,
	linux-doc@vger.kernel.org,
	linux-kernel@vger.kernel.org,
	bpf@vger.kernel.org,
	linux-rdma@vger.kernel.org,
	linux-kselftest@vger.kernel.org,
	dtatulea@nvidia.com,
	io-uring@vger.kernel.org
Subject: [PATCH net-next v8 7/9] eth: bnxt: support qcfg provided rx page size
Date: Fri,  9 Jan 2026 11:28:46 +0000
Message-ID: <28028611f572ded416b8ab653f1b9515b0337fba.1767819709.git.asml.silence@gmail.com>
X-Mailer: git-send-email 2.52.0
In-Reply-To: <cover.1767819709.git.asml.silence@gmail.com>
References: <cover.1767819709.git.asml.silence@gmail.com>
Precedence: bulk
X-Mailing-List: io-uring@vger.kernel.org
List-Id: <io-uring.vger.kernel.org>
List-Subscribe: <mailto:io-uring+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:io-uring+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

Implement support for qcfg provided rx page sizes. For that, implement
the ndo_default_qcfg callback and validate the config on restart. Also,
use the current config's value in bnxt_init_ring_struct to retain the
correct size across resets.

Signed-off-by: Pavel Begunkov <asml.silence@gmail.com>
---
 drivers/net/ethernet/broadcom/bnxt/bnxt.c | 36 ++++++++++++++++++++++-
 drivers/net/ethernet/broadcom/bnxt/bnxt.h |  1 +
 2 files changed, 36 insertions(+), 1 deletion(-)

diff --git a/drivers/net/ethernet/broadcom/bnxt/bnxt.c b/drivers/net/ethernet/broadcom/bnxt/bnxt.c
index 137e348d2b9c..3ffe4fe159d3 100644
--- a/drivers/net/ethernet/broadcom/bnxt/bnxt.c
+++ b/drivers/net/ethernet/broadcom/bnxt/bnxt.c
@@ -4325,6 +4325,7 @@ static void bnxt_init_ring_struct(struct bnxt *bp)
 		struct bnxt_rx_ring_info *rxr;
 		struct bnxt_tx_ring_info *txr;
 		struct bnxt_ring_struct *ring;
+		struct netdev_rx_queue *rxq;
 
 		if (!bnapi)
 			continue;
@@ -4342,7 +4343,8 @@ static void bnxt_init_ring_struct(struct bnxt *bp)
 		if (!rxr)
 			goto skip_rx;
 
-		rxr->rx_page_size = BNXT_RX_PAGE_SIZE;
+		rxq = __netif_get_rx_queue(bp->dev, i);
+		rxr->rx_page_size = rxq->qcfg.rx_page_size;
 
 		ring = &rxr->rx_ring_struct;
 		rmem = &ring->ring_mem;
@@ -15932,6 +15934,29 @@ static const struct netdev_stat_ops bnxt_stat_ops = {
 	.get_base_stats		= bnxt_get_base_stats,
 };
 
+static void bnxt_queue_default_qcfg(struct net_device *dev,
+				    struct netdev_queue_config *qcfg)
+{
+	qcfg->rx_page_size = BNXT_RX_PAGE_SIZE;
+}
+
+static int bnxt_validate_qcfg(struct bnxt *bp, struct netdev_queue_config *qcfg)
+{
+	/* Older chips need MSS calc so rx_page_size is not supported */
+	if (!(bp->flags & BNXT_FLAG_CHIP_P5_PLUS) &&
+	     qcfg->rx_page_size != BNXT_RX_PAGE_SIZE)
+		return -EINVAL;
+
+	if (!is_power_of_2(qcfg->rx_page_size))
+		return -ERANGE;
+
+	if (qcfg->rx_page_size < BNXT_RX_PAGE_SIZE ||
+	    qcfg->rx_page_size > BNXT_MAX_RX_PAGE_SIZE)
+		return -ERANGE;
+
+	return 0;
+}
+
 static int bnxt_queue_mem_alloc(struct net_device *dev,
 				struct netdev_queue_config *qcfg,
 				void *qmem, int idx)
@@ -15944,6 +15969,10 @@ static int bnxt_queue_mem_alloc(struct net_device *dev,
 	if (!bp->rx_ring)
 		return -ENETDOWN;
 
+	rc = bnxt_validate_qcfg(bp, qcfg);
+	if (rc < 0)
+		return rc;
+
 	rxr = &bp->rx_ring[idx];
 	clone = qmem;
 	memcpy(clone, rxr, sizeof(*rxr));
@@ -15955,6 +15984,7 @@ static int bnxt_queue_mem_alloc(struct net_device *dev,
 	clone->rx_sw_agg_prod = 0;
 	clone->rx_next_cons = 0;
 	clone->need_head_pool = false;
+	clone->rx_page_size = qcfg->rx_page_size;
 
 	rc = bnxt_alloc_rx_page_pool(bp, clone, rxr->page_pool->p.nid);
 	if (rc)
@@ -16081,6 +16111,8 @@ static void bnxt_copy_rx_ring(struct bnxt *bp,
 	src_ring = &src->rx_agg_ring_struct;
 	src_rmem = &src_ring->ring_mem;
 
+	dst->rx_page_size = src->rx_page_size;
+
 	WARN_ON(dst_rmem->nr_pages != src_rmem->nr_pages);
 	WARN_ON(dst_rmem->page_size != src_rmem->page_size);
 	WARN_ON(dst_rmem->flags != src_rmem->flags);
@@ -16235,6 +16267,8 @@ static const struct netdev_queue_mgmt_ops bnxt_queue_mgmt_ops = {
 	.ndo_queue_mem_free	= bnxt_queue_mem_free,
 	.ndo_queue_start	= bnxt_queue_start,
 	.ndo_queue_stop		= bnxt_queue_stop,
+	.ndo_default_qcfg	= bnxt_queue_default_qcfg,
+	.supported_params	= QCFG_RX_PAGE_SIZE,
 };
 
 static void bnxt_remove_one(struct pci_dev *pdev)
diff --git a/drivers/net/ethernet/broadcom/bnxt/bnxt.h b/drivers/net/ethernet/broadcom/bnxt/bnxt.h
index 4c880a9fba92..d245eefbbdda 100644
--- a/drivers/net/ethernet/broadcom/bnxt/bnxt.h
+++ b/drivers/net/ethernet/broadcom/bnxt/bnxt.h
@@ -760,6 +760,7 @@ struct nqe_cn {
 #endif
 
 #define BNXT_RX_PAGE_SIZE (1 << BNXT_RX_PAGE_SHIFT)
+#define BNXT_MAX_RX_PAGE_SIZE BIT(15)
 
 #define BNXT_MAX_MTU		9500
 
-- 
2.52.0


