Return-Path: <io-uring+bounces-55-lists+io-uring=lfdr.de@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [147.75.199.223])
	by mail.lfdr.de (Postfix) with ESMTPS id D7FB67E4AE0
	for <lists+io-uring@lfdr.de>; Tue,  7 Nov 2023 22:41:27 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id 06F521C20A1B
	for <lists+io-uring@lfdr.de>; Tue,  7 Nov 2023 21:41:27 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id C5A4F2A8F8;
	Tue,  7 Nov 2023 21:41:04 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=davidwei-uk.20230601.gappssmtp.com header.i=@davidwei-uk.20230601.gappssmtp.com header.b="w1Ymep9N"
X-Original-To: io-uring@vger.kernel.org
Received: from lindbergh.monkeyblade.net (lindbergh.monkeyblade.net [23.128.96.19])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0185C2A8C5
	for <io-uring@vger.kernel.org>; Tue,  7 Nov 2023 21:41:01 +0000 (UTC)
Received: from mail-oo1-xc30.google.com (mail-oo1-xc30.google.com [IPv6:2607:f8b0:4864:20::c30])
	by lindbergh.monkeyblade.net (Postfix) with ESMTPS id E4F1510E9
	for <io-uring@vger.kernel.org>; Tue,  7 Nov 2023 13:41:00 -0800 (PST)
Received: by mail-oo1-xc30.google.com with SMTP id 006d021491bc7-581e5a9413bso3409662eaf.1
        for <io-uring@vger.kernel.org>; Tue, 07 Nov 2023 13:41:00 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=davidwei-uk.20230601.gappssmtp.com; s=20230601; t=1699393260; x=1699998060; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=1JQFVyD/BclnABaNMr0ihb/yu9Na0XwqUKf71Hw/JqE=;
        b=w1Ymep9NNgfB4ODycMNp//P+6E1bB3ih2At9wJKsln4ltVh6coE6wN//o76LjdMn/q
         8hQ8MLGtUtA4R1ITttsoInVJFvRk/3PKjSA1Vi4opRQjRdeeO5RdRgAMB/Z62YMsmu/7
         QFMIMfg+kB84wpnubMp3xCBCRZaBStabibeIIP3VwdJHKJIM+nrV5dE2sp/yY2FCU9cT
         +hby7KwCIPsYNaXrGTdai12MLYmmXfNSfeNJ3i0EnJH9WQilAiohoQCc73RsmQOmmxAe
         f73FbEl0iLbCHF6UiVDTpcBIH6K+tf3O8FPp/AV8kHiGviMayZoidfVFJWNHpRTXMROV
         SwxA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1699393260; x=1699998060;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=1JQFVyD/BclnABaNMr0ihb/yu9Na0XwqUKf71Hw/JqE=;
        b=JHR/mecfmcmA/PbU8zbWN/lSdTf1ISpexGpymhne0mjL2JMjdiiksngPSTnO+aE82j
         37rM69gt+fZzmBJKk43d0h3iyExPOiJzYMNM0ek98aV3KTu+WDPY4IOTf/i18wHoCm7X
         py51qbLA2PV5o4kfluMNvLnrvlV7OcCcV8BsjSlQdgK79vcANsVqeOZGuI9FT9oth+IM
         ZN8N4VIAEhk0Ckz399JWzB0vOh1DHqXsULozysPBBbQ+hto7Z0wLZbdKXdWyNCXSZqDX
         kAUAu24EOzwERHjRdfdTRZiWSBHlX/Jbb5vrEiCMsYbDGsVyrh+hDb6VyVdX4oFCJEPT
         JIdQ==
X-Gm-Message-State: AOJu0YxbOtQCbIbIuVqEI4pzxDZ8YQsY4qellda7I9J7wIF+mTJy/p8t
	KNqijaNeE0ACHRL32093ArXLiuqtQ82PRG2T3g4GFQ==
X-Google-Smtp-Source: AGHT+IFWdyvIluXwiwCF4cLhWlh9UcUzd1F1iP7kvHIF5igbTDAVoRK1o58ujXZe6zX4hW3DRWIEGw==
X-Received: by 2002:a05:6358:1904:b0:168:e0db:ce43 with SMTP id w4-20020a056358190400b00168e0dbce43mr33357692rwm.31.1699393260074;
        Tue, 07 Nov 2023 13:41:00 -0800 (PST)
Received: from localhost (fwdproxy-prn-012.fbsv.net. [2a03:2880:ff:c::face:b00c])
        by smtp.gmail.com with ESMTPSA id j26-20020a63595a000000b0058ac101ad83sm1822698pgm.33.2023.11.07.13.40.59
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 07 Nov 2023 13:40:59 -0800 (PST)
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
	Willem de Bruijn <willemdebruijn.kernel@gmail.com>,
	Dragos Tatulea <dtatulea@nvidia.com>
Subject: [PATCH 04/20] io_uring: setup ZC for an Rx queue when registering an ifq
Date: Tue,  7 Nov 2023 13:40:29 -0800
Message-Id: <20231107214045.2172393-5-dw@davidwei.uk>
X-Mailer: git-send-email 2.39.3
In-Reply-To: <20231107214045.2172393-1-dw@davidwei.uk>
References: <20231107214045.2172393-1-dw@davidwei.uk>
Precedence: bulk
X-Mailing-List: io-uring@vger.kernel.org
List-Id: <io-uring.vger.kernel.org>
List-Subscribe: <mailto:io-uring+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:io-uring+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

This patch sets up ZC for an Rx queue in a net device when an ifq is
registered with io_uring. The Rx queue is specified in the registration
struct. The XDP command added in the previous patch is used to enable or
disable ZC Rx.

For now since there is only one ifq, its destruction is implicit during
io_uring cleanup.

Co-developed-by: Pavel Begunkov <asml.silence@gmail.com>
Signed-off-by: Pavel Begunkov <asml.silence@gmail.com>
Signed-off-by: David Wei <dw@davidwei.uk>
---
 io_uring/zc_rx.c | 48 ++++++++++++++++++++++++++++++++++++++++++++++--
 1 file changed, 46 insertions(+), 2 deletions(-)

diff --git a/io_uring/zc_rx.c b/io_uring/zc_rx.c
index a3a54845c712..85180c3044d8 100644
--- a/io_uring/zc_rx.c
+++ b/io_uring/zc_rx.c
@@ -4,6 +4,7 @@
 #include <linux/errno.h>
 #include <linux/mm.h>
 #include <linux/io_uring.h>
+#include <linux/netdevice.h>
 
 #include <uapi/linux/io_uring.h>
 
@@ -11,6 +12,35 @@
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
+
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
 static struct io_zc_rx_ifq *io_zc_rx_ifq_alloc(struct io_ring_ctx *ctx)
 {
 	struct io_zc_rx_ifq *ifq;
@@ -20,12 +50,17 @@ static struct io_zc_rx_ifq *io_zc_rx_ifq_alloc(struct io_ring_ctx *ctx)
 		return NULL;
 
 	ifq->ctx = ctx;
+	ifq->if_rxq_id = -1;
 
 	return ifq;
 }
 
 static void io_zc_rx_ifq_free(struct io_zc_rx_ifq *ifq)
 {
+	if (ifq->if_rxq_id != -1)
+		io_close_zc_rxq(ifq);
+	if (ifq->dev)
+		dev_put(ifq->dev);
 	io_free_rbuf_ring(ifq);
 	kfree(ifq);
 }
@@ -42,17 +77,22 @@ int io_register_zc_rx_ifq(struct io_ring_ctx *ctx,
 		return -EFAULT;
 	if (ctx->ifq)
 		return -EBUSY;
+	if (reg.if_rxq_id == -1)
+		return -EINVAL;
 
 	ifq = io_zc_rx_ifq_alloc(ctx);
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
@@ -60,6 +100,10 @@ int io_register_zc_rx_ifq(struct io_ring_ctx *ctx,
 	ifq->if_rxq_id = reg.if_rxq_id;
 	ctx->ifq = ifq;
 
+	ret = io_open_zc_rxq(ifq);
+	if (ret)
+		goto err;
+
 	ring_sz = sizeof(struct io_rbuf_ring);
 	rqes_sz = sizeof(struct io_uring_rbuf_rqe) * ifq->rq_entries;
 	cqes_sz = sizeof(struct io_uring_rbuf_cqe) * ifq->cq_entries;
-- 
2.39.3


