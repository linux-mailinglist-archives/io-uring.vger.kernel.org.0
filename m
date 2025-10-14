Return-Path: <io-uring+bounces-10000-lists+io-uring=lfdr.de@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [147.75.80.249])
	by mail.lfdr.de (Postfix) with ESMTPS id 899E0BD982F
	for <lists+io-uring@lfdr.de>; Tue, 14 Oct 2025 15:03:09 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id 9998319A015E
	for <lists+io-uring@lfdr.de>; Tue, 14 Oct 2025 13:02:26 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id E83F4314D04;
	Tue, 14 Oct 2025 13:00:42 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="OlShYp1S"
X-Original-To: io-uring@vger.kernel.org
Received: from mail-wr1-f41.google.com (mail-wr1-f41.google.com [209.85.221.41])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E0290313E11
	for <io-uring@vger.kernel.org>; Tue, 14 Oct 2025 13:00:40 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.221.41
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1760446842; cv=none; b=h1rpaMbqmITC0Fl9A2rBY79EN1OhwU+FQX4Z37vv/BBJQq3cgZW2ayWkcC559/UScOWVwAT2J4oN/ApafzUVS2xU2pePjIYKxT0u/FYP1ju9T/HeS1b1R/sbLDb9gBCv2LsuzzDssV+82AI2Q9ka20QXuucvHckCgyILfb0sYVs=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1760446842; c=relaxed/simple;
	bh=HRBeeqncveoZFS7vcpAo1b3/1g5dn/bW6PkOv+8KzhQ=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=Pa0risTCR4h+eO0WzCaqOh89bIgCl7RNAVkWDmQ0MRqKKV+VO92NvTGodmA+/eZ08QuUY9gzVfAjVDO0w86iUSg8npMHbHwxA4DLcOySDdL3TkS34+Xjsq3mvyMyK/pBJrjflymyo0zA2XNFGpmFeaYO8M/kqT2DikSvXc+EOyE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=OlShYp1S; arc=none smtp.client-ip=209.85.221.41
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Received: by mail-wr1-f41.google.com with SMTP id ffacd0b85a97d-42568669606so3887228f8f.2
        for <io-uring@vger.kernel.org>; Tue, 14 Oct 2025 06:00:40 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1760446839; x=1761051639; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=Fr+blYainBcpT6wR27xzUZrr6kB24eyLx7MFFl01tLI=;
        b=OlShYp1S6wwr3A3l3D/OKq1RWcY7wjbrWDhM5KKUdElsltBDlIYZPuDuIeIBheWPDX
         G70nBH1jc+JSGI/04uLkWAPJ7s70pEFmxZiEOx/Dff+D5u6+tXyV4ZWmnjsypo2CMvJa
         2QmzLDYAas4AXbdI7OEkVHOVIzbAustBzwz/SV5+IruPp7oSpS0C8VUSOrVK2SWSlRO0
         BzLb+BqYb17tZnMAiVdyZXR9xtGOCXJc+Gok/Vtld7s90g3qCQYZG/aiwHk9P6CItY8z
         a0Wvi0YeIIEqc2ZWZQ7pVar91bLOD0qY2JdOVOq2F+G/hEuRXgxUbdNIviM/by9cZuP4
         Ca/A==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1760446839; x=1761051639;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=Fr+blYainBcpT6wR27xzUZrr6kB24eyLx7MFFl01tLI=;
        b=tJ+2BOg/xTB6U6JqOoceWg2Omg08UPJOTTIufAWMJ3+eZPJ4eTzS3ToBbPJRPDs0tE
         wJwLzpGTSJt09X45ZkE9y2Qsqz7Ve88IPyQYb+YL1hbz3xq8xaYQZ1WTXck+f6hGtr2m
         TXtTmsAssGT5+gGcUBRG/o7eZ1HHwD4xxqNtpy0JhGSM+Vy4RCDLjIMJU7fj1ZZrjF+z
         VMH72KsgQQm9DvLT40muBK3R1aRmb7GMJauKLvNiFgQKDf8yb6g4xbrxTkLyR0BhrFrn
         IQNJjcTiqI0YahVjFdG129kZtivxjGx+OrN5V7ghtLF6551bqhAkMDf2sotn91m9dbzn
         FkiA==
X-Forwarded-Encrypted: i=1; AJvYcCXepH5ZP48NV/joDgRxxPLQyhBJsxeoNP5Uchk9SmiZWVwumIphGebrAQmgQSw0EJf7pKsq+KYI5A==@vger.kernel.org
X-Gm-Message-State: AOJu0Yw75yI191GbU9YQhYDzikg/XHv7BjgpvLzkTsRLIrLU6ksVmJl3
	2QLFBRTzqjkxWhSZFg6MGq3ZmFoWj/bx3MKJsKlHvd1AqKIx84e3i6mm
X-Gm-Gg: ASbGnct8K6heHyNrKOYrRZpR7PYaeJpxJjPDtjp6/X2WV550nf9TzsoMU8G2oYCas9h
	NniL0eyJT5fXk0I/kdKo7xh1FRloC6noFs4iSaIpbNa9EhtkZqtQvovyB0ABOMX0BWC525XuMGG
	TVD7VBKOsrSGcTxVAA9bV8vjPhVt9ByAfalxYy96/oU6x+yiyw0GT2+gf60G/VV5wc00ert07x4
	sZybcYy2L2fExvHNwhD3ga0f1/J7nO747kSB6+ZjQt1oEIvzarPlLH7yLutBTa83Ue690o9tlls
	62t6NMi0t85r+LzaU0YYvUhKHW4oA7TgHbYBfReBBRIKrUkNN7npb1yz7KvZs/05FIrHflnvScM
	fs8TWJEvc9o218eoIWWQD/Fl5
X-Google-Smtp-Source: AGHT+IGcoZuBqHvgvUSsgwLain+WF6qicDLZHuH6hV35Q+IUg9D7eRD2PZdvbylFSmz/OUoUDJoUoA==
X-Received: by 2002:a5d:5889:0:b0:3fa:ff5d:c34a with SMTP id ffacd0b85a97d-4266e7e15bbmr17795709f8f.39.1760446839125;
        Tue, 14 Oct 2025 06:00:39 -0700 (PDT)
Received: from 127.com ([2620:10d:c092:600::1:7ec0])
        by smtp.gmail.com with ESMTPSA id ffacd0b85a97d-426ce582b39sm23296494f8f.15.2025.10.14.06.00.37
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 14 Oct 2025 06:00:38 -0700 (PDT)
From: Pavel Begunkov <asml.silence@gmail.com>
To: netdev@vger.kernel.org,
	io-uring@vger.kernel.org
Cc: Michael Chan <michael.chan@broadcom.com>,
	Pavan Chebbi <pavan.chebbi@broadcom.com>,
	Andrew Lunn <andrew+netdev@lunn.ch>,
	"David S . Miller" <davem@davemloft.net>,
	Eric Dumazet <edumazet@google.com>,
	Jakub Kicinski <kuba@kernel.org>,
	Paolo Abeni <pabeni@redhat.com>,
	Jesper Dangaard Brouer <hawk@kernel.org>,
	John Fastabend <john.fastabend@gmail.com>,
	Stanislav Fomichev <sdf@fomichev.me>,
	Simon Horman <horms@kernel.org>,
	Ilias Apalodimas <ilias.apalodimas@linaro.org>,
	Mina Almasry <almasrymina@google.com>,
	Pavel Begunkov <asml.silence@gmail.com>,
	Willem de Bruijn <willemb@google.com>,
	Dragos Tatulea <dtatulea@nvidia.com>,
	Saeed Mahameed <saeedm@nvidia.com>,
	Tariq Toukan <tariqt@nvidia.com>,
	Mark Bloch <mbloch@nvidia.com>,
	David Wei <dw@davidwei.uk>,
	linux-kernel@vger.kernel.org
Subject: [PATCH net-next v5 6/6] eth: bnxt: allow providers to set rx buf size
Date: Tue, 14 Oct 2025 14:01:26 +0100
Message-ID: <f389276330412ec4305fb423944261e78490f06a.1760440268.git.asml.silence@gmail.com>
X-Mailer: git-send-email 2.49.0
In-Reply-To: <cover.1760440268.git.asml.silence@gmail.com>
References: <cover.1760440268.git.asml.silence@gmail.com>
Precedence: bulk
X-Mailing-List: io-uring@vger.kernel.org
List-Id: <io-uring.vger.kernel.org>
List-Subscribe: <mailto:io-uring+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:io-uring+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

Implement NDO_QUEUE_RX_BUF_SIZE and take the rx buf size from the memory
providers.

Signed-off-by: Pavel Begunkov <asml.silence@gmail.com>
---
 drivers/net/ethernet/broadcom/bnxt/bnxt.c | 34 +++++++++++++++++++++++
 drivers/net/ethernet/broadcom/bnxt/bnxt.h |  1 +
 2 files changed, 35 insertions(+)

diff --git a/drivers/net/ethernet/broadcom/bnxt/bnxt.c b/drivers/net/ethernet/broadcom/bnxt/bnxt.c
index 950e60d204cb..8d0e69dc900e 100644
--- a/drivers/net/ethernet/broadcom/bnxt/bnxt.c
+++ b/drivers/net/ethernet/broadcom/bnxt/bnxt.c
@@ -15906,16 +15906,46 @@ static const struct netdev_stat_ops bnxt_stat_ops = {
 	.get_base_stats		= bnxt_get_base_stats,
 };
 
+static ssize_t bnxt_get_rx_buf_size(struct bnxt *bp, int rxq_idx)
+{
+	struct netdev_rx_queue *rxq = __netif_get_rx_queue(bp->dev, rxq_idx);
+	size_t rx_buf_size;
+
+	rx_buf_size = rxq->mp_params.rx_buf_len;
+	if (!rx_buf_size)
+		return BNXT_RX_PAGE_SIZE;
+
+	/* Older chips need MSS calc so rx_buf_len is not supported,
+	 * but we don't set queue ops for them so we should never get here.
+	 */
+	if (!(bp->flags & BNXT_FLAG_CHIP_P5_PLUS))
+		return -EINVAL;
+
+	if (!is_power_of_2(rx_buf_size))
+		return -ERANGE;
+
+	if (rx_buf_size < BNXT_RX_PAGE_SIZE ||
+	    rx_buf_size > BNXT_MAX_RX_PAGE_SIZE)
+		return -ERANGE;
+
+	return rx_buf_size;
+}
+
 static int bnxt_queue_mem_alloc(struct net_device *dev, void *qmem, int idx)
 {
 	struct bnxt_rx_ring_info *rxr, *clone;
 	struct bnxt *bp = netdev_priv(dev);
 	struct bnxt_ring_struct *ring;
+	ssize_t rx_buf_size;
 	int rc;
 
 	if (!bp->rx_ring)
 		return -ENETDOWN;
 
+	rx_buf_size = bnxt_get_rx_buf_size(bp, idx);
+	if (rx_buf_size < 0)
+		return rx_buf_size;
+
 	rxr = &bp->rx_ring[idx];
 	clone = qmem;
 	memcpy(clone, rxr, sizeof(*rxr));
@@ -15927,6 +15957,7 @@ static int bnxt_queue_mem_alloc(struct net_device *dev, void *qmem, int idx)
 	clone->rx_sw_agg_prod = 0;
 	clone->rx_next_cons = 0;
 	clone->need_head_pool = false;
+	clone->rx_page_size = rx_buf_size;
 
 	rc = bnxt_alloc_rx_page_pool(bp, clone, rxr->page_pool->p.nid);
 	if (rc)
@@ -16053,6 +16084,8 @@ static void bnxt_copy_rx_ring(struct bnxt *bp,
 	src_ring = &src->rx_agg_ring_struct;
 	src_rmem = &src_ring->ring_mem;
 
+	dst->rx_page_size = src->rx_page_size;
+
 	WARN_ON(dst_rmem->nr_pages != src_rmem->nr_pages);
 	WARN_ON(dst_rmem->page_size != src_rmem->page_size);
 	WARN_ON(dst_rmem->flags != src_rmem->flags);
@@ -16205,6 +16238,7 @@ static const struct netdev_queue_mgmt_ops bnxt_queue_mgmt_ops = {
 	.ndo_queue_mem_free	= bnxt_queue_mem_free,
 	.ndo_queue_start	= bnxt_queue_start,
 	.ndo_queue_stop		= bnxt_queue_stop,
+	.supported_params	= NDO_QUEUE_RX_BUF_SIZE,
 };
 
 static void bnxt_remove_one(struct pci_dev *pdev)
diff --git a/drivers/net/ethernet/broadcom/bnxt/bnxt.h b/drivers/net/ethernet/broadcom/bnxt/bnxt.h
index 3a53d9073c4d..d84c0de231b3 100644
--- a/drivers/net/ethernet/broadcom/bnxt/bnxt.h
+++ b/drivers/net/ethernet/broadcom/bnxt/bnxt.h
@@ -759,6 +759,7 @@ struct nqe_cn {
 #endif
 
 #define BNXT_RX_PAGE_SIZE (1 << BNXT_RX_PAGE_SHIFT)
+#define BNXT_MAX_RX_PAGE_SIZE (1 << 15)
 
 #define BNXT_MAX_MTU		9500
 
-- 
2.49.0


