Return-Path: <io-uring+bounces-10829-lists+io-uring=lfdr.de@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [139.178.88.99])
	by mail.lfdr.de (Postfix) with ESMTPS id F22CEC90267
	for <lists+io-uring@lfdr.de>; Thu, 27 Nov 2025 21:45:32 +0100 (CET)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 934513AA35F
	for <lists+io-uring@lfdr.de>; Thu, 27 Nov 2025 20:45:31 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id B873C31DD97;
	Thu, 27 Nov 2025 20:44:40 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="Z9ym8mhZ"
X-Original-To: io-uring@vger.kernel.org
Received: from mail-wr1-f42.google.com (mail-wr1-f42.google.com [209.85.221.42])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B025431AF1A
	for <io-uring@vger.kernel.org>; Thu, 27 Nov 2025 20:44:37 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.221.42
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1764276280; cv=none; b=SK6D2pW2TifK6wkIqW3M5ZzfFbwsBsHiP7gRmp29YKKIXIJEnWm7BoDGy6t0IrxCFoTx775TBpJwi2pzyJazSkfM1QstsYfwcseUrHhvaYtG/UkF0u3jAcORxQKoy8RK/JE9dQ5sa9JYnrdjnd2x6kBwyzvlQOUppPw199JsyEY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1764276280; c=relaxed/simple;
	bh=s+ujYG85N1S/vvBzu10d4al31eQMM3yatlYRBU38WTA=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=hZJqLgskv4x4NV9m9xFopezKzNIkAwmU16JoLQrRG/l3ZMT4JPM7Wu4qGnkBrr+TKR8mvBFV2GEHdqF1dFLE5Ict+jQiqct0Ck1WjOUEqxXNdztC05ZoMrc5RNS3GLGydDpXZmzNDGPx18xsPUrNfHnn7gEvmb6bky3LPCn5fBc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=Z9ym8mhZ; arc=none smtp.client-ip=209.85.221.42
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Received: by mail-wr1-f42.google.com with SMTP id ffacd0b85a97d-42b3c965df5so742517f8f.1
        for <io-uring@vger.kernel.org>; Thu, 27 Nov 2025 12:44:37 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1764276276; x=1764881076; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=B5qoAELZ8wHHvykz/cZa6mBE+envmBXhX8Q5+VASiMI=;
        b=Z9ym8mhZDrOtMBje+/v2PKWH6O/lnU7rf2xVi5fiXPfMmmfyZOrc8poi+q1e6gj7tD
         MFVCxhvKDhJ56HjohOJjC3BcL4E6lYhWLyuf4VR58MbEAt7Z+R9fOBt7pGeu/UDSq5NI
         +kA7TBVZDbAPBbA7Mi0CKg6lRut47DB13iGcP9RjM/AppTFvBuIhY+UTp2boOg9QM8dM
         YMZh0SiJxpIBXbdVc/PRhXSiPV4YnwyOb3AXmbOIIKizS9guIWLGNRztJmeZcURukkLS
         M6gKEC6GirjPJou50RXjwpEAdJ8HDfUZ/VxyMgVRlKJrIbPgnVFxVKgaCYi7HuCiMxwM
         ROtg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1764276276; x=1764881076;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to;
        bh=B5qoAELZ8wHHvykz/cZa6mBE+envmBXhX8Q5+VASiMI=;
        b=dKcoCxjlYRb/J1Nu1UUqu92+oiu0KWNUtZqNdDd3cqNqRWtJSm+Do9c9R91/0uNxh3
         vfB/KS+nb8dwRJAaGV98Nc5PA8z6wrscWst17rhZPMST1BbWIfTuPYasPCH+13pFdcb5
         jjvWYcLO+R6A/ZwXkWYSf1yMp+5QIeQKkp0PEE93mDi0wWZBD0IVu4xEvdPyAPR5OBUu
         kKm3A9gDhcLFBemZleoojx7AYfHbYtlTKdy0E2fehA0p3BOIVIqM6kEmiWEjajoU6A6m
         4RZoFGcwsGMzqiTWuqutTfem5wm8mzgYwFX601Hbqt2CMWA/IdOoN+Q8TVfiLherLYwY
         ugFA==
X-Forwarded-Encrypted: i=1; AJvYcCVuwJUboJdIh5Bb9Gw6Qlj8PyS2Mg6FRr1YFO789rI/yZSnr2hDAelXob2mpFBmoBvvZIo26c4YqA==@vger.kernel.org
X-Gm-Message-State: AOJu0YzejgV07vXMTBVtd4BiMkdMsUDkXaH1ka5PKTAMJJDYz3PhEIX8
	+xlduUuiYg1oZG4Jmbf23e8GNiOHjgteMdNNdnWY1eyCXMbjp8JjumNf
X-Gm-Gg: ASbGncvmfLA2OK/Xz+a2fBQtGiwnDE3BNRO3C9bZLVhNk3TaBDSieVBGUzl2UbR/XAO
	9uYLECuGb+fnY4sUwXm/EcRtfOFBYiSQwNRICytzHo6vngSLPj9UxvquIsrCnZJzNIBQCvKl7G6
	VWtYpgFaMZXH+KbyXBPhuV7+DuTRX/CctSM0GS0UHT/wcXBE/akQVILiuMycbRkv/wLME0k0dTz
	8WX4dkcYmTtyNW+AJo3qy/V7wstVBf1jy3JxBiPL8TS/5wWIYrs1PF5Z8vMuKJn+Umrkeiq5vzf
	MhD0m7ZLny0bU9n5JW8lsyhC5fCekuQn+1w8mWvzz7etP3cI9+VoZ51MXsWmmcfnyUBGvjHGEZp
	W/RLPgFUTHG8WAXup3f4Si7UtbnIhMT0Oh/mIdqEmICGfFPC19WKr3bLhPgybnzpin7vWbmvn1z
	c5wF1JkaVGeL9qIA==
X-Google-Smtp-Source: AGHT+IEyaVmnfDxtl2rFThdCbalOVXR3AbBBiusuPnSeb0Ao82EGUMzRsDZmj1oPm2zoagTXUFdGmQ==
X-Received: by 2002:a05:6000:1862:b0:42b:3ee9:4771 with SMTP id ffacd0b85a97d-42e0f22a21dmr13385644f8f.23.1764276275904;
        Thu, 27 Nov 2025 12:44:35 -0800 (PST)
Received: from 127.mynet ([2a01:4b00:bd21:4f00:7cc6:d3ca:494:116c])
        by smtp.gmail.com with ESMTPSA id ffacd0b85a97d-42e1c5d614asm5346105f8f.12.2025.11.27.12.44.34
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 27 Nov 2025 12:44:34 -0800 (PST)
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
Subject: [PATCH net-next v6 5/8] eth: bnxt: adjust the fill level of agg queues with larger buffers
Date: Thu, 27 Nov 2025 20:44:18 +0000
Message-ID: <b45c38df1fb514fea82d0080ff6105024f8738cf.1764264798.git.asml.silence@gmail.com>
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
[pavel: rebase on top of agg_size_fac, assert agg_size_fac]
Signed-off-by: Pavel Begunkov <asml.silence@gmail.com>
---
 drivers/net/ethernet/broadcom/bnxt/bnxt.c | 28 +++++++++++++++++++----
 1 file changed, 24 insertions(+), 4 deletions(-)

diff --git a/drivers/net/ethernet/broadcom/bnxt/bnxt.c b/drivers/net/ethernet/broadcom/bnxt/bnxt.c
index 091da26fdf7c..fc88566779a4 100644
--- a/drivers/net/ethernet/broadcom/bnxt/bnxt.c
+++ b/drivers/net/ethernet/broadcom/bnxt/bnxt.c
@@ -3816,16 +3816,34 @@ static void bnxt_free_rx_rings(struct bnxt *bp)
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
+	if (rxr->rx_page_size > BNXT_RX_PAGE_SIZE)
+		fill_level /= rxr->rx_page_size / BNXT_RX_PAGE_SIZE;
+
+	return fill_level;
+}
+
 static int bnxt_alloc_rx_page_pool(struct bnxt *bp,
 				   struct bnxt_rx_ring_info *rxr,
 				   int numa_node)
 {
-	const unsigned int agg_size_fac = PAGE_SIZE / BNXT_RX_PAGE_SIZE;
+	unsigned int agg_size_fac = rxr->rx_page_size / BNXT_RX_PAGE_SIZE;
 	const unsigned int rx_size_fac = PAGE_SIZE / SZ_4K;
 	struct page_pool_params pp = { 0 };
 	struct page_pool *pool;
 
-	pp.pool_size = bp->rx_agg_ring_size / agg_size_fac;
+	if (WARN_ON_ONCE(agg_size_fac == 0))
+		agg_size_fac = 1;
+
+	pp.pool_size = bnxt_rx_agg_ring_fill_level(bp, rxr) / agg_size_fac;
 	if (BNXT_RX_PAGE_MODE(bp))
 		pp.pool_size += bp->rx_ring_size / rx_size_fac;
 
@@ -4403,11 +4421,13 @@ static void bnxt_alloc_one_rx_ring_netmem(struct bnxt *bp,
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
 				    ring_nr, i, bp->rx_agg_ring_size);
-- 
2.52.0


