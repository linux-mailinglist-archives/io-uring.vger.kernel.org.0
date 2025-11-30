Return-Path: <io-uring+bounces-10865-lists+io-uring=lfdr.de@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [139.178.88.99])
	by mail.lfdr.de (Postfix) with ESMTPS id 2A98DC956C6
	for <lists+io-uring@lfdr.de>; Mon, 01 Dec 2025 00:38:14 +0100 (CET)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 02C5B3A2131
	for <lists+io-uring@lfdr.de>; Sun, 30 Nov 2025 23:37:02 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 867F9301707;
	Sun, 30 Nov 2025 23:35:45 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="VaXsnjVu"
X-Original-To: io-uring@vger.kernel.org
Received: from mail-wm1-f52.google.com (mail-wm1-f52.google.com [209.85.128.52])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4E940301460
	for <io-uring@vger.kernel.org>; Sun, 30 Nov 2025 23:35:43 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.128.52
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1764545745; cv=none; b=mJ10D8iq3NkQaPPo3Z8+n9HVMT2KhjAFwyfAR61YXMC8uznL1cMF7yTv5NNKsPsFbFffGjigvGCag+u6NWhDZ47st2TBFW2sd2VXNkxQ4o4JqVOBebgz2bKj9t4RjRYKJzv/Q65TKsBUVAQCLMZTGlN6U5LL3e0WJ1qJeXmSOrA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1764545745; c=relaxed/simple;
	bh=o4iyw2832atNMAZQImPFBGA5yCK+ZgPjuVFT1OuNVO4=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=oefGenBKtabUugelVkBO4VEO7gLuaI7Ly2aeErBjuukauBdEN4ORge2GjMrYZZkOx/OwkSy8I7hU3GoFkuV5a6NbWktqb2Jv5vO6smBKqBPMxi+Cy/KwGMsRtJAvFano7DhHMf7y58NysnGT/dUgQ7lV2p5mZPnNcCk7ZZjqEWI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=VaXsnjVu; arc=none smtp.client-ip=209.85.128.52
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Received: by mail-wm1-f52.google.com with SMTP id 5b1f17b1804b1-477a2ab455fso37851925e9.3
        for <io-uring@vger.kernel.org>; Sun, 30 Nov 2025 15:35:43 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1764545742; x=1765150542; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=WQMylrLW4Im9C3RrLyVskL4uzKLnQ4lYGDfbJ+ntA2k=;
        b=VaXsnjVufNs3gclDiScMqSFHNBjJVUDmV81FXsfFlmxopyAqW5eDl8ll1a/2R3De9B
         Rp4YRozymaxW3NV70+Gvvr2t6WdvDZlA8THrJ3tUp7Bc7JoK1xSGdUgUxbSZkxbtOBi2
         yIUdh5zzbIYcvfLhKgc6B+ltCaNIOsxUsyZhDibKKENqENs5EEOHjAfj0APfKj8Rw2HL
         zYbzTZg7CWmWsOKMBVkohX1FOVMhM2qeVDEz3GU2DYNkqjO9NdySbyDvpsb9yp0YnAKe
         eE9sDC0B02Q4cUSHHZnIoM+3YPVuupTYV30DeabL4z4b30epxpDoDfKKl5eYgID8dzdy
         yQKQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1764545742; x=1765150542;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to;
        bh=WQMylrLW4Im9C3RrLyVskL4uzKLnQ4lYGDfbJ+ntA2k=;
        b=io2f09XFQmZ2fjYHrTtbnuDJymWiRfXtg6fB7fUtJPMsIAc58rOzYsJ9ADxxOX3lvA
         kRa5sPlxdvn5pOyqv7cFUh/AJozwq8bcfiRMAQp7D3w2aQ4JbfsAY2KuLIt9dtQuvlxe
         mIHznUsu37bjViPqK9K8AMBiOMnqgKg2zQz4XKIjxKFnGCsV9VmWSTI129AZqmg2w3Il
         x92OVo2fpOGwTCPtRCntjOVnZWKOwplJRXQdwv+TyoxPGyKAGvTzq5mSfwxezQGrRSOg
         Y08rEYUNXK7J/DYgDClfMSWLT4ztmjKUHWVKSTSQkkFcU0oel2DvQ5uOOgHHva5vTmEu
         C/WQ==
X-Forwarded-Encrypted: i=1; AJvYcCXnj532/MiBD9YybmdahnCW7JLKqJix3mgFRgAKBNcncGbm3IIH8MZtHwIxpUg+SrMYtw1OkFV+aA==@vger.kernel.org
X-Gm-Message-State: AOJu0Yys40T7GBoIFIfMC5P0c/uhd4PAJY0e1rahmvZ8IGKPQRKYhhw0
	Dsv3avDFDvmjM3LO5y6juX66+iq72eF0Cn5tE2Q6qF3CCulK//Tw2j4t
X-Gm-Gg: ASbGnctQhTZi0VQjBWoTRcAr/Zg0l1i2H9iMfg5bObuGx6OKhDQKKK2esH43lcmKDHl
	FjY5+P93JCB2CYvnZ83e/lSdcBbX1dXaYU0X50I7nISz6J93QWVu4ChSroMW2Dy7jRA+L8QvZjE
	+gj5I4sBXaSuB8Xn6nwFW4Hckc+r639uK6tpu976Kn+k3OXUQWdpYNHSsk8MsZD4x2zolVGctTB
	ZwDYg9qN0+bcRaJWDdExrIjKsuHAZ46VQXuQOsT0jPdHkqOSTdGPK0A1zF9Sda5d4G/xpoudklb
	lz0xWLqLjpQXnH9U0EYzt3jxsrbdzosP2uGU+t2RKpzk1PY7CfWayZMCFfba3RjsU3XUnnFMfvn
	EbZVkit0yFQ0ExEfo+XtSRwZsFeaAIbUiY4qf/+BCUIYnbGIlh5+SV9y93QgvC4SJQifa3GblCO
	zkTfrzC4akAeYovt4nWDfm/XefMyxHwFHBhuAqNFeMPwX/+H/teF+qAX8KWZEpM7kp3RaAFa04B
	ZzaovsCOyvi4fth
X-Google-Smtp-Source: AGHT+IFRNy69yAJEtLTkHqjePuEbcPuedCzCBZDYARz00zxMJbUrkfp5Acqq1qnoxF/x8wIlVCZ83w==
X-Received: by 2002:a05:600c:1c29:b0:477:639d:bca2 with SMTP id 5b1f17b1804b1-477c10c85e2mr406364115e9.4.1764545741617;
        Sun, 30 Nov 2025 15:35:41 -0800 (PST)
Received: from 127.mynet ([2a01:4b00:bd21:4f00:7cc6:d3ca:494:116c])
        by smtp.gmail.com with ESMTPSA id 5b1f17b1804b1-479040b3092sm142722075e9.1.2025.11.30.15.35.39
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sun, 30 Nov 2025 15:35:39 -0800 (PST)
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
Subject: [PATCH net-next v7 6/9] eth: bnxt: adjust the fill level of agg queues with larger buffers
Date: Sun, 30 Nov 2025 23:35:21 +0000
Message-ID: <df309468ba5127fc91dc4fcba9056fab826812bf.1764542851.git.asml.silence@gmail.com>
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
index f4c2ec243e9a..e9840165c7d0 100644
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


