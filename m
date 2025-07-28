Return-Path: <io-uring+bounces-8831-lists+io-uring=lfdr.de@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [IPv6:2604:1380:45e3:2400::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 8A4B9B1399B
	for <lists+io-uring@lfdr.de>; Mon, 28 Jul 2025 13:06:38 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 165853BE71E
	for <lists+io-uring@lfdr.de>; Mon, 28 Jul 2025 11:04:58 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 932DC255F5C;
	Mon, 28 Jul 2025 11:03:45 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="jRGsoSPF"
X-Original-To: io-uring@vger.kernel.org
Received: from mail-wm1-f46.google.com (mail-wm1-f46.google.com [209.85.128.46])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C5202264638;
	Mon, 28 Jul 2025 11:03:43 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.128.46
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1753700625; cv=none; b=JXJzd0VOSzswimx/Zj6avUqru2+FivDGT9n3Lv00+pJPFPd9i7Xnsu7y8MFeDcaI9lIkTRYgjYHx/HZPSnOzOPKO7G0D/8VsmzgEQnDNNZ5Mf6S89P8z26O3pRgHUc8G14kskWmFninTThygvnTWOz5ViAz5wxqZTT6WWOF/ryE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1753700625; c=relaxed/simple;
	bh=FEdheWXb5F9Nq/IjgejTsKYNllrzR9JaziuBslWivhI=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=ITZt+G1gteBvMA1DOL6QTeLzuw/f6PW7ZMRWpdlvh6k8yQ5Mu5SMxUx2rN8gWWiNpUjve1X1X7arzr2Y7ZFNhOOxaOch8i5MVyo4tZdAHSYgpvhO61k3mbyoObnnZJDNbfE7VpVzcZ/TK3O6bWcug8yaGnGgOYGwBNUNNFs15OM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=jRGsoSPF; arc=none smtp.client-ip=209.85.128.46
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Received: by mail-wm1-f46.google.com with SMTP id 5b1f17b1804b1-4561ca74829so45586895e9.0;
        Mon, 28 Jul 2025 04:03:43 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1753700622; x=1754305422; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=haXT2XWtKDi8P4ng1er3yz9HPA21iNN79GCxNp3aw0M=;
        b=jRGsoSPFxvM6oDpdqkXYvmaqW3VcnDtdquXLUkZncixikSXGW4tXYYQoW573Mj3EyQ
         m2u2nSIbRZ/58MGWWnMr/konMUdgGY6KvAKn2J77XJCKpWdZXpAdAXblvO81kQk1WZVj
         eHOf+kOY1rxbe9ZbRfdKP1mCuGuE0+OuUAOzEMqExyCm/B1LWJ3Dt1fMx4PwVGw1fWoH
         cdAhrpy4sGctgIikQesPA/JAsgCzUtkFD9HpoXhkHaLBi+nl1Ws0JPe4MbrmrL0KvjVH
         OWEPGBr3mAOyvh9U//xqM6LC0OIHgJLyL+K6m5VnGFDbnCDBNZjCtZv5lxsorD/Qj6Yy
         tvYA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1753700622; x=1754305422;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=haXT2XWtKDi8P4ng1er3yz9HPA21iNN79GCxNp3aw0M=;
        b=N3OwJ0kEBQ/8IUrUEkS9kcpjahu3HKfXnhEFetm+B2t1Y6YRUpeCKa91hSH4+sjpkc
         10xTrMBlyB34TRmVgqqblsNz+pyprGeQicLP1bKLADR0JctHR7ymymY76DmCYyyQ/nE4
         zTQKb/8ZBQf/Hj7d+ID1pqu1QINv+Yqv5abKsT5+u3LOLiJoD7RFTaf9cwNkKbYxmQvt
         tyfAyjKm96cAN4GE4p+JxLgUbEq8F9aR1GOyfoZRJDURLWrtu9R19MhaTQm8zuKMlkV5
         NJOemTd+VohVSrm5akmNOWqTLDmj2lJC7NaOIowgh6feezhfJ7NHcXEPhFfHxzInVbDY
         C+jQ==
X-Forwarded-Encrypted: i=1; AJvYcCUcWYP26Qyi0qTE6Ol/kxXwwv3jawU8t/nwYnQwJrXkrWZe/jJy9rx2FKFxxSd4YXOVIcLy6Qyk@vger.kernel.org, AJvYcCV4bkYsRLlT1e2rCEMsEiW7gyEpOWfttP73oPQQTfxNuYvupgOVxBOdXeNTO9EkLUDoid3Ijda9Ag==@vger.kernel.org
X-Gm-Message-State: AOJu0YxBRUkYciEckY/RN826tV7pCCFFX74OWP2f+mf+N2doegJQlV7n
	fTNzm38C3Lr1O9Ztg5qhPEYcEupl6E1hDlVZfoam4wNVXomX85TUKMGGt92QZw==
X-Gm-Gg: ASbGnctu4dBUgYtSbaEs/4G9dyDq3qXfelP9kZSRHL6lECD18KDKC7229TLpPXhue+R
	jkPO+3Bm+crWg/3P/PeoPN5R9uqjAfweuxh5OvHsZ/IEbFdV0GFTaqXdcpqr2ELnmxVFK+W0JZs
	5OzlMcJW41/up/vmAAJSiik8c8N3O1QtCvRyabadQnDUkAg1ZMNkqORgMw96Z+W9g5m70o/kpy5
	8VXAAFp6KIicyJS67HdG07TzgUgHn4dVNAtUSiHA0ajOZXKGVutjLtep6qP9HmfQaOtWSdlIIAu
	LEYiQJuWMpyrL5xMH4ATICpKYXeIRWrwzvoCGRfF0sYm0kYUSy/giutx+KjG7crN08eqBvEzjVv
	QsZMZK80ib/Co9g==
X-Google-Smtp-Source: AGHT+IGum3+QoeVIzz9H5lbCrHBl0db70mEHZMSVP0l3gwyOLa6Pr9iCNdYRhL3A+1Ugn5R/KseIOg==
X-Received: by 2002:a05:600c:8b66:b0:43c:fcbc:9680 with SMTP id 5b1f17b1804b1-45876652621mr84215905e9.25.1753700621675;
        Mon, 28 Jul 2025 04:03:41 -0700 (PDT)
Received: from 127.com ([2620:10d:c092:600::1:75])
        by smtp.gmail.com with ESMTPSA id 5b1f17b1804b1-458705c4fdasm157410235e9.28.2025.07.28.04.03.40
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 28 Jul 2025 04:03:40 -0700 (PDT)
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
Subject: [RFC v1 20/22] eth: bnxt: support per queue configuration of rx-buf-len
Date: Mon, 28 Jul 2025 12:04:24 +0100
Message-ID: <d9228d871dd4429e4bb0b829222229f47b024195.1753694914.git.asml.silence@gmail.com>
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

Now that the rx_buf_len is stored and validated per queue allow
it being set differently for different queues. Instead of copying
the device setting for each queue ask the core for the config
via netdev_queue_config().

Signed-off-by: Jakub Kicinski <kuba@kernel.org>
Signed-off-by: Pavel Begunkov <asml.silence@gmail.com>
---
 drivers/net/ethernet/broadcom/bnxt/bnxt.c | 8 +++++++-
 1 file changed, 7 insertions(+), 1 deletion(-)

diff --git a/drivers/net/ethernet/broadcom/bnxt/bnxt.c b/drivers/net/ethernet/broadcom/bnxt/bnxt.c
index 5788518fe407..8d2cae59c4d5 100644
--- a/drivers/net/ethernet/broadcom/bnxt/bnxt.c
+++ b/drivers/net/ethernet/broadcom/bnxt/bnxt.c
@@ -4284,6 +4284,7 @@ static void bnxt_init_ring_struct(struct bnxt *bp)
 
 	for (i = 0; i < bp->cp_nr_rings; i++) {
 		struct bnxt_napi *bnapi = bp->bnapi[i];
+		struct netdev_queue_config qcfg;
 		struct bnxt_ring_mem_info *rmem;
 		struct bnxt_cp_ring_info *cpr;
 		struct bnxt_rx_ring_info *rxr;
@@ -4306,7 +4307,8 @@ static void bnxt_init_ring_struct(struct bnxt *bp)
 		if (!rxr)
 			goto skip_rx;
 
-		rxr->rx_page_size = bp->rx_page_size;
+		netdev_queue_config(bp->dev, i,	&qcfg);
+		rxr->rx_page_size = qcfg.rx_buf_len;
 
 		ring = &rxr->rx_ring_struct;
 		rmem = &ring->ring_mem;
@@ -15863,6 +15865,7 @@ static int bnxt_queue_mem_alloc(struct net_device *dev,
 	clone->rx_agg_prod = 0;
 	clone->rx_sw_agg_prod = 0;
 	clone->rx_next_cons = 0;
+	clone->rx_page_size = qcfg->rx_buf_len;
 	clone->need_head_pool = false;
 
 	rc = bnxt_alloc_rx_page_pool(bp, clone, rxr->page_pool->p.nid);
@@ -15969,6 +15972,8 @@ static void bnxt_copy_rx_ring(struct bnxt *bp,
 	src_ring = &src->rx_ring_struct;
 	src_rmem = &src_ring->ring_mem;
 
+	dst->rx_page_size = src->rx_page_size;
+
 	WARN_ON(dst_rmem->nr_pages != src_rmem->nr_pages);
 	WARN_ON(dst_rmem->page_size != src_rmem->page_size);
 	WARN_ON(dst_rmem->flags != src_rmem->flags);
@@ -16175,6 +16180,7 @@ bnxt_queue_cfg_defaults(struct net_device *dev, int idx,
 }
 
 static const struct netdev_queue_mgmt_ops bnxt_queue_mgmt_ops = {
+	.supported_ring_params	= ETHTOOL_RING_USE_RX_BUF_LEN,
 	.ndo_queue_mem_size	= sizeof(struct bnxt_rx_ring_info),
 
 	.ndo_queue_cfg_defaults	= bnxt_queue_cfg_defaults,
-- 
2.49.0


