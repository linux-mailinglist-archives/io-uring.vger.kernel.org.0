Return-Path: <io-uring+bounces-9036-lists+io-uring=lfdr.de@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [139.178.88.99])
	by mail.lfdr.de (Postfix) with ESMTPS id 47AE8B2A939
	for <lists+io-uring@lfdr.de>; Mon, 18 Aug 2025 16:17:25 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id AA513684393
	for <lists+io-uring@lfdr.de>; Mon, 18 Aug 2025 14:04:11 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 90FCD345750;
	Mon, 18 Aug 2025 13:57:13 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="Oxv5MXoK"
X-Original-To: io-uring@vger.kernel.org
Received: from mail-wm1-f48.google.com (mail-wm1-f48.google.com [209.85.128.48])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id CBA1234572A;
	Mon, 18 Aug 2025 13:57:11 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.128.48
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1755525433; cv=none; b=On/5+jUnbfmyAVjicxTSGOmZ2/9PDfbdIycuFpfn9HXOVE+ktMET5SeO47oVJQ8w3z1BpRI9dPplx4+ARK4/WoER1NtphfwXEgXZAV1VuVjh9jquoIqSsHbpy7YUrGbD6fc3zYsLSwAkJ4P+4rOJoBPfkSvYwYAmTvHDmMzV9DM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1755525433; c=relaxed/simple;
	bh=g+U/dDRMJlpuZ+vOqxuN3mbpStlCbyAdnbyJxluqbQo=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=Zh/K/r3FynS5bFlFa0aEFW4agDdvFOjvx7mX2yrCwCrX2xJonsMxe7dhS6OYy8nzAZfJ2t/itPk/UHHVGaof+PdlZrFabgnZ/Vo4MKPaXQawlpV5GxrDLWztVOWb2BZYPa47AHOomWj0AY4DLi4+IR4i6q4BGRvW/mPvuKvFVEI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=Oxv5MXoK; arc=none smtp.client-ip=209.85.128.48
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Received: by mail-wm1-f48.google.com with SMTP id 5b1f17b1804b1-45a1b0cbbbaso28794975e9.3;
        Mon, 18 Aug 2025 06:57:11 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1755525430; x=1756130230; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=MakgO4vr4JjhkQ2lJFO6co8+2+DfEo312cNgG79Z1GI=;
        b=Oxv5MXoKrUEpdgzn5rXp2dPc4kY9eK+f/0qXRTqYy9obj8WiuW5mpKDYANA5n7y3yb
         WMlFyJaY5VighVUfSy5eDXCRnACBKAHgjQ1lfdPcPOUZ3vNODxKGSYVtJsGIDC3s/UzO
         5jhI9O6kMcLHROvncfenY1i2GI6RZ4xNwpc5QYp7on039wEEhn3IkuwA4vhWs5rDEIp4
         YqEyTnu4OPcnBGgF2NBvup/36v6CE2BKT2laVDc70UwnLhZC+R9ymiMY2by85ApUBs4J
         oZcZ6ehzoHDvAVAnI6TiZaAIdIPNoPzuIRms7GDaE2GlYSAV5Pk9R/HzQhHFLFuhbvq7
         BJfA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1755525430; x=1756130230;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=MakgO4vr4JjhkQ2lJFO6co8+2+DfEo312cNgG79Z1GI=;
        b=kFMM5uIiTZzrub7aXfEiZ68q3KfT6VCG4ijsiM5JoMpHKEpaj6rZmuMCAcCnU19bSC
         9/3jxUlwBLnEZTmQNafwpw8svpjrAOOG5s2yipS++G4QfvGOaYphGcw72FxgwGecQOXK
         zO/sbA3nYt/vForZ+U/nXPK//Wl7xPBAMJ6qEhpTVdfJ5N3BU7uv2YM8ElJi/GPlUpo0
         KVDlMj4jzlEZKic8YgtkkhH93crQmVdBsECMatrIQSZxWEJRUuf4KbpeNu9Pl/WwJACn
         xRqmn1pdju4LEwBhzmYb6A/zFU/qk6caGF6VERbyz2m6I8OU8CSaN7kafzDyHTjix8H/
         9LZA==
X-Forwarded-Encrypted: i=1; AJvYcCUQCbw68+KDFDuniNmMnienR9vd3qbQ09mhJUtC+lDznN+trcRjT92v2Wj1AFt7cwP4JjvGru+tSQ==@vger.kernel.org, AJvYcCVWyeGRidosj8q1gRxsQoaLjFmXVUw3WHuJKCBllVNCCDiwgITi4MLceULSaA6++xEoFy8XHUeWZx5uX/s6@vger.kernel.org, AJvYcCWgZBOfKhVpnK7uEq06nE4C36yoUesFJEr/AmkDZsdzb0FB/L2qMxCj8GxW7pHCRKJALEWQiJir@vger.kernel.org
X-Gm-Message-State: AOJu0Yxb+B8Sx/12cOf1KOc3/bSzVNVjbw2X1svK09X4zPlyztvWFvY3
	jGin+uL0Z4AJeWsxhZfYomWjQZ0w5W5r/yT6lHDWT+eZszGvL+MedJTC
X-Gm-Gg: ASbGnctRSB9FZd5/WnslqKUfsbilclei6dIj+LM3qJdGpJ5Hb7ZW8fj13R/4qvYDUJS
	W/wJZnNgem1Xmbk8iveN5AUqBxsh1MbO01sUuhYmRld2BBSW/4CiKH9g2BvO25xGWNyl9GXi3kB
	enOq9lbTli5HESNzvx1rN+KdlIZaxbBnCUxS9sCp1wbEo/T87u/pQ/cKeC9qsAWLZ3ajmBTmNUa
	69Ad39EzXYDLmDGEBZIE+47JOhFsKFeoZWdU7EUl7n9szCagvM/qlT0imD4z7Qc6hgp6sB/mQKn
	IBDvX7QhF/wMrTE/pEYq4zlwJ0HNv3rOs2vsrUjli7/gkXGW3hULd6yp4CGdUQp3aZR8GNLjMmf
	Zn27FXnZjbbFZcVVtNbvF4U+8axMYM7gGELyYZxzzgHXS
X-Google-Smtp-Source: AGHT+IGuIwzsKruUx00S6MuPZZ8wEipmbrU34csOmvQGufg9/2Z1MNN5TYK/0noWD38o0a09A5dqvA==
X-Received: by 2002:a05:600c:1c9d:b0:459:da76:d7aa with SMTP id 5b1f17b1804b1-45a2185d715mr86983485e9.25.1755525430037;
        Mon, 18 Aug 2025 06:57:10 -0700 (PDT)
Received: from 127.0.0.1localhost ([185.69.144.43])
        by smtp.gmail.com with ESMTPSA id 5b1f17b1804b1-45a1b899338sm91187345e9.7.2025.08.18.06.57.08
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 18 Aug 2025 06:57:09 -0700 (PDT)
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
Subject: [PATCH net-next v3 21/23] eth: bnxt: support per queue configuration of rx-buf-len
Date: Mon, 18 Aug 2025 14:57:37 +0100
Message-ID: <4468e2a3f887f687050ff9cc602415ecbb541b8f.1755499376.git.asml.silence@gmail.com>
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
index b02205f1f010..5490f956f577 100644
--- a/drivers/net/ethernet/broadcom/bnxt/bnxt.c
+++ b/drivers/net/ethernet/broadcom/bnxt/bnxt.c
@@ -4313,6 +4313,7 @@ static void bnxt_init_ring_struct(struct bnxt *bp)
 
 	for (i = 0; i < bp->cp_nr_rings; i++) {
 		struct bnxt_napi *bnapi = bp->bnapi[i];
+		struct netdev_queue_config qcfg;
 		struct bnxt_ring_mem_info *rmem;
 		struct bnxt_cp_ring_info *cpr;
 		struct bnxt_rx_ring_info *rxr;
@@ -4335,7 +4336,8 @@ static void bnxt_init_ring_struct(struct bnxt *bp)
 		if (!rxr)
 			goto skip_rx;
 
-		rxr->rx_page_size = bp->rx_page_size;
+		netdev_queue_config(bp->dev, i,	&qcfg);
+		rxr->rx_page_size = qcfg.rx_buf_len;
 
 		ring = &rxr->rx_ring_struct;
 		rmem = &ring->ring_mem;
@@ -15870,6 +15872,7 @@ static int bnxt_queue_mem_alloc(struct net_device *dev,
 	clone->rx_agg_prod = 0;
 	clone->rx_sw_agg_prod = 0;
 	clone->rx_next_cons = 0;
+	clone->rx_page_size = qcfg->rx_buf_len;
 	clone->need_head_pool = false;
 
 	rc = bnxt_alloc_rx_page_pool(bp, clone, rxr->page_pool->p.nid);
@@ -15976,6 +15979,8 @@ static void bnxt_copy_rx_ring(struct bnxt *bp,
 	src_ring = &src->rx_ring_struct;
 	src_rmem = &src_ring->ring_mem;
 
+	dst->rx_page_size = src->rx_page_size;
+
 	WARN_ON(dst_rmem->nr_pages != src_rmem->nr_pages);
 	WARN_ON(dst_rmem->page_size != src_rmem->page_size);
 	WARN_ON(dst_rmem->flags != src_rmem->flags);
@@ -16183,6 +16188,7 @@ bnxt_queue_cfg_defaults(struct net_device *dev, int idx,
 }
 
 static const struct netdev_queue_mgmt_ops bnxt_queue_mgmt_ops = {
+	.supported_ring_params	= ETHTOOL_RING_USE_RX_BUF_LEN,
 	.ndo_queue_mem_size	= sizeof(struct bnxt_rx_ring_info),
 
 	.ndo_queue_cfg_defaults	= bnxt_queue_cfg_defaults,
-- 
2.49.0


