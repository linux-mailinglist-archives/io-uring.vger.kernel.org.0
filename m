Return-Path: <io-uring+bounces-5226-lists+io-uring=lfdr.de@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from sy.mirrors.kernel.org (sy.mirrors.kernel.org [147.75.48.161])
	by mail.lfdr.de (Postfix) with ESMTPS id A187F9E43F0
	for <lists+io-uring@lfdr.de>; Wed,  4 Dec 2024 20:01:35 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sy.mirrors.kernel.org (Postfix) with ESMTPS id 1FEFCB2F274
	for <lists+io-uring@lfdr.de>; Wed,  4 Dec 2024 17:58:16 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 1BACC21638D;
	Wed,  4 Dec 2024 17:23:01 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=davidwei-uk.20230601.gappssmtp.com header.i=@davidwei-uk.20230601.gappssmtp.com header.b="pGD6cees"
X-Original-To: io-uring@vger.kernel.org
Received: from mail-pf1-f176.google.com (mail-pf1-f176.google.com [209.85.210.176])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 77ADA215F74
	for <io-uring@vger.kernel.org>; Wed,  4 Dec 2024 17:22:59 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.210.176
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1733332981; cv=none; b=sSpfAZ+ELrVBLaNhAUdM2XlPBUkhJCEVY3TBi/NyfBM4jIq2eLLB+a/31KQrl+tj8ZXkZxJ6Ew60R26xc4SC7ML42ofcT2wUH7Yp9h6/DlQlAGrCCFivv8VQ/dtYBmrsDt5ei3kXpzx+PFpgPVLfB4xrShuM/QYFb+o+Jvo7ZIo=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1733332981; c=relaxed/simple;
	bh=yHkBS0Ae7tWKphGIsp/BscufJpA2CS64Q5wOxYY5YaY=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=iw+Qw2jmYrKWlrgRJRGMam1pC893IG2CmC79k/x3AW4ncuQHKGlvKdc1fQeRdRpo9mNNor1CThKgN/pABv/5fhJs7/4wLOTMokl1na0Hn+/fHZh4E3O/3GG0X7xhV6s/C7esDEG10kiKfjjLWi95wY4MFbBv4qLrtK91UluwRLU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=davidwei.uk; spf=none smtp.mailfrom=davidwei.uk; dkim=pass (2048-bit key) header.d=davidwei-uk.20230601.gappssmtp.com header.i=@davidwei-uk.20230601.gappssmtp.com header.b=pGD6cees; arc=none smtp.client-ip=209.85.210.176
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=davidwei.uk
Authentication-Results: smtp.subspace.kernel.org; spf=none smtp.mailfrom=davidwei.uk
Received: by mail-pf1-f176.google.com with SMTP id d2e1a72fcca58-7251331e756so57879b3a.3
        for <io-uring@vger.kernel.org>; Wed, 04 Dec 2024 09:22:59 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=davidwei-uk.20230601.gappssmtp.com; s=20230601; t=1733332979; x=1733937779; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=2VznSQpWwqyyoWSCkKyMSe9FismvnJKrDHHL+sPjQaA=;
        b=pGD6ceesua5fqcoDyv6tYtlyfBSCa74Ez8d8BPc+DWDUbdTkR7oqw7Z06A4lDTpRqW
         cMB/SAy8Nx97kwed1h2TYDAtCewFDjz+A1pPUuAH/lfo3dMVhvhw4TJuS/nBbKyioINg
         j6uFVqFDg8cd/iRfoNmC5TKG6lJpXPTZZapOh7GNxQDeIcvYCURtyMoD8NkjY0LCaBHK
         1+woBjiyw5H/r+SR/4j56/clo2iyPjidb3D2IR02hNRyvTkg6pS6EW9ZmuKKJAoBuGji
         xYXrH1mvI5fn9kELhX7Rmbixan/slt0NYgxPte5MhaVPDFxkOa9rVzFgbI37jaw7hqVP
         uYAA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1733332979; x=1733937779;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=2VznSQpWwqyyoWSCkKyMSe9FismvnJKrDHHL+sPjQaA=;
        b=rozGZKqpGAve3UsDhBKG426PDI+w0g+IqetAQrXil3Qy1J6P1PZg9dbYbIGm3On71c
         Yv7xUahqc/SOHkpqAaN48xYELMmNd/mWeuRzRzvAHrlvr9Hs0bJJwwZYetGFqwNm68NJ
         iBf+6DsbJaP2nMv8SNjNMv6+Db3RCIVXhoahpAzj1KfFigeVaJIQC6zxIUPGmvK/m8RM
         0IHrcFnfx+cyINBd5UcLkJzrZTcm1Gjcw/OdcCFJh/Deinn778/wJ5W1xSMgHTHhITzO
         A341C4CeDXFiY1a088mKHcXF6RVj8S/3gAEhV3ZWfRNUJYOkT0NWuZJjVNugtl3FbPVE
         3D+w==
X-Gm-Message-State: AOJu0YwTInomVSbNP/oNN0VO6ZGru80WvjTiw49aa76SQ5TzWlVSgtax
	B/e8ek2D0MvDmsleZG5NrPp9a+Pw3GKh2CLAWSWZ6dMVjIxmfy2zY17JQfk2O4epo1bzH6FmNlT
	l
X-Gm-Gg: ASbGncuhbMB1utEr+6BsnGVodnR1RFsqoiMaTunLcmNcC+vj74os0IsioEkceL5Z1Eg
	CneizePHKXkrhpYMQ8Si8qXcfE0EZlcmTj116ksbh4t+UcYahbakkWNBiH1fsuy3+hT5prEIUzX
	ZycKl/n0F2DP/bvO0LWnBsfrcoiMxWRAI+8wZRHp2VtaUFECXp+cgoL0J8nfuxxFIdauMcbIe1Y
	64qq9cb173Pv/I+kAirhkF68jWDq55m6Q==
X-Google-Smtp-Source: AGHT+IEYZB2vCFuL7ZbQFmggnrjBxbbYL45SNh5yqfMSBWNINZX4pOWFcZW8ol1Bys8QeuJPGdAFuA==
X-Received: by 2002:a05:6a00:3c96:b0:725:9ac3:f35 with SMTP id d2e1a72fcca58-7259ac31291mr1468948b3a.4.1733332978687;
        Wed, 04 Dec 2024 09:22:58 -0800 (PST)
Received: from localhost ([2a03:2880:ff:e::])
        by smtp.gmail.com with ESMTPSA id d2e1a72fcca58-72541762c0csm12633993b3a.33.2024.12.04.09.22.58
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 04 Dec 2024 09:22:58 -0800 (PST)
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
Subject: [PATCH net-next v8 13/17] io_uring/zcrx: set pp memory provider for an rx queue
Date: Wed,  4 Dec 2024 09:21:52 -0800
Message-ID: <20241204172204.4180482-14-dw@davidwei.uk>
X-Mailer: git-send-email 2.43.5
In-Reply-To: <20241204172204.4180482-1-dw@davidwei.uk>
References: <20241204172204.4180482-1-dw@davidwei.uk>
Precedence: bulk
X-Mailing-List: io-uring@vger.kernel.org
List-Id: <io-uring.vger.kernel.org>
List-Subscribe: <mailto:io-uring+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:io-uring+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

From: David Wei <davidhwei@meta.com>

Set the page pool memory provider for the rx queue configured for zero
copy to io_uring. Then the rx queue is reset using
netdev_rx_queue_restart() and netdev core + page pool will take care of
filling the rx queue from the io_uring zero copy memory provider.

For now, there is only one ifq so its destruction happens implicitly
during io_uring cleanup.

Reviewed-by: Jens Axboe <axboe@kernel.dk>
Signed-off-by: David Wei <dw@davidwei.uk>
---
 io_uring/zcrx.c | 92 +++++++++++++++++++++++++++++++++++++++++++++----
 io_uring/zcrx.h |  2 ++
 2 files changed, 87 insertions(+), 7 deletions(-)

diff --git a/io_uring/zcrx.c b/io_uring/zcrx.c
index 004730d16e8f..0cba433c764a 100644
--- a/io_uring/zcrx.c
+++ b/io_uring/zcrx.c
@@ -8,6 +8,7 @@
 #include <net/page_pool/helpers.h>
 #include <net/page_pool/memory_provider.h>
 #include <trace/events/page_pool.h>
+#include <net/netdev_rx_queue.h>
 #include <net/tcp.h>
 #include <net/rps.h>
 
@@ -36,6 +37,65 @@ static inline struct io_zcrx_area *io_zcrx_iov_to_area(const struct net_iov *nio
 	return container_of(owner, struct io_zcrx_area, nia);
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
@@ -161,9 +221,12 @@ static struct io_zcrx_ifq *io_zcrx_ifq_alloc(struct io_ring_ctx *ctx)
 
 static void io_zcrx_ifq_free(struct io_zcrx_ifq *ifq)
 {
+	io_close_zc_rxq(ifq);
+
 	if (ifq->area)
 		io_zcrx_free_area(ifq->area);
-
+	if (ifq->dev)
+		netdev_put(ifq->dev, &ifq->netdev_tracker);
 	io_free_rbuf_ring(ifq);
 	kfree(ifq);
 }
@@ -222,7 +285,18 @@ int io_register_zcrx_ifq(struct io_ring_ctx *ctx,
 		goto err;
 
 	ifq->rq_entries = reg.rq_entries;
-	ifq->if_rxq = reg.if_rxq;
+
+	ret = -ENODEV;
+	rtnl_lock();
+	ifq->dev = netdev_get_by_index(current->nsproxy->net_ns, reg.if_idx,
+				       &ifq->netdev_tracker, GFP_KERNEL);
+	if (!ifq->dev)
+		goto err_rtnl_unlock;
+
+	ret = io_open_zc_rxq(ifq, reg.if_rxq);
+	if (ret)
+		goto err_rtnl_unlock;
+	rtnl_unlock();
 
 	ring_sz = sizeof(struct io_uring);
 	rqes_sz = sizeof(struct io_uring_zcrx_rqe) * ifq->rq_entries;
@@ -231,16 +305,17 @@ int io_register_zcrx_ifq(struct io_ring_ctx *ctx,
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
 	ctx->ifq = ifq;
 	return 0;
+
+err_rtnl_unlock:
+	rtnl_unlock();
 err:
 	io_zcrx_ifq_free(ifq);
 	return ret;
@@ -262,6 +337,9 @@ void io_unregister_zcrx_ifqs(struct io_ring_ctx *ctx)
 void io_shutdown_zcrx_ifqs(struct io_ring_ctx *ctx)
 {
 	lockdep_assert_held(&ctx->uring_lock);
+
+	if (ctx->ifq)
+		io_close_zc_rxq(ctx->ifq);
 }
 
 static void io_zcrx_get_buf_uref(struct net_iov *niov)
diff --git a/io_uring/zcrx.h b/io_uring/zcrx.h
index ffc3e333b4af..01a167e08c4b 100644
--- a/io_uring/zcrx.h
+++ b/io_uring/zcrx.h
@@ -5,6 +5,7 @@
 #include <linux/io_uring_types.h>
 #include <linux/socket.h>
 #include <net/page_pool/types.h>
+#include <net/net_trackers.h>
 
 #define IO_ZC_RX_UREF			0x10000
 #define IO_ZC_RX_KREF_MASK		(IO_ZC_RX_UREF - 1)
@@ -36,6 +37,7 @@ struct io_zcrx_ifq {
 	u32				if_rxq;
 
 	struct io_mapped_region		region;
+	netdevice_tracker		netdev_tracker;
 };
 
 #if defined(CONFIG_IO_URING_ZCRX)
-- 
2.43.5


