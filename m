Return-Path: <io-uring+bounces-3456-lists+io-uring=lfdr.de@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [139.178.88.99])
	by mail.lfdr.de (Postfix) with ESMTPS id 6D57D993A0A
	for <lists+io-uring@lfdr.de>; Tue,  8 Oct 2024 00:18:05 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 2A0FD2859C2
	for <lists+io-uring@lfdr.de>; Mon,  7 Oct 2024 22:18:04 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 2194B1DE2D9;
	Mon,  7 Oct 2024 22:16:47 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=davidwei-uk.20230601.gappssmtp.com header.i=@davidwei-uk.20230601.gappssmtp.com header.b="Ohw8gW5U"
X-Original-To: io-uring@vger.kernel.org
Received: from mail-pl1-f181.google.com (mail-pl1-f181.google.com [209.85.214.181])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id AB6BF1C9B77
	for <io-uring@vger.kernel.org>; Mon,  7 Oct 2024 22:16:45 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.214.181
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1728339407; cv=none; b=mqx39YWzFrt9RLbEqOt61L6Ibn73L7RXPNJ2qvL+zOO1IOqq0c2VOry8UZVTry4Q4gU1K/9jQ1WDezCi93WrKA7DUNVx8Iwl8Lo9V9iNCNpNBJWRPuuviJMxQWVST8K12Fyo5XTFIuQt8mJGD7Vhez4PkGoIUeE62GLhGUrXmvY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1728339407; c=relaxed/simple;
	bh=M/u32X7mE0eu2j1IfCto9rHwIaFfw+VZzzLEOHDgzC8=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=acr38OC5ran+NQ2sj40cY/OsiZSmwQNOACroIy/IMqELFqPicXdNZFJ34EpmrMG5nurzRpZUNJbvprqI2cR1Y6ZspLCiyJ6IYqClo+M4Yq4ABZvuQ9AiyRxy69TCD1K7WGpYClQ6gziuvbc8ufzsVIeAHOFuovrUB8otmsDyMCQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=davidwei.uk; spf=none smtp.mailfrom=davidwei.uk; dkim=pass (2048-bit key) header.d=davidwei-uk.20230601.gappssmtp.com header.i=@davidwei-uk.20230601.gappssmtp.com header.b=Ohw8gW5U; arc=none smtp.client-ip=209.85.214.181
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=davidwei.uk
Authentication-Results: smtp.subspace.kernel.org; spf=none smtp.mailfrom=davidwei.uk
Received: by mail-pl1-f181.google.com with SMTP id d9443c01a7336-20bcae5e482so43205285ad.0
        for <io-uring@vger.kernel.org>; Mon, 07 Oct 2024 15:16:45 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=davidwei-uk.20230601.gappssmtp.com; s=20230601; t=1728339405; x=1728944205; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=/eq2VZkNo54wCm06p4ihDUUpbW/pqLbz8N2zWhnWG4o=;
        b=Ohw8gW5URHf1iufG7i+Pbt9RCUmdRZOuXS5QPXkYWTZCAPb5KGd9XgEIEkWjUok/tX
         oSBmF5Q+ojSQNa8NdMMAMQ6ulD8JYHLbtdfvi3/AGr3i+y1Mnb29zx0ha/okSO8cOx2e
         vCK96uPVJDBDeuFjdQ2gemMzJWdG+4WGbyJ0owieumFsNHV11lsMc/86L86Iz+p1unQp
         1vGrPpIZWigCc2CYoqTBBr2yQgsA0M6sdnSMgfAZlfTXYPzDWFa5Tg6PiZem+lBltPV7
         b3SstKcLV+Vhhm22tb9efnESHbgT8CZyzCQPq0fb4u9JpVOqaUygJV9l1g9X0uWQXkc2
         Vwlg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1728339405; x=1728944205;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=/eq2VZkNo54wCm06p4ihDUUpbW/pqLbz8N2zWhnWG4o=;
        b=JVcvdO7AvSB5QiWLlOyPOULRSMf3KfuJ5xC/UyZjY9HFdFIwQHgZhHjfRgExmN1Wpv
         wvN45AJwiHmlHaPXsqyYr3G0Q0J1xbli2XAL1SDJkFS3RNY4TNHUkm4fbaImNM6Jn/fC
         PI+KfMzsamfaLRVmtkyMSwNmHHWaQUAs82L42xGBAprMDDfKIO9OM+1XTlkmG1gBLtvH
         mX35ojqqRgL7fAkcbu+D+VF59DSPJlKI4qWRvup1n1CfM0aJKmK0iHOapmc7u8b9+vW1
         1LFJE6orIT/FBX4McTHnF33JPwoa3AN3nNXrmE1TkNjjLJFYxV6ymZRIuAkN91hMyKgD
         karQ==
X-Gm-Message-State: AOJu0Ywya8jQTxPzHswxxrgE9wHivh1eHsubg0+sbHx3afaNFR6JgtF+
	mCUz0C6TYnFyThkq4xz1il/E21f0kB7hq5MFfuxMvcw+SsolawLnOt1dvvyLd6JgjzyCfBRTFcK
	g
X-Google-Smtp-Source: AGHT+IGnf67ts0Ls/kC3chNDoUoQKzIEIrHLFKWe3Mde2+FmEtrlljL2verm97/1cvmUnLU5bmDy0w==
X-Received: by 2002:a17:902:cec6:b0:20b:61ec:7d3c with SMTP id d9443c01a7336-20bff1c6365mr217121335ad.49.1728339405080;
        Mon, 07 Oct 2024 15:16:45 -0700 (PDT)
Received: from localhost (fwdproxy-prn-008.fbsv.net. [2a03:2880:ff:8::face:b00c])
        by smtp.gmail.com with ESMTPSA id d9443c01a7336-20c1396c887sm44337865ad.237.2024.10.07.15.16.44
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 07 Oct 2024 15:16:44 -0700 (PDT)
From: David Wei <dw@davidwei.uk>
To: io-uring@vger.kernel.org,
	netdev@vger.kernel.org
Cc: David Wei <dw@davidwei.uk>,
	Jens Axboe <axboe@kernel.dk>,
	Pavel Begunkov <asml.silence@gmail.com>,
	Jakub Kicinski <kuba@kernel.org>,
	Paolo Abeni <pabeni@redhat.com>,
	"David S. Miller" <davem@davemloft.net>,
	Eric Dumazet <edumazet@google.com>,
	Jesper Dangaard Brouer <hawk@kernel.org>,
	David Ahern <dsahern@kernel.org>,
	Mina Almasry <almasrymina@google.com>
Subject: [PATCH v1 14/15] io_uring/zcrx: set pp memory provider for an rx queue
Date: Mon,  7 Oct 2024 15:16:02 -0700
Message-ID: <20241007221603.1703699-15-dw@davidwei.uk>
X-Mailer: git-send-email 2.43.5
In-Reply-To: <20241007221603.1703699-1-dw@davidwei.uk>
References: <20241007221603.1703699-1-dw@davidwei.uk>
Precedence: bulk
X-Mailing-List: io-uring@vger.kernel.org
List-Id: <io-uring.vger.kernel.org>
List-Subscribe: <mailto:io-uring+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:io-uring+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

From: David Wei <davidhwei@meta.com>

Set the page pool memory provider for the rx queue configured for zero copy to
io_uring. Then the rx queue is reset using netdev_rx_queue_restart() and netdev
core + page pool will take care of filling the rx queue from the io_uring zero
copy memory provider.

For now, there is only one ifq so its destruction happens implicitly during
io_uring cleanup.

Signed-off-by: David Wei <dw@davidwei.uk>
---
 io_uring/zcrx.c | 84 +++++++++++++++++++++++++++++++++++++++++++++++--
 1 file changed, 82 insertions(+), 2 deletions(-)

diff --git a/io_uring/zcrx.c b/io_uring/zcrx.c
index d21e7017deb3..7939f830cf5b 100644
--- a/io_uring/zcrx.c
+++ b/io_uring/zcrx.c
@@ -6,6 +6,8 @@
 #include <linux/netdevice.h>
 #include <linux/io_uring.h>
 #include <linux/skbuff_ref.h>
+#include <linux/io_uring/net.h>
+#include <net/netdev_rx_queue.h>
 #include <net/busy_poll.h>
 #include <net/page_pool/helpers.h>
 #include <trace/events/page_pool.h>
@@ -49,6 +51,63 @@ static inline struct page *io_zcrx_iov_page(const struct net_iov *niov)
 	return area->pages[net_iov_idx(niov)];
 }
 
+static int io_open_zc_rxq(struct io_zcrx_ifq *ifq, unsigned ifq_idx)
+{
+	struct netdev_rx_queue *rxq;
+	struct net_device *dev = ifq->dev;
+	int ret;
+
+	ASSERT_RTNL();
+
+	if (ifq_idx >= dev->num_rx_queues)
+		return -EINVAL;
+	ifq_idx = array_index_nospec(ifq_idx, dev->num_rx_queues);
+
+	rxq = __netif_get_rx_queue(ifq->dev, ifq_idx);
+	if (rxq->mp_params.mp_priv)
+		return -EEXIST;
+
+	ifq->if_rxq = ifq_idx;
+	rxq->mp_params.mp_ops = &io_uring_pp_zc_ops;
+	rxq->mp_params.mp_priv = ifq;
+	ret = netdev_rx_queue_restart(ifq->dev, ifq->if_rxq);
+	if (ret) {
+		rxq->mp_params.mp_ops = NULL;
+		rxq->mp_params.mp_priv = NULL;
+		ifq->if_rxq = -1;
+	}
+	return ret;
+}
+
+static void io_close_zc_rxq(struct io_zcrx_ifq *ifq)
+{
+	struct netdev_rx_queue *rxq;
+	int err;
+
+	if (ifq->if_rxq == -1)
+		return;
+
+	rtnl_lock();
+	if (WARN_ON_ONCE(ifq->if_rxq >= ifq->dev->num_rx_queues)) {
+		rtnl_unlock();
+		return;
+	}
+
+	rxq = __netif_get_rx_queue(ifq->dev, ifq->if_rxq);
+
+	WARN_ON_ONCE(rxq->mp_params.mp_priv != ifq);
+
+	rxq->mp_params.mp_ops = NULL;
+	rxq->mp_params.mp_priv = NULL;
+
+	err = netdev_rx_queue_restart(ifq->dev, ifq->if_rxq);
+	if (err)
+		pr_devel("io_uring: can't restart a queue on zcrx close\n");
+
+	rtnl_unlock();
+	ifq->if_rxq = -1;
+}
+
 static int io_allocate_rbuf_ring(struct io_zcrx_ifq *ifq,
 				 struct io_uring_zcrx_ifq_reg *reg)
 {
@@ -169,9 +228,12 @@ static struct io_zcrx_ifq *io_zcrx_ifq_alloc(struct io_ring_ctx *ctx)
 
 static void io_zcrx_ifq_free(struct io_zcrx_ifq *ifq)
 {
+	io_close_zc_rxq(ifq);
+
 	if (ifq->area)
 		io_zcrx_free_area(ifq->area);
-
+	if (ifq->dev)
+		dev_put(ifq->dev);
 	io_free_rbuf_ring(ifq);
 	kfree(ifq);
 }
@@ -227,7 +289,17 @@ int io_register_zcrx_ifq(struct io_ring_ctx *ctx,
 		goto err;
 
 	ifq->rq_entries = reg.rq_entries;
-	ifq->if_rxq = reg.if_rxq;
+
+	ret = -ENODEV;
+	rtnl_lock();
+	ifq->dev = dev_get_by_index(current->nsproxy->net_ns, reg.if_idx);
+	if (!ifq->dev)
+		goto err_rtnl_unlock;
+
+	ret = io_open_zc_rxq(ifq, reg.if_rxq);
+	if (ret)
+		goto err_rtnl_unlock;
+	rtnl_unlock();
 
 	ring_sz = sizeof(struct io_uring);
 	rqes_sz = sizeof(struct io_uring_zcrx_rqe) * ifq->rq_entries;
@@ -237,15 +309,20 @@ int io_register_zcrx_ifq(struct io_ring_ctx *ctx,
 	reg.offsets.tail = offsetof(struct io_uring, tail);
 
 	if (copy_to_user(arg, &reg, sizeof(reg))) {
+		io_close_zc_rxq(ifq);
 		ret = -EFAULT;
 		goto err;
 	}
 	if (copy_to_user(u64_to_user_ptr(reg.area_ptr), &area, sizeof(area))) {
+		io_close_zc_rxq(ifq);
 		ret = -EFAULT;
 		goto err;
 	}
 	ctx->ifq = ifq;
 	return 0;
+
+err_rtnl_unlock:
+	rtnl_unlock();
 err:
 	io_zcrx_ifq_free(ifq);
 	return ret;
@@ -267,6 +344,9 @@ void io_unregister_zcrx_ifqs(struct io_ring_ctx *ctx)
 void io_shutdown_zcrx_ifqs(struct io_ring_ctx *ctx)
 {
 	lockdep_assert_held(&ctx->uring_lock);
+
+	if (ctx->ifq)
+		io_close_zc_rxq(ctx->ifq);
 }
 
 static void io_zcrx_get_buf_uref(struct net_iov *niov)
-- 
2.43.5


