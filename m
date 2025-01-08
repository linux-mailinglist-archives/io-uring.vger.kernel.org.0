Return-Path: <io-uring+bounces-5773-lists+io-uring=lfdr.de@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [IPv6:2604:1380:45d1:ec00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 8DFF6A067EF
	for <lists+io-uring@lfdr.de>; Wed,  8 Jan 2025 23:09:21 +0100 (CET)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id EB723167F1A
	for <lists+io-uring@lfdr.de>; Wed,  8 Jan 2025 22:09:06 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 41FF0205ACB;
	Wed,  8 Jan 2025 22:07:29 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=davidwei-uk.20230601.gappssmtp.com header.i=@davidwei-uk.20230601.gappssmtp.com header.b="FGbuWMhZ"
X-Original-To: io-uring@vger.kernel.org
Received: from mail-pj1-f45.google.com (mail-pj1-f45.google.com [209.85.216.45])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A8C5D205AB9
	for <io-uring@vger.kernel.org>; Wed,  8 Jan 2025 22:07:26 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.216.45
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1736374049; cv=none; b=sOnycYmWxUAbAr6cjFnU7o3W1ywlsrGJR1y61pmU7n3xHCRt0Gh1jzouvVBg/jGKnnwkOqVJBdOHvh1Wpp535xFg6gAICa1EEuVa/1vl/pFIYRt7uH5Q9Zf9rLliZHZjUpDwxxcBqg0xR7xxVZdSSCOucQLW1PKpuI9aLzwpYhw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1736374049; c=relaxed/simple;
	bh=6Bqn2WlGC/QyLXjHkwEt96grEpG1mYxHhlF1Chcw+Es=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=O9YMI5NhRZCneHjFe3To+4/hFzMxdkhu6oQTq51d7oB5iV56v+tem1lka2eUkAZ7rEVTy8lG+XtC+3G2Vk4HwAg3k/O6qtjJBqsY5SfumZ5peFkBo3dJZnPbjSwSbq9b6ijAMD4wi5RDFKF5RWbnUaBNxnlAps2P31WVQkRCXPI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=davidwei.uk; spf=none smtp.mailfrom=davidwei.uk; dkim=pass (2048-bit key) header.d=davidwei-uk.20230601.gappssmtp.com header.i=@davidwei-uk.20230601.gappssmtp.com header.b=FGbuWMhZ; arc=none smtp.client-ip=209.85.216.45
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=davidwei.uk
Authentication-Results: smtp.subspace.kernel.org; spf=none smtp.mailfrom=davidwei.uk
Received: by mail-pj1-f45.google.com with SMTP id 98e67ed59e1d1-2ee86a1a92dso414935a91.1
        for <io-uring@vger.kernel.org>; Wed, 08 Jan 2025 14:07:26 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=davidwei-uk.20230601.gappssmtp.com; s=20230601; t=1736374046; x=1736978846; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=PgGQEoJLO7hhZFXH7kddctHl5vKUc6YtY/qUSu41pew=;
        b=FGbuWMhZ8EFCbz0wfB0zosrHX5b0E7KeOA7UfbnL7Fuwk41Frk97q+KPsoPyLuMNkk
         unloXQFz8Er/qWjlsYgo2KDuSMQdEh7ikiEY+maTVz5zIV0vaYyTnlYTIg+0Y0oodFHM
         9ua987mZlIBH8B3IfPJ40sj/H+3x7sd+N1DCsj4BwFVRGt1nvD8jiKBPczjpwoVYnYLO
         s4zPlDwANBbGFIKaFKLQ4oNfeCELurVvaVoarogq8nzNS+gb7I2+I4L/ccfeR0glF8lO
         6gzl+Qusvp0tAmUFrTCiyhh/jTUP/KZ5/6KLBJOcOwVcx01ff2majRVeT4reUJeR7QWi
         l9qg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1736374046; x=1736978846;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=PgGQEoJLO7hhZFXH7kddctHl5vKUc6YtY/qUSu41pew=;
        b=lkD6w4iPPxZs+2tZ6Mtsf0zEPv+bFSXydqv6NEVZsKoUdsYEnc0Q6q2Ow+SkSUynR6
         S55hcHBr4HSLu1VUqLQN+xaGuF1Lm+1xau950nNbtIlkhxQc+xdj1WHmMcJYptWy7uwa
         YQvY+yAz1mHb8b+PXazlsYNAiZTQTaCKuE2IDDdykmETzVXYMbt6PiQCJWpRlzNfDq2D
         NgbFkXtxAsdmtqU/DTCeusIomIRR3cd4T1tRdbhcBMyr5B4GzF87irgMpmIx1xQmFSh0
         /bJ25u1mCJmqTuJMMV0ex7ZzHOuQB3aSQD7Qt/44yYhE3H3OpLe/iegziF2+lvh+9Fvs
         nwAw==
X-Gm-Message-State: AOJu0YwpmneZTYzV8eyUN+kZw77eioASyrWXIwLwA0inu+Ua+M15l+qp
	gEJ2wE1PMVjSZn/y3z4kzxSX2Hs5yMj2YhPSJPKFMe5Z+KxLRX9mD4ZrXBl0G0G/MwKhLmKhsxA
	l
X-Gm-Gg: ASbGncuJbskEOpodiHkp96FKgkOeiGRmS22zETK9r2pB2kvrc9IJbhnlEoQBMDM5cdm
	GPo8q2epSVgXC9czauDKJkN053uINuuw4B+dqE3NBNUroQpFIvYrtdgLYUwSBAGBFW1crKbw2s1
	EgzCIECzXMFqlrDmy7KXxP5sRZaRfOEiaj/ToX9to798RgsqHg+U/O0dQ/jh6QhEcUzmdBLGwQ6
	8JbOjcozeTPuG6dHzFDsEberV5Jtz5aDwoVzJ4WTA==
X-Google-Smtp-Source: AGHT+IF3DPLBKCj1BgtTvQaQMgpAUunD+hMtH5A7pos3phLAMFWyYcaHc7D2A8IIuO3on97HbSrMew==
X-Received: by 2002:a17:90a:e18c:b0:2ee:d797:408b with SMTP id 98e67ed59e1d1-2f548e98537mr6484711a91.2.1736374046028;
        Wed, 08 Jan 2025 14:07:26 -0800 (PST)
Received: from localhost ([2a03:2880:ff:1d::])
        by smtp.gmail.com with ESMTPSA id d9443c01a7336-219dc962d9esm335194945ad.17.2025.01.08.14.07.25
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 08 Jan 2025 14:07:25 -0800 (PST)
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
Subject: [PATCH net-next v10 18/22] io_uring/zcrx: set pp memory provider for an rx queue
Date: Wed,  8 Jan 2025 14:06:39 -0800
Message-ID: <20250108220644.3528845-19-dw@davidwei.uk>
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
index 036de2981e64..caaec528cc3c 100644
--- a/io_uring/zcrx.c
+++ b/io_uring/zcrx.c
@@ -11,11 +11,12 @@
 #include <net/page_pool/helpers.h>
 #include <net/page_pool/memory_provider.h>
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
@@ -139,6 +140,65 @@ static void io_zcrx_get_niov_uref(struct net_iov *niov)
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
@@ -275,6 +335,8 @@ static struct io_zcrx_ifq *io_zcrx_ifq_alloc(struct io_ring_ctx *ctx)
 
 static void io_zcrx_ifq_free(struct io_zcrx_ifq *ifq)
 {
+	io_close_zc_rxq(ifq);
+
 	if (ifq->area)
 		io_zcrx_free_area(ifq->area);
 
@@ -337,7 +399,6 @@ int io_register_zcrx_ifq(struct io_ring_ctx *ctx,
 		goto err;
 
 	ifq->rq_entries = reg.rq_entries;
-	ifq->if_rxq = reg.if_rxq;
 
 	ret = -ENODEV;
 	ifq->dev = netdev_get_by_index(current->nsproxy->net_ns, reg.if_idx,
@@ -349,16 +410,20 @@ int io_register_zcrx_ifq(struct io_ring_ctx *ctx,
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
@@ -435,6 +500,8 @@ void io_shutdown_zcrx_ifqs(struct io_ring_ctx *ctx)
 
 	if (ctx->ifq)
 		io_zcrx_scrub(ctx->ifq);
+
+	io_close_zc_rxq(ctx->ifq);
 }
 
 static inline u32 io_zcrx_rqring_entries(struct io_zcrx_ifq *ifq)
-- 
2.43.5


