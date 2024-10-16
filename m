Return-Path: <io-uring+bounces-3752-lists+io-uring=lfdr.de@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from sy.mirrors.kernel.org (sy.mirrors.kernel.org [IPv6:2604:1380:40f1:3f00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 12EB79A11FF
	for <lists+io-uring@lfdr.de>; Wed, 16 Oct 2024 20:54:43 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sy.mirrors.kernel.org (Postfix) with ESMTPS id 6909AB24428
	for <lists+io-uring@lfdr.de>; Wed, 16 Oct 2024 18:54:40 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id ABB362170BC;
	Wed, 16 Oct 2024 18:53:20 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=davidwei-uk.20230601.gappssmtp.com header.i=@davidwei-uk.20230601.gappssmtp.com header.b="TkvKqhQV"
X-Original-To: io-uring@vger.kernel.org
Received: from mail-pl1-f175.google.com (mail-pl1-f175.google.com [209.85.214.175])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 35E7E20F5BA
	for <io-uring@vger.kernel.org>; Wed, 16 Oct 2024 18:53:19 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.214.175
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1729104800; cv=none; b=MuvwSmJpy9AUUcj6TBboOsjLaB/nwHJ/+3T7g+2IpAMUTNZND/lzXcmx1obJJif0OYLNIAH+aQdu9SBBJqNBdVB3Hv+mbVS0tiHzRFmbjsi1xUyhcEyoyHLxmpUujcAZu6495MKRHdatVvpbzc5OtDOOa710FpV8JR+nQKJU6MQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1729104800; c=relaxed/simple;
	bh=aa+huor/6qdUs/u5/3W+OBGNv1FL/yOsPwUTTmTQnzg=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=jqqhLzM+58yKI9xYk2F1/yiU8W6m7oAafuO2w0ZkvPh7/V+R+FgSBXWjVT4CKPu4Vnzau6OoMKuV+GxMMSNsrL3zAEW1g5kuEfNtXVaVk+xTmoyDkgr2MDwa3K0Dqi/f7QZPswuBliba8Fg2uk0hNWO70SF51Iy8FTMBKU8s9TQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=davidwei.uk; spf=none smtp.mailfrom=davidwei.uk; dkim=pass (2048-bit key) header.d=davidwei-uk.20230601.gappssmtp.com header.i=@davidwei-uk.20230601.gappssmtp.com header.b=TkvKqhQV; arc=none smtp.client-ip=209.85.214.175
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=davidwei.uk
Authentication-Results: smtp.subspace.kernel.org; spf=none smtp.mailfrom=davidwei.uk
Received: by mail-pl1-f175.google.com with SMTP id d9443c01a7336-207115e3056so1060505ad.2
        for <io-uring@vger.kernel.org>; Wed, 16 Oct 2024 11:53:19 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=davidwei-uk.20230601.gappssmtp.com; s=20230601; t=1729104798; x=1729709598; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=infCm4b2+YzvgJNyI1UPPed5lAP0dKTh35zcwGfwOss=;
        b=TkvKqhQVzFRosqDZl+x08qAk7m3eph9yB/SpqinAcuA17jQHIER8aMTZe5+kIOC/5K
         OqWbx9uFLIn15aCw8KwjSVDES+LI2Vj5Ei89aIq0dlTTAvN1AoHVByQXF4GHeBHGbjZg
         d2JQqsMKNQpxoj0oeF5K37Leq+07IbfOR1+r/SRbQrFouOx4IMQRhE03ZyAwLkCKKVmC
         kOFwSQgWxXDq6AhWhlviYc/AJ1OhGu4XI+OaX/blG44pNDT0OFt+NBQL/x0fwSjVTpVS
         D33oWn0xHGufgXbwgvsDt1OV5+TLftIuw12resqasQx6WUyc13fEvlOqv04f7EajRmfF
         heVQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1729104798; x=1729709598;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=infCm4b2+YzvgJNyI1UPPed5lAP0dKTh35zcwGfwOss=;
        b=MGUUoX2KaScQyeR1z7a9RvdbDaqOFhs6w6Tq7oHa9+RrtjsWFR7u47GfcHEN3UArCd
         1QuJBPT31ZxAW841rjDyPx1e+YW6v0Dc2jEDaWJ17o4uIHIchtfwrvh4Yk91ERsE7Z/L
         Ge1zy3dSGb9FYHqs/ZNuPwJz8joqJ7mZhHRkbVPn5wY9B7SxtcCENrXQn9NcxGx694uT
         lXeL4lIiQU+NyOVbq1KwZ6OS+vzI0XBwOf6ykW3mjbsWH8HHYO6B1pVGew73682LgGT1
         yXova21ErUT881g3RZqQjM/Qs5hilw0UT/QpvYZYLpeBp7ZrODQ0UxnemQZegAPBrkSv
         VqmQ==
X-Gm-Message-State: AOJu0YwciqN4areEInE0xPUY3hVtoFi5cdzySlOFCfdWZ+SfrMdbR/aF
	4kSaAKdi2Qo8rD7ME53cCzFpqxZjQtI3GvOtCh1zJeAlmjKheOZxMHaq+fSBi77z8+d7DiXVsga
	l
X-Google-Smtp-Source: AGHT+IGkNe9K9cBR5SbFKWb0dgia9tqwF0W7vBE2efKajMt672mzsefOWdsyqZtZEToIi9SbmxMkew==
X-Received: by 2002:a17:903:1cd:b0:20c:7a0b:74a5 with SMTP id d9443c01a7336-20d27f1c789mr72724885ad.39.1729104798616;
        Wed, 16 Oct 2024 11:53:18 -0700 (PDT)
Received: from localhost (fwdproxy-prn-115.fbsv.net. [2a03:2880:ff:73::face:b00c])
        by smtp.gmail.com with ESMTPSA id d9443c01a7336-20d17f9da9dsm31920695ad.111.2024.10.16.11.53.17
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 16 Oct 2024 11:53:18 -0700 (PDT)
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
	Mina Almasry <almasrymina@google.com>,
	Stanislav Fomichev <stfomichev@gmail.com>,
	Joe Damato <jdamato@fastly.com>,
	Pedro Tammela <pctammela@mojatatu.com>
Subject: [PATCH v6 13/15] io_uring/zcrx: set pp memory provider for an rx queue
Date: Wed, 16 Oct 2024 11:52:50 -0700
Message-ID: <20241016185252.3746190-14-dw@davidwei.uk>
X-Mailer: git-send-email 2.43.5
In-Reply-To: <20241016185252.3746190-1-dw@davidwei.uk>
References: <20241016185252.3746190-1-dw@davidwei.uk>
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

Signed-off-by: David Wei <dw@davidwei.uk>
---
 io_uring/zcrx.c | 86 +++++++++++++++++++++++++++++++++++++++++++++++--
 io_uring/zcrx.h |  2 ++
 2 files changed, 86 insertions(+), 2 deletions(-)

diff --git a/io_uring/zcrx.c b/io_uring/zcrx.c
index 477b0d1b7b91..3f4625730dbd 100644
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
 				 struct io_uring_zcrx_ifq_reg *reg)
 {
@@ -156,9 +216,12 @@ static struct io_zcrx_ifq *io_zcrx_ifq_alloc(struct io_ring_ctx *ctx)
 
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
@@ -214,7 +277,18 @@ int io_register_zcrx_ifq(struct io_ring_ctx *ctx,
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
@@ -224,15 +298,20 @@ int io_register_zcrx_ifq(struct io_ring_ctx *ctx,
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
@@ -254,6 +333,9 @@ void io_unregister_zcrx_ifqs(struct io_ring_ctx *ctx)
 void io_shutdown_zcrx_ifqs(struct io_ring_ctx *ctx)
 {
 	lockdep_assert_held(&ctx->uring_lock);
+
+	if (ctx->ifq)
+		io_close_zc_rxq(ctx->ifq);
 }
 
 static void io_zcrx_get_buf_uref(struct net_iov *niov)
diff --git a/io_uring/zcrx.h b/io_uring/zcrx.h
index 1f039ad45a63..d3f6b6cdd647 100644
--- a/io_uring/zcrx.h
+++ b/io_uring/zcrx.h
@@ -5,6 +5,7 @@
 #include <linux/io_uring_types.h>
 #include <linux/socket.h>
 #include <net/page_pool/types.h>
+#include <net/net_trackers.h>
 
 #define IO_ZC_RX_UREF			0x10000
 #define IO_ZC_RX_KREF_MASK		(IO_ZC_RX_UREF - 1)
@@ -37,6 +38,7 @@ struct io_zcrx_ifq {
 	struct page			**rqe_pages;
 
 	u32				if_rxq;
+	netdevice_tracker		netdev_tracker;
 };
 
 #if defined(CONFIG_IO_URING_ZCRX)
-- 
2.43.5


