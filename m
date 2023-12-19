Return-Path: <io-uring+bounces-309-lists+io-uring=lfdr.de@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [IPv6:2604:1380:4601:e00::3])
	by mail.lfdr.de (Postfix) with ESMTPS id AA1858191F6
	for <lists+io-uring@lfdr.de>; Tue, 19 Dec 2023 22:05:07 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id 499271F24075
	for <lists+io-uring@lfdr.de>; Tue, 19 Dec 2023 21:05:07 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id DE4FD3B18E;
	Tue, 19 Dec 2023 21:04:17 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=davidwei-uk.20230601.gappssmtp.com header.i=@davidwei-uk.20230601.gappssmtp.com header.b="gQnYYc+4"
X-Original-To: io-uring@vger.kernel.org
Received: from mail-pj1-f53.google.com (mail-pj1-f53.google.com [209.85.216.53])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 680733D0C6
	for <io-uring@vger.kernel.org>; Tue, 19 Dec 2023 21:04:15 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=davidwei.uk
Authentication-Results: smtp.subspace.kernel.org; spf=none smtp.mailfrom=davidwei.uk
Received: by mail-pj1-f53.google.com with SMTP id 98e67ed59e1d1-28bd09e35e8so73272a91.0
        for <io-uring@vger.kernel.org>; Tue, 19 Dec 2023 13:04:15 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=davidwei-uk.20230601.gappssmtp.com; s=20230601; t=1703019854; x=1703624654; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=wAMvX5PF2J42C1cn2NekqDrZ68M45niiPpeKzGsshQo=;
        b=gQnYYc+4cUb/LyvXOAYXV4CcWCkXGxnl1WiRbq+UPsXTpqZhsq3ebvzMqkHRlvHdXG
         CLGIPmwqIN0hCAHiYhYI+GoDZMfRyfO2IEqSvLktGi1NYoyBnD8AviV1J7iKGN5aTWMr
         9iJNSzzaOiJnC1BJuFDYezq88uHMftcv/ERbai4AO1KE8zz9bni9ni9vuToxqw2824cz
         Z9sM9Vqk5fD5J1sHLTq9iVCu8t0VhM1Gwsyu/JB9+9KLUgC/YVfudx4hdjr50OYuQoki
         kwVcIuP6tnBNmeW03YEeXH8qhq7JuhTTdglim1i1JJWXNQxUN8NV6JkneykYm2DAefG0
         Akyg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1703019854; x=1703624654;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=wAMvX5PF2J42C1cn2NekqDrZ68M45niiPpeKzGsshQo=;
        b=oa4UciaFaM6idrjgfDISnbgb/yefk4Bobmz+RWmMjfQsLk/37bN+aQsZ4ZrV8ehkaE
         ZGhv7Il5deBepQykVy2nAIlxMWWLlIOvO0GamlJ+KTlQ2PGjSh+9n35IKPxi/uF94XVp
         vRIr1CqO3kkH13VA/CDVeMFW9hQDyg5Q1hkgQlivTCTWY//2qtgAlwreQ9YqRdZ1dBMH
         Ez5fw411+8lLzzN1suh6qygzXTFZbvmKUqKH4Tw+B77qWwN4bXFYkA1Bh03nfgaFKfAZ
         zhIxZk43mkvjGVooiQdXp2rdTis9XmgvgJE6MB/cUu7SOS1ANdtjuL0I0PzErU4mFtF/
         olnQ==
X-Gm-Message-State: AOJu0YxxzjUhjoPAy7P2NOY4tDGz2PAhzghlbJTyJ66Qo1sCSSWiP3E6
	LA8wFmeSRxpB0In5v2qeju8CmuPQFOm/f9bhT+PLlQ==
X-Google-Smtp-Source: AGHT+IHoQAQ/k1SxzwciIcmi+jcQ+upozI8wcoH4KzgZpCsiXfMS4tOsd7N3uxiOUng9G36LVHu5GQ==
X-Received: by 2002:a17:90b:120d:b0:28b:a3bf:8aaa with SMTP id gl13-20020a17090b120d00b0028ba3bf8aaamr1684113pjb.53.1703019854284;
        Tue, 19 Dec 2023 13:04:14 -0800 (PST)
Received: from localhost (fwdproxy-prn-000.fbsv.net. [2a03:2880:ff::face:b00c])
        by smtp.gmail.com with ESMTPSA id k9-20020a170902c40900b001d0969c5b68sm21470889plk.139.2023.12.19.13.04.13
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 19 Dec 2023 13:04:14 -0800 (PST)
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
	Mina Almasry <almasrymina@google.com>
Subject: [RFC PATCH v3 10/20] io_uring: setup ZC for an Rx queue when registering an ifq
Date: Tue, 19 Dec 2023 13:03:47 -0800
Message-Id: <20231219210357.4029713-11-dw@davidwei.uk>
X-Mailer: git-send-email 2.39.3
In-Reply-To: <20231219210357.4029713-1-dw@davidwei.uk>
References: <20231219210357.4029713-1-dw@davidwei.uk>
Precedence: bulk
X-Mailing-List: io-uring@vger.kernel.org
List-Id: <io-uring.vger.kernel.org>
List-Subscribe: <mailto:io-uring+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:io-uring+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

From: David Wei <davidhwei@meta.com>

This patch sets up ZC for an Rx queue in a net device when an ifq is
registered with io_uring. The Rx queue is specified in the registration
struct.

For now since there is only one ifq, its destruction is implicit during
io_uring cleanup.

Signed-off-by: David Wei <dw@davidwei.uk>
---
 io_uring/zc_rx.c | 45 +++++++++++++++++++++++++++++++++++++++++++--
 1 file changed, 43 insertions(+), 2 deletions(-)

diff --git a/io_uring/zc_rx.c b/io_uring/zc_rx.c
index 7e3e6f6d446b..259e08a34ab2 100644
--- a/io_uring/zc_rx.c
+++ b/io_uring/zc_rx.c
@@ -4,6 +4,7 @@
 #include <linux/errno.h>
 #include <linux/mm.h>
 #include <linux/io_uring.h>
+#include <linux/netdevice.h>
 
 #include <uapi/linux/io_uring.h>
 
@@ -11,6 +12,34 @@
 #include "kbuf.h"
 #include "zc_rx.h"
 
+typedef int (*bpf_op_t)(struct net_device *dev, struct netdev_bpf *bpf);
+
+static int __io_queue_mgmt(struct net_device *dev, struct io_zc_rx_ifq *ifq,
+			   u16 queue_id)
+{
+	struct netdev_bpf cmd;
+	bpf_op_t ndo_bpf;
+
+	ndo_bpf = dev->netdev_ops->ndo_bpf;
+	if (!ndo_bpf)
+		return -EINVAL;
+
+	cmd.command = XDP_SETUP_ZC_RX;
+	cmd.zc_rx.ifq = ifq;
+	cmd.zc_rx.queue_id = queue_id;
+	return ndo_bpf(dev, &cmd);
+}
+
+static int io_open_zc_rxq(struct io_zc_rx_ifq *ifq)
+{
+	return __io_queue_mgmt(ifq->dev, ifq, ifq->if_rxq_id);
+}
+
+static int io_close_zc_rxq(struct io_zc_rx_ifq *ifq)
+{
+	return __io_queue_mgmt(ifq->dev, NULL, ifq->if_rxq_id);
+}
+
 static int io_allocate_rbuf_ring(struct io_zc_rx_ifq *ifq,
 				 struct io_uring_zc_rx_ifq_reg *reg)
 {
@@ -52,6 +81,10 @@ static struct io_zc_rx_ifq *io_zc_rx_ifq_alloc(struct io_ring_ctx *ctx)
 
 static void io_zc_rx_ifq_free(struct io_zc_rx_ifq *ifq)
 {
+	if (ifq->if_rxq_id != -1)
+		io_close_zc_rxq(ifq);
+	if (ifq->dev)
+		dev_put(ifq->dev);
 	io_free_rbuf_ring(ifq);
 	kfree(ifq);
 }
@@ -77,18 +110,25 @@ int io_register_zc_rx_ifq(struct io_ring_ctx *ctx,
 	if (!ifq)
 		return -ENOMEM;
 
-	/* TODO: initialise network interface */
-
 	ret = io_allocate_rbuf_ring(ifq, &reg);
 	if (ret)
 		goto err;
 
+	ret = -ENODEV;
+	ifq->dev = dev_get_by_index(current->nsproxy->net_ns, reg.if_idx);
+	if (!ifq->dev)
+		goto err;
+
 	/* TODO: map zc region and initialise zc pool */
 
 	ifq->rq_entries = reg.rq_entries;
 	ifq->cq_entries = reg.cq_entries;
 	ifq->if_rxq_id = reg.if_rxq_id;
 
+	ret = io_open_zc_rxq(ifq);
+	if (ret)
+		goto err;
+
 	ring_sz = sizeof(struct io_rbuf_ring);
 	rqes_sz = sizeof(struct io_uring_rbuf_rqe) * ifq->rq_entries;
 	cqes_sz = sizeof(struct io_uring_rbuf_cqe) * ifq->cq_entries;
@@ -101,6 +141,7 @@ int io_register_zc_rx_ifq(struct io_ring_ctx *ctx,
 	reg.cq_off.tail = offsetof(struct io_rbuf_ring, cq.tail);
 
 	if (copy_to_user(arg, &reg, sizeof(reg))) {
+		io_close_zc_rxq(ifq);
 		ret = -EFAULT;
 		goto err;
 	}
-- 
2.39.3


