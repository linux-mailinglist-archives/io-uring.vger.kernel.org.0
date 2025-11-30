Return-Path: <io-uring+bounces-10866-lists+io-uring=lfdr.de@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from dfw.mirrors.kernel.org (dfw.mirrors.kernel.org [IPv6:2605:f480:58:1:0:1994:3:14])
	by mail.lfdr.de (Postfix) with ESMTPS id 8BFF0C956BB
	for <lists+io-uring@lfdr.de>; Mon, 01 Dec 2025 00:37:58 +0100 (CET)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by dfw.mirrors.kernel.org (Postfix) with ESMTPS id 330AA4E17B9
	for <lists+io-uring@lfdr.de>; Sun, 30 Nov 2025 23:37:28 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 340F43019DA;
	Sun, 30 Nov 2025 23:35:47 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="N+0soFpq"
X-Original-To: io-uring@vger.kernel.org
Received: from mail-wm1-f42.google.com (mail-wm1-f42.google.com [209.85.128.42])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D62E53016EE
	for <io-uring@vger.kernel.org>; Sun, 30 Nov 2025 23:35:44 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.128.42
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1764545747; cv=none; b=bJcwUG9WKa7kpsh1I0DT/z47oEp47oWCU99C+A8kPybbD6aN1m6PopYwcXLzB3+u9/9WecC4rt3zcyCxv8Ij4+9N+cDzeD42B3cNB+ZDqTICwDfQtth6kTDiiUoIKuvV08sxnusJBQG0z6Et0GNRgDzNocm90b9GQhqNiFO4FeM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1764545747; c=relaxed/simple;
	bh=yKCm3JWX46w3TSeS1HDjGDEN8Lb+RgGnnDzf1hIzpyg=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=puvO5ad1KbVqf6JrmzEgT/66N3tC22CWYMq8mccZgdXlLYDtOE3CzVbUnQddTEPYjWE1tI7LTes8OFhwIEeYDTZeqKAM6mixNGqZqiZOuLQhXW6fSg8NnW0FQrhRb+/dIYY0PgLeU/5Yv7AV8qYsasyShSbaWHH3m3tkGsoWvbI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=N+0soFpq; arc=none smtp.client-ip=209.85.128.42
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Received: by mail-wm1-f42.google.com with SMTP id 5b1f17b1804b1-4779aa4f928so28510515e9.1
        for <io-uring@vger.kernel.org>; Sun, 30 Nov 2025 15:35:44 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1764545743; x=1765150543; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=HX9L7y9TUVKUZMrEe/EUsMICdbihgCRR79vdhXFo/qA=;
        b=N+0soFpqHul603HIj5zHoSIfWc5W9GiN6vklkHMVCs+W4/neQtP3pzS0yfITiq28bG
         1izqBmz0Vq+fFKQ90rZEKWfeAmlDKPBAVTfnKXldC1ZylLjyioNEh0rQ6vIW6bjHxWwb
         dXc16NPNkz+eQ3kl80Ti+ATMzdbzHq/OZvtcgJ0eCzm3zsHw6eedbvvEogje1iB8l+oI
         inpqFusTXLkC/LWcYbmtLwuFDBKMJ/1tXQRoaDHMXWgrEEoHrkJjEig8DI316DClAjP5
         5iNp8pL5Ib8wkKyjZvbfl27mruFlb4/Lv1r3nw4lqegb/2efQpLsdF6pEzuG6v8b2Pwv
         13Kg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1764545743; x=1765150543;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to;
        bh=HX9L7y9TUVKUZMrEe/EUsMICdbihgCRR79vdhXFo/qA=;
        b=OAGzuJ3S82IzvBWiRBjuh8wjoysiNoOJjh0I80ccTzyNJZKzP04M8yJkOA0ZPMuKTy
         TQlFD7jDcB0rRfWFM0IuT1VtHWA3bXOw6UnqD4B4KTpaQWgTjUayYK0cDH1UCqaZ4cop
         /lK8UdzGC3F3WUd6tXJi2D57t8FLY8jT49EsNNvirbzLuUjDWeXrKEURcW1rYBMd76hn
         3hPmVusTJUvIgdaAiZiDQN2AHBLzQMMOiWQIBkHRbzf0BCtWozAtZFtgMtluOfDrzZM6
         256POo2DJOYAFatlasgle4h3eSaNr702WiTED8DAO8xywzUuMTxr5ktRvW8kkcdPTLbK
         yaDg==
X-Forwarded-Encrypted: i=1; AJvYcCWaCahH+yvvc8+ceUsAkcxsJPpU1/1NAjVvYwiF7eVBHdkT/ygVNiKaHpLIoPHfBSj4EnYS6cuKOA==@vger.kernel.org
X-Gm-Message-State: AOJu0YxtabjhpXhMj+oZl6j+DB7ki3uKpZO2z5KfA2f5am0omfbkBg3r
	3GNy/gEcl6CJ/VN2K34OoNxS/ZEWeWVv5NflgdPzUtpB02LHkHvhTCqK
X-Gm-Gg: ASbGncsi1eMItKIkyxkC7QjDifrDNLdhb6cUZPI4YlR/kBKTERnsv2V0om5ctFCkmhs
	o9WJB9mPP3h7whBLtaa+aVDUhRNE+p+khjep4L/r87/a8fzjN99b6svK2f131H8JSMcMhVR9e51
	xzWcMTXzWzUopBFMXc3TAnlkILBztcPLrezCMhAMvTbyRqjMHWNcr3qUSNqeclhEXSb9VxG4koj
	S3zh6WyUwKaaPbrxBnFV/+GYWVCCSRHB0Ee2KgG5oXCthqwGItPpVD0ayj2gQmIeYRPTZDNEU6/
	vB9WzfZ2RDxk/5qqVcxG79m2QAz8CLTHqnntjD46CrW0Z+ZMMsPSPxZMQ80S3k2oAXL+S2pn8k+
	Upf6kyiC0617RXxvSpmuu5q0PJ9PHEg6QmT2tze4sBL0kDTixiAZJK6g3jniTwt8uA0y9jbD+w6
	Tzzub9L9NHLw7r7ashYXuLujhnaog0rNIWaAOMVzWJ1SkKpg/Tet21B8lh6OcNS8wZWEzuDfxd+
	9JU52CI8X0S7RdM
X-Google-Smtp-Source: AGHT+IEXud9v2I+TjLUDj/xk+alqLhuWUdH7fEpxpL99N2ZrU2hz5Df/0YCDMBC9pg3l3cG4o9WBpg==
X-Received: by 2002:a05:600c:4e91:b0:477:7a95:b971 with SMTP id 5b1f17b1804b1-47904b2c3dfmr250016755e9.31.1764545742979;
        Sun, 30 Nov 2025 15:35:42 -0800 (PST)
Received: from 127.mynet ([2a01:4b00:bd21:4f00:7cc6:d3ca:494:116c])
        by smtp.gmail.com with ESMTPSA id 5b1f17b1804b1-479040b3092sm142722075e9.1.2025.11.30.15.35.41
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sun, 30 Nov 2025 15:35:42 -0800 (PST)
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
	Ilias Apalodimas <ilias.apalodimas@linaro.org>,
	Shuah Khan <shuah@kernel.org>,
	Mina Almasry <almasrymina@google.com>,
	Stanislav Fomichev <sdf@fomichev.me>,
	Pavel Begunkov <asml.silence@gmail.com>,
	Yue Haibing <yuehaibing@huawei.com>,
	David Wei <dw@davidwei.uk>,
	Haiyue Wang <haiyuewa@163.com>,
	Jens Axboe <axboe@kernel.dk>,
	Joe Damato <jdamato@fastly.com>,
	Simon Horman <horms@kernel.org>,
	Vishwanath Seshagiri <vishs@fb.com>,
	linux-doc@vger.kernel.org,
	linux-kernel@vger.kernel.org,
	bpf@vger.kernel.org,
	linux-kselftest@vger.kernel.org,
	io-uring@vger.kernel.org,
	dtatulea@nvidia.com
Subject: [PATCH net-next v7 7/9] eth: bnxt: allow providers to set rx buf size
Date: Sun, 30 Nov 2025 23:35:22 +0000
Message-ID: <95566e5d1b75abcaefe3dca9a52015c2b5f04933.1764542851.git.asml.silence@gmail.com>
X-Mailer: git-send-email 2.52.0
In-Reply-To: <cover.1764542851.git.asml.silence@gmail.com>
References: <cover.1764542851.git.asml.silence@gmail.com>
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
index e9840165c7d0..0eff527c267b 100644
--- a/drivers/net/ethernet/broadcom/bnxt/bnxt.c
+++ b/drivers/net/ethernet/broadcom/bnxt/bnxt.c
@@ -15932,16 +15932,46 @@ static const struct netdev_stat_ops bnxt_stat_ops = {
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
@@ -15953,6 +15983,7 @@ static int bnxt_queue_mem_alloc(struct net_device *dev, void *qmem, int idx)
 	clone->rx_sw_agg_prod = 0;
 	clone->rx_next_cons = 0;
 	clone->need_head_pool = false;
+	clone->rx_page_size = rx_buf_size;
 
 	rc = bnxt_alloc_rx_page_pool(bp, clone, rxr->page_pool->p.nid);
 	if (rc)
@@ -16079,6 +16110,8 @@ static void bnxt_copy_rx_ring(struct bnxt *bp,
 	src_ring = &src->rx_agg_ring_struct;
 	src_rmem = &src_ring->ring_mem;
 
+	dst->rx_page_size = src->rx_page_size;
+
 	WARN_ON(dst_rmem->nr_pages != src_rmem->nr_pages);
 	WARN_ON(dst_rmem->page_size != src_rmem->page_size);
 	WARN_ON(dst_rmem->flags != src_rmem->flags);
@@ -16231,6 +16264,7 @@ static const struct netdev_queue_mgmt_ops bnxt_queue_mgmt_ops = {
 	.ndo_queue_mem_free	= bnxt_queue_mem_free,
 	.ndo_queue_start	= bnxt_queue_start,
 	.ndo_queue_stop		= bnxt_queue_stop,
+	.supported_params	= NDO_QUEUE_RX_BUF_SIZE,
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


