Return-Path: <io-uring+bounces-4168-lists+io-uring=lfdr.de@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [IPv6:2604:1380:45e3:2400::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 27CC99B5672
	for <lists+io-uring@lfdr.de>; Wed, 30 Oct 2024 00:07:23 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id DACFE281E7A
	for <lists+io-uring@lfdr.de>; Tue, 29 Oct 2024 23:07:21 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 0FD6020CCC4;
	Tue, 29 Oct 2024 23:06:18 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=davidwei-uk.20230601.gappssmtp.com header.i=@davidwei-uk.20230601.gappssmtp.com header.b="yWrZZ3ry"
X-Original-To: io-uring@vger.kernel.org
Received: from mail-pj1-f52.google.com (mail-pj1-f52.google.com [209.85.216.52])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E914520C46E
	for <io-uring@vger.kernel.org>; Tue, 29 Oct 2024 23:06:15 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.216.52
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1730243178; cv=none; b=b5dHFWGn7bzVloDN15y87FxQ0jQZNa6mtdVShKv51Ya7SQABtAQWmrRpbKqG/1HQG1SIk3FIxun2DvhIfHr5llq/M58yEMOrls1dEgls9nrzzgLZ5t3E2rGnMmGT/2wxs20g4XaQ3kHYDqIVMH9MI2bky9yan8ibTSBzqRiF/QE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1730243178; c=relaxed/simple;
	bh=aa+huor/6qdUs/u5/3W+OBGNv1FL/yOsPwUTTmTQnzg=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=rDPVHQIicfwcZdbp3KwE+LrRSEHo3MY6caSrTnvSEXJq/mhLaWOCuffnwVo7Rw5UnIuHbaVMBK8/hd2UrQiadd78Qpu/zEo1x1ioKEnBP29jUZ2wxZOX8d45kW/kE5d8fyIpCVFqb2gzUeAgLqM0oKgNbMPHUA/r+WDxw6SIs7Y=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=davidwei.uk; spf=none smtp.mailfrom=davidwei.uk; dkim=pass (2048-bit key) header.d=davidwei-uk.20230601.gappssmtp.com header.i=@davidwei-uk.20230601.gappssmtp.com header.b=yWrZZ3ry; arc=none smtp.client-ip=209.85.216.52
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=davidwei.uk
Authentication-Results: smtp.subspace.kernel.org; spf=none smtp.mailfrom=davidwei.uk
Received: by mail-pj1-f52.google.com with SMTP id 98e67ed59e1d1-2e2cc469c62so4348936a91.2
        for <io-uring@vger.kernel.org>; Tue, 29 Oct 2024 16:06:15 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=davidwei-uk.20230601.gappssmtp.com; s=20230601; t=1730243175; x=1730847975; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=infCm4b2+YzvgJNyI1UPPed5lAP0dKTh35zcwGfwOss=;
        b=yWrZZ3ryCZx+pHmn6jPf28UDn8yzYbefLeNj3WOkZts0ZfivviagXPeMZexFRPkCni
         CdR4LrBc0D6Ive2es0wscJawJNqKrtu/dcBlCbsUJ1FIzCE6NIOukXtaQtXx3zzbUgJw
         ID9VkJICqJcIqFnYoVehtJEdLNVlCN3DZVVFHqLcRh/GgY1VhpODAW5riwSJnIhi0vEU
         4vbEjGN86EoRNJXbUiriRoVn8d25ofs2sBJsdJSNTNyCZ7un4tNRXnk/RFF189Ob/OxV
         5qTby/bNNHhfjEu186+ncoL7eSITWErKcCet61NxtLOwFhqi+GNfATosJ75fYbKd0S/5
         NuWw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1730243175; x=1730847975;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=infCm4b2+YzvgJNyI1UPPed5lAP0dKTh35zcwGfwOss=;
        b=cZcdJEZt3zZzvJbgFM8QokxdxLduQ5b220/Lgp8EwIty6m0zbIglmH5IanPhYvLePB
         bD4hE5WSz/W1eik5fXmvLwWTlNrTYrDQJqw46BmM3GFBbjcbSGLxrbjd4kMdHqjmPZhD
         AcL/3jnaOfcBzkZBgQUf8t9LqZNh3ZZw/wX0WmJ42xrJU4f+8j/azpfqTq32dG7Zz5Qp
         HwCda0DVAmMc3Jod+d+9wkDIUcArzh//oh9waUKgRtWXh1v+MiTd2mmZVx5RVkra6vpT
         lHjpyIrTMnkYtP+JnWDMDWSpb9vHyVABWOVahQ6AWZyZTc3suDmoexCHZVvhTaL//+hZ
         27GA==
X-Gm-Message-State: AOJu0Yy+HuefbW6JhGfVYldAM8+/2sVRiKHnfFsctEHW1aFBDyzOzcCf
	8lndBkWz80a/NvKNfTLMkv9cQIySg8N0m4yd/lBSpoli0dJKC3F7WPw/NOgS9qQYtbOInhGM9Bx
	9hns=
X-Google-Smtp-Source: AGHT+IEJVa4X+2ORYvpdaPhwQ66uz+tnzb2hz+w6yMyiu/p15C29w2SW5FOpMCCswghJZWZncd3M5g==
X-Received: by 2002:a17:90b:390f:b0:2e2:b45f:53b4 with SMTP id 98e67ed59e1d1-2e8f11a027bmr14117298a91.25.1730243175383;
        Tue, 29 Oct 2024 16:06:15 -0700 (PDT)
Received: from localhost (fwdproxy-prn-005.fbsv.net. [2a03:2880:ff:5::face:b00c])
        by smtp.gmail.com with ESMTPSA id 98e67ed59e1d1-2e92fa63967sm225353a91.32.2024.10.29.16.06.14
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 29 Oct 2024 16:06:14 -0700 (PDT)
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
Subject: [PATCH v7 13/15] io_uring/zcrx: set pp memory provider for an rx queue
Date: Tue, 29 Oct 2024 16:05:16 -0700
Message-ID: <20241029230521.2385749-14-dw@davidwei.uk>
X-Mailer: git-send-email 2.43.5
In-Reply-To: <20241029230521.2385749-1-dw@davidwei.uk>
References: <20241029230521.2385749-1-dw@davidwei.uk>
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


