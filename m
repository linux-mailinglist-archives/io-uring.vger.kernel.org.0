Return-Path: <io-uring+bounces-6372-lists+io-uring=lfdr.de@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [IPv6:2604:1380:4601:e00::3])
	by mail.lfdr.de (Postfix) with ESMTPS id A7534A32F12
	for <lists+io-uring@lfdr.de>; Wed, 12 Feb 2025 19:59:53 +0100 (CET)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id 09036188B0F7
	for <lists+io-uring@lfdr.de>; Wed, 12 Feb 2025 18:59:51 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id AE1F4262811;
	Wed, 12 Feb 2025 18:59:10 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=davidwei-uk.20230601.gappssmtp.com header.i=@davidwei-uk.20230601.gappssmtp.com header.b="XGh8rszJ"
X-Original-To: io-uring@vger.kernel.org
Received: from mail-pj1-f41.google.com (mail-pj1-f41.google.com [209.85.216.41])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 269E52627ED
	for <io-uring@vger.kernel.org>; Wed, 12 Feb 2025 18:59:08 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.216.41
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1739386750; cv=none; b=FoYplqKoAnI8Wwk4+coyj/ecYKdnjMxixmMIsDrefWfxSHgeLVz6o0HjuVI90Do4c0qrjmzvnTjfAhLyTOLuffs4qugBjMv8rJyItIUlE+pKgw9HfuZ0xl6DtgwfYb8RMytKQwh4Jwn84dnZclUDbON+cMuCFqkFW2xLdDnJqn8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1739386750; c=relaxed/simple;
	bh=moxT/9tlqEGGqkvg89jEl7qnqkLxWddMi6wsJk9KyOo=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=CQNg85SRCs6D35cjuaV7MD7ZyyUW12fhEvIms+F4zasTxsfr3sQCBu9hYU2Adz2g1R0rW7ffDDpa/tkjuUWDa5/jdyT29dGVLhbXiRkTtQtzgcuTcYw+Yl+KSq0S5l6PaqmP5vg0Mn8tH901KW3MrkFIuGkGVtCCAQw2H16citM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=davidwei.uk; spf=none smtp.mailfrom=davidwei.uk; dkim=pass (2048-bit key) header.d=davidwei-uk.20230601.gappssmtp.com header.i=@davidwei-uk.20230601.gappssmtp.com header.b=XGh8rszJ; arc=none smtp.client-ip=209.85.216.41
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=davidwei.uk
Authentication-Results: smtp.subspace.kernel.org; spf=none smtp.mailfrom=davidwei.uk
Received: by mail-pj1-f41.google.com with SMTP id 98e67ed59e1d1-2f9bac7699aso181505a91.1
        for <io-uring@vger.kernel.org>; Wed, 12 Feb 2025 10:59:08 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=davidwei-uk.20230601.gappssmtp.com; s=20230601; t=1739386748; x=1739991548; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=6McXPFUQHYSYEvRYSRp9lVm8DJpoafPAg8IZnzA+YUI=;
        b=XGh8rszJqMN8Qfa8Cj4UmLAL9igowG3ru8BgdeFxaYKrzu6d67YM4Wv72mPaEr4+1/
         Umy5NkG+w7C/Wvjj7cT4ska+smg8GXEwrqweynXpHPPzpUsLzk4ebEiKV2kuO70Mc5cb
         cUwxHYLtOw59wgpnzKqwRDweE9f4xFJlCuokYxhGYtG1It7vqTGF/Ba6fTTe/ptos8wM
         +3EXh7+0Lxsxwu2l0ZP2ks/pJPP0V2r/pbQQ5swvgHM2rCY/GCVxYajgJMI+yblPaya/
         /bwyVvZ3OlZlwALw7lHBeQNYro2iavONBuxBAth5s1TyoFu1LE2o1KQ4XT6ZG8OCSoQH
         Yb6A==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1739386748; x=1739991548;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=6McXPFUQHYSYEvRYSRp9lVm8DJpoafPAg8IZnzA+YUI=;
        b=s7emzIIu/tH71+/efsZ+PbbK4lHadz12a5Vzcd+iiXmivYKV4Wzeb3IZ7ZW3PQqowd
         JQcG0UO3M7G83iU7jnWv4zzRTRHkcaDP1qJFHuVz5kXgImf+KVIpk97Dy3zy9W6Fu1rY
         wIW0EJPINLfhMoEOR45kDFwY7hRc2HymVsFbLDySryvC58C4Ik0SIwrF6gNaY7fJF1i6
         gaMVXGNyiAFeLfERP8/I6MM8F3Nnk9f/K8F2g5Bje4MOhA7n1Ur8vASxDSQfO5QlHAMN
         cVERqGFoF6NzMVqh/0ZOc0B6/9AQ4GoZ0fJn0Om608hzIZTxx2zAHOqdbcRJPWlmxsWr
         ntAQ==
X-Gm-Message-State: AOJu0YxTg6YXwaF0Hs8BQSFpS402I1HH2ee5eITB2lz3hvnVQaqCnCtx
	CAab3ZTpW/LO/1vHdmst+TH8lNjskgNPFlDfmtcTAfPu1ZHs/bm+3uGnDxhbxM8o12oTPP9p1Ao
	9
X-Gm-Gg: ASbGncvO8TbmUCdTHiEddhc+Eb3Kaq/DS0eaMM0CIR49hZv0RmOvpXNpIKILLB/rIwE
	TQIyetIyQWjwnMuORb6LqfYMKbHw6/vecUQMCoulcz+QoxH3iCnL5EP3z0ltuI6PVAPtOeObIHB
	ASEAk4OhLDHoVKuugidX+eIFbmoLUqrHqu0M8g80c3VAacY1IajYb0kYdpDcCO2wFm6jYP8c2kR
	6G+9ClO57VOJDs8AkStT+uzAo8W992QVzVWBv2ISmJTEl3EDCkK0AjXXuxzFEL8jFuydN3T8V8=
X-Google-Smtp-Source: AGHT+IHq0dQfxC0rbEh1qFTbv56rIAztS5CVccFToQQQQg1SXxJ2m03b+QzPICPIqkNdBhQOBvdCiw==
X-Received: by 2002:a17:90b:4b06:b0:2fa:b84:b320 with SMTP id 98e67ed59e1d1-2fbf9106cc2mr5703089a91.24.1739386748549;
        Wed, 12 Feb 2025 10:59:08 -0800 (PST)
Received: from localhost ([2a03:2880:ff:9::])
        by smtp.gmail.com with ESMTPSA id 98e67ed59e1d1-2fbf989876bsm1835561a91.9.2025.02.12.10.59.07
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 12 Feb 2025 10:59:07 -0800 (PST)
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
Subject: [PATCH net-next v13 03/11] io_uring/zcrx: grab a net device
Date: Wed, 12 Feb 2025 10:57:53 -0800
Message-ID: <20250212185859.3509616-4-dw@davidwei.uk>
X-Mailer: git-send-email 2.43.5
In-Reply-To: <20250212185859.3509616-1-dw@davidwei.uk>
References: <20250212185859.3509616-1-dw@davidwei.uk>
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
 io_uring/zcrx.c | 28 ++++++++++++++++++++++++++++
 io_uring/zcrx.h |  5 +++++
 2 files changed, 33 insertions(+)

diff --git a/io_uring/zcrx.c b/io_uring/zcrx.c
index 04883a3ae80c..435cd634f91c 100644
--- a/io_uring/zcrx.c
+++ b/io_uring/zcrx.c
@@ -3,6 +3,8 @@
 #include <linux/errno.h>
 #include <linux/mm.h>
 #include <linux/io_uring.h>
+#include <linux/netdevice.h>
+#include <linux/rtnetlink.h>
 
 #include <uapi/linux/io_uring.h>
 
@@ -128,13 +130,28 @@ static struct io_zcrx_ifq *io_zcrx_ifq_alloc(struct io_ring_ctx *ctx)
 
 	ifq->if_rxq = -1;
 	ifq->ctx = ctx;
+	spin_lock_init(&ifq->lock);
 	return ifq;
 }
 
+static void io_zcrx_drop_netdev(struct io_zcrx_ifq *ifq)
+{
+	spin_lock(&ifq->lock);
+	if (ifq->netdev) {
+		netdev_put(ifq->netdev, &ifq->netdev_tracker);
+		ifq->netdev = NULL;
+	}
+	spin_unlock(&ifq->lock);
+}
+
 static void io_zcrx_ifq_free(struct io_zcrx_ifq *ifq)
 {
+	io_zcrx_drop_netdev(ifq);
+
 	if (ifq->area)
 		io_zcrx_free_area(ifq->area);
+	if (ifq->dev)
+		put_device(ifq->dev);
 
 	io_free_rbuf_ring(ifq);
 	kfree(ifq);
@@ -195,6 +212,17 @@ int io_register_zcrx_ifq(struct io_ring_ctx *ctx,
 	ifq->rq_entries = reg.rq_entries;
 	ifq->if_rxq = reg.if_rxq;
 
+	ret = -ENODEV;
+	ifq->netdev = netdev_get_by_index(current->nsproxy->net_ns, reg.if_idx,
+					  &ifq->netdev_tracker, GFP_KERNEL);
+	if (!ifq->netdev)
+		goto err;
+
+	ifq->dev = ifq->netdev->dev.parent;
+	if (!ifq->dev)
+		return -EOPNOTSUPP;
+	get_device(ifq->dev);
+
 	reg.offsets.rqes = sizeof(struct io_uring);
 	reg.offsets.head = offsetof(struct io_uring, head);
 	reg.offsets.tail = offsetof(struct io_uring, tail);
diff --git a/io_uring/zcrx.h b/io_uring/zcrx.h
index 53fd94b65b38..595bca0001d2 100644
--- a/io_uring/zcrx.h
+++ b/io_uring/zcrx.h
@@ -4,6 +4,7 @@
 
 #include <linux/io_uring_types.h>
 #include <net/page_pool/types.h>
+#include <net/net_trackers.h>
 
 struct io_zcrx_area {
 	struct net_iov_area	nia;
@@ -27,6 +28,10 @@ struct io_zcrx_ifq {
 	u32				rq_entries;
 
 	u32				if_rxq;
+	struct device			*dev;
+	struct net_device		*netdev;
+	netdevice_tracker		netdev_tracker;
+	spinlock_t			lock;
 };
 
 #if defined(CONFIG_IO_URING_ZCRX)
-- 
2.43.5


