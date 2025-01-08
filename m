Return-Path: <io-uring+bounces-5768-lists+io-uring=lfdr.de@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [IPv6:2604:1380:45e3:2400::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 9F9E0A067E5
	for <lists+io-uring@lfdr.de>; Wed,  8 Jan 2025 23:08:42 +0100 (CET)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id DD2E43A6DA0
	for <lists+io-uring@lfdr.de>; Wed,  8 Jan 2025 22:08:36 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 17C7A2046B4;
	Wed,  8 Jan 2025 22:07:23 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=davidwei-uk.20230601.gappssmtp.com header.i=@davidwei-uk.20230601.gappssmtp.com header.b="fY7a6lvR"
X-Original-To: io-uring@vger.kernel.org
Received: from mail-pl1-f182.google.com (mail-pl1-f182.google.com [209.85.214.182])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B2684205501
	for <io-uring@vger.kernel.org>; Wed,  8 Jan 2025 22:07:21 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.214.182
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1736374043; cv=none; b=f+OxCFTKeascOc6N55ONsujN5ddMQrjuotWdemvBM1K/0nZkr+kdH6u2kzdnCx330dx+5lwklYWYCaZn+sTcmzpJ5dA/nYWAT6giTJlX6jblZ0MvC0nAgCBP4y4dH2lBp7WarUuWq/QC55xqcy5fOvvjhMQDL+EcqrMtrFDPgvo=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1736374043; c=relaxed/simple;
	bh=47+zvc2Ici6Dhxn2E8wYQnSlqsBoCJHtk3I1q+12dkA=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=XKOvYB39v+mRrJRWCr6HnUI1MapUs7TnxXuqD9orlULdhBbbNTQnHvlEZJ6rcxSnsRvAI8k9moXXHGBKcGJDfaJ0JD6lZ77A07xqUCWyl1Rc7Kix0KJ7a6b2er9PI03ibjzPLFoCm1XP/a8/ZMzXPQkEDKVXBWA73q4vbVu6ddM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=davidwei.uk; spf=none smtp.mailfrom=davidwei.uk; dkim=pass (2048-bit key) header.d=davidwei-uk.20230601.gappssmtp.com header.i=@davidwei-uk.20230601.gappssmtp.com header.b=fY7a6lvR; arc=none smtp.client-ip=209.85.214.182
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=davidwei.uk
Authentication-Results: smtp.subspace.kernel.org; spf=none smtp.mailfrom=davidwei.uk
Received: by mail-pl1-f182.google.com with SMTP id d9443c01a7336-21628b3fe7dso3274845ad.3
        for <io-uring@vger.kernel.org>; Wed, 08 Jan 2025 14:07:21 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=davidwei-uk.20230601.gappssmtp.com; s=20230601; t=1736374041; x=1736978841; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=BrJyIoqHvwSKUkoZTkSSHSYdDjrfAJzArFg5r7V7N5Q=;
        b=fY7a6lvRS0yQ/8igCbORVvnbC20kjRKmiv9ZyDCLgvONapvgXvFFddzINSFAjy2BSn
         OJv2FecVTUqm6npLoqbZYIZ/lb+cMErknQfALPCbdh5LS3KBreFjOsvL+2PNasoZ8FO9
         DCWPqi5+wug6eO3kv/fvBe/3PJOBcy0IOCp0OZvQqh4A+C/fj+ekLClw0xpMfc/xH/yR
         5kzYc1uKFXEZpP7EzdhAGDIGMxA3sfwW4MPwkPNoOsUNNXDkdEyIIJbPofsrKS0pDFgZ
         K+dYeCB6MyGhNVK3b9O/ZyAflPYA9QywqKmyN6GPjnHpGfxC0hPhDRUbR3Vx4OTz89gR
         QXQQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1736374041; x=1736978841;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=BrJyIoqHvwSKUkoZTkSSHSYdDjrfAJzArFg5r7V7N5Q=;
        b=Lx5mD6HJK444tfzRFHf7JAi3THYOgrCEEIxHE1xIJNV/EuiZ/tq8VJyg70+mNn8j0A
         qm+CiEKiCq/I4ntDTRLtgfnfasiM4G0TB77yHN52Aw/Jkvs5a4BDOjFwldC1HPmpSvsZ
         nL7QbfbW2G5OE3tckCycsRUPJY47JwtSJfPb/UvAj+bv7L4Djjzg/Q1uXoCoqs3u3Jg9
         VKWadEwQXhejkxeQQ4OqchR0M3zouV0MnwrPvTnkSJowZIphoCQPKNkkMAmj2xf612Y0
         HGDRnD6LRcneFA4sWb5EhVN63W7X6zhMsYLPViEoJ891w3/98J36zE3V83WO20JDJiIJ
         l7ow==
X-Gm-Message-State: AOJu0YxII0m+B9UyH7O7iPa6jKaS/5ZictTIMWIGxY069xxuvn+fr8hw
	gUznH1mbrBK8jCyC7Ku+fenXUNm0kN+iKjFeCWiLQE0Sd2WWr57eNpR+LzmYNbDWybMA2fRjDIK
	A
X-Gm-Gg: ASbGnctLVxEGtpZGSwgzwDSRhX4oWZbCZrcC0jZW5uYw8scOwOe4FeZV2BZY43Gdrtl
	vxUmooj67NLxzlmz4GIfKOhKOvBqbReAq2F2qeW9aDi2vvg9u9ircJF7HHivSQYWlX2u5envNKw
	NJTsizSLy9jZ6HIsMTpSvgwLaHeMHK2B95+iXcTMchNHXuttoSJ4iRLNFboUcLG/A2fsRSNjjV9
	bRcw+OzjPKE8HoD8HY60ZhYLSAU5u1R6xOQJtPiiw==
X-Google-Smtp-Source: AGHT+IGvmLmr2nz6de/uaFySICL6uCdtyb6A3NlfWNpmpXbniS3AxufBFSiNq5oEiDX1paYwMwTzCQ==
X-Received: by 2002:a17:90b:2f46:b0:2ee:bbe0:98c6 with SMTP id 98e67ed59e1d1-2f548ea6488mr7112436a91.8.1736374040952;
        Wed, 08 Jan 2025 14:07:20 -0800 (PST)
Received: from localhost ([2a03:2880:ff:71::])
        by smtp.gmail.com with ESMTPSA id 98e67ed59e1d1-2f54a265db1sm2306594a91.1.2025.01.08.14.07.20
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 08 Jan 2025 14:07:20 -0800 (PST)
From: David Wei <dw@davidwei.uk>
To: io-uring@vger.kernel.org,
	netdev@vger.kernel.org
Cc: Jens Axboe <axboe@kernel.dk>,
	Pavel Begunkov <asml.silence@gmail.com>,
	Jakub Kicinski <kuba@kernel.org>,
	Paolo Abeni <pabeni@redhat.com>,
	"David S. Miller" <davem@davemloft.net>,
	Eric Dumazet <edumazet@google.com>,
	Jesper Dangaard Brouer <hawk@kernel.org>,
	David Ahern <dsahern@kernel.org>,
	Mina Almasry <almasrymina@google.com>,
	Stanislav Fomichev <stfomichev@gmail.com>,
	Joe Damato <jdamato@fastly.com>,
	Pedro Tammela <pctammela@mojatatu.com>
Subject: [PATCH net-next v10 14/22] io_uring/zcrx: grab a net device
Date: Wed,  8 Jan 2025 14:06:35 -0800
Message-ID: <20250108220644.3528845-15-dw@davidwei.uk>
X-Mailer: git-send-email 2.43.5
In-Reply-To: <20250108220644.3528845-1-dw@davidwei.uk>
References: <20250108220644.3528845-1-dw@davidwei.uk>
Precedence: bulk
X-Mailing-List: io-uring@vger.kernel.org
List-Id: <io-uring.vger.kernel.org>
List-Subscribe: <mailto:io-uring+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:io-uring+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

From: Pavel Begunkov <asml.silence@gmail.com>

Zerocopy receive needs a net device to bind to its rx queue and dma map
buffers. As a preparation to following patches, resolve a net device
from the if_idx parameter with no functional changes otherwise.

Reviewed-by: Jens Axboe <axboe@kernel.dk>
Signed-off-by: Pavel Begunkov <asml.silence@gmail.com>
Signed-off-by: David Wei <dw@davidwei.uk>
---
 io_uring/zcrx.c | 10 ++++++++++
 io_uring/zcrx.h |  3 +++
 2 files changed, 13 insertions(+)

diff --git a/io_uring/zcrx.c b/io_uring/zcrx.c
index 04883a3ae80c..e6cca6747148 100644
--- a/io_uring/zcrx.c
+++ b/io_uring/zcrx.c
@@ -3,6 +3,8 @@
 #include <linux/errno.h>
 #include <linux/mm.h>
 #include <linux/io_uring.h>
+#include <linux/netdevice.h>
+#include <linux/rtnetlink.h>
 
 #include <uapi/linux/io_uring.h>
 
@@ -136,6 +138,8 @@ static void io_zcrx_ifq_free(struct io_zcrx_ifq *ifq)
 	if (ifq->area)
 		io_zcrx_free_area(ifq->area);
 
+	if (ifq->dev)
+		netdev_put(ifq->dev, &ifq->netdev_tracker);
 	io_free_rbuf_ring(ifq);
 	kfree(ifq);
 }
@@ -195,6 +199,12 @@ int io_register_zcrx_ifq(struct io_ring_ctx *ctx,
 	ifq->rq_entries = reg.rq_entries;
 	ifq->if_rxq = reg.if_rxq;
 
+	ret = -ENODEV;
+	ifq->dev = netdev_get_by_index(current->nsproxy->net_ns, reg.if_idx,
+					&ifq->netdev_tracker, GFP_KERNEL);
+	if (!ifq->dev)
+		goto err;
+
 	reg.offsets.rqes = sizeof(struct io_uring);
 	reg.offsets.head = offsetof(struct io_uring, head);
 	reg.offsets.tail = offsetof(struct io_uring, tail);
diff --git a/io_uring/zcrx.h b/io_uring/zcrx.h
index 53fd94b65b38..46988a1dbd54 100644
--- a/io_uring/zcrx.h
+++ b/io_uring/zcrx.h
@@ -4,6 +4,7 @@
 
 #include <linux/io_uring_types.h>
 #include <net/page_pool/types.h>
+#include <net/net_trackers.h>
 
 struct io_zcrx_area {
 	struct net_iov_area	nia;
@@ -27,6 +28,8 @@ struct io_zcrx_ifq {
 	u32				rq_entries;
 
 	u32				if_rxq;
+	struct net_device		*dev;
+	netdevice_tracker		netdev_tracker;
 };
 
 #if defined(CONFIG_IO_URING_ZCRX)
-- 
2.43.5


