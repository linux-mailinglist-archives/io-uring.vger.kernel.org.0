Return-Path: <io-uring+bounces-11740-lists+io-uring=lfdr.de@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from sin.lore.kernel.org (sin.lore.kernel.org [IPv6:2600:3c15:e001:75::12fc:5321])
	by mail.lfdr.de (Postfix) with ESMTPS id E04DED26549
	for <lists+io-uring@lfdr.de>; Thu, 15 Jan 2026 18:23:21 +0100 (CET)
Received: from smtp.subspace.kernel.org (conduit.subspace.kernel.org [100.90.174.1])
	by sin.lore.kernel.org (Postfix) with ESMTP id 4C4A53070E0E
	for <lists+io-uring@lfdr.de>; Thu, 15 Jan 2026 17:13:31 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 669963C1997;
	Thu, 15 Jan 2026 17:12:39 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="Uh9CH+0P"
X-Original-To: io-uring@vger.kernel.org
Received: from mail-wm1-f52.google.com (mail-wm1-f52.google.com [209.85.128.52])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id DF9963C1967
	for <io-uring@vger.kernel.org>; Thu, 15 Jan 2026 17:12:36 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.128.52
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1768497159; cv=none; b=D6fx6oaJPYKaRKMCF/r26jjoiMgOLq5RsbCI+GzX5RQDVNcC+VGoI997UI5FqOlh672j3ZjqpaX85i4xP32R8aPibSArMEiGGdt1aduuyJnJzB90pKpILRUQc+rW04uoHVyVxJbC1OS58BSPmCH+sj7F7grefHvdVsLRbY6NjVs=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1768497159; c=relaxed/simple;
	bh=m8NMYH4g6lQKcDnWsulwGjwfrhYH+1zKunQ0vgAfNRI=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=dTZkFfnntb/aLlXwt11bLEDxcuYGSVQ7pxgGtXglPyK75KHZBicxHrIyihwuLP8vtPV2FWYz2ChcD0Fus5PasghOfZyJIomR6cc/o4PrKjrA8ccwL9HPmQyCxU6cxhIejguPIrFldq8GY5CwXASuSfWFLzSNty/Eja7a9yYpm4M=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=Uh9CH+0P; arc=none smtp.client-ip=209.85.128.52
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Received: by mail-wm1-f52.google.com with SMTP id 5b1f17b1804b1-47d1d8a49f5so7293525e9.3
        for <io-uring@vger.kernel.org>; Thu, 15 Jan 2026 09:12:36 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1768497155; x=1769101955; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=wz1yS4KnsLbiuKsdPkEkvSuKGyQ7NQwQMS3x7qa8DNs=;
        b=Uh9CH+0PtQFoy2xX4gBfxnddb1lL+DfYCnOwBWThGJGyKEhSKwlEOJD4+E9X0CnwSz
         pkLyHv82T0T+DMKi3nhFSclTexl9/CncwFV87UxsnoBcDzarZCMsreQzhQBEvZ3yJYXj
         LdZyv8Swohkgt1nr+PEYKOAut1ysA/XlKHcBC/nDWWksu+2qptZ+Ujf/6av7aIyJNtIK
         bw/doxp+F8kFjkCsakvon4Dut0+ACoS/Ca3/fBJsHyiWHvjIOmUSLQCHJqy/I/SEPL7b
         PFyb7EVK7oB5ApOBjDwZy/tsyfi2CJYhXUQaEeyIWCLt4vrZGrfZyqiA3G0a21Hj9TgT
         el3g==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1768497155; x=1769101955;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to;
        bh=wz1yS4KnsLbiuKsdPkEkvSuKGyQ7NQwQMS3x7qa8DNs=;
        b=WQ4isvVSuPAS2PFCpK/nsbCLnOjWp94BsZZLFICt0inO7kZ0dQyHxTrFk+33EH+VTK
         Itt3ctfXX7QXAAiMXm2AlXIG/acu61zRKxOuNSaQw7NuN8+ne1RH+V20Tnk6HJeEpCsK
         l41GVnkJ5qXLafcm7ljnS0e9Iww/Qr+6KfgaXsm+UkRb1oGYjpgBnqeB86I1qopjfRNW
         OxXSgZOMLt97Rbpal7HfyqNJempRYl9+7Kblh2Mkrb4Z5N8bdqe/W9x+9zz5lnTonhZH
         d+zsHJpRDt74op1gvJvvpbOb9df6DBWVRA/az6atsug7G67b5LCIN+7AWV1lytyRx/3I
         PNTA==
X-Forwarded-Encrypted: i=1; AJvYcCWORm4FGmTTeIpHmAjtECPKPR67GXhu9FTzYC53LTl25twjS1Hy8baj76S7T7OEtLNn6vrSAfJXxw==@vger.kernel.org
X-Gm-Message-State: AOJu0Yxq+oAhXgUAqNjJpQH46UQCHP3PH/pLyf+RZ1bV/Do3lYfHDgNB
	39M0c8wGy+OsK5v88T4XPrqLQKKEP/oectKpMm1v+z1Zw225ZlUjKhQj
X-Gm-Gg: AY/fxX7A0JoM9sKCraqs8ibDZNPjU45jzHr59Zq+w440S2EkyB8GWBtUrJq9w8xtDg8
	dVBaemr3OOVmHESeRAvEhnRt1TIbJgQKfNm6Q5K1CLAkTFYtZuZUiG8Abv+7avorx9Xzy+upD3M
	+gawXzhRNHRebCady94tMthv9oyghs8zcSLuW32JkmTBd2XQ22PWrapx+HdXe2y3Qc69ts8H9Fw
	6LP06rndwkQkenR+mtcOJscPPWy4iK4ICLQXtf4c0Wh6M0v6h5aRsxlY/3Ovl2XGohahuLc9WF0
	zg5cGVR0hCkgOH6fH0Ewf2cR40VpVfMce8S+++eWeqF60lLwXJjIk5YCAcujgSN0sJcrb6asqvl
	/zcUtOMM6P8hhzoe1wZpBm3SHVSRbq5cacP4Ham7rGUGvAG7JmENPNMWRId1gNFPiyT6DX4KP/R
	wMdq1z7gGwCCHo1z5Z5C1iaW7y4ww4z+g4NPhn2Tb0wxI1DuMEp6KYEIkDs0RTYDkQ10RuuKQlu
	bs8MXQWlFKIZZFuXw==
X-Received: by 2002:a05:600c:1c05:b0:47e:e952:86ca with SMTP id 5b1f17b1804b1-4801e2f28edmr6191145e9.2.1768497155155;
        Thu, 15 Jan 2026 09:12:35 -0800 (PST)
Received: from 127.mynet ([2a01:4b00:bd21:4f00:7cc6:d3ca:494:116c])
        by smtp.gmail.com with ESMTPSA id 5b1f17b1804b1-47f429071a2sm54741645e9.11.2026.01.15.09.12.33
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 15 Jan 2026 09:12:34 -0800 (PST)
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
	kernel-team@meta.com,
	io-uring@vger.kernel.org
Subject: [PATCH net-next v9 6/9] eth: bnxt: adjust the fill level of agg queues with larger buffers
Date: Thu, 15 Jan 2026 17:11:59 +0000
Message-ID: <c55bf90a2112d7a831d8427034b71ff9fbb78285.1768493907.git.asml.silence@gmail.com>
X-Mailer: git-send-email 2.52.0
In-Reply-To: <cover.1768493907.git.asml.silence@gmail.com>
References: <cover.1768493907.git.asml.silence@gmail.com>
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
[pavel: rebase on top of agg_size_fac]
Signed-off-by: Pavel Begunkov <asml.silence@gmail.com>
---
 drivers/net/ethernet/broadcom/bnxt/bnxt.c | 25 +++++++++++++++++++----
 1 file changed, 21 insertions(+), 4 deletions(-)

diff --git a/drivers/net/ethernet/broadcom/bnxt/bnxt.c b/drivers/net/ethernet/broadcom/bnxt/bnxt.c
index 196b972263bd..f011cf792abe 100644
--- a/drivers/net/ethernet/broadcom/bnxt/bnxt.c
+++ b/drivers/net/ethernet/broadcom/bnxt/bnxt.c
@@ -3825,16 +3825,31 @@ static void bnxt_free_rx_rings(struct bnxt *bp)
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
+	pp.pool_size = bnxt_rx_agg_ring_fill_level(bp, rxr) / agg_size_fac;
 	if (BNXT_RX_PAGE_MODE(bp))
 		pp.pool_size += bp->rx_ring_size / rx_size_fac;
 
@@ -4412,11 +4427,13 @@ static void bnxt_alloc_one_rx_ring_netmem(struct bnxt *bp,
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


