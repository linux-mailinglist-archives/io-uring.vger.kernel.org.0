Return-Path: <io-uring+bounces-5554-lists+io-uring=lfdr.de@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [IPv6:2604:1380:45d1:ec00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 278CA9F5BC4
	for <lists+io-uring@lfdr.de>; Wed, 18 Dec 2024 01:40:34 +0100 (CET)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id 5A6A6162213
	for <lists+io-uring@lfdr.de>; Wed, 18 Dec 2024 00:40:31 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 235441494B3;
	Wed, 18 Dec 2024 00:38:18 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=davidwei-uk.20230601.gappssmtp.com header.i=@davidwei-uk.20230601.gappssmtp.com header.b="UU+catRN"
X-Original-To: io-uring@vger.kernel.org
Received: from mail-pf1-f177.google.com (mail-pf1-f177.google.com [209.85.210.177])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9D0991465B3
	for <io-uring@vger.kernel.org>; Wed, 18 Dec 2024 00:38:15 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.210.177
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1734482298; cv=none; b=eipkf89cTd11azF82f5qMt5XFOLejXdoF4EivGoppCCmUDpnKk+QrlJ23zIuSQuBn0vAzICxvTg1LTg/4KW511Bid67C+RhJMXKJTR4TfB9TKfQPANHjsWBH7Hvlq5a6lCrUX2TGZ/oSPR2w2ZtrSOVoSByMWLjpgXJZ0kRy34k=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1734482298; c=relaxed/simple;
	bh=NN6l70wJTo+V3AXDIpdVN8AsIz5j8mOAPtjJ/ZcVfqo=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=cQ0RjqXOYj+aeyw8vRfviGbuGtZUUAIoAVKFzlTibhRNv6t0qI1QNSLwTZ7QDoKRWNhEU1F4yZEQtZlQw2wBQDNmFJ7FueHGNtkHmPdsrjoyc1pFSif6p+eWj0XxrNUXvp0s2WoSOncyCn09rewi/MvLy+1M7IZ2DWp1gFjwIXk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=davidwei.uk; spf=none smtp.mailfrom=davidwei.uk; dkim=pass (2048-bit key) header.d=davidwei-uk.20230601.gappssmtp.com header.i=@davidwei-uk.20230601.gappssmtp.com header.b=UU+catRN; arc=none smtp.client-ip=209.85.210.177
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=davidwei.uk
Authentication-Results: smtp.subspace.kernel.org; spf=none smtp.mailfrom=davidwei.uk
Received: by mail-pf1-f177.google.com with SMTP id d2e1a72fcca58-725f4623df7so5267531b3a.2
        for <io-uring@vger.kernel.org>; Tue, 17 Dec 2024 16:38:15 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=davidwei-uk.20230601.gappssmtp.com; s=20230601; t=1734482295; x=1735087095; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=eMOrlUp6jAnTkKL1sSea4dlKz2vU1sfuxmAW5sBPRZc=;
        b=UU+catRNRM7NL9gQG1SQuvh9L3Fyf9SWU/sdsKwAWkdn2SRiD3AVKDLD2qtDkyPexn
         E6Wl3MadEcKnrHElY3+qioBEGzT0Df9Ppz5K+tFBGfqJBinOnKYobDha8KjnnRiyPOxV
         dPd0vWDyPtObWFlcxflJjbILmD5yN5OH6UKFXugUymLlaZgVXz15aoMQWlrjdszd8LmA
         7zS+v32/KxSfII4mY1OdGaSdQHkyIxxnUbi2s0znQMKbfpMSpbEqHSu04fh2rDQavaaW
         QyewwKa4Jmph2kn1uuNg/xZsQE7cHm4jBoinDnzy16fxKlgzfGotUViNGnNlOHhFkHbg
         JYEw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1734482295; x=1735087095;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=eMOrlUp6jAnTkKL1sSea4dlKz2vU1sfuxmAW5sBPRZc=;
        b=eAstW+C5xRXGXlNBBzw5a7R52kkLx1SVPxis9EMHcprlKKelG4V1pK/wDRw7JUMpEH
         ATYgIzpsaAU0F/LxahHkivq0eiFSBpgGLGt7zhqk5oE9q5DsquT8b7XlN7acjXjdFRKa
         sJ0yWAEyAgXuKY2J7n1ue2TGmb7NvPMYw4LRsE7udyiqeTxoJO0ipjLkgotD5Gxt2QF9
         f71SF9uhhesd37FmdHrKYbAydAX8zIRrvZ334EnG90LYFym8bUjgCSwgdNj3eJCC0fKz
         gSA0a9DHE5+y5A6wsJOmXVzkFJB8OU67HN2VySotA5Y8/cn1rstNgTxj6P9jWyJqf7ZX
         Mhcw==
X-Gm-Message-State: AOJu0YzzZTyI/5rVXx/X0//O+LMGtZANxajrlJ/YFR0/aF+RojZN1B+x
	CXa4BZdD+QMLCcTOQ2JzjI967any/OtW6KlMXWkjPRDCRzm5zssoBjGDVIHN3oQ+gPh3WXYHWvg
	8
X-Gm-Gg: ASbGnctNSV9MzMv25yP7+NDS4HOUh7vxWT8zLssOAgEkid3bdpOIAcOgqCFYGJ28Ri+
	58hDA8FtcMIEqB1w2vdrM/QX7OQ7YgKYgWksXoYTy67al4xNjEPDlIPMrrYPioS1AC31k18WFgb
	W5IJsdCYv58VF5UYDKyEJ5fhH0ZqRFIEerjXX/TqWBM/zp3WvMzjchuly/l2fH40RmjthGcYE1u
	dXaN1P6eogglTaaxLLA2p3P1gFbB/NpoEEaIhJV
X-Google-Smtp-Source: AGHT+IGvs56gJHOktJseiAi7TrAKx7QXPL0L6ug4z9uFCs5Je1RvXtfDkS7+qoqOQ3y1lhNxg5hYlw==
X-Received: by 2002:a17:90b:2e4a:b0:2ee:90a1:5d42 with SMTP id 98e67ed59e1d1-2f2e8f55a1dmr1520309a91.0.1734482294978;
        Tue, 17 Dec 2024 16:38:14 -0800 (PST)
Received: from localhost ([2a03:2880:ff:c::])
        by smtp.gmail.com with ESMTPSA id 98e67ed59e1d1-2f2ed0d84d0sm123242a91.0.2024.12.17.16.38.14
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 17 Dec 2024 16:38:14 -0800 (PST)
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
Subject: [PATCH net-next v9 16/20] io_uring/zcrx: set pp memory provider for an rx queue
Date: Tue, 17 Dec 2024 16:37:42 -0800
Message-ID: <20241218003748.796939-17-dw@davidwei.uk>
X-Mailer: git-send-email 2.43.5
In-Reply-To: <20241218003748.796939-1-dw@davidwei.uk>
References: <20241218003748.796939-1-dw@davidwei.uk>
Precedence: bulk
X-Mailing-List: io-uring@vger.kernel.org
List-Id: <io-uring.vger.kernel.org>
List-Subscribe: <mailto:io-uring+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:io-uring+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

Set the page pool memory provider for the rx queue configured for zero
copy to io_uring. Then the rx queue is reset using
netdev_rx_queue_restart() and netdev core + page pool will take care of
filling the rx queue from the io_uring zero copy memory provider.

For now, there is only one ifq so its destruction happens implicitly
during io_uring cleanup.

Reviewed-by: Jens Axboe <axboe@kernel.dk>
Signed-off-by: David Wei <dw@davidwei.uk>
---
 io_uring/zcrx.c | 83 ++++++++++++++++++++++++++++++++++++++++++++-----
 1 file changed, 75 insertions(+), 8 deletions(-)

diff --git a/io_uring/zcrx.c b/io_uring/zcrx.c
index 1122c80502d6..756c78c0920e 100644
--- a/io_uring/zcrx.c
+++ b/io_uring/zcrx.c
@@ -10,11 +10,12 @@
 
 #include <net/page_pool/helpers.h>
 #include <net/netlink.h>
-
-#include <trace/events/page_pool.h>
+#include <net/netdev_rx_queue.h>
 #include <net/tcp.h>
 #include <net/rps.h>
 
+#include <trace/events/page_pool.h>
+
 #include <uapi/linux/io_uring.h>
 
 #include "io_uring.h"
@@ -119,6 +120,65 @@ static void io_zcrx_get_niov_uref(struct net_iov *niov)
 	atomic_inc(io_get_user_counter(niov));
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
+	if (ret)
+		goto fail;
+	return 0;
+fail:
+	rxq->mp_params.mp_ops = NULL;
+	rxq->mp_params.mp_priv = NULL;
+	ifq->if_rxq = -1;
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
 				 struct io_uring_zcrx_ifq_reg *reg,
 				 struct io_uring_region_desc *rd)
@@ -255,6 +315,8 @@ static struct io_zcrx_ifq *io_zcrx_ifq_alloc(struct io_ring_ctx *ctx)
 
 static void io_zcrx_ifq_free(struct io_zcrx_ifq *ifq)
 {
+	io_close_zc_rxq(ifq);
+
 	if (ifq->area)
 		io_zcrx_free_area(ifq->area);
 
@@ -317,7 +379,6 @@ int io_register_zcrx_ifq(struct io_ring_ctx *ctx,
 		goto err;
 
 	ifq->rq_entries = reg.rq_entries;
-	ifq->if_rxq = reg.if_rxq;
 
 	ret = -ENODEV;
 	ifq->dev = netdev_get_by_index(current->nsproxy->net_ns, reg.if_idx,
@@ -329,16 +390,20 @@ int io_register_zcrx_ifq(struct io_ring_ctx *ctx,
 	if (ret)
 		goto err;
 
+	rtnl_lock();
+	ret = io_open_zc_rxq(ifq, reg.if_rxq);
+	rtnl_unlock();
+	if (ret)
+		goto err;
+
 	reg.offsets.rqes = sizeof(struct io_uring);
 	reg.offsets.head = offsetof(struct io_uring, head);
 	reg.offsets.tail = offsetof(struct io_uring, tail);
 
 	if (copy_to_user(arg, &reg, sizeof(reg)) ||
-	    copy_to_user(u64_to_user_ptr(reg.region_ptr), &rd, sizeof(rd))) {
-		ret = -EFAULT;
-		goto err;
-	}
-	if (copy_to_user(u64_to_user_ptr(reg.area_ptr), &area, sizeof(area))) {
+	    copy_to_user(u64_to_user_ptr(reg.region_ptr), &rd, sizeof(rd)) ||
+	    copy_to_user(u64_to_user_ptr(reg.area_ptr), &area, sizeof(area))) {
+		io_close_zc_rxq(ifq);
 		ret = -EFAULT;
 		goto err;
 	}
@@ -415,6 +480,8 @@ void io_shutdown_zcrx_ifqs(struct io_ring_ctx *ctx)
 
 	if (ctx->ifq)
 		io_zcrx_scrub(ctx->ifq);
+
+	io_close_zc_rxq(ctx->ifq);
 }
 
 static inline u32 io_zcrx_rqring_entries(struct io_zcrx_ifq *ifq)
-- 
2.43.5


