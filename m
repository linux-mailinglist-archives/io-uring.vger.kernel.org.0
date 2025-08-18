Return-Path: <io-uring+bounces-9032-lists+io-uring=lfdr.de@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [IPv6:2604:1380:45e3:2400::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 908CBB2A954
	for <lists+io-uring@lfdr.de>; Mon, 18 Aug 2025 16:18:41 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id A5C6A62635E
	for <lists+io-uring@lfdr.de>; Mon, 18 Aug 2025 14:02:39 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id C4098342C8E;
	Mon, 18 Aug 2025 13:57:05 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="edzym3n6"
X-Original-To: io-uring@vger.kernel.org
Received: from mail-wm1-f41.google.com (mail-wm1-f41.google.com [209.85.128.41])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id EFC30340DA9;
	Mon, 18 Aug 2025 13:57:03 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.128.41
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1755525425; cv=none; b=PGYWS7eD4aey+Mgqqmmrbw+Qh2sxWNaIuEMZBTEegpYR3JsUSXmt9eZY6G8mrFq0bbdudG/kn87gQERCspXpd8X2NhRWJTn0ZJUf8uYXfIMI3ru8DMujtKXW843TR9WtTXP4fbFqw7wlhCB7IDyl6MMrBPB0JuA7cg2EcejbeGw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1755525425; c=relaxed/simple;
	bh=rc0YQ0x0wrZ7moGxHCzFDGmosQdHLH5aAifxKJ71OdI=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=jhuSG2vKsdGJMA0ZPaBneKD3NpGHmuInnPcacY6gx5nGZcM9voR+P1+ci9+vXSxJLtP9Iuwl+nQSclVSWf0NEmGpL3kNr1heDEczVZ+8nhOMJvfUxnzoDzUZ4xLqeuzdWwQKm0ecowhos9YWvMLNyQGuCSmV58r9WSNQrvXg6Sg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=edzym3n6; arc=none smtp.client-ip=209.85.128.41
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Received: by mail-wm1-f41.google.com with SMTP id 5b1f17b1804b1-45a1b05a49cso30147945e9.1;
        Mon, 18 Aug 2025 06:57:03 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1755525422; x=1756130222; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=iyCEFBKqEjH0pemMHaxucZCjRqMSn8Hg4d1cOb7O5ag=;
        b=edzym3n63i43paiTYhxHTbvLfEkGjVmmNBhM/ATA6znUD8Y6d5uV4ZS/IKl25BLoww
         SkQoGFiTPxWLrqND0b9TtWiQpZMk+M89qSCu2tkCyCrBqgj3liskCIsYe1yZzka6kQXZ
         yH9EQt7aCf6LrmANWqh3KSzF4X+XzIXTJ67EgET7H6FnQGhZoOrQp62dVTMmIvqluzga
         ueTP6lgGBIB8+kXEvrubcFU4Nx3RIzQS4SwN4WDjQ79XBLkzhjsldHCROWaS4kTgvvQs
         GfN+nP2cWCdU4v+ATQkoLVzhWVZq3qK011gKM5Qj1aozc3/PoLmf6RIbJrxpWpFv9eSg
         KM+A==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1755525422; x=1756130222;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=iyCEFBKqEjH0pemMHaxucZCjRqMSn8Hg4d1cOb7O5ag=;
        b=IN51Kyq5yyl+UoXn2XLYGe2a7+gXScB7QqFhxUef7Vla+8Rwt4HBXgL9DndBq/xG9J
         x/FSNCVvbt4nKKmBa+yonX+QJFvtvE2Lg3br561DcaYIHAx/6BCkL5WPel7ASiSnDzZQ
         Qgi13oHwzXj5shpLGn9qk1Vw70QPgCgphrNa3aO8dT+M7A/2moqIM0ZJin5J2Fy+d/Fn
         3OBGGZdc2b/HcKLT3OvODIzj53btkTdvb+6Djxly6HpOXN4MOormF9XZxUGvJb+XLMdb
         UjacTe+w6Q9ZlxHP9uVuQq3cYMTqxCrenhrwpnz9dgOLeyBbm/4MEwtUUrBwTPkjmkyc
         ho1A==
X-Forwarded-Encrypted: i=1; AJvYcCWyXkr26R1eX4g7ybCQlaYRV+g0y8XajPug5YriC9cgC1ggPzE/W0Hc5z50Xxu8xXVaVZpzk84l0E9lA26f@vger.kernel.org, AJvYcCXQs4bvIkqUcDaxKy7TORWtP87e61l0yDQhGKawFVJryMt89K7bw9qhFlFmsrz+yBmjvh32xHXy@vger.kernel.org, AJvYcCXiBfGJmoh63+2xJKjgWGJ9yVlIJOl4OmU4nZ0SeIc/7Q49GmLvb2d7bLPS0Vf7AEsDdBf0+007DQ==@vger.kernel.org
X-Gm-Message-State: AOJu0Yy2V0zs5lXgMo+0yhWM2IYQV7ZwKGjYgTW1DYO/04nuZiVp0zil
	+1UOU9pVp5zrFY7F9XmTfub3++LVwzX5zy6rkZJGFc6l8s9lH+aOBgRR
X-Gm-Gg: ASbGnctfq/BNQdBD1Cr5tAeIf/7LIoZV7JVjWCnEdfy+W4BmG0Xl+37p8JfglbHhyRN
	uJlDrSVzWs8JEF5txLnyccbsA18wBoga2I9oKdOTckZra8mVZrZW87E1oFp95EYDyQh1+3lERpA
	ZQ3olRQnGyTO3atuW1hHWbnsWY70UWBrAWyQquywm1xmtOsT9paLfnFxIFxcWbpz5Wv9a6G8GQQ
	YNx/W0BWjvn5aOv3PrK/PjoSWIciH6RY8mZQRYKc4MghXF1a1zVneUsH5Qtn5FqZZxb1bmOsoZB
	04mCw2aahRyljXohHBX+kX0dl5xXsd49h+2ELHqBEc5uZPh75NAHPshmby/HuluzZxv7sC1BYv/
	MsrjK2JYOOFLdzNUZqpDxrY0ZxavUOELasaZJETdB7jVV
X-Google-Smtp-Source: AGHT+IGLLkv16swk4fx9aCVvfU1SOUGYfOcKy/YNUc2y0tepDLomC4H05wxHLBOQJ8YxMzryQZamog==
X-Received: by 2002:a05:600c:1389:b0:441:b698:3431 with SMTP id 5b1f17b1804b1-45a2185e6d6mr70529725e9.28.1755525422015;
        Mon, 18 Aug 2025 06:57:02 -0700 (PDT)
Received: from 127.0.0.1localhost ([185.69.144.43])
        by smtp.gmail.com with ESMTPSA id 5b1f17b1804b1-45a1b899338sm91187345e9.7.2025.08.18.06.57.00
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 18 Aug 2025 06:57:01 -0700 (PDT)
From: Pavel Begunkov <asml.silence@gmail.com>
To: Jakub Kicinski <kuba@kernel.org>,
	netdev@vger.kernel.org
Cc: asml.silence@gmail.com,
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
	ap420073@gmail.com,
	linux-kernel@vger.kernel.org,
	io-uring@vger.kernel.org
Subject: [PATCH net-next v3 17/23] eth: bnxt: adjust the fill level of agg queues with larger buffers
Date: Mon, 18 Aug 2025 14:57:33 +0100
Message-ID: <311f2a7b63a9ca20b0d0944657828093d05a5116.1755499376.git.asml.silence@gmail.com>
X-Mailer: git-send-email 2.49.0
In-Reply-To: <cover.1755499375.git.asml.silence@gmail.com>
References: <cover.1755499375.git.asml.silence@gmail.com>
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
index 50f663777843..b47b95631a33 100644
--- a/drivers/net/ethernet/broadcom/bnxt/bnxt.c
+++ b/drivers/net/ethernet/broadcom/bnxt/bnxt.c
@@ -3811,16 +3811,34 @@ static void bnxt_free_rx_rings(struct bnxt *bp)
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
 
@@ -4396,11 +4414,13 @@ static void bnxt_alloc_one_rx_ring_netmem(struct bnxt *bp,
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


