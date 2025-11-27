Return-Path: <io-uring+bounces-10830-lists+io-uring=lfdr.de@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from dfw.mirrors.kernel.org (dfw.mirrors.kernel.org [142.0.200.124])
	by mail.lfdr.de (Postfix) with ESMTPS id 809E6C9026D
	for <lists+io-uring@lfdr.de>; Thu, 27 Nov 2025 21:45:35 +0100 (CET)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by dfw.mirrors.kernel.org (Postfix) with ESMTPS id E8E794E397E
	for <lists+io-uring@lfdr.de>; Thu, 27 Nov 2025 20:45:33 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id EBDC131E0E6;
	Thu, 27 Nov 2025 20:44:40 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="DotU0Rr0"
X-Original-To: io-uring@vger.kernel.org
Received: from mail-wr1-f53.google.com (mail-wr1-f53.google.com [209.85.221.53])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1E00F31A561
	for <io-uring@vger.kernel.org>; Thu, 27 Nov 2025 20:44:38 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.221.53
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1764276280; cv=none; b=doG8Vg7hivHr8lMKNRm/X/u8drf2QblK+NdHOtx/uridNiuxX8sEjmhG3oGn31IbWoM5CzELqekEj/hCntU+4o+g5OfHPmcoboSeg6rBeT+68sGS7tSI8Z9KcwEp+w2Uo44OZDoGnwW0tKwhEQ3lXFIE+j4TvWtxFhegk2dleC0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1764276280; c=relaxed/simple;
	bh=D2EsVI2xh2ZhL05Tk+r0h3Pg9Cl/77LcPo6nKDQSuGY=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=Qge0ei/5CR37SAeysL31og8HSpvrQBU6xz/+ZJjNUKNoTWZmHRX3XXa7SZSx9nhzmwrhEapqLOJHJu805W3L72JJ2SwQNd+P23vBAnqVj4uDdzadYcI0t56Ggg9wbbM28YfFKD871hZzqZASNNC/z96aNjvmYBVbEOiBxNyLJg0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=DotU0Rr0; arc=none smtp.client-ip=209.85.221.53
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Received: by mail-wr1-f53.google.com with SMTP id ffacd0b85a97d-42b3b29153fso734611f8f.3
        for <io-uring@vger.kernel.org>; Thu, 27 Nov 2025 12:44:38 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1764276277; x=1764881077; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=vy0XbKcemKbh0CcuwZvqfWEa3IvL5tyGOdRED1Ad+uQ=;
        b=DotU0Rr0wYeSWTrWjGX/hBXLnQeUJKMJjdb5kKAplXeQlnY0TpvGr0vyMBlJOvTUwk
         Xjgkiix19rVRe8+vvy8g9kTRuKDtzTXAWUsm9TzfgAbeVmVMaULHrPHsPnxqi2Ev2ioC
         c/xFZQQZzexZLpT+l7tmuwnRQK0/daDbEN9GbGVwrYiyAuzPS3cev62PXtoBd0H8P3A0
         NV1jpL/DnDOGmDI63j3gSIfs7Jv+Os52cf3gKKvNTK1G9l8Cxca7ZyJIMV7VSk2vOKGh
         s0wH9bBwWYbS4dj/u2VBgZtJ6xcsiFIVNAsuFkxcdueUhB2srfjlNlcNG/ekJVufYK5J
         5Ltg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1764276277; x=1764881077;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to;
        bh=vy0XbKcemKbh0CcuwZvqfWEa3IvL5tyGOdRED1Ad+uQ=;
        b=O9kwt5oZ5MVsqnEXU35mNWssHatWEZF/42Xj/Z4r/BAdEfYF9hvPptPnOzvn18HHhq
         eHHStef8I1hnazqQ4B1rNP766Tn8KvbuhmJAIPpa9uBl/wqq7dm1TfpBH1aCFXzh2i7P
         PO7qoxSsoy7QMLH+0GC+ZTPU04Z9LPBVAJxjKIHx1kTw+B7cjWELfQ1bsuxJSSpQP2Fi
         6D4f1dpsYfBOEWnfh2DWiuO0mMZSYeFHhxA9aq1MSyiPIK+g6ym+xm5uCWbQbm1Yw46F
         BoGcdtCF/uYXERr0+UUSV1Xe6AZ7VXW3wmNQP2jQPPZ5FisGDViezwL2tyJF2b2Nr8kZ
         4zPg==
X-Forwarded-Encrypted: i=1; AJvYcCVsFBZNjwGihUgX77tmbsSH4fkmNOeOKffK1V7bF/mJpk0l1tEfwnuz/C/Ym/MV4bUSoTOUBok2WQ==@vger.kernel.org
X-Gm-Message-State: AOJu0Yzsgc61oggikGTo6VP8UPZdZr+9pgh7W+2b1XXCPdxPmvzYcdqf
	2Ee29Amz46uUTjalYIiNJ8ZrPyUpkITQz2KuLhP6lny6j+ZXl3ExZQlt
X-Gm-Gg: ASbGncvv0My5N9hWU37u3jO0aVpav+4F+QLvNbj38KXKsUQ+2HXNMeQtbupNmMtqBt3
	6zDlLOvkwuE2cVwlS2S01KToiUhPpNkMBDoq/nJDDK1lAaNhDxv0kD63qHkXGoZMIDwqwc14DkZ
	L6/pk5XUqtw7JGFZp1bzB4ZCPqMhTaLEw9+tLSNeWL/OILI9Gz+skbQ/pGXSkagRQmDqB3bSMdS
	x+4d3VFKx+I9USQeCXj4kUbj8dDgQGx97abiP59GUutFYNb0E+ERBf1BXwDy1RVYpQBnhTV+FyS
	AsmO/NlPOEtBj8lc2BEpgB4f5tkBlIbHPu/L0g29k6bzWhqTHK5sx0GYLI6PmhcSofIOVoUyY7+
	i4GU/vOI8DfKEkYlgD9319x7Rg0pWo6y/KnDdYcJgQTaYz5LuVGrexUH+xH8711oXvMCa2QGQyn
	NxXbbFai7fBwtHSQ==
X-Google-Smtp-Source: AGHT+IE4EdepoSGguIef0SYCibCymaDm7WjMY8rUmVSyXGFaZ7vrRrlEhrAxCK+PPLWhSAF3UH6tKg==
X-Received: by 2002:a05:6000:2f81:b0:429:bc68:6c95 with SMTP id ffacd0b85a97d-42cc1d520camr29604197f8f.47.1764276277267;
        Thu, 27 Nov 2025 12:44:37 -0800 (PST)
Received: from 127.mynet ([2a01:4b00:bd21:4f00:7cc6:d3ca:494:116c])
        by smtp.gmail.com with ESMTPSA id ffacd0b85a97d-42e1c5d614asm5346105f8f.12.2025.11.27.12.44.36
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 27 Nov 2025 12:44:36 -0800 (PST)
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
	Ilias Apalodimas <ilias.apalodimas@linaro.org>,
	Stanislav Fomichev <sdf@fomichev.me>,
	Pavel Begunkov <asml.silence@gmail.com>,
	Jens Axboe <axboe@kernel.dk>,
	Simon Horman <horms@kernel.org>,
	linux-doc@vger.kernel.org,
	linux-kselftest@vger.kernel.org,
	io-uring@vger.kernel.org,
	dtatulea@nvidia.com
Subject: [PATCH net-next v6 6/8] eth: bnxt: allow providers to set rx buf size
Date: Thu, 27 Nov 2025 20:44:19 +0000
Message-ID: <9342d7dd5e663d3d44419229d6c9971b67e3f059.1764264798.git.asml.silence@gmail.com>
X-Mailer: git-send-email 2.52.0
In-Reply-To: <cover.1764264798.git.asml.silence@gmail.com>
References: <cover.1764264798.git.asml.silence@gmail.com>
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
index fc88566779a4..698ed30b1dcc 100644
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
index bfe36ea1e7c5..b59b8e4984f4 100644
--- a/drivers/net/ethernet/broadcom/bnxt/bnxt.h
+++ b/drivers/net/ethernet/broadcom/bnxt/bnxt.h
@@ -759,6 +759,7 @@ struct nqe_cn {
 #endif
 
 #define BNXT_RX_PAGE_SIZE (1 << BNXT_RX_PAGE_SHIFT)
+#define BNXT_MAX_RX_PAGE_SIZE (1 << 15)
 
 #define BNXT_MAX_MTU		9500
 
-- 
2.52.0


