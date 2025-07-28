Return-Path: <io-uring+bounces-8827-lists+io-uring=lfdr.de@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [147.75.80.249])
	by mail.lfdr.de (Postfix) with ESMTPS id C2F83B1399C
	for <lists+io-uring@lfdr.de>; Mon, 28 Jul 2025 13:06:42 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id 5B54A189D882
	for <lists+io-uring@lfdr.de>; Mon, 28 Jul 2025 11:05:18 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 34533264604;
	Mon, 28 Jul 2025 11:03:39 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="XizIb5l7"
X-Original-To: io-uring@vger.kernel.org
Received: from mail-wm1-f41.google.com (mail-wm1-f41.google.com [209.85.128.41])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6D0B7263F40;
	Mon, 28 Jul 2025 11:03:37 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.128.41
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1753700619; cv=none; b=LB2SyZ+aPkbcOCJfl1JZmuJoBUbztwudD+0iM8bSlSKRgGowzoxtVgzeJp7D1YwojzDg9yLpCeiIxITt3Hv5oOEPKWdvdCOUlA/ZnPndILsycITf3I2pTksxcGQ+1A+5+HM8t0oYb3qLquFBMrrjnBmkJ92a33z4pG04As2o8qg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1753700619; c=relaxed/simple;
	bh=gcQmjZOcrC24/U3WO7nbk6Qhzm4KycLQlBRJ+WOz3ds=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=Xgv6qll0UecRKexhEGYJmaTiJu9kZDmniCWlbki7W9W3bEPBSRRE2VIOzRsddpX4DVZFr4j/oCiLef8Y1Nf/l2j43Li/B6pedb4Puhi3U0z+CwYh9Q9Hu2qRS94b4T0CGXpp8cjehFnr0+auBGP2FdmEc9OMburo1FSqRRRWZVg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=XizIb5l7; arc=none smtp.client-ip=209.85.128.41
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Received: by mail-wm1-f41.google.com with SMTP id 5b1f17b1804b1-4561ca74829so45586015e9.0;
        Mon, 28 Jul 2025 04:03:37 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1753700616; x=1754305416; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=aAmKOrkaiUc2a7mujUacNV0qgx3lTjIapuuJNNW/KCo=;
        b=XizIb5l74u/G0JZ72COqVGXHtEaLAZ5gMgIDyDmyQ1jVqcGSZTKZnlFI6/1ouBS3uv
         0VAME4y5F/GmoMjHMzh2+6j6TVdMIHTuf9BsAMRL6Exyhyg/knbWGxGkYzrOXixNID4D
         xB2Vcm47K8ZxTc1LREBTz/O4cVYkfJePbGnmLwxNKQhazpejFSz2OAzFlXkygP7I+69D
         ur/C+IBa8Kh/mciCWLk5hlQX+aJOLvh9HbCjPhGMIPRizhfpGE/C5zXtv1CB6Rq8RcGZ
         XICIATX+v61MY8DKKiDlZ+PcXbBukJmQ/W+4cmIIAPwpxc7IMCS5EyoOmdDy4KApeIx1
         vODg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1753700616; x=1754305416;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=aAmKOrkaiUc2a7mujUacNV0qgx3lTjIapuuJNNW/KCo=;
        b=A8E/EtHHCkHmesKlBeygiISUfcFT/fdyf8Z043W3F+K7rJdOsLt9B71hV28qRAPiUB
         hFpS38qcy721ZykcHAa5oyGKuV4LL/twBsLWH7jU2ZuuAnzUFXAhQEOrKWnfbjfmRrOU
         3yOEeVQDLjyN1whkOLIHn5nYvsBInV8VbVG8XYwJQXokqsIHWQi5IOqMTRpPrNKpwBvI
         2QyzgqA2ajFwnE8TYVNtqLPGOCODHiXC/JqMHOi/iBqIMU6qHmIX961HI0poycYPV3Nc
         5oFV33VLB0sZHbHSf2rJv5DitpjrGq7/JeAxd+dR7V7BUJSc8XJPwl5LWNIDKyU8e7Qf
         KsCg==
X-Forwarded-Encrypted: i=1; AJvYcCU74PMKVwlWF1UkkQi+pT2FeihfMqUw24op0WDT/POPjSSieAp+8s0ckd8v0MI9xr8PFizX46GzMA==@vger.kernel.org, AJvYcCXsbY33tnDKmW1ftQjTmUjs+BTibnEVEKy7GIxmwQIHDAFWtY6nC8fNkuzb18D7CgZVCISisMpW@vger.kernel.org
X-Gm-Message-State: AOJu0Yw8yyH2Fq3SD/uK6qNaHog+Vwtvu+/HFXYT9IgTH1FTnLZSrzhR
	OjJhpZwKP9a78AQIiNlLk2i537YCRRf9cvwe8NsOYrJnEZlcFfdrE3y6
X-Gm-Gg: ASbGncuQ3IWLbxgkA0PypSd8jVdiKExTRw+qRazwim42YZZ2j+/w5jiBRb4naMOu7PM
	Lz8lBFh49HClF9VpPeu0YcMY2rdabx0R6UwPcTFowy4ZRZFCLGXJ5XPHtHW2It5kwfLsrnNenz+
	t7jsQOtX5WikjFW/uNGTnB9Omi/V6uzLkKO7ezil6uKj+COmUGvrnQxkuqxbUUOJUUe15lae4U9
	jU33EgxBAwID6YiFWzGCaYOdkQP1JRYSwruJ6oZ5NRAwuhlqZZb06NSCkWJw1wEQ5CAxX03L5uR
	ZMAZWbvTMx9o9y4p3J+exHbdaB87JlXpRBtyctDXuP7fJ1ExY1KzSMW/pCYV4xf8MITD/lGPd7r
	F/CAz4yT/arNDuA==
X-Google-Smtp-Source: AGHT+IGawjnphEw5FmRwL+aJWIoV35D/x+gQjXj3nOPnM1qH90dRaG/eNvtliIv57dQssiUzZdA8Cg==
X-Received: by 2002:a05:6000:2dc9:b0:3a5:7967:cdb9 with SMTP id ffacd0b85a97d-3b776688bb9mr7521606f8f.46.1753700615561;
        Mon, 28 Jul 2025 04:03:35 -0700 (PDT)
Received: from 127.com ([2620:10d:c092:600::1:75])
        by smtp.gmail.com with ESMTPSA id 5b1f17b1804b1-458705c4fdasm157410235e9.28.2025.07.28.04.03.34
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 28 Jul 2025 04:03:34 -0700 (PDT)
From: Pavel Begunkov <asml.silence@gmail.com>
To: Jakub Kicinski <kuba@kernel.org>,
	netdev@vger.kernel.org
Cc: asml.silence@gmail.com,
	io-uring@vger.kernel.org,
	Eric Dumazet <edumazet@google.com>,
	Willem de Bruijn <willemb@google.com>,
	Paolo Abeni <pabeni@redhat.com>,
	andrew+netdev@lunn.ch,
	horms@kernel.org,
	davem@davemloft.net,
	sdf@fomichev.me,
	almasrymina@google.com,
	dw@davidwei.uk,
	michael.chan@broadcom.com,
	dtatulea@nvidia.com,
	ap420073@gmail.com
Subject: [RFC v1 16/22] eth: bnxt: adjust the fill level of agg queues with larger buffers
Date: Mon, 28 Jul 2025 12:04:20 +0100
Message-ID: <d7bc505a32ca2a4a5b3c9353f841e3572b911f7b.1753694914.git.asml.silence@gmail.com>
X-Mailer: git-send-email 2.49.0
In-Reply-To: <cover.1753694913.git.asml.silence@gmail.com>
References: <cover.1753694913.git.asml.silence@gmail.com>
Precedence: bulk
X-Mailing-List: io-uring@vger.kernel.org
List-Id: <io-uring.vger.kernel.org>
List-Subscribe: <mailto:io-uring+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:io-uring+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

From: Jakub Kicinski <kuba@kernel.org>

The driver tries to provision more agg buffers than header buffers
since multiple agg segments can reuse the same header. The calculation
/ heuristic tries to provide enough pages for 65k of data for each header
(or 4 frags per header if the result is too big). This calculation is
currently global to the adapter. If we increase the buffer sizes 8x
we don't want 8x the amount of memory sitting on the rings.
Luckily we don't have to fill the rings completely, adjust
the fill level dynamically in case particular queue has buffers
larger than the global size.

Signed-off-by: Jakub Kicinski <kuba@kernel.org>
Signed-off-by: Pavel Begunkov <asml.silence@gmail.com>
---
 drivers/net/ethernet/broadcom/bnxt/bnxt.c | 23 ++++++++++++++++++++---
 1 file changed, 20 insertions(+), 3 deletions(-)

diff --git a/drivers/net/ethernet/broadcom/bnxt/bnxt.c b/drivers/net/ethernet/broadcom/bnxt/bnxt.c
index 26fc275fb44b..017f08ca8d1d 100644
--- a/drivers/net/ethernet/broadcom/bnxt/bnxt.c
+++ b/drivers/net/ethernet/broadcom/bnxt/bnxt.c
@@ -3795,6 +3795,21 @@ static void bnxt_free_rx_rings(struct bnxt *bp)
 	}
 }
 
+static int bnxt_rx_agg_ring_fill_level(struct bnxt *bp,
+				       struct bnxt_rx_ring_info *rxr)
+{
+	/* User may have chosen larger than default rx_page_size,
+	 * we keep the ring sizes uniform and also want uniform amount
+	 * of bytes consumed per ring, so cap how much of the rings we fill.
+	 */
+	int fill_level = bp->rx_agg_ring_size;
+
+	if (rxr->rx_page_size > bp->rx_page_size)
+		fill_level /= rxr->rx_page_size / bp->rx_page_size;
+
+	return fill_level;
+}
+
 static int bnxt_alloc_rx_page_pool(struct bnxt *bp,
 				   struct bnxt_rx_ring_info *rxr,
 				   int numa_node)
@@ -3802,7 +3817,7 @@ static int bnxt_alloc_rx_page_pool(struct bnxt *bp,
 	struct page_pool_params pp = { 0 };
 	struct page_pool *pool;
 
-	pp.pool_size = bp->rx_agg_ring_size;
+	pp.pool_size = bnxt_rx_agg_ring_fill_level(bp, rxr);
 	if (BNXT_RX_PAGE_MODE(bp))
 		pp.pool_size += bp->rx_ring_size;
 	pp.order = get_order(rxr->rx_page_size);
@@ -4370,11 +4385,13 @@ static void bnxt_alloc_one_rx_ring_netmem(struct bnxt *bp,
 					  struct bnxt_rx_ring_info *rxr,
 					  int ring_nr)
 {
+	int fill_level, i;
 	u32 prod;
-	int i;
+
+	fill_level = bnxt_rx_agg_ring_fill_level(bp, rxr);
 
 	prod = rxr->rx_agg_prod;
-	for (i = 0; i < bp->rx_agg_ring_size; i++) {
+	for (i = 0; i < fill_level; i++) {
 		if (bnxt_alloc_rx_netmem(bp, rxr, prod, GFP_KERNEL)) {
 			netdev_warn(bp->dev, "init'ed rx ring %d with %d/%d pages only\n",
 				    ring_nr, i, bp->rx_ring_size);
-- 
2.49.0


